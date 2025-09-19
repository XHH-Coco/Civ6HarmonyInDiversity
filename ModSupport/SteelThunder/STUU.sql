-- ----------------------------------------------
-- # Steel & Thunder Unique Units Compatibility #
-- ----------------------------------------------
-- Assume Military Testing Mode is Enabled.

--伊丽莎白lu
delete from CivilizationTraits where TraitType = 'TRAIT_CIVILIZATION_UNIT_ENGLISH_SEADOG';
update Units set Description = 'LOC_UNIT_ENGLISH_SEADOG_STUU_DESCRIPTION' where UnitType = 'UNIT_ENGLISH_SEADOG'
and exists (select UnitType from Units where UnitType = 'UNIT_ENGLISH_LONGBOWMAN');
update Traits set Description = 'LOC_TRAIT_LEADER_ELIZABETH_HD_DESCRIPTION' where TraitType = 'TRAIT_LEADER_ELIZABETH'
and exists (select UnitType from Units where UnitType = 'UNIT_ENGLISH_LONGBOWMAN');

insert or replace into LeaderTraits
    (LeaderType,                    TraitType)
select
    'LEADER_ELIZABETH',         'TRAIT_CIVILIZATION_UNIT_ENGLISH_SEADOG'
where exists (select * from Traits where TraitType = 'TRAIT_CIVILIZATION_UNIT_ENGLISH_SEADOG');

-- General Fix
delete from UnitUpgrades where Unit = 'UNIT_BRAZILIAN_BANDEIRANTE';

insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) select UnitType, 'UNIT_MAN_AT_ARMS'
from Units where UnitType = 'UNIT_BYZANTINE_VARANGIAN_GUARD' or UnitType = 'UNIT_MAYAN_HOLKAN';
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) select UnitType, 'UNIT_LINE_INFANTRY'
from Units where UnitType = 'UNIT_COLOMBIAN_BRITISH_LEGION' or UnitType = 'UNIT_ETHIOPIAN_MEHAL_SEFARI';

insert or replace into UnitReplaces
    (CivUniqueUnitType,                     ReplacesUnitType)
values
    ('UNIT_ARABIAN_GHAZI',                  'UNIT_MAN_AT_ARMS'),
    ('UNIT_SCOTTISH_GALLOWGLASS',           'UNIT_MAN_AT_ARMS'),
    ('UNIT_ELEANOR_TEMPLAR',                'UNIT_MAN_AT_ARMS'),

    ('UNIT_BRAZILIAN_FATHERLAND_VOLUNTEER', 'UNIT_LINE_INFANTRY'),
    ('UNIT_INDIAN_SEPOY',                   'UNIT_LINE_INFANTRY'),
    ('UNIT_MONGOLIAN_HUI_HUI_PAO',          'UNIT_TREBUCHET');

update UnitUpgrades set UpgradeUnit = 'UNIT_MAN_AT_ARMS' where Unit = 'UNIT_EGYPTIAN_KHOPESH' or Unit = 'UNIT_AZTEC_JAGUAR';
update UnitUpgrades set UpgradeUnit = 'UNIT_LINE_INFANTRY' where Unit = 'UNIT_POLISH_CHOSEN_INFANTRY' or Unit = 'UNIT_AMERICAN_MINUTEMAN';
update UnitUpgrades set UpgradeUnit = 'UNIT_TREBUCHET' where Unit = 'UNIT_ROMAN_ONAGER' or Unit = 'UNIT_MACEDONIAN_BALLISTA';

update UnitUpgrades set UpgradeUnit = 'UNIT_DLV_COG'
where Unit = 'UNIT_KHMER_WAR_CANOE' and exists (select 1 from Units where UnitType = 'UNIT_DLV_COG');

update UnitUpgrades set UpgradeUnit = 'UNIT_CUIRASSIER' where
    Unit = 'UNIT_SCYTHIAN_AMAZON' or Unit = 'UNIT_FRENCH_GENDARME' or Unit = 'UNIT_INDIAN_MUGHAL_SOWAR' or Unit = 'UNIT_GEORGIAN_TADZREULI' or Unit = 'UNIT_OTTOMAN_SIPAHI';

update UnitUpgrades set UpgradeUnit = 'UNIT_COURSER' where Unit = 'UNIT_PHOENICIA_NUMIDIAN_CAVALRY';

update Units set PrereqTech = 'TECH_MILITARY_SCIENCE' where UnitType = 'UNIT_BRAZILIAN_FATHERLAND_VOLUNTEER';
update Units set PrereqTech = 'TECH_MILITARY_SCIENCE' where UnitType = 'UNIT_INDIAN_SEPOY';
update Units set PrereqTech = 'TECH_MILITARY_SCIENCE' where UnitType = 'UNIT_COLOMBIAN_BRITISH_LEGION';
update Units set PrereqTech = 'TECH_MILITARY_SCIENCE' where UnitType = 'UNIT_ETHIOPIAN_MEHAL_SEFARI';

-- ----------------------------------------------
-- HD modifications
-- ----------------------------------------------
insert or replace into TraitModifiers
    (TraitType,                                     ModifierId)
values
    ('TRAIT_CIVILIZATION_UNIT_GERMAN_LANDSKNECHT',  'UNIT_GERMAN_LANDSKNECHT_DISCOUNT'),
    ('TRAIT_CIVILIZATION_EXTRA_LIGHT_CAVALRY',      'TRAIT_EXTRA_SCYTHIAN_AMAZON');

insert or replace into Modifiers
    (ModifierId,                            ModifierType)
values
    ('UNIT_GERMAN_LANDSKNECHT_DISCOUNT',    'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST'),
    ('TRAIT_EXTRA_SCYTHIAN_AMAZON',         'MODIFIER_PLAYER_UNITS_ADJUST_EXTRA_UNIT_COPY');

insert or replace into ModifierArguments
    (ModifierId,                            Name,       Value)
values
    ('UNIT_GERMAN_LANDSKNECHT_DISCOUNT',    'UnitType', 'UNIT_GERMAN_LANDSKNECHT'),
    ('UNIT_GERMAN_LANDSKNECHT_DISCOUNT',    'Amount',   50),
    ('TRAIT_EXTRA_SCYTHIAN_AMAZON',         'UnitType', 'UNIT_SCYTHIAN_AMAZON'),
    ('TRAIT_EXTRA_SCYTHIAN_AMAZON',         'Amount',   1);

-- UU
-- 美国
update Units set Cost = 140, Maintenance = 4, BaseMoves = 2, Range = 0, Combat = 55, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_AMERICAN_MINUTEMAN';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_AMERICAN_MINUTEMAN';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_MINUTEMAN' and (ModifierId = 'COSSACK_LOCAL_COMBAT' or ModifierId = 'PLUS_5_FOREST_JUNGLE_COMBAT_BONUS');
insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId) values
    ('ABILITY_MINUTEMAN',  'HETAIROI_FREE_PROMOTION'),
    ('ABILITY_MINUTEMAN',  'HD_RECON_IGNORE_HILLS_MOVEMENT_PENALTY'),
    ('ABILITY_MINUTEMAN',  'HD_RECON_IGNORE_FOREST_MOVEMENT_PENALTY');
-- 阿拉伯
delete from CivilizationTraits where CivilizationType = 'CIVILIZATION_ARABIA' and TraitType = 'TRAIT_CIVILIZATION_UNIT_ARABIAN_MAMLUK';
insert or replace into LeaderTraits (LeaderType, TraitType) values ('LEADER_SALADIN', 'TRAIT_CIVILIZATION_UNIT_ARABIAN_MAMLUK');
update Traits set Description = 'LOC_TRAIT_LEADER_RIGHTEOUSNESS_OF_FAITH_STUU_DESCRIPTION' where TraitType = 'TRAIT_LEADER_RIGHTEOUSNESS_OF_FAITH';
-- 
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) values ('UNIT_ARABIAN_CAMEL_ARCHER', 'UNIT_CROSSBOWMAN');
-- update Units set PrereqTech = 'TECH_STIRRUPS', PurchaseYield = 'YIELD_FAITH' where UnitType = 'UNIT_ARABIAN_CAMEL_ARCHER';
update Units set PrereqTech = 'TECH_CASTLES', PurchaseYield = 'YIELD_FAITH' where UnitType = 'UNIT_ARABIAN_CAMEL_ARCHER';
update Units set Cost = 90, Maintenance = 3, BaseMoves = 4, Range = 2, Combat = 35, RangedCombat = 45, StrategicResource = NULL where UnitType = 'UNIT_ARABIAN_CAMEL_ARCHER';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_ARABIAN_CAMEL_ARCHER';
insert or replace into TypeTags (Type, Tag) values ('UNIT_ARABIAN_CAMEL_ARCHER', 'CLASS_HD_CAN_MOVE_AFTER_ATTACK');
delete from TypeTags where Type = 'ABILITY_CAMEL_ARCHER' and Tag = 'CLASS_ARABIAN_CAMEL_ARCHER';
-- 
update Units set PrereqTech = NULL, PrereqCivic = 'CIVIC_THEOLOGY', PurchaseYield = 'YIELD_FAITH' where UnitType = 'UNIT_ARABIAN_GHAZI';
update Units set Cost = 75, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 42, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_ARABIAN_GHAZI';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ARABIAN_GHAZI';
update UnitReplaces set ReplacesUnitType = 'UNIT_MAN_AT_ARMS' where CivUniqueUnitType = 'UNIT_ARABIAN_GHAZI';
update UnitUpgrades set UpgradeUnit = 'UNIT_MUSKETMAN' where Unit = 'UNIT_ARABIAN_GHAZI';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_GHAZI' and ModifierId = '50_PERCENT_POST_COMBAT_FAITH';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_GHAZI' and ModifierId = 'CONQUISTADOR_CITY_RELIGION_COMBAT';
insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId) values ('ABILITY_GHAZI',  'DISCIPLES_LAND_VICTORY_SPREAD');
-- update Units set PrereqTech = 'TECH_METAL_CASTING' where UnitType = 'UNIT_ARABIAN_GHAZI';
-- update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 46, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_ARABIAN_GHAZI';
-- update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ARABIAN_GHAZI';
-- 德国
update Units set PrereqTech = 'TECH_APPRENTICESHIP', MustPurchase = 0, CostProgressionModel = 'NO_COST_PROGRESSION', CostProgressionParam1 = 0 where UnitType = 'UNIT_GERMAN_LANDSKNECHT';
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 45, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_GERMAN_LANDSKNECHT';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_GERMAN_LANDSKNECHT';
update Units set Cost = 600, Maintenance = 15, BaseMoves = 4, Range = 0, Combat = 92, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_GERMAN_PANZER';
update Units_XP2 set ResourceCost = 10, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 2 where UnitType = 'UNIT_GERMAN_PANZER';
-- 希腊
update Units set Cost = 45, Maintenance = 1, BaseMoves = 2, Range = 2, Combat = 13, RangedCombat = 23, StrategicResource = NULL where UnitType = 'UNIT_GREEK_PELTAST';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_GREEK_PELTAST';
delete from TypeTags where Type = 'ABILITY_PLUS_5_DEFENDER' and Tag = 'CLASS_GREEK_PELTAST';
insert or replace into TypeTags (Type, Tag) values ('ABILITY_GREEK_PELTAST', 'CLASS_GREEK_PELTAST');
-- 苏美尔
update Units set PrereqTech = NULL where UnitType = 'UNIT_SUMERIAN_PHALANX';
update Units set Cost = 25, Maintenance = 0, BaseMoves = 2, Range = 0, Combat = 25, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_SUMERIAN_PHALANX';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_SUMERIAN_PHALANX';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_PHALANX' and ModifierId = 'PLUS_5_ZIGURRAT_PROXIMITY_COMBAT_BONUS';
insert or replace into UnitAbilityModifiers (UnitAbilityType,   ModifierId)
values ('ABILITY_PHALANX', 'PLUS_10_BARBARIAN_COMBAT');
insert or replace into Modifiers (ModifierId,       ModifierType)
values ('PLUS_10_BARBARIAN_COMBAT',      'MODIFIER_PLAYER_UNIT_ADJUST_BARBARIAN_COMBAT');
insert or replace into ModifierArguments (ModifierId,   Name,       Value)
values ('PLUS_10_BARBARIAN_COMBAT',      'Amount',   10);
-- 埃及
update Units set Cost = 60, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 38, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_EGYPTIAN_KHOPESH';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_EGYPTIAN_KHOPESH';
delete from TypeTags where Type = 'ABILITY_PLUS_5_BONUS_VS_DAMAGED' and Tag = 'CLASS_EGYPTIAN_KHOPESH';
insert or replace into TypeTags (Type, Tag) values ('ABILITY_HD_BATTLECRY', 'CLASS_EGYPTIAN_KHOPESH');
update Units set Combat = 28, RangedCombat = 38, Cost = 80 where UnitType = 'UNIT_EGYPTIAN_WAR_GALLEY';
-- -- 中国
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 2, Combat = 32, RangedCombat = 37, StrategicResource = NULL where UnitType = 'UNIT_CHINESE_CHOKONU';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_CHINESE_CHOKONU';
-- -- 西班牙
update Units set PrereqTech = 'TECH_MILITARY_TACTICS' where UnitType = 'UNIT_SPANISH_TERCIO';
update Units set Cost = 160, Maintenance = 4, BaseMoves = 2, Range = 0, Combat = 55, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_SPANISH_TERCIO';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_SPANISH_TERCIO';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_TERCIO' and ModifierId = 'MUSTANG_MORE_EXPERIENCE';
insert or replace into UnitAbilityModifiers
    (UnitAbilityType,   ModifierId)
values
    ('ABILITY_TERCIO', 'PLUS_5_CAPITAL_CONTINENT_COMBAT_BONUS'),
    ('ABILITY_TERCIO', 'HD_FOREIGN_CONTINENT_MOVEMENT_BONUS');
insert or replace into Modifiers (ModifierId,       ModifierType,                            SubjectRequirementSetId)
values ('HD_FOREIGN_CONTINENT_MOVEMENT_BONUS',      'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',  'REDCOAT_PLOT_IS_FOREIGN_CONTINENT');
insert or replace into ModifierArguments (ModifierId,   Name,       Value)
values ('HD_FOREIGN_CONTINENT_MOVEMENT_BONUS',          'Amount',   1);
-- -- 罗马
update Units set Cost = 75, Maintenance = 2, BaseMoves = 2, Range = 2, Combat = 30, Bombard = 40, StrategicResource = NULL where UnitType = 'UNIT_ROMAN_ONAGER';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_ROMAN_ONAGER';
-- -- 俄罗斯
update Units set PrereqTech = 'TECH_STIRRUPS' where UnitType = 'UNIT_RUSSIAN_DRUZHINA';
update Units set Cost = 100, Maintenance = 3, BaseMoves = 5, Range = 0, Combat = 50, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_RUSSIAN_DRUZHINA';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_RUSSIAN_DRUZHINA';
-- -- 挪威
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) values ('UNIT_NORWEGIAN_ULFHEDNAR',    'UNIT_MEDIC');
update Units set Cost = 100, CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1 = 20, PurchaseYield = 'YIELD_FAITH' where UnitType = 'UNIT_NORWEGIAN_ULFHEDNAR';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_RECEIVE_NORWEGIAN_ULFHEDNAR_BONUS' and ModifierId = 'RECEIVE_NORWEGIAN_ULFHEDNAR_COMBAT_BONUS_ATTACH';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_RECEIVE_NORWEGIAN_ULFHEDNAR_BONUS' and ModifierId = 'RECEIVE_NORWEGIAN_ULFHEDNAR_DAMAGED_UNITS_BONUS_ATTACH';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_RECEIVE_NORWEGIAN_ULFHEDNAR_BONUS' and ModifierId = 'RECEIVE_NORWEGIAN_ULFHEDNAR_FAITH_BONUS_ATTACH';
insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                               ModifierId)
values
    ('ABILITY_RECEIVE_NORWEGIAN_ULFHEDNAR_BONUS',   'RECEIVE_NORWEGIAN_ULFHEDNAR_MOVEMENT_BONUS_ATTACH'),
    ('ABILITY_RECEIVE_NORWEGIAN_ULFHEDNAR_BONUS',   'RECEIVE_NORWEGIAN_ULFHEDNAR_EXPERIENCE_BONUS_ATTACH');
insert or replace into Modifiers (ModifierId,                   ModifierType,                           SubjectRequirementSetId)
values ('RECEIVE_NORWEGIAN_ULFHEDNAR_MOVEMENT_BONUS_ATTACH',    'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER', 'ADJACENT_NORWEGIAN_ULFHEDNAR_REQUIREMENTS'),
       ('RECEIVE_NORWEGIAN_ULFHEDNAR_EXPERIENCE_BONUS_ATTACH',  'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER', 'ADJACENT_NORWEGIAN_ULFHEDNAR_REQUIREMENTS');
insert or replace into ModifierArguments (ModifierId,           Name,       Value)
values ('RECEIVE_NORWEGIAN_ULFHEDNAR_MOVEMENT_BONUS_ATTACH',    'ModifierId',   'PURSUIT_BONUS_MOVEMENT'),
       ('RECEIVE_NORWEGIAN_ULFHEDNAR_EXPERIENCE_BONUS_ATTACH',  'ModifierId',   'MUSTANG_MORE_EXPERIENCE');
-- -- 印度
update Units set Cost = 210, Maintenance = 5, BaseMoves = 2, Range = 0, Combat = 68, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_INDIAN_SEPOY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_INDIAN_SEPOY';
-- -- 英国
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 3, Combat = 32, RangedCombat = 37, StrategicResource = NULL where UnitType = 'UNIT_ENGLISH_LONGBOWMAN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_ENGLISH_LONGBOWMAN';
delete from TypeTags where Type = 'ABILITY_LONGBOWMAN' and Tag = 'CLASS_ENGLISH_LONGBOWMAN';
update Units set Cost = 220, Maintenance = 4, BaseMoves = 4, Range = 2, Combat = 50, RangedCombat = 60, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_ENGLISH_SHIP_OF_THE_LINE';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ENGLISH_SHIP_OF_THE_LINE';
-- -- 日本
delete from TypeTags where Type = 'UNIT_JAPANESE_SOHEI' and Tag = 'CLASS_MELEE';
insert or replace into TypeTags (Type, Tag) values ('UNIT_JAPANESE_SOHEI', 'CLASS_WARRIOR_MONK');

update Units set PrereqCivic = 'CIVIC_THEOLOGY', PromotionClass = 'PROMOTION_CLASS_MONK' where UnitType = 'UNIT_JAPANESE_SOHEI';
update Units set Cost = 60, Maintenance = 2, BaseMoves = 3, Range = 0, Combat = 38, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_JAPANESE_SOHEI';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_JAPANESE_SOHEI';

delete from UnitUpgrades where Unit = 'UNIT_JAPANESE_SOHEI';
delete from TypeTags where Type = 'ABILITY_PLUS_10_DEFENDER' and Tag = 'CLASS_JAPANESE_SOHEI';
-- delete from TypeTags where Type = 'UNIT_JAPANESE_SOHEI' and Tag = 'CLASS_MELEE';
-- insert or replace into TypeTags (Type, Tag) values ('UNIT_JAPANESE_SOHEI', 'CLASS_ANTI_CAVALRY');

-- update Units set PromotionClass = 'PROMOTION_CLASS_ANTI_CAVALRY' where UnitType = 'UNIT_JAPANESE_SOHEI';
-- update Units set Cost = 80, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 42, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_JAPANESE_SOHEI';
-- update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_JAPANESE_SOHEI';

-- insert or replace into UnitReplaces
--     (CivUniqueUnitType,                     ReplacesUnitType)
-- values
--     ('UNIT_JAPANESE_SOHEI',                 'UNIT_PIKEMAN');
-- update UnitUpgrades set UpgradeUnit = 'UNIT_PIKE_AND_SHOT' where Unit = 'UNIT_JAPANESE_SOHEI';
-- -- 斯基泰
update UnitUpgrades set UpgradeUnit = 'UNIT_KNIGHT' where Unit = 'UNIT_SCYTHIAN_AMAZON';
update UnitReplaces set ReplacesUnitType = 'UNIT_HEAVY_CHARIOT' where CivUniqueUnitType = 'UNIT_SCYTHIAN_AMAZON';
insert or replace into TypeTags (Type, Tag) values ('UNIT_SCYTHIAN_AMAZON', 'CLASS_HEAVY_CHARIOT');
update Units set PrereqTech = 'TECH_SADDLE_HD' where UnitType = 'UNIT_SCYTHIAN_AMAZON';
update Units set Cost = 90, Maintenance = 2, BaseMoves = 3, Range = 0, Combat = 39, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_SCYTHIAN_AMAZON';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_SCYTHIAN_AMAZON';
-- -- 巴西
update Units set Cost = 150, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 65, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_BRAZILIAN_FATHERLAND_VOLUNTEER';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_BRAZILIAN_FATHERLAND_VOLUNTEER';
-- -- 法国
update Units set Cost = 130, Maintenance = 3, BaseMoves = 4, Range = 0, Combat = 56, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_FRENCH_GENDARME';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_FRENCH_GENDARME';
-- -- 刚果
update Units set Cost = 50, MustPurchase = 0 where UnitType = 'UNIT_KONGO_MEDICINE_MAN';
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) values ('UNIT_KONGO_MEDICINE_MAN',    'UNIT_MEDIC');
update ModifierArguments set Value = 100 where ModifierId = 'RECEIVE_MEDICINE_MAN_FAITH_BONUS' and Name = 'PercentDefeatedStrength';
-- ------ UNIT_KONGO_MEDICINE_MAN
-- -- 澳大利亚
update Units set Cost = 690, Maintenance = 8, BaseMoves = 3, Range = 0, Combat = 95, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_AUSTRALIAN_SASR';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_AUSTRALIAN_SASR';
-- -- 波兰
update Units set Cost = 140, Maintenance = 4, BaseMoves = 2, Range = 0, Combat = 58, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_POLISH_CHOSEN_INFANTRY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_POLISH_CHOSEN_INFANTRY';
-- -- 阿兹特克
update units set Description = 'LOC_UNIT_AZTEC_EAGLE_WARRIOR_STUU_DESCRIPTION', Cost = 65 where UnitType = 'UNIT_AZTEC_EAGLE_WARRIOR';
delete from UnitReplaces where CivUniqueUnitType = 'UNIT_AZTEC_JAGUAR';
-- delete from TypeTags where Type = 'UNIT_AZTEC_JAGUAR' and Tag = 'CLASS_CAPTURE_WORKER';
--update UnitUpgrades set UpgradeUnit = 'UNIT_MUSKETMAN' where Unit = 'UNIT_AZTEC_JAGUAR';
update Units set Cost = 30, Maintenance = 0, BaseMoves = 2, Range = 0, Combat = 28, RangedCombat = 0, StrategicResource = NULL, PrereqTech = NULL where UnitType = 'UNIT_AZTEC_JAGUAR';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_AZTEC_JAGUAR';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_JAGUAR' and ModifierId = 'UNIT_STRONG_WHEN_ATTACKING';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_JAGUAR' and ModifierId = 'UNIT_WEAK_WHEN_DEFENDING';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_JAGUAR' and ModifierId = 'JUNGLE_MOVEMENT';
-- 保留 RANGER_IGNORE_FOREST_MOVEMENT_PENALTY，无视雨林森林移动力消耗。
insert or replace into UnitAbilityModifiers 
    (UnitAbilityType,                           ModifierId)
values 
    ('ABILITY_JAGUAR',                          'GRANT_STRENGTH_FROM_EAGLE_ATTACH'),
    ('ABILITY_JAGUAR',                          'GRANT_MOVEMENT_FROM_EAGLE_ATTACH'),
    --('ABILITY_JAGUAR',                          'GRANT_STRENGTH_FROM_EAGLE_LATE_ATTACH'),
    ('ABILITY_JAGUAR',                          'GRANT_MOVEMENT_FROM_EAGLE_LATE_ATTACH');

insert or replace into Modifiers 
    (ModifierId,                                    ModifierType,                               SubjectRequirementSetId)
values 
    ('GRANT_STRENGTH_FROM_EAGLE_ATTACH',            'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',    'JAGUAR_PLOT_IS_EAGLE_WARRIOR_REQUIREMENTS'),
    ('STRENGTH_FROM_EAGLE_MODIFIER',                'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     NULL),
    ('GRANT_MOVEMENT_FROM_EAGLE_ATTACH',            'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',    'JAGUAR_PLOT_IS_EAGLE_WARRIOR_REQUIREMENTS'),
    ('MOVEMENT_FROM_EAGLE_MODIFIER',                'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',     NULL),
    --('GRANT_STRENGTH_FROM_EAGLE_LATE_ATTACH',       'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',    'JAGUAR_PLOT_IS_EAGLE_WARRIOR_REQUIREMENTS'),
    --('STRENGTH_FROM_EAGLE_LATE_MODIFIER',           'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',    'PLAYER_HAS_CIVIC_MILITARY_TRAINING_REQUIREMENTS'),
    ('GRANT_MOVEMENT_FROM_EAGLE_LATE_ATTACH',       'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',    'JAGUAR_PLOT_IS_EAGLE_WARRIOR_REQUIREMENTS'),
    ('MOVEMENT_FROM_EAGLE_LATE_MODIFIER',           'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',    'PLAYER_HAS_CIVIC_MILITARY_TRAINING_REQUIREMENTS');

insert or replace into ModifierArguments 
    (ModifierId,                                        Name,           Value)
values 
    ('GRANT_STRENGTH_FROM_EAGLE_ATTACH',                'ModifierId',   'STRENGTH_FROM_EAGLE_MODIFIER'),
    ('STRENGTH_FROM_EAGLE_MODIFIER',                    'Amount',       5),
    ('GRANT_MOVEMENT_FROM_EAGLE_ATTACH',                'ModifierId',   'MOVEMENT_FROM_EAGLE_MODIFIER'),
    ('MOVEMENT_FROM_EAGLE_MODIFIER',                    'Amount',       1),
    --('GRANT_STRENGTH_FROM_EAGLE_LATE_ATTACH',           'ModifierId',   'STRENGTH_FROM_EAGLE_LATE_MODIFIER'),
    --('STRENGTH_FROM_EAGLE_LATE_MODIFIER',               'Amount',       10),
    ('GRANT_MOVEMENT_FROM_EAGLE_LATE_ATTACH',           'ModifierId',   'MOVEMENT_FROM_EAGLE_LATE_MODIFIER'),
    ('MOVEMENT_FROM_EAGLE_LATE_MODIFIER',               'Amount',       1);

insert or replace into ModifierStrings (ModifierId,     Context,    Text)
values ('STRENGTH_FROM_EAGLE_MODIFIER',                  'Preview',  '+{1_Amount} {LOC_STRENGTH_FOR_EAGLE_MODIFIER_PREVIEW_TEXT}');
-- -- 马其顿
update Units set Cost = 45, Maintenance = 1, BaseMoves = 2, Range = 0, Combat = 28, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_MACEDONIAN_PEZHETAIROS';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MACEDONIAN_PEZHETAIROS';
update UnitAbilityModifiers set ModifierId = 'PLUS_10_ATTACKING_UNIT_BONUS' where
    UnitAbilityType = 'ABILITY_PEZHETAIROS' and ModifierId = 'PLUS_10_VERSUS_MELEE_COMBAT_BONUS';
insert or replace into Modifiers (ModifierId,       ModifierType,                            SubjectRequirementSetId)
values ('PLUS_10_ATTACKING_UNIT_BONUS',             'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',  'HD_UNIT_ATTACKING_UNIT_REQUIREMENTS');
insert or replace into ModifierArguments (ModifierId,   Name,       Value)
values ('PLUS_10_ATTACKING_UNIT_BONUS',                 'Amount',   10);
insert or replace into ModifierStrings (ModifierId,     Context,    Text)
values ('PLUS_10_ATTACKING_UNIT_BONUS',                 'Preview',  '+{1_Amount} {LOC_PLUS_10_ATTACKING_UNIT_BONUS_PREVIEW_TEXT}');
-- -- 波斯
update Units set Cost = 70, Maintenance = 2, BaseMoves = 4, Range = 0, Combat = 42, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_PERSIAN_CATAPHRACT';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_PERSIAN_CATAPHRACT';
-- -- 努比亚
update Units set Cost = 100, Maintenance = 2, BaseMoves = 3, Range = 0, Combat = 40, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_NUBIAN_AFRICAN_FOREST_ELEPHANT';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_NUBIAN_AFRICAN_FOREST_ELEPHANT';
-- -- 祖鲁
update UnitReplaces set ReplacesUnitType = 'UNIT_CROSSBOWMAN' where CivUniqueUnitType = 'UNIT_ZULU_ASSEGAI';
update UnitUpgrades set UpgradeUnit = 'UNIT_FIELD_CANNON' where Unit = 'UNIT_ZULU_ASSEGAI';
update Units set PrereqTech = 'TECH_METAL_CASTING' where UnitType = 'UNIT_ZULU_ASSEGAI';
update Units set Cost = 90, Maintenance = 2, BaseMoves = 2, Range = 2, Combat = 32, RangedCombat = 45, StrategicResource = NULL where UnitType = 'UNIT_ZULU_ASSEGAI';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_ZULU_ASSEGAI';
update UnitAbilityModifiers set ModifierId = 'HD_MOVEMENT_ADJACENT_TO_ANTI_CAVALRY' where
    UnitAbilityType = 'ABILITY_ZULU_ASSEGAI' and ModifierId = 'PLUS_4_ASSEGAI_ADJACENCY_COMBAT_BONUS_ATTACH';
insert or replace into Modifiers (ModifierId,      ModifierType,                            SubjectRequirementSetId)
values ('HD_MOVEMENT_ADJACENT_TO_ANTI_CAVALRY',    'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',  'HD_NEAR_ANTI_CAVALRY_REQUIREMENTS');
insert or replace into ModifierArguments (ModifierId,   Name,       Value)
values ('HD_MOVEMENT_ADJACENT_TO_ANTI_CAVALRY',         'Amount',   1);
-- -- 苏格兰
update Units set PrereqTech = 'TECH_APPRENTICESHIP' where UnitType = 'UNIT_SCOTTISH_GALLOWGLASS';
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 48, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_SCOTTISH_GALLOWGLASS';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_SCOTTISH_GALLOWGLASS';
-- -- 蒙古
update Units set Cost = 120, Maintenance = 3, BaseMoves = 2, Range = 2, Combat = 38, Bombard = 48, StrategicResource = NULL where UnitType = 'UNIT_MONGOLIAN_HUI_HUI_PAO';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MONGOLIAN_HUI_HUI_PAO';
delete from TypeTags where Type = 'ABILITY_RECEIVE_HUI_HUI_PAO_BONUS';
insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId) values ('ABILITY_GRANT_HUI_HUI_PAO_BONUS', 'HD_SIEGE_CAVALRY_MOVEMENT');
insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId) values ('ABILITY_GRANT_HUI_HUI_PAO_BONUS', 'HD_SIEGE_CAVALRY_STRENGTH');
insert or replace into Modifiers (ModifierId,   ModifierType,                            SubjectRequirementSetId)
values ('HD_SIEGE_CAVALRY_STRENGTH',            'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',  'HD_NEAR_CAVALRY_REQUIREMENTS');
insert or replace into ModifierArguments (ModifierId,   Name,       Value)
values ('HD_SIEGE_CAVALRY_STRENGTH',                    'Amount',   3);
insert or replace into ModifierStrings (ModifierId,     Context,    Text)
values ('HD_SIEGE_CAVALRY_STRENGTH',                    'Preview',  '+{1_Amount} {LOC_HD_SIEGE_CAVALRY_STRENGTH_PREVIEW_TEXT}');
-- -- 马普切
update Units set PrereqTech = NULL, PrereqCivic = 'CIVIC_MILITARY_TRAINING', PromotionClass = 'PROMOTION_CLASS_RECON' where UnitType = 'UNIT_MAPUCHE_GUERILLA';
update Units set Cost = 75, Maintenance = 2, BaseMoves = 3, Range = 1, Combat = 40, RangedCombat = 30, StrategicResource = NULL where UnitType = 'UNIT_MAPUCHE_GUERILLA';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MAPUCHE_GUERILLA';
update TypeTags set Tag = 'CLASS_RECON' where Type = 'UNIT_MAPUCHE_GUERILLA' and Tag = 'CLASS_ANTI_CAVALRY';
delete from UnitAiInfos where UnitType = 'UNIT_MAPUCHE_GUERILLA' and AiType = 'UNITTYPE_ANTI_CAVALRY';
insert or ignore into UnitAIInfos (UnitType, AiType) values ('UNIT_MAPUCHE_GUERILLA', 'UNITTYPE_RANGED');
update UnitReplaces set ReplacesUnitType = 'UNIT_SKIRMISHER' where CivUniqueUnitType = 'UNIT_MAPUCHE_GUERILLA';
update UnitUpgrades set UpgradeUnit = 'UNIT_RANGER' where Unit = 'UNIT_MAPUCHE_GUERILLA';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_MAPUCHE_GUERILLA' and ModifierId = 'NAGAO_FOREST_MOVEMENT';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_MAPUCHE_GUERILLA' and ModifierId = 'JUNGLE_MOVEMENT';
insert or replace into UnitAbilityModifiers (UnitAbilityType,   ModifierId) values ('ABILITY_MAPUCHE_GUERILLA', 'IGNOREZOC_IGNORE_ZOC');
insert or replace into UnitAbilityModifiers (UnitAbilityType,   ModifierId) values ('ABILITY_MAPUCHE_GUERILLA', 'SPYGLASS_BONUS_SIGHT');
-- -- 朝鲜
update Units set Cost = 180, Maintenance = 4, BaseMoves = 4, Range = 0, Combat = 58, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_KOREAN_TURTLE_SHIP';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_KOREAN_TURTLE_SHIP';
-- -- 高棉
update Units set Cost = 40, Maintenance = 1, BaseMoves = 4, Range = 0, Combat = 33, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_KHMER_WAR_CANOE';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_KHMER_WAR_CANOE';
-- -- 格鲁吉亚
update Units set Cost = 130, Maintenance = 3, BaseMoves = 4, Range = 0, Combat = 56, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_GEORGIAN_TADZREULI';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_GEORGIAN_TADZREULI';
-- -- 荷兰
update Units set Cost = 90, Maintenance = 2, BaseMoves = 2, Range = 0, Combat = 55, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_DUTCH_SCHUTTERIJ';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_DUTCH_SCHUTTERIJ';
-- -- 克里
update Units set Cost = 200, Maintenance = 5, BaseMoves = 5, Range = 0, Combat = 62, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_CREE_OTEHTAPIW';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_CREE_OTEHTAPIW';
-- -- 印尼
update Units set Cost = 60, Maintenance = 2, BaseMoves = 3, Range = 0, Combat = 38, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_INDONESIAN_KRIS_SWORDSMAN';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_INDONESIAN_KRIS_SWORDSMAN';
-- -- 加拿大
update Units set Cost = 670, Maintenance = 7, BaseMoves = 5, Range = 0, Combat = 90, RangedCombat = 0, StrategicResource = 'RESOURCE_COAL' where UnitType = 'UNIT_CANADA_HMCS_HAIDA';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_CANADA_HMCS_HAIDA';
-- -- 匈牙利
update Units set Cost = 90, Maintenance = 3, BaseMoves = 3, Range = 2, Combat = 32, RangedCombat = 47, StrategicResource = NULL where UnitType = 'UNIT_HUNGARY_KALANDOZO';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_HUNGARY_KALANDOZO';
delete from TypeTags where Type = 'ABILITY_LESS_MOVEMENT_PILLAGE' and Tag = 'CLASS_HUNGARY_KALANDOZO';
-- -- 印加
delete from Route_ValidBuildUnits where UnitType = 'UNIT_INCA_CHASQUI';
insert or replace into Improvement_ValidBuildUnits (ImprovementType, UnitType) values ('IMPROVEMENT_MOUNTAIN_ROAD', 'UNIT_INCA_CHASQUI');
-- -- 马里
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 2, Combat = 32, RangedCombat = 42, StrategicResource = NULL where UnitType = 'UNIT_MALI_SOFA';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MALI_SOFA';
-- -- 毛利
update Units set PrereqTech = 'TECH_GUNPOWDER' where UnitType = 'UNIT_MAORI_TUPARA';
-- update Units set Cost = 140, Maintenance = 4, BaseMoves = 3, Range = 1, Combat = 50, RangedCombat = 40, StrategicResource = NULL where UnitType = 'UNIT_ARQUEBUSIER';
-- update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_ARQUEBUSIER';
update Units set Cost = 180, Maintenance = 5, BaseMoves = 3, Range = 1, Combat = 55, RangedCombat = 45, StrategicResource = NULL where UnitType = 'UNIT_MAORI_TUPARA';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MAORI_TUPARA';
-- -- 奥斯曼
update Units set Cost = 130, Maintenance = 3, BaseMoves = 4, Range = 0, Combat = 56, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_OTTOMAN_SIPAHI';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_OTTOMAN_SIPAHI';
-- -- 腓尼基
update Units set Cost = 65, Maintenance = 2, BaseMoves = 4, Range = 1, Combat = 35, RangedCombat = 31, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_PHOENICIA_NUMIDIAN_CAVALRY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_PHOENICIA_NUMIDIAN_CAVALRY';
-- -- 瑞典
update Units set Cost = 200, Maintenance = 5, BaseMoves = 5, Range = 0, Combat = 64, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_SWEDEN_HAKKAPELIITTA';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_SWEDEN_HAKKAPELIITTA';
delete from TypeTags where Type = 'ABILITY_SWEDEN_HAKKAPELIITTA' and Tag = 'CLASS_SWEDEN_HAKKAPELIITTA';
-- -- 埃利诺
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 45, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_ELEANOR_TEMPLAR';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ELEANOR_TEMPLAR';
-- -- 玛雅
update Units set PrereqTech = NULL, PrereqCivic = 'CIVIC_FEUDALISM' where UnitType = 'UNIT_MAYAN_HOLKAN';
update Units set Cost = 90, Maintenance = 3, BaseMoves = 2, Range = 0, Combat = 50, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_MAYAN_HOLKAN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_MAYAN_HOLKAN';
delete from TypeTags where Type = 'ABILITY_UNIT_BONUS_VERSUS_CITY_STATES' and Tag = 'CLASS_MAYAN_HOLKAN';
-- -- 大哥伦比亚
update Units set Cost = 210, Maintenance = 5, BaseMoves = 2, Range = 0, Combat = 68, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_COLOMBIAN_BRITISH_LEGION';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_COLOMBIAN_BRITISH_LEGION';
-- -- 埃塞俄比亚
update Units set Cost = 210, Maintenance = 5, BaseMoves = 2, Range = 0, Combat = 68, RangedCombat = 0, StrategicResource = 'RESOURCE_NITER' where UnitType = 'UNIT_ETHIOPIAN_MEHAL_SEFARI';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_NITER', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_ETHIOPIAN_MEHAL_SEFARI';
update ModifierArguments set Value = 10 where ModifierId = 'PLUS_X_VERSUS_STRONGER_UNITS' and Name = 'Amount';
insert or replace into ModifierStrings (ModifierId,     Context,    Text)
values ('PLUS_X_VERSUS_STRONGER_UNITS',                 'Preview',  '+{1_Amount} {LOC_PLUS_X_VERSUS_STRONGER_UNITS_PREVIEW_TEXT}');
-- -- 拜占庭
update Units set PrereqTech = 'TECH_METAL_CASTING', PurchaseYield = 'YIELD_FAITH' where UnitType = 'UNIT_BYZANTINE_VARANGIAN_GUARD';
update Units set Cost = 90, Maintenance = 3, BaseMoves = 3, Range = 0, Combat = 46, RangedCombat = 0, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_BYZANTINE_VARANGIAN_GUARD';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_BYZANTINE_VARANGIAN_GUARD';
-- -- 高卢
update Units set Cost = 55, Maintenance = 1, BaseMoves = 3, Range = 0, Combat = 35, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_GAUL_CARRUS';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_GAUL_CARRUS';
delete from TypeTags where Type = 'ABILITY_PLUS_X_VS_ANTI_CAVALRY' and Tag = 'CLASS_GAUL_CARRUS';
-- -- 巴比伦
update Units set PrereqTech = NULL where UnitType = 'UNIT_BABYLONIAN_BOWMAN';
update Units set Cost = 45, Maintenance = 1, BaseMoves = 2, Range = 2, Combat = 13, RangedCombat = 23, StrategicResource = NULL where UnitType = 'UNIT_BABYLONIAN_BOWMAN';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_BABYLONIAN_BOWMAN';
insert or replace into TypeTags (Type, Tag) select UnitType, 'CLASS_HD_GAIN_SCIENCE_WHEN_KILLS'
from Units where UnitType = 'UNIT_BABYLONIAN_BOWMAN';
update Modifiers set SubjectRequirementSetId = 'URBAN_RAIDER_REQUIREMENTS' where ModifierId = 'PLUS_X_DISTRICT_ATTACK';
-- -- 越南
update Units set Cost = 270, Maintenance = 6, BaseMoves = 3, Range = 0, Combat = 78, RangedCombat = 0, StrategicResource = NULL where UnitType = 'UNIT_VIETNAMESE_VIETCONG';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_VIETNAMESE_VIETCONG';
-- 葡萄牙
-- update Units set PrereqTech = 'TECH_CASTLES' where UnitType = 'UNIT_SPANISH_JINETE';
-- update Units set Cost = 100, Maintenance = 3, BaseMoves = 5, Range = 1, Combat = 46, RangedCombat = 33, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_SPANISH_JINETE';
-- update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_HORSES', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_SPANISH_JINETE';
update Units set Cost = 130, Maintenance = 3, BaseMoves = 4, Range = 0, Combat = 56, RangedCombat = 0, StrategicResource = 'RESOURCE_HORSES' where UnitType = 'UNIT_PORTUGUESE_KNIGHT_OF_AVIZ';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_IRON', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_PORTUGUESE_KNIGHT_OF_AVIZ';

---------------------------------------------------------------------------------------------------
-- Unit ability
insert or replace into Types
    (Type,                                                      Kind)
values
    ('ABILITY_GREEK_PELTAST',                                   'KIND_ABILITY');

insert or replace into UnitAbilities
    (UnitAbilityType,               Description,                                    Inactive)
values
    ('ABILITY_GREEK_PELTAST',       'LOC_ABILITY_GREEK_PELTAST_DESCRIPTION',        0);

insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                               ModifierId)
values
    ('ABILITY_GREEK_PELTAST',                       'PELTAST_NEIGHBOR_COMBAT_HD');

insert or replace into Modifiers
    (ModifierId,                                    ModifierType,                               SubjectRequirementSetId)
values
    ('PELTAST_NEIGHBOR_COMBAT_HD',                  'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',     'PELTAST_PLOT_IS_PELTAST_REQUIREMENTS'),
    ('PELTAST_NEIGHBOR_COMBAT_HD_MODIFIER',         'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     NULL);

insert or replace into ModifierArguments
    (ModifierId,                                    Name,               Value)
values
    ('PELTAST_NEIGHBOR_COMBAT_HD',                  'ModifierId',       'PELTAST_NEIGHBOR_COMBAT_HD_MODIFIER'),
    ('PELTAST_NEIGHBOR_COMBAT_HD_MODIFIER',         'Amount',           10);

insert or replace into ModifierStrings
    (ModifierId,                                    Context,    Text)
values
    ('PELTAST_NEIGHBOR_COMBAT_HD_MODIFIER',         'Preview',  '+{1_Amount} {LOC_PELTAST_NEIGHBOR_COMBAT_HD_PREVIEW_TEXT}');

------------------------------------------------------------------------------------------------
-- Requirements
insert or replace into RequirementSets
    (RequirementSetId,                                  RequirementSetType)
values
    ('PELTAST_PLOT_IS_PELTAST_REQUIREMENTS',            'REQUIREMENTSET_TEST_ALL');

insert or replace into RequirementSetRequirements
    (RequirementSetId,                                  RequirementId)
values
    ('PELTAST_PLOT_IS_PELTAST_REQUIREMENTS',            'HD_REQUIRES_UNIT_NEXT_TO_PELTAST');

insert or ignore into Requirements
    (RequirementId,                                 RequirementType)
values
    ('HD_REQUIRES_UNIT_NEXT_TO_PELTAST',            'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TYPE_MATCHES');

insert or ignore into RequirementArguments
    (RequirementId,                                 Name,               Value)
values
    ('HD_REQUIRES_UNIT_NEXT_TO_PELTAST',            'UnitType',         'UNIT_GREEK_PELTAST');


-- insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId)
-- select from UnitAbilities where UnitAbilityType = 'ABILITY_JAGUAR'

------------------------------------------------------------------------------------------------
-- Requirements
insert or replace into RequirementSets
    (RequirementSetId,                                  RequirementSetType)
values
    ('UNIT_IS_ADJACENT_JAGUAR_REQUIREMENTS',            'REQUIREMENTSET_TEST_ALL'),
    ('UNIT_IS_ADJACENT_EAGLE_WARRIOR_REQUIREMENTS',     'REQUIREMENTSET_TEST_ALL');

insert or replace into RequirementSetRequirements
    (RequirementSetId,                                  RequirementId)
values
    ('UNIT_IS_ADJACENT_JAGUAR_REQUIREMENTS',            'ADJACENT_TO_OWNER'),
    ('UNIT_IS_ADJACENT_EAGLE_WARRIOR_REQUIREMENTS',     'ADJACENT_TO_OWNER');

insert or replace into RequirementSetRequirements (RequirementSetId, RequirementId) select
    'UNIT_IS_ADJACENT_JAGUAR_REQUIREMENTS',            'REQUIRES_UNIT_IS_UNIT_AZTEC_JAGUAR'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');
insert or replace into RequirementSetRequirements (RequirementSetId, RequirementId) select
    'UNIT_IS_ADJACENT_EAGLE_WARRIOR_REQUIREMENTS',     'REQUIRES_UNIT_IS_UNIT_AZTEC_EAGLE_WARRIOR'
where exists (select UnitType from Units where UnitType = 'UNIT_AZTEC_JAGUAR');

------------------------------------------------------------------------------------------------
-- fix a bug for Canada 
insert or ignore into RequirementSetRequirements 
    (RequirementSetId, RequirementId)
values
    ('PLOT_HAS_SNOW_MINE_REQUIREMENTS',            'REQUIRES_PLOT_HAS_SNOW'),
    ('PLOT_HAS_SNOW_CAMP_REQUIREMENTS',            'REQUIRES_PLOT_HAS_SNOW'),
    ('PLOT_HAS_SNOW_FARM_REQUIREMENTS',            'REQUIRES_PLOT_HAS_SNOW'),
    ('PLOT_HAS_SNOW_LUMBER_MILL_REQUIREMENTS',     'REQUIRES_PLOT_HAS_SNOW');

-- 圣殿骑士 by xiaoxiao
insert or replace into Tags
    (Tag,                       Vocabulary)
values
    ('CLASS_ELEANOR_TEMPLAR',   'ABILITY_CLASS');
insert or replace into Types 
	(Type, 												Kind)
values
	('ABILITY_BLOCK_FIRST_NON_LETHAL_ATTACK_EACH_TURN',	'KIND_ABILITY');
insert or replace into TypeTags
    (Type,                                              Tag)
values
    ('UNIT_ELEANOR_TEMPLAR',                            'CLASS_ELEANOR_TEMPLAR'),
    ('ABILITY_BLOCK_FIRST_NON_LETHAL_ATTACK_EACH_TURN', 'CLASS_ELEANOR_TEMPLAR');
insert or replace into UnitAbilities
	(UnitAbilityType, Name, Description, Inactive)
values
	('ABILITY_BLOCK_FIRST_NON_LETHAL_ATTACK_EACH_TURN',
    'LOC_ABILITY_BLOCK_FIRST_NON_LETHAL_ATTACK_EACH_TURN_NAME',
    'LOC_ABILITY_BLOCK_FIRST_NON_LETHAL_ATTACK_EACH_TURN_DESCRIPTION',
    0);

--删除埃及的弯刀战士
delete from CivilizationTraits where CivilizationType = 'CIVILIZATION_EGYPT' and TraitType = 'TRAIT_CIVILIZATION_UNIT_EGYPTIAN_KHOPESH';

--拜占庭UU
update Units set PurchaseYield = 'YIELD_GOLD' where UnitType = 'UNIT_BYZANTINE_VARANGIAN_GUARD';
insert or replace into TraitModifiers
    (TraitType,                                             ModifierId)
select
    'TRAIT_CIVILIZATION_UNIT_BYZANTINE_VARANGIAN_GUARD',   'UNIT_BYZANTINE_VARANGIAN_GUARD_FAITH_PURCHASE'
where exists (select Type from Types where Type = 'TRAIT_CIVILIZATION_UNIT_BYZANTINE_VARANGIAN_GUARD');
insert or replace into Modifiers
    (ModifierId,                                            ModifierType)
values
    ('UNIT_BYZANTINE_VARANGIAN_GUARD_FAITH_PURCHASE',       'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
insert or replace into ModifierArguments
    (ModifierId,	                                        Name,       Value)
values
    ('UNIT_BYZANTINE_VARANGIAN_GUARD_FAITH_PURCHASE',       'Tag',      'CLASS_BYZANTINE_VARANGIAN_GUARD');
