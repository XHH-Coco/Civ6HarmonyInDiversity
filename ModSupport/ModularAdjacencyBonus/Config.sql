-- 金法国
update Players set LeaderAbilityDescription = 'LOC_TRAIT_LEADER_MAGNIFICENCES_DESCRIPTION_MAB' where LeaderType = 'LEADER_CATHERINE_DE_MEDICI_ALT';

-- 苏格兰
update Players set CivilizationAbilityDescription = 'LOC_TRAIT_CIVILIZATION_SCOTTISH_ENLIGHTENMENT_DESCRIPTION_MAB' where CivilizationType = 'CIVILIZATION_SCOTLAND';

-- 红胡子
update Players set LeaderAbilityDescription = 'LOC_TRAIT_LEADER_HOLY_ROMAN_EMPEROR_DESCRIPTION_MAB' where CivilizationType = 'CIVILIZATION_GERMANY';