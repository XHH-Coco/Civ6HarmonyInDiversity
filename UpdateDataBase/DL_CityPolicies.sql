-- grant basic building to enable city policies
insert or replace into TraitModifiers
	(TraitType,					ModifierId)
values
	('TRAIT_LEADER_MAJOR_CIV',	'TRAIT_GRANT_EMPTY_CITY_POLICY_MODIFIER'),
	('MINOR_CIV_DEFAULT_TRAIT',	'TRAIT_GRANT_EMPTY_CITY_POLICY_MODIFIER');

insert or replace into Modifiers
	(ModifierId,									ModifierType)
values
	('TRAIT_GRANT_EMPTY_CITY_POLICY_MODIFIER',		'GRANT_BUILDING_TO_ALL_CITIES_IGNORE');

insert or replace into ModifierArguments
	(ModifierId,									Name,			Value)
values
	('TRAIT_GRANT_EMPTY_CITY_POLICY_MODIFIER',		'BuildingType', 'BUILDING_CITY_POLICY_EMPTY');

-- Main table
create table 'CityPolicyMaster'(
	'CityPolicy' TEXT NOT null,
	'BuildingType' TEXT,
	'EnableProjectType' TEXT,
	'DisableProjectType' TEXT,
	'EnableCivicType' TEXT,
	'EnableTechType' TEXT,
	'EnableCost' INT NOT null,
	'DisableCost' INT NOT null,
	PRIMARY KEY('CityPolicy')
);

------【此处需要手动修改】------
insert or replace into CityPolicyMaster
	(CityPolicy,			EnableCost,	DisableCost)
values
	('EMPTY',				0,			0),
	('LABOR',				0,			0);

update CityPolicyMaster set EnableCivicType = 'CIVIC_CODE_OF_LAWS' where CityPolicy = 'LABOR';
------【结束】------

update CityPolicyMaster set
	BuildingType 			= 'BUILDING_CITY_POLICY_' || CityPolicy,
	EnableProjectType 		= 'PROJECT_CITY_POLICY_ENABLE_' || CityPolicy,
	DisableProjectType 		= 'PROJECT_CITY_POLICY_DISABLE_' || CityPolicy;

insert or replace into Types (Type, Kind) select BuildingType, 'KIND_BUILDING' from CityPolicyMaster;
insert or replace into Types (Type, Kind) select EnableProjectType, 'KIND_PROJECT' from CityPolicyMaster where CityPolicy != 'EMPTY';
insert or replace into Types (Type, Kind) select DisableProjectType, 'KIND_PROJECT' from CityPolicyMaster where CityPolicy != 'EMPTY';

-- Use buildings as city policies, use projects to turn on and turn off the city policies.
insert or replace into Buildings
	(BuildingType,	Name,								Cost,	Description)
select
	BuildingType,	'LOC_' || BuildingType || '_NAME',	1,		'LOC_' || BuildingType || '_DESCRIPTION'
from CityPolicyMaster;

insert or replace into Buildings_XP2 (BuildingType, Pillage)
select BuildingType, 0 from CityPolicyMaster;

insert or replace into BuildingModifiers 
	(BuildingType,									ModifierId)
values
	('BUILDING_CITY_POLICY_LABOR',					'CITY_POLICY_LABOR_POP_FOOD_MODIFIER'),
	('BUILDING_CITY_POLICY_LABOR',					'CITY_POLICY_LABOR_POP_PROD_MODIFIER'),
	('BUILDING_CITY_POLICY_LABOR',					'CITY_POLICY_LABOR_CITY_GROWTH_MODIFIER'),
	('BUILDING_CITY_POLICY_LABOR',					'CITY_POLICY_LABOR_CITY_AMENITIES');

insert or replace into Modifiers
	(ModifierId,								ModifierType)
values
	('CITY_POLICY_LABOR_POP_FOOD_MODIFIER',		'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION'),
	('CITY_POLICY_LABOR_POP_PROD_MODIFIER',		'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION'),
	('CITY_POLICY_LABOR_CITY_GROWTH_MODIFIER',	'MODIFIER_SINGLE_CITY_ADJUST_CITY_GROWTH'),
	('CITY_POLICY_LABOR_CITY_AMENITIES',		'MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT');

insert or replace into ModifierArguments
	(ModifierId,															Name,			Value)
values
	('CITY_POLICY_LABOR_POP_FOOD_MODIFIER',									'YieldType',	'YIELD_FOOD'),
	('CITY_POLICY_LABOR_POP_FOOD_MODIFIER',									'Amount',		-1),
	('CITY_POLICY_LABOR_POP_PROD_MODIFIER',									'YieldType',	'YIELD_PRODUCTION'),
	('CITY_POLICY_LABOR_POP_PROD_MODIFIER',									'Amount',		1.5),
	('CITY_POLICY_LABOR_CITY_GROWTH_MODIFIER',								'Amount',		-75),
	('CITY_POLICY_LABOR_CITY_AMENITIES',									'Amount',		-1);

-- Enable Projects
insert or replace into Projects
	(ProjectType, Name, ShortName, Description, Cost, PrereqCivic, PrereqTech, AdvisorType)
select
	EnableProjectType,
	'LOC_'||EnableProjectType||'_NAME',
	'LOC_'||EnableProjectType||'_SHORT_NAME',
	'LOC_'||EnableProjectType||'_DESCRIPTION',
	EnableCost,
	EnableCivicType,
	EnableTechType,
	'ADVISOR_GENERIC'
from CityPolicyMaster where CityPolicy != 'EMPTY';
-- Disable Projects
insert or replace into Projects
	(ProjectType, Name, ShortName, Description, Cost, PrereqCivic, PrereqTech, AdvisorType)
select
	DisableProjectType,
	'LOC_'||DisableProjectType||'_NAME',
	'LOC_'||DisableProjectType||'_SHORT_NAME',
	'LOC_'||DisableProjectType||'_DESCRIPTION',
	DisableCost,
	null,
	null,
	'ADVISOR_GENERIC'
from CityPolicyMaster where CityPolicy != 'EMPTY';
-- Enable
insert or replace into Project_BuildingCosts
	(ProjectType,			ConsumedBuildingType)
select
	EnableProjectType,		'BUILDING_CITY_POLICY_EMPTY'
from CityPolicyMaster where CityPolicy != 'EMPTY';
insert or replace into Projects_XP2
	(ProjectType,			RequiredBuilding,				CreateBuilding)
select
	EnableProjectType,		'BUILDING_CITY_POLICY_EMPTY',	BuildingType
from CityPolicyMaster where CityPolicy != 'EMPTY';
-- Disable
insert or replace into Projects_XP2
	(ProjectType,			RequiredBuilding,				CreateBuilding)
select
	DisableProjectType,		BuildingType,					'BUILDING_CITY_POLICY_EMPTY'
from CityPolicyMaster where CityPolicy != 'EMPTY';
insert or replace into Project_BuildingCosts
	(ProjectType,			ConsumedBuildingType)
select
	DisableProjectType,		BuildingType
from CityPolicyMaster where CityPolicy != 'EMPTY';

insert or replace into MutuallyExclusiveBuildings (Building, MutuallyExclusiveBuilding)
select a.BuildingType, b.BuildingType from CityPolicyMaster a, CityPolicyMaster b where a.BuildingType != b.BuildingType;