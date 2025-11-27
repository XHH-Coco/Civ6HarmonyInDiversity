-------------------------------------
--         Boosts Adjustment       --
-------------------------------------

update Boosts set NumItems = 2 where TechnologyType = 'TECH_BRONZE_WORKING';

update Boosts set ImprovementType = 'IMPROVEMENT_PASTURE' where TechnologyType = 'TECH_THE_WHEEL';
update Boosts set BoostClass = 'BOOST_TRIGGER_IMPROVE_SPECIFIC_RESOURCE', ResourceType = 'RESOURCE_HORSES', NumItems = 0, RequiresResource = 0 where TechnologyType = 'TECH_HORSEBACK_RIDING';
update Boosts set NumItems = 2 where TechnologyType = 'TECH_MASS_PRODUCTION';
-- update Boosts set BoostClass = 'BOOST_TRIGGER_CULTURVATE_CIVIC', ImprovementType = NULL, NumItems = 0, BoostingCivicType = 'CIVIC_NAVAL_TRADITION' where TechnologyType = 'TECH_MASS_PRODUCTION';
update Boosts set BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE', NumItems = 1 where CivicType = 'CIVIC_NAVAL_TRADITION';
update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_X_IMPROVEMENTS', NumItems = 2, ImprovementType = 'IMPROVEMENT_CAMP', BoostingTechType = null where CivicType = 'CIVIC_GAMES_RECREATION';

update Boosts set NumItems = 3 where CivicType = 'CIVIC_MEDIEVAL_FAIRES';
update Boosts set NumItems = 1, BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS', DistrictType = NULL, BuildingType = 'BUILDING_LIBRARY' where CivicType = 'CIVIC_RECORDED_HISTORY';
update Boosts set NumItems = 2, BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS', Unit1Type = NULL, BuildingType = 'BUILDING_AMPHITHEATER' where CivicType = 'CIVIC_HUMANISM';

update Boosts set NumItems = 1, BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS', Unit1Type = NULL, BuildingType = 'BUILDING_MONUMENT' where TechnologyType = 'TECH_WRITING';
update Boosts set NumItems = 0, Unit1Type = 'UNIT_SCOUT', BoostClass = 'BOOST_TRIGGER_MEET_CIV' where CivicType = 'CIVIC_FOREIGN_TRADE';

-- update Boosts set NumItems = 2, BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS' where TechnologyType = 'TECH_ENGINEERING';

-- update Boosts set NumItems = 0, Unit1Type = 'UNIT_SPEARMAN', BoostClass = 'BOOST_TRIGGER_KILL_WITH' where CivicType = 'CIVIC_DEFENSIVE_TACTICS';
-- update Boosts set Unit1Type = null, BoostClass = 'BOOST_TRIGGER_CULTURVATE_CIVIC', BoostingCivicType = 'CIVIC_DEFENSIVE_TACTICS' where TechnologyType = 'TECH_MILITARY_TACTICS';

update Boosts set NumItems = 5, BoostClass = 'BOOST_TRIGGER_HAVE_WONDER_PAST_X_ERA', Unit1Type = NULL,
    TriggerDescription = 'LOC_BOOST_TRIGGER_ELECTRICITY_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_ELECTRICITY_HD' where TechnologyType = 'TECH_ELECTRICITY';

update Boosts set BoostClass = 'BOOST_TRIGGER_CULTURVATE_CIVIC', BoostingCivicType = 'CIVIC_MILITARY_TRAINING',
    Unit1Type = NULL, NumItems = 0 where TechnologyType = 'TECH_METAL_CASTING';
update Boosts set BoostClass = 'BOOST_TRIGGER_CULTURVATE_CIVIC', BoostingCivicType = 'CIVIC_DEFENSIVE_TACTICS',
    Unit1Type = NULL, NumItems = 0 where TechnologyType = 'TECH_CASTLES';
update Boosts set BoostClass = 'BOOST_TRIGGER_TRAIN_UNIT', Unit1Type = 'UNIT_GREAT_GENERAL', NumItems = 0
    where TechnologyType = 'TECH_MILITARY_TACTICS';
-- 内燃机
update Boosts set BoostClass = 'BOOST_TRIGGER_IMPROVE_SPECIFIC_RESOURCE', ImprovementType = 'IMPROVEMENT_OIL_WELL', NumItems = 0, ResourceType = 'RESOURCE_OIL', TriggerDescription = 'LOC_BOOST_TRIGGER_COMBUSTION_HD',
    TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_COMBUSTION_HD'
where TechnologyType = 'TECH_COMBUSTION';
-- 现代通讯设备
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', BuildingType = null, NumItems = 0, TriggerDescription = 'LOC_BOOST_TRIGGER_TELECOMMUNICATIONS_HD',
    TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_TELECOMMUNICATIONS_HD'
where TechnologyType = 'TECH_TELECOMMUNICATIONS';
-- 隐形技术
update Boosts set BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE', Unit1Type = 'UNIT_BOMBER', NumItems = 2, TriggerDescription = 'LOC_BOOST_TRIGGER_STEALTH_TECHNOLOGY',
    TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_STEALTH_TECHNOLOGY'
where TechnologyType = 'TECH_STEALTH_TECHNOLOGY';
-- 高级弹道学
update Boosts set BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE', Unit1Type = 'UNIT_FIELD_CANNON', NumItems = 2, BuildingType = NULL, TriggerDescription = 'LOC_BOOST_TRIGGER_ADVANCED_BALLISTICS_HD',
    TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_ADVANCED_BALLISTICS_HD'
where TechnologyType = 'TECH_ADVANCED_BALLISTICS';
update Boosts set Unit1Type = 'UNIT_DLV_MORTAR', TriggerDescription = 'LOC_BOOST_TRIGGER_ADVANCED_BALLISTICS_HD_2'
    where TechnologyType = 'TECH_ADVANCED_BALLISTICS' and exists (select UnitType from Units where UnitType = 'UNIT_DLV_MORTAR');
-- 塑料
update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS', BuildingType = 'BUILDING_FOSSIL_FUEL_POWER_PLANT', NumItems = 1, ImprovementType = NULL, ResourceType = NULL,
    TriggerDescription = 'LOC_BOOST_TRIGGER_PLASTICS_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_PLASTICS_HD'
where TechnologyType = 'TECH_PLASTICS';
-- 现代国防
update Boosts set BoostClass = 'BOOST_TRIGGER_RECEIVE_DOW', Unit1Type = null, NumItems = 0,
    TriggerDescription = 'LOC_BOOST_TRIGGER_SCORCHED_EARTH_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_SCORCHED_EARTH_HD'
where CivicType = 'CIVIC_SCORCHED_EARTH';
-- 民族主义
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', TriggerDescription = 'LOC_BOOST_TRIGGER_NATIONALISM_HD',
    TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_NATIONALISM_HD'
where CivicType = 'CIVIC_NATIONALISM';
-- 选举权
update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS', BuildingType = 'BUILDING_HD_HUMAN_RIGHTS_COUNCIL', NumItems = 1,
    TriggerDescription = 'LOC_BOOST_TRIGGER_SUFFRAGE_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_SUFFRAGE_HD'
where CivicType = 'CIVIC_SUFFRAGE';
-- 环境保护主义
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', ImprovementType = null, NumItems = 0,
    TriggerDescription = 'LOC_BOOST_TRIGGER_ENVIRONMENTALISM_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_ENVIRONMENTALISM_HD'
where CivicType = 'CIVIC_ENVIRONMENTALISM' and exists (select DistrictType from Districts where DistrictType = 'DISTRICT_PRESERVE');
-- 歌剧与芭蕾
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', BuildingType = null, NumItems = 0,
    TriggerDescription = 'LOC_BOOST_TRIGGER_OPERA_BALLET_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_OPERA_BALLET_HD'
where CivicType = 'CIVIC_OPERA_BALLET';
-- 大众媒体
update Boosts set BoostClass = 'BOOST_TRIGGER_CULTURVATE_CIVIC', BoostingCivicType = 'CIVIC_JOURNALISM_STUDIES_HD', NumItems = 0, BoostingTechType = null,
    TriggerDescription = 'LOC_BOOST_TRIGGER_MASS_MEDIA_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_MASS_MEDIA_HD'
where CivicType = 'CIVIC_MASS_MEDIA';
-- 阶级斗争
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', BuildingType = null, NumItems = 0,
    TriggerDescription = 'LOC_BOOST_TRIGGER_CLASS_STRUGGLE_HD'
where CivicType = 'CIVIC_CLASS_STRUGGLE';
-- 社交媒体
update Boosts set BoostingTechType = 'TECH_INTERNET_HD',
    TriggerDescription = 'LOC_BOOST_TRIGGER_SOCIAL_MEDIA_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_SOCIAL_MEDIA_HD'
where CivicType = 'CIVIC_SOCIAL_MEDIA';
-- 职业体育
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', DistrictType = null, NumItems = 0,
    TriggerDescription = 'LOC_BOOST_TRIGGER_PROFESSIONAL_SPORTS_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_PROFESSIONAL_SPORTS_HD'
where CivicType = 'CIVIC_PROFESSIONAL_SPORTS';
-- 殖民主义
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', BoostingTechType = null, NumItems = 0,
    TriggerDescription = 'LOC_BOOST_TRIGGER_COLONIALISM_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_COLONIALISM_HD'
where CivicType = 'CIVIC_COLONIALISM';
-- 帝国初期
update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_X_DISTRICTS', DistrictType = 'DISTRICT_CITY_CENTER', NumItems = 2,
    TriggerDescription = 'LOC_BOOST_TRIGGER_EARLY_EMPIRE_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_EARLY_EMPIRE_HD'
where CivicType = 'CIVIC_EARLY_EMPIRE';
-- 钢铁
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', BoostingTechType = null, NumItems = 0, ImprovementType = NULL, ResourceType = NULL, Unit1Type = NULL,
    TriggerDescription = 'LOC_BOOST_TRIGGER_STEEL_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_STEEL_HD'
where TechnologyType = 'TECH_STEEL';
-- 造船术
update Boosts set BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE', Unit1Type = 'UNIT_HD_CANOE', NumItems = 2 where TechnologyType = 'TECH_SHIPBUILDING';
-- 探索
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', NumItems = 0, Unit1Type = NULL,
    TriggerDescription = 'LOC_BOOST_TRIGGER_EXPLORATION_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_EXPLORATION_HD'
where CivicType = 'CIVIC_EXPLORATION';

-- 设定市政的鼓舞
insert or replace into Boosts
    (BoostID,   CivicType,                                  Boost,  TriggerDescription,                                     TriggerLongDescription,                                             Unit1Type,                  BoostClass,                                         Unit2Type,      BuildingType,           ImprovementType,        BoostingTechType,           ResourceType,   NumItems,   DistrictType,           RequiresResource)
values
    (201,       'CIVIC_LITERARY_TRADITION_HD',              40,     'LOC_BOOST_TRIGGER_LITERARY_TRADITION_HD',              'LOC_BOOST_TRIGGER_LONGDESC_LITERARY_TRADITION_HD',                 NULL,                       'BOOST_TRIGGER_RESEARCH_TECH',                      NULL,           NULL,                   NULL,                   'TECH_PAPER_MAKING_HD',     NULL,           0,          NULL,                   0),
    (202,       'CIVIC_IMPERIAL_EXAMINATION_SYSTEM_HD',     40,     'LOC_BOOST_TRIGGER_IMPERIAL_EXAMINATION_SYSTEM_HD',     'LOC_BOOST_TRIGGER_LONGDESC_IMPERIAL_EXAMINATION_SYSTEM_HD',        NULL,                       'BOOST_TRIGGER_HAVE_X_DISTRICTS',                   NULL,           NULL,                   NULL,                   NULL,                       NULL,           2,          'DISTRICT_CAMPUS',      0),
    (203,       'CIVIC_EVOLUTION_THEORY_HD',                40,     'LOC_BOOST_TRIGGER_EVOLUTION_THEORY_HD',                'LOC_BOOST_TRIGGER_LONGDESC_EVOLUTION_THEORY_HD',                   NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    (204,       'CIVIC_HISTORICAL_PHILOSOPHY_HD',           40,     'LOC_BOOST_TRIGGER_HISTORICAL_PHILOSOPHY_HD',           'LOC_BOOST_TRIGGER_LONGDESC_HISTORICAL_PHILOSOPHY_HD',              NULL,                       'BOOST_TRIGGER_HAVE_X_DISTRICTS',                   NULL,           NULL,                   NULL,                   NULL,                       NULL,           3,          'DISTRICT_THEATER',     0),
    (205,       'CIVIC_ETHICS_HD',                          40,     'LOC_BOOST_TRIGGER_ETHICS_HD',                          'LOC_BOOST_TRIGGER_LONGDESC_ETHICS_HD',                             NULL,                       'BOOST_TRIGGER_RESEARCH_TECH',                      NULL,           NULL,                   NULL,                   'TECH_PRINTING',            NULL,           0,          NULL,                   0),
    (206,       'CIVIC_SOCIAL_SCIENCE_HD',                  40,     'LOC_BOOST_TRIGGER_SOCIAL_SCIENCE_HD',                  'LOC_BOOST_TRIGGER_LONGDESC_SOCIAL_SCIENCE_HD',                     NULL,                       'BOOST_TRIGGER_HAVE_X_UNIQUE_SPECIALTY_DISTRICTS',  NULL,           NULL,                   NULL,                   NULL,                       NULL,           7,          NULL,                   0),
    -- 博物馆学
    (207,       'CIVIC_MUSEOLOGY_HD',                       40,     'LOC_BOOST_TRIGGER_MUSEOLOGY_HD',                       'LOC_BOOST_TRIGGER_LONGDESC_MUSEOLOGY_HD',                          NULL,                       'BOOST_TRIGGER_ARTIFACT_EXTRACTED',                 NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 原始军事
    (208,       'CIVIC_EARLY_WARFARE_HD',                   40,     'LOC_BOOST_TRIGGER_EARLY_WARFARE_HD',                   'LOC_BOOST_TRIGGER_LONGDESC_EARLY_WARFARE_HD',                      NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 丧仪
    (209,       'CIVIC_FUNERAL_HD',                         40,     'LOC_BOOST_TRIGGER_FUNERAL_HD',                         'LOC_BOOST_TRIGGER_LONGDESC_FUNERAL_HD',                            NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 纹章学
    (210,       'CIVIC_HERALDRY_HD',                        40,     'LOC_BOOST_TRIGGER_HERALDRY_HD',                        'LOC_BOOST_TRIGGER_LONGDESC_HERALDRY_HD',                           NULL,                       'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_ARENA',       NULL,                   NULL,                       NULL,           1,          NULL,                   0),
    -- 商业资本主义
    (211,       'CIVIC_COMMERCIAL_CAPITALISM_HD',           40,     'LOC_BOOST_TRIGGER_COMMERCIAL_CAPITALISM_HD',           'LOC_BOOST_TRIGGER_LONGDESC_COMMERCIAL_CAPITALISM_HD',              NULL,                       'BOOST_TRIGGER_RESEARCH_TECH',                      NULL,           NULL,                   NULL,                   'TECH_APPRENTICESHIP',      NULL,           0,          NULL,                   0),
    -- 法学
    (212,       'CIVIC_LAW_HD',                             40,     'LOC_BOOST_TRIGGER_LAW_HD',                             'LOC_BOOST_TRIGGER_LONGDESC_LAW_HD',                                'UNIT_TRAVEL_THEATRE',      'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',                NULL,           NULL,                   NULL,                   NULL,                       NULL,           1,          NULL,                   0),
    -- 新闻学
    (213,       'CIVIC_JOURNALISM_STUDIES_HD',              40,     'LOC_BOOST_TRIGGER_JOURNALISM_STUDIES_HD',              'LOC_BOOST_TRIGGER_LONGDESC_JOURNALISM_STUDIES_HD',                 NULL,                       'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_HD_MANSION',  NULL,                   NULL,                       NULL,           1,          NULL,                   0),
    -- 人权
    (214,       'CIVIC_HUMAN_RIGHTS_HD',                    40,     'LOC_BOOST_TRIGGER_HUMAN_RIGHTS_HD',                    'LOC_BOOST_TRIGGER_LONGDESC_HUMAN_RIGHTS_HD',                       NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 警察制度
    (215,       'CIVIC_POLICE_SYSTEM_HD',                   40,     'LOC_BOOST_TRIGGER_POLICE_SYSTEM_HD',                   'LOC_BOOST_TRIGGER_LONGDESC_POLICE_SYSTEM_HD',                      NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 社会保障制度
    (216,       'CIVIC_SOCIAL_SECURITY_SYSTEM_HD',          40,     'LOC_BOOST_TRIGGER_SOCIAL_SECURITY_SYSTEM_HD',          'LOC_BOOST_TRIGGER_LONGDESC_SOCIAL_SECURITY_SYSTEM_HD',             NULL,                       'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_SEWER',       NULL,                   NULL,                       NULL,           3,          NULL,                   0),
    -- 古生物学
    (217,       'CIVIC_PALEOBIOLOGY_HD',                    40,     'LOC_BOOST_TRIGGER_PALEOBIOLOGY_HD',                    'LOC_BOOST_TRIGGER_LONGDESC_PALEOBIOLOGY_HD',                       NULL,                       'BOOST_TRIGGER_RESEARCH_TECH',                      NULL,           NULL,                   NULL,                   'TECH_GEOLOGY_HD',          NULL,           0,          NULL,                   0),
    -- 法典
    (218,       'CIVIC_CODE_OF_LAWS',                       40,     'LOC_BOOST_TRIGGER_CODE_OF_LAWS',                       'LOC_BOOST_TRIGGER_LONGDESC_CODE_OF_LAWS',                          NULL,                       'BOOST_TRIGGER_EMPIRE_POPULATION',                  NULL,           NULL,                   NULL,                   NULL,                       NULL,           3,          NULL,                   0),
    -- 人类学
    (219,       'CIVIC_ANTHROPOLOGY_HD',                    40,     'LOC_BOOST_TRIGGER_ANTHROPOLOGY_HD',                    'LOC_BOOST_TRIGGER_LONGDESC_ANTHROPOLOGY_HD',                       NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 城市设计
    (220,       'CIVIC_URBAN_DESIGN_HD',                    40,     'LOC_BOOST_TRIGGER_URBAN_DESIGN_HD',                    'LOC_BOOST_TRIGGER_LONGDESC_URBAN_DESIGN_HD',                       NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 现代主义思潮
    (221,       'CIVIC_MODERNISM_HD',                       40,     'LOC_BOOST_TRIGGER_MODERNISM_HD',                       'LOC_BOOST_TRIGGER_LONGDESC_MODERNISM_HD',                          NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 国际主义
    (222,       'CIVIC_INTERNATIONALISM_HD',                40,     'LOC_BOOST_TRIGGER_INTERNATIONALISM_HD',                'LOC_BOOST_TRIGGER_LONGDESC_INTERNATIONALISM_HD',                   NULL,                       'BOOST_TRIGGER_HAVE_ALLIANCE_LEVEL_X',              NULL,           NULL,                   NULL,                   NULL,                       NULL,           3,          NULL,                   0),
    -- 意识形态
    (223,       'CIVIC_IDEOLOGY',                           40,     'LOC_BOOST_TRIGGER_IDEOLOGY_HD',                        'LOC_BOOST_TRIGGER_LONGDESC_IDEOLOGY_HD',                           NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 金融学
    (224,       'CIVIC_FINANCE_HD',                         40,     'LOC_BOOST_TRIGGER_FINANCE_HD',                         'LOC_BOOST_TRIGGER_LONGDESC_FINANCE_HD',                            NULL,                       'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_SHOPPING_MALL',NULL,                  NULL,                       NULL,           1,          NULL,                   0),
    -- 高等教育
    (225,       'CIVIC_HIGHER_EDUCATION_HD',                40,     'LOC_BOOST_TRIGGER_HIGHER_EDUCATION_HD',                'LOC_BOOST_TRIGGER_LONGDESC_HIGHER_EDUCATION_HD',                   NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 新殖民主义
    (226,       'CIVIC_NEOCOLONIALISM_HD',                  40,     'LOC_BOOST_TRIGGER_NEOCOLONIALISM_HD',                  'LOC_BOOST_TRIGGER_LONGDESC_NEOCOLONIALISM_HD',                     NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 国际联盟
    (227,       'CIVIC_LEAGUE_OF_NATIONS_HD',               40,     'LOC_BOOST_TRIGGER_LEAGUE_OF_NATIONS_HD',               'LOC_BOOST_TRIGGER_LONGDESC_LEAGUE_OF_NATIONS_HD',                  NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0),
    -- 国际联盟
    (228,       'CIVIC_HOUSEHOLD_REGISTRATION_HD',          40,     'LOC_BOOST_TRIGGER_HOUSEHOLD_REGISTRATION_HD',          'LOC_BOOST_TRIGGER_LONGDESC_HOUSEHOLD_REGISTRATION_HD',             NULL,                       'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                   NULL,                   NULL,                       NULL,           0,          NULL,                   0);

-- 设定科技的尤里卡
insert or replace into Boosts
    (BoostID,   TechnologyType,                             Boost,  TriggerDescription,                                     TriggerLongDescription,                                             Unit1Type,                   BoostClass,                                         Unit2Type,      BuildingType,              ImprovementType,              BoostingTechType,        BoostingCivicType,          ResourceType,        NumItems,   DistrictType,           RequiresResource)
values
    (250,       'TECH_CALENDAR_HD',                         40,     'LOC_BOOST_TRIGGER_CALENDAR_HD',                        'LOC_BOOST_TRIGGER_LONGDESC_CALENDAR_HD',                           NULL,                        'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_GRANARY',        NULL,                         NULL,                    NULL,                       NULL,                1,          NULL,                   0),
    (251,       'TECH_PAPER_MAKING_HD',                     40,     'LOC_BOOST_TRIGGER_PAPER_MAKING_HD',                    'LOC_BOOST_TRIGGER_LONGDESC_PAPER_MAKING_HD',                       NULL,                        'BOOST_TRIGGER_HAVE_X_IMPROVEMENTS',                NULL,           NULL,                      'IMPROVEMENT_PLANTATION',     NULL,                    NULL,                       NULL,                1,          NULL,                   0),
    (252,       'TECH_COMPASS_HD',                          40,     'LOC_BOOST_TRIGGER_COMPASS_HD',                         'LOC_BOOST_TRIGGER_LONGDESC_COMPASS_HD',                            NULL,                        'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_LIGHTHOUSE',     NULL,                         NULL,                    NULL,                       NULL,                1,          NULL,                   0),
    (253,       'TECH_PHYSICS_HD',                          40,     'LOC_BOOST_TRIGGER_PHYSICS_HD',                         'LOC_BOOST_TRIGGER_LONGDESC_PHYSICS_HD',                            'UNIT_GREAT_SCIENTIST',      'BOOST_TRIGGER_TRAIN_UNIT',                         NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                0,          NULL,                   0),
    (254,       'TECH_BIOLOGY_HD',                          40,     'LOC_BOOST_TRIGGER_BIOLOGY_HD',                         'LOC_BOOST_TRIGGER_LONGDESC_BIOLOGY_HD',                            NULL,                        'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_ZOO',            NULL,                         NULL,                    NULL,                       NULL,                1,          NULL,                   0),
    (255,       'TECH_CIVIL_ENGINEERING_HD',                40,     'LOC_BOOST_TRIGGER_CIVIL_ENGINEERING_HD',               'LOC_BOOST_TRIGGER_LONGDESC_CIVIL_ENGINEERING_HD',                  NULL,                        'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_WORKSHOP',       NULL,                         NULL,                    NULL,                       NULL,                2,          NULL,                   0),
    -- 现代农业
    (256,       'TECH_MODERN_AGRICULTURE_HD',               40,     'LOC_BOOST_TRIGGER_MODERN_AGRICULTURE_HD',              'LOC_BOOST_TRIGGER_LONGDESC_MODERN_AGRICULTURE_HD',                 NULL,                        'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_FOOD_MARKET',    NULL,                         NULL,                    NULL,                       NULL,                1,          NULL,                   0),
    -- 医药学
    (257,       'TECH_MEDICAL_SCIENCE_HD',                  40,     'LOC_BOOST_TRIGGER_MEDICAL_SCIENCE_HD',                 'LOC_BOOST_TRIGGER_LONGDESC_MEDICAL_SCIENCE_HD',                    NULL,                        'BOOST_TRIGGER_CULTURVATE_CIVIC',                   NULL,           NULL,                      NULL,                         NULL,                    'CIVIC_MOBILIZATION',       NULL,                0,          NULL,                   0),
    -- 现代化交通
    (258,       'TECH_MODERN_TRAFFIC_HD',                   40,     'LOC_BOOST_TRIGGER_MODERN_TRAFFIC_HD',                  'LOC_BOOST_TRIGGER_LONGDESC_MODERN_TRAFFIC_HD',                     NULL,                        'BOOST_TRIGGER_HAVE_X_IMPROVEMENTS',                NULL,           NULL,                      'IMPROVEMENT_MOUNTAIN_TUNNEL',NULL,                    NULL,                       NULL,                1,          NULL,                   0),
    -- 地质学
    (259,       'TECH_GEOLOGY_HD',                          40,     'LOC_BOOST_TRIGGER_GEOLOGY_HD',                         'LOC_BOOST_TRIGGER_LONGDESC_GEOLOGY_HD',                            NULL,                        'BOOST_TRIGGER_CULTURVATE_CIVIC',                   NULL,           NULL,                      NULL,                         NULL,                    'CIVIC_EVOLUTION_THEORY_HD',NULL,                0,          NULL,                   0),
    -- 海洋学
    (260,       'TECH_OCEANOGRAPHY_HD',                     40,     'LOC_BOOST_TRIGGER_OCEANOGRAPHY_HD',                    'LOC_BOOST_TRIGGER_LONGDESC_OCEANOGRAPHY_HD',                       NULL,                        'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                0,          NULL,                   0),
    -- 虚拟现实
    (261,       'TECH_VIRTUAL_REALITY_HD',                  40,     'LOC_BOOST_TRIGGER_MUST_STEAL',                         'Critical late game tech - boost description not needed',           NULL,                        'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                0,          NULL,                   0),
    -- 大数据
    (262,       'TECH_BIG_DATA_HD',                         40,     'LOC_BOOST_TRIGGER_MUST_STEAL',                         'Critical late game tech - boost description not needed',           NULL,                        'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                0,          NULL,                   0),
    -- 马鞍
    (263,       'TECH_SADDLE_HD',                           40,     'LOC_BOOST_TRIGGER_SADDLE_HD',                          'LOC_BOOST_TRIGGER_LONGDESC_SADDLE_HD',                             'UNIT_BARBARIAN_HORSEMAN',   'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE',                NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                2,          NULL,                   0),
    -- 集成电路
    (264,       'TECH_INTEGRATED_CIRCUIT_HD',               40,     'LOC_BOOST_TRIGGER_MUST_STEAL',                         'Critical late game tech - boost description not neededD',          NULL,                        'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                0,          NULL,                   0),
    -- 工业自动化
    (265,       'TECH_INDUSTRIAL_AUTOMATION_HD',            40,     'LOC_BOOST_TRIGGER_INDUSTRIAL_AUTOMATION_HD',           'LOC_BOOST_TRIGGER_LONGDESC_INDUSTRIAL_AUTOMATION_HD',              NULL,                        'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                0,          NULL,                   0),
    -- 测绘学
    (266,       'TECH_GEOMATICS_HD',                        40,     'LOC_BOOST_TRIGGER_GEOMATICS_HD',                       'LOC_BOOST_TRIGGER_LONGDESC_GEOMATICS_HD',                          NULL,                        'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_NILOMETER_HD',   NULL,                         NULL,                    NULL,                       NULL,                1,          NULL,                   0),
    -- 纺织
    (267,       'TECH_TEXTILE_HD',                          40,     'LOC_BOOST_TRIGGER_TEXTILE_HD',                         'LOC_BOOST_TRIGGER_LONGDESC_TEXTILE_HD',                            NULL,                        'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_FAIR',           NULL,                         NULL,                    NULL,                       NULL,                1,          NULL,                   0),
    -- 炼丹术
    (268,       'TECH_ALCHEMY_HD',                          40,     'LOC_BOOST_TRIGGER_ALCHEMY_HD',                         'LOC_BOOST_TRIGGER_LONGDESC_ALCHEMY_HD',                            NULL,                        'BOOST_TRIGGER_HAVE_X_IMPROVEMENTS',                NULL,           NULL,                      'IMPROVEMENT_MINE',           NULL,                    NULL,                       NULL,                1,          NULL,                   1),
    -- 制炭
    (269,       'TECH_FUEL_HD',                             40,     'LOC_BOOST_TRIGGER_FUEL_HD',                            'LOC_BOOST_TRIGGER_LONGDESC_FUEL_HD',                               NULL,                        'BOOST_TRIGGER_HAVE_X_IMPROVEMENTS',                NULL,           NULL,                      'IMPROVEMENT_LUMBER_MILL',    NULL,                    NULL,                       NULL,                2,          NULL,                   0),
    -- 履带
    (270,       'TECH_CATERPILLAR_TRACK_HD',                40,     'LOC_BOOST_TRIGGER_CATERPILLAR_TRACK_HD',               'LOC_BOOST_TRIGGER_LONGDESC_CATERPILLAR_TRACK_HD',                  NULL,                        'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                0,          NULL,                   0),
    -- 基因工程
    (271,       'TECH_GENETIC_ENGINEERING_HD',              40,     'LOC_BOOST_TRIGGER_GENETIC_ENGINEERING_HD',             'LOC_BOOST_TRIGGER_LONGDESC_GENETIC_ENGINEERING_HD',                NULL,                        'BOOST_TRIGGER_CULTURVATE_CIVIC',                   NULL,           NULL,                      NULL,                         NULL,                    'CIVIC_PALEOBIOLOGY_HD',    NULL,                0,          NULL,                   0),
    -- 制冷技术
    (272,       'TECH_REFRIGERATION_HD',                    40,     'LOC_BOOST_TRIGGER_REFRIGERATION_HD',                   'LOC_BOOST_TRIGGER_LONGDESC_REFRIGERATION_HD',                      NULL,                        'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                0,          NULL,                   0),
    -- 互联网
    (273,       'TECH_INTERNET_HD',                         40,     'LOC_BOOST_TRIGGER_INTERNET_HD',                        'LOC_BOOST_TRIGGER_LONGDESC_INTERNET_HD',                           NULL,                        'BOOST_TRIGGER_HAVE_X_BUILDINGS',                   NULL,           'BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE',    NULL,     NULL,                    NULL,                       NULL,                1,          NULL,                   0),
    -- 方帆
    (274,       'TECH_SQUARE_SAIL_HD',                      40,     'LOC_BOOST_TRIGGER_SQUARE_SAIL_HD',                     'LOC_BOOST_TRIGGER_LONGDESC_SQUARE_SAIL_HD',                        NULL,                        'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH',       NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                0,          NULL,                   0),
    -- 拱券
    (275,       'TECH_ARCH_HD',                             40,     'LOC_BOOST_TRIGGER_ARCH_HD',                            'LOC_BOOST_TRIGGER_LONGDESC_ARCH_HD',                               NULL,                        'BOOST_TRIGGER_HAVE_X_WONDERS',                     NULL,           NULL,                      NULL,                         NULL,                    NULL,                       NULL,                3,          NULL,                   0);

    -- 【航行】科技尤里卡改为：沿湖也可以触发
update Boosts set TriggerDescription = 'LOC_BOOST_TRIGGER_SAILING_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_SAILING_HD'
    where TechnologyType = 'TECH_SAILING';
-- 新科文版本 原有科文尤里卡&鼓舞调整
    -- 【教育】科技尤里卡改为：拥有科举制市政
update Boosts set BoostClass = 'BOOST_TRIGGER_CULTURVATE_CIVIC', Unit1Type = NULL, NumItems = 0,
    BoostingCivicType = 'CIVIC_IMPERIAL_EXAMINATION_SYSTEM_HD' where TechnologyType = 'TECH_EDUCATION';
    -- 【军事工程学】科技尤里卡改为：训练2个石弩
update Boosts set BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE', Unit1Type = 'UNIT_CATAPULT', NumItems = 2,
    DistrictType = NULL where TechnologyType = 'TECH_MILITARY_ENGINEERING';
    -- 【王权神授】市政鼓舞改为：训练1个使徒
update Boosts set BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE', Unit1Type = 'UNIT_APOSTLE', NumItems = 1,
    BuildingType = NULL where CivicType = 'CIVIC_DIVINE_RIGHT';
    -- 【归正会】市政鼓舞改为：建造2座寺庙
--update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS', NumItems = 2,
--    BuildingType = 'BUILDING_TEMPLE' where CivicType = 'CIVIC_REFORMED_CHURCH';
    -- 【后勤补给】市政鼓舞改为：拥有轮子科技
update Boosts set BoostClass = 'BOOST_TRIGGER_RESEARCH_TECH', Unit1Type = NULL, NumItems = 0, GovernmentTierType = NULL,
    BoostingTechType = 'TECH_THE_WHEEL' where CivicType = 'CIVIC_DEFENSIVE_TACTICS';
    -- 【飞行】科技尤里卡改为：训练2个观测气球
update Boosts set BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE', Unit1Type = 'UNIT_OBSERVATION_BALLOON',
    NumItems = 2 where TechnologyType = 'TECH_FLIGHT';
    -- 【无线电】科技尤里卡改为：拥有殖民主义市政
update Boosts set BoostClass = 'BOOST_TRIGGER_CULTURVATE_CIVIC',
    BoostingCivicType = 'CIVIC_COLONIALISM' where TechnologyType = 'TECH_RADIO';
    -- 【制导系统】科技尤里卡改为：训练2个战斗机
update Boosts set BoostClass = 'BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE', Unit1Type = 'UNIT_FIGHTER',
    NumItems = 2 where TechnologyType = 'TECH_GUIDANCE_SYSTEMS';
    -- 【封建主义】市政鼓舞改为：建造4个农场
update Boosts set NumItems = 4 where BoostID = 15;
    -- 【电脑】科技尤里卡改为：建造一座铝矿
update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_X_BUILDINGS', BuildingType = 'BUILDING_HD_ELECTRONICS_FACTORY', 
    NumItems = 2, GovernmentTierType = NULL where TechnologyType = 'TECH_COMPUTERS';
    -- 【纳米技术】科技尤里卡改为：建造一座铝矿，训练一个直升机
update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_UNIT_AND_IMPROVEMENT', 
    Unit1Type = 'UNIT_HELICOPTER' where TechnologyType = 'TECH_NANOTECHNOLOGY';
    -- 【工业化】科技尤里卡改为：建造4座工业区
update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_X_DISTRICTS', BuildingType = NULL, 
    NumItems = 4, DistrictType = 'DISTRICT_INDUSTRIAL_ZONE' where TechnologyType = 'TECH_INDUSTRIALIZATION';
    -- 【外交部门】市政鼓舞改为：2级同盟
update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_ALLIANCE_LEVEL_X', NumItems = 2 where CivicType = 'CIVIC_DIPLOMATIC_SERVICE';
    -- 【化学】科技尤里卡改为：大科或间谍触发
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', NumItems = 0, TriggerDescription = 'LOC_BOOST_TRIGGER_MUST_STEAL_NO_GREAT_SCIENTIST', 
    TriggerLongDescription = 'Critical late game tech - boost description not needed' where TechnologyType = 'TECH_CHEMISTRY';
    -- 【航海仪器】科技尤里卡
update Boosts set BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', NumItems = 0, Unit1Type = null,
    TriggerDescription = 'LOC_BOOST_TRIGGER_SQUARE_RIGGING_HD', TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_SQUARE_RIGGING_HD'
where TechnologyType = 'TECH_SQUARE_RIGGING';
    -- 【膛线】科技尤里卡改为：用火枪手击杀一个单位
--update Boosts set BoostClass = 'BOOST_TRIGGER_KILL_WITH', ImprovementType = NULL, 
--    ResourceType = NULL, Unit1Type = 'UNIT_MUSKETMAN' where TechnologyType = 'TECH_RIFLING';
--膛线尤里卡改为生产两个射石炮
--by 先驱
update Boosts set BoostClass = "BOOST_TRIGGER_OWN_X_UNITS_OF_TYPE", NumItems = 2, Unit1Type = "UNIT_BOMBARD",
    ImprovementType = NULL, ResourceType = NULL where TechnologyType ="TECH_RIFLING";
-- 公司模式 商业资本主义
update Boosts set BoostClass = "BOOST_TRIGGER_HAVE_X_IMPROVEMENTS", NumItems = 1, ImprovementType = "IMPROVEMENT_INDUSTRY",
    BoostingTechType = NULL, TriggerDescription = 'LOC_BOOST_TRIGGER_COMMERCIAL_CAPITALISM_HD_CORP' where CivicType ="CIVIC_COMMERCIAL_CAPITALISM_HD"
    and exists (select ImprovementType from Improvements where ImprovementType = 'IMPROVEMENT_INDUSTRY');

-- update boost ratio at last
update Boosts set Boost = 34 where Boost = 40;

--卫星ulk更改
update Boosts set TriggerDescription = 'LOC_BOOST_TECH_SATELLITES_HD', TriggerLongDescription = 'LOC_BOOST_TECH_SATELLITES_HD_LONG', BoostClass = 'BOOST_TRIGGER_NONE_LATE_GAME_CRITICAL_TECH', BuildingType = NULL, NumItems = 0 where TechnologyType = 'TECH_SATELLITES';
insert or replace into ProjectCompletionModifiers
	(ProjectType,						ModifierId)
values
	('PROJECT_LAUNCH_EARTH_SATELLITE',	'TECH_SATELLITES_BOOST');
insert or replace into Modifiers
	(ModifierId,						ModifierType)
values
	('TECH_SATELLITES_BOOST',			'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST');
insert or replace into ModifierArguments
	(ModifierId,						Name,			Value)
values
	('TECH_SATELLITES_BOOST',			'TechType',		'TECH_SATELLITES');
