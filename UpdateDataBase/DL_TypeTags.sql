--------------------------------------------------
--TypeTags dacaogu-------------------------------
insert or replace into TypeTags
	(Type,									Tag)
values
	('UNIT_HUNGARY_BLACK_ARMY',				'CLASS_DACAOGU'),
	('UNIT_HORSEMAN',						'CLASS_DACAOGU'),
	('UNIT_COURSER',						'CLASS_DACAOGU');

insert or replace into Tags
	(Tag,									Vocabulary)
values
	('CLASS_DACAOGU',						'ABILITY_CLASS');
---------------------------------------------------
--TypeTags all millitary units---------------------
insert or replace into TypeTags(Type,Tag)
select UnitType ,'CLASS_LAND_COMBAT' from Units where FormationClass = 'FORMATION_CLASS_LAND_COMBAT';
insert or replace into TypeTags(Type,Tag)
select UnitType ,'CLASS_LAND_UNITS' from Units where Domain = 'DOMAIN_LAND';
insert or replace into TypeTags(Type,Tag)
select UnitType ,'CLASS_NAVAL' from Units where FormationClass = 'FORMATION_CLASS_NAVAL';
insert or replace into TypeTags(Type,Tag)
select UnitType ,'CLASS_AIR' from Units where FormationClass = 'FORMATION_CLASS_AIR';
insert or replace into TypeTags(Type,Tag)
select UnitType ,'CLASS_MILITARY' from Units where FormationClass != 'FORMATION_CLASS_CIVILIAN' AND FormationClass != 'FORMATION_CLASS_SUPPORT';


insert or replace into TypeTags(Type,Tag)
select UnitType ,'CLASS_KEQING_BUFF_UNITS' from Units where Domain = 'DOMAIN_LAND'
	and (PromotionClass is NULL or PromotionClass not in ('PROMOTION_CLASS_LIGHT_CAVALRY', 'PROMOTION_CLASS_HEAVY_CAVALRY'))
	and UnitType != 'UNIT_KEQING';

insert or replace into TypeTags(Type,Tag)
select UnitType ,'CLASS_KEQING_BUFF_MILITARY' from Units where FormationClass = 'FORMATION_CLASS_LAND_COMBAT'
	and PromotionClass not in ('PROMOTION_CLASS_LIGHT_CAVALRY', 'PROMOTION_CLASS_HEAVY_CAVALRY')
	and UnitType != 'UNIT_KEQING';

insert or replace into Tags
	(Tag,									Vocabulary)
values
	('CLASS_HD_GAIN_SCIENCE_WHEN_KILLS',	'ABILITY_CLASS'),
	('CLASS_HD_CAN_MOVE_AFTER_ATTACK',		'ABILITY_CLASS'),
	('CLASS_MILITARY_ENGINEER',				'ABILITY_CLASS'),
	('CLASS_MILITARY',						'ABILITY_CLASS'),
	('CLASS_LAND_UNITS',					'ABILITY_CLASS'),
	('CLASS_AIR',							'ABILITY_CLASS'),
	('CLASS_NAVAL',							'ABILITY_CLASS'),
	('CLASS_LAND_COMBAT',					'ABILITY_CLASS'),
	('CLASS_WALL_ATTACK',	'ABILITY_CLASS'),
	('CLASS_KEQING_BUFF_UNITS',	'ABILITY_CLASS'),
	('CLASS_KEQING_BUFF_MILITARY',	'ABILITY_CLASS');

insert or replace into TypeTags
	(Type,									Tag)
values
	('UNIT_MILITARY_ENGINEER', 'CLASS_MILITARY_ENGINEER');
------------------------------------------------------------------------
--typetags warrior monks------
insert or replace into TypeTags
 	(Type,									Tag)
values
 	('UNIT_WARRIOR_MONK',				'CLASS_ALL_ERAS');
----------------------------------------------------------------------
-- 从陆地平民删除宗教单位
delete from TypeTags where Type in (
	'UNIT_MISSIONARY', 'UNIT_APOSTLE', 'UNIT_INQUISITOR', 'UNIT_GURU'
) and Tag = 'CLASS_LANDCIVILIAN';

-- 战车攻城
insert or replace into TypeTags
	(Type,									Tag)
values
	('UNIT_SUMERIAN_WAR_CART',				'CLASS_HEAVY_CAVALRY'),
	('UNIT_SUMERIAN_WAR_CART',				'CLASS_WALL_ATTACK'),
	('ABILITY_ENABLE_WALL_ATTACK',		'CLASS_WALL_ATTACK');

-- bug fix
-- 大灯塔文本 龙骨船 毛利 越南
delete from TypeTags where Type = 'ABILITY_GREAT_LIGHTHOUSE_EMBARKED_MOVEMENT';
delete from TypeTags where Type = 'ABILITY_KNARR_IGNORE_EMBARK_DISEMBARK_COST';
delete from TypeTags where Type = 'ABILITY_MANA';
delete from TypeTags where Type = 'ABILITY_TRIEU_FEATURES';

insert or ignore into TypeTags (Type, Tag)
	select UnitAbilityType, 'CLASS_LAND_UNITS'
from UnitAbilities where UnitAbilityType in (
	'ABILITY_GREAT_LIGHTHOUSE_EMBARKED_MOVEMENT',
	'ABILITY_KNARR_IGNORE_EMBARK_DISEMBARK_COST',
	'ABILITY_MANA',
	'ABILITY_TRIEU_FEATURES'
);