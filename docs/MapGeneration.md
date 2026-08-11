# HD 地图生成流程

这份文档解释 `Maps/` 下的代码在一局游戏开始时**按什么顺序、依据什么逻辑**把一张地图造出来。
面向想改地图脚本、或者想搞清楚"为什么我的出生点长这样"的人。

不需要先读代码。涉及具体实现的地方会给出文件和行号。

---

## 0. 一句话总览

点"开始游戏"之后，引擎新建一个 Lua 状态机，加载**一个**地图脚本（比如 `Continents.lua`），
调用它的全局函数 `GenerateMap()`，然后这个函数从头到尾跑完 15 个步骤，地图就定型了。
之后引擎把结果烘焙进存档，地图脚本再也不会被调用。

所以：**地图完全由 `GenerateMap()` 一次性决定**。游戏中不会再生成地形。

---

## 1. 随机数模型（先读这段）

这是理解整个系统的关键，也是最容易踩坑的地方。

### 1.1 只有一条随机流算数

Civ6 里和地图有关的随机数**只有一个合法来源**：

```lua
TerrainBuilder.GetRandomNumber(range, "描述字符串")   -- 返回 0 .. range-1
```

它由**地图种子**播种 —— 也就是 `MapConfiguration.GetValue("RANDOM_SEED")`，暂停菜单里
显示的那个数字。同一个种子 + 同一套地图参数 ⇒ 同一张图。

第二个参数是给日志用的标签，不影响结果，但**请老实填**，调试时全靠它定位。

### 1.2 不要用 `math.random`

标准 Lua 的 `math.random` 是**另一条独立的流**，不接地图种子。用了它，那部分地形就永远
无法靠种子复现。

而且它连"每次开图都一样"都做不到。Civ6 内嵌的是 Lua 5.1/5.2 系
（判据：[MapUtilities.lua:626](../Maps/Utility/MapUtilities.lua) 在用 5.3 已移除的 `table.maxn` 且能正常工作，
至少可以确定不是 5.3+），这一代的 `math.random` 直接包 C 运行库的 `rand()`，
状态跟**进程**走而不是跟 Lua 状态机走。代码里也从没调用过 `math.randomseed`。
于是同一次启动内连续开图，随机流会一直往前推，第二次开图和第一次结果不同；重启游戏又回到起点。

这正是 2026-08-10 之前"种子不生效"的成因：25 个地图脚本里共 61 处 `math.random`，
影响海陆轮廓和火山土，进而影响资源与出生点。现已全部改为 `GetRandomNumber`。

**顺带**：`math.random` 在多人游戏里各客户端不同步，会 desync。这是不用它的第二个理由。

### 1.3 随机流是共享且有序的

所有 `GetRandomNumber` 调用共用一条流。这意味着：

- 在流程中间**增加或删除**一次抽取，会让它之后的所有随机结果整体位移。
- 所以任何改动地图脚本的提交，都会让老种子生成出不同的图。这不是 bug，但要在 changelog 里写明。

### 1.4 概率写法对照

`GetRandomNumber(n)` 返回 `0 .. n-1`，和 `math.random` 的 `1 .. n` 差一位。换算：

| 想要 | 写法 |
|---|---|
| 1/n 概率 | `GetRandomNumber(n, "...") == 0` |
| 均匀取 `a..b` | `a + GetRandomNumber(b - a + 1, "...")` |
| 洗牌 | `GetShuffledCopyOfTable(t)`（Fisher–Yates，[MapUtilities.lua:624](../Maps/Utility/MapUtilities.lua)） |

---

## 2. 主流程

以 [Continents.lua](../Maps/Continents.lua) 的 `GenerateMap()` 为准。25 个地图脚本骨架相同，
差别在参数和少数几步是否启用。

```
┌─ 读配置 ─────────────────────────────────────────┐
│  地图尺寸 / 温度 / 世界年龄 / 海平面 / 降水 /      │
│  资源丰度 / 出生点模式                            │
└──────────────────────────────────────────────────┘
   ↓
 1. GeneratePlotTypes()      分形 → 陆/海/丘/山
   ↓
 2. GenerateTerrainTypes()   纬度 → 雪/苔原/草原/平原/沙漠
   ↓
 3. ApplyBaseTerrain()       ← 到这里才真正写进引擎
   ↓
 4. AddTerrainFromContinents()  火山、孤峰
   ↓
 5. AddRivers()              河流
   ↓
 6. AddLakes()               湖泊
   ↓
 7. AddFeatures()            森林/丛林/沼泽/雨林/冰
   ↓
 8. AddCliffs()              峭壁
   ↓
 9. NaturalWonderGenerator   自然奇观
   ↓
10. AddFeaturesFromContinents()  礁石等依赖大陆划分的地貌
   ↓
11. MarkCoastalLowlands()    海岸低地（洪水用）
   ↓
12. AddVolcanicSoil()        ★ HD 新增：火山土
   ↓
13. ResourceGenerator        资源
   ↓
14. AssignStartingPlots      出生点
   ↓
15. AddGoodies()             部落村庄
```

**这个顺序不能随便调。** 后面的步骤读取前面的结果：资源要看地貌（火山土会顶掉森林），
出生点要看资源和产出。第 12 步排在 13、14 之前，就是为了让火山土参与资源评分和出生点肥沃度计算 ——
这也是当初火山土用错随机源会导致"整张图都变了"的原因。

### 2.1 一个容易困惑的写法

`NaturalWonderGenerator.Create(args)`、`ResourceGenerator.Create(args)`、
`AssignStartingPlots.Create(args)` 看起来只是构造对象，其实**构造函数里就把活全干完了**：

```lua
-- NaturalWonderGenerator.lua:14
function NaturalWonderGenerator.Create(args)
    local instance = { ... }
    instance:__InitNWData()
    instance:__FindValidLocs()
    instance:__PlaceWonders()   -- ← 奇观在这里就放完了
    return instance
end
```

返回值基本没人用。这是 Firaxis 的原始写法，照抄即可，但别以为 `Create` 只是初始化。

---

## 3. 逐步详解

### 步骤 1：GeneratePlotTypes —— 陆海轮廓

分形噪声决定哪里是陆地。核心是一个**海平面百分比**：噪声高度低于阈值的格子是海。

HD 改了海平面常量（[Continents.lua:125](../Maps/Continents.lua)）：

| | 原版 | HD |
|---|---|---|
| 低海平面 | 57 | 40 |
| 正常 | 62 | 45 |
| 高海平面 | 66 | 50 |

数值是"水占比百分比"，所以 HD 的陆地明显比原版多。这是 HD 地图手感的根本来源之一。

生成之后有一个**拒绝重采样循环**：如果最大的一块陆地占了全部陆地的 58% 以上，就丢弃重来
（`while done == false`）。这个循环每轮都要抽随机数，所以同一个种子下的实际抽取次数是不定的 ——
但对同一种子是确定的。

部分地图（Lakes、Rivers、各种 Highlands 等 22 张）额外跑一个
`GenerateFractalLayerWithoutHills()`，它在第一层分形之外叠一层，并对"周围陆地很多的海格"
做补陆处理，用来消除条纹状的碎海。

### 步骤 2：GenerateTerrainTypes —— 地形带

按**纬度**铺基础地形，从两极到赤道依次是雪原、苔原、草原、平原、沙漠。
分界纬度受"温度"配置影响（`temperature` 1~3，4 表示随机）。

同时叠一层沙漠/平原的分形扰动，避免地形带成为整齐的横条。

### 步骤 3：ApplyBaseTerrain

前两步都只在 Lua 的 `plotTypes` / `terrainTypes` 数组里算，这一步才调
`TerrainBuilder.SetTerrainType` 真正写进引擎。之后 `AreaBuilder.Recalculate()` 和
`TerrainBuilder.StampContinents()` 让引擎重新识别大陆和区域。

**改地形请在这一步之前改数组，之后改则要用 API。** 混着来会不一致。

### 步骤 4：AddTerrainFromContinents —— 火山与孤峰

两件事：

1. **板块边界火山**。在两块大陆交界处（`Map.FindSecondContinent`）按距离分档撒火山：
   紧贴边界概率最高，1 格、2 格外递减。会避开"六面环山"的死格和沿海格。
2. **孤峰**。不在边界的零散山脉。

### 步骤 5–6：河流与湖泊

`AddRivers()` 从高地找源头，沿"河流值"最低的方向逐格推进入海。方向选择在
[RiversLakes.lua:252](../Maps/Utility/RiversLakes.lua) 的 `DoRiver` 里，本身不抽随机数，
完全由地形高度决定 —— 所以河流是地形的确定性函数。

`AddLakes(n)` 的 `n` 由地图脚本给：Continents 用
`ceil(GameInfo.Maps[size].Continents * 4 + 15)`。湖必须在河流之后放，否则会截断河道。

### 步骤 7：AddFeatures —— 植被

`FeatureGenerator` 按地形和降水配置铺沼泽、湿地、丛林、森林、稀树草原。
每张图在创建 `FeatureGenerator` 时传入自己的百分比，例如 Continents：

```lua
{rainfall = rainfall, iMarshPercent = 5, iSwampPercent = 4,
 iJunglePercent = 36, iForestPercent = 24}
```

Continents 的注释写明了设计意图：植被茂盛 ⇒ 出生点锤子多 ⇒ 主文明出生点的肥沃度上下限
都要相应提高，城邦的下限则要降低，否则城邦会被挤到角落。**改植被百分比时，
步骤 14 的 `MIN/MAX_*_FERTILITY` 要跟着调。**

### 步骤 9：自然奇观

`__FindValidLocs()` 遍历所有奇观，找出每个奇观所有合法落点。
然后给**每个有落点的奇观**抽一个 `GetRandomNumber(100)` 作为随机分，按分数降序排，
取前 `NumNaturalWonders` 个实际放置。放置时再对该奇观的候选格评分，取最高分那格。

注意随机分只有 0–99 而候选奇观可能上百个，**平分很常见**；`table.sort` 不稳定，
平分的先后由排序实现决定。对同一输入是确定的，所以不影响种子复现。

### 步骤 12：AddVolcanicSoil（HD 新增）★

扫全图找火山，在周围铺火山土。分两类：

**普通火山 `FEATURE_VOLCANO`**：一环铺满。无随机。

**火山系自然奇观**（埃亚菲亚德拉冰盖、乞力马扎罗、维苏威、富士山、恩戈罗恩戈罗火山口）：
一环铺满，二环按 1/3 概率（Primordial 是 1/2）。

三处共用同一个准入判断：

```lua
local function CanTakeVolcanicSoil(pPlot)
    if (pPlot:IsWater() or pPlot:IsMountain()) then return false; end
    local eFeature = pPlot:GetFeatureType();
    if (eFeature == -1) then return true; end
    if (eFeature == g_FEATURE_FLOODPLAINS
    or  eFeature == g_FEATURE_FLOODPLAINS_GRASSLAND
    or  eFeature == g_FEATURE_FLOODPLAINS_PLAINS) then return false; end
    if (GameInfo.Features[eFeature].NaturalWonder) then return false; end
    return true;
end
```

也就是：**水域、山地、三种泛滥平原、以及任何自然奇观都不铺**。自然奇观用
`Features.NaturalWonder` 标志位而不是硬编码名单，新增的自然奇观（含第三方 mod 的）自动受保护。

> **为什么泛滥平原要单独排除。** 洪水判定看的是河流，不是地貌 ——
> 把泛滥平原盖成火山土，那一格照样会发洪水，只是不再有泛滥平原了。
> 这种"会发洪水但没有泛滥平原"的地块是给下游逻辑埋雷，不值得为几格火山土换。
> 代价是火山紧邻泛滥时一环会少铺几格，这是刻意接受的。

> **二环的实际概率不是 1/3。** 二环循环嵌在一环循环内部
> （[Continents.lua:398](../Maps/Continents.lua)），所以一个二环格子每邻接一个一环格子就被摇一次。
> 六边形网格上，二环的"角"格只邻接 1 个一环格，"边"格邻接 2 个 ——
> 于是角格 33%、边格 55.6%。如果你想调整火山土密度，改的是这个复合概率，不是字面的 1/3。
> 这个行为是**刻意保留**的（原实现如此，改掉会显著改变火山土观感），代码里有注释说明。

火山土会**覆盖**原有地貌（森林等），并改变地块产出，所以它排在资源和出生点之前。

### 步骤 13：ResourceGenerator —— 资源

按固定顺序分七批放置，每批内部是"给所有合法格评分 → 排序 → 从高分往下放 N 个"：

1. 陆地奢侈 2. 水域奢侈 3. 陆地战略 4. 水域战略 5. 陆地加成 6. 水域加成 7. 去重清理

**HD 加的调节旋钮**（在各地图脚本里通过 `args` 传入）：

| 参数 | 作用 |
|---|---|
| `HorsesMultiply` / `IronMultiply` / `NiterMultiply` / `CoalMultiply` / `OilMultiply` / `AluminumMultiply` | 单独调六种战略资源丰度 |
| `ExtraBonusGroupOne/Two` + `...Multiply` | 指定一组加成资源，乘一个 >1 的倍率 |
| `FewerBonusGroupOne/Two` + `...Multiply` | 同上，乘一个 <1 的倍率 |
| `ExtraLuxuries` | 额外奢侈资源池，每图最多放 `maxExtraLuxuries = 2` 种 |
| `iWaterLux` | 水域奢侈数量 |

倍率是**连乘**的：一个资源同时出现在 Extra 和 Fewer 组里，两个倍率都会生效。
最终数量走 `for iI = 1, iNumToPlace`，小数部分被截断（向下取整）。

### 步骤 14：AssignStartingPlots —— 出生点

最长的一个模块（2553 行）。顺序：

1. `__DLPreparePlotFertilities()`（HD 新增）—— 预计算全图肥沃度表
2. 水上文明可行性检查（水格不够就全部改回陆地开局）
3. **主文明**逐个选点 `__SetStartMajor()`，按肥沃度排序取最优，并保持彼此距离
4. 主文明的**起始偏好**（StartBias）—— 按 civ 的地形/资源/地貌偏好做二次筛选
5. 平衡/传奇难度下补资源：`__AddResourcesBalanced()` / `__AddResourcesLegendary()`
6. **城邦**逐个选点 `__SetStartMinor()`
7. 城邦起始偏好
8. 最后处理水上文明

肥沃度阈值由地图脚本给，例如 Continents：

```lua
MIN_MAJOR_CIV_FERTILITY = 93,  MAX_MAJOR_CIV_FERTILITY = 141,
MIN_MINOR_CIV_FERTILITY = 18,  MAX_MINOR_CIV_FERTILITY = 86,
MIN_BARBARIAN_FERTILITY = 50,
```

这些数字和步骤 7 的植被百分比是**一对**，改一个必须回头看另一个。

### 步骤 15：AddGoodies —— 部落村庄

HD 重写了这一步（[MapUtilities.lua:800](../Maps/Utility/MapUtilities.lua)）。
原版是按扫描顺序逐格 50% 掷骰，密度靠"已放数/已扫描数"动态控制，结果偏少且有扫描顺序偏置。
HD 版改为：把全图格子索引洗牌，然后按洗牌顺序放满 `floor(总格数 / TilesPerGoody)` 个。
另外把雪地排除在外（[MapUtilities.lua:698](../Maps/Utility/MapUtilities.lua)）。

---

## 4. 25 个地图脚本的关系

`Maps/` 下共 28388 行（地图脚本 20438 + `Utility/` 7950），结构是：

```
Maps/
├── <25 个地图脚本>.lua      每个 400~1200 行，各自实现 GenerateMap()
└── Utility/                 共享模块，被 include 进地图脚本
    ├── MapEnums.lua              地形/地貌/资源的索引常量
    ├── MapUtilities.lua          通用工具、洗牌、部落村庄
    ├── TerrainGenerator.lua      地形带、火山、孤峰
    ├── MountainsCliffs.lua       板块、孤峰、峭壁
    ├── RiversLakes.lua           河流、湖泊
    ├── FeatureGenerator.lua      植被、冰
    ├── NaturalWonderGenerator.lua 自然奇观
    ├── CoastalLowlands.lua       海岸低地
    ├── ResourceGenerator.lua     资源
    ├── AssignStartingPlots.lua   出生点
    ├── PlotFiltering.lua         格子筛选辅助
    └── SetDefaultAssignedStartingPlots.lua
```

`Utility/` 是单一副本，改一处全图生效。**地图脚本本身则大量复制粘贴** ——
详见下一节。

HD 覆盖了全部原版地图脚本（在 `DL.modinfo` 的 `ImportFiles` 里列出），
所以选"大陆"这种原版图，跑的也是 HD 的版本。

---

## 5. 已知工程问题

> 已修复的见 [changelog_cloud.md](../Changelog/changelog_cloud.md)。

### 5.1 GenerateFractalLayerWithoutHills 的 22 份副本

其余重复已合并（`AddVolcanicSoil` 25→1、`Adjacent` 22→1、`AdjacentCount` 11→1，
都在 `Utility/MapUtilities.lua`，净减约 2500 行）。剩这一个**不建议合并**。

22 份里有 **18 个不同变体**，不是复制粘贴：Lakes 与 Rivers 只差 4 行默认值，
但 Lakes 与 Tiny_Islands 差 59 行 / 共 117 行，Tiny_Islands 只有 80 行——是结构性差异。
合并意味着把 18 种配置塞进一个参数化函数，拿"22 个简单函数"换"1 个参数汤"，
不见得更好。

真要动，先给 [tools/maptest](../tools/maptest/) 补 `Fractal.*` 和 `ShiftPlotTypes`
的桩（`Fractal` 是黑盒，塞确定性伪噪声即可——差分只要求两版吃到同一份输入）。

### 5.2 十张图的填海分支已删除，但"要不要填海"仍未定

`AdjacentCount` 的值域是 0..6（相邻陆地数）加哨兵 7（自己已是陆地）。
11 张用它的图里，只有 Lakes 的阈值 `> 1` 可达；其余 10 张写的是 `> 8`、`> 9`、
`> 12`、`> 13`、`> 16`，**从来没执行过**。数值形态像是作者想让填海更保守，
一路往上调、超过 7 之后分支静默失效而不自知。

死分支已删（行为不变，它本来就不执行）。但**这 10 张图到底该不该填海**是手感问题，
需要 xhh 判断：现在它们只在"周围完全没有已有陆地"时铺陆，即只投放孤立新岛，
永远不会填海湾或连接已有陆地——而代码注释描述的恰恰相反。

要启用的话按 0..6 标定，参考 Lakes.lua，并注意这会显著改变那 10 张图的海岸线。

### 5.3 十张图的世界纪元被局部变量屏蔽（已修）

`GenerateMap()` 读设置、映射成数值、传给 `GeneratePlotTypes(world_age)`。
但这 10 张图在函数体开头又写了一遍 `local world_age = 1;`（Highlands_XP2 是 2），
**把入参遮住了**。

`Archipelago_XP2` 的这一行**原版 Firaxis 就有**，其余 9 张是 HD 侧引入的
（原版 `Lakes.lua` 的 `GeneratePlotTypes()` 不带入参，函数体内自己读一遍设置，所以是好的）。

#### 先厘清"不生效"到底指什么

世界纪元有**三个**下游消费者，被遮住的只有其中两个：

| 消费者 | 拿到的是 | 改之前 |
|---|---|---|
| `AddTerrainFromContinents(..., world_age, ...)` → 火山数量 | **外层的、活的** world_age | **一直在生效** |
| `args.world_age` → `ApplyTectonics` | 被遮住的硬编码值 | 失效 |
| `mountainRatio` → `AddLonelyMountains` | 被遮住的硬编码值 | 失效 |

`AddTerrainFromContinents` 里是 `iDesiredVolcanoes = 陆地数 / ((8 - world_age) * 50)`。

#### 顺带发现的第二个缺陷：三张图比错了变量

`MapConfiguration.GetValue("world_age")` 返回的是**设置序号 1/2/3**。
但有三张图拿它去比自己的 `world_age_*` **常量**：

| 地图 | 写的是 | 后果 |
|---|---|---|
| Forest_Highlands | `== 3 / == 5 / == 7` | 选「老」→ 命中第一个分支拿到 `world_age_new`（方向反了）；选「新」「标准」→ 全部掉进 `else` 变成**随机** |
| Great_Sand_Sea | `== 3 / == 7 / == 10` | 同上 |
| Highlands_XP2 | `== 3 / == 5 / == 7` | 同上 |

因为外层 `world_age` 是活的（喂给火山那条路径），所以这三张图的**火山数量在改之前
基本是随机的，而且"老世界"给的是最年轻的那档**。像是有人改了常量之后
顺手把比较的数字也一起改了，没意识到被比较的是设置序号。

#### 两个失效消费者的量纲完全不同

**`ApplyTectonics` 里 `adjustment` 的每一处用法都是加减法**，单位是**分形百分位点**：

```lua
adjust_plates  : <3 → ×0.75 ; ==3 → ×1.0 ; >3 → ×1.5     ← 阶跃，不连续
hillsBottom1   = 28 - adj   ;  hillsTop1 = 28 + adj
hillsBottom2   = 72 - adj   ;  hillsTop2 = 72 + adj
hillsClumps    = 1 + adj
hillsNearMountains = 91 - 2*adj - extra_mountains
mountains      = 97 - adj - extra_mountains
```

这些值最后都喂给 `frac:GetHeight(百分位)`，所以**小数是合法的**。
Great_Sand_Sea / Great_Steppe / Highlands_XP2 另外还有一份**内联**的同类块，
用于它们自己的分形叠层，写法一样是加减。

**`mountainRatio` 是"每几格陆地一座山"，越大山越少**：

```lua
iNewMountains = math.floor(iTotalLandPlots / mountainRatio) - iTotalMountains;
if (iNewMountains < 0) then iNewMountains = 0; end       -- 只加不减
```

日志可以对上：Great Steppe 的 `mountainRatio = 10 + 1*12 = 22`，
`New Mountains 50`，`Mountain Set 51`，反推陆地约 1100 格 —— 证实硬编码值确实在生效。

> **更正一处早先的说法**：我之前写"删掉这一行等于统一加 1.5～2.4 倍山脉"，方向错了。
> 放开之后 `mountainRatio` **变大**，孤峰**变少**；同时 `ApplyTectonics` 的
> `mountains = 97 - adj` 阈值下降，造山带**变多**。原版是刻意让两者反向的 ——
> 年轻世界山脉集中成脉，古老世界山脉被侵蚀但孤峰更散。那是一次**再分配**，
> 不是单向增加。

#### 落地方案：把设置当"步长"，而不是替换

硬编码值是长期调出来的，直接放开连"正常"档都会大幅偏离今天的观感
（Forest_Highlands 的 `mountainRatio` 从 21 变 41，孤峰直接减半）。
所以保留硬编码值作为**"标准纪元"的基准**，全局设置只提供 `-1 / 0 / +1` 的步长，
而且**两个消费者用不同的作用方式**，因为量纲不同：

**① `ApplyTectonics` 那边用加法，步长 0.5。** 它的每一处用法都是加减、单位是百分位点，
关心的是**绝对差**。用乘法的话，同一个"新世界"设置在 C=1 的图上是 +0.5 个百分点、
在 C=2 的图上是 +1.0 —— 同一个设置在不同图上含义不同，没有道理。

步长取 0.5 不取 1，是为了躲开两个点：

- `adj == 0` 会让 `hillsBottom1 == hillsTop1 == 28`，**丘陵带宽度归零**。
  9 张图的 C 是 1，减 1 就踩上。
- `adj == 3` 是 `adjust_plates` 的阶跃点。Highlands_XP2 的 C 是 2，加 1 就踩上，
  板块数会突跳 33%。

**② `mountainRatio` 那边用乘法，±20%。** 公式是 `A + C*B`，其中 `B` 在 10 张图上
从 4 变到 12。加法步长 δ 会让它变化 `B*δ`，在不同图上是 +18% ~ +55% 不等；
乘在最终值上才是统一的。方向跟随原版：年轻世界孤峰更少。

**③ 内联阈值块的判断仍用基准值。** Great_Steppe 的 `world_age_old` 正好等于它的
硬编码值 1，步长 +1 会让 `world_age <= world_age_old` 从真变假，
`adjust_plates` 突跳 33%。所以那三张图的 `if world_age <= world_age_old` 改成
`if world_age_base <= ...`，阶跃判断锁在基准值上，只让连续量跟着步长走。

实际写法（以 Great_Steppe 为例）：

```lua
-- 文件级
local g_iWorldAgeStep = 0;			-- 世界纪元步长：老 -1 / 标准 0 / 新 +1

-- GenerateMap()：先算步长，再由步长选常量。不动 world_age 本身的取值，
-- 所以火山那条路径在三个固定档上行为不变。
local world_age = MapConfiguration.GetValue("world_age");
if (world_age == 1) then     g_iWorldAgeStep = 1;      -- 30 亿年（新）
elseif (world_age == 2) then g_iWorldAgeStep = 0;      -- 40 亿年（标准）
elseif (world_age == 3) then g_iWorldAgeStep = -1;     -- 50 亿年（老）
else g_iWorldAgeStep = TerrainBuilder.GetRandomNumber(3, "Random World Age - Lua") - 1;
end
if (g_iWorldAgeStep > 0) then     world_age = world_age_new;
elseif (g_iWorldAgeStep < 0) then world_age = world_age_old;
else                              world_age = world_age_normal;
end

-- GeneratePlotTypes()
local world_age_base = 1;
local world_age = world_age_base + g_iWorldAgeStep * 0.5;
...
mountainRatio = (10 + world_age_base * 12) * (1 + g_iWorldAgeStep * 0.2);
```

随机档的抽取次数和范围都没变（还是一次 `GetRandomNumber(3, "Random World Age - Lua")`），
顺带修掉原先 `1 + rand(3)` 取 1..3、而映射常量可能是 3/5/7 的量纲不一致。

#### 结果

| 地图 | 硬编码 C | `adj` 老/标准/新 | `mountainRatio` 老/标准/新 |
|---|---|---|---|
| Archipelago_XP2 | 1 | 0.75 / 1.25 / 1.75 | 8 / 10 / 12 |
| Continents_Islands | 1 | 0.75 / 1.25 / 1.75 | 8 / 10 / 12 |
| Tiny_Islands | 1 | 0.75 / 1.25 / 1.75 | 7.2 / 9 / 10.8 |
| Great_Steppe | 1 | 0.5 / 1 / 1.5 | 17.6 / 22 / 26.4 |
| Wet_Lakes2 | 1 | 0.5 / 1 / 1.5 | 14.4 / 18 / 21.6 |
| Great_Sand_Sea | 1 | 0.5 / 1 / 1.5 | 9.6 / 12 / 14.4 |
| Lakes | 1 | 0.5 / 1 / 1.5 | 11.2 / 14 / 16.8 |
| Tiny_Lakes | 1 | 0.5 / 1 / 1.5 | 16.8 / 21 / 25.2 |
| Forest_Highlands | 1 | 0.5 / 1 / 1.5 | 16.8 / 21 / 25.2 |
| Highlands_XP2 | 2 | 1.5 / 2 / 2.5 | 10.4 / 13 / 15.6 |

（三张岛图的 `args.world_age` 带 `+0.25`，表里已经算进去了。）

以 Great_Steppe（陆地约 1100 格）为例，孤峰 62（老）/ 50（标准）/ 42（新），
同时 `mountains = 97 - adj` 阈值 96.5 / 96 / 95.5，造山带反向变化。

**"标准"档的一致性**：七张图与改动前**逐位一致**（步长 0 时两处都退化成原值）。
Forest_Highlands / Great_Sand_Sea / Highlands_XP2 三张**会变** ——
它们的"标准"档本来就是坏的（掉进随机分支），现在才第一次真正生效。
同样地，这三张图在"新"和"标准"档上比以前**少抽一次随机数**，随机流会平移。

**两个系数（0.5 和 0.2）是可调的旋钮，不是推导出来的定值。**
觉得纪元"手感太弱"就同比放大。

### 5.4 河流没有入海口（已修北边界那一类）

`DoRiver` 是递归的，正常出口是"下一格是水或出了地图边界"（[RiversLakes.lua:212](../Maps/Utility/RiversLakes.lua)）。
但有两条路会让它停在内陆：

1. **找不到下一个流向**（`bestFlowDirection == NO_FLOWDIRECTION`）。
2. **撞上已有河流的分支提前 `return`**。六个方向分支里各有一组
   `riverPlot:IsNEOfRiver()` / `IsNWOfRiver()` / `adjacentPlot:IsWOfRiver()` 判断，
   命中就直接返回。本意是"汇入已有河流"，但两条河的边未必真的接得上。

这两种情况都会留下一段**逻辑上存在、但没有入海口**的河：`IsRiver()` 为真、给淡水、
参与河流相邻加成，而河道模型可能画不出来 —— 与外部 modder 的说法一致。
**这一轮只处理第 1 条。**

#### 第 1 条只可能发生在首末行（穷举 + 实测双重确认）

把方向搜索的三个约束穷举了一遍。`adjacentPlotFunctions` 里六个流向用来**打分**
的相邻格方向是：

| 流向 | 打分方向 | y=0 拿不到 | y=H−1 拿不到 |
|---|---|---|---|
| NORTH | `DIRECTION_NORTHWEST` | | ✔ |
| NORTHEAST | `DIRECTION_NORTHEAST` | | ✔ |
| SOUTHEAST | `DIRECTION_EAST` | | |
| SOUTH | `DIRECTION_SOUTHWEST` | ✔ | |
| SOUTHWEST | `DIRECTION_WEST` | | |
| NORTHWEST | `DIRECTION_NORTHWEST` | | ✔ |

东西向环绕，所以 `DIRECTION_EAST` / `DIRECTION_WEST` 永远拿得到。
理论上共 13 种 `(边界, this, original)` 组合，其中一种在递归里不可达，
**可达 12 种：北边界 10、南边界 2**，内陆不可能。

#### 测什么、没测什么（先说清楚）

[tools/maptest/river.lua](../tools/maptest/river.lua) 直接加载真实的 `RiversLakes.lua`，
桩掉十来个引擎接口。但要注意：

> **它跑的不是任何一张真实地图脚本。** 地形是合成的（白噪声，以及做过几轮平滑的
> 连片陆地），不是 `GeneratePlotTypes` 生成的分形大陆；起河也是直接调 `DoRiver`，
> 没走 `AddRivers` 的选源逻辑（`passConditions` + `Map.FindWater` + 引擎侧的
> `GetInlandCorner`）。**分形生成器和 `GetInlandCorner` 都在引擎里，游戏外没法复现。**

所以"每张图会出现几条断头河"这个问题，离线测不出来，**而且各图一定不一样** ——
断头要求首行/末行是**陆地**，那么极地是海还是雪原、河源密度高不高，
每张图差别很大（高地系几乎全陆地、群岛系几乎没有内陆河源）。

离线能回答的是另一个更重要的问题：**哪些情况会发生、补丁覆盖了几种。**
这个只取决于 `DoRiver` 自身的控制流，与地形无关。

#### 随机采样：实际碰到的只有一类

4 个场景（白噪声 32% / 8%、连片陆地 40% / 15%）× 3 种尺寸 × 12 张：

```
起河 89742 次，铺下 232634 条河流边
走到 NO_FLOWDIRECTION（断在陆地上）：80 次
  按位置：北边界 y=H-1  80        ← 内陆 0、南边界 0
  按组合：this=NORTH orig=NORTHEAST  62      ← 原版补丁救得回
          this=NORTH orig=NORTHWEST  16      ← 原版救不回
          this=NORTH orig=NORTH       2      ← 原版救不回
```

`thisFlowDirection` **全部**是 `NORTH`。

#### 定向穷举：可达的是 11 种，不是 12 种

随机采样只能说"实际碰到了哪几种"，回答不了"还有哪几种到得了"。所以另外做了一遍
穷举：在一张全陆地的图上，用每个格子 × 每一组 `(this, original)` 直接调 `DoRiver`。

结果**11 种可达，全部在北边界**：

| 组合 | 补丁覆盖 |
|---|---|
| `this=NORTH` × `orig` 的六种 + 起点 | ✔ |
| `this=NORTHWEST, orig=NORTHEAST` | ✔（靠保留的原版条件） |
| `this=NORTHEAST, orig=NORTHWEST` | ✘ |
| `this=SOUTHEAST, orig=NORTH` | ✘ |
| `this=SOUTHWEST, orig=NORTH` | ✘ |

（`orig=起点` 那一行是直接构造出来的，真实递归里 `original` 一定已被赋值。）

比只看方向搜索约束的理论值（13 种）少两种，**少的正是南边界那两种**：
`FLOWDIRECTION_SOUTH` 分支在 `y=0` 时要取 SW 邻格，那格不存在，
**会在铺边之前就 early return**，根本走不到搜索那一步。
所以南边界**结构上就不会产生断头河** —— 这比之前"没有实测样本"的说法强得多。

#### 修法：原版判错了变量

原版的条件是 `originalFlowDirection == FLOWDIRECTION_NORTHEAST`。但决定"河现在
停在这一格的哪个角上"的是 **`thisFlowDirection`** —— 补的那两条边（NW 边走
NORTHEAST、W 边走 NORTH）只和"以 NORTH 流向到达这里"有关，跟这条河最初往哪流
没关系。原版按 `original` 判属于判错了变量，只是绝大多数时候两者恰好同时成立。

改成只做加法，保留原条件、另外补上按 `thisFlowDirection` 的判断：

```lua
-if (originalFlowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST) then
+if (thisFlowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTH
+ or originalFlowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST) then
```

改后：随机采样里 **80 次断头全部被补上，未补 0 次**；定向穷举里覆盖 **8 / 11 种**。

#### 剩下 3 种为什么刻意不补

补的那两条边在几何上只对应"以 NORTH 流向到达"。剩下 3 种里河停在这一格的**另一个
角**上，硬套同一组边多半会铺出一段接不上的孤边，**比留着更糟**。要正确处理得逐种
推出口，而这需要一套六边形顶点模型 —— `W/NW/NE-of-river` 标志位和 `DoRiver` 里
"startPlot 的某个角"这个约定之间的对应关系，在游戏外验证不了。

它们在 89742 次随机起河里**一次都没出现**，只有直接指定 `(this, orig)` 才构造得出来。
测试里用**白名单**钉住：新出现补不上的组合会失败，白名单里的组合变成能补也会失败
（说明白名单过期）。

#### 想要真实的每图数字，只能进游戏

断头处已经加了一句诊断：

```lua
print(string.format("RIVER DEAD END: (%d,%d) this=%d orig=%d id=%d", ...))
```

它会进 `Logs/Lua.log`。想知道 25 张图各自的实际分布，就是每张图开几局、
`grep RIVER DEAD END` 数一下。这是唯一的办法。

#### 没做的部分

- **第 2 条（撞上已有河流提前 `return`）**不在边界上，补边界解决不了，
  需要单独判断两条河是否真的接上。
- 顺带确认：`AddRivers` 排在 `AddCliffs` 和自然奇观**之前**，所以
  `GetRiverValueAtPlot` 里那段 `IsNWOfCliff()/IsNaturalWonder() → return -1`
  在标准流程里**是死代码**。它写成 `-1` 而分数是**越小越优**，真要是活的，
  效果会是让河流优先冲向峭壁和奇观。

#### 变异测试

五种人为破坏全部被抓到：退回原版条件、只留 `this` 那半条件（会让
`this=NORTHWEST, orig=NORTHEAST` 失去覆盖，触发白名单过期检查）、
把 `NORTH` 写成 `SOUTH`、少铺一条边、把 `NW` 写成 `NE`。

**这次改动会改全部 25 张图的河网，老种子作废。**

### 5.5 开 Sukritact's Oceans 时海洋奢侈品可能一个都不放（第三方 mod 崩溃）

`Suk_ResourceGenerator.lua:354` 报 `operator < is not supported for number < nil`，
地图照样生成，看着像无害，其实那一局的海洋奢侈品会全没。

完整分析（Suk 那 7 个 Lua 文件各自在干什么、在主流程的哪个阶段生效、
已证实的除零缺陷、崩溃的排查过程与修改方案）单独写在
**[SukOceans.md](SukOceans.md)** 里。

一句话结论：**Suk 是 `AddGameplayScripts`，在 `GenerateMap()` 之后才跑**，
所以修它不会动地形、河流、出生点，也不会让老地图种子失效 ——
比 5.3 和 5.4 安全得多。

## 6. 怎么验证改动

1. **跑差分测试**——[tools/maptest](../tools/maptest/)。它把地图函数从游戏里摘出来、
   桩掉引擎接口，逐格对比改动前后的行为。目前覆盖 `AddVolcanicSoil`
   （含泛滥平原守卫）和 `Adjacent` / `AdjacentCount`；`river.lua` 直接加载真实的
   `RiversLakes.lua` 统计断头河。要测别的函数照着 `stub.lua` 补接口即可。
   **这是唯一能给出确定性结论的办法**，比开很多局强。
2. **看日志**。`GenerateMap()` 里的 `print` 会进 Civ6 用户目录的 `Logs/Lua.log`。
   `GetRandomNumber` 的第二个参数也会出现在随机数日志里，可以用来核对抽取顺序。
3. **实机冒烟测试**。1～2 局，确认不报错、地貌正常生成。不需要资深玩家。
4. **测种子复现**。在高级设置里手填地图种子，开两局对比。注意要**重启游戏**再测第二次 ——
   如果哪天又有人引入 `math.random`，同一次进程内连开两局才能暴露问题。

> **改了任何抽取次数，老种子就失效**。随机流是共享有序的，增删一次抽取会让之后所有结果
> 整体位移。这是预期行为，不是 bug，在 changelog 里写明即可。
>
> 同理，**同种子同图的前提是配置完全一致**：地图参数、文明与城邦数量、启用的 mod 集合
> 与加载顺序、游戏模式。差一个资源包，出来就是完全不同的图。

---

*最后更新：2026-08-10*
