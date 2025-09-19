
-- Aztec
update PlayerItems set Description = 'LOC_UNIT_AZTEC_EAGLE_WARRIOR_STUU_DESCRIPTION'
where Domain = 'Players:Expansion2_Players' and CivilizationType = 'CIVILIZATION_AZTEC' and Type = 'UNIT_AZTEC_EAGLE_WARRIOR'
and exists (select Type from PlayerItems where Type = 'UNIT_AZTEC_JAGUAR');

-- Arabia
update Players set LeaderAbilityDescription = 'LOC_TRAIT_LEADER_RIGHTEOUSNESS_OF_FAITH_STUU_DESCRIPTION'
where Domain = 'Players:Expansion2_Players' and CivilizationType = 'CIVILIZATION_ARABIA' and LeaderType = 'LEADER_SALADIN'
and exists (select Type from PlayerItems where Type = 'UNIT_ARABIAN_GHAZI');

--挪威
insert or ignore into PlayerItems
	(Domain,						CivilizationType,				LeaderType,				Type,								Icon,										Name,											Description,											SortIndex)
select
	"Players:Expansion2_Players",	"CIVILIZATION_NORWAY",			"LEADER_HARALD_ALT",	"UNIT_BYZANTINE_VARANGIAN_GUARD",	"ICON_UNIT_BYZANTINE_VARANGIAN_GUARD",		"LOC_UNIT_BYZANTINE_VARANGIAN_GUARD_NAME",		"LOC_UNIT_BYZANTINE_VARANGIAN_GUARD_DESCRIPTION",		31
where exists (select LeaderType from Players where LeaderType = 'LEADER_HARALD_ALT') and exists (select Type from ConfigEnabledUniqueUnits where Type = 'UNIT_BYZANTINE_VARANGIAN_GUARD');