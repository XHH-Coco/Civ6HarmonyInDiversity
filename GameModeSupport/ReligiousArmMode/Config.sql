insert or replace into Queries
	(QueryId,									SQL)
values
	('ReligiousArmModePlayerItemOverrides',		'SELECT * FROM GameModePlayerItemOverrides WHERE GameModeType = "GAMEMODE_RILIGIOUS_ARM"');
insert or replace into QueryCriteria
	(QueryId,									ConfigurationGroup,		ConfigurationId,			Operator,		ConfigurationValue)
values
	('ReligiousArmModePlayerItemOverrides',		'Game',					'GAMEMODE_RILIGIOUS_ARM',	'Equals',		1);
insert or replace into GameModePlayerItemOverrides
	(GameModeType,				Domain,		CivilizationType,	LeaderType,		Type,	Description)
select
	'GAMEMODE_RILIGIOUS_ARM',	Domain,		CivilizationType,	LeaderType,		Type,	'LOC_UNIT_NORWEGIAN_ULFHEDNAR_RA_DESCRIPTION'
from PlayerItems where Type = 'UNIT_NORWEGIAN_ULFHEDNAR';
insert or replace into GameModePlayerItemOverrides
	(GameModeType,				Domain,		CivilizationType,	LeaderType,		Type,	Description)
select
	'GAMEMODE_RILIGIOUS_ARM',	Domain,		CivilizationType,	LeaderType,		Type,	'LOC_UNIT_JAPANESE_SOHEI_RA_DESCRIPTION'
from PlayerItems where Type = 'UNIT_JAPANESE_SOHEI';
insert or replace into GameModePlayerItemOverrides
	(GameModeType,				Domain,		CivilizationType,	LeaderType,		Type,	Description)
select
	'GAMEMODE_RILIGIOUS_ARM',	Domain,		CivilizationType,	LeaderType,		Type,	'LOC_UNIT_ELEANOR_TEMPLAR_RA_DESCRIPTION'
from PlayerItems where Type = 'UNIT_ELEANOR_TEMPLAR';
insert or replace into GameModePlayerItemOverrides
	(GameModeType,				Domain,		CivilizationType,	LeaderType,		Type,	Description)
select
	'GAMEMODE_RILIGIOUS_ARM',	Domain,		CivilizationType,	LeaderType,		Type,	'LOC_UNIT_INDONESIAN_KRIS_SWORDSMAN_RA_DESCRIPTION'
from PlayerItems where Type = 'UNIT_INDONESIAN_KRIS_SWORDSMAN';