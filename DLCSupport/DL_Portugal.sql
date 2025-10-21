-------------------------------------
--            Portugal DLC         --
-------------------------------------

insert or replace into Building_CitizenYieldChanges
	(BuildingType,							YieldType,			YieldChange)
values
	('BUILDING_NAVIGATION_SCHOOL',			'YIELD_SCIENCE',	1), -- ub
	('BUILDING_NAVIGATION_SCHOOL',			'YIELD_GOLD',		-1);

update Buildings set RegionalRange = 3 where BuildingType = 'BUILDING_NAVIGATION_SCHOOL';

insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
    ('BUILDING_NAVIGATION_SCHOOL',  'UNIVERSITY_ADD_POPULATION_SCIENCE');

update Buildings set Maintenance = 4,	Cost = 275, PrereqCivic	= 'CIVIC_GUILDS'	where BuildingType = 'BUILDING_NAVIGATION_SCHOOL';


-- BUILDING_TORRE_DE_BELEM Wonder
-- remove the effect.
delete from BuildingModifiers where BuildingType = 'BUILDING_TORRE_DE_BELEM' and ModifierId = 'TORREDEBELEM_CHEAPEST_BUILDING';

insert or replace into BuildingModifiers
    (BuildingType,              ModifierId)
values
    ('BUILDING_TORRE_DE_BELEM', 'TORRE_DE_BELEM_OFF_HOME_POP'),
    ('BUILDING_TORRE_DE_BELEM', 'TORRE_DE_BELEM_SETTLERS_MOVEMENT'),
    ('BUILDING_TORRE_DE_BELEM', 'TORRE_DE_BELEM_GRANT_SETTLERS');

insert or replace into Modifiers
    (ModifierId,                            ModifierType,                               RunOnce,    Permanent,  SubjectRequirementSetId)
values 
    ('TORRE_DE_BELEM_OFF_HOME_POP',         'MODIFIER_PLAYER_ADJUST_EXTRA_STARTING_POPULATION_OFF_HOME_CONTINENT',  0, 0,   NULL),
    ('TORRE_DE_BELEM_SETTLERS_MOVEMENT',    'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT',    0,          0,          'HD_UNIT_IS_SETTLER'),
    ('TORRE_DE_BELEM_GRANT_SETTLERS',       'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',  1,          1,          NULL);

insert or replace into ModifierArguments
    (ModifierId,                            Name,       Value)
values
    ('TORRE_DE_BELEM_OFF_HOME_POP',         'Amount',   2),
    ('TORRE_DE_BELEM_SETTLERS_MOVEMENT',    'Amount',   2),
    ('TORRE_DE_BELEM_GRANT_SETTLERS',       'UnitType', 'UNIT_SETTLER'),
    ('TORRE_DE_BELEM_GRANT_SETTLERS',       'Amount',   2);
update TypeTags set Tag = 'CLASS_NAVAL' where Type = 'ABILITY_PORTA_DO_CERCO_EXTRA_SIGHT';