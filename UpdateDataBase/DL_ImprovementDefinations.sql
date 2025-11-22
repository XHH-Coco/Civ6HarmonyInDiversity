-- 渔场下放通用
update Improvements set TraitType = NULL, PrereqTech = 'TECH_SAILING', Housing = 1, TilesRequired = 2, SameAdjacentValid = 1, AdjacentSeaResource = 1, Workable = 1 where ImprovementType = 'IMPROVEMENT_FISHERY';

-- 陆地圩田
insert or ignore into Types
	(Type,											Kind)
values
	('TRAIT_CIVILIZATION_IMPROVEMENT_LAND_POLDER',	'KIND_TRAIT'),
	('IMPROVEMENT_LAND_POLDER',						'KIND_IMPROVEMENT');
	
insert or replace into Traits
	(TraitType,										Name)
values
	('TRAIT_CIVILIZATION_IMPROVEMENT_LAND_POLDER',	'LOC_IMPROVEMENT_LAND_POLDER_NAME');

insert or replace into Improvements
	(ImprovementType,			Name,								PrereqTech,				Description,								PlunderType,		PlunderAmount,	Icon,							TraitType,										Housing,	TilesRequired,	MovementChange)
values
	('IMPROVEMENT_LAND_POLDER',	'LOC_IMPROVEMENT_LAND_POLDER_NAME',	'TECH_IRRIGATION',		'LOC_IMPROVEMENT_LAND_POLDER_DESCRIPTION',	'PLUNDER_FAITH',	25,				'ICON_IMPROVEMENT_LAND_POLDER',	'TRAIT_CIVILIZATION_IMPROVEMENT_LAND_POLDER',	1,			2,				1);