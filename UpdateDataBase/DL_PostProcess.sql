-------------------------------------
--         Post Process            --
-------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Military production cards
-------------------------------------------------------------------------------------------------------------------

-- Speed Up
insert or replace into PolicyModifiers (PolicyType, ModifierId) select
    a.PolicyType,   'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType;

insert or replace into Modifiers (ModifierId,   ModifierType) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION',  'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType;

insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION',  'EraType',  a.EraType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION',  'UnitPromotionClass',   b.PromotionClassType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION',  'Amount',   a.SpeedUpAmount
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType;

-- Tier1, land
insert or replace into PolicyModifiers (PolicyType, ModifierId) select
    a.PolicyType,   'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER1'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;

insert or replace into Modifiers (ModifierId,   ModifierType,   SubjectRequirementSetId) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER1',
    'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION',    'BUILDING_IS_BARRACKS_STABLE_MILITARITIC_CITY_STATE'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;

insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER1',   'EraType',  a.EraType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER1',   'UnitPromotionClass',   b.PromotionClassType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER1',   'Amount',   a.SpeedUpPerTier
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;

-- Tier2, land
insert or replace into PolicyModifiers (PolicyType, ModifierId) select
    a.PolicyType,   'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER2'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;

insert or replace into Modifiers (ModifierId,   ModifierType,   SubjectRequirementSetId) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER2',
    'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION',    'BUILDING_IS_ARMORY'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;

insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER2',   'EraType',  a.EraType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER2',   'UnitPromotionClass',   b.PromotionClassType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER2',   'Amount',   a.SpeedUpPerTier
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;

-- Tier3, land
insert or replace into PolicyModifiers (PolicyType, ModifierId) select
    a.PolicyType,   'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER3'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;

insert or replace into Modifiers (ModifierId,   ModifierType,   SubjectRequirementSetId) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER3',
    'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION',    'BUILDING_IS_MILITARY_ACADEMY'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;

insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER3',   'EraType',  a.EraType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER3',   'UnitPromotionClass',   b.PromotionClassType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_LAND_TIER3',   'Amount',   a.SpeedUpPerTier
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Land' and a.SpeedUpPerTier != 0;

-- Tier1, sea
insert or replace into PolicyModifiers (PolicyType, ModifierId) select
    a.PolicyType,   'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER1'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;

insert or replace into Modifiers (ModifierId,   ModifierType,   SubjectRequirementSetId) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER1',
    'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION',    'BUILDING_IS_LIGHTHOUSE'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;

insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER1',    'EraType',  a.EraType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER1',    'UnitPromotionClass',   b.PromotionClassType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER1',    'Amount',   a.SpeedUpPerTier
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;

-- Tier2, land
insert or replace into PolicyModifiers (PolicyType, ModifierId) select
    a.PolicyType,   'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER2'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;

insert or replace into Modifiers (ModifierId,   ModifierType,   SubjectRequirementSetId) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER2',
    'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION',    'BUILDING_IS_SHIPYARD'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;

insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER2',    'EraType',  a.EraType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER2',    'UnitPromotionClass',   b.PromotionClassType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER2',    'Amount',   a.SpeedUpPerTier
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;

-- Tier3, land
insert or replace into PolicyModifiers (PolicyType, ModifierId) select
    a.PolicyType,   'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER3'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;

insert or replace into Modifiers (ModifierId,   ModifierType,   SubjectRequirementSetId) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER3',
    'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION',    'BUILDING_IS_SEAPORT'
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;

insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER3',    'EraType',  a.EraType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER3',    'UnitPromotionClass',   b.PromotionClassType
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;
insert or replace into ModifierArguments (ModifierId,   Name,   Value) select
    'HD_' || a.PolicyType || '_' || a.EraType || '_' || b.PromotionClassType || '_PRODUCTION_SEA_TIER3',    'Amount',   a.SpeedUpPerTier
from PolicyUnitProductionValidEras a CROSS JOIN PolicyUnitProductionValidClasses b where a.PolicyType = b.PolicyType and b.UnitDomain = 'Sea' and a.SpeedUpPerTier != 0;

-- Sphinx (Egypt)
-- other basic adjustments are written in UpdateDatabse/DL_Improvements.sql
create temporary table SphinxWonderYields (
	BuildingType text not null,
	YieldType text not null,
	YieldChange int not null,
	primary key (BuildingType, YieldType)
);
insert or replace into SphinxWonderYields
	(BuildingType,	YieldType,	YieldChange)
select
	BuildingType,	YieldType,	YieldChange
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1);
insert or replace into ImprovementModifiers
	(ImprovementType,		ModifierId)
select
	'IMPROVEMENT_SPHINX',	'SPHINX_' || BuildingType || '_' || YieldType
from SphinxWonderYields;
insert or replace into Modifiers
	(ModifierId,										ModifierType,								SubjectRequirementSetId)
select
	'SPHINX_' || BuildingType || '_' || YieldType,		'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PLOT_ADJACENT_TO_' || BuildingType || '_REQUIREMENTS'
from SphinxWonderYields;
insert or replace into ModifierArguments
	(ModifierId,										Name,			Value)
select
	'SPHINX_' || BuildingType || '_' || YieldType,		'YieldType',	YieldType
from SphinxWonderYields;
insert or replace into ModifierArguments
	(ModifierId,										Name,			Value)
select
	'SPHINX_' || BuildingType || '_' || YieldType,		'Amount',		YieldChange * 1
from SphinxWonderYields;

-- Royal Society
delete from BuildingModifiers where BuildingType = 'BUILDING_GOV_SCIENCE' and ModifierId = 'GOV_PROJECT_ABILITY';
create temporary table HD_GovScienceBuildingYields (
	BuildingType text not null primary key,
	YieldType text not null,
	Amount int,
	ReplacesBuildingType text,
	ReplacesAmount int,
	ModifierId text
);
-- Initialize
insert or replace into HD_GovScienceBuildingYields
	(BuildingType,	YieldType)
select
	BuildingType,	'YIELD_PRODUCTION'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS';
insert or replace into HD_GovScienceBuildingYields
	(BuildingType,	YieldType)
select
	BuildingType,	'YIELD_SCIENCE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE';
update HD_GovScienceBuildingYields set Amount =	(select YieldChange from Building_YieldChanges
	where BuildingType = HD_GovScienceBuildingYields.BuildingType and YieldType = 'YIELD_PRODUCTION') where YieldType = 'YIELD_SCIENCE';
update HD_GovScienceBuildingYields set Amount =	(select YieldChange from Building_YieldChanges
	where BuildingType = HD_GovScienceBuildingYields.BuildingType and YieldType = 'YIELD_SCIENCE') where YieldType = 'YIELD_PRODUCTION';
-- UB support
update HD_GovScienceBuildingYields set Amount = 0 where Amount is null;
update HD_GovScienceBuildingYields set ReplacesBuildingType = (select ReplacesBuildingType from BuildingReplaces where CivUniqueBuildingType = BuildingType);
with T(BuildingType, Amount) as (select BuildingType, Amount from HD_GovScienceBuildingYields)
update HD_GovScienceBuildingYields set ReplacesAmount = (select Amount from T where T.BuildingType = ReplacesBuildingType);
update HD_GovScienceBuildingYields set ReplacesAmount = 0 where ReplacesAmount is null;
update HD_GovScienceBuildingYields set Amount = Amount - ReplacesAmount;
delete from HD_GovScienceBuildingYields where Amount = 0;
-- Modifiers
update HD_GovScienceBuildingYields set ModifierId = 'GOV_SCIENCE_' || BuildingType || '_' || YieldType;
insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
select
	'BUILDING_GOV_SCIENCE',		ModifierId
from HD_GovScienceBuildingYields;
insert or replace into Modifiers
	(ModifierId,	ModifierType)
select
	ModifierId,		'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from HD_GovScienceBuildingYields;
insert or replace into ModifierArguments
	(ModifierId,	Name,			Value)
select
	ModifierId,		'BuildingType',	BuildingType
from HD_GovScienceBuildingYields;
insert or replace into ModifierArguments
	(ModifierId,	Name,			Value)
select
	ModifierId,		'YieldType',	YieldType
from HD_GovScienceBuildingYields;
insert or replace into ModifierArguments
	(ModifierId,	Name,			Value)
select
	ModifierId,		'Amount',		Amount
from HD_GovScienceBuildingYields;

-------------------------------------------------------------------
-- 博物馆管理
insert or ignore into PolicyModifiers
	(PolicyType,							 			ModifierId)
select distinct
	'POLICY_HD_MUSEUM_MANAGEMENT',	'HD_MUSEUM_MANAGEMENT_' || a.BuildingType || '_' || b.YieldType || '_BONUS'
from Building_GreatWorks a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.GreatWorkSlotType in ('GREATWORKSLOT_ART', 'GREATWORKSLOT_ARTIFACT', 'GREATWORKSLOT_RELIC', 'GREATWORKSLOT_PALACE', 'GREATWORKSLOT_CATHEDRAL');

insert or replace into Modifiers
	(ModifierId, ModifierType, SubjectRequirementSetId)
select
	'HD_MUSEUM_MANAGEMENT_' || a.BuildingType || '_' || b.YieldType || '_BONUS',
	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',
	'CITY_HAS_' || a.BuildingType || '_REQUIREMENTS'
from Building_GreatWorks a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.GreatWorkSlotType in ('GREATWORKSLOT_ART', 'GREATWORKSLOT_ARTIFACT', 'GREATWORKSLOT_RELIC', 'GREATWORKSLOT_PALACE', 'GREATWORKSLOT_CATHEDRAL');

insert or replace into ModifierArguments
	(ModifierId, Name, Value)
select
	'HD_MUSEUM_MANAGEMENT_' || a.BuildingType || '_' || b.YieldType || '_BONUS', 'YieldType', b.YieldType
from Building_GreatWorks a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.GreatWorkSlotType in ('GREATWORKSLOT_ART', 'GREATWORKSLOT_ARTIFACT', 'GREATWORKSLOT_RELIC', 'GREATWORKSLOT_PALACE', 'GREATWORKSLOT_CATHEDRAL');

insert or replace into ModifierArguments
	(ModifierId, Name, Value)
select
	'HD_MUSEUM_MANAGEMENT_' || a.BuildingType || '_' || b.YieldType || '_BONUS', 'Amount', b.YieldChange
from Building_GreatWorks a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.GreatWorkSlotType in ('GREATWORKSLOT_ART', 'GREATWORKSLOT_ARTIFACT', 'GREATWORKSLOT_RELIC', 'GREATWORKSLOT_PALACE', 'GREATWORKSLOT_CATHEDRAL');

-- 正字法
insert or ignore into PolicyModifiers
	(PolicyType,							ModifierId)
select distinct
	'POLICY_HD_ORTHOGRAPHY',	'HD_ORTHOGRAPHY_' || a.BuildingType || '_' || b.YieldType || '_BONUS'
from Building_GreatWorks a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.GreatWorkSlotType in ('GREATWORKSLOT_WRITING', 'GREATWORKSLOT_MUSIC', 'GREATWORKSLOT_PALACE');

insert or replace into Modifiers
	(ModifierId, ModifierType, SubjectRequirementSetId)
select
	'HD_ORTHOGRAPHY_' || a.BuildingType || '_' || b.YieldType || '_BONUS',
	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',
	'CITY_HAS_' || a.BuildingType || '_REQUIREMENTS'
from Building_GreatWorks a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.GreatWorkSlotType in ('GREATWORKSLOT_WRITING', 'GREATWORKSLOT_MUSIC', 'GREATWORKSLOT_PALACE');

insert or replace into ModifierArguments
	(ModifierId, Name, Value)
select
	'HD_ORTHOGRAPHY_' || a.BuildingType || '_' || b.YieldType || '_BONUS', 'YieldType', b.YieldType
from Building_GreatWorks a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.GreatWorkSlotType in ('GREATWORKSLOT_WRITING', 'GREATWORKSLOT_MUSIC', 'GREATWORKSLOT_PALACE');

insert or replace into ModifierArguments
	(ModifierId, Name, Value)
select
	'HD_ORTHOGRAPHY_' || a.BuildingType || '_' || b.YieldType || '_BONUS', 'Amount', b.YieldChange
from Building_GreatWorks a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.GreatWorkSlotType in ('GREATWORKSLOT_WRITING', 'GREATWORKSLOT_MUSIC', 'GREATWORKSLOT_PALACE');

	-- 男朝鲜适配
insert or ignore into PolicyModifiers
	(PolicyType,							ModifierId)
select distinct
	'POLICY_HD_ORTHOGRAPHY',	'HD_ORTHOGRAPHY_' || a.BuildingType || '_' || b.YieldType || '_BONUS_SEJONG'
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict = 'DISTRICT_CAMPUS' and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SEOWON');

insert or replace into Modifiers
	(ModifierId, ModifierType, SubjectRequirementSetId)
select
	'HD_ORTHOGRAPHY_' || a.BuildingType || '_' || b.YieldType || '_BONUS_SEJONG',
	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',
	'CITY_HAS_SEOWON_AND_' || a.BuildingType || '_REQUIREMENTS'
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict = 'DISTRICT_CAMPUS' and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SEOWON');

insert or replace into ModifierArguments
	(ModifierId, Name, Value)
select
	'HD_ORTHOGRAPHY_' || a.BuildingType || '_' || b.YieldType || '_BONUS_SEJONG', 'YieldType', b.YieldType
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict = 'DISTRICT_CAMPUS' and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SEOWON');

insert or replace into ModifierArguments
	(ModifierId, Name, Value)
select
	'HD_ORTHOGRAPHY_' || a.BuildingType || '_' || b.YieldType || '_BONUS_SEJONG', 'Amount', b.YieldChange
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict = 'DISTRICT_CAMPUS' and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_SEOWON');
-------------------------------------------------------------------