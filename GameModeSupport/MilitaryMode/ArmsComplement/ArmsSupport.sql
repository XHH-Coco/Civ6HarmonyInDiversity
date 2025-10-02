insert or replace into UnitAbilities
    (UnitAbilityType,                                   Name,                                           Description)
values
    ("ABILITY_ENGINEER_HEAL_HD",                        "LOC_ABILITY_ENGINEER_HEAL_HD_NAME",             "LOC_ABILITY_ENGINEER_HEAL_HD_DESCRIPTION");

insert or replace into Types
	(Type,											    Kind)
values
    ("ABILITY_ENGINEER_HEAL_HD",                        "KIND_ABILITY");

insert or replace into TypeTags
    (Type,                                              Tag)
values
    ("ABILITY_ENGINEER_HEAL_HD",                        "CLASS_MILITARY_ENGINEER");

insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                                   ModifierId)
values
    ("ABILITY_ENGINEER_HEAL_HD",                        "MILITARY_ENGINEER_HEAL_HD");

insert or replace into Modifiers
    (ModifierId,                                        ModifierType,                                                           SubjectRequirementSetId)
values
    ("MILITARY_ENGINEER_HEAL_HD",                       "MODIFIER_PLAYER_UNITS_ADJUST_HEAL_PER_TURN",                           "MEDIC_HEALING_REQUIREMENTS");

insert or replace into ModifierArguments
    (ModifierId,                                        Name,                   Value)
values
    ("MILITARY_ENGINEER_HEAL_HD",                       "Amount",               10),
    ("MILITARY_ENGINEER_HEAL_HD",                       "Type",                 "ALL");


With Unit_BuildingPrereqs_Pre
    (Unit,PrereqBuilding)
as (values
      ("UNIT_ENGINEER_CORP","BUILDING_JNR_ARSENAL"),
      ("UNIT_ENGINEER_CORP","BUILDING_JNR_PRISON"),
      ("UNIT_ENGINEER_CORP","BUILDING_JNR_NAVAL_BASE"))
insert or replace into Unit_BuildingPrereqs
    (Unit,                                              PrereqBuilding)
select
    Unit_BuildingPrereqs_Pre.Unit,     Unit_BuildingPrereqs_Pre.PrereqBuilding
from Unit_BuildingPrereqs_Pre INNER JOIN Buildings ON Buildings.BuildingType = Unit_BuildingPrereqs_Pre.PrereqBuilding;

insert or replace into Improvement_ValidBuildUnits
    (ImprovementType,           UnitType)
select
    'IMPROVEMENT_LEU_STATION',  'UNIT_ENGINEER_CORP'
where exists (select ImprovementType from Improvements where ImprovementType = 'IMPROVEMENT_LEU_STATION');

update UnitReplaces set ReplacesUnitType = 'UNIT_VELITE' where CivUniqueUnitType = 'UNIT_INCA_WARAKAQ';

update Improvements set PrereqTech = NULL, PrereqCivic = 'CIVIC_DEFENSIVE_TACTICS' where ImprovementType = 'IMPROVEMENT_FORT';