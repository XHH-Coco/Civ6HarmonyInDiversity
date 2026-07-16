-- 雄伟工程
insert or ignore into GovernorPromotionModifiers (GovernorPromotionType, ModifierId) select
	'GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_2', 'HD_GOVERNOR_BUILDER_RIGHT_2_' || BuildingType || '_' || YieldType
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1);

insert or ignore into Modifiers (ModifierId, ModifierType) select
  'HD_GOVERNOR_BUILDER_RIGHT_2_' || BuildingType || '_' || YieldType, 'MODIFIER_BUILDING_YIELD_CHANGE'
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1);

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_RIGHT_2_' || BuildingType || '_' || YieldType, 'BuildingType', BuildingType
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1);

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_RIGHT_2_' || BuildingType || '_' || YieldType, 'YieldType', YieldType
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1);

insert or ignore into ModifierArguments (ModifierId, Name, Value) select
  'HD_GOVERNOR_BUILDER_RIGHT_2_' || BuildingType || '_' || YieldType, 'Amount', YieldChange
from Building_YieldChanges where BuildingType in (select BuildingType from Buildings where IsWonder = 1);