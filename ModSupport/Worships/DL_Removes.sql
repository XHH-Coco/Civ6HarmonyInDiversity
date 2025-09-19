-------------------------------------
-- Remove Adjustments from the Mod --
-------------------------------------

-- UC_REL_Worship_Policies removes
delete from PolicyModifiers where PolicyType = 'POLICY_SIMULTANEUM';

-- UC_REL_Worship_Bonuses_Faith removes
update Building_CitizenYieldChanges set YieldChange = 1 where BuildingType = 'BUILDING_SYNAGOGUE' and YieldType = 'YIELD_FAITH';

delete from BuildingModifiers
 where BuildingType = 'BUILDING_JNR_CANDI'
	or BuildingType = 'BUILDING_JNR_DAOGUAN'
	or BuildingType = 'BUILDING_JNR_JINJA'
	or BuildingType = 'BUILDING_JNR_KHALWAT'
	or BuildingType = 'BUILDING_JNR_MANDIR'
	or BuildingType = 'BUILDING_JNR_MBARI'
	or BuildingType = 'BUILDING_JNR_PERIPTEROS'
	or BuildingType = 'BUILDING_JNR_SOBOR'
	or BuildingType = 'BUILDING_JNR_TZACUALLI';

delete from BuildingModifiers
 where BuildingType = 'BUILDING_GURDWARA'
	or BuildingType = 'BUILDING_MOSQUE'
	or BuildingType = 'BUILDING_STUPA'
	or BuildingType = 'BUILDING_CATHEDRAL'
	or BuildingType = 'BUILDING_MEETING_HOUSE'
	or BuildingType = 'BUILDING_WAT';

delete from BuildingModifiers
 where ModifierId = 'JNR_PERIPTEROS_FAITH_ENTERTAINMENT'
	or ModifierId = 'JNR_SOBOR_FAITH_CONSULATE'
	or ModifierId = 'JNR_SOBOR_FAITH_CHANCERY';

delete from DistrictModifiers where ModifierId = 'JNR_PAGODA_FAITH_DISTRICTS';
delete from AllianceEffects where ModifierID = 'JNR_PERIPTEROS_FAITH_ALLY_TRADE';

insert or replace into BuildingModifiers
	(BuildingType,		ModifierId)
values
	('BUILDING_MOSQUE',	'MOSQUE_ADJUST_SPREAD_CHARGES');

-- UC_REL_Worship_Bonuses_Special removes
delete from Building_YieldChanges
 where BuildingType = 'BUILDING_JNR_CANDI'
	or BuildingType = 'BUILDING_CATHEDRAL'
	or BuildingType = 'BUILDING_JNR_MBARI'
	or BuildingType = 'BUILDING_JNR_JINJA'
	or BuildingType = 'BUILDING_MOSQUE'
	or BuildingType = 'BUILDING_JNR_SOBOR'
	or BuildingType = 'BUILDING_JNR_TZACUALLI';

delete from GreatWork_ValidSubTypes where GreatWorkSlotType = 'GREATWORKSLOT_CATHEDRAL' and
	(GreatWorkObjectType = 'GREATWORKOBJECT_RELIC' or GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC');

delete from Building_GreatWorks where GreatWorkSlotType = 'GREATWORKSLOT_RELIC'
  and (BuildingType = 'BUILDING_JNR_CANDI'
	or BuildingType = 'BUILDING_JNR_DAOGUAN'
	or BuildingType = 'BUILDING_DAR_E_MEHR'
	or BuildingType = 'BUILDING_JNR_MBARI'
	or BuildingType = 'BUILDING_JNR_JINJA'
	or BuildingType = 'BUILDING_GURDWARA'
	or BuildingType = 'BUILDING_JNR_KHALWAT'
	or BuildingType = 'BUILDING_JNR_MANDIR'
	or BuildingType = 'BUILDING_MEETING_HOUSE'
	or BuildingType = 'BUILDING_MOSQUE'
	or BuildingType = 'BUILDING_PAGODA'
	or BuildingType = 'BUILDING_JNR_PERIPTEROS'
	or BuildingType = 'BUILDING_JNR_SOBOR'
	or BuildingType = 'BUILDING_STUPA'
	or BuildingType = 'BUILDING_SYNAGOGUE'
	or BuildingType = 'BUILDING_JNR_TZACUALLI'
	or BuildingType = 'BUILDING_WAT');

-- UC_REL_Worship_Buildings removes
-- Make the yields all clear, for later adjustment.
update Buildings set Entertainment = 0 where BuildingType = 'BUILDING_JNR_KHALWAT';
update Buildings set Housing = 0 where BuildingType = 'BUILDING_JNR_MBARI';
