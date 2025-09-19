--越南
insert or replace into TraitModifiers (TraitType,   ModifierId) 
    select 'TRAIT_CIVILIZATION_VIETNAM', 'TRAIT_SAVANNAH_VALID_' || DistrictType from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into Modifiers    (ModifierId, ModifierType)
    select 'TRAIT_SAVANNAH_VALID_' || DistrictType, 'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS' 
    from Districts where DistrictType != 'DISTRICT_CITY_CENTER';   
insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
    select 'TRAIT_SAVANNAH_VALID_' || DistrictType, 'DistrictType', DistrictType
    from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
    select 'TRAIT_SAVANNAH_VALID_' || DistrictType, 'FeatureType', 'FEATURE_JNR_SAVANNAH'
    from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into TraitModifiers 
    (TraitType,                             ModifierId)
values
    ('TRAIT_CIVILIZATION_VIETNAM',          'TRAIT_SAVANNAH_FAITH'),
    ('TRAIT_CIVILIZATION_VIETNAM',          'TRAIT_SAVANNAH_BUILDINGS_FAITH');

insert or replace into Modifiers
    (ModifierId,                            ModifierType,                                                       SubjectRequirementSetId)
values
    ('TRAIT_SAVANNAH_FAITH',                'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',                    'HD_PLOT_HAS_FEATURE_JNR_SAVANNAH'),
    ('TRAIT_SAVANNAH_BUILDINGS_FAITH',      'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_FEATURE_YIELD_CHANGE',      NULL);

insert or replace into ModifierArguments    
    (ModifierId,                            Name,               Value) 
values
    ('TRAIT_SAVANNAH_FAITH',                'Amount',           2),
    ('TRAIT_SAVANNAH_FAITH',                'YieldType',        'YIELD_FAITH'),
    ('TRAIT_SAVANNAH_BUILDINGS_FAITH',	    'FeatureType',      'FEATURE_JNR_SAVANNAH'),
    ('TRAIT_SAVANNAH_BUILDINGS_FAITH',	    'YieldType',        'YIELD_FAITH'),
    ('TRAIT_SAVANNAH_BUILDINGS_FAITH',	    'Amount',           2);