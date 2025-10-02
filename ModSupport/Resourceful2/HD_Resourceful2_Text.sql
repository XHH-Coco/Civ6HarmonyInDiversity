--------------------------
-- Resourceful 2 by xhh --
--------------------------

-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                         Text)
values
    ("LOC_RESOURCE_POPPIES_NAME",                                 "Corn Poppies"),
    ("LOC_RESOURCE_SUGAR_NAME",                                   "Sugarcane"),
    ("LOC_RESOURCE_SEASHELLS_NAME",                               "Money Cowrie"),
    ("LOC_RESOURCE_WHALES_NAME",                                  "Sperm Whale"),
    ("LOC_RESOURCE_TOXINS_NAME",                                  "Poison Dart Frog"),
    ("LOC_RESOURCE_MEDIHERBS_NAME",                               "Dendrobium Officinale"),
    ("LOC_RESOURCE_BERRIES_NAME",                                 "Berries"),
    ("LOC_RESOURCE_LIMESTONE_NAME",                               "Dolomite"),
    ("LOC_RESOURCE_BARLEY_NAME",                                  "Highland Barley"),
    ("LOC_RESOURCE_STONE_NAME",                                   "Andesite"),
    ("LOC_RESOURCE_FISH_NAME",                                    "Chum Salmon"),
    ("LOC_IMPROVEMENT_LUMBER_MILL_HD_DESCRIPTION",                "Unlocks the Builder ability to construct a Lumber Mill.[NEWLINE][NEWLINE]+1 [ICON_Production] Production. [NEWLINE][NEWLINE]Can be built on Woods or valid Resources. If built on Luxury resources, the city will gain use of that Resource. +1 [ICON_Production] Production for each adjacent Industrial Zone District (except Hansa District). Once Guilds is unlocked it can also be built on Rainforest.[NEWLINE][NEWLINE]After researching Bronze Working Technology, for each improved Lumber Mill Resource in this city, +10% Production towards districts and buildings."),
    ("LOC_BUILDING_STONEHENGE_DESCRIPTION",                       "Grants a free [ICON_GreatProphet] Great Prophet. [ICON_GreatProphet] Great Prophets may found a Religion on Stonehenge instead of a Holy Site. Must be adjacent to [ICON_RESOURCE_STONE] Andesite and on flat land."),
    ("LOC_BELIEF_PAN_NAME",                                       "Pan"),
    ("LOC_BELIEF_PAN_DL_DESCRIPTION",                             "+1 [ICON_FAITH] Faith and +1 [ICON_CULTURE] Culture from Lumber Mills over resource. +2 [ICON_GREATPROPHET] Great Prophet points per turn for cities having Lumber Mill over resource."),
    ("LOC_DISTRICT_LUMBER_MILL_FAITH",                            "+{1_num} [ICON_Faith] Faith from the adjacent Lumber Mill {1_Num : plural 2?tile; other?tiles;}."),
    ("LOC_BELIEF_HEART_OF_THE_WOODS_NAME",                        "Heart of the Woods"),
    ("LOC_BELIEF_HEART_OF_THE_WOODS_DL_DESCRIPTION",              "Lumber Mills over Luxury and Bonus resources provide +1 [ICON_Food] Food and +1 [ICON_Science] Science."),
    ("LOC_TECH_BRONZE_WORKING_DESCRIPTION_RS2",                   "{LOC_TECH_BRONZE_WORKING_DESCRIPTION}[NEWLINE]For each improved Lumber Mill Resource in this city, +10% Production towards districts and buildings.");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                                         Text)
values
    ("zh_Hans_CN",  "LOC_RESOURCE_SORGHUM_NAME",                                 "高粱"),
    ("zh_Hans_CN",  "LOC_RESOURCE_SUGAR_NAME",                                   "甘蔗"),
    ("zh_Hans_CN",  "LOC_RESOURCE_POPPIES_NAME",                                 "虞美人"),
    ("zh_Hans_CN",  "LOC_RESOURCE_SEASHELLS_NAME",                               "货贝"),
    ("zh_Hans_CN",  "LOC_RESOURCE_SAKURA_NAME",                                  "樱桃木"),
    ("zh_Hans_CN",  "LOC_RESOURCE_WHALES_NAME",                                  "抹香鲸"),
    ("zh_Hans_CN",  "LOC_RESOURCE_LAPIS_NAME",                                   "青金石"),
    ("zh_Hans_CN",  "LOC_RESOURCE_TOXINS_NAME",                                  "箭毒蛙"),
    ("zh_Hans_CN",  "LOC_RESOURCE_ORCA_NAME",                                    "虎鲸"),
    ("zh_Hans_CN",  "LOC_RESOURCE_MEDIHERBS_NAME",                               "铁皮石斛"),
    ("zh_Hans_CN",  "LOC_RESOURCE_LEAD_NAME",                                    "铅锌矿"),
    ("zh_Hans_CN",  "LOC_RESOURCE_BERRIES_NAME",                                 "浆果"),
    ("zh_Hans_CN",  "LOC_RESOURCE_BARLEY_NAME",                                  "青稞"),
    ("zh_Hans_CN",  "LOC_RESOURCE_LIMESTONE_NAME",                               "白云石"),
    ("zh_Hans_CN",  "LOC_RESOURCE_DATES_NAME",                                   "椰枣"),
    ("zh_Hans_CN",  "LOC_RESOURCE_STONE_NAME",                                   "安山岩"),
    ("zh_Hans_CN",  "LOC_RESOURCE_FISH_NAME",                                    "马哈鱼"),
    ("zh_Hans_CN",  "LOC_RESOURCE_COPPER_NAME",                                  "铜矿"),
	("zh_Hans_CN",	"LOC_IMPROVEMENT_LUMBER_MILL_HD_DESCRIPTION",				 "解锁建造者建造伐木场的能力。[NEWLINE][NEWLINE]+1 [ICON_Production] 生产力。每相邻1个工业区（商业同业公会除外）单元格，额外+1 [ICON_Production] 生产力。[NEWLINE][NEWLINE]只能在森林或有效资源上建造。如果建在奢侈品资源上，城市则可以利用该资源。解锁“公会”市政后也能建造在雨林上。[NEWLINE][NEWLINE]解锁“铸铜术”科技后，城市每拥有一种改良的伐木场资源，则建造区域和建筑时+10%建造速度。"), 
    ("zh_Hans_CN",  "LOC_BUILDING_STONEHENGE_DESCRIPTION",                       "免费获得1个 [ICON_GreatProphet] 大预言家。 [ICON_GreatProphet] 大预言家可在巨石阵（代替圣地）创立一个宗教。必须建在靠近 [ICON_RESOURCE_STONE] 安山岩的平坦地形上。"),
    ("zh_Hans_CN",  "LOC_BELIEF_PAN_NAME",                                       "潘神"),
    ("zh_Hans_CN",  "LOC_BELIEF_PAN_DL_DESCRIPTION",                             "所有改良资源的伐木场+1 [ICON_CULTURE] 文化值和+1 [ICON_FAITH] 信仰值。如城市拥有改良资源的伐木场，则每回合+2 [ICON_GREATPROPHET] 大预言家点数。"),
    ("zh_Hans_CN",  "LOC_DISTRICT_LUMBER_MILL_FAITH",                            "+{1_num} [ICON_Faith] 信仰值来自相邻森林{1_Num : plural 2?单元格; other?单元格;}。"),
    ("zh_Hans_CN",  "LOC_BELIEF_HEART_OF_THE_WOODS_NAME",                        "森灵之心"),
    ("zh_Hans_CN",  "LOC_BELIEF_HEART_OF_THE_WOODS_DL_DESCRIPTION",              "改良奢侈品资源和加成资源的伐木场+1 [ICON_Food] 食物和 +1 [ICON_Science] 科技值。"),
    ("zh_Hans_CN",  "LOC_TECH_BRONZE_WORKING_DESCRIPTION_RS2",                   "{LOC_TECH_BRONZE_WORKING_DESCRIPTION}[NEWLINE]城市每拥有一种改良的伐木场资源，则建造区域和建筑时+10%建造速度。");

--------------------------------------------------------------------------------
-- update LocalizedText set Text = Text || " +1 [ICON_Production] Production to Lumber Mills over bonus resources in this city." where Language = 'en_US' and
--     (Tag = 'LOC_DISTRICT_INDUSTRIAL_ZONE_HD_DESCRIPTION' or Tag = 'LOC_DISTRICT_HANSA_HD_DESCRIPTION' or Tag = 'LOC_DISTRICT_OPPIDUM_HD_DESCRIPTION');
-- update LocalizedText set Text = Text || "为本城改良加成资源的伐木场+1 [ICON_Production] 生产力。" where Language = 'zh_Hans_CN' and
--     (Tag = 'LOC_DISTRICT_INDUSTRIAL_ZONE_HD_DESCRIPTION' or Tag = 'LOC_DISTRICT_HANSA_HD_DESCRIPTION' or Tag = 'LOC_DISTRICT_OPPIDUM_HD_DESCRIPTION');

CREATE TEMPORARY TABLE "HDResourceful2_Pedia_Text"(
    "ResourceType"  TEXT
);
insert or replace into HDResourceful2_Pedia_Text
    (ResourceType)
values
    ('RESOURCE_SPONGE'),('RESOURCE_CASHMERE'),('RESOURCE_SANDALWOOD'),('RESOURCE_EBONY'),('RESOURCE_STRAWBERRY'),('RESOURCE_SALMON'),('RESOURCE_BAMBOO'),
    ('RESOURCE_ALABASTER'),('RESOURCE_QUARTZ'),('RESOURCE_LAPIS'),('RESOURCE_RUBY'),('RESOURCE_PLATINUM'),('RESOURCE_SEA_URCHIN'),('RESOURCE_SORGHUM'),
    ('RESOURCE_COD'),('RESOURCE_WOLF'),('RESOURCE_TIGER'),('RESOURCE_SAKURA'),('RESOURCE_POPPIES'),('RESOURCE_ORCA'),('RESOURCE_LION'),
    ('RESOURCE_TRAVERTINE'),('RESOURCE_TOXINS'),('RESOURCE_SAFFRON'),('RESOURCE_ALOE'),('RESOURCE_MEDIHERBS'),('RESOURCE_SEASHELLS'),
    ('RESOURCE_TOMATO'),('RESOURCE_TIN'),('RESOURCE_RUBBER'),('RESOURCE_PINE'),('RESOURCE_OAK'),('RESOURCE_MUSSELS'),('RESOURCE_MUSHROOMS'),
    ('RESOURCE_GRANITE'),('RESOURCE_LIMESTONE'),('RESOURCE_LEAD'),('RESOURCE_HAM'),('RESOURCE_DATES'),('RESOURCE_BERRIES'),('RESOURCE_BARLEY');

insert or replace into EnglishText
    (Tag,                                                                       Text)
select
    'LOC_PEDIA_RESOURCES_PAGE_' || ResourceType ||'_CHAPTER_HISTORY_PARA_1',    " "
from HDResourceful2_Pedia_Text;

insert or replace into LocalizedText
    (Language,      Tag,                                                                        Text)
select
    "zh_Hans_CN",   'LOC_PEDIA_RESOURCES_PAGE_' || ResourceType ||'_CHAPTER_HISTORY_PARA_1',    " "
from HDResourceful2_Pedia_Text;

-- 糖改名甘蔗
update  LocalizedText set Text = REPLACE(Text, '糖', '甘蔗')
where Language = 'zh_Hans_CN' and (Tag in (
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_DESCRIPTION',
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_SHORT_NAME',
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_NAME'
));

update  LocalizedText set Text = REPLACE(Text, 'Sugar', 'Sugarcane')
where Tag in (
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_DESCRIPTION',
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_SHORT_NAME',
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_NAME'
);