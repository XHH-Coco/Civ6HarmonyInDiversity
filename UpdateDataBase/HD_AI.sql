--------------------------------------------------------------------------------
-- Starting units 初始单位
update MajorStartingUnits set NotStartTile = 0, OnDistrictCreated = 1, DifficultyDelta = 0.5
	where Unit = 'UNIT_WARRIOR' and Era = 'ERA_ANCIENT' and AiOnly = 1;
update MajorStartingUnits set NotStartTile = 0, OnDistrictCreated = 1, DifficultyDelta = 0.5
	where Unit = 'UNIT_SPEARMAN' and Era = 'ERA_CLASSICAL' and AiOnly = 1;


update MajorStartingUnits set DifficultyDelta = 0 where Unit = 'UNIT_SETTLER' and AiOnly = 1;
insert or replace into MajorStartingUnits
	(Unit,			Era,									NotStartTile,	AiOnly,	Quantity, MinDifficulty)
values
	('UNIT_SCOUT',	'ERA_ANCIENT',		1,						1,			2,				'DIFFICULTY_EMPEROR'),
	('UNIT_SCOUT',	'ERA_CLASSICAL',	1,						1,			2,				'DIFFICULTY_EMPEROR');


-- High difficulty AI buff
-- 神AI战略资源
insert or replace into TraitModifiers
	(TraitType,						ModifierId)
select
	'TRAIT_LEADER_MAJOR_CIV',		'HD_DEITY_AI_FREE_STRATEGIC_' || ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or replace into Modifiers
	(ModifierId, ModifierType, OwnerRequirementSetId)
select
	'HD_DEITY_AI_FREE_STRATEGIC_' || ResourceType,
	'MODIFIER_PLAYER_ADJUST_FREE_RESOURCE_IMPORT_EXTRACTION',
	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI_CAN_SEE_' || ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or replace into ModifierArguments
	(ModifierId,									Name,			Value)
select
	'HD_DEITY_AI_FREE_STRATEGIC_' || ResourceType,	'ResourceType',	ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or replace into ModifierArguments
	(ModifierId,									Name,			Value)
select
	'HD_DEITY_AI_FREE_STRATEGIC_' || ResourceType,	'Amount',		2
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

insert or replace into TraitModifiers
	(TraitType,						ModifierId)
values
	-- AI的宜居度和住房加成
	('TRAIT_LEADER_MAJOR_CIV',		'AT_LEAST_EMPEROR_DIFFICULTY_AI_EXTRA_AMENITY'),
	('TRAIT_LEADER_MAJOR_CIV',		'AT_LEAST_DEITY_DIFFICULTY_AI_EXTRA_AMENITY'),
	('TRAIT_LEADER_MAJOR_CIV',		'AT_LEAST_EMPEROR_DIFFICULTY_AI_EXTRA_HOUSING'),
	('TRAIT_LEADER_MAJOR_CIV',		'AT_LEAST_DEITY_DIFFICULTY_AI_EXTRA_HOUSING'),
	-- 移民工人可以直接下水
	('TRAIT_LEADER_MAJOR_CIV',		'AT_LEAST_DEITY_SETTLER_EMBARK'),
	('TRAIT_LEADER_MAJOR_CIV',		'AT_LEAST_DEITY_BUILDER_EMBARK'),
	-- 神级ai巨作自动主体化
	('TRAIT_LEADER_MAJOR_CIV',		'AI_AT_LEAST_DEITY_DIFFICULTY_AUTO_THEME'),
	('TRAIT_LEADER_MAJOR_CIV',		'AI_AT_LEAST_DEITY_DIFFICULTY_AUTO_THEME_WONDER');

insert or replace into Modifiers
	(ModifierId,																				ModifierType,																		OwnerRequirementSetId)
values
	('AT_LEAST_EMPEROR_DIFFICULTY_AI_EXTRA_AMENITY',		'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',	'PLAYER_IS_AT_LEAST_EMPEROR_DIFFICULTY_AI'),
	('AT_LEAST_DEITY_DIFFICULTY_AI_EXTRA_AMENITY',			'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY',	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AT_LEAST_EMPEROR_DIFFICULTY_AI_EXTRA_HOUSING',		'MODIFIER_PLAYER_CITIES_ADJUST_POLICY_HOUSING',	'PLAYER_IS_AT_LEAST_EMPEROR_DIFFICULTY_AI'),
	('AT_LEAST_DEITY_DIFFICULTY_AI_EXTRA_HOUSING',			'MODIFIER_PLAYER_CITIES_ADJUST_POLICY_HOUSING',	'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AT_LEAST_DEITY_SETTLER_EMBARK',										'MODIFIER_PLAYER_ADJUST_EMBARK_UNIT_PASS',			'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AT_LEAST_DEITY_BUILDER_EMBARK',										'MODIFIER_PLAYER_ADJUST_EMBARK_UNIT_PASS',			'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_AUTO_THEME',					'MODIFIER_PLAYER_ADJUST_AUTO_THEME_BUILDINGS_WITH_X_SLOTS',							'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_AUTO_THEME_WONDER',	'MODIFIER_PLAYER_ADJUST_AUTO_THEME_BUILDINGS_WITH_X_SLOTS',							'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI');

insert or replace into ModifierArguments
	(ModifierId,											Name,		Value)
values
	('AT_LEAST_EMPEROR_DIFFICULTY_AI_EXTRA_AMENITY',		'Amount',	1),
	('AT_LEAST_DEITY_DIFFICULTY_AI_EXTRA_AMENITY',			'Amount',	1),
	('AT_LEAST_EMPEROR_DIFFICULTY_AI_EXTRA_HOUSING',		'Amount',	1),
	('AT_LEAST_DEITY_DIFFICULTY_AI_EXTRA_HOUSING',			'Amount',	1),
	('AT_LEAST_DEITY_SETTLER_EMBARK',										'UnitType',	'UNIT_SETTLER'),
	('AT_LEAST_DEITY_BUILDER_EMBARK',										'UnitType',	'UNIT_BUILDER'),
	('AI_AT_LEAST_DEITY_DIFFICULTY_AUTO_THEME',					'Amount',		2),
	('AI_AT_LEAST_DEITY_DIFFICULTY_AUTO_THEME',					'IsWonder',	0),
	('AI_AT_LEAST_DEITY_DIFFICULTY_AUTO_THEME_WONDER',	'Amount',		2),
	('AI_AT_LEAST_DEITY_DIFFICULTY_AUTO_THEME_WONDER',	'IsWonder',	1);

-- Yield scale
-- Production Scale: 60 + 15n
-- Science & Culture Scale: 40 + 10n
-- Gold & Faith Scale: 25 + 10n
-- Basic value
--下面这些数值乘以5是高难度AI的城市面板上的额外百分比系数加成，例如生产力12%*5=60%
update ModifierArguments set Extra = 12	where ModifierId = 'HIGH_DIFFICULTY_PRODUCTION_SCALING' and Name = 'Amount';
update ModifierArguments set Extra = 12 where ModifierId = 'HIGH_DIFFICULTY_SCIENCE_SCALING' and Name = 'Amount';
update ModifierArguments set Extra = 12 where ModifierId = 'HIGH_DIFFICULTY_CULTURE_SCALING' and Name = 'Amount';
update ModifierArguments set Extra = 5 where ModifierId = 'HIGH_DIFFICULTY_GOLD_SCALING' and Name = 'Amount';
update ModifierArguments set Extra = 2 where ModifierId = 'HIGH_DIFFICULTY_FAITH_SCALING' and Name = 'Amount';
-- Era bonus 每过掉一个时代获得一层加成，每层*5
create temporary table HD_AIYieldScales (
	EraType text not null,
	YieldType text not null,
	Extra int not null,
	ModifierId text,
	primary key (EraType, YieldType)
);
with Y
	(YieldType,				Extra)
as (values
	('YIELD_PRODUCTION',	5),
	('YIELD_SCIENCE',		5),
	('YIELD_CULTURE',		5),
	('YIELD_GOLD',			2),
	('YIELD_FAITH',			2))
insert or replace into HD_AIYieldScales
	(EraType,	YieldType,	Extra)
select
	EraType,	YieldType,	Extra
from (Eras cross join Y) where EraType != 'ERA_ANCIENT';
update HD_AIYieldScales set ModifierId = 'HIGH_DIFFICULTY_' || YieldType || '_SCALING_AT_LEAST_' || EraType;
insert or replace into TraitModifiers
	(TraitType,					ModifierId)
select
	'TRAIT_LEADER_MAJOR_CIV',	ModifierId
from HD_AIYieldScales;
insert or replace into Modifiers
	(ModifierId,	ModifierType,											OwnerRequirementSetId)
select
	ModifierId,		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'PLAYER_IS_HIGH_DIFFICULTY_AI_AT_LEAST_' || EraType
from HD_AIYieldScales;
insert or replace into ModifierArguments
	(ModifierId,	Name,			Value)
select
	ModifierId,		'YieldType',	YieldType
from HD_AIYieldScales;
insert or replace into ModifierArguments
	(ModifierId,	Name,		Type,								Value,	Extra)
select
	ModifierId,		'Amount',	'LinearScaleFromDefaultHandicap',	0,		Extra
from HD_AIYieldScales;

-- AI伟人点BUFF
create temporary table HD_AIGreatPersonPoints (
	ObjectType text not null,
	GreatPersonClassType text not null,
	ModifierId text,
	primary key (ObjectType, GreatPersonClassType)
);
insert or replace into HD_AIGreatPersonPoints
	(ObjectType,					GreatPersonClassType)
values
	('DISTRICT_COMMERCIAL_HUB',		'GREAT_PERSON_CLASS_MERCHANT'),
	('DISTRICT_SUGUBA',				'GREAT_PERSON_CLASS_MERCHANT'),
	('DISTRICT_HARBOR',				'GREAT_PERSON_CLASS_ADMIRAL'),
	('DISTRICT_COTHON',				'GREAT_PERSON_CLASS_ADMIRAL'),
	('DISTRICT_ROYAL_NAVY_DOCKYARD','GREAT_PERSON_CLASS_ADMIRAL'),
	('DISTRICT_HOLY_SITE',			'GREAT_PERSON_CLASS_PROPHET'),
	('DISTRICT_CAMPUS',				'GREAT_PERSON_CLASS_SCIENTIST'),
	('DISTRICT_SEOWON',				'GREAT_PERSON_CLASS_SCIENTIST'),
	('DISTRICT_ENCAMPMENT',			'GREAT_PERSON_CLASS_GENERAL'),
	('DISTRICT_IKANDA',				'GREAT_PERSON_CLASS_GENERAL'),
	('DISTRICT_THEATER',			'GREAT_PERSON_CLASS_WRITER'),
	('DISTRICT_THEATER',			'GREAT_PERSON_CLASS_ARTIST'),
	('DISTRICT_THEATER',			'GREAT_PERSON_CLASS_MUSICIAN'),
	('DISTRICT_ACROPOLIS',			'GREAT_PERSON_CLASS_WRITER'),
	('DISTRICT_ACROPOLIS',			'GREAT_PERSON_CLASS_ARTIST'),
	('DISTRICT_ACROPOLIS',			'GREAT_PERSON_CLASS_MUSICIAN'),
	('DISTRICT_INDUSTRIAL_ZONE',	'GREAT_PERSON_CLASS_ENGINEER'),
	('DISTRICT_HANSA',				'GREAT_PERSON_CLASS_ENGINEER');
insert or replace into HD_AIGreatPersonPoints
	(ObjectType,					GreatPersonClassType)
select
	'DISTRICT_OBSERVATORY',			'GREAT_PERSON_CLASS_SCIENTIST'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_OBSERVATORY');
insert or replace into HD_AIGreatPersonPoints
	(ObjectType,					GreatPersonClassType)
select
	'DISTRICT_THANH',				'GREAT_PERSON_CLASS_GENERAL'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_THANH');
insert or replace into HD_AIGreatPersonPoints
	(ObjectType,					GreatPersonClassType)
select
	'DISTRICT_SUK_FLOATINGMARKET',	'GREAT_PERSON_CLASS_MERCHANT'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_SUK_FLOATINGMARKET');
insert or replace into HD_AIGreatPersonPoints
	(ObjectType,					GreatPersonClassType)
select
	'DISTRICT_OPPIDUM',				'GREAT_PERSON_CLASS_ENGINEER'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_OPPIDUM');
insert or replace into HD_AIGreatPersonPoints
	(ObjectType,					GreatPersonClassType)
select
	'DISTRICT_CVS_MALAYSIA_UI',		'GREAT_PERSON_CLASS_ADMIRAL'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_CVS_MALAYSIA_UI');
insert or replace into HD_AIGreatPersonPoints
	(ObjectType,					GreatPersonClassType)
select
	BuildingType,					GreatPersonClassType
from (HD_BuildingTiers b inner join HD_AIGreatPersonPoints a on b.PrereqDistrict = a.ObjectType);
update HD_AIGreatPersonPoints set ModifierId = 'HD_AI_' || ObjectType || '_' || GreatPersonClassType;
insert or replace into BuildingModifiers
	(BuildingType,		ModifierId)
select
	ObjectType,			ModifierId
from HD_AIGreatPersonPoints where ObjectType in (select BuildingType from Buildings);
insert or replace into DistrictModifiers
	(DistrictType,		ModifierId)
select
	ObjectType,			ModifierId
from HD_AIGreatPersonPoints where ObjectType in (select DistrictType from Districts);
--删除圣地地基额外伟人点
delete from DistrictModifiers where ModifierId = 'HD_AI_DISTRICT_HOLY_SITE_GREAT_PERSON_CLASS_PROPHET';
insert or replace into Modifiers
	(ModifierId,	ModifierType,											OwnerRequirementSetId)
select
	ModifierId,		'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT',		'PLAYER_IS_HIGH_DIFFICULTY_AI'
from HD_AIGreatPersonPoints;
insert or replace into ModifierArguments
	(ModifierId,	Name,						Value)
select
	ModifierId,		'GreatPersonClassType',		GreatPersonClassType
from HD_AIGreatPersonPoints union all select
	ModifierId,		'Amount',					1
from HD_AIGreatPersonPoints;

update ModifierArguments set Value = 2 where Name = 'Amount' and ModifierId in
	(select ModifierId from HD_AIGreatPersonPoints where GreatPersonClassType in ('GREAT_PERSON_CLASS_WRITER', 'GREAT_PERSON_CLASS_ARTIST', 'GREAT_PERSON_CLASS_MUSICIAN'));
------------------------------------------------------------------
-- adjust district priority   调整基础产出倾向，这会让AI的坐地、科技市政、总督选择、建造选择等有所变化。
--除了鸽子，暂时全部删掉恢复原版设定by siv1.35 这可能导致了测试中AI落地出商业中心和渔业港市现象的出现频率
--UPDATE AiFavoredItems SET Value = 25 WHERE ListType = 'DefaultYieldBias' AND Item = 'YIELD_PRODUCTION'; -- V1.35维持原版锤25%
--UPDATE AiFavoredItems SET Value = 20 WHERE ListType = 'DefaultYieldBias' AND Item = 'YIELD_SCIENCE'; -- V1.35维持原版瓶10%
--UPDATE AiFavoredItems SET Value = 20 WHERE ListType = 'DefaultYieldBias' AND Item = 'YIELD_CULTURE'; -- V1.35维持原版琴10%
--UPDATE AiFavoredItems SET Value = 0 WHERE ListType = 'DefaultYieldBias' AND Item = 'YIELD_GOLD';  -- V1.35维持原版金20
update AiFavoredItems set Value = 15 where ListType = 'DefaultYieldBias' and Item = 'YIELD_FAITH'; -- V1.35上调，从原版鸽-25%，但对比V1.34的+50%是下降

------------------------------------------------------------------
--F版AI认为伟人点的基础产出概念是1伟人点=0.5产。
--hd的区域建筑等产出的伟人点翻倍了，但是pseudoyield表的gpp没相应除以2导致项目估值过高。故项目延后，并降低部分伟人价值。
--在下面列入的伟人点类型为0.5产（大科、大艺、大音），除此以外以外的伟人点基础产出概念会变成1产，也就是价值被翻倍。
--可填入0.1~1等数字（精确到十分位就好，不要设置过低）
update PseudoYields set DefaultValue = 1 where PseudoYieldType like 'PSEUDOYIELD_GPP_%' and PseudoYieldType != 'PSEUDOYIELD_GPP_SCIENTIST' and PseudoYieldType != 'PSEUDOYIELD_GPP_ARTIST' and PseudoYieldType != 'PSEUDOYIELD_GPP_MUSICIAN';

------------------------------------------------------------------
-- xiaoxiaocat: changes below are not reorganized 
--siv 已初步整理的AI（模式搬运）改动
------------------------------------------------------------------
--↓AI不同时代的不同策略，此处插入了2个区域策略---2023年01月28日怀疑这个写法无法生效，暂时注释
-- AiFavoredItems
--insert or replace into Strategy_Priorities
--	(StrategyType,						ListType)
--values
--	('STRATEGY_MEDIEVAL_CHANGES',		'DLMedievalDistricts'),
--	('STRATEGY_RENAISSANCE_CHANGES',	'DLRenaissanceDistricts');
--↑AI不同时代的不同策略，此处插入了2个区域策略---2023年01月28日怀疑这个写法无法生效，暂时注释
------------------------------------------------------------------

--AI通用逻辑，施加给主要文明AI，版本V1.35，在游戏中常驻（未来增加比较具体的倾向，减少通用部分，让AI更个性化）
insert or replace into AiListTypes (ListType) values
--	('DLMedievalDistricts'),
--	('DLRenaissanceDistricts'),
--HD自设的AI建筑/区域/市政/科技/单位/宣战城邦等倾向
	('DLAdjustBuildings'),
	('DLAdjustDistricts'),
	('DLAdjustCivics'),
	('DLAdjustTechs'),
	('DLAdjustUnits'),
	('DLAdjustUnitPCBuilds'),
	('DLFewerWaronCityStates');
insert or replace into AiLists
	(ListType,					LeaderType,					System)
values
--中世纪开始重视的区域
--	('DLMedievalDistricts',		'TRAIT_LEADER_MAJOR_CIV',	'Districts'),
--文艺开始重视的区域
--	('DLRenaissanceDistricts',	'TRAIT_LEADER_MAJOR_CIV',	'Districts'),
--常驻
	('DLAdjustBuildings',		'TRAIT_LEADER_MAJOR_CIV',	'Buildings'),
	('DLAdjustDistricts',		'TRAIT_LEADER_MAJOR_CIV',	'Districts'),
	('DLAdjustCivics',			'TRAIT_LEADER_MAJOR_CIV',	'Civics'),
	('DLAdjustTechs',			'TRAIT_LEADER_MAJOR_CIV',	'Technologies'),
	('DLAdjustUnits',			'TRAIT_LEADER_MAJOR_CIV',	'Units'),
	('DLFewerWaronCityStates',	'TRAIT_LEADER_MAJOR_CIV',	'DiplomaticActions');

--AI具体的偏爱对象和爱恨程度，Favored填0或者1（无偏爱或者有偏爱），Value定义额外价值程度，可正数可负数，数值大小可决定优先级
insert or replace into AiFavoredItems
	(ListType,					Item,									Favored,	Value)
values
--将【粮仓】设置为比较热衷的建筑,设置额外价值粮仓0→20，-by siv1.35
--但是【远古城墙】从偏爱改为不偏爱，设置额外价值5，以避免砌砖后落地固定出城墙不出碑的情况-by siv1.35
	('DLAdjustBuildings',		'BUILDING_GRANARY',						1,			20),
	('DLAdjustBuildings',		'BUILDING_WALLS',						0,			5),
--增加【神社】的偏爱，以解锁传教士（应用于已经出了圣地的AI）-by siv1.35
	('DLAdjustBuildings',		'BUILDING_SHRINE',						1,			60),
--【谒见厅】
	('DLAdjustBuildings',		'BUILDING_GOV_TALL',					1,			0),
--基于减少干扰的理由注释掉【市政2级建筑】，AI自行判断价值（总督头衔等）-by siv1.35
--	('DLAdjustBuildings',		'BUILDING_GOV_CITYSTATES',				1,			0),
	('DLAdjustBuildings',		'BUILDING_GOV_FAITH',					1,			800),
	('DLAdjustBuildings',		'BUILDING_GOV_CITYSTATES',		1,			800),
--工业区和市政广场的偏爱和额外价值，工业区额外价值从1000→1，避免一解锁炼铁就放弃圣地等区域的情况-by siv1.35
	('DLAdjustDistricts',		'DISTRICT_GOVERNMENT',					1,			0),
	('DLAdjustDistricts',		'DISTRICT_INDUSTRIAL_ZONE',				1,			1),
--1.37版本，加入商业和港口调整
--	('DLAdjustDistricts',		'DISTRICT_HARBOR',						1,			0),	
	-- ('DLAdjustDistricts',		'DISTRICT_COMMERCIAL_HUB',				0,			-1),		
--传教单位（修复不出传教单位的BUG，让能传教的文明更激情传教）-by siv1.35
	('DLAdjustUnits',			'UNIT_MISSIONARY',						1,			10),
	('DLAdjustUnits',			'UNIT_APOSTLE',							1,			10),
--暂时使得出间谍频率降低，非处于战争、敌对状态几乎不出-by siv1.35
	('DLAdjustUnits',			'UNIT_SPY',							    0,			-1), 
--暂时使得出大亨频率降低，几乎不出-by siv1.39
	('DLAdjustUnits',			'UNIT_LEU_TYCOON',						0,			-1),    
--科技类改动（注：ai似乎会根据视野中已看到的地块采取不同玩法，如湖海格子够多就变成走制图学的海文明玩法，因此不对海科技做强调（实测结果也认为不需要强调）
--HD历法科技
	('DLAdjustTechs',			'TECH_CALENDAR_HD',						1,			0),
--占星术（因为写作基本自带尤里卡存在优先级，所以不用设置写作）-by siv1.35
	('DLAdjustTechs',			'TECH_ASTROLOGY',						1,			0),
--采矿、畜牧、制陶术（让AI的资源地块更容易获得改良）-by siv1.35
	('DLAdjustTechs',			'TECH_MINING',							1,			1),
	('DLAdjustTechs',			'TECH_ANIMAL_HUSBANDRY',				1,			8),
	('DLAdjustTechs',			'TECH_POTTERY',							1,			1),
--炼铁术改为工程，以降低开局直冲铸铜的可能性-by siv1.35
	('DLAdjustTechs',			'TECH_ENGINEERING',						1,			0),
--货币，为减少干扰，注释掉-by siv1.35
--  ('DLAdjustTechs',			'TECH_CURRENCY',						1,			0),
--学徒
	('DLAdjustTechs',			'TECH_APPRENTICESHIP',					1,			0),
--教育
	('DLAdjustTechs',			'TECH_EDUCATION',						1,			70),
--罗盘和制图下降优先级
	('DLAdjustTechs',			'TECH_COMPASS_HD',						0,			-5000),
	('DLAdjustTechs',			'TECH_CARTOGRAPHY',						0,			-3000),
	('DLAdjustTechs',			'TTECH_SQUARE_RIGGING',					0,			-5000),
--HD土木工程，减少干扰，注释掉by siv 
--  ('DLAdjustTechs',			'TECH_CIVIL_ENGINEERING_HD',			1,			0),
--电脑
	('DLAdjustTechs',			'TECH_COMPUTERS',						1,			0),
--市政线 技艺/对外贸易/国家劳动力/帝国初期/政治哲学
	('DLAdjustCivics',			'CIVIC_FOREIGN_TRADE',					1,			0),
	('DLAdjustCivics',			'CIVIC_CRAFTSMANSHIP',					1,			0),
	('DLAdjustCivics',			'CIVIC_STATE_WORKFORCE',				1,			0),
	('DLAdjustCivics',			'CIVIC_EARLY_EMPIRE',					1,			0),
	('DLAdjustCivics',			'CIVIC_POLITICAL_PHILOSOPHY',			1,			20),
--戏剧诗歌/行政部门/历史哲学（解锁文艺学院，关键）
	('DLAdjustCivics',			'CIVIC_DRAMA_POETRY',					1,			20),
	('DLAdjustCivics',			'CIVIC_CIVIL_SERVICE',					1,			0),
	('DLAdjustCivics',			'CIVIC_HISTORICAL_PHILOSOPHY_HD',		1,			80),--上调，by siv1.35
--为避免AI不换政体的情况，增加2级政体市政偏爱（归正会和探索） by siv1.35（但测试中AI还是基本不切政体）
	('DLAdjustCivics',			'CIVIC_REFORMED_CHURCH',				1,			80),
	('DLAdjustCivics',			'CIVIC_EXPLORATION',					1,			80),   
--城市化、意识形态和全球化——注释掉避免干扰，by siv1.35
--  ('DLAdjustCivics',			'CIVIC_URBANIZATION',					1,			0),
--  ('DLAdjustCivics',			'CIVIC_IDEOLOGY',						1,			0),
--  ('DLAdjustCivics',			'CIVIC_GLOBALIZATION',					1,			0),
	('DLFewerWaronCityStates',	'DIPLOACTION_DECLARE_WAR_MINOR_CIV',	0,			0),--非战狂不打城邦
	('AgressiveDiplomacy',		'DIPLOACTION_DECLARE_WAR_MINOR_CIV',	1,			0);
/*
These Pseudos affect the valuation of Civics and Technologies
However, each is applied to a separate tree respectively, and since the trees are separate they don't clash
Tweaking these probaby would result in a bit different ORDER of selecting civics and techs, but without the details
of the algorithm it is hard to predict results
I determined only that:
a) Each civic and tech has a residual valuation that can be seen when setting those Pseudos to 0
b) The pseudo default value is multiplied by a factor of 30..100 and added to the valuation
c) The bias value (from AiFavoredItems) affects this factor even further, so formula is: factor * def_value * ( 1 + bias_percentage )
UPDATE PseudoYields SET DefaultValue = 5 WHERE PseudoYieldType = 'PSEUDOYIELD_CIVIC';
UPDATE PseudoYields SET DefaultValue = 5 WHERE PseudoYieldType = 'PSEUDOYIELD_TECHNOLOGY';
*/
-------------------------------------
--AI奢侈品价格
update PseudoYields set DefaultValue = 3 where PseudoYieldType = 'PSEUDOYIELD_RESOURCE_LUXURY';--AI认为一个奢侈最多基础价值几产(1产4回合金），实际价格需要考虑具体情况
update AiFavoredItems set Value = 30 where ListType = 'CatherineAltLuxuries'; --凯瑟琳（寻欢作乐）同奢侈再购买额外价格调整，具体影响需要实测
update PseudoYields set DefaultValue = 0.2 where PseudoYieldType = 'PSEUDOYIELD_HAPPINESS';--AI认为一个奢侈带来的宜居度助力每1座城的产出价值，实际价格需要考虑具体情况
-------------------------------------
-- 巴巴罗萨/老德，单独AI改动范例
insert or replace into AiListTypes (ListType) values
	('BarbarossaBuildings'),
	('BarbarossaDistricts'),
	('BarbarossaYields');
insert or replace into AiLists
	(ListType,					LeaderType,							System)
values
	('BarbarossaBuildings',		'TRAIT_LEADER_HOLY_ROMAN_EMPEROR',	'Buildings'),
	('BarbarossaDistricts',		'TRAIT_LEADER_HOLY_ROMAN_EMPEROR',	'Districts'),
	('BarbarossaYields',		'TRAIT_LEADER_HOLY_ROMAN_EMPEROR',	'Yields');
insert or replace into AiFavoredItems
	(ListType,					Item,						Favored,	Value)
values
	('BarbarossaBuildings',		'BUILDING_WORKSHOP',		1,			0),
	('BarbarossaDistricts',		'DISTRICT_HANSA',			1,			0),
	('BarbarossaTechs',			'TECH_IRON_WORKING',		1,			0),
	('BarbarossaTechs',			'TECH_CURRENCY',			1,			0),
	('BarbarossaYields',		'YIELD_FAITH',				1,			-20),
	('BarbarossaYields',		'YIELD_GOLD',				1,			10),
	('BarbarossaYields',		'YIELD_PRODUCTION',			1,			10);

--凯撒和图拉真的罗马UD水渠倾向-把凯撒代码挪到凯撒包
insert or replace into AiListTypes (ListType) values
--	('CaesarDistricts'),
	('TrajanDistricts');
insert or replace into AiLists
	(ListType,					LeaderType,							System)
values
--	('CaesarDistricts',			'TRAIT_LEADER_CAESAR',				'Districts'),
	('TrajanDistricts',			'TRAJANS_COLUMN_TRAIT',				'Districts');
insert or replace into AiFavoredItems
	(ListType,					Item,						Favored,	Value)
values
--	('CaesarDistricts',			'DISTRICT_BATH',			1,			80),
	('TrajanDistricts',			'DISTRICT_BATH',			1,			100);

--雅德维加偏好的中世纪市政从原版雇佣兵（解锁翼骑兵）改为行政部门
update AiFavoredItems set Item = 'CIVIC_CIVIL_SERVICE' where ListType = 'JadwigaCivics' and Item = 'CIVIC_MERCENARIES';

--雅德维加额外的军工价值（但AI雅德维加还是要等军营2级建筑才开始训练军事工程师）
update AiFavoredItems set Value = '20' where ListType = 'JadwigaUnitBuilds';
--增加雅德维加偏好的科技：攻城术改马镫，货币改造纸术
update AiFavoredItems set Item = 'TECH_PAPER_MAKING' where ListType = 'JadwigaTechs' and Item = 'TECH_PAPER_MAKING';
update AiFavoredItems set Item = 'TECH_STIRRUPS' where ListType = 'JadwigaTechs' and Item = 'TECH_SIEGE_TACTICS';	
--增加雅德维加偏好的市政:军事训练改归正会，神秘主义改神学
update AiFavoredItems set Item = 'CIVIC_THEOLOGY' where ListType = 'JadwigaCivics' and Item = 'CIVIC_MYSTICISM';
update AiFavoredItems set Item = 'CIVIC_REFORMED_CHURCH' where ListType = 'JadwigaCivics' and Item = 'CIVIC_MILITARY_TRAINING';
--雅德维加偏好的奇观新增：宙斯像/阿尔罕布拉宫/神谕/奇琴伊察
update AiFavoredItems set Item =  'BUILDING_STATUE_OF_ZEUS' where ListType = 'JadwigaWonders';
update AiFavoredItems set Item =  'BUILDING_ALHAMBRA'		where ListType = 'JadwigaWonders';
update AiFavoredItems set Item =  'BUILDING_ORACLE'			where ListType = 'JadwigaWonders';	
update AiFavoredItems set Item =  'BUILDING_CHICHEN_ITZA'	where ListType = 'JadwigaWonders';

-- From AI Testing mode.AI模式代码搬运2
-------------------------------------
--		AI Related Adjustments	 -- 
-------------------------------------
--宣战前后对某些城市的攻击欲望，如有城墙的城市
update AiOperationDefs set MaxTargetDistInArea = 20, MinOddsOfSuccess = 0.6, MustHaveUnits = 6 where OperationName = 'Attack Enemy City';
update AiOperationDefs set MaxTargetDistInArea = 30, MinOddsOfSuccess = 0.3, MustHaveUnits = 6 where OperationName = 'Wartime Attack Enemy City';
update AiOperationDefs set MaxTargetDistInArea = 20, MinOddsOfSuccess = 0.72, MustHaveUnits = 8 where OperationName = 'Attack Walled City';
update AiOperationDefs set MaxTargetDistInArea = 30, MinOddsOfSuccess = 0.48, MustHaveUnits = 8 where OperationName = 'Wartime Attack Walled City';
-------------------------------------
--（另一段）具体的偏爱对象和爱恨程度，Favored填0或者1（无固定爱好或者有固定爱好），Value定义额外价值程度，可正数可负数，大小可决定优先级
--根据近期用测试工具测试的结果，直走ZZZX的目的达到了，尽管没有设置额外价值
--新增水渠、外交区和保护区的偏爱以强化AI产出，探索效力--by siv1.35
insert or replace into AiFavoredItems
	(ListType,					Item,									Favored,	Value)
values
	('DLAdjustCivics',			'CIVIC_CRAFTSMANSHIP',					1,			0),
	('DLAdjustCivics',			'CIVIC_FOREIGN_TRADE',					1,			0),
	('DLAdjustCivics',			'CIVIC_STATE_WORKFORCE',				1,			0),
	('DLAdjustCivics',			'CIVIC_EARLY_EMPIRE',					1,			0),
	('DLAdjustCivics',			'CIVIC_POLITICAL_PHILOSOPHY',			1,			0),
--保护区、水渠和外交区的偏好，避免AI错过有用的建筑资源
	('DLAdjustDistricts',		'DISTRICT_PRESERVE',					1,			70),
--神谕碑、古树林、观海石偏好（使AI大后期可以正常解锁并建造到后面的保护区高级建筑）
	('DLAdjustBuildings',		'BUILDING_GROVE',						1,			400),
	('DLAdjustDistricts',		'DISTRICT_DIPLOMATIC_QUARTER',			1,			110),	
	('DLAdjustDistricts',		'DISTRICT_AQUEDUCT',					1,			40),	
	('DLAdjustDistricts',		'DISTRICT_THEATER',					1,			40);




-------------------------------------
--海军

insert or replace into AiFavoredItems
	(ListType,					Item,									Favored,	Value)
values
	('NavalPreferredTechs',			'TECH_CARTOGRAPHY',					0,			-8000),
	('NavalPreferredTechs',			'TECH_SQUARE_RIGGING',				0,			-8000),
	('NavalPreferredTechs',			'TECH_MASS_PRODUCTION',				1,			4500),
	('NavalPreferredTechs',			'TECH_EDUCATION',					1,			8500),
	('NavalPreferredTechs',			'TECH_MATHEMATICS',					1,			8500),
	('NavalPreferredTechs',			'TECH_SCIENTIFIC_THEORY',			1,			9000);

-------------------------------------
-- [Real Strategy]（工坊作者infixo一个AI调整MOD，此处是抄它对某些领袖的调整）
--大英维多利亚和西班牙菲利普二世的异大陆爱好降低，不要那么极端/挪威的海军爱好降低
update AiFavoredItems set Favored = 0, Value = 40 where ListType = 'SettleAllContinents' and Item = 'Foreign Continent'; -- 大英, down from 120 (!)
update AiFavoredItems set Favored = 0, Value = 40 where ListType = 'PhilipForeignSettlement' and Item = 'Foreign Continent'; -- 菲利普二世, def. 60
update AiFavoredItems set Value = 50 where ListType = 'LastVikingKingNavalPreference' and Item = 'PSEUDOYIELD_UNIT_NAVAL_COMBAT'; -- def. 100
--------------------------------------------------------------
-- Changed based on [MOD] Real Strategy
--先删除了原版的AI移民偏爱，赋予新的AI坐地指导顾问的智能（1.3.6beta，撤销删除，以保护原有代码完整性，改删增为增改）
--AI专用坐地指导顾问会给出推荐坐城点，AI看到视野里存在好的坐城点可能会更热衷训练和命令开拓者前往，并拉出一支护送军队。
--注：F社的奇妙逻辑导致坐地指导顾问每几T都要根据新探到的视野刷新坐地推荐，坐地不够及时可能导致AI移民兜圈。
--delete from AiFavoredItems where ListType = 'StandardSettlePlot';
insert or replace into AiFavoredItems
	(ListType, 				Item, 					Favored, Value, StringVal,  TooltipString)
values
	--忠诚度压力，重复项以增加权重
	--('StandardSettlePlot', 'Cultural Pressure', 	0, 		 3, 	NULL, 		NULL), -- 1  
	('StandardSettlePlot', 'Cultural Pressure', 	0, 		 -1, 	NULL, 		NULL), -- -6 忠诚度压力
	('StandardSettlePlot', 'Cultural Pressure_1', 	0, 		 -1, 	NULL, 		NULL), -- -6 忠诚度压力
	('StandardSettlePlot', 'Cultural Pressure_2', 	0, 		 -1, 	NULL, 		NULL), -- -6 忠诚度压力
	--异大陆不偏爱而且价值不高
	('StandardSettlePlot', 'Foreign Continent', 	0, 		 -7, 	NULL, 		'LOC_SETTLEMENT_RECOMMENDATION_FOREIGN_CONTINENT'), 
	--附近友方城市加分，疑似VALUE=每远离我方城市一环加多少分，重复项以增加权重
	('StandardSettlePlot', 'Nearest Friendly City', 1,  	 -7, 	NULL, 		'LOC_SETTLEMENT_RECOMMENDATION_NEAREST_CITY'), -- -10, be careful - expansion gives +3, naval +2/4 
	('StandardSettlePlot', 'Nearest Friendly City_1', 1,  	 -7, 	NULL, 		'LOC_SETTLEMENT_RECOMMENDATION_NEAREST_CITY'), -- -10, be careful - expansion gives +3, naval +2/4 
	('StandardSettlePlot', 'Nearest Friendly City_2', 1,  	 -7, 	NULL, 		'LOC_SETTLEMENT_RECOMMENDATION_NEAREST_CITY'), -- -10, be careful - expansion gives +3, naval +2/4 
	--去除淡水偏爱，但是淡水价值仍然很高（这样改比Favored=1更优的地方是不会导致没淡水就不想坐地）
	('StandardSettlePlot', 'Fresh Water', 			0, 		 18, 	NULL, 		'LOC_SETTLEMENT_RECOMMENDATION_FRESH_WATER'), -- def
	--去除海城偏爱，但是海水价值仍然较高（这样改比Favored=1更优的地方是不会导致没海水就不想坐地）
	('StandardSettlePlot', 'Coastal', 				0, 		 11,     NULL, 		'LOC_SETTLEMENT_RECOMMENDATION_COAST'), -- 12
	--城市产出预估，3环内产出，1粮=1锤=1瓶=1琴=1.5鸽=3金
	('StandardSettlePlot', 'Total Yield', 			0, 		 3, 	'YIELD_PRODUCTION', 'LOC_SETTLEMENT_RECOMMENDATION_TOTAL_YIELD'), -- 原版2
	('StandardSettlePlot', 'Total Yield', 			0, 		 3, 	'YIELD_FOOD', 'LOC_SETTLEMENT_RECOMMENDATION_TOTAL_YIELD'), -- 原版1
	('StandardSettlePlot', 'Total Yield', 			0, 		 3, 	'YIELD_SCIENCE', 'LOC_SETTLEMENT_RECOMMENDATION_TOTAL_YIELD'), -- 原版1
	('StandardSettlePlot', 'Total Yield', 			0, 		 3, 	'YIELD_CULTURE', 'LOC_SETTLEMENT_RECOMMENDATION_TOTAL_YIELD'), -- 原版1
	('StandardSettlePlot', 'Total Yield', 			0, 		 2, 	'YIELD_FAITH', 'LOC_SETTLEMENT_RECOMMENDATION_TOTAL_YIELD'), -- 原版1，为了让AI愿意在近点沙漠坐而设置
	('StandardSettlePlot', 'Total Yield', 			0, 		 1, 	'YIELD_GOLD', 'LOC_SETTLEMENT_RECOMMENDATION_TOTAL_YIELD'), -- 原版无,为了让AI愿意坐湖设置。  
	--内环（市中心和靠近市中心的产出）
	('StandardSettlePlot', 'Inner Ring Yield',      0, 		 3, 	'YIELD_FOOD',	'LOC_SETTLEMENT_RECOMMENDATION_INNER_YIELD'), -- 1, RS:1
	('StandardSettlePlot', 'Inner Ring Yield', 		0, 		 3,	    'YIELD_PRODUCTION', 'LOC_SETTLEMENT_RECOMMENDATION_INNER_YIELD'), -- def
	('StandardSettlePlot', 'Inner Ring Yield', 		0, 		 3,		'YIELD_SCIENCE', 'LOC_SETTLEMENT_RECOMMENDATION_INNER_YIELD'), -- 1
	('StandardSettlePlot', 'Inner Ring Yield', 		0, 		 3,		'YIELD_CULTURE', 'LOC_SETTLEMENT_RECOMMENDATION_INNER_YIELD'), -- 1
	('StandardSettlePlot', 'Inner Ring Yield', 		0, 		 1,		'YIELD_GOLD', 'LOC_SETTLEMENT_RECOMMENDATION_INNER_YIELD'),  --原版没有这条   
	('StandardSettlePlot', 'Inner Ring Yield', 		0, 		 2,		'YIELD_FAITH',	'LOC_SETTLEMENT_RECOMMENDATION_INNER_YIELD'), -- 1
	--对新资源的重视程度（3环内资源），分通用/加成/奢侈/战略
	('StandardSettlePlot', 'New Resources',    		0, 		 2, 	NULL, '   LOC_SETTLEMENT_RECOMMENDATION_NEW_RESOURCES'), -- 4, RS:6
	('StandardSettlePlot', 'Resource Class', 		0, 		 2, 	'RESOURCECLASS_BONUS',	 'LOC_SETTLEMENT_RECOMMENDATION_STRATEGIC_RESOURCES'), -- new, RS:2
	('StandardSettlePlot', 'Resource Class', 		0, 		 2,     'RESOURCECLASS_LUXURY',	'LOC_SETTLEMENT_RECOMMENDATION_STRATEGIC_RESOURCES'), -- 2
	('StandardSettlePlot', 'Resource Class', 		0, 		 1,     'RESOURCECLASS_STRATEGIC', 'LOC_SETTLEMENT_RECOMMENDATION_STRATEGIC_RESOURCES'), -- 2, RS:4

	--特地增强了AI圈马铁硝石的重视程度，降低了坐有冰的城的情况
	('StandardSettlePlot', 'Specific Resource', 0, 2, 'RESOURCE_HORSES', 'LOC_SETTLEMENT_RECOMMENDATION_RESOURCES'), -- 3
	('StandardSettlePlot', 'Specific Resource', 0, 1, 'RESOURCE_IRON',	'LOC_SETTLEMENT_RECOMMENDATION_RESOURCES'), -- 5, RS:4
	('StandardSettlePlot', 'Specific Resource', 0, 1, 'RESOURCE_NITER',	'LOC_SETTLEMENT_RECOMMENDATION_STRATEGIC_RESOURCES'), -- def
	('StandardSettlePlot', 'Specific Feature', 0, -5, 'FEATURE_ICE', 'LOC_SETTLEMENT_RECOMMENDATION_FEATURES');
--------------------------------------------------------------
-- Updates to Settlement recommendations 给AI修饰一些穷/差和富/好的概念，以及两者之间的普通区间
--鼓励新资源
--update PlotEvalConditions set PoorValue = -1,  GoodValue = 1 where ConditionType = 'New Resources'; -- PoorValue="0" GoodValue="4"
--内环产出（1环粮锤瓶琴鸽金）至少两个加成资源为优秀，至少4格沙漠为差（是否是求和有待考据）
update PlotEvalConditions set PoorValue = 24, GoodValue = 57 where ConditionType = 'Inner Ring Yield'; -- PoorValue="18" GoodValue="26", RS:12~18
--城市产出预估，降低过度挑剔不坐地的可能性
update PlotEvalConditions set PoorValue = 18, GoodValue = 57 where ConditionType = 'Total Yield'; -- PoorValue="30" GoodValue="50"
--POOR为内陆定居点，GOOD为海岸定居点，此规则更多应用于进入海洋思维的AI（为避免海洋思维产生BUG，淡化之）
update PlotEvalConditions set PoorValue = -1, GoodValue = 2 where ConditionType = 'Coastal'; -- PoorValue="-1" GoodValue="12", RS:-1~8
--增加了城点圈资源地貌的评分门槛 
update PlotEvalConditions set PoorValue = -1,  GoodValue =	3 where ConditionType = 'Specific Resource'; -- PoorValue="-1" GoodValue="6"
update PlotEvalConditions set PoorValue = -6,  GoodValue =	6 where ConditionType = 'Specific Feature'; -- PoorValue="-5" GoodValue="5"
update PlotEvalConditions set PoorValue = 1, GoodValue =	6 where ConditionType = 'Resource Class'; -- PoorValue="2" GoodValue="6"
--新大陆城点，大幅降低，让移民跨半个地球远征不再那么常见
update PlotEvalConditions set PoorValue = -6, GoodValue = -1 where ConditionType = 'Foreign Continent'; -- PoorValue="-2" GoodValue="50"
--如果城点处于友方城市6环以内，AI无可无不可，超过6环会觉得差;重复项以增加权重
update PlotEvalConditions set PoorValue = -71,  GoodValue = -43 where ConditionType = 'Nearest Friendly City'; -- PoorValue="-50" GoodValue="-20"
update PlotEvalConditions set PoorValue = -71,  GoodValue = -43 where ConditionType = 'Nearest Friendly City_1'; -- PoorValue="-50" GoodValue="-20"
update PlotEvalConditions set PoorValue = -71,  GoodValue = -43 where ConditionType = 'Nearest Friendly City_2'; -- PoorValue="-50" GoodValue="-20"
--忠诚度压力,重复项以增加权重
update PlotEvalConditions set PoorValue = -5,  GoodValue = -2 where ConditionType = 'Cultural Pressure'; 
update PlotEvalConditions set PoorValue = -5,  GoodValue = -2 where ConditionType = 'Cultural Pressure_1'; 
update PlotEvalConditions set PoorValue = -5,  GoodValue = -2 where ConditionType = 'Cultural Pressure_2'; 
--------------------------------------------------------------


-- See also [MOD] Real Strategy   一些零碎的AI价值调整，对于某些对象有多少价值（赋予虚拟价值）乘算到实际价值
--------------------------------------------------------------
--用于消灭AI对某个item价值的代码
--用来降低遗物的价格（顺便降低了其他的）和前期不让用间谍
insert or replace into PseudoYields
	(PseudoYieldType,                   DefaultValue)
values
	('PSEUDOYIELD_TOURISM',             0),
	('PSEUDOYIELD_UNIT_LEU_TYCOON',			0.4),
	('PSEUDOYIELD_UNIT_LEU_INVESTOR',		0.2),
	('PSEUDOYIELD_UNIT_SPY',            1.0);
--------------------------------------------------------------
--对其他人的原始首都（攻击）降低，理论上避免不管路上的城直冲首都，理论上也降低有首都视野的联宣价格
update PseudoYields set DefaultValue = 50 where PseudoYieldType = 'PSEUDOYIELD_CITY_ORIGINAL_CAPITAL'; -- 	200, lower value should save Minors a bit, Conquest will boost it anyway

--理论上更加死磕蛮寨
update PseudoYields set DefaultValue = 1 where PseudoYieldType = 'PSEUDOYIELD_CLEAR_BANDIT_CAMPS'; -- 	0.5, Ai+ 1.6
--理论上更热衷改良地块
update PseudoYields set DefaultValue = 5.5 where PseudoYieldType = 'PSEUDOYIELD_IMPROVEMENT'; -- 	0.5 => 3.0 in NFP, 13.5 too much
--影响力点数热衷
update PseudoYields set DefaultValue = 0.8 where PseudoYieldType = 'PSEUDOYIELD_INFLUENCE'; -- 	0.5
--常备军
update PseudoYields set DefaultValue = 0.9 where PseudoYieldType = 'PSEUDOYIELD_STANDING_ARMY_NUMBER'; -- 	1 -- controls size of the army
update PseudoYields set DefaultValue = 0.08 where PseudoYieldType = 'PSEUDOYIELD_STANDING_ARMY_VALUE'; -- 	0.1 -- controls size of the army
--旅游业绩渴求度降低，理论上降低遗物价格
--update PseudoYields set DefaultValue = 0.1 where PseudoYieldType = 'PSEUDOYIELD_TOURISM'; -- 	1
--更加热衷出开拓者
update PseudoYields set DefaultValue = 2.0 where PseudoYieldType = 'PSEUDOYIELD_UNIT_SETTLER'; -- 1 -- 1.4 seems to much, they build Settlers even with 0 army and undeveloped cities; 210616 back to original - AI settles well
--维持总督头衔价值为2
--update PseudoYields set DefaultValue = X.X where PseudoYieldType = 'PSEUDOYIELD_GOVERNOR'; -- 2, R&F
--区域倾向，原版风云是8.0，1.34版本AI是5.0
update PseudoYields set DefaultValue = 7.0 where PseudoYieldType = 'PSEUDOYIELD_DISTRICT'; -- 	3.5 => 8 in NFP, AI+ = 6.7! check if this helps with Holy Sites - this is the earliest available district! 210616 changed to 5.0, 8 seems too much
--世界上的不满传播
update PseudoYields set DefaultValue = -0.25 where PseudoYieldType = 'PSEUDOYIELD_DIPLOMATIC_GRIEVANCE';
--奇观倾向
update PseudoYields set DefaultValue = 1.1 where PseudoYieldType = 'PSEUDOYIELD_WONDER'; -- 2, AI+ 0.55
--间谍
update PseudoYields set DefaultValue = 1.0 where PseudoYieldType = 'PSEUDOYIELD_UNIT_SPY'; -- 20
--大亨、投资人
update PseudoYields set DefaultValue = 0.4 where PseudoYieldType = 'PSEUDOYIELD_UNIT_LEU_TYCOON'; 
update PseudoYields set DefaultValue = 0.2 where PseudoYieldType = 'PSEUDOYIELD_UNIT_LEU_INVESTOR';
--------------------------------------------------------------
--神级AI不爱莫克夏,临时方案
insert or replace into GovernorPromotionModifiers 
	(GovernorPromotionType,                  ModifierId) 
values
	('GOVERNOR_PROMOTION_CARDINAL_BISHOP',   'BISHOP_AI_LESS_FAITH_POP');
insert or replace into Modifiers    
	(ModifierId,                             ModifierType,                                    Permanent,  SubjectRequirementSetId)
values
	('BISHOP_AI_LESS_FAITH_POP',              'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION', 0,  'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI');
insert or replace into ModifierArguments
	(ModifierId,                              Name,                   Value)
values
	('BISHOP_AI_LESS_FAITH_POP',               'YieldType',            'YIELD_FAITH'),
	('BISHOP_AI_LESS_FAITH_POP',               'Amount',               -1);

insert or replace into GovernorPromotionModifiers 
	(GovernorPromotionType,                  ModifierId) 
values
	('GOVERNOR_PROMOTION_CARDINAL_BISHOP',   'BISHOP_AI_LESS_PROHET');
insert or replace into Modifiers    
	(ModifierId,                             ModifierType,                                    Permanent,  SubjectRequirementSetId)
values
	('BISHOP_AI_LESS_PROHET',				'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT', 0,  'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI');
insert or replace into ModifierArguments
	(ModifierId,                              Name,                   			Value)
values
	('BISHOP_AI_LESS_PROHET',               'GreatPersonClassType',            'GREAT_PERSON_CLASS_PROPHET'),
	('BISHOP_AI_LESS_PROHET',               'Amount',               			-3);

-- 神级ai过时代送移民
-- insert or replace into TraitModifiers
-- 	(TraitType,										ModifierId)
-- select
-- 	'TRAIT_LEADER_MAJOR_CIV',			'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_SETTLER'
-- from Eras where EraType != 'ERA_ANCIENT';

-- insert or replace into Modifiers
-- 	(ModifierId,																						ModifierType,															OwnerRequirementSetId)
-- select
-- 	'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_SETTLER',		'MODIFIER_PLAYER_GRANT_UNIT_IN_CAPITAL',	'PLAYER_IS_HIGH_DIFFICULTY_AI_AT_LEAST_' || EraType
-- from Eras where EraType != 'ERA_ANCIENT';

-- insert or replace into ModifierArguments
-- 	(ModifierId,																						Name,					Value)
-- select
-- 	'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_SETTLER',		'UnitType',		'UNIT_SETTLER'
-- from Eras where EraType != 'ERA_ANCIENT';

-- insert or replace into ModifierArguments
-- 	(ModifierId,																						Name,					Value)
-- select
-- 	'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_SETTLER',		'Amount',			1
-- from Eras where EraType != 'ERA_ANCIENT';

-- insert or replace into ModifierArguments
-- 	(ModifierId,																						Name,										Value)
-- select
-- 	'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_SETTLER',		'AllowUniqueOverride',	0
-- from Eras where EraType != 'ERA_ANCIENT';

-- 神级ai古典送工人
-- insert or replace into TraitModifiers
-- 	(TraitType,										ModifierId)
-- select
-- 	'TRAIT_LEADER_MAJOR_CIV',			'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_BUILDER'
-- from Eras where EraType == 'ERA_CLASSICAL';

-- insert or replace into Modifiers
-- 	(ModifierId,																						ModifierType,																	OwnerRequirementSetId)
-- select
-- 	'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_BUILDER',		'MODIFIER_PLAYER_CITIES_GRANT_UNIT_IN_CITY',	'PLAYER_IS_HIGH_DIFFICULTY_AI_AT_LEAST_' || EraType
-- from Eras where EraType == 'ERA_CLASSICAL';

-- insert or replace into ModifierArguments
-- 	(ModifierId,																						Name,					Value)
-- select
-- 	'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_BUILDER',		'UnitType',		'UNIT_BUILDER'
-- from Eras where EraType == 'ERA_CLASSICAL';

-- insert or replace into ModifierArguments
-- 	(ModifierId,																						Name,					Value)
-- select
-- 	'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_BUILDER',		'Amount',			1
-- from Eras where EraType == 'ERA_CLASSICAL';

-- insert or replace into ModifierArguments
-- 	(ModifierId,																						Name,										Value)
-- select
-- 	'AI_HIGH_DIFFICULTY_' || EraType || '_EXTRA_BUILDER',		'AllowUniqueOverride',	0
-- from Eras where EraType == 'ERA_CLASSICAL';