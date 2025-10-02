insert or ignore into HD_BuildingClassificationTypes (BuildingClassificationType, SortIndex) values
  ('BUILDING_CLASSIFICATION_TRANSPORTATION_FACILITIES', 0);

update HD_BuildingClassificationTypes set Name = 'LOC_' || BuildingClassificationType || '_NAME' where Name is NULL;

-- 交通设施
insert or ignore into HD_Building_Classification (BuildingType, BuildingClassificationType) select
  BuildingType, 'BUILDING_CLASSIFICATION_TRANSPORTATION_FACILITIES'
from Buildings where BuildingType in (
  'BUILDING_HD_BUS_STOP',
  'BUILDING_JNR_TRANSIT_HUB',
  'BUILDING_SEAPORT',
  'BUILDING_JNR_OFFSHORE_TERMINAL',
  'BUILDING_AIRPORT'
);

insert or ignore into HD_Building_Classification (BuildingType, BuildingClassificationType) select
  BuildingType, 'BUILDING_CLASSIFICATION_TRANSPORTATION_FACILITIES'
from Buildings_XP2 where Bridge = 1 or CanalWonder = 1;