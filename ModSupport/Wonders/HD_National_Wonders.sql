-- National_Wonders
insert or ignore into HD_DUMMY_BUILDINGS (BuildingType) values
  ('NAT_WONDER_CL_COLLEGE_INTERNAL'),
  ('NAT_WONDER_CL_NATIONALEPIC_INTERNAL'),
  ('NAT_WONDER_CL_CITADEL_INTERNAL'),
  ('NAT_WONDER_CL_TEMPLE_INTERNAL'),
  ('NAT_WONDER_CL_THEMEPARK_INTERNAL');

-- 国立大学 ----------------------------------------------------------------------------------------------------------------------------------------------------
	-- 修改解锁条件和造价
update Buildings set PrereqTech = NULL, PrereqCivic = 'CIVIC_IMPERIAL_EXAMINATION_SYSTEM_HD', cost = 750 where BuildingType = 'NAT_WONDER_CL_COLLEGE';
update Buildings set PrereqTech = NULL, PrereqCivic = 'CIVIC_IMPERIAL_EXAMINATION_SYSTEM_HD', cost = 750 where BuildingType = 'NAT_WONDER_CL_COLLEGE_INTERNAL';
	-- 修改建造条件
update Modifiers set OwnerRequirementSetId = NULL where ModifierId = 'CL_NAT_WONDER_ALLOW_BUILDING_COLLEGE';
insert or replace into BuildingPrereqs
	(Building,								PrereqBuilding)
values
	('NAT_WONDER_CL_COLLEGE',				'BUILDING_LIBRARY'),
	('NAT_WONDER_CL_COLLEGE_INTERNAL',		'BUILDING_LIBRARY');
	-- 修改本体产出
update Building_YieldChanges set YieldChange = 4 where BuildingType = 'NAT_WONDER_CL_COLLEGE';
update Building_YieldChanges set YieldChange = 4 where BuildingType = 'NAT_WONDER_CL_COLLEGE_INTERNAL';
update Building_GreatPersonPoints set PointsPerTurn = 6 where BuildingType = 'NAT_WONDER_CL_COLLEGE';
update Building_GreatPersonPoints set PointsPerTurn = 6 where BuildingType = 'NAT_WONDER_CL_COLLEGE_INTERNAL';
	-- 修改特效
delete from BuildingModifiers where BuildingType = 'NAT_WONDER_CL_COLLEGE' and ModifierId = 'CL_NAT_WONDER_ATTACH_SCIENCE_YIELD_MODIFIER';
delete from BuildingModifiers where BuildingType = 'NAT_WONDER_CL_COLLEGE' and ModifierId = 'CL_NAT_WONDER_ADJUST_CITY_SCIENCE_YIELD';

insert or replace into Modifiers
	(ModifierId,							ModifierType,															RunOnce,	Permanent,		SubjectRequirementSetId)
values
	('HD_NAT_COLLEGE_CAMPUS_DOUBLE',		'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',						0,			0,				'DISTRICT_IS_CAMPUS'),
	('HD_NAT_COLLEGE_GOVERN_SCIENCE',		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER_PER_GOVERNOR_TITLE',	0,			0,				'CITY_HAS_NAT_COLLEGE'),
	('HD_NAT_COLLEGE_GOVERNOR_POINTS',		'MODIFIER_PLAYER_ADJUST_GOVERNOR_POINTS',								1,			1,				NULL),
	('HD_NAT_COLLEGE_SCIENTIST_POINTS',		'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',					0,			0,				NULL);

insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
values
	('NAT_WONDER_CL_COLLEGE',				'HD_NAT_COLLEGE_CAMPUS_DOUBLE'),
	('NAT_WONDER_CL_COLLEGE',				'HD_NAT_COLLEGE_GOVERN_SCIENCE'),
	('NAT_WONDER_CL_COLLEGE',				'HD_NAT_COLLEGE_GOVERNOR_POINTS'),
	('NAT_WONDER_CL_COLLEGE',				'HD_NAT_COLLEGE_SCIENTIST_POINTS');

insert or replace into ModifierArguments
	(ModifierId,							Name,				Value)
values
	('HD_NAT_COLLEGE_CAMPUS_DOUBLE',		'YieldType',		'YIELD_SCIENCE'),
	('HD_NAT_COLLEGE_CAMPUS_DOUBLE',		'Amount',			100),
	('HD_NAT_COLLEGE_GOVERN_SCIENCE',		'YieldType',		'YIELD_SCIENCE'),
	('HD_NAT_COLLEGE_GOVERN_SCIENCE',		'Amount',			5),
	('HD_NAT_COLLEGE_GOVERNOR_POINTS',		'Delta',			1),
	('HD_NAT_COLLEGE_SCIENTIST_POINTS',		'GreatPersonClassType',		'GREAT_PERSON_CLASS_SCIENTIST'),
	('HD_NAT_COLLEGE_SCIENTIST_POINTS',		'Amount',					20);

insert or ignore into RequirementSets
	(RequirementSetId,						RequirementSetType)
values
	('CITY_HAS_NAT_COLLEGE',				'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
values
	('CITY_HAS_NAT_COLLEGE',				'REQUIRES_CITY_HAS_NAT_WONDER_CL_COLLEGE');


-- 民族史诗 ----------------------------------------------------------------------------------------------------------------------------------------------------
	-- 修改解锁条件和造价
update Buildings set PrereqTech = NULL, PrereqCivic = 'CIVIC_HISTORICAL_PHILOSOPHY_HD', cost = 1000 where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC';
update Buildings set PrereqTech = NULL, PrereqCivic = 'CIVIC_HISTORICAL_PHILOSOPHY_HD', cost = 1000 where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC_INTERNAL';
	-- 修改建造条件
update Modifiers set OwnerRequirementSetId = NULL where ModifierId = 'CL_NAT_WONDER_ALLOW_BUILDING_NATIONALEPIC';

update Buildings set AdjacentDistrict = 'DISTRICT_THEATER' where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC';
update Buildings set AdjacentDistrict = 'DISTRICT_THEATER' where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC_INTERNAL';

insert or replace into BuildingPrereqs
	(Building,								PrereqBuilding)
values
	('NAT_WONDER_CL_NATIONALEPIC',			'BUILDING_MUSEUM_ART'),
	('NAT_WONDER_CL_NATIONALEPIC',			'BUILDING_MUSEUM_ARTIFACT'),
	('NAT_WONDER_CL_NATIONALEPIC_INTERNAL',	'BUILDING_MUSEUM_ART'),
	('NAT_WONDER_CL_NATIONALEPIC_INTERNAL',	'BUILDING_MUSEUM_ARTIFACT');
	-- 修改本体产出
delete from Building_YieldChanges where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC' and YieldType = 'YIELD_PRODUCTION';
delete from Building_YieldChanges where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC_INTERNAL' and YieldType = 'YIELD_PRODUCTION';
insert or replace into Building_YieldChanges
	(BuildingType,							YieldType,			YieldChange)
values
	('NAT_WONDER_CL_NATIONALEPIC',			'YIELD_CULTURE',	2),
	('NAT_WONDER_CL_NATIONALEPIC',			'YIELD_FAITH',		2),
	('NAT_WONDER_CL_NATIONALEPIC_INTERNAL',	'YIELD_CULTURE',	2),
	('NAT_WONDER_CL_NATIONALEPIC_INTERNAL',	'YIELD_FAITH',		2);
delete from Building_GreatWorks where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC';
delete from Building_GreatWorks where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC_INTERNAL';
	-- 修改特效
delete from BuildingModifiers where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC' and ModifierId = 'CL_NAT_WONDER_ADJUST_GREATWORK_YIELD';
delete from BuildingModifiers where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC' and ModifierId = 'CL_NAT_WONDER_ADJUST_GREAT_PERSON_POINT_BONUS_GOLDEN';
delete from BuildingModifiers where BuildingType = 'NAT_WONDER_CL_NATIONALEPIC' and ModifierId = 'CL_NAT_WONDER_ADJUST_GREATWORK_YIELD_GOLDEN';

update ModifierArguments set Value = 50 where ModifierId = 'CL_NAT_WONDER_ADJUST_GREAT_PERSON_POINT_BONUS';

insert or replace into Modifiers
	(ModifierId,																										ModifierType)
select
	'HD_NAT_NATIONALEPIC_' || GreatPersonClassType || '_ATTACH',		'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from GreatPersonCorrespondingYieldType_HD;

insert or replace into ModifierArguments
	(ModifierId,																										Name,							Value)
select
	'HD_NAT_NATIONALEPIC_' || GreatPersonClassType || '_ATTACH',		'BuildingType',		'NAT_WONDER_CL_NATIONALEPIC'
from GreatPersonCorrespondingYieldType_HD;

insert or replace into ModifierArguments
	(ModifierId,																										Name,							Value)
select
	'HD_NAT_NATIONALEPIC_' || GreatPersonClassType || '_ATTACH',		'YieldType',			YieldType
from GreatPersonCorrespondingYieldType_HD;

insert or replace into ModifierArguments
	(ModifierId,																										Name,							Value)
select
	'HD_NAT_NATIONALEPIC_' || GreatPersonClassType || '_ATTACH',		'Amount',					Amount * 3
from GreatPersonCorrespondingYieldType_HD where YieldType != 'YIELD_CULTURE';

insert or replace into ModifierArguments
	(ModifierId,																										Name,							Value)
select
	'HD_NAT_NATIONALEPIC_' || GreatPersonClassType || '_ATTACH',		'Amount',					Amount
from GreatPersonCorrespondingYieldType_HD where YieldType = 'YIELD_CULTURE';

-- 大本营 ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 修改解锁条件和造价
update Buildings set PrereqTech = 'TECH_MILITARY_ENGINEERING', PrereqCivic = NULL, cost = 750 where BuildingType = 'NAT_WONDER_CL_CITADEL';
update Buildings set PrereqTech = 'TECH_MILITARY_ENGINEERING', PrereqCivic = NULL, cost = 750 where BuildingType = 'NAT_WONDER_CL_CITADEL_INTERNAL';
update Modifiers set OwnerRequirementSetId = 'PLAYER_IS_AT_WAR_WITH_ANY_MAJOR' where ModifierId in ('CL_NAT_WONDER_ALLOW_BUILDING_CITADEL', 'CL_NAT_WONDER_ATTACH_FORT_YIELD_MODIFIER');
	-- 修改本体产出
delete from Building_YieldChanges where BuildingType = 'NAT_WONDER_CL_CITADEL' and YieldType = 'YIELD_SCIENCE';
delete from Building_YieldChanges where BuildingType = 'NAT_WONDER_CL_CITADEL_INTERNAL' and YieldType = 'YIELD_SCIENCE';
update Building_YieldChanges set YieldChange = 2 where BuildingType = 'NAT_WONDER_CL_CITADEL' and YieldType = 'YIELD_CULTURE';
update Building_YieldChanges set YieldChange = 2 where BuildingType = 'NAT_WONDER_CL_CITADEL_INTERNAL' and YieldType = 'YIELD_CULTURE';

update Building_GreatPersonPoints set PointsPerTurn = 6 where BuildingType = 'NAT_WONDER_CL_CITADEL';
update Building_GreatPersonPoints set PointsPerTurn = 6 where BuildingType = 'NAT_WONDER_CL_CITADEL_INTERNAL';
	-- 修改特效
		-- 移除堡垒产出
delete from BuildingModifiers where BuildingType = 'NAT_WONDER_CL_CITADEL' and ModifierId = 'CL_NAT_WONDER_ATTACH_FORT_YIELD_MODIFIER';
		-- 单位加力
update Modifiers set SubjectRequirementSetId = NULL where ModifierId = 'CL_NAT_WONDER_CITADEL_GRANT_ABILITY';
update Modifiers set SubjectRequirementSetId = 'HD_UNIT_IN_OWNER_TERRITORY_REQUIREMENTS' where ModifierId = 'CL_NAT_WONDER_ADJUST_UNIT_COMBAT_STRENGTH';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_NAT_WONDER_CL_CITADEL' and ModifierId = 'CL_NAT_WONDER_ADJUST_UNIT_MOVEMENT';
update UnitAbilities set Description = 'LOC_ABILITY_NAT_WONDER_CL_CITADEL_DESCRIPTION_HD' where UnitAbilityType = 'ABILITY_NAT_WONDER_CL_CITADEL';
insert or replace into ModifierStrings
	(ModifierId,									Context,				Text)
values
	('CL_NAT_WONDER_ADJUST_UNIT_COMBAT_STRENGTH',	'Preview',				'LOC_ABILITY_NAT_WONDER_CL_CITADEL_DESCRIPTION_HD');
delete from TypeTags where Type = 'ABILITY_NAT_WONDER_CL_CITADEL';
insert or replace into TypeTags
	(Type,									Tag)
values
	('ABILITY_NAT_WONDER_CL_CITADEL',		'CLASS_MILITARY');

		-- 单位晋升不消耗移动力
insert or replace into UnitAbilityModifiers
	(UnitAbilityType,						ModifierId)
values
	('ABILITY_NAT_WONDER_CL_CITADEL',		'TRAIT_PROMOTE_NO_FINISH_MOVES');
-- Gran Colombia pack
insert or ignore into Modifiers (ModifierId, ModifierType) values
('TRAIT_PROMOTE_NO_FINISH_MOVES',	'MODIFIER_PLAYER_UNITS_PROMOTE_NO_FINISH_MOVES');
insert or ignore into ModifierArguments (ModifierId, Name, Value) values
('TRAIT_PROMOTE_NO_FINISH_MOVES',	'NoFinishMoves',	1);

		-- 送城墙&军营产出&军工+1次+1速&军营相邻
insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
values
	('NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_GRANT_WALLS'),
	('NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_GRANT_CASTLE'),
	('NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_ENCAMPMENT_ADJACENCY'),
	('NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_ENCAMPMENT_ADJACENCY_CULTURE'),
	('NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_MILITARY_ENGINEER_CHARGE'),
	('NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_MILITARY_ENGINEER_MOVEMENT'),
	('NAT_WONDER_CL_CITADEL',				'ALHAMBRA_MILITARY_GOVERNMENT_SLOT');
	--('NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_PRODUCTION_ATTACH'),
	--('NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_CULTURE_ATTACH');

insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
select
	'NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_PRODUCTION'
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT' and TraitType is null and BuildingType in (select BuildingType from HD_BuildingTiers);

insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
select
	'NAT_WONDER_CL_CITADEL',				'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_CULTURE'
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT' and TraitType is null and BuildingType in (select BuildingType from HD_BuildingTiers);

insert or replace into Modifiers
	(ModifierId,														ModifierType,												RunOnce,	Permanent,	SubjectRequirementSetId)
values
	('HD_NAT_CITADEL_GRANT_WALLS',										'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',		1,			1,			NULL),
	('HD_NAT_CITADEL_GRANT_CASTLE',										'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',		1,			1,			NULL),
	('HD_NAT_CITADEL_ENCAMPMENT_ADJACENCY',								'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',			0,			0,			'DISTRICT_IS_DISTRICT_ENCAMPMENT_REQUIREMENTS'),
	('HD_NAT_CITADEL_ENCAMPMENT_ADJACENCY_CULTURE',						'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',			0,			0,			'DISTRICT_IS_DISTRICT_ENCAMPMENT_REQUIREMENTS'),
	('HD_NAT_CITADEL_MILITARY_ENGINEER_CHARGE',							'MODIFIER_PLAYER_UNITS_ADJUST_BUILDER_CHARGES',				0,			1,			'UNIT_IS_UNIT_MILITARY_ENGINEER_REQUIREMENTS'),
	('HD_NAT_CITADEL_MILITARY_ENGINEER_MOVEMENT',						'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT',					0,			1,			'UNIT_IS_UNIT_MILITARY_ENGINEER_REQUIREMENTS');
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_PRODUCTION_ATTACH',		'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',				0,			0,			NULL),
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_CULTURE_ATTACH',		'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',					0,			0,			NULL),
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_PRODUCTION',			'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',				0,			0,			'DISTRICT_IS_ENCAMPMENT'),
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_CULTURE',				'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',				0,			0,			'DISTRICT_IS_ENCAMPMENT');

insert or replace into Modifiers
	(ModifierId,														ModifierType)
select
	'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_PRODUCTION',			'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT'
	and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into Modifiers
	(ModifierId,														ModifierType)
select
	'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_CULTURE',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT'
	and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into ModifierArguments
	(ModifierId,														Name,					Value)
values
	('HD_NAT_CITADEL_GRANT_WALLS',										'BuildingType',			'BUILDING_WALLS'),
	('HD_NAT_CITADEL_GRANT_CASTLE',										'BuildingType',			'BUILDING_CASTLE'),
	('HD_NAT_CITADEL_ENCAMPMENT_ADJACENCY',								'YieldType',			'YIELD_PRODUCTION'),
	('HD_NAT_CITADEL_ENCAMPMENT_ADJACENCY',								'Amount',				100),
	('HD_NAT_CITADEL_ENCAMPMENT_ADJACENCY_CULTURE',						'YieldType',			'YIELD_CULTURE'),
	('HD_NAT_CITADEL_ENCAMPMENT_ADJACENCY_CULTURE',						'Amount',				100),
	('HD_NAT_CITADEL_MILITARY_ENGINEER_CHARGE',							'Amount',				1),
	('HD_NAT_CITADEL_MILITARY_ENGINEER_MOVEMENT',						'Amount',				1);
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_PRODUCTION_ATTACH',		'ModifierId',			'HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_PRODUCTION'),
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_CULTURE_ATTACH',		'ModifierId',			'HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_CULTURE'),
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_PRODUCTION',			'YieldType',			'YIELD_PRODUCTION'),
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_PRODUCTION',			'Amount',				2),
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_CULTURE',				'YieldType',			'YIELD_CULTURE'),
	--('HD_NAT_CITADEL_ADJUST_ENCAMPMENT_DISTRICT_CULTURE',				'Amount',				2);

insert or replace into ModifierArguments
	(ModifierId,														Name,					Value)
select
	'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_PRODUCTION',			'BuildingType',			BuildingType
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT' and TraitType is null and BuildingType in (select BuildingType from HD_BuildingTiers);

insert or replace into ModifierArguments
	(ModifierId,														Name,					Value)
select
	'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_PRODUCTION',			'YieldType',			'YIELD_PRODUCTION'
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT' and TraitType is null and BuildingType in (select BuildingType from HD_BuildingTiers);

insert or replace into ModifierArguments
	(ModifierId,														Name,					Value)
select
	'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_PRODUCTION',			'Amount',				2
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT' and TraitType is null and BuildingType in (select BuildingType from HD_BuildingTiers);

insert or replace into ModifierArguments
	(ModifierId,														Name,					Value)
select
	'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_CULTURE',				'BuildingType',			BuildingType
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT' and TraitType is null and BuildingType in (select BuildingType from HD_BuildingTiers);

insert or replace into ModifierArguments
	(ModifierId,														Name,					Value)
select
	'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_CULTURE',				'YieldType',			'YIELD_CULTURE'
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT' and TraitType is null and BuildingType in (select BuildingType from HD_BuildingTiers);

insert or replace into ModifierArguments
	(ModifierId,														Name,					Value)
select
	'HD_NAT_CITADEL_ADJUST_' || BuildingType || '_CULTURE',				'Amount',				2
from Buildings where PrereqDistrict = 'DISTRICT_ENCAMPMENT' and TraitType is null and BuildingType in (select BuildingType from HD_BuildingTiers);

-- 圣殿 --------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 修改解锁条件和造价
update Buildings set PrereqTech = NULL, PrereqCivic = 'CIVIC_THEOLOGY', cost = 420 where BuildingType = 'NAT_WONDER_CL_TEMPLE';
update Buildings set PrereqTech = NULL, PrereqCivic = 'CIVIC_THEOLOGY', cost = 420 where BuildingType = 'NAT_WONDER_CL_TEMPLE_INTERNAL';
	-- 修改建造条件
update RequirementArguments set Value = 3 where RequirementId = 'REQ_CL_PLAYER_HAS_X_CITIES_WITH_RELIGION' and Name = 'Count';
	-- 修改特效
-- update ModifierArguments set Value = 20 where ModifierId = 'CL_NAT_WONDER_ADJUST_RELIGION_PRESSURE' and Name = 'Amount';
-- update Modifiers set SubjectStackLimit = 5 where ModifierId = 'CL_NAT_WONDER_ADJUST_RELIGION_PRESSURE';
-- update Modifiers set SubjectStackLimit = 5 where ModifierId = 'CL_NAT_WONDER_ADJUST_RELIGION_DISTANCE';

delete from BuildingModifiers where BuildingType = 'NAT_WONDER_CL_TEMPLE';

insert or replace into Building_GreatWorks (BuildingType, GreatWorkSlotType, NumSlots)
values ('NAT_WONDER_CL_TEMPLE', 'GREATWORKSLOT_RELIC', 2),('NAT_WONDER_CL_TEMPLE_INTERNAL', 'GREATWORKSLOT_RELIC', 2);

insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
values
	('NAT_WONDER_CL_TEMPLE',		'HD_NAT_TEMPLE_RELIC_SCIENCE'),
	('NAT_WONDER_CL_TEMPLE',		'HD_NAT_TEMPLE_RELIC_CULTURE'),
	('NAT_WONDER_CL_TEMPLE',		'HD_NAT_TEMPLE_RELIC_TOURISM_ATTACH'),
	('NAT_WONDER_CL_TEMPLE',		'HD_NAT_TEMPLE_RELIC_TOURISM_ATTACH_CAPITAL');

insert or replace into Modifiers
	(ModifierId,																		ModifierType,																		SubjectRequirementSetId)
values
	('HD_NAT_TEMPLE_RELIC_SCIENCE',									'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD',	NULL),
	('HD_NAT_TEMPLE_RELIC_CULTURE',									'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD',	NULL),
	('HD_NAT_TEMPLE_RELIC_TOURISM_ATTACH',					'MODIFIER_ALL_CITIES_ATTACH_MODIFIER',					'HD_AI_CITY_FOLLOWS_RELIGION_REQUIREMENTS'),
	('HD_NAT_TEMPLE_RELIC_TOURISM_ATTACH_CAPITAL',	'MODIFIER_ALL_CITIES_ATTACH_MODIFIER',					'HD_AI_CAPITAL_FOLLOWS_RELIGION_REQUIREMENTS'),
	('HD_NAT_TEMPLE_RELIC_TOURISM_MODIFIER',				'MODIFIER_ALL_CITIES_ADJUST_TOURISM',						'CITY_HAS_NAT_WONDER_CL_TEMPLE_REQUIREMENTS');
update Modifiers set OwnerRequirementSetId = 'PLAYER_IS_HUMAN' where ModifierId in ('HD_NAT_TEMPLE_RELIC_TOURISM_ATTACH', 'HD_NAT_TEMPLE_RELIC_TOURISM_ATTACH_CAPITAL');

insert or replace into ModifierArguments
	(ModifierId,																		Name,									Value)
values
	('HD_NAT_TEMPLE_RELIC_SCIENCE',									'GreatWorkObjectType','GREATWORKOBJECT_RELIC'),
	('HD_NAT_TEMPLE_RELIC_SCIENCE',									'YieldChange',				2),
	('HD_NAT_TEMPLE_RELIC_SCIENCE',									'YieldType',					'YIELD_SCIENCE'),
	('HD_NAT_TEMPLE_RELIC_CULTURE',									'GreatWorkObjectType','GREATWORKOBJECT_RELIC'),
	('HD_NAT_TEMPLE_RELIC_CULTURE',									'YieldChange',				2),
	('HD_NAT_TEMPLE_RELIC_CULTURE',									'YieldType',					'YIELD_CULTURE'),
	('HD_NAT_TEMPLE_RELIC_TOURISM_ATTACH',					'ModifierId',					'HD_NAT_TEMPLE_RELIC_TOURISM_MODIFIER'),
	('HD_NAT_TEMPLE_RELIC_TOURISM_ATTACH_CAPITAL',	'ModifierId',					'HD_NAT_TEMPLE_RELIC_TOURISM_MODIFIER'),
	('HD_NAT_TEMPLE_RELIC_TOURISM_MODIFIER',				'ScalingFactor',			130),
	('HD_NAT_TEMPLE_RELIC_TOURISM_MODIFIER',				'GreatWorkObjectType','GREATWORKOBJECT_RELIC');

-- 国家主题公园 ------------------------------------------------------------------------------------------------------------------------------------------------
	-- 修改解锁条件和造价
update Buildings set PrereqTech = NULL, PrereqCivic = 'CIVIC_MASS_MEDIA', cost = 1800, RegionalRange = 9 where BuildingType = 'NAT_WONDER_CL_THEMEPARK';
update Buildings set PrereqTech = NULL, PrereqCivic = 'CIVIC_MASS_MEDIA', cost = 1800, RegionalRange = 9 where BuildingType = 'NAT_WONDER_CL_THEMEPARK_INTERNAL';
	-- 修改本体产出
insert or replace into Building_YieldChanges
	(BuildingType,							YieldType,			YieldChange)
values
	('NAT_WONDER_CL_THEMEPARK',				'YIELD_CULTURE',	3),
	('NAT_WONDER_CL_THEMEPARK',				'YIELD_GOLD',		9),
	('NAT_WONDER_CL_THEMEPARK_INTERNAL',	'YIELD_CULTURE',	3),
	('NAT_WONDER_CL_THEMEPARK_INTERNAL',	'YIELD_GOLD',		9);
update Building_YieldChangesBonusWithPower set YieldType = 'YIELD_CULTURE', YieldChange = 2 where BuildingType = 'NAT_WONDER_CL_THEMEPARK';
update Building_YieldChangesBonusWithPower set YieldType = 'YIELD_CULTURE', YieldChange = 2 where BuildingType = 'NAT_WONDER_CL_THEMEPARK_INTERNAL';

	-- 修改特效
delete from BuildingModifiers where BuildingType = 'NAT_WONDER_CL_THEMEPARK'
	and (ModifierId = 'CL_NAT_WONDER_ADJUST_TOURISM_ENTERTAINMENT' or ModifierId = 'CL_NAT_WONDER_ADJUST_TOURISM_ENTERTAINMENT_ADJACENT');

insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_CAMP_TOURISM'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_PASTURE_TOURISM'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_PLANTATION_TOURISM'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_LUMBER_MILL_TOURISM'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_FISHBOAT_TOURISM'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM1'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM2'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM3'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM1'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM2'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM3'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_ENTERTAINMENT_GOLD'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_ENTERTAINMENT_CULTURE'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_WATER_PARK_GOLD'),
	('NAT_WONDER_CL_THEMEPARK',		'HD_NAT_THEMEPARK_WATER_PARK_CULTURE');

insert or replace into Modifiers
	(ModifierId,																				ModifierType,																						SubjectRequirementSetId)
values
	('HD_NAT_THEMEPARK_CAMP_TOURISM',										'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'HD_CITY_HAS_ZOO_OR_BOTANICAL_GARDEN'),
	('HD_NAT_THEMEPARK_PASTURE_TOURISM',									'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'HD_CITY_HAS_ZOO_OR_BOTANICAL_GARDEN'),
	('HD_NAT_THEMEPARK_PLANTATION_TOURISM',									'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'HD_CITY_HAS_ZOO_OR_BOTANICAL_GARDEN'),
	('HD_NAT_THEMEPARK_LUMBER_MILL_TOURISM',								'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'HD_CITY_HAS_ZOO_OR_BOTANICAL_GARDEN'),
	('HD_NAT_THEMEPARK_FISHBOAT_TOURISM',								'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'CITY_HAS_BUILDING_AQUARIUM_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM',		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'CITY_HAS_DISTRICT_ENTERTAINMENT_COMPLEX_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM1',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'CITY_HAS_DISTRICT_ENTERTAINMENT_COMPLEX_TIER_1_BUILDING_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM2',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'CITY_HAS_DISTRICT_ENTERTAINMENT_COMPLEX_TIER_2_BUILDING_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM3',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'CITY_HAS_DISTRICT_ENTERTAINMENT_COMPLEX_TIER_3_BUILDING_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM',			'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'CITY_HAS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM1',			'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'CITY_HAS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_TIER_1_BUILDING_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM2',			'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'CITY_HAS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_TIER_2_BUILDING_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM3',			'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',								'CITY_HAS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_TIER_3_BUILDING_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_GOLD',							'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',						'REQUIRES_DISTRICT_IS_DISTRICT_ENTERTAINMENT_COMPLEX_UDMET'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_CULTURE',					'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',						'REQUIRES_DISTRICT_IS_DISTRICT_ENTERTAINMENT_COMPLEX_UDMET'),
	('HD_NAT_THEMEPARK_WATER_PARK_GOLD',								'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',						'REQUIRES_DISTRICT_IS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_UDMET'),
	('HD_NAT_THEMEPARK_WATER_PARK_CULTURE',							'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',						'REQUIRES_DISTRICT_IS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_UDMET');

insert or replace into Modifiers
	(ModifierId,																				ModifierType,																						OwnerRequirementSetId)
values
	('HD_NAT_THEMEPARK_ENTERTAINMENT_GOLD_MODIFIER',		'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',			'PLOT_ADJACENT_TO_WONDER_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_CULTURE_MODIFIER',	'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',			'PLOT_ADJACENT_TO_WONDER_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_WATER_PARK_GOLD_MODIFIER',				'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',			'PLOT_ADJACENT_TO_WONDER_REQUIREMENTS'),
	('HD_NAT_THEMEPARK_WATER_PARK_CULTURE_MODIFIER',		'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',			'PLOT_ADJACENT_TO_WONDER_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,											Name,					Value)
values
	('HD_NAT_THEMEPARK_CAMP_TOURISM',						'ImprovementType',		'IMPROVEMENT_CAMP'),
	('HD_NAT_THEMEPARK_CAMP_TOURISM',						'ScalingFactor',		150),
	('HD_NAT_THEMEPARK_PASTURE_TOURISM',					'ImprovementType',		'IMPROVEMENT_PASTURE'),
	('HD_NAT_THEMEPARK_PASTURE_TOURISM',					'ScalingFactor',		150),
	('HD_NAT_THEMEPARK_PLANTATION_TOURISM',						'ImprovementType',		'IMPROVEMENT_PLANTATION'),
	('HD_NAT_THEMEPARK_PLANTATION_TOURISM',						'ScalingFactor',		150),
	('HD_NAT_THEMEPARK_LUMBER_MILL_TOURISM',					'ImprovementType',		'IMPROVEMENT_LUMBER_MILL'),
	('HD_NAT_THEMEPARK_LUMBER_MILL_TOURISM',					'ScalingFactor',		150),
	('HD_NAT_THEMEPARK_FISHBOAT_TOURISM',					'ImprovementType',		'IMPROVEMENT_FISHING_BOATS'),
	('HD_NAT_THEMEPARK_FISHBOAT_TOURISM',					'ScalingFactor',		150),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM',							'BoostsWonders',		1),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM',							'ScalingFactor',		200),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM1',						'BoostsWonders',		1),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM1',						'ScalingFactor',		200),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM2',						'BoostsWonders',		1),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM2',						'ScalingFactor',		200),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM3',						'BoostsWonders',		1),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_WONDER_TOURISM3',						'ScalingFactor',		200),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM',								'BoostsWonders',		1),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM',								'ScalingFactor',		200),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM1',								'BoostsWonders',		1),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM1',								'ScalingFactor',		200),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM2',								'BoostsWonders',		1),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM2',								'ScalingFactor',		200),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM3',								'BoostsWonders',		1),
	('HD_NAT_THEMEPARK_WATER_PARK_WONDER_TOURISM3',								'ScalingFactor',		200),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_GOLD',										'ModifierId',		'HD_NAT_THEMEPARK_ENTERTAINMENT_GOLD_MODIFIER'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_CULTURE',								'ModifierId',		'HD_NAT_THEMEPARK_ENTERTAINMENT_CULTURE_MODIFIER'),
	('HD_NAT_THEMEPARK_WATER_PARK_GOLD',											'ModifierId',		'HD_NAT_THEMEPARK_WATER_PARK_GOLD_MODIFIER'),
	('HD_NAT_THEMEPARK_WATER_PARK_CULTURE',										'ModifierId',		'HD_NAT_THEMEPARK_WATER_PARK_CULTURE_MODIFIER'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_GOLD_MODIFIER',											'YieldType',	'YIELD_GOLD'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_GOLD_MODIFIER',											'Amount',			10),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_CULTURE_MODIFIER',										'YieldType',	'YIELD_CULTURE'),
	('HD_NAT_THEMEPARK_ENTERTAINMENT_CULTURE_MODIFIER',										'Amount',			10),
	('HD_NAT_THEMEPARK_WATER_PARK_GOLD_MODIFIER',													'YieldType',	'YIELD_GOLD'),
	('HD_NAT_THEMEPARK_WATER_PARK_GOLD_MODIFIER',													'Amount',			10),
	('HD_NAT_THEMEPARK_WATER_PARK_CULTURE_MODIFIER',											'YieldType',	'YIELD_CULTURE'),
	('HD_NAT_THEMEPARK_WATER_PARK_CULTURE_MODIFIER',											'Amount',			10);

-- insert or ignore into RequirementSets
-- 	(RequirementSetId,						RequirementSetType)
-- values
-- 	-- ('HD_CITY_HAS_ZOO',						'REQUIREMENTSET_TEST_ALL'),
-- 	('HD_CITY_HAS_ZOO_OR_BOTANICAL_GARDEN',	'REQUIREMENTSET_TEST_ANY'),
-- 	('HD_CITY_HAS_AQUARIUM', 				'REQUIREMENTSET_TEST_ALL');

-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,						RequirementId)
-- values
-- 	-- ('HD_CITY_HAS_ZOO',						'REQUIRES_CITY_HAS_BUILDING_ZOO'),
-- 	('HD_CITY_HAS_ZOO_OR_BOTANICAL_GARDEN',	'REQUIRES_CITY_HAS_BUILDING_ZOO'),
-- 	-- ('HD_CITY_HAS_ZOO_OR_BOTANICAL_GARDEN',	'REQUIRES_CITY_HAS_BUILDING_JNR_BOTANICAL_GARDEN'),
-- 	('HD_CITY_HAS_AQUARIUM',				'REQUIRES_CITY_HAS_BUILDING_AQUARIUM');