------------------- 特色项目与Modifier -------------------
create table if not exists UniqueProjects_HD(
  ProjectType         TEXT    not NULL,
  ModifierId          TEXT    not NULL,
  CivilizationType    TEXT,
  LeaderType          TEXT,
PRIMARY KEY('ProjectType', 'ModifierId', 'CivilizationType', 'LeaderType'));
---------------------------------------------------------

-- 爱之审判
insert or ignore into Types
	(Type,								            Kind)
values
	('PROJECT_CIRCUSES_AND_BREAD',		'KIND_PROJECT');

insert or ignore into Projects
  (ProjectType, Name, ShortName, Description, Cost, CostProgressionModel, CostProgressionParam1, PrereqDistrict, UnlocksFromEffect)
values 
	('PROJECT_CIRCUSES_AND_BREAD', 'LOC_PROJECT_CIRCUSES_AND_BREAD_HD_NAME', 'LOC_PROJECT_CIRCUSES_AND_BREAD_HD_SHORT_NAME', 'LOC_PROJECT_CIRCUSES_AND_BREAD_HD_DESCRIPTION',
	50, 'COST_PROGRESSION_GAME_PROGRESS', 800, 'DISTRICT_THEATER', 1);

insert or ignore into UniqueProjects_HD
	(ProjectType,											ModifierId,								LeaderType)
values
	('PROJECT_CIRCUSES_AND_BREAD',   	'ELEANOR_ALLOW_PROJECT',  'LEADER_ELEANOR_ENGLAND'),
	('PROJECT_CIRCUSES_AND_BREAD',   	'ELEANOR_ALLOW_PROJECT',  'LEADER_ELEANOR_FRANCE');

-- 大报恩寺 比萨斜塔项目
insert or ignore into Types (Type, Kind)
  select 'PROJECT_' || BuildingType, 'KIND_PROJECT'
from Buildings where BuildingType in ('BUILDING_PORCELAIN_TOWER', 'BUILDING_LEANING_TOWER');

insert or ignore into Projects (ProjectType, Name, ShortName, Description, Cost, MaxPlayerInstances, AdvisorType) select
  'PROJECT_' || BuildingType,
  'LOC_ROJECT_' || BuildingType || '_NAME',
  'LOC_ROJECT_' || BuildingType || '_SHORT_NAME',
  'LOC_ROJECT_' || BuildingType || '_DESCRIPTION',
  0,
  1,
  'ADVISOR_TECHNOLOGY'
from Buildings where BuildingType in ('BUILDING_PORCELAIN_TOWER', 'BUILDING_LEANING_TOWER');

insert or ignore into Projects_XP2 (ProjectType, RequiredBuilding)
  select 'PROJECT_' || BuildingType, BuildingType
from Buildings where BuildingType in ('BUILDING_PORCELAIN_TOWER', 'BUILDING_LEANING_TOWER');