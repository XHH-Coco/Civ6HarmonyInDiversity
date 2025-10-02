-------------------------------------
--      Gaul & Byzantium DLC       --
-------------------------------------

-- Wonder
update Buildings set PrereqCivic = 'CIVIC_DRAMA_POETRY', AdjacentDistrict = 'DISTRICT_THEATER', RegionalRange = 0, RequiresRiver = 1 where BuildingType = 'BUILDING_STATUE_OF_ZEUS';

delete from Building_ValidTerrains where BuildingType = 'BUILDING_STATUE_OF_ZEUS';
delete from BuildingPrereqs where Building = 'BUILDING_STATUE_OF_ZEUS';
delete from Building_YieldChanges where BuildingType = 'BUILDING_STATUE_OF_ZEUS';

insert or replace into Building_YieldChanges
	(BuildingType,                  YieldType,          YieldChange)
values
	('BUILDING_STATUE_OF_ZEUS',     'YIELD_CULTURE',    1),
	('BUILDING_STATUE_OF_ZEUS',     'YIELD_FAITH',      1);

delete from BuildingModifiers where BuildingType = 'BUILDING_STATUE_OF_ZEUS';

insert or replace into BuildingModifiers
    (BuildingType,                  ModifierId)
select
    'BUILDING_STATUE_OF_ZEUS',      'STATUE_OF_ZEUS_INFLUENCE_POINTS_ATTACH'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_STATUE_OF_ZEUS');

insert or replace into Modifiers
    (ModifierId,                                    ModifierType,                               SubjectRequirementSetId)
select
    'STATUE_OF_ZEUS_INFLUENCE_POINTS_ATTACH',       'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',   'CITY_HAS_MONUMENT'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_STATUE_OF_ZEUS');

insert or replace into ModifierArguments
    (ModifierId,                                    Name,           Value)
select
    'STATUE_OF_ZEUS_INFLUENCE_POINTS_ATTACH',       'ModifierId',   'STATUE_OF_ZEUS_INFLUENCE_POINTS'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_STATUE_OF_ZEUS');

insert or replace into Modifiers
    (ModifierId,                                    ModifierType)
values
    ('STATUE_OF_ZEUS_INFLUENCE_POINTS',             'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN');

insert or replace into ModifierArguments
    (ModifierId,                                    Name,           Value)
values
    ('STATUE_OF_ZEUS_INFLUENCE_POINTS',             'Amount',       1);

insert or replace into Improvement_Adjacencies
    (ImprovementType,               YieldChangeId)
values
    ('IMPROVEMENT_MINE',            'Mine_Oppidum_Production'),
    ('IMPROVEMENT_QUARRY',          'Quarry_Oppidum_Production'),
    ('IMPROVEMENT_LUMBER_MILL',     'Lumber_Mill_Oppidum_Production');
    -- ('IMPROVEMENT_CAMP',            'Camp_Hippodrome_Gold');

insert or replace into Improvement_Adjacencies
    (ImprovementType,               YieldChangeId)
select
    ImprovementType,                'BATEY_Hippodrome_Culture'
from Improvements where ImprovementType = 'IMPROVEMENT_BATEY';
insert or replace into Improvement_Adjacencies
    (ImprovementType,               YieldChangeId)
select
    ImprovementType,                'BATEY_Late_Hippodrome_Culture'
from Improvements where ImprovementType = 'IMPROVEMENT_BATEY';

insert or replace into Adjacency_YieldChanges
    (ID,                                Description,    YieldType,          YieldChange,    TilesRequired,  AdjacentRiver,
    AdjacentDistrict,               PrereqCivic,    PrereqTech, ObsoleteCivic,  ObsoleteTech,   AdjacentResourceClass)
values
    ('Mine_Oppidum_Production',         'Placeholder', 'YIELD_PRODUCTION',  1,              1,              0,
    'DISTRICT_OPPIDUM',             NULL,           NULL,       NULL,           NULL,           'NO_RESOURCECLASS'),
    ('Quarry_Oppidum_Production',       'Placeholder', 'YIELD_PRODUCTION',  1,              1,              0,
    'DISTRICT_OPPIDUM',             NULL,           NULL,       NULL,           NULL,           'NO_RESOURCECLASS'),
    ('Lumber_Mill_Oppidum_Production',  'Placeholder', 'YIELD_PRODUCTION',  1,              1,              0,
    'DISTRICT_OPPIDUM',             NULL,           NULL,       NULL,           NULL,           'NO_RESOURCECLASS'),
    ('Camp_Hippodrome_Gold',            'Placeholder', 'YIELD_GOLD',        2,              1,              0,
    'DISTRICT_HIPPODROME',          NULL,           NULL,       NULL,           NULL,           'NO_RESOURCECLASS'),
    ('BATEY_Hippodrome_Culture', 	    'Placeholder', 'YIELD_CULTURE',		1,				1,				0,
	'DISTRICT_HIPPODROME',		    NULL,			NULL,		'CIVIC_HUMANISM',	NULL,		'NO_RESOURCECLASS'),
	('BATEY_Late_Hippodrome_Culture', 	'Placeholder', 'YIELD_CULTURE',		2,				1,				0,
	'DISTRICT_HIPPODROME',		    'CIVIC_HUMANISM',	NULL,	NULL,			NULL,			'NO_RESOURCECLASS');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,									RequirementId)
values
	('PLOT_ADJACENT_TO_INDUSTRIAL_ZONE',				'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_OPPIDUM');
--高卢重做
update UnitUpgrades set UpgradeUnit = 'UNIT_SWORDSMAN' where Unit = 'UNIT_GAUL_GAESATAE';
update Districts set Housing = 2 where DistrictType = 'DISTRICT_OPPIDUM';
delete from DistrictModifiers where ModifierId = 'OPPIDUM_GRANT_TECH_APPRENTICESHIP';
delete from ExcludedAdjacencies where TraitType = 'TRAIT_CIVILIZATION_GAUL';

insert or replace into TraitModifiers
	(TraitType,							ModifierId)
values
	('TRAIT_CIVILIZATION_GAUL',			'GAUL_QUARRY_CULTURE'),
	('TRAIT_CIVILIZATION_GAUL',			'GAUL_QUARRY_CULTURE_BOMB'),
	('TRAIT_CIVILIZATION_GAUL',			'GAUL_QUARRY_TOURISM'),
	('TRAIT_CIVILIZATION_GAUL',			'GAUL_CITY_HAS_IRON'),
	('TRAIT_CIVILIZATION_GAUL',			'TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION'),
	('TRAIT_CIVILIZATION_GAUL',			'TRAIT_CIVILIZATION_GAUL_CAMPUS_ADJACENCYSCIENCE_HD'),
	('TRAIT_CIVILIZATION_GAUL',			'TRAIT_CIVILIZATION_GAUL_COMMERCIALHUB_ADJACENCYGOLD_HD'),
	('TRAIT_CIVILIZATION_GAUL',			'TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION_HD'),
	('TRAIT_CIVILIZATION_GAUL',			'TRAIT_CIVILIZATION_GAUL_HARBOR_ADJACENCYGOLD_HD'),
	('TRAIT_CIVILIZATION_GAUL',			'TRAIT_CIVILIZATION_GAUL_HOLYSITE_ADJACENCYFAITH_HD'),
	('TRAIT_CIVILIZATION_GAUL',			'TRAIT_CIVILIZATION_GAUL_OPPIDUM_ADJACENCYPRODUCTION_HD'),
	('TRAIT_CIVILIZATION_GAUL',			'TRAIT_CIVILIZATION_GAUL_THEATER_ADJACENCYCULTURE_HD');
insert or replace into Modifiers
	(ModifierId,													ModifierType,														SubjectRequirementSetId)
values
	('GAUL_QUARRY_CULTURE',											'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								'PLOT_HAS_QUARRY_REQUIREMENTS'),
	('GAUL_QUARRY_CULTURE_BOMB',									'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER',							NULL),
	('GAUL_QUARRY_TOURISM',											'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',								'PLAYER_HAS_FLIGHT'),
	('GAUL_CITY_HAS_IRON',											'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',							'CITY_HAS_IMPROVED_IRON'),
	('GAUL_CITY_HAS_IRON_MODIFIER',									'MODIFIER_PLAYER_ATTACH_MODIFIER',									NULL),
	('GAUL_TECH_IRON_WORKING',										'MODIFIER_PLAYER_GRANT_SPECIFIC_TECHNOLOGY',						NULL),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION',		'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY',						NULL),
	('TRAIT_CIVILIZATION_GAUL_CAMPUS_ADJACENCYSCIENCE_HD',			'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY',						NULL),
	('TRAIT_CIVILIZATION_GAUL_COMMERCIALHUB_ADJACENCYGOLD_HD',		'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY',						NULL),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION_HD',	'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY',						NULL),
	('TRAIT_CIVILIZATION_GAUL_HARBOR_ADJACENCYGOLD_HD',				'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY',						NULL),
	('TRAIT_CIVILIZATION_GAUL_HOLYSITE_ADJACENCYFAITH_HD',			'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY',						NULL),
	('TRAIT_CIVILIZATION_GAUL_OPPIDUM_ADJACENCYPRODUCTION_HD',		'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY',						NULL),
	('TRAIT_CIVILIZATION_GAUL_THEATER_ADJACENCYCULTURE_HD',			'MODIFIER_PLAYER_CITIES_IMPROVEMENT_ADJACENCY',						NULL);
insert or replace into ModifierArguments
	(ModifierId,													Name,						Value)
values
	('GAUL_QUARRY_CULTURE',											'Amount',					1),
	('GAUL_QUARRY_CULTURE',											'YieldType',				'YIELD_CULTURE'),
	('GAUL_QUARRY_CULTURE_BOMB',									'CaptureOwnedTerritory',	0),
	('GAUL_QUARRY_CULTURE_BOMB',									'ImprovementType',			'IMPROVEMENT_QUARRY'),
	('GAUL_QUARRY_TOURISM',											'ImprovementType',			'IMPROVEMENT_QUARRY'),
	('GAUL_QUARRY_TOURISM',											'ScalingFactor',			200),
	('GAUL_CITY_HAS_IRON',											'ModifierId',				'GAUL_CITY_HAS_IRON_MODIFIER'),
	('GAUL_CITY_HAS_IRON_MODIFIER',									'ModifierId',				'GAUL_TECH_IRON_WORKING'),
	('GAUL_TECH_IRON_WORKING',										'TechType',					'TECH_IRON_WORKING'),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION',		'Amount',					1),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION',		'Description',				'LOC_DISTRICT_MINE_1_PRODUCTION'),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION',		'DistrictType',				'DISTRICT_ENCAMPMENT'),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION',		'ImprovementType',			'IMPROVEMENT_MINE'),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION',		'TilesRequired',			1),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION',		'YieldType',				'YIELD_PRODUCTION'),
	('TRAIT_CIVILIZATION_GAUL_CAMPUS_ADJACENCYSCIENCE_HD',			'Amount',					1),
	('TRAIT_CIVILIZATION_GAUL_CAMPUS_ADJACENCYSCIENCE_HD',			'Description',				'LOC_DISTRICT_QUARRY_1_SCIENCE'),
	('TRAIT_CIVILIZATION_GAUL_CAMPUS_ADJACENCYSCIENCE_HD',			'DistrictType',				'DISTRICT_CAMPUS'),
	('TRAIT_CIVILIZATION_GAUL_CAMPUS_ADJACENCYSCIENCE_HD',			'ImprovementType',			'IMPROVEMENT_QUARRY'),
	('TRAIT_CIVILIZATION_GAUL_CAMPUS_ADJACENCYSCIENCE_HD',			'TilesRequired',			1),
	('TRAIT_CIVILIZATION_GAUL_CAMPUS_ADJACENCYSCIENCE_HD',			'YieldType',				'YIELD_SCIENCE'),
	('TRAIT_CIVILIZATION_GAUL_COMMERCIALHUB_ADJACENCYGOLD_HD',		'Amount',					1),
	('TRAIT_CIVILIZATION_GAUL_COMMERCIALHUB_ADJACENCYGOLD_HD',		'Description',				'LOC_DISTRICT_QUARRY_1_GOLD'),
	('TRAIT_CIVILIZATION_GAUL_COMMERCIALHUB_ADJACENCYGOLD_HD',		'DistrictType',				'DISTRICT_COMMERCIAL_HUB'),
	('TRAIT_CIVILIZATION_GAUL_COMMERCIALHUB_ADJACENCYGOLD_HD',		'ImprovementType',			'IMPROVEMENT_QUARRY'),
	('TRAIT_CIVILIZATION_GAUL_COMMERCIALHUB_ADJACENCYGOLD_HD',		'TilesRequired',			1),
	('TRAIT_CIVILIZATION_GAUL_COMMERCIALHUB_ADJACENCYGOLD_HD',		'YieldType',				'YIELD_GOLD'),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION_HD',	'Amount',					1),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION_HD',	'Description',				'LOC_DISTRICT_QUARRY_1_PRODUCTION'),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION_HD',	'DistrictType',				'DISTRICT_ENCAMPMENT'),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION_HD',	'ImprovementType',			'IMPROVEMENT_QUARRY'),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION_HD',	'TilesRequired',			1),
	('TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION_HD',	'YieldType',				'YIELD_PRODUCTION'),
	('TRAIT_CIVILIZATION_GAUL_HARBOR_ADJACENCYGOLD_HD',				'Amount',					1),
	('TRAIT_CIVILIZATION_GAUL_HARBOR_ADJACENCYGOLD_HD',				'Description',				'LOC_DISTRICT_QUARRY_1_GOLD'),
	('TRAIT_CIVILIZATION_GAUL_HARBOR_ADJACENCYGOLD_HD',				'DistrictType',				'DISTRICT_HARBOR'),
	('TRAIT_CIVILIZATION_GAUL_HARBOR_ADJACENCYGOLD_HD',				'ImprovementType',			'IMPROVEMENT_QUARRY'),
	('TRAIT_CIVILIZATION_GAUL_HARBOR_ADJACENCYGOLD_HD',				'TilesRequired',			1),
	('TRAIT_CIVILIZATION_GAUL_HARBOR_ADJACENCYGOLD_HD',				'YieldType',				'YIELD_GOLD'),
	('TRAIT_CIVILIZATION_GAUL_HOLYSITE_ADJACENCYFAITH_HD',			'Amount',					1),
	('TRAIT_CIVILIZATION_GAUL_HOLYSITE_ADJACENCYFAITH_HD',			'Description',				'LOC_DISTRICT_QUARRY_1_FAITH'),
	('TRAIT_CIVILIZATION_GAUL_HOLYSITE_ADJACENCYFAITH_HD',			'DistrictType',				'DISTRICT_HOLY_SITE'),
	('TRAIT_CIVILIZATION_GAUL_HOLYSITE_ADJACENCYFAITH_HD',			'ImprovementType',			'IMPROVEMENT_QUARRY'),
	('TRAIT_CIVILIZATION_GAUL_HOLYSITE_ADJACENCYFAITH_HD',			'TilesRequired',			1),
	('TRAIT_CIVILIZATION_GAUL_HOLYSITE_ADJACENCYFAITH_HD',			'YieldType',				'YIELD_FAITH'),
	('TRAIT_CIVILIZATION_GAUL_OPPIDUM_ADJACENCYPRODUCTION_HD',		'Amount',					1),
	('TRAIT_CIVILIZATION_GAUL_OPPIDUM_ADJACENCYPRODUCTION_HD',		'Description',				'LOC_DISTRICT_QUARRY_1_PRODUCTION'),
	('TRAIT_CIVILIZATION_GAUL_OPPIDUM_ADJACENCYPRODUCTION_HD',		'DistrictType',				'DISTRICT_OPPIDUM'),
	('TRAIT_CIVILIZATION_GAUL_OPPIDUM_ADJACENCYPRODUCTION_HD',		'ImprovementType',			'IMPROVEMENT_QUARRY'),
	('TRAIT_CIVILIZATION_GAUL_OPPIDUM_ADJACENCYPRODUCTION_HD',		'TilesRequired',			1),
	('TRAIT_CIVILIZATION_GAUL_OPPIDUM_ADJACENCYPRODUCTION_HD',		'YieldType',				'YIELD_PRODUCTION'),
	('TRAIT_CIVILIZATION_GAUL_THEATER_ADJACENCYCULTURE_HD',			'Amount',					1),
	('TRAIT_CIVILIZATION_GAUL_THEATER_ADJACENCYCULTURE_HD',			'Description',				'LOC_DISTRICT_QUARRY_1_CULTURE'),
	('TRAIT_CIVILIZATION_GAUL_THEATER_ADJACENCYCULTURE_HD',			'DistrictType',				'DISTRICT_THEATER'),
	('TRAIT_CIVILIZATION_GAUL_THEATER_ADJACENCYCULTURE_HD',			'ImprovementType',			'IMPROVEMENT_QUARRY'),
	('TRAIT_CIVILIZATION_GAUL_THEATER_ADJACENCYCULTURE_HD',			'TilesRequired',			1),
	('TRAIT_CIVILIZATION_GAUL_THEATER_ADJACENCYCULTURE_HD',			'YieldType',				'YIELD_CULTURE');


update ModifierArguments set Value = 1 where Name = 'TilesRequired' and ModifierId in (
	'TRAIT_CIVILIZATION_GAUL_CAMPUS_ADJACENCYSCIENCE',
	'TRAIT_CIVILIZATION_GAUL_COMMERCIALHUB_ADJACENCYGOLD',
	'TRAIT_CIVILIZATION_GAUL_ENCAMPMENT_ADJACENCYPRODUCTION',
	'TRAIT_CIVILIZATION_GAUL_HARBOR_ADJACENCYGOLD',
	'TRAIT_CIVILIZATION_GAUL_HOLYSITE_ADJACENCYFAITH',
	'TRAIT_CIVILIZATION_GAUL_OPPIDUM_ADJACENCYPRODUCTION',
	'TRAIT_CIVILIZATION_GAUL_THEATER_ADJACENCYCULTURE'
);
-- AI

insert or replace into AiListTypes (ListType) values
    ('AmbiorixBuildings'),
    ('AmbiorixDistricts'),
    ('AmbiorixYields');

insert or replace into AiLists
    (ListType,                  LeaderType,                         System)
values
    ('AmbiorixBuildings',       'TRAIT_LEADER_AMBIORIX',            'Buildings'),
    ('AmbiorixDistricts',       'TRAIT_LEADER_AMBIORIX',            'Districts'),
    ('AmbiorixYields',          'TRAIT_LEADER_AMBIORIX',            'Yields');

insert or replace into AiFavoredItems
    (ListType,                  Item,                       Favored,    Value)
values
    ('AmbiorixBuildings',       'BUILDING_WORKSHOP',        1,          0),
    ('AmbiorixDistricts',       'DISTRICT_OPPIDUM',         1,          0),
    ('GaulFavoredTechs',        'TECH_IRON_WORKING',        1,          0),
    ('AmbiorixYields',          'YIELD_FAITH',              1,          -20),
    ('AmbiorixYields',          'YIELD_FOOD',               1,          10),
    ('AmbiorixYields',          'YIELD_PRODUCTION',         1,          10);

update Districts set PrereqCivic = NULL, PrereqTech = 'TECH_HORSEBACK_RIDING' where DistrictType = 'DISTRICT_HIPPODROME';
insert or replace into DistrictModifiers
	(DistrictType,					ModifierId)
values
	('DISTRICT_HIPPODROME',	'HD_DISTRICT_HIPPODROME_EXTRA_AMENITY'),
	('DISTRICT_HIPPODROME',	'HD_DISTRICT_HIPPODROME_TECH_SADDLE_HD');

insert or replace into Modifiers
	(ModifierId,																			ModifierType,																	OwnerRequirementSetId)
values
	('HD_DISTRICT_HIPPODROME_EXTRA_AMENITY',					'MODIFIER_ADJUST_AMENITIES_IN_DISTRICT',			'HD_PLOT_ADJACENT_TO_IMPROVEMENT_CAMP_OR_PASTURE'),
	('HD_DISTRICT_HIPPODROME_TECH_SADDLE_HD',					'MODIFIER_PLAYER_GRANT_SPECIFIC_TECHNOLOGY',	Null);

insert or replace into ModifierArguments
	(ModifierId,																			Name,				Value)
values
	('HD_DISTRICT_HIPPODROME_EXTRA_AMENITY',					'Amount',		1),
	('HD_DISTRICT_HIPPODROME_TECH_SADDLE_HD',					'TechType',	'TECH_SADDLE_HD');


--拜占庭
--ua世界渴望之城：
--非首都城市建造首都已有区域时+50%生产力。圣地+4大预言家点数。每个信奉拜占庭主流宗教的圣城为拜占庭的军事和宗教单位+3战斗力。

--删除拜占庭击杀传教能力
delete from UnitAbilityModifiers where ModifierId = 'BYZANTIUM_PRESSURE_KILLS';

insert or replace into TraitModifiers
	(TraitType,								ModifierId)
values
	('TRAIT_CIVILIZATION_BYZANTIUM',		'BYZANTIUM_ADD_GREATPROPHETPOINTS');
insert or replace into Modifiers
	(ModifierId,							ModifierType,												SubjectRequirementSetId)
values
	('BYZANTIUM_ADD_GREATPROPHETPOINTS',	'MODIFIER_PLAYER_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',		'DISTRICT_IS_HOLY_SITE');

insert or replace into ModifierArguments
	(ModifierId,							Name,						Value)
values
	('BYZANTIUM_ADD_GREATPROPHETPOINTS',	'Amount',					2),
	('BYZANTIUM_ADD_GREATPROPHETPOINTS',	'GreatPersonClassType',		'GREAT_PERSON_CLASS_PROPHET');
--非首都城市建造首都已有区域时+50%生产力。
insert or replace into TraitModifiers
	(TraitType,							ModifierId)
select
	'TRAIT_CIVILIZATION_BYZANTIUM',		'BYZANTIUM_' || DistrictType || '_SPEED'
from Districts where DistrictType not in (select CivUniqueDistrictType from DistrictReplaces);

insert or replace into Modifiers
	(ModifierId,								ModifierType,									SubjectRequirementSetId,							SubjectStackLimit)
select
	'BYZANTIUM_' || DistrictType || '_SPEED',	'MODIFIER_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER',	'CITY_HAS_' || DistrictType || '_REQUIREMENTS',		1
from Districts where DistrictType not in (select CivUniqueDistrictType from DistrictReplaces);

insert or replace into ModifierArguments
	(ModifierId,								Name,			Value)
select
	'BYZANTIUM_' || DistrictType || '_SPEED',	'ModifierId',	'BYZANTIUM_' || DistrictType || '_SPEED_MODIFIER'
from Districts where DistrictType not in (select CivUniqueDistrictType from DistrictReplaces);

insert or replace into Modifiers
	(ModifierId,										ModifierType)
select
	'BYZANTIUM_' || DistrictType || '_SPEED_MODIFIER',	'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION'
from Districts where DistrictType not in (select CivUniqueDistrictType from DistrictReplaces);

insert or replace into ModifierArguments
	(ModifierId,										Name,		Value)
select
	'BYZANTIUM_' || DistrictType || '_SPEED_MODIFIER',	'Amount',	50
from Districts where DistrictType not in (select CivUniqueDistrictType from DistrictReplaces);

insert or replace into ModifierArguments
	(ModifierId,										Name,			Value)
select
	'BYZANTIUM_' || DistrictType || '_SPEED_MODIFIER',	'DistrictType',	DistrictType
from Districts where DistrictType not in (select CivUniqueDistrictType from DistrictReplaces);

--甲胄骑兵：改为拜占庭UU
delete from LeaderTraits where TraitType = 'TRAIT_LEADER_UNIT_BYZANTINE_TAGMA';
insert or replace into CivilizationTraits
	(CivilizationType,				TraitType)
values
	('CIVILIZATION_BYZANTIUM',		'TRAIT_LEADER_UNIT_BYZANTINE_TAGMA');

--巴西尔la生于紫室：击杀敌方单位时，向6个单元格内的城市释放拜占庭的宗教压力。攻击与拜占庭主流宗教相同的城市时骑兵对城墙造成全额伤害。
insert or replace into TraitModifiers
	(TraitType,						ModifierId)
values
	('TRAIT_LEADER_BASIL',			'BASIL_PRESSURE_KILLS');

insert or replace into Modifiers
	(ModifierId,					ModifierType)
values
	('BASIL_PRESSURE_KILLS',		'MODIFIER_PLAYER_UNITS_GRANT_ABILITY');

insert or replace into ModifierArguments
	(ModifierId,					Name,			Value)
values
	('BASIL_PRESSURE_KILLS',		'AbilityType',	'ABILITY_BASIL_PRESSURE_KILLS');

insert or replace into Types
	(Type,								Kind)
values
	('ABILITY_BASIL_PRESSURE_KILLS',	'KIND_ABILITY');

insert or replace into UnitAbilities
	(UnitAbilityType,					Name,										Description,										Inactive,	ShowFloatTextWhenEarned,	Permanent)
values
	('ABILITY_BASIL_PRESSURE_KILLS',	'LOC_ABILITY_BYZANTIUM_COMBAT_UNITS_NAME',	'LOC_ABILITY_BASIL_PRESSURE_KILLS_DESCRIPTION',		1,			0,							1);

insert or replace into UnitAbilityModifiers
	(UnitAbilityType,					ModifierId)
values
	('ABILITY_BASIL_PRESSURE_KILLS',	'BYZANTIUM_PRESSURE_KILLS');

insert or replace into TypeTags
	(Type,								Tag)
select
	'ABILITY_BASIL_PRESSURE_KILLS',		Tag
from TypeTags where Type = 'ABILITY_BYZANTIUM_COMBAT_UNITS';

--跑马场：取代娱乐区，+4宜居度，每相邻一个资源+1琴，建成时赠送一个可训练的最强重骑兵单位，此单位无需战略资源训练和维护。额外赠送一个区域位。
insert or replace into District_Adjacencies
	(DistrictType,				YieldChangeId)
values
	('DISTRICT_HIPPODROME',		'Resource_Culture');

insert or replace into Adjacency_YieldChanges
	(ID,					Description,							YieldType,			YieldChange,	AdjacentResource,	AdjacentResourceClass)
values
	('Resource_Culture',	'LOC_DISTRICT_RESOURCE_CULTURE',		'YIELD_CULTURE',	1,				1,					'NO_RESOURCECLASS');

--希腊火：改为罗盘解锁的中世纪海军远程，取代三桅战舰。远程力更高但是近战力更低（120锤近30力远53力2射程）
--狄奥多拉la拜占庭的宠儿：圣地和跑马场建成时，开发相邻的加成和奢侈资源。创力宗教时可以额外选取一个信条。