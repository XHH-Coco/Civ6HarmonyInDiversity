-- 纺织会馆
delete from BuildingReplaces where CivUniqueBuildingType = 'BUILDING_SUKIENNICE';

insert or replace into MutuallyExclusiveBuildings (Building, MutuallyExclusiveBuilding) values
	('BUILDING_SUKIENNICE', 'BUILDING_MARKET'),
	('BUILDING_MARKET', 'BUILDING_SUKIENNICE');

insert or ignore into BuildingPrereqs (Building, PrereqBuilding) select
	Building, 'BUILDING_SUKIENNICE'
from BuildingPrereqs where PrereqBuilding = 'BUILDING_MARKET';