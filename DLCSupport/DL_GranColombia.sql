-------------------------------------
--		GranColombia DLC		 --
-------------------------------------

-- Resource
-- remove some maize. 
update Resources set Frequency = 4 where ResourceType = 'RESOURCE_MAIZE';
insert or replace into Resource_YieldChanges  
	(ResourceType,		  YieldType,		  YieldChange)
values
	('RESOURCE_HONEY',	  'YIELD_GOLD',	   1);
delete from Resource_ValidTerrains where ResourceType = 'RESOURCE_MAIZE';
delete from Resource_ValidFeatures where ResourceType = 'RESOURCE_MAIZE';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_MAIZE' and YieldType = 'YIELD_GOLD';
insert or replace into Resource_ValidTerrains
	(ResourceType,			  TerrainType)
values
	('RESOURCE_MAIZE',		  'TERRAIN_GRASS_HILLS'),
	('RESOURCE_MAIZE',		  'TERRAIN_PLAINS_HILLS'),
	('RESOURCE_MAIZE',		  'TERRAIN_TUNDRA_HILLS');

insert or replace into Resource_YieldChanges (ResourceType, YieldType, YieldChange) select
	ResourceType,	'YIELD_FOOD',   2
from Resources where ResourceType = 'RESOURCE_MAIZE';
insert or replace into Resource_YieldChanges (ResourceType, YieldType, YieldChange) select
	ResourceType,	'YIELD_PRODUCTION',   -1
from Resources where ResourceType = 'RESOURCE_MAIZE';

-- insert or replace into RequirementSetRequirements 
--	 (RequirementSetId,					  RequirementId) 
-- values
--	 ('PLOT_HAS_FARM_RESOURCE_REQUIREMENTS', 'REQUIRES_MAIZE_IN_PLOT');

insert or replace into Resource_ValidFeatures
	(ResourceType,			  FeatureType)
values
	('RESOURCE_HONEY',		  'FEATURE_FOREST');

---------------------------------------------------------------------------------------------------------------
-- Maya
update Modifiers set SubjectRequirementSetId = 'OBJECT_IS_6_TILES_FROM_CAPITAL_REQUIREMENTS'
	where ModifierId = 'TRAIT_LEADER_NEARBY_CITIES_GAIN_YIELDS';
update Modifiers set SubjectRequirementSetId = 'OBJECT_IS_10_OR_MORE_TILES_FROM_CAPITAL_REQUIREMENTS'
	where ModifierId = 'TRAIT_LEADER_NEARBY_CITIES_LOSE_YIELDS';
update Modifiers set SubjectRequirementSetId = 'OBJECT_IS_6_TILES_FROM_CAPITAL_REQUIREMENTS' where
	ModifierId = 'TRAIT_LEADER_NEARBY_CITIES_GAIN_BUILDER';

-- 修改农场+1住房的写法
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_FARM' and ModifierId = 'FARM_HOUSING_WITH_MAYAB_TRAIT';

insert or replace into TraitModifiers 
	(TraitType,								 		ModifierId)
values
	('TRAIT_CIVILIZATION_MAYAB',	'HD_MAYAB_FARM_HOUSING');

insert or replace into Modifiers 
	(ModifierId,									ModifierType,							   											SubjectRequirementSetId)
values
	('HD_MAYAB_FARM_HOUSING',			'MODIFIER_PLAYER_IMPROVEMENTS_ATTACH_MODIFIER',		'PLOT_HAS_IMPROVEMENT_FARM_REQUIREMENTS');

update Modifiers set SubjectRequirementSetId = null where ModifierId = 'FARM_HOUSING_WITH_MAYAB_TRAIT';

insert or ignore into ModifierArguments
	(ModifierId,								Name,					  Value)
values
	('HD_MAYAB_FARM_HOUSING',		'ModifierId',		'FARM_HOUSING_WITH_MAYAB_TRAIT');

-- insert or replace into TraitModifiers (TraitType, ModifierId) values
--	 ('TRAIT_CIVILIZATION_MAYAB', 'MAYAB_EXTRA_HOUSING');
-- insert or replace into Modifiers (ModifierId, ModifierType) values
--	 ('MAYAB_EXTRA_HOUSING', 'MODIFIER_PLAYER_CITIES_ADJUST_POLICY_HOUSING');
-- insert or replace into ModifierArguments (ModifierId, Name, Value) values
--	 ('MAYAB_EXTRA_HOUSING', 'Amount', 1);

-- Gran Colombia
insert or replace into TraitModifiers 
	(TraitType,								 ModifierId)
values
	('TRAIT_CIVILIZATION_EJERCITO_PATRIOTA',	'TRAIT_PLANTATION_CULTURE_HD'),
	('TRAIT_CIVILIZATION_EJERCITO_PATRIOTA',	'TRAIT_PLANTATION_CULTURE_BOMB_HD');

insert or replace into Modifiers 
	(ModifierId,								ModifierType,							   SubjectRequirementSetId)
values
	('TRAIT_PLANTATION_CULTURE_HD',			 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'PLOT_HAS_PLANTATION_REQUIREMENTS'),
	('TRAIT_PLANTATION_CULTURE_BOMB_HD',		'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER', null);

insert or ignore into ModifierArguments
	(ModifierId,								Name,					   Value)
values
	('TRAIT_PLANTATION_CULTURE_HD',			 'YieldType',				'YIELD_CULTURE'),
	('TRAIT_PLANTATION_CULTURE_HD',			 'Amount',				   1),
	('TRAIT_PLANTATION_CULTURE_BOMB_HD',		'ImprovementType',		  'IMPROVEMENT_PLANTATION'),
	('TRAIT_PLANTATION_CULTURE_BOMB_HD',		'CaptureOwnedTerritory',	0);

-- Hacienda (Gran Colombia)
update Improvements set PrereqCivic = null, PrereqTech = 'TECH_CALENDAR_HD' where ImprovementType = 'IMPROVEMENT_HACIENDA';
delete from Improvement_YieldChanges where ImprovementType = 'IMPROVEMENT_HACIENDA' and YieldType = 'YIELD_GOLD';
delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_HACIENDA' and YieldChangeId = 'Hacienda_HaciendaAdjacency';
update Adjacency_YieldChanges set ObsoleteCivic = null where ID = 'Plantation_HaciendaAdjacency';
update Adjacency_YieldChanges set TilesRequired = 2, PrereqCivic = null, PrereqTech = 'TECH_BANKING', YieldType = 'YIELD_GOLD', YieldChange = 3 where ID = 'Plantation_AdvancedHaciendaAdjacency';   
update Adjacency_YieldChanges set TilesRequired = 1, YieldType = 'YIELD_PRODUCTION', ObsoleteTech = null, ObsoleteCivic = 'CIVIC_MERCANTILISM' where ID = 'Hacienda_PlantationAdjacency';
update Adjacency_YieldChanges set YieldChange = 2, YieldType = 'YIELD_PRODUCTION', PrereqTech = null, PrereqCivic = 'CIVIC_MERCANTILISM' where ID = 'Hacienda_MechanizedPlantationAdjacency';
update Adjacency_YieldChanges set PrereqCivic = 'CIVIC_GUILDS' where ID = 'Hacienda_AdvancedHaciendaAdjacency';
insert or replace into Improvement_Adjacencies
	(ImprovementType,			YieldChangeId)
values
	('IMPROVEMENT_HACIENDA',	'Hacienda_Plantation_Food'),
	('IMPROVEMENT_HACIENDA',	'Hacienda_Hacienda_Food'),
	('IMPROVEMENT_HACIENDA',	'Hacienda_Hacienda_Food_Late'),
	('IMPROVEMENT_HACIENDA',	'Hacienda_Hacienda_Food_Final');
insert or replace into Adjacency_YieldChanges
	(ID,								Description,	YieldType,			YieldChange,	TilesRequired,	AdjacentImprovement,		PrereqCivic,				ObsoleteCivic)
values
	('Hacienda_Plantation_Food',		'Placeholder',	'YIELD_FOOD',		1,				1,				'IMPROVEMENT_PLANTATION',	'CIVIC_FEUDALISM',			null),
	('Hacienda_Hacienda_Food',			'Placeholder',	'YIELD_FOOD',		1,				2,				'IMPROVEMENT_HACIENDA',		null,						'CIVIC_MEDIEVAL_FAIRES'),
	('Hacienda_Hacienda_Food_Late',		'Placeholder',	'YIELD_FOOD',		1,				1,				'IMPROVEMENT_HACIENDA',		'CIVIC_MEDIEVAL_FAIRES',	null),
	('Hacienda_Hacienda_Food_Final',	'Placeholder',	'YIELD_FOOD',		1,				1,				'IMPROVEMENT_HACIENDA',		'CIVIC_COLONIALISM',		null);
insert or replace into Improvement_ValidFeatures 
	(ImprovementType,			FeatureType)
values
	('IMPROVEMENT_HACIENDA',	'FEATURE_JUNGLE');

insert or replace into Improvement_ValidFeatures
    (ImprovementType,                   FeatureType)
select
    'IMPROVEMENT_HACIENDA',             'FEATURE_HD_SWAMP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');
---------------------------------------------------------------------------------------------------------------
-- CityStates

-- Batey
update Adjacency_YieldChanges set ObsoleteCivic = 'CIVIC_HUMANISM' where ID = 'Batey_EntertainmentComplexAdjacency' or ID = 'Batey_BonusResourceAdjacency';
update Adjacency_YieldChanges set PrereqCivic = 'CIVIC_HUMANISM' where ID = 'Batey_LateEntertainmentComplexAdjacency' or ID = 'Batey_LateBonusResourceAdjacency';
insert or replace into Improvement_Adjacencies
	(ImprovementType,		YieldChangeId)
values
	('IMPROVEMENT_BATEY',	'BATEY_Street_Carnival_Culture'),
	('IMPROVEMENT_BATEY',	'BATEY_Late_Street_Carnival_Culture'),
	('IMPROVEMENT_BATEY',	'Batey_LuxuryResourceAdjacency'),
	('IMPROVEMENT_BATEY',	'Batey_LateLuxuryResourceAdjacency'),
	('IMPROVEMENT_BATEY',	'Batey_NeighborhoodAdjacency'),
	('IMPROVEMENT_BATEY',	'Batey_LateNeighborhoodAdjacency'),
	('IMPROVEMENT_BATEY',	'Batey_MbanzaAdjacency'),
	('IMPROVEMENT_BATEY',	'Batey_LateMbanzaAdjacency');
insert or replace into Adjacency_YieldChanges
	(ID,									Description,	YieldType,			YieldChange,	PrereqCivic,		ObsoleteCivic,		AdjacentResourceClass,	AdjacentDistrict)
values
	('BATEY_Street_Carnival_Culture',		'Placeholder',	'YIELD_CULTURE',	1,				null,				'CIVIC_HUMANISM',	null,					'DISTRICT_STREET_CARNIVAL'),
	('BATEY_Late_Street_Carnival_Culture',	'Placeholder',	'YIELD_CULTURE',	2,				'CIVIC_HUMANISM',	null,				null,					'DISTRICT_STREET_CARNIVAL'),
	('Batey_LuxuryResourceAdjacency',		'Placeholder',	'YIELD_CULTURE',	1,				null,				'CIVIC_HUMANISM',	'RESOURCECLASS_LUXURY',	null),
	('Batey_LateLuxuryResourceAdjacency',	'Placeholder',	'YIELD_CULTURE',	2,				'CIVIC_HUMANISM',	null,				'RESOURCECLASS_LUXURY',	null),
	('Batey_NeighborhoodAdjacency',			'Placeholder',	'YIELD_CULTURE',	1,				null,				'CIVIC_HUMANISM',	null,					'DISTRICT_NEIGHBORHOOD'),
	('Batey_LateNeighborhoodAdjacency',		'Placeholder',	'YIELD_CULTURE',	2,				'CIVIC_HUMANISM',	null,				null,					'DISTRICT_NEIGHBORHOOD'),
	('Batey_MbanzaAdjacency',				'Placeholder',	'YIELD_CULTURE',	1,				null,				'CIVIC_HUMANISM',	null,					'DISTRICT_MBANZA'),
	('Batey_LateMbanzaAdjacency',			'Placeholder',	'YIELD_CULTURE',	2,				'CIVIC_HUMANISM',	null,				null,					'DISTRICT_MBANZA');

-- Singapore
-- MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL
delete from TraitModifiers where TraitType = 'MINOR_CIV_SINGAPORE_TRAIT' and ModifierId = 'MINOR_CIV_SINGAPORE_UNIQUE_INFLUENCE_BONUS';
insert or replace into TraitModifiers 
	(TraitType,							 ModifierId)
values
	('MINOR_CIV_SINGAPORE_TRAIT',		   'SINGAPORE_INTERNATIONAL_TRADE_ROUTE_PRODUCTION'),
	('MINOR_CIV_SINGAPORE_TRAIT',		   'SINGAPORE_TRADE_ROUTE_GOLD_FROM_ALLY'),
	('MINOR_CIV_SINGAPORE_TRAIT',		   'SINGAPORE_TRADE_ROUTE_GOLD_FROM_SUZERAIN');

insert or replace into Modifiers 
	(ModifierId,												ModifierType,														   SubjectRequirementSetId)
values
	('SINGAPORE_INTERNATIONAL_TRADE_ROUTE_PRODUCTION',		  'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',								 'PLAYER_IS_SUZERAIN'),
	('SINGAPORE_INTERNATIONAL_TRADE_ROUTE_PRODUCTION_MODIFIER', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',		   null),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_ALLY',					'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',								 'PLAYER_IS_SUZERAIN'),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_ALLY_MODIFIER',		   'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_ORIGIN_YIELD_FOR_ALLY_ROUTE',	   null),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_SUZERAIN',				'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',								 'PLAYER_IS_SUZERAIN'),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_SUZERAIN_MODIFIER',	   'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_ORIGIN_YIELD_FOR_SUZERAIN_ROUTE',   null);

insert or ignore into ModifierArguments
	(ModifierId,												Name,		   Value)
values
	('SINGAPORE_INTERNATIONAL_TRADE_ROUTE_PRODUCTION',		  'ModifierId',   'SINGAPORE_INTERNATIONAL_TRADE_ROUTE_PRODUCTION_MODIFIER'),
	('SINGAPORE_INTERNATIONAL_TRADE_ROUTE_PRODUCTION_MODIFIER', 'YieldType',	'YIELD_PRODUCTION'),
	('SINGAPORE_INTERNATIONAL_TRADE_ROUTE_PRODUCTION_MODIFIER', 'Amount',	   2),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_ALLY',					'ModifierId',   'SINGAPORE_TRADE_ROUTE_GOLD_FROM_ALLY_MODIFIER'),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_ALLY_MODIFIER',		   'YieldType',	'YIELD_GOLD'),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_ALLY_MODIFIER',		   'Amount',	   2),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_SUZERAIN',				'ModifierId',   'SINGAPORE_TRADE_ROUTE_GOLD_FROM_SUZERAIN_MODIFIER'),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_SUZERAIN_MODIFIER',	   'YieldType',	'YIELD_GOLD'),
	('SINGAPORE_TRADE_ROUTE_GOLD_FROM_SUZERAIN_MODIFIER',	   'Amount',	   2);

-- Vatican City
delete from TraitModifiers where TraitType = 'MINOR_CIV_VATICAN_CITY_TRAIT' and ModifierId = 'MINOR_CIV_VATICAN_CITY_UNIQUE_INFLUENCE_BONUS';
insert or ignore into TraitModifiers (TraitType, ModifierId) values
	('MINOR_CIV_VATICAN_CITY_TRAIT', 'MINOR_CIV_VATICAN_CITY_HOLYSITE_ADJACENCY_ATTACH');

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
	('MINOR_CIV_VATICAN_CITY_HOLYSITE_ADJACENCY_ATTACH',		'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',				'PLAYER_IS_SUZERAIN'),
	('MINOR_CIV_VATICAN_CITY_HOLYSITE_ADJACENCY_MODIFIER',	'MODIFIER_PLAYER_CITIES_DISTRICT_ADJACENCY',	'DL_CITY_HAS_WONDER_REQUIREMENTS');

insert or ignore into ModifierArguments (ModifierId, Name, Value) values
	('MINOR_CIV_VATICAN_CITY_HOLYSITE_ADJACENCY_ATTACH',	 	'ModifierId', 			'MINOR_CIV_VATICAN_CITY_HOLYSITE_ADJACENCY_MODIFIER'),
	('MINOR_CIV_VATICAN_CITY_HOLYSITE_ADJACENCY_MODIFIER',	'DistrictType',			'DISTRICT_HOLY_SITE'),
	('MINOR_CIV_VATICAN_CITY_HOLYSITE_ADJACENCY_MODIFIER',	'YieldType',		  	'YIELD_FAITH'),
	('MINOR_CIV_VATICAN_CITY_HOLYSITE_ADJACENCY_MODIFIER',	'Amount',		   			1),
	('MINOR_CIV_VATICAN_CITY_HOLYSITE_ADJACENCY_MODIFIER',	'Description',			'LOC_DISTRICT_DISTRICT_1_FAITH');

--Lahore_Nihang
insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
values
	('BUILDING_BARRACKS',					'LAHORE_NIHANG_BARRACKS_ADD_PURCHASE_COST'),
	('BUILDING_ARMORY',						'LAHORE_NIHANG_ARMORY_ADD_PURCHASE_COST'),
	('BUILDING_MILITARY_ACADEMY',			'LAHORE_NIHANG_ACADEMY_ADD_PURCHASE_COST');

insert or replace into BuildingModifiers
	(BuildingType,						  ModifierId)
select
	'BUILDING_BASILIKOI_PAIDES',		   'LAHORE_NIHANG_BARRACKS_ADD_PURCHASE_COST'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BASILIKOI_PAIDES');

insert or replace into Modifiers
	(ModifierId,									ModifierType,									   			 SubjectRequirementSetId,	   SubjectStackLimit)
values
	('LAHORE_NIHANG_BARRACKS_ADD_PURCHASE_COST',	'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST',		  null,						  1),
	('LAHORE_NIHANG_ARMORY_ADD_PURCHASE_COST',		'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST',		  null,						  1),
	('LAHORE_NIHANG_ACADEMY_ADD_PURCHASE_COST',		'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST',		  null,						  1);

insert or replace into ModifierArguments
	(ModifierId,									Name,			Value)
values
	('LAHORE_NIHANG_BARRACKS_ADD_PURCHASE_COST',	'UnitType',	 'UNIT_LAHORE_NIHANG'),
	('LAHORE_NIHANG_BARRACKS_ADD_PURCHASE_COST',	'Amount',	   -50),
	('LAHORE_NIHANG_ARMORY_ADD_PURCHASE_COST',		'UnitType',	 'UNIT_LAHORE_NIHANG'),
	('LAHORE_NIHANG_ARMORY_ADD_PURCHASE_COST',		'Amount',	   -100),
	('LAHORE_NIHANG_ACADEMY_ADD_PURCHASE_COST',		'UnitType',	 'UNIT_LAHORE_NIHANG'),
	('LAHORE_NIHANG_ACADEMY_ADD_PURCHASE_COST',		'Amount',	   -150);

insert or replace into UnitAbilityModifiers
	(UnitAbilityType,										ModifierId)
values
	('ABILITY_BYPASS_WALLS_PROMOTION_CLASS',				'BYPASS_WALLS_LAHORE_NIHANG'),
	('ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS',			'ENABLE_WALL_ATTACK_LAHORE_NIHANG');

insert or replace into Modifiers
	(ModifierId,									ModifierType)
values
	('BYPASS_WALLS_LAHORE_NIHANG',					'MODIFIER_PLAYER_UNIT_ADJUST_BYPASS_WALLS_PROMOTION_CLASS'),
	('ENABLE_WALL_ATTACK_LAHORE_NIHANG',			'MODIFIER_PLAYER_UNIT_ADJUST_ENABLE_WALL_ATTACK_PROMOTION_CLASS');

insert or replace into ModifierArguments
	(ModifierId,									Name,				Value)
values
	('BYPASS_WALLS_LAHORE_NIHANG',					'PromotionClass',   'PROMOTION_CLASS_NIHANG'),
	('ENABLE_WALL_ATTACK_LAHORE_NIHANG',			'PromotionClass',   'PROMOTION_CLASS_NIHANG');