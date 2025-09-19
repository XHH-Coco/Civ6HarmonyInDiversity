-- National_Wonders_Pack1
insert or ignore into HD_DUMMY_BUILDINGS (BuildingType) values
  ('NAT_WONDER_CL_IRONWORKS_INTERNAL'),
  ('NAT_WON_CL_FINANCE_INTERNAL'),
  ('NAT_WON_CL_AIRPORT_INTERNAL');

-- 大铁厂 ----------------------------------------------------------------------------------------------------------------------------------------------------
	-- 修改解锁条件和造价
update Buildings set cost = 750, PrereqTech = 'TECH_METAL_CASTING', RegionalRange = 9 where BuildingType = 'NAT_WONDER_CL_IRONWORKS'; --AdjacentResource = 'RESOURCE_IRON', 
update Buildings set cost = 750, PrereqTech = 'TECH_METAL_CASTING', RegionalRange = 9 where BuildingType = 'NAT_WONDER_CL_IRONWORKS_INTERNAL'; --AdjacentResource = 'RESOURCE_IRON', 
	-- 修改建造条件
update RequirementArguments set Value = 4 where RequirementId = 'REQ_CL_PLAYER_HAS_X_STRATEGIC_IMPROVEMENTS' and Name = 'Count';

	-- 修改本体产出
update Building_YieldChanges set YieldChange = 2 where BuildingType = 'NAT_WONDER_CL_IRONWORKS' and YieldType = 'YIELD_PRODUCTION';
update Building_YieldChanges set YieldChange = 2 where BuildingType = 'NAT_WONDER_CL_IRONWORKS_INTERNAL' and YieldType = 'YIELD_PRODUCTION';
update Building_GreatPersonPoints set PointsPerTurn = 2
	where BuildingType in ('NAT_WONDER_CL_IRONWORKS','NAT_WONDER_CL_IRONWORKS_INTERNAL') and GreatPersonClassType = 'GREAT_PERSON_CLASS_ENGINEER';

insert or replace into Building_GreatPersonPoints
	(BuildingType,                  		GreatPersonClassType,           PointsPerTurn)
values  
	('NAT_WONDER_CL_IRONWORKS',      		'GREAT_PERSON_CLASS_SCIENTIST', 2),
	('NAT_WONDER_CL_IRONWORKS_INTERNAL','GREAT_PERSON_CLASS_SCIENTIST', 2);

	-- 修改特效
delete from BuildingModifiers where BuildingType = 'NAT_WONDER_CL_IRONWORKS' and ModifierId = 'CL_NAT_WONDER_ATTACH_STRATEGIC_YIELD_MODIFIER';

	-- 战略
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'NAT_WONDER_CL_IRONWORKS', 'HD_NAT_IRONWORKS_CITIES_SCIENCE_' || ResourceType
	from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	select 'HD_NAT_IRONWORKS_CITIES_SCIENCE_' || ResourceType, 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS',	'HD_OBJECT_WITHIN_9_TILES'
	from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_NAT_IRONWORKS_CITIES_SCIENCE_' || ResourceType, 'YieldType', 'YIELD_SCIENCE'
	from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_NAT_IRONWORKS_CITIES_SCIENCE_' || ResourceType, 'Amount', 2
	from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'NAT_WONDER_CL_IRONWORKS', 'HD_NAT_IRONWORKS_CITIES_SCIENTIST_' || ResourceType
	from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	select 'HD_NAT_IRONWORKS_CITIES_SCIENTIST_' || ResourceType, 'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', 'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS',	'HD_CITY_CENTER_WITHIN_9_TILES'
	from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_NAT_IRONWORKS_CITIES_SCIENTIST_' || ResourceType, 'GreatPersonClassType', 'GREAT_PERSON_CLASS_SCIENTIST'
	from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_NAT_IRONWORKS_CITIES_SCIENTIST_' || ResourceType, 'Amount', 2
	from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

	-- 加成
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'NAT_WONDER_CL_IRONWORKS', 'HD_NAT_IRONWORKS_CITIES_PRODUCTION_' || a.ResourceType
	from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
	where a.ResourceClassType = 'RESOURCECLASS_BONUS' and b.ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY');
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	select 'HD_NAT_IRONWORKS_CITIES_PRODUCTION_' || a.ResourceType, 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'HD_CITY_HAS_IMPROVED_' || a.ResourceType || '_REQUIRMENTS',	'HD_OBJECT_WITHIN_9_TILES'
	from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
	where a.ResourceClassType = 'RESOURCECLASS_BONUS' and b.ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY');
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_NAT_IRONWORKS_CITIES_PRODUCTION_' || a.ResourceType, 'YieldType', 'YIELD_PRODUCTION'
	from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
	where a.ResourceClassType = 'RESOURCECLASS_BONUS' and b.ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY');
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_NAT_IRONWORKS_CITIES_PRODUCTION_' || a.ResourceType, 'Amount', 2
	from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
	where a.ResourceClassType = 'RESOURCECLASS_BONUS' and b.ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY');

insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'NAT_WONDER_CL_IRONWORKS', 'HD_NAT_IRONWORKS_CITIES_ENGINEER_' || a.ResourceType
	from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
	where a.ResourceClassType = 'RESOURCECLASS_BONUS' and b.ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY');
insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	select 'HD_NAT_IRONWORKS_CITIES_ENGINEER_' || a.ResourceType, 'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', 'HD_CITY_HAS_IMPROVED_' || a.ResourceType || '_REQUIRMENTS',	'HD_CITY_CENTER_WITHIN_9_TILES'
	from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
	where a.ResourceClassType = 'RESOURCECLASS_BONUS' and b.ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY');
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_NAT_IRONWORKS_CITIES_ENGINEER_' || a.ResourceType, 'GreatPersonClassType', 'GREAT_PERSON_CLASS_ENGINEER'
	from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
	where a.ResourceClassType = 'RESOURCECLASS_BONUS' and b.ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY');
insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_NAT_IRONWORKS_CITIES_ENGINEER_' || a.ResourceType, 'Amount', 2
	from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
	where a.ResourceClassType = 'RESOURCECLASS_BONUS' and b.ImprovementType in ('IMPROVEMENT_MINE','IMPROVEMENT_QUARRY');

-- 金融中心 ----------------------------------------------------------------------------------------------------------------------------------------------------
	-- 修改解锁条件和造价
update Buildings set PrereqTech = null, PrereqCivic = 'CIVIC_FINANCE_HD', cost = 1800 where BuildingType = 'NAT_WON_CL_FINANCE';
update Buildings set PrereqTech = null, PrereqCivic = 'CIVIC_FINANCE_HD', cost = 1800 where BuildingType = 'NAT_WON_CL_FINANCE_INTERNAL';
update Building_YieldChanges set YieldChange = 8 where BuildingType = 'NAT_WON_CL_FINANCE' and YieldType = 'YIELD_GOLD';

insert or replace into Building_YieldChanges
	(BuildingType,							YieldType,			YieldChange)
values
	('NAT_WON_CL_FINANCE',					'YIELD_GOLD',		18),
	('NAT_WON_CL_FINANCE_INTERNAL',			'YIELD_GOLD',		18);
insert or replace into Building_YieldChangesBonusWithPower
	(BuildingType,							YieldType,			YieldChange)
values
	('NAT_WON_CL_FINANCE',					'YIELD_GOLD',		6),
	('NAT_WON_CL_FINANCE_INTERNAL',			'YIELD_GOLD',		6);
	-- 修改特效
update ModifierArguments set Value = 2 where ModifierId = 'CL_NAT_WONDER_ADJUST_TRADE_ROUTE_YIELD_INTERNATIONAL_01' and Name = 'Amount';
update ModifierArguments set Value = 4 where ModifierId = 'CL_NAT_WONDER_ADJUST_TRADE_ROUTE_YIELD_INTERNATIONAL_02' and Name = 'Amount';

insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('NAT_WON_CL_FINANCE',			'HD_NAT_FINANCE_GP_GOLD_DISCOUNT');

insert or replace into Modifiers
	(ModifierId,							ModifierType)
values
	('HD_NAT_FINANCE_GP_GOLD_DISCOUNT',		'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_PATRONAGE_DISCOUNT_PERCENT');

insert or replace into ModifierArguments
	(ModifierId,							Name,			Value)
values
	('HD_NAT_FINANCE_GP_GOLD_DISCOUNT',		'YieldType',	'YIELD_GOLD'),
	('HD_NAT_FINANCE_GP_GOLD_DISCOUNT',		'Amount',		50);

	-- 公司模式
delete from BuildingModifiers where BuildingType = 'NAT_WON_CL_FINANCE' and ModifierId in
	(	'CL_NAT_WONDER_ATTACH_COMMERCIAL_YIELD_MODIFIER',
		'CL_NAT_WONDER_ATTACH_BANK_GOLD_TRADEROUTE_YIELD',
		'CL_NAT_WONDER_ATTACH_STOCKEXCHANGE_GOLD_TRADEROUTE_YIELD')
	and exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

update Buildings set Description = 'LOC_NAT_WON_CL_FINANCE_CORP_DESCRIPTION', AdjacentImprovement = 'IMPROVEMENT_CORPORATION', AdjacentDistrict = null
	where BuildingType = 'NAT_WON_CL_FINANCE' and exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');
update Buildings set Description = 'LOC_NAT_WON_CL_FINANCE_CORP_DESCRIPTION_INTERNAL', AdjacentImprovement = 'IMPROVEMENT_CORPORATION', AdjacentDistrict = null
	where BuildingType = 'NAT_WON_CL_FINANCE_INTERNAL' and exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

------------- 公司业绩
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'NAT_WON_CL_FINANCE',			'HD_NAT_FINANCE_CORP_TOURISM'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into Modifiers
	(ModifierId,					ModifierType)
select
	'HD_NAT_FINANCE_CORP_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,					Name,				Value)
select
	'HD_NAT_FINANCE_CORP_TOURISM',	'ImprovementType',	'IMPROVEMENT_CORPORATION'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,					Name,				Value)
select
	'HD_NAT_FINANCE_CORP_TOURISM',	'ScalingFactor',	300
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');
------------- 公司金币百分比
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'NAT_WON_CL_FINANCE',			'HD_NAT_FINANCE_CORP_GOLD_BONUS'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into Modifiers
	(ModifierId,					ModifierType,				SubjectRequirementSetId)
select
	'HD_NAT_FINANCE_CORP_GOLD_BONUS',	'MODIFIER_PLAYER_IMPROVEMENTS_ATTACH_MODIFIER',	'PLOT_HAS_IMPROVEMENT_CORPORATION_REQUIREMENTS'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into Modifiers
	(ModifierId,					ModifierType)
select
	'HD_NAT_FINANCE_CORP_GOLD_BONUS_MODIFIER',	'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,					Name,				Value)
select
	'HD_NAT_FINANCE_CORP_GOLD_BONUS',	'ModifierId',	'HD_NAT_FINANCE_CORP_GOLD_BONUS_MODIFIER'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,					Name,				Value)
select
	'HD_NAT_FINANCE_CORP_GOLD_BONUS_MODIFIER',	'YieldType',	'YIELD_GOLD'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,					Name,				Value)
select
	'HD_NAT_FINANCE_CORP_GOLD_BONUS_MODIFIER',	'Amount',	20
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');
------------- 产品产出
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'NAT_WON_CL_FINANCE',			'HD_NAT_FINANCE_PRODUCT_' || YieldType
from Yields
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into Modifiers
	(ModifierId,							ModifierType,										SubjectRequirementSetId)
select
	'HD_NAT_FINANCE_PRODUCT_' || YieldType,	'MODIFIER_PLAYER_CITIES_ADJUST_GREATWORK_YIELD',	'HD_CITY_HAS_COMMERCIAL_TIER_3_BUILDING_REQUIREMENTS'
from Yields
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,							Name,					Value)
select
	'HD_NAT_FINANCE_PRODUCT_' || YieldType,	'GreatWorkObjectType',	'GREATWORKOBJECT_PRODUCT'
from Yields
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,							Name,					Value)
select
	'HD_NAT_FINANCE_PRODUCT_' || YieldType,	'YieldType',			YieldType
from Yields
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,							Name,					Value)
select
	'HD_NAT_FINANCE_PRODUCT_' || YieldType,	'ScalingFactor',		200
from Yields
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or ignore into RequirementSets
	(RequirementSetId,												RequirementSetType)
values
	('HD_CITY_HAS_COMMERCIAL_TIER_3_BUILDING_REQUIREMENTS',		    'REQUIREMENTSET_TEST_ANY');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
values
	('HD_CITY_HAS_COMMERCIAL_TIER_3_BUILDING_REQUIREMENTS',		    'REQUIRES_CITY_HAS_BUILDING_STOCK_EXCHANGE');

-- 国际机场 ----------------------------------------------------------------------------------------------------------------------------------------------------
	-- 修改解锁条件和造价
update Buildings set cost = 2000, AdjacentDistrict = NULL where BuildingType = 'NAT_WON_CL_AIRPORT';
update Buildings set cost = 2000, AdjacentDistrict = NULL where BuildingType = 'NAT_WON_CL_AIRPORT_INTERNAL';
insert or replace into Building_YieldChanges
	(BuildingType,							YieldType,			YieldChange)
values
	('NAT_WON_CL_AIRPORT',					'YIELD_GOLD',		6),
	('NAT_WON_CL_AIRPORT_INTERNAL',			'YIELD_GOLD',		6);
insert or replace into Building_YieldChangesBonusWithPower
	(BuildingType,							YieldType,			YieldChange)
values
	('NAT_WON_CL_AIRPORT',					'YIELD_GOLD',		6),
	('NAT_WON_CL_AIRPORT_INTERNAL',			'YIELD_GOLD',		6);
	-- 修改建造条件
update Modifiers set OwnerRequirementSetId = NULL where ModifierId = 'CL_NAT_WONDER_ALLOW_BUILDING_AIRPORT';
	-- 修改特效
delete from BuildingModifiers where BuildingType = 'NAT_WON_CL_AIRPORT';

insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('NAT_WON_CL_AIRPORT',			'HD_NAT_AIRPORT_3_TRADE'),
	('NAT_WON_CL_AIRPORT',			'HD_NAT_AIRPORT_DIPLO');
	-- ('NAT_WON_CL_AIRPORT',			'HD_NAT_AIRPORT_LUMBERMILL_TOURISM'),
	-- ('NAT_WON_CL_AIRPORT',			'HD_NAT_AIRPORT_PLANTATION_TOURISM');

insert or replace into BuildingModifiers(BuildingType,	ModifierId)
select 'NAT_WON_CL_AIRPORT', 'HD_NAT_AIRPORT_' || ImprovementType || '_TOURISM'
from Improvement_Tourism where PrereqTech = 'TECH_FLIGHT';

insert or replace into Modifiers(ModifierId,	ModifierType,	SubjectRequirementSetId)
select 'HD_NAT_AIRPORT_' || ImprovementType || '_TOURISM', 'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM', 'HD_CITY_HAS_AIRPORT_OR_NATAIRPORT'
from Improvement_Tourism where PrereqTech = 'TECH_FLIGHT';

insert or replace into ModifierArguments(ModifierId,	Name,	Value)
select 'HD_NAT_AIRPORT_' || ImprovementType || '_TOURISM', 'ImprovementType', ImprovementType
from Improvement_Tourism where PrereqTech = 'TECH_FLIGHT';

insert or replace into ModifierArguments(ModifierId,	Name,	Value)
select 'HD_NAT_AIRPORT_' || ImprovementType || '_TOURISM', 'ScalingFactor', 200
from Improvement_Tourism where PrereqTech = 'TECH_FLIGHT';

insert or replace into Modifiers
	(ModifierId,							ModifierType,									SubjectRequirementSetId)
values
	('HD_NAT_AIRPORT_3_TRADE',				'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',	NULL),
	('HD_NAT_AIRPORT_DIPLO',				'MODIFIER_PLAYER_ADD_DIPLO_VISIBILITY',			NULL),
	('HD_NAT_AIRPORT_LUMBERMILL_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',		'HD_CITY_HAS_AIRPORT_OR_NATAIRPORT'),
	('HD_NAT_AIRPORT_PLANTATION_TOURISM',	'MODIFIER_PLAYER_CITIES_ADJUST_TOURISM',		'HD_CITY_HAS_AIRPORT_OR_NATAIRPORT');

insert or replace into ModifierArguments
	(ModifierId,							Name,				Value)
values
	('HD_NAT_AIRPORT_3_TRADE',				'Amount',			3),
	('HD_NAT_AIRPORT_DIPLO',				'Amount',			1),
	('HD_NAT_AIRPORT_DIPLO',				'Source',			'SOURCE_NAT_AIRPORT'),
	('HD_NAT_AIRPORT_DIPLO',				'SourceType',		'DIPLO_SOURCE_ALL_NAMES'),
	('HD_NAT_AIRPORT_LUMBERMILL_TOURISM',	'ImprovementType',	'IMPROVEMENT_LUMBER_MILL'),
	('HD_NAT_AIRPORT_LUMBERMILL_TOURISM',	'ScalingFactor',	150),
	('HD_NAT_AIRPORT_PLANTATION_TOURISM',	'ImprovementType',	'IMPROVEMENT_PLANTATION'),
	('HD_NAT_AIRPORT_PLANTATION_TOURISM',	'ScalingFactor',	150);

insert or replace into DiplomaticVisibilitySources
    (VisibilitySourceType,		Description,                	ActionDescription,                  	GossipString,                  	   PrereqTech)
values
    ('SOURCE_NAT_AIRPORT',		'LOC_VIZSOURCE_NAT_AIRPORT',	'LOC_VIZSOURCE_ACTION_NAT_AIRPORT',   	'LOC_GOSSIP_SOURCE_NAT_AIRPORT',   'TECH_ADVANCED_FLIGHT');

insert or ignore into RequirementSets
	(RequirementSetId,						RequirementSetType)
values
	('HD_CITY_HAS_AIRPORT_OR_NATAIRPORT',	'REQUIREMENTSET_TEST_ANY'),
	('HD_PLAYER_HAS_NAT_AIRPORT', 			'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
values
	('HD_CITY_HAS_AIRPORT_OR_NATAIRPORT',	'REQUIRES_CITY_HAS_BUILDING_AIRPORT'),
	('HD_CITY_HAS_AIRPORT_OR_NATAIRPORT',	'REQUIRES_CITY_HAS_NAT_WON_CL_AIRPORT'),
	('HD_PLAYER_HAS_NAT_AIRPORT', 			'REQUIRES_PLAYER_HAS_NAT_AIRPOR');

insert or ignore into Requirements
	(RequirementId,							RequirementType)
values
	('REQUIRES_PLAYER_HAS_NAT_AIRPOR',		'REQUIREMENT_PLAYER_HAS_BUILDING');

insert or ignore into RequirementArguments
	(RequirementId,							Name,				Value)
values
	('REQUIRES_PLAYER_HAS_NAT_AIRPOR',		'BuildingType',		'NAT_WON_CL_AIRPORT');

insert or replace into DistrictModifiers (DistrictType, ModifierId)
select DistrictType, DistrictType || '_' || YieldType || '_FROM_OTHERS_NAT_AIRPORT'
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
select DistrictType || '_' || YieldType || '_FROM_OTHERS_NAT_AIRPORT',
    'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FROM_OTHERS',
    'HD_PLAYER_HAS_NAT_AIRPORT'
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_FROM_OTHERS_NAT_AIRPORT', 'YieldType', YieldType
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_FROM_OTHERS_NAT_AIRPORT', 'Amount', YieldChangeAsInternationalDestination
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

-- For International
insert or replace into DistrictModifiers (DistrictType, ModifierId)
select DistrictType, DistrictType || '_' || YieldType || '_FOR_INTERNATIONAL_NAT_AIRPORT'
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId)
select DistrictType || '_' || YieldType || '_FOR_INTERNATIONAL_NAT_AIRPORT',
    'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',
    'HD_PLAYER_HAS_NAT_AIRPORT'
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_FOR_INTERNATIONAL_NAT_AIRPORT', 'YieldType', YieldType
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_FOR_INTERNATIONAL_NAT_AIRPORT', 'Amount', YieldChangeAsInternationalDestination
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;
	-----------------------------
insert or replace into DistrictModifiers (DistrictType, ModifierId)
select DistrictType, DistrictType || '_' || YieldType || '_FROM_OTHERS_NAT_AIRPORT2'
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
select DistrictType || '_' || YieldType || '_FROM_OTHERS_NAT_AIRPORT2',
    'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FROM_OTHERS',
    'HD_PLAYER_HAS_NAT_AIRPORT',
    'HD_CITY_HAS_AIRPORT_OR_NATAIRPORT'
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_FROM_OTHERS_NAT_AIRPORT2', 'YieldType', YieldType
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_FROM_OTHERS_NAT_AIRPORT2', 'Amount', YieldChangeAsInternationalDestination
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

-- For International
insert or replace into DistrictModifiers (DistrictType, ModifierId)
select DistrictType, DistrictType || '_' || YieldType || '_FOR_INTERNATIONAL_NAT_AIRPORT2'
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
select DistrictType || '_' || YieldType || '_FOR_INTERNATIONAL_NAT_AIRPORT2',
    'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',
    'HD_PLAYER_HAS_NAT_AIRPORT',
    'HD_CITY_HAS_AIRPORT_OR_NATAIRPORT'
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_FOR_INTERNATIONAL_NAT_AIRPORT2', 'YieldType', YieldType
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;
insert or replace into ModifierArguments (ModifierId, Name, Value)
select DistrictType || '_' || YieldType || '_FOR_INTERNATIONAL_NAT_AIRPORT2', 'Amount', YieldChangeAsInternationalDestination
from District_TradeRouteYields
where DistrictType != 'DISTRICT_CITY_CENTER' and YieldChangeAsInternationalDestination != 0;