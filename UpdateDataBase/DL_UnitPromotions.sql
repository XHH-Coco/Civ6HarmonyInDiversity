-------------------------------------
--         Unit Promostions        --
-------------------------------------

-- Tech and Civic Promotion
update Civics set Description = 'LOC_CIVIC_DEFENSIVE_TACTICS_HD_DESCRIPTION' where CivicType = 'CIVIC_DEFENSIVE_TACTICS';
update Civics set Description = 'LOC_CIVIC_MILITARY_TRAINING_HD_DESCRIPTION' where CivicType = 'CIVIC_MILITARY_TRAINING';
update Civics set Description = 'LOC_CIVIC_MERCENARIES_HD_DESCRIPTION' where CivicType = 'CIVIC_MERCENARIES';
update Civics set Description = 'LOC_CIVIC_MERCANTILISM_HD_DESCRIPTION' where CivicType ='CIVIC_MERCANTILISM';
update Civics set Description = 'LOC_CIVIC_SCORCHED_EARTH_HD_DESCRIPTION' where CivicType ='CIVIC_SCORCHED_EARTH';
update Technologies set Description = 'LOC_TECH_SHIPBUILDING_HD_DESCRIPTION' where TechnologyType ='TECH_SHIPBUILDING';
update Technologies set Description = 'LOC_TECH_MILITARY_TACTICS_HD_DESCRIPTION' where TechnologyType ='TECH_MILITARY_TACTICS';
update Technologies set Description = 'LOC_TECH_GUNPOWDER_HD_DESCRIPTION' where TechnologyType ='TECH_GUNPOWDER';
update Technologies set Description = 'LOC_TECH_RIFLING_HD_DESCRIPTION' where TechnologyType ='TECH_RIFLING';
-- update Technologies set Description = 'LOC_TECH_SANITATION_HD_DESCRIPTION' where TechnologyType ='TECH_SANITATION';

insert or replace into Types
    (Type,                                                      Kind)
values
    ('ABILITY_MELEE_BATTLE_LINE_HD',                            'KIND_ABILITY'),
    ('ABILITY_RANGED_HILLS_STRENGTH_HD',                        'KIND_ABILITY'),
    ('ABILITY_ANTIC_IGNORE_DAMAGED_STRENGTH_REDUCTION_HD',      'KIND_ABILITY'),
    ('ABILITY_RECON_IGNORE_RIVERS_AND_SHORES_HD',               'KIND_ABILITY'),
    ('ABILITY_HEAVYC_HEAL_AFTER_KILL_HD',                       'KIND_ABILITY'),
    ('ABILITY_LIGHTC_AGAINST_UNIT_BONUS_HD',                    'KIND_ABILITY'),
    ('ABILITY_SIEGE_ATTACK_DISTRICT_BONUS_HD',                  'KIND_ABILITY'),
    ('ABILITY_MELEE_FOREST_AND_JUNGLE_COMBAT_BONUS_HD',         'KIND_ABILITY'),
    ('ABILITY_RANGED_GARRISON_BONUS_HD',                        'KIND_ABILITY'),
    ('ABILITY_ANTIC_HILLS_DEFEND_BONUS_HD',                     'KIND_ABILITY'),
    ('ABILITY_RECON_IGNORE_ZOC_HD',                             'KIND_ABILITY'),
    ('ABILITY_HEAVYC_OPEN_AREA_STRENGTH_HD',                    'KIND_ABILITY'),
    -- ('ABILITY_LIGHTC_EXTRA_FAITH_PLUNDER_HD',                   'KIND_ABILITY'),
    ('ABILITY_LIGHTC_ENEMY_MOVEMENT_HD',                        'KIND_ABILITY'),
    ('ABILITY_SIEGE_ATTACK_AFTER_MOVE_HD',                      'KIND_ABILITY'),
    ('ABILITY_SCOUNT_IGNORE_ALL_HD',                            'KIND_ABILITY');

insert or replace into TechnologyModifiers
    (TechnologyType,                                        ModifierId)
values
    ('TECH_SQUARE_SAIL_HD',                                 'HD_NAVAL_MELEE_ESCORT_MOBILITY_SHARED_MOVEMENT'),
    -- 
    ('TECH_MILITARY_TACTICS',                               'HD_MELEE_BATTLE_LINE'),
    ('TECH_MILITARY_TACTICS',                               'HD_RANGED_HILLS_STRENGTH'),
    ('TECH_MILITARY_TACTICS',                               'HD_ANTIC_IGNORE_DAMAGED_STRENGTH_REDUCTION'),
    ('TECH_SHIPBUILDING',                                   'HD_RECON_IGNORE_RIVERS_AND_SHORES'),
    ('TECH_GUNPOWDER',                                      'HD_HEAVYC_HEAL_AFTER_KILL'),
    ('TECH_MILITARY_TACTICS',                               'HD_LIGHTC_AGAINST_UNIT_BONUS'),
    ('TECH_RIFLING',                                        'HD_SIEGE_ATTACK_DISTRICT_BONUS');

insert or replace into CivicModifiers
    (CivicType,                                             ModifierId)
values
    ('CIVIC_CRAFTSMANSHIP',                                 'HD_CIVIC_CRAFTSMANSHIP_SCOUNT_IGNORE_ALL'),
    ('CIVIC_FEUDALISM',                                     'HD_MELEE_FOREST_AND_JUNGLE_COMBAT_BONUS'),
    ('CIVIC_DEFENSIVE_TACTICS',                             'HD_RANGED_GARRISON_BONUS'),
    ('CIVIC_DEFENSIVE_TACTICS',                             'HD_ANTIC_HILLS_DEFEND_BONUS'),
    ('CIVIC_MERCANTILISM',                                  'HD_RECON_IGNORE_ZOC'),
    ('CIVIC_MILITARY_TRAINING',                             'HD_HEAVYC_OPEN_AREA_STRENGTH'),
    -- ('CIVIC_MERCENARIES',                                   'HD_LIGHTC_EXTRA_FAITH_PLUNDER'),
    ('CIVIC_MERCENARIES',                                   'HD_LIGHTC_ENEMY_MOVEMENT'),
    ('CIVIC_MILITARY_TRAINING',                             'HD_SIEGE_ATTACK_AFTER_MOVE');

insert or replace into Modifiers
    (ModifierId,                                            ModifierType)
values
    ('HD_CIVIC_CRAFTSMANSHIP_SCOUNT_IGNORE_ALL',            'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_NAVAL_MELEE_ESCORT_MOBILITY_SHARED_MOVEMENT',      'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    -- 
    ('HD_MELEE_BATTLE_LINE',                                'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_RANGED_HILLS_STRENGTH',                            'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_ANTIC_IGNORE_DAMAGED_STRENGTH_REDUCTION',          'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_RECON_IGNORE_RIVERS_AND_SHORES',                   'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_HEAVYC_HEAL_AFTER_KILL',                           'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_LIGHTC_AGAINST_UNIT_BONUS',                        'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_SIEGE_ATTACK_DISTRICT_BONUS',                      'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),

    ('HD_MELEE_FOREST_AND_JUNGLE_COMBAT_BONUS',             'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_RANGED_GARRISON_BONUS',                            'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_ANTIC_HILLS_DEFEND_BONUS',                         'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_RECON_IGNORE_ZOC',                                 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_HEAVYC_OPEN_AREA_STRENGTH',                        'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    -- ('HD_LIGHTC_EXTRA_FAITH_PLUNDER',                       'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_LIGHTC_ENEMY_MOVEMENT',                            'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
    ('HD_SIEGE_ATTACK_AFTER_MOVE',                          'MODIFIER_PLAYER_UNITS_GRANT_ABILITY');

insert or replace into ModifierArguments
    (ModifierId,                                            Name,           Value)
values
    ('HD_CIVIC_CRAFTSMANSHIP_SCOUNT_IGNORE_ALL',            'AbilityType',  'ABILITY_SCOUNT_IGNORE_ALL_HD'),
    ('HD_NAVAL_MELEE_ESCORT_MOBILITY_SHARED_MOVEMENT',      'AbilityType',  'ABILITY_NAVAL_MELEE_ESCORT_MOBILITY_SHARED_MOVEMENT'),
    -- 
    ('HD_MELEE_BATTLE_LINE',                                'AbilityType',  'ABILITY_MELEE_BATTLE_LINE_HD'),
    ('HD_RANGED_HILLS_STRENGTH',                            'AbilityType',  'ABILITY_RANGED_HILLS_STRENGTH_HD'),
    ('HD_ANTIC_IGNORE_DAMAGED_STRENGTH_REDUCTION',          'AbilityType',  'ABILITY_ANTIC_IGNORE_DAMAGED_STRENGTH_REDUCTION_HD'),
    ('HD_RECON_IGNORE_RIVERS_AND_SHORES',                   'AbilityType',  'ABILITY_RECON_IGNORE_RIVERS_AND_SHORES_HD'),
    ('HD_HEAVYC_HEAL_AFTER_KILL',                           'AbilityType',  'ABILITY_HEAVYC_HEAL_AFTER_KILL_HD'),
    ('HD_LIGHTC_AGAINST_UNIT_BONUS',                        'AbilityType',  'ABILITY_LIGHTC_AGAINST_UNIT_BONUS_HD'),
    ('HD_SIEGE_ATTACK_DISTRICT_BONUS',                      'AbilityType',  'ABILITY_SIEGE_ATTACK_DISTRICT_BONUS_HD'),

    ('HD_MELEE_FOREST_AND_JUNGLE_COMBAT_BONUS',             'AbilityType',  'ABILITY_MELEE_FOREST_AND_JUNGLE_COMBAT_BONUS_HD'),
    ('HD_RANGED_GARRISON_BONUS',                            'AbilityType',  'ABILITY_RANGED_GARRISON_BONUS_HD'),
    ('HD_ANTIC_HILLS_DEFEND_BONUS',                         'AbilityType',  'ABILITY_ANTIC_HILLS_DEFEND_BONUS_HD'),
    ('HD_RECON_IGNORE_ZOC',                                 'AbilityType',  'ABILITY_RECON_IGNORE_ZOC_HD'),
    ('HD_HEAVYC_OPEN_AREA_STRENGTH',                        'AbilityType',  'ABILITY_HEAVYC_OPEN_AREA_STRENGTH_HD'),
    -- ('HD_LIGHTC_EXTRA_FAITH_PLUNDER',                       'AbilityType',  'ABILITY_LIGHTC_EXTRA_FAITH_PLUNDER_HD'),
    ('HD_LIGHTC_ENEMY_MOVEMENT',                            'AbilityType',  'ABILITY_LIGHTC_ENEMY_MOVEMENT_HD'),
    ('HD_SIEGE_ATTACK_AFTER_MOVE',                          'AbilityType',  'ABILITY_SIEGE_ATTACK_AFTER_MOVE_HD');

insert or replace into TypeTags
    (Type,                                                      Tag)
values
    ('ABILITY_SCOUNT_IGNORE_ALL_HD',                            'CLASS_RECON'),
    ('ABILITY_MELEE_BATTLE_LINE_HD',                            'CLASS_MELEE'),
    ('ABILITY_RANGED_HILLS_STRENGTH_HD',                        'CLASS_RANGED'),
    ('ABILITY_ANTIC_IGNORE_DAMAGED_STRENGTH_REDUCTION_HD',      'CLASS_ANTI_CAVALRY'),
    ('ABILITY_RECON_IGNORE_RIVERS_AND_SHORES_HD',               'CLASS_RECON'),
    ('ABILITY_HEAVYC_HEAL_AFTER_KILL_HD',                       'CLASS_HEAVY_CAVALRY'),
    ('ABILITY_LIGHTC_AGAINST_UNIT_BONUS_HD',                    'CLASS_LIGHT_CAVALRY'),
    ('ABILITY_SIEGE_ATTACK_DISTRICT_BONUS_HD',                  'CLASS_SIEGE'),
    ('ABILITY_MELEE_FOREST_AND_JUNGLE_COMBAT_BONUS_HD',         'CLASS_MELEE'),
    ('ABILITY_RANGED_GARRISON_BONUS_HD',                        'CLASS_RANGED'),
    ('ABILITY_ANTIC_HILLS_DEFEND_BONUS_HD',                     'CLASS_ANTI_CAVALRY'),
    ('ABILITY_RECON_IGNORE_ZOC_HD',                             'CLASS_RECON'),
    ('ABILITY_HEAVYC_OPEN_AREA_STRENGTH_HD',                    'CLASS_HEAVY_CAVALRY'),
    -- ('ABILITY_LIGHTC_EXTRA_FAITH_PLUNDER_HD',                   'CLASS_LIGHT_CAVALRY'),
    ('ABILITY_LIGHTC_ENEMY_MOVEMENT_HD',                        'CLASS_LIGHT_CAVALRY'),
    ('ABILITY_SIEGE_ATTACK_AFTER_MOVE_HD',                      'CLASS_SIEGE'),
    -- ('ABILITY_MONGOLIAN_KESHIG',                                'CLASS_NAVAL_MELEE'),
    ('ABILITY_SEE_HIDDEN',                                      'CLASS_NAVAL_MELEE');

insert or replace into UnitAbilities 
    (UnitAbilityType,                                           Name,   Description,                                                            Inactive) 
values
    ('ABILITY_SCOUNT_IGNORE_ALL_HD',                            NULL,   'LOC_ABILITY_SCOUNT_IGNORE_ALL_HD_DESCRIPTION',                          1),
    ('ABILITY_MELEE_BATTLE_LINE_HD',                            NULL,   'LOC_ABILITY_MELEE_BATTLE_LINE_HD_DESCRIPTION',                            1),
    ('ABILITY_RANGED_HILLS_STRENGTH_HD',                        NULL,   'LOC_ABILITY_RANGED_HILLS_STRENGTH_HD_DESCRIPTION',                        1),
    ('ABILITY_ANTIC_IGNORE_DAMAGED_STRENGTH_REDUCTION_HD',      NULL,   'LOC_ABILITY_ANTIC_IGNORE_DAMAGED_STRENGTH_REDUCTION_HD_DESCRIPTION',      1),
    ('ABILITY_RECON_IGNORE_RIVERS_AND_SHORES_HD',               NULL,   'LOC_ABILITY_RECON_IGNORE_RIVERS_AND_SHORES_HD_DESCRIPTION',               1),
    ('ABILITY_HEAVYC_HEAL_AFTER_KILL_HD',                       NULL,   'LOC_ABILITY_HEAVYC_HEAL_AFTER_KILL_HD_DESCRIPTION',                       1),
    ('ABILITY_LIGHTC_AGAINST_UNIT_BONUS_HD',                    NULL,   'LOC_ABILITY_LIGHTC_AGAINST_UNIT_BONUS_HD_DESCRIPTION',                    1),
    ('ABILITY_SIEGE_ATTACK_DISTRICT_BONUS_HD',                  NULL,   'LOC_ABILITY_SIEGE_ATTACK_DISTRICT_BONUS_HD_DESCRIPTION',                  1),
    ('ABILITY_MELEE_FOREST_AND_JUNGLE_COMBAT_BONUS_HD',         NULL,   'LOC_ABILITY_MELEE_FOREST_AND_JUNGLE_COMBAT_BONUS_HD_DESCRIPTION',         1),
    ('ABILITY_RANGED_GARRISON_BONUS_HD',                        NULL,   'LOC_ABILITY_RANGED_GARRISON_BONUS_HD_DESCRIPTION',                        1),
    ('ABILITY_ANTIC_HILLS_DEFEND_BONUS_HD',                     NULL,   'LOC_ABILITY_ANTIC_HILLS_DEFEND_BONUS_HD_DESCRIPTION',                     1),
    ('ABILITY_RECON_IGNORE_ZOC_HD',                             NULL,   'LOC_ABILITY_RECON_IGNORE_ZOC_HD_DESCRIPTION',                             1),
    ('ABILITY_HEAVYC_OPEN_AREA_STRENGTH_HD',                    NULL,   'LOC_ABILITY_HEAVYC_OPEN_AREA_STRENGTH_HD_DESCRIPTION',                    1),
    -- ('ABILITY_LIGHTC_EXTRA_FAITH_PLUNDER_HD',                   NULL,   'LOC_ABILITY_LIGHTC_EXTRA_FAITH_PLUNDER_HD_DESCRIPTION',                   1),
    ('ABILITY_LIGHTC_ENEMY_MOVEMENT_HD',                        NULL,   'LOC_ABILITY_LIGHTC_ENEMY_MOVEMENT_HD_DESCRIPTION',                        1),
    ('ABILITY_SIEGE_ATTACK_AFTER_MOVE_HD',                      NULL,   'LOC_ABILITY_SIEGE_ATTACK_AFTER_MOVE_HD_DESCRIPTION',                      1);

insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                                           ModifierId)
values
    ('ABILITY_SCOUNT_IGNORE_ALL_HD',                            'HD_SCOUNT_IGNORE_ALL_HD'),
    ('ABILITY_MELEE_BATTLE_LINE_HD',                            'HD_BATTLE_LINE_COMBAT'),
    ('ABILITY_RANGED_HILLS_STRENGTH_HD',                        'HD_ATTACKING_FROM_HILLS_STRENGTH'),
    ('ABILITY_ANTIC_IGNORE_DAMAGED_STRENGTH_REDUCTION_HD',      'HD_IGNORE_DAMAGED_STRENGTH_REDUCTION'),
    ('ABILITY_RECON_IGNORE_RIVERS_AND_SHORES_HD',               'HD_IGNORE_RIVERS'),
    ('ABILITY_RECON_IGNORE_RIVERS_AND_SHORES_HD',               'HD_IGNORE_SHORES'),
    ('ABILITY_HEAVYC_HEAL_AFTER_KILL_HD',                       'HD_HEAL_AFTER_KILL'),
    ('ABILITY_LIGHTC_AGAINST_UNIT_BONUS_HD',                    'HD_AGAINST_UNIT_BONUS'),
    ('ABILITY_SIEGE_ATTACK_DISTRICT_BONUS_HD',                  'HD_ATTACK_DISTRICT_BONUS'),
    ('ABILITY_MELEE_FOREST_AND_JUNGLE_COMBAT_BONUS_HD',         'HD_FOREST_AND_JUNGLE_COMBAT_BONUS'),
    ('ABILITY_RANGED_GARRISON_BONUS_HD',                        'HD_GARRISON_BONUS'),
    ('ABILITY_ANTIC_HILLS_DEFEND_BONUS_HD',                     'HD_HILLS_DEFEND_BONUS'),
    ('ABILITY_RECON_IGNORE_ZOC_HD',                             'HD_IGNORE_ZOC'),
    ('ABILITY_HEAVYC_OPEN_AREA_STRENGTH_HD',                    'HD_OPEN_AREA_STRENGTH'),
    -- ('ABILITY_LIGHTC_EXTRA_FAITH_PLUNDER_HD',                   'HD_EXTRA_FAITH_PLUNDER_DISTRICT'),
    -- ('ABILITY_LIGHTC_EXTRA_FAITH_PLUNDER_HD',                   'HD_EXTRA_FAITH_PLUNDER_IMPROVEMENT'),
    ('ABILITY_LIGHTC_ENEMY_MOVEMENT_HD',                        'HD_ENEMY_MOVEMENT'),
    ('ABILITY_SIEGE_ATTACK_AFTER_MOVE_HD',                      'HD_ATTACK_AFTER_MOVE');

insert or replace into Modifiers
    (ModifierId,                                ModifierType,                           OwnerRequirementSetId,                      SubjectRequirementSetId)
values
    ('HD_ATTACKING_FROM_HILLS_STRENGTH',        'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'BALKAN_CAVALRY_PLOT_IS_HILS_REQUIREMENTS', 'HD_UNIT_ATTACKING_REQUIREMENTS');

insert or replace into Modifiers
    (ModifierId,                                ModifierType,                                                           SubjectRequirementSetId)
values
    ('HD_SCOUNT_IGNORE_ALL_HD',                 'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_TERRAIN_COST',                      'HD_UNIT_IS_NOT_BARBARIAN_REQUIREMENTS'),
    ('HD_BATTLE_LINE_COMBAT',                   'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                                 'BATTLE_LINE_COMBAT_REQUIREMENTS'),
    ('HD_IGNORE_DAMAGED_STRENGTH_REDUCTION',    'MODIFIER_PLAYER_UNIT_ADJUST_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER',   NULL),
    ('HD_IGNORE_RIVERS',                        'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_RIVERS',                            'HD_UNIT_IS_NOT_BARBARIAN_REQUIREMENTS'),
    ('HD_IGNORE_SHORES',                        'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_SHORES',                            'HD_UNIT_IS_NOT_BARBARIAN_REQUIREMENTS'),
    ('HD_HEAL_AFTER_KILL',                      'MODIFIER_PLAYER_UNIT_ADJUST_HEAL_FROM_COMBAT',                         NULL),
    ('HD_AGAINST_UNIT_BONUS',                   'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                                 'COMBAT_AGAINST_UNITS_REQUIREMENTS'),
    ('HD_ATTACK_DISTRICT_BONUS',                'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                                 'ATTACKING_DISTRICTS_REQUIREMENTS'),
    ('HD_FOREST_AND_JUNGLE_COMBAT_BONUS',       'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                                 'PLOT_HAS_FOREST_OR_JUNGLE_REQUIREMENTS'),
    ('HD_GARRISON_BONUS',                       'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                                 'GARRISON_REQUIREMENTS'),
    ('HD_HILLS_DEFEND_BONUS',                   'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                                 'DEFENCE_MELEE_ATTACK_ON_HILLS_REQUIREMENTS'),
    ('HD_IGNORE_ZOC',                           'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_ZOC',                               NULL),
    ('HD_OPEN_AREA_STRENGTH',                   'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                                 'REQUIREMENTS_OPPONENT_IS_WOUNDED'), -- PLOT_IS_OPEN_AREA_REQUIREMENTS
    ('HD_EXTRA_FAITH_PLUNDER_DISTRICT',         'MODIFIER_PLAYER_UNIT_ADJUST_FAITH_ON_DISTRICT_PILLAGE',                NULL),
    ('HD_EXTRA_FAITH_PLUNDER_IMPROVEMENT',      'MODIFIER_PLAYER_UNIT_ADJUST_FAITH_ON_IMPROVEMENT_PILLAGE',             NULL),
    ('HD_ENEMY_MOVEMENT',                       'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',                                 'BERSERKER_PLOT_IS_ENEMY_TERRITORY'),
    ('HD_ATTACK_AFTER_MOVE',                    'MODIFIER_PLAYER_UNIT_ADJUST_MOVE_AND_ATTACK',                          NULL);

insert or replace into ModifierArguments
    (ModifierId,                                Name,          Value)
values
    ('HD_SCOUNT_IGNORE_ALL_HD',                 'Ignore',      1),
    ('HD_SCOUNT_IGNORE_ALL_HD',                 'Type',        'ALL'),
    ('HD_BATTLE_LINE_COMBAT',                   'Amount',      3),
    ('HD_ATTACKING_FROM_HILLS_STRENGTH',        'Amount',      5),
    ('HD_IGNORE_DAMAGED_STRENGTH_REDUCTION',    'Amount',      100),
    ('HD_IGNORE_RIVERS',                        'Ignore',      1),
    ('HD_IGNORE_SHORES',                        'Ignore',      1),
    ('HD_HEAL_AFTER_KILL',                      'Amount',      10),
    ('HD_AGAINST_UNIT_BONUS',                   'Amount',      5),
    ('HD_ATTACK_DISTRICT_BONUS',                'Amount',      5),
    ('HD_FOREST_AND_JUNGLE_COMBAT_BONUS',       'Amount',      3),
    ('HD_GARRISON_BONUS',                       'Amount',      5),
    ('HD_HILLS_DEFEND_BONUS',                   'Amount',      7),
    ('HD_IGNORE_ZOC',                           'Ignore',      1),
    ('HD_OPEN_AREA_STRENGTH',                   'Amount',      5),
    ('HD_EXTRA_FAITH_PLUNDER_DISTRICT',         'Amount',      25),
    ('HD_EXTRA_FAITH_PLUNDER_IMPROVEMENT',      'Amount',      25),
    ('HD_ENEMY_MOVEMENT',                       'Amount',      1),
    ('HD_ATTACK_AFTER_MOVE',                    'CanAttack',   1);

insert or replace into ModifierStrings
    (ModifierId,                                Context,    Text)
values
    ('HD_BATTLE_LINE_COMBAT',                   'Preview',  '+{1_Amount} {LOC_HD_BATTLE_LINE_COMBAT_PREVIEW_TEXT}'),
    ('HD_ATTACKING_FROM_HILLS_STRENGTH',        'Preview',  '+{1_Amount} {LOC_HD_ATTACKING_FROM_HILLS_STRENGTH_PREVIEW_TEXT}'),
    ('HD_AGAINST_UNIT_BONUS',                   'Preview',  '+{1_Amount} {LOC_HD_AGAINST_UNIT_BONUS_PREVIEW_TEXT}'),
    ('HD_ATTACK_DISTRICT_BONUS',                'Preview',  '+{1_Amount} {LOC_HD_ATTACK_DISTRICT_BONUS_PREVIEW_TEXT}'),
    ('HD_FOREST_AND_JUNGLE_COMBAT_BONUS',       'Preview',  '+{1_Amount} {LOC_HD_FOREST_AND_JUNGLE_COMBAT_BONUS_PREVIEW_TEXT}'),
    ('HD_GARRISON_BONUS',                       'Preview',  '+{1_Amount} {LOC_HD_GARRISON_BONUS_PREVIEW_TEXT}'),
    ('HD_HILLS_DEFEND_BONUS',                   'Preview',  '+{1_Amount} {LOC_HD_HILLS_DEFEND_BONUS_PREVIEW_TEXT}'),
    -- ('HD_OPEN_AREA_STRENGTH',                   'Preview',  '+{1_Amount} {LOC_HD_OPEN_AREA_STRENGTH_PREVIEW_TEXT}'),
    ('HD_OPEN_AREA_STRENGTH',                   'Preview',  '+{1_Amount} {LOC_HD_ATTACK_WOUNDED_PREVIEW_TEXT}');

---------------------------------------------------------------------------------------------------------------
-- Melee, ranged, anti-cavalry, naval melee, naval ranged, naval raider                                                                               --
---------------------------------------------------------------------------------------------------------------
insert or replace into Types
    (Type,                                                      Kind)
values
    --melee
    -- ('ABILITY_MELEE_DISTRICT_COMBAT_BONUS',                     'KIND_ABILITY'),
    ('PROMOTION_BATTLE_LINE',                                   'KIND_PROMOTION'),
    ('PROMOTION_LONG_MARCH',                                    'KIND_PROMOTION'),
    --ranged
    -- ('ABILITY_RANGED_GARRISON_DISTRICT_BONUS',                  'KIND_ABILITY'),
    -- ('RANGED_WEAKER_ATTACKING_FOREST_AND_JUNGLE',               'KIND_ABILITY'),
    ('PROMOTION_SNIPER',                                        'KIND_PROMOTION'),
    --anti-cavalry
    ('PROMOTION_LOGISTICS_SUPPLY',                              'KIND_PROMOTION'),
    ('PROMOTION_SPRINT_HD',                                     'KIND_PROMOTION'),
    --naval melee
    ('PROMOTION_BATTERING_RAM_TACTICS',                         'KIND_PROMOTION'),
    --naval ranged
    ('PROMOTION_BULB_BOW',                                      'KIND_PROMOTION'),
    --naval raider
    ('PROMOTION_BOARDING_ACTION',                               'KIND_PROMOTION'),
    ('PROMOTION_DAMAGE_CONTROL',                                'KIND_PROMOTION'),
    ('PROMOTION_AUTO_SOLICITATION',                             'KIND_PROMOTION'),
    ('ABILITY_WOLFPACK_ADJACENT_BONUS',                         'KIND_ABILITY');

delete from TypeTags where Type = 'ABILITY_ANTI_SPEAR' and Tag = 'CLASS_MELEE';
delete from TypeTags where (Type != 'ABILITY_SEE_HIDDEN') and Tag = 'CLASS_REVEAL_STEALTH';

insert or replace into TypeTags (Type, Tag)
select UnitType,    'CLASS_REVEAL_STEALTH'  from Units where PromotionClass = 'PROMOTION_CLASS_NAVAL_MELEE';

insert or replace into TypeTags
    (Type,                                                      Tag)
values
--     --melee
--     ('ABILITY_MELEE_DISTRICT_COMBAT_BONUS',                     'CLASS_MELEE'),
--     --ranged
--     ('ABILITY_RANGED_GARRISON_DISTRICT_BONUS',                  'CLASS_RANGED'),
--     ('RANGED_WEAKER_ATTACKING_FOREST_AND_JUNGLE',               'CLASS_RANGED');
    ('ABILITY_WOLFPACK_ADJACENT_BONUS',                         'CLASS_NAVAL_RAIDER');

insert or replace into UnitPromotions
    (UnitPromotionType,             Name,                                           Description,                                        Level,    PromotionClass,                   Column)
values
    --melee
    -- ('PROMOTION_BATTLE_LINE',       'LOC_PROMOTION_BATTLE_LINE_HD_NAME',            'LOC_PROMOTION_BATTLE_LINE_HD_DESCRIPTION',         2,        'PROMOTION_CLASS_MELEE',          3),
    ('PROMOTION_LONG_MARCH',        'LOC_PROMOTION_LONG_MARCH_HD_NAME',             'LOC_PROMOTION_LONG_MARCH_HD_DESCRIPTION',          3,        'PROMOTION_CLASS_MELEE',          1),
    --ranged
    ('PROMOTION_SNIPER',            'LOC_PROMOTION_SNIPER_HD_NAME',                 'LOC_PROMOTION_SNIPER_HD_DESCRIPTION',              4,        'PROMOTION_CLASS_RANGED',         1),
    --anti-cavalry
    ('PROMOTION_LOGISTICS_SUPPLY',  'LOC_PROMOTION_LOGISTICS_SUPPLY_HD_NAME',       'LOC_PROMOTION_LOGISTICS_SUPPLY_HD_DESCRIPTION',    3,        'PROMOTION_CLASS_ANTI_CAVALRY',   1),
    ('PROMOTION_SPRINT_HD',         'LOC_PROMOTION_SPRINT_HD_NAME',                 'LOC_PROMOTION_SPRINT_HD_DESCRIPTION',              4,        'PROMOTION_CLASS_ANTI_CAVALRY',   2),
    --naval melee
    ('PROMOTION_BATTERING_RAM_TACTICS', 'LOC_PROMOTION_BATTERING_RAM_TACTICS_HD_NAME',  'LOC_PROMOTION_BATTERING_RAM_TACTICS_HD_DESCRIPTION',  4, 'PROMOTION_CLASS_NAVAL_MELEE',    2),
    --naval ranged
    ('PROMOTION_BULB_BOW',          'LOC_PROMOTION_BULB_BOW_HD_NAME',               'LOC_PROMOTION_BULB_BOW_HD_DESCRIPTION',            3,        'PROMOTION_CLASS_NAVAL_RANGED',   3),
    --naval raider
    ('PROMOTION_BOARDING_ACTION',   'LOC_PROMOTION_BOARDING_ACTION_HD_NAME',        'LOC_PROMOTION_BOARDING_ACTION_HD_DESCRIPTION',     1,        'PROMOTION_CLASS_NAVAL_RAIDER',   3),
    -- ('PROMOTION_DAMAGE_CONTROL',    'LOC_PROMOTION_DAMAGE_CONTROL_HD_NAME',         'LOC_PROMOTION_DAMAGE_CONTROL_HD_DESCRIPTION',      2,        'PROMOTION_CLASS_NAVAL_RAIDER',   1),
    ('PROMOTION_DAMAGE_CONTROL',    'LOC_PROMOTION_DAMAGE_CONTROL_HD_NAME',         'LOC_PROMOTION_DAMAGE_CONTROL_HD_DESCRIPTION',      3,        'PROMOTION_CLASS_NAVAL_RAIDER',   1),
    ('PROMOTION_AUTO_SOLICITATION', 'LOC_PROMOTION_AUTO_SOLICITATION_HD_NAME',      'LOC_PROMOTION_AUTO_SOLICITATION_HD_DESCRIPTION',   3,        'PROMOTION_CLASS_NAVAL_RAIDER',   3);

insert or replace into UnitAbilities 
    (UnitAbilityType,                               Name,      Description,                                                     Inactive) 
values
--     --melee
--     ('ABILITY_MELEE_DISTRICT_COMBAT_BONUS',         NULL,      'LOC_ABILITY_MELEE_DISTRICT_COMBAT_BONUS_HD_DESCRIPTION',        0),
--     --ranged
--     ('ABILITY_RANGED_GARRISON_DISTRICT_BONUS',      NULL,      'LOC_ABILITY_RANGED_GARRISON_DISTRICT_BONUS_HD_DESCRIPTION',     0),
--     ('RANGED_WEAKER_ATTACKING_FOREST_AND_JUNGLE',   NULL,      'LOC_RANGED_WEAKER_ATTACKING_FOREST_AND_JUNGLE_HD_DESCRIPTION',  0);
    ('ABILITY_WOLFPACK_ADJACENT_BONUS',             NULL,       NULL,                                                           1);

insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                                           ModifierId)
values
    --melee
    -- ('ABILITY_MELEE_DISTRICT_COMBAT_BONUS',                     'MELEE_DISTRICT_COMBAT_BONUS'),
    --ranged
    -- ('ABILITY_RANGED_GARRISON_DISTRICT_BONUS',                  'RANGED_GARRISON_DISTRICT_BONUS'),
    -- ('RANGED_WEAKER_ATTACKING_FOREST_AND_JUNGLE',               'RANGED_WEAKER_ATTACKING_FOREST_AND_JUNGLE'),
    ('ABILITY_ANTI_CAVALRY',                                    'ANTI_CAVALRY_COMBAT_BONUS_DEFENDING'),
    ('ABILITY_WOLFPACK_ADJACENT_BONUS',                         'HD_WOLFPACK_ADJACENT_BONUS');

insert or replace into Modifiers
    (ModifierId,                                                ModifierType,                               SubjectRequirementSetId)
values
    --melee
    -- ('MELEE_DISTRICT_COMBAT_BONUS',                             'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'URBAN_WARFARE_REQUIREMENTS'),
    --ranged
    -- ('RANGED_GARRISON_DISTRICT_BONUS',                          'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'GARRISON_REQUIREMENTS'),
    -- ('RANGED_WEAKER_ATTACKING_FOREST_AND_JUNGLE',               'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'RANGED_WEAKER_REQUIREMENTS'),
    ('ANTI_CAVALRY_COMBAT_BONUS_DEFENDING',                     'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'ANTI_CAVALRY_DEFEND_OPPONENT_REQUIREMENTS'),
    ('HD_WOLFPACK_ADJACENT_BONUS',                              'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     NULL);

insert or replace into ModifierArguments
    (ModifierId,                                                Name,            Value)
values
    --melee
    -- ('MELEE_DISTRICT_COMBAT_BONUS',                             'Amount',        5),
    --ranged
    -- ('RANGED_GARRISON_DISTRICT_BONUS',                          'Amount',        5),
    -- ('RANGED_WEAKER_ATTACKING_FOREST_AND_JUNGLE',               'Amount',        -3),
    ('ANTI_CAVALRY_COMBAT_BONUS_DEFENDING',                     'Amount',        10),
    ('HD_WOLFPACK_ADJACENT_BONUS',                              'Amount',        2);

insert or replace into ModifierStrings
    (ModifierId,                                                Context,    Text)
values
    ('ANTI_CAVALRY_COMBAT_BONUS_DEFENDING',                     'Preview',    '+{1_Amount} {LOC_ANTI_CAVALRY_COMBAT_BONUS_DEFENDING_PREVIEW_TEXT}'),
    ('HD_WOLFPACK_ADJACENT_BONUS',                              'Preview',    '+{1_Amount} {LOC_HD_WOLFPACK_ADJACENT_BONUS_PREVIEW_TEXT}');

--unit upgrade ability 升级线
--melee
-- update ModifierArguments set Value = 5 where ModifierId = 'BATTLECRY_BONUS_VS_MELEE_RANGED' and Name = 'Amount';
--update UnitPromotionModifiers set ModifierId = 'TORTOISE_DEFENSE_BONUS_VS_RANGED_AND_CITIES' where UnitPromotionType = 'PROMOTION_TORTOISE' and ModifierId = 'TORTOISE_DEFENSE_BONUS_VS_RANGED_COMBAT';
-- update ModifierArguments set Value = 7 where ModifierId = 'TORTOISE_DEFENSE_BONUS_VS_RANGED_COMBAT' and Name = 'Amount';
-- update ModifierArguments set Value = 7 where ModifierId = 'URBAN_WARFARE_BONUS' and Name = 'Amount';
--ranged
-- update ModifierArguments set Value = 5 where ModifierId = 'GARRISON_BONUS_DISTRICTS' and Name = 'Amount';
-- update ModifierArguments set Value = 10 where ModifierId = 'INCENDIARIES_BONUS_VS_DISTRICT_DEFENSES' and Name = 'Amount';
update UnitPromotionModifiers set ModifierId = 'EMPLACEMENT_DEFENSE_BONUS_VS_RANGED' where UnitPromotionType = 'PROMOTION_EMPLACEMENT' and ModifierId = 'EMPLACEMENT_DEFENSE_BONUS_VS_CITIES';
--anti-cavalry
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_ANTI_CAVALRY' and ModifierId = 'ANTI_CAVALRY_COMBAT_BONUS';
-- update ModifierArguments set Value = 5 where ModifierId = 'ANTI_CAVALRY_COMBAT_BONUS' and Name = 'Amount';
--delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_ECHELON' and ModifierId = 'ECHELON_ADDITIONAL_CAVALRY_BONUS';
delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_THRUST' and ModifierId = 'THRUST_BONUS_VS_MELEE';
-- update ModifierArguments set Value = 10 where ModifierId = 'CHOKE_POINTS_BONUS' and Name = 'Amount';
update Modifiers set SubjectRequirementSetId = 'CHOKE_POINTS_PLOT_REQUIREMENTS' where ModifierId = 'CHOKE_POINTS_BONUS';
--naval melee
--匍匐攻击：与海军袭击者战斗+12力
update ModifierArguments set Value = 12 where ModifierId = 'CREEPING_ATTACK_BONUS_VS_RAIDERS' and Name = 'Amount';
--naval ranged
--轰炸：攻击区域防御+7力
update ModifierArguments set Value = 7 where ModifierId = 'BOMBARDMENT_BONUS_VS_DISTRICT_DEFENSES' and Name = 'Amount';
--徐进弹：攻击区域防御+12力
update ModifierArguments set Value = 12 where ModifierId = 'ROLLING_BARRAGE_BONUS_VS_DISTRICT_DEFENSES' and Name = 'Amount';
--naval raider
update ModifierArguments set Value = 100 where ModifierId = 'LOOT_GOLD_FROM_COASTAL_RAID' and Name = 'Bonus';
delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_WOLFPACK' and ModifierId = 'WOLFPACK_ADDITIONAL_ATTACK';

--melee
-- update UnitPromotions set Column = -1 where UnitPromotionType = 'PROMOTION_AMPHIBIOUS' or UnitPromotionType = 'PROMOTION_ZWEIHANDER';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_AMPHIBIOUS';
update UnitPromotions set Level = 2, Column = 3 where UnitPromotionType = 'PROMOTION_ZWEIHANDER';
delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_ZWEIHANDER' and ModifierId = 'ZWEIHANDER_BONUS_VS_ANTI_CAVALRY';
-- delete from UnitPromotions where UnitPromotionType = 'PROMOTION_ZWEIHANDER';
--ranged
-- update UnitPromotions set Column = -1 where UnitPromotionType = 'PROMOTION_INCENDIARIES';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_INCENDIARIES';
update UnitPromotions set Level = 2 , Column = 2 where UnitPromotionType = 'PROMOTION_SUPPRESSION';
update UnitPromotions set Level = 3 , Column = 1 where UnitPromotionType = 'PROMOTION_ARROW_STORM';
update UnitPromotions set Level = 4 , Column = 3 where UnitPromotionType = 'PROMOTION_EXPERT_MARKSMAN';
--anti-cavalry 
-- update UnitPromotions set Column = -1 where UnitPromotionType = 'PROMOTION_SCHILTRON';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SCHILTRON' or UnitPromotionType = 'PROMOTION_HOLD_THE_LINE';
update UnitPromotions set Level = 2, Column = 3 where UnitPromotionType = 'PROMOTION_REDEPLOY';
-- update UnitPromotions set Level = 3 , Column = 1 where UnitPromotionType = 'PROMOTION_CHOKE_POINTS';
--naval melee
-- update UnitPromotions set Column = -1 where UnitPromotionType = 'PROMOTION_RUTTER';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_RUTTER';
update UnitPromotions set Level = 2 , Column = 3 where UnitPromotionType = 'PROMOTION_CREEPING_ATTACK';
--naval ranged
-- update UnitPromotions set Column = -1 where UnitPromotionType = 'PROMOTION_PROXIMITY_FUSES';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_PROXIMITY_FUSES';
--naval raider
-- update UnitPromotions set Column = -1 where UnitPromotionType = 'PROMOTION_BOARDING' or UnitPromotionType = 'PROMOTION_HOMING_TORPEDOES' or UnitPromotionType = 'PROMOTION_OBSERVATION';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_BOARDING' or UnitPromotionType = 'PROMOTION_HOMING_TORPEDOES' or UnitPromotionType = 'PROMOTION_OBSERVATION';
update UnitPromotions set Level = 1, Column = 1 where UnitPromotionType = 'PROMOTION_SWIFT_KEEL';
update UnitPromotions set Level = 2, Column = 1 where UnitPromotionType = 'PROMOTION_DAMAGE_CONTROL';
update UnitPromotions set Level = 2, Column = 3 where UnitPromotionType = 'PROMOTION_SILENT_RUNNING';
update UnitPromotions set Level = 3, Column = 1 where UnitPromotionType = 'PROMOTION_LOOT';
update UnitPromotions set Level = 3, Column = 3 where UnitPromotionType = 'PROMOTION_WOLFPACK';
update UnitPromotions set Level = 4, Column = 2 where UnitPromotionType = 'PROMOTION_AUTO_SOLICITATION';
/* update UnitPromotionPrereqs set UnitPromotion = 'PROMOTION_AUTO_SOLICITATION' where UnitPromotion = 'PROMOTION_WOLFPACK' and PrereqUnitPromotion = 'PROMOTION_DAMAGE_CONTROL';
update UnitPromotionPrereqs set UnitPromotion = 'PROMOTION_WOLFPACK' where UnitPromotion = 'PROMOTION_AUTO_SOLICITATION' and PrereqUnitPromotion = 'PROMOTION_LOOT';
update UnitPromotionPrereqs set UnitPromotion = 'PROMOTION_WOLFPACK' where UnitPromotion = 'PROMOTION_AUTO_SOLICITATION' and PrereqUnitPromotion = 'PROMOTION_SILENT_RUNNING';
delete from UnitPromotionPrereqs where UnitPromotion = 'PROMOTION_WOLFPACK' and PrereqUnitPromotion = 'PROMOTION_AUTO_SOLICITATION';
insert or replace into UnitPromotionPrereqs
	(UnitPromotion, 					PrereqUnitPromotion)
values
	('PROMOTION_AUTO_SOLICITATION',		'PROMOTION_WOLFPACK');
 */

delete from UnitPromotionPrereqs 
    --melee
where  UnitPromotion = 'PROMOTION_AMPHIBIOUS' 
    or PrereqUnitPromotion = 'PROMOTION_AMPHIBIOUS'
    or UnitPromotion = 'PROMOTION_ZWEIHANDER' 
    or PrereqUnitPromotion = 'PROMOTION_ZWEIHANDER'
    --ranged
    or UnitPromotion = 'PROMOTION_ARROW_STORM' 
    or PrereqUnitPromotion = 'PROMOTION_ARROW_STORM'
    or UnitPromotion = 'PROMOTION_INCENDIARIES' 
    or PrereqUnitPromotion = 'PROMOTION_INCENDIARIES'
    or UnitPromotion = 'PROMOTION_SUPPRESSION' 
    or PrereqUnitPromotion = 'PROMOTION_SUPPRESSION'
    --anti-cavalry 
    or UnitPromotion = 'PROMOTION_SCHILTRON' 
    or PrereqUnitPromotion = 'PROMOTION_SCHILTRON'
    or UnitPromotion = 'PROMOTION_REDEPLOY' 
    or PrereqUnitPromotion = 'PROMOTION_REDEPLOY'
    --naval melee
    or UnitPromotion = 'PROMOTION_RUTTER' 
    or PrereqUnitPromotion = 'PROMOTION_RUTTER'
    or UnitPromotion = 'PROMOTION_CREEPING_ATTACK' 
    or PrereqUnitPromotion = 'PROMOTION_CREEPING_ATTACK'
    --naval ranged
    or UnitPromotion = 'PROMOTION_PROXIMITY_FUSES' 
    or PrereqUnitPromotion = 'PROMOTION_PROXIMITY_FUSES'
    --naval raider
    or UnitPromotion in (select UnitPromotionType from UnitPromotions where PromotionClass = 'PROMOTION_CLASS_NAVAL_RAIDER');

insert or replace into UnitPromotionPrereqs
    (UnitPromotion,             PrereqUnitPromotion)
values
    --melee
    ('PROMOTION_ZWEIHANDER',    'PROMOTION_TORTOISE'),
    ('PROMOTION_ZWEIHANDER',    'PROMOTION_COMMANDO'),
    ('PROMOTION_COMMANDO',      'PROMOTION_ZWEIHANDER'),
    ('PROMOTION_LONG_MARCH',    'PROMOTION_COMMANDO'),
    ('PROMOTION_LONG_MARCH',    'PROMOTION_ZWEIHANDER'),
    ('PROMOTION_URBAN_WARFARE', 'PROMOTION_ZWEIHANDER'),
    ('PROMOTION_ELITE_GUARD',   'PROMOTION_LONG_MARCH'),
    --ranged
    -- ('PROMOTION_SNIPER',        'PROMOTION_VOLLEY'),
    -- ('PROMOTION_SNIPER',        'PROMOTION_GARRISON'),
    ('PROMOTION_SUPPRESSION',   'PROMOTION_VOLLEY'),
    ('PROMOTION_SUPPRESSION',   'PROMOTION_GARRISON'),
    -- ('PROMOTION_INCENDIARIES',  'PROMOTION_VOLLEY'),
    -- ('PROMOTION_ARROW_STORM',   'PROMOTION_SNIPER'),
    ('PROMOTION_ARROW_STORM',   'PROMOTION_SUPPRESSION'),
    ('PROMOTION_EMPLACEMENT',   'PROMOTION_SUPPRESSION'),
    ('PROMOTION_SNIPER',        'PROMOTION_ARROW_STORM'),
    --anti-cavalry
    ('PROMOTION_REDEPLOY',          'PROMOTION_THRUST'),
    ('PROMOTION_CHOKE_POINTS',      'PROMOTION_REDEPLOY'),
    ('PROMOTION_LOGISTICS_SUPPLY',  'PROMOTION_REDEPLOY'),
    ('PROMOTION_LOGISTICS_SUPPLY',  'PROMOTION_SQUARE'),
    -- ('PROMOTION_HOLD_THE_LINE',     'PROMOTION_LOGISTICS_SUPPLY'),
    ('PROMOTION_SPRINT_HD',         'PROMOTION_LOGISTICS_SUPPLY'),
    ('PROMOTION_SPRINT_HD',         'PROMOTION_CHOKE_POINTS'),
    --spy
    --('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_TECHNOLOGIST'),
    --('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_CAT_BURGLAR'),
    --('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_DEMOLITIONS'),
   -- ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_CON_ARTIST'),
   -- ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_SEDUCTION'),
   -- ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_LINGUIST'),
   -- ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_QUARTERMASTER'),
   -- ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_SMEAR_CAMPAIGN'),
  --  ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_LICENSE_TO_KILL'),
   -- ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_SATCHEL_CHARGES'),
  --  ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_SURVEILLANCE'),
  --  ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_OBSERVER'),
  --  ('PROMOTION_SPY_SPIN_WEB',      'PROMOTION_SPY_PATHFINDER'),
    --naval melee
    ('PROMOTION_CREEPING_ATTACK',   'PROMOTION_HELMSMAN'),
    ('PROMOTION_AUXILIARY_SHIPS',   'PROMOTION_CREEPING_ATTACK'),
    ('PROMOTION_CONVOY',            'PROMOTION_CREEPING_ATTACK'),
    ('PROMOTION_BATTERING_RAM_TACTICS',     'PROMOTION_AUXILIARY_SHIPS'),
    ('PROMOTION_BATTERING_RAM_TACTICS',     'PROMOTION_CONVOY'),
    --naval ranged
    ('PROMOTION_BULB_BOW',           'PROMOTION_PREPARATORY_FIRE'),
    ('PROMOTION_BULB_BOW',           'PROMOTION_ROLLING_BARRAGE'),
    ('PROMOTION_COINCIDENCE_RANGEFINDING',  'PROMOTION_BULB_BOW'),
    --naval raider
    ('PROMOTION_DAMAGE_CONTROL',	'PROMOTION_SWIFT_KEEL'),
    ('PROMOTION_SILENT_RUNNING',     'PROMOTION_BOARDING_ACTION'),
    ('PROMOTION_LOOT',	'PROMOTION_DAMAGE_CONTROL'),
    ('PROMOTION_LOOT',	'PROMOTION_SILENT_RUNNING'),
    ('PROMOTION_WOLFPACK',	'PROMOTION_DAMAGE_CONTROL'),
    ('PROMOTION_WOLFPACK',     'PROMOTION_SILENT_RUNNING'),
    ('PROMOTION_AUTO_SOLICITATION',	'PROMOTION_LOOT'),
    ('PROMOTION_AUTO_SOLICITATION',  'PROMOTION_WOLFPACK');

insert or replace into UnitPromotionModifiers
    (UnitPromotionType,             ModifierId)
values
-- 近战
    ('PROMOTION_ZWEIHANDER',        'ZWEIHANDER_FLANKED_BONUS'),
    ('PROMOTION_LONG_MARCH',        'MAMLUK_HEAL_EVERY_MOVE'),
-- 远程
    ('PROMOTION_SNIPER',            'SNIPER_ATTACK_RANGE'),
    ('PROMOTION_SUPPRESSION',       'SUPPRESSION_BONUS_VS_WOUNDED_UNITS'),
-- 抗骑兵
    ('PROMOTION_THRUST',            'THRUST_ATTACK_BONUS'),
    ('PROMOTION_LOGISTICS_SUPPLY',  'LOGISTICS_SUPPLY_HEAL_BONUS'),
    ('PROMOTION_SPRINT_HD',         'SPRINT_REMAINING_MOVEMENT_STRENGTH'),
-- 海军近战
    ('PROMOTION_BATTERING_RAM_TACTICS', 'BREAKTHROUGH_ADDITIONAL_ATTACK'),
    ('PROMOTION_BATTERING_RAM_TACTICS', 'MOD_MOVE_AFTER_ATTACKING'),
-- 海军远程
    ('PROMOTION_BULB_BOW',          'BULB_BOW_BONUS_WATER_MOVEMENT'),
-- 海军袭击者
    ('PROMOTION_SWIFT_KEEL',        'OBSERVATION_INCREASED_SIGHT_RANGE'),
    ('PROMOTION_BOARDING_ACTION',   'BOARDING_ACTION_ATTACK_BONUS'),
    ('PROMOTION_DAMAGE_CONTROL',    'SUPPLY_FLEET_NEUTRAL_TERRITORY_HEAL'),
    ('PROMOTION_DAMAGE_CONTROL',    'SUPPLY_FLEET_ENEMY_TERRITORY_HEAL'),
    ('PROMOTION_LOOT',              'TRADE_ROUTE_PLUNDER_BONUS'),
    ('PROMOTION_AUTO_SOLICITATION', 'WOLFPACK_ADDITIONAL_ATTACK'),
    ('PROMOTION_WOLFPACK',          'WOLFPACK_ADJACENT_BONUS'),
-- 恩奇都
    -- 战斗鼓舞
    ('PROMOTION_BATTLE_CHEER_HD',          'HD_BATTLE_CHEER_GRANT_ABILITY'),
    -- 杉林远征
    ('PROMOTION_FIR_EXPEDITION_HD',        'HD_FIR_EXPEDITION_GRANT_ABILITY'),
    -- 天牛试炼
    ('PROMOTION_LONGOX_TRIAL_HD',          'HD_LONGOX_TRIAL_DOUBLE_SUPPORT_BONUS'),
    ('PROMOTION_LONGOX_TRIAL_HD',          'HD_LONGOX_TRIAL_DOUBLE_FLANKING_BONUS'),
    ('PROMOTION_LONGOX_TRIAL_HD',          'HD_LONGOX_TRIAL_DOUBLE_GRANT_ABILITY'),
    -- 英雄凯旋
    ('PROMOTION_HEROES_RETURN_HD',         'HD_HEROES_RETURN_CAPITAL_CULTURE');

insert or replace into Modifiers
    (ModifierId,                                                    ModifierType,                                           SubjectRequirementSetId)
values
-- 近战
    ('ZWEIHANDER_FLANKED_BONUS',                                    'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                 'HD_UNIT_IS_FLANKED_REQUIREMENTS'),
-- 远程
    ('SNIPER_ATTACK_RANGE',                                         'MODIFIER_UNIT_ADJUST_ATTACK_RANGE',                    NULL),
    ('SUPPRESSION_BONUS_VS_WOUNDED_UNITS',                          'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                 'REQUIREMENTS_OPPONENT_IS_WOUNDED'),
    ('EMPLACEMENT_DEFENSE_BONUS_VS_RANGED',                         'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                 'TORTOISE_REQUIREMENTS'),
-- 抗骑兵
    ('THRUST_ATTACK_BONUS',                                         'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                 'FASCISM_REQUIREMENTS'),
    ('LOGISTICS_SUPPLY_HEAL_BONUS',                                 'MODIFIER_PLAYER_UNIT_ADJUST_HEAL_PER_TURN',            NULL),
    ('SPRINT_REMAINING_MOVEMENT_STRENGTH',                          'MODIFIER_SINGLE_UNIT_ADJUST_COMBAT_FOR_UNUSED_MOVEMENT',   NULL),
-- 海军近战
    ('BULB_BOW_BONUS_WATER_MOVEMENT',                               'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',                 NULL),
-- 海军袭击者
    ('BOARDING_ACTION_ATTACK_BONUS',                                'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                 'HD_UNIT_ATTACKING_REQUIREMENTS'),
    ('TRADE_ROUTE_PLUNDER_BONUS',                                   'MODIFIER_PLAYER_UNIT_ADJUST_PLUNDER_YIELDS',           'JUST_WAR_PLOT_UNIT_REQUIREMENTS'),
    ('WOLFPACK_ADJACENT_BONUS',                                     'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',                 'WOLFPACK_ADJACENT_REQUIREMENTS'),
-- 恩奇都
    ('HD_BATTLE_CHEER_GRANT_ABILITY',                               'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',                      'HD_OBJECT_WITHIN_3_TILES'),
    ('HD_FIR_EXPEDITION_GRANT_ABILITY',                             'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',                      'HD_FIR_EXPEDITION_REQUIREMENTS'),
	('HD_LONGOX_TRIAL_DOUBLE_SUPPORT_BONUS',	                    'MODIFIER_PLAYER_UNIT_ADJUST_SUPPORT_BONUS_MODIFIER',	    NULL),
	('HD_LONGOX_TRIAL_DOUBLE_FLANKING_BONUS',	                    'MODIFIER_PLAYER_UNIT_ADJUST_FLANKING_BONUS_MODIFIER',	    NULL),
	('HD_LONGOX_TRIAL_DOUBLE_GRANT_ABILITY',	                    'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',	                    'HD_OBJECT_WITHIN_3_TILES'),
	('HD_HEROES_RETURN_CAPITAL_CULTURE', 				            'MODIFIER_PLAYER_CAPITAL_CITY_ADJUST_CITY_YIELD_MODIFIER',	'HD_HEROES_RETURN_REQUIREMENTS');

insert or replace into ModifierArguments
    (ModifierId,                                                    Name,           Value)
values
-- 近战
    ('ZWEIHANDER_FLANKED_BONUS',                                    'Amount',       7),
-- 远程
    ('SNIPER_ATTACK_RANGE',                                         'Amount',       1),
    ('SUPPRESSION_BONUS_VS_WOUNDED_UNITS',                          'Amount',       5),
    ('EMPLACEMENT_DEFENSE_BONUS_VS_RANGED',                         'Amount',       10),
-- 抗骑兵
    ('THRUST_ATTACK_BONUS',                                         'Amount',       5),
    ('LOGISTICS_SUPPLY_HEAL_BONUS',                                 'Amount',       10),
    ('LOGISTICS_SUPPLY_HEAL_BONUS',                                 'Type',         'ALL'),
    ('SPRINT_REMAINING_MOVEMENT_STRENGTH',                          'Amount',       3),
-- 海军近战
    ('BULB_BOW_BONUS_WATER_MOVEMENT',                               'Amount',       1),
-- 海军袭击者
    ('BOARDING_ACTION_ATTACK_BONUS',                                'Amount',       5),
    ('TRADE_ROUTE_PLUNDER_BONUS',                                   'Amount',       100),
    ('WOLFPACK_ADJACENT_BONUS',                                     'ModifierId',   'HD_WOLFPACK_ADJACENT_BONUS'),
-- 恩奇都
    ('HD_BATTLE_CHEER_GRANT_ABILITY',                               'AbilityType',              'ABILITY_HD_BATTLE_CHEER'),
    ('HD_FIR_EXPEDITION_GRANT_ABILITY',                             'AbilityType',              'ABILITY_HD_FIR_EXPEDITION'),
	('HD_LONGOX_TRIAL_DOUBLE_SUPPORT_BONUS',				        'Percent',	                100),
	('HD_LONGOX_TRIAL_DOUBLE_FLANKING_BONUS',				        'Percent',	                100),
	('HD_LONGOX_TRIAL_DOUBLE_GRANT_ABILITY',				        'AbilityType',	            'ABILITY_HD_LONGOX_TRIAL'),
    ('HD_HEROES_RETURN_CAPITAL_CULTURE',                            'YieldType',                'YIELD_CULTURE'),
	('HD_HEROES_RETURN_CAPITAL_CULTURE',				            'Amount',	                10);

insert or replace into ModifierStrings
    (ModifierId,                                                Context,    Text)
values
-- 近战
    ('ZWEIHANDER_FLANKED_BONUS',                                'Preview',  '+{1_Amount} {LOC_PROMOTION_ZWEIHANDER_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
-- 远程
    ('SUPPRESSION_BONUS_VS_WOUNDED_UNITS',                      'Preview',  '+{1_Amount} {LOC_PROMOTION_SUPPRESSION_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('EMPLACEMENT_DEFENSE_BONUS_VS_RANGED',                     'Preview',  '+{1_Amount} {LOC_PROMOTION_EMPLACEMENT_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
-- 抗骑兵
    ('THRUST_ATTACK_BONUS',                                     'Preview',  '+{1_Amount} {LOC_PROMOTION_THRUST_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('SPRINT_REMAINING_MOVEMENT_STRENGTH',                      'Preview',  '+{1_Amount} {LOC_PROMOTION_SPRINT_HD_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
-- 海军袭击者
    ('BOARDING_ACTION_ATTACK_BONUS',                            'Preview',  '+{1_Amount} {LOC_PROMOTION_BOARDING_ACTION_HD_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}');

---------------------------------------------------------------------------------------------------------------
-- Recon, light & heavy Cavalry, Siege                                                                       --
---------------------------------------------------------------------------------------------------------------
-- Ability
delete from TypeTags where Type = 'UNIT_SCOUT' and Tag = 'CLASS_REVEAL_STEALTH';
insert or replace into TypeTags
    (Type,                                                      Tag)
values
    -- recon
    ('ABILITY_RECON_IGNORE_TERRIAN_COST_HD',                    'CLASS_RECON');

insert or replace into UnitAbilities 
    (UnitAbilityType,                               Name,       Description,                                                     Inactive) 
values
    -- recon
    ('ABILITY_RECON_IGNORE_TERRIAN_COST_HD',        NULL,       'LOC_ABILITY_RECON_IGNORE_TERRIAN_COST_HD_DESCRIPTION',          0),
    ('ABILITY_LIGHT_CAVALRY_HD',                    NULL,       'LOC_ABILITY_LIGHT_CAVALRY_HD_DESCRIPTION',                      0),
    ('ABILITY_SIEGE_CAVALRY_MOVEMENT_HD',           NULL,       'LOC_ABILITY_SIEGE_CAVALRY_MOVEMENT_HD_DESCRIPTION',             0);

insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                                       ModifierId)
values
    -- recon
    ('ABILITY_RECON_IGNORE_TERRIAN_COST_HD',                'HD_RECON_IGNORE_HILLS_MOVEMENT_PENALTY'),
    ('ABILITY_RECON_IGNORE_TERRIAN_COST_HD',                'HD_RECON_IGNORE_FOREST_MOVEMENT_PENALTY'),
    -- light
    ('ABILITY_LIGHT_CAVALRY_HD',                            'HD_LIGHT_CAVALRY_ADVANCED_PILLAGING'),
    -- siege
    ('ABILITY_SIEGE_CAVALRY_MOVEMENT_HD',                   'HD_SIEGE_CAVALRY_MOVEMENT');

-- Promotions
insert or replace into Types
    (Type,                                                      Kind)
values
    -- recon
    ('ABILITY_RECON_IGNORE_TERRIAN_COST_HD',                    'KIND_ABILITY'),
    ('ABILITY_LIGHT_CAVALRY_HD',                                'KIND_ABILITY'),
    ('ABILITY_SIEGE_CAVALRY_MOVEMENT_HD',                       'KIND_ABILITY'),
    ('PROMOTION_RECON_TRAVEL_LIGHT',                            'KIND_PROMOTION'),
    ('PROMOTION_RECON_RAPID_FIRE',                              'KIND_PROMOTION'),
    ('PROMOTION_RECON_ACCURATE',                                'KIND_PROMOTION'),
    ('PROMOTION_HEAVYC_SHOCK',                                  'KIND_PROMOTION'),
    ('PROMOTION_LIGHTC_MILITANT',                               'KIND_PROMOTION'),
    ('PROMOTION_LIGHTC_SHOCK',                                  'KIND_PROMOTION'),
    ('PROMOTION_LIGHTC_MOBILE_WARFARE',                         'KIND_PROMOTION');

update UnitPromotions set Level = 1 where UnitPromotionType = 'PROMOTION_GUERRILLA';
update UnitPromotions set Level = 2 where UnitPromotionType = 'PROMOTION_SENTRY';
update UnitPromotions set Level = 1 where UnitPromotionType = 'PROMOTION_SPYGLASS';
-- 
update UnitPromotions set Column = 2 where UnitPromotionType = 'PROMOTION_AMBUSH';
update UnitPromotions set Column = 3 where UnitPromotionType = 'PROMOTION_MARAUDING';
update UnitPromotions set Column = 1 where UnitPromotionType = 'PROMOTION_ROUT';
-- 
update UnitPromotions set Level = 1 where UnitPromotionType = 'PROMOTION_DEPREDATION';
update UnitPromotions set Level = 1 where UnitPromotionType = 'PROMOTION_DOUBLE_ENVELOPMENT';

insert or replace into UnitPromotions
    (UnitPromotionType,                 Name,                                       Description,                                        Level,  PromotionClass,                     Column)
values
    -- Recon
    ('PROMOTION_RECON_TRAVEL_LIGHT',    'LOC_PROMOTION_RECON_TRAVEL_LIGHT_NAME',    'LOC_PROMOTION_RECON_TRAVEL_LIGHT_DESCRIPTION',     2,      'PROMOTION_CLASS_RECON',            3),
    ('PROMOTION_RECON_RAPID_FIRE',      'LOC_PROMOTION_RECON_RAPID_FIRE_NAME',      'LOC_PROMOTION_RECON_RAPID_FIRE_DESCRIPTION',       4,      'PROMOTION_CLASS_RECON',            1),
    ('PROMOTION_RECON_ACCURATE',        'LOC_PROMOTION_RECON_ACCURATE_NAME',        'LOC_PROMOTION_RECON_ACCURATE_DESCRIPTION',         4,      'PROMOTION_CLASS_RECON',            3),
    -- Heavy
    ('PROMOTION_HEAVYC_SHOCK',          'LOC_PROMOTION_HEAVYC_SHOCK_NAME',          'LOC_PROMOTION_HEAVYC_SHOCK_DESCRIPTION',           2,      'PROMOTION_CLASS_HEAVY_CAVALRY',    1),
    -- Light
    ('PROMOTION_LIGHTC_MILITANT',       'LOC_PROMOTION_LIGHTC_MILITANT_NAME',       'LOC_PROMOTION_LIGHTC_MILITANT_DESCRIPTION',        2,      'PROMOTION_CLASS_LIGHT_CAVALRY',    1),
    ('PROMOTION_LIGHTC_SHOCK',          'LOC_PROMOTION_LIGHTC_SHOCK_NAME',          'LOC_PROMOTION_LIGHTC_SHOCK_DESCRIPTION',           2,      'PROMOTION_CLASS_LIGHT_CAVALRY',    3),
    ('PROMOTION_LIGHTC_MOBILE_WARFARE', 'LOC_PROMOTION_LIGHTC_MOBILE_WARFARE_NAME', 'LOC_PROMOTION_LIGHTC_MOBILE_WARFARE_DESCRIPTION',  3,      'PROMOTION_CLASS_LIGHT_CAVALRY',    1);

delete from UnitPromotionPrereqs where UnitPromotion = 'PROMOTION_CAMOUFLAGE';
delete from UnitPromotionPrereqs where PrereqUnitPromotion = 'PROMOTION_RANGER' or PrereqUnitPromotion = 'PROMOTION_ALPINE';
delete from UnitPromotionPrereqs where UnitPromotion = 'PROMOTION_AMBUSH' and PrereqUnitPromotion = 'PROMOTION_GUERRILLA';
-- Heavy
update UnitPromotionPrereqs set UnitPromotion = 'PROMOTION_ROUT' where UnitPromotion = 'PROMOTION_MARAUDING' and PrereqUnitPromotion = 'PROMOTION_CHARGE';
update UnitPromotionPrereqs set UnitPromotion = 'PROMOTION_MARAUDING' where UnitPromotion = 'PROMOTION_ROUT' and PrereqUnitPromotion = 'PROMOTION_BARDING';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_ROUT' where UnitPromotion = 'PROMOTION_ARMOR_PIERCING' and PrereqUnitPromotion = 'PROMOTION_MARAUDING';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_MARAUDING' where UnitPromotion = 'PROMOTION_REACTIVE_ARMOR' and PrereqUnitPromotion = 'PROMOTION_ROUT';
update UnitPromotionPrereqs set UnitPromotion = 'PROMOTION_HEAVYC_SHOCK' where UnitPromotion = 'PROMOTION_ROUT';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_HEAVYC_SHOCK' where PrereqUnitPromotion = 'PROMOTION_ROUT';
-- Light
update UnitPromotionPrereqs set UnitPromotion = 'PROMOTION_LIGHTC_MOBILE_WARFARE' where UnitPromotion = 'PROMOTION_SPIKING_THE_GUNS';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_LIGHTC_MOBILE_WARFARE' where PrereqUnitPromotion = 'PROMOTION_SPIKING_THE_GUNS';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_LIGHTC_MILITANT' where PrereqUnitPromotion = 'PROMOTION_DEPREDATION';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_LIGHTC_SHOCK' where PrereqUnitPromotion = 'PROMOTION_DOUBLE_ENVELOPMENT';
delete from UnitPromotionPrereqs where UnitPromotion = 'PROMOTION_DEPREDATION' or UnitPromotion = 'PROMOTION_DOUBLE_ENVELOPMENT';
delete from UnitPromotionPrereqs where UnitPromotion = 'PROMOTION_SPYGLASS' and PrereqUnitPromotion = 'PROMOTION_SENTRY';

insert or replace into UnitPromotionPrereqs
    (UnitPromotion,                 PrereqUnitPromotion)
values
    -- recon
    ('PROMOTION_RECON_TRAVEL_LIGHT', 'PROMOTION_GUERRILLA'),
    ('PROMOTION_SENTRY',            'PROMOTION_SPYGLASS'),
    ('PROMOTION_AMBUSH',            'PROMOTION_RECON_TRAVEL_LIGHT'),
    ('PROMOTION_AMBUSH',            'PROMOTION_SENTRY'),
    ('PROMOTION_RECON_RAPID_FIRE',  'PROMOTION_AMBUSH'),
    ('PROMOTION_RECON_ACCURATE',    'PROMOTION_AMBUSH'),
    -- Heavy
    -- Light
    ('PROMOTION_LIGHTC_MILITANT',   'PROMOTION_DEPREDATION'),
    ('PROMOTION_LIGHTC_SHOCK',      'PROMOTION_DOUBLE_ENVELOPMENT');

-- Remove unused promotions
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_RANGER' or UnitPromotionType = 'PROMOTION_ALPINE' or UnitPromotionType = 'PROMOTION_CAMOUFLAGE';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_ROUT';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_COURSERS' or UnitPromotionType = 'PROMOTION_CAPARISON' or UnitPromotionType = 'PROMOTION_SPIKING_THE_GUNS';

update ModifierArguments set Value = 5 where ModifierId = 'AMBUSH_INCREASED_COMBAT_STRENGTH' and Name = 'Amount';
delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_ARMOR_PIERCING';
delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_REACTIVE_ARMOR';
delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_EXPERT_CREW' and ModifierId = 'EXPERT_CREW_BONUS_ATTACK_AFTER_MOVING';
delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_PURSUIT';

insert or replace into UnitPromotionModifiers
    (UnitPromotionType,                 ModifierId)
values
    ('PROMOTION_SENTRY',                'SPYGLASS_BONUS_SIGHT'),
    ('PROMOTION_RECON_TRAVEL_LIGHT',    'TRAVEL_LIGHT_BONUS_MOVEMENT'),
    ('PROMOTION_SPYGLASS',              'SPYGLASS_SEE_HIDDEN'),
    ('PROMOTION_GUERRILLA',             'GUERRILLA_ATTACK_BUFF_HD'),
    ('PROMOTION_AMBUSH',                'AMBUSH_STEALTH'),
    ('PROMOTION_RECON_RAPID_FIRE',      'RAPID_FIRE_ADDITIONAL_ATTACK'),
    ('PROMOTION_RECON_ACCURATE',        'ACCURATE_BONUS_RANGE'),
    -- Heavy Cavalry
    ('PROMOTION_HEAVYC_SHOCK',          'SHOCK_OPEN_AREA_STRENGTH'),
    ('PROMOTION_ARMOR_PIERCING',        'ARMOR_PIERCING_ATTACK_BONUS'),
    ('PROMOTION_ARMOR_PIERCING',        'ARMOR_PIERCING_ATTACK_BONUS_HIGHER_STRENGTH'),
    ('PROMOTION_REACTIVE_ARMOR',        'REACTIVE_ARMOR_DEFEND_BONUS'),
    ('PROMOTION_REACTIVE_ARMOR',        'REACTIVE_ARMOR_DEFEND_BONUS_HIGHER_STRENGTH'),
    -- Light
    ('PROMOTION_LIGHTC_SHOCK',          'SHOCK_OPEN_AREA_STRENGTH'),
    ('PROMOTION_LIGHTC_MILITANT',       'MILITANT_ENEMY_TERRITORY_STRENGTH'),
    ('PROMOTION_LIGHTC_MOBILE_WARFARE', 'PURSUIT_BONUS_MOVEMENT'),
    ('PROMOTION_LIGHTC_MOBILE_WARFARE', 'FADE_BONUS_MOVE_AFTER_ATTACKING'),
    ('PROMOTION_PURSUIT',               'PURSUIT_BONUS_VS_WOUNDED_UNITS'),
    ('PROMOTION_ESCORT_MOBILITY',       'ESCORT_BONUS_IN_FORMATION'),
    -- Siege
    ('PROMOTION_EXPERT_CREW',           'EXPERT_CREW_MOVEMENT');

insert or replace into Modifiers
    (ModifierId,                                            ModifierType)
values
    -- recon
    ('TRAVEL_LIGHT_BONUS_MOVEMENT',                         'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT'),
    ('TRAVEL_LIGHT_IGNORE_ZOC',                             'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_ZOC'),
    ('SPYGLASS_SEE_HIDDEN',                                 'MODIFIER_PLAYER_UNIT_ADJUST_SEE_HIDDEN'),
    ('AMBUSH_STEALTH',                                      'MODIFIER_PLAYER_UNIT_ADJUST_HIDDEN_VISIBILITY'),
    ('RAPID_FIRE_ADDITIONAL_ATTACK',                        'MODIFIER_UNIT_ADJUST_NUM_ATTACKS'),
    ('ACCURATE_BONUS_RANGE',                                'MODIFIER_UNIT_ADJUST_ATTACK_RANGE'),
    ('HD_RECON_LOWER_MOVEMENT',                             'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT'),
    ('HD_RECON_IGNORE_HILLS_MOVEMENT_PENALTY',              'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_TERRAIN_COST'),
    ('HD_RECON_IGNORE_FOREST_MOVEMENT_PENALTY',             'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_TERRAIN_COST'),
    ('HD_LIGHT_CAVALRY_ADVANCED_PILLAGING',                 'MODIFIER_PLAYER_UNIT_ADJUST_ADVANCED_PILLAGING');

insert or replace into Modifiers
    (ModifierId,                                            ModifierType,                               SubjectRequirementSetId)
values
    ('GUERRILLA_ATTACK_BUFF_HD',                            'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'HD_UNIT_ATTACKING_REQUIREMENTS'),
    -- 
    ('ARMOR_PIERCING_ATTACK_BONUS',                         'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'HD_UNIT_ATTACKING_REQUIREMENTS'),
    ('ARMOR_PIERCING_ATTACK_BONUS_HIGHER_STRENGTH',         'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'HD_UNIT_ATTACK_WEAKER_UNIT_REQUIREMENTS'),
    ('REACTIVE_ARMOR_DEFEND_BONUS',                         'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'HD_UNIT_DEFENDING_REQUIREMENTS'),
    ('REACTIVE_ARMOR_DEFEND_BONUS_HIGHER_STRENGTH',         'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'HD_UNIT_DEFEND_WEAKER_OPPONENT_REQUIREMENTS'),
    -- 
    ('SHOCK_OPEN_AREA_STRENGTH',                            'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'PLOT_IS_OPEN_AREA_REQUIREMENTS'),
    ('MILITANT_ENEMY_TERRITORY_STRENGTH',                   'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'BERSERKER_PLOT_IS_ENEMY_TERRITORY'),
    ('PURSUIT_BONUS_VS_WOUNDED_UNITS',                      'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'REQUIREMENTS_OPPONENT_IS_WOUNDED'),
    ('ESCORT_BONUS_IN_FORMATION',                           'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',     'CONVOY_REQUIREMENTS'),
    -- 
    ('HD_SIEGE_CAVALRY_MOVEMENT',                           'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',     'HD_NEAR_CAVALRY_REQUIREMENTS'),
    ('EXPERT_CREW_MOVEMENT',                                'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',     NULL);

insert or replace into ModifierArguments
    (ModifierId,                                            Name,           Value)
values
    -- recon
    ('TRAVEL_LIGHT_BONUS_MOVEMENT',                         'Amount',       1),
    ('TRAVEL_LIGHT_IGNORE_ZOC',                             'Ignore',       1),
    ('SPYGLASS_SEE_HIDDEN',                                 'SeeHidden',    1),
    ('GUERRILLA_ATTACK_BUFF_HD',                            'Amount',       5),
    ('AMBUSH_STEALTH',                                      'Hidden',       1),
    ('RAPID_FIRE_ADDITIONAL_ATTACK',                        'Amount',       1),
    ('ACCURATE_BONUS_RANGE',                                'Amount',       1),
    ('HD_RECON_IGNORE_HILLS_MOVEMENT_PENALTY',              'Ignore',       1),
    ('HD_RECON_IGNORE_HILLS_MOVEMENT_PENALTY',              'Type',         'HILLS'),
    ('HD_RECON_IGNORE_FOREST_MOVEMENT_PENALTY',             'Ignore',       1),
    ('HD_RECON_IGNORE_FOREST_MOVEMENT_PENALTY',             'Type',         'FOREST'),
    -- heavy
    ('ARMOR_PIERCING_ATTACK_BONUS',                         'Amount',       5),
    ('ARMOR_PIERCING_ATTACK_BONUS_HIGHER_STRENGTH',         'Amount',       5),
    ('REACTIVE_ARMOR_DEFEND_BONUS',                         'Amount',       7),
    ('REACTIVE_ARMOR_DEFEND_BONUS_HIGHER_STRENGTH',         'Amount',       7),
    -- light
    ('HD_LIGHT_CAVALRY_ADVANCED_PILLAGING',                 'UseAdvancedPillaging', 1),
    ('SHOCK_OPEN_AREA_STRENGTH',                            'Amount',       5),
    ('MILITANT_ENEMY_TERRITORY_STRENGTH',                   'Amount',       5),
    ('PURSUIT_BONUS_VS_WOUNDED_UNITS',                      'Amount',       7),
    ('ESCORT_BONUS_IN_FORMATION',                           'Amount',       7),
    -- siege
    ('HD_SIEGE_CAVALRY_MOVEMENT',                           'Amount',       1),
    ('EXPERT_CREW_MOVEMENT',                                'Amount',       1);

insert or replace into ModifierStrings
    (ModifierId,                                            Context,    Text)
values
    ('GUERRILLA_ATTACK_BUFF_HD',                            'Preview',  '+{1_Amount} {LOC_PROMOTION_GUERRILLA_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('ARMOR_PIERCING_ATTACK_BONUS',                         'Preview',  '+{1_Amount} {LOC_PROMOTION_ARMOR_PIERCING_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('ARMOR_PIERCING_ATTACK_BONUS_HIGHER_STRENGTH',         'Preview',  '+{1_Amount} {LOC_PROMOTION_ARMOR_PIERCING_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('REACTIVE_ARMOR_DEFEND_BONUS',                         'Preview',  '+{1_Amount} {LOC_PROMOTION_REACTIVE_ARMOR_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('REACTIVE_ARMOR_DEFEND_BONUS_HIGHER_STRENGTH',         'Preview',  '+{1_Amount} {LOC_PROMOTION_REACTIVE_ARMOR_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('SHOCK_OPEN_AREA_STRENGTH',                            'Preview',  '+{1_Amount} {LOC_PROMOTION_LIGHTC_SHOCK_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('MILITANT_ENEMY_TERRITORY_STRENGTH',                   'Preview',  '+{1_Amount} {LOC_PROMOTION_LIGHTC_MILITANT_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('PURSUIT_BONUS_VS_WOUNDED_UNITS',                      'Preview',  '+{1_Amount} {LOC_PROMOTION_PURSUIT_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}'),
    ('ESCORT_BONUS_IN_FORMATION',                           'Preview',  '+{1_Amount} {LOC_PROMOTION_ESCORT_MOBILITY_NAME} {LOC_PROMOTION_DESCRIPTOR_PREVIEW_TEXT}');

--------------------------------------------------------------------------------------------------------------
-- Requirements
insert or replace into RequirementSets
    (RequirementSetId,                              RequirementSetType)
values
    ('HD_UNIT_IS_FLANKED_REQUIREMENTS',             'REQUIREMENTSET_TEST_ALL'),
    -- 
    ('HD_UNIT_ATTACKING_REQUIREMENTS',              'REQUIREMENTSET_TEST_ALL'),
    ('HD_UNIT_DEFENDING_REQUIREMENTS',              'REQUIREMENTSET_TEST_ALL'),
    -- 
    ('HD_UNIT_ATTACKING_UNIT_REQUIREMENTS',         'REQUIREMENTSET_TEST_ALL'),
    ('HD_UNIT_ATTACK_WEAKER_UNIT_REQUIREMENTS',     'REQUIREMENTSET_TEST_ALL'),
    ('HD_UNIT_DEFEND_WEAKER_OPPONENT_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'),
    -- 
    ('ANTI_CAVALRY_DEFEND_OPPONENT_REQUIREMENTS',   'REQUIREMENTSET_TEST_ALL'),
    -- 
    ('HD_NEAR_ANTI_CAVALRY_REQUIREMENTS',           'REQUIREMENTSET_TEST_ALL'),
    ('HD_NEAR_CAVALRY_REQUIREMENTS',                'REQUIREMENTSET_TEST_ANY');

insert or replace into RequirementSetRequirements
    (RequirementSetId,                              RequirementId)
values
    ('HD_UNIT_IS_FLANKED_REQUIREMENTS',             'HD_REQUIRES_UNIT_IS_FLANKED'),
    -- 
    ('HD_UNIT_ATTACKING_REQUIREMENTS',              'PLAYER_IS_ATTACKER_REQUIREMENTS'),
    ('HD_UNIT_DEFENDING_REQUIREMENTS',              'PLAYER_IS_DEFENDER_REQUIREMENTS'),
    -- 
    ('HD_UNIT_ATTACKING_UNIT_REQUIREMENTS',         'PLAYER_IS_ATTACKER_REQUIREMENTS'),
    ('HD_UNIT_ATTACKING_UNIT_REQUIREMENTS',         'OPPONENT_IS_NOT_DISTRICT'),
    ('HD_UNIT_ATTACK_WEAKER_UNIT_REQUIREMENTS',     'REQUIRES_COMBAT_AGAINST_WEAKER_OPPONENT'),
    ('HD_UNIT_ATTACK_WEAKER_UNIT_REQUIREMENTS',     'PLAYER_IS_ATTACKER_REQUIREMENTS'),
    ('HD_UNIT_ATTACK_WEAKER_UNIT_REQUIREMENTS',     'OPPONENT_IS_NOT_DISTRICT'),
    ('HD_UNIT_DEFEND_WEAKER_OPPONENT_REQUIREMENTS', 'REQUIRES_COMBAT_AGAINST_WEAKER_OPPONENT'),
    ('HD_UNIT_DEFEND_WEAKER_OPPONENT_REQUIREMENTS', 'PLAYER_IS_DEFENDER_REQUIREMENTS'),
    -- 
    ('ANTI_CAVALRY_DEFEND_OPPONENT_REQUIREMENTS',   'PLAYER_IS_DEFENDER_REQUIREMENTS'),
    ('ANTI_CAVALRY_DEFEND_OPPONENT_REQUIREMENTS',   'REQUIRES_OPPONENT_IS_CAVALRY'),
    -- 
    ('HD_NEAR_ANTI_CAVALRY_REQUIREMENTS',           'REQUIRES_ANTI_CAVALRY_NEXT_TO_OWNER'),
    ('HD_NEAR_CAVALRY_REQUIREMENTS',                'REQUIRES_LIGHT_CAVALRY_NEXT_TO_OWNER'),
    ('HD_NEAR_CAVALRY_REQUIREMENTS',                'REQUIRES_HEAVY_CAVALRY_NEXT_TO_OWNER');

insert or replace into Requirements
    (RequirementId,                                 RequirementType,                                        Inverse)
values
    ('HD_REQUIRES_UNIT_IS_FLANKED',                 'REQUIREMENT_PLOT_UNIT_FLANKED',                        0),
    ('REQUIRES_COMBAT_AGAINST_WEAKER_OPPONENT',     'REQUIREMENT_OPPONENT_IS_STRONGER',                     1),
    ('REQUIRES_ANTI_CAVALRY_NEXT_TO_OWNER',         'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TAG_MATCHES',  0),
    ('REQUIRES_LIGHT_CAVALRY_NEXT_TO_OWNER',        'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TAG_MATCHES',  0),
    ('REQUIRES_HEAVY_CAVALRY_NEXT_TO_OWNER',        'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TAG_MATCHES',  0);

insert or replace into RequirementArguments
    (RequirementId,                                 Name,       Value)
values
    ('REQUIRES_ANTI_CAVALRY_NEXT_TO_OWNER',         'Tag',      'CLASS_ANTI_CAVALRY'),
    ('REQUIRES_LIGHT_CAVALRY_NEXT_TO_OWNER',        'Tag',      'CLASS_LIGHT_CAVALRY'),
    ('REQUIRES_HEAVY_CAVALRY_NEXT_TO_OWNER',        'Tag',      'CLASS_HEAVY_CAVALRY');
--海军近战单位升级改动：左一舵手改为一速一视野
--海军远程单位升级改动：右三球鼻艏改为一速一视野
--海军袭击者焦土政策：海岸扫荡不结束回合
--重骑兵单位升级改动：右三反应装甲改为将领卫队：给周围一环单位+2力（升级线左右三互通）
delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_REACTIVE_ARMOR' and ModifierId = 'REACTIVE_ARMOR_DEFEND_BONUS';
delete from UnitPromotionModifiers where UnitPromotionType = 'PROMOTION_REACTIVE_ARMOR' and ModifierId = 'REACTIVE_ARMOR_DEFEND_BONUS_HIGHER_STRENGTH';
insert or replace into UnitPromotionPrereqs
    (UnitPromotion,                 PrereqUnitPromotion)
values
    ('PROMOTION_REACTIVE_ARMOR',    'PROMOTION_HEAVYC_SHOCK'),
    ('PROMOTION_ARMOR_PIERCING',    'PROMOTION_MARAUDING');
insert or replace into UnitPromotionModifiers
    (UnitPromotionType,             ModifierId)
values
    ('PROMOTION_HELMSMAN',          'HELMSMAN_BONUS_WATER_PERSPECTIVE'),
    ('PROMOTION_BULB_BOW',          'BULB_BOW_BONUS_WATER_PERSPECTIVE'),
    ('PROMOTION_REACTIVE_ARMOR',    'HD_GENERAL_GUARD');
insert or replace into Modifiers
    (ModifierId,                                    ModifierType,                                           SubjectRequirementSetId)
values
    ('HELMSMAN_BONUS_WATER_PERSPECTIVE',            'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT',                    NULL),
    ('BULB_BOW_BONUS_WATER_PERSPECTIVE',            'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT',                    NULL),
    ('HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID',          'MODIFIER_PLAYER_UNIT_ADJUST_ADVANCED_COASTAL_RAID',    NULL),
    ('HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID_MODIFIER', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',                  NULL),
    ('HD_GENERAL_GUARD',                            'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',                  'HD_AOE_REQUIRES_GENERAL_GUARD'),
    ('HD_GENERAL_GUARD_STRENGTH',                   'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',                 NULL);
insert or replace into ModifierArguments
    (ModifierId,                                        Name,                           Value)
values
    ('HELMSMAN_BONUS_WATER_PERSPECTIVE',                'Amount',                       1),
    ('BULB_BOW_BONUS_WATER_PERSPECTIVE',                'Amount',                       1),
    ('HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID',              'UseAdvancedCoastalRaid',       1),
    ('HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID_MODIFIER',     'AbilityType',                  'ABILITY_HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID'),
    ('HD_GENERAL_GUARD',                                'AbilityType',                  'ABILITY_GENERAL_GUARD_STRENGTH'),
    ('HD_GENERAL_GUARD_STRENGTH',                       'Amount',                       2);
insert or replace into CivicModifiers
    (CivicType,                                         ModifierId)
values
    ('CIVIC_SCORCHED_EARTH',                            'HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID_MODIFIER');

insert or replace into Types
    (Type,                                              Kind)
values
    ('ABILITY_HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID',      'KIND_ABILITY'),
    ('ABILITY_GENERAL_GUARD_STRENGTH',                  'KIND_ABILITY');
insert or replace into TypeTags
    (Type,                                              Tag)
values
    ('ABILITY_HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID',      'CLASS_NAVAL_RAIDER');
insert or replace into TypeTags 
    (Type,                                              Tag)
select 'ABILITY_GENERAL_GUARD_STRENGTH',Tag from TypeTags where Type = 'ABILITY_GREAT_GENERAL_STRENGTH';
insert or replace into UnitAbilities
    (UnitAbilityType,                                   Name,                                   Description,                                                        inactive,   Permanent)
values
    ('ABILITY_HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID',      null,                                   'LOC_ABILITY_HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID_DESCRIPTION',       1,          1),
    ('ABILITY_GENERAL_GUARD_STRENGTH',                  'LOC_GENERAL_GUARD_STRENGTH_NAME',      'LOC_GENERAL_GUARD_STRENGTH_DESCRIPTION',                           1,          0);
insert or ignore into UnitAbilityModifiers
    (UnitAbilityType,                                   ModifierId)
values
    ('ABILITY_HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID',      'HD_NAVAL_RAIDER_LESS_MOVEMENT_RAID'),
    ('ABILITY_GENERAL_GUARD_STRENGTH',                  'HD_GENERAL_GUARD_STRENGTH');
insert or replace into ModifierStrings
    (ModifierId,                                Context,        Text)
values
    ('HD_GENERAL_GUARD_STRENGTH',               'Preview',      '+{1_Amount} {LOC_HD_GENERAL_GUARD_PREVIEW_TEXT}');

--海军远程左2右2换位
update UnitPromotions set Column = 3 where UnitPromotionType = 'PROMOTION_PREPARATORY_FIRE';
update UnitPromotions set Column = 1 where UnitPromotionType = 'PROMOTION_ROLLING_BARRAGE';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_BOMBARDMENT' where UnitPromotion = 'PROMOTION_PREPARATORY_FIRE';
update UnitPromotionPrereqs set PrereqUnitPromotion = 'PROMOTION_LINE_OF_BATTLE' where UnitPromotion = 'PROMOTION_ROLLING_BARRAGE';
--------------------------------------------------------------------------------------------------------------
--SPY-删除游击队领袖、火箭专家、隐秘行动、掩饰和王牌驾驶员等5个间谍升级V1.34
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_GUERILLA_LEADER';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_ROCKET_SCIENTIST';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_DISGUISE';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_COVERT_ACTION';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_ACE_DRIVER';
--SPY-删除       V1.41
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_TECHNOLOGIST';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_CAT_BURGLAR';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_DEMOLITIONS';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_CON_ARTIST';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_SEDUCTION';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_QUARTERMASTER';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_SMEAR_CAMPAIGN';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_LICENSE_TO_KILL';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_SATCHEL_CHARGES';
delete from UnitPromotions where UnitPromotionType = 'PROMOTION_SPY_SURVEILLANCE';

-- insert or replace into Modifiers
--     (ModifierId,                                    ModifierType,                         RunOnce, Permanent, SubjectRequirementSetId)
-- values
--     ('HD_SPY_ACE_DRIVER',                           'MODIFIER_PLAYER_UNIT_GRANT_ABILITY', 1,       0,         'PLAYER_IS_HUMAN');
-- insert or replace into ModifierArguments
--     (ModifierId,                            Name,           Value)
-- values
--     ('HD_SPY_ACE_DRIVER',                   'AbilityType',  'ABILITY_HD_SPY_ACE_DRIVER');

--SPY-新间谍升级-向导/观察者/先驱/吐丝结网/外交家/教官/密码通讯/测谎仪/审讯专家/巧言/混乱/爆破专家/英豪/隐秘行动/商业密探/资深骗子/学者/变容/语言学家/本地线人/织网者
insert or replace into Types
    (Type,                                          Kind)
values
    --向导
    ('PROMOTION_SPY_PATHFINDER',                    'KIND_PROMOTION'),
    --观察者
    ('PROMOTION_SPY_OBSERVER',                      'KIND_PROMOTION'),
    --先驱
    ('PROMOTION_SPY_PIONEER',                       'KIND_PROMOTION'),    
 --   ('PROMOTION_SPY_SPIN_WEB',                      'KIND_PROMOTION'),
    --外交家
    ('PROMOTION_SPY_DIPLOMAT',                      'KIND_PROMOTION'),
    --教官
    ('PROMOTION_SPY_INSTRUCTOR',                    'KIND_PROMOTION'),
    --密码通讯
    ('PROMOTION_SPY_CRYPTOGRAPHY',                  'KIND_PROMOTION'),
    --测谎仪
    ('PROMOTION_SPY_POLYGRAPH',                     'KIND_PROMOTION'),
    --审讯专家
    ('PROMOTION_SPY_INQUISITOR',                    'KIND_PROMOTION'),
    --巧言
    ('PROMOTION_SPY_RHETORIC',                      'KIND_PROMOTION'),
    --混乱
    ('PROMOTION_SPY_CHAOS',                         'KIND_PROMOTION'),
    --爆破专家
    ('PROMOTION_SPY_DEMOLITIONIST',                 'KIND_PROMOTION'),
    --英豪
    ('PROMOTION_SPY_HEROES',                        'KIND_PROMOTION'),
    --隐秘行动
    ('PROMOTION_SPY_COVERT_OPERATION',              'KIND_PROMOTION'),
    --商业密探
    ('PROMOTION_SPY_COMMERCIAL_SPY',                'KIND_PROMOTION'),
    --资深骗子
    ('PROMOTION_SPY_SENIOR_CHEATER',                'KIND_PROMOTION'),
    --学者
    ('PROMOTION_SPY_SCHOLAR',                       'KIND_PROMOTION'),
    --变容
    ('PROMOTION_SPY_TRANSFIGURATION',               'KIND_PROMOTION'),
    --语言学家
    ('PROMOTION_SPY_LINGUIST',                      'KIND_PROMOTION'),
    --本地线人
    ('PROMOTION_SPY_LOCAL_INFORMANT',               'KIND_PROMOTION'),
    --织网者
    ('PROMOTION_SPY_WEBBER',                        'KIND_PROMOTION');
insert or replace into UnitPromotions
    (UnitPromotionType,                 Name,                                       Description,                                        PromotionClass,    Level,  Column)
values
    ('PROMOTION_SPY_PATHFINDER',        'LOC_PROMOTION_SPY_PATHFINDER_NAME',        'LOC_PROMOTION_SPY_PATHFINDER_DESCRIPTION',         'PROMOTION_CLASS_SPY', 1,  NULL),
    ('PROMOTION_SPY_OBSERVER',          'LOC_PROMOTION_SPY_OBSERVER_NAME',          'LOC_PROMOTION_SPY_OBSERVER_DESCRIPTION',           'PROMOTION_CLASS_SPY', 2,  NULL),
    ('PROMOTION_SPY_PIONEER',           'LOC_PROMOTION_SPY_PIONEER_NAME',           'LOC_PROMOTION_SPY_PIONEER_DESCRIPTION',            'PROMOTION_CLASS_SPY', 3,  NULL),
--    ('PROMOTION_SPY_SPIN_WEB',    'LOC_PROMOTION_SPY_SPIN_WEB_NAME',   'LOC_PROMOTION_SPY_SPIN_WEB_DESCRIPTION',    'PROMOTION_CLASS_SPY', 2,  NULL),
    ('PROMOTION_SPY_DIPLOMAT',          'LOC_PROMOTION_SPY_DIPLOMAT_NAME',          'LOC_PROMOTION_SPY_DIPLOMAT_DESCRIPTION',           'PROMOTION_CLASS_SPY', 4,  NULL),
    ('PROMOTION_SPY_INSTRUCTOR',        'LOC_PROMOTION_SPY_INSTRUCTOR_NAME',        'LOC_PROMOTION_SPY_INSTRUCTOR_DESCRIPTION',         'PROMOTION_CLASS_SPY', 1,  NULL),
    ('PROMOTION_SPY_CRYPTOGRAPHY',      'LOC_PROMOTION_SPY_CRYPTOGRAPHY_NAME',      'LOC_PROMOTION_SPY_CRYPTOGRAPHY_DESCRIPTION',       'PROMOTION_CLASS_SPY', 2,  NULL),
    ('PROMOTION_SPY_POLYGRAPH',         'LOC_PROMOTION_SPY_POLYGRAPH_NAME',         'LOC_PROMOTION_SPY_POLYGRAPH_DESCRIPTION',          'PROMOTION_CLASS_SPY', 3,  NULL),
    ('PROMOTION_SPY_INQUISITOR',        'LOC_PROMOTION_SPY_INQUISITOR_NAME',        'LOC_PROMOTION_SPY_INQUISITOR_DESCRIPTION',         'PROMOTION_CLASS_SPY', 4,  NULL),
    ('PROMOTION_SPY_RHETORIC',          'LOC_PROMOTION_SPY_RHETORIC_NAME',          'LOC_PROMOTION_SPY_RHETORIC_DESCRIPTION',           'PROMOTION_CLASS_SPY', 1,  NULL),
    ('PROMOTION_SPY_CHAOS',             'LOC_PROMOTION_SPY_CHAOS_NAME',             'LOC_PROMOTION_SPY_CHAOS_DESCRIPTION',              'PROMOTION_CLASS_SPY', 2,  NULL),
    ('PROMOTION_SPY_DEMOLITIONIST',     'LOC_PROMOTION_SPY_DEMOLITIONIST_NAME',     'LOC_PROMOTION_SPY_DEMOLITIONIST_DESCRIPTION',      'PROMOTION_CLASS_SPY', 3,  NULL),
    ('PROMOTION_SPY_HEROES',            'LOC_PROMOTION_SPY_HEROES_NAME',            'LOC_PROMOTION_SPY_HEROES_DESCRIPTION',             'PROMOTION_CLASS_SPY', 4,  NULL),
    ('PROMOTION_SPY_COVERT_OPERATION',  'LOC_PROMOTION_SPY_COVERT_OPERATION_NAME',  'LOC_PROMOTION_SPY_COVERT_OPERATION_DESCRIPTION',   'PROMOTION_CLASS_SPY', 1,  NULL),
    ('PROMOTION_SPY_COMMERCIAL_SPY',    'LOC_PROMOTION_SPY_COMMERCIAL_SPY_NAME',    'LOC_PROMOTION_SPY_COMMERCIAL_SPY_DESCRIPTION',     'PROMOTION_CLASS_SPY', 2,  NULL),
    ('PROMOTION_SPY_SENIOR_CHEATER',    'LOC_PROMOTION_SPY_SENIOR_CHEATER_NAME',    'LOC_PROMOTION_SPY_SENIOR_CHEATER_DESCRIPTION',     'PROMOTION_CLASS_SPY', 3,  NULL),
    ('PROMOTION_SPY_SCHOLAR',           'LOC_PROMOTION_SPY_SCHOLAR_NAME',           'LOC_PROMOTION_SPY_SCHOLAR_DESCRIPTION',            'PROMOTION_CLASS_SPY', 4,  NULL),
    ('PROMOTION_SPY_TRANSFIGURATION',   'LOC_PROMOTION_SPY_TRANSFIGURATION_NAME',   'LOC_PROMOTION_SPY_TRANSFIGURATION_DESCRIPTION',    'PROMOTION_CLASS_SPY', 1,  NULL),
    ('PROMOTION_SPY_LINGUIST',          'LOC_PROMOTION_SPY_LINGUIST_NAME',          'LOC_PROMOTION_SPY_LINGUIST_DESCRIPTION',           'PROMOTION_CLASS_SPY', 2,  NULL),
    ('PROMOTION_SPY_LOCAL_INFORMANT',   'LOC_PROMOTION_SPY_LOCAL_INFORMANT_NAME',   'LOC_PROMOTION_SPY_LOCAL_INFORMANT_DESCRIPTION',    'PROMOTION_CLASS_SPY', 3,  NULL),
    ('PROMOTION_SPY_WEBBER',            'LOC_PROMOTION_SPY_WEBBER_NAME',            'LOC_PROMOTION_SPY_WEBBER_DESCRIPTION',             'PROMOTION_CLASS_SPY', 4,  NULL);
insert or replace into UnitPromotionModifiers
    (UnitPromotionType,                             ModifierId)
values
    ('PROMOTION_SPY_PATHFINDER',                    'HD_SPY_PATHFINDER'),
    ('PROMOTION_SPY_PIONEER',                       'HD_SPY_PIONEER'),
 --   ('PROMOTION_SPY_SPIN_WEB',                      'HD_SPY_SPIN_WEB'),
    ('PROMOTION_SPY_DIPLOMAT',                      'HD_SPY_DIPLOMAT_INFLUENCE_POINTS'),
    ('PROMOTION_SPY_COMMERCIAL_SPY',                'HD_SPY_COMMERCIAL_SPY_SUCCESS_LEVEL'),
    ('PROMOTION_SPY_COMMERCIAL_SPY',                'HD_SPY_COMMERCIAL_SPY_GREATPERSON_POINTS'),
    -- ('PROMOTION_SPY_SENIOR_CHEATER',                'SENIOR_CHEATER_ESCAPE_LEVEL'),
    ('PROMOTION_SPY_INSTRUCTOR',                    'INSTRUCTOR_SPY_PRODUCTION'),
    ('PROMOTION_SPY_CRYPTOGRAPHY',                  'SPY_QUARTERMASTER'),
    ('PROMOTION_SPY_CRYPTOGRAPHY',                  'SPY_POLYGRAPH'),
    ('PROMOTION_SPY_POLYGRAPH',                     'SPY_SURVEILLANCE_ENTIRE_CITY'),
    ('PROMOTION_SPY_POLYGRAPH',                     'SPY_SURVEILLANCE_ADJACENT_LEVEL'),
    ('PROMOTION_SPY_INQUISITOR',                    'SPY_INQUISITOR_ENEMY_LEVEL'),
    ('PROMOTION_SPY_INQUISITOR',                    'SPY_INQUISITOR_COUNTERYSPY_SCIENCE'),
    ('PROMOTION_SPY_RHETORIC',                      'SPY_COVERT_ACTION'),
    ('PROMOTION_SPY_RHETORIC',                      'SPY_SMEAR_CAMPAIGN'),
    ('PROMOTION_SPY_DEMOLITIONIST',                 'SPY_ROCKET_SCIENTIST'),
    ('PROMOTION_SPY_DEMOLITIONIST',                 'SPY_DEMOLITIONS'),
    ('PROMOTION_SPY_DEMOLITIONIST',                 'SPY_LICENSE_TO_KILL'),
    ('PROMOTION_SPY_DEMOLITIONIST',                 'SPY_SATCHEL_CHARGES'),
    ('PROMOTION_SPY_COVERT_OPERATION',              'SPY_TECHNOLOGIST'),
    ('PROMOTION_SPY_COVERT_OPERATION',              'SPY_CAT_BURGLAR'),
    ('PROMOTION_SPY_OBSERVER',                      'HD_SPY_OBSERVER_UNOBSTRUCTED'),
    ('PROMOTION_SPY_OBSERVER',                      'HD_SPY_OBSERVER_HD_SEE_HIDDEN'),
    ('PROMOTION_SPY_OBSERVER',                      'HD_SPY_OBSERVER_SPYGLASS_SIGHT');

--变容
insert or replace into UnitPromotionModifiers   (UnitPromotionType, ModifierId)
select 'PROMOTION_SPY_TRANSFIGURATION',    'SPY_TRANSFIGURATION_' || OperationType || '_TIME'
from UnitOperations where Offensive = 1;
insert or replace into Modifiers   (ModifierId, ModifierType)
select 'SPY_TRANSFIGURATION_' || OperationType || '_TIME',    'MODIFIER_PLAYER_UNIT_ADJUST_SPY_OPERATION_TIME'
from UnitOperations where Offensive = 1;
insert or replace into ModifierArguments   (ModifierId, Name,   Value)
select 'SPY_TRANSFIGURATION_' || OperationType || '_TIME',    'OperationType',     OperationType
from UnitOperations where Offensive = 1;
insert or replace into ModifierArguments   (ModifierId, Name,   Value)
select 'SPY_TRANSFIGURATION_' || OperationType || '_TIME',    'ReductionPercent',  15
from UnitOperations where Offensive = 1;
--语言学家
insert or replace into UnitPromotionModifiers   (UnitPromotionType, ModifierId)
select 'PROMOTION_SPY_LINGUIST',    'SPY_LINGUIST_' || OperationType || '_TIME'
from UnitOperations where Offensive = 1;
insert or replace into Modifiers   (ModifierId, ModifierType)
select 'SPY_LINGUIST_' || OperationType || '_TIME',    'MODIFIER_PLAYER_UNIT_ADJUST_SPY_OPERATION_TIME'
from UnitOperations where Offensive = 1;
insert or replace into ModifierArguments   (ModifierId, Name,   Value)
select 'SPY_LINGUIST_' || OperationType || '_TIME',    'OperationType',     OperationType
from UnitOperations where Offensive = 1;
insert or replace into ModifierArguments   (ModifierId, Name,   Value)
select 'SPY_LINGUIST_' || OperationType || '_TIME',    'ReductionPercent',  20
from UnitOperations where Offensive = 1;

--------------------------------------------------------------------------------------------------------------
--SPY-间谍向导相关的范围加速代码，先驱相关的范围无视地形地貌代码，观察者的视野代码

insert or replace into Modifiers
    (ModifierId,                                    ModifierType,                                                   Permanent,      SubjectRequirementSetId)
values
    ('HD_SPY_PATHFINDER',                           'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',                          null,           'HD_AOE_REQUIRES_SPY_PATHFINDER'),
    ('HD_SPY_PATHFINDER_MOVEMENT',                  'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',                         0,              NULL),
    ('HD_SPY_PIONEER',                              'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',                          null,           'HD_AOE_REQUIRES_SPY_PIONEER'),
    ('HD_SPY_PIONEER_IGNORE',                       'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_TERRAIN_COST',              0,              NULL),
    ('HD_SPY_DIPLOMAT_INFLUENCE_POINTS',            'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN',             0,              NULL),
    ('HD_SPY_COMMERCIAL_SPY_SUCCESS_LEVEL',         'MODIFIER_PLAYER_UNIT_ADJUST_SPY_OPERATION_CHANCE',             0,              NULL),
    ('HD_SPY_COMMERCIAL_SPY_GREATPERSON_POINTS',    'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',           0,              'NOT_IN_OWNER_TERRITORY_REQUIREMENTS'),
    ('SENIOR_CHEATER_ESCAPE_LEVEL',                 'MODIFIER_PLAYER_UNIT_ESCAPE_BOOST',                            0,              NULL),
    ('INSTRUCTOR_SPY_PRODUCTION',                   'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION',                 0,              'HD_UNIT_IN_OWNER_TERRITORY_REQUIREMENTS'),
    ('SPY_INQUISITOR_ENEMY_LEVEL',                  'MODIFIER_PLAYER_UNIT_BOOST_ALL_SPIES',                         0,              'HD_UNIT_IN_OWNER_TERRITORY_REQUIREMENTS'),
    ('SPY_INQUISITOR_COUNTERYSPY_SCIENCE',          'MODIFIER_PLAYER_ADJUST_COUNTER_SPY_AWARD_YIELD_PER_LEVEL',     0,              'HD_UNIT_IN_OWNER_TERRITORY_REQUIREMENTS'),
    ('HD_SPY_OBSERVER_UNOBSTRUCTED',                'MODIFIER_PLAYER_UNIT_GRANT_ABILITY',                           1,              NULL),
    ('HD_SPY_OBSERVER_HD_SEE_HIDDEN',               'MODIFIER_PLAYER_UNIT_GRANT_ABILITY',                           1,              NULL),    
    ('HD_SPY_OBSERVER_SPYGLASS_SIGHT',              'MODIFIER_PLAYER_UNIT_GRANT_ABILITY',                           1,              NULL),
    ('HD_UNOBSTRUCTED_VIEW',                        'MODIFIER_PLAYER_UNIT_ADJUST_SEE_THROUGH_FEATURES',             1,              NULL),    
    ('HD_UNOBSTRUCTED_VIEW_TERRAIN',                'MODIFIER_PLAYER_UNIT_ADJUST_SEE_THROUGH_TERRAIN',              1,              NULL),
    ('HD_UNIT_SEE_HIDDEN',                          'MODIFIER_PLAYER_UNIT_ADJUST_SEE_HIDDEN',                       1,              NULL);
insert or replace into ModifierArguments
    (ModifierId,                                 Name,                      Value)
values
    ('HD_SPY_PATHFINDER',                        'AbilityType',             'ABILITY_SPY_PATHFINDER_MOVEMENT'),
    ('HD_SPY_PIONEER',                           'AbilityType',             'ABILITY_SPY_PIONEER_IGNORE'),    
    ('HD_SPY_OBSERVER_UNOBSTRUCTED',             'AbilityType',             'ABILITY_HD_UNOBSTRUCTED_VIEW'),
    ('HD_SPY_DIPLOMAT_INFLUENCE_POINTS',         'Amount',                  5),
    ('HD_SPY_COMMERCIAL_SPY_SUCCESS_LEVEL',      'OperationType',           'UNITOPERATION_SPY_SIPHON_FUNDS'),
    ('HD_SPY_COMMERCIAL_SPY_SUCCESS_LEVEL',      'Offensive',               1),
    ('HD_SPY_COMMERCIAL_SPY_SUCCESS_LEVEL',      'Amount',                  3),
    ('HD_SPY_COMMERCIAL_SPY_GREATPERSON_POINTS', 'GreatPersonClassType',    'GREAT_PERSON_CLASS_MERCHANT'),
    ('HD_SPY_COMMERCIAL_SPY_GREATPERSON_POINTS', 'Amount',                  10),
    ('SENIOR_CHEATER_ESCAPE_LEVEL',              'Amount',                  7),
    ('INSTRUCTOR_SPY_PRODUCTION',                'UnitType',                'UNIT_SPY'),
    ('INSTRUCTOR_SPY_PRODUCTION',                'Amount',                  100),
    ('SPY_INQUISITOR_ENEMY_LEVEL',               'Defense',                 1),
    ('SPY_INQUISITOR_ENEMY_LEVEL',               'Amount',                  3),
    ('SPY_INQUISITOR_COUNTERYSPY_SCIENCE',       'YieldType',               'YIELD_SCIENCE'),
    ('SPY_INQUISITOR_COUNTERYSPY_SCIENCE',       'Amount',                  100),
    ('SPY_INQUISITOR_COUNTERYSPY_SCIENCE',       'PerXLevels',              1),
    ('HD_SPY_OBSERVER_HD_SEE_HIDDEN',            'AbilityType',             'ABILITY_HD_SEE_HIDDEN'),
    ('HD_UNOBSTRUCTED_VIEW',                     'CanSee',                  1),
    ('HD_UNOBSTRUCTED_VIEW_TERRAIN',             'CanSee',                  1),
    ('HD_UNIT_SEE_HIDDEN',                       'SeeHidden',               1),
    ('HD_SPY_OBSERVER_SPYGLASS_SIGHT',           'AbilityType',             'ABILITY_SPY_OBSERVER_SPYGLASS_SIGHT'),
    ('HD_SPY_PIONEER_IGNORE',                    'Ignore',                  1),
    ('HD_SPY_PIONEER_IGNORE',                    'Type',                    'ALL'),   
    ('HD_SPY_PATHFINDER_MOVEMENT',               'Amount',                  1);

update Modifiers set SubjectRequirementSetId = 'HD_UNIT_IN_OWNER_TERRITORY_REQUIREMENTS' where ModifierId = 'SPY_QUARTERMASTER';
update ModifierArguments set Value = 2 where ModifierId = 'SPY_QUARTERMASTER';
update Modifiers set SubjectRequirementSetId = 'HD_UNIT_IN_OWNER_TERRITORY_REQUIREMENTS' where ModifierId = 'SPY_POLYGRAPH';
update ModifierArguments set Value = 2 where ModifierId = 'SPY_POLYGRAPH' and Name = 'Amount';
update ModifierArguments set Value = 3 where ModifierId = 'SPY_SMEAR_CAMPAIGN' and Name = 'Amount';
update ModifierArguments set Value = 3 where ModifierId = 'SPY_COVERT_ACTION' and Name = 'Amount';
update ModifierArguments set Value = 5 where ModifierId = 'SPY_ROCKET_SCIENTIST' and Name = 'Amount';
update ModifierArguments set Value = 5 where ModifierId = 'SPY_DEMOLITIONS' and Name = 'Amount';
update ModifierArguments set Value = 5 where ModifierId = 'SPY_LICENSE_TO_KILL' and Name = 'Amount';
update ModifierArguments set Value = 5 where ModifierId = 'SPY_SATCHEL_CHARGES' and Name = 'Amount';
update ModifierArguments set Value = 3 where ModifierId = 'SPY_TECHNOLOGIST' and Name = 'Amount';
update ModifierArguments set Value = 3 where ModifierId = 'SPY_CAT_BURGLAR' and Name = 'Amount';

insert or ignore into RequirementSets
    (RequirementSetId,                                  RequirementSetType)
values
    ('NOT_IN_OWNER_TERRITORY_REQUIREMENTS',             'REQUIREMENTSET_TEST_ANY');

insert or ignore into RequirementSetRequirements
    (RequirementSetId,                                  RequirementId)
values
    ('NOT_IN_OWNER_TERRITORY_REQUIREMENTS',             'UNIT_NOT_IN_OWNER_TERRITORY_REQUIREMENT');
insert or ignore into Requirements
    (RequirementId,                                     RequirementType,                           Inverse)
values
    ('UNIT_NOT_IN_OWNER_TERRITORY_REQUIREMENT',         'REQUIREMENT_UNIT_IN_OWNER_TERRITORY',     1);

insert or ignore into UnitAbilityModifiers
    (UnitAbilityType,                                   ModifierId)
values
    ('ABILITY_SPY_PATHFINDER_MOVEMENT',                 'HD_SPY_PATHFINDER_MOVEMENT'),
    ('ABILITY_SPY_PIONEER_IGNORE',                      'HD_SPY_PIONEER_IGNORE'),    
    ('ABILITY_HD_UNOBSTRUCTED_VIEW',                    'HD_UNOBSTRUCTED_VIEW'),
    ('ABILITY_HD_UNOBSTRUCTED_VIEW',                    'HD_UNOBSTRUCTED_VIEW_TERRAIN'),
    ('ABILITY_HD_SEE_HIDDEN',                           'HD_UNIT_SEE_HIDDEN'),
    ('ABILITY_SPY_OBSERVER_SPYGLASS_SIGHT',             'HD_SPY_OBSERVER_ADJUST_SIGHT');



insert or replace into Types
    (Type,                                              Kind)
values
    ('ABILITY_SPY_PATHFINDER_MOVEMENT',                 'KIND_ABILITY'),
    ('ABILITY_SPY_PIONEER_IGNORE',                      'KIND_ABILITY'),    
    ('ABILITY_HD_UNOBSTRUCTED_VIEW',                    'KIND_ABILITY'),
    ('ABILITY_HD_SEE_HIDDEN',                           'KIND_ABILITY'),
    ('ABILITY_SPY_OBSERVER_SPYGLASS_SIGHT',             'KIND_ABILITY');

insert or replace into TypeTags
    (Type,                                              Tag)
values
    ('ABILITY_SPY_PATHFINDER_MOVEMENT',                 'CLASS_ALL_UNITS'),
    ('ABILITY_SPY_PIONEER_IGNORE',                      'CLASS_ALL_UNITS'),
    ('ABILITY_HD_UNOBSTRUCTED_VIEW',                    'CLASS_SPY'),
    ('ABILITY_HD_SEE_HIDDEN',                           'CLASS_SPY'),
    ('ABILITY_SPY_OBSERVER_SPYGLASS_SIGHT',             'CLASS_SPY');    
insert or replace into UnitAbilities
    (UnitAbilityType,                        Name,                                   Description,                                   inactive,   Permanent)
values
    ('ABILITY_SPY_PATHFINDER_MOVEMENT',     'LOC_SPY_PATHFINDER_MOVEMENT_NAME',      'LOC_SPY_PATHFINDER_MOVEMENT_DESCRIPTION',     1,          0),
    ('ABILITY_SPY_PIONEER_IGNORE',          'LOC_SPY_PIONEER_IGNORE_NAME',           'LOC_SPY_PIONEER_IGNORE_DESCRIPTION',          1,          0),    
    ('ABILITY_HD_UNOBSTRUCTED_VIEW',        'LOC_HD_UNOBSTRUCTED_VIEW_NAME',         'LOC_HD_UNOBSTRUCTED_VIEW_DESCRIPTION',        1,          1),
    ('ABILITY_HD_SEE_HIDDEN',               'LOC_HD_SEE_HIDDEN_NAME',                'LOC_HD_SEE_HIDDEN_DESCRIPTION',               1,          1),
    ('ABILITY_SPY_OBSERVER_SPYGLASS_SIGHT', 'LOC_SPY_OBSERVER_SPYGLASS_SIGHT_NAME',  'LOC_SPY_OBSERVER_SPYGLASS_SIGHT_DESCRIPTION', 1,          1);
insert or replace into ModifierStrings
    (ModifierId,                          Context,        Text)
values
    ('HD_SPY_PATHFINDER_MOVEMENT',        'Preview',      '+{1_Amount} {LOC_HD_SPY_PATHFINDER_MOVEMENT_PREVIEW_TEXT}');
--------------------------------------------------------------------------------------------------------------
--SPY-吐丝结网-王牌间谍发展下线
--insert or replace into Modifiers
--    (ModifierId,               ModifierType,                                           RunOnce,    Permanent,  SubjectRequirementSetId)
--values
 --   ('HD_SPY_SPIN_WEB',        'MODIFIER_PLAYER_UNIT_GRANT_UNIT_WITH_EXPERIENCE',      1,          1,          NULL);

--insert or replace into ModifierArguments
--    (ModifierId,                                    Name,               Value)  
--values
--    ('HD_SPY_SPIN_WEB',                             'UnitType',          'UNIT_SPY');
--写其他限制失败，暂且作为2级技能
--------------------------------------------------------------------------------------------------------------
insert or replace into Types
	(Type,											Kind)
values
	('ABILITY_LEVEL4_SPY_ESCAPE_INCREASE',			'KIND_ABILITY');

insert or replace into TypeTags
    (Type,                                          Tag)
values
	('ABILITY_LEVEL4_SPY_ESCAPE_INCREASE',          'CLASS_SPY'); 

insert or replace into UnitAbilities
    (UnitAbilityType,                        		Name,                                   				Description,                                   					inactive,   Permanent)
values
	('ABILITY_LEVEL4_SPY_ESCAPE_INCREASE',     		'LOC_ABILITY_LEVEL4_SPY_ESCAPE_INCREASE_NAME',      	'LOC_ABILITY_LEVEL4_SPY_ESCAPE_INCREASE_DESCRIPTION',     		1,          0);

insert or ignore into UnitAbilityModifiers
    (UnitAbilityType,                                   ModifierId)
values
    ('ABILITY_LEVEL4_SPY_ESCAPE_INCREASE',              'LEVEL4_SPY_ESCAPE_INCREASE');

--给间谍所有晋升普及额外逃跑成功率
insert or replace into UnitPromotionModifiers   (UnitPromotionType, ModifierId)
select UnitPromotionType,    'SPY_ESCAPE_PER_LEVEL_INCREASE'
from UnitPromotions where PromotionClass = 'PROMOTION_CLASS_SPY';
insert or replace into Modifiers
    (ModifierId,                                    ModifierType,                           SubjectStackLimit,  SubjectRequirementSetId)
values
    ('SPY_ESCAPE_PER_LEVEL_INCREASE',               'MODIFIER_PLAYER_UNIT_ESCAPE_BOOST',    1,                  'PLAYER_IS_HUMAN'),
    ('LEVEL4_SPY_ESCAPE_INCREASE',                  'MODIFIER_PLAYER_UNIT_ESCAPE_BOOST',    1,                  'PLAYER_IS_HUMAN');
insert or replace into ModifierArguments
    (ModifierId,                                 Name,                      Value)
values
    ('SPY_ESCAPE_PER_LEVEL_INCREASE',            'Amount',                  4),
    ('LEVEL4_SPY_ESCAPE_INCREASE',               'Amount',                  7);
