update Improvement_ValidResources set ImprovementType = 'IMPROVEMENT_LUMBER_MILL'
	where ImprovementType = 'IMPROVEMENT_RES2_SAWMILL' and ResourceType not in 
	(select ResourceType from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_LUMBER_MILL');
delete from Types where Type = 'IMPROVEMENT_RES2_SAWMILL';
update RequirementSetRequirements set RequirementId = 'REQUIRES_PLOT_HAS_LUMBER_MILL' where RequirementId = 'REQUIRES_RES2_PLOT_HAS_ANY_LUMBER_MILL_REQUIREMENTS_MET';

update Boosts set NumItems = 1, RequiresResource = 1, TriggerDescription = 'LOC_BOOST_TRIGGER_FUEL_HD_RSC2' where TechnologyType = 'TECH_FUEL_HD';