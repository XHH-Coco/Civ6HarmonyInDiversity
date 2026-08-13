# 奇观建造条件：文本与实际效果一致性排查

起因：玩家反馈罗马斗兽场实际需要平坦单元格，但描述文本里没写。

原则：**以实际效果为准**，只改文本，不改数据库。

## 为什么会漏

奇观的建造条件分散在三处，只有前两处会显示：

| 条件来源 | 生产面板提示（`UI/Loaders/ToolTipLoader_DL.lua` 的「建造条件」） | 文明百科（`UI/Civilopedia/CivilopediaPage_Building.lua`） | 描述文本 `LOC_BUILDING_*_DESCRIPTION` |
| --- | --- | --- | --- |
| `Buildings.RequiresRiver` / `AdjacentDistrict` / `AdjacentImprovement` / `AdjacentResource` / `AdjacentToMountain` / `Coast` / `MustBeLake` / `MustNotBeLake` / `MustBeAdjacentLand` / `RequiresReligion` / `BuildingPrereqs` | ✅ 自动生成 | ✅ | 需手写 |
| `Building_ValidTerrains` / `Building_ValidFeatures` / `Building_RequiredFeatures`（地形、地貌限制） | ❌ **不生成** | ✅ | 需手写 |

也就是说，**地形限制在生产面板里完全不显示**，只能靠描述文本告诉玩家。原版描述文本本来写了（斗兽场原文："必须建在靠近娱乐中心的平原上"），我们重写描述时把这句丢了，于是这条限制在游戏里就彻底看不见了。

## 排查方法

**真值来源：`C:\Users\<用户名>\AppData\Local\Firaxis Games\Sid Meier's Civilization VI\Cache\DebugGameplay.sqlite`**——这是游戏上次启动后落盘的完整数据库，可以直接用 sqlite 读。注意两点：

1. 它反映的是**上次启动时的整套 mod**，不只是本模组。凡是与本仓库 SQL 冲突的值，都要先确认是哪个 mod 改的（下面「非本模组导致」一节有例子）。
2. 同目录的 `DebugLocalization.sqlite` 存文本，但可能不完整；不过它保留的**原版文案**很适合当基线交叉验证。

流程（全自动，不要凭记忆或 wiki）：

1. 取 `select * from Buildings where IsWonder = 1 and InternalOnly = 0`——世界奇观和国家奇观一起，共 82 个由本模组提供描述文本的奇观。
2. 每个奇观 dump 全部建造条件：`Buildings` 的 `RequiresRiver` / `RequiresAdjacentRiver` / `AdjacentDistrict` / `AdjacentImprovement` / `AdjacentResource` / `AdjacentToMountain` / `AdjacentCapital` / `Coast` / `MustBeLake` / `MustNotBeLake` / `MustBeAdjacentLand` / `RequiresReligion`，加上 `Building_ValidTerrains` / `Building_ValidFeatures` / `Building_RequiredFeatures` / `BuildingPrereqs`。
   - **`BuildingPrereqs` 是「或」关系**（见 `ToolTipLoader_DL.lua` 里 `Required Buildings is an OR relationship` 一段），一个奇观列了多行代表任意一个都行。
3. 从本仓库全部 `.sql` 里抽出我们自己写的 `*_DESCRIPTION` 文本（中英各一份），按 `Buildings.Description` 以及 `LOC_<BuildingType>_DESCRIPTION` / `_EXPANSION1/2_DESCRIPTION` 几个候选 tag 对上。
4. 逐条要求做关键词匹配，中英分别跑一遍，输出「DB 有要求但文本没提」的清单，再人工过一遍。

**关键词匹配会误报，必须人工复核**，已知的两类误报：

- 地形集合不是「全部平坦 / 全部丘陵 / 全部山脉 / COAST」这类规范集合时，脚本没有对应关键词，会一律标未提及（佩特拉、兵马俑、桑科雷、乌菲兹、哈利法塔、环球剧院、杰贝尔巴尔卡尔、阿蒙森-斯科特都属于这种，文本其实逐个地形都写全了）。
- `DebugLocalization.sqlite` 是**不完整**的，取不到名字时脚本会拿 tag 去匹配，必然失败（民族史诗的两个博物馆、金融中心的「公司」改良都属于这种，文本其实都写了，只是写在描述开头而不是末尾）。

## 结论：需要修的 10 处

| 奇观 | 实际条件（DebugGameplay 实测） | 原文本问题 | 处理 |
| --- | --- | --- | --- |
| 罗马斗兽场 | 平坦地形；相邻娱乐中心；`BuildingPrereqs` = 竞技场 / JNR 竞技场（娱乐中心一级建筑，特色建筑「蹴球场」经 `BuildingReplaces` 同样满足） | 中英文都完全没有建造条件 | 补全，用「一级建筑」表述 |
| 艾尔米塔什博物馆 | **只有 `RequiresRiver`，没有任何地形限制** | 中英文都完全没有建造条件 | 补「必须建在河流旁」 |
| 马拉卡纳体育场 | 平坦地形；相邻娱乐中心；`BuildingPrereqs` 只有体育场 | 中文有，英文没有 | 补英文（点名体育场，因为三级的 JNR 主题公园并不满足） |
| 贝伦塔 | 浅海；`MustBeAdjacentLand = 1`；相邻港口 | 中文有「邻近陆地」，英文漏了 | 补英文 |
| 威尼斯军械库 | 浅海；`MustBeAdjacentLand = 1`；相邻工业区 | 中英文都漏了「相邻陆地」（原版文案也漏，属沿袭） | 中英文补上 |
| 严岛神社（Suk 奇观） | 浅海；`MustBeAdjacentLand = 1`；相邻圣地 | 同上，中英文都漏了「相邻陆地」 | 中英文补上 |
| 巨石阵 | `AdjacentResource = RESOURCE_STONE` + 全部平坦地形 | 本模组把「石材」改名成「安山岩」（`Texts/HD_Text_Resources.sql`），但只在 Resourceful2 适配文本里改了描述，基础配置下描述仍写「石材」——玩家会去找一个已经不存在的资源名 | 把 Resourceful2 那份同样的文案提到常驻文本里 |
| 佩特拉卡兹尼神殿 | 沙漠 / 沙漠丘陵 / 沙漠山脉 + 泛滥平原地貌 | 本模组加了 `TERRAIN_DESERT_HILLS`（原版明确「没有丘陵的沙漠」），文本只写了「包括山脉和泛滥平原」 | 中英文补「丘陵」（含 Savannah 适配版） |
| 阿蒙森-斯科特考察站 | 雪地 / 雪地丘陵；相邻学院；`BuildingPrereqs` = 研究实验室 / JNR 教育建筑（**学院四级建筑**；数据中心以研究实验室为前置，所以「任意四级建筑」与实际接受集合等价） | 英文写的是 "Institute of Technology or Community College"，这两个建筑在本模组中并不存在；中文沿用原版只写了研究实验室 | 英文改为「四级建筑」，并新增中文覆盖 |

用「N 级建筑」而不是点名建筑的判断标准：**只有当「该区域第 N 级的全部建筑」与 `BuildingPrereqs` 实际接受的集合等价时才用等级表述**。斗兽场、阿蒙森-斯科特满足；马拉卡纳不满足（同为三级的 JNR 主题公园不被接受），所以点名体育场。

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
- 高德院（新增 `Coast = 1`，即必须相邻海洋）
- 瓦西里升天教堂（新增「必须已创立宗教」）
- 罗德斯巨像、自由女神像（`MustBeAdjacentLand` 改为 0，文本已去掉「相邻陆地」）
- 杰贝尔巴尔卡尔（新增沙漠山脉）
- 兵马俑、大灯塔、摩诃菩提寺、高德院、自由女神像等已经在用「N 级建筑」表述，与本模组新增的替代建筑吻合

## 已知的轻微不精确（暂不处理）

本模组把「伊斯兰学院」改成与大学互斥而非替代，并在所有以大学为前置的地方补了伊斯兰学院。因此牛津大学、桑科雷大学的文本写「大学」时，对阿拉伯而言不完整。这里没有改成「二级建筑」，因为同为二级的航海学校并不被接受，等级表述反而更不准。大本钟（银行 / 大集市）同理，且本模组没有覆盖它的描述文本。

## 全 HD 模组配置下的复查

目标配置 = 本模组 + `Mods/` 下全部 `HD_*` 子模组。子模组会覆盖部分奇观描述，所以文本必须**合并**后再核对：主模组的文本先收，`HD_*` 后收覆盖（子模组加载在后）。合并后 94 个奇观全部有中英文本，逐条比对结果：

- **大浴场**和**鲁尔山谷**的差异不是漏写，是子模组自带了配套文本，而且都是对的：
  - `HD_DistrictsDiversity/Database/aqueduct.sql:163-172` 改数据 + `Text/aqueduct_texts_Late.sql:6,13` 改文本 →「必须建造在相邻蓄水池的平坦单元格中」，连洪水那段都改成了条件句「若建造在泛滥平原上……」。
  - `HD_CorporationsDiversity/Database/Wonders.sql:102-103` 改数据 + `Text/Text_Wonders.sql:5` 改文本 →「Must be built adjacent to River.」。
  - 因此**主仓库这两条文本不要动**：关掉子模组时数据会退回原版（大浴场泛滥平原、鲁尔相邻工业区 + `BUILDING_HD_ELECTRONICS_FACTORY` 前置），主仓库文本正是给那种配置用的。
- **威尼斯军械库**在公司模式下描述换成 `LOC_BUILDING_VENETIAN_ARSENAL_CORP_DESCRIPTION`，内容是 `获得1个大亨。{LOC_BUILDING_VENETIAN_ARSENAL_DESCRIPTION}`——用 `{}` 内插了主仓库的描述，所以主仓库补的「相邻陆地」会自动带过去。
- 本轮另修 2 处中文用词（要求本身没写错，但字面会误导）：
  - 帝国大厦（`HD_CorporationsDiversity/Text/Text_Wonders.sql:22`）：「靠近市中心的**平原**上」→「平坦地形上」。地形限制是 5 种平坦地形，写「平原」会被读成只能建在平原。英文本来就写的 flat land。
  - 民族史诗（本仓库）：「**剧院区域**」→「剧院广场区域」，对齐区域正式名。

复查后剩下 13 条标记全部是匹配脚本的固有误报，逐条确认过：

- `LOC_CL_NAT_WONDER_INTERNAL_NAME`（即 `NAT_WONDER_CL_DISABLE_BUILDING_INTERNAL`）：国家奇观 mod 用来让预览条目不可建造的空建筑，不是真实条件。
- 博物馆、公司改良、水渠等名字在 `DebugLocalization.sqlite` 里取不到，脚本退化成拿 tag 匹配。
- 巨石阵的 `RESOURCE_STONE`：本模组已改名安山岩，缓存里还是「石头」。
- 威尼斯军械库公司版的 `{}` 内插，脚本不展开。

**注意脚本的 tag 过滤要用 `'_DESCRIPTION' in tag` 而不是 `endswith`**，否则国家奇观的 `LOC_..._DESCRIPTION_INTERNAL` 预览条目会被整批漏掉。

## 定位「这个值是谁改的」

`DebugGameplay.sqlite` 是整套 mod 合并后的结果，出现与本仓库 SQL 冲突的值时，按这个顺序查：

1. 本仓库全库 grep 该 `BuildingType`。
2. `Mods/HD_*` 几个兄弟仓库 grep——它们就在本机，大浴场和鲁尔山谷就是这样查到的。
3. 还找不到，才是创意工坊的第三方 mod；这时最快的办法是用**只开本模组**的配置重启一次再读 cache 对比。

另外 `Buildings.Description` 本身会被换 tag（鲁尔山谷 → `..._CORP_DESCRIPTION`、金融中心 → `..._CORP_DESCRIPTION`），所以核对时要以 `Buildings.Description` 的当前值为准，不能假定就是 `LOC_<BuildingType>_DESCRIPTION`。

## 后续可选改进

生产面板的「建造条件」列表目前不读 `Building_ValidTerrains` / `Building_ValidFeatures`。如果在 `ToolTipHelper.GetBuildingToolTip`（`UI/Loaders/ToolTipLoader_DL.lua`）里补上这两张表并做归并（全部平坦地形 → 「平坦地形」，全部丘陵 → 「丘陵」，等等），这类「文本漏写地形」的问题就不会再出现，第三方奇观也能一起受益。代价是会与描述文本末尾的手写条件重复一行——本模组现在对河流、相邻区域这些条件本来就是重复显示的，所以并不算破例。
