/*
滚滚蒸汽维多利亚La工业革命：
建成工业区二级建筑时获得工业化尤里卡，拥有工业化尤里卡时直接获得工业化科技。拥有工业区的城市+1区域位。皇家海军船坞+2大工程师点数。
*/
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_VICTORIA_ALT';

insert or replace into TraitModifiers
	(TraitType,										ModifierId)
values
	('TRAIT_LEADER_VICTORIA_ALT',					'LEADER_VICTORIA_ALT_EXTRA_DISTRICT_CAPACITY'),
	('TRAIT_LEADER_VICTORIA_ALT',					'LEADER_VICTORIA_ALT_EXTRA_GREATENGINEER');

insert or replace into Modifiers
	(ModifierId,											ModifierType,										SubjectRequirementSetId)
values
	('LEADER_VICTORIA_ALT_EXTRA_DISTRICT_CAPACITY',			'MODIFIER_PLAYER_CITIES_EXTRA_DISTRICT',			'CITY_HAS_DISTRICT_INDUSTRIAL_ZONE_REQUIREMENTS'),
	('LEADER_VICTORIA_ALT_EXTRA_GREATENGINEER',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',			NULL),
	('LEADER_VICTORIA_ALT_EXTRA_GREATENGINEER_MODIFIER',	'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT',	'CITY_HAS_DISTRICT_ROYAL_NAVY_DOCKYARD_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,											Name,					Value)
values
	('LEADER_VICTORIA_ALT_EXTRA_DISTRICT_CAPACITY',			'Amount',				1),
	('LEADER_VICTORIA_ALT_EXTRA_GREATENGINEER',				'ModifierId',			'LEADER_VICTORIA_ALT_EXTRA_GREATENGINEER_MODIFIER'),
	('LEADER_VICTORIA_ALT_EXTRA_GREATENGINEER_MODIFIER',	'Amount',				2),
	('LEADER_VICTORIA_ALT_EXTRA_GREATENGINEER_MODIFIER',	'GreatPersonClassType',	'GREAT_PERSON_CLASS_ENGINEER');

-- 2级工业建筑给工业化ulk和跳工业化, by 先驱
create temporary table IndustrialTier2Buildings (BuildingType text);
insert or replace into IndustrialTier2Buildings (BuildingType) values ('BUILDING_WORKSHOP');
insert or replace into IndustrialTier2Buildings (BuildingType) select Building from MutuallyExclusiveBuildings where MutuallyExclusiveBuilding = 'BUILDING_WORKSHOP';

insert or replace into TraitModifiers
	(TraitType,										ModifierId)
select
	'TRAIT_LEADER_VICTORIA_ALT',		            'HD_ENGLAND_' || BuildingType || '_INDISTRIALIZATION_BOOST'
from IndustrialTier2Buildings;

insert or replace into Modifiers
	(ModifierId,													ModifierType)
select
	'HD_ENGLAND_' || BuildingType || '_INDISTRIALIZATION_BOOST',	'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER'
from IndustrialTier2Buildings;

insert or replace into ModifierArguments
	(ModifierId,													Name,			Value)
select
	'HD_ENGLAND_' || BuildingType || '_INDISTRIALIZATION_BOOST',	'ModifierId',	'HD_ENGLAND_' || BuildingType || '_INDISTRIALIZATION_BOOST_MODIFIER'
from IndustrialTier2Buildings;

insert or replace into Modifiers
	(ModifierId,															ModifierType,									SubjectRequirementSetId,					RunOnce)
select
	'HD_ENGLAND_' || BuildingType || '_INDISTRIALIZATION_BOOST_MODIFIER',	'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST',	'HD_ENGLAND_CITY_HAS_' || BuildingType,		1
from IndustrialTier2Buildings;

insert or replace into ModifierArguments
	(ModifierId,															Name,					Value)
select
	'HD_ENGLAND_' || BuildingType || '_INDISTRIALIZATION_BOOST_MODIFIER',	'TechType',				'TECH_INDUSTRIALIZATION'
from IndustrialTier2Buildings;

insert or replace into ModifierArguments
	(ModifierId,															Name,					Value)
select
	'HD_ENGLAND_' || BuildingType || '_INDISTRIALIZATION_BOOST_MODIFIER',	'GrantTechIfBoosted',	1
from IndustrialTier2Buildings;

insert or replace into RequirementSets
	(RequirementSetId,							RequirementSetType)
select
	'HD_ENGLAND_CITY_HAS_' || BuildingType, 	'REQUIREMENTSET_TEST_ALL'
from IndustrialTier2Buildings;

insert or replace into RequirementSetRequirements
	(RequirementSetId,							RequirementId)
select
	'HD_ENGLAND_CITY_HAS_' || BuildingType,		'REQUIRES_CITY_HAS_' || BuildingType
from IndustrialTier2Buildings;

/*
伊丽莎白La荣光女王（Gloriana）：
所有海军袭击者+1射程。海军统帅+1使用次数。研究“探索”市政后获得特色单位海猎犬。
*/
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_ELIZABETH';
update Units set PrereqCivic = 'CIVIC_EXPLORATION' where UnitType = 'UNIT_ENGLISH_SEADOG';

insert or replace into TraitModifiers
	(TraitType,						ModifierId)
values
	('TRAIT_LEADER_ELIZABETH',		'ELIZABETH_ADJUST_ADMIRAL_CHARGES'),
	('TRAIT_LEADER_ELIZABETH',		'ELIZABETH_ADJUST_ATTACK_RANGE');

insert or replace into Modifiers
	(ModifierId,								ModifierType,											SubjectRequirementSetId)
values
	('ELIZABETH_ADJUST_ADMIRAL_CHARGES',		'MODIFIER_PLAYER_UNITS_ADJUST_GREAT_PERSON_CHARGES',	'UNIT_IS_ADMIRAL'),
	('ELIZABETH_ADJUST_ATTACK_RANGE',			'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',					NULL),
	('ELIZABETH_ADJUST_ATTACK_RANGE_MODIFIER',	'MODIFIER_UNIT_ADJUST_ATTACK_RANGE',					NULL);

insert or replace into ModifierArguments
	(ModifierId,								Name,					Value)
values
	('ELIZABETH_ADJUST_ADMIRAL_CHARGES',		'Amount',				1),
	('ELIZABETH_ADJUST_ATTACK_RANGE',			'AbilityType',			'ABILITY_ADJUST_ATTACK_RANGE'),
	('ELIZABETH_ADJUST_ATTACK_RANGE_MODIFIER',	'Amount',				1);

insert or replace into Types
	(Type,								Kind)
values
	('ABILITY_ADJUST_ATTACK_RANGE',		'KIND_ABILITY');

insert or replace into UnitAbilities
	(UnitAbilityType,				Name,	Description,									Inactive,	ShowFloatTextWhenEarned,	Permanent)
values
	('ABILITY_ADJUST_ATTACK_RANGE',	NULL,	'LOC_ABILITY_ADJUST_ATTACK_RANGE_DESCRIPTION',	1,			0,							1);

insert or replace into UnitAbilityModifiers
	(UnitAbilityType,				ModifierId)
values
	('ABILITY_ADJUST_ATTACK_RANGE',	'ELIZABETH_ADJUST_ATTACK_RANGE_MODIFIER');

insert or replace into TypeTags
	(Type,							Tag)
values
	('ABILITY_ADJUST_ATTACK_RANGE',	'CLASS_NAVAL_RAIDER');
/*
挪威

瓦良格哈拉尔德la：瓦良格冒险（Varangian Adventure）
每发现24个单元格或1个奇观，获得24金币。解锁“金属铸造”科技后，获得特色单位瓦良格卫队。
lu瓦良格卫队：
拜占庭和瓦良格哈拉尔德特色近战单位，取代披甲战士
46力3速90锤，可以鸽子买。位于区域，攻击区域以及攻击区域中单位+5力。

传统挪威改名为无情者哈拉尔（挪威诸王萨迦）英文为Harald Hardrada （Heimskringla）
新挪威改为无情者哈拉尔（瓦良格）英文不改
*/
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_HARALD_ALT';
insert or replace into LeaderTraits
	(LeaderType,						TraitType)
select
	'LEADER_HARALD_ALT',				'TRAIT_CIVILIZATION_UNIT_BYZANTINE_VARANGIAN_GUARD'
where exists (select Type from Types where Type = 'TRAIT_CIVILIZATION_UNIT_BYZANTINE_VARANGIAN_GUARD');