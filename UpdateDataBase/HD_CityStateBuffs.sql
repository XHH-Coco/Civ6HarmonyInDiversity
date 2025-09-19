-- Modifier Info
update HD_CityStateBuffedObjects set
	IsYieldChange		= YieldType in (select YieldType from Yields),
	AttachId				= TraitType || '_' || ObjectType || '_' || YieldType;
update HD_CityStateBuffedObjects set
	ModifierId			= AttachId || '_MODIFIER';
update HD_CityStateBuffedObjects set
	ModifierType			= 'MODIFIER_BUILDING_YIELD_CHANGE',
	SubjectRequirementSetId = null
where IsYieldChange = 1 and IsDistrict = 0;
update HD_CityStateBuffedObjects set
	ModifierType			= 'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',
	SubjectRequirementSetId = 'CITY_HAS_' || ObjectType || '_REQUIREMENTS'
where IsYieldChange = 1 and IsDistrict = 1;
-- 适配原本的军邦和工邦
-- update HD_CityStateBuffedObjects set
-- 	ModifierType			= 'MODIFIER_PLAYER_CITIES_ADJUST_' || YieldType || '_CHANGE',
-- 	SubjectRequirementSetId = 'CITY_HAS_' || ObjectType || '_REQUIREMENTS'
-- where IsYieldChange = 0;
-- TraitModifiers
insert or replace into TraitModifiers (TraitType, ModifierId)
	select TraitType, AttachId from HD_CityStateBuffedObjects;
insert or replace into Modifiers (ModifierId,	ModifierType, SubjectRequirementSetId)
	select AttachId, 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'PLAYER_HAS_' || Level || '_INFLUENCE' from HD_CityStateBuffedObjects;
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select AttachId, 'ModifierId', ModifierId from HD_CityStateBuffedObjects;
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	select ModifierId, ModifierType, 'CITY_WAS_FOUNDED', SubjectRequirementSetId from HD_CityStateBuffedObjects;

-- ModifierArguments
-- BuildingType
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select ModifierId, 'BuildingType', ObjectType from HD_CityStateBuffedObjects where IsYieldChange = 1 and IsDistrict = 0;
-- YieldType
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select ModifierId, 'YieldType', YieldType from HD_CityStateBuffedObjects where IsYieldChange = 1;
-- Amount
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select ModifierId, 'Amount', Amount from HD_CityStateBuffedObjects;

-- Yields for Neighborhood attached directly to district instead of city
update Modifiers set ModifierType = 'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE', SubjectRequirementSetId = 'DISTRICT_IS_DISTRICT_NEIGHBORHOOD_REQUIREMENTS' where ModifierId = 'MINOR_CIV_CSE_AGRICULTURAL_TRAIT_DISTRICT_NEIGHBORHOOD_YIELD_FOOD_MODIFIER';
update Modifiers set ModifierType = 'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE', SubjectRequirementSetId = 'DISTRICT_IS_DISTRICT_DAM_REQUIREMENTS' where ModifierId = 'MINOR_CIV_CSE_AGRICULTURAL_TRAIT_DISTRICT_DAM_YIELD_FOOD_MODIFIER';
update Modifiers set ModifierType = 'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE', SubjectRequirementSetId = 'DISTRICT_IS_DISTRICT_CANAL_REQUIREMENTS' where ModifierId = 'MINOR_CIV_CSE_AGRICULTURAL_TRAIT_DISTRICT_CANAL_YIELD_FOOD_MODIFIER';
update Modifiers set ModifierType = 'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE', SubjectRequirementSetId = 'DISTRICT_IS_DISTRICT_AQUEDUCT_REQUIREMENTS' where ModifierId = 'MINOR_CIV_CSE_AGRICULTURAL_TRAIT_DISTRICT_AQUEDUCT_YIELD_FOOD_MODIFIER';

-- 铜雀台 Buff非自己建立的城市
insert or ignore into TraitModifiers (TraitType, ModifierId)
	select distinct TraitType, TraitType || '_' || Level || '_NOT_FOUNDED' from HD_CityStateBuffedObjects
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE');
insert or ignore into Modifiers (ModifierId,	ModifierType, SubjectRequirementSetId)
	select distinct TraitType || '_' || Level || '_NOT_FOUNDED', 'MODIFIER_ALL_CITIES_ATTACH_MODIFIER', 'PLAYER_HAS_' || Level || '_INFLUENCE' from HD_CityStateBuffedObjects
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE');
insert or ignore into ModifierArguments (ModifierId, Name, Value)
	select distinct TraitType || '_' || Level || '_NOT_FOUNDED', 'ModifierId', TraitType || '_' || Level || '_NOT_FOUNDED_MODIFIER' from HD_CityStateBuffedObjects
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE');
insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	select distinct TraitType || '_' || Level || '_NOT_FOUNDED_MODIFIER', 'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE', 'PLAYER_HAS_BUILDING_PHANTA_BRONZE_BIRD_TERRACE_REQUIREMENTS', 'CITY_WAS_NOT_FOUNDED' from HD_CityStateBuffedObjects
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE');

insert or ignore into ModifierArguments (ModifierId, Name, Value)
	select distinct TraitType || '_' || Level || '_NOT_FOUNDED_MODIFIER', 'YieldType', YieldType from HD_CityStateBuffedObjects where IsYieldChange = 1
and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE');
insert or ignore into ModifierArguments (ModifierId, Name, Value)
	select distinct TraitType || '_' || Level || '_NOT_FOUNDED_MODIFIER', 'Amount', Amount from HD_CityStateBuffedObjects
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PHANTA_BRONZE_BIRD_TERRACE');