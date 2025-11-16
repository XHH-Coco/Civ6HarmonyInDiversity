--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                 Text)
values
    ("LOC_UNIT_BUILDER_DL_DESCRIPTION",                   "May create tile improvements, remove features like Woods or Rainforest, or Harvest some resources. Builders can be used 4 times. This can be increased through policies or wonders like the Pyramids. After Sailing is researched, Builders are allowed to embark."),
    ("LOC_UNIT_GURU_DESCRIPTION",                         "May use a charge to heal itself and all adjacent friendly religious units. May not initiate theological combat with units of other Religions (but can defend). Religious units adjacent to Gurus receive +5 [ICON_Religion] Religious Strength in Theological Combat and +1 [ICON_Movement] Movement."),
    ("LOC_UNIT_SIEGE_TOWER_EXPANSION2_DESCRIPTION",       "Medieval era support unit. When adjacent to a city, attacking melee, anti-cavalry units and Warrior Monks ignore Walls and immediately assault the city. Does not affect cities with Renaissance Walls. Ineffective against Urban Defenses."),
    ("LOC_UNIT_BATTERING_RAM_EXPANSION2_DESCRIPTION",     "Ancient era support unit. When adjacent to a city, attacking melee, anti-cavalry units and Monk Warriors do full damage to the city’s Walls. Does not affect cities with Medieval or Renaissance Walls. Ineffective against Urban Defenses."),
    ("LOC_UNIT_MILITARY_ENGINEER_ALT_DESCRIPTION",        "Medieval era support unit. Requires an Armory to produce. Can construct Roads, Railroads, Forts, Airstrips, Missile Silos, and Mountain Tunnel improvements. One of their build charges can also be used to complete 30% of a Canal, Dam or Aqueduct district or a Seawall building. Ignore [ICON_MOVEMENT] movement penalty from all Terrians, Features and Rivers."), -- Can move with ability that ignore all the terrain and river.
    ("LOC_UNIT_WARRIOR_MONK_DESCRIPTION",                 "Fast-moving land combat unit with a unique promotion tree. Can only be purchased with [ICON_FAITH] Faith in city with Temple."),
    ("LOC_UNIT_OBSERVATION_BALLOON_DESCRIPTION",          "Industrial era support unit. Grants +1 [ICON_Range] Range to Siege class units within 1 hex."),
    ("LOC_UNIT_ANCIENT_SEADOG_DESCRIPTION",               "Ancient era ranged Naval Raider."),
    ("LOC_UNIT_ANCIENT_SEADOG_NAME",                      "Oarlocked Rowboats"), -- Outrigger Boats
    ("LOC_UNIT_ANCIENT_SIEGE_DESCRIPTION",                "Ancient era siege unit, ideal for attacking cities. Gains 1 bonus [ICON_MOVEMENT] Movement if it begins a turn near a light cavalry unit. Cannot move and attack on the same turn unless player has Military Training Civic."),
    ("LOC_UNIT_ANCIENT_SIEGE_NAME",                       "Trebucket"),
    ("LOC_SEADOG_LESS_STRENGTH_DESCRIPTION",			  "-17 [ICON_STRENGTH] Strength when attacking districts."), -- Outrigger Boats
    ("LOC_UNIT_BARBARIAN_HORSEMAN_NAME",			      "Nomadic Raider"),
    ("LOC_UNIT_BARBARIAN_HORSE_ARCHER_NAME",			  "Nomadic Bowrider"),
    -- Unique Units
    ("LOC_UNIT_NORWEGIAN_LONGSHIP_DESCRIPTION",           "Norwegian unique Classical era naval unit that replaces the Galley. Can pillage enemy coastal lands and capture civilians if adjacent using its coastal raiding ability. Gains 1 bonus [ICON_MOVEMENT] Movement if it begins a turn on a Water Area tile."),
    --("LOC_UNIT_ENGLISH_SEADOG_DESCRIPTION",               "Elizabeth I's unique Renaissance era naval unit that replaces the Privateer. Has a chance to capture defeated enemy ships."), -- Can only be seen by other Naval Raiders unless adjacent to it. Reveals Naval Raiders within sight range.
    ("LOC_UNIT_ENGLISH_SEADOG_DESCRIPTION",               "English unique Renaissance era naval unit that replaces the Privateer. Has a chance to capture defeated enemy ships. "), -- Can only be seen by other Naval Raiders unless adjacent to it. Reveals Naval Raiders within sight range.
    ("LOC_UNIT_OTTOMAN_BARBARY_CORSAIR_DESCRIPTION",      "Ottoman unique Medieval era naval unit that replaces the Pirate Ship. It costs no [ICON_Movement] Movement to coastal raid."), -- Can only be seen by other Naval Raiders unless adjacent to it. Reveals Naval Raiders within sight range.
    ("LOC_UNIT_GERMAN_UBOAT_DESCRIPTION",                 "German unique Modern era naval unit that replaces the Submarine. Cheaper to produce, +1 Sight, and +10 [ICON_Strength] Combat Strength when fighting on Ocean tiles."), -- Able to reveal other stealthed units.
    ("LOC_UNIT_ZULU_IMPI_DESCRIPTION",                    "Zulu unique Medieval Era unit that replaces the Pikeman. +100% Flanking bonus, lower maintenance. Earns XP 50% faster."),
    ("LOC_UNIT_KONGO_SHIELD_BEARER_DESCRIPTION",          "Kongo unique Classical era unit that replaces the Swordsman. +10 [ICON_Strength] Combat Strength when defending against ranged attacks. Can see through Woods and Rainforest. +3 [ICON_Strength] Combat Strength when fighting in Rainforest or Woods tiles."),
    ("LOC_UNIT_SWEDEN_CAROLEAN_DESCRIPTION",              "Swedish unique Industrial Era unit that replaces the Line Infantry. Faster than the Pike and Shot. +3 [ICON_Strength] Combat Strength per unused [ICON_Movement] Movement."),
    ("LOC_UNIT_BABYLONIAN_SABUM_KIBITTUM_DESCRIPTION",    "Babylonian unique Ancient era melee unit. +17 [ICON_Strength] Combat Strength against Heavy and Light Cavalry promotion class units. This unit has 3 [ICON_Movement] Movement and sight. Combat victories provide [ICON_SCIENCE] Science equal to 50% of that unit's base [ICON_Strength] Combat Strength (on Standard Speed)."),
    ("LOC_UNIT_MALI_MANDEKALU_CAVALRY_DESCRIPTION",       "Mali unique Medieval Era unit that replaces the Knight. Stronger than Knight. Trader units are immune to being plundered if they are within 4 tiles of a Mandekalu Cavalry and on a land tile. Combat kills provide [ICON_GOLD] Gold equal to 100% of killed unit's base [ICON_Strength] Combat Strength (on Standard Speed). 20% Cheaper to purchase with [ICON_Gold] Gold or [ICON_Faith] Faith (when available)."),
    ("LOC_UNIT_DE_ZEVEN_PROVINCIEN_DESCRIPTION",          "Netherlands unique Renaissance Era unit that replaces the Frigate. +7 [ICON_Strength] Combat Strength when attacking defensible districts. Require less resources to build or upgrade."),
    ("LOC_UNIT_SCYTHIAN_HORSE_ARCHER_DESCRIPTION",        "Scythian unique Classical era unit. Ranged unit with 4 [ICON_Movement] Movement with a [ICON_Range] Range of 2. Can move after attacking and ignore Zone of Control."),
    ("LOC_UNIT_MONGOLIAN_KESHIG_DESCRIPTION",             "Mongolian unique Medieval Era Ranged Cavalry unit that replaces Crossbowman. Can move after attacking and ignore Zone of Control. Can escort moving civilian and support units at their higher [ICON_Movement] Movement speed."),
    ("LOC_UNIT_AZTEC_EAGLE_WARRIOR_DESCRIPTION",          "Aztec unique Ancient era unit that replaces the Warrior. Has higher base combat Strength."),
    ("LOC_UNIT_ROMAN_LEGION_DESCRIPTION",                 "Roman unique Classical era melee unit that replaces the Swordsman. Can build a Roman Fort. Can construct ancient or classical roads."),
    ("LOC_UNIT_CHINESE_CROUCHING_TIGER_DESCRIPTION",      "Chinese unique Renaissance era unit that replaces the Field Cannon. Ranged unit with high combat strength."),
    ("LOC_UNIT_MACEDONIAN_HETAIROI_DESCRIPTION",          "Macedonian unique heavy cavalry unit. Additional +5 [ICON_Strength] Combat Strength when adjacent to a Great General. +10 Great General points when killing an enemy unit. Starts with 1 free Promotion."),
    ("LOC_UNIT_SUMERIAN_WAR_CART_DESCRIPTION",            "Sumerian unique Ancient era unit. Stronger than all other starting units. No [ICON_Strength] Strength penalties against anti-cavalry units. +1 [ICON_Movement] Movement if this unit starts in open terrain. Attacks do full damage to the city's Walls."),
    ("LOC_UNIT_CREE_OKIHTCITAW_DESCRIPTION",              "Cree unique Ancient era unit that replaces the Scout. Strong reconnaissance unit and have one more [ICON_Movement] Movement than Scout."),
    ("LOC_UNIT_POLISH_HUSSAR_EXPANSION2_DESCRIPTION",     "Polish unique Renaissance era unit. Pushes defending enemy units back from their hex in any battle where they score more damage. Defenders that cannot retreat suffer additional damage. 50% less [ICON_Strength] Combat Strength reduction from being injured."),
	("LOC_UNIT_BRAZILIAN_MINAS_GERAES_DESCRIPTION",		  "Brazilian unique Industrial era unit that replaces the Battleship. Stronger than the Battleship."),
    ("LOC_UNIT_NORWEGIAN_BERSERKER_DESCRIPTION",          "Harald Hardrada (Heimskringla)'s unique Medieval era melee unit that replaces the Man-At-Arms. 4 [ICON_MOVEMENT] Movement if this unit starts in enemy territory. +10 [ICON_STRENGTH] Combat Strength when attacking and -5 [ICON_STRENGTH] Combat Strength when defending against melee attacks."),
    ("LOC_UNIT_INCA_WARAKAQ_DESCRIPTION",                 "Incan unique Classical Era unit. +1 additional attack per turn.");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                                 Text)
values
    ("zh_Hans_CN",  "LOC_UNIT_BUILDER_DL_DESCRIPTION",                   "可建造单元格改良设施、移除地貌（如森林或雨林），或收获资源。建造者可使用4次。可通过政策或奇观（如金字塔）增加使用次数。研究“航行”科技后可进入湖泊或浅海单元格。"),
    ("zh_Hans_CN",  "LOC_UNIT_GURU_DESCRIPTION",                         "消耗次数可治疗其自身以及相邻的全部友方宗教单位。无法发起和其他宗教单位的神学战争（但可进行防御）。与上师相邻的宗教单位在神学战争中+5 [ICON_Religion] 宗教战斗力、+1 [ICON_Movement] 移动力。"),
    ("zh_Hans_CN",  "LOC_UNIT_SIEGE_TOWER_EXPANSION2_DESCRIPTION",       "中世纪支援单位。与城市相邻时，近战、抗骑兵单位和武僧可无视城墙直接对城市发起进攻。对拥有文艺复兴城墙的城市无效。对现代城市防御无效。"),
    ("zh_Hans_CN",  "LOC_UNIT_BATTERING_RAM_EXPANSION2_DESCRIPTION",     "远古时代支援单位。与城市相邻时，近战，抗骑兵单位和武僧发起进攻可对城墙输出全额伤害。对拥有中世纪或文艺复兴城墙的城市无效。对现代城市防御无效。"),
    ("zh_Hans_CN",  "LOC_UNIT_MILITARY_ENGINEER_ALT_DESCRIPTION",        "中世纪支援单位。需要“兵工厂”才能生产。能建造道路、堡垒、飞机跑道、导弹发射井和穿山隧道改良设施。其建造次数可用于加快运河、堤坝、水渠区域或拦海堤30%的建造进度。无视地形、地貌和河流的移动力消耗。"),
    ("zh_Hans_CN",  "LOC_UNIT_WARRIOR_MONK_DESCRIPTION",                 "高移动力的陆地战斗单位，拥有独特的升级树。只能在有寺庙的城市通过 [ICON_FAITH] 信仰值购买。"),
    ("zh_Hans_CN",  "LOC_UNIT_OBSERVATION_BALLOON_DESCRIPTION",          "工业时代支援单位。为1单元格内的攻城类单位+1 [ICON_Range] 射程。"),
    ("zh_Hans_CN",  "LOC_UNIT_ANCIENT_SEADOG_DESCRIPTION",               "远古时代的海军袭击者。"),
    ("zh_Hans_CN",  "LOC_UNIT_ANCIENT_SEADOG_NAME",                      "双边架船"),
    ("zh_Hans_CN",  "LOC_UNIT_ANCIENT_SIEGE_DESCRIPTION",                "远古时代攻城单位，适合对城市发起攻击。如果相邻轻骑兵单位开始一个回合，会获得1 [ICON_MOVEMENT] 移动力加成。无法在一回合内移动并攻击（除非玩家已拥有军事训练市政）。"),
    ("zh_Hans_CN",  "LOC_UNIT_ANCIENT_SIEGE_NAME",                       "投石机"),
    ("zh_Hans_CN",  "LOC_SEADOG_LESS_STRENGTH_DESCRIPTION",			     "攻击区域防御时-17 [ICON_STRENGTH] 攻击力。"),
    ("zh_Hans_CN",  "LOC_UNIT_BARBARIAN_HORSEMAN_NAME",			         "游牧袭击者"),
    ("zh_Hans_CN",  "LOC_UNIT_BARBARIAN_HORSE_ARCHER_NAME",			     "游牧弓骑手"),
    -- 特色单位
    ("zh_Hans_CN",  "LOC_UNIT_NORWEGIAN_LONGSHIP_DESCRIPTION",           "取代桨帆船的挪威古典时代特色海军单位。能在中立领土上恢复。通过海岸扫荡能力，可掠夺敌方海岸土地，并俘获附近的平民。如果在水域单元格上开始一个回合，会获得1 [ICON_MOVEMENT] 移动力加成。"),
    --("zh_Hans_CN",  "LOC_UNIT_ENGLISH_SEADOG_DESCRIPTION",               "伊丽莎白一世的文艺复兴时代特色海军单位，取代私掠船。击败敌方船只后有几率将其俘获。"),
    ("zh_Hans_CN",  "LOC_UNIT_ENGLISH_SEADOG_DESCRIPTION",               "文艺复兴时代英国特色海军单位，取代私掠船。击败敌方船只后有几率将其俘获。"),
    ("zh_Hans_CN",  "LOC_UNIT_OTTOMAN_BARBARY_CORSAIR_DESCRIPTION",      "中世纪奥斯曼特色海军单位，取代海盗船。进行海岸扫荡时无需花费 [ICON_Movement] 移动力。"),
    ("zh_Hans_CN",  "LOC_UNIT_GERMAN_UBOAT_DESCRIPTION",                 "取代潜艇的德国特色现代海军单位。生产成本更低，+1视野，在海洋单元格作战时，+10 [ICON_Strength] 战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_ZULU_IMPI_DESCRIPTION",                    "中世纪时代的祖鲁特色单位，取代长矛兵。双倍夹击加成，维护费较低。从战斗中获得的经验值多50%。"),
    ("zh_Hans_CN",  "LOC_UNIT_KONGO_SHIELD_BEARER_DESCRIPTION",          "取代剑客的刚果古典时代特色单位。防御远程攻击时+10 [ICON_Strength] 战斗力。视野能穿过树林和雨林。在森林或雨林中战斗时+3 [ICON_Strength] 战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_SWEDEN_CAROLEAN_DESCRIPTION",              "瑞典工业时代特色单位，取代线列步兵，速度较其更快。每点未使用的 [ICON_Movement] 移动力提供+3 [ICON_Strength] 战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_BABYLONIAN_SABUM_KIBITTUM_DESCRIPTION",    "巴比伦特色远古时代近战单位。与轻重骑兵类单位作战时+17 [ICON_Strength] 战斗力。此单位拥有3点 [ICON_Movement] 移动力和视野。战斗胜利后，可获得等同于被击杀单位50%基础 [ICON_Strength] 战斗力数值的 [ICON_SCIENCE] 科技值（标准速度下）。"),
    ("zh_Hans_CN",  "LOC_UNIT_MALI_MANDEKALU_CAVALRY_DESCRIPTION",       "马里中世纪特色单位，取代骑士。基础力更高。位于陆地且与曼德卡鲁骑兵相距4个单元格内的商人单位可免遭掠夺。战斗胜利后，可获得等同于被击杀单位基础 [ICON_Strength] 战斗力数值的 [ICON_GOLD] 金币（标准速度下）。使用 [ICON_Gold] 金币购买时降价20%，若可用 [ICON_Faith] 信仰值购买时也降价20%。"),
    ("zh_Hans_CN",  "LOC_UNIT_DE_ZEVEN_PROVINCIEN_DESCRIPTION",          "荷兰文艺复兴特色单位，取代护卫舰。攻击防御区域时+7 [ICON_Strength] 战斗力。建造或升级得到时需要更少的战略资源。"),
    ("zh_Hans_CN",  "LOC_UNIT_SCYTHIAN_HORSE_ARCHER_DESCRIPTION",        "斯基泰古典时代特色单位。 [ICON_Range] 射程为2， [ICON_Movement] 移动力为4的远程单位。攻击后可移动且免受控制区影响。"),
    ("zh_Hans_CN",  "LOC_UNIT_MONGOLIAN_KESHIG_DESCRIPTION",             "取代弩手的中世纪蒙古特色远程单位。攻击后可移动且免受控制区影响。可利用自身的高 [ICON_Movement] 移动力护送平民和支援单位。"),
    ("zh_Hans_CN",  "LOC_UNIT_AZTEC_EAGLE_WARRIOR_DESCRIPTION",          "取代勇士的阿兹特克远古时代特色单位。拥有更高的基础战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_ROMAN_LEGION_DESCRIPTION",                 "取代剑客的罗马古典时代特色近战单位。能建造一个罗马堡垒，修建远古和古典道路。"),
    ("zh_Hans_CN",  "LOC_UNIT_CHINESE_CROUCHING_TIGER_DESCRIPTION",      "中国文艺复兴特色单位，取代野战加农炮。 火药解锁的高战斗力的远程单位。"),
    ("zh_Hans_CN",  "LOC_UNIT_MACEDONIAN_HETAIROI_DESCRIPTION",          "马其顿特色重骑兵单位。与大将军相邻时额外+5 [ICON_Strength] 战斗力。击杀敌方单位时+10大将军点数。初始便拥有1次免费升级。"),
    ("zh_Hans_CN",  "LOC_UNIT_SUMERIAN_WAR_CART_DESCRIPTION",            "苏美尔远古时代特色单位。比其他所有初始单位更强大。对战抗骑兵单位时无 [ICON_Strength] 战斗力减益。如果从开阔地形开始回合则+1 [ICON_Movement] 移动力。对城墙造成全额伤害。"),
    ("zh_Hans_CN",  "LOC_UNIT_CREE_OKIHTCITAW_DESCRIPTION",              "远古时代的克里特色单位，取代侦察兵。拥有更高战斗力的侦察单位，且比侦察兵多1 [ICON_Movement] 移动力。"),
    ("zh_Hans_CN",  "LOC_UNIT_POLISH_HUSSAR_EXPANSION2_DESCRIPTION",     "波兰文艺复兴特色单位。伤害点数高于敌方的状况下，会将防守的敌方单位推至后方的单元格。无法后退的防守单位会遭受额外伤害。受伤后的 [ICON_Strength] 战斗力减益减少50%。"),
	("zh_Hans_CN",	"LOC_UNIT_BRAZILIAN_MINAS_GERAES_DESCRIPTION",		 "工业时代的巴西特色单位，取代战舰，强于战舰。"),
    ("zh_Hans_CN",	"LOC_ABILITY_IGNORE_TERRAIN_COST_DESCRIPTION",       "森林、丛林、丘陵和沼泽只消耗1个 [ICON_Movement] 移动力。"),
    ("zh_Hans_CN",  "LOC_UNIT_ENGLISH_REDCOAT_DESCRIPTION",              "维多利亚作为领袖时的工业时代英国特色单位，取代线列步兵。在非首都所处大陆作战时+10 [ICON_Strength] 战斗力。下船不消耗移动力。"),
    ("zh_Hans_CN",  "LOC_UNIT_FRENCH_GARDE_IMPERIALE_DESCRIPTION",       "工业时代法国特色近战单位，取代线列步兵。在首都所处大陆作战时+10 [ICON_Strength] 战斗力。击杀单位后将获得 [ICON_GreatGeneral] 大将军点数。"),
    ("zh_Hans_CN",  "LOC_UNIT_NORWEGIAN_BERSERKER_DESCRIPTION",          "无情者哈拉尔（挪威诸王萨迦）中世纪特色近战单位。若该单位回合开始时处于敌方领土，则 [ICON_MOVEMENT] 移动力为+2。攻击时+10 [ICON_STRENGTH] 战斗力，防御近战攻击时-5 [ICON_STRENGTH] 战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_KOREAN_HWACHA_NAME",                       "火厢车"),
    ("zh_Hans_CN",  "LOC_UNIT_MONGOLIAN_KESHIG_NAME",                    "怯薛军"),
    ("zh_Hans_CN",  "LOC_UNIT_INCA_WARAKAQ_NAME",                        "精锐投石者"),
    ("zh_Hans_CN",  "LOC_UNIT_INCA_WARAKAQ_DESCRIPTION",                 "印加古典时代特色单位，取代斥候。每回合+1额外攻击。");

-- Units information updates
--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                                       Text)
values

    ("LOC_UNIT_HD_BARBARIAN_GALLEY_NAME",                                       "Barbarian Dinghy"),
    ("LOC_UNIT_HD_BARBARIAN_GALLEY_DESCRIPTION",                                "Ancient era naval raider unit, unique to Barbarians."),
    ("LOC_ESPIONAGE_LEVEL_5_NAME",                                              "Legendary Spy"), 
    ("LOC_UNIT_HD_BARBARIAN_QUADRIREME_NAME",                                   "Barbarian Sailboat"),
    ("LOC_UNIT_HD_BARBARIAN_QUADRIREME_DESCRIPTION",                            "Ancient era naval ranged unit, unique to Barbarians."),
    ("LOC_UNIT_DL_MEDIEVAL_PIRATE_DESCRIPTION",                                 "Medieval era Naval Raider unit."), -- have the ability to coastal raid. Can only be seen by other Naval Raiders unless adjacent to it. Reveals Naval Raiders within sight range."),
    ("LOC_UNIT_PRIVATEER_DESCRIPTION",                                          "Renaissance era Naval Raider unit."), -- ranged naval unit with the ability to coastal raid. Can only be seen by other Naval Raiders unless adjacent to it. Reveals Naval Raiders within sight range."),
    ("LOC_UNIT_SUBMARINE_DESCRIPTION",                                          "Modern era Naval Raider unit."), -- ranged naval unit with the ability to coastal raid. Can only be seen by other Naval Raiders unless adjacent to it. Reveals Naval Raiders within sight range."),
    ("LOC_UNIT_HD_CANOE_NAME",                                                  "Canoe"),
    ("LOC_UNIT_HD_CANOE_DESCRIPTION",                                           "Ancient era melee naval combat unit."),
    ("LOC_UNIT_GALLEY_DESCRIPTION",                                             "Classical era melee naval combat unit."),
    ("LOC_UNIT_PHOENICIA_BIREME_DESCRIPTION",                                   "Phoenician unique Classical Era unit that replaces the Galley. Increased [ICON_STRENGTH] Combat Strength and [ICON_MOVEMENT] Movement. Trader units are immune to being plundered if they are within 4 tiles of a Bireme and on a water tile."),
    ("LOC_UNIT_NUCLEAR_SUBMARINE_DESCRIPTION",                                  "Highly advanced Information era Naval Raider unit that can be armed with nuclear weapons."),
    ("LOC_UNIT_CATAPULT_DESCRIPTION",                                           "Classical era siege unit, ideal for attacking cities. Gains 1 bonus [ICON_MOVEMENT] Movement if it begins a turn near a light cavalry unit. Cannot move and attack on the same turn unless player has Military Training Civic."),
    ("LOC_UNIT_BOMBARD_DESCRIPTION",                                            "Renaissance era siege unit, ideal for attacking cities. Gains 1 bonus [ICON_MOVEMENT] Movement if it begins a turn near a light cavalry unit. Cannot move and attack on the same turn unless player has Military Training Civic."),
    ("LOC_UNIT_ARTILLERY_DESCRIPTION",                                          "Modern era siege unit, ideal for attacking cities. Gains 1 bonus [ICON_MOVEMENT] Movement if it begins a turn near a light cavalry unit. Cannot move and attack on the same turn unless player has Military Training Civic."),
    ("LOC_UNIT_ROCKET_ARTILLERY_DESCRIPTION",                                   "Information era siege unit, ideal for attacking cities. Gains 1 bonus [ICON_MOVEMENT] Movement if it begins a turn near a light cavalry unit. Cannot move and attack on the same turn unless player has Military Training Civic."),
    ("LOC_UNIT_TREBUCHET_DESCRIPTION",                                          "Medieval era siege unit, ideal for attacking cities. Gains 1 bonus [ICON_MOVEMENT] Movement if it begins a turn near a light cavalry unit. Cannot move and attack on the same turn unless player has Military Training Civic."),
    ("LOC_PROMOTION_HELMSMAN_DESCRIPTION",                                      "+1 [ICON_Movement] Movement, and +1 sight range."),
    ("LOC_UNIT_INDONESIAN_JONG_DESCRIPTION",                                    "Indonesian unique Medieval era naval unit that replaces the Galleass. Formation units all inherit escort's [ICON_MOVEMENT] Movement speed and +5 [ICON_STRENGTH] Combat Strength when in a formation."),
    ("LOC_UNIT_BYZANTINE_DROMON_DESCRIPTION",                                   "Byzantine unique Medieval era unit that replaces the Galleass that receives +10 [ICON_STRENGTH] Combat Strength against units."),
    ("LOC_UNIT_BYZANTINE_TAGMA_DESCRIPTION",                                    "Byzantine unique Medieval era unit that replaces the Knight. Land units within 1 tile of the Tagma receive +4 [ICON_STRENGTH] Combat Strength or [ICON_RELIGION] Religious Strength.");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                                                    Text)
values
    ("zh_Hans_CN",  "LOC_UNIT_HD_BARBARIAN_GALLEY_NAME",                                    "蛮族小艇"),
    ("zh_Hans_CN",  "LOC_UNIT_HD_BARBARIAN_GALLEY_DESCRIPTION",                             "远古时代蛮族部落的海上侦察单位。"),
    ("zh_Hans_CN",  "LOC_ESPIONAGE_LEVEL_5_NAME",                                           "传奇间谍"),

    ("zh_Hans_CN",  "LOC_UNIT_HD_BARBARIAN_QUADRIREME_NAME",                                "蛮族帆船"),
    ("zh_Hans_CN",  "LOC_UNIT_HD_BARBARIAN_QUADRIREME_DESCRIPTION",                         "远古时代蛮族部落的海上远程单位。"),
    ("zh_Hans_CN",  "LOC_UNIT_DL_MEDIEVAL_PIRATE_DESCRIPTION",                              "中世纪时代海军袭击者。"),
    ("zh_Hans_CN",  "LOC_UNIT_PRIVATEER_DESCRIPTION",                                       "文艺复兴时代的海军袭击者。"),
    ("zh_Hans_CN",  "LOC_UNIT_SUBMARINE_DESCRIPTION",                                       "现代海军袭击者。"),
    ("zh_Hans_CN",  "LOC_UNIT_HD_CANOE_NAME",                                               "独木舟"),
    ("zh_Hans_CN",  "LOC_UNIT_HD_CANOE_DESCRIPTION",                                        "远古时代近战海军战斗单位。"),
    ("zh_Hans_CN",  "LOC_UNIT_GALLEY_DESCRIPTION",                                          "古典时代近战海军战斗单位。"),
    ("zh_Hans_CN",  "LOC_UNIT_PHOENICIA_BIREME_DESCRIPTION",                                "腓尼基古典时代特色单位，取代桨帆船，拥有更高战斗力及移动力。位于水域且与双层桨座战船相距4个单元格内的商人可免遭掠夺。"),
    ("zh_Hans_CN",  "LOC_UNIT_NUCLEAR_SUBMARINE_DESCRIPTION",                               "高度发达的信息时代海军袭击者，能配备核武器。"),
    ("zh_Hans_CN",  "LOC_UNIT_CATAPULT_DESCRIPTION",                                        "古典时代攻城单位，适合对城市发起攻击。如果相邻轻骑兵单位开始一个回合，会获得1 [ICON_MOVEMENT] 移动力加成。无法在一回合内移动并攻击（除非玩家已拥有军事训练市政）。"),
    ("zh_Hans_CN",  "LOC_UNIT_BOMBARD_DESCRIPTION",                                         "文艺复兴时代攻城单位，适合对城市发起攻击。如果相邻轻骑兵单位开始一个回合，会获得1 [ICON_MOVEMENT] 移动力加成。无法在一回合内移动并攻击（除非玩家已拥有军事训练市政）。"),
    ("zh_Hans_CN",  "LOC_UNIT_ARTILLERY_DESCRIPTION",                                       "现代攻城单位，适合对城市发起攻击。如果相邻轻骑兵单位开始一个回合，会获得1 [ICON_MOVEMENT] 移动力加成。无法在一回合内移动并攻击（除非玩家已拥有军事训练市政）。"),
    ("zh_Hans_CN",  "LOC_UNIT_ROCKET_ARTILLERY_DESCRIPTION",                                "信息时代攻城单位，适合对城市发起攻击。如果相邻轻骑兵单位开始一个回合，会获得1 [ICON_MOVEMENT] 移动力加成。无法在一回合内移动并攻击（除非玩家已拥有军事训练市政）。"),
    ("zh_Hans_CN",  "LOC_UNIT_TREBUCHET_DESCRIPTION",                                       "中世纪攻城单位，适合对城市发起攻击。如果相邻轻骑兵单位开始一个回合，会获得1 [ICON_MOVEMENT] 移动力加成。无法在一回合内移动并攻击（除非玩家已拥有军事训练市政）。"),
    ("zh_Hans_CN",  "LOC_PROMOTION_HELMSMAN_DESCRIPTION",                                   "+1 [ICON_Movement] 移动力，+1视野范围。"),
    ("zh_Hans_CN",  "LOC_UNIT_INDONESIAN_JONG_DESCRIPTION",                                 "印度尼西亚特色中世纪海军单位，替代三桅帆战舰。编队时，所有编队单位将继承戎克船的 [ICON_MOVEMENT] 移动力，且会使戎克船+5 [ICON_STRENGTH] 战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_BYZANTINE_DROMON_DESCRIPTION",                                "拜占庭特色中世纪海军单位，替代三桅帆战舰。对抗其它单位时+10 [ICON_STRENGTH] 战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_BYZANTINE_TAGMA_DESCRIPTION",                                 "拜占庭特色中世纪单位，替代骑士。与甲胄骑兵相邻的陆地单位+4 [ICON_STRENGTH] 战斗力或 [ICON_RELIGION] 宗教战斗力（该加成不会叠加）。");
--------------------------------------------------------------------------------
insert or replace into LocalizedText
    (Language,      Tag,                                                Text)
values
    ("zh_Hans_CN",  "LOC_UNIT_GEORGIAN_KHEVSURETI_DESCRIPTION",         "格鲁吉亚中世纪特色单位，取代披甲战士。在丘陵时+7 [ICON_STRENGTH] 战斗力。无视丘陵对 [ICON_MOVEMENT] 移动力的减益。"),
    ("zh_Hans_CN",  "LOC_UNIT_GEORGIAN_KHEVSURETI_NAME",                "克黑苏战士");