-------------------------------------
--     Wild Testing Adjustments    --
-------------------------------------

-------------------------------------
--     狂野模式 版本V0.1    --
-------------------------------------

-- -------------------------------------
-- --耶稣会√
-- update ModifierArguments set Value = 0.2 where ModifierId = 'JESUIT_EDUCATION_POPULATION_SCIENCE_MODIFIER' and Name = 'Amount';
-- update ModifierArguments set Value = 0.3 where ModifierId = 'JESUIT_EDUCATION_SHRINE_POPULATION_SCIENCE_MODIFIER' and Name = 'Amount';
-- update ModifierArguments set Value = 0.5 where ModifierId = 'JESUIT_EDUCATION_TEMPLE_POPULATION_SCIENCE_MODIFIER' and Name = 'Amount';

-- -------------------------------------
-- --托钵修会
-- update ModifierArguments set Value = 20 where ModifierId = 'MESSIAH_SHRINE_PURCHASE_DISCOUNT_MODIFIER' and Name = 'Amount';
-- update ModifierArguments set Value = 20 where ModifierId = 'MESSIAH_TEMPLE_PURCHASE_DISCOUNT_MODIFIER' and Name = 'Amount';
-- update ModifierArguments set Value = 20 where ModifierId = 'MESSIAH_SHRINE_FAITH_PERCENTAGE_BOOST_MODIFIER' and Name = 'Amount';
-- delete from BeliefModifiers where ModifierId = 'MESSIAH_HOLYSITE_BUILDING_PRODUCTION';
-- update ModifierArguments set Value = 8 where ModifierId = 'MESSIAH_SHRINE_FAITH_PERCENTAGE_BOOST_MODIFIER' and Name = 'Amount';
-- update ModifierArguments set Value = 8 where ModifierId = 'MESSIAH_TEMPLE_FAITH_PERCENTAGE_BOOST_MODIFIER' and Name = 'Amount';
-- update ModifierArguments set Value = 8 where ModifierId = 'MESSIAH_RELIGIOUS_FAITH_PERCENTAGE_BOOST_MODIFIER' and Name = 'Amount';
-- insert or replace into ModifierArguments	(ModifierId,	Name,	Value)
-- select 'MESSIAH_PURCHASE_DISCOUNT_' || BuildingType || '_MODIFIER',	'Amount',	20 from Buildings 
-- where PrereqDistrict = 'DISTRICT_HOLY_SITE' and PurchaseYield = 'YIELD_FAITH';

-------------------------------------
--禅修
update ModifierArguments set Value = 1 where ModifierId = 'ZEN_MEDITATION_CITY_CENTER_RIVER_HOUSING_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 1 where ModifierId = 'ZEN_MEDITATION_HOLY_SITE_RIVER_HOUSING_MODIFIER' and Name = 'Amount';
insert or replace into BeliefModifiers
	(BeliefType,						ModifierID)
values
	('BELIEF_ZEN_MEDITATION',			'ZEN_MEDITATION_CITY_CENTER_RIVER_CULTURE'),
	('BELIEF_ZEN_MEDITATION',			'ZEN_MEDITATION_HOLY_SITE_RIVER_CULTURE');
insert or replace into Modifiers
	(ModifierId,												ModifierType,											SubjectRequirementSetId)
values
	('ZEN_MEDITATION_CITY_CENTER_RIVER_CULTURE',				'MODIFIER_ALL_CITIES_ATTACH_MODIFIER',					'CITY_FOLLOWS_RELIGION_REQUIREMENTS'),
	('ZEN_MEDITATION_CITY_CENTER_RIVER_CULTURE_MODIFIER',		'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',		'CITYCENTER_ADJACENT_TO_RIVER_REQUIREMENTS'),
    ('ZEN_MEDITATION_HOLY_SITE_RIVER_CULTURE',				    'MODIFIER_ALL_CITIES_ATTACH_MODIFIER',					'CITY_FOLLOWS_RELIGION_REQUIREMENTS'),
	('ZEN_MEDITATION_HOLY_SITE_RIVER_CULTURE_MODIFIER',		    'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_YIELD_CHANGE',		'HOLYSITE_ADJACENT_TO_RIVER_REQUIREMENTS');
insert or replace into ModifierArguments
	(ModifierId,												Name,						Value)
values
    ('ZEN_MEDITATION_CITY_CENTER_RIVER_CULTURE',				'ModifierId',	'ZEN_MEDITATION_CITY_CENTER_RIVER_CULTURE_MODIFIER'),
    ('ZEN_MEDITATION_CITY_CENTER_RIVER_CULTURE_MODIFIER',		'YieldType',	'YIELD_CULTURE'),
	('ZEN_MEDITATION_CITY_CENTER_RIVER_CULTURE_MODIFIER',		'Amount',		2),
    ('ZEN_MEDITATION_HOLY_SITE_RIVER_CULTURE',				    'ModifierId',	'ZEN_MEDITATION_HOLY_SITE_RIVER_CULTURE_MODIFIER'),
    ('ZEN_MEDITATION_HOLY_SITE_RIVER_CULTURE_MODIFIER',		    'YieldType',	'YIELD_CULTURE'),
	('ZEN_MEDITATION_HOLY_SITE_RIVER_CULTURE_MODIFIER',		    'Amount',		2);

-------------------------------------
--朝圣
update ModifierArguments set Value = 6 where ModifierId = 'PILGRIMAGE_FAITH_CITY_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 6 where ModifierId = 'PILGRIMAGE_FAITH_FOREIGN_CITY_MODIFIER' and Name = 'Amount';

-------------------------------------
--宗教统一
update ModifierArguments set Value = 1 where ModifierId = 'RELIGIOUS_UNITY_FAITH_FOLLOWER_MODIFIER' and Name = 'PerXItems';
update ModifierArguments set Value = 1 where ModifierId = 'RELIGIOUS_UNITY_FAITH_FOLLOWER_MODIFIER' and Name = 'Amount';

-------------------------------------
--什一税
update ModifierArguments set Value = 1 where ModifierId = 'TITHE_GOLD_FOLLOWER_MODIFIER' and Name = 'PerXItems';
update ModifierArguments set Value = 2 where ModifierId = 'TITHE_GOLD_FOLLOWER_MODIFIER' and Name = 'Amount';

-------------------------------------
--犹太
update Building_YieldChanges set YieldChange = 8 where BuildingType = 'BUILDING_SYNAGOGUE';
update ModifierArguments set Value = 15 where ModifierId = 'SYNAGOGUE_FAITH_PERCENTAGE_BOOST' and Name = 'Amount';

-------------------------------------
--少林寺（拜火）
insert or replace into BuildingModifiers
	(BuildingType,						ModifierID)
values
	('BUILDING_DAR_E_MEHR',			    'DAR_E_MEHR_GRANTMONKS');
insert or replace into Modifiers
	(ModifierId,							RunOnce,	Permanent,	ModifierType)
values
	('DAR_E_MEHR_GRANTMONKS',				1,	        1,	        'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY');
insert or replace into ModifierArguments
	(ModifierId,					Name,						Value)
values
    ('DAR_E_MEHR_GRANTMONKS',		'UnitType',	    			'UNIT_WARRIOR_MONK'),
	('DAR_E_MEHR_GRANTMONKS',		'AllowUniqueOverride',		1),
	('DAR_E_MEHR_GRANTMONKS',		'Amount',					1);

-- -------------------------------------
-- --自由探索
-- delete from CommemorationModifiers where CommemorationType = 'COMMEMORATION_SCIENTIFIC' and ModifierId = 'COMMEMORATION_SCIENTIFIC_GA_COMMERCIAL_HUB';

-- insert or replace into CommemorationModifiers
-- 	(CommemorationType,					ModifierId)
-- values
-- 	('COMMEMORATION_SCIENTIFIC',	    'COMMEMORATION_SCIENTIFIC_DISTRICTSCIENCE');
-- insert or replace into Modifiers
-- 	(ModifierId,									ModifierType,								                OwnerRequirementSetId)
-- values
-- 	('COMMEMORATION_SCIENTIFIC_DISTRICTSCIENCE',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_DISTRICT',	'PLAYER_HAS_GOLDEN_AGE');
-- insert or replace into ModifierArguments
-- 	(ModifierId,									Name,		    Value)
-- values
-- 	('COMMEMORATION_SCIENTIFIC_DISTRICTSCIENCE',	'YieldType',	'YIELD_SCIENCE'),
--     ('COMMEMORATION_SCIENTIFIC_DISTRICTSCIENCE',	'Amount',	    2);
-- --奢侈加金
-- update Adjacency_YieldChanges set YieldChange = 2 where ID = 'HD_Commercial_Luxury_Gold';
-- update Adjacency_YieldChanges set YieldChange = 4 where ID = 'HD_Commercial_Luxury_Gold_Late' ;

-- -------------------------------------
-- --刚果
-- --UA
-- insert or replace into TraitModifiers (TraitType, ModifierId) 
-- 	select 'TRAIT_CIVILIZATION_NKISI' , 'TRAIT_GREAT_WORK_FAITH_' || GreatWorkObjectType
-- 	from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into TraitModifiers (TraitType, ModifierId) 
-- 	select 'TRAIT_CIVILIZATION_NKISI' , 'TRAIT_GREAT_WORK_FOOD_' || GreatWorkObjectType
-- 	from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into TraitModifiers (TraitType, ModifierId) 
-- 	select 'TRAIT_CIVILIZATION_NKISI' , 'TRAIT_GREAT_WORK_PRODUCTION_' || GreatWorkObjectType
-- 	from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into TraitModifiers (TraitType, ModifierId) 
-- 	select 'TRAIT_CIVILIZATION_NKISI' , 'TRAIT_GREAT_WORK_GOLD_' || GreatWorkObjectType
-- 	from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

-- insert or replace into Modifiers(ModifierId,ModifierType)
--     select ModifierId,'MODIFIER_PLAYER_CITIES_ADJUST_GREATWORK_YIELD'
--     from TraitModifiers	where ModifierId like '%TRAIT_GREAT_WORK%';

-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_FAITH_' || GreatWorkObjectType,'GreatWorkObjectType',GreatWorkObjectType
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_FOOD_' || GreatWorkObjectType,'GreatWorkObjectType',GreatWorkObjectType
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_PRODUCTION_' || GreatWorkObjectType,'GreatWorkObjectType',GreatWorkObjectType
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_GOLD_' || GreatWorkObjectType,'GreatWorkObjectType',GreatWorkObjectType
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_FAITH_' || GreatWorkObjectType,'YieldType','YIELD_FAITH'
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_FOOD_' || GreatWorkObjectType,'YieldType','YIELD_FOOD'
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_PRODUCTION_' || GreatWorkObjectType,'YieldType','YIELD_PRODUCTION'
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_GOLD_' || GreatWorkObjectType,'YieldType','YIELD_GOLD'
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';

-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_FAITH_' || GreatWorkObjectType,'YieldChange',3
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_FOOD_' || GreatWorkObjectType,'YieldChange',3
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_PRODUCTION_' || GreatWorkObjectType,'YieldChange',3
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- insert or replace into ModifierArguments(ModifierId,Name,Value)
--     select 'TRAIT_GREAT_WORK_GOLD_' || GreatWorkObjectType,'YieldChange',6
--     from GreatWorks where GreatWorkObjectType != 'GREATWORKOBJECT_PRODUCT';
-- update ModifierArguments set Value = 2 where ModifierId like '%GREATWORKOBJECT_WRITING%' and Name = 'YieldChange';
-- update ModifierArguments set Value = 3 where ModifierId = 'TRAIT_GREAT_WORK_GOLD_GREATWORKOBJECT_WRITING' and Name = 'YieldChange';

-- --LA 
-- insert or replace into TraitModifiers 
-- 	(TraitType,						            ModifierId)
-- values
-- 	('TRAIT_LEADER_RELIGIOUS_CONVERT',		    'YT_TRAIT_LEADER_CULTURAL_FAITH');
-- insert or replace into Modifiers
-- 	(ModifierId,									ModifierType,														SubjectRequirementSetId)
-- values
--     ('YT_TRAIT_LEADER_CULTURAL_FAITH',	    'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',	    'DISTRICT_IS_THEATER');
-- insert or replace into ModifierArguments
-- 	(ModifierId,							        Name,			        Value)
-- values
-- 	('YT_TRAIT_LEADER_CULTURAL_FAITH',		'YieldTypeToMirror',	'YIELD_CULTURE'),
-- 	('YT_TRAIT_LEADER_CULTURAL_FAITH',		'YieldTypeToGrant',		'YIELD_FAITH');
-- --UD 
-- delete from DistrictModifiers where DistrictType = 'DISTRICT_MBANZA' and ModifierId = 'MBANZA_ADD_ADJACENT_JUNGLE_FOOD';
-- delete from DistrictModifiers where DistrictType = 'DISTRICT_MBANZA' and ModifierId = 'MBANZA_ADD_ADJACENT_FOREST_FOOD';
-- update Districts set Appeal = 1 where DistrictType = 'DISTRICT_MBANZA' ;

-- insert or replace into District_Adjacencies
-- 	(DistrictType,				YieldChangeId)
-- values
-- 	('DISTRICT_THEATER',	    'District_Culture_Mbanza'),
--     ('DISTRICT_COMMERCIAL_HUB',	'District_Gold_Mbanza');
-- insert or replace into Adjacency_YieldChanges
-- 	(ID,								Description,							YieldType,			YieldChange,	TilesRequired,  AdjacentDistrict,			PrereqCivic,	PrereqTech,			ObsoleteCivic,	ObsoleteTech)
-- values
-- 	('District_Culture_Mbanza',		    'LOC_DISTRICT_CULTURE_MBANZA',		    'YIELD_CULTURE',	2,				1,	            'DISTRICT_MBANZA',			    NULL,			NULL,				NULL,			NULL),
--     ('District_Gold_Mbanza',		    'LOC_DISTRICT_GOLD_MBANZA',				'YIELD_GOLD',	    2,				1,	            'DISTRICT_MBANZA',			    NULL,			NULL,				NULL,			NULL);

-------------------------------------
--     狂野模式 版本V0.2    --
-------------------------------------

-------------------------------------
--喀布尔
-- update ModifierArguments set Value = 100 where ModifierId = 'MINOR_CIV_KABUL_UNIT_EXPERIENCE_BONUS' and Name = 'Amount';

-------------------------------------
-- --阿卡德
-- insert or replace into TraitModifiers
-- 	(TraitType,					ModifierId)
-- values
-- 	('MINOR_CIV_AKKAD_TRAIT',	'MINOR_CIV_AKKAD_LANDCIVILIAN_INCREASED_MOVEMENT');

-- insert or replace into Modifiers	
-- 	(ModifierId,													ModifierType,											SubjectRequirementSetId)
-- values
-- 	('MINOR_CIV_AKKAD_LANDCIVILIAN_INCREASED_MOVEMENT',				'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_IS_SUZERAIN'),
-- 	('MINOR_CIV_AKKAD_LANDCIVILIAN_INCREASED_MOVEMENT_MODIFIER',	'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',					NULL),
-- 	('LANDCIVILIAN_INCREASED_MOVEMENT',           					'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',					NULL);	

-- insert or replace into	ModifierArguments
-- 	(ModifierId, 											        Name,												Value)
-- values
-- 	('MINOR_CIV_AKKAD_LANDCIVILIAN_INCREASED_MOVEMENT',				'ModifierId',										'MINOR_CIV_AKKAD_LANDCIVILIAN_INCREASED_MOVEMENT_MODIFIER'),
-- 	('MINOR_CIV_AKKAD_LANDCIVILIAN_INCREASED_MOVEMENT_MODIFIER',	'AbilityType',										'ABILITY_LANDCIVILIAN_INCREASED_MOVEMENT'),
--     ('LANDCIVILIAN_INCREASED_MOVEMENT',								'Amount',											1);
-- insert or replace into Types
-- 	(Type,													Kind)
-- values
-- 	('ABILITY_LANDCIVILIAN_INCREASED_MOVEMENT',				'KIND_ABILITY');

-- insert or replace into TypeTags		
-- 	(Type,													Tag)
-- select 
-- 	'ABILITY_LANDCIVILIAN_INCREASED_MOVEMENT',				'CLASS_LANDCIVILIAN';

-- insert or replace into UnitAbilities 
-- 	(UnitAbilityType, 										Inactive) 
-- values	
-- 	('ABILITY_LANDCIVILIAN_INCREASED_MOVEMENT',  			1);

-- insert or replace into UnitAbilityModifiers
-- 	(UnitAbilityType,										ModifierId)
-- values
-- 	('ABILITY_LANDCIVILIAN_INCREASED_MOVEMENT',				'LANDCIVILIAN_INCREASED_MOVEMENT');

-- -------------------------------------
-- --摩艾石像
-- insert or replace into Improvement_ValidResources
-- 	(ImprovementType,ResourceType,MustRemoveFeature)
-- select
-- 	'IMPROVEMENT_MOAI',ResourceType,1
-- from Resources;

-- -------------------------------------
-- --摩亨朱达罗
-- insert or replace into TraitModifiers
-- 	(TraitType,					ModifierId)
-- values
-- 	('MINOR_CIV_MOHENJO_DARO_TRAIT',	'MINOR_CIV_MOHENJO_DARO_THEATER_FOOD_BONUS'),
-- 	('MINOR_CIV_MOHENJO_DARO_TRAIT',	'MINOR_CIV_MOHENJO_DARO_THEATER_AMENITY_BONUS');

-- insert or replace into Modifiers	
-- 	(ModifierId,													ModifierType,											SubjectRequirementSetId)
-- values
-- 	('MINOR_CIV_MOHENJO_DARO_THEATER_FOOD_BONUS',					'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_IS_SUZERAIN'),
-- 	('MINOR_CIV_MOHENJO_DARO_THEATER_FOOD_BONUS_MODIFIER',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		'DISTRICT_IS_THEATER'),
-- 	('MINOR_CIV_MOHENJO_DARO_THEATER_AMENITY_BONUS',				'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_IS_SUZERAIN'),
-- 	('MINOR_CIV_MOHENJO_DARO_THEATER_AMENITY_BONUS_MODIFIER',		'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',			'YT_CITY_HAS_THEATER');	;	

-- insert or replace into	ModifierArguments
-- 	(ModifierId, 											        Name,												Value)
-- values
-- 	('MINOR_CIV_MOHENJO_DARO_THEATER_FOOD_BONUS',					'ModifierId',										'MINOR_CIV_MOHENJO_DARO_THEATER_FOOD_BONUS_MODIFIER'),
-- 	('MINOR_CIV_MOHENJO_DARO_THEATER_FOOD_BONUS_MODIFIER',			'YieldType',										'YIELD_FOOD'),
--     ('MINOR_CIV_MOHENJO_DARO_THEATER_FOOD_BONUS_MODIFIER',			'Amount',											3),
--     ('MINOR_CIV_MOHENJO_DARO_THEATER_AMENITY_BONUS',                'ModifierId',                                       'MINOR_CIV_MOHENJO_DARO_THEATER_AMENITY_BONUS_MODIFIER'),
--     ('MINOR_CIV_MOHENJO_DARO_THEATER_AMENITY_BONUS_MODIFIER',       'Amount',                                           1);

-- insert or replace into RequirementSets
-- 	(RequirementSetId, 										RequirementSetType)
-- values
-- 	('YT_CITY_HAS_THEATER',									'REQUIREMENTSET_TEST_ALL');

-- insert or replace into RequirementSetRequirements
-- 	(RequirementSetId, 										RequirementId)
-- values
-- 	('YT_CITY_HAS_THEATER',									'REQUIRES_CITY_HAS_DISTRICT_THEATER');

-- -------------------------------------
-- --维尔纽斯
-- delete from TraitModifiers where TraitType = 'MINOR_CIV_VILNIUS_TRAIT';
-- insert or replace into TraitModifiers
-- 	(TraitType,					ModifierId)
-- values
-- 	('MINOR_CIV_VILNIUS_TRAIT',	'MINOR_CIV_VILNIUS_THEATER_BONUS'),
-- 	('MINOR_CIV_VILNIUS_TRAIT',	'MINOR_CIV_VILNIUS_THEATER_BONUS1'),
-- 	('MINOR_CIV_VILNIUS_TRAIT',	'MINOR_CIV_VILNIUS_THEATER_BONUS2'),
-- 	('MINOR_CIV_VILNIUS_TRAIT',	'MINOR_CIV_VILNIUS_THEATER_BONUS3');
-- insert or replace into Modifiers	
-- 	(ModifierId,													ModifierType,											SubjectRequirementSetId)
-- values
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS',								'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_IS_SUZERAIN'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS1',							'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_IS_SUZERAIN'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS2',							'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_IS_SUZERAIN'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS3',							'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_IS_SUZERAIN'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS_MODIFIER',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',		'YT_REQUIRE_VILNIUS1'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS1_MODIFIER',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',		'YT_REQUIRE_VILNIUS2'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS2_MODIFIER',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',		'YT_REQUIRE_VILNIUS3'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS3_MODIFIER',					'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',		'DISTRICT_IS_THEATER');

-- insert or replace into	ModifierArguments
-- 	(ModifierId, 											Name,												Value)
-- values
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS',						'ModifierId',										'MINOR_CIV_VILNIUS_THEATER_BONUS_MODIFIER'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS_MODIFIER',			'YieldType',										'YIELD_CULTURE'),
--     ('MINOR_CIV_VILNIUS_THEATER_BONUS_MODIFIER',			'Amount',											50),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS1',						'ModifierId',										'MINOR_CIV_VILNIUS_THEATER_BONUS1_MODIFIER'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS1_MODIFIER',			'YieldType',										'YIELD_CULTURE'),
--     ('MINOR_CIV_VILNIUS_THEATER_BONUS1_MODIFIER',			'Amount',											50),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS2',						'ModifierId',										'MINOR_CIV_VILNIUS_THEATER_BONUS2_MODIFIER'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS2_MODIFIER',			'YieldType',										'YIELD_CULTURE'),
--     ('MINOR_CIV_VILNIUS_THEATER_BONUS2_MODIFIER',			'Amount',											50),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS3',						'ModifierId',										'MINOR_CIV_VILNIUS_THEATER_BONUS3_MODIFIER'),
-- 	('MINOR_CIV_VILNIUS_THEATER_BONUS3_MODIFIER',			'YieldType',										'YIELD_CULTURE'),
--     ('MINOR_CIV_VILNIUS_THEATER_BONUS3_MODIFIER',			'Amount',											50);
-- insert or replace into RequirementSets
-- 	(RequirementSetId, 										RequirementSetType)
-- values
-- 	('YT_REQUIRE_VILNIUS1',									'REQUIREMENTSET_TEST_ALL'),
-- 	('YT_REQUIRE_VILNIUS2',									'REQUIREMENTSET_TEST_ALL'),
-- 	('YT_REQUIRE_VILNIUS3',									'REQUIREMENTSET_TEST_ALL');

-- insert or replace into RequirementSetRequirements
-- 	(RequirementSetId, 										RequirementId)
-- values
-- 	('YT_REQUIRE_VILNIUS1',									'REQUIRES_DISTRICT_IS_THEATER'),
-- 	('YT_REQUIRE_VILNIUS1',									'REQUIRES_PLAYER_HAS_CIVIC_HUMANISM'),
-- 	('YT_REQUIRE_VILNIUS2',									'REQUIRES_DISTRICT_IS_THEATER'),
-- 	('YT_REQUIRE_VILNIUS2',									'REQUIRES_PLAYER_HAS_CIVIC_OPERA_BALLET'),
-- 	('YT_REQUIRE_VILNIUS3',									'REQUIRES_DISTRICT_IS_THEATER'),
-- 	('YT_REQUIRE_VILNIUS3',									'REQUIRES_PLAYER_HAS_CIVIC_CULTURAL_HERITAGE');

-- insert or ignore into Requirements
--     (RequirementId,                                         RequirementType)
-- values 
--     ('REQUIRES_PLAYER_HAS_CIVIC_HUMANISM',                  'REQUIREMENT_PLAYER_HAS_CIVIC'),
--     ('REQUIRES_PLAYER_HAS_CIVIC_OPERA_BALLET',              'REQUIREMENT_PLAYER_HAS_CIVIC'),
--     ('REQUIRES_PLAYER_HAS_CIVIC_CULTURAL_HERITAGE',         'REQUIREMENT_PLAYER_HAS_CIVIC');

-- insert or ignore into RequirementArguments
--     (RequirementId,                                         Name,                   Value)
-- values 
--     ('REQUIRES_PLAYER_HAS_CIVIC_HUMANISM',                  'CivicType',      		'CIVIC_HUMANISM'),
--     ('REQUIRES_PLAYER_HAS_CIVIC_OPERA_BALLET',              'CivicType',      		'CIVIC_OPERA_BALLET'), 
--     ('REQUIRES_PLAYER_HAS_CIVIC_CULTURAL_HERITAGE',         'CivicType',         	'CIVIC_CULTURAL_HERITAGE');


-- -------------------------------------
-- --梵蒂冈x
-- update ModifierArguments set Value = 3 where ModifierId = 'MINOR_CIV_VATICAN_CITY_SCULPTURE_CULTURE_BONUS1' and Name = 'YieldChange';
-- update ModifierArguments set Value = 3 where ModifierId = 'MINOR_CIV_VATICAN_CITY_SCULPTURE_FAITH_BONUS1' and Name = 'YieldChange';
-- update ModifierArguments set Value = 3 where ModifierId = 'MINOR_CIV_VATICAN_CITY_LANDSCAPE_CULTURE_BONUS1' and Name = 'YieldChange';
-- update ModifierArguments set Value = 3 where ModifierId = 'MINOR_CIV_VATICAN_CITY_LANDSCAPE_FAITH_BONUS1' and Name = 'YieldChange';
-- update ModifierArguments set Value = 3 where ModifierId = 'MINOR_CIV_VATICAN_CITY_PORTRAIT_CULTURE_BONUS1' and Name = 'YieldChange';
-- update ModifierArguments set Value = 3 where ModifierId = 'MINOR_CIV_VATICAN_CITY_PORTRAIT_FAITH_BONUS1' and Name = 'YieldChange';
-- update ModifierArguments set Value = 3 where ModifierId = 'MINOR_CIV_VATICAN_CITY_RELIGIOUS_CULTURE_BONUS1' and Name = 'YieldChange';
-- update ModifierArguments set Value = 3 where ModifierId = 'MINOR_CIV_VATICAN_CITY_RELIGIOUS_FAITH_BONUS1' and Name = 'YieldChange';

-------------------------------------
--纳斯卡
-- update ModifierArguments set Value = 2 where ModifierId = 'NAZCA_LINE_ADJACENCY_FAITH' and Name = 'Amount';
-- update ModifierArguments set Value = 2 where ModifierId = 'NAZCA_LINE_ADJACENCY_FOOD_DESERT_CIVIL_SERVICE' and Name = 'Amount';
-- update ModifierArguments set Value = 2 where ModifierId = 'NAZCA_LINE_ADJACENCY_FOOD_DESERT_HILLS_CIVIL_SERVICE' and Name = 'Amount';

-------------------------------------
--     狂野模式 版本V0.2    --
-------------------------------------

---------------------------------------
--市场
-- update Building_YieldChanges set YieldChange = 5 where BuildingType = 'BUILDING_MARKET' ;
-- update Buildings set Cost = 100 where BuildingType = 'BUILDING_MARKET';

-- ---------------------------------------
-- --大小庙
-- update Building_YieldChanges set YieldChange = 3 where BuildingType = 'BUILDING_SHRINE';
-- update Building_YieldChanges set YieldChange = 6 where BuildingType = 'BUILDING_TEMPLE';
-- update Building_YieldChanges set YieldChange = 6 where BuildingType = 'BUILDING_STAVE_CHURCH';
-- update Building_YieldChanges set YieldChange = 6 where BuildingType = 'BUILDING_PRASAT';

---------------------------------------
--宗社
update ModifierArguments set Value = 1 where ModifierId = 'RELIGIOUS_COMMUNITY_SHRINE_ORIGIN_SCIENCE_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 2 where ModifierId = 'RELIGIOUS_COMMUNITY_TEMPLE_ORIGIN_SCIENCE_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 3 where ModifierId = 'RELIGIOUS_COMMUNITY_TIER3_ORIGIN_SCIENCE_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 1 where ModifierId = 'RELIGIOUS_COMMUNITY_SHRINE_DESTINATION_SCIENCE_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 2 where ModifierId = 'RELIGIOUS_COMMUNITY_TEMPLE_DESTINATION_SCIENCE_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 3 where ModifierId = 'RELIGIOUS_COMMUNITY_TIER3_DESTINATION_SCIENCE_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 1 where ModifierId = 'RELIGIOUS_COMMUNITY_SHRINE_SCIENCE_TO_OTHERS_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 2 where ModifierId = 'RELIGIOUS_COMMUNITY_TEMPLE_SCIENCE_TO_OTHERS_MODIFIER' and Name = 'Amount';
update ModifierArguments set Value = 3 where ModifierId = 'RELIGIOUS_COMMUNITY_TIER3_SCIENCE_TO_OTHERS_MODIFIER' and Name = 'Amount';