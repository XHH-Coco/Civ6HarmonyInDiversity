
insert or replace into TraitModifiers
    (TraitType,                             ModifierId)
values
    ('TRAIT_LEADER_MAJOR_CIV',              'HD_AI_GET_COPY_FOR_MILITARY_UNITS');

insert or ignore into Modifiers
    (ModifierId,                                ModifierType,                                       OwnerRequirementSetId)
values
    ('HD_AI_GET_COPY_FOR_MILITARY_UNITS',       'MODIFIER_PLAYER_UNITS_ADJUST_EXTRA_UNIT_COPY_TAG', 'PLAYER_IS_AI'); 

insert or ignore into ModifierArguments
    (ModifierId,                                Name,         Value)
values
    ('HD_AI_GET_COPY_FOR_MILITARY_UNITS',       'Tag',        'CLASS_MILITARY'),
    ('HD_AI_GET_COPY_FOR_MILITARY_UNITS',       'Amount',     '1');

UPDATE PseudoYields SET DefaultValue = 1.5 WHERE PseudoYieldType = 'PSEUDOYIELD_STANDING_ARMY_NUMBER'; --  1 -- controls size of the army
UPDATE PseudoYields SET DefaultValue = 0.2 WHERE PseudoYieldType = 'PSEUDOYIELD_STANDING_ARMY_VALUE'; --   0.1 -- controls size of the army

update Resource_Consumption set ImprovedExtractionRate = ImprovedExtractionRate + 1;
