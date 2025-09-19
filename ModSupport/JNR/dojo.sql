update Buildings set
  PrereqCivic = 'CIVIC_FEUDALISM',
  Cost = 300,
  Description = 'LOC_BUILDING_JNR_DOJO_HD_DESCRIPTION',
  Maintenance = 4,
  AdvisorType = 'ADVISOR_CULTURE'
where BuildingType = 'BUILDING_JNR_DOJO';

delete from Building_YieldChanges where BuildingType = 'BUILDING_JNR_DOJO';

update Building_GreatPersonPoints set PointsPerTurn = 2 where BuildingType = 'BUILDING_JNR_DOJO';
insert or replace into Building_GreatPersonPoints
  (BuildingType,            GreatPersonClassType,           PointsPerTurn)
values
  ('BUILDING_JNR_DOJO',     'GREAT_PERSON_CLASS_MUSICIAN',  2);

delete from Building_GreatWorks where BuildingType = 'BUILDING_JNR_DOJO';
insert or replace into Building_GreatWorks
  (BuildingType,            GreatWorkSlotType,        NumSlots)
values
  ('BUILDING_JNR_DOJO',     'GREATWORKSLOT_WRITING', 1),
  ('BUILDING_JNR_DOJO',     'GREATWORKSLOT_ART', 1),
  ('BUILDING_JNR_DOJO',     'GREATWORKSLOT_MUSIC', 1);

insert or replace into Building_CitizenYieldChanges
  (BuildingType,            YieldType,        YieldChange)
values
  ('BUILDING_JNR_DOJO',     'YIELD_CULTURE',  1),
  ('BUILDING_JNR_DOJO',     'YIELD_GOLD',     -1);

delete from BuildingModifiers where BuildingType = 'BUILDING_JNR_DOJO';

-- 训练单位经验
insert or replace into BuildingModifiers
  (BuildingType,            ModifierId)
values
  ('BUILDING_JNR_DOJO',     'HD_JNR_DOJO_UNIT_EXP');

insert or replace into Modifiers
  (ModifierId,                  ModifierType,                                             Permanent)
values
  ('HD_JNR_DOJO_UNIT_EXP',      'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',   1),
  ('JNR_DOJO_TRAINED_UNIT_XP',  'MODIFIER_PLAYER_UNIT_ADJUST_UNIT_EXPERIENCE_MODIFIER',   1);

insert or replace into ModifierArguments
  (ModifierId,							    Name,					  Value)
values
  ('HD_JNR_DOJO_UNIT_EXP',      'AbilityType',  'ABILITY_JNR_DOJO_TRAINED_UNIT_XP'),
  ('JNR_DOJO_TRAINED_UNIT_XP',  'Amount',       25);

insert or ignore into Types
  (Type,                                Kind)
values
  ('ABILITY_JNR_DOJO_TRAINED_UNIT_XP',  'KIND_ABILITY');

insert or replace into UnitAbilities
  (UnitAbilityType,							        Description,												                Inactive)
values
  ('ABILITY_JNR_DOJO_TRAINED_UNIT_XP',  'LOC_ABILITY_JNR_DOJO_TRAINED_UNIT_XP_DESCRIPTION', 1);

insert or replace into TypeTags
  (Type,										            Tag)
select
  'ABILITY_JNR_DOJO_TRAINED_UNIT_XP',   Tag
from TypeTags where Type in ('ABILITY_ARMORY_TRAINED_UNIT_XP', 'ABILITY_SEAPORT_TRAINED_UNIT_XP');

insert or replace into UnitAbilityModifiers
  (UnitAbilityType,							        ModifierId)
values
  ('ABILITY_JNR_DOJO_TRAINED_UNIT_XP',	'JNR_DOJO_TRAINED_UNIT_XP');

-- 巨作产出
	-- 本城巨作文化产出
insert or replace into BuildingModifiers
	(BuildingType,									ModifierId)
select
	'BUILDING_JNR_DOJO',					  'JNR_DOJO_' || GreatWorkObjectType || '_CULTURE_MODIFIER'
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into Modifiers
	(ModifierId,																													ModifierType)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_CULTURE_MODIFIER',						'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD'
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into ModifierArguments
	(ModifierId,																													Name,										Value)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_CULTURE_MODIFIER',						'ScalingFactor',				150
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into ModifierArguments
	(ModifierId,																													Name,										Value)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_CULTURE_MODIFIER',						'YieldType',						'YIELD_CULTURE'
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into ModifierArguments
	(ModifierId,																													Name,										Value)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_CULTURE_MODIFIER',						'GreatWorkObjectType',	GreatWorkObjectType
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

	-- 本城巨作业绩产出
insert or replace into BuildingModifiers
	(BuildingType,									ModifierId)
select
	'BUILDING_JNR_DOJO',					  'JNR_DOJO_' || GreatWorkObjectType || '_TOURISM_MODIFIER'
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into Modifiers
	(ModifierId,																													ModifierType)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_TOURISM_MODIFIER',						'MODIFIER_SINGLE_CITY_ADJUST_TOURISM'
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into ModifierArguments
	(ModifierId,																													Name,										Value)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_TOURISM_MODIFIER',						'ScalingFactor',				150
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into ModifierArguments
	(ModifierId,																													Name,										Value)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_TOURISM_MODIFIER',						'GreatWorkObjectType',	GreatWorkObjectType
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

	-- 本城巨作生产力产出
insert or replace into BuildingModifiers
	(BuildingType,									ModifierId)
select
	'BUILDING_JNR_DOJO',					  'JNR_DOJO_' || GreatWorkObjectType || '_PRODUCTION_MODIFIER'
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into Modifiers
	(ModifierId,																													  ModifierType)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_PRODUCTION_MODIFIER',						'MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD'
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into ModifierArguments
	(ModifierId,																													  Name,										Value)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_PRODUCTION_MODIFIER',						'YieldChange',				  2
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into ModifierArguments
	(ModifierId,																													  Name,										Value)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_PRODUCTION_MODIFIER',						'YieldType',						'YIELD_PRODUCTION'
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

insert or replace into ModifierArguments
	(ModifierId,																													  Name,										Value)
select
	'JNR_DOJO_' || GreatWorkObjectType || '_PRODUCTION_MODIFIER',						'GreatWorkObjectType',	GreatWorkObjectType
from GreatWorkObjectTypes where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';