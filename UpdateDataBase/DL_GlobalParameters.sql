-------------------------------------
--      Balance Adjustments        --
-------------------------------------

-- adjust purchase plot cost
update GlobalParameters set Value = 40 where Name = 'PLOT_BUY_BASE_COST';
-- update GlobalParameters set Value = 4 where Name = 'CITY_MAX_BUY_PLOT_RANGE';
update GlobalParameters set Value = 8 where Name = 'PLOT_INFLUENCE_MAX_ACQUIRE_DISTANCE';

-- adjust the population food consumption.
update GlobalParameters set Value = 3 where Name = 'CITY_FOOD_CONSUMPTION_PER_POPULATION';
update GlobalParameters set Value = 3 where Name = 'YIELD_FOOD_CITY_TERRAIN_REPLACE';
update GlobalParameters set Value = 1 where Name = 'YIELD_PRODUCTION_CITY_TERRAIN_REPLACE';
    
--SPY间谍获取情报源持续时间优化（持续12T）、文化成为主流后的任务缩短时间削弱
--update GlobalParameters set Value = 2 where Name = 'ESPIONAGE_BONUS_GAIN_SOURCES';
update GlobalParameters set Value = 6 where Name = 'ESPIONAGE_GAIN_SOURCES_DURATION_MULTIPLIER';
update GlobalParameters set Value = 1 where Name = 'ESPIONAGE_MISSION_LENGTH_REDUCTION_CULTURAL_DOMINANCE';
--SPY间谍手动逃跑相关参数优化更易逃脱-但死亡率还是很高
-- update GlobalParameters set Value = 20 where Name = 'ESPIONAGE_ESCAPE_BASE_CHANCE';
-- update GlobalParameters set Value = 10 where Name = 'ESPIONAGE_ESCAPE_LEVEL_BOOST';
-- update GlobalParameters set Value = 5 where Name = 'ESPIONAGE_ESCAPE_COUNTERSPY_LEVEL_MODIFIER';
-- update GlobalParameters set Value = 1 where Name = 'ESPIONAGE_ESCAPE_POLICE_CORRECT_MODIFIER';
--SPY间谍捏造丑闻（杀使者）收益提升至基础5名使者，每1个升级+2
update GlobalParameters set Value = 3 where Name = 'ESPIONAGE_FABRICATE_SCANDAL_BASE_ENVOYS_REMOVED';
update GlobalParameters set Value = 2 where Name = 'ESPIONAGE_FABRICATE_SCANDAL_LEVEL_ENVOYS_REMOVED';
--SPY间谍暗杀总督持续时间4T，每1个升级+1（改这里不生效）
--update GlobalParameters set Value = 4 where Name = 'ESPIONAGE_NEUTRALIZE_GOVERNOR_BASE_TURNS';
--SPY间谍煽动骚乱的效果调整至55点忠诚，每1个升级+15
update GlobalParameters set Value = 0 where Name = 'ESPIONAGE_FOMENT_UNREST_LEVEL_IDENTITY_CHANGE';
update GlobalParameters set Value = -15 where Name = 'ESPIONAGE_FOMENT_UNREST_LEVEL_LOYALTY_CHANGE';
update GlobalParameters set Value = 0 where Name = 'ESPIONAGE_FOMENT_UNREST_BASE_IDENTITY_CHANGE';
update GlobalParameters set Value = -40 where Name = 'ESPIONAGE_FOMENT_UNREST_BASE_LOYALTY_CHANGE';
-- Map
-- update GlobalParameters set Value = 8 where Name = 'ICE_TILES_PERCENT';
update GlobalParameters set Value = 3 where Name = 'STRATEGIC_RESOURCE_FERTILITY_STARTING_ERA_RANGE';

-- the distance to netural wonders
update GlobalParameters set Value = 5 where Name = 'START_DISTANCE_MAJOR_NATURAL_WONDER';
update GlobalParameters set Value = 3 where Name = 'START_DISTANCE_MINOR_NATURAL_WONDER';

-- Trade Route duration: minimal > 12 (was 20), do not increase based on Era.
update GlobalParameters set Value = 12 where Name = 'TRADE_ROUTE_TURN_DURATION_BASE';
update Eras_XP2 set TradeRouteMinimumEndTurnChange = 0;

-- Change from 2 to 1. Only full sea trade route gets 100% more gold, only need half of the route before.
-- back to 1.5, double when at least 2/3 is sea.
--系数小数点无效
update GlobalParameters set Value = 1 where Name = 'TRADE_ROUTE_TRANSPORTATION_EFFICIENCY_SCORE_WATER_TILE';

update GlobalParameters set Value = 15 where Name = 'DIPLOMACY_ALLIANCE_TIME_LIMIT';
update GlobalParameters set Value = 15 where Name = 'DIPLOMACY_DECLARED_FRIENDSHIP_TIME_LIMIT';
update GlobalParameters set Value = 15 where Name = 'DIPLOMACY_DEFENSIVE_PACT_TIME_LIMIT';
update GlobalParameters set Value = 15 where Name = 'DIPLOMACY_DENOUNCE_TIME_LIMIT';

update GlobalParameters set Value = 40 where Name = 'LEVY_MILITARY_PERCENT_OF_UNIT_PURCHASE_COST';

-- ranged unit cause 75% damage to walls instead of 50% (but -17 strength still remains)
update GlobalParameters set Value = 75 where Name = 'COMBAT_DEFENSE_DAMAGE_PERCENT_RANGED';
-- COMBAT_STRENGTH_REDUCTION_INSUFFICIENT_FUEL
update GlobalParameters set Value = 15 where Name = 'UNIT_MAX_STR_REDUCTION_INSUFFICIENT_RESOURCES';
-- strategic resources
update Resource_Consumption set ImprovedExtractionRate = ImprovedExtractionRate + 1;
update Resource_Consumption set StockpileCap = 100 where StockpileCap = 50;
-- Plunder
update Improvements set PlunderType = 'PLUNDER_GOLD' where ImprovementType = 'IMPROVEMENT_FISHERY';
update Improvements set PlunderAmount = 25 where PlunderType = 'PLUNDER_HEAL';

-- Great person poinst
update GlobalParameters set Value = 0.5 where Name = 'FAITH_PER_UNUSED_GREAT_PERSON_POINT';

-- pantheon
update GlobalParameters set Value = 30 where Name = 'RELIGION_PANTHEON_MIN_FAITH';

-- Ally 同盟点数需求
update GlobalParameters set Value = 240 where Name = 'ALLIANCE_LEVEL_TWO_XP'; --60点数到2级
update GlobalParameters set Value = 560 where Name = 'ALLIANCE_LEVEL_THREE_XP';--原版风云960，（560-240）/4=80点数到3级

-- Suzerain
update GlobalParameters set Value = 3 where Name = 'INFLUENCE_TOKENS_MINIMUM_FOR_SUZERAIN';

-- City states
INSERT OR IGNORE INTO Requirements
        (RequirementId,                             RequirementType                                 )
VALUES  ('REQUIRES_PLAYER_HAS_LARGEST_INFLUENCE',   'REQUIREMENT_PLAYER_HAS_GIVEN_INFLUENCE_TOKENS' );
INSERT OR IGNORE INTO RequirementArguments
        (RequirementId,                             Name,               Value)
VALUES  ('REQUIRES_PLAYER_HAS_LARGEST_INFLUENCE',   'MinimumTokens',    10);
update RequirementArguments set Value = 1 where RequirementId = 'REQUIRES_PLAYER_HAS_SMALL_INFLUENCE' and Name = 'MinimumTokens';
update RequirementArguments set Value = 3 where RequirementId = 'REQUIRES_PLAYER_HAS_MEDIUM_INFLUENCE' and Name = 'MinimumTokens';
update RequirementArguments set Value = 6 where RequirementId = 'REQUIRES_PLAYER_HAS_LARGE_INFLUENCE' and Name = 'MinimumTokens';
-- The New Global Parameters.
insert or replace into GlobalParameters
    (Name,                                              Value)
values
    ('INFLUENCE_TOKENS_MINIMUM_FOR_SMALL_INFLUENCE',    1),
    ('INFLUENCE_TOKENS_MINIMUM_FOR_MEDIUM_INFLUENCE',   3),
    ('INFLUENCE_TOKENS_MINIMUM_FOR_LARGE_INFLUENCE',    6),
    ('INFLUENCE_TOKENS_MINIMUM_FOR_LARGEST_INFLUENCE',  10); 

-- Religion pressure
update GlobalParameters set Value = 2 where Name = 'RELIGION_SPREAD_ADJACENT_PER_TURN_PRESSURE';
update GlobalParameters set Value = 2 where Name = 'RELIGION_SPREAD_TRADE_ROUTE_PRESSURE_FOR_DESTINATION';
update GlobalParameters set Value = 2 where Name = 'RELIGION_SPREAD_TRADE_ROUTE_PRESSURE_FOR_ORIGIN';

-- Neutralize turns
update GlobalParameters set Value = 4 where Name = 'ESPIONAGE_NEUTRALIZE_GOVERNOR_BASE_TURNS';

-- Barbarian camp
-- the distance to barbarian camp
update GlobalParameters set Value = 6 where Name = 'BARBARIAN_CAMP_MINIMUM_DISTANCE_CITY';

-- let the barbarian camp start raid with higher threshold (20 turns after the camp being created).
update BarbarianTribes set RaidingBoldness = 40 where RaidingBehaviorTree = 'Barbarian Attack';
update BarbarianTribes set CityAttackBoldness = 20 where RaidingBehaviorTree = 'Barbarian City Assault';
update BarbarianTribes set ResourceRange = 2 where TribeType = 'TRIBE_CAVALRY';
update GlobalParameters set Value = -20 where Name = 'BARBARIAN_BOLDNESS_PER_CAMP_ATTACK';
-- AiFavoredItems, Default Barbarian, Chase Target

-- free amenity
update Buildings set Entertainment = 1 where BuildingType = 'BUILDING_PALACE';
update GlobalParameters set Value = 1 where Name = 'CITY_AMENITIES_FOR_FREE';
-- district population require
update GlobalParameters set Value = 3 where Name = 'DISTRICT_POPULATION_REQUIRED_PER';
-- update the City Growth Formula.
update GlobalParameters set Value = 16 where Name = 'CITY_GROWTH_THRESHOLD';
update GlobalParameters set Value = 7 where Name = 'CITY_GROWTH_MULTIPLIER';
update GlobalParameters set Value = 2.05 where Name = 'CITY_GROWTH_EXPONENT';
update GlobalParameters set Value = -9 where Name = 'CITY_GROWTH_OCCUPATION_MULTIPLIER';

update GlobalParameters set Value = 2 where Name = 'CITY_POP_PER_AMENITY';

-- Enable districts/wonders placement on GEOTHERMAL_FISSURE and REEF
insert or replace into Features_XP2 (FeatureType, ValidWonderPlacement, ValidDistrictPlacement, ValidForReplacement) values 
	('FEATURE_GEOTHERMAL_FISSURE', 1, 1, 1);
insert or replace into Features_XP2 (FeatureType, ValidWonderPlacement, ValidDistrictPlacement, ValidForReplacement) values 
	('FEATURE_REEF', 1, 1, 1);

-- change era minimum turns
update Eras_XP1 set GameEraMinimumTurns = 20, GameEraMaximumTurns = 44 where EraType = 'ERA_ANCIENT';
update Eras_XP1 set GameEraMinimumTurns = 15, GameEraMaximumTurns = 20 where EraType = 'ERA_CLASSICAL';
update Eras_XP1 set GameEraMinimumTurns = 15, GameEraMaximumTurns = 20 where EraType in ('ERA_MEDIEVAL', 'ERA_RENAISSANCE', 'ERA_INDUSTRIAL');
update Eras_XP1 set GameEraMinimumTurns = 20, GameEraMaximumTurns = 40 where EraType in ('ERA_MODERN', 'ERA_ATOMIC', 'ERA_INFORMATION');
update GlobalParameters set Value = 10 where Name = 'THRESHOLD_SHIFT_PER_PAST_GOLDEN_AGE';
update GlobalParameters set Value = -10 where Name = 'THRESHOLD_SHIFT_PER_PAST_DARK_AGE';
update GlobalParameters set Value = 2 where Name = 'THRESHOLD_SHIFT_PER_CITY';

-- Slower Barbarian tech.
update GlobalParameters set Value = 60 where Name = 'BARBARIAN_TECH_PERCENT';
-- no trade route quest for city states
delete from Quests where QuestType = 'QUEST_SEND_TRADE_ROUTE';
delete from Quests where QuestType = 'QUEST_CONVERT_CAPITAL_TO_RELIGION';

update BonusMinorStartingUnits set DifficultyDelta = 0.5 where Unit = 'UNIT_WARRIOR' and Era = 'ERA_ANCIENT' and MinDifficulty = 'DIFFICULTY_EMPEROR';
update BonusMinorStartingUnits set DifficultyDelta = 0.5 where Unit = 'UNIT_WARRIOR' and Era = 'ERA_CLASSICAL' and MinDifficulty = 'DIFFICULTY_EMPEROR';

-- Loyalty pressure

-- minor civs 1.37改为100防止被埃莉诺压下来
update GlobalParameters set Value = 100 where Name = 'IDENTITY_PER_TURN_FROM_CITY_STATES';

-- Bug Fix
update BarbarianAttackForces set SiegeTag = 'CLASS_HEAVY_CAVALRY' where AttackForceType = 'HighDifficultyCavalryAttack';

--allow to level 2 for beating barb
update GlobalParameters set Value = 3 where Name = 'EXPERIENCE_MAX_BARB_LEVEL';

--double trade alliance points 
update GlobalParameters set Value = 2 where Name = 'ALLIANCE_POINTS_FOR_TRADE';

--research agreement time 3级研究同盟每次送尤里卡需要的回合数
update ModifierArguments set Value = 5 where ModifierId = 'ALLIANCE_RESEARCH_AGREEMENT';

-- The New Global Parameters.
insert or replace into GlobalParameters
    (Name,                                              Value)
values
    ('EXPANDED_INIT_VISION_RANGE',                      3),
    ('REYNA_CONVERT_PERCENTAGE',                        100),
    ('LIANG_WONDER_GREAT_ENGINEER_PERCENTAGE',          25),
    ('DEVINE_INSPIRATION_WONDER_FAITH_PERCENTAGE',      33),
    ('MAGNUS_GENERAL_SERVICES_OFFICE_EFFECT_DISTANCE',  8),
    ('GOLD_FOR_EVERY_ERA_SCORE',                        5),
    ('MALI_EXTRA_GOLD_FOR_EVERY_ERA_SCORE',             10),
    ('AMERICA_GOLD_FROM_EVERY_PLOTS',                   10),
    ('AMERICA_GOLD_FROM_LUXURY_AND_STRATEGIC',          20),
    ('AMERICA_FAITH_FROM_NATURAL_WONDERS',              20),
    -- ('TURNS_BEFORE_DESTROY_AFTER_PILLAGE',              5),
    ('OCCUPATION_GOLD_PER_POP',                         30),
    ('HD_CITY_ROADS_REQUIRE_WHEEL',                     1),
    ('GENERATE_NEW_GOODY_HUTS_FOR_EVERY',               3);

-- Turns & Years Mapping. 
delete from GameSpeed_Turns;
insert or replace into GameSpeed_Turns
    (GameSpeedType,         MonthIncrement, TurnsPerIncrement)
values
    ('GAMESPEED_MARATHON',  360,            100),
    ('GAMESPEED_MARATHON',  240,            75),
    ('GAMESPEED_MARATHON',  120,            85),
    ('GAMESPEED_MARATHON',  72,             60),
    ('GAMESPEED_MARATHON',  36,             60),
    ('GAMESPEED_MARATHON',  12,             60),
    ('GAMESPEED_MARATHON',  6,              80),
    ('GAMESPEED_MARATHON',  3,              980),
    ('GAMESPEED_EPIC',      480,            75),
    ('GAMESPEED_EPIC',      360,            50),
    ('GAMESPEED_EPIC',      360,            30),
    ('GAMESPEED_EPIC',      120,            30),
    ('GAMESPEED_EPIC',      72,             30),
    ('GAMESPEED_EPIC',      24,             30),
    ('GAMESPEED_EPIC',      12,             50),
    ('GAMESPEED_EPIC',      12,             80),
    ('GAMESPEED_EPIC',      6,              375),
    ('GAMESPEED_STANDARD',  720,            50),
    ('GAMESPEED_STANDARD',  600,            30),
    ('GAMESPEED_STANDARD',  360,            30),
    ('GAMESPEED_STANDARD',  120,            30),
    ('GAMESPEED_STANDARD',  72,             30),
    ('GAMESPEED_STANDARD',  36,             20),
    ('GAMESPEED_STANDARD',  24,             20),
    ('GAMESPEED_STANDARD',  12,             40),
    ('GAMESPEED_STANDARD',  6,              250),
    ('GAMESPEED_QUICK',     900,            40),
    ('GAMESPEED_QUICK',     840,            25),
    ('GAMESPEED_QUICK',     480,            20),
    ('GAMESPEED_QUICK',     240,            20),
    ('GAMESPEED_QUICK',     120,            20),
    ('GAMESPEED_QUICK',     36,             15),
    ('GAMESPEED_QUICK',     24,             15),
    ('GAMESPEED_QUICK',     12,             15),
    ('GAMESPEED_QUICK',     6,              160),
    ('GAMESPEED_ONLINE',    1200,           30),
    ('GAMESPEED_ONLINE',    900,            20),
    ('GAMESPEED_ONLINE',    600,            15),
    ('GAMESPEED_ONLINE',    360,            15),
    ('GAMESPEED_ONLINE',    144,            15),
    ('GAMESPEED_ONLINE',    48,             15),
    ('GAMESPEED_ONLINE',    36,             15),
    ('GAMESPEED_ONLINE',    24,             15),
    ('GAMESPEED_ONLINE',    12,             110);

-- Art move lock
update GlobalParameters set Value = 0 where Name = 'GREATWORK_ART_LOCK_TIME';
--市中心改为3粮2锤
update GlobalParameters set Value = 2 where Name = 'YIELD_PRODUCTION_CITY_TERRAIN_REPLACE';

-- 允许政体有空槽位
update GlobalParameters set Value = 'true' where Name = 'GOVERNMENT_ALLOW_EMPTY_POLICY_SLOTS';

-- 刷战略
create table HD_GuaranteedStrategicResources (
	ResourceType text not null primary key,
	Distance int not null,
	foreign key (ResourceType) references Resources (ResourceType) on delete cascade on update cascade
);
insert or replace into HD_GuaranteedStrategicResources
	(ResourceType,			Distance)
values
	('RESOURCE_HORSES',		4),
	('RESOURCE_IRON',		4),
	('RESOURCE_NITER',		6),
	('RESOURCE_COAL',		6),
	('RESOURCE_ALUMINUM',	8),
	('RESOURCE_OIL',		8),
	('RESOURCE_URANIUM',	8);
--删除政体业绩debuff
update GlobalParameters set Value = 0 where Name = 'TOURISM_CONFLICTING_GOVERNMENT_MULTIPLIER';

--单次经验上限
update GlobalParameters set Value = 32 where Name = 'EXPERIENCE_MAXIMUM_ONE_COMBAT';

--飞天光年数
update GlobalParameters set Value = 50 where Name = 'SCIENCE_VICTORY_POINTS_REQUIRED';

--征兵回合数
update GlobalParameters set Value = 15 where Name = 'LEVY_MILITARY_TURN_DURATION';

--征兵花费
update GlobalParameters set Value = 60 where Name = 'LEVY_MILITARY_PERCENT_OF_UNIT_PURCHASE_COST';

--征兵升级保底战略花费
update GlobalParameters set Value = 10 where Name = 'UPGRADE_MINIMUM_COST_LEVY';

--军事单位升级力差倍率*2
update GlobalParameters set Value = 100 where Name = 'UPGRADE_NET_PRODUCTION_PERCENT_COST';
--update GlobalParameters set Value = 4 where Name = 'RANDOM_EVENT_START_TURN';

-- 间谍
update GlobalParameters set Value = 5 where Name = 'ESPIONAGE_MAX_LEVEL';