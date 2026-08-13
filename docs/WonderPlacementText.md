# 奇观建造条件：文本与实际效果一致性排查

起因：玩家反馈罗马斗兽场实际需要平坦单元格，但描述文本里没写。

原则：**以实际效果为准**，只改文本，不改数据库。

## 为什么会漏

奇观的建造条件分散在三处，只有前两处会显示：

| 条件来源 | 战斗界面/生产面板提示（`UI/Loaders/ToolTipLoader_DL.lua` 的「建造条件」） | 文明百科（`UI/Civilopedia/CivilopediaPage_Building.lua`） | 描述文本 `LOC_BUILDING_*_DESCRIPTION` |
| --- | --- | --- | --- |
| `Buildings.RequiresRiver` / `AdjacentDistrict` / `AdjacentImprovement` / `AdjacentResource` / `AdjacentToMountain` / `Coast` / `MustBeLake` / `MustNotBeLake` / `MustBeAdjacentLand` / `RequiresReligion` / `BuildingPrereqs` | ✅ 自动生成 | ✅ | 需手写 |
| `Building_ValidTerrains` / `Building_ValidFeatures` / `Building_RequiredFeatures`（地形、地貌限制） | ❌ **不生成** | ✅ | 需手写 |

也就是说，**地形限制在生产面板里完全不显示**，只能靠描述文本告诉玩家。原版描述文本本来写了（斗兽场原文："必须建在靠近娱乐中心的平坦地形上"），我们重写描述时把这句丢了，于是这条限制在游戏里就彻底看不见了。

## 排查方法

1. 从 `UpdateDataBase/DL_Wonders.sql` 的费用调整段取出全部 56 个本体 + DLC 世界奇观。
2. 全库 grep 出所有会改动建造条件的语句，作为「本模组相对原版的改动」：
   - `Building_ValidTerrains` / `Building_ValidFeatures` / `Building_RequiredFeatures`
   - `update Buildings set ... RequiresRiver/AdjacentDistrict/AdjacentImprovement/AdjacentResource/AdjacentToMountain/Coast/MustBeAdjacentLand/RequiresReligion ...`
   - `BuildingPrereqs`
3. 原版基线取自 Civilization Wiki 的 [List of wonders in Civ6](https://civilization.fandom.com/wiki/List_of_wonders_in_Civ6)（风云变幻规则集一栏），另用 `SubMods/BetterChinese/Text/*.xml` 里保留的原版中文文本交叉验证。
4. 逐个比对「原版基线 + 本模组改动」与描述文本。

## 结论：需要修的 6 处

| 奇观 | 实际条件 | 原文本问题 | 处理 |
| --- | --- | --- | --- |
| 罗马斗兽场 | 平坦地形，相邻建有竞技场的娱乐中心 | 中英文都完全没有建造条件 | 补全 |
| 艾尔米塔什博物馆 | 河流旁，且非沙漠、非冻土单元格 | 中英文都完全没有建造条件 | 补全 |
| 马拉卡纳体育场 | 平坦地形，相邻娱乐中心，本城建有体育场 | 中文有，英文没有 | 补英文 |
| 贝伦塔 | 浅海，相邻陆地与港口 | 中文有「邻近陆地」，英文漏了（`MustBeAdjacentLand` 仍为 1） | 补英文 |
| 佩特拉卡兹尼神殿 | 沙漠 / 沙漠丘陵 / 沙漠山脉 / 沙漠泛滥平原 | 本模组加了 `TERRAIN_DESERT_HILLS`，文本只写了「包括山脉和泛滥平原」 | 中英文补「丘陵」（含 Savannah 适配版） |
| 阿蒙森-斯科特考察站 | 雪原 / 雪原丘陵，相邻建有研究实验室的学院 | `HD_Text_BetterEnglish.sql` 里写的是 "Institute of Technology or Community College"，这两个建筑在本模组中并不存在 | 英文改为 Research Lab |

## 结论：已一致，无需改动（重点核对项）

改动过建造条件、文本也已同步的奇观：

- 阿尔罕布拉宫（原版丘陵+相邻军营 → 加山脉、去掉相邻区域要求）
- 布达拉宫（原版丘陵+靠山 → 加山脉、去掉靠山要求）
- 神谕、基督像、新天鹅堡（原版仅丘陵 → 加山脉）
- 牛津大学（原版仅草原/平原 → 补齐全部平坦地形，文本「平坦地形」）
- 宙斯神像（改为相邻剧院广场 + 临河，并清空了地形限制）
- 圣米歇尔山（原版泛滥平原/沼泽 → 改为浅海/湖泊 + 相邻陆地）
- 大津巴布韦（相邻牛资源 → 相邻牧场）
- 西印度贸易总署（相邻政府广场 → 相邻港口）
- 百老汇（相邻剧院广场 → 相邻商业中心 + 证券交易所）
- 高德院（新增「必须相邻海洋」）
- 瓦西里升天教堂（新增「必须已创立宗教」）
- 罗德斯巨像、自由女神像（`MustBeAdjacentLand` 改为 0，文本已去掉「相邻陆地」）
- 杰贝尔巴尔卡尔（新增沙漠山脉）

没有改动建造条件、也没有覆盖描述文本因而沿用原版文案的奇观（金字塔、摩索拉斯陵墓、吴哥窟、大本钟等）不在问题范围内。

## 后续可选改进

生产面板的「建造条件」列表目前不读 `Building_ValidTerrains` / `Building_ValidFeatures`。如果在 `ToolTipHelper.GetBuildingToolTip`（`UI/Loaders/ToolTipLoader_DL.lua`）里补上这两张表并做归并（全部平坦地形 → 「平坦地形」，全部丘陵 → 「丘陵」，等等），这类「文本漏写地形」的问题就不会再出现，第三方奇观也能一起受益。代价是会与描述文本末尾的手写条件重复一行——本模组现在对河流、相邻区域这些条件本来就是重复显示的，所以并不算破例。
