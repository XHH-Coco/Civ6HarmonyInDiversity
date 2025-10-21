--------------------------------
--  Civilization Bias by xhh  --
--------------------------------

CREATE TABLE 'HD_StartBiasTerrains'(
	'CivilizationType' TEXT NOT NULL,
	'TerrainType' TEXT NOT NULL,
	'Tier' INTEGER NOT NULL
);

CREATE TABLE 'HD_StartBiasFeatures'(
	'CivilizationType' TEXT NOT NULL,
	'FeatureType' TEXT NOT NULL,
	'Tier' INTEGER NOT NULL
);

CREATE TABLE 'HD_StartBiasResources'(
	'CivilizationType' TEXT NOT NULL,
	'ResourceType' TEXT NOT NULL,
	'Tier' INTEGER NOT NULL
);

CREATE TABLE 'HD_StartBiasRivers'(
	'CivilizationType' TEXT NOT NULL,
	'Tier' INTEGER NOT NULL
);

CREATE TABLE 'HD_StartBiasCivilizations'(
	'CivilizationType' TEXT NOT NULL
);

insert or ignore into HD_StartBiasTerrains
	(CivilizationType,						TerrainType,                       	Tier)
values
	('CIVILIZATION_ENGLAND',			'TERRAIN_COAST',										3),
	('CIVILIZATION_GREECE',				'TERRAIN_GRASS_HILLS',							2),
	('CIVILIZATION_GREECE',				'TERRAIN_PLAINS_HILLS',							2),
	('CIVILIZATION_NORWAY',				'TERRAIN_COAST',										1),
	('CIVILIZATION_RUSSIA',				'TERRAIN_TUNDRA',										1),
	('CIVILIZATION_RUSSIA',				'TERRAIN_TUNDRA_HILLS',							1),
	('CIVILIZATION_INDONESIA',		'TERRAIN_COAST',										1),
	('CIVILIZATION_MAPUCHE',			'TERRAIN_GRASS_MOUNTAIN',						1),
	('CIVILIZATION_MAPUCHE',			'TERRAIN_PLAINS_MOUNTAIN',					1),
	('CIVILIZATION_NETHERLANDS',	'TERRAIN_COAST',										2),
	('CIVILIZATION_CANADA',				'TERRAIN_TUNDRA',										1),
	('CIVILIZATION_CANADA',				'TERRAIN_TUNDRA_HILLS',							1),	
	('CIVILIZATION_INCA',					'TERRAIN_PLAINS_MOUNTAIN',					1),
	('CIVILIZATION_INCA',					'TERRAIN_GRASS_MOUNTAIN',						1),
	('CIVILIZATION_INCA',					'TERRAIN_GRASS_HILLS',							3),
	('CIVILIZATION_INCA',					'TERRAIN_PLAINS_HILLS',							3),
	('CIVILIZATION_MALI',					'TERRAIN_DESERT_HILLS',							1),
	('CIVILIZATION_MALI',					'TERRAIN_DESERT',										1),
	('CIVILIZATION_PHOENICIA',		'TERRAIN_COAST',										2),
	('CIVILIZATION_ETHIOPIA',			'TERRAIN_GRASS_HILLS',							1),
	('CIVILIZATION_ETHIOPIA',			'TERRAIN_PLAINS_HILLS',							1),
	('CIVILIZATION_PORTUGAL',			'TERRAIN_COAST',										1);

insert or ignore into HD_StartBiasFeatures
	(CivilizationType,						FeatureType,                    		Tier)
values
	('CIVILIZATION_AMERICA',			'FEATURE_FOREST',										2),
	('CIVILIZATION_AMERICA',			'FEATURE_HD_SWAMP',									2),
	('CIVILIZATION_BRAZIL',				'FEATURE_JUNGLE',										1),
	('CIVILIZATION_EGYPT',				'FEATURE_FLOODPLAINS',							2),
	('CIVILIZATION_EGYPT',				'FEATURE_FLOODPLAINS_GRASSLAND',		2),
	('CIVILIZATION_EGYPT',				'FEATURE_FLOODPLAINS_PLAINS',				2),
	('CIVILIZATION_INDIA',				'FEATURE_FLOODPLAINS_GRASSLAND',		2),
	('CIVILIZATION_INDIA',				'FEATURE_FLOODPLAINS_PLAINS',				2),
	('CIVILIZATION_JAPAN',				'FEATURE_VOLCANO',									3),
	('CIVILIZATION_KONGO',				'FEATURE_FOREST',										2),
	('CIVILIZATION_KONGO',				'FEATURE_JUNGLE',										2),
	('CIVILIZATION_NORWAY',				'FEATURE_SUK_KELP',									2),
	('CIVILIZATION_ROME',					'FEATURE_GEOTHERMAL_FISSURE',				3),
	('CIVILIZATION_SPAIN',				'FEATURE_GEOTHERMAL_FISSURE',				1),
	('CIVILIZATION_INDONESIA',		'FEATURE_REEF',											2),
	('CIVILIZATION_NETHERLANDS',	'FEATURE_REEF',											2),
	('CIVILIZATION_HUNGARY',			'FEATURE_GEOTHERMAL_FISSURE',				2),
	('CIVILIZATION_INCA',					'FEATURE_VOLCANO',									2),
	('CIVILIZATION_OTTOMAN',			'FEATURE_GEOTHERMAL_FISSURE',				2),
	('CIVILIZATION_PHOENICIA',		'FEATURE_REEF',											2),
	('CIVILIZATION_VIETNAM',			'FEATURE_JUNGLE',										1),
	('CIVILIZATION_VIETNAM',			'FEATURE_FOREST',										1),
	('CIVILIZATION_VIETNAM',			'FEATURE_MARSH',										1),
	('CIVILIZATION_VIETNAM',			'FEATURE_HD_SWAMP',									1),
	('CIVILIZATION_PORTUGAL',			'FEATURE_REEF',											2);

insert or ignore into HD_StartBiasResources
	(CivilizationType,						ResourceType,                 	Tier)
values
	('CIVILIZATION_AMERICA',			'RESOURCE_DLV_BISON',						3),
	('CIVILIZATION_AMERICA',			'RESOURCE_OAK',									3),
	('CIVILIZATION_AMERICA',			'RESOURCE_SAKURA',							3),
	('CIVILIZATION_AMERICA',			'RESOURCE_OIL',									5),

	('CIVILIZATION_ARABIA',				'RESOURCE_SUK_CAMEL',						5),
	('CIVILIZATION_ARABIA',				'RESOURCE_WHEAT',								2),
	('CIVILIZATION_ARABIA',				'RESOURCE_DATES',								2),
	('CIVILIZATION_ARABIA',				'RESOURCE_SORGHUM',							2),
	('CIVILIZATION_ARABIA',				'RESOURCE_COTTON',							2),

	('CIVILIZATION_BRAZIL',				'RESOURCE_RUBBER',							1),
	('CIVILIZATION_BRAZIL',				'RESOURCE_BANANAS',							2),
	('CIVILIZATION_BRAZIL',				'RESOURCE_COCOA',								2),
	('CIVILIZATION_BRAZIL',				'RESOURCE_COFFEE',							2),
	('CIVILIZATION_BRAZIL',				'RESOURCE_LEU_P0K_CAPYBARAS',		2),

	('CIVILIZATION_CHINA',				'RESOURCE_STONE',								1),
	('CIVILIZATION_CHINA',				'RESOURCE_SILK',								3),
	('CIVILIZATION_CHINA',				'RESOURCE_BAMBOO',							3),
	('CIVILIZATION_CHINA',				'RESOURCE_MEDIHERBS',						3),
	('CIVILIZATION_CHINA',				'RESOURCE_JADE',								3),
	('CIVILIZATION_CHINA',				'RESOURCE_TEA',									3),

	('CIVILIZATION_ENGLAND',			'RESOURCE_IRON',								2),
	('CIVILIZATION_ENGLAND',			'RESOURCE_COAL',								1),

	('CIVILIZATION_EGYPT',				'RESOURCE_DATES',								3),
	('CIVILIZATION_EGYPT',				'RESOURCE_P0K_PAPYRUS',					3),
	('CIVILIZATION_EGYPT',				'RESOURCE_NITER',								3),

	('CIVILIZATION_FRANCE',				'RESOURCE_WINE',								2),
	('CIVILIZATION_FRANCE',				'RESOURCE_OLIVES',							2),
	('CIVILIZATION_FRANCE',				'RESOURCE_POPPIES',							2),
	('CIVILIZATION_FRANCE',				'RESOURCE_SAFFRON',							2),
	('CIVILIZATION_FRANCE',				'RESOURCE_STRAWBERRY',					2),
	('CIVILIZATION_FRANCE',				'RESOURCE_OAK',									2),

	('CIVILIZATION_GERMANY',			'RESOURCE_COAL',								3),
	('CIVILIZATION_GERMANY',			'RESOURCE_SALT',								3),

	('CIVILIZATION_GREECE',				'RESOURCE_COAL',								3),
	('CIVILIZATION_GREECE',				'RESOURCE_MARBLE',							4),

	('CIVILIZATION_INDIA',				'RESOURCE_C_ZEBU',							1),
	('CIVILIZATION_INDIA',				'RESOURCE_SPICES',							4),
	('CIVILIZATION_INDIA',				'RESOURCE_NITER',								4),

	('CIVILIZATION_JAPAN',				'RESOURCE_SAKURA',							2),
	('CIVILIZATION_JAPAN',				'RESOURCE_DEER',								2),

	('CIVILIZATION_KONGO',				'RESOURCE_PINE',								2),
	('CIVILIZATION_KONGO',				'RESOURCE_SANDALWOOD',					2),
	('CIVILIZATION_KONGO',				'RESOURCE_IVORY',								2),

	('CIVILIZATION_NORWAY',				'RESOURCE_COD',									1),
	('CIVILIZATION_NORWAY',				'RESOURCE_SALMON',							1),

	('CIVILIZATION_ROME',					'RESOURCE_MARBLE',							2),
	('CIVILIZATION_ROME',					'RESOURCE_MERCURY',							2),
	('CIVILIZATION_ROME',					'RESOURCE_LEAD',								2),

	('CIVILIZATION_SCYTHIA',			'RESOURCE_HORSES',							1),
	('CIVILIZATION_SCYTHIA',			'RESOURCE_SHEEP',								2),
	('CIVILIZATION_SCYTHIA',			'RESOURCE_CATTLE',							2),
	('CIVILIZATION_SCYTHIA',			'RESOURCE_C_HEAVENLY_HORSE',		2),

	('CIVILIZATION_SPAIN',				'RESOURCE_HAM',									5),

	('CIVILIZATION_SUMERIA',			'RESOURCE_COTTON',							2),
	('CIVILIZATION_SUMERIA',			'RESOURCE_OLIVES',							2),
	('CIVILIZATION_SUMERIA',			'RESOURCE_JNR_PEAT',						2),
	('CIVILIZATION_SUMERIA',			'RESOURCE_WHEAT',								2),

	('CIVILIZATION_AZTEC',				'RESOURCE_SUK_OBSIDIAN',				2),
	('CIVILIZATION_AZTEC',				'RESOURCE_TOXINS',							2),

	('CIVILIZATION_INDONESIA',		'RESOURCE_SPICES',							5),

	('CIVILIZATION_KHMER',				'RESOURCE_BANANAS',							5),
	('CIVILIZATION_KHMER',				'RESOURCE_CITRUS',							5),

	('CIVILIZATION_POLAND',				'RESOURCE_WHEAT',								2),
	('CIVILIZATION_POLAND',				'RESOURCE_CATTLE',							2),
	('CIVILIZATION_POLAND',				'RESOURCE_FURS',								2),

	('CIVILIZATION_NUBIA',				'RESOURCE_RUBY',								2),
	('CIVILIZATION_NUBIA',				'RESOURCE_DIAMONDS',						2),
	('CIVILIZATION_NUBIA',				'RESOURCE_SILVER',							2),
	('CIVILIZATION_NUBIA',				'RESOURCE_GOLD',								2),
	('CIVILIZATION_NUBIA',				'RESOURCE_IRON',								2),

	('CIVILIZATION_MACEDON',			'RESOURCE_IRON',								3),
	('CIVILIZATION_MACEDON',			'RESOURCE_COPPER',							3),
	('CIVILIZATION_MACEDON',			'RESOURCE_LEAD',								3),

	('CIVILIZATION_PERSIA',				'RESOURCE_IRON',								2),
	('CIVILIZATION_PERSIA',				'RESOURCE_LEAD',								2),
	('CIVILIZATION_PERSIA',				'RESOURCE_GYPSUM',							2),
	('CIVILIZATION_PERSIA',				'RESOURCE_MARBLE',							2),

	('CIVILIZATION_AUSTRALIA',		'RESOURCE_SHEEP',								1),
	('CIVILIZATION_AUSTRALIA',		'RESOURCE_CASHMERE',						1),
	('CIVILIZATION_AUSTRALIA',		'RESOURCE_IRON',								1),
	('CIVILIZATION_AUSTRALIA',		'RESOURCE_GOLD',								1),
	('CIVILIZATION_AUSTRALIA',		'RESOURCE_PEARLS',							3),
	('CIVILIZATION_AUSTRALIA',		'RESOURCE_CATTLE',							3),
	('CIVILIZATION_AUSTRALIA',		'RESOURCE_COAL',								3),

	('CIVILIZATION_CREE',					'RESOURCE_DEER',								2),
	('CIVILIZATION_CREE',					'RESOURCE_DLV_BISON',						2),
	('CIVILIZATION_CREE',					'RESOURCE_FURS',								2),

	('CIVILIZATION_GEORGIA',			'RESOURCE_CITRUS',							3),
	('CIVILIZATION_GEORGIA',			'RESOURCE_TEA',									3),
	('CIVILIZATION_GEORGIA',			'RESOURCE_WINE',								3),

	('CIVILIZATION_KOREA',				'RESOURCE_IRON',								3),

	('CIVILIZATION_MAPUCHE',			'RESOURCE_SHEEP',								3),
	('CIVILIZATION_MAPUCHE',			'RESOURCE_LEU_P0K_POTATOES',		3),
	('CIVILIZATION_MAPUCHE',			'RESOURCE_SUK_CHEESE',					3),
	('CIVILIZATION_MAPUCHE',			'RESOURCE_LEU_P0K_LLAMAS',			3),
	('CIVILIZATION_MAPUCHE',			'RESOURCE_CASHMERE',						3),

	('CIVILIZATION_MONGOLIA',			'RESOURCE_HORSES',							2),
	('CIVILIZATION_MONGOLIA',			'RESOURCE_SHEEP',								2),
	('CIVILIZATION_MONGOLIA',			'RESOURCE_CATTLE',							2),
	('CIVILIZATION_MONGOLIA',			'RESOURCE_C_HEAVENLY_HORSE',		2),

	('CIVILIZATION_SCOTLAND',			'RESOURCE_IRON',								2),
	('CIVILIZATION_SCOTLAND',			'RESOURCE_WHEAT',								4),

	('CIVILIZATION_ZULU',					'RESOURCE_HORSES',							3),
	('CIVILIZATION_ZULU',					'RESOURCE_IVORY',								3),
	('CIVILIZATION_ZULU',					'RESOURCE_TIGER',								3),
	('CIVILIZATION_ZULU',					'RESOURCE_LION',								3),

	('CIVILIZATION_INCA',					'RESOURCE_LEU_P0K_LLAMAS',			2),
	('CIVILIZATION_INCA',					'RESOURCE_MAIZE',								2),
	('CIVILIZATION_INCA',					'RESOURCE_LEU_P0K_QUINOA',			2),
	
	('CIVILIZATION_MALI',					'RESOURCE_IRON',								3),
	('CIVILIZATION_MALI',					'RESOURCE_SALT',								3),
	('CIVILIZATION_MALI',					'RESOURCE_GOLD',								3),

	('CIVILIZATION_OTTOMAN',			'RESOURCE_NITER',								2),
	('CIVILIZATION_OTTOMAN',			'RESOURCE_IRON',								5),
	
	('CIVILIZATION_PHOENICIA',		'RESOURCE_PEARLS',							2),
	('CIVILIZATION_PHOENICIA',		'RESOURCE_DYES',								5),

	('CIVILIZATION_SWEDEN',				'RESOURCE_IRON',								2),

	('CIVILIZATION_GRAN_COLOMBIA','RESOURCE_BANANAS',							1),
	('CIVILIZATION_GRAN_COLOMBIA','RESOURCE_COFFEE',							1),
	('CIVILIZATION_GRAN_COLOMBIA','RESOURCE_SUGAR',								1),
	('CIVILIZATION_GRAN_COLOMBIA','RESOURCE_TOBACCO',							1),
	('CIVILIZATION_GRAN_COLOMBIA','RESOURCE_LEU_P0K_COCA',				1),
	
	('CIVILIZATION_MAYA',					'RESOURCE_MAIZE',								1),
	('CIVILIZATION_MAYA',					'RESOURCE_LEU_P0K_POTATOES',		1),
	('CIVILIZATION_MAYA',					'RESOURCE_STRAWBERRY',					1),

	('CIVILIZATION_BYZANTIUM',		'RESOURCE_HORSES',							2),

	('CIVILIZATION_GAUL',					'RESOURCE_IRON',								2),
	('CIVILIZATION_GAUL',					'RESOURCE_COAL',								2),
	('CIVILIZATION_GAUL',					'RESOURCE_SALT',								2),

	('CIVILIZATION_VIETNAM',			'RESOURCE_IRON',								3),
	('CIVILIZATION_VIETNAM',			'RESOURCE_SPICES',							3),
	('CIVILIZATION_VIETNAM',			'RESOURCE_MEDIHERBS',						3),

	('CIVILIZATION_ETHIOPIA',			'RESOURCE_GOLD',								4),

	('CIVILIZATION_BABYLON_STK',	'RESOURCE_WHEAT',								4),

	('CIVILIZATION_SUK_SIAM',			'RESOURCE_RICE',								1),
	('CIVILIZATION_SUK_SIAM',			'RESOURCE_RUBBER',							4),
	('CIVILIZATION_SUK_SIAM',			'RESOURCE_SUGAR',								4);


insert or ignore into HD_StartBiasRivers
	(CivilizationType,						Tier)
values
	('CIVILIZATION_GERMANY',			1),
	('CIVILIZATION_SUMERIA',			1),
	('CIVILIZATION_KHMER',				1),
	('CIVILIZATION_HUNGARY',			1),
	('CIVILIZATION_BABYLON_STK',	1),
	('CIVILIZATION_SUK_SIAM',			1);

delete from HD_StartBiasTerrains where CivilizationType not in (select CivilizationType from Civilizations);
delete from HD_StartBiasFeatures where CivilizationType not in (select CivilizationType from Civilizations);
delete from HD_StartBiasFeatures where FeatureType not in (select FeatureType from Features);
delete from HD_StartBiasResources where CivilizationType not in (select CivilizationType from Civilizations);
delete from HD_StartBiasResources where ResourceType not in (select ResourceType from Resources);
delete from HD_StartBiasRivers where CivilizationType not in (select CivilizationType from Civilizations);

-- 删除需要被修改关联的文明的原关联
insert or ignore into HD_StartBiasCivilizations (CivilizationType) select CivilizationType from HD_StartBiasTerrains;
insert or ignore into HD_StartBiasCivilizations (CivilizationType) select CivilizationType from HD_StartBiasFeatures;
insert or ignore into HD_StartBiasCivilizations (CivilizationType) select CivilizationType from HD_StartBiasResources;
insert or ignore into HD_StartBiasCivilizations (CivilizationType) select CivilizationType from HD_StartBiasRivers;

delete from StartBiasTerrains where CivilizationType in (select CivilizationType from HD_StartBiasCivilizations);
delete from StartBiasFeatures where CivilizationType in (select CivilizationType from HD_StartBiasCivilizations);
delete from StartBiasResources where CivilizationType in (select CivilizationType from HD_StartBiasCivilizations);
delete from StartBiasRivers where CivilizationType in (select CivilizationType from HD_StartBiasCivilizations);

-- 修改关联
insert or replace into StartBiasTerrains (CivilizationType, TerrainType, Tier) select CivilizationType, TerrainType, Tier from HD_StartBiasTerrains;
insert or replace into StartBiasFeatures (CivilizationType, FeatureType, Tier) select CivilizationType, FeatureType, Tier from HD_StartBiasFeatures;
insert or replace into StartBiasResources (CivilizationType, ResourceType, Tier) select CivilizationType, ResourceType, Tier from HD_StartBiasResources;
insert or replace into StartBiasRivers (CivilizationType, Tier) select CivilizationType, Tier from HD_StartBiasRivers;

-- =======================================================================================================================
-- 负面关联
-- =======================================================================================================================

CREATE TABLE 'HD_Negative_StartBiasTerrains'(
	'CivilizationType' TEXT NOT NULL,
	'TerrainType' TEXT NOT NULL
);

CREATE TABLE 'HD_Negative_StartBiasFeatures'(
	'CivilizationType' TEXT NOT NULL,
	'FeatureType' TEXT NOT NULL
);

CREATE TABLE 'HD_Negative_StartBiasResources'(
	'CivilizationType' TEXT NOT NULL,
	'ResourceType' TEXT NOT NULL
);

CREATE TABLE 'HD_Negative_StartBiasRivers'(
	'CivilizationType' TEXT NOT NULL
);

insert or replace into HD_Negative_StartBiasFeatures (CivilizationType, FeatureType) values
	('CIVILIZATION_AMERICA', 		'FEATURE_FLOODPLAINS'),
	('CIVILIZATION_AMERICA', 		'FEATURE_FLOODPLAINS_GRASSLAND'),
	('CIVILIZATION_AMERICA', 		'FEATURE_FLOODPLAINS_PLAINS'),
	('CIVILIZATION_AUSTRALIA', 	'FEATURE_FLOODPLAINS'),
	('CIVILIZATION_AUSTRALIA', 	'FEATURE_FLOODPLAINS_GRASSLAND'),
	('CIVILIZATION_AUSTRALIA', 	'FEATURE_FLOODPLAINS_PLAINS');

delete from HD_Negative_StartBiasTerrains where CivilizationType not in (select CivilizationType from Civilizations);
delete from HD_Negative_StartBiasFeatures where CivilizationType not in (select CivilizationType from Civilizations);
delete from HD_Negative_StartBiasFeatures where FeatureType not in (select FeatureType from Features);
delete from HD_Negative_StartBiasResources where CivilizationType not in (select CivilizationType from Civilizations);
delete from HD_Negative_StartBiasResources where ResourceType not in (select ResourceType from Resources);
delete from HD_Negative_StartBiasRivers where CivilizationType not in (select CivilizationType from Civilizations);