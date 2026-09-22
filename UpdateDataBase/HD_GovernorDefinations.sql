-- ============================================================================================================================================================
-- 该文件定义新的总督升级 调整总督升级的位置
-- ============================================================================================================================================================
create table if not exists 'HD_Governors_Need_Reset'(
	'GovernorType'  Text NOT NULL,
	'Tag'           Text NOT NULL,
	PRIMARY KEY('GovernorType'),
  FOREIGN KEY('GovernorType') REFERENCES Governors('GovernorType') ON DELETE CASCADE ON UPDATE CASCADE
);

insert or ignore into HD_Governors_Need_Reset (GovernorType, Tag) values
  ('GOVERNOR_THE_EDUCATOR',         'EDUCATOR'),
  ('GOVERNOR_THE_DEFENDER',         'DEFENDER'),
  ('GOVERNOR_THE_BUILDER',          'BUILDER'),
  ('GOVERNOR_THE_RESOURCE_MANAGER', 'MANAGER'),
  ('GOVERNOR_THE_MERCHANT',         'MERCHANT'),
  ('GOVERNOR_THE_CARDINAL',         'CARDINAL'),
  ('GOVERNOR_THE_AMBASSADOR',       'AMBASSADOR');

create table if not exists 'HD_GovernorPromotion_ColumnNames'(
  'ColumnName'    Text NOT NULL,
  'Column'        Int NOT NULL,
  PRIMARY KEY('ColumnName')
);

insert or ignore into HD_GovernorPromotion_ColumnNames (ColumnName, Column) values
  ('LEFT', 0),
  ('RIGHT', 2);

-- ============================================================================================================================================================
-- 删除原版的总督升级
-- ============================================================================================================================================================
delete from Types where Type in (select GovernorPromotion from GovernorPromotionSets where GovernorType in (select GovernorType from HD_Governors_Need_Reset));
delete from GovernorPromotions where GovernorPromotionType in (select GovernorPromotion from GovernorPromotionSets where GovernorType in (select GovernorType from HD_Governors_Need_Reset));

-- ============================================================================================================================================================
-- 定义HD的总督升级
-- ============================================================================================================================================================
-- 基础升级
insert or ignore into Types (Type, Kind) select
  'GOVERNOR_PROMOTION_HD_' || Tag || '_BASE', 'KIND_GOVERNOR_PROMOTION'
from HD_Governors_Need_Reset;

insert or ignore into GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column, BaseAbility) select
  'GOVERNOR_PROMOTION_HD_' || Tag || '_BASE',
  'LOC_GOVERNOR_PROMOTION_HD_' || Tag || '_BASE_NAME',
  'LOC_GOVERNOR_PROMOTION_HD_' || Tag || '_BASE_DESCRIPTION',
  0,
  1,
  1
from HD_Governors_Need_Reset;

insert or ignore into GovernorPromotionSets (GovernorType, GovernorPromotion) select
  GovernorType, 'GOVERNOR_PROMOTION_HD_' || Tag || '_BASE'
from HD_Governors_Need_Reset;

-- 左右线升级
insert or ignore into Types (Type, Kind) select
  'GOVERNOR_PROMOTION_HD_' || Tag || '_' || ColumnName || '_' || Count, 'KIND_GOVERNOR_PROMOTION'
from HD_Governors_Need_Reset, HD_GovernorPromotion_ColumnNames, HDCounter where Count <= 3;

insert or ignore into GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column, BaseAbility) select
  'GOVERNOR_PROMOTION_HD_' || Tag || '_' || ColumnName || '_' || Count,
  'LOC_GOVERNOR_PROMOTION_HD_' || Tag || '_' || ColumnName || '_' || Count || '_NAME',
  'LOC_GOVERNOR_PROMOTION_HD_' || Tag || '_' || ColumnName || '_' || Count || '_DESCRIPTION',
  Count,
  Column,
  0
from HD_Governors_Need_Reset, HD_GovernorPromotion_ColumnNames, HDCounter where Count <= 3;

insert or ignore into GovernorPromotionSets (GovernorType, GovernorPromotion) select
  GovernorType, 'GOVERNOR_PROMOTION_HD_' || Tag || '_' || ColumnName || '_' || Count
from HD_Governors_Need_Reset, HD_GovernorPromotion_ColumnNames, HDCounter where Count <= 3;

-- 升级树
insert or ignore into GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) select
  'GOVERNOR_PROMOTION_HD_' || Tag || '_' || ColumnName || '_1', 'GOVERNOR_PROMOTION_HD_' || Tag || '_BASE'
from HD_Governors_Need_Reset, HD_GovernorPromotion_ColumnNames;

insert or ignore into GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) select
  'GOVERNOR_PROMOTION_HD_' || Tag || '_' || ColumnName || '_' || (Count + 1), 'GOVERNOR_PROMOTION_HD_' || Tag || '_' || ColumnName || '_' || Count
from HD_Governors_Need_Reset, HD_GovernorPromotion_ColumnNames, HDCounter where Count <= 2;

insert or ignore into GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) select
  'GOVERNOR_PROMOTION_HD_' || Tag || '_LEFT_' || (Count + 1), 'GOVERNOR_PROMOTION_HD_' || Tag || '_RIGHT_' || Count
from HD_Governors_Need_Reset, HDCounter where Count <= 2;

insert or ignore into GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) select
  'GOVERNOR_PROMOTION_HD_' || Tag || '_RIGHT_' || (Count + 1), 'GOVERNOR_PROMOTION_HD_' || Tag || '_LEFT_' || Count
from HD_Governors_Need_Reset, HDCounter where Count <= 2;