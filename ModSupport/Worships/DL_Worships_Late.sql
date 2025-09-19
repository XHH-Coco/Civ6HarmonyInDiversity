-- 道观
insert or replace into BuildingModifiers (BuildingType, ModifierId)
	select 'BUILDING_JNR_DAOGUAN', 'HD_DAOGUAN_' || GreatPersonClassType || '_POINTS'
from DistrictCorrespondingGPP_HD;

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)	
	select 'HD_DAOGUAN_' || GreatPersonClassType || '_POINTS', 'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS', 'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET'
from DistrictCorrespondingGPP_HD;

insert or replace into ModifierArguments (ModifierId, name, value)
	select 'HD_DAOGUAN_' || GreatPersonClassType || '_POINTS', 'GreatPersonClassType', GreatPersonClassType
from DistrictCorrespondingGPP_HD;

insert or replace into ModifierArguments (ModifierId, name, value)
	select 'HD_DAOGUAN_' || GreatPersonClassType || '_POINTS', 'Amount', 6
from DistrictCorrespondingGPP_HD;