-- Trading Dome (Samarkand)
-- In order to adapt the resource change made in UpdateDatabse/DL_Resources.sql at LoadOrder 16010 and resource in Resourceful2 in ModSupport/Resourceful2/HD_Resourceful2.sql at LoadOrder 17000, Modifiers about collecting Luxuries are written in DLCSupport/DL_Babylon_Late.sql, which is at LoadOrder 17010
update Improvements set OnePerCity = 1, SameAdjacentValid = 1 where ImprovementType = 'IMPROVEMENT_TRADING_DOME';
delete from Improvement_YieldChanges where ImprovementType = 'IMPROVEMENT_TRADING_DOME';
delete from TraitModifiers where TraitType = 'MINOR_CIV_SAMARKAND_TRAIT' and ModifierId = 'MINOR_CIV_SAMARKAND_TRADE_GOLD';
delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_TRADING_DOME' and YieldChangeId = 'TradingDome_LuxuryAdjacency';
delete from Improvement_ValidFeatures where ImprovementType = 'IMPROVEMENT_TRADING_DOME';
delete from Improvement_ValidTerrains where ImprovementType = 'IMPROVEMENT_TRADING_DOME';
insert or replace into ImprovementModifiers
	(ImprovementType,				ModifierId)
values
	('IMPROVEMENT_TRADING_DOME',	'TRADING_DOME_DESERT_FOOD'),
	('IMPROVEMENT_TRADING_DOME',	'TRADING_DOME_DESERT_PRODUCTION');
insert or replace into Modifiers
	(ModifierId,							ModifierType,								SubjectRequirementSetId)
values
	('TRADING_DOME_DESERT_FOOD',			'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PETRA_YIELD_MODIFIER_REQUIREMENTS'),
	('TRADING_DOME_DESERT_PRODUCTION',		'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',	'PETRA_YIELD_MODIFIER_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,								Name,			Value)
values
	('TRADING_DOME_DESERT_FOOD',				'YieldType',	'YIELD_FOOD'),
	('TRADING_DOME_DESERT_FOOD',				'Amount',		2),
	('TRADING_DOME_DESERT_PRODUCTION',			'YieldType',	'YIELD_PRODUCTION'),
	('TRADING_DOME_DESERT_PRODUCTION',			'Amount',		1);
	
-- 古典提督航海家汉诺: 赠送一艘+2速的海军近战单位, 且所有与该单位编队的单位将继承该桨帆单位的移速
insert or replace into Types (Type, Kind) values ('ABILITY_HANNO', 'KIND_ABILITY');
insert or replace into TypeTags (Type, Tag) values ('ABILITY_HANNO', 'CLASS_NAVAL_MELEE');
insert or replace into UnitAbilities
	(UnitAbilityType,	Description,						Inactive)
values
	('ABILITY_HANNO',	'LOC_ABILITY_HANNO_DESCRIPTION',	1);
insert or replace into UnitAbilityModifiers
	(UnitAbilityType,	ModifierId)
values
	('ABILITY_HANNO',	'HANNO_FREE_UNIT_MOVEMENT_BUFF'),
	('ABILITY_HANNO',	'ESCORT_MOBILITY_SHARED_MOVEMENT');
update Modifiers set ModifierType = 'MODIFIER_PLAYER_GRANT_ADVANCED_UNIT_OF_CLASS_IN_NEAREST_OWNER_CITY_AND_APPLY_ABILITY' where ModifierId = 'GREAT_PERSON_INDIVIDUAL_HANNO_THE_NAVIGATOR_FREE_UNIT';
update ModifierArguments set Value = 'HANNO_GRANT_ABILITY' where ModifierId = 'GREAT_PERSON_INDIVIDUAL_HANNO_THE_NAVIGATOR_FREE_UNIT' and Name = 'ModifierId';
insert or replace into Modifiers
	(ModifierId,			ModifierType,							RunOnce,	Permanent)
values
	('HANNO_GRANT_ABILITY', 'MODIFIER_PLAYER_UNIT_GRANT_ABILITY',	1,			1);
insert or replace into ModifierArguments
	(ModifierId,			Name,			Value)
values
	('HANNO_GRANT_ABILITY', 'AbilityType',	'ABILITY_HANNO');


-- AYUTTHAYA
-- delete from ModifierArguments where Value = 'MINOR_CIV_AYUTTHAYA_CULTURE_COMPLETE_BUILDING';
delete from TraitModifiers where TraitType = 'MINOR_CIV_AYUTTHAYA_TRAIT';
insert or replace into TraitModifiers
	(TraitType,					 ModifierID)
values
	('MINOR_CIV_AYUTTHAYA_TRAIT',	'MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE'),
	('MINOR_CIV_AYUTTHAYA_TRAIT',	'MINOR_CIV_AYUTTHAYA_RIVIER_DISTRICTS_CULTURE');

insert or replace into Modifiers
	(ModifierId,												ModifierType,											SubjectRequirementSetId)
values
	('MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE',					'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',				 'PLAYER_IS_SUZERAIN'),
	('MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE_MODIFIER',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		'MINOR_3DISTRICTS_CULTURE_REQUIREMENTS'),
	('MINOR_CIV_AYUTTHAYA_RIVIER_DISTRICTS_CULTURE',			'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',				 'PLAYER_IS_SUZERAIN'),
	('MINOR_CIV_AYUTTHAYA_RIVIER_DISTRICTS_CULTURE_MODIFIER',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		'MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,												Name,			Value)
values
	('MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE',					'ModifierId',	'MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE_MODIFIER'),
	('MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE_MODIFIER',			'YieldType',	'YIELD_CULTURE'),
	('MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE_MODIFIER',			'Amount',		1),
	('MINOR_CIV_AYUTTHAYA_RIVIER_DISTRICTS_CULTURE',			'ModifierId',	'MINOR_CIV_AYUTTHAYA_RIVIER_DISTRICTS_CULTURE_MODIFIER'),
	('MINOR_CIV_AYUTTHAYA_RIVIER_DISTRICTS_CULTURE_MODIFIER',	'YieldType',	'YIELD_CULTURE'),
	('MINOR_CIV_AYUTTHAYA_RIVIER_DISTRICTS_CULTURE_MODIFIER',	'Amount',		1);

-- Chinguetti
update ModifierArguments set Value = 0.3 where ModifierId = 'MINOR_CIV_CHINGUETTI_FAITH_FOLLOWERS' and Name = 'Amount';
insert or replace into TraitModifiers(TraitType,ModifierID)values
	('MINOR_CIV_CHINGUETTI_TRAIT','MINOR_CIV_CHINGUETTI_UNIQUE_INFLUENCE_BONUS2');
insert or replace into Modifiers
	(ModifierId,										ModifierType,								SubjectRequirementSetId)
values
	('MINOR_CIV_CHINGUETTI_UNIQUE_INFLUENCE_BONUS2',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',	 'PLAYER_IS_SUZERAIN'),
	('MINOR_CIV_CHINGUETTI_FAITH',					 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', NULL);

insert or replace into ModifierArguments
	(ModifierId,										Name,			Value)
values
	('MINOR_CIV_CHINGUETTI_UNIQUE_INFLUENCE_BONUS2',	'ModifierId',	'MINOR_CIV_CHINGUETTI_FAITH'),
	('MINOR_CIV_CHINGUETTI_FAITH',					 'YieldType',	'YIELD_FAITH'),
	('MINOR_CIV_CHINGUETTI_FAITH',					 'Amount',		3);

-- Babylon
update ModifierArguments set Value = 60 where ModifierId = 'TRAIT_EUREKA_INCREASE';
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_BABYLON' or TraitType = 'TRAIT_LEADER_HAMMURABI';
insert or replace into TraitModifiers
	(TraitType,						ModifierId)
values
	('TRAIT_LEADER_HAMMURABI',		'TRAIT_EUREKA_INCREASE'),
	('TRAIT_LEADER_HAMMURABI',		'HD_TRAIT_EUREKA_INCREASE_RECORD'),
	('TRAIT_LEADER_HAMMURABI',		'TRAIT_SCIENCE_DECREASE');

insert or replace into Modifiers
	(ModifierId,												ModifierType)
values
	('HD_TRAIT_EUREKA_INCREASE_RECORD',	'MODIFIER_PLAYER_ADJUST_PROPERTY');

insert or replace into ModifierArguments
	(ModifierId,												Name,			Value)
values
	('HD_TRAIT_EUREKA_INCREASE_RECORD',	'Key',		'HD_Player_Extra_Tech_Boost'),
	('HD_TRAIT_EUREKA_INCREASE_RECORD',	'Amount',	60);

create temporary table HD_BabylonDistrictBonuses (
	DistrictType text not null,
	YieldType text not null,
	Amount text not null,
	IsNegative boolean not null default 0,
	AttachModifierId text,
	DistrictAttachModifierId text,
	ModifierId text,
	primary key (DistrictType, IsNegative)
);
insert or replace into HD_BabylonDistrictBonuses
	(DistrictType,	YieldType,	Amount)
select
	DistrictType,	YieldType,	1
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into HD_BabylonDistrictBonuses
	(DistrictType,	YieldType,	Amount,		IsNegative)
select
	DistrictType,	YieldType,	-Amount,	1
from HD_BabylonDistrictBonuses;
update HD_BabylonDistrictBonuses set ModifierId = 'TRAIT_BABYLON_' || DistrictType || '_' || YieldType;
update HD_BabylonDistrictBonuses set ModifierId = ModifierId || '_NEGETIVE' where IsNegative;
update HD_BabylonDistrictBonuses set AttachModifierId = ModifierId || '_ATTACH';
update HD_BabylonDistrictBonuses set DistrictAttachModifierId = ModifierId || '_DISTRICT_ATTACH';
insert or replace into TraitModifiers
	(TraitType,								ModifierId)
select
	'TRAIT_CIVILIZATION_BABYLON',			AttachModifierId
from HD_BabylonDistrictBonuses;
insert or replace into Modifiers
	(ModifierId,							ModifierType,									SubjectRequirementSetId)
select
	AttachModifierId,						'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	'DISTRICT_IS_' || DistrictType || '_REQUIREMENTS'
from HD_BabylonDistrictBonuses;
insert or replace into ModifierArguments
	(ModifierId,							Name,			Value)
select
	AttachModifierId,						'ModifierId',	DistrictAttachModifierId
from HD_BabylonDistrictBonuses;
insert or replace into Modifiers
	(ModifierId,							ModifierType,								SubjectRequirementSetId)
select
	DistrictAttachModifierId,				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',
	case when IsNegative then 'CITY_HAS_' || DistrictType || '_REQUIREMENTS' else null end
from HD_BabylonDistrictBonuses;
insert or replace into ModifierArguments
	(ModifierId,							Name,			Value)
select
	DistrictAttachModifierId,				'ModifierId',	ModifierId
from HD_BabylonDistrictBonuses;
-- non Diplomatic Quater
insert or replace into Modifiers
	(ModifierId,			ModifierType,									SubjectRequirementSetId)
select
	ModifierId,				'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',	'DISTRICT_IS_SPECIALTY_DISTRICT_REQUIREMENTS'
from HD_BabylonDistrictBonuses;
insert or replace into ModifierArguments
	(ModifierId,			Name,			Value)
select
	ModifierId,				'YieldType',	YieldType
from HD_BabylonDistrictBonuses;
insert or replace into ModifierArguments
	(ModifierId,			Name,			Value)
select
	ModifierId,				'Amount',		Amount
from HD_BabylonDistrictBonuses;

-- 沟渠 BUILDING_PALGUM
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
values
	('BUILDING_PALGUM',			'HD_PALGUM_ADD_PRODUCTION');

insert or replace into Modifiers
	(ModifierId,									ModifierType,																		OwnerRequirementSetId,											SubjectRequirementSetId)
values
	('HD_PALGUM_ADD_PRODUCTION',	'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',	'PLAYER_HAS_TECH_ENGINEERING_REQUIREMENTS',	'PLOT_IS_FRESH');

insert or replace into ModifierArguments
	(ModifierId,									Name,						Value)
values
	('HD_PALGUM_ADD_PRODUCTION',	'YieldType',		'YIELD_PRODUCTION'),
	('HD_PALGUM_ADD_PRODUCTION',	'Amount',				1);

-- Kenzo Tange
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_KENZO_TANGE';

insert or replace into GreatPersonIndividualActionModifiers 
	(GreatPersonIndividualType,						 ModifierId)
values
	('GREAT_PERSON_INDIVIDUAL_KENZO_TANGE',			 'GREATPERSON_NATIONAL_DISTRICT_SCIENCE_ADJACENCY_AS_TOURISM'),
	('GREAT_PERSON_INDIVIDUAL_KENZO_TANGE',			 'GREATPERSON_NATIONAL_DISTRICT_CULTURE_ADJACENCY_AS_TOURISM'),
	('GREAT_PERSON_INDIVIDUAL_KENZO_TANGE',			 'GREATPERSON_NATIONAL_DISTRICT_FAITH_ADJACENCY_AS_TOURISM'),
	('GREAT_PERSON_INDIVIDUAL_KENZO_TANGE',			 'GREATPERSON_NATIONAL_DISTRICT_PRODUCTION_ADJACENCY_AS_TOURISM'),
	('GREAT_PERSON_INDIVIDUAL_KENZO_TANGE',			 'GREATPERSON_NATIONAL_DISTRICT_GOLD_ADJACENCY_AS_TOURISM');

insert or replace into Modifiers
	(ModifierId,													ModifierType,													Runonce, Permanent)
values
	('GREATPERSON_NATIONAL_DISTRICT_SCIENCE_ADJACENCY_AS_TOURISM',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_TOURISM_ADJACENCY_YIELD_MOFIFIER',	1, 1),
	('GREATPERSON_NATIONAL_DISTRICT_CULTURE_ADJACENCY_AS_TOURISM',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_TOURISM_ADJACENCY_YIELD_MOFIFIER',	1, 1),
	('GREATPERSON_NATIONAL_DISTRICT_FAITH_ADJACENCY_AS_TOURISM',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_TOURISM_ADJACENCY_YIELD_MOFIFIER',	1, 1),
	('GREATPERSON_NATIONAL_DISTRICT_PRODUCTION_ADJACENCY_AS_TOURISM','MODIFIER_PLAYER_DISTRICTS_ADJUST_TOURISM_ADJACENCY_YIELD_MOFIFIER',	1, 1),
	('GREATPERSON_NATIONAL_DISTRICT_GOLD_ADJACENCY_AS_TOURISM',	 'MODIFIER_PLAYER_DISTRICTS_ADJUST_TOURISM_ADJACENCY_YIELD_MOFIFIER',	1, 1);

insert or replace into ModifierArguments
	(ModifierId,														Name,					Value)
values
	('GREATPERSON_NATIONAL_DISTRICT_SCIENCE_ADJACENCY_AS_TOURISM',		'Amount',				100),
	('GREATPERSON_NATIONAL_DISTRICT_SCIENCE_ADJACENCY_AS_TOURISM',		'YieldType',			'YIELD_SCIENCE'),
	('GREATPERSON_NATIONAL_DISTRICT_CULTURE_ADJACENCY_AS_TOURISM',		'Amount',				100),
	('GREATPERSON_NATIONAL_DISTRICT_CULTURE_ADJACENCY_AS_TOURISM',		'YieldType',			'YIELD_CULTURE'),
	('GREATPERSON_NATIONAL_DISTRICT_FAITH_ADJACENCY_AS_TOURISM',		'Amount',				100),
	('GREATPERSON_NATIONAL_DISTRICT_FAITH_ADJACENCY_AS_TOURISM',		'YieldType',			'YIELD_FAITH'),
	('GREATPERSON_NATIONAL_DISTRICT_PRODUCTION_ADJACENCY_AS_TOURISM',	'Amount',				100),
	('GREATPERSON_NATIONAL_DISTRICT_PRODUCTION_ADJACENCY_AS_TOURISM',	'YieldType',			'YIELD_PRODUCTION'),
	('GREATPERSON_NATIONAL_DISTRICT_GOLD_ADJACENCY_AS_TOURISM',		 'Amount',				100),
	('GREATPERSON_NATIONAL_DISTRICT_GOLD_ADJACENCY_AS_TOURISM',		 'YieldType',			'YIELD_GOLD');

insert or replace into ModifierStrings
	(ModifierId,													Context,	Text)
values
	('GREATPERSON_NATIONAL_DISTRICT_SCIENCE_ADJACENCY_AS_TOURISM',	'Summary',	'LOC_GREATPERSON_NATIONAL_DISTRICT_SCIENCE_ADJACENCY_AS_TOURISM');

-- Bug fix for the new great scientist IBN_KHALDUN.
update ModifierArguments set Value = 4
 where ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_SCIENCE' and Name = 'Amount'
	or ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_CULTURE' and Name = 'Amount'
	or ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_PRODUCTION' and Name = 'Amount'
	or ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_GOLD' and Name = 'Amount'
	or ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_FAITH' and Name = 'Amount';

update ModifierArguments set Value = 8
 where ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_SCIENCE' and Name = 'Amount'
	or ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_CULTURE' and Name = 'Amount'
	or ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_PRODUCTION' and Name = 'Amount'
	or ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_GOLD' and Name = 'Amount'
	or ModifierID = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_FAITH' and Name = 'Amount';

update Modifiers set RunOnce = 0 where ModifierId like 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_%';

-- Add on for new happiness level.
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType, ModifierId, AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_SCIENCE',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_CULTURE',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_PRODUCTION',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_GOLD',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_FAITH',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_SCIENCE',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_CULTURE',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_PRODUCTION',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_GOLD',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN',
	'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_FAITH',
	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');

update GreatPersonIndividualActionModifiers set AttachmentTargetType = 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER' 
where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN' and ModifierId like 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_%';

insert or replace into Modifiers
	(ModifierID,														ModifierType,								RunOnce, Permanent)
values
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_SCIENCE',	'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_CULTURE',	'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_GOLD',		'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_FAITH',		'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_SCIENCE',		'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_CULTURE',		'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_PRODUCTION',	'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_GOLD',			'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_FAITH',		 'MODIFIER_PLAYER_CITIES_ADJUST_HAPPINESS_YIELD_BAB',	0,	1);

insert or replace into ModifierArguments
	(ModifierID,															Name,				Value)
values
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_SCIENCE',		'HappinessType',	'HAPPINESS_DELIGHTED'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_SCIENCE',		'YieldType',		'YIELD_SCIENCE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_SCIENCE',		'Amount',			2),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_CULTURE',		'HappinessType',	'HAPPINESS_DELIGHTED'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_CULTURE',		'YieldType',		'YIELD_CULTURE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_CULTURE',		'Amount',			2),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_PRODUCTION',	 'HappinessType',	'HAPPINESS_DELIGHTED'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_PRODUCTION',	 'YieldType',		'YIELD_PRODUCTION'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_PRODUCTION',	 'Amount',			2),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_GOLD',			'HappinessType',	'HAPPINESS_DELIGHTED'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_GOLD',			'YieldType',		'YIELD_GOLD'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_GOLD',			'Amount',			2),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_FAITH',			'HappinessType',	'HAPPINESS_DELIGHTED'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_FAITH',			'YieldType',		'YIELD_FAITH'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_DELIGHTED_FAITH',			'Amount',			2),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_SCIENCE',			'HappinessType',	'HAPPINESS_JOYFUL'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_SCIENCE',			'YieldType',		'YIELD_SCIENCE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_SCIENCE',			'Amount',			6),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_CULTURE',			'HappinessType',	'HAPPINESS_JOYFUL'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_CULTURE',			'YieldType',		'YIELD_CULTURE'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_CULTURE',			'Amount',			6),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_PRODUCTION',		'HappinessType',	'HAPPINESS_JOYFUL'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_PRODUCTION',		'YieldType',		'YIELD_PRODUCTION'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_PRODUCTION',		'Amount',			6),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_GOLD',				'HappinessType',	'HAPPINESS_JOYFUL'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_GOLD',				'YieldType',		'YIELD_GOLD'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_GOLD',				'Amount',			6),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_FAITH',			 'HappinessType',	'HAPPINESS_JOYFUL'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_FAITH',			 'YieldType',		'YIELD_FAITH'),
	('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_JOYFUL_FAITH',			 'Amount',			6);

-- Mahavihara
insert or replace into Improvement_Adjacencies
	(ImprovementType,				YieldChangeId)
values
	('IMPROVEMENT_MAHAVIHARA',		'Mahavihara_Seowon_Science_Early'),
	('IMPROVEMENT_MAHAVIHARA',		'Mahavihara_Seowon_Science_Late'),
	('IMPROVEMENT_MAHAVIHARA',		'Mahavihara_Holy_Site_Science_Late'),
	('IMPROVEMENT_MAHAVIHARA',		'Mahavihara_Lavra_Science_Late'),
	('IMPROVEMENT_MAHAVIHARA',		'Mahavihara_Neighborhood_Science'),
	('IMPROVEMENT_MAHAVIHARA',		'Mahavihara_Mbanza_Science');
insert or replace into Adjacency_YieldChanges
	(ID,										Description,	YieldType,			YieldChange,	AdjacentDistrict,			PrereqCivic,			ObsoleteCivic)
values
	('Mahavihara_Seowon_Science_Early',		'Placeholder',	'YIELD_SCIENCE',	1,				'DISTRICT_SEOWON',			null,					'CIVIC_DIVINE_RIGHT'),
	('Mahavihara_Seowon_Science_Late',			'Placeholder',	'YIELD_SCIENCE',	2,				'DISTRICT_SEOWON',			'CIVIC_DIVINE_RIGHT',	null),
	('Mahavihara_Holy_Site_Science_Late',		'Placeholder',	'YIELD_SCIENCE',	2,				'DISTRICT_HOLY_SITE',		'CIVIC_DIVINE_RIGHT',	null),
	('Mahavihara_Lavra_Science_Late',			'Placeholder',	'YIELD_SCIENCE',	2,				'DISTRICT_LAVRA',			'CIVIC_DIVINE_RIGHT',	null),
	('Mahavihara_Neighborhood_Science',		'Placeholder',	'YIELD_SCIENCE',	1,				'DISTRICT_NEIGHBORHOOD',	null,					null),
	('Mahavihara_Mbanza_Science',				'Placeholder',	'YIELD_SCIENCE',	1,				'DISTRICT_MBANZA',			null,					null);

-- Modifiers in this table are attached to suzerain
create temporary table if not exists TraitAttachedModifiers (
	TraitType text not null,
	ModifierId text not null,
	primary key (TraitType, ModifierId)
);

-- Johannesburg
delete from TraitModifiers where TraitType = 'MINOR_CIV_JOHANNESBURG_TRAIT';
create temporary table JohannesburgResources (ResourceType text not null primary key);
insert or replace into JohannesburgResources (ResourceType) select ResourceType from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_MINE' or ImprovementType = 'IMPROVEMENT_QUARRY';

insert or replace into TraitAttachedModifiers
	(TraitType,							ModifierId)
select
	'MINOR_CIV_JOHANNESBURG_TRAIT',		'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_PRODUCTION_TIRE1'
from JohannesburgResources;
insert or replace into Modifiers
	(ModifierId,														ModifierType,										 SubjectRequirementSetId)
select
	'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_PRODUCTION_TIRE1',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',	 'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS'
from JohannesburgResources;
insert or replace into ModifierArguments
	(ModifierId,														Name,			Value)
select
	'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_PRODUCTION_TIRE1',	'YieldType',	'YIELD_PRODUCTION'
from JohannesburgResources;
insert or replace into ModifierArguments
	(ModifierId,														Name,			Value)
select
	'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_PRODUCTION_TIRE1',	'Amount',		1
from JohannesburgResources;
insert or replace into TraitAttachedModifiers
	(TraitType,							ModifierId)
select
	'MINOR_CIV_JOHANNESBURG_TRAIT',		'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_PRODUCTION_TIRE2'
from JohannesburgResources;
insert or replace into Modifiers
	(ModifierId,														ModifierType,											OwnerRequirementSetId,							SubjectRequirementSetId)
select
	'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_PRODUCTION_TIRE2',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',		'PLAYER_HAS_TECH_APPRENTICESHIP_REQUIREMENTS',	'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS'
from JohannesburgResources;
insert or replace into ModifierArguments
	(ModifierId,														Name,			Value)
select
	'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_PRODUCTION_TIRE2',	'YieldType',	'YIELD_PRODUCTION'
from JohannesburgResources;
insert or replace into ModifierArguments
	(ModifierId,														Name,			Value)
select
	'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_PRODUCTION_TIRE2',	'Amount',		1
from JohannesburgResources;

insert or replace into TraitAttachedModifiers
	(TraitType,							ModifierId)
select
	'MINOR_CIV_JOHANNESBURG_TRAIT',		'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_GOLD'
from JohannesburgResources;
insert or replace into Modifiers
	(ModifierId,														ModifierType,											SubjectRequirementSetId)
select
	'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_GOLD',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',	'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS'
from JohannesburgResources;
insert or replace into ModifierArguments
	(ModifierId,														Name,			Value)
select
	'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_GOLD',	'YieldType',	'YIELD_GOLD'
from JohannesburgResources;
insert or replace into ModifierArguments
	(ModifierId,														Name,			Value)
select
	'MINOR_CIV_JOHANNESBURG_' || ResourceType || '_GOLD',	'Amount',		3
from JohannesburgResources;

-- Attach modifiers in TraitAttachedModifiers to suzerain
insert or ignore into TraitModifiers
	(TraitType, ModifierId)
select
	TraitType,	ModifierId || '_ATTACH'
from TraitAttachedModifiers;
insert or ignore into Modifiers
	(ModifierId,				ModifierType,								SubjectRequirementSetId)
select
	ModifierId || '_ATTACH',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',	 'PLAYER_IS_SUZERAIN'
from TraitAttachedModifiers;
insert or ignore into ModifierArguments
	(ModifierId,				Name,			Value)
select
	ModifierId || '_ATTACH',	'ModifierId',	ModifierId
from TraitAttachedModifiers;
drop table TraitAttachedModifiers;
--张衡
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_CEL_NAV' or ModifierId = 'GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_MATHEMATICS';
-- delete from ModifierArguments where ModifierId = 'GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_ENGINEERING' and Name = 'GrantTechIfBoosted';
insert or replace into GreatPersonIndividualActionModifiers 
	(GreatPersonIndividualType,					ModifierId,										AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_ZHANG_HENG',		'GREATPERSON_1CLASSICALMEDIEVALTECHBOOSTS',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');
insert or replace into Modifiers
	(ModifierID,									ModifierType,											RunOnce,	Permanent)
values
	('GREATPERSON_1CLASSICALMEDIEVALTECHBOOSTS',	'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_BY_ERA',	1,			1);
insert or replace into ModifierArguments
	(ModifierID,									Name,				Value)
values
	('GREATPERSON_1CLASSICALMEDIEVALTECHBOOSTS',	'Amount',			1),
	('GREATPERSON_1CLASSICALMEDIEVALTECHBOOSTS',	'StartEraType',		'ERA_CLASSICAL'),
	('GREATPERSON_1CLASSICALMEDIEVALTECHBOOSTS',	'EndEraType',		'ERA_CLASSICAL');
insert or replace into ModifierStrings
	(ModifierId,												Context,				Text)
values
	('GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_ENGINEERING',		'Summary',				'LOC_GREAT_PERSON_INDIVIDUAL_ZHANGHENG'),
	('GREATPERSON_1CLASSICALMEDIEVALTECHBOOSTS',				'Summary',				'GREATPERSON_1CLASSICALMEDIEVALTECHBOOSTS');