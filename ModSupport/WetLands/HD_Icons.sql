insert or ignore into IconTextureAtlases	
		(Name,								    IconSize,	IconsPerRow,	IconsPerColumn,	Filename)
VALUES
		-- ('ICON_ATLAS_HD_WETLANDS_FEATURES',		50, 	 	1,				1,				'HD_Swamp_50.dds'),
		-- ('ICON_ATLAS_HD_WETLANDS_FEATURES',		64,			1,				1,				'HD_Swamp_64.dds'),
		-- ('ICON_ATLAS_HD_WETLANDS_FEATURES',		256, 		1,				1,				'HD_Swamp_256.dds'),
		('ICON_ATLAS_HD_WETLANDS_PEAT',			32, 	 	1,				1,				'HD_Peat_32.dds'),
		('ICON_ATLAS_HD_WETLANDS_PEAT',			38, 	 	1,				1,				'HD_Peat_38.dds'),
		('ICON_ATLAS_HD_WETLANDS_PEAT',			50, 	 	1,				1,				'HD_Peat_50.dds'),
		('ICON_ATLAS_HD_WETLANDS_PEAT',			64, 	 	1,				1,				'HD_Peat_64.dds'),
		('ICON_ATLAS_HD_WETLANDS_PEAT',			80, 	 	1,				1,				'HD_Peat_80.dds'),
		('ICON_ATLAS_HD_WETLANDS_PEAT',			128, 	 	1,				1,				'HD_Peat_128.dds'),
		('ICON_ATLAS_HD_WETLANDS_PEAT',			256, 	 	1,				1,				'HD_Peat_256.dds'),
		('ICON_ATLAS_HD_WETLANDS_PEAT_FOW',		256, 	 	1,				1,				'HD_Peat_FOW_256.dds');

insert or ignore into IconTextureAtlases
	(Name,									Baseline,	IconSize,		IconsPerRow,		IconsPerColumn,			Filename)
values
	('ICON_ATLAS_HD_WETLANDS_PEAT',			6,			22,				1,					1,						'HD_Peat_22.dds');

insert or ignore into IconDefinitions	
		(Name,								Atlas, 								'Index')
VALUES 	('ICON_RESOURCE_JNR_PEAT',				'ICON_ATLAS_HD_WETLANDS_PEAT',		0),
		('ICON_RESOURCE_JNR_PEAT_FOW',			'ICON_ATLAS_HD_WETLANDS_PEAT_FOW',	0),
		('RESOURCE_JNR_PEAT',					'ICON_ATLAS_HD_WETLANDS_PEAT',		0),
		('ICON_FEATURE_HD_SWAMP',			'ICON_ATLAS_JNR_WETLANDS_FEATURES',			1);