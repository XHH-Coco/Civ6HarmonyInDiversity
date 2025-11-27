-- 百科页面排除所有虚拟建筑
insert or ignore into CivilopediaPageExcludes (SectionId, PageId)
  select 'BUILDINGS', BuildingType from HD_DUMMY_BUILDINGS;

--------------------------------------------------------------------------------------------------------------------
-- 百科资源分类
  -- 战略 文物资源
insert into HD_Civilopedia_Resource_Groups (ResourceType, PageGroupId)
  select ResourceType, ResourceClassType from Resources where ResourceClassType not in ("RESOURCECLASS_BONUS", "RESOURCECLASS_LUXURY");

  -- 按改良类型 分类 加成 奢侈资源
insert into HD_Civilopedia_Resource_Groups (ResourceType, PageGroupId)
  select a.ResourceType, b.ImprovementType || "_" || a.ResourceClassType
  from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
  where ResourceClassType in ("RESOURCECLASS_BONUS", "RESOURCECLASS_LUXURY")
  and b.ImprovementType in (select ImprovementType from HD_Improvement_Classification where ImprovementClassificationType = 'IMPROVEMENT_CLASSIFICATION_BASIC');

  -- 奇观 奢侈资源
insert into HD_Civilopedia_Resource_Groups (ResourceType, PageGroupId)
  select a.ResourceType, 'WONDER_LUXURY' from Resources a inner join Wonder_Resources_HD b on a.ResourceType = b.ResourceType
  where ResourceClassType = 'RESOURCECLASS_LUXURY';

  -- 特殊 资源
insert into HD_Civilopedia_Resource_Groups (ResourceType, PageGroupId)
  select ResourceType, ResourceClassType from Resources
  where ResourceClassType in ("RESOURCECLASS_BONUS", "RESOURCECLASS_LUXURY")
  and ResourceType not in (select ResourceType from HD_Civilopedia_Resource_Groups)
  and ResourceType not like "RESOURCE_C_ALCOHOL_%" 
  and ResourceType != "RESOURCE_C_ALCOHOL_GENERAL";

-- 按改良类型给资源分类
insert or ignore into HD_Resource_Classification (ResourceType, ResourceClassificationType) select
  ResourceType, 'RESOURCE_CLASSIFICATION_' || ImprovementType
from Improvement_ValidResources where ImprovementType in (
  select ImprovementType from HD_Improvement_Classification where ImprovementClassificationType = 'IMPROVEMENT_CLASSIFICATION_BASIC'
    and ImprovementType not in ('IMPROVEMENT_OFFSHORE_OIL_RIG')
);

-- 删除没有任何对应资源的分类
delete from HD_ResourceClassificationTypes where ResourceClassificationType not in (select distinct ResourceClassificationType from HD_Resource_Classification);

--------------------------------------------------------------------------------------------------------------------
-- 艺术巨作 文物 重复创作者产出和业绩减益
update Building_GreatWorks set NonUniquePersonYield = 1, NonUniquePersonTourism = 1 where
  GreatWorkSlotType in ('GREATWORKSLOT_PALACE', 'GREATWORKSLOT_ART', 'GREATWORKSLOT_ARTIFACT');
update Building_GreatWorks set NonUniquePersonYield = 0, NonUniquePersonTourism = 0 where
  GreatWorkSlotType not in ('GREATWORKSLOT_PALACE', 'GREATWORKSLOT_ART', 'GREATWORKSLOT_ARTIFACT');

--------------------------------------------------------------------------------------------------------------------
-- 二进制
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_' || Key || '_' || Exp, 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
	from HD_Binary_Compress, HD_Binary_Compress_Keys where Exp <= MaxExp;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_' || Key || '_' || Exp, 'PropertyName', Key || '_' || Exp
	from HD_Binary_Compress, HD_Binary_Compress_Keys where Exp <= MaxExp;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_' || Key || '_' || Exp, 'PropertyMinimum', 1
	from HD_Binary_Compress, HD_Binary_Compress_Keys where Exp <= MaxExp;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select Key || '_' || Exp || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY'
	from HD_Binary_Compress, HD_Binary_Compress_Keys where Exp <= MaxExp;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select Key || '_' || Exp || '_REQUIREMENTS', 'REQUIRES_' || Key || '_' || Exp
	from HD_Binary_Compress, HD_Binary_Compress_Keys where Exp <= MaxExp;

--------------------------------------------------------------------------------------------------------------------
-- 西班牙自然奇观能力
	-- LB 自然奇观产出
insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, RunOnce, Permanent, SubjectStackLimit)
select 'TRAIT_' || b.FeatureType || '_ON_' || a.YieldType, 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE', null, 1, 1,	1
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_' || b.FeatureType || '_ON_' || a.YieldType, 'BuildingType', 'BUILDING_EL_ESCORIAL_PALACE'
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_' || b.FeatureType || '_ON_' || a.YieldType, 'Amount', a.YieldChange
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_' || b.FeatureType || '_ON_' || a.YieldType, 'YieldType', a.YieldType
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, RunOnce, Permanent, SubjectStackLimit)
select 'TRAIT_' || b.FeatureType || '_ADJACENT_' || a.YieldType, 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE', null, 1, 1,	1
	from Feature_AdjacentYields a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_' || b.FeatureType || '_ADJACENT_' || a.YieldType, 'BuildingType', 'BUILDING_EL_ESCORIAL_PALACE'
	from Feature_AdjacentYields a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_' || b.FeatureType || '_ADJACENT_' || a.YieldType, 'Amount', a.YieldChange
	from Feature_AdjacentYields a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_' || b.FeatureType || '_ADJACENT_' || a.YieldType, 'YieldType', a.YieldType
	from Feature_AdjacentYields a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

	-- 宫殿
insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, RunOnce, Permanent, SubjectStackLimit)
select 'TRAIT_PALACE_' || b.FeatureType || '_ON_' || a.YieldType, 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE', 'PLAYER_HAS_BUILDING_EL_ESCORIAL_PALACE_REQUIREMENTS', 1, 1,	1
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_PALACE_' || b.FeatureType || '_ON_' || a.YieldType, 'BuildingType', 'BUILDING_PALACE'
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_PALACE_' || b.FeatureType || '_ON_' || a.YieldType, 'Amount', a.YieldChange
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_PALACE_' || b.FeatureType || '_ON_' || a.YieldType, 'YieldType', a.YieldType
	from Feature_YieldChanges a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, RunOnce, Permanent, SubjectStackLimit)
select 'TRAIT_PALACE_' || b.FeatureType || '_ADJACENT_' || a.YieldType, 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE', 'PLAYER_HAS_BUILDING_EL_ESCORIAL_PALACE_REQUIREMENTS', 1, 1,	1
	from Feature_AdjacentYields a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_PALACE_' || b.FeatureType || '_ADJACENT_' || a.YieldType, 'BuildingType', 'BUILDING_PALACE'
	from Feature_AdjacentYields a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_PALACE_' || b.FeatureType || '_ADJACENT_' || a.YieldType, 'Amount', a.YieldChange
	from Feature_AdjacentYields a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
select 'TRAIT_PALACE_' || b.FeatureType || '_ADJACENT_' || a.YieldType, 'YieldType', a.YieldType
	from Feature_AdjacentYields a inner join Features b on a.FeatureType = b.FeatureType where b.NaturalWonder = 1;
--------------------------------------------------------------------------------------------------------------------
-- 宙斯像万神殿收益翻倍
-- MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER -> MODIFIER_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER
-- MODIFIER_ALL_DISTRICTS_ATTACH_MODIFIER -> MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER
-- MODIFIER_ALL_CITIES_TERRAIN_ADJACENCY -> MODIFIER_PLAYER_CITIES_TERRAIN_ADJACENCY
-- MODIFIER_ALL_CITIES_IMPROVEMENT_ADJACENCY -> MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY
-- MODIFIER_ALL_CITIES_FEATURE_ADJACENCY -> MODIFIER_PLAYER_CITIES_FEATURE_ADJACENCY
-- MODIFIER_ALL_CITIES_CULTURE_BORDER_EXPANSION -> MODIFIER_PLAYER_CITIES_CULTURE_BORDER_EXPANSION
-- MODIFIER_ALL_CITIES_ATTACH_MODIFIER -> MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER
-- MODIFIER_ALL_CITIES_ADJUST_CITY_GROWTH -> MODIFIER_PLAYER_CITIES_ADJUST_CITY_GROWTH
-- MODIFIER_ALL_PLAYERS_ADJUST_PLAYER_VALID_UNIT_BUILD -> MODIFIER_PLAYER_ADJUST_VALID_UNIT_BUILD

-- CITY_FOLLOWS_PANTHEON_AND_HOLYSITE_REQUIREMENTS -> REQUIRES_DISTRICT_IS_DISTRICT_HOLY_SITE_UDMET
-- CITY_FOLLOWS_PANTHEON_AND_CITY_HAS_HOLYSITE -> REQUIRES_CITY_HAS_DISTRICT_HOLY_SITE_UDMET

create temporary table HD_PantheonModifierTypeTrans (
	OldModifierType text not null,
	NewModifierType text not null,
	primary key (OldModifierType)
);

insert or replace into HD_PantheonModifierTypeTrans
  (OldModifierType,                                       NewModifierType)
values
  ('MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',                'MODIFIER_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER'),
  ('MODIFIER_ALL_DISTRICTS_ATTACH_MODIFIER',              'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER'),
  ('MODIFIER_ALL_CITIES_TERRAIN_ADJACENCY',               'MODIFIER_PLAYER_CITIES_TERRAIN_ADJACENCY'),
  ('MODIFIER_ALL_CITIES_IMPROVEMENT_ADJACENCY',           'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY'),
  ('MODIFIER_ALL_CITIES_FEATURE_ADJACENCY',               'MODIFIER_PLAYER_CITIES_FEATURE_ADJACENCY'),
  ('MODIFIER_ALL_CITIES_CULTURE_BORDER_EXPANSION',        'MODIFIER_PLAYER_CITIES_CULTURE_BORDER_EXPANSION'),
  ('MODIFIER_ALL_CITIES_ATTACH_MODIFIER',                 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER'),
  ('MODIFIER_ALL_CITIES_ADJUST_CITY_GROWTH',              'MODIFIER_PLAYER_CITIES_ADJUST_CITY_GROWTH'),
  ('MODIFIER_ALL_PLAYERS_ADJUST_PLAYER_VALID_UNIT_BUILD', 'MODIFIER_PLAYER_ADJUST_VALID_UNIT_BUILD');

create temporary table HD_PantheonRequirementSetIdTrans (
	OldRequirementSetId text not null,
	NewRequirementSetId text,
	primary key (OldRequirementSetId)
);

insert or replace into HD_PantheonRequirementSetIdTrans
  (OldRequirementSetId,                                 NewRequirementSetId)
values
  ('CITY_FOLLOWS_PANTHEON_REQUIREMENTS',                null),
  ('PLAYER_HAS_PANTHEON_REQUIREMENTS',                  null),
  ('CITY_FOLLOWS_PANTHEON_AND_HOLYSITE_REQUIREMENTS',   'REQUIRES_DISTRICT_IS_DISTRICT_HOLY_SITE_UDMET'),
  ('CITY_FOLLOWS_PANTHEON_AND_CITY_HAS_HOLYSITE',       'REQUIRES_CITY_HAS_DISTRICT_HOLY_SITE_UDMET');

create table HD_PantheonModifiers (
	BeliefType text not null,
	ModifierId text not null,
  ModifierType text not null,
  SubjectRequirementSetId text not null,
	primary key (BeliefType, ModifierId)
);

insert or replace into HD_PantheonModifiers
  (BeliefType, ModifierId, ModifierType, SubjectRequirementSetId)
select
  a.BeliefType, a.ModifierId, c.ModifierType, c.SubjectRequirementSetId
from BeliefModifiers a
  inner join Beliefs b on a.BeliefType = b.BeliefType
  inner join Modifiers c on a.ModifierId = c.ModifierId
where b.BeliefClassType = 'BELIEF_CLASS_PANTHEON';


insert or replace into Modifiers
  (ModifierId,                                       ModifierType,      SubjectRequirementSetId)
select
  a.ModifierId || '_STATUE_OF_ZEUS_DOUBLE_PANTHEON', b.NewModifierType, c.NewRequirementSetId
from HD_PantheonModifiers a
  inner join HD_PantheonModifierTypeTrans b on a.ModifierType = b.OldModifierType
  inner join HD_PantheonRequirementSetIdTrans c on a.SubjectRequirementSetId = c.OldRequirementSetId;

insert or replace into ModifierArguments
	(ModifierId,                                       Name,   Value)
select
  a.ModifierId || '_STATUE_OF_ZEUS_DOUBLE_PANTHEON', b.Name, b.Value
from HD_PantheonModifiers a inner join ModifierArguments b on a.ModifierId = b.ModifierId;

--------------------------------------------------------------------------------------------------------------------
-- 布达拉宫追随者信条翻倍
create temporary table HD_FollowerBeliefModifierTypeTrans (
	OldModifierType text not null,
	NewModifierType text not null,
	primary key (OldModifierType)
);

insert or replace into HD_FollowerBeliefModifierTypeTrans
  (OldModifierType,                                                 NewModifierType)
values
  ('MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',                          'MODIFIER_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER'),
  ('MODIFIER_ALL_CITIES_ATTACH_MODIFIER',                           'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER'),
  ('MODIFIER_ALL_DISTRICTS_ATTACH_MODIFIER',                        'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER'),
  ('MODIFIER_ALL_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',  'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS'),
  ('MODIFIER_PLAYER_RELIGION_ADD_RELIGIOUS_UNIT',                   'MODIFIER_PLAYER_RELIGION_ADD_RELIGIOUS_UNIT');

create temporary table HD_FollowerBelieRequirementSetIdTrans (
	OldRequirementSetId text not null,
	NewRequirementSetId text,
	primary key (OldRequirementSetId)
);

insert or replace into HD_FollowerBelieRequirementSetIdTrans
  (OldRequirementSetId,                                           NewRequirementSetId)
values
  ('CITY_FOLLOWS_RELIGION_AND_HOLYSITE_REQUIREMENTS',             'REQUIRES_DISTRICT_IS_DISTRICT_HOLY_SITE_UDMET'),
  ('CITY_FOLLOWS_RELIGION_REQUIREMENTS',                          null),
  ('PLAYER_FOUNDED_RELIGION_REQUIREMENTS',                        null);


create table HD_FollowerBeliefModifiers (
	BeliefType text not null,
	ModifierId text not null,
  ModifierType text not null,
  SubjectRequirementSetId text not null,
	primary key (BeliefType, ModifierId)
);

insert or replace into HD_FollowerBeliefModifiers
  (BeliefType, ModifierId, ModifierType, SubjectRequirementSetId)
select
  a.BeliefType, a.ModifierId, c.ModifierType, c.SubjectRequirementSetId
from BeliefModifiers a
  inner join Beliefs b on a.BeliefType = b.BeliefType
  inner join Modifiers c on a.ModifierId = c.ModifierId
where b.BeliefClassType = 'BELIEF_CLASS_FOLLOWER' and c.SubjectRequirementSetId is not null;

insert or replace into Modifiers
  (ModifierId,                                       ModifierType,      SubjectRequirementSetId)
select
  a.ModifierId || '_POTALA_PALACE_DOUBLE_FOLLOWER',  b.NewModifierType, c.NewRequirementSetId
from HD_FollowerBeliefModifiers a
  inner join HD_FollowerBeliefModifierTypeTrans b on a.ModifierType = b.OldModifierType
  inner join HD_FollowerBelieRequirementSetIdTrans c on a.SubjectRequirementSetId = c.OldRequirementSetId;

insert or replace into ModifierArguments
	(ModifierId,                                       Name,   Value)
select
  a.ModifierId || '_POTALA_PALACE_DOUBLE_FOLLOWER',  b.Name, b.Value
from HD_FollowerBeliefModifiers a inner join ModifierArguments b on a.ModifierId = b.ModifierId;

--------------------------------------------------------------------------------------------------------------------
-- 圣索菲亚大教堂抢夺祭祀建筑
  -- 记录祭祀建筑信条与祭祀建筑的对应关系
create table HD_WorshipBeliefs_Buildings (
	BeliefType text not null,
	BuildingType text not null,
	primary key (BeliefType, BuildingType)
);

insert or replace into HD_WorshipBeliefs_Buildings
  (BeliefType, BuildingType)
select
  a.BeliefType, c.Value
from BeliefModifiers a
  inner join Beliefs b on a.BeliefType = b.BeliefType
  inner join ModifierArguments c on a.ModifierId = c.ModifierId
where b.BeliefClassType = 'BELIEF_CLASS_WORSHIP' and c.Name = 'BuildingType';

  -- 创建 Attach Modifier
create table HD_WorshipModifiers (
	BuildingType text not null,
	ModifierId text not null,
	primary key (BuildingType, ModifierId)
);

insert or replace into HD_WorshipModifiers
  (BuildingType,  ModifierId)
select
  a.BuildingType, b.ModifierId
from Buildings a inner join BuildingModifiers b on a.BuildingType = b.BuildingType
  where a.EnabledByReligion = 1 and b.ModifierId != 'RELIGIOUS_BUILDING_FAITH_PERCENTAGE_BOOST' and b.ModifierId not like 'HD_AI_%_GREAT_PERSON_CLASS_PROPHET';

insert or ignore into Modifiers
  (ModifierId,                                                                ModifierType,                               SubjectRequirementSetId)
select
  a.BuildingType || '_' || a.ModifierId || '_ATTACH_TO_' || b.BuildingType,   'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',   'CITY_HAS_' || b.BuildingType || '_REQUIREMENTS'
from HD_WorshipModifiers a, Buildings b where b.EnabledByReligion = 1 and a.BuildingType != b.BuildingType;

insert or ignore into ModifierArguments
	(ModifierId,                                                                Name,         Value)
select
  a.BuildingType || '_' || a.ModifierId || '_ATTACH_TO_' || b.BuildingType,   'ModifierId', ModifierId
from HD_WorshipModifiers a, Buildings b where b.EnabledByReligion = 1 and a.BuildingType != b.BuildingType;

--------------------------------------------------------------------------------------------------------------------
-- 李裪首都复制大科效果
create table HD_GreatScientistsModifiers (
	GreatPersonIndividualType text not null,
	ModifierId text not null,
  AttachmentTargetType text not null,
  DistrictType text,
	primary key (GreatPersonIndividualType, ModifierId)
);

insert or replace into HD_GreatScientistsModifiers
  (GreatPersonIndividualType, ModifierId, AttachmentTargetType, DistrictType)
select
  b.GreatPersonIndividualType, b.ModifierId, b.AttachmentTargetType, a.ActionRequiresCompletedDistrictType
from GreatPersonIndividuals a inner join GreatPersonIndividualActionModifiers b on a.GreatPersonIndividualType = b.GreatPersonIndividualType
  where a.GreatPersonClassType = 'GREAT_PERSON_CLASS_SCIENTIST';

insert or ignore into Modifiers
  (ModifierId,                                                    ModifierType,                                 SubjectRequirementSetId)
select
  GreatPersonIndividualType || '_' || ModifierId || '_ATTACH',   'MODIFIER_CITY_DISTRICTS_ATTACH_MODIFIER',    'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET'
from HD_GreatScientistsModifiers where AttachmentTargetType = 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE';

insert or ignore into ModifierArguments
	(ModifierId,                                                  Name,         Value)
select
  GreatPersonIndividualType || '_' || ModifierId || '_ATTACH',  'ModifierId', ModifierId
from HD_GreatScientistsModifiers where AttachmentTargetType = 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE';

--------------------------------------------------------------------------------------------------------------------
-- Lua 手动实现随机获得村庄奖励
create table HD_RandomGoodyHutReward (
	GoodyHut text not null,
	SubTypeGoodyHut text not null,
  Weight int not null,
  ModifierId text not null,
  Turn int not null,
	primary key (SubTypeGoodyHut)
);

insert or replace into HD_RandomGoodyHutReward
  (GoodyHut, SubTypeGoodyHut, Weight, ModifierId, Turn)
select
  a.GoodyHut, a.SubTypeGoodyHut, a.Weight, a.ModifierId, a.Turn
from GoodyHutSubTypes a inner join GoodyHuts b on a.GoodyHut = b.GoodyHutType
  where b.ImprovementType = 'IMPROVEMENT_GOODY_HUT'
  and a.UpgradeUnit = 0
  and a.Experience = 0
  and a.Heal = 0
  and a.Weight != 0;

--------------------------------------------------------------------------------------------------------------------
-- 信仰之战 劫掠瓶琴参数
insert or replace into ModifierArguments
	(ModifierId,								                                                Name,						          Value)
select
  'COMMEMORATION_HD_RELIGIOUS_WAR_PILLAGE_' || ImprovementType || '_SCIENCE', 'PlunderType',            'PLUNDER_SCIENCE'
from Improvements where PlunderType != 'NO_PLUNDER';

insert or replace into ModifierArguments
	(ModifierId,								                                                Name,						          Value)
select
  'COMMEMORATION_HD_RELIGIOUS_WAR_PILLAGE_' || ImprovementType || '_SCIENCE', 'ImprovementType',        ImprovementType
from Improvements where PlunderType != 'NO_PLUNDER';

insert or replace into ModifierArguments
	(ModifierId,								                                                Name,						          Value)
select
  'COMMEMORATION_HD_RELIGIOUS_WAR_PILLAGE_' || ImprovementType || '_SCIENCE', 'Amount',                 PlunderAmount
from Improvements where PlunderType != 'NO_PLUNDER';

-- insert or replace into ModifierArguments
-- 	(ModifierId,								                                                Name,						          Value)
-- select
--   'COMMEMORATION_HD_RELIGIOUS_WAR_PILLAGE_' || ImprovementType || '_CULTURE', 'PlunderType',            'PLUNDER_CULTURE'
-- from Improvements where PlunderType != 'NO_PLUNDER';

-- insert or replace into ModifierArguments
-- 	(ModifierId,								                                                Name,						          Value)
-- select
--   'COMMEMORATION_HD_RELIGIOUS_WAR_PILLAGE_' || ImprovementType || '_CULTURE', 'ImprovementType',        ImprovementType
-- from Improvements where PlunderType != 'NO_PLUNDER';

-- insert or replace into ModifierArguments
-- 	(ModifierId,								                                                Name,						          Value)
-- select
--   'COMMEMORATION_HD_RELIGIOUS_WAR_PILLAGE_' || ImprovementType || '_CULTURE', 'Amount',                 PlunderAmount
-- from Improvements where PlunderType != 'NO_PLUNDER';

--------------------------------------------------------------------------------------------------------------------
-- 首都区域梯田增产
create table if not exists Pachacuti_Modifiers_HD(
	ModifierId        TEXT    not NULL,
PRIMARY KEY('ModifierId'));

insert or replace into Pachacuti_Modifiers_HD (ModifierId)
	select 'HD_PACHACUTI_' || a.DistrictType || '_DOMESTIC_' || b.YieldType || '_BONUS'
from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsDomesticDestination != 0;

insert or replace into Pachacuti_Modifiers_HD (ModifierId)
	select 'HD_PACHACUTI_' || a.DistrictType || '_INTERNATIONAL_' || b.YieldType || '_BONUS'
from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsInternationalDestination != 0;

-- insert or replace into Modifiers (ModifierId, ModifierType)
-- 	select 'HD_PACHACUTI_' || a.DistrictType || '_DOMESTIC_' || b.YieldType || '_ATTACH', 'MODIFIER_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER'
-- from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsDomesticDestination != 0;

-- insert or replace into Modifiers (ModifierId, ModifierType)
-- 	select 'HD_PACHACUTI_' || a.DistrictType || '_INTERNATIONAL_' || b.YieldType || '_ATTACH', 'MODIFIER_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER'
-- from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsInternationalDestination != 0;

-- insert or replace into ModifierArguments (ModifierId, Name, Value)
-- 	select 'HD_PACHACUTI_' || a.DistrictType || '_DOMESTIC_' || b.YieldType || '_ATTACH',
-- 	'ModifierId',
-- 	'HD_PACHACUTI_' || a.DistrictType || '_INTERNATIONAL_' || b.YieldType || '_BONUS'
-- from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsDomesticDestination != 0;

-- insert or replace into ModifierArguments (ModifierId, Name, Value)
-- 	select 'HD_PACHACUTI_' || a.DistrictType || '_INTERNATIONAL_' || b.YieldType || '_ATTACH',
-- 	'ModifierId',
-- 	'HD_PACHACUTI_' || a.DistrictType || '_INTERNATIONAL_' || b.YieldType || '_BONUS'
-- from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsInternationalDestination != 0;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	select 'HD_PACHACUTI_' || a.DistrictType || '_DOMESTIC_' || b.YieldType || '_BONUS',
	'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
	'REQUIRES_CITY_HAS_' || a.DistrictType || '_UDMET',
	'PLOT_HAS_IMPROVEMENT_TERRACE_FARM_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsDomesticDestination != 0;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
	select 'HD_PACHACUTI_' || a.DistrictType || '_INTERNATIONAL_' || b.YieldType || '_BONUS',
	'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
	'REQUIRES_CITY_HAS_' || a.DistrictType || '_UDMET',
	'PLOT_HAS_IMPROVEMENT_MOUNTAIN_ROAD_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsInternationalDestination != 0;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_PACHACUTI_' || a.DistrictType || '_DOMESTIC_' || b.YieldType || '_BONUS', 'YieldType', b.YieldType
from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsDomesticDestination != 0;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_PACHACUTI_' || a.DistrictType || '_DOMESTIC_' || b.YieldType || '_BONUS', 'Amount', b.YieldChangeAsDomesticDestination
from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsDomesticDestination != 0;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_PACHACUTI_' || a.DistrictType || '_INTERNATIONAL_' || b.YieldType || '_BONUS', 'YieldType', b.YieldType
from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsInternationalDestination != 0;

insert or replace into ModifierArguments (ModifierId, Name, Value)
	select 'HD_PACHACUTI_' || a.DistrictType || '_INTERNATIONAL_' || b.YieldType || '_BONUS', 'Amount', b.YieldChangeAsInternationalDestination
from DistrictCorrespondingYieldType_HD a inner join District_TradeRouteYields b on a.DistrictType = b.DistrictType where a.HasAdjacency = 1 and b.YieldChangeAsInternationalDestination != 0;

--------------------------------------------------------------------------------------------------------------------
-- 记录城市开发的奢侈资源
-- insert or replace into GameModifiers (ModifierId) select
-- 	'HD_RECORD_CITY_HAS_' || ResourceType
-- 	from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY' and (Frequency != 0 or SeaFrequency != 0);

-- insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, SubjectStackLimit) select
-- 	'HD_RECORD_CITY_HAS_' || ResourceType, 'MODIFIER_ALL_CITIES_ADJUST_PROPERTY', 'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS', 1
-- 	from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY' and (Frequency != 0 or SeaFrequency != 0);

-- insert or replace into ModifierArguments (ModifierId, Name, Value) select
-- 	'HD_RECORD_CITY_HAS_' || ResourceType, 'Key', 'HD_CITY_HAS_IMPROVED_' || ResourceType
-- 	from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY' and (Frequency != 0 or SeaFrequency != 0);

-- insert or replace into ModifierArguments (ModifierId, Name, Value) select
-- 	'HD_RECORD_CITY_HAS_' || ResourceType, 'Amount', 1
-- 	from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY' and (Frequency != 0 or SeaFrequency != 0);

-- 获得一份奢侈资源
insert or ignore into Modifiers (ModifierId, ModifierType)
  select 'HD_GRANT_' || ResourceType, 'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT'
from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY' and (Frequency != 0 or SeaFrequency != 0);

insert or ignore into ModifierArguments (ModifierId, Name, Value)
  select 'HD_GRANT_' || ResourceType, 'ResourceType', ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY' and (Frequency != 0 or SeaFrequency != 0);

insert or ignore into ModifierArguments (ModifierId, Name, Value)
  select 'HD_GRANT_' || ResourceType, 'Amount', 1
from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY' and (Frequency != 0 or SeaFrequency != 0);

-- 城堡庄园
insert or replace into ImprovementModifiers (ImprovementType, ModifierId)
  select 'IMPROVEMENT_CHATEAU', 'HD_CHATEAU_GRANT_' || a.ResourceType || '_ATTACH'
from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
  where a.ResourceClassType = 'RESOURCECLASS_LUXURY' and (a.Frequency != 0 or a.SeaFrequency != 0) and b.ImprovementType in ('IMPROVEMENT_FARM', 'IMPROVEMENT_PLANTATION', 'IMPROVEMENT_LUMBER_MILL');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
  select 'HD_CHATEAU_GRANT_' || a.ResourceType || '_ATTACH', 'MODIFIER_PLAYER_IMPROVEMENTS_ATTACH_MODIFIER', 'HD_PLOT_HAS_' || a.ResourceType || '_ADJACENT'
from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
  where a.ResourceClassType = 'RESOURCECLASS_LUXURY' and (a.Frequency != 0 or a.SeaFrequency != 0) and b.ImprovementType in ('IMPROVEMENT_FARM', 'IMPROVEMENT_PLANTATION', 'IMPROVEMENT_LUMBER_MILL');

insert or replace into ModifierArguments (ModifierId, Name, Value)
  select 'HD_CHATEAU_GRANT_' || a.ResourceType || '_ATTACH', 'ModifierId', 'HD_GRANT_' || a.ResourceType
from Resources a inner join Improvement_ValidResources b on a.ResourceType = b.ResourceType
  where a.ResourceClassType = 'RESOURCECLASS_LUXURY' and (a.Frequency != 0 or a.SeaFrequency != 0) and b.ImprovementType in ('IMPROVEMENT_FARM', 'IMPROVEMENT_PLANTATION', 'IMPROVEMENT_LUMBER_MILL');

-------------------------------------------------------------------
-- 匈牙利国会大厦
create temporary table HD_OrszaghazModifiers (
	PolicyType text not null,
	OldModifierId text not null,
	NewModifierId text not null,
	primary key (PolicyType, OldModifierId)
);
insert or replace into HD_OrszaghazModifiers
  (PolicyType,	OldModifierId,		NewModifierId)
select
  PolicyType,		ModifierId,			'ORSZAGHAZ_GRANT_' || ModifierId
from PolicyModifiers where PolicyType in (select PolicyType from Policies where GovernmentSlotType = 'SLOT_GREAT_PERSON' or GovernmentSlotType = 'SLOT_WILDCARD');
insert or replace into Modifiers
  (ModifierId,	ModifierType,									SubjectRequirementSetId)
select
  NewModifierId,	'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',		'CITY_HAS_BUILDING_ORSZAGHAZ_REQUIREMENTS'
from HD_OrszaghazModifiers;
insert or replace into ModifierArguments
  (ModifierId,	Name,			Value)
select
  NewModifierId,	'ModifierId',	OldModifierId
from HD_OrszaghazModifiers;
insert or replace into PolicyModifiers
  (PolicyType,	ModifierId)
select
  PolicyType,		NewModifierId
from HD_OrszaghazModifiers;

-------------------------------------------------------------------
-- 单城送单位
insert or ignore into Modifiers (ModifierId, ModifierType, RunOnce, Permanent) select
  'HD_CITY_GRANT_' || UnitType, 'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY', 1, 1
from Units where UnitType not in (select UnitType from GreatPersonClasses);

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_CITY_GRANT_' || UnitType, 'UnitType', UnitType
from Units where UnitType not in (select UnitType from GreatPersonClasses);

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_CITY_GRANT_' || UnitType, 'Amount', 1
from Units where UnitType not in (select UnitType from GreatPersonClasses);

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_CITY_GRANT_' || UnitType, 'AllowUniqueOverride', 0
from Units where UnitType not in (select UnitType from GreatPersonClasses);
-------------------------------------------------------------------
-- 苏美尔 特殊城邦任务
  -- 建造单位
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description, PrereqTech, PrereqCivic) values
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_RECON',		 				'PROMOTION_CLASS_RECON',						'LOC_PROMOTION_CLASS_RECON_NAME',							NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_MELEE',		 				'PROMOTION_CLASS_MELEE',						'LOC_PROMOTION_CLASS_MELEE_NAME',							NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_RANGED',		 				'PROMOTION_CLASS_RANGED',						'LOC_PROMOTION_CLASS_RANGED_NAME',						NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_SIEGE',		 				'PROMOTION_CLASS_SIEGE',						'LOC_PROMOTION_CLASS_SIEGE_NAME',							NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_ANTI_CAVALRY',		 	'PROMOTION_CLASS_ANTI_CAVALRY',			'LOC_PROMOTION_CLASS_ANTI_CAVALRY_NAME',			NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_LIGHT_CAVALRY',		'PROMOTION_CLASS_LIGHT_CAVALRY',		'LOC_PROMOTION_CLASS_LIGHT_CAVALRY_NAME',			NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_HEAVY_CAVALRY',		'PROMOTION_CLASS_HEAVY_CAVALRY',		'LOC_PROMOTION_CLASS_HEAVY_CAVALRY_NAME',			NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_AIR_FIGHTER',		 	'PROMOTION_CLASS_AIR_FIGHTER',			'LOC_PROMOTION_CLASS_AIR_FIGHTER_NAME',				'TECH_FLIGHT', 				NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_AIR_BOMBER',		 		'PROMOTION_CLASS_AIR_BOMBER',				'LOC_PROMOTION_CLASS_AIR_BOMBER_NAME',				'TECH_ROCKETRY', 			NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_NAVAL_MELEE',		 	'PROMOTION_CLASS_NAVAL_MELEE',			'LOC_PROMOTION_CLASS_NAVAL_MELEE_NAME',				NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_NAVAL_RANGED',		 	'PROMOTION_CLASS_NAVAL_RANGED',			'LOC_PROMOTION_CLASS_NAVAL_RANGED_NAME',			'TECH_SHIPBUILDING', 	NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_NAVAL_CARRIER',		'PROMOTION_CLASS_NAVAL_CARRIER',		'LOC_PROMOTION_CLASS_NAVAL_CARRIER_NAME',			'TECH_COMBINED_ARMS', NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_NAVAL_RAIDER',		 	'PROMOTION_CLASS_NAVAL_RAIDER',			'LOC_PROMOTION_CLASS_NAVAL_RAIDER_NAME',			NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_SUPPORT',		  		'PROMOTION_CLASS_SUPPORT',					'LOC_PROMOTION_CLASS_SUPPORT_NAME',						NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_SPY',		 					'PROMOTION_CLASS_SPY',							'LOC_PROMOTION_CLASS_SPY_NAME',								NULL, 								NULL),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_ROCK_BAND',		 		'PROMOTION_CLASS_ROCK_BAND',				'LOC_PROMOTION_CLASS_ROCK_BAND_NAME',					NULL, 								'CIVIC_RECORDED_HISTORY'),
	('HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_PROMOTION_CLASS_GIANT_DEATH_ROBOT','PROMOTION_CLASS_GIANT_DEATH_ROBOT','LOC_PROMOTION_CLASS_GIANT_DEATH_ROBOT_NAME',	'TECH_ROBOTICS', 			NULL);

  -- 建造区域
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description, PrereqTech, PrereqCivic) select
  'HD_SPECIAL_QUEST_BUILD_DISTRICT',
  'HD_SPECIAL_SUBQUEST_BUILD_' || DistrictType,
  DistrictType,
  Name,
  PrereqTech,
  PrereqCivic
from Districts where TraitType is Null and MaxPerPlayer = -1 and DistrictType not in (
  'DISTRICT_CITY_CENTER', 'DISTRICT_WONDER'
);

  -- 招募伟人
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description) select
  'HD_SPECIAL_QUEST_RECRUIT_GREAT_PERSON_CLASS',
  'HD_SPECIAL_SUBQUEST_RECRUIT_' || GreatPersonClassType,
  GreatPersonClassType,
  Name
from GreatPersonClasses where AvailableInTimeline = 1 and GreatPersonClassType != 'GREAT_PERSON_CLASS_PROPHET';

  -- 尤里卡
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description, ObsoleteTech, ObsoleteEra) select
  'HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST',
  'HD_SPECIAL_SUBQUEST_TRIGGER_' || a.TechnologyType || '_BOOST',
  a.TechnologyType,
  b.Name,
  a.TechnologyType,
  b.EraType
from Boosts a inner join Technologies b on a.TechnologyType = b.TechnologyType;

  -- 鼓舞
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description, ObsoleteCivic, ObsoleteEra) select
  'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST',
  'HD_SPECIAL_SUBQUEST_TRIGGER_' || a.CivicType || '_BOOST',
  a.CivicType,
  b.Name,
  a.CivicType,
  b.EraType
from Boosts a inner join Civics b on a.CivicType = b.CivicType;

  -- 完成科技
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description, ObsoleteTech, ObsoleteEra) select
  'HD_SPECIAL_QUEST_FINISH_TECH',
  'HD_SPECIAL_SUBQUEST_FINISH_' || TechnologyType,
  TechnologyType,
  Name,
  TechnologyType,
  EraType
from Technologies where TechnologyType not in ('TECH_FUTURE_TECH', 'TECH_FAKE_TECH');

  -- 完成市政
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description, ObsoleteCivic, ObsoleteEra) select
  'HD_SPECIAL_QUEST_FINISH_CIVIC',
  'HD_SPECIAL_SUBQUEST_FINISH_' || CivicType,
  CivicType,
  Name,
  CivicType,
  EraType
from Civics where CivicType not in ('CIVIC_FUTURE_CIVIC', 'CIVIC_FAKE_CIVIC');

update Sumeria_CityState_Special_SubQuests_HD set PrereqEra = NULL, ObsoleteEra = NULL where ObsoleteEra = 'ERA_ANCIENT'
  and SpecialQuestType in ('HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_QUEST_FINISH_CIVIC');
update Sumeria_CityState_Special_SubQuests_HD set PrereqEra = 'ERA_ANCIENT', ObsoleteEra = NULL where ObsoleteEra = 'ERA_CLASSICAL'
  and SpecialQuestType in ('HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_QUEST_FINISH_CIVIC');
update Sumeria_CityState_Special_SubQuests_HD set PrereqEra = 'ERA_CLASSICAL', ObsoleteEra = NULL where ObsoleteEra = 'ERA_MEDIEVAL'
  and SpecialQuestType in ('HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_QUEST_FINISH_CIVIC');
update Sumeria_CityState_Special_SubQuests_HD set PrereqEra = 'ERA_MEDIEVAL', ObsoleteEra = NULL where ObsoleteEra = 'ERA_RENAISSANCE'
  and SpecialQuestType in ('HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_QUEST_FINISH_CIVIC');
update Sumeria_CityState_Special_SubQuests_HD set PrereqEra = 'ERA_RENAISSANCE', ObsoleteEra = NULL where ObsoleteEra = 'ERA_INDUSTRIAL'
  and SpecialQuestType in ('HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_QUEST_FINISH_CIVIC');
update Sumeria_CityState_Special_SubQuests_HD set PrereqEra = 'ERA_INDUSTRIAL', ObsoleteEra = NULL where ObsoleteEra = 'ERA_MODERN'
  and SpecialQuestType in ('HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_QUEST_FINISH_CIVIC');
update Sumeria_CityState_Special_SubQuests_HD set PrereqEra = 'ERA_MODERN', ObsoleteEra = NULL where ObsoleteEra = 'ERA_ATOMIC'
  and SpecialQuestType in ('HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_QUEST_FINISH_CIVIC');
update Sumeria_CityState_Special_SubQuests_HD set PrereqEra = 'ERA_ATOMIC', ObsoleteEra = NULL where ObsoleteEra = 'ERA_INFORMATION'
  and SpecialQuestType in ('HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_QUEST_FINISH_CIVIC');
update Sumeria_CityState_Special_SubQuests_HD set PrereqEra = 'ERA_INFORMATION', ObsoleteEra = NULL where ObsoleteEra = 'ERA_FUTURE'
  and SpecialQuestType in ('HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_QUEST_FINISH_CIVIC');

  -- 改良资源
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description) select distinct
  'HD_SPECIAL_QUEST_IMPROVE_RESOURCE',
  'HD_SPECIAL_SUBQUEST_IMPROVE_' || a.ImprovementType || '_RESOURCE',
  a.ImprovementType,
  b.Name
from Improvement_ValidResources a inner join Improvements b on a.ImprovementType = b.ImprovementType
where a.ImprovementType in (
  'IMPROVEMENT_FARM', 'IMPROVEMENT_MINE', 'IMPROVEMENT_QUARRY', 'IMPROVEMENT_FISHING_BOATS', 'IMPROVEMENT_PASTURE', 'IMPROVEMENT_PLANTATION', 'IMPROVEMENT_CAMP', 'IMPROVEMENT_LUMBER_MILL'
);

  -- 采用政体
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description, PrereqCivic, ObsoleteCivic) values
	('HD_SPECIAL_QUEST_CHANGE_ADVANCED_GOVERNMRNT', 'HD_SPECIAL_SUBQUEST_CHANGE_TIER_1_GOVERNMRNT', '1', 'LOC_TIER_1_GOVERNMRNT_NAME', NULL, 													'CIVIC_POLITICAL_PHILOSOPHY'),
	('HD_SPECIAL_QUEST_CHANGE_ADVANCED_GOVERNMRNT', 'HD_SPECIAL_SUBQUEST_CHANGE_TIER_2_GOVERNMRNT', '2', 'LOC_TIER_2_GOVERNMRNT_NAME', 'CIVIC_POLITICAL_PHILOSOPHY', 	'CIVIC_CIVIL_SERVICE'),
	('HD_SPECIAL_QUEST_CHANGE_ADVANCED_GOVERNMRNT', 'HD_SPECIAL_SUBQUEST_CHANGE_TIER_3_GOVERNMRNT', '3', 'LOC_TIER_3_GOVERNMRNT_NAME', 'CIVIC_CIVIL_SERVICE', 				'CIVIC_IDEOLOGY'),
	('HD_SPECIAL_QUEST_CHANGE_ADVANCED_GOVERNMRNT', 'HD_SPECIAL_SUBQUEST_CHANGE_TIER_4_GOVERNMRNT', '4', 'LOC_TIER_4_GOVERNMRNT_NAME', 'CIVIC_IDEOLOGY', 							'CIVIC_GLOBALIZATION');

  -- 建造特殊改良
insert or ignore into Sumeria_CityState_Special_SubQuests_HD (SpecialQuestType, SpecialSubQuestType, ObjectType, Description, PrereqTech, PrereqCivic) select
  'HD_SPECIAL_QUEST_BUILD_SPECIAL_IMPROVEMENT',
  'HD_SPECIAL_SUBQUEST_BUILD_' || ImprovementType,
  ImprovementType,
  Name,
  PrereqTech,
  PrereqCivic
from Improvements where ImprovementType in (
  'IMPROVEMENT_INDUSTRY', 'IMPROVEMENT_CORPORATION',
  'IMPROVEMENT_LEU_STATION', 'IMPROVEMENT_LEU_WAREHOUSE','IMPROVEMENT_LEU_CONTAINER_PORT',
  'IMPROVEMENT_MOUNTAIN_TUNNEL', 'IMPROVEMENT_BEACH_RESORT', 'IMPROVEMENT_SKI_RESORT', 'IMPROVEMENT_SEASTEAD',
  'IMPROVEMENT_SAILOR_WATCHTOWER', 'IMPROVEMENT_FORT', 'IMPROVEMENT_AIRSTRIP', 'IMPROVEMENT_MISSILE_SILO',
  'IMPROVEMENT_SOLAR_FARM', 'IMPROVEMENT_WIND_FARM', 'IMPROVEMENT_GEOTHERMAL_PLANT', 'IMPROVEMENT_OFFSHORE_WIND_FARM'
);
update Sumeria_CityState_Special_SubQuests_HD set PrereqTech = 'TECH_APPRENTICESHIP' where SpecialSubQuestType = 'HD_SPECIAL_SUBQUEST_BUILD_IMPROVEMENT_INDUSTRY';
update Sumeria_CityState_Special_SubQuests_HD set PrereqTech = 'TECH_ECONOMICS' where SpecialSubQuestType = 'HD_SPECIAL_SUBQUEST_BUILD_IMPROVEMENT_CORPORATION';
update Sumeria_CityState_Special_Quests_HD set PrereqTech = 'TECH_MILITARY_ENGINEERING' where SpecialQuestType = 'HD_SPECIAL_QUEST_BUILD_SPECIAL_IMPROVEMENT';
update Sumeria_CityState_Special_Quests_HD set PrereqTech = 'TECH_MILITARY_ENGINEERING' where SpecialQuestType = 'HD_SPECIAL_QUEST_BUILD_SPECIAL_IMPROVEMENT'
  and exists (select ImprovementType from Improvements where ImprovementType = 'IMPROVEMENT_INDUSTRY');
update Sumeria_CityState_Special_Quests_HD set PrereqTech = Null where SpecialQuestType = 'HD_SPECIAL_QUEST_BUILD_SPECIAL_IMPROVEMENT'
  and exists (select ImprovementType from Improvements where ImprovementType = 'IMPROVEMENT_SAILOR_WATCHTOWER');

  -- 补充特殊任务描述
update Sumeria_CityState_Special_Quests_HD set Description = 'LOC_' || SpecialQuestType || '_DESCRIPTION';
  -- 记录需要次级任务的特殊任务
update Sumeria_CityState_Special_Quests_HD set HasSubType = 1 where SpecialQuestType in
  (select SpecialQuestType from Sumeria_CityState_Special_SubQuests_HD);
-------------------------------------------------------------------
-- 苏美尔 特殊城邦奖励
  -- 伟人点
insert or ignore into Sumeria_CityState_Special_Quest_SubRewards_HD (SpecialRewardType, SpecialSubRewardType, ObjectType, Description, PrereqCityStateType)
  select 'HD_SPECIAL_QUEST_REWARD_GPP', 'HD_SPECIAL_QUEST_REWARD_' || a.GreatPersonClassType, a.GreatPersonClassType, b.Name, a.CityStateType
from CityStateCorrespondingGPP_HD a inner join GreatPersonClasses b on a.GreatPersonClassType = b.GreatPersonClassType where a.GreatPersonClassType != 'GREAT_PERSON_CLASS_PROPHET';

  -- 战略资源
insert or ignore into Sumeria_CityState_Special_Quest_SubRewards_HD (SpecialRewardType, SpecialSubRewardType, ObjectType, Description, PrereqEra, ObsoleteEra) values
	('HD_SPECIAL_QUEST_REWARD_STRATEGIC_RESOURCE', 	'HD_SPECIAL_QUEST_REWARD_RESOURCE_HORSES',		'RESOURCE_HORSES',		'LOC_RESOURCE_HORSES_NAME',		NULL,							'ERA_RENAISSANCE'),
	('HD_SPECIAL_QUEST_REWARD_STRATEGIC_RESOURCE', 	'HD_SPECIAL_QUEST_REWARD_RESOURCE_IRON',			'RESOURCE_IRON',			'LOC_RESOURCE_IRON_NAME',			NULL,							'ERA_RENAISSANCE'),
	('HD_SPECIAL_QUEST_REWARD_STRATEGIC_RESOURCE', 	'HD_SPECIAL_QUEST_REWARD_RESOURCE_NITER',			'RESOURCE_NITER',			'LOC_RESOURCE_NITER_NAME',		'ERA_CLASSICAL',	'ERA_INDUSTRIAL'),
	('HD_SPECIAL_QUEST_REWARD_STRATEGIC_RESOURCE', 	'HD_SPECIAL_QUEST_REWARD_RESOURCE_COAL',			'RESOURCE_COAL',			'LOC_RESOURCE_COAL_NAME',			'ERA_CLASSICAL',	'ERA_ATOMIC'),
	('HD_SPECIAL_QUEST_REWARD_STRATEGIC_RESOURCE', 	'HD_SPECIAL_QUEST_REWARD_RESOURCE_OIL',				'RESOURCE_OIL',				'LOC_RESOURCE_OIL_NAME',			'ERA_INDUSTRIAL',	NULL),
	('HD_SPECIAL_QUEST_REWARD_STRATEGIC_RESOURCE', 	'HD_SPECIAL_QUEST_REWARD_RESOURCE_ALUMINUM',	'RESOURCE_ALUMINUM',	'LOC_RESOURCE_ALUMINUM_NAME',	'ERA_MODERN',			NULL),
	('HD_SPECIAL_QUEST_REWARD_STRATEGIC_RESOURCE', 	'HD_SPECIAL_QUEST_REWARD_RESOURCE_URANIUM',		'RESOURCE_URANIUM',		'LOC_RESOURCE_URANIUM_NAME',	'ERA_ATOMIC',			NULL);

  -- 奢侈资源
insert or ignore into Sumeria_CityState_Special_Quest_SubRewards_HD (SpecialRewardType, SpecialSubRewardType, ObjectType, Description, ModifierId) select
  'HD_SPECIAL_QUEST_REWARD_LUXURY_RESOURCE',
  'HD_SPECIAL_QUEST_REWARD_' || ResourceType,
  ResourceType,
  Name,
  'HD_GRANT_' || ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY' and (Frequency != 0 or SeaFrequency != 0);

  -- 区域相邻
insert or ignore into Sumeria_CityState_Special_Quest_SubRewards_HD (SpecialRewardType, SpecialSubRewardType, ObjectType, Description, ModifierId, PrereqCityStateType) select
  'HD_SPECIAL_QUEST_REWARD_DISTRICT_ADJACENCY',
  'HD_SPECIAL_QUEST_REWARD_' || a.DistrictType || '_ADJACENCY',
  a.DistrictType,
  b.Name,
  'HD_SPECIAL_QUEST_REWARD_' || a.DistrictType || '_ADJACENCY_MODIFIER',
  a.CityStateType
from CityStateCorrespondingDistrict_HD a inner join Districts b on a.DistrictType = b.DistrictType;

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId, Permanent) select
  'HD_SPECIAL_QUEST_REWARD_' || DistrictType || '_ADJACENCY_MODIFIER',
  'MODIFIER_PLAYER_DISTRICTS_ADJUST_BASE_YIELD_CHANGE',
  'DISTRICT_IS_' || DistrictType || '_REQUIREMENTS',
  1
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_SPECIAL_QUEST_REWARD_' || DistrictType || '_ADJACENCY_MODIFIER', 'YieldType', YieldType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_SPECIAL_QUEST_REWARD_' || DistrictType || '_ADJACENCY_MODIFIER', 'Amount', 1
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

  -- 军事单位
insert or ignore into Sumeria_CityState_Special_Quest_SubRewards_HD (SpecialRewardType, SpecialSubRewardType, ObjectType, Description, PrereqEra) values
	('HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_RECON',							'PROMOTION_CLASS_RECON',							'LOC_PROMOTION_CLASS_RECON_NAME',							NULL),
	('HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_MELEE',							'PROMOTION_CLASS_MELEE',							'LOC_PROMOTION_CLASS_MELEE_NAME',							NULL),
	('HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_RANGED',							'PROMOTION_CLASS_RANGED',							'LOC_PROMOTION_CLASS_RANGED_NAME',						NULL),
	('HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_SIEGE',							'PROMOTION_CLASS_SIEGE',							'LOC_PROMOTION_CLASS_SIEGE_NAME',							NULL),
	('HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_ANTI_CAVALRY',				'PROMOTION_CLASS_ANTI_CAVALRY',				'LOC_PROMOTION_CLASS_ANTI_CAVALRY_NAME',			NULL),
	('HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_LIGHT_CAVALRY',			'PROMOTION_CLASS_LIGHT_CAVALRY',			'LOC_PROMOTION_CLASS_LIGHT_CAVALRY_NAME',			NULL),
	('HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_HEAVY_CAVALRY',			'PROMOTION_CLASS_HEAVY_CAVALRY',			'LOC_PROMOTION_CLASS_HEAVY_CAVALRY_NAME',			NULL),
	('HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_GIANT_DEATH_ROBOT',	'PROMOTION_CLASS_GIANT_DEATH_ROBOT',	'LOC_PROMOTION_CLASS_GIANT_DEATH_ROBOT_NAME',	'ERA_INFORMATION'),
	('HD_SPECIAL_QUEST_REWARD_GRANT_SEA_UNIT', 			'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_NAVAL_MELEE',				'PROMOTION_CLASS_NAVAL_MELEE',				'LOC_PROMOTION_CLASS_NAVAL_MELEE_NAME',				NULL),
	('HD_SPECIAL_QUEST_REWARD_GRANT_SEA_UNIT', 			'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_NAVAL_RANGED',				'PROMOTION_CLASS_NAVAL_RANGED',				'LOC_PROMOTION_CLASS_NAVAL_RANGED_NAME',			NULL),
	('HD_SPECIAL_QUEST_REWARD_GRANT_SEA_UNIT', 			'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_NAVAL_CARRIER',			'PROMOTION_CLASS_NAVAL_CARRIER',			'LOC_PROMOTION_CLASS_NAVAL_CARRIER_NAME',			'ERA_ATOMIC'),
	('HD_SPECIAL_QUEST_REWARD_GRANT_SEA_UNIT', 			'HD_SPECIAL_QUEST_REWARD_GRANT_PROMOTION_CLASS_NAVAL_RAIDER',				'PROMOTION_CLASS_NAVAL_RAIDER',				'LOC_PROMOTION_CLASS_NAVAL_RAIDER_NAME',			NULL);

  -- 支援单位
insert or ignore into Sumeria_CityState_Special_Quest_SubRewards_HD (SpecialRewardType, SpecialSubRewardType, ObjectType, Description, ModifierId) select
  'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT',
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || UnitType,
  UnitType,
  Name,
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || UnitType || '_MODIFIER'
from Units where (FormationClass = 'FORMATION_CLASS_SUPPORT' and TraitType is Null) or UnitType = 'UNIT_PLUM_INTERNAL_SECURITY_HD';

update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = NULL, ObsoleteEra = 'ERA_MEDIEVAL'
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_SAPPER';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = 'ERA_MEDIEVAL', ObsoleteEra = 'ERA_INDUSTRIAL'
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_MILITARY_ENGINEER';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = 'ERA_INDUSTRIAL', ObsoleteEra = NULL
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_ENGINEER_CORP';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = NULL, ObsoleteEra = 'ERA_MEDIEVAL'
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_BATTERING_RAM';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = 'ERA_MEDIEVAL', ObsoleteEra = 'ERA_INDUSTRIAL'
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_SIEGE_TOWER';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = 'ERA_INDUSTRIAL', ObsoleteEra = 'ERA_ATOMIC'
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_OBSERVATION_BALLOON';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = 'ERA_ATOMIC', ObsoleteEra = NULL
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_DRONE';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = 'ERA_RENAISSANCE', ObsoleteEra = 'ERA_MODERN'
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_MEDIC';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = 'ERA_MODERN', ObsoleteEra = NULL
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_SUPPLY_CONVOY';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = 'ERA_MODERN', ObsoleteEra = 'ERA_INFORMATION'
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_ANTIAIR_GUN';
update Sumeria_CityState_Special_Quest_SubRewards_HD set PrereqEra = 'ERA_INFORMATION', ObsoleteEra = NULL
  where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_SUPPORT_UNIT' and ObjectType = 'UNIT_MOBILE_SAM';

insert or replace into Modifiers (ModifierId, ModifierType, RunOnce, Permanent) select
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || UnitType || '_MODIFIER',
  'MODIFIER_PLAYER_GRANT_UNIT_IN_CAPITAL',
  1,
  1
from Units where (FormationClass = 'FORMATION_CLASS_SUPPORT' and TraitType is Null) or UnitType = 'UNIT_PLUM_INTERNAL_SECURITY_HD';

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || UnitType || '_MODIFIER', 'UnitType', UnitType
from Units where (FormationClass = 'FORMATION_CLASS_SUPPORT' and TraitType is Null) or UnitType = 'UNIT_PLUM_INTERNAL_SECURITY_HD';

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || UnitType || '_MODIFIER', 'Amount', 1
from Units where (FormationClass = 'FORMATION_CLASS_SUPPORT' and TraitType is Null) or UnitType = 'UNIT_PLUM_INTERNAL_SECURITY_HD';

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || UnitType || '_MODIFIER', 'AllowUniqueOverride', 0
from Units where (FormationClass = 'FORMATION_CLASS_SUPPORT' and TraitType is Null) or UnitType = 'UNIT_PLUM_INTERNAL_SECURITY_HD';

  -- 文化传播单位
insert or ignore into Sumeria_CityState_Special_Quest_SubRewards_HD (SpecialRewardType, SpecialSubRewardType, ObjectType, Description, PrereqEra) values
  ('HD_SPECIAL_QUEST_REWARD_GRANT_CULTURAL_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_UNIT_ROCK_BAND',							'UNIT_ROCK_BAND',							'LOC_UNIT_ROCK_BAND_NAME',							'ERA_INDUSTRIAL'),
  ('HD_SPECIAL_QUEST_REWARD_GRANT_CULTURAL_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_UNIT_ORAL_SCHOLAR',					'UNIT_ORAL_SCHOLAR',					'LOC_UNIT_ORAL_SCHOLAR_NAME',						NULL),
  ('HD_SPECIAL_QUEST_REWARD_GRANT_CULTURAL_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_UNIT_TRAVEL_THEATRE',				'UNIT_TRAVEL_THEATRE',				'LOC_UNIT_TRAVEL_THEATRE_NAME',					'ERA_MEDIEVAL'),
  ('HD_SPECIAL_QUEST_REWARD_GRANT_CULTURAL_UNIT', 		'HD_SPECIAL_QUEST_REWARD_GRANT_UNIT_MALI_GRIOTS',						'UNIT_MALI_GRIOTS',						'LOC_UNIT_MALI_GRIOTS_NAME',						NULL);
update Sumeria_CityState_Special_Quest_SubRewards_HD set ModifierId = 'HD_SPECIAL_QUEST_REWARD_GRANT_' || ObjectType || '_MODIFIER' where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_CULTURAL_UNIT';

insert or replace into Modifiers (ModifierId, ModifierType, RunOnce, Permanent) select
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || ObjectType || '_MODIFIER',
  'MODIFIER_PLAYER_GRANT_UNIT_IN_CAPITAL',
  1,
  1
from Sumeria_CityState_Special_Quest_SubRewards_HD where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_CULTURAL_UNIT';

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || ObjectType || '_MODIFIER', 'UnitType', ObjectType
from Sumeria_CityState_Special_Quest_SubRewards_HD where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_CULTURAL_UNIT';

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || ObjectType || '_MODIFIER', 'Amount', 1
from Sumeria_CityState_Special_Quest_SubRewards_HD where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_CULTURAL_UNIT';

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_SPECIAL_QUEST_REWARD_GRANT_' || ObjectType || '_MODIFIER', 'AllowUniqueOverride', 0
from Sumeria_CityState_Special_Quest_SubRewards_HD where SpecialRewardType = 'HD_SPECIAL_QUEST_REWARD_GRANT_CULTURAL_UNIT';

  -- 补充特殊奖励描述
update Sumeria_CityState_Special_Quest_Rewards_HD set Description = 'LOC_' || SpecialRewardType || '_DESCRIPTION';
  -- 记录需要次级奖励的特殊奖励
update Sumeria_CityState_Special_Quest_Rewards_HD set HasSubType = 1 where SpecialRewardType in
  (select SpecialRewardType from Sumeria_CityState_Special_Quest_SubRewards_HD);

  -- Debug 暂时去除所有特殊任务或奖励的前置条件
-- update Sumeria_CityState_Special_Quests_HD set
--   PrereqEra = NULL,
--   PrereqTech = NULL,
--   PrereqCivic = NULL,
--   ObsoleteEra = NULL,
--   ObsoleteTech = NULL,
--   ObsoleteCivic = NULL;

-- update Sumeria_CityState_Special_SubQuests_HD set
--   PrereqEra = NULL,
--   PrereqTech = NULL,
--   PrereqCivic = NULL,
--   ObsoleteEra = NULL,
--   ObsoleteTech = NULL,
--   ObsoleteCivic = NULL;

-- update Sumeria_CityState_Special_Quest_Rewards_HD set
--   PrereqEra = NULL,
--   PrereqTech = NULL,
--   PrereqCivic = NULL,
--   ObsoleteEra = NULL,
--   ObsoleteTech = NULL,
--   ObsoleteCivic = NULL,
--   PrereqCityStateType = NULL,
--   MinTurn = 0;

-- update Sumeria_CityState_Special_Quest_SubRewards_HD set
--   PrereqEra = NULL,
--   PrereqTech = NULL,
--   PrereqCivic = NULL,
--   ObsoleteEra = NULL,
--   ObsoleteTech = NULL,
--   ObsoleteCivic = NULL,
--   PrereqCityStateType = NULL,
--   MinTurn = 0;

-------------------------------------------------------------------
-- 城市记录改良数量
insert or replace into ImprovementModifiers (ImprovementType, ModifierId)
  select ImprovementType, 'HD_CITY_' || ImprovementType || '_COUNT_RECORD'
from ImprovementsNeedCount_HD;

insert or replace into Modifiers (ModifierId, ModifierType)
  select 'HD_CITY_' || ImprovementType || '_COUNT_RECORD', 'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY'
from ImprovementsNeedCount_HD;

insert or replace into ModifierArguments (ModifierId, Name, Value)
  select 'HD_CITY_' || ImprovementType || '_COUNT_RECORD', 'Key', 'HD_CITY_IMPROVEMENT_NUM_' || ImprovementType
from ImprovementsNeedCount_HD;

insert or replace into ModifierArguments (ModifierId, Name, Value)
  select 'HD_CITY_' || ImprovementType || '_COUNT_RECORD', 'Amount', 1
from ImprovementsNeedCount_HD;