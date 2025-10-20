--梁左2
insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType,						ModifierId)
select
	'GOVERNOR_PROMOTION_ZONING_COMMISSIONER',	'ZONING_COMMISSIONER_' || BuildingType || '_' || YieldType
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1);

insert or replace into Modifiers
	(ModifierId,																ModifierType)
select
	'ZONING_COMMISSIONER_' || BuildingType || '_' || YieldType,					'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER'
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1) union all
select
	'ZONING_COMMISSIONER_' || BuildingType || '_' || YieldType || '_MODIFIER',	'MODIFIER_BUILDING_YIELD_CHANGE'
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1);

insert or replace into ModifierArguments
	(ModifierId,																Name,				Value)
select
	'ZONING_COMMISSIONER_' || BuildingType || '_' || YieldType,					'ModifierId',		'ZONING_COMMISSIONER_' || BuildingType || '_' || YieldType || '_MODIFIER'
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1) union all
select
	'ZONING_COMMISSIONER_' || BuildingType || '_' || YieldType || '_MODIFIER',	'Amount',			YieldChange
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1) union all
select
	'ZONING_COMMISSIONER_' || BuildingType || '_' || YieldType || '_MODIFIER',	'BuildingType',		BuildingType
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1) union all
select
	'ZONING_COMMISSIONER_' || BuildingType || '_' || YieldType || '_MODIFIER',	'YieldType',		YieldType
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1);

-- 梁3
insert or replace into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
	'GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE',	'REINFORCED_INFRASTRUCTURE_' || DistrictType || '_BONUS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
	'GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE',	'REINFORCED_INFRASTRUCTURE_' || DistrictType || '_BONUS_LATE'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
	'REINFORCED_INFRASTRUCTURE_' || DistrictType || '_BONUS',
	'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',
	'REQUIRES_DISTRICT_IS_' || DistrictType || '_WITHIN_4_TILES_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) select
	'REINFORCED_INFRASTRUCTURE_' || DistrictType || '_BONUS_LATE',
	'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',
	'PLAYER_HAS_TECH_ARCH_HD_REQUIREMENTS',
	'REQUIRES_DISTRICT_IS_' || DistrictType || '_WITHIN_4_TILES_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'REINFORCED_INFRASTRUCTURE_' || DistrictType || '_BONUS', 'YieldType', YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'REINFORCED_INFRASTRUCTURE_' || DistrictType || '_BONUS', 'Amount', 50
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'REINFORCED_INFRASTRUCTURE_' || DistrictType || '_BONUS_LATE', 'YieldType', YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'REINFORCED_INFRASTRUCTURE_' || DistrictType || '_BONUS_LATE', 'Amount', 50
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 梁右4
-- 新版市立公园
	-- 区域加产
insert or replace into ImprovementModifiers
	(ImprovementType, 				ModifierId)
select
	'IMPROVEMENT_CITY_PARK',	'PARKS_RECREATION_' || DistrictType || '_YIELD_BONUS'
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into Modifiers
	(ModifierId,																						ModifierType,																SubjectRequirementSetId)
select
	'PARKS_RECREATION_' || DistrictType || '_YIELD_BONUS',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',  'REQUIRES_CITY_HAS_' || DistrictType ||'_UDMET'
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into ModifierArguments
	(ModifierId,																						Name,					Value)
select
	'PARKS_RECREATION_' || DistrictType || '_YIELD_BONUS',	'YieldType',	YieldType
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into ModifierArguments
	(ModifierId,																						Name,					Value)
select
	'PARKS_RECREATION_' || DistrictType || '_YIELD_BONUS',	'Amount',			Amount
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

	-- 建筑加成
insert or replace into ImprovementModifiers
	(ImprovementType, 				ModifierId)
select
	'IMPROVEMENT_CITY_PARK',	'PARKS_RECREATION_' || a.BuildingType || '_YIELD_BONUS'
from Buildings a inner join DistrictCorrespondingYieldType_HD b on a.PrereqDistrict = b.DistrictType
	where b.RequiresPopulation = 1
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into Modifiers
	(ModifierId,																							ModifierType,																		SubjectRequirementSetId)
select
	'PARKS_RECREATION_' || a.BuildingType || '_YIELD_BONUS',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',  		'CITY_HAS_' || a.BuildingType || '_REQUIREMENTS'
from Buildings a inner join DistrictCorrespondingYieldType_HD b on a.PrereqDistrict = b.DistrictType
	where b.RequiresPopulation = 1
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into ModifierArguments
	(ModifierId,																							Name,					Value)
select
	'PARKS_RECREATION_' || a.BuildingType || '_YIELD_BONUS',	'YieldType',	b.YieldType
from Buildings a inner join DistrictCorrespondingYieldType_HD b on a.PrereqDistrict = b.DistrictType
	where b.RequiresPopulation = 1
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into ModifierArguments
	(ModifierId,																							Name,					Value)
select
	'PARKS_RECREATION_' || a.BuildingType || '_YIELD_BONUS',	'Amount',			b.Amount
from Buildings a inner join DistrictCorrespondingYieldType_HD b on a.PrereqDistrict = b.DistrictType
	where b.RequiresPopulation = 1
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

-- 红胡子LA 总督城市可以信仰买区域
insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType,						ModifierId)
select
	GovernorPromotionType,						'HD_HOLY_ROMAN_GOVERNOR_FAITH_PURCHASE_DISTRICT'
from GovernorPromotions where Level = 0 and BaseAbility = 1;

insert or replace into Modifiers
	(ModifierId,																					ModifierType,																									OwnerRequirementSetId)
values
	('HD_HOLY_ROMAN_GOVERNOR_FAITH_PURCHASE_DISTRICT',		'MODIFIER_GOVERNOR_ADJUST_CAN_FAITH_PURCHASE_DISTRICTS',			'HD_PLAYER_IS_LEADER_BARBAROSSA_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,																					Name,						Value)
values
	('HD_HOLY_ROMAN_GOVERNOR_FAITH_PURCHASE_DISTRICT',		'CanPurchase',	'true');

-- 主教4
insert or replace into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
	'GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT', 'CARDINAL_DIVINE_ARCHITECT_' || DistrictType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
	'CARDINAL_DIVINE_ARCHITECT_' || DistrictType, 'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS', 'DISTRICT_IS_' || DistrictType || '_WITHIN_6_TILES_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'CARDINAL_DIVINE_ARCHITECT_' || DistrictType, 'YieldTypeToMirror', YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'CARDINAL_DIVINE_ARCHITECT_' || DistrictType, 'YieldTypeToGrant', 'YIELD_FAITH'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 马右4
insert or replace into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION', 'HD_VERTICAL_INTEGRATION_' || DistrictType || '_ATTACH'
from DistrictCorrespondingYieldType_HD;

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select
	'HD_VERTICAL_INTEGRATION_' || DistrictType || '_ATTACH', 'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER', 'DISTRICT_IS_' || DistrictType || '_WITHIN_6_TILES_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_VERTICAL_INTEGRATION_' || DistrictType || '_ATTACH', 'ModifierId', 'HD_VERTICAL_INTEGRATION_' || DistrictType
from DistrictCorrespondingYieldType_HD;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) select
	'HD_VERTICAL_INTEGRATION_' || DistrictType, 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'CITY_HAS_NO_VERTICAL_INTEGRATION_REQUIREMENTS', 'CITY_HAS_VERTICAL_INTEGRATION_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_VERTICAL_INTEGRATION_' || DistrictType, 'YieldType', YieldType
from DistrictCorrespondingYieldType_HD;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
	'HD_VERTICAL_INTEGRATION_' || DistrictType, 'Amount', Amount
from DistrictCorrespondingYieldType_HD;