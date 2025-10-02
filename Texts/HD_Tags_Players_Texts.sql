-- Insert new text tag for replaced texts.

--------------------------------------------------------------------------------
-- Major Civs

-- UD
update PlayerItems set Description = 'LOC_DISTRICT_LAVRA_HD_DESCRIPTION'
    where Type = 'DISTRICT_LAVRA' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_HANSA_HD_DESCRIPTION'
    where Type = 'DISTRICT_HANSA' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_OPPIDUM_HD_DESCRIPTION'
    where Type = 'DISTRICT_OPPIDUM' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_COTHON_HD_DESCRIPTION'
    where Type = 'DISTRICT_COTHON' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_ROYAL_NAVY_DOCKYARD_HD_DESCRIPTION'
    where Type = 'DISTRICT_ROYAL_NAVY_DOCKYARD' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_IKANDA_HD_DESCRIPTION'
    where Type = 'DISTRICT_IKANDA' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_MBANZA_HD_DESCRIPTION'
    where Type = 'DISTRICT_MBANZA' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_ACROPOLIS_HD_DESCRIPTION'
    where Type = 'DISTRICT_ACROPOLIS' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_WATER_STREET_CARNIVAL_HD_DESCRIPTION'
    where Type = 'DISTRICT_WATER_STREET_CARNIVAL' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_STREET_CARNIVAL_HD_DESCRIPTION'
    where Type = 'DISTRICT_STREET_CARNIVAL' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_HIPPODROME_HD_DESCRIPTION'
    where Type = 'DISTRICT_HIPPODROME' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_SUGUBA_HD_DESCRIPTION'
    where Type = 'DISTRICT_SUGUBA' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_SEOWON_HD_DESCRIPTION'
    where Type = 'DISTRICT_SEOWON' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_OBSERVATORY_HD_DESCRIPTION'
    where Type = 'DISTRICT_OBSERVATORY' and Domain = 'Players:Expansion2_Players';
update PlayerItems set Description = 'LOC_DISTRICT_THANH_HD_DESCRIPTION'
    where Type = 'DISTRICT_THANH' and Domain = 'Players:Expansion2_Players';

insert or ignore into PlayerItems
    (Domain,                        CivilizationType,              LeaderType,              Type,                       Icon,                               Name,                                   Description,                                    SortIndex)
values
    ("Players:Expansion1_Players",  "CIVILIZATION_NETHERLANDS",    "LEADER_WILHELMINA",     "IMPROVEMENT_LAND_POLDER",  "ICON_IMPROVEMENT_LAND_POLDER",     "LOC_IMPROVEMENT_LAND_POLDER_NAME",     "LOC_IMPROVEMENT_LAND_POLDER_DESCRIPTION",      31),
    ("Players:Expansion2_Players",  "CIVILIZATION_NETHERLANDS",    "LEADER_WILHELMINA",     "IMPROVEMENT_LAND_POLDER",  "ICON_IMPROVEMENT_LAND_POLDER",     "LOC_IMPROVEMENT_LAND_POLDER_NAME",     "LOC_IMPROVEMENT_LAND_POLDER_DESCRIPTION",      31);

update PlayerItems set SortIndex = 30 where Type = 'IMPROVEMENT_POLDER';

insert or ignore into PlayerItems
    (Domain,                        CivilizationType,              LeaderType,              Type,                       Icon,                               Name,                                   Description,                                    SortIndex)
select
    "Players:Expansion2_Players",  "CIVILIZATION_AMERICA",         "LEADER_T_ROOSEVELT",    "BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS",  "ICON_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS",     "LOC_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_NAME",     "LOC_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_DESCRIPTION",      31
where exists (select CivilizationType from Players where CivilizationType = 'CIVILIZATION_ETHIOPIA');
insert or ignore into PlayerItems
    (Domain,                        CivilizationType,              LeaderType,              Type,                       Icon,                               Name,                                   Description,                                    SortIndex)
select 
    "Players:Expansion2_Players",  "CIVILIZATION_AMERICA",         "LEADER_T_ROOSEVELT_ROUGHRIDER",    "BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS",  "ICON_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS",     "LOC_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_NAME",     "LOC_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_DESCRIPTION",      31
where exists (select CivilizationType from Players where CivilizationType = 'CIVILIZATION_ETHIOPIA');
insert or ignore into PlayerItems
    (Domain,                        CivilizationType,              LeaderType,              Type,                       Icon,                               Name,                                   Description,                                    SortIndex)
select
    "Players:Expansion2_Players",  "CIVILIZATION_AMERICA",         "LEADER_ABRAHAM_LINCOLN",    "BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS",  "ICON_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS",     "LOC_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_NAME",     "LOC_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS_DESCRIPTION",      31
where exists (select CivilizationType from Players where CivilizationType = 'CIVILIZATION_ETHIOPIA') and exists (select LeaderType from Players where LeaderType = 'LEADER_ABRAHAM_LINCOLN');

insert or ignore into PlayerItems
    (Domain,                        CivilizationType,              LeaderType,              Type,                       Icon,                               Name,                                   Description,                                    SortIndex)
select
    "Players:Expansion2_Players",   "CIVILIZATION_OTTOMAN",        "LEADER_SULEIMAN_ALT",   "UNIT_SULEIMAN_JANISSARY",  "ICON_UNIT_SULEIMAN_JANISSARY",     "LOC_UNIT_SULEIMAN_JANISSARY_NAME",      "LOC_UNIT_SULEIMAN_JANISSARY_DESCRIPTION",     31
where exists (select LeaderType from Players where LeaderType = 'LEADER_SULEIMAN_ALT');

delete from PlayerItems where LeaderType = 'LEADER_CLEOPATRA' and Type = 'UNIT_EGYPTIAN_KHOPESH' and exists (select LeaderType from Players where LeaderType = 'LEADER_RAMSES');
delete from PlayerItems where LeaderType = 'LEADER_CLEOPATRA_ALT' and Type = 'UNIT_EGYPTIAN_KHOPESH' and exists (select LeaderType from Players where LeaderType = 'LEADER_RAMSES');    

--拜占庭选人界面
insert or ignore into PlayerItems
	(Domain,						CivilizationType,				LeaderType,				Type,						Icon,								Name,									Description,									SortIndex)
select
	"Players:Expansion2_Players",	"CIVILIZATION_BYZANTIUM",		"LEADER_THEODORA",		"UNIT_BYZANTINE_TAGMA",		"ICON_UNIT_BYZANTINE_TAGMA",		"LOC_UNIT_BYZANTINE_TAGMA_NAME",		"LOC_UNIT_BYZANTINE_TAGMA_DESCRIPTION",			31
where exists (select LeaderType from Players where LeaderType = 'LEADER_THEODORA');
--伊丽莎白
insert or ignore into PlayerItems
	(Domain,						CivilizationType,				LeaderType,				Type,						Icon,								Name,									Description,									SortIndex)
select
	"Players:Expansion2_Players",	"CIVILIZATION_ENGLAND",			"LEADER_ELIZABETH",		"UNIT_ENGLISH_SEADOG",		"ICON_UNIT_ENGLISH_SEADOG",		    "LOC_UNIT_ENGLISH_SEADOG_NAME",		    "LOC_UNIT_ENGLISH_SEADOG_DESCRIPTION",			31
where exists (select LeaderType from Players where LeaderType = 'LEADER_ELIZABETH');
update PlayerItems set Description = 'LOC_UNIT_ENGLISH_SEADOG_STUU_DESCRIPTION' 
where Domain = 'Players:Expansion2_Players' and CivilizationType = 'CIVILIZATION_ENGLAND' and Type = 'UNIT_ENGLISH_SEADOG'
and exists (select Type from PlayerItems where Type = 'UNIT_ENGLISH_LONGBOWMAN');

-- 西班牙
insert or ignore into PlayerItems
    (Domain,                        CivilizationType,        LeaderType,             Type,                           Icon,                                   Name,                                       Description,                                        SortIndex)
values
    ("Players:Expansion1_Players",  "CIVILIZATION_SPAIN",    "LEADER_PHILIP_II",     "BUILDING_EL_ESCORIAL_PALACE",  "ICON_BUILDING_EL_ESCORIAL_PALACE",     "LOC_BUILDING_EL_ESCORIAL_PALACE_NAME",     "LOC_BUILDING_EL_ESCORIAL_PALACE_DESCRIPTION",      31),
    ("Players:Expansion2_Players",  "CIVILIZATION_SPAIN",    "LEADER_PHILIP_II",     "BUILDING_EL_ESCORIAL_PALACE",  "ICON_BUILDING_EL_ESCORIAL_PALACE",     "LOC_BUILDING_EL_ESCORIAL_PALACE_NAME",     "LOC_BUILDING_EL_ESCORIAL_PALACE_DESCRIPTION",      31);

-- 日本
delete from PlayerItems where Type = 'BUILDING_ELECTRONICS_FACTORY';
update PlayerItems set Description = 'LOC_BUILDING_JNR_DOJO_HD_DESCRIPTION' where Type = 'BUILDING_JNR_DOJO';

-- 李裪
insert or ignore into PlayerItems
    (Domain,                        CivilizationType,        LeaderType,             Type,                  Icon,                        Name,                            Description,                             SortIndex)
select
    "Players:Expansion2_Players",   "CIVILIZATION_KOREA",    "LEADER_SEJONG",        "UNIT_HD_CODIFIER",    "ICON_UNIT_HD_CODIFIER",     "LOC_UNIT_HD_CODIFIER_NAME",     "LOC_UNIT_HD_CODIFIER_DESCRIPTION",      50
where exists (select LeaderType from Players where LeaderType = 'LEADER_SEJONG');

--挪威
delete from PlayerItems where Type = 'UNIT_NORWEGIAN_BERSERKER' and LeaderType = 'LEADER_HARALD_ALT';
insert or ignore into PlayerItems
	(Domain,						CivilizationType,				LeaderType,				Type,						Icon,								Name,									Description,									SortIndex)
select
	"Players:Expansion2_Players",	"CIVILIZATION_NORWAY",			"LEADER_HARALD_ALT",	"UNIT_NORWEGIAN_LONGSHIP",	"ICON_UNIT_NORWEGIAN_LONGSHIP",		"LOC_UNIT_NORWEGIAN_LONGSHIP_NAME",		"LOC_UNIT_NORWEGIAN_LONGSHIP_DESCRIPTION",		31
where exists (select LeaderType from Players where LeaderType = 'LEADER_HARALD_ALT');

-- 吉尔伽美什
insert or ignore into PlayerItems
    (Domain,                        CivilizationType,        LeaderType,             Type,                  Icon,                        Name,                            Description,                             SortIndex)
values
    ("Players:Expansion2_Players",  "CIVILIZATION_SUMERIA",  "LEADER_GILGAMESH",     "UNIT_ENKIDU_HD",      "ICON_UNIT_ENKIDU_HD",       "LOC_UNIT_ENKIDU_HD_NAME",       "LOC_UNIT_ENKIDU_HD_DESCRIPTION",        51);

-- 中国
-- 删除 除了朱棣之外的虎蹲炮
delete from PlayerItems where CivilizationType = "CIVILIZATION_CHINA" and Type = "UNIT_CHINESE_CROUCHING_TIGER" and LeaderType not in ("LEADER_YONGLE", "LEADER_ZHUDI");

-- 老秦 秦锐士
insert or ignore into PlayerItems
	(Domain,						CivilizationType,       LeaderType,     Type,                       Icon,								Name,									Description,									SortIndex)
values
	("Players:Expansion2_Players",  "CIVILIZATION_CHINA",   "LEADER_QIN",   "UNIT_QIN_ELITE_SOLDIER_HD","ICON_UNIT_QIN_ELITE_SOLDIER_HD",   "LOC_UNIT_QIN_ELITE_SOLDIER_HD_NAME",   "LOC_UNIT_QIN_ELITE_SOLDIER_HD_DESCRIPTION",    44);

insert or ignore into PlayerItems
	(Domain,						CivilizationType,       LeaderType,         Type,                       Icon,								Name,									Description,									SortIndex)
select
	"Players:Expansion2_Players",   "CIVILIZATION_CHINA",   'LEADER_QIN_ALT',   "UNIT_QIN_ELITE_SOLDIER_HD","ICON_UNIT_QIN_ELITE_SOLDIER_HD",   "LOC_UNIT_QIN_ELITE_SOLDIER_HD_NAME",   "LOC_UNIT_QIN_ELITE_SOLDIER_HD_DESCRIPTION",    45
where exists (select LeaderType from Players where LeaderType = 'LEADER_QIN_ALT');

insert or ignore into PlayerItems
    (Domain,                        CivilizationType,              LeaderType,              Type,                       Icon,                               Name,                                   Description,                                    SortIndex)
select
    "Players:Expansion2_Players",   "CIVILIZATION_CHINA",          "LEADER_QIN_ALT",        "UNIT_KEQING",              "ICON_UNIT_KEQING",                 "LOC_UNIT_KEQING_NAME",                 "LOC_UNIT_KEQING_DESCRIPTION",                  46
where exists (select LeaderType from Players where LeaderType = 'LEADER_QIN_ALT');

-- 中国忽必烈 怯薛军
insert or ignore into PlayerItems
    (Domain,                        CivilizationType,       LeaderType,                     Type,                       Icon,                               Name,                                   Description,                                    SortIndex)
select
    "Players:Expansion2_Players",   "CIVILIZATION_CHINA",   "LEADER_KUBLAI_KHAN_CHINA",     "UNIT_MONGOLIAN_KESHIG",    "ICON_UNIT_MONGOLIAN_KESHIG",       "LOC_UNIT_MONGOLIAN_KESHIG_NAME",       "LOC_UNIT_MONGOLIAN_KESHIG_DESCRIPTION",        29
where exists (select LeaderType from Players where LeaderType = 'LEADER_KUBLAI_KHAN_CHINA');

-- 武则天 梅花内卫
insert or ignore into PlayerItems
    (Domain,                        CivilizationType,       LeaderType,             Type,                               Icon,                                   Name,                                       Description,                                        SortIndex)
select
    "Players:Expansion2_Players",   "CIVILIZATION_CHINA",   "LEADER_WU_ZETIAN",     "UNIT_PLUM_INTERNAL_SECURITY_HD",   "ICON_UNIT_PLUM_INTERNAL_SECURITY_HD",  "LOC_UNIT_PLUM_INTERNAL_SECURITY_HD_NAME",  "LOC_UNIT_PLUM_INTERNAL_SECURITY_HD_DESCRIPTION",   50
where exists (select LeaderType from Players where LeaderType = 'LEADER_WU_ZETIAN');