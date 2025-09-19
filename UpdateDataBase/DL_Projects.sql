-------------------------------------
--      Projects Adjustments      --
-------------------------------------

-- Projects
update Projects set CostProgressionParam1 = 1100
 where ProjectType = 'PROJECT_CARNIVAL'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_ENCAMPMENT'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_HARBOR'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_INDUSTRIAL_ZONE'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_COMMERCIAL_HUB'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_HOLY_SITE'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_CAMPUS'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_THEATER'
	or ProjectType = 'PROJECT_WATER_CARNIVAL'
	or ProjectType = 'PROJECT_BREAD_AND_CIRCUSES'
	or ProjectType = 'PROJECT_WATER_BREAD_AND_CIRCUSES'
;

update Projects set Cost = 40
 where ProjectType = 'PROJECT_CARNIVAL'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_ENCAMPMENT'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_HARBOR'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_INDUSTRIAL_ZONE'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_COMMERCIAL_HUB'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_HOLY_SITE'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_CAMPUS'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_THEATER'
	or ProjectType = 'PROJECT_WATER_CARNIVAL'
	or ProjectType = 'PROJECT_BREAD_AND_CIRCUSES'
	or ProjectType = 'PROJECT_WATER_BREAD_AND_CIRCUSES'
;

update Projects set CostProgressionParam1 = 200, Cost = 50	where ProjectType = 'PROJECT_COTHON_CAPITAL_MOVE';

-- Project Great Points
update Project_GreatPersonPoints set PointProgressionParam1 = 900
 where ProjectType = 'PROJECT_CARNIVAL'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_ENCAMPMENT'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_HARBOR'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_INDUSTRIAL_ZONE'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_COMMERCIAL_HUB'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_HOLY_SITE'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_CAMPUS'
	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_THEATER'
	or ProjectType = 'PROJECT_WATER_CARNIVAL'
;

--update Projects set PrereqCivic = 'CIVIC_HISTORICAL_PHILOSOPHY_HD' where ProjectType like 'PROJECT_ENHANCE_DISTRICT_%';
update Project_YieldConversions set PercentOfProductionRate = PercentOfProductionRate * 2 where ProjectType like 'PROJECT_ENHANCE_DISTRICT_%';

-- update Project_GreatPersonPoints set Points = 10
--  where ProjectType = 'PROJECT_ENHANCE_DISTRICT_ENCAMPMENT'
-- 	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_HARBOR'
-- 	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_INDUSTRIAL_ZONE'
-- 	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_COMMERCIAL_HUB'
-- 	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_HOLY_SITE'
-- 	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_CAMPUS'
-- ;

-- update Project_GreatPersonPoints set Points = 5
--  where ProjectType = 'PROJECT_CARNIVAL'
-- 	or ProjectType = 'PROJECT_ENHANCE_DISTRICT_THEATER'
-- 	or ProjectType = 'PROJECT_WATER_CARNIVAL'
-- ;

-- TODO OCCULT project in Secret Societies MODE

-- strategic projects

insert or replace into Types	(Type,	Kind)
select 'PROJECT_GRANT_' || ResourceType,	'KIND_PROJECT' from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

insert or replace into Projects 
	(ProjectType,						Name,												ShortName,													
	Description,												Cost,	PrereqDistrict)
select
	'PROJECT_GRANT_' || ResourceType,	'LOC_PROJECT_GRANT_' || ResourceType || '_HD_NAME',	'LOC_PROJECT_GRANT_' || ResourceType || '_HD_SHORT_NAME',	
	'LOC_PROJECT_GRANT_' || ResourceType || '_HD_DESCRIPTION',	100,	'DISTRICT_ENCAMPMENT' from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

update Projects set Cost = 100,	PrereqTech = 'TECH_SADDLE_HD', RequiredBuilding = 'BUILDING_STABLE' where ProjectType = 'PROJECT_GRANT_RESOURCE_HORSES';
update Projects set Cost = 150,	PrereqTech = 'TECH_FUEL_HD', RequiredBuilding = 'BUILDING_BARRACKS'  where ProjectType = 'PROJECT_GRANT_RESOURCE_IRON';
update Projects set Cost = 200,	PrereqTech = 'TECH_GUNPOWDER', RequiredBuilding = 'BUILDING_ARMORY'  where ProjectType = 'PROJECT_GRANT_RESOURCE_NITER';
update Projects set Cost = 300,	PrereqTech = 'TECH_REFINING', RequiredBuilding = 'BUILDING_ARMORY'  where ProjectType = 'PROJECT_GRANT_RESOURCE_COAL';
update Projects set Cost = 500,	PrereqTech = 'TECH_PLASTICS', RequiredBuilding = 'BUILDING_MILITARY_ACADEMY'  where ProjectType = 'PROJECT_GRANT_RESOURCE_OIL';
update Projects set Cost = 500,	PrereqTech = 'TECH_COMPUTERS', RequiredBuilding = 'BUILDING_MILITARY_ACADEMY'  where ProjectType = 'PROJECT_GRANT_RESOURCE_ALUMINUM';
update Projects set Cost = 800,	PrereqTech = 'TECH_STEALTH_TECHNOLOGY', RequiredBuilding = 'BUILDING_MILITARY_ACADEMY'  where ProjectType = 'PROJECT_GRANT_RESOURCE_URANIUM';

------------------------------------------------------------------------------------------------------------
-- adjust strategic projects cost
update Projects set Cost = 80 where ProjectType = 'PROJECT_GRANT_RESOURCE_HORSES';
update Projects set Cost = 100 where ProjectType = 'PROJECT_GRANT_RESOURCE_IRON';
update Projects set Cost = 150 where ProjectType = 'PROJECT_GRANT_RESOURCE_NITER';
update Projects set Cost = 200 where ProjectType = 'PROJECT_GRANT_RESOURCE_COAL';
update Projects set Cost = 300 where ProjectType = 'PROJECT_GRANT_RESOURCE_OIL';
update Projects set Cost = 300 where ProjectType = 'PROJECT_GRANT_RESOURCE_ALUMINUM';
update Projects set Cost = 600 where ProjectType = 'PROJECT_GRANT_RESOURCE_URANIUM';

update Projects set Cost = 1000 where ProjectType = 'PROJECT_TERRESTRIAL_LASER';
update Projects set Cost = 1000 where ProjectType = 'PROJECT_ORBITAL_LASER';

update Project_ResourceCosts set StartProductionCost = 30 where ProjectType = 'PROJECT_ORBITAL_LASER';

-- Launch Moon Landing
delete from ProjectCompletionModifiers where ProjectType = 'PROJECT_LAUNCH_MOON_LANDING' and ModifierId = 'PROJECT_COMPLETION_GRANT_CULTURE_BASED_ON_SCIENCE_RATE';
insert or replace into ProjectCompletionModifiers
	(ProjectType,						ModifierId)
values
	('PROJECT_LAUNCH_MOON_LANDING',		'LAUNCH_MOON_LANDING_CIVIC_BOOST_PRECENTAGE'),
	('PROJECT_LAUNCH_MOON_LANDING',		'HD_LAUNCH_MOON_LANDING_CIVIC_BOOST_PRECENTAGE_RECORD');
insert or replace into Modifiers
	(ModifierId,									ModifierType, Permanent)
values
	('LAUNCH_MOON_LANDING_CIVIC_BOOST_PRECENTAGE',	'MODIFIER_PLAYER_ADJUST_CIVIC_BOOST', 1),
	('HD_LAUNCH_MOON_LANDING_CIVIC_BOOST_PRECENTAGE_RECORD',	'MODIFIER_PLAYER_ADJUST_PROPERTY', 1);
insert or replace into ModifierArguments
	(ModifierId,									Name,		Value)
values
	('LAUNCH_MOON_LANDING_CIVIC_BOOST_PRECENTAGE',	'Amount',	10),
	('HD_LAUNCH_MOON_LANDING_CIVIC_BOOST_PRECENTAGE_RECORD',	'Key',		'HD_Player_Extra_Civic_Boost'),
	('HD_LAUNCH_MOON_LANDING_CIVIC_BOOST_PRECENTAGE_RECORD',	'Amount',	10);