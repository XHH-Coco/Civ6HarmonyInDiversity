update Improvement_ValidResources set ImprovementType = 'IMPROVEMENT_LUMBER_MILL'
	where ImprovementType = 'IMPROVEMENT_RES2_SAWMILL' and ResourceType not in 
	(select ResourceType from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_LUMBER_MILL');
delete from Types where Type = 'IMPROVEMENT_RES2_SAWMILL';
update RequirementSetRequirements set RequirementId = 'REQUIRES_PLOT_HAS_LUMBER_MILL' where RequirementId = 'REQUIRES_RES2_PLOT_HAS_ANY_LUMBER_MILL_REQUIREMENTS_MET';

update Boosts set NumItems = 1, RequiresResource = 1, TriggerDescription = 'LOC_BOOST_TRIGGER_FUEL_HD_RSC2' where TechnologyType = 'TECH_FUEL_HD';

-- 在未开启hd公司mod时 垄断模式 删除资源
delete from GreatWorks_ImprovementType where ResourceType in (select ResourceType from HDResourceful2_ToDelete);
delete from Improvement_ValidResources where ResourceType in (select ResourceType from HDResourceful2_ToDelete);
delete from Projects_MODE where ResourceType in (select ResourceType from HDResourceful2_ToDelete);
delete from ResourceCorporations where ResourceType in (select ResourceType from HDResourceful2_ToDelete);
delete from ResourceIndustries where ResourceType in (select ResourceType from HDResourceful2_ToDelete);
delete from Types where Type in (select 'GREATWORK_PRODUCT_'|| substr(ResourceType, 10) ||'_1' from HDResourceful2_ToDelete);
delete from Types where Type in (select 'GREATWORK_PRODUCT_'|| substr(ResourceType, 10) ||'_2' from HDResourceful2_ToDelete);
delete from Types where Type in (select 'GREATWORK_PRODUCT_'|| substr(ResourceType, 10) ||'_3' from HDResourceful2_ToDelete);
delete from Types where Type in (select 'GREATWORK_PRODUCT_'|| substr(ResourceType, 10) ||'_4' from HDResourceful2_ToDelete);
delete from Types where Type in (select 'GREATWORK_PRODUCT_'|| substr(ResourceType, 10) ||'_5' from HDResourceful2_ToDelete);
delete from Types where Type in (select 'PROJECT_CREATE_CORPORATION_PRODUCT_'|| substr(ResourceType, 10) from HDResourceful2_ToDelete);