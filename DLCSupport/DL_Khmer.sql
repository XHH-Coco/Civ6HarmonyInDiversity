-------------------------------------
--            Khmer DLC            --
-------------------------------------
--delete from CivilizationTraits where TraitType = 'TRAIT_CIVILIZATION_BUILDING_PRASAT';
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_BUILDING_PRASAT';

insert or replace into Building_CitizenYieldChanges
    (BuildingType,                          YieldType,          YieldChange)
values
    ('BUILDING_PRASAT',                     'YIELD_FAITH',      1); --ub (高棉)

insert or replace into BuildingModifiers
    (BuildingType,                  ModifierId)
values
    ('BUILDING_PRASAT',             'TEMPLE_SETTLER_PURCHASE');
    -- ('BUILDING_PRASAT',             'TEMPLE_FAITH_PERCENTAGE_BOOST');

--CIVILIZATION_INDONESIA
update ModifierArguments set Value = 1 where ModifierId = 'TRAIT_NUSANTARA_COAST_HOLY_SITE' and Name = 'TilesRequired';
update ModifierArguments set Value = 1 where ModifierId = 'TRAIT_NUSANTARA_COAST_CAMPUS' and Name = 'TilesRequired';
update ModifierArguments set Value = 1 where ModifierId = 'TRAIT_NUSANTARA_COAST_INDUSTRIAL_ZONE' and Name = 'TilesRequired';
update ModifierArguments set Value = 1 where ModifierId = 'TRAIT_NUSANTARA_COAST_THEATER' and Name = 'TilesRequired';

-- 新增与甘榜屋相关的UA能力
delete from TraitModifiers where TraitType = 'TRAIT_CIVILIZATION_INDONESIA_NUSANTARA' and ModifierId = 'TRAIT_NUSANTARA_COAST_ENTERTAINMENT';
insert or replace into TraitModifiers
    (TraitType,                                 ModifierId)
values
    ('TRAIT_CIVILIZATION_INDONESIA_NUSANTARA',  'TRAIT_NUSANTARA_KAMPUNG_AMENITY'),
    ('TRAIT_CIVILIZATION_INDONESIA_NUSANTARA',  'TRAIT_NUSANTARA_KAMPUNG_HARBOR_PRODUCTION_BOOST'),
    ('TRAIT_CIVILIZATION_INDONESIA_NUSANTARA',  'TRAIT_NUSANTARA_KAMPUNG_WATER_PARK_PRODUCTION_BOOST');
insert or replace into Modifiers
	(ModifierId,				                            ModifierType,								            SubjectRequirementSetId)
values
    ('TRAIT_NUSANTARA_KAMPUNG_AMENITY',	                    'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',	        'REQUIREMENTS_PLOT_ADJACENT_KAMPUNG'),
    ('TRAIT_NUSANTARA_KAMPUNG_HARBOR_PRODUCTION_BOOST',	    'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION',	'REQUIREMENTS_PLOT_ADJACENT_KAMPUNG'),
    ('TRAIT_NUSANTARA_KAMPUNG_WATER_PARK_PRODUCTION_BOOST',	'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION',	'REQUIREMENTS_PLOT_ADJACENT_KAMPUNG');
insert or replace into ModifierArguments
	(ModifierId,				                            Name,			Value)
values
	('TRAIT_NUSANTARA_KAMPUNG_AMENITY',	                    'Amount',		2),
    ('TRAIT_NUSANTARA_KAMPUNG_HARBOR_PRODUCTION_BOOST',	    'DistrictType', 'DISTRICT_HARBOR'),
    ('TRAIT_NUSANTARA_KAMPUNG_HARBOR_PRODUCTION_BOOST',	    'Amount',		30),
    ('TRAIT_NUSANTARA_KAMPUNG_WATER_PARK_PRODUCTION_BOOST',	'DistrictType', 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX'),
    ('TRAIT_NUSANTARA_KAMPUNG_WATER_PARK_PRODUCTION_BOOST',	'Amount',		30);

insert or ignore into RequirementSets
	(RequirementSetId,						RequirementSetType)
values
	('REQUIREMENTS_PLOT_ADJACENT_KAMPUNG',	'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
values
	('REQUIREMENTS_PLOT_ADJACENT_KAMPUNG',	'REQUIRES_PLOT_ADJACENT_TO_IMPROVEMENT_KAMPUNG');

-- 甘榜屋
update Improvements set PrereqTech = 'TECH_SHIPBUILDING', Housing = 1, TilesRequired = 1, SameAdjacentValid = 0, AdjacentSeaResource = 0 where ImprovementType = 'IMPROVEMENT_KAMPUNG';

-- 基础产出
delete from Improvement_YieldChanges where ImprovementType = 'IMPROVEMENT_KAMPUNG';
delete from Improvement_BonusYieldChanges where ImprovementType = 'IMPROVEMENT_KAMPUNG';
insert or replace into Improvement_YieldChanges
	(ImprovementType,		YieldType,				YieldChange)
values
    ('IMPROVEMENT_KAMPUNG', 'YIELD_FOOD',			1),
    ('IMPROVEMENT_KAMPUNG', 'YIELD_PRODUCTION',		1);

-- 特效
update RequirementSetRequirements set RequirementId = 'HD_REQUIRES_PLAYER_HAS_TECH_STEAM_POWER'
    where RequirementSetId = 'PLAYER_HAS_KAMPUNG_TECHNOLOGY_REQUIREMENTS' and RequirementId = 'REQUIRES_PLAYER_HAS_MASS_PRODUCTION_TECHNOLOGY';
insert or replace into ImprovementModifiers
	(ImprovementType,		    ModifierId)
values
	('IMPROVEMENT_KAMPUNG',	    'HD_KAMPUNG_HOUSING_2'),
    ('IMPROVEMENT_KAMPUNG',	    'HD_KAMPUNG_ADJACENT_PLOT_BONUS1'),
    ('IMPROVEMENT_KAMPUNG',	    'HD_KAMPUNG_ADJACENT_PLOT_BONUS2');
insert or replace into Modifiers
	(ModifierId,				        ModifierType,								        SubjectRequirementSetId)
values
	('HD_KAMPUNG_HOUSING_2',	        'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING',	'PLAYER_HAS_CIVIC_URBANIZATION_REQUIREMENTS'),
    ('HD_KAMPUNG_ADJACENT_PLOT_BONUS1',	'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',	            'HD_ADJACENT_PLOT_WATER'),
    ('HD_KAMPUNG_ADJACENT_PLOT_BONUS2',	'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',	            'HD_ADJACENT_PLOT_WATER');
update Modifiers set OwnerRequirementSetId = 'PLAYER_HAS_TECH_OCEANOGRAPHY_HD_REQUIREMENTS' where ModifierId = 'HD_KAMPUNG_ADJACENT_PLOT_BONUS2';
insert or replace into ModifierArguments
	(ModifierId,				        Name,			Value)
values
	('HD_KAMPUNG_HOUSING_2',	        'Amount',		1),
    ('HD_KAMPUNG_ADJACENT_PLOT_BONUS1',	'YieldType',	'YIELD_FOOD,YIELD_PRODUCTION'),
    ('HD_KAMPUNG_ADJACENT_PLOT_BONUS1',	'Amount',		'1,1'),
    ('HD_KAMPUNG_ADJACENT_PLOT_BONUS2',	'YieldType',	'YIELD_FOOD,YIELD_PRODUCTION'),
    ('HD_KAMPUNG_ADJACENT_PLOT_BONUS2',	'Amount',		'1,1');

-- 相邻区域给本城海域加产
    -- Attach
insert or replace into ImprovementModifiers (ImprovementType, ModifierId)
    select 'IMPROVEMENT_KAMPUNG', 'HD_KAMPUNG_' || DistrictType || '_ATTACH'
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into ImprovementModifiers (ImprovementType, ModifierId)
    select 'IMPROVEMENT_KAMPUNG', 'HD_KAMPUNG_' || DistrictType || '_ATTACH_LATE'
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit)
    select 'HD_KAMPUNG_' || DistrictType || '_ATTACH',
    'MODIFIER_CITY_OWNER_ATTACH_MODIFIER',
    'PLOT_ADJACENT_TO_' || DistrictType || '_REQUIREMENTS',
    Null,
    1
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId, SubjectStackLimit)
    select 'HD_KAMPUNG_' || DistrictType || '_ATTACH_LATE',
    'MODIFIER_CITY_OWNER_ATTACH_MODIFIER',
    'PLOT_ADJACENT_TO_' || DistrictType || '_REQUIREMENTS',
    'PLAYER_HAS_CIVIC_URBANIZATION_REQUIREMENTS',
    1
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
    select 'HD_KAMPUNG_' || DistrictType || '_ATTACH', 'ModifierId', 'HD_KAMPUNG_' || DistrictType
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
    select 'HD_KAMPUNG_' || DistrictType || '_ATTACH_LATE', 'ModifierId', 'HD_KAMPUNG_' || DistrictType
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

    -- Bonus
insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    select 'HD_KAMPUNG_' || DistrictType, 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'PLOT_HAS_COAST_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
    select 'HD_KAMPUNG_' || DistrictType, 'YieldType', YieldType
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

insert or replace into ModifierArguments (ModifierId, Name, Value)
    select 'HD_KAMPUNG_' || DistrictType, 'Amount', Amount
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1;

-- 建造条件
insert or replace into Improvement_ValidFeatures
	(ImprovementType,			FeatureType) 
values 
	('IMPROVEMENT_KAMPUNG',		'FEATURE_REEF');
insert or replace into Improvement_ValidFeatures
	(ImprovementType, FeatureType)
select
	'IMPROVEMENT_KAMPUNG',		'FEATURE_SUK_KELP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_SUK_KELP');

-- 旅游业绩
-- update Improvement_Tourism set TourismSource = 'TOURISMSOURCE_PRODUCTION' where ImprovementType = 'IMPROVEMENT_KAMPUNG';
delete from Improvement_Tourism where ImprovementType = 'IMPROVEMENT_KAMPUNG';

-- 相邻加成
delete from Improvement_Adjacencies where ImprovementType = 'IMPROVEMENT_KAMPUNG';
-- update Adjacency_YieldChanges set YieldType = 'YIELD_PRODUCTION' where ID = 'Kampung_FoodFishingBoats';
-- insert or replace into Improvement_Adjacencies
--     (ImprovementType,               YieldChangeId)
-- values
--     ('IMPROVEMENT_KAMPUNG',         'Kampung_ProductionFishingBoats2'),
--     ('IMPROVEMENT_KAMPUNG',         'Kampung_ProductionFishingBoats3'),
--     ('IMPROVEMENT_KAMPUNG',         'Kampung_FoodFishery1'),
--     ('IMPROVEMENT_KAMPUNG',         'Kampung_FoodFishery2'),
--     ('IMPROVEMENT_KAMPUNG',         'Kampung_FoodFishery3');

-- insert or replace into Adjacency_YieldChanges
-- 	(ID,				                Description,	YieldType,			YieldChange,	TilesRequired,  AdjacentImprovement,            PrereqTech,             PrereqCivic)
-- values
--     ('Kampung_ProductionFishingBoats2',	'Placeholder', 'YIELD_PRODUCTION',  1,				1,              'IMPROVEMENT_FISHING_BOATS',    'TECH_COMPASS_HD',      null),
-- 	('Kampung_ProductionFishingBoats3',	'Placeholder', 'YIELD_PRODUCTION',	1,				1,              'IMPROVEMENT_FISHING_BOATS',    null,                   'CIVIC_EVOLUTION_THEORY_HD'),
-- 	('Kampung_FoodFishery1',	        'Placeholder', 'YIELD_FOOD',	    1,				1,              'IMPROVEMENT_FISHERY',          null,                   null),
-- 	('Kampung_FoodFishery2',	        'Placeholder', 'YIELD_FOOD',	    1,				1,              'IMPROVEMENT_FISHERY',          null,                   'CIVIC_NAVAL_TRADITION'),
-- 	('Kampung_FoodFishery3',	        'Placeholder', 'YIELD_FOOD',	    1,				1,              'IMPROVEMENT_FISHERY',          'TECH_CARTOGRAPHY',     null);