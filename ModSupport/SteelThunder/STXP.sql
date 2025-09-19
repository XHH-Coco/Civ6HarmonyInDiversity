-------------------------------------
--     Adaptation for the Mod      --
-------------------------------------

-- To Fix for Apr update.
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) values ('UNIT_JAPANESE_SAMURAI', 'UNIT_MAN_AT_ARMS');
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) values ('UNIT_ENGLISH_REDCOAT', 'UNIT_LINE_INFANTRY');
insert or replace into UnitReplaces (CivUniqueUnitType, ReplacesUnitType) values ('UNIT_FRENCH_GARDE_IMPERIALE', 'UNIT_LINE_INFANTRY');
-- UPDATE Units SET Combat = 41 WHERE UnitType = 'UNIT_ROMAN_LEGION';

/* Revert Unit Upgrade Changes */
update UnitUpgrades set UpgradeUnit = 'UNIT_TREBUCHET' where UpgradeUnit = 'UNIT_DLV_TREBUCHET';
update UnitUpgrades set UpgradeUnit = 'UNIT_LINE_INFANTRY' where UpgradeUnit = 'UNIT_DLV_RIFLEMAN';
update UnitUpgrades set UpgradeUnit = 'UNIT_MAN_AT_ARMS' where UpgradeUnit = 'UNIT_DLV_LONGSWORDSMAN';

delete from UnitReplaces where ReplacesUnitType = 'UNIT_DLV_TREBUCHET';
delete from UnitReplaces where ReplacesUnitType = 'UNIT_DLV_LONGSWORDSMAN';
delete from UnitReplaces where ReplacesUnitType = 'UNIT_DLV_RIFLEMAN';

delete from Types where Type = 'UNIT_DLV_RIFLEMAN';
delete from Types where Type = 'UNIT_DLV_TREBUCHET';
delete from Types where Type = 'UNIT_DLV_LONGSWORDSMAN';

-- Adaptation
-- delete from UnitReplaces where CivUniqueUnitType = 'UNIT_SUMERIAN_WAR_CART';
update UnitUpgrades set UpgradeUnit = 'UNIT_DLV_COG' where Unit = 'UNIT_PHOENICIA_BIREME';

delete from Types where Type = 'ABILITY_CITY_CENTER_NERF';
delete from Types where Type = 'ABILITY_PLUS_X_WHEN_DEFENDING';
delete from Types where Type = 'ABILITY_AUTOMATIC_GUNFIRE';
delete from Types where Type = 'ABILITY_PRE_GUNPOWDER_MELEE_ATTACK';

delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_ANTI_CAVALRY' and ModifierId = 'PLUS_20_VS_HEAVY_CAVALRY_COMBAT_BONUS';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_ANTI_CAVALRY' and ModifierId = 'PLUS_15_VS_LIGHT_CAVALRY_COMBAT_BONUS';
insert or ignore into UnitAbilityModifiers (UnitAbilityType, ModifierId) values ('ABILITY_ANTI_CAVALRY', 'ANTI_CAVALRY_COMBAT_BONUS');

update Units set PrereqTech = 'TECH_SQUARE_SAIL_HD' where UnitType = 'UNIT_DLV_COG';
update Units set PrereqTech = 'TECH_COMPASS_HD', Range = 2 where UnitType = 'UNIT_DLV_GALLEASS';
update ModifierArguments set Value = 10 where ModifierId = 'CONQUISTADOR_SPECIFIC_UNIT_COMBAT' and Name = 'Amount';
update UnitReplaces set ReplacesUnitType = 'UNIT_DLV_GALLEASS' where CivUniqueUnitType = 'UNIT_BYZANTINE_DROMON';

-- unit types and promotion updates
update Units set PrereqTech = 'TECH_REPLACEABLE_PARTS' where UnitType = 'UNIT_DLV_MORTAR';
update Units set PrereqTech = 'TECH_ADVANCED_BALLISTICS' where UnitType = 'UNIT_DLV_SELF_PROPELLED_ARTILLERY';
update Units set Cost = 310, Maintenance = 6, BaseMoves = 3, Range = 2, Combat = 60, RangedCombat = 70, StrategicResource = NULL where UnitType = 'UNIT_DLV_MORTAR';
update Units_XP2 set ResourceCost = 0, ResourceMaintenanceType = NULL, ResourceMaintenanceAmount = 0 where UnitType = 'UNIT_DLV_MORTAR';
update Units set Cost = 640, Maintenance = 10, BaseMoves = 3, Range = 3, Combat = 70, Bombard = 90, StrategicResource = 'RESOURCE_IRON' where UnitType = 'UNIT_DLV_SELF_PROPELLED_ARTILLERY';
update Units_XP2 set ResourceCost = 5, ResourceMaintenanceType = 'RESOURCE_OIL', ResourceMaintenanceAmount = 1 where UnitType = 'UNIT_DLV_SELF_PROPELLED_ARTILLERY';
update Units set RangedCombat = 0 where UnitType = 'UNIT_ROCKET_ARTILLERY';

delete from UnitUpgrades where Unit = 'UNIT_MACHINE_GUN';
delete from Types where Type = 'UNIT_DLV_GATLING_GUN';
update UnitUpgrades set UpgradeUnit = 'UNIT_MACHINE_GUN' where Unit = 'UNIT_DLV_MORTAR';

insert or replace into UnitUpgrades (UpgradeUnit, Unit) values ('UNIT_ROCKET_ARTILLERY',    'UNIT_DLV_SELF_PROPELLED_ARTILLERY');
update Units set PromotionClass = 'PROMOTION_CLASS_SIEGE' where UnitType = 'UNIT_ROCKET_ARTILLERY';
delete from TypeTags where Type = 'UNIT_ROCKET_ARTILLERY' and Tag like 'CLASS_%';
insert or ignore into TypeTags select 'UNIT_ROCKET_ARTILLERY', Tag from TypeTags where Type = 'UNIT_ARTILLERY' and Tag like 'CLASS_%';

--
update UnitReplaces set ReplacesUnitType = 'UNIT_DLV_GALLEASS' where CivUniqueUnitType = 'UNIT_INDONESIAN_JONG';
update UnitUpgrades set UpgradeUnit = 'UNIT_FRIGATE' where Unit = 'UNIT_INDONESIAN_JONG';