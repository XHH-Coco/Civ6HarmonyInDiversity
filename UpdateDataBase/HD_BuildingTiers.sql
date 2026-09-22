-- At LoadOrder 16001
create table if not exists HD_BuildingTiers (
	BuildingType text not null primary key,
	PrereqDistrict text not null,
	Tier int not null default 1,
	ReplacesOther int not null default 0,
	Tag text
);

-- Initialize
insert or replace into HD_BuildingTiers
	(BuildingType,  PrereqDistrict)
select
	BuildingType,   PrereqDistrict
from Buildings where IsWonder = 0 and InternalOnly = 0 and PrereqDistrict is not null;
update HD_BuildingTiers set ReplacesOther = 1 where BuildingType in (select CivUniqueBuildingType from BuildingReplaces);
update HD_BuildingTiers set Tier = 0 where PrereqDistrict = 'DISTRICT_CITY_CENTER';
update HD_BuildingTiers set Tier = 2 where BuildingType in (select Building from BuildingPrereqs where PrereqBuilding in (select BuildingType from HD_BuildingTiers where Tier = 1));
update HD_BuildingTiers set Tier = 3 where BuildingType in (select Building from BuildingPrereqs where PrereqBuilding in (select BuildingType from HD_BuildingTiers where Tier = 2));
update HD_BuildingTiers set Tier = 4 where BuildingType in (select Building from BuildingPrereqs where PrereqBuilding in (select BuildingType from HD_BuildingTiers where Tier = 3));
-- Hospitium and Garden moves to Tier 4 with District Expansion enabled.
update HD_BuildingTiers set Tier = 4 where Tier = 3 and PrereqDistrict = 'DISTRICT_HOLY_SITE' and BuildingType not in (select BuildingType from Buildings where EnabledByReligion = 1);

-- 删除虚拟建筑
delete from HD_BuildingTiers where BuildingType in (select BuildingType from HD_DUMMY_BUILDINGS);

create table if not exists HD_DistrictBuildingHighestTier (
	DistrictType text not null primary key,
	Tier int not null
);
insert or ignore into HD_DistrictBuildingHighestTier
	(DistrictType,					Tier)
select
	PrereqDistrict,					max(Tier)
from HD_BuildingTiers group by PrereqDistrict;

create table if not exists HD_HighestTierBuildings (
	BuildingType text not null primary key,
	PrereqDistrict text not null
);
insert or ignore into HD_HighestTierBuildings (BuildingType, PrereqDistrict) select b.BuildingType, b.PrereqDistrict
	from HD_DistrictBuildingHighestTier a inner join HD_BuildingTiers b on a.DistrictType = b.PrereqDistrict and a.Tier = b.Tier where b.PrereqDistrict != 'DISTRICT_CITY_CENTER'
	and b.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

-- Reqs
-- 城市拥有
insert or ignore into RequirementSets
	(RequirementSetId,																RequirementSetType)
select distinct
	'CITY_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'
from HD_BuildingTiers;
insert or ignore into RequirementSetRequirements
	(RequirementSetId,																RequirementId)
select
	'CITY_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING_REQUIREMENTS',	'REQUIRES_CITY_HAS_' || BuildingType
from HD_BuildingTiers;
insert or ignore into Requirements
	(RequirementId,																RequirementType)
select distinct
	'REQUIRES_CITY_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING',	'REQUIREMENT_REQUIREMENTSET_IS_MET'
from HD_BuildingTiers;
insert or ignore into RequirementArguments
	(RequirementId,																Name,				Value)
select distinct
	'REQUIRES_CITY_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING',	'RequirementSetId',	'CITY_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING_REQUIREMENTS'
from HD_BuildingTiers;

-- 玩家拥有
insert or ignore into RequirementSets
	(RequirementSetId,																	RequirementSetType)
select distinct
	'PLAYER_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'
from HD_BuildingTiers;
insert or ignore into RequirementSetRequirements
	(RequirementSetId,																	RequirementId)
select
	'PLAYER_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING_REQUIREMENTS',	'REQUIRES_PLAYER_HAS_' || BuildingType
from HD_BuildingTiers;
insert or ignore into Requirements
	(RequirementId,																	RequirementType)
select distinct
	'REQUIRES_PLAYER_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING',	'REQUIREMENT_REQUIREMENTSET_IS_MET'
from HD_BuildingTiers;
insert or ignore into RequirementArguments
	(RequirementId,																	Name,				Value)
select distinct
	'REQUIRES_PLAYER_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING',	'RequirementSetId',	'PLAYER_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING_REQUIREMENTS'
from HD_BuildingTiers;

-- 单元格拥有
insert or ignore into RequirementSets
	(RequirementSetId,																																RequirementSetType)
select distinct
	'HD_PLOT_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'
from HD_BuildingTiers;
insert or ignore into RequirementSetRequirements
	(RequirementSetId,																																RequirementId)
select
	'HD_PLOT_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING_REQUIREMENTS',	'PLOT_HAS_' || BuildingType
from HD_BuildingTiers;
insert or ignore into Requirements
	(RequirementId,																															RequirementType)
select distinct
	'REQUIRES_PLOT_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING',	'REQUIREMENT_REQUIREMENTSET_IS_MET'
from HD_BuildingTiers;
insert or ignore into RequirementArguments
	(RequirementId,																															Name,								Value)
select distinct
	'REQUIRES_PLOT_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING',	'RequirementSetId',	'HD_PLOT_HAS_' || PrereqDistrict || '_TIER_' || Tier || '_BUILDING_REQUIREMENTS'
from HD_BuildingTiers;

-- City State
delete from TraitModifiers where TraitType in (select TraitType from CSE_ClassTypes);
create table if not exists HD_CityStateBuffedObjects (
	TraitType text,
	YieldType text,
	ObjectType text,
	IsDistrict int default 0,
	Amount int default 0,
	PrereqDistrict text,
	Level text,
	IsYieldChange int,
	AttachId text,
	ModifierId text,
	ModifierType text,
	SubjectRequirementSetId text,
	primary key (TraitType, YieldType, ObjectType)
);

-- City State buffed Buildings
-- Initialize
insert or replace into HD_CityStateBuffedObjects
	(PrereqDistrict,	ObjectType,		Amount)
select
	PrereqDistrict,		BuildingType,   Tier
from HD_BuildingTiers where ReplacesOther = 0;
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_SCIENTIFIC_TRAIT',		YieldType = 'YIELD_SCIENCE'			where PrereqDistrict = 'DISTRICT_CAMPUS';
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_CULTURAL_TRAIT',		YieldType = 'YIELD_CULTURE'			where PrereqDistrict = 'DISTRICT_THEATER';
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_RELIGIOUS_TRAIT',		YieldType = 'YIELD_FAITH'			where PrereqDistrict = 'DISTRICT_HOLY_SITE';
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_TRADE_TRAIT',			YieldType = 'YIELD_GOLD'			where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB';
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_MILITARISTIC_TRAIT',	YieldType = 'YIELD_PRODUCTION'		where PrereqDistrict = 'DISTRICT_ENCAMPMENT';
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_INDUSTRIAL_TRAIT',		YieldType = 'YIELD_PRODUCTION'   	where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE';
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_CSE_MARITIME_TRAIT',	YieldType = 'YIELD_GOLD'			where PrereqDistrict = 'DISTRICT_HARBOR';
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_CSE_AGRICULTURAL_TRAIT',  YieldType = 'YIELD_FOOD', Amount = Amount + 1 where PrereqDistrict = 'DISTRICT_AQUEDUCT';
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_CSE_AGRICULTURAL_TRAIT',  YieldType = 'YIELD_FOOD', Amount = Amount + 1 where PrereqDistrict = 'DISTRICT_NEIGHBORHOOD';
-- 农业区适配
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_CSE_AGRICULTURAL_TRAIT',  YieldType = 'YIELD_FOOD' where PrereqDistrict = 'DISTRICT_C_AGRICULTURE';

-- remove Buildings that are not buffed.
delete from HD_CityStateBuffedObjects where TraitType is null or YieldType is null or PrereqDistrict is null;
-- Buffs District itself as Tier 4 with no Tier 4 building
insert or replace into HD_CityStateBuffedObjects
	(TraitType,			YieldType,	ObjectType,		Amount,	IsDistrict)
select
	distinct TraitType, YieldType,	PrereqDistrict,	4,		1
from HD_CityStateBuffedObjects a where not exists (select ObjectType from HD_CityStateBuffedObjects b where Amount = 4 and a.PrereqDistrict = b.PrereqDistrict);
-- Industrial Zone bonus for District production
insert or replace into HD_CityStateBuffedObjects
	(TraitType, YieldType,				PrereqDistrict,	ObjectType,	Amount)
select
	TraitType,  'DISTRICT_PRODUCTION',  PrereqDistrict,	ObjectType,	Amount
from HD_CityStateBuffedObjects where YieldType = 'BUILDING_PRODUCTION';
-- Aqueduct & Neighborhood
update HD_CityStateBuffedObjects set Amount = 2 where ObjectType = 'DISTRICT_AQUEDUCT';
insert or replace into HD_CityStateBuffedObjects
	(TraitType,								YieldType,			ObjectType,					Amount,	IsDistrict)
values
	('MINOR_CIV_CSE_AGRICULTURAL_TRAIT',	'YIELD_FOOD',		'DISTRICT_NEIGHBORHOOD',	4,		1),
	('MINOR_CIV_CSE_AGRICULTURAL_TRAIT',	'YIELD_FOOD',		'DISTRICT_DAM',	4,		1),
	('MINOR_CIV_CSE_AGRICULTURAL_TRAIT',	'YIELD_FOOD',		'DISTRICT_CANAL',	4,		1);
-- Agricultural City States buff Aqueduct as Tier 2, sewer as Tier 3 with district expansion not enabled.
-- delete from HD_CityStateBuffedObjects where ObjectType = 'DISTRICT_AQUEDUCT' and not exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SEWER' and PrereqDistrict = 'DISTRICT_CITY_CENTER');
update HD_CityStateBuffedObjects set Amount = 4 where ObjectType = 'DISTRICT_AQUEDUCT' and not exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SEWER' and PrereqDistrict = 'DISTRICT_CITY_CENTER');
insert or replace into HD_CityStateBuffedObjects
	(TraitType,							YieldType,			ObjectType,	Amount)
select
	'MINOR_CIV_CSE_AGRICULTURAL_TRAIT',	'YIELD_FOOD',		BuildingType,   3
from Buildings where BuildingType = 'BUILDING_SEWER' and PrereqDistrict = 'DISTRICT_CITY_CENTER';
-- Trade City States buff Harbor buildings with Maritime not enabled.
update HD_CityStateBuffedObjects set TraitType = 'MINOR_CIV_TRADE_TRAIT' where TraitType = 'MINOR_CIV_CSE_MARITIME_TRAIT' and TraitType not in (select Type from Types);
-- remove City State Types that are not enabled.
delete from HD_CityStateBuffedObjects where TraitType not in (select Type from Types);
-- Diplomatic Quater buildings
insert or replace into HD_CityStateBuffedObjects
	(TraitType,	YieldType,	ObjectType,		Amount,		PrereqDistrict)
select
	TraitType,	YieldType,	BuildingType,	Tier + 1,	'DISTRICT_DIPLOMATIC_QUARTER'
from ((select distinct TraitType, YieldType from HD_CityStateBuffedObjects)
cross join (select BuildingType, Tier from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_DIPLOMATIC_QUARTER' and ReplacesOther = 0));

-- 农业区适配 删除农邦给水渠、社区、堤坝、运河加产
delete from HD_CityStateBuffedObjects where TraitType = 'MINOR_CIV_CSE_AGRICULTURAL_TRAIT'
	and (PrereqDistrict not in ('DISTRICT_C_AGRICULTURE', 'DISTRICT_DIPLOMATIC_QUARTER') or PrereqDistrict is null)
	and exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');

-- Palace
insert or replace into HD_CityStateBuffedObjects
	(TraitType,			YieldType,	ObjectType,			Amount)
select
	distinct TraitType,	YieldType,	'BUILDING_PALACE',	1
from HD_CityStateBuffedObjects;

-- stores Influence Level
update HD_CityStateBuffedObjects set Level = 'SMALL'	where Amount = 1;
update HD_CityStateBuffedObjects set Level = 'MEDIUM'	where Amount = 2;
update HD_CityStateBuffedObjects set Level = 'LARGE'	where Amount = 3;
update HD_CityStateBuffedObjects set Level = 'LARGEST'	where Amount = 4;
delete from HD_CityStateBuffedObjects where Level is null;
-- Agricultural City States adjusts
update HD_CityStateBuffedObjects set Amount = Amount - 1 where Amount > 1 and YieldType = 'YIELD_FOOD'
	and not exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');
update HD_CityStateBuffedObjects set Amount = Amount - 1 where Amount > 1 and YieldType = 'YIELD_FOOD'
	and not exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');
-- triple gold yield
update HD_CityStateBuffedObjects set Amount = Amount * 3 where YieldType = 'YIELD_GOLD';

update HD_CityStateBuffedObjects set Amount = 7 where Amount = 4 and YieldType = 'YIELD_FAITH';
update HD_CityStateBuffedObjects set Amount = 5 where Amount = 3 and YieldType = 'YIELD_FAITH';
update HD_CityStateBuffedObjects set Amount = 3 where Amount = 2 and YieldType = 'YIELD_FAITH';