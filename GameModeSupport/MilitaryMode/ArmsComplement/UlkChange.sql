update Boosts set NumItems=2 where BoostID=68;
update Boosts set Unit1Type='UNIT_COMPOSITE_BOWMAN' where BoostID=68;

insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) select UnitType, 'UNIT_ARMOR_CAVALRY'
from Units where UnitType = 'UNIT_NUBIAN_AFRICAN_FOREST_ELEPHANT' or UnitType = 'UNIT_PERSIAN_CATAPHRACT' 
or UnitType = 'UNIT_GEDEMO_PALADIN' or UnitType = 'UNIT_GEDEMO_GPALADIN' or UnitType = 'UNIT_MACEDONIAN_HETAIROI';

delete from UnitReplaces where CivUniqueUnitType='UNIT_ARABIAN_CAMEL_ARCHER';
delete from UnitReplaces where CivUniqueUnitType='UNIT_MONGOLIAN_KESHIG';
delete from UnitReplaces where CivUniqueUnitType='UNIT_VIETNAMESE_VOI_CHIEN';
update UnitReplaces set ReplacesUnitType='UNIT_HALBERDMAN' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_ASSYRIA_KISIR_SARRUTI');
update UnitReplaces set ReplacesUnitType='UNIT_SPEC_OPS' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_AUSTRALIAN_SASR');
update UnitReplaces set ReplacesUnitType='UNIT_ARCHER' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_BABYLONIAN_BOWMAN');
update UnitReplaces set ReplacesUnitType='UNIT_COMPOSITE_BOWMAN' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_ENGLISH_LONGBOWMAN');
update UnitReplaces set ReplacesUnitType='UNIT_COMPOSITE_BOWMAN' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_GREEK_PELTAST');
update UnitReplaces set ReplacesUnitType='UNIT_HALBERDMAN' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_MACEDONIAN_PEZHETAIROS');
--update UnitReplaces set ReplacesUnitType='UNIT_ARMOR_CAVALRY' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_NUBIAN_AFRICAN_FOREST_ELEPHANT');
--update UnitReplaces set ReplacesUnitType='UNIT_ARMOR_CAVALRY' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_PERSIAN_CATAPHRACT');
update UnitReplaces set ReplacesUnitType='UNIT_ARMOR_CAVALRY' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_SCYTHIAN_AMAZON');
update UnitReplaces set ReplacesUnitType='UNIT_COMPOSITE_BOWMAN' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_ZULU_ASSEGAI');
--update UnitReplaces set ReplacesUnitType='UNIT_ARMOR_CAVALRY' where CivUniqueUnitType=(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_MACEDONIAN_HETAIROI');

--重骑兵晋升
update UnitUpgrades set UpgradeUnit='UNIT_REITER' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_SCYTHIAN_AMAZON');
update UnitUpgrades set UpgradeUnit='UNIT_REITER' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_INDIAN_VARU');
update UnitUpgrades set UpgradeUnit='UNIT_REITER' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_GEDEMO_PALADIN');
update UnitUpgrades set UpgradeUnit='UNIT_REITER' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_GEDEMO_GPALADIN');
update UnitUpgrades set UpgradeUnit='UNIT_REITER' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_MACEDONIAN_HETAIROI');
update UnitUpgrades set UpgradeUnit='UNIT_REITER' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_PERSIAN_CATAPHRACT');
update UnitUpgrades set UpgradeUnit='UNIT_REITER' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_NUBIAN_AFRICAN_FOREST_ELEPHANT');
--update UnitUpgrades set UpgradeUnit='UNIT_ARMOR_CAVALRY' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_AUSTRALIAN_SASR');
--轻骑兵晋升
update UnitUpgrades set UpgradeUnit='UNIT_LANCER' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_PHOENICIA_NUMIDIAN_CAVALRY');
update UnitUpgrades set UpgradeUnit='UNIT_LANCER' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_CVS_MASINISSA_UU');
--陆地远程晋升
update UnitUpgrades set UpgradeUnit='UNIT_COMPOSITE_BOWMAN' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_BABYLONIAN_BOWMAN');
update UnitUpgrades set UpgradeUnit='UNIT_CANNON' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_ENGLISH_LONGBOWMAN');
update UnitUpgrades set UpgradeUnit='UNIT_CANNON' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_GREEK_PELTAST');
update UnitUpgrades set UpgradeUnit='UNIT_CANNON' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_ZULU_ASSEGAI');
update UnitUpgrades set UpgradeUnit='UNIT_FIELD_CANNON' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_ARABIAN_CAMEL_ARCHER');
--抗骑兵晋升
update UnitUpgrades set UpgradeUnit='UNIT_PIKE_AND_SHOT' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_MACEDONIAN_PEZHETAIROS');
update UnitUpgrades set UpgradeUnit='UNIT_PIKE_AND_SHOT' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_GREEK_HOPLITE');
update UnitUpgrades set UpgradeUnit='UNIT_ARRAY_INFANTRY' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_GERMAN_LANDSKNECHT');
update UnitUpgrades set UpgradeUnit='UNIT_ARRAY_INFANTRY' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_CVS_BERBER_UU');
--攻城单位晋升
update UnitUpgrades set UpgradeUnit='UNIT_BOMBARD' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_ROMAN_ONAGER');
update UnitUpgrades set UpgradeUnit='UNIT_MORTER_NEW' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_KHMER_DOMREY');
update UnitUpgrades set UpgradeUnit='UNIT_MORTER_NEW' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_MONGOLIAN_HUI_HUI_PAO');

update TypeTags set Tag='CLASS_RECON' where Type='UNIT_AUSTRALIAN_SASR' and Tag='CLASS_MELEE';

--insert into UnitReplaces(CivUniqueUnitType,ReplacesUnitType)values(select CivUniqueUnitType from UnitReplaces where CivUniqueUnitType='UNIT_ENGLISH_LONGBOWMAN','UNIT_CROSSBOWMAN');

--马铁纯享
--update Buildings set PrereqTech=null where BuildingType=(select BuildingType from Buildings where BuildingType='BUILDING_JNR_WAYSTATION');
--update Buildings set PrereqCivic='CIVIC_FOREIGN_TRADE' where BuildingType=(select BuildingType from Buildings where BuildingType='BUILDING_JNR_WAYSTATION');
	
--允许打蛮子升到3级（3级以后最多获得1经验，之前是2级）
update GlobalParameters set Value = 4 where Name = 'EXPERIENCE_MAX_BARB_LEVEL';

--掠夺移动力消耗
update GlobalParameters set Value = 2 where Name = 'PILLAGE_MOVEMENT_COST';

--击杀获得海军/大军点数
insert or replace into UnitAbilities
    (UnitAbilityType,                                       Name,                                                           Description)
values
    ('ABILITY_ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD',       'LOC_ABILITY_ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD_NAME',       'LOC_ABILITY_ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD_DESCRIPTION'),
    ('ABILITY_ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD',      'LOC_ABILITY_ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD_NAME',      'LOC_ABILITY_ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD_DESCRIPTION');

insert or replace into Types
	(Type,											        Kind)
values
    ('ABILITY_ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD',       'KIND_ABILITY'),
    ('ABILITY_ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD',      'KIND_ABILITY');

insert or replace into TypeTags
    (Type,                                                  Tag)
values
    ('ABILITY_ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD',       'CLASS_MILITARY'),

    ('ABILITY_ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD',      'CLASS_NAVAL_RANGED'),
    ('ABILITY_ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD',      'CLASS_NAVAL_RAIDER'),
    ('ABILITY_ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD',      'CLASS_NAVAL_MELEE');

insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                                       ModifierId)
values
    ('ABILITY_ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD',       'ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD'),
    ('ABILITY_ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD',      'ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD');

insert or replace into Modifiers
    (ModifierId,                                            ModifierType,                                                                               SubjectRequirementSetId)
values
    ('ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD',               'MODIFIER_PLAYER_ADJUST_UNITS_GREAT_PEOPLE_POINTS_PER_KILL_BY_DEFEATED_STRENGTH',           'HD_UNIT_IS_NOT_BARBARIAN_REQUIREMENTS'),
    ('ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD',              'MODIFIER_PLAYER_ADJUST_UNITS_GREAT_PEOPLE_POINTS_PER_KILL_BY_DEFEATED_STRENGTH',           'HD_UNIT_IS_NOT_BARBARIAN_REQUIREMENTS');

insert or replace into ModifierArguments
    (ModifierId,                                            Name,                       Value)
values
    ('ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD',               'GreatPersonClassType',     'GREAT_PERSON_CLASS_GENERAL'),
    ('ALL_LAND_UNITS_GREAT_PEOPLE_POINTS_HD',               'Amount',                   25),
    ('ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD',              'GreatPersonClassType',     'GREAT_PERSON_CLASS_ADMIRAL'),
    ('ALL_NAVAL_UNITS_GREAT_PEOPLE_POINTS_HD',              'Amount',                   25);

--UU特效
update Units set BuildCharges=2 where UnitType=(select UnitType from Units where UnitType='UNIT_POLISH_CHOSEN_INFANTRY');--封邑步兵加2劳动力

insert or replace into Improvement_ValidBuildUnits
    (ImprovementType,                   UnitType)
select
    'IMPROVEMENT_FORT',                 UnitType
from Units where UnitType in
    ('UNIT_POLISH_CHOSEN_INFANTRY');--封邑步兵可修建堡垒


insert or replace into Modifiers
    (ModifierId,                                            ModifierType)
values
    ('PERC_50_POST_COMBAT_CULTRAL',                         'MODIFIER_UNIT_ADJUST_POST_COMBAT_YIELD');

insert or replace into Modifiers
    (ModifierId,                                            ModifierType,                                                                               SubjectRequirementSetId)
values
    ('CHINESE_CROUCHING_TIGER_VS_WOUNDED_UNITS_HD',         'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                                                     'REQUIREMENTS_OPPONENT_IS_WOUNDED');

-- With Modifiers_Pre
--     (ModifierId,											ModifierType,																				PreSubjectRequirementSetId)
-- as (values
-- 	('POLISH_CHOSEN_INFANTRY_ATTACK_DISTRICT_STRENGTH_HD',	'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',														'OPPONENT_IS_DISTRICT_REQUIREMENTS'))
-- insert or replace into Modifiers
--     (ModifierId,                                           	ModifierType,																				SubjectRequirementSetId)
-- select
--     Modifiers_Pre.ModifierId,    							Modifiers_Pre.ModifierType,																	Modifiers_Pre.PreSubjectRequirementSetId
-- from Modifiers_Pre INNER JOIN RequirementSets ON RequirementSets.RequirementSetId = Modifiers_Pre.PreSubjectRequirementSetId;

insert or replace into Modifiers
    (ModifierId,                                            ModifierType,                                                                               OwnerRequirementSetId)
values
    ('ENGLISH_LONGBOWMAN_TECH_MACHINERY_STRENGTH_HD',       'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                                                     'PLAYER_HAS_TECH_MACHINERY_REQUIREMENTS');

insert or replace into ModifierArguments
    (ModifierId,                                            Name,                       Value)
values
    ('CHINESE_CROUCHING_TIGER_VS_WOUNDED_UNITS_HD',         'Amount',                   5),--虎蹲炮攻击受伤单位时额外+5力
    ('ENGLISH_LONGBOWMAN_TECH_MACHINERY_STRENGTH_HD',       'Amount',                   10),--长弓手解锁机械科技后+10力
    ('GARDE_CONTINENT_COMBAT',                              'Amount',                   5),--帝国卫队在您首都大陆作战时，+10改为+5力
    -- ('POLISH_CHOSEN_INFANTRY_ATTACK_DISTRICT_STRENGTH_HD',  'Amount',                   5),--封邑步兵攻击区域防御时+5力
    ('PERC_50_POST_COMBAT_CULTRAL',                         'PercentDefeatedStrength',  50),
    ('PERC_50_POST_COMBAT_CULTRAL',                         'YieldType',                'YIELD_CULTURAL');--黑曜石矛手击败敌军单位即获得其自身50% [ICON_STRENGTH] 战斗力的 [ICON_GOLD] 金币。
update ModifierArguments set Value=5 where ModifierId='PELTAST_NEIGHBOR_COMBAT_HD_MODIFIER' and Name='Amount';--轻盾步兵相邻另一个轻盾兵时+10改为+5力


insert or replace into UnitAbilities
    (UnitAbilityType,                                       Name,                                                           Description)
values
    ('ABILITY_CHINESE_CROUCHING_TIGER_HD',                  'LOC_ABILITY_CHINESE_CROUCHING_TIGER_HD_NAME',                  'LOC_ABILITY_CHINESE_CROUCHING_TIGER_HD_DESCRIPTION'),
    ('ABILITY_ENGLISH_LONGBOWMAN_HD',                       'LOC_ABILITY_ENGLISH_LONGBOWMAN_HD_NAME',                       'LOC_ABILITY_ENGLISH_LONGBOWMAN_HD_DESCRIPTION'),
    ('ABILITY_PERC_50_POST_COMBAT_CULTURAL_HD',             'LOC_ABILITY_PERC_50_POST_COMBAT_CULTURAL_HD_NAME',             'LOC_ABILITY_PERC_50_POST_COMBAT_CULTURAL_HD_DESCRIPTION');

insert or replace into Types
	(Type,											        Kind)
values
    ('ABILITY_CHINESE_CROUCHING_TIGER_HD',                  'KIND_ABILITY'),
    ('ABILITY_ENGLISH_LONGBOWMAN_HD',                  		'KIND_ABILITY'),
    ('ABILITY_PERC_50_POST_COMBAT_CULTURAL_HD',             'KIND_ABILITY');

insert or replace into Tags
	(Tag,					                                Vocabulary)
values
    ('CLASS_CHINESE_CROUCHING_TIGER_HD',                    'ABILITY_CLASS');

With TypeTags_Pre
    (Type,PreTag)
as (values
	('ABILITY_ENGLISH_LONGBOWMAN_HD',	                    'CLASS_ENGLISH_LONGBOWMAN'),
	('ABILITY_PERC_50_POST_COMBAT_CULTURAL_HD',	            'CLASS_MAYAN_HOLKAN'))
insert or replace into TypeTags
    (Type,                                                  Tag)
select
    TypeTags_Pre.Type,                                      TypeTags_Pre.PreTag
from TypeTags_Pre INNER JOIN TypeTags ON TypeTags.Type = TypeTags_Pre.PreTag;

insert or replace into TypeTags
	(Type,					                                Tag)
values
	('UNIT_CHINESE_CROUCHING_TIGER',	                    'CLASS_CHINESE_CROUCHING_TIGER_HD'),
	('ABILITY_CHINESE_CROUCHING_TIGER_HD',	                'CLASS_CHINESE_CROUCHING_TIGER_HD');

insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                                       ModifierId)
values
    ('ABILITY_CHINESE_CROUCHING_TIGER_HD',                  'CHINESE_CROUCHING_TIGER_VS_WOUNDED_UNITS_HD'),
    ('ABILITY_ENGLISH_LONGBOWMAN_HD',                       'ENGLISH_LONGBOWMAN_TECH_MACHINERY_STRENGTH_HD'),
    -- ('ABILITY_CHOSEN_INFANTRY',                             'POLISH_CHOSEN_INFANTRY_ATTACK_DISTRICT_STRENGTH_HD'),
    ('ABILITY_PERC_50_POST_COMBAT_CULTURAL_HD',             'PERC_50_POST_COMBAT_CULTRAL');

-- update UnitAbilityModifiers set ModifierId='POLISH_CHOSEN_INFANTRY_ATTACK_DISTRICT_STRENGTH_HD' where  UnitAbilityType='ABILITY_CHOSEN_INFANTRY' and ModifierId='PLUS_10_HEAL_PER_TURN_BONUS';--封邑步兵删除驻防的生命值回复额外+10
delete from UnitAbilityModifiers where UnitAbilityType='ABILITY_MAPUCHE_MALON_RAIDER' and ModifierId='MALON_RAIDER_LESS_MOVEMENT_PILLAGE';--突袭骑兵删除可消耗1点移动力进行掠夺