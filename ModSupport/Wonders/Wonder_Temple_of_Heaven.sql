----------------------------------------------------------------------------------------------------------------
------support some Comunity Wonder and update its effect (also unlock civ&tech and cost)------------------------
--(By xiaoyu)
----------------------------------------------------------------------------------------------------------------

--BUILDING_TEMPLE_OF_HEAVEN
UPDATE Buildings SET  Cost = 1000, ObsoleteEra = 'ERA_MODERN',  PrereqTech = 'TECH_ASTRONOMY', PrereqCivic = NULL
WHERE BuildingType = 'BUILDING_TEMPLE_OF_HEAVEN' AND EXISTS (SELECT BuildingType FROM Buildings WHERE BuildingType ='BUILDING_TEMPLE_OF_HEAVEN');

delete from Building_YieldChanges where BuildingType = 'BUILDING_TEMPLE_OF_HEAVEN' and YieldType = 'YIELD_FAITH';
insert or replace into Building_YieldChanges
	(BuildingType,					YieldType,			YieldChange)
values
	('BUILDING_TEMPLE_OF_HEAVEN',	'YIELD_CULTURE',	4);
delete from BuildingModifiers where BuildingType = 'BUILDING_TEMPLE_OF_HEAVEN';

-- insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
-- 	'BUILDING_TEMPLE_OF_HEAVEN',	'TEMPLE_OF_HEAVEN_GOVERNOR_FOOD'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_TEMPLE_OF_HEAVEN');

-- insert or replace into BuildingModifiers (BuildingType,	ModifierId) select
-- 	'BUILDING_TEMPLE_OF_HEAVEN',	'TEMPLE_OF_HEAVEN_DOMESTIC_GOLD'
-- where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_TEMPLE_OF_HEAVEN');

insert or replace into Modifiers 
	(ModifierId,						ModifierType) 
values
	('TEMPLE_OF_HEAVEN_DOMESTIC_GOLD',	'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_PER_SPECIALTY_DISTRICT_FOR_DOMESTIC'),
	('TEMPLE_OF_HEAVEN_GOVERNOR_FOOD',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER_PER_GOVERNOR_TITLE');

insert or replace into ModifierArguments 
	(ModifierId,						Name,			Value) 
values
	('TEMPLE_OF_HEAVEN_DOMESTIC_GOLD',	'YieldType',	'YIELD_GOLD'),
	('TEMPLE_OF_HEAVEN_DOMESTIC_GOLD',	'Amount',		2),
	('TEMPLE_OF_HEAVEN_GOVERNOR_FOOD',	'YieldType',	'YIELD_FOOD'),
	('TEMPLE_OF_HEAVEN_GOVERNOR_FOOD',	'Amount',		3);

-- For Domestic
insert or replace into DistrictModifiers (DistrictType, ModifierId)
select DistrictType, DistrictType || '_' || YieldType || '_TO_OTHERS'
from District_TradeRouteYields
where YieldChangeAsDomesticDestination != 0;

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
select DistrictType || '_' || YieldType || '_TO_OTHERS',
    'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS',
    'TEMPLE_OF_HEAVEN_REQUIREMENTS'
from District_TradeRouteYields
where  YieldChangeAsDomesticDestination != 0;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_TO_OTHERS', 'YieldType', YieldType
from District_TradeRouteYields
where YieldChangeAsDomesticDestination != 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_TO_OTHERS', 'Amount', YieldChangeAsDomesticDestination
from District_TradeRouteYields
where  YieldChangeAsDomesticDestination != 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_TO_OTHERS', 'Domestic', 1
from District_TradeRouteYields
where YieldChangeAsDomesticDestination != 0;

insert or replace into Requirements (RequirementId ,RequirementType)
values('PLAYER_HAS_TEMPLE_OF_HEAVEN_REQUIREMENTS','REQUIREMENT_PLAYER_HAS_BUILDING');
insert or replace into RequirementArguments (RequirementId, Name, Value)
values('PLAYER_HAS_TEMPLE_OF_HEAVEN_REQUIREMENTS','BuildingType','BUILDING_TEMPLE_OF_HEAVEN');
insert or replace into RequirementSetRequirements(RequirementSetId,RequirementId)
values('TEMPLE_OF_HEAVEN_REQUIREMENTS','PLAYER_HAS_TEMPLE_OF_HEAVEN_REQUIREMENTS');
insert or replace into RequirementSets (RequirementSetId,RequirementSetType)
values('TEMPLE_OF_HEAVEN_REQUIREMENTS','REQUIREMENTSET_TEST_ALL');
