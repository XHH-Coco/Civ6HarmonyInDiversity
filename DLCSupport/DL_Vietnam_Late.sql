CREATE TABLE 'HD_NATURAL_WONDERS_TYPE'(
    'FeatureType' TEXT NOT NULL,
    'Type' TEXT NOT NULL
);

insert or ignore into HD_NATURAL_WONDERS_TYPE
    (FeatureType,                       Type)
values
    ('FEATURE_BARRIER_REEF',            'SEA'),
    ('FEATURE_CLIFFS_DOVER',            'SEA'),
    ('FEATURE_CRATER_LAKE',             'LAKE'),
    ('FEATURE_DEAD_SEA',                'LAKE'),
    ('FEATURE_EVEREST',                 'MOUNTAIN'),
    ('FEATURE_GALAPAGOS',               'SEA'),
    ('FEATURE_KILIMANJARO',             'MOUNTAIN'),
    ('FEATURE_PANTANAL',                'WETLANDS'),
    ('FEATURE_PIOPIOTAHI',              'SEA'),
    ('FEATURE_TORRES_DEL_PAINE',        'MOUNTAIN'),
    ('FEATURE_TSINGY',                  'MOUNTAIN'),
    ('FEATURE_YOSEMITE',                'MOUNTAIN'),
    ('FEATURE_HA_LONG_BAY',             'SEA'),
    ('FEATURE_EYJAFJALLAJOKULL',        'MOUNTAIN'),
    ('FEATURE_LYSEFJORDEN',             'SEA'),
    ('FEATURE_GIANTS_CAUSEWAY',         'SEA'),
    ('FEATURE_ULURU',                   'MOUNTAIN'),
    ('FEATURE_DELICATE_ARCH',           'MOUNTAIN'),
    ('FEATURE_EYE_OF_THE_SAHARA',       'LAND'),
    ('FEATURE_LAKE_RETBA',              'LAKE'),
    ('FEATURE_MATTERHORN',              'MOUNTAIN'),
    ('FEATURE_RORAIMA',                 'MOUNTAIN'),
    ('FEATURE_UBSUNUR_HOLLOW',          'WETLANDS'),
    ('FEATURE_ZHANGYE_DANXIA',          'MOUNTAIN'),
    ('FEATURE_CHOCOLATEHILLS',          'JUNGLE'),
    ('FEATURE_DEVILSTOWER',             'MOUNTAIN'),
    ('FEATURE_GOBUSTAN',                'MOUNTAIN'),
    ('FEATURE_IKKIL',                   'LAKE'),
    ('FEATURE_PAMUKKALE',               'LAKE'),
    ('FEATURE_VESUVIUS',                'MOUNTAIN'),
    ('FEATURE_WHITEDESERT',             'LAND'),
    ('FEATURE_BERMUDA_TRIANGLE',        'SEA'),
    ('FEATURE_FOUNTAIN_OF_YOUTH',       'LAKE'),
    ('FEATURE_PAITITI',                 'JUNGLE'),
    ('FEATURE_SUK_FUJI',                'MOUNTAIN'),
    ('FEATURE_SUK_TONLESAP',            'LAKE'),
    ('FEATURE_SUK_NGORONGORO_CRATER',   'FOREST'),
    ('FEATURE_SUK_GREATBLUEHOLE',       'SEA'),
    ('FEATURE_SUK_GRANDCANYON',         'LAKE');
delete from HD_NATURAL_WONDERS_TYPE where FeatureType not in (select FeatureType from Features where NaturalWonder = 1);

    -- 特效
delete from AppealHousingChanges where DistrictType = 'DISTRICT_PRESERVE';
delete from Adjacent_AppealYieldChanges where DistrictType = 'DISTRICT_PRESERVE';

insert or replace into DistrictModifiers
    (DistrictType,          ModifierId)
values
--    ('DISTRICT_PRESERVE',   'HD_PRESERVE_ADD_FOOD_1'),
--    ('DISTRICT_PRESERVE',   'HD_PRESERVE_ADD_FOOD_2'),
    ('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_FLOODPLAINS_APPEAL'),
    ('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_JUNGLE_APPEAL'),
    ('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_MARSH_APPEAL'),
    ('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_FLOODPLAINS_GRASSLAND_APPEAL'),
    ('DISTRICT_PRESERVE',   'HD_PRESERVE_FEATURE_FLOODPLAINS_PLAINS_APPEAL'),

    ('DISTRICT_PRESERVE',   'HD_PRESERVE_GRANT_DUMMY_FOREST'),
    ('DISTRICT_PRESERVE',   'HD_PRESERVE_GRANT_DUMMY_JUNGLE'),
    ('DISTRICT_PRESERVE',   'HD_PRESERVE_GRANT_DUMMY_WETLANDS'),
    ('DISTRICT_PRESERVE',   'HD_PRESERVE_GRANT_DUMMY_WATER'),
    ('DISTRICT_PRESERVE',   'HD_PRESERVE_GRANT_DUMMY_HERITAGE');

-- 保护区UD适配
insert or replace into DistrictModifiers (DistrictType, ModifierId)
    select a.CivUniqueDistrictType, b.ModifierId
from DistrictReplaces a, DistrictModifiers b
    where a.ReplacesDistrictType = 'DISTRICT_PRESERVE'
    and b.DistrictType = 'DISTRICT_PRESERVE'
    and (b.ModifierId like 'HD_PRESERVE_FEATURE_%_APPEAL' or b.ModifierId like 'HD_PRESERVE_GRANT_DUMMY_%');

insert or replace into BuildingModifiers
    (BuildingType,                              ModifierId)
values
    ('BUILDING_GROVE',                          'HD_GROVE_PLOT_BONUS_1'),
--    ('BUILDING_GROVE',                          'HD_GROVE_PLOT_BONUS_2'),
--    ('BUILDING_GROVE',                          'HD_GROVE_PLOT_BONUS_3'),
    ('BUILDING_HD_MONASTERY',                   'HD_MONASTERY_PLOT_CHARMING_BONUS_1'),
--    ('BUILDING_HD_MONASTERY',                   'HD_MONASTERY_PLOT_CHARMING_BONUS_2'),
    ('BUILDING_HD_MONASTERY',                   'HD_MONASTERY_PLOT_BREATHTAKING_BONUS_1'),
--    ('BUILDING_HD_MONASTERY',                   'HD_MONASTERY_PLOT_BREATHTAKING_BONUS_2'),
    ('BUILDING_HD_HOLYWATERS',                  'HD_HOLYWATERS_PLOT_BONUS_1'),
--    ('BUILDING_HD_HOLYWATERS',                  'HD_HOLYWATERS_PLOT_BONUS_2'),
--    ('BUILDING_HD_HOLYWATERS',                  'HD_HOLYWATERS_PLOT_BONUS_3'),

    ('BUILDING_SANCTUARY',                      'HD_SANCTUARY_PLOT_FOREST_BONUS'),
    ('BUILDING_SANCTUARY',                      'HD_SANCTUARY_PLOT_CHARMING_BONUS'),
    ('BUILDING_SANCTUARY',                      'HD_SANCTUARY_PLOT_BREATHTAKING_BONUS'),
--    ('BUILDING_SANCTUARY',                      'HD_SANCTUARY_PLOT_NATURAL_WONDER_BONUS'),

    ('BUILDING_HD_JUNGLE_PRESERVE',             'HD_PRESERVE_FEATURE_JUNGLE_APPEAL'),
    ('BUILDING_HD_JUNGLE_PRESERVE',             'HD_JUNGLE_PRESERVE_PLOT_JUNGLE_BONUS'),
    ('BUILDING_HD_JUNGLE_PRESERVE',             'HD_JUNGLE_PRESERVE_PLOT_CHARMING_BONUS'),
    ('BUILDING_HD_JUNGLE_PRESERVE',             'HD_JUNGLE_PRESERVE_PLOT_BREATHTAKING_BONUS'),
--    ('BUILDING_HD_JUNGLE_PRESERVE',             'HD_JUNGLE_PRESERVE_PLOT_NATURAL_WONDER_BONUS'),

    ('BUILDING_HD_WETLANDS_PRESERVE',           'HD_PRESERVE_FEATURE_FLOODPLAINS_APPEAL'),
    ('BUILDING_HD_WETLANDS_PRESERVE',           'HD_PRESERVE_FEATURE_MARSH_APPEAL'),
    ('BUILDING_HD_WETLANDS_PRESERVE',           'HD_PRESERVE_FEATURE_FLOODPLAINS_GRASSLAND_APPEAL'),
    ('BUILDING_HD_WETLANDS_PRESERVE',           'HD_PRESERVE_FEATURE_FLOODPLAINS_PLAINS_APPEAL'),
    ('BUILDING_HD_WETLANDS_PRESERVE',           'HD_WETLANDS_PRESERVE_PLOT_WETLANDS_BONUS'),
    ('BUILDING_HD_WETLANDS_PRESERVE',           'HD_WETLANDS_PRESERVE_PLOT_CHARMING_BONUS'),
    ('BUILDING_HD_WETLANDS_PRESERVE',           'HD_WETLANDS_PRESERVE_PLOT_BREATHTAKING_BONUS'),
--    ('BUILDING_HD_WETLANDS_PRESERVE',           'HD_WETLANDS_PRESERVE_PLOT_NATURAL_WONDER_BONUS'),

    ('BUILDING_HD_WATER_PRESERVE',              'HD_WATER_PRESERVE_PLOT_WATER_BONUS'),
    ('BUILDING_HD_WATER_PRESERVE',              'HD_WATER_PRESERVE_PLOT_FEATURE_BONUS'),
    ('BUILDING_HD_WATER_PRESERVE',              'HD_WATER_PRESERVE_PLOT_RESOURCE_BONUS'),
--    ('BUILDING_HD_WATER_PRESERVE',              'HD_WATER_PRESERVE_PLOT_NATURAL_WONDER_BONUS'),

    ('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_IMPROVEMENT_CHARMING_BONUS'),
    ('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_IMPROVEMENT_BREATHTAKING_BONUS'),
    ('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_1'),
    ('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_2'),
    ('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_1'),
    ('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_2'),
    ('BUILDING_HD_CULTURE_HERITAGE_PRESERVE',   'HD_HERITAGE_PRESERVE_WONDER_TOURISM'),

    ('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_1'),
    ('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_1'),
    -- ('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_2'),
    -- ('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_2'),
    ('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_NATIONAL_PARK_TOURISM'),
    ('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_GRANT_UNIT_NATURALIST'),
    ('BUILDING_HD_SCENIC_EPO',                  'HD_SCENIC_EPO_UNIT_NATURALIST_DISCOUNT');

insert or replace into Modifiers
	(ModifierId,													ModifierType,										SubjectRequirementSetId,                            OwnerRequirementSetId)
values
--    ('HD_PRESERVE_ADD_FOOD_1',                                      'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_HAS_RESOURCE_OR_FEATURE',         NULL),
--    ('HD_PRESERVE_ADD_FOOD_2',                                      'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_HAS_RESOURCE_OR_FEATURE',         'HD_ADJACENT_TO_NATURAL_WONDER'),
    ('HD_PRESERVE_FEATURE_FLOODPLAINS_APPEAL',                      'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               NULL),
    ('HD_PRESERVE_FEATURE_JUNGLE_APPEAL',                           'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               NULL),
    ('HD_PRESERVE_FEATURE_MARSH_APPEAL',                            'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               NULL),
    ('HD_PRESERVE_FEATURE_FLOODPLAINS_GRASSLAND_APPEAL',            'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               NULL),
    ('HD_PRESERVE_FEATURE_FLOODPLAINS_PLAINS_APPEAL',               'MODIFIER_CITY_ADJUST_FEATURE_APPEAL_MODIFIER',     NULL,                                               NULL),

    ('HD_PRESERVE_GRANT_DUMMY_FOREST',                              'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE','HD_CITY_HAS_PRESERVE_TIER1',                      'HD_ON_OR_ADJACENT_FOREST'),
    ('HD_PRESERVE_GRANT_DUMMY_JUNGLE',                              'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE','HD_CITY_HAS_PRESERVE_TIER1',                      'HD_ON_OR_ADJACENT_JUNGLE'),
    ('HD_PRESERVE_GRANT_DUMMY_WETLANDS',                            'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE','HD_CITY_HAS_PRESERVE_TIER1',                      'HD_ON_OR_ADJACENT_WETLANDS'),
    ('HD_PRESERVE_GRANT_DUMMY_WATER',                               'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE','HD_CITY_HAS_PRESERVE_TIER1',                      'HD_ON_OR_ADJACENT_WATER'),
    ('HD_PRESERVE_GRANT_DUMMY_HERITAGE',                            'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE','HD_CITY_HAS_PRESERVE_TIER1',                      'HD_ADJACENT_UI_OR_WONDER'),

    ('HD_GROVE_PLOT_BONUS_1',                                       'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_HAS_GROVE_FEATURE',               NULL),
--    ('HD_GROVE_PLOT_BONUS_2',                                       'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_HAS_GROVE_FEATURE_RESOURCE',      NULL),
--    ('HD_GROVE_PLOT_BONUS_3',                                       'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_HAS_GROVE_NATURAL_WONDER',        NULL),
    
    ('HD_MONASTERY_PLOT_CHARMING_BONUS_1',                          'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_CHARMING',                        NULL),
--    ('HD_MONASTERY_PLOT_CHARMING_BONUS_2',                          'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_CHARMING',                        'HD_PLOT_ADJACENT_TO_MOUNTAIN_NATURAL_WONDERS'),
    ('HD_MONASTERY_PLOT_BREATHTAKING_BONUS_1',                      'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_BREATHTAKING',                    NULL),
--    ('HD_MONASTERY_PLOT_BREATHTAKING_BONUS_2',                      'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_BREATHTAKING',                    'HD_PLOT_ADJACENT_TO_MOUNTAIN_NATURAL_WONDERS'),
    
    ('HD_HOLYWATERS_PLOT_BONUS_1',                                  'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_WATER',                           NULL),
--    ('HD_HOLYWATERS_PLOT_BONUS_2',                                  'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_WATER_FEATURE_RESOURCE',          NULL),
--    ('HD_HOLYWATERS_PLOT_BONUS_3',                                  'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',                'HD_ADJACENT_PLOT_SEA_NATURAL_WONDER_ONLAND',       NULL),

    ('HD_SANCTUARY_PLOT_FOREST_BONUS',                              'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_FOREST_REQUIREMENTS',                  NULL),
    ('HD_SANCTUARY_PLOT_CHARMING_BONUS',                            'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_CHARMING_FOREST_RESOURCE',             NULL),
    ('HD_SANCTUARY_PLOT_BREATHTAKING_BONUS',                        'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_BREATHTAKING_FOREST_RESOURCE',         NULL),
--    ('HD_SANCTUARY_PLOT_NATURAL_WONDER_BONUS',                      'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_FOREST_NATURAL_WONDER',                NULL),

    ('HD_JUNGLE_PRESERVE_PLOT_JUNGLE_BONUS',                        'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_JUNGLE_REQUIREMENTS',                  NULL),
    ('HD_JUNGLE_PRESERVE_PLOT_CHARMING_BONUS',                      'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_CHARMING_JUNGLE_RESOURCE',             NULL),
    ('HD_JUNGLE_PRESERVE_PLOT_BREATHTAKING_BONUS',                  'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_BREATHTAKING_JUNGLE_RESOURCE',         NULL),
--    ('HD_JUNGLE_PRESERVE_PLOT_NATURAL_WONDER_BONUS',                'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_JUNGLE_NATURAL_WONDER',                NULL),

    ('HD_WETLANDS_PRESERVE_PLOT_WETLANDS_BONUS',                    'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_WETLANDS_REQUIREMENTS',                NULL),
    ('HD_WETLANDS_PRESERVE_PLOT_CHARMING_BONUS',                    'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_CHARMING_WETLANDS_RESOURCE',           NULL),
    ('HD_WETLANDS_PRESERVE_PLOT_BREATHTAKING_BONUS',                'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_BREATHTAKING_WETLANDS_RESOURCE',       NULL),
--    ('HD_WETLANDS_PRESERVE_PLOT_NATURAL_WONDER_BONUS',              'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_WETLANDS_NATURAL_WONDER',              NULL),

    ('HD_WATER_PRESERVE_PLOT_WATER_BONUS',                          'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'PLOT_HAS_COAST_REQUIREMENTS',                      NULL),
    ('HD_WATER_PRESERVE_PLOT_FEATURE_BONUS',                        'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_SEA_FEATURE',                          NULL),
    ('HD_WATER_PRESERVE_PLOT_RESOURCE_BONUS',                       'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_WATER_RESOURCE',                       NULL),
--    ('HD_WATER_PRESERVE_PLOT_NATURAL_WONDER_BONUS',                 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_HAS_SEA_NATURAL_WONDER',                   NULL),

    ('HD_HERITAGE_PRESERVE_IMPROVEMENT_CHARMING_BONUS',             'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_CHARMING_UNIQUE_IMPROVEMENT',              NULL),
    ('HD_HERITAGE_PRESERVE_IMPROVEMENT_BREATHTAKING_BONUS',         'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'HD_PLOT_BREATHTAKING_UNIQUE_IMPROVEMENT',          NULL),
    ('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_1',                'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',      'HD_PLOT_CHARMING_WONDER',                          NULL),
    ('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_2',                'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',      'HD_PLOT_CHARMING_WONDER',                          NULL),
    ('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_1',            'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',      'HD_PLOT_BREATHTAKING_WONDER',                      NULL),
    ('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_2',            'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',      'HD_PLOT_BREATHTAKING_WONDER',                      NULL),
    ('HD_HERITAGE_PRESERVE_WONDER_TOURISM',                         'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',              NULL,                                               NULL),

    ('HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_1',              'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER','ONE_WITH_NATURE_CITY_HAS_NATURAL_WONDER',          NULL),
    ('HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_1',               'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER','CITY_HAS_NATIONAL_PARK_REQUREMENTS',               NULL),
    -- ('HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_2',              'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER','ONE_WITH_NATURE_CITY_HAS_NATURAL_WONDER',          'HD_PLAYER_HAS_ALL_NATURAL_WONDER'),
    -- ('HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_2',               'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER','CITY_HAS_NATIONAL_PARK_REQUREMENTS',               'HD_PLAYER_HAS_ALL_NATURAL_WONDER'),
    ('HD_SCENIC_EPO_NATIONAL_PARK_TOURISM',                         'MODIFIER_PLAYER_ADJUST_TOURISM_FROM_NATIONAL_PARKS',NULL,                                              NULL),
    ('HD_SCENIC_EPO_GRANT_UNIT_NATURALIST',                         'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',          NULL,                                               NULL),
    ('HD_SCENIC_EPO_UNIT_NATURALIST_DISCOUNT',                      'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST', NULL,                                               NULL);

update Modifiers set SubjectRequirementSetId = 'HD_PLOT_HAS_SANCTUARY_FEATURE' where ModifierId = 'HD_SANCTUARY_PLOT_FOREST_BONUS'
and exists (select FeatureType from Features where FeatureType = 'FEATURE_JNR_SAVANNAH');

insert or replace into ModifierArguments
	(ModifierId,										            Name,			Value)
values
--    ('HD_PRESERVE_ADD_FOOD_1',                                      'YieldType',    'YIELD_FOOD'),
--    ('HD_PRESERVE_ADD_FOOD_1',                                      'Amount',       1),
--    ('HD_PRESERVE_ADD_FOOD_2',                                      'YieldType',    'YIELD_FOOD'),
--    ('HD_PRESERVE_ADD_FOOD_2',                                      'Amount',       1),
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
    
    ('HD_GROVE_PLOT_BONUS_1',                                       'YieldType',    'YIELD_FOOD,YIELD_GOLD'),
    ('HD_GROVE_PLOT_BONUS_1',                                       'Amount',       '1,1'),
--    ('HD_GROVE_PLOT_BONUS_2',                                       'YieldType',    'YIELD_FOOD,YIELD_CULTURE'),
--    ('HD_GROVE_PLOT_BONUS_2',                                       'Amount',       '1,1'),
--    ('HD_GROVE_PLOT_BONUS_3',                                       'YieldType',    'YIELD_FOOD,YIELD_CULTURE'),
--    ('HD_GROVE_PLOT_BONUS_3',                                       'Amount',       '2,2'),
    
    ('HD_MONASTERY_PLOT_CHARMING_BONUS_1',                          'YieldType',    'YIELD_CULTURE'),
    ('HD_MONASTERY_PLOT_CHARMING_BONUS_1',                          'Amount',       '1'),
--    ('HD_MONASTERY_PLOT_CHARMING_BONUS_2',                          'YieldType',    'YIELD_FAITH'),
--    ('HD_MONASTERY_PLOT_CHARMING_BONUS_2',                          'Amount',       '1'),
    ('HD_MONASTERY_PLOT_BREATHTAKING_BONUS_1',                      'YieldType',    'YIELD_SCIENCE'),
    ('HD_MONASTERY_PLOT_BREATHTAKING_BONUS_1',                      'Amount',       '1'),
--    ('HD_MONASTERY_PLOT_BREATHTAKING_BONUS_2',                      'YieldType',    'YIELD_FOOD,YIELD_SCIENCE'),
--    ('HD_MONASTERY_PLOT_BREATHTAKING_BONUS_2',                      'Amount',       '1,1'),
    
    ('HD_HOLYWATERS_PLOT_BONUS_1',                                  'YieldType',    'YIELD_PRODUCTION,YIELD_GOLD'),
    ('HD_HOLYWATERS_PLOT_BONUS_1',                                  'Amount',       '1,1'),
--    ('HD_HOLYWATERS_PLOT_BONUS_2',                                  'YieldType',    'YIELD_PRODUCTION,YIELD_SCIENCE'),
--    ('HD_HOLYWATERS_PLOT_BONUS_2',                                  'Amount',       '1,1'),
--    ('HD_HOLYWATERS_PLOT_BONUS_3',                                  'YieldType',    'YIELD_PRODUCTION,YIELD_SCIENCE,YIELD_FAITH'),
--    ('HD_HOLYWATERS_PLOT_BONUS_3',                                  'Amount',       '2,1,1'),

    ('HD_SANCTUARY_PLOT_FOREST_BONUS',                              'YieldType',    'YIELD_FOOD'),
    ('HD_SANCTUARY_PLOT_FOREST_BONUS',                              'Amount',       1),
    ('HD_SANCTUARY_PLOT_CHARMING_BONUS',                            'YieldType',    'YIELD_GOLD'),
    ('HD_SANCTUARY_PLOT_CHARMING_BONUS',                            'Amount',       2),
    ('HD_SANCTUARY_PLOT_BREATHTAKING_BONUS',                        'YieldType',    'YIELD_CULTURE'),
    ('HD_SANCTUARY_PLOT_BREATHTAKING_BONUS',                        'Amount',       1),
--    ('HD_SANCTUARY_PLOT_NATURAL_WONDER_BONUS',                      'YieldType',    'YIELD_FOOD,YIELD_CULTURE'),
--    ('HD_SANCTUARY_PLOT_NATURAL_WONDER_BONUS',                      'Amount',       '1,2'),

    ('HD_JUNGLE_PRESERVE_PLOT_JUNGLE_BONUS',                        'YieldType',    'YIELD_PRODUCTION'),
    ('HD_JUNGLE_PRESERVE_PLOT_JUNGLE_BONUS',                        'Amount',       1),
    ('HD_JUNGLE_PRESERVE_PLOT_CHARMING_BONUS',                      'YieldType',    'YIELD_GOLD'),
    ('HD_JUNGLE_PRESERVE_PLOT_CHARMING_BONUS',                      'Amount',       2),
    ('HD_JUNGLE_PRESERVE_PLOT_BREATHTAKING_BONUS',                  'YieldType',    'YIELD_SCIENCE'),
    ('HD_JUNGLE_PRESERVE_PLOT_BREATHTAKING_BONUS',                  'Amount',       1),
--    ('HD_JUNGLE_PRESERVE_PLOT_NATURAL_WONDER_BONUS',                'YieldType',    'YIELD_PRODUCTION,YIELD_SCIENCE'),
--    ('HD_JUNGLE_PRESERVE_PLOT_NATURAL_WONDER_BONUS',                'Amount',       '1,2'),

    ('HD_WETLANDS_PRESERVE_PLOT_WETLANDS_BONUS',                    'YieldType',    'YIELD_PRODUCTION'),
    ('HD_WETLANDS_PRESERVE_PLOT_WETLANDS_BONUS',                    'Amount',       1),
    ('HD_WETLANDS_PRESERVE_PLOT_CHARMING_BONUS',                    'YieldType',    'YIELD_GOLD'),
    ('HD_WETLANDS_PRESERVE_PLOT_CHARMING_BONUS',                    'Amount',       2),
    ('HD_WETLANDS_PRESERVE_PLOT_BREATHTAKING_BONUS',                'YieldType',    'YIELD_SCIENCE'),
    ('HD_WETLANDS_PRESERVE_PLOT_BREATHTAKING_BONUS',                'Amount',       1),
--   ('HD_WETLANDS_PRESERVE_PLOT_NATURAL_WONDER_BONUS',              'YieldType',    'YIELD_FOOD,YIELD_PRODUCTION,YIELD_SCIENCE'),
--   ('HD_WETLANDS_PRESERVE_PLOT_NATURAL_WONDER_BONUS',              'Amount',       '1,1,1'),

    ('HD_WATER_PRESERVE_PLOT_WATER_BONUS',                          'YieldType',    'YIELD_GOLD'),
    ('HD_WATER_PRESERVE_PLOT_WATER_BONUS',                          'Amount',       2),
    ('HD_WATER_PRESERVE_PLOT_FEATURE_BONUS',                        'YieldType',    'YIELD_CULTURE'),
    ('HD_WATER_PRESERVE_PLOT_FEATURE_BONUS',                        'Amount',       1),
    ('HD_WATER_PRESERVE_PLOT_RESOURCE_BONUS',                       'YieldType',    'YIELD_PRODUCTION'),
    ('HD_WATER_PRESERVE_PLOT_RESOURCE_BONUS',                       'Amount',       1),
--    ('HD_WATER_PRESERVE_PLOT_NATURAL_WONDER_BONUS',                 'YieldType',    'YIELD_FOOD,YIELD_PRODUCTION,YIELD_CULTURE'),
--    ('HD_WATER_PRESERVE_PLOT_NATURAL_WONDER_BONUS',                 'Amount',       '1,1,1'),

    ('HD_HERITAGE_PRESERVE_IMPROVEMENT_CHARMING_BONUS',             'YieldType',    'YIELD_CULTURE,YIELD_GOLD'),
    ('HD_HERITAGE_PRESERVE_IMPROVEMENT_CHARMING_BONUS',             'Amount',       '1,2'),
    ('HD_HERITAGE_PRESERVE_IMPROVEMENT_BREATHTAKING_BONUS',         'YieldType',    'YIELD_CULTURE,YIELD_GOLD'),
    ('HD_HERITAGE_PRESERVE_IMPROVEMENT_BREATHTAKING_BONUS',         'Amount',       '1,2'),
    ('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_1',                'Amount',       1),
    ('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_1',                'YieldType',    'YIELD_CULTURE'),
    ('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_2',                'Amount',       2),
    ('HD_HERITAGE_PRESERVE_WONDER_CHARMING_BONUS_2',                'YieldType',    'YIELD_GOLD'),
    ('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_1',            'Amount',       1),
    ('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_1',            'YieldType',    'YIELD_CULTURE'),
    ('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_2',            'Amount',       2),
    ('HD_HERITAGE_PRESERVE_WONDER_BREATHTAKING_BONUS_2',            'YieldType',    'YIELD_GOLD'),
    ('HD_HERITAGE_PRESERVE_WONDER_TOURISM',                         'BoostsWonders',1),
    ('HD_HERITAGE_PRESERVE_WONDER_TOURISM',                         'ScalingFactor',200),

    ('HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_1',              'YieldType',    'YIELD_PRODUCTION, YIELD_FOOD, YIELD_SCIENCE, YIELD_CULTURE, YIELD_GOLD, YIELD_FAITH'),
    ('HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_1',              'Amount',       '5,5,5,5,5,5'),
    ('HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_1',               'YieldType',    'YIELD_PRODUCTION, YIELD_FOOD, YIELD_SCIENCE, YIELD_CULTURE, YIELD_GOLD, YIELD_FAITH'),
    ('HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_1',               'Amount',       '5,5,5,5,5,5'),
    -- ('HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_2',              'YieldType',    'YIELD_PRODUCTION, YIELD_FOOD, YIELD_SCIENCE, YIELD_CULTURE, YIELD_GOLD, YIELD_FAITH'),
    -- ('HD_SCENIC_EPO_NATURAL_WONDER_ALL_YIELD_BONUS_2',              'Amount',       '15,15,15,15,15,15'),
    -- ('HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_2',               'YieldType',    'YIELD_PRODUCTION, YIELD_FOOD, YIELD_SCIENCE, YIELD_CULTURE, YIELD_GOLD, YIELD_FAITH'),
    -- ('HD_SCENIC_EPO_NATIONAL_PARK_ALL_YIELD_BONUS_2',               'Amount',       '15,15,15,15,15,15'),
    ('HD_SCENIC_EPO_NATIONAL_PARK_TOURISM',                         'Amount',       100),
    ('HD_SCENIC_EPO_GRANT_UNIT_NATURALIST',                         'UnitType',     'UNIT_NATURALIST'),
    ('HD_SCENIC_EPO_GRANT_UNIT_NATURALIST',                         'Amount',       1),
    ('HD_SCENIC_EPO_UNIT_NATURALIST_DISCOUNT',                      'UnitType',     'UNIT_NATURALIST'),
    ('HD_SCENIC_EPO_UNIT_NATURALIST_DISCOUNT',                      'Amount',       50),

    ('HD_PRESERVE_GRANT_DUMMY_FOREST',                              'BuildingType', 'BUILDING_HD_DUMMY_FOREST_PRESERVE'),
    ('HD_PRESERVE_GRANT_DUMMY_JUNGLE',                              'BuildingType', 'BUILDING_HD_DUMMY_JUNGLE_PRESERVE'),
    ('HD_PRESERVE_GRANT_DUMMY_WETLANDS',                            'BuildingType', 'BUILDING_HD_DUMMY_WETLANDS_PRESERVE'),
    ('HD_PRESERVE_GRANT_DUMMY_WATER',                               'BuildingType', 'BUILDING_HD_DUMMY_WATER_PRESERVE'),
    ('HD_PRESERVE_GRANT_DUMMY_HERITAGE',                            'BuildingType', 'BUILDING_HD_DUMMY_HERITAGE_PRESERVE');

-- 人文遗产保护部
insert or replace into BuildingModifiers
    (BuildingType,                              ModifierId)
select
    'BUILDING_HD_CULTURE_HERITAGE_PRESERVE',    'HD_HERITAGE_PRESERVE_' || ImprovementType || '_TOURISM'
from Improvements where (TraitType is not null and TraitType not in ('TRAIT_BARBARIAN','TRAIT_CIVILIZATION_NO_PLAYER'));

insert or replace into Modifiers
	(ModifierId,													ModifierType)
select
    'HD_HERITAGE_PRESERVE_' || ImprovementType || '_TOURISM',       'MODIFIER_SINGLE_CITY_ADJUST_TOURISM'
from Improvements where (TraitType is not null and TraitType not in ('TRAIT_BARBARIAN','TRAIT_CIVILIZATION_NO_PLAYER'));

insert or replace into ModifierArguments
	(ModifierId,										            Name,			    Value)
select
    'HD_HERITAGE_PRESERVE_' || ImprovementType || '_TOURISM',       'ImprovementType',  ImprovementType
from Improvements where (TraitType is not null and TraitType not in ('TRAIT_BARBARIAN','TRAIT_CIVILIZATION_NO_PLAYER'));
insert or replace into ModifierArguments
	(ModifierId,										            Name,			    Value)
select
    'HD_HERITAGE_PRESERVE_' || ImprovementType || '_TOURISM',       'ScalingFactor',    200
from Improvements where (TraitType is not null and TraitType not in ('TRAIT_BARBARIAN','TRAIT_CIVILIZATION_NO_PLAYER'));

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

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
--     select 'BUILDING_HD_LANDFORM_EPO', 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_2'
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
-- insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
--     select 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_2', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_' || FeatureType, 'HD_PLAYER_HAS_ALL_FEATURES'
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_2', 'BuildingType', 'BUILDING_HD_LANDFORM_EPO'
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_2', 'YieldType', 'YIELD_CULTURE'
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select 'HD_LANDFORM_EPO_' || FeatureType || '_CULTURE_2', 'Amount', 9
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
--     select 'BUILDING_HD_LANDFORM_EPO', 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_2'
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
-- insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
--     select 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_2', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_' || FeatureType, 'HD_PLAYER_HAS_ALL_FEATURES'
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_2', 'BuildingType', 'BUILDING_HD_LANDFORM_EPO'
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_2', 'YieldType', 'YIELD_SCIENCE'
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select 'HD_LANDFORM_EPO_' || FeatureType || '_SCIENCE_2', 'Amount', 9
--     from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;

    -- 资源
insert or replace into BuildingModifiers (BuildingType, ModifierId)
    select distinct 'BUILDING_HD_RESOURCE_EPO', 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_1'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
    select distinct 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_1', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_1', 'BuildingType', 'BUILDING_HD_RESOURCE_EPO'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_1', 'YieldType', 'YIELD_SCIENCE'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_1', 'Amount', 4
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';

insert or replace into BuildingModifiers (BuildingType, ModifierId)
    select distinct 'BUILDING_HD_RESOURCE_EPO', 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_1'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
    select distinct 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_1', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_1', 'BuildingType', 'BUILDING_HD_RESOURCE_EPO'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_1', 'YieldType', 'YIELD_PRODUCTION'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_1', 'Amount', 4
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
--     select distinct 'BUILDING_HD_RESOURCE_EPO', 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_2'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
-- insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
--     select distinct 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_2', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS', 'HD_PLAYER_GOT_ALL_ORE_RESOURCE_ON_MAP'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_2', 'BuildingType', 'BUILDING_HD_RESOURCE_EPO'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_2', 'YieldType', 'YIELD_SCIENCE'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_RESOURCE_EPO' || ResourceType || '_SCIENCE_2', 'Amount', 6
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
--     select distinct 'BUILDING_HD_RESOURCE_EPO', 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_2'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
-- insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
--     select distinct 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_2', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS', 'HD_PLAYER_GOT_ALL_ORE_RESOURCE_ON_MAP'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_2', 'BuildingType', 'BUILDING_HD_RESOURCE_EPO'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_2', 'YieldType', 'YIELD_PRODUCTION'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_RESOURCE_EPO' || ResourceType || '_PRODUCTION_2', 'Amount', 6
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';

--     -- 物种
insert or replace into BuildingModifiers (BuildingType, ModifierId)
    select distinct 'BUILDING_HD_SPECIES_EPO', 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_1'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
    select distinct 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_1', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_1', 'BuildingType', 'BUILDING_HD_SPECIES_EPO'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_1', 'YieldType', 'YIELD_CULTURE'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_1', 'Amount', 4
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');

insert or replace into BuildingModifiers (BuildingType, ModifierId)
    select distinct 'BUILDING_HD_SPECIES_EPO', 'HD_SPECIES_EPO' || ResourceType || '_FOOD_1'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
    select distinct 'HD_SPECIES_EPO' || ResourceType || '_FOOD_1', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_SPECIES_EPO' || ResourceType || '_FOOD_1', 'BuildingType', 'BUILDING_HD_SPECIES_EPO'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_SPECIES_EPO' || ResourceType || '_FOOD_1', 'YieldType', 'YIELD_FOOD'
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
insert or replace into ModifierArguments (ModifierId, Name, Value)
    select distinct 'HD_SPECIES_EPO' || ResourceType || '_FOOD_1', 'Amount', 4
    from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
--     select distinct 'BUILDING_HD_SPECIES_EPO', 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_2'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
-- insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
--     select distinct 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_2', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS', 'HD_PLAYER_GOT_ALL_BIO_RESOURCE_ON_MAP'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_2', 'BuildingType', 'BUILDING_HD_SPECIES_EPO'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_2', 'YieldType', 'YIELD_CULTURE'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_SPECIES_EPO' || ResourceType || '_CULTURE_2', 'Amount', 6
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
--     select distinct 'BUILDING_HD_SPECIES_EPO', 'HD_SPECIES_EPO' || ResourceType || '_FOOD_2'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
-- insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
--     select distinct 'HD_SPECIES_EPO' || ResourceType || '_FOOD_2', 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS', 'HD_PLAYER_GOT_ALL_BIO_RESOURCE_ON_MAP'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_SPECIES_EPO' || ResourceType || '_FOOD_2', 'BuildingType', 'BUILDING_HD_SPECIES_EPO'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_SPECIES_EPO' || ResourceType || '_FOOD_2', 'YieldType', 'YIELD_GOLD'
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');
-- insert or replace into ModifierArguments (ModifierId, Name, Value)
--     select distinct 'HD_SPECIES_EPO' || ResourceType || '_FOOD_2', 'Amount', 6
--     from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');

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

insert or ignore into Requirements
	(RequirementId,									                RequirementType)
values
    ('HD_PLOT_HAS_RESOURCE_OR_FEATURE_MET',   		                'REQUIREMENT_REQUIREMENTSET_IS_MET'),
    ('HD_PLOT_HAS_GROVE_FEATURE_MET',   		                    'REQUIREMENT_REQUIREMENTSET_IS_MET'),
    ('HD_PLOT_HAS_GROVE_NATURAL_WONDER_MET',   		                'REQUIREMENT_REQUIREMENTSET_IS_MET'),
    ('HD_PLOT_HAS_SEA_NATURAL_WONDER_MET',   		                'REQUIREMENT_REQUIREMENTSET_IS_MET'),
    ('HD_PLOT_HAS_WETLANDS_REQUIREMENTS_MET',   		            'REQUIREMENT_REQUIREMENTSET_IS_MET'),
    ('HD_PLOT_HAS_UNIQUE_IMPROVEMENT_MET',   		                'REQUIREMENT_REQUIREMENTSET_IS_MET');

insert or ignore into RequirementArguments
	(RequirementId,									                Name,				    Value)
values
    ('HD_PLOT_HAS_RESOURCE_OR_FEATURE_MET',                         'RequirementSetId',     'HD_PLOT_HAS_RESOURCE_OR_FEATURE'),
    ('HD_PLOT_HAS_GROVE_FEATURE_MET',                               'RequirementSetId',     'HD_PLOT_HAS_GROVE_FEATURE'),
    ('HD_PLOT_HAS_GROVE_NATURAL_WONDER_MET',                        'RequirementSetId',     'HD_PLOT_HAS_GROVE_NATURAL_WONDER'),
    ('HD_PLOT_HAS_SEA_NATURAL_WONDER_MET',                          'RequirementSetId',     'HD_PLOT_HAS_SEA_NATURAL_WONDER'),
    ('HD_PLOT_HAS_WETLANDS_REQUIREMENTS_MET',                       'RequirementSetId',     'HD_PLOT_HAS_WETLANDS_REQUIREMENTS'),
    ('HD_PLOT_HAS_UNIQUE_IMPROVEMENT_MET',                          'RequirementSetId',     'HD_PLOT_HAS_UNIQUE_IMPROVEMENT');

insert or ignore into RequirementSets
	(RequirementSetId,												RequirementSetType)
values
	('HD_ADJACENT_TO_NATURAL_WONDER',								'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_HAS_RESOURCE_OR_FEATURE',								'REQUIREMENTSET_TEST_ANY'),
    ('HD_ADJACENT_PLOT_HAS_RESOURCE_OR_FEATURE',					'REQUIREMENTSET_TEST_ALL'),

    ('HD_CITY_HAS_PRESERVE_TIER1',								    'REQUIREMENTSET_TEST_ANY'),
    ('HD_ON_OR_ADJACENT_FOREST',								    'REQUIREMENTSET_TEST_ANY'),
    ('HD_ON_OR_ADJACENT_JUNGLE',								    'REQUIREMENTSET_TEST_ANY'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'REQUIREMENTSET_TEST_ANY'),
    ('HD_ON_OR_ADJACENT_WATER',								        'REQUIREMENTSET_TEST_ANY'),
    ('HD_ADJACENT_UI_OR_WONDER',								    'REQUIREMENTSET_TEST_ANY'),

    ('HD_PLOT_HAS_GROVE_FEATURE',					                'REQUIREMENTSET_TEST_ANY'),
    ('HD_PLOT_HAS_GROVE_NATURAL_WONDER',					        'REQUIREMENTSET_TEST_ANY'),
    ('HD_ADJACENT_PLOT_HAS_GROVE_FEATURE',					        'REQUIREMENTSET_TEST_ALL'),
    ('HD_ADJACENT_PLOT_HAS_GROVE_NATURAL_WONDER',					'REQUIREMENTSET_TEST_ALL'),
    ('HD_ADJACENT_PLOT_HAS_GROVE_FEATURE_RESOURCE',					'REQUIREMENTSET_TEST_ALL'),

    ('HD_PLOT_ADJACENT_TO_MOUNTAIN_NATURAL_WONDERS',				'REQUIREMENTSET_TEST_ANY'),
    ('HD_ADJACENT_PLOT_CHARMING',					                'REQUIREMENTSET_TEST_ALL'),
    ('HD_ADJACENT_PLOT_BREATHTAKING',					            'REQUIREMENTSET_TEST_ALL'),

    ('HD_ADJACENT_PLOT_WATER_FEATURE_RESOURCE',					    'REQUIREMENTSET_TEST_ALL'),
    ('HD_ADJACENT_PLOT_SEA_NATURAL_WONDER_ONLAND',					'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_HAS_SEA_NATURAL_WONDER',					            'REQUIREMENTSET_TEST_ANY'),

    ('HD_PLOT_HAS_CHARMING_FOREST_RESOURCE',				        'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_HAS_BREATHTAKING_FOREST_RESOURCE',					'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_HAS_FOREST_NATURAL_WONDER',					        'REQUIREMENTSET_TEST_ANY'),

    ('HD_PLOT_HAS_CHARMING_JUNGLE_RESOURCE',				        'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_HAS_BREATHTAKING_JUNGLE_RESOURCE',					'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_HAS_JUNGLE_NATURAL_WONDER',					        'REQUIREMENTSET_TEST_ANY'),

    ('HD_PLOT_HAS_WETLANDS_REQUIREMENTS',				            'REQUIREMENTSET_TEST_ANY'),
    ('HD_PLOT_HAS_CHARMING_WETLANDS_RESOURCE',					    'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_HAS_BREATHTAKING_WETLANDS_RESOURCE',					'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_HAS_WETLANDS_NATURAL_WONDER',					        'REQUIREMENTSET_TEST_ANY'),

    ('HD_PLOT_HAS_WATER_RESOURCE',				                    'REQUIREMENTSET_TEST_ALL'),

    ('HD_PLOT_HAS_UNIQUE_IMPROVEMENT',				                'REQUIREMENTSET_TEST_ANY'),
    ('HD_PLOT_CHARMING_UNIQUE_IMPROVEMENT',					        'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_BREATHTAKING_UNIQUE_IMPROVEMENT',					    'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_CHARMING_WONDER',					                    'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLOT_BREATHTAKING_WONDER',					                'REQUIREMENTSET_TEST_ALL'),

    ('HD_PLAYER_HAS_5_CONSERVATION_DEPARTMENT',					    'REQUIREMENTSET_TEST_ALL'),
    ('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					            'REQUIREMENTSET_TEST_ALL'),
    ('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					            'REQUIREMENTSET_TEST_ANY');

    -- ('HD_PLAYER_HAS_ALL_FEATURES',					                'REQUIREMENTSET_TEST_ALL'),
    -- ('HD_PLAYER_HAS_ALL_NATURAL_WONDER',					            'REQUIREMENTSET_TEST_ALL');
    -- ('HD_PLAYER_GOT_ALL_ORE_RESOURCE_ON_MAP',					    'REQUIREMENTSET_TEST_ALL'),
    -- ('HD_PLAYER_GOT_ALL_BIO_RESOURCE_ON_MAP',					    'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
values
	('HD_ADJACENT_TO_NATURAL_WONDER',								'REQUIRES_PLOT_ADJACENT_TO_NATURAL_WONDER'),
    ('HD_PLOT_HAS_RESOURCE_OR_FEATURE',								'PLOT_HAS_RESOURCE_REQUIREMENTS'),
    ('HD_PLOT_HAS_RESOURCE_OR_FEATURE',								'PLOT_HAS_ANY_FEATURE_REQUIREMENT'),
    ('HD_ADJACENT_PLOT_HAS_RESOURCE_OR_FEATURE',    				'HD_PLOT_HAS_RESOURCE_OR_FEATURE_MET'),
    ('HD_ADJACENT_PLOT_HAS_RESOURCE_OR_FEATURE',    				'ADJACENT_TO_OWNER'),

    ('HD_CITY_HAS_PRESERVE_TIER1',								    'REQUIRES_CITY_HAS_BUILDING_GROVE'),
    ('HD_CITY_HAS_PRESERVE_TIER1',								    'REQUIRES_CITY_HAS_BUILDING_HD_MONASTERY'),
    ('HD_CITY_HAS_PRESERVE_TIER1',								    'REQUIRES_CITY_HAS_BUILDING_HD_HOLYWATERS'),

    ('HD_ON_OR_ADJACENT_FOREST',								    'HD_REQUIRES_PLOT_HAS_FEATURE_FOREST'),
    ('HD_ON_OR_ADJACENT_FOREST',								    'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_FOREST'),
    ('HD_ON_OR_ADJACENT_JUNGLE',								    'HD_REQUIRES_PLOT_HAS_FEATURE_JUNGLE'),
    ('HD_ON_OR_ADJACENT_JUNGLE',								    'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_JUNGLE'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'HD_REQUIRES_PLOT_HAS_FEATURE_FLOODPLAINS'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_FLOODPLAINS'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'HD_REQUIRES_PLOT_HAS_FEATURE_MARSH'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_MARSH'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'HD_REQUIRES_PLOT_HAS_FEATURE_FLOODPLAINS_GRASSLAND'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_FLOODPLAINS_GRASSLAND'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'HD_REQUIRES_PLOT_HAS_FEATURE_FLOODPLAINS_PLAINS'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_FLOODPLAINS_PLAINS'),
    ('HD_ON_OR_ADJACENT_WETLANDS',								    'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_OASIS'),
    ('HD_ON_OR_ADJACENT_WATER',								        'REQUIRES_PLOT_IS_ADJACENT_TO_COAST'),
    ('HD_ADJACENT_UI_OR_WONDER',								    'REQUIRES_PLOT_ADJACENT_TO_WONDER'),

    ('HD_PLOT_HAS_GROVE_FEATURE',					                'HD_REQUIRES_PLOT_HAS_FEATURE_JUNGLE'),
    ('HD_PLOT_HAS_GROVE_FEATURE',					                'HD_REQUIRES_PLOT_HAS_FEATURE_FOREST'),
    ('HD_PLOT_HAS_GROVE_FEATURE',					                'HD_REQUIRES_PLOT_HAS_FEATURE_OASIS'),
    ('HD_PLOT_HAS_GROVE_FEATURE',					                'HD_REQUIRES_PLOT_HAS_FEATURE_MARSH'),
    ('HD_ADJACENT_PLOT_HAS_GROVE_FEATURE',          				'ADJACENT_TO_OWNER'),
    ('HD_ADJACENT_PLOT_HAS_GROVE_FEATURE',          				'HD_PLOT_HAS_GROVE_FEATURE_MET'),
    ('HD_ADJACENT_PLOT_HAS_GROVE_NATURAL_WONDER',      				'ADJACENT_TO_OWNER'),
    ('HD_ADJACENT_PLOT_HAS_GROVE_NATURAL_WONDER',      				'HD_PLOT_HAS_GROVE_NATURAL_WONDER_MET'),
    ('HD_ADJACENT_PLOT_HAS_GROVE_FEATURE_RESOURCE',    				'ADJACENT_TO_OWNER'),
--    ('HD_ADJACENT_PLOT_HAS_GROVE_FEATURE_RESOURCE',    				'HD_PLOT_HAS_GROVE_FEATURE_MET'),
--    ('HD_ADJACENT_PLOT_HAS_GROVE_FEATURE_RESOURCE',    				'PLOT_HAS_RESOURCE_REQUIREMENTS'),

    ('HD_PLOT_ADJACENT_TO_MOUNTAIN_NATURAL_WONDERS',				'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
    ('HD_ADJACENT_PLOT_CHARMING',					                'ADJACENT_TO_OWNER'),
    ('HD_ADJACENT_PLOT_CHARMING',					                'REQUIRES_PLOT_CHARMING_APPEAL'),
    ('HD_ADJACENT_PLOT_BREATHTAKING',					            'ADJACENT_TO_OWNER'),
    ('HD_ADJACENT_PLOT_BREATHTAKING',					            'REQUIRES_PLOT_BREATHTAKING_APPEAL'),

    ('HD_ADJACENT_PLOT_WATER_FEATURE_RESOURCE',					    'ADJACENT_TO_OWNER'),
    ('HD_ADJACENT_PLOT_WATER_FEATURE_RESOURCE',					    'REQUIRES_PLOT_HAS_COAST'),
    ('HD_ADJACENT_PLOT_WATER_FEATURE_RESOURCE',					    'HD_PLOT_HAS_RESOURCE_OR_FEATURE_MET'),
    ('HD_ADJACENT_PLOT_SEA_NATURAL_WONDER_ONLAND',				    'ADJACENT_TO_OWNER'),
    ('HD_ADJACENT_PLOT_SEA_NATURAL_WONDER_ONLAND',				    'REQUIRES_PLOT_HAS_NOT_COAST'),
    ('HD_ADJACENT_PLOT_SEA_NATURAL_WONDER_ONLAND',				    'HD_PLOT_HAS_SEA_NATURAL_WONDER_MET'),

    ('HD_PLOT_HAS_CHARMING_FOREST_RESOURCE',				        'PLOT_IS_FOREST_REQUIREMENT'),
    ('HD_PLOT_HAS_CHARMING_FOREST_RESOURCE',				        'REQUIRES_PLOT_CHARMING_APPEAL'),
--    ('HD_PLOT_HAS_CHARMING_FOREST_RESOURCE',				        'PLOT_HAS_RESOURCE_REQUIREMENTS'),
    ('HD_PLOT_HAS_BREATHTAKING_FOREST_RESOURCE',					'PLOT_IS_FOREST_REQUIREMENT'),
    ('HD_PLOT_HAS_BREATHTAKING_FOREST_RESOURCE',					'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
--    ('HD_PLOT_HAS_BREATHTAKING_FOREST_RESOURCE',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),

    ('HD_PLOT_HAS_CHARMING_JUNGLE_RESOURCE',				        'PLOT_IS_JUNGLE_REQUIREMENT'),
    ('HD_PLOT_HAS_CHARMING_JUNGLE_RESOURCE',				        'REQUIRES_PLOT_CHARMING_APPEAL'),
--    ('HD_PLOT_HAS_CHARMING_JUNGLE_RESOURCE',				        'PLOT_HAS_RESOURCE_REQUIREMENTS'),
    ('HD_PLOT_HAS_BREATHTAKING_JUNGLE_RESOURCE',					'PLOT_IS_JUNGLE_REQUIREMENT'),
    ('HD_PLOT_HAS_BREATHTAKING_JUNGLE_RESOURCE',					'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
--    ('HD_PLOT_HAS_BREATHTAKING_JUNGLE_RESOURCE',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),

    ('HD_PLOT_HAS_WETLANDS_REQUIREMENTS',				            'HD_REQUIRES_PLOT_HAS_FEATURE_FLOODPLAINS'),
    ('HD_PLOT_HAS_WETLANDS_REQUIREMENTS',				            'HD_REQUIRES_PLOT_HAS_FEATURE_OASIS'),
    ('HD_PLOT_HAS_WETLANDS_REQUIREMENTS',				            'HD_REQUIRES_PLOT_HAS_FEATURE_MARSH'),
    ('HD_PLOT_HAS_WETLANDS_REQUIREMENTS',				            'HD_REQUIRES_PLOT_HAS_FEATURE_FLOODPLAINS_GRASSLAND'),
    ('HD_PLOT_HAS_WETLANDS_REQUIREMENTS',				            'HD_REQUIRES_PLOT_HAS_FEATURE_FLOODPLAINS_PLAINS'),
    ('HD_PLOT_HAS_CHARMING_WETLANDS_RESOURCE',					    'HD_PLOT_HAS_WETLANDS_REQUIREMENTS_MET'),
    ('HD_PLOT_HAS_CHARMING_WETLANDS_RESOURCE',					    'REQUIRES_PLOT_CHARMING_APPEAL'),
--    ('HD_PLOT_HAS_CHARMING_WETLANDS_RESOURCE',					    'PLOT_HAS_RESOURCE_REQUIREMENTS'),
    ('HD_PLOT_HAS_BREATHTAKING_WETLANDS_RESOURCE',					'HD_PLOT_HAS_WETLANDS_REQUIREMENTS_MET'),
    ('HD_PLOT_HAS_BREATHTAKING_WETLANDS_RESOURCE',					'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
--    ('HD_PLOT_HAS_BREATHTAKING_WETLANDS_RESOURCE',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),

    ('HD_PLOT_HAS_WATER_RESOURCE',				                    'REQUIRES_PLOT_HAS_COAST'),
    ('HD_PLOT_HAS_WATER_RESOURCE',				                    'PLOT_HAS_RESOURCE_REQUIREMENTS'),

    ('HD_PLOT_CHARMING_UNIQUE_IMPROVEMENT',		                    'REQUIRES_PLOT_CHARMING_APPEAL'),
    ('HD_PLOT_CHARMING_UNIQUE_IMPROVEMENT',		                    'HD_PLOT_HAS_UNIQUE_IMPROVEMENT_MET'),
    ('HD_PLOT_BREATHTAKING_UNIQUE_IMPROVEMENT',		                'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
    ('HD_PLOT_BREATHTAKING_UNIQUE_IMPROVEMENT',		                'HD_PLOT_HAS_UNIQUE_IMPROVEMENT_MET'),
    ('HD_PLOT_CHARMING_WONDER',					                    'REQUIRES_PLOT_CHARMING_APPEAL'),
    ('HD_PLOT_CHARMING_WONDER',					                    'REQUIRES_DISTRICT_IS_DISTRICT_WONDER'),
    ('HD_PLOT_CHARMING_WONDER',					                    'REQUIRES_PLOT_HAS_COMPLETE_WONDER'),
    ('HD_PLOT_BREATHTAKING_WONDER',					                'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
    ('HD_PLOT_BREATHTAKING_WONDER',					                'REQUIRES_DISTRICT_IS_DISTRICT_WONDER'),
    ('HD_PLOT_BREATHTAKING_WONDER',					                'REQUIRES_PLOT_HAS_COMPLETE_WONDER'),

    ('HD_PLAYER_HAS_5_CONSERVATION_DEPARTMENT',					    'REQUIRES_PLAYER_HAS_BUILDING_SANCTUARY'),
    ('HD_PLAYER_HAS_5_CONSERVATION_DEPARTMENT',					    'REQUIRES_PLAYER_HAS_BUILDING_HD_JUNGLE_PRESERVE'),
    ('HD_PLAYER_HAS_5_CONSERVATION_DEPARTMENT',					    'REQUIRES_PLAYER_HAS_BUILDING_HD_WETLANDS_PRESERVE'),
    ('HD_PLAYER_HAS_5_CONSERVATION_DEPARTMENT',					    'REQUIRES_PLAYER_HAS_BUILDING_HD_WATER_PRESERVE'),
    ('HD_PLAYER_HAS_5_CONSERVATION_DEPARTMENT',					    'REQUIRES_PLAYER_HAS_BUILDING_HD_CULTURE_HERITAGE_PRESERVE'),

    
    ('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					            'REQUIRES_PLAYER_HAS_BUILDING_HD_LANDFORM_EPO'),
    ('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					            'REQUIRES_PLAYER_HAS_BUILDING_HD_RESOURCE_EPO'),
    ('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					            'REQUIRES_PLAYER_HAS_BUILDING_HD_SPECIES_EPO'),
    ('HD_PLAYER_HAS_4_PRESERVE_AGENCY',					            'REQUIRES_PLAYER_HAS_BUILDING_HD_SCENIC_EPO'),

    ('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					            'REQUIRES_CITY_HAS_BUILDING_HD_LANDFORM_EPO'),
    ('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					            'REQUIRES_CITY_HAS_BUILDING_HD_RESOURCE_EPO'),
    ('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					            'REQUIRES_CITY_HAS_BUILDING_HD_SCENIC_EPO'),
    ('HD_CITY_HAS_ANY_PRESERVE_AGENCY',					            'REQUIRES_CITY_HAS_BUILDING_HD_SPECIES_EPO');

insert or ignore into RequirementSetRequirements
    (RequirementSetId,                              RequirementId)
select
    'HD_PLOT_HAS_GROVE_FEATURE',                    'HD_REQUIRES_PLOT_HAS_FEATURE_HD_SWAMP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');

insert or ignore into RequirementSetRequirements
    (RequirementSetId,                              RequirementId)
select
    'HD_PLOT_HAS_WETLANDS_REQUIREMENTS',            'HD_REQUIRES_PLOT_HAS_FEATURE_HD_SWAMP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');

insert or ignore into RequirementSetRequirements
    (RequirementSetId,                              RequirementId)
select
    'HD_ON_OR_ADJACENT_WETLANDS',                   'HD_REQUIRES_PLOT_HAS_FEATURE_HD_SWAMP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');

insert or ignore into RequirementSetRequirements
    (RequirementSetId,                              RequirementId)
select
    'HD_ON_OR_ADJACENT_WETLANDS',                   'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_HD_SWAMP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_PLOT_HAS_GROVE_NATURAL_WONDER',                             'HD_REQUIRES_PLOT_HAS_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type not in ('SEA','LAKE');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_PLOT_ADJACENT_TO_MOUNTAIN_NATURAL_WONDERS',                 'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type = 'MOUNTAIN';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_PLOT_HAS_SEA_NATURAL_WONDER',                               'HD_REQUIRES_PLOT_HAS_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type in ('SEA','LAKE');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_PLOT_HAS_FOREST_NATURAL_WONDER',                            'HD_REQUIRES_PLOT_HAS_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type = 'FOREST';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_PLOT_HAS_JUNGLE_NATURAL_WONDER',                            'HD_REQUIRES_PLOT_HAS_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type = 'JUNGLE';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_PLOT_HAS_WETLANDS_NATURAL_WONDER',                          'HD_REQUIRES_PLOT_HAS_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type = 'WETLANDS';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_ON_OR_ADJACENT_FOREST',                                     'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type = 'FOREST';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_ON_OR_ADJACENT_JUNGLE',                                     'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type = 'JUNGLE';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_ON_OR_ADJACENT_WETLANDS',                                   'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type = 'WETLANDS';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_ON_OR_ADJACENT_WATER',                                      'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType
from HD_NATURAL_WONDERS_TYPE where Type in ('SEA','LAKE');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_PLOT_HAS_UNIQUE_IMPROVEMENT',                              'REQUIRES_PLOT_HAS_' || ImprovementType
from Improvements where (TraitType is not null and TraitType not in ('TRAIT_BARBARIAN','TRAIT_CIVILIZATION_NO_PLAYER'));

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
    'HD_ADJACENT_UI_OR_WONDER',                                     'REQUIRES_PLOT_ADJACENT_TO_' || ImprovementType
from Improvements where (TraitType is not null and TraitType not in ('TRAIT_BARBARIAN','TRAIT_CIVILIZATION_NO_PLAYER'));

-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,												RequirementId)
-- select
--     'HD_PLAYER_HAS_ALL_FEATURES',                                   'REQUIRES_PLAYER_HAS_' || FeatureType
-- from Features where FeatureType not in ('FEATURE_BURNING_FOREST','FEATURE_BURNT_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;

-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,												RequirementId)
-- select
--     'HD_PLAYER_HAS_ALL_NATURAL_WONDER',                             'REQUIRES_PLAYER_HAS_' || FeatureType || '_OR_MAP_NOT_HAS'
-- from Features where NaturalWonder = 1;

-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,												RequirementId)
-- select
--     'HD_PLAYER_GOT_ALL_ORE_RESOURCE_ON_MAP',                        'REQUIRES_PLAYER_HAS_' || ResourceType || '_OR_MAP_NOT_HAS'
-- from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER';

-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,												RequirementId)
-- select
--     'HD_PLAYER_GOT_ALL_BIO_RESOURCE_ON_MAP',                        'REQUIRES_PLAYER_HAS_' || ResourceType || '_OR_MAP_NOT_HAS'
-- from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL');

update Modifiers set SubjectRequirementSetId = 'HD_PLOT_HAS_CHARMING_SANCTUARY_FEATURE' where ModifierId = 'HD_SANCTUARY_PLOT_CHARMING_BONUS'
and exists (select FeatureType from Features where FeatureType = 'FEATURE_JNR_SAVANNAH');
update Modifiers set SubjectRequirementSetId = 'HD_PLOT_HAS_BREATHTAKING_SANCTUARY_FEATURE' where ModifierId = 'HD_SANCTUARY_PLOT_BREATHTAKING_BONUS'
and exists (select FeatureType from Features where FeatureType = 'FEATURE_JNR_SAVANNAH');

-- Dummy Modifiers for lua script to check the collection progress
-- create table if not exists HD_PreserveCollectionProgress (
-- 	BuildingType text not null,
-- 	ObjectType text not null,
-- 	CollectedRequirementSetId text not null,
-- 	NotInMapRequirementSetId text,
-- 	NotInMapPropertyKey text,
-- 	ObjectName text not null,
-- 	CollectedModifierId text,
-- 	NotInMapModifierId text,
-- 	PrereqTech text,
-- 	PrereqCivic text,
-- 	primary key (BuildingType, ObjectType)
-- );
-- -- 地貌
-- insert or replace into HD_PreserveCollectionProgress
-- 	(BuildingType,					ObjectType,		ObjectName,	 CollectedRequirementSetId)
-- select
-- 	'BUILDING_HD_LANDFORM_EPO',		FeatureType,	Name,		'HD_PLAYER_HAS_' || FeatureType
-- from Features where FeatureType not in ('FEATURE_BURNING_FOREST', 'FEATURE_BURNT_FOREST', 'FEATURE_BURNING_JUNGLE', 'FEATURE_BURNT_JUNGLE', 'FEATURE_JNR_BURNING_SAVANNAH', 'FEATURE_JNR_BURNT_SAVANNAH') and NaturalWonder = 0;
-- -- 资源
-- insert or replace into HD_PreserveCollectionProgress
-- 	(BuildingType,					ObjectType,		ObjectName,	 CollectedRequirementSetId,										NotInMapPropertyKey)
-- select
-- 	'BUILDING_HD_RESOURCE_EPO',		ResourceType,	Name,		'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS',	'HD_MAP_HAS_' || ResourceType
-- from Resources where ResourceType in (select ResourceType from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY','IMPROVEMENT_OIL_WELL') and ResourceType != 'RESOURCE_AMBER');
-- -- 物种
-- insert or replace into HD_PreserveCollectionProgress
-- 	(BuildingType,					ObjectType,		ObjectName,	 CollectedRequirementSetId,										NotInMapPropertyKey)
-- select
-- 	'BUILDING_HD_SPECIES_EPO',		ResourceType,	Name,		'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS',	'HD_MAP_HAS_' || ResourceType
-- from Resources where ResourceType in (select ResourceType from Improvement_ValidResources where ImprovementType in ('IMPROVEMENT_FARM','IMPROVEMENT_FISHING_BOATS','IMPROVEMENT_PLANTATION','IMPROVEMENT_PASTURE','IMPROVEMENT_CAMP','IMPROVEMENT_LUMBER_MILL'));
-- -- 奇观
-- insert or replace into HD_PreserveCollectionProgress
-- 	(BuildingType,					ObjectType,		ObjectName,	 CollectedRequirementSetId,			NotInMapRequirementSetId)
-- select
-- 	'BUILDING_HD_SCENIC_EPO',		FeatureType,	Name,		'HD_PLAYER_HAS_' || FeatureType,	'MAP_NOT_HAS_' || FeatureType || '_REQUIREMENTS'
-- from Features where NaturalWonder = 1;
-- -- Name Modifier
-- update HD_PreserveCollectionProgress set CollectedModifierId = CollectedRequirementSetId || '_DUMMY_MODIFIER';
-- update HD_PreserveCollectionProgress set NotInMapModifierId = NotInMapRequirementSetId || '_DUMMY_MODIFIER' where NotInMapRequirementSetId is not null;
-- -- Update Prereq
-- update HD_PreserveCollectionProgress set PrereqTech = (select PrereqTech from Buildings b where b.BuildingType = HD_PreserveCollectionProgress.BuildingType);
-- update HD_PreserveCollectionProgress set PrereqCivic = (select PrereqCivic from Buildings b where b.BuildingType = HD_PreserveCollectionProgress.BuildingType);
-- insert or ignore into TechnologyModifiers
-- 	(TechnologyType,	ModifierId)
-- select
-- 	PrereqTech, 		CollectedModifierId
-- from HD_PreserveCollectionProgress where PrereqTech is not null;
-- insert or ignore into CivicModifiers
-- 	(CivicType,			ModifierId)
-- select
-- 	PrereqCivic, 		CollectedModifierId
-- from HD_PreserveCollectionProgress where PrereqCivic is not null;
-- insert or ignore into Modifiers
-- 	(ModifierId,				ModifierType,			OwnerRequirementSetId)
-- select
-- 	CollectedModifierId,		'MODIFIER_DO_NOTHING',	CollectedRequirementSetId
-- from HD_PreserveCollectionProgress;
-- insert or ignore into GameModifiers
-- 	(ModifierId)
-- select
-- 	NotInMapModifierId
-- from HD_PreserveCollectionProgress where NotInMapRequirementSetId is not null;
-- insert or ignore into Modifiers
-- 	(ModifierId,				ModifierType,			OwnerRequirementSetId)
-- select
-- 	NotInMapModifierId,			'MODIFIER_DO_NOTHING',	NotInMapRequirementSetId
-- from HD_PreserveCollectionProgress where NotInMapRequirementSetId is not null;

--update Buildings set InternalOnly = 1 where BuildingType = 'BUILDING_HD_RESOURCE_EPO' or BuildingType = 'BUILDING_HD_SPECIES_EPO';

-- 收集5种保护部奖励1总督头衔
insert or replace into GameModifiers (ModifierId) values
    ('HD_5_CONSERVATION_DEPARTMENT_AWARD_GOVERNOR');

insert or replace into TraitModifiers
    (TraitType,          ModifierId)
values
    ('TRAIT_LEADER_MAJOR_CIV',     'HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT1'),
    ('TRAIT_LEADER_MAJOR_CIV',     'HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT2'),
    ('TRAIT_LEADER_MAJOR_CIV',     'HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT3'),
    ('TRAIT_LEADER_MAJOR_CIV',     'HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT4');

insert or replace into Modifiers
    (ModifierId,                                        ModifierType,                                                   SubjectRequirementSetId,                    RunOnce,Permanent,SubjectStackLimit)
values
    ('HD_5_CONSERVATION_DEPARTMENT_AWARD_GOVERNOR',     'MODIFIER_ALL_PLAYERS_ADJUST_GOVERNOR_POINTS',                  'HD_PLAYER_HAS_5_CONSERVATION_DEPARTMENT',  1,      1,        1),
    ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT1',     'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER',     'HD_PLAYER_HAS_4_PRESERVE_AGENCY',          1,      1,        1),
    ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT2',     'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER',     'HD_PLAYER_HAS_4_PRESERVE_AGENCY',          1,      1,        1),
    ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT3',     'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER',     'HD_PLAYER_HAS_4_PRESERVE_AGENCY',          1,      1,        1),
    ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT4',     'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER',     'HD_PLAYER_HAS_4_PRESERVE_AGENCY',          1,      1,        1);

insert or replace into ModifierArguments
	(ModifierId,									  Name,			            Value)
values
   ('HD_5_CONSERVATION_DEPARTMENT_AWARD_GOVERNOR',    'Delta',                  1),
   ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT1',    'GovernmentSlotType',     'SLOT_MILITARY'),
   ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT1',    'Amount',                 1),
   ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT2',    'GovernmentSlotType',     'SLOT_ECONOMIC'),
   ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT2',    'Amount',                 1),
   ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT3',    'GovernmentSlotType',     'SLOT_DIPLOMATIC'),
   ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT3',    'Amount',                 1),
   ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT4',    'GovernmentSlotType',     'SLOT_WILDCARD'),
   ('HD_4_PRESERVE_AGENCY_AWARD_GOVERNMENT_SLOT4',    'Amount',                 1);

insert or replace into ObsoletePolicies
	(PolicyType,					    ObsoletePolicy)
values
	('POLICY_HD_BIOSYSTEMATICS',		'POLICY_HD_HARMONIOUS_COEXISTENCE');