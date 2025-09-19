-- delete from IconDefinitions where
-- 	Name = 'ICON_CIVILIZATION_CHINA' and Atlas = 'ICON_ATLAS_KUBLAIKHAN_VIETNAM_CIVILIZATIONS';


-- Temple of Heaven
--==========================================================================================================================
-- IconTextureAtlases
--==========================================================================================================================
insert or ignore into IconTextureAtlases 
            (Name,                                    IconSize,   Filename,                           IconsPerRow,    IconsPerColumn)
VALUES      ('ICON_ATLAS_TEMPLE_OF_HEAVEN_HDFIX',     32,         'Icon_Temple_Of_Heaven_32',         1,              1),
            ('ICON_ATLAS_TEMPLE_OF_HEAVEN_HDFIX',     38,         'Icon_Temple_Of_Heaven_38',         1,              1),
            ('ICON_ATLAS_TEMPLE_OF_HEAVEN_HDFIX',     50,         'Icon_Temple_Of_Heaven_50',         1,              1),
            ('ICON_ATLAS_TEMPLE_OF_HEAVEN_HDFIX',     64,         'Icon_Temple_Of_Heaven_64',         1,              1),         
            ('ICON_ATLAS_TEMPLE_OF_HEAVEN_HDFIX',     128,        'Icon_Temple_Of_Heaven_128',        1,              1),         
            ('ICON_ATLAS_TEMPLE_OF_HEAVEN_HDFIX',     256,        'Icon_Temple_Of_Heaven_256',        1,              1);
--==========================================================================================================================
-- IconTextureAtlases
--==========================================================================================================================
INSERT OR REPLACE INTO IconDefinitions 
            (Name,                              Atlas,                          'Index')
VALUES      ('ICON_BUILDING_TEMPLE_OF_HEAVEN',  'ICON_ATLAS_TEMPLE_OF_HEAVEN_HDFIX',  0);
--==========================================================================================================================
--==========================================================================================================================

-- Wat Arun
--==========================================================================================================================
-- IconTextureAtlases
--==========================================================================================================================
-- insert or ignore into IconTextureAtlases 
--             (Name,                              IconSize,   Filename,                           IconsPerRow,    IconsPerColumn)
-- VALUES      ('ICON_SUK_WAT_ARUN_ATLAS_HDFIX',   32,         'Icon_Suk_Wat_Arun_32',             1,              1),
--             ('ICON_SUK_WAT_ARUN_ATLAS_HDFIX',   38,         'Icon_Suk_Wat_Arun_38',             1,              1),
--             ('ICON_SUK_WAT_ARUN_ATLAS_HDFIX',   50,         'Icon_Suk_Wat_Arun_50',             1,              1),
--             ('ICON_SUK_WAT_ARUN_ATLAS_HDFIX',   64,         'Icon_Suk_Wat_Arun_64',             1,              1),         
--             ('ICON_SUK_WAT_ARUN_ATLAS_HDFIX',   128,        'Icon_Suk_Wat_Arun_128',            1,              1),         
--             ('ICON_SUK_WAT_ARUN_ATLAS_HDFIX',   256,        'Icon_Suk_Wat_Arun_256',            1,              1);
--==========================================================================================================================
-- IconTextureAtlases
--==========================================================================================================================
-- INSERT OR REPLACE INTO IconDefinitions 
--             (Name,                          Atlas,                      'Index')
-- VALUES      ('ICON_BUILDING_SUK_WAT_ARUN',  'ICON_SUK_WAT_ARUN_ATLAS_HDFIX',   0);
--==========================================================================================================================
--==========================================================================================================================
