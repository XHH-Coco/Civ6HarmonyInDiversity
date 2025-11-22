-------------------------------------
--      Governors Adjustments      --
-------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-- Magnus-总务官=马格努斯=老马
-- 调整顺序
update GovernorPromotions set Level = 1, column = 2, BaseAbility = 0 where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER';
update GovernorPromotions set Level = 0, column = 1, BaseAbility = 1 where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION';
update GovernorPromotions set Level = 2, column = 1, BaseAbility = 0 where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
update GovernorPromotions set Level = 3, column = 0, BaseAbility = 0 where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
update GovernorPromotions set Level = 3, column = 2, BaseAbility = 0 where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION';

update GovernorPromotionPrereqs set PrereqGovernorPromotion = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION'
	where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS';
update GovernorPromotionPrereqs set PrereqGovernorPromotion = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER'
	where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
update GovernorPromotionPrereqs set
	GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER',
	PrereqGovernorPromotion = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION'
	where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION'
	and PrereqGovernorPromotion = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER';

delete from GovernorPromotionPrereqs where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';

insert or replace into GovernorPromotionPrereqs	(GovernorPromotionType, 			PrereqGovernorPromotion) values
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER',	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS'),
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST',	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER');

delete from GovernorPromotionSets where GovernorType = 'GOVERNOR_THE_RESOURCE_MANAGER';
insert or replace into GovernorPromotionSets (GovernorType, GovernorPromotion) values
	('GOVERNOR_THE_RESOURCE_MANAGER', 	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION'),
	('GOVERNOR_THE_RESOURCE_MANAGER', 	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS'),
	('GOVERNOR_THE_RESOURCE_MANAGER', 	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER'),
	('GOVERNOR_THE_RESOURCE_MANAGER', 	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER'),
	('GOVERNOR_THE_RESOURCE_MANAGER', 	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST'),
	('GOVERNOR_THE_RESOURCE_MANAGER', 	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION');

-- 删除原效果
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER';
-- delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION';

-- update ModifierArguments set Value = 30 where ModifierId = 'SURPLUS_LOGISTICS_EXTRA_GROWTH' and Name = 'Amount';
update ModifierArguments set Value = 4 where ModifierId = 'SURPLUS_LOGISTICS_TRADE_ROUTE_FOOD' and Name = 'Amount';

-- 新增效果
insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType,											ModifierId)
values
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER',			'MAGNUS_EXTRA_DISTRICT'),
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER',			'MAGNUS_FASTER_DISTRICT_CONSTRUCTION'),
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER',			'MAGNUS_FASTER_BUILDING_CONSTRUCTION'),
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER',			'MAGNUS_ADJUST_CITY_YIELD'),
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST',			'MAGNUS_REGIONAL_EARLY_FOOD'),
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST',			'MAGNUS_REGIONAL_EARLY_PRODUCTION'),
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST',			'MAGNUS_REGIONAL_LATE_FOOD'),
	('GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST',			'MAGNUS_REGIONAL_LATE_PRODUCTION');

insert or replace into Modifiers
	(ModifierId,													ModifierType,													OwnerRequirementSetId,							SubjectRequirementSetId)
values
	('MAGNUS_EXTRA_DISTRICT',										'MODIFIER_SINGLE_CITY_EXTRA_DISTRICT',							null,											null),
	('MAGNUS_FASTER_DISTRICT_CONSTRUCTION',							'MODIFIER_CITY_INCREASE_DISTRICT_PRODUCTION_RATE',				null,											null),
	('MAGNUS_FASTER_BUILDING_CONSTRUCTION',							'MODIFIER_SINGLE_CITY_ADJUST_ALLBUILDING_PRODUCTION_MODIFIER',	null,											null),
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PRODUCTION',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS',		null,											null),
	('MAGNUS_ADJUST_CITY_YIELD',									'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',				null,											null),
	('MAGNUS_PLACEHOLDER',											'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',						null,											null),
	('MAGNUS_REGIONAL_EARLY_FOOD',									'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',				null,											'HD_OBJECT_WITHIN_9_TILES'),
	('MAGNUS_REGIONAL_EARLY_PRODUCTION',							'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',				null,											'HD_OBJECT_WITHIN_9_TILES'),
	('MAGNUS_REGIONAL_LATE_FOOD',									'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',				'PLAYER_HAS_CIVIC_CIVIL_SERVICE_REQUIREMENTS',	'HD_OBJECT_WITHIN_9_TILES'),
	('MAGNUS_REGIONAL_LATE_PRODUCTION',								'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',				'PLAYER_HAS_CIVIC_CIVIL_SERVICE_REQUIREMENTS',	'HD_OBJECT_WITHIN_9_TILES');

insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
values
	('MAGNUS_EXTRA_DISTRICT',							'Amount',			1),
	('MAGNUS_FASTER_DISTRICT_CONSTRUCTION',				'Amount',			30),
	('MAGNUS_FASTER_BUILDING_CONSTRUCTION',				'Amount',			30),
	('MAGNUS_FASTER_BUILDING_CONSTRUCTION',				'IsWonder',			0),
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PRODUCTION',		'YieldType',		'YIELD_PRODUCTION'),
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PRODUCTION',		'Amount',			1),
	('SURPLUS_LOGISTICS_TRADE_ROUTE_PRODUCTION',		'Domestic',			1),
	('MAGNUS_ADJUST_CITY_YIELD',						'YieldType',		'YIELD_FOOD, YIELD_PRODUCTION'),
	('MAGNUS_ADJUST_CITY_YIELD',						'Amount',			'20,20'),
	('MAGNUS_PLACEHOLDER',								'YieldType',		'YIELD_GOLD'),
	('MAGNUS_PLACEHOLDER',								'Amount',			0),
	('MAGNUS_REGIONAL_EARLY_FOOD',						'YieldType',		'YIELD_FOOD'),
	('MAGNUS_REGIONAL_EARLY_FOOD',						'Amount',			5),
	('MAGNUS_REGIONAL_EARLY_PRODUCTION',				'YieldType',		'YIELD_PRODUCTION'),
	('MAGNUS_REGIONAL_EARLY_PRODUCTION',				'Amount',			5),
	('MAGNUS_REGIONAL_LATE_FOOD',						'YieldType',		'YIELD_FOOD'),
	('MAGNUS_REGIONAL_LATE_FOOD',						'Amount',			5),
	('MAGNUS_REGIONAL_LATE_PRODUCTION',					'YieldType',		'YIELD_PRODUCTION'),
	('MAGNUS_REGIONAL_LATE_PRODUCTION',					'Amount',			5);

-- -----------------------------------------------------------------------------------------------------------------------------------

-- Reyna -金融家=瑞娜
-- 删除原效果
-- 基础 改名港务局长
delete from GovernorPromotionModifiers where ModifierId = 'LAND_ACQUISITION_FASTER_PLOT_ANNEXING';
delete from GovernorPromotionModifiers where ModifierId = 'FOREIGN_EXCHANGE_GOLD_FROM_FOREIGN_TRADE_PASSING_THROUGH';
-- 右一林业管理（改名财政大臣）
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_MERCHANT_FORESTRY_MANAGEMENT';
-- 中二税务员（改名市舶榷务）
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR';
-- 左三发包人（改名金融中心）
delete from GovernorPromotionModifiers where ModifierId = 'CONTRACTOR_ENABLE_DISTRICT_PURCHASE';
-- 移除再生资源补贴升级
delete from GovernorPromotions where GovernorPromotionType = 'GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';

-- 跨国公司取缔再生资源补贴
insert or replace into Types
	(Type, Kind)
values
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP', 'KIND_GOVERNOR_PROMOTION');

insert or replace into GovernorPromotions
	(GovernorPromotionType, Name, Description, Level, Column, BaseAbility)
values
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP', 'LOC_GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP_NAME', 'LOC_GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP_DESCRIPTION', 3, 2, 0);

insert or replace into GovernorPromotionSets
	(GovernorType, GovernorPromotion)
values
	('GOVERNOR_THE_MERCHANT', 'GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP');

insert or replace into GovernorPromotionPrereqs
	(GovernorPromotionType, PrereqGovernorPromotion)
values
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP', 'GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR');

-- 新增效果
-- 单城区域产出
-- insert or replace into Types
-- 	(Type,												Kind)
-- values
-- 	('MODIFIER_REYNA_ADJUST_DISTRICTS_YIELD_CHANGE',	'KIND_MODIFIER');
-- insert or replace into DynamicModifiers
-- 	(ModifierType,										CollectionType,										EffectType)
-- values
-- 	('MODIFIER_REYNA_ADJUST_DISTRICTS_YIELD_CHANGE',	'COLLECTION_CITY_DISTRICTS',						'EFFECT_ADJUST_DISTRICT_YIELD_CHANGE');

insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType,								ModifierId)
values
-- 林业管理
	('GOVERNOR_PROMOTION_MERCHANT_FORESTRY_MANAGEMENT',	'REYNA_UNIT_DISCOUNT'),
	('GOVERNOR_PROMOTION_MERCHANT_FORESTRY_MANAGEMENT',	'REYNA_UNIT_EXTRA_DISCOUNT'),
-- 地产商人
	('GOVERNOR_PROMOTION_MERCHANT_LAND_ACQUISITION',	'REYNA_POPULATION_GOLD'),
--	('GOVERNOR_PROMOTION_MERCHANT_LAND_ACQUISITION',	'REYNA_TRADEROUTE'),
-- 港务局长
	('GOVERNOR_PROMOTION_MERCHANT_HARBORMASTER',		'REYNA_EXTRA_DISTRICT'),
-- 市舶榷务
	('GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR',		'REYNA_TRADEROUTE'),
-- 金融中心
	('GOVERNOR_PROMOTION_MERCHANT_CONTRACTOR',		'REYNA_CONTRACTOR_GOLD'),
	('GOVERNOR_PROMOTION_MERCHANT_CONTRACTOR',		'REYNA_CONTRACTOR_GOLD_COMMERCIAL'),
	('GOVERNOR_PROMOTION_MERCHANT_CONTRACTOR',		'REYNA_CONTRACTOR_GOLD_HARBOR'),
-- 远洋贸易
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP',		'REYNA_MULTINATIONAL_CORP_TRADE_GOLD_0'),
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP',		'REYNA_MULTINATIONAL_CORP_TRADE_GOLD_1'),
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP',		'REYNA_MULTINATIONAL_CORP_TRADE_GOLD_2'),
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP',		'REYNA_MULTINATIONAL_CORP_TRADE_GOLD_3'),
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP',		'REYNA_MULTINATIONAL_CORP_TRADE_GOLD_4'),
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP',		'REYNA_MULTINATIONAL_CORP_TRADE_GOLD_5'),
	('GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP',		'REYNA_MULTINATIONAL_CORP_TRADE_GOLD_6');


insert or replace into Modifiers
	(ModifierId,										ModifierType,													SubjectRequirementSetId)
values
-- 林业管理
	('REYNA_UNIT_DISCOUNT',								'MODIFIER_SINGLE_CITY_ADJUST_ALL_UNITS_PURCHASE_COST',			NULL),
	('REYNA_UNIT_EXTRA_DISCOUNT',						'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',				NULL),
-- 地产商人
	('REYNA_POPULATION_GOLD',							'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',		null),
	('REYNA_TRADEROUTE',								'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',					null),
-- 港务局长
	('REYNA_EXTRA_DISTRICT',							'MODIFIER_SINGLE_CITY_EXTRA_DISTRICT',							'CITY_HAS_COMMERCIAL_OR_HARBOR'),
-- 市舶榷务
	('REYNA_CHEAPER_BUILDING_PURCHASE',					'MODIFIER_SINGLE_CITY_ADJUST_ALL_BUILDINGS_PURCHASE_COST',		null),
-- 金融中心
	('REYNA_CONTRACTOR_GOLD',											'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',		null),
	('REYNA_CONTRACTOR_GOLD_COMMERCIAL',					'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',		'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_4_BUILDING_REQUIREMENTS'),
	('REYNA_CONTRACTOR_GOLD_HARBOR',							'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',		'CITY_HAS_DISTRICT_HARBOR_TIER_3_BUILDING_REQUIREMENTS'),
-- 跨国公司
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_0',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',		'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_1_BUILDING_REQUIREMENTS'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_1',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',		'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_2_BUILDING_REQUIREMENTS'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_2',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',		'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_3_BUILDING_REQUIREMENTS'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_3',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',		'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_4_BUILDING_REQUIREMENTS'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_4',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',		'CITY_HAS_DISTRICT_HARBOR_TIER_1_BUILDING_REQUIREMENTS'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_5',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',		'CITY_HAS_DISTRICT_HARBOR_TIER_2_BUILDING_REQUIREMENTS'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_6',					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',		'CITY_HAS_DISTRICT_HARBOR_TIER_3_BUILDING_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,										Name,												Value)
values
-- 林业管理
	('REYNA_UNIT_DISCOUNT',								'Amount',											20),
	('REYNA_UNIT_DISCOUNT',								'IncludeCivilian',									1),
	('REYNA_UNIT_EXTRA_DISCOUNT',						'UnitType',											'UNIT_TRADER'),
	('REYNA_UNIT_EXTRA_DISCOUNT',						'Amount',											20),
-- 地产商人
	('REYNA_POPULATION_GOLD',							'YieldType',										'YIELD_GOLD'),
	('REYNA_POPULATION_GOLD',							'Amount',											3),
	('REYNA_TRADEROUTE',								'Amount',											3),
-- 港务局长
	('REYNA_EXTRA_DISTRICT',							'Amount',											1),
-- 市舶榷务
	('REYNA_CHEAPER_BUILDING_PURCHASE',					'Amount',											15),
-- 金融中心
	('REYNA_CONTRACTOR_GOLD',											'Amount',											20),
	('REYNA_CONTRACTOR_GOLD',											'YieldType',									'YIELD_GOLD'),
	('REYNA_CONTRACTOR_GOLD_COMMERCIAL',					'Amount',											10),
	('REYNA_CONTRACTOR_GOLD_COMMERCIAL',					'YieldType',									'YIELD_GOLD'),
	('REYNA_CONTRACTOR_GOLD_HARBOR',							'Amount',											10),
	('REYNA_CONTRACTOR_GOLD_HARBOR',							'YieldType',									'YIELD_GOLD'),
-- 跨国公司
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_0',					'YieldType',									'YIELD_GOLD'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_0',					'Amount',											6),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_1',					'YieldType',									'YIELD_GOLD'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_1',					'Amount',											6),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_2',					'YieldType',									'YIELD_GOLD'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_2',					'Amount',											6),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_3',					'YieldType',									'YIELD_GOLD'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_3',					'Amount',											6),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_4',					'YieldType',									'YIELD_GOLD'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_4',					'Amount',											6),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_5',					'YieldType',									'YIELD_GOLD'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_5',					'Amount',											6),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_6',					'YieldType',									'YIELD_GOLD'),
	('REYNA_MULTINATIONAL_CORP_TRADE_GOLD_6',					'Amount',											6);
-- 林业管理公司模式
insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType,								ModifierId)
select
	'GOVERNOR_PROMOTION_MERCHANT_FORESTRY_MANAGEMENT',	'REYNA_UNIT_EXTRA_DISCOUNT1'
where exists (select UnitType from Units where UnitType = 'UNIT_LEU_INVESTOR');
insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType,								ModifierId)
select
	'GOVERNOR_PROMOTION_MERCHANT_FORESTRY_MANAGEMENT',	'REYNA_UNIT_EXTRA_DISCOUNT2'
where exists (select UnitType from Units where UnitType = 'UNIT_LEU_TYCOON');

insert or replace into Modifiers
	(ModifierId,										ModifierType,													SubjectRequirementSetId)
select
	'REYNA_UNIT_EXTRA_DISCOUNT1',						'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',				NULL
where exists (select UnitType from Units where UnitType = 'UNIT_LEU_INVESTOR');
insert or replace into Modifiers
	(ModifierId,										ModifierType,													SubjectRequirementSetId)
select
	'REYNA_UNIT_EXTRA_DISCOUNT2',						'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',				NULL
where exists (select UnitType from Units where UnitType = 'UNIT_LEU_TYCOON');

insert or replace into ModifierArguments
	(ModifierId,										Name,												Value)
select
	'REYNA_UNIT_EXTRA_DISCOUNT1',						'UnitType',											'UNIT_LEU_INVESTOR'
where exists (select UnitType from Units where UnitType = 'UNIT_LEU_INVESTOR');
insert or replace into ModifierArguments
	(ModifierId,										Name,												Value)
select
	'REYNA_UNIT_EXTRA_DISCOUNT1',						'Amount',											20
where exists (select UnitType from Units where UnitType = 'UNIT_LEU_INVESTOR');

insert or replace into ModifierArguments
	(ModifierId,										Name,												Value)
select
	'REYNA_UNIT_EXTRA_DISCOUNT2',						'UnitType',											'UNIT_LEU_TYCOON'
where exists (select UnitType from Units where UnitType = 'UNIT_LEU_TYCOON');
insert or replace into ModifierArguments
	(ModifierId,										Name,												Value)
select
	'REYNA_UNIT_EXTRA_DISCOUNT2',						'Amount',											20
where exists (select UnitType from Units where UnitType = 'UNIT_LEU_TYCOON');
--跨国公司 金融中心
-- create temporary table HD_REYNA(
-- 	BuildingType text not null,
-- 	ModifierType text not null,
-- 	GovernorPromotionType text not null,
-- 	ModifierId text,
-- 	primary key (BuildingType, ModifierType)
-- );
-- insert or replace into HD_REYNA
-- 	(BuildingType,	ModifierType,															GovernorPromotionType)
-- select
-- 	BuildingType,	'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',						'GOVERNOR_PROMOTION_MERCHANT_CONTRACTOR'
-- from Buildings where (PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and TraitType is NULL) or (PrereqDistrict = 'DISTRICT_HARBOR' and TraitType is NULL) union all
-- select
-- 	BuildingType,	'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',		'GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP'
-- from Buildings where (PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and TraitType is NULL) or (PrereqDistrict = 'DISTRICT_HARBOR' and TraitType is NULL);
-- update HD_REYNA set ModifierId = 'REYNA_' || BuildingType || '_' || ModifierType;

-- insert or replace into GovernorPromotionModifiers
-- 	(GovernorPromotionType,		ModifierId)
-- select
-- 	GovernorPromotionType,		ModifierId
-- from HD_REYNA;
-- insert or replace into Modifiers
-- 	(ModifierId,			ModifierType,			SubjectRequirementSetId)
-- select
-- 	ModifierId,				ModifierType,			'CITY_HAS_' || BuildingType || '_REQUIREMENTS'
-- from HD_REYNA;
-- insert or replace into ModifierArguments
-- 	(ModifierId,			Name,					Value)
-- select
-- 	ModifierId,				'YieldType',			'YIELD_GOLD'
-- from HD_REYNA union all
-- select
-- 	ModifierId,				'Amount',				8
-- from HD_REYNA where ModifierType = 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER' union all
-- select
-- 	ModifierId,				'Amount',				6
-- from HD_REYNA where ModifierType = 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL';

-- 公司模式 跨国公司
update GovernorPromotions set Description = 'LOC_GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP_DESCRIPTION_CORP'
	where GovernorPromotionType = 'GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP'
	and exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType,				ModifierId)
select
	'GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP',	'MULTINATIONAL_CORP_PRODUCT_TOURISM'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into Modifiers
	(ModifierId,									ModifierType)
select
	'MULTINATIONAL_CORP_PRODUCT_TOURISM',			'MODIFIER_SINGLE_CITY_ADJUST_TOURISM'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,									Name,						Value)
select
	'MULTINATIONAL_CORP_PRODUCT_TOURISM',			'GreatWorkObjectType',		'GREATWORKOBJECT_PRODUCT'
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into ModifierArguments
	(ModifierId,									Name,						Value)
select
	'MULTINATIONAL_CORP_PRODUCT_TOURISM',			'ScalingFactor',			300
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

-----------------------------------------------------------------------------------------------------------------------------------

--Victor=城主=维克多
update Governors set TransitionStrength = 250 where GovernorType = 'GOVERNOR_THE_DEFENDER';

--delete from GovernorPromotions where GovernorPromotionType = 'GOVERNOR_PROMOTION_DEFENSE_LOGISTICS';
delete from GovernorPromotions where GovernorPromotionType = 'GOVERNOR_PROMOTION_AIR_DEFENSE_INITIATIVE';
delete from GovernorPromotions where GovernorPromotionType = 'GOVERNOR_PROMOTION_EMBRASURE';
delete from GovernorPromotions where GovernorPromotionType = 'GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT';

insert or replace into Types (Type,Kind) values
	('GOVERNOR_PROMOTION_CONSCRIPTION',			'KIND_GOVERNOR_PROMOTION'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'KIND_GOVERNOR_PROMOTION'),
	('GOVERNOR_PROMOTION_COMMANDER',			'KIND_GOVERNOR_PROMOTION');

insert or replace into GovernorPromotions
	(GovernorPromotionType,						Name,												Description,											Level,	Column,	BaseAbility)
values
	('GOVERNOR_PROMOTION_REDOUBT',				'LOC_GOVERNOR_PROMOTION_REDOUBT_NAME',				'LOC_GOVERNOR_PROMOTION_REDOUBT_DESCRIPTION',				0,	1,	1),
	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',	'LOC_GOVERNOR_PROMOTION_GARRISON_COMMANDER_NAME',	'LOC_GOVERNOR_PROMOTION_GARRISON_COMMANDER_DESCRIPTION',	1,	0,	0),
	('GOVERNOR_PROMOTION_DEFENSE_LOGISTICS',	'LOC_GOVERNOR_PROMOTION_DEFENSE_LOGISTICS_NAME',	'LOC_GOVERNOR_PROMOTION_DEFENSE_LOGISTICS_DESCRIPTION',		1,	2,	0),
	('GOVERNOR_PROMOTION_CONSCRIPTION',			'LOC_GOVERNOR_PROMOTION_CONSCRIPTION_NAME',			'LOC_GOVERNOR_PROMOTION_CONSCRIPTION_DESCRIPTION',			2,	1,	0),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'LOC_GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT_NAME',	'LOC_GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT_DESCRIPTION',	3,	0,	0),
	('GOVERNOR_PROMOTION_COMMANDER',			'LOC_GOVERNOR_PROMOTION_COMMANDER_NAME',			'LOC_GOVERNOR_PROMOTION_COMMANDER_DESCRIPTION',				3,	2,	0);

--level 0 promotion GOVERNOR_PROMOTION_REDOUBT
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_REDOUBT';
insert or replace into GovernorPromotionModifiers (GovernorPromotionType,ModifierId) values
	('GOVERNOR_PROMOTION_REDOUBT',	'DEFENDER_ADJUST_CITY_DEFENSE_STRENGTH'),
	('GOVERNOR_PROMOTION_REDOUBT',	'DEFENSE_LOGISTICS_SIEGE_PROTECTION'),
	-- ('GOVERNOR_PROMOTION_REDOUBT',	'PRESTIGE_IDENTITY_PRESSURE_TO_DOMESTIC_CITIES'),
	('GOVERNOR_PROMOTION_REDOUBT',	'VICTOR_ENCAMPMENT_PRODUCTION'),
	('GOVERNOR_PROMOTION_REDOUBT',	'VICTOR_ENCAMPMENT_BUILDINGS_PRODUCTION'),
	('GOVERNOR_PROMOTION_REDOUBT',	'VICTOR_HARBOR_PRODUCTION'),
	('GOVERNOR_PROMOTION_REDOUBT',	'VICTOR_HARBOR_BUILDINGS_PRODUCTION'),
	('GOVERNOR_PROMOTION_REDOUBT',	'VICTOR_ENCAMPMENT_ADJACENCY_BONUS');
--维克多bug修复
insert or replace into Modifiers
	(ModifierId,															ModifierType,																															SubjectRequirementSetId)
values
	('VICTOR_ENCAMPMENT_ADJACENCY_BONUS',			'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',													'DISTRICT_IS_ENCAMPMENT');
insert or replace into Modifiers
	(ModifierId,                                  ModifierType)
values
	('VICTOR_ENCAMPMENT_PRODUCTION',							'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION'),
	('VICTOR_ENCAMPMENT_BUILDINGS_PRODUCTION',		'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION'),
	('VICTOR_HARBOR_PRODUCTION',									'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION'),
	('VICTOR_HARBOR_BUILDINGS_PRODUCTION',				'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION');
insert or replace into ModifierArguments
	(ModifierId,                                Name,                   Value)
values
	('VICTOR_ENCAMPMENT_ADJACENCY_BONUS',				'YieldType',						'YIELD_PRODUCTION'),
	('VICTOR_ENCAMPMENT_ADJACENCY_BONUS',				'Amount',								100),
	('VICTOR_ENCAMPMENT_PRODUCTION',						'DistrictType',					'DISTRICT_ENCAMPMENT'),
	('VICTOR_ENCAMPMENT_PRODUCTION',						'Amount',								30),
	('VICTOR_HARBOR_PRODUCTION',								'DistrictType',					'DISTRICT_HARBOR'),
	('VICTOR_HARBOR_PRODUCTION',								'Amount',								30),
	('VICTOR_ENCAMPMENT_BUILDINGS_PRODUCTION',	'DistrictType',					'DISTRICT_ENCAMPMENT'),
	('VICTOR_ENCAMPMENT_BUILDINGS_PRODUCTION',	'Amount',								30),
	('VICTOR_HARBOR_BUILDINGS_PRODUCTION',			'DistrictType',					'DISTRICT_HARBOR'),
	('VICTOR_HARBOR_BUILDINGS_PRODUCTION',			'Amount',								30);


--level 1 promotion GOVERNOR_PROMOTION_GARRISON_COMMANDER
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_GARRISON_COMMANDER';
insert or replace into GovernorPromotionModifiers (GovernorPromotionType,ModifierId) values
	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',	'GARRISON_COMMANDER_ADJUST_CITY_COMBAT_BONUS'),
	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',	'CITY_DEFENDER_ADJUST_ATTACKS_PER_TURN'),
	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',	'LIMES_CASTLEPRODUCTION'),
	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',	'LIMES_WALLSPRODUCTION'),
	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',	'LIMES_STARFORTPRODUCTION'),
	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',	'LIMES_TSIKHEPRODUCTION');

--level 1 promotion GOVERNOR_PROMOTION_DEFENSE_LOGISTICS
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_DEFENSE_LOGISTICS';
insert or replace into GovernorPromotionModifiers (GovernorPromotionType,ModifierId) values
	('GOVERNOR_PROMOTION_DEFENSE_LOGISTICS',	'BLACK_MARKETEER_STRATEGIC_RESOURCE_COST_DISCOUNT'),
	('GOVERNOR_PROMOTION_DEFENSE_LOGISTICS',	'DEFENSE_LOGISTICS_BONUS_STRATEGICS_ALL_CITIES');
-- update ModifierArguments set Value = 3 where ModifierId = 'DEFENSE_LOGISTICS_BONUS_STRATEGICS' and Name = 'Amount';

insert or replace into Modifiers	
	(ModifierId,										ModifierType)
values
	('DEFENSE_LOGISTICS_BONUS_STRATEGICS_ALL_CITIES',	'MODIFIER_PLAYER_CITIES_ADJUST_EXTRA_ACCUMULATION');

insert or replace into ModifierArguments
	(ModifierId,										Name,		Value)
values
	('DEFENSE_LOGISTICS_BONUS_STRATEGICS_ALL_CITIES',	'Amount',	2);

--level 2 promotion GOVERNOR_PROMOTION_EMBRASURE
-- delete from GovernorPromotionModifiers where ModifierId = 'CITY_DEFENDER_FREE_PROMOTIONS';
-- insert or replace into GovernorPromotionModifiers (GovernorPromotionType,ModifierId) values
-- 	('GOVERNOR_PROMOTION_EMBRASURE','CITY_DEFENDER_ADJUST_ATTACKS_PER_TURN'),
-- 	('GOVERNOR_PROMOTION_EMBRASURE','EMBRASURE_MILLITARY_ENGINEER_CHARGES'),
-- 	('GOVERNOR_PROMOTION_EMBRASURE','EMBRASURE_ADJUST_MILITARY_ENGINEER_PRODUCTION_MODIFIER'),
-- 	('GOVERNOR_PROMOTION_EMBRASURE','EMBRASURE_ADJUST_MILITARY_ENGINEER_PRODUCTION');

-- insert or replace into Modifiers	
-- 	(ModifierId,												ModifierType,							SubjectRequirementSetId)
-- values
-- 	('EMBRASURE_MILLITARY_ENGINEER_CHARGES',					'MODIFIER_SINGLE_CITY_BUILDER_CHARGES','UNIT_IS_MILITARY_ENGINEER'),
-- 	--('EMBRASURE_ADJUST_MILITARY_ENGINEER_PRODUCTION_MODIFIER',	'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION',NULL),
-- 	('EMBRASURE_ADJUST_MILITARY_ENGINEER_PRODUCTION',			'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',NULL);

-- insert or replace into ModifierArguments
-- 	(ModifierId,										Name,		Value)
-- values
-- 	('EMBRASURE_MILLITARY_ENGINEER_CHARGES',			'Amount',	2),
-- 	('EMBRASURE_ADJUST_MILITARY_ENGINEER_PRODUCTION',	'ModifierId','TRAIT_ADJUST_MILITARY_ENGINEER_PRODUCTION');

--level 2 promotion GOVERNOR_PROMOTION_CONSCRIPTION
insert or replace into GovernorPromotionModifiers (GovernorPromotionType,ModifierId) values
	('GOVERNOR_PROMOTION_CONSCRIPTION',	'CITY_DEFENDER_FREE_PROMOTIONS'),
	('GOVERNOR_PROMOTION_CONSCRIPTION',	'VICTOR_SCIENCE_TRAINED_UNIT');
update Modifiers set SubjectRequirementSetId = 'HD_CITY_DEFENDER_PROMOTION_REQUIREMENTS' where ModifierId = 'CITY_DEFENDER_FREE_PROMOTIONS';

-- update Modifiers set Permanent = 0 where ModifierId = 'BASILIKOI_PAIDES_SCIENCE_TRAINED_UNIT';
-- update Modifiers set RunOnce = 0 where ModifierId = 'BASILIKOI_PAIDES_SCIENCE_TRAINED_UNIT';
-- update ModifierArguments set Value = 60 where ModifierId = 'BLACK_MARKETEER_STRATEGIC_RESOURCE_COST_DISCOUNT' and Name = 'Amount';

-- insert or replace into Modifiers	
-- 	(ModifierId,									ModifierType,											Permanent)
-- values
-- 	-- ('VICTOR_TRAINED_EXP',							'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',					0),
-- 	('VICTOR_TRAINED_EXP_MODIFIER',					'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',	1),
-- 	-- ('CONSCRIPTION_GRANTS_UNIT_ABILITY',			'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',					0),
-- 	('CONSCRIPTION_GRANTS_UNIT_ABILITY_MODIFIER',	'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',	1);

-- insert or replace into ModifierArguments
-- 	(ModifierId,									Name,			Value)
-- values
-- 	-- ('VICTOR_TRAINED_EXP',							'ModifierId',	'VICTOR_TRAINED_EXP_MODIFIER'),
-- 	('VICTOR_TRAINED_EXP_MODIFIER',					'AbilityType',	'ABILITY_VICTOR_TRAINED_UNIT_EXP'),
-- 	-- ('CONSCRIPTION_GRANTS_UNIT_ABILITY',			'ModifierId',	'CONSCRIPTION_GRANTS_UNIT_ABILITY_MODIFIER'),
-- 	('CONSCRIPTION_GRANTS_UNIT_ABILITY_MODIFIER',	'AbilityType',	'ABILITY_VICTOR_TRAINED_UNIT_STRENGTH');

-- Level 3 Commander promotion GOVERNOR_PROMOTION_COMMANDER
insert or replace into GovernorPromotionModifiers (GovernorPromotionType,ModifierId) values
	('GOVERNOR_PROMOTION_COMMANDER',	'COMMANDER_REGIONAL_COMBAT_STRENGTH');

insert or replace into Modifiers	
	(ModifierId,									ModifierType,							SubjectRequirementSetId)
values
	('COMMANDER_REGIONAL_COMBAT_STRENGTH',			'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',	'UNIT_WITHIN_NINE_TILES_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,								Name,						Value)
values
	('COMMANDER_REGIONAL_COMBAT_STRENGTH',		'AbilityType',				'ABILITY_VICTOR_COMMANDER_STRENGTH');

--level 3 promotion GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT
update ModifierArguments set Value = 100 where ModifierId = 'EDUCATOR_FASTER_MANHATTAN_PROJECT_RESEARCH' and Name = 'Amount';
update ModifierArguments set Value = 100 where ModifierId = 'EDUCATOR_FASTER_OPERATION_IVY_RESEARCH' and Name = 'Amount';	
update ModifierArguments set Value = 100 where ModifierId = 'EDUCATOR_FASTER_NUCLEAR_DEVICE_PRODUCTION' and Name = 'Amount';
update ModifierArguments set Value = 100 where ModifierId = 'EDUCATOR_FASTER_THERMONUCLEAR_DEVICE_PRODUCTION' and Name = 'Amount';	

insert or replace into GovernorPromotionModifiers (GovernorPromotionType,ModifierId) values
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'EDUCATOR_FASTER_MANHATTAN_PROJECT_RESEARCH'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'EDUCATOR_FASTER_OPERATION_IVY_RESEARCH'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'EDUCATOR_FASTER_NUCLEAR_DEVICE_PRODUCTION'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'EDUCATOR_FASTER_THERMONUCLEAR_DEVICE_PRODUCTION'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'VICTOR_AIR_UNITS_PRODUCTION'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'VICTOR_GDR_PRODUCTION'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'VICTOR_ALL_MILITARY_UNITS_PRODUCTION');

insert or replace into Modifiers	
	(ModifierId,									ModifierType)
values
	('VICTOR_SCIENCE_TRAINED_UNIT',					'MODIFIER_SINGLE_CITY_GRANT_YIELD_PER_UNIT_COST'),
	('VICTOR_AIR_UNITS_PRODUCTION',					'MODIFIER_CITY_ADJUST_UNIT_DOMAIN_PRODUCTION'),
	('VICTOR_GDR_PRODUCTION',						'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION'),
	('VICTOR_ALL_MILITARY_UNITS_PRODUCTION',		'MODIFIER_SINGLE_CITY_ADJUST_MILITARY_UNITS_PRODUCTION');

insert or replace into ModifierArguments
	(ModifierId,								Name,					Value)
values
	('VICTOR_SCIENCE_TRAINED_UNIT',				'UnitProductionPercent',	25),
	('VICTOR_SCIENCE_TRAINED_UNIT',				'YieldType',			'YIELD_SCIENCE'),
	('VICTOR_AIR_UNITS_PRODUCTION',				'Domain',				'DOMAIN_AIR'),
	('VICTOR_AIR_UNITS_PRODUCTION',				'Amount',				50),
	('VICTOR_ALL_MILITARY_UNITS_PRODUCTION',	'Amount',				30),
	('VICTOR_GDR_PRODUCTION',					'UnitPromotionClass',	'PROMOTION_CLASS_GIANT_DEATH_ROBOT'),
	('VICTOR_GDR_PRODUCTION',					'EraType',				'ERA_INFORMATION'),
	('VICTOR_GDR_PRODUCTION',					'Amount',				50);

insert or replace into GovernorPromotionSets
	(GovernorType,				GovernorPromotion)
values
	('GOVERNOR_THE_DEFENDER',	'GOVERNOR_PROMOTION_REDOUBT'),
	('GOVERNOR_THE_DEFENDER',	'GOVERNOR_PROMOTION_GARRISON_COMMANDER'),
	('GOVERNOR_THE_DEFENDER',	'GOVERNOR_PROMOTION_DEFENSE_LOGISTICS'),
	-- ('GOVERNOR_THE_DEFENDER',	'GOVERNOR_PROMOTION_EMBRASURE'),
	('GOVERNOR_THE_DEFENDER',	'GOVERNOR_PROMOTION_CONSCRIPTION'),
	-- ('GOVERNOR_THE_DEFENDER',	'GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT'),
	('GOVERNOR_THE_DEFENDER',	'GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT'),
	('GOVERNOR_THE_DEFENDER',	'GOVERNOR_PROMOTION_COMMANDER');

insert or replace into GovernorPromotionPrereqs
	(GovernorPromotionType,						PrereqGovernorPromotion)
values
	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',	'GOVERNOR_PROMOTION_REDOUBT'),
	('GOVERNOR_PROMOTION_DEFENSE_LOGISTICS',	'GOVERNOR_PROMOTION_REDOUBT'),
	-- ('GOVERNOR_PROMOTION_EMBRASURE',			'GOVERNOR_PROMOTION_GARRISON_COMMANDER'),
	('GOVERNOR_PROMOTION_CONSCRIPTION',			'GOVERNOR_PROMOTION_GARRISON_COMMANDER'),
	('GOVERNOR_PROMOTION_CONSCRIPTION',			'GOVERNOR_PROMOTION_DEFENSE_LOGISTICS'),
	-- ('GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT','GOVERNOR_PROMOTION_EMBRASURE'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',	'GOVERNOR_PROMOTION_CONSCRIPTION'),
	('GOVERNOR_PROMOTION_COMMANDER',			'GOVERNOR_PROMOTION_CONSCRIPTION');
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-- Liang=测量师=梁 总督修改 by PineApple 

-- update GovernorPromotionModifiers set ModifierId = 'AQUACULTURE_ADDITIONAL_PRODUCTION' where GovernorPromotionType = 'GOVERNOR_PROMOTION_AQUACULTURE';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_AQUACULTURE';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_WATER_WORKS';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_ZONING_COMMISSIONER';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_PARKS_RECREATION';

insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType, 									ModifierId)
values
	('GOVERNOR_PROMOTION_BUILDER_GUILDMASTER',					'GUILDMASTER_TRAINED_BUILDER_MOVEMENT'),
	-- ('GOVERNOR_PROMOTION_ZONING_COMMISSIONER',					'ZONING_COMMISSIONER_FASTER_BUILDING_CONSTRUCTION'),
	('GOVERNOR_PROMOTION_ZONING_COMMISSIONER',					'ARCHITECTURE_MASTER_WONDERS_BOOST'),
	('GOVERNOR_PROMOTION_AQUACULTURE',							'AQUACULTURE_ADDITIONAL_PRODUCTION'),
	('GOVERNOR_PROMOTION_AQUACULTURE',							'AQUACULTURE_POP_PRODUCTION'),
	('GOVERNOR_PROMOTION_PARKS_RECREATION',							'PARKS_RECREATION_ALLOW_PLAYER_CITY_PARK'),
	('GOVERNOR_PROMOTION_WATER_WORKS',							'WATER_WORKS_IMPROVEMENT_TOURISM'),
	('GOVERNOR_PROMOTION_WATER_WORKS',							'WATER_WORKS_NATIONAL_PARK_TOURISM'),
	('GOVERNOR_PROMOTION_WATER_WORKS',							'WATER_WORKS_IMPROVEMENT_TOURISM_6_TILES'),
	('GOVERNOR_PROMOTION_WATER_WORKS',							'WATER_WORKS_NATIONAL_PARK_TOURISM_6_TILES');

-- 总督升级连线修改
update GovernorPromotions set column = 1 where GovernorPromotionType = 'GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE';
update GovernorPromotions set level = 3, column = 0 where GovernorPromotionType = 'GOVERNOR_PROMOTION_WATER_WORKS';
update GovernorPromotions set column = 2 where GovernorPromotionType = 'GOVERNOR_PROMOTION_PARKS_RECREATION';

delete from GovernorPromotionPrereqs where PrereqGovernorPromotion ='GOVERNOR_PROMOTION_WATER_WORKS';
delete from GovernorPromotionPrereqs where PrereqGovernorPromotion ='GOVERNOR_PROMOTION_AQUACULTURE';

insert or replace into GovernorPromotionPrereqs 
	(GovernorPromotionType, 									PrereqGovernorPromotion) 
values
	('GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE',			'GOVERNOR_PROMOTION_AQUACULTURE'),
	('GOVERNOR_PROMOTION_WATER_WORKS',							'GOVERNOR_PROMOTION_REINFORCED_INFRASTRUCTURE');

-- 工会首领: 工人额外+1速
-- insert or replace into Modifiers
-- 	(ModifierId,												ModifierType,									Permanent,		SubjectRequirementSetId)
-- values
-- 	('GUILDMASTER_ADDITIONAL_BUILDER_MOVEMENT',					'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',			0,				NULL),
-- 	('GUILDMASTER_ADDITIONAL_BUILDER_MOVEMENT_UNIT_MODIFIER',	'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT',		1,				'UNIT_IS_BUILDER');

-- insert or replace into ModifierArguments
-- 	(ModifierId,												Name,											Value)
-- values
-- 	('GUILDMASTER_ADDITIONAL_BUILDER_MOVEMENT',					'ModifierId',									'GUILDMASTER_ADDITIONAL_BUILDER_MOVEMENT_UNIT_MODIFIER'),
-- 	('GUILDMASTER_ADDITIONAL_BUILDER_MOVEMENT_UNIT_MODIFIER',	'Amount',										1);

insert or replace into Modifiers
	(ModifierId,										ModifierType,											Permanent,	SubjectRequirementSetId)
values
	('GUILDMASTER_TRAINED_BUILDER_MOVEMENT',			'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',					0,			NULL),
	('GUILDMASTER_TRAINED_BUILDER_MOVEMENT_MODIFIER',	'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',	1,			'UNIT_IS_BUILDER');

insert or replace into ModifierArguments
 	(ModifierId,										Name,			Value)
values
 	('GUILDMASTER_TRAINED_BUILDER_MOVEMENT',			'ModifierId',	'GUILDMASTER_TRAINED_BUILDER_MOVEMENT_MODIFIER'),
 	('GUILDMASTER_TRAINED_BUILDER_MOVEMENT_MODIFIER',	'AbilityType',	'ABILITY_GUILDMASTER_TRAINED_BUILDER_MOVEMENT');

-- 耕樵渔猎（原水产养殖）：改良地块+1锤
insert or replace into Modifiers
	(ModifierId,												ModifierType,												SubjectRequirementSetId)
values
	('AQUACULTURE_POP_PRODUCTION',								'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',	NULL),
	('AQUACULTURE_ADDITIONAL_PRODUCTION',						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',				'PLOT_IS_IMPROVED');

insert or replace into ModifierArguments
	(ModifierId,												Name,											Value)
values
	('AQUACULTURE_POP_PRODUCTION',								'YieldType',									'YIELD_PRODUCTION'),
	('AQUACULTURE_POP_PRODUCTION',								'Amount',										0.5),
	('AQUACULTURE_ADDITIONAL_PRODUCTION',						'YieldType',									'YIELD_PRODUCTION'), -- ,YIELD_FOOD
	('AQUACULTURE_ADDITIONAL_PRODUCTION',						'Amount',										'1'); -- ,1

-- 规划委员：建造区域、建筑+30%面板锤
-- update Modifiers set ModifierType = 'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_MODIFIER' 
-- 	where ModifierId = 'ZONING_COMMISSIONER_FASTER_DISTRICT_CONSTRUCTION';

-- insert or replace into Modifiers
-- 	(ModifierId,												ModifierType)
-- values
-- 	('ZONING_COMMISSIONER_FASTER_BUILDING_CONSTRUCTION',		'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION_MODIFIER');

-- insert or replace into ModifierArguments
-- 	(ModifierId,												Name,											Value)
-- values
-- 	('ZONING_COMMISSIONER_FASTER_DISTRICT_CONSTRUCTION',		'Amount',										30),
-- 	('ZONING_COMMISSIONER_FASTER_BUILDING_CONSTRUCTION',		'Amount',										30);

--改为加速
-- update ModifierArguments set Value = 30 where ModifierId = 'ZONING_COMMISSIONER_FASTER_DISTRICT_CONSTRUCTION';
-- insert or replace into Modifiers
-- 	(ModifierId,												ModifierType)
-- values
-- 	('ZONING_COMMISSIONER_FASTER_BUILDING_CONSTRUCTION',		'MODIFIER_SINGLE_CITY_ADJUST_ALLBUILDING_PRODUCTION_MODIFIER');
-- insert or replace into ModifierArguments
--  	(ModifierId,											Name,		Value)
-- values
-- 	('ZONING_COMMISSIONER_FASTER_BUILDING_CONSTRUCTION',	'Amount',	30),
-- 	('ZONING_COMMISSIONER_FASTER_BUILDING_CONSTRUCTION',	'IsWonder',	0);

-- 梁左一：建筑大师，奇观加速20%，奇观完成返10%大工点数（lua实现）
insert or replace into Modifiers
	(ModifierId,									ModifierType)
values
	('ARCHITECTURE_MASTER_WONDERS_BOOST',			'MODIFIER_SINGLE_CITY_ADJUST_WONDER_PRODUCTION');

insert or replace into ModifierArguments
	(ModifierId,									Name,			Value)
values
	('ARCHITECTURE_MASTER_WONDERS_BOOST',			'Amount',		20);

-- 市立公园：可以修在泛滥平原上。
insert or replace into Modifiers
	(ModifierId,																ModifierType,																RunOnce,	Permanent)
values
	('PARKS_RECREATION_ALLOW_PLAYER_CITY_PARK',	'MODIFIER_PLAYER_ADJUST_VALID_IMPROVEMENT',	1,				1);

insert or replace into ModifierArguments
	(ModifierId,																	Name,											Value)
values
	('PARKS_RECREATION_ALLOW_PLAYER_CITY_PARK',		'ImprovementType',				'IMPROVEMENT_CITY_PARK');

delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_CITY_PARK';
update Improvements set PrereqCivic = null where ImprovementType = 'IMPROVEMENT_CITY_PARK';

insert or replace into Improvement_YieldChanges
	(ImprovementType,						YieldType,					YieldChange)
values
	('IMPROVEMENT_CITY_PARK',		'YIELD_FOOD',				2),
	('IMPROVEMENT_CITY_PARK',		'YIELD_PRODUCTION',	1),
	('IMPROVEMENT_CITY_PARK',		'YIELD_GOLD',				3);

insert or replace into Improvement_ValidFeatures
	(ImprovementType,											FeatureType)
values
	('IMPROVEMENT_CITY_PARK',									'FEATURE_FLOODPLAINS'),
	('IMPROVEMENT_CITY_PARK',									'FEATURE_FLOODPLAINS_GRASSLAND'),
	('IMPROVEMENT_CITY_PARK',									'FEATURE_FLOODPLAINS_PLAINS');

-- update Improvements set PrereqCivic = 'CIVIC_GUILDS' where ImprovementType = 'IMPROVEMENT_CITY_PARK';
-- update Improvements set PrereqCivic = 'CIVIC_MEDIEVAL_FAIRES' where ImprovementType = 'IMPROVEMENT_CITY_PARK';

-- 世外天堂：代替自来水工程，本城所有改良设施和国家公园旅游业绩+200%
insert or replace into Modifiers
	(ModifierId,																		ModifierType,																					SubjectRequirementSetId)
values
	('WATER_WORKS_IMPROVEMENT_TOURISM',							'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_TOURISM',		null),
	('WATER_WORKS_NATIONAL_PARK_TOURISM',						'MODIFIER_SINGLE_CITY_ADJUST_NATIONAL_PARK_TOURISM',	null),
	('WATER_WORKS_IMPROVEMENT_TOURISM_6_TILES',			'MODIFIER_PLAYER_CITIES_ADJUST_IMPROVEMENT_TOURISM',  'HD_OBJECT_WITHIN_6_TILES'),
	('WATER_WORKS_NATIONAL_PARK_TOURISM_6_TILES',		'MODIFIER_PLAYER_CITIES_ADJUST_NATIONAL_PARK_TOURISM',	'HD_OBJECT_WITHIN_6_TILES');

insert or replace into ModifierArguments
	(ModifierId,																		Name,											Value)
values
	('WATER_WORKS_IMPROVEMENT_TOURISM',							'Amount',									100),
	('WATER_WORKS_NATIONAL_PARK_TOURISM',						'Amount',									100),
	('WATER_WORKS_IMPROVEMENT_TOURISM_6_TILES',			'Amount',									100),
	('WATER_WORKS_NATIONAL_PARK_TOURISM_6_TILES',		'Amount',									100);

--bishop
--level 0 GOVERNOR_PROMOTION_CARDINAL_BISHOP 大主教
--LEVEL 1-0 GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR 赛义德
--LEVEL 1-2 GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS 因信称义
--LEVEL 2-0 GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT 主保圣人
--LEVEL 2-2 GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD 神圣建筑师
--LEVEL 3-1 GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT 普世牧首
update GovernorPromotions set Column = 2 where GovernorPromotionType = 'GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
update GovernorPromotions set Level = 2, Column = 0 where GovernorPromotionType = 'GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';
update GovernorPromotions set Column = 1 where GovernorPromotionType = 'GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT';
delete from GovernorPromotionPrereqs where GovernorPromotionType = 'GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD' and PrereqGovernorPromotion = 'GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR';
delete from GovernorPromotionPrereqs where GovernorPromotionType = 'GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT' and PrereqGovernorPromotion = 'GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
insert or replace into GovernorPromotionPrereqs
	(GovernorPromotionType,								PrereqGovernorPromotion)
values
	('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT',		'GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR'),
	('GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT',	'GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT');
/*
主教一：3大仙点，城市有胶后+3人口鸽
左二：买宗教单位打折（传教加次数）
右二：改为6环内的圣地+100%相邻，+2宜居度
左三：原右四效果（遗物）+原左四效果（使徒升级），宗教单位加力
右三：单位 神圣建筑师
中四：原右四效果（遗物）+原左四效果（使徒升级） MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS
*/
update Governors set TransitionStrength = 150 where GovernorType = 'GOVERNOR_THE_CARDINAL';
delete from GovernorPromotionModifiers where ModifierId = 'CARDINAL_BISHOP_FAITH_DISTRICT';
delete from GovernorPromotionModifiers where ModifierId = 'CARDINAL_CITADEL_OF_GOD_PRESSURE';
delete from GovernorPromotionModifiers where ModifierId = 'CARDINAL_CITADEL_OF_GOD_COMBAT';
delete from GovernorPromotionModifiers where ModifierId = 'CARDINAL_CITADEL_OF_GOD_FAITH_FINISH_BUILDINGS';
delete from GovernorPromotionModifiers where ModifierId = 'CARDINAL_GRAND_INQUISITOR_COMBAT';
delete from GovernorPromotionModifiers where ModifierId = 'CARDINAL_LAYING_ON_OF_HANDS_RELIGIOUS_HEAL';
delete from GovernorPromotionModifiers where ModifierId = 'CARDINAL_LAYING_ON_OF_HANDS_HEAL';
delete from GovernorPromotionModifiers where ModifierId = 'CARDINAL_FAITH_PURCHASE_DISTRICT';
update GovernorPromotionModifiers set GovernorPromotionType = 'GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT' where ModifierId = 'CARDINAL_PATRON_SAINT_PROMOTION';
insert or replace into GovernorPromotionModifiers 
	(GovernorPromotionType,								ModifierId) 
values	
	('GOVERNOR_PROMOTION_CARDINAL_BISHOP',				'BISHOP_FAITH_POP'),
	('GOVERNOR_PROMOTION_CARDINAL_BISHOP',				'ADD_4_GREAT_PROHET'),
	('GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR',	'BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_MOVEMENT'),
	('GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR',	'BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_CHARGES'),
	('GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR',	'BISHOP_RELIGIOUS_UNIT_MISSIONARY_DISCOUNT'),
	('GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR',	'BISHOP_RELIGIOUS_UNIT_APOSTLE_DISCOUNT'),
	('GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR',	'BISHOP_RELIGIOUS_UNIT_INQUISITOR_DISCOUNT'),
	('GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR',	'BISHOP_RELIGIOUS_UNIT_GURU_DISCOUNT'),
--	('GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR',	'CARDINAL_FAITH_PURCHASE_HOLYSITE_BUILDINGS'),
	('GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS',	'BISHOP_HOLYSITE_DOUBLE_ADJACENCY_SIX_TILES'),
	('GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS',	'BISHOP_HOLYSITE_AMENITY_SIX_TILES'),
--	('GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD',		'CARDINAL_EXTRA_DISTRICT'),
--	('GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD',		'CARDINAL_CHEAPER_DISTRICT_PURCHASE'),

--	('GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD',		'CARDINAL_FAITH_PURCHASE_DISTRICT'),
--	('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT',		'PATRON_SAINT_DISTRICT_FAITH'),
	('GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD',		'BISHOP_UNIT_CITADEL_OF_GOD_FAITH_PURCHASE'),
	('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT',		'BISHOP_RELIC_FAITH1'),
	('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT',		'BISHOP_RELIC_TOURISM2'),
	('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT',		'BISHOP_TRAINED_MONK_EXTRA_COMBAT_STRENGTH');

insert or replace into Modifiers	
	(ModifierId,												ModifierType,													Permanent,	SubjectRequirementSetId)
values
	('BISHOP_FAITH_POP',										'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',				0,	'CITY_FOLLOWS_RELIGION_REQUIREMENTS'),
	('ADD_4_GREAT_PROHET',										'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT',						0,	NULL),
	('BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_CHARGES',				'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',									0,	NULL),
	('BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_CHARGES_MODIFIER',	'MODIFIER_SINGLE_CITY_RELIGIOUS_SPREADS',								1,	'UNIT_IS_RELIGOUS_ALL'),
	('BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_MOVEMENT',			'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',									0,	NULL),
	('BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_MOVEMENT_MODIFIER',	'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',					1,	'UNIT_IS_RELIGOUS_ALL_AND_MONK'),
	('BISHOP_RELIGIOUS_UNIT_MISSIONARY_DISCOUNT',				'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',						0,	NULL),
	('BISHOP_RELIGIOUS_UNIT_APOSTLE_DISCOUNT',					'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',						0,	NULL),
	('BISHOP_RELIGIOUS_UNIT_INQUISITOR_DISCOUNT',				'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',						0,	NULL),
	('BISHOP_RELIGIOUS_UNIT_GURU_DISCOUNT',						'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',						0,	NULL),
	('BISHOP_RELIC_FAITH1',										'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD',							0,	NULL),
	('BISHOP_HOLYSITE_DOUBLE_ADJACENCY_SIX_TILES',				'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',						0,	'DISTRICT_IS_HOLY_SITE_WITHIN_SIX_TILES_REQUIREMENTS'),
	('BISHOP_HOLYSITE_AMENITY_SIX_TILES',						'MODIFIER_PLAYER_DISTRICTS_ADJUST_EXTRA_ENTERTAINMENT',					0,	'DISTRICT_IS_HOLY_SITE_WITHIN_SIX_TILES_REQUIREMENTS'),
	('BISHOP_UNIT_CITADEL_OF_GOD_FAITH_PURCHASE',				'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE',					0,	NULL),
	('BISHOP_RELIC_TOURISM2',									'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',									0,	NULL),
	('BISHOP_TRAINED_MONK_EXTRA_COMBAT_STRENGTH',				'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',									0,	NULL),
	('BISHOP_TRAINED_MONK_EXTRA_COMBAT_STRENGTH_MODIFIER',		'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',					1,	'UNIT_IS_RELIGOUS_ALL_AND_MONK');

insert or replace into ModifierArguments
	(ModifierId,											Name,					Value)
values
	('BISHOP_FAITH_POP',									'YieldType',			'YIELD_FAITH'),
	('BISHOP_FAITH_POP',									'Amount',				2),
	('ADD_4_GREAT_PROHET',									'GreatPersonClassType',	'GREAT_PERSON_CLASS_PROPHET'),
	('ADD_4_GREAT_PROHET',									'Amount',				4),
	('BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_CHARGES',			'ModifierId',			'BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_CHARGES_MODIFIER'),
	('BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_CHARGES_MODIFIER','Amount',				1),
	('BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_MOVEMENT',		'ModifierId',			'BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_MOVEMENT_MODIFIER'),
	('BISHOP_TRAINED_RELIGIOUS_UNIT_EXTRA_MOVEMENT_MODIFIER','AbilityType',			'ABILITY_BISHOP_EXTRA_MOVEMENT'),
	('BISHOP_RELIGIOUS_UNIT_MISSIONARY_DISCOUNT',			'UnitType',				'UNIT_MISSIONARY'),
	('BISHOP_RELIGIOUS_UNIT_MISSIONARY_DISCOUNT',			'Amount',				20),
	('BISHOP_RELIGIOUS_UNIT_APOSTLE_DISCOUNT',				'UnitType',				'UNIT_APOSTLE'),
	('BISHOP_RELIGIOUS_UNIT_APOSTLE_DISCOUNT',				'Amount',				20),
	('BISHOP_RELIGIOUS_UNIT_INQUISITOR_DISCOUNT',			'UnitType',				'UNIT_INQUISITOR'),
	('BISHOP_RELIGIOUS_UNIT_INQUISITOR_DISCOUNT',			'Amount',				20),
	('BISHOP_RELIGIOUS_UNIT_GURU_DISCOUNT',					'UnitType',				'UNIT_GURU'),
	('BISHOP_RELIGIOUS_UNIT_GURU_DISCOUNT',					'Amount',				20),
	-- ('BISHOP_APOSTLE_PURCHASE_DISCOUNT',					'UnitType',				'UNIT_APOSTLE'),
	-- ('BISHOP_APOSTLE_PURCHASE_DISCOUNT',					'Amount',				10),
	-- ('BISHOP_MISSIONARY_PURCHASE_DISCOUNT',					'UnitType',				'UNIT_MISSIONARY'),
	-- ('BISHOP_MISSIONARY_PURCHASE_DISCOUNT',					'Amount',				10),
	-- ('BISHOP_GURU_PURCHASE_DISCOUNT',						'UnitType',				'UNIT_GURU'),
	-- ('BISHOP_GURU_PURCHASE_DISCOUNT',						'Amount',				10),
	-- ('BISHOP_MONK_PURCHASE_DISCOUNT',						'UnitType',				'UNIT_WARRIOR_MONK'),
	-- ('BISHOP_MONK_PURCHASE_DISCOUNT',						'Amount',				10),
	-- ('BISHOP_INQUISITOR_PURCHASE_DISCOUNT',					'UnitType',				'UNIT_INQUISITOR'),
	-- ('BISHOP_INQUISITOR_PURCHASE_DISCOUNT',					'Amount',				10),
	('BISHOP_RELIC_FAITH1',									'GreatWorkObjectType',	'GREATWORKOBJECT_RELIC'),
	('BISHOP_RELIC_FAITH1',									'YieldType',			'YIELD_FAITH'),
	('BISHOP_RELIC_FAITH1',									'ScalingFactor',		150),
	-- ('BISHOP_RELIC_TOURISM1',								'GreatWorkObjectType',	'GREATWORKOBJECT_RELIC'),
	-- ('BISHOP_RELIC_TOURISM1',								'ScalingFactor',		200),
	('BISHOP_HOLYSITE_DOUBLE_ADJACENCY_SIX_TILES',			'YieldType',		'YIELD_FAITH'),
	('BISHOP_HOLYSITE_DOUBLE_ADJACENCY_SIX_TILES',			'Amount',			100),
	('BISHOP_HOLYSITE_AMENITY_SIX_TILES',					'Amount',			2),
	--('BISHOP_HOLYSITE_ADJACENCY_CONVERT_TOURISM_FOUR_TILES', 'YieldType',		'YIELD_FAITH'),
	--('BISHOP_HOLYSITE_ADJACENCY_CONVERT_TOURISM_FOUR_TILES', 'Amount',			100),
	-- ('BISHOP_PERCENTAGE_FAITH',								'YieldType',			'YIELD_FAITH'),
	-- ('BISHOP_PERCENTAGE_FAITH',								'Amount',				15),
	-- ('BISHOP_CAMPUS_CONVERT_FAITH',							'YieldTypeToMirror',	'YIELD_SCIENCE'),
	-- ('BISHOP_CAMPUS_CONVERT_FAITH',							'YieldTypeToGrant',		'YIELD_FAITH'),
	-- ('BISHOP_THEATER_CONVERT_FAITH',						'YieldTypeToMirror',	'YIELD_CULTURE'),
	-- ('BISHOP_THEATER_CONVERT_FAITH',						'YieldTypeToGrant',		'YIELD_FAITH'),
	-- ('BISHOP_COMMERCIAL_HUB_CONVERT_FAITH',					'YieldTypeToMirror',	'YIELD_GOLD'),
	-- ('BISHOP_COMMERCIAL_HUB_CONVERT_FAITH',					'YieldTypeToGrant',		'YIELD_FAITH'),
	-- ('BISHOP_INDUSTRIAL_ZONE_CONVERT_FAITH',				'YieldTypeToMirror',	'YIELD_PRODUCTION'),
	-- ('BISHOP_INDUSTRIAL_ZONE_CONVERT_FAITH',				'YieldTypeToGrant',		'YIELD_FAITH'),
	-- ('BISHOP_HARBOR_CONVERT_FAITH',							'YieldTypeToMirror',	'YIELD_GOLD'),
	-- ('BISHOP_HARBOR_CONVERT_FAITH',							'YieldTypeToGrant',		'YIELD_FAITH'),
	-- ('BISHOP_THANH_CONVERT_FAITH',							'YieldTypeToMirror',	'YIELD_CULTURE'),
	-- ('BISHOP_THANH_CONVERT_FAITH',							'YieldTypeToGrant',		'YIELD_FAITH'),
	-- ('BISHOP_HOLY_SITE_ADJACENCY_CONVERT_TOURISM',			'YieldType',			'YIELD_FAITH'),
	-- ('BISHOP_HOLY_SITE_ADJACENCY_CONVERT_TOURISM',			'Amount',				100),
--	('CARDINAL_EXTRA_DISTRICT',								'Amount',				1),
--	('CARDINAL_FAITH_PURCHASE_HOLYSITE_BUILDINGS',			'DistrictType',			'DISTRICT_HOLY_SITE'),
--	('CARDINAL_CHEAPER_DISTRICT_PURCHASE',					'Amount',				20),
	-- ('CARDINAL_FAITH_PURCHASE_SHRINE',						'BuildingType',			'BUILDING_SHRINE'),
	-- ('CARDINAL_FAITH_PURCHASE_TEMPLE',						'BuildingType',			'BUILDING_TEMPLE'),
	-- ('CARDINAL_FAITH_PURCHASE_STAVE_CHURCH',				'BuildingType',			'BUILDING_STAVE_CHURCH'), --If enabled, need DLC support
	-- ('CARDINAL_FAITH_PURCHASE_PRASAT',						'BuildingType',			'BUILDING_PRASAT'), --If enabled, need DLC support
	('BISHOP_TRAINED_MONK_EXTRA_COMBAT_STRENGTH',			'ModifierId',			'BISHOP_TRAINED_MONK_EXTRA_COMBAT_STRENGTH_MODIFIER'),
	('BISHOP_TRAINED_MONK_EXTRA_COMBAT_STRENGTH_MODIFIER',	'AbilityType',			'ABILITY_BISHOP_TRAINED_UNIT_STRENGTH'),	
	--('BISHOP_TRAINED_MONK_FASTER_EXP',						'ModifierId',			'BISHOP_TRAINED_MONK_FASTER_EXP_MODIFIER'),
	--('BISHOP_TRAINED_MONK_FASTER_EXP_MODIFIER',				'AbilityType',			'ABILITY_BISHOP_TRAINED_UNIT_EXP'),
--	('PATRON_SAINT_DISTRICT_FAITH',							'YieldType',			'YIELD_FAITH'),
--	('PATRON_SAINT_DISTRICT_FAITH',							'Amount',				4),
	('BISHOP_RELIC_TOURISM2',								'GreatWorkObjectType',	'GREATWORKOBJECT_RELIC'),
	('BISHOP_RELIC_TOURISM2',								'ScalingFactor',		400),
	('BISHOP_UNIT_CITADEL_OF_GOD_FAITH_PURCHASE',			'Tag',					'CLASS_UNIT_CITADEL_OF_GOD');

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--Educator--Pingala=教育家=平伽拉
--基础图书馆员	GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN
--左一鉴赏家		GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR
--右一研究员		GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER
--中二拨款		GOVERNOR_PROMOTION_EDUCATOR_GRANTS
--左三策展人		GOVERNOR_PROMOTION_MERCHANT_CURATOR
--右三科教兴国	GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE
update ModifierArguments set Value = 300 where ModifierId = 'CURATOR_DOUBLE_SCULPTURE_TOURISM' and Name = 'ScalingFactor';
update ModifierArguments set Value = 300 where ModifierId = 'CURATOR_DOUBLE_PORTRAIT_TOURISM' and Name = 'ScalingFactor';
update ModifierArguments set Value = 300 where ModifierId = 'CURATOR_DOUBLE_LANDSCAPE_TOURISM' and Name = 'ScalingFactor';
update ModifierArguments set Value = 300 where ModifierId = 'CURATOR_DOUBLE_RELIGIOUS_TOURISM' and Name = 'ScalingFactor';
update ModifierArguments set Value = 300 where ModifierId = 'CURATOR_DOUBLE_MUSIC_TOURISM' and Name = 'ScalingFactor';
update ModifierArguments set Value = 300 where ModifierId = 'CURATOR_DOUBLE_WRITING_TOURISM' and Name = 'ScalingFactor';

update ModifierArguments set Value = 0.8 where (ModifierId = 'RESEARCHER_SCIENCE_CITIZEN' or ModifierId = 'CONNOISSEUR_CULTURE_CITIZEN') and Name = 'Amount';
-- update ModifierArguments set Value = 25 where (ModifierId = 'LIBRARIAN_CULTURE_YIELD_BONUS' or ModifierId = 'LIBRARIAN_SCIENCE_YIELD_BONUS') and Name = 'Amount';
update ModifierArguments set Value = 100 where ModifierId = 'EDUCATOR_INCREASE_CITY_GREAT_PERSON_POINT_BONUS';

delete from GovernorPromotionModifiers where GovernorPromotionType
	in ('GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN', 'GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR', 'GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER', 'GOVERNOR_PROMOTION_EDUCATOR_GRANTS');
-- 右三太空计划 改名 科教兴国
update GovernorPromotions set Description = 'LOC_GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE_DESCRIPTION_HD' where GovernorPromotionType = 'GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE';

insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType,								ModifierId)
values
	-- 基础 图书馆员 改名 基础教育
	('GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN',				'RESEARCHER_SCIENCE_CITIZEN'),
	('GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN',				'CONNOISSEUR_CULTURE_CITIZEN'),
	-- 左一鉴赏家 改名 招贤纳士
	('GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR',				'EDUCATOR_INCREASE_CITY_GREAT_PERSON_POINT_BONUS'),
	-- 右一研究员 改名 兴学
	('GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER',				'EDUCATOR_RESEARCHER_CAMPUS_ADJACENCY_BONUS'),
	('GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER',				'EDUCATOR_RESEARCHER_THEATER_ADJACENCY_BONUS'),
	('GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER',				'EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS'),
	('GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER',				'EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS2'),
	('GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER',				'EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS'),
	('GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER',				'EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS2'),
	-- 中二拨款 改名 皇家藏书阁
	('GOVERNOR_PROMOTION_EDUCATOR_GRANTS',						'EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS'),
	('GOVERNOR_PROMOTION_EDUCATOR_GRANTS',						'EDUCATOR_GRANTS_CULTURE_YIELD_BONUS'),
	-- ('GOVERNOR_PROMOTION_EDUCATOR_GRANTS',						'EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS_4_TILES'),
	-- ('GOVERNOR_PROMOTION_EDUCATOR_GRANTS',						'EDUCATOR_GRANTS_CULTURE_YIELD_BONUS_4_TILES'),
	-- ('GOVERNOR_PROMOTION_EDUCATOR_GRANTS',						'EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS_6_TILES'),
	-- ('GOVERNOR_PROMOTION_EDUCATOR_GRANTS',						'EDUCATOR_GRANTS_CULTURE_YIELD_BONUS_6_TILES'),
	-- 左三策展人 加 文物业绩
	('GOVERNOR_PROMOTION_MERCHANT_CURATOR',						'CURATOR_DOUBLE_ARTIFACT_TOURISM'),
	-- 科教兴国
	('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE',	'EDUCATOR_CAMPUS_TIER1_SCIENCE'),
	('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE',	'EDUCATOR_CAMPUS_TIER1_SCIENCE_MODIFIER'),
	('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE',	'EDUCATOR_CAMPUS_TIER2_SCIENCE'),
	('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE',	'EDUCATOR_CAMPUS_TIER2_SCIENCE_MODIFIER'),
	('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE',	'EDUCATOR_CAMPUS_TIER3_SCIENCE'),
	('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE',	'EDUCATOR_CAMPUS_TIER3_SCIENCE_MODIFIER');
	-- ('GOVERNOR_PROMOTION_EDUCATOR_GRANTS',				'EDUCATOR_INCREASE_CITY_GREAT_PERSON_POINT_BONUS_EXTRA');

insert or replace into Modifiers
	(ModifierId,																				ModifierType,																															SubjectRequirementSetId)
values
	('EDUCATOR_RESEARCHER_CAMPUS_ADJACENCY_BONUS',			'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',													'DISTRICT_IS_CAMPUS'),
	('EDUCATOR_RESEARCHER_THEATER_ADJACENCY_BONUS',			'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',													'DISTRICT_IS_THEATER'),
	('EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS',				'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',			NULL),
	('EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS2',			'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',			NULL),
	('EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS',			'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',			NULL),
	('EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS2',			'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',			NULL),
	('EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS',							'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',												NULL),
	('EDUCATOR_GRANTS_CULTURE_YIELD_BONUS',							'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',												NULL),
	('CURATOR_DOUBLE_ARTIFACT_TOURISM',									'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',																		NULL),
	('EDUCATOR_CAMPUS_TIER1_SCIENCE',										'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',																'HD_CITY_HAS_SCIENTIFIC_TIER_1_BUILDING_REQUIREMENTS'),
	('EDUCATOR_CAMPUS_TIER1_SCIENCE_MODIFIER',					'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',												'HD_CITY_HAS_SCIENTIFIC_TIER_1_BUILDING_REQUIREMENTS'),
	('EDUCATOR_CAMPUS_TIER2_SCIENCE',										'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',																'HD_CITY_HAS_SCIENTIFIC_TIER_2_BUILDING_REQUIREMENTS'),
	('EDUCATOR_CAMPUS_TIER2_SCIENCE_MODIFIER',					'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',												'HD_CITY_HAS_SCIENTIFIC_TIER_2_BUILDING_REQUIREMENTS'),
	('EDUCATOR_CAMPUS_TIER3_SCIENCE',										'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',																'HD_CITY_HAS_SCIENTIFIC_TIER_3_BUILDING_REQUIREMENTS'),
	('EDUCATOR_CAMPUS_TIER3_SCIENCE_MODIFIER',					'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER',												'HD_CITY_HAS_SCIENTIFIC_TIER_3_BUILDING_REQUIREMENTS');
	-- ('EDUCATOR_INCREASE_CITY_GREAT_PERSON_POINT_BONUS_EXTRA',	'MODIFIER_CITY_INCREASE_GREAT_PERSON_POINT_BONUS',		'PLAYER_HAS_CIVIC_IMPERIAL_EXAMINATION_SYSTEM_HD_REQUIREMENTS');

-- insert or replace into Modifiers
-- 	(ModifierId,																		ModifierType,																					OwnerRequirementSetId,												SubjectRequirementSetId)
-- values
-- 	('EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS_4_TILES',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'PLAYER_HAS_NO_TECH_CHEMISTRY_REQUIREMENTS',	'HD_OBJECT_WITHIN_4_TILES'),
-- 	('EDUCATOR_GRANTS_CULTURE_YIELD_BONUS_4_TILES',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'PLAYER_HAS_NO_TECH_CHEMISTRY_REQUIREMENTS',	'HD_OBJECT_WITHIN_4_TILES'),
-- 	('EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS_6_TILES',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'PLAYER_HAS_TECH_CHEMISTRY_REQUIREMENTS',			'HD_OBJECT_WITHIN_6_TILES'),
-- 	('EDUCATOR_GRANTS_CULTURE_YIELD_BONUS_6_TILES',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'PLAYER_HAS_TECH_CHEMISTRY_REQUIREMENTS',			'HD_OBJECT_WITHIN_6_TILES');

insert or replace into ModifierArguments
	(ModifierId,																				Name,										Value)
values
	('EDUCATOR_RESEARCHER_CAMPUS_ADJACENCY_BONUS',			'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_RESEARCHER_CAMPUS_ADJACENCY_BONUS',			'Amount',								100),
	('EDUCATOR_RESEARCHER_THEATER_ADJACENCY_BONUS',			'YieldType',						'YIELD_CULTURE'),
	('EDUCATOR_RESEARCHER_THEATER_ADJACENCY_BONUS',			'Amount',								100),
	('EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS',				'DistrictType',					'DISTRICT_CAMPUS'),
	('EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS',				'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS',				'Amount',								100),
	('EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS2',			'DistrictType',					'DISTRICT_CAMPUS'),
	('EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS2',			'YieldType',						'YIELD_CULTURE'),
	('EDUCATOR_RESEARCHER_CAMPUS_BUILDING_BONUS2',			'Amount',								100),
	('EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS',			'DistrictType',					'DISTRICT_THEATER'),
	('EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS',			'YieldType',						'YIELD_CULTURE'),
	('EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS',			'Amount',								100),
	('EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS2',			'DistrictType',					'DISTRICT_THEATER'),
	('EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS2',			'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_RESEARCHER_THEATER_BUILDING_BONUS2',			'Amount',								100),

	('EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS',							'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS',							'Amount',								30),
	('EDUCATOR_GRANTS_CULTURE_YIELD_BONUS',							'YieldType',						'YIELD_CULTURE'),
	('EDUCATOR_GRANTS_CULTURE_YIELD_BONUS',							'Amount',								30),
	-- ('EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS_4_TILES',			'YieldType',						'YIELD_SCIENCE'),
	-- ('EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS_4_TILES',			'Amount',								20),
	-- ('EDUCATOR_GRANTS_CULTURE_YIELD_BONUS_4_TILES',			'YieldType',						'YIELD_CULTURE'),
	-- ('EDUCATOR_GRANTS_CULTURE_YIELD_BONUS_4_TILES',			'Amount',								20),
	-- ('EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS_6_TILES',			'YieldType',						'YIELD_SCIENCE'),
	-- ('EDUCATOR_GRANTS_SCIENCE_YIELD_BONUS_6_TILES',			'Amount',								20),
	-- ('EDUCATOR_GRANTS_CULTURE_YIELD_BONUS_6_TILES',			'YieldType',						'YIELD_CULTURE'),
	-- ('EDUCATOR_GRANTS_CULTURE_YIELD_BONUS_6_TILES',			'Amount',								20),

	('CURATOR_DOUBLE_ARTIFACT_TOURISM',									'GreatWorkObjectType',	'GREATWORKOBJECT_ARTIFACT'),
	('CURATOR_DOUBLE_ARTIFACT_TOURISM',									'ScalingFactor',				300),
	('EDUCATOR_CAMPUS_TIER1_SCIENCE',										'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_CAMPUS_TIER1_SCIENCE',										'Amount',								5),
	('EDUCATOR_CAMPUS_TIER1_SCIENCE_MODIFIER',					'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_CAMPUS_TIER1_SCIENCE_MODIFIER',					'Amount',								10),
	('EDUCATOR_CAMPUS_TIER2_SCIENCE',										'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_CAMPUS_TIER2_SCIENCE',										'Amount',								5),
	('EDUCATOR_CAMPUS_TIER2_SCIENCE_MODIFIER',					'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_CAMPUS_TIER2_SCIENCE_MODIFIER',					'Amount',								10),
	('EDUCATOR_CAMPUS_TIER3_SCIENCE',										'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_CAMPUS_TIER3_SCIENCE',										'Amount',								5),
	('EDUCATOR_CAMPUS_TIER3_SCIENCE_MODIFIER',					'YieldType',						'YIELD_SCIENCE'),
	('EDUCATOR_CAMPUS_TIER3_SCIENCE_MODIFIER',					'Amount',								10);
	-- ('EDUCATOR_INCREASE_CITY_GREAT_PERSON_POINT_BONUS_EXTRA',	'Amount',		100);

-----------------------------------------------------------------------------------------------------------------------------------
-- Amani=阿玛尼=外交官
update ModifierArguments set Value = 0 where ModifierId = 'EMISSARY_IDENTITY_PRESSURE_TO_FOREIGN_CITIES' and Name = 'Amount';
--LEVEL 0 GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER
--level 1-0 GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY 左一
--level 1-2 GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE 右一
--level 2-0 GOVERNOR_PROMOTION_LOCAL_INFORMANTS 左二
--level 2-2 GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR 右二
--level 3 GOVERNOR_PROMOTION_AMBASSADOR_PUPPETEER

-- 阿玛尼升级连线修改
insert or ignore into GovernorPromotionPrereqs
    (GovernorPromotionType,             						PrereqGovernorPromotion)
values
    ('GOVERNOR_PROMOTION_LOCAL_INFORMANTS',   					'GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE'),
    ('GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR',   		'GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY');


insert or replace into Governors_XP2 (GovernorType,AssignToMajor) values
	('GOVERNOR_THE_AMBASSADOR',1);
	
delete from GovernorPromotionModifiers where ModifierId = 'FOREIGN_INVESTOR_COPY_STRATEGICS_FOR_IMPORT';
insert or replace into GovernorPromotionModifiers 
	(GovernorPromotionType,								ModifierId) 
values
	('GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER',			'MESSENGER_INFLUENCEPOINTS'),--阿玛尼基础影响力
	('GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY',			'AMANI_FAITH_PURCHASE_SPY'),
	('GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY',			'AMANI_FAITH_PURCHASE_SPY_DISCOUNT'),
	('GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY',			'AMANI_GRANT_SPY_FREE_PROMOTION'),
	('GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY',			'AMANI_SPY_CAPACITY'),
	('GOVERNOR_PROMOTION_LOCAL_INFORMANTS',				'MACHIAVELLIANISM_OFFENSIVESPYTIME'),
	('GOVERNOR_PROMOTION_LOCAL_INFORMANTS',				'LOCAL_INFORMANTS_OFFENSE'),
	('GOVERNOR_PROMOTION_AMBASSADOR_PUPPETEER',			'PUPPETEER_OFFENSE'),
	('GOVERNOR_PROMOTION_AMBASSADOR_PUPPETEER',			'PUPPETEER_DEFENSE'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE',			'FOREIGN_INVESTOR_COPY_STRATEGICS_FOR_IMPORT'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE',			'CONSULATE_LEVY_DISCOUNT'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE',			'BUILDING_GOV_CITYSTATES_UNIT_STRENGTH'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE',			'BUILDING_GOV_CITYSTATES_LEVERAGED_UNIT_STRENGTH'),
	('GOVERNOR_PROMOTION_AMBASSADOR_AFFLUENCE',			'AMANI_EXTRA_ENVOY'),	
	('GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR',	'AMANI_HALF_RAJ_GOLD'),
	('GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR',	'AMANI_HALF_RAJ_SCIENCE'),
	('GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR',	'AMANI_HALF_RAJ_CULTURE'),
	('GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR',	'AMANI_HALF_RAJ_FAITH');
	-- ('GOVERNOR_PROMOTION_AMBASSADOR_PUPPETEER',			'MONARCHY_ENVOYS');

delete from GovernorPromotionModifiers where ModifierId = 'LOCAL_INFORMANTS_SPY_DEFENSE_BONUS';

insert or replace into Modifiers	
	(ModifierId,									ModifierType,											SubjectRequirementSetId,	Permanent)
values
	--('AMANI_CITYSTATES_LEVERAGED_UNIT_STRENGTH',	'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',				NULL,	0),
	('MESSENGER_INFLUENCEPOINTS',					'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN',		'CITY_HAS_AMBASSADOR_MESSENGER_REQUIREMENTS',	0),		
	('AMANI_FAITH_PURCHASE_SPY',					'MODIFIER_SINGLE_CITY_ENABLE_UNIT_FAITH_PURCHASE',		NULL,	0),
	('AMANI_FAITH_PURCHASE_SPY_DISCOUNT',			'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',		NULL,	0),
	('AMANI_GRANT_SPY_FREE_PROMOTION',				'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',					NULL,	0),
	('AMANI_SPY_CAPACITY',							'MODIFIER_PLAYER_GRANT_SPY',							NULL,	0),	
	('AMANI_GRANT_SPY_FREE_PROMOTION_MODIFIER',		'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',	NULL,	1),
	('LOCAL_INFORMANTS_OFFENSE',					'MODIFIER_PLAYER_ADJUST_SPY_BONUS',						NULL,	0),	
	('PUPPETEER_OFFENSE',							'MODIFIER_PLAYER_ADJUST_SPY_BONUS',						NULL,	0),	
	('PUPPETEER_DEFENSE',							'MODIFIER_PLAYER_ADJUST_SPY_BONUS',						NULL,	0),
	('AMANI_EXTRA_ENVOY',							'MODIFIER_GOVERNOR_ADJUST_CITY_ENVOYS',					NULL,	0),
	('AMANI_HALF_RAJ_GOLD',							'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_TRIBUTARY',	NULL,	0),
	('AMANI_HALF_RAJ_SCIENCE',						'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_TRIBUTARY',	NULL,	0),
	('AMANI_HALF_RAJ_CULTURE',						'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_TRIBUTARY',	NULL,	0),
	('AMANI_HALF_RAJ_FAITH',						'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_TRIBUTARY',	NULL,	0);

insert or replace into ModifierArguments
	(ModifierId,										Name,					Value)
values
	--('AMANI_CITYSTATES_LEVERAGED_UNIT_STRENGTH',		'ModifierId',				'AMANI_CITYSTATES_LEVERAGED_UNIT_STRENGTH_MODIFIER'),
	--('AMANI_CITYSTATES_LEVERAGED_UNIT_STRENGTH_MODIFIER','Amount',					4),
	('MESSENGER_INFLUENCEPOINTS',						'Amount',					5),	
	('AMANI_FAITH_PURCHASE_SPY',						'Tag',						'CLASS_SPY'),
	('AMANI_FAITH_PURCHASE_SPY_DISCOUNT',				'UnitType',					'UNIT_SPY'),	
	('AMANI_FAITH_PURCHASE_SPY_DISCOUNT',				'Amount',					50),
	('AMANI_GRANT_SPY_FREE_PROMOTION',					'ModifierId',				'AMANI_GRANT_SPY_FREE_PROMOTION_MODIFIER'),
	('AMANI_SPY_CAPACITY',								'Amount',					2),
	('AMANI_GRANT_SPY_FREE_PROMOTION_MODIFIER',			'AbilityType',				'ABILITY_AMANI_FERR_PROMOTION'),
	('LOCAL_INFORMANTS_OFFENSE',						'Offense',					1),
	('LOCAL_INFORMANTS_OFFENSE',						'Amount',					2),
	('PUPPETEER_OFFENSE',								'Offense',					1),
	('PUPPETEER_OFFENSE',								'Amount',					2),
	('PUPPETEER_DEFENSE',								'Offense',					0),
	('PUPPETEER_DEFENSE',								'Amount',					2),
	('AMANI_EXTRA_ENVOY',								'Amount',					1),
	('AMANI_HALF_RAJ_GOLD',								'YieldType',				'YIELD_GOLD'),
	('AMANI_HALF_RAJ_GOLD',								'Amount',					1),
	('AMANI_HALF_RAJ_SCIENCE',							'YieldType',				'YIELD_SCIENCE'),
	('AMANI_HALF_RAJ_SCIENCE',							'Amount',					1),
	('AMANI_HALF_RAJ_CULTURE',							'YieldType',				'YIELD_CULTURE'),
	('AMANI_HALF_RAJ_CULTURE',							'Amount',					1),
	('AMANI_HALF_RAJ_FAITH',							'YieldType',				'YIELD_FAITH'),
	('AMANI_HALF_RAJ_FAITH',							'Amount',					1);
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
-- Ibrahim=易卜拉欣=大维齐尔=帕夏
--3t就职一级：就职城市的每个人口为本城+1锤。获得单位造价25%的科技值。
--左一：建造军营建筑时额外+30%生产力。军营和军营每级建筑+3瓶。
--右一：10环内对区域+10力。
--中二：与本方和盟友的共同敌人作战时+5力。
--左二：在外国首都就职时，此文明对你不满每回合多降低5，此文明任何城市无法对您城市施加忠诚度压力。
--右二：建造军事单位加速20%。在任职城市内生产文艺复兴以后的近战和攻城单位时会额外赠送一个相同的单位。

update Governors set TransitionStrength = 150 where GovernorType = 'GOVERNOR_IBRAHIM';

-- 树调整
--level 0 GOVERNOR_PROMOTION_PASHA
--level 1-0 GOVERNOR_PROMOTION_HEAD_FALCONER
--LEVEL 1-2 GOVERNOR_PROMOTION_SERASKER
--level 2-1 GOVERNOR_PROMOTION_GRAND_VISIER
--level 3-0 GOVERNOR_PROMOTION_KHASS_ODA_BASHI
--level 3-2 GOVERNOR_PROMOTION_CAPOU_AGHA

--位置调整
update GovernorPromotions set Level = 2, Column = 1 where GovernorPromotionType = 'GOVERNOR_PROMOTION_GRAND_VISIER';
update GovernorPromotions set Level = 3, Column = 0 where GovernorPromotionType = 'GOVERNOR_PROMOTION_KHASS_ODA_BASHI';
update GovernorPromotions set Level = 3, Column = 2 where GovernorPromotionType = 'GOVERNOR_PROMOTION_CAPOU_AGHA';

--连线
delete from GovernorPromotionPrereqs where 
	   GovernorPromotionType = 'GOVERNOR_PROMOTION_PASHA'
	or GovernorPromotionType = 'GOVERNOR_PROMOTION_SERASKER' 
	or GovernorPromotionType = 'GOVERNOR_PROMOTION_KHASS_ODA_BASHI' 
	or GovernorPromotionType = 'GOVERNOR_PROMOTION_CAPOU_AGHA'
	or GovernorPromotionType = 'GOVERNOR_PROMOTION_GRAND_VISIER'
	or GovernorPromotionType = 'GOVERNOR_PROMOTION_HEAD_FALCONER';

insert or ignore into GovernorPromotionPrereqs
    (GovernorPromotionType,             	PrereqGovernorPromotion)
values
    ('GOVERNOR_PROMOTION_HEAD_FALCONER',   	'GOVERNOR_PROMOTION_PASHA'),
    ('GOVERNOR_PROMOTION_SERASKER',   		'GOVERNOR_PROMOTION_PASHA'),
	('GOVERNOR_PROMOTION_GRAND_VISIER',   	'GOVERNOR_PROMOTION_HEAD_FALCONER'),    
	('GOVERNOR_PROMOTION_GRAND_VISIER',   	'GOVERNOR_PROMOTION_SERASKER'),
	('GOVERNOR_PROMOTION_KHASS_ODA_BASHI',  'GOVERNOR_PROMOTION_GRAND_VISIER'),    
	('GOVERNOR_PROMOTION_CAPOU_AGHA',   	'GOVERNOR_PROMOTION_GRAND_VISIER');

--能力
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_PASHA'
	or   GovernorPromotionType = 'GOVERNOR_PROMOTION_HEAD_FALCONER'
	or   GovernorPromotionType = 'GOVERNOR_PROMOTION_CAPOU_AGHA'
	or   GovernorPromotionType = 'GOVERNOR_PROMOTION_KHASS_ODA_BASHI'
	or   GovernorPromotionType = 'GOVERNOR_PROMOTION_GRAND_VISIER';
insert or replace into GovernorPromotionModifiers
	(GovernorPromotionType,         	 	ModifierId)
values
	('GOVERNOR_PROMOTION_PASHA',     		'SERASKER_POP_PRODUCTION'),
	('GOVERNOR_PROMOTION_PASHA',     		'HD_MILITARY_RESEARCH_UNIT_TRAIN_GRANT_SCIENCE_TIME'),
	('GOVERNOR_PROMOTION_HEAD_FALCONER',	'HEAD_FALCONER_ENCAMPMENT_BUILDINGS_PRODUCTION_MODIFIER'),
	('GOVERNOR_PROMOTION_HEAD_FALCONER',	'HEAD_FALCONER_ENCAMPMENT_SCIENCE_BONUS1'),
	('GOVERNOR_PROMOTION_HEAD_FALCONER',	'HEAD_FALCONER_BARRACKS_STABLE_SCIENCE_BONUS1'),
	('GOVERNOR_PROMOTION_HEAD_FALCONER',	'HEAD_FALCONER_ARMORY_SCIENCE_BONUS1'),
	('GOVERNOR_PROMOTION_HEAD_FALCONER',	'HEAD_FALCONER_MILITARY_ACADEMY_SCIENCE_BONUS1'),
	('GOVERNOR_PROMOTION_SERASKER',			'SERASKER_ADJUST_GOVERNOR_COMBAT_DISTRICT'),
	('GOVERNOR_PROMOTION_GRAND_VISIER',		'GRAND_VISIER_ALLIANCE_COMBAT_STRENGTH'),
	('GOVERNOR_PROMOTION_KHASS_ODA_BASHI',	'GRAND_VIZIER_ADJUST_IGNORE_CULTURAL_IDENTITY'),
	('GOVERNOR_PROMOTION_KHASS_ODA_BASHI',	'CAPOU_AGHA_ADJUST_GRIEVANCES'),
	('GOVERNOR_PROMOTION_CAPOU_AGHA',		'PASHA_BONUS_UNIT_PRODUCTION'),
	('GOVERNOR_PROMOTION_CAPOU_AGHA',		'CAPOU_AGHA_EXTRA_MELEE_AND_SIEGE');

insert or replace into Modifiers	
	(ModifierId,												ModifierType,												SubjectRequirementSetId)
values
	('SERASKER_POP_PRODUCTION',									'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',	'PLAYER_IS_OTTOMAN'),
	('CAPOU_AGHA_EXTRA_MELEE_AND_SIEGE',						'MODIFIER_SINGLE_CITY_ADJUST_EXTRA_UNIT_COPY_TAG',			'PLAYER_IS_OTTOMAN'),
	('GRAND_VISIER_ALLIANCE_COMBAT_STRENGTH',					'MODIFIER_PLAYER_ALLIANCES_ATTACH_MODIFIER',				NULL),
	('HD_MILITARY_RESEARCH_UNIT_TRAIN_GRANT_SCIENCE_TIME',  	'MODIFIER_SINGLE_CITY_GRANT_YIELD_PER_UNIT_COST',			NULL),
	('HEAD_FALCONER_ENCAMPMENT_BUILDINGS_PRODUCTION_MODIFIER',	'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION',			NULL),
	('HEAD_FALCONER_ENCAMPMENT_SCIENCE_BONUS1',					'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',					'CITY_HAS_ENCAMPMENT'),
	('HEAD_FALCONER_BARRACKS_STABLE_SCIENCE_BONUS1',			'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',					'BUILDING_IS_BARRACKS_STABLE_MILITARITIC_CITY_STATE'),
	('HEAD_FALCONER_ARMORY_SCIENCE_BONUS1',						'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',					'BUILDING_IS_ARMORY'),
	('HEAD_FALCONER_MILITARY_ACADEMY_SCIENCE_BONUS1',			'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',					'BUILDING_IS_MILITARY_ACADEMY');

insert or replace into Modifiers	
	(ModifierId,										ModifierType,									SubjectRequirementSetId,					SubjectStackLimit)
values
	('GRAND_VISIER_ALLIANCE_COMBAT_STRENGTH_MODIFIER',	'MODIFIER_ALLIANCE_COMBATS_UNIT_STRENGTHS',		'ALLIES_AT_WAR_WITH_TARGET_REQUIREMENTS',	1);

insert or replace into ModifierArguments
	(ModifierId,                                            	Name,                   	Value)
values
	('SERASKER_POP_PRODUCTION',									'YieldType',				'YIELD_PRODUCTION'),
	('SERASKER_POP_PRODUCTION',									'Amount',					1),
	('CAPOU_AGHA_EXTRA_MELEE_AND_SIEGE',						'Tag',						'CLASS_CAPOU_EXTRA'),
	('CAPOU_AGHA_EXTRA_MELEE_AND_SIEGE',						'Amount',					1),
	('GRAND_VISIER_ALLIANCE_COMBAT_STRENGTH',					'ModifierId',				'GRAND_VISIER_ALLIANCE_COMBAT_STRENGTH_MODIFIER'),
	('GRAND_VISIER_ALLIANCE_COMBAT_STRENGTH_MODIFIER',			'Amount',					5),
	('HD_MILITARY_RESEARCH_UNIT_TRAIN_GRANT_SCIENCE_TIME',  	'YieldType',           		'YIELD_SCIENCE'),
	('HD_MILITARY_RESEARCH_UNIT_TRAIN_GRANT_SCIENCE_TIME',  	'UnitProductionPercent',	25),
	('HEAD_FALCONER_ENCAMPMENT_BUILDINGS_PRODUCTION_MODIFIER',	'DistrictType',				'DISTRICT_ENCAMPMENT'),
	('HEAD_FALCONER_ENCAMPMENT_BUILDINGS_PRODUCTION_MODIFIER',	'Amount',					30),
	('HEAD_FALCONER_ENCAMPMENT_SCIENCE_BONUS1',					'YieldType',				'YIELD_SCIENCE'),
	('HEAD_FALCONER_ENCAMPMENT_SCIENCE_BONUS1',					'Amount',					3),
	('HEAD_FALCONER_BARRACKS_STABLE_SCIENCE_BONUS1',			'YieldType',				'YIELD_SCIENCE'),
	('HEAD_FALCONER_BARRACKS_STABLE_SCIENCE_BONUS1',			'Amount',					3),
	('HEAD_FALCONER_ARMORY_SCIENCE_BONUS1',						'YieldType',				'YIELD_SCIENCE'),
	('HEAD_FALCONER_ARMORY_SCIENCE_BONUS1',						'Amount',					3),
	('HEAD_FALCONER_MILITARY_ACADEMY_SCIENCE_BONUS1',			'YieldType',				'YIELD_SCIENCE'),
	('HEAD_FALCONER_MILITARY_ACADEMY_SCIENCE_BONUS1',			'Amount',					3);

update ModifierArguments set Value = 10 where ModifierId = 'SERASKER_ADJUST_GOVERNOR_COMBAT_DISTRICT';
update ModifierArguments set Value = 5 where ModifierId = 'GRAND_VIZIER_ADJUST_IGNORE_CULTURAL_IDENTITY';


insert or replace into TypeTags	(Type,	Tag)
select UnitType,	'CLASS_CAPOU_EXTRA' from Units 
where (PromotionClass = 'PROMOTION_CLASS_MELEE' and Combat >= 55) or (PromotionClass = 'PROMOTION_CLASS_SIEGE' and Combat >= 45);

insert or replace into Tags
	(Tag,									Vocabulary)
values
	('CLASS_CAPOU_EXTRA',					'ABILITY_CLASS');

insert or replace into RequirementSets
	(RequirementSetId,						RequirementSetType)
values
	('PLAYER_IS_OTTOMAN',					'REQUIREMENTSET_TEST_ALL');

insert or replace into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
values
	('PLAYER_IS_OTTOMAN',					'PLAYER_IS_CIVILIZATION_OTTOMAN');

insert or replace into ModifierStrings
    (ModifierId,                                				Context,    Text)
values
    ('GRAND_VISIER_ALLIANCE_COMBAT_STRENGTH_MODIFIER',			'Preview',  'LOC_GRAND_VISIER_ALLIANCE_COMBAT_STRENGTH_MODIFIER_PREVIEW_TEXT');

-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-- Victor=维克托=城主 更新by泉sp
-- 0：新增单位加速30%，防御建筑加速100%，取消城市防御+5力
 -- Level="1" Column="0" :城市防御+5力，驻扎1t回满，删除防御建筑加速和领土内单位防御+5力
 --Level="1" Column="2"  不变
 -- Level="2" Column="1"  不变
 -- Level="3" Column="0"  左右效果互换
 --Level="3" Column="2"  核武加速保留，新增生产工业时代单位额外加速50%，生产军事工程师，飞机和工业时代后的重骑兵时额外赠送一个，这些单位并在友好领土开始回合时+2速(加速所有城市都生效)
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_REDOUBT' and ModifierId = 'DEFENDER_ADJUST_CITY_DEFENSE_STRENGTH';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_GARRISON_COMMANDER' and ModifierId = 'GARRISON_COMMANDER_ADJUST_CITY_COMBAT_BONUS';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_GARRISON_COMMANDER' and ModifierId = 'LIMES_CASTLEPRODUCTION';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_GARRISON_COMMANDER' and ModifierId = 'LIMES_WALLSPRODUCTION';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_GARRISON_COMMANDER' and ModifierId = 'LIMES_STARFORTPRODUCTION';
delete from GovernorPromotionModifiers where GovernorPromotionType = 'GOVERNOR_PROMOTION_GARRISON_COMMANDER' and ModifierId = 'LIMES_TSIKHEPRODUCTION';


-- update ModifierArguments set Value = 50 where ModifierId = 'VICTOR_SCIENCE_TRAINED_UNIT' and Name = 'UnitProductionPercent';
update GovernorPromotions set Column = 0 where GovernorPromotionType = 'GOVERNOR_PROMOTION_COMMANDER' and Level = 3;
update GovernorPromotions set Column = 2 where GovernorPromotionType = 'GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT' and Level = 3;

insert or ignore into GovernorPromotionModifiers
	(GovernorPromotionType,							ModifierId)
values
	('GOVERNOR_PROMOTION_REDOUBT',					'VICTOR_ALL_UNITS_PRODUCTION'),
	('GOVERNOR_PROMOTION_REDOUBT',					'LIMES_CASTLEPRODUCTION'),
	('GOVERNOR_PROMOTION_REDOUBT',					'LIMES_WALLSPRODUCTION'),
	('GOVERNOR_PROMOTION_REDOUBT',					'LIMES_STARFORTPRODUCTION'),
	('GOVERNOR_PROMOTION_REDOUBT',					'LIMES_TSIKHEPRODUCTION'),

	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',		'DEFENDER_ADJUST_CITY_DEFENSE_STRENGTH'),
	('GOVERNOR_PROMOTION_GARRISON_COMMANDER',		'VICTOR_CAN_HEAL_UNITS_ATTACH'),

	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',		'VICTOR_SPEED_UP_INDUSTRIAL_UNITS'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',		'VICTOR_GRNAT_SAME_UNIT_ERA_INDUSTRIAL'),
	('GOVERNOR_PROMOTION_ARMS_RACE_PROPONENT',		'VICTOR_UNITS_FRIENDLY_START_MOVEMENT');
	




insert or ignore into Modifiers
	(ModifierId,								ModifierType, 				RunOnce, Permanent, NewOnly, 		OwnerRequirementSetId, 						SubjectRequirementSetId)
values
	('VICTOR_ALL_UNITS_PRODUCTION',				'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION_MODIFIER', 	0, 0, 0, NULL,								NULL),
	('VICTOR_CAN_HEAL_UNITS_ATTACH',			'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',					0, 0, 0, NULL, 								NULL),
	('VICTOR_CAN_HEAL_UNITS',					'MODIFIER_PLAYER_UNITS_ADJUST_HEAL_PER_TURN',				0, 0, 0, NULL, 								'SET_THIS_CITY_UNITS'),
	('VICTOR_SPEED_UP_INDUSTRIAL_UNITS', 		'MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION', 	0, 0, 0, NULL, 								NULL),
	('VICTOR_GRNAT_SAME_UNIT_ERA_INDUSTRIAL',	'MODIFIER_SINGLE_CITY_ADJUST_EXTRA_UNIT_COPY_TAG',			0, 0, 0, NULL, 								NULL),
	('VICTOR_UNITS_FRIENDLY_START_MOVEMENT',	'MODIFIER_PLAYER_UNITS_ADJUST_FRIENDLY_TERRITORY_START_MOVEMENT',0,1,1,NULL,							'SET_SOME_MILITARY_UNITS');






insert or ignore into ModifierArguments
	(ModifierId,									Name,				Value)
values
	('VICTOR_ALL_UNITS_PRODUCTION',					'Amount',		'30'),
	('VICTOR_CAN_HEAL_UNITS_ATTACH',				'ModifierId',	'VICTOR_CAN_HEAL_UNITS'),
	('VICTOR_CAN_HEAL_UNITS',						'Amount',		'100'),
	('VICTOR_CAN_HEAL_UNITS',						'Type',			'ALL'),

	('VICTOR_SPEED_UP_INDUSTRIAL_UNITS', 			'Amount', 		'50'), 
	('VICTOR_SPEED_UP_INDUSTRIAL_UNITS', 			'StartEra', 	'ERA_INDUSTRIAL'),
	('VICTOR_GRNAT_SAME_UNIT_ERA_INDUSTRIAL',		'Tag',			'CLASS_MILITARY_SP'),
	('VICTOR_GRNAT_SAME_UNIT_ERA_INDUSTRIAL',		'Amount',		'1'),
	('VICTOR_UNITS_FRIENDLY_START_MOVEMENT',		'Amount',		'2');


--重骑，飞机，军工

insert or replace into Tags
    (Tag,                       Vocabulary)
values
   ('CLASS_MILITARY_SP',		'ABILITY_CLASS');

insert or replace into TypeTags(Type,Tag)
select UnitType, 'CLASS_MILITARY_SP' from Units where (PromotionClass = 'PROMOTION_CLASS_HEAVY_CAVALRY' and Combat >= 64) or (FormationClass = 'FORMATION_CLASS_AIR') or (UnitType = 'UNIT_MILITARY_ENGINEER'); 


-- RequirementSets

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('SET_SOME_MILITARY_UNITS', 'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('SET_SOME_MILITARY_UNITS', 'REQ_SOME_MILITARY_UNITS');

-- Requirements

insert or ignore into Requirements (RequirementId, RequirementType) VALUES 
('REQ_SOME_MILITARY_UNITS', 'REQUIREMENT_UNIT_TAG_MATCHES');

insert or ignore into RequirementArguments (RequirementId, Name, Value) VALUES 
('REQ_SOME_MILITARY_UNITS', 'Tag', 'CLASS_MILITARY_SP');


-- RequirementSets

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('SET_THIS_CITY_UNITS', 'REQUIREMENTSET_TEST_ALL');
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('SET_THIS_CITY_UNITS', 'REQ_THIS_CITY_UNITS');
-- Requirements
insert or ignore into Requirements (RequirementId, RequirementType) VALUES 
('REQ_THIS_CITY_UNITS', 'REQUIREMENT_PLOT_UNIT_CITY_HAS_DISTRICT_SAME_OWNER');
insert or ignore into RequirementArguments (RequirementId, Name, Value) VALUES 
('REQ_THIS_CITY_UNITS', 'DistrictType', 'DISTRICT_CITY_CENTER');

-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------