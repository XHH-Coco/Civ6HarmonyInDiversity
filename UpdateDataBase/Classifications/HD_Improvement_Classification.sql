insert or ignore into HD_ImprovementClassificationTypes (ImprovementClassificationType, SortIndex) values
  ('IMPROVEMENT_CLASSIFICATION_BASIC',                      0),
  ('IMPROVEMENT_CLASSIFICATION_UNIQUE',                     1),
  ('IMPROVEMENT_CLASSIFICATION_CITYSTATE',                  2),
  ('IMPROVEMENT_CLASSIFICATION_URBAN_FACILITIES',           3),
  ('IMPROVEMENT_CLASSIFICATION_TRANSPORTATION_FACILITIES',  4),
  ('IMPROVEMENT_CLASSIFICATION_TOURISM_FACILITIES',         5),
  ('IMPROVEMENT_CLASSIFICATION_MILITARY_FACILITIES',        6),
  ('IMPROVEMENT_CLASSIFICATION_COMMON',                     90);

update HD_ImprovementClassificationTypes set Name = 'LOC_' || ImprovementClassificationType || '_NAME' where Name is NULL;

  -- 基础改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_BASIC'
from Improvements where ImprovementType in (
  'IMPROVEMENT_FARM',
  'IMPROVEMENT_MINE',
  'IMPROVEMENT_QUARRY',
  'IMPROVEMENT_FISHING_BOATS',
  'IMPROVEMENT_PASTURE',
  'IMPROVEMENT_PLANTATION',
  'IMPROVEMENT_CAMP',
  'IMPROVEMENT_LUMBER_MILL',
  'IMPROVEMENT_FISHERY',
  'IMPROVEMENT_OIL_WELL',
  'IMPROVEMENT_OFFSHORE_OIL_RIG'
);

  -- 特色改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_UNIQUE'
from Improvements where TraitType is not Null and TraitType not like 'MINOR_%' and BarbarianCamp = 0 and Goody = 0
  and TraitType not in ('TRAIT_BARBARIAN','TRAIT_CIVILIZATION_NO_PLAYER');

  -- 城邦特色改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_CITYSTATE'
from Improvements where TraitType is not Null and TraitType like 'MINOR_%' and BarbarianCamp = 0 and Goody = 0;

  -- 城市设施改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_URBAN_FACILITIES'
from Improvements where ImprovementType in (
  'IMPROVEMENT_GEOTHERMAL_PLANT',
  'IMPROVEMENT_SOLAR_FARM',
  'IMPROVEMENT_WIND_FARM',
  'IMPROVEMENT_OFFSHORE_WIND_FARM',
  'IMPROVEMENT_MOUNTAIN_TUNNEL',
  'IMPROVEMENT_INDUSTRY',
  'IMPROVEMENT_CORPORATION',
  'IMPROVEMENT_LEU_WAREHOUSE',
  'IMPROVEMENT_LEU_CONTAINER_PORT',
  'IMPROVEMENT_LEU_STATION',
  'IMPROVEMENT_LEU_TRANSNATIONAL',
  'IMPROVEMENT_LEU_TRANSNATIONAL_SEA',
  'IMPROVEMENT_MOUNTAIN_ROAD'
);

  -- 交通设施改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_TRANSPORTATION_FACILITIES'
from Improvements where ImprovementType in (
  'IMPROVEMENT_MOUNTAIN_TUNNEL',
  'IMPROVEMENT_LEU_STATION',
  'IMPROVEMENT_MOUNTAIN_ROAD'
);

  -- 旅游设施改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_TOURISM_FACILITIES'
from Improvements where ImprovementType in (
  'IMPROVEMENT_BEACH_RESORT',
  'IMPROVEMENT_CITY_PARK',
  'IMPROVEMENT_SKI_RESORT',
  'IMPROVEMENT_SEASTEAD',
  'IMPROVEMENT_JNR_OASIS_FARM',
  'IMPROVEMENT_JNR_REED_HOME'
);

  -- 军事设施改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_MILITARY_FACILITIES'
from Improvements where ImprovementType in (
  'IMPROVEMENT_FORT',
  'IMPROVEMENT_AIRSTRIP',
  'IMPROVEMENT_MISSILE_SILO',
  'IMPROVEMENT_ROMAN_FORT',
  'IMPROVEMENT_MAORI_PA',
  'IMPROVEMENT_SAILOR_WATCHTOWER'
);

  -- 其他通用改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_COMMON'
from Improvements where ImprovementType not in (select ImprovementType from HD_Improvement_Classification) and BarbarianCamp = 0 and Goody = 0;