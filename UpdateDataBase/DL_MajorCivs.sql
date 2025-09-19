-------------------------------------
-- Major Civilizations Adjustments --
-------------------------------------

-- 所有文明赠送效果
insert or replace into TraitModifiers
	(TraitType,								ModifierId)
values
	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_SUZERAIN_FAVOR_UNTIL_COLONIALISM'),
	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_PRESERVE_VALID_FOREST'),
	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_PRESERVE_VALID_JUNGLE'),
	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_PRESERVE_VALID_MARSH'),
--	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_PRESERVE_VALID_SWAMP'),
-- 伟人赞助折扣
	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_PATRONAGE_DISCOUNT_FAITH_PERCENT'),
	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_PATRONAGE_DISCOUNT_GOLD_PERCENT'),
-- 贸易路线大使馆
	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_ADJUST_PROGRESS_DIFF_TRADE_BONUS'),
-- 剧院享受魅力加成
	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_CHARMING_THEATER_DISTRICT'),
	('TRAIT_LEADER_MAJOR_CIV',				'TRAIT_BREATHTAKING_THEATER_DISTRICT');

insert or replace into TraitModifiers
	(TraitType,								ModifierId)
select
	'TRAIT_LEADER_MAJOR_CIV',				'TRAIT_PRESERVE_VALID_SWAMP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');

-- Use insert or ignore to support the missing DLC case.
insert or ignore into Modifiers
	(ModifierId,								ModifierType)
values
	('TRAIT_CHARMING_THEATER_DISTRICT',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_APPEAL'),
	('TRAIT_BREATHTAKING_THEATER_DISTRICT',		'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_APPEAL');

insert or ignore into ModifierArguments
	(ModifierId,								Name,				Value)
values
	('TRAIT_CHARMING_THEATER_DISTRICT',			'YieldType',		'YIELD_CULTURE'),
	('TRAIT_CHARMING_THEATER_DISTRICT',			'RequiredAppeal',	2),
	('TRAIT_CHARMING_THEATER_DISTRICT',			'YieldChange',		1),
	('TRAIT_CHARMING_THEATER_DISTRICT',			'DistrictType',		'DISTRICT_THEATER'),
	('TRAIT_CHARMING_THEATER_DISTRICT',			'Description',		'LOC_DISTRICT_APPEAL_CULTURE'),
	('TRAIT_BREATHTAKING_THEATER_DISTRICT',		'YieldType',		'YIELD_CULTURE'),
	('TRAIT_BREATHTAKING_THEATER_DISTRICT',		'RequiredAppeal',	4),
	('TRAIT_BREATHTAKING_THEATER_DISTRICT',		'YieldChange',		2),
	('TRAIT_BREATHTAKING_THEATER_DISTRICT',		'DistrictType',		'DISTRICT_THEATER'),
	('TRAIT_BREATHTAKING_THEATER_DISTRICT',		'Description',		'LOC_DISTRICT_APPEAL_CULTURE');

insert or replace into Modifiers
	(ModifierId,								ModifierType,														SubjectRequirementSetId)
values
	('TRAIT_SUZERAIN_FAVOR_UNTIL_COLONIALISM',	'MODIFIER_PLAYER_ADJUST_SUZERAIN_FAVOR_MULTIPLIER',					'HD_PLAYER_HAS_NO_CIVIC_COLONIALISM_REQUIRMENTS'),
	('TRAIT_PRESERVE_VALID_FOREST',				'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS',			NULL),
	('TRAIT_PRESERVE_VALID_JUNGLE',				'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS',			NULL),
	('TRAIT_PRESERVE_VALID_MARSH',				'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS',			NULL),
	('TRAIT_PRESERVE_VALID_SWAMP',				'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS',			NULL),
	('TRAIT_PATRONAGE_DISCOUNT_FAITH_PERCENT',	'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_PATRONAGE_DISCOUNT_PERCENT',	NULL),
	('TRAIT_PATRONAGE_DISCOUNT_GOLD_PERCENT',	'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_PATRONAGE_DISCOUNT_PERCENT',	NULL);

-- 因为伟人点整体提升过2倍，但赞助价格公式未找到修改途径，故提供整体-40%折扣，神谕的25%体现为-15%，文本不变。
insert or replace into ModifierArguments
	(ModifierId,								Name,			Value)
values
	('TRAIT_SUZERAIN_FAVOR_UNTIL_COLONIALISM',	'Amount',		-100),
	('TRAIT_PRESERVE_VALID_FOREST',				'DistrictType',	'DISTRICT_PRESERVE'),
	('TRAIT_PRESERVE_VALID_FOREST',				'FeatureType',	'FEATURE_FOREST'),
	('TRAIT_PRESERVE_VALID_JUNGLE',				'DistrictType',	'DISTRICT_PRESERVE'),
	('TRAIT_PRESERVE_VALID_JUNGLE',				'FeatureType',	'FEATURE_JUNGLE'),
	('TRAIT_PRESERVE_VALID_MARSH',				'DistrictType',	'DISTRICT_PRESERVE'),
	('TRAIT_PRESERVE_VALID_MARSH',				'FeatureType',	'FEATURE_MARSH'),
--	('TRAIT_PRESERVE_VALID_SWAMP',				'DistrictType',	'DISTRICT_PRESERVE'),
--	('TRAIT_PRESERVE_VALID_SWAMP',				'FeatureType',	'FEATURE_HD_SWAMP'),
	('TRAIT_PATRONAGE_DISCOUNT_FAITH_PERCENT',	'YieldType',	'YIELD_FAITH'),
	('TRAIT_PATRONAGE_DISCOUNT_FAITH_PERCENT',	'Amount',		20),
	('TRAIT_PATRONAGE_DISCOUNT_GOLD_PERCENT',	'YieldType',	'YIELD_GOLD'),
	('TRAIT_PATRONAGE_DISCOUNT_GOLD_PERCENT',	'Amount',		20);
update ModifierArguments set Value = 20 where ModifierId = 'ORACLE_PATRONAGE_FAITH_DISCOUNT' and Name = 'Amount';
insert or replace into ModifierArguments
	(ModifierId,								Name,			Value)
select
	'TRAIT_PRESERVE_VALID_SWAMP',				'DistrictType',	'DISTRICT_PRESERVE'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');
insert or replace into ModifierArguments
	(ModifierId,								Name,			Value)
select
	'TRAIT_PRESERVE_VALID_SWAMP',				'FeatureType',	'FEATURE_HD_SWAMP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');
create table 'PopulationMaintenance'(
	'Pop' Int NOT NULL,
	'ImmortalMaintenance' TEXT NOT NULL,
	'DeityMaintenance' TEXT NOT NULL,
	PRIMARY KEY('Pop')
);

insert or replace into PopulationMaintenance
	(Pop,	ImmortalMaintenance,	DeityMaintenance)
values
	(1,		'0',					'0'),
	(2,		'0',					'0'),
	(3,		'0',					'0'),
	(4,		'0',					'0'),
	(5,		'0',					'0'),
	(6,		'0',					'-1'),
	(7,		'0',					'-1'),
	(8,		'0',					'-1'),
	(9,		'0',					'-1'),
	(10,	'0',					'-1'),
	(11,	'-1',					'-1'),
	(12,	'-1',					'-1'),
	(13,	'-1',					'-1'),
	(14,	'-1',					'-1'),
	(15,	'-1',					'-1'),
	(16,	'-1',					'-2'),
	(17,	'-1',					'-2'),
	(18,	'-1',					'-2'),
	(19,	'-1',					'-2'),
	(20,	'-1',					'-2'),
	(21,	'-2',					'-2'),
	(22,	'-2',					'-2'),
	(23,	'-2',					'-2'),
	(24,	'-2',					'-2'),
	(25,	'-2',					'-2'),
	(26,	'-2',					'-2'),
	(27,	'-2',					'-2'),
	(28,	'-2',					'-2'),
	(29,	'-2',					'-2'),
	(30,	'-2',					'-2'),
	(31,	'-2',					'-2'),
	(32,	'-2',					'-2'),
	(33,	'-2',					'-2'),
	(34,	'-2',					'-2'),
	(35,	'-2',					'-2'),
	(36,	'-2',					'-2'),
	(37,	'-2',					'-2'),
	(38,	'-2',					'-2'),
	(39,	'-2',					'-2'),
	(40,	'-2',					'-2');


insert or replace into TraitModifiers (TraitType,	ModifierId) values
	('TRAIT_LEADER_MAJOR_CIV',						'AT_LEAST_IMMORTAL_HUMAN_STARTING_GOLD'),
	('TRAIT_LEADER_MAJOR_CIV',						'AT_LEAST_IMMORTAL_HUMAN_CITY_MAINTENANCE'),
	('TRAIT_LEADER_MAJOR_CIV',						'AT_LEAST_DEITY_HUMAN_STARTING_GOLD'),
	('TRAIT_LEADER_MAJOR_CIV',						'AT_LEAST_DEITY_HUMAN_CITY_MAINTENANCE');

insert or replace into Modifiers
	(ModifierId,													ModifierType,												
	OwnerRequirementSetId,											SubjectRequirementSetId)
values
	('AT_LEAST_IMMORTAL_HUMAN_STARTING_GOLD',						'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE',
	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN_AND_HAS_CITY',		NULL),
	('AT_LEAST_IMMORTAL_HUMAN_CITY_MAINTENANCE',					'MODIFIER_PLAYER_CITIES_ADJUST_PLAYER_YIELD_CHANGE',
	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN',					NULL),
	('AT_LEAST_DEITY_HUMAN_STARTING_GOLD',							'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE',
	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN_AND_HAS_CITY',		NULL),
	('AT_LEAST_DEITY_HUMAN_CITY_MAINTENANCE',						'MODIFIER_PLAYER_CITIES_ADJUST_PLAYER_YIELD_CHANGE',
	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN',					NULL);

insert or replace into ModifierArguments
	(ModifierId,											Name,			Value)
values
	('AT_LEAST_IMMORTAL_HUMAN_STARTING_GOLD',				'YieldType',	'YIELD_GOLD'),
	('AT_LEAST_IMMORTAL_HUMAN_STARTING_GOLD',				'Amount',		1),
	('AT_LEAST_IMMORTAL_HUMAN_CITY_MAINTENANCE',			'YieldType',	'YIELD_GOLD'),
	('AT_LEAST_IMMORTAL_HUMAN_CITY_MAINTENANCE',			'Amount',		-1),
	('AT_LEAST_DEITY_HUMAN_STARTING_GOLD',					'YieldType',	'YIELD_GOLD'),
	('AT_LEAST_DEITY_HUMAN_STARTING_GOLD',					'Amount',		1),
	('AT_LEAST_DEITY_HUMAN_CITY_MAINTENANCE',				'YieldType',	'YIELD_GOLD'),
	('AT_LEAST_DEITY_HUMAN_CITY_MAINTENANCE',				'Amount',		-1);
