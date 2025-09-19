
--BUILDING_SUK_WAT_ARUN
update Buildings set Cost = 1000, ObsoleteEra = 'ERA_MODERN', PrereqTech = NULL, PrereqCivic = 'CIVIC_HISTORICAL_PHILOSOPHY_HD', AdjacentDistrict = NULL where BuildingType = 'BUILDING_SUK_WAT_ARUN';

delete from Building_GreatPersonPoints where BuildingType = 'BUILDING_SUK_WAT_ARUN';
delete from BuildingModifiers where BuildingType = 'BUILDING_SUK_WAT_ARUN';

-- 招募伟人获得影响力
insert or ignore into Modifiers
	(ModifierId,            ModifierType,                                       SubjectRequirementSetId)
values
	('WAT_ARUN_INFLUNCE',   'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN', 'PLAYER_HAS_BUILDING_SUK_WAT_ARUN_REQUIREMENTS');
insert or ignore into ModifierArguments
	(ModifierId,            Name,       Value)
values
	('WAT_ARUN_INFLUNCE',   'Amount',   1);

-- 泛滥平原相邻加成
insert or ignore into BuildingModifiers
	(BuildingType,									ModifierId)
select
	'BUILDING_SUK_WAT_ARUN',				'HD_WAT_ARUN_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY'
from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

insert or ignore into Modifiers
	(ModifierId,																																ModifierType)
select
	'HD_WAT_ARUN_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',		'MODIFIER_PLAYER_CITIES_FEATURE_ADJACENCY'
from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

insert or ignore into ModifierArguments
	(ModifierId,																															Name,						Value)
select
	'HD_WAT_ARUN_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'DistrictType',	a.DistrictType
from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

insert or ignore into ModifierArguments
	(ModifierId,																															Name,						Value)
select
	'HD_WAT_ARUN_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'FeatureType',	b.FeatureType
from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

insert or ignore into ModifierArguments
	(ModifierId,																															Name,						Value)
select
	'HD_WAT_ARUN_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'YieldType',		a.YieldType
from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

insert or ignore into ModifierArguments
	(ModifierId,																															Name,						Value)
select
	'HD_WAT_ARUN_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'Amount',				1
from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

insert or ignore into ModifierArguments
	(ModifierId,																															Name,						Value)
select
	'HD_WAT_ARUN_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'TilesRequired',2
from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;

insert or ignore into ModifierArguments
	(ModifierId,																															Name,						Value)
select
	'HD_WAT_ARUN_' || a.DistrictType || '_' || b.FeatureType || '_ADJACENCY',	'Description',	'LOC_HD_WAT_ARUN_' || a.YieldType
from DistrictCorrespondingYieldType_HD a, Feature_Floodplains b where a.HasAdjacency = 1;