update GreatWorks set Tourism = 18 where GreatWorkObjectType = 'GREATWORKOBJECT_ARTIFACT';
replace into GreatWork_YieldChanges (GreatWorkType, YieldType, YieldChange)
	select GreatWorkType, 'YIELD_CULTURE', 18 from GreatWorks where GreatWorkObjectType = 'GREATWORKOBJECT_ARTIFACT';

create table HD_GREATWORK_YIELDCHANGES (
	GreatWorkObjectType TEXT not null,
	EraType TEXT not null,
  YieldType TEXT not null,
  YieldChange INT not null,
  Tourism INT not null,
	primary key (GreatWorkObjectType, EraType, YieldType)
);

insert or replace into HD_GREATWORK_YIELDCHANGES
  (GreatWorkObjectType,         EraType,            YieldType,        YieldChange,  Tourism)
values
  -- 著作
  ('GREATWORKOBJECT_WRITING',   'ERA_CLASSICAL',    'YIELD_CULTURE',  2,            2),
  ('GREATWORKOBJECT_WRITING',   'ERA_MEDIEVAL',     'YIELD_CULTURE',  3,            3),
  ('GREATWORKOBJECT_WRITING',   'ERA_RENAISSANCE',  'YIELD_CULTURE',  6,            6),
  ('GREATWORKOBJECT_WRITING',   'ERA_INDUSTRIAL',   'YIELD_CULTURE',  9,            9),
  ('GREATWORKOBJECT_WRITING',   'ERA_MODERN',       'YIELD_CULTURE',  12,           12),
  ('GREATWORKOBJECT_WRITING',   'ERA_ATOMIC',       'YIELD_CULTURE',  15,           15),
  ('GREATWORKOBJECT_WRITING',   'ERA_INFORMATION',  'YIELD_CULTURE',  18,           18),
  -- 雕塑
  ('GREATWORKOBJECT_SCULPTURE', 'ERA_CLASSICAL',    'YIELD_CULTURE',  2,            2),
  ('GREATWORKOBJECT_SCULPTURE', 'ERA_MEDIEVAL',     'YIELD_CULTURE',  3,            3),
  ('GREATWORKOBJECT_SCULPTURE', 'ERA_RENAISSANCE',  'YIELD_CULTURE',  4,            4),
  ('GREATWORKOBJECT_SCULPTURE', 'ERA_INDUSTRIAL',   'YIELD_CULTURE',  6,            6),
  ('GREATWORKOBJECT_SCULPTURE', 'ERA_MODERN',       'YIELD_CULTURE',  8,            8),
  ('GREATWORKOBJECT_SCULPTURE', 'ERA_ATOMIC',       'YIELD_CULTURE',  10,           10),
  ('GREATWORKOBJECT_SCULPTURE', 'ERA_INFORMATION',  'YIELD_CULTURE',  12,           12),
  -- 肖像
  ('GREATWORKOBJECT_PORTRAIT',  'ERA_CLASSICAL',    'YIELD_CULTURE',  2,            2),
  ('GREATWORKOBJECT_PORTRAIT',  'ERA_MEDIEVAL',     'YIELD_CULTURE',  3,            3),
  ('GREATWORKOBJECT_PORTRAIT',  'ERA_RENAISSANCE',  'YIELD_CULTURE',  4,            4),
  ('GREATWORKOBJECT_PORTRAIT',  'ERA_INDUSTRIAL',   'YIELD_CULTURE',  6,            6),
  ('GREATWORKOBJECT_PORTRAIT',  'ERA_MODERN',       'YIELD_CULTURE',  8,            8),
  ('GREATWORKOBJECT_PORTRAIT',  'ERA_ATOMIC',       'YIELD_CULTURE',  10,           10),
  ('GREATWORKOBJECT_PORTRAIT',  'ERA_INFORMATION',  'YIELD_CULTURE',  12,           12),
  -- 风景
  ('GREATWORKOBJECT_LANDSCAPE', 'ERA_CLASSICAL',    'YIELD_CULTURE',  2,            2),
  ('GREATWORKOBJECT_LANDSCAPE', 'ERA_MEDIEVAL',     'YIELD_CULTURE',  3,            3),
  ('GREATWORKOBJECT_LANDSCAPE', 'ERA_RENAISSANCE',  'YIELD_CULTURE',  4,            4),
  ('GREATWORKOBJECT_LANDSCAPE', 'ERA_INDUSTRIAL',   'YIELD_CULTURE',  6,            6),
  ('GREATWORKOBJECT_LANDSCAPE', 'ERA_MODERN',       'YIELD_CULTURE',  8,            8),
  ('GREATWORKOBJECT_LANDSCAPE', 'ERA_ATOMIC',       'YIELD_CULTURE',  10,           10),
  ('GREATWORKOBJECT_LANDSCAPE', 'ERA_INFORMATION',  'YIELD_CULTURE',  12,           12),
  -- 宗教
  ('GREATWORKOBJECT_RELIGIOUS', 'ERA_CLASSICAL',    'YIELD_CULTURE',  2,            2),
  ('GREATWORKOBJECT_RELIGIOUS', 'ERA_MEDIEVAL',     'YIELD_CULTURE',  3,            3),
  ('GREATWORKOBJECT_RELIGIOUS', 'ERA_RENAISSANCE',  'YIELD_CULTURE',  4,            4),
  ('GREATWORKOBJECT_RELIGIOUS', 'ERA_INDUSTRIAL',   'YIELD_CULTURE',  6,            6),
  ('GREATWORKOBJECT_RELIGIOUS', 'ERA_MODERN',       'YIELD_CULTURE',  8,            8),
  ('GREATWORKOBJECT_RELIGIOUS', 'ERA_ATOMIC',       'YIELD_CULTURE',  10,           10),
  ('GREATWORKOBJECT_RELIGIOUS', 'ERA_INFORMATION',  'YIELD_CULTURE',  12,           12),
  -- 音乐
  ('GREATWORKOBJECT_MUSIC',     'ERA_CLASSICAL',    'YIELD_CULTURE',  4,            4),
  ('GREATWORKOBJECT_MUSIC',     'ERA_MEDIEVAL',     'YIELD_CULTURE',  6,            6),
  ('GREATWORKOBJECT_MUSIC',     'ERA_RENAISSANCE',  'YIELD_CULTURE',  6,            6),
  ('GREATWORKOBJECT_MUSIC',     'ERA_INDUSTRIAL',   'YIELD_CULTURE',  9,            9),
  ('GREATWORKOBJECT_MUSIC',     'ERA_MODERN',       'YIELD_CULTURE',  12,           12),
  ('GREATWORKOBJECT_MUSIC',     'ERA_ATOMIC',       'YIELD_CULTURE',  15,           15),
  ('GREATWORKOBJECT_MUSIC',     'ERA_INFORMATION',  'YIELD_CULTURE',  18,           18);

-- 重新定义著作、艺术、音乐巨作的产出
delete from GreatWork_YieldChanges where GreatWorkType in
  (select GreatWorkType from GreatWorks where
    GreatWorkObjectType in (select GreatWorkObjectType from HD_GREATWORK_YIELDCHANGES) and
    EraType in (select EraType from HD_GREATWORK_YIELDCHANGES));

insert or ignore into GreatWork_YieldChanges
	(GreatWorkType, YieldType, YieldChange)
select
  a.GreatWorkType, b.YieldType, b.YieldChange
from GreatWorks a inner join HD_GREATWORK_YIELDCHANGES b on a.GreatWorkObjectType = b.GreatWorkObjectType and a.EraType = b.EraType;

-- 更新巨作旅游业绩
  -- 巨著
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_CLASSICAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_CLASSICAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_MEDIEVAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_MEDIEVAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_RENAISSANCE')
  where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_RENAISSANCE';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_INDUSTRIAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_INDUSTRIAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_MODERN')
  where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_MODERN';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_ATOMIC')
  where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_ATOMIC';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_INFORMATION')
  where GreatWorkObjectType = 'GREATWORKOBJECT_WRITING' and EraType = 'ERA_INFORMATION';
  -- 雕塑
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_CLASSICAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_CLASSICAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_MEDIEVAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_MEDIEVAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_RENAISSANCE')
  where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_RENAISSANCE';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_INDUSTRIAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_INDUSTRIAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_MODERN')
  where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_MODERN';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_ATOMIC')
  where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_ATOMIC';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_INFORMATION')
  where GreatWorkObjectType = 'GREATWORKOBJECT_SCULPTURE' and EraType = 'ERA_INFORMATION';
  -- 肖像
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_CLASSICAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_CLASSICAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_MEDIEVAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_MEDIEVAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_RENAISSANCE')
  where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_RENAISSANCE';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_INDUSTRIAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_INDUSTRIAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_MODERN')
  where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_MODERN';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_ATOMIC')
  where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_ATOMIC';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_INFORMATION')
  where GreatWorkObjectType = 'GREATWORKOBJECT_PORTRAIT' and EraType = 'ERA_INFORMATION';
  -- 风景
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_CLASSICAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_CLASSICAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_MEDIEVAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_MEDIEVAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_RENAISSANCE')
  where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_RENAISSANCE';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_INDUSTRIAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_INDUSTRIAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_MODERN')
  where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_MODERN';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_ATOMIC')
  where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_ATOMIC';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_INFORMATION')
  where GreatWorkObjectType = 'GREATWORKOBJECT_LANDSCAPE' and EraType = 'ERA_INFORMATION';
  -- 宗教
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_CLASSICAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_CLASSICAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_MEDIEVAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_MEDIEVAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_RENAISSANCE')
  where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_RENAISSANCE';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_INDUSTRIAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_INDUSTRIAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_MODERN')
  where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_MODERN';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_ATOMIC')
  where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_ATOMIC';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_INFORMATION')
  where GreatWorkObjectType = 'GREATWORKOBJECT_RELIGIOUS' and EraType = 'ERA_INFORMATION';
  -- 音乐
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_CLASSICAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_CLASSICAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_MEDIEVAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_MEDIEVAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_RENAISSANCE')
  where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_RENAISSANCE';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_INDUSTRIAL')
  where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_INDUSTRIAL';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_MODERN')
  where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_MODERN';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_ATOMIC')
  where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_ATOMIC';
update GreatWorks set Tourism = (select Tourism from HD_GREATWORK_YIELDCHANGES where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_INFORMATION')
  where GreatWorkObjectType = 'GREATWORKOBJECT_MUSIC' and EraType = 'ERA_INFORMATION';

-- 调整特殊巨作的产出和业绩
update GreatWorks set Tourism = 4 where GreatWorkType = 'GREATWORK_SHI_TAO_HD_3';
update GreatWork_YieldChanges set YieldChange = 4 where GreatWorkType = 'GREATWORK_SHI_TAO_HD_3';

update GreatWorks set Tourism = 1 where GreatWorkType = 'GREATWORK_YUE_SHU_YAO_LU';
update GreatWork_YieldChanges set YieldChange = 1 where GreatWorkType = 'GREATWORK_YUE_SHU_YAO_LU';
update GreatWorks set Tourism = 1 where GreatWorkType = 'GREATWORK_NONG_SANG_JI_YAO';
update GreatWork_YieldChanges set YieldChange = 2, YieldType = 'YIELD_FOOD' where GreatWorkType = 'GREATWORK_NONG_SANG_JI_YAO';