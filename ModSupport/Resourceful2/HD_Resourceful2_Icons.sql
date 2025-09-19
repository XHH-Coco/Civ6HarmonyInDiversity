--------------------------
-- Resourceful 2 by xhh --
--------------------------

insert or ignore into IconTextureAtlases
	(Name,									IconSize,		IconsPerRow,		IconsPerColumn,			Filename)
values
	('ICON_ATLAS_RESOURCEFUL2_NEW_HD',		32,				8,					2,						'Resourceful2_New_32.dds'),
	('ICON_ATLAS_RESOURCEFUL2_NEW_HD',		38,				8,					2,						'Resourceful2_New_38.dds'),
	('ICON_ATLAS_RESOURCEFUL2_NEW_HD',		50,				8,					2,						'Resourceful2_New_50.dds'),
	('ICON_ATLAS_RESOURCEFUL2_NEW_HD',		64,				8,					2,						'Resourceful2_New_64.dds'),
	('ICON_ATLAS_RESOURCEFUL2_NEW_HD',		128,			8,					2,						'Resourceful2_New_128.dds'),
	('ICON_ATLAS_RESOURCEFUL2_NEW_HD',		256,			8,					2,						'Resourceful2_New_256.dds'),
	('ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	256,			8,					2,						'Resourceful2_New_FOW_256.dds');

insert or ignore into IconTextureAtlases
	(Name,									Baseline,	IconSize,		IconsPerRow,		IconsPerColumn,			Filename)
values
	('ICON_ATLAS_RESOURCEFUL2_NEW_HD',		6,			22,				8,					2,						'Resourceful2_New_22.dds');

-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 0 where Name = 'ICON_RESOURCE_ALOE';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW', "Index" = 0 where Name = 'ICON_RESOURCE_ALOE_FOW';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 0 where Name = 'RESOURCE_ALOE';

-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 1 where Name = 'ICON_RESOURCE_MEDIHERBS';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW', "Index" = 1 where Name = 'ICON_RESOURCE_MEDIHERBS_FOW';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 1 where Name = 'RESOURCE_MEDIHERBS';

-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 2 where Name = 'ICON_RESOURCE_COD';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW', "Index" = 2 where Name = 'ICON_RESOURCE_COD_FOW';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 2 where Name = 'RESOURCE_COD';

-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 3 where Name = 'ICON_RESOURCE_QUARTZ';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW', "Index" = 3 where Name = 'ICON_RESOURCE_QUARTZ_FOW';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 3 where Name = 'RESOURCE_QUARTZ';

-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 4 where Name = 'ICON_RESOURCE_SALMON';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW', "Index" = 4 where Name = 'ICON_RESOURCE_SALMON_FOW';
-- update IconDefinitions set Atlas = 'ICON_ATLAS_RESOURCEFUL2_NEW_HD', "Index" = 4 where Name = 'RESOURCE_SALMON';

insert or replace into IconDefinitions
	(Name,								Atlas,									"Index")
values
	('ICON_RESOURCE_ALOE',				'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		0),
	('ICON_RESOURCE_ALOE_FOW',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	0),
	('RESOURCE_ALOE',					'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		0),

	('ICON_RESOURCE_MEDIHERBS',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		1),
	('ICON_RESOURCE_MEDIHERBS_FOW',		'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	1),
	('RESOURCE_MEDIHERBS',				'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		1),

	('ICON_RESOURCE_COD',				'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		2),
	('ICON_RESOURCE_COD_FOW',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	2),
	('RESOURCE_COD',					'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		2),

	('ICON_RESOURCE_QUARTZ',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		3),
	('ICON_RESOURCE_QUARTZ_FOW',		'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	3),
	('RESOURCE_QUARTZ',					'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		3),

	('ICON_RESOURCE_SALMON',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		4),
	('ICON_RESOURCE_SALMON_FOW',		'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	4),
	('RESOURCE_SALMON',					'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		4),

	('ICON_RESOURCE_LIMESTONE',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		5),
	('ICON_RESOURCE_LIMESTONE_FOW',		'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	5),
	('RESOURCE_LIMESTONE',				'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		5),

	('ICON_RESOURCE_BARLEY',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		6),
	('ICON_RESOURCE_BARLEY_FOW',		'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	6),
	('RESOURCE_BARLEY',					'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		6),

	('ICON_RESOURCE_SEASHELLS',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		8),
	('ICON_RESOURCE_SEASHELLS_FOW',		'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	8),
	('RESOURCE_SEASHELLS',				'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		8),
	
	('ICON_RESOURCE_SORGHUM',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		9),
	('ICON_RESOURCE_SORGHUM_FOW',		'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	9),
	('RESOURCE_SORGHUM',				'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		9),
	
	('ICON_RESOURCE_HAM',			'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		10),
	('ICON_RESOURCE_HAM_FOW',		'ICON_ATLAS_RESOURCEFUL2_NEW_HD_FOW',	10),
	('RESOURCE_HAM',				'ICON_ATLAS_RESOURCEFUL2_NEW_HD',		10),
	
	('ICON_RESOURCE_HONEY',			'ICON_ATLAS_AMATHERIA',		41),
	('ICON_RESOURCE_HONEY_FOW',		'ICON_ATLAS_AMATHERIA_FOW',	41),
	('RESOURCE_HONEY',				'ICON_ATLAS_AMATHERIA',		41);