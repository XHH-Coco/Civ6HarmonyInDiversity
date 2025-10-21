-------------------------------------
--       Wonders Adjustments       --
-------------------------------------

-- Adjust cost
update Buildings set Cost = 180	where BuildingType = 'BUILDING_STONEHENGE';
update Buildings set Cost = 220, Housing = 1, Entertainment = 1 where BuildingType = 'BUILDING_TEMPLE_ARTEMIS';
update Buildings set Cost = 220, Housing = 1 where BuildingType = 'BUILDING_GREAT_BATH';
update Buildings set Cost = 260 where BuildingType = 'BUILDING_HANGING_GARDENS';
update Buildings set Cost = 220 where BuildingType = 'BUILDING_ETEMENANKI';
update Buildings set Cost = 260 where BuildingType = 'BUILDING_PYRAMIDS';
update Buildings set Cost = 260 where BuildingType = 'BUILDING_ORACLE';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_GREAT_LIGHTHOUSE';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_COLOSSUS';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_PETRA';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_COLOSSEUM';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_GREAT_LIBRARY';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_MAHABODHI_TEMPLE';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_TERRACOTTA_ARMY';
update Buildings set Cost = 750, PrereqTech = 'TECH_ARCH_HD' where BuildingType = 'BUILDING_HUEY_TEOCALLI';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_JEBEL_BARKAL';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_APADANA';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_HALICARNASSUS_MAUSOLEUM';
update Buildings set Cost = 420, AdvisorType = 'ADVISOR_CULTURE' where BuildingType = 'BUILDING_STATUE_OF_ZEUS';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_HAGIA_SOPHIA';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_ALHAMBRA';
update Buildings set Cost = 1000, PrereqCivic = null, PrereqTech = 'TECH_ASTRONOMY' where BuildingType = 'BUILDING_CHICHEN_ITZA';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_MONT_ST_MICHEL';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_GREAT_ZIMBABWE';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_ANGKOR_WAT';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_KILWA_KISIWANI';
update Buildings set Cost = 750, Coast = 1 where BuildingType = 'BUILDING_KOTOKU_IN';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_MACHU_PICCHU';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_MEENAKSHI_TEMPLE';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_UNIVERSITY_SANKORE';
update Buildings set Cost = 750, PrereqTech = 'TECH_APPRENTICESHIP' where BuildingType = 'BUILDING_VENETIAN_ARSENAL';
update Buildings set Cost = 1000 where BuildingType = 'BUILDING_FORBIDDEN_CITY';
update Buildings set Cost = 1000, RequiresReligion = 1 where BuildingType = 'BUILDING_ST_BASILS_CATHEDRAL';
update Buildings set Cost = 1000 where BuildingType = 'BUILDING_TAJ_MAHAL';
update Buildings set Cost = 1000, AdjacentDistrict = 'DISTRICT_HARBOR' where BuildingType = 'BUILDING_CASA_DE_CONTRATACION';
update Buildings set Cost = 1000 where BuildingType = 'BUILDING_TORRE_DE_BELEM';
update Buildings set Cost = 750, PrereqCivic = 'CIVIC_FEUDALISM', PrereqTech = null where BuildingType = 'BUILDING_POTALA_PALACE';
update Buildings set Cost = 1360 where BuildingType = 'BUILDING_PANAMA_CANAL';
update Buildings set Cost = 1360 where BuildingType = 'BUILDING_ORSZAGHAZ';
update Buildings set Cost = 1360 where BuildingType = 'BUILDING_RUHR_VALLEY';
update Buildings set Cost = 1360 where BuildingType = 'BUILDING_BOLSHOI_THEATRE';
update Buildings set Cost = 1360 where BuildingType = 'BUILDING_OXFORD_UNIVERSITY';
update Buildings set Cost = 1360 where BuildingType = 'BUILDING_STATUE_LIBERTY';
update Buildings set Cost = 1360 where BuildingType = 'BUILDING_BIG_BEN';
update Buildings set Cost = 1800, PrereqCivic = 'CIVIC_MUSEOLOGY_HD' where BuildingType = 'BUILDING_HERMITAGE';
update Buildings set Cost = 1800 where BuildingType = 'BUILDING_EIFFEL_TOWER';
update Buildings set Cost = 1800, AdjacentDistrict = 'DISTRICT_COMMERCIAL_HUB' where BuildingType = 'BUILDING_BROADWAY';
update Buildings set Cost = 1800, PrereqCivic = 'CIVIC_SOCIAL_SECURITY_SYSTEM_HD' where BuildingType = 'BUILDING_CRISTO_REDENTOR';
update Buildings set Cost = 1800 where BuildingType = 'BUILDING_GOLDEN_GATE_BRIDGE';
update Buildings set Cost = 2000 where BuildingType = 'BUILDING_ESTADIO_DO_MARACANA';
update Buildings set Cost = 2000 where BuildingType = 'BUILDING_BIOSPHERE';
update Buildings set Cost = 2000 where BuildingType = 'BUILDING_SYDNEY_OPERA_HOUSE';
update Buildings set Cost = 2000 where BuildingType = 'BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION';
update Buildings set ObsoleteEra = 'NO_ERA' where IsWonder = 1 and ObsoleteEra != 'NO_ERA';
update Buildings set DefenseModifier = 4 where DefenseModifier != 0;

-- Adjust basic yield
delete from Building_YieldChanges where BuildingType = 'BUILDING_TEMPLE_ARTEMIS' and YieldType = 'YIELD_FOOD';
with Building_YieldChanges_Pre
	(BuildingType,								YieldType,			YieldChange)
as (values
	('BUILDING_HANGING_GARDENS',				'YIELD_FOOD', 		2),
	('BUILDING_GREAT_BATH',						'YIELD_FOOD',		1),
	('BUILDING_GREAT_BATH',						'YIELD_FAITH',		1),
	('BUILDING_ABU_SIMBEL',						'YIELD_FOOD',		1),
	('BUILDING_ABU_SIMBEL',						'YIELD_CULTURE',		1),
	('BUILDING_TEMPLE_ARTEMIS',					'YIELD_PRODUCTION',		1),
	('BUILDING_TEMPLE_ARTEMIS',					'YIELD_GOLD',	3),
	('BUILDING_PETRA',							'YIELD_FOOD',		1),
	('BUILDING_PETRA',							'YIELD_PRODUCTION',	1),
	('BUILDING_GREAT_LIGHTHOUSE',				'YIELD_GOLD',		6),
	('BUILDING_TERRACOTTA_ARMY',				'YIELD_CULTURE',	2),
	('BUILDING_HUEY_TEOCALLI',					'YIELD_FOOD',		1),
	('BUILDING_HUEY_TEOCALLI',					'YIELD_PRODUCTION',		1),
	('BUILDING_HUEY_TEOCALLI',					'YIELD_FAITH',		2),
	('BUILDING_APADANA',						'YIELD_CULTURE',	1),
	('BUILDING_APADANA',						'YIELD_GOLD',		3),
	('BUILDING_HALICARNASSUS_MAUSOLEUM',		'YIELD_PRODUCTION',	1),
	('BUILDING_HALICARNASSUS_MAUSOLEUM',		'YIELD_CULTURE',	1),
	('BUILDING_MAHABODHI_TEMPLE',				'YIELD_FAITH',		2),
	('BUILDING_JEBEL_BARKAL',					'YIELD_CULTURE',	1),
	('BUILDING_JEBEL_BARKAL',					'YIELD_FAITH',		1),
	('BUILDING_COLOSSUS',						'YIELD_PRODUCTION',	1),
	('BUILDING_ALHAMBRA',						'YIELD_PRODUCTION',	2),
	('BUILDING_ALHAMBRA',						'YIELD_CULTURE',	2),
	('BUILDING_CHICHEN_ITZA',					'YIELD_CULTURE',	2),
	('BUILDING_CHICHEN_ITZA',					'YIELD_FAITH',		2),
	('BUILDING_ANGKOR_WAT',						'YIELD_FOOD',		2),
	('BUILDING_ANGKOR_WAT',						'YIELD_FAITH',		2),
	('BUILDING_KILWA_KISIWANI',					'YIELD_GOLD',		12),
	('BUILDING_GREAT_ZIMBABWE',					'YIELD_GOLD',		12),
	('BUILDING_MACHU_PICCHU',					'YIELD_FOOD',		2),
	('BUILDING_MACHU_PICCHU',					'YIELD_PRODUCTION', 2),
	('BUILDING_KOTOKU_IN',						'YIELD_CULTURE',	2),
	('BUILDING_KOTOKU_IN',						'YIELD_FAITH',		2),
	('BUILDING_MONT_ST_MICHEL',					'YIELD_FAITH',		4),
	('BUILDING_MEENAKSHI_TEMPLE',				'YIELD_CULTURE',	2),
	('BUILDING_MEENAKSHI_TEMPLE',				'YIELD_FAITH',		2),
	('BUILDING_UNIVERSITY_SANKORE',				'YIELD_SCIENCE',	5),
	('BUILDING_VENETIAN_ARSENAL',				'YIELD_PRODUCTION',	4),
	('BUILDING_CASA_DE_CONTRATACION',			'YIELD_GOLD',		6),
	('BUILDING_CASA_DE_CONTRATACION',			'YIELD_PRODUCTION',	2),
	('BUILDING_FORBIDDEN_CITY',					'YIELD_CULTURE',	4),
	('BUILDING_ST_BASILS_CATHEDRAL',			'YIELD_PRODUCTION',		1),
	('BUILDING_ST_BASILS_CATHEDRAL',			'YIELD_CULTURE',		1),
	('BUILDING_ST_BASILS_CATHEDRAL',			'YIELD_FAITH',		2),
	('BUILDING_TAJ_MAHAL',						'YIELD_CULTURE',	2),
	('BUILDING_TAJ_MAHAL',						'YIELD_FAITH',		2),
	('BUILDING_POTALA_PALACE',					'YIELD_CULTURE',	2),
	('BUILDING_POTALA_PALACE',					'YIELD_FAITH',		2),
	('BUILDING_TORRE_DE_BELEM',					'YIELD_GOLD',		12),
	('BUILDING_RUHR_VALLEY',					'YIELD_PRODUCTION',	6),
	('BUILDING_BIG_BEN',						'YIELD_PRODUCTION',	3),
	('BUILDING_BIG_BEN',						'YIELD_GOLD',		9),
	('BUILDING_ORSZAGHAZ',						'YIELD_CULTURE',	6),
	('BUILDING_HERMITAGE',						'YIELD_CULTURE',	8),
	('BUILDING_HERMITAGE',						'YIELD_FAITH',		8),
	('BUILDING_BOLSHOI_THEATRE',				'YIELD_CULTURE',	6),
	('BUILDING_OXFORD_UNIVERSITY',				'YIELD_SCIENCE',	6),
	('BUILDING_STATUE_LIBERTY',					'YIELD_CULTURE',	2),
	('BUILDING_STATUE_LIBERTY',					'YIELD_GOLD',		12),
	('BUILDING_PANAMA_CANAL',					'YIELD_GOLD',		18),
	('BUILDING_EIFFEL_TOWER',					'YIELD_CULTURE',	6),
	('BUILDING_BROADWAY',						'YIELD_CULTURE',	6),
	('BUILDING_CRISTO_REDENTOR',				'YIELD_FAITH',		8),
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION','YIELD_SCIENCE',	6),
	('BUILDING_GOLDEN_GATE_BRIDGE',				'YIELD_GOLD',		18),
	('BUILDING_BIOSPHERE',						'YIELD_FOOD',		2),
	('BUILDING_BIOSPHERE',						'YIELD_PRODUCTION',	2),
	('BUILDING_BIOSPHERE',						'YIELD_SCIENCE',	2),
	('BUILDING_SYDNEY_OPERA_HOUSE',				'YIELD_CULTURE',	6),

	('BUILDING_ITSUKUSHIMA',					'YIELD_CULTURE',	1),
	('BUILDING_BAMYAN',							'YIELD_FAITH',		1),
	('BUILDING_BAMYAN',							'YIELD_GOLD',		3),
	('BUILDING_BOROBUDUR',						'YIELD_CULTURE',	1),
	('BUILDING_PHANTA_BRONZE_BIRD_TERRACE', 'YIELD_CULTURE',	2),
	('BUILDING_LEANING_TOWER',					'YIELD_SCIENCE',	4),
	('BUILDING_UFFIZI',							'YIELD_CULTURE',	2),
	('BUILDING_UFFIZI',							'YIELD_GOLD',		6),
	('BUILDING_SUK_WAT_ARUN',					'YIELD_CULTURE',	2),
	('BUILDING_SUK_WAT_ARUN',					'YIELD_FAITH',	2),
	('BUILDING_PORCELAIN_TOWER',				'YIELD_CULTURE',	2),
	('BUILDING_PORCELAIN_TOWER',				'YIELD_PRODUCTION',	2),
	('BUILDING_TOWER_BRIDGE',					'YIELD_PRODUCTION',	4),
	('BUILDING_TOWER_BRIDGE',					'YIELD_GOLD',		6),
	('WON_CL_EMPIRE_STATES',					'YIELD_PRODUCTION',	4),
	('WON_CL_EMPIRE_STATES',					'YIELD_GOLD',		6),
	('BUILDING_MOTHERLAND_CALLS',				'YIELD_PRODUCTION',	4),
	('BUILDING_MOTHERLAND_CALLS',				'YIELD_CULTURE',	4),
	('BUILDING_THREE_GORDES_DAM',				'YIELD_PRODUCTION',	4),
	('BUILDING_THREE_GORDES_DAM',				'YIELD_FOOD',		4),
	('BUILDING_BURJ_KHALIFA',					'YIELD_GOLD',		18),
	('CL_BUILDING_CN_TOWER',					'YIELD_GOLD',		18),
	('WON_CL_BUILDING_ARECIBO',					'YIELD_SCIENCE',	6))
insert or replace into Building_YieldChanges
	(BuildingType,	YieldType,	YieldChange)
select
	BuildingType,	YieldType,	YieldChange
from Building_YieldChanges_Pre where BuildingType in (select BuildingType from Buildings);
with Building_YieldChangesBonusWithPower_Pre
	(BuildingType,								YieldType,			YieldChange)
as (values
	('BUILDING_EIFFEL_TOWER',					'YIELD_CULTURE',	2),
	('BUILDING_TOWER_BRIDGE',					'YIELD_GOLD',		6),
	('BUILDING_GOLDEN_GATE_BRIDGE',				'YIELD_GOLD',		6),
	('BUILDING_BROADWAY',						'YIELD_CULTURE',	2),
	('WON_CL_EMPIRE_STATES',					'YIELD_GOLD',		6),

	('BUILDING_BURJ_KHALIFA',					'YIELD_GOLD',		12),
	('BUILDING_BIOSPHERE',						'YIELD_SCIENCE',	4),
	('CL_BUILDING_CN_TOWER',					'YIELD_CULTURE',	4),
	('BUILDING_SYDNEY_OPERA_HOUSE',				'YIELD_CULTURE',	4),
	('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION','YIELD_SCIENCE',	4),
	('WON_CL_BUILDING_ARECIBO',					'YIELD_SCIENCE',	4))
insert or replace into Building_YieldChangesBonusWithPower
	(BuildingType,	YieldType,	YieldChange)
select
	BuildingType,	YieldType,	YieldChange
from Building_YieldChangesBonusWithPower_Pre where BuildingType in (select BuildingType from Buildings);
insert or ignore into Buildings_XP2 (BuildingType) select BuildingType from Buildings where BuildingType in (
	'NAT_WONDER_CL_THEMEPARK',
	'NAT_WONDER_CL_THEMEPARK_INTERNAL',
	'NAT_WON_CL_FINANCE',
	'NAT_WON_CL_FINANCE_INTERNAL',
	'BUILDING_EIFFEL_TOWER', 
	'BUILDING_TOWER_BRIDGE',
	'BUILDING_GOLDEN_GATE_BRIDGE',
	'BUILDING_BROADWAY',
	'WON_CL_EMPIRE_STATES',

	'NAT_WON_CL_AIRPORT',
	'NAT_WON_CL_AIRPORT_INTERNAL',
	'BUILDING_BURJ_KHALIFA',
	'BUILDING_BIOSPHERE',
	'CL_BUILDING_CN_TOWER',
	'BUILDING_SYDNEY_OPERA_HOUSE',
	'BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION',
	'WON_CL_BUILDING_ARECIBO'
);
update Buildings_XP2 set RequiredPower = 3 where BuildingType in (
	'NAT_WONDER_CL_THEMEPARK',
	'NAT_WONDER_CL_THEMEPARK_INTERNAL',
	'NAT_WON_CL_FINANCE',
	'NAT_WON_CL_FINANCE_INTERNAL',
	'BUILDING_EIFFEL_TOWER',
	'BUILDING_TOWER_BRIDGE',
	'BUILDING_GOLDEN_GATE_BRIDGE',
	'BUILDING_BROADWAY',
	'WON_CL_EMPIRE_STATES');
update Buildings_XP2 set RequiredPower = 6 where BuildingType in (
	'NAT_WON_CL_AIRPORT',
	'NAT_WON_CL_AIRPORT_INTERNAL',
	'BUILDING_BURJ_KHALIFA',
	'BUILDING_BIOSPHERE',
	'CL_BUILDING_CN_TOWER',
	'BUILDING_SYDNEY_OPERA_HOUSE',
	'BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION',
	'WON_CL_BUILDING_ARECIBO');

-- Enable Wonders on Mountain
insert or replace into Building_ValidTerrains (BuildingType,	TerrainType)
select a.BuildingType,	b.TerrainType
from Buildings a, Terrains b where
	a.BuildingType in ('BUILDING_ORACLE', 'BUILDING_POTALA_PALACE', 'BUILDING_CRISTO_REDENTOR', 'BUILDING_NEUSCHWANSTEIN', 'BUILDING_ALHAMBRA', 'BUILDING_YELLOW_CRANE_HD') and
	b.TerrainType like 'TERRAIN_%_MOUNTAIN';
insert or replace into Building_ValidTerrains
	(BuildingType,		TerrainType)
values
	('BUILDING_PETRA',	'TERRAIN_DESERT_HILLS'),
	('BUILDING_PETRA',	'TERRAIN_DESERT_MOUNTAIN'),
	('BUILDING_OXFORD_UNIVERSITY',	'TERRAIN_TUNDRA'),
	('BUILDING_OXFORD_UNIVERSITY',	'TERRAIN_SNOW'),
	('BUILDING_OXFORD_UNIVERSITY',	'TERRAIN_DESERT');

-- Adjust building effects
-- Great Bath
update Buildings set PrereqTech = 'TECH_IRRIGATION' where BuildingType = 'BUILDING_GREAT_BATH';
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('BUILDING_GREAT_BATH',			'GREAT_BATH_FAITH_PURCHASE_AQUEDUCT_BUILDINGS');
-- 	('BUILDING_GREAT_BATH',			'GREAT_BATH_RIVER_FOOD'),
-- 	('BUILDING_GREAT_BATH',			'GREAT_BATH_RIVER_CULTURE');

insert or replace into  BuildingModifiers(BuildingType,					ModifierId)
select 'BUILDING_GREAT_BATH', 'GREAT_BATH_AQUEDUCT_BUILDINGS_' || YieldType || '_MODIFIER' from Yields;
insert or replace into  Modifiers(ModifierId,					ModifierType)
select 'GREAT_BATH_AQUEDUCT_BUILDINGS_' || YieldType || '_MODIFIER', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT' from Yields;
insert or replace into  ModifierArguments(ModifierId,	Name,	Value)
select 'GREAT_BATH_AQUEDUCT_BUILDINGS_' || YieldType || '_MODIFIER', 'DistrictType', 'DISTRICT_AQUEDUCT' from Yields;
insert or replace into  ModifierArguments(ModifierId,	Name,	Value)
select 'GREAT_BATH_AQUEDUCT_BUILDINGS_' || YieldType || '_MODIFIER', 'YieldType', YieldType from Yields;
insert or replace into  ModifierArguments(ModifierId,	Name,	Value)
select 'GREAT_BATH_AQUEDUCT_BUILDINGS_' || YieldType || '_MODIFIER', 'Amount', 50 from Yields;

insert or replace into Modifiers
	(ModifierId,					ModifierType,											SubjectRequirementSetId)
values
	('GREAT_BATH_FAITH_PURCHASE_AQUEDUCT_BUILDINGS',	'MODIFIER_PLAYER_CITIES_ENABLE_BUILDING_FAITH_PURCHASE',	NULL);
	-- ('GREAT_BATH_RIVER_FOOD',		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',		'PLOT_ADJACENT_TO_RIVER_REQUIREMENTS'),
	-- ('GREAT_BATH_RIVER_CULTURE',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',		'PLOT_ADJACENT_TO_RIVER_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,					Name,			Value)
values
	('GREAT_BATH_FAITH_PURCHASE_AQUEDUCT_BUILDINGS',	'DistrictType',	'DISTRICT_AQUEDUCT');
	-- ('GREAT_BATH_RIVER_FOOD',		'YieldType',	'YIELD_FOOD'),
	-- ('GREAT_BATH_RIVER_FOOD',		'Amount',		1),
	-- ('GREAT_BATH_RIVER_CULTURE',	'YieldType',	'YIELD_CULTURE'),
	-- ('GREAT_BATH_RIVER_CULTURE',	'Amount',		1);

-- insert or replace into BuildingModifiers
-- 	(BuildingType,					ModifierId)
-- select
-- 	'BUILDING_GREAT_BATH',	'GREAT_BATH_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY'
-- from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

-- insert or replace into Modifiers
-- 	(ModifierId,																																ModifierType)
-- select
-- 	'GREAT_BATH_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',		'MODIFIER_PLAYER_CITIES_FEATURE_ADJACENCY'
-- from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

-- insert or replace into ModifierArguments
-- 	(ModifierId,																															Name,						Value)
-- select
-- 	'GREAT_BATH_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'DistrictType',	a.DistrictType
-- from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

-- insert or replace into ModifierArguments
-- 	(ModifierId,																															Name,						Value)
-- select
-- 	'GREAT_BATH_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'FeatureType',	b.FeatureType
-- from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

-- insert or replace into ModifierArguments
-- 	(ModifierId,																															Name,						Value)
-- select
-- 	'GREAT_BATH_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'YieldType',		a.YieldType
-- from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

-- insert or replace into ModifierArguments
-- 	(ModifierId,																															Name,						Value)
-- select
-- 	'GREAT_BATH_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'Amount',				1
-- from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

-- insert or replace into ModifierArguments
-- 	(ModifierId,																															Name,						Value)
-- select
-- 	'GREAT_BATH_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'TilesRequired',2
-- from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

-- insert or replace into ModifierArguments
-- 	(ModifierId,																															Name,						Value)
-- select
-- 	'GREAT_BATH_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'Description',	'LOC_GREAT_BATH_' || a.YieldType
-- from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

-- Alhambra
update Buildings set Entertainment = 0, AdjacentDistrict = null where BuildingType = 'BUILDING_ALHAMBRA';
delete from BuildingModifiers where BuildingType = 'BUILDING_ALHAMBRA';
insert or replace into Building_GreatWorks
	(BuildingType,					GreatWorkSlotType,				NumSlots)
values
	('BUILDING_ALHAMBRA',		'GREATWORKSLOT_PALACE',		2);
delete from Building_GreatPersonPoints where BuildingType = 'BUILDING_ALHAMBRA';
insert or replace into Building_GreatPersonPoints
	(BuildingType,			GreatPersonClassType,			PointsPerTurn)
values
	('BUILDING_ALHAMBRA',	'GREAT_PERSON_CLASS_ARTIST',		2),
	('BUILDING_ALHAMBRA',	'GREAT_PERSON_CLASS_MUSICIAN',	2);

insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('BUILDING_ALHAMBRA',		'HD_ALHAMBRA_NOT_FOUNDED_CITY_AMENITY');

insert or replace into Modifiers
	(ModifierId,															ModifierType,																		SubjectRequirementSetId)
values
	('HD_ALHAMBRA_NOT_FOUNDED_CITY_AMENITY',	'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',	'HD_BREATHTAKING_CITY_NOT_FOUNDED');

insert or replace into ModifierArguments
	(ModifierId,															Name,				Value)
values
	('HD_ALHAMBRA_NOT_FOUNDED_CITY_AMENITY',	'Amount',		2);

insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'BUILDING_ALHAMBRA',		'BUILDING_ALHAMBRA_CITY_CENTER_' || YieldType || '_BONUS'
from Yields;

insert or replace into Modifiers
	(ModifierId,																								ModifierType,																														SubjectRequirementSetId)
select
	'BUILDING_ALHAMBRA_CITY_CENTER_' || YieldType || '_BONUS',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',	'HD_BREATHTAKING_CITY_FOUNDED'
from Yields;

insert or replace into ModifierArguments
	(ModifierId,																								Name,							Value)
select
	'BUILDING_ALHAMBRA_CITY_CENTER_' || YieldType || '_BONUS',	'DistrictType',		'DISTRICT_CITY_CENTER'
from Yields;

insert or replace into ModifierArguments
	(ModifierId,																								Name,							Value)
select
	'BUILDING_ALHAMBRA_CITY_CENTER_' || YieldType || '_BONUS',	'YieldType',			YieldType
from Yields;

insert or replace into ModifierArguments
	(ModifierId,																								Name,							Value)
select
	'BUILDING_ALHAMBRA_CITY_CENTER_' || YieldType || '_BONUS',	'Amount',					100
from Yields;


-- Oracle
update ModifierArguments set Value = 6 where ModifierId like 'ORACLE_GREAT%POINTS' and Name = 'Amount';

-- Petra
update Buildings set PrereqTech = 'TECH_CURRENCY' where BuildingType = 'BUILDING_PETRA';
update Modifiers set ModifierType = 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD' where ModifierId = 'PETRA_YIELD_MODIFIER';
update ModifierArguments set Value = '3,2,1' where ModifierId = 'PETRA_YIELD_MODIFIER' and Name = 'Amount';
insert or replace into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
values
	('PETRA_YIELD_MODIFIER_REQUIREMENTS',	'REQUIRES_OBJECT_WITHIN_5_TILES');

-- St. Basil's Cathedral
update ModifierArguments set Value = 2 where ModifierId = 'STBASILS_ADDFOOD_MODIFIER' and Name = 'Amount';

-- 布达拉宫
update Buildings set AdjacentToMountain = 0 where BuildingType = 'BUILDING_POTALA_PALACE';
delete from BuildingModifiers where BuildingType = 'BUILDING_POTALA_PALACE' and ModifierId = 'POTALA_PALACE_DIPLOMATIC_GOVERNMENT_SLOT';

insert or replace into Building_GreatWorks
	(BuildingType,							GreatWorkSlotType,			NumSlots, ThemingSameObjectType,	ThemingYieldMultiplier,	ThemingTourismMultiplier,	ThemingBonusDescription)
values
	('BUILDING_POTALA_PALACE',	'GREATWORKSLOT_RELIC',	3,				1,											100,										100,											'LOC_BUILDING_THEMINGBONUS_POTALA_PALACE');

insert or replace into GlobalParameters
	(Name,															Value)
values
	('HD_POTALA_PALACE_COPY_FOLLOWER',	1),
	('HD_POTALA_PALACE_EXTRA_FOUNDER',	1),
	('HD_POTALA_PALACE_EXTRA_ENHANCER',	1);

-- Chichen Itza
delete from BuildingModifiers where BuildingType = 'BUILDING_CHICHEN_ITZA';
insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
values
	('BUILDING_CHICHEN_ITZA',				'CHICHEN_ITZA_DIPLOMATIC_GOVERNMENT_SLOT'),
	('BUILDING_CHICHEN_ITZA',				'CHICHEN_ITZA_GOLDEN_FAITH'),
	('BUILDING_CHICHEN_ITZA',				'CHICHEN_ITZA_NORMAL_PRODUCTION'),
	('BUILDING_CHICHEN_ITZA',				'CHICHEN_ITZA_DISTRICT_CULTURE'),
	('BUILDING_CHICHEN_ITZA',				'CHICHEN_ITZA_DISTRICT_FAITH');
insert or replace into Modifiers
	(ModifierId, 							ModifierType,												SubjectRequirementSetId)
values
	('CHICHEN_ITZA_DIPLOMATIC_GOVERNMENT_SLOT',		'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER',		null),
	('CHICHEN_ITZA_SACRIFICE_FAITH',		'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',		null),
	('CHICHEN_ITZA_SACRIFICE_CULTURE',		'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',		null),
	('CHICHEN_ITZA_GOLDEN_FAITH',			'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',		'PLAYER_HAS_GOLDEN_AGE'),
	('CHICHEN_ITZA_NORMAL_PRODUCTION',		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',		'PLAYER_NOT_HAS_GOLDEN_AGE'),
	('CHICHEN_ITZA_DISTRICT_CULTURE',		'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',			'CHICHEN_ITZA_REQUIREMENTS'),
	('CHICHEN_ITZA_DISTRICT_FAITH',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',			'CHICHEN_ITZA_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,								Name,					Value)
values
	('CHICHEN_ITZA_DIPLOMATIC_GOVERNMENT_SLOT',			'GovernmentSlotType',			'SLOT_DIPLOMATIC'),
	('CHICHEN_ITZA_SACRIFICE_FAITH',			'BuildingType',			'BUILDING_CHICHEN_ITZA'),
	('CHICHEN_ITZA_SACRIFICE_FAITH',			'YieldType',			'YIELD_FAITH'),
	('CHICHEN_ITZA_SACRIFICE_FAITH',			'Amount',				1),
	('CHICHEN_ITZA_SACRIFICE_CULTURE',			'BuildingType',			'BUILDING_CHICHEN_ITZA'),
	('CHICHEN_ITZA_SACRIFICE_CULTURE',			'YieldType',			'YIELD_CULTURE'),
	('CHICHEN_ITZA_SACRIFICE_CULTURE',			'Amount',				1),
	('CHICHEN_ITZA_GOLDEN_FAITH',				'YieldType',			'YIELD_FAITH'),
	('CHICHEN_ITZA_GOLDEN_FAITH',				'Amount',				10),
	('CHICHEN_ITZA_NORMAL_PRODUCTION',			'YieldType',			'YIELD_PRODUCTION'),
	('CHICHEN_ITZA_NORMAL_PRODUCTION',			'Amount',				10),
	('CHICHEN_ITZA_DISTRICT_CULTURE',			'YieldType',			'YIELD_CULTURE'),
	('CHICHEN_ITZA_DISTRICT_CULTURE',			'Amount',				2),
	('CHICHEN_ITZA_DISTRICT_FAITH',				'YieldType',			'YIELD_FAITH'),
	('CHICHEN_ITZA_DISTRICT_FAITH',				'Amount',				2);
insert or replace into GlobalParameters (Name, Value) values ('CHICHEN_ITZA_PERCENTAGE', 25);

-- Great Lighthouse
insert or ignore into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('BUILDING_GREAT_LIGHTHOUSE',	'GREAT_LIGHTHOUSE_GRANTS_ADMIRAL');
insert or replace into Modifiers
	(ModifierId,							ModifierType,												RunOnce,	Permanent)
values
	('GREAT_LIGHTHOUSE_GRANTS_ADMIRAL',		'MODIFIER_SINGLE_CITY_GRANT_GREAT_PERSON_CLASS_IN_CITY',	1,			1);
insert or replace into ModifierArguments
	(ModifierId,							Name,						Value)
values
	('GREAT_LIGHTHOUSE_GRANTS_ADMIRAL',		'Amount',					1),
	('GREAT_LIGHTHOUSE_GRANTS_ADMIRAL',		'GreatPersonClassType',		'GREAT_PERSON_CLASS_ADMIRAL');
update Building_GreatPersonPoints set PointsPerTurn = 2 where BuildingType = 'BUILDING_GREAT_LIGHTHOUSE';

-- Panama Canal
insert or ignore into BuildingModifiers
	(BuildingType,				ModifierId)
values
	('BUILDING_PANAMA_CANAL',	'PANAMA_CANAL_GRANTS_MERCHANT');
insert or ignore into Modifiers
	(ModifierId,						ModifierType,												RunOnce,	Permanent)
values
	('PANAMA_CANAL_GRANTS_MERCHANT',	'MODIFIER_SINGLE_CITY_GRANT_GREAT_PERSON_CLASS_IN_CITY',	1,			1);
insert or ignore into ModifierArguments
	(ModifierId,						Name,						Value)
values
	('PANAMA_CANAL_GRANTS_MERCHANT',	'Amount',					1),
	('PANAMA_CANAL_GRANTS_MERCHANT',	'GreatPersonClassType',		'GREAT_PERSON_CLASS_MERCHANT');

-- Great Zimbabwe
update Buildings set AdjacentResource = null, AdjacentImprovement = 'IMPROVEMENT_PASTURE', PrereqTech = 'TECH_ARCH_HD' where BuildingType = 'BUILDING_GREAT_ZIMBABWE';
delete from BuildingModifiers where BuildingType = 'BUILDING_GREAT_ZIMBABWE';
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('BUILDING_GREAT_ZIMBABWE',		'GREAT_ZIMBABWE_BONUS_GOLD_ATTACH'),
	('BUILDING_GREAT_ZIMBABWE',		'GREAT_ZIMBABWE_BONUS_GOLD_ATTACH2'),
	('BUILDING_GREAT_ZIMBABWE',		'GREAT_ZIMBABWE_TRADEROUTE'),
	('BUILDING_GREAT_ZIMBABWE',		'GREAT_ZIMBABWE_TRADER');
insert or replace into Modifiers
	(ModifierId,							ModifierType,														SubjectRequirementSetId)
values
	('GREAT_ZIMBABWE_BONUS_GOLD_ATTACH',	'MODIFIER_PLAYER_IMPROVEMENTS_ATTACH_MODIFIER',						'GREAT_ZIMBABWE_REQUIREMENTS'),
	('GREAT_ZIMBABWE_BONUS_GOLD_ATTACH2',	'MODIFIER_PLAYER_IMPROVEMENTS_ATTACH_MODIFIER',						'GREAT_ZIMBABWE_REQUIREMENTS'),
	('GREAT_ZIMBABWE_BONUS_GOLD',			'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	null),
	('GREAT_ZIMBABWE_BONUS_GOLD2',			'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS',	null),
	('GREAT_ZIMBABWE_TRADEROUTE',			'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',						NULL),
	('GREAT_ZIMBABWE_TRADER',				'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',							NULL);
insert or replace into ModifierArguments
	(ModifierId,							Name,			Value)
values
	('GREAT_ZIMBABWE_BONUS_GOLD_ATTACH',	'ModifierId',	'GREAT_ZIMBABWE_BONUS_GOLD'),
	('GREAT_ZIMBABWE_BONUS_GOLD_ATTACH2',	'ModifierId',	'GREAT_ZIMBABWE_BONUS_GOLD2'),
	('GREAT_ZIMBABWE_BONUS_GOLD',			'YieldType',	'YIELD_GOLD'),
	('GREAT_ZIMBABWE_BONUS_GOLD',			'Amount',		3),
	('GREAT_ZIMBABWE_BONUS_GOLD2',			'YieldType',	'YIELD_GOLD'),
	('GREAT_ZIMBABWE_BONUS_GOLD2',			'Amount',		3),
	('GREAT_ZIMBABWE_BONUS_GOLD2',			'Domestic',		1),
	('GREAT_ZIMBABWE_TRADEROUTE',			'Amount',		1),
	('GREAT_ZIMBABWE_TRADER',				'Amount',		1),
	('GREAT_ZIMBABWE_TRADER',				'UnitType',		'UNIT_TRADER');

-- Broadway
insert or replace into BuildingPrereqs
	(Building,				PrereqBuilding)
values 
	('BUILDING_BROADWAY',	'BUILDING_STOCK_EXCHANGE');
update Building_GreatWorks set NumSlots = 2 where BuildingType = 'BUILDING_BROADWAY' and GreatWorkSlotType = 'GREATWORKSLOT_WRITING';

insert or replace into GlobalParameters
	(Name,											Value)
values
	('HD_BROADWAY_GOLD_PER_GREAT_PERSON',	150),
	('HD_BROADWAY_CULTURE_PER_GREAT_PERSON',	25);

update ModifierArguments set Value = 30 where ModifierId = 'BROADWAY_ADDCULTUREYIELD' and Name = 'Amount';
delete from BuildingModifiers where BuildingType = 'BUILDING_BROADWAY' and ModifierId = 'BUILDING_BROADWAY_RANDOMCIVICBOOST';
insert or ignore into BuildingModifiers
	(BuildingType,				ModifierId)
values
	('BUILDING_BROADWAY',		'BROADWAY_GRANTS_MUSICIAN'),
	('BUILDING_BROADWAY', 		'BROADWAY_REGIONAL_POP_CULTURE');
	-- ('BUILDING_BROADWAY', 		'BROADWAY_MUSICIAN_POINTS');
insert or replace into Modifiers
	(ModifierId,						ModifierType,												SubjectRequirementSetId,	RunOnce,	Permanent)
values
	('BROADWAY_GRANTS_MUSICIAN',		'MODIFIER_SINGLE_CITY_GRANT_GREAT_PERSON_CLASS_IN_CITY',	null,						1,			1),
	('BROADWAY_REGIONAL_POP_CULTURE',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_POPULATION',	'HD_OBJECT_WITHIN_9_TILES',	0,			0);
	-- ('BROADWAY_MUSICIAN_POINTS',		'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',		null,						0,			0);
insert or replace into ModifierArguments
	(ModifierId,								Name,						Value)
values
	('BROADWAY_GRANTS_MUSICIAN',				'Amount',					1),
	('BROADWAY_GRANTS_MUSICIAN',				'GreatPersonClassType',		'GREAT_PERSON_CLASS_MUSICIAN'),
	('BROADWAY_REGIONAL_POP_CULTURE',			'YieldType',				'YIELD_CULTURE'),
	('BROADWAY_REGIONAL_POP_CULTURE',			'Amount',					1);
	-- ('BROADWAY_MUSICIAN_POINTS',				'GreatPersonClassType',		'GREAT_PERSON_CLASS_MUSICIAN'),
	-- ('BROADWAY_MUSICIAN_POINTS',				'Amount',					50);

-- Amundsen-Scott Research Station
update Buildings set PrereqCivic = 'CIVIC_COLD_WAR' where BuildingType = 'BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION';

-- University of Sankore
delete from BuildingModifiers where BuildingType = 'BUILDING_UNIVERSITY_SANKORE';
update Buildings set RegionalRange = 6 where BuildingType = 'BUILDING_UNIVERSITY_SANKORE';
insert or replace into BuildingModifiers
	(BuildingType,						 ModifierId)
values
	('BUILDING_UNIVERSITY_SANKORE',		'UNIVERSITY_SANKORE_CAMPUS_DESERTADJACENCY'),
	('BUILDING_UNIVERSITY_SANKORE',		'UNIVERSITY_SANKORE_CAMPUS_DESERTHILLADJACENCY'),
	('BUILDING_UNIVERSITY_SANKORE',		'UNIVERSITY_SANKORE_DESERT_SCIENCE');
insert or replace into Modifiers	
	(ModifierId,										ModifierType,									SubjectRequirementSetId)
values	
	('UNIVERSITY_SANKORE_CAMPUS_DESERTADJACENCY',		'MODIFIER_PLAYER_CITIES_TERRAIN_ADJACENCY',		null),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTHILLADJACENCY',	'MODIFIER_PLAYER_CITIES_TERRAIN_ADJACENCY',		null),
	('UNIVERSITY_SANKORE_DESERT_SCIENCE',				'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',	'PETRA_YIELD_MODIFIER_REQUIREMENTS');
insert or replace into ModifierArguments 
	(ModifierId,										Name,					Value) 
values
	('UNIVERSITY_SANKORE_CAMPUS_DESERTADJACENCY',		'DistrictType',			'DISTRICT_CAMPUS'),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTADJACENCY',		'TerrainType',			'TERRAIN_DESERT'),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTADJACENCY',		'YieldType'	,			'YIELD_SCIENCE'),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTADJACENCY',		'Amount',				1),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTADJACENCY',		'Description',			'LOC_DISTRICT_DESERT_SCIENCE'),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTHILLADJACENCY',	'DistrictType',			'DISTRICT_CAMPUS'),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTHILLADJACENCY',	'TerrainType',			'TERRAIN_DESERT_HILLS'),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTHILLADJACENCY',	'YieldType',			'YIELD_SCIENCE'),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTHILLADJACENCY',	'Amount',				1),
	('UNIVERSITY_SANKORE_CAMPUS_DESERTHILLADJACENCY',	'Description',			'LOC_DISTRICT_DESERT_HILLS_SCIENCE'),
	('UNIVERSITY_SANKORE_DESERT_SCIENCE',				'YieldType',			'YIELD_SCIENCE'),			
	('UNIVERSITY_SANKORE_DESERT_SCIENCE',				'Amount',				1);

-- Great Library
insert or replace into BuildingModifiers
	(BuildingType,						 ModifierId)
values
	('BUILDING_GREAT_LIBRARY',			'GREAT_LIBRARY_BOOST_ERUKA'),
	('BUILDING_GREAT_LIBRARY',			'HD_GREAT_LIBRARY_BOOST_ERUKA_RECORD');
insert or replace into Modifiers	
	(ModifierId,						ModifierType)
values	
	('GREAT_LIBRARY_BOOST_ERUKA',		'MODIFIER_PLAYER_ADJUST_TECHNOLOGY_BOOST'),
	('HD_GREAT_LIBRARY_BOOST_ERUKA_RECORD',		'MODIFIER_PLAYER_ADJUST_PROPERTY');
insert or replace into ModifierArguments
	(ModifierId,						Name,			Value)
values
	('GREAT_LIBRARY_BOOST_ERUKA',		'Amount',		3),
	('HD_GREAT_LIBRARY_BOOST_ERUKA_RECORD',		'Key',		'HD_Player_Extra_Tech_Boost'),
	('HD_GREAT_LIBRARY_BOOST_ERUKA_RECORD',		'Amount',		3);

-- Mahabodhi Temple
delete from BuildingModifiers where ModifierId = 'MAHABODHI_DIPLOVP';
insert or replace into Building_GreatWorks
	(BuildingType,								GreatWorkSlotType,			NumSlots)
values
	('BUILDING_MAHABODHI_TEMPLE',	'GREATWORKSLOT_RELIC',	2);

insert or replace into BuildingModifiers
	(BuildingType,						 			ModifierId)
values
	('BUILDING_MAHABODHI_TEMPLE',		'HD_MAHABODHI_TEMPLE_IGNORE_FOREST'),
	('BUILDING_MAHABODHI_TEMPLE',		'HD_MAHABODHI_TEMPLE_BUILDING_FAITH');
insert or replace into Modifiers
	(ModifierId,														ModifierType,																									SubjectRequirementSetId)
values	
	('HD_MAHABODHI_TEMPLE_IGNORE_FOREST',		'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',												NULL),
	('HD_MAHABODHI_TEMPLE_BUILDING_FAITH',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',			'HD_CITY_DISTRICT_HOLY_SITE_HAS_6_ADJACENCY_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,														Name,							Value) 
values
	('HD_MAHABODHI_TEMPLE_IGNORE_FOREST',		'AbilityType',		'ABILITY_HD_MAHABODHI_TEMPLE_IGNORE_FOREST'),
	('HD_MAHABODHI_TEMPLE_BUILDING_FAITH',	'DistrictType',		'DISTRICT_HOLY_SITE'),
	('HD_MAHABODHI_TEMPLE_BUILDING_FAITH',	'YieldType',			'YIELD_FAITH'),
	('HD_MAHABODHI_TEMPLE_BUILDING_FAITH',	'Amount',					100);

-- Hagia Sophia
insert or replace into BuildingModifiers
	(BuildingType,						 ModifierId)
values
	('BUILDING_HAGIA_SOPHIA',			'HAGIA_SOPHIA_CONVERT_FAITH');
insert or replace into Modifiers	
	(ModifierId,							ModifierType)
values	
	('HAGIA_SOPHIA_CONVERT_FAITH',			'MODIFIER_PLAYER_UNITS_ADJUST_INITIATION_YIELD_POPULATION');
insert or replace into ModifierArguments 
	(ModifierId,							Name,			Value) 
values
	('HAGIA_SOPHIA_CONVERT_FAITH',			'YieldType',	'YIELD_FAITH'),
	('HAGIA_SOPHIA_CONVERT_FAITH',			'Amount',		10);

-- Biosphère
update ModifierArguments set Value = 400	where ModifierId = 'BIOSPHERE_MODIFIED_FREE_POWER'		and Name = 'Amount';
update ModifierArguments set Value = 2 		where ModifierId = 'BIOSPHERE_ADJUST_APPEAL_RAINFOREST'	and Name = 'Amount';
update ModifierArguments set Value = 2		where ModifierId = 'BIOSPHERE_ADJUST_APPEAL_MARSH'		and Name = 'Amount';

-- Kotoku-in
insert or replace into Building_GreatWorks (BuildingType, GreatWorkSlotType, NumSlots) values
	('BUILDING_KOTOKU_IN',	'GREATWORKSLOT_RELIC',	2);

delete from BuildingModifiers where BuildingType = 'BUILDING_KOTOKU_IN';

insert or replace into BuildingModifiers (BuildingType, ModifierId) values
	('BUILDING_KOTOKU_IN', 'HD_KOTOKU_IN_GRANT_RELIC'),
	('BUILDING_KOTOKU_IN', 'HD_KOTOKU_IN_COASTAL_CITY_YIELD_MODIFIER'),
	('BUILDING_KOTOKU_IN', 'HD_KOTOKU_IN_COASTAL_CITY_AMENITY'),
	('BUILDING_KOTOKU_IN', 'HD_KOTOKU_IN_RELIGIOUS_TOURISM_ATTACH'),
	('BUILDING_KOTOKU_IN', 'HD_KOTOKU_IN_WONDER_TOURISM_ATTACH');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, RunOnce, Permanent) values
	('HD_KOTOKU_IN_GRANT_RELIC', 									'MODIFIER_PLAYER_GRANT_RELIC', 												null, 																												1, 1),
	('HD_KOTOKU_IN_COASTAL_CITY_YIELD_MODIFIER', 	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER', 	'PLOT_IS_COASTAL_LAND_REQUIREMENTS', 													0, 0),
	('HD_KOTOKU_IN_COASTAL_CITY_AMENITY', 				'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY', 				'PLOT_IS_COASTAL_LAND_REQUIREMENTS', 													0, 0),
	('HD_KOTOKU_IN_RELIGIOUS_TOURISM_ATTACH', 		'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 						'CITY_HAS_DISTRICT_HOLY_SITE_TIER_3_BUILDING_REQUIREMENTS', 	0, 0),
	('HD_KOTOKU_IN_WONDER_TOURISM_ATTACH', 				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 						'CITY_HAS_DISTRICT_HOLY_SITE_TIER_3_BUILDING_REQUIREMENTS', 	0, 0),
	('HD_KOTOKU_IN_RELIGIOUS_TOURISM_MODIFIER', 	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	 						'CITY_HAS_BUILDING_KOTOKU_IN_REQUIREMENTS', 									0, 0),
	('HD_KOTOKU_IN_WONDER_TOURISM_MODIFIER', 			'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	 						'CITY_HAS_BUILDING_KOTOKU_IN_REQUIREMENTS', 									0, 0);

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('HD_KOTOKU_IN_GRANT_RELIC', 									'Amount', 				1),
	('HD_KOTOKU_IN_COASTAL_CITY_YIELD_MODIFIER', 	'YieldType', 			'YIELD_CULTURE,YIELD_FAITH,YIELD_PRODUCTION'),
	('HD_KOTOKU_IN_COASTAL_CITY_YIELD_MODIFIER', 	'Amount', 				'5,5,5'),
	('HD_KOTOKU_IN_COASTAL_CITY_AMENITY', 				'Amount', 				2),
	('HD_KOTOKU_IN_RELIGIOUS_TOURISM_ATTACH', 		'ModifierId',			'HD_KOTOKU_IN_RELIGIOUS_TOURISM_MODIFIER'),
	('HD_KOTOKU_IN_WONDER_TOURISM_ATTACH', 				'ModifierId',			'HD_KOTOKU_IN_WONDER_TOURISM_MODIFIER'),
	('HD_KOTOKU_IN_RELIGIOUS_TOURISM_MODIFIER',		'Religious',			1),
	('HD_KOTOKU_IN_RELIGIOUS_TOURISM_MODIFIER',		'ScalingFactor',	150),
	('HD_KOTOKU_IN_WONDER_TOURISM_MODIFIER',			'BoostsWonders',	1),
	('HD_KOTOKU_IN_WONDER_TOURISM_MODIFIER',			'ScalingFactor',	150);

-- Hanging Gardens
update Buildings set Housing = 1, PrereqTech = 'TECH_CALENDAR_HD' where BuildingType = 'BUILDING_HANGING_GARDENS';
delete from BuildingModifiers where BuildingType = 'BUILDING_HANGING_GARDENS';
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('BUILDING_HANGING_GARDENS',	'HANGING_GARDEN_ADDFOOD');
insert or replace into Modifiers	
	(ModifierId,					ModifierType)
values
	('HANGING_GARDEN_ADDFOOD',		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER');
insert or replace into ModifierArguments 
	(ModifierId,					Name,			Value) 
values
	('HANGING_GARDEN_ADDFOOD',		'YieldType',	'YIELD_FOOD'),
	('HANGING_GARDEN_ADDFOOD',		'Amount',		10);

-- Cristo Redentor
insert or replace into BuildingModifiers
	(BuildingType,	 				ModifierId)
values
	('BUILDING_CRISTO_REDENTOR',	'ORACLE_PATRONAGE_FAITH_DISCOUNT');

-- 巨像
update Buildings set MustBeAdjacentLand = 0 where BuildingType = 'BUILDING_COLOSSUS';

insert or replace into BuildingModifiers
	(BuildingType, 						ModifierId)
values
	('BUILDING_COLOSSUS',			'COLOSSUS_TRADE_ROUTE_FISHINGBOAT_GOLD_ATTACH');

insert or replace into Modifiers
	(ModifierId, 																			ModifierType,																												SubjectRequirementSetId)
values
	('COLOSSUS_TRADE_ROUTE_FISHINGBOAT_GOLD_ATTACH',	'MODIFIER_PLAYER_IMPROVEMENTS_ATTACH_MODIFIER',											'HD_COLOSSUS_REQUIREMENTS'),
	('COLOSSUS_TRADE_ROUTE_FISHINGBOAT_GOLD',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	null);

insert or replace into ModifierArguments 
	(ModifierId,								Name,			Value) 
values
	('COLOSSUS_TRADE_ROUTE_FISHINGBOAT_GOLD_ATTACH', 	'ModifierId',	'COLOSSUS_TRADE_ROUTE_FISHINGBOAT_GOLD'),
	('COLOSSUS_TRADE_ROUTE_FISHINGBOAT_GOLD', 				'YieldType',	'YIELD_GOLD'),
	('COLOSSUS_TRADE_ROUTE_FISHINGBOAT_GOLD',					'Amount',			2);

-- 马丘比丘
update Buildings set PrereqTech = 'TECH_ARCH_HD', PrereqCivic = null where BuildingType = 'BUILDING_MACHU_PICCHU';
delete from Building_YieldChanges where BuildingType = 'BUILDING_MACHU_PICCHU' and YieldType = 'YIELD_GOLD';
insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
values
	('BUILDING_MACHU_PICCHU',	'MACHU_PICCHU_DISTRICT_FOOD');
insert or replace into Modifiers
	(ModifierId, 					ModifierType, 										SubjectRequirementSetId)
values
	('MACHU_PICCHU_DISTRICT_FOOD',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',	'PLOT_ADJACENT_TO_MOUNTAIN_IS_NOT_WONDER_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,					Name,			Value)
values
	('MACHU_PICCHU_DISTRICT_FOOD',	'YieldType',	'YIELD_FOOD'),
	('MACHU_PICCHU_DISTRICT_FOOD',	'Amount', 		2);

-- 自由女神像
insert or replace into BuildingPrereqs
	(Building,									PrereqBuilding)
values 
	('BUILDING_STATUE_LIBERTY',	'BUILDING_SEAPORT');
update Buildings set PrereqCivic = 'CIVIC_COLONIALISM', MustBeAdjacentLand = 0 where BuildingType = 'BUILDING_STATUE_LIBERTY';
delete from BuildingModifiers where BuildingType = 'BUILDING_STATUE_LIBERTY' and ModifierId = 'STATUELIBERTY_CITIES_ALWAYS_LOYAL';

insert or replace into BuildingModifiers (BuildingType, ModifierId) values
	('BUILDING_STATUE_LIBERTY', 'HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_COAST_ORIGIN'),
	('BUILDING_STATUE_LIBERTY', 'HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_OCEAN_ORIGIN'),
	('BUILDING_STATUE_LIBERTY', 'GUNBOATDIPLOMACY_OPENBORDERS');

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) values
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_COAST_ORIGIN',	'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_PER_TERRAIN_INTERNATIONAL',	NULL),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_OCEAN_ORIGIN',	'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_PER_TERRAIN_INTERNATIONAL',	NULL),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_CAPACITY',					'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',												'PLAYER_HAS_BUILDING_STATUE_LIBERTY_REQUIREMENTS');

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_COAST_ORIGIN',	'Origin',				1),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_COAST_ORIGIN',	'Amount',				1),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_COAST_ORIGIN',	'TerrainType',	'TERRAIN_COAST'),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_COAST_ORIGIN',	'YieldType',		'YIELD_GOLD'),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_OCEAN_ORIGIN',	'Origin',				1),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_OCEAN_ORIGIN',	'Amount',				1),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_OCEAN_ORIGIN',	'TerrainType',	'TERRAIN_OCEAN'),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_GOLD_OCEAN_ORIGIN',	'YieldType',		'YIELD_GOLD'),
	('HD_STATUE_LIBERTY_TRADE_ROUTE_CAPACITY',					'Amount',				1);

insert or replace into GlobalParameters (Name, Value) values
	('HD_STATUE_LIBERTY_NAVAL_HEAL',									1),
	('HD_STATUE_LIBERTY_NAVAL_FLEET',									1),
	('HD_STATUE_LIBERTY_INFLUENCE_POINT_PERCENTAGE',	5);

insert or replace into HD_Binary_Compress_Keys (Key) values
	('HD_PLOT_BINARY_COMPRESS_STATUE_LIBERTY');

	-- 影响力 二进制压缩
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_STATUE_LIBERTY', 'HD_STATUE_LIBERTY_INFLUENCE_POINT_' || Exp
	from HD_Binary_Compress where Exp < 10;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
	select 'HD_STATUE_LIBERTY_INFLUENCE_POINT_' || Exp, 'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN', 'HD_PLOT_BINARY_COMPRESS_STATUE_LIBERTY_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_STATUE_LIBERTY_INFLUENCE_POINT_' || Exp, 'Amount',	Amount
	from HD_Binary_Compress where Exp < 10;

-- Hagia Sophia
update Modifiers set SubjectRequirementSetId = 'UNIT_IS_MISSIONARY_OR_APOSTLE' where ModifierId = 'HAGIA_SOPHIA_ADJUST_RELIGIOUS_CHARGES';

-- Hermitage
insert or replace into GlobalParameters
	(Name,											Value)
values
	('HD_HERMITAGE_POINT_PERCENTAGE',				15);

update Buildings set RegionalRange = 9, Entertainment = 1, QuoteAudio = 'PLAY_HD_NEW_HERMITAGE_QUOTE' where BuildingType = 'BUILDING_HERMITAGE';
insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
values
	('BUILDING_HERMITAGE',		'HERMITAGE_CITY_SCULPTURE_TOURISM'),
	('BUILDING_HERMITAGE',		'HERMITAGE_CITY_PORTRAIT_TOURISM'),
	('BUILDING_HERMITAGE',		'HERMITAGE_CITY_RELIGIOUS_TOURISM'),
	('BUILDING_HERMITAGE',		'HERMITAGE_CITY_LANDSCAPE_TOURISM');
insert or replace into Modifiers
	(ModifierId,								ModifierType,											SubjectRequirementSetId)
values
	('HERMITAGE_CITY_SCULPTURE_TOURISM',		'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',					null),
	('HERMITAGE_CITY_PORTRAIT_TOURISM',			'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',					null),
	('HERMITAGE_CITY_RELIGIOUS_TOURISM',		'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',					null),
	('HERMITAGE_CITY_LANDSCAPE_TOURISM',		'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',					null);

insert or replace into ModifierArguments
	(ModifierId,								Name, 						Value)
values
	('HERMITAGE_CITY_SCULPTURE_TOURISM',		'GreatWorkObjectType',		'GREATWORKOBJECT_SCULPTURE'),
	('HERMITAGE_CITY_SCULPTURE_TOURISM',		'ScalingFactor',			300),
	('HERMITAGE_CITY_PORTRAIT_TOURISM',			'GreatWorkObjectType',		'GREATWORKOBJECT_PORTRAIT'),
	('HERMITAGE_CITY_PORTRAIT_TOURISM',			'ScalingFactor',			300),
	('HERMITAGE_CITY_RELIGIOUS_TOURISM',		'GreatWorkObjectType',		'GREATWORKOBJECT_RELIGIOUS'),
	('HERMITAGE_CITY_RELIGIOUS_TOURISM',		'ScalingFactor',			300),
	('HERMITAGE_CITY_LANDSCAPE_TOURISM',		'GreatWorkObjectType',		'GREATWORKOBJECT_LANDSCAPE'),
	('HERMITAGE_CITY_LANDSCAPE_TOURISM',		'ScalingFactor',			300);

-- Sydney Opera House
insert or replace into BuildingModifiers
	(BuildingType, 						ModifierId)
values
	('BUILDING_SYDNEY_OPERA_HOUSE', 	'OPERAHOUSE_GRANT_MUSICIAN'),
	('BUILDING_SYDNEY_OPERA_HOUSE', 	'OPERAHOUSE_ADD_WONDER_TOURISM'),
	('BUILDING_SYDNEY_OPERA_HOUSE',		'OPERAHOUSE_ADD_MUSIC_TOURISM'),
	('BUILDING_SYDNEY_OPERA_HOUSE', 	'OPERAHOUSE_ADD_WRITING_TOURISM'),
	('BUILDING_SYDNEY_OPERA_HOUSE', 	'OPERAHOUSE_ADD_ARTIFACTS_TOURISM'),
	('BUILDING_SYDNEY_OPERA_HOUSE', 	'OPERAHOUSE_ADD_RELIC_TOURISM'),
	('BUILDING_SYDNEY_OPERA_HOUSE', 	'OPERAHOUSE_ADD_LANDSCAPE_TOURISM'),
	('BUILDING_SYDNEY_OPERA_HOUSE', 	'OPERAHOUSE_ADD_RELIGIOUS_TOURISM'),
	('BUILDING_SYDNEY_OPERA_HOUSE', 	'OPERAHOUSE_ADD_PORTRAIT_TOURISM'),
	('BUILDING_SYDNEY_OPERA_HOUSE', 	'OPERAHOUSE_ADD_SCULPTURE_TOURISM');
	
insert or replace into Modifiers
	(ModifierId,							ModifierType,								SubjectRequirementSetId)
values
	('OPERAHOUSE_ADD_WONDER_TOURISM',  		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'CITY_HAS_GOVERNOR_FOUNDED'),
	('OPERAHOUSE_ADD_MUSIC_TOURISM',		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'CITY_HAS_GOVERNOR_FOUNDED'),
	('OPERAHOUSE_ADD_WRITING_TOURISM',		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'CITY_HAS_GOVERNOR_FOUNDED'),
	('OPERAHOUSE_ADD_ARTIFACTS_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'CITY_HAS_GOVERNOR_FOUNDED'),
	('OPERAHOUSE_ADD_RELIC_TOURISM',		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'CITY_HAS_GOVERNOR_FOUNDED'),
	('OPERAHOUSE_ADD_LANDSCAPE_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'CITY_HAS_GOVERNOR_FOUNDED'),
	('OPERAHOUSE_ADD_RELIGIOUS_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'CITY_HAS_GOVERNOR_FOUNDED'),
	('OPERAHOUSE_ADD_PORTRAIT_TOURISM',		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'CITY_HAS_GOVERNOR_FOUNDED'),
	('OPERAHOUSE_ADD_SCULPTURE_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'CITY_HAS_GOVERNOR_FOUNDED');

insert or replace into Modifiers
	(ModifierId,							ModifierType,												SubjectRequirementSetId,			RunOnce,	Permanent)
values
	('OPERAHOUSE_GRANT_MUSICIAN',  			'MODIFIER_SINGLE_CITY_GRANT_GREAT_PERSON_CLASS_IN_CITY',	null,	1,			1);

insert or replace into ModifierArguments 
	(ModifierId,							Name,					Value) 
values 
	('OPERAHOUSE_GRANT_MUSICIAN',			'GreatPersonClassType',	'GREAT_PERSON_CLASS_MUSICIAN'),
	('OPERAHOUSE_GRANT_MUSICIAN',			'Amount',				1),
	('OPERAHOUSE_ADD_WONDER_TOURISM',		'BoostsWonders',		1),
	('OPERAHOUSE_ADD_WONDER_TOURISM',		'ScalingFactor',		200),
	('OPERAHOUSE_ADD_RELIC_TOURISM',		'GreatWorkObjectType',	'GREATWORKOBJECT_RELIC'),
	('OPERAHOUSE_ADD_RELIC_TOURISM',		'ScalingFactor',		200),
	('OPERAHOUSE_ADD_WRITING_TOURISM',		'GreatWorkObjectType',	'GREATWORKOBJECT_WRITING'),	
	('OPERAHOUSE_ADD_WRITING_TOURISM',		'ScalingFactor',		200),
	('OPERAHOUSE_ADD_SCULPTURE_TOURISM',	'GreatWorkObjectType',	'GREATWORKOBJECT_SCULPTURE'),
	('OPERAHOUSE_ADD_SCULPTURE_TOURISM',	'ScalingFactor',		200),
	('OPERAHOUSE_ADD_PORTRAIT_TOURISM',		'GreatWorkObjectType',	'GREATWORKOBJECT_PORTRAIT'),
	('OPERAHOUSE_ADD_PORTRAIT_TOURISM',		'ScalingFactor',		200),
	('OPERAHOUSE_ADD_ARTIFACTS_TOURISM',	'GreatWorkObjectType',	'GREATWORKOBJECT_ARTIFACT'),
	('OPERAHOUSE_ADD_ARTIFACTS_TOURISM',	'ScalingFactor',		200),
	('OPERAHOUSE_ADD_RELIGIOUS_TOURISM',	'GreatWorkObjectType',	'GREATWORKOBJECT_RELIGIOUS'),
	('OPERAHOUSE_ADD_RELIGIOUS_TOURISM',	'ScalingFactor',		200),	
	('OPERAHOUSE_ADD_LANDSCAPE_TOURISM',	'GreatWorkObjectType',	'GREATWORKOBJECT_LANDSCAPE'),
	('OPERAHOUSE_ADD_LANDSCAPE_TOURISM',	'ScalingFactor',		200),
	('OPERAHOUSE_ADD_MUSIC_TOURISM',		'GreatWorkObjectType',	'GREATWORKOBJECT_MUSIC'),
	('OPERAHOUSE_ADD_MUSIC_TOURISM',		'ScalingFactor',		300);

-- Ruhr Valley
insert or replace into Building_GreatPersonPoints
	(BuildingType,			GreatPersonClassType,			PointsPerTurn)
values
	('BUILDING_RUHR_VALLEY',	'GREAT_PERSON_CLASS_ENGINEER',	6);
delete from BuildingModifiers where BuildingType = 'BUILDING_RUHR_VALLEY' and ModifierId = 'RUHR_VALLEY_PRODUCTION_MODIFIER';
-- update ModifierArguments set Value = 2 where ModifierId = 'RUHR_VALLEY_PRODUCTION_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 15 where ModifierId = 'RUHRVALLEY_ADDPRODUCTIONYIELD' and Name = 'Amount';

insert or replace into BuildingModifiers
	(BuildingType, 					ModifierId)
values
	('BUILDING_RUHR_VALLEY',		'RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_FROM_OTHERS'),
	('BUILDING_RUHR_VALLEY',		'RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_DOM_OTHERS'),
	('BUILDING_RUHR_VALLEY',		'RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_TO_OTHERS'),
	('BUILDING_RUHR_VALLEY',		'RUHR_VALLEY_COAL'),
	('BUILDING_RUHR_VALLEY',		'RUHR_VALLEY_CITIES_PRODUCTION_MODIFIER'),
	('BUILDING_RUHR_VALLEY',		'RUHR_VALLEY_CITIES_EXTRA_GREAT_ENGINEER_POINTS');

insert or replace into Modifiers
	(ModifierId,																				ModifierType)
values
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_FROM_OTHERS',	'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FROM_OTHERS'),
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_DOM_OTHERS',		'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS'),
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_TO_OTHERS',  	'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS'),
	('RUHR_VALLEY_COAL',  															'MODIFIER_SINGLE_CITY_ADJUST_FREE_RESOURCE_EXTRACTION');

insert or replace into Modifiers
	(ModifierId,																								ModifierType,																									SubjectRequirementSetId)
values
	('RUHR_VALLEY_CITIES_PRODUCTION_MODIFIER',									'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',					'CITY_HAS_DISTRICT_INDUSTRIAL_ZONE_TIER_2_BUILDING_REQUIREMENTS'),
	('RUHR_VALLEY_CITIES_EXTRA_GREAT_ENGINEER_POINTS',					'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',											'CITY_HAS_DISTRICT_INDUSTRIAL_ZONE_TIER_2_BUILDING_REQUIREMENTS'),
	('RUHR_VALLEY_CITIES_EXTRA_GREAT_ENGINEER_POINTS_MODIFIER',	'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',					null);

insert or replace into ModifierArguments 
	(ModifierId,										Name,			Value) 
values 
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_FROM_OTHERS',	'YieldType',	'YIELD_PRODUCTION'),
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_FROM_OTHERS',	'Amount',		3),
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_DOM_OTHERS',	'YieldType',	'YIELD_PRODUCTION'),
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_DOM_OTHERS',	'Amount',		6),
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_DOM_OTHERS',	'Domestic',		1),
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_TO_OTHERS',	'YieldType',	'YIELD_PRODUCTION'),
	('RUHR_VALLEY_TRADE_ROUTE_PRODUCTION_TO_OTHERS',	'Amount',		3),
	('RUHR_VALLEY_COAL',															'ResourceType',	'RESOURCE_COAL'),
	('RUHR_VALLEY_COAL',															'Amount',		6),
	('RUHR_VALLEY_CITIES_PRODUCTION_MODIFIER',				'YieldType',	'YIELD_PRODUCTION'),
	('RUHR_VALLEY_CITIES_PRODUCTION_MODIFIER',				'Amount',		5),
	('RUHR_VALLEY_CITIES_EXTRA_GREAT_ENGINEER_POINTS','ModifierId',	'RUHR_VALLEY_CITIES_EXTRA_GREAT_ENGINEER_POINTS_MODIFIER'),
	('RUHR_VALLEY_CITIES_EXTRA_GREAT_ENGINEER_POINTS_MODIFIER',				'GreatPersonClassType',		'GREAT_PERSON_CLASS_ENGINEER'),
	('RUHR_VALLEY_CITIES_EXTRA_GREAT_ENGINEER_POINTS_MODIFIER',				'Amount',		10);

-- Venetian Arsenal 
insert or replace into BuildingModifiers
	(BuildingType, 									ModifierId)
values
	('BUILDING_VENETIAN_ARSENAL',		'VENETIAN_ARSENAL_GRANT_SIX_NITER_PER_TURN'),
	('BUILDING_VENETIAN_ARSENAL', 	'HD_VENETIAN_ARSENAL_INDUSTRIAL_ADJACENCY'),
	('BUILDING_VENETIAN_ARSENAL', 	'HD_VENETIAN_ARSENAL_ENCAMPMENT_ADJACENCY');
	
insert or replace into Modifiers
	(ModifierId,																	ModifierType,																							SubjectRequirementSetId)
values
	('VENETIAN_ARSENAL_GRANT_SIX_NITER_PER_TURN',	'MODIFIER_SINGLE_CITY_ADJUST_FREE_RESOURCE_EXTRACTION',		null),
	('HD_VENETIAN_ARSENAL_INDUSTRIAL_ADJACENCY',	'MODIFIER_PLAYER_CITIES_TERRAIN_ADJACENCY',								null),
	('HD_VENETIAN_ARSENAL_ENCAMPMENT_ADJACENCY',	'MODIFIER_PLAYER_CITIES_TERRAIN_ADJACENCY',								null);

insert or replace into ModifierArguments 
	(ModifierId,																	Name,							Value) 
values 
	('VENETIAN_ARSENAL_GRANT_SIX_NITER_PER_TURN',	'ResourceType',		'RESOURCE_NITER'),
	('VENETIAN_ARSENAL_GRANT_SIX_NITER_PER_TURN',	'Amount',					6),
	('HD_VENETIAN_ARSENAL_INDUSTRIAL_ADJACENCY',	'DistrictType',		'DISTRICT_INDUSTRIAL_ZONE'),
	('HD_VENETIAN_ARSENAL_INDUSTRIAL_ADJACENCY',	'TerrainType',		'TERRAIN_COAST'),
	('HD_VENETIAN_ARSENAL_INDUSTRIAL_ADJACENCY',	'YieldType',			'YIELD_PRODUCTION'),
	('HD_VENETIAN_ARSENAL_INDUSTRIAL_ADJACENCY',	'Amount',					1),
	('HD_VENETIAN_ARSENAL_INDUSTRIAL_ADJACENCY',	'TilesRequired',	1),
	('HD_VENETIAN_ARSENAL_INDUSTRIAL_ADJACENCY',	'Description',		'LOC_DISTRICT_COAST_PRODUCTION_HD'),
	('HD_VENETIAN_ARSENAL_ENCAMPMENT_ADJACENCY',	'DistrictType',		'DISTRICT_ENCAMPMENT'),
	('HD_VENETIAN_ARSENAL_ENCAMPMENT_ADJACENCY',	'TerrainType',		'TERRAIN_COAST'),
	('HD_VENETIAN_ARSENAL_ENCAMPMENT_ADJACENCY',	'YieldType',			'YIELD_PRODUCTION'),
	('HD_VENETIAN_ARSENAL_ENCAMPMENT_ADJACENCY',	'Amount',					1),
	('HD_VENETIAN_ARSENAL_ENCAMPMENT_ADJACENCY',	'TilesRequired',	1),
	('HD_VENETIAN_ARSENAL_ENCAMPMENT_ADJACENCY',	'Description',		'LOC_DISTRICT_COAST_PRODUCTION_HD');

-- Terracotta Army
update Buildings set PrereqCivic = 'CIVIC_DEFENSIVE_TACTICS', PrereqTech = NULL where BuildingType = 'BUILDING_TERRACOTTA_ARMY';
delete from BuildingModifiers where BuildingType = 'BUILDING_TERRACOTTA_ARMY' and ModifierId = 'TERRACOTTA_ARMY_ARCHAEOLOGIST_OPEN_BORDERS';
insert or replace into BuildingModifiers
	(BuildingType, 					ModifierId)
values
	-- ('BUILDING_TERRACOTTA_ARMY',	'TERRACOTTA_ARMY_ARCHAEOLOGIST_IGNORE_HILLS'),
	-- ('BUILDING_TERRACOTTA_ARMY',	'TERRACOTTA_ARMY_ARCHAEOLOGIST_IGNORE_FOREST'),
	('BUILDING_TERRACOTTA_ARMY',	'ALHAMBRA_MILITARY_GOVERNMENT_SLOT');
-- insert or replace into Modifiers
-- 	(ModifierId,										ModifierType)
-- values
-- 	('TERRACOTTA_ARMY_ARCHAEOLOGIST_IGNORE_HILLS',		'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
-- 	('TERRACOTTA_ARMY_ARCHAEOLOGIST_IGNORE_FOREST',		'MODIFIER_PLAYER_UNITS_GRANT_ABILITY');
-- insert or replace into ModifierArguments 
-- 	(ModifierId,										Name,				Value) 
-- values 
-- 	('TERRACOTTA_ARMY_ARCHAEOLOGIST_IGNORE_HILLS',		'AbilityType',		'ABILITY_ARCHAEOLOGIST_IGNORE_HILLS'),
-- 	('TERRACOTTA_ARMY_ARCHAEOLOGIST_IGNORE_FOREST',		'AbilityType',		'ABILITY_ARCHAEOLOGIST_IGNORE_FOREST');

-- 米纳克希神庙
update Buildings set PrereqCivic = 'CIVIC_DIVINE_RIGHT' where BuildingType = 'BUILDING_MEENAKSHI_TEMPLE';
delete from BuildingModifiers where BuildingType = 'BUILDING_MEENAKSHI_TEMPLE' and ModifierId != 'MEENAKSHITEMPLE_FREE_GURU';
update UnitAbilities set Inactive = 0 where UnitAbilityType = 'ABILITY_SAGE_COMBAT_AOE_RELIGIOUS' or UnitAbilityType = 'ABILITY_GUIDE_MOVEMENT_AOE_RELIGIOUS';
insert or replace into Building_GreatWorks
	(BuildingType,					GreatWorkSlotType,			NumSlots)
values 
	('BUILDING_MEENAKSHI_TEMPLE',	'GREATWORKSLOT_ART',		3);

create temporary table HD_Meenakshi_DistrictBonus (
	DistrictType text not null primary key
);
insert or replace into HD_Meenakshi_DistrictBonus (DistrictType)
select DistrictType from Districts where CitizenSlots is not NULL and CitizenSlots > 0 and TraitType is null;
insert or replace into Types
	(Type,											Kind)
select
	'BUILDING_MEENAKSHI_DUMMY_' || DistrictType,	'KIND_BUILDING'
from HD_Meenakshi_DistrictBonus;
-- 记录虚拟建筑
insert or replace into HD_DUMMY_BUILDINGS (BuildingType)
	select 'BUILDING_MEENAKSHI_DUMMY_' || DistrictType from HD_Meenakshi_DistrictBonus;
insert or replace into Buildings
	(BuildingType, Name, Description, PrereqDistrict, Cost, MustPurchase, CitizenSlots)
select
	'BUILDING_MEENAKSHI_DUMMY_' || DistrictType,
	'LOC_BUILDING_MEENAKSHI_DUMMY_' || DistrictType || '_NAME',
	'LOC_BUILDING_MEENAKSHI_DUMMY_' || DistrictType || '_DESCRIPTION',
	DistrictType,
	0, 1, 1
from HD_Meenakshi_DistrictBonus;
insert or replace into Buildings_XP2
	(BuildingType,									Pillage)
select
	'BUILDING_MEENAKSHI_DUMMY_' || DistrictType,	0
from HD_Meenakshi_DistrictBonus;
insert or ignore into Types
	(Type,										Kind)
values
	('BUILDING_MEENAKSHI_DUMMY_INTERNAL_ONLY',	'KIND_BUILDING');
insert or replace into HD_DUMMY_BUILDINGS (BuildingType)
	values ('BUILDING_MEENAKSHI_DUMMY_INTERNAL_ONLY');
insert or ignore into Buildings
	(BuildingType,								Cost,	Name,												InternalOnly)
values
	('BUILDING_MEENAKSHI_DUMMY_INTERNAL_ONLY',	0,		'LOC_BUILDING_MEENAKSHI_DUMMY_INTERNAL_ONLY_NAME',	1);
insert or replace into BuildingPrereqs
	(Building,										PrereqBuilding)
select
	'BUILDING_MEENAKSHI_DUMMY_' || DistrictType,	'BUILDING_MEENAKSHI_DUMMY_INTERNAL_ONLY'
from HD_Meenakshi_DistrictBonus;
insert or replace into Building_CitizenYieldChanges
	(BuildingType,									YieldType,		YieldChange)
select
	'BUILDING_MEENAKSHI_DUMMY_' || DistrictType,	'YIELD_FAITH',	1
from HD_Meenakshi_DistrictBonus;
insert or replace into Building_CitizenYieldChanges
	(BuildingType,									YieldType,			YieldChange)
select
	'BUILDING_MEENAKSHI_DUMMY_' || DistrictType,	'YIELD_CULTURE',	1
from HD_Meenakshi_DistrictBonus;
insert or replace into Building_CitizenYieldChanges
	(BuildingType,									YieldType,			YieldChange)
select
	'BUILDING_MEENAKSHI_DUMMY_' || DistrictType,	'YIELD_FOOD',	1
from HD_Meenakshi_DistrictBonus;
insert or replace into Building_CitizenYieldChanges
	(BuildingType,									YieldType,			YieldChange)
select
	'BUILDING_MEENAKSHI_DUMMY_' || DistrictType,	'YIELD_GOLD',	-2
from HD_Meenakshi_DistrictBonus;
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'BUILDING_MEENAKSHI_TEMPLE',	'MEENAKSHI_' || DistrictType || '_EXPERT_ATTACH'
from HD_Meenakshi_DistrictBonus;
insert or replace into Modifiers
	(ModifierId,										ModifierType,									SubjectRequirementSetId)
select
	'MEENAKSHI_' || DistrictType || '_EXPERT_ATTACH',	'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',		'CITY_HAS_DISTRICT_HOLY_SITE_REQUIREMENTS'
from HD_Meenakshi_DistrictBonus;
insert or replace into ModifierArguments
	(ModifierId,										Name,			Value)
select
	'MEENAKSHI_' || DistrictType || '_EXPERT_ATTACH',	'ModifierId',	'MEENAKSHI_' || DistrictType || '_EXPERT'
from HD_Meenakshi_DistrictBonus;
insert or replace into Modifiers
	(ModifierId,										ModifierType,									SubjectRequirementSetId)
select
	'MEENAKSHI_' || DistrictType || '_EXPERT',			'MODIFIER_CITY_DISTRICTS_ATTACH_MODIFIER',		NULL
from HD_Meenakshi_DistrictBonus;
insert or replace into ModifierArguments
	(ModifierId,										Name,			Value)
select
	'MEENAKSHI_' || DistrictType || '_EXPERT',			'ModifierId',	'MEENAKSHI_' || DistrictType || '_EXPERT_YIELD'
from HD_Meenakshi_DistrictBonus;
insert or replace into Modifiers
	(ModifierId,										ModifierType,											OwnerRequirementSetId)
select
	'MEENAKSHI_' || DistrictType || '_EXPERT_YIELD',	'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',	'DISTRICT_IS_' || DistrictType || '_REQUIREMENTS'
from HD_Meenakshi_DistrictBonus;
insert or replace into ModifierArguments
	(ModifierId,										Name,			Value)
select
	'MEENAKSHI_' || DistrictType || '_EXPERT_YIELD',	'BuildingType',	'BUILDING_MEENAKSHI_DUMMY_' || DistrictType
from HD_Meenakshi_DistrictBonus;
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('BUILDING_MEENAKSHI_TEMPLE',	'MEENAKSHI_HOUSING'),
	('BUILDING_MEENAKSHI_TEMPLE',	'MEENAKSHI_SCULPTURE_TOURISM'),
	('BUILDING_MEENAKSHI_TEMPLE',	'MEENAKSHI_PORTRAIT_TOURISM'),
	('BUILDING_MEENAKSHI_TEMPLE',	'MEENAKSHI_ART_TOURISM'),
	('BUILDING_MEENAKSHI_TEMPLE',	'MEENAKSHI_RELIGIOUS_TOURISM'),
	('BUILDING_MEENAKSHI_TEMPLE',	'MEENAKSHI_LANDSCAPE_TOURISM');
insert or replace into Modifiers
	(ModifierId,					ModifierType,									OwnerRequirementSetId,				SubjectRequirementSetId, 						OwnerStackLimit)
values
	('MEENAKSHI_HOUSING',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_HOUSING',		null,								'DISTRICT_IS_DISTRICT_HOLY_SITE_REQUIREMENTS',	null),
	('MEENAKSHI_SCULPTURE_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',		null,								'CITY_HAS_DISTRICT_HOLY_SITE_REQUIREMENTS',	null),
	('MEENAKSHI_PORTRAIT_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',		null,								'CITY_HAS_DISTRICT_HOLY_SITE_REQUIREMENTS',	null),
	-- ('MEENAKSHI_ART_TOURISM',		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',		null,								'CITY_HAS_DISTRICT_HOLY_SITE_REQUIREMENTS',	null),
	('MEENAKSHI_RELIGIOUS_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',		null,								'CITY_HAS_DISTRICT_HOLY_SITE_REQUIREMENTS',	null),
	('MEENAKSHI_LANDSCAPE_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',		null,								'CITY_HAS_DISTRICT_HOLY_SITE_REQUIREMENTS',	null);
	-- ('MEENAKSHI_HOUSING',			'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	null,								'REQUIRE_PLOT_ADJACENT_TO_OWNER',				null),
	-- ('MEENAKSHI_HOUSING_MODIFIER',	'MODIFIER_ADJUST_HOUSING_IN_DISTRICT',			'DISTRICT_HAS_NO_CITIZEN_SLOT',		null,											1);
insert or replace into ModifierArguments
	(ModifierId,									Name,					Value)
values
	-- ('MEENAKSHI_HOUSING_ATTACH',	'ModifierId',	'MEENAKSHI_HOUSING'),
	-- ('MEENAKSHI_HOUSING',			'ModifierId',	'MEENAKSHI_HOUSING_MODIFIER'),
	('MEENAKSHI_HOUSING',							'Amount',				2),
	('MEENAKSHI_SCULPTURE_TOURISM',					'GreatWorkObjectType',	'GREATWORKOBJECT_SCULPTURE'),
	('MEENAKSHI_SCULPTURE_TOURISM',					'ScalingFactor',		150),
	('MEENAKSHI_PORTRAIT_TOURISM',					'GreatWorkObjectType',	'GREATWORKOBJECT_PORTRAIT'),
	('MEENAKSHI_PORTRAIT_TOURISM',					'ScalingFactor',		150),
	-- ('MEENAKSHI_ART_TOURISM',						'GreatWorkObjectType',	'GREATWORKOBJECT_ARTIFACT'),
	-- ('MEENAKSHI_ART_TOURISM',						'ScalingFactor',		150),
	('MEENAKSHI_RELIGIOUS_TOURISM',					'GreatWorkObjectType',	'GREATWORKOBJECT_RELIGIOUS'),
	('MEENAKSHI_RELIGIOUS_TOURISM',					'ScalingFactor',		150),	
	('MEENAKSHI_LANDSCAPE_TOURISM',					'GreatWorkObjectType',	'GREATWORKOBJECT_LANDSCAPE'),
	('MEENAKSHI_LANDSCAPE_TOURISM',					'ScalingFactor',		150);
-- insert or replace into RequirementSets
-- 	(RequirementSetId,					RequirementSetType)
-- values
-- 	('DISTRICT_HAS_NO_CITIZEN_SLOT',	'REQUIREMENTSET_TEST_ANY');
-- insert or replace into RequirementSetRequirements
-- 	(RequirementSetId,					RequirementId)
-- select
-- 	'DISTRICT_HAS_NO_CITIZEN_SLOT',		'REQUIRES_DISTRICT_IS_' || DistrictType
-- from Districts where (CitizenSlots is null or CitizenSlots = 0) and TraitType is null and DistrictType != 'DISTRICT_CITY_CENTER' and DistrictType != 'DISTRICT_WONDER';

-- Taj Mahal
update Buildings set PrereqCivic = null, PrereqTech = 'TECH_PHYSICS_HD' where BuildingType = 'BUILDING_TAJ_MAHAL';
insert or replace into Building_GreatPersonPoints
	(BuildingType,			GreatPersonClassType,			PointsPerTurn)
values
	('BUILDING_TAJ_MAHAL',	'GREAT_PERSON_CLASS_ENGINEER',	4);
insert or replace into BuildingModifiers
	(BuildingType,          	ModifierId)
values
	('BUILDING_TAJ_MAHAL',  	'TAJ_MAHAL_WONDER_CULTURE'),
	('BUILDING_TAJ_MAHAL',  	'TAJ_MAHAL_WONDER_FAITH'),
	('BUILDING_TAJ_MAHAL',  	'TAJ_MAHAL_WONDER_GREAT_ENGINEER_POINT'),
	('BUILDING_TAJ_MAHAL',  	'TAJ_MAHAL_WONDER_TOURISM');
insert or replace into Modifiers
    (ModifierId,                						ModifierType,											SubjectRequirementSetId)
values
	('TAJ_MAHAL_WONDER_CULTURE',   						'MODIFIER_SINGLE_CITY_ADJUST_WONDER_YIELD_CHANGE',		null),
	('TAJ_MAHAL_WONDER_FAITH',   						'MODIFIER_SINGLE_CITY_ADJUST_WONDER_YIELD_CHANGE',		null),
	('TAJ_MAHAL_WONDER_GREAT_ENGINEER_POINT',			'MODIFIER_CITY_DISTRICTS_ATTACH_MODIFIER',				'PLOT_HAS_COMPLETE_WONDER'),
	('TAJ_MAHAL_WONDER_TOURISM',   						'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',				null),
	('TAJ_MAHAL_WONDER_GREAT_ENGINEER_POINT_MODIFIER',	'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',	null);
insert or replace into ModifierArguments
    (ModifierId,                						Name,          			Value)
values
	('TAJ_MAHAL_WONDER_CULTURE',   						'YieldType',			'YIELD_CULTURE'),
	('TAJ_MAHAL_WONDER_CULTURE',   						'Amount',				3),
	('TAJ_MAHAL_WONDER_FAITH',   						'YieldType',			'YIELD_FAITH'),
	('TAJ_MAHAL_WONDER_FAITH',   						'Amount',				3),
	('TAJ_MAHAL_WONDER_GREAT_ENGINEER_POINT',			'ModifierId',			'TAJ_MAHAL_WONDER_GREAT_ENGINEER_POINT_MODIFIER'),
	('TAJ_MAHAL_WONDER_TOURISM',   						'BoostsWonders',		1),
	('TAJ_MAHAL_WONDER_TOURISM',   						'ScalingFactor',		200),
	('TAJ_MAHAL_WONDER_GREAT_ENGINEER_POINT_MODIFIER',	'GreatPersonClassType',	'GREAT_PERSON_CLASS_ENGINEER'),
	('TAJ_MAHAL_WONDER_GREAT_ENGINEER_POINT_MODIFIER',	'Amount',				5);

-- Golden Gate Bridge
update Buildings set PrereqCivic = null, PrereqTech = 'TECH_STEEL' where BuildingType = 'BUILDING_GOLDEN_GATE_BRIDGE';

insert or replace into BuildingModifiers
  (BuildingType,          					ModifierId)
values
	('BUILDING_GOLDEN_GATE_BRIDGE',		'GOLDEN_GATE_BRIDGE_WONDER_DOMESTIC_TRADE_BONUS'),
	('BUILDING_GOLDEN_GATE_BRIDGE',		'GOLDEN_GATE_BRIDGE_WONDER_INERNATIONAL_TRADE_BONUS');

insert or replace into Modifiers
	(ModifierId,                																		ModifierType,																												SubjectRequirementSetId)
values
	('GOLDEN_GATE_BRIDGE_WONDER_DOMESTIC_TRADE_BONUS',							'MODIFIER_CITY_DISTRICTS_ATTACH_MODIFIER',													'HD_IS_COMPLETE_WONDER_REQUIREMENTS'),
	('GOLDEN_GATE_BRIDGE_WONDER_DOMESTIC_TRADE_BONUS_MODIFIER',			'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS',					null),
	('GOLDEN_GATE_BRIDGE_WONDER_INERNATIONAL_TRADE_BONUS',					'MODIFIER_CITY_DISTRICTS_ATTACH_MODIFIER',													'HD_IS_COMPLETE_WONDER_REQUIREMENTS'),
	('GOLDEN_GATE_BRIDGE_WONDER_INERNATIONAL_TRADE_BONUS_MODIFIER',	'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	null);

insert or replace into ModifierArguments
	(ModifierId,                																		Name,          			Value)
values
	('GOLDEN_GATE_BRIDGE_WONDER_DOMESTIC_TRADE_BONUS',							'ModifierId',				'GOLDEN_GATE_BRIDGE_WONDER_DOMESTIC_TRADE_BONUS_MODIFIER'),
	('GOLDEN_GATE_BRIDGE_WONDER_DOMESTIC_TRADE_BONUS_MODIFIER',			'YieldType',				'YIELD_GOLD'),
	('GOLDEN_GATE_BRIDGE_WONDER_DOMESTIC_TRADE_BONUS_MODIFIER',			'Amount',						5),
	('GOLDEN_GATE_BRIDGE_WONDER_DOMESTIC_TRADE_BONUS_MODIFIER',			'Domestic',					1),
	('GOLDEN_GATE_BRIDGE_WONDER_INERNATIONAL_TRADE_BONUS',					'ModifierId',				'GOLDEN_GATE_BRIDGE_WONDER_INERNATIONAL_TRADE_BONUS_MODIFIER'),
	('GOLDEN_GATE_BRIDGE_WONDER_INERNATIONAL_TRADE_BONUS_MODIFIER',	'YieldType',				'YIELD_GOLD'),
	('GOLDEN_GATE_BRIDGE_WONDER_INERNATIONAL_TRADE_BONUS_MODIFIER',	'Amount',						5);

-- Kilwa Kisiwani
update Buildings set PrereqTech = 'TECH_COMPASS_HD' where BuildingType = 'BUILDING_KILWA_KISIWANI';
delete from BuildingModifiers where BuildingType = 'BUILDING_KILWA_KISIWANI' and ModifierId != 'KILWA_THREE_INFLUENCE_TOKENS';
-- update Modifiers set ModifierType = 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER'			where ModifierId like 'KILWA_PLAYERCITIES_ADD%YIELD' or ModifierId like 'CVS_CITYSTATE_KILWA_PLAYERCITIES_ADD%';
-- update Modifiers set ModifierType = 'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION_MODIFIER'	where ModifierId = 'KILWA_PLAYERCITIES_ADDPRODUCTIONBUILDINGS';
-- update Modifiers set ModifierType = 'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_MODIFIER'	where ModifierId = 'KILWA_PLAYERCITIES_ADDPRODUCTIONDISTRICTS';
-- update Modifiers set ModifierType = 'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION_MODIFIER'		where ModifierId = 'KILWA_PLAYERCITIES_ADDPRODUCTIONUNITS';
-- update ModifierArguments set Value = 15 where Name = 'Amount' and (ModifierId = 'CVS_CITYSTATE_KILWA_SINGLE_ADDHARBORFOOD' or ModifierId = 'CVS_CITYSTATE_KILWA_PLAYERCITIES_ADDHARBORFOOD');
-- delete from BuildingModifiers where BuildingType = 'BUILDING_KILWA_KISIWANI' and (ModifierId = 'CVS_CITYSTATE_KILWA_SINGLE_ADDHARBORPRODUCTION' or ModifierId = 'CVS_CITYSTATE_KILWA_PLAYERCITIES_ADDHARBORPRODUCTION');

-- 1使者
insert or replace into BuildingModifiers
	(BuildingType,					      ModifierId)
select
	'BUILDING_KILWA_KISIWANI',    'HD_KILWA_' || CityStateType || '_ADD_' || YieldType
from CityStateCorrespondingYieldType_HD;

insert or replace into Modifiers
	(ModifierId,					        												ModifierType,			                                 SubjectRequirementSetId)
select
	'HD_KILWA_' || CityStateType || '_ADD_' || YieldType,	'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER', 'HD_' || CityStateType || '_SUZERAIN_1_REQUIREMENTS'
from CityStateCorrespondingYieldType_HD;

insert or replace into ModifierArguments
	(ModifierId,																					Name,		     Value)
select
	'HD_KILWA_' || CityStateType || '_ADD_' || YieldType,	'YieldType', YieldType
from CityStateCorrespondingYieldType_HD;

insert or replace into ModifierArguments
	(ModifierId,																					Name,		     Value)
select
	'HD_KILWA_' || CityStateType || '_ADD_' || YieldType,	'Amount', 	 15
from CityStateCorrespondingYieldType_HD;

-- 2使者
insert or replace into BuildingModifiers
	(BuildingType,					      ModifierId)
select
	'BUILDING_KILWA_KISIWANI',    'HD_KILWA_' || CityStateType || '_ADD_' || YieldType || "_2"
from CityStateCorrespondingYieldType_HD;

insert or replace into Modifiers
	(ModifierId,					        																ModifierType,			                                 SubjectRequirementSetId)
select
	'HD_KILWA_' || CityStateType || '_ADD_' || YieldType || "_2",	'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER', 'HD_' || CityStateType || '_SUZERAIN_2_REQUIREMENTS'
from CityStateCorrespondingYieldType_HD;

insert or replace into ModifierArguments
	(ModifierId,																									Name,		     Value)
select
	'HD_KILWA_' || CityStateType || '_ADD_' || YieldType || "_2",	'YieldType', YieldType
from CityStateCorrespondingYieldType_HD;

insert or replace into ModifierArguments
	(ModifierId,																									Name,		     Value)
select
	'HD_KILWA_' || CityStateType || '_ADD_' || YieldType || "_2",	'Amount', 	 15
from CityStateCorrespondingYieldType_HD;

-- Panama Canal
update Buildings set PrereqTech = null, PrereqCivic = 'CIVIC_COLONIALISM' where BuildingType = 'BUILDING_PANAMA_CANAL';

-- Forbidden City
insert or replace into Building_GreatWorks
	(BuildingType,					GreatWorkSlotType,				NumSlots,	ThemingSameObjectType,		ThemingYieldMultiplier,		ThemingTourismMultiplier,	ThemingBonusDescription)
values
	('BUILDING_FORBIDDEN_CITY',		'GREATWORKSLOT_PALACE',			2,			1,							100,						100,						'LOC_BUILDING_THEMINGBONUS_FORBIDDEN_CITY');

-- Országház
update Buildings set PrereqTech = null, PrereqCivic = 'CIVIC_SOCIAL_SCIENCE_HD' where BuildingType = 'BUILDING_ORSZAGHAZ';
insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
values
	('BUILDING_ORSZAGHAZ',		'MAHABODHI_DIPLOVP'),
	('BUILDING_ORSZAGHAZ',  	'ORSZAGHAZ_INFLUENCE_TOKENS');
insert or replace into Modifiers
	(ModifierId,                    	ModifierType,                               RunOnce)
values
	('ORSZAGHAZ_INFLUENCE_TOKENS',  	'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN',    1);
insert or replace into ModifierArguments
	(ModifierId,                    	Name,        Value)
values
	('ORSZAGHAZ_INFLUENCE_TOKENS',  	'Amount',    2);

-- Estádio do Maracanã
update Buildings set RegionalRange = 9 where BuildingType = 'BUILDING_ESTADIO_DO_MARACANA';
insert or ignore into Building_YieldChangesBonusWithPower
	(BuildingType,						YieldType,			YieldChange)
values
	('BUILDING_ESTADIO_DO_MARACANA',	'YIELD_GOLD',		12);
insert or ignore into Buildings_XP2
	(BuildingType,						RequiredPower,	EntertainmentBonusWithPower)
values
	('BUILDING_ESTADIO_DO_MARACANA',	6,				2);
insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
values
	('BUILDING_ESTADIO_DO_MARACANA',	'MARACANA_CITIES_GPP_BOOST');
insert or replace into Modifiers
	(ModifierId,					ModifierType,												OwnerRequirementSetId,	SubjectRequirementSetId)
values
	('MARACANA_CITIES_GPP_BOOST',	'MODIFIER_PLAYER_CITIES_ADJUST_GREAT_PERSON_POINT_BONUS',	'CITY_IS_POWERED',		NULL);
insert or replace into ModifierArguments
	(ModifierId,					Name,		Value)
values
	('MARACANA_CITIES_GPP_BOOST',	'Amount',	50);
create temporary table HD_Maracana_DistrictBonus (
    'DistrictType' text not null primary key,
    'YieldType' text not null
);
insert or replace into HD_Maracana_DistrictBonus (DistrictType, YieldType)
	select DistrictType, YieldType
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1 and HasAdjacency = 1;

insert or replace into Types
    (Type,                                      Kind)
select
    'BUILDING_MARACANA_DUMMY_' || DistrictType, 'KIND_BUILDING'
from HD_Maracana_DistrictBonus;
-- 记录虚拟建筑
insert or replace into HD_DUMMY_BUILDINGS (BuildingType)
	select 'BUILDING_MARACANA_DUMMY_' || DistrictType from HD_Maracana_DistrictBonus;
insert or replace into Buildings 
    (BuildingType, Name, Description, PrereqDistrict, Cost, MustPurchase) 
select
	'BUILDING_MARACANA_DUMMY_' || DistrictType,
	'LOC_BUILDING_MARACANA_DUMMY_' || DistrictType || '_NAME',
	'LOC_BUILDING_MARACANA_DUMMY_' || DistrictType || '_DESCRIPTION',
	DistrictType,
	0, 1
from HD_Maracana_DistrictBonus;
insert or replace into Buildings_XP2
	(BuildingType,									Pillage)
select
	'BUILDING_MARACANA_DUMMY_' || DistrictType,		0
from HD_Maracana_DistrictBonus;
insert or ignore into Types
	(Type,										Kind)
values
	('BUILDING_MARACANA_DUMMY_INTERNAL_ONLY',	'KIND_BUILDING');
-- 记录虚拟建筑
insert or replace into HD_DUMMY_BUILDINGS (BuildingType)
	values ('BUILDING_MARACANA_DUMMY_INTERNAL_ONLY');
insert or ignore into Buildings
	(BuildingType,								Cost,	Name,												InternalOnly)
values
	('BUILDING_MARACANA_DUMMY_INTERNAL_ONLY',	0,		'LOC_BUILDING_MARACANA_DUMMY_INTERNAL_ONLY_NAME',	1);
insert or replace into BuildingPrereqs
	(Building,										PrereqBuilding)
select
	'BUILDING_MARACANA_DUMMY_' || DistrictType,		'BUILDING_MARACANA_DUMMY_INTERNAL_ONLY'
from HD_Maracana_DistrictBonus;
insert or replace into Building_CitizenYieldChanges
	(BuildingType,									YieldType,	YieldChange)
select
	'BUILDING_MARACANA_DUMMY_' || DistrictType,		YieldType,	4
from HD_Maracana_DistrictBonus;
insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
select
	'BUILDING_ESTADIO_DO_MARACANA',		'MARACANA_' || DistrictType || '_EXPERT_ATTACH'
from HD_Maracana_DistrictBonus;
insert or replace into Modifiers
	(ModifierId,										ModifierType,										SubjectRequirementSetId)
select
	'MARACANA_' || DistrictType || '_EXPERT_ATTACH', 	'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',		NULL
from HD_Maracana_DistrictBonus;
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'MARACANA_' || DistrictType || '_EXPERT_ATTACH', 	'ModifierId',		'MARACANA_' || DistrictType || '_EXPERT_YIELD'
from HD_Maracana_DistrictBonus;
insert or replace into Modifiers
	(ModifierId,										ModifierType,												OwnerRequirementSetId)
select
	'MARACANA_' || DistrictType || '_EXPERT_YIELD', 	'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',		'DISTRICT_IS_' || DistrictType || '_REQUIREMENTS'
from HD_Maracana_DistrictBonus;
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'MARACANA_' || DistrictType || '_EXPERT_YIELD', 	'BuildingType',		'BUILDING_MARACANA_DUMMY_' || DistrictType
from HD_Maracana_DistrictBonus;

-- Free tech / civic Wonder
-- Player can choose awarded tech manually
update Modifiers set OwnerRequirementSetId = 'PLAYER_IS_AI' where ModifierId in ('OXFORD_UNIVERSITY_FREE_TECHS', 'BOLSHOI_THEATRE_FREE_CIVICS', 'ARECIBO_FREE_TECHS');

--圣瓦西里主教座堂
update Building_GreatWorks set
	NumSlots = 3,
	ThemingSameObjectType = 1,
	ThemingYieldMultiplier = 100,
	ThemingTourismMultiplier = 100,
	ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_ST_BASILS_CATHEDRAL'
where BuildingType = 'BUILDING_ST_BASILS_CATHEDRAL';

delete from BuildingModifiers where BuildingType = 'BUILDING_ST_BASILS_CATHEDRAL';
update ModifierArguments set Value = 200 where ModifierId = 'STBASILS_ADDRELIGIOUSTOURISM' and Name = 'ScalingFactor';

insert or replace into BuildingModifiers (BuildingType, ModifierId) values
	('BUILDING_ST_BASILS_CATHEDRAL',	'ST_BASILS_CATHEDRAL_POP'),
	('BUILDING_ST_BASILS_CATHEDRAL',	'ST_BASILS_CATHEDRAL_BUILDER'),
	('BUILDING_ST_BASILS_CATHEDRAL',	'TUNDRA_FARMS'),
	('BUILDING_ST_BASILS_CATHEDRAL',	'TUNDRA_HILLS_FARMS'),
	('BUILDING_ST_BASILS_CATHEDRAL',	'FRESH_WATER_TUNDRA_HILL_FARMS'),
	('BUILDING_ST_BASILS_CATHEDRAL',	'ST_BASILS_CATHEDRAL_YIELD_IMPROVEMENT'),
	('BUILDING_ST_BASILS_CATHEDRAL',	'ST_BASILS_CATHEDRAL_TOURISM_ATTACH');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, NewOnly, Permanent) values
	('ST_BASILS_CATHEDRAL_POP',								'MODIFIER_PLAYER_CITIES_ADD_POPULATION',			'PLOT_HAS_ANYTUNDRA_REQUIREMENTS', 1, 1),
	('ST_BASILS_CATHEDRAL_BUILDER',						'MODIFIER_PLAYER_CITIES_GRANT_UNIT_IN_CITY',	'PLOT_HAS_ANYTUNDRA_REQUIREMENTS', 1, 1);

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
	('ST_BASILS_CATHEDRAL_YIELD_IMPROVEMENT',	'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',				'ST_BASILS_CATHEDRAL_YIELD_IMPROVEMENT_REQUIREMENTS'),
	('ST_BASILS_CATHEDRAL_TOURISM_ATTACH',		'MODIFIER_CITY_DISTRICTS_ATTACH_MODIFIER',	'PLOT_HAS_COMPLETE_WONDER');

insert or replace into ModifierArguments (ModifierId, Name, value) values
	('ST_BASILS_CATHEDRAL_POP',								'Amount',			1),
	('ST_BASILS_CATHEDRAL_BUILDER',						'UnitType',		'UNIT_BUILDER'),
	('ST_BASILS_CATHEDRAL_BUILDER',						'Amount',			1),
	('ST_BASILS_CATHEDRAL_YIELD_IMPROVEMENT',	'YieldType',	'YIELD_FOOD,YIELD_PRODUCTION,YIELD_CULTURE,YIELD_FAITH'),
	('ST_BASILS_CATHEDRAL_YIELD_IMPROVEMENT',	'Amount',			'1,2,1,1'),
	('ST_BASILS_CATHEDRAL_TOURISM_ATTACH',		'ModifierId',	'STBASILS_ADDRELIGIOUSTOURISM');

insert or replace into HD_Binary_Compress_Keys (Key) values
	('HD_PLOT_BINARY_COMPRESS_ST_BASILS_CATHEDRAL_1'),
	('HD_PLOT_BINARY_COMPRESS_ST_BASILS_CATHEDRAL_2');

	-- 信徒提供产出
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_ST_BASILS_CATHEDRAL', 'HD_ST_BASILS_CATHEDRAL_CULTURE_' || Exp
	from HD_Binary_Compress where Exp < 10;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
	select 'HD_ST_BASILS_CATHEDRAL_CULTURE_' || Exp, 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_ST_BASILS_CATHEDRAL_1_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_ST_BASILS_CATHEDRAL_CULTURE_' || Exp, 'Amount', Amount
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_ST_BASILS_CATHEDRAL_CULTURE_' || Exp, 'YieldType', 'YIELD_CULTURE'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_ST_BASILS_CATHEDRAL_CULTURE_' || Exp, 'BuildingType', 'BUILDING_ST_BASILS_CATHEDRAL'
	from HD_Binary_Compress where Exp < 10;

insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_ST_BASILS_CATHEDRAL', 'HD_ST_BASILS_CATHEDRAL_FAITH_' || Exp
	from HD_Binary_Compress where Exp < 10;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
	select 'HD_ST_BASILS_CATHEDRAL_FAITH_' || Exp, 'MODIFIER_BUILDING_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_ST_BASILS_CATHEDRAL_2_' || Exp || '_REQUIREMENTS'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_ST_BASILS_CATHEDRAL_FAITH_' || Exp, 'Amount', Amount
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_ST_BASILS_CATHEDRAL_FAITH_' || Exp, 'YieldType', 'YIELD_FAITH'
	from HD_Binary_Compress where Exp < 10;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_ST_BASILS_CATHEDRAL_FAITH_' || Exp, 'BuildingType', 'BUILDING_ST_BASILS_CATHEDRAL'
	from HD_Binary_Compress where Exp < 10;

insert or replace into GlobalParameters (Name, Value) values
	('HD_ST_BASILS_CATHEDRAL_CULTURE_FOLLOWER', 3),
	('HD_ST_BASILS_CATHEDRAL_CULTURE_AMOUNT', 	1),
	('HD_ST_BASILS_CATHEDRAL_FAITH_FOLLOWER', 	3),
	('HD_ST_BASILS_CATHEDRAL_FAITH_AMOUNT', 		1);

--休伊神庙
delete from BuildingModifiers where ModifierId = 'HUEY_LAKE_FOOD' or ModifierId = 'HUEY_LAKE_PRODUCTION';
insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
select
	'BUILDING_HUEY_TEOCALLI',			'HUEY_FOOD_HD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_HUEY_TEOCALLI');
insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
select
	'BUILDING_HUEY_TEOCALLI',			'HUEY_PRODUCTION_HD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_HUEY_TEOCALLI');

insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
select
	'BUILDING_HUEY_TEOCALLI',			'HUEY_FOOD_HD_DISTRICT'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_HUEY_TEOCALLI');
insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
select
	'BUILDING_HUEY_TEOCALLI',			'HUEY_PRODUCTION_HD_DISTRICT'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_HUEY_TEOCALLI');

insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
select
	'BUILDING_HUEY_TEOCALLI',			'HUEY_FOOD_HD_WONDER'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_HUEY_TEOCALLI');
insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
select
	'BUILDING_HUEY_TEOCALLI',			'HUEY_PRODUCTION_HD_WONDER'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_HUEY_TEOCALLI');

insert or replace into Modifiers
	(ModifierId,							ModifierType,										SubjectRequirementSetId)
values
	('HUEY_FOOD_HD',						'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',				'ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS'),
	('HUEY_PRODUCTION_HD',					'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',				'ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS'),
	('HUEY_FOOD_HD_DISTRICT',						'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',				'DISTRICT_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS'),
	('HUEY_PRODUCTION_HD_DISTRICT',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',				'DISTRICT_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS'),
	('HUEY_FOOD_HD_WONDER',						'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',				'WONDER_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS'),
	('HUEY_PRODUCTION_HD_WONDER',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',				'WONDER_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,							Name,					value)
values
	('HUEY_FOOD_HD',						'YieldType',			'YIELD_FOOD'),
	('HUEY_FOOD_HD',						'Amount',				2),
	('HUEY_PRODUCTION_HD',					'YieldType',			'YIELD_PRODUCTION'),
	('HUEY_PRODUCTION_HD',					'Amount',				1),
	('HUEY_FOOD_HD_DISTRICT',						'YieldType',			'YIELD_FOOD'),
	('HUEY_FOOD_HD_DISTRICT',						'Amount',				2),
	('HUEY_PRODUCTION_HD_DISTRICT',					'YieldType',			'YIELD_PRODUCTION'),
	('HUEY_PRODUCTION_HD_DISTRICT',					'Amount',				1),
	('HUEY_FOOD_HD_WONDER',						'YieldType',			'YIELD_FOOD'),
	('HUEY_FOOD_HD_WONDER',						'Amount',				2),
	('HUEY_PRODUCTION_HD_WONDER',					'YieldType',			'YIELD_PRODUCTION'),
	('HUEY_PRODUCTION_HD_WONDER',					'Amount',				1);

-- 埃菲尔铁塔
	-- 相邻加成
insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
select
	'BUILDING_EIFFEL_TOWER',		'HD_EIFFEL_' || DistrictType || '_ADJACENCY_BONUS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into Modifiers
	(ModifierId,																					ModifierType,																				SubjectRequirementSetId)
select
	'HD_EIFFEL_' || DistrictType || '_ADJACENCY_BONUS',		'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',	'HD_REQUIRES_DISTRICT_IS_' || DistrictType || '_APPEAL_MORE_THAN_8'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments
	(ModifierId,																					Name,					value)
select
	'HD_EIFFEL_' || DistrictType || '_ADJACENCY_BONUS',		'YieldType',	YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments
	(ModifierId,																					Name,					value)
select
	'HD_EIFFEL_' || DistrictType || '_ADJACENCY_BONUS',		'Amount',			50
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

	-- 相邻业绩
insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
select
	'BUILDING_EIFFEL_TOWER',		'HD_EIFFEL_' || DistrictType || '_ADJACENCY_TOURISM'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into Modifiers
	(ModifierId,																					ModifierType,																													SubjectRequirementSetId)
select
	'HD_EIFFEL_' || DistrictType || '_ADJACENCY_TOURISM',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_TOURISM_ADJACENCY_YIELD_MOFIFIER',	'HD_REQUIRES_DISTRICT_IS_' || DistrictType || '_APPEAL_MORE_THAN_8'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments
	(ModifierId,																					Name,					value)
select
	'HD_EIFFEL_' || DistrictType || '_ADJACENCY_TOURISM',	'YieldType',	YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments
	(ModifierId,																					Name,					value)
select
	'HD_EIFFEL_' || DistrictType || '_ADJACENCY_TOURISM',	'Amount',			100
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

	-- 伟人点
insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
select
	'BUILDING_EIFFEL_TOWER',		'HD_EIFFEL_' || DistrictType || '_' || GreatPersonClassType || '_GPP'
from DistrictCorrespondingGPP_HD;

insert or replace into Modifiers
	(ModifierId,																															ModifierType,																	SubjectRequirementSetId)
select
	'HD_EIFFEL_' || DistrictType || '_' || GreatPersonClassType || '_GPP',		'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	'HD_REQUIRES_DISTRICT_IS_' || DistrictType || '_APPEAL_MORE_THAN_8'
from DistrictCorrespondingGPP_HD;

insert or replace into Modifiers
	(ModifierId,																																			ModifierType)
select
	'HD_EIFFEL_' || DistrictType || '_' || GreatPersonClassType || '_GPP_MODIFIER',		'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT'
from DistrictCorrespondingGPP_HD;

insert or replace into ModifierArguments
	(ModifierId,																														Name,					value)
select
	'HD_EIFFEL_' || DistrictType || '_' || GreatPersonClassType || '_GPP',	'ModifierId',	'HD_EIFFEL_' || DistrictType || '_' || GreatPersonClassType || '_GPP_MODIFIER'
from DistrictCorrespondingGPP_HD;

insert or replace into ModifierArguments
	(ModifierId,																																		Name,										value)
select
	'HD_EIFFEL_' || DistrictType || '_' || GreatPersonClassType || '_GPP_MODIFIER',	'GreatPersonClassType',	GreatPersonClassType
from DistrictCorrespondingGPP_HD;

insert or replace into ModifierArguments
	(ModifierId,																																		Name,			value)
select
	'HD_EIFFEL_' || DistrictType || '_' || GreatPersonClassType || '_GPP_MODIFIER',	'Amount',	15
from DistrictCorrespondingGPP_HD;

-- 阿耳忒弥斯神庙
delete from ImprovementModifiers where ModifierId in ('TEMPLE_ARTEMIS_CAMP_AMENITY', 'TEMPLE_ARTEMIS_PASTURE_AMENITY', 'TEMPLE_ARTEMIS_PLANTATION_AMENITY');

insert or replace into BuildingModifiers (BuildingType, ModifierId) values
	('BUILDING_TEMPLE_ARTEMIS', 'HD_TEMPLE_ARTEMIS_COMMERCIAL_HUB_PRODUCTION'),
	('BUILDING_TEMPLE_ARTEMIS', 'HD_TEMPLE_ARTEMIS_ENTERTAINMENT_COMPLEX_PRODUCTION');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
	('HD_TEMPLE_ARTEMIS_COMMERCIAL_HUB_PRODUCTION',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',	'REQUIRES_DISTRICT_IS_DISTRICT_COMMERCIAL_HUB_UDMET'),
	('HD_TEMPLE_ARTEMIS_ENTERTAINMENT_COMPLEX_PRODUCTION',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',	'REQUIRES_DISTRICT_IS_DISTRICT_ENTERTAINMENT_COMPLEX_UDMET');

insert or replace into ModifierArguments (ModifierId, Name, value) values
	('HD_TEMPLE_ARTEMIS_COMMERCIAL_HUB_PRODUCTION',					'YieldType',	'YIELD_PRODUCTION'),
	('HD_TEMPLE_ARTEMIS_COMMERCIAL_HUB_PRODUCTION',					'Amount',			2),
	('HD_TEMPLE_ARTEMIS_ENTERTAINMENT_COMPLEX_PRODUCTION',	'YieldType',	'YIELD_PRODUCTION'),
	('HD_TEMPLE_ARTEMIS_ENTERTAINMENT_COMPLEX_PRODUCTION',	'Amount',			2);

	-- 地貌改良加产
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_TEMPLE_ARTEMIS', 'HD_TEMPLE_ARTEMIS_' || FeatureType || '_PLOT_BONUS'
from Features where NaturalWonder = 0 and Impassable = 0 and FeatureType not like '%BURN%';

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	select 'HD_TEMPLE_ARTEMIS_' || FeatureType || '_PLOT_BONUS',
	'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
	'HD_PLOT_ADJACENT_TO_' || FeatureType,
	'HD_PLOT_HAS_' || FeatureType
from Features where NaturalWonder = 0 and Impassable = 0 and FeatureType not like '%BURN%';

insert or replace into ModifierArguments (ModifierId, Name, value)
	select 'HD_TEMPLE_ARTEMIS_' || FeatureType || '_PLOT_BONUS', 'YieldType', 'YIELD_PRODUCTION,YIELD_GOLD'
from Features where NaturalWonder = 0 and Impassable = 0 and FeatureType not like '%BURN%';

insert or replace into ModifierArguments (ModifierId, Name, value)
	select 'HD_TEMPLE_ARTEMIS_' || FeatureType || '_PLOT_BONUS', 'Amount', '1,1'
from Features where NaturalWonder = 0 and Impassable = 0 and FeatureType not like '%BURN%';

--莫斯科大剧院
update Building_GreatWorks set NumSlots = 2 where BuildingType = 'BUILDING_BOLSHOI_THEATRE';

-- 圣米歇尔山
update Buildings set RequiresReligion = 1, MustBeAdjacentLand = 1 where BuildingType = 'BUILDING_MONT_ST_MICHEL';
update Building_GreatWorks set
	NumSlots = 3,
	ThemingSameObjectType = 1,
	ThemingYieldMultiplier = 100,
	ThemingTourismMultiplier = 100,
	ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_MONT_ST_MICHEL'
where BuildingType = 'BUILDING_MONT_ST_MICHEL';
delete from Building_RequiredFeatures where BuildingType = 'BUILDING_MONT_ST_MICHEL';
insert or replace into Building_ValidTerrains
	(BuildingType,							TerrainType)
values
	('BUILDING_MONT_ST_MICHEL',	'TERRAIN_COAST');

insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
values
	('BUILDING_MONT_ST_MICHEL',	'HD_MONT_ST_MICHEL_GRANT_PILGRIM'),
	('BUILDING_MONT_ST_MICHEL',	'HD_MONT_ST_MICHEL_IGNORE_RIVER');

insert or replace into Modifiers
	(ModifierId, 																ModifierType, 														SubjectRequirementSetId)
values
	('HD_MONT_ST_MICHEL_IGNORE_RIVER',					'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',		NULL);

insert or replace into Modifiers
	(ModifierId, 																ModifierType, 														SubjectRequirementSetId,	Permanent)
values
	('HD_MONT_ST_MICHEL_GRANT_PILGRIM',					'MODIFIER_PLAYER_UNITS_GRANT_PROMOTION',	NULL,											1);	

insert or replace into ModifierArguments
	(ModifierId, 																Name, 								value)
values
	('HD_MONT_ST_MICHEL_GRANT_PILGRIM',					'PromotionType',			'PROMOTION_PILGRIM'),
	('HD_MONT_ST_MICHEL_IGNORE_RIVER',					'AbilityType',				'ABILITY_HD_MONT_ST_MICHEL_IGNORE_RIVER');

insert or replace into GlobalParameters (Name, Value) values ('HD_MONT_ST_MICHEL_GPP_AMOUNT', 25);

-- 神谕
delete from BuildingModifiers where BuildingType = 'BUILDING_ORACLE' and ModifierId != 'ORACLE_PATRONAGE_FAITH_DISCOUNT';

insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_ORACLE', 'HD_ORACLE_' || GreatPersonClassType || '_POINTS'
from DistrictCorrespondingGPP_HD;

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)	
	select 'HD_ORACLE_' || GreatPersonClassType || '_POINTS', 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', 'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET'
from DistrictCorrespondingGPP_HD;

insert or replace into ModifierArguments (ModifierId, name, value)
	select 'HD_ORACLE_' || GreatPersonClassType || '_POINTS', 'GreatPersonClassType', GreatPersonClassType
from DistrictCorrespondingGPP_HD;

insert or replace into ModifierArguments (ModifierId, name, value)
	select 'HD_ORACLE_' || GreatPersonClassType || '_POINTS', 'Amount', 6
from DistrictCorrespondingGPP_HD;