-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                                       Text)
values
    ("LOC_UNIT_SAPPER_NAME",                                                    "Sapper"),
    ("LOC_UNIT_SAPPER_DESCRIPTION",                                             "Classical era support unit. [NEWLINE]Can spend a build charges to complete 20% of a Canal, Dam or Aqueduct district. Can spend a build charges on the Volcanic Soil tiles for “exploration”, having a probability of obtaining [ICON_Gold] Gold or [ICON_Science] Science; there is also the possibility of discovering new resources or [ICON_GREATWORK_RELIC] Relics. Units within 1 tile recover +10 additional HP per turn when healing. [NEWLINE]Ignore [ICON_MOVEMENT] movement penalty from all Terrians, Features and Rivers."),
    ("LOC_UNIT_ENGINEER_CORP_NAME",                                             "Engineer Corp"),
    ("LOC_UNIT_ENGINEER_CORP_DESCRIPTION",                                      "Industrial era support unit. [NEWLINE]Can spend a build charges to complete 40% of a Canal, Dam or Aqueduct district or a Seawall building. Can spend a build charges on the Volcanic Soil tiles for “exploration”, having a probability of obtaining [ICON_Gold] Gold or [ICON_Science] Science; there is also the possibility of discovering new resources or [ICON_GREATWORK_RELIC] Relics. Units within 1 tile recover +10 additional HP per turn when healing. [NEWLINE]Ignore [ICON_MOVEMENT] movement penalty from all Terrians, Features and Rivers."),
    ("LOC_ABILITY_ENGINEER_HEAL_HD_DESCRIPTION",                                "Units within 1 tile recover +10 additional HP per turn when healing."),
    ("LOC_UNIT_ZULU_IMPI_DESCRIPTION",                                          "Zulu unique Classical Era unit that replaces the Halberdman. +100% Flanking bonus, lower maintenance. Earns XP 50% faster."),
    ("LOC_UNIT_MACEDONIAN_PEZHETAIROS_DESCRIPTION",                             "Macedonian unique Halberdman replacement. Stronger than Halberdman and receives +10 [ICON_Strength] Combat Strength when attacking units."),
    ("LOC_UNIT_GREEK_HOPLITE_DESCRIPTION",                                      "Greek unique Classical era anti-cavalry unit that replaces the Halberdman. +10 [ICON_Strength] Combat Strength if there is at least one adjacent Hoplite unit."),
    ("LOC_UNIT_ENGLISH_LONGBOWMAN_DESCRIPTION",                                 "English unique Classical Era Ranged unit that replaces the Composite Bowman. +1 [ICON_Range] Range."),
    ("LOC_UNIT_GREEK_PELTAST_DESCRIPTION",                                      "Greek unique Ranged unit that replaces the Composite Bowman. +10 [ICON_Strength] Combat Strength when next to another Peltast."),
    ("LOC_UNIT_ZULU_ASSEGAI_DESCRIPTION",                                       "Zulu unique Classical era ranged unit that replaces the Composite Bowman. Higher Ranged Strength. +1 [ICON_Movement] when adjacent to Anti-Cavalry units."), 
    ("LOC_UNIT_VIETNAMESE_VOI_CHIEN_DESCRIPTION",                               "Vietnamese unique Medieval era ranged unit. These units have additional movement and can move after attacking. They are also stronger when defending, more expensive, and have greater sight."), 
    ("LOC_UNIT_ASSYRIA_KISIR_SARRUTI_DESCRIPTION",                              "Assyrian Classical Era Unique Unit that replaces the Halberdman. Lower [ICON_STRENGTH] Strength, but is unlocked earlier, has more [ICON_MOVEMENT] Movement and cheaper to build. Has 1 free promotion.");


insert or replace into LocalizedText
    (Language,      Tag,                                                                        Text)
values
    ("zh_Hans_CN",  "LOC_UNIT_SAPPER_NAME",                                                     "工兵"),
    ("zh_Hans_CN",  "LOC_UNIT_ENGINEER_CORP_NAME",                                              "工程部队"),
    ("zh_Hans_CN",  "LOC_UNIT_SAPPER_DESCRIPTION",                                              "古典时期支援单位。[NEWLINE]可消耗1次劳动力加快运河、堤坝、水渠区域的20%的建造进度。可以在火山土上消耗1次劳动力进行“勘探”，有概率获得 [ICON_Gold] 金币或 [ICON_Science] 科技值，也有概率发现新资源或发掘出 [ICON_GREATWORK_RELIC] 遗物。一个单元格内单位回复生命值时+10每回合回复量。[NEWLINE]无视地形、地貌和河流的移动力消耗。"),
    ("zh_Hans_CN",  "LOC_UNIT_ENGINEER_CORP_DESCRIPTION",                                       "工业时代支援单位。[NEWLINE]可消耗1次劳动力加快运河、堤坝、水渠区域或拦海堤40%的建造进度。可以在火山土上消耗1次劳动力进行“勘探”，有概率获得 [ICON_Gold] 金币或 [ICON_Science] 科技值，也有概率发现新资源或发掘出 [ICON_GREATWORK_RELIC] 遗物。一个单元格内单位回复生命值时+10每回合回复量。[NEWLINE]无视地形、地貌和河流的移动力消耗。"),
    ("zh_Hans_CN",  "LOC_ABILITY_ENGINEER_HEAL_HD_DESCRIPTION",                                 "一个单元格内单位回复生命值时+10每回合回复量。"),
    ("zh_Hans_CN",  "LOC_UNIT_ZULU_IMPI_DESCRIPTION",                                           "古典时代的祖鲁特色单位，取代长戟兵。双倍夹击加成，维护费较低。从战斗中获得的经验值多50%。"),
    ("zh_Hans_CN",  "LOC_UNIT_MACEDONIAN_PEZHETAIROS_DESCRIPTION",                              "取代长戟兵的马其顿古典时代特色抗骑兵单位，拥有更强的 [ICON_Strength] 战斗力且进攻单位时+10 [ICON_Strength] 战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_GREEK_HOPLITE_DESCRIPTION",                                       "古典时代希腊特色抗骑兵单位，替代长戟兵。如与至少一个重装步兵相邻，则+10 [ICON_Strength] 战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_ENGLISH_LONGBOWMAN_DESCRIPTION",                                  "取代复合弓手的英国古典时代特色远程攻击单位，额外+1 [ICON_Range] 射程。"),
    ("zh_Hans_CN",  "LOC_UNIT_GREEK_PELTAST_DESCRIPTION",                                       "取代复合弓手的希腊古典时代特色远程攻击单位，与另一个轻盾步兵相邻时+10 [ICON_Strength] 战斗力。"),
    ("zh_Hans_CN",  "LOC_UNIT_ZULU_ASSEGAI_DESCRIPTION",                                        "取代复合弓手的祖鲁古典时代特色远程单位。拥有更高的远程攻击力。相邻抗骑兵时+1 [ICON_Movement] 移动力。"), --当靠近另一个部族标枪手时+4 [ICON_Strength] 战斗力。
    ("zh_Hans_CN",  "LOC_UNIT_VIETNAMESE_VOI_CHIEN_DESCRIPTION",                                "越南特色中世纪远程单位。其拥有更高移动力，攻击后可移动。其防御时战斗力更强、生产费用更高，且拥有更高视野。"), 
    ("zh_Hans_CN",  "LOC_UNIT_ASSYRIA_KISIR_SARRUTI_DESCRIPTION",                               "亚述古典时代特色抗骑兵单位，取代长戟兵。[ICON_STRENGTH] 战斗力更低，但解锁更早，[ICON_MOVEMENT] 移动力更高且建造成本更低。初始便拥有1次免费升级。");