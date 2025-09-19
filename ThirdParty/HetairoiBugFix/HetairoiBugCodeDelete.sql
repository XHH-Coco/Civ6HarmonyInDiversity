-- HetairoiBugCodeDelete
-- Author: Amazer
-- DateCreated: 8/1/2020 2:20:10 AM
--------------------------------------------------------------

-- Modifier
DELETE FROM UnitAbilityModifiers WHERE ModifierId='HETAIROI_GREAT_GENERAL_COMBAT_BONUS';
DELETE FROM Modifiers WHERE ModifierId='HETAIROI_GREAT_GENERAL_COMBAT_BONUS';
DELETE FROM ModifierArguments WHERE ModifierId='HETAIROI_GREAT_GENERAL_COMBAT_BONUS';
DELETE FROM ModifierStrings WHERE ModifierId='HETAIROI_GREAT_GENERAL_COMBAT_BONUS';

-- Requirement
-- DELETE FROM RequirementSets WHERE ;
-- DELETE FROM RequirementSetRequirements WHERE ;
-- DELETE FROM Requirements WHERE ;
-- DELETE FROM RequirementArguments WHERE ;