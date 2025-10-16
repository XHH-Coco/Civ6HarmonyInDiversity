insert or ignore into HD_DistrictClassificationTypes (DistrictClassificationType, SortIndex) values
  ('DISTRICT_CLASSIFICATION_TRANSPORTATION_FACILITIES',     0),
  ('DISTRICT_CLASSIFICATION_WATER_CONSERVANCY_FACILITIES',  1),
  ('DISTRICT_CLASSIFICATION_TOURISM_FACILITIES',            2);

update HD_DistrictClassificationTypes set Name = 'LOC_' || DistrictClassificationType || '_NAME' where Name is NULL;

-- 交通设施
insert or ignore into HD_District_Classification (DistrictType, DistrictClassificationType) select
  DistrictType, 'DISTRICT_CLASSIFICATION_TRANSPORTATION_FACILITIES'
from Districts where DistrictType in (
  'DISTRICT_HARBOR',
  'DISTRICT_AERODROME',
  'DISTRICT_CANAL'
);

-- 水利设施
insert or ignore into HD_District_Classification (DistrictType, DistrictClassificationType) select
  DistrictType, 'DISTRICT_CLASSIFICATION_WATER_CONSERVANCY_FACILITIES'
from Districts where DistrictType in (
  'DISTRICT_AQUEDUCT',
  'DISTRICT_CANAL',
  'DISTRICT_DAM'
);

-- 旅游设施
insert or ignore into HD_District_Classification (DistrictType, DistrictClassificationType) select
  DistrictType, 'DISTRICT_CLASSIFICATION_TOURISM_FACILITIES'
from Districts where DistrictType in (
  'DISTRICT_ENTERTAINMENT_COMPLEX',
  'DISTRICT_WATER_ENTERTAINMENT_COMPLEX'
);

-- 适配UD
insert or ignore into HD_District_Classification (DistrictType, DistrictClassificationType) select
  b.CivUniqueDistrictType, a.DistrictClassificationType
from HD_District_Classification a inner join DistrictReplaces b on a.DistrictType = b.ReplacesDistrictType where CivUniqueDistrictType not in (
  'DISTRICT_SUK_TORFBAEIR'
);