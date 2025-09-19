-- Master table
create table if not exists HD_ReligiousArmUnits (
	UnitType text not null primary key,
	BaseMoves int not null,
	Combat int not null,
	Cost int not null,
	PrereqTech text,
	PrereqCivic text,
	Maintenance int not null default 0,
	FaithMaintenance int not null default 0,
	StrategicResource text,
	StrategicResourceAmount int not null default 0,
	ResourceMaintenanceType text,
	ResourceMaintenanceAmount int not null default 0,
	Replaces text,
	Upgrades text,
	IsNew boolean not null default false
);
insert or replace into HD_ReligiousArmUnits
	(UnitType,							BaseMoves,	Combat,	Cost,	PrereqTech,			PrereqCivic,				Maintenance,	FaithMaintenance,	StrategicResource,	StrategicResourceAmount,	ResourceMaintenanceType,	ResourceMaintenanceAmount,	Replaces,					Upgrades,							IsNew)
values
	-- New Units
	('UNIT_HD_ARMED_BELIEVER',			2,			35,		60,		null,				'CIVIC_THEOLOGY',			2,				2,					'RESOURCE_IRON',	5,							'RESOURCE_IRON',			1,							null,						'UNIT_HD_EXPEDITIONARY',			1),
	('UNIT_HD_EXPEDITIONARY',			3,			45,		90,		null,				'CIVIC_DIVINE_RIGHT',		3,				3,					'RESOURCE_IRON',	5,							'RESOURCE_IRON',			1,							null,						'UNIT_HD_THEOCRATIC_GUARDIAN',		1),
	('UNIT_HD_THEOCRATIC_GUARDIAN',		3,			55,		140,	null,				'CIVIC_REFORMED_CHURCH',	4,				4,					'RESOURCE_NITER',	5,							'RESOURCE_NITER',			1,							null,						'UNIT_HD_RESISTANCE_ARMY',			1),
	('UNIT_HD_RESISTANCE_ARMY',			3,			65,		210,	null,				'CIVIC_NATIONALISM',		5,				5,					'RESOURCE_NITER',	5,							'RESOURCE_NITER',			1,							null,						'UNIT_HD_REVOLUTIONARY_GUARDIAN',	1),
	('UNIT_HD_REVOLUTIONARY_GUARDIAN',	4,			75,		310,	null,				'CIVIC_IDEOLOGY',			6,				6,					'RESOURCE_NITER',	5,							'RESOURCE_NITER',			2,							null,						'UNIT_HD_DEUX_EX_MACHINA',			1),
	('UNIT_HD_DEUX_EX_MACHINA',			5,			120,	1500,	'TECH_ROBOTICS',	null,						15,				15,					'RESOURCE_URANIUM',	5,							'RESOURCE_URANIUM',			2,							null,						null,								1),
	-- Old Units
	('UNIT_WARRIOR_MONK',				3,			38,		60,		null,				null,						0,				3,					null,				0,							null,						0,							null,						'UNIT_HD_EXPEDITIONARY',			0),
	('UNIT_NORWEGIAN_ULFHEDNAR',		2,			25,		35,		null,				'CIVIC_MYSTICISM',			1,				0,					null,				0,							null,						0,							null,						'UNIT_HD_ARMED_BELIEVER',			0),
	('UNIT_JAPANESE_SOHEI',				3,			48,		90,		null,				'CIVIC_DIVINE_RIGHT',		3,				3,					'RESOURCE_IRON',	5,							'RESOURCE_IRON',			1,							'UNIT_HD_EXPEDITIONARY',	'UNIT_HD_THEOCRATIC_GUARDIAN',		0),
	('UNIT_ELEANOR_TEMPLAR',			3,			50,		100,	'TECH_CASTLES',		null,						3,				3,					null,				0,							'RESOURCE_IRON',			1,							null,						'UNIT_HD_THEOCRATIC_GUARDIAN',		0),
	('UNIT_INDONESIAN_KRIS_SWORDSMAN',	3,			38,		60,		null,				'CIVIC_THEOLOGY',			2,				2,					'RESOURCE_IRON',	5,							'RESOURCE_IRON',			1,							'UNIT_HD_ARMED_BELIEVER',	'UNIT_HD_EXPEDITIONARY',			0),
	('UNIT_LAHORE_NIHANG',				2,			20,		75,		null,				null,						0,				2,					null,				0,							null,						0,							null,						'UNIT_HD_THEOCRATIC_GUARDIAN',		0);
delete from HD_ReligiousArmUnits where (not IsNew) and (UnitType not in (select UnitType from Units));
-- Types
insert or replace into Types
	(Type,			Kind)
select
	UnitType,		'KIND_UNIT'
from HD_ReligiousArmUnits where IsNew;
-- Units
insert or replace into Units
	(UnitType,	Name,							BaseSightRange,	BaseMoves,	Combat,	Domain,			FormationClass,					Cost,	StrategicResource,	Description,							PromotionClass,				PrereqTech,			PrereqCivic,				PurchaseYield,	Maintenance,	ZoneOfControl,	EnabledByReligion,	AdvisorType)
select
	UnitType,	'LOC_' || UnitType || '_NAME',	2,				BaseMoves,	Combat,	'DOMAIN_LAND',	'FORMATION_CLASS_LAND_COMBAT',	Cost,	StrategicResource,	'LOC_' || UnitType || '_DESCRIPTION',	'PROMOTION_CLASS_MONK',		PrereqTech,			PrereqCivic,				'YIELD_FAITH',	Maintenance,	1,				1,					'ADVISOR_CONQUEST'
from HD_ReligiousArmUnits where IsNew;
update Units set
	BaseSightRange		= 2,
	Domain				= 'DOMAIN_LAND',
	FormationClass		= 'FORMATION_CLASS_LAND_COMBAT',
	PromotionClass		= 'PROMOTION_CLASS_MONK',
	PurchaseYield		= 'YIELD_FAITH',
	ZoneOfControl		= 1,
	AdvisorType			= 'ADVISOR_CONQUEST',
	EnabledByReligion	= 1,
	CostProgressionModel = 'NO_COST_PROGRESSION',
	CostProgressionParam1 = 0,
	BaseMoves			= (select BaseMoves			from HD_ReligiousArmUnits r where r.UnitType = Units.UnitType),
	Combat				= (select Combat			from HD_ReligiousArmUnits r where r.UnitType = Units.UnitType),
	Cost				= (select Cost				from HD_ReligiousArmUnits r where r.UnitType = Units.UnitType),
	StrategicResource	= (select StrategicResource	from HD_ReligiousArmUnits r where r.UnitType = Units.UnitType),
	PrereqTech			= (select PrereqTech		from HD_ReligiousArmUnits r where r.UnitType = Units.UnitType),
	PrereqCivic			= (select PrereqCivic		from HD_ReligiousArmUnits r where r.UnitType = Units.UnitType),
	Maintenance			= (select Maintenance		from HD_ReligiousArmUnits r where r.UnitType = Units.UnitType),
	Maintenance			= (select Maintenance		from HD_ReligiousArmUnits r where r.UnitType = Units.UnitType)
where UnitType in (select UnitType from HD_ReligiousArmUnits where not IsNew);
-- Units_XP2
delete from Units_XP2 where UnitType in (select UnitType from HD_ReligiousArmUnits);
insert or replace into Units_XP2
	(UnitType,	ResourceCost,				ResourceMaintenanceType,	ResourceMaintenanceAmount)
select
	UnitType,	StrategicResourceAmount,	ResourceMaintenanceType,	ResourceMaintenanceAmount
from HD_ReligiousArmUnits where ResourceMaintenanceType is not null or StrategicResource is not null;
-- Unit Replaces
delete from UnitReplaces where CivUniqueUnitType in (select UnitType from HD_ReligiousArmUnits) or ReplacesUnitType in (select UnitType from HD_ReligiousArmUnits);
insert or replace into UnitReplaces
	(CivUniqueUnitType,		ReplacesUnitType)
select
	UnitType,				Replaces
from HD_ReligiousArmUnits where Replaces is not null;
-- Unit Upgrades
delete from UnitUpgrades where Unit in (select UnitType from HD_ReligiousArmUnits) or UpgradeUnit in (select UnitType from HD_ReligiousArmUnits);
insert or replace into UnitUpgrades
	(Unit,					UpgradeUnit)
select
	UnitType,				Upgrades
from HD_ReligiousArmUnits where Upgrades is not null;
-- TypeTags
delete from TypeTags where Type in (select UnitType from HD_ReligiousArmUnits) and Type != 'UNIT_WARRIOR_MONK';
insert or replace into TypeTags
	(Type,			Tag)
select
	UnitType,		Tag
from (HD_ReligiousArmUnits cross join (select Tag from TypeTags where Type = 'UNIT_WARRIOR_MONK' and Tag != 'CLASS_ALL_ERAS'));
-- Religion Enable
insert or replace into Modifiers
	(ModifierId,						ModifierType)
select
	'RELIGION_ALLOW_' || UnitType,		'MODIFIER_PLAYER_RELIGION_ADD_RELIGIOUS_UNIT'
from HD_ReligiousArmUnits where UnitType != 'UNIT_WARRIOR_MONK' and UnitType != 'UNIT_NORWEGIAN_ULFHEDNAR';
insert or replace into ModifierArguments
	(ModifierId,						Name,			Value)
select
	'RELIGION_ALLOW_' || UnitType,		'UnitType',		UnitType
from HD_ReligiousArmUnits where UnitType != 'UNIT_WARRIOR_MONK' and UnitType != 'UNIT_NORWEGIAN_ULFHEDNAR';
insert or replace into BeliefModifiers
	(BeliefType,						ModifierId)
select
	BeliefType,							'RELIGION_ALLOW_' || UnitType
from (Beliefs cross join HD_ReligiousArmUnits) where BeliefClassType = 'BELIEF_CLASS_FOLLOWER' and UnitType != 'UNIT_WARRIOR_MONK' and UnitType != 'UNIT_NORWEGIAN_ULFHEDNAR';
-- Common Unit Abilities
insert or replace into Types
	(Type,								Kind)
values
	('ABILITY_RELIGOUS_ARM',			'KIND_ABILITY'),
	('ABILITY_RELIGOUS_ARM_MELEE_ANTC',	'KIND_ABILITY'),
	('ABILITY_RELIGOUS_ARM_FLAT',		'KIND_ABILITY'),
	('ABILITY_RELIGOUS_ARM_DISTRICT',	'KIND_ABILITY');
insert or replace into TypeTags
	(Type,								Tag)
values
	('ABILITY_RELIGOUS_ARM',			'CLASS_WARRIOR_MONK'),
	('ABILITY_RELIGOUS_ARM_MELEE_ANTC',	'CLASS_WARRIOR_MONK'),
	('ABILITY_RELIGOUS_ARM_FLAT',		'CLASS_WARRIOR_MONK'),
	('ABILITY_RELIGOUS_ARM_DISTRICT',	'CLASS_WARRIOR_MONK');
insert or replace into UnitAbilities
	(UnitAbilityType,					Name,										Description,										Inactive)
values
	('ABILITY_RELIGOUS_ARM',			'LOC_ABILITY_RELIGOUS_ARM_NAME',			'LOC_ABILITY_RELIGOUS_ARM_DESCRIPTION',				0),
	('ABILITY_RELIGOUS_ARM_MELEE_ANTC',	'LOC_ABILITY_RELIGOUS_ARM_MELEE_ANTC_NAME',	'LOC_ABILITY_RELIGOUS_ARM_MELEE_ANTC_DESCRIPTION',	1),
	('ABILITY_RELIGOUS_ARM_FLAT',		'LOC_ABILITY_RELIGOUS_ARM_FLAT_NAME',		'LOC_ABILITY_RELIGOUS_ARM_FLAT_DESCRIPTION',		1),
	('ABILITY_RELIGOUS_ARM_DISTRICT',	'LOC_ABILITY_RELIGOUS_ARM_DISTRICT_NAME',	'LOC_ABILITY_RELIGOUS_ARM_DISTRICT_DESCRIPTION',	1);
insert or replace into UnitAbilityModifiers
	(UnitAbilityType,					ModifierId)
values
	('ABILITY_RELIGOUS_ARM',			'RELIGOUS_ARM_FAITH_ON_KILL'),
	('ABILITY_RELIGOUS_ARM_MELEE_ANTC',	'RELIGOUS_ARM_MELEE_ANTC'),
	('ABILITY_RELIGOUS_ARM_FLAT',		'RELIGOUS_ARM_FLAT'),
	('ABILITY_RELIGOUS_ARM_DISTRICT',	'RELIGOUS_ARM_DISTRICT');
insert or replace into TechnologyModifiers
	(TechnologyType,					ModifierId)
values
	('TECH_IRON_WORKING',				'IRON_WORKING_GRANT_ABILITY_RELIGOUS_ARM'),
	('TECH_GUNPOWDER',					'GUNPOWDER_GRANT_ABILITY_RELIGOUS_ARM'),
	('TECH_REPLACEABLE_PARTS',			'REPLACEABLE_PARTS_GRANT_ABILITY_RELIGOUS_ARM');
insert or replace into Modifiers
	(ModifierId,										ModifierType,								OwnerRequirementSetId,				SubjectRequirementSetId)
values
	('RELIGOUS_ARM_FAITH_ON_KILL',						'MODIFIER_UNIT_ADJUST_POST_COMBAT_YIELD',	null,								null),
	('RELIGOUS_ARM_MELEE_ANTC',							'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',		null,								'OPPONENT_IS_MELEE_OR_ANTC_REQUIREMENTS'),
	('RELIGOUS_ARM_FLAT',								'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',		'PLOT_IS_OPEN_AREA_REQUIREMENTS',	null),
	('RELIGOUS_ARM_DISTRICT',							'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',		null,								'URBAN_WARFARE_REQUIREMENTS'),
	('IRON_WORKING_GRANT_ABILITY_RELIGOUS_ARM',			'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',		null,								null),
	('GUNPOWDER_GRANT_ABILITY_RELIGOUS_ARM',			'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',		null,								null),
	('REPLACEABLE_PARTS_GRANT_ABILITY_RELIGOUS_ARM',	'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',		null,								null);
insert or replace into ModifierArguments
	(ModifierId,										Name,						Value)
values
	('RELIGOUS_ARM_FAITH_ON_KILL',						'YieldType',				'YIELD_FAITH'),
	('RELIGOUS_ARM_FAITH_ON_KILL',						'PercentDefeatedStrength',	50),
	('RELIGOUS_ARM_MELEE_ANTC',							'Amount',					5),
	('RELIGOUS_ARM_FLAT',								'Amount',					5),
	('RELIGOUS_ARM_DISTRICT',							'Amount',					5),
	('IRON_WORKING_GRANT_ABILITY_RELIGOUS_ARM',			'AbilityType',				'ABILITY_RELIGOUS_ARM_MELEE_ANTC'),
	('GUNPOWDER_GRANT_ABILITY_RELIGOUS_ARM',			'AbilityType',				'ABILITY_RELIGOUS_ARM_FLAT'),
	('REPLACEABLE_PARTS_GRANT_ABILITY_RELIGOUS_ARM',	'AbilityType',				'ABILITY_RELIGOUS_ARM_DISTRICT');
insert or replace into ModifierStrings
	(ModifierId,					Context,		Text)
values
	('RELIGOUS_ARM_MELEE_ANTC',		'Preview',		'LOC_RELIGOUS_ARM_MELEE_ANTC'),
	('RELIGOUS_ARM_FLAT',			'Preview',		'LOC_RELIGOUS_ARM_FLAT'),
	('RELIGOUS_ARM_DISTRICT',		'Preview',		'LOC_RELIGOUS_ARM_DISTRICT');
-- Faith Maintenance
insert or replace into Types
	(Type,																	Kind)
select distinct
	'ABILITY_RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE',	'KIND_ABILITY'
from HD_ReligiousArmUnits where FaithMaintenance > 0;
insert or replace into UnitAbilities
	(UnitAbilityType,														Name,			Description)
select distinct
	'ABILITY_RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE',	'PlaceHolder',	'LOC_ABILITY_' || FaithMaintenance || '_FAITH_MAINTENANCE_DESCRIPTION'
from HD_ReligiousArmUnits where FaithMaintenance > 0;
insert or replace into Tags
	(Tag,																	Vocabulary)
select distinct
	'CLASS_RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE',		'ABILITY_CLASS'
from HD_ReligiousArmUnits where FaithMaintenance > 0;
insert or replace into TypeTags
	(Type,																	Tag)
select distinct
	'ABILITY_RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE',	'CLASS_RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE'
from HD_ReligiousArmUnits where FaithMaintenance > 0 union all select
	UnitType,																'CLASS_RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE'
from HD_ReligiousArmUnits where FaithMaintenance > 0;
insert or replace into UnitAbilityModifiers
	(UnitAbilityType,														ModifierId)
select distinct
	'ABILITY_RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE',	'RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE'
from HD_ReligiousArmUnits where FaithMaintenance > 0;
insert or replace into Modifiers
	(ModifierId,													ModifierType)
select distinct
	'RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE',	'MODIFIER_PLAYER_ADJUST_YIELD_CHANGE'
from HD_ReligiousArmUnits where FaithMaintenance > 0;
insert or replace into ModifierArguments
	(ModifierId,													Name,			Value)
select distinct
	'RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE',	'YieldType',	'YIELD_FAITH'
from HD_ReligiousArmUnits where FaithMaintenance > 0 union all select distinct
	'RELIGOUS_ARM_' || FaithMaintenance || '_FAITH_MAINTENANCE',	'Amount',		-FaithMaintenance
from HD_ReligiousArmUnits where FaithMaintenance > 0;

-- Unit Promotions
delete from Types where Type in (select UnitPromotionType from UnitPromotions where PromotionClass = 'PROMOTION_CLASS_MONK');
insert or replace into Types
	(Type,									Kind)
values
	('PROMOTION_NRYANA',					'KIND_PROMOTION'), -- L1
	('PROMOTION_DRAGONS_SHAME',				'KIND_PROMOTION'), -- L2
	('PROMOTION_UNIVERSAL_RESTORATION',		'KIND_PROMOTION'), -- L3
	('PROMOTION_LIBERATE_THE_HOLY_LAND',	'KIND_PROMOTION'), -- M1
	('PROMOTION_PUNCITIVE_LAND',			'KIND_PROMOTION'), -- M2
	('PROMOTION_PROMISED_LAND',				'KIND_PROMOTION'), -- M3
	('PROMOTION_NATARAJ',					'KIND_PROMOTION'), -- R1
	('PROMOTION_HD_PILGRIM',				'KIND_PROMOTION'), -- R2
	('PROMOTION_SHARING_GODS_FAVOR',		'KIND_PROMOTION'), -- R3
	('PROMOTION_MIND_OVER_MATTER',			'KIND_PROMOTION'); -- M4
insert or replace into UnitPromotions
	(UnitPromotionType,						Name,											Description,										PromotionClass,				Level,	Column)
values
	('PROMOTION_NRYANA',					'LOC_PROMOTION_NRYANA_NAME',					'LOC_PROMOTION_NRYANA_DESCRIPTION',					'PROMOTION_CLASS_MONK',		1,		1),
	('PROMOTION_DRAGONS_SHAME',				'LOC_PROMOTION_DRAGONS_SHAME_NAME',				'LOC_PROMOTION_DRAGONS_SHAME_DESCRIPTION',			'PROMOTION_CLASS_MONK',		2,		1),
	('PROMOTION_UNIVERSAL_RESTORATION',		'LOC_PROMOTION_UNIVERSAL_RESTORATION_NAME',		'LOC_PROMOTION_UNIVERSAL_RESTORATION_DESCRIPTION',	'PROMOTION_CLASS_MONK',		3,		1),
	('PROMOTION_LIBERATE_THE_HOLY_LAND',	'LOC_PROMOTION_LIBERATE_THE_HOLY_LAND_NAME',	'LOC_PROMOTION_LIBERATE_THE_HOLY_LAND_DESCRIPTION',	'PROMOTION_CLASS_MONK',		1,		2),
	('PROMOTION_PUNCITIVE_LAND',			'LOC_PROMOTION_PUNCITIVE_LAND_NAME',			'LOC_PROMOTION_PUNCITIVE_LAND_DESCRIPTION',			'PROMOTION_CLASS_MONK',		2,		2),
	('PROMOTION_PROMISED_LAND',				'LOC_PROMOTION_PROMISED_LAND_NAME',				'LOC_PROMOTION_PROMISED_LAND_DESCRIPTION',			'PROMOTION_CLASS_MONK',		3,		2),
	('PROMOTION_NATARAJ',					'LOC_PROMOTION_NATARAJ_NAME',					'LOC_PROMOTION_NATARAJ_DESCRIPTION',				'PROMOTION_CLASS_MONK',		1,		3),
	('PROMOTION_HD_PILGRIM',				'LOC_PROMOTION_HD_PILGRIM_NAME',				'LOC_PROMOTION_HD_PILGRIM_DESCRIPTION',				'PROMOTION_CLASS_MONK',		2,		3),
	('PROMOTION_SHARING_GODS_FAVOR',		'LOC_PROMOTION_SHARING_GODS_FAVOR_NAME',		'LOC_PROMOTION_SHARING_GODS_FAVOR_DESCRIPTION',		'PROMOTION_CLASS_MONK',		3,		3),
	('PROMOTION_MIND_OVER_MATTER',			'LOC_PROMOTION_MIND_OVER_MATTER_NAME',			'LOC_PROMOTION_MIND_OVER_MATTER_DESCRIPTION',		'PROMOTION_CLASS_MONK',		4,		2);
insert or replace into UnitPromotionPrereqs
	(UnitPromotion,							PrereqUnitPromotion)
values
	('PROMOTION_DRAGONS_SHAME',				'PROMOTION_NRYANA'),
	('PROMOTION_UNIVERSAL_RESTORATION',		'PROMOTION_DRAGONS_SHAME'),
	('PROMOTION_MIND_OVER_MATTER',			'PROMOTION_UNIVERSAL_RESTORATION'),
	('PROMOTION_PUNCITIVE_LAND',			'PROMOTION_LIBERATE_THE_HOLY_LAND'),
	('PROMOTION_PROMISED_LAND',				'PROMOTION_PUNCITIVE_LAND'),
	('PROMOTION_MIND_OVER_MATTER',			'PROMOTION_PROMISED_LAND'),
	('PROMOTION_HD_PILGRIM',				'PROMOTION_NATARAJ'),
	('PROMOTION_SHARING_GODS_FAVOR',		'PROMOTION_HD_PILGRIM'),
	('PROMOTION_MIND_OVER_MATTER',			'PROMOTION_SHARING_GODS_FAVOR');
insert or replace into UnitPromotionModifiers
	(UnitPromotionType,						ModifierId)
values
	('PROMOTION_NRYANA',					'NRYANA_ATTACK'),
	('PROMOTION_DRAGONS_SHAME',				'DRAGONS_SHAME_DEFEND'),
	('PROMOTION_DRAGONS_SHAME',				'DRAGONS_SHAME_HEAL'),
	('PROMOTION_UNIVERSAL_RESTORATION',		'UNIVERSAL_RESTORATION_FLANK'),
	('PROMOTION_LIBERATE_THE_HOLY_LAND',	'LIBERATE_THE_HOLY_LAND_MOVEMENT'),
	('PROMOTION_PUNCITIVE_LAND',			'PUNCITIVE_LAND_DISTRICT'),
	('PROMOTION_PROMISED_LAND',				'PROMISED_LAND_ATTACK_DAMAGED'),
	('PROMOTION_NATARAJ',					'NATARAJ_DEFEND_RANGE'),
	('PROMOTION_NATARAJ',					'NATARAJ_ATTACK_DISTRICT'),
	('PROMOTION_HD_PILGRIM',				'HD_PILGRIM_DAMAGED'),
	('PROMOTION_SHARING_GODS_FAVOR',		'SHARING_GODS_FAVOR_ADJACENT_ATTACH'),
	('PROMOTION_MIND_OVER_MATTER',			'MIND_OVER_MATTER_MOVE_AFTER_ATTACK');
insert or replace into Modifiers
	(ModifierId,							ModifierType,															OwnerRequirementSetId,			SubjectRequirementSetId)
values
	('NRYANA_ATTACK',						'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',									null,							'HD_UNIT_ATTACKING_REQUIREMENTS'),
	('DRAGONS_SHAME_DEFEND',				'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',									'PLOT_HAS_ANY_FEATURE',			'HD_UNIT_DEFENDING_REQUIREMENTS'),
	('DRAGONS_SHAME_HEAL',					'MODIFIER_PLAYER_UNIT_ADJUST_HEAL_PER_TURN',							'PLOT_HAS_ANY_FEATURE',			null),
	('UNIVERSAL_RESTORATION_FLANK',			'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',									null,							'UNIT_IS_FLANKED_REQUIREMENTS'),
	('LIBERATE_THE_HOLY_LAND_MOVEMENT',		'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',									null,							null),
	('PUNCITIVE_LAND_DISTRICT',				'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',									null,							'URBAN_WARFARE_REQUIREMENTS'),
	('PROMISED_LAND_ATTACK_DAMAGED',		'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',									null,							'VULTURE_REQUIREMENTS'),
	('NATARAJ_DEFEND_RANGE',				'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',									null,							'TORTOISE_REQUIREMENTS'),
	('NATARAJ_ATTACK_DISTRICT',				'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',									null,							'ATTACKING_DISTRICTS_REQUIREMENTS'),
	('HD_PILGRIM_DAMAGED',					'MODIFIER_PLAYER_UNIT_ADJUST_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER',	null,							'ATTACKING_DISTRICTS_REQUIREMENTS'),
	('SHARING_GODS_FAVOR_ADJACENT_ATTACH',	'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',								null,							'UNIT_IS_RELIGIOUS_ARM_ADJACENT_TO_OWNER'),
	('SHARING_GODS_FAVOR_ADJACENT',			'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',									null,							null),
	('MIND_OVER_MATTER_MOVE_AFTER_ATTACK',	'MODIFIER_PLAYER_UNIT_ADJUST_ATTACK_AND_MOVE',							null,							null);
insert or replace into ModifierArguments
	(ModifierId,							Name,				Value)
values
	('NRYANA_ATTACK',						'Amount',			5),
	('DRAGONS_SHAME_DEFEND',				'Amount',			5),
	('DRAGONS_SHAME_HEAL',					'Type',				'ALL'),
	('DRAGONS_SHAME_HEAL',					'Amount',			15),
	('UNIVERSAL_RESTORATION_FLANK',			'Amount',			7),
	('LIBERATE_THE_HOLY_LAND_MOVEMENT',		'Amount',			1),
	('PUNCITIVE_LAND_DISTRICT',				'Amount',			10),
	('PROMISED_LAND_ATTACK_DAMAGED',		'Amount',			7),
	('NATARAJ_DEFEND_RANGE',				'Amount',			7),
	('NATARAJ_ATTACK_DISTRICT',				'Amount',			7),
	('HD_PILGRIM_DAMAGED',					'Amount',			100),
	('SHARING_GODS_FAVOR_ADJACENT_ATTACH',	'ModifierId',		'SHARING_GODS_FAVOR_ADJACENT'),
	('SHARING_GODS_FAVOR_ADJACENT',			'Amount',			2),
	('MIND_OVER_MATTER_MOVE_AFTER_ATTACK',	'CanMove',			1);
insert or replace into ModifierStrings
	(ModifierId,							Context,			Text)
values
	('NRYANA_ATTACK',						'Preview',			'LOC_NRYANA_ATTACK'),
	('DRAGONS_SHAME_DEFEND',				'Preview',			'LOC_DRAGONS_SHAME_DEFEND'),
	('UNIVERSAL_RESTORATION_FLANK',			'Preview',			'LOC_UNIVERSAL_RESTORATION_FLANK'),
	('PUNCITIVE_LAND_DISTRICT',				'Preview',			'LOC_PUNCITIVE_LAND_DISTRICT'),
	('PROMISED_LAND_ATTACK_DAMAGED',		'Preview',			'LOC_PROMISED_LAND_ATTACK_DAMAGED'),
	('NATARAJ_DEFEND_RANGE',				'Preview',			'LOC_NATARAJ_DEFEND_RANGE'),
	('NATARAJ_ATTACK_DISTRICT',				'Preview',			'LOC_NATARAJ_ATTACK_DISTRICT'),
	('SHARING_GODS_FAVOR_ADJACENT',			'Preview',			'LOC_SHARING_GODS_FAVOR_ADJACENT');
-- Promotion Action Cost
insert or replace into GlobalParameters
	(Name,											Value)
values
	('RELIGIOUS_ARM_UNIVERSAL_RESTORATION_COST',	2.0),
	('RELIGIOUS_ARM_PUNCITIVE_LAND_COST',			0.5),
	('RELIGIOUS_ARM_PROMISED_LAND_COST',			0.5),
	('RELIGIOUS_ARM_MIND_OVER_MATTER_COST',			2.0),
	('RELIGIOUS_ARM_HD_PILGRIM_COST',				10);

-- Beliefs
insert or replace into Types 
	(Type,									Kind) 
values
	('ABILITY_RELIGIION_START_MOVE',		'KIND_ABILITY'),
	('BELIEF_FRATERNITY',					'KIND_BELIEF'),
	('BELIEF_SILKH_SWORD_BAPTISM',			'KIND_BELIEF'),
	('BELIEF_SHAOLIN_TEMPLE',				'KIND_BELIEF'),
	('ABILITY_RELIGIION_START_MOVE',		'KIND_ABILITY');
insert or ignore into BeliefsSortIndex
	(BeliefType,						SortIndex)
values
	('BELIEF_FRATERNITY',				134),
	('BELIEF_SILKH_SWORD_BAPTISM',		135),
	('BELIEF_SHAOLIN_TEMPLE',			219);
insert or replace into Beliefs
	(BeliefType,						Name,									Description,									BeliefClassType)
values
	('BELIEF_FRATERNITY',				'LOC_BELIEF_FRATERNITY_NAME',			'LOC_BELIEF_FRATERNITY_DESCRIPTION',			'BELIEF_CLASS_FOUNDER'),
	('BELIEF_SILKH_SWORD_BAPTISM',		'LOC_BELIEF_SILKH_SWORD_BAPTISM_NAME',	'LOC_BELIEF_SILKH_SWORD_BAPTISM_DESCRIPTION',	'BELIEF_CLASS_FOUNDER'),
	('BELIEF_SHAOLIN_TEMPLE',			'LOC_BELIEF_SHAOLIN_TEMPLE_NAME',		'LOC_BELIEF_SHAOLIN_TEMPLE_DESCRIPTION',		'BELIEF_CLASS_WORSHIP');
-- Warrior Monks
insert or replace into District_BuildChargeProductions
	(DistrictType,				UnitType,				PercentProductionPerCharge)
values
	('DISTRICT_HOLY_SITE',		'UNIT_WARRIOR_MONK',	'100');
update Units set BuildCharges = 1 where UnitType = 'UNIT_WARRIOR_MONK';
-- Crusade (BELIEF_JUST_WAR)
delete from BeliefModifiers where BeliefType = 'BELIEF_JUST_WAR' and ModifierID = 'JUST_WAR_COMBAT_BONUS';
update ModifierArguments set Value = 50 where ModifierId = 'JUST_WAR_FAITH_PILLAGE_IMPROVEMENT_FAITH_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 50 where ModifierId = 'JUST_WAR_FAITH_PILLAGE_DISTRICT_FAITH_MODIFIER' and Name = 'Amount';
insert or replace into BeliefModifiers
	(BeliefType,			ModifierId)
values 
	('BELIEF_JUST_WAR',		'MODIFIER_RELIGIOUS_START_MOVE_ATTACH');
insert or replace into Modifiers
	(ModifierId,								ModifierType,									SubjectRequirementSetId)
values 
	('MODIFIER_RELIGIOUS_START_MOVE_ATTACH',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',			'PLAYER_FOUNDED_RELIGION_REQUIREMENTS'),
	('MODIFIER_RELIGIOUS_START_MOVE',			'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',			null),
	('MODIFIER_RELIGIION_START_MOVE',			'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',			'PLOT_IS_FLAT_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,								Name,				Value)
values
	('MODIFIER_RELIGIOUS_START_MOVE_ATTACH',	'ModifierId',		'MODIFIER_RELIGIOUS_START_MOVE'),
	('MODIFIER_RELIGIOUS_START_MOVE',			'AbilityType',		'ABILITY_RELIGIION_START_MOVE');
insert or replace into TypeTags
	(Type,								Tag)
values
	('ABILITY_RELIGIION_START_MOVE',	'CLASS_WARRIOR_MONK'),
	('ABILITY_RELIGIION_START_MOVE',	'CLASS_RELIGIOUS_ALL');
insert or replace into UnitAbilities
	(UnitAbilityType,					Name,											Description,									Inactive)											
values  
	('ABILITY_RELIGIION_START_MOVE',	'LOC_ABILITY_RELIGIION_START_MOVE_NAME',		'LOC_ABILITY_RELIGIION_START_MOVE_DESCRIPTION',  1);
insert or replace into UnitAbilityModifiers
	(UnitAbilityType,					ModifierId)
values  
	('ABILITY_RELIGIION_START_MOVE',	'MODIFIER_RELIGIION_START_MOVE');
insert or replace into Modifiers 
	(ModifierId,						ModifierType,								SubjectRequirementSetId) 
values 
	('MODIFIER_RELIGIION_START_MOVE',	'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',		'PLOT_IS_OPEN_AREA_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,						Name,			Value)
values
	('MODIFIER_RELIGIION_START_MOVE',	'Amount',		1);
-- Fraterity
insert or replace into TypeTags
	(Type,								Tag)
values
	('ABILITY_JUST_WAR_STRENGTH',		'CLASS_WARRIOR_MONK');
insert or replace into BeliefModifiers 
	(BeliefType,						ModifierId)
values
	('BELIEF_FRATERNITY',				'2X_SUPPORT_STRENGTH_ATTACH_1'),
	('BELIEF_FRATERNITY',				'2X_FLANKING_STRENGTH_ATTACH_1'),
	('BELIEF_FRATERNITY',				'JUST_WAR_FAITH_PILLAGE_IMPROVEMENT_FAITH'),
	('BELIEF_FRATERNITY',				'JUST_WAR_FAITH_PILLAGE_DISTRICT_FAITH');
insert or replace into Modifiers
	(ModifierId,								ModifierType,											SubjectRequirementSetId)
values
	('2X_SUPPORT_STRENGTH_ATTACH_1',			'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_FOUNDED_RELIGION_REQUIREMENTS'),
	('2X_FLANKING_STRENGTH_ATTACH_1',			'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_FOUNDED_RELIGION_REQUIREMENTS'),
	('2X_SUPPORT_STRENGTH_ATTACH',				'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',				'UNIT_IS_RELIGION_OR_RELIGIOUS_ARM'),
	('2X_FLANKING_STRENGTH_ATTACH',				'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',				'UNIT_IS_RELIGION_OR_RELIGIOUS_ARM'),
	('2X_SUPPORT_STRENGTH',						'MODIFIER_PLAYER_UNIT_ADJUST_SUPPORT_BONUS_MODIFIER',	null),
	('2X_FLANKING_STRENGTH',					'MODIFIER_PLAYER_UNIT_ADJUST_FLANKING_BONUS_MODIFIER',	null);
insert or replace into ModifierArguments
	(ModifierId,								Name,				Value)
values
	('2X_SUPPORT_STRENGTH_ATTACH',				'ModifierId',		'2X_SUPPORT_STRENGTH'),
	('2X_FLANKING_STRENGTH_ATTACH',				'ModifierId',		'2X_FLANKING_STRENGTH'),
	('2X_SUPPORT_STRENGTH',						'Percent',			'100'),
	('2X_FLANKING_STRENGTH',					'Percent',			'100'),
	('2X_SUPPORT_STRENGTH_ATTACH_1',			'ModifierId',		'2X_SUPPORT_STRENGTH_ATTACH'),
	('2X_FLANKING_STRENGTH_ATTACH_1',			'ModifierId',		'2X_FLANKING_STRENGTH_ATTACH');
-- Silkh Sword Baptism
insert or replace into BeliefModifiers 
	(BeliefType,						ModifierId)
values
	('BELIEF_SILKH_SWORD_BAPTISM',		'JUST_WAR_RELIGIOUS_ALL_COMBAT_BUFF'),
	('BELIEF_SILKH_SWORD_BAPTISM',		'CONQUER_CITY_UNITS_HEAL_ATTACH');
insert or replace into Modifiers
	(ModifierId,								ModifierType,											SubjectRequirementSetId)
values
	('CONQUER_CITY_UNITS_HEAL_ATTACH_1',		'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_FOUNDED_RELIGION_REQUIREMENTS'),
	('CONQUER_CITY_UNITS_HEAL_ATTACH',			'MODIFIER_PLAYER_CAPTURED_CITY_ATTACH_MODIFIER',		null),
	('CONQUER_CITY_UNITS_HEAL',					'MODIFIER_PLAYER_UNITS_ADJUST_DAMAGE',					'JUST_WAR_PLOT_UNIT_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,							Name,					Value)
values 
	('CONQUER_CITY_UNITS_HEAL_ATTACH_1',	'ModifierId',			'CONQUER_CITY_UNITS_HEAL_ATTACH'),
	('CONQUER_CITY_UNITS_HEAL_ATTACH',		'ModifierId',			'CONQUER_CITY_UNITS_HEAL'),
	('CONQUER_CITY_UNITS_HEAL',				'Amount',				-15);
insert or replace into GlobalParameters
	(Name,									Value)
values
	('SILKH_SWORD_BAPTISM_HEAL_AMOUNT',		15);
-- Shaolin Temple
insert or replace into BeliefModifiers 
	(BeliefType,						ModifierId)
values
	('BELIEF_SHAOLIN_TEMPLE',			'SHAOLIN_TEMPLE_ALLOW');
insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
values
	('BUILDING_SHAOLIN_TEMPLE',			'SHAOLIN_TEMPLE_GRANTS_1_EXPMONKS'),
	('BUILDING_SHAOLIN_TEMPLE',			'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST');
insert or replace into Modifiers
	(ModifierId,								ModifierType)
values
	('SHAOLIN_TEMPLE_ALLOW',					'MODIFIER_PLAYER_RELIGION_ADD_RELIGIOUS_BUILDING'),
	('SHAOLIN_TEMPLE_GRANTS_1_EXPMONKS',		'MODIFIER_PLAYER_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER'),
	('SHAOLIN_TEMPLE_FREE_PROMOTION',			'MODIFIER_PLAYER_UNIT_ADJUST_GRANT_EXPERIENCE');
insert or replace into ModifierArguments
	(ModifierId,								Name,							Value)
values
	('SHAOLIN_TEMPLE_ALLOW',					'BuildingType',					'BUILDING_SHAOLIN_TEMPLE'),
	('SHAOLIN_TEMPLE_GRANTS_1_EXPMONKS',		'UnitPromotionClassType',		'PROMOTION_CLASS_MONK'),
	('SHAOLIN_TEMPLE_GRANTS_1_EXPMONKS',		'ModifierId',					'SHAOLIN_TEMPLE_FREE_PROMOTION'),
	('SHAOLIN_TEMPLE_FREE_PROMOTION',			'Amount',						-1);
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'BUILDING_SHAOLIN_TEMPLE',		'SHAOLIN_TEMPLE_' || UnitType || '_PRODUCTION'
from HD_ReligiousArmUnits;
insert or replace into Modifiers
	(ModifierId,										ModifierType)
select
	'SHAOLIN_TEMPLE_' || UnitType || '_PRODUCTION',		'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION'
from HD_ReligiousArmUnits;
insert or replace into ModifierArguments 
	(ModifierId,										Name,			Value)
select
	'SHAOLIN_TEMPLE_' || UnitType || '_PRODUCTION',		'Amount',		'50'
from HD_ReligiousArmUnits union all select
	'SHAOLIN_TEMPLE_' || UnitType || '_PRODUCTION',		'UnitType',		UnitType
from HD_ReligiousArmUnits;
-- Mosque
delete from BuildingModifiers where BuildingType = 'BUILDING_MOSQUE' and ModifierId = 'MOSQUE_TRAINED_STRENGTH_MODIFIER';
insert or replace into BuildingModifiers
	(BuildingType,						ModifierId)
values
	('BUILDING_MOSQUE',					'MOSQUE_RELIGIOUS_ARM_STRENGTH_ATTACH');
insert or replace into Modifiers
	(ModifierId,								ModifierType,										SubjectRequirementSetId)
values
	('MOSQUE_RELIGIOUS_ARM_STRENGTH_ATTACH',	'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',			'UNIT_IS_RELIGIOUS_ARM'),
	('MOSQUE_RELIGIOUS_ARM_STRENGTH',			'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',				null);
insert or replace into ModifierArguments
	(ModifierId,								Name,				Value)
values
	('MOSQUE_RELIGIOUS_ARM_STRENGTH_ATTACH',	'ModifierId',		'MOSQUE_RELIGIOUS_ARM_STRENGTH'),
	('MOSQUE_RELIGIOUS_ARM_STRENGTH',			'Amount',			1);
insert or replace into ModifierStrings
	(ModifierId,								Context,			Text)
values
	('MOSQUE_RELIGIOUS_ARM_STRENGTH',			'Preview',			'LOC_MOSQUE_RELIGIOUS_ARM_STRENGTH');
-- Defender of Faith
delete from RequirementSetRequirements where RequirementSetId = 'DEFENDER_OF_FAITH_REQUIREMENTS' and RequirementId = 'REQUIRES_NON_RELIGIOUS_UNIT';
update Modifiers set SubjectRequirementSetId = 'DEFENDER_OF_FAITH_FOREIGN_REQUIREMENTS' where ModifierId = 'DEFENDER_OF_FAITH_COMBAT_BONUS';
insert or replace into BeliefModifiers
	(BeliefType,					ModifierId)
values
	('BELIEF_DEFENDER_OF_FAITH',	'DEFENDER_OF_FAITH_MOVEMENT_BONUS');
insert or replace into Modifiers
	(ModifierId,									ModifierType,									SubjectRequirementSetId)
values
	('DEFENDER_OF_FAITH_MOVEMENT_BONUS',			'MODIFIER_ALL_UNITS_ATTACH_MODIFIER',			'DEFENDER_OF_FAITH_REQUIREMENTS'),
	('DEFENDER_OF_FAITH_MOVEMENT_BONUS_MODIFIER',	'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',			null);
insert or replace into ModifierArguments
	(ModifierId,									Name,				Value)
values
	('DEFENDER_OF_FAITH_MOVEMENT_BONUS',			'ModifierId',		'DEFENDER_OF_FAITH_MOVEMENT_BONUS_MODIFIER'),
	('DEFENDER_OF_FAITH_MOVEMENT_BONUS_MODIFIER',	'Amount',			1);
-- Capellani
delete from BeliefModifiers where BeliefType = 'BELIEF_CAPELLANI' and ModifierId = 'JUST_WAR_RELIGIOUS_ALL_COMBAT_BUFF';
insert or replace into GlobalParameters
	(Name,									Value)
values
	('CAPELLANI_PRESSURE',					150),
	('CAPELLANI_FAITH_PER_POPULATION',		30);

-- Unique Units
-- Ulfhedinn
update Units set EnabledByReligion = 0 where UnitType = 'UNIT_NORWEGIAN_ULFHEDNAR';
delete from UnitAbilityModifiers where UnitAbilityType = 'ABILITY_RECEIVE_NORWEGIAN_ULFHEDNAR_BONUS' and ModifierId = 'RECEIVE_NORWEGIAN_ULFHEDNAR_MOVEMENT_BONUS_ATTACH';
delete from TypeTags where Type = 'ABILITY_RECEIVE_NORWEGIAN_ULFHEDNAR_BONUS';
insert or replace into TypeTags
	(Type,												Tag)
values
	('ABILITY_RECEIVE_NORWEGIAN_ULFHEDNAR_BONUS',		'CLASS_ALL_UNITS');
-- Sohei
update Units set PurchaseYield = 'YIELD_GOLD' where UnitType = 'UNIT_JAPANESE_SOHEI';
insert or replace into TraitModifiers
	(TraitType,											ModifierId)
values
	('TRAIT_CIVILIZATION_UNIT_JAPANESE_SOHEI',			'SOHEI_FAITH_PURCHASE');
insert or replace into Modifiers
	(ModifierId,									ModifierType)
values
	('SOHEI_FAITH_PURCHASE',						'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
insert or replace into ModifierArguments
	(ModifierId,									Name,				Value)
values
	('SOHEI_FAITH_PURCHASE',						'Tag',				'CLASS_JAPANESE_SOHEI');
insert or replace into Tags
	(Tag,							Vocabulary)
values
	('CLASS_JAPANESE_SOHEI',		'ABILITY_CLASS');
insert or replace into TypeTags
	(Type,							Tag)
values
	('UNIT_JAPANESE_SOHEI',			'CLASS_JAPANESE_SOHEI');
-- Templar
insert or replace into TypeTags
	(Type,							Tag)
values
	('UNIT_ELEANOR_TEMPLAR',		'CLASS_ELEANOR_TEMPLAR');
-- Kris Warrior
update Units set PurchaseYield = 'YIELD_GOLD' where UnitType = 'UNIT_INDONESIAN_KRIS_SWORDSMAN';
insert or replace into TraitModifiers
	(TraitType,												ModifierId)
values
	('TRAIT_CIVILIZATION_UNIT_INDONESIAN_KRIS_SWORDSMAN',	'KRIS_SWORDSMAN_FAITH_PURCHASE');
insert or replace into Modifiers
	(ModifierId,									ModifierType)
values
	('KRIS_SWORDSMAN_FAITH_PURCHASE',				'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE');
insert or replace into ModifierArguments
	(ModifierId,									Name,				Value)
values
	('KRIS_SWORDSMAN_FAITH_PURCHASE',				'Tag',				'CLASS_INDONESIAN_KRIS_SWORDSMAN');
insert or replace into Tags
	(Tag,									Vocabulary)
values
	('CLASS_INDONESIAN_KRIS_SWORDSMAN',		'ABILITY_CLASS');
insert or replace into TypeTags
	(Type,									Tag)
values
	('UNIT_INDONESIAN_KRIS_SWORDSMAN',		'CLASS_INDONESIAN_KRIS_SWORDSMAN');

-- City States
-- Modifiers in this table are attached to suzerain
create temporary table if not exists TraitAttachedModifiers (
	TraitType text not null,
	ModifierId text not null,
	primary key (TraitType, ModifierId)
);
-- Lahore
update Units set MustPurchase = 0 where UnitType = 'UNIT_LAHORE_NIHANG';
delete from Types where Type in (select UnitPromotionType from UnitPromotions where PromotionClass = 'PROMOTION_CLASS_NIHANG');
delete from Types where Type = 'PROMOTION_CLASS_NIHANG';
delete from BuildingModifiers where ModifierId like 'LAHORE_NIHANG_%_ADD_PURCHASE_COST';
update ModifierArguments set Value = 2 where Name = 'Amount' and ModifierId in ('NIHANG_ARMORY_STRENGTH', 'NIHANG_BARRACKS_STRENGTH', 'NIHANG_ACADEMY_STRENGTH');
update UnitAbilities set Description = null where UnitAbilityType in ('ABILITY_NIHANG_ARMORY_STRENGTH', 'ABILITY_NIHANG_ARMORY_STRENGTH', 'ABILITY_NIHANG_ACADEMY_STRENGTH');
insert or replace into TraitAttachedModifiers
	(TraitType,								ModifierId)
values
	('MINOR_CIV_LAHORE_NIHANG_TRAIT',		'MINOR_CIV_LAHORE_NIHANG_STRENGTH');
insert or replace into Modifiers
	(ModifierId,									ModifierType,										SubjectRequirementSetId)
values
	('MINOR_CIV_LAHORE_NIHANG_STRENGTH',			'MODIFIER_PLAYER_UNITS_ADJUST_COMBAT_STRENGTH',		'UNIT_IS_UNIT_LAHORE_NIHANG_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,									Name,				Value)
values
	('MINOR_CIV_LAHORE_NIHANG_STRENGTH',			'Amount',			15);
insert or replace into ModifierStrings
	(ModifierId,								Context,			Text)
values
	('MINOR_CIV_LAHORE_NIHANG_STRENGTH',		'Preview',			'LOC_MINOR_CIV_LAHORE_NIHANG_STRENGTH');
insert or replace into TypeTags
	(Type,									Tag)
values
	('UNIT_LAHORE_NIHANG',					'CLASS_LAHORE_NIHANG');
-- Jerusalem
delete from TraitModifiers where TraitType = 'MINOR_CIV_JERUSALEM_TRAIT';
-- Monastery (Armagh)
update Improvements set OnePerCity = 0, SameAdjacentValid = 1, PlunderType = 'PLUNDER_FAITH', PlunderAmount = 50 where ImprovementType = 'IMPROVEMENT_MONASTERY';
update Adjacency_YieldChanges set YieldType = 'YIELD_FAITH', ObsoleteCivic = null where ID = 'Monastery_DistrictAdjacency';
delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_MONASTERY' and YieldChangeId = 'Monastery_DistrictAdjacency_Divine_Right_Late';
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_MONASTERY';
insert or replace into ImprovementModifiers
	(ImprovementType,				ModifierId)
values
	('IMPROVEMENT_MONASTERY',		'MONASTERY_RELIGIOUS_ARM_EXPERIENCE_ATTACH');
insert or replace into Modifiers
	(ModifierId,									ModifierType,												SubjectRequirementSetId,	SubjectStackLimit)
values
	('MONASTERY_RELIGIOUS_ARM_EXPERIENCE_ATTACH',	'MODIFIER_CITY_TRAINED_UNITS_ATTACH_MODIFIER',				'UNIT_IS_RELIGIOUS_ARM',	1),
	('MONASTERY_RELIGIOUS_ARM_EXPERIENCE',			'MODIFIER_PLAYER_UNIT_ADJUST_UNIT_EXPERIENCE_MODIFIER',		null,						null);
insert or replace into ModifierArguments
	(ModifierId,									Name,				Value)
values
	('MONASTERY_RELIGIOUS_ARM_EXPERIENCE_ATTACH',	'ModifierId',		'MONASTERY_RELIGIOUS_ARM_EXPERIENCE'),
	('MONASTERY_RELIGIOUS_ARM_EXPERIENCE_ATTACH',	'Amount',			50);

-- Attach modifiers in TraitAttachedModifiers to suzerain
insert or ignore into TraitModifiers
	(TraitType, ModifierId)
select
	TraitType,  ModifierId || '_ATTACH'
from TraitAttachedModifiers;
insert or ignore into Modifiers
	(ModifierId,				ModifierType,							SubjectRequirementSetId)
select
	ModifierId || '_ATTACH',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',	'PLAYER_IS_SUZERAIN'
from TraitAttachedModifiers;
insert or ignore into ModifierArguments
	(ModifierId,				Name,			Value)
select
	ModifierId || '_ATTACH',	'ModifierId',	ModifierId
from TraitAttachedModifiers;
drop table TraitAttachedModifiers;

-- Requirements
insert or ignore into RequirementSets
	(RequirementSetId,								RequirementSetType)
values
	('OPPONENT_IS_MELEE_OR_ANTC_REQUIREMENTS',		'REQUIREMENTSET_TEST_ANY'),
	('UNIT_IS_RELIGIOUS_ARM_ADJACENT_TO_OWNER',		'REQUIREMENTSET_TEST_ANY'),
	('PLOT_IS_FLAT_REQUIREMENTS',					'REQUIREMENTSET_TEST_ANY'),
	('UNIT_IS_RELIGION_OR_RELIGIOUS_ARM',			'REQUIREMENTSET_TEST_ANY'),
	('UNIT_IS_RELIGIOUS_ARM',						'REQUIREMENTSET_TEST_ALL'),
	('DEFENDER_OF_FAITH_FOREIGN_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,								RequirementId)
values
	('OPPONENT_IS_MELEE_OR_ANTC_REQUIREMENTS',		'REQUIRES_OPPONENT_IS_MELEE'),
	('OPPONENT_IS_MELEE_OR_ANTC_REQUIREMENTS',		'REQUIRES_OPPONENT_IS_ANTC'),
	('UNIT_IS_RELIGIOUS_ARM_ADJACENT_TO_OWNER',		'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_MONK'),
	('UNIT_IS_RELIGIOUS_ARM_ADJACENT_TO_OWNER',		'ADJACENT_TO_OWNER'),
	('PLOT_IS_FLAT_REQUIREMENTS',					'REQUIRES_PLOT_IS_FLAT'),
	('UNIT_IS_RELIGION_OR_RELIGIOUS_ARM',			'REQUIRES_UNIT_IS_RELIGIOUS_ALL'),
	('UNIT_IS_RELIGION_OR_RELIGIOUS_ARM',			'REQUIRES_UNIT_IS_RELIGIOUS_ARM'),
	('UNIT_IS_RELIGIOUS_ARM',						'REQUIRES_UNIT_IS_RELIGIOUS_ARM'),
	('DEFENDER_OF_FAITH_FOREIGN_REQUIREMENTS',		'REQUIRES_NON_SUPPORT_UNIT'),
	('DEFENDER_OF_FAITH_FOREIGN_REQUIREMENTS',		'REQUIRES_PLAYER_FOUNDED_RELIGION'),
	('DEFENDER_OF_FAITH_FOREIGN_REQUIREMENTS',		'REQUIRES_UNIT_NEAR_FOREIGN_RELIGIOUS_CITY');
insert or ignore into Requirements
	(RequirementId,									RequirementType)
values
	('REQUIRES_OPPONENT_IS_MELEE',					'REQUIREMENT_OPPONENT_UNIT_PROMOTION_CLASS_MATCHES'),
	('REQUIRES_OPPONENT_IS_ANTC',					'REQUIREMENT_OPPONENT_UNIT_PROMOTION_CLASS_MATCHES'),
	('REQUIRES_UNIT_IS_RELIGIOUS_ARM',				'REQUIREMENT_UNIT_TAG_MATCHES'),
	('REQUIRES_UNIT_NEAR_FOREIGN_RELIGIOUS_CITY',	'REQUIREMENT_NEAR_RELIGIOUS_CITY');
insert or ignore into RequirementArguments
	(RequirementId,									Name,						Value)
values
	('REQUIRES_OPPONENT_IS_MELEE',					'UnitPromotionClass',		'PROMOTION_CLASS_MELEE'),
	('REQUIRES_OPPONENT_IS_ANTC',					'UnitPromotionClass',		'PROMOTION_CLASS_ANTI_CAVALRY'),
	('REQUIRES_UNIT_IS_RELIGIOUS_ARM',				'Tag',						'CLASS_WARRIOR_MONK'),
	('REQUIRES_UNIT_NEAR_FOREIGN_RELIGIOUS_CITY',	'FriendlyCity',				0);