-------------------------------------
--                  --
-------------------------------------
--update ModifierArguments set Value = '1,0' where ModifierId = 'CLEOPATRA_FLOODPLAINS_RESOURCE_YIELD' and Name = 'Amount';



delete from TraitModifiers where ModifierId ='CLEOPATRA_FLOODPLAINS_RESOURCE_YIELD';
	--托勒密法老克利欧佩特拉，3种改良1琴
insert or replace into TraitModifiers
	(TraitType,								ModifierId)
values
	('TRAIT_LEADER_CLEOPATRA_ALT',			'THE_PTOLEMAIC_IMPROVEMENT_CULTRUE');

insert or replace into Modifiers
	(ModifierId,								ModifierType,										SubjectRequirementSetId)
values
	('THE_PTOLEMAIC_IMPROVEMENT_CULTRUE',		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',				'PLOT_HAS_IMPROVED_AND_ON_ALL_FLOODPLAINS');

insert or replace into ModifierArguments
	(ModifierId,									Name,						Value)
values

	('THE_PTOLEMAIC_IMPROVEMENT_CULTRUE',			'Amount',					1),
	('THE_PTOLEMAIC_IMPROVEMENT_CULTRUE',			'YieldType',				'YIELD_CULTURE');


--托勒密法老,惊艳水渠堤坝余粮加成
insert or replace into TraitModifiers
	(TraitType,								ModifierId)
values
	('TRAIT_LEADER_CLEOPATRA_ALT',			'THE_PTOLEMAIC_BREATHTAKING_AQUEDUCT_DISTRICT'),
	('TRAIT_LEADER_CLEOPATRA_ALT',			'THE_PTOLEMAIC_BREATHTAKING_DAM_DISTRICT'); 
insert or replace into Modifiers
	(ModifierId,										ModifierType,									RunOnce,	Permanent,	SubjectRequirementSetId)
values
	('THE_PTOLEMAIC_BREATHTAKING_AQUEDUCT_DISTRICT',	'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	0,			0,			'REQUIRES_THE_PTOLEMAIC_HAS_AQUEDUCT_ON_PLOT_BREATHTAKING'),
	('THE_PTOLEMAIC_BREATHTAKING_AQUEDUCT_GROWTH',		'MODIFIER_SINGLE_CITY_ADJUST_CITY_GROWTH',		0,			0,			null),
	('THE_PTOLEMAIC_BREATHTAKING_DAM_DISTRICT',			'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	0,			0,			'REQUIRES_THE_PTOLEMAIC_HAS_DAM_ON_PLOT_BREATHTAKING'),
	('THE_PTOLEMAIC_BREATHTAKING_DAM_GROWTH',			'MODIFIER_SINGLE_CITY_ADJUST_CITY_GROWTH',		0,			0,			null);
insert or replace into ModifierArguments 
	(ModifierId,											Name,			Value) 
values
	('THE_PTOLEMAIC_BREATHTAKING_AQUEDUCT_DISTRICT',		'ModifierId',	'THE_PTOLEMAIC_BREATHTAKING_AQUEDUCT_GROWTH'),
	('THE_PTOLEMAIC_BREATHTAKING_AQUEDUCT_DISTRICT',		'Amount',		10),
	('THE_PTOLEMAIC_BREATHTAKING_DAM_DISTRICT',				'ModifierId',	'THE_PTOLEMAIC_BREATHTAKING_DAM_GROWTH'),
	('THE_PTOLEMAIC_BREATHTAKING_DAM_DISTRICT',				'Amount',		10);

insert or ignore into RequirementSets
	(RequirementSetId,														RequirementSetType)
values
	('REQUIRES_THE_PTOLEMAIC_HAS_AQUEDUCT_ON_PLOT_BREATHTAKING',			'REQUIREMENTSET_TEST_ALL'),
	('REQUIRES_THE_PTOLEMAIC_HAS_DAM_ON_PLOT_BREATHTAKING',					'REQUIREMENTSET_TEST_ALL');   
insert or ignore into RequirementSetRequirements
	(RequirementSetId,														RequirementId)
values
	('REQUIRES_THE_PTOLEMAIC_HAS_AQUEDUCT_ON_PLOT_BREATHTAKING',			'REQUIRES_PLOT_BREATHTAKING_APPEAL'),--因为目标是区域，所以会自动判定区域是惊艳
	('REQUIRES_THE_PTOLEMAIC_HAS_AQUEDUCT_ON_PLOT_BREATHTAKING',			'REQUIRES_DISTRICT_IS_DISTRICT_AQUEDUCT'),
	('REQUIRES_THE_PTOLEMAIC_HAS_DAM_ON_PLOT_BREATHTAKING',					'REQUIRES_PLOT_BREATHTAKING_APPEAL'),--因为目标是区域，所以会自动判定区域是惊艳
	('REQUIRES_THE_PTOLEMAIC_HAS_DAM_ON_PLOT_BREATHTAKING',					'REQUIRES_DISTRICT_IS_DISTRICT_DAM');
--武马里
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_SUNDIATA_KEITA';
insert or replace into TraitModifiers
	(TraitType,							ModifierId)
values
	('TRAIT_LEADER_SUNDIATA_KEITA',		'SUNDIATA_KEITA_UNIT_CHEAPER_PURCHSE');
insert or replace into Modifiers
	(ModifierId,										ModifierType)
values
	('SUNDIATA_KEITA_UNIT_CHEAPER_PURCHSE',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER'),
	('SUNDIATA_KEITA_UNIT_CHEAPER_PURCHSE_MODIFIER',	'MODIFIER_SINGLE_CITY_ADJUST_ALL_UNITS_PURCHASE_COST');
insert or replace into ModifierArguments 
	(ModifierId,										Name,				Value) 
values
	('SUNDIATA_KEITA_UNIT_CHEAPER_PURCHSE',				'ModifierId',		'SUNDIATA_KEITA_UNIT_CHEAPER_PURCHSE_MODIFIER'),
	('SUNDIATA_KEITA_UNIT_CHEAPER_PURCHSE_MODIFIER',	'Amount',			15),
	('SUNDIATA_KEITA_UNIT_CHEAPER_PURCHSE_MODIFIER',	'IncludeCivilian',	1);




--拉美西斯二世 陆地单位穿越河流时没有移动惩罚，战斗时无视河流阻碍。

insert or replace into TraitModifiers
    (TraitType,                            		ModifierId)
values
    ('TRAIT_LEADER_RAMSES',                    	'RAMSES_RIVER_PATROL');

insert or replace into Modifiers
    (ModifierId,                                ModifierType,                     Permanent,      SubjectRequirementSetId)
values

    ('RAMSES_RIVER_PATROL',                     'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',    1,      NULL);

insert or replace into ModifierArguments
    (ModifierId,                                Name,               Value)
values
    ('RAMSES_RIVER_PATROL',                     'AbilityType',      'ABILITY_RAMSES_RIVER_PATROL');

insert or ignore into UnitAbilityModifiers
    (UnitAbilityType,                           ModifierId)
values
    ('ABILITY_RAMSES_RIVER_PATROL',             'RAMSES_RIVER_PATROL_IGNORE');



insert or replace into Types
    (Type,                                      Kind)
values
    ('ABILITY_RAMSES_RIVER_PATROL',             'KIND_ABILITY');     


insert or replace into TypeTags
    (Type,                                      Tag)
values
    ('ABILITY_RAMSES_RIVER_PATROL',             'CLASS_LAND_UNITS');
   
insert or replace into UnitAbilities
    (UnitAbilityType,                        	Name,               		  Description,                 	   Inactive,Permanent)
values
    ('ABILITY_RAMSES_RIVER_PATROL', 'LOC_ABILITY_RAMSES_RIVER_PATROL_NAME',  'LOC_ABILITY_RAMSES_RIVER_PATROL_DESCRIPTION', 1,  1);


insert or replace into Modifiers
    (ModifierId,                                ModifierType,                 Permanent)
values
    ('RAMSES_RIVER_PATROL_IGNORE',              'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_RIVERS',        1);
insert or replace into ModifierArguments
    (ModifierId,                                Name,       Value)
values
    ('RAMSES_RIVER_PATROL_IGNORE',              'Ignore',   1);

-- 文化传播单位
-- insert or ignore into UnitAbilityModifiers
--     (UnitAbilityType,                           	ModifierId)
-- values
--     ('ABILITY_ORAL_SCHOLAR_BOMB_ALL_HD',         	'RAMSES_ROCK_IGNORE_RIVERS'),
-- 	('ABILITY_TRAVEL_THEATRE_BOMB_ALL_HD',         	'RAMSES_ROCK_IGNORE_RIVERS'),
-- 	('ABILITY_ROCK_BAND_BOMB_ALL_HD',         		'RAMSES_ROCK_IGNORE_RIVERS');
-- insert or replace into Modifiers
--     (ModifierId,                                ModifierType,                 						Permanent, 	SubjectRequirementSetId)
-- values
--     ('RAMSES_ROCK_IGNORE_RIVERS',              'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_RIVERS',        1, 			'HD_PLAYER_IS_LEADER_RAMSES_REQUIREMENTS');
-- insert or replace into ModifierArguments
--     (ModifierId,                                Name,       Value)
-- values
--     ('RAMSES_ROCK_IGNORE_RIVERS',              'Ignore',   1);

--弯刀战士给拉二
insert or replace into LeaderTraits (LeaderType,    TraitType) select
    'LEADER_RAMSES',                               	'TRAIT_CIVILIZATION_UNIT_EGYPTIAN_KHOPESH'
where exists (select UnitType from Units where UnitType = 'UNIT_EGYPTIAN_KHOPESH');

