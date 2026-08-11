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
    if (eFeature ~= -1 and GameInfo.Features[eFeature].NaturalWonder) then return false; end
    return true;
end
```

也就是：**水域、山地、以及任何自然奇观都不铺**。用 `Features.NaturalWonder` 标志位而不是
硬编码名单，新增的自然奇观（含第三方 mod 的）自动受保护。

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

> 已修复的见 [changelog_cloud.md](../Changelog/changelog_cloud.md)：61 处 `math.random`、
> 125 处硬编码 feature id、`AddVolcanicSoil` 的 X 循环越界与三处不一致的奇观排除名单、
> 死声明与 GBK 字节、`AddGoodies` 的 off-by-one、随机海平面取不到最低档、
> 出生点肥沃度的浮点求和顺序、浮点 RNG 上界。

只剩一个，而且是最大的一个。

### 5.1 大规模复制粘贴

| 函数 | 重复份数 | 合并难度 |
|---|---|---|
| `AddVolcanicSoil` | 25 | **低** —— 逐字相同，直接搬进 `Utility/` |
| `GenerateFractalLayerWithoutHills` | 22 | **高** —— 22 份**不相同**，`(a,b)` 参数与分形指数逐图调过，合并要参数化 |
| `Adjacent` | 22 | **中** —— 读文件级全局 `islands`，搬走要连状态一起搬 |
| `AdjacentCount` | 11 | 同上 |

后果是具体的：修 `math.random` 要改 61 处、去掉火山土硬编码要改 125 处、修海平面要改 15 个
文件、修火山上界要改 8 个文件。而 X 循环越界和奇观名单不一致这两个缺陷本身，
也都是一次写错、复制 25 份。

**动手前先扩展 [tools/maptest](../tools/maptest/) 的桩覆盖目标函数。**
`AddVolcanicSoil` 已经有覆盖，可以先做它；后三个需要额外桩掉 `Fractal.*`、
`ShiftPlotTypes`、`Map.GetAdjacentPlot`（`Fractal` 是黑盒，塞确定性伪噪声即可——
差分只要求两个版本吃到同一份输入）。

---

## 6. 怎么验证改动

1. **跑差分测试**——[tools/maptest](../tools/maptest/)。它把地图函数从游戏里摘出来、
   桩掉引擎接口，逐格对比改动前后的行为。目前只覆盖 `AddVolcanicSoil`，
   要测别的函数照着 `stub.lua` 补接口即可。
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
