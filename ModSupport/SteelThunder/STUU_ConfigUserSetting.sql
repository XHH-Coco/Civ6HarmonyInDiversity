-------------------------------------
--                  --
-------------------------------------
update ConfigEnabledUniqueUnits set Enabled = 1;
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_AMERICAN_AH64_APACHE';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_GREEK_ARMATOLOS';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_EGYPTIAN_WAR_GALLEY';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_CHINESE_SHIGONG';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_ROMAN_EQUITE';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_RUSSIAN_T34';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_NORWEGIAN_HIRDMAN';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_INDIAN_MUGHAL_SOWAR';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_JAPANESE_YAMATO';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_SCYTHIAN_AMAZON_SCOUT';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_BRAZILIAN_BANDEIRANTE';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_FRENCH_MARINE';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_KONGO_GARDE_REPUBLICAINE';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_POLISH_UHLAN';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_AZTEC_WARRIOR_PRIEST';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_MACEDONIAN_BALLISTA';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_PERSIAN_WARSHIP';
update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_SPANISH_JINETE';
-- update ConfigEnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_PORTUGUESE_KNIGHT_OF_AVIZ';
-- update ConfigEnabledUniqueUnits set OwnerType = 'CIVILIZATION_PORTUGAL' where Type = 'UNIT_SPANISH_JINETE';

-- delete from UnitsToDelete;
insert or replace into UnitsToDelete values ('UNIT_GERMAN_UBOAT');

--埃及四十桨
update ConfigEnabledUniqueUnits set Enabled = 1	where Type = 'UNIT_EGYPTIAN_WAR_GALLEY'


--赫梯拿弯刀战士-主菜单文本1
--update ConfigEnabledUniqueUnits set OwnerType = 'CIVILIZATION_MER_HITTITES' where Type = 'UNIT_EGYPTIAN_KHOPESH'
--	and exists (select CivilizationType from Players where CivilizationType = 'CIVILIZATION_MER_HITTITES');

--给拉二在选人框加个文本


