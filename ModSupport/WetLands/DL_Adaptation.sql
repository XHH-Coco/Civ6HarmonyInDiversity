-------------------------------------
--     Adaptation for the Mod      --
-------------------------------------

-- Peat
insert or replace into Resource_ValidFeatures (ResourceType, FeatureType) values
	('RESOURCE_JNR_PEAT', 'FEATURE_FLOODPLAINS_GRASSLAND');

delete from Improvements_XP2 where ImprovementType in ('IMPROVEMENT_JNR_OASIS_FARM','IMPROVEMENT_JNR_REED_HOME');
update Resource_Harvests set PrereqTech = 'TECH_MASONRY' where ResourceType = 'RESOURCE_JNR_PEAT';

-- 绿洲花园 芦苇屋
update Improvements set PrereqTech = 'TECH_IRRIGATION', PrereqCivic = NULL, TilesRequired = 1, Appeal = 1 where ImprovementType = 'IMPROVEMENT_JNR_OASIS_FARM';
update Improvements set PrereqTech = NULL, PrereqCivic = 'CIVIC_CRAFTSMANSHIP', TilesRequired = 2 where ImprovementType = 'IMPROVEMENT_JNR_REED_HOME';

delete from Improvement_YieldChanges where ImprovementType = 'IMPROVEMENT_JNR_OASIS_FARM';
delete from Improvement_YieldChanges where ImprovementType = 'IMPROVEMENT_JNR_REED_HOME';
insert or replace into Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) values
	('IMPROVEMENT_JNR_OASIS_FARM',  'YIELD_CULTURE',    1),
	('IMPROVEMENT_JNR_OASIS_FARM',  'YIELD_GOLD',       0),
	('IMPROVEMENT_JNR_OASIS_FARM',  'YIELD_FOOD',       0),
	('IMPROVEMENT_JNR_REED_HOME',   'YIELD_PRODUCTION', 1),
	('IMPROVEMENT_JNR_REED_HOME',   'YIELD_SCIENCE',    1);

-- --------------------------------------------------------------
delete from Improvement_BonusYieldChanges where ImprovementType = 'IMPROVEMENT_JNR_OASIS_FARM';
delete from Improvement_BonusYieldChanges where ImprovementType = 'IMPROVEMENT_JNR_REED_HOME';
insert or replace into Improvement_BonusYieldChanges
  (Id,    ImprovementType,                YieldType,          BonusYieldChange,   PrereqTech,                 PrereqCivic)
values  
	(307,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_PRODUCTION',  1,                  'TECH_FUEL_HD',             NULL),
	(308,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_SCIENCE',  		1,                  'TECH_GEOMATICS_HD',        NULL),
	(309,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_SCIENCE',     1,                  'TECH_PHYSICS_HD',          NULL),
	(310,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_PRODUCTION',  1,                  NULL,      									'CIVIC_COMMERCIAL_CAPITALISM_HD'),
	(311,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_SCIENCE',     1,                  'TECH_GEOLOGY_HD',          NULL),
	(312,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_PRODUCTION',  1,                  'TECH_CATERPILLAR_TRACK_HD',NULL),
	(313,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_SCIENCE',     1,                  NULL,          							'CIVIC_PALEOBIOLOGY_HD'),
	(314,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_PRODUCTION',  1,                  'TECH_PLASTICS',          	NULL),
	(315,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_SCIENCE', 	 	1,                  'TECH_INTERNET_HD',					NULL),
	(316,  'IMPROVEMENT_JNR_REED_HOME',    'YIELD_SCIENCE', 	 	1,                  'TECH_NANOTECHNOLOGY',			NULL),

	(350,  'IMPROVEMENT_JNR_OASIS_FARM',   'YIELD_FOOD',        1,                  NULL,            						'CIVIC_HOUSEHOLD_REGISTRATION_HD'),
	(351,  'IMPROVEMENT_JNR_OASIS_FARM',   'YIELD_CULTURE',     1,                  'TECH_BUTTRESS',          	NULL),
	(352,  'IMPROVEMENT_JNR_OASIS_FARM',   'YIELD_GOLD',        3,                  NULL,            						'CIVIC_COMMERCIAL_CAPITALISM_HD'),
	(353,  'IMPROVEMENT_JNR_OASIS_FARM',   'YIELD_CULTURE',     1,                  NULL,            						'CIVIC_HUMANISM'),
	(354,  'IMPROVEMENT_JNR_OASIS_FARM',   'YIELD_CULTURE',     1,                  NULL,            						'CIVIC_URBAN_DESIGN_HD'),
	(355,  'IMPROVEMENT_JNR_OASIS_FARM',   'YIELD_GOLD',     		3,                  'TECH_SYNTHETIC_MATERIALS', NULL),
	(356,  'IMPROVEMENT_JNR_OASIS_FARM',   'YIELD_CULTURE',     1,                  NULL,            						'CIVIC_MODERNISM_HD');

-- 学院相邻
insert or replace into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqTech, PrereqCivic) values
	('HD_REED_HOME_SCIENCE_DISTRICT_CAMPUS', 'Placeholder', 'YIELD_SCIENCE', 1, 1, 'DISTRICT_CAMPUS', 'TECH_PAPER_MAKING_HD', NULL);
insert or ignore into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqTech, PrereqCivic)
	select 'HD_REED_HOME_SCIENCE_' || CivUniqueDistrictType, 'Placeholder', 'YIELD_SCIENCE', 1, 1, CivUniqueDistrictType, 'TECH_PAPER_MAKING_HD', NULL
from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_CAMPUS';

-- 堤坝相邻
insert or replace into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqTech, PrereqCivic) values
	('HD_REED_HOME_PRODUCTION_DISTRICT_DAM', 'Placeholder', 'YIELD_PRODUCTION', 1, 1, 'DISTRICT_DAM', NULL, NULL);
insert or ignore into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqTech, PrereqCivic)
	select 'HD_REED_HOME_PRODUCTION_' || CivUniqueDistrictType, 'Placeholder', 'YIELD_PRODUCTION', 1, 1, CivUniqueDistrictType, NULL, NULL
from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_DAM';

-- 剧院相邻
insert or replace into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqTech, PrereqCivic) values
	('HD_OASIS_FARM_CULTURE_DISTRICT_ENTERTAINMENT_COMPLEX', 'Placeholder', 'YIELD_CULTURE', 1, 1, 'DISTRICT_ENTERTAINMENT_COMPLEX', NULL, NULL);
insert or ignore into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqTech, PrereqCivic)
	select 'HD_OASIS_FARM_CULTURE_' || CivUniqueDistrictType, 'Placeholder', 'YIELD_CULTURE', 1, 1, CivUniqueDistrictType, NULL, NULL
from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX';

-- 社区相邻
insert or replace into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqTech, PrereqCivic) values
	('HD_OASIS_FARM_FOOD_DISTRICT_NEIGHBORHOOD', 'Placeholder', 'YIELD_FOOD', 1, 1, 'DISTRICT_NEIGHBORHOOD', NULL, 'CIVIC_FEUDALISM');
insert or ignore into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqTech, PrereqCivic)
	select 'HD_OASIS_FARM_FOOD_' || CivUniqueDistrictType, 'Placeholder', 'YIELD_FOOD', 1, 1, CivUniqueDistrictType, NULL, 'CIVIC_FEUDALISM'
from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_NEIGHBORHOOD';

delete from Improvement_Adjacencies where ImprovementType in ('IMPROVEMENT_JNR_REED_HOME', 'IMPROVEMENT_JNR_OASIS_FARM');
insert or replace into Improvement_Adjacencies
	(ImprovementType,			    YieldChangeId)
values
	('IMPROVEMENT_JNR_REED_HOME',	'HD_REED_HOME_SCIENCE_DISTRICT_CAMPUS'),
	('IMPROVEMENT_JNR_REED_HOME',	'HD_REED_HOME_PRODUCTION_DISTRICT_DAM'),

	('IMPROVEMENT_JNR_OASIS_FARM',	'HD_OASIS_FARM_CULTURE_DISTRICT_ENTERTAINMENT_COMPLEX'),
	('IMPROVEMENT_JNR_OASIS_FARM',	'HD_OASIS_FARM_FOOD_DISTRICT_NEIGHBORHOOD');

insert or replace into Improvement_Adjacencies (ImprovementType, YieldChangeId) select
	'IMPROVEMENT_JNR_REED_HOME', 'HD_REED_HOME_SCIENCE_' || CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_CAMPUS';
insert or replace into Improvement_Adjacencies (ImprovementType, YieldChangeId) select
	'IMPROVEMENT_JNR_REED_HOME', 'HD_REED_HOME_PRODUCTION_' || CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_DAM';
insert or replace into Improvement_Adjacencies (ImprovementType, YieldChangeId) select
	'IMPROVEMENT_JNR_OASIS_FARM', 'HD_OASIS_FARM_CULTURE_' || CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX';
insert or replace into Improvement_Adjacencies (ImprovementType, YieldChangeId) select
	'IMPROVEMENT_JNR_OASIS_FARM', 'HD_OASIS_FARM_FOOD_' || CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_NEIGHBORHOOD';

-- 旅游业绩
delete from Improvement_Tourism where ImprovementType in ('IMPROVEMENT_JNR_REED_HOME', 'IMPROVEMENT_JNR_OASIS_FARM');
insert or replace into Improvement_Tourism (ImprovementType, TourismSource) values
	('IMPROVEMENT_JNR_OASIS_FARM',	'TOURISMSOURCE_CULTURE'),
	('IMPROVEMENT_JNR_REED_HOME',		'TOURISMSOURCE_SCIENCE');

-- 改良特效
insert or replace into ImprovementModifiers (ImprovementType, ModifierID) values
	-- ('IMPROVEMENT_JNR_REED_HOME',  'JNR_REED_HOME_AQUEDUCT_PRODUCTION'),
	('IMPROVEMENT_JNR_REED_HOME',  'JNR_REED_HOME_NILOMETER_SCIENCE'),
	-- ('IMPROVEMENT_JNR_OASIS_FARM', 'JNR_OASIS_FARM_AQUEDUCT_FOOD'),
	('IMPROVEMENT_JNR_OASIS_FARM', 'JNR_OASIS_FARM_NILOMETER_CULTURE'),

	('IMPROVEMENT_JNR_OASIS_FARM', 'JNR_OASIS_FARM_AMENITY'),
	('IMPROVEMENT_JNR_OASIS_FARM', 'JNR_OASIS_FARM_AMENITY_1'),
	('IMPROVEMENT_JNR_OASIS_FARM', 'JNR_OASIS_FARM_AMENITY_2'),
	('IMPROVEMENT_JNR_OASIS_FARM', 'JNR_OASIS_FARM_AMENITY_3');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
	-- ('JNR_REED_HOME_AQUEDUCT_PRODUCTION', 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',  'REQUIRES_CITY_HAS_DISTRICT_AQUEDUCT_UDMET'),
	('JNR_REED_HOME_NILOMETER_SCIENCE',   'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',  'CITY_HAS_BUILDING_NILOMETER_HD_REQUIREMENTS'),
	-- ('JNR_OASIS_FARM_AQUEDUCT_FOOD',    	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',  'REQUIRES_CITY_HAS_DISTRICT_AQUEDUCT_UDMET'),
	('JNR_OASIS_FARM_NILOMETER_CULTURE',  'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',  'CITY_HAS_BUILDING_NILOMETER_HD_REQUIREMENTS'),

	('JNR_OASIS_FARM_AMENITY',    				'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY',  NULL),
	('JNR_OASIS_FARM_AMENITY_1',  				'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY',  'PLAYER_HAS_CIVIC_URBANIZATION_REQUIREMENTS'),
	('JNR_OASIS_FARM_AMENITY_2',  				'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY',  'PLAYER_HAS_TECH_REFRIGERATION_HD_REQUIREMENTS'),
	('JNR_OASIS_FARM_AMENITY_3',  				'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY',  'PLAYER_HAS_TECH_VIRTUAL_REALITY_HD_REQUIREMENTS');

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	-- ('JNR_REED_HOME_AQUEDUCT_PRODUCTION',  	'YieldType', 'YIELD_PRODUCTION'),
	-- ('JNR_REED_HOME_AQUEDUCT_PRODUCTION',  	'Amount',    1),
	('JNR_REED_HOME_NILOMETER_SCIENCE',    	'YieldType', 'YIELD_SCIENCE'),
	('JNR_REED_HOME_NILOMETER_SCIENCE',    	'Amount',    1),
	-- ('JNR_OASIS_FARM_AQUEDUCT_FOOD',    		'YieldType', 'YIELD_FOOD'),
	-- ('JNR_OASIS_FARM_AQUEDUCT_FOOD',    		'Amount',    1),
	('JNR_OASIS_FARM_NILOMETER_CULTURE',    'YieldType', 'YIELD_CULTURE'),
	('JNR_OASIS_FARM_NILOMETER_CULTURE',    'Amount',    1),

	('JNR_OASIS_FARM_AMENITY',    					'Amount',    1),
	('JNR_OASIS_FARM_AMENITY_1',  					'Amount',    1),
	('JNR_OASIS_FARM_AMENITY_2',  					'Amount',    1),
	('JNR_OASIS_FARM_AMENITY_3',  					'Amount',    1);

------------------------------------------------------------------------
------------------------------------------------------------------------
insert or replace into Features_XP2
	(FeatureType,           ValidForReplacement)
values
	('FEATURE_HD_SWAMP',    1);

insert or replace into Feature_ValidTerrains
	(FeatureType,           TerrainType)
values
	('FEATURE_HD_SWAMP',    'TERRAIN_PLAINS'),
	('FEATURE_HD_SWAMP',    'TERRAIN_PLAINS_HILLS');

insert or replace into Feature_Removes
	(FeatureType,           YieldType,          Yield)
values
	('FEATURE_HD_SWAMP',    'YIELD_PRODUCTION', 24);

insert or replace into Improvement_ValidFeatures
	(ImprovementType,               FeatureType)
values
	('IMPROVEMENT_JNR_REED_HOME',   'FEATURE_HD_SWAMP'),
	('IMPROVEMENT_JNR_REED_HOME',   'FEATURE_FLOODPLAINS'),
	('IMPROVEMENT_BARBARIAN_CAMP',  'FEATURE_HD_SWAMP'),
	('IMPROVEMENT_GOODY_HUT',       'FEATURE_HD_SWAMP'),
	('IMPROVEMENT_LAND_POLDER',     'FEATURE_HD_SWAMP'),
	('IMPROVEMENT_GREAT_WALL',			'FEATURE_HD_SWAMP'),
	('IMPROVEMENT_CHEMAMULL',				'FEATURE_HD_SWAMP'),
	('IMPROVEMENT_COLOSSAL_HEAD',		'FEATURE_HD_SWAMP'),
	('IMPROVEMENT_OPEN_AIR_MUSEUM',	'FEATURE_HD_SWAMP');
    
insert or replace into Improvement_ValidFeatures
	(ImprovementType,				FeatureType,					PrereqTech,			PrereqCivic)
values
	('IMPROVEMENT_MEKEWAP',	'FEATURE_HD_SWAMP',		'TECH_MINING',	null);

insert or replace into Improvement_ValidFeatures
	(ImprovementType,               FeatureType)
select
	'IMPROVEMENT_METEOR_GOODY',     'FEATURE_HD_SWAMP'
where exists (select ImprovementType from Improvements where ImprovementType = 'IMPROVEMENT_METEOR_GOODY');

insert or replace into Improvement_ValidFeatures
	(ImprovementType,               FeatureType)
select
	'IMPROVEMENT_SAILOR_WATCHTOWER','FEATURE_HD_SWAMP'
where exists (select ImprovementType from Improvements where ImprovementType = 'IMPROVEMENT_SAILOR_WATCHTOWER');

insert or replace into Building_RequiredFeatures
	(BuildingType,                  FeatureType)
select
	'BUILDING_ETEMENANKI',         'FEATURE_HD_SWAMP'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_ETEMENANKI');

delete from Resource_ValidFeatures where ResourceType = 'RESOURCE_TOBACCO' and FeatureType = 'FEATURE_FOREST';

insert or replace into Resource_ValidFeatures
	(ResourceType,                  FeatureType)
values
	('RESOURCE_IRON',               'FEATURE_HD_SWAMP'),
	('RESOURCE_DEER',               'FEATURE_HD_SWAMP'),
	('RESOURCE_GYPSUM',             'FEATURE_HD_SWAMP'),
	('RESOURCE_WHEAT',              'FEATURE_HD_SWAMP'),
	('RESOURCE_SALT',               'FEATURE_HD_SWAMP'),
	('RESOURCE_ANTIQUITY_SITE',     'FEATURE_HD_SWAMP'),
	('RESOURCE_TOBACCO',            'FEATURE_HD_SWAMP'),
	('RESOURCE_AMBER',              'FEATURE_HD_SWAMP');

insert or replace into Resource_ValidFeatures
	(ResourceType,                  FeatureType)
select
	ResourceType,                   'FEATURE_HD_SWAMP'
from Resources where ResourceType in
	('RESOURCE_WOLF','RESOURCE_TOXINS','RESOURCE_LEU_P0K_CAPYBARAS','RESOURCE_PINE','RESOURCE_LIMESTONE',
	'RESOURCE_P0K_MAPLE','RESOURCE_TIN','RESOURCE_HONEY','RESOURCE_BERRIES','RESOURCE_OAK','RESOURCE_SORGHUM','RESOURCE_MAPLE','RESOURCE_GOLD2');

insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
select
	'BUILDING_ETEMENANKI',      'ETEMENANKI_CULTURE_SWAMP'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_ETEMENANKI');

insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
select
	'BUILDING_ETEMENANKI',      'ETEMENANKI_PRODUCTION_SWAMP'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_ETEMENANKI');

insert or replace into BeliefModifiers
	(BeliefType,							    ModifierID)
values
	('BELIEF_HD_DRUID',	          'LADY_OF_THE_SWAMP_CULTURE');

insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
select
	'BUILDING_JNR_JINJA',       'JNR_JINJA_SWAMP_SCIENCE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_JNR_JINJA');

insert or replace into Modifiers
	(ModifierId,                            ModifierType,                                                       SubjectRequirementSetId)
values
	('ETEMENANKI_CULTURE_SWAMP',            'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                                'HD_PLOT_HAS_SWAMP_REQUIREMENTS'),
	('ETEMENANKI_PRODUCTION_SWAMP',         'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                                'HD_PLOT_HAS_SWAMP_REQUIREMENTS'),
	('JNR_JINJA_SWAMP_SCIENCE',							'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',		                	'HD_PLOT_HAS_SWAMP_REQUIREMENTS'),
	('LADY_OF_THE_SWAMP_CULTURE',						'MODIFIER_ALL_CITIES_ATTACH_MODIFIER',				                			'CITY_FOLLOWS_PANTHEON_REQUIREMENTS'),
	('LADY_OF_THE_SWAMP_CULTURE_MODIFIER',	'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',		                	'HD_PLOT_HAS_SWAMP_REQUIREMENTS'),
	('TRAIT_SWAMP_CULTIRE',	                'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		            		'HD_PLOT_HAS_SWAMP_REQUIREMENTS'),
	('TRAIT_SWAMP_BUILDINGS_CULTIRE',       'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_FEATURE_YIELD_CHANGE',      NULL);

insert or ignore into ModifierArguments
	(ModifierId,														Name,								Value)
values
	('ETEMENANKI_CULTURE_SWAMP',            'YieldType',        'YIELD_CULTURE'),
	('ETEMENANKI_CULTURE_SWAMP',            'Amount',           2),
	('ETEMENANKI_PRODUCTION_SWAMP',         'YieldType',        'YIELD_PRODUCTION'),
	('ETEMENANKI_PRODUCTION_SWAMP',         'Amount',           1),
	('JNR_JINJA_SWAMP_SCIENCE',             'YieldType',        'YIELD_SCIENCE'),
	('JNR_JINJA_SWAMP_SCIENCE',             'Amount',           2),
	('LADY_OF_THE_SWAMP_CULTURE',           'ModifierId',       'LADY_OF_THE_SWAMP_CULTURE_MODIFIER'),
	('LADY_OF_THE_SWAMP_CULTURE_MODIFIER',	'YieldType',        'YIELD_CULTURE,YIELD_FOOD'),
	('LADY_OF_THE_SWAMP_CULTURE_MODIFIER',	'Amount',           '1,1'),
	('TRAIT_SWAMP_CULTIRE',	                'YieldType',        'YIELD_CULTURE'),
	('TRAIT_SWAMP_CULTIRE',	                'Amount',           2),
	('TRAIT_SWAMP_BUILDINGS_CULTIRE',	    	'FeatureType',      'FEATURE_HD_SWAMP'),
	('TRAIT_SWAMP_BUILDINGS_CULTIRE',	    	'YieldType',        'YIELD_CULTURE'),
	('TRAIT_SWAMP_BUILDINGS_CULTIRE',	    	'Amount',           2);

insert or ignore into RequirementSets
	(RequirementSetId,								RequirementSetType)
values
	('HD_PLOT_HAS_SWAMP_REQUIREMENTS',              'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,                              RequirementId)
values
	('HD_PLOT_HAS_SWAMP_REQUIREMENTS',              'HD_REQUIRES_PLOT_HAS_FEATURE_HD_SWAMP');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,                              RequirementId)
select
	'PLOT_IS_JUNGLE_FOREST_MARSH_REQUIREMENTS',    'HD_REQUIRES_PLOT_HAS_FEATURE_HD_SWAMP'
where exists (select UnitType from Units where UnitType = 'UNIT_VIETNAMESE_VIETCONG');

insert or replace into TraitModifiers 
	(TraitType,                         ModifierId)
select
	'TRAIT_CIVILIZATION_VIETNAM',       'TRAIT_SWAMP_CULTIRE'
where exists (select CivilizationType from Civilizations where CivilizationType = 'CIVILIZATION_VIETNAM');

insert or replace into TraitModifiers 
	(TraitType,                         ModifierId)
select
	'TRAIT_CIVILIZATION_VIETNAM',       'TRAIT_SWAMP_BUILDINGS_CULTIRE'
where exists (select CivilizationType from Civilizations where CivilizationType = 'CIVILIZATION_VIETNAM');

insert or replace into TraitModifiers (TraitType,   ModifierId) 
	select 'TRAIT_CIVILIZATION_VIETNAM', 'TRAIT_SWAMP_VALID_' || DistrictType
	from Districts where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select CivilizationType from Civilizations where CivilizationType = 'CIVILIZATION_VIETNAM');

insert or replace into Modifiers    (ModifierId, ModifierType)
	select 'TRAIT_SWAMP_VALID_' || DistrictType, 'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS' 
	from Districts where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select CivilizationType from Civilizations where CivilizationType = 'CIVILIZATION_VIETNAM');

insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
	select 'TRAIT_SWAMP_VALID_' || DistrictType, 'DistrictType', DistrictType
	from Districts where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select CivilizationType from Civilizations where CivilizationType = 'CIVILIZATION_VIETNAM');

insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
	select 'TRAIT_SWAMP_VALID_' || DistrictType, 'FeatureType', 'FEATURE_HD_SWAMP'
	from Districts where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select CivilizationType from Civilizations where CivilizationType = 'CIVILIZATION_VIETNAM');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,                              RequirementId)
select
	'TRIEU_FEATURE_REQUIREMENTS',                   'HD_REQUIRES_PLOT_HAS_FEATURE_HD_SWAMP'
where exists (select CivilizationType from Civilizations where CivilizationType = 'CIVILIZATION_VIETNAM');

-- 圣地相邻加成
insert or replace into District_Adjacencies
	(DistrictType,						YieldChangeId)
values
	('DISTRICT_HOLY_SITE',				'Swamp_Faith');
insert or replace into Adjacency_YieldChanges
	(ID,				Description,			YieldType,		YieldChange,	AdjacentFeature)
values
	('Swamp_Faith',		'LOC_SWAMP_FAITH',		'YIELD_FAITH',	1,				'FEATURE_HD_SWAMP');

-- 杉林远征 Reqs
insert or ignore into RequirementSetRequirements
	(RequirementSetId,                              RequirementId)
values
	('HD_FIR_EXPEDITION_FEATURES_REQUIREMENTS',			'HD_REQUIRES_PLOT_HAS_FEATURE_HD_SWAMP'),
	('HD_FIR_EXPEDITION_FEATURES_REQUIREMENTS',			'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_HD_SWAMP');