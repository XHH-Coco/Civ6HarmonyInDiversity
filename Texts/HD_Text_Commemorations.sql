--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
  (Tag,                                                                           Text)
values
  ("LOC_MOMENT_ACTION_PANEL_TEXT",                                                "{1_Name}: {2_Bonus}"),
  ("LOC_MOMENT_CIVILOPEDIA_TEXT",                                                 "[ICON_GLORY_NORMAL_AGE] Normal Age: {1_NormalBonus}[NEWLINE][NEWLINE][ICON_GLORY_GOLDEN_AGE] Golden Age: {2_GoldenBonus}"),
  -- Natural Philosophy
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC",                                              "Natural Philosophy"),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_GOLDEN_AGE",                             "Academies, Ports, and Aqueducts provide +1 [ICON_SCIENCE] Science and +1 [ICON_CULTURE] Culture. Each triggered [ICON_TECHBOOSTED] Eureka provides 10 [ICON_GREATSCIENTIST] Great Scientist points."),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_NORMAL_AGE",                             "Each triggered [ICON_TECHBOOSTED] Eureka provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Buildings whose production is based on Science provide +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_DARK_AGE",                               "Each triggered [ICON_TECHBOOSTED] Eureka provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Buildings whose production is based on Science provide +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Axis Age
  ("LOC_MOMENT_CATEGORY_CULTURAL",                                                "Axial Age"),
  ("LOC_MOMENT_CATEGORY_CULTURAL_BONUS_GOLDEN_AGE",                               "Each district provides +1 [ICON_CULTURE] Culture and +1 [ICON_FAITH] Faith. Specialized districts provide +3 [ICON_GREATWRITER] Great Writer points."),
  ("LOC_MOMENT_CATEGORY_CULTURAL_BONUS_NORMAL_AGE",                               "Each triggered [ICON_CIVICBOOSTED] Inspiration provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Buildings with Great Work slots provide +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_CULTURAL_BONUS_DARK_AGE",                                 "Each triggered [ICON_CIVICBOOSTED] Inspiration provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Buildings with Great Work slots provide +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Majestic Splendor
  ("LOC_MOMENT_CATEGORY_INFRASTRUCTURE",                                          "Monumentality"),
  ("LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_GOLDEN_AGE",                         "[ICON_CAPITAL] Capital can build one more district than the [ICON_CITIZEN] Population limit allows. Building Ancient, Classical, and Medieval Wonders provides +15% construction speed. Cities with Wonders gain +10% [ICON_FOOD] Food and [ICON_PRODUCTION] Production."),
  ("LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_NORMAL_AGE",                         "Each new district built provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_DARK_AGE",                           "Each new district built provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Glorious Victory
  ("LOC_MOMENT_CATEGORY_RELIGIOUS",                                               "Glorious Victory"),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_GOLDEN_AGE",                              "Recon units and naval raider units gain +1 [ICON_MOVEMENT] Movement and +1 sight. Military units gain +2 [ICON_STRENGTH] Strength. Clearing Barbarian Outposts provides +50 [ICON_GOLD] Gold. Conquering cities grants Tribal Village rewards."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_NORMAL_AGE",                              "Each Barbarian Outpost cleared provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Each city conquered provides +3 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_DARK_AGE",                                "Each Barbarian Outpost cleared provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Each city conquered provides +3 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_SPEED_SIGHT_DESCRIPTION",            "Focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS}”: +1 [ICON_MOVEMENT] Movement. +1 sight."),
  ("LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_STRENGTH_MODIFIER_TEXT",             "From focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS}”"),
  ("LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_STRENGTH_DESCRIPTION",               "Focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS}”: +2 [ICON_Strength] Strength."),
  ------------------------------------------------
  -- Translation Movement
  ("LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT",                                    "Translation Movement"),
  ("LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_GOLDEN_AGE",                   "Building Academies, Theater Squares, and buildings in these districts provides +30% construction speed. [ICON_SCIENCE] Science from [ICON_TechBoosted] Eureka +3%, [ICON_CULTURE] Culture from [ICON_Civicboosted] Inspirations +3%."),
  ("LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_NORMAL_AGE",                   "Each recruitment of a [ICON_GREATSCIENTIST] Great Scientist, [ICON_GREATWRITER] Great Writer, [ICON_GREATARTIST] Great Artist, or [ICON_GREATMUSICIAN] Great Musician provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_DARK_AGE",                     "Each recruitment of a [ICON_GREATSCIENTIST] Great Scientist, [ICON_GREATWRITER] Great Writer, [ICON_GREATARTIST] Great Artist, or [ICON_GREATMUSICIAN] Great Musician provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Prosperous Road
  ("LOC_MOMENT_CATEGORY_FLOURSHING_ROAD",                                         "Flourshing Road"),
  ("LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_GOLDEN_AGE",                        "+50% adjacency bonus for Industrial Zones, Commercial Hubs, and Harbors. All international [ICON_TRADEROUTE] Trade Routes provide +6 [ICON_GOLD] Gold."),
  ("LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_NORMAL_AGE",                        "Each completed [ICON_TRADEROUTE] Trade Route provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_DARK_AGE",                          "Each completed [ICON_TRADEROUTE] Trade Route provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Rough Beginnings
  ("LOC_MOMENT_CATEGORY_DOMESTIC_ASSART",                                         "Domestic Assart"),
  ("LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_GOLDEN_AGE",                        "Civilian units gain +2 [ICON_MOVEMENT] Movement. Newly founded cities receive 1 free Builder. Each improved resource provides +1 [ICON_FOOD] Food and +1 [ICON_PRODUCTION] Production in the city."),
  ("LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_NORMAL_AGE",                        "Each improved resource provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_DARK_AGE",                          "Each improved resource provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_HD_DOMESTIC_ASSART_CIVILIAN_SPEED_DESCRIPTION",     "Focus point “{LOC_MOMENT_CATEGORY_DOMESTIC_ASSART}”: +2 [ICON_MOVEMENT] Movement."),

  -- Religious War
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_WAR",                                           "Religious War"),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_GOLDEN_AGE",                          "Military units gain +1 [ICON_MOVEMENT] Movement. Religious units gain +2 [ICON_MOVEMENT] Movement and +2 uses. +5 [ICON_STRENGTH] Strength when fighting units from civilizations with different religion. Plundering and Coastal Raiding rewards +50%. Plundering or Coastal Raiding improvements will yield additional [ICON_SCIENCE] Science equivalent."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_NORMAL_AGE",                          "First city to follow your founded religion provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_DARK_AGE",                            "First city to follow your founded religion provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_MILITARY_SPEED_DESCRIPTION",       "Focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”: +1 [ICON_MOVEMENT] Movement. +5 [ICON_STRENGTH] Strength when fighting units from non-religious civilizations."),
  ("LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_SPEED_DESCRIPTION",      "Focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”: +2 [ICON_MOVEMENT] Movement. +5 [ICON_RELIGION] Religious combat strength in Theological Wars."),
  ("LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_MILITARY_STRENGTH_TEXT",           "From focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”"),
  ("LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_STRENGTH_TEXT",          "From focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”"),
  ------------------------------------------------
  -- Enlightened Despotism
  ("LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM",                                   "Enlightened Despotism"),
  ("LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_GOLDEN_AGE",                  "Gain a wildcard policy slot permanently. All cities can build one additional district without population restrictions from [ICON_CITIZEN]. Districts adjacent to the Civic Square {LOC_AND_DIPLOMATIC_QUARTER} gain +50% adjacency bonus."),
  ("LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_NORMAL_AGE",                  "Each constructed Community or building in the Civic Square {LOC_AND_DIPLOMATIC_QUARTER} grants +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_DARK_AGE",                    "Each constructed Community or building in the Civic Square {LOC_AND_DIPLOMATIC_QUARTER} grants +2 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Economic Model
  ("LOC_MOMENT_CATEGORY_ECONOMIC",                                                "Primitive Accumulation"),
  ("LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_GOLDEN_AGE",                               "[ICON_GREATENGINEER] Great Engineers and [ICON_GREATMERCHANT] Great Merchants accumulate points +50% faster. All [ICON_TRADEROUTE] Trade Routes provide +2 [ICON_PRODUCTION] Production and +6 [ICON_GOLD] Gold. Purchase districts, buildings, or units at -10% cost."),
  ("LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_NORMAL_AGE",                               "Each recruitment of a [ICON_GREATENGINEER] Great Engineer and [ICON_GREATMERCHANT] Great Merchant provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_DARK_AGE",                                 "Each recruitment of a [ICON_GREATENGINEER] Great Engineer and [ICON_GREATMERCHANT] Great Merchant provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Religious Reform
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM",                                        "Religious Reform"),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_GOLDEN_AGE",                       "+100% adjacency bonus for Holy Sites. Cities with Shrines provide +10% [ICON_SCIENCE] Science, [ICON_CULTURE] Culture, and [ICON_FAITH] Faith."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_NORMAL_AGE",                       "Each constructed Holy Site building provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_DARK_AGE",                         "Each constructed Holy Site building provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Here Be Dragons
  ("LOC_MOMENT_CATEGORY_EXPLORATION",                                             "Hic Sunt Dracones"),
  ("LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_GOLDEN_AGE",                            "Civilian, naval, and waterborne units gain +2 [ICON_MOVEMENT] Movement. Newly founded cities gain +3 [ICON_CITIZEN] Population. Cities without specialized districts build districts +100% faster."),
  ("LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_NORMAL_AGE",                            "Each discovered new continent or natural wonder provides +3 [ICON_GLORY_NORMAL_AGE] Era Score. Each naval non-barbarian unit killed in combat provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_DARK_AGE",                              "Each discovered new continent or natural wonder provides +3 [ICON_GLORY_NORMAL_AGE] Era Score. Each naval non-barbarian unit killed in combat provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_EXPLORATION_CIVILIAN_SPEED_DESCRIPTION",            "Focus point “{LOC_MOMENT_CATEGORY_EXPLORATION}”: +2 [ICON_MOVEMENT] Movement."),
  ------------------------------------------------
  -- Steamrolling
  ("LOC_MOMENT_CATEGORY_INDUSTRIAL",                                              "Heartbeat of Steam"),
  ("LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_GOLDEN_AGE",                             "Constructing wonders from the Industrial Era or later provides +25% construction speed. The adjacency bonus from [ICON_SCIENCE] Science in Campuses also provides [ICON_PRODUCTION] Production. The adjacency bonus from [ICON_PRODUCTION] Production in Industrial Zones also provides [ICON_SCIENCE] Science."),
  ("LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_NORMAL_AGE",                             "Each construction of a building from the Industrial Era or later provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_DARK_AGE",                               "Each construction of a building from the Industrial Era or later provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Romanticism
  ("LOC_MOMENT_CATEGORY_ROMANTICISM",                                             "Romanticism"),
  ("LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_GOLDEN_AGE",                            "[ICON_GREATWRITER] Great Writers, [ICON_GREATARTIST] Great Artists, and [ICON_GREATMUSICIAN] Great Musicians accumulate points +50% faster. Tourism performance from Great Works is +300%."),
  ("LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_NORMAL_AGE",                            "Each activation of a [ICON_GREATWORK_WRITING] Writing, [ICON_GREATWORK_LANDSCAPE] Art or [ICON_GREATWORK_MUSIC] Music Great Work in a city provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_DARK_AGE",                              "Each activation of a [ICON_GREATWORK_WRITING] Writing, [ICON_GREATWORK_LANDSCAPE] Art or [ICON_GREATWORK_MUSIC] Music Great Work in a city provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Scientific Revolution
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION",                                   "Scientific Revolution"),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_GOLDEN_AGE",                  "[ICON_GREATSCIENTIST] Great Scientists accumulate points +50% faster. [ICON_SCIENCE] Science from [ICON_TechBoosted] Eureka moments is +7%."),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_NORMAL_AGE",                  "Each research of an Industrial Era or later technology provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_DARK_AGE",                    "Each research of an Industrial Era or later technology provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Universal Conscription
  ("LOC_MOMENT_CATEGORY_MILITARY",                                                "To Arms!"),
  ("LOC_MOMENT_CATEGORY_MILITARY_BONUS_GOLDEN_AGE",                               "Unlock a special war casus belli, enabling immediate declaration of war after denouncing a target, with [ICON_STAT_GRIEVANCE] Grievance -75%. Military units gain +7 [ICON_STRENGTH] Combat Strength. Production of military units is +100% [ICON_PRODUCTION] faster."),
  ("LOC_MOMENT_CATEGORY_MILITARY_BONUS_NORMAL_AGE",                               "In battle, each non-barbarian Legion killed provides +1 [ICON_GLORY_NORMAL_AGE] Era Score, each non-barbarian Army killed provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_MILITARY_BONUS_DARK_AGE",                                 "In battle, each non-barbarian Legion killed provides +1 [ICON_GLORY_NORMAL_AGE] Era Score, each non-barbarian Army killed provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_MILITARY_STRENGTH_DESCRIPTION",                     "Focus point “{LOC_MOMENT_CATEGORY_MILITARY}”: +7 [ICON_STRENGTH] Combat Strength."),
  ("LOC_COMMEMORATION_MILITARY_STRENGTH_MODIFIER_TEXT",                           "From focus point “{LOC_MOMENT_CATEGORY_MILITARY}”"),
  ------------------------------------------------
  -- May You Be Here
  ("LOC_MOMENT_CATEGORY_TOURISM",                                                 "Wish You Were Here"),
  ("LOC_MOMENT_CATEGORY_TOURISM_BONUS_GOLDEN_AGE",                                "[ICON_TOURISM] Tourism performance from improvements, wonders, and national parks is +300%."),
  ("LOC_MOMENT_CATEGORY_TOURISM_BONUS_NORMAL_AGE",                                "Each artifact discovered provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_TOURISM_BONUS_DARK_AGE",                                  "Each artifact discovered provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- All's Fair in War
  ("LOC_MOMENT_CATEGORY_ESPIONAGE",                                               "Bodyguard of Lies"),
  ("LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_GOLDEN_AGE",                              "Spies deployed to cities of other civilizations require no time. Time for completing offensive missions is reduced by 25%."),
  ("LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_NORMAL_AGE",                              "Each successful offensive espionage mission provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_DARK_AGE",                                "Each successful offensive espionage mission provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Starry Skies
  ("LOC_MOMENT_CATEGORY_AERONAUTICAL",                                            "Sky and Stars"),
  ("LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_EXPANSION2_GOLDEN_AGE",                "If in the Information Era, unlock [ICON_TechBoosted] Eureka for Satellites, Nuclear Fusion, and Nanotechnology. If in the Future Era, unlock [ICON_TechBoosted] Eureka for Smart Materials, Forecast Systems, and Extraterrestrial Missions. All air units gain +100% experience. Each turn, collect +2 [ICON_RESOURCE_ALUMINUM] Aluminum."),
  ("LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_NORMAL_AGE",                           "Each construction of an Airbase building provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Each recruitment of a [ICON_GREATPERSON] Great Person provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_DARK_AGE",                             "Each construction of an Airbase building provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Each recruitment of a [ICON_GREATPERSON] Great Person provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Robot Wars
  ("LOC_MOMENT_CATEGORY_AUTOMATON",                                               "Automaton Warfare"),
  ("LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_GOLDEN_AGE",                              "One Doomsday Mech appears in the capital. Gain 3 [ICON_RESOURCE_URANIUM] Uranium per turn. Each turn, collect +1 [ICON_RESOURCE_URANIUM] Uranium."),
  ("LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_NORMAL_AGE",                              "Each kill of a non-barbarian unit with the Doomsday Mech provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_DARK_AGE",                                "Each kill of a non-barbarian unit with the Doomsday Mech provides +1 [ICON_GLORY_NORMAL_AGE] Era Score.");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
  (Language,      Tag,                                                                            Text)
values
  ("zh_Hans_CN",  "LOC_MOMENT_ACTION_PANEL_TEXT",                                                 "{1_Name}：{2_Bonus}"),
  ("zh_Hans_CN",  "LOC_MOMENT_CIVILOPEDIA_TEXT",                                                  "[ICON_GLORY_NORMAL_AGE] 普通时代：{1_NormalBonus}[NEWLINE][NEWLINE][ICON_GLORY_GOLDEN_AGE] 黄金时代：{2_GoldenBonus}"),
  -- 自然哲学
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC",                                               "自然哲学"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_GOLDEN_AGE",                              "学院、港口和水渠+1 [ICON_SCIENCE] 科技值和+1 [ICON_CULTURE] 文化值。每次触发 [ICON_TECHBOOSTED] 尤里卡，获得10点 [ICON_GREATSCIENTIST] 大科学家点数。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_NORMAL_AGE",                              "每次触发 [ICON_TECHBOOSTED] 尤里卡+1 [ICON_GLORY_NORMAL_AGE] 时代得分。建造以科技值为基础产出的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_DARK_AGE",                                "每次触发 [ICON_TECHBOOSTED] 尤里卡+1 [ICON_GLORY_NORMAL_AGE] 时代得分。建造以科技值为基础产出的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 轴心时代
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CULTURAL",                                                 "轴心时代"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CULTURAL_BONUS_GOLDEN_AGE",                                "每个区域+1 [ICON_CULTURE] 文化值和+1 [ICON_FAITH] 信仰值。专业化区域+3 [ICON_GREATWRITER] 大作家点数。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CULTURAL_BONUS_NORMAL_AGE",                                "每次触发 [ICON_CIVICBOOSTED] 鼓舞+1 [ICON_GLORY_NORMAL_AGE] 时代得分。建成拥有巨作槽位的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CULTURAL_BONUS_DARK_AGE",                                  "每次触发 [ICON_CIVICBOOSTED] 鼓舞+1 [ICON_GLORY_NORMAL_AGE] 时代得分。建成拥有巨作槽位的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 雄伟壮丽
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INFRASTRUCTURE",                                           "雄伟壮丽"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_GOLDEN_AGE",                          "[ICON_CAPITAL] 首都可无视 [ICON_CITIZEN] 人口数量限制再建造一个区域。建造远古、古典和中世纪奇观+15%建造速度。拥有奇观的城市+10% [ICON_FOOD] 食物和 [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_NORMAL_AGE",                          "每修建1座新区域+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_DARK_AGE",                            "每修建1座新区域+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 光荣胜利
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS",                                                "光荣胜利"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_GOLDEN_AGE",                               "侦察单位和海军袭击者单位+1 [ICON_MOVEMENT] 移动力和+1视野。军事单位+2 [ICON_STRENGTH] 战斗力。摧毁 [ICON_Barbarian] 蛮族哨站时+50 [ICON_GOLD] 金币。征服城市时获得一次部落村庄奖励。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_NORMAL_AGE",                               "每摧毁1个 [ICON_Barbarian] 蛮族哨站+1 [ICON_GLORY_NORMAL_AGE] 时代得分。每征服1座城市+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_DARK_AGE",                                 "每摧毁1个 [ICON_Barbarian] 蛮族哨站+1 [ICON_GLORY_NORMAL_AGE] 时代得分。每征服1座城市+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_SPEED_SIGHT_DESCRIPTION",             "着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS}”：+1 [ICON_MOVEMENT] 移动力。+1视野。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_STRENGTH_MODIFIER_TEXT",              "来自着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS}”"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_STRENGTH_DESCRIPTION",                "着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS}”：+2 [ICON_Strength] 战斗力。"),
  ------------------------------------------------
  -- 翻译运动
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT",                                     "翻译运动"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_GOLDEN_AGE",                    "建造学院、剧院广场和这些区域中的建筑时+30%建造速度。为 [ICON_TechBoosted] 尤里卡提供的 [ICON_SCIENCE] 科技值+3%，为 [ICON_Civicboosted] 鼓舞提供的 [ICON_CULTURE] 文化值+3%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_NORMAL_AGE",                    "每招募1位 [ICON_GREATSCIENTIST] 大科学家、[ICON_GREATWRITER] 大作家、[ICON_GREATARTIST] 大艺术家或 [ICON_GREATMUSICIAN] 大音乐家+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_DARK_AGE",                      "每招募1位 [ICON_GREATSCIENTIST] 大科学家、[ICON_GREATWRITER] 大作家、[ICON_GREATARTIST] 大艺术家或 [ICON_GREATMUSICIAN] 大音乐家+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 繁荣之路
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_FLOURSHING_ROAD",                                          "繁荣之路"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_GOLDEN_AGE",                         "+50%工业区、商业中心和港口相邻加成。所有国际 [ICON_TRADEROUTE] 贸易路线+6 [ICON_GOLD] 金币。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_NORMAL_AGE",                         "每完成1条 [ICON_TRADEROUTE] 贸易路线+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_DARK_AGE",                           "每完成1条 [ICON_TRADEROUTE] 贸易路线+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 筚路蓝缕
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DOMESTIC_ASSART",                                          "筚路蓝缕"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_GOLDEN_AGE",                         "平民单位+2 [ICON_MOVEMENT] 移动力。新建立的城市获得1个免费的建造者。每种改良的资源为所在城市+1 [ICON_FOOD] 食物和+1 [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_NORMAL_AGE",                         "每改良1处资源+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_DARK_AGE",                           "每改良1处资源+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_DOMESTIC_ASSART_CIVILIAN_SPEED_DESCRIPTION",      "着力点“{LOC_MOMENT_CATEGORY_DOMESTIC_ASSART}”：+2 [ICON_MOVEMENT] 移动力。"),
  -- 信仰之战
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_WAR",                                            "信仰之战"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_GOLDEN_AGE",                           "军事单位+1 [ICON_MOVEMENT] 移动力。宗教单位+2 [ICON_MOVEMENT] 移动力和+2使用次数。与异教文明的单位作战时+5 [ICON_STRENGTH] 战斗力。掠夺和海岸扫荡的收益+50%。对改良发起掠夺或海岸扫荡时将获得额外等额的 [ICON_SCIENCE] 科技值。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_NORMAL_AGE",                           "首次使一座城市信奉您创立的宗教+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_DARK_AGE",                             "首次使一座城市信奉您创立的宗教+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_MILITARY_SPEED_DESCRIPTION",        "着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”：+1 [ICON_MOVEMENT] 移动力。与异教文明的单位作战时+5 [ICON_STRENGTH] 战斗力。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_SPEED_DESCRIPTION",       "着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”：+2 [ICON_MOVEMENT] 移动力。神学战争中+5 [ICON_RELIGION] 宗教战斗力。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_MILITARY_STRENGTH_TEXT",            "来自着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_STRENGTH_TEXT",           "来自着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”"),
  ------------------------------------------------
  -- 开明专制
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM",                                    "开明专制"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_GOLDEN_AGE",                   "永久获得一个通配符政策槽位。所有城市可无视 [ICON_CITIZEN] 人口数量限制再建造一个区域。与市政广场{LOC_AND_DIPLOMATIC_QUARTER}相邻的区域+50%相邻加成。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_NORMAL_AGE",                   "每建造1座社区、市政广场{LOC_AND_DIPLOMATIC_QUARTER}中的建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_DARK_AGE",                     "每建造1座社区、市政广场{LOC_AND_DIPLOMATIC_QUARTER}中的建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 原始积累
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ECONOMIC",                                                 "原始积累"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_GOLDEN_AGE",                                "[ICON_GREATENGINEER] 大工程师和 [ICON_GREATMERCHANT] 大商人点数积累速度+50%。所有 [ICON_TRADEROUTE] 贸易路线+2 [ICON_PRODUCTION] 生产力和+6 [ICON_GOLD] 金币。购买区域、建筑或单位时费用-10%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_NORMAL_AGE",                                "每招募1位 [ICON_GREATENGINEER] 大工程师和 [ICON_GREATMERCHANT] 大商人+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_DARK_AGE",                                  "每招募1位 [ICON_GREATENGINEER] 大工程师和 [ICON_GREATMERCHANT] 大商人+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 宗教改革
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM",                                         "宗教改革"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_GOLDEN_AGE",                        "+100%圣地相邻加成。拥有祭祀建筑的城市+10% [ICON_SCIENCE] 科技值、[ICON_CULTURE] 文化值和 [ICON_FAITH] 信仰值。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_NORMAL_AGE",                        "每建造1座圣地建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_DARK_AGE",                          "每建造1座圣地建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 此处有龙
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_EXPLORATION",                                              "此处有龙"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_GOLDEN_AGE",                             "平民、海军和水运单位+2 [ICON_MOVEMENT] 移动力。新建立的城市+3 [ICON_CITIZEN] 人口。没有专业化区域的城市建造区域时+100%建造速度。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_NORMAL_AGE",                             "每发现1个新大陆或自然奇观+3 [ICON_GLORY_NORMAL_AGE] 时代得分。在战斗中每击杀1个非蛮族海军单位+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_DARK_AGE",                               "每发现1个新大陆或自然奇观+3 [ICON_GLORY_NORMAL_AGE] 时代得分。在战斗中每击杀1个非蛮族海军单位+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_EXPLORATION_CIVILIAN_SPEED_DESCRIPTION",             "着力点“{LOC_MOMENT_CATEGORY_EXPLORATION}”：+2 [ICON_MOVEMENT] 移动力。"),
  ------------------------------------------------
  -- 滚滚蒸汽
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INDUSTRIAL",                                               "滚滚蒸汽"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_GOLDEN_AGE",                              "建造工业时代或以后的奇观+25%建造速度。学院的 [ICON_SCIENCE] 科技值相邻加成也提供 [ICON_PRODUCTION] 生产力。工业区的 [ICON_PRODUCTION] 生产力相邻加成也提供 [ICON_SCIENCE] 科技值。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_NORMAL_AGE",                              "每建造1座工业时代或以后的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_DARK_AGE",                                "每建造1座工业时代或以后的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 浪漫主义
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ROMANTICISM",                                              "浪漫主义"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_GOLDEN_AGE",                             "[ICON_GREATWRITER] 大作家、[ICON_GREATARTIST] 大艺术家和 [ICON_GREATMUSICIAN] 大音乐家点数积累速度+50%。来自巨作的 [ICON_TOURISM] 旅游业绩+300%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_NORMAL_AGE",                             "每次在城市中创作 [ICON_GREATWORK_WRITING] 著作、[ICON_GREATWORK_LANDSCAPE] 艺术或 [ICON_GREATWORK_MUSIC] 音乐巨作+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_DARK_AGE",                               "每次在城市中创作 [ICON_GREATWORK_WRITING] 著作、[ICON_GREATWORK_LANDSCAPE] 艺术或 [ICON_GREATWORK_MUSIC] 音乐巨作+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 科学革命
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION",                                    "科学革命"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_GOLDEN_AGE",                   "[ICON_GREATSCIENTIST] 大科学家点数积累速度+50%。为 [ICON_TechBoosted] 尤里卡提供的 [ICON_SCIENCE] 科技值+7%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_NORMAL_AGE",                   "每研究1项工业时代或以后科技+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_DARK_AGE",                     "每研究1项工业时代或以后科技+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 全民皆兵
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY",                                                 "全民皆兵"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_BONUS_GOLDEN_AGE",                                "解锁特殊战争借口，谴责目标后可立即宣战，[ICON_STAT_GRIEVANCE] 不满-75%。军事单位+7 [ICON_STRENGTH] 战斗力。生产军事单位时+100% [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_BONUS_NORMAL_AGE",                                "在战斗中每击杀1个非蛮族军团+1 [ICON_GLORY_NORMAL_AGE] 时代得分、每击杀1个非蛮族军队+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_BONUS_DARK_AGE",                                  "在战斗中每击杀1个非蛮族军团+1 [ICON_GLORY_NORMAL_AGE] 时代得分、每击杀1个非蛮族军队+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_MILITARY_STRENGTH_DESCRIPTION",                      "着力点“{LOC_MOMENT_CATEGORY_MILITARY}”：+7 [ICON_STRENGTH] 战斗力。"),
  ("zh_Hans_CN",  "LOC_COMMEMORATION_MILITARY_STRENGTH_MODIFIER_TEXT",                            "来自着力点“{LOC_MOMENT_CATEGORY_MILITARY}”"),
  ------------------------------------------------
  -- 愿你在此
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TOURISM",                                                  "愿你在此"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TOURISM_BONUS_GOLDEN_AGE",                                 "来自改良、奇观和国家公园的 [ICON_TOURISM] 旅游业绩+300%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TOURISM_BONUS_NORMAL_AGE",                                 "每发掘1件文物+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TOURISM_BONUS_DARK_AGE",                                   "每发掘1件文物+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 兵不厌诈
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ESPIONAGE",                                                "兵不厌诈"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_GOLDEN_AGE",                               "间谍部署到另一文明的城市无需时间。完成进攻性任务的时间缩短25%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_NORMAL_AGE",                               "每次进攻性间谍行动成功+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_DARK_AGE",                                 "每次进攻性间谍行动成功+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 漫天繁星
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AERONAUTICAL",                                             "漫天繁星"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_EXPANSION2_GOLDEN_AGE",                 "如处于信息时代，解锁卫星、核聚变和纳米技术的 [ICON_TechBoosted] 尤里卡。如处于未来时代，解锁智能材料、预报系统和外星任务的 [ICON_TechBoosted] 尤里卡。所有空中单位获得的经验值+100%。每回合收集的 [ICON_RESOURCE_ALUMINUM] 铝矿资源+2。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_NORMAL_AGE",                            "每建造1座航空港建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。每招募1位 [ICON_GREATPERSON] 伟人+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_DARK_AGE",                              "每建造1座航空港建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。每招募1位 [ICON_GREATPERSON] 伟人+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 机器人大战
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AUTOMATON",                                                "机器人大战"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_GOLDEN_AGE",                               "首都中将出现1个末日机甲。每回合获得3点 [ICON_RESOURCE_URANIUM] 铀。每回合收集的 [ICON_RESOURCE_URANIUM] 铀矿资源+1。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_NORMAL_AGE",                               "每用末日机甲击杀1个非蛮族单位便+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_DARK_AGE",                                 "每用末日机甲击杀1个非蛮族单位便+1 [ICON_GLORY_NORMAL_AGE] 时代得分。");




  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_GOLDEN_AGE",                          "“雄伟壮丽”黄金时代：[NEWLINE]建造奇观时+15%建造速度。有奇观的城市+10% [ICON_SCIENCE] 科技值，+10% [ICON_CULTURE] 文化值，+10% [ICON_GOLD] 金币，+10% [ICON_FAITH] 信仰值，并可无视 [ICON_CITIZEN] 人口数量限制再建造一个区域。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_GOLDEN_AGE",                           	  "“布道者的远行”黄金时代：[NEWLINE]所有传教士、使徒和审判官+2 [ICON_MOVEMENT] 移动力、+2使用次数。每有一座信奉您创立的宗教的外国城市便+6 [ICON_FAITH] 信仰值。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_GOLDEN_AGE",                              "“自由探索”黄金时代：[NEWLINE][ICON_TECHBOOSTED]尤里卡额外提供（对应科技所需科技总量的）10%。每个不同的区域和建筑为文明提供 +1 [ICON_SCIENCE] 科技值。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CULTURAL_BONUS_GOLDEN_AGE",                                "“百花齐放”黄金时代：[NEWLINE][ICON_CivicBoosted]鼓舞额外提供10%的市政开销。城市每拥有1处特色区域，则+2 [ICON_Culture] 文化值。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_GOLDEN_AGE",                             "“此处有龙”黄金时代：[NEWLINE]新建立的城市+3 [ICON_CITIZEN] 人口。移民、海军和水运单位+2 [ICON_MOVEMENT] 移动力。没有专业化区域的城市建造区域+100% [ICON_PRODUCTION] 生产力。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_GOLDEN_AGE",                              "“滚滚蒸汽”黄金时代：[NEWLINE]建造后工业时代的奇观时+10% [ICON_Production] 生产力。学院区域的 [ICON_SCIENCE] 科技值相邻加成也可提供 [ICON_PRODUCTION] 生产力。工业区域的 [ICON_PRODUCTION] 生产力相邻加成也可提供 [ICON_SCIENCE] 科技值。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_BONUS_GOLDEN_AGE",                                "“全民皆兵”黄金时代：[NEWLINE]解锁特殊战争借口，谴责目标后可立即宣战，[ICON_STAT_GRIEVANCE] 不满-75%。生产军事单位时+30% [ICON_Production] 生产力。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TOURISM_BONUS_GOLDEN_AGE",                                 "“愿你在此”黄金时代：[NEWLINE]世界奇观产出的 [ICON_Tourism] 旅游业绩+100%。国家公园产出的 [ICON_Tourism] 旅游业绩+100%。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM",                                               "开明专制"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_GOLDEN_AGE",                              "“开明专制”黄金时代：[NEWLINE]+1 通配符政策槽位。所有城市+5% [ICON_CULTURE] 文化值。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_NORMAL_AGE",                              "“开明专制”普通时代：[NEWLINE]每次获得 [ICON_GLORY_NORMAL_AGE] 时代得分时额外获得1点 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_DARK_AGE",                                "“开明专制”黑暗时代：[NEWLINE]每次获得 [ICON_GLORY_NORMAL_AGE] 时代得分时额外获得1点 [ICON_GLORY_NORMAL_AGE] 时代得分。");