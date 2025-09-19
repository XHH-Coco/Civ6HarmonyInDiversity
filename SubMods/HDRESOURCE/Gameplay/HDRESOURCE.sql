-- Author: C
-- DateCreated: 6/22/2024 3:29:06 PM
--------------------------------------------------------------
INSERT INTO Types	
	(Type,				Kind)
VALUES	
        ('RESOURCE_C_HEAVENLY_HORSE',   'KIND_RESOURCE'),
        ('RESOURCE_C_ZEBU',             'KIND_RESOURCE');

INSERT INTO TypeTags
			(Type,								Tag)
VALUES	
        ('RESOURCE_C_HEAVENLY_HORSE',			'CLASS_GOLD'),
        ('RESOURCE_C_HEAVENLY_HORSE',			'CLASS_PRODUCTION'),
	('RESOURCE_C_ZEBU',			            'CLASS_GOLD'),
	('RESOURCE_C_ZEBU',			            'CLASS_CULTURE');

INSERT INTO Resources			
		(ResourceType,				Name,					ResourceClassType,	NoRiver,Happiness,Frequency)
VALUES	
        ('RESOURCE_C_HEAVENLY_HORSE',           'LOC_RESOURCE_C_HEAVENLY_HORSE_NAME',		'RESOURCECLASS_LUXURY',	0,4,2), 
        ('RESOURCE_C_ZEBU',	                'LOC_RESOURCE_C_ZEBU_NAME',	                'RESOURCECLASS_LUXURY',	0,4,2);

INSERT INTO Resource_ValidTerrains
		(ResourceType,						TerrainType)
VALUES		
        ('RESOURCE_C_HEAVENLY_HORSE',       'TERRAIN_GRASS'),
        ('RESOURCE_C_HEAVENLY_HORSE',       'TERRAIN_PLAINS'),
        ('RESOURCE_C_ZEBU',                 'TERRAIN_GRASS'),
        ('RESOURCE_C_ZEBU',                 'TERRAIN_GRASS_HILLS'),
        ('RESOURCE_C_ZEBU',                 'TERRAIN_PLAINS'),
        ('RESOURCE_C_ZEBU',                 'TERRAIN_PLAINS_HILLS');
        
INSERT INTO Resource_ValidFeatures
		(ResourceType,			FeatureType)
VALUES
        ('RESOURCE_C_ZEBU',             'FEATURE_FLOODPLAINS_GRASSLAND'),
        ('RESOURCE_C_ZEBU',             'FEATURE_FLOODPLAINS_PLAINS');

INSERT INTO Resource_YieldChanges	
		(ResourceType,			YieldType,		YieldChange)
VALUES	
        ('RESOURCE_C_HEAVENLY_HORSE',	'YIELD_PRODUCTION',	1),
        ('RESOURCE_C_HEAVENLY_HORSE',	'YIELD_GOLD',	        1),
        ('RESOURCE_C_ZEBU',		'YIELD_CULTURE',	1),
        ('RESOURCE_C_ZEBU',		'YIELD_GOLD',		1);

INSERT INTO Improvement_ValidResources	
		(ImprovementType,		ResourceType,		        MustRemoveFeature)
VALUES	
        ('IMPROVEMENT_PASTURE',			'RESOURCE_C_HEAVENLY_HORSE',    0),
        ('IMPROVEMENT_PASTURE',			'RESOURCE_C_ZEBU',              0);