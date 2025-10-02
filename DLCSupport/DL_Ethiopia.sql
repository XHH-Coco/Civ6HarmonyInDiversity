-------------------------------------
--           Ethiopia DLC          --
-------------------------------------

--Ethiopia
--独石教堂基础信仰由+1变为+2, 拥有独石教堂的城市可以购买移民和工人

--insert or replace into Improvement_YieldChanges
--    (ImprovementType,                 YieldType,          YieldChange)
--values
--    ('IMPROVEMENT_ROCK_HEWN_CHURCH', 'YIELD_FAITH',       2);
insert or replace into Improvement_YieldChanges
	(ImprovementType,					YieldType,		YieldChange)
values
	('IMPROVEMENT_ROCK_HEWN_CHURCH',	'YIELD_FOOD',	1);
insert or replace into ImprovementModifiers
	(ImprovementType,				        ModifierId)
values
	('IMPROVEMENT_ROCK_HEWN_CHURCH',		'DUSHI_SETTLER_PURCHASE'),
	('IMPROVEMENT_ROCK_HEWN_CHURCH',		'DUSHI_BUILDER_PURCHASE');
insert or replace into Modifiers
	(ModifierId,				ModifierType,									SubjectStackLimit)
values
	('DUSHI_SETTLER_PURCHASE',	'MODIFIER_CITY_ENABLE_UNIT_FAITH_PURCHASE',		1),
	('DUSHI_BUILDER_PURCHASE',	'MODIFIER_CITY_ENABLE_UNIT_FAITH_PURCHASE',		1);

insert or replace into ModifierArguments
	(ModifierId,									Name,				Value)
values
	('DUSHI_BUILDER_PURCHASE',						'Tag',			'CLASS_BUILDER'),
	('DUSHI_SETTLER_PURCHASE',						'Tag',			'CLASS_SETTLER');
--独石教堂相邻
insert or replace into Improvement_Adjacencies
  (ImprovementType,                               YieldChangeId)
values
  ('IMPROVEMENT_ROCK_HEWN_CHURCH',                'LuxuryAdjacency_Faith'),
  ('IMPROVEMENT_ROCK_HEWN_CHURCH',                'StrategicAdjacency_Faith'),
  ('IMPROVEMENT_ROCK_HEWN_CHURCH',                'BonusAdjacency_Faith');
-- insert or replace into PolicyModifiers
--     (PolicyType,    ModifierId)
-- values
--     ('POLICY_GOV_AUTOCRACY',    'AUTOCRACY_DIP');

-- insert or replace into GovernmentModifiers
--     (GovernmentType,    ModifierId)
-- values
--     ('GOVERNMENT_AUTOCRACY',    'AUTOCRACY_DIP');

-- insert or replace into Modifiers
--     (ModifierId,        ModifierType,   SubjectRequirementSetId)
-- values
--     ('AUTOCRACY_DIP',   'MODIFIER_PLAYER_CITIES_ADJUST_CITY_ALL_YIELDS_CHANGE', 'CITY_HAS_DIP_DISTRICT');

-- insert or replace into ModifierArguments
--     (ModifierId,            Name,       Value)
-- values
--     ('AUTOCRACY_DIP',       'Amount',   2);

insert or ignore into RequirementSetRequirements(RequirementSetId, RequirementId)values
  ('CITY_HAS_DIP_DISTRICT',   'REQUIRES_CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER');
insert or ignore into RequirementSets(RequirementSetId, RequirementSetType)values
  ('CITY_HAS_DIP_DISTRICT',   'REQUIREMENTSET_TEST_ALL');

update Policies set Description = 'LOC_POLICY_CHARISMATIC_LEADER_ETHIOPIA_DESCRIPTION' where PolicyType = 'POLICY_CHARISMATIC_LEADER';
update Policies set Description = 'LOC_POLICY_DIPLOMATIC_LEAGUE_ETHIOPIA_DESCRIPTION' where PolicyType = 'POLICY_DIPLOMATIC_LEAGUE';
update Policies set Description = 'LOC_POLICY_GUNBOAT_DIPLOMACY_ETHIOPIA_DESCRIPTION' where PolicyType = 'POLICY_GUNBOAT_DIPLOMACY';

--外交区建筑提升政策卡收益
insert or replace into PolicyModifiers  
  (PolicyType,                    ModifierId)
values 
  ('POLICY_CHARISMATIC_LEADER',   'CHARISMATIC_LEADER_DIP_DISTRICT'),
  ('POLICY_CHARISMATIC_LEADER',   'CHARISMATIC_LEADER_DIP_BUILDING'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'CHARISMATIC_LEADER_DIP_DISTRICT'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'CHARISMATIC_LEADER_DIP_BUILDING'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'DIPLOMATIC_LEAGUE_SCIENCE_0'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'DIPLOMATIC_LEAGUE_SCIENCE_1'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'DIPLOMATIC_LEAGUE_SCIENCE_2'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'DIPLOMATIC_LEAGUE_SCIENCE_3'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'DIPLOMATIC_LEAGUE_FAVOR_0'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'DIPLOMATIC_LEAGUE_FAVOR_1'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'DIPLOMATIC_LEAGUE_FAVOR_2'),
  ('POLICY_DIPLOMATIC_LEAGUE',    'DIPLOMATIC_LEAGUE_FAVOR_3'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'CHARISMATIC_LEADER_DIP_DISTRICT'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'CHARISMATIC_LEADER_DIP_BUILDING'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'GUNBOAT_DIPLOMACY_SCIENCE_0'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'GUNBOAT_DIPLOMACY_SCIENCE_1'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'GUNBOAT_DIPLOMACY_SCIENCE_2'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'GUNBOAT_DIPLOMACY_SCIENCE_3'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'GUNBOAT_DIPLOMACY_FAVOR_0'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'GUNBOAT_DIPLOMACY_FAVOR_1'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'GUNBOAT_DIPLOMACY_FAVOR_2'),
  ('POLICY_GUNBOAT_DIPLOMACY',    'GUNBOAT_DIPLOMACY_FAVOR_3');

insert or replace into Modifiers
  (ModifierId,                            ModifierType,                                             SubjectRequirementSetId)
values
  ('CHARISMATIC_LEADER_DIP_DISTRICT',     'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION',      Null),
  ('CHARISMATIC_LEADER_DIP_BUILDING',     'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION',      Null),
  ('DIPLOMATIC_LEAGUE_SCIENCE_0',         'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',        'REQUIRES_CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_UDMET'),
  ('DIPLOMATIC_LEAGUE_SCIENCE_1',         'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',        'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_1_BUILDING_REQUIREMENTS'),
  ('DIPLOMATIC_LEAGUE_SCIENCE_2',         'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',        'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_2_BUILDING_REQUIREMENTS'),
  ('DIPLOMATIC_LEAGUE_SCIENCE_3',         'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',        'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_3_BUILDING_REQUIREMENTS'),
  ('DIPLOMATIC_LEAGUE_FAVOR_0',           'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',                 'REQUIRES_CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_UDMET'),
  ('DIPLOMATIC_LEAGUE_FAVOR_1',           'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',                 'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_1_BUILDING_REQUIREMENTS'),
  ('DIPLOMATIC_LEAGUE_FAVOR_2',           'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',                 'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_2_BUILDING_REQUIREMENTS'),
  ('DIPLOMATIC_LEAGUE_FAVOR_3',           'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',                 'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_3_BUILDING_REQUIREMENTS'),
  ('DIPLOMATIC_LEAGUE_FAVOR',             'MODIFIER_PLAYER_ADJUST_EXTRA_FAVOR_PER_TURN',            Null),
  ('GUNBOAT_DIPLOMACY_SCIENCE_0',         'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',        'REQUIRES_CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_UDMET'),
  ('GUNBOAT_DIPLOMACY_SCIENCE_1',         'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',        'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_1_BUILDING_REQUIREMENTS'),
  ('GUNBOAT_DIPLOMACY_SCIENCE_2',         'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',        'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_2_BUILDING_REQUIREMENTS'),
  ('GUNBOAT_DIPLOMACY_SCIENCE_3',         'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',        'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_3_BUILDING_REQUIREMENTS'),
  ('GUNBOAT_DIPLOMACY_FAVOR_0',           'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',                 'REQUIRES_CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_UDMET'),
  ('GUNBOAT_DIPLOMACY_FAVOR_1',           'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',                 'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_1_BUILDING_REQUIREMENTS'),
  ('GUNBOAT_DIPLOMACY_FAVOR_2',           'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',                 'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_2_BUILDING_REQUIREMENTS'),
  ('GUNBOAT_DIPLOMACY_FAVOR_3',           'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',                 'CITY_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_3_BUILDING_REQUIREMENTS'),
  ('GUNBOAT_DIPLOMACY_FAVOR',             'MODIFIER_PLAYER_ADJUST_EXTRA_FAVOR_PER_TURN',            Null);

insert or replace into ModifierArguments
  (ModifierId,                            Name,               Value)
values
  ('CHARISMATIC_LEADER_DIP_DISTRICT',     'DistrictType',     'DISTRICT_DIPLOMATIC_QUARTER'),
  ('CHARISMATIC_LEADER_DIP_DISTRICT',     'Amount',           30),
  ('CHARISMATIC_LEADER_DIP_BUILDING',     'DistrictType',     'DISTRICT_DIPLOMATIC_QUARTER'),
  ('CHARISMATIC_LEADER_DIP_BUILDING',     'Amount',           30),
  ('DIPLOMATIC_LEAGUE_SCIENCE_0',         'YieldType',        'YIELD_SCIENCE'),
  ('DIPLOMATIC_LEAGUE_SCIENCE_0',         'Amount',           2),
  ('DIPLOMATIC_LEAGUE_SCIENCE_1',         'YieldType',        'YIELD_SCIENCE'),
  ('DIPLOMATIC_LEAGUE_SCIENCE_1',         'Amount',           2),
  ('DIPLOMATIC_LEAGUE_SCIENCE_2',         'YieldType',        'YIELD_SCIENCE'),
  ('DIPLOMATIC_LEAGUE_SCIENCE_2',         'Amount',           2),
  ('DIPLOMATIC_LEAGUE_SCIENCE_3',         'YieldType',        'YIELD_SCIENCE'),
  ('DIPLOMATIC_LEAGUE_SCIENCE_3',         'Amount',           2),
  ('DIPLOMATIC_LEAGUE_FAVOR_0',           'ModifierId',       'DIPLOMATIC_LEAGUE_FAVOR'),
  ('DIPLOMATIC_LEAGUE_FAVOR_1',           'ModifierId',       'DIPLOMATIC_LEAGUE_FAVOR'),
  ('DIPLOMATIC_LEAGUE_FAVOR_2',           'ModifierId',       'DIPLOMATIC_LEAGUE_FAVOR'),
  ('DIPLOMATIC_LEAGUE_FAVOR_3',           'ModifierId',       'DIPLOMATIC_LEAGUE_FAVOR'),
  ('DIPLOMATIC_LEAGUE_FAVOR',             'Amount',           2),
  ('GUNBOAT_DIPLOMACY_SCIENCE_0',         'YieldType',        'YIELD_SCIENCE'),
  ('GUNBOAT_DIPLOMACY_SCIENCE_0',         'Amount',           4),
  ('GUNBOAT_DIPLOMACY_SCIENCE_1',         'YieldType',        'YIELD_SCIENCE'),
  ('GUNBOAT_DIPLOMACY_SCIENCE_1',         'Amount',           4),
  ('GUNBOAT_DIPLOMACY_SCIENCE_2',         'YieldType',        'YIELD_SCIENCE'),
  ('GUNBOAT_DIPLOMACY_SCIENCE_2',         'Amount',           4),
  ('GUNBOAT_DIPLOMACY_SCIENCE_3',         'YieldType',        'YIELD_SCIENCE'),
  ('GUNBOAT_DIPLOMACY_SCIENCE_3',         'Amount',           4),
  ('GUNBOAT_DIPLOMACY_FAVOR_0',           'ModifierId',       'GUNBOAT_DIPLOMACY_FAVOR'),
  ('GUNBOAT_DIPLOMACY_FAVOR_1',           'ModifierId',       'GUNBOAT_DIPLOMACY_FAVOR'),
  ('GUNBOAT_DIPLOMACY_FAVOR_2',           'ModifierId',       'GUNBOAT_DIPLOMACY_FAVOR'),
  ('GUNBOAT_DIPLOMACY_FAVOR_3',           'ModifierId',       'GUNBOAT_DIPLOMACY_FAVOR'),
  ('GUNBOAT_DIPLOMACY_FAVOR',             'Amount',           4);

insert or replace into ObsoletePolicies
	(PolicyType,							  ObsoletePolicy)
values
	('POLICY_HD_TRANSLATE', 		'POLICY_DIPLOMATIC_LEAGUE'),
	('POLICY_HD_TRANSLATE',			'POLICY_GUNBOAT_DIPLOMACY');
-----------------------------------------------------------------------
--领事馆/外交办间谍改动
insert or replace into BuildingModifiers
  (BuildingType,                          ModifierId)
values
  ('BUILDING_CHANCERY',                  'CHANCERY_OFFENSIVESPYTIME'),
  ('BUILDING_CHANCERY',                  'CHANCERY_SPYPRODUCTION'),
  ('BUILDING_CONSULATE',                 'CONSULATE_SPYPRODUCTION'),
  ('BUILDING_CONSULATE',                 'CONSULATE_SPY_UNLIMITED_PROMOTION');
insert or replace into Modifiers
  (ModifierId,                            ModifierType,                                                           SubjectRequirementSetId)
values
  ('CHANCERY_OFFENSIVESPYTIME',          'MODIFIER_PLAYER_UNITS_ADJUST_SPY_OFFENSIVE_OPERATION_TIME',            'PLAYER_HAS_BUILDING_CHANCERY_REQUIREMENTS'),
  ('CHANCERY_SPYPRODUCTION',             'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PRODUCTION',                        NULL),
  ('CONSULATE_SPYPRODUCTION',            'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION',                         'PLAYER_HAS_BUILDING_CONSULATE_REQUIREMENTS'),
  ('CONSULATE_SPY_UNLIMITED_PROMOTION',  'MODIFIER_PLAYER_UNIT_GRANT_UNLIMITED_PROMOTION_CHOICES',               'PLAYER_HAS_BUILDING_CONSULATE_REQUIREMENTS');

insert or replace into ModifierArguments
  (ModifierId,                            Name,               Value)
values
  ('CHANCERY_OFFENSIVESPYTIME',          'ReductionPercent', 15),
  ('CHANCERY_SPYPRODUCTION',             'UnitType',         'UNIT_SPY'),
  ('CHANCERY_SPYPRODUCTION',             'Amount',           50),
  ('CONSULATE_SPYPRODUCTION',            'UnitType',         'UNIT_SPY'),
  ('CONSULATE_SPYPRODUCTION',            'Amount',           50),
  ('CONSULATE_SPY_UNLIMITED_PROMOTION',  'UnitType',         'UNIT_SPY');

   
--外交办所有城市新手间谍升级探员
  
insert or replace into BuildingModifiers
  (BuildingType,                  ModifierId)
values
  ('BUILDING_CHANCERY',           'CHANCERY_GRANT_SPY_FREE_PROMOTION');

insert or replace into Modifiers    
  (ModifierId,                                      ModifierType,                                            SubjectRequirementSetId, Permanent)
values
  ('CHANCERY_GRANT_SPY_FREE_PROMOTION',             'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',                NULL,                    0),
  ('CHANCERY_GRANT_SPY_FREE_PROMOTION_MODIFIER',    'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',  NULL,                    1);

insert or replace into ModifierArguments
  (ModifierId,                                           Name,                     Value)
values
  ('CHANCERY_GRANT_SPY_FREE_PROMOTION',                  'ModifierId',             'CHANCERY_GRANT_SPY_FREE_PROMOTION_MODIFIER'),
  ('CHANCERY_GRANT_SPY_FREE_PROMOTION_MODIFIER',         'AbilityType',            'ABILITY_CHANCERY_FERR_PROMOTION');

--间谍身上的外交办免费升级能力设置和tag说明

insert or replace into Types
  (Type,                                                      Kind)
values
  ('ABILITY_CHANCERY_FERR_PROMOTION',                         'KIND_ABILITY');

insert or replace into TypeTags
  (Type,                                                      Tag)
values
  ('ABILITY_CHANCERY_FERR_PROMOTION',                         'CLASS_SPY');

insert or replace into UnitAbilities (UnitAbilityType, Name, Description, Inactive) 
values
  ('ABILITY_CHANCERY_FERR_PROMOTION',
  'LOC_ABILITY_CHANCERY_FERR_PROMOTION_NAME',
  'LOC_ABILITY_CHANCERY_FERR_PROMOTION_DESCRIPTION',
  1);

insert or replace into UnitAbilityModifiers
  (UnitAbilityType,                                       ModifierId)
values
  ('ABILITY_CHANCERY_FERR_PROMOTION',                     'HETAIROI_FREE_PROMOTION');

--外交办额外间谍容量，本城赠送1个1级间谍
insert or replace into BuildingModifiers
  (BuildingType,                              ModifierId)
values
  ('BUILDING_CHANCERY',                       'CHANCERY_SPY_CAPACITY'),
  ('BUILDING_CHANCERY',                       'CHANCERY_ADD_SPY_WITH_PROMOTION');
insert or replace into Modifiers
  (ModifierId,                            ModifierType,                                         OwnerRequirementSetId,                              SubjectRequirementSetId)
values
  ('CHANCERY_SPY_CAPACITY',              'MODIFIER_PLAYER_GRANT_SPY',                           'PLAYER_HAS_BUILDING_CHANCERY_REQUIREMENTS',        NULL),
--  ('CHANCERY_ADD_SPY_WITH_PROMOTION',    'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',             'PLAYER_HAS_BUILDING_CHANCERY_REQUIREMENTS',        NULL),
  ('CHANCERY_ADD_SPY_WITH_PROMOTION',    'MODIFIER_PLAYER_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER', NULL,                                               NULL);

update Modifiers set RunOnce = 1, Permanent = 1 where ModifierId = 'CHANCERY_SPY_CAPACITY';
update Modifiers set RunOnce = 1, Permanent = 1 where ModifierId = 'CHANCERY_ADD_SPY_WITH_PROMOTION';
insert or replace into ModifierArguments
  (ModifierId,                        Name,                       Value)
values
  ('CHANCERY_SPY_CAPACITY',           'Amount',                   1),
  ('CHANCERY_ADD_SPY_WITH_PROMOTION', 'UnitPromotionClassType',   'PROMOTION_CLASS_SPY'),
  ('CHANCERY_ADD_SPY_WITH_PROMOTION', 'ModifierId',               'HETAIROI_FREE_PROMOTION'),
  ('CHANCERY_ADD_SPY_WITH_PROMOTION', 'UnitType',                 'UNIT_SPY'),
  ('CHANCERY_ADD_SPY_WITH_PROMOTION', 'Amount',                   1);

-----------------------------------------------------------------------
--外交区地基间谍容量

insert or ignore into DistrictModifiers
  (DistrictType,                      ModifierId)
values
  -- Diplomatic Quarter
  -- ('DISTRICT_DIPLOMATIC_QUARTER',     'DIPLOMATIC_QUARTER_DUPLICATE_FIRST_INFLUENCE');
  ('DISTRICT_DIPLOMATIC_QUARTER',       'DIPLOMATIC_QUARTER_GRANTS_SPY_CAPACITY'); -- Moved to tier-1 building.


--外交区地基同盟点数 v1.4   +0.25

insert or replace into DistrictModifiers
  (DistrictType,                      ModifierId)
values
  ('DISTRICT_DIPLOMATIC_QUARTER',     'HD_DDQ_ALLIANCE_POINTS');

insert or replace into Modifiers
  (ModifierId,                                        ModifierType,                                                   SubjectRequirementSetId)
values
  ('HD_DDQ_ALLIANCE_POINTS',          'MODIFIER_PLAYER_ADJUST_ALLIANCE_POINTS',                                   NULL);

insert or replace into ModifierArguments
  (ModifierId,                                                    Name,                               Value)
values
  ('HD_DDQ_ALLIANCE_POINTS',                      'Amount',                       1);

-----------------------------------------------------------------------

update Modifiers set RunOnce = 1, Permanent = 1, SubjectRequirementSetId = NULL where ModifierId = 'DIPLOMATIC_QUARTER_AWARD_ONE_INFLUENCE_TOKEN';

-- Diplomacy Quarter Buildings
insert or replace into BuildingModifiers
  (BuildingType,                          ModifierId)
values
  ('BUILDING_CHANCERY',                   'CHANCERY_ADD_VISIBILITY'),
  -- ('BUILDING_CONSULATE',                  'MODIFIER_MAJOR_PLAYER_TRADE_ROUTE_BY_CITY_STATE_BONUS_TYPE_MODIFIER'),
  ('BUILDING_CONSULATE',                  'DIPLOMATIC_QUARTER_AWARD_ONE_INFLUENCE_TOKEN'),
  ('BUILDING_CONSULATE',                  'CONSULATE_LEVY_DISCOUNT'),
  ('BUILDING_CHANCERY',                   'DIPLOMATIC_QUARTER_AWARD_ONE_INFLUENCE_TOKEN');
  -- ('BUILDING_CHANCERY',                   'WISSELBANKEN_ALLIANCEPOINTS');
  -- ('BUILDING_CONSULATE',                  'CONSULATE_LEVY_UNITUPGRADEDISCOUNT');
  -- ('BUILDING_CONSULATE',                   'DIPLOMATIC_QUARTER_GRANTS_SPY_CAPACITY'),
  -- ('BUILDING_CONSULATE',                   'DIPLOMATIC_QUARTER_DELEGATION_FAVOR'),
  -- ('BUILDING_CONSULATE',                   'DIPLOMATIC_QUARTER_EMBASSY_FAVOR');

insert or replace into Modifiers    
  (ModifierId,                            ModifierType)
values
  ('CHANCERY_ADD_VISIBILITY',             'MODIFIER_PLAYER_ADD_DIPLO_VISIBILITY'),
  ('CONSULATE_LEVY_DISCOUNT',             'MODIFIER_PLAYER_ADJUST_LEVY_DISCOUNT_PERCENT'),
  ('CONSULATE_LEVY_UNITUPGRADEDISCOUNT',  'MODIFIER_PLAYER_ADJUST_LEVIED_UNIT_UPGRADE_DISCOUNT_PERCENT');

insert or replace into ModifierArguments
  (ModifierId,                            Name,               Value)
values
  ('CHANCERY_ADD_VISIBILITY',             'Amount',           1),
  ('CHANCERY_ADD_VISIBILITY',             'Source',           'SOURCE_CHANCERY'),
	('CHANCERY_ADD_VISIBILITY',             'SourceType',       'DIPLO_SOURCE_ALL_NAMES'),
  ('CONSULATE_LEVY_DISCOUNT',             'Percent',          20),
  ('CONSULATE_LEVY_UNITUPGRADEDISCOUNT',  'Amount',           20);

insert or replace into DiplomaticVisibilitySources
  (VisibilitySourceType,  Description,                ActionDescription,                  GossipString,                   PrereqTech)
values
  ('SOURCE_CHANCERY',     'LOC_VIZSOURCE_CHANCERY',   'LOC_VIZSOURCE_ACTION_CHANCERY',    'LOC_GOSSIP_SOURCE_CHANCERY',   'TECH_MATHEMATICS');

----------------------------------------------------------------------------------------------------
--外交办的间谍进攻/防守全局加成
insert or replace into BuildingModifiers 
  (BuildingType,                                  ModifierId) 
values
  ('BUILDING_CHANCERY',                           'CHANCERY_OFFENSE');
    
insert or replace into Modifiers    
  (ModifierId,                                    ModifierType,                       SubjectRequirementSetId,    Permanent)
values
  ('CHANCERY_OFFENSE',                            'MODIFIER_PLAYER_ADJUST_SPY_BONUS',                     NULL,   0);

insert or replace into ModifierArguments
  (ModifierId,                                        Name,               Value)
values
  ('CHANCERY_OFFENSE',                                'Offense',          1),
  ('CHANCERY_OFFENSE',                                'Amount',           1);

----------------------------------------------------------------------------------------------------
-- 宪政研究、法治现代化
insert or replace into PolicyModifiers
	(PolicyType,						ModifierId)
values
	('POLICY_HD_CONSTITUTIONAL_STUDY',	'HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_ATTACH_1'),
	('POLICY_HD_CONSTITUTIONAL_STUDY',	'HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_ATTACH_2'),
	('POLICY_HD_CONSTITUTIONAL_STUDY',	'HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_ATTACH_3'),
	('POLICY_HD_CONSTITUTIONAL_STUDY',	'HD_CONSTITUTIONAL_STUDY_GOLD_DIP_ATTACH_1'),
	('POLICY_HD_CONSTITUTIONAL_STUDY',	'HD_CONSTITUTIONAL_STUDY_GOLD_DIP_ATTACH_2'),
	('POLICY_HD_CONSTITUTIONAL_STUDY',	'HD_CONSTITUTIONAL_STUDY_GOLD_DIP_ATTACH_3');

insert or replace into Modifiers
	(ModifierId,											ModifierType,												SubjectRequirementSetId)
values
  ('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_ATTACH_1',     'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',                'HD_PLOT_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_1_BUILDING_REQUIREMENTS'),
  ('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_ATTACH_2',     'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',                'HD_PLOT_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_2_BUILDING_REQUIREMENTS'),
  ('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_ATTACH_3',     'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',                'HD_PLOT_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_3_BUILDING_REQUIREMENTS'),
  ('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_ATTACH_1',           'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',                'HD_PLOT_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_1_BUILDING_REQUIREMENTS'),
  ('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_ATTACH_2',           'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',                'HD_PLOT_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_2_BUILDING_REQUIREMENTS'),
  ('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_ATTACH_3',           'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',                'HD_PLOT_HAS_DISTRICT_DIPLOMATIC_QUARTER_TIER_3_BUILDING_REQUIREMENTS'),
  ('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_1',            'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',          'HD_OBJECT_WITHIN_6_TILES'),
  ('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_2',            'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',          'HD_OBJECT_WITHIN_6_TILES'),
  ('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_3',            'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',          'HD_OBJECT_WITHIN_6_TILES'),
  ('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_1',                  'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',          'HD_OBJECT_WITHIN_6_TILES'),
  ('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_2',                  'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',          'HD_OBJECT_WITHIN_6_TILES'),
  ('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_3',                  'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',          'HD_OBJECT_WITHIN_6_TILES');

insert or replace into ModifierArguments
	(ModifierId,											Name,				Value)
values
  ('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_ATTACH_1',     'ModifierId',       'HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_1'),
  ('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_ATTACH_2',     'ModifierId',       'HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_2'),
  ('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_ATTACH_3',     'ModifierId',       'HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_3'),
  ('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_ATTACH_1',           'ModifierId',       'HD_CONSTITUTIONAL_STUDY_GOLD_DIP_1'),
  ('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_ATTACH_2',           'ModifierId',       'HD_CONSTITUTIONAL_STUDY_GOLD_DIP_2'),
  ('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_ATTACH_3',           'ModifierId',       'HD_CONSTITUTIONAL_STUDY_GOLD_DIP_3'),
	('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_1',			'YieldType',  		'YIELD_PRODUCTION'),
	('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_1',			'Amount',			1),
	('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_2',			'YieldType',  		'YIELD_PRODUCTION'),
	('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_2',			'Amount',			1),
	('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_3',			'YieldType',  		'YIELD_PRODUCTION'),
	('HD_CONSTITUTIONAL_STUDY_PRODUCTION_DIP_3',			'Amount',			1),
	('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_1',					'YieldType',  		'YIELD_GOLD'),
	('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_1',					'Amount',			3),
	('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_2',					'YieldType',  		'YIELD_GOLD'),
	('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_2',					'Amount',			3),
	('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_3',					'YieldType',  		'YIELD_GOLD'),
	('HD_CONSTITUTIONAL_STUDY_GOLD_DIP_3',					'Amount',			3);