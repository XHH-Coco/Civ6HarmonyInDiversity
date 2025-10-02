------------------- 资源分类 -------------------
create table if not exists HD_ResourceClassificationTypes(
  ResourceClassificationType  TEXT    not NULL,
  Name                        TEXT,
  SortIndex                   Integer Default 0,
  Display                     boolean not null default true,
PRIMARY KEY('ResourceClassificationType'));

create table if not exists HD_Resource_Classification(
  ResourceType                TEXT    not NULL,
  ResourceClassificationType  TEXT    not NULL,
PRIMARY KEY('ResourceType', 'ResourceClassificationType'));

------------------- 奇观对应资源 -------------------
create table if not exists Wonder_Resources_HD(
  BuildingType TEXT not NULL,
  ResourceType TEXT,
PRIMARY KEY('BuildingType'));

------------------- 百科资源分类 -------------------
create table if not exists HD_Civilopedia_Resource_Groups(
  ResourceType 	TEXT not NULL,
  PageGroupId 	TEXT not NULL,
PRIMARY KEY('ResourceType', 'PageGroupId'));

------------------- 改良分类 -------------------
create table if not exists HD_ImprovementClassificationTypes(
  ImprovementClassificationType  TEXT    not NULL,
  Name                           TEXT,
  SortIndex                      Integer Default 0,
PRIMARY KEY('ImprovementClassificationType'));

create table if not exists HD_Improvement_Classification(
  ImprovementType                TEXT    not NULL,
  ImprovementClassificationType  TEXT    not NULL,
PRIMARY KEY('ImprovementType', 'ImprovementClassificationType'));

------------------- 区域分类 -------------------
create table if not exists HD_DistrictClassificationTypes(
  DistrictClassificationType  TEXT    not NULL,
  Name                        TEXT,
  SortIndex                   Integer Default 0,
PRIMARY KEY('DistrictClassificationType'));

create table if not exists HD_District_Classification(
  DistrictType                TEXT    not NULL,
  DistrictClassificationType  TEXT    not NULL,
PRIMARY KEY('DistrictType', 'DistrictClassificationType'));

------------------- 建筑分类 -------------------
create table if not exists HD_BuildingClassificationTypes(
  BuildingClassificationType  TEXT    not NULL,
  Name                        TEXT,
  SortIndex                   Integer Default 0,
PRIMARY KEY('BuildingClassificationType'));

create table if not exists HD_Building_Classification(
  BuildingType                TEXT    not NULL,
  BuildingClassificationType  TEXT    not NULL,
PRIMARY KEY('BuildingType', 'BuildingClassificationType'));