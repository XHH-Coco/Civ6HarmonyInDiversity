-- Remove Adjacencies
-- Remove some adjacencies that will be added back right after, to make them better ordered in the game text.
delete from District_Adjacencies where (DistrictType = 'DISTRICT_INDUSTRIAL_ZONE' or DistrictType in
	(select CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_INDUSTRIAL_ZONE')) and
	(YieldChangeId = 'LumberMill_HalfProduction' or YieldChangeId = 'Minel_HalfProduction' or YieldChangeId = 'Quarry_Production');
delete from District_Adjacencies where DistrictType = 'DISTRICT_HANSA' and
	(YieldChangeId = 'Resource_Production' or YieldChangeId = 'Commerical_Hub_Production');
-- Remove a non-repetition UD support, which will be added back with the UD support sql afterwards
delete from District_Adjacencies where DistrictType = 'DISTRICT_ROYAL_NAVY_DOCKYARD' and YieldChangeId = 'RoyalDock_City_Gold';
-- Real remove
delete from District_Adjacencies where DistrictType = 'DISTRICT_THANH' and YieldChangeId = 'District_Culture_Major';
delete from District_Adjacencies where DistrictType = 'DISTRICT_SEOWON' and YieldChangeId = 'NegativeDistrict_Science';
delete from District_Adjacencies where DistrictType = 'DISTRICT_OBSERVATORY' and YieldChangeId = 'Farm_Science';
delete from District_Adjacencies where DistrictType = 'DISTRICT_OBSERVATORY' and YieldChangeId = 'Plantation_Science';
-- Add new Adjacencies
with District_Adjacencies_Pre
	(DistrictType,						YieldChangeId)
as (values
	('DISTRICT_INDUSTRIAL_ZONE',		'City_center_Production'),
	('DISTRICT_INDUSTRIAL_ZONE',		'Strategic_Production_Late'),
	('DISTRICT_COMMERCIAL_HUB',			'Canal_Gold'),
	('DISTRICT_COMMERCIAL_HUB',			'Luxury_Gold'),
	('DISTRICT_COMMERCIAL_HUB',			'Bonus_Gold'),
	('DISTRICT_COMMERCIAL_HUB',			'Hansa_Gold'),
	('DISTRICT_THEATER',				'District_Culture_City_Center'),
	('DISTRICT_AQUEDUCT',				'Aqueduct_Self_Food'),
	('DISTRICT_ENCAMPMENT',				'HD_Strategic_Production'),
	('DISTRICT_ENCAMPMENT',				'Government_Production'),
	('DISTRICT_ENCAMPMENT',				'Aerodrome_Production'),
	('DISTRICT_HOLY_SITE',				'Neighborhood_Faith'),
	('DISTRICT_HOLY_SITE',				'Mbanza_Faith'),
	('DISTRICT_CAMPUS',					'City_Center_Science'),
	('DISTRICT_CAMPUS',					'Marsh_Science'),
	('DISTRICT_CAMPUS',					'Jungle_Science_Late'),

	('DISTRICT_BATH',					'Aqueduct_Self_Food'),
	('DISTRICT_ROYAL_NAVY_DOCKYARD',	'Industrial_Zone_Gold'),
	('DISTRICT_ACROPOLIS',				'City_Center_Culture'),
	('DISTRICT_HANSA',					'River_Hansa_Production'),
	('DISTRICT_HANSA',					'HD_Commerical_Hub_Production'),
	('DISTRICT_HANSA',					'HD_Suguba_Production'),
	('DISTRICT_HANSA',					'HD_Commerical_Hub_Production_Late'),
	('DISTRICT_HANSA',					'HD_Suguba_Production_Late'),
	('DISTRICT_HANSA',					'HD_Resource_Production'),
	('DISTRICT_HANSA',					'HD_Resource_Production_Late'),
	('DISTRICT_HANSA',					'City_center_Production'),
	('DISTRICT_MBANZA',					'Mbanza_Self_Food'),
	('DISTRICT_MBANZA',					'Mbanza_Self_Gold'),
	('DISTRICT_MBANZA',					'Bonus_Production'),
	('DISTRICT_MBANZA',					'Luxury_Gold'),
	('DISTRICT_MBANZA',					'Strategic_Science'),
--	('DISTRICT_HIPPODROME',				'Holy_Site_Culture'),
--	('DISTRICT_HIPPODROME',				'Lavra_Culture'),
	('DISTRICT_THANH',					'District_Production_HD'),
	('DISTRICT_OBSERVATORY',			'Luxury_Science'),
	('DISTRICT_OBSERVATORY',			'Luxury_Science_Late'),
	('DISTRICT_OBSERVATORY',			'Farm_Science_HD'),
	('DISTRICT_OBSERVATORY',			'Farm_Science_Late'))
insert or replace into District_Adjacencies
	(DistrictType,	YieldChangeId)
select
	DistrictType,	YieldChangeId
from District_Adjacencies_Pre where DistrictType in (select DistrictType from Districts);

-- DLC support
with District_Adjacencies_Pre
	(DistrictType,						YieldChangeId)
as (values
	('DISTRICT_COMMERCIAL_HUB',			'Diplomatic_Quater_Gold'),
	('DISTRICT_HARBOR',					'Diplomatic_Quater_Gold'),
	('DISTRICT_HOLY_SITE',				'Diplomatic_Quater_Faith'),
	('DISTRICT_CAMPUS',					'Diplomatic_Quater_Science'),
	('DISTRICT_THEATER',				'Diplomatic_Quater_Culture'),
	('DISTRICT_ENCAMPMENT',				'Diplomatic_Quater_Production'),
	('DISTRICT_INDUSTRIAL_ZONE',		'Diplomatic_Quater_Production'))
insert or replace into District_Adjacencies
	(DistrictType,	YieldChangeId)
select
	DistrictType,	YieldChangeId
from District_Adjacencies_Pre where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');
-- Mod support
insert or replace into District_Adjacencies
	(DistrictType,						YieldChangeId)
select
	'DISTRICT_HOLY_SITE',				'Preserve_Faith'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_PRESERVE');
insert or replace into District_Adjacencies
	(DistrictType,						YieldChangeId)
select
	'DISTRICT_HOLY_SITE',				'Kelp_Faith'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_SUK_KELP');
-- UD support
insert or ignore into District_Adjacencies 
	(DistrictType,				YieldChangeId)
select
	b.CivUniqueDistrictType,	a.YieldChangeId 
from (District_Adjacencies a inner join DistrictReplaces b on a.DistrictType = b.ReplacesDistrictType)
	where b.CivUniqueDistrictType not in ('DISTRICT_OBSERVATORY', 'DISTRICT_SEOWON', 'DISTRICT_HANSA', 'DIS_C_IKU')
	or a.YieldChangeId like 'Diplomatic_Quater_%';

delete from District_Adjacencies where DistrictType = 'DISTRICT_ACROPOLIS' and YieldChangeId = 'District_Culture_City_Center';
delete from District_Adjacencies where DistrictType = 'DISTRICT_OPPIDUM' and YieldChangeId in ('Strategic_Production');

-- Adjacency update
update Adjacency_YieldChanges set YieldChange = 2 where ID = 'SeaResource_Gold';
update Adjacency_YieldChanges set YieldChange = 3 where ID = 'NaturalWonder_Faith';
update Adjacency_YieldChanges set TilesRequired = 1 where ID = 'Forest_Faith';
update Adjacency_YieldChanges set YieldChange = 1 where ID = 'Harbor_City_Gold';
update Adjacency_YieldChanges set TilesRequired = 1 where ID = 'District_Gold';

-- Adjacency definition
-- Adjacent to district (remember to support UD)
insert or replace into Adjacency_YieldChanges
	(ID,									Description,									YieldType,			YieldChange,	AdjacentDistrict)
values
	('Industrial_Zone_Gold',				'LOC_DISTRICT_INDUSTRIAL_ZONE_GOLD',			'YIELD_GOLD',		2,				'DISTRICT_INDUSTRIAL_ZONE'),
	('Hansa_Gold',							'LOC_DISTRICT_HANSA_GOLD',						'YIELD_GOLD',		2,				'DISTRICT_HANSA'),
	('Canal_Gold',							'LOC_DISTRICT_CANAL_GOLD',						'YIELD_GOLD',		3,				'DISTRICT_CANAL'),
	('City_Center_Culture',					'LOC_DISTRICT_CITY_CENTER_CULTURE',				'YIELD_CULTURE',	2,				'DISTRICT_CITY_CENTER'),
	('City_Center_Science',					'LOC_DISTRICT_CITY_CENTER_SCIENCE',				'YIELD_SCIENCE',	1,				'DISTRICT_CITY_CENTER'),
	('Aerodrome_Production',				'LOC_DISTRICT_AERODROME_PRODUCTION',			'YIELD_PRODUCTION', 2,				'DISTRICT_AERODROME'),
	('City_center_Production',				'LOC_DISTRICT_CITY_CENTER_PRODUCTION',			'YIELD_PRODUCTION', 1,				'DISTRICT_CITY_CENTER'),
	('Neighborhood_Faith',					'LOC_DISTRICT_NEIGHBORHOOD_FAITH',				'YIELD_FAITH',		2,				'DISTRICT_NEIGHBORHOOD'),
	('Mbanza_Faith',						'LOC_DISTRICT_MBANZA_FAITH',					'YIELD_FAITH',		2,				'DISTRICT_MBANZA'),
	('Holy_Site_Culture',					'LOC_DISTRICT_HOLY_SITE_CULTURE',				'YIELD_CULTURE',	2,				'DISTRICT_HOLY_SITE'),
	('Lavra_Culture',						'LOC_DISTRICT_LAVRA_CULTURE',					'YIELD_CULTURE',	2,				'DISTRICT_LAVRA');
insert or replace into Adjacency_YieldChanges
	(ID,									Description,									YieldType,			YieldChange,	TilesRequired,	OtherDistrictAdjacent)
values
	('District_Production_HD',				'LOC_DISTRICT_DISTRICT_PRODUCTION',				'YIELD_PRODUCTION',	1,				2,				1);

-- Adjacent to resources class
insert or replace into Adjacency_YieldChanges
	(ID,								Description,								YieldType,				YieldChange,	AdjacentResourceClass)
values
	('Luxury_Gold',						'LOC_DISTRICT_LUXURY_GOLD',					'YIELD_GOLD',			2,				'RESOURCECLASS_LUXURY'),
	('Bonus_Gold',						'LOC_DISTRICT_BONUS_GOLD',					'YIELD_GOLD',			1,				'RESOURCECLASS_BONUS'),
	('HD_Strategic_Production',			'LOC_DISTRICT_HD_STRATEGIC_PRODUCTION',		'YIELD_PRODUCTION',		2,				'RESOURCECLASS_STRATEGIC'),
	('Bonus_Production',				'LOC_DISTRICT_BONUS_PRODUCTION',			'YIELD_PRODUCTION',		1,				'RESOURCECLASS_BONUS'),
	('Strategic_Science',				'LOC_DISTRICT_STRATEGIC_SCIENCE',			'YIELD_SCIENCE',		1,				'RESOURCECLASS_STRATEGIC'),
	('Strategic_Production_Late',				'LOC_DISTRICT_STRATEGIC2_PRODUCTION',			'YIELD_PRODUCTION',		2,				'RESOURCECLASS_STRATEGIC');
update Adjacency_YieldChanges set ObsoleteTech = 'TECH_GEOLOGY_HD' where ID = 'Strategic_Production';
update Adjacency_YieldChanges set PrereqTech = 'TECH_GEOLOGY_HD' where ID = 'Strategic_Production_Late';
-- Self (no adjacency requirements)
insert or replace into Adjacency_YieldChanges
	(ID,								Description,					YieldType,			YieldChange,	Self)
values
	('Aqueduct_Self_Food',				'LOC_DISTRICT_SELF_FOOD',		'YIELD_FOOD',		1,				1),
	('Mbanza_Self_Food',				'LOC_DISTRICT_SELF_FOOD',		'YIELD_FOOD',		2,				1),
	('Mbanza_Self_Gold',				'LOC_DISTRICT_SELF_GOLD',		'YIELD_GOLD',		2,				1);
-- With Prereq/Obsolete Tech/Civic

insert or replace into Adjacency_YieldChanges
	(ID,									Description,								YieldType,				YieldChange,	AdjacentDistrict, 			PrereqTech,				ObsoleteTech)
values
	('HD_Commerical_Hub_Production',		'LOC_DISTRICT_COMMERCIAL_HUB_PRODUCTION',	'YIELD_PRODUCTION',		1,				'DISTRICT_COMMERCIAL_HUB',	null,					'TECH_APPRENTICESHIP'),
	('HD_Commerical_Hub_Production_Late',	'LOC_DISTRICT_COMMERCIAL_HUB_PRODUCTION',	'YIELD_PRODUCTION',		2,				'DISTRICT_COMMERCIAL_HUB',	'TECH_APPRENTICESHIP',	null),
	('HD_Suguba_Production',				'LOC_DISTRICT_SUGUBA_PRODUCTION',			'YIELD_PRODUCTION',		1,				'DISTRICT_SUGUBA',			null,					'TECH_APPRENTICESHIP'),
	('HD_Suguba_Production_Late', 			'LOC_DISTRICT_SUGUBA_PRODUCTION',			'YIELD_PRODUCTION',		2,				'DISTRICT_SUGUBA',			'TECH_APPRENTICESHIP',	null);
insert or replace into Adjacency_YieldChanges
	(ID,									Description,								YieldType,				YieldChange,	AdjacentResource,	PrereqTech,				ObsoleteTech)
values
	('HD_Resource_Production',				'LOC_DISTRICT_RESOURCE_PRODUCTION',			'YIELD_PRODUCTION',		1,				1,					null,					'TECH_APPRENTICESHIP'),
	('HD_Resource_Production_Late',			'LOC_DISTRICT_RESOURCE_PRODUCTION',			'YIELD_PRODUCTION',		2,				1,					'TECH_APPRENTICESHIP',	null);
insert or replace into Adjacency_YieldChanges
	(ID,						Description,                            YieldType,          YieldChange,    TilesRequired,  AdjacentImprovement,    AdjacentResourceClass,		PrereqTech,			ObsoleteTech,		PrereqCivic,		ObsoleteCivic)
values
	('Luxury_Science',			'LOC_DISTRICT_JNR_UC_Luxury_Science',   'YIELD_SCIENCE',    1,              1,              null,                   'RESOURCECLASS_LUXURY',		null,				'TECH_ASTRONOMY',	null,				null),
	('Luxury_Science_Late',		'LOC_DISTRICT_JNR_UC_Luxury_Science',   'YIELD_SCIENCE',    2,              1,              null,                   'RESOURCECLASS_LUXURY',		'TECH_ASTRONOMY',	null,				null,				null),
	('Farm_Science_HD',			'LOC_DISTRICT_FARM_SCIENCE',            'YIELD_SCIENCE',    1,              2,              'IMPROVEMENT_FARM',     'NO_RESOURCECLASS',			null,				null,				null,				'CIVIC_FEUDALISM'),
	('Farm_Science_Late',		'LOC_DISTRICT_FARM_SCIENCE',            'YIELD_SCIENCE',    1,              1,              'IMPROVEMENT_FARM',     'NO_RESOURCECLASS',			null,				null,				'CIVIC_FEUDALISM',	null);
-- Misc
insert or replace into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, AdjacentFeature, AdjacentRiver, PrereqTech) values
	('River_Hansa_Production',				'LOC_DISTRICT_RIVER_HANSA_PRODUCTION', 		'YIELD_PRODUCTION', 	2,				null,				1,	NULL),
	('Marsh_Science',									'LOC_DISTRICT_MARSH_SCIENCE', 				'YIELD_SCIENCE', 		1,				'FEATURE_MARSH',	0,	NULL),
	('Jungle_Science_Late',						'LOC_DISTRICT_JUNGLE_SCIENCE', 				'YIELD_SCIENCE', 		1,				'FEATURE_JUNGLE',	0,	'TECH_EDUCATION');
update Adjacency_YieldChanges set ObsoleteTech = 'TECH_EDUCATION' where ID = 'Jungle_Science';
-- DLC Support
with Adjacency_YieldChanges_Pre
	(ID,								Description,									YieldType,			YieldChange,	AdjacentDistrict)
as (values
	('Preserve_Faith',					'LOC_DISTRICT_PRESERVE_FAITH',					'YIELD_FAITH',		1,				'DISTRICT_PRESERVE'),
	('Diplomatic_Quater_Gold',			'LOC_DISTRICT_DIPLOMATIC_QUATER_GOLD',			'YIELD_GOLD',		1,				'DISTRICT_DIPLOMATIC_QUARTER'),
	('Diplomatic_Quater_Faith',			'LOC_DISTRICT_DIPLOMATIC_QUATER_FAITH',			'YIELD_FAITH',		1,				'DISTRICT_DIPLOMATIC_QUARTER'),
	('Diplomatic_Quater_Science',		'LOC_DISTRICT_DIPLOMATIC_QUATER_SCIENCE',		'YIELD_SCIENCE',	1,				'DISTRICT_DIPLOMATIC_QUARTER'),
	('Diplomatic_Quater_Culture',		'LOC_DISTRICT_DIPLOMATIC_QUATER_CULTURE',		'YIELD_CULTURE',	1,				'DISTRICT_DIPLOMATIC_QUARTER'),
	('Diplomatic_Quater_Production',	'LOC_DISTRICT_DIPLOMATIC_QUATER_PRODUCTION',	'YIELD_PRODUCTION',	1,				'DISTRICT_DIPLOMATIC_QUARTER'))
insert or replace into Adjacency_YieldChanges
	(ID,	Description,	YieldType,	YieldChange,	AdjacentDistrict)
select
	ID,		Description,	YieldType,	YieldChange,	AdjacentDistrict
from Adjacency_YieldChanges_Pre where AdjacentDistrict in (select DistrictType from Districts);
-- Mod Support
insert or replace into Adjacency_YieldChanges
	(ID,				Description,		YieldType,		YieldChange,	AdjacentFeature)
select
	'Kelp_Faith',		'LOC_KELP_FAITH',	'YIELD_FAITH',	1,				'FEATURE_SUK_KELP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_SUK_KELP');

delete from District_Adjacencies where DistrictType = 'DISTRICT_OPPIDUM';
create temporary table HD_DISTRICT_OPPIDUM (
	YieldChangeId text not null primary key
);
insert or replace into Adjacency_YieldChanges
	(ID,						Description,					YieldType,		YieldChange,	OtherDistrictAdjacent,	TilesRequired,		Self)
values
	('Oppidum_Self_Food',		'LOC_DISTRICT_SELF_FOOD',		'YIELD_FOOD',	2,				0,						1,					1),
	('Oppidum_District_Food',	'LOC_DISTRICT_DISTRICT_FOOD',	'YIELD_FOOD',	1,				1,						1,					0);
insert or replace into HD_DISTRICT_OPPIDUM
	(YieldChangeId)
select
	YieldChangeId
from District_Adjacencies where DistrictType = 'DISTRICT_INDUSTRIAL_ZONE';
insert or replace into District_Adjacencies
	(DistrictType,						YieldChangeId)
select
	'DISTRICT_OPPIDUM',					YieldChangeId
from HD_DISTRICT_OPPIDUM where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_OPPIDUM');
insert or replace into District_Adjacencies
	(DistrictType,						YieldChangeId)
select
	'DISTRICT_OPPIDUM',					'Oppidum_Self_Food'
from HD_DISTRICT_OPPIDUM where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_OPPIDUM');
insert or replace into District_Adjacencies
	(DistrictType,						YieldChangeId)
select
	'DISTRICT_OPPIDUM',					'Oppidum_District_Food'
from HD_DISTRICT_OPPIDUM where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_OPPIDUM');
--冰岛
delete from District_Adjacencies where DistrictType = 'DISTRICT_SUK_TORFBAEIR' and YieldChangeId = 'Aqueduct_Self_Food';