-- 
create table 'CityPolicyTextMaster'(
    'CityPolicy' TEXT NOT NULL,
    'Name' TEXT,
    'EffectText' TEXT,
    'BuildingText' TEXT,
    'EnableProjectText' TEXT,
    'DisableProjectText' TEXT,
    PRIMARY KEY('CityPolicy')
);

insert or replace into CityPolicyTextMaster
    (CityPolicy)
values
    ('EMPTY'),
    ('LABOR'),
    ('REVISION_ALMANAC'),
    ('AGRICULTURAL_TAX'),
    ('INDUSTRAIL_TAX'),
    ('DIPLOMATIC_MEETING'),
    ('JIMI'),
    ('THEOLOGICAL_SEMINAR'),
    ('FREIGHT'),
    ('FORGING_IRON');
update CityPolicyTextMaster set
    Name                    = 'LOC_CITY_POLICY_' || CityPolicy,
    EffectText              = 'LOC_CITY_POLICY_' || CityPolicy || '_EFFECT',
    BuildingText            = 'LOC_BUILDING_CITY_POLICY_' || CityPolicy,
    EnableProjectText       = 'LOC_PROJECT_CITY_POLICY_ENABLE_' || CityPolicy,
    DisableProjectText      = 'LOC_PROJECT_CITY_POLICY_DISABLE_' || CityPolicy;

insert or replace into EnglishText (Tag, Text) select
    BuildingText || '_NAME',            '{'||Name||'}{LOC_HD_SPACE}{LOC_POLICY_NAME}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    BuildingText || '_DESCRIPTION',     '{'||Name||'}{LOC_HD_SPACE}{LOC_CITY_POLICY_NAME}{LOC_HD_SPACE}{LOC_UNDERGOING_TEXT}[NEWLINE]{'||EffectText||'} {LOC_DISABLE_BY_PROJECT}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';

insert or replace into EnglishText (Tag, Text) select
    EnableProjectText || '_NAME',       '{LOC_MODS_ENABLE}{LOC_HD_SPACE}{'||BuildingText||'_NAME}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    EnableProjectText || '_SHORT_NAME', '{LOC_MODS_ENABLE}{LOC_HD_SPACE}{'||Name||'}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    EnableProjectText || '_DESCRIPTION', '{LOC_MODS_ENABLE} {'||BuildingText||'_NAME}[NEWLINE]{'||EffectText||'} {LOC_DISABLE_BY_PROJECT}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';

insert or replace into EnglishText (Tag, Text) select
    DisableProjectText || '_NAME',       '{LOC_MODS_DISABLE}{LOC_HD_SPACE}{'||BuildingText||'_NAME}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    DisableProjectText || '_SHORT_NAME', '{LOC_MODS_DISABLE}{LOC_HD_SPACE}{'||Name||'}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    DisableProjectText || '_DESCRIPTION', '{LOC_MODS_DISABLE} {'||BuildingText||'_NAME}[NEWLINE]{LOC_CITYPOLICY_BACK_TO_NORMAL}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';

--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                             Text)
values
    ("LOC_CITY_POLICY_NAME",                                          "City Policy"),
    ("LOC_HUD_CITY_CITY_POLICIES",                                    "City Policies"),
    ("LOC_HUD_CITY_NO_CITY_POLICIES",                                 "No City Policies exist."),
    ("LOC_BUILDING_CITY_POLICY_EMPTY_NAME",                           "No City Policy"),
    ("LOC_BUILDING_CITY_POLICY_EMPTY_DESCRIPTION",                    "No City Policy."),

    ("LOC_HD_SPACE",                                                  " "),
    ("LOC_UNDERGOING_TEXT",                                           "undergoing"),
    ("LOC_DISABLE_BY_PROJECT",                                        "This policy can be disabled by a project."),
    ("LOC_CITYPOLICY_BACK_TO_NORMAL",                                 "Restore the original yields."),

    ("LOC_CITY_POLICY_LABOR",                                         "Conscripting Labor"),
    ("LOC_CITY_POLICY_LABOR_EFFECT",                                  "Each [ICON_Citizen] Citizen provides 1.5 extra [ICON_Production] Production, but consume extra 1 [ICON_Food] Food. The city growth rate decreased by 75% and suffer -1 [ICON_Amenities] Amenity."),
    ("LOC_CITY_POLICY_AGRICULTURAL_TAX",                              "Cash Crops"),
    ("LOC_CITY_POLICY_AGRICULTURAL_TAX_EFFECT",                       "Each Farm provides extra 2 [ICON_GOLD] Gold, but -1 [ICON_Food] Food."),
    ("LOC_CITY_POLICY_INDUSTRAIL_TAX",                                "Daily Goods"),
    ("LOC_CITY_POLICY_INDUSTRAIL_TAX_EFFECT",                         "Each Mine or Quarry provides extra 2 [ICON_GOLD] Gold, but -1 [ICON_PRODUCTION] Production."),
    ("LOC_CITY_POLICY_REVISION_ALMANAC",                              "Almanac Revision"),
    ("LOC_CITY_POLICY_REVISION_ALMANAC_EFFECT",                       "Aqueduct Project. Need maintenance cost of 6 [ICON_GOLD] Gold. Plantations and Farms over resource provides -1 [ICON_FOOD] Food, +1 [ICON_Production] Production and +1 [ICON_SCIENCE] Science. After Calendar is researched, provides +2 [ICON_Production] Production."),
    ("LOC_CITY_POLICY_DIPLOMATIC_MEETING",                            "Diplomatic Meeting"),
    ("LOC_CITY_POLICY_DIPLOMATIC_MEETING_EFFECT",                     "Diplomatic Quarter Project. Each turn, Diplomatic Quarter and each of its building consumes 2 [ICON_Favor] Favor, and provides 5 influence points."),
    ("LOC_CITY_POLICY_JIMI",                                          "JIMI"),
    ("LOC_CITY_POLICY_JIMI_EFFECT",                                   "Encampment Project. Consumes 1 [ICON_RESOURCE_HORSES] Horses and 1 [ICON_RESOURCE_IRON] Iron per turn, and provides 2 influence points."),
    ("LOC_CITY_POLICY_FREIGHT",                                       "Freight"),
    ("LOC_CITY_POLICY_FREIGHT_EFFECT",                                "Domestic [ICON_TRADEROUTE] Trade Route to this city comsumes 2 [ICON_RESOURCE_HORSES] Horses per turn to provide +1 [ICON_FOOD] Food and +1 [ICON_PRODUCTION] Production. International [ICON_TRADEROUTE] Trade Route from this city comsumes 2 [ICON_RESOURCE_HORSES] Horses per turn to provide +8 [ICON_GOLD] Gold."),
    ("LOC_CITY_POLICY_THEOLOGICAL_SEMINAR",                           "Theological Seminar"),
    ("LOC_CITY_POLICY_THEOLOGICAL_SEMINAR_EFFECT",                    "Holy Site Project. Holy Site [ICON_CITIZEN] Specialist in this city provides -2 [ICON_FAITH] Faith, +1 [ICON_SCIENCE] Science and +1 [ICON_CULTURE] Culture. Religious spread to adjacent city pressure is 50% weaker."),
    ("LOC_CITY_POLICY_FORGING_IRON",                                  "Forging Iron"), -- Tool Production
    ("LOC_CITY_POLICY_FORGING_IRON_EFFECT",                           "Each Commercial Hub or Industrial Zone building in this city with regional effect costs [ICON_RESOURCE_IRON] equal to its basic regional range, to extend its regional range 2 tiles further.");

    -- ("LOC_CITY_POLICY_DACAOGU",                                       "Pillage Preparing"),
    -- ("LOC_CITY_POLICY_DACAOGU_EFFECT",                                "Each trained light cavalry unit of Mediveal or eralier era in this city gains the ability that can pillage tiles using only 1 [ICON_Movement] Movement. Each [ICON_Citizen] Citizen consumes extra 1 [ICON_FOOD] Food. -100% Growth Rate and -1 [ICON_Amenities] Amenity to this city. If the city has at least 3 [ICON_Citizen] Citizens, receives another unit of the same kind when a light cavalry unit of Mediveal or eralier era being trained in this city, at the cost of one [ICON_Citizen] Citizen. This policy can be disabled by a project.");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                                             Text)
values
    ("zh_Hans_CN",  "LOC_CITY_POLICY_NAME",                                          "城市政策"),
    ("zh_Hans_CN",  "LOC_HUD_CITY_CITY_POLICIES",                                    "城市政策"),
    ("zh_Hans_CN",  "LOC_HUD_CITY_NO_CITY_POLICIES",                                 "尚未开启城市政策"),
    ("zh_Hans_CN",  "LOC_BUILDING_CITY_POLICY_EMPTY_NAME",                           "无城市政策"),
    ("zh_Hans_CN",  "LOC_BUILDING_CITY_POLICY_EMPTY_DESCRIPTION",                    "无城市政策。"),

    ("zh_Hans_CN",  "LOC_HD_SPACE",                                                  ""),
    ("zh_Hans_CN",  "LOC_UNDERGOING_TEXT",                                           "已启用"),
    ("zh_Hans_CN",  "LOC_DISABLE_BY_PROJECT",                                        "该政策可通过项目关闭。"),
    ("zh_Hans_CN",  "LOC_CITYPOLICY_BACK_TO_NORMAL",                                 "产出恢复正常。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_LABOR",                                         "徭役"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_LABOR_EFFECT",                                  "城市中每位 [ICON_Citizen] 公民提供1.5 [ICON_Production] 生产力，但额外增加1 [ICON_Food] 食物消耗。城市余粮减少75%，且-1 [ICON_Amenities] 宜居度。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_AGRICULTURAL_TAX",                              "农业税"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_AGRICULTURAL_TAX_EFFECT",                       "每个农场多2 [ICON_GOLD] 金币，但额外减少1 [ICON_Food] 食物。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_INDUSTRAIL_TAX",                                "工业税"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_INDUSTRAIL_TAX_EFFECT",                         "每个矿山或采石场多2 [ICON_GOLD] 金币，但额外减少1 [ICON_PRODUCTION] 生产力。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_REVISION_ALMANAC",                              "修编历书"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_REVISION_ALMANAC_EFFECT",                       "水渠项目。需要6 [ICON_GOLD] 金币的维护费。城市中改良资源的农场或种植园-1[ICON_FOOD] 食物，+1 [ICON_Production] 生产力和+1 [ICON_SCIENCE] 科技值。研究“历法”科技后，提供+2 [ICON_Production] 生产力。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_DIPLOMATIC_MEETING",                            "外交会晤"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_DIPLOMATIC_MEETING_EFFECT",                     "外交区项目。外交区和其中的每个建筑每回合消耗 2 [ICON_Favor] 外交支持，提供5点影响力点数。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_JIMI",                                          "羁縻"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_JIMI_EFFECT",                                   "军营项目。每回合消耗 1 [ICON_RESOURCE_HORSES] 马和1 [ICON_RESOURCE_IRON] 铁，提供2点影响力点数。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_FREIGHT",                                       "货运"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_FREIGHT_EFFECT",                                "以此城为终点的国内 [ICON_TRADEROUTE] 贸易路线每回合消耗2 [ICON_RESOURCE_HORSES] 马以获得+1 [ICON_FOOD] 食物和+1 [ICON_PRODUCTION] 生产力。以此城为起点的国际 [ICON_TRADEROUTE] 贸易路线每回合消耗2 [ICON_RESOURCE_HORSES] 马以获得+8 [ICON_GOLD] 金币。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_THEOLOGICAL_SEMINAR",                           "神学研讨"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_THEOLOGICAL_SEMINAR_EFFECT",                    "此城的圣地专家额外产出1 [ICON_SCIENCE] 科技值、1 [ICON_CULTURE] 文化值，但少产出2 [ICON_FAITH] 信仰值。此城向邻近城市传播的宗教压力减少50%。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_FORGING_IRON",                                  "锻铁"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_FORGING_IRON_EFFECT",                           "此城拥有辐射效果的商业中心或工业区建筑每回合消耗等同于其基础辐射范围的 [ICON_RESOURCE_IRON] 铁以将其辐射范围延伸2个单元格。");

    -- ("zh_Hans_CN",  "LOC_CITY_POLICY_DACAOGU",                                       "打草谷政策"),
    -- ("zh_Hans_CN",  "LOC_CITY_POLICY_DACAOGU_EFFECT",                                "本城生产的中古及更早时代的轻骑兵获得劫掠地块只消耗1 [ICON_Movement] 移动力的能力。若本城有3 [ICON_Citizen] 人口或以上，则生产该类型的轻骑兵以后，额外获得一个免费的相同类型的单位，但减少一个 [ICON_Citizen] 人口。[NEWLINE]城市中每位公民 [ICON_Citizen] 额外消耗1 [ICON_Food] 食物。本城减少100%余粮，并-1 [ICON_Amenities] 宜居度。该政策可通过项目关闭。");
