-------------------------------------
--            Vikings DLC          --
-------------------------------------

-- Natural Wonders
insert or replace into Feature_AdjacentYields
	(FeatureType,				YieldType,				YieldChange)
values
	('FEATURE_LYSEFJORDEN',		'YIELD_PRODUCTION',		1);
insert or ignore into RequirementSetRequirements
	(RequirementSetId,                                          RequirementId)
values
	('GODDESS_OF_FIRE_CITY_HAS_VOLCANO',                        'REQUIRES_CITY_HAS_FEATURE_EYJAFJALLAJOKULL');

-- =====================================================================================================================================
-- 修道院 下放通用
-- =====================================================================================================================================
insert or ignore into ImprovementsNeedCount_HD (ImprovementType) values ('IMPROVEMENT_MONASTERY');
update Improvements set TraitType = NULL, Housing = 1, TilesRequired = 1, PrereqCivic = 'CIVIC_THEOLOGY', SameAdjacentValid = 1,
	Description = 'LOC_IMPROVEMENT_MONASTERY_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_MONASTERY';
delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_MONASTERY';
delete from ImprovementModifiers where ImprovementType = 'IMPROVEMENT_MONASTERY';

insert or replace into Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) values
	('IMPROVEMENT_MONASTERY', 'YIELD_FAITH', 		1),
	('IMPROVEMENT_MONASTERY', 'YIELD_CULTURE', 	1);

insert or ignore into ImprovementModifiers (ImprovementType, ModifierId) values
	('IMPROVEMENT_MONASTERY', 'HD_MONASTERY_BUILDER_PURCHASE');

insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
	('HD_MONASTERY_BUILDER_PURCHASE', 		'MODIFIER_CITY_ENABLE_UNIT_FAITH_PURCHASE', NULL);

insert or ignore into ModifierArguments (ModifierId, Name, Value) values
	('HD_MONASTERY_BUILDER_PURCHASE', 	'Tag', 		'CLASS_BUILDER');

-- 本体产出
insert or ignore into ImprovementModifiers (ImprovementType, ModifierId) select
	'IMPROVEMENT_MONASTERY', 'HD_MONASTERY_PRODUCTION_FAITH_' || ResourceType
from HD_Resource_Classification where ResourceClassificationType = 'RESOURCE_CLASSIFICATION_HD_BREWING';

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
	'HD_MONASTERY_PRODUCTION_FAITH_' || ResourceType, 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIREMENTS'
from HD_Resource_Classification where ResourceClassificationType = 'RESOURCE_CLASSIFICATION_HD_BREWING';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_MONASTERY_PRODUCTION_FAITH_' || ResourceType, 'YieldType', 'YIELD_PRODUCTION,YIELD_FAITH'
from HD_Resource_Classification where ResourceClassificationType = 'RESOURCE_CLASSIFICATION_HD_BREWING';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_MONASTERY_PRODUCTION_FAITH_' || ResourceType, 'Amount', '1,1'
from HD_Resource_Classification where ResourceClassificationType = 'RESOURCE_CLASSIFICATION_HD_BREWING';

insert or ignore into ImprovementModifiers (ImprovementType, ModifierId) select
	'IMPROVEMENT_MONASTERY', 'HD_MONASTERY_CULTURE_FAITH_' || ResourceType
from HD_Resource_Classification where ResourceClassificationType = 'RESOURCE_CLASSIFICATION_HD_STATIONERY';

insert or ignore into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
	'HD_MONASTERY_CULTURE_FAITH_' || ResourceType, 'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIREMENTS'
from HD_Resource_Classification where ResourceClassificationType = 'RESOURCE_CLASSIFICATION_HD_STATIONERY';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_MONASTERY_CULTURE_FAITH_' || ResourceType, 'YieldType', 'YIELD_CULTURE,YIELD_FAITH'
from HD_Resource_Classification where ResourceClassificationType = 'RESOURCE_CLASSIFICATION_HD_STATIONERY';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
	'HD_MONASTERY_CULTURE_FAITH_' || ResourceType, 'Amount', '1,1'
from HD_Resource_Classification where ResourceClassificationType = 'RESOURCE_CLASSIFICATION_HD_STATIONERY';

-- 建造数量限制
insert or ignore into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) select distinct
	'HD_CITY_ALLOW_EXTRA_MONASTERY_' || Tier, 	'MODIFIER_SINGLE_CITY_ADJUST_PROPERTY', 		'CITY_HAS_DISTRICT_HOLY_SITE_TIER_' || Tier || '_BUILDING_REQUIREMENTS'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select distinct
	'HD_CITY_ALLOW_EXTRA_MONASTERY_' || Tier, 'Key', 'HD_CITY_ALLOW_EXTRA_IMPROVEMENT_MONASTERY'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or ignore into ModifierArguments (ModifierId, Name, Value) select distinct
	'HD_CITY_ALLOW_EXTRA_MONASTERY_' || Tier, 'Amount', 1
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or ignore into DistrictModifiers (DistrictType, ModifierId) select distinct
	DistrictType, 'HD_CITY_ALLOW_EXTRA_MONASTERY_' || Tier
from Districts, HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE' and
	(DistrictType = 'DISTRICT_HOLY_SITE' or DistrictType in (select CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_HOLY_SITE'));

-- =====================================================================================================================================
-- 城邦
-- =====================================================================================================================================
-- Modifiers in this table are attached to suzerain
create temporary table if not exists TraitAttachedModifiers (
	TraitType text not null,
	ModifierId text not null,
	primary key (TraitType, ModifierId)
);

-- =====================================================================================================================================
-- 阿尔玛 MINOR_CIV_ARMAGH_TRAIT
-- =====================================================================================================================================
delete from TraitModifiers where TraitType = 'MINOR_CIV_ARMAGH_TRAIT';

insert or replace into TraitAttachedModifiers (TraitType, ModifierId) values
	('MINOR_CIV_ARMAGH_TRAIT', 'HD_ARMAGH_GPP'),
	('MINOR_CIV_ARMAGH_TRAIT', 'HD_ARMAGH_PLAYER_PROPERTY');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
	('HD_ARMAGH_GPP',							'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',	'DISTRICT_IS_HOLY_SITE'),
	('HD_ARMAGH_PLAYER_PROPERTY',	'MODIFIER_PLAYER_ADJUST_PROPERTY',											'PLAYER_HAS_FOUNDED_A_RELIGION');

insert or replace into ModifierArguments (ModifierId, Name, Value) values
	('HD_ARMAGH_GPP', 						'GreatPersonClassType',	'GREAT_PERSON_CLASS_PROPHET'),
	('HD_ARMAGH_GPP', 						'Amount',								2),
	('HD_ARMAGH_PLAYER_PROPERTY', 'Key',									'HD_ARMAGH_SUZERAIN_FOUNDED_A_RELIGION'),
	('HD_ARMAGH_PLAYER_PROPERTY', 'Amount',								1);

insert or replace into GlobalParameters (Name, Value) values
  ('HD_ARMAGH_PROPHET_TO_WRITER_PERCENTAGE', 100);

-- =====================================================================================================================================
-- 奥克兰
-- =====================================================================================================================================
update Modifiers set SubjectRequirementSetId = 'PLOT_HAS_SHALLOW_WATER_AND_STEAM_POWER_REQUIREMENTS' where ModifierId = 'MINOR_CIV_AUCKLAND_SHALLOW_WATER_PRODUCTION_BONUS_INDUSTRIAL';

-- Muscat
delete from TraitModifiers where TraitType = 'MINOR_CIV_MUSCAT_TRAIT';
insert or replace into TraitAttachedModifiers
	(TraitType,                 ModifierId)
values
	('MINOR_CIV_MUSCAT_TRAIT',  'MINOR_CIV_MUSCAT_COMMERCIAL'),
	('MINOR_CIV_MUSCAT_TRAIT',  'MINOR_CIV_MUSCAT_HARBOR');
insert or replace into Modifiers
	(ModifierId,                            	ModifierType,										SubjectRequirementSetId)
values
	('MINOR_CIV_MUSCAT_COMMERCIAL',      		'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',			'CITY_ON_HOME_CONTINENT_HAS_COMMERCIAL_HUB'),
	('MINOR_CIV_MUSCAT_HARBOR',    				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',			'CITY_ON_HOME_CONTINENT_HAS_HARBOR'),
	('MINOR_CIV_MUSCAT_COMMERCIAL_MODIFIER',    'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',	'CITY_IS_CAPITAL_OR_ON_FOREIGN_CONTINENT'),
	('MINOR_CIV_MUSCAT_HARBOR_MODIFIER',    	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',	'CITY_IS_CAPITAL_OR_ON_FOREIGN_CONTINENT');
insert or replace into ModifierArguments
	(ModifierId,                            	Name,				Value)
values
('MINOR_CIV_MUSCAT_COMMERCIAL',	    		'ModifierId',		'MINOR_CIV_MUSCAT_COMMERCIAL_MODIFIER'),
('MINOR_CIV_MUSCAT_HARBOR',	    			'ModifierId',	    'MINOR_CIV_MUSCAT_HARBOR_MODIFIER'),
('MINOR_CIV_MUSCAT_COMMERCIAL_MODIFIER',	'YieldType',		'YIELD_GOLD'),
('MINOR_CIV_MUSCAT_COMMERCIAL_MODIFIER',	'Amount',			3),
('MINOR_CIV_MUSCAT_HARBOR_MODIFIER',		'YieldType',		'YIELD_PRODUCTION'),
('MINOR_CIV_MUSCAT_HARBOR_MODIFIER',		'Amount',			1);

-- Mitla
update ModifierArguments set value = 10 where ModifierId = 'MINOR_CIV_PALENQUE_CAMPUS_GROWTH_BONUS' and Name = 'Amount';
insert or replace into TraitAttachedModifiers
	(TraitType,						ModifierId)
values
	('MINOR_CIV_PALENQUE_TRAIT',	'MINOR_CIV_PALENQUE_CAMPUS_FOOD');
insert or replace into Modifiers
	(ModifierId,                            	ModifierType,										SubjectRequirementSetId)
values
	('MINOR_CIV_PALENQUE_CAMPUS_FOOD',      	'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',	'DISTRICT_IS_DISTRICT_CAMPUS_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,                            	Name,				Value)
values
	('MINOR_CIV_PALENQUE_CAMPUS_FOOD',	    	'YieldType',		'YIELD_FOOD'),
	('MINOR_CIV_PALENQUE_CAMPUS_FOOD',	    	'Amount',			1);
insert or replace into TraitAttachedModifiers
	(TraitType,						ModifierId)
select
	'MINOR_CIV_PALENQUE_TRAIT',		'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS';
insert or replace into Modifiers
	(ModifierId,                            			ModifierType)
select
	'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS';
insert or replace into ModifierArguments
	(ModifierId,                            			Name,				Value)
select
	'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD',	'BuildingType',		BuildingType
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS' union all select
	'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD',	'YieldType',		'YIELD_FOOD'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS' union all select
	'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD',	'Amount',			1
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS';

-- Attach modifiers in TraitAttachedModifiers to suzerain
insert or ignore into TraitModifiers
	(TraitType, ModifierId)
select
	TraitType,  ModifierId || '_ATTACH'
from TraitAttachedModifiers;
insert or ignore into Modifiers
	(ModifierId,                ModifierType,                               SubjectRequirementSetId)
select
	ModifierId || '_ATTACH',    'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',     'PLAYER_IS_SUZERAIN'
from TraitAttachedModifiers;
insert or ignore into ModifierArguments
	(ModifierId,                Name,           Value)
select
	ModifierId || '_ATTACH',    'ModifierId',   ModifierId
from TraitAttachedModifiers;
drop table TraitAttachedModifiers;