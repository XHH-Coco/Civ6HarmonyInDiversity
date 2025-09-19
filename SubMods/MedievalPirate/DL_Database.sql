
insert or replace into Types (Type,  Kind) values ('UNIT_DL_MEDIEVAL_PIRATE',   'KIND_UNIT');

insert or replace into Units
    (UnitType,                  Name,                               Description,                                PrereqTech,        MandatoryObsoleteTech,
    BaseSightRange, BaseMoves,   Combat, RangedCombat,   Range,  Cost,   ZoneOfControl,  PurchaseYield, Domain,
    FormationClass,             PromotionClass,                 PseudoYieldType,                    AdvisorType)
values
    ('UNIT_DL_MEDIEVAL_PIRATE', 'LOC_UNIT_DL_MEDIEVAL_PIRATE_NAME', 'LOC_UNIT_DL_MEDIEVAL_PIRATE_DESCRIPTION',  'TECH_SQUARE_SAIL_HD',    'TECH_LASERS',
    2,              4,           30,     40,             1,      180,    1,              'YIELD_GOLD',  'DOMAIN_SEA',
    'FORMATION_CLASS_NAVAL',    'PROMOTION_CLASS_NAVAL_RAIDER', 'PSEUDOYIELD_UNIT_NAVAL_COMBAT',    'ADVISOR_CONQUEST');

insert or replace into TypeTags
    (Type,  Tag)
values
    ('UNIT_DL_MEDIEVAL_PIRATE',    'CLASS_NAVAL_RAIDER'),
    ('UNIT_DL_MEDIEVAL_PIRATE',    'CLASS_NAVAL_RANGED'),
    ('UNIT_DL_MEDIEVAL_PIRATE',    'CLASS_STEALTH'),
    ('UNIT_DL_MEDIEVAL_PIRATE',    'CLASS_REVEAL_STEALTH');

insert or replace into UnitUpgrades (Unit,  UpgradeUnit) values ('UNIT_DL_MEDIEVAL_PIRATE', 'UNIT_PRIVATEER');

insert or replace into UnitReplaces (CivUniqueUnitType,  ReplacesUnitType) values ('UNIT_OTTOMAN_BARBARY_CORSAIR', 'UNIT_DL_MEDIEVAL_PIRATE');

insert or replace into UnitAiInfos
    (UnitType,                  AiType)
values
    ('UNIT_DL_MEDIEVAL_PIRATE', 'UNITAI_COMBAT'),
    ('UNIT_DL_MEDIEVAL_PIRATE', 'UNITTYPE_RANGED'),
    ('UNIT_DL_MEDIEVAL_PIRATE', 'UNITTYPE_NAVAL');
