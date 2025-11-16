-------------------------------------
--         Units Adjustments       --
-------------------------------------
-- DL_RemoveGameCostEscalation
update Units set
	CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES',
	CostProgressionParam1 = 5,
	Cost = 40
where UnitType = 'UNIT_TRADER';

update Units set
	CostProgressionModel = 'NO_COST_PROGRESSION',
	CostProgressionParam1 = 0
where UnitType = 'UNIT_LAHORE_NIHANG';

update Units set Cost = 75, CostProgressionParam1 = 5 where UnitType = 'UNIT_MISSIONARY';
update Units set Cost = 150, CostProgressionParam1 = 10 where UnitType = 'UNIT_APOSTLE';
update Units set Cost = 75, CostProgressionParam1 = 5 where UnitType = 'UNIT_INQUISITOR';
update Units set Cost = 120, CostProgressionParam1 = 10 where UnitType = 'UNIT_GURU';

update Units set Cost = 250 where UnitType = 'UNIT_ARCHAEOLOGIST';
-- add worker's basic building charges
update Units set BuildCharges = 4 where UnitType = 'UNIT_BUILDER' and BuildCharges < 4;
update Units set BuildCharges = 3, BaseMoves = 3 where UnitType = 'UNIT_MILITARY_ENGINEER';

-- UNIT_MILITARY_ENGINEER
update Routes_XP2 set BuildWithUnitChargeCost = 0;
update District_BuildChargeProductions set PercentProductionPerCharge = 30;
insert or replace into Route_ResourceCosts
    (RouteType,                 ResourceType,       BuildWithUnitCost)
values
    ('ROUTE_ANCIENT_ROAD',      'RESOURCE_HORSES',  1),
    ('ROUTE_MEDIEVAL_ROAD',     'RESOURCE_HORSES',  1),
    ('ROUTE_INDUSTRIAL_ROAD',   'RESOURCE_IRON',    1),
    ('ROUTE_MODERN_ROAD',       'RESOURCE_IRON',    1);

insert or replace into Route_ValidBuildUnits
    (RouteType,                 UnitType)
values
    ('ROUTE_ANCIENT_ROAD',      'UNIT_ROMAN_LEGION'),
    ('ROUTE_MEDIEVAL_ROAD',     'UNIT_ROMAN_LEGION');
/*
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
    ('BUILDING_ARMORY',				'ARMORY_MILITARY_ENGINEER_PURCHASE_DISCOUNT');

insert or replace into Modifiers
	(ModifierId,											ModifierType)
values
	('ARMORY_MILITARY_ENGINEER_PURCHASE_GOLD_DISCOUNT',		'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST');

insert or replace into ModifierArguments
	(ModifierId,									    Name,			Value)
values
	('ARMORY_MILITARY_ENGINEER_PURCHASE_GOLD_DISCOUNT',	'UnitType',	    'UNIT_MILITARY_ENGINEER'),
    ('ARMORY_MILITARY_ENGINEER_PURCHASE_GOLD_DISCOUNT',	'Amount',	    20);*/
--SPY间谍价格和涨价方式-暂时参考了HD使徒和传教士-但它显得不那么耐用
-----------------------------------------------------------------------
update Units set
	CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES',
	CostProgressionParam1 = 15,
	Cost = 60,
	PurchaseYield = 'YIELD_GOLD',
	Maintenance = 1,
	Stackable = 1,
	NumRandomChoices = 0
where UnitType = 'UNIT_SPY';
-----------------------------------------------------------------------
--爱护玩家-SPY间谍玩家专属防守全局加成6级
insert or replace into BuildingModifiers 
    (BuildingType,                                  ModifierId) 
values
    ('BUILDING_PALACE',                             'HD_SPY_LOVE_AND_PEACE');

insert or replace into Modifiers    
    (ModifierId,                                    ModifierType,                       SubjectRequirementSetId,   Permanent)
values
    ('HD_SPY_LOVE_AND_PEACE',                       'MODIFIER_PLAYER_ADJUST_SPY_BONUS',       'PLAYER_IS_HUMAN',   1);
insert or replace into ModifierArguments
    (ModifierId,                                    Name,               Value)
values
    ('HD_SPY_LOVE_AND_PEACE',                       'Offense',          0),
    ('HD_SPY_LOVE_AND_PEACE',                       'Amount',           6);
----------------------------------------------
--间谍名字增加避免重名
-- insert or replace into CivilizationCitizenNames (CivilizationType, CitizenName, Female, Modern)
-- select a.CivilizationType, b.CitizenName, 0, 0
-- from Civilizations a, CivilizationCitizenNames b 
-- where a.StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV' and a.CivilizationType != b.CivilizationType and b.CitizenName like 'LOC_CITIZEN_%_MALE_%';
-- insert or replace into CivilizationCitizenNames (CivilizationType, CitizenName, Female, Modern)
-- select a.CivilizationType, b.CitizenName, 1, 0
-- from Civilizations a, CivilizationCitizenNames b 
-- where a.StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV' and a.CivilizationType != b.CivilizationType and b.CitizenName like 'LOC_CITIZEN_%_FEMALE_%';
-- insert or replace into CivilizationCitizenNames (CivilizationType, CitizenName, Female, Modern)
-- select a.CivilizationType, b.CitizenName, 0, 1
-- from Civilizations a, CivilizationCitizenNames b 
-- where a.StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV' and a.CivilizationType != b.CivilizationType and b.CitizenName like 'LOC_CITIZEN_%_MODERN_MALE_%';
-- insert or replace into CivilizationCitizenNames (CivilizationType, CitizenName, Female, Modern)
-- select a.CivilizationType, b.CitizenName, 1, 1
-- from Civilizations a, CivilizationCitizenNames b 
-- where a.StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV' and a.CivilizationType != b.CivilizationType and b.CitizenName like 'LOC_CITIZEN_%_MODERN_FEMALE_%';
----------------------------------------------
--SPY 间谍出击任务成功率，T数调整，其他相关内容多在DL_GlobalParameters全局参数表
--删除招募叛军
delete from UnitOperations where OperationType = 'UNITOPERATION_SPY_RECRUIT_PARTISANS';
--获取情报源，在全局参数表改动了持续时间
update UnitOperations set Turns = 2           		where OperationType = 'UNITOPERATION_SPY_GAIN_SOURCES';
--建立情报站（外交能见度）从8T改4T
update UnitOperations set Turns = 4           		where OperationType = 'UNITOPERATION_SPY_LISTENING_POST';
--捏造丑闻
update UnitOperations set BaseProbability = 13 		where OperationType = 'UNITOPERATION_SPY_FABRICATE_SCANDAL';
update UnitOperations set LevelProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_FABRICATE_SCANDAL';
update UnitOperations set Turns = 8           		where OperationType = 'UNITOPERATION_SPY_FABRICATE_SCANDAL';
--煽动骚乱
update UnitOperations set BaseProbability = 11 		where OperationType = 'UNITOPERATION_SPY_FOMENT_UNREST';
update UnitOperations set LevelProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_FOMENT_UNREST';
update UnitOperations set Turns = 4            		where OperationType = 'UNITOPERATION_SPY_FOMENT_UNREST';	
update UnitOperations set EnemyProbChange = 0  		where OperationType = 'UNITOPERATION_SPY_FOMENT_UNREST';
update UnitOperations set EnemylevelProbChange = 5  where OperationType = 'UNITOPERATION_SPY_FOMENT_UNREST';	
--抽取资金
update UnitOperations set BaseProbability = 14 		where OperationType = 'UNITOPERATION_SPY_SIPHON_FUNDS';
update UnitOperations set LevelProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_SIPHON_FUNDS';
update UnitOperations set Turns = 8            		where OperationType = 'UNITOPERATION_SPY_SIPHON_FUNDS';	
update UnitOperations set EnemyProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_SIPHON_FUNDS';
update UnitOperations set EnemylevelProbChange = 5  where OperationType = 'UNITOPERATION_SPY_SIPHON_FUNDS';
--陷害总督
update UnitOperations set BaseProbability = 19 		where OperationType = 'UNITOPERATION_SPY_NEUTRALIZE_GOVERNOR';
update UnitOperations set LevelProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_NEUTRALIZE_GOVERNOR';
update UnitOperations set Turns = 8           		where OperationType = 'UNITOPERATION_SPY_NEUTRALIZE_GOVERNOR';	
update UnitOperations set EnemyProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_NEUTRALIZE_GOVERNOR';
update UnitOperations set EnemylevelProbChange = 5  where OperationType = 'UNITOPERATION_SPY_NEUTRALIZE_GOVERNOR';
--破坏生产
update UnitOperations set BaseProbability = 17 		where OperationType = 'UNITOPERATION_SPY_SABOTAGE_PRODUCTION';
update UnitOperations set LevelProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_SABOTAGE_PRODUCTION';	
update UnitOperations set Turns = 6            		where OperationType = 'UNITOPERATION_SPY_SABOTAGE_PRODUCTION';
update UnitOperations set EnemyProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_SABOTAGE_PRODUCTION';
update UnitOperations set EnemylevelProbChange = 5  where OperationType = 'UNITOPERATION_SPY_SABOTAGE_PRODUCTION';	
--破坏堤坝
update UnitOperations set BaseProbability = 18 		where OperationType = 'UNITOPERATION_SPY_BREACH_DAM';
update UnitOperations set LevelProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_BREACH_DAM';
update UnitOperations set Turns = 6            		where OperationType = 'UNITOPERATION_SPY_BREACH_DAM';
update UnitOperations set EnemyProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_BREACH_DAM';
update UnitOperations set EnemylevelProbChange = 5  where OperationType = 'UNITOPERATION_SPY_BREACH_DAM';
--窃取科技提升
update UnitOperations set BaseProbability = 10 		where OperationType = 'UNITOPERATION_SPY_STEAL_TECH_BOOST';
update UnitOperations set LevelProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_STEAL_TECH_BOOST';	
update UnitOperations set Turns = 4            		where OperationType = 'UNITOPERATION_SPY_STEAL_TECH_BOOST';	
update UnitOperations set EnemyProbChange = 0  		where OperationType = 'UNITOPERATION_SPY_STEAL_TECH_BOOST';
update UnitOperations set EnemylevelProbChange = 5  where OperationType = 'UNITOPERATION_SPY_STEAL_TECH_BOOST';	
--盗取巨作
update UnitOperations set BaseProbability = 13 		where OperationType = 'UNITOPERATION_SPY_GREAT_WORK_HEIST';
update UnitOperations set LevelProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_GREAT_WORK_HEIST';	
update UnitOperations set Turns = 6            		where OperationType = 'UNITOPERATION_SPY_GREAT_WORK_HEIST';
update UnitOperations set EnemyProbChange = 0  		where OperationType = 'UNITOPERATION_SPY_GREAT_WORK_HEIST';
update UnitOperations set EnemylevelProbChange = 5  where OperationType = 'UNITOPERATION_SPY_GREAT_WORK_HEIST';
--破坏火箭研究
update UnitOperations set BaseProbability = 20 		where OperationType = 'UNITOPERATION_SPY_DISRUPT_ROCKETRY';
update UnitOperations set LevelProbChange = 3  		where OperationType = 'UNITOPERATION_SPY_DISRUPT_ROCKETRY';	
update UnitOperations set Turns = 16            	where OperationType = 'UNITOPERATION_SPY_DISRUPT_ROCKETRY';
update UnitOperations set EnemyProbChange = 6  		where OperationType = 'UNITOPERATION_SPY_DISRUPT_ROCKETRY';
update UnitOperations set EnemylevelProbChange = 5  where OperationType = 'UNITOPERATION_SPY_DISRUPT_ROCKETRY';
--SPY MOVE -间谍移动到其他文明的城市所需时间减少3T
update UnitOperations set Turns = 0            		where OperationType = 'UNITOPERATION_SPY_TRAVEL_NEW_CITY';

-- Worrior monk and nihang can have siege_tower and Battering_ram bonus
update Units set ObsoleteCivic = null where UnitType = 'UNIT_SIEGE_TOWER';	
update Units set ObsoleteCivic = null where UnitType = 'UNIT_BATTERING_RAM';

update UnitUpgrades set UpgradeUnit = 'UNIT_OBSERVATION_BALLOON' where Unit = 'UNIT_SIEGE_TOWER';
update Units set PrereqTech = 'TECH_STEAM_POWER' where UnitType = 'UNIT_OBSERVATION_BALLOON';

-------------------------------------
-- Testing Adjustments for units   --
-------------------------------------

update Units set PrereqTech = 'TECH_CONSTRUCTION' where UnitType = 'UNIT_CATAPULT';
update Units set PrereqTech = 'TECH_CONSTRUCTION' where UnitType = 'UNIT_ROMAN_ONAGER'; -- ST
update Units set PrereqTech = 'TECH_CONSTRUCTION' where UnitType = 'UNIT_MACEDONIAN_BALLISTA'; -- ST
update Units set PrereqTech = 'TECH_APPRENTICESHIP' where UnitType = 'UNIT_AXE_THROWER'; -- WE
update Units set PrereqTech = 'TECH_GUNPOWDER' where UnitType = 'UNIT_REITER'; -- WE
update Units set PrereqTech = 'TECH_MILITARY_TACTICS' where UnitType = 'UNIT_ARQUEBUSIER'; -- WE
update Units set PrereqTech = 'TECH_MILITARY_TACTICS' where UnitType = 'UNIT_STRADIOT'; -- WE
update Units set PrereqTech = 'TECH_METAL_CASTING' where UnitType = 'UNIT_MAN_AT_ARMS';
update Units set PrereqTech = 'TECH_METAL_CASTING' where UnitType = 'UNIT_NORWEGIAN_BERSERKER';
update Units set PrereqTech = 'TECH_METAL_CASTING' where UnitType = 'UNIT_GEORGIAN_KHEVSURETI';
update Units set PrereqTech = 'TECH_METAL_CASTING' where UnitType = 'UNIT_ZULU_IMPI';
update Units set PrereqTech = 'TECH_METAL_CASTING' where UnitType = 'UNIT_PIKEMAN';
update Units set PrereqTech = 'TECH_METAL_CASTING' where UnitType = 'UNIT_SCOTTISH_GALLOWGLASS';   -- ST
update Units set PrereqTech = 'TECH_MILITARY_TACTICS' where UnitType = 'UNIT_PIKE_AND_SHOT';
update Units set PrereqTech = 'TECH_SIEGE_TACTICS' where UnitType = 'UNIT_BOMBARD';
update Units set PrereqCivic = 'CIVIC_EXPLORATION' where UnitType = 'UNIT_PRIVATEER'; 

-- 调整单位过期科技。
update Units set MandatoryObsoleteTech = 'TECH_MILITARY_TACTICS' where MandatoryObsoleteTech = 'TECH_METAL_CASTING';

-- Special:
-- TODO: set LU as UU for Arabia, change player information.

-- Costs
update Units set Cost = 25 where UnitType = 'UNIT_SCOUT';
update Units set Cost = 25 where UnitType = 'UNIT_SLINGER';
update Units set Cost = 30 where UnitType = 'UNIT_WARRIOR';
update Units set Cost = 110 where UnitType = 'UNIT_MILITARY_ENGINEER';

-- Melee
update Units set Cost = 60, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 35, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_SWORDSMAN';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_SWORDSMAN';
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 45, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_MAN_AT_ARMS';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_MAN_AT_ARMS';
update Units set Cost = 140, Maintenance = 4, BaseMoves = 2, Range = 0, Combat = 55, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_MUSKETMAN';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_MUSKETMAN';
update Units set Cost = 210, Maintenance = 5, BaseMoves = 2, Range = 0, Combat = 65, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_LINE_INFANTRY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_LINE_INFANTRY';
-- Special Cases: UNIT_INFANTRY
update Units set Cost = 310, Maintenance = 6, BaseMoves = 3, Range = 0, Combat = 75, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_INFANTRY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_INFANTRY';
update Units set Cost = 690, Maintenance = 8, BaseMoves = 3, Range = 0, Combat = 95, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_MECHANIZED_INFANTRY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_MECHANIZED_INFANTRY';

-- Anti Cavalry
update Units set Cost = 45, Maintenance = 1, BaseMoves = 2, Range = 0, Combat = 25, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_SPEARMAN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_SPEARMAN';
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 42, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_PIKEMAN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_PIKEMAN';
update Units set Cost = 140, Maintenance = 4, BaseMoves = 2, Range = 0, Combat = 52, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_PIKE_AND_SHOT';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_PIKE_AND_SHOT';
update Units set Cost = 310, Maintenance = 6, BaseMoves = 3, Range = 0, Combat = 72, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_AT_CREW';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_AT_CREW';
update Units set Cost = 690, Maintenance = 8, BaseMoves = 3, Range = 0, Combat = 92, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_MODERN_AT';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MODERN_AT';

-- Ranged
update Units set Cost = 45, Maintenance = 1, BaseMoves = 2, Range = 2, Combat = 15, RangedCombat = 25, StrategicResource = NULL where UnitType = 'UNIT_ARCHER';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_ARCHER';
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 2, Combat = 32, RangedCombat = 42, StrategicResource = NULL where UnitType = 'UNIT_CROSSBOWMAN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_CROSSBOWMAN';
update Units set Cost = 210, Maintenance = 5, BaseMoves = 2, Range = 2, Combat = 50, RangedCombat = 60, StrategicResource = NULL where UnitType = 'UNIT_FIELD_CANNON';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_FIELD_CANNON';
update Units set Cost = 460, Maintenance = 7, BaseMoves = 3, Range = 2, Combat = 70, RangedCombat = 80, StrategicResource = NULL where UnitType = 'UNIT_MACHINE_GUN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MACHINE_GUN';

-- Light cavalry
update Units set Cost = 65, Maintenance = 2, BaseMoves = 4, Range = 0, Combat = 36, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_HORSEMAN';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_HORSEMAN';
update Units set Cost = 100, Maintenance = 3, BaseMoves = 5, Range = 0, Combat = 47, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_COURSER';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_COURSER';
update Units set Cost = 200, Maintenance = 5, BaseMoves = 5, Range = 0, Combat = 62, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_CAVALRY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_CAVALRY';
update Units set Cost = 460, Maintenance = 7, BaseMoves = 4, Range = 0, Combat = 96, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON', PrereqTech = 'TECH_SYNTHETIC_MATERIALS' where UnitType = 'UNIT_HELICOPTER';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_HELICOPTER';
-- Special Cases: UNIT_MECHANIZED_INFANTRY

-- Heavy cavalry
update Units set Cost = 55, Maintenance = 1, BaseMoves = 2, Range = 0, Combat = 30, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_HEAVY_CHARIOT';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_HEAVY_CHARIOT';
update Units set Cost = 120, Maintenance = 3, BaseMoves = 4, Range = 0, Combat = 53, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_KNIGHT';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_KNIGHT';
update Units set Cost = 250, Maintenance = 5, BaseMoves = 4, Range = 0, Combat = 73, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_CUIRASSIER';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_CUIRASSIER';
-- Special Case: UNIT_TANK
update Units set Cost = 500, Maintenance = 10, BaseMoves = 4, Range = 0, Combat = 83, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON', PrereqTech = 'TECH_CATERPILLAR_TRACK_HD' where UnitType = 'UNIT_TANK';
update Units_XP2 set ResourceCost = 10, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_TANK';
update Units set Cost = 1080, Maintenance = 16, BaseMoves = 5, Range = 0, Combat = 105, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_MODERN_ARMOR';
update Units_XP2 set ResourceCost = 10, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 2 where UnitType = 'UNIT_MODERN_ARMOR';

-- Bombard
update Units set Cost = 75, Maintenance = 2, BaseMoves = 2, Range = 2, Combat = 25, Bombard = 35, StrategicResource = NULL where UnitType = 'UNIT_CATAPULT';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_CATAPULT';
update Units set Cost = 120, Maintenance = 3, BaseMoves = 2, Range = 2, Combat = 35, Bombard = 45, StrategicResource = NULL where UnitType = 'UNIT_TREBUCHET';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_TREBUCHET';
update Units set Cost = 200, Maintenance = 6, BaseMoves = 2, Range = 2, Combat = 50, Bombard = 60, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_BOMBARD';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_BOMBARD';
update Units set Cost = 450, Maintenance = 9, BaseMoves = 3, Range = 2, Combat = 70, Bombard = 80, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_ARTILLERY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ARTILLERY';
update Units set Cost = 960, Maintenance = 12, BaseMoves = 3, Range = 3, Combat = 80, Bombard = 100, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_ROCKET_ARTILLERY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ROCKET_ARTILLERY';

-- Recon
update Units set Cost = 90, Maintenance = 3, BaseMoves = 3, Range = 1, Combat = 40, RangedCombat = 30, StrategicResource = NULL where UnitType = 'UNIT_SKIRMISHER';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_SKIRMISHER';
update Units set Cost = 210, Maintenance = 5, BaseMoves = 3, Range = 1, Combat = 60, RangedCombat = 50, StrategicResource = NULL where UnitType = 'UNIT_RANGER';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_RANGER';
-- Special Cases: UNIT_MACHINE_GUN
update Units set Cost = 460, Maintenance = 8, BaseMoves = 4, Range = 1, Combat = 80, RangedCombat = 70, StrategicResource = NULL where UnitType = 'UNIT_SPEC_OPS';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_SPEC_OPS';
-- Special Cases: UNIT_HELICOPTER

-- Support
update Units set Cost = 60, Maintenance = 1, BaseMoves = 3, Range = 0, Combat = 0, RangedCombat = 0, StrategicResource = NULL, PrereqTech = 'TECH_THE_WHEEL' where UnitType = 'UNIT_BATTERING_RAM';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_BATTERING_RAM';
update Units set Cost = 90, Maintenance = 3, BaseMoves = 3, Range = 0, Combat = 0, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_SIEGE_TOWER';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_SIEGE_TOWER';
update Units set Cost = 180, Maintenance = 3, BaseMoves = 3, Range = 0, Combat = 0, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_MEDIC';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MEDIC';
update Units set Cost = 270, Maintenance = 3, BaseMoves = 4, Range = 0, Combat = 0, RangedCombat = 0, StrategicResource = NULL, PrereqTech = 'TECH_MEDICAL_SCIENCE_HD' where UnitType = 'UNIT_SUPPLY_CONVOY';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_SUPPLY_CONVOY';
update Units set Cost = 400, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 0, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_ANTIAIR_GUN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_ANTIAIR_GUN';
update Units set Cost = 500, Maintenance = 4, BaseMoves = 3, Range = 0, Combat = 0, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_MOBILE_SAM';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MOBILE_SAM';

update Units set Cost = 200, Maintenance = 3, BaseMoves = 3, Range = 0, Combat = 0, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_OBSERVATION_BALLOON';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_OBSERVATION_BALLOON';
update Units set Cost = 300, Maintenance = 4, BaseMoves = 4, Range = 0, Combat = 0, RangedCombat = 0, StrategicResource = NULL, PrereqTech = 'TECH_INTEGRATED_CIRCUIT_HD' where UnitType = 'UNIT_DRONE';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_DRONE';

-- Naval Melee
update Units set Cost = 55, Maintenance = 1, BaseMoves = 3, Range = 0, Combat = 30, RangedCombat = 0, StrategicResource = NULL, PrereqTech = 'TECH_SHIPBUILDING' where UnitType = 'UNIT_GALLEY';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_GALLEY';
update Units set Cost = 110, Maintenance = 3, BaseMoves = 3, Range = 0, Combat = 45, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_DLV_COG';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_DLV_COG';
update Units set Cost = 180, Maintenance = 4, BaseMoves = 4, Range = 0, Combat = 55, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_CARAVEL';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_CARAVEL';
update Units set Cost = 300, Maintenance = 5, BaseMoves = 5, Range = 0, Combat = 70, RangedCombat = 0, StrategicResource = 'RESOURCE_COAL' where UnitType = 'UNIT_IRONCLAD';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_COAL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_IRONCLAD';
update Units set Cost = 670, Maintenance = 7, BaseMoves = 5, Range = 0, Combat = 90, RangedCombat = 0, StrategicResource = 'RESOURCE_COAL' where UnitType = 'UNIT_DESTROYER';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_DESTROYER';

-- Naval Ranged
update Units set Cost = 80, Maintenance = 2, BaseMoves = 3, Range = 1, Combat = 25, RangedCombat = 35, StrategicResource = NULL where UnitType = 'UNIT_QUADRIREME';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_QUADRIREME';
update Units set Cost = 120, Maintenance = 3, BaseMoves = 4, Range = 2, Combat = 35, RangedCombat = 45, StrategicResource = NULL where UnitType = 'UNIT_DLV_GALLEASS';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_DLV_GALLEASS';
update Units set Cost = 220, Maintenance = 4, BaseMoves = 4, Range = 2, Combat = 50, RangedCombat = 60, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_FRIGATE';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_FRIGATE';
update Units set Cost = 500, Maintenance = 6, BaseMoves = 5, Range = 3, Combat = 70, RangedCombat = 80, StrategicResource = 'RESOURCE_COAL' where UnitType = 'UNIT_BATTLESHIP';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_COAL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_BATTLESHIP';
update Units set Cost = 1080, Maintenance = 8, BaseMoves = 5, Range = 4, Combat = 75, RangedCombat = 95, StrategicResource = 'RESOURCE_COAL' where UnitType = 'UNIT_MISSILE_CRUISER';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_MISSILE_CRUISER';

-- Naval Raider
update Units set Cost = 110, Maintenance = 3, BaseMoves = 4, Range = 1, Combat = 30, RangedCombat = 40, StrategicResource = NULL where UnitType = 'UNIT_DL_MEDIEVAL_PIRATE';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_DL_MEDIEVAL_PIRATE';
update Units set Cost = 180, Maintenance = 4, BaseMoves = 4, Range = 2, Combat = 40, RangedCombat = 50, StrategicResource = NULL where UnitType = 'UNIT_PRIVATEER';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_PRIVATEER';
update Units set Cost = 450, Maintenance = 6, BaseMoves = 5, Range = 2, Combat = 65, RangedCombat = 75, StrategicResource = 'RESOURCE_COAL' where UnitType = 'UNIT_SUBMARINE';
insert or replace into Units_XP2 (UnitType, ResourceCost, ResourceMaintenanceType, ResourceMaintenanceAmount)
values  ('UNIT_SUBMARINE',  5, 'RESOURCE_COAL', 1);
update Units set Cost = 900, Maintenance = 8, BaseMoves = 5, Range = 2, Combat = 85, RangedCombat = 95, StrategicResource = 'RESOURCE_COAL' where UnitType = 'UNIT_NUCLEAR_SUBMARINE';
insert or replace into Units_XP2 (UnitType, ResourceCost, ResourceMaintenanceType, ResourceMaintenanceAmount)
values  ('UNIT_NUCLEAR_SUBMARINE',  5, 'RESOURCE_URANIUM', 1);

-- Carrier
update Units set Cost = 750, Maintenance = 7, BaseMoves = 4, Range = 0, Combat = 70, RangedCombat = 0, StrategicResource = 'RESOURCE_OIL' where UnitType = 'UNIT_AIRCRAFT_CARRIER';
insert or replace into Units_XP2 (UnitType, ResourceCost, ResourceMaintenanceType, ResourceMaintenanceAmount)
values  ('UNIT_AIRCRAFT_CARRIER',  5, 'RESOURCE_OIL', 1);
-- GDR
update Units set Cost = 1500 where UnitType = 'UNIT_GIANT_DEATH_ROBOT';

-- Promotions
update Units set BaseMoves = BaseMoves - 1 where PromotionClass = 'PROMOTION_CLASS_RECON';

--------------------------------------------------------------------------------------------------------------
-- 蛮族远古海军
update Technologies set BarbarianFree = 0 where TechnologyType = 'TECH_SHIPBUILDING';
update Modifiers set SubjectRequirementSetId = 'HD_UNIT_IS_NOT_BARBARIAN_GALLEY_REQUIREMENTS' where ModifierId = 'UNIT_COASTAL_RAID';
update BarbarianTribes set ScoutTag = 'CLASS_NAVAL_RAIDER', TurnsToWarriorSpawn = 15 where TribeType = 'TRIBE_NAVAL';

--攻城单位增加基础能力：回合开始时相邻轻骑兵+1速
insert or replace into Modifiers
	(ModifierId,                                  ModifierType,                             RunOnce, NewOnly, Permanent, Repeatable, OwnerRequirementSetId)
values
	('HD_ADJACENT_LIGHT_CAVALRY_ACCELERATING',    'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',  0,       0,       0,         0,          'ADJACENT_FRIENDLY_LIGHT_CAVALRY_UNIT_REQUIREMENT_SETS');

insert or replace into ModifierArguments
	(ModifierId,                                  Name,      Type,               Value)
values
	('HD_ADJACENT_LIGHT_CAVALRY_ACCELERATING',    'Amount',  'ARGTYPE_IDENTITY', 1);
insert or replace into UnitAbilities
	(UnitAbilityType,                           Name, Description,                                             inactive, ShowFloatTextWhenEarned, Permanent)
values
	('ABILITY_SIEGE_CAVALRY_MOVEMENT_HD_NEW',   NULL, 'LOC_ABILITY_SIEGE_CAVALRY_MOVEMENT_HD_NEW_DESCRIPTION', 0,        0,                       1);
insert or replace into UnitAbilityModifiers
	(UnitAbilityType,                         ModifierId)
values
	('ABILITY_SIEGE_CAVALRY_MOVEMENT_HD_NEW', 'HD_ADJACENT_LIGHT_CAVALRY_ACCELERATING');
insert or replace into Types
	(Type,                                    Kind)
values
	('ABILITY_SIEGE_CAVALRY_MOVEMENT_HD_NEW', 'KIND_ABILITY');
insert or replace into TypeTags
	(Type,                                    Tag)
values
	('ABILITY_SIEGE_CAVALRY_MOVEMENT_HD_NEW', 'CLASS_SIEGE');

--海军近战单位升级改动：左一舵手改为一速一视野
--海军远程单位升级改动：右三球鼻艏改为一速一视野
insert or replace into UnitPromotionModifiers
	(UnitPromotionType, 		ModifierId)
values
	('PROMOTION_HELMSMAN',		'HELMSMAN_BONUS_WATER_PERSPECTIVE'),
	('PROMOTION_BULB_BOW',		'BULB_BOW_BONUS_WATER_PERSPECTIVE');
insert or replace into Modifiers
	(ModifierId, 							ModifierType)
values
	('HELMSMAN_BONUS_WATER_PERSPECTIVE',	'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT'),
	('BULB_BOW_BONUS_WATER_PERSPECTIVE',	'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT');
insert or replace into ModifierArguments
	(ModifierId, 							Name, 		Type, 				Value)
values
	('HELMSMAN_BONUS_WATER_PERSPECTIVE',	'Amount',	'ARGTYPE_IDENTITY',	1),
	('BULB_BOW_BONUS_WATER_PERSPECTIVE',	'Amount',	'ARGTYPE_IDENTITY',	1);
--海军远程左2右2换位
update UnitPromotions set Column = 3 where UnitPromotionType = 'PROMOTION_PREPARATORY_FIRE';
update UnitPromotions set Column = 1 where UnitPromotionType = 'PROMOTION_ROLLING_BARRAGE';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_BOMBARDMENT' where UnitPromotion = 'PROMOTION_PREPARATORY_FIRE';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_LINE_OF_BATTLE' where UnitPromotion = 'PROMOTION_ROLLING_BARRAGE';

update Units set PrereqTech = 'TECH_ROCKETRY' where UnitType = 'UNIT_BOMBER';
------------------------------------------------------------------------------------------------
-- make a new unit - ancient seadog. by Five.
insert or ignore into UnitAbilities
    (UnitAbilityType,			Name,								Description)
values
	('ABILITY_SEADOG_LESS_STRENGTH',	'LOC_UNIT_ANCIENT_SEADOG_NAME',		'LOC_SEADOG_LESS_STRENGTH_DESCRIPTION');
insert or ignore into UnitAbilityModifiers
	(UnitAbilityType,			ModifierId)
values
	('ABILITY_SEADOG_LESS_STRENGTH',	'SEADOG_LESS_STRENGTH_ATTACKING_DISTRICT');
insert or ignore into Modifiers
	(ModifierId,									ModifierType,								SubjectRequirementSetId)
values
	('SEADOG_LESS_STRENGTH_ATTACKING_DISTRICT',		'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',		'SHELLS_REQUIREMENTS');
insert or ignore into ModifierArguments
	(ModifierId,									Name,		Value)
values
	('SEADOG_LESS_STRENGTH_ATTACKING_DISTRICT',		'Amount',	-17);
insert or ignore into ModifierStrings
	(ModifierId,									Context,	 Text)
values
	('SEADOG_LESS_STRENGTH_ATTACKING_DISTRICT',		'Preview',	'LOC_SEADOG_LESS_STRENGTH_DESCRIPTION');

update Units set PrereqTech = null, PrereqCivic = 'CIVIC_HERALDRY_HD' where UnitType = 'UNIT_COURSER';
update Units set PrereqTech = null, PrereqCivic = 'CIVIC_HERALDRY_HD' where UnitType = 'UNIT_HUNGARY_BLACK_ARMY';
update Units set PrereqTech = null, PrereqCivic = 'CIVIC_HERALDRY_HD' where UnitType = 'UNIT_ETHIOPIAN_OROMO_CAVALRY';
update Units set PrereqTech = 'TECH_RIFLING' where UnitType = 'UNIT_CUIRASSIER';
update Units set PrereqTech = 'TECH_RIFLING' where UnitType = 'UNIT_AMERICAN_ROUGH_RIDER';
insert or replace into TypeTags(Type,Tag)
select UnitType, 'CLASS_LAND_MILITARY' from Units where FormationClass = 'FORMATION_CLASS_LAND_COMBAT';

---------------------------------------------------------------------------------
-- 远古小马
update Units set PrereqTech = 'TECH_SADDLE_HD' where PrereqTech = 'TECH_HORSEBACK_RIDING';
update Units set TraitType = null, PrereqTech = 'TECH_HORSEBACK_RIDING', StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_BARBARIAN_HORSEMAN';
update Units set TraitType = null, PrereqTech = 'TECH_HORSEBACK_RIDING' where UnitType = 'UNIT_BARBARIAN_HORSE_ARCHER';

insert or replace into Units_XP2
	(UnitType,										ResourceCost,		ResourceMaintenanceAmount,		ResourceMaintenanceType)
values
	('UNIT_BARBARIAN_HORSEMAN',		5,							1,														'RESOURCE_HORSES');