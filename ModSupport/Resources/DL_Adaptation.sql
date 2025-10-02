-------------------------------------
--     Adaptation for the Mod      --
-------------------------------------

delete from Resource_YieldChanges where ResourceType = 'RESOURCE_GOLD' and YieldType = 'YIELD_CULTURE';
update Resource_YieldChanges set YieldChange = 4 where ResourceType = 'RESOURCE_GOLD' and YieldType = 'YIELD_GOLD';
insert or ignore into Resource_ValidTerrains (ResourceType, TerrainType) values
    ('RESOURCE_GOLD',   'TERRAIN_PLAINS'),
    ('RESOURCE_GOLD',   'TERRAIN_PLAINS_HILLS');

insert or ignore into Resource_ValidTerrains (ResourceType, TerrainType)
select 'RESOURCE_SUK_CHEESE',   'TERRAIN_GRASS'
where exists (select ResourceType from Resources where ResourceType = 'RESOURCE_SUK_CHEESE');
insert or ignore into Resource_ValidTerrains (ResourceType, TerrainType)
select 'RESOURCE_SUK_CHEESE',   'TERRAIN_GRASS_HILLS'
where exists (select ResourceType from Resources where ResourceType = 'RESOURCE_SUK_CHEESE');
insert or ignore into Resource_ValidTerrains (ResourceType, TerrainType)
select 'RESOURCE_SUK_CHEESE',   'TERRAIN_PLAINS'
where exists (select ResourceType from Resources where ResourceType = 'RESOURCE_SUK_CHEESE');
insert or ignore into Resource_ValidTerrains (ResourceType, TerrainType)
select 'RESOURCE_SUK_CHEESE',   'TERRAIN_PLAINS_HILLS'
where exists (select ResourceType from Resources where ResourceType = 'RESOURCE_SUK_CHEESE');

delete from Resource_ValidTerrains where ResourceType = 'RESOURCE_LEU_P0K_QUINOA' and TerrainType = 'TERRAIN_DESERT';

update Resources set Frequency = 4 where ResourceType = 'RESOURCE_LEU_P0K_POTATOES';
update Resources set Frequency = 4 where ResourceType = 'RESOURCE_DLV_BISON';

insert or ignore into Resource_ValidTerrains (ResourceType, TerrainType) select
    ResourceType,   'TERRAIN_TUNDRA'
from Resources where ResourceType = 'RESOURCE_DLV_BISON';

insert or replace into Resource_ValidFeatures
    (ResourceType,   FeatureType)
select
    ResourceType,    'FEATURE_FOREST'
from Resources where ResourceType in ('RESOURCE_DLV_BISON', 'RESOURCE_P0K_MAPLE');

insert or ignore into Resource_ValidTerrains (ResourceType, TerrainType) select
    ResourceType, 'TERRAIN_COAST'
from Resources where ResourceType = 'RESOURCE_P0K_PENGUINS';
insert or replace into Resource_ValidFeatures (ResourceType, FeatureType) select
    ResourceType, 'FEATURE_REEF'
from Resources where ResourceType = 'RESOURCE_P0K_PENGUINS';
insert or ignore into Improvement_ValidResources (ImprovementType, ResourceType, MustRemoveFeature) select
    'IMPROVEMENT_FISHING_BOATS',    ResourceType,   0
from Resources where ResourceType = 'RESOURCE_P0K_PENGUINS';
update Resources set SeaFrequency = 1, LakeEligible = 0 where ResourceType = 'RESOURCE_P0K_PENGUINS';

delete from Resource_Harvests where ResourceType = 'RESOURCE_SUK_CAMEL' and YieldType = 'YIELD_GOLD';
-- update Resource_YieldChanges set YieldChange = 2 where ResourceType = 'RESOURCE_SUK_CAMEL' and YieldType = 'YIELD_PRODUCTION';
-- delete from Resource_YieldChanges where ResourceType = 'RESOURCE_SUK_CAMEL' and YieldType = 'YIELD_GOLD';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_SUK_CHEESE' and YieldType = 'YIELD_CULTURE';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_SUK_SHARK' and YieldType = 'YIELD_PRODUCTION';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_P0K_PLUMS' and YieldType = 'YIELD_FOOD';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_CVS_POMEGRANATES' and YieldType = 'YIELD_FOOD';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_CVS_POMEGRANATES' and YieldType = 'YIELD_FAITH';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_LEU_P0K_QUINOA' and YieldType = 'YIELD_FOOD';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_LEU_P0K_YERBAMATE' and YieldType = 'YIELD_FOOD';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_LEU_P0K_YERBAMATE' and YieldType = 'YIELD_PRODUCTION';
update Resource_YieldChanges set YieldChange = 1 where ResourceType = 'RESOURCE_LEU_P0K_CAPYBARAS' and YieldType = 'YIELD_FOOD';
update Resource_YieldChanges set YieldType = 'YIELD_PRODUCTION' where ResourceType = 'RESOURCE_DLV_BISON' and YieldType = 'YIELD_FOOD';

insert or replace into Resource_YieldChanges (ResourceType, YieldType, YieldChange) select
    ResourceType,    'YIELD_FOOD',   1
from Resources where ResourceType = 'RESOURCE_SUK_CAMEL';

insert or replace into Resource_YieldChanges (ResourceType, YieldType, YieldChange) select
    ResourceType,    'YIELD_FAITH',   1
from Resources where ResourceType = 'RESOURCE_LEU_P0K_YERBAMATE';

update Resource_YieldChanges set YieldChange = 4 where ResourceType = 'RESOURCE_P0K_OPAL' and YieldType = 'YIELD_GOLD';

update Resource_YieldChanges set YieldChange = 2 where ResourceType = 'RESOURCE_LEU_P0K_COCA' and YieldType = 'YIELD_GOLD';

insert or replace into Resource_YieldChanges (ResourceType, YieldType, YieldChange) select
    ResourceType,    'YIELD_GOLD',   1
from Resources where ResourceType = 'RESOURCE_SUK_OBSIDIAN'
    or ResourceType = 'RESOURCE_SUK_CHEESE'
    or ResourceType = 'RESOURCE_SUK_SHARK'
    or ResourceType = 'RESOURCE_P0K_PENGUINS'
    or ResourceType = 'RESOURCE_P0K_PLUMS'
    or ResourceType = 'RESOURCE_LEU_P0K_QUINOA'
    or ResourceType = 'RESOURCE_LEU_P0K_CAPYBARAS'
    or ResourceType = 'RESOURCE_P0K_PAPYRUS';

insert or replace into Resource_YieldChanges (ResourceType, YieldType, YieldChange) select
    ResourceType,    'YIELD_GOLD',   2
from Resources where ResourceType = 'RESOURCE_LEU_P0K_YERBAMATE';

insert or replace into Resource_YieldChanges (ResourceType, YieldType, YieldChange) select
    ResourceType,    'YIELD_GOLD',   4
from Resources where ResourceType = 'RESOURCE_CVS_POMEGRANATES';

insert or replace into Resource_ValidFeatures
    (ResourceType,              FeatureType)
select
    'RESOURCE_SUK_OBSIDIAN',    'FEATURE_GEOTHERMAL_FISSURE'
where exists (select ResourceType from Resources where ResourceType = 'RESOURCE_SUK_OBSIDIAN');