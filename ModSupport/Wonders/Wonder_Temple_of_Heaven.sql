-- 天坛
update Buildings set PrereqTech = 'TECH_ASTRONOMY' where BuildingType = 'BUILDING_PHANTA_TEMPLE_OF_HEAVEN';

insert or replace into Building_GreatPersonPoints (BuildingType, GreatPersonClassType, PointsPerTurn) values
  ('BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'GREAT_PERSON_CLASS_ENGINEER', 2);

insert or ignore into HD_Building_Base_On_ResourceClassification (BuildingType, ResourceClassificationType, DetectRange, PropertyKey) values
  ('BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'RESOURCE_CLASSIFICATION_HD_CROPS',        'PLAYER', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_CITY_YIELDS'),
  ('BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'RESOURCE_CLASSIFICATION_HD_VEGETABLE',    'PLAYER', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_CITY_YIELDS'),
  ('BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'RESOURCE_CLASSIFICATION_HD_AGRICULTURE',  'PLAYER', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE'),
  ('BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'RESOURCE_CLASSIFICATION_HD_TRANSIT',      'PLAYER', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE'),
  ('BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'RESOURCE_CLASSIFICATION_HD_BEVERAGE',     'PLAYER', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_INTERNATIONAL_TRADE'),
  ('BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'RESOURCE_CLASSIFICATION_HD_SEASONING',    'PLAYER', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_INTERNATIONAL_TRADE');

insert or replace into HD_Binary_Compress_Keys (Key, MaxExp) values
	('HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_CITY_YIELDS',         5),
	('HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE',      4),
	('HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_INTERNATIONAL_TRADE', 4);

-- 城市产出
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
  'BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'HD_TEMPLE_OF_HEAVEN_CITY_CULTURE_' || Exp
from HD_Binary_Compress where Exp < 6;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_TEMPLE_OF_HEAVEN_CITY_CULTURE_' || Exp, 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_CITY_YIELDS_' || Exp || '_REQUIREMENTS'
from HD_Binary_Compress where Exp < 6;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_CITY_CULTURE_' || Exp, 'YieldType', 'YIELD_CULTURE'
from HD_Binary_Compress where Exp < 6;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_CITY_CULTURE_' || Exp, 'Amount', Amount
from HD_Binary_Compress where Exp < 6;

insert or replace into BuildingModifiers (BuildingType, ModifierId) select
  'BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'HD_TEMPLE_OF_HEAVEN_CITY_FAITH_' || Exp
from HD_Binary_Compress where Exp < 6;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_TEMPLE_OF_HEAVEN_CITY_FAITH_' || Exp, 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_CITY_YIELDS_' || Exp || '_REQUIREMENTS'
from HD_Binary_Compress where Exp < 6;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_CITY_FAITH_' || Exp, 'YieldType', 'YIELD_FAITH'
from HD_Binary_Compress where Exp < 6;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_CITY_FAITH_' || Exp, 'Amount', Amount
from HD_Binary_Compress where Exp < 6;

-- 内商
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
  'BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'HD_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_FOOD_' || Exp
from HD_Binary_Compress where Exp < 5;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_FOOD_' || Exp, 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_DOMESTIC', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_' || Exp || '_REQUIREMENTS'
from HD_Binary_Compress where Exp < 5;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_FOOD_' || Exp, 'YieldType', 'YIELD_FOOD'
from HD_Binary_Compress where Exp < 5;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_FOOD_' || Exp, 'Amount', Amount
from HD_Binary_Compress where Exp < 5;

insert or replace into BuildingModifiers (BuildingType, ModifierId) select
  'BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'HD_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_PRODUCTION_' || Exp
from HD_Binary_Compress where Exp < 5;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_PRODUCTION_' || Exp, 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_DOMESTIC', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_' || Exp || '_REQUIREMENTS'
from HD_Binary_Compress where Exp < 5;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_PRODUCTION_' || Exp, 'YieldType', 'YIELD_PRODUCTION'
from HD_Binary_Compress where Exp < 5;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_DOMESTIC_TRADE_PRODUCTION_' || Exp, 'Amount', Amount
from HD_Binary_Compress where Exp < 5;

-- 外商
insert or replace into BuildingModifiers (BuildingType, ModifierId) select
  'BUILDING_PHANTA_TEMPLE_OF_HEAVEN', 'HD_TEMPLE_OF_HEAVEN_INTERNATIONAL_TRADE_GOLD_' || Exp
from HD_Binary_Compress where Exp < 5;

insert or replace into Modifiers (ModifierId, ModifierType, OwnerRequirementSetId) select
  'HD_TEMPLE_OF_HEAVEN_INTERNATIONAL_TRADE_GOLD_' || Exp, 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL', 'HD_PLOT_BINARY_COMPRESS_TEMPLE_OF_HEAVEN_INTERNATIONAL_TRADE_' || Exp || '_REQUIREMENTS'
from HD_Binary_Compress where Exp < 5;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_INTERNATIONAL_TRADE_GOLD_' || Exp, 'YieldType', 'YIELD_GOLD'
from HD_Binary_Compress where Exp < 5;

insert or replace into ModifierArguments (ModifierId, Name, Value) select
  'HD_TEMPLE_OF_HEAVEN_INTERNATIONAL_TRADE_GOLD_' || Exp, 'Amount', Amount * 6
from HD_Binary_Compress where Exp < 5;