-------------------------------------
--            Vietnam DLC          --
-------------------------------------

insert or replace into District_GreatPersonPoints
    (DistrictType,      GreatPersonClassType,           PointsPerTurn)
values
    ('DISTRICT_THANH',  'GREAT_PERSON_CLASS_GENERAL',   1);

update Districts set Appeal = 0, RequiresPopulation = 1 where DistrictType = 'DISTRICT_THANH';
update ModifierArguments set Value = 'YIELD_PRODUCTION' where ModifierId = 'THANH_TOURISM_CULTURE' and Name = 'YieldType';
insert or replace into DistrictModifiers
	(DistrictType,			ModifierId)
values
	('DISTRICT_THANH',		'THANH_ENCAMPMENT_CULTURE'),
	('DISTRICT_THANH',		'THANH_ENCAMPMENT_EXTRA_DISTRICT');
insert or replace into Modifiers
	(ModifierId,					    ModifierType,															SubjectRequirementSetId)
values
	('THANH_ENCAMPMENT_CULTURE',	    'MODIFIER_SINGLE_CITY_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',	'DISTRICT_IS_DISTRICT_ENCAMPMENT_REQUIREMENTS'),
	('THANH_ENCAMPMENT_EXTRA_DISTRICT',	'MODIFIER_SINGLE_CITY_EXTRA_DISTRICT',	                                null);
insert or replace into ModifierArguments
	(ModifierId,					    Name,					Value)
values
	('THANH_ENCAMPMENT_CULTURE',	    'YieldTypeToMirror',	'YIELD_PRODUCTION'),
	('THANH_ENCAMPMENT_CULTURE',	    'YieldTypeToGrant',		'YIELD_CULTURE'),
	('THANH_ENCAMPMENT_EXTRA_DISTRICT',	'Amount',		        1);
-------------------------------------------------------------------------------------------------------------------------------
-- Vietnan Civ

-- Vietnam can build districts in all features and do not remove on forest jungle and marsh
-- rainforest +2 food forest +2 production marsh +2 science
-- district itself included

delete from TraitModifiers where ModifierId = 'TRAIT_DISTRICTS_FOREST_ONLY';
delete from TraitModifiers where ModifierId = 'TRAIT_DISTRICTS_MARSH_ONLY';
delete from TraitModifiers where ModifierId = 'TRAIT_DISTRICTS_JUNGLE_ONLY';

insert or replace into TraitModifiers (TraitType,   ModifierId) 
    select 'TRAIT_CIVILIZATION_VIETNAM', 'TRAIT_JUNGLE_VALID_' || DistrictType from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into TraitModifiers (TraitType,   ModifierId) 
    select 'TRAIT_CIVILIZATION_VIETNAM', 'TRAIT_MARSH_VALID_' || DistrictType from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into TraitModifiers (TraitType,   ModifierId) 
    select 'TRAIT_CIVILIZATION_VIETNAM', 'TRAIT_FOREST_VALID_' || DistrictType from Districts where DistrictType != 'DISTRICT_CITY_CENTER';

-- insert or replace into Modifiers    (ModifierId, ModifierType)
--     select 'TRAIT_JUNGLE_VALID_' || DistrictType, 'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS' 
--     from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into Modifiers    (ModifierId, ModifierType)
    select 'TRAIT_MARSH_VALID_' || DistrictType, 'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS' 
    from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into Modifiers    (ModifierId, ModifierType)
    select 'TRAIT_FOREST_VALID_' || DistrictType, 'MODIFIER_PLAYER_CITIES_ADJUST_VALID_FEATURES_DISTRICTS' 
    from Districts where DistrictType != 'DISTRICT_CITY_CENTER';    

-- insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
--     select 'TRAIT_JUNGLE_VALID_' || DistrictType, 'DistrictType', DistrictType
--     from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
    select 'TRAIT_MARSH_VALID_' || DistrictType, 'DistrictType', DistrictType
    from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
    select 'TRAIT_FOREST_VALID_' || DistrictType, 'DistrictType', DistrictType
    from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
-- insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
--     select 'TRAIT_JUNGLE_VALID_' || DistrictType, 'FeatureType', 'FEATURE_JUNGLE'
--     from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
    select 'TRAIT_MARSH_VALID_' || DistrictType, 'FeatureType', 'FEATURE_MARSH'
    from Districts where DistrictType != 'DISTRICT_CITY_CENTER';
insert or replace into ModifierArguments    (ModifierId,    Name,        Value) 
    select 'TRAIT_FOREST_VALID_' || DistrictType, 'FeatureType', 'FEATURE_FOREST'
    from Districts where DistrictType != 'DISTRICT_CITY_CENTER';

update ModifierArguments set Value = 'YIELD_PRODUCTION' where ModifierId = 'TRAIT_FOREST_BUILDINGS_CULTURE' and Name = 'YieldType';
update ModifierArguments set Value = 'YIELD_FOOD' where ModifierId = 'TRAIT_JUNGLE_BUILDINGS_SCIENCE' and Name = 'YieldType';
update ModifierArguments set Value = 'YIELD_SCIENCE' where ModifierId = 'TRAIT_MARSH_BUILDINGS_PRODUCTION' and Name = 'YieldType';
update ModifierArguments set Value = 2 where ModifierId = 'TRAIT_FOREST_BUILDINGS_CULTURE' and Name = 'Amount';
update ModifierArguments set Value = 2 where ModifierId = 'TRAIT_JUNGLE_BUILDINGS_SCIENCE' and Name = 'Amount';
update ModifierArguments set Value = 2 where ModifierId = 'TRAIT_MARSH_BUILDINGS_PRODUCTION' and Name = 'Amount';

insert or replace into TraitModifiers 
    (TraitType, ModifierId)
values
    ('TRAIT_CIVILIZATION_VIETNAM','TRAIT_JUNGLE_FOOD'),
    ('TRAIT_CIVILIZATION_VIETNAM','TRAIT_WOODS_PRODUCTION'),
    ('TRAIT_CIVILIZATION_VIETNAM','TRAIT_MARSH_SCIENCE');

insert or replace into Modifiers
    (ModifierId,        ModifierType,       SubjectRequirementSetId)
values
    ('TRAIT_JUNGLE_FOOD',       'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',    'ZOO_RAINFOREST_REQUIREMENTS'),
    ('TRAIT_WOODS_PRODUCTION',  'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',    'PLOT_HAS_FOREST_REQUIREMENT'),
    ('TRAIT_MARSH_SCIENCE',     'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',    'PLOT_HAS_MARSH_REQUIREMENTS');

insert or replace into ModifierArguments    
    (ModifierId,                    Name,       Value) 
values
    ('TRAIT_JUNGLE_FOOD',           'Amount',       2),
    ('TRAIT_JUNGLE_FOOD',           'YieldType',    'YIELD_FOOD'),
    ('TRAIT_WOODS_PRODUCTION',      'Amount',       2),
    ('TRAIT_WOODS_PRODUCTION',      'YieldType',    'YIELD_PRODUCTION'),
    ('TRAIT_MARSH_SCIENCE',         'Amount',       2),
    ('TRAIT_MARSH_SCIENCE',         'YieldType',    'YIELD_SCIENCE');

------------------------------------------------------------------------------------------------------------------
-- Kublai
delete from TraitModifiers where
    ModifierId in ('TRAIT_TRADING_POST_CIVIC_BOOST', 'TRAIT_TRADING_POST_TECH_BOOST', 'TRAIT_ECONOMIC_GOVERNMENT_SLOT')
and TraitType = 'TRAIT_LEADER_KUBLAI';

-- insert or replace into TraitModifiers
-- 	(TraitType,					ModifierId)
-- values
--     ('TRAIT_LEADER_KUBLAI',     'HD_KUBLAI_ECONOMIC_GOVERNMENT_SLOT_1'),
--     ('TRAIT_LEADER_KUBLAI',     'HD_KUBLAI_ECONOMIC_GOVERNMENT_SLOT_2');

-- insert or replace into Modifiers
-- 	(ModifierId,								ModifierType,													SubjectRequirementSetId)
-- values
--     ('HD_KUBLAI_ECONOMIC_GOVERNMENT_SLOT_1',    'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER',     'PLAYER_HAS_DISTRICT_COMMERCIAL_HUB_REQUIREMENTS'),
--     ('HD_KUBLAI_ECONOMIC_GOVERNMENT_SLOT_2',    'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER',     'PLAYER_HAS_DISTRICT_CANAL_REQUIREMENTS');

-- insert or replace into ModifierArguments
-- 	(ModifierId,								Name,			        Value)
-- values
--     ('HD_KUBLAI_ECONOMIC_GOVERNMENT_SLOT_1',    'GovernmentSlotType',   'SLOT_ECONOMIC'),
--     ('HD_KUBLAI_ECONOMIC_GOVERNMENT_SLOT_2',    'GovernmentSlotType',   'SLOT_ECONOMIC');

--越南种树前移
update ModifierArguments set Value = 'CIVIC_MYSTICISM' where ModifierId = 'TRAIT_PLANT_MEDIEVAL_WOODS' and Name = 'CivicType';
------------------------------------------------------------------------------------------------------------------
update Districts set Cost = 60, Housing = 1 where DistrictType = 'DISTRICT_PRESERVE';
with District_Adjacencies_Pre
	(DistrictType,						YieldChangeId)
as (values
	('DISTRICT_PRESERVE',				'Preserve_Self_Food'))
insert or replace into District_Adjacencies
	(DistrictType,	YieldChangeId)
select
	DistrictType,	YieldChangeId
from District_Adjacencies_Pre where DistrictType in (select DistrictType from Districts);

insert or replace into Adjacency_YieldChanges
	(ID,								Description,					YieldType,			YieldChange,	Self)
values
	('Preserve_Self_Food',				'LOC_DISTRICT_SELF_FOOD',		'YIELD_FOOD',		1,				1);

--文美保护区版本改动
insert or replace into TraitModifiers
	(TraitType,								ModifierId)
select
	'TRAIT_LEADER_ANTIQUES_AND_PARKS',		'TRAIT_LEADER_ANTIQUES_AND_PARKS_DISTRICT_PRESERVE'
where exists (select TraitType from Traits where TraitType = 'TRAIT_LEADER_ANTIQUES_AND_PARKS') union
select
	'TRAIT_LEADER_ANTIQUES_AND_PARKS',		'TRAIT_LEADER_ANTIQUES_AND_PARKS_' || BuildingType
from Buildings where PrereqDistrict = 'DISTRICT_PRESERVE' and exists (select TraitType from Traits where TraitType = 'TRAIT_LEADER_ANTIQUES_AND_PARKS');

insert or replace into Modifiers
	(ModifierId,														ModifierType,									SubjectRequirementSetId)
values
	('TRAIT_LEADER_ANTIQUES_AND_PARKS_DISTRICT_PRESERVE',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',		'CITY_HAS_DISTRICT_PRESERVE_REQUIREMENTS'),
	('TRAIT_LEADER_ANTIQUES_AND_PARKS_DISTRICT_PRESERVE_MODIFIER',		'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',	'PLOT_BREATHTAKING_APPEAL');

insert or replace into ModifierArguments
	(ModifierId,														Name,						Value)
values
	('TRAIT_LEADER_ANTIQUES_AND_PARKS_DISTRICT_PRESERVE',				'ModifierId',				'TRAIT_LEADER_ANTIQUES_AND_PARKS_DISTRICT_PRESERVE_MODIFIER'),
	('TRAIT_LEADER_ANTIQUES_AND_PARKS_DISTRICT_PRESERVE_MODIFIER',		'YieldType',				'YIELD_CULTURE,YIELD_SCIENCE'),
	('TRAIT_LEADER_ANTIQUES_AND_PARKS_DISTRICT_PRESERVE_MODIFIER',		'Amount',					'1,1');

insert or replace into Modifiers
	(ModifierId,														ModifierType,									SubjectRequirementSetId)
select
	'TRAIT_LEADER_ANTIQUES_AND_PARKS_' || BuildingType,					'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',		'CITY_HAS_' || BuildingType || '_REQUIREMENTS'
from Buildings where PrereqDistrict = 'DISTRICT_PRESERVE' union
select
	'TRAIT_LEADER_ANTIQUES_AND_PARKS_' || BuildingType || '_MODIFIER',	'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',	'PLOT_BREATHTAKING_APPEAL'
from Buildings where PrereqDistrict = 'DISTRICT_PRESERVE';

insert or replace into ModifierArguments
	(ModifierId,														Name,						Value)
select
	'TRAIT_LEADER_ANTIQUES_AND_PARKS_' || BuildingType,					'ModifierId',				'TRAIT_LEADER_ANTIQUES_AND_PARKS_' || BuildingType || '_MODIFIER'
from Buildings where PrereqDistrict = 'DISTRICT_PRESERVE' union
select
	'TRAIT_LEADER_ANTIQUES_AND_PARKS_' || BuildingType || '_MODIFIER',	'YieldType',				'YIELD_CULTURE,YIELD_SCIENCE'
from Buildings where PrereqDistrict = 'DISTRICT_PRESERVE' union
select
	'TRAIT_LEADER_ANTIQUES_AND_PARKS_' || BuildingType || '_MODIFIER',	'Amount',					'1,1'
from Buildings where PrereqDistrict = 'DISTRICT_PRESERVE';

-- 政策
delete from CivicModifiers where CivicType = 'CIVIC_ENVIRONMENTALISM' and ModifierId = 'ENVIRONMENTALISM_BOOST_ALL_TOURISM';

insert or replace into Types
	(Type,						            Kind)
values
	('POLICY_HD_ECOLOGICAL_CIV',	        'KIND_POLICY'),
	('POLICY_HD_HARMONIOUS_COEXISTENCE',	'KIND_POLICY');

insert or replace into Policies
	(PolicyType,				            Name,								            Description,								        PrereqCivic,				GovernmentSlotType)
values
	('POLICY_HD_ECOLOGICAL_CIV',	        'LOC_POLICY_HD_ECOLOGICAL_CIV_NAME',	        'LOC_POLICY_HD_ECOLOGICAL_CIV_DESCRIPTION',	        'CIVIC_ENVIRONMENTALISM',   'SLOT_ECONOMIC'),
	('POLICY_HD_HARMONIOUS_COEXISTENCE',	'LOC_POLICY_HD_HARMONIOUS_COEXISTENCE_NAME',	'LOC_POLICY_HD_HARMONIOUS_COEXISTENCE_DESCRIPTION',	'CIVIC_ENVIRONMENTALISM',   'SLOT_ECONOMIC');

insert or replace into PolicyModifiers
	(PolicyType,				            ModifierId)
values
    ('POLICY_HD_ECOLOGICAL_CIV',            'HD_ECOLOGICAL_CIV_TOURISM_1'),
    ('POLICY_HD_ECOLOGICAL_CIV',            'HD_ECOLOGICAL_CIV_TOURISM_2'),
    ('POLICY_HD_ECOLOGICAL_CIV',            'HD_ECOLOGICAL_CIV_TOURISM_3'),
    ('POLICY_HD_ECOLOGICAL_CIV',            'HD_ECOLOGICAL_CIV_TOURISM_4'),
    ('POLICY_HD_HARMONIOUS_COEXISTENCE',    'HD_HARMONIOUS_COEXISTENCE_ATTACH');

insert or replace into Modifiers
	(ModifierId,						    ModifierType,							                OwnerRequirementSetId,				                    SubjectRequirementSetId)
values
	('HD_ECOLOGICAL_CIV_TOURISM_1',		    'MODIFIER_PLAYER_ADJUST_TOURISM',	                    'PLAYER_HAS_BUILDING_HD_LANDFORM_EPO_REQUIREMENTS',     NULL),
    ('HD_ECOLOGICAL_CIV_TOURISM_2',		    'MODIFIER_PLAYER_ADJUST_TOURISM',	                    'PLAYER_HAS_BUILDING_HD_RESOURCE_EPO_REQUIREMENTS',     NULL),
    ('HD_ECOLOGICAL_CIV_TOURISM_3',		    'MODIFIER_PLAYER_ADJUST_TOURISM',	                    'PLAYER_HAS_BUILDING_HD_SPECIES_EPO_REQUIREMENTS',      NULL),
    ('HD_ECOLOGICAL_CIV_TOURISM_4',		    'MODIFIER_PLAYER_ADJUST_TOURISM',	                    'PLAYER_HAS_BUILDING_HD_SCENIC_EPO_REQUIREMENTS',       NULL),
	('HD_HARMONIOUS_COEXISTENCE_ATTACH',	'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',               NULL,                                                   'HD_CITY_HAS_ANY_PRESERVE_AGENCY'),
    ('HD_HARMONIOUS_COEXISTENCE_MODIFER',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',    NULL,                                                   NULL);

insert or replace into ModifierArguments
	(ModifierId,						      Name,			Value)
values
    ('HD_ECOLOGICAL_CIV_TOURISM_1',           'Amount',       5),
    ('HD_ECOLOGICAL_CIV_TOURISM_2',           'Amount',       5),
    ('HD_ECOLOGICAL_CIV_TOURISM_3',           'Amount',       5),
    ('HD_ECOLOGICAL_CIV_TOURISM_4',           'Amount',       5),
    ('HD_HARMONIOUS_COEXISTENCE_ATTACH',      'ModifierId',   'HD_HARMONIOUS_COEXISTENCE_MODIFER'),
    ('HD_HARMONIOUS_COEXISTENCE_MODIFER',     'YieldType',    'YIELD_PRODUCTION, YIELD_FOOD, YIELD_SCIENCE, YIELD_CULTURE, YIELD_GOLD, YIELD_FAITH'),
    ('HD_HARMONIOUS_COEXISTENCE_MODIFER',     'Amount',       '5,5,5,5,5,5');