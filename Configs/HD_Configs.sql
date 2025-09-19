-------------------------------------
--             Configs             --
-------------------------------------

-- -- Defaults
-- update Parameters set DefaultValue = 'GAMESPEED_QUICK' where ParameterId = 'GameSpeeds' and SupportsSinglePlayer = 0;

-- No longer supports WE
-- update Parameters set DefaultValue = 1 where ParameterId = 'WER_ADD_STEEL_N_THUNDER_UU';
-- delete from Parameters where ParameterId = 'WER_ADD_STEEL_N_THUNDER_UU';

-- Take your time
update Parameters set DefaultValue = 33 where ParameterId = 'TechnologyBoostAmount';
update Parameters set DefaultValue = 33 where ParameterId = 'CivicBoostAmount';

update Parameters set DefaultValue = 1 where ParameterId = 'GameMode_Suk_Oceans';
-- delete from Parameters where ParameterId = 'GameMode_TowerDefense'; 
update Parameters set DefaultValue = 0 where ParameterId = 'CSE_Favor_Suzerain';
-- update Parameters set DefaultValue = 0 where ParameterId = 'CSE_Favor_Consular';
update Parameters set DefaultValue = 0 where ParameterId = 'CSE_CityState_Walls';
update Parameters set DefaultValue = 0 where ParameterId = 'CSE_Ethiopia_Mode';
delete from Parameters where ParameterId = 'CSE_CityState_Walls';
delete from Parameters where ParameterId = 'CSE_Ethiopia_Mode';

insert or replace into Parameters
    (Key1,      Key2,                   ParameterId,                    Name,                                       Description,
    Domain,     DefaultValue,   ConfigurationGroup, ConfigurationId,                        GroupId,            SortIndex)
values
    ('Ruleset', 'RULESET_EXPANSION_2',  'CityStatesStartWithWalls',     'LOC_GAME_CITY_STATES_START_WITH_WALLS',    'LOC_GAME_CITY_STATES_START_WITH_WALLS_DESCRIPTION',
    'bool',     1,              'Game',             'GAME_CITY_STATES_START_WITH_WALLS',    'AdvancedOptions',  2019),
    ('Ruleset', 'RULESET_EXPANSION_2',  'PostponeWorldCongress',        'LOC_GAME_POSTPONE_WORLD_CONGRESS',         'LOC_GAME_POSTPONE_WORLD_CONGRESS_DESCRIPTION',
    'bool',     1,              'Game',             'GAME_POSTPONE_WORLD_CONGRESS',         'AdvancedOptions',  2020),
    ('Ruleset', 'RULESET_EXPANSION_2',  'CapturedSettlersAsBuilders',   'LOC_GAME_CAPTURE_SETTLERS_AS_BUILDERS',    'LOC_GAME_CAPTURE_SETTLERS_AS_BUILDERS_DESCRIPTION',
    'bool',     0,              'Game',             'GAME_CAPTURE_SETTLERS_AS_BUILDERS',    'AdvancedOptions',  2021),
    ('Ruleset', 'RULESET_EXPANSION_2',  'AIGetCopyforMilitaryUnits',    'LOC_GAME_AI_GET_COPY_FOR_MILITARY_UNITS',  'LOC_GAME_AI_GET_COPY_FOR_MILITARY_UNITS_DESCRIPTION',
    'bool',     0,              'Game',             'GAME_AI_GET_COPY_FOR_MILITARY_UNITS',  'AdvancedOptions',  2022),
    ('Ruleset', 'RULESET_EXPANSION_2',  'ForeverWar',                   'LOC_GAME_FOREVER_WAR',                     'LOC_GAME_FOREVER_WAR_DESCRIPTION',
    'bool',     0,              'Game',             'GAME_FOREVER_WAR',                     'AdvancedOptions',  2023),

    ('Ruleset', 'RULESET_EXPANSION_2',  'HistoricalReligions',          'LOC_GAME_HISTORICAL_RELIGIONS',          	'LOC_GAME_HISTORICAL_RELIGIONS_DESCRIPTION',
    'bool',     0,              'Game',             'GAME_HISTORICAL_RELIGIONS',            'AdvancedOptions',  2025),
    -- 测试用
    ('Ruleset', 'RULESET_EXPANSION_2',  'TestingOption',                'LOC_GAME_TESTING_OPTION',                  'LOC_GAME_TESTING_OPTION_DESCRIPTION',
    'bool',     0,              'Game',             'GAME_TESTING_OPTION',                  'AdvancedOptions',  2026);

-- update MapStartPositions set Plot = 6194 where 
--     Map="{4873eb62-8ccc-4574-b784-dda455e74e68}Maps/EarthMaps/TSLWorldMapHuge_XP2.Civ6Map" and Type="LEADER" and Value="LEADER_MINOR_CIV_HONG_KONG";
-- update MapStartPositions set Plot = 6194 where 
--     Map="../../Assets/Maps/EarthMaps/TSLWorldMapHuge.Civ6Map" and Type="LEADER" and Value="LEADER_MINOR_CIV_HONG_KONG";

insert or replace into MapStartPositions (Map, Plot, Type, Value) values
    ("{4873eb62-8ccc-4574-b784-dda455e74e68}Maps/EarthMaps/TSLEarthStandard_XP2.Civ6Map",   3665,   "LEADER",   "LEADER_MINOR_CIV_HONG_KONG"),
    ("../../Assets/Maps/EarthMaps/TSLEarthStandard.Civ6Map",                                3665,   "LEADER",   "LEADER_MINOR_CIV_HONG_KONG"),
    ("{4873eb62-8ccc-4574-b784-dda455e74e68}Maps/EarthMaps/TSLWorldMapHuge_XP2.Civ6Map",    6194,   "LEADER",   "LEADER_MINOR_CIV_HONG_KONG"),
    ("../../Assets/Maps/EarthMaps/TSLWorldMapHuge.Civ6Map",                                 6194,   "LEADER",   "LEADER_MINOR_CIV_HONG_KONG");

--关掉埃及弯刀在主菜单的显示
--delete from PlayerItems where Description = 'LOC_UNIT_EGYPTIAN_KHOPESH_DESCRIPTION' and Type = 'UNIT_EGYPTIAN_KHOPESH';

