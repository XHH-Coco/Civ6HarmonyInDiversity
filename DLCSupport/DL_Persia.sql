-------------------------------------
--            Persia DLC           --
-------------------------------------

-- Apadana
delete from BuildingModifiers where ModifierId = 'APADANA_AWARD_TWO_INFLUENCE_TOKEN';
insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
values
	('BUILDING_APADANA',					'APADANA_AWARD_ONE_INFLUENCE_TOKEN');

insert or replace into Modifiers
	(ModifierId,									ModifierType,												SubjectRequirementSetId)
values
	('APADANA_AWARD_ONE_INFLUENCE_TOKEN',       	'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',				'PLOT_HAS_COMPLETE_WONDER'),
	('APADANA_AWARD_ONE_INFLUENCE_TOKEN_MODIFIER',	'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN',					NULL);

insert or replace into ModifierArguments
	(ModifierId,										Name,			Value)
values
	('APADANA_AWARD_ONE_INFLUENCE_TOKEN',				'ModifierId',	'APADANA_AWARD_ONE_INFLUENCE_TOKEN_MODIFIER'),
	('APADANA_AWARD_ONE_INFLUENCE_TOKEN_MODIFIER',		'Amount',		1);

insert or replace into Building_CitizenYieldChanges
    (BuildingType,                          YieldType,          YieldChange)
values
    ('BUILDING_BASILIKOI_PAIDES',           'YIELD_PRODUCTION', 1), -- ub
    ('BUILDING_BASILIKOI_PAIDES',           'YIELD_GOLD',       -1); -- ub

insert or replace into BuildingModifiers
    (BuildingType,                  ModifierId)
values
    -- ('BUILDING_BASILIKOI_PAIDES',    'BARRACKS_ADD_COPPER_PRODUCTION'), --ub
    ('BUILDING_BASILIKOI_PAIDES',   'BARRACKS_ADD_IRON_PRODUCTION'), --ub
    ('BUILDING_BASILIKOI_PAIDES',   'BASILIKOI_TRAINED_STRENGTH_MODIFIER'); --ub
    -- ('BUILDING_BASILIKOI_PAIDES', 'BASILIKOI_PAIDES_INCREASED_MOVEMENT_MODIFIER'),

-- Ability from Basilikoi
insert or replace into TypeTags
    (Type,                                                              Tag)
values
    ('ABILITY_BASILIKOI_TRAINED_UNIT_STRENGTH',                         'CLASS_MELEE'),
    ('ABILITY_BASILIKOI_TRAINED_UNIT_STRENGTH',                         'CLASS_RANGED'),
    ('ABILITY_BASILIKOI_TRAINED_UNIT_STRENGTH',                         'CLASS_ANTI_CAVALRY'),
    ('ABILITY_BASILIKOI_TRAINED_UNIT_STRENGTH',                         'CLASS_SIEGE'),
    ('ABILITY_BASILIKOI_TRAINED_UNIT_STRENGTH',                         'CLASS_HETAIROI');

-----------------------------------------------------------------------------------------------------------------------
--Persia
--波斯LA从占领城市驻军+5忠诚变成全部城市驻军+5忠诚
--长生军变成28远程，33近战 (在DL_Units里面修改)
--波斯庭院相邻港口+1金，相邻市中心除了1金外额外+1粮
--波斯UA内商+1琴改为+2琴
--波斯、马其顿、罗马、刚果、日本、格鲁吉亚、挪威增加铁关联（4级关联，在DL_StartBias里面修改）
--城市中建造的首座波斯庭院改良设施可以提供+1点宜居度
insert or replace into Improvement_YieldChanges
	(ImprovementType,				YieldType,		YieldChange)
values
	('IMPROVEMENT_PAIRIDAEZA',		'YIELD_FOOD',	0);
update Adjacency_YieldChanges set YieldType = 'YIELD_FOOD' where ID = 'Pairidaeza_CityCenterAdjacency';
update Adjacency_YieldChanges set YieldChange = 2 where ID = 'Pairidaeza_CommercialHubAdjacency';
update Improvements set Appeal = 2 where ImprovementType = 'IMPROVEMENT_PAIRIDAEZA';
insert or replace into ImprovementModifiers
	(ImprovementType,				ModifierId)
values
	('IMPROVEMENT_PAIRIDAEZA',		'PAIRIDAEZA_GOVERNMENT_CULTURE'),
	('IMPROVEMENT_PAIRIDAEZA',		'PAIRIDAEZA_GOVERNMENT_TIER_1_CULTURE'),
	('IMPROVEMENT_PAIRIDAEZA',		'PAIRIDAEZA_GOVERNMENT_TIER_2_CULTURE'),
	('IMPROVEMENT_PAIRIDAEZA',		'PAIRIDAEZA_GOVERNMENT_TIER_3_CULTURE');
insert or replace into Modifiers
	(ModifierId,								ModifierType,								SubjectRequirementSetId)
values
	('PAIRIDAEZA_GOVERNMENT_CULTURE',			'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PLAYER_HAS_DISTRICT_GOVERNMENT_REQUIREMENTS'),
	('PAIRIDAEZA_GOVERNMENT_TIER_1_CULTURE',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PLAYER_HAS_DISTRICT_GOVERNMENT_TIER_1_BUILDING_REQUIREMENTS'),
	('PAIRIDAEZA_GOVERNMENT_TIER_2_CULTURE',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PLAYER_HAS_DISTRICT_GOVERNMENT_TIER_2_BUILDING_REQUIREMENTS'),
	('PAIRIDAEZA_GOVERNMENT_TIER_3_CULTURE',	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PLAYER_HAS_DISTRICT_GOVERNMENT_TIER_3_BUILDING_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,								Name,			Value)
values
	('PAIRIDAEZA_GOVERNMENT_CULTURE',			'YieldType',	'YIELD_CULTURE'),
	('PAIRIDAEZA_GOVERNMENT_CULTURE',			'Amount',		1),
	('PAIRIDAEZA_GOVERNMENT_TIER_1_CULTURE',	'YieldType',	'YIELD_CULTURE'),
	('PAIRIDAEZA_GOVERNMENT_TIER_1_CULTURE',	'Amount',		1),
	('PAIRIDAEZA_GOVERNMENT_TIER_2_CULTURE',	'YieldType',	'YIELD_CULTURE'),
	('PAIRIDAEZA_GOVERNMENT_TIER_2_CULTURE',	'Amount',		1),
	('PAIRIDAEZA_GOVERNMENT_TIER_3_CULTURE',	'YieldType',	'YIELD_CULTURE'),
	('PAIRIDAEZA_GOVERNMENT_TIER_3_CULTURE',	'Amount',		1);
/*insert or replace into ImprovementModifiers
    (ImprovementType,                           ModifierId)
values
    ('IMPROVEMENT_PAIRIDAEZA',                  'PAIRIDAEZA_AMENITY_MAX_ONE');

insert or ignore into Modifiers
        (ModifierId,                                    ModifierType,                                           SubjectStackLimit)
values
        ('PAIRIDAEZA_AMENITY_MAX_ONE',                  'MODIFIER_CITY_OWNER_ADJUST_IMPROVEMENT_AMENITY',       1);

insert or ignore into ModifierArguments
        (ModifierId,                                     Name,                Value)
values
        ('PAIRIDAEZA_AMENITY_MAX_ONE',                  'Amount',             1);*/

insert or replace into ModifierArguments 
    (ModifierId,                                Name,               Value) 
values
    ('TRAIT_SATRAPIES_INTERNAL_TRADE_CULTURE',  'Amount',           2);

INSERT OR REPLACE INTO TraitModifiers (TraitType, ModifierId) VALUES 
('TRAIT_CIVILIZATION_SATRAPIES', 'PERSIA_GOVERNOR_POINTS'),
('TRAIT_CIVILIZATION_SATRAPIES', 'HD_PERSIA_SET_PROPERTY');

INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES 
('PERSIA_GOVERNOR_POINTS', 'MODIFIER_PLAYER_ADJUST_GOVERNOR_POINTS', 'PLAYER_HAS_POLITICAL_PHILOSOPHY'),
('HD_PERSIA_SET_PROPERTY', 'MODIFIER_PLAYER_ADJUST_PROPERTY', NULL);

INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('PERSIA_GOVERNOR_POINTS', 'Delta', '1'),
('HD_PERSIA_SET_PROPERTY', 'Key', 	'HD_ROUTE_EXTRA_LEVEL'),
('HD_PERSIA_SET_PROPERTY', 'Amount', 1);


update Modifiers set ModifierType = 'MODIFIER_PLAYER_CITIES_ADJUST_IDENTITY_PER_TURN' where ModifierId = 'TRAIT_ADDITIONAL_MARTIAL_LAW';
update Modifiers set SubjectRequirementSetId = 'CITY_HAS_GARRISON_UNIT_REQUIERMENT' where ModifierId = 'TRAIT_ADDITIONAL_MARTIAL_LAW';

--马其顿UA
--城市不会产生厌战情绪。此玩家占领拥有世界奇观的城市或建成世界奇观时，目前所有单位获得15点经验值。占领城市时，为所有城市正在建造的奇观推进10%的建造进程。
delete from TraitModifiers where ModifierId = 'TRAIT_TOWORLDSEND_HEAL_ON_WONDER_CAPTURE';
insert or replace into TraitModifiers
	(TraitType,												ModifierId)
values
	('TRAIT_LEADER_TO_WORLDS_END',							'TRAIT_TOWORLDSEND_EXPERIENCE_ON_WONDER_CAPTURE');

insert or replace into Modifiers
	(ModifierId,													ModifierType,										RunOnce,	Permanent,		SubjectRequirementSetId)
values
	('TRAIT_TOWORLDSEND_EXPERIENCE_ON_WONDER_CAPTURE',				'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',		0,			0,				'PLOT_HAS_COMPLETE_WONDER'),
	('TRAIT_TOWORLDSEND_EXPERIENCE_ON_WONDER_CAPTURE_MODIFIER',		'MODIFIER_PLAYER_UNITS_ADJUST_GRANT_EXPERIENCE',	1,			1,				NULL);

insert or replace into ModifierArguments
	(ModifierId,													Name,							Value)
values
	('TRAIT_TOWORLDSEND_EXPERIENCE_ON_WONDER_CAPTURE',				'ModifierId',					'TRAIT_TOWORLDSEND_EXPERIENCE_ON_WONDER_CAPTURE_MODIFIER'),
	('TRAIT_TOWORLDSEND_EXPERIENCE_ON_WONDER_CAPTURE_MODIFIER',		'Amount',						15);