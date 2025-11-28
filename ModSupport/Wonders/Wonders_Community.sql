-----------------------------------------------------------------------------------------
------support some Comunity Wonder and update its effect , unlock civ&tech and cost------
-----------------------------------------------------------------------------------------

-- Abu Simbel
delete from Building_YieldChanges where BuildingType = 'BUILDING_ABU_SIMBEL';
update Buildings set ObsoleteEra = 'ERA_MEDIEVAL', PrereqTech = 'TECH_CALENDAR_HD', PrereqCivic = null, RequiresRiver = 1, Housing = 1 where BuildingType = 'BUILDING_ABU_SIMBEL';
delete from Building_RequiredFeatures where BuildingType = 'BUILDING_ABU_SIMBEL';
insert or replace into Building_ValidTerrains
	(BuildingType,			TerrainType)
select 'BUILDING_ABU_SIMBEL', TerrainType
	from Terrains where TerrainType in ('TERRAIN_GRASS', 'TERRAIN_PLAINS', 'TERRAIN_TUNDRA', 'TERRAIN_SNOW', 'TERRAIN_DESERT')
	and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_ABU_SIMBEL');

delete from BuildingModifiers where BuildingType = 'BUILDING_ABU_SIMBEL';
insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
select
	'BUILDING_ABU_SIMBEL',		'ABU_SIMBEL_RIVER_DISTRICT_FOOD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_ABU_SIMBEL');
insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
select
	'BUILDING_ABU_SIMBEL',		'ABU_SIMBEL_RIVER_WONDER_FOOD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_ABU_SIMBEL');
insert or replace into Modifiers
	(ModifierId,							ModifierType,										SubjectRequirementSetId)
values
	('ABU_SIMBEL_RIVER_DISTRICT_FOOD',		'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',	'PLOT_IS_DISTRICT_ADJACENT_TO_RIVER_REQUIREMENTS'),
	('ABU_SIMBEL_RIVER_WONDER_FOOD',		'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',	'PLOT_IS_WONDER_ADJACENT_TO_RIVER_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,							Name,				Value)
values
	('ABU_SIMBEL_RIVER_DISTRICT_FOOD',		'YieldType',		'YIELD_FOOD'),
	('ABU_SIMBEL_RIVER_DISTRICT_FOOD',		'Amount',			1),
	('ABU_SIMBEL_RIVER_WONDER_FOOD',		'YieldType',		'YIELD_FOOD'),
	('ABU_SIMBEL_RIVER_WONDER_FOOD',		'Amount',			1);

-- insert or replace into Modifiers
-- 	(ModifierId,					ModifierType)
-- values
-- 	('ABU_SIMBEL_GRANARY_FOOD',		'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE');
-- insert or replace into ModifierArguments
-- 	(ModifierId,					Name,				Value)
-- values
-- 	('ABU_SIMBEL_GRANARY_FOOD',		'BuildingType',		'BUILDING_GRANARY'),
-- 	('ABU_SIMBEL_GRANARY_FOOD',		'YieldType',		'YIELD_FOOD'),
-- 	('ABU_SIMBEL_GRANARY_FOOD',		'Amount',			1);
-- insert or replace into BuildingModifiers
-- 	(BuildingType,				ModifierId)
-- select
-- 	'BUILDING_ABU_SIMBEL',		'ABU_SIMBEL_GRANARY_FOOD'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_ABU_SIMBEL');

----------------------------------------------------------------------------------------------------------------
--BUILDING_LEANING_TOWER----------------------------------------------------------------------------------------
UPDATE Buildings set ObsoleteEra = 'ERA_MODERN', PrereqTech = 'TECH_PHYSICS_HD', PrereqCivic = NULL, PrereqDistrict = NULL, AdjacentDistrict = Null WHERE BuildingType = 'BUILDING_LEANING_TOWER';
delete from Building_YieldChanges where BuildingType = 'BUILDING_LEANING_TOWER';
delete from BuildingModifiers where BuildingType = 'BUILDING_LEANING_TOWER';

insert or replace into Building_GreatPersonPoints (BuildingType, GreatPersonClassType, PointsPerTurn)
select 'BUILDING_LEANING_TOWER', 'GREAT_PERSON_CLASS_SCIENTIST', 2
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_LEANING_TOWER');

insert or replace into Building_ValidTerrains (BuildingType, TerrainType)
	select 'BUILDING_LEANING_TOWER', TerrainType
from Terrains where TerrainType in ('TERRAIN_TUNDRA', 'TERRAIN_SNOW', 'TERRAIN_DESERT')
and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_LEANING_TOWER');

insert or replace into BuildingPrereqs (Building, PrereqBuilding)
	select 'BUILDING_LEANING_TOWER', BuildingType
from Buildings where GovernmentTierRequirement = 'Tier2'
and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_LEANING_TOWER');

--grants an scientist
insert or ignore into ProjectCompletionModifiers (ProjectType, ModifierId)
	select 'PROJECT_BUILDING_LEANING_TOWER', 'LEANING_TOWER_GRANTS_SCIENTIST'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_LEANING_TOWER');

insert or replace into Modifiers (ModifierId, ModifierType, RunOnce, Permanent, SubjectStackLimit) values
('LEANING_TOWER_GRANTS_SCIENTIST', 'MODIFIER_SINGLE_CITY_GRANT_GREAT_PERSON_CLASS_IN_CITY',1,1,1);

insert or replace into ModifierArguments (ModifierId,	Name,	Value) values
('LEANING_TOWER_GRANTS_SCIENTIST', 'Amount', 1),
('LEANING_TOWER_GRANTS_SCIENTIST', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_SCIENTIST');

insert or replace into GlobalParameters
	(Name,																		Value)
values
	('HD_LEANING_TOWER_SCIENTIST_PERCENTAGE',	10);
----------------------------------------------------------------------------------------------------------------------
----------------BUILDING_PORCELAIN_TOWER------------------------------------------------------------------------------
UPDATE Buildings SET ObsoleteEra = 'ERA_MODERN', PrereqTech = NULL, PrereqCivic = 'CIVIC_THE_ENLIGHTENMENT', AdjacentDistrict = 'DISTRICT_HOLY_SITE' where BuildingType = 'BUILDING_PORCELAIN_TOWER';
delete from Building_YieldChanges where BuildingType = 'BUILDING_PORCELAIN_TOWER';
update Building_GreatPersonPoints set GreatPersonClassType = 'GREAT_PERSON_CLASS_ENGINEER' where BuildingType = 'BUILDING_PORCELAIN_TOWER';

insert or replace into Building_ValidTerrains (BuildingType, TerrainType)
	select 'BUILDING_PORCELAIN_TOWER', TerrainType
from Terrains where TerrainType in ('TERRAIN_SNOW', 'TERRAIN_DESERT')
and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PORCELAIN_TOWER');

insert or replace into BuildingPrereqs (Building, PrereqBuilding)
	select 'BUILDING_PORCELAIN_TOWER', 'BUILDING_TEMPLE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PORCELAIN_TOWER');

insert or replace into BuildingPrereqs (Building, PrereqBuilding)
	select 'BUILDING_PORCELAIN_TOWER', 'BUILDING_HD_ALCHEMY_ROOM'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PORCELAIN_TOWER');

--grants a engineer
insert or ignore into ProjectCompletionModifiers (ProjectType, ModifierId)
select	'PROJECT_BUILDING_PORCELAIN_TOWER', 'PORCELAIN_TOWER_GRANTS_ENGINEER'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PORCELAIN_TOWER');

insert or ignore into Modifiers (ModifierId, ModifierType, RunOnce, Permanent, SubjectStackLimit) values
('PORCELAIN_TOWER_GRANTS_ENGINEER',	'MODIFIER_SINGLE_CITY_GRANT_GREAT_PERSON_CLASS_IN_CITY',1,1,1);

insert or ignore into ModifierArguments (ModifierId,	Name,	Value) values
('PORCELAIN_TOWER_GRANTS_ENGINEER',	'Amount',	1),
('PORCELAIN_TOWER_GRANTS_ENGINEER',	'GreatPersonClassType',	'GREAT_PERSON_CLASS_ENGINEER');
-----------------------------------------------------------------------------------------------------------------------
-------BUILDING_NEUSCHWANSTEIN-----------------------------------------------------------------------------------------
update Buildings set ObsoleteEra = 'ERA_ATOMIC', AdjacentToMountain = 0 where BuildingType = 'BUILDING_NEUSCHWANSTEIN'
	AND EXISTS (SELECT BuildingType FROM Buildings WHERE BuildingType ='BUILDING_NEUSCHWANSTEIN');

delete from BuildingModifiers where BuildingType = 'BUILDING_NEUSCHWANSTEIN';

insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_CULTURE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_WALLS_CULTURE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_CASTLE_CULTURE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_CULTURE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_GOLD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_WALLS_GOLD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_CASTLE_GOLD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_GOLD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_AMENITY'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_WALLS_AMENITY'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_CASTLE_AMENITY'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_AMENITY'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_MUSICIAN_POINTS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_WALLS_MUSICIAN_POINTS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_CASTLE_MUSICIAN_POINTS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_MUSICIAN_POINTS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_NEUSCHWANSTEIN', 'HD_NEUSCHWANSTEIN_CITY_MUSIC_TOURISM'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

insert or replace into Modifiers 
	(ModifierId,											ModifierType,											SubjectRequirementSetId)
values 
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_CULTURE',			'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',						NULL),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_CULTURE',			'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',						NULL),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_CULTURE',			'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',						NULL),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_CULTURE',		'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',						NULL),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_GOLD',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',						NULL),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_GOLD',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',						NULL),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_GOLD',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',						NULL),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_GOLD',			'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',						NULL),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_AMENITY',			'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',			'CITY_HAS_BUILDING_WALLS_EARLY_REQUIREMENTS'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_AMENITY',			'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',			'CITY_HAS_BUILDING_WALLS_REQUIREMENTS'),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_AMENITY',			'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',			'CITY_HAS_BUILDING_CASTLE_REQUIREMENTS'),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_AMENITY',		'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',			'CITY_HAS_BUILDING_STAR_FORT_REQUIREMENTS'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_MUSICIAN_POINTS',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',		'HD_PLOT_HAS_BUILDING_WALLS_EARLY_REQUIREMENTS'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_MUSICIAN_POINTS',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',		'HD_PLOT_HAS_BUILDING_WALLS_REQUIREMENTS'),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_MUSICIAN_POINTS',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',		'HD_PLOT_HAS_BUILDING_CASTLE_REQUIREMENTS'),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_MUSICIAN_POINTS','MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',		'HD_PLOT_HAS_BUILDING_STAR_FORT_REQUIREMENTS'),
	('HD_NEUSCHWANSTEIN_CITY_MUSIC_TOURISM',				'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',					NULL);

insert or replace into ModifierArguments 
	(ModifierId,											Name,										Value)
values 
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_CULTURE',			'BuildingType',								'BUILDING_WALLS_EARLY'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_CULTURE',			'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_CULTURE',			'YieldType',								'YIELD_CULTURE'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_CULTURE',			'BuildingType',								'BUILDING_WALLS'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_CULTURE',			'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_CULTURE',			'YieldType',								'YIELD_CULTURE'),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_CULTURE',			'BuildingType',								'BUILDING_CASTLE'),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_CULTURE',			'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_CULTURE',			'YieldType',								'YIELD_CULTURE'),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_CULTURE',		'BuildingType',								'BUILDING_STAR_FORT'),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_CULTURE',		'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_CULTURE',		'YieldType',								'YIELD_CULTURE'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_GOLD',				'BuildingType',								'BUILDING_WALLS_EARLY'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_GOLD',				'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_GOLD',				'YieldType',								'YIELD_GOLD'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_GOLD',				'BuildingType',								'BUILDING_WALLS'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_GOLD',				'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_GOLD',				'YieldType',								'YIELD_GOLD'),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_GOLD',				'BuildingType',								'BUILDING_CASTLE'),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_GOLD',				'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_GOLD',				'YieldType',								'YIELD_GOLD'),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_GOLD',			'BuildingType',								'BUILDING_STAR_FORT'),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_GOLD',			'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_GOLD',			'YieldType',								'YIELD_GOLD'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_AMENITY',			'Amount',									1),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_AMENITY',			'Amount',									1),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_AMENITY',			'Amount',									1),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_AMENITY',		'Amount',									1),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_MUSICIAN_POINTS',	'GreatPersonClassType',						'GREAT_PERSON_CLASS_MUSICIAN'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_EARLY_MUSICIAN_POINTS',	'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_MUSICIAN_POINTS',	'GreatPersonClassType',						'GREAT_PERSON_CLASS_MUSICIAN'),
	('HD_NEUSCHWANSTEIN_BUILDING_WALLS_MUSICIAN_POINTS',	'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_MUSICIAN_POINTS',	'GreatPersonClassType',						'GREAT_PERSON_CLASS_MUSICIAN'),
	('HD_NEUSCHWANSTEIN_BUILDING_CASTLE_MUSICIAN_POINTS',	'Amount',									4),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_MUSICIAN_POINTS','GreatPersonClassType',						'GREAT_PERSON_CLASS_MUSICIAN'),
	('HD_NEUSCHWANSTEIN_BUILDING_STAR_FORT_MUSICIAN_POINTS','Amount',									4),
	('HD_NEUSCHWANSTEIN_CITY_MUSIC_TOURISM',				'GreatWorkObjectType',						'GREATWORKOBJECT_MUSIC'),
	('HD_NEUSCHWANSTEIN_CITY_MUSIC_TOURISM',				'ScalingFactor',							300);

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_NEUSCHWANSTEIN', 'CONSERVATION_ANCIENT_WALL_TOURISM'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_NEUSCHWANSTEIN', 'CONSERVATION_MEDIEVAL_WALL_TOURISM'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_NEUSCHWANSTEIN', 'CONSERVATION_RENAISSANCE_WALL_TOURISM'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

--SPECIAL ADJUSTMENT FOR TSIKHE(make it yield(5+15)*2=30 tourism)
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_NEUSCHWANSTEIN', 'CONSERVATION_TSIKHE_TOURISM'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_NEUSCHWANSTEIN', 'CONSERVATION_TSIKHE_TOURISM_GOLDEN_AGE'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

-- update ModifierArguments set Value = 4 where ModifierId = 'NEUSCHWANSTEIN_WALLS_CULTURE_MODIFIER' and Name = 'Amount';
-- update ModifierArguments set Value = 6 where ModifierId = 'NEUSCHWANSTEIN_WALLS_GOLD_MODIFIER' and Name = 'Amount';
-- update ModifierArguments set Value = 2 where ModifierId = 'NEUSCHWANSTEIN_WALLS_AMENITY_MODIFIER' and Name = 'Amount';

-- update Building_YieldChanges set YieldChange = 4 where BuildingType = 'BUILDING_NEUSCHWANSTEIN' and YieldType = 'YIELD_CULTURE';
-- update Building_YieldChanges set YieldChange = 6 where BuildingType = 'BUILDING_NEUSCHWANSTEIN' and YieldType = 'YIELD_GOLD';

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_NEUSCHWANSTEIN', 'NEUSCHWANSTEIN_ADD_HOUSING'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

-- insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
-- 	'NEUSCHWANSTEIN_ADD_HOUSING', 'MODIFIER_PLAYER_CITIES_ADJUST_POLICY_HOUSING', 'CITY_HAS_MED_OR_REN_WALLS_REQUIREMENTS'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

-- insert or replace into ModifierArguments (ModifierId,	Name,	Value) select
-- 	'NEUSCHWANSTEIN_ADD_HOUSING',	'Amount', 1
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_NEUSCHWANSTEIN');

--  neuschwanstein theming bonus from different aurthor
update Building_GreatWorks set 
	NumSlots = 4,
	ThemingUniquePerson = 1 ,
	ThemingSameObjectType = 0 ,
	ThemingSameEras = 0 ,
	ThemingTourismMultiplier = 100 ,
	ThemingYieldMultiplier = 100
where BuildingType ='BUILDING_NEUSCHWANSTEIN';
--------------------------------------------------------------------------------------------------------------------------------
------- BUILDING_UFFIZI---------------------------------------------------------------------------------------------------------
UPDATE Buildings SET ObsoleteEra = 'ERA_MODERN'
WHERE BuildingType = 'BUILDING_UFFIZI' AND EXISTS (SELECT BuildingType FROM Buildings WHERE BuildingType ='BUILDING_UFFIZI');
delete from BuildingModifiers where ModifierId = 'UFFIZI_ART_MUSEUM_CULTURE_MODIFIER';

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_UFFIZI', 'UFFIZI_CITY_GOLD'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_UFFIZI', 'UFFIZI_CITY_CULTURE'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_UFFIZI', 'UFFIZI_CITY_WRITING_TOURISM'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_UFFIZI', 'UFFIZI_CITY_SCULPTURE_TOURISM'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_UFFIZI', 'UFFIZI_CITY_PORTRAIT_TOURISM'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_UFFIZI', 'UFFIZI_CITY_ART_TOURISM'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_UFFIZI', 'UFFIZI_CITY_RELIGIOUS_TOURISM'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_UFFIZI', 'UFFIZI_CITY_LANDSCAPE_TOURISM'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_UFFIZI', 'UFFIZI_CITY_MUSIC_TOURISM'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');

-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_UFFIZI', 'BUILDING_UFFIZI_THEATER_DISTRICT_ADJACENCY'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_UFFIZI', 'BUILDING_UFFIZI_COMMERCIAL_DISTRICT_ADJACENCY'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_UFFIZI', 'BUILDING_UFFIZI_THEATER_ADJACENT_COMMERCIAL_ADJACENCY_MODIFIER'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');
-- insert or replace into BuildingModifiers (BuildingType, ModifierId)
-- select	'BUILDING_UFFIZI', 'BUILDING_UFFIZI_COMMERCIAL_ADJACENT_THEATER_ADJACENCY_MODIFIER'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');

insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_UFFIZI', 'BUILDING_UFFIZI_THEATER_ADJACENT'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_UFFIZI');

insert or replace into Modifiers
	(ModifierId, 														ModifierType,				 						SubjectRequirementSetId) 
values
	('UFFIZI_CITY_GOLD',												'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER','CITY_HAS_THEATER_AND_COMMERCIAL_HUB_REQUIRMENTS'),			
	('UFFIZI_CITY_CULTURE',												'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER','CITY_HAS_THEATER_AND_COMMERCIAL_HUB_REQUIRMENTS'),	
	-- ('UFFIZI_CITY_WRITING_TOURISM',		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',			'CITY_HAS_THEATER_AND_COMMERCIAL_HUB_REQUIRMENTS'),	
	('UFFIZI_CITY_SCULPTURE_TOURISM',									'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',				NULL),	
	('UFFIZI_CITY_PORTRAIT_TOURISM',									'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',				NULL),	
	-- ('UFFIZI_CITY_ART_TOURISM',											'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',				NULL),	
	('UFFIZI_CITY_RELIGIOUS_TOURISM',									'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',				NULL),
	('UFFIZI_CITY_MUSIC_TOURISM',										'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',				NULL),
	('UFFIZI_CITY_LANDSCAPE_TOURISM',									'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',				NULL),
	-- ('BUILDING_UFFIZI_THEATER_DISTRICT_ADJACENCY',						'MODIFIER_PLAYER_CITIES_DISTRICT_ADJACENCY',		NULL),	
	-- ('BUILDING_UFFIZI_COMMERCIAL_DISTRICT_ADJACENCY',					'MODIFIER_PLAYER_CITIES_DISTRICT_ADJACENCY',		NULL),
	-- ('BUILDING_UFFIZI_THEATER_ADJACENT_COMMERCIAL_ADJACENCY_MODIFIER',	'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',	'DISTRICT_IS_THEATER_AND_ADJACENT_TO_COMMERCIAL'),
	-- ('BUILDING_UFFIZI_COMMERCIAL_ADJACENT_THEATER_ADJACENCY_MODIFIER',	'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',	'DISTRICT_IS_COMMERCIAL_AND_ADJACENT_TO_THEATER'),
	('BUILDING_UFFIZI_THEATER_ADJACENT',					'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',	'HD_CITY_DISTRICT_COMMERCIAL_HUB_HAS_6_ADJACENCY_REQUIREMENTS'),
	('BUILDING_UFFIZI_THEATER_ADJACENT_MODIFIER',	'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',	'DISTRICT_IS_THEATER');

insert or replace into ModifierArguments 
	(ModifierId,										Name,					Value) 
values 
	('UFFIZI_CITY_GOLD',								'Amount',				10),
	('UFFIZI_CITY_GOLD',								'YieldType',			'YIELD_GOLD'),				
	('UFFIZI_CITY_CULTURE',								'Amount',				10),
	('UFFIZI_CITY_CULTURE',								'YieldType',			'YIELD_CULTURE'),
	-- ('UFFIZI_CITY_WRITING_TOURISM',			'GreatWorkObjectType',	'GREATWORKOBJECT_WRITING'),	
	-- ('UFFIZI_CITY_WRITING_TOURISM',			'ScalingFactor',		150),
	('UFFIZI_CITY_SCULPTURE_TOURISM',					'GreatWorkObjectType',	'GREATWORKOBJECT_SCULPTURE'),
	('UFFIZI_CITY_SCULPTURE_TOURISM',					'ScalingFactor',		200),
	('UFFIZI_CITY_PORTRAIT_TOURISM',					'GreatWorkObjectType',	'GREATWORKOBJECT_PORTRAIT'),
	('UFFIZI_CITY_PORTRAIT_TOURISM',					'ScalingFactor',		200),
	-- ('UFFIZI_CITY_ART_TOURISM',							'GreatWorkObjectType',	'GREATWORKOBJECT_ARTIFACT'),
	-- ('UFFIZI_CITY_ART_TOURISM',							'ScalingFactor',		200),
	('UFFIZI_CITY_RELIGIOUS_TOURISM',					'GreatWorkObjectType',	'GREATWORKOBJECT_RELIGIOUS'),
	('UFFIZI_CITY_RELIGIOUS_TOURISM',					'ScalingFactor',		200),	
	('UFFIZI_CITY_LANDSCAPE_TOURISM',					'GreatWorkObjectType',	'GREATWORKOBJECT_LANDSCAPE'),
	('UFFIZI_CITY_LANDSCAPE_TOURISM',					'ScalingFactor',		200),
	('UFFIZI_CITY_MUSIC_TOURISM',						'GreatWorkObjectType',	'GREATWORKOBJECT_MUSIC'),
	('UFFIZI_CITY_MUSIC_TOURISM',						'ScalingFactor',		150),
	-- ('BUILDING_UFFIZI_THEATER_DISTRICT_ADJACENCY',		'DistrictType',	'DISTRICT_THEATER'),
	-- ('BUILDING_UFFIZI_THEATER_DISTRICT_ADJACENCY',		'YieldType',	'YIELD_CULTURE'),	
	-- ('BUILDING_UFFIZI_THEATER_DISTRICT_ADJACENCY',		'Amount',		1),
	-- ('BUILDING_UFFIZI_THEATER_DISTRICT_ADJACENCY',		'Description',	'LOC_DISTRICT_DISTRICT_1_CULTURE'),
	-- ('BUILDING_UFFIZI_COMMERCIAL_DISTRICT_ADJACENCY',	'DistrictType',	'DISTRICT_COMMERCIAL_HUB'),
	-- ('BUILDING_UFFIZI_COMMERCIAL_DISTRICT_ADJACENCY',	'YieldType',	'YIELD_GOLD'),	
	-- ('BUILDING_UFFIZI_COMMERCIAL_DISTRICT_ADJACENCY',	'Amount',		1),
	-- ('BUILDING_UFFIZI_COMMERCIAL_DISTRICT_ADJACENCY',	'Description',	'LOC_DISTRICT_DISTRICT_1_GOLD'),
	-- ('BUILDING_UFFIZI_THEATER_ADJACENT_COMMERCIAL_ADJACENCY_MODIFIER',			'YieldType',	'YIELD_CULTURE'),
	-- ('BUILDING_UFFIZI_THEATER_ADJACENT_COMMERCIAL_ADJACENCY_MODIFIER',			'Amount',		50),
	-- ('BUILDING_UFFIZI_COMMERCIAL_ADJACENT_THEATER_ADJACENCY_MODIFIER',			'YieldType',	'YIELD_GOLD'),
	-- ('BUILDING_UFFIZI_COMMERCIAL_ADJACENT_THEATER_ADJACENCY_MODIFIER',			'Amount',		50),
	('BUILDING_UFFIZI_THEATER_ADJACENT',							'ModifierId',	'BUILDING_UFFIZI_THEATER_ADJACENT_MODIFIER'),
	('BUILDING_UFFIZI_THEATER_ADJACENT_MODIFIER',			'YieldType',	'YIELD_CULTURE'),
	('BUILDING_UFFIZI_THEATER_ADJACENT_MODIFIER',			'Amount',		50);

-- insert or ignore into RequirementSets
--     (RequirementSetId,                                  RequirementSetType)
-- values
--     ('DISTRICT_IS_THEATER_AND_ADJACENT_TO_COMMERCIAL',  'REQUIREMENTSET_TEST_ALL'),
-- 	('DISTRICT_IS_COMMERCIAL_AND_ADJACENT_TO_THEATER',  'REQUIREMENTSET_TEST_ALL');

-- insert or ignore into RequirementSetRequirements
--     (RequirementSetId,                                  RequirementId)
-- values
--     ('DISTRICT_IS_THEATER_AND_ADJACENT_TO_COMMERCIAL',  'REQUIRES_DISTRICT_IS_DISTRICT_THEATER'),
--     ('DISTRICT_IS_THEATER_AND_ADJACENT_TO_COMMERCIAL',  'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_COMMERCIAL_HUB_RAW'),
-- 	('DISTRICT_IS_COMMERCIAL_AND_ADJACENT_TO_THEATER',  'REQUIRES_DISTRICT_IS_DISTRICT_COMMERCIAL_HUB'),
--     ('DISTRICT_IS_COMMERCIAL_AND_ADJACENT_TO_THEATER',  'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_THEATER_RAW');

-- uffizi theming bonus when art are same kinds(i.e. all portrait) 
update Building_GreatWorks set 
	ThemingUniquePerson = 0,
	ThemingSameObjectType = 1,
	ThemingSameEras = 0,
	ThemingTourismMultiplier = 100,
	ThemingYieldMultiplier = 100,
	NonUniquePersonYield = 1,
	NonUniquePersonTourism = 1
where BuildingType = 'BUILDING_UFFIZI';
-- uffizi +3 great artist (need to assigin era)
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_BOTTICELLI_1';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_BOTTICELLI_2';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_BOTTICELLI_3';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_RAPHAEL_1';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_RAPHAEL_2';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_RAPHAEL_3';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_CARAVAGGIO_1';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_CARAVAGGIO_2';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_CARAVAGGIO_3';
------------------------------------------------------------------------------------------------------------
-----圣母院------------------------------------------------------------------------------------
update Buildings set Entertainment = 0, RegionalRange = 0, PrereqCivic = null, PrereqTech = 'TECH_ARCH_HD', AdjacentDistrict = NULL,
	Description = 'LOC_BUILDING_SUK_NOTRE_DAME_DE_PARIS_HD_DESCRIPTION'
	where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS';
insert or replace into GlobalParameters (Name, Value) values
	('HD_NOTRE_DAME_CIVIC_BOOST_PERCENTAGE', 5);

delete from Building_GreatWorks where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS';
insert or replace into Building_GreatWorks (BuildingType,	GreatWorkSlotType,	NumSlots, NonUniquePersonYield, NonUniquePersonTourism)
select 'BUILDING_SUK_NOTRE_DAME_DE_PARIS', 'GREATWORKSLOT_MUSIC', 3, 1, 1
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS');

delete from Building_GreatPersonPoints where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS';
insert or replace into Building_GreatPersonPoints (BuildingType,	GreatPersonClassType,	PointsPerTurn)
select 'BUILDING_SUK_NOTRE_DAME_DE_PARIS', 'GREAT_PERSON_CLASS_MUSICIAN', 1
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS');

insert or replace into Building_YieldChanges (BuildingType,	YieldType, YieldChange)
select 'BUILDING_SUK_NOTRE_DAME_DE_PARIS', 'YIELD_FAITH', 2
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS');
insert or replace into Building_YieldChanges (BuildingType,	YieldType, YieldChange)
select 'BUILDING_SUK_NOTRE_DAME_DE_PARIS', 'YIELD_CULTURE', 2
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS');

delete from BuildingModifiers where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS';
insert or replace into BuildingModifiers (BuildingType,	ModifierId)
select 'BUILDING_SUK_NOTRE_DAME_DE_PARIS', 'NOTRE_DAME_HOLY_SITE_ADJACENT_THEATER_ADJACENCY'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS');
insert or replace into Modifiers (ModifierId,	ModifierType,	SubjectRequirementSetId)
select 'NOTRE_DAME_HOLY_SITE_ADJACENT_THEATER_ADJACENCY',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',	'DISTRICT_IS_HOLY_SITE_AND_ADJACENT_TO_THEATER'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS');
insert or replace into ModifierArguments (ModifierId,	Name,	Value)
select 'NOTRE_DAME_HOLY_SITE_ADJACENT_THEATER_ADJACENCY',	'YieldType',	'YIELD_FAITH'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS');
insert or replace into ModifierArguments (ModifierId,	Name,	Value)
select 'NOTRE_DAME_HOLY_SITE_ADJACENT_THEATER_ADJACENCY',	'Amount',	100
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS');
------------------------------------------------------------------------------------------------------------
------BUILDING_GLOBE_THEATRE--------------------------------------------------------------------------------
UPDATE Buildings SET  ObsoleteEra = 'ERA_MODERN', RegionalRange = 6, Entertainment = 0
WHERE BuildingType = 'BUILDING_GLOBE_THEATRE' AND EXISTS (SELECT BuildingType FROM Buildings WHERE BuildingType = 'BUILDING_GLOBE_THEATRE');

update Building_YieldChanges set YieldChange = 8 where BuildingType = 'BUILDING_GLOBE_THEATRE';
insert or ignore into Building_ValidTerrains (BuildingType, TerrainType)
select 'BUILDING_GLOBE_THEATRE', 'TERRAIN_DESERT' where exists (SELECT BuildingType FROM Buildings WHERE BuildingType = 'BUILDING_GLOBE_THEATRE');

insert or replace into BuildingModifiers (BuildingType, ModifierId)
select	'BUILDING_GLOBE_THEATRE', 'GLOBE_THEATRE_CITY_WRITING_TOURISM'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_GLOBE_THEATRE');

insert or replace into Modifiers
	(ModifierId, 							ModifierType,				 						SubjectRequirementSetId) 
values
	('GLOBE_THEATRE_CITY_WRITING_TOURISM',	'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',				NULL);

insert or replace into ModifierArguments 
	(ModifierId,							Name,					Value) 
values
	('GLOBE_THEATRE_CITY_WRITING_TOURISM',	'GreatWorkObjectType',	'GREATWORKOBJECT_WRITING'),	
	('GLOBE_THEATRE_CITY_WRITING_TOURISM',	'ScalingFactor',		200);

delete from BuildingModifiers where ModifierId = 'GLOBE_THEATRE_AMPHITHEATER_AMENITY_MODIFIER';
-- globe theter +3 great writer (need to assign era)
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_JOHN_DONNE_1';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_JOHN_DONNE_2';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_MOLIERE_1';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_MOLIERE_2';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_DANTE_1';
update GreatWorks set EraType = 'ERA_RENAISSANCE'	where GreatWorkType = 'GREATWORK_CWON_DANTE_2';
-------------------------------------------------------------------------------------------------------------
-------P0K_BUILDING_TEMPLE_POSEIDON--------------------------------------------------------------------------
update Buildings set ObsoleteEra = 'ERA_MEDIEVAL' where BuildingType = 'P0K_BUILDING_TEMPLE_POSEIDON';
update Building_YieldChanges set YieldChange = 6 where BuildingType = 'P0K_BUILDING_TEMPLE_POSEIDON' and YieldType = 'YIELD_FOOD';
------------------------------------------------------------------------------------------------------------------

--BUILDING_ITSUKUSHIMA
update Buildings set PrereqTech = 'TECH_CELESTIAL_NAVIGATION' where BuildingType = 'BUILDING_ITSUKUSHIMA';
update ModifierArguments set Value = 1 where ModifierId = 'ITSUKUSHIMA_THEATER_COAST_CULTURE' and Name = 'TilesRequired';
update ModifierArguments set Value = 1 where ModifierId = 'ITSUKUSHIMA_HOLY_SITE_COAST_FAITH' and Name = 'Amount';
delete from BuildingModifiers where BuildingType = 'BUILDING_ITSUKUSHIMA' and ModifierId = 'ITSUKUSHIMA_GRANT_MONUMENT';

--BUILDING_TOWER_BRIDGE
update Buildings set PrereqCivic = 'CIVIC_URBAN_DESIGN_HD', PrereqTech = Null where BuildingType = 'BUILDING_TOWER_BRIDGE';
delete from BuildingModifiers where BuildingType = 'BUILDING_TOWER_BRIDGE'
	and (ModifierId = 'TOWER_BRIDGE_GRANT_COAL_PER_TURN' or ModifierId = 'TOWER_BRIDGE_CITIES_PRODUCTION' or ModifierId = 'TOWER_BRIDGE_CITIES_GOLD');

--BUILDING_BRANDENBURG_GATE
update Buildings set PrereqCivic = 'CIVIC_NATIONALISM', PrereqTech = null where BuildingType = 'BUILDING_BRANDENBURG_GATE';
insert or replace into Building_YieldChanges (BuildingType, YieldType, YieldChange)
select 'BUILDING_BRANDENBURG_GATE', 'YIELD_SCIENCE', 2 from Buildings where BuildingType = 'BUILDING_BRANDENBURG_GATE';
insert or replace into Building_YieldChanges (BuildingType, YieldType, YieldChange)
select 'BUILDING_BRANDENBURG_GATE', 'YIELD_PRODUCTION', 2 from Buildings where BuildingType = 'BUILDING_BRANDENBURG_GATE';

insert or ignore into Building_ValidTerrains (BuildingType, TerrainType)
select 'BUILDING_BRANDENBURG_GATE', 'TERRAIN_SNOW' where exists (SELECT BuildingType FROM Buildings WHERE BuildingType = 'BUILDING_BRANDENBURG_GATE');

delete from BuildingModifiers where BuildingType = 'BUILDING_BRANDENBURG_GATE' and ModifierId = 'BRANDENBURG_GATE_TRAINED_UNIT_XP_MODIFIER';
delete from BuildingModifiers where BuildingType = 'BUILDING_BRANDENBURG_GATE' and ModifierId = 'BRANDENBURG_GRANT_GENERAL';
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_BRANDENBURG_GATE',	'BRANDENBURG_GATE_PRODUCTION_AT_PEACE_BONUS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BRANDENBURG_GATE');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_BRANDENBURG_GATE',	'BRANDENBURG_GATE_SCIENCE_AT_WAR_BONUS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BRANDENBURG_GATE');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_BRANDENBURG_GATE',	'BRANDENBURG_GARRISON_LOYALTY'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BRANDENBURG_GATE');

insert or replace into Modifiers 
	(ModifierId,									ModifierType,											SubjectRequirementSetId) 
values
	('BRANDENBURG_GATE_PRODUCTION_AT_PEACE_BONUS',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'PLAYER_IS_AT_PEACE_WITH_ALL_MAJORS'),
	('BRANDENBURG_GATE_SCIENCE_AT_WAR_BONUS',		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'PLAYER_IS_AT_WAR_WITH_ANY_MAJOR'),
	('BRANDENBURG_GARRISON_LOYALTY',				'MODIFIER_PLAYER_CITIES_ADJUST_IDENTITY_PER_TURN',		'CITY_HAS_GARRISON_UNIT_REQUIERMENT');

insert or replace into ModifierArguments 
	(ModifierId,								Name,			Value) 
values
	('BRANDENBURG_GATE_PRODUCTION_AT_PEACE_BONUS', 	'YieldType',	'YIELD_PRODUCTION'),
	('BRANDENBURG_GATE_PRODUCTION_AT_PEACE_BONUS',	'Amount',		8),
	('BRANDENBURG_GATE_SCIENCE_AT_WAR_BONUS', 		'YieldType',	'YIELD_SCIENCE'),
	('BRANDENBURG_GATE_SCIENCE_AT_WAR_BONUS',		'Amount',		8),
	('BRANDENBURG_GARRISON_LOYALTY',				'Amount',		3);

--BUILDING_BOROBUDUR
update Buildings set PrereqCivic = 'CIVIC_THEOLOGY', RequiresReligion = 0 where BuildingType = 'BUILDING_BOROBUDUR';

delete from BuildingModifiers where BuildingType = 'BUILDING_BOROBUDUR';
delete from BuildingPrereqs where Building = 'BUILDING_BOROBUDUR';-- and PrereqBuilding = 'BUILDING_TEMPLE';

insert or replace into Building_RequiredFeatures (BuildingType,	FeatureType) select
	'BUILDING_BOROBUDUR',	'FEATURE_VOLCANIC_SOIL'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BOROBUDUR');
	
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_BOROBUDUR',	'HD_BOROBUDUR_CITY_FAITH'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BOROBUDUR');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_BOROBUDUR',	'HD_BOROBUDUR_DISTRICT_CULTURE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BOROBUDUR');

insert or replace into Building_GreatWorks (BuildingType, GreatWorkSlotType, NumSlots)
	select 'BUILDING_BOROBUDUR', 'GREATWORKSLOT_RELIC', 2 where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BOROBUDUR');

insert or replace into Modifiers 
	(ModifierId,																					ModifierType,																				SubjectRequirementSetId) 
values
	('HD_BOROBUDUR_CITY_FAITH',														'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER','HD_BOROBUDUR_CITY_REQUIREMENTS'),
	('HD_BOROBUDUR_DISTRICT_CULTURE',											'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		'HD_BOROBUDUR_DISTRICT_REQUIREMENTS'),
	('HD_BOROBUDUR_VOLCANIC_SOIL_YIELD',									'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								'HD_PLOT_HAS_FEATURE_VOLCANIC_SOIL');

insert or replace into Modifiers 
	(ModifierId,											ModifierType,										RunOnce,  Permanent) 
values
	('HD_BOROBUDUR_GRANT_RELIC',			'MODIFIER_PLAYER_GRANT_RELIC',	1,				1);

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
	'HD_BOROBUDUR_RELIC_TOURISM', 'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM', 'CITY_HAS_BUILDING_BOROBUDUR_REQUIREMENTS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BOROBUDUR');

insert or replace into ModifierArguments 
	(ModifierId,																					Name,									Value) 
values
	('HD_BOROBUDUR_CITY_FAITH',														'YieldType',					'YIELD_FAITH'),
	('HD_BOROBUDUR_CITY_FAITH',														'Amount',							10),
	('HD_BOROBUDUR_DISTRICT_CULTURE',											'YieldType',					'YIELD_CULTURE'),
	('HD_BOROBUDUR_DISTRICT_CULTURE',											'Amount',							2),
	('HD_BOROBUDUR_VOLCANIC_SOIL_YIELD',									'YieldType',					'YIELD_FOOD,YIELD_CULTURE,YIELD_FAITH'),
	('HD_BOROBUDUR_VOLCANIC_SOIL_YIELD',									'Amount',							'1,1,1'),
	('HD_BOROBUDUR_GRANT_RELIC',													'Amount',							1);

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_BOROBUDUR_RELIC_TOURISM', 'ScalingFactor', 150
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BOROBUDUR');

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_BOROBUDUR_RELIC_TOURISM', 'GreatWorkObjectType','GREATWORKOBJECT_RELIC'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BOROBUDUR');

insert or replace into GlobalParameters
	(Name,																	Value)
values
	('HD_BOROBUDUR_EXCAVATE_MAX_TIMES',			3),
	('HD_BOROBUDUR_EXCAVATE_GOLD',					100),
	('HD_BOROBUDUR_EXCAVATE_FAITH',					60),
	('HD_BOROBUDUR_EXCAVATE_CULTURE',				50),
	('HD_BOROBUDUR_EXCAVATE_RESOURCE_PROB',	0.5),
	('HD_BOROBUDUR_EXCAVATE_RELIC_PROB',		0.1);

-- BUILDING_MOTHERLAND_CALLS
update Buildings set PrereqCivic = 'CIVIC_MOBILIZATION' where BuildingType = 'BUILDING_MOTHERLAND_CALLS';
update Modifiers set SubjectRequirementSetId = 'JANISSARY_CITY_FOUNDED' where ModifierId = 'MOTHERLANDCALLS_IDENTITY';
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_MOTHERLAND_CALLS',	'MOTHERLAND_CALLS_OWNER_TERRITORY_COMBAT_STRENGTH'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_MOTHERLAND_CALLS');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_MOTHERLAND_CALLS',	'MOTHERLAND_CALLS_GOLDEN_SCIENCE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_MOTHERLAND_CALLS');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_MOTHERLAND_CALLS',	'MOTHERLAND_CALLS_GOLDEN_CULTURE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_MOTHERLAND_CALLS');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_MOTHERLAND_CALLS',	'MOTHERLAND_CALLS_NORMAL_FOOD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_MOTHERLAND_CALLS');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_MOTHERLAND_CALLS',	'MOTHERLAND_CALLS_NORMAL_PRODUCTION'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_MOTHERLAND_CALLS');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_MOTHERLAND_CALLS',	'MOTHERLAND_CALLS_DARK_FOOD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_MOTHERLAND_CALLS');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'BUILDING_MOTHERLAND_CALLS',	'MOTHERLAND_CALLS_DARK_PRODUCTION'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_MOTHERLAND_CALLS');

insert or replace into Modifiers
	(ModifierId,											ModifierType,												SubjectRequirementSetId,					OwnerRequirementSetId) 
values
	('MOTHERLAND_CALLS_OWNER_TERRITORY_COMBAT_STRENGTH',	'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',						NULL,										NULL),
	('OWN_TERRITORY_COMBAT_STRENGTH_BUFF',					'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',						'HD_UNIT_IN_OWNER_TERRITORY_REQUIREMENTS',	NULL),
	('MOTHERLAND_CALLS_GOLDEN_SCIENCE',						'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',		'HD_OBJECT_WITHIN_9_TILES',					'PLAYER_HAS_GOLDEN_AGE'),
	('MOTHERLAND_CALLS_GOLDEN_CULTURE',						'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',		'HD_OBJECT_WITHIN_9_TILES',					'PLAYER_HAS_GOLDEN_AGE'),
	('MOTHERLAND_CALLS_NORMAL_FOOD',						'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',		'HD_OBJECT_WITHIN_9_TILES',					'PLAYER_NOT_HAS_GOLDEN_AGE'),
	('MOTHERLAND_CALLS_NORMAL_PRODUCTION',					'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',		'HD_OBJECT_WITHIN_9_TILES',					'PLAYER_NOT_HAS_GOLDEN_AGE'),
	('MOTHERLAND_CALLS_DARK_FOOD',							'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',		'HD_OBJECT_WITHIN_9_TILES',					'PLAYER_HAS_DARK_AGE'),
	('MOTHERLAND_CALLS_DARK_PRODUCTION',					'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',		'HD_OBJECT_WITHIN_9_TILES',					'PLAYER_HAS_DARK_AGE');

insert or replace into ModifierArguments
	(ModifierId,											Name,					Value) 
values
	('MOTHERLAND_CALLS_OWNER_TERRITORY_COMBAT_STRENGTH',	'AbilityType',			'ABILITY_MOTHERLAND_CALLS_OWN_TERRITORY'),
	('OWN_TERRITORY_COMBAT_STRENGTH_BUFF',					'Amount',				10),
	('MOTHERLAND_CALLS_GOLDEN_SCIENCE',						'YieldType',			'YIELD_SCIENCE'),
	('MOTHERLAND_CALLS_GOLDEN_SCIENCE',						'Amount',				7),
	('MOTHERLAND_CALLS_GOLDEN_CULTURE',						'YieldType',			'YIELD_CULTURE'),
	('MOTHERLAND_CALLS_GOLDEN_CULTURE',						'Amount',				7),
	('MOTHERLAND_CALLS_NORMAL_FOOD',						'YieldType',			'YIELD_FOOD'),
	('MOTHERLAND_CALLS_NORMAL_FOOD',						'Amount',				7),
	('MOTHERLAND_CALLS_NORMAL_PRODUCTION',					'YieldType',			'YIELD_PRODUCTION'),
	('MOTHERLAND_CALLS_NORMAL_PRODUCTION',					'Amount',				7),
	('MOTHERLAND_CALLS_DARK_FOOD',							'YieldType',			'YIELD_FOOD'),
	('MOTHERLAND_CALLS_DARK_FOOD',							'Amount',				7),
	('MOTHERLAND_CALLS_DARK_PRODUCTION',					'YieldType',			'YIELD_PRODUCTION'),
	('MOTHERLAND_CALLS_DARK_PRODUCTION',					'Amount',				7);

insert or replace into ModifierStrings
	(ModifierId,											Context,		Text) 
values
	('OWN_TERRITORY_COMBAT_STRENGTH_BUFF',					'Preview',		'LOC_OWN_TERRITORY_COMBAT_STRENGTH_BUFF_PREVIEW_TEXT');

-- Ability
insert or replace into Types
	(Type,													Kind)
values
	('ABILITY_MOTHERLAND_CALLS_OWN_TERRITORY',				'KIND_ABILITY');

insert or replace into TypeTags	
	(Type,													Tag)
values
 	('ABILITY_MOTHERLAND_CALLS_OWN_TERRITORY',				'CLASS_MILITARY');

insert or replace into UnitAbilities (UnitAbilityType, Name, Description, Inactive) values
	('ABILITY_MOTHERLAND_CALLS_OWN_TERRITORY',
	'LOC_ABILITY_MOTHERLAND_CALLS_OWN_TERRITORY_NAME',
 	'LOC_ABILITY_MOTHERLAND_CALLS_OWN_TERRITORY_DESCRIPTION',
 	1);

insert or replace into UnitAbilityModifiers
	(UnitAbilityType,									ModifierId)
values
	('ABILITY_MOTHERLAND_CALLS_OWN_TERRITORY',			'OWN_TERRITORY_COMBAT_STRENGTH_BUFF');

-- WON_CL_KINKAKU 金阁寺
insert or replace into Building_YieldChanges (BuildingType, YieldType, YieldChange)
select 'WON_CL_KINKAKU', 'YIELD_FAITH', 2 from Buildings where BuildingType = 'WON_CL_KINKAKU';
insert or replace into Building_YieldChanges (BuildingType, YieldType, YieldChange)
select 'WON_CL_KINKAKU', 'YIELD_PRODUCTION', 2 from Buildings where BuildingType = 'WON_CL_KINKAKU';
update Buildings set PrereqCivic = 'CIVIC_DIVINE_RIGHT', PrereqTech = NULL where BuildingType = 'WON_CL_KINKAKU';

insert or replace into Building_GreatWorks (BuildingType, GreatWorkSlotType, NumSlots)
select 'WON_CL_KINKAKU', 'GREATWORKSLOT_CATHEDRAL', 1
where exists (select BuildingType from Buildings where BuildingType = 'WON_CL_KINKAKU');

delete from BuildingModifiers where BuildingType = 'WON_CL_KINKAKU';

insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'WON_CL_KINKAKU',	'KINKAKU_RANGE_HOLYSITE_PRODUCTION'
where exists (select BuildingType from Buildings where BuildingType = 'WON_CL_KINKAKU');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'WON_CL_KINKAKU',	'KINKAKU_GRANT_RELIC'
where exists (select BuildingType from Buildings where BuildingType = 'WON_CL_KINKAKU');

insert or replace into Modifiers 
	(ModifierId,														ModifierType,																												SubjectRequirementSetId) 
values
	('KINKAKU_RANGE_HOLYSITE_PRODUCTION',		'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',	'HD_PLOT_HAS_DISTRICT_HOLY_SITE_TIER_2_BUILDING_REQUIREMENTS'),
	('KINKAKU_GRANT_RELIC',									'MODIFIER_PLAYER_GRANT_RELIC',																			Null);

update Modifiers set RunOnce = 1, Permanent = 1 where ModifierId = 'KINKAKU_GRANT_RELIC';

insert or replace into ModifierArguments 
	(ModifierId,														Name,									Value) 
values
	('KINKAKU_RANGE_HOLYSITE_PRODUCTION', 	'YieldTypeToMirror',	'YIELD_FAITH'),
	('KINKAKU_RANGE_HOLYSITE_PRODUCTION',		'YieldTypeToGrant',		'YIELD_PRODUCTION'),
	('KINKAKU_GRANT_RELIC',									'Amount',							1);

-- CL_BUILDING_CN_TOWER
delete from BuildingModifiers where BuildingType = 'CL_BUILDING_CN_TOWER' and ModifierId != 'CL_GRANT_BROADCAST';
-- update Buildings set AdjacentDistrict = NULL where BuildingType = 'CL_BUILDING_CN_TOWER';

insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'CL_BUILDING_CN_TOWER',	'CN_TOWER_ALL_CITY_POP'
where exists (select BuildingType from Buildings where BuildingType = 'CL_BUILDING_CN_TOWER');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'CL_BUILDING_CN_TOWER',	'CN_TOWER_ALL_CITY_HOUSING'
where exists (select BuildingType from Buildings where BuildingType = 'CL_BUILDING_CN_TOWER');
-- insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
-- 	'CL_BUILDING_CN_TOWER',	'CN_TOWER_ALL_CITY_AMENITY'
-- where exists (select BuildingType from Buildings where BuildingType = 'CL_BUILDING_CN_TOWER');
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'CL_BUILDING_CN_TOWER',	'CN_TOWER_MUSIC_TOURISM'
where exists (select BuildingType from Buildings where BuildingType = 'CL_BUILDING_CN_TOWER');

	-- Product
insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
	'CL_BUILDING_CN_TOWER',	'CN_TOWER_PRODUCT_TOURISM'
where exists (select BuildingType from Buildings where BuildingType = 'CL_BUILDING_CN_TOWER')
  and exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');
update Buildings set Description = 'LOC_CL_BUILDING_CN_TOWER_DESCRIPTION_CORP' where BuildingType = 'CL_BUILDING_CN_TOWER'
	and exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');
insert or replace into Modifiers 
	(ModifierId,					ModifierType,								SubjectRequirementSetId) 
select
	'CN_TOWER_PRODUCT_TOURISM',		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'HD_CITY_HAS_BROADCAST_AND_POWERED'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');
insert or replace into ModifierArguments 
	(ModifierId,					Name,		Value) 
select
	'CN_TOWER_PRODUCT_TOURISM',		'GreatWorkObjectType',	'GREATWORKOBJECT_PRODUCT'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');
insert or replace into ModifierArguments 
	(ModifierId,					Name,		Value) 
select
	'CN_TOWER_PRODUCT_TOURISM',		'ScalingFactor',	300
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into Building_GreatWorks
	(BuildingType,			GreatWorkSlotType,		NumSlots,ThemingUniquePerson,ThemingYieldMultiplier,ThemingTourismMultiplier,ThemingBonusDescription)
select
	'CL_BUILDING_CN_TOWER',	'GREATWORKSLOT_MUSIC',	4,		 1,					 200,					200,					 'LOC_BUILDING_THEMINGBONUS_CN_TOWER'
where exists (select BuildingType from Buildings where BuildingType = 'CL_BUILDING_CN_TOWER');

insert or replace into Modifiers 
	(ModifierId,					ModifierType,							RunOnce,	Permanent,	SubjectRequirementSetId) 
values
	('CN_TOWER_ALL_CITY_POP',		'MODIFIER_PLAYER_CITIES_ADD_POPULATION',	1,		1,			NULL),
	('CN_TOWER_MUSIC_TOURISM',		'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	0,		0,			'HD_CITY_HAS_BROADCAST_AND_POWERED');

insert or replace into Modifiers 
	(ModifierId,					ModifierType) 
values
	('CN_TOWER_ALL_CITY_HOUSING',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_HOUSING');
	-- ('CN_TOWER_ALL_CITY_AMENITY',	'MODIFIER_PLAYER_CITIES_ADJUST_POLICY_AMENITY');

insert or replace into ModifierArguments 
	(ModifierId,					Name,		Value) 
values
	('CN_TOWER_ALL_CITY_POP',		'Amount',	2),
	('CN_TOWER_ALL_CITY_HOUSING',	'Amount',	2),
	-- ('CN_TOWER_ALL_CITY_AMENITY', 	'Amount',	1),
	('CN_TOWER_MUSIC_TOURISM',		'GreatWorkObjectType',	'GREATWORKOBJECT_MUSIC'),
	('CN_TOWER_MUSIC_TOURISM',	 	'ScalingFactor',		300);

-- Yellow Crane Tower
insert or replace into Types
	(Type, 			Kind)
select
	Type || '_HD', 	Kind
from Types where Type = 'BUILDING_YELLOW_CRANE';
insert or replace into Buildings
	(BuildingType, 			Name, Description, Cost,	AdvisorType, MaxWorldInstances, IsWonder, RequiresPlacement, RequiresRiver, Quote, PrereqCivic)
select
	BuildingType || '_HD',	Name, Description, 420,		AdvisorType, MaxWorldInstances, IsWonder, RequiresPlacement, RequiresRiver, Quote, 'CIVIC_LITERARY_TRADITION_HD'
from Buildings where BuildingType = 'BUILDING_YELLOW_CRANE';
insert or replace into Building_ValidTerrains
	(BuildingType, 			TerrainType)
select
	BuildingType || '_HD', 	TerrainType
from Building_ValidTerrains where BuildingType = 'BUILDING_YELLOW_CRANE';
insert or replace into Building_GreatPersonPoints
	(BuildingType, 			GreatPersonClassType, PointsPerTurn)
select
	BuildingType || '_HD',	GreatPersonClassType, PointsPerTurn
from Building_GreatPersonPoints where BuildingType = 'BUILDING_YELLOW_CRANE';
insert or replace into Building_GreatWorks
	(BuildingType,			GreatWorkSlotType,	NumSlots,	NonUniquePersonYield,	NonUniquePersonTourism)
select
	BuildingType || '_HD', 	GreatWorkSlotType,	2,			1,						1
from Building_GreatWorks where BuildingType = 'BUILDING_YELLOW_CRANE';
insert or replace into Building_YieldChanges
	(BuildingType,					YieldType,			YieldChange)
select
	BuildingType || '_HD',			'YIELD_CULTURE',	2
from Buildings where BuildingType = 'BUILDING_YELLOW_CRANE';
delete from Types where Type = 'BUILDING_YELLOW_CRANE';
insert or replace into GlobalParameters (Name, Value) values ('YELLOW_CRANE_TOWER_POINT_PERCENTAGE', 15);
insert or replace into Modifiers
	(ModifierId,										ModifierType)
select
	'YELLOW_CRANE_WRITER_' || EraType || '_BOOST',		'MODIFIER_PLAYER_GRANT_RANDOM_CIVIC_BOOST_BY_ERA'
from Eras;
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'YELLOW_CRANE_WRITER_' || EraType || '_BOOST',		'StartEraType',		EraType
from Eras;
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'YELLOW_CRANE_WRITER_' || EraType || '_BOOST',		'EndEraType',		EraType
from Eras;
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'YELLOW_CRANE_WRITER_' || EraType || '_BOOST',		'Amount',			1
from Eras;

-- 圣彼得大教堂
insert or replace into Building_YieldChanges (BuildingType, YieldType, YieldChange)
select 'BUILDING_AL_STPETERSBASILICA', 'YIELD_CULTURE', 2 from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA';
insert or replace into Building_YieldChanges (BuildingType, YieldType, YieldChange)
select 'BUILDING_AL_STPETERSBASILICA', 'YIELD_FAITH', 2 from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA';

delete from Building_GreatWorks where BuildingType = 'BUILDING_AL_STPETERSBASILICA' and GreatWorkSlotType = 'GREATWORKSLOT_RELIC';
update Building_GreatWorks set 
	GreatWorkSlotType = 'GREATWORKSLOT_ART',
	NumSlots = 4,
	ThemingUniquePerson = 0,
	ThemingSameObjectType = 1,
	ThemingSameEras = 0,
	ThemingTourismMultiplier = 100,
	ThemingYieldMultiplier = 100,
	NonUniquePersonYield = 1,
	NonUniquePersonTourism = 1
where BuildingType ='BUILDING_AL_STPETERSBASILICA' and GreatWorkSlotType = 'GREATWORKSLOT_CATHEDRAL';

delete from BuildingModifiers where BuildingType = 'BUILDING_AL_STPETERSBASILICA';

	-- 大艺点
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
	'BUILDING_AL_STPETERSBASILICA', 'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT_ATTACH'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
	'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT_ATTACH', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'CITY_FOLLOWS_RELIGION_REQUIREMENTS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA');
insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT_ATTACH', 'ModifierId', 'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT_BACK'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
	'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT_BACK', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'REQ_SET_CL_CITY_HAS_STPETERSBASILICA'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA');
insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT_BACK', 'ModifierId', 'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
	'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT', 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', 'REQUIRES_DISTRICT_IS_DISTRICT_CITY_CENTER_UDMET'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA');
insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_ARTIST'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA');
insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_AL_STPETERSBASILICA_GREAT_ARTIST_POINT', 'Amount', 4
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_AL_STPETERSBASILICA');

insert or replace into GlobalParameters (Name, Value) values
	('HD_AL_STPETERSBASILICA_YIELD_SCIENCE_PER_POP',	10),
	('HD_AL_STPETERSBASILICA_YIELD_CULTURE_PER_POP',	10),
	('HD_AL_STPETERSBASILICA_YIELD_FAITH_PER_POP',		15),
	('HD_AL_STPETERSBASILICA_YIELD_GOLD_PER_POP',			30);

-- 帝国大厦
update Buildings set PrereqCivic = 'CIVIC_CAPITALISM' where BuildingType = 'WON_CL_EMPIRE_STATES';
update ModifierArguments set Value = 300 where ModifierId = 'EMPIRE_CITY_WONDER_TOURISM' and Name = 'ScalingFactor';

-- 三峡大坝
update ModifierArguments set Value = 6 where ModifierId = 'THREE_GORDES_DAM_POWER_ORIGIN_MODIFIER' and Name = 'Amount';
delete from BuildingModifiers where BuildingType = 'BUILDING_THREE_GORDES_DAM' and ModifierId = 'THREE_GORDES_DAM_POWER_SPREAD';
delete from BuildingModifiers where BuildingType = 'BUILDING_THREE_GORDES_DAM' and ModifierId = 'THREE_GORDES_DAM_POWER_SUPERSPREAD';
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
	'BUILDING_THREE_GORDES_DAM', 'THREE_GORDES_DAM_DAM_GREAT_ENGINEER_POINT'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_THREE_GORDES_DAM');
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
	'BUILDING_THREE_GORDES_DAM', 'THREE_GORDES_DAM_HYDROELECTRIC_DAM_GREAT_ENGINEER_POINT'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_THREE_GORDES_DAM');
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
	'BUILDING_THREE_GORDES_DAM', 'THREE_GORDES_DAM_POPULATION_FOOD'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_THREE_GORDES_DAM');
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
	'BUILDING_THREE_GORDES_DAM', 'THREE_GORDES_DAM_POPULATION_PRODUCTION'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_THREE_GORDES_DAM');

insert or replace into Modifiers
	(ModifierId,														ModifierType,												SubjectRequirementSetId)
values
	('THREE_GORDES_DAM_DAM_GREAT_ENGINEER_POINT',						'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',				'DISTRICT_IS_DISTRICT_DAM_REQUIREMENTS'),
	('THREE_GORDES_DAM_DAM_GREAT_ENGINEER_POINT_MODIFIER',				'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',		NULL),
	('THREE_GORDES_DAM_HYDROELECTRIC_DAM_GREAT_ENGINEER_POINT',			'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',					'CITY_HAS_BUILDING_HYDROELECTRIC_DAM_REQUIREMENTS'),
	('THREE_GORDES_DAM_HYDROELECTRIC_DAM_GREAT_ENGINEER_POINT_MODIFIER','MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',		NULL),
	('THREE_GORDES_DAM_POPULATION_FOOD',								'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_POPULATION',	'CITY_HAS_DISTRICT_DAM_REQUIREMENTS'),
	('THREE_GORDES_DAM_POPULATION_PRODUCTION',							'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_POPULATION',	'CITY_HAS_DISTRICT_DAM_REQUIREMENTS'),
	('THREE_GORDES_DAM_RIVER_IMPROVEMENT_FOOD',							'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',						'PLOT_HAS_IMPROVEMENT_ADJACENT_TO_RIVER'),
	('THREE_GORDES_DAM_RIVER_IMPROVEMENT_PRODUCTION',					'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',						'PLOT_HAS_IMPROVEMENT_ADJACENT_TO_RIVER');
insert or replace into ModifierArguments
	(ModifierId,														Name,			Value)
values
	('THREE_GORDES_DAM_DAM_GREAT_ENGINEER_POINT',						'ModifierId',	'THREE_GORDES_DAM_DAM_GREAT_ENGINEER_POINT_MODIFIER'),
	('THREE_GORDES_DAM_DAM_GREAT_ENGINEER_POINT_MODIFIER',				'GreatPersonClassType',	'GREAT_PERSON_CLASS_ENGINEER'),
	('THREE_GORDES_DAM_DAM_GREAT_ENGINEER_POINT_MODIFIER',				'Amount',				20),
	('THREE_GORDES_DAM_HYDROELECTRIC_DAM_GREAT_ENGINEER_POINT',			'ModifierId',	'THREE_GORDES_DAM_HYDROELECTRIC_DAM_GREAT_ENGINEER_POINT_MODIFIER'),
	('THREE_GORDES_DAM_HYDROELECTRIC_DAM_GREAT_ENGINEER_POINT_MODIFIER','GreatPersonClassType',	'GREAT_PERSON_CLASS_ENGINEER'),
	('THREE_GORDES_DAM_HYDROELECTRIC_DAM_GREAT_ENGINEER_POINT_MODIFIER','Amount',				20),
	('THREE_GORDES_DAM_POPULATION_FOOD',								'YieldType',	'YIELD_FOOD'),
	('THREE_GORDES_DAM_POPULATION_FOOD',								'Amount',		0.5),
	('THREE_GORDES_DAM_POPULATION_PRODUCTION',							'YieldType',	'YIELD_PRODUCTION'),
	('THREE_GORDES_DAM_POPULATION_PRODUCTION',							'Amount',		0.5),
	('THREE_GORDES_DAM_RIVER_IMPROVEMENT_FOOD',							'YieldType',	'YIELD_FOOD'),
	('THREE_GORDES_DAM_RIVER_IMPROVEMENT_FOOD',							'Amount',		1),
	('THREE_GORDES_DAM_RIVER_IMPROVEMENT_PRODUCTION',					'YieldType',	'YIELD_PRODUCTION'),
	('THREE_GORDES_DAM_RIVER_IMPROVEMENT_PRODUCTION',					'Amount',		1);


-- 巴米扬大佛
delete from Building_YieldChanges where BuildingType = 'BUILDING_BAMYAN' and YieldType = 'YIELD_CULTURE';

delete from BuildingModifiers where BuildingType = 'BUILDING_BAMYAN' and ModifierId != 'BAMYAN_GRANT_RELIC';

insert or replace into GlobalParameters
	(Name,														Value)
values
	('HD_BAMYAN_RELIGIOUS_PRESSURE',	400);

insert or replace into BuildingModifiers (BuildingType,	ModifierId)
select 'BUILDING_BAMYAN',	'BAMYAN_GRANT_TRADE_ROUTE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BAMYAN');
insert or replace into BuildingModifiers (BuildingType,	ModifierId)
select 'BUILDING_BAMYAN',	'BAMYAN_GRANT_TRADER'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BAMYAN');
insert or replace into BuildingModifiers (BuildingType,	ModifierId)
select 'BUILDING_BAMYAN',	'BAMYAN_GRANT_TRADE_ROUTE_SCIENCE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BAMYAN');
insert or replace into BuildingModifiers (BuildingType,	ModifierId)
select 'BUILDING_BAMYAN',	'BAMYAN_GRANT_TRADE_ROUTE_CULTURE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BAMYAN');
insert or replace into BuildingModifiers (BuildingType,	ModifierId)
select 'BUILDING_BAMYAN',	'BAMYAN_GRANT_TRADE_ROUTE_DOMESTIC_FAITH'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BAMYAN');
insert or replace into BuildingModifiers (BuildingType,	ModifierId)
select 'BUILDING_BAMYAN',	'BAMYAN_GRANT_TRADE_ROUTE_INTERNATIONAL_FAITH'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BAMYAN');

insert or replace into Modifiers
	(ModifierId,												ModifierType,															RunOnce,	Permanent,	SubjectRequirementSetId)
values
	('BAMYAN_GRANT_TRADE_ROUTE',						'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',							1,			1,			'PLAYER_HAS_NOT_FOUNDED_A_RELIGION'),
	('BAMYAN_GRANT_TRADER',									'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',							1,			1,			'PLAYER_HAS_NOT_FOUNDED_A_RELIGION'),
	('BAMYAN_GRANT_TRADE_ROUTE_SCIENCE',				'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	0,			0,			'PLAYER_HAS_NOT_FOUNDED_A_RELIGION'),
	('BAMYAN_GRANT_TRADE_ROUTE_CULTURE',				'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	0,			0,			'PLAYER_HAS_NOT_FOUNDED_A_RELIGION'),
	('BAMYAN_GRANT_TRADE_ROUTE_DOMESTIC_FAITH',		'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_FOR_DOMESTIC',			0,			0,			'PLAYER_HAS_FOUNDED_A_RELIGION'),
	('BAMYAN_GRANT_TRADE_ROUTE_INTERNATIONAL_FAITH',	'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',	0,			0,			'PLAYER_HAS_FOUNDED_A_RELIGION');
insert or replace into ModifierArguments
	(ModifierId,												Name,			Value)
values
	('BAMYAN_GRANT_TRADE_ROUTE',						'Amount',		1),
	('BAMYAN_GRANT_TRADER',						'UnitType',		'UNIT_TRADER'),
	('BAMYAN_GRANT_TRADER',						'Amount',		1),
	('BAMYAN_GRANT_TRADE_ROUTE_SCIENCE',				'YieldType',	'YIELD_SCIENCE'),
	('BAMYAN_GRANT_TRADE_ROUTE_SCIENCE',				'Amount',		1),
	('BAMYAN_GRANT_TRADE_ROUTE_CULTURE',				'YieldType',	'YIELD_CULTURE'),
	('BAMYAN_GRANT_TRADE_ROUTE_CULTURE',				'Amount',		1),
	('BAMYAN_GRANT_TRADE_ROUTE_DOMESTIC_FAITH',		'YieldType',	'YIELD_FAITH'),
	('BAMYAN_GRANT_TRADE_ROUTE_DOMESTIC_FAITH',		'Amount',		2),
	('BAMYAN_GRANT_TRADE_ROUTE_INTERNATIONAL_FAITH',	'YieldType',	'YIELD_FAITH'),
	('BAMYAN_GRANT_TRADE_ROUTE_INTERNATIONAL_FAITH',	'Amount',		2);

-- 铜雀台
update Buildings set
	Cost = 420,
	PrereqCivic = 'CIVIC_MILITARY_TRAINING',
	AdjacentDistrict = 'DISTRICT_CITY_CENTER',
	RequiresRiver = 0,
	AdvisorType = 'ADVISOR_CONQUEST'
where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE';

delete from Building_GreatWorks where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE' and GreatWorkSlotType = 'GREATWORKSLOT_PALACE';
delete from GameModifiers where ModifierId like 'MODFEAT_PHANTA_BRONZE_BIRD_TERRACE_AMENITY_UNIT_ATTACH_MODIFIER_%';

update ModifierArguments set Value = 'GREAT_PERSON_CLASS_GENERAL' where ModifierId = 'MODFEAT_PHANTA_BRONZE_BIRD_TERRACE_GRANT_WRITER' and Name = 'GreatPersonClassType';

insert or replace into Building_GreatPersonPoints (BuildingType,	GreatPersonClassType,	PointsPerTurn)
	select 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE', 'GREAT_PERSON_CLASS_GENERAL', 1
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE');

insert or replace into BuildingPrereqs (Building, PrereqBuilding)
	select 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE', 'BUILDING_BARRACKS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE');

insert or replace into BuildingPrereqs (Building, PrereqBuilding)
	select 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE', 'BUILDING_STABLE'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE');

-- 哈利法塔
delete from BuildingModifiers where BuildingType = 'BUILDING_BURJ_KHALIFA' and ModifierId not in ('BURJ_KHALIFA_ADDGOLDYIELD');

insert or replace into BuildingModifiers (BuildingType,	ModifierId)
	select 'BUILDING_BURJ_KHALIFA',	'HD_KHALIFA_CULTURE_BONUS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_BURJ_KHALIFA');

insert or replace into Modifiers
	(ModifierId,									ModifierType)
values
	('HD_KHALIFA_CULTURE_BONUS',	'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');

insert or replace into ModifierArguments
	(ModifierId,									Name,					Value)
values
	('HD_KHALIFA_CULTURE_BONUS',	'YieldType',	'YIELD_CULTURE'),
	('HD_KHALIFA_CULTURE_BONUS',	'Amount',			15);

insert or replace into GlobalParameters
	(Name,																	Value)
values
	('HD_BURJ_KHALIFA_MERCHANT_PERCENTAGE',	15);

-- Cost adjust
update Buildings set Cost = 180 where BuildingType = 'P0K_BUILDING_TEMPLE_POSEIDON';
update Buildings set Cost = 260 where BuildingType = 'BUILDING_ABU_SIMBEL';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_BOROBUDUR';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_YELLOW_CRANE';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_BAMYAN';
update Buildings set Cost = 420 where BuildingType = 'BUILDING_ITSUKUSHIMA';
update Buildings set Cost = 750 where BuildingType = 'BUILDING_SUK_NOTRE_DAME_DE_PARIS';
update Buildings set Cost = 750 where BuildingType = 'WON_CL_KINKAKU';
update Buildings set Cost = 1000 where BuildingType = 'BUILDING_AL_STPETERSBASILICA';
update Buildings set Cost = 1000 where BuildingType = 'BUILDING_UFFIZI';
update Buildings set Cost = 1000 where BuildingType = 'BUILDING_GLOBE_THEATRE';
update Buildings set Cost = 1000 where BuildingType = 'BUILDING_PORCELAIN_TOWER';
update Buildings set Cost = 1000 where BuildingType = 'BUILDING_LEANING_TOWER';
update Buildings set Cost = 1360 where BuildingType = 'BUILDING_NEUSCHWANSTEIN';
update Buildings set Cost = 1360 where BuildingType = 'BUILDING_BRANDENBURG_GATE';
update Buildings set Cost = 1800 where BuildingType = 'BUILDING_THREE_GORDES_DAM';
update Buildings set Cost = 1800 where BuildingType = 'BUILDING_TOWER_BRIDGE';
update Buildings set Cost = 2000 where BuildingType = 'BUILDING_BURJ_KHALIFA';
update Buildings set Cost = 1800 where BuildingType = 'WON_CL_EMPIRE_STATES';
update Buildings set Cost = 1800 where BuildingType = 'BUILDING_MOTHERLAND_CALLS';
update Buildings set Cost = 2000 where BuildingType = 'WON_CL_BUILDING_ARECIBO';
update Buildings set Cost = 2000 where BuildingType = 'CL_BUILDING_CN_TOWER';
