-------------------------------------
--		Australia DLC		--
-------------------------------------
update Improvements set PrereqCivic = null, PrereqTech = 'TECH_THE_WHEEL' where ImprovementType = 'IMPROVEMENT_OUTBACK_STATION';

insert or replace into Improvement_YieldChanges
	(ImprovementType,					YieldType,		YieldChange)
values
	('IMPROVEMENT_OUTBACK_STATION',		'YIELD_FOOD',	0),
	('IMPROVEMENT_OUTBACK_STATION',		'YIELD_GOLD',	0);

insert or replace into Improvement_ValidTerrains
	(ImprovementType,					TerrainType,				PrereqTech)
values
	('IMPROVEMENT_OUTBACK_STATION',		'TERRAIN_GRASS_HILLS',		null),
	('IMPROVEMENT_OUTBACK_STATION',		'TERRAIN_PLAINS_HILLS',		null),
	('IMPROVEMENT_OUTBACK_STATION',		'TERRAIN_DESERT_HILLS',		null);

delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_PASTURE' and YieldChangeId = 'Pasture_Outback_Production';
delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_OUTBACK_STATION';
insert or replace into Improvement_Adjacencies
	(ImprovementType,					YieldChangeId)
values
	-- 牧场
	('IMPROVEMENT_PASTURE',				'HD_Pasture_Outback_Gold'),
	('IMPROVEMENT_PASTURE',				'HD_Pasture_Outback_Production'),
	('IMPROVEMENT_PASTURE',				'HD_Outback_Adjacent_Gold'),
	('IMPROVEMENT_PASTURE',				'HD_Outback_Adjacent_Science'),
	-- 内陆牧场
	('IMPROVEMENT_OUTBACK_STATION',		'HD_Outback_Pasture_Food_1'),
	('IMPROVEMENT_OUTBACK_STATION',		'HD_Outback_Pasture_Food_2'),
	('IMPROVEMENT_OUTBACK_STATION',		'HD_Outback_Pasture_Food_3'),
	('IMPROVEMENT_OUTBACK_STATION',		'HD_Outback_Outback_Production_1'),
	('IMPROVEMENT_OUTBACK_STATION',		'HD_Outback_Outback_Production_2'),
	('IMPROVEMENT_OUTBACK_STATION',		'HD_Outback_Outback_Production_3'),
	('IMPROVEMENT_OUTBACK_STATION',		'HD_Outback_Adjacent_Science'),
	('IMPROVEMENT_OUTBACK_STATION',		'HD_Outback_Adjacent_Gold');

insert or replace into Adjacency_YieldChanges
	(ID,																	Description,		YieldType,					YieldChange,	TilesRequired,	AdjacentImprovement,						PrereqCivic,								PrereqTech,											ObsoleteCivic,		ObsoleteTech)
values
	-- 牧场
	('HD_Pasture_Outback_Gold',						'Placeholder',	'YIELD_GOLD',				3,						1,							'IMPROVEMENT_OUTBACK_STATION',	null,												'TECH_TEXTILE_HD',							null,							null),
	('HD_Pasture_Outback_Production',			'Placeholder',	'YIELD_PRODUCTION',	1,						1,							'IMPROVEMENT_OUTBACK_STATION',	null,												'TECH_MASS_PRODUCTION',					null,							null),
	-- 内陆牧场
	('HD_Outback_Pasture_Food_1',					'Placeholder',	'YIELD_FOOD',				1,						1,							'IMPROVEMENT_PASTURE',					null,												null,														null,							null),
	('HD_Outback_Pasture_Food_2',					'Placeholder',	'YIELD_FOOD',				1,						1,							'IMPROVEMENT_PASTURE',					'CIVIC_GUILDS',							null,														null,							null),
	('HD_Outback_Pasture_Food_3',					'Placeholder',	'YIELD_FOOD',				1,						1,							'IMPROVEMENT_PASTURE',					null,												'TECH_MODERN_AGRICULTURE_HD',		null,							null),
	('HD_Outback_Outback_Production_1',		'Placeholder',	'YIELD_PRODUCTION',	1,						1,							'IMPROVEMENT_OUTBACK_STATION',	null,												null,														null,							null),
	('HD_Outback_Outback_Production_2',		'Placeholder',	'YIELD_PRODUCTION',	1,						1,							'IMPROVEMENT_OUTBACK_STATION',	null,												'TECH_STEAM_POWER',							null,							null),
	('HD_Outback_Outback_Production_3',		'Placeholder',	'YIELD_PRODUCTION',	1,						1,							'IMPROVEMENT_OUTBACK_STATION',	'CIVIC_URBAN_DESIGN_HD',		null,														null,							null),
	('HD_Outback_Adjacent_Gold',					'Placeholder',	'YIELD_GOLD',				3,						1,							'IMPROVEMENT_OUTBACK_STATION',	'CIVIC_NEOCOLONIALISM_HD',	null,														null,							null),
	('HD_Outback_Adjacent_Science',				'Placeholder',	'YIELD_SCIENCE',		1,						1,							'IMPROVEMENT_OUTBACK_STATION',	null,												'TECH_GENETIC_ENGINEERING_HD',	null,							null);

insert or replace into GlobalParameters (Name, Value) values
  ('HD_OUTBACK_STATION_COPY_RESOURCE', 1);

-- 牧场1琴
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_LAND_DOWN_UNDER' and ModifierId = 'TRAIT_COASTAL_HOUSING';
insert or replace into TraitModifiers
	(TraitType,															ModifierId)
values
	('TRAIT_CIVILIZATION_LAND_DOWN_UNDER',	'TRAIT_CULTURE_PASTURE'),
	('TRAIT_LEADER_MAJOR_CIV',							'TRAIT_OUTBACK_STATION_CULTURE_BOMB');
insert or replace into Modifiers
	(ModifierId,														ModifierType,																	SubjectRequirementSetId)
values
	('TRAIT_CULTURE_PASTURE',								'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',					'PLOT_HAS_PASTURE_REQUIREMENTS'),
	('TRAIT_OUTBACK_STATION_CULTURE_BOMB',	'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER',		null);
insert or replace into ModifierArguments
	(ModifierId,														Name,								Value)
values
	('TRAIT_CULTURE_PASTURE',								'YieldType',				'YIELD_CULTURE'),
	('TRAIT_CULTURE_PASTURE',								'Amount',						1),
	('TRAIT_OUTBACK_STATION_CULTURE_BOMB',	'ImprovementType',	'IMPROVEMENT_OUTBACK_STATION');