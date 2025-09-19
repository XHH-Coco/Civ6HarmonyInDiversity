-- 政体槽位
insert or replace into Government_SlotCounts
	(GovernmentType,					        GovernmentSlotType,		NumSlots)
values
	('GOVERNMENT_MONARCHY',				    'SLOT_MILITARY',		  2),
	('GOVERNMENT_MONARCHY',				    'SLOT_ECONOMIC',		  2),
	('GOVERNMENT_MONARCHY',				    'SLOT_DIPLOMATIC',		1),
	('GOVERNMENT_MONARCHY',				    'SLOT_WILDCARD',		  1),

	('GOVERNMENT_THEOCRACY',			    'SLOT_MILITARY',		  2),
	('GOVERNMENT_THEOCRACY',			    'SLOT_ECONOMIC',		  1),
	('GOVERNMENT_THEOCRACY',			    'SLOT_DIPLOMATIC',		2),
	('GOVERNMENT_THEOCRACY',			    'SLOT_WILDCARD',		  1),

	('GOVERNMENT_MERCHANT_REPUBLIC',	'SLOT_MILITARY',		  1),
	('GOVERNMENT_MERCHANT_REPUBLIC',	'SLOT_ECONOMIC',		  2),
	('GOVERNMENT_MERCHANT_REPUBLIC',	'SLOT_DIPLOMATIC',		1),
	('GOVERNMENT_MERCHANT_REPUBLIC',	'SLOT_WILDCARD',		  2),

	('GOVERNMENT_FASCISM',				    'SLOT_MILITARY',		  3),
	('GOVERNMENT_FASCISM',				    'SLOT_ECONOMIC',		  2),
	('GOVERNMENT_FASCISM',				    'SLOT_DIPLOMATIC',		1),
	('GOVERNMENT_FASCISM',				    'SLOT_WILDCARD',		  2),

	('GOVERNMENT_COMMUNISM',			    'SLOT_MILITARY',		  2),
	('GOVERNMENT_COMMUNISM',			    'SLOT_ECONOMIC',		  2),
	('GOVERNMENT_COMMUNISM',			    'SLOT_DIPLOMATIC',		2),
	('GOVERNMENT_COMMUNISM',			    'SLOT_WILDCARD',		  2),

	('GOVERNMENT_DEMOCRACY',			    'SLOT_MILITARY',		  1),
	('GOVERNMENT_DEMOCRACY',			    'SLOT_ECONOMIC',		  3),
	('GOVERNMENT_DEMOCRACY',			    'SLOT_DIPLOMATIC',		2),
	('GOVERNMENT_DEMOCRACY',			    'SLOT_WILDCARD',		  2);

-- 政体效果
-- 独裁
delete from GovernmentModifiers where ModifierId in (
	'AUTOCRACY_CAPITAL',
	'AUTOCRACY_TIER1',
	'AUTOCRACY_TIER2',
	'AUTOCRACY_TIER3',
	'CONSULATE_TIER1',
	'CHANCERY_TIER2'
);
delete from PolicyModifiers where ModifierId in (
	'AUTOCRACY_CAPITAL',
	'AUTOCRACY_TIER1',
	'AUTOCRACY_TIER2',
	'AUTOCRACY_TIER3',
	'CONSULATE_TIER1',
	'CHANCERY_TIER2'
);

create temporary table AUTOCRACY_HD (
  BuildingType text not null,
	ModifierId text not null,
	YieldType text not null,
	primary key(ModifierId)
);

insert or replace into AUTOCRACY_HD
	(BuildingType,			ModifierId,											YieldType)
select
	BuildingType,				BuildingType || '_FOOD',				'YIELD_FOOD'
from HD_BuildingTiers where BuildingType = 'BUILDING_PALACE' or ((PrereqDistrict = 'DISTRICT_GOVERNMENT' or PrereqDistrict = 'DISTRICT_DIPLOMATIC_QUARTER') and ReplacesOther = 0) union all
select
	BuildingType,				BuildingType || '_PRODUCTION',	'YIELD_PRODUCTION'
from HD_BuildingTiers where BuildingType = 'BUILDING_PALACE' or ((PrereqDistrict = 'DISTRICT_GOVERNMENT' or PrereqDistrict = 'DISTRICT_DIPLOMATIC_QUARTER') and ReplacesOther = 0);

insert or replace into GovernmentModifiers (GovernmentType, ModifierId)
	select 'GOVERNMENT_AUTOCRACY', ModifierId from AUTOCRACY_HD;

insert or replace into PolicyModifiers (PolicyType, ModifierId)
	select 'POLICY_GOV_AUTOCRACY', ModifierId from AUTOCRACY_HD;

insert or replace into Modifiers (ModifierId, ModifierType)
	select ModifierId, 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE' from AUTOCRACY_HD;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select ModifierId, 'BuildingType', BuildingType from AUTOCRACY_HD union all
	select ModifierId, 'Amount', 3 from AUTOCRACY_HD union all
	select ModifierId, 'YieldType', YieldType from AUTOCRACY_HD;

-- 共和
insert or replace into GovernmentModifiers
	(GovernmentType,					ModifierId)
values
	('GOVERNMENT_CLASSICAL_REPUBLIC',	'CLASSICAL_REPUBLIC_CULTURE'),
	('GOVERNMENT_CLASSICAL_REPUBLIC',	'CLASSICAL_REPUBLIC_SCIENCE');
insert or replace into PolicyModifiers
	(PolicyType,						ModifierId)
values
	('POLICY_GOV_CLASSICAL_REPUBLIC',	'CLASSICAL_REPUBLIC_CULTURE'),
	('POLICY_GOV_CLASSICAL_REPUBLIC',	'CLASSICAL_REPUBLIC_SCIENCE');
insert or replace into Modifiers
	(ModifierId,					ModifierType,												SubjectRequirementSetId)
values
	('CLASSICAL_REPUBLIC_CULTURE',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',			'CITY_HAS_1_SPECIALTY_DISTRICT'),
	('CLASSICAL_REPUBLIC_SCIENCE',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',			'CITY_HAS_1_SPECIALTY_DISTRICT');
insert or replace into ModifierArguments
	(ModifierId,					Name,					Value)
values
	('CLASSICAL_REPUBLIC_CULTURE',	'YieldType',			'YIELD_CULTURE'),
	('CLASSICAL_REPUBLIC_CULTURE',	'Amount',				1),
	('CLASSICAL_REPUBLIC_SCIENCE',	'YieldType',			'YIELD_SCIENCE'),
	('CLASSICAL_REPUBLIC_SCIENCE',	'Amount',				1);

-- 君主
update Governments set PrereqCivic = 'CIVIC_CIVIL_SERVICE' where GovernmentType = 'GOVERNMENT_MONARCHY';
delete from GovernmentModifiers where GovernmentType = 'GOVERNMENT_MONARCHY' and ModifierId in (
	'MONARCHY_WALLS_HOUSING',
	'MONARCHY_CASTLE_HOUSING',
	'MONARCHY_STARFORT_HOUSING',
	'MONARCHY_STARFORT_FAVOR'
);
delete from PolicyModifiers where PolicyType = 'POLICY_GOV_MONARCHY' and ModifierId in (
	'MONARCHY_WALLS_HOUSING',
	'MONARCHY_CASTLE_HOUSING',
	'MONARCHY_STARFORT_HOUSING',
	'MONARCHY_STARFORT_FAVOR'
);
insert or replace into GovernmentModifiers
	(GovernmentType,						ModifierId)
values
	('GOVERNMENT_MONARCHY',			'MONARCHY_CITYGROWTH_BONUS'),
	('GOVERNMENT_MONARCHY',			'MONARCHY_DISTRICT_BONUS'),
	('GOVERNMENT_MONARCHY',			'MONARCHY_UNITPRODUCTION_BONUS');
insert or replace into PolicyModifiers
	(PolicyType,							ModifierId)
values
	('POLICY_GOV_MONARCHY',					'MONARCHY_CITYGROWTH_BONUS'),
	('POLICY_GOV_MONARCHY',					'MONARCHY_DISTRICT_BONUS');
insert or replace into Modifiers
	(ModifierId,												ModifierType,																								SubjectRequirementSetId)
values
	('MONARCHY_CITYGROWTH_BONUS',				'MODIFIER_PLAYER_CITIES_ADJUST_CITY_GROWTH',								'CITY_HAS_GARRISON_UNIT_REQUIERMENT'),
	('MONARCHY_DISTRICT_BONUS',					'MODIFIER_PLAYER_CITIES_ADJUST_ALL_DISTRICTS_PRODUCTION',		'CITY_HAS_GARRISON_UNIT_REQUIERMENT'),
	('MONARCHY_UNITPRODUCTION_BONUS',		'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PRODUCTION_MODIFIER',		'CITY_HAS_GARRISON_UNIT_REQUIERMENT');
insert or replace into ModifierArguments
	(ModifierId,												Name,														Value)
values
	('MONARCHY_CITYGROWTH_BONUS',				'Amount',												10),
	('MONARCHY_DISTRICT_BONUS',					'Amount',												25),
	('MONARCHY_UNITPRODUCTION_BONUS',		'Amount',												20);

-- 神权
delete from GovernmentModifiers where GovernmentType = 'GOVERNMENT_THEOCRACY' and ModifierId in (
	'THEOCRACY_RELIGIOUS_PEOPLE'
);
delete from PolicyModifiers where PolicyType = 'POLICY_GOV_THEOCRACY' and ModifierId in (
	'THEOCRACY_RELIGIOUS_PEOPLE'
);

insert or replace into GovernmentModifiers
	(GovernmentType,					ModifierID)
values
	('GOVERNMENT_THEOCRACY',	'THEOCRACY_HOLY_SITE_PURCHASE_MILITARY');
insert or replace into Modifiers
	(ModifierId,								ModifierType,											SubjectRequirementSetId)
values
	('THEOCRACY_HOLY_SITE_PURCHASE_MILITARY',	'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE',	'CITY_HAS_HOLY_SITE');
insert or replace into ModifierArguments
	(ModifierId,								Name,	Value)
values
	('THEOCRACY_HOLY_SITE_PURCHASE_MILITARY',	'Tag',	'CLASS_LAND_COMBAT');

insert or ignore into GovernmentModifiers (GovernmentType, ModifierID)
	select distinct 'GOVERNMENT_THEOCRACY', 'THEOCRACY_HOLY_SITE_BUILDING_' || Tier || '_BONUS' from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';
insert or ignore into PolicyModifiers (PolicyType, ModifierId)
	select distinct 'POLICY_GOV_THEOCRACY', 'THEOCRACY_HOLY_SITE_BUILDING_' || Tier || '_BONUS' from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';
insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	select distinct 'THEOCRACY_HOLY_SITE_BUILDING_' || Tier || '_BONUS', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_POPULATION', 'CITY_HAS_DISTRICT_HOLY_SITE_TIER_' || Tier || '_BUILDING_REQUIREMENTS'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';
insert or ignore into ModifierArguments (ModifierId, Name,	Value)
	select distinct 'THEOCRACY_HOLY_SITE_BUILDING_' || Tier || '_BONUS', 'YieldType', 'YIELD_FAITH' from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';
insert or ignore into ModifierArguments (ModifierId, Name,	Value)
	select distinct 'THEOCRACY_HOLY_SITE_BUILDING_' || Tier || '_BONUS', 'Amount', 0.5 from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

-- 商共
delete from GovernmentModifiers where GovernmentType = 'GOVERNMENT_MERCHANT_REPUBLIC' and ModifierId in (
	'MERCHANT_REPUBLIC_DISTRICTS'
);
delete from PolicyModifiers where PolicyType = 'POLICY_GOV_MERCHANT_REPUBLIC' and ModifierId in (
	'MERCHANT_REPUBLIC_DISTRICTS'
);

update ModifierArguments set Value = 10 where ModifierId = 'MERCHANT_REPUBLIC_GOLD_MODIFIER' and Name = 'Amount';
insert or replace into GovernmentModifiers
	(GovernmentType,									ModifierId)
values
	('GOVERNMENT_MERCHANT_REPUBLIC',	'LANDSURVEYORS_PLOTPURCHASECOST'),
	('GOVERNMENT_MERCHANT_REPUBLIC',	'MERCHANT_REPUBLIC_POP_GOLD');
insert or replace into PolicyModifiers
	(PolicyType,											ModifierID)
values
	('POLICY_GOV_MERCHANT_REPUBLIC',	'MERCHANT_REPUBLIC_POP_GOLD');

insert or replace into Modifiers
	(ModifierId,												ModifierType)
values
	('MERCHANT_REPUBLIC_POP_GOLD',			'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_POPULATION');
insert or replace into ModifierArguments
	(ModifierId,												Name,							Value)
values
	('MERCHANT_REPUBLIC_POP_GOLD',			'Amount',					4),
	('MERCHANT_REPUBLIC_POP_GOLD',			'YieldType',			'YIELD_GOLD');

-- 民主
delete from GovernmentModifiers where GovernmentType = 'GOVERNMENT_DEMOCRACY' and ModifierId in (
	'DEMOCRACY_TRADEROUTEFOODTOALLY',
	'DEMOCRACY_TRADEROUTEPRODUCTIONTOALLY',
	'DEMOCRACY_TRADEROUTEFOODFROMALLY',
	'DEMOCRACY_TRADEROUTEPRODUCTIONFROMALLY',
	'DEMOCRACY_TRADEROUTEFOODTOSUZERAIN',
	'DEMOCRACY_TRADEROUTEPRODUCTIONTOSUZERAIN',
	'DEMOCRACY_TRADEROUTEFOODFROMSUZERAIN',
	'DEMOCRACY_TRADEROUTEPRODUCTIONFROMSUZERAIN',
	'DEMOCRACY_ALLIANCEPOINTS'
);
delete from PolicyModifiers where PolicyType = 'POLICY_GOV_DEMOCRACY' and ModifierId in (
	'DEMOCRACY_TRADEROUTEFOODTOALLY',
	'DEMOCRACY_TRADEROUTEPRODUCTIONTOALLY',
	'DEMOCRACY_TRADEROUTEFOODFROMALLY',
	'DEMOCRACY_TRADEROUTEPRODUCTIONFROMALLY',
	'DEMOCRACY_TRADEROUTEFOODTOSUZERAIN',
	'DEMOCRACY_TRADEROUTEPRODUCTIONTOSUZERAIN',
	'DEMOCRACY_TRADEROUTEFOODFROMSUZERAIN',
	'DEMOCRACY_TRADEROUTEPRODUCTIONFROMSUZERAIN',
	'DEMOCRACY_ALLIANCEPOINTS'
);

insert or replace into GovernmentModifiers
	(GovernmentType,												ModifierId)
values
	('GOVERNMENT_DEMOCRACY',								'DEMOCRACY_ENABLE_DISTRICT_PURCHASE'),
	('GOVERNMENT_DEMOCRACY',								'DEMOCRACY_GPP_BONUS');
insert or replace into PolicyModifiers
	(PolicyType,														ModifierId)
values
	('POLICY_GOV_DEMOCRACY',								'DEMOCRACY_ENABLE_DISTRICT_PURCHASE'),
	('POLICY_GOV_DEMOCRACY',								'DEMOCRACY_GPP_BONUS');
insert or replace into Modifiers
	(ModifierId,														ModifierType,																							SubjectRequirementSetId)
values
	('DEMOCRACY_ENABLE_DISTRICT_PURCHASE',	'MODIFIER_PLAYER_CITIES_ENABLE_DISTRICT_PURCHASE',				null),
	('DEMOCRACY_GPP_BONUS',									'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',									'CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_3_BUILDING_REQUIREMENTS'),
	('DEMOCRACY_GPP_BONUS_MODIFIER',				'MODIFIER_PLAYER_CITIES_ADJUST_GREAT_PERSON_POINT_BONUS',	null);
insert or replace into ModifierArguments
	(ModifierId,														Name,								Value)
values
	('DEMOCRACY_ENABLE_DISTRICT_PURCHASE',	'CanPurchase',			1),
	('DEMOCRACY_GPP_BONUS',									'ModifierId',				'DEMOCRACY_GPP_BONUS_MODIFIER'),
	('DEMOCRACY_GPP_BONUS_MODIFIER',				'Amount',						5);

update Modifiers set ModifierType = 'MODIFIER_PLAYER_IMPROVEMENTS_ATTACH_MODIFIER', SubjectRequirementSetId = 'PLOT_HAS_IMPROVEMENT_CORPORATION_REQUIREMENTS'
	where ModifierId = 'DEMOCRACY_GPP_BONUS' and exists (select ImprovementType from Improvements where ImprovementType = 'IMPROVEMENT_CORPORATION');

update ModifierArguments set Value = 15 where ModifierId = 'DEMOCRACY_GOLD_PURCHASE' and Name = 'Amount';

-- 共产
update ModifierArguments set Value = 1 where ModifierId = 'COMMUNISM_PRODUCTIVE_PEOPLE' and Name = 'Amount';
update Modifiers set SubjectRequirementSetId = null where ModifierId = 'COMMUNISM_PRODUCTIVE_PEOPLE';
update ModifierArguments set Value = 15 where ModifierId = 'COMMUNISM_SCIENCE' and Name = 'Amount';
update Modifiers set SubjectRequirementSetId = 'CITY_HAS_15_POPULATION' where ModifierId = 'COMMUNISM_SCIENCE';

insert or replace into GovernmentModifiers
	(GovernmentType,												ModifierId)
values
	('GOVERNMENT_COMMUNISM',								'COMMUNISM_WONDER_PRODUCTION'),
	('GOVERNMENT_COMMUNISM',								'COMMUNISM_BUILDING_PRODUCTION'),
	('GOVERNMENT_COMMUNISM',								'COMMUNISM_DISTRICT_PRODUCTION');
insert or replace into PolicyModifiers
	(PolicyType,														ModifierId)
values
	('POLICY_GOV_COMMUNISM',								'DEMOCRACY_GPP_BONUS');
insert or replace into Modifiers
	(ModifierId,														ModifierType,																									SubjectRequirementSetId)
values
	('COMMUNISM_WONDER_PRODUCTION',					'MODIFIER_PLAYER_CITIES_ADJUST_WONDER_ERA_PRODUCTION',				null),
	('COMMUNISM_BUILDING_PRODUCTION',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION_MODIFIER',	null),
	('COMMUNISM_DISTRICT_PRODUCTION',				'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION_MODIFIER',	null);
insert or replace into ModifierArguments
	(ModifierId,														Name,								Value)
values
	('COMMUNISM_WONDER_PRODUCTION',					'Amount',						25),
	('COMMUNISM_WONDER_PRODUCTION',					'IsWonder',					1),
	('COMMUNISM_WONDER_PRODUCTION',					'StartEra',					'ERA_INDUSTRIAL'),
	('COMMUNISM_WONDER_PRODUCTION',					'EndEra',						'ERA_INFORMATION'),
	('COMMUNISM_BUILDING_PRODUCTION',				'IsWonder',					0),
	('COMMUNISM_BUILDING_PRODUCTION',				'Amount',						50),
	('COMMUNISM_DISTRICT_PRODUCTION',				'Amount',						50);