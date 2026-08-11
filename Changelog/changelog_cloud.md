# changelog — cloud 分支

bingyang1132 的长期分支。本文件按时间倒序记录本分支的改动。

---

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
