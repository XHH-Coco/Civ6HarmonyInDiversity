# Sukritact's Oceans 与 HD 地图流程的关系

创意工坊 ID `2542898147`，游戏模式开关 `GAMEMODE_SUK_OCEANS`。
本文只讲它的 Lua 部分（数据表改动见它自己的 `Core/*.sql`）。

配套阅读：[MapGeneration.md](MapGeneration.md) —— HD 自己的地图生成流程。

---

## 0. 一句话总览

**7 个 Lua 文件，实际加载 6 个，全部在 HD 地图流程跑完之后才执行。**

它不是地图脚本，是一个 `AddGameplayScripts`。也就是说地形、河流、湖泊、地貌、
自然奇观、资源、出生点、部落村庄**全部已经定稿**，Suk 在成品上再补两样东西：
海藻森林和按大洲区分的海洋奢侈品。

---

## 1. 什么时候跑

modinfo 里只有一个入口：

```xml
<AddGameplayScripts id="AddGameplayScripts">
  <Criteria>Suk_Oceans_Rework</Criteria>     <!-- GAMEMODE_SUK_OCEANS = 1 -->
  <File>Lua/Suk_OceansMapGen.lua</File>
</AddGameplayScripts>
```

其余 5 个 Lua 是 `ImportFiles`，只是放进 VFS 供 `include` 取用，自己不会执行。

`AddGameplayScripts` 在 gameplay 状态初始化时执行 —— 那时 `GenerateMap()` 早已返回。
日志可以逐行对上：

```
Map Script: Map Generation - Adding Goodies          ← HD 主流程第 15 步
Map Script: Map Generation Fixing -- DeepLogic version ← HD 的收尾
Map Script: -------------------------------
YellowCraneGreatPeople: Load YellowCrane Lua Override  ← 开始加载 gameplay 脚本
WorldCongress: Initializing World Congress Lua
Suk_OceansMapGen: Number of Kelp Forests:     0          ← Suk 在这里才开始
```

接到 [MapGeneration.md 第 2 节](MapGeneration.md#2-主流程)那张流程图后面：

```
GenerateMap()
  1  GeneratePlotTypes            陆海轮廓
  2  GenerateTerrainTypes         地形带
  3  ApplyBaseTerrain
  4  AddTerrainFromContinents     火山与孤峰
  5  AddRivers
  6  AddLakes
  7  AddFeatures                  植被
  8  AddCliffs
  9  NaturalWonderGenerator
 10  AddFeaturesFromContinents
 11  MarkCoastalLowlands
 12  AddVolcanicSoil          ★HD
 13  ResourceGenerator            资源（含原版的水域奢侈品）
 14  AssignStartingPlots          出生点
 15  AddGoodies                   部落村庄
        │
        └──────► 地图定稿，GenerateMap() 返回
                     │
                     ▼
          ┌──────────────────────────────────────────┐
          │ Suk_OceansMapGen.lua（gameplay 脚本）     │
          │                                          │
          │  S1  Suk_KelpGenerator                   │
          │        建"温度场" → 铺 FEATURE_SUK_KELP  │
          │                                          │
          │  S2  Suk_ResourceGenerator               │
          │        Jump Flood 给每格判大洲           │
          │        删掉所有已有水域奢侈品            │
          │        每个大洲抽 2 种重新投放           │
          └──────────────────────────────────────────┘
```

---

## 2. 文件职责一览

| 文件                                 | 行数  | 角色                      | 加载                           |
| ---------------------------------- | --- | ----------------------- | ---------------------------- |
| `Suk_OceansMapGen.lua`             | 15  | 编排：按固定顺序 include 其余文件   | AddGameplayScripts           |
| `Suk_MapConvolution.lua`           | 169 | 通用二维网格类：高斯模糊 + 归一化      | include（第 1 个）               |
| `Suk_ContinentJumpFlood.lua`       | 190 | 把**每一格**（含水域）判给最近的大洲    | include（第 2 个）               |
| `PlotIterators.lua`                | 209 | 六边形环形/面状迭代器（协程实现）       | include（ResourceGenerator 内） |
| `Suk_KelpGenerator.lua`            | 175 | 铺海藻森林                   | include（第 5 个）               |
| `Suk_ResourceGenerator.lua`        | 418 | 按大洲重新投放海洋奢侈品            | include（第 6 个）               |
| `Suk_TemperatureLens.lua` + `.xml` | 107 | 温度透镜 UI —— **死代码，从未加载** | 无                            |

`Suk_OceansMapGen.lua` 的 include 列表还有两个不属于 Suk 的：

```lua
include "Suk_MapConvolution"
include "Suk_ContinentJumpFlood"
include "MapEnums"          -- ← 解析到 HD 的副本
include "MapUtilities"      -- ← 解析到 HD 的副本
include "Suk_KelpGenerator"
include "Suk_ResourceGenerator"
```

`include` 按**文件名**在 VFS 里查，HD 用 `ImportFiles` 覆盖了 `MapEnums.lua` 和
`MapUtilities.lua`，所以这里加载的是 HD 的版本。

> **这给 HD 立了一条约束**：`Maps/Utility/MapEnums.lua` 和 `Maps/Utility/MapUtilities.lua`
> 会在 **gameplay 上下文**里被完整执行一遍，不只是在地图生成时。改这两个文件时，
> 顶层语句必须在"地图已经生成完、没有 `plotTypes` 表"的环境下也能安全跑完。
> 目前它们的顶层只有 `include`、`GetGameInfoIndex()` 读表、和一个 `local g_IslandLayer = {}`，
> 都是安全的。将来往里加顶层可执行代码要记得这一点。

---

## 3. 逐个文件

### 3.1 `Suk_OceansMapGen.lua` —— 编排

只有 include，没有别的。文件头的注释说明了它存在的理由：
"This file will help us control the order of operations between the two Lua scripts"。

顺序是有意义的：**海藻先铺，海洋资源后放**。见第 4 节。

### 3.2 `Suk_MapConvolution.lua` —— 通用网格与高斯模糊

一个手写的"类"（`setmetatable` + `__index`），负责把一张按格子编号的数值表做
高斯模糊再归一化到 `[0,1]`。海藻和资源都拿它来把"点状信号"抹成"场"。

提供的东西：

- `g_Suk_GaussianKernel_3x3 / 5x5 / 7x7` —— 三个预算好的高斯核
- `Suk_iter2D(x1,y1,x2,y2)` —— 二维遍历迭代器，返回 `x, y, 线性下标`
- `Select(n, ...)` —— 取第 n 个返回值，实现依赖 Lua 5.0 时代的 `arg` 表
- `Suk_MapConvolution:new(padding, limiter)` —— 建实例
- `:Get(x,y)` / `:Set(x,y,v)` —— 越界时按 `m_WrapX/m_WrapY` 环绕，否则用 `padding` 补
- `:DoConvolution(kernel)` —— 返回**新对象**，逐格做卷积
- `:DoNormalise()` —— 原地 min-max 归一化

两个需要留意的实现细节：

```lua
Suk_MapConvolution = {
    m_MapWidth  = Map.GetGridSize();              -- 类级字段，首次加载时抓一次
    m_MapHeight = Select(2, Map.GetGridSize());   -- 全文件唯一一处绕 arg 表
    m_WrapX     = Map:IsWrapX();
    m_WrapY     = Map:IsWrapY();
```

尺寸是**类级常量**，不是每个实例现取的。`DoConvolution` 拿它们当循环上界重建网格，
所以它们一旦和真实地图尺寸不符，网格尾部就会没人写。

```lua
DoNormalise = function(self)
    local iMin, iMax = 0, 0                     -- 初值是 0，不是首个元素
    ...
    local iRange = iMax - iMin
    for i,v in pairs(self.m_MapGrid) do
        self.m_MapGrid[i] = (v - iMin)/iRange    -- iRange 为 0 时 → 0/0 = NaN
    end
end
```

因为 `iMin`/`iMax` 从 0 起算而不是从首个元素起算，**全零的图会得到 `iRange == 0`**，
于是每一格都变成 NaN。这是第 6 节那个缺陷的起点。

### 3.3 `Suk_ContinentJumpFlood.lua` —— 把海也分给大洲

Suk Oceans 的核心卖点是"每个大洲的海岸出产不同的奢侈品"。可原版的
`plot:GetContinentType()` 对**水域返回 -1** —— 海不属于任何大洲。所以要先给每个
水格找一个"最近的大洲"。

用的是 **Jump Flooding Algorithm**（跳跃泛洪，GPU 上算 Voronoi 图的经典手法）：

1. `PackMap()` —— 每个 `GetContinentType() > -1` 的格子把自己登记成种子 `{x, y, 大洲}`；
   其余格子是 `{-1, -1, -1}`
2. `JumpFloodingStep(step)` —— 步长从 `2^ceil(log2(max(W,H)))` 起逐次减半到 1。
   每一轮，每个格子看自己和 8 个"步长距离"的邻居，谁的种子更近就抄谁的
3. 跑 `ceil(log2(max(W,H)))` 轮（44×26 的图是 6 轮）
4. `UnpackMap()` —— 输出 `{Continents = {[大洲id] = {格子...}}, Plots = {[格子] = 大洲id}}`

距离用像素坐标近似六边形距离：`px = sqrt(3) * (x + 奇数行偏移 0.5)`、`py = 1.5 * y`，
比较平方距离（不开根号）。东西/南北是否环绕按 `Map.IsWrapX/IsWrapY`。

**输出一定覆盖全图**：`UnpackMap` 对每个 `(x, y)` 都会 `table.insert`，
一格不落。完全没有大洲的图（理论上）会得到 `Continents[-1] = 全部格子`。

小瑕疵：`UnpackMap` 里 `tContinentPlots = {...}` 漏了 `local`，是个全局。不影响功能。

### 3.4 `PlotIterators.lua` —— 六边形迭代器

Civ6 modding 圈流传的通用片段（不是 Suk 原创，注释里带原始出处）。把地图的
`(x, y)` 偏移坐标转成六边形立方坐标，再用协程沿着六条边走一圈。

- `PlotRingIterator(pPlot, r, sector, anticlock)` —— 半径 r 的**环**
- `PlotAreaSpiralIterator(...)` —— 半径 r 以内的**面**，一圈一圈
- `PlotAreaSweepIterator(...)` —— 同样是面，按射线扫

Suk 只用到 `PlotRingIterator(pPlot, 1..3)`，用来给刚放下的奢侈品在周围三环
打上"附近已有奢侈品"的惩罚分。

### 3.5 `Suk_KelpGenerator.lua` —— 海藻森林

开头有幂等锁，靠 `Game:GetProperty("Suk_Kelp_Spawned")` 保证一局只跑一次（读档不重跑）。

**第一步：建"温度场"。** 名字叫温度，实际是拿地形和地貌打分再抹开：

| 来源              | 权重       |
| --------------- | -------- |
| 丛林              | **+375** |
| 沙漠 / 沙漠丘陵 / 沙漠山 | +150     |
| 苔原 / 苔原丘陵 / 苔原山 | −100     |
| 雪地 / 雪地丘陵 / 雪地山 | −50      |
| 冰               | −50      |
| 森林              | **−450** |
| 其它              | 0        |

地貌优先于地形（先查 `tFeatureMap` 再查 `tTerrainMap`）。然后**模糊三次**
（5×5、5×5、7×7）再归一化到 `[0,1]`。

> 所以"高纬度海藻更多"这个观感是对的，但驱动量**不是纬度，是邻近的地形地貌**。
> 而且森林的 −450 比苔原的 −100 还负，**森林海岸才是海藻最密的地方**，
> 比雪原海岸还密。这多半不是有意为之。

**第二步：挑候选格。** 水域 + 没有地貌 + `CanHaveFeature(KELP)` + 不邻接礁石 +
格子上的资源在 `Resource_ValidFeatures` 里和海藻兼容（`tValidResources`）。

**第三步：洗牌后逐格判定。**

```lua
iScore = 200
相邻已有海藻 0 个 → +0 ；1 个 → +175 ；2 个 → +100 ；3 个 → +0 ；4 个 → −100 ；5+ → −150
iMod = 1 - 温度场[本格]          -- 冷 → iMod 接近 1，热 → 接近 0
放置条件：GetRandomNumber(300) <= iScore * iMod
```

聚集加成让海藻成片而不是撒胡椒面；4 个以上开始扣分避免连成一大坨。

**目标覆盖率**：

```lua
local iKelpPercent = 25 + (MapConfiguration.GetValue("rainfall") or 0)
```

`rainfall` 是枚举（1=干旱 / 2=正常 / 3=湿润 / 4=随机），不是百分比。
所以实际目标是 26%~29%，"降雨量"这个设置对海藻的影响只有 ±3 个百分点，
基本等于没有。多半是想写 `+ 某个映射` 而不是直接加枚举值。

**两个健壮性问题**：

- `print("Percent Kelp Forests: ", (100 * iKelpCount) / iKelpablePlots)` ——
  没有可铺海藻的格子时是 `0/0`，日志里那句 `-nan(ind)` 就是它
- `local iMod = (1-tTemperatureMap.m_MapGrid[iPlot])` —— **没有 nil 守卫**。
  温度场缺格时会直接崩 `attempt to perform arithmetic on a nil value`

第二条是个有用的探针：如果 `Suk_MapConvolution` 的尺寸常量出问题，
**海藻会先崩，而且崩得比资源那边响得多**。

### 3.6 `Suk_ResourceGenerator.lua` —— 按大洲重投海洋奢侈品

同样有幂等锁 `Suk_Oceans_Resources_Spawned`。流程：

**① 取资源清单**

```sql
SELECT *, (ResourceType IN (SELECT DISTINCT Type FROM TypeTags WHERE Tag = 'CLASS_SUK_LAKE_ONLY'))
AS LakeOnly FROM Resources WHERE SeaFrequency > 0
```

按 `ResourceClassType` 分成 `tLuxuries` / `tBonuses`，另外记一张 `tLakeOnly`。

> **关于"只能生成在湖里"**（群里问到的）：靠的是 `TypeTags` 上的
> `CLASS_SUK_LAKE_ONLY` 标签，加上 Lua 里这一句：
> 
> ```lua
> function CanHaveResource(pPlot, iResource)
>     if tLakeOnly[iResource] then
>         return ResourceBuilder.CanHaveResource(pPlot, iResource)
>            and pPlot:IsLake() and (pPlot:GetResourceType() == -1)
>     ...
> ```
> 
> **不是 `LakeEligible` 列**。`LakeEligible` 只表示"允许出现在湖里"，做不到"只能在湖里"。
> 原版 Suk 只给**鱼子酱**（`RESOURCE_SUK_CAVIAR`）打了这个标签。
> HD 在 `ModSupport/SukOceans/DL_Adaptation.sql` 里给龙虾和海豹开了 `LakeEligible = 1`，
> 那是"也可以进湖"，不是"只在湖里"。要新增湖限定资源，得往 `TypeTags` 插一行。

**② 资源丰度设置**

```lua
iTargetPercentage = 40 + ({[1]=-3, [3]=3, [4]=随机-4..4, [25]=25, [45]=45})[资源设置] or 0
```

**③ 判大洲** —— 调 `Suk_GetPlotContinents()`（3.3 节），顺手存进
`Game:SetProperty("Suk_Oceans_ContinentsData")` 和 `ExposedMembers`，供别的脚本用。

**④ 建两张热力图**（奢侈品一张、加成资源一张）

逐格取值：水格且已有对应类别的资源 → 500，否则 → 0。
然后 3×3 + 5×5 高斯模糊、归一化。热力图的意思是"这附近已经有多少同类资源"，
后面用来**避开**已有的密集区。

**⑤ 顺手把所有水域奢侈品删光**

```lua
if iLuxWeight > 0 then
    ResourceBuilder.SetResourceType(pPlot, -1)     -- 原版第 13 步放的水域奢侈全没了
    iNumLuxuries = iNumLuxuries + 1
end
print("Removed luxuries from " .. iNumLuxuries .. " tiles")
```

**⑥ 每个大洲抽 2 种奢侈品** —— 按 Score 加权、不放回地抽两张"牌"
（`DrawRandomCards`）。抽中之后把该资源在**所有**大洲的分数扣掉，
让它不容易在别处再被抽中，这就是"每个大洲的海岸不一样"的实现。

**⑦ 投放** —— 按热力图分数排序候选格，逐格判定：

```lua
iWeight = 本格热力 / 最大热力
iScore  = (iWeight^0.666) * (6 - 附近奢侈品数) * 0.1666 * 100
湖限定资源额外乘 iLakesMultiplier（放宽）
放置条件：GetRandomNumber(100) <= iScore
```

放满 `iTargetOccurences` 个就停。**一个都没放成时**有个兜底分支，无视权重从头铺
`ceil(target/2)` 个。

### 3.7 `Suk_TemperatureLens.lua` / `.xml` —— 死代码

一个显示温度场的透镜 UI。**没有加载，也不可能工作**：

- modinfo 的 `AddUserInterfaces` 块是空的，一个 `<File>` 都没有
- 就算挂上也会立刻崩：它读 `ExposedMembers.SukTemperature.m_MapGrid`，
  而海藻生成器里那行 `ExposedMembers.SukTemperature = tTemperatureMap` **是注释掉的**

作者调试完之后关掉忘了删。

---

## 4. 顺序带来的三个后果

### 4.1 海藻和海洋资源对出生点是隐形的

它们在 `AssignStartingPlots`（第 14 步）**之后**才出现。HD 的出生点肥沃度计算
（`__DLPreparePlotFertilities`）完全看不到它们。

所以：**开不开海洋模式，同一个地图种子的出生点是一样的**。
反过来说，海洋模式带来的收益也不会被均衡逻辑折算进出生点评分 ——
沿海文明在开了海洋模式之后会白赚一截。这是个设计取舍，不是 bug，
但配平时要知道。

### 4.2 海藻先于资源，让路是单向的

海藻挑格子时会避开"资源不兼容"的格子（`tValidResources`），
而资源投放只受 `ResourceBuilder.CanHaveResource` 约束（它会查 `Resource_ValidFeatures`）。

于是：**海藻让着原版已有的资源；新投放的海洋奢侈品让着海藻。**
HD 往 `Resource_ValidFeatures` 里加东西（比如给鱼子酱开礁石）会直接改变这个让路关系。

### 4.3 改 Suk 不会让地图种子失效

两个脚本都调 `TerrainBuilder.GetRandomNumber`，用的确实是**地图种子**那条随机流。
但因为它们在 `GenerateMap()` **之后**才跑，前面的地形、河流、湖泊、地貌、
自然奇观、出生点已经全部定稿。

所以改 Suk 的代码**只会改同一种子下海洋资源和海藻的分布**，
不会动陆地。这比改 HD 的地图脚本安全得多 —— 那边任何改动都会让老种子作废。

---

## 5. HD 侧做了哪些适配

`ModSupport/SukOceans/`，条件 `Suk_Oceans_Rework_Expansion2`：

| 文件                      | 内容                                                 |
| ----------------------- | -------------------------------------------------- |
| `DL_Adaptation.sql`     | 龙虾/海豹开 `LakeEligible`；调整产出；渔场可建在海藻上；鱼子酱可在礁石上；水族馆改造 |
| `HD_Texts.sql`          | 文本                                                 |
| `HD_Monopoly_Texts.sql` | 与"垄断与公司"模式叠加时的文本                                   |

另外 `ModSupport/Resourceful2/HD_Resourceful2.sql` 也会碰 `SeaFrequency`
（虎鲸、鱼子酱），所以同时开 Resourceful 时海洋资源池会变。

---

## 6. 已知缺陷

### 6.1 全零热力图 → 除零 → 加权投放整段失效（已证实）

`DoNormalise` 的 `iMin`/`iMax` 从 0 起算，所以**图上一格水域奢侈都没有时**，
热力图全零、`iRange == 0`、每一格变成 `0/0 = NaN`。

拿真实的 `Suk_MapConvolution.lua` 跑 44×26 验证过：**1144 格全部 NaN**。

NaN 一路往下传：

```lua
iMaxWeight 保持 0            -- NaN > 0 恒假
iWeight = NaN / 0 = NaN
iScore  = NaN
GetRandomNumber(100) <= NaN  -- 恒假，一格都不放
```

于是所有资源掉进 `iOccurences == 0` 的兜底分支，**完全无视热力图**从头往下铺。
Suk 那套"按热力图分散布置"的逻辑在湖多海少的图上等于没跑。

这个缺陷**不崩也在生效**。

### 6.2 `Suk_ResourceGenerator.lua:354` 崩溃（触发条件未定）

```
Runtime Error: Suk_ResourceGenerator.lua:354: operator < is not supported for number < nil
stack traceback:
    Suk_ResourceGenerator.lua:354: in function '(anonymous)'
    [C]: in function 'table.sort'
    Suk_ResourceGenerator.lua:353: in function '(main chunk)'
    [C]: in function 'lInclude'
    Suk_OceansMapGen.lua:14: in function '(main chunk)'
```

**后果**：报错一路抛到 `include`，把整个脚本打断，`tResourcesToPlace` 剩下的条目
一个都不放。日志那局崩在**第一条**（AMBER），所以那张图海洋奢侈品是 0。
如果 6.1 那步删掉了 N 个原版水域奢侈品然后早早崩掉，那 N 个也一起没了
（日志那局删了 0 个，所以只是"没有新增"）。而且脚本开头就设了幂等锁，**读档不重试**。

**NaN 不是崩因。** 把 Lua 5.1 `ltablib.c` 的 `auxsort` 照抄一份插桩测过：
比较函数恒假（全 NaN 就是这种，因为 `NaN > NaN` 是假，在严格弱序意义下是合法的
"全部相等"）时，长度 1..259 全部**零次**越界读取；只有比较函数恒真时才会在 n=4
把 `nil` 喂给比较函数。所以 `tPlotsData.LuxuryWeight` 里必须存在**真正的 nil**，
而 `number < nil`（恰好一个操作数是 nil）说明那张表是**部分填充**。

**唯一的写入点**：

```lua
for iPlot = 0, #tPlotsData.Plots do
    tPlotsData.LuxuryWeight[iPlot] = tLuxuryMap.m_MapGrid[iPlot]
    tPlotsData.BonusWeight[iPlot]  = tBonusMap.m_MapGrid[iPlot]
end
```

- `#tPlotsData.Plots`：该表键是 0..N-1，`#` 返回 N-1，循环 `0..N-1` 刚好覆盖全图。
  实测 1143 / 1144 格，打散顺序赋值也一样。**它不是那个洞**，
  但它是个雷 —— 覆盖范围挂在另一张表的 `#` 上，而 `#` 是 border 不是计数。
- `tLuxuryMap.m_MapGrid` 短了：这张表被 `DoConvolution` 整体重建，
  上界是 3.2 节那两个类级常量。一旦不符，网格尾部就没人写；
  而 `DoNormalise` 用 `pairs` 遍历，**只改已存在的键，填不了洞**。

**这个嫌疑有硬伤**：海藻用同一套卷积而且**没有 nil 守卫**（3.5 节），
尺寸常量若全局出错，正常有海岸的图上海藻会先崩、且崩得很响。
日志那局恰好 `iKelpablePlots == 0` 掩住了。
**所以可以直接验伪：问报告者有没有见过海藻相关的 Lua 报错。没见过就基本排除。**

**没复现出来**：用真实源码搭桩跑过 44×26 / 单大洲 / 18 个湖 / 无海岸的图
（照日志那局建的），跑得通，CAVIAR 和 AMBER 都放了（走的正是 6.1 的兜底分支）。

### 6.3 修改方案

交付方式都一样：把文件 vendor 进 HD，用 `ImportFiles` + `criteria="Suk_Oceans_Rework"`
覆盖 —— `include` 按文件名解析，HD 的副本会赢。HD 已经这么盖过
`Suk_YieldTT.lua`、`YellowCraneGreatPeople.lua`、`TradeSupport.lua`。

**方案 B —— 只 fork `Suk_MapConvolution.lua`（169 行）**

```lua
-- ① 归一化：全图同值时整体置零，而不是除零
DoNormalise = function(self)
    local iMin, iMax = 0, 0
    for _, v in pairs(self.m_MapGrid) do
        iMin = math.min(iMin, v); iMax = math.max(iMax, v)
    end
    local iRange = iMax - iMin
    if iRange == 0 then
        for i in pairs(self.m_MapGrid) do self.m_MapGrid[i] = 0 end
        return
    end
    for i, v in pairs(self.m_MapGrid) do
        self.m_MapGrid[i] = (v - iMin)/iRange
    end
end

-- ② 尺寸每个实例现取，彻底摆脱类级常量和 Select/arg
new = function(self, padding, limiter)
    local o = {}
    setmetatable(o, self); self.__index = self
    o.m_MapWidth, o.m_MapHeight = Map.GetGridSize()
    o.m_WrapX, o.m_WrapY = Map.IsWrapX(), Map.IsWrapY()
    o.m_Padding, o.m_Limiter = padding, limiter
    o.m_MapGrid = {}
    return o
end
```

修掉 6.1（已证实的缺陷）并干掉 6.2 的主嫌疑，顺带也保护了海藻。
**代价**：①会改变行为 —— 它把目前形同死码的加权投放段激活了，
湖多海少的图上海洋资源分布会变（我认为是变好，但确实是改动）。

**方案 A —— 再 fork `Suk_ResourceGenerator.lua`（418 行，diff 只有 3 行）**

```lua
-  for iPlot = 0, #tPlotsData.Plots do
-      tPlotsData.LuxuryWeight[iPlot] = tLuxuryMap.m_MapGrid[iPlot]
-      tPlotsData.BonusWeight[iPlot]  = tBonusMap.m_MapGrid[iPlot]
+  for iPlot = 0, iWidth * iHeight - 1 do
+      tPlotsData.LuxuryWeight[iPlot] = tLuxuryMap.m_MapGrid[iPlot] or 0
+      tPlotsData.BonusWeight[iPlot]  = tBonusMap.m_MapGrid[iPlot]  or 0
   end

-      return tPlotsData.LuxuryWeight[a] > tPlotsData.LuxuryWeight[b]
+      return (tPlotsData.LuxuryWeight[a] or 0) > (tPlotsData.LuxuryWeight[b] or 0)
```

按地图尺寸铺满、缺失补 0、比较函数兜底。**数据正常时这三行完全不改变行为**，
对未知崩因免疫。

**建议**：A + B 一起做。fork 的**行数**（587）不等于**维护成本** ——
我们的 diff 只有十几行，Suk 哪天更新了 `git diff` 一眼就能重新贴上。
不修的代价是玩家在某类图上静默丢掉全部海洋奢侈品，不报错、不提示、读档不重试。

动手之前有两件很便宜的事值得先做：

1. 找报告者要同一局的 `Database.log` / `modding.log` 和确切的地图与设置
2. 问他有没有见过**海藻**相关的报错（见 6.2 的验伪思路）
