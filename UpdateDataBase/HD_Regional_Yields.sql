-- Regional Range bug fix
--		Let A be a non-regional building and B be a regional building, which are exclusive (defined in MutuallyExclusiveBuildings)
--		When the following conditions are BOTH met:
-- 			There is a Modifier that extends the Regional Range of B, e.g. Rationalism
-- 			The CURRENT yield (including basic yield plus the yields given by EFFECT_ADJUST_BUILDING_YIELD_CHANGE) of A >= the BASIC yield of B
--		Then the bug happens, and the city of A cannot receive the regional yield of B
-- To fix the bug, rewrite all regional yield by Modifiers. Things to adapt: Policy, Mexico City, Magnus, Watt, England, Forging Iron
-- Record regional range in HD_BuildingRegionalRange

-- 定义辐射产出类型
insert or replace into HD_BuildingRegionalYieldTypes (YieldType, Name, IconString) values
  ('YIELD_FOOD',        'LOC_YIELD_FOOD_NAME',        '[ICON_Food]'),
  ('YIELD_PRODUCTION',  'LOC_YIELD_PRODUCTION_NAME',  '[ICON_Production]'),
  ('YIELD_SCIENCE',     'LOC_YIELD_SCIENCE_NAME',     '[ICON_Science]'),
  ('YIELD_CULTURE',     'LOC_YIELD_CULTURE_NAME',     '[ICON_Culture]'),
  ('YIELD_GOLD',        'LOC_YIELD_GOLD_NAME',        '[ICON_Gold]'),
  ('YIELD_FAITH',       'LOC_YIELD_FAITH_NAME',       '[ICON_Faith]'),
  ('AMENITY',           'LOC_AMENITY_NAME',           '[ICON_Amenities]');

-- 辐射范围
insert or replace into HD_BuildingRegionalRange (BuildingType, RegionalRange) select
	BuildingType,	RegionalRange
from Buildings where RegionalRange > 0;

update Buildings set RegionalRange = 0 where
	BuildingType in (select BuildingType from HD_BuildingRegionalRange) and
	BuildingType not in (select BuildingType from Buildings_XP2 where ResourceTypeConvertedToPower is not null);  

-- 辐射产出
insert or replace into HD_BuildingRegionalYields
	(BuildingType,	YieldType,	YieldChange)
select
	BuildingType,	YieldType,	YieldChange
from Building_YieldChanges where YieldChange > 0 and BuildingType in (select BuildingType from HD_BuildingRegionalRange);
delete from Building_YieldChanges where BuildingType in (select BuildingType from HD_BuildingRegionalRange);

-- 通电辐射产出
insert or replace into HD_BuildingRegionalYields
	(BuildingType,	YieldType,	YieldChange,	RequiresPower)
select
	BuildingType,	YieldType,	YieldChange,	1
from Building_YieldChangesBonusWithPower where YieldChange > 0 and BuildingType in (select BuildingType from HD_BuildingRegionalRange);
delete from Building_YieldChangesBonusWithPower where BuildingType in (select BuildingType from HD_BuildingRegionalRange);

-- 辐射宜居度
insert or replace into HD_BuildingRegionalYields
	(BuildingType,	YieldType,	YieldChange)
select
	BuildingType,	'AMENITY',	Entertainment
from Buildings where Entertainment > 0 and BuildingType in (select BuildingType from HD_BuildingRegionalRange);
update Buildings set Entertainment = 0 where BuildingType in (select BuildingType from HD_BuildingRegionalRange);

-- 通电辐射宜居度
insert or replace into HD_BuildingRegionalYields
	(BuildingType,	YieldType,	YieldChange,					RequiresPower)
select
	BuildingType,	'AMENITY',	EntertainmentBonusWithPower,	1
from Buildings_XP2 where EntertainmentBonusWithPower > 0 and BuildingType in (select BuildingType from HD_BuildingRegionalRange);
update Buildings_XP2 set EntertainmentBonusWithPower = 0 where BuildingType in (select BuildingType from HD_BuildingRegionalRange);

-- 科技/市政前置
update HD_BuildingRegionalYields set PrereqTech = 'TECH_PAPER_MAKING_HD'
  where (BuildingType = 'BUILDING_JNR_ACADEMY' or BuildingType = 'BUILDING_MER_LITERARY_SCHOOL_HD') and YieldType = 'YIELD_CULTURE';

-- 补充 YieldChange = 0 的部分建筑，用于适配伟人加产等
  -- 如桑弘羊给铸币厂+1辐射文化 需要文化的 YieldChange = 0
insert or ignore into HD_BuildingRegionalYields (BuildingType, YieldType, YieldChange) select
  'BUILDING_JNR_MINT', 'YIELD_CULTURE', 0
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_JNR_MINT');

  -- 爱达·勒芙蕾丝 工业区建筑+3辐射科技
insert or ignore into HD_BuildingRegionalYields (BuildingType, YieldType, YieldChange) select distinct
  BuildingType, 'YIELD_PRODUCTION', 0
from HD_BuildingRegionalRange where BuildingType in (select BuildingType from Buildings where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE');

insert or ignore into HD_BuildingRegionalYields (BuildingType, YieldType, YieldChange) select distinct
  BuildingType, 'YIELD_SCIENCE', 0
from HD_BuildingRegionalRange where BuildingType in (select BuildingType from Buildings where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE');

-- 二进制折叠 Modifiers
insert or replace into HD_Binary_Compress_Keys (Key, MaxExp) values
	('HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_YIELD_FOOD', 	    7),
	('HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_YIELD_PRODUCTION', 7),
	('HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_YIELD_SCIENCE',    7),
	('HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_YIELD_CULTURE',    7),
	('HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_YIELD_GOLD',       7),
	('HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_YIELD_FAITH',      7),
	('HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_AMENITY',          5);

  -- 产出
insert or ignore into TraitModifiers (TraitType, ModifierId)
	select 'TRAIT_LEADER_MAJOR_CIV', 'HD_CITY_RECEIVE_REGIONAL_' || YieldType || '_' || Exp
	from HD_Binary_Compress, Yields where Exp < 8;

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	select 'HD_CITY_RECEIVE_REGIONAL_' || YieldType || '_' || Exp, 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_' || YieldType || '_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress, Yields where Exp < 8;

insert or ignore into ModifierArguments (ModifierId, Name, Value)
	select 'HD_CITY_RECEIVE_REGIONAL_' || YieldType || '_' || Exp, 'Amount', Amount
	from HD_Binary_Compress, Yields where Exp < 8;

insert or ignore into ModifierArguments (ModifierId, Name, Value)
	select 'HD_CITY_RECEIVE_REGIONAL_' || YieldType || '_' || Exp, 'YieldType', YieldType
	from HD_Binary_Compress, Yields where Exp < 8;

  -- 宜居度
insert or ignore into TraitModifiers (TraitType, ModifierId)
	select 'TRAIT_LEADER_MAJOR_CIV', 'HD_CITY_RECEIVE_REGIONAL_AMENITY_' || Exp
	from HD_Binary_Compress, Yields where Exp < 6;

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	select 'HD_CITY_RECEIVE_REGIONAL_AMENITY_' || Exp, 'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY', 'HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_AMENITY_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress, Yields where Exp < 6;

insert or ignore into ModifierArguments (ModifierId, Name, Value)
	select 'HD_CITY_RECEIVE_REGIONAL_AMENITY_' || Exp, 'Amount', Amount
	from HD_Binary_Compress, Yields where Exp < 6;

-- 墨西哥城：所有辐射产出×1.5倍
delete from TraitModifiers where TraitType = 'MINOR_CIV_MEXICO_CITY_TRAIT' and ModifierId = 'MINOR_CIV_MEXICO_CITY_UNIQUE_INFLUENCE_BONUS';

insert or ignore into TraitModifiers (TraitType, ModifierId) select
  'MINOR_CIV_MEXICO_CITY_TRAIT', 'HD_MEXICO_CITY_REGIONAL_YIELDS_BONUS_ATTACH_' || YieldType
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
  'HD_MEXICO_CITY_REGIONAL_YIELDS_BONUS_ATTACH_' || YieldType, 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_IS_SUZERAIN'
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
  'HD_MEXICO_CITY_REGIONAL_YIELDS_BONUS_' || YieldType, 'MODIFIER_PLAYER_CITIES_ADJUST_PROPERTY', NULL
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_MEXICO_CITY_REGIONAL_YIELDS_BONUS_ATTACH_' || YieldType, 'ModifierId', 'HD_MEXICO_CITY_REGIONAL_YIELDS_BONUS_' || YieldType
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_MEXICO_CITY_REGIONAL_YIELDS_BONUS_' || YieldType, 'Key', 'HD_ALL_DISTRICTS_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_' || YieldType
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_MEXICO_CITY_REGIONAL_YIELDS_BONUS_' || YieldType, 'Amount', 50
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

-- 官邸
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
  'BUILDING_HD_MANSION', 'HD_MANSION_CITY_RECEIVE_REGIONAL_YIELDS_BONUS_' || YieldType
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
  'HD_MANSION_CITY_RECEIVE_REGIONAL_YIELDS_BONUS_' || YieldType, 'MODIFIER_PLAYER_CITIES_ADJUST_PROPERTY', 'HD_CITY_HAS_NEIGHBORHOOD_AND_GOVERNOR_IMPROVEMENT'
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_MANSION_CITY_RECEIVE_REGIONAL_YIELDS_BONUS_' || YieldType, 'Key', 'HD_ALL_DISTRICTS_RECEIVE_REGIONAL_YIELD_SCALING_FACTOR_' || YieldType
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_MANSION_CITY_RECEIVE_REGIONAL_YIELDS_BONUS_' || YieldType, 'Amount', 50
from HD_BuildingRegionalYieldTypes where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH');

-------------------------------------------------------------------
-- 着力点
-------------------------------------------------------------------
-- 灯火通明
insert or replace into CommemorationModifiers (CommemorationType, ModifierId) select
  'COMMEMORATION_HD_ILLUMINATED_CITY', 'COMMEMORATION_HD_ILLUMINATED_CITY_' || BuildingType || '_BASIC_' || YieldType
from Building_YieldChangesBonusWithPower where BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into CommemorationModifiers (CommemorationType, ModifierId) select
  'COMMEMORATION_HD_ILLUMINATED_CITY', 'COMMEMORATION_HD_ILLUMINATED_CITY_' || BuildingType || '_REGIONAL_' || YieldType
from HD_BuildingRegionalYields where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH')
  and RequiresPower = 1 and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) select
  'COMMEMORATION_HD_ILLUMINATED_CITY_' || BuildingType || '_BASIC_' || YieldType, 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE', 'PLAYER_HAS_GOLDEN_AGE', 'CITY_IS_POWERED'
from Building_YieldChangesBonusWithPower where BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) select
  'COMMEMORATION_HD_ILLUMINATED_CITY_' || BuildingType || '_REGIONAL_' || YieldType, 'MODIFIER_PLAYER_CITIES_ADJUST_PROPERTY', 'PLAYER_HAS_GOLDEN_AGE', 'CITY_IS_POWERED'
from HD_BuildingRegionalYields where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH')
  and RequiresPower = 1 and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'COMMEMORATION_HD_ILLUMINATED_CITY_' || BuildingType || '_BASIC_' || YieldType, 'BuildingType', BuildingType
from Building_YieldChangesBonusWithPower where BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'COMMEMORATION_HD_ILLUMINATED_CITY_' || BuildingType || '_BASIC_' || YieldType, 'YieldType', YieldType
from Building_YieldChangesBonusWithPower where BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'COMMEMORATION_HD_ILLUMINATED_CITY_' || BuildingType || '_BASIC_' || YieldType, 'Amount', 8
from Building_YieldChangesBonusWithPower where BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'COMMEMORATION_HD_ILLUMINATED_CITY_' || BuildingType || '_REGIONAL_' || YieldType, 'Key', 'HD_SINGLE_BUILDING_PROVIDE_REGIONAL_YIELD_BONUS_' || BuildingType || '_' || YieldType || '_POWERED'
from HD_BuildingRegionalYields where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH')
  and RequiresPower = 1 and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'COMMEMORATION_HD_ILLUMINATED_CITY_' || BuildingType || '_REGIONAL_' || YieldType, 'Amount', 8
from HD_BuildingRegionalYields where YieldType in ('YIELD_FOOD', 'YIELD_PRODUCTION', 'YIELD_SCIENCE', 'YIELD_CULTURE', 'YIELD_GOLD', 'YIELD_FAITH')
  and RequiresPower = 1 and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);