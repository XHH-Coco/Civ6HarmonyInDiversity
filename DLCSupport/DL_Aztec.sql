-------------------------------------
--             Aztec DLC           --
-------------------------------------

delete from TraitModifiers where TraitType = 'TRAIT_LEADER_GIFTS_FOR_TLATOANI' and 'TRAIT_COMBAT_BONUS_PER_LUXURY';
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_GIFTS_FOR_TLATOANI' and 'TRAIT_OWNED_LUXURY_EXTRA_AMENITIES';

insert or replace into TraitModifiers (TraitType, ModifierId) values 
    ('TRAIT_CIVILIZATION_LEGEND_FIVE_SUNS', 'TRAIT_COMBAT_BONUS_PER_LUXURY'),
    ('TRAIT_CIVILIZATION_LEGEND_FIVE_SUNS', 'TRAIT_OWNED_LUXURY_EXTRA_AMENITIES'),
    -- ('TRAIT_LEADER_GIFTS_FOR_TLATOANI',      'TRAIT_LEADER_FAITH_KILLS'),
    ('TRAIT_LEADER_GIFTS_FOR_TLATOANI',     'TRAIT_LEADER_MELEE_CAPTIVE_WORKERS');

insert or replace into Modifiers (ModifierId,   ModifierType) values
    ('TRAIT_LEADER_MELEE_CAPTIVE_WORKERS',      'MODIFIER_PLAYER_UNITS_GRANT_ABILITY');

insert or replace into ModifierArguments (ModifierId,   Name,   Value) values
    ('TRAIT_LEADER_MELEE_CAPTIVE_WORKERS',      'AbilityType',   'ABILITY_CAPTIVE_WORKERS');

update UnitAbilities set Inactive = 1 where UnitAbilityType = 'ABILITY_CAPTIVE_WORKERS';

insert or replace into TypeTags (Type, Tag)
    select UnitType,    'CLASS_CAPTURE_WORKER' from Units where PromotionClass = 'PROMOTION_CLASS_MELEE';

update Units set Cost = 65 where UnitType = 'UNIT_AZTEC_EAGLE_WARRIOR';
update UnitUpgrades set UpgradeUnit='UNIT_MAN_AT_ARMS' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_AZTEC_EAGLE_WARRIOR');
update UnitUpgrades set UpgradeUnit='UNIT_MAN_AT_ARMS' where Unit=(select Unit from UnitUpgrades where Unit='UNIT_AZTEC_JAGUAR');