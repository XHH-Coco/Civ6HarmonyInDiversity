-- 学院加大作家点，圣地加大艺大音点
insert or replace into BuildingModifiers
	(BuildingType,	ModifierId)
select
	ObjectType,			'HD_AI_DISTRICT_THEATER_GREAT_PERSON_CLASS_WRITER'
from HD_AIGreatPersonPoints where ObjectType in (select BuildingType from Buildings where PrereqDistrict = 'DISTRICT_CAMPUS');

insert or replace into BuildingModifiers
	(BuildingType,	ModifierId)
select
	ObjectType,			'HD_AI_DISTRICT_THEATER_GREAT_PERSON_CLASS_ARTIST'
from HD_AIGreatPersonPoints where ObjectType in (select BuildingType from Buildings where PrereqDistrict = 'DISTRICT_HOLY_SITE');

insert or replace into BuildingModifiers
	(BuildingType,	ModifierId)
select
	ObjectType,			'HD_AI_DISTRICT_THEATER_GREAT_PERSON_CLASS_MUSICIAN'
from HD_AIGreatPersonPoints where ObjectType in (select BuildingType from Buildings where PrereqDistrict = 'DISTRICT_HOLY_SITE');

insert or replace into DistrictModifiers
	(DistrictType,						ModifierId)
values
	('DISTRICT_CAMPUS',				'HD_AI_DISTRICT_THEATER_GREAT_PERSON_CLASS_WRITER'),
	('DISTRICT_SEOWON',				'HD_AI_DISTRICT_THEATER_GREAT_PERSON_CLASS_WRITER'),
	('DISTRICT_HOLY_SITE',		'HD_AI_DISTRICT_THEATER_GREAT_PERSON_CLASS_ARTIST'),
	('DISTRICT_HOLY_SITE',		'HD_AI_DISTRICT_THEATER_GREAT_PERSON_CLASS_MUSICIAN');

------------------------------------------------------------------
-- 神级ai增加通用巨作槽位
-- 神级ai学院剧院产出翻倍
insert or replace into TraitModifiers
	(TraitType,										ModifierId)
values
	('TRAIT_LEADER_MAJOR_CIV',		'AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_PALACE_GREATWORKSLOT'),
	('TRAIT_LEADER_MAJOR_CIV',		'AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_MONUMENT_GREATWORKSLOT'),
	('TRAIT_LEADER_MAJOR_CIV',		'AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS'),
	('TRAIT_LEADER_MAJOR_CIV',		'AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS2'),
	('TRAIT_LEADER_MAJOR_CIV',		'AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS'),
	('TRAIT_LEADER_MAJOR_CIV',		'AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS2');

insert or replace into Modifiers
	(ModifierId,																									ModifierType,																														OwnerRequirementSetId)
values
	('AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_PALACE_GREATWORKSLOT',		'MODIFIER_PLAYER_CITIES_ADJUST_EXTRA_GREAT_WORK_SLOTS',									'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_MONUMENT_GREATWORKSLOT',	'MODIFIER_PLAYER_CITIES_ADJUST_EXTRA_GREAT_WORK_SLOTS',									'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS2',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS2',			'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_MODIFIERS_FOR_DISTRICT',	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI');

insert or replace into ModifierArguments
	(ModifierId,																										Name,								Value)
values
	('AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_PALACE_GREATWORKSLOT',			'BuildingType',			'BUILDING_PALACE'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_PALACE_GREATWORKSLOT',			'GreatWorkSlotType','GREATWORKSLOT_PALACE'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_PALACE_GREATWORKSLOT',			'Amount',						5),
	('AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_MONUMENT_GREATWORKSLOT',		'BuildingType',			'BUILDING_MONUMENT'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_MONUMENT_GREATWORKSLOT',		'GreatWorkSlotType','GREATWORKSLOT_PALACE'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_EXTRA_MONUMENT_GREATWORKSLOT',		'Amount',						2),
	('AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS',					'DistrictType',			'DISTRICT_CAMPUS'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS',					'YieldType',				'YIELD_SCIENCE'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS',					'Amount',						100),
	('AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS2',					'DistrictType',			'DISTRICT_CAMPUS'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS2',					'YieldType',				'YIELD_CULTURE'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_CAMPUS_BUILDING_BONUS2',					'Amount',						100),
	('AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS',					'DistrictType',			'DISTRICT_THEATER'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS',					'YieldType',				'YIELD_SCIENCE'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS',					'Amount',						100),
	('AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS2',				'DistrictType',			'DISTRICT_THEATER'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS2',				'YieldType',				'YIELD_CULTURE'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_THEATER_BUILDING_BONUS2',				'Amount',						100);
------------------------------------------------------------------
-- 神级ai市政建筑送移民
-- insert or replace into TraitModifiers
-- 	(TraitType,										ModifierId)
-- select
-- 	'TRAIT_LEADER_MAJOR_CIV',			'AI_AT_LEAST_DEITY_DIFFICULTY_' || BuildingType || '_EXTRA_SETTLER'
-- from Buildings where PrereqDistrict = 'DISTRICT_GOVERNMENT';

-- insert or replace into Modifiers
-- 	(ModifierId,																														ModifierType,															OwnerRequirementSetId,										SubjectRequirementSetId)
-- select
-- 	'AI_AT_LEAST_DEITY_DIFFICULTY_' || BuildingType || '_EXTRA_SETTLER',		'MODIFIER_PLAYER_GRANT_UNIT_IN_CAPITAL',	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI',	'PLAYER_HAS_' || BuildingType || '_REQUIREMENTS'
-- from Buildings where PrereqDistrict = 'DISTRICT_GOVERNMENT';

-- insert or replace into ModifierArguments
-- 	(ModifierId,																														Name,					Value)
-- select
-- 	'AI_AT_LEAST_DEITY_DIFFICULTY_' || BuildingType || '_EXTRA_SETTLER',		'UnitType',		'UNIT_SETTLER'
-- from Buildings where PrereqDistrict = 'DISTRICT_GOVERNMENT';

-- insert or replace into ModifierArguments
-- 	(ModifierId,																														Name,					Value)
-- select
-- 	'AI_AT_LEAST_DEITY_DIFFICULTY_' || BuildingType || '_EXTRA_SETTLER',		'Amount',			1
-- from Buildings where PrereqDistrict = 'DISTRICT_GOVERNMENT';

-- insert or replace into ModifierArguments
-- 	(ModifierId,																														Name,										Value)
-- select
-- 	'AI_AT_LEAST_DEITY_DIFFICULTY_' || BuildingType || '_EXTRA_SETTLER',		'AllowUniqueOverride',	0
-- from Buildings where PrereqDistrict = 'DISTRICT_GOVERNMENT';
------------------------------------------------------------------
update PseudoYields set DefaultValue = 1.1 where PseudoYieldType = 'PSEUDOYIELD_WONDER';