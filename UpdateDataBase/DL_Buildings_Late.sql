-- 官邸
	-- 总督点
insert or replace into GameModifiers (ModifierId) values
	('HD_MANSION_AWARD_GOVERNOR');

insert or replace into Modifiers
	(ModifierId,                      ModifierType,                                    SubjectRequirementSetId,                    			RunOnce,Permanent,SubjectStackLimit)
values
	('HD_MANSION_AWARD_GOVERNOR',     'MODIFIER_ALL_PLAYERS_ADJUST_GOVERNOR_POINTS',   'PLAYER_HAS_BUILDING_HD_MANSION_REQUIREMENTS',  	1,      1,        1);

insert or replace into ModifierArguments
	(ModifierId,	                 	Name,	      Value)
values
	('HD_MANSION_AWARD_GOVERNOR',		'Delta',		1);

	-- 辐射复制
		-- 基础产出
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'BUILDING_HD_MANSION',	'HD_MANSION_' || a.BuildingType || '_' || b.YieldType || '_ATTACH'
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into Modifiers
	(ModifierId,	                                            						ModifierType,                                 SubjectRequirementSetId)
select
	'HD_MANSION_' || a.BuildingType || '_' || b.YieldType || '_ATTACH',		'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	'HD_PLOT_HAS_WONDER_' || a.BuildingType || '_REQUIREMENTS'
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                        							Name,	        Value)
select
	'HD_MANSION_' || a.BuildingType || '_' || b.YieldType || '_ATTACH',	'ModifierId',	'HD_MANSION_' || a.BuildingType || '_' || b.YieldType
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into Modifiers
	(ModifierId,	                                            ModifierType,                                 			SubjectRequirementSetId)
select
	'HD_MANSION_' || a.BuildingType || '_' || b.YieldType,		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',	'CITY_HAS_NEIGHBORHOOD_GOVERNOR_WITHIN_' || a.RegionalRange || '_TILES'
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                        	Name,	        Value)
select
	'HD_MANSION_' || a.BuildingType || '_' || b.YieldType,	'YieldType',	b.YieldType
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                        	Name,	        Value)
select
	'HD_MANSION_' || a.BuildingType || '_' || b.YieldType,	'Amount',			b.YieldChange
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

		-- 通电产出
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'BUILDING_HD_MANSION',	'HD_MANSION_POWERED_' || a.BuildingType || '_' || b.YieldType || '_ATTACH'
from Buildings a inner join Building_YieldChangesBonusWithPower b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into Modifiers
	(ModifierId,	                                            										ModifierType,                                 SubjectRequirementSetId)
select
	'HD_MANSION_POWERED_' || a.BuildingType || '_' || b.YieldType || '_ATTACH',		'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	'HD_PLOT_HAS_WONDER_' || a.BuildingType || '_REQUIREMENTS'
from Buildings a inner join Building_YieldChangesBonusWithPower b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                        											Name,	        Value)
select
	'HD_MANSION_POWERED_' || a.BuildingType || '_' || b.YieldType || '_ATTACH',	'ModifierId',	'HD_MANSION_POWERED_' || a.BuildingType || '_' || b.YieldType
from Buildings a inner join Building_YieldChangesBonusWithPower b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into Modifiers
	(ModifierId,	                                            				ModifierType,                                 			OwnerRequirementSetId,	SubjectRequirementSetId)
select
	'HD_MANSION_POWERED_' || a.BuildingType || '_' || b.YieldType,		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',	'CITY_IS_POWERED',			'CITY_HAS_NEIGHBORHOOD_GOVERNOR_WITHIN_' || a.RegionalRange || '_TILES'
from Buildings a inner join Building_YieldChangesBonusWithPower b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                        					Name,	        Value)
select
	'HD_MANSION_POWERED_' || a.BuildingType || '_' || b.YieldType,	'YieldType',	b.YieldType
from Buildings a inner join Building_YieldChangesBonusWithPower b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                        					Name,	        Value)
select
	'HD_MANSION_POWERED_' || a.BuildingType || '_' || b.YieldType,	'Amount',			b.YieldChange
from Buildings a inner join Building_YieldChangesBonusWithPower b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and a.BuildingType not like '%_INTERNAL';

		-- 宜居度
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'BUILDING_HD_MANSION',	'HD_MANSION_' || BuildingType || '_AMENITY_ATTACH'
from Buildings where IsWonder = 1 and RegionalRange != 0 and Entertainment != 0 and BuildingType not like '%_INTERNAL';

insert or replace into Modifiers
	(ModifierId,	                                        ModifierType,                                 SubjectRequirementSetId)
select
	'HD_MANSION_' || BuildingType || '_AMENITY_ATTACH',		'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	'HD_PLOT_HAS_WONDER_' || BuildingType || '_REQUIREMENTS'
from Buildings where IsWonder = 1 and RegionalRange != 0 and Entertainment != 0 and BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                       	Name,	        Value)
select
	'HD_MANSION_' || BuildingType || '_AMENITY_ATTACH',		'ModifierId',	'HD_MANSION_' || BuildingType || '_AMENITY'
from Buildings where IsWonder = 1 and RegionalRange != 0 and Entertainment != 0 and BuildingType not like '%_INTERNAL';

insert or replace into Modifiers
	(ModifierId,	                                  ModifierType,                                 	SubjectRequirementSetId)
select
	'HD_MANSION_' || BuildingType || '_AMENITY',		'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',	'CITY_HAS_NEIGHBORHOOD_GOVERNOR_WITHIN_' || RegionalRange || '_TILES'
from Buildings where IsWonder = 1 and RegionalRange != 0 and Entertainment != 0 and BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                  Name,	        Value)
select
	'HD_MANSION_' || BuildingType || '_AMENITY',		'Amount',			Entertainment
from Buildings where IsWonder = 1 and RegionalRange != 0 and Entertainment != 0 and BuildingType not like '%_INTERNAL';

		-- 通电宜居度
insert or replace into BuildingModifiers
	(BuildingType,					ModifierId)
select
	'BUILDING_HD_MANSION',	'HD_MANSION_POWERED_' || a.BuildingType || '_AMENITY_ATTACH'
from Buildings a inner join Buildings_XP2 b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and b.EntertainmentBonusWithPower != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into Modifiers
	(ModifierId,	                                        					ModifierType,                                 SubjectRequirementSetId)
select
	'HD_MANSION_POWERED_' || a.BuildingType || '_AMENITY_ATTACH',		'MODIFIER_PLAYER_DISTRICTS_ATTACH_MODIFIER',	'HD_PLOT_HAS_WONDER_' || a.BuildingType || '_REQUIREMENTS'
from Buildings a inner join Buildings_XP2 b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and b.EntertainmentBonusWithPower != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                       						Name,	        Value)
select
	'HD_MANSION_POWERED_' || a.BuildingType || '_AMENITY_ATTACH',		'ModifierId',	'HD_MANSION_POWERED_' || a.BuildingType || '_AMENITY'
from Buildings a inner join Buildings_XP2 b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and b.EntertainmentBonusWithPower != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into Modifiers
	(ModifierId,	                                  					ModifierType,                                 	OwnerRequirementSetId,	SubjectRequirementSetId)
select
	'HD_MANSION_POWERED_' || a.BuildingType || '_AMENITY',		'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',	'CITY_IS_POWERED',			'CITY_HAS_NEIGHBORHOOD_GOVERNOR_WITHIN_' || a.RegionalRange || '_TILES'
from Buildings a inner join Buildings_XP2 b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and b.EntertainmentBonusWithPower != 0 and a.BuildingType not like '%_INTERNAL';

insert or replace into ModifierArguments
	(ModifierId,	                                  					Name,	        Value)
select
	'HD_MANSION_POWERED_' || a.BuildingType || '_AMENITY',		'Amount',			b.EntertainmentBonusWithPower
from Buildings a inner join Buildings_XP2 b on a.BuildingType = b.BuildingType
	where a.IsWonder = 1 and a.RegionalRange != 0 and b.EntertainmentBonusWithPower != 0 and a.BuildingType not like '%_INTERNAL';

  -- Reqs
insert or ignore into RequirementSets
	(RequirementSetId,																											RequirementSetType)
select
	'CITY_HAS_NEIGHBORHOOD_GOVERNOR_WITHIN_' || RegionalRange || '_TILES',	'REQUIREMENTSET_TEST_ALL'
from Buildings where IsWonder = 1 and RegionalRange != 0 and BuildingType not like '%_INTERNAL';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,																											RequirementId)
select
	'CITY_HAS_NEIGHBORHOOD_GOVERNOR_WITHIN_' || RegionalRange || '_TILES',	'REQUIRES_OBJECT_WITHIN_' || RegionalRange || '_TILES'
from Buildings where IsWonder = 1 and RegionalRange != 0 and BuildingType not like '%_INTERNAL';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,																											RequirementId)
select
	'CITY_HAS_NEIGHBORHOOD_GOVERNOR_WITHIN_' || RegionalRange || '_TILES',	'REQUIRES_CITY_HAS_GOVERNOR'
from Buildings where IsWonder = 1 and RegionalRange != 0 and BuildingType not like '%_INTERNAL';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,																											RequirementId)
select
	'CITY_HAS_NEIGHBORHOOD_GOVERNOR_WITHIN_' || RegionalRange || '_TILES',	'REQUIRES_CITY_HAS_DISTRICT_NEIGHBORHOOD'
from Buildings where IsWonder = 1 and RegionalRange != 0 and BuildingType not like '%_INTERNAL';