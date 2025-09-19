-------------------------------------
--     Adaptation for the Mod      --
-------------------------------------

-- The Worships mod already did the support for religious city state bonus.
-- The citizen yield are already done by the mod.

-- The new buildings
-- 'BUILDING_JNR_CANDI'
-- 'BUILDING_JNR_DAOGUAN'
-- 'BUILDING_JNR_JINJA'
-- 'BUILDING_JNR_KHALWAT'
-- 'BUILDING_JNR_MANDIR'
-- 'BUILDING_JNR_MBARI'
-- 'BUILDING_JNR_PERIPTEROS'
-- 'BUILDING_JNR_SOBOR'
-- 'BUILDING_JNR_TZACUALLI'

-- The yield of original building will be adjusted again in the main part of our mod.
-- Need to setup the Building_YieldChanges for the new buildings.


-- Need to update the Maintenance (and cost) for the new buildings.
-- e.g. all 4 golds.


-- Need to assign special effect for 3-rd tier holy site buildings.
insert or replace into BuildingModifiers
	(BuildingType,							ModifierId)
values
	('BUILDING_JNR_CANDI',					'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST'),
	('BUILDING_JNR_DAOGUAN',				'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST'),
	('BUILDING_JNR_JINJA',					'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST'),
	('BUILDING_JNR_KHALWAT',				'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST'),
	('BUILDING_JNR_MANDIR',					'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST'),
	('BUILDING_JNR_MBARI',					'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST'),
	('BUILDING_JNR_PERIPTEROS',				'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST'),
	('BUILDING_JNR_SOBOR',					'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST'),
	('BUILDING_JNR_TZACUALLI',				'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST');

-- Text updates
update Beliefs set Description = 'LOC_BELIEF_JNR_CANDI_DL_DESCRIPTION' 			where BeliefType = 'BELIEF_JNR_CANDI';
update Beliefs set Description = 'LOC_BELIEF_JNR_DAOGUAN_DL_DESCRIPTION' 		where BeliefType = 'BELIEF_JNR_DAOGUAN';
update Beliefs set Description = 'LOC_BELIEF_JNR_JINJA_DL_DESCRIPTION' 			where BeliefType = 'BELIEF_JNR_JINJA';
update Beliefs set Description = 'LOC_BELIEF_JNR_KHALWAT_DL_DESCRIPTION' 		where BeliefType = 'BELIEF_JNR_KHALWAT';
update Beliefs set Description = 'LOC_BELIEF_JNR_MANDIR_DL_DESCRIPTION' 		where BeliefType = 'BELIEF_JNR_MANDIR';
update Beliefs set Description = 'LOC_BELIEF_JNR_MBARI_DL_DESCRIPTION' 			where BeliefType = 'BELIEF_JNR_MBARI';
update Beliefs set Description = 'LOC_BELIEF_JNR_PERIPTEROS_DL_DESCRIPTION' 	where BeliefType = 'BELIEF_JNR_PERIPTEROS';
update Beliefs set Description = 'LOC_BELIEF_JNR_SOBOR_DL_DESCRIPTION' 			where BeliefType = 'BELIEF_JNR_SOBOR';
update Beliefs set Description = 'LOC_BELIEF_JNR_TZACUALLI_DL_DESCRIPTION' 		where BeliefType = 'BELIEF_JNR_TZACUALLI';

update Buildings set Description = 'LOC_BUILDING_JNR_CANDI_DL_DESCRIPTION'		where BuildingType = 'BUILDING_JNR_CANDI';
update Buildings set Description = 'LOC_BUILDING_JNR_DAOGUAN_DL_DESCRIPTION'	where BuildingType = 'BUILDING_JNR_DAOGUAN';
update Buildings set Description = 'LOC_BUILDING_JNR_JINJA_DL_DESCRIPTION'		where BuildingType = 'BUILDING_JNR_JINJA';
update Buildings set Description = 'LOC_BUILDING_JNR_KHALWAT_DL_DESCRIPTION'	where BuildingType = 'BUILDING_JNR_KHALWAT';
update Buildings set Description = 'LOC_BUILDING_JNR_MANDIR_DL_DESCRIPTION'		where BuildingType = 'BUILDING_JNR_MANDIR';
update Buildings set Description = 'LOC_BUILDING_JNR_MBARI_DL_DESCRIPTION'		where BuildingType = 'BUILDING_JNR_MBARI';
update Buildings set Description = 'LOC_BUILDING_JNR_PERIPTEROS_DL_DESCRIPTION'	where BuildingType = 'BUILDING_JNR_PERIPTEROS';
update Buildings set Description = 'LOC_BUILDING_JNR_SOBOR_DL_DESCRIPTION'		where BuildingType = 'BUILDING_JNR_SOBOR';
update Buildings set Description = 'LOC_BUILDING_JNR_TZACUALLI_DL_DESCRIPTION'	where BuildingType = 'BUILDING_JNR_TZACUALLI';

insert or replace into Building_YieldChanges
	(BuildingType,				YieldType,			YieldChange)
values
	('BUILDING_JNR_CANDI',		'YIELD_FAITH',		8),
	('BUILDING_JNR_CANDI',		'YIELD_CULTURE',		4),
	('BUILDING_JNR_DAOGUAN',	'YIELD_FAITH',		8),
	('BUILDING_JNR_DAOGUAN',	'YIELD_SCIENCE',		4),
	('BUILDING_JNR_JINJA',		'YIELD_FAITH',		8),
	('BUILDING_JNR_JINJA',		'YIELD_PRODUCTION',		4),
	('BUILDING_JNR_KHALWAT',	'YIELD_FAITH',		8),
	('BUILDING_JNR_KHALWAT',	'YIELD_CULTURE',		4),
 	('BUILDING_JNR_MANDIR',		'YIELD_FAITH',		8),
 	('BUILDING_JNR_MANDIR',		'YIELD_FOOD',		4),
 	('BUILDING_JNR_MBARI',		'YIELD_FAITH',		8),
 	('BUILDING_JNR_MBARI',		'YIELD_GOLD',		12),
 	('BUILDING_JNR_PERIPTEROS',	'YIELD_FAITH',		8),
 	('BUILDING_JNR_PERIPTEROS',	'YIELD_CULTURE',		4),
 	('BUILDING_JNR_SOBOR',		'YIELD_FAITH',		8),
 	('BUILDING_JNR_TZACUALLI',	'YIELD_FAITH',		8),
 	('BUILDING_JNR_TZACUALLI',	'YIELD_SCIENCE',		4);

update Buildings set Cost = 220, Maintenance = 4
 where BuildingType = 'BUILDING_JNR_CANDI'
	or BuildingType = 'BUILDING_JNR_DAOGUAN'
	or BuildingType = 'BUILDING_JNR_JINJA'
	or BuildingType = 'BUILDING_JNR_KHALWAT'
	or BuildingType = 'BUILDING_JNR_MBARI'
	or BuildingType = 'BUILDING_JNR_MANDIR'
	or BuildingType = 'BUILDING_JNR_PERIPTEROS'
	or BuildingType = 'BUILDING_JNR_SOBOR'
	or BuildingType = 'BUILDING_JNR_TZACUALLI';

insert or ignore into BuildingPrereqs
	(Building,	PrereqBuilding)
select
	Building,		'BUILDING_HD_ALCHEMY_ROOM'
from BuildingPrereqs where PrereqBuilding = 'BUILDING_TEMPLE';