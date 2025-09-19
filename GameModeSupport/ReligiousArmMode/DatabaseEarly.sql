insert or replace into Types 
	(Type,								Kind) 
values
	('BUILDING_SHAOLIN_TEMPLE',			'KIND_BUILDING');
insert or replace into Buildings
	(BuildingType,					Name,									Description,									PrereqDistrict,			PurchaseYield,	Cost,	CitizenSlots,	EnabledByReligion,	Maintenance)
values
	('BUILDING_SHAOLIN_TEMPLE',		'LOC_BUILDING_SHAOLIN_TEMPLE_NAME',		'LOC_BUILDING_SHAOLIN_TEMPLE_DESCRIPTION',		'DISTRICT_HOLY_SITE',	'YIELD_FAITH',	220,	1,				1,					4);
insert or replace into Building_YieldChanges
	(BuildingType,					YieldType,			YieldChange)
values
	('BUILDING_SHAOLIN_TEMPLE',		'YIELD_FAITH',		8);
insert or replace into Building_CitizenYieldChanges
	(BuildingType,					YieldType,			YieldChange)
values
	('BUILDING_SHAOLIN_TEMPLE',		'YIELD_FAITH',		1);
insert or replace into BuildingPrereqs
	(Building,						PrereqBuilding)
values
	('BUILDING_SHAOLIN_TEMPLE',		'BUILDING_TEMPLE');