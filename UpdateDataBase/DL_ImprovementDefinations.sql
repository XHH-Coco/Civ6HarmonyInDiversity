-- 改良分类表
create table if not exists HD_Basic_Improvements (
	ImprovementType TEXT not null,
	primary key (ImprovementType)
);

create table if not exists HD_Unique_Improvements (
	ImprovementType TEXT not null,
	primary key (ImprovementType)
);

create table if not exists HD_CityState_Improvements (
	ImprovementType TEXT not null,
	primary key (ImprovementType)
);

create table if not exists HD_Urban_Facilities_Improvements (
	ImprovementType TEXT not null,
	primary key (ImprovementType)
);

create table if not exists HD_Tourism_Facilities_Improvements (
	ImprovementType TEXT not null,
	primary key (ImprovementType)
);

create table if not exists HD_Military_Facilities_Improvements (
	ImprovementType TEXT not null,
	primary key (ImprovementType)
);

create table if not exists HD_Common_Improvements (
	ImprovementType TEXT not null,
	primary key (ImprovementType)
);

------------------- 奇观对应资源 -------------------
create table if not exists Wonder_Resources_HD(
  BuildingType TEXT not NULL,
  ResourceType TEXT,
PRIMARY KEY('BuildingType'));

------------------- 百科资源分类 -------------------
create table if not exists HD_Civilopedia_Resource_Groups(
  ResourceType 	TEXT not NULL,
  PageGroupId 	TEXT not NULL,
PRIMARY KEY('ResourceType', 'PageGroupId'));

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