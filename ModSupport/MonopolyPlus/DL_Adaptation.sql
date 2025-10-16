-------------------------------------
--     Adaptation for the Mod      --
-------------------------------------

-- 大亨和投资人修改
update Units set Cost = 200, CostProgressionParam1 = 20, MustPurchase = 0, PrereqTech = 'TECH_MASS_PRODUCTION', PseudoYieldType = 'PSEUDOYIELD_UNIT_LEU_TYCOON' where UnitType = 'UNIT_LEU_TYCOON';
update Units set PseudoYieldType = 'PSEUDOYIELD_UNIT_LEU_INVESTOR' where UnitType = 'UNIT_LEU_INVESTOR';
delete from TypeProperties where Type in ('UNIT_LEU_INVESTOR', 'UNIT_LEU_TYCOON') and Name = 'LIFESPAN';

-- 回调海滨度假区和滑雪场的建造单位
update Improvement_ValidBuildUnits set UnitType = 'UNIT_BUILDER' where ImprovementType = 'IMPROVEMENT_BEACH_RESORT';
update Improvement_ValidBuildUnits set UnitType = 'UNIT_BUILDER' where ImprovementType = 'IMPROVEMENT_SKI_RESORT';

-- 火车站修改
    -- 基础
update Improvements set Appeal = 0, YieldFromAppeal = NULL, YieldFromAppealPercent = 100, Removable = 1 where ImprovementType = 'IMPROVEMENT_LEU_STATION';
    -- 军工也可以建造
insert or ignore into Improvement_ValidBuildUnits
    (ImprovementType,               UnitType)
values
    ('IMPROVEMENT_LEU_STATION',     'UNIT_MILITARY_ENGINEER');

    -- 删除内商和耗电特效
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_LEU_STATION' and (
    (ModifierId like 'LEU_STATION_DOMESTIC_PRODUCTION_%_OTHERS') or
    (ModifierId like 'LEU_STATION_DOMESTIC_PRODUCTION_%_OTHERS_POWERED') or
    (ModifierId like 'LEU_STATION_DOMESTIC_GOLD_%_OTHERS') or
    (ModifierId like 'LEU_STATION_DOMESTIC_GOLD_%_OTHERS_POWERED') or
    (ModifierId like 'LEU_STATION_DOMESTIC_CULTURE_%_OTHERS') or
    (ModifierId like 'LEU_STATION_DOMESTIC_CULTURE_%_OTHERS_POWERED') or
    (ModifierId like 'LEU_STATION_DOMESTIC_FOOD_%_OTHERS') or
    (ModifierId like 'LEU_STATION_DOMESTIC_FOOD_%_OTHERS_POWERED') or
    (ModifierId = 'LEU_STATION_REQUIRED_POWER')
);

    -- 相邻加成
update Adjacency_YieldChanges set YieldChange = 1 where ID = 'Station_Production_From_Industry';
delete from District_Adjacencies where YieldChangeId = 'Station_Production';
update Improvement_YieldChanges set YieldChange = 2 where ImprovementType = 'IMPROVEMENT_LEU_STATION' and YieldType = 'YIELD_PRODUCTION';

update Improvement_Tourism set PrereqTech = 'TECH_FLIGHT' where ImprovementType = 'IMPROVEMENT_LEU_STATION';
insert or ignore into Adjacency_YieldChanges
    (ID,                                        Description,   YieldType,               YieldChange,    TilesRequired,  AdjacentDistrict)
values
    ('HD_INDUSTRIAL_STATION_PRODUCTION',       'Placeholder', 'YIELD_PRODUCTION',       2,              1,              'DISTRICT_INDUSTRIAL_ZONE'),
    ('HD_COMMERCIAL_STATION_PRODUCTION',       'Placeholder', 'YIELD_PRODUCTION',       2,              1,              'DISTRICT_COMMERCIAL_HUB'),
    ('HD_HARBOR_STATION_PRODUCTION',           'Placeholder', 'YIELD_PRODUCTION',       2,              1,              'DISTRICT_HARBOR'),
    ('HD_CANAL_STATION_PRODUCTION',            'Placeholder', 'YIELD_PRODUCTION',       2,              1,              'DISTRICT_CANAL'),
    ('HD_AERODROME_STATION_PRODUCTION',        'Placeholder', 'YIELD_PRODUCTION',       2,              1,              'DISTRICT_AERODROME');
insert or replace into Adjacency_YieldChanges
	(ID,								            Description,	YieldType,				YieldChange,	AdjacentImprovement)
values
    ('HD_MOUNTAIN_TUNNEL_STATION_PRODUCTION',		'Placeholder',	'YIELD_PRODUCTION',		3,				'IMPROVEMENT_MOUNTAIN_TUNNEL');
insert or ignore into Improvement_Adjacencies
    (ImprovementType,           YieldChangeId)
values
    ('IMPROVEMENT_LEU_STATION', 'HD_INDUSTRIAL_STATION_PRODUCTION'),
    ('IMPROVEMENT_LEU_STATION', 'HD_COMMERCIAL_STATION_PRODUCTION'),
    ('IMPROVEMENT_LEU_STATION', 'HD_HARBOR_STATION_PRODUCTION'),
    ('IMPROVEMENT_LEU_STATION', 'HD_CANAL_STATION_PRODUCTION'),
    ('IMPROVEMENT_LEU_STATION', 'HD_AERODROME_STATION_PRODUCTION'),
    ('IMPROVEMENT_LEU_STATION', 'HD_MOUNTAIN_TUNNEL_STATION_PRODUCTION');

    -- 上丘陵
insert or ignore into Improvement_ValidTerrains
    (ImprovementType,               TerrainType)
values
    ('IMPROVEMENT_LEU_STATION',     'TERRAIN_GRASS_HILLS'),
    ('IMPROVEMENT_LEU_STATION',     'TERRAIN_PLAINS_HILLS'),
    ('IMPROVEMENT_LEU_STATION',     'TERRAIN_DESERT_HILLS'),
    ('IMPROVEMENT_LEU_STATION',     'TERRAIN_TUNDRA_HILLS'),
    ('IMPROVEMENT_LEU_STATION',     'TERRAIN_SNOW_HILLS');

    -- 本城改良业绩
insert or ignore into ImprovementModifiers
    (ImprovementType,           ModifierId)
values
    ('IMPROVEMENT_LEU_STATION', 'LEU_STATION_IMPROVEMENT_TOURISM');

insert or ignore into Modifiers
    (ModifierId,                          ModifierType)
values
    ('LEU_STATION_IMPROVEMENT_TOURISM',   'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_TOURISM');

insert or ignore into ModifierArguments
    (ModifierId,                          Name,      Value)
values
    ('LEU_STATION_IMPROVEMENT_TOURISM',   'Amount',  50);

-- BUG Fixing
update ModifierArguments set Value = 'YIELD_PRODUCTION' where Value = 'YIELD_PRODUCION' and Name = 'YieldType';

insert or ignore into RequirementSetRequirements
    (RequirementSetId,		RequirementId)
select	'LEU_IS_'||ResourceType||'_CORPORATION',		'REQUIRES_LEU_CORPORATION_PLOT'
FROM ResourceCorporations;

-- 
insert or ignore into Unit_BuildingPrereqs
    (Unit,                      PrereqBuilding)
select  'UNIT_LEU_TYCOON',          BuildingType
from Buildings where BuildingType = 'BUILDING_JNR_MANUFACTURY';
