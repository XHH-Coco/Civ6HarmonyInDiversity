-------------------------------------
--			Nubia DLC			--
-------------------------------------	
update Improvements set PrereqTech = NULL, PrereqCivic = 'CIVIC_FUNERAL_HD' where ImprovementType = 'IMPROVEMENT_PYRAMID';
insert or replace into Improvement_ValidTerrains 
	(ImprovementType,			TerrainType)
values
	('IMPROVEMENT_PYRAMID',		'TERRAIN_PLAINS'),
	('IMPROVEMENT_PYRAMID',		'TERRAIN_GRASS_HILLS'),
	('IMPROVEMENT_PYRAMID',		'TERRAIN_GRASS'),
	('IMPROVEMENT_PYRAMID',		'TERRAIN_PLAINS_HILLS');
insert or replace into Improvement_ValidFeatures
	(ImprovementType,			FeatureType)
values
	('IMPROVEMENT_PYRAMID',		'FEATURE_FLOODPLAINS_GRASSLAND'),
	('IMPROVEMENT_PYRAMID',		'FEATURE_FLOODPLAINS_PLAINS');
update Improvement_YieldChanges set YieldChange = 1 where ImprovementType = 'IMPROVEMENT_PYRAMID' and YieldType = 'YIELD_FOOD';
insert or replace into ImprovementModifiers
	(ImprovementType,			ModifierId)
values
	('IMPROVEMENT_PYRAMID', 	'PYRAMID_DESERT_FOOD'),
	('IMPROVEMENT_PYRAMID', 	'PYRAMID_DESERT_FAITH');
insert or replace into Modifiers
	(ModifierId,					ModifierType,								SubjectRequirementSetId)
values
	('PYRAMID_DESERT_FOOD',			'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PETRA_YIELD_MODIFIER_REQUIREMENTS'),
	('PYRAMID_DESERT_FAITH',		'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PETRA_YIELD_MODIFIER_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,					Name,			Value)
values
	('PYRAMID_DESERT_FAITH',		'YieldType',	'YIELD_FAITH'),
	('PYRAMID_DESERT_FAITH',		'Amount',		2),
	('PYRAMID_DESERT_FOOD',			'YieldType',	'YIELD_FOOD'),
	('PYRAMID_DESERT_FOOD',			'Amount',		2);

-- 相邻加成
delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_PYRAMID';

insert or replace into Improvement_Adjacencies
	(ImprovementType,				YieldChangeId)
select
	'IMPROVEMENT_PYRAMID',	'IMPROVEMENT_PYRAMID_' || DistrictType || '_' || YieldType || '_ADJACENCY'
from DistrictCorrespondingYieldType_HD;

insert or replace into Adjacency_YieldChanges
	(ID,																																				Description,		YieldType,	YieldChange,	AdjacentDistrict,		PrereqCivic)
select
	'IMPROVEMENT_PYRAMID_' || DistrictType || '_' || YieldType || '_ADJACENCY',	'Placeholder',	YieldType,	Amount,				DistrictType,				null
from DistrictCorrespondingYieldType_HD;

insert or replace into Improvement_Adjacencies
	(ImprovementType,				YieldChangeId)
select
	'IMPROVEMENT_PYRAMID',	'IMPROVEMENT_PYRAMID_' || DistrictType || '_' || YieldType || '_ADJACENCY2'
from DistrictCorrespondingYieldType_HD;

insert or replace into Adjacency_YieldChanges
	(ID,																																					Description,		YieldType,	YieldChange,	AdjacentDistrict,		PrereqCivic)
select
	'IMPROVEMENT_PYRAMID_' || DistrictType || '_' || YieldType || '_ADJACENCY2',	'Placeholder',	YieldType,	Amount,				DistrictType,				'CIVIC_FEUDALISM'
from DistrictCorrespondingYieldType_HD;

-- LA
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_TA_SETI' and ModifierId in ('TRAIT_LUXURY_MINE_GOLD', 'TRAIT_BONUS_MINE_GOLD', 'TRAIT_STRATEGIC_MINE_PRODUCTION');
insert or replace into TraitModifiers
	(TraitType,					ModifierId)
values
	('TRAIT_CIVILIZATION_TA_SETI',  'HD_TA_SETI_MINE_PRODUCTION_GOLD');

insert or replace into Modifiers
	(ModifierId,														ModifierType,														SubjectRequirementSetId)
values
	('HD_TA_SETI_MINE_PRODUCTION_GOLD',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'HD_PLOT_HAS_RESOURCE_MINE_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,														Name,		Value)
values  
	('HD_TA_SETI_MINE_PRODUCTION_GOLD',			'YieldType',	'YIELD_PRODUCTION, YIELD_GOLD'),
	('HD_TA_SETI_MINE_PRODUCTION_GOLD',			'Amount',			'1,2');

-- 百分比锤
insert or replace into TraitModifiers
	(TraitType,					ModifierId)
select
	'TRAIT_CIVILIZATION_TA_SETI',  'HD_TA_SETI_' || i.ResourceType || '_PRODUCTION'
from Resources i inner join Improvement_ValidResources j on i.ResourceType = j.ResourceType where j.ImprovementType = 'IMPROVEMENT_MINE';

insert or replace into Modifiers
	(ModifierId,																				ModifierType,																					SubjectRequirementSetId)
select
	'HD_TA_SETI_' || i.ResourceType || '_PRODUCTION',		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'HD_CITY_HAS_IMPROVED_' || i.ResourceType || '_REQUIRMENTS'
from Resources i inner join Improvement_ValidResources j on i.ResourceType = j.ResourceType where j.ImprovementType = 'IMPROVEMENT_MINE';

insert or replace into ModifierArguments
	(ModifierId,																				Name,					Value)
select
	'HD_TA_SETI_' || i.ResourceType || '_PRODUCTION',		'YieldType',	'YIELD_PRODUCTION'
from Resources i inner join Improvement_ValidResources j on i.ResourceType = j.ResourceType where j.ImprovementType = 'IMPROVEMENT_MINE';

insert or replace into ModifierArguments
	(ModifierId,																				Name,					Value)
select
	'HD_TA_SETI_' || i.ResourceType || '_PRODUCTION',		'Amount',			5
from Resources i inner join Improvement_ValidResources j on i.ResourceType = j.ResourceType where j.ImprovementType = 'IMPROVEMENT_MINE';

-- 百分比金
insert or replace into TraitModifiers
	(TraitType,					ModifierId)
select
	'TRAIT_CIVILIZATION_TA_SETI',  'HD_TA_SETI_' || i.ResourceType || '_GOLD'
from Resources i inner join Improvement_ValidResources j on i.ResourceType = j.ResourceType where j.ImprovementType = 'IMPROVEMENT_MINE';

insert or replace into Modifiers
	(ModifierId,																				ModifierType,																					SubjectRequirementSetId)
select
	'HD_TA_SETI_' || i.ResourceType || '_GOLD',					'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'HD_CITY_HAS_IMPROVED_' || i.ResourceType || '_REQUIRMENTS'
from Resources i inner join Improvement_ValidResources j on i.ResourceType = j.ResourceType where j.ImprovementType = 'IMPROVEMENT_MINE';

insert or replace into ModifierArguments
	(ModifierId,																				Name,					Value)
select
	'HD_TA_SETI_' || i.ResourceType || '_GOLD',					'YieldType',	'YIELD_GOLD'
from Resources i inner join Improvement_ValidResources j on i.ResourceType = j.ResourceType where j.ImprovementType = 'IMPROVEMENT_MINE';

insert or replace into ModifierArguments
	(ModifierId,																				Name,					Value)
select
	'HD_TA_SETI_' || i.ResourceType || '_GOLD',					'Amount',			10
from Resources i inner join Improvement_ValidResources j on i.ResourceType = j.ResourceType where j.ImprovementType = 'IMPROVEMENT_MINE';

-- create TEMPORARY table 'Nubia_Resource'(
-- 	'ResourceType' Text NOT NULL
-- );

-- create TEMPORARY table 'Nubia_Resource1'(
-- 	'ResourceType' Text NOT NULL
-- );

-- insert or replace into Nubia_Resource
-- 	(ResourceType)
-- select
-- 	i.ResourceType
-- from Resources i, Improvement_ValidResources j
-- where i.ResourceType = j.ResourceType and (i.ResourceClassType = 'RESOURCECLASS_BONUS' or i.ResourceClassType = 'RESOURCECLASS_LUXURY') and j.ImprovementType = 'IMPROVEMENT_MINE';

-- insert or replace into Nubia_Resource1
-- 	(ResourceType)
-- select
-- 	i.ResourceType
-- from Resources i, Improvement_ValidResources j
-- where i.ResourceType = j.ResourceType and i.ResourceClassType = 'RESOURCECLASS_STRATEGIC' and j.ImprovementType = 'IMPROVEMENT_MINE';

-- insert or replace into TraitModifiers
-- 	(TraitType,					ModifierId)
-- select
-- 	'TRAIT_CIVILIZATION_TA_SETI',  'TRAIT_' || ResourceType || '_MINE_GOLD_PERCENTAGE'
-- from Nubia_Resource;

-- insert or replace into Modifiers
-- 	(ModifierId,													ModifierType,										SubjectRequirementSetId)
-- select
-- 	'TRAIT_' || ResourceType || '_MINE_GOLD_PERCENTAGE',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS'
-- from Nubia_Resource;

-- insert or replace into ModifierArguments
-- 	(ModifierId,													Name,		Value)
-- select
-- 	'TRAIT_' || ResourceType || '_MINE_GOLD_PERCENTAGE',	'YieldType',	'YIELD_GOLD'
-- from Nubia_Resource;

-- insert or replace into ModifierArguments
-- 	(ModifierId,													Name,		Value)
-- select
-- 	'TRAIT_' || ResourceType || '_MINE_GOLD_PERCENTAGE',	'Amount',	10
-- from Nubia_Resource;

-- insert or replace into TraitModifiers (TraitType, ModifierId) select
-- 	'TRAIT_CIVILIZATION_TA_SETI',	'TRAIT_'||ResourceType||'_MINE_PRODUCTION_RATIO'
-- from Nubia_Resource1;

-- insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
-- 	'TRAIT_'||ResourceType||'_MINE_PRODUCTION_RATIO', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',  'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS'
-- from Nubia_Resource1;

-- insert or replace into ModifierArguments (ModifierId, Name, Value) select
-- 	'TRAIT_'||ResourceType||'_MINE_PRODUCTION_RATIO', 'YieldType',  'YIELD_PRODUCTION'
-- from Nubia_Resource1;

-- insert or replace into ModifierArguments (ModifierId, Name, Value) select
-- 	'TRAIT_'||ResourceType||'_MINE_PRODUCTION_RATIO', 'Amount',  10
-- from Nubia_Resource1;

-- Jebel Barkal
update Buildings set RegionalRange = 0 where BuildingType = 'BUILDING_JEBEL_BARKAL';

insert or replace into Building_ValidTerrains
	(BuildingType,		TerrainType)
values
	('BUILDING_JEBEL_BARKAL',	'TERRAIN_DESERT_MOUNTAIN');

insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	-- ('BUILDING_JEBEL_BARKAL',		'JEBEL_BARKAL_MINE_PRODUCTION'),
	-- ('BUILDING_JEBEL_BARKAL',		'JEBEL_BARKAL_MINE_FAITH'),
	-- ('BUILDING_JEBEL_BARKAL',		'JEBEL_BARKAL_QUARRY_PRODUCTION'),
	-- ('BUILDING_JEBEL_BARKAL',		'JEBEL_BARKAL_QUARRY_FAITH');
	('BUILDING_JEBEL_BARKAL',		'JEBEL_BARKAL_DISTRICT_CULTURE'),
	('BUILDING_JEBEL_BARKAL',		'JEBEL_BARKAL_DISTRICT_FAITH');
insert or replace into Modifiers
	(ModifierId,					ModifierType,								SubjectRequirementSetId)
values
	-- ('JEBEL_BARKAL_MINE_PRODUCTION',		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'PLOT_HAS_MINE_WITH_6_TILES'),
	-- ('JEBEL_BARKAL_MINE_FAITH',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'PLOT_HAS_MINE_WITH_6_TILES'),
	-- ('JEBEL_BARKAL_QUARRY_PRODUCTION',	'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'PLOT_HAS_QUARRY_WITH_6_TILES'),
	-- ('JEBEL_BARKAL_QUARRY_FAITH',		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'PLOT_HAS_QUARRY_WITH_6_TILES'),
	('JEBEL_BARKAL_DISTRICT_CULTURE',		'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',		'HD_NOT_WONDER_WITHIN_6_TILES_REQUIREMENTS'),
	('JEBEL_BARKAL_DISTRICT_FAITH',		'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',		'HD_NOT_WONDER_WITHIN_6_TILES_REQUIREMENTS'),
	('JEBEL_BARKAL_DISTRICT_CULTURE_MODIFIER',		'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_CHANGE',		'HD_IS_ON_DESERT_OR_DESERT_HILL_REQUIREMENTS'),
	('JEBEL_BARKAL_DISTRICT_FAITH_MODIFIER',		'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_CHANGE',		'HD_IS_ON_DESERT_OR_DESERT_HILL_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,					Name,			Value)
values
	-- ('JEBEL_BARKAL_MINE_PRODUCTION',		'YieldType',	'YIELD_PRODUCTION'),
	-- ('JEBEL_BARKAL_MINE_PRODUCTION',		'Amount',		1),
	-- ('JEBEL_BARKAL_MINE_FAITH',			'YieldType',	'YIELD_FAITH'),
	-- ('JEBEL_BARKAL_MINE_FAITH',			'Amount',		1),
	-- ('JEBEL_BARKAL_QUARRY_PRODUCTION',	'YieldType',	'YIELD_PRODUCTION'),
	-- ('JEBEL_BARKAL_QUARRY_PRODUCTION',	'Amount',		1),
	-- ('JEBEL_BARKAL_QUARRY_FAITH',		'YieldType',	'YIELD_FAITH'),
	-- ('JEBEL_BARKAL_QUARRY_FAITH',		'Amount',		1),
	('JEBEL_BARKAL_DISTRICT_CULTURE',	'ModifierId',	'JEBEL_BARKAL_DISTRICT_CULTURE_MODIFIER'),
	('JEBEL_BARKAL_DISTRICT_FAITH',	'ModifierId',		'JEBEL_BARKAL_DISTRICT_FAITH_MODIFIER'),
	('JEBEL_BARKAL_DISTRICT_CULTURE_MODIFIER',	'YieldType',	'YIELD_CULTURE'),
	('JEBEL_BARKAL_DISTRICT_CULTURE_MODIFIER',	'Amount',		1),
	('JEBEL_BARKAL_DISTRICT_FAITH_MODIFIER',		'YieldType',	'YIELD_FAITH'),
	('JEBEL_BARKAL_DISTRICT_FAITH_MODIFIER',		'Amount',		1);


--努比亚
update ModifierArguments set Value = 100 where Name = 'Amount' and ModifierId in (
	'TRAIT_ANCIENT_RANGED_UNIT_PRODUCTION',
	'TRAIT_ATOMIC_RANGED_UNIT_PRODUCTION',
	'TRAIT_CLASSICAL_RANGED_UNIT_PRODUCTION',
	'TRAIT_INDUSTRIAL_RANGED_UNIT_PRODUCTION',
	'TRAIT_INFORMATION_RANGED_UNIT_PRODUCTION',
	'TRAIT_MEDIEVAL_RANGED_UNIT_PRODUCTION',
	'TRAIT_MODERN_RANGED_UNIT_PRODUCTION'
);
update ModifierArguments set Value = 25 where ModifierId = 'TRAIT_BASE_DISTRICT_PRODUCTION_MODIFIER' or ModifierId = 'TRAIT_PYRAMID_DISTRICT_PRODUCTION_MODIFIER';
insert or replace into TraitModifiers
	(TraitType,								ModifierId)
values
	('TRAIT_CIVILIZATION_TA_SETI',			'TRAIT_TECH_ARCHERY');
insert or replace into Modifiers
	(ModifierId,							ModifierType,										SubjectRequirementSetId)
values
	('TRAIT_TECH_ARCHERY',					'MODIFIER_PLAYER_GRANT_SPECIFIC_TECHNOLOGY',		NULL);
insert or replace into ModifierArguments
	(ModifierId,							Name,						Value)
values
	('TRAIT_TECH_ARCHERY',					'TechType',					'TECH_ARCHERY');