--世宗 删除原能力 新增能力书院加2琴3%鼓舞
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_SEJONG';

insert or replace into TraitModifiers
	(TraitType,							ModifierId)
select
	'TRAIT_LEADER_SEJONG',	'HD_SEJONG_' || a.BuildingType || '_' || b.YieldType || '_BONUS'
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER') and b.YieldType in ('YIELD_SCIENCE', 'YIELD_CULTURE')
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into Modifiers
	(ModifierId,																											ModifierType)
select
	'HD_SEJONG_' || a.BuildingType || '_' || b.YieldType || '_BONUS',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER') and b.YieldType in ('YIELD_SCIENCE', 'YIELD_CULTURE')
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into ModifierArguments
	(ModifierId,																											Name,						Value)
select
	'HD_SEJONG_' || a.BuildingType || '_' || b.YieldType || '_BONUS',	'BuildingType',	a.BuildingType
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER') and b.YieldType in ('YIELD_SCIENCE', 'YIELD_CULTURE')
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into ModifierArguments
	(ModifierId,																											Name,						Value)
select
	'HD_SEJONG_' || a.BuildingType || '_' || b.YieldType || '_BONUS',	'Amount',				b.YieldChange
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER') and b.YieldType in ('YIELD_SCIENCE', 'YIELD_CULTURE')
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into ModifierArguments
	(ModifierId,																											Name,						Value)
select
	'HD_SEJONG_' || a.BuildingType || '_' || b.YieldType || '_BONUS',	'YieldType',		'YIELD_CULTURE'
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER') and b.YieldType = 'YIELD_SCIENCE'
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

insert or replace into ModifierArguments
	(ModifierId,																											Name,						Value)
select
	'HD_SEJONG_' || a.BuildingType || '_' || b.YieldType || '_BONUS',	'YieldType',		'YIELD_SCIENCE'
from Buildings a inner join Building_YieldChanges b on a.BuildingType = b.BuildingType
	where a.PrereqDistrict in ('DISTRICT_CAMPUS', 'DISTRICT_THEATER') and b.YieldType = 'YIELD_CULTURE'
	and a.BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS)
	and a.BuildingType not in (select CivUniqueBuildingType from BuildingReplaces);

-- 编撰官
insert or ignore into Types
	(Type,                                      Kind)
values
	('TRAIT_HD_CODIFIER',          							'KIND_TRAIT'),
	('GREAT_PERSON_CLASS_HD_CODIFIER',          'KIND_GREAT_PERSON_CLASS'),
	('UNIT_HD_CODIFIER',                        'KIND_UNIT');

insert or replace into Traits
	(TraitType,								Name)
values
	('TRAIT_HD_CODIFIER',			'LOC_TRAIT_HD_CODIFIER_NAME');

insert or replace into LeaderTraits
	(LeaderType,							TraitType)
values
	('LEADER_SEJONG',					'TRAIT_HD_CODIFIER');

insert or replace into Units
	(UnitType,              Name,                       		BaseSightRange, BaseMoves,  Domain,         FormationClass,             Cost,   Description,                        		CanCapture, CanRetreatWhenCaptured, CanTrain, TraitType)
values
	('UNIT_HD_CODIFIER',    'LOC_UNIT_HD_CODIFIER_NAME',    2,              4,          'DOMAIN_LAND',  'FORMATION_CLASS_CIVILIAN', 1,      'LOC_UNIT_HD_CODIFIER_DESCRIPTION',     0,          1,                      0,				'TRAIT_HD_CODIFIER');

insert or replace into GreatPersonClasses
	(GreatPersonClassType,              Name,                         							UnitType,           DistrictType,           PseudoYieldType,             IconString,             ActionIcon,                          AvailableInTimeline,	GenerateDuplicateIndividuals)
values
	('GREAT_PERSON_CLASS_HD_CODIFIER',  'LOC_GREAT_PERSON_CLASS_HD_CODIFIER_NAME',  'UNIT_HD_CODIFIER', 'DISTRICT_CAMPUS',      'PSEUDOYIELD_GPP_WRITER',    '[ICON_GreatWriter]', 	'ICON_UNITOPERATION_WRITER_ACTION',   0,										1);

-- 编撰官 伟人
create table HD_NEW_CODIFIER (
	GreatPersonIndividualType TEXT not null,
	GreatWorkType TEXT,
	primary key (GreatPersonIndividualType, GreatWorkType)
);

insert or replace into HD_NEW_CODIFIER
	(GreatPersonIndividualType,										GreatWorkType)
values
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_1',			'GREATWORK_HD_CODIFIER_1'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_2',			'GREATWORK_HD_CODIFIER_2'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_3',			'GREATWORK_HD_CODIFIER_3'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_4',			'GREATWORK_HD_CODIFIER_4'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_5',			'GREATWORK_HD_CODIFIER_5'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_6',			'GREATWORK_HD_CODIFIER_6'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_7',			'GREATWORK_HD_CODIFIER_7'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_8',			'GREATWORK_HD_CODIFIER_8'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_9',			'GREATWORK_HD_CODIFIER_9'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_10',		'GREATWORK_HD_CODIFIER_10'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_11',		'GREATWORK_HD_CODIFIER_11'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_12',		'GREATWORK_HD_CODIFIER_12'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_13',		'GREATWORK_HD_CODIFIER_13'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_14',		'GREATWORK_HD_CODIFIER_14'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_15',		'GREATWORK_HD_CODIFIER_15'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_16',		'GREATWORK_HD_CODIFIER_16'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_17',		'GREATWORK_HD_CODIFIER_17'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_18',		'GREATWORK_HD_CODIFIER_18'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_19',		'GREATWORK_HD_CODIFIER_19'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_20',		'GREATWORK_HD_CODIFIER_20'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_21',		'GREATWORK_HD_CODIFIER_21'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_22',		'GREATWORK_HD_CODIFIER_22'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_23',		'GREATWORK_HD_CODIFIER_23'),
	('GREAT_PERSON_INDIVIDUAL_HD_CODIFIER_24',		'GREATWORK_HD_CODIFIER_24');

insert or ignore into Types (Type, Kind)
	select GreatPersonIndividualType,	'KIND_GREAT_PERSON_INDIVIDUAL' from HD_NEW_CODIFIER;

insert or ignore into GreatPersonIndividuals
	(GreatPersonIndividualType, Name, GreatPersonClassType, EraType, ActionCharges, ActionRequiresOwnedTile, Gender)
select
	GreatPersonIndividualType,
	'LOC_UNIT_HD_CODIFIER_NAME',
	'GREAT_PERSON_CLASS_HD_CODIFIER',
	'ERA_ANCIENT',
	0,
	1,
	'M'
from HD_NEW_CODIFIER;

-- 编撰官 著作
insert or ignore into Types (Type, Kind)
	select GreatWorkType, 'KIND_GREATWORK' from HD_NEW_CODIFIER;

insert or ignore into GreatWorks
	(GreatWorkType, GreatWorkObjectType, GreatPersonIndividualType, Name, EraType)
select
	GreatWorkType,
	'GREATWORKOBJECT_WRITING',
	GreatPersonIndividualType,
	'LOC_' || GreatWorkType || '_NAME',
	'ERA_RENAISSANCE'
from HD_NEW_CODIFIER;

-- LA 获得槽位
insert or replace into TraitModifiers
	(TraitType,							ModifierId)
select
	'TRAIT_LEADER_SEJONG',	'HD_SEJONG_' || BuildingType || '_WRITING_SLOT'
from Buildings where PrereqDistrict = 'DISTRICT_CAMPUS' and TraitType is null and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into Modifiers
	(ModifierId,																			ModifierType)
select
	'HD_SEJONG_' || BuildingType || '_WRITING_SLOT',	'MODIFIER_PLAYER_CITIES_ADJUST_EXTRA_GREAT_WORK_SLOTS'
from Buildings where PrereqDistrict = 'DISTRICT_CAMPUS' and TraitType is null and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into ModifierArguments
	(ModifierId,																			Name,						Value)
select
	'HD_SEJONG_' || BuildingType || '_WRITING_SLOT',	'BuildingType',	BuildingType
from Buildings where PrereqDistrict = 'DISTRICT_CAMPUS' and TraitType is null and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into ModifierArguments
	(ModifierId,																			Name,									Value)
select
	'HD_SEJONG_' || BuildingType || '_WRITING_SLOT',	'GreatWorkSlotType',	'GREATWORKSLOT_WRITING'
from Buildings where PrereqDistrict = 'DISTRICT_CAMPUS' and TraitType is null and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into ModifierArguments
	(ModifierId,																			Name,						Value)
select
	'HD_SEJONG_' || BuildingType || '_WRITING_SLOT',	'Amount',				1
from Buildings where PrereqDistrict = 'DISTRICT_CAMPUS' and TraitType is null and BuildingType not in (select BuildingType from HD_DUMMY_BUILDINGS);

insert or replace into MomentIllustrations
	(MomentIllustrationType, 								MomentDataType,					GameDataType,				Texture)
values
	('MOMENT_ILLUSTRATION_UNIQUE_UNIT', 		'MOMENT_DATA_UNIT',			'UNIT_HD_CODIFIER',	'Moment_Infrastructure_Korea.dds');

--狄奥多拉la拜占庭的宠儿：圣地和跑马场建成时对相邻单元格释放文化炸弹。建成圣地时获得一个建造者，建成圣地建筑时获得一个人口。创力宗教时可以额外选取一个信条。
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_THEODORA';
insert or replace into TraitModifiers
	(TraitType,					ModifierId)
values
	-- ('TRAIT_LEADER_THEODORA',	'THEODORA_ADD_BELIEF'),
	('TRAIT_LEADER_THEODORA',	'THEODORA_DISTRICT_HOLY_SITE_CULTURE_BOMB'),
	('TRAIT_LEADER_THEODORA',	'THEODORA_DISTRICT_HIPPODROME_CULTURE_BOMB');

delete from TraitModifiers where TraitType = 'TRAIT_LEADER_THEODORA' and
	not exists (select TraitType from Traits where TraitType = 'TRAIT_LEADER_THEODORA');

insert or replace into Modifiers
	(ModifierId,										ModifierType,									SubjectRequirementSetId)
values
	('THEODORA_ADD_BELIEF',								'MODIFIER_PLAYER_ADD_BELIEF',					'PLAYER_HAS_FOUNDED_A_RELIGION'),
	('THEODORA_DISTRICT_HOLY_SITE_CULTURE_BOMB',		'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER',		NULL),
	('THEODORA_DISTRICT_HIPPODROME_CULTURE_BOMB',		'MODIFIER_PLAYER_ADD_CULTURE_BOMB_TRIGGER',		NULL),
	('THEODORA_DISTRICT_HOLY_SITE_BUILDING_GRANT_CITIZEN',		'MODIFIER_SINGLE_CITY_ADD_POPULATION',		NULL);

insert or replace into ModifierArguments
	(ModifierId,										Name,						Value)
values
	('THEODORA_DISTRICT_HOLY_SITE_CULTURE_BOMB',		'CaptureOwnedTerritory',	0),
	('THEODORA_DISTRICT_HOLY_SITE_CULTURE_BOMB',		'DistrictType',				'DISTRICT_HOLY_SITE'),
	('THEODORA_DISTRICT_HIPPODROME_CULTURE_BOMB',		'CaptureOwnedTerritory',	0),
	('THEODORA_DISTRICT_HIPPODROME_CULTURE_BOMB',		'DistrictType',				'DISTRICT_HIPPODROME'),
	('THEODORA_DISTRICT_HOLY_SITE_BUILDING_GRANT_CITIZEN',		'Amount',				1);