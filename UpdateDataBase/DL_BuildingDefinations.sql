-- 虚拟建筑记录表
create table if not exists HD_DUMMY_BUILDINGS (
	BuildingType TEXT not null,
	primary key (BuildingType)
);

-- 首都初始城墙
insert or ignore into Types
	(Type,									Kind)
values
	-- Buildings
	('BUILDING_WALLS_EARLY',				'KIND_BUILDING');

insert or replace into Buildings 
	(BuildingType, 						Name, 									Cost, 	Description,								InternalOnly,	OuterDefenseHitPoints) 
values
	('BUILDING_WALLS_EARLY', 			'LOC_BUILDING_WALLS_EARLY_NAME', 		1, 		'LOC_BUILDING_WALLS_EARLY_DESCRIPTION',		1,				25);

-- New City Center buildings
insert or ignore into Types
	(Type,										Kind)
values
	('BUILDING_NILOMETER_HD',											'KIND_BUILDING'),
	('BUILDING_TRIUMPHAL_ARCH',										'KIND_BUILDING'),
	('BUILDING_KAREZ',														'KIND_BUILDING'),
	('BUILDING_OFFICIAL_RUN_HANDCRAFT',						'KIND_BUILDING'),
	('BUILDING_BOOTCAMP',													'KIND_BUILDING'),
	('BUILDING_FAIR',															'KIND_BUILDING'),
	('BUILDING_TOTEMS',														'KIND_BUILDING'),
	('BUILDING_HD_CELLAR',												'KIND_BUILDING'),
	('BUILDING_HD_CAMPFIRE',											'KIND_BUILDING'),
	('BUILDING_HD_WHARF_RIVER',										'KIND_BUILDING'),
	('BUILDING_HD_ROYAL_COURT',										'KIND_BUILDING'),
	('BUILDING_HD_YUNSHAO_MANSION',								'KIND_BUILDING'),
	('BUILDING_HD_YUNSHAO_MANSION_INTERNAL_ONLY',	'KIND_BUILDING');

insert or replace into Buildings
	(BuildingType, 						Name, 										Cost, 		Description,										
		PrereqTech,						PrereqCivic,								PrereqDistrict,			PurchaseYield,			Housing) 
values
	-- 测量仪
	('BUILDING_NILOMETER_HD',			'LOC_BUILDING_NILOMETER_HD_NAME', 			60,			'LOC_BUILDING_NILOMETER_HD_DESCRIPTION',				
	'TECH_IRRIGATION',					null,										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			null),
	-- 凯旋门
	('BUILDING_TRIUMPHAL_ARCH',			'LOC_BUILDING_TRIUMPHAL_ARCH_NAME', 		60,			'LOC_BUILDING_TRIUMPHAL_ARCH_DESCRIPTION',			
	null,								'CIVIC_EARLY_EMPIRE',						'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			null),
	-- 坎儿井
	('BUILDING_KAREZ',					'LOC_BUILDING_KAREZ_NAME',					60,			'LOC_BUILDING_KAREZ_DESCRIPTION',	
	NULL,					'CIVIC_CRAFTSMANSHIP',										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			1),
	-- 工官
	('BUILDING_OFFICIAL_RUN_HANDCRAFT',	'LOC_BUILDING_OFFICIAL_RUN_HANDCRAFT_NAME', 60,			'LOC_BUILDING_OFFICIAL_RUN_HANDCRAFT_DESCRIPTION',	
	'TECH_MINING',						null,										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			1),
	-- 训练营
	('BUILDING_BOOTCAMP',				'LOC_BUILDING_BOOTCAMP_NAME',				40,			'LOC_BUILDING_BOOTCAMP_DESCRIPTION',	
	NULL,			'CIVIC_EARLY_WARFARE_HD',										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			null),
	-- 集市
	('BUILDING_FAIR',					'LOC_BUILDING_FAIR_NAME', 					50,			'LOC_BUILDING_FAIR_DESCRIPTION',
	null,								'CIVIC_FOREIGN_TRADE',						'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			null),
	-- 图腾柱
	('BUILDING_TOTEMS',					'LOC_BUILDING_TOTEMS_NAME', 				25,			'LOC_BUILDING_TOTEMS_DESCRIPTION',
	NULL,					'CIVIC_FUNERAL_HD',										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			null),
	-- 酒窖
	('BUILDING_HD_CELLAR',					'LOC_BUILDING_HD_CELLAR_NAME', 				60,			'LOC_BUILDING_HD_CELLAR_DESCRIPTION',
	'TECH_MASONRY',					NULL,										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			1),
	-- 营火
	('BUILDING_HD_CAMPFIRE',					'LOC_BUILDING_HD_CAMPFIRE_NAME', 				60,			'LOC_BUILDING_HD_CAMPFIRE_DESCRIPTION',
	NULL,					'CIVIC_CRAFTSMANSHIP',										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			1),
	-- 河运港市
	('BUILDING_HD_WHARF_RIVER',					'LOC_BUILDING_HD_WHARF_RIVER_NAME', 				50,			'LOC_BUILDING_HD_WHARF_RIVER_DESCRIPTION',
	NULL,					'CIVIC_FOREIGN_TRADE',										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			0),
	-- 王廷
	('BUILDING_HD_ROYAL_COURT',					'LOC_BUILDING_HD_ROYAL_COURT_NAME', 				50,			'LOC_BUILDING_HD_ROYAL_COURT_DESCRIPTION',
	NULL,					'CIVIC_CODE_OF_LAWS',										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			0),
	-- 云韶府
	('BUILDING_HD_YUNSHAO_MANSION',					'LOC_BUILDING_HD_YUNSHAO_MANSION_NAME', 				0,			'LOC_BUILDING_HD_YUNSHAO_MANSION_DESCRIPTION',
	NULL,					NULL,										'DISTRICT_CITY_CENTER',	NULL,			0),
	('BUILDING_HD_YUNSHAO_MANSION_INTERNAL_ONLY',					'LOC_BUILDING_HD_YUNSHAO_MANSION_INTERNAL_ONLY_NAME', 				0,			NULL,
	NULL,					NULL,										NULL,	NULL,			0);

update Buildings set RequiresAdjacentRiver = 1 where BuildingType = 'BUILDING_HD_WHARF_RIVER';
update Buildings set MaxPlayerInstances = 1 where BuildingType = 'BUILDING_HD_ROYAL_COURT';
update Buildings set Maintenance = 1 where BuildingType in (
	'BUILDING_NILOMETER_HD',
	'BUILDING_TRIUMPHAL_ARCH',
	'BUILDING_OFFICIAL_RUN_HANDCRAFT',
	'BUILDING_HD_CAMPFIRE'
);
update Buildings set MaxPlayerInstances = 1, MustPurchase = 1 where BuildingType = 'BUILDING_HD_YUNSHAO_MANSION';
update Buildings set InternalOnly = 1 where BuildingType = 'BUILDING_HD_YUNSHAO_MANSION_INTERNAL_ONLY';

insert or ignore into BuildingPrereqs
	(Building,															PrereqBuilding)
values
	('BUILDING_HD_ROYAL_COURT',							'BUILDING_PALACE'),
	('BUILDING_HD_YUNSHAO_MANSION',					'BUILDING_HD_YUNSHAO_MANSION_INTERNAL_ONLY');

insert or replace into MutuallyExclusiveBuildings
	(Building,								MutuallyExclusiveBuilding)
values
	('BUILDING_NILOMETER_HD',				'BUILDING_TRIUMPHAL_ARCH'),
	('BUILDING_TRIUMPHAL_ARCH',				'BUILDING_NILOMETER_HD'),

	('BUILDING_HD_WHARF_RIVER',						'BUILDING_FAIR'),
	('BUILDING_FAIR',						'BUILDING_HD_WHARF_RIVER'),

	('BUILDING_HD_CELLAR',						'BUILDING_WATER_MILL'),
	('BUILDING_WATER_MILL',						'BUILDING_HD_CELLAR');

insert or replace into Building_GreatPersonPoints
	(BuildingType,									GreatPersonClassType,							PointsPerTurn)
values
	('BUILDING_HD_YUNSHAO_MANSION',	'GREAT_PERSON_CLASS_MUSICIAN',		1);

insert or replace into Building_GreatWorks
	(BuildingType, 									GreatWorkSlotType, 			NumSlots, ThemingSameObjectType, ThemingYieldMultiplier, ThemingTourismMultiplier, ThemingBonusDescription)
values
	('BUILDING_HD_YUNSHAO_MANSION', 'GREATWORKSLOT_MUSIC', 	6,				1,										 100,										 100,											'LOC_BUILDING_THEMINGBONUS_HD_YUNSHAO_MANSION');

insert or replace into Buildings_XP2 (BuildingType, Pillage) values ('BUILDING_HD_YUNSHAO_MANSION',	0);

insert or replace into HD_DUMMY_BUILDINGS (BuildingType) values ('BUILDING_HD_YUNSHAO_MANSION'), ('BUILDING_HD_YUNSHAO_MANSION_INTERNAL_ONLY');

-- 新社区建筑
insert or ignore into Types
	(Type,																		Kind)
values
	('BUILDING_HD_ANCESTRAL_TEMPLE',	        'KIND_BUILDING'),
	('BUILDING_HD_TAVERN',										'KIND_BUILDING'),
	('BUILDING_HD_INN',												'KIND_BUILDING'),
	('BUILDING_HD_DRAMA_STAGE',								'KIND_BUILDING'),
	('BUILDING_HD_LOCAL_POLICE_STATION',			'KIND_BUILDING'),
	('BUILDING_HD_POLICE_STATION',						'KIND_BUILDING'),
	('BUILDING_HD_MANSION',										'KIND_BUILDING'),
	('BUILDING_HD_BUS_STOP',									'KIND_BUILDING'),
	('BUILDING_HD_NEWSPAPER_OFFICE',					'KIND_BUILDING'),
	('BUILDING_HD_LAW_OFFICE',								'KIND_BUILDING');

insert or ignore into Buildings
	(BuildingType,														PrereqDistrict,						PrereqCivic,															Cost,	Maintenance,	CitizenSlots,	Housing,		PurchaseYield,		AdvisorType,					Name,																						Description)
values
	('BUILDING_HD_ANCESTRAL_TEMPLE',					'DISTRICT_NEIGHBORHOOD',	'CIVIC_HOUSEHOLD_REGISTRATION_HD',				140,	1,						1,						1,					'YIELD_GOLD',			'ADVISOR_RELIGIOUS',	'LOC_BUILDING_HD_ANCESTRAL_TEMPLE_NAME',				'LOC_BUILDING_HD_ANCESTRAL_TEMPLE_DESCRIPTION'),
	('BUILDING_HD_TAVERN',										'DISTRICT_NEIGHBORHOOD',	'CIVIC_MEDIEVAL_FAIRES',									140,	1,						1,						1,					'YIELD_GOLD',			'ADVISOR_CULTURE',		'LOC_BUILDING_HD_TAVERN_NAME',									'LOC_BUILDING_HD_TAVERN_DESCRIPTION'),
	('BUILDING_HD_INN',												'DISTRICT_NEIGHBORHOOD',	'CIVIC_IMPERIAL_EXAMINATION_SYSTEM_HD',		140,	1,						1,						1,					'YIELD_GOLD',			'ADVISOR_CULTURE',		'LOC_BUILDING_HD_INN_NAME',											'LOC_BUILDING_HD_INN_DESCRIPTION'),
	('BUILDING_HD_DRAMA_STAGE',								'DISTRICT_NEIGHBORHOOD',	'CIVIC_FEUDALISM',												140,	1,						1,						1,					'YIELD_GOLD',			'ADVISOR_CULTURE',		'LOC_BUILDING_HD_DRAMA_STAGE_NAME',							'LOC_BUILDING_HD_DRAMA_STAGE_DESCRIPTION'),
	('BUILDING_HD_LOCAL_POLICE_STATION',			'DISTRICT_NEIGHBORHOOD',	'CIVIC_POLICE_SYSTEM_HD',									275,	4,						1,						0,					'YIELD_GOLD',			'ADVISOR_GENERIC',		'LOC_BUILDING_HD_LOCAL_POLICE_STATION_NAME',		'LOC_BUILDING_HD_LOCAL_POLICE_STATION_DESCRIPTION'),
	('BUILDING_HD_POLICE_STATION',						'DISTRICT_CITY_CENTER',		'CIVIC_POLICE_SYSTEM_HD',									275,	4,						0,						1,					'YIELD_GOLD',			'ADVISOR_GENERIC',		'LOC_BUILDING_HD_POLICE_STATION_NAME',					'LOC_BUILDING_HD_POLICE_STATION_DESCRIPTION'),
	('BUILDING_HD_MANSION',										'DISTRICT_NEIGHBORHOOD',	'CIVIC_COMMERCIAL_CAPITALISM_HD',					400,	7,						2,						2,					null,							'ADVISOR_GENERIC',		'LOC_BUILDING_HD_MANSION_NAME',									'LOC_BUILDING_HD_MANSION_DESCRIPTION'),
	('BUILDING_HD_BUS_STOP',									'DISTRICT_NEIGHBORHOOD',	'CIVIC_URBANIZATION',											220,	4,						1,						0,					'YIELD_GOLD',			'ADVISOR_GENERIC',		'LOC_BUILDING_HD_BUS_STOP_NAME',								'LOC_BUILDING_HD_BUS_STOP_DESCRIPTION'),
	('BUILDING_HD_NEWSPAPER_OFFICE',					'DISTRICT_NEIGHBORHOOD',	'CIVIC_JOURNALISM_STUDIES_HD',						160,	4,						1,						0,					'YIELD_GOLD',			'ADVISOR_CULTURE',		'LOC_BUILDING_HD_NEWSPAPER_OFFICE_NAME',				'LOC_BUILDING_HD_NEWSPAPER_OFFICE_DESCRIPTION'),
	('BUILDING_HD_LAW_OFFICE',								'DISTRICT_NEIGHBORHOOD',	'CIVIC_LAW_HD',														160,	4,						1,						0,					'YIELD_GOLD',			'ADVISOR_GENERIC',		'LOC_BUILDING_HD_LAW_OFFICE_NAME',							null);
update Buildings set MaxPlayerInstances = 1 where BuildingType = 'BUILDING_HD_MANSION';
update Buildings set RegionalRange = 6 where BuildingType = 'BUILDING_HD_LAW_OFFICE';

insert or ignore into MutuallyExclusiveBuildings
	(Building,																MutuallyExclusiveBuilding)
values
	('BUILDING_HD_ANCESTRAL_TEMPLE',					'BUILDING_HD_TAVERN'),
	('BUILDING_HD_ANCESTRAL_TEMPLE',					'BUILDING_HD_INN'),
	('BUILDING_HD_ANCESTRAL_TEMPLE',					'BUILDING_HD_DRAMA_STAGE'),
	('BUILDING_HD_TAVERN',										'BUILDING_HD_INN'),
	('BUILDING_HD_TAVERN',										'BUILDING_HD_DRAMA_STAGE'),
	('BUILDING_HD_TAVERN',										'BUILDING_HD_ANCESTRAL_TEMPLE'),
	('BUILDING_HD_INN',												'BUILDING_HD_TAVERN'),
	('BUILDING_HD_INN',												'BUILDING_HD_DRAMA_STAGE'),
	('BUILDING_HD_INN',												'BUILDING_HD_ANCESTRAL_TEMPLE'),
	('BUILDING_HD_DRAMA_STAGE',								'BUILDING_HD_TAVERN'),
	('BUILDING_HD_DRAMA_STAGE',								'BUILDING_HD_INN'),
	('BUILDING_HD_DRAMA_STAGE',								'BUILDING_HD_ANCESTRAL_TEMPLE'),
	('BUILDING_HD_LOCAL_POLICE_STATION',			'BUILDING_HD_POLICE_STATION'),
	('BUILDING_HD_POLICE_STATION',						'BUILDING_HD_LOCAL_POLICE_STATION'),
	('BUILDING_HD_MANSION',										'BUILDING_HD_NEWSPAPER_OFFICE'),
	('BUILDING_HD_MANSION',										'BUILDING_HD_LAW_OFFICE'),
	('BUILDING_HD_NEWSPAPER_OFFICE',					'BUILDING_HD_MANSION'),
	('BUILDING_HD_NEWSPAPER_OFFICE',					'BUILDING_HD_LAW_OFFICE'),
	('BUILDING_HD_LAW_OFFICE',								'BUILDING_HD_MANSION'),
	('BUILDING_HD_LAW_OFFICE',								'BUILDING_HD_NEWSPAPER_OFFICE');

insert or ignore into BuildingPrereqs
	(Building,															PrereqBuilding)
values
	('BUILDING_FOOD_MARKET',								'BUILDING_HD_ANCESTRAL_TEMPLE'),
	('BUILDING_FOOD_MARKET',								'BUILDING_HD_TAVERN'),
	('BUILDING_FOOD_MARKET',								'BUILDING_HD_INN'),
	('BUILDING_FOOD_MARKET',								'BUILDING_HD_DRAMA_STAGE'),
	('BUILDING_FOOD_MARKET',								'BUILDING_HD_LOCAL_POLICE_STATION'),
	('BUILDING_SHOPPING_MALL',							'BUILDING_HD_ANCESTRAL_TEMPLE'),
	('BUILDING_SHOPPING_MALL',							'BUILDING_HD_TAVERN'),
	('BUILDING_SHOPPING_MALL',							'BUILDING_HD_INN'),
	('BUILDING_SHOPPING_MALL',							'BUILDING_HD_DRAMA_STAGE'),
	('BUILDING_SHOPPING_MALL',							'BUILDING_HD_LOCAL_POLICE_STATION'),
	('BUILDING_HD_MANSION',									'BUILDING_PALACE'),
	('BUILDING_HD_NEWSPAPER_OFFICE',				'BUILDING_HD_ANCESTRAL_TEMPLE'),
	('BUILDING_HD_NEWSPAPER_OFFICE',				'BUILDING_HD_TAVERN'),
	('BUILDING_HD_NEWSPAPER_OFFICE',				'BUILDING_HD_INN'),
	('BUILDING_HD_NEWSPAPER_OFFICE',				'BUILDING_HD_DRAMA_STAGE'),
	('BUILDING_HD_NEWSPAPER_OFFICE',				'BUILDING_HD_LOCAL_POLICE_STATION'),
	('BUILDING_HD_LAW_OFFICE',							'BUILDING_HD_ANCESTRAL_TEMPLE'),
	('BUILDING_HD_LAW_OFFICE',							'BUILDING_HD_TAVERN'),
	('BUILDING_HD_LAW_OFFICE',							'BUILDING_HD_INN'),
	('BUILDING_HD_LAW_OFFICE',							'BUILDING_HD_DRAMA_STAGE'),
	('BUILDING_HD_LAW_OFFICE',							'BUILDING_HD_LOCAL_POLICE_STATION'),
	('BUILDING_HD_BUS_STOP',								'BUILDING_HD_ANCESTRAL_TEMPLE'),
	('BUILDING_HD_BUS_STOP',								'BUILDING_HD_TAVERN'),
	('BUILDING_HD_BUS_STOP',								'BUILDING_HD_INN'),
	('BUILDING_HD_BUS_STOP',								'BUILDING_HD_DRAMA_STAGE'),
	('BUILDING_HD_BUS_STOP',								'BUILDING_HD_LOCAL_POLICE_STATION');

insert or replace into Building_GreatPersonPoints
	(BuildingType,								GreatPersonClassType,							PointsPerTurn)
values
	('BUILDING_HD_TAVERN',				'GREAT_PERSON_CLASS_ARTIST',			1),
	('BUILDING_HD_INN',						'GREAT_PERSON_CLASS_WRITER',			1),
	('BUILDING_HD_DRAMA_STAGE',		'GREAT_PERSON_CLASS_MUSICIAN',		1);

insert or replace into Building_GreatWorks
	(BuildingType,													GreatWorkSlotType,						NumSlots)
values
	('BUILDING_HD_ANCESTRAL_TEMPLE',				'GREATWORKSLOT_RELIC',				1),
	('BUILDING_HD_TAVERN',									'GREATWORKSLOT_ART',					2),
	('BUILDING_HD_INN',											'GREATWORKSLOT_WRITING',			2),
	('BUILDING_HD_DRAMA_STAGE',							'GREATWORKSLOT_MUSIC',				2),
	('BUILDING_HD_MANSION',									'GREATWORKSLOT_WRITING',			3),
	('BUILDING_HD_NEWSPAPER_OFFICE',				'GREATWORKSLOT_WRITING',			1),
	('BUILDING_HD_LAW_OFFICE',							'GREATWORKSLOT_WRITING',			1);

-- 新学院建筑
insert or ignore into Types
	(Type,																		Kind)
values
	('BUILDING_HD_AGRICULTURE_COLLEGE',	      'KIND_BUILDING'),
	('BUILDING_HD_FINANCE_COLLEGE',						'KIND_BUILDING'),
	('BUILDING_HD_DATA_CENTER',								'KIND_BUILDING');

insert or ignore into Buildings
	(BuildingType,														PrereqDistrict,			PrereqTech,											PrereqCivic,				  Cost,	Maintenance,	CitizenSlots,	PurchaseYield,		AdvisorType,						Name,																						Description)
values
	('BUILDING_HD_AGRICULTURE_COLLEGE',			  'DISTRICT_CAMPUS',	'TECH_MODERN_AGRICULTURE_HD',		null,									900,	10,						1,						'YIELD_GOLD',			'ADVISOR_TECHNOLOGY',		'LOC_BUILDING_HD_AGRICULTURE_COLLEGE_NAME',			'LOC_BUILDING_HD_AGRICULTURE_COLLEGE_DESCRIPTION'),
	('BUILDING_HD_FINANCE_COLLEGE',						'DISTRICT_CAMPUS',	null,														'CIVIC_FINANCE_HD',		900,	10,						1,						'YIELD_GOLD',			'ADVISOR_TECHNOLOGY',		'LOC_BUILDING_HD_FINANCE_COLLEGE_NAME',					'LOC_BUILDING_HD_FINANCE_COLLEGE_DESCRIPTION'),
	('BUILDING_HD_DATA_CENTER',								'DISTRICT_CAMPUS',	'TECH_BIG_DATA_HD',							null,									1200,	10,						4,						'YIELD_GOLD',			'ADVISOR_TECHNOLOGY',		'LOC_BUILDING_HD_DATA_CENTER_NAME',							'LOC_BUILDING_HD_DATA_CENTER_DESCRIPTION');
update Buildings set MaxPlayerInstances = 1 where BuildingType = 'BUILDING_HD_DATA_CENTER';
update Buildings set PrereqTech = 'TECH_MEDICAL_SCIENCE_HD', Name = 'LOC_BUILDING_HD_AGRICULTURE_COLLEGE_NAME_C', Description = 'LOC_BUILDING_HD_AGRICULTURE_COLLEGE_DESCRIPTION_C'
	where BuildingType = 'BUILDING_HD_AGRICULTURE_COLLEGE'
	and exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');

insert or ignore into MutuallyExclusiveBuildings
	(Building,																MutuallyExclusiveBuilding)
values
	('BUILDING_HD_AGRICULTURE_COLLEGE',				'BUILDING_HD_FINANCE_COLLEGE'),
	('BUILDING_HD_FINANCE_COLLEGE',						'BUILDING_HD_AGRICULTURE_COLLEGE');

insert or ignore into BuildingPrereqs
	(Building,																PrereqBuilding)
values
	('BUILDING_HD_AGRICULTURE_COLLEGE',				'BUILDING_RESEARCH_LAB'),
	('BUILDING_HD_FINANCE_COLLEGE',						'BUILDING_RESEARCH_LAB'),
	('BUILDING_HD_DATA_CENTER',								'BUILDING_HD_FINANCE_COLLEGE'),
	('BUILDING_HD_DATA_CENTER',								'BUILDING_HD_AGRICULTURE_COLLEGE');

insert or replace into Building_GreatPersonPoints
	(BuildingType,														GreatPersonClassType,							PointsPerTurn)
values
	('BUILDING_HD_AGRICULTURE_COLLEGE',				'GREAT_PERSON_CLASS_SCIENTIST',		1),
	('BUILDING_HD_FINANCE_COLLEGE',						'GREAT_PERSON_CLASS_SCIENTIST',		1),
	('BUILDING_HD_DATA_CENTER',								'GREAT_PERSON_CLASS_SCIENTIST',		1);

insert or ignore into Buildings_XP2
	(BuildingType,                  					RequiredPower)
values
	('BUILDING_HD_AGRICULTURE_COLLEGE',				5),
	('BUILDING_HD_FINANCE_COLLEGE',						5),
	('BUILDING_HD_DATA_CENTER',								10);

-- 新娱乐区建筑
insert or ignore into Types
	(Type,																		Kind)
values
	('BUILDING_HD_CIRCUS',	        					'KIND_BUILDING'),
	('BUILDING_HD_JEWELRY_SHOP',							'KIND_BUILDING');

insert or ignore into Buildings
	(BuildingType,								PrereqDistrict,										PrereqCivic,				  							Cost,	Maintenance,	Entertainment,	PurchaseYield,		AdvisorType,					RegionalRange,	Name,																	Description)
values
	('BUILDING_HD_CIRCUS',			  'DISTRICT_ENTERTAINMENT_COMPLEX',	'CIVIC_COMMERCIAL_CAPITALISM_HD',		360,	4,						2,							'YIELD_GOLD',			'ADVISOR_GENERIC',		6,							'LOC_BUILDING_HD_CIRCUS_NAME',				'LOC_BUILDING_HD_CIRCUS_DESCRIPTION'),
	('BUILDING_HD_JEWELRY_SHOP',	'DISTRICT_ENTERTAINMENT_COMPLEX',	'CIVIC_COMMERCIAL_CAPITALISM_HD',		360,	4,						2,							'YIELD_GOLD',			'ADVISOR_GENERIC',		0,							'LOC_BUILDING_HD_JEWELRY_SHOP_NAME',	'LOC_BUILDING_HD_JEWELRY_SHOP_DESCRIPTION');

insert or ignore into MutuallyExclusiveBuildings
	(Building,										MutuallyExclusiveBuilding)
values
	('BUILDING_ZOO',							'BUILDING_HD_CIRCUS'),
	('BUILDING_ZOO',							'BUILDING_HD_JEWELRY_SHOP'),
	('BUILDING_HD_CIRCUS',				'BUILDING_ZOO'),
	('BUILDING_HD_CIRCUS',				'BUILDING_HD_JEWELRY_SHOP'),
	('BUILDING_HD_JEWELRY_SHOP',	'BUILDING_HD_CIRCUS'),
	('BUILDING_HD_JEWELRY_SHOP',	'BUILDING_ZOO');

insert or ignore into BuildingPrereqs
	(Building,										PrereqBuilding)
values
	('BUILDING_HD_CIRCUS',				'BUILDING_ARENA'),
	('BUILDING_HD_JEWELRY_SHOP',	'BUILDING_ARENA'),
	('BUILDING_STADIUM',					'BUILDING_HD_CIRCUS'),
	('BUILDING_STADIUM',					'BUILDING_HD_JEWELRY_SHOP');

-- 新圣地建筑
insert or ignore into Types
	(Type,																		Kind)
values
	('BUILDING_HD_ALCHEMY_ROOM',	        		'KIND_BUILDING');

insert or ignore into Buildings
	(BuildingType,								PrereqDistrict,				PrereqTech,				  	Cost,	Maintenance,	CitizenSlots,	PurchaseYield,		AdvisorType,					Name,																	Description)
values
	('BUILDING_HD_ALCHEMY_ROOM',	'DISTRICT_HOLY_SITE',	'TECH_ALCHEMY_HD',		140,	2,						1,						'YIELD_GOLD',			'ADVISOR_RELIGIOUS',	'LOC_BUILDING_HD_ALCHEMY_ROOM_NAME',	'LOC_BUILDING_HD_ALCHEMY_ROOM_DESCRIPTION');

insert or ignore into MutuallyExclusiveBuildings
	(Building,										MutuallyExclusiveBuilding)
values
	('BUILDING_HD_ALCHEMY_ROOM',	'BUILDING_TEMPLE'),
	('BUILDING_TEMPLE',						'BUILDING_HD_ALCHEMY_ROOM');

insert or ignore into MutuallyExclusiveBuildings
	(Building,										MutuallyExclusiveBuilding)
select
	'BUILDING_HD_ALCHEMY_ROOM',		'BUILDING_STAVE_CHURCH'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_STAVE_CHURCH');

insert or ignore into MutuallyExclusiveBuildings
	(Building,										MutuallyExclusiveBuilding)
select
	'BUILDING_STAVE_CHURCH',			'BUILDING_HD_ALCHEMY_ROOM'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_STAVE_CHURCH');

insert or ignore into MutuallyExclusiveBuildings
	(Building,										MutuallyExclusiveBuilding)
select
	'BUILDING_PRASAT',						'BUILDING_HD_ALCHEMY_ROOM'
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_PRASAT');

insert or ignore into BuildingPrereqs
	(Building,										PrereqBuilding)
values
	('BUILDING_HD_ALCHEMY_ROOM',	'BUILDING_SHRINE');

insert or ignore into BuildingPrereqs
	(Building,	PrereqBuilding)
select
	Building,		'BUILDING_HD_ALCHEMY_ROOM'
from BuildingPrereqs where PrereqBuilding = 'BUILDING_TEMPLE';

insert or replace into Building_GreatPersonPoints
	(BuildingType,											GreatPersonClassType,							PointsPerTurn)
values
	('BUILDING_HD_ALCHEMY_ROOM',				'GREAT_PERSON_CLASS_PROPHET',			1),
	('BUILDING_HD_ALCHEMY_ROOM',				'GREAT_PERSON_CLASS_SCIENTIST',		1);

insert or replace into Building_GreatWorks
	(BuildingType,										GreatWorkSlotType,						NumSlots)
values
	('BUILDING_HD_ALCHEMY_ROOM',			'GREATWORKSLOT_WRITING',			1);

-- 西班牙LB
insert or ignore into Types
	(Type,																					Kind)
values
	('BUILDING_EL_ESCORIAL_PALACE',									'KIND_BUILDING'),
	('TRAIT_LEADER_BUILDING_EL_ESCORIAL_PALACE',		'KIND_TRAIT');

insert or ignore into Traits
	(TraitType,																		Name)
values
	('TRAIT_LEADER_BUILDING_EL_ESCORIAL_PALACE',	'LOC_BUILDING_EL_ESCORIAL_PALACE_NAME');

insert or replace into LeaderTraits
	(LeaderType,							TraitType)
values
	('LEADER_PHILIP_II',			'TRAIT_LEADER_BUILDING_EL_ESCORIAL_PALACE');

insert or ignore into Buildings
	(BuildingType, Name, Description, PrereqDistrict, Cost, Maintenance, TraitType, AdvisorType, UnlocksGovernmentPolicy, GovernmentTierRequirement)
values
	('BUILDING_EL_ESCORIAL_PALACE',	'LOC_BUILDING_EL_ESCORIAL_PALACE_NAME', 'LOC_BUILDING_EL_ESCORIAL_PALACE_DESCRIPTION',
	'DISTRICT_GOVERNMENT', 150, 1, 
	'TRAIT_LEADER_BUILDING_EL_ESCORIAL_PALACE', 'ADVISOR_GENERIC', 1, 'Tier1');

insert or replace into Building_GreatPersonPoints
	(BuildingType,										GreatPersonClassType,							PointsPerTurn)
values
	('BUILDING_EL_ESCORIAL_PALACE',		'GREAT_PERSON_CLASS_PROPHET',			1),
	('BUILDING_EL_ESCORIAL_PALACE',		'GREAT_PERSON_CLASS_WRITER',			1),
	('BUILDING_EL_ESCORIAL_PALACE',		'GREAT_PERSON_CLASS_ARTIST',			1);

insert or replace into Building_GreatWorks
	(BuildingType,										GreatWorkSlotType,						NumSlots)
values
	('BUILDING_EL_ESCORIAL_PALACE',		'GREATWORKSLOT_RELIC',				2),
	('BUILDING_EL_ESCORIAL_PALACE',		'GREATWORKSLOT_WRITING',			2),
	('BUILDING_EL_ESCORIAL_PALACE',		'GREATWORKSLOT_ART',					2);

insert or replace into MomentIllustrations
	(MomentIllustrationType, 								MomentDataType,					GameDataType,										Texture)
values
	('MOMENT_ILLUSTRATION_UNIQUE_BUILDING', 'MOMENT_DATA_BUILDING',	'BUILDING_EL_ESCORIAL_PALACE',	'BUILDING_EL_ESCORIAL_PALACE_MOMENT.dds');

-- 电子厂 & 互联网公司
	-- 删除原版电子厂
update Buildings set InternalOnly = 1, PrereqTech = null, TraitType = null, RegionalRange = 0 where BuildingType = 'BUILDING_ELECTRONICS_FACTORY';
delete from BuildingReplaces where CivUniqueBuildingType = 'BUILDING_ELECTRONICS_FACTORY';
delete from Building_YieldChangesBonusWithPower where BuildingType = 'BUILDING_ELECTRONICS_FACTORY';
delete from BuildingModifiers where BuildingType = 'BUILDING_ELECTRONICS_FACTORY';
delete from MomentIllustrations where GameDataType = 'BUILDING_ELECTRONICS_FACTORY';

	-- 定义新建筑
insert or ignore into Types
	(Type,																					Kind)
values
	('BUILDING_HD_ELECTRONICS_FACTORY',							'KIND_BUILDING'),
	('BUILDING_HD_INTERNET_COMPANY',								'KIND_BUILDING');

insert or replace into Buildings
	(BuildingType,                      PrereqDistrict,             PrereqTech,         Cost, Maintenance, CitizenSlots, PurchaseYield, AdvisorType,       Name,                                       Description)
values
	('BUILDING_HD_ELECTRONICS_FACTORY', 'DISTRICT_INDUSTRIAL_ZONE', 'TECH_ELECTRICITY',	400,	7,					 1,						 'YIELD_GOLD',  'ADVISOR_GENERIC', 'LOC_BUILDING_HD_ELECTRONICS_FACTORY_NAME', 'LOC_BUILDING_HD_ELECTRONICS_FACTORY_DESCRIPTION'),
	('BUILDING_HD_INTERNET_COMPANY', 		'DISTRICT_INDUSTRIAL_ZONE', 'TECH_INTERNET_HD',	600,	10,					 1,						 'YIELD_GOLD',  'ADVISOR_CULTURE', 'LOC_BUILDING_HD_INTERNET_COMPANY_NAME',    'LOC_BUILDING_HD_INTERNET_COMPANY_DESCRIPTION');

update Buildings set Description = 'LOC_BUILDING_HD_INTERNET_COMPANY_MONOPOLY_DESCRIPTION'
	where BuildingType = 'BUILDING_HD_INTERNET_COMPANY' and exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

insert or replace into MutuallyExclusiveBuildings
	(Building,													MutuallyExclusiveBuilding)
values
	('BUILDING_FACTORY',								'BUILDING_HD_ELECTRONICS_FACTORY'),
	('BUILDING_HD_ELECTRONICS_FACTORY',	'BUILDING_FACTORY'),

	('BUILDING_HD_INTERNET_COMPANY',		'BUILDING_COAL_POWER_PLANT'),
	('BUILDING_HD_INTERNET_COMPANY',		'BUILDING_FOSSIL_FUEL_POWER_PLANT'),
	('BUILDING_HD_INTERNET_COMPANY',		'BUILDING_POWER_PLANT'),
	('BUILDING_COAL_POWER_PLANT',				'BUILDING_HD_INTERNET_COMPANY'),
	('BUILDING_FOSSIL_FUEL_POWER_PLANT','BUILDING_HD_INTERNET_COMPANY'),
	('BUILDING_POWER_PLANT',						'BUILDING_HD_INTERNET_COMPANY');

insert or replace into Building_YieldChanges
	(BuildingType,											YieldType,					YieldChange)
values
	('BUILDING_HD_ELECTRONICS_FACTORY',	'YIELD_SCIENCE',		2),
	('BUILDING_HD_ELECTRONICS_FACTORY',	'YIELD_CULTURE',		2),
	('BUILDING_HD_ELECTRONICS_FACTORY',	'YIELD_PRODUCTION',	2),
	('BUILDING_HD_INTERNET_COMPANY',		'YIELD_SCIENCE',		5),
	('BUILDING_HD_INTERNET_COMPANY',		'YIELD_CULTURE',		5);

insert or replace into BuildingPrereqs
	(Building,													PrereqBuilding)
values
	('BUILDING_HD_ELECTRONICS_FACTORY',	'BUILDING_WORKSHOP'),
	('BUILDING_COAL_POWER_PLANT',				'BUILDING_HD_ELECTRONICS_FACTORY'),
	('BUILDING_FOSSIL_FUEL_POWER_PLANT','BUILDING_HD_ELECTRONICS_FACTORY'),
	('BUILDING_POWER_PLANT',						'BUILDING_HD_ELECTRONICS_FACTORY'),
	('BUILDING_HD_INTERNET_COMPANY',		'BUILDING_FACTORY'),
	('BUILDING_HD_INTERNET_COMPANY',		'BUILDING_HD_ELECTRONICS_FACTORY'),
	('BUILDING_RUHR_VALLEY',						'BUILDING_HD_ELECTRONICS_FACTORY');

insert or replace into Building_CitizenYieldChanges
	(BuildingType,                  			YieldType,          YieldChange)
values
	('BUILDING_HD_ELECTRONICS_FACTORY',   'YIELD_PRODUCTION', 1),
	('BUILDING_HD_ELECTRONICS_FACTORY',   'YIELD_GOLD',       -1),
	('BUILDING_HD_INTERNET_COMPANY',   		'YIELD_PRODUCTION', 1),
	('BUILDING_HD_INTERNET_COMPANY',   		'YIELD_SCIENCE',    1),
	('BUILDING_HD_INTERNET_COMPANY',   		'YIELD_CULTURE',    1),
	('BUILDING_HD_INTERNET_COMPANY',   		'YIELD_GOLD',       -1);

-- 伟人点
insert or replace into Building_GreatPersonPoints
	(BuildingType,													GreatPersonClassType,							PointsPerTurn)
values
	('BUILDING_HD_ELECTRONICS_FACTORY',     'GREAT_PERSON_CLASS_ENGINEER',		1),
	('BUILDING_HD_INTERNET_COMPANY',     		'GREAT_PERSON_CLASS_ENGINEER',		1);

-- 巨作槽位
insert or replace into Building_GreatWorks
	(BuildingType,										GreatWorkSlotType,				NumSlots)
select
    'BUILDING_HD_INTERNET_COMPANY', 'GREATWORKSLOT_PRODUCT',  3
where exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');

-- 耗电
insert or replace into Buildings_XP2
  (BuildingType,                          RequiredPower)
values
	('BUILDING_HD_ELECTRONICS_FACTORY',     2),
	('BUILDING_HD_INTERNET_COMPANY',        5);

-- 日本UB
insert or ignore into Types
	(Type,																					Kind)
values
	('BUILDING_HD_PIT_DWELLING',										'KIND_BUILDING');

insert or replace into Buildings
	(BuildingType, 						Name, 										Cost, 		Description,										
		PrereqTech,						PrereqCivic,								PrereqDistrict,			PurchaseYield,			Housing, 			TraitType) 
values
	('BUILDING_HD_PIT_DWELLING',			'LOC_BUILDING_HD_PIT_DWELLING_NAME', 			70,			'LOC_BUILDING_HD_PIT_DWELLING_DESCRIPTION',				
	'TECH_ANIMAL_HUSBANDRY',					null,										'DISTRICT_CITY_CENTER',	'YIELD_GOLD',			2,			'TRAIT_CIVILIZATION_BUILDING_ELECTRONICS_FACTORY');

update Traits set Name = 'LOC_BUILDING_HD_PIT_DWELLING_NAME' where TraitType = 'TRAIT_CIVILIZATION_BUILDING_ELECTRONICS_FACTORY';

insert or replace into MutuallyExclusiveBuildings
	(Building,											MutuallyExclusiveBuilding)
values
	('BUILDING_HD_PIT_DWELLING',		'BUILDING_KAREZ'),
	('BUILDING_KAREZ',							'BUILDING_HD_PIT_DWELLING');

-- 如果存在JNR道场，则竖穴坑居下放通用建筑
update Buildings set TraitType = null, Housing = 1, Cost = 60, Description = 'LOC_BUILDING_HD_PIT_DWELLING_COMMON_DESCRIPTION'
	where BuildingType = 'BUILDING_HD_PIT_DWELLING' and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_JNR_DOJO');
delete from CivilizationTraits where CivilizationType = 'CIVILIZATION_JAPAN' and TraitType = 'TRAIT_CIVILIZATION_BUILDING_ELECTRONICS_FACTORY'
	and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_JNR_DOJO');

insert or replace into MomentIllustrations
	(MomentIllustrationType, 								MomentDataType,					GameDataType,				        Texture)
select
	'MOMENT_ILLUSTRATION_UNIQUE_BUILDING', 	'MOMENT_DATA_BUILDING',	'BUILDING_HD_PIT_DWELLING',	'BUILDING_HD_PIT_DWELLING_MONMENT.dds'
where not exists (select BuildingType from Buildings where BuildingType = 'BUILDING_JNR_DOJO');

-- 酒窖与水磨UB互斥
insert or replace into MutuallyExclusiveBuildings
	(Building,								MutuallyExclusiveBuilding)
select
	CivUniqueBuildingType,		'BUILDING_HD_CELLAR'
from BuildingReplaces where ReplacesBuildingType = 'BUILDING_WATER_MILL';

-- 李裪书院额外1著作槽位
insert or ignore into Types
	(Type,																					Kind)
select
	'BUILDING_SEOWON',															'KIND_BUILDING'
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or ignore into Types
	(Type,																					Kind)
select
	'BUILDING_SEOWON_INTERNAL_ONLY',								'KIND_BUILDING'
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or ignore into Types
	(Type,																					Kind)
select
	'TRAIT_LEADER_SEJONG_BUILDING_SEOWON',					'KIND_TRAIT'
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or ignore into Traits
	(TraitType,																		Name)
select
	'TRAIT_LEADER_SEJONG_BUILDING_SEOWON',				'LOC_TRAIT_LEADER_SEJONG_BUILDING_SEOWON_NAME'
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or replace into LeaderTraits
	(LeaderType,							TraitType)
select
	'LEADER_SEJONG',					'TRAIT_LEADER_SEJONG_BUILDING_SEOWON'
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or ignore into Buildings
	(BuildingType, Name, Description, PrereqDistrict, Cost, Maintenance, TraitType, AdvisorType, MustPurchase)
select
	'BUILDING_SEOWON',	'LOC_BUILDING_SEOWON_NAME', 'LOC_BUILDING_SEOWON_DESCRIPTION',
	'DISTRICT_CAMPUS', 0, 0, 
	'TRAIT_LEADER_SEJONG_BUILDING_SEOWON', 'ADVISOR_GENERIC', 1
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or ignore into Buildings
	(BuildingType,										Cost,	Name,																			InternalOnly)
select
	'BUILDING_SEOWON_INTERNAL_ONLY',	0,		'LOC_BUILDING_SEOWON_INTERNAL_ONLY_NAME', 1
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or replace into BuildingPrereqs
	(Building,					PrereqBuilding)
select
	'BUILDING_SEOWON',	'BUILDING_SEOWON_INTERNAL_ONLY'
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or replace into Buildings_XP2
	(BuildingType,			Pillage)
select
	'BUILDING_SEOWON',	0
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or replace into Building_GreatWorks
	(BuildingType,				GreatWorkSlotType,				NumSlots)
select
	'BUILDING_SEOWON',		'GREATWORKSLOT_WRITING',	1
where exists (select LeaderType from Leaders where LeaderType = 'LEADER_SEJONG');

insert or replace into HD_DUMMY_BUILDINGS (BuildingType) select BuildingType
	from Buildings where BuildingType in ('BUILDING_SEOWON', 'BUILDING_SEOWON_INTERNAL_ONLY');

-- 新政府区/外交区建筑
insert or ignore into Types
	(Type,								                        			Kind)
values
	('BUILDING_HD_REGIONAL_COUNCIL_CENTER',		          'KIND_BUILDING'),
	('BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',	      'KIND_BUILDING'),
	('BUILDING_HD_HUMAN_RIGHTS_COUNCIL',		            'KIND_BUILDING'),
	('BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE',	      'KIND_BUILDING'),
	-- 特质
	('TRAIT_CIVILIZATION_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',	'KIND_TRAIT');

insert or ignore into Traits
	(TraitType, 																										Name,																																			Description)
values
	('TRAIT_CIVILIZATION_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS', 'LOC_TRAIT_CIVILIZATION_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_NAME', 'LOC_TRAIT_CIVILIZATION_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_DESCRIPTION');

insert or ignore into CivilizationTraits
	(CivilizationType,          TraitType)
values
	('CIVILIZATION_AMERICA',    'TRAIT_CIVILIZATION_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS');

insert or ignore into Buildings
	(BuildingType,			                        				PrereqDistrict,				    PrereqCivic,											Cost,	Maintenance,    PurchaseYield,		AdvisorType,					Name,								                    									Description)
values
	('BUILDING_HD_REGIONAL_COUNCIL_CENTER',	        		'DISTRICT_GOVERNMENT',		'CIVIC_LEAGUE_OF_NATIONS_HD',			600,	7,							null,							'ADVISOR_GENERIC',		'LOC_BUILDING_HD_REGIONAL_COUNCIL_CENTER_NAME',		    		'LOC_BUILDING_HD_REGIONAL_COUNCIL_CENTER_DESCRIPTION'),
	('BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',				'DISTRICT_GOVERNMENT',		'CIVIC_SCORCHED_EARTH',						600,	7,							null,							'ADVISOR_GENERIC',		'LOC_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_NAME',			'LOC_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_DESCRIPTION'),
	('BUILDING_HD_HUMAN_RIGHTS_COUNCIL',	        			'DISTRICT_GOVERNMENT',		'CIVIC_HUMAN_RIGHTS_HD',					600,	7,							null,							'ADVISOR_CULTURE',		'LOC_BUILDING_HD_HUMAN_RIGHTS_COUNCIL_NAME',		    			'LOC_BUILDING_HD_HUMAN_RIGHTS_COUNCIL_DESCRIPTION'),
	('BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE',				'DISTRICT_GOVERNMENT',		'CIVIC_SCORCHED_EARTH',						600,	7,							null,							'ADVISOR_CONQUEST',		'LOC_BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSES_NAME',			'LOC_BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE_DESCRIPTION');
update Buildings set TraitType = 'TRAIT_CIVILIZATION_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS' where BuildingType = 'BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS';

insert or ignore into BuildingPrereqs
	(Building, 																					PrereqBuilding)
values
	('BUILDING_HD_REGIONAL_COUNCIL_CENTER',							'BUILDING_GOV_CITYSTATES'),
	('BUILDING_HD_REGIONAL_COUNCIL_CENTER',							'BUILDING_GOV_SPIES'),
	('BUILDING_HD_REGIONAL_COUNCIL_CENTER',							'BUILDING_GOV_FAITH'),
	('BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',				'BUILDING_GOV_CITYSTATES'),
	('BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',				'BUILDING_GOV_SPIES'),
	('BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',				'BUILDING_GOV_FAITH'),
	('BUILDING_HD_HUMAN_RIGHTS_COUNCIL',								'BUILDING_GOV_CITYSTATES'),
	('BUILDING_HD_HUMAN_RIGHTS_COUNCIL',								'BUILDING_GOV_SPIES'),
	('BUILDING_HD_HUMAN_RIGHTS_COUNCIL',								'BUILDING_GOV_FAITH'),
	('BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE',				'BUILDING_GOV_CITYSTATES'),
	('BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE',				'BUILDING_GOV_SPIES'),
	('BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE',				'BUILDING_GOV_FAITH');

insert or replace into MutuallyExclusiveBuildings
	(Building,																					MutuallyExclusiveBuilding)
values
	('BUILDING_HD_REGIONAL_COUNCIL_CENTER',							'BUILDING_HD_HUMAN_RIGHTS_COUNCIL'),
	('BUILDING_HD_REGIONAL_COUNCIL_CENTER',							'BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE'),
	('BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',				'BUILDING_HD_HUMAN_RIGHTS_COUNCIL'),
	('BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',				'BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE'),
	('BUILDING_HD_HUMAN_RIGHTS_COUNCIL',								'BUILDING_HD_REGIONAL_COUNCIL_CENTER'),
	('BUILDING_HD_HUMAN_RIGHTS_COUNCIL',								'BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE'),
	('BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE',				'BUILDING_HD_REGIONAL_COUNCIL_CENTER'),
	('BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE',				'BUILDING_HD_HUMAN_RIGHTS_COUNCIL');

insert or ignore into BuildingReplaces
	(CivUniqueBuildingType,												ReplacesBuildingType)
values
	('BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',	'BUILDING_HD_REGIONAL_COUNCIL_CENTER');

-- 开启外交区则改为外交区建筑
update Buildings set PrereqDistrict = 'DISTRICT_DIPLOMATIC_QUARTER' where BuildingType in (
	'BUILDING_HD_REGIONAL_COUNCIL_CENTER',
	'BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',
	'BUILDING_HD_HUMAN_RIGHTS_COUNCIL',
	'BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE'
) and exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

delete from BuildingPrereqs where Building in (
	'BUILDING_HD_REGIONAL_COUNCIL_CENTER',
	'BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',
	'BUILDING_HD_HUMAN_RIGHTS_COUNCIL',
	'BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE'
) and exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into BuildingPrereqs
	(Building, PrereqBuilding)
select
	BuildingType, 'BUILDING_CHANCERY'
from Buildings where BuildingType in (
	'BUILDING_HD_REGIONAL_COUNCIL_CENTER',
	'BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS',
	'BUILDING_HD_HUMAN_RIGHTS_COUNCIL',
	'BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE'
) and exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');
update Buildings set MaxPlayerInstances = 1 where PrereqDistrict = 'DISTRICT_DIPLOMATIC_QUARTER';
update Buildings set MaxPlayerInstances = 3 where BuildingType in ('BUILDING_CONSULATE', 'BUILDING_CHANCERY');

-- 伊斯兰大学
delete from BuildingReplaces where CivUniqueBuildingType = 'BUILDING_MADRASA';

insert or replace into MutuallyExclusiveBuildings (Building, MutuallyExclusiveBuilding) values
	('BUILDING_MADRASA', 'BUILDING_UNIVERSITY'),
	('BUILDING_UNIVERSITY', 'BUILDING_MADRASA');

insert or ignore into BuildingPrereqs (Building, PrereqBuilding) select
	Building, 'BUILDING_MADRASA'
from BuildingPrereqs where PrereqBuilding = 'BUILDING_UNIVERSITY';