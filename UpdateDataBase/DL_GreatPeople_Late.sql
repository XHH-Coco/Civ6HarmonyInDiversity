-- 苏祗婆
	-- 建筑加产
insert or ignore into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,									ModifierId,																									AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_SU_ZHI_PO_HD',			'HD_SU_ZHI_PO_' || BuildingType || '_CULTURE_BONUS',			  'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'
from Building_GreatWorks where GreatWorkSlotType = 'GREATWORKSLOT_MUSIC';

insert or replace into Modifiers
	(ModifierId,																							ModifierType,																		Permanent)
select
	'HD_SU_ZHI_PO_' || BuildingType || '_CULTURE_BONUS',			'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD',		1
from Building_GreatWorks where GreatWorkSlotType = 'GREATWORKSLOT_MUSIC';

insert or replace into ModifierArguments
	(ModifierId,																							Name,										Value)
select
	'HD_SU_ZHI_PO_' || BuildingType || '_CULTURE_BONUS',			'BuildingType',					BuildingType
from Building_GreatWorks where GreatWorkSlotType = 'GREATWORKSLOT_MUSIC';

insert or replace into ModifierArguments
	(ModifierId,																							Name,										Value)
select
	'HD_SU_ZHI_PO_' || BuildingType || '_CULTURE_BONUS',			'YieldType',						'YIELD_CULTURE'
from Building_GreatWorks where GreatWorkSlotType = 'GREATWORKSLOT_MUSIC';

insert or replace into ModifierArguments
	(ModifierId,																							Name,										Value)
select
	'HD_SU_ZHI_PO_' || BuildingType || '_CULTURE_BONUS',			'Amount',								2
from Building_GreatWorks where GreatWorkSlotType = 'GREATWORKSLOT_MUSIC';