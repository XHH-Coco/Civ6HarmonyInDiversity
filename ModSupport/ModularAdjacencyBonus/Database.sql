-- 金法国
update Traits set Description = 'LOC_TRAIT_LEADER_MAGNIFICENCES_DESCRIPTION_MAB' where TraitType = 'TRAIT_LEADER_MAGNIFICENCES';
insert or replace into Ruivo_New_Adjacency
  (ID, DistrictType, YieldType, YieldChange, AdjacencyType, DistrictModifiers, TraitType, ProvideType)
select
  'HD_TRAIT_LEADER_MAGNIFICENCES_' || DistrictType || '_' || YieldType || '_FROM_CITY_SURPLUS_AMENITIES_OVER_HIGHEST_LEVEL_HAPPINESS',
  DistrictType,
  YieldType,
  0.3334,
  'FROM_CITY_SURPLUS_AMENITIES_OVER_HIGHEST_LEVEL_HAPPINESS',
  0,
  'TRAIT_LEADER_MAGNIFICENCES',
  'SelfBonus'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1 and exists (select TraitType from Traits where TraitType = 'TRAIT_LEADER_MAGNIFICENCES');