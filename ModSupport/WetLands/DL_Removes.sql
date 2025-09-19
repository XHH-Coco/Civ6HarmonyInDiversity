-------------------------------------
-- Remove Adjustments from the Mod --
-------------------------------------

-- remove tundra floodplains.
delete from Types where Type = 'FEATURE_FLOODPLAINS_TUNDRA';
delete from Types where Type = 'IMPROVEMENT_JNR_FLOOD_FARM';
delete from Types where Type = 'RESOURCE_JNR_SWAMP';
-- delete from Types where Type = 'RESOURCE_JNR_PEAT';

delete from Types where Type = 'FEATURE_JNR_SWAMP';
delete from BuildingModifiers where BuildingType = 'BUILDING_BIOSPHERE' and ModifierId = 'BIOSPHERE_ADJUST_APPEAL_JNR_SWAMP';
delete from BuildingModifiers where BuildingType = 'BUILDING_ZOO' and ModifierId = 'ZOO_JNR_SWAMP_SCIENCE';
delete from AiFavoredItems where StringVal = 'FEATURE_JNR_SWAMP';
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_VIETNAM' and ModifierId = 'TRAIT_DISTRICTS_JNR_SWAMP_ONLY';
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_VIETNAM' and ModifierId = 'TRAIT_JNR_SWAMP_BUILDINGS_FOOD';
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_CLEOPATRA_ALT' and ModifierId = 'CLEOPATRA_JNR_SWAMP_APPEAL';

delete from Adjacency_YieldChanges where ID = 'Flood_Farms_MechanizedAdjacency';
delete from Improvement_Adjacencies where YieldChangeId = 'Flood_Farms_MechanizedAdjacency';
delete from RandomEvent_Yields where FeatureType = 'FEATURE_FLOODPLAINS_TUNDRA';
delete from TraitModifiers where ModifierId = 'CLEOPATRA_TUNDRA_FLOODPLAINS_APPEAL';

delete from RequirementSetRequirements where RequirementId = 'REQUIRES_PLOT_HAS_JNR_SWAMP' and RequirementSetId in (
    'CHOKE_POINTS_PLOT_REQUIREMENTS', 'TRIEU_FEATURE_REQUIREMENTS'
);

insert or ignore into Types
    (Type,                  Kind)
values
    ('FEATURE_HD_SWAMP',    'KIND_FEATURE');

insert or replace into Features
    (FeatureType,           Name,                           MovementChange,     SightThroughModifier,   RemoveTech,         Removable,  DefenseModifier,    Appeal, AntiquityPriority)
values
    ('FEATURE_HD_SWAMP',    'LOC_FEATURE_HD_SWAMP_NAME',    1,                  1,                      'TECH_IRRIGATION',  1,          3,                  1,      5);

insert or replace into Improvement_ValidResources
	(ImprovementType,			ResourceType,           MustRemoveFeature)
values
    ('IMPROVEMENT_QUARRY',      'RESOURCE_JNR_PEAT',    0);