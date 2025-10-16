-- ================================================================================
------------------- 资源分类 -------------------
create table if not exists HD_ResourceClassificationTypes(
  ResourceClassificationType  TEXT    not NULL,
  Name                        TEXT,
  SortIndex                   Integer Default 0,
  Display                     boolean not null default 1,
PRIMARY KEY('ResourceClassificationType'));

create table if not exists HD_Resource_Classification(
  ResourceType                TEXT    not NULL,
  ResourceClassificationType  TEXT    not NULL,
PRIMARY KEY('ResourceType', 'ResourceClassificationType'));

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

-- ================================================================================
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

-- ================================================================================
------------------- 依赖资源分类的建筑 -------------------
create table if not exists HD_Building_Base_On_ResourceClassification(
  BuildingType                TEXT    not NULL,
  ResourceClassificationType  TEXT    not NULL,
  DetectRange                 TEXT    not NULL,
  PropertyKey                 TEXT    not NULL,
PRIMARY KEY('BuildingType', 'ResourceClassificationType', 'DetectRange'));

-- ================================================================================
------------------- 依赖分类的相邻加成 -------------------
create table if not exists HD_Adjacency_Base_On_Classification(
  ID                              TEXT  not NULL,
  Description                     TEXT  not NULL,
  YieldType                       TEXT  not NULL,
  YieldChange                     INT   not NULL,
  TilesRequired                   INT   not NULL Default 1,
  TerrainClassType                TEXT,
  ResourceClassificationType      TEXT,
  ImprovementClassificationType   TEXT,
  DistrictClassificationType      TEXT,
  PrereqCivic                     TEXT,
  PrereqTech                      TEXT,
  ObsoleteCivic                   TEXT,
  ObsoleteTech                    TEXT,
PRIMARY KEY('ID'));

create table if not exists HD_Adjacencies_YieldChangeId_ParentId(
  YieldChangeId   TEXT not NULL,
  ParentId        TEXT not NULL,
PRIMARY KEY('YieldChangeId'));

create table if not exists HD_District_Adjacencies_Base_On_Classification(
  DistrictType    TEXT  not NULL,
  YieldChangeId   TEXT  not NULL,
PRIMARY KEY('DistrictType', 'YieldChangeId'));

create table if not exists HD_Improvement_Adjacencies_Base_On_Classification(
  ImprovementType TEXT  not NULL,
  YieldChangeId   TEXT  not NULL,
PRIMARY KEY('ImprovementType', 'YieldChangeId'));