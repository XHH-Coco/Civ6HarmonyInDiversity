-- 特效
delete from AppealHousingChanges where DistrictType = 'DISTRICT_PRESERVE';
delete from Adjacent_AppealYieldChanges where DistrictType = 'DISTRICT_PRESERVE';

insert or replace into DistrictModifiers (DistrictType, ModifierId) values
	('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_FLOODPLAINS_APPEAL'),
	('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_JUNGLE_APPEAL'),
	('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_MARSH_APPEAL'),
	('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_FLOODPLAINS_GRASSLAND_APPEAL'),
	('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_FLOODPLAINS_PLAINS_APPEAL');

-- 保护区UD适配
insert or replace into DistrictModifiers (DistrictType, ModifierId)
	select a.CivUniqueDistrictType, b.ModifierId
from DistrictReplaces a, DistrictModifiers b
	where a.ReplacesDistrictType = 'DISTRICT_PRESERVE'
	and b.DistrictType = 'DISTRICT_PRESERVE'
	and (b.ModifierId like 'HD_PRESERVE_FEATURE_%_APPEAL' or b.ModifierId like 'HD_PRESERVE_GRANT_DUMMY_%');

insert or replace into BuildingModifiers (BuildingType, ModifierId) values
	('BUILDING_GROVE',                          'HD_GROVE_PLOT_CHARMING_BONUS_1'),
	('BUILDING_GROVE',                          'HD_GROVE_PLOT_BREATHTAKING_BONUS_1'),

	('BUILDING_SANCTUARY',                      'HD_PRESERVE_FEATURE_FLOODPLAINS_APPEAL'),
	('BUILDING_SANCTUARY',                      'HD_PRESERVE_FEATURE_JUNGLE_APPEAL'),
	('BUILDING_SANCTUARY',                      'HD_PRESERVE_FEATURE_MARSH_APPEAL'),
	('BUILDING_SANCTUARY',                      'HD_PRESERVE_FEATURE_FLOODPLAINS_GRASSLAND_APPEAL'),
	('BUILDING_SANCTUARY',                      'HD_PRESERVE_FEATURE_FLOODPLAINS_PLAINS_APPEAL'),

	('BUILDING_SANCTUARY',                      'HD_SANCTUARY_BASIC_PLOT_YIELD_BONUS'),
	('BUILDING_SANCTUARY',                      'HD_SANCTUARY_RESOURCE_PLOT_YIELD_BONUS'),
	('BUILDING_SANCTUARY',                      'HD_SANCTUARY_CHARMING_PLOT_YIELD_BONUS'),
	('BUILDING_SANCTUARY',                      'HD_SANCTUARY_BREATHTAKING_PLOT_YIELD_BONUS'),
	('BUILDING_SANCTUARY',                      'HD_SANCTUARY_NATURAL_WONDER_PLOT_YIELD_BONUS'),

	('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_IMPROVEMENT_CHARMING_BONUS'),
	('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_IMPROVEMENT_BREATHTAKING_BONUS'),
	('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_1'),
	('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_2'),
	('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_1'),
	('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_2'),
	('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_TOURISM'),

	('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_1'),
	('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_1'),
	('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_NATIONAL_PARK_TOURISM'),
	('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_GRANT_UNIT_NATURALIST'),
	('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_UNIT_NATURALIST_DISCOUNT');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, OwnerRequirementSetId) values
	('HD_PRESERVE_FEATURE_FLOODPLAINS_APPEAL',                      'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               	NULL),
	('HD_PRESERVE_FEATURE_JUNGLE_APPEAL',                           'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               	NULL),
	('HD_PRESERVE_FEATURE_MARSH_APPEAL',                            'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               	NULL),
	('HD_PRESERVE_FEATURE_FLOODPLAINS_GRASSLAND_APPEAL',            'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               	NULL),
	('HD_PRESERVE_FEATURE_FLOODPLAINS_PLAINS_APPEAL',               'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               	NULL),

	('HD_GROVE_PLOT_CHARMING_BONUS_1',                          		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_CHARMING',                        	NULL),
	('HD_GROVE_PLOT_BREATHTAKING_BONUS_1',                      		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_BREATHTAKING',                    	NULL),
   
	('HD_SANCTUARY_BASIC_PLOT_YIELD_BONUS',             						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_FEATURE_REQUIREMENTS',										NULL),
	('HD_SANCTUARY_RESOURCE_PLOT_YIELD_BONUS',             					'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_FEATURE_AND_RESOURCE_REQUIREMENTS',			NULL),
	('HD_SANCTUARY_CHARMING_PLOT_YIELD_BONUS',             					'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_CHARMING_PLOT_HAS_FEATURE_REQUIREMENTS',          NULL),
	('HD_SANCTUARY_BREATHTAKING_PLOT_YIELD_BONUS',             			'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_BREATHTAKING_PLOT_HAS_FEATURE_REQUIREMENTS',      NULL),
	('HD_SANCTUARY_NATURAL_WONDER_PLOT_YIELD_BONUS',             		'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_NATURAL_WONDER_REQUIREMENTS',						NULL),
	
	('HD_HERITAGE_PRESERVE_IMPROVEMENT_CHARMING_BONUS',             'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_CHARMING_UNIQUE_IMPROVEMENT',              	NULL),
	('HD_HERITAGE_PRESERVE_IMPROVEMENT_BREATHTAKING_BONUS',         'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_BREATHTAKING_UNIQUE_IMPROVEMENT',          	NULL),
	('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_1',                'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',      'HD_PLOT_CHARMING_WONDER',                          	NULL),
	('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_2',                'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',      'HD_PLOT_CHARMING_WONDER',                          	NULL),
	('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_1',            'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',      'HD_PLOT_BREATHTAKING_WONDER',                      	NULL),
	('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_2',            'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',      'HD_PLOT_BREATHTAKING_WONDER',                      	NULL),
	('HD_HERITAGE_PRESERVE_WONDER_TOURISM',                         'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',              NULL,                                               	NULL),

	('HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_1',              'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER','HD_CITY_HAS_NATURAL_WONDER_REQUIREMENTS',          	NULL),
	('HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_1',               'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER','CITY_HAS_NATIONAL_PARK_REQUREMENTS',               	NULL),
	('HD_SCENIC_EPO_NATIONAL_PARK_TOURISM',                         'MODIFIER_PLAYER_ADJUST_TOURISM_FROM_NATIONAL_PARKS',NULL,                                              	NULL),
	('HD_SCENIC_EPO_GRANT_UNIT_NATURALIST',                         'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',          NULL,                                               	NULL),
	('HD_SCENIC_EPO_UNIT_NATURALIST_DISCOUNT',                      'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST', NULL,                                               	NULL);

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('HD_PRESERVE_FEATURE_FLOODPLAINS_APPEAL',                      'FeatureType',  'FEATURE_FLOODPLAINS'),
	('HD_PRESERVE_FEATURE_FLOODPLAINS_APPEAL',                      'Amount',       1),
	('HD_PRESERVE_FEATURE_JUNGLE_APPEAL',                           'FeatureType',  'FEATURE_JUNGLE'),
	('HD_PRESERVE_FEATURE_JUNGLE_APPEAL',                           'Amount',       1),
	('HD_PRESERVE_FEATURE_MARSH_APPEAL',                            'FeatureType',  'FEATURE_MARSH'),
	('HD_PRESERVE_FEATURE_MARSH_APPEAL',                            'Amount',       1),
	('HD_PRESERVE_FEATURE_FLOODPLAINS_GRASSLAND_APPEAL',            'FeatureType',  'FEATURE_FLOODPLAINS_GRASSLAND'),
	('HD_PRESERVE_FEATURE_FLOODPLAINS_GRASSLAND_APPEAL',            'Amount',       1),
	('HD_PRESERVE_FEATURE_FLOODPLAINS_PLAINS_APPEAL',               'FeatureType',  'FEATURE_FLOODPLAINS_PLAINS'),
	('HD_PRESERVE_FEATURE_FLOODPLAINS_PLAINS_APPEAL',               'Amount',       1),

	('HD_GROVE_PLOT_CHARMING_BONUS_1',                          		'YieldType',    'YIELD_CULTURE'),
	('HD_GROVE_PLOT_CHARMING_BONUS_1',                          		'Amount',       '1'),
	('HD_GROVE_PLOT_BREATHTAKING_BONUS_1',                      		'YieldType',    'YIELD_SCIENCE'),
	('HD_GROVE_PLOT_BREATHTAKING_BONUS_1',                      		'Amount',       '1'),
	
	('HD_SANCTUARY_BASIC_PLOT_YIELD_BONUS',                      		'YieldType',    'YIELD_FOOD'),
	('HD_SANCTUARY_BASIC_PLOT_YIELD_BONUS',                      		'Amount',       '1'),
	('HD_SANCTUARY_RESOURCE_PLOT_YIELD_BONUS',                      'YieldType',    'YIELD_PRODUCTION'),
	('HD_SANCTUARY_RESOURCE_PLOT_YIELD_BONUS',                      'Amount',       '1'),
	('HD_SANCTUARY_CHARMING_PLOT_YIELD_BONUS',                      'YieldType',    'YIELD_GOLD'),
	('HD_SANCTUARY_CHARMING_PLOT_YIELD_BONUS',                      'Amount',       '3'),
	('HD_SANCTUARY_BREATHTAKING_PLOT_YIELD_BONUS',                  'YieldType',    'YIELD_CULTURE'),
	('HD_SANCTUARY_BREATHTAKING_PLOT_YIELD_BONUS',                  'Amount',       '1'),
	('HD_SANCTUARY_NATURAL_WONDER_PLOT_YIELD_BONUS',                'YieldType',    'YIELD_FOOD,YIELD_GOLD,YIELD_CULTURE'),
	('HD_SANCTUARY_NATURAL_WONDER_PLOT_YIELD_BONUS',                'Amount',       '1,3,1'),

	('HD_HERITAGE_PRESERVE_IMPROVEMENT_CHARMING_BONUS',             'YieldType',    'YIELD_CULTURE,YIELD_GOLD'),
	('HD_HERITAGE_PRESERVE_IMPROVEMENT_CHARMING_BONUS',             'Amount',       '1,3'),
	('HD_HERITAGE_PRESERVE_IMPROVEMENT_BREATHTAKING_BONUS',         'YieldType',    'YIELD_CULTURE,YIELD_GOLD'),
	('HD_HERITAGE_PRESERVE_IMPROVEMENT_BREATHTAKING_BONUS',         'Amount',       '1,3'),
	('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_1',                'Amount',       1),
	('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_1',                'YieldType',    'YIELD_CULTURE'),
	('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_2',                'Amount',       3),
	('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_2',                'YieldType',    'YIELD_GOLD'),
	('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_1',            'Amount',       1),
	('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_1',            'YieldType',    'YIELD_CULTURE'),
	('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_2',            'Amount',       3),
	('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_2',            'YieldType',    'YIELD_GOLD'),
	('HD_HERITAGE_PRESERVE_WONDER_TOURISM',                         'BoostsWonders',1),
	('HD_HERITAGE_PRESERVE_WONDER_TOURISM',                         'ScalingFactor',200),

	('HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_1',              'YieldType',    'YIELD_PRODUCTION, YIELD_FOOD, YIELD_SCIENCE, YIELD_CULTURE, YIELD_GOLD, YIELD_FAITH'),
	('HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_1',              'Amount',       '5,5,5,5,5,5'),
	('HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_1',               'YieldType',    'YIELD_PRODUCTION, YIELD_FOOD, YIELD_SCIENCE, YIELD_CULTURE, YIELD_GOLD, YIELD_FAITH'),
	('HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_1',               'Amount',       '5,5,5,5,5,5'),
	('HD_SCENIC_EPO_NATIONAL_PARK_TOURISM',                         'Amount',       100),
	('HD_SCENIC_EPO_GRANT_UNIT_NATURALIST',                         'UnitType',     'UNIT_NATURALIST'),
	('HD_SCENIC_EPO_GRANT_UNIT_NATURALIST',                         'Amount',       1),
	('HD_SCENIC_EPO_UNIT_NATURALIST_DISCOUNT',                      'UnitType',     'UNIT_NATURALIST'),
	('HD_SCENIC_EPO_UNIT_NATURALIST_DISCOUNT',                      'Amount',       50);

-- 人文遗产保护部
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
	'BUILDING_HD_CULTURE_HERITAGE_PRESERVE', 'HD_HERITAGE_PRESERVE_' || ImprovementType || '_TOURISM'
from HD_Improvement_Classification where ImprovementClassificationType in ('IMPROVEMENT_CLASSIFICATION_UNIQUE', 'IMPROVEMENT_CLASSIFICATION_CITYSTATE');

insert or replace into Modifiers (ModifierId, ModifierType) select
	'HD_HERITAGE_PRESERVE_' || ImprovementType || '_TOURISM', 'MODIFIER_SINGLE_CITY_ADJUST_TOURISM'
from HD_Improvement_Classification where ImprovementClassificationType in ('IMPROVEMENT_CLASSIFICATION_UNIQUE', 'IMPROVEMENT_CLASSIFICATION_CITYSTATE');

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_HERITAGE_PRESERVE_' || ImprovementType || '_TOURISM', 'ImprovementType', ImprovementType
from HD_Improvement_Classification where ImprovementClassificationType in ('IMPROVEMENT_CLASSIFICATION_UNIQUE', 'IMPROVEMENT_CLASSIFICATION_CITYSTATE');

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_HERITAGE_PRESERVE_' || ImprovementType || '_TOURISM', 'ScalingFactor', 200
from HD_Improvement_Classification where ImprovementClassificationType in ('IMPROVEMENT_CLASSIFICATION_UNIQUE', 'IMPROVEMENT_CLASSIFICATION_CITYSTATE');

-------------------------------------------
-- 三级建筑
-- 地貌
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_HD_LANDFORM_EPO', 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_1'
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
	select 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_1', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_' || FeatureType
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_1', 'BuildingType', 'BUILDING_HD_LANDFORM_EPO'
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_1', 'YieldType', 'YIELD_CULTURE'
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_1', 'Amount', 8
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;

insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_HD_LANDFORM_EPO', 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_1'
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
	select 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_1', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_' || FeatureType
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_1', 'BuildingType', 'BUILDING_HD_LANDFORM_EPO'
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_1', 'YieldType', 'YIELD_SCIENCE'
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_1', 'Amount', 8
	from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;

-- 资源分类产出
insert or replace into HD_Building_Base_On_ResourceClassification (BuildingType, ResourceClassificationType, DetectRange, PropertyKey) values
	('BUILDING_HD_RESOURCE_EPO', 	'RESOURCE_CLASSIFICATION_MINERAL',			'PLAYER', 'HD_PLOT_BINARY_COMPRESS_RESOURCE_EPO'),
	('BUILDING_HD_SPECIES_EPO', 	'RESOURCE_CLASSIFICATION_BIOLOGICAL',		'PLAYER',	'HD_PLOT_BINARY_COMPRESS_SPECIES_EPO');

insert or replace into HD_Binary_Compress_Keys (Key, MaxExp) values
	('HD_PLOT_BINARY_COMPRESS_RESOURCE_EPO', 	6),
	('HD_PLOT_BINARY_COMPRESS_SPECIES_EPO', 	6);

-- 资源
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_HD_RESOURCE_EPO', 'HD_RESOURCE_EPO_SCIENCE_' || Exp
	from HD_Binary_Compress where Exp < 7;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
	select 'HD_RESOURCE_EPO_SCIENCE_' || Exp, 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_RESOURCE_EPO_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_RESOURCE_EPO_SCIENCE_' || Exp, 'BuildingType', 'BUILDING_HD_RESOURCE_EPO'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_RESOURCE_EPO_SCIENCE_' || Exp, 'YieldType', 'YIELD_SCIENCE'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_RESOURCE_EPO_SCIENCE_' || Exp, 'Amount', Amount * 4
	from HD_Binary_Compress where Exp < 7;

insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_HD_RESOURCE_EPO', 'HD_RESOURCE_EPO_PRODUCTION_' || Exp
	from HD_Binary_Compress where Exp < 7;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
	select 'HD_RESOURCE_EPO_PRODUCTION_' || Exp, 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_RESOURCE_EPO_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_RESOURCE_EPO_PRODUCTION_' || Exp, 'BuildingType', 'BUILDING_HD_RESOURCE_EPO'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_RESOURCE_EPO_PRODUCTION_' || Exp, 'YieldType', 'YIELD_PRODUCTION'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_RESOURCE_EPO_PRODUCTION_' || Exp, 'Amount', Amount * 4
	from HD_Binary_Compress where Exp < 7;

-- 物种
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_HD_SPECIES_EPO', 'HD_SPECIES_EPO_CULTURE_' || Exp
	from HD_Binary_Compress where Exp < 7;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
	select 'HD_SPECIES_EPO_CULTURE_' || Exp, 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_SPECIES_EPO_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SPECIES_EPO_CULTURE_' || Exp, 'BuildingType', 'BUILDING_HD_SPECIES_EPO'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SPECIES_EPO_CULTURE_' || Exp, 'YieldType', 'YIELD_CULTURE'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SPECIES_EPO_CULTURE_' || Exp, 'Amount', Amount * 4
	from HD_Binary_Compress where Exp < 7;

insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_HD_SPECIES_EPO', 'HD_SPECIES_EPO_FOOD_' || Exp
	from HD_Binary_Compress where Exp < 7;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
	select 'HD_SPECIES_EPO_FOOD_' || Exp, 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_SPECIES_EPO_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SPECIES_EPO_FOOD_' || Exp, 'BuildingType', 'BUILDING_HD_SPECIES_EPO'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SPECIES_EPO_FOOD_' || Exp, 'YieldType', 'YIELD_FOOD'
	from HD_Binary_Compress where Exp < 7;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SPECIES_EPO_FOOD_' || Exp, 'Amount', Amount * 4
	from HD_Binary_Compress where Exp < 7;

-- 名胜
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_HD_SCENIC_EPO', 'HD_SCENIC_EPO_' || a.FeatureType || '_ON_' || a.YieldType
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;
insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	select 'HD_SCENIC_EPO_' || a.FeatureType || '_ON_' || a.YieldType, 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'HD_PLOT_HAS_' || a.FeatureType
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SCENIC_EPO_' || a.FeatureType || '_ON_' || a.YieldType, 'YieldType', a.YieldType
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SCENIC_EPO_' || a.FeatureType || '_ON_' || a.YieldType, 'Amount', a.YieldChange * 2
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_HD_SCENIC_EPO', 'HD_SCENIC_EPO_' || FeatureType || '_ADJACENT_' || YieldType
	from Feature_AdjacentYields;
insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	select 'HD_SCENIC_EPO_' || FeatureType || '_ADJACENT_' || YieldType, 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'HD_PLOT_ADJACENT_TO_' || FeatureType
	from Feature_AdjacentYields;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SCENIC_EPO_' || FeatureType || '_ADJACENT_' || YieldType, 'YieldType', YieldType
	from Feature_AdjacentYields;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_SCENIC_EPO_' || FeatureType || '_ADJACENT_' || YieldType, 'Amount', YieldChange * 2
	from Feature_AdjacentYields;

-------------------------------------------
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType) values
	('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					          'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					          'REQUIREMENTSET_TEST_ANY');

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) values 
	('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					          'REQUIRES_PLAYER_HAS_BUILDING_HD_LANDFORM_EPO'),
	('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					          'REQUIRES_PLAYER_HAS_BUILDING_HD_RESOURCE_EPO'),
	('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					          'REQUIRES_PLAYER_HAS_BUILDING_HD_SPECIES_EPO'),
	('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					          'REQUIRES_PLAYER_HAS_BUILDING_HD_SCENIC_EPO'),

	('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					          'REQUIRES_CITY_HAS_BUILDING_HD_LANDFORM_EPO'),
	('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					          'REQUIRES_CITY_HAS_BUILDING_HD_RESOURCE_EPO'),
	('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					          'REQUIRES_CITY_HAS_BUILDING_HD_SCENIC_EPO'),
	('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					          'REQUIRES_CITY_HAS_BUILDING_HD_SPECIES_EPO');

-- 彩蛋
insert or replace into TraitModifiers (TraitType, ModifierId) values
	('TRAIT_LEADER_MAJOR_CIV', 'HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId,Permanent,SubjectStackLimit) values
	('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER', 'HD_PLAYER_HAS_4_PRESERVE_AGENCY', 1, 1);

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT', 'GovernmentSlotType', 'SLOT_WILDCARD'),
	('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT', 'Amount',             1);

insert or replace into ObsoletePolicies (PolicyType, ObsoletePolicy) values
	('POLICY_HD_BIOSYSTEMATICS', 'POLICY_HD_HARMONIOUS_COEXISTENCE');