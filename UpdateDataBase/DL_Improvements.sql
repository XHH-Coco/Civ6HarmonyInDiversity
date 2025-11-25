-- Basic Yield
insert or replace into Improvement_YieldChanges
	(ImprovementType,					YieldType,				YieldChange)
values
	('IMPROVEMENT_FISHING_BOATS',		'YIELD_FOOD',			0),
	('IMPROVEMENT_FISHING_BOATS',		'YIELD_PRODUCTION',		1),
	
	('IMPROVEMENT_FISHERY', 'YIELD_FOOD',       1),
	('IMPROVEMENT_FISHERY', 'YIELD_PRODUCTION', 1),

	('IMPROVEMENT_PLANTATION',			'YIELD_FOOD',			1),
	('IMPROVEMENT_PLANTATION',			'YIELD_PRODUCTION',		0),
	('IMPROVEMENT_PLANTATION',			'YIELD_GOLD',			0),

	('IMPROVEMENT_CAMP',				'YIELD_FOOD',			1),
	('IMPROVEMENT_CAMP',				'YIELD_PRODUCTION',		0),
	('IMPROVEMENT_CAMP',				'YIELD_GOLD',			0),

	('IMPROVEMENT_PASTURE',				'YIELD_FOOD',			0),
	('IMPROVEMENT_PASTURE',				'YIELD_PRODUCTION',		1),
	('IMPROVEMENT_PASTURE',				'YIELD_GOLD',			0),

	('IMPROVEMENT_LUMBER_MILL',			'YIELD_PRODUCTION',		1),
	('IMPROVEMENT_LUMBER_MILL',			'YIELD_GOLD',		0),

	('IMPROVEMENT_OIL_WELL',			'YIELD_PRODUCTION',		3),
	('IMPROVEMENT_OIL_WELL',			'YIELD_SCIENCE',		1),
	('IMPROVEMENT_OFFSHORE_OIL_RIG',	'YIELD_PRODUCTION',		3),
	('IMPROVEMENT_OFFSHORE_OIL_RIG',	'YIELD_SCIENCE',		1),
	
	('IMPROVEMENT_COLOSSAL_HEAD',		'YIELD_FAITH',			2),
	('IMPROVEMENT_MOAI',				'YIELD_CULTURE',		2),
	
	('IMPROVEMENT_ZIGGURAT',			'YIELD_SCIENCE',		1),
	('IMPROVEMENT_ZIGGURAT',			'YIELD_FAITH',		0),
	('IMPROVEMENT_MEKEWAP',				'YIELD_GOLD',			2),
	('IMPROVEMENT_MEKEWAP',				'YIELD_PRODUCTION',		0),
	('IMPROVEMENT_GREAT_WALL',			'YIELD_FOOD',			1),
	('IMPROVEMENT_CHATEAU',				'YIELD_FOOD',		2),
	('IMPROVEMENT_CHATEAU',				'YIELD_CULTURE',		1),
	('IMPROVEMENT_CHATEAU',				'YIELD_GOLD',		0),
	('IMPROVEMENT_LAND_POLDER',			'YIELD_FOOD',			1),
	('IMPROVEMENT_LAND_POLDER',			'YIELD_PRODUCTION',		1),
	('IMPROVEMENT_LAND_POLDER',			'YIELD_GOLD',			0),
	('IMPROVEMENT_MISSION',				'YIELD_FOOD',			0),
	('IMPROVEMENT_MISSION',				'YIELD_PRODUCTION',		0),
	('IMPROVEMENT_ICE_HOCKEY_RINK',		'YIELD_FOOD',			2);

-- Bonus Yield
delete from Improvement_BonusYieldChanges where ImprovementType in (
	'IMPROVEMENT_FARM',
	'IMPROVEMENT_PLANTATION',
	'IMPROVEMENT_CAMP',
	'IMPROVEMENT_PASTURE',
	'IMPROVEMENT_QUARRY',
	'IMPROVEMENT_MINE',
	'IMPROVEMENT_LUMBER_MILL',
	'IMPROVEMENT_FISHING_BOATS');

insert or replace into Improvement_BonusYieldChanges
	(Id,	ImprovementType,								YieldType,							BonusYieldChange,	PrereqCivic,										PrereqTech)
values
	(600,	'IMPROVEMENT_FARM',							'YIELD_FOOD',						1,								null,														'TECH_CALENDAR_HD'),
	(601,	'IMPROVEMENT_FARM',							'YIELD_FOOD',						1,								'CIVIC_HOUSEHOLD_REGISTRATION_HD',null),
	(602,	'IMPROVEMENT_FARM',							'YIELD_FOOD',						1,								null,														'TECH_ASTRONOMY'),
	(603,	'IMPROVEMENT_FARM',							'YIELD_FOOD',						1,								null,														'TECH_GEOLOGY_HD'),
	(604,	'IMPROVEMENT_FARM',							'YIELD_FOOD',						1,								null,														'TECH_BIOLOGY_HD'),
	(605,	'IMPROVEMENT_FARM',							'YIELD_FOOD',						1,								null,														'TECH_PLASTICS'),
	(606,	'IMPROVEMENT_FARM',							'YIELD_FOOD',						1,								null,														'TECH_GENETIC_ENGINEERING_HD'),
	(607,	'IMPROVEMENT_FARM',							'YIELD_FOOD',						1,								null,														'TECH_ROBOTICS'),

	(610,	'IMPROVEMENT_PLANTATION',				'YIELD_PRODUCTION',			1,								null,														'TECH_PAPER_MAKING_HD'),
	(611,	'IMPROVEMENT_PLANTATION',				'YIELD_FOOD',						1,								'CIVIC_FEUDALISM',							null),
	(612,	'IMPROVEMENT_PLANTATION',				'YIELD_FOOD',						1,								'CIVIC_MERCANTILISM',						null),
	(613,	'IMPROVEMENT_PLANTATION',				'YIELD_GOLD',						3,								'CIVIC_COLONIALISM',						null),
	(614,	'IMPROVEMENT_PLANTATION',				'YIELD_FOOD',						1,								null,														'TECH_BIOLOGY_HD'),
	(615,	'IMPROVEMENT_PLANTATION',				'YIELD_GOLD',						3,								'CIVIC_FINANCE_HD',							null),
	(616,	'IMPROVEMENT_PLANTATION',				'YIELD_FOOD',						1,								null,														'TECH_GENETIC_ENGINEERING_HD'),
	(617,	'IMPROVEMENT_PLANTATION',				'YIELD_GOLD',						3,								'CIVIC_NEOCOLONIALISM_HD',			null),
	(618,	'IMPROVEMENT_PLANTATION',				'YIELD_GOLD',						3,								'CIVIC_GLOBALIZATION',					null),

	(620,	'IMPROVEMENT_CAMP',						'YIELD_PRODUCTION',		1,					null,							'TECH_TEXTILE_HD'),
	(621,	'IMPROVEMENT_CAMP',						'YIELD_PRODUCTION',		1,					'CIVIC_MEDIEVAL_FAIRES',		null),
	(622,	'IMPROVEMENT_CAMP',						'YIELD_FOOD',					1,					'CIVIC_EVOLUTION_THEORY_HD',	null),
	(623,	'IMPROVEMENT_CAMP',						'YIELD_GOLD',					3,					'CIVIC_COLONIALISM',	null),
	(624,	'IMPROVEMENT_CAMP',						'YIELD_FOOD',					1,					null,							'TECH_REFRIGERATION_HD'),
	(625,	'IMPROVEMENT_CAMP',						'YIELD_GOLD',					3,					'CIVIC_FINANCE_HD',	null),
	(626,	'IMPROVEMENT_CAMP',						'YIELD_PRODUCTION',		1,					null,							'TECH_GENETIC_ENGINEERING_HD'),
	(627,	'IMPROVEMENT_CAMP',						'YIELD_GOLD',					3,					'CIVIC_NEOCOLONIALISM_HD',	null),
	(628,	'IMPROVEMENT_CAMP',						'YIELD_GOLD',					3,					'CIVIC_GLOBALIZATION',							null),

	(630,	'IMPROVEMENT_PASTURE',					'YIELD_PRODUCTION',		1,					null,							'TECH_SADDLE_HD'),
	(631,	'IMPROVEMENT_PASTURE',					'YIELD_PRODUCTION',		1,					'CIVIC_HERALDRY_HD',				null),
	(632,	'IMPROVEMENT_PASTURE',					'YIELD_FOOD',					1,					null,							'TECH_MASS_PRODUCTION'),
	(633,	'IMPROVEMENT_PASTURE',					'YIELD_GOLD',					3,					null,							'TECH_SANITATION'),
	(634,	'IMPROVEMENT_PASTURE',					'YIELD_FOOD',					1,					null,							'TECH_REFRIGERATION_HD'),
	(635,	'IMPROVEMENT_PASTURE',					'YIELD_GOLD',					3,					'CIVIC_FINANCE_HD',							null),
	(636,	'IMPROVEMENT_PASTURE',					'YIELD_GOLD',					3,					null,							'TECH_ADVANCED_FLIGHT'),
	(637,	'IMPROVEMENT_PASTURE',					'YIELD_PRODUCTION',		1,					null,							'TECH_GENETIC_ENGINEERING_HD'),
	(638,	'IMPROVEMENT_PASTURE',					'YIELD_PRODUCTION',		1,					null,							'TECH_ROBOTICS'),

	(640,	'IMPROVEMENT_QUARRY',					'YIELD_PRODUCTION',		1,					null,							'TECH_ENGINEERING'),
	(641,	'IMPROVEMENT_QUARRY',					'YIELD_PRODUCTION',		1,					null,							'TECH_METAL_CASTING'),
	(642,	'IMPROVEMENT_QUARRY',					'YIELD_PRODUCTION',		1,					null,							'TECH_GUNPOWDER'),
	(643,	'IMPROVEMENT_QUARRY',					'YIELD_PRODUCTION',		1,					null,							'TECH_GEOLOGY_HD'),
	(644,	'IMPROVEMENT_QUARRY',					'YIELD_PRODUCTION',		1,					null,							'TECH_STEEL'),
	(645,	'IMPROVEMENT_QUARRY',					'YIELD_PRODUCTION',		1,					'CIVIC_PALEOBIOLOGY_HD',							null),
	(646,	'IMPROVEMENT_QUARRY',					'YIELD_PRODUCTION',		1,					null,							'TECH_INDUSTRIAL_AUTOMATION_HD'),
	(647,	'IMPROVEMENT_QUARRY',					'YIELD_PRODUCTION',		1,					null,							'TECH_SYNTHETIC_MATERIALS'),
	(648,	'IMPROVEMENT_QUARRY',					'YIELD_PRODUCTION',		1,					null,							'TECH_COMPOSITES'),

	(650,	'IMPROVEMENT_MINE',						'YIELD_PRODUCTION',		1,					null,							'TECH_ALCHEMY_HD'),
	(651,	'IMPROVEMENT_MINE',						'YIELD_PRODUCTION',		1,					null,							'TECH_APPRENTICESHIP'),
	(652,	'IMPROVEMENT_MINE',						'YIELD_PRODUCTION',		1,					null,							'TECH_MASS_PRODUCTION'),
	(653,	'IMPROVEMENT_MINE',						'YIELD_PRODUCTION',		1,					null,							'TECH_GEOLOGY_HD'),
	(654,	'IMPROVEMENT_MINE',						'YIELD_PRODUCTION',		1,					null,							'TECH_STEEL'),
	(655,	'IMPROVEMENT_MINE',						'YIELD_PRODUCTION',		1,					'CIVIC_PALEOBIOLOGY_HD',							null),
	(656,	'IMPROVEMENT_MINE',						'YIELD_PRODUCTION',		1,					null,							'TECH_INDUSTRIAL_AUTOMATION_HD'),
	(657,	'IMPROVEMENT_MINE',						'YIELD_PRODUCTION',		1,					null,							'TECH_INTEGRATED_CIRCUIT_HD'),
	(658,	'IMPROVEMENT_MINE',						'YIELD_PRODUCTION',		1,					null,							'TECH_COMPOSITES'),

	(660,	'IMPROVEMENT_LUMBER_MILL',				'YIELD_PRODUCTION',		1,					null,							'TECH_CONSTRUCTION'),
	(661,	'IMPROVEMENT_LUMBER_MILL',				'YIELD_PRODUCTION',		1,					null,							'TECH_MACHINERY'),
	(662,	'IMPROVEMENT_LUMBER_MILL',				'YIELD_PRODUCTION',		1,					null,							'TECH_MASS_PRODUCTION'),
	(663,	'IMPROVEMENT_LUMBER_MILL',				'YIELD_PRODUCTION',		1,					null,							'TECH_CIVIL_ENGINEERING_HD'),
	(664,	'IMPROVEMENT_LUMBER_MILL',				'YIELD_PRODUCTION',		1,					null,							'TECH_BIOLOGY_HD'),
	(665,	'IMPROVEMENT_LUMBER_MILL',				'YIELD_GOLD',					3,					'CIVIC_FINANCE_HD',							null),
	(666,	'IMPROVEMENT_LUMBER_MILL',				'YIELD_GOLD',					3,					null,							'TECH_ADVANCED_FLIGHT'),
	(667,	'IMPROVEMENT_LUMBER_MILL',				'YIELD_PRODUCTION',		1,					null,							'TECH_GENETIC_ENGINEERING_HD'),
	(668,	'IMPROVEMENT_LUMBER_MILL',				'YIELD_PRODUCTION',		1,					null,							'TECH_COMPOSITES'),

	(670,	'IMPROVEMENT_FISHING_BOATS',			'YIELD_FOOD',					1,					null,							'TECH_SHIPBUILDING'),
	(671,	'IMPROVEMENT_FISHING_BOATS',			'YIELD_FOOD',					1,					null,							'TECH_COMPASS_HD'),
	(672,	'IMPROVEMENT_FISHING_BOATS',			'YIELD_PRODUCTION',		1,					null,							'TECH_MASS_PRODUCTION'),
	(673,	'IMPROVEMENT_FISHING_BOATS',			'YIELD_FOOD',					1,					null,							'TECH_OCEANOGRAPHY_HD'),
	(674,	'IMPROVEMENT_FISHING_BOATS',			'YIELD_FOOD',					1,					null,							'TECH_REFRIGERATION_HD'),
	(675,	'IMPROVEMENT_FISHING_BOATS',			'YIELD_FOOD',					1,					null,							'TECH_BIOLOGY_HD'),
	(676,	'IMPROVEMENT_FISHING_BOATS',			'YIELD_PRODUCTION',		1,					null,							'TECH_PLASTICS'),
	(677,	'IMPROVEMENT_FISHING_BOATS',			'YIELD_FOOD',					1,					null,							'TECH_GENETIC_ENGINEERING_HD'),
	(678,	'IMPROVEMENT_FISHING_BOATS',			'YIELD_FOOD',					1,					null,							'TECH_ROBOTICS'),

	(710,	'IMPROVEMENT_FISHERY',		'YIELD_PRODUCTION',	1,								null,												'TECH_TEXTILE_HD'),
	(711,	'IMPROVEMENT_FISHERY',		'YIELD_FOOD',				1,								null,												'TECH_SQUARE_SAIL_HD'),
	(712,	'IMPROVEMENT_FISHERY',		'YIELD_PRODUCTION',	1,								'CIVIC_NAVAL_TRADITION',		null),
	(713,	'IMPROVEMENT_FISHERY',		'YIELD_FOOD',				1,								null,												'TECH_CARTOGRAPHY'),
	(714,	'IMPROVEMENT_FISHERY',		'YIELD_PRODUCTION',	1,								'CIVIC_EXPLORATION',				null),
	(715,	'IMPROVEMENT_FISHERY',		'YIELD_PRODUCTION',	1,								'CIVIC_COLONIALISM',				null),
	(716,	'IMPROVEMENT_FISHERY',		'YIELD_FOOD',				1,								null,												'TECH_REFRIGERATION_HD'),
	(717,	'IMPROVEMENT_FISHERY',		'YIELD_PRODUCTION',	1,								null,												'TECH_BIOLOGY_HD'),
	(718,	'IMPROVEMENT_FISHERY',		'YIELD_FOOD',				1,								null,												'TECH_PLASTICS'),
	(719,	'IMPROVEMENT_FISHERY',		'YIELD_PRODUCTION',	1,								'CIVIC_NEOCOLONIALISM_HD',	null),
	(720,	'IMPROVEMENT_FISHERY',		'YIELD_FOOD',				1,								null,												'TECH_NANOTECHNOLOGY'),

	(800,	'IMPROVEMENT_OIL_WELL',					'YIELD_PRODUCTION',		2,					null,							'TECH_REFINING'),
	(801,	'IMPROVEMENT_OIL_WELL',					'YIELD_SCIENCE',		2,					null,							'TECH_REFINING'),
	(802,	'IMPROVEMENT_OFFSHORE_OIL_RIG',			'YIELD_PRODUCTION',		2,					null,							'TECH_REFINING'),
	(803,	'IMPROVEMENT_OFFSHORE_OIL_RIG',			'YIELD_SCIENCE',		2,					null,							'TECH_REFINING');

-- Adjacency Yield
delete from Improvement_Adjacencies where
	ImprovementType = 'IMPROVEMENT_ICE_HOCKEY_RINK'
	or (ImprovementType = 'IMPROVEMENT_TERRACE_FARM' and YieldChangeId = 'Terrace_AqueductAdjacency')
	or (ImprovementType = 'IMPROVEMENT_CHATEAU' and YieldChangeId = 'Chateau_River')
	or (ImprovementType = 'IMPROVEMENT_CHATEAU' and YieldChangeId = 'Chateau_WonderEarly')
	or (YieldChangeId in ('Terrace_MedievalAdjacency', 'Terrace_MechanizedAdjacency'))
	or ImprovementType = 'IMPROVEMENT_FISHERY';

delete from Adjacency_YieldChanges where ID in (
	'Mekewap_FirstBonusAdjacency',
	'Mekewap_SecondBonusAdjacency',
	'Mekewap_ThirdBonusAdjacency'
);

insert or replace into Improvement_Adjacencies
	(ImprovementType,				YieldChangeId)
values
	('IMPROVEMENT_LUMBER_MILL',		'Lumber_Mill_Industrial_Production'),
	('IMPROVEMENT_MINE',			'Mine_Industrial_Production'),
	('IMPROVEMENT_QUARRY',			'Quarry_Industrial_Production'),
	('IMPROVEMENT_PLANTATION',		'Plantation_Commercial_Gold'),
	('IMPROVEMENT_PLANTATION',		'Plantation_Suguba_Gold'),
	('IMPROVEMENT_PASTURE',			'Pasture_Commercial_Gold'),
	('IMPROVEMENT_PASTURE',			'Pasture_Suguba_Gold'),
	('IMPROVEMENT_CAMP',			'Camp_Commercial_Gold'),
	('IMPROVEMENT_CAMP',			'Camp_Suguba_Gold'),
	('IMPROVEMENT_FISHERY',			'Fishery_Production_from_Fishing_Boat'),
	('IMPROVEMENT_FISHERY',			'Fishery_Food_from_Fishery'),

	('IMPROVEMENT_MEKEWAP',			'Mekewap_Luxury_Production_Tier1'),
	('IMPROVEMENT_MEKEWAP',			'Mekewap_Luxury_Production_Tier2'),
	('IMPROVEMENT_MEKEWAP',			'Mekewap_Strategic_Production_Tier1'),
	('IMPROVEMENT_MEKEWAP',		    'Mekewap_Strategic_Production_Tier2'),
	('IMPROVEMENT_MEKEWAP',		    'Mekewap_Bonus_Food_Tier1'),
	('IMPROVEMENT_MEKEWAP',		    'Mekewap_Bonus_Food_Tier2'),
	('IMPROVEMENT_CHATEAU',			'Chateau_Bonus_Food'),
	('IMPROVEMENT_CHATEAU',			'Chateau_Luxury_Culture'),
	-- 传教团
	('IMPROVEMENT_MISSION',			'Mission_Science_HolySite2'),
	('IMPROVEMENT_MISSION',			'Mission_Science_Campus2'),
	('IMPROVEMENT_MISSION',			'Mission_Science_HolySite3'),
	('IMPROVEMENT_MISSION',			'Mission_Science_Campus3'),
	('IMPROVEMENT_MISSION',			'Mission_CityCenter_Food'),
	('IMPROVEMENT_MISSION',			'Mission_CityCenter_Production'),
	('IMPROVEMENT_MISSION',			'Mission_Neighborhood_Food1'),
	('IMPROVEMENT_MISSION',			'Mission_Neighborhood_Production1'),
	('IMPROVEMENT_MISSION',			'Mission_Neighborhood_Food2'),
	('IMPROVEMENT_MISSION',			'Mission_Neighborhood_Production2'),
	('IMPROVEMENT_MISSION',			'Mission_Neighborhood_Food3'),
	('IMPROVEMENT_MISSION',			'Mission_Neighborhood_Production3');

insert or replace into Adjacency_YieldChanges
	(ID,										Description,	YieldType,			YieldChange,	AdjacentDistrict)
values
	('Lumber_Mill_Industrial_Production',		'Placeholder',	'YIELD_PRODUCTION',	1,				'DISTRICT_INDUSTRIAL_ZONE'),
	('Mine_Industrial_Production',				'Placeholder',	'YIELD_PRODUCTION',	1,				'DISTRICT_INDUSTRIAL_ZONE'),
	('Quarry_Industrial_Production',			'Placeholder',	'YIELD_PRODUCTION',	1,				'DISTRICT_INDUSTRIAL_ZONE'),
	('Plantation_Commercial_Gold', 				'Placeholder',	'YIELD_GOLD',		3,				'DISTRICT_COMMERCIAL_HUB'),
	('Plantation_Suguba_Gold', 					'Placeholder',	'YIELD_GOLD',		3,				'DISTRICT_SUGUBA'),
	('Pasture_Commercial_Gold', 				'Placeholder',	'YIELD_GOLD',		3,				'DISTRICT_COMMERCIAL_HUB'),
	('Pasture_Suguba_Gold', 					'Placeholder',	'YIELD_GOLD',		3,				'DISTRICT_SUGUBA'),
	('Camp_Commercial_Gold', 					'Placeholder',	'YIELD_GOLD',		3,				'DISTRICT_COMMERCIAL_HUB'),
	('Camp_Suguba_Gold', 						'Placeholder',	'YIELD_GOLD',		3,				'DISTRICT_SUGUBA');

update Adjacency_YieldChanges set PrereqTech = 'TECH_CURRENCY' where ID in (
	'Plantation_Commercial_Gold',
	'Plantation_Suguba_Gold',
	'Pasture_Commercial_Gold',
	'Pasture_Suguba_Gold',
	'Camp_Commercial_Gold',
	'Camp_Suguba_Gold'
);

insert or replace into Adjacency_YieldChanges
	(ID,																	Description,		YieldType,						YieldChange,	AdjacentDistrict,				PrereqTech,		        PrereqCivic)
values
	-- 传教团
	('Mission_Science_HolySite2',					'Placeholder',	'YIELD_SCIENCE',			1,						'DISTRICT_HOLY_SITE',		null,									'CIVIC_EXPLORATION'),
	('Mission_Science_Campus2',						'Placeholder',	'YIELD_SCIENCE',			1,						'DISTRICT_CAMPUS',			null,									'CIVIC_EXPLORATION'),
	('Mission_Science_HolySite3',					'Placeholder',	'YIELD_SCIENCE',			1,						'DISTRICT_HOLY_SITE',		null,									'CIVIC_COLONIALISM'),
	('Mission_Science_Campus3',						'Placeholder',	'YIELD_SCIENCE',			1,						'DISTRICT_CAMPUS',			null,									'CIVIC_COLONIALISM'),
	('Mission_CityCenter_Food',						'Placeholder',	'YIELD_FOOD',					1,						'DISTRICT_CITY_CENTER',	null,									null),
	('Mission_CityCenter_Production',			'Placeholder',	'YIELD_PRODUCTION',		1,						'DISTRICT_CITY_CENTER',	null,									null),
	('Mission_Neighborhood_Food1',				'Placeholder',	'YIELD_FOOD',					1,						'DISTRICT_NEIGHBORHOOD',null,									null),
	('Mission_Neighborhood_Production1',	'Placeholder',	'YIELD_PRODUCTION',		1,						'DISTRICT_NEIGHBORHOOD',null,									null),
	('Mission_Neighborhood_Food2',				'Placeholder',	'YIELD_FOOD',					1,						'DISTRICT_NEIGHBORHOOD',null,									'CIVIC_EVOLUTION_THEORY_HD'),
	('Mission_Neighborhood_Production2',	'Placeholder',	'YIELD_PRODUCTION',		1,						'DISTRICT_NEIGHBORHOOD',null,									'CIVIC_EVOLUTION_THEORY_HD'),
	('Mission_Neighborhood_Food3',				'Placeholder',	'YIELD_FOOD',					1,						'DISTRICT_NEIGHBORHOOD','TECH_SANITATION',		null),
	('Mission_Neighborhood_Production3',	'Placeholder',	'YIELD_PRODUCTION',		1,						'DISTRICT_NEIGHBORHOOD','TECH_SANITATION',		null);

insert or replace into Adjacency_YieldChanges
	(ID,																			Description,		YieldType,						YieldChange,	AdjacentImprovement,					PrereqTech,		        				PrereqCivic)
values
	('Fishery_Production_from_Fishing_Boat',	'Placeholder',	'YIELD_PRODUCTION',		1,						'IMPROVEMENT_FISHING_BOATS',	NULL,													NULL),
	('Fishery_Food_from_Fishery',							'Placeholder',	'YIELD_FOOD',					1,						'IMPROVEMENT_FISHERY',				'TECH_CELESTIAL_NAVIGATION',	NULL);

insert or replace into Adjacency_YieldChanges
	(ID,										Description,	YieldType,			YieldChange,	AdjacentResourceClass,		PrereqTech,		        PrereqCivic,            ObsoleteTech,           ObsoleteCivic)
values
	('Mekewap_Luxury_Production_Tier1', 		'Placeholder',	'YIELD_PRODUCTION',	1,				'RESOURCECLASS_LUXURY',		null,			        null,                   'TECH_MASS_PRODUCTION', null),
	('Mekewap_Luxury_Production_Tier2', 		'Placeholder',	'YIELD_PRODUCTION',	2,				'RESOURCECLASS_LUXURY',		'TECH_MASS_PRODUCTION',	null,                   null,                   null),
	('Mekewap_Strategic_Production_Tier1', 		'Placeholder',	'YIELD_PRODUCTION',	1,				'RESOURCECLASS_STRATEGIC',	null,			        null,                   'TECH_MASS_PRODUCTION', null),
	('Mekewap_Strategic_Production_Tier2', 		'Placeholder',	'YIELD_PRODUCTION',	2,				'RESOURCECLASS_STRATEGIC',	'TECH_MASS_PRODUCTION',	null,                   null,                   null),
	('Mekewap_Bonus_Food_Tier1',                'PlaceHolder',  'YIELD_FOOD',       1,              'RESOURCECLASS_BONUS',      null,                   null,                   null,                   'CIVIC_CIVIL_SERVICE'),
	('Mekewap_Bonus_Food_Tier2',                'PlaceHolder',  'YIELD_FOOD',       2,              'RESOURCECLASS_BONUS',      null,                   'CIVIC_CIVIL_SERVICE',  null,                   null),
	('Chateau_Bonus_Food', 					'Placeholder',	'YIELD_FOOD',	1,				'RESOURCECLASS_BONUS',		null,	        null,                   null,                   null),
	('Chateau_Luxury_Culture', 					'Placeholder',	'YIELD_CULTURE',	2,				'RESOURCECLASS_LUXURY',		null,	        null,                   null,                   null);

-- Prereq Tech / Civic
update Improvements set PrereqTech = 'TECH_POTTERY'					where ImprovementType = 'IMPROVEMENT_PLANTATION';
update Improvements set PrereqTech = 'TECH_MINING'					where ImprovementType = 'IMPROVEMENT_LUMBER_MILL';
update Improvements set PrereqTech = 'TECH_MILITARY_ENGINEERING'	where ImprovementType = 'IMPROVEMENT_FORT';
update Improvements set PrereqTech = 'TECH_GEOLOGY_HD'				where ImprovementType = 'IMPROVEMENT_OIL_WELL';
update Improvements set PrereqTech = 'TECH_SYNTHETIC_MATERIALS'		where ImprovementType = 'IMPROVEMENT_OFFSHORE_WIND_FARM';
update Improvements set PrereqTech = 'TECH_GEOLOGY_HD'		where ImprovementType = 'IMPROVEMENT_MOUNTAIN_TUNNEL';

-- Valid Features
insert or replace into Improvement_ValidFeatures
	(ImprovementType,				FeatureType,					PrereqTech,			PrereqCivic)
values
	('IMPROVEMENT_CAMP',			'FEATURE_FOREST',				'TECH_ARCHERY',		null),
	('IMPROVEMENT_CAMP',			'FEATURE_JUNGLE',				null,				'CIVIC_GUILDS'),
	('IMPROVEMENT_LUMBER_MILL',		'FEATURE_JUNGLE',				null,				'CIVIC_GUILDS'),
	('IMPROVEMENT_MINE',			'FEATURE_GEOTHERMAL_FISSURE',	'TECH_ENGINEERING',	null),
	('IMPROVEMENT_FISHERY',			'FEATURE_REEF',					null,				null),

	('IMPROVEMENT_COLOSSAL_HEAD',	'FEATURE_FOREST',				null,				null),
	('IMPROVEMENT_COLOSSAL_HEAD',	'FEATURE_JUNGLE',				null,				null),

	('IMPROVEMENT_MEKEWAP',			'FEATURE_FOREST',				'TECH_MINING',		null);

with I(ImprovementType) as (select ImprovementType from Improvements where ImprovementType in (
	'IMPROVEMENT_GREAT_WALL',
	'IMPROVEMENT_MISSION',
	'IMPROVEMENT_FORT',
	'IMPROVEMENT_ROMAN_FORT',
	'IMPROVEMENT_GOLF_COURSE',
	'IMPROVEMENT_MEKEWAP',
	'IMPROVEMENT_MOAI',
	'IMPROVEMENT_OPEN_AIR_MUSEUM',
	'IMPROVEMENT_MAHAVIHARA', 
	'IMPROVEMENT_BATEY',
	'IMPROVEMENT_HACIENDA',
	'IMPROVEMENT_PAIRIDAEZA',
	'IMPROVEMENT_MONASTERY',
	'IMPROVEMENT_ALCAZAR'
	)),
F(FeatureType) as (select FeatureType from Features where FeatureType in (
	'FEATURE_FLOODPLAINS',
	'FEATURE_FLOODPLAINS_GRASSLAND',
	'FEATURE_FLOODPLAINS_PLAINS'))
insert or replace into Improvement_ValidFeatures
	(ImprovementType,			FeatureType,					PrereqTech)
select
	ImprovementType,			FeatureType,					'TECH_BUTTRESS'
from I cross join F;
update Improvements set Description = '{' || Description || '}{LOC_IMPROVEMENT_BUTTRESS_ON_FLOODLANDS}'	where ImprovementType in (
	'IMPROVEMENT_GREAT_WALL',
	'IMPROVEMENT_MISSION',
	'IMPROVEMENT_FORT',
	'IMPROVEMENT_ROMAN_FORT',
	'IMPROVEMENT_GOLF_COURSE',
	'IMPROVEMENT_MEKEWAP',
	'IMPROVEMENT_MOAI',
	'IMPROVEMENT_OPEN_AIR_MUSEUM',
	'IMPROVEMENT_MAHAVIHARA',
	'IMPROVEMENT_BATEY',
	'IMPROVEMENT_HACIENDA',
	'IMPROVEMENT_PAIRIDAEZA',
	'IMPROVEMENT_MONASTERY',
	'IMPROVEMENT_ALCAZAR'
);

with I(ImprovementType) as (select ImprovementType from Improvements where ImprovementType in (
	'IMPROVEMENT_BATEY',
	'IMPROVEMENT_MAHAVIHARA',
	'IMPROVEMENT_CITY_PARK',
	'IMPROVEMENT_MEKEWAP',
	'IMPROVEMENT_ALCAZAR',
	'IMPROVEMENT_MOUND',
	'IMPROVEMENT_MAORI_PA',
	'IMPROVEMENT_CHEMAMULL',
	'IMPROVEMENT_PAIRIDAEZA',
	'IMPROVEMENT_GREAT_WALL',
	'IMPROVEMENT_GOLF_COURSE',
	'IMPROVEMENT_MISSION',
	'IMPROVEMENT_ROMAN_FORT',
	'IMPROVEMENT_FORT',
	'IMPROVEMENT_OPEN_AIR_MUSEUM',
	'IMPROVEMENT_ZIGGURAT'))
insert or replace into Improvement_ValidFeatures
	(ImprovementType,			FeatureType)
select
	ImprovementType,			'FEATURE_VOLCANIC_SOIL'
from I;

-- Plunder Yield
update Improvements set PlunderType = 'PLUNDER_GOLD', PlunderAmount = 50 where ImprovementType = 'IMPROVEMENT_PLANTATION';
update Improvements set PlunderType = 'PLUNDER_GOLD', PlunderAmount = 50 where ImprovementType = 'IMPROVEMENT_QUARRY';
update Improvements set PlunderType = 'PLUNDER_HEAL' where ImprovementType = 'IMPROVEMENT_PASTURE';

-- Improvement Tourism
delete from Improvement_Tourism where ImprovementType in (
	'IMPROVEMENT_MINE',
	'IMPROVEMENT_ZIGGURAT',
	'IMPROVEMENT_SEASTEAD',
	'IMPROVEMENT_PASTURE',
	'IMPROVEMENT_PLANTATION',
	'IMPROVEMENT_CITY_PARK',
	'IMPROVEMENT_BEACH_RESORT'
);

insert or replace into Improvement_Tourism
	(ImprovementType,			TourismSource,						PrereqTech)
select
	ImprovementType,			'TOURISMSOURCE_CULTURE',	'TECH_FLIGHT'
from Improvements where ImprovementType in (
	'IMPROVEMENT_FORT'
);

insert or replace into Improvement_Tourism
	(ImprovementType,			TourismSource,					PrereqCivic)
select
	ImprovementType, 			'TOURISMSOURCE_GOLD',		'CIVIC_CAPITALISM'
from Improvements where ImprovementType in (
	'IMPROVEMENT_PLANTATION',
	'IMPROVEMENT_CAMP',
	'IMPROVEMENT_PASTURE',
	'IMPROVEMENT_LUMBER_MILL',
	'IMPROVEMENT_MEKEWAP',
	'IMPROVEMENT_POLDER',
	'IMPROVEMENT_LAND_POLDER',
	'IMPROVEMENT_TRADING_DOME',
	'IMPROVEMENT_CITY_PARK',
	'IMPROVEMENT_BEACH_RESORT',
	'IMPROVEMENT_MOUNTAIN_ROAD'
);

insert or replace into Improvement_Tourism
	(ImprovementType,			TourismSource,						PrereqTech)
select
	ImprovementType, 			'TOURISMSOURCE_SCIENCE',	'TECH_FLIGHT'
from Improvements where ImprovementType in (
	'IMPROVEMENT_MAHAVIHARA',
	'IMPROVEMENT_ALCAZAR',
	'IMPROVEMENT_MISSION',
	'IMPROVEMENT_ZIGGURAT'
);

insert or replace into Improvement_Tourism
	(ImprovementType,			TourismSource,						PrereqTech)
select
	ImprovementType, 			'TOURISMSOURCE_FAITH',		'TECH_FLIGHT'
from Improvements where ImprovementType in (
	'IMPROVEMENT_PYRAMID',
	'IMPROVEMENT_MONASTERY'
);

insert or replace into Improvement_Tourism
	(ImprovementType,			TourismSource,							PrereqTech)
select
	ImprovementType, 			'TOURISMSOURCE_PRODUCTION',	'TECH_FLIGHT'
from Improvements where ImprovementType in (
	'IMPROVEMENT_OUTBACK_STATION',
	'IMPROVEMENT_HACIENDA',
	'IMPROVEMENT_SEASTEAD'
);

-- 基础改良提前产
-- Farm
update Adjacency_YieldChanges set PrereqTech = 'TECH_MODERN_AGRICULTURE_HD' where ID = 'Farms_MechanizedAdjacency' or ID = 'Terrace_MechanizedAdjacency';
update Adjacency_YieldChanges set ObsoleteTech = 'TECH_MODERN_AGRICULTURE_HD' where ID = 'Farms_MedievalAdjacency' or ID = 'Terrace_MedievalAdjacency';

delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_FISHERY';
insert or replace into ImprovementModifiers (ImprovementType, ModifierID) values
	-- Plantation
	('IMPROVEMENT_PLANTATION',	'PLANTATION_FRESH_WATER_NO_AQUEDUCT_FEUDALISM_GOLD'),
	('IMPROVEMENT_PLANTATION',	'PLANTATION_AQUEDUCT_NO_FEUDALISM_GOLD'),
	-- Camp
	('IMPROVEMENT_CAMP',				'CAMP_FEATURE_NO_MEDIEVAL_FAIRES_PRODUCTION'),
	-- Pasture
	('IMPROVEMENT_PASTURE',			'PASTURE_HILL_NO_HERALDRY_PRODUCTION'),
	-- Mine
	('IMPROVEMENT_MINE', 				'MINE_NO_APPRENTICESHIP_PRODUCTION'),
	-- Quarry
	('IMPROVEMENT_QUARRY', 			'QUARRY_NO_METAL_CASTING_PRODUCTION'),
	-- Lumber Mill
	('IMPROVEMENT_LUMBER_MILL', 'LUMBER_MILL_NO_MACHINERY_PRODUCTION'),
	-- 渔船
	('IMPROVEMENT_FISHING_BOATS', 'FISHING_BOATS_NO_COMPASS_FOOD');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
	('PLANTATION_FRESH_WATER_NO_AQUEDUCT_FEUDALISM_GOLD',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PLOT_IS_ADJACENT_TO_FRESH_WATER_NOT_AQUEDUCT_NO_FEUDALISM'),
	('PLANTATION_AQUEDUCT_NO_FEUDALISM_GOLD',							'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'IS_ADJACENT_TO_AQUEDUCT_NO_FEUDALISM'),
	('CAMP_FEATURE_NO_MEDIEVAL_FAIRES_PRODUCTION',				'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'HD_HAS_FEATURE_NO_MEDIEVAL_FAIRES'),
	('PASTURE_HILL_NO_HERALDRY_PRODUCTION',								'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'HD_HAS_HILL_NO_HERALDRY'),
	('MINE_NO_APPRENTICESHIP_PRODUCTION',									'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'HD_ADJACENT_TO_MOUNTAIN_NO_APPRENTICESHIP'),
	('QUARRY_NO_METAL_CASTING_PRODUCTION',								'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'HD_HAS_HILL_NO_METAL_CASTING'),
	('LUMBER_MILL_NO_MACHINERY_PRODUCTION',								'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'HD_ADJACENT_TO_RIVER_NO_MACHINERY'),
	('FISHING_BOATS_NO_COMPASS_FOOD',											'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'HD_ADJACENT_TO_LAND_OR_HARBOR_NO_COMPASS');

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('PLANTATION_FRESH_WATER_NO_AQUEDUCT_FEUDALISM_GOLD',	'YieldType',	'YIELD_FOOD'),
	('PLANTATION_FRESH_WATER_NO_AQUEDUCT_FEUDALISM_GOLD',	'Amount',		1),
	('PLANTATION_AQUEDUCT_NO_FEUDALISM_GOLD',							'YieldType',	'YIELD_FOOD'),
	('PLANTATION_AQUEDUCT_NO_FEUDALISM_GOLD',							'Amount',		1),
	('CAMP_FEATURE_NO_MEDIEVAL_FAIRES_PRODUCTION',				'YieldType',	'YIELD_PRODUCTION'),
	('CAMP_FEATURE_NO_MEDIEVAL_FAIRES_PRODUCTION',				'Amount',		1),
	('PASTURE_HILL_NO_HERALDRY_PRODUCTION',								'YieldType',	'YIELD_PRODUCTION'),
	('PASTURE_HILL_NO_HERALDRY_PRODUCTION',								'Amount',		1),
	('MINE_NO_APPRENTICESHIP_PRODUCTION',									'YieldType',	'YIELD_PRODUCTION'),
	('MINE_NO_APPRENTICESHIP_PRODUCTION',									'Amount',		1),
	('QUARRY_NO_METAL_CASTING_PRODUCTION',								'YieldType',	'YIELD_PRODUCTION'),
	('QUARRY_NO_METAL_CASTING_PRODUCTION',								'Amount',		1),
	('LUMBER_MILL_NO_MACHINERY_PRODUCTION',								'YieldType',	'YIELD_PRODUCTION'),
	('LUMBER_MILL_NO_MACHINERY_PRODUCTION',								'Amount',		1),
	('FISHING_BOATS_NO_COMPASS_FOOD',											'YieldType',	'YIELD_FOOD'),
	('FISHING_BOATS_NO_COMPASS_FOOD',											'Amount',		1);

-- 渔场
-- insert or ignore into ImprovementModifiers
-- 	(ImprovementType,			ModifierId)
-- values
-- 	('IMPROVEMENT_FISHERY',		'FISHERY_EXTRA_PRODUCTION_ON_FEATURE');
-- insert or ignore into Modifiers
-- 	(ModifierID,									ModifierType,											SubjectRequirementSetId)
-- values
-- 	('FISHERY_EXTRA_PRODUCTION_ON_FEATURE',				'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',				'HD_PLOT_HAS_FEATURE_REQUIREMENTS');
-- insert or ignore into ModifierArguments
-- 	(ModifierID,									Name,				Value)
-- values
-- 	('FISHERY_EXTRA_PRODUCTION_ON_FEATURE',				'YieldType',	'YIELD_PRODUCTION'),
-- 	('FISHERY_EXTRA_PRODUCTION_ON_FEATURE',				'Amount',		1);

-- City State UI
-- Cahokia Mounds
update Modifiers set SubjectRequirementSetId = null, SubjectStackLimit = 2 where ModifierId = 'MOUND_AMENITY_MAX_ONE';
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_MOUND' and (ModifierId = 'MOUND_AMENITY_MAX_TWO' or ModifierId = 'MOUND_HOUSING');
update Adjacency_YieldChanges set TilesRequired = 1, PrereqCivic = null, ObsoleteTech = null, ObsoleteCivic = 'CIVIC_HISTORICAL_PHILOSOPHY_HD' where ID = 'Mound_MedievalAdjacency';
update Adjacency_YieldChanges set YieldChange = 2, PrereqTech = null, PrereqCivic = 'CIVIC_HISTORICAL_PHILOSOPHY_HD' where ID = 'Mound_MechanizedAdjacency';

-- Alcázar
update Improvements set YieldFromAppealPercent = 100 where ImprovementType ='IMPROVEMENT_ALCAZAR';

-- Nazca Line
update Improvements set SameAdjacentValid = 0 where ImprovementType = 'IMPROVEMENT_NAZCA_LINE';
update ModifierArguments set Value = 'YIELD_FOOD' where ModifierId = 'NAZCA_LINE_ADJACENCY_FAITH' and Name = 'YieldType';
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_NAZCA_LINE' and ModifierId in (
	'NAZCA_LINE_ADJACENCY_FOOD_DESERT_CIVIL_SERVICE',
	'NAZCA_LINE_ADJACENCY_FOOD_DESERT_HILLS_CIVIL_SERVICE',
	'NAZCA_LINE_ADJACENCY_PRODUCTION_FLAT_MASS_PRODUCTION');
insert or replace into ImprovementModifiers
 	(ImprovementType,			ModifierId)
values
	('IMPROVEMENT_NAZCA_LINE',	'NAZCA_LINE_FRESH_WATER'),
	('IMPROVEMENT_NAZCA_LINE',	'NAZCA_LINE_ENGINEERING_ADJACENCY_FOOD'),
	('IMPROVEMENT_NAZCA_LINE',	'NAZCA_LINE_MASS_PRODUCTION_ADJACENCY_PRODUCTION');
insert or replace into GameModifiers
	(ModifierId)
values
	('NAZCA_LINE_HOLY_SITE_ADJACENCY'),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY_LATE'),
	('NAZCA_LINE_CAMPUS_ADJACENCY'),
	('NAZCA_LINE_CAMPUS_ADJACENCY_LATE'),
	('NAZCA_LINE_THEATER_ADJACENCY'),
	('NAZCA_LINE_THEATER_ADJACENCY_LATE');
insert or replace into Modifiers
 	(ModifierId,											ModifierType,											SubjectRequirementSetId,									SubjectStackLimit)
values
	('NAZCA_LINE_FRESH_WATER',								'MODIFIER_PLAYER_CITIES_ADJUST_IMPROVEMENT_HOUSING',	'REQUIRE_PLOT_ADJACENT_TO_OWNER',							1),
	('NAZCA_LINE_ENGINEERING_ADJACENCY_FOOD',				'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',	    			'PLOT_ADJACENT_TO_OWNER_AND_PLAYER_HAS_ENGINEERING',		null),
	('NAZCA_LINE_MASS_PRODUCTION_ADJACENCY_PRODUCTION',		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',					'PLOT_ADJACENT_TO_OWNER_AND_PLAYER_HAS_MASS_PRODUCTION',	null),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY',						'MODIFIER_ALL_CITIES_IMPROVEMENT_ADJACENCY',			'PLAYER_HAS_NO_CIVIC_NATURAL_HISTORY_REQUIREMENTS',			null),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY_LATE',					'MODIFIER_ALL_CITIES_IMPROVEMENT_ADJACENCY',			'PLAYER_HAS_CIVIC_NATURAL_HISTORY_REQUIREMENTS',			null),
	('NAZCA_LINE_CAMPUS_ADJACENCY',							'MODIFIER_ALL_CITIES_IMPROVEMENT_ADJACENCY',			'PLAYER_HAS_NO_CIVIC_NATURAL_HISTORY_REQUIREMENTS',			null),
	('NAZCA_LINE_CAMPUS_ADJACENCY_LATE',					'MODIFIER_ALL_CITIES_IMPROVEMENT_ADJACENCY',			'PLAYER_HAS_CIVIC_NATURAL_HISTORY_REQUIREMENTS',			null),
	('NAZCA_LINE_THEATER_ADJACENCY',						'MODIFIER_ALL_CITIES_IMPROVEMENT_ADJACENCY',			'PLAYER_HAS_NO_CIVIC_NATURAL_HISTORY_REQUIREMENTS',			null),
	('NAZCA_LINE_THEATER_ADJACENCY_LATE',					'MODIFIER_ALL_CITIES_IMPROVEMENT_ADJACENCY',			'PLAYER_HAS_CIVIC_NATURAL_HISTORY_REQUIREMENTS',			null);
insert or replace into ModifierArguments
	(ModifierId,											Name,			        Value)
values
	('NAZCA_LINE_FRESH_WATER',								'Amount',				2),
	('NAZCA_LINE_ENGINEERING_ADJACENCY_FOOD',				'YieldType',			'YIELD_FOOD'),
	('NAZCA_LINE_ENGINEERING_ADJACENCY_FOOD',				'Amount',				1),
	('NAZCA_LINE_MASS_PRODUCTION_ADJACENCY_PRODUCTION',		'YieldType',			'YIELD_PRODUCTION'),
	('NAZCA_LINE_MASS_PRODUCTION_ADJACENCY_PRODUCTION',		'Amount',				1),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY',						'DistrictType',			'DISTRICT_HOLY_SITE'),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY',						'ImprovementType',		'IMPROVEMENT_NAZCA_LINE'),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY',						'YieldType',			'YIELD_FAITH'),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY',						'Amount',				1),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY',						'Description',			'LOC_NAZCA_LINE_HOLY_SITE_ADJACENCY_DESCRIPTION'),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY_LATE',					'DistrictType',			'DISTRICT_HOLY_SITE'),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY_LATE',					'ImprovementType',		'IMPROVEMENT_NAZCA_LINE'),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY_LATE',					'YieldType',			'YIELD_FAITH'),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY_LATE',					'Amount',				2),
	('NAZCA_LINE_HOLY_SITE_ADJACENCY_LATE',					'Description',			'LOC_NAZCA_LINE_HOLY_SITE_ADJACENCY_DESCRIPTION'),
	('NAZCA_LINE_CAMPUS_ADJACENCY',							'DistrictType',			'DISTRICT_CAMPUS'),
	('NAZCA_LINE_CAMPUS_ADJACENCY',							'ImprovementType',		'IMPROVEMENT_NAZCA_LINE'),
	('NAZCA_LINE_CAMPUS_ADJACENCY',							'YieldType',			'YIELD_SCIENCE'),
	('NAZCA_LINE_CAMPUS_ADJACENCY',							'Amount',				1),
	('NAZCA_LINE_CAMPUS_ADJACENCY',							'Description',			'LOC_NAZCA_LINE_CAMPUS_ADJACENCY_DESCRIPTION'),
	('NAZCA_LINE_CAMPUS_ADJACENCY_LATE',					'DistrictType',			'DISTRICT_CAMPUS'),
	('NAZCA_LINE_CAMPUS_ADJACENCY_LATE',					'ImprovementType',		'IMPROVEMENT_NAZCA_LINE'),
	('NAZCA_LINE_CAMPUS_ADJACENCY_LATE',					'YieldType',			'YIELD_SCIENCE'),
	('NAZCA_LINE_CAMPUS_ADJACENCY_LATE',					'Amount',				2),
	('NAZCA_LINE_CAMPUS_ADJACENCY_LATE',					'Description',			'LOC_NAZCA_LINE_CAMPUS_ADJACENCY_DESCRIPTION'),
	('NAZCA_LINE_THEATER_ADJACENCY',						'DistrictType',			'DISTRICT_THEATER'),
	('NAZCA_LINE_THEATER_ADJACENCY',						'ImprovementType',		'IMPROVEMENT_NAZCA_LINE'),
	('NAZCA_LINE_THEATER_ADJACENCY',						'YieldType',			'YIELD_CULTURE'),
	('NAZCA_LINE_THEATER_ADJACENCY',						'Amount',				1),
	('NAZCA_LINE_THEATER_ADJACENCY',						'Description',			'LOC_NAZCA_LINE_THEATER_ADJACENCY_DESCRIPTION'),
	('NAZCA_LINE_THEATER_ADJACENCY_LATE',					'DistrictType',			'DISTRICT_THEATER'),
	('NAZCA_LINE_THEATER_ADJACENCY_LATE',					'ImprovementType',		'IMPROVEMENT_NAZCA_LINE'),
	('NAZCA_LINE_THEATER_ADJACENCY_LATE',					'YieldType',			'YIELD_CULTURE'),
	('NAZCA_LINE_THEATER_ADJACENCY_LATE',					'Amount',				2),
	('NAZCA_LINE_THEATER_ADJACENCY_LATE',					'Description',			'LOC_NAZCA_LINE_THEATER_ADJACENCY_DESCRIPTION');
insert or replace into RequirementSets
	(RequirementSetId,											RequirementSetType)
values
	('PLOT_ADJACENT_TO_OWNER_AND_PLAYER_HAS_ENGINEERING',		'REQUIREMENTSET_TEST_ALL'),
	('PLOT_ADJACENT_TO_OWNER_AND_PLAYER_HAS_MASS_PRODUCTION',	'REQUIREMENTSET_TEST_ALL');
insert or replace into RequirementSetRequirements
	(RequirementSetId,											RequirementId)
values
	('PLOT_ADJACENT_TO_OWNER_AND_PLAYER_HAS_ENGINEERING',		'ADJACENT_TO_OWNER'),
	('PLOT_ADJACENT_TO_OWNER_AND_PLAYER_HAS_ENGINEERING',		'HD_REQUIRES_PLAYER_HAS_TECH_ENGINEERING'),
	('PLOT_ADJACENT_TO_OWNER_AND_PLAYER_HAS_MASS_PRODUCTION',	'ADJACENT_TO_OWNER'),
	('PLOT_ADJACENT_TO_OWNER_AND_PLAYER_HAS_MASS_PRODUCTION',	'HD_REQUIRES_PLAYER_HAS_TECH_MASS_PRODUCTION');

-- Mahavihara
delete from TraitModifiers where TraitType = 'MINOR_CIV_NALANDA_TRAIT' and ModifierId = 'MINOR_CIV_NALANDA_FREE_TECHNOLOGY';
update Adjacency_YieldChanges set PrereqTech = null, PrereqCivic = 'CIVIC_DIVINE_RIGHT' where ID = 'Mahavihara_Campus_Science_Late' or ID = 'Mahavihara_Observatory_Science_Late';
update Adjacency_YieldChanges set ObsoleteTech = null, ObsoleteCivic = 'CIVIC_DIVINE_RIGHT' where ID = 'Mahavihara_Campus_Science_Early' or ID = 'Mahavihara_Observatory_Science_Early';
update Adjacency_YieldChanges set YieldType = 'YIELD_SCIENCE', ObsoleteCivic = 'CIVIC_DIVINE_RIGHT' where ID = 'Mahavihara_Holy_Site_Faith';
update Adjacency_YieldChanges set YieldType = 'YIELD_SCIENCE', ObsoleteCivic = 'CIVIC_DIVINE_RIGHT' where ID = 'Mahavihara_Lavra_Faith';

-- Civilization UI
-- Mekewap (Cree)
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_MEKEWAP' and ModifierId = 'MEKEWAP_LUXURY_GOLD';
update ModifierArguments set Value = 'YIELD_PRODUCTION' where ModifierId = 'MEKEWAP_LUXURY_GOLD' and Name = 'YieldType';
insert or replace into Improvement_YieldChanges
	(ImprovementType,					YieldType,				YieldChange)
values
	('IMPROVEMENT_MEKEWAP',		        'YIELD_PRODUCTION',		1),
	('IMPROVEMENT_MEKEWAP',		        'YIELD_GOLD',			2);

-- =====================================================================================================================================
-- 苏美尔 金字形神塔
-- =====================================================================================================================================
delete from Improvement_BonusYieldChanges where ImprovementType = 'IMPROVEMENT_ZIGGURAT';
insert or ignore into ImprovementsNeedCount_HD (ImprovementType) values ('IMPROVEMENT_ZIGGURAT');
delete from ImprovementModifiers where ModifierId = 'ZIGGURAT_RIVERADJACENCY_CULTURE' and ImprovementType = 'IMPROVEMENT_ZIGGURAT';

insert or replace into ImprovementModifiers (ImprovementType, ModifierID) values
	('IMPROVEMENT_ZIGGURAT', 'HD_ZIGGURAT_GREAT_PROPHET_POINTS');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
	('HD_ZIGGURAT_GREAT_PROPHET_POINTS',	'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',	'HD_IS_ADJACENT_CITY_CENTER_REQUIREMENTS'),
	('HD_CAPITAL_ALLOW_EXTRA_ZIGGURAT',		'MODIFIER_PLAYER_CAPITAL_CITY_ADJUST_PROPERTY',								NULL);

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('HD_ZIGGURAT_GREAT_PROPHET_POINTS',	'GreatPersonClassType',	'GREAT_PERSON_CLASS_PROPHET'),
	('HD_ZIGGURAT_GREAT_PROPHET_POINTS',	'Amount',								2),
	('HD_CAPITAL_ALLOW_EXTRA_ZIGGURAT',		'Key',									'HD_CITY_ALLOW_EXTRA_IMPROVEMENT_ZIGGURAT'),
	('HD_CAPITAL_ALLOW_EXTRA_ZIGGURAT',		'Amount',								1);

-- 完成城邦特殊任务加产
insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	select 'HD_ZIGGURAT_LEADER_MINOR_CIV_' || CityStateType || '_BONUS', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_HAS_IMPROVEMENT_ZIGGURAT_REQUIREMENTS'
from CityStateCorrespondingYieldType_HD;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_ZIGGURAT_LEADER_MINOR_CIV_' || CityStateType || '_BONUS', 'YieldType', YieldType
from CityStateCorrespondingYieldType_HD;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_ZIGGURAT_LEADER_MINOR_CIV_' || CityStateType || '_BONUS', 'Amount', Amount
from CityStateCorrespondingYieldType_HD;

-- 沿河加产
insert or replace into Improvement_Adjacencies (ImprovementType, YieldChangeId) values
	('IMPROVEMENT_ZIGGURAT', 'HD_Ziggurat_River_Culture'),
	('IMPROVEMENT_ZIGGURAT', 'HD_Ziggurat_River_Faith');

insert or replace into Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, AdjacentRiver) values
	('HD_Ziggurat_River_Culture',	'Placeholder',	'YIELD_CULTURE',	1,	1),
	('HD_Ziggurat_River_Faith',		'Placeholder',	'YIELD_FAITH',		1,	1);

-- 建造圣地建筑允许额外建造金字形神塔
insert or replace into TraitModifiers (TraitType,	ModifierId)
	select distinct 'TRAIT_LEADER_MAJOR_CIV', 'HD_CITY_ALLOW_EXTRA_ZIGGURAT_FROM_TIER_' || Tier || '_HOLY_SITE_BUILDING'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	select distinct 'HD_CITY_ALLOW_EXTRA_ZIGGURAT_FROM_TIER_' || Tier || '_HOLY_SITE_BUILDING', 'MODIFIER_PLAYER_CITIES_ADJUST_PROPERTY', 'CITY_HAS_DISTRICT_HOLY_SITE_TIER_' || Tier || '_BUILDING_REQUIREMENTS'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select distinct 'HD_CITY_ALLOW_EXTRA_ZIGGURAT_FROM_TIER_' || Tier || '_HOLY_SITE_BUILDING', 'Key', 'HD_CITY_ALLOW_EXTRA_IMPROVEMENT_ZIGGURAT'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select distinct 'HD_CITY_ALLOW_EXTRA_ZIGGURAT_FROM_TIER_' || Tier || '_HOLY_SITE_BUILDING', 'Amount', 1
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

-- =====================================================================================================================================
-- 斯基泰 坟墩
-- =====================================================================================================================================
update Improvements set PrereqTech = null, PrereqCivic = 'CIVIC_FUNERAL_HD' where ImprovementType = 'IMPROVEMENT_KURGAN';
insert or replace into ImprovementModifiers
	(ImprovementType,		ModifierId)
values
	('IMPROVEMENT_KURGAN',	'KURGAN_PASTURE_FAITH'),
	('IMPROVEMENT_KURGAN',	'KURGAN_PURCHASE_LIGHT_CAVALRY'),
	('IMPROVEMENT_KURGAN',	'KURGAN_PURCHASE_HEAVY_CAVALRY');
insert or replace into Modifiers
	(ModifierId,						ModifierType,										SubjectRequirementSetId)
values
	('KURGAN_PASTURE_FAITH',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',				'PLOT_HAS_IMPROVEMENT_PASTURE_AND_ADJACENT_TO_OWNER_REQUIREMENTS'),
	('KURGAN_PURCHASE_LIGHT_CAVALRY',	'MODIFIER_SINGLE_CITY_ENABLE_UNIT_FAITH_PURCHASE',	null),
	('KURGAN_PURCHASE_HEAVY_CAVALRY',	'MODIFIER_SINGLE_CITY_ENABLE_UNIT_FAITH_PURCHASE',	null),
	('KURGAN_GENERAL_FAITH',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',				'PLOT_HAS_IMPROVEMENT_KURGAN_REQUIREMENTS'),
	('KURGAN_CAVALRY_FAITH',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',				'PLOT_HAS_IMPROVEMENT_KURGAN_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,						Name,			Value)
values
	('KURGAN_PASTURE_FAITH',			'YieldType',	'YIELD_FAITH'),
	('KURGAN_PASTURE_FAITH',			'Amount',		1),
	('KURGAN_PURCHASE_LIGHT_CAVALRY',	'Tag',			'CLASS_LIGHT_CAVALRY'),
	('KURGAN_PURCHASE_HEAVY_CAVALRY',	'Tag',			'CLASS_HEAVY_CAVALRY'),
	('KURGAN_GENERAL_FAITH',			'YieldType',	'YIELD_FAITH'),
	('KURGAN_GENERAL_FAITH',			'Amount',		2),
	('KURGAN_CAVALRY_FAITH',			'YieldType',	'YIELD_FAITH'),
	('KURGAN_CAVALRY_FAITH',			'Amount',		1);

-- 印加梯田
insert or replace into Improvement_ValidTerrains
	(ImprovementType,				TerrainType)
values
	('IMPROVEMENT_TERRACE_FARM',	'TERRAIN_GRASS_MOUNTAIN'),
	('IMPROVEMENT_TERRACE_FARM',	'TERRAIN_PLAINS_MOUNTAIN'),
	('IMPROVEMENT_TERRACE_FARM',	'TERRAIN_DESERT_MOUNTAIN'),
	('IMPROVEMENT_TERRACE_FARM',	'TERRAIN_TUNDRA_HILLS'),
	('IMPROVEMENT_TERRACE_FARM',	'TERRAIN_TUNDRA_MOUNTAIN');
insert or replace into Improvement_ValidFeatures
	(ImprovementType,				FeatureType)
values
	('IMPROVEMENT_TERRACE_FARM',	'FEATURE_VOLCANO');
insert or replace into Improvements_XP2
	(ImprovementType,				BuildOnAdjacentPlot)
values
	('IMPROVEMENT_TERRACE_FARM',	1);
-- update Adjacency_YieldChanges set ObsoleteTech = 'TECH_ENGINEERING' where ID like 'Terrace_%MountainAdjacency';
insert or replace into Improvement_ValidResources
	(ImprovementType,						ResourceType,		MustRemoveFeature)
select
	'IMPROVEMENT_TERRACE_FARM',	ResourceType,  	0
from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_FARM' or ImprovementType = 'IMPROVEMENT_PASTURE';
update Improvements set Housing = 1, TilesRequired = 1 where ImprovementType = 'IMPROVEMENT_TERRACE_FARM';
insert or replace into ImprovementsRules_HD (ImprovementType) values ('IMPROVEMENT_TERRACE_FARM');

update Modifiers set SubjectRequirementSetId = 'PLOT_IS_FRESH_WATER_OR_AQUEDUCT_REQUIREMENTS' where ModifierId = 'TERRACE_FARM_PRODUCTION_FRESH_WATER_NO_AQUEDUCT';
-- insert or replace into ImprovementModifiers
-- 	(ImprovementType, 						ModifierId)
-- values
-- 	('IMPROVEMENT_TERRACE_FARM',	'HD_TERRACE_FARM_AQUEDUCT_PRODUCTION');

-- insert or replace into Modifiers
-- 	(ModifierId,															ModifierType,																SubjectRequirementSetId)
-- values
-- 	('HD_TERRACE_FARM_AQUEDUCT_PRODUCTION',		'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'REQUIRES_CITY_HAS_DISTRICT_AQUEDUCT_UDMET');

-- insert or replace into ModifierArguments
-- 	(ModifierId,															Name,							Value)
-- values
-- 	('HD_TERRACE_FARM_AQUEDUCT_PRODUCTION',		'YieldType',			'YIELD_PRODUCTION'),
-- 	('HD_TERRACE_FARM_AQUEDUCT_PRODUCTION',		'Amount',					1);

-- insert or replace into ImprovementModifiers (ImprovementType, ModifierId)
-- 	select 'IMPROVEMENT_TERRACE_FARM', 'HD_TERRACE_FARM_' || BuildingType || '_BONUS'
-- from Buildings where PrereqDistrict = 'DISTRICT_AQUEDUCT'
-- 	and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
-- 	and BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

-- insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
-- 	select 'HD_TERRACE_FARM_' || BuildingType || '_BONUS', 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'CITY_HAS_' || BuildingType || '_REQUIREMENTS'
-- from Buildings where PrereqDistrict = 'DISTRICT_AQUEDUCT'
-- 	and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
-- 	and BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

-- insert or replace into ModifierArguments (ModifierId, Name, Value)
-- 	select 'HD_TERRACE_FARM_' || BuildingType || '_BONUS', 'YieldType', 'YIELD_PRODUCTION'
-- from Buildings where PrereqDistrict = 'DISTRICT_AQUEDUCT'
-- 	and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
-- 	and BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

-- insert or replace into ModifierArguments (ModifierId, Name, Value)
-- 	select 'HD_TERRACE_FARM_' || BuildingType || '_BONUS', 'Amount', 1
-- from Buildings where PrereqDistrict = 'DISTRICT_AQUEDUCT'
-- 	and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
-- 	and BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

-- 印加路网
update Improvements set PrereqCivic = NULL where ImprovementType = 'IMPROVEMENT_MOUNTAIN_ROAD';
insert or replace into Improvement_ValidBuildUnits
	(ImprovementType,							UnitType)
select
	'IMPROVEMENT_MOUNTAIN_ROAD',	UnitType
from Units where PromotionClass = 'PROMOTION_CLASS_RECON';

insert or replace into Improvement_YieldChanges
	(ImprovementType,							YieldType,						YieldChange)
values
	('IMPROVEMENT_MOUNTAIN_ROAD',	'YIELD_PRODUCTION',		2),
	('IMPROVEMENT_MOUNTAIN_ROAD',	'YIELD_GOLD',					3);

insert or replace into Modifiers
	(ModifierId,											ModifierType,																						SubjectRequirementSetId)
values
	('HD_MOUNTAIN_ROAD_YIELD',				'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',					'PLOT_HAS_IMPROVEMENT_MOUNTAIN_ROAD_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,											Name,							Value)
values
	('HD_MOUNTAIN_ROAD_YIELD',				'YieldType',			'YIELD_GOLD,YIELD_PRODUCTION'),
	('HD_MOUNTAIN_ROAD_YIELD',				'Amount',					'1,1');

insert or replace into ImprovementModifiers (ImprovementType, ModifierId)
	select ImprovementType, 'HD_MOUNTAIN_ROAD_YIELD'
from HD_Improvement_Classification where ImprovementClassificationType = 'IMPROVEMENT_CLASSIFICATION_TRANSPORTATION_FACILITIES' and ImprovementType != 'IMPROVEMENT_MOUNTAIN_ROAD';

insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select BuildingType, 'HD_MOUNTAIN_ROAD_YIELD'
from HD_Building_Classification where BuildingClassificationType = 'BUILDING_CLASSIFICATION_TRANSPORTATION_FACILITIES';

insert or replace into DistrictModifiers (DistrictType, ModifierId)
	select DistrictType, 'HD_MOUNTAIN_ROAD_YIELD'
from HD_District_Classification where DistrictClassificationType = 'DISTRICT_CLASSIFICATION_TRANSPORTATION_FACILITIES';

-- Sphinx (Egypt)
-- In order to adapt the wonder yield change made in UpdateDatabse/DL_Wonders.sql at LoadOrder 16010, Modifiers about adjacent wonders are written in UpdateDatabse/DL_PostProcess.sql, which is at LoadOrder 20000
delete from Improvement_BonusYieldChanges where ImprovementType = 'IMPROVEMENT_SPHINX';
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_SPHINX' and ModifierId = 'SPHINX_WONDERADJACENCY_FAITH';
insert or replace into Improvement_YieldChanges
	(ImprovementType,					YieldType,				YieldChange)
values
	('IMPROVEMENT_SPHINX',		        'YIELD_CULTURE',		1),
	('IMPROVEMENT_SPHINX',		        'YIELD_FAITH',			2);

--insert or replace into ImprovementModifiers
--	(ImprovementType,		ModifierId)
--values
--	('IMPROVEMENT_SPHINX',	'SPHINX_FARM_FOOD'),
--	('IMPROVEMENT_SPHINX',	'SPHINX_RIVER_FASTER_BUILDTIME_DISTRICT'),
--	('IMPROVEMENT_SPHINX',	'SPHINX_RIVER_FASTER_BUILDTIME_WONDER'),
--	('IMPROVEMENT_SPHINX',	'SPHINX_FASTER_BUILDTIME_DISTRICT'),
--	('IMPROVEMENT_SPHINX',	'SPHINX_FASTER_BUILDTIME_WONDER');
--insert or replace into Modifiers
--	(ModifierId,								ModifierType,												OwnerRequirementSetId,							SubjectRequirementSetId,						SubjectStackLimit)
--values
--	('SPHINX_FARM_FOOD',						'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',						null,											'PLOT_HAS_IMPROVEMENT_FARM_AND_ADJACENT_TO_OWNER_REQUIREMENTS',			null),
--	('SPHINX_RIVER_FASTER_BUILDTIME_DISTRICT',	'MODIFIER_SINGLE_CITY_ADJUST_RIVER_DISTRICT_PRODUCTION',	'PLOT_IS_FLOODPLIANS_ADJACENT_TO_CITY_CENTER',	'PLAYER_DOES_NOT_HAVE_GREAT_BATH_REQUIREMENTS',	1),
--	('SPHINX_RIVER_FASTER_BUILDTIME_WONDER',	'MODIFIER_SINGLE_CITY_ADJUST_RIVER_WONDER_PRODUCTION',		'PLOT_IS_FLOODPLIANS_ADJACENT_TO_CITY_CENTER',	'PLAYER_DOES_NOT_HAVE_GREAT_BATH_REQUIREMENTS',	1),
--	('SPHINX_FASTER_BUILDTIME_DISTRICT',		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',						'PLOT_IS_FLOODPLIANS_ADJACENT_TO_CITY_CENTER',	null,											1),
--	('SPHINX_FASTER_BUILDTIME_WONDER',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',						'PLOT_IS_FLOODPLIANS_ADJACENT_TO_CITY_CENTER',	null,											1);
--insert or replace into ModifierArguments
--	(ModifierId,								Name,			Value)
--values
--	('SPHINX_FARM_FOOD',						'YieldType',	'YIELD_FOOD'),
--	('SPHINX_FARM_FOOD',						'Amount',		1),
--	('SPHINX_RIVER_FASTER_BUILDTIME_DISTRICT',	'Amount',		15),
--	('SPHINX_RIVER_FASTER_BUILDTIME_WONDER',	'Amount',		15),
--	('SPHINX_FASTER_BUILDTIME_DISTRICT',		'Amount',		15),
--	('SPHINX_FASTER_BUILDTIME_WONDER',			'Amount',		15);
--insert or replace into RequirementSets
--	(RequirementSetId,								RequirementSetType)
--values
--	('PLOT_IS_FLOODPLIANS_ADJACENT_TO_CITY_CENTER',	'REQUIREMENTSET_TEST_ALL');
--insert or replace into RequirementSetRequirements
--	(RequirementSetId,								RequirementId)
--values
--	('PLOT_IS_FLOODPLIANS_ADJACENT_TO_CITY_CENTER',	'REQUIRES_PLOT_HAS_FLOODPLAINS_TAG'),
--	('PLOT_IS_FLOODPLIANS_ADJACENT_TO_CITY_CENTER',	'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_CITY_CENTER');

-- Chemamull (Mapuche)
update Improvements set MinimumAppeal = 2, PrereqCivic = 'CIVIC_FUNERAL_HD' where ImprovementType = 'IMPROVEMENT_CHEMAMULL';
update Improvements set YieldFromAppealPercent = 100 where ImprovementType = 'IMPROVEMENT_CHEMAMULL';

-- Stepwell (India)
update Improvements set PrereqTech = 'TECH_MINING' where ImprovementType = 'IMPROVEMENT_STEPWELL';
update Improvement_BonusYieldChanges set PrereqCivic = null, PrereqTech = 'TECH_SANITATION' where ImprovementType = 'IMPROVEMENT_STEPWELL' and YieldType = 'YIELD_FOOD';
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_STEPWELL' and ModifierId = 'STEPWELL_FARMADJACENCY_FOOD';
update Improvement_YieldChanges set YieldChange = 2 where ImprovementType = 'IMPROVEMENT_STEPWELL' and YieldType = 'YIELD_FOOD';
delete from ImprovementModifiers where ModifierId = 'STEPWELL_HOLYSITEADJACENCY_FAITH' or ModifierId = 'STEPWELL_HOUSING_WITHTECH';
delete from Improvement_BonusYieldChanges where ImprovementType = 'IMPROVEMENT_STEPWELL';
insert or replace into Improvement_ValidFeatures
	(ImprovementType,					FeatureType)
values
	('IMPROVEMENT_STEPWELL',	'FEATURE_FLOODPLAINS'),
	('IMPROVEMENT_STEPWELL',	'FEATURE_FLOODPLAINS_GRASSLAND'),
	('IMPROVEMENT_STEPWELL',	'FEATURE_FLOODPLAINS_PLAINS');

insert or replace into Improvement_ValidTerrains
	(ImprovementType,					TerrainType,							PrereqTech)
values
	('IMPROVEMENT_STEPWELL',	'TERRAIN_DESERT_HILLS',		'TECH_MASONRY'),
	('IMPROVEMENT_STEPWELL',	'TERRAIN_TUNDRA_HILLS',		'TECH_MASONRY'),
	('IMPROVEMENT_STEPWELL',	'TERRAIN_PLAINS_HILLS',		'TECH_MASONRY'),
	('IMPROVEMENT_STEPWELL',	'TERRAIN_GRASS_HILLS',		'TECH_MASONRY'),
	('IMPROVEMENT_STEPWELL',	'TERRAIN_SNOW_HILLS',			'TECH_MASONRY');

--adjacency
insert or replace into Improvement_Adjacencies
	(ImprovementType,				YieldChangeId)
values
	('IMPROVEMENT_STEPWELL',		'STEPWELL_HOLY_SITE_ADJACENCY_FAITH_TIER1'),
	('IMPROVEMENT_STEPWELL',		'STEPWELL_HOLY_SITE_ADJACENCY_FAITH_TIER2'),
	('IMPROVEMENT_STEPWELL',		'STEPWELL_FARM_ADJACENCY_FAITH_TIER1'),
	('IMPROVEMENT_STEPWELL',		'STEPWELL_FARM_ADJACENCY_FAITH_TIER2'),
	('IMPROVEMENT_STEPWELL',		'STEPWELL_PLANTATION_ADJACENCY_FAITH_TIER1'),
	('IMPROVEMENT_STEPWELL',		'STEPWELL_PLANTATION_ADJACENCY_FAITH_TIER2');

insert or replace into Adjacency_YieldChanges
	(ID,											Description,		YieldType,			YieldChange,	AdjacentDistrict,		PrereqCivic,			ObsoleteCivic)
values
	('STEPWELL_HOLY_SITE_ADJACENCY_FAITH_TIER1',	'Placeholder',		'YIELD_FAITH',		2,				'DISTRICT_HOLY_SITE',	NULL,					'CIVIC_DIVINE_RIGHT'),
	('STEPWELL_HOLY_SITE_ADJACENCY_FAITH_TIER2',	'Placeholder',		'YIELD_FAITH',		4,				'DISTRICT_HOLY_SITE',	'CIVIC_DIVINE_RIGHT',	NULL);

insert or replace into Adjacency_YieldChanges
	(ID,											Description,		YieldType,			YieldChange,	AdjacentImprovement,			PrereqCivic,				ObsoleteCivic)
values
	('STEPWELL_FARM_ADJACENCY_FAITH_TIER1',			'Placeholder',		'YIELD_FAITH',		1,				'IMPROVEMENT_FARM',				NULL,						'CIVIC_REFORMED_CHURCH'),
	('STEPWELL_FARM_ADJACENCY_FAITH_TIER2',			'Placeholder',		'YIELD_FAITH',		2,				'IMPROVEMENT_FARM',				'CIVIC_REFORMED_CHURCH',	NULL),
	('STEPWELL_PLANTATION_ADJACENCY_FAITH_TIER1',	'Placeholder',		'YIELD_FAITH',		1,				'IMPROVEMENT_PLANTATION',		NULL,						'CIVIC_REFORMED_CHURCH'),
	('STEPWELL_PLANTATION_ADJACENCY_FAITH_TIER2',	'Placeholder',		'YIELD_FAITH',		2,				'IMPROVEMENT_PLANTATION',		'CIVIC_REFORMED_CHURCH',	NULL);
insert or replace into ImprovementModifiers
	(ImprovementType,				ModifierId)
values
	('IMPROVEMENT_STEPWELL',		'STEPWELL_ADD_CITY_POPULATION_FOOD'),
	('IMPROVEMENT_STEPWELL',		'STEPWELL_AMENITY_MAX_ONE'),
	('IMPROVEMENT_STEPWELL',		'STEPWELL_FARM_FOOD'),
	('IMPROVEMENT_STEPWELL',		'STEPWELL_PLANTATION_FOOD');
insert or replace into Modifiers
	(ModifierId,							ModifierType,										SubjectRequirementSetId,												SubjectStackLimit)
values
	('STEPWELL_ADD_CITY_POPULATION_FOOD',	'MODIFIER_CITY_OWNER_ADJUST_POP_YIELD',				'PLAYER_HAS_TECH_MASONRY_REQUIREMENTS',	1),
	('STEPWELL_AMENITY_MAX_ONE',			'MODIFIER_CITY_OWNER_ADJUST_IMPROVEMENT_AMENITY',	'PLAYER_HAS_TECH_MASONRY_REQUIREMENTS',	1),
	('STEPWELL_FARM_FOOD',					'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',				'PLOT_HAS_IMPROVEMENT_FARM_AND_ADJACENT_TO_OWNER_REQUIREMENTS',			null),
	('STEPWELL_PLANTATION_FOOD',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',				'PLOT_HAS_IMPROVEMENT_PLANTATION_AND_ADJACENT_TO_OWNER_REQUIREMENTS',	null);
insert or replace into ModifierArguments
	(ModifierId,									Name,				Value)
values
	('STEPWELL_ADD_CITY_POPULATION_FOOD',			'YieldType',		'YIELD_FOOD'),
	('STEPWELL_ADD_CITY_POPULATION_FOOD',			'Amount',			0.5),
	('STEPWELL_AMENITY_MAX_ONE',					'Amount',			1),
	('STEPWELL_FARM_FOOD',							'YieldType',		'YIELD_FOOD'),
	('STEPWELL_FARM_FOOD',							'Amount',			1),
	('STEPWELL_PLANTATION_FOOD',					'YieldType',		'YIELD_FOOD'),
	('STEPWELL_PLANTATION_FOOD',					'Amount',			1);

-- Great Wall (China)
update Improvements_XP2 set BuildOnAdjacentPlot = 1 where ImprovementType = 'IMPROVEMENT_GREAT_WALL';
update Adjacency_YieldChanges set PrereqTech = 'TECH_CASTLES' where ID = 'GreatWall_Gold';
update Adjacency_YieldChanges set PrereqTech = 'TECH_MASONRY' where ID = 'GreatWall_Culture';
insert or replace into Improvement_ValidFeatures
	(ImprovementType,			FeatureType)
values
	('IMPROVEMENT_GREAT_WALL',	'FEATURE_FOREST');
insert or replace into Improvement_ValidTerrains
	(ImprovementType,			TerrainType)
values
	('IMPROVEMENT_GREAT_WALL',	'TERRAIN_GRASS_MOUNTAIN'),
	('IMPROVEMENT_GREAT_WALL',	'TERRAIN_PLAINS_MOUNTAIN'),
	('IMPROVEMENT_GREAT_WALL',	'TERRAIN_DESERT_MOUNTAIN'),
	('IMPROVEMENT_GREAT_WALL',	'TERRAIN_TUNDRA_MOUNTAIN'),
	('IMPROVEMENT_GREAT_WALL',	'TERRAIN_SNOW_MOUNTAIN');
insert or replace into ImprovementModifiers
	(ImprovementType,				ModifierId)
values
	('IMPROVEMENT_GREAT_WALL',		'GREAT_WALL_REDUCE_COMBAT');
insert or replace into Modifiers
	(ModifierId,							ModifierType,									SubjectRequirementSetId)
values
	('GREAT_WALL_REDUCE_COMBAT',			'MODIFIER_ALL_UNITS_ATTACH_MODIFIER',			'VARU_ADJACENT_AT_WAR_REQUIREMENTS'),
	('GREAT_WALL_REDUCE_COMBAT_MODIFIER',	'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',			NULL);
insert or replace into ModifierArguments
	(ModifierId,							Name,				Value)
values
	('GREAT_WALL_REDUCE_COMBAT',			'ModifierId',		'GREAT_WALL_REDUCE_COMBAT_MODIFIER'),
	('GREAT_WALL_REDUCE_COMBAT_MODIFIER',	'Amount',			-2);
insert or replace into ModifierStrings
	(ModifierId,								Context,	Text)
values
	('GREAT_WALL_REDUCE_COMBAT_MODIFIER',		'Preview',	'{1_Amount} {LOC_GREAT_WALL_REDUCE_COMBAT_PREVIEW_TEXT}');

-- Château (France)
update Improvements set
	PrereqCivic = 'CIVIC_LITERARY_TRADITION_HD',
	Housing = 1,
	SameAdjacentValid = 1,
	OnePerCity = 0
where ImprovementType = 'IMPROVEMENT_CHATEAU';
update Adjacency_YieldChanges set PrereqTech = null where ID = 'Chateau_WonderLate';
insert or ignore into ImprovementsNeedCount_HD (ImprovementType) values ('IMPROVEMENT_CHATEAU');

-- Coastal Polder (Netherlands)
update Improvements set MovementChange = 1, ValidAdjacentTerrainAmount = 1, PrereqTech = 'TECH_SAILING', PrereqCivic = null where ImprovementType = 'IMPROVEMENT_POLDER';
delete from Improvement_BonusYieldChanges where ImprovementType = 'IMPROVEMENT_POLDER';
delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_POLDER';
insert or replace into Improvement_ValidFeatures
	(ImprovementType,			FeatureType)
values
	('IMPROVEMENT_POLDER',		'FEATURE_REEF');


insert or replace into CivilizationTraits
	(CivilizationType,								TraitType)
values
	('CIVILIZATION_NETHERLANDS',					'TRAIT_CIVILIZATION_IMPROVEMENT_LAND_POLDER');

insert or replace into Improvement_Tourism
	(ImprovementType,			TourismSource,			PrereqCivic,		PrereqTech,	ScalingFactor)
values
	('IMPROVEMENT_LAND_POLDER',	'TOURISMSOURCE_GOLD',	'CIVIC_CAPITALISM',	null,		100	);

insert or replace into Improvement_ValidFeatures
	(ImprovementType,			FeatureType)
values
	('IMPROVEMENT_LAND_POLDER',	'FEATURE_FLOODPLAINS'),
	('IMPROVEMENT_LAND_POLDER',	'FEATURE_FLOODPLAINS_GRASSLAND'),
	('IMPROVEMENT_LAND_POLDER',	'FEATURE_FLOODPLAINS_PLAINS'),
	('IMPROVEMENT_LAND_POLDER',	'FEATURE_MARSH');

insert or replace into ImprovementsRules_HD (ImprovementType) values ('IMPROVEMENT_LAND_POLDER');
--resource
insert or replace into Improvement_ValidResources
	(ImprovementType,						ResourceType, MustRemoveFeature)
select
	'IMPROVEMENT_LAND_POLDER',	ResourceType, 0
from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_FARM' or ImprovementType = 'IMPROVEMENT_PLANTATION';
insert or replace into Improvement_ValidBuildUnits
	(ImprovementType,			UnitType)
values
	('IMPROVEMENT_LAND_POLDER',	'UNIT_BUILDER');
insert or replace into MomentIllustrations
	(MomentIllustrationType,						MomentDataType,					GameDataType,					Texture)
values
	('MOMENT_ILLUSTRATION_UNIQUE_IMPROVEMENT',		'MOMENT_DATA_IMPROVEMENT',		'IMPROVEMENT_LAND_POLDER',		'Moment_Infrastructure_Netherlands.dds');
-- adjacency
insert or replace into Improvement_Adjacencies
	(ImprovementType,			YieldChangeId)
values
	('IMPROVEMENT_POLDER',		'P_POLDER_PRODUCTION_TIRE1'),
	('IMPROVEMENT_POLDER',		'P_POLDER_PRODUCTION_TIRE2'),
	('IMPROVEMENT_POLDER',		'P_POLDER_FOOD_TIRE1'),
	('IMPROVEMENT_POLDER',		'P_POLDER_FOOD_TIRE2'),
	('IMPROVEMENT_POLDER',		'P_LAND_POLDER_PRODUCTION_TIRE1'),
	('IMPROVEMENT_POLDER',		'P_LAND_POLDER_PRODUCTION_TIRE2'),
	('IMPROVEMENT_POLDER',		'P_LAND_POLDER_FOOD_TIRE1'),
	('IMPROVEMENT_POLDER',		'P_LAND_POLDER_FOOD_TIRE2');

-- yieldchange
insert or replace into Adjacency_YieldChanges
	(ID, 								Description,		YieldType, 				YieldChange, 	TilesRequired, 		AdjacentImprovement, 		PrereqTech, 				ObsoleteTech,				PrereqCivic,				ObsoleteCivic)
values
	('P_POLDER_PRODUCTION_TIRE1',		'Placeholder',		'YIELD_PRODUCTION',		1,				2,					'IMPROVEMENT_POLDER',		'TECH_SHIPBUILDING',		'TECH_MASS_PRODUCTION',		NULL,						NULL),
	('P_POLDER_PRODUCTION_TIRE2',		'Placeholder',		'YIELD_PRODUCTION',		1,				1,					'IMPROVEMENT_POLDER',		'TECH_MASS_PRODUCTION',		NULL,						NULL,						NULL),
	('P_POLDER_FOOD_TIRE1',				'Placeholder',		'YIELD_FOOD',			1,				2,					'IMPROVEMENT_POLDER',		NULL,						NULL,						NULL,						'CIVIC_FEUDALISM'),
	('P_POLDER_FOOD_TIRE2',				'Placeholder',		'YIELD_FOOD',			1,				1,					'IMPROVEMENT_POLDER',		NULL,						NULL,						'CIVIC_FEUDALISM',			NULL),
	('P_LAND_POLDER_PRODUCTION_TIRE1',	'Placeholder',		'YIELD_PRODUCTION',		1,				2,					'IMPROVEMENT_LAND_POLDER',	'TECH_SHIPBUILDING',		'TECH_MASS_PRODUCTION',		NULL,						NULL),
	('P_LAND_POLDER_PRODUCTION_TIRE2',	'Placeholder',		'YIELD_PRODUCTION',		1,				1,					'IMPROVEMENT_LAND_POLDER',	'TECH_MASS_PRODUCTION',		NULL,						NULL,						NULL),
	('P_LAND_POLDER_FOOD_TIRE1',		'Placeholder',		'YIELD_FOOD',			1,				2,					'IMPROVEMENT_LAND_POLDER',	NULL,						NULL,						NULL,						'CIVIC_FEUDALISM'),
	('P_LAND_POLDER_FOOD_TIRE2',		'Placeholder',		'YIELD_FOOD',			1,				1,					'IMPROVEMENT_LAND_POLDER',	NULL,						NULL,						'CIVIC_FEUDALISM',			NULL);
	
-- adjacency
insert or replace into Improvement_Adjacencies
	(ImprovementType,				YieldChangeId)
values
	('IMPROVEMENT_LAND_POLDER',		'LP_POLDER_PRODUCTION_TIRE1'),
	('IMPROVEMENT_LAND_POLDER',		'LP_POLDER_PRODUCTION_TIRE2'),
	('IMPROVEMENT_LAND_POLDER',		'LP_POLDER_FOOD_TIRE1'),
	('IMPROVEMENT_LAND_POLDER',		'LP_POLDER_FOOD_TIRE2'),
	('IMPROVEMENT_LAND_POLDER',		'LP_LAND_POLDER_PRODUCTION_TIRE1'),
	('IMPROVEMENT_LAND_POLDER',		'LP_LAND_POLDER_PRODUCTION_TIRE2'),
	('IMPROVEMENT_LAND_POLDER',		'LP_LAND_POLDER_FOOD_TIRE1'),
	('IMPROVEMENT_LAND_POLDER',		'LP_LAND_POLDER_FOOD_TIRE2');

-- yieldchange
insert or replace into Adjacency_YieldChanges
	(ID, 								Description,		YieldType, 				YieldChange, 	TilesRequired, 		AdjacentImprovement, 		PrereqTech, 				ObsoleteTech,				PrereqCivic,				ObsoleteCivic)
values
	('LP_POLDER_PRODUCTION_TIRE1',		'Placeholder',		'YIELD_PRODUCTION',		1,				2,					'IMPROVEMENT_POLDER',		'TECH_CONSTRUCTION',		'TECH_MASS_PRODUCTION',		NULL,						NULL),
	('LP_POLDER_PRODUCTION_TIRE2',		'Placeholder',		'YIELD_PRODUCTION',		1,				1,					'IMPROVEMENT_POLDER',		'TECH_MASS_PRODUCTION',		NULL,						NULL,						NULL),
	('LP_POLDER_FOOD_TIRE1',			'Placeholder',		'YIELD_FOOD',			1,				2,					'IMPROVEMENT_POLDER',		NULL,						NULL,						NULL,						'CIVIC_FEUDALISM'),
	('LP_POLDER_FOOD_TIRE2',			'Placeholder',		'YIELD_FOOD',			1,				1,					'IMPROVEMENT_POLDER',		NULL,						NULL,						'CIVIC_FEUDALISM',			NULL),
	('LP_LAND_POLDER_PRODUCTION_TIRE1',	'Placeholder',		'YIELD_PRODUCTION',		1,				2,					'IMPROVEMENT_LAND_POLDER',	'TECH_CONSTRUCTION',		'TECH_MASS_PRODUCTION',		NULL,						NULL),
	('LP_LAND_POLDER_PRODUCTION_TIRE2',	'Placeholder',		'YIELD_PRODUCTION',		1,				1,					'IMPROVEMENT_LAND_POLDER',	'TECH_MASS_PRODUCTION',		NULL,						NULL,						NULL),
	('LP_LAND_POLDER_FOOD_TIRE1',		'Placeholder',		'YIELD_FOOD',			1,				2,					'IMPROVEMENT_LAND_POLDER',	NULL,						NULL,						NULL,						'CIVIC_FEUDALISM'),
	('LP_LAND_POLDER_FOOD_TIRE2',		'Placeholder',		'YIELD_FOOD',			1,				1,					'IMPROVEMENT_LAND_POLDER',	NULL,						NULL,						'CIVIC_FEUDALISM',			NULL);

-- Mission (Spain)
update Improvements set PrereqTech = null, PrereqCivic = 'CIVIC_THEOLOGY', CanBuildOutsideTerritory = 1 where ImprovementType = 'IMPROVEMENT_MISSION';
update Improvement_YieldChanges set YieldChange = 1 where YieldType = 'YIELD_SCIENCE' and ImprovementType = 'IMPROVEMENT_MISSION';
update Improvement_YieldChanges set YieldChange = 3 where YieldType = 'YIELD_FAITH' and ImprovementType = 'IMPROVEMENT_MISSION';
update Improvement_BonusYieldChanges set PrereqCivic = null, PrereqTech = 'TECH_EDUCATION', BonusYieldChange = 1 where ImprovementType = 'IMPROVEMENT_MISSION' and PrereqCivic = 'CIVIC_CULTURAL_HERITAGE' and YieldType = 'YIELD_SCIENCE';
insert or replace into Improvement_BonusYieldChanges
	(Id,	ImprovementType,						YieldType,				BonusYieldChange,	PrereqCivic)
values
	(850,	'IMPROVEMENT_MISSION',			'YIELD_FAITH',		3,								'CIVIC_DIVINE_RIGHT'),
	(851,	'IMPROVEMENT_MISSION',			'YIELD_FAITH',		3,								'CIVIC_REFORMED_CHURCH');

delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_MISSION';
insert or replace into ImprovementModifiers
	(ImprovementType,			ModifierId)
values
	('IMPROVEMENT_MISSION',		'HD_MISSION_FOREIGN_CITY_CENTER_FOOD'),
	('IMPROVEMENT_MISSION',		'HD_MISSION_FOREIGN_CITY_CENTER_PRODUCTION');
insert or replace into Modifiers
	(ModifierId,																	ModifierType,																SubjectRequirementSetId)
values
	('HD_MISSION_FOREIGN_CITY_CENTER_FOOD',				'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PLOT_ADJACENT_TO_DISTRICT_CITY_CENTER_ON_FOREIGN_CONTINENT'),
	('HD_MISSION_FOREIGN_CITY_CENTER_PRODUCTION',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PLOT_ADJACENT_TO_DISTRICT_CITY_CENTER_ON_FOREIGN_CONTINENT');
insert or replace into ModifierArguments
	(ModifierId,																		Name,			Value)
values
	('HD_MISSION_FOREIGN_CITY_CENTER_FOOD',					'YieldType',	'YIELD_FOOD'),
	('HD_MISSION_FOREIGN_CITY_CENTER_FOOD',					'Amount',			1),
	('HD_MISSION_FOREIGN_CITY_CENTER_PRODUCTION',		'YieldType',	'YIELD_PRODUCTION'),
	('HD_MISSION_FOREIGN_CITY_CENTER_PRODUCTION',		'Amount',			1);

-- Golf Course (Scotland)(fox)
	-- pre
update Improvements set PrereqCivic = 'CIVIC_GAMES_RECREATION', SameAdjacentValid = 0, Workable = 0 where ImprovementType = 'IMPROVEMENT_GOLF_COURSE';

delete from Improvement_YieldChanges where ImprovementType = 'IMPROVEMENT_GOLF_COURSE';

delete from Improvement_BonusYieldChanges where ImprovementType = 'IMPROVEMENT_GOLF_COURSE';

delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_GOLF_COURSE';

delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_GOLF_COURSE';
		
	-- modifier
insert or replace into ImprovementModifiers
	(ImprovementType,				ModifierId)
values
	('IMPROVEMENT_GOLF_COURSE',		'GOLFCOURSE_AMENITY_TIER1'),
	('IMPROVEMENT_GOLF_COURSE',		'GOLFCOURSE_AMENITY_TIER2'),
	('IMPROVEMENT_GOLF_COURSE',		'GOLFCOURSE_DISTRICT_CULTURE');

insert or replace into Modifiers
	(ModifierId,																ModifierType,																				SubjectRequirementSetId)
values
	('GOLFCOURSE_AMENITY_TIER1',								'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY',	NULL),
	('GOLFCOURSE_AMENITY_TIER2',								'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_AMENITY',	'PLAYER_HAS_CIVIC_HUMANISM_REQUIREMENTS'),
	('GOLFCOURSE_DISTRICT_CULTURE',							'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		'REQUIRE_PLOT_ADJACENT_TO_OWNER_AND_NOT_WONDER');

insert or replace into ModifierArguments
	(ModifierId,						Name,				Value)
values
	('GOLFCOURSE_AMENITY_TIER1',		'Type',				'ARGTYPE_IDENTITY'),
	('GOLFCOURSE_AMENITY_TIER1',		'Amount',			1),
	('GOLFCOURSE_AMENITY_TIER2',		'Type',				'ARGTYPE_IDENTITY'),
	('GOLFCOURSE_AMENITY_TIER2',		'Amount',			1),
	('GOLFCOURSE_DISTRICT_CULTURE',		'YieldType',				'YIELD_CULTURE'),
	('GOLFCOURSE_DISTRICT_CULTURE',		'Amount',			1);

-- 区域加速
insert or replace into ImprovementModifiers
	(ImprovementType,						ModifierId)
select
	'IMPROVEMENT_GOLF_COURSE',	'IMPROVEMENT_GOLF_COURSE_' || DistrictType || '_PRODUCTION'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into Modifiers
	(ModifierId,																									ModifierType,																					OwnerRequirementSetId,																	SubjectStackLimit)
select
	'IMPROVEMENT_GOLF_COURSE_' || DistrictType || '_PRODUCTION',	'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION',	'PLOT_ADJACENT_TO_' || DistrictType || '_REQUIREMENTS',	1
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments
	(ModifierId,																									Name,						Value)
select
	'IMPROVEMENT_GOLF_COURSE_' || DistrictType || '_PRODUCTION',	'DistrictType',	DistrictType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments
	(ModifierId,																									Name,						Value)
select
	'IMPROVEMENT_GOLF_COURSE_' || DistrictType || '_PRODUCTION',	'Amount',				30
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 相邻加成
insert or replace into ImprovementModifiers
	(ImprovementType,						ModifierId)
select
	'IMPROVEMENT_GOLF_COURSE',	'IMPROVEMENT_GOLF_COURSE_' || DistrictType || '_ADJACENCY'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into Modifiers
	(ModifierId,																									ModifierType,																					OwnerRequirementSetId,																	SubjectRequirementSetId,															SubjectStackLimit)
select
	'IMPROVEMENT_GOLF_COURSE_' || DistrictType || '_ADJACENCY',		'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',		'PLOT_ADJACENT_TO_' || DistrictType || '_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET',	1
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments
	(ModifierId,																									Name,						Value)
select
	'IMPROVEMENT_GOLF_COURSE_' || DistrictType || '_ADJACENCY',		'YieldType',		YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments
	(ModifierId,																									Name,						Value)
select
	'IMPROVEMENT_GOLF_COURSE_' || DistrictType || '_ADJACENCY',		'Amount',				50
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;


-- Open-Air Museum (Sweden)
update Improvements set PrereqCivic = 'CIVIC_HUMANISM' where ImprovementType = 'IMPROVEMENT_OPEN_AIR_MUSEUM';
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_OPEN_AIR_MUSEUM';
create temporary table Open_Air_Museum_ValidFeatures (
	ImprovementType text not null, 
	FeatureType text not null
);
insert or replace into Open_Air_Museum_ValidFeatures
	(ImprovementType,					FeatureType)
values
	('IMPROVEMENT_OPEN_AIR_MUSEUM',		'FEATURE_FOREST'),
	('IMPROVEMENT_OPEN_AIR_MUSEUM',		'FEATURE_JUNGLE'),
	('IMPROVEMENT_OPEN_AIR_MUSEUM',		'FEATURE_MARSH'),
	('IMPROVEMENT_OPEN_AIR_MUSEUM',		'FEATURE_GEOTHERMAL_FISSURE'),
	('IMPROVEMENT_OPEN_AIR_MUSEUM',		'FEATURE_OASIS');
insert or replace into Improvement_ValidFeatures
	(ImprovementType,					FeatureType)
select
	ImprovementType,					FeatureType
from Open_Air_Museum_ValidFeatures where FeatureType in (select FeatureType from Features);

create temporary table HD_OpenAirMuseumBonuses (
	ObjectType text not null primary key,
	YieldType text not null,
	AttachModifierId text,
	ModifierId text
);
insert or replace into HD_OpenAirMuseumBonuses
	(ObjectType,	YieldType)
select
	TerrainType,	'YIELD_CULTURE'
from Terrains;
insert or replace into HD_OpenAirMuseumBonuses
	(ObjectType,	YieldType)
select
	FeatureType,	'YIELD_SCIENCE'
from Features where FeatureType not in ('FEATURE_BURNING_FOREST', 'FEATURE_BURNT_FOREST', 'FEATURE_BURNING_JUNGLE', 'FEATURE_BURNT_JUNGLE');
update HD_OpenAirMuseumBonuses set ModifierId = 'OPEN_AIR_MUSEUM_' || ObjectType || '_' || YieldType;
update HD_OpenAirMuseumBonuses set AttachModifierId = ModifierId || '_ATTACH';
-- 基础
insert or replace into ImprovementModifiers
	(ImprovementType,		 			ModifierId)
select
	'IMPROVEMENT_OPEN_AIR_MUSEUM',		AttachModifierId
from HD_OpenAirMuseumBonuses;
insert or replace into Modifiers
	(ModifierId,		ModifierType,								SubjectRequirementSetId,			SubjectStackLimit)
select
	AttachModifierId,	'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',	'HD_CITY_HAS_' || ObjectType,		1
from HD_OpenAirMuseumBonuses;
insert or replace into ModifierArguments
	(ModifierId,		Name,			Value)
select
	AttachModifierId,	'ModifierId',	ModifierId
from HD_OpenAirMuseumBonuses;
insert or replace into Modifiers
	(ModifierId,		ModifierType,								SubjectRequirementSetId,								SubjectStackLimit)
select
	ModifierId,			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'PLOT_HAS_IMPROVEMENT_OPEN_AIR_MUSEUM_REQUIREMENTS',	1
from HD_OpenAirMuseumBonuses;
insert or replace into ModifierArguments
	(ModifierId,		Name,			Value)
select
	ModifierId,			'YieldType',	YieldType
from HD_OpenAirMuseumBonuses;
insert or replace into ModifierArguments
	(ModifierId,		Name,			Value)
select
	ModifierId,			'Amount',		1
from HD_OpenAirMuseumBonuses;

-- 科技翻倍
insert or replace into ImprovementModifiers (ImprovementType, ModifierId)
	select 'IMPROVEMENT_OPEN_AIR_MUSEUM', AttachModifierId || '_LATE'
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_SCIENCE';
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit)
	select AttachModifierId || '_LATE', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'PLAYER_HAS_TECH_BIOLOGY_HD_REQUIREMENTS', 'HD_CITY_HAS_' || ObjectType, 1
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_SCIENCE';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select AttachModifierId || '_LATE', 'ModifierId', ModifierId || '_LATE'
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_SCIENCE';
insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, SubjectStackLimit)
	select ModifierId || '_LATE', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_HAS_IMPROVEMENT_OPEN_AIR_MUSEUM_REQUIREMENTS',	1
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_SCIENCE';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select ModifierId || '_LATE', 'YieldType', YieldType
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_SCIENCE';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select ModifierId || '_LATE', 'Amount', 1
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_SCIENCE';

-- 文化翻倍
insert or replace into ImprovementModifiers (ImprovementType, ModifierId)
	select 'IMPROVEMENT_OPEN_AIR_MUSEUM', AttachModifierId || '_LATE'
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_CULTURE';
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit)
	select AttachModifierId || '_LATE', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'PLAYER_HAS_CIVIC_MUSEOLOGY_HD_REQUIREMENTS', 'HD_CITY_HAS_' || ObjectType, 1
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_CULTURE';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select AttachModifierId || '_LATE', 'ModifierId', ModifierId || '_LATE'
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_CULTURE';
insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, SubjectStackLimit)
	select ModifierId || '_LATE', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_HAS_IMPROVEMENT_OPEN_AIR_MUSEUM_REQUIREMENTS',	1
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_CULTURE';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select ModifierId || '_LATE', 'YieldType', YieldType
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_CULTURE';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select ModifierId || '_LATE', 'Amount', 1
	from HD_OpenAirMuseumBonuses where YieldType = 'YIELD_CULTURE';

-- Ice Hockey Rink (Canada)
update Improvements set PrereqCivic = 'CIVIC_GAMES_RECREATION' where ImprovementType = 'IMPROVEMENT_ICE_HOCKEY_RINK';
update Improvement_YieldChanges set YieldChange = 0 where ImprovementType = 'IMPROVEMENT_ICE_HOCKEY_RINK' and YieldType = 'YIELD_FOOD';
delete from Improvement_BonusYieldChanges where ImprovementType = 'IMPROVEMENT_ICE_HOCKEY_RINK';
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_ICE_HOCKEY_RINK' and ModifierId = 'ICEHOCKEYRINK_CULTURE_STADIUM';
-- delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_ICE_HOCKEY_RINK' and ModifierId = 'ICEHOCKEYRINK_AMENITY';
update ModifierArguments set Value = 2 where ModifierId = 'ICEHOCKEYRINK_AMENITY' and Name = 'Amount';
insert or replace into ImprovementModifiers
	(ImprovementType,					ModifierId)
values
	('IMPROVEMENT_ICE_HOCKEY_RINK',		'ICE_HOCKEY_RINK_CITY_CULTURE_ATTACH');
insert or replace into Modifiers
	(ModifierId,								ModifierType,								SubjectRequirementSetId,								SubjectStackLimit)
values
	('ICE_HOCKEY_RINK_CITY_CULTURE_ATTACH',		'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',	'PLOT_IS_TUNDRA_OR_SNOW_REQUIREMENTS',					1),
	('ICE_HOCKEY_RINK_CITY_CULTURE',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'PLOT_HAS_IMPROVEMENT_ICE_HOCKEY_RINK_REQUIREMENTS',	null);
insert or replace into ModifierArguments
	(ModifierId,								Name,			Value)
values
	('ICE_HOCKEY_RINK_CITY_CULTURE_ATTACH',		'ModifierId',	'ICE_HOCKEY_RINK_CITY_CULTURE'),
	('ICE_HOCKEY_RINK_CITY_CULTURE',			'YieldType',	'YIELD_CULTURE'),
	('ICE_HOCKEY_RINK_CITY_CULTURE',			'Amount',		1);
create temporary table HD_IceHockeyRinkBonuses (
	DistrictType text not null primary key,
	AttachModifierId text,
	ModifierId text
);
insert or replace into HD_IceHockeyRinkBonuses (DistrictType) select DistrictType from Districts where RequiresPopulation = 1 and TraitType is null;
update HD_IceHockeyRinkBonuses set ModifierId = 'ICE_HOCKEY_RINK_' || DistrictType || '_PRODUCTION';
update HD_IceHockeyRinkBonuses set AttachModifierId = ModifierId || '_ATTACH';
insert or replace into ImprovementModifiers
	(ImprovementType,					ModifierId)
select
	'IMPROVEMENT_ICE_HOCKEY_RINK',		AttachModifierId
from HD_IceHockeyRinkBonuses;
insert or replace into Modifiers
	(ModifierId,			ModifierType,									SubjectRequirementSetId,								SubjectStackLimit)
select
	AttachModifierId,		'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	'DISTRICT_IS_' || DistrictType || '_REQUIREMENTS',		1
from HD_IceHockeyRinkBonuses;
insert or replace into ModifierArguments
	(ModifierId,			Name,			Value)
select
	AttachModifierId,		'ModifierId',	ModifierId
from HD_IceHockeyRinkBonuses;
insert or replace into Modifiers
	(ModifierId,	ModifierType,							OwnerRequirementSetId,						SubjectRequirementSetId,								SubjectStackLimit)
select
	ModifierId,		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',	'PLOT_IS_TUNDRA_OR_SNOW_REQUIREMENTS',		'PLOT_HAS_IMPROVEMENT_ICE_HOCKEY_RINK_REQUIREMENTS',	1
from HD_IceHockeyRinkBonuses;
insert or replace into ModifierArguments
	(ModifierId,	Name,			Value)
select
	ModifierId,		'YieldType',	'YIELD_PRODUCTION'
from HD_IceHockeyRinkBonuses;
insert or replace into ModifierArguments
	(ModifierId,	Name,			Value)
select
	ModifierId,		'Amount',		1
from HD_IceHockeyRinkBonuses;

-- 蛮寨清剿奖励改成虚拟村子奖励的方式。
-- update Improvements set DispersalGold = 0 where ImprovementType = 'IMPROVEMENT_BARBARIAN_CAMP';
-- Remove snow barbarian camp.
delete from Improvement_ValidTerrains where
	ImprovementType = 'IMPROVEMENT_BARBARIAN_CAMP' and TerrainType = 'TERRAIN_SNOW';
delete from Improvement_ValidTerrains where
	ImprovementType = 'IMPROVEMENT_BARBARIAN_CAMP' and TerrainType = 'TERRAIN_SNOW_HILLS';

insert or replace into Types (Type, Kind) values 
	('IMPROVEMENT_GOODY_BUILDER', 'KIND_IMPROVEMENT');
	-- ('IMPROVEMENT_GOODY_BARBARIAN_CAMP', 'KIND_IMPROVEMENT');
insert or replace into Improvements
	(ImprovementType,				Name,									Icon,							PlunderType,	RemoveOnEntry,	Goody,	GoodyNotify)
values
	('IMPROVEMENT_GOODY_BUILDER',	'LOC_IMPROVEMENT_GOODY_BUILDER_NAME',	'ICON_IMPROVEMENT_GOODY_HUT',	'NO_PLUNDER',	1,				1,		0);
	-- ('IMPROVEMENT_GOODY_BARBARIAN_CAMP',	'LOC_IMPROVEMENT_GOODY_BUILDER_NAME',	'ICON_IMPROVEMENT_GOODY_HUT',	'NO_PLUNDER',	1,				1,		0);

insert or replace into GoodyHuts
	(GoodyHutType,									ImprovementType,										Weight,	ShowMoment)
values
	('DUMMY_GOODY_BUILDIER',				'IMPROVEMENT_GOODY_BUILDER',				100,		0);
	-- ('DUMMY_GOODY_BARBARIAN_CAMP',	'IMPROVEMENT_GOODY_BARBARIAN_CAMP',	100,		0);

insert or replace into GoodyHutSubTypes
	(GoodyHut,													SubTypeGoodyHut,										Description,																				Weight, ModifierID)
values
	('DUMMY_GOODY_BUILDIER',						'DUMMY_GRANT_BUILDER',							'LOC_GOODYHUT_SURVIVORS_GRANT_UNIT_DESCRIPTION',		100,		'GOODY_SURVIVORS_GRANT_BUILDER');
	-- ('DUMMY_GOODY_BARBARIAN_CAMP',			'DUMMY_GOODY_BARBARIAN_CAMP_GOLD',	'LOC_GOODYHUT_SMALL_GOLD_DESCRIPTION',							100,		'GOODY_GOLD_SMALL_MODIFIER');

-- -- 村庄小额奖励改为40，大额奖励改为120；
-- update ModifierArguments set Value = 40 where ModifierID = 'GOODY_GOLD_SMALL_MODIFIER' and Name = 'Amount';
-- update ModifierArguments set Value = 120 where ModifierID = 'GOODY_GOLD_LARGE_MODIFIER' and Name = 'Amount';

--删除林肯种植园debuff
delete from ImprovementModifiers where ModifierId = 'PLANTATION_NEGATIVE_LOYALTY';
--巨神头像
update Adjacency_YieldChanges set TilesRequired = 1, ObsoleteCivic = NULL where ID = 'ColossalHead_FaithForestEarly';
update Adjacency_YieldChanges set TilesRequired = 1, ObsoleteCivic = NULL where ID = 'ColossalHead_FaithJungleEarly';
delete from Improvement_Adjacencies where YieldChangeId = 'ColossalHead_FaithForestLate' or YieldChangeId = 'ColossalHead_FaithJungleLate';
--摩艾石像
-- delete from Improvement_InvalidAdjacentFeatures where ImprovementType = 'IMPROVEMENT_MOAI';
--独石教堂相邻
insert or replace into Adjacency_YieldChanges
	(ID,										Description,				YieldType,					YieldChange,				TilesRequired,			AdjacentResourceClass)
values
	('LuxuryAdjacency_Faith',					'Placeholder',				'YIELD_FAITH',				1,							1,						'RESOURCECLASS_LUXURY'),
	('StrategicAdjacency_Faith',				'Placeholder',				'YIELD_FAITH',				1,							1,						'RESOURCECLASS_STRATEGIC'),
	('BonusAdjacency_Faith',					'Placeholder',				'YIELD_FAITH',				1,							1,						'RESOURCECLASS_BONUS');

-- 海滨度假区
update Improvements set PrereqTech = 'TECH_CARTOGRAPHY', YieldFromAppealPercent = 400 where ImprovementType = 'IMPROVEMENT_BEACH_RESORT';

insert or ignore into ImprovementModifiers
	(ImprovementType,           ModifierId)
values
	('IMPROVEMENT_BEACH_RESORT',	'IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_1'),
	('IMPROVEMENT_BEACH_RESORT',	'IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_2'),
	('IMPROVEMENT_BEACH_RESORT',	'IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_3'),
	('IMPROVEMENT_BEACH_RESORT',	'IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_1'),
	('IMPROVEMENT_BEACH_RESORT',	'IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_2'),
	('IMPROVEMENT_BEACH_RESORT',	'IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_3');

insert or ignore into Modifiers
	(ModifierId,                                            ModifierType,                               SubjectRequirementSetId)
values
	('IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_1',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'CITY_HAS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_TIER_1_BUILDING_REQUIREMENTS'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_2',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'CITY_HAS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_TIER_2_BUILDING_REQUIREMENTS'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_3',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'CITY_HAS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_TIER_3_BUILDING_REQUIREMENTS'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_1',					'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'CITY_HAS_DISTRICT_HARBOR_TIER_1_BUILDING_REQUIREMENTS'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_2',					'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'CITY_HAS_DISTRICT_HARBOR_TIER_2_BUILDING_REQUIREMENTS'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_3',					'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'CITY_HAS_DISTRICT_HARBOR_TIER_3_BUILDING_REQUIREMENTS');

insert or ignore into ModifierArguments
	(ModifierId,                                            Name,         Value)
values
	('IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_1',	'YieldType',	'YIELD_GOLD'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_1',	'Amount',			3),
	('IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_2',	'YieldType',	'YIELD_GOLD'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_2',	'Amount',			3),
	('IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_3',	'YieldType',	'YIELD_GOLD'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_WATER_ENTERTAINMENT_COMPLEX_TIER_3',	'Amount',			3),
	('IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_1',					'YieldType',	'YIELD_GOLD'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_1',					'Amount',			3),
	('IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_2',					'YieldType',	'YIELD_GOLD'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_2',					'Amount',			3),
	('IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_3',					'YieldType',	'YIELD_GOLD'),
	('IMPROVEMENT_BEACH_RESORT_GOLD_HARBOR_TIER_3',					'Amount',			3);

-- 滑雪场
update Improvements set OnePerCity = 1 where ImprovementType = 'IMPROVEMENT_SKI_RESORT';

-- 奇观业绩
insert or ignore into ImprovementModifiers
	(ImprovementType,           ModifierId)
values
	('IMPROVEMENT_SKI_RESORT',	'IMPROVEMENT_SKI_RESORT_WONDER_TOURISM');

insert or ignore into Modifiers
	(ModifierId,                              ModifierType,                             OwnerRequirementSetId)
values
	('IMPROVEMENT_SKI_RESORT_WONDER_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',	'PLOT_ADJACENT_TO_WONDER_REQUIREMENTS');

insert or ignore into ModifierArguments
	(ModifierId,                                        Name,         Value)
values
	('IMPROVEMENT_SKI_RESORT_WONDER_TOURISM',         'BoostsWonders',            1),
	('IMPROVEMENT_SKI_RESORT_WONDER_TOURISM',         'ScalingFactor',            150);

-- 改良业绩
insert or replace into ImprovementModifiers
	(ImprovementType,						ModifierId)
select
	'IMPROVEMENT_SKI_RESORT',			'IMPROVEMENT_SKI_RESORT_' || ImprovementType || '_TOURISM'
from Improvement_Tourism where ImprovementType != 'IMPROVEMENT_SKI_RESORT';

insert or replace into Modifiers
	(ModifierId,									                ModifierType,								OwnerRequirementSetId)
select
  'IMPROVEMENT_SKI_RESORT_' || ImprovementType || '_TOURISM',    'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',    'PLOT_ADJACENT_TO_TOURISM_IMPROVEMENT'
from Improvement_Tourism where ImprovementType != 'IMPROVEMENT_SKI_RESORT';

insert or replace into ModifierArguments
	(ModifierId,					                                Name,				Value)
select
	'IMPROVEMENT_SKI_RESORT_' || ImprovementType || '_TOURISM',	'ImprovementType',	ImprovementType
from Improvement_Tourism where ImprovementType != 'IMPROVEMENT_SKI_RESORT';

insert or replace into ModifierArguments
	(ModifierId,					                                Name,				Value)
select
	'IMPROVEMENT_SKI_RESORT_' || ImprovementType || '_TOURISM',	'ScalingFactor',	150
from Improvement_Tourism where ImprovementType != 'IMPROVEMENT_SKI_RESORT';

-- 产品业绩1
insert or replace into ImprovementModifiers
	(ImprovementType,						ModifierId)
select
	'IMPROVEMENT_SKI_RESORT',			'IMPROVEMENT_SKI_RESORT_PRODUCT_TOURISM1'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into Modifiers
	(ModifierId,									                ModifierType,								OwnerRequirementSetId)
select
  'IMPROVEMENT_SKI_RESORT_PRODUCT_TOURISM1',    'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',    'PLOT_ADJACENT_TO_DISTRICT_ENTERTAINMENT_COMPLEX_REQUIREMENTS'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,					                  Name,				Value)
select
	'IMPROVEMENT_SKI_RESORT_PRODUCT_TOURISM1',	'GreatWorkObjectType',	'GREATWORKOBJECT_PRODUCT'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,					                  Name,				Value)
select
	'IMPROVEMENT_SKI_RESORT_PRODUCT_TOURISM1',	'ScalingFactor',	150
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

-- 产品业绩2
insert or replace into ImprovementModifiers
	(ImprovementType,						ModifierId)
select
	'IMPROVEMENT_SKI_RESORT',			'IMPROVEMENT_SKI_RESORT_PRODUCT_TOURISM2'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into Modifiers
	(ModifierId,									                ModifierType,								OwnerRequirementSetId)
select
  'IMPROVEMENT_SKI_RESORT_PRODUCT_TOURISM2',    'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',    'PLOT_ADJACENT_TO_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_REQUIREMENTS'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,					                  Name,				Value)
select
	'IMPROVEMENT_SKI_RESORT_PRODUCT_TOURISM2',	'GreatWorkObjectType',	'GREATWORKOBJECT_PRODUCT'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,					                  Name,				Value)
select
	'IMPROVEMENT_SKI_RESORT_PRODUCT_TOURISM2',	'ScalingFactor',	150
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

-- 发电厂
update Improvements set PrereqTech = 'TECH_INTEGRATED_CIRCUIT_HD' where ImprovementType = 'IMPROVEMENT_SOLAR_FARM';
update Improvements set PrereqTech = 'TECH_INTEGRATED_CIRCUIT_HD' where ImprovementType = 'IMPROVEMENT_WIND_FARM';