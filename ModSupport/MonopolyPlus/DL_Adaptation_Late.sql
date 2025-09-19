-- 火车站特效
--   -- 相邻区域相邻加成
-- insert or ignore into ImprovementModifiers
--   (ImprovementType,               ModifierId)
-- select
--   'IMPROVEMENT_LEU_STATION',      'HD_STATION_' || DistrictType || '_BONUS'
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- insert or ignore into Modifiers
--   (ModifierId,                                ModifierType,                                       SubjectRequirementSetId)
-- select
--   'HD_STATION_' || DistrictType || '_BONUS',  'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',    'HD_DISTRICT_IS_' || DistrictType || '_ADJACENT'
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- insert or ignore into ModifierArguments
--   (ModifierId,                                Name,           Value)
-- select
--   'HD_STATION_' || DistrictType || '_BONUS',  'YieldType',    YieldType
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- insert or ignore into ModifierArguments
--   (ModifierId,                                Name,           Value)
-- select
--   'HD_STATION_' || DistrictType || '_BONUS',  'Amount',       50
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

--   -- 相邻区域相邻加成 供电
-- insert or ignore into ImprovementModifiers
--   (ImprovementType,               ModifierId)
-- select
--   'IMPROVEMENT_LEU_STATION',      'HD_STATION_' || DistrictType || '_BONUS_POWERED'
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- insert or ignore into Modifiers
--   (ModifierId,                                        ModifierType,                                       OwnerRequirementSetId,  SubjectRequirementSetId)
-- select
--   'HD_STATION_' || DistrictType || '_BONUS_POWERED',  'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_MODIFIER',  'CITY_IS_POWERED',      'HD_DISTRICT_IS_' || DistrictType || '_ADJACENT'
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- insert or ignore into ModifierArguments
--   (ModifierId,                                        Name,           Value)
-- select
--   'HD_STATION_' || DistrictType || '_BONUS_POWERED',  'YieldType',    YieldType
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- insert or ignore into ModifierArguments
--   (ModifierId,                                        Name,           Value)
-- select
--   'HD_STATION_' || DistrictType || '_BONUS_POWERED',  'Amount',       50
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

  -- 相邻区域给外商产出
insert or ignore into ImprovementModifiers
  (ImprovementType,               ModifierId)
select
  'IMPROVEMENT_LEU_STATION',      'HD_STATION_' || DistrictType || '_INTERNATIONAL_TRADE_BONUS'
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1 or DistrictType = 'DISTRICT_AQUEDUCT';

insert or ignore into Modifiers
  (ModifierId,                                                    ModifierType,                                                         OwnerRequirementSetId)
select
  'HD_STATION_' || DistrictType || '_INTERNATIONAL_TRADE_BONUS',  'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',    'PLOT_ADJACENT_TO_' || DistrictType || '_REQUIREMENTS'
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1 or DistrictType = 'DISTRICT_AQUEDUCT';

insert or ignore into ModifierArguments
  (ModifierId,                                                        Name,           Value)
select
  'HD_STATION_' || DistrictType || '_INTERNATIONAL_TRADE_BONUS',      'YieldType',    YieldType
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1 or DistrictType = 'DISTRICT_AQUEDUCT';

insert or ignore into ModifierArguments
  (ModifierId,                                                        Name,           Value)
select
  'HD_STATION_' || DistrictType || '_INTERNATIONAL_TRADE_BONUS',      'Amount',       Amount
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1 or DistrictType = 'DISTRICT_AQUEDUCT';

  -- 相邻区域给外商产出 供电
insert or ignore into ImprovementModifiers
  (ImprovementType,               ModifierId)
select
  'IMPROVEMENT_LEU_STATION',      'HD_STATION_' || DistrictType || '_INTERNATIONAL_TRADE_BONUS_POWERED'
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1 or DistrictType = 'DISTRICT_AQUEDUCT';

insert or ignore into Modifiers
  (ModifierId,                                                            ModifierType,                                                         OwnerRequirementSetId,                                    SubjectRequirementSetId)
select
  'HD_STATION_' || DistrictType || '_INTERNATIONAL_TRADE_BONUS_POWERED',  'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',    'PLOT_ADJACENT_TO_' || DistrictType || '_REQUIREMENTS',   'CITY_IS_POWERED'
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1 or DistrictType = 'DISTRICT_AQUEDUCT';

insert or ignore into ModifierArguments
  (ModifierId,                                                                Name,           Value)
select
  'HD_STATION_' || DistrictType || '_INTERNATIONAL_TRADE_BONUS_POWERED',      'YieldType',    YieldType
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1 or DistrictType = 'DISTRICT_AQUEDUCT';

insert or ignore into ModifierArguments
  (ModifierId,                                                                Name,           Value)
select
  'HD_STATION_' || DistrictType || '_INTERNATIONAL_TRADE_BONUS_POWERED',      'Amount',       Amount
from DistrictCorrespondingYieldType_HD where RequiresPopulation = 1 or DistrictType = 'DISTRICT_AQUEDUCT';

-- 尤里卡
update Boosts set BoostClass = 'BOOST_TRIGGER_HAVE_X_IMPROVEMENTS', ImprovementType = 'IMPROVEMENT_LEU_STATION', NumItems = 2, TriggerDescription = 'LOC_BOOST_TRIGGER_INTEGRATED_CIRCUIT_HD_LEU',
  TriggerLongDescription = 'LOC_BOOST_TRIGGER_LONGDESC_INTEGRATED_CIRCUIT_HD_LEU'
where TechnologyType = 'TECH_INTEGRATED_CIRCUIT_HD';