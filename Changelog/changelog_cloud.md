# changelog — cloud 分支

bingyang1132 的长期分支。本文件按时间倒序记录本分支的改动。

---

## 2026-08-10

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

### 未处理，待定

- `Gameplay/Misc.lua:145` 城邦弓箭手回合数仍用 `math.random(min, max)`。它在游戏侧不在地图侧，
  不影响地图种子，但同样有 desync 风险。
- `AddVolcanicSoil()` 里火山土 feature id 硬编码为 `35`，未用 `MapEnums.lua` 已有的
  `g_FEATURE_VOLCANIC_SOIL`。当前工作正常，属健壮性问题。

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
