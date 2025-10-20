-------------------------------------
--		GreatPeople Adjustments		--
-------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------
-- New Great Eng (Classical Era), JNR Industry Expansion
-------------------------------------------------------------------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------
INSERT OR IGNORE INTO Types
	(Type,													Kind)
VALUES
	('GREAT_PERSON_INDIVIDUAL_JNR_ARCHIMEDES',				'KIND_GREAT_PERSON_INDIVIDUAL'),
	('GREAT_PERSON_INDIVIDUAL_JNR_LI_BING',						'KIND_GREAT_PERSON_INDIVIDUAL'),
	('GREAT_PERSON_INDIVIDUAL_JNR_MA_JUN',						'KIND_GREAT_PERSON_INDIVIDUAL'),
	('GREAT_PERSON_INDIVIDUAL_HD_CROESUS',						'KIND_GREAT_PERSON_INDIVIDUAL'),
	('GREAT_PERSON_INDIVIDUAL_HD_ALI_MUGHAYAT_SYAH',	'KIND_GREAT_PERSON_INDIVIDUAL'),
	('GREAT_PERSON_INDIVIDUAL_HD_SANCTUS_LEO',				'KIND_GREAT_PERSON_INDIVIDUAL'),
	-- 专属伟人
	('GREAT_PERSON_CLASS_HD_YUAN_WAN_QING',          	'KIND_GREAT_PERSON_CLASS'),
	('UNIT_HD_YUAN_WAN_QING',                        	'KIND_UNIT'),
	('GREAT_PERSON_INDIVIDUAL_HD_YUAN_WAN_QING',			'KIND_GREAT_PERSON_INDIVIDUAL'),
	('GREAT_PERSON_CLASS_HD_SI_NONG_SI',          		'KIND_GREAT_PERSON_CLASS'),
	('UNIT_HD_SI_NONG_SI',                        		'KIND_UNIT'),
	('GREAT_PERSON_INDIVIDUAL_HD_SI_NONG_SI',					'KIND_GREAT_PERSON_INDIVIDUAL');

insert or ignore into Types
	(Type,												Kind)
select
	'GREAT_PERSON_INDIVIDUAL_HD_SANG_HONGYANG',			'KIND_GREAT_PERSON_INDIVIDUAL'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_JNR_MINT');

--------------------------------------------------------------
insert or replace into Units
	(UnitType,              	Name,                       			BaseSightRange, BaseMoves,  Domain,         FormationClass,             Cost,   Description,                        		CanCapture, CanRetreatWhenCaptured, CanTrain)
values
	('UNIT_HD_YUAN_WAN_QING', 'LOC_UNIT_HD_YUAN_WAN_QING_NAME', 2,              4,          'DOMAIN_LAND',  'FORMATION_CLASS_CIVILIAN', 1,      'LOC_UNIT_HD_YUAN_WAN_QING_DESCRIPTION',0,          1,                      0),
	('UNIT_HD_SI_NONG_SI', 		'LOC_UNIT_HD_SI_NONG_SI_NAME', 		2,              4,          'DOMAIN_LAND',  'FORMATION_CLASS_CIVILIAN', 1,      'LOC_UNIT_HD_SI_NONG_SI_DESCRIPTION',		0,          1,                      0);

insert or replace into GreatPersonClasses
	(GreatPersonClassType,              		Name,                         									UnitType,           			DistrictType,           PseudoYieldType,             IconString,             ActionIcon,                          AvailableInTimeline,	GenerateDuplicateIndividuals)
values
	('GREAT_PERSON_CLASS_HD_YUAN_WAN_QING', 'LOC_GREAT_PERSON_CLASS_HD_YUAN_WAN_QING_NAME', 'UNIT_HD_YUAN_WAN_QING', 'DISTRICT_THEATER',     'PSEUDOYIELD_GPP_WRITER',    '[ICON_GreatWriter]', 	'ICON_UNITOPERATION_WRITER_ACTION',   0,										1),
	('GREAT_PERSON_CLASS_HD_SI_NONG_SI', 		'LOC_GREAT_PERSON_CLASS_HD_SI_NONG_SI_NAME',  	'UNIT_HD_SI_NONG_SI', 	 'DISTRICT_THEATER',     'PSEUDOYIELD_GPP_MUSICIAN',  '[ICON_GreatMusician]', 'ICON_UNITOPERATION_MUSICIAN_ACTION', 0,										1);

-- GreatPersonIndividuals
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividuals
	(
	GreatPersonIndividualType,
	Name,
	GreatPersonClassType,
	EraType,
	Gender,
	ActionCharges,
	ActionRequiresCompletedDistrictType
	)
VALUES
	-- 专属伟人
	(
	'GREAT_PERSON_INDIVIDUAL_HD_YUAN_WAN_QING',
	'LOC_UNIT_HD_YUAN_WAN_QING_NAME',
	'GREAT_PERSON_CLASS_HD_YUAN_WAN_QING',
	'ERA_ANCIENT',
	'M',
	0,
	NULL
	),
	(
	'GREAT_PERSON_INDIVIDUAL_HD_SI_NONG_SI',
	'LOC_UNIT_HD_SI_NONG_SI_NAME',
	'GREAT_PERSON_CLASS_HD_SI_NONG_SI',
	'ERA_ANCIENT',
	'M',
	0,
	NULL
	),
	-- 常规伟人
	(
	'GREAT_PERSON_INDIVIDUAL_JNR_ARCHIMEDES',
	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_ARCHIMEDES_NAME',
	'GREAT_PERSON_CLASS_ENGINEER',
	'ERA_CLASSICAL',
	'M',
	1,
	'DISTRICT_INDUSTRIAL_ZONE'
	),
	(
	'GREAT_PERSON_INDIVIDUAL_JNR_LI_BING',
	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_LI_BING_NAME',
	'GREAT_PERSON_CLASS_ENGINEER',
	'ERA_CLASSICAL',
	'M',
	1,
	'DISTRICT_INDUSTRIAL_ZONE'
	),
	(
	'GREAT_PERSON_INDIVIDUAL_JNR_MA_JUN',
	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_MA_JUN_NAME',
	'GREAT_PERSON_CLASS_ENGINEER',
	'ERA_CLASSICAL',
	'M',
	1,
	'DISTRICT_CITY_CENTER'
	),
	(
	'GREAT_PERSON_INDIVIDUAL_HD_CROESUS',
	'LOC_GREAT_PERSON_INDIVIDUAL_HD_CROESUS_NAME',
	'GREAT_PERSON_CLASS_MERCHANT',
	'ERA_CLASSICAL',
	'M',
	1,
	'DISTRICT_COMMERCIAL_HUB'
	),
	(
	'GREAT_PERSON_INDIVIDUAL_HD_ALI_MUGHAYAT_SYAH',
	'LOC_GREAT_PERSON_INDIVIDUAL_HD_ALI_MUGHAYAT_SYAH_NAME',
	'GREAT_PERSON_CLASS_MERCHANT',
	'ERA_MEDIEVAL',
	'M',
	1,
	'DISTRICT_COMMERCIAL_HUB'
	),
	(
	'GREAT_PERSON_INDIVIDUAL_HD_SANCTUS_LEO',
	'LOC_GREAT_PERSON_INDIVIDUAL_HD_SANCTUS_LEO_NAME',
	'GREAT_PERSON_CLASS_PROPHET',
	'ERA_CLASSICAL',
	'M',
	1,
	null
	);
insert or ignore into GreatPersonIndividuals
	(
	GreatPersonIndividualType,
	Name,
	GreatPersonClassType,
	EraType,
	Gender,
	ActionCharges,
	ActionRequiresCompletedDistrictType
	)
select	
	'GREAT_PERSON_INDIVIDUAL_HD_SANG_HONGYANG',
	'LOC_GREAT_PERSON_INDIVIDUAL_HD_SANG_HONGYANG_NAME',
	'GREAT_PERSON_CLASS_MERCHANT',
	'ERA_CLASSICAL',
	'M',
	1,
	'DISTRICT_COMMERCIAL_HUB'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_JNR_MINT');

UPDATE GreatPersonIndividuals SET EraType='ERA_CLASSICAL'	WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_IMHOTEP';

UPDATE GreatPersonIndividuals SET ActionEffectTextOverride='LOC_GREATPERSON_IMHOTEP_ACTIVE_JNR_UC'				WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_IMHOTEP';
--------------------------------------------------------------

-- Modifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO Modifiers
		(ModifierId,										ModifierType,											SubjectRequirementSetId,					Permanent)
VALUES	('JNR_GREATPERSON_EUREKA_STRENGTH',					'MODIFIER_PLAYER_ADJUST_TECHNOLOGY_BOOST',				NULL,										1),
		('HD_JNR_GREATPERSON_EUREKA_STRENGTH_RECORD',					'MODIFIER_PLAYER_ADJUST_PROPERTY',				NULL,										1),
		('JNR_GREATPERSON_DAM_UNLOCK_MATHEMATICS',			'MODIFIER_PLAYER_ADJUST_DISTRICT_UNLOCK',				NULL,										1);
--------------------------------------------------------------

-- ModifierArguments
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierArguments
		(ModifierId,										Name,					Value)
VALUES	('JNR_GREATPERSON_EUREKA_STRENGTH',					'Amount',				3),
		('HD_JNR_GREATPERSON_EUREKA_STRENGTH_RECORD',					'Key',				'HD_Player_Extra_Tech_Boost'),
		('HD_JNR_GREATPERSON_EUREKA_STRENGTH_RECORD',					'Amount',				3),
		('JNR_GREATPERSON_DAM_UNLOCK_MATHEMATICS',			'DistrictType',			'DISTRICT_DAM'),
		('JNR_GREATPERSON_DAM_UNLOCK_MATHEMATICS',			'TechType',				'TECH_MATHEMATICS');

UPDATE ModifierArguments SET Extra=-1	WHERE Name='Amount' AND ModifierId='JNR_GREATPERSON_EUREKA_STRENGTH';
--------------------------------------------------------------

-- GreatPersonIndividualActionModifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividualActionModifiers
		(GreatPersonIndividualType,								ModifierId,											AttachmentTargetType)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_ARCHIMEDES',				'JNR_GREATPERSON_EUREKA_STRENGTH',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
		('GREAT_PERSON_INDIVIDUAL_JNR_ARCHIMEDES',				'HD_JNR_GREATPERSON_EUREKA_STRENGTH_RECORD',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
		('GREAT_PERSON_INDIVIDUAL_JNR_LI_BING',					'JNR_GREATPERSON_DAM_UNLOCK_MATHEMATICS',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY');
--------------------------------------------------------------

-- ModifierStrings
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierStrings
		(ModifierId,										Context,	Text)
VALUES	('JNR_GREATPERSON_EUREKA_STRENGTH',					'Summary',	'LOC_JNR_GREATPERSON_EUREKA_STRENGTH'),
		('JNR_GREATPERSON_DAM_UNLOCK_MATHEMATICS',			'Summary',	'LOC_JNR_GREATPERSON_DAM_UNLOCK_MATHEMATICS');
--------------------------------------------------------------

--------------------------------------------------------------
-- Adaptation for JNR's New Great Eng
update GreatPersonIndividuals set ActionCharges = 3 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_IMHOTEP';
update ModifierArguments set Value = 55 where Name = 'Amount' and ModifierId = 'GREAT_PERSON_INDIVIDUAL_IMHOTEP_PRODUCTION_OTHER';
update ModifierArguments set Value = 110 where Name = 'Amount' and ModifierId = 'GREAT_PERSON_INDIVIDUAL_IMHOTEP_PRODUCTION_ANCIENT_CLASSICAL';

-- update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JNR_ARCHIMEDES';
-- update ModifierArguments set Value = 1 where Name = 'Amount' and ModifierId = 'JNR_GREATPERSON_EUREKA_STRENGTH';

update GreatPersonIndividuals set ActionRequiresCompletedDistrictType = 'DISTRICT_CITY_CENTER' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JNR_LI_BING';
update GreatPersonIndividuals set ActionRequiresCompletedDistrictType = 'DISTRICT_INDUSTRIAL_ZONE' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JNR_MA_JUN';

insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,					ModifierId,											AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_JNR_ARCHIMEDES',	'GREATPERSON_1MEDIEVALTECHBOOST',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_JNR_LI_BING',		'JNR_GREATPERSON_DAM_SPEED_UP',						'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_JNR_LI_BING',		'JNR_GREATPERSON_DAM_RIVER_PRODUCTION',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_JNR_MA_JUN',		'HD_GREATPERSON_GRANT_IZ_TIER1_BUILDING',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');

insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,					ModifierId,											AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_JNR_MA_JUN',		'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = 1;

insert or replace into Modifiers
	(ModifierId,										ModifierType,												SubjectRequirementSetId)
values
	('JNR_GREATPERSON_DAM_RIVER_PRODUCTION',			'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',				'DISTRICT_IS_DAM'),
	('JNR_GREATPERSON_DAM_SPEED_UP',					'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION',		NULL),
	('HD_GREATPERSON_GRANT_IZ_TIER1_BUILDING',			'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',		NULL);

insert or replace into Modifiers
	(ModifierId,										ModifierType)
select
	'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = 1;

insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
values
	('JNR_GREATPERSON_DAM_RIVER_PRODUCTION',			'ModifierId',		'HYDROELECTRIC_DAM_ADD_RIVER_PRODUCTION'),
	('JNR_GREATPERSON_DAM_SPEED_UP',					'DistrictType',		'DISTRICT_DAM'),
	('JNR_GREATPERSON_DAM_SPEED_UP',					'Amount',			25),
	('HD_GREATPERSON_GRANT_IZ_TIER1_BUILDING',			'BuildingType',		'BUILDING_WORKSHOP');

insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'BuildingType',		BuildingType
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = 1;

insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'Amount',			1
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = 1;

insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'YieldType',		'YIELD_PRODUCTION'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = 1;

insert or replace into ModifierStrings
	(ModifierId,												Context,	Text)
values 
	('HD_GREATPERSON_GRANT_IZ_TIER1_BUILDING',					'Summary',	'LOC_HD_GREATPERSON_GRANT_IZ_TIER1_BUILDING');


-------------------------------------------------------------- End

-------------------------------------------------------------------------------------------------------------------------------------------
---	Great Engineer
-------------------------------------------------------------------------------------------------------------------------------------------
-- Bi Sheng: if printing eruka is boosted grant this tech GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_MATHEMATICS
-- JAMES_OF_ST_GEORGE: +1 great engineer points for each level wall 
-- CHARLES_CORREA: +2 appeal national-wide
-- ALVAR_AALTO: +1 appeal national-wide
-- SHAH_JAHAN: tourism from district adjacency national-wide
-- JOHN_A_ROEBLING: little goldengate + wonder tourism
-- SHAH_JAHAN: to renissance era
-- JOSEPH_PAXTON: to modern era, 2 charges +680 production for wonders 

delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_BI_SHENG' and ModifierId = 'GREATPERSON_PRINTINGTECHBOOST';
update GreatPersonIndividuals set ActionEffectTextOverride = 'LOC_HD_BI_SHENG_ACTIVE' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_BI_SHENG';
-- delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_CULTURE_BOMB_TRIGGER_INDUSTRIAL_ZONE';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO' and ModifierId = 'GREATPERSON_CITY_APPEAL_SMALL';
update GreatPersonIndividuals set EraType = 'ERA_RENAISSANCE' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_SHAH_JAHAN';	
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA';
update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE';
update GreatPersonIndividuals set EraType = 'ERA_MODERN', ActionCharges = 2, ActionRequiresIncompleteWonder = 1, ActionRequiresCompletedDistrictType = NULL where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JOSEPH_PAXTON';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JOSEPH_PAXTON' and (ModifierId = 'GREATPERSON_EXTRA_REGIONAL_BUILDING_RANGE' or ModifierId = 'GREATPERSON_EXTRA_REGIONAL_BUILDING_ENTERTAINMENT');
update GreatPersonIndividuals set ActionCharges = ActionCharges + 1 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ADA_LOVELACE';
update GreatPersonIndividuals set ActionEffectTextOverride = 'LOC_GREATPERSON_JAMES_WATT_ACTIVE' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JAMES_WATT';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO';

delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_NIKOLA_TESLA' and ModifierId = 'GREATPERSON_EXTRA_REGIONAL_BUILDING_RANGE';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_NIKOLA_TESLA' and ModifierId = 'GREATPERSON_EXTRA_REGIONAL_BUILDING_PRODUCTION';

insert or replace into GreatPersonIndividualActionModifiers 
	(GreatPersonIndividualType,							ModifierId,										AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO',				'GREATPERSON_CITY_AMENITIES_SMALL',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO',				'GREATPERSON_CITY_HOUSING_MEDIUM',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO',				'GREATPERSON_SINGLECITY_APPEAL',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO',				'GREATPERSON_SINGLECITY_APPEAL',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO',				'GREATPERSON_SINGLECITY_WONDER_TOURISM',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO',				'GREATPERSON_SINGLECITY_IMPROVEMENT_TOURISM',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO',				'GREATPERSON_SINGLECITY_NATIONAL_PARK_TOURISM', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_JOSEPH_PAXTON',			'GREATPERSON_GRANT_PRODUCTION_IN_CITY_MODERN',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_WONDER_IN_TILE');

insert or replace into GreatPersonIndividualActionModifiers 
	(GreatPersonIndividualType,							ModifierId)
values
	('GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE',		'GREAT_PERSON_INDIVIDUAL_WALL_EARLY_GEP'),
	('GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE',		'GREAT_PERSON_INDIVIDUAL_WALL_GEP'),
	('GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE',		'GREAT_PERSON_INDIVIDUAL_CASTLE_GEP'),
	('GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE',		'GREAT_PERSON_INDIVIDUAL_STAR_WALL_GEP'),
	-- this Modifier is not removed with the Regional Range rewrite in DL_PostProcess.sql in order to make Power Plants provides power to more cities.
	('GREAT_PERSON_INDIVIDUAL_ADA_LOVELACE',			'GREATPERSON_REGIONAL_RANGE_BONUS'),
	('GREAT_PERSON_INDIVIDUAL_ADA_LOVELACE',			'HD_ADA_LOVELACE_ADD_INDUSTRIAL_ZONE_REGIONAL_RANGE'),
	('GREAT_PERSON_INDIVIDUAL_ADA_LOVELACE',			'HD_ADA_LOVELACE_ADD_INDUSTRIAL_ZONE_REGIONAL_SCIENCE'),
	('GREAT_PERSON_INDIVIDUAL_NIKOLA_TESLA',			'GREATPERSON_ELECTRICITY'),
	('GREAT_PERSON_INDIVIDUAL_NIKOLA_TESLA',			'GREATPERSON_ELECTRICITY_ADD_PRODUCTION'),
	('GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING',			'GREATPERSON_NATIONAL_APPEAL'),
	('GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA',			'GREATPERSON_NATIONAL_APPEAL_BIG');

insert or replace into Modifiers
	(ModifierId,										ModifierType,								Runonce, Permanent, SubjectRequirementSetId)
values
    ('GREAT_PERSON_INDIVIDUAL_WALL_EARLY_GEP',          'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',     0,1,    'HD_PLOT_HAS_BUILDING_WALLS_EARLY_REQUIREMENTS'),
    ('GREAT_PERSON_INDIVIDUAL_WALL_GEP',                'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',     0,1,    'HD_PLOT_HAS_BUILDING_WALLS_REQUIREMENTS'),
    ('GREAT_PERSON_INDIVIDUAL_CASTLE_GEP',              'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',     0,1,    'HD_PLOT_HAS_BUILDING_CASTLE_REQUIREMENTS'),
    ('GREAT_PERSON_INDIVIDUAL_STAR_WALL_GEP',           'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',     0,1,    'HD_PLOT_HAS_BUILDING_STAR_FORT_REQUIREMENTS'),
    ('GREATPERSON_REGIONAL_RANGE_BONUS',                'MODIFIER_PLAYER_DISTRICTS_ADJUST_EXTRA_REGIONAL_RANGE',0,1,    'DISTRICT_IS_INDUSTRIAL_ZONE'),
		('HD_ADA_LOVELACE_ADD_INDUSTRIAL_ZONE_REGIONAL_RANGE',					'MODIFIER_PLAYER_CITIES_ADJUST_PROPERTY',					0,			1,			null),
		('HD_ADA_LOVELACE_ADD_INDUSTRIAL_ZONE_REGIONAL_SCIENCE',				'MODIFIER_PLAYER_CITIES_ADJUST_PROPERTY',					0,			1,			null),
    ('GREATPERSON_CAMPUS_SCIENCE_PRODUCTION',           'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS', 0,1, 'DISTRICT_IS_CAMPUS'),
    ('GREATPERSON_INDUSTRY_PRODUCTION_SCIENCE',         'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS', 0,1, 'DISTRICT_IS_INDUSTRIAL_ZONE'),
    ('GREATPERSON_NATIONAL_APPEAL',                     'MODIFIER_PLAYER_CITIES_ADJUST_CITY_APPEAL',            0,1,    NULL),
    ('GREATPERSON_SINGLECITY_APPEAL',                   'MODIFIER_SINGLE_CITY_ADJUST_CITY_APPEAL',              0,1,    NULL),
    ('GREATPERSON_SINGLECITY_WONDER_TOURISM',           'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',                  0,1,    NULL),
    ('GREATPERSON_SINGLECITY_IMPROVEMENT_TOURISM',      'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_TOURISM',      0,1,    NULL),  
    ('GREATPERSON_SINGLECITY_NATIONAL_PARK_TOURISM',    'MODIFIER_SINGLE_CITY_ADJUST_NATIONAL_PARK_TOURISM',    0,1,    NULL),
    ('GREATPERSON_NATIONAL_APPEAL_BIG',                 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_APPEAL',            0,1,    NULL),
    ('GREATPERSON_GRANT_PRODUCTION_IN_CITY_MODERN',     'MODIFIER_SINGLE_CITY_GRANT_PRODUCTION_IN_CITY',        1,1,    NULL),
    ('GREATPERSON_ELECTRICITY',                         'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',               0,1,    NULL),
    ('GREATPERSON_ELECTRICITY_MODIFIER',                'MODIFIER_SINGLE_CITY_ADJUST_FREE_POWER',               0,1,    NULL),
    ('GREATPERSON_ELECTRICITY_ADD_PRODUCTION',          'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',   0,1,    'CITY_IS_POWERED');

insert or replace into ModifierArguments
	(ModifierId,										Name,					Value)
values
    ('GREAT_PERSON_INDIVIDUAL_WALL_EARLY_GEP',          'GreatPersonClassType', 'GREAT_PERSON_CLASS_ENGINEER'),
    ('GREAT_PERSON_INDIVIDUAL_WALL_EARLY_GEP',          'Amount',               1),
    ('GREAT_PERSON_INDIVIDUAL_WALL_GEP',                'GreatPersonClassType', 'GREAT_PERSON_CLASS_ENGINEER'),
    ('GREAT_PERSON_INDIVIDUAL_WALL_GEP',                'Amount',               1),
    ('GREAT_PERSON_INDIVIDUAL_CASTLE_GEP',              'GreatPersonClassType', 'GREAT_PERSON_CLASS_ENGINEER'),
    ('GREAT_PERSON_INDIVIDUAL_CASTLE_GEP',              'Amount',               1),
    ('GREAT_PERSON_INDIVIDUAL_STAR_WALL_GEP',           'GreatPersonClassType', 'GREAT_PERSON_CLASS_ENGINEER'),
    ('GREAT_PERSON_INDIVIDUAL_STAR_WALL_GEP',           'Amount',               1),
    ('GREATPERSON_REGIONAL_RANGE_BONUS',                'Amount',               1),
	('HD_ADA_LOVELACE_ADD_INDUSTRIAL_ZONE_REGIONAL_RANGE',					'Key',		'HD_SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_DISTRICT_INDUSTRIAL_ZONE'),
	('HD_ADA_LOVELACE_ADD_INDUSTRIAL_ZONE_REGIONAL_RANGE',					'Amount',			1),
	('HD_ADA_LOVELACE_ADD_INDUSTRIAL_ZONE_REGIONAL_SCIENCE',					'Key',		'HD_SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_BONUS_DISTRICT_INDUSTRIAL_ZONE_YIELD_SCIENCE'),
	('HD_ADA_LOVELACE_ADD_INDUSTRIAL_ZONE_REGIONAL_SCIENCE',					'Amount',			2),
    ('GREATPERSON_CAMPUS_SCIENCE_PRODUCTION',           'YieldTypeToMirror',    'YIELD_SCIENCE'),
    ('GREATPERSON_CAMPUS_SCIENCE_PRODUCTION',           'YieldTypeToGrant',     'YIELD_PRODUCTION'),
    ('GREATPERSON_INDUSTRY_PRODUCTION_SCIENCE',         'YieldTypeToMirror',    'YIELD_PRODUCTION'),
    ('GREATPERSON_INDUSTRY_PRODUCTION_SCIENCE',         'YieldTypeToGrant',     'YIELD_SCIENCE'),
    ('GREATPERSON_NATIONAL_APPEAL',                     'Amount',               1),
    ('GREATPERSON_SINGLECITY_APPEAL',                   'Amount',               2),
    ('GREATPERSON_SINGLECITY_IMPROVEMENT_TOURISM',      'Amount',               100),
    ('GREATPERSON_SINGLECITY_NATIONAL_PARK_TOURISM',    'Amount',               100),
    ('GREATPERSON_SINGLECITY_WONDER_TOURISM',           'BoostsWonders',        1),
    ('GREATPERSON_SINGLECITY_WONDER_TOURISM',           'ScalingFactor',        200),
    ('GREATPERSON_NATIONAL_APPEAL_BIG',                 'Amount',               2),
    ('GREATPERSON_GRANT_PRODUCTION_IN_CITY_MODERN',     'Amount',               680),
    ('GREATPERSON_GRANT_PRODUCTION_IN_CITY_MODERN',     'KeepOverflow',         0),
    ('GREATPERSON_ELECTRICITY',                         'ModifierId',           'GREATPERSON_ELECTRICITY_MODIFIER'),
    ('GREATPERSON_ELECTRICITY_MODIFIER',                'Amount',               3),
    ('GREATPERSON_ELECTRICITY_MODIFIER',                'SourceType',           'FREE_POWER_SOURCE_MISC'),
    ('GREATPERSON_ELECTRICITY_ADD_PRODUCTION',          'YieldType',            'YIELD_PRODUCTION'),
    ('GREATPERSON_ELECTRICITY_ADD_PRODUCTION',          'Amount',               5);

update Modifiers set ModifierType = 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_AMENITIES_FROM_GREAT_PEOPLE' where ModifierId = 'GREATPERSON_CITY_AMENITIES_LARGE';
update Modifiers set ModifierType = 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_HOUSING_FROM_GREAT_PEOPLE' where ModifierId = 'GREATPERSON_CITY_HOUSING_LARGE';

delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JAMES_WATT' and ModifierId = 'GREATPERSON_FACTORIES_PRODUCTION';
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,					ModifierId,											AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_JAMES_WATT',		'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = (select Tier from HD_BuildingTiers where BuildingType = 'BUILDING_FACTORY');
insert or replace into Modifiers
	(ModifierId,										ModifierType)
select
	'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = (select Tier from HD_BuildingTiers where BuildingType = 'BUILDING_FACTORY');
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'BuildingType',		BuildingType
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = (select Tier from HD_BuildingTiers where BuildingType = 'BUILDING_FACTORY');
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'Amount',			3
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = (select Tier from HD_BuildingTiers where BuildingType = 'BUILDING_FACTORY');
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'HD_GREATPERSON_'|| BuildingType ||'_PRODUCTION',	'YieldType',		'YIELD_PRODUCTION'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_INDUSTRIAL_ZONE' and Tier = (select Tier from HD_BuildingTiers where BuildingType = 'BUILDING_FACTORY');

insert or replace into ModifierStrings
	(ModifierId,												Context,	Text)
values
	('GREATPERSON_REGIONAL_RANGE_BONUS',						'Summary',	'LOC_GREATPERSON_REGIONAL_RANGE_BONUS');
------------------------------------------------------------------------------------------------------------------------------
--- Great Scientist
-------------------------------------------------------------------------------------------------------------------------------
-- EUCLID +1 district capacity finish mathmatics if boosted
-- Darwin : +1000 science for each natural wonder tiles
-- galieo : +400 science for each ajacent mountain tiles
-- HILDEGARD_OF_BINGEN ： +200 faith when activate
-- ABU_AL_QASIM_AL_ZAHRAWI : sanitation boost or give full tech
-- issac_newton : university +1 sicence
-- ALFRED_NOBEL：+25%GPP acumulate speed
-- ALBERT_EINSTEIN: 2 boost
-- ALAN_TURING: finish computer if boosted; boost +era
-- DMITRI_MENDELEEV: finish chemistry if boosted; boost +era
-- JAMES_YOUNG: finish refining if boosted; boost plastic

update ModifierArguments set Value = 400 where ModifierId = 'GREATPERSON_ADJACENT_SNOWMOUNTAIN_SCIENCE' and Name = 'Amount';
update ModifierArguments set Value = 400 where ModifierId = 'GREATPERSON_ADJACENT_TUNDRAMOUNTAIN_SCIENCE' and Name = 'Amount';
update ModifierArguments set Value = 400 where ModifierId = 'GREATPERSON_ADJACENT_DESERTMOUNTAIN_SCIENCE' and Name = 'Amount';
update ModifierArguments set Value = 400 where ModifierId = 'GREATPERSON_ADJACENT_PLAINSMOUNTAIN_SCIENCE' and Name = 'Amount';
update ModifierArguments set Value = 400 where ModifierId = 'GREATPERSON_ADJACENT_GRASSMOUNTAIN_SCIENCE' and Name = 'Amount';
update ModifierArguments set Value = 1000 where ModifierId = 'GREATPERSON_ADJACENT_NATURALWONDER_SCIENCE' and Name = 'Amount';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_1MEDIEVALRENAISSANCETECHBOOST';
update ModifierArguments set Value = 200 where ModifierId = 'GREATPERSON_FAITH' and	Name = 'Amount';
update ModifierArguments set Value = 2 where ModifierId = 'GREATPERSON_LIBRARIES_SCIENCE' and Name = 'Amount';
update ModifierArguments set Value = 4 where ModifierId = 'GREATPERSON_UNIVERSITIES_SMALL_SCIENCE' and Name = 'Amount';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_MATHTECHBOOST' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_EUCLID';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_2INDUSTRIALMODERNTECHBOOSTS';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_1INDUSTRIALTECHBOOST';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_COMPUTERSTECHBOOST' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ALAN_TURING';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_1MODERNTECHBOOST' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ALAN_TURING';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_CHEMISTRYTECHBOOST';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_1MODERNATOMICTECHBOOST' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ALBERT_EINSTEIN';

insert or replace into GreatPersonIndividualActionModifiers 
	(GreatPersonIndividualType,							ModifierId,												AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_EUCLID',					'GREATPERSON_EXTRA_DISTRICT_CAPACITY',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_ARYABHATA',				'GREAT_PERSON_INDIVIDUAL_ARYABHATA_CAMPUS_AMENITY',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');

insert or replace into GreatPersonIndividualActionModifiers 
	(GreatPersonIndividualType,							ModifierId)
values
	('GREAT_PERSON_INDIVIDUAL_EUCLID',					'GREAT_PERSON_HD_BOOST_OR_GRANT_MATHEMATICS'),
	('GREAT_PERSON_INDIVIDUAL_ALBERT_EINSTEIN',			'GREATPERSON_2MODERNATOMICTECHBOOST'),
	('GREAT_PERSON_INDIVIDUAL_ALAN_TURING',				'GREATPERSON_1MODERNATOMICTECHBOOST'),
	('GREAT_PERSON_INDIVIDUAL_ALAN_TURING',				'GREAT_PERSON_HD_BOOST_OR_GRANT_COMPUTERS'),
	-- ('GREAT_PERSON_INDIVIDUAL_DMITRI_MENDELEEV',		'GREATPERSON_1INDUSTRIALMODERNTECHBOOSTS'),
	('GREAT_PERSON_INDIVIDUAL_DMITRI_MENDELEEV',		'GREAT_PERSON_HD_BOOST_OR_GRANT_CHEMISTRY'),
	('GREAT_PERSON_INDIVIDUAL_DMITRI_MENDELEEV',		'GREATPERSON_REVEAL_ALUMINUM'),
	('GREAT_PERSON_INDIVIDUAL_JAMES_YOUNG',				'GREAT_PERSON_HD_BOOST_OR_GRANT_REFINING'),
	('GREAT_PERSON_INDIVIDUAL_JAMES_YOUNG',				'GREAT_PERSON_PLASTICS_TECHBOOST'),
	('GREAT_PERSON_INDIVIDUAL_ABU_AL_QASIM_AL_ZAHRAWI', 'GREAT_PERSON_HD_BOOST_OR_GRANT_SANITATION');

insert or replace into Modifiers
	(ModifierId,											ModifierType,											Runonce,	Permanent)
values
	('GREAT_PERSON_INDIVIDUAL_ARYABHATA_CAMPUS_AMENITY',	'MODIFIER_ADJUST_AMENITIES_IN_DISTRICT',				1,	1),
	('GREATPERSON_2MODERNATOMICTECHBOOST',					'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_BY_ERA', 1,	1),
	-- ('GREATPERSON_1INDUSTRIALMODERNTECHBOOSTS',				'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_BY_ERA', 1,	1),
	('GREATPERSON_REVEAL_ALUMINUM',							'MODIFIER_PLAYER_GRANT_FREE_RESOURCE_VISIBILITY',		1,	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_MATHEMATICS',			'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',			1,	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_COMPUTERS',			'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',			1,	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_CHEMISTRY',			'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',			1,	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_REFINING',				'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',			1,	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_SANITATION',			'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',			1,	1),
	('GREAT_PERSON_PLASTICS_TECHBOOST',						'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',			1,	1);

insert or replace into GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId)
select 'GREAT_PERSON_INDIVIDUAL_ALFRED_NOBEL', 'GREAT_PERSON_ADD_' || GreatPersonClassType from GreatPersonClasses
where not (GreatPersonClassType = 'GREAT_PERSON_CLASS_COMANDANTE_GENERAL');
insert or replace into Modifiers	(ModifierId,ModifierType, Runonce, Permanent)
select	'GREAT_PERSON_ADD_' || GreatPersonClassType , 'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',1,1 from GreatPersonClasses;
insert or replace into ModifierArguments (ModifierId,	Name,	Value)
select	'GREAT_PERSON_ADD_' || GreatPersonClassType ,	'GreatPersonClassType',	GreatPersonClassType from GreatPersonClasses;
insert or replace into ModifierArguments (ModifierId,	Name,	Value)
select	'GREAT_PERSON_ADD_' || GreatPersonClassType ,	'Amount', 25 from GreatPersonClasses;

insert or replace into ModifierArguments
	(ModifierId,												Name,					Value)
values
	('GREAT_PERSON_INDIVIDUAL_ARYABHATA_CAMPUS_AMENITY',		'Amount',				2),
	('GREATPERSON_2MODERNATOMICTECHBOOST',						'Amount',				2),
	('GREATPERSON_2MODERNATOMICTECHBOOST',						'EndEraType',			'ERA_ATOMIC'),
	('GREATPERSON_2MODERNATOMICTECHBOOST',						'StartEraType',			'ERA_MODERN'),
	-- ('GREATPERSON_1INDUSTRIALMODERNTECHBOOSTS',					'Amount',				1),
	-- ('GREATPERSON_1INDUSTRIALMODERNTECHBOOSTS',					'EndEraType',			'ERA_MODERN'),
	-- ('GREATPERSON_1INDUSTRIALMODERNTECHBOOSTS',					'StartEraType',			'ERA_INDUSTRIAL'),
	('GREATPERSON_REVEAL_ALUMINUM',								'ResourceType',			'RESOURCE_ALUMINUM'),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_MATHEMATICS',				'TechType',				'TECH_MATHEMATICS'),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_MATHEMATICS',				'GrantTechIfBoosted',	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_COMPUTERS',				'TechType',				'TECH_COMPUTERS'),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_COMPUTERS',				'GrantTechIfBoosted',	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_CHEMISTRY',				'TechType',				'TECH_CHEMISTRY'),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_CHEMISTRY',				'GrantTechIfBoosted',	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_REFINING',					'TechType',				'TECH_REFINING'),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_REFINING',					'GrantTechIfBoosted',	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_SANITATION',				'TechType',				'TECH_SANITATION'),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_SANITATION',				'GrantTechIfBoosted',	1),
	('GREAT_PERSON_PLASTICS_TECHBOOST',							'TechType',				'TECH_PLASTICS');

--GREAT_PERSON_INDIVIDUAL_JANAKI_AMMAL
update ModifierArguments set Value = 800 where ModifierId = 'GREATPERSON_ADJACENT_RAINFOREST_SCIENCE' and Name = 'Amount';

--GREAT_PERSON_INDIVIDUAL_MARY_LEAKEY
update GreatPersonIndividuals set ActionRequiresCityGreatWorkObjectType = 'GREATWORKOBJECT_WRITING', ActionRequiresCompletedDistrictType = 'DISTRICT_CITY_CENTER' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARY_LEAKEY'; 
update ModifierArguments set Value = 450 where ModifierId = 'GREATPERSON_ARTIFACT_SCIENCE' and Name = 'Amount';
update ModifierArguments set Value = 'GREATWORKOBJECT_WRITING' where ModifierId = 'GREATPERSON_ARTIFACT_SCIENCE' and Name = 'GreatWorkObjectType';
update ModifierArguments set Value = 'GREATWORKOBJECT_WRITING' where ModifierId = 'GREATPERSON_ARTIFACT_TOURISM_MODIFIER' and Name = 'GreatWorkObjectType';
update GreatPersonIndividualActionModifiers set AttachmentTargetType = 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARY_LEAKEY';

--GREAT_PERSON_INDIVIDUAL_MARGARET_MEAD
update ModifierArguments set Value = 3000 where ModifierId = 'GREAT_PERSON_GRANT_LOTSO_SCIENCE' and Name = 'Amount';

--GREAT_PERSON_INDIVIDUAL_ABDUS_SALAM
update ModifierArguments set Value = 'ERA_FUTURE' where ModifierId = 'GREATPERSON_ALLINFORMATIONTECHBOOSTS' and Name = 'EndEraType';

-- insert or replace into GreatWorks
--	(GreatWorkType, GreatWorkObjectType, GreatPersonIndividualType, Name, Audio, Image, Quote, Tourism, Eratype)
-- values
--	('GREATWORK_NEWTON',	'GREATWORKOBJECT_WRITING',	'GREAT_PERSON_INDIVIDUAL_ISAAC_NEWTON', 'LOC_GREATWORK_NEWTON_NAME',	NULL,
--		NULL, 'LOC_GREATWORK_NEWTON_QUOTE', 3,	'ERA_RENAISSANCE');

-- insert or replace into GreatWorkModifiers (GreatWorkType, ModifierId)
-- values ('GREATWORK_NEWTON','PRODUCT_SCIENCE_YIELD_BONUS_TURTLES');

-- todo: add a button for Newton
-- and see if he is 30% sicence boost

------------------------------------------------------------------------------------------------------------------------------
--- Great Merchants
-------------------------------------------------------------------------------------------------------------------------------
-- Colaeus
update GreatPersonIndividuals set ActionRequiresOwnedTile = 1, ActionRequiresVisibleLuxury = 0, ActionRequiresCompletedDistrictType = 'DISTRICT_COMMERCIAL_HUB'
	where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_COLAEUS';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_COLAEUS';
-- Marcus Licinius Crassus
update GreatPersonIndividuals set ActionCharges = 2, ActionRequiresUnownedTile = 0, ActionRequiresOwnedTile = 0, ActionRequiresAdjacentOwnedTile = 0, ActionRequiresCompletedDistrictType = null, ActionRequiresNoMilitaryUnit = 1, ActionEffectTileHighlighting = 0
	where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARCUS_LICINIUS_CRASSUS';
update ModifierArguments set Value = 100 where ModifierId = 'GREATPERSON_GOLD_TINY' and Name = 'Amount';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARCUS_LICINIUS_CRASSUS' and ModifierId = 'GREATPERSON_GRANT_PLOT';
-- Zhang Qian
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ZHANG_QIAN' and (ModifierId = 'GREATPERSON_GOLD_FROM_INCOMING_FOREIGN_ROUTES' or ModifierId = 'GREATPERSON_GOLD_TO_INCOMING_FOREIGN_ROUTES');
-- Marco Polo
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARCO_POLO' and (ModifierId = 'GREATPERSON_GOLD_TO_INCOMING_FOREIGN_ROUTES' or ModifierId = 'GREATPERSON_GOLD_TO_INCOMING_FOREIGN_ROUTES');
-- Piero de' Bardi
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI';
-- Ibn Fadlan
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_IBN_FADLAN' and ModifierId = 'GREATPERSON_CITY_STATE_TRADE_FAITH';
-- Giovanni de' Medici
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,												AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_GIOVANNI_DE_MEDICI',	'GIOVANNI_DE_MEDICI_' || BuildingType || '_DISCOUNT',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_THEATER';
insert or replace into Modifiers
	(ModifierId,											ModifierType)
select
	'GIOVANNI_DE_MEDICI_' || BuildingType || '_DISCOUNT',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PURCHASE_COST'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_THEATER';
insert or replace into ModifierArguments
	(ModifierId,											Name,				Value)
select
	'GIOVANNI_DE_MEDICI_' || BuildingType || '_DISCOUNT',	'BuildingType',		BuildingType
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_THEATER';
insert or replace into ModifierArguments
	(ModifierId,											Name,				Value)
select
	'GIOVANNI_DE_MEDICI_' || BuildingType || '_DISCOUNT',	'Amount',			25
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_THEATER';
-- Jakob Fugger
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_GOLD_SMALL' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER';
-- Raja Todar Mal
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_INFLUENCE_TOKENS_SMALL' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_RAJA_TODAR_MAL';
update ModifierArguments set Value = 2 where ModifierId = 'GREATPERSON_DOMESTIC_ROUTE_GOLD_PER_SPECIALTY_DISTRICT' and Name = 'Amount';
-- Zhou Daguan
update GreatPersonIndividuals set ActionRequiresCityStateTerritory = 0, ActionRequiresNonHostileTerritory = 0, ActionRequiresCompletedDistrictType = 'DISTRICT_COMMERCIAL_HUB' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ZHOU_DAGUAN';
delete from GreatPersonIndividualBirthModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ZHOU_DAGUAN';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ZHOU_DAGUAN';
-- John Jacob Astor
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR';
-- Adam Smith
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ADAM_SMITH' and (ModifierId = 'GREATPERSON_GOVERNOR_POINTS' or ModifierId = 'GREATPERSON_GOLD_LARGE');
-- Melitta Bentz
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MELITTA_BENTZ' and ModifierId = 'GREATPERSON_EXTRA_TRADE_ROUTE_CAPACITY';
-- Modifiers
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,							ModifierId,									AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_HD_CROESUS',				'GREATPERSON_GRANT_FAIR',							'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_GIOVANNI_DE_MEDICI',				'GREATPERSON_GRANT_FAIR',							'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	
	('GREAT_PERSON_INDIVIDUAL_COLAEUS',					'COLAEUS_SETTLER_PRODUCTION',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_COLAEUS',					'COLAEUS_SETTLER_MOVEMENT',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_MARCUS_LICINIUS_CRASSUS',	'MARCUS_LICINIUS_CRASSUS_SWORDSMAN',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON'),
	('GREAT_PERSON_INDIVIDUAL_MARCUS_LICINIUS_CRASSUS',	'MARCUS_LICINIUS_CRASSUS_IRON',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_ZHANG_QIAN',				'ZHANG_QIAN_GRANT_TRADER',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_HD_CROESUS',				'CROESUS_MARKET',							'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_MARCO_POLO',				'MARCO_POLO_DO_NOTHING',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI',			'GREATPERSON_INFLUENCE_TOKENS_MEDIUM',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI',			'JAKOB_FUGGER_GOLD',						'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_HD_ALI_MUGHAYAT_SYAH',	'ALI_MUGHAYAT_SYAH_SETTLER',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_HD_ALI_MUGHAYAT_SYAH',	'ALI_MUGHAYAT_SYAH_BUILDER',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER',			'JAKOB_FUGGER_GOLD',						'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER',			'JAKOB_FUGGER_COMMERCIAL_ADJACENCY',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_RAJA_TODAR_MAL',			'GREATPERSON_INFLUENCE_TOKENS_MEDIUM',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR',		'JOHN_JACOB_ASTOR_INDUSTRIAL_ADJACENCY',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR',		'JOHN_JACOB_ASTOR_GOLD',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR',		'GREATPERSON_INFLUENCE_TOKENS_LARGE',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_ADAM_SMITH',				'GREATPERSON_ECONOMIC_POLICY_SLOT',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_MARY_KATHERINE_GODDARD',	'MARY_KATHERINE_DEFENSE',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_MELITTA_BENTZ',			'GREATPERSON_EXTRA_TRADE_ROUTE_CAPACITY2',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');
-- With conditions
with GreatPersonIndividualActionModifiers_Pre
	(GreatPersonIndividualType,							ModifierId,									AttachmentTargetType)
as (values
	('GREAT_PERSON_INDIVIDUAL_IBN_FADLAN',				'GREATPERSON_INFLUENCE_TOKENS_MEDIUM',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_ZHOU_DAGUAN',				'ZHOU_DAGUAN_COMMERCIAL_ATTACH',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_HD_SANG_HONGYANG',		'GREATPERSON_GRANT_FAIR',						'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_HD_SANG_HONGYANG',		'SANG_HONGYANG_MINT',						'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_HD_SANG_HONGYANG',		'SANG_HONGYANG_ADD_COMMERCIAL_HUB_REGIONAL_RANGE',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_HD_SANG_HONGYANG',		'SANG_HONGYANG_ADD_COMMERCIAL_HUB_REGIONAL_CULTURE',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'))
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,							ModifierId,									AttachmentTargetType)
select
	GreatPersonIndividualType,							ModifierId,									AttachmentTargetType
from GreatPersonIndividualActionModifiers_Pre where GreatPersonIndividualType in (select GreatPersonIndividualType from GreatPersonIndividuals);

insert or replace into Modifiers
	(ModifierId,								ModifierType,														RunOnce,	Permanent,	SubjectRequirementSetId)
values
	('GREATPERSON_GRANT_FAIR',							'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',				1,			1,			null),
	('COLAEUS_SETTLER_PRODUCTION',				'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION',						0,			1,			null),
	('COLAEUS_SETTLER_MOVEMENT',				'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT',							0,			1,			'UNIT_IS_UNIT_SETTLER_REQUIREMENTS'),
	('MARCUS_LICINIUS_CRASSUS_SWORDSMAN',		'MODIFIER_PLAYER_UNIT_GRANT_UNIT_WITH_EXPERIENCE',					1,			1,			null),
	('MARCUS_LICINIUS_CRASSUS_IRON',			'MODIFIER_CAPITAL_CITY_ADJUST_FREE_RESOURCE_EXTRACTION',			0,			1,			null),
	('ZHANG_QIAN_GRANT_TRADER',					'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',							1,			1,			null),
	('CROESUS_MARKET',							'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',				1,			1,			null),
	('SANG_HONGYANG_MINT',						'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',				1,			1,			null),
	('SANG_HONGYANG_ADD_COMMERCIAL_HUB_REGIONAL_RANGE',					'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',					0,			1,			null),
	('SANG_HONGYANG_ADD_COMMERCIAL_HUB_REGIONAL_CULTURE',					'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY',					0,			1,			null),

	('MARCO_POLO_DO_NOTHING',					'MODIFIER_DO_NOTHING',												0,			0,			null),
	('ZHOU_DAGUAN_COMMERCIAL_ATTACH',			'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',						0,			1,			'DISTRICT_IS_DISTRICT_COMMERCIAL_HUB_REQUIREMENTS'),
	('ALI_MUGHAYAT_SYAH_SETTLER',				'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',							1,			1,			null),
	('ALI_MUGHAYAT_SYAH_BUILDER',				'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',							1,			1,			null),
	('JAKOB_FUGGER_GOLD',						'MODIFIER_PLAYER_GRANT_YIELD',										1,			1,			null),
	('JAKOB_FUGGER_COMMERCIAL_ADJACENCY',		'MODIFIER_PLAYER_CITIES_DISTRICT_ADJACENCY',						0,			1,			null),
	('JOHN_JACOB_ASTOR_INDUSTRIAL_ADJACENCY',	'MODIFIER_PLAYER_CITIES_DISTRICT_ADJACENCY',						0,			1,			null),
	('JOHN_JACOB_ASTOR_GOLD',					'MODIFIER_PLAYER_GRANT_YIELD',										1,			1,			null),
	('GREATPERSON_INFLUENCE_TOKENS_LARGE',		'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN',							1,			1,			null),
	('MARY_KATHERINE_DEFENSE',					'MODIFIER_PLAYER_ADJUST_SPY_BONUS',									1,			1,			null),
	('GREATPERSON_EXTRA_TRADE_ROUTE_CAPACITY2', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',						1,			1,			null);

with ModifierArguments_Pre
	(ModifierId,								Name,				Value)
as (values
	('SANG_HONGYANG_MINT',						'BuildingType',		'BUILDING_JNR_MINT'),
	('SANG_HONGYANG_ADD_COMMERCIAL_HUB_REGIONAL_RANGE',					'Key',		'HD_SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_DISTRICT_COMMERCIAL_HUB'),
	('SANG_HONGYANG_ADD_COMMERCIAL_HUB_REGIONAL_RANGE',					'Amount',			1),
	('SANG_HONGYANG_ADD_COMMERCIAL_HUB_REGIONAL_CULTURE',					'Key',		'HD_SINGLE_BUILDING_PROVIDE_REGIONAL_YIELD_BONUS_BUILDING_JNR_MINT_YIELD_CULTURE'),
	('SANG_HONGYANG_ADD_COMMERCIAL_HUB_REGIONAL_CULTURE',					'Amount',			1))
insert or replace into ModifierArguments
	(ModifierId,								Name,				Value)
select
	ModifierId,									Name,				Value
from ModifierArguments_Pre where ModifierId in (select ModifierId from Modifiers);
	
insert or replace into ModifierArguments
	(ModifierId,								Name,				Type,					Value)
values
	('JAKOB_FUGGER_GOLD',						'Amount',			'ScaleByGameSpeed',		400),
	('JOHN_JACOB_ASTOR_GOLD',					'Amount',			'ScaleByGameSpeed',		600);
insert or replace into ModifierArguments
	(ModifierId,								Name,				Value)
values
	('GREATPERSON_GRANT_FAIR',							'BuildingType',		'BUILDING_FAIR'),
	('COLAEUS_SETTLER_PRODUCTION',				'Amount',			25),
	('COLAEUS_SETTLER_PRODUCTION',				'UnitType',			'UNIT_SETTLER'),
	('COLAEUS_SETTLER_MOVEMENT',				'Amount',			1),
	('MARCUS_LICINIUS_CRASSUS_SWORDSMAN',		'UnitType',			'UNIT_SWORDSMAN'),
	('MARCUS_LICINIUS_CRASSUS_SWORDSMAN',		'Experience',		0),
	('MARCUS_LICINIUS_CRASSUS_SWORDSMAN',		'UniqueOverride',	1),
	('MARCUS_LICINIUS_CRASSUS_IRON',			'ResourceType',		'RESOURCE_IRON'),
	('MARCUS_LICINIUS_CRASSUS_IRON',			'Amount',			1),
	('ZHANG_QIAN_GRANT_TRADER',					'UnitType',			'UNIT_TRADER'),
	('ZHANG_QIAN_GRANT_TRADER',					'Amount',			1),
	('CROESUS_MARKET',							'BuildingType',		'BUILDING_MARKET'),
	('ZHOU_DAGUAN_COMMERCIAL_ATTACH',			'ModifierId',		'GREATPERSON_INFLUENCE_TOKENS_SMALL'),
	('ALI_MUGHAYAT_SYAH_SETTLER',				'UnitType',			'UNIT_SETTLER'),
	('ALI_MUGHAYAT_SYAH_SETTLER',				'Amount',			1),
	('ALI_MUGHAYAT_SYAH_BUILDER',				'UnitType',			'UNIT_BUILDER'),
	('ALI_MUGHAYAT_SYAH_BUILDER',				'Amount',			1),
	('JAKOB_FUGGER_GOLD',						'YieldType',		'YIELD_GOLD'),
	('JAKOB_FUGGER_COMMERCIAL_ADJACENCY',		'DistrictType',		'DISTRICT_COMMERCIAL_HUB'),
	('JAKOB_FUGGER_COMMERCIAL_ADJACENCY',		'YieldType',		'YIELD_GOLD'),
	('JAKOB_FUGGER_COMMERCIAL_ADJACENCY',		'Amount',			1),
	('JAKOB_FUGGER_COMMERCIAL_ADJACENCY',		'Description',		'LOC_DISTRICT_DISTRICT_1_GOLD'),
	('JOHN_JACOB_ASTOR_INDUSTRIAL_ADJACENCY',	'DistrictType',		'DISTRICT_INDUSTRIAL_ZONE'),
	('JOHN_JACOB_ASTOR_INDUSTRIAL_ADJACENCY',	'YieldType',		'YIELD_PRODUCTION'),
	('JOHN_JACOB_ASTOR_INDUSTRIAL_ADJACENCY',	'Amount',			1),
	('JOHN_JACOB_ASTOR_INDUSTRIAL_ADJACENCY',	'Description',		'LOC_DISTRICT_DISTRICT_1_PRODUCTION'),
	('JOHN_JACOB_ASTOR_GOLD',					'YieldType',		'YIELD_GOLD'),
	('GREATPERSON_INFLUENCE_TOKENS_LARGE',		'Amount',			2),
	('MARY_KATHERINE_DEFENSE',					'Amount',			1),
	('MARY_KATHERINE_DEFENSE',					'Offense',			0),
	('GREATPERSON_EXTRA_TRADE_ROUTE_CAPACITY2', 'Amount',			2);
-- Text
update GreatPersonIndividuals set ActionEffectTextOverride = null where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ZHANG_QIAN' or GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARCO_POLO';
update GreatPersonIndividuals set ActionEffectTextOverride = 'LOC_GREAT_PERSON_INDIVIDUAL_HD_CROESUS_ACTIVE' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HD_CROESUS';
update GreatPersonIndividuals set ActionEffectTextOverride = 'LOC_GREAT_PERSON_INDIVIDUAL_HD_SANG_HONGYANG_ACTIVE' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HD_SANG_HONGYANG';
update GreatPersonIndividuals set ActionEffectTextOverride = 'LOC_GREATPERSON_GIOVANNI_DE_MEDICI_ACTIVE_HD' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_GIOVANNI_DE_MEDICI';
insert or replace into ModifierStrings
	(ModifierId,								Context,		Text)
values
	('COLAEUS_SETTLER_PRODUCTION',				'Summary',		'LOC_COLAEUS_SETTLER_PRODUCTION'),
	('COLAEUS_SETTLER_MOVEMENT',				'Summary',		'LOC_COLAEUS_SETTLER_MOVEMENT'),
	('MARCUS_LICINIUS_CRASSUS_SWORDSMAN',		'Summary',		'LOC_MARCUS_LICINIUS_CRASSUS_SWORDSMAN'),
	('MARCUS_LICINIUS_CRASSUS_IRON',			'Summary',		'LOC_MARCUS_LICINIUS_CRASSUS_IRON'),
	('ZHANG_QIAN_GRANT_TRADER',					'Summary',		'LOC_ZHANG_QIAN_GRANT_TRADER'),
	('GREATPERSON_FREE_TRADER_UNIT',			'Summary',		'LOC_GREATPERSON_FREE_TRADER_UNIT'),
	('MARCO_POLO_DO_NOTHING',					'Summary',		'LOC_MARCO_POLO_NOTHING'),
	('ZHOU_DAGUAN_COMMERCIAL_ATTACH',			'Summary',		'LOC_ZHOU_DAGUAN_COMMERCIAL_ATTACH'),
	('ALI_MUGHAYAT_SYAH_SETTLER',				'Summary',		'LOC_ALI_MUGHAYAT_SYAH_SETTLER'),
	('ALI_MUGHAYAT_SYAH_BUILDER',				'Summary',		'LOC_ALI_MUGHAYAT_SYAH_BUILDER'),
	('JAKOB_FUGGER_GOLD',						'Summary',		'LOC_JAKOB_FUGGER_GOLD'),
	('JAKOB_FUGGER_COMMERCIAL_ADJACENCY',		'Summary',		'LOC_JAKOB_FUGGER_COMMERCIAL_ADJACENCY'),
	('JOHN_JACOB_ASTOR_INDUSTRIAL_ADJACENCY',	'Summary',		'LOC_JOHN_JACOB_ASTOR_INDUSTRIAL_ADJACENCY'),
	('JOHN_JACOB_ASTOR_GOLD',					'Summary',		'LOC_JOHN_JACOB_ASTOR_GOLD'),
	('GREATPERSON_INFLUENCE_TOKENS_LARGE',		'Summary',		'LOC_GREATPERSON_INFLUENCE_TOKENS_LARGE'),
	('GREATPERSON_EXTRA_TRADE_ROUTE_CAPACITY2',	'Summary',		'LOC_GREATPERSON_EXTRA_TRADE_ROUTE_CAPACITY2');

--克罗索斯
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,							ModifierId,									AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_HD_CROESUS',				'CROESUS_' || BuildingType || '_GOLD',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 2 and ReplacesOther = 0;
insert or replace into Modifiers
	(ModifierId,										ModifierType)
select
	'CROESUS_' || BuildingType || '_GOLD',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 2 and ReplacesOther = 0;
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'CROESUS_' || BuildingType || '_GOLD',				'BuildingType',		BuildingType
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 2 and ReplacesOther = 0;
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'CROESUS_' || BuildingType || '_GOLD',				'YieldType',		'YIELD_GOLD'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 2 and ReplacesOther = 0;
insert or replace into ModifierArguments
	(ModifierId,										Name,				Value)
select
	'CROESUS_' || BuildingType || '_GOLD',				'Amount',			3
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 2 and ReplacesOther = 0;

-- Jamsetji Tata and Masaru Ibuka
update ModifierArguments set Value = 100 where ModifierId in ('GREATPERSON_CAMPUS_TOURISM', 'GREATPERSON_INDUSTRIAL_ZONE_TOURISM') and Name = 'Amount';

------------------------------------------------------------
-- great admiral
------------------------------------------------------------
-- GREAT_PERSON_INDIVIDUAL_ARTEMISIA grants a lighthouse and lighthouses +1 food
-- GREAT_PERSON_INDIVIDUAL_THEMISTOCLES grants an extra district capacity and an envoy
-- GREAT_PERSON_INDIVIDUAL_LEIF_ERIKSON grants a settler
-- GREAT_PERSON_INDIVIDUAL_HIMERIOS +1 charge
-- GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE naval raider units +2 combat strength
-- GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN grants a settler instead of luxulry resource
-- GREAT_PERSON_INDIVIDUAL_CHING_SHIH plunder bonus +100%
-- GREAT_PERSON_INDIVIDUAL_HORATIO_NELSON shipyards +2 production
-- GREAT_PERSON_INDIVIDUAL_LASKARINA_BOUBOULINA +2 charges
-- GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA grants a lighthouse, a shipyard, a seaport and all seaports +1 housing
-- GREAT_PERSON_INDIVIDUAL_SERGEY_GORSHKOV +1 charge
-- GREAT_PERSON_INDIVIDUAL_CLANCY_FERNANDO +1 amenity for all harbors and -25% war weariness
-- GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO +1 Movement for all naval units
-- GREAT_PERSON_INDIVIDUAL_CHESTER_NIMITZ grants an aircraft carrier with free promotion

update GreatPersonIndividuals set ActionRequiresOwnedTile = 1, ActionRequiresMilitaryUnitDomain = NULL, ActionRequiresCompletedDistrictType = 'DISTRICT_HARBOR', ActionEffectTileHighlighting = 1, ActionRequiresUnitCanGainExperience = 0
where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ARTEMISIA';
update GreatPersonIndividuals set ActionRequiresOwnedTile = 1, ActionRequiresNoMilitaryUnit = 0, ActionRequiresCompletedDistrictType = 'DISTRICT_HARBOR', ActionEffectTileHighlighting = 1
where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_THEMISTOCLES';
update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HIMERIOS';
update GreatPersonIndividuals set ActionRequiresVisibleLuxury = 0, ActionEffectTileHighlighting = 0 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN';
update ModifierArguments set Value = 100 where ModifierId = 'CHING_SHIH_PLUNDER_BONUS' and Name = 'Amount';
update GreatPersonIndividuals set ActionCharges = 3 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_LASKARINA_BOUBOULINA';
update GreatPersonIndividuals set ActionRequiresOwnedTile = 1, ActionRequiresCompletedDistrictType = 'DISTRICT_HARBOR', ActionEffectTileHighlighting = 1 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA';
update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_SERGEY_GORSHKOV';
update GreatPersonIndividuals set ActionRequiresOwnedTile = 1, ActionRequiresMilitaryUnitDomain = NULL, ActionRequiresCompletedDistrictType = 'DISTRICT_HARBOR', ActionEffectTileHighlighting = 1 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_CLANCY_FERNANDO';
update GreatPersonIndividuals set ActionRequiresOwnedTile = 0, ActionRequiresCompletedDistrictType = NULL, ActionEffectTileHighlighting = 0 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO';
update ModifierArguments set Value = 'UNIT_AIRCRAFT_CARRIER' where ModifierId = 'GREATPERSON_CHESTER_NIMITZ_UNIT_PROMOTION' and Name = 'UnitType';

delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_ARTEMISIA_ACTIVE' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ARTEMISIA';
delete from GreatPersonIndividualActionModifiers where (ModifierId = 'GREATPERSON_THEMISTOCLES_ACTIVE' or ModifierId = 'GREATPERSON_THEMISTOCLES_NAVAL_RANGED') and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_THEMISTOCLES';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_FERDINAND_MAGELLAN_GRANT_PLOT_RESOURCE' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_JOAQUIM_MARQUES_LISBOA_ACTIVE' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA';
delete from GreatPersonIndividualActionModifiers where (ModifierId = 'GREATPERSON_CLANCY_FERNANDO_ACTIVE' or ModifierId = 'GREATPERSON_CLANCY_FERNANDO_ACTIVE_UNIT_BONUS') and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_CLANCY_FERNANDO';
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_TOGO_HEIHACHIRO_ACTIVE' and GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO';

--update ModifierArguments set Value = 'TERRAIN_OCEAN,TERRAIN_COAST' where ModifierId = 'GREATPERSON_LEIF_ERIKSON_ACTIVE' and Name = 'TerrainType';
update RequirementSets set RequirementSetType = 'REQUIREMENTSET_TEST_ANY' where RequirementSetId = 'GREATPERSON_LEIF_ERIKSON_ACTIVE_REQUIREMENTS';
insert or ignore into RequirementSetRequirements	(RequirementSetId,	RequirementId)	
values	('GREATPERSON_LEIF_ERIKSON_ACTIVE_REQUIREMENTS', 'REQUIREMENT_UNIT_IS_SETTLER');

insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,							ModifierId,												AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_ARTEMISIA',				'ARTEMISIA_LIGHTHOUSE',									'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_ARTEMISIA',				'ARTEMISIA_LIGHTHOUSE_FOOD',							'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_THEMISTOCLES',			'GREATPERSON_EXTRA_DISTRICT_CAPACITY',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_THEMISTOCLES',			'GREATPERSON_INFLUENCE_TOKENS_SMALL',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_LEIF_ERIKSON',			'GREATPERSON_GRANT_A_SETTLER',							'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON'),
	('GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE',			'GREATPERSON_NAVLA_RAIDER_BONUS',						'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN',		'GREATPERSON_GRANT_A_SETTLER',							'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON'),
	('GREAT_PERSON_INDIVIDUAL_HORATIO_NELSON',			'HORATIO_NELSON_SHIPYARD_PRODUCTION',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_LEIF_ERIKSON',			'GREATPERSON_SETTLER_EMBARK',							'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA',	'GREATPERSON_HORATIO_NELSON_LIGHTHOUSE',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA',	'GREATPERSON_HORATIO_NELSON_SHIPYARD',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA',	'GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA',	'GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT_HOUSING',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_CLANCY_FERNANDO',			'GREATPERSON_JOAQUIM_MARQUES_LISBOA_ACTIVE',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_CLANCY_FERNANDO',			'GREATPERSON_CLANCY_FERNANDO_AMENITIES',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO',			'GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO_SEA_MOVEMENT', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');

insert or replace into Modifiers
	(ModifierId,												ModifierType,											RunOnce,	Permanent)
values
	('ARTEMISIA_LIGHTHOUSE',									'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',	1,			1),
	('ARTEMISIA_LIGHTHOUSE_FOOD',								'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',	0,			1),
	('GREATPERSON_GRANT_A_SETTLER',								'MODIFIER_PLAYER_UNIT_GRANT_UNIT_WITH_EXPERIENCE',		1,			1),
	('GREATPERSON_NAVLA_RAIDER_BONUS',							'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',					0,			1),
	('HORATIO_NELSON_SHIPYARD_PRODUCTION',						'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',	0,			1),
	('GREATPERSON_SETTLER_EMBARK',								'MODIFIER_PLAYER_ADJUST_EMBARK_UNIT_PASS',				0,			1),
	('GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT',				'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',	1,			1),
	('GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO_SEA_MOVEMENT',	'MODIFIER_PLAYER_UNITS_ADJUST_SEA_MOVEMENT',			1,			1);

insert or replace into Modifiers
	(ModifierId,											ModifierType,										RunOnce,		Permanent,	SubjectRequirementSetId)
values
	('GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT_HOUSING',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_HOUSING',	0,				1,			'BUILDING_IS_SEAPORT'),
	('GREATPERSON_CLANCY_FERNANDO_AMENITIES',				'MODIFIER_PLAYER_CITIES_ADJUST_CITY_AMENITIES_FROM_GREAT_PEOPLE',	0,	1,		'CITY_HAS_HARBOR_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,												Name,				Value)
values
	('ARTEMISIA_LIGHTHOUSE',									'BuildingType',		'BUILDING_LIGHTHOUSE'),
	('ARTEMISIA_LIGHTHOUSE_FOOD',								'BuildingType',		'BUILDING_LIGHTHOUSE'),
	('ARTEMISIA_LIGHTHOUSE_FOOD',								'YieldType',		'YIELD_FOOD'),
	('ARTEMISIA_LIGHTHOUSE_FOOD',								'Amount',			1),
	('GREATPERSON_GRANT_A_SETTLER',								'UnitType',			'UNIT_SETTLER'),
	('GREATPERSON_NAVLA_RAIDER_BONUS',							'AbilityType',		'ABILITY_NAVAL_RAIDER_BONUS'),
	('HORATIO_NELSON_SHIPYARD_PRODUCTION',						'BuildingType',		'BUILDING_SHIPYARD'),
	('HORATIO_NELSON_SHIPYARD_PRODUCTION',						'YieldType',		'YIELD_PRODUCTION'),
	('HORATIO_NELSON_SHIPYARD_PRODUCTION',						'Amount',			3),
	('GREATPERSON_SETTLER_EMBARK',								'UnitType',			'UNIT_SETTLER'),
	('GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT',				'BuildingType',		'BUILDING_SEAPORT'),
	('GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT_HOUSING',		'Amount',			1),
	('GREATPERSON_CLANCY_FERNANDO_AMENITIES',					'Amount',			1),
	('GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO_SEA_MOVEMENT',	'Amount',			1);

insert or replace into ModifierStrings
	(ModifierId,												Context,	Text)
values
	('ARTEMISIA_LIGHTHOUSE',									'Summary',	'LOC_ARTEMISIA_LIGHTHOUSE'),
	('ARTEMISIA_LIGHTHOUSE_FOOD',								'Summary',	'LOC_ARTEMISIA_LIGHTHOUSE_FOOD'),
	('GREATPERSON_GRANT_A_SETTLER',								'Summary',	'LOC_GREATPERSON_GRANT_A_SETTLER'),
	('GREATPERSON_NAVLA_RAIDER_BONUS',							'Summary',	'LOC_GREATPERSON_NAVLA_RAIDER_BONUS'),
	('HORATIO_NELSON_SHIPYARD_PRODUCTION',						'Summary',	'LOC_HORATIO_NELSON_SHIPYARD_PRODUCTION'),
	('GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT',				'Summary',	'LOC_GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT'),
	('GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT_HOUSING',		'Summary',	'LOC_GREATPERSON_JOAQUIM_MARQUES_LISBOA_SEAPORT_HOUSING'),
	('GREATPERSON_CLANCY_FERNANDO_AMENITIES',					'Summary',	'LOC_GREATPERSON_CLANCY_FERNANDO_AMENITIES'),
	('GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO_SEA_MOVEMENT',	'Summary',	'LOC_GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO_SEA_MOVEMENT');

update ModifierStrings set Text = 'LOC_PIERO_DE_BARDI_GOLD' where ModifierId = 'GREATPERSON_FERDINAND_MAGELLAN_ACTIVE';
update ModifierArguments set Value = 1000 where Name = 'Amount' and ModifierId = 'GREATPERSON_CHING_SHIH_ACTIVE';

-- Mimar Sinan.
insert or replace into Modifiers (ModifierId, ModifierType) values
('GREATPERSON_CULTURE_BOMB_MIMAR_SINAN', 'MODIFIER_DO_NOTHING');
insert or replace into ModifierStrings (ModifierId, Context, Text) values
('GREATPERSON_CULTURE_BOMB_MIMAR_SINAN', 'Summary', 'LOC_GREATPERSON_DISTRICT_CULTURE_BOMB');

update GreatPersonIndividuals set
ActionCharges = 2,
ActionRequiresCompletedDistrictType = NULL,
ActionEffectTileHighlighting = 0
where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN';

update GreatPersonIndividualActionModifiers
set ModifierId = 'GREATPERSON_CULTURE_BOMB_MIMAR_SINAN', AttachmentTargetType = 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'
where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN';

-- 使者调整
	-- 【大将军】 安娜·恩津加
-- update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ANA_NZINGA';
	-- 【大商人】 拉贾·托达·马尔 皮耶罗·迪·巴尔迪 【海军统帅】 特米斯托克力
-- update ModifierArguments set Value = 2 where ModifierId = 'GREATPERSON_INFLUENCE_TOKENS_SMALL';
	-- 【大商人】 雅各布·富格尔 约翰·雅各·阿斯特
-- update ModifierArguments set Value = 4 where ModifierId = 'GREATPERSON_INFLUENCE_TOKENS_MEDIUM';
	-- 【大商人】 周达观
-- update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ZHOU_DAGUAN';

-- 新大作家
insert or replace into Types
	(Type,											Kind)
values
	('GREAT_PERSON_INDIVIDUAL_ZHUANG_ZHOU',			'KIND_GREAT_PERSON_INDIVIDUAL'),
	('GREAT_PERSON_INDIVIDUAL_SI_MA_QIAN',			'KIND_GREAT_PERSON_INDIVIDUAL');

insert or replace into GreatPersonIndividuals
	(GreatPersonIndividualType,						Name,												GreatPersonClassType,			EraType,			ActionCharges,		ActionRequiresOwnedTile,		Gender)
values
	('GREAT_PERSON_INDIVIDUAL_ZHUANG_ZHOU',			'LOC_GREAT_PERSON_INDIVIDUAL_ZHUANG_ZHOU_NAME',		'GREAT_PERSON_CLASS_WRITER',	'ERA_CLASSICAL',	0,					1,								'M'),
	('GREAT_PERSON_INDIVIDUAL_SI_MA_QIAN',			'LOC_GREAT_PERSON_INDIVIDUAL_SI_MA_QIAN_NAME',		'GREAT_PERSON_CLASS_WRITER',	'ERA_CLASSICAL',	0,					1,								'M');

------------------------------------------------------------------------------------------------
--大军改动 by先驱

--布狄卡由一次改为两次(取消)
--update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_BOUDICA';
--汉尼拔·巴卡由两次改为三次
update GreatPersonIndividuals set ActionCharges = 3 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HANNIBAL_BARCA';
--孙子新增能力：全国军事单位战斗经验+25%（效果还在大军上，能力写在书上）
--update GreatPersonIndividuals set ActionCharges = 1 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_SUN_TZU';
--埃塞尔弗莱德能力重做：完成1个兵营，对蛮子+3力。可以使用两次
update GreatPersonIndividuals set ActionCharges = 2, ActionRequiresCompletedDistrictType = 'DISTRICT_ENCAMPMENT'
	where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_AETHELFLAED';
--古斯塔夫·阿道弗斯，不送单位的晋升，次数由1改为2
update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_GUSTAVUS_ADOLPHUS';
update ModifierArguments set Value = 0 where ModifierId = 'GREATPERSON_GUSTAVUS_ADOLPHUS_ACTIVE' and Name = 'Experience';
--安娜·恩津加次数由2改为4
update GreatPersonIndividuals set ActionCharges = 4 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ANA_NZINGA';
--詹西女王由一次改为两次
update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_RANI_LAKSHMIBAI';
--次数由1改为2
update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR';

update GreatPersonIndividuals set
	ActionRequiresUnitCanGainExperience = 0,
	ActionRequiresMilitaryUnitDomain = NULL,
	ActionRequiresCompletedDistrictType = 'DISTRICT_CITY_CENTER'
where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_TIMUR';

update GreatPersonIndividuals set 
	ActionRequiresCompletedDistrictType = NULL,
	ActionRequiresNoMilitaryUnit = 1,
	ActionRequiresOwnedTile = 0,
	ActionEffectTileHighlighting = 0
where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR';

insert or replace into ModifierStrings
	(ModifierId,								Context,		Text)
values
--	('GREATPERSON_SUN_ZTU_ACTIVE_1',			'Summary',		'LOC_GREATPERSON_SUN_ZTU_ACTIVE'),
	('GREATPERSON_AETHELFLAED_ACTIVE_1',		'Summary',		'LOC_GREATPERSON_AETHELFLAED_ACTIVE'),
	('GREATPERSON_EL_CID_ACTIVE',				'Summary',		'LOC_GREATPERSON_EL_CID_ACTIVE'),
	('GREATPERSON_TIMUR_ACTIVE_1',				'Summary',		'LOC_GREATPERSON_TIMUR_ACTIVE'),
	('GREATPERSON_GUSTAVUS_ADOLPHUS_ACTIVE',	'Summary',		'LOC_GREATPERSON_GUSTAVUS_ADOLPHUS_ACTIVE'),
	('GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE',	'Summary',		'LOC_GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE'),
	('GREATPERSON_SIMON_BOLIVAR_ACTIVE_1',		'Summary',		'LOC_GREATPERSON_SIMON_BOLIVAR_ACTIVE');

delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_AETHELFLAED' and ModifierId = 'GREATPERSON_AETHELFLAED_ACTIVE';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_TIMUR' and ModifierId = 'GREATPERSON_TIMUR_ACTIVE';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_TIMUR' and ModifierId = 'GREATPERSON_TIMUR_ACTIVE_UNIT_BONUS';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR' and ModifierId = 'GREATPERSON_SIMON_BOLIVAR_ACTIVE';

insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,									AttachmentTargetType)
values
--	('GREAT_PERSON_INDIVIDUAL_SUN_TZU',				'GREATPERSON_SUN_ZTU_ACTIVE_1',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
--埃塞尔弗莱德能力重做：完成1个兵营，对蛮子+3力。可以使用两次
	('GREAT_PERSON_INDIVIDUAL_AETHELFLAED',			'GREATPERSON_AETHELFLAED_ACTIVE_1',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_AETHELFLAED',			'GREATPERSON_AETHELFLAED_ACTIVE_2',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
--艾尔·熙德新增能力：给一个升级
	('GREAT_PERSON_INDIVIDUAL_EL_CID',				'GREATPERSON_EL_CID_ACTIVE_1',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_DOMAIN_MILITARY_IN_TILE'),
--帖木儿能力重做：为该城市赠予一个免费的商人单位，增加1条贸易路线容量。
	('GREAT_PERSON_INDIVIDUAL_TIMUR',				'GREATPERSON_TIMUR_ACTIVE_1',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_TIMUR',				'GREATPERSON_TIMUR_ACTIVE_2',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
--拿破仑波拿巴新增能力：给一个升级
	('GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE',	'GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE_1',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_DOMAIN_MILITARY_IN_TILE'),
--圣马丁能力重做：立即创建1个胸甲骑兵单位。
	('GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR',		'GREATPERSON_SIMON_BOLIVAR_ACTIVE_1',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON');
insert or replace into GreatWorkModifiers
	(GreatWorkType,					ModifierId)
values
	('GREATWORK_SUN_TZU',			'GREATPERSON_SUN_ZTU_ACTIVE_ATTACH');
insert or replace into Modifiers
	(ModifierId,								ModifierType,												RunOnce,	Permanent)
values
	('GREATPERSON_SUN_ZTU_ACTIVE_ATTACH',		'MODIFIER_PLAYER_ATTACH_MODIFIER',							0,			0),
	('GREATPERSON_SUN_ZTU_ACTIVE',				'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_EXPERIENCE_MODIFIER',	0,			0),
	('GREATPERSON_AETHELFLAED_ACTIVE_1',		'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',		1,			1),
	('GREATPERSON_AETHELFLAED_ACTIVE_2',		'MODIFIER_PLAYER_UNITS_ADJUST_BARBARIAN_COMBAT',			1,			1),
	('GREATPERSON_EL_CID_ACTIVE_1',				'MODIFIER_PLAYER_UNIT_ADJUST_GRANT_EXPERIENCE',				1,			1),
	('GREATPERSON_TIMUR_ACTIVE_1',				'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',					1,			1),
	('GREATPERSON_TIMUR_ACTIVE_2',				'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY',				1,			1),
	('GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE_1', 'MODIFIER_PLAYER_UNIT_ADJUST_GRANT_EXPERIENCE',				1,			1),
	('GREATPERSON_SIMON_BOLIVAR_ACTIVE_1',		'MODIFIER_PLAYER_UNIT_GRANT_UNIT_WITH_EXPERIENCE',			1,			1);

insert or replace into ModifierArguments 
	(ModifierID,								Name,			Value) 
values
	('GREATPERSON_SUN_ZTU_ACTIVE_ATTACH',		'ModifierId',	'GREATPERSON_SUN_ZTU_ACTIVE'),
	('GREATPERSON_SUN_ZTU_ACTIVE',				'Amount',		25),
	('GREATPERSON_AETHELFLAED_ACTIVE_1',		'BuildingType', 'BUILDING_BARRACKS'),
	('GREATPERSON_AETHELFLAED_ACTIVE_2',		'Amount',		3),
	('GREATPERSON_EL_CID_ACTIVE_1',				'Amount',		-1),
	('GREATPERSON_TIMUR_ACTIVE_1',				'Amount',		1),
	('GREATPERSON_TIMUR_ACTIVE_1',				'UnitType',		'UNIT_TRADER'),
	('GREATPERSON_TIMUR_ACTIVE_2',				'Amount',		1),
	('GREATPERSON_NAPOLEON_BONAPARTE_ACTIVE_1', 'Amount',		-1),
	('GREATPERSON_SIMON_BOLIVAR_ACTIVE_1',		'Experience',	0),
	('GREATPERSON_SIMON_BOLIVAR_ACTIVE_1',		'UnitType',		'UNIT_CUIRASSIER'),
	('GREATPERSON_SIMON_BOLIVAR_ACTIVE_1',		'UniqueOverride',	1);

--宾根
update ModifierArguments set Value = 100 where ModifierId = 'GREATPERSON_FAITH' and Name = 'Amount';
update GreatPersonIndividuals set ActionCharges = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN';
--霍普
delete from GreatPersonIndividualActionModifiers where ModifierId = 'GREATPERSON_GRACE_HOPPER_ACTIVE';
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,								AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_GRACE_HOPPER',		'GREATPERSON_GRACE_HOPPER_ACTIVE_HD',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');
insert or replace into Modifiers
	(ModifierId,									ModifierType)
values
	('GREATPERSON_GRACE_HOPPER_ACTIVE_HD',			'MODIFIER_DO_NOTHING');
insert or replace into ModifierStrings
	(ModifierId,												Context,				Text)
values
	('GREATPERSON_GRACE_HOPPER_ACTIVE_HD',						'Summary',				'LOC_GREAT_PERSON_INDIVIDUAL_HOPPER');
--删除LEU附带的部分伟人	
delete from GreatPersonIndividuals where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_LEU_BRIAN_EPSTEIN' or GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_LEU_JACK_MA';
--阿基米德变大科，次数变1次，给3%+1ULK
update GreatPersonIndividuals set GreatPersonClassType = 'GREAT_PERSON_CLASS_SCIENTIST', ActionCharges = 1, ActionRequiresCompletedDistrictType = 'DISTRICT_CAMPUS' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_JNR_ARCHIMEDES';
-- update ModifierArguments set Value = 3 where ModifierId = 'JNR_GREATPERSON_EUREKA_STRENGTH';
--新大科郭守敬 新大工昌·巴鲁姆二世 新提督徐福
insert or replace into Types
	(Type,											Kind)
values
	('GREAT_PERSON_INDIVIDUAL_GUO_SHOU_JING',		'KIND_GREAT_PERSON_INDIVIDUAL'),
	('GREAT_PERSON_INDIVIDUAL_KINICH_KAN_BAHLAM',	'KIND_GREAT_PERSON_INDIVIDUAL'),
	('GREAT_PERSON_INDIVIDUAL_XU_FU',				'KIND_GREAT_PERSON_INDIVIDUAL');

insert or replace into GreatPersonIndividuals
	(GreatPersonIndividualType,						Name,														GreatPersonClassType,					EraType,			ActionCharges,		ActionRequiresOwnedTile,		Gender,		ActionRequiresCompletedDistrictType)
values
	('GREAT_PERSON_INDIVIDUAL_GUO_SHOU_JING',		'LOC_GREAT_PERSON_INDIVIDUAL_GUO_SHOU_JING_NAME',			'GREAT_PERSON_CLASS_SCIENTIST',			'ERA_MEDIEVAL',		1,					1,								'M',		'DISTRICT_CAMPUS'),
	('GREAT_PERSON_INDIVIDUAL_KINICH_KAN_BAHLAM',	'LOC_GREAT_PERSON_INDIVIDUAL_KINICH_KAN_BAHLAM_NAME',		'GREAT_PERSON_CLASS_ENGINEER',			'ERA_CLASSICAL',	1,					1,								'M',		'DISTRICT_INDUSTRIAL_ZONE'),
	('GREAT_PERSON_INDIVIDUAL_XU_FU',				'LOC_GREAT_PERSON_INDIVIDUAL_XU_FU_NAME',					'GREAT_PERSON_CLASS_ADMIRAL',			'ERA_CLASSICAL',	1,					1,								'M',		'DISTRICT_HARBOR');

update GreatPersonIndividuals set ActionNameTextOverride = 'LOC_GREATPERSON_ACTION_NAME_RETIRE', AreaHighlightRadius = 2 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_XU_FU';

insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,												AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_GUO_SHOU_JING',		'GREAT_PERSON_HD_BOOST_ASTRONOMY',						'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_KINICH_KAN_BAHLAM',	'GREAT_PERSON_HD_DISTRICT_INDUSTRIAL_ZONE_YIELD',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_XU_FU',				'GREAT_PERSON_HD_EMBARKED_EXTRA_MOVEMENT',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_XU_FU',				'GREAT_PERSON_HD_HARBOR_ADJACENCY_AS_FAITH',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');

insert or replace into GreatPersonIndividualBirthModifiers
	(GreatPersonIndividualType,						ModifierId)
values
	('GREAT_PERSON_INDIVIDUAL_XU_FU',				'GREATPERSON_COMBAT_STRENGTH_AOE_CLASSICAL_SEA'),
	('GREAT_PERSON_INDIVIDUAL_XU_FU',				'GREATPERSON_MOVEMENT_AOE_CLASSICAL_SEA');

insert or replace into Modifiers
	(ModifierId,																ModifierType,														SubjectRequirementSetId)
values
	('GREAT_PERSON_HD_BOOST_ASTRONOMY',											'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',						NULL),
	('GREAT_PERSON_HD_DISTRICT_INDUSTRIAL_ZONE_YIELD',							'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',						'DISTRICT_IS_DISTRICT_INDUSTRIAL_ZONE_REQUIREMENTS'),
	('GREAT_PERSON_HD_DISTRICT_INDUSTRIAL_ZONE_YIELD_MODIFIER',					'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								'PLOT_IS_IMPROVED_ADJACENT'),
	('GREAT_PERSON_HD_EMBARKED_EXTRA_MOVEMENT',									'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',							NULL),
	('GREAT_PERSON_HD_EMBARKED_EXTRA_MOVEMENT_MODIFIER',						'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',								'REQUIREMENTS_UNIT_IS_EMBARKED'),
	('GREAT_PERSON_HD_HARBOR_ADJACENCY_AS_FAITH',								'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',	NULL);

insert or replace into ModifierArguments
	(ModifierId,														Name,					Value)
values
	('GREAT_PERSON_HD_BOOST_ASTRONOMY',									'TechType',				'TECH_ASTRONOMY'),
	('GREAT_PERSON_HD_DISTRICT_INDUSTRIAL_ZONE_YIELD',					'ModifierId',			'GREAT_PERSON_HD_DISTRICT_INDUSTRIAL_ZONE_YIELD_MODIFIER'),
	('GREAT_PERSON_HD_DISTRICT_INDUSTRIAL_ZONE_YIELD_MODIFIER',			'Amount',				'1,1'),
	('GREAT_PERSON_HD_DISTRICT_INDUSTRIAL_ZONE_YIELD_MODIFIER',			'YieldType',			'YIELD_PRODUCTION,YIELD_GOLD'),
	('GREAT_PERSON_HD_EMBARKED_EXTRA_MOVEMENT',							'ModifierId',			'GREAT_PERSON_HD_EMBARKED_EXTRA_MOVEMENT_MODIFIER'),
	('GREAT_PERSON_HD_EMBARKED_EXTRA_MOVEMENT_MODIFIER',				'Amount',				1),
	('GREAT_PERSON_HD_HARBOR_ADJACENCY_AS_FAITH',						'YieldTypeToGrant',		'YIELD_FAITH'),
	('GREAT_PERSON_HD_HARBOR_ADJACENCY_AS_FAITH',						'YieldTypeToMirror',	'YIELD_GOLD');

insert or replace into ModifierStrings
	(ModifierId,											Context,				Text)
values
	('GREAT_PERSON_HD_BOOST_ASTRONOMY',						'Summary',				'LOC_GREAT_PERSON_HD_BOOST_ASTRONOMY'),
	('GREAT_PERSON_HD_DISTRICT_INDUSTRIAL_ZONE_YIELD',		'Summary',				'LOC_GREAT_PERSON_HD_DISTRICT_INDUSTRIAL_ZONE_YIELD'),
	('GREAT_PERSON_HD_EMBARKED_EXTRA_MOVEMENT',				'Summary',				'LOC_GREAT_PERSON_HD_EMBARKED_EXTRA_MOVEMENT');

insert or ignore into Types
	(Type,								Kind)
values
	('TERRAIN_CLASS_HILLS',				'KIND_TERRAIN_CLASS');

insert or ignore into TerrainClasses
	(TerrainClassType,					Name)
values
	('TERRAIN_CLASS_HILLS',				'LOC_TERRAIN_CLASS_HILLS_NAME');

insert or ignore into TerrainClass_Terrains
	(TerrainClassType,					TerrainType)
values
	('TERRAIN_CLASS_HILLS',				'TERRAIN_GRASS_HILLS'),
	('TERRAIN_CLASS_HILLS',				'TERRAIN_PLAINS_HILLS'),
	('TERRAIN_CLASS_HILLS',				'TERRAIN_DESERT_HILLS'),
	('TERRAIN_CLASS_HILLS',				'TERRAIN_TUNDRA_HILLS'),
	('TERRAIN_CLASS_HILLS',				'TERRAIN_SNOW_HILLS');

insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,												AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_GUO_SHOU_JING',		'GREAT_PERSON_HD_' || TerrainType || '_EXTRA_BONUS',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'
from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_HILLS';

insert or replace into Modifiers
	(ModifierId,											ModifierType,											SubjectRequirementSetId)
select
	'GREAT_PERSON_HD_' || TerrainType || '_EXTRA_BONUS',	'MODIFIER_PLAYER_CITIES_TERRAIN_ADJACENCY',				NULL
from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_HILLS';

insert or replace into ModifierArguments
	(ModifierId,											Name,					Value)
select
	'GREAT_PERSON_HD_' || TerrainType || '_EXTRA_BONUS',	'Amount',				1
from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_HILLS' union all
select
	'GREAT_PERSON_HD_' || TerrainType || '_EXTRA_BONUS',	'Description',			'LOC_DISTRICT_' || TerrainClassType || '_SCIENCE'
from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_HILLS' union all
select
	'GREAT_PERSON_HD_' || TerrainType || '_EXTRA_BONUS',	'DistrictType',			'DISTRICT_CAMPUS'
from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_HILLS' union all
select
	'GREAT_PERSON_HD_' || TerrainType || '_EXTRA_BONUS',	'TerrainType',			TerrainType
from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_HILLS' union all
select
	'GREAT_PERSON_HD_' || TerrainType || '_EXTRA_BONUS',	'YieldType',			'YIELD_SCIENCE'
from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_HILLS';


--伟人替换
update GreatPersonIndividuals set Gender = 'M' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_EMILIE_DU_CHATELET';
update GreatPersonIndividuals set Gender = 'M', ActionRequiresNonHostileTerritory = 0, ActionRequiresOwnedTile = 1 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARGARET_MEAD';
update GreatPersonIndividuals set Gender = 'M' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_STEPHANIE_KWOLEK';
update GreatPersonIndividuals set Gender = 'M' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_DANDARA';
update GreatPersonIndividuals set EraType = 'ERA_ATOMIC' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARINA_RASKOVA';
update GreatPersonIndividuals set ActionRequiresCompletedDistrictType = 'DISTRICT_ENCAMPMENT', ActionRequiresOwnedTile = 1, ActionEffectTileHighlighting = 1 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_DWIGHT_EISENHOWER';
update ModifierArguments set Value = 'UNIT_LINE_INFANTRY' where ModifierId = 'GREATPERSON_SAMORI_TURE_ACTIVE' and Name = 'UnitType';
update GreatPersonIndividuals set ActionRequiresCityStateTerritory = 1, ActionRequiresSuzerainTerritory = 0 where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARGARET_MEAD';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_DANDARA';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_DWIGHT_EISENHOWER';
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES';
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,											AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_MARGARET_MEAD',		'GREAT_PERSON_HD_BOOST_OR_GRANT_NUCLEAR_FISSION',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'
where exists (select GreatPersonIndividualType from GreatPersonIndividuals where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_MARGARET_MEAD');
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,											AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_DANDARA',				'GREAT_PERSON_HD_COMBAT_STRENGTH',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'
where exists (select GreatPersonIndividualType from GreatPersonIndividuals where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_DANDARA');
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,											AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES',		'GREATPERSON_CITY_STATE_STEAL_ENVOYS',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON'
where exists (select GreatPersonIndividualType from GreatPersonIndividuals where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES');
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,											AttachmentTargetType)
values
--	('GREAT_PERSON_INDIVIDUAL_MARGARET_MEAD',		'GREAT_PERSON_HD_BOOST_OR_GRANT_NUCLEAR_FISSION',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
--	('GREAT_PERSON_INDIVIDUAL_DANDARA',				'GREAT_PERSON_HD_COMBAT_STRENGTH',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_DWIGHT_EISENHOWER',	'GREAT_PERSON_MILITARY_POLICY_SLOT',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');
--	('GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES',	'GREATPERSON_CITY_STATE_STEAL_ENVOYS',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON');

insert or replace into GreatPersonIndividualBirthModifiers
	(GreatPersonIndividualType,						ModifierId)
select
	'GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES',	'GREAT_PERSON_ENTER_FOREIGN_LANDS'
where exists (select GreatPersonIndividualType from GreatPersonIndividuals where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES');
insert or replace into Modifiers
	(ModifierId,										ModifierType,													RunOnce,	SubjectRequirementSetId)
values
	('GREAT_PERSON_HD_BOOST_OR_GRANT_NUCLEAR_FISSION',	'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',					1,			NULL),
	('GREAT_PERSON_HD_COMBAT_STRENGTH',					'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',						0,			'REQUIREMENTS_UNIT_IS_LAND_DOMAIN'),
	('GREAT_PERSON_HD_COMBAT_STRENGTH_MODIFIER',		'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',							0,			NULL),
	('GREAT_PERSON_MILITARY_POLICY_SLOT',				'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER',		1,			NULL);
insert or replace into ModifierArguments
	(ModifierId,										Name,					Value)
values
	('GREAT_PERSON_HD_BOOST_OR_GRANT_NUCLEAR_FISSION',	'GrantTechIfBoosted',	1),
	('GREAT_PERSON_HD_BOOST_OR_GRANT_NUCLEAR_FISSION',	'TechType',				'TECH_NUCLEAR_FISSION'),
	('GREAT_PERSON_HD_COMBAT_STRENGTH',					'ModifierId',			'GREAT_PERSON_HD_COMBAT_STRENGTH_MODIFIER'),
	('GREAT_PERSON_HD_COMBAT_STRENGTH_MODIFIER',		'Amount',				2),
	('GREAT_PERSON_MILITARY_POLICY_SLOT',				'GovernmentSlotType',	'SLOT_MILITARY');
insert or replace into ModifierStrings
	(ModifierId,										Context,	Text)
values
	('GREAT_PERSON_HD_BOOST_OR_GRANT_NUCLEAR_FISSION',	'Summary',	'LOC_GREAT_PERSON_HD_BOOST_OR_GRANT_NUCLEAR_FISSION'),
	('GREAT_PERSON_HD_COMBAT_STRENGTH',					'Summary',	'LOC_GREAT_PERSON_HD_COMBAT_STRENGTH'),
	('GREAT_PERSON_HD_COMBAT_STRENGTH_MODIFIER',		'Preview',	'+{1_Amount} {LOC_GREAT_PERSON_HD_COMBAT_STRENGTH_MODIFIER}'),
	('GREAT_PERSON_MILITARY_POLICY_SLOT',				'Summary',	'LOC_GREAT_PERSON_MILITARY_POLICY_SLOT');
--bug修复
--拉金德拉·朱罗
update Modifiers set ModifierType = 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', SubjectRequirementSetId = 'HD_UNIT_IS_NAVAL' where ModifierId = 'GREATPERSON_RAJENDRA_CHOLA_ACTIVE';
update ModifierArguments set Name = 'ModifierId', Value = 'CHOLA_NAVAL_UNITS_COMBAT_STRENGTH' where ModifierId = 'GREATPERSON_RAJENDRA_CHOLA_ACTIVE';
--雷夫·埃里克森
update Modifiers set ModifierType = 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', SubjectRequirementSetId = 'HD_UNIT_IS_NAVAL' where ModifierId = 'GREATPERSON_LEIF_ERIKSON_SIGHT_BONUS';
update ModifierArguments set Name = 'ModifierId', Value = 'ERIKSON_NAVAL_UNITS_SIGHT_RANGE' where ModifierId = 'GREATPERSON_LEIF_ERIKSON_SIGHT_BONUS';
--弗朗西斯·德瑞克
update Modifiers set ModifierType = 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', SubjectRequirementSetId = 'UNIT_IS_NAVAL_RAIDER' where ModifierId = 'GREATPERSON_NAVLA_RAIDER_BONUS';
update ModifierArguments set Name = 'ModifierId', Value = 'FRANCIS_DRAKE_NAVAL_RAIDER_BONUS' where ModifierId = 'GREATPERSON_NAVLA_RAIDER_BONUS';
--霍雷肖·纳尔逊
update Modifiers set ModifierType = 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER' where ModifierId = 'GREATPERSON_HORATIO_NELSON_ACTIVE';
update ModifierArguments set Name = 'ModifierId', Value = 'HORATIO_NELSON_FLANKING_BONUS' where ModifierId = 'GREATPERSON_HORATIO_NELSON_ACTIVE';
--东乡平八郎
update Modifiers set RunOnce = 0 where ModifierId = 'GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO_SEA_MOVEMENT';
--欧几里得
delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_EUCLID' and ModifierId = 'GREATPERSON_1MEDIEVALTECHBOOST';
delete from ModifierArguments where ModifierId = 'GREAT_PERSON_HD_BOOST_OR_GRANT_MATHEMATICS' and Name = 'GrantTechIfBoosted';


-- 仇英
update GreatPersonIndividuals set EraType = 'ERA_RENAISSANCE' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_QIU_YING';

---------------------------------------------------------------------------------------------------------------------------------------------------
-- 新大艺术家
create table HD_NEW_ARTIST (
	GreatPersonIndividualType TEXT not null,
	EraType TEXT not null,
	GreatWorkType TEXT,
	GreatWorkObjectType TEXT,
	primary key (GreatPersonIndividualType, GreatWorkType)
);

insert or replace into HD_NEW_ARTIST
	(GreatPersonIndividualType,												EraType,						GreatWorkType,												GreatWorkObjectType)
values
	---------------------------------------------------------------- 古典时代 ----------------------------------------------------------------
	-- 毛延寿 《美人图》
	('GREAT_PERSON_INDIVIDUAL_MAO_YAN_SHOU_HD',				'ERA_CLASSICAL',		'GREATWORK_MAO_YAN_SHOU_HD_1',				'GREATWORKOBJECT_PORTRAIT'),
	-- 毛延寿 《昭君画像》
	('GREAT_PERSON_INDIVIDUAL_MAO_YAN_SHOU_HD',				'ERA_CLASSICAL',		'GREATWORK_MAO_YAN_SHOU_HD_2',				'GREATWORKOBJECT_PORTRAIT'),
	-- 曹不兴 《敦煌壁画康僧会建业传法图》
	('GREAT_PERSON_INDIVIDUAL_CAO_BU_XING_HD',				'ERA_CLASSICAL',		'GREATWORK_CAO_BU_XING_HD_1',					'GREATWORKOBJECT_RELIGIOUS'),
	-- 曹不兴 《佛像立轴》
	('GREAT_PERSON_INDIVIDUAL_CAO_BU_XING_HD',				'ERA_CLASSICAL',		'GREATWORK_CAO_BU_XING_HD_2',					'GREATWORKOBJECT_RELIGIOUS'),
	-- 顾恺之 《洛神赋图》其一
	('GREAT_PERSON_INDIVIDUAL_GU_KAI_ZHI_HD',					'ERA_CLASSICAL',		'GREATWORK_GU_KAI_ZHI_HD_1',					'GREATWORKOBJECT_LANDSCAPE'),
	-- 顾恺之 《洛神赋图》其二
	('GREAT_PERSON_INDIVIDUAL_GU_KAI_ZHI_HD',					'ERA_CLASSICAL',		'GREATWORK_GU_KAI_ZHI_HD_2',					'GREATWORKOBJECT_LANDSCAPE'),
	-- 戴逵 《丈六无量寿佛》
	('GREAT_PERSON_INDIVIDUAL_DAI_KUI_HD',						'ERA_CLASSICAL',		'GREATWORK_DAI_KUI_HD_1',							'GREATWORKOBJECT_SCULPTURE'),
	-- 戴逵 《玉躯佛像》
	('GREAT_PERSON_INDIVIDUAL_DAI_KUI_HD',						'ERA_CLASSICAL',		'GREATWORK_DAI_KUI_HD_2',							'GREATWORKOBJECT_SCULPTURE'),
	-- 张僧繇 《二十八星宿真形图》
	('GREAT_PERSON_INDIVIDUAL_ZHANG_SENG_YAO_HD',			'ERA_CLASSICAL',		'GREATWORK_ZHANG_SENG_YAO_HD_1',			'GREATWORKOBJECT_PORTRAIT'),
	-- 张僧繇 《仙人楼阁图》
	('GREAT_PERSON_INDIVIDUAL_ZHANG_SENG_YAO_HD',			'ERA_CLASSICAL',		'GREATWORK_ZHANG_SENG_YAO_HD_2',			'GREATWORKOBJECT_LANDSCAPE'),
	-- 菲狄亚斯 《雅典娜头像》
	('GREAT_PERSON_INDIVIDUAL_PHEIDIAS_HD',						'ERA_CLASSICAL',		'GREATWORK_PHEIDIAS_HD_1',						'GREATWORKOBJECT_SCULPTURE'),
	-- 菲狄亚斯 《戎装的雅典娜》
	('GREAT_PERSON_INDIVIDUAL_PHEIDIAS_HD',						'ERA_CLASSICAL',		'GREATWORK_PHEIDIAS_HD_2',						'GREATWORKOBJECT_SCULPTURE'),
	-- 米隆 《掷铁饼者》
	('GREAT_PERSON_INDIVIDUAL_MYRON_HD',							'ERA_CLASSICAL',		'GREATWORK_MYRON_HD_1',								'GREATWORKOBJECT_SCULPTURE'),
	-- 米隆 《雅典娜和玛息阿》
	('GREAT_PERSON_INDIVIDUAL_MYRON_HD',							'ERA_CLASSICAL',		'GREATWORK_MYRON_HD_2',								'GREATWORKOBJECT_SCULPTURE'),
	-- 波利克里托斯 《荷矛者》
	('GREAT_PERSON_INDIVIDUAL_POLYCLITUS_HD',					'ERA_CLASSICAL',		'GREATWORK_POLYCLITUS_HD_1',					'GREATWORKOBJECT_SCULPTURE'),
	-- 波利克里托斯 《法则》
	('GREAT_PERSON_INDIVIDUAL_POLYCLITUS_HD',					'ERA_CLASSICAL',		'GREATWORK_POLYCLITUS_HD_2',					'GREATWORKOBJECT_WRITING'),
	---------------------------------------------------------------- 中世纪时代 ----------------------------------------------------------------
	-- 展子虔 《游春图》
	('GREAT_PERSON_INDIVIDUAL_ZHAN_ZI_QIAN_HD',				'ERA_MEDIEVAL',			'GREATWORK_ZHAN_ZI_QIAN_HD_1',				'GREATWORKOBJECT_LANDSCAPE'),
	-- 展子虔 《授经图》
	('GREAT_PERSON_INDIVIDUAL_ZHAN_ZI_QIAN_HD',				'ERA_MEDIEVAL',			'GREATWORK_ZHAN_ZI_QIAN_HD_2',				'GREATWORKOBJECT_PORTRAIT'),
	-- 吴道子 《送子天王图》
	('GREAT_PERSON_INDIVIDUAL_WU_DAO_ZI_HD',					'ERA_MEDIEVAL',			'GREATWORK_WU_DAO_ZI_HD_1',						'GREATWORKOBJECT_RELIGIOUS'),
	-- 吴道子 《八十七神仙卷》
	('GREAT_PERSON_INDIVIDUAL_WU_DAO_ZI_HD',					'ERA_MEDIEVAL',			'GREATWORK_WU_DAO_ZI_HD_2',						'GREATWORKOBJECT_RELIGIOUS'),
	-- 杨惠之 《袒腹罗汉》
	('GREAT_PERSON_INDIVIDUAL_YANG_HUI_ZHI_HD',				'ERA_MEDIEVAL',			'GREATWORK_YANG_HUI_ZHI_HD_1',				'GREATWORKOBJECT_SCULPTURE'),
	-- 杨惠之 《达摩罗汉》
	('GREAT_PERSON_INDIVIDUAL_YANG_HUI_ZHI_HD',				'ERA_MEDIEVAL',			'GREATWORK_YANG_HUI_ZHI_HD_2',				'GREATWORKOBJECT_SCULPTURE'),
	-- 荆浩 《匡庐图》
	('GREAT_PERSON_INDIVIDUAL_JING_HAO_HD',						'ERA_MEDIEVAL',			'GREATWORK_JING_HAO_HD_1',						'GREATWORKOBJECT_LANDSCAPE'),
	-- 荆浩 《雪景山水图》
	('GREAT_PERSON_INDIVIDUAL_JING_HAO_HD',						'ERA_MEDIEVAL',			'GREATWORK_JING_HAO_HD_2',						'GREATWORKOBJECT_LANDSCAPE'),
	-- 张择端 《清明上河图》
	('GREAT_PERSON_INDIVIDUAL_ZHANG_ZE_DUAN_HD',			'ERA_MEDIEVAL',			'GREATWORK_ZHANG_ZE_DUAN_HD_1',				'GREATWORKOBJECT_LANDSCAPE'),
	-- 张择端 《金明池争标图》
	('GREAT_PERSON_INDIVIDUAL_ZHANG_ZE_DUAN_HD',			'ERA_MEDIEVAL',			'GREATWORK_ZHANG_ZE_DUAN_HD_2',				'GREATWORKOBJECT_LANDSCAPE'),
	-- 李唐 《采薇图》
	('GREAT_PERSON_INDIVIDUAL_LI_TANG_HD',						'ERA_MEDIEVAL',			'GREATWORK_LI_TANG_HD_1',							'GREATWORKOBJECT_PORTRAIT'),
	-- 李唐 《万壑松风图》
	('GREAT_PERSON_INDIVIDUAL_LI_TANG_HD',						'ERA_MEDIEVAL',			'GREATWORK_LI_TANG_HD_2',							'GREATWORKOBJECT_LANDSCAPE'),
	-- 赵孟頫
	('GREAT_PERSON_INDIVIDUAL_ZHAO_MENG_FU_HD',				'ERA_MEDIEVAL',			NULL,																	NULL),
	-- 朱碧山 《元朱碧山银槎》
	('GREAT_PERSON_INDIVIDUAL_ZHU_BI_SHAN_HD',				'ERA_MEDIEVAL',			'GREATWORK_ZHU_BI_SHAN_HD_1',					'GREATWORKOBJECT_SCULPTURE'),
	-- 朱碧山 《元朱碧山银槎》
	('GREAT_PERSON_INDIVIDUAL_ZHU_BI_SHAN_HD',				'ERA_MEDIEVAL',			'GREATWORK_ZHU_BI_SHAN_HD_2',					'GREATWORKOBJECT_SCULPTURE'),
	-- 吉斯勒贝尔 《最后的审判》
	('GREAT_PERSON_INDIVIDUAL_GISLEBERTUS_HD',				'ERA_MEDIEVAL',			'GREATWORK_GISLEBERTUS_HD_1',					'GREATWORKOBJECT_SCULPTURE'),
	-- 吉斯勒贝尔 《诱惑夏娃》
	('GREAT_PERSON_INDIVIDUAL_GISLEBERTUS_HD',				'ERA_MEDIEVAL',			'GREATWORK_GISLEBERTUS_HD_2',					'GREATWORKOBJECT_SCULPTURE'),
	-- 乔托·迪·邦多纳 《犹大之吻》
	('GREAT_PERSON_INDIVIDUAL_GIOTTO_DI_BONDONE_HD',	'ERA_MEDIEVAL',			'GREATWORK_GIOTTO_DI_BONDONE_HD_1',		'GREATWORKOBJECT_RELIGIOUS'),
	-- 乔托·迪·邦多纳 《逃往埃及》
	('GREAT_PERSON_INDIVIDUAL_GIOTTO_DI_BONDONE_HD',	'ERA_MEDIEVAL',			'GREATWORK_GIOTTO_DI_BONDONE_HD_2',		'GREATWORKOBJECT_RELIGIOUS'),
	---------------------------------------------------------------- 文艺复兴时代 ----------------------------------------------------------------
	-- 董其昌 《高逸图》
	('GREAT_PERSON_INDIVIDUAL_DONG_QI_CHANG_HD',			'ERA_RENAISSANCE',	'GREATWORK_DONG_QI_CHANG_HD_1',				'GREATWORKOBJECT_PORTRAIT'),
	-- 董其昌 《林和靖诗意图》
	('GREAT_PERSON_INDIVIDUAL_DONG_QI_CHANG_HD',			'ERA_RENAISSANCE',	'GREATWORK_DONG_QI_CHANG_HD_2',				'GREATWORKOBJECT_LANDSCAPE'),
	-- 董其昌 《岩居图》
	('GREAT_PERSON_INDIVIDUAL_DONG_QI_CHANG_HD',			'ERA_RENAISSANCE',	'GREATWORK_DONG_QI_CHANG_HD_3',				'GREATWORKOBJECT_LANDSCAPE'),
	-- 石涛 《淮扬洁秋图》
	('GREAT_PERSON_INDIVIDUAL_SHI_TAO_HD',						'ERA_RENAISSANCE',	'GREATWORK_SHI_TAO_HD_1',							'GREATWORKOBJECT_LANDSCAPE'),
	-- 石涛 《山水清音图》
	('GREAT_PERSON_INDIVIDUAL_SHI_TAO_HD',						'ERA_RENAISSANCE',	'GREATWORK_SHI_TAO_HD_2',							'GREATWORKOBJECT_LANDSCAPE'),
	-- 石涛 《苦瓜和尚画语录》
	('GREAT_PERSON_INDIVIDUAL_SHI_TAO_HD',						'ERA_RENAISSANCE',	'GREATWORK_SHI_TAO_HD_3',							'GREATWORKOBJECT_WRITING'),
	-- 八大山人 《孔雀竹石图》
	('GREAT_PERSON_INDIVIDUAL_ZHU_DA_HD',							'ERA_RENAISSANCE',	'GREATWORK_ZHU_DA_HD_1',							'GREATWORKOBJECT_LANDSCAPE'),
	-- 八大山人 《荷花双禽图》
	('GREAT_PERSON_INDIVIDUAL_ZHU_DA_HD',							'ERA_RENAISSANCE',	'GREATWORK_ZHU_DA_HD_2',							'GREATWORKOBJECT_LANDSCAPE'),
	-- 八大山人 《八大山人自画像》
	('GREAT_PERSON_INDIVIDUAL_ZHU_DA_HD',							'ERA_RENAISSANCE',	'GREATWORK_ZHU_DA_HD_3',							'GREATWORKOBJECT_PORTRAIT'),
	-- 沈蓉圃 《同光十三绝》其一
	('GREAT_PERSON_INDIVIDUAL_SHEN_RONG_PU_HD',				'ERA_RENAISSANCE',	'GREATWORK_SHEN_RONG_PU_HD_1',				'GREATWORKOBJECT_PORTRAIT'),
	-- 沈蓉圃 《同光十三绝》其二
	('GREAT_PERSON_INDIVIDUAL_SHEN_RONG_PU_HD',				'ERA_RENAISSANCE',	'GREATWORK_SHEN_RONG_PU_HD_2',				'GREATWORKOBJECT_PORTRAIT'),
	-- 沈蓉圃 《同光十三绝》其三
	('GREAT_PERSON_INDIVIDUAL_SHEN_RONG_PU_HD',				'ERA_RENAISSANCE',	'GREATWORK_SHEN_RONG_PU_HD_3',				'GREATWORKOBJECT_PORTRAIT');

insert or ignore into Types (Type, Kind)
	select GreatPersonIndividualType,	'KIND_GREAT_PERSON_INDIVIDUAL' from HD_NEW_ARTIST;

insert or ignore into GreatPersonIndividuals
	(GreatPersonIndividualType, Name, GreatPersonClassType, EraType, ActionCharges, ActionRequiresOwnedTile, Gender)
select
	GreatPersonIndividualType,
	'LOC_' || GreatPersonIndividualType || '_NAME',
	'GREAT_PERSON_CLASS_ARTIST',
	EraType,
	0,
	1,
	'M'
from HD_NEW_ARTIST;

-- 赵孟頫
update GreatPersonIndividuals set ActionCharges = 1, ActionRequiresCompletedDistrictType = 'DISTRICT_THEATER' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ZHAO_MENG_FU_HD';
	-- 巨作产出
insert or ignore into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,									ModifierId,																									AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_ZHAO_MENG_FU_HD',	'HD_ZHAO_MENG_FU_' || GreatWorkObjectType || '_CULTURE',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS');

insert or replace into Modifiers
	(ModifierId,																												ModifierType,																		Permanent)
select
	'HD_ZHAO_MENG_FU_' || GreatWorkObjectType || '_CULTURE',						'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD',	1
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS');

insert or replace into ModifierArguments
	(ModifierId,																												Name,										Value)
select
	'HD_ZHAO_MENG_FU_' || GreatWorkObjectType || '_CULTURE',						'ScalingFactor',				125
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS');

insert or replace into ModifierArguments
	(ModifierId,																												Name,										Value)
select
	'HD_ZHAO_MENG_FU_' || GreatWorkObjectType || '_CULTURE',						'YieldType',						'YIELD_CULTURE'
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS');

insert or replace into ModifierArguments
	(ModifierId,																												Name,										Value)
select
	'HD_ZHAO_MENG_FU_' || GreatWorkObjectType || '_CULTURE',						'GreatWorkObjectType',	GreatWorkObjectType
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS');

	-- 巨作业绩
insert or ignore into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,									ModifierId,																									AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_ZHAO_MENG_FU_HD',	'HD_ZHAO_MENG_FU_' || GreatWorkObjectType || '_TOURISM',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS');

insert or replace into Modifiers
	(ModifierId,																														ModifierType,														Permanent)
select
	'HD_ZHAO_MENG_FU_' || GreatWorkObjectType || '_TOURISM',								'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',	1
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS');

insert or replace into ModifierArguments
	(ModifierId,																														Name,										Value)
select
	'HD_ZHAO_MENG_FU_' || GreatWorkObjectType || '_TOURISM',								'ScalingFactor',				150
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS');

insert or replace into ModifierArguments
	(ModifierId,																														Name,										Value)
select
	'HD_ZHAO_MENG_FU_' || GreatWorkObjectType || '_TOURISM',								'GreatWorkObjectType',	GreatWorkObjectType
from GreatWorkObjectTypes where GreatWorkObjectType in ('GREATWORKOBJECT_SCULPTURE', 'GREATWORKOBJECT_PORTRAIT', 'GREATWORKOBJECT_LANDSCAPE', 'GREATWORKOBJECT_RELIGIOUS');

	-- 描述
insert or ignore into ModifierStrings
	(ModifierId,																					Context,		Text)
values
	('HD_ZHAO_MENG_FU_GREATWORKOBJECT_SCULPTURE_CULTURE',	'Summary',	'LOC_ZHAO_MENG_FU_ARTIST_GREATWORK_BONUS_DESCRIPTION');


---------------------------------------------------------------------------------------------------------------------------------------------------
-- 新大音乐家
create table HD_NEW_MUSICIAN (
	GreatPersonIndividualType TEXT not null,
	EraType TEXT not null,
	GreatWorkType TEXT,
	GreatWorkObjectType TEXT,
	primary key (GreatPersonIndividualType, GreatWorkType)
);

insert or replace into HD_NEW_MUSICIAN
	(GreatPersonIndividualType,												EraType,						GreatWorkType,												GreatWorkObjectType)
values
	---------------------------------------------------------------- 古典时代 ----------------------------------------------------------------
	-- 俞伯牙 《高山流水》
	('GREAT_PERSON_INDIVIDUAL_YU_BO_YA_HD',						'ERA_CLASSICAL',		'GREATWORK_YU_BO_YA_HD_1',						'GREATWORKOBJECT_MUSIC'),
	-- 师旷 《阳春白雪》
	('GREAT_PERSON_INDIVIDUAL_SHI_KUANG_HD',					'ERA_CLASSICAL',		'GREATWORK_SHI_KUANG_HD_1',						'GREATWORKOBJECT_MUSIC'),
	-- 李延年 《佳人曲》
	('GREAT_PERSON_INDIVIDUAL_LI_YAN_NIAN_HD',				'ERA_CLASSICAL',		'GREATWORK_LI_YAN_NIAN_HD_1',					'GREATWORKOBJECT_MUSIC'),
	-- 司马相如 《凤求凰》
	('GREAT_PERSON_INDIVIDUAL_SI_MA_XIANG_RU_HD',			'ERA_CLASSICAL',		'GREATWORK_SI_MA_XIANG_RU_HD_1',			'GREATWORKOBJECT_MUSIC'),
	-- 乌孙公主 《悲愁歌》
	('GREAT_PERSON_INDIVIDUAL_LIU_XI_JUN_HD',					'ERA_CLASSICAL',		'GREATWORK_LIU_XI_JUN_HD_1',					'GREATWORKOBJECT_MUSIC'),
	-- 蔡邕 《蔡氏五弄》
	('GREAT_PERSON_INDIVIDUAL_CAI_YONG_HD',						'ERA_CLASSICAL',		'GREATWORK_CAI_YONG_HD_1',						'GREATWORKOBJECT_MUSIC'),
	-- 蔡文姬 《胡笳十八拍》
	('GREAT_PERSON_INDIVIDUAL_CAI_WEN_JI_HD',					'ERA_CLASSICAL',		'GREATWORK_CAI_WEN_JI_HD_1',					'GREATWORKOBJECT_MUSIC'),
	-- 桓伊 《梅花三弄》
	('GREAT_PERSON_INDIVIDUAL_HUAN_YI_HD',						'ERA_CLASSICAL',		'GREATWORK_HUAN_YI_HD_1',							'GREATWORKOBJECT_MUSIC'),
	-- 阮咸 《三峡流泉》
	('GREAT_PERSON_INDIVIDUAL_RUAN_XIAN_HD',					'ERA_CLASSICAL',		'GREATWORK_RUAN_XIAN_HD_1',						'GREATWORKOBJECT_MUSIC'),
	-- 阮籍 《酒狂》
	('GREAT_PERSON_INDIVIDUAL_RUAN_JI_HD',						'ERA_CLASSICAL',		'GREATWORK_RUAN_JI_HD_1',							'GREATWORKOBJECT_MUSIC'),
	-- 嵇康 《广陵散》
	('GREAT_PERSON_INDIVIDUAL_JI_KANG_HD',						'ERA_CLASSICAL',		'GREATWORK_JI_KANG_HD_1',							'GREATWORKOBJECT_MUSIC'),
	-- 苏祗婆
	('GREAT_PERSON_INDIVIDUAL_SU_ZHI_PO_HD',					'ERA_CLASSICAL',		NULL,																	NULL),
	---------------------------------------------------------------- 中世纪时代 ----------------------------------------------------------------
	-- 赵耶利 《胡笳五弄》
	('GREAT_PERSON_INDIVIDUAL_LIU_KUN_HD',						'ERA_MEDIEVAL',		  'GREATWORK_LIU_KUN_HD_1',							'GREATWORKOBJECT_MUSIC'),
	-- 万宝常
	('GREAT_PERSON_INDIVIDUAL_WANG_BAO_CHANG_HD',			'ERA_MEDIEVAL',			NULL,																	NULL),
	-- 李隆基 《霓裳羽衣曲》
	('GREAT_PERSON_INDIVIDUAL_LI_LONG_JI_HD',					'ERA_MEDIEVAL',			'GREATWORK_LI_LONG_JI_HD_1',					'GREATWORKOBJECT_MUSIC'),
	-- 李龟年 《渭川曲》
	('GREAT_PERSON_INDIVIDUAL_LI_GUI_NIAN_HD',				'ERA_MEDIEVAL',			'GREATWORK_LI_GUI_NIAN_HD_1',					'GREATWORKOBJECT_MUSIC'),
	-- 雷海青 《引梅敬酒歌》
	('GREAT_PERSON_INDIVIDUAL_LEI_HAI_QING_HD',				'ERA_MEDIEVAL',			'GREATWORK_LEI_HAI_QING_HD_1',				'GREATWORKOBJECT_MUSIC'),
	-- 董庭兰 《小胡笳》
	('GREAT_PERSON_INDIVIDUAL_DONG_TING_LAN_HD',			'ERA_MEDIEVAL',			'GREATWORK_DONG_TING_LAN_HD_1',				'GREATWORKOBJECT_MUSIC'),
	-- 毛敏仲 《平沙落雁》
	('GREAT_PERSON_INDIVIDUAL_MAO_MIN_ZHONG_HD',			'ERA_MEDIEVAL',			'GREATWORK_MAO_MIN_ZHONG_HD_1',				'GREATWORKOBJECT_MUSIC'),
	-- 姜夔 《扬州慢》
	('GREAT_PERSON_INDIVIDUAL_JIANG_KUI_HD',					'ERA_MEDIEVAL',			'GREATWORK_JIANG_KUI_HD_1',						'GREATWORKOBJECT_MUSIC'),
	-- 关汉卿 《窦娥冤》
	('GREAT_PERSON_INDIVIDUAL_GUAN_HAN_QING_HD',			'ERA_MEDIEVAL',			'GREATWORK_GUAN_HAN_QING_HD_1',				'GREATWORKOBJECT_MUSIC'),
	-- 白朴 《墙头马上》
	('GREAT_PERSON_INDIVIDUAL_BAI_PU_HD',							'ERA_MEDIEVAL',			'GREATWORK_BAI_PU_HD_1',							'GREATWORKOBJECT_MUSIC'),
	-- 郑光祖 《倩女离魂》
	('GREAT_PERSON_INDIVIDUAL_ZHENG_GUANG_ZU_HD',			'ERA_MEDIEVAL',			'GREATWORK_ZHENG_GUANG_ZU_HD_1',			'GREATWORKOBJECT_MUSIC'),
	-- 马致远 《汉宫秋》
	('GREAT_PERSON_INDIVIDUAL_MA_ZHI_YUAN_HD',				'ERA_MEDIEVAL',			'GREATWORK_MA_ZHI_YUAN_HD_1',					'GREATWORKOBJECT_MUSIC'),
	-- 王实甫 《西厢记》
	('GREAT_PERSON_INDIVIDUAL_WANG_SHI_FU_HD',				'ERA_MEDIEVAL',			'GREATWORK_WANG_SHI_FU_HD_1',					'GREATWORKOBJECT_MUSIC'),
	-- 弗朗切斯科·兰迪尼 《什么是爱情》
	('GREAT_PERSON_INDIVIDUAL_FRANCESCO_LANDINI_HD',	'ERA_MEDIEVAL',			'GREATWORK_FRANCESCO_LANDINI_HD_1',		'GREATWORKOBJECT_MUSIC'),
	---------------------------------------------------------------- 文艺复兴时代 ----------------------------------------------------------------
	-- 汤显祖 《临川四梦》
	('GREAT_PERSON_INDIVIDUAL_TANG_XIAN_ZU_HD',				'ERA_RENAISSANCE',	'GREATWORK_TANG_XIAN_ZU_HD_1',				'GREATWORKOBJECT_MUSIC'),
	-- 汤显祖 《紫箫记》
	('GREAT_PERSON_INDIVIDUAL_TANG_XIAN_ZU_HD',				'ERA_RENAISSANCE',	'GREATWORK_TANG_XIAN_ZU_HD_2',				'GREATWORKOBJECT_MUSIC'),
	-- 汤应曾 《十面埋伏》
	('GREAT_PERSON_INDIVIDUAL_TANG_YING_ZENG_HD',			'ERA_RENAISSANCE',	'GREATWORK_TANG_YING_ZENG_HD_1',			'GREATWORKOBJECT_MUSIC'),
	-- 汤应曾 《洞庭秋思》
	('GREAT_PERSON_INDIVIDUAL_TANG_YING_ZENG_HD',			'ERA_RENAISSANCE',	'GREATWORK_TANG_YING_ZENG_HD_2',			'GREATWORKOBJECT_MUSIC'),
	-- 肖鸾 《渔樵问答》
	('GREAT_PERSON_INDIVIDUAL_XIAO_LUAN_HD',					'ERA_RENAISSANCE',	'GREATWORK_XIAO_LUAN_HD_1',						'GREATWORKOBJECT_MUSIC'),
	-- 肖鸾 《石床读易》
	('GREAT_PERSON_INDIVIDUAL_XIAO_LUAN_HD',					'ERA_RENAISSANCE',	'GREATWORK_XIAO_LUAN_HD_2',						'GREATWORKOBJECT_MUSIC'),
	-- 高则诚 《琵琶记》
	('GREAT_PERSON_INDIVIDUAL_GAO_ZE_CHENG_HD',				'ERA_RENAISSANCE',	'GREATWORK_GAO_ZE_CHENG_HD_1',				'GREATWORKOBJECT_MUSIC'),
	-- 高则诚 《闵子骞单衣记》
	('GREAT_PERSON_INDIVIDUAL_GAO_ZE_CHENG_HD',				'ERA_RENAISSANCE',	'GREATWORK_GAO_ZE_CHENG_HD_2',				'GREATWORKOBJECT_MUSIC'),
	-- 朱载堉
	('GREAT_PERSON_INDIVIDUAL_ZHU_ZAI_YU_HD',					'ERA_RENAISSANCE',	NULL,																	NULL),
	-- 鞠士林 《夕阳箫鼓》
	('GREAT_PERSON_INDIVIDUAL_JU_SHI_LIN_HD',					'ERA_RENAISSANCE',	'GREATWORK_JU_SHI_LIN_HD_1',					'GREATWORKOBJECT_MUSIC'),
	-- 鞠士林 《闲叙幽音》
	('GREAT_PERSON_INDIVIDUAL_JU_SHI_LIN_HD',					'ERA_RENAISSANCE',	'GREATWORK_JU_SHI_LIN_HD_2',					'GREATWORKOBJECT_MUSIC'),
	-- 纪尧姆·迪费 《武士歌》
	('GREAT_PERSON_INDIVIDUAL_GUILLAUME_DUFAY_HD',		'ERA_RENAISSANCE',	'GREATWORK_GUILLAUME_DUFAY_HD_1',			'GREATWORKOBJECT_MUSIC'),
	-- 纪尧姆·迪费 《脸儿苍白》
	('GREAT_PERSON_INDIVIDUAL_GUILLAUME_DUFAY_HD',		'ERA_RENAISSANCE',	'GREATWORK_GUILLAUME_DUFAY_HD_2',			'GREATWORKOBJECT_MUSIC'),
	-- 若斯坎·德普雷 《圣母颂》
	('GREAT_PERSON_INDIVIDUAL_JOSQUIN_DES_PREZ_HD',		'ERA_RENAISSANCE',	'GREATWORK_JOSQUIN_DES_PREZ_HD_1',		'GREATWORKOBJECT_MUSIC'),
	-- 若斯坎·德普雷 《千般悔》
	('GREAT_PERSON_INDIVIDUAL_JOSQUIN_DES_PREZ_HD',		'ERA_RENAISSANCE',	'GREATWORK_JOSQUIN_DES_PREZ_HD_2',		'GREATWORKOBJECT_MUSIC'),
	-- 托马斯·塔利斯
	('GREAT_PERSON_INDIVIDUAL_THOMAS_TALLIS_HD',			'ERA_RENAISSANCE',	NULL,																	NULL),
	-- 威廉·伯德 《G大调幻想曲》
	('GREAT_PERSON_INDIVIDUAL_WILLIAM_BYRD_HD',				'ERA_RENAISSANCE',	'GREATWORK_WILLIAM_BYRD_HD_1',				'GREATWORKOBJECT_MUSIC'),
	-- 威廉·伯德 《内维尔夫人曲集》
	('GREAT_PERSON_INDIVIDUAL_WILLIAM_BYRD_HD',				'ERA_RENAISSANCE',	'GREATWORK_WILLIAM_BYRD_HD_2',				'GREATWORKOBJECT_MUSIC'),
	-- 托马斯·路易斯·德·维多利亚 《悼亡仪式》
	('GREAT_PERSON_INDIVIDUAL_TOMAS_LUIS_DE_VICTORIA_HD',				'ERA_RENAISSANCE',	'GREATWORK_TOMAS_LUIS_DE_VICTORIA_HD_1',				'GREATWORKOBJECT_MUSIC'),
	-- 托马斯·路易斯·德·维多利亚 《王国多么荣耀》
	('GREAT_PERSON_INDIVIDUAL_TOMAS_LUIS_DE_VICTORIA_HD',				'ERA_RENAISSANCE',	'GREATWORK_TOMAS_LUIS_DE_VICTORIA_HD_2',				'GREATWORKOBJECT_MUSIC');

insert or ignore into Types (Type, Kind)
	select GreatPersonIndividualType,	'KIND_GREAT_PERSON_INDIVIDUAL' from HD_NEW_MUSICIAN;

insert or ignore into GreatPersonIndividuals
	(GreatPersonIndividualType, Name, GreatPersonClassType, EraType, ActionCharges, ActionRequiresOwnedTile, Gender)
select
	GreatPersonIndividualType,
	'LOC_' || GreatPersonIndividualType || '_NAME',
	'GREAT_PERSON_CLASS_MUSICIAN',
	EraType,
	0,
	1,
	'M'
from HD_NEW_MUSICIAN;

update GreatPersonIndividuals set Gender = 'F' where GreatPersonIndividualType in ('GREAT_PERSON_INDIVIDUAL_LIU_XI_JUN_HD', 'GREAT_PERSON_INDIVIDUAL_CAI_WEN_JI_HD');
update GreatPersonIndividuals set ActionCharges = 1, ActionRequiresCompletedDistrictType = 'DISTRICT_CITY_CENTER' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_SU_ZHI_PO_HD';
update GreatPersonIndividuals set ActionCharges = 1, ActionRequiresCompletedDistrictType = 'DISTRICT_THEATER' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_WANG_BAO_CHANG_HD';
update GreatPersonIndividuals set ActionCharges = 1, ActionRequiresCompletedDistrictType = 'DISTRICT_CITY_CENTER' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_ZHU_ZAI_YU_HD';
update GreatPersonIndividuals set ActionCharges = 2, ActionRequiresCompletedDistrictType = 'DISTRICT_HOLY_SITE' where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_THOMAS_TALLIS_HD';

-- 伟人特效
insert or ignore into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,											ModifierId,																									AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_SU_ZHI_PO_HD',				'HD_SU_ZHI_PO_EXTRA_GREAT_MUSICIAN_POINTS',									'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_WANG_BAO_CHANG_HD',		'HD_WANG_BAO_CHANG_MUSIC_CULTURE_BONUS',										'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_WANG_BAO_CHANG_HD',		'HD_WANG_BAO_CHANG_MUSIC_TOURISM_BONUS',										'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_ZHU_ZAI_YU_HD',				'HD_ZHU_ZAI_YU_CAMPUS_BONUS',																'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_ZHU_ZAI_YU_HD',				'HD_ZHU_ZAI_YU_THEATER_BONUS',															'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_THOMAS_TALLIS_HD',		'HD_THOMAS_TALLIS_HOLY_SITE_TO_CULTURE',										'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	-- ('GREAT_PERSON_INDIVIDUAL_THOMAS_TALLIS_HD',		'HD_THOMAS_TALLIS_MUSIC_CULTURE_BONUS',											'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_THOMAS_TALLIS_HD',		'HD_THOMAS_TALLIS_MUSIC_TOURISM_BONUS',											'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY');

insert or replace into Modifiers
	(ModifierId,																							ModifierType,																												Permanent)
values
	('HD_SU_ZHI_PO_EXTRA_GREAT_MUSICIAN_POINTS',							'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS_PERCENT',								1),
	('HD_WANG_BAO_CHANG_MUSIC_CULTURE_BONUS',									'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD',											1),
	('HD_WANG_BAO_CHANG_MUSIC_TOURISM_BONUS',									'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',															1),
	('HD_THOMAS_TALLIS_HOLY_SITE_TO_CULTURE',									'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',		1),
	-- ('HD_THOMAS_TALLIS_MUSIC_CULTURE_BONUS',									'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD',											1),
	('HD_THOMAS_TALLIS_MUSIC_TOURISM_BONUS',									'MODIFIER_SINGLE_CITY_ADJUST_TOURISM',															1);

insert or replace into Modifiers
	(ModifierId,																							ModifierType,																							Permanent,	SubjectRequirementSetId)
values
	('HD_ZHU_ZAI_YU_CAMPUS_BONUS',														'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',					1,					'REQUIRES_DISTRICT_IS_DISTRICT_CAMPUS_UDMET'),
	('HD_ZHU_ZAI_YU_THEATER_BONUS',														'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER',					1,					'REQUIRES_DISTRICT_IS_DISTRICT_THEATER_UDMET');

insert or replace into ModifierArguments
	(ModifierId,																							Name,												Value)
values
	('HD_SU_ZHI_PO_EXTRA_GREAT_MUSICIAN_POINTS',							'GreatPersonClassType',			'GREAT_PERSON_CLASS_MUSICIAN'),
	('HD_SU_ZHI_PO_EXTRA_GREAT_MUSICIAN_POINTS',							'Amount',										25),
	('HD_WANG_BAO_CHANG_MUSIC_CULTURE_BONUS',									'ScalingFactor',						125),
	('HD_WANG_BAO_CHANG_MUSIC_CULTURE_BONUS',									'YieldType',								'YIELD_CULTURE'),
	('HD_WANG_BAO_CHANG_MUSIC_CULTURE_BONUS',									'GreatWorkObjectType',			'GREATWORKOBJECT_MUSIC'),
	('HD_WANG_BAO_CHANG_MUSIC_TOURISM_BONUS',									'ScalingFactor',						150),
	('HD_WANG_BAO_CHANG_MUSIC_TOURISM_BONUS',									'GreatWorkObjectType',			'GREATWORKOBJECT_MUSIC'),
	('HD_ZHU_ZAI_YU_CAMPUS_BONUS',														'YieldType',								'YIELD_SCIENCE'),
	('HD_ZHU_ZAI_YU_CAMPUS_BONUS',														'Amount',										100),
	('HD_ZHU_ZAI_YU_THEATER_BONUS',														'YieldType',								'YIELD_CULTURE'),
	('HD_ZHU_ZAI_YU_THEATER_BONUS',														'Amount',										100),
	('HD_THOMAS_TALLIS_HOLY_SITE_TO_CULTURE',									'YieldTypeToMirror',				'YIELD_FAITH'),
	('HD_THOMAS_TALLIS_HOLY_SITE_TO_CULTURE',									'YieldTypeToGrant',					'YIELD_CULTURE'),
	-- ('HD_THOMAS_TALLIS_MUSIC_CULTURE_BONUS',									'ScalingFactor',						200),
	-- ('HD_THOMAS_TALLIS_MUSIC_CULTURE_BONUS',									'YieldType',								'YIELD_CULTURE'),
	-- ('HD_THOMAS_TALLIS_MUSIC_CULTURE_BONUS',									'GreatWorkObjectType',			'GREATWORKOBJECT_MUSIC'),
	('HD_THOMAS_TALLIS_MUSIC_TOURISM_BONUS',									'ScalingFactor',						150),
	('HD_THOMAS_TALLIS_MUSIC_TOURISM_BONUS',									'GreatWorkObjectType',			'GREATWORKOBJECT_MUSIC');

	-- 描述
insert or ignore into ModifierStrings
	(ModifierId,																							Context,		Text)
values
	('HD_SU_ZHI_PO_EXTRA_GREAT_MUSICIAN_POINTS',							'Summary',	'LOC_SU_ZHI_PO_EXTRA_GREAT_MUSICIAN_POINTS_DESCRIPTION'),
	('HD_WANG_BAO_CHANG_MUSIC_CULTURE_BONUS',									'Summary',	'LOC_WANG_BAO_CHANG_MUSIC_CULTURE_BONUS_DESCRIPTION'),
	('HD_ZHU_ZAI_YU_CAMPUS_BONUS',														'Summary',	'LOC_ZHU_ZAI_YU_CAMPUS_BONUS_DESCRIPTION'),
	('HD_THOMAS_TALLIS_HOLY_SITE_TO_CULTURE',									'Summary',	'LOC_THOMAS_TALLIS_HOLY_SITE_TO_CULTURE_DESCRIPTION');