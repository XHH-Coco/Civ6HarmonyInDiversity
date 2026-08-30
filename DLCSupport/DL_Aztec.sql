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

insert or replace into HD_Building_Base_On_ResourceClassification (BuildingType, ResourceClassificationType, DetectRange, PropertyKey) values
	('BUILDING_TLACHTLI', 'RESOURCE_CLASSIFICATION_HD_CELEBRATION',	'PLAYER', 'HD_PLOT_BINARY_COMPRESS_TLACHTLI'),
	('BUILDING_TLACHTLI', 'RESOURCE_CLASSIFICATION_HD_HOUSEHOLD',		'PLAYER', 'HD_PLOT_BINARY_COMPRESS_TLACHTLI');

insert or replace into HD_Binary_Compress_AtLeast (Key, AtLeast) values
	('HD_PLOT_BINARY_COMPRESS_TLACHTLI', 3);

insert or replace into BuildingModifiers (BuildingType, ModifierId) values
	('BUILDING_TLACHTLI',	'HD_TLACHTLI_REGIONAL_CULTURE'),
	('BUILDING_TLACHTLI',	'HD_TLACHTLI_REGIONAL_FAITH'),
	('BUILDING_TLACHTLI',	'HD_TLACHTLI_REGIONAL_RANGE');

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) values
	('HD_TLACHTLI_REGIONAL_CULTURE',	'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',	'HD_PLOT_BINARY_COMPRESS_TLACHTLI_AT_LEAST_3_REQUIREMENTS'),
	('HD_TLACHTLI_REGIONAL_FAITH',		'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',	'HD_PLOT_BINARY_COMPRESS_TLACHTLI_AT_LEAST_3_REQUIREMENTS'),
	('HD_TLACHTLI_REGIONAL_RANGE',		'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',	'HD_PLOT_BINARY_COMPRESS_TLACHTLI_AT_LEAST_3_REQUIREMENTS');

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('HD_TLACHTLI_REGIONAL_CULTURE',	'Key',		'HD_SINGLE_BUILDING_PROVIDE_REGIONAL_YIELD_BONUS_BUILDING_TLACHTLI_YIELD_CULTURE'),
	('HD_TLACHTLI_REGIONAL_CULTURE',	'Amount',	1),
	('HD_TLACHTLI_REGIONAL_FAITH',		'Key',		'HD_SINGLE_BUILDING_PROVIDE_REGIONAL_YIELD_BONUS_BUILDING_TLACHTLI_YIELD_FAITH'),
	('HD_TLACHTLI_REGIONAL_FAITH',		'Amount',	1),
	('HD_TLACHTLI_REGIONAL_RANGE',		'Key',		'HD_SINGLE_BUILDING_EXTRA_REGIONAL_RANGE_BUILDING_TLACHTLI'),
	('HD_TLACHTLI_REGIONAL_RANGE',		'Amount',	1);