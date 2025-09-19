-----------------------------------------------
-- City-States Start with Walls (from CSE Game Mode)
-----------------------------------------------

INSERT OR IGNORE INTO TraitModifiers (TraitType, ModifierId)
SELECT  'MINOR_CIV_DEFAULT_TRAIT',
        'MODIFIER_CSE_DEFAULT_FREE_WALLS';

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent)
VALUES  ('MODIFIER_CSE_DEFAULT_FREE_WALLS', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 0, 0),
        ('MODIFIER_CSE_DEFAULT_FREE_WALLS_MOD', 'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE', 1, 1);

INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
VALUES  ('MODIFIER_CSE_DEFAULT_FREE_WALLS', 'ModifierId', 'MODIFIER_CSE_DEFAULT_FREE_WALLS_MOD'),
        ('MODIFIER_CSE_DEFAULT_FREE_WALLS_MOD', 'BuildingType', 'BUILDING_WALLS');
