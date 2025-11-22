-------------------------------------
--          Early Setup            --
-------------------------------------

create table if not exists 'HDCounter'(
	'Count' INT NOT NULL,
	PRIMARY KEY(Count)
);
insert or ignore into HDCounter (Count) values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15);

create table if not exists 'HD_Binary_Compress'(
	'Exp' INT NOT NULL,
	'Amount' INT NOT NULL,
	PRIMARY KEY('Exp')
);
insert or ignore into HD_Binary_Compress ('Exp', 'Amount') values (0,1),(1,2),(2,4),(3,8),(4,16),(5,32),(6,64),(7,128),(8,256),(9,512);

insert or replace into GlobalParameters (Name, Value) values ('HD_BINARY_COMPRESS_MAX_EXP', 9);

create table if not exists 'HD_Binary_Compress_Keys'(
	'Key' TEXT NOT NULL,
	'MaxExp' INT NOT NULL Default 9,
	PRIMARY KEY('Key')
);

-- 着力点图标
create table if not exists 'CommemorationIcons'(
	'CommemorationType' TEXT    not NULL,
	'Icon'              TEXT    not NULL,
	PRIMARY KEY('CommemorationType')
);

-- Influence Bonus
--delete from TraitModifiers where
--    (TraitType in (select TraitType from CSE_ClassTypes)) and 
--    (ModifierId like '%_SMALL_INFLUENCE_%' or 
--    ModifierId like '%_MEDIUM_INFLUENCE_%' or 
--    ModifierId like '%_LARGE_INFLUENCE_%' or 
--    ModifierId like '%_LARGEST_INFLUENCE_%' or
--    ModifierId like 'MODIFIER_CSE_%');

create table if not exists CityStateInfluenceBonus_HD(
    Type                TEXT    not NULL,
    TraitType           TEXT    not NULL,
    Level               TEXT    not NULL,
    YieldType           TEXT    not NULL,
    Tier                INT     DEFAULT 0,
    Amount              INT     DEFAULT 0,
    AttachModifierId    TEXT    DEFAULT NULL,
    ModifierId          TEXT    DEFAULT NULL,
    ModifierType        TEXT    DEFAULT NULL,
    RequirementSetId    TEXT    DEFAULT NULL,
    IsYieldChange       INT     DEFAULT 0,
    PRIMARY KEY('Type', 'Level', 'YieldType'));

insert or replace into CityStateInfluenceBonus_HD (Type, TraitType, Tier, Level, YieldType, Amount)
select Type, TraitType, 0, 'SMALL',     'YIELD_FOOD', 1 from CSE_ClassTypes;
insert or replace into CityStateInfluenceBonus_HD (Type, TraitType, Tier, Level, YieldType, Amount)
select Type, TraitType, 1, 'MEDIUM',    'YIELD_FOOD', 1 from CSE_ClassTypes;
insert or replace into CityStateInfluenceBonus_HD (Type, TraitType, Tier, Level, YieldType, Amount)
select Type, TraitType, 2, 'LARGE',     'YIELD_FOOD', 2 from CSE_ClassTypes;
insert or replace into CityStateInfluenceBonus_HD (Type, TraitType, Tier, Level, YieldType, Amount)
select Type, TraitType, 3, 'LARGEST',   'YIELD_FOOD', 3 from CSE_ClassTypes;
update CityStateInfluenceBonus_HD set YieldType = 'YIELD_SCIENCE'       where Type = 'SCIENTIFIC';
update CityStateInfluenceBonus_HD set YieldType = 'YIELD_FAITH'         where Type = 'RELIGIOUS';
update CityStateInfluenceBonus_HD set YieldType = 'YIELD_GOLD'          where Type = 'TRADE';
update CityStateInfluenceBonus_HD set YieldType = 'YIELD_CULTURE'       where Type = 'CULTURAL';
update CityStateInfluenceBonus_HD set YieldType = 'YIELD_PRODUCTION'    where Type = 'MILITARISTIC';
update CityStateInfluenceBonus_HD set YieldType = 'YIELD_PRODUCTION'    where Type = 'INDUSTRIAL';
-- 
update CityStateInfluenceBonus_HD set YieldType = 'YIELD_GOLD'          where Type = 'CSE_MARITIME';

insert or replace into CityStateInfluenceBonus_HD
    (Type,          TraitType,                      Tier,   Level,      YieldType,              Amount)
values
    ('INDUSTRIAL',  'MINOR_CIV_INDUSTRIAL_TRAIT',   0,      'SMALL',    'BUILDING_PRODUCTION',  1),
    ('INDUSTRIAL',  'MINOR_CIV_INDUSTRIAL_TRAIT',   1,      'MEDIUM',   'BUILDING_PRODUCTION',  1),
    ('INDUSTRIAL',  'MINOR_CIV_INDUSTRIAL_TRAIT',   2,      'LARGE',    'BUILDING_PRODUCTION',  2),
    ('INDUSTRIAL',  'MINOR_CIV_INDUSTRIAL_TRAIT',   3,      'LARGEST',  'BUILDING_PRODUCTION',  3);

update CityStateInfluenceBonus_HD set Amount = Amount * 2 where YieldType = 'YIELD_GOLD';
update CityStateInfluenceBonus_HD set IsYieldChange = YieldType in (select YieldType from Yields);
update CityStateInfluenceBonus_HD set ModifierType = 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE' where IsYieldChange = 1;
update CityStateInfluenceBonus_HD set ModifierType = 'MODIFIER_PLAYER_CITIES_ADJUST_'||YieldType||'_CHANGE' where IsYieldChange = 0;
update CityStateInfluenceBonus_HD set ModifierType = 'MODIFIER_PLAYER_CAPITAL_CITY_ADJUST_CITY_YIELD_CHANGE' where Level = 'SMALL' and IsYieldChange = 1;
update CityStateInfluenceBonus_HD set ModifierType = 'MODIFIER_PLAYER_CAPITAL_CITY_ADJUST_'||YieldType where Level = 'SMALL' and IsYieldChange = 0;
update CityStateInfluenceBonus_HD set RequirementSetId = 'HD_CITY_HAS_'||Type||'_TIER_'||Tier||'_BUILDING_REQUIREMENTS' where Level != 'SMALL';
update CityStateInfluenceBonus_HD set ModifierId = TraitType || '_' || Level || '_INFLUENCE_' || YieldType || '_HD';
update CityStateInfluenceBonus_HD set AttachModifierId = ModifierId || '_ATTACH';

--insert or replace into TraitModifiers (TraitType, ModifierId) select TraitType, AttachModifierId from CityStateInfluenceBonus_HD;
insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
select AttachModifierId, 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_HAS_'||Level||'_INFLUENCE' from CityStateInfluenceBonus_HD;
insert or replace into ModifierArguments (ModifierId, Name, Value)
select AttachModifierId, 'ModifierId', ModifierId from CityStateInfluenceBonus_HD;
insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
select ModifierId, ModifierType, RequirementSetId from CityStateInfluenceBonus_HD;
insert or replace into ModifierArguments (ModifierId, Name, Value)
select ModifierId, 'Amount', Amount from CityStateInfluenceBonus_HD;
insert or replace into ModifierArguments (ModifierId, Name, Value)
select ModifierId, 'YieldType', YieldType from CityStateInfluenceBonus_HD where IsYieldChange = 1;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
select RequirementSetId, 'REQUIREMENTSET_TEST_ANY' from CityStateInfluenceBonus_HD where Level != 'SMALL';
insert or ignore into RequirementSetRequirements
    (RequirementSetId,                                          RequirementId)
values
    ('HD_CITY_HAS_SCIENTIFIC_TIER_1_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_LIBRARY'),
    ('HD_CITY_HAS_SCIENTIFIC_TIER_2_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_UNIVERSITY'),
    ('HD_CITY_HAS_SCIENTIFIC_TIER_2_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_MADRASA'),
    ('HD_CITY_HAS_SCIENTIFIC_TIER_3_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_RESEARCH_LAB'),
    ('HD_CITY_HAS_RELIGIOUS_TIER_1_BUILDING_REQUIREMENTS',      'REQUIRES_CITY_HAS_BUILDING_SHRINE'),
    ('HD_CITY_HAS_RELIGIOUS_TIER_2_BUILDING_REQUIREMENTS',      'REQUIRES_CITY_HAS_BUILDING_TEMPLE'),
    ('HD_CITY_HAS_RELIGIOUS_TIER_2_BUILDING_REQUIREMENTS',      'REQUIRES_CITY_HAS_BUILDING_HD_ALCHEMY_ROOM'),
    ('HD_CITY_HAS_TRADE_TIER_1_BUILDING_REQUIREMENTS',          'REQUIRES_CITY_HAS_BUILDING_FAIR'),
    ('HD_CITY_HAS_TRADE_TIER_1_BUILDING_REQUIREMENTS',          'REQUIRES_CITY_HAS_BUILDING_MARKET'),
    ('HD_CITY_HAS_TRADE_TIER_2_BUILDING_REQUIREMENTS',          'REQUIRES_CITY_HAS_BUILDING_BANK'),
    ('HD_CITY_HAS_TRADE_TIER_3_BUILDING_REQUIREMENTS',          'REQUIRES_CITY_HAS_BUILDING_STOCK_EXCHANGE'),
    ('HD_CITY_HAS_TRADE_TIER_1_BUILDING_REQUIREMENTS',          'REQUIRES_CITY_HAS_BUILDING_LIGHTHOUSE'),
    ('HD_CITY_HAS_TRADE_TIER_2_BUILDING_REQUIREMENTS',          'REQUIRES_CITY_HAS_BUILDING_SHIPYARD'),
    ('HD_CITY_HAS_TRADE_TIER_3_BUILDING_REQUIREMENTS',          'REQUIRES_CITY_HAS_BUILDING_SEAPORT'),
    ('HD_CITY_HAS_CULTURAL_TIER_1_BUILDING_REQUIREMENTS',       'REQUIRES_CITY_HAS_BUILDING_AMPHITHEATER'),
    ('HD_CITY_HAS_CULTURAL_TIER_2_BUILDING_REQUIREMENTS',       'REQUIRES_CITY_HAS_BUILDING_MUSEUM_ART'),
    ('HD_CITY_HAS_CULTURAL_TIER_2_BUILDING_REQUIREMENTS',       'REQUIRES_CITY_HAS_BUILDING_MUSEUM_ARTIFACT'),
    ('HD_CITY_HAS_CULTURAL_TIER_3_BUILDING_REQUIREMENTS',       'REQUIRES_CITY_HAS_BUILDING_BROADCAST_CENTER'),
    ('HD_CITY_HAS_MILITARISTIC_TIER_1_BUILDING_REQUIREMENTS',   'REQUIRES_CITY_HAS_BUILDING_BARRACKS'),
    ('HD_CITY_HAS_MILITARISTIC_TIER_1_BUILDING_REQUIREMENTS',   'REQUIRES_CITY_HAS_BUILDING_STABLE'),
    ('HD_CITY_HAS_MILITARISTIC_TIER_2_BUILDING_REQUIREMENTS',   'REQUIRES_CITY_HAS_BUILDING_ARMORY'),
    ('HD_CITY_HAS_MILITARISTIC_TIER_3_BUILDING_REQUIREMENTS',   'REQUIRES_CITY_HAS_BUILDING_MILITARY_ACADEMY'),
    ('HD_CITY_HAS_INDUSTRIAL_TIER_1_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_WORKSHOP'),
    ('HD_CITY_HAS_INDUSTRIAL_TIER_2_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_FACTORY'),
    ('HD_CITY_HAS_INDUSTRIAL_TIER_2_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_HD_ELECTRONICS_FACTORY'),
    ('HD_CITY_HAS_INDUSTRIAL_TIER_3_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_POWER_PLANT'),
    ('HD_CITY_HAS_INDUSTRIAL_TIER_3_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_COAL_POWER_PLANT'),
    ('HD_CITY_HAS_INDUSTRIAL_TIER_3_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_FOSSIL_FUEL_POWER_PLANT'),
    ('HD_CITY_HAS_INDUSTRIAL_TIER_3_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_HD_INTERNET_COMPANY');

insert or ignore into RequirementSetRequirements
    (RequirementSetId,                                          RequirementId)
select
    'HD_CITY_HAS_RELIGIOUS_TIER_2_BUILDING_REQUIREMENTS',       'REQUIRES_CITY_HAS_BUILDING_STAVE_CHURCH'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_STAVE_CHURCH');

insert or ignore into RequirementSetRequirements
    (RequirementSetId,                                          RequirementId)
select
    'HD_CITY_HAS_TRADE_TIER_1_BUILDING_REQUIREMENTS',           'REQUIRES_CITY_HAS_BUILDING_SUKIENNICE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SUKIENNICE');

insert or replace into RequirementSetRequirements (RequirementSetId,    RequirementId)
select 'HD_CITY_HAS_CSE_AGRICULTURAL_TIER_1_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_GRANARY'
from CSE_ClassTypes where Type = 'CSE_AGRICULTURAL';
insert or replace into RequirementSetRequirements (RequirementSetId,    RequirementId)
select 'HD_CITY_HAS_CSE_AGRICULTURAL_TIER_2_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_DISTRICT_AQUEDUCT'
from CSE_ClassTypes where Type = 'CSE_AGRICULTURAL';
insert or replace into RequirementSetRequirements (RequirementSetId,    RequirementId)
select 'HD_CITY_HAS_CSE_AGRICULTURAL_TIER_3_BUILDING_REQUIREMENTS',     'REQUIRES_CITY_HAS_BUILDING_SEWER'
from CSE_ClassTypes where Type = 'CSE_AGRICULTURAL';

-- Assume Maritime is enabled when CIVITAS enabled.
update RequirementSetRequirements set RequirementSetId = 'HD_CITY_HAS_CSE_MARITIME_TIER_1_BUILDING_REQUIREMENTS'
where exists (select Type from CSE_ClassTypes where Type = 'CSE_MARITIME') and 
    (RequirementSetId = 'HD_CITY_HAS_TRADE_TIER_1_BUILDING_REQUIREMENTS' and RequirementId = 'REQUIRES_CITY_HAS_BUILDING_LIGHTHOUSE');
update RequirementSetRequirements set RequirementSetId = 'HD_CITY_HAS_CSE_MARITIME_TIER_2_BUILDING_REQUIREMENTS'
where exists (select Type from CSE_ClassTypes where Type = 'CSE_MARITIME') and 
    (RequirementSetId = 'HD_CITY_HAS_TRADE_TIER_2_BUILDING_REQUIREMENTS' and RequirementId = 'REQUIRES_CITY_HAS_BUILDING_SHIPYARD');
update RequirementSetRequirements set RequirementSetId = 'HD_CITY_HAS_CSE_MARITIME_TIER_3_BUILDING_REQUIREMENTS'
where exists (select Type from CSE_ClassTypes where Type = 'CSE_MARITIME') and 
    (RequirementSetId = 'HD_CITY_HAS_TRADE_TIER_3_BUILDING_REQUIREMENTS' and RequirementId = 'REQUIRES_CITY_HAS_BUILDING_SEAPORT');

insert or replace into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'HD_CITY_HAS_RELIGIOUS_TIER_3_BUILDING_REQUIREMENTS', 'REQUIRES_CITY_HAS_'||BuildingType from Buildings where EnabledByReligion = 1;

------------------- 需要Lua统计城市改良数量的改良 -------------------
create table if not exists ImprovementsNeedCount_HD(
    ImprovementType         TEXT    not NULL,
PRIMARY KEY('ImprovementType'));

------------------- 允许改良特定地形地貌上资源的改良 -------------------
create table if not exists ImprovementsRules_HD(
    ImprovementType         TEXT    not NULL,
PRIMARY KEY('ImprovementType'));

------------------- 对应产出 -------------------
create table if not exists DistrictCorrespondingYieldType_HD(
    DistrictType        TEXT    not NULL,
    YieldType           TEXT    not NULL,
    Amount              INT     DEFAULT 1,
    RequiresPopulation  BOOLEAN DEFAULT 1,
    HasAdjacency        BOOLEAN DEFAULT 0,
PRIMARY KEY('DistrictType'));

-- 专业化区域对应产出
insert or ignore into DistrictCorrespondingYieldType_HD
    (DistrictType,                  YieldType,          Amount,     RequiresPopulation, HasAdjacency)
values
    ('DISTRICT_HOLY_SITE',          'YIELD_FAITH',      1,          1,                  1),
    ('DISTRICT_CAMPUS',             'YIELD_SCIENCE',    1,          1,                  1),
    ('DISTRICT_ENCAMPMENT',         'YIELD_PRODUCTION', 1,          1,                  1),
    ('DISTRICT_HARBOR',             'YIELD_GOLD',       3,          1,                  1),
    ('DISTRICT_COMMERCIAL_HUB',     'YIELD_GOLD',       3,          1,                  1),
    ('DISTRICT_THEATER',            'YIELD_CULTURE',    1,          1,                  1),
    ('DISTRICT_INDUSTRIAL_ZONE',    'YIELD_PRODUCTION', 1,          1,                  1),
    ('DISTRICT_GOVERNMENT',         'YIELD_CULTURE',    1,          1,                  0);

insert or ignore into DistrictCorrespondingYieldType_HD
    (DistrictType,                  YieldType,          Amount,     RequiresPopulation)
select
    'DISTRICT_DIPLOMATIC_QUARTER', 'YIELD_GOLD',       3,           1
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into DistrictCorrespondingYieldType_HD
    (DistrictType,                  YieldType,          Amount,     RequiresPopulation, HasAdjacency)
select
    'DISTRICT_C_AGRICULTURE',       'YIELD_FOOD',       1,           1,                 1
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');

-- 非专业化区域对应产出
insert or ignore into DistrictCorrespondingYieldType_HD
    (DistrictType,                          YieldType,          Amount,     RequiresPopulation)
values
    ('DISTRICT_CITY_CENTER',                'YIELD_PRODUCTION', 1,          0),
    ('DISTRICT_AQUEDUCT',                   'YIELD_FOOD',       1,          0),
    ('DISTRICT_ENTERTAINMENT_COMPLEX',      'YIELD_GOLD',       3,          0),
    ('DISTRICT_WATER_ENTERTAINMENT_COMPLEX','YIELD_GOLD',       3,          0),
    ('DISTRICT_DAM',                        'YIELD_FOOD',       1,          0),
    ('DISTRICT_CANAL',                      'YIELD_GOLD',       3,          0),
    ('DISTRICT_NEIGHBORHOOD',               'YIELD_PRODUCTION', 1,          0),
    ('DISTRICT_AERODROME',                  'YIELD_GOLD',       3,          0);

insert or ignore into DistrictCorrespondingYieldType_HD
    (DistrictType,                  YieldType,          Amount,     RequiresPopulation)
select
    'DISTRICT_PRESERVE',            'YIELD_FOOD',       1,           0
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_PRESERVE');

-- 区域对应伟人点
create table if not exists DistrictCorrespondingGPP_HD(
    DistrictType            TEXT    not NULL,
    GreatPersonClassType    TEXT    not NULL,
PRIMARY KEY('DistrictType', 'GreatPersonClassType'));

insert or ignore into DistrictCorrespondingGPP_HD
    (DistrictType,                  GreatPersonClassType)
values
    ('DISTRICT_HOLY_SITE',          'GREAT_PERSON_CLASS_PROPHET'),
    ('DISTRICT_CAMPUS',             'GREAT_PERSON_CLASS_SCIENTIST'),
    ('DISTRICT_ENCAMPMENT',         'GREAT_PERSON_CLASS_GENERAL'),
    ('DISTRICT_HARBOR',             'GREAT_PERSON_CLASS_ADMIRAL'),
    ('DISTRICT_COMMERCIAL_HUB',     'GREAT_PERSON_CLASS_MERCHANT'),
    ('DISTRICT_THEATER',            'GREAT_PERSON_CLASS_WRITER'),
    ('DISTRICT_THEATER',            'GREAT_PERSON_CLASS_ARTIST'),
    ('DISTRICT_THEATER',            'GREAT_PERSON_CLASS_MUSICIAN'),
    ('DISTRICT_INDUSTRIAL_ZONE',    'GREAT_PERSON_CLASS_ENGINEER');

insert or ignore into DistrictCorrespondingGPP_HD(DistrictType, GreatPersonClassType)
select 'DISTRICT_C_AGRICULTURE', 'GREAT_PERSON_CLASS_AGRONOMIST'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');

-- 伟人对应产出
create table if not exists GreatPersonCorrespondingYieldType_HD(
    GreatPersonClassType    TEXT    not NULL,
    YieldType               TEXT    not NULL,
    Amount                  INT     not NULL,
PRIMARY KEY('GreatPersonClassType'));

insert or ignore into GreatPersonCorrespondingYieldType_HD
    (GreatPersonClassType,              YieldType,          Amount)
values
    ('GREAT_PERSON_CLASS_PROPHET',      'YIELD_FAITH',      1),
    ('GREAT_PERSON_CLASS_SCIENTIST',    'YIELD_SCIENCE',    1),
    ('GREAT_PERSON_CLASS_GENERAL',      'YIELD_PRODUCTION', 1),
    ('GREAT_PERSON_CLASS_ADMIRAL',      'YIELD_GOLD',       3),
    ('GREAT_PERSON_CLASS_MERCHANT',     'YIELD_GOLD',       3),
    ('GREAT_PERSON_CLASS_WRITER',       'YIELD_CULTURE',    1),
    ('GREAT_PERSON_CLASS_ARTIST',       'YIELD_CULTURE',    1),
    ('GREAT_PERSON_CLASS_MUSICIAN',     'YIELD_CULTURE',    1),
    ('GREAT_PERSON_CLASS_ENGINEER',     'YIELD_PRODUCTION', 1);

insert or ignore into GreatPersonCorrespondingYieldType_HD(GreatPersonClassType, YieldType, Amount)
select 'GREAT_PERSON_CLASS_AGRONOMIST', 'YIELD_FOOD', 1
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');

-- 城邦对应产出
create table if not exists CityStateCorrespondingYieldType_HD(
    CityStateType           TEXT    not NULL,
    YieldType               TEXT    not NULL,
    Amount                  INT     not NULL,
PRIMARY KEY('CityStateType'));

insert or ignore into CityStateCorrespondingYieldType_HD
    (CityStateType,         YieldType,          Amount)
values
    ('SCIENTIFIC',          'YIELD_SCIENCE',    1),
    ('RELIGIOUS',           'YIELD_FAITH',      1),
    ('TRADE',               'YIELD_GOLD',       3),
    ('CULTURAL',            'YIELD_CULTURE',    1),
    ('MILITARISTIC',        'YIELD_PRODUCTION', 1),
    ('INDUSTRIAL',          'YIELD_PRODUCTION', 1);

-- 城邦对应区域
create table if not exists CityStateCorrespondingDistrict_HD(
    CityStateType   TEXT    not NULL,
    DistrictType    TEXT    not NULL,
PRIMARY KEY('CityStateType', 'DistrictType'));

insert or ignore into CityStateCorrespondingDistrict_HD
    (CityStateType,         DistrictType)
values
    ('SCIENTIFIC',          'DISTRICT_CAMPUS'),
    ('RELIGIOUS',           'DISTRICT_HOLY_SITE'),
    ('TRADE',               'DISTRICT_HARBOR'),
    ('TRADE',               'DISTRICT_COMMERCIAL_HUB'),
    ('CULTURAL',            'DISTRICT_THEATER'),
    ('MILITARISTIC',        'DISTRICT_ENCAMPMENT'),
    ('INDUSTRIAL',          'DISTRICT_INDUSTRIAL_ZONE');

-- 城邦对应伟人点
create table if not exists CityStateCorrespondingGPP_HD(
    CityStateType           TEXT    not NULL,
    GreatPersonClassType    TEXT    not NULL,
    Amount                  INT     not NULL,
PRIMARY KEY('CityStateType', 'GreatPersonClassType'));

insert or ignore into CityStateCorrespondingGPP_HD
    (CityStateType,         GreatPersonClassType,               Amount)
values
    ('SCIENTIFIC',          'GREAT_PERSON_CLASS_SCIENTIST',     3),
    ('RELIGIOUS',           'GREAT_PERSON_CLASS_PROPHET',       3),
    ('TRADE',               'GREAT_PERSON_CLASS_ADMIRAL',       3),
    ('TRADE',               'GREAT_PERSON_CLASS_MERCHANT',      3),
    ('CULTURAL',            'GREAT_PERSON_CLASS_WRITER',        1),
    ('CULTURAL',            'GREAT_PERSON_CLASS_ARTIST',        1),
    ('CULTURAL',            'GREAT_PERSON_CLASS_MUSICIAN',      1),
    ('MILITARISTIC',        'GREAT_PERSON_CLASS_GENERAL',       3),
    ('INDUSTRIAL',          'GREAT_PERSON_CLASS_ENGINEER',      3);

-- 同盟对应产出
create table if not exists AllianceCorrespondingYieldType_HD(
    AllianceType           TEXT    not NULL,
    YieldType              TEXT    not NULL,
    Amount                 INT     not NULL,
PRIMARY KEY('AllianceType'));

insert or ignore into AllianceCorrespondingYieldType_HD
    (AllianceType,          YieldType,              Amount)
values
    ('ALLIANCE_RESEARCH',   'YIELD_SCIENCE',        1),
    ('ALLIANCE_RELIGIOUS',  'YIELD_FAITH',          1),
    ('ALLIANCE_ECONOMIC',   'YIELD_GOLD',           3),
    ('ALLIANCE_CULTURAL',   'YIELD_CULTURE',        1),
    ('ALLIANCE_MILITARY',   'YIELD_PRODUCTION',     1);

-- 同盟对应伟人点
create table if not exists AllianceCorrespondingGPP_HD(
    AllianceType           TEXT    not NULL,
    GreatPersonClassType   TEXT    not NULL,
    Amount                 INT     not NULL,
PRIMARY KEY('AllianceType', 'GreatPersonClassType'));

insert or ignore into AllianceCorrespondingGPP_HD
    (AllianceType,          GreatPersonClassType,               Amount)
values
    ('ALLIANCE_RESEARCH',   'GREAT_PERSON_CLASS_SCIENTIST',     1),
    ('ALLIANCE_RELIGIOUS',  'GREAT_PERSON_CLASS_PROPHET',       1),
    ('ALLIANCE_ECONOMIC',   'GREAT_PERSON_CLASS_MERCHANT',      1),
    ('ALLIANCE_CULTURAL',   'GREAT_PERSON_CLASS_WRITER',        1),
    ('ALLIANCE_CULTURAL',   'GREAT_PERSON_CLASS_ARTIST',        1),
    ('ALLIANCE_CULTURAL',   'GREAT_PERSON_CLASS_MUSICIAN',      1),
    ('ALLIANCE_MILITARY',   'GREAT_PERSON_CLASS_GENERAL',       1),
    ('ALLIANCE_MILITARY',   'GREAT_PERSON_CLASS_ADMIRAL',       1);