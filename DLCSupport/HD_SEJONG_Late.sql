update GreatWorks set Tourism = 1 where GreatWorkType in (select GreatWorkType from HD_NEW_CODIFIER);

delete from GreatWork_YieldChanges where GreatWorkType in (select GreatWorkType from HD_NEW_CODIFIER);

insert or replace into GreatWork_YieldChanges
  (GreatWorkType,                 YieldType,              YieldChange)
values
  -- 孝行录
  ('GREATWORK_HD_CODIFIER_1',     'YIELD_CULTURE',        1),
  ('GREATWORK_HD_CODIFIER_1',     'YIELD_FAITH',          3),
  -- 农事直说
	('GREATWORK_HD_CODIFIER_2',     'YIELD_FOOD',           3),
  -- 三纲行实图
	('GREATWORK_HD_CODIFIER_3',     'YIELD_CULTURE',        1),
	('GREATWORK_HD_CODIFIER_3',     'YIELD_FAITH',          3),
  -- 八道地理志
	('GREATWORK_HD_CODIFIER_4',     'YIELD_PRODUCTION',     3),
  -- 无冤录注解
	('GREATWORK_HD_CODIFIER_5',     'YIELD_CULTURE',        1),
	('GREATWORK_HD_CODIFIER_5',     'YIELD_SCIENCE',        2),
  -- 乡药集成方
	('GREATWORK_HD_CODIFIER_6',     'YIELD_FOOD',           1),
	('GREATWORK_HD_CODIFIER_6',     'YIELD_SCIENCE',        2),
  -- 资治通鉴训译
	('GREATWORK_HD_CODIFIER_7',     'YIELD_CULTURE',        3),
  -- 韩柳文注释
	('GREATWORK_HD_CODIFIER_8',     'YIELD_CULTURE',        3),
  -- 国语补正
	('GREATWORK_HD_CODIFIER_9',     'YIELD_CULTURE',        3),
  -- 明皇诫鉴
	('GREATWORK_HD_CODIFIER_10',    'YIELD_CULTURE',        3),
  -- 丝纶全集
	('GREATWORK_HD_CODIFIER_11',    'YIELD_PRODUCTION',     2),
	('GREATWORK_HD_CODIFIER_11',    'YIELD_CULTURE',        1),
  -- 杜诗诸家注释
	('GREATWORK_HD_CODIFIER_12',    'YIELD_CULTURE',        3),
  -- 韵会谚译
	('GREATWORK_HD_CODIFIER_13',    'YIELD_CULTURE',        3),
  -- 五礼仪注
	('GREATWORK_HD_CODIFIER_14',    'YIELD_CULTURE',        1),
	('GREATWORK_HD_CODIFIER_14',    'YIELD_FAITH',          3),
  -- 七政算內外篇
	('GREATWORK_HD_CODIFIER_15',    'YIELD_SCIENCE',        1),
	('GREATWORK_HD_CODIFIER_15',    'YIELD_FAITH',          3),
  -- 治平要览
	('GREATWORK_HD_CODIFIER_16',    'YIELD_CULTURE',        1),
	('GREATWORK_HD_CODIFIER_16',    'YIELD_PRODUCTION',     2),
  -- 龙飞御天歌
	('GREATWORK_HD_CODIFIER_17',    'YIELD_CULTURE',        1),
	('GREATWORK_HD_CODIFIER_17',    'YIELD_FAITH',          3),
  -- 龙飞御天歌注解
	('GREATWORK_HD_CODIFIER_18',    'YIELD_CULTURE',        1),
	('GREATWORK_HD_CODIFIER_18',    'YIELD_FAITH',          3),
  -- 诸家历象集
	('GREATWORK_HD_CODIFIER_19',    'YIELD_FOOD',           1),
	('GREATWORK_HD_CODIFIER_19',    'YIELD_CULTURE',        1),
	('GREATWORK_HD_CODIFIER_19',    'YIELD_SCIENCE',        1),
  -- 医方类聚
	('GREATWORK_HD_CODIFIER_20',    'YIELD_SCIENCE',        3),
  -- 训民正音
	('GREATWORK_HD_CODIFIER_21',    'YIELD_CULTURE',        3),
  -- 东国正韵
	('GREATWORK_HD_CODIFIER_22',    'YIELD_CULTURE',        3),
  -- 四书谚解
	('GREATWORK_HD_CODIFIER_23',    'YIELD_CULTURE',        3),
  -- 高丽史
	('GREATWORK_HD_CODIFIER_24',    'YIELD_CULTURE',        3);