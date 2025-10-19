--Resource_ValidFeatures
insert or replace into Resource_ValidFeatures
    (ResourceType,                  FeatureType)
select
    ResourceType,                   'FEATURE_JNR_SAVANNAH'
from Resources where ResourceType in
	('RESOURCE_COPPER',
	'RESOURCE_SILVER',
    'RESOURCE_HORSES',
    'RESOURCE_IRON',
    'RESOURCE_ALOE',
    'RESOURCE_DYES',
	'RESOURCE_LAPIS',
	'RESOURCE_LION',
    'RESOURCE_INCENSE',
    'RESOURCE_COTTON',
    'RESOURCE_SALT',
    'RESOURCE_TOMATO',
    'RESOURCE_GRANITE',
    'RESOURCE_SORGHUM',
    'RESOURCE_MAIZE',
    'RESOURCE_DATES',
    'RESOURCE_PLATINUM',
    'RESOURCE_RUBY',
    'RESOURCE_WOLF',
    'RESOURCE_BAMBOO',
    'RESOURCE_TIGER',
    'RESOURCE_POTATO',
    'RESOURCE_MUSHROOMS');
insert or replace into Resource_ValidFeatures
    (ResourceType,                  FeatureType)
select
    'RESOURCE_SUK_CHEESE',          'FEATURE_JNR_SAVANNAH'
where exists (select ResourceType from Resources where ResourceType = 'RESOURCE_SUK_CHEESE');

--Adjacency
delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_COLOSSAL_HEAD' and YieldChangeId = 'ColossalHead_FaithJNRSavannahLate';
update Adjacency_YieldChanges set TilesRequired = 1 where ID = 'JNR_Savannah_Faith';
update Adjacency_YieldChanges set TilesRequired = 1, ObsoleteCivic = NULL where ID = 'ColossalHead_FaithJNRSavannahEarly';
insert or ignore into Adjacency_YieldChanges
		(ID,								Description,						YieldType,		YieldChange,	TilesRequired,	AdjacentFeature)
values	('Savannah_Gold',			        'LOC_DISTRICT_SAVANNAH_GOLD',	    'YIELD_GOLD',	1,				1,				'FEATURE_JNR_SAVANNAH');
insert or ignore into District_Adjacencies
		(DistrictType,	YieldChangeId)
select	DistrictType,	'Savannah_Gold'
from	District_Adjacencies
where	YieldChangeId='River_Gold';

--Resource_ValidTerrains
delete from Resource_ValidTerrains where ResourceType = 'RESOURCE_IVORY' and TerrainType = 'TERRAIN_DESERT';

--Feature_YieldChanges
insert or replace into Feature_YieldChanges
	(FeatureType,			    YieldType,			YieldChange)
values
	('FEATURE_FLOODPLAINS',	    'YIELD_FOOD',		2),
	('FEATURE_FLOODPLAINS',     'YIELD_GOLD',		1),
	('FEATURE_JNR_SAVANNAH',    'YIELD_GOLD',		1);

--Feature_Removes
update Feature_Removes set Yield = 12 where FeatureType = 'FEATURE_JNR_SAVANNAH';

--Movement
update Features set MovementChange = 0 where FeatureType = 'FEATURE_JNR_SAVANNAH';

--SightThroughModifier
update Features set SightThroughModifier = 0 where FeatureType = 'FEATURE_JNR_SAVANNAH';

--ui
insert or replace into Improvement_ValidFeatures
    (ImprovementType,                   FeatureType)
select
    ImprovementType,                    'FEATURE_JNR_SAVANNAH'
from Improvements where ImprovementType in
    ('IMPROVEMENT_LEU_STATION',
	'IMPROVEMENT_HACIENDA',
    'IMPROVEMENT_OUTBACK_STATION',
    'IMPROVEMENT_OPEN_AIR_MUSEUM',
    'IMPROVEMENT_GEDEMO_DZIMBABWE',
    'IMPROVEMENT_PYRAMID',
    'IMPROVEMENT_CVS_BERBER_UI',
    'IMPROVEMENT_CHEMAMULL');
insert or replace into Improvement_ValidFeatures
    (ImprovementType,                   FeatureType,                PrereqTech)
values
    ('IMPROVEMENT_MEKEWAP',              'FEATURE_JNR_SAVANNAH',     'TECH_MINING');

--modifier
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_VIETNAM' and ModifierId = 'TRAIT_DISTRICTS_JNR_SAVANNAH_ONLY';
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_VIETNAM' and ModifierId = 'TRAIT_JNR_SAVANNAH_BUILDINGS_FAITH';
delete from BuildingModifiers where BuildingType = 'BUILDING_ZOO' and ModifierId = 'ZOO_JNR_SAVANNAH_SCIENCE';

insert or replace into TraitModifiers
	(TraitType,								ModifierId)
select
	'TRAIT_LEADER_MAJOR_CIV',				'TRAIT_PRESERVE_VALID_SAVANNAH'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_JNR_SAVANNAH');
insert or replace into Modifiers
	(ModifierId,								ModifierType,														SubjectRequirementSetId)
values
	('TRAIT_PRESERVE_VALID_SAVANNAH',			'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS',			NULL);
insert or replace into ModifierArguments
	(ModifierId,								Name,			Value)
values
	('TRAIT_PRESERVE_VALID_SAVANNAH',			'DistrictType',	'DISTRICT_PRESERVE'),
	('TRAIT_PRESERVE_VALID_SAVANNAH',			'FeatureType',	'FEATURE_JNR_SAVANNAH');

--毛利
insert or replace into TraitModifiers
	(TraitType,							ModifierId)
values
	('TRAIT_CIVILIZATION_MAORI_MANA',	'TRAIT_MAORI_SAVANNAH');
insert or replace into Modifiers
	(ModifierId,						ModifierType,							SubjectRequirementSetId)
values
	('TRAIT_MAORI_SAVANNAH',		    'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',	'PLOT_HAS_SAVANNAH_TECH_ASTROLOGY_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,						Name,				Value)
values
	('TRAIT_MAORI_SAVANNAH',			'YieldType',		'YIELD_PRODUCTION'),
	('TRAIT_MAORI_SAVANNAH',			'Amount',			1);
insert or ignore into RequirementSets
	(RequirementSetId,										RequirementSetType)
values
	('PLOT_HAS_SAVANNAH_TECH_ASTROLOGY_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,										RequirementId)
values
	('PLOT_HAS_SAVANNAH_TECH_ASTROLOGY_REQUIREMENTS',		'HD_REQUIRES_PLOT_HAS_FEATURE_JNR_SAVANNAH'),
	('PLOT_HAS_SAVANNAH_TECH_ASTROLOGY_REQUIREMENTS',		'HD_REQUIRES_PLAYER_HAS_TECH_ASTROLOGY');

--佩特拉
update Modifiers set SubjectRequirementSetId = 'SAVANNAH_PETRA_YIELD_MODIFIER_REQUIREMENTS' where ModifierId = 'PETRA_YIELD_MODIFIER';
insert or ignore into RequirementSets
    (RequirementSetId,                              RequirementSetType)
values 
    ('SAVANNAH_PETRA_YIELD_MODIFIER_REQUIREMENTS',  'REQUIREMENTSET_TEST_ALL');
insert or ignore into RequirementSetRequirements
    (RequirementSetId,                              RequirementId)
values 
    ('SAVANNAH_PETRA_YIELD_MODIFIER_REQUIREMENTS',  'PETRA_YIELD_MODIFIER_REQUIRES_PLOT_HAS_DESERT'),
    ('SAVANNAH_PETRA_YIELD_MODIFIER_REQUIREMENTS',  'REQUIRES_PLOT_HAS_NO_FLOODPLAINS'),
    ('SAVANNAH_PETRA_YIELD_MODIFIER_REQUIREMENTS',  'REQUIRES_OBJECT_WITHIN_5_TILES'),
    ('SAVANNAH_PETRA_YIELD_MODIFIER_REQUIREMENTS',  'REQUIRES_PLOT_HAS_NO_SAVANNAH');
insert or ignore into Requirements
    (RequirementId,                     RequirementType,                            Inverse)
values 
    ('REQUIRES_PLOT_HAS_NO_SAVANNAH',   'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES',    1);
insert or ignore into RequirementArguments
    (RequirementId,                     Name,                                       Value)
values 
    ('REQUIRES_PLOT_HAS_NO_SAVANNAH',   'FeatureType',                              'FEATURE_JNR_SAVANNAH');
