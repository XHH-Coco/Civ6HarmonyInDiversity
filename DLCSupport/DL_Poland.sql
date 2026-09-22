-------------------------------------
--            Poland DLC           --
-------------------------------------

-- 波兰
-------------------------------------------------------------------------
insert or replace into GlobalParameters (Name, Value) values
  ('HD_GOLDEN_LIBERTY_ALL_GOV_BUILDING', 									1),
  ('HD_LITHUANIAN_UNION_COPY_ALLY_GPP', 									100),
  ('HD_SUKIENNICE_TRADE_ROUTE_NUM', 											8),
  ('HD_SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_PERCENTAGE', 	25),
  ('HD_SUKIENNICE_INTERNATIONAL_TRADE_GOLD_PERCENTAGE', 	75);

delete from ExcludedAdjacencies where TraitType = 'TRAIT_LEADER_LITHUANIAN_UNION' and YieldChangeId = 'District_Faith';
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_GOLDEN_LIBERTY' and ModifierId != 'TRAIT_REPLACE_MILITARY_SLOT_WITH_WILDCARD';
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_LITHUANIAN_UNION' and ModifierId != 'TRAIT_CULTURE_BOMB_CONVERTS_CITY';

insert or replace into Modifiers
	(ModifierId,                                        ModifierType,                                                           SubjectRequirementSetId)
values
	('POLAND_CAVALRY_HALF_REDUCTION_DAMAGE',            'MODIFIER_PLAYER_UNIT_ADJUST_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER',  NULL);

insert or replace into ModifierArguments
	(ModifierId,                                        Name,               Value)
values
	('TRAIT_REPLACE_MILITARY_SLOT_WITH_WILDCARD',       'ReplacesAll',      1),
	('POLAND_CAVALRY_HALF_REDUCTION_DAMAGE',            'Amount',           50);

-- 圣城商路鸽
	-- To Ally
insert or replace into TraitModifiers (TraitType, ModifierId) select distinct
	'TRAIT_LEADER_LITHUANIAN_UNION', 'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_TO_ALLY'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)  select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_TO_ALLY', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'HD_IS_HOLY_CITY_HAS_HOLYSITE_TIER_' || Tier || '_BUILDING_REQUIREMENTS'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into ModifierArguments (ModifierId, Name, Value) select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_TO_ALLY', 'ModifierId', 'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_TO_ALLY_MODIFIER'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into Modifiers (ModifierId, ModifierType)  select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_TO_ALLY_MODIFIER', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_DESTINATION_YIELD_FOR_ALLY_ROUTE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into ModifierArguments (ModifierId, Name, Value) select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_TO_ALLY', 'YieldType', 'YIELD_FAITH'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into ModifierArguments (ModifierId, Name, Value) select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_TO_ALLY', 'Amount', 1
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

	-- From Ally
insert or replace into TraitModifiers (TraitType, ModifierId) select distinct
	'TRAIT_LEADER_LITHUANIAN_UNION', 'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_FROM_ALLY'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)  select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_FROM_ALLY', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'HD_IS_HOLY_CITY_HAS_HOLYSITE_TIER_' || Tier || '_BUILDING_REQUIREMENTS'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into ModifierArguments (ModifierId, Name, Value) select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_FROM_ALLY', 'ModifierId', 'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_FROM_ALLY_MODIFIER'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into Modifiers (ModifierId, ModifierType)  select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_FROM_ALLY_MODIFIER', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_ORIGIN_YIELD_FOR_ALLY_ROUTE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into ModifierArguments (ModifierId, Name, Value) select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_FROM_ALLY_MODIFIER', 'YieldType', 'YIELD_FAITH'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into ModifierArguments (ModifierId, Name, Value) select distinct
	'HD_HOLY_CITY_TIER_' || Tier || '_FAITH_FROM_ALLY_MODIFIER', 'Amount', 1
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

-- 翼骑兵忽略50%受伤减益
insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId) values
	('ABILITY_PUSHBACK', 'POLAND_CAVALRY_HALF_REDUCTION_DAMAGE');

-- 纺织会馆
update Buildings set PrereqTech = 'TECH_TEXTILE_HD', Maintenance = 0,	Cost = 420, CitizenSlots = 4, MaxPlayerInstances = 1 where BuildingType = 'BUILDING_SUKIENNICE';

insert or replace into Building_CitizenYieldChanges
	(BuildingType,         	YieldType,          YieldChange)
values
	('BUILDING_SUKIENNICE',	'YIELD_CULTURE',    1),
	('BUILDING_SUKIENNICE',	'YIELD_GOLD',       2);

insert or replace into Building_YieldChanges
	(BuildingType,         	YieldType,          YieldChange)
values
	('BUILDING_SUKIENNICE',	'YIELD_CULTURE',    1),
	('BUILDING_SUKIENNICE',	'YIELD_GOLD',       3);

delete from BuildingModifiers where BuildingType = 'BUILDING_SUKIENNICE';
insert or replace into BuildingModifiers (BuildingType, ModifierId) values
	('BUILDING_SUKIENNICE',	'HD_SUKIENNICE_COMMERCIAL_HUB_CULTURE_BOMB'),
	('BUILDING_SUKIENNICE',	'HD_SUKIENNICE_SET_PLAYER_PROPERTY'),
	('BUILDING_SUKIENNICE',	'HD_SUKIENNICE_SET_CITY_PROPERTY');

insert or replace into Modifiers (ModifierId, ModifierType) values
	('HD_SUKIENNICE_COMMERCIAL_HUB_CULTURE_BOMB',   'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER'),
	('HD_SUKIENNICE_SET_PLAYER_PROPERTY',   				'MODIFIER_PLAYER_ADJUST_PROPERTY'),
	('HD_SUKIENNICE_SET_CITY_PROPERTY',   					'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY');

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('HD_SUKIENNICE_COMMERCIAL_HUB_CULTURE_BOMB',   'DistrictType',    	'DISTRICT_COMMERCIAL_HUB'),
	('HD_SUKIENNICE_SET_PLAYER_PROPERTY',   				'Key',    					'HD_PLAYER_HAS_SUKIENNICE'),
	('HD_SUKIENNICE_SET_PLAYER_PROPERTY',   				'Amount',    				1),
	('HD_SUKIENNICE_SET_CITY_PROPERTY',   					'Key',    					'HD_CITY_HAS_SUKIENNICE'),
	('HD_SUKIENNICE_SET_CITY_PROPERTY',   					'Amount',    				1);

insert or replace into HD_Binary_Compress_Keys (Key) values
	('HD_PLOT_BINARY_COMPRESS_SUKIENNICE_1'),
	('HD_PLOT_BINARY_COMPRESS_SUKIENNICE_2'),
	('HD_PLOT_BINARY_COMPRESS_SUKIENNICE_3');

-- 商路
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
	'BUILDING_SUKIENNICE',	'HD_SUKIENNICE_TRADE_ROUTE_' || Exp
	from HD_Binary_Compress where Exp < 10;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
	'HD_SUKIENNICE_TRADE_ROUTE_' || Exp, 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 'HD_PLOT_BINARY_COMPRESS_SUKIENNICE_1_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_SUKIENNICE_TRADE_ROUTE_' || Exp, 'Amount', Amount
	from HD_Binary_Compress where Exp < 10;

-- 内商
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
	'BUILDING_SUKIENNICE',	'HD_SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_' || Exp
	from HD_Binary_Compress where Exp < 10;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
	'HD_SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_' || Exp, 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS', 'HD_PLOT_BINARY_COMPRESS_SUKIENNICE_2_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_' || Exp, 'YieldType', 'YIELD_PRODUCTION'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_' || Exp, 'Amount', Amount
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_' || Exp, 'Domestic', 1
	from HD_Binary_Compress where Exp < 10;

-- 外商
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
	'BUILDING_SUKIENNICE',	'HD_SUKIENNICE_INTERNATIONAL_TRADE_GOLD_' || Exp
	from HD_Binary_Compress where Exp < 10;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
	'HD_SUKIENNICE_INTERNATIONAL_TRADE_GOLD_' || Exp, 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL', 'HD_PLOT_BINARY_COMPRESS_SUKIENNICE_3_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_SUKIENNICE_INTERNATIONAL_TRADE_GOLD_' || Exp, 'YieldType', 'YIELD_GOLD'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_SUKIENNICE_INTERNATIONAL_TRADE_GOLD_' || Exp, 'Amount', Amount
	from HD_Binary_Compress where Exp < 10;

-- 资源产出
insert or replace into Modifiers (ModifierId, ModifierType) select
	'HD_SUKIENNICE_' || YieldType, 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE' from Yields;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_SUKIENNICE_' || YieldType, 'YieldType', YieldType from Yields;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_SUKIENNICE_' || YieldType, 'Amount', 1 from Yields;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_SUKIENNICE_' || YieldType, 'BuildingType', 'BUILDING_SUKIENNICE' from Yields;