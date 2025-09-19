-------------------------------------
--                  --
-------------------------------------
update EnabledUniqueUnits set Enabled = 1;
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_AMERICAN_AH64_APACHE';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_GREEK_ARMATOLOS';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_EGYPTIAN_WAR_GALLEY';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_CHINESE_SHIGONG';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_ROMAN_EQUITE';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_RUSSIAN_T34';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_NORWEGIAN_HIRDMAN';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_INDIAN_MUGHAL_SOWAR';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_JAPANESE_YAMATO';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_SCYTHIAN_AMAZON_SCOUT';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_BRAZILIAN_BANDEIRANTE';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_FRENCH_MARINE';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_KONGO_GARDE_REPUBLICAINE';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_POLISH_UHLAN';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_AZTEC_WARRIOR_PRIEST';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_MACEDONIAN_BALLISTA';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_PERSIAN_WARSHIP';
update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_SPANISH_JINETE';
-- update EnabledUniqueUnits set Enabled = 0 where Type = 'UNIT_PORTUGUESE_KNIGHT_OF_AVIZ';
-- update EnabledUniqueUnits set OwnerType = 'CIVILIZATION_PORTUGAL' where Type = 'UNIT_SPANISH_JINETE';

-- delete from UnitsToDelete;
insert or replace into UnitsToDelete values ('UNIT_GERMAN_UBOAT');

--埃及四十桨
update EnabledUniqueUnits set Enabled = 1 where Type = 'UNIT_EGYPTIAN_WAR_GALLEY'

--赫梯的弯刀
--update EnabledUniqueUnits set OwnerType = 'CIVILIZATION_MER_HITTITES' where Type = 'UNIT_EGYPTIAN_KHOPESH'
--	and exists (select CivilizationType from Civilizations where CivilizationType = 'CIVILIZATION_MER_HITTITES');


