-- ============================================================================================================================================================
-- 二进制 Key
-- ============================================================================================================================================================
insert or replace into HD_Binary_Compress_Keys (Key, MaxExp) values
	('HD_PLOT_BINARY_COMPRESS_GOVERNOR_EDUCATOR_LEFT_2',                    4),
	('HD_PLOT_BINARY_COMPRESS_GOVERNOR_EDUCATOR_RIGHT_3',                   5),
	('HD_PLOT_BINARY_COMPRESS_GOVERNOR_BUILDER_RIGHT_3',                    5),
	('HD_PLOT_BINARY_COMPRESS_GOVERNOR_MERCHANT_RIGHT_3_YIELD_FOOD',        11),
	('HD_PLOT_BINARY_COMPRESS_GOVERNOR_MERCHANT_RIGHT_3_YIELD_PRODUCTION',  11),
	('HD_PLOT_BINARY_COMPRESS_GOVERNOR_MERCHANT_RIGHT_3_YIELD_SCIENCE',     11),
	('HD_PLOT_BINARY_COMPRESS_GOVERNOR_MERCHANT_RIGHT_3_YIELD_CULTURE',     11),
	('HD_PLOT_BINARY_COMPRESS_GOVERNOR_MERCHANT_RIGHT_3_YIELD_GOLD',        14),
	('HD_PLOT_BINARY_COMPRESS_GOVERNOR_MERCHANT_RIGHT_3_YIELD_FAITH',       11);

-- ============================================================================================================================================================
-- 全局参数
-- ============================================================================================================================================================
insert or replace into GlobalParameters (Name, Value) values
  ('HD_GOVERNOR_BUILDER_RIGHT_1_WONDER_ENGINEER_PERCENTAGE',              25),
  ('HD_GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_BASE',            25),
  ('HD_GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_PER_TRADINGPOST', 3),
  ('HD_GOVERNOR_CARDINAL_RIGHT_2_RELIGIOUS_PRESSURE',                     150),
  ('HD_GOVERNOR_CARDINAL_RIGHT_2_RELIGIOUS_DISTANCE',                     6),
  ('HD_GOVERNOR_CARDINAL_RIGHT_3_FAITH_PERCENTAGE',                       200),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_2_ENVOY_NUM',                            1);

-- ============================================================================================================================================================
-- 所有总督基础能力
-- ============================================================================================================================================================
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_' || Tag || '_BASE', 'REINFORCED_INFRASTRUCTURE_PREVENET_STRUCTURAL_DAMAGE'
from HD_Governors_Need_Reset;
update Modifiers set OwnerRequirementSetId = 'PLAYER_HAS_TECH_ENGINEERING_REQUIREMENTS' where ModifierId = 'REINFORCED_INFRASTRUCTURE_PREVENET_STRUCTURAL_DAMAGE';

-- ============================================================================================================================================================
-- 平伽拉
-- ============================================================================================================================================================
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) values
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_BASE',     'HD_GOVERNOR_EDUCATOR_BASE_POP_SCIENCE'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_BASE',     'HD_GOVERNOR_EDUCATOR_BASE_POP_CULTURE'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_LEFT_1',   'HD_GOVERNOR_EDUCATOR_LEFT_1_GPP_BONUS'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_1',  'HD_GOVERNOR_EDUCATOR_RIGHT_1_CAMPUS_ADJACENCY_BONUS'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_1',  'HD_GOVERNOR_EDUCATOR_RIGHT_1_THEATER_ADJACENCY_BONUS'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_2',  'HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_SCIENCE'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_2',  'HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_CULTURE'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_2',  'HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_SCIENCE'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_2',  'HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_CULTURE'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_2',  'HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_REGIONAL_RANGE'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_2',  'HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_REGIONAL_RANGE'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_3',  'HD_GOVERNOR_EDUCATOR_RIGHT_3_CITY_YIELDS'),
  ('GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_3',  'HD_GOVERNOR_EDUCATOR_RIGHT_3_SPACE_RACE');

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
  ('HD_GOVERNOR_EDUCATOR_BASE_POP_SCIENCE',                             'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',                NULL),
  ('HD_GOVERNOR_EDUCATOR_BASE_POP_CULTURE',                             'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',                NULL),
  ('HD_GOVERNOR_EDUCATOR_LEFT_1_GPP_BONUS',                             'MODIFIER_CITY_INCREASE_GREAT_PERSON_POINT_BONUS',                      NULL),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_1_CAMPUS_ADJACENCY_BONUS',               'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',                        'DISTRICT_IS_CAMPUS'),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_1_THEATER_ADJACENCY_BONUS',              'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',                        'DISTRICT_IS_THEATER'),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_SCIENCE',        'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',    NULL),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_CULTURE',        'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',    NULL),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_SCIENCE',       'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',    NULL),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_CULTURE',       'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',    NULL),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_REGIONAL_RANGE',       'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',                                 NULL),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_REGIONAL_RANGE',      'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',                                 NULL),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_3_CITY_YIELDS',                          'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',                      NULL),
  ('HD_GOVERNOR_EDUCATOR_RIGHT_3_SPACE_RACE',                           'MODIFIER_SINGLE_CITY_ADJUST_SPACE_RACE_PROJECTS_PRODUCTION',           NULL);

insert or ignore into ModifierArguments (ModifierId, Name, Value) values
	('HD_GOVERNOR_EDUCATOR_BASE_POP_SCIENCE',                             'YieldType',      'YIELD_SCIENCE'),
	('HD_GOVERNOR_EDUCATOR_BASE_POP_SCIENCE',                             'Amount',         0.8),
	('HD_GOVERNOR_EDUCATOR_BASE_POP_CULTURE',                             'YieldType',      'YIELD_CULTURE'),
	('HD_GOVERNOR_EDUCATOR_BASE_POP_CULTURE',                             'Amount',         0.8),
	('HD_GOVERNOR_EDUCATOR_LEFT_1_GPP_BONUS',                             'Amount',         100),
	('HD_GOVERNOR_EDUCATOR_RIGHT_1_CAMPUS_ADJACENCY_BONUS',			          'YieldType',			'YIELD_SCIENCE'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_1_CAMPUS_ADJACENCY_BONUS',			          'Amount',					100),
	('HD_GOVERNOR_EDUCATOR_RIGHT_1_THEATER_ADJACENCY_BONUS',			        'YieldType',			'YIELD_CULTURE'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_1_THEATER_ADJACENCY_BONUS',			        'Amount',					100),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_SCIENCE',		    'DistrictType',		'DISTRICT_CAMPUS'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_SCIENCE',		    'YieldType',			'YIELD_SCIENCE'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_SCIENCE',		    'Amount',					100),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_CULTURE',		    'DistrictType',		'DISTRICT_CAMPUS'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_CULTURE',		    'YieldType',			'YIELD_CULTURE'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_BONUS_CULTURE',		    'Amount',					100),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_SCIENCE',		    'DistrictType',		'DISTRICT_THEATER'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_SCIENCE',		    'YieldType',			'YIELD_SCIENCE'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_SCIENCE',		    'Amount',					100),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_CULTURE',		    'DistrictType',		'DISTRICT_THEATER'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_CULTURE',		    'YieldType',			'YIELD_CULTURE'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_BONUS_CULTURE',		    'Amount',					100),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_REGIONAL_RANGE',		    'Key',			      'HD_SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_DISTRICT_CAMPUS'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_CAMPUS_BUILDING_REGIONAL_RANGE',		    'Amount',					1),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_REGIONAL_RANGE',	    'Key',			      'HD_SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_DISTRICT_THEATER'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_2_THEATER_BUILDING_REGIONAL_RANGE',	    'Amount',					1),
	('HD_GOVERNOR_EDUCATOR_RIGHT_3_CITY_YIELDS',		                      'YieldType',			'YIELD_SCIENCE'),
	('HD_GOVERNOR_EDUCATOR_RIGHT_3_CITY_YIELDS',		                      'Amount',					25),
	('HD_GOVERNOR_EDUCATOR_RIGHT_3_SPACE_RACE',		                        'Amount',					30);

-- 典籍研读会
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_EDUCATOR_LEFT_2', 'HD_GOVERNOR_EDUCATOR_LEFT_2_' || DistrictType || '_' || Exp
from DistrictCorrespondingYieldType_HD, HD_Binary_Compress where Exp < 5 and DistrictType in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) select
  'HD_GOVERNOR_EDUCATOR_LEFT_2_' || DistrictType || '_' || Exp,
  'MODIFIER_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE',
  'HD_PLOT_BINARY_COMPRESS_GOVERNOR_EDUCATOR_LEFT_2_' || Exp || '_REQUIREMENTS',
  'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET'
from DistrictCorrespondingYieldType_HD, HD_Binary_Compress where Exp < 5 and DistrictType in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_EDUCATOR_LEFT_2_' || DistrictType || '_' || Exp, 'YieldType', YieldType
from DistrictCorrespondingYieldType_HD, HD_Binary_Compress where Exp < 5 and DistrictType in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_EDUCATOR_LEFT_2_' || DistrictType || '_' || Exp, 'Amount', HD_Binary_Compress.Amount
from DistrictCorrespondingYieldType_HD, HD_Binary_Compress where Exp < 5 and DistrictType in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');

-- 皇家博物馆
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_EDUCATOR_LEFT_3', 'HD_GOVERNOR_EDUCATOR_LEFT_3_' || GreatWorkObjectType || '_TOURISM'
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_ARTIFACT', 'GREATWORKOBJECT_WRITING', 'GREATWORKOBJECT_MUSIC');

insert or ignore into Modifiers (ModifierId, ModifierType) select
  'HD_GOVERNOR_EDUCATOR_LEFT_3_' || GreatWorkObjectType || '_TOURISM', 'MODIFIER_SINGLE_CITY_ADJUST_TOURISM'
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_ARTIFACT', 'GREATWORKOBJECT_WRITING', 'GREATWORKOBJECT_MUSIC');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_EDUCATOR_LEFT_3_' || GreatWorkObjectType || '_TOURISM', 'GreatWorkObjectType', GreatWorkObjectType
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_ARTIFACT', 'GREATWORKOBJECT_WRITING', 'GREATWORKOBJECT_MUSIC');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_EDUCATOR_LEFT_3_' || GreatWorkObjectType || '_TOURISM', 'ScalingFactor', 300
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS', 'GREATWORKOBJECT_ARTIFACT', 'GREATWORKOBJECT_WRITING', 'GREATWORKOBJECT_MUSIC');

-- 贵族书院
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
	'GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_2', 'HD_GOVERNOR_EDUCATOR_RIGHT_2_' || DistrictType || '_REGIONAL_' || YieldType
from Yields, Districts where YieldType in ('YIELD_SCIENCE', 'YIELD_CULTURE') and DistrictType in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');

insert or ignore into Modifiers (ModifierId, ModifierType) select
	'HD_GOVERNOR_EDUCATOR_RIGHT_2_' || DistrictType || '_REGIONAL_' || YieldType, 'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY'
from Yields, Districts where YieldType in ('YIELD_SCIENCE', 'YIELD_CULTURE') and DistrictType in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_GOVERNOR_EDUCATOR_RIGHT_2_' || DistrictType || '_REGIONAL_' || YieldType, 'Key', 'HD_SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_' || DistrictType || '_' || YieldType
from Yields, Districts where YieldType in ('YIELD_SCIENCE', 'YIELD_CULTURE') and DistrictType in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_GOVERNOR_EDUCATOR_RIGHT_2_' || DistrictType || '_REGIONAL_' || YieldType, 'Amount', 50
from Yields, Districts where YieldType in ('YIELD_SCIENCE', 'YIELD_CULTURE') and DistrictType in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER');

-- 国家科学院
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_3', 'HD_GOVERNOR_EDUCATOR_RIGHT_3_CITY_YIELDS_' || Exp
from HD_Binary_Compress where Exp < 6;

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_GOVERNOR_EDUCATOR_RIGHT_3_CITY_YIELDS_' || Exp, 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER', 'HD_PLOT_BINARY_COMPRESS_GOVERNOR_EDUCATOR_RIGHT_3_' || Exp || '_REQUIREMENTS'
from HD_Binary_Compress where Exp < 6;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_EDUCATOR_RIGHT_3_CITY_YIELDS_' || Exp, 'YieldType', 'YIELD_SCIENCE'
from HD_Binary_Compress where Exp < 6;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_EDUCATOR_RIGHT_3_CITY_YIELDS_' || Exp, 'Amount', Amount * 5
from HD_Binary_Compress where Exp < 6;

-- ============================================================================================================================================================
-- 维克多
-- ============================================================================================================================================================
update Governors set TransitionStrength = 250 where GovernorType = 'GOVERNOR_THE_DEFENDER';

insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) values
  ('GOVERNOR_PROMOTION_HD_DEFENDER_BASE',     'HD_GOVERNOR_DEFENDER_BASE_POP_PRODUCTION'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_BASE',     'HD_GOVERNOR_DEFENDER_BASE_UNIT_PRODUCTION'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_BASE',     'HD_GOVERNOR_DEFENDER_BASE_GENERAL_POINTS'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_BASE',     'HD_GOVERNOR_DEFENDER_BASE_ADMIRAL_POINTS'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_LEFT_1',   'HD_GOVERNOR_DEFENDER_LEFT_1_SIEGE_PROTECTION'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_LEFT_1',   'HD_GOVERNOR_DEFENDER_LEFT_1_UNIT_HEAL'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_LEFT_1',   'HD_GOVERNOR_DEFENDER_LEFT_1_STRATEGIC_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_LEFT_1',   'HD_GOVERNOR_DEFENDER_LEFT_1_UNIT_STRENGTH'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_LEFT_2',   'HD_GOVERNOR_DEFENDER_LEFT_2_UNIT_ABILITY'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_LEFT_3',   'HD_GOVERNOR_DEFENDER_LEFT_3_FREE_PROMOTION'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_LEFT_3',   'HD_GOVERNOR_DEFENDER_LEFT_3_FREE_UNIT'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_RIGHT_1',  'HD_GOVERNOR_DEFENDER_RIGHT_1_ENCAMPMENT_ADJACENCY'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_RIGHT_1',  'HD_GOVERNOR_DEFENDER_RIGHT_1_STRATEGIC_YIELDS'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_RIGHT_1',  'HD_GOVERNOR_DEFENDER_RIGHT_1_STRATEGIC_ACCUMULATION'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_RIGHT_2',  'HD_GOVERNOR_DEFENDER_RIGHT_2_SUPPORT_MOVEMENT'),
  ('GOVERNOR_PROMOTION_HD_DEFENDER_RIGHT_2',  'HD_GOVERNOR_DEFENDER_RIGHT_2_MILITARY_ENGINEERING_ABILITY');

insert or ignore into Modifiers (ModifierId, ModifierType, Permanent, SubjectRequirementSetId) values
  ('HD_GOVERNOR_DEFENDER_BASE_POP_PRODUCTION',                          'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',                0,  NULL),
  ('HD_GOVERNOR_DEFENDER_BASE_UNIT_PRODUCTION',                         'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION_MODIFIER',                 0,  NULL),
  ('HD_GOVERNOR_DEFENDER_BASE_GENERAL_POINTS',                          'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',            0,  'REQUIRES_DISTRICT_IS_DISTRICT_CITY_CENTER_UDMET'),
  ('HD_GOVERNOR_DEFENDER_BASE_ADMIRAL_POINTS',                          'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',            0,  'REQUIRES_DISTRICT_IS_DISTRICT_CITY_CENTER_UDMET'),
  ('HD_GOVERNOR_DEFENDER_LEFT_1_SIEGE_PROTECTION',                      'MODIFIER_CITY_ADJUST_SIEGE_PROTECTION',                                0,  NULL),
  ('HD_GOVERNOR_DEFENDER_LEFT_1_UNIT_HEAL',                             'MODIFIER_PLAYER_UNITS_ADJUST_HEAL_PER_TURN',                           0,  'OBJECT_IS_AT_OR_ADJACENT'),
  ('HD_GOVERNOR_DEFENDER_LEFT_1_STRATEGIC_DISCOUNT',                    'MODIFIER_CITY_ADJUST_STRATEGIC_RESOURCE_REQUIREMENT_MODIFIER',         0,  NULL),
  ('HD_GOVERNOR_DEFENDER_LEFT_1_UNIT_STRENGTH',                         'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',                 1,  NULL),
  ('HD_GOVERNOR_DEFENDER_LEFT_2_UNIT_ABILITY',                          'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',                                  0,  'HD_OBJECT_WITHIN_9_TILES'),
  ('HD_GOVERNOR_DEFENDER_LEFT_3_FREE_PROMOTION',                        'MODIFIER_CITY_TRAINED_UNITS_ADJUST_GRANT_EXPERIENCE',                  0,  'HD_UNIT_IS_MILITARY_REQUIREMENTS'),
  ('HD_GOVERNOR_DEFENDER_LEFT_3_FREE_UNIT',                             'MODIFIER_SINGLE_CITY_ADJUST_EXTRA_UNIT_COPY_TAG',                      0,  NULL),
  ('HD_GOVERNOR_DEFENDER_RIGHT_1_ENCAMPMENT_ADJACENCY',                 'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',                        0,  'DISTRICT_IS_ENCAMPMENT'),
  ('HD_GOVERNOR_DEFENDER_RIGHT_1_STRATEGIC_YIELDS',                     'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',                          0,  'PLOT_HAS_STRATEGIC_IMPROVED_REQUIREMENTS'),
  ('HD_GOVERNOR_DEFENDER_RIGHT_1_STRATEGIC_ACCUMULATION',               'MODIFIER_SINGLE_CITY_ADJUST_EXTRA_ACCUMULATION',                       0,  NULL),
  ('HD_GOVERNOR_DEFENDER_RIGHT_2_SUPPORT_MOVEMENT',                     'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',                 1,  NULL),
  ('HD_GOVERNOR_DEFENDER_RIGHT_2_MILITARY_ENGINEERING_ABILITY',         'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',                 1,  NULL);

insert or ignore into ModifierArguments (ModifierId, Name, Value) values
	('HD_GOVERNOR_DEFENDER_BASE_POP_PRODUCTION',                          'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_DEFENDER_BASE_POP_PRODUCTION',                          'Amount',                 0.8),
	('HD_GOVERNOR_DEFENDER_BASE_UNIT_PRODUCTION',                         'Amount',                 30),
	('HD_GOVERNOR_DEFENDER_BASE_GENERAL_POINTS',                          'GreatPersonClassType',   'GREAT_PERSON_CLASS_GENERAL'),
	('HD_GOVERNOR_DEFENDER_BASE_GENERAL_POINTS',                          'Amount',                 4),
	('HD_GOVERNOR_DEFENDER_BASE_ADMIRAL_POINTS',                          'GreatPersonClassType',   'GREAT_PERSON_CLASS_ADMIRAL'),
	('HD_GOVERNOR_DEFENDER_BASE_ADMIRAL_POINTS',                          'Amount',                 4),
	('HD_GOVERNOR_DEFENDER_LEFT_1_SIEGE_PROTECTION',                      'Protected',              1),
	('HD_GOVERNOR_DEFENDER_LEFT_1_UNIT_HEAL',                             'Amount',                 100),
	('HD_GOVERNOR_DEFENDER_LEFT_1_UNIT_HEAL',                             'Type',                   'FRIENDLY'),
	('HD_GOVERNOR_DEFENDER_LEFT_1_STRATEGIC_DISCOUNT',                    'Amount',                 80),
	('HD_GOVERNOR_DEFENDER_LEFT_1_UNIT_STRENGTH',                         'AbilityType',            'ABILITY_HD_GOVERNOR_DEFENDER_LEFT_1_UNIT_STRENGTH'),
	('HD_GOVERNOR_DEFENDER_LEFT_2_UNIT_ABILITY',                          'AbilityType',            'ABILITY_HD_GOVERNOR_DEFENDER_LEFT_2_UNIT_ABILITY'),
	('HD_GOVERNOR_DEFENDER_LEFT_3_FREE_PROMOTION',                        'Amount',                 -1),
	('HD_GOVERNOR_DEFENDER_LEFT_3_FREE_UNIT',                             'Tag',                    'CLASS_MILITARY'),
	('HD_GOVERNOR_DEFENDER_LEFT_3_FREE_UNIT',                             'Amount',                 1),
	('HD_GOVERNOR_DEFENDER_RIGHT_1_ENCAMPMENT_ADJACENCY',                 'YieldType',             'YIELD_PRODUCTION'),
	('HD_GOVERNOR_DEFENDER_RIGHT_1_ENCAMPMENT_ADJACENCY',                 'Amount',                 100),
	('HD_GOVERNOR_DEFENDER_RIGHT_1_STRATEGIC_YIELDS',                     'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_DEFENDER_RIGHT_1_STRATEGIC_YIELDS',                     'Amount',                 1),
	('HD_GOVERNOR_DEFENDER_RIGHT_1_STRATEGIC_ACCUMULATION',               'Amount',                 4),
	('HD_GOVERNOR_DEFENDER_RIGHT_2_SUPPORT_MOVEMENT',                     'AbilityType',            'ABILITY_HD_GOVERNOR_DEFENDER_RIGHT_2_SUPPORT_MOVEMENT'),
	('HD_GOVERNOR_DEFENDER_RIGHT_2_MILITARY_ENGINEERING_ABILITY',         'AbilityType',            'ABILITY_HD_GOVERNOR_DEFENDER_RIGHT_2_MILITARY_ENGINEERING_ABILITY');

-- 军备研究部
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_DEFENDER_RIGHT_3', 'HD_GOVERNOR_DEFENDER_RIGHT_3_' || ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_GOVERNOR_DEFENDER_RIGHT_3_' || ResourceType, 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIREMENTS'
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_DEFENDER_RIGHT_3_' || ResourceType, 'YieldType', 'YIELD_PRODUCTION, YIELD_SCIENCE'
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_DEFENDER_RIGHT_3_' || ResourceType, 'Amount', '7, 7'
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

-- ============================================================================================================================================================
-- 梁
-- ============================================================================================================================================================
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) values
  ('GOVERNOR_PROMOTION_HD_BUILDER_BASE',     'HD_GOVERNOR_BUILDER_BASE_BUILDER_ABILITY'),
  ('GOVERNOR_PROMOTION_HD_BUILDER_LEFT_1',   'HD_GOVERNOR_BUILDER_LEFT_1_IMPROVEMENT_YIELDS'),
  ('GOVERNOR_PROMOTION_HD_BUILDER_LEFT_1',   'HD_GOVERNOR_BUILDER_LEFT_1_AGRICULTURAL_IMPROVEMENT_YIELDS'),
  ('GOVERNOR_PROMOTION_HD_BUILDER_LEFT_3',   'HD_GOVERNOR_BUILDER_LEFT_3_ALLOW_EXTRA_CITY_PARK'),
  ('GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_1',  'HD_GOVERNOR_BUILDER_RIGHT_1_WONDER_BOOST'),
  ('GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_2',  'HD_GOVERNOR_BUILDER_RIGHT_2_DISTRICT_PRODUCTION'),
  ('GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_2',  'HD_GOVERNOR_BUILDER_RIGHT_2_WONDER_PRODUCTION'),
  ('GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_2',  'HD_GOVERNOR_BUILDER_RIGHT_2_WONDER_CULTURE'),
  ('GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_3',  'HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_REGIONAL_RANGE');

insert or ignore into Modifiers (ModifierId, ModifierType, Permanent, SubjectRequirementSetId) values
  ('HD_GOVERNOR_BUILDER_BASE_BUILDER_ABILITY',                          'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',                 1,  NULL),
  ('HD_GOVERNOR_BUILDER_LEFT_1_IMPROVEMENT_YIELDS',                     'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',                          0,  'PLOT_IS_IMPROVED'),
  ('HD_GOVERNOR_BUILDER_LEFT_1_AGRICULTURAL_IMPROVEMENT_YIELDS',        'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',                          0,  'PLOT_HAS_IMPROVEMENT_CLASSIFICATION_AGRARIAN_REQUIREMENTS'),
  ('HD_GOVERNOR_BUILDER_LEFT_3_ALLOW_EXTRA_CITY_PARK',                  'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',                                 0,  NULL),
  ('HD_GOVERNOR_BUILDER_RIGHT_1_WONDER_BOOST',                          'MODIFIER_SINGLE_CITY_ADJUST_WONDER_PRODUCTION',                        0,  NULL),
  ('HD_GOVERNOR_BUILDER_RIGHT_2_DISTRICT_PRODUCTION',                   'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',                          0,  'DISTRICT_IS_NOT_WONDER_REQUIREMENTS'),
  ('HD_GOVERNOR_BUILDER_RIGHT_2_WONDER_PRODUCTION',                     'MODIFIER_SINGLE_CITY_ADJUST_WONDER_YIELD_CHANGE',                      0,  NULL),
  ('HD_GOVERNOR_BUILDER_RIGHT_2_WONDER_CULTURE',                        'MODIFIER_SINGLE_CITY_ADJUST_WONDER_YIELD_CHANGE',                      0,  NULL),
  ('HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_REGIONAL_RANGE',                 'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',                                 0,  NULL);

insert or ignore into ModifierArguments (ModifierId, Name, Value) values
	('HD_GOVERNOR_BUILDER_BASE_BUILDER_ABILITY',                          'AbilityType',            'ABILITY_HD_GOVERNOR_BUILDER_BASE_BUILDER_ABILITY'),
	('HD_GOVERNOR_BUILDER_LEFT_1_IMPROVEMENT_YIELDS',                     'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_BUILDER_LEFT_1_IMPROVEMENT_YIELDS',                     'Amount',                 1),
	('HD_GOVERNOR_BUILDER_LEFT_1_AGRICULTURAL_IMPROVEMENT_YIELDS',        'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_BUILDER_LEFT_1_AGRICULTURAL_IMPROVEMENT_YIELDS',        'Amount',                 1),
	('HD_GOVERNOR_BUILDER_LEFT_3_ALLOW_EXTRA_CITY_PARK',                  'Key',                    'HD_CITY_ALLOW_EXTRA_IMPROVEMENT_CITY_PARK'),
	('HD_GOVERNOR_BUILDER_LEFT_3_ALLOW_EXTRA_CITY_PARK',                  'Amount',                 1),
	('HD_GOVERNOR_BUILDER_RIGHT_1_WONDER_BOOST',                          'Amount',                 20),
	('HD_GOVERNOR_BUILDER_RIGHT_2_DISTRICT_PRODUCTION',                   'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_BUILDER_RIGHT_2_DISTRICT_PRODUCTION',                   'Amount',                 1),
	('HD_GOVERNOR_BUILDER_RIGHT_2_WONDER_PRODUCTION',                     'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_BUILDER_RIGHT_2_WONDER_PRODUCTION',                     'Amount',                 1),
	('HD_GOVERNOR_BUILDER_RIGHT_2_WONDER_CULTURE',                        'YieldType',              'YIELD_CULTURE'),
	('HD_GOVERNOR_BUILDER_RIGHT_2_WONDER_CULTURE',                        'Amount',                 1),
	('HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_REGIONAL_RANGE',		              'Key',			              'HD_SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_DISTRICT_WONDER'),
	('HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_REGIONAL_RANGE',		              'Amount',					        1);

-- 卫星城区
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_BUILDER_LEFT_2', 'HD_GOVERNOR_BUILDER_LEFT_2_' || DistrictType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
  'HD_GOVERNOR_BUILDER_LEFT_2_' || DistrictType, 'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER', 'DISTRICT_IS_' || DistrictType || '_WITHIN_6_TILES_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_LEFT_2_' || DistrictType, 'YieldType', YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_LEFT_2_' || DistrictType, 'Amount', 100
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 公园与休憩
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_BUILDER_LEFT_3', 'HD_GOVERNOR_BUILDER_LEFT_3_' || DistrictType || '_ATTACH'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
  'HD_GOVERNOR_BUILDER_LEFT_3_' || DistrictType || '_ATTACH', 'MODIFIER_PLAYER_IMPROVEMENTS_ATTACH_MODIFIER', 'HD_PLOT_HAS_CITY_OR_WATER_PARK_IMPROVEMENT_WITHIN_6_TILES_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_LEFT_3_' || DistrictType || '_ATTACH', 'ModifierId', 'HD_GOVERNOR_BUILDER_LEFT_3_' || DistrictType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
  'HD_GOVERNOR_BUILDER_LEFT_3_' || DistrictType, 'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER', 'HD_DISTRICT_IS_' || DistrictType || '_WITHIN_2_TILES_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_LEFT_3_' || DistrictType, 'YieldType', YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_LEFT_3_' || DistrictType, 'Amount', 50
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 国家工程院 奇观辐射
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
	'GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_3', 'HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_REGIONAL_' || YieldType
from Yields;

insert or ignore into Modifiers (ModifierId, ModifierType) select
	'HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_REGIONAL_' || YieldType, 'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY'
from Yields;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_REGIONAL_' || YieldType, 'Key', 'HD_SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_DISTRICT_WONDER_' || YieldType
from Yields;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_REGIONAL_' || YieldType, 'Amount', 100
from Yields;

-- 国家工程院 相邻加成
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_3', 'HD_GOVERNOR_BUILDER_RIGHT_3_' || DistrictType || '_' || Exp
from HD_Binary_Compress, DistrictCorrespondingYieldType_HD where Exp < 6 and HasAdjacency = 1;

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) select
  'HD_GOVERNOR_BUILDER_RIGHT_3_' || DistrictType || '_' || Exp, 'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER', 'HD_PLOT_BINARY_COMPRESS_GOVERNOR_BUILDER_RIGHT_3_' || Exp || '_REQUIREMENTS', 'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET'
from HD_Binary_Compress, DistrictCorrespondingYieldType_HD where Exp < 6 and HasAdjacency = 1;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_RIGHT_3_' || DistrictType || '_' || Exp, 'YieldType', YieldType
from HD_Binary_Compress, DistrictCorrespondingYieldType_HD where Exp < 6 and HasAdjacency = 1;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_RIGHT_3_' || DistrictType || '_' || Exp, 'Amount', HD_Binary_Compress.Amount * 25
from HD_Binary_Compress, DistrictCorrespondingYieldType_HD where Exp < 6 and HasAdjacency = 1;

-- ============================================================================================================================================================
-- 马格努斯
-- ============================================================================================================================================================
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) values
  ('GOVERNOR_PROMOTION_HD_MANAGER_BASE',     'HD_GOVERNOR_MANAGER_BASE_SETTLER_CONSUME_NO_POP'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_BASE',     'HD_GOVERNOR_MANAGER_BASE_PLOT_PURCHASE_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_BASE',     'HD_GOVERNOR_MANAGER_BASE_IMPROVEMENT_YIELDS'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_1',   'HD_GOVERNOR_MANAGER_LEFT_1_TRADE_ROUTE'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_1',   'HD_GOVERNOR_MANAGER_LEFT_1_TRADE_FOOD'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_1',   'HD_GOVERNOR_MANAGER_LEFT_1_TRADE_PRODUCTION'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_1',   'HD_GOVERNOR_MANAGER_LEFT_1_TRADE_AMENITY'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_2',   'HD_GOVERNOR_MANAGER_LEFT_2_RESOURCE_FOOD'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_2',   'HD_GOVERNOR_MANAGER_LEFT_2_RESOURCE_PRODUCTION'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_3',   'HD_GOVERNOR_MANAGER_LEFT_3_CITY_FOOD'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_3',   'HD_GOVERNOR_MANAGER_LEFT_3_CITY_PRODUCTION'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_3',   'HD_GOVERNOR_MANAGER_LEFT_3_CITY_FOOD_LATE'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_LEFT_3',   'HD_GOVERNOR_MANAGER_LEFT_3_CITY_PRODUCTION_LATE'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_RIGHT_1',  'HD_GOVERNOR_MANAGER_RIGHT_1_EXTRA_DISTRICT'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_RIGHT_1',  'HD_GOVERNOR_MANAGER_RIGHT_1_DISTRICT_BOOST'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_RIGHT_1',  'HD_GOVERNOR_MANAGER_RIGHT_1_BUILDING_BOOST'),
  ('GOVERNOR_PROMOTION_HD_MANAGER_RIGHT_2',  'HD_GOVERNOR_MANAGER_RIGHT_2_CITY_YIELDS');

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
  ('HD_GOVERNOR_MANAGER_BASE_SETTLER_CONSUME_NO_POP',                   'MODIFIER_CITY_ADJUST_SETTLER_CONSUME_POPULATION',                      NULL),
  ('HD_GOVERNOR_MANAGER_BASE_PLOT_PURCHASE_DISCOUNT',                   'MODIFIER_SINGLE_CITY_ADJUST_PLOT_PURCHASE_COST',                       NULL),
  ('HD_GOVERNOR_MANAGER_BASE_IMPROVEMENT_YIELDS',                       'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',                          'PLOT_HAS_IMPROVEMENT_CLASSIFICATION_EXPLOITATIVE_REQUIREMENTS'),
  ('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_ROUTE',                            'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',                          NULL),
  ('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_FOOD',                             'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS',              NULL),
  ('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_PRODUCTION',                       'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS',              NULL),
  ('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_AMENITY',                          'MODIFIER_PLAYER_CITIES_ADJUST_AMENITIES_FROM_GOVERNORS',               'HD_GOVERNOR_MANAGER_LEFT_1_TRADE_REQUIREMENTS'),
  ('HD_GOVERNOR_MANAGER_LEFT_2_RESOURCE_FOOD',                          'MODIFIER_SINGLE_CITY_ADJUST_YIELD_BY_NUMBER_RESOURCES',                NULL),
  ('HD_GOVERNOR_MANAGER_LEFT_2_RESOURCE_PRODUCTION',                    'MODIFIER_SINGLE_CITY_ADJUST_YIELD_BY_NUMBER_RESOURCES',                NULL),
  ('HD_GOVERNOR_MANAGER_RIGHT_1_EXTRA_DISTRICT',                        'MODIFIER_SINGLE_CITY_EXTRA_DISTRICT',                                  NULL),
  ('HD_GOVERNOR_MANAGER_RIGHT_1_DISTRICT_BOOST',                        'MODIFIER_CITY_INCREASE_DISTRICT_PRODUCTION_RATE',                      NULL),
  ('HD_GOVERNOR_MANAGER_RIGHT_1_BUILDING_BOOST',                        'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION_MODIFIER',             NULL),
  ('HD_GOVERNOR_MANAGER_RIGHT_2_CITY_YIELDS',                           'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',                      NULL);

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) values
  ('HD_GOVERNOR_MANAGER_LEFT_3_CITY_FOOD',                              'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',  NULL,                                           'HD_OBJECT_WITHIN_9_TILES'),
  ('HD_GOVERNOR_MANAGER_LEFT_3_CITY_PRODUCTION',                        'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',  NULL,                                           'HD_OBJECT_WITHIN_9_TILES'),
  ('HD_GOVERNOR_MANAGER_LEFT_3_CITY_FOOD_LATE',                         'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',  'PLAYER_HAS_CIVIC_CIVIL_SERVICE_REQUIREMENTS',  'HD_OBJECT_WITHIN_9_TILES'),
  ('HD_GOVERNOR_MANAGER_LEFT_3_CITY_PRODUCTION_LATE',                   'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',  'PLAYER_HAS_CIVIC_CIVIL_SERVICE_REQUIREMENTS',  'HD_OBJECT_WITHIN_9_TILES');

insert or ignore into ModifierArguments (ModifierId, Name, Value) values
	('HD_GOVERNOR_MANAGER_BASE_SETTLER_CONSUME_NO_POP',                   'Enabled',                0),
	('HD_GOVERNOR_MANAGER_BASE_PLOT_PURCHASE_DISCOUNT',                   'Amount',                 -25),
	('HD_GOVERNOR_MANAGER_BASE_IMPROVEMENT_YIELDS',                       'YieldType',              'YIELD_FOOD'),
	('HD_GOVERNOR_MANAGER_BASE_IMPROVEMENT_YIELDS',                       'Amount',                 1),
	('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_ROUTE',                            'Amount',                 1),
	('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_FOOD',                             'YieldType',              'YIELD_FOOD'),
	('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_FOOD',                             'Amount',                 2),
	('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_FOOD',                             'Domestic',               1),
	('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_PRODUCTION',                       'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_PRODUCTION',                       'Amount',                 2),
	('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_PRODUCTION',                       'Domestic',               1),
	('HD_GOVERNOR_MANAGER_LEFT_1_TRADE_AMENITY',                          'Amount',                 1),
	('HD_GOVERNOR_MANAGER_LEFT_2_RESOURCE_FOOD',                          'YieldType',              'YIELD_FOOD'),
	('HD_GOVERNOR_MANAGER_LEFT_2_RESOURCE_FOOD',                          'Amount',                 2),
	('HD_GOVERNOR_MANAGER_LEFT_2_RESOURCE_PRODUCTION',                    'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_MANAGER_LEFT_2_RESOURCE_PRODUCTION',                    'Amount',                 2),
	('HD_GOVERNOR_MANAGER_LEFT_3_CITY_FOOD',                              'YieldType',              'YIELD_FOOD'),
	('HD_GOVERNOR_MANAGER_LEFT_3_CITY_FOOD',                              'Amount',                 4),
	('HD_GOVERNOR_MANAGER_LEFT_3_CITY_PRODUCTION',                        'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_MANAGER_LEFT_3_CITY_PRODUCTION',                        'Amount',                 4),
	('HD_GOVERNOR_MANAGER_LEFT_3_CITY_FOOD_LATE',                         'YieldType',              'YIELD_FOOD'),
	('HD_GOVERNOR_MANAGER_LEFT_3_CITY_FOOD_LATE',                         'Amount',                 4),
	('HD_GOVERNOR_MANAGER_LEFT_3_CITY_PRODUCTION_LATE',                   'YieldType',              'YIELD_PRODUCTION'),
	('HD_GOVERNOR_MANAGER_LEFT_3_CITY_PRODUCTION_LATE',                   'Amount',                 4),
	('HD_GOVERNOR_MANAGER_RIGHT_1_EXTRA_DISTRICT',                        'Amount',                 1),
	('HD_GOVERNOR_MANAGER_RIGHT_1_DISTRICT_BOOST',                        'Amount',                 30),
	('HD_GOVERNOR_MANAGER_RIGHT_1_BUILDING_BOOST',                        'Amount',                 30),
	('HD_GOVERNOR_MANAGER_RIGHT_1_BUILDING_BOOST',                        'IsWonder',               0),
	('HD_GOVERNOR_MANAGER_RIGHT_2_CITY_YIELDS',                           'YieldType',              'YIELD_FOOD, YIELD_PRODUCTION'),
	('HD_GOVERNOR_MANAGER_RIGHT_2_CITY_YIELDS',                           'Amount',                 '20, 20');

-- 纵向一体化
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_MANAGER_RIGHT_3', 'HD_GOVERNOR_MANAGER_RIGHT_3_RECEIVE_REGIONAL_' || YieldType
from Yields;

insert or ignore into Modifiers (ModifierId, ModifierType) select
  'HD_GOVERNOR_MANAGER_RIGHT_3_RECEIVE_REGIONAL_' || YieldType, 'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY'
from Yields;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_GOVERNOR_MANAGER_RIGHT_3_RECEIVE_REGIONAL_' || YieldType, 'Key', 'HD_ALL_DISTRICTS_RECEIVE_REGIONAL_YIELD_SCALING_FACTOR_' || YieldType
from Yields;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_GOVERNOR_MANAGER_RIGHT_3_RECEIVE_REGIONAL_' || YieldType, 'Amount', 50
from Yields;

-- ============================================================================================================================================================
-- 瑞娜
-- ============================================================================================================================================================
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) values
  ('GOVERNOR_PROMOTION_HD_MERCHANT_BASE',     'HD_GOVERNOR_MERCHANT_BASE_COMMERCIAL_HUB_DISTRICT_BOOST'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_BASE',     'HD_GOVERNOR_MERCHANT_BASE_COMMERCIAL_HUB_BUILDING_BOOST'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_BASE',     'HD_GOVERNOR_MERCHANT_BASE_HARBOR_DISTRICT_BOOST'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_BASE',     'HD_GOVERNOR_MERCHANT_BASE_HARBOR_BUILDING_BOOST'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_BASE',     'HD_GOVERNOR_MERCHANT_BASE_EXTRA_DISTRICT'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_1',   'HD_GOVERNOR_MERCHANT_LEFT_1_UNIT_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_1',   'HD_GOVERNOR_MERCHANT_LEFT_1_UNIT_TRADER_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_2',   'HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_GOLD_BONUS'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_2',   'HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_GOLD_BONUS'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_2',   'HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_REGIONAL_GOLD'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_2',   'HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_REGIONAL_GOLD'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_2',   'HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_REGIONAL_RANGE'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_2',   'HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_REGIONAL_RANGE'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_3',   'HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_1_GPP'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_3',   'HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_2_GPP'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_3',   'HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_3_GPP'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_3',   'HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_4_GPP'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_3',   'HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_1_GPP'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_3',   'HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_2_GPP'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_LEFT_3',   'HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_3_GPP'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_1',  'HD_GOVERNOR_MERCHANT_RIGHT_1_TRADE_ROUTE'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_1',  'HD_GOVERNOR_MERCHANT_RIGHT_1_COMMERCIAL_HUB_ADJACENCY_BONUS'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_1',  'HD_GOVERNOR_MERCHANT_RIGHT_1_HARBOR_ADJACENCY_BONUS'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_2',  'HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_1_TRADE_GOLD'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_2',  'HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_2_TRADE_GOLD'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_2',  'HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_3_TRADE_GOLD'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_2',  'HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_4_TRADE_GOLD'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_2',  'HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_1_TRADE_GOLD'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_2',  'HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_2_TRADE_GOLD'),
  ('GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_2',  'HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_3_TRADE_GOLD');

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
  ('HD_GOVERNOR_MERCHANT_BASE_COMMERCIAL_HUB_DISTRICT_BOOST',           'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION',                      NULL),
  ('HD_GOVERNOR_MERCHANT_BASE_COMMERCIAL_HUB_BUILDING_BOOST',           'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION',                      NULL),
  ('HD_GOVERNOR_MERCHANT_BASE_HARBOR_DISTRICT_BOOST',                   'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION',                      NULL),
  ('HD_GOVERNOR_MERCHANT_BASE_HARBOR_BUILDING_BOOST',                   'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION',                      NULL),
  ('HD_GOVERNOR_MERCHANT_BASE_EXTRA_DISTRICT',                          'MODIFIER_SINGLE_CITY_EXTRA_DISTRICT',                                  'HD_CITY_HAS_COMMERCIAL_HUB_OR_HARBOR_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_LEFT_1_UNIT_DISCOUNT',                         'MODIFIER_SINGLE_CITY_ADJUST_ALL_UNITS_PURCHASE_COST',                  NULL),
  ('HD_GOVERNOR_MERCHANT_LEFT_1_UNIT_TRADER_DISCOUNT',                  'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',                       NULL),
  ('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_GOLD_BONUS',    'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',    NULL),
  ('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_GOLD_BONUS',            'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',    NULL),
  ('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_REGIONAL_GOLD', 'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',                                 NULL),
  ('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_REGIONAL_GOLD',         'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',                                 NULL),
  ('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_REGIONAL_RANGE','MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',                                 NULL),
  ('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_REGIONAL_RANGE',        'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',                                 NULL),
  ('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_1_GPP',             'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',                   'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_1_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_2_GPP',             'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',                   'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_2_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_3_GPP',             'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',                   'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_3_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_4_GPP',             'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',                   'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_4_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_1_GPP',                     'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',                   'CITY_HAS_DISTRICT_HARBOR_TIER_1_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_2_GPP',                     'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',                   'CITY_HAS_DISTRICT_HARBOR_TIER_2_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_3_GPP',                     'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',                   'CITY_HAS_DISTRICT_HARBOR_TIER_3_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_RIGHT_1_TRADE_ROUTE',                          'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',                          NULL),
  ('HD_GOVERNOR_MERCHANT_RIGHT_1_COMMERCIAL_HUB_ADJACENCY_BONUS',       'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',                        'DISTRICT_IS_COMMERCIAL_HUB'),
  ('HD_GOVERNOR_MERCHANT_RIGHT_1_HARBOR_ADJACENCY_BONUS',               'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',                        'DISTRICT_IS_HARBOR'),
  ('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_1_TRADE_GOLD',     'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',      'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_1_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_2_TRADE_GOLD',     'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',      'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_2_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_3_TRADE_GOLD',     'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',      'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_3_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_4_TRADE_GOLD',     'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',      'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_4_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_1_TRADE_GOLD',             'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',      'CITY_HAS_DISTRICT_HARBOR_TIER_1_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_2_TRADE_GOLD',             'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',      'CITY_HAS_DISTRICT_HARBOR_TIER_2_BUILDING_REQUIREMENTS'),
  ('HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_3_TRADE_GOLD',             'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',      'CITY_HAS_DISTRICT_HARBOR_TIER_3_BUILDING_REQUIREMENTS');

insert or ignore into ModifierArguments (ModifierId, Name, Value) values
	('HD_GOVERNOR_MERCHANT_BASE_COMMERCIAL_HUB_DISTRICT_BOOST',           'DistrictType',           'DISTRICT_COMMERCIAL_HUB'),
	('HD_GOVERNOR_MERCHANT_BASE_COMMERCIAL_HUB_DISTRICT_BOOST',           'Amount',                 30),
	('HD_GOVERNOR_MERCHANT_BASE_COMMERCIAL_HUB_BUILDING_BOOST',           'DistrictType',           'DISTRICT_COMMERCIAL_HUB'),
	('HD_GOVERNOR_MERCHANT_BASE_COMMERCIAL_HUB_BUILDING_BOOST',           'Amount',                 30),
	('HD_GOVERNOR_MERCHANT_BASE_HARBOR_DISTRICT_BOOST',                   'DistrictType',           'DISTRICT_HARBOR'),
	('HD_GOVERNOR_MERCHANT_BASE_HARBOR_DISTRICT_BOOST',                   'Amount',                 30),
	('HD_GOVERNOR_MERCHANT_BASE_HARBOR_BUILDING_BOOST',                   'DistrictType',           'DISTRICT_HARBOR'),
	('HD_GOVERNOR_MERCHANT_BASE_HARBOR_BUILDING_BOOST',                   'Amount',                 30),
	('HD_GOVERNOR_MERCHANT_BASE_EXTRA_DISTRICT',                          'Amount',                 1),
	('HD_GOVERNOR_MERCHANT_LEFT_1_UNIT_DISCOUNT',                         'Amount',                 15),
	('HD_GOVERNOR_MERCHANT_LEFT_1_UNIT_DISCOUNT',                         'IncludeCivilian',        1),
	('HD_GOVERNOR_MERCHANT_LEFT_1_UNIT_TRADER_DISCOUNT',                  'Amount',                 15),
	('HD_GOVERNOR_MERCHANT_LEFT_1_UNIT_TRADER_DISCOUNT',                  'UnitType',               'UNIT_TRADER'),
	('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_GOLD_BONUS',		'DistrictType',		        'DISTRICT_COMMERCIAL_HUB'),
	('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_GOLD_BONUS',		'YieldType',			        'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_GOLD_BONUS',		'Amount',					        100),
	('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_GOLD_BONUS',		        'DistrictType',		        'DISTRICT_HARBOR'),
	('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_GOLD_BONUS',		        'YieldType',			        'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_GOLD_BONUS',		        'Amount',					        100),
	('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_REGIONAL_GOLD',	'Key',			              'HD_SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_DISTRICT_COMMERCIAL_HUB_YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_REGIONAL_GOLD',	'Amount',					        100),
	('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_REGIONAL_GOLD',	        'Key',			              'HD_SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_DISTRICT_HARBOR_YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_REGIONAL_GOLD',	        'Amount',					        100),
	('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_REGIONAL_RANGE','Key',			              'HD_SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_DISTRICT_COMMERCIAL_HUB'),
	('HD_GOVERNOR_MERCHANT_LEFT_2_COMMERCIAL_HUB_BUILDING_REGIONAL_RANGE','Amount',					        1),
	('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_REGIONAL_RANGE',	      'Key',			              'HD_SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_DISTRICT_HARBOR'),
	('HD_GOVERNOR_MERCHANT_LEFT_2_HARBOR_BUILDING_REGIONAL_RANGE',	      'Amount',					        1),
	('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_1_GPP',             'GreatPersonClassType',   'GREAT_PERSON_CLASS_MERCHANT'),
	('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_1_GPP',             'Amount',                 25),
	('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_2_GPP',             'GreatPersonClassType',   'GREAT_PERSON_CLASS_MERCHANT'),
	('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_2_GPP',             'Amount',                 25),
	('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_3_GPP',             'GreatPersonClassType',   'GREAT_PERSON_CLASS_MERCHANT'),
	('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_3_GPP',             'Amount',                 25),
	('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_4_GPP',             'GreatPersonClassType',   'GREAT_PERSON_CLASS_MERCHANT'),
	('HD_GOVERNOR_MERCHANT_LEFT_3_COMMERCIAL_HUB_TIER_4_GPP',             'Amount',                 25),
	('HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_1_GPP',                     'GreatPersonClassType',   'GREAT_PERSON_CLASS_ADMIRAL'),
	('HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_1_GPP',                     'Amount',                 25),
	('HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_2_GPP',                     'GreatPersonClassType',   'GREAT_PERSON_CLASS_ADMIRAL'),
	('HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_2_GPP',                     'Amount',                 25),
	('HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_3_GPP',                     'GreatPersonClassType',   'GREAT_PERSON_CLASS_ADMIRAL'),
	('HD_GOVERNOR_MERCHANT_LEFT_3_HARBOR_TIER_3_GPP',                     'Amount',                 25),
	('HD_GOVERNOR_MERCHANT_RIGHT_1_TRADE_ROUTE',                          'Amount',                 2),
	('HD_GOVERNOR_MERCHANT_RIGHT_1_COMMERCIAL_HUB_ADJACENCY_BONUS',       'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_RIGHT_1_COMMERCIAL_HUB_ADJACENCY_BONUS',       'Amount',                 100),
	('HD_GOVERNOR_MERCHANT_RIGHT_1_HARBOR_ADJACENCY_BONUS',               'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_RIGHT_1_HARBOR_ADJACENCY_BONUS',               'Amount',                 100),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_1_TRADE_GOLD',     'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_1_TRADE_GOLD',     'Amount',                 3),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_2_TRADE_GOLD',     'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_2_TRADE_GOLD',     'Amount',                 3),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_3_TRADE_GOLD',     'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_3_TRADE_GOLD',     'Amount',                 3),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_4_TRADE_GOLD',     'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_COMMERCIAL_HUB_TIER_4_TRADE_GOLD',     'Amount',                 3),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_1_TRADE_GOLD',             'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_1_TRADE_GOLD',             'Amount',                 4),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_2_TRADE_GOLD',             'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_2_TRADE_GOLD',             'Amount',                 4),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_3_TRADE_GOLD',             'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_MERCHANT_RIGHT_2_HARBOR_TIER_3_TRADE_GOLD',             'Amount',                 4);

-- 国际贸易
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_3', 'HD_GOVERNOR_MERCHANT_RIGHT_3_' || YieldType || '_' || Exp
from Yields, HD_Binary_Compress where Exp < 12 and YieldType != 'YIELD_GOLD';

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_GOVERNOR_MERCHANT_RIGHT_3_' || YieldType || '_' || Exp, 'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_GOVERNOR_MERCHANT_RIGHT_3_' || YieldType || '_' || Exp || '_REQUIREMENTS'
from Yields, HD_Binary_Compress where Exp < 12 and YieldType != 'YIELD_GOLD';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_MERCHANT_RIGHT_3_' || YieldType || '_' || Exp, 'YieldType', YieldType
from Yields, HD_Binary_Compress where Exp < 12 and YieldType != 'YIELD_GOLD';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_MERCHANT_RIGHT_3_' || YieldType || '_' || Exp, 'Amount', Amount
from Yields, HD_Binary_Compress where Exp < 12 and YieldType != 'YIELD_GOLD';

  -- 金币 二进制上限更高
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_3', 'HD_GOVERNOR_MERCHANT_RIGHT_3_YIELD_GOLD_' || Exp
from HD_Binary_Compress where Exp < 15;

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_GOVERNOR_MERCHANT_RIGHT_3_YIELD_GOLD_' || Exp, 'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_GOVERNOR_MERCHANT_RIGHT_3_YIELD_GOLD_' || Exp || '_REQUIREMENTS'
from HD_Binary_Compress where Exp < 15;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_MERCHANT_RIGHT_3_YIELD_GOLD_' || Exp, 'YieldType', 'YIELD_GOLD'
from HD_Binary_Compress where Exp < 15;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_MERCHANT_RIGHT_3_YIELD_GOLD_' || Exp, 'Amount', Amount
from HD_Binary_Compress where Exp < 15;

-- ============================================================================================================================================================
-- 莫克夏
-- ============================================================================================================================================================
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) values
  ('GOVERNOR_PROMOTION_HD_CARDINAL_BASE',     'HD_GOVERNOR_CARDINAL_BASE_RELIGIOUS_PRESSURE'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_BASE',     'HD_GOVERNOR_CARDINAL_BASE_PROPHET_POINTS'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_BASE',     'HD_GOVERNOR_CARDINAL_BASE_POP_FAITH'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_LEFT_1',   'HD_GOVERNOR_CARDINAL_LEFT_1_HOLY_SITE_ADJACENCY_BONUS'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_LEFT_2',   'HD_GOVERNOR_CARDINAL_LEFT_2_CITY_YIELDS'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_LEFT_2',   'HD_GOVERNOR_CARDINAL_LEFT_2_RELIC_CITY_YIELDS'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_LEFT_2',   'HD_GOVERNOR_CARDINAL_LEFT_2_CITY_PROPERTY'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_RIGHT_1',  'HD_GOVERNOR_CARDINAL_RIGHT_1_SPREAD_CHARGE'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_RIGHT_1',  'HD_GOVERNOR_CARDINAL_RIGHT_1_MISSIONARY_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_RIGHT_1',  'HD_GOVERNOR_CARDINAL_RIGHT_1_APOSTLE_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_RIGHT_1',  'HD_GOVERNOR_CARDINAL_RIGHT_1_INQUISITOR_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_RIGHT_1',  'HD_GOVERNOR_CARDINAL_RIGHT_1_GURU_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_RIGHT_1',  'HD_GOVERNOR_CARDINAL_RIGHT_1_FREE_PROMOTION'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_RIGHT_2',  'HD_GOVERNOR_CARDINAL_RIGHT_2_GURU_CHARGE'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_RIGHT_2',  'HD_GOVERNOR_CARDINAL_RIGHT_2_GURU_ABILITY'),
  ('GOVERNOR_PROMOTION_HD_CARDINAL_RIGHT_3',  'HD_GOVERNOR_CARDINAL_RIGHT_3_UNIT_PURCHASE');

insert or ignore into Modifiers (ModifierId, ModifierType, Permanent, OwnerRequirementSetId, SubjectRequirementSetId) values
  ('HD_GOVERNOR_CARDINAL_BASE_RELIGIOUS_PRESSURE',                      'MODIFIER_SINGLE_CITY_RELIGION_PRESSURE',                               0,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_BASE_PROPHET_POINTS',                          'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',            0,  'PLAYER_IS_HUMAN',                                'REQUIRES_DISTRICT_IS_DISTRICT_CITY_CENTER_UDMET'),
  ('HD_GOVERNOR_CARDINAL_BASE_POP_FAITH',                               'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',                0,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_LEFT_1_HOLY_SITE_ADJACENCY_BONUS',             'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',                      0,  NULL,                                             'DISTRICT_IS_DISTRICT_HOLY_SITE_WITHIN_6_TILES_REQUIREMENTS'),
  ('HD_GOVERNOR_CARDINAL_LEFT_2_CITY_YIELDS',                           'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',                      0,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_LEFT_2_RELIC_CITY_YIELDS',                     'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',                      0,  'HD_CITY_HAS_GREATWORKOBJECT_RELIC_REQUIREMENTS', NULL),
  ('HD_GOVERNOR_CARDINAL_LEFT_2_CITY_PROPERTY',                         'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',                                 0,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_RIGHT_1_SPREAD_CHARGE',                        'MODIFIER_SINGLE_CITY_RELIGIOUS_SPREADS',                               1,  NULL,                                             'MOSQUE_RELIGIOUS_UNIT'),
  ('HD_GOVERNOR_CARDINAL_RIGHT_1_MISSIONARY_DISCOUNT',                  'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',                       0,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_RIGHT_1_APOSTLE_DISCOUNT',                     'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',                       0,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_RIGHT_1_INQUISITOR_DISCOUNT',                  'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',                       0,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_RIGHT_1_GURU_DISCOUNT',                        'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',                       0,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_RIGHT_1_FREE_PROMOTION',                       'MODIFIER_SINGLE_CITY_RELIGION_EXTRA_PROMOTIONS',                       0,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_RIGHT_2_GURU_CHARGE',                          'MODIFIER_SINGLE_CITY_HEAL_SPREADS',                                    1,  NULL,                                             'UNIT_IS_UNIT_GURU_REQUIREMENTS'),
  ('HD_GOVERNOR_CARDINAL_RIGHT_2_GURU_ABILITY',                         'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',                 1,  NULL,                                             NULL),
  ('HD_GOVERNOR_CARDINAL_RIGHT_3_UNIT_PURCHASE',                        'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE',                    0,  NULL,                                             NULL);

insert or ignore into ModifierArguments (ModifierId, Name, Value) values
	('HD_GOVERNOR_CARDINAL_BASE_RELIGIOUS_PRESSURE',                      'Amount',                 100),
	('HD_GOVERNOR_CARDINAL_BASE_PROPHET_POINTS',                          'GreatPersonClassType',   'GREAT_PERSON_CLASS_PROPHET'),
	('HD_GOVERNOR_CARDINAL_BASE_PROPHET_POINTS',                          'Amount',                 4),
	('HD_GOVERNOR_CARDINAL_BASE_POP_FAITH',                               'YieldType',              'YIELD_FAITH'),
	('HD_GOVERNOR_CARDINAL_BASE_POP_FAITH',                               'Amount',                 1.5),
	('HD_GOVERNOR_CARDINAL_LEFT_1_HOLY_SITE_ADJACENCY_BONUS',             'YieldType',              'YIELD_FAITH'),
	('HD_GOVERNOR_CARDINAL_LEFT_1_HOLY_SITE_ADJACENCY_BONUS',             'Amount',                 100),
	('HD_GOVERNOR_CARDINAL_LEFT_2_CITY_YIELDS',                           'YieldType',              'YIELD_FAITH'),
	('HD_GOVERNOR_CARDINAL_LEFT_2_CITY_YIELDS',                           'Amount',                 20),
	('HD_GOVERNOR_CARDINAL_LEFT_2_RELIC_CITY_YIELDS',                     'YieldType',	            'YIELD_FAITH'),
	('HD_GOVERNOR_CARDINAL_LEFT_2_RELIC_CITY_YIELDS',                     'Amount',			            10),
	('HD_GOVERNOR_CARDINAL_LEFT_2_CITY_PROPERTY',                         'Key',	                  'HD_CITY_NEED_DETECT_GREATWORKOBJECT_RELIC'),
	('HD_GOVERNOR_CARDINAL_LEFT_2_CITY_PROPERTY',                         'Amount',			            1),
	('HD_GOVERNOR_CARDINAL_RIGHT_1_SPREAD_CHARGE',                        'Amount',		              1),
	('HD_GOVERNOR_CARDINAL_RIGHT_1_MISSIONARY_DISCOUNT',				          'UnitType',				        'UNIT_MISSIONARY'),
	('HD_GOVERNOR_CARDINAL_RIGHT_1_MISSIONARY_DISCOUNT',				          'Amount',				          20),
  ('HD_GOVERNOR_CARDINAL_RIGHT_1_APOSTLE_DISCOUNT',				              'UnitType',				        'UNIT_APOSTLE'),
	('HD_GOVERNOR_CARDINAL_RIGHT_1_APOSTLE_DISCOUNT',				              'Amount',				          20),
  ('HD_GOVERNOR_CARDINAL_RIGHT_1_INQUISITOR_DISCOUNT',				          'UnitType',				        'UNIT_INQUISITOR'),
	('HD_GOVERNOR_CARDINAL_RIGHT_1_INQUISITOR_DISCOUNT',				          'Amount',				          20),
  ('HD_GOVERNOR_CARDINAL_RIGHT_1_GURU_DISCOUNT',				                'UnitType',				        'UNIT_GURU'),
	('HD_GOVERNOR_CARDINAL_RIGHT_1_GURU_DISCOUNT',				                'Amount',				          20),
	('HD_GOVERNOR_CARDINAL_RIGHT_1_FREE_PROMOTION',				                'Amount',				          1),
	('HD_GOVERNOR_CARDINAL_RIGHT_2_GURU_CHARGE',				                  'Amount',				          1),
	('HD_GOVERNOR_CARDINAL_RIGHT_2_GURU_ABILITY',				                  'AbilityType',				    'ABILITY_HD_GOVERNOR_CARDINAL_RIGHT_2_GURU'),
	('HD_GOVERNOR_CARDINAL_RIGHT_3_UNIT_PURCHASE',				                'Tag',				            'CLASS_UNIT_CITADEL_OF_GOD');

-- 普世牧首
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_CARDINAL_LEFT_3', 'HD_GOVERNOR_CARDINAL_LEFT_3_' || DistrictType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
  'HD_GOVERNOR_CARDINAL_LEFT_3_' || DistrictType, 'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS', 'DISTRICT_IS_' || DistrictType || '_WITHIN_6_TILES_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_CARDINAL_LEFT_3_' || DistrictType, 'YieldTypeToMirror', YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_CARDINAL_LEFT_3_' || DistrictType, 'YieldTypeToGrant', 'YIELD_FAITH'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- ============================================================================================================================================================
-- 阿玛妮
-- ============================================================================================================================================================
update Governors set TransitionStrength = 250 where GovernorType = 'GOVERNOR_THE_AMBASSADOR';
update GovernorPromotions set Description = 'LOC_GOVERNOR_PROMOTION_HD_AMBASSADOR_BASE_DESCRIPTION_DIPLO' where GovernorPromotionType = 'GOVERNOR_PROMOTION_HD_AMBASSADOR_BASE'
  and exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) values
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_BASE',     'HD_GOVERNOR_AMBASSADOR_BASE_ENVOY'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_LEFT_1',   'HD_GOVERNOR_AMBASSADOR_LEFT_1_FAITH_PURCHASE_SPY'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_LEFT_1',   'HD_GOVERNOR_AMBASSADOR_LEFT_1_PURCHASE_SPY_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_LEFT_1',   'HD_GOVERNOR_AMBASSADOR_LEFT_1_SPY_FREE_PROMOTION'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_LEFT_1',   'HD_GOVERNOR_AMBASSADOR_LEFT_1_SPY_CAPACITY'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_LEFT_2',   'HD_GOVERNOR_AMBASSADOR_LEFT_2_SPY_TIME_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_LEFT_2',   'HD_GOVERNOR_AMBASSADOR_LEFT_2_SPY_OFFENSE'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_LEFT_3',   'HD_GOVERNOR_AMBASSADOR_LEFT_3_SPY_OFFENSE'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_LEFT_3',   'HD_GOVERNOR_AMBASSADOR_LEFT_3_SPY_DEFENSE'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_1',  'HD_GOVERNOR_AMBASSADOR_RIGHT_1_ENVOY'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_1',  'HD_GOVERNOR_AMBASSADOR_RIGHT_1_LEVY_DISCOUNT'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_1',  'HD_GOVERNOR_AMBASSADOR_RIGHT_1_LEVY_STRENGTH'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_1',  'HD_GOVERNOR_AMBASSADOR_RIGHT_1_CITYSTATE_STRENGTH'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_1',  'HD_GOVERNOR_AMBASSADOR_RIGHT_1_COPY_LUXURY'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_1',  'HD_GOVERNOR_AMBASSADOR_RIGHT_1_COPY_STRATEGIC'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_2',  'HD_GOVERNOR_AMBASSADOR_RIGHT_2_SCIENCE'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_2',  'HD_GOVERNOR_AMBASSADOR_RIGHT_2_CULTURE'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_2',  'HD_GOVERNOR_AMBASSADOR_RIGHT_2_GOLD'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_2',  'HD_GOVERNOR_AMBASSADOR_RIGHT_2_FAITH'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_3',  'HD_GOVERNOR_AMBASSADOR_RIGHT_3_ALLIANCE_POINTS'),
  ('GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_3',  'HD_GOVERNOR_AMBASSADOR_RIGHT_3_DOUBLE_ENVOY');

insert or ignore into Modifiers (ModifierId, ModifierType, Permanent, SubjectRequirementSetId) values
  ('HD_GOVERNOR_AMBASSADOR_BASE_ENVOY',                                 'MODIFIER_GOVERNOR_ADJUST_CITY_ENVOYS',                                 0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_LEFT_1_FAITH_PURCHASE_SPY',                  'MODIFIER_SINGLE_CITY_ENABLE_UNIT_FAITH_PURCHASE',                      0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_LEFT_1_PURCHASE_SPY_DISCOUNT',               'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',                       0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_LEFT_1_SPY_FREE_PROMOTION',                  'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',                 1,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_LEFT_1_SPY_CAPACITY',                        'MODIFIER_PLAYER_GRANT_SPY',                                            0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_LEFT_2_SPY_TIME_DISCOUNT',                   'MODIFIER_PLAYER_UNITS_ADJUST_SPY_OFFENSIVE_OPERATION_TIME',            0,  'UNIT_IS_SPY'),
  ('HD_GOVERNOR_AMBASSADOR_LEFT_2_SPY_OFFENSE',                         'MODIFIER_PLAYER_ADJUST_SPY_BONUS',                                     0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_LEFT_3_SPY_OFFENSE',                         'MODIFIER_PLAYER_ADJUST_SPY_BONUS',                                     0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_LEFT_3_SPY_DEFENSE',                         'MODIFIER_PLAYER_ADJUST_SPY_BONUS',                                     0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_1_ENVOY',                              'MODIFIER_GOVERNOR_ADJUST_CITY_ENVOYS',                                 0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_1_LEVY_DISCOUNT',                      'MODIFIER_PLAYER_ADJUST_LEVY_DISCOUNT_PERCENT',                         0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_1_LEVY_STRENGTH',                      'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',                                  0,  'UNIT_IS_LEVERAGED_REQUIREMENTS'),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_1_CITYSTATE_STRENGTH',                 'MODIFIER_PLAYER_CITYSTATEUNITS_ATTACH_MODIFIER',                       0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_1_COPY_LUXURY',                        'MODIFIER_GOVERNOR_ADJUST_CITY_COPY_LUXURIES_FOR_IMPORT',               0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_1_COPY_STRATEGIC',                     'MODIFIER_GOVERNOR_ADJUST_CITY_COPY_STRATEGICS_FOR_IMPORT',             0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_2_SCIENCE',                            'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_TRIBUTARY',                    0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_2_CULTURE',                            'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_TRIBUTARY',                    0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_2_GOLD',                               'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_TRIBUTARY',                    0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_2_FAITH',                              'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_TRIBUTARY',                    0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_3_ALLIANCE_POINTS',                    'MODIFIER_PLAYER_ADJUST_ALLIANCE_POINTS',                               0,  NULL),
  ('HD_GOVERNOR_AMBASSADOR_RIGHT_3_DOUBLE_ENVOY',                       'MODIFIER_GOVERNOR_ADJUST_CITY_ENVOYS_MODIFIER',                        0,  NULL);
  
insert or ignore into ModifierArguments (ModifierId, Name, Value) values
	('HD_GOVERNOR_AMBASSADOR_BASE_ENVOY',                                 'Amount',                 2),
	('HD_GOVERNOR_AMBASSADOR_LEFT_1_FAITH_PURCHASE_SPY',                  'Tag',                    'CLASS_SPY'),
	('HD_GOVERNOR_AMBASSADOR_LEFT_1_PURCHASE_SPY_DISCOUNT',               'UnitType',               'UNIT_SPY'),
	('HD_GOVERNOR_AMBASSADOR_LEFT_1_PURCHASE_SPY_DISCOUNT',               'Amount',                 25),
	('HD_GOVERNOR_AMBASSADOR_LEFT_1_SPY_FREE_PROMOTION',                  'AbilityType',            'ABILITY_HD_GOVERNOR_AMBASSADOR_LEFT_1_SPY_FREE_PROMOTION'),
	('HD_GOVERNOR_AMBASSADOR_LEFT_1_SPY_CAPACITY',                        'Amount',                 2),
	('HD_GOVERNOR_AMBASSADOR_LEFT_2_SPY_TIME_DISCOUNT',                   'ReductionPercent',       25),
	('HD_GOVERNOR_AMBASSADOR_LEFT_2_SPY_OFFENSE',                         'Offense',                1),
	('HD_GOVERNOR_AMBASSADOR_LEFT_2_SPY_OFFENSE',                         'Amount',                 2),
	('HD_GOVERNOR_AMBASSADOR_LEFT_3_SPY_OFFENSE',                         'Offense',                1),
	('HD_GOVERNOR_AMBASSADOR_LEFT_3_SPY_OFFENSE',                         'Amount',                 2),
	('HD_GOVERNOR_AMBASSADOR_LEFT_3_SPY_DEFENSE',                         'Offense',                0),
	('HD_GOVERNOR_AMBASSADOR_LEFT_3_SPY_DEFENSE',                         'Amount',                 2),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_1_ENVOY',                              'Amount',                 1),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_1_LEVY_DISCOUNT',                      'Percent',                20),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_1_LEVY_STRENGTH',                      'AbilityType',            'ABILITY_HD_GOVERNOR_AMBASSADOR_RIGHT_1_LEVY_STRENGTH'),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_1_CITYSTATE_STRENGTH',                 'ModifierId',             'HD_GOVERNOR_AMBASSADOR_RIGHT_1_LEVY_STRENGTH_MODIFIER'),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_2_SCIENCE',                            'YieldType',              'YIELD_SCIENCE'),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_2_SCIENCE',                            'Amount',                 1),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_2_CULTURE',                            'YieldType',              'YIELD_CULTURE'),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_2_CULTURE',                            'Amount',                 1),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_2_GOLD',                               'YieldType',              'YIELD_GOLD'),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_2_GOLD',                               'Amount',                 1),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_2_FAITH',                              'YieldType',              'YIELD_FAITH'),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_2_FAITH',                              'Amount',                 1),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_3_ALLIANCE_POINTS',                    'Amount',                 2),
	('HD_GOVERNOR_AMBASSADOR_RIGHT_3_DOUBLE_ENVOY',                       'Percent',                100);
	
-- 典客
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_AMBASSADOR_BASE', 'HD_GOVERNOR_AMBASSADOR_BASE_DIPLOMATIC_' || YieldType
from Yields where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into Modifiers (ModifierId, ModifierType) select
  'HD_GOVERNOR_AMBASSADOR_BASE_DIPLOMATIC_' || YieldType, 'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT'
from Yields where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_AMBASSADOR_BASE_DIPLOMATIC_' || YieldType, 'YieldType', YieldType
from Yields where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_AMBASSADOR_BASE_DIPLOMATIC_' || YieldType, 'DistrictType', 'DISTRICT_DIPLOMATIC_QUARTER'
from Yields where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_AMBASSADOR_BASE_DIPLOMATIC_' || YieldType, 'Amount', 50
from Yields where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

-- 互惠同盟
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
  'GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_3', 'HD_GOVERNOR_AMBASSADOR_RIGHT_3_TRADE_' || CityStateType
from CityStateCorrespondingYieldType_HD;

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_GOVERNOR_AMBASSADOR_RIGHT_3_TRADE_' || CityStateType, 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL', 'HD_CITY_IS_' || CityStateType || '_REQUIREMENTS'
from CityStateCorrespondingYieldType_HD;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_AMBASSADOR_RIGHT_3_TRADE_' || CityStateType, 'YieldType', YieldType
from CityStateCorrespondingYieldType_HD;

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_AMBASSADOR_RIGHT_3_TRADE_' || CityStateType, 'Amount', Amount * 2
from CityStateCorrespondingYieldType_HD;