delete from TraitModifiers where ModifierId = 'TRAIT_SULEIMAN_ALT_SCIENCE_CULTURE_GOLDEN_AGE' or ModifierId = 'SULEIMAN_ALT_COMBAT_ABILITY';
--update Modifiers set SubjectStackLimit = 1 where ModifierId in (select ModifierId from CommemorationModifiers);
/*
create temporary table HD_SULEIMAN
	(CommemorationType text not null,
	ModifierId text not null primary key,
	MinimumGameEra text not null,
	MaximumGameEra text not null);

insert or replace into HD_SULEIMAN
	(CommemorationType,		ModifierId,			MinimumGameEra,			MaximumGameEra)
select
	t.CommemorationType,	ModifierId,			MinimumGameEra,			case when MaximumGameEra != NULL then MaximumGameEra else 'ERA_FUTURE' end
from (CommemorationTypes t inner join CommemorationModifiers m on t.CommemorationType = m.CommemorationType);
insert or replace into TraitModifiers
	(TraitType,								ModifierId)
select
	'TRAIT_LEADER_SULEIMAN_ALT',    		ModifierId || '_ATTACH'
from HD_SULEIMAN;
insert or replace into Modifiers
	(ModifierId,					ModifierType,										SubjectRequirementSetId)
select
	ModifierId || '_ATTACH',		'MODIFIER_PLAYER_ATTACH_MODIFIER',					MinimumGameEra || '_' || MaximumGameEra
from HD_SULEIMAN;
insert or replace into ModifierArguments
	(ModifierId,					Name,					Value)
select
	ModifierId || '_ATTACH',		'ModifierId',			ModifierId
from HD_SULEIMAN;
insert or ignore into RequirementSets
	(RequirementSetId,								RequirementSetType)
select distinct
	MinimumGameEra || '_' || MaximumGameEra,		'REQUIREMENTSET_TEST_ANY'
from HD_SULEIMAN;
insert or ignore into RequirementSetRequirements
	(RequirementSetId,								RequirementId)
select distinct
	MinimumGameEra || '_' || MaximumGameEra,		'REQUIRES_ERA_IS_' || EraType
from (HD_SULEIMAN s cross join Eras e) where (select ChronologyIndex from Eras er where er.EraType = MinimumGameEra) <= e.ChronologyIndex and (select ChronologyIndex from Eras er where er.EraType = MaximumGameEra) >= e.ChronologyIndex;
*/

insert or replace into GlobalParameters
  (Name,                                                    Value)
values
  -- 大帝 三倍着力点
  ('HD_TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION',     1);

create temporary table HD_SULEIMAN
	(CommemorationType text not null,
	ModifierId text not null primary key,
	ModifierId_ATTACH text not null,
	ModifierId_ATTACH_EXTRA text not null);

insert or replace into HD_SULEIMAN
	(CommemorationType,		ModifierId,					ModifierId_ATTACH,				ModifierId_ATTACH_EXTRA)
select
	CommemorationType,		ModifierId,					ModifierId || '_ATTACH',		ModifierId || '_ATTACH_EXTRA'
from CommemorationModifiers;

insert or replace into CommemorationModifiers
	(CommemorationType,				ModifierId)
select
	CommemorationType,				ModifierId_ATTACH
from HD_SULEIMAN;

insert or replace into CommemorationModifiers
	(CommemorationType,				ModifierId)
select
	CommemorationType,				ModifierId_ATTACH_EXTRA
from HD_SULEIMAN;

insert or replace into Modifiers
	(ModifierId,					ModifierType,								SubjectRequirementSetId)
select
	ModifierId_ATTACH,				'MODIFIER_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER',			'HD_PLAYER_IS_LEADER_SULEIMAN_ALT_REQUIREMENTS'
from HD_SULEIMAN;

insert or replace into Modifiers
	(ModifierId,					ModifierType,								SubjectRequirementSetId)
select
	ModifierId_ATTACH_EXTRA,		'MODIFIER_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER',			'HD_PLAYER_IS_LEADER_SULEIMAN_ALT_REQUIREMENTS'
from HD_SULEIMAN;

insert or replace into ModifierArguments
	(ModifierId,					Name,					Value)
select
	ModifierId_ATTACH,				'ModifierId',			ModifierId
from HD_SULEIMAN;

insert or replace into ModifierArguments
	(ModifierId,					Name,					Value)
select
	ModifierId_ATTACH_EXTRA,		'ModifierId',			ModifierId
from HD_SULEIMAN;

-- Nader Shah
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_NADER_SHAH' and ModifierId != 'NADER_SHAH_COMBAT_ABILITY';
update ModifierArguments set Value = 7 where ModifierId = 'NADER_SHAH_COMBAT_BUFF' and Name = 'Amount';
-- insert or replace into TraitModifiers
-- 	(TraitType,							ModifierId)
-- values
-- 	('TRAIT_LEADER_NADER_SHAH',			'NADER_SHAH_TRADEROUTE_CAPACITY');
-- insert or replace into Modifiers
-- 	(ModifierId,						ModifierType,											SubjectRequirementSetId)
-- values
-- 	('NADER_SHAH_TRADEROUTE_CAPACITY',	'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_CAPACITY',	'CITY_WAS_NOT_FOUNDED');
-- insert or replace into ModifierArguments
-- 	(ModifierId,						Name,		Value)
-- values
-- 	('NADER_SHAH_TRADEROUTE_CAPACITY',	'Amount',	1);


--LEADER_TOKUGAWA
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_TOKUGAWA';

insert or replace into TraitModifiers
	(TraitType,											ModifierId)
values
	('TRAIT_LEADER_TOKUGAWA',				'HD_TOKUGAWA_FEUDALISM_GOVERNOR'),
	('TRAIT_LEADER_TOKUGAWA',				'HD_TOKUGAWA_NO_GOVERNOR_CITY_NEGATIVE_GOLD'),
	('TRAIT_LEADER_TOKUGAWA',				'HD_TOKUGAWA_GOVERNOR_CITY_GOLD_ATTACH');

insert or replace into Modifiers
	(ModifierId,																		ModifierType,																					OwnerRequirementSetId,											SubjectRequirementSetId)
values
	('HD_TOKUGAWA_FEUDALISM_GOVERNOR',							'MODIFIER_PLAYER_ADJUST_GOVERNOR_POINTS',							'PLAYER_HAS_CIVIC_FEUDALISM_REQUIREMENTS',	NULL),
	('HD_TOKUGAWA_NO_GOVERNOR_CITY_NEGATIVE_GOLD',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	NULL,																				'HD_CITY_NOT_CAPITAL_NO_GOVERNOR'),
	('HD_TOKUGAWA_GOVERNOR_CITY_GOLD_ATTACH',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',							NULL,																				'HD_CITY_NOT_CAPITAL_NO_GOVERNOR'),
	('HD_TOKUGAWA_GOVERNOR_CITY_GOLD',							'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	NULL,																				'HD_CITY_CAPITAL_OR_GOVERNOR');

insert or replace into ModifierArguments
	(ModifierId,																		Name,							Value)
values
	('HD_TOKUGAWA_FEUDALISM_GOVERNOR',							'Delta', 					1),
	('HD_TOKUGAWA_NO_GOVERNOR_CITY_NEGATIVE_GOLD',	'YieldType',    	'YIELD_GOLD'),
	('HD_TOKUGAWA_NO_GOVERNOR_CITY_NEGATIVE_GOLD',	'Amount',       	-20),
	('HD_TOKUGAWA_GOVERNOR_CITY_GOLD_ATTACH',				'ModifierId',    	'HD_TOKUGAWA_GOVERNOR_CITY_GOLD'),
	('HD_TOKUGAWA_GOVERNOR_CITY_GOLD',							'YieldType',    	'YIELD_GOLD'),
	('HD_TOKUGAWA_GOVERNOR_CITY_GOLD',							'Amount',       	5);