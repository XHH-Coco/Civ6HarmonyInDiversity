------------------- 奇观对应资源 -------------------
create table if not exists Wonder_Resources_HD(
  BuildingType TEXT not NULL,
  ResourceType TEXT,
PRIMARY KEY('BuildingType'));

insert or replace into Wonder_Resources_HD (BuildingType) values
  ('BUILDING_BAMYAN'),
  ('BUILDING_BURJ_KHALIFA'),
  ('BUILDING_KILWA_KISIWANI'),
  ('BUILDING_HUEY_TEOCALLI'),
  ('BUILDING_PYRAMIDS'),
  ('BUILDING_GREAT_LIGHTHOUSE'),
  ('BUILDING_GREAT_LIBRARY'),
  ('BUILDING_ABU_SIMBEL'),
  ('BUILDING_SYDNEY_OPERA_HOUSE'),
  ('BUILDING_HANGING_GARDENS'),
  ('BUILDING_ETEMENANKI'),
  ('BUILDING_PANAMA_CANAL'),
  ('BUILDING_CRISTO_REDENTOR'),
  ('BUILDING_ESTADIO_DO_MARACANA'),
  ('BUILDING_HAGIA_SOPHIA'),
  ('BUILDING_APADANA'),
  ('BUILDING_HALICARNASSUS_MAUSOLEUM'),
  ('BUILDING_RUHR_VALLEY'),
  ('BUILDING_NEUSCHWANSTEIN'),
  ('BUILDING_BRANDENBURG_GATE'),
  ('BUILDING_BOLSHOI_THEATRE'),
  ('BUILDING_HERMITAGE'),
  ('BUILDING_ST_BASILS_CATHEDRAL'),
  ('BUILDING_MOTHERLAND_CALLS'),
  ('BUILDING_MONT_ST_MICHEL'),
  ('BUILDING_EIFFEL_TOWER'),
  ('BUILDING_SUK_NOTRE_DAME_DE_PARIS'),
  ('BUILDING_AL_STPETERSBASILICA'),
  ('BUILDING_ANGKOR_WAT'),
  ('CL_BUILDING_CN_TOWER'),
  ('BUILDING_GREAT_ZIMBABWE'),
  ('BUILDING_UNIVERSITY_SANKORE'),
  ('BUILDING_CHICHEN_ITZA'),
  ('BUILDING_BROADWAY'),
  ('BUILDING_STATUE_LIBERTY'),
  ('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION'),
  ('BUILDING_GOLDEN_GATE_BRIDGE'),
  ('BUILDING_BIOSPHERE'),
  ('WON_CL_BUILDING_ARECIBO'),
  ('WON_CL_EMPIRE_STATES'),
  ('BUILDING_JEBEL_BARKAL'),
  ('BUILDING_TORRE_DE_BELEM'),
  ('BUILDING_ITSUKUSHIMA'),
  ('BUILDING_KOTOKU_IN'),
  ('WON_CL_KINKAKU'),
  ('BUILDING_SUK_WAT_ARUN'),
  ('BUILDING_VENETIAN_ARSENAL'),
  ('BUILDING_ALHAMBRA'),
  ('BUILDING_CASA_DE_CONTRATACION'),
  ('BUILDING_ORACLE'),
  ('BUILDING_COLOSSUS'),
  ('BUILDING_TEMPLE_ARTEMIS'),
  ('BUILDING_STATUE_OF_ZEUS'),
  ('P0K_BUILDING_TEMPLE_POSEIDON'),
  ('BUILDING_ORSZAGHAZ'),
  ('BUILDING_COLOSSEUM'),
  ('BUILDING_LEANING_TOWER'),
  ('BUILDING_UFFIZI'),
  ('BUILDING_MAHABODHI_TEMPLE'),
  ('BUILDING_TAJ_MAHAL'),
  ('BUILDING_GREAT_BATH'),
  ('BUILDING_MEENAKSHI_TEMPLE'),
  ('BUILDING_BOROBUDUR'),
  ('BUILDING_MACHU_PICCHU'),
  ('BUILDING_STONEHENGE'),
  ('BUILDING_OXFORD_UNIVERSITY'),
  ('BUILDING_BIG_BEN'),
  ('BUILDING_TOWER_BRIDGE'),
  ('BUILDING_GLOBE_THEATRE'),
  ('BUILDING_PETRA'),
  ('BUILDING_TERRACOTTA_ARMY'),
  ('BUILDING_FORBIDDEN_CITY'),
  ('BUILDING_POTALA_PALACE'),
  ('BUILDING_PORCELAIN_TOWER'),
  ('BUILDING_TEMPLE_OF_HEAVEN'),
  ('BUILDING_PHANTA_BRONZE_BIRD_TERRACE'),
  ('BUILDING_THREE_GORDES_DAM'),
  ('BUILDING_YELLOW_CRANE_HD');

delete from Wonder_Resources_HD where BuildingType not in (select BuildingType from Buildings);
update Wonder_Resources_HD set ResourceType = 'RESOURCE_HD_' || BuildingType;

insert or ignore into Types (Type, Kind) select ResourceType, 'KIND_RESOURCE' from Wonder_Resources_HD;
insert or ignore into Resources (ResourceType, Name, ResourceClassType, Happiness)
  select ResourceType, 'LOC_' || ResourceType || '_NAME', 'RESOURCECLASS_LUXURY', 4 from Wonder_Resources_HD;

insert or ignore into Modifiers (ModifierId, ModifierType)
  select 'HD_GRANT_' || ResourceType, 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT' from Wonder_Resources_HD;

insert or ignore into ModifierArguments (ModifierId, Name, Value)
  select 'HD_GRANT_' || ResourceType, 'ResourceType', ResourceType from Wonder_Resources_HD;

insert or ignore into ModifierArguments (ModifierId, Name, Value)
  select 'HD_GRANT_' || ResourceType, 'Amount', 1 from Wonder_Resources_HD;

------------------- 领袖能力 -------------------
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_MAGNIFICENCES' and ModifierId = 'MAGNIFICENCES_CULTURE_LUXURY_ADJACENT_TO_THEATER_SQUARE_OR_CHATEAU';
insert or replace into TraitModifiers
	(TraitType,							        ModifierId)
values
  ('TRAIT_LEADER_MAGNIFICENCES',  'HD_MAGNIFICENCES_CITY_HAS_LUXURY_TRAIN_UNIT_MOVEMENT');

insert or replace into Modifiers
  (ModifierId,                                                      ModifierType,                                           SubjectRequirementSetId,              Permanent)
values
  ('HD_MAGNIFICENCES_CITY_HAS_LUXURY_TRAIN_UNIT_MOVEMENT',          'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',               'CITY_HAS_IMPROVED_LUXURY_RESOURCE',  0),
  ('HD_MAGNIFICENCES_CITY_HAS_LUXURY_TRAIN_UNIT_MOVEMENT_MODIFIER', 'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS', NULL,                                 1);

insert or ignore into ModifierArguments
  (ModifierId,                                                      Name,             Value)
values
  ('HD_MAGNIFICENCES_CITY_HAS_LUXURY_TRAIN_UNIT_MOVEMENT',          'ModifierId',     'HD_MAGNIFICENCES_CITY_HAS_LUXURY_TRAIN_UNIT_MOVEMENT_MODIFIER'),
  ('HD_MAGNIFICENCES_CITY_HAS_LUXURY_TRAIN_UNIT_MOVEMENT_MODIFIER', 'AbilityType',    'ABILITY_CITY_HAS_LUXURY_TRAIN_UNIT_MOVEMENT');
------------------- 特色项目 -------------------
update Projects set CostProgressionParam1 = 800, Cost = 50, Description = 'LOC_PROJECT_COURT_FESTIVAL_HD_DESCRIPTION' where ProjectType = 'PROJECT_COURT_FESTIVAL';
update ModifierArguments set Value = 10 where ModifierId = 'PROJECT_COMPLETION_GRANT_CULTURE_BASED_ON_EXCESS_LUXURIES' and Name = 'Amount';
update ModifierArguments set Value = 10 where ModifierId = 'PROJECT_COMPLETION_GRANT_TOURISM_BASED_ON_EXCESS_LUXURIES' and Name = 'Amount';

insert or ignore into UniqueProjects_HD
	(ProjectType,				            ModifierId,						          LeaderType)
values
  ('PROJECT_COURT_FESTIVAL',      'MAGNIFICENCES_ALLOW_PROJECT',  'LEADER_CATHERINE_DE_MEDICI_ALT');

insert or replace into ProjectCompletionModifiers
  (ProjectType,                   ModifierId)
values
  ('PROJECT_COURT_FESTIVAL',      'HD_COURT_FESTIVAL_CHATEAU_CULTURE');

insert or replace into Modifiers
  (ModifierId,                              ModifierType,                             SubjectRequirementSetId)
values
  ('HD_COURT_FESTIVAL_CHATEAU_CULTURE',     'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',      'PLOT_HAS_IMPROVEMENT_CHATEAU_REQUIREMENTS');

insert or ignore into ModifierArguments
  (ModifierId,                              Name,           Value)
values
  ('HD_COURT_FESTIVAL_CHATEAU_CULTURE',     'YieldType',    'YIELD_CULTURE'),
  ('HD_COURT_FESTIVAL_CHATEAU_CULTURE',     'Amount',       1);