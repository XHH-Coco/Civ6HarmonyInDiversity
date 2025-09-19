-- 伦敦塔桥
insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
select
	'BUILDING_TOWER_BRIDGE',			'TOWER_BRIDGE_' || DistrictType || '_DISTRICT_ATTACH1'
from DistrictCorrespondingYieldType_HD where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_TOWER_BRIDGE');

insert or replace into Modifiers
	(ModifierId,											ModifierType,										SubjectRequirementSetId)
select
	'TOWER_BRIDGE_' || DistrictType || '_DISTRICT_ATTACH1', 'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',		'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET'
from DistrictCorrespondingYieldType_HD where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_TOWER_BRIDGE');

insert or replace into ModifierArguments
	(ModifierId,											Name,				Value)
select
	'TOWER_BRIDGE_' || DistrictType || '_DISTRICT_ATTACH1', 'ModifierId',		'TOWER_BRIDGE_' || DistrictType || '_DISTRICT_YIELD'
from DistrictCorrespondingYieldType_HD where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_TOWER_BRIDGE');

insert or replace into Modifiers
	(ModifierId,											ModifierType,												OwnerRequirementSetId,			SubjectStackLimit)
select
	'TOWER_BRIDGE_' || DistrictType || '_DISTRICT_YIELD', 	'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',			'HD_IS_RIVER_OR_ON_OR_ADJACENT_TO_COAST', 1
from DistrictCorrespondingYieldType_HD where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_TOWER_BRIDGE');

insert or replace into ModifierArguments
	(ModifierId,											Name,				Value)
select
	'TOWER_BRIDGE_' || DistrictType || '_DISTRICT_YIELD', 	'YieldType',		YieldType
from DistrictCorrespondingYieldType_HD where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_TOWER_BRIDGE');

insert or replace into ModifierArguments
	(ModifierId,											Name,				Value)
select
	'TOWER_BRIDGE_' || DistrictType || '_DISTRICT_YIELD', 	'Amount',			5
from DistrictCorrespondingYieldType_HD where DistrictType != 'DISTRICT_CITY_CENTER'
	and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_TOWER_BRIDGE');