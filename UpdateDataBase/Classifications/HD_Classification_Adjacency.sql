-- ================================================================================
-- 地形分类
-- ================================================================================
-- 山脉相邻加成 to 学院 圣地 梯田 独石教堂
-- 丘陵相邻加成 to 独石教堂
delete from District_Adjacencies where DistrictType in ('DISTRICT_CAMPUS') and YieldChangeId in (
  'Mountains_Science1', 'Mountains_Science2', 'Mountains_Science3', 'Mountains_Science4', 'Mountains_Science5'
);
delete from District_Adjacencies where DistrictType in ('DISTRICT_HOLY_SITE', 'DISTRICT_LAVRA') and YieldChangeId in (
  'Mountain_Faith1', 'Mountain_Faith2', 'Mountain_Faith3', 'Mountain_Faith4', 'Mountain_Faith5'
);
delete from Improvement_Adjacencies where ImprovementType in ('IMPROVEMENT_TERRACE_FARM') and YieldChangeId in (
  'Terrace_GrassMountainAdjacency', 'Terrace_PlainsMountainAdjacency', 'Terrace_DesertMountainAdjacency', 'Terrace_TundraMountainAdjacency', 'Terrace_SnowMountainAdjacency'
);
delete from Improvement_Adjacencies where ImprovementType in ('IMPROVEMENT_ROCK_HEWN_CHURCH') and YieldChangeId in (
  'Mountain_Faith1', 'Mountain_Faith2', 'Mountain_Faith3', 'Mountain_Faith4', 'Mountain_Faith5',
  'Hills_Faith1', 'Hills_Faith2', 'Hills_Faith3', 'Hills_Faith4', 'Hills_Faith5'
);

insert or ignore into HD_District_Adjacencies_Base_On_Classification (DistrictType, YieldChangeId) values
  ('DISTRICT_CAMPUS',     'HD_CAMPUS_ALL_MOUNTAINS_SCIENCE'),
  ('DISTRICT_HOLY_SITE',  'HD_HOLY_SITE_ALL_MOUNTAINS_SCIENCE');

insert or ignore into HD_Improvement_Adjacencies_Base_On_Classification (ImprovementType, YieldChangeId) values
  ('IMPROVEMENT_TERRACE_FARM',      'HD_TERRACE_FARM_ALL_MOUNTAINS_SCIENCE'),
  ('IMPROVEMENT_ROCK_HEWN_CHURCH',  'HD_ROCK_HEWN_CHURCH_ALL_MOUNTAINS_FAITH'),
  ('IMPROVEMENT_ROCK_HEWN_CHURCH',  'HD_ROCK_HEWN_CHURCH_ALL_HILLS_FAITH');

insert or ignore into HD_Adjacency_Base_On_Classification (ID, Description, YieldType, YieldChange, TerrainClassType) values
  ('HD_CAMPUS_ALL_MOUNTAINS_SCIENCE',         'LOC_HD_ALL_MOUNTAINS_SCIENCE_TEXT',  'YIELD_SCIENCE',  1, 'TERRAIN_CLASS_MOUNTAIN'),
  ('HD_HOLY_SITE_ALL_MOUNTAINS_SCIENCE',      'LOC_HD_ALL_MOUNTAINS_FAITH_TEXT',    'YIELD_FAITH',    1, 'TERRAIN_CLASS_MOUNTAIN'),
  ('HD_TERRACE_FARM_ALL_MOUNTAINS_SCIENCE',   'Placeholder',                        'YIELD_FOOD',     1, 'TERRAIN_CLASS_MOUNTAIN'),
  ('HD_ROCK_HEWN_CHURCH_ALL_MOUNTAINS_FAITH', 'Placeholder',                        'YIELD_FAITH',    1, 'TERRAIN_CLASS_MOUNTAIN'),
  ('HD_ROCK_HEWN_CHURCH_ALL_HILLS_FAITH',     'Placeholder',                        'YIELD_FAITH',    1, 'TERRAIN_CLASS_HILLS');

-- ================================================================================
-- 区域分类
-- ================================================================================
-- 工业：水利设施、交通设施
-- 商业：交通设施
-- 剧院：旅游设施
delete from District_Adjacencies where DistrictType in ('DISTRICT_INDUSTRIAL_ZONE', 'DISTRICT_HANSA', 'DISTRICT_OPPIDUM') and YieldChangeId in (
  'Aqueduct_Production', 'Bath_Production', 'Canal_Production', 'Dam_Production'
);
delete from District_Adjacencies where DistrictType in ('DISTRICT_COMMERCIAL_HUB', 'DISTRICT_SUGUBA', 'DISTRICT_SUK_FLOATINGMARKET') and YieldChangeId in (
  'Harbor_Gold', 'RoyalDock_Gold', 'Cothon_Gold', 'Canal_Gold'
);
delete from District_Adjacencies where DistrictType in ('DISTRICT_THEATER', 'DISTRICT_ACROPOLIS', 'DISTRICT_XHH_FESTIVAL_THEATER') and YieldChangeId in (
  'EntertainmentComplex_Culture', 'WaterPark_Culture', 'StreetCarnival_Culture', 'Copacabana_Culture', 'Hippodrome_Culture'
);

insert or ignore into HD_District_Adjacencies_Base_On_Classification (DistrictType, YieldChangeId) values
  ('DISTRICT_INDUSTRIAL_ZONE',      'HD_INDUSTRIAL_ZONE_TRANSPORTATION_FACILITIES_DISTRICTS_PRODUCTION'),
  ('DISTRICT_INDUSTRIAL_ZONE',      'HD_INDUSTRIAL_ZONE_WATER_CONSERVANCY_FACILITIES_DISTRICTS_PRODUCTION'),
  ('DISTRICT_COMMERCIAL_HUB',       'HD_COMMERCIAL_HUB_TRANSPORTATION_FACILITIES_DISTRICTS_GOLD'),
  ('DISTRICT_THEATER',              'HD_THEATER_TOURISM_FACILITIES_DISTRICTS_CULTURE');

insert or ignore into HD_Adjacency_Base_On_Classification (ID, Description, YieldType, YieldChange, DistrictClassificationType) values
  ('HD_INDUSTRIAL_ZONE_TRANSPORTATION_FACILITIES_DISTRICTS_PRODUCTION',     'LOC_HD_TRANSPORTATION_FACILITIES_DISTRICTS_PRODUCTION_TEXT',     'YIELD_PRODUCTION', 2, 'DISTRICT_CLASSIFICATION_TRANSPORTATION_FACILITIES'),
  ('HD_INDUSTRIAL_ZONE_WATER_CONSERVANCY_FACILITIES_DISTRICTS_PRODUCTION',  'LOC_HD_WATER_CONSERVANCY_FACILITIES_DISTRICTS_PRODUCTION_TEXT',  'YIELD_PRODUCTION', 2, 'DISTRICT_CLASSIFICATION_WATER_CONSERVANCY_FACILITIES'),
  ('HD_COMMERCIAL_HUB_TRANSPORTATION_FACILITIES_DISTRICTS_GOLD',            'LOC_HD_TRANSPORTATION_FACILITIES_DISTRICTS_GOLD_TEXT',           'YIELD_GOLD',       2, 'DISTRICT_CLASSIFICATION_TRANSPORTATION_FACILITIES'),
  ('HD_THEATER_TOURISM_FACILITIES_DISTRICTS_CULTURE',                       'LOC_HD_TOURISM_FACILITIES_DISTRICTS_CULTURE_TEXT',               'YIELD_CULTURE',    1, 'DISTRICT_CLASSIFICATION_TOURISM_FACILITIES');

-- ================================================================================
-- 改良分类
-- ================================================================================
-- 工业：工业生产、城市设施
-- 商业：交通设施、商业设施
-- 港口：交通设施、商业设施
-- 军营：交通设施、军事设施
-- 剧院：旅游设施
-- 圣地：宗教设施
delete from District_Adjacencies where DistrictType in ('DISTRICT_INDUSTRIAL_ZONE', 'DISTRICT_HANSA', 'DISTRICT_OPPIDUM') and YieldChangeId in (
  'Warehouse_Production', 'ContainerPort_Production'
);
delete from District_Adjacencies where DistrictType in ('DISTRICT_COMMERCIAL_HUB', 'DISTRICT_SUGUBA', 'DISTRICT_SUK_FLOATINGMARKET', 'DISTRICT_HARBOR', 'DISTRICT_ROYAL_NAVY_DOCKYARD', 'DISTRICT_COTHON') and YieldChangeId in (
  'Warehouse_Gold', 'ContainerPort_Gold'
);

insert or ignore into HD_District_Adjacencies_Base_On_Classification (DistrictType, YieldChangeId) values
  ('DISTRICT_INDUSTRIAL_ZONE',      'HD_INDUSTRIAL_ZONE_INDUSTRIAL_PRODUCTION_IMPROVEMENTS_PRODUCTION'),
  ('DISTRICT_INDUSTRIAL_ZONE',      'HD_INDUSTRIAL_ZONE_INDUSTRIAL_PRODUCTION_IMPROVEMENTS_PRODUCTION_LATE'),
  ('DISTRICT_INDUSTRIAL_ZONE',      'HD_INDUSTRIAL_ZONE_URBAN_FACILITIES_IMPROVEMENTS_PRODUCTION'),
  ('DISTRICT_COMMERCIAL_HUB',       'HD_COMMERCIAL_HUB_TRANSPORTATION_FACILITIES_IMPROVEMENTS_GOLD'),
  ('DISTRICT_COMMERCIAL_HUB',       'HD_COMMERCIAL_HUB_COMMERCIAL_FACILITIES_IMPROVEMENTS_GOLD'),
  ('DISTRICT_HARBOR',               'HD_COMMERCIAL_HUB_TRANSPORTATION_FACILITIES_IMPROVEMENTS_GOLD'),
  ('DISTRICT_HARBOR',               'HD_COMMERCIAL_HUB_COMMERCIAL_FACILITIES_IMPROVEMENTS_GOLD'),
  ('DISTRICT_ENCAMPMENT',           'HD_ENCAMPMENT_MILITARY_FACILITIES_IMPROVEMENTS_PRODUCTION'),
  ('DISTRICT_ENCAMPMENT',           'HD_ENCAMPMENT_MILITARY_FACILITIES_IMPROVEMENTS_PRODUCTION_LATE'),
  ('DISTRICT_ENCAMPMENT',           'HD_ENCAMPMENT_TRANSPORTATION_FACILITIES_IMPROVEMENTS_PRODUCTION'),
  ('DISTRICT_THEATER',              'HD_THEATER_TOURISM_FACILITIES_IMPROVEMENTS_CULTURE'),
  ('DISTRICT_HOLY_SITE',            'HD_HOLY_SITE_RELIGIOUS_FACILITIES_IMPROVEMENTS_FAITH');

insert or ignore into HD_Adjacency_Base_On_Classification (ID, Description, YieldType, YieldChange, ImprovementClassificationType, PrereqTech, ObsoleteTech) values
  ('HD_INDUSTRIAL_ZONE_INDUSTRIAL_PRODUCTION_IMPROVEMENTS_PRODUCTION',      'LOC_HD_INDUSTRIAL_PRODUCTION_IMPROVEMENTS_PRODUCTION_TEXT',      'YIELD_PRODUCTION', 1, 'IMPROVEMENT_CLASSIFICATION_INDUSTRIAL_PRODUCTION',      NULL,                       'TECH_INDUSTRIALIZATION'),
  ('HD_INDUSTRIAL_ZONE_INDUSTRIAL_PRODUCTION_IMPROVEMENTS_PRODUCTION_LATE', 'LOC_HD_INDUSTRIAL_PRODUCTION_IMPROVEMENTS_PRODUCTION_TEXT',      'YIELD_PRODUCTION', 2, 'IMPROVEMENT_CLASSIFICATION_INDUSTRIAL_PRODUCTION',      'TECH_INDUSTRIALIZATION',   NULL),
  ('HD_INDUSTRIAL_ZONE_URBAN_FACILITIES_IMPROVEMENTS_PRODUCTION',           'LOC_HD_URBAN_FACILITIES_IMPROVEMENTS_PRODUCTION_TEXT',           'YIELD_PRODUCTION', 2, 'IMPROVEMENT_CLASSIFICATION_URBAN_FACILITIES',           NULL,                       NULL),
  ('HD_COMMERCIAL_HUB_TRANSPORTATION_FACILITIES_IMPROVEMENTS_GOLD',         'LOC_HD_TRANSPORTATION_FACILITIES_IMPROVEMENTS_GOLD_TEXT',        'YIELD_GOLD',       2, 'IMPROVEMENT_CLASSIFICATION_TRANSPORTATION_FACILITIES',  NULL,                       NULL),
  ('HD_COMMERCIAL_HUB_COMMERCIAL_FACILITIES_IMPROVEMENTS_GOLD',             'LOC_HD_COMMERCIAL_FACILITIES_IMPROVEMENTS_GOLD_TEXT',            'YIELD_GOLD',       2, 'IMPROVEMENT_CLASSIFICATION_COMMERCIAL_FACILITIES',      NULL,                       NULL),
  ('HD_ENCAMPMENT_MILITARY_FACILITIES_IMPROVEMENTS_PRODUCTION',             'LOC_HD_MILITARY_FACILITIES_IMPROVEMENTS_PRODUCTION_TEXT',        'YIELD_PRODUCTION', 1, 'IMPROVEMENT_CLASSIFICATION_MILITARY_FACILITIES',        NULL,                       'TECH_MILITARY_SCIENCE'),
  ('HD_ENCAMPMENT_MILITARY_FACILITIES_IMPROVEMENTS_PRODUCTION_LATE',        'LOC_HD_MILITARY_FACILITIES_IMPROVEMENTS_PRODUCTION_TEXT',        'YIELD_PRODUCTION', 2, 'IMPROVEMENT_CLASSIFICATION_MILITARY_FACILITIES',        'TECH_MILITARY_SCIENCE',    NULL),
  ('HD_ENCAMPMENT_TRANSPORTATION_FACILITIES_IMPROVEMENTS_PRODUCTION',       'LOC_HD_TRANSPORTATION_FACILITIES_IMPROVEMENTS_PRODUCTION_TEXT',  'YIELD_PRODUCTION', 2, 'IMPROVEMENT_CLASSIFICATION_TRANSPORTATION_FACILITIES',  NULL,                       NULL),
  ('HD_THEATER_TOURISM_FACILITIES_IMPROVEMENTS_CULTURE',                    'LOC_HD_TOURISM_FACILITIES_IMPROVEMENTS_CULTURE_TEXT',            'YIELD_CULTURE',    1, 'IMPROVEMENT_CLASSIFICATION_TOURISM_FACILITIES',         NULL,                       NULL),
  ('HD_HOLY_SITE_RELIGIOUS_FACILITIES_IMPROVEMENTS_FAITH',                  'LOC_HD_RELIGIOUS_FACILITIES_IMPROVEMENTS_FAITH_TEXT',            'YIELD_FAITH',      1, 'IMPROVEMENT_CLASSIFICATION_RELIGIOUS_FACILITIES',       NULL,                       NULL);

-- ================================================================================
-- 适配 UD
-- ================================================================================
insert or ignore into HD_District_Adjacencies_Base_On_Classification (DistrictType, YieldChangeId) select
  b.CivUniqueDistrictType,	a.YieldChangeId 
from HD_District_Adjacencies_Base_On_Classification a inner join DistrictReplaces b on a.DistrictType = b.ReplacesDistrictType
	where b.CivUniqueDistrictType not in ('DISTRICT_OBSERVATORY', 'DISTRICT_SEOWON', 'DIS_C_IKU');

delete from HD_District_Adjacencies_Base_On_Classification where DistrictType = 'DISTRICT_HANSA' and YieldChangeId in (
  'HD_INDUSTRIAL_ZONE_INDUSTRIAL_PRODUCTION_IMPROVEMENTS_PRODUCTION',
  'HD_INDUSTRIAL_ZONE_INDUSTRIAL_PRODUCTION_IMPROVEMENTS_PRODUCTION_LATE'
);

-- ================================================================================
-- 批量生成
-- ================================================================================
-- 地形分类
insert or ignore into HD_Adjacencies_YieldChangeId_ParentId (YieldChangeId, ParentId) select
  ID || '_' || TerrainType, ID
from HD_Adjacency_Base_On_Classification a inner join TerrainClass_Terrains b on a.TerrainClassType = b.TerrainClassType where a.TerrainClassType is not NULL;

insert or ignore into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentTerrain, PrereqCivic, PrereqTech, ObsoleteCivic, ObsoleteTech) select
  ID || '_' || TerrainType, Description, YieldType, YieldChange, TilesRequired, TerrainType, PrereqCivic, PrereqTech, ObsoleteCivic, ObsoleteTech
from HD_Adjacency_Base_On_Classification a inner join TerrainClass_Terrains b on a.TerrainClassType = b.TerrainClassType where a.TerrainClassType is not NULL;

-- 区域分类
insert or ignore into HD_Adjacencies_YieldChangeId_ParentId (YieldChangeId, ParentId) select
  ID || '_' || DistrictType, ID
from HD_Adjacency_Base_On_Classification a inner join HD_District_Classification b on a.DistrictClassificationType = b.DistrictClassificationType where a.DistrictClassificationType is not NULL;

insert or ignore into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict, PrereqCivic, PrereqTech, ObsoleteCivic, ObsoleteTech) select
  ID || '_' || DistrictType, Description, YieldType, YieldChange, TilesRequired, DistrictType, PrereqCivic, PrereqTech, ObsoleteCivic, ObsoleteTech
from HD_Adjacency_Base_On_Classification a inner join HD_District_Classification b on a.DistrictClassificationType = b.DistrictClassificationType where a.DistrictClassificationType is not NULL;

-- 改良分类
insert or ignore into HD_Adjacencies_YieldChangeId_ParentId (YieldChangeId, ParentId) select
  ID || '_' || ImprovementType, ID
from HD_Adjacency_Base_On_Classification a inner join HD_Improvement_Classification b on a.ImprovementClassificationType = b.ImprovementClassificationType where a.ImprovementClassificationType is not NULL;

insert or ignore into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentImprovement, PrereqCivic, PrereqTech, ObsoleteCivic, ObsoleteTech) select
  ID || '_' || ImprovementType, Description, YieldType, YieldChange, TilesRequired, ImprovementType, PrereqCivic, PrereqTech, ObsoleteCivic, ObsoleteTech
from HD_Adjacency_Base_On_Classification a inner join HD_Improvement_Classification b on a.ImprovementClassificationType = b.ImprovementClassificationType where a.ImprovementClassificationType is not NULL;

-- ================================================================================
-- 批量插入
-- ================================================================================
delete from HD_District_Adjacencies_Base_On_Classification where DistrictType not in (select DistrictType from Districts);
delete from HD_Improvement_Adjacencies_Base_On_Classification where ImprovementType not in (select ImprovementType from Improvements);

insert or ignore into District_Adjacencies (DistrictType, YieldChangeId) select
  DistrictType, b.YieldChangeId
from HD_District_Adjacencies_Base_On_Classification a inner join HD_Adjacencies_YieldChangeId_ParentId b on a.YieldChangeId = b.ParentId;

insert or ignore into Improvement_Adjacencies (ImprovementType, YieldChangeId) select
  ImprovementType, b.YieldChangeId
from HD_Improvement_Adjacencies_Base_On_Classification a inner join HD_Adjacencies_YieldChangeId_ParentId b on a.YieldChangeId = b.ParentId;