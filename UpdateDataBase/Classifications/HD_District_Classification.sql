insert or ignore into HD_DistrictClassificationTypes (DistrictClassificationType, SortIndex) values
  ('DISTRICT_CLASSIFICATION_TRANSPORTATION_FACILITIES', 0);

update HD_DistrictClassificationTypes set Name = 'LOC_' || DistrictClassificationType || '_NAME' where Name is NULL;

-- 交通设施
insert or ignore into HD_District_Classification (DistrictType, DistrictClassificationType) select
  DistrictType, 'DISTRICT_CLASSIFICATION_TRANSPORTATION_FACILITIES'
from Districts where DistrictType in (
  'DISTRICT_HARBOR',
  'DISTRICT_AERODROME',
  'DISTRICT_CANAL'
);

-- 适配UD
insert or ignore into HD_District_Classification (DistrictType, DistrictClassificationType) select
  b.CivUniqueDistrictType, a.DistrictClassificationType
from HD_District_Classification a inner join DistrictReplaces b on a.DistrictType = b.ReplacesDistrictType;