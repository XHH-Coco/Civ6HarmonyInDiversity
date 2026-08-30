-------------------------------------
--  Temporary update database sql  --
-------------------------------------

--building theming bonus adjustment
--考古=同时代，不同国家
--艺术=同类型，不同作者

--OXFORD_UNIVERSITY
--不同作者
update Building_GreatWorks set 
	ThemingUniquePerson = 1 ,
	ThemingSameObjectType = 1 ,
	ThemingSameEras = 0 ,
	ThemingTourismMultiplier = 100 ,
	ThemingYieldMultiplier = 100
where BuildingType = 'BUILDING_OXFORD_UNIVERSITY';

--GLOBE_THEATRE
--不同作者
update Building_GreatWorks set 
	NumSlots = 3 ,
	ThemingUniquePerson = 1 ,
	ThemingSameObjectType = 1 ,
	ThemingTourismMultiplier = 100 ,
	ThemingYieldMultiplier = 100
where BuildingType = 'BUILDING_GLOBE_THEATRE';

--GOV_CULTURE
--同时代
update Building_GreatWorks set 
	NumSlots = 6 ,
	ThemingUniquePerson = 0 ,
	ThemingSameObjectType = 0 ,
	ThemingSameEras = 1 ,
	ThemingTourismMultiplier = 200 ,
	ThemingYieldMultiplier = 200
where BuildingType = 'BUILDING_GOV_CULTURE';

--HERMITAGE
delete from Building_GreatWorks where BuildingType = 'BUILDING_HERMITAGE';
insert or replace into Building_GreatWorks
	(BuildingType, 			GreatWorkSlotType, 			NumSlots,	ThemingUniquePerson,	ThemingYieldMultiplier,	ThemingTourismMultiplier,	NonUniquePersonYield,	NonUniquePersonTourism)
values
	('BUILDING_HERMITAGE',	'GREATWORKSLOT_ART',		6,			1,						200,					200,						1,						1);

--SYDNEY_OPERA_HOUSE
--同时代
update Building_GreatWorks set 
	NumSlots = 6,
	ThemingUniquePerson = 1 ,
	ThemingSameObjectType = 1 ,
	ThemingSameEras = 0 ,
	ThemingTourismMultiplier = 200 ,
	ThemingYieldMultiplier = 200
where BuildingType = 'BUILDING_SYDNEY_OPERA_HOUSE';

--BUILDING_HAGIA_SOPHIA
insert or replace into Building_GreatWorks
	(BuildingType, 						GreatWorkSlotType, 			NumSlots,	ThemingUniquePerson,	ThemingYieldMultiplier,	ThemingTourismMultiplier,	NonUniquePersonYield,	NonUniquePersonTourism, ThemingBonusDescription)
values
	('BUILDING_HAGIA_SOPHIA',	'GREATWORKSLOT_ART',		3,				1,										100,										100,											1,										1,											'LOC_BUILDING_THEMINGBONUS_HAGIA_SOPHIA');