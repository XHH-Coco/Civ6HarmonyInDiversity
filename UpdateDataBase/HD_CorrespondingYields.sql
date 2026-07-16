------------------- 对应产出 -------------------
create table if not exists DistrictCorrespondingYieldType_HD(
  DistrictType        TEXT    not NULL,
  YieldType           TEXT    not NULL,
  Amount              INT     DEFAULT 1,
  RequiresPopulation  BOOLEAN DEFAULT 1,
  HasAdjacency        BOOLEAN DEFAULT 0,
PRIMARY KEY('DistrictType'));

-- 专业化区域对应产出
insert or ignore into DistrictCorrespondingYieldType_HD (DistrictType, YieldType, Amount, RequiresPopulation, HasAdjacency) values
  ('DISTRICT_HOLY_SITE',          'YIELD_FAITH',      1,          1,                  1),
  ('DISTRICT_CAMPUS',             'YIELD_SCIENCE',    1,          1,                  1),
  ('DISTRICT_ENCAMPMENT',         'YIELD_PRODUCTION', 1,          1,                  1),
  ('DISTRICT_HARBOR',             'YIELD_GOLD',       3,          1,                  1),
  ('DISTRICT_COMMERCIAL_HUB',     'YIELD_GOLD',       3,          1,                  1),
  ('DISTRICT_THEATER',            'YIELD_CULTURE',    1,          1,                  1),
  ('DISTRICT_INDUSTRIAL_ZONE',    'YIELD_PRODUCTION', 1,          1,                  1),
  ('DISTRICT_GOVERNMENT',         'YIELD_CULTURE',    1,          1,                  0);

insert or ignore into DistrictCorrespondingYieldType_HD (DistrictType, YieldType, Amount, RequiresPopulation) select
  'DISTRICT_DIPLOMATIC_QUARTER', 'YIELD_GOLD', 3, 1
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into DistrictCorrespondingYieldType_HD (DistrictType, YieldType, Amount, RequiresPopulation, HasAdjacency) select
  'DISTRICT_C_AGRICULTURE', 'YIELD_FOOD', 1, 1, 1
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');

-- 非专业化区域对应产出
insert or ignore into DistrictCorrespondingYieldType_HD (DistrictType, YieldType, Amount, RequiresPopulation) values
  ('DISTRICT_CITY_CENTER',                'YIELD_PRODUCTION', 1,          0),
  ('DISTRICT_AQUEDUCT',                   'YIELD_FOOD',       1,          0),
  ('DISTRICT_ENTERTAINMENT_COMPLEX',      'YIELD_GOLD',       3,          0),
  ('DISTRICT_WATER_ENTERTAINMENT_COMPLEX','YIELD_GOLD',       3,          0),
  ('DISTRICT_DAM',                        'YIELD_FOOD',       1,          0),
  ('DISTRICT_CANAL',                      'YIELD_GOLD',       3,          0),
  ('DISTRICT_NEIGHBORHOOD',               'YIELD_PRODUCTION', 1,          0),
  ('DISTRICT_AERODROME',                  'YIELD_GOLD',       3,          0);

insert or ignore into DistrictCorrespondingYieldType_HD (DistrictType, YieldType, Amount, RequiresPopulation) select
  'DISTRICT_PRESERVE', 'YIELD_FOOD', 1, 0
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_PRESERVE');

-- 区域对应伟人点
create table if not exists DistrictCorrespondingGPP_HD(
  DistrictType            TEXT    not NULL,
  GreatPersonClassType    TEXT    not NULL,
PRIMARY KEY('DistrictType', 'GreatPersonClassType'));

insert or ignore into DistrictCorrespondingGPP_HD (DistrictType, GreatPersonClassType) values
  ('DISTRICT_HOLY_SITE',          'GREAT_PERSON_CLASS_PROPHET'),
  ('DISTRICT_CAMPUS',             'GREAT_PERSON_CLASS_SCIENTIST'),
  ('DISTRICT_ENCAMPMENT',         'GREAT_PERSON_CLASS_GENERAL'),
  ('DISTRICT_HARBOR',             'GREAT_PERSON_CLASS_ADMIRAL'),
  ('DISTRICT_COMMERCIAL_HUB',     'GREAT_PERSON_CLASS_MERCHANT'),
  ('DISTRICT_THEATER',            'GREAT_PERSON_CLASS_WRITER'),
  ('DISTRICT_THEATER',            'GREAT_PERSON_CLASS_ARTIST'),
  ('DISTRICT_THEATER',            'GREAT_PERSON_CLASS_MUSICIAN'),
  ('DISTRICT_INDUSTRIAL_ZONE',    'GREAT_PERSON_CLASS_ENGINEER');

insert or ignore into DistrictCorrespondingGPP_HD (DistrictType, GreatPersonClassType)
  select 'DISTRICT_C_AGRICULTURE', 'GREAT_PERSON_CLASS_AGRONOMIST'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');

-- 伟人对应产出
create table if not exists GreatPersonCorrespondingYieldType_HD(
  GreatPersonClassType    TEXT    not NULL,
  YieldType               TEXT    not NULL,
  Amount                  INT     not NULL,
PRIMARY KEY('GreatPersonClassType'));

insert or ignore into GreatPersonCorrespondingYieldType_HD (GreatPersonClassType, YieldType, Amount) values
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

insert or ignore into CityStateCorrespondingYieldType_HD (CityStateType, YieldType, Amount) values
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

insert or ignore into CityStateCorrespondingDistrict_HD (CityStateType, DistrictType) values
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

insert or ignore into CityStateCorrespondingGPP_HD (CityStateType, GreatPersonClassType, Amount) values
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

insert or ignore into AllianceCorrespondingYieldType_HD (AllianceType, YieldType, Amount) values
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

insert or ignore into AllianceCorrespondingGPP_HD (AllianceType, GreatPersonClassType, Amount) values
  ('ALLIANCE_RESEARCH',   'GREAT_PERSON_CLASS_SCIENTIST',     1),
  ('ALLIANCE_RELIGIOUS',  'GREAT_PERSON_CLASS_PROPHET',       1),
  ('ALLIANCE_ECONOMIC',   'GREAT_PERSON_CLASS_MERCHANT',      1),
  ('ALLIANCE_CULTURAL',   'GREAT_PERSON_CLASS_WRITER',        1),
  ('ALLIANCE_CULTURAL',   'GREAT_PERSON_CLASS_ARTIST',        1),
  ('ALLIANCE_CULTURAL',   'GREAT_PERSON_CLASS_MUSICIAN',      1),
  ('ALLIANCE_MILITARY',   'GREAT_PERSON_CLASS_GENERAL',       1),
  ('ALLIANCE_MILITARY',   'GREAT_PERSON_CLASS_ADMIRAL',       1);