# changelog — cloud 分支

bingyang1132 的长期分支。本文件按时间倒序记录本分支的改动。

---

## 2026-08-11（四）

Suk 那条交给 leader 了，这次把剩下两条做掉。**两条都会改地图、让老种子作废。**

### 世界纪元：改成"步长"作用在硬编码基准上（10 张图）

硬编码值是长期调出来的，所以不直接放开，而是把它当"标准纪元"的基准，
全局设置只提供 `-1 / 0 / +1` 的步长。两个消费者用**不同的作用方式**，因为量纲不同：

- `ApplyTectonics` 里 `world_age` 的每一处都是加减（`28±age`、`97-age`、`91-2*age`…），
  单位是分形百分位点，关心绝对差 → **加法，步长 0.5**
- `mountainRatio = A + C*B` 里 `B` 在 10 张图上从 4 变到 12，加法会产生
  +18%~+55% 不等的变化 → **乘法，×(1 ± 0.2)** 乘在最终值上

步长取 0.5 不取 1，是为了躲开两个点：`adj == 0` 会让丘陵带宽度归零
（9 张图的基准是 1，减 1 就踩上），`adj == 3` 是 `adjust_plates` 的阶跃点
（Highlands_XP2 的基准是 2，加 1 就踩上，板块数突跳 33%）。

Great_Sand_Sea / Great_Steppe / Highlands_XP2 另有一份内联的同类块，
里面的 `if world_age <= world_age_old` 改成判基准值 —— Great_Steppe 的
`world_age_old` 正好等于它的基准 1，不锁住的话步长 +1 会让它从真变假。

**"标准"档：七张图与改动前逐位一致**（脚本核对过）。

**顺带发现并修掉了第二个缺陷**：`MapConfiguration.GetValue("world_age")` 返回的是
设置序号 1/2/3，但 Forest_Highlands（比 3/5/7）、Great_Sand_Sea（比 3/7/10）、
Highlands_XP2（比 3/5/7）拿它去比自己的 `world_age_*` **常量**。后果是这三张图
选「老世界」会命中第一个分支拿到 `world_age_new`（方向反了），选「新」和「标准」
则全部掉进 `else` 变成随机。因为外层 `world_age` 是活的（喂火山数量那条路径），
所以这三张图**改之前火山数量基本是随机的**。像是有人改了常量之后顺手把比较的
数字也一起改了，没意识到被比较的是设置序号。

代价：这三张图的"标准"档会变（它本来就是坏的），而且在"新"和"标准"档上比以前
**少抽一次随机数**，随机流会平移。

### 河流：补上北边界漏掉的那一类断头河

先量再改。新增 [tools/maptest/river.lua](../tools/maptest/river.lua)，直接加载真实的
`RiversLakes.lua`，桩掉十来个引擎接口，在 72 张随机图上起河 43171 次：

```
走到 NO_FLOWDIRECTION（断在陆地上）：29 次
  按位置：北边界 y=H-1  29        ← 内陆 0、南边界 0，与穷举结论一致
  按组合：this=NORTH orig=NORTHEAST  24    ← 原版补丁救得回
          this=NORTH orig=NORTHWEST   5    ← 原版救不回
```

12 种理论组合里**实际只出现 2 种**，而且 `thisFlowDirection` 都是 `NORTH`。

原版的补丁条件是 `originalFlowDirection == FLOWDIRECTION_NORTHEAST`，
但决定"河现在停在这一格哪个角"的是 **`thisFlowDirection`** —— 补的那两条边只和
"以 NORTH 流向到达"有关，跟这条河最初往哪流没关系。**原版判错了变量**，
只是绝大多数时候两者恰好同时成立。

改成只做加法（保留原条件，另外补按 `thisFlowDirection` 判），
结果 **29 次断头全部补上、未补 0 次**，河流边数 91596 → 91606。

顺带在断头处加了一句诊断 `print("RIVER DEAD END: ...")`，游戏里也能用，
可以核对实机分布是否和离线一致。

**没做**：南边界一个样本都没有，不写没有依据的代码（真要补也只有一种可能 ——
每个格子只拥有 W/NW/NE 三条边，y=0 时 SW/SE 边属于图外格子根本设不了）。
"撞上已有河流提前 return"那一类不在边界上，补边界解决不了。

**测试覆盖到哪**：`river.lua` 不做"河道是否连通到水/边界"的几何校验 ——
那需要一套六边形顶点模型，而 `W/NW/NE-of-river` 标志位和 `DoRiver` 里
"startPlot 的某个角"这个约定的对应关系在游戏外没法验证，与其给个自己都不敢信的
数字不如不给。它另外钉住了补丁的**形状**：每次修复必须恰好铺同一格的 NW + W
两条边（靠铺边事件的先后顺序判断）。四种人为变异全部被抓到。

`drive.py` 现在会依次跑 `run.lua` 和 `river.lua`，各用一个干净的 Lua 状态。

---

## 2026-08-11（三）

### 新增 docs/SukOceans.md

把 Sukritact's Oceans 相关的内容从 `MapGeneration.md` 拆出来单独成文。
内容：7 个 Lua 文件逐个的职责、它们在 HD 主流程里的**位置**、
顺序带来的后果、HD 侧的适配、以及那个崩溃的完整分析与修改方案。

关键结论是**位置**：它是 `AddGameplayScripts`，在 `GenerateMap()` 的 15 步
全部结束之后才跑。由此推出三件事：

- 海藻和海洋资源对 `AssignStartingPlots` 是**隐形的** ——
  开不开海洋模式，同一地图种子的出生点一样；反过来海洋模式的收益也不会被
  均衡逻辑折算进出生点评分
- 海藻先于资源，让路是单向的：海藻让着已有资源，新资源让着海藻
- **改 Suk 的代码不会让老地图种子失效**，只改海洋资源分布

顺带发现的两件事：

- `Suk_OceansMapGen.lua` 会 `include "MapEnums"` 和 `include "MapUtilities"`，
  而 `include` 按文件名解析 —— 拿到的是 **HD 的副本**。也就是说这两个文件会在
  **gameplay 上下文**里被完整执行一遍。给 HD 立了条约束：它们的顶层语句必须在
  "地图已生成完、没有 plotTypes"的环境下也能安全跑完。目前是安全的。
- `Suk_TemperatureLens.lua` / `.xml` 是死代码：modinfo 的 `AddUserInterfaces`
  块一个 `<File>` 都没有，而且海藻生成器里那行
  `ExposedMembers.SukTemperature = tTemperatureMap` 是注释掉的，挂上也会立刻崩。

另外把海藻的机制写清楚了：所谓"高纬度海藻更多"的驱动量**不是纬度，是邻近地形地貌**
打分后高斯模糊三次的结果，而且森林的权重 −450 比苔原的 −100 还负，
**森林海岸才是海藻最密的地方**。以及"只能生成在湖里"靠的是 `TypeTags` 上的
`CLASS_SUK_LAKE_ONLY` 加 Lua 里的 `IsLake()` 判断，**不是 `LakeEligible` 列** ——
`LakeEligible` 只表示"允许进湖"。

### 5.4 河流：穷举确认死胡同只可能在首末行

把 `DoRiver` 方向搜索的三个约束穷举了一遍。六个流向用来打分的相邻格里，
只有指向南北的会拿到 nil（东西向环绕），所以**内陆不可能出现死胡同**。
共 13 种组合，其中 1 种在递归里不可达，**实际可达 12 种：北边界 10、南边界 2**，
而原版的 `NORTH EDGE OF MAP RIVER REPAIR` 只覆盖了 2 种。

按 leader 的方向（不回滚、补边界）写了三步落地方案：先加诊断输出量出
12 种组合里实际发生哪几种、每图几条；再按"格子只拥有 W/NW/NE 三条边"推每种的出口
（南边界只有一种补法，因为 SW/SE 边属于图外邻格根本设不了）；
最后在 `tools/maptest` 里断言一条不用看图的性质 ——
每条河的边集合连通、终点顶点落在水域格或地图上下边界上。

### 5.3 世界纪元：给出可落地的"步长"方案

先更正一处方向错误：`mountainRatio` 是**除数**（每几格陆地一座山），
越大山越少。之前写"放开等于统一加 1.5～2.4 倍山脉"是反的 ——
放开之后孤峰**变少**、造山带**变多**，是一次再分配。
日志能对上：Great Steppe `mountainRatio = 22`、`New Mountains 50`、陆地约 1100 格。

还厘清了一件事：世界纪元**没有完全失效**。三个下游消费者里，
`AddTerrainFromContinents`（火山数量）拿的是**外层活的** world_age，一直在生效；
失效的只有 `ApplyTectonics` 和 `mountainRatio`。

方案要点是**两个消费者用不同的作用方式，因为量纲不同**：

- `ApplyTectonics` 里 `world_age` 的每一处都是加减（`28±age`、`97-age`、
  `91-2*age`…），单位是分形百分位点，关心绝对差 → **用加法**。
  用乘法会让同一个设置在 C=1 和 C=2 的图上含义不同。
- `mountainRatio = A + C*B` 里 `B` 在 10 张图上从 4 变到 12，
  加法步长在各图上会产生 +18%~+55% 不等的变化 → **用乘法**乘在最终值上。
- 步长取 **0.5 而不是 1**，为了躲开两个点：`adj == 0` 会让丘陵带宽度归零
  （9 张图的 C 是 1，减 1 就踩上），`adj == 3` 是 `adjust_plates` 的阶跃点
  （Highlands_XP2 的 C 是 2，加 1 就踩上，板块数突跳 33%）。

最重要的性质：**"标准"档与今天逐位一致**（步长 0 时两处都退化成原值）。
顺带修掉随机档的量纲不一致（现在是 `1 + rand(3)` 取 1..3，
而映射常量可能是 3/5/7）。

---

## 2026-08-11（二）

### 火山土不再覆盖三种泛滥平原

`Utility/MapUtilities.lua` 的 `CanTakeVolcanicSoil` 多排除
`FEATURE_FLOODPLAINS` / `_GRASSLAND` / `_PLAINS`。

理由：洪水判定看的是河流而不是地貌，把泛滥平原盖成火山土之后那一格照样发洪水，
只是不再有泛滥平原了。这种"会发洪水但没有泛滥平原"的地块是给下游逻辑埋雷。
代价是火山紧邻泛滥时一环会少铺几格，刻意接受。其它普通地貌照旧可以被覆盖。

**这会改地图，也会让老种子失效**：二环的随机抽取写在 `CanTakeVolcanicSoil` 内部，
多排除一类地貌就少抽几次，整条随机流随之平移。

**回归覆盖**：差分测试加了 `v4` 一节，46 个用例（新增"火山旁的泛滥平原"专项用例，
并让 40 张随机图有 6% 概率生成泛滥平原）。
`place` 模式下断言 v3→v4 的差异**恰好**是"v3 铺成火山土、v4 保留原地貌"的泛滥格，
其它一格没动，共保住 357 格、涉及 41/46 个用例；`stream` 模式下断言不变式
"跑完之后没有任何泛滥格是火山土"。五种人为变异（删守卫、只排一种、写反、
去掉 `eFeature == -1` 提前返回、顺手删掉奇观守卫）全部被抓到。

### 排查：三个未修的地图缺陷已记录

来自群里反馈的 5 条，详见 [MapGeneration.md 第 5 节](../docs/MapGeneration.md)：

- **5.3 世界纪元被屏蔽**：10 张图在 `GeneratePlotTypes` 开头用
  `local world_age = 1;` 遮住了入参。`Archipelago_XP2` 那份原版就有，其余 9 张是 HD 侧引入的。
  **没有直接删**：硬编码值是长期调出来的，直接放开连"正常"档都会大幅偏离今天的观感
  （Forest_Highlands 的 mountainRatio 从 21 变 41，孤峰直接减半）。属于配平而非修 bug。
- **5.4 河流没有入海口**：`DoRiver` 有两条通往内陆断头的路，原版只给北边界
  `FLOWDIRECTION_NORTHEAST` 一种情况打了补丁。给出了两条修法（回滚整条 / 推广边界补丁）
  及各自代价。顺带确认 `GetRiverValueAtPlot` 里那段 cliff/自然奇观 `return -1`
  在标准流程里是死代码（`AddRivers` 排在 `AddCliffs` 和自然奇观之前）。
- **5.5 Suk's Oceans 崩溃**：`Suk_ResourceGenerator.lua:354`。报错一路抛到
  `Suk_OceansMapGen.lua:14` 的 include，把整个脚本打断；日志那局崩在第一条资源上，
  所以那张图**一个海洋奢侈品都没有**。
  已证实 `Suk_MapConvolution.DoNormalise` 在热力图全零时除零，把 1144/1144 格权重
  变成 NaN，加权放置段因此完全失效 —— 这是个不崩也在生效的独立缺陷。
  但**照抄 Lua 5.1 的 auxsort 插桩测过，恒假的比较函数在长度 1..259 上零次越界读**，
  所以 NaN 不是崩因：`LuxuryWeight` 里必须有真 nil，且 `number < nil` 的形态说明
  那张表是**部分填充**。嫌疑落在 `Suk_MapConvolution` 的类级
  `m_MapWidth` / `m_MapHeight` 上——`DoConvolution` 拿它们当上界重建网格，
  而 `DoNormalise` 用 pairs 遍历，填不了洞。用真实源码搭桩仍未复现，触发条件未定。
  一个好消息：该脚本是 AddGameplayScripts，在 `GenerateMap()` **之后**才跑，
  改它不影响 HD 的地形/河流/出生点，也不会让老地图种子失效。

---

## 2026-08-11

### 去重：三个函数的 58 份副本合并成 3 份

净减约 2500 行。

| 函数 | 原副本数 | 情况 |
|---|---|---|
| `AddVolcanicSoil` | 25 | 24 份逐字相同，Primordial 只差二环概率，提成入参 |
| `Adjacent` | 22 | 全部逐字相同（只差制表符/空格缩进） |
| `AdjacentCount` | 11 | 同上 |

都放进 `Utility/MapUtilities.lua` 而不是新建文件：25 个脚本已经全部 include 了它，
不用动 modinfo，也就没有 VFS 解析失败的风险——那是唯一一个在游戏外验证不了、
而且一旦出错会直接让地图生成崩掉的失败模式。代价是 MapUtilities 变长，
将来按主题拆分是另一件安全的事。

`Adjacent` / `AdjacentCount` 原本读地图脚本的文件级 `local islands`，跨文件后拿不到
那个 upvalue，所以状态一起搬进 MapUtilities，地图脚本改用 `SetIslandLayer()` 写入
（87 处）。初值用空表而不是 nil，与原来的 `local islands = {}` 行为一致。

**回归覆盖**：差分测试加了两节。`v2 ≡ v3` 覆盖 AddVolcanicSoil 的两条入参路径
（默认值对应 24 张图，传 2 对应 Primordial，各与合并前的对应版本逐格比对）；
新增一节对 18646 个格子逐个比对 `Adjacent` / `AdjacentCount` 搬迁前后的返回值。
两节各做了四种人为变异，全部能被抓到。

**没有合并 `GenerateFractalLayerWithoutHills` 的 22 份**：它们是 18 个真实变体
（Lakes 与 Tiny_Islands 差 59 行 / 共 117 行，后者只有 80 行），不是复制粘贴。
合并等于拿 22 个简单函数换一个参数汤。

### 删掉十张图里不可达的填海分支

`AdjacentCount` 的值域是 0..6（相邻陆地数）加哨兵 7（自己已是陆地，被上一分支拦截）。
11 张用它的图里只有 Lakes 的阈值 `> 1` 可达，其余 10 张写的是 `> 8`、`> 9`、`> 12`、
`> 13`、`> 16`，**从来没执行过**。数值形态像是作者想让填海更保守、一路往上调，
超过 7 之后分支静默失效而不自知——而分支上方的注释描述的恰恰是"把周围陆地多的
海格变成陆地"。

删除不改变任何运行时行为（它本来就不执行，也从不抽随机数），只是让代码诚实。
留了注释记录值域，免得下次又写出越界阈值。

**两处对之前说法的更正**：

- 那 11 处 `math.random` 有 10 处在死代码里。海陆轮廓受种子失效影响的只有 Lakes
  一张图，不是当时提交信息里写的 11 张。
- 这 10 张图**该不该填海**是手感问题，留给 xhh 定，没有顺手重新标定阈值。

## 2026-08-10

### 清掉剩下四个地图缺陷（5.2–5.5）

趁人工测试还没铺开，把文档里列的四个小缺陷一次做完——每个都会让种子位移，
分四次提交就是让群里的人四次作废种子。合进 xhh_reborn 的三个提交之后一起发布。

**① `AddGoodies` 多放一个村庄**（[MapUtilities.lua:833](../Maps/Utility/MapUtilities.lua)）

```lua
-if (iNeedtoPlace >= 0) then      ...      if (iNeedtoPlace < 0) then break; end
+if (iNeedtoPlace > 0) then       ...      if (iNeedtoPlace <= 0) then break; end
```

计数从 N 递减到 0 都会放置，实际放了 N+1 个。**不消耗随机数**——洗牌在循环之前，
循环本身不抽——所以这一处不影响种子，只是村庄少一个。

**② 随机海平面取不到最低档**（15 个地图脚本）

```lua
-GetRandomNumber(sea_level_high - sea_level_low, "...") + sea_level_low + 1;   -- 41..50
+GetRandomNumber(sea_level_high - sea_level_low + 1, "...") + sea_level_low;   -- 40..50
```

固定档位是 40 / 45 / 50，随机档却取不到 40。只在海平面设为「随机」时生效；
抽取次数不变，但取值分布变了。

**③ 出生点肥沃度的浮点求和顺序**（[AssignStartingPlots.lua:490](../Maps/Utility/AssignStartingPlots.lua)）

原来用 `pairs(RingOnePlotYields)` 累加，而这个表是**字符串键**——是地图生成里唯一一处。
浮点加法不满足结合律，权重里又有 `1/3`、`2/3` 这类无限二进制小数，所以遍历顺序会影响末位。
Lua 5.1 的字符串哈希不随机化、顺序固定；5.2+ 才逐进程随机，而现有证据只能把 Civ6 缩到 ≤5.2。

改成按 `GameInfo.Yields()` 的行序累加。至此**地图生成的随机性完全收敛到地图种子**。

**④ 浮点 RNG 上界**（8 个脚本 × 3 处 = 24 处）

```lua
-GetRandomNumber(iBoundaryPlotsPerVolcano * 1.5, "Volcano 2 from boundary")
+GetRandomNumber(math.max(1, math.floor(iBoundaryPlotsPerVolcano * 1.5)), "Volcano 2 from boundary")
```

`iBoundaryPlotsPerVolcano` 来自除法，恒为浮点；不带乘数的那 8 处同样是浮点，
之前漏数了。除了依赖未声明的截断行为，更实际的问题是**值小于 1 时上界变 0，
`== 0` 恒真会让板块边界火山连片**。取整并夹到至少 1，保留「想要的火山数超过可用地块时
就铺满」这个意图。

差分测试仍然全绿（这四处都不在 `AddVolcanicSoil` 里）。

### 合入 xhh_reborn

`77ea7af 德国重做`、`feee1b1 宗教社区修改`、`840f58c 海外投资人修改`。
未触及 `Maps/`，无冲突。

### 差分测试：证明上面那批改动没有夹带私货

新增 [tools/maptest](../tools/maptest/)。起因是 leader 要求验证重写和原写法等价，
而"让资深玩家开很多档凭经验判断"成本太高。

**实机对比其实回答不了这个问题**：①②都减少了随机抽取次数，而地图随机流是共享有序的，
少抽一次之后所有随机结果整体位移。所以同一个种子在改动前后**必然**开出不同的图，
人眼看到的差异绝大部分来自流位移，和被改的逻辑无关。

桩掉 `AddVolcanicSoil` 实际用到的那 11 个引擎接口（六边形网格 + 东西环绕 + 可插拔
随机源），脱离游戏跑。

第一版设计是逐格解释 v1 与 v2 的差异，结果 47 个用例失败。差异是真的但无害——
自然奇观不再被铺掉之后，它自己会继续向外辐射火山土，所以重写版在某些格子上**多**铺了。
逐格解释要求预先想到所有间接后果，而这恰恰是想不全的。

改成把整批改动拆成一条链，每级只做一件事，然后断言两端精确相等：

```
v0   最初实现（math.random、硬编码 35）
v1   接入种子 + feature 枚举              断言 ≡ v0
v1a  只修 X 循环越界（缺陷 ①）
v1b  只换自然奇观守卫（缺陷 ②）
v2   实际发布的重写版                     断言 ≡ v1b
```

两条等式在 45 个用例 × 3 种随机模式下同时成立，且比对的是网格状态、
`SetFeatureType` 调用序列、抽取次数三项。级联效应同时出现在 v1b 和 v2 里，
于是不再需要解释。

结论：**v2 恰好等于 v1 + 缺陷① + 缺陷②，无第三种行为变化**；
而 `math.random → GetRandomNumber` 和 feature id → 枚举那两步是纯重构。

顺带确定了一件之前存疑的事：把 `Map.GetPlot` 越界改成返回 `nil` 之后 v1 会报错、
v2 不会——说明旧代码确实访问了 `x == mWidth`，而它在游戏里从没崩过，
所以 Civ6 的 `Map.GetPlot` 必然是东西环绕的。

四种人为破坏（改概率、去掉奇观守卫、改回越界上界、去掉山地守卫）都能被抓到，
测试不是空转。

### 清理死声明与一个 GBK 字节

都不影响地图输出：改的全是从未被读取的声明，或者注释。

- 23 个脚本的 `local featureGen = nil` 把名字写成大写 G，而赋值和读取用的是小写
  `featuregen`——于是声明是死变量、实际用的是全局。改成小写让两者绑定。
  Wetlands_XP2 压根没有声明（并且重复声明了两个 river 表），补上并去重。
  Terra 本来就是对的（函数内局部变量），不动。
- Continents / Frozen_Continents / Small_Continents 的 `local adjustment = world_age` 从未被读取。
- `MapUtilities.lua` 的 Fisher–Yates 注释里混了个 GBK 编码的破折号，使它成为
  `Maps/` 下唯一不合法 UTF-8 的文件；另有旧实现残留的 `local left_to_do`；
  以及 `TestMembership` 的参数名 `table` 遮蔽标准库，改为 `incoming_table`。

### `AddVolcanicSoil` 重写：修两个复制了 25 份的缺陷

审计地图代码时发现的，两个都在同一个函数里，于是一起重写。25 个地图脚本的这个函数
此前逐字相同，现在仍然逐字相同（只有 Primordial 的概率参数是 1/2，其余是 1/3）。

**① X 循环越界一格。**

```lua
for CoordinateX = 0, mWidth, 1 do        -- 改为 mWidth - 1
    for CoordinateY = 0, mHeight-1, 1 do -- Y 本来就是对的
```

同一个函数里 X 和 Y 写法不一致，是笔误。地图东西向环绕，`Map.GetPlot(mWidth, y)` 绕回
第 0 列，于是第 0 列被处理两次：该列火山的二环随机多摇一轮，覆盖率从 33%/56% 升到
约 55%/80%，还白耗一批随机数。只影响接缝那一列，但确实不对称。

**② 三处奇观排除名单互不一致。**

一环排除 2 个奇观特征，二环排除 5 个，而普通火山那一支一个都不排除。三处合并为一个
局部函数：

```lua
local function CanTakeVolcanicSoil(pPlot)
    if (pPlot:IsWater() or pPlot:IsMountain()) then return false; end
    local eFeature = pPlot:GetFeatureType();
    if (eFeature ~= -1 and GameInfo.Features[eFeature].NaturalWonder) then return false; end
    return true;
end
```

改用 `Features.NaturalWonder` 标志位，不再维护硬编码名单——和上面去掉 feature id 硬编码
是同一个思路。这比原来的名单**保护范围更大**：原先只有名单里那 5 个奇观受保护，
`IsMountain()` 又挡掉了其中 4 个（它们都在山地上），实际上只有恩戈罗恩戈罗火山口
（HD 把它设为 `Impassable = 1`，但不是山地）以及基础游戏里其它平地奇观
（撒哈拉之眼、伊克-基尔天然井等）会被火山土覆盖掉。现在一律不覆盖。

二环那个"每个一环邻格都向外摇一圈、所以角格 33%、边格 55.6%"的行为**刻意保留**——
改掉会显著改变火山土观感。代码里补了注释说明，免得下次被当成 bug 修掉。

顺带把 6 次重复的 `GameInfo.Features[...]` 查询提成一个局部变量 `sFeatureType`，无行为变化。

种子影响：两处改动都减少了随机抽取次数，所以老种子再次失效。

### 地图生成流程文档

新增 [docs/MapGeneration.md](../docs/MapGeneration.md)，讲清 `GenerateMap()` 的 15 个步骤、
随机数模型、以及 HD 相对原版改了什么。

文档放在新建的 `docs/` 下，专门存放说明文档；`tools/maptest/README.md` 留在工具目录里
不动，它是那个工具的使用说明。

末尾列出审计中发现但**仍未修**的问题：25 份复制粘贴、`AddGoodies` 多放一个村庄、
随机海平面取不到最低档、出生点肥沃度里字符串键表的浮点求和顺序，以及浮点 RNG 上界。
（原先列的 `local featureGen` 死变量和 GBK 字节已在本次一并修掉，不再列出。）

### 地图种子失效修复

`Maps/` 下 25 个地图脚本共 61 处用了标准 Lua 的 `math.random`，全部改为
`TerrainBuilder.GetRandomNumber`。

Civ6 只有 `TerrainBuilder.GetRandomNumber` 走地图 RNG，由 `MapConfiguration RANDOM_SEED`
（暂停菜单显示的地图种子）播种；`math.random` 是另一条独立的流，不接种子，也从未调用过
`math.randomseed`。因为 mod 覆盖了全部原版地图脚本，所有图都受影响：

- **`AddVolcanicSoil()`（25 张图，50 处）**：以 1/3（Primordial 为 1/2）概率给火山二环铺
  火山土。它跑在 `ResourceGenerator` 和 `AssignStartingPlots` 之前，改动的地块产出会连锁
  改掉资源评分和出生点 fertility，所以海陆轮廓相同时资源和出生点仍然全变。
- **`GenerateFractalLayerWithoutHills()`（11 张图，11 处）**：`math.random(a,b) <= adjCount`
  决定海洋格是否变陆地，直接改海陆轮廓。涉及 Lakes、Rivers、Rivers_And_Lakes、Wet_Lakes、
  Wet_Lakes2、Forest_Highlands、New_Highlands、Highlands_XP2、Northern_Mountains、
  Great_Sand_Sea、Great_Steppe。

概率按 `GetRandomNumber(n)` 返回 `0..n-1` 对齐：`math.random(n) == 1` → `GetRandomNumber(n) == 0`，
`math.random(a, b)` → `a + GetRandomNumber(b - a + 1)`。分布不变。

顺带修掉了多人游戏 desync 隐患——`math.random` 在各客户端的 Lua 状态不同步。

注意：新增的 `GetRandomNumber` 调用会消耗地图 RNG 流，因此**同一种子在本次修改前后生成的
地图不同**。这是一次性的，此后同种子可复现。

### 游戏侧 `math.random` 一并修掉

`Gameplay/Misc.lua:145` 城邦弓箭手回合数原用 `math.random(min, max)`，改为
`min + TerrainBuilder.GetRandomNumber(max - min + 1, "City State Archer Turn")`。
它在游戏侧不在地图侧，不影响地图种子，但同样有多人游戏 desync 风险；同文件 217 行的保底
战略资源本来就用的 `GetRandomNumber`，现在两处一致了。

至此除 `Gameplay/Religions.lua:23` 一行已注释的死代码外，仓库内无 `math.random`。

### 火山土 feature id 去硬编码

`AddVolcanicSoil()` 里 `SetFeatureType(plot, 35)` 共 125 处（每图 5 处，其中 2 处走随机、
3 处无条件），全部改为 `g_FEATURE_VOLCANIC_SOIL`（[MapEnums.lua:67](../Maps/Utility/MapEnums.lua) 已定义）。

原来同一个函数**读**特征用名字（`FeatureType ~= "FEATURE_SUK_FUJI"`）、**写**用数字，不一致；
周围代码本来也都在用 `g_FEATURE_VOLCANO` / `g_FEATURE_ICE`，现在统一了。行为等价——mod 自身
不往 `Features` 表插行，35 是基础游戏索引；此改动防的是第三方 mod 插行导致索引漂移。

## 2026-08-08

### 英文本地化补全（已由 xhh 合入 xhh_reborn）

补全 HD 自有内容缺失的英文文本共 160 条。这些条目此前只有中文，英文环境下游戏与百科
会直接显示 `LOC_` 原始标签。涉及 10 个文本文件。

- **总督**：平伽拉、维克多、梁、马格努斯、瑞娜、莫克夏、阿玛妮七位，全部晋升的英文名称与描述（100 条）
- **社区奇观**：但丁·阿利吉耶里、约翰·邓恩、莫里哀三位伟人的英文简介，及其六件巨作的名称与引言；
  环球剧院、哈利法塔的引言与百科历史
- **军备补全模式**：新增单位的英文描述，以及卧虎藏龙等三条单位能力描述
- **文化传播单位**：晋升描述、能力描述，以及杰利的名称与描述
- **其它**：纪念碑谷；化妆品、香水、牛仔裤、玩具四类资源分类；数条相邻加成提示

用词沿用仓库中已有的英文译法（辐射产出 regional yield、本体产出 base yield、
辐射范围 regional range tile、文化传播单位 Cultural Communicator，改良分类名取自
`HD_Text_Classifications.sql`）。巨作引言采用公共版权领域的英文原文，未从中文回译。

两点事后说明：

- **纪念碑谷**那几条是给已移除 mod 的遗留适配代码补的，标签实际无人引用，留着不生效。
  经 xhh 判断不必删除。
- **`ModSupport/Wonders/HD_Wonders_Community_text.sql` 那批是重复劳动**——工坊订阅的原 mod
  自带英文。当时的检查方法是「在 HD 仓库里找有中文没英文的标签」，但 `ModSupport/` 是给别人
  mod 做适配的，那些 mod 自带英文，所以「HD 仓库里缺」≠「游戏里缺」。正确的检查范围应包含
  `steamapps/workshop/content/289070`。重复只是噪音（`insert or replace` 后加载覆盖），
  不造成冲突，但可以清理。

### Borobudur 缺失时的报错处理（已由 xhh 合入）

Sukritact 的 Borobudur 源 mod 缺失时给出明确诊断，而不是静默失败。

---

## 待反馈给 xhh 的问题（本分支未改动，仅记录）

这三处都是从百科生成侧发现的，属于 mod 数据问题：

1. **`ModSupport/ModularAdjacencyBonus/Text.sql`**：英文那行标签写成
   `LOC_TRAIT_LEADER_HOLY_ROMAN_EMPEROR_DESCRIPTION`，中文那行是 `..._MAB`，看着是笔误——
   现在它会覆盖基础游戏巴巴罗萨的英文描述。已补 `_MAB` 那行，原行保留未删。
2. **`Texts/HD_Text_Governors.sql`**：末尾旅游总督 / 易卜拉欣 / 丹隆三位的模板行标签都是
   `LOC_GOVERNOR_PROMOTION_HD__*`（双下划线、三处重复），会互相覆盖，中文本身也还是空的，
   所以这三位没有补英文。
3. **`ICON_BUILDING_CANAL`** 被声明为 `ICON_ATLAS_EXHIBITION` 索引 0，和
   `ICON_BUILDING_EXHIBITION` 同一个槽位（该 atlas 是 1×1，只有一张图），
   所以百科里运河显示成会展中心。
