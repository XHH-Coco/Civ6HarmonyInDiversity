-------------------------------------
--   Support Building Functions    --
-------------------------------------

-- Write the new building functions here.
insert or replace into BuildingModifiers
	(BuildingType					,ModifierId)
values
	-- ('BUILDING_JNR_MBARI',			'Mbari_Gold'),
	-- ('BUILDING_JNR_MBARI',			'Mbari_GoldPercent'),
	('BUILDING_JNR_MBARI',			'MBARI_TRADEROUTE');
insert or replace into Modifiers
	(ModifierId,					ModifierType)
values
	-- ('Mbari_Gold',					'MODIFIER_BUILDING_YIELD_CHANGE'),
	-- ('Mbari_GoldPercent',			'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER'),
	('MBARI_TRADEROUTE',			'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY');
insert or replace into ModifierArguments
	(ModifierId,					Name,				Value)
values
	-- ('Mbari_Gold',					'YieldType',		'YIELD_GOLD'),
	-- ('Mbari_Gold',					'Amount',			6),
	-- ('Mbari_Gold',					'BuildingType',		'BUILDING_JNR_MBARI'),
	-- ('Mbari_GoldPercent',			'YieldType',		'YIELD_GOLD'),
	-- ('Mbari_GoldPercent',			'Amount',			10),
	('MBARI_TRADEROUTE',			'Amount',			1);
--Khalwat (Druze)
--建成第一个时获得“保护地球”市政的鼓舞，本城所有地块加一魅力，本城购买自然学家的花费减50%。

--unlock boost of Conservation
--lua needed(specific civic boost rather than eruka ) 
--+1 appeal to all tiles 
insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
values
	-- ('BUILDING_JNR_KHALWAT',	'KHALWA_SINGLE_CITY_APPEAL_BONUS'),
	-- ('BUILDING_JNR_KHALWAT',	'NATURALIST_DISCOUNT');
	('BUILDING_JNR_KHALWAT',	'HD_KHALWAT_GRANT_NATURALIST');

insert or replace into Modifiers
	(ModifierId,										RunOnce,	Permanent,	ModifierType)
values
	('HD_KHALWAT_GRANT_NATURALIST',	1,				1,					'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY');

-- insert or replace into Modifiers
-- 	(ModifierId,						ModifierType,								RunOnce,SubjectRequirementSetId)
-- values
-- 	('KHALWA_SINGLE_CITY_APPEAL_BONUS',	'MODIFIER_SINGLE_CITY_ADJUST_CITY_APPEAL',			0,NULL),
-- 	('NATURALIST_DISCOUNT',				'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PURCHASE_COST',	0,NULL);

insert or replace into ModifierArguments
	(ModifierId,						Name,				Value)
values
	-- ('KHALWA_SINGLE_CITY_APPEAL_BONUS',	'Amount',			1),
	-- ('NATURALIST_DISCOUNT',				'UnitType',			'UNIT_NATURALIST'),
	-- ('NATURALIST_DISCOUNT',				'Amount',			50);
	('HD_KHALWAT_GRANT_NATURALIST',		'UnitType',					'UNIT_NATURALIST'),
	('HD_KHALWAT_GRANT_NATURALIST',		'Amount',					1);

-- 禅邸，神道教神社和羽蛇神庙
insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
values
-- 禅邸
	('BUILDING_JNR_CANDI',					'CANDI_CULTURE'),
	('BUILDING_JNR_CANDI',					'CANDI_FAITH'),
-- 神道教神社
	('BUILDING_JNR_JINJA',					'JNR_JINJA_FOREST_FOOD'),
	('BUILDING_JNR_JINJA',					'JNR_JINJA_JUNGLE_SCIENCE'),
	('BUILDING_JNR_JINJA',					'JNR_JINJA_MARSH_CULTURE'),
-- 羽蛇神庙
	('BUILDING_JNR_TZACUALLI',				'JNR_TZACUALLI_EXTRA_SCIENTIST_POINTS');

-- 羽蛇神庙
insert or replace into BuildingModifiers
	(BuildingType,          ModifierId)
values
	('BUILDING_PALACE',     'JNR_TZACUALLI_CIVIC_BOOST_MDF'),
	('BUILDING_PALACE',     'HD_JNR_TZACUALLI_CIVIC_BOOST_MDF_RECORD'),
	('BUILDING_PALACE',     'JNR_TZACUALLI_TECHNOLOGY_BOOST_MDF'),
	('BUILDING_PALACE',     'HD_JNR_TZACUALLI_TECHNOLOGY_BOOST_MDF_RECORD');

insert or replace into Modifiers
	(ModifierId,							ModifierType,										SubjectRequirementSetId,		SubjectStackLimit)
values
-- 禅邸
	('CANDI_CULTURE',						'MODIFIER_CITY_ADJUST_CITY_YIELD_PER_TERRAIN_TYPE',	NULL,							NULL),
	('CANDI_FAITH',							'MODIFIER_CITY_ADJUST_CITY_YIELD_PER_TERRAIN_TYPE',	NULL,							NULL),
-- 神道教神社
	('JNR_JINJA_FOREST_FOOD',				'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',		'PLOT_HAS_FOREST_REQUIREMENT',	NULL),
	('JNR_JINJA_JUNGLE_SCIENCE',			'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',		'PLOT_HAS_JUNGLE_REQUIREMENT',	NULL),
	('JNR_JINJA_MARSH_CULTURE',				'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',		'PLOT_HAS_MARSH_REQUIREMENTS',	NULL),
-- 羽蛇神庙
	('JNR_TZACUALLI_CIVIC_BOOST_MDF',		'MODIFIER_PLAYER_ADJUST_CIVIC_BOOST',				'PLAYER_HAS_BUILDING_JNR_TZACUALLI_REQUIREMENTS',							NULL),
	('HD_JNR_TZACUALLI_CIVIC_BOOST_MDF_RECORD',		'MODIFIER_PLAYER_ADJUST_PROPERTY',				'PLAYER_HAS_BUILDING_JNR_TZACUALLI_REQUIREMENTS',							NULL),
	('JNR_TZACUALLI_TECHNOLOGY_BOOST_MDF',	'MODIFIER_PLAYER_ADJUST_TECHNOLOGY_BOOST',			'PLAYER_HAS_BUILDING_JNR_TZACUALLI_REQUIREMENTS',							NULL),
	('HD_JNR_TZACUALLI_TECHNOLOGY_BOOST_MDF_RECORD',	'MODIFIER_PLAYER_ADJUST_PROPERTY',			'PLAYER_HAS_BUILDING_JNR_TZACUALLI_REQUIREMENTS',							NULL),
	('JNR_TZACUALLI_EXTRA_SCIENTIST_POINTS',	'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',			NULL,							NULL);

insert or replace into ModifierArguments
	(ModifierId,							Name,												Value)
values
-- 禅邸
	('CANDI_CULTURE',						'YieldType',										'YIELD_CULTURE'),
	('CANDI_CULTURE',						'Amount',											1),
	('CANDI_CULTURE',						'TerrainType',										'TERRAIN_COAST'),
	('CANDI_FAITH',							'YieldType',										'YIELD_FAITH'),
	('CANDI_FAITH',							'Amount',											1),
	('CANDI_FAITH',							'TerrainType',										'TERRAIN_COAST'),
-- 神道教神社
	('JNR_JINJA_FOREST_FOOD',				'YieldType',										'YIELD_FOOD'),
	('JNR_JINJA_FOREST_FOOD',				'Amount',											2),
	('JNR_JINJA_JUNGLE_SCIENCE',			'YieldType',										'YIELD_PRODUCTION'),
	('JNR_JINJA_JUNGLE_SCIENCE',			'Amount',											2),
	('JNR_JINJA_MARSH_CULTURE',				'YieldType',										'YIELD_CULTURE'),
	('JNR_JINJA_MARSH_CULTURE',				'Amount',											2),
-- 羽蛇神庙
	('JNR_TZACUALLI_CIVIC_BOOST_MDF',		'Amount',											3),
	('HD_JNR_TZACUALLI_CIVIC_BOOST_MDF_RECORD',		'Key',											'HD_Player_Extra_Tech_Boost'),
	('HD_JNR_TZACUALLI_CIVIC_BOOST_MDF_RECORD',		'Amount',											3),
	('JNR_TZACUALLI_TECHNOLOGY_BOOST_MDF',	'Amount',											3),
	('HD_JNR_TZACUALLI_TECHNOLOGY_BOOST_MDF_RECORD',	'Key',											'HD_Player_Extra_Civic_Boost'),
	('HD_JNR_TZACUALLI_TECHNOLOGY_BOOST_MDF_RECORD',	'Amount',											3),
	('JNR_TZACUALLI_EXTRA_SCIENTIST_POINTS',	'GreatPersonClassType',											'GREAT_PERSON_CLASS_SCIENTIST'),
	('JNR_TZACUALLI_EXTRA_SCIENTIST_POINTS',	'Amount',											10);

--Mandir
insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
values
	('BUILDING_JNR_MANDIR',		'MANDIR_SPECIAL_DISTRICT_FOOD');
	-- ('BUILDING_JNR_MANDIR',		'MANDIR_SPECIAL_DISTRICT_FAITH');

insert or replace into Modifiers
	(ModifierId,							ModifierType,											SubjectRequirementSetId)
values
	('MANDIR_SPECIAL_DISTRICT_FOOD',		'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',	'DISTRICT_IS_SPECIALTY_DISTRICT_REQUIREMENTS'),
	('MANDIR_SPECIAL_DISTRICT_FAITH',		'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',	'DISTRICT_IS_SPECIALTY_DISTRICT_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,							Name,			Value)
values
	('MANDIR_SPECIAL_DISTRICT_FOOD',	'YieldType',		'YIELD_FOOD'),	
	('MANDIR_SPECIAL_DISTRICT_FOOD',	'Amount',			3),
	('MANDIR_SPECIAL_DISTRICT_FAITH',	'YieldType',		'YIELD_FAITH'),
	('MANDIR_SPECIAL_DISTRICT_FAITH',	'Amount',			1);

-- Peripteros
insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
values
	('BUILDING_JNR_PERIPTEROS',		'CIVIC_AWARD_ONE_INFLUENCE_TOKEN'),
	('BUILDING_JNR_PERIPTEROS',		'PERIPTEROS_INFLUENCEPOINTS');
-- 	('BUILDING_JNR_PERIPTEROS',		'CIVIC_AWARD_ONE_INFLUENCE_TOKEN'),
-- 	('BUILDING_JNR_PERIPTEROS',		'PERIPTEROS_ADJUST_SINGLE_CITY_CULTURE_PERCENTAGE_PER_SUZEREN'),
-- 	('BUILDING_JNR_PERIPTEROS',		'PERIPTEROS_ADJUST_SINGLE_CITY_FAITH_PERCENTAGE_PER_SUZEREN');

insert or replace into Modifiers
 	(ModifierId,													ModifierType)
values
	('PERIPTEROS_INFLUENCEPOINTS',									'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN');
-- 	('PERIPTEROS_ADJUST_SINGLE_CITY_CULTURE_PERCENTAGE_PER_SUZEREN','MODIFIER_SINGLE_CITY_ADJUST_YIELD_MODIFIER_PER_TRIBUTARY'),
-- 	('PERIPTEROS_ADJUST_SINGLE_CITY_FAITH_PERCENTAGE_PER_SUZEREN',	'MODIFIER_SINGLE_CITY_ADJUST_YIELD_MODIFIER_PER_TRIBUTARY');

insert or replace into ModifierArguments
 	(ModifierId,													Name,			Value)
values
	('PERIPTEROS_INFLUENCEPOINTS',									'Amount',		2);
-- 	('PERIPTEROS_ADJUST_SINGLE_CITY_CULTURE_PERCENTAGE_PER_SUZEREN','YieldType',	'YIELD_CULTURE'),
-- 	('PERIPTEROS_ADJUST_SINGLE_CITY_CULTURE_PERCENTAGE_PER_SUZEREN','Amount',		2),
-- 	('PERIPTEROS_ADJUST_SINGLE_CITY_FAITH_PERCENTAGE_PER_SUZEREN',	'YieldType',	'YIELD_FAITH'),
-- 	('PERIPTEROS_ADJUST_SINGLE_CITY_FAITH_PERCENTAGE_PER_SUZEREN',	'Amount',		2);

-- BUILDING_JNR_SOBOR
insert or replace into Building_GreatWorks
	(BuildingType,			GreatWorkSlotType,		NumSlots)
values
	('BUILDING_JNR_SOBOR',	'GREATWORKSLOT_RELIC',	1);

insert or replace into BuildingModifiers
	(BuildingType,				ModifierId)
values
	('BUILDING_JNR_SOBOR',		'SOBOR_RELIC_FAITH'),
	('BUILDING_JNR_SOBOR',		'SOBOR_RELIC_TOURISM');

insert or replace into Modifiers
	(ModifierId,				ModifierType)	
values
	('SOBOR_RELIC_FAITH',		'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD'),
	('SOBOR_RELIC_TOURISM',		'MODIFIER_SINGLE_CITY_ADJUST_TOURISM');

insert or replace into ModifierArguments
	(ModifierId,				name,					value)
values
	('SOBOR_RELIC_FAITH',		'GreatWorkObjectType',	'GREATWORKOBJECT_RELIC'),
	('SOBOR_RELIC_FAITH',		'YieldType',			'YIELD_FAITH'),
	('SOBOR_RELIC_FAITH',		'ScalingFactor',		200),
	('SOBOR_RELIC_TOURISM',		'GreatWorkObjectType',	'GREATWORKOBJECT_RELIC'),
	('SOBOR_RELIC_TOURISM',		'ScalingFactor',		200);

insert or ignore into RequirementSetRequirements
	(RequirementSetId,										RequirementId)
select
	'BUILDING_IS_TIER3_HOLY_SITE',							'REQUIRES_CITY_HAS_' || BuildingType
from Buildings where PrereqDistrict = 'DISTRICT_HOLY_SITE' and cost = 220;
