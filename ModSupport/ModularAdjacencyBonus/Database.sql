-- =====================================================================================================================================
-- 金法国
-- =====================================================================================================================================
update Traits set Description = 'LOC_TRAIT_LEADER_MAGNIFICENCES_DESCRIPTION_MAB' where TraitType = 'TRAIT_LEADER_MAGNIFICENCES';

insert or replace into Ruivo_New_Adjacency (ID, DistrictType, ProvideType, YieldType, YieldChange, AdjacencyType, DistrictModifiers, ModifierOwner, WhoIsTheOwner, CollectionType) select
  'HD_TRAIT_LEADER_MAGNIFICENCES_' || DistrictType || '_' || YieldType || '_FROM_CITY_SURPLUS_AMENITIES_OVER_HIGHEST_LEVEL_HAPPINESS',
  DistrictType,
  'SelfBonus',
  YieldType,
  0.3334,
  'FROM_CITY_SURPLUS_AMENITIES_OVER_HIGHEST_LEVEL_HAPPINESS',
  1,
  'TraitModifiers',
  'TRAIT_LEADER_MAGNIFICENCES',
  'COLLECTION_PLAYER_DISTRICTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1 and exists (select TraitType from Traits where TraitType = 'TRAIT_LEADER_MAGNIFICENCES');

-- =====================================================================================================================================
-- 苏格兰
-- =====================================================================================================================================
update Traits set Description = 'LOC_TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT_DESCRIPTION_MAB' where TraitType = 'TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT';
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT';

insert or replace into TraitModifiers (TraitType, ModifierId) values
	('TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT', 'HD_SCOTTISH_ENLIGHTENMENT_CAMPUS_BOOST'),
	('TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT', 'HD_SCOTTISH_ENLIGHTENMENT_INDUSTRIAL_ZONE_BOOST');

insert or replace into Modifiers (ModifierId, ModifierType) values
	('HD_SCOTTISH_ENLIGHTENMENT_CAMPUS_BOOST',          'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION'),
	('HD_SCOTTISH_ENLIGHTENMENT_INDUSTRIAL_ZONE_BOOST', 'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION');

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('HD_SCOTTISH_ENLIGHTENMENT_CAMPUS_BOOST',          'DistrictType',   'DISTRICT_CAMPUS'),
	('HD_SCOTTISH_ENLIGHTENMENT_CAMPUS_BOOST',          'Amount',         100),
	('HD_SCOTTISH_ENLIGHTENMENT_INDUSTRIAL_ZONE_BOOST', 'DistrictType',   'DISTRICT_INDUSTRIAL_ZONE'),
	('HD_SCOTTISH_ENLIGHTENMENT_INDUSTRIAL_ZONE_BOOST', 'Amount',         100);

-- 在岗公民提供 相邻加成
insert or replace into Ruivo_New_Adjacency (ID, DistrictType, ProvideType, YieldType, YieldChange, AdjacencyType, DistrictModifiers, ModifierOwner, WhoIsTheOwner, CollectionType) select
  'HD_TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT_' || DistrictType || '_' || YieldType || '_FROM_ADJACENT_WORKER',
  DistrictType,
  'SelfBonus',
  YieldType,
  1,
  'FROM_ADJACENT_WORKER',
  1,
  'TraitModifiers',
  'TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT',
  'COLLECTION_PLAYER_DISTRICTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 在岗公民提供 伟人点数
insert or replace into Ruivo_New_Adjacency (ID, DistrictType, ProvideType, YieldType, YieldChange, AdjacencyType, DistrictModifiers, ModifierOwner, WhoIsTheOwner, CollectionType) select
  'HD_TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT_' || DistrictType || '_' || GreatPersonClassType || '_FROM_ADJACENT_WORKER',
  DistrictType,
  'GreatPersonPoints',
  GreatPersonClassType,
  2,
  'FROM_ADJACENT_WORKER',
  1,
  'TraitModifiers',
  'TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT',
  'COLLECTION_PLAYER_DISTRICTS'
from DistrictCorrespondingGPP_HD;

-- =====================================================================================================================================
-- 武则天
-- =====================================================================================================================================
delete from TraitModifiers where TraitType = 'TRAIT_WU_ZETIAN_ALT';

insert or replace into Ruivo_New_Adjacency (ID, DistrictType, ProvideType, YieldType, YieldChange, AdjacencyType, DistrictModifiers, ModifierOwner, WhoIsTheOwner, CollectionType) select
  'HD_TRAIT_WU_ZETIAN_ALT_' || DistrictType || '_' || YieldType || '_FROM_ADJACENT_WONDERS',
  DistrictType,
  'SelfBonus',
  YieldType,
  2,
  'FROM_ADJACENT_WONDERS',
  1,
  'TraitModifiers',
  'TRAIT_WU_ZETIAN_ALT',
  'COLLECTION_PLAYER_DISTRICTS'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1 and exists (select TraitType from Traits where TraitType = 'TRAIT_WU_ZETIAN_ALT');

-- =====================================================================================================================================
-- 红胡子
-- =====================================================================================================================================
update Traits set Description = 'LOC_TRAIT_LEADER_HOLY_ROMAN_EMPEROR_DESCRIPTION_MAB' where TraitType = 'TRAIT_LEADER_HOLY_ROMAN_EMPEROR';

delete from TraitModifiers where TraitType = 'TRAIT_LEADER_HOLY_ROMAN_EMPEROR' and ModifierId in (
  'HD_HOLY_ROMAN_ENCAMPMENT_DISTRICT_ADJACENCY',
  'HD_HOLY_ROMAN_ENCAMPMENT_RESOURCE_BONUS_ATTACH'
);

insert or replace into Ruivo_New_Adjacency (ID, DistrictType, ProvideType, YieldType, YieldChange, AdjacencyType, DistrictModifiers, ModifierOwner, WhoIsTheOwner, CollectionType) values
(
  'HD_TRAIT_LEADER_HOLY_ROMAN_EMPEROR_DISTRICT_ENCAMPMENT_YIELD_PRODUCTION_FROM_ADJACENT_RESOURCE',
  'DISTRICT_ENCAMPMENT',
  'SelfBonus',
  'YIELD_PRODUCTION',
  1,
  'FROM_ADJACENT_RESOURCE',
  1,
  'TraitModifiers',
  'TRAIT_LEADER_HOLY_ROMAN_EMPEROR',
  'COLLECTION_PLAYER_DISTRICTS'
),
(
  'HD_TRAIT_LEADER_HOLY_ROMAN_EMPEROR_DISTRICT_ENCAMPMENT_YIELD_PRODUCTION_FROM_SLOT_MILITARY',
  'DISTRICT_ENCAMPMENT',
  'SelfBonus',
  'YIELD_PRODUCTION',
  1,
  'FROM_SLOT_MILITARY',
  1,
  'TraitModifiers',
  'TRAIT_LEADER_HOLY_ROMAN_EMPEROR',
  'COLLECTION_PLAYER_DISTRICTS'
);