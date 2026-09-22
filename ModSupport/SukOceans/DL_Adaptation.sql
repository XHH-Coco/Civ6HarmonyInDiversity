-------------------------------------
--     Adaptation for the Mod      --
-------------------------------------

update Resources set LakeEligible = 1 where ResourceType = 'RESOURCE_SUK_LOBSTER';
update Resources set LakeEligible = 1 where ResourceType = 'RESOURCE_SUK_SEALS';

delete from Resource_YieldChanges where ResourceType = 'RESOURCE_SUK_SQUID' and YieldType = 'YIELD_GOLD';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_SUK_ABALONE' and YieldType = 'YIELD_FOOD';
delete from Resource_YieldChanges where ResourceType = 'RESOURCE_SUK_CORAL';
update Resource_YieldChanges set YieldChange = 4 where ResourceType = 'RESOURCE_SUK_CAVIAR' and YieldType = 'YIELD_GOLD';
update Resource_YieldChanges set YieldChange = 4 where ResourceType = 'RESOURCE_SUK_ABALONE' and YieldType = 'YIELD_GOLD';
insert or replace into Resource_YieldChanges
    (ResourceType,              YieldType,              YieldChange)
values
    ('RESOURCE_SUK_CORAL',      'YIELD_PRODUCTION',     1),
    ('RESOURCE_SUK_CORAL',      'YIELD_GOLD',           1),
    ('RESOURCE_SUK_LOBSTER',    'YIELD_GOLD',           1);

delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_FISHING_BOATS' and ModifierId = 'SUK_FISHERY_FOOD';
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_FISHING_BOATS' and ModifierId = 'SUK_FISHERY_PRODUCTION';

insert or replace into Improvement_ValidFeatures (ImprovementType, FeatureType) values
    ('IMPROVEMENT_FISHERY', 'FEATURE_SUK_KELP');

update BuildingModifiers set ModifierId = 'AQUATICS_CENTER_WONDER_TOURISM'
    where ModifierId = 'SUK_OCEANS_AQUATIC_CENTER_TOURISM';

delete from BuildingModifiers where ModifierId in ('SUK_OCEANS_AQUARIUM_SCIENCE', 'SUK_OCEANS_AQUARIUM_ADJACENT_SCIENCE');
insert or ignore into BuildingModifiers
        (BuildingType,          ModifierId)
values  ('BUILDING_AQUARIUM',   'AQUARIUM_SEARESOURCE_SCIENCE'),
        ('BUILDING_AQUARIUM',   'AQUARIUM_REEF_SCIENCE'),
        ('BUILDING_AQUARIUM',   'AQUARIUM_KELP_FOREST_SCIENCE');
insert or replace into Modifiers
        (ModifierId,                                ModifierType,                                       SubjectRequirementSetId)
values  ('AQUARIUM_KELP_FOREST_SCIENCE',            'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',      'SUK_OCEANS_AQUARIUM_KELP_REQUIREMENTS');
insert or replace into ModifierArguments
        (ModifierId,                                    Name,                   Value)
values  ('AQUARIUM_KELP_FOREST_SCIENCE',                'YieldType',            'YIELD_SCIENCE'),
        ('AQUARIUM_KELP_FOREST_SCIENCE',                'Amount',               1);
insert or replace into RequirementSets
        (RequirementSetId,                                          RequirementSetType)
values  ('SUK_OCEANS_AQUARIUM_KELP_REQUIREMENTS',                   'REQUIREMENTSET_TEST_ANY');
insert or replace into RequirementSetRequirements
        (RequirementSetId,                                          RequirementId)
values  ('SUK_OCEANS_AQUARIUM_KELP_REQUIREMENTS',                   'REQUIRES_PLOT_HAS_SUK_KELP');

insert or ignore into Resource_ValidFeatures
        (ResourceType,				FeatureType)
select	ResourceType,	            'FEATURE_REEF'
from Resources where ResourceType = 'RESOURCE_SUK_CAVIAR';

-- 水族馆适配 xhh
delete from BuildingModifiers where ModifierId = 'AQUARIUM_KELP_FOREST_SCIENCE';

--------------------------------------------------------------------------------
-- from multi mode
update Features set RemoveTech = 'TECH_SAILING' where FeatureType = 'FEATURE_SUK_KELP';
