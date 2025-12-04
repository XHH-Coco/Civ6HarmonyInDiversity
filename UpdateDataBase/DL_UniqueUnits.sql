-------------------------------------
--     Unique Units Adjustments    --
-------------------------------------
--巴西uu米舰改到殖民主义，翼骑兵移到归正会
--土鸡巴巴里移到罗盘
update Units set PrereqCivic = NULL, PrereqTech = 'TECH_SQUARE_SAIL_HD' where UnitType = 'UNIT_OTTOMAN_BARBARY_CORSAIR';
update Units set PrereqCivic = null, PrereqTech = 'TECH_STEAM_POWER' where UnitType = 'UNIT_BRAZILIAN_MINAS_GERAES'; 
update Units set PrereqCivic = 'CIVIC_REFORMED_CHURCH' where UnitType = 'UNIT_POLISH_HUSSAR'; 

-- UU
-- 美国
update Units set Cost = 260, Maintenance = 4, BaseMoves = 5, Range = 0, Combat = 76, RangedCombat = 0 where UnitType = 'UNIT_AMERICAN_ROUGH_RIDER';
------ UNIT_AMERICAN_P51
------ UNIT_AMERICAN_MINUTEMAN
-- 阿拉伯
update Units set Cost = 130, Maintenance = 3, BaseMoves = 4, Range = 0, Combat = 56, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_ARABIAN_MAMLUK';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ARABIAN_MAMLUK';
------ UNIT_ARABIAN_CAMEL_ARCHER
------ UNIT_ARABIAN_GHAZI
-- 德国
update Units set Cost = 410, Maintenance = 6, BaseMoves = 5, Range = 2, Combat = 65, RangedCombat = 75 where UnitType = 'UNIT_GERMAN_UBOAT';
------ UNIT_GERMAN_LANDSKNECHT
------ UNIT_GERMAN_PANZER
-- 希腊
update Units set Cost = 45, Maintenance = 1, BaseMoves = 2, Range = 0, Combat = 25, RangedCombat = 0 where UnitType = 'UNIT_GREEK_HOPLITE';
------ UNIT_GREEK_PELTAST
-- 苏美尔
update Units set Cost = 25, Maintenance = 0, BaseMoves = 2, Range = 0, Combat = 28, RangedCombat = 0 where UnitType = 'UNIT_SUMERIAN_WAR_CART';
------ UNIT_SUMERIAN_PHALANXF
-- 埃及
update Units set Cost = 60, Maintenance = 1, BaseMoves = 2, Range = 2, Combat = 25, RangedCombat = 35 where UnitType = 'UNIT_EGYPTIAN_CHARIOT_ARCHER';
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) select 'UNIT_EGYPTIAN_CHARIOT_ARCHER', 'UNIT_COMPOSITE_BOWMAN'
    where exists (select UnitType from Units where UnitType = 'UNIT_COMPOSITE_BOWMAN');
------ UNIT_EGYPTIAN_KHOPESH
-- 中国
update Units set Cost = 150, Maintenance = 4, BaseMoves = 2, Range = 2, Combat = 45, RangedCombat = 60, PrereqTech = 'TECH_GUNPOWDER' where UnitType = 'UNIT_CHINESE_CROUCHING_TIGER';
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) values ('UNIT_CHINESE_CROUCHING_TIGER', 'UNIT_FIELD_CANNON');
update UnitUpgrades set UpgradeUnit = 'UNIT_MACHINE_GUN' where Unit = 'UNIT_CHINESE_CROUCHING_TIGER';
update UnitUpgrades set UpgradeUnit = 'UNIT_DLV_MORTAR' where Unit = 'UNIT_CHINESE_CROUCHING_TIGER'
    and exists (select UnitType from Units where UnitType = 'UNIT_DLV_MORTAR');
update UnitUpgrades set UpgradeUnit = 'UNIT_FIELD_GUN' where Unit = 'UNIT_CHINESE_CROUCHING_TIGER'
    and exists (select UnitType from Units where UnitType = 'UNIT_FIELD_GUN');
------ UNIT_CHINESE_CHOKONU
-- 西班牙
update Units set Cost = 150, Maintenance = 4, BaseMoves = 2, Range = 0, Combat = 58, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_SPANISH_CONQUISTADOR';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_SPANISH_CONQUISTADOR';
update UnitUpgrades set UpgradeUnit = 'UNIT_INFANTRY' where Unit = 'UNIT_SPANISH_CONQUISTADOR';
------ UNIT_SPANISH_TERCIO
-- 罗马
update Units set Cost = 70, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 40, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_ROMAN_LEGION';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ROMAN_LEGION';
------ UNIT_ROMAN_ONAGER
-- 俄罗斯
update Units set Cost = 210, Maintenance = 5, BaseMoves = 5, Range = 0, Combat = 67, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_RUSSIAN_COSSACK';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_RUSSIAN_COSSACK';
------ UNIT_RUSSIAN_DRUZHINA
-- 挪威
update Units set Cost = 55, Maintenance = 1, BaseMoves = 3, Range = 0, Combat = 35, RangedCombat = 0, StrategicResource = NULL, PrereqTech = 'TECH_SHIPBUILDING' where UnitType = 'UNIT_NORWEGIAN_LONGSHIP';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_NORWEGIAN_LONGSHIP';
insert or replace into TypeTags (Type, Tag) values ('ABILITY_LONGSHIP_COASTAL_RAID', 'CLASS_LONGSHIP');
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 48, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_NORWEGIAN_BERSERKER';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_NORWEGIAN_BERSERKER';
------ UNIT_NORWEGIAN_ULFHEDNAR
-- 印度
update Units set Cost = 100, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 40, RangedCombat = 0 where UnitType = 'UNIT_INDIAN_VARU';
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) select 'UNIT_INDIAN_VARU', 'UNIT_ARMORED_HORSEMAN'
    where exists (select UnitType from Units where UnitType = 'UNIT_ARMORED_HORSEMAN');
update UnitUpgrades set UpgradeUnit = 'UNIT_REITER' where Unit = 'UNIT_INDIAN_VARU'
    and exists (select UnitType from Units where UnitType = 'UNIT_REITER');
------ UNIT_INDIAN_SEPOY
-- 英国
update Units set Cost = 180, Maintenance = 4, BaseMoves = 4, Range = 2, Combat = 45, RangedCombat = 55, StrategicResource = NULL where UnitType = 'UNIT_ENGLISH_SEADOG';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_ENGLISH_SEADOG';
update Units set Cost = 210, Maintenance = 5, BaseMoves = 2, Range = 0, Combat = 70, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_ENGLISH_REDCOAT';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ENGLISH_REDCOAT';
update UnitUpgrades set UpgradeUnit = 'UNIT_INFANTRY' where Unit = 'UNIT_ENGLISH_REDCOAT' and exists (select UnitType from Units where UnitType = 'UNIT_WW1_INFANTRY');
------ UNIT_ENGLISH_LONGBOWMAN
------ UNIT_ENGLISH_SHIP_OF_THE_LINE
-- 日本
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 48, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_JAPANESE_SAMURAI';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_JAPANESE_SAMURAI';
------ UNIT_JAPANESE_SOHEI
-- 斯基泰
update Units set Cost = 60, Maintenance = 2, BaseMoves = 4, Range = 2, Combat = 15, RangedCombat = 25 where UnitType = 'UNIT_SCYTHIAN_HORSE_ARCHER';
insert or replace into TypeTags (Type, Tag) values ('UNIT_SCYTHIAN_HORSE_ARCHER', 'CLASS_HD_CAN_MOVE_AFTER_ATTACK');
------ UNIT_SCYTHIAN_AMAZON
-- 巴西
update Units set Cost = 500, Maintenance = 6, BaseMoves = 5, Range = 3, Combat = 80, RangedCombat = 90, StrategicResource = 'RESOURCE_COAL' where UnitType = 'UNIT_BRAZILIAN_MINAS_GERAES';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_COAL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_BRAZILIAN_MINAS_GERAES';
update UnitReplaces set ReplacesUnitType = 'UNIT_LIGHT_CRUISER' where CivUniqueUnitType = 'UNIT_BRAZILIAN_MINAS_GERAES'
    and exists (select UnitType from Units where UnitType = 'UNIT_LIGHT_CRUISER');
------ UNIT_BRAZILIAN_FATHERLAND_VOLUNTEER
-- 法国
update Units set Cost = 210, Maintenance = 5, BaseMoves = 2, Range = 0, Combat = 70, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_FRENCH_GARDE_IMPERIALE';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_FRENCH_GARDE_IMPERIALE';
update UnitUpgrades set UpgradeUnit = 'UNIT_INFANTRY' where Unit = 'UNIT_FRENCH_GARDE_IMPERIALE' and exists (select UnitType from Units where UnitType = 'UNIT_WW1_INFANTRY');
------ UNIT_FRENCH_GENDARME
-- 刚果
update Units set Cost = 75, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 38, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_KONGO_SHIELD_BEARER';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_KONGO_SHIELD_BEARER';
------ UNIT_KONGO_MEDICINE_MAN
-- 澳大利亚
update Units set Cost = 310, Maintenance = 6, BaseMoves = 3, Range = 0, Combat = 78, RangedCombat = 0 where UnitType = 'UNIT_DIGGER';
update UnitReplaces set ReplacesUnitType = 'UNIT_WW1_INFANTRY' where CivUniqueUnitType = 'UNIT_DIGGER'
    and exists (select UnitType from Units where UnitType = 'UNIT_WW1_INFANTRY');
------ UNIT_AUSTRALIAN_SASR
-- 波兰
update Units set Cost = 260, Maintenance = 5, BaseMoves = 4, Range = 0, Combat = 73, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_POLISH_HUSSAR';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_POLISH_HUSSAR';
------ UNIT_POLISH_CHOSEN_INFANTRY
-- 阿兹特克
update Units set Cost = 45, Maintenance = 0, BaseMoves = 2, Range = 0, Combat = 28, RangedCombat = 0 where UnitType = 'UNIT_AZTEC_EAGLE_WARRIOR';
------ UNIT_AZTEC_JAGUAR
--delete from UnitReplaces where CivUniqueUnitType = 'UNIT_AZTEC_EAGLE_WARRIOR'
--and exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
--update UnitUpgrades set UpgradeUnit = 'UNIT_MUSKETMAN' where Unit = 'UNIT_AZTEC_EAGLE_WARRIOR'
--and exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
update Units set Cost = 30, BaseMoves = 2, Range = 0, Combat = 28, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_AZTEC_EAGLE_WARRIOR'
and exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_AZTEC_EAGLE_WARRIOR'
and exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or ignore into Tags (Tag, Vocabulary) values ('CLASS_AZTEC_EAGLE_WARRIOR', 'ABILITY_CLASS');
insert or replace into TypeTags (Type, Tag) select 'UNIT_AZTEC_EAGLE_WARRIOR', 'CLASS_AZTEC_EAGLE_WARRIOR'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into TypeTags (Type, Tag) select 'ABILITY_EAGLE_WARRIOR', 'CLASS_AZTEC_EAGLE_WARRIOR'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId)
select 'ABILITY_EAGLE_WARRIOR',   'ALPINE_IGNORE_HILLS_MOVEMENT_PENALTY'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId)
select 'ABILITY_EAGLE_WARRIOR',   'GRANT_STRENGTH_FROM_JAGUAR_ATTACH'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId)
select 'ABILITY_EAGLE_WARRIOR',   'GRANT_MOVEMENT_FROM_JAGUAR_ATTACH'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
--insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId)
--select 'ABILITY_EAGLE_WARRIOR',   'GRANT_STRENGTH_FROM_JAGUAR_LATE_ATTACH'
--where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId)
select 'ABILITY_EAGLE_WARRIOR',   'GRANT_MOVEMENT_FROM_JAGUAR_LATE_ATTACH'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');

insert or replace into Modifiers (ModifierId,       ModifierType,                               SubjectRequirementSetId)
select 'GRANT_STRENGTH_FROM_JAGUAR_ATTACH',         'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',    'EAGLE_WARRIOR_PLOT_IS_JAGUAR_REQUIREMENTS'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into Modifiers (ModifierId,       ModifierType,                               SubjectRequirementSetId)
select 'GRANT_MOVEMENT_FROM_JAGUAR_ATTACH',         'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',    'EAGLE_WARRIOR_PLOT_IS_JAGUAR_REQUIREMENTS'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
--insert or replace into Modifiers (ModifierId,       ModifierType,                               SubjectRequirementSetId)
--select 'GRANT_STRENGTH_FROM_JAGUAR_LATE_ATTACH',    'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',    'EAGLE_WARRIOR_PLOT_IS_JAGUAR_REQUIREMENTS'
--where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into Modifiers (ModifierId,       ModifierType,                               SubjectRequirementSetId)
select 'GRANT_MOVEMENT_FROM_JAGUAR_LATE_ATTACH',    'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',    'EAGLE_WARRIOR_PLOT_IS_JAGUAR_REQUIREMENTS'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');

insert or replace into ModifierArguments (ModifierId,   Name,           Value)
select 'GRANT_STRENGTH_FROM_JAGUAR_ATTACH',             'ModifierId',   'STRENGTH_FROM_JAGUAR_MODIFIER'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into ModifierArguments (ModifierId,   Name,           Value)
select 'GRANT_MOVEMENT_FROM_JAGUAR_ATTACH',             'ModifierId',   'MOVEMENT_FROM_JAGUAR_MODIFIER'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
--insert or replace into ModifierArguments (ModifierId,   Name,           Value)
--select 'GRANT_STRENGTH_FROM_JAGUAR_LATE_ATTACH',        'ModifierId',   'STRENGTH_FROM_JAGUAR_LATE_MODIFIER'
--where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into ModifierArguments (ModifierId,   Name,           Value)
select 'GRANT_MOVEMENT_FROM_JAGUAR_LATE_ATTACH',        'ModifierId',   'MOVEMENT_FROM_JAGUAR_LATE_MODIFIER'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');

insert or replace into Modifiers 
    (ModifierId,                                ModifierType,                               SubjectRequirementSetId)
values 
    ('STRENGTH_FROM_JAGUAR_MODIFIER',           'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     NULL),
    ('MOVEMENT_FROM_JAGUAR_MODIFIER',           'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',     NULL),
    --('STRENGTH_FROM_JAGUAR_LATE_MODIFIER',      'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'PLAYER_HAS_CIVIC_MILITARY_TRAINING_REQUIREMENTS'),
    ('MOVEMENT_FROM_JAGUAR_LATE_MODIFIER',      'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',     'PLAYER_HAS_CIVIC_MILITARY_TRAINING_REQUIREMENTS');

insert or replace into ModifierArguments 
    (ModifierId,                                        Name,           Value)
values 
    ('STRENGTH_FROM_JAGUAR_MODIFIER',                   'Amount',       5),
    ('MOVEMENT_FROM_JAGUAR_MODIFIER',                   'Amount',       1),
    --('STRENGTH_FROM_JAGUAR_LATE_MODIFIER',              'Amount',       10),
    ('MOVEMENT_FROM_JAGUAR_LATE_MODIFIER',              'Amount',       1);
insert or replace into ModifierStrings (ModifierId,     Context,    Text)
values ('STRENGTH_FROM_JAGUAR_MODIFIER',                'Preview',  '+{1_Amount} {LOC_STRENGTH_FOR_JAGUAR_MODIFIER_PREVIEW_TEXT}');

insert or ignore into RequirementSets
	(RequirementSetId,										            RequirementSetType)
values
	('EAGLE_WARRIOR_PLOT_IS_JAGUAR_REQUIREMENTS',			            'REQUIREMENTSET_TEST_ALL'),
    ('JAGUAR_PLOT_IS_EAGLE_WARRIOR_REQUIREMENTS',			            'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId, 										            RequirementId)
values
	('EAGLE_WARRIOR_PLOT_IS_JAGUAR_REQUIREMENTS',			            'REQUIRES_UNIT_NEXT_TO_JAGUAR'),
    ('JAGUAR_PLOT_IS_EAGLE_WARRIOR_REQUIREMENTS',			            'REQUIRES_UNIT_NEXT_TO_EAGLE_WARRIOR');

insert or ignore into Requirements
	(RequirementId,											RequirementType)
values
	('REQUIRES_UNIT_NEXT_TO_JAGUAR',		                'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TYPE_MATCHES'),
    ('REQUIRES_UNIT_NEXT_TO_EAGLE_WARRIOR',		            'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TYPE_MATCHES');

insert or ignore into RequirementArguments
	(RequirementId,											Name,					Value)
values
	('REQUIRES_UNIT_NEXT_TO_JAGUAR',		                'UnitType',		        'UNIT_AZTEC_JAGUAR'),
    ('REQUIRES_UNIT_NEXT_TO_EAGLE_WARRIOR',		            'UnitType',		        'UNIT_AZTEC_EAGLE_WARRIOR');

-- 马其顿
update Units set Cost = 70, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 38, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_MACEDONIAN_HYPASPIST';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_MACEDONIAN_HYPASPIST';
------ UNIT_MACEDONIAN_HETAIROI
update Units set Cost = 70, Maintenance = 2, BaseMoves = 4, Range = 0, Combat = 40, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_MACEDONIAN_HETAIROI';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_MACEDONIAN_HETAIROI';
delete from UnitReplaces where CivUniqueUnitType = 'UNIT_MACEDONIAN_HETAIROI';
------ UNIT_MACEDONIAN_PEZHETAIROS
-- 波斯
update Units set Cost = 70, Maintenance = 2, BaseMoves = 2, Range = 2, Combat = 40, RangedCombat = 28, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_PERSIAN_IMMORTAL';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_PERSIAN_IMMORTAL';
------ UNIT_PERSIAN_CATAPHRACT
-- 努比亚
update Units set Cost = 60, Maintenance = 1, BaseMoves = 3, Range = 2, Combat = 18, RangedCombat = 30, StrategicResource = NULL where UnitType = 'UNIT_NUBIAN_PITATI';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_NUBIAN_PITATI';
------ UNIT_NUBIAN_AFRICAN_FOREST_ELEPHANT
-- 祖鲁
update Units set Cost = 90, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 45, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_ZULU_IMPI';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_ZULU_IMPI';
update ModifierArguments set Value = 50 where ModifierId = 'IMPI_FASTER_COMBAT_XP' and Name = 'Amount';
------ UNIT_ZULU_ASSEGAI
-- 苏格兰
update Units set Cost = 210, Maintenance = 5, BaseMoves = 3, Range = 1, Combat = 65, RangedCombat = 55, StrategicResource = NULL where UnitType = 'UNIT_SCOTTISH_HIGHLANDER';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_SCOTTISH_HIGHLANDER';
insert or ignore into UnitAIInfos (UnitType, AiType) values ('UNIT_SCOTTISH_HIGHLANDER', 'UNITTYPE_MELEE');
------ UNIT_SCOTTISH_GALLOWGLASS
-- 蒙古
update Units set Cost = 90, Maintenance = 3, BaseMoves = 4, Range = 2, Combat = 35, RangedCombat = 45, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_MONGOLIAN_KESHIG';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_MONGOLIAN_KESHIG';
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) values ('UNIT_MONGOLIAN_KESHIG',  'UNIT_CROSSBOWMAN');
insert or replace into TypeTags (Type, Tag) values ('UNIT_MONGOLIAN_KESHIG', 'CLASS_HD_CAN_MOVE_AFTER_ATTACK');
------ UNIT_MONGOLIAN_HUI_HUI_PAO
-- 马普切
update Units set Cost = 140, Maintenance = 4, BaseMoves = 4, Range = 0, Combat = 56, RangedCombat = 0 where UnitType = 'UNIT_MAPUCHE_MALON_RAIDER';
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) select 'UNIT_MAPUCHE_MALON_RAIDER', 'UNIT_STRADIOT'
    where exists (select UnitType from Units where UnitType = 'UNIT_STRADIOT');
insert or replace into ModifierStrings (ModifierId,     Context,    Text)
values ('MALON_RAIDER_TERRITORY_COMBAT_BONUS',          'Preview',  '+{1_Amount} {LOC_MALON_RAIDER_TERRITORY_COMBAT_BONUS_PREVIEW_TEXT}');
------ UNIT_MAPUCHE_GUERILLA
-- 朝鲜
update Units set Cost = 120, Maintenance = 4, BaseMoves = 2, Range = 2, Combat = 40, RangedCombat = 60, StrategicResource = NULL where UnitType = 'UNIT_KOREAN_HWACHA';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_KOREAN_HWACHA';
update UnitReplaces set ReplacesUnitType = 'UNIT_CULVERIN' where CivUniqueUnitType = 'UNIT_KOREAN_HWACHA'
    and exists (select UnitType from Units where UnitType = 'UNIT_CULVERIN');
------ UNIT_KOREAN_TURTLE_SHIP
-- 高棉
update Units set Cost = 120, Maintenance = 3, BaseMoves = 2, Range = 2, Combat = 40, Bombard = 50, StrategicResource = NULL where UnitType = 'UNIT_KHMER_DOMREY';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_KHMER_DOMREY';
------ UNIT_KHMER_WAR_CANOE
-- 格鲁吉亚
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 48, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_GEORGIAN_KHEVSURETI';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_GEORGIAN_KHEVSURETI';
------ UNIT_GEORGIAN_TADZREULI
-- 荷兰
update Units set Cost = 220, Maintenance = 4, BaseMoves = 4, Range = 2, Combat = 55, RangedCombat = 65, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_DE_ZEVEN_PROVINCIEN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_DE_ZEVEN_PROVINCIEN';
------ UNIT_DUTCH_SCHUTTERIJ
-- 克里
update Units set Cost = 30, Combat = 17, BaseMoves = BaseMoves + 1 where UnitType = 'UNIT_CREE_OKIHTCITAW';
delete from TypeTags where Type = 'ABILITY_CREE_OKIHTCITAW' and Tag = 'CLASS_CREE_OKIHTCITAW';
------ UNIT_CREE_OTEHTAPIW
-- 印尼
update Units set Cost = 120, Maintenance = 3, BaseMoves = 5, Range = 2, Combat = 40, RangedCombat = 50, StrategicResource = NULL, PrereqCivic = 'CIVIC_NAVAL_TRADITION', PrereqTech = null where UnitType = 'UNIT_INDONESIAN_JONG';
------ UNIT_INDONESIAN_KRIS_SWORDSMAN
-- 加拿大
update Units set Cost = 200, Maintenance = 5, BaseMoves = 5, Range = 0, Combat = 66, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_CANADA_MOUNTIE';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_CANADA_MOUNTIE';
------ UNIT_CANADA_HMCS_HAIDA
-- 匈牙利
update Units set Cost = 100, Maintenance = 3, BaseMoves = 5, Range = 0, Combat = 50, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_HUNGARY_BLACK_ARMY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_HUNGARY_BLACK_ARMY';
update Units set Cost = 205, Maintenance = 5, BaseMoves = 5, Range = 0, Combat = 65, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_HUNGARY_HUSZAR';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_HUNGARY_HUSZAR';
------ UNIT_HUNGARY_KALANDOZO
-- 印加
update Units set Cost = 60, Maintenance = 2, BaseMoves = BaseMoves + 1, Range = 1, Combat = 36, RangedCombat = 26, StrategicResource = NULL,
    PrereqTech = null, PrereqCivic = 'CIVIC_MILITARY_TRAINING'
    where UnitType = 'UNIT_INCA_WARAKAQ';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_INCA_WARAKAQ';
update UnitUpgrades set UpgradeUnit = 'UNIT_RANGER' where Unit = 'UNIT_INCA_WARAKAQ';
-- maybe not add melee to encourage the ranged attack.
------ UNIT_INCA_CHASQUI
-- 马里
update Units set Cost = 130, Maintenance = 3, BaseMoves = 4, Range = 0, Combat = 56, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_MALI_MANDEKALU_CAVALRY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_MALI_MANDEKALU_CAVALRY';
------ UNIT_MALI_SOFA
-- 毛利
update Units set Cost = 60, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 40, RangedCombat = 0 where UnitType = 'UNIT_MAORI_TOA';
------ UNIT_MAORI_TUPARA
-- 奥斯曼
update Units set Cost = 155, Maintenance = 4, BaseMoves = 4, Range = 2, Combat = 40, RangedCombat = 50, StrategicResource = NULL where UnitType = 'UNIT_OTTOMAN_BARBARY_CORSAIR';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_OTTOMAN_BARBARY_CORSAIR';
update Units set Cost = 105, Maintenance = 4, BaseMoves = 2, Range = 0, Combat = 60, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_SULEIMAN_JANISSARY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_SULEIMAN_JANISSARY';
------ UNIT_OTTOMAN_SIPAHI
-- 腓尼基
update Units set Cost = 55, Maintenance = 1, BaseMoves = 4, Range = 0, Combat = 35, RangedCombat = 0, StrategicResource = NULL, PrereqTech = 'TECH_SHIPBUILDING' where UnitType = 'UNIT_PHOENICIA_BIREME';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_PHOENICIA_BIREME';
------ UNIT_PHOENICIA_NUMIDIAN_CAVALRY
-- 瑞典
update Units set PrereqTech = 'TECH_MILITARY_SCIENCE', PromotionClass = 'PROMOTION_CLASS_MELEE' where UnitType = 'UNIT_SWEDEN_CAROLEAN';
update Units set Cost = 210, Maintenance = 5, BaseMoves = 3, Range = 0, Combat = 65, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_SWEDEN_CAROLEAN';
insert or replace into Units_XP2 (UnitType, ResourceCost, ResourceMaintenanceType, ResourceMaintenanceAmount) values
    ('UNIT_SWEDEN_CAROLEAN', 5, 'RESOURCE_NITER', 1);
update TypeTags set Tag = 'CLASS_MELEE' where Type = 'UNIT_SWEDEN_CAROLEAN' and Tag = 'CLASS_ANTI_CAVALRY';
delete from UnitAiInfos where UnitType = 'UNIT_SWEDEN_CAROLEAN' and AiType = 'UNITTYPE_ANTI_CAVALRY';
update UnitReplaces set ReplacesUnitType = 'UNIT_LINE_INFANTRY' where CivUniqueUnitType = 'UNIT_SWEDEN_CAROLEAN';
update UnitUpgrades set UpgradeUnit = 'UNIT_INFANTRY' where Unit = 'UNIT_SWEDEN_CAROLEAN';
------ UNIT_SWEDEN_HAKKAPELIITTA
-- 埃利诺
------ UNIT_ELEANOR_TEMPLAR
-- 玛雅
update UnitUpgrades set UpgradeUnit = 'UNIT_CROSSBOWMAN' where Unit = 'UNIT_MAYAN_HULCHE';
update Units set Cost = 45, Maintenance = 1, BaseMoves = 2, Range = 2, Combat = 15, RangedCombat = 28, StrategicResource = NULL where UnitType = 'UNIT_MAYAN_HULCHE';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MAYAN_HULCHE';
------ UNIT_MAYAN_HOLKAN
-- 大哥伦比亚
update Units set Cost = 200, Maintenance = 4, BaseMoves = 5, Range = 0, Combat = 62, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_COLOMBIAN_LLANERO';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_COLOMBIAN_LLANERO';
------ UNIT_COLOMBIAN_BRITISH_LEGION
-- 埃塞俄比亚
update Units set Cost = 100, Maintenance = 3, BaseMoves = 5, Range = 0, Combat = 50, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_ETHIOPIAN_OROMO_CAVALRY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ETHIOPIAN_OROMO_CAVALRY';
update UnitReplaces set ReplacesUnitType = 'UNIT_COURSER' where CivUniqueUnitType = 'UNIT_ETHIOPIAN_OROMO_CAVALRY';
------ UNIT_ETHIOPIAN_MEHAL_SEFARI
-- 拜占庭
update Units set Cost = 120, Maintenance = 3, BaseMoves = 4, Range = 2, Combat = 40, RangedCombat = 50, StrategicResource = NULL, PrereqTech = 'TECH_COMPASS_HD' where UnitType = 'UNIT_BYZANTINE_DROMON';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_BYZANTINE_DROMON';
update Units set Cost = 130, Maintenance = 3, BaseMoves = 4, Range = 0, Combat = 56, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_BYZANTINE_TAGMA';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_BYZANTINE_TAGMA';
------ UNIT_BYZANTINE_VARANGIAN_GUARD
-- 高卢
update Units set Cost = 45 where UnitType = 'UNIT_GAUL_GAESATAE';
------ UNIT_GAUL_CARRUS
-- 巴比伦
update Units set Cost = 25 where UnitType = 'UNIT_BABYLONIAN_SABUM_KIBITTUM';
insert or replace into TypeTags (Type, Tag) select UnitType, 'CLASS_HD_GAIN_SCIENCE_WHEN_KILLS'
from Units where UnitType = 'UNIT_BABYLONIAN_SABUM_KIBITTUM';
------ UNIT_BABYLONIAN_BOWMAN
-- 越南
update Units set Cost = 100, Maintenance = 3, BaseMoves = 3, Range = 2, Combat = 38, RangedCombat = 40, StrategicResource = NULL where UnitType = 'UNIT_VIETNAMESE_VOI_CHIEN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_VIETNAMESE_VOI_CHIEN';
------ UNIT_VIETNAMESE_VIETCONG
-- 葡萄牙
update Units set Cost = 140, Maintenance = 4, BaseMoves = 3, Range = 0, Combat = 55, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_PORTUGUESE_NAU';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_PORTUGUESE_NAU';
------ UNIT_SPANISH_JINETE

-- 武僧
update Units set Cost = 70 where UnitType = 'UNIT_WARRIOR_MONK';
-- 拉合尔
update Units set Cost = 60 where UnitType = 'UNIT_LAHORE_NIHANG';



