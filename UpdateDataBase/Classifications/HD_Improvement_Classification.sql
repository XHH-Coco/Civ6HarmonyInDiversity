insert or ignore into HD_ImprovementClassificationTypes (ImprovementClassificationType, SortIndex) values
  ('IMPROVEMENT_CLASSIFICATION_BASIC',                      0),
  ('IMPROVEMENT_CLASSIFICATION_WATER',                      1),
  ('IMPROVEMENT_CLASSIFICATION_UNIQUE',                     2),
  ('IMPROVEMENT_CLASSIFICATION_CITYSTATE',                  3),

  ('IMPROVEMENT_CLASSIFICATION_AGRARIAN',                   4),
  ('IMPROVEMENT_CLASSIFICATION_EXPLOITATIVE',               5),
  ('IMPROVEMENT_CLASSIFICATION_EDUCATIONAL',                6),
  ('IMPROVEMENT_CLASSIFICATION_HUMANITIES',                 7),
  ('IMPROVEMENT_CLASSIFICATION_MILITARISTIC',               8),
  ('IMPROVEMENT_CLASSIFICATION_COMMERCIAL',                 9),
  ('IMPROVEMENT_CLASSIFICATION_RESIDENTIAL',                10),
  ('IMPROVEMENT_CLASSIFICATION_RELIGIOUS',                  11),
  ('IMPROVEMENT_CLASSIFICATION_LANDSCAPE',                  12),
  ('IMPROVEMENT_CLASSIFICATION_ENTERTAINING',               13),
  ('IMPROVEMENT_CLASSIFICATION_HYDRAULIC',                  14),
  ('IMPROVEMENT_CLASSIFICATION_TRANSPOTATION',              15),
  ('IMPROVEMENT_CLASSIFICATION_RENEWABLE',                  16),
  
  ('IMPROVEMENT_CLASSIFICATION_OTHER',                      90);

update HD_ImprovementClassificationTypes set Name = 'LOC_' || ImprovementClassificationType || '_NAME' where Name is NULL;

-- ==========================================================================================================================================
-- ==========================================================================================================================================
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
  'IMPROVEMENT_OIL_WELL',
  'IMPROVEMENT_OFFSHORE_OIL_RIG',
  'IMPROVEMENT_FISHERY'
);

-- 水上改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_WATER'
from Improvements where Domain = 'DOMAIN_SEA' and BarbarianCamp = 0 and Goody = 0;

-- 特色改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_UNIQUE'
from Improvements where TraitType is not Null and TraitType not like 'MINOR_%' and BarbarianCamp = 0 and Goody = 0
  and TraitType not in ('TRAIT_BARBARIAN','TRAIT_CIVILIZATION_NO_PLAYER');

-- 城邦特色改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_CITYSTATE'
from Improvements where TraitType is not Null and TraitType like 'MINOR_%' and BarbarianCamp = 0 and Goody = 0;

-- ==========================================================================================================================================
-- ==========================================================================================================================================
-- 农业生产改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_AGRARIAN'
from Improvements where ImprovementType in (
  'IMPROVEMENT_FARM',
  'IMPROVEMENT_FISHING_BOATS',
  'IMPROVEMENT_PASTURE',
  'IMPROVEMENT_PLANTATION',
  'IMPROVEMENT_CAMP',
  'IMPROVEMENT_FISHERY',

  'IMPROVEMENT_CHATEAU',
  'IMPROVEMENT_OUTBACK_STATION',
  'IMPROVEMENT_POLDER',
  'IMPROVEMENT_TERRACE_FARM',
  'IMPROVEMENT_HACIENDA',
  'IMPROVEMENT_KAMPUNG',
  'IMPROVEMENT_MEKEWAP',
  'IMPROVEMENT_LAND_POLDER'
);

-- 工业开发改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_EXPLOITATIVE'
from Improvements where ImprovementType in (
  'IMPROVEMENT_MINE',
  'IMPROVEMENT_QUARRY',
  'IMPROVEMENT_LUMBER_MILL',
  'IMPROVEMENT_OIL_WELL',
  'IMPROVEMENT_OFFSHORE_OIL_RIG',
  'IMPROVEMENT_GEOTHERMAL_PLANT',
  'IMPROVEMENT_SOLAR_FARM',
  'IMPROVEMENT_WIND_FARM',
  'IMPROVEMENT_OFFSHORE_WIND_FARM',
  'IMPROVEMENT_INDUSTRY',
  'IMPROVEMENT_INDUSTRY_BONUS',
  'IMPROVEMENT_INDUSTRY_STRATEGIC',
  'IMPROVEMENT_CORPORATION',
  'IMPROVEMENT_CORPORATION_BONUS',
  'IMPROVEMENT_CORPORATION_STRATEGIC',
  'IMPROVEMENT_LEU_WAREHOUSE',
  'IMPROVEMENT_LEU_CONTAINER_PORT',
  'IMPROVEMENT_LEU_TRANSNATIONAL',
  'IMPROVEMENT_LEU_TRANSNATIONAL_SEA',

  'IMPROVEMENT_ZIGGURAT',
  'IMPROVEMENT_FEITORIA'
);

-- 研究教育改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_EDUCATIONAL'
from Improvements where ImprovementType in (
  'IMPROVEMENT_MAHAVIHARA',
  'IMPROVEMENT_JNR_OASIS_FARM',

  'IMPROVEMENT_MISSION',
  'IMPROVEMENT_ALCAZAR',
  'IMPROVEMENT_PAIRIDAEZA',
  'IMPROVEMENT_OPEN_AIR_MUSEUM'
);

-- 人文社科改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_HUMANITIES'
from Improvements where ImprovementType in (
  'IMPROVEMENT_BATEY',
  'IMPROVEMENT_CHEMAMULL',
  'IMPROVEMENT_COLOSSAL_HEAD',
  'IMPROVEMENT_KURGAN',
  'IMPROVEMENT_MOAI',
  'IMPROVEMENT_NAZCA_LINE',
  'IMPROVEMENT_OPEN_AIR_MUSEUM',
  'IMPROVEMENT_PAIRIDAEZA',
  'IMPROVEMENT_PYRAMID',
  'IMPROVEMENT_ROCK_HEWN_CHURCH',
  'IMPROVEMENT_ROMAN_FORT',
  'IMPROVEMENT_SPHINX'
);

-- 军事屯驻改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_MILITARISTIC'
from Improvements where ImprovementType in (
  'IMPROVEMENT_FORT',
  'IMPROVEMENT_AIRSTRIP',
  'IMPROVEMENT_MISSILE_SILO',
  'IMPROVEMENT_SAILOR_WATCHTOWER',

  'IMPROVEMENT_GREAT_WALL',
  'IMPROVEMENT_ROMAN_FORT',
  'IMPROVEMENT_ALCAZAR',
  'IMPROVEMENT_MAORI_PA'
);

-- 贸易往来改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_COMMERCIAL'
from Improvements where ImprovementType in (
  'IMPROVEMENT_MOUNTAIN_TUNNEL',
  'IMPROVEMENT_INDUSTRY',
  'IMPROVEMENT_INDUSTRY_BONUS',
  'IMPROVEMENT_INDUSTRY_STRATEGIC',
  'IMPROVEMENT_CORPORATION',
  'IMPROVEMENT_CORPORATION_BONUS',
  'IMPROVEMENT_CORPORATION_STRATEGIC',
  'IMPROVEMENT_TRADING_DOME',
  'IMPROVEMENT_LEU_WAREHOUSE',
  'IMPROVEMENT_LEU_CONTAINER_PORT',
  'IMPROVEMENT_LEU_STATION',
  'IMPROVEMENT_LEU_TRANSNATIONAL',
  'IMPROVEMENT_LEU_TRANSNATIONAL_SEA',

  'IMPROVEMENT_MOUNTAIN_ROAD',
  'IMPROVEMENT_FEITORIA',
  'IMPROVEMENT_GEDEMO_DZIMBABWE'
);

-- 民居宅邸改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_RESIDENTIAL'
from Improvements where ImprovementType in (
  'IMPROVEMENT_MONASTERY',
  'IMPROVEMENT_SEASTEAD',
  'IMPROVEMENT_JNR_REED_HOME',
  'IMPROVEMENT_TRADING_DOME',

  'IMPROVEMENT_CHATEAU',
  'IMPROVEMENT_STEPWELL',
  'IMPROVEMENT_KAMPUNG',
  'IMPROVEMENT_OUTBACK_STATION',
  'IMPROVEMENT_MEKEWAP',
  'IMPROVEMENT_MOUND',
  'IMPROVEMENT_TERRACE_FARM',
  'IMPROVEMENT_MAORI_PA',
  'IMPROVEMENT_HACIENDA',
  'IMPROVEMENT_CVS_BERBER_UI'
);

-- 宗教场所改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_RELIGIOUS'
from Improvements where ImprovementType in (
  'IMPROVEMENT_MONASTERY',
  'IMPROVEMENT_MAHAVIHARA',

  'IMPROVEMENT_COLOSSAL_HEAD',
  'IMPROVEMENT_KURGAN',
  'IMPROVEMENT_MISSION',
  'IMPROVEMENT_SPHINX',
  'IMPROVEMENT_ZIGGURAT',
  'IMPROVEMENT_PYRAMID',
  'IMPROVEMENT_CHEMAMULL',
  'IMPROVEMENT_MOAI',
  'IMPROVEMENT_MOUND',
  'IMPROVEMENT_NAZCA_LINE',
  'IMPROVEMENT_ROCK_HEWN_CHURCH',
  'IMPROVEMENT_GEDEMO_DZIMBABWE'
);

-- 旅游景观改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_LANDSCAPE'
from Improvements where ImprovementType in (
  'IMPROVEMENT_BEACH_RESORT',
  'IMPROVEMENT_CITY_PARK',
  'IMPROVEMENT_SEASTEAD',
  'IMPROVEMENT_SKI_RESORT',
  'IMPROVEMENT_JNR_OASIS_FARM',
  'IMPROVEMENT_JNR_REED_HOME',

  'IMPROVEMENT_GREAT_WALL',
  'IMPROVEMENT_GOLF_COURSE',
  'IMPROVEMENT_ICE_HOCKEY_RINK'
);

-- 娱乐活动改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_ENTERTAINING'
from Improvements where ImprovementType in (
  'IMPROVEMENT_BEACH_RESORT',
  'IMPROVEMENT_CITY_PARK',
  'IMPROVEMENT_SKI_RESORT',

  'IMPROVEMENT_GOLF_COURSE',
  'IMPROVEMENT_ICE_HOCKEY_RINK',
  'IMPROVEMENT_BATEY'
);

-- 水利工程改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_HYDRAULIC'
from Improvements where ImprovementType in (
  'IMPROVEMENT_STEPWELL',
  'IMPROVEMENT_POLDER',
  'IMPROVEMENT_LAND_POLDER',
  'IMPROVEMENT_CVS_BERBER_UI'
);

-- 交通设施改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_TRANSPOTATION'
from Improvements where ImprovementType in (
  'IMPROVEMENT_MOUNTAIN_TUNNEL',
  'IMPROVEMENT_LEU_STATION',

  'IMPROVEMENT_MOUNTAIN_ROAD'
);

-- 清洁能源改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_RENEWABLE'
from Improvements where ImprovementType in (
  'IMPROVEMENT_GEOTHERMAL_PLANT',
  'IMPROVEMENT_SOLAR_FARM',
  'IMPROVEMENT_WIND_FARM',
  'IMPROVEMENT_OFFSHORE_WIND_FARM'
);

-- ==========================================================================================================================================
-- ==========================================================================================================================================
-- 其他改良
insert or ignore into HD_Improvement_Classification (ImprovementType, ImprovementClassificationType) select
  ImprovementType, 'IMPROVEMENT_CLASSIFICATION_OTHER'
from Improvements where ImprovementType not in (select ImprovementType from HD_Improvement_Classification) and BarbarianCamp = 0 and Goody = 0;