-------------------------------------
--    Newly added Requirements     --
-------------------------------------

-- River
insert or ignore into Requirements (RequirementId, RequirementType, Inverse) values 
	('REQUIRES_PLOT_NOT_ADJACENT_TO_RIVER', 'REQUIREMENT_PLOT_ADJACENT_TO_RIVER', 1);

-- Units
insert or ignore into Requirements (RequirementId, RequirementType) values 
	('REQUIREMENT_UNIT_IS_SETTLER', 'REQUIREMENT_UNIT_TYPE_MATCHES');
insert or ignore into RequirementArguments (RequirementId, Name, Value) values
	('REQUIREMENT_UNIT_IS_SETTLER', 'UnitType', 'UNIT_SETTLER');
insert or ignore into Requirements (RequirementId, RequirementType) values 
	('REQUIREMENT_UNIT_IS_LAND_COMBAT', 'REQUIREMENT_UNIT_TAG_MATCHES');
insert or ignore into RequirementArguments (RequirementId, Name, Value) values
	('REQUIREMENT_UNIT_IS_LAND_COMBAT', 'Tag', 'CLASS_LAND_COMBAT');
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_UNIT_IS_' || UnitType , 'REQUIREMENT_UNIT_TYPE_MATCHES' from Units;
insert or ignore into RequirementArguments (RequirementId, Name, Value) 
	select 'REQUIRES_UNIT_IS_' || UnitType , 'UnitType', UnitType from Units;
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'UNIT_IS_' || UnitType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Units;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) 
	select 'UNIT_IS_' || UnitType || '_REQUIREMENTS', 'REQUIRES_UNIT_IS_' || UnitType from Units;
insert or ignore into Requirements (RequirementId, RequirementType, Inverse)
	select 'HD_REQUIRES_UNIT_IS_NOT_' || UnitType , 'REQUIREMENT_UNIT_TYPE_MATCHES', 1 from Units;
insert or ignore into RequirementArguments (RequirementId, Name, Value) 	
	select 'HD_REQUIRES_UNIT_IS_NOT_' || UnitType , 'UnitType', UnitType from Units;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_UNIT_IS_' || PromotionClassType , 'REQUIREMENT_UNIT_PROMOTION_CLASS_MATCHES' from UnitPromotionClasses;
insert or ignore into RequirementArguments (RequirementId, Name, Value) 	
	select 'HD_REQUIRES_UNIT_IS_' || PromotionClassType , 'UnitPromotionClass', PromotionClassType from UnitPromotionClasses;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'UNIT_PROMOTION_IS_' || PromotionClassType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from UnitPromotionClasses;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) 
	select 'UNIT_PROMOTION_IS_' || PromotionClassType || '_REQUIREMENTS', 'HD_REQUIRES_UNIT_IS_' || PromotionClassType from UnitPromotionClasses;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) 
	select distinct 'HD_UNIT_IS_MILITARY_REQUIREMENTS', 'HD_REQUIRES_UNIT_IS_' || PromotionClass
from Units where FormationClass in ('FORMATION_CLASS_LAND_COMBAT', 'FORMATION_CLASS_NAVAL', 'FORMATION_CLASS_AIR') and PromotionClass is not Null;

-- Resource
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_' || ResourceType || '_IN_PLOT', 'ResourceType', ResourceType from Resources;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_' || ResourceType || '_IN_PLOT', 'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES' from Resources;
	
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select ResourceType || '_IN_PLOT_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Resources;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) 
	select ResourceType || '_IN_PLOT_REQUIREMENTS', 'REQUIRES_' || ResourceType || '_IN_PLOT' from Resources;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLOT_HAS_' || ResourceType, 'REQUIREMENTSET_TEST_ALL' from Resources;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_HAS_' || ResourceType, 'REQUIRES_' || ResourceType || '_IN_PLOT' from Resources;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLOT_HAS_' || ResourceType || '_ADJACENT', 'REQUIREMENTSET_TEST_ALL' from Resources;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_HAS_' || ResourceType || '_ADJACENT', 'REQUIRES_' || ResourceType || '_IN_PLOT' from Resources;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_HAS_' || ResourceType || '_ADJACENT', 'ADJACENT_TO_OWNER' from Resources;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType, 'ResourceType', ResourceType from Resources;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType, 'REQUIREMENT_CITY_HAS_RESOURCE_TYPE_IMPROVED' from Resources;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_CAN_SEE_' || ResourceType, 'ResourceType', ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLAYER_CAN_SEE_' || ResourceType, 'REQUIREMENT_PLAYER_HAS_RESOURCE_VISIBILITY'
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLAYER_HAS_ENOUGH_' || ResourceType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_HAS_ENOUGH_' || ResourceType || '_REQUIREMENTS', 'REQUIRES_PLAYER_HAS_ENOUGH_' || ResourceType from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLAYER_HAS_ENOUGH_' || ResourceType, 'PropertyName', 'PLAYER_HAS_ENOUGH_' || ResourceType from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLAYER_HAS_ENOUGH_' || ResourceType, 'PropertyMinimum', 1 from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLAYER_HAS_ENOUGH_' || ResourceType, 'REQUIREMENT_PLOT_PROPERTY_MATCHES' from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS', 'REQUIREMENTSET_TEST_ALL' from Resources;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_CITY_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType from Resources;

-- Techs
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_HAS_' || TechnologyType, 'TechnologyType', TechnologyType from Technologies;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLAYER_HAS_' || TechnologyType, 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY' from Technologies;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLAYER_HAS_' || TechnologyType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Technologies;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_HAS_' || TechnologyType || '_REQUIREMENTS', 'HD_REQUIRES_PLAYER_HAS_' || TechnologyType from Technologies;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_HAS_NO_' || TechnologyType, 'TechnologyType', TechnologyType from Technologies;
insert or ignore into Requirements (RequirementId, RequirementType, Inverse)
	select 'HD_REQUIRES_PLAYER_HAS_NO_' || TechnologyType, 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY', 1 from Technologies;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLAYER_HAS_NO_' || TechnologyType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Technologies;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_HAS_NO_' || TechnologyType || '_REQUIREMENTS', 'HD_REQUIRES_PLAYER_HAS_NO_' || TechnologyType from Technologies;

-- Civic
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLAYER_HAS_' || CivicType, 'CivicType', CivicType from Civics;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLAYER_HAS_' || CivicType, 'REQUIREMENT_PLAYER_HAS_CIVIC' from Civics;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_HAS_NO_' || CivicType, 'CivicType', CivicType from Civics;
insert or ignore into Requirements (RequirementId, RequirementType, Inverse)
	select 'HD_REQUIRES_PLAYER_HAS_NO_' || CivicType, 'REQUIREMENT_PLAYER_HAS_CIVIC', 1 from Civics;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLAYER_HAS_' || CivicType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Civics;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_HAS_' || CivicType || '_REQUIREMENTS', 'REQUIRES_PLAYER_HAS_' || CivicType from Civics;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLAYER_HAS_NO_' || CivicType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Civics;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_HAS_NO_' || CivicType || '_REQUIREMENTS', 'HD_REQUIRES_PLAYER_HAS_NO_' || CivicType from Civics;

-- Districts plots
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || DistrictType || '_RAW', 'DistrictType', DistrictType from Districts;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || DistrictType || '_RAW', 'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES' from Districts;
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLOT_ADJACENT_TO_' || DistrictType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_ADJACENT_TO_' || DistrictType || '_REQUIREMENTS', 'REQUIRES_PLOT_ADJACENT_TO_' || DistrictType || '_RAW' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_ADJACENT_TO_' || ReplacesDistrictType || '_REQUIREMENTS', 'REQUIRES_PLOT_ADJACENT_TO_' || CivUniqueDistrictType || '_RAW' from DistrictReplaces;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || DistrictType, 'RequirementSetId', 'PLOT_ADJACENT_TO_' || DistrictType || '_REQUIREMENTS' from Districts;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || DistrictType, 'REQUIREMENT_REQUIREMENTSET_IS_MET' from Districts;

-- Improvements plots
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || ImprovementType, 'ImprovementType', ImprovementType from Improvements;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || ImprovementType, 'REQUIREMENT_PLOT_ADJACENT_IMPROVEMENT_TYPE_MATCHES' from Improvements;
	
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLOT_HAS_' || ImprovementType, 'ImprovementType', ImprovementType from Improvements;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLOT_HAS_' || ImprovementType, 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES' from Improvements;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLOT_HAS_' || ImprovementType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Improvements;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_HAS_' || ImprovementType || '_REQUIREMENTS', 'REQUIRES_PLOT_HAS_' || ImprovementType from Improvements;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLOT_HAS_' || ImprovementType || '_AND_ADJACENT_TO_OWNER_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Improvements;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_HAS_' || ImprovementType || '_AND_ADJACENT_TO_OWNER_REQUIREMENTS', 'REQUIRES_PLOT_HAS_' || ImprovementType from Improvements;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_HAS_' || ImprovementType || '_AND_ADJACENT_TO_OWNER_REQUIREMENTS', 'ADJACENT_TO_OWNER' from Improvements;

-- 改良分类
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLOT_HAS_' || ImprovementClassificationType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from HD_ImprovementClassificationTypes
	where ImprovementClassificationType != 'IMPROVEMENT_CLASSIFICATION_COMMON';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_HAS_' || ImprovementClassificationType || '_REQUIREMENTS', 'REQUIRES_PLOT_HAS_' || ImprovementType from HD_Improvement_Classification
	where ImprovementClassificationType != 'IMPROVEMENT_CLASSIFICATION_COMMON';

insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLOT_HAS_' || ImprovementClassificationType, 'REQUIREMENT_REQUIREMENTSET_IS_MET' from HD_ImprovementClassificationTypes
	where ImprovementClassificationType != 'IMPROVEMENT_CLASSIFICATION_COMMON';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLOT_HAS_' || ImprovementClassificationType, 'RequirementSetId', 'PLOT_HAS_' || ImprovementClassificationType || '_REQUIREMENTS' from HD_ImprovementClassificationTypes
	where ImprovementClassificationType != 'IMPROVEMENT_CLASSIFICATION_COMMON';

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLOT_HAS_' || ImprovementClassificationType || '_AND_ADJACENT_TO_OWNER_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from HD_ImprovementClassificationTypes
	where ImprovementClassificationType != 'IMPROVEMENT_CLASSIFICATION_COMMON';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_HAS_' || ImprovementClassificationType || '_AND_ADJACENT_TO_OWNER_REQUIREMENTS', 'REQUIRES_PLOT_HAS_' || ImprovementClassificationType from HD_ImprovementClassificationTypes
	where ImprovementClassificationType != 'IMPROVEMENT_CLASSIFICATION_COMMON';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_HAS_' || ImprovementClassificationType || '_AND_ADJACENT_TO_OWNER_REQUIREMENTS', 'ADJACENT_TO_OWNER' from HD_ImprovementClassificationTypes
	where ImprovementClassificationType != 'IMPROVEMENT_CLASSIFICATION_COMMON';

-- District 
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_DISTRICT_IS_' || DistrictType, 'DistrictType', DistrictType from Districts;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_DISTRICT_IS_' || DistrictType,	'REQUIREMENT_DISTRICT_TYPE_MATCHES' from Districts;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_DISTRICT_IS_NOT_' || DistrictType, 'DistrictType', DistrictType from Districts;
insert or ignore into Requirements (RequirementId, RequirementType, Inverse)
	select 'HD_REQUIRES_DISTRICT_IS_NOT_' || DistrictType,	'REQUIREMENT_DISTRICT_TYPE_MATCHES',	1 from Districts;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'DISTRICT_IS_' || DistrictType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'DISTRICT_IS_' || DistrictType || '_REQUIREMENTS', 'REQUIRES_DISTRICT_IS_' || DistrictType from Districts;

-- 3环内区域
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'DISTRICT_IS_' || DistrictType || '_WITHIN_3_TILES_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'DISTRICT_IS_' || DistrictType || '_WITHIN_3_TILES_REQUIREMENTS', 'REQUIRES_DISTRICT_IS_' || DistrictType from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'DISTRICT_IS_' || DistrictType || '_WITHIN_3_TILES_REQUIREMENTS', 'REQUIRES_OBJECT_WITHIN_3_TILES' from Districts;

-- 6环内区域
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'DISTRICT_IS_' || DistrictType || '_WITHIN_6_TILES_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'DISTRICT_IS_' || DistrictType || '_WITHIN_6_TILES_REQUIREMENTS', 'REQUIRES_DISTRICT_IS_' || DistrictType from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'DISTRICT_IS_' || DistrictType || '_WITHIN_6_TILES_REQUIREMENTS', 'REQUIRES_OBJECT_WITHIN_6_TILES' from Districts;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_CITY_HAS_' || DistrictType || '_RAW', 'DistrictType', DistrictType from Districts;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_CITY_HAS_' || DistrictType || '_RAW', 'REQUIREMENT_CITY_HAS_DISTRICT' from Districts;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'REQUIRES_CITY_HAS_' || DistrictType || '_UDMET', 'REQUIREMENTSET_TEST_ANY' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'REQUIRES_CITY_HAS_' || DistrictType || '_UDMET', 'REQUIRES_CITY_HAS_' || DistrictType || '_RAW' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'REQUIRES_CITY_HAS_' || ReplacesDistrictType || '_UDMET', 'REQUIRES_CITY_HAS_' || CivUniqueDistrictType || '_RAW' from DistrictReplaces;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_CITY_HAS_' || DistrictType, 'RequirementSetId', 'REQUIRES_CITY_HAS_' || DistrictType || '_UDMET' from Districts;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_CITY_HAS_' || DistrictType, 'REQUIREMENT_REQUIREMENTSET_IS_MET' from Districts;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_DISTRICT_IS_' || DistrictType || '_RAW', 'DistrictType', DistrictType from Districts;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_DISTRICT_IS_' || DistrictType || '_RAW', 'REQUIREMENT_DISTRICT_TYPE_MATCHES' from Districts;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET', 'REQUIREMENTSET_TEST_ANY' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET', 'REQUIRES_DISTRICT_IS_' || DistrictType || '_RAW' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'REQUIRES_DISTRICT_IS_' || ReplacesDistrictType || '_UDMET', 'REQUIRES_DISTRICT_IS_' || CivUniqueDistrictType || '_RAW' from DistrictReplaces;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_DISTRICT_IS_' || DistrictType || '_HD', 'RequirementSetId', 'REQUIRES_DISTRICT_IS_' || DistrictType || '_UDMET' from Districts;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_DISTRICT_IS_' || DistrictType || '_HD', 'REQUIREMENT_REQUIREMENTSET_IS_MET' from Districts;
	
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_CITY_DOES_NOT_HAVE_' || DistrictType, 'RequirementSetId', 'REQUIRES_CITY_HAS_' || DistrictType || '_UDMET' from Districts;
insert or ignore into Requirements (RequirementId, RequirementType, Inverse)
	select 'REQUIRES_CITY_DOES_NOT_HAVE_' || DistrictType, 'REQUIREMENT_REQUIREMENTSET_IS_MET', 1 from Districts;
	
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'CITY_DOES_NOT_HAVE_' || DistrictType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'CITY_DOES_NOT_HAVE_' || DistrictType || '_REQUIREMENTS', 'REQUIRES_CITY_DOES_NOT_HAVE_' || DistrictType from Districts;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'CITY_HAS_' || DistrictType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'CITY_HAS_' || DistrictType || '_REQUIREMENTS', 'REQUIRES_CITY_HAS_' || DistrictType from Districts;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLAYER_HAS_' || DistrictType, 'DistrictType', DistrictType from Districts;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLAYER_HAS_' || DistrictType, 'REQUIREMENT_PLAYER_HAS_DISTRICT' from Districts;
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLAYER_HAS_' || DistrictType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_HAS_' || DistrictType || '_REQUIREMENTS', 'REQUIRES_PLAYER_HAS_' || DistrictType from Districts;

	-- 通电城市拥有XX区域
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'POWERED_CITY_HAS_' || DistrictType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'POWERED_CITY_HAS_' || DistrictType || '_REQUIREMENTS', 'REQUIRES_CITY_HAS_' || DistrictType from Districts;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'POWERED_CITY_HAS_' || DistrictType || '_REQUIREMENTS', 'REQUIRES_CITY_IS_POWERED' from Districts;
	
-- Buildings
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_CITY_HAS_' || BuildingType, 'BuildingType', BuildingType from Buildings;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_CITY_HAS_' || BuildingType, 'REQUIREMENT_CITY_HAS_BUILDING' from Buildings;
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'CITY_HAS_' || BuildingType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Buildings;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'CITY_HAS_' || BuildingType || '_REQUIREMENTS', 'REQUIRES_CITY_HAS_' || BuildingType from Buildings;
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'DISTRICT_HAS_' || BuildingType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Buildings;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'DISTRICT_HAS_' || BuildingType || '_REQUIREMENTS', 'REQUIRES_CITY_HAS_' || BuildingType from Buildings;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'DISTRICT_HAS_' || BuildingType || '_REQUIREMENTS', 'REQUIRES_DISTRICT_IS_' || PrereqDistrict from Buildings;
	
-- 有书院和学院建筑
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'CITY_HAS_SEOWON_AND_' || BuildingType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL' from Buildings where PrereqDistrict = 'DISTRICT_CAMPUS';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'CITY_HAS_SEOWON_AND_' || BuildingType || '_REQUIREMENTS', 'REQUIRES_CITY_HAS_' || BuildingType from Buildings where PrereqDistrict = 'DISTRICT_CAMPUS';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'CITY_HAS_SEOWON_AND_' || BuildingType || '_REQUIREMENTS', 'REQUIRES_CITY_HAS_DISTRICT_SEOWON_RAW' from Buildings where PrereqDistrict = 'DISTRICT_CAMPUS';

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLAYER_HAS_' || BuildingType, 'BuildingType', BuildingType from Buildings;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLAYER_HAS_' || BuildingType, 'REQUIREMENT_PLAYER_HAS_BUILDING' from Buildings;
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLAYER_HAS_' || BuildingType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Buildings;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_HAS_' || BuildingType || '_REQUIREMENTS', 'REQUIRES_PLAYER_HAS_' || BuildingType from Buildings;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || BuildingType, 'BuildingType', BuildingType from Buildings;
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || BuildingType, 'MinRange', 1 from Buildings;
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || BuildingType, 'MaxRange', 1 from Buildings;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLOT_ADJACENT_TO_' || BuildingType, 'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES' from Buildings;
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLOT_ADJACENT_TO_' || BuildingType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Buildings;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_ADJACENT_TO_' || BuildingType || '_REQUIREMENTS', 'REQUIRES_PLOT_ADJACENT_TO_' || BuildingType from Buildings;

insert or ignore into Requirements	(RequirementId,	RequirementType)
select 'PLOT_HAS_' || BuildingType, 'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES' from Buildings;
insert or ignore into RequirementArguments	(RequirementId,	Name, Value)
select 'PLOT_HAS_' || BuildingType, 'BuildingType', BuildingType from Buildings;
insert or ignore into RequirementArguments	(RequirementId,	Name, Value)
select 'PLOT_HAS_' || BuildingType, 'MinRange', 0 from Buildings;
insert or ignore into RequirementArguments	(RequirementId,	Name, Value)
select 'PLOT_HAS_' || BuildingType, 'MaxRange', 0 from Buildings;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLOT_HAS_' || BuildingType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Buildings where IsWonder = 0;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_HAS_' || BuildingType || '_REQUIREMENTS', 'PLOT_HAS_' || BuildingType from Buildings where IsWonder = 0;
	-- UD适配
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_HAS_' || a.BuildingType || '_REQUIREMENTS', 'PLOT_HAS_' || b.CivUniqueBuildingType
	from Buildings a inner join BuildingReplaces b on a.BuildingType = b.ReplacesBuildingType where a.IsWonder = 0;

-- 判断单元格是否有XX奇观
insert or ignore into RequirementSets
	(RequirementSetId,																				RequirementSetType)
select
	'HD_PLOT_HAS_WONDER_' || BuildingType || '_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'
from Buildings where IsWonder = 1 and BuildingType not like '%_INTERNAL';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,																				RequirementId)
select
	'HD_PLOT_HAS_WONDER_' || BuildingType || '_REQUIREMENTS',	'PLOT_HAS_' || BuildingType
from Buildings where IsWonder = 1 and BuildingType not like '%_INTERNAL';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,																				RequirementId)
select
	'HD_PLOT_HAS_WONDER_' || BuildingType || '_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_DISTRICT_WONDER'
from Buildings where IsWonder = 1 and BuildingType not like '%_INTERNAL';

-- Player Eras
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLAYER_IS_' || EraType, 'EraType', EraType from Eras;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLAYER_IS_' || EraType, 'REQUIREMENT_PLAYER_ERA_AT_LEAST' from Eras;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLAYER_IS_' || EraType, 'REQUIREMENTSET_TEST_ALL' from Eras;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLAYER_IS_' || EraType, 'REQUIRES_PLAYER_IS_' || EraType from Eras;

-- Opponent Eras Less than
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_OPPONENT_LESSTHAN_' || EraType, 'EraType', EraType from Eras;
insert or ignore into Requirements (RequirementId, RequirementType, Inverse)
	select 'REQUIRES_OPPONENT_LESSTHAN_' || EraType, 'REQUIREMENT_OPPONENT_ERA_AT_LEAST', 1 from Eras;

-- Game Eras
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_ERA_IS_' || EraType, 'EraType', EraType from Eras;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_ERA_IS_' || EraType, 'REQUIREMENT_GAME_ERA_IS' from Eras;

-- City Has Features & Natural Wonders
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_CITY_HAS_' || FeatureType, 'FeatureType', FeatureType from Features;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_CITY_HAS_' || FeatureType, 'REQUIREMENT_CITY_HAS_FEATURE' from Features;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_CITY_HAS_' || FeatureType, 'REQUIREMENTSET_TEST_ALL' from Features;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_CITY_HAS_' || FeatureType, 'REQUIRES_CITY_HAS_' || FeatureType from Features;

-- City Has Terrain
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_CITY_HAS_' || TerrainType, 'TerrainType', TerrainType from Terrains;
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_CITY_HAS_' || TerrainType, 'Amount', 2 from Terrains;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_CITY_HAS_' || TerrainType, 'REQUIREMENT_CITY_HAS_X_TERRAIN_TYPE' from Terrains;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_CITY_HAS_' || TerrainType, 'REQUIREMENTSET_TEST_ALL' from Terrains;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_CITY_HAS_' || TerrainType, 'REQUIRES_CITY_HAS_' || TerrainType from Terrains;

-- Player Has Feature
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_PLAYER_HAS_' || FeatureType, 'FeatureType', FeatureType from Features;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_PLAYER_HAS_' || FeatureType, 'REQUIREMENT_PLAYER_HAS_FEATURE' from Features;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLAYER_HAS_' || FeatureType, 'REQUIREMENTSET_TEST_ALL' from Features;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLAYER_HAS_' || FeatureType, 'REQUIRES_PLAYER_HAS_' || FeatureType from Features;

-- 玩家有改良的资源
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_HAS_IMPROVED_' || ResourceType, 'ResourceType', ResourceType from Resources;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLAYER_HAS_IMPROVED_' || ResourceType, 'REQUIREMENT_PLAYER_HAS_RESOURCE_IMPROVED' from Resources;
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS', 'REQUIREMENTSET_TEST_ALL' from Resources;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLAYER_HAS_IMPROVED_' || ResourceType || '_REQUIRMENTS', 'HD_REQUIRES_PLAYER_HAS_IMPROVED_' || ResourceType from Resources;

-- Plot Has Terrains
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLOT_HAS_' || TerrainType, 'TerrainType', TerrainType from Terrains;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLOT_HAS_' || TerrainType, 'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES' from Terrains;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLOT_HAS_' || TerrainType, 'REQUIREMENTSET_TEST_ALL' from Terrains;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_HAS_' || TerrainType, 'HD_REQUIRES_PLOT_HAS_' || TerrainType from Terrains;

-- Plot Adjacent to Terrains
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLOT_ADJACENT_TO_' || TerrainType, 'TerrainType', TerrainType from Terrains;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLOT_ADJACENT_TO_' || TerrainType, 'REQUIREMENT_PLOT_ADJACENT_TERRAIN_TYPE_MATCHES' from Terrains;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLOT_ADJACENT_TO_' || TerrainType, 'REQUIREMENTSET_TEST_ALL' from Terrains;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_ADJACENT_TO_' || TerrainType, 'HD_REQUIRES_PLOT_ADJACENT_TO_' || TerrainType from Terrains;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLOT_ON_OR_ADJACENT_TO_' || TerrainType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Terrains;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_ON_OR_ADJACENT_TO_' || TerrainType || '_REQUIREMENTS', 'HD_REQUIRES_PLOT_HAS_' || TerrainType from Terrains;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_ON_OR_ADJACENT_TO_' || TerrainType || '_REQUIREMENTS', 'HD_REQUIRES_PLOT_ADJACENT_TO_' || TerrainType from Terrains;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLOT_ON_OR_ADJACENT_TO_' || TerrainType, 'RequirementSetId', 'PLOT_ON_OR_ADJACENT_TO_' || TerrainType || '_REQUIREMENTS' from Terrains;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLOT_ON_OR_ADJACENT_TO_' || TerrainType, 'REQUIREMENT_REQUIREMENTSET_IS_MET' from Terrains;

-- Plot Has Features & Natural Wonders
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLOT_HAS_' || FeatureType, 'FeatureType', FeatureType from Features;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLOT_HAS_' || FeatureType, 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES' from Features;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLOT_HAS_' || FeatureType, 'REQUIREMENTSET_TEST_ALL' from Features;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_HAS_' || FeatureType, 'HD_REQUIRES_PLOT_HAS_' || FeatureType from Features;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_HAS_NATURAL_WONDER_REQUIREMENTS', 'HD_REQUIRES_PLOT_HAS_' || FeatureType from Features where NaturalWonder = 1;

-- Plot Adjacent to Features & Natural Wonders
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType, 'FeatureType', FeatureType from Features;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType, 'REQUIREMENT_PLOT_ADJACENT_FEATURE_TYPE_MATCHES' from Features;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLOT_ADJACENT_TO_' || FeatureType, 'REQUIREMENTSET_TEST_ALL' from Features;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_ADJACENT_TO_' || FeatureType, 'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType from Features;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLOT_ON_OR_ADJACENT_TO_' || FeatureType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY' from Features;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_ON_OR_ADJACENT_TO_' || FeatureType || '_REQUIREMENTS', 'HD_REQUIRES_PLOT_HAS_' || FeatureType from Features;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_ON_OR_ADJACENT_TO_' || FeatureType || '_REQUIREMENTS', 'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType from Features;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLOT_ON_OR_ADJACENT_TO_' || FeatureType, 'RequirementSetId', 'PLOT_ON_OR_ADJACENT_TO_' || FeatureType || '_REQUIREMENTS' from Features;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLOT_ON_OR_ADJACENT_TO_' || FeatureType, 'REQUIREMENT_REQUIREMENTSET_IS_MET' from Features;

-- civlization
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLAYER_IS_' || CivilizationType || '_RAW', 'REQUIREMENT_PLAYER_TYPE_MATCHES'
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_IS_' || CivilizationType || '_RAW', 'CivilizationType'	, CivilizationType
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';

insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLAYER_IS_' || CivilizationType || '_PLOT_PROPERTY', 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_IS_' || CivilizationType || '_PLOT_PROPERTY', 'PropertyName', CivilizationType || '_CAPTURED'
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_IS_' || CivilizationType || '_PLOT_PROPERTY', 'PropertyMinimum', 1
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLAYER_IS_' || CivilizationType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY'
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_IS_' || CivilizationType || '_REQUIREMENTS', 'HD_REQUIRES_PLAYER_IS_' || CivilizationType || '_RAW'
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_IS_' || CivilizationType || '_REQUIREMENTS', 'HD_REQUIRES_PLAYER_IS_' || CivilizationType || '_PLOT_PROPERTY'
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';

	-- Met Requirements
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'PLAYER_IS_' || CivilizationType, 'REQUIREMENT_REQUIREMENTSET_IS_MET'
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'PLAYER_IS_' || CivilizationType, 'RequirementSetId', 'PLAYER_IS_' || CivilizationType || '_REQUIREMENTS'
	from Civilizations where StartingCivilizationLevelType = 'CIVILIZATION_LEVEL_FULL_CIV';

 -- leader
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLAYER_IS_' || LeaderType || '_RAW', 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES'
	from Leaders where InheritFrom = 'LEADER_DEFAULT';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_IS_' || LeaderType || '_RAW', 'LeaderType'	, LeaderType
	from Leaders where InheritFrom = 'LEADER_DEFAULT';

insert or ignore into Requirements (RequirementId, RequirementType)
	select 'HD_REQUIRES_PLAYER_IS_' || LeaderType || '_PLOT_PROPERTY', 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
	from Leaders where InheritFrom = 'LEADER_DEFAULT';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_IS_' || LeaderType || '_PLOT_PROPERTY', 'PropertyName', LeaderType || '_CAPTURED'
	from Leaders where InheritFrom = 'LEADER_DEFAULT';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'HD_REQUIRES_PLAYER_IS_' || LeaderType || '_PLOT_PROPERTY', 'PropertyMinimum', 1
	from Leaders where InheritFrom = 'LEADER_DEFAULT';

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_PLAYER_IS_' || LeaderType || '_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY'
	from Leaders where InheritFrom = 'LEADER_DEFAULT';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLAYER_IS_' || LeaderType || '_REQUIREMENTS', 'HD_REQUIRES_PLAYER_IS_' || LeaderType || '_RAW'
	from Leaders where InheritFrom = 'LEADER_DEFAULT';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLAYER_IS_' || LeaderType || '_REQUIREMENTS', 'HD_REQUIRES_PLAYER_IS_' || LeaderType || '_PLOT_PROPERTY'
	from Leaders where InheritFrom = 'LEADER_DEFAULT';

-- City has X Pop
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_CITY_HAS_'  || Pop || '_POPULATION', 'Amount', Pop from PopulationMaintenance;
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_CITY_HAS_'  || Pop || '_POPULATION', 'REQUIREMENT_CITY_HAS_X_POPULATION' from PopulationMaintenance;
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'CITY_HAS_' || Pop || '_POPULATION', 'REQUIREMENTSET_TEST_ALL' from PopulationMaintenance;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'CITY_HAS_' || Pop || '_POPULATION', 'REQUIRES_CITY_HAS_'  || Pop || '_POPULATION' from PopulationMaintenance;

-- Use insert or ignore to support the missing DLC case.
insert or ignore into Requirements
	(RequirementId,									RequirementType)
values
	('REQUIRES_PLOT_IS_LAKE',						'REQUIREMENT_PLOT_IS_LAKE'),
	('REQUIRES_CITY_HAS_WONDER',					'REQUIREMENT_CITY_HAS_ANY_WONDER'),
	('REQUIRES_PLOT_ADJACENT_TO_AQUEDUCT',			'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES');

insert or ignore into Requirements
	(RequirementId,									RequirementType,				Inverse)
values
	('PLOT_IS_NOT_LAKE_REQUIREMENTS',				'REQUIREMENT_PLOT_IS_LAKE',		1);

insert or ignore into RequirementArguments
	(RequirementId,									Name,				Value)
values
	('REQUIRES_PLOT_ADJACENT_TO_AQUEDUCT',			'DistrictType',		'DISTRICT_AQUEDUCT');

-- Misc

-- new Terrain class
insert or ignore into Types
	(Type,								Kind)
values
	('TERRAIN_CLASS_TUNDRA_OR_SNOW',	'KIND_TERRAIN_CLASS'),
	('TERRAIN_CLASS_FLATTEN',			'KIND_TERRAIN_CLASS'),
	('TERRAIN_CLASS_HILLS',				'KIND_TERRAIN_CLASS');
insert or ignore into TerrainClasses
	(TerrainClassType,					Name)
values
	('TERRAIN_CLASS_TUNDRA_OR_SNOW',	'LOC_TERRAIN_CLASS_TUNDRA_OR_SNOW_NAME'),
	('TERRAIN_CLASS_FLATTEN',			'LOC_TERRAIN_CLASS_FLATTEN_NAME'),
	('TERRAIN_CLASS_HILLS',				'LOC_TERRAIN_CLASS_HILLS_NAME');

insert or ignore into TerrainClass_Terrains
	(TerrainClassType,					TerrainType)
values
	('TERRAIN_CLASS_TUNDRA_OR_SNOW',	'TERRAIN_TUNDRA'),
	('TERRAIN_CLASS_TUNDRA_OR_SNOW',	'TERRAIN_TUNDRA_HILLS'),
	('TERRAIN_CLASS_TUNDRA_OR_SNOW',	'TERRAIN_SNOW'),
	('TERRAIN_CLASS_TUNDRA_OR_SNOW',	'TERRAIN_SNOW_HILLS'),
	('TERRAIN_CLASS_FLATTEN',			'TERRAIN_GRASS'),
	('TERRAIN_CLASS_FLATTEN',			'TERRAIN_PLAINS'),
	('TERRAIN_CLASS_FLATTEN',			'TERRAIN_DESERT'),
	('TERRAIN_CLASS_FLATTEN',			'TERRAIN_TUNDRA'),
	('TERRAIN_CLASS_FLATTEN',			'TERRAIN_SNOW'),
	('TERRAIN_CLASS_HILLS',				'TERRAIN_GRASS_HILLS'),
	('TERRAIN_CLASS_HILLS',				'TERRAIN_PLAINS_HILLS'),
	('TERRAIN_CLASS_HILLS',				'TERRAIN_DESERT_HILLS'),
	('TERRAIN_CLASS_HILLS',				'TERRAIN_TUNDRA_HILLS'),
	('TERRAIN_CLASS_HILLS',				'TERRAIN_SNOW_HILLS');

insert or ignore into Requirements
	(RequirementId,									RequirementType,							Inverse)
values
	-- ('REQUIRES_UNIT_NOT_BARBARIAN_GALLEY', 			'REQUIREMENT_UNIT_TYPE_MATCHES',			1),
	('REQUIRES_PLAYER_HAS_NO_DIPLOMATIC_QUARTER',	'REQUIREMENT_PLAYER_HAS_DISTRICT',			1),
	('REQUIRES_PLOT_HAS_NOT_OCEAN',					'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES',	1),
	('REQUIRES_OBJECT_OUTOF_7_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER',		1),
	('REQUIRES_CITY_HAS_NO_FILM_STUDIO',			'REQUIREMENT_CITY_HAS_BUILDING',			1),
	('REQUIRES_PLAYER_NOT_HAS_CIVIC_URBANIZATION',	'REQUIREMENT_PLAYER_HAS_CIVIC',				1),
	-- ('REQUIRES_PLAYER_NOT_FOUNDED_RELIGION',			'REQUIREMENT_PLOT_PROPERTY_MATCHES',		1),
	('REQUIRES_CITY_HAS_NOT_PALACE',		'REQUIREMENT_CITY_HAS_BUILDING',					1),
	('UNIT_IN_NOT_OWNER_TERRITORY_REQUIREMENT',		'REQUIREMENT_UNIT_IN_OWNER_TERRITORY',					1),
	('REQUIRES_CITY_HAS_NO_VERTICAL_INTEGRATION',		'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE',	1);

insert or ignore into Requirements
	(RequirementId,									RequirementType)
values
    ('REQUIRES_WITHIN_NINE_TILES_FROM_OWNER',       'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_CITY_HAS_1_DESERT',					'REQUIREMENT_CITY_HAS_X_TERRAIN_TYPE'),
	('REQUIRES_CITY_HAS_1_TUNDRA',					'REQUIREMENT_CITY_HAS_X_TERRAIN_TYPE'),
	('REQUIRES_PLOT_IS_TUNDRA_OR_SNOW',				'REQUIREMENT_PLOT_TERRAIN_CLASS_MATCHES'),
	('REQUIRES_PLOT_IS_FLATTEN',					'REQUIREMENT_PLOT_TERRAIN_CLASS_MATCHES'),
	('REQUIRES_PLOT_IS_HILLS',						'REQUIREMENT_PLOT_TERRAIN_CLASS_MATCHES'),
	('REQUIRES_THIS_WONDER_IS_AT_LEAST_MIEDIVAL',	'REQUIREMENT_PLOT_WONDER_IS_ERA'),
	('REQUIRES_THIS_WONDER_IS_AT_LEAST_ANCIENT',	'REQUIREMENT_PLOT_WONDER_IS_ERA'),
	('REQUIRES_AIRPORT_AND_WITHIN_9TILES',			'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES'),
	('REQUIRES_PLOT_WITHIN_EIGHT_CITY_CENTER',		'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES'),
	('PLOT_IS_COASTAL_LAND',						'REQUIREMENT_PLOT_IS_COASTAL_LAND'),
	('HD_REQUIRES_PLOT_ADJACENT_TO_COAST',      	'REQUIREMENT_PLOT_ADJACENT_TERRAIN_TYPE_MATCHES'),
	('HD_PLOT_IS_COAST_NOT_LAKE_MET',				'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('HD_PLOT_ADJACENT_TO_COAST_NOT_LAKE_MET',		'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_RESOUCE_ADJACENT_TO_LAKE',			'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_OBJECT_WITHIN_0_TILE',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_1_TILE',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_3_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_4_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_5_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_6_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_7_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_8_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_9_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_10_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('REQUIRES_OBJECT_WITHIN_12_TILES',				'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('HD_PLOT_HAS_RESOURCE_FARM',       			'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('HD_PLOT_HAS_RESOURCE_MINE',       			'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('HD_PLOT_HAS_RESOURCE_LUMBER_MILL',       		'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('HD_PLOT_HAS_RESOURCE_CAMP',       			'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('PLOT_IS_OR_ADJACENT_TO_COAST_REQUIREMENTS',	'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_PLOT_IS_OR_ADJACENT_TO_DESERT',		'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_DISTRICT_IS_CHICHEN_ITZA_DISTRICTS',	'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_PLOT_HAS_SHALLOW_WATER',				'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES'),
	('HD_REQUIRES_PLAYER_HAS_FAVOR',				'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
	('REQUIRES_PLAYER_HAS_ENOUGH_HORSES',			'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
	('REQUIRES_PLAYER_HAS_ENOUGH_IRON',				'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
	('REQUIRES_CITY_HAS_VERTICAL_INTEGRATION',		'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE'),
	('REQUIRES_CITY_HAS_CONTRACTOR',				'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE'),
	('REQUIRES_CITY_HAS_AMBASSADOR_MESSENGER',		'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE'),	
	('REQUIRES_CITY_HAS_MULTINATIONAL_CORP',		'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE'),	
	('HD_PLOT_APPEAL_LESS_THAN_0',		'REQUIREMENT_PLOT_IS_APPEAL_BETWEEN'),
	('HD_PLOT_APPEAL_MORE_THAN_8',		'REQUIREMENT_PLOT_IS_APPEAL_BETWEEN'),	
	('HD_REQUIRES_PLOT_ADJACENT_TO_ANY_DISTRICT',		'REQUIREMENT_REQUIREMENTSET_IS_MET'),	
	('REQUIRES_CITY_HAS_4_SPECIALTY_DISTRICTS',		'REQUIREMENT_CITY_HAS_X_SPECIALTY_DISTRICTS'),
	('REQUIRES_CITY_HAS_6_SPECIALTY_DISTRICTS',		'REQUIREMENT_CITY_HAS_X_SPECIALTY_DISTRICTS'),
	('HD_REQUIRES_TEMPLE_ARTEMIS_IMPROVEMENTS',		'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIREMENT_UNIT_IS_SCIENTIST',		'REQUIREMENT_GREAT_PERSON_TYPE_MATCHES'),
	-- ('HD_REQUIRES_PUBLIC_TRANSPORT_AT_RADIUS_ONE',		'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_PLOT_AT_RADIUS_3',		'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	-- ('REQUIRES_PLAYER_HAS_FOUNDED_RELIGION',		'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
	('HD_CITY_IS_SAME_CONTINENT_REQUIREMENTS','REQUIREMENT_CITY_IS_OWNER_CAPITAL_CONTINENT'),
	('HD_REQUIRES_DISTRICT_IS_SPECIALTY_DISTRICT',						'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_DISTRICT_IS_WONDER_THEATER_HOLY_SITE_COMMERCIAL_HUB',	'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_CITY_HAS_SEAPORT',				'REQUIREMENT_CITY_HAS_BUILDING'),
	('REQUIRES_CITY_HAS_TIER_2_HARBOR_BUILDINGS_MET',				'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_CITY_HAS_TIER_2_COMMERCIAL_HUB_BUILDINGS_MET',				'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_PLAYER_HAS_NOT_FOUNDED_A_RELIGION',				'REQUIREMENT_PLAYER_FOUNDED_NO_RELIGION'),
	('REQUIRES_ADJACENT_TO_LAKE_OR_LAKE',				'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_HD_FIR_EXPEDITION_FEATURES',				'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_HD_HEROES_RETURN_WITHIN_TURNS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
	('REQUIRES_HD_IMMORTAL_SEARCH_ENKIDU_DEAD',				'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
	('REQUIRES_HD_PLOT_HAS_GOVERNMENT_OR_DIPLO_DISTRICTS',				'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_HD_MADRASA_FAITH_PURCHASE_CAMPUS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
	('REQUIRES_HD_MADRASA_FAITH_PURCHASE_THEATER',				'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
	('REQUIRES_HD_IS_HOLY_CITY',				'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
	('REQUIRES_PLOT_HAS_CIV_OR_CITYSTATE_UNIQUE',				'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('HD_REQUIRES_PLOT_ADJACENT_TO_LAND_OR_HARBOR',			'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_PLOT_HAS_ROBOT_PRODUCTION_IMPROVEMENT',			'REQUIREMENT_REQUIREMENTSET_IS_MET');

insert or ignore into RequirementArguments
	(RequirementId,									Name,				Value)
values
	('REQUIRES_PLAYER_NOT_HAS_CIVIC_URBANIZATION',	'CivicType',		'CIVIC_URBANIZATION'),
	('REQUIRES_CITY_HAS_1_DESERT',					'TerrainType',		'TERRAIN_DESERT'),
	('REQUIRES_CITY_HAS_1_DESERT',					'Hills',			1),
	('REQUIRES_CITY_HAS_1_DESERT',					'Amount',			2), 
	('REQUIRES_CITY_HAS_1_TUNDRA',					'TerrainType',		'TERRAIN_TUNDRA'),
	('REQUIRES_CITY_HAS_1_TUNDRA',					'Hills',			1),
	('REQUIRES_CITY_HAS_1_TUNDRA',					'Amount',			2),
	('REQUIRES_PLOT_IS_TUNDRA_OR_SNOW',				'TerrainClass',		'TERRAIN_CLASS_TUNDRA_OR_SNOW'),
	('REQUIRES_PLOT_IS_FLATTEN',					'TerrainClass',		'TERRAIN_CLASS_FLATTEN'),
	('REQUIRES_PLOT_IS_HILLS',						'TerrainClass',		'TERRAIN_CLASS_HILLS'),
	('REQUIRES_THIS_WONDER_IS_AT_LEAST_MIEDIVAL',	'EarliestEra',		'ERA_MEDIEVAL'),
	('REQUIRES_THIS_WONDER_IS_AT_LEAST_MIEDIVAL',	'LatestEra',		'ERA_FUTURE'),
	('REQUIRES_THIS_WONDER_IS_AT_LEAST_ANCIENT',	'EarliestEra',		'ERA_ANCIENT'),
	('REQUIRES_THIS_WONDER_IS_AT_LEAST_ANCIENT',	'LatestEra',		'ERA_FUTURE'),
	('REQUIRES_PLAYER_HAS_NO_DIPLOMATIC_QUARTER',	'DistrictType',		'DISTRICT_DIPLOMATIC_QUARTER'),
	('REQUIRES_PLOT_HAS_NOT_OCEAN',					'TerrainType',		'TERRAIN_OCEAN'),
	('REQUIRES_CITY_HAS_NO_FILM_STUDIO',			'BuildingType',		'BUILDING_FILM_STUDIO'),
	('REQUIRES_CITY_HAS_NO_FILM_STUDIO',			'MustBeFunctioning',	1),	
	('REQUIRES_WITHIN_NINE_TILES_FROM_OWNER',		'MinDistance',		0),
	('REQUIRES_WITHIN_NINE_TILES_FROM_OWNER',		'MaxDistance',		9),
	('REQUIRES_AIRPORT_AND_WITHIN_9TILES',			'BuildingType',		'BUILDING_AIRPORT'),
	('REQUIRES_AIRPORT_AND_WITHIN_9TILES',			'MinRange',			0),
	('REQUIRES_AIRPORT_AND_WITHIN_9TILES',			'MaxRange',			9),
	('REQUIRES_PLOT_WITHIN_EIGHT_CITY_CENTER',		'DistrictType',		'DISTRICT_CITY_CENTER'),
	('REQUIRES_PLOT_WITHIN_EIGHT_CITY_CENTER',		'MinRange',			0),
	('REQUIRES_PLOT_WITHIN_EIGHT_CITY_CENTER',		'MaxRange',			8),
	('HD_PLOT_IS_COAST_NOT_LAKE_MET',				'RequirementSetId',	'PLOT_IS_COAST_NOT_LAKE_REQUIREMENTS'),
	('HD_PLOT_ADJACENT_TO_COAST_NOT_LAKE_MET',		'RequirementSetId',	'PLOT_IS_COASTAL_LAND_REQUIREMENTS'),
	('HD_REQUIRES_PLOT_ADJACENT_TO_COAST', 			'TerrainType',		'TERRAIN_COAST'),
	('HD_REQUIRES_PLOT_ADJACENT_TO_COAST', 			'MaxRange',		  	'1'),
	('REQUIRES_PLAYER_HAS_ENOUGH_HORSES',			'PropertyName',		'PLAYER_HAS_ENOUGH_RESOURCE_HORSES'),
	('REQUIRES_PLAYER_HAS_ENOUGH_HORSES',			'PropertyMinimum',	1),
	('REQUIRES_PLAYER_HAS_ENOUGH_IRON',				'PropertyName',		'PLAYER_HAS_ENOUGH_RESOURCE_IRON'),
	('REQUIRES_PLAYER_HAS_ENOUGH_IRON',				'PropertyMinimum',	1),
	('REQUIRES_RESOUCE_ADJACENT_TO_LAKE',			'RequirementSetId', 'RESOUCE_ADJACENT_TO_LAKE'),
	('REQUIRES_OBJECT_WITHIN_0_TILE',				'MaxDistance',		0),
	('REQUIRES_OBJECT_WITHIN_0_TILE',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_1_TILE',				'MaxDistance',		1),
	('REQUIRES_OBJECT_WITHIN_1_TILE',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_3_TILES',				'MaxDistance',		3),
	('REQUIRES_OBJECT_WITHIN_3_TILES',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_4_TILES',				'MaxDistance',		4),
	('REQUIRES_OBJECT_WITHIN_4_TILES',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_5_TILES',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_5_TILES',				'MaxDistance',		5),
	('REQUIRES_OBJECT_WITHIN_6_TILES',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_6_TILES',				'MaxDistance',		6),
	('REQUIRES_OBJECT_WITHIN_7_TILES',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_7_TILES',				'MaxDistance',		7),
	('REQUIRES_OBJECT_WITHIN_8_TILES',				'MaxDistance',		8),
	('REQUIRES_OBJECT_WITHIN_8_TILES',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_9_TILES',				'MaxDistance',		9),
	('REQUIRES_OBJECT_WITHIN_9_TILES',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_10_TILES',				'MaxDistance',		10),
	('REQUIRES_OBJECT_WITHIN_10_TILES',				'MinDistance',		0),
	('REQUIRES_OBJECT_WITHIN_12_TILES',				'MaxDistance',		12),
	('REQUIRES_OBJECT_WITHIN_12_TILES',				'MinDistance',		0),
	('REQUIRES_OBJECT_OUTOF_7_TILES',				'MaxDistance',		6),
	('REQUIRES_OBJECT_OUTOF_7_TILES',				'MinDistance',		0),
	('HD_PLOT_HAS_RESOURCE_FARM',       			'RequirementSetId',	'HD_PLOT_HAS_RESOURCE_FARM_REQUIREMENTS'),
	('HD_PLOT_HAS_RESOURCE_MINE',       			'RequirementSetId',	'HD_PLOT_HAS_RESOURCE_MINE_REQUIREMENTS'),
	('HD_PLOT_HAS_RESOURCE_LUMBER_MILL',       		'RequirementSetId',	'HD_PLOT_HAS_RESOURCE_LUMBER_MILL_REQUIREMENTS'),
	('HD_PLOT_HAS_RESOURCE_CAMP',       			'RequirementSetId',	'HD_PLOT_HAS_RESOURCE_CAMP_REQUIREMENTS'),
	('PLOT_IS_OR_ADJACENT_TO_COAST_REQUIREMENTS',	'RequirementSetId',	'PLOT_IS_OR_ADJACENT_TO_COAST'),
	('REQUIRES_PLOT_IS_OR_ADJACENT_TO_DESERT',		'RequirementSetId',	'PLOT_IS_OR_ADJACENT_TO_DESERT'),
	('REQUIRES_DISTRICT_IS_CHICHEN_ITZA_DISTRICTS',	'RequirementSetId',	'DISTRICT_IS_CHICHEN_ITZA_DISTRICTS'),
	('REQUIRES_PLOT_HAS_SHALLOW_WATER',				'TerrainType',		'TERRAIN_COAST'),
	('HD_REQUIRES_PLAYER_HAS_FAVOR', 				'PropertyName',     'HD_HasDipFavor'),
	('HD_REQUIRES_PLAYER_HAS_FAVOR', 				'PropertyMinimum',  1),
	('REQUIRES_CITY_HAS_VERTICAL_INTEGRATION', 		'GovernorPromotionType',	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION'),
	('REQUIRES_CITY_HAS_NO_VERTICAL_INTEGRATION', 		'GovernorPromotionType',	'GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION'),
	('REQUIRES_CITY_HAS_CONTRACTOR',				'GovernorPromotionType',	'GOVERNOR_PROMOTION_MERCHANT_CONTRACTOR'),
	('REQUIRES_CITY_HAS_AMBASSADOR_MESSENGER',		'GovernorPromotionType',	'GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER'),
	('REQUIRES_CITY_HAS_MULTINATIONAL_CORP',		'GovernorPromotionType',	'GOVERNOR_PROMOTION_MERCHANT_MULTINATIONAL_CORP'),
	('HD_PLOT_APPEAL_LESS_THAN_0',		'MaximumAppeal',	0),
	('HD_PLOT_APPEAL_MORE_THAN_8',		'MinimumAppeal',	8),
	('HD_REQUIRES_PLOT_ADJACENT_TO_ANY_DISTRICT',		'RequirementSetId',	'HD_PLOT_ADJACENT_TO_ANY_DISTRICT_REQUIRMENTS'),
	('REQUIRES_CITY_HAS_4_SPECIALTY_DISTRICTS',		'Amount',	4),
	('REQUIRES_CITY_HAS_6_SPECIALTY_DISTRICTS',		'Amount',	6),
	('HD_REQUIRES_TEMPLE_ARTEMIS_IMPROVEMENTS',		'RequirementSetId',		'HD_TEMPLE_ARTEMIS_IMPROVEMENTS'),
	('REQUIREMENT_UNIT_IS_SCIENTIST',		'GreatPersonClassType',		'GREAT_PERSON_CLASS_SCIENTIST'),
	-- ('HD_REQUIRES_PUBLIC_TRANSPORT_AT_RADIUS_ONE',		'RequirementSetId', 'HD_PUBLIC_TRANSPORT_AT_RADIUS_ONE_REQUIREMENTS'),
	('REQUIRES_PLOT_AT_RADIUS_3',		'MinDistance',		3),
	('REQUIRES_PLOT_AT_RADIUS_3',		'MaxDistance',		3),
	-- ('REQUIRES_PLAYER_NOT_FOUNDED_RELIGION',			'PropertyName',		'HDPlayerHasReligion'),
	-- ('REQUIRES_PLAYER_NOT_FOUNDED_RELIGION',			'PropertyMinimum',	1),
	-- ('REQUIRES_PLAYER_HAS_FOUNDED_RELIGION',		'PropertyName',		'HDPlayerHasReligion'),
	-- ('REQUIRES_PLAYER_HAS_FOUNDED_RELIGION',		'PropertyMinimum',	1),
	('REQUIRES_CITY_HAS_NOT_PALACE',		'BuildingType',		'BUILDING_PALACE'),
	('HD_REQUIRES_DISTRICT_IS_SPECIALTY_DISTRICT',						'RequirementSetId',	'DISTRICT_IS_SPECIALTY_DISTRICT_REQUIREMENTS'),
	('REQUIRES_DISTRICT_IS_WONDER_THEATER_HOLY_SITE_COMMERCIAL_HUB',	'RequirementSetId',	'MINOR_3DISTRICTS_CULTURE_REQUIREMENTS'),
	('REQUIRES_CITY_HAS_SEAPORT',				'BuildingType',	'BUILDING_SEAPORT'),
	('REQUIRES_CITY_HAS_TIER_2_HARBOR_BUILDINGS_MET','RequirementSetId',	'REQUIRES_CITY_HAS_TIER_2_HARBOR_BUILDINGS'),
	('REQUIRES_CITY_HAS_TIER_2_COMMERCIAL_HUB_BUILDINGS_MET','RequirementSetId',	'REQUIRES_CITY_HAS_TIER_2_COMMERCIAL_HUB_BUILDINGS'),
	('REQUIRES_ADJACENT_TO_LAKE_OR_LAKE','RequirementSetId',	'ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS'),
	('REQUIRES_HD_FIR_EXPEDITION_FEATURES','RequirementSetId',	'HD_FIR_EXPEDITION_FEATURES_REQUIREMENTS'),
	('REQUIRES_HD_HEROES_RETURN_WITHIN_TURNS',				'PropertyName',		'HD_HEROES_RETURN_WITHIN_TURNS'),
	('REQUIRES_HD_HEROES_RETURN_WITHIN_TURNS',				'PropertyMinimum',	1),
	('REQUIRES_HD_IMMORTAL_SEARCH_ENKIDU_DEAD',				'PropertyName',		'HD_IMMORTAL_SEARCH_ENKIDU_DEAD'),
	('REQUIRES_HD_IMMORTAL_SEARCH_ENKIDU_DEAD',				'PropertyMinimum',	1),
	('REQUIRES_HD_PLOT_HAS_GOVERNMENT_OR_DIPLO_DISTRICTS','RequirementSetId',	'HD_PLOT_HAS_GOVERNMENT_OR_DIPLO_DISTRICTS_REQUIREMENTS'),
	('REQUIRES_HD_MADRASA_FAITH_PURCHASE_CAMPUS',				'PropertyName',			'HD_MADRASA_FAITH_PURCHASE_CAMPUS'),
	('REQUIRES_HD_MADRASA_FAITH_PURCHASE_CAMPUS',				'PropertyMinimum',	20),
	('REQUIRES_HD_MADRASA_FAITH_PURCHASE_THEATER',			'PropertyName',			'HD_MADRASA_FAITH_PURCHASE_THEATER'),
	('REQUIRES_HD_MADRASA_FAITH_PURCHASE_THEATER',			'PropertyMinimum',	6),
	('REQUIRES_HD_IS_HOLY_CITY',			'PropertyName',			'HD_IS_HOLY_CITY'),
	('REQUIRES_HD_IS_HOLY_CITY',			'PropertyMinimum',	1),
	('REQUIRES_PLOT_HAS_CIV_OR_CITYSTATE_UNIQUE',			'RequirementSetId',	'PLOT_HAS_CIV_OR_CITYSTATE_UNIQUE_REQUIREMENTS'),
	('HD_REQUIRES_PLOT_ADJACENT_TO_LAND_OR_HARBOR',		'RequirementSetId',		'HD_PLOT_ADJACENT_TO_LAND_OR_HARBOR_REQUIREMENTS'),
	('REQUIRES_PLOT_HAS_ROBOT_PRODUCTION_IMPROVEMENT',		'RequirementSetId',		'PLOT_HAS_ROBOT_PRODUCTION_IMPROVEMENT_REQUIREMENTS');

-- 魅力超过8的区域
insert or ignore into RequirementSets
	(RequirementSetId,																										RequirementSetType)
select
	'HD_REQUIRES_DISTRICT_IS_' || DistrictType || '_APPEAL_MORE_THAN_8',	'REQUIREMENTSET_TEST_ALL'
from Districts;

insert or ignore into RequirementSetRequirements
	(RequirementSetId,																										RequirementId)
select
	'HD_REQUIRES_DISTRICT_IS_' || DistrictType || '_APPEAL_MORE_THAN_8',	'REQUIRES_DISTRICT_IS_' || DistrictType || '_HD'
from Districts;

insert or ignore into RequirementSetRequirements
	(RequirementSetId,																										RequirementId)
select
	'HD_REQUIRES_DISTRICT_IS_' || DistrictType || '_APPEAL_MORE_THAN_8',	'HD_PLOT_APPEAL_MORE_THAN_8'
from Districts;

insert or ignore into RequirementSets
	(RequirementSetId,												RequirementSetType)
values
	('PLOT_IS_COASTAL_LAND_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_ADJACENT_TO_FRESH_WATER_NOT_AQUEDUCT_NO_FEUDALISM',	'REQUIREMENTSET_TEST_ALL'),
	('IS_ADJACENT_TO_AQUEDUCT_NO_FEUDALISM',						'REQUIREMENTSET_TEST_ALL'),
	('HD_HAS_FEATURE_NO_MEDIEVAL_FAIRES',						'REQUIREMENTSET_TEST_ALL'),
	('HD_HAS_HILL_NO_HERALDRY',						'REQUIREMENTSET_TEST_ALL'),
	-- ('PLOT_ADJACENT_TO_MOUNTAIN_NO_APPRENTICESHIP',					'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_TUNDRA_OR_SNOW_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('IS_CAMPUS_ADJACENT_TO_MOUNTAIN_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('HD_PLAYER_HAS_NO_CIVIC_COLONIALISM_REQUIRMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('ADJACENT_TO_FOREST_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL'),
	('DL_PLOT_IS_LAKE_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL'),
	('DL_CITY_HAS_WONDER_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL'),
	('DL_PLOT_IS_WONDER_REQUIRMENTS',								'REQUIREMENTSET_TEST_ALL'),
	('DL_PLOT_IS_DISTRICT_IS_ENTERTAINMENT_REQUIRMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('DL_THIS_WONDER_IS_AT_LEAST_MIEDIVAL_REQUIRMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('DL_THIS_WONDER_IS_AT_LEAST_ANCIENT_REQUIRMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_THEATER_AND_COMMERCIAL_HUB_REQUIRMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('HD_UNIT_IN_OWNER_TERRITORY_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_IS_OR_ADJACENT_TO_COAST_NOT_LAKE',					'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_IMPROVEMENT_ADJACENT_TO_RIVER',						'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_IMPROVEMENT_IS_OR_ADJACENT_TO_COAST',						'REQUIREMENTSET_TEST_ALL'),
	('RESOUCE_ADJACENT_TO_LAKE',									'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_LAKE_OR_RESOURCE_ADJACENT_TO_LAKE',					'REQUIREMENTSET_TEST_ANY'),
	('PLAYER_NOT_HAS_GOLDEN_AGE',									'REQUIREMENTSET_TEST_ALL'),
	('NON_WONDER_NON_CITYCENTER_PLOT_IS_OR_ADJACENT_TO_COAST',		'REQUIREMENTSET_TEST_ALL'),
	('DISTRICT_IS_HOLY_SITE_ADJACENT_TO_COAST',						'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_0_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_3_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_4_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_5_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_6_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_7_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_8_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_CENTER_WITHIN_9_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_9_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_10_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_12_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('HD_OBJECT_WITHIN_7_TO_12_TILES',								'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_PASTURE_WITH_4_TILES',								'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_RESOURCE_CAMP_WITH_4_TILES',							'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_FISHING_BOATS_WITH_4_TILES',							'REQUIREMENTSET_TEST_ALL'),
	('DISTRICT_IS_HARBOR_WITHIN_4_TILES',							'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_PLANTATION_WITH_5_TILES',							'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_RESOURCE_FARM_WITH_5_TILES',							'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_RESOURCE_LUMBER_MILL_WITH_4_TILES',					'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_MINE_WITH_6_TILES',									'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_QUARRY_WITH_6_TILES',								'REQUIREMENTSET_TEST_ALL'),
	('GREAT_ZIMBABWE_REQUIREMENTS',									'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_HAS_BROADCAST_AND_POWERED',							'REQUIREMENTSET_TEST_ALL'),
	('HD_PLAYER_HAS_CIVIC_CAPITALISM',								'REQUIREMENTSET_TEST_ALL'),
	('HD_DISTRICT_IS_ENTERTAINMENT_OR_WARTERPARK',					'REQUIREMENTSET_TEST_ANY'),
	('PLOT_IS_IMPROVED_ADJACENT',									'REQUIREMENTSET_TEST_ALL'),
	('OBJECT_IS_AT_OR_ADJACENT',									'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_CENTER_ADJACENT_TO_RIVER_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('UNIT_IS_MISSIONARY_OR_APOSTLE',								'REQUIREMENTSET_TEST_ANY'),
  ('PLOT_IS_HILLS',                                               'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_HILLS_AND_ADJACENT_TO_OWNER',							'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_OR_ADJACENT_TO_DESERT',								'REQUIREMENTSET_TEST_ANY'),
	('ENCAMPMENT_ON_OR_ADJACENT_TO_DESERT',							'REQUIREMENTSET_TEST_ALL'),
	('CITY_WAS_FOUNDED',											'REQUIREMENTSET_TEST_ALL'),
	('CITY_WAS_NOT_FOUNDED',										'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_FEATURE_REQUIREMENTS',										'REQUIREMENTSET_TEST_ALL'),
	('DISTRICT_IS_CHICHEN_ITZA_DISTRICTS',							'REQUIREMENTSET_TEST_ANY'),
	('CHICHEN_ITZA_REQUIREMENTS',									'REQUIREMENTSET_TEST_ALL'),
	('CITY_ON_HOME_CONTINENT_HAS_COMMERCIAL_HUB',					'REQUIREMENTSET_TEST_ALL'),
	('CITY_ON_HOME_CONTINENT_HAS_HARBOR',							'REQUIREMENTSET_TEST_ALL'),
	('CITY_IS_CAPITAL_OR_ON_FOREIGN_CONTINENT',						'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_IMPROVED_RESOURCE_AND_ON_TUNDRA',					'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_LAND_BONUS_RESOURCE_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_ADJACENT_TO_IMPROVEMENT_FISHING_BOAT',					'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_ADJACENT_TO_IMPROVEMENT_CAMP',					'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_ADJACENT_TO_IMPROVEMENT_PASTURE',					'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_IS_HARBOR_ADJACENT_TO_IMPROVEMENT_FISHING_BOAT',					'REQUIREMENTSET_TEST_ALL'),
	('PLOT_ADJACENT_TO_TOURISM_IMPROVEMENT',					'REQUIREMENTSET_TEST_ANY'),
	('HD_ADJACENT_PLOT_WATER',					                    'REQUIREMENTSET_TEST_ALL'),
	('REQUIRE_PLOT_ADJACENT_TO_OWNER_AND_NOT_WONDER',	'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_ADJACENT_TO_ANY_DISTRICT_REQUIRMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('CITY_HAS_4_SPECIALTY_DISTRICTS_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_6_SPECIALTY_DISTRICTS_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_15_POPULATION_AND_IS_POWERED',   'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_6_SPECIALTY_DISTRICTS_AND_IS_POWERED',	'REQUIREMENTSET_TEST_ALL'),
	('HD_NOT_WONDER_WITHIN_6_TILES_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_IS_ON_DESERT_OR_DESERT_HILL_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_IMPROVED_AND_ON_ALL_FLOODPLAINS',					'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_RESOURCE_AND_ON_ALL_FLOODPLAINS',					'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_FRESH_WATER_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	('PLOT_IS_FRESH_WATER_OR_AQUEDUCT_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_MARSH_REQUIREMENTS',									'REQUIREMENTSET_TEST_ALL'),
	('HD_DISTRICT_IS_CITY_CENTER_OR_NEIGHBORHOOD',					'REQUIREMENTSET_TEST_ANY'),
	('CITY_HAS_VERTICAL_INTEGRATION_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_NO_VERTICAL_INTEGRATION_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_COMMERCIAL_OR_HARBOR',								'REQUIREMENTSET_TEST_ANY'),
	('CITY_HAS_CONTRACTOR_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_AMBASSADOR_MESSENGER_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_MULTINATIONAL_CORP_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_REYNA_4',											'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_SHALLOW_WATER_AND_ADJACENT_TO_OWNER_HD',				'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_NOT_CAPITAL_NO_GOVERNOR',				'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_CAPITAL_OR_GOVERNOR',				'REQUIREMENTSET_TEST_ANY'),
	('HD_PLOT_HAS_CAMP_FISHING_BOAT',				'REQUIREMENTSET_TEST_ANY'),
	('PLOT_ADJACENT_TO_DISTRICT_CITY_CENTER_ON_FOREIGN_CONTINENT',					'REQUIREMENTSET_TEST_ALL'),
	('HD_RIVER_IMPROVEMENT_APPEAL_LESS_THAN_0',					'REQUIREMENTSET_TEST_ALL'),
	('HD_RIVER_PLOT_APPEAL_LESS_THAN_0',								'REQUIREMENTSET_TEST_ALL'),
	('HD_ARENA_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('HD_NILOMETER_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('UNIT_IS_SCIENTIST',				'REQUIREMENTSET_TEST_ANY'),
	('HD_CHARCOAL_KILN_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('HD_PLOT_HAS_SEA_FEATURE',								'REQUIREMENTSET_TEST_ANY'),
	('HD_PLOT_ADJACENT_TO_COAST_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL'),
	('PLOT_ON_OR_ADJACENT_TO_GEOTHERMAL_FISSURE',								'REQUIREMENTSET_TEST_ANY'),
	-- ('HD_PUBLIC_TRANSPORT_AT_RADIUS_ONE_REQUIREMENTS',								'REQUIREMENTSET_TEST_ANY'),
	-- ('HD_PUBLIC_TRANSPORT_OBJECTS_REQUIREMENTS',								'REQUIREMENTSET_TEST_ANY'),
	('HD_SPORTS_MEDIA_REQUIREMENTS',								'REQUIREMENTSET_TEST_ANY'),
	('BUILDING_IS_MUSEUM', 										'REQUIREMENTSET_TEST_ANY'),
	('HD_IS_MOUNTAIN_SPECIALTY_DISTRICT_REQUIREMENTS', 										'REQUIREMENTSET_TEST_ALL'),
	('HD_CHANNEL_ADMINISTRATOR_REQUIREMENTS', 										'REQUIREMENTSET_TEST_ANY'),
	('HD_CITY_HAS_ZOO_OR_BOTANICAL_GARDEN',	'REQUIREMENTSET_TEST_ANY'),
	('PLOT_IS_WONDER_ADJACENT_TO_RIVER_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('DISTRICT_IS_HOLY_SITE_AND_ADJACENT_TO_THEATER',		'REQUIREMENTSET_TEST_ALL'),
	('HD_CLONE_RESEARCH_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('HD_HIGH_TECH_INDUSTRY_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('HD_URBAN_EXHIBITION_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	-- ('PLAYER_NOT_FOUNDED_RELIGION_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	-- ('PLAYER_HAS_FOUNDED_RELIGION_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('HD_COMMEMORATION_SCIENTIFIC_DISTRICT_REQUIREMENTS',		'REQUIREMENTSET_TEST_ANY'),
	('HD_CITY_IS_SAME_CONTINENT_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_IS_SAME_CONTINENT_NOT_CAPITAL_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('DISTRICT_IS_BRAZIL_UD',	'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_IMPROVED_AND_RAINFOREST_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_LUXURY_AND_RAINFOREST_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('HD_DIONYSIAN_CARNIVAL_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('HD_NEW_DEAL_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('MINOR_3DISTRICTS_CULTURE_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('HD_IS_COMPLETE_WONDER_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('THE_HOME_CONTINENT_NEW_REQUIREMENT',					'REQUIREMENTSET_TEST_ALL'),
	('MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HOLYSITE_ADJACENT_TO_JUNGLE_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_IS_AT_WAR_WITH_ANY_MAJOR',						'REQUIREMENTSET_TEST_ALL'),
	('PLOT_ADJACENT_TO_VOLCANO_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('HD_WRESTING_AND_MANEUVERS_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('PLOT_ADJACENT_TO_MOUNTAIN_IS_NOT_WONDER_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_SPECIALTY_DISTRICT_ADJACENT_TO_RIVER_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_DISTRICT_ADJACENT_TO_RIVER_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_WALLS_EARLY', 									'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_TSIKHE', 										'REQUIREMENTSET_TEST_ALL'),
	('HD_OVERSEAS_CITY_HAS_TIER_3_COMMERCIAL_HUB_BUILDINGS', 			'REQUIREMENTSET_TEST_ALL'),
	('HD_OVERSEAS_CITY_HAS_TIER_2_HARBOR_BUILDINGS', 					'REQUIREMENTSET_TEST_ALL'),
	('HD_SPORTS_MEET_1_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HD_SPORTS_MEET_2_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HD_NATIONALIZATION_OF_ENTERPRISES_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HD_AUTONOMY_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HD_FOSSIL_RESEARCH_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HD_ADAPTATION_TO_LOCAL_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HD_PUBLIC_SECURITY_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HD_DISTRICT_IS_NEIGHBORHOOD_OR_AQUEDUCT_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	('HD_WATERSIDE_PAVILIONS_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	('HD_DISTRICT_IS_NEIGHBORHOOD_OR_CITY_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	('HD_AIR_CONDITIONING_SYSTEM_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	('HD_PLOT_HAS_FARM_PLANTATION_LUMBER_MILL_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	('HD_UNIT_IS_RECON_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	('HD_2_TILES_WITHIN_MOUNTAIN_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	('PLAYER_HAS_FOUNDED_A_RELIGION',		'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_NOT_FOUNDED_A_RELIGION',		'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_HAS_IMPROVED_STRATEGIC_RESOURCE',		'REQUIREMENTSET_TEST_ANY'),
	('PLOT_ADJACENT_TO_WONDER_OR_NEIGHBORHOOD_REQUIREMENTS',		'REQUIREMENTSET_TEST_ANY'),
	('HD_PLOT_ADJACENT_TO_IMPROVEMENT_CAMP_OR_PASTURE',		'REQUIREMENTSET_TEST_ANY'),
	('CITY_HAS_0_SPECIALTY_DISTRICTS_HAS_NEIGHBORHOOD_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('HD_STANDARDIZED_PRODUCTION_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('HD_EFFECTIVE_ACCELERATIONISM_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('CITYCENTER_ADJACENT_TO_MOUNTAIN_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('CITYCENTER_ADJACENT_TO_COAST_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_COAST_AND_CITY_HAS_HOLYSITE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_IMPROVEMENT_OIL_WELL_OR_OFFSHORE_OIL_RIG',	'REQUIREMENTSET_TEST_ANY'),
	('HD_CITY_HAS_IMPROVED_CAMP_FISHING_BOAT_RESOURCE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('HD_AI_CITY_FOLLOWS_RELIGION_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_AI_CAPITAL_FOLLOWS_RELIGION_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_COLOSSUS_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_BOROBUDUR_CITY_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('HD_BOROBUDUR_DISTRICT_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_IS_WATER_CONSERVATION_DISTRICT',	'REQUIREMENTSET_TEST_ANY'),
	('HD_PLOT_HAS_FARM_PLANTATION_PASTURE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('KEQING_AOE_LAND_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_BREATHTAKING_CITY_FOUNDED',	'REQUIREMENTSET_TEST_ALL'),
	('HD_BREATHTAKING_CITY_NOT_FOUNDED',	'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_IS_FARM_ADJACENT_TO_RIVER_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_CAN_HAVE_SEA_UNITS_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('HD_FIR_EXPEDITION_FEATURES_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('HD_FIR_EXPEDITION_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_HEROES_RETURN_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_IMMORTAL_SEARCH_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_IS_ADJACENT_CITY_CENTER_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_GOVERNMENT_OR_DIPLO_DISTRICTS_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('HD_SUPERVISE_OFFICIALS_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_NEIGHBORHOOD_PATROL_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_DISTRICT_IS_CAMPUS_WITHIN_6_TILES_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_DISTRICT_IS_THEATER_WITHIN_6_TILES_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_MADRASA_FAITH_PURCHASE_CAMPUS_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_MADRASA_FAITH_PURCHASE_THEATER_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_IS_HOLY_CITY_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_AT_GOLDEN_AGE_BUILD_WONDER',	'REQUIREMENTSET_TEST_ALL'),
	('HD_AT_DARK_AGE_AT_WAR',	'REQUIREMENTSET_TEST_ALL'),
	('HD_HAS_HIGH_COASTAL_CITES_LOW_EXPLORATION',	'REQUIREMENTSET_TEST_ALL'),
	('HD_PILLAGER_HIGH_EXPLORATION',	'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_WONDER_DISTRICT_IS_HOLY_SITE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_IMPROVEMENT_CHARMING_APPEAL_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_IMPROVEMENT_BREATHTAKING_APPEAL_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_CIV_OR_CITYSTATE_UNIQUE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('HD_PLOT_HAS_FEATURE_AND_RESOURCE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_CHARMING_PLOT_HAS_FEATURE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_BREATHTAKING_PLOT_HAS_FEATURE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_NATURAL_WONDER_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('HD_ADJACENT_PLOT_CHARMING',					                'REQUIREMENTSET_TEST_ALL'),
	('HD_ADJACENT_PLOT_BREATHTAKING',					            'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_CHARMING_UNIQUE_IMPROVEMENT',					      'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_BREATHTAKING_UNIQUE_IMPROVEMENT',					  'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_CHARMING_WONDER',					                  'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_BREATHTAKING_WONDER',					              'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_ON_OR_ADJACENT_TO_LUXURY',					              'REQUIREMENTSET_TEST_ANY'),
	('HD_IMPROVED_PLOT_WITHIN_3_TIELS',					              'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_HAS_NEIGHBORHOOD_AND_GOVERNOR_IMPROVEMENT',					              'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_HAS_DISTRICT_ENCAMPMENT_AND_INDUSTRIAL_ZONE_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('HD_UNIT_IS_MILITARY_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('HD_ADJACENT_TO_MOUNTAIN_NO_APPRENTICESHIP',				'REQUIREMENTSET_TEST_ALL'),
	('HD_HAS_HILL_NO_METAL_CASTING',				'REQUIREMENTSET_TEST_ALL'),
	('HD_ADJACENT_TO_RIVER_NO_MACHINERY',				'REQUIREMENTSET_TEST_ALL'),
	('HD_ADJACENT_TO_LAND_OR_HARBOR_NO_COMPASS',				'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_ADJACENT_TO_LAND_OR_HARBOR_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_WATER_IMPROVEMENT_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_ROBOT_PRODUCTION_IMPROVEMENT_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_ROBOT_PRODUCTION_IMPROVEMENT_AND_ADJACENT_TO_OWNER_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('HD_CANADA_IMPROVEMENT_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
values
	('PLOT_IS_COASTAL_LAND_REQUIREMENTS',							'PLOT_IS_COASTAL_LAND'),
	('PLOT_IS_ADJACENT_TO_FRESH_WATER_NOT_AQUEDUCT_NO_FEUDALISM',	'REQUIRES_PLOT_IS_FRESH_WATER'),
	('PLOT_IS_ADJACENT_TO_FRESH_WATER_NOT_AQUEDUCT_NO_FEUDALISM',	'REQUIRES_NOT_ADJACENT_TO_AQUEDUCT'),
	('PLOT_IS_ADJACENT_TO_FRESH_WATER_NOT_AQUEDUCT_NO_FEUDALISM',	'HD_REQUIRES_PLAYER_HAS_NO_CIVIC_FEUDALISM'),
	('PLOT_IS_ADJACENT_TO_FRESH_WATER_NOT_AQUEDUCT_NO_FEUDALISM',	'HD_REQUIRES_PLAYER_HAS_TECH_IRRIGATION'),
	('IS_ADJACENT_TO_AQUEDUCT_NO_FEUDALISM',						'REQUIRES_PLOT_ADJACENT_TO_AQUEDUCT'),
	('IS_ADJACENT_TO_AQUEDUCT_NO_FEUDALISM',						'HD_REQUIRES_PLAYER_HAS_NO_CIVIC_FEUDALISM'),
	('HD_HAS_FEATURE_NO_MEDIEVAL_FAIRES',						'PLOT_HAS_ANY_FEATURE_REQUIREMENT'),
	('HD_HAS_FEATURE_NO_MEDIEVAL_FAIRES',						'HD_REQUIRES_PLAYER_HAS_NO_CIVIC_MEDIEVAL_FAIRES'),
	('HD_HAS_FEATURE_NO_MEDIEVAL_FAIRES',						'HD_REQUIRES_PLAYER_HAS_TECH_ARCHERY'),
	('HD_HAS_HILL_NO_HERALDRY',						'PLOT_IS_HILLS_REQUIREMENT'),
	('HD_HAS_HILL_NO_HERALDRY',						'HD_REQUIRES_PLAYER_HAS_NO_CIVIC_HERALDRY_HD'),
	('HD_HAS_HILL_NO_HERALDRY',						'HD_REQUIRES_PLAYER_HAS_TECH_THE_WHEEL'),
	('PLOT_IS_TUNDRA_OR_SNOW_REQUIREMENTS',		'REQUIRES_PLOT_IS_TUNDRA_OR_SNOW'),
	('IS_CAMPUS_ADJACENT_TO_MOUNTAIN_REQUIREMENTS',					'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
	('IS_CAMPUS_ADJACENT_TO_MOUNTAIN_REQUIREMENTS',					'REQUIRES_DISTRICT_IS_CAMPUS'),
	('HD_PLAYER_HAS_NO_CIVIC_COLONIALISM_REQUIRMENTS',				'HD_REQUIRES_PLAYER_HAS_NO_CIVIC_COLONIALISM'),
	('ADJACENT_TO_FOREST_REQUIREMENTS',								'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_FOREST'),
	('DL_PLOT_IS_LAKE_REQUIREMENTS',								'REQUIRES_PLOT_IS_LAKE'),
	('DL_CITY_HAS_WONDER_REQUIREMENTS',								'REQUIRES_CITY_HAS_WONDER'),
	('DL_PLOT_IS_WONDER_REQUIRMENTS',								'REQUIRES_DISTRICT_IS_DISTRICT_WONDER'),
	('DL_PLOT_IS_DISTRICT_IS_ENTERTAINMENT_REQUIRMENTS',			'REQUIRES_DISTRICT_IS_ENTERTAINMENT_COMPLEX'),
	('DL_THIS_WONDER_IS_AT_LEAST_MIEDIVAL_REQUIRMENTS',				'REQUIRES_THIS_WONDER_IS_AT_LEAST_MIEDIVAL'),
	('DL_THIS_WONDER_IS_AT_LEAST_ANCIENT_REQUIRMENTS',				'REQUIRES_THIS_WONDER_IS_AT_LEAST_ANCIENT'),
	('CITY_HAS_THEATER_AND_COMMERCIAL_HUB_REQUIRMENTS',				'REQUIRES_CITY_HAS_COMMERCIAL_HUB'),
	('CITY_HAS_THEATER_AND_COMMERCIAL_HUB_REQUIRMENTS',				'REQUIRES_CITY_HAS_THEATER_DISTRICT'),
	('HD_UNIT_IN_OWNER_TERRITORY_REQUIREMENTS',						'UNIT_IN_OWNER_TERRITORY_REQUIREMENT'),
	('PLOT_HAS_IMPROVEMENT_ADJACENT_TO_RIVER',						'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_HAS_IMPROVEMENT_ADJACENT_TO_RIVER',						'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('PLOT_HAS_IMPROVEMENT_IS_OR_ADJACENT_TO_COAST',						'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_HAS_IMPROVEMENT_IS_OR_ADJACENT_TO_COAST',						'PLOT_IS_OR_ADJACENT_TO_COAST_REQUIREMENTS'),
	('HD_PLOT_IS_OR_ADJACENT_TO_COAST_NOT_LAKE',					'HD_PLOT_ADJACENT_TO_COAST_NOT_LAKE_MET'),
	('HD_PLOT_IS_OR_ADJACENT_TO_COAST_NOT_LAKE',					'HD_PLOT_IS_COAST_NOT_LAKE_MET'),
	('RESOUCE_ADJACENT_TO_LAKE',									'REQUIRES_PLOT_ADJACENT_TO_LAKE'),
	('RESOUCE_ADJACENT_TO_LAKE',									'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('HD_PLOT_LAKE_OR_RESOURCE_ADJACENT_TO_LAKE',					'REQUIRES_RESOUCE_ADJACENT_TO_LAKE'),
	('HD_PLOT_LAKE_OR_RESOURCE_ADJACENT_TO_LAKE',					'REQUIRES_PLOT_IS_LAKE'),
	('PLAYER_NOT_HAS_GOLDEN_AGE',									'REQUIRES_PLAYER_NOT_HAS_GOLDEN_AGE'),
	('NON_WONDER_NON_CITYCENTER_PLOT_IS_OR_ADJACENT_TO_COAST',		'PLOT_IS_OR_ADJACENT_TO_COAST_REQUIREMENTS'),
	('NON_WONDER_NON_CITYCENTER_PLOT_IS_OR_ADJACENT_TO_COAST',		'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
	('NON_WONDER_NON_CITYCENTER_PLOT_IS_OR_ADJACENT_TO_COAST',		'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER'),
	('DISTRICT_IS_HOLY_SITE_ADJACENT_TO_COAST',						'PLOT_IS_OR_ADJACENT_TO_COAST_REQUIREMENTS'),
	('DISTRICT_IS_HOLY_SITE_ADJACENT_TO_COAST',						'REQUIRES_DISTRICT_IS_HOLY_SITE'),
	('HD_OBJECT_WITHIN_0_TILES',									'REQUIRES_OBJECT_WITHIN_0_TILE'),
	('OBJECT_IS_AT_OR_ADJACENT',									'REQUIRES_OBJECT_WITHIN_1_TILE'),
	('HD_OBJECT_WITHIN_3_TILES',									'REQUIRES_OBJECT_WITHIN_3_TILES'),
	('HD_OBJECT_WITHIN_4_TILES',									'REQUIRES_OBJECT_WITHIN_4_TILES'),
	('HD_OBJECT_WITHIN_5_TILES',									'REQUIRES_OBJECT_WITHIN_5_TILES'),
	('HD_OBJECT_WITHIN_6_TILES',									'REQUIRES_OBJECT_WITHIN_6_TILES'),
	('HD_OBJECT_WITHIN_7_TILES',									'REQUIRES_OBJECT_WITHIN_7_TILES'),
	('HD_OBJECT_WITHIN_8_TILES',									'REQUIRES_OBJECT_WITHIN_8_TILES'),
	('HD_CITY_CENTER_WITHIN_9_TILES',									'REQUIRES_OBJECT_WITHIN_9_TILES'),
	('HD_CITY_CENTER_WITHIN_9_TILES',									'REQUIRES_DISTRICT_IS_CITY_CENTER'),
	('HD_OBJECT_WITHIN_9_TILES',									'REQUIRES_OBJECT_WITHIN_9_TILES'),
	('HD_OBJECT_WITHIN_10_TILES',									'REQUIRES_OBJECT_WITHIN_10_TILES'),
	('HD_OBJECT_WITHIN_12_TILES',									'REQUIRES_OBJECT_WITHIN_12_TILES'),
	('HD_OBJECT_WITHIN_7_TO_12_TILES',								'REQUIRES_OBJECT_WITHIN_12_TILES'),
	('HD_OBJECT_WITHIN_7_TO_12_TILES',								'REQUIRES_OBJECT_OUTOF_7_TILES'),
	('PLOT_HAS_PASTURE_WITH_4_TILES',								'REQUIRES_OBJECT_WITHIN_4_TILES'),
	('PLOT_HAS_PASTURE_WITH_4_TILES',								'REQUIRES_PLOT_HAS_IMPROVEMENT_PASTURE'),
	('PLOT_HAS_RESOURCE_CAMP_WITH_4_TILES',							'REQUIRES_OBJECT_WITHIN_4_TILES'),
	('PLOT_HAS_RESOURCE_CAMP_WITH_4_TILES',							'REQUIRES_PLOT_HAS_IMPROVEMENT_CAMP'),
	('PLOT_HAS_RESOURCE_CAMP_WITH_4_TILES',							'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('PLOT_HAS_FISHING_BOATS_WITH_4_TILES',							'REQUIRES_OBJECT_WITHIN_4_TILES'),
	('PLOT_HAS_FISHING_BOATS_WITH_4_TILES',							'REQUIRES_PLOT_HAS_IMPROVEMENT_FISHING_BOATS'),
	('DISTRICT_IS_HARBOR_WITHIN_4_TILES',							'REQUIRES_OBJECT_WITHIN_4_TILES'),
	('DISTRICT_IS_HARBOR_WITHIN_4_TILES',							'REQUIRES_DISTRICT_IS_DISTRICT_HARBOR'),
	('PLOT_HAS_PLANTATION_WITH_5_TILES',							'REQUIRES_OBJECT_WITHIN_5_TILES'),
	('PLOT_HAS_PLANTATION_WITH_5_TILES',							'REQUIRES_PLOT_HAS_IMPROVEMENT_PLANTATION'),
	('PLOT_HAS_RESOURCE_FARM_WITH_5_TILES',							'REQUIRES_OBJECT_WITHIN_5_TILES'),
	('PLOT_HAS_RESOURCE_FARM_WITH_5_TILES',							'REQUIRES_PLOT_HAS_IMPROVEMENT_FARM'),
	('PLOT_HAS_RESOURCE_FARM_WITH_5_TILES',							'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('PLOT_HAS_RESOURCE_LUMBER_MILL_WITH_4_TILES',					'REQUIRES_OBJECT_WITHIN_4_TILES'),
	('PLOT_HAS_RESOURCE_LUMBER_MILL_WITH_4_TILES',					'REQUIRES_PLOT_HAS_IMPROVEMENT_LUMBER_MILL'),
	('PLOT_HAS_RESOURCE_LUMBER_MILL_WITH_4_TILES',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('PLOT_HAS_MINE_WITH_6_TILES',									'REQUIRES_OBJECT_WITHIN_6_TILES'),
	('PLOT_HAS_MINE_WITH_6_TILES',									'REQUIRES_PLOT_HAS_IMPROVEMENT_MINE'),
	('PLOT_HAS_QUARRY_WITH_6_TILES',								'REQUIRES_OBJECT_WITHIN_6_TILES'),
	('PLOT_HAS_QUARRY_WITH_6_TILES',								'REQUIRES_PLOT_HAS_IMPROVEMENT_QUARRY'),
	('GREAT_ZIMBABWE_REQUIREMENTS',									'REQUIRES_CITY_HAS_BUILDING_GREAT_ZIMBABWE'),
	('GREAT_ZIMBABWE_REQUIREMENTS',									'REQUIRES_PLOT_HAS_BONUS'),
	('GREAT_ZIMBABWE_REQUIREMENTS',									'REQUIRES_PLOT_HAS_NOT_COAST'),
	('GREAT_ZIMBABWE_REQUIREMENTS',									'REQUIRES_PLOT_HAS_NOT_OCEAN'),
	('HD_CITY_HAS_BROADCAST_AND_POWERED',							'REQUIRES_CITY_HAS_BUILDING_BROADCAST_CENTER'),
	('HD_CITY_HAS_BROADCAST_AND_POWERED',							'REQUIRES_CITY_IS_POWERED'),
	('HD_PLAYER_HAS_CIVIC_CAPITALISM',								'REQUIRES_PLAYER_HAS_CIVIC_CAPITALISM'),
	('HD_DISTRICT_IS_ENTERTAINMENT_OR_WARTERPARK',					'REQUIRES_DISTRICT_IS_DISTRICT_ENTERTAINMENT_COMPLEX'),
	('HD_DISTRICT_IS_ENTERTAINMENT_OR_WARTERPARK',					'REQUIRES_DISTRICT_IS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX'),
	('PLOT_IS_IMPROVED_ADJACENT',									'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_IS_IMPROVED_ADJACENT',									'ADJACENT_TO_OWNER'),
	('HD_CITY_CENTER_ADJACENT_TO_RIVER_REQUIREMENTS',				'REQUIRES_DISTRICT_IS_CITY_CENTER'),
	('HD_CITY_CENTER_ADJACENT_TO_RIVER_REQUIREMENTS',				'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('UNIT_IS_MISSIONARY_OR_APOSTLE',								'REQUIRES_UNIT_IS_UNIT_MISSIONARY'),
	('UNIT_IS_MISSIONARY_OR_APOSTLE',								'REQUIRES_UNIT_IS_UNIT_APOSTLE'),
  ('PLOT_IS_HILLS',                                               'REQUIRES_PLOT_IS_HILLS'),
	('PLOT_IS_HILLS_AND_ADJACENT_TO_OWNER',							'REQUIRES_PLOT_IS_HILLS'),
	('PLOT_IS_HILLS_AND_ADJACENT_TO_OWNER',							'ADJACENT_TO_OWNER'),
	('PLOT_IS_OR_ADJACENT_TO_DESERT',								'HD_REQUIRES_PLOT_ON_OR_ADJACENT_TO_TERRAIN_DESERT'),
	('PLOT_IS_OR_ADJACENT_TO_DESERT',								'HD_REQUIRES_PLOT_ON_OR_ADJACENT_TO_TERRAIN_DESERT_HILLS'),
  ('ENCAMPMENT_ON_OR_ADJACENT_TO_DESERT',                         'REQUIRES_PLOT_IS_OR_ADJACENT_TO_DESERT'),
  ('ENCAMPMENT_ON_OR_ADJACENT_TO_DESERT',                         'REQUIRES_DISTRICT_IS_DISTRICT_ENCAMPMENT'),
	('CITY_WAS_FOUNDED',											'REQUIRES_CITY_WAS_FOUNDED'),
	('CITY_WAS_NOT_FOUNDED',										'REQUIRES_CITY_WAS_NOT_FOUNDED'),
	('HD_PLOT_HAS_FEATURE_REQUIREMENTS',										'PLOT_HAS_ANY_FEATURE_REQUIREMENT'),
	('DISTRICT_IS_CHICHEN_ITZA_DISTRICTS',							'REQUIRES_DISTRICT_IS_DISTRICT_HOLY_SITE'),
	('DISTRICT_IS_CHICHEN_ITZA_DISTRICTS',							'REQUIRES_DISTRICT_IS_DISTRICT_CAMPUS'),
	('DISTRICT_IS_CHICHEN_ITZA_DISTRICTS',							'REQUIRES_DISTRICT_IS_DISTRICT_THEATER'),
	('DISTRICT_IS_CHICHEN_ITZA_DISTRICTS',							'REQUIRES_DISTRICT_IS_DISTRICT_ENTERTAINMENT_COMPLEX'),
	('CHICHEN_ITZA_REQUIREMENTS',									'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_JUNGLE'),
	('CHICHEN_ITZA_REQUIREMENTS',									'REQUIRES_DISTRICT_IS_CHICHEN_ITZA_DISTRICTS'),
	('CITY_ON_HOME_CONTINENT_HAS_COMMERCIAL_HUB',					'REQUIRES_PLOT_IS_OWNER_CAPITAL_CONTINENT'),
	('CITY_ON_HOME_CONTINENT_HAS_COMMERCIAL_HUB',					'REQUIRES_CITY_HAS_DISTRICT_COMMERCIAL_HUB'),
	('CITY_ON_HOME_CONTINENT_HAS_HARBOR',							'REQUIRES_PLOT_IS_OWNER_CAPITAL_CONTINENT'),
	('CITY_ON_HOME_CONTINENT_HAS_HARBOR',							'REQUIRES_CITY_HAS_DISTRICT_HARBOR'),
	('CITY_IS_CAPITAL_OR_ON_FOREIGN_CONTINENT',						'REQUIRES_CITY_IS_NOT_OWNER_CAPITAL_CONTINENT'),
	('CITY_IS_CAPITAL_OR_ON_FOREIGN_CONTINENT',						'REQUIRES_CITY_HAS_BUILDING_PALACE'),	
	('PLOT_HAS_IMPROVED_RESOURCE_AND_ON_TUNDRA',					'REQUIRES_TUNDRA_OR_TUNDRA_HILL'),
	('PLOT_HAS_IMPROVED_RESOURCE_AND_ON_TUNDRA',					'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_HAS_IMPROVED_RESOURCE_AND_ON_TUNDRA',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('HD_PLOT_HAS_LAND_BONUS_RESOURCE_REQUIREMENTS',					'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_LAND_BONUS_RESOURCE_REQUIREMENTS',					'REQUIRES_PLOT_HAS_NOT_COAST'),
	('HD_PLOT_HAS_LAND_BONUS_RESOURCE_REQUIREMENTS',					'REQUIRES_PLOT_HAS_NOT_OCEAN'),
	('HD_PLOT_ADJACENT_TO_IMPROVEMENT_FISHING_BOAT',					'REQUIRES_PLOT_ADJACENT_TO_IMPROVEMENT_FISHING_BOATS'),
	('HD_PLOT_ADJACENT_TO_IMPROVEMENT_CAMP',					'REQUIRES_PLOT_ADJACENT_TO_IMPROVEMENT_CAMP'),
	('HD_PLOT_ADJACENT_TO_IMPROVEMENT_PASTURE',					'REQUIRES_PLOT_ADJACENT_TO_IMPROVEMENT_PASTURE'),
	('HD_PLOT_IS_HARBOR_ADJACENT_TO_IMPROVEMENT_FISHING_BOAT',					'REQUIRES_PLOT_ADJACENT_TO_IMPROVEMENT_FISHING_BOATS'),
	('HD_PLOT_IS_HARBOR_ADJACENT_TO_IMPROVEMENT_FISHING_BOAT',					'REQUIRES_DISTRICT_IS_HARBOR'),
	('HD_ADJACENT_PLOT_WATER',					                    'ADJACENT_TO_OWNER'),
	('HD_ADJACENT_PLOT_WATER',					                    'REQUIRES_PLOT_HAS_COAST'),
	('REQUIRE_PLOT_ADJACENT_TO_OWNER_AND_NOT_WONDER',	'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
	('REQUIRE_PLOT_ADJACENT_TO_OWNER_AND_NOT_WONDER',	'ADJACENT_TO_OWNER'),
	('CITY_HAS_4_SPECIALTY_DISTRICTS_REQUIREMENTS',	'REQUIRES_CITY_HAS_4_SPECIALTY_DISTRICTS'),
	('CITY_HAS_6_SPECIALTY_DISTRICTS_REQUIREMENTS',	'REQUIRES_CITY_HAS_6_SPECIALTY_DISTRICTS'),
	('CITY_HAS_6_SPECIALTY_DISTRICTS_AND_IS_POWERED',	'REQUIRES_CITY_HAS_6_SPECIALTY_DISTRICTS'),
	('CITY_HAS_6_SPECIALTY_DISTRICTS_AND_IS_POWERED',	'REQUIRES_CITY_IS_POWERED'),
	('CITY_HAS_15_POPULATION_AND_IS_POWERED',   'REQUIRES_CITY_IS_POWERED'),
	('CITY_HAS_15_POPULATION_AND_IS_POWERED',   'REQUIRES_CITY_HAS_15_POPULATION'),
	('HD_NOT_WONDER_WITHIN_6_TILES_REQUIREMENTS',	'REQUIRES_OBJECT_WITHIN_6_TILES'),
	('HD_NOT_WONDER_WITHIN_6_TILES_REQUIREMENTS',	'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
	('HD_IS_ON_DESERT_OR_DESERT_HILL_REQUIREMENTS',	'HD_REQUIRES_PLOT_HAS_TERRAIN_DESERT'),
	('HD_IS_ON_DESERT_OR_DESERT_HILL_REQUIREMENTS',	'HD_REQUIRES_PLOT_HAS_TERRAIN_DESERT_HILLS'),
	('PLOT_HAS_IMPROVED_AND_ON_ALL_FLOODPLAINS',					'REQUIRES_FLOODPLAINS_OR_PLAINSFLOODPLAINS_OR_GRASSFLOODPLAINS_REQUIREMENTS'),
	('PLOT_HAS_IMPROVED_AND_ON_ALL_FLOODPLAINS',					'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_HAS_RESOURCE_AND_ON_ALL_FLOODPLAINS',					'REQUIRES_FLOODPLAINS_OR_PLAINSFLOODPLAINS_OR_GRASSFLOODPLAINS_REQUIREMENTS'),
	('PLOT_HAS_RESOURCE_AND_ON_ALL_FLOODPLAINS',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('PLOT_IS_FRESH_WATER_REQUIREMENTS',							'REQUIRES_PLOT_IS_FRESH_WATER'),
	('PLOT_IS_FRESH_WATER_REQUIREMENTS',							'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('PLOT_IS_FRESH_WATER_REQUIREMENTS',							'REQUIRES_PLOT_ADJACENT_TO_LAKE'),
	('PLOT_IS_FRESH_WATER_OR_AQUEDUCT_REQUIREMENTS',							'REQUIRES_PLOT_IS_FRESH_WATER'),
	('PLOT_IS_FRESH_WATER_OR_AQUEDUCT_REQUIREMENTS',							'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('PLOT_IS_FRESH_WATER_OR_AQUEDUCT_REQUIREMENTS',							'REQUIRES_PLOT_ADJACENT_TO_LAKE'),
	('PLOT_IS_FRESH_WATER_OR_AQUEDUCT_REQUIREMENTS',							'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_AQUEDUCT'),
	('PLOT_HAS_MARSH_REQUIREMENTS',									'REQUIRES_PLOT_HAS_MARSH'),
	('HD_DISTRICT_IS_CITY_CENTER_OR_NEIGHBORHOOD',					'REQUIRES_DISTRICT_IS_DISTRICT_CITY_CENTER'),
	('HD_DISTRICT_IS_CITY_CENTER_OR_NEIGHBORHOOD',					'REQUIRES_DISTRICT_IS_DISTRICT_NEIGHBORHOOD'),
	('CITY_HAS_VERTICAL_INTEGRATION_REQUIREMENTS',					'REQUIRES_CITY_HAS_VERTICAL_INTEGRATION'),
	('CITY_HAS_NO_VERTICAL_INTEGRATION_REQUIREMENTS',					'REQUIRES_CITY_HAS_NO_VERTICAL_INTEGRATION'),
	('CITY_HAS_COMMERCIAL_OR_HARBOR',								'REQUIRES_CITY_HAS_DISTRICT_COMMERCIAL_HUB'),
	('CITY_HAS_COMMERCIAL_OR_HARBOR',								'REQUIRES_CITY_HAS_DISTRICT_HARBOR'),
	('CITY_HAS_CONTRACTOR_REQUIREMENTS',							'REQUIRES_CITY_HAS_CONTRACTOR'),
	('CITY_HAS_AMBASSADOR_MESSENGER_REQUIREMENTS',					'REQUIRES_CITY_HAS_AMBASSADOR_MESSENGER'),	
	('CITY_HAS_MULTINATIONAL_CORP_REQUIREMENTS',					'REQUIRES_CITY_HAS_MULTINATIONAL_CORP'),
	('CITY_HAS_REYNA_4',											'REQUIRES_CITY_HAS_CONTRACTOR'),
	('CITY_HAS_REYNA_4',											'REQUIRES_CITY_HAS_MULTINATIONAL_CORP'),
	('PLOT_HAS_SHALLOW_WATER_AND_ADJACENT_TO_OWNER_HD',				'REQUIRES_PLOT_HAS_SHALLOW_WATER'),
	('PLOT_HAS_SHALLOW_WATER_AND_ADJACENT_TO_OWNER_HD',				'ADJACENT_TO_OWNER'),
	('HD_CITY_NOT_CAPITAL_NO_GOVERNOR',				'REQUIRES_NOT_CITY_HAS_GOV'),
	('HD_CITY_NOT_CAPITAL_NO_GOVERNOR',				'REQUIRES_CITY_NON_CAPITAL'),
	('HD_CITY_CAPITAL_OR_GOVERNOR',				'REQUIRES_CITY_HAS_GOVERNOR'),
	('HD_CITY_CAPITAL_OR_GOVERNOR',				'REQUIRES_CITY_HAS_BUILDING_PALACE'),
	('HD_PLOT_HAS_CAMP_FISHING_BOAT',				'REQUIRES_PLOT_HAS_IMPROVEMENT_CAMP'),
	('HD_PLOT_HAS_CAMP_FISHING_BOAT',				'REQUIRES_PLOT_HAS_IMPROVEMENT_FISHING_BOATS'),
	('PLOT_ADJACENT_TO_DISTRICT_CITY_CENTER_ON_FOREIGN_CONTINENT',					'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_CITY_CENTER'),
	('PLOT_ADJACENT_TO_DISTRICT_CITY_CENTER_ON_FOREIGN_CONTINENT',					'REQUIRES_PLOT_IS_NOT_OWNER_CAPITAL_CONTINENT'),
	('HD_RIVER_IMPROVEMENT_APPEAL_LESS_THAN_0',					'HD_PLOT_APPEAL_LESS_THAN_0'),
	('HD_RIVER_IMPROVEMENT_APPEAL_LESS_THAN_0',					'REQUIRES_PLOT_IS_IMPROVED'),
	('HD_RIVER_IMPROVEMENT_APPEAL_LESS_THAN_0',					'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('HD_RIVER_PLOT_APPEAL_LESS_THAN_0',								'HD_PLOT_APPEAL_LESS_THAN_0'),
	('HD_RIVER_PLOT_APPEAL_LESS_THAN_0',								'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('UNIT_IS_SCIENTIST',								'REQUIREMENT_UNIT_IS_SCIENTIST'),
	('HD_PLOT_ADJACENT_TO_COAST_REQUIREMENTS',				'HD_REQUIRES_PLOT_ADJACENT_TO_COAST'),
	('PLOT_ON_OR_ADJACENT_TO_GEOTHERMAL_FISSURE',				'HD_REQUIRES_PLOT_HAS_FEATURE_GEOTHERMAL_FISSURE'),
	('PLOT_ON_OR_ADJACENT_TO_GEOTHERMAL_FISSURE',				'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_GEOTHERMAL_FISSURE'),
	('HD_SPORTS_MEDIA_REQUIREMENTS',								'REQUIRES_CITY_HAS_BUILDING_STADIUM'),
	('HD_SPORTS_MEDIA_REQUIREMENTS',								'REQUIRES_CITY_HAS_BUILDING_AQUATICS_CENTER'),
	('BUILDING_IS_MUSEUM', 										'REQUIRES_CITY_HAS_BUILDING_MUSEUM_ART'),
	('BUILDING_IS_MUSEUM', 										'REQUIRES_CITY_HAS_BUILDING_MUSEUM_ARTIFACT'),
	('HD_IS_MOUNTAIN_SPECIALTY_DISTRICT_REQUIREMENTS', 										'HD_REQUIRES_DISTRICT_IS_SPECIALTY_DISTRICT'),
	('HD_IS_MOUNTAIN_SPECIALTY_DISTRICT_REQUIREMENTS', 										'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
	('HD_CHANNEL_ADMINISTRATOR_REQUIREMENTS', 										'REQUIRES_DISTRICT_IS_DISTRICT_AQUEDUCT_HD'),
	('HD_CHANNEL_ADMINISTRATOR_REQUIREMENTS', 										'REQUIRES_DISTRICT_IS_DISTRICT_CANAL_HD'),
	('HD_CHANNEL_ADMINISTRATOR_REQUIREMENTS', 										'REQUIRES_DISTRICT_IS_DISTRICT_DAM_HD'),
	('HD_CITY_HAS_ZOO_OR_BOTANICAL_GARDEN',	'REQUIRES_CITY_HAS_BUILDING_ZOO'),
	('PLOT_IS_WONDER_ADJACENT_TO_RIVER_REQUIREMENTS',		'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('PLOT_IS_WONDER_ADJACENT_TO_RIVER_REQUIREMENTS',		'REQUIRES_PLOT_HAS_COMPLETE_WONDER'),
	('DISTRICT_IS_HOLY_SITE_AND_ADJACENT_TO_THEATER',		'REQUIRES_DISTRICT_IS_DISTRICT_HOLY_SITE_HD'),
	('DISTRICT_IS_HOLY_SITE_AND_ADJACENT_TO_THEATER',		'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_THEATER_RAW'),
	('HD_HIGH_TECH_INDUSTRY_REQUIREMENTS',		'REQUIRES_CAMPUS_HAS_HIGH_ADJACENCY'),
	('HD_HIGH_TECH_INDUSTRY_REQUIREMENTS',		'REQUIRES_INDUSTRIAL_ZONE_HAS_HIGH_ADJACENCY'),
	('HD_HIGH_TECH_INDUSTRY_REQUIREMENTS',		'REQUIRES_CITY_HAS_DISTRICT_INDUSTRIAL_ZONE_TIER_3_BUILDING'),
	('HD_URBAN_EXHIBITION_REQUIREMENTS',				'REQUIRES_CITY_HAS_DISTRICT_ENTERTAINMENT_COMPLEX_TIER_2_BUILDING'),
	('HD_URBAN_EXHIBITION_REQUIREMENTS',				'REQUIRES_CITY_HAS_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_TIER_2_BUILDING'),
	-- ('PLAYER_NOT_FOUNDED_RELIGION_REQUIREMENTS',		'REQUIRES_PLAYER_NOT_FOUNDED_RELIGION'),
	-- ('PLAYER_HAS_FOUNDED_RELIGION_REQUIREMENTS',		'REQUIRES_PLAYER_HAS_FOUNDED_RELIGION'),
	('HD_COMMEMORATION_SCIENTIFIC_DISTRICT_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_CAMPUS'),
	('HD_COMMEMORATION_SCIENTIFIC_DISTRICT_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_HARBOR'),
	('HD_COMMEMORATION_SCIENTIFIC_DISTRICT_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_AQUEDUCT'),
	('HD_CITY_IS_SAME_CONTINENT_REQUIREMENTS',	'HD_CITY_IS_SAME_CONTINENT_REQUIREMENTS'),
	('HD_CITY_IS_SAME_CONTINENT_NOT_CAPITAL_REQUIREMENTS',	'HD_CITY_IS_SAME_CONTINENT_REQUIREMENTS'),
	('HD_CITY_IS_SAME_CONTINENT_NOT_CAPITAL_REQUIREMENTS',	'REQUIRES_CITY_HAS_NOT_PALACE'),
	('DISTRICT_IS_BRAZIL_UD',	'REQUIRES_DISTRICT_IS_DISTRICT_STREET_CARNIVAL'),
	('DISTRICT_IS_BRAZIL_UD',	'REQUIRES_DISTRICT_IS_DISTRICT_WATER_STREET_CARNIVAL'),
	('PLOT_HAS_IMPROVED_AND_RAINFOREST_REQUIREMENTS',		'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_HAS_IMPROVED_AND_RAINFOREST_REQUIREMENTS',		'REQUIRES_PLOT_HAS_JUNGLE'),
	('PLOT_HAS_LUXURY_AND_RAINFOREST_REQUIREMENTS',		'REQUIRES_PLOT_HAS_LUXURY'),
	('PLOT_HAS_LUXURY_AND_RAINFOREST_REQUIREMENTS',		'REQUIRES_PLOT_HAS_JUNGLE'),
	('HD_DIONYSIAN_CARNIVAL_REQUIREMENTS',		'REQUIRES_CITY_HAS_DISTRICT_THEATER'),
	('HD_DIONYSIAN_CARNIVAL_REQUIREMENTS',		'REQUIRES_CITY_HAS_4_POPULATION'),
	('HD_NEW_DEAL_REQUIREMENTS',		'REQUIRES_NOT_CITY_HAS_GOV'),
	('HD_NEW_DEAL_REQUIREMENTS',		'REQUIRES_CITY_DOES_NOT_HAVE_DISTRICT_GOVERNMENT'),
	('THE_HOME_CONTINENT_NEW_REQUIREMENT',					'REQUIRES_PLOT_IS_OWNER_CAPITAL_CONTINENT'),
	('MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE_REQUIREMENTS',	'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('MINOR_CIV_AYUTTHAYA_DISTRICTS_CULTURE_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_WONDER_THEATER_HOLY_SITE_COMMERCIAL_HUB'),
	('MINOR_3DISTRICTS_CULTURE_REQUIREMENTS',				'REQUIRES_PLOT_HAS_COMPLETE_WONDER'),
	('MINOR_3DISTRICTS_CULTURE_REQUIREMENTS',				'REQUIRES_DISTRICT_IS_DISTRICT_THEATER'),
	('HD_IS_COMPLETE_WONDER_REQUIREMENTS',				'REQUIRES_DISTRICT_IS_DISTRICT_WONDER'),
	('HD_IS_COMPLETE_WONDER_REQUIREMENTS',				'REQUIRES_PLOT_HAS_COMPLETE_WONDER'),
	('HOLYSITE_ADJACENT_TO_JUNGLE_REQUIREMENTS',			'REQUIRES_PLOT_ADJACENT_TO_JUNGLE'),
	('HOLYSITE_ADJACENT_TO_JUNGLE_REQUIREMENTS',			'REQUIRES_PLOT_HAS_HOLY_SITE'),
	('PLAYER_IS_AT_WAR_WITH_ANY_MAJOR',						'REQUIRES_PLAYER_AT_WAR_WITH_ANY_MAJOR'),
	('PLOT_ADJACENT_TO_VOLCANO_REQUIREMENTS',				'REQUIRES_PLOT_ADJACENT_VOLCANO'),
	('PLOT_ADJACENT_TO_VOLCANO_REQUIREMENTS',				'REQUIRES_PLOT_ADJACENT_EYJAFJALLAJOKULL'),
	('PLOT_ADJACENT_TO_VOLCANO_REQUIREMENTS',				'REQUIRES_PLOT_ADJACENT_VESUVIUS'),
	('PLOT_ADJACENT_TO_VOLCANO_REQUIREMENTS',				'REQUIRES_PLOT_ADJACENT_KILIMANJARO'),
	('HD_WRESTING_AND_MANEUVERS_REQUIREMENTS',							'PLOT_HAS_BUILDING_ARENA'),
	('HD_WRESTING_AND_MANEUVERS_REQUIREMENTS',							'REQUIRES_DISTRICT_IS_ENTERTAINMENT_COMPLEX'),
	('PLOT_ADJACENT_TO_MOUNTAIN_IS_NOT_WONDER_REQUIREMENTS',		'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
	('PLOT_ADJACENT_TO_MOUNTAIN_IS_NOT_WONDER_REQUIREMENTS',		'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
	('PLOT_IS_SPECIALTY_DISTRICT_ADJACENT_TO_RIVER_REQUIREMENTS',	'HD_REQUIRES_DISTRICT_IS_SPECIALTY_DISTRICT'),
	('PLOT_IS_SPECIALTY_DISTRICT_ADJACENT_TO_RIVER_REQUIREMENTS',	'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('PLOT_IS_DISTRICT_ADJACENT_TO_RIVER_REQUIREMENTS',				'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
	('PLOT_IS_DISTRICT_ADJACENT_TO_RIVER_REQUIREMENTS',				'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('CITY_HAS_WALLS_EARLY', 									'REQUIRES_CITY_HAS_BUILDING_WALLS_EARLY'),
	('CITY_HAS_TSIKHE', 										'REQUIRES_CITY_HAS_BUILDING_TSIKHE'),
	('HD_OVERSEAS_CITY_HAS_TIER_3_COMMERCIAL_HUB_BUILDINGS', 	'REQUIRES_CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_3_BUILDING'),
	('HD_OVERSEAS_CITY_HAS_TIER_3_COMMERCIAL_HUB_BUILDINGS', 	'REQUIRES_CITY_IS_NOT_OWNER_CAPITAL_CONTINENT'),
	('HD_OVERSEAS_CITY_HAS_TIER_2_HARBOR_BUILDINGS', 			'REQUIRES_CITY_HAS_DISTRICT_HARBOR_TIER_2_BUILDING'),
	('HD_OVERSEAS_CITY_HAS_TIER_2_HARBOR_BUILDINGS', 			'REQUIRES_CITY_IS_NOT_OWNER_CAPITAL_CONTINENT'),
	('HD_SPORTS_MEET_1_REQUIREMENTS',							'PLOT_HAS_BUILDING_STADIUM'),
	('HD_SPORTS_MEET_1_REQUIREMENTS',							'REQUIRES_DISTRICT_IS_ENTERTAINMENT_COMPLEX'),
	('HD_SPORTS_MEET_2_REQUIREMENTS',							'PLOT_HAS_BUILDING_AQUATICS_CENTER'),
	('HD_SPORTS_MEET_2_REQUIREMENTS',							'REQUIRES_DISTRICT_IS_WATER_ENTERTAINMENT_COMPLEX'),
	('HD_NATIONALIZATION_OF_ENTERPRISES_REQUIREMENTS',							'REQUIRES_DISTRICT_IS_DISTRICT_COMMERCIAL_HUB_HD'),
	('HD_NATIONALIZATION_OF_ENTERPRISES_REQUIREMENTS',							'REQUIRES_CITY_HAS_DISTRICT_COMMERCIAL_HUB_TIER_3_BUILDING'),
	('HD_AUTONOMY_REQUIREMENTS',							'REQUIRES_NOT_CITY_HAS_GOV'),
	('HD_AUTONOMY_REQUIREMENTS',							'REQUIRES_CITY_HAS_DISTRICT_NEIGHBORHOOD_TIER_1_BUILDING'),
	('HD_FOSSIL_RESEARCH_REQUIREMENTS',							'REQUIRES_DISTRICT_IS_DISTRICT_CAMPUS_HD'),
	('HD_FOSSIL_RESEARCH_REQUIREMENTS',							'REQUIRES_PLOT_ADJACENT_TO_IMPROVEMENT_QUARRY'),
	('HD_PUBLIC_SECURITY_REQUIREMENTS',							'REQUIRES_CITY_HAS_GARRISON_UNIT'),
	('HD_PUBLIC_SECURITY_REQUIREMENTS',							'REQUIRES_CITY_HAS_DISTRICT_NEIGHBORHOOD'),
	('HD_DISTRICT_IS_NEIGHBORHOOD_OR_AQUEDUCT_REQUIREMENTS',							'REQUIRES_DISTRICT_IS_DISTRICT_NEIGHBORHOOD_HD'),
	('HD_DISTRICT_IS_NEIGHBORHOOD_OR_AQUEDUCT_REQUIREMENTS',							'REQUIRES_DISTRICT_IS_DISTRICT_AQUEDUCT_HD'),
	('HD_WATERSIDE_PAVILIONS_REQUIREMENTS',							'HD_REQUIRES_PLOT_HAS_FEATURE_GEOTHERMAL_FISSURE'),
	('HD_WATERSIDE_PAVILIONS_REQUIREMENTS',							'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_OASIS'),
	('HD_DISTRICT_IS_NEIGHBORHOOD_OR_CITY_REQUIREMENTS',							'REQUIRES_DISTRICT_IS_DISTRICT_NEIGHBORHOOD_HD'),
	('HD_DISTRICT_IS_NEIGHBORHOOD_OR_CITY_REQUIREMENTS',							'REQUIRES_DISTRICT_IS_DISTRICT_CITY_CENTER_HD'),
	('HD_AIR_CONDITIONING_SYSTEM_REQUIREMENTS',							'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_JUNGLE'),
	('HD_AIR_CONDITIONING_SYSTEM_REQUIREMENTS',							'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_OASIS'),
	('HD_AIR_CONDITIONING_SYSTEM_REQUIREMENTS',							'HD_REQUIRES_PLOT_HAS_TERRAIN_DESERT'),
	('HD_AIR_CONDITIONING_SYSTEM_REQUIREMENTS',							'HD_REQUIRES_PLOT_HAS_TERRAIN_DESERT_HILLS'),
	('HD_AIR_CONDITIONING_SYSTEM_REQUIREMENTS',							'HD_REQUIRES_PLOT_HAS_TERRAIN_SNOW'),
	('HD_AIR_CONDITIONING_SYSTEM_REQUIREMENTS',							'HD_REQUIRES_PLOT_HAS_TERRAIN_SNOW_HILLS'),
	('HD_AIR_CONDITIONING_SYSTEM_REQUIREMENTS',							'HD_REQUIRES_PLOT_HAS_TERRAIN_TUNDRA'),
	('HD_AIR_CONDITIONING_SYSTEM_REQUIREMENTS',							'HD_REQUIRES_PLOT_HAS_TERRAIN_TUNDRA_HILLS'),
	('HD_PLOT_HAS_FARM_PLANTATION_LUMBER_MILL_REQUIREMENTS',							'REQUIRES_PLOT_HAS_IMPROVEMENT_FARM'),
	('HD_PLOT_HAS_FARM_PLANTATION_LUMBER_MILL_REQUIREMENTS',							'REQUIRES_PLOT_HAS_IMPROVEMENT_LUMBER_MILL'),
	('HD_PLOT_HAS_FARM_PLANTATION_LUMBER_MILL_REQUIREMENTS',							'REQUIRES_PLOT_HAS_IMPROVEMENT_PLANTATION'),
	('PLAYER_HAS_FOUNDED_A_RELIGION',		'REQUIRES_PLAYER_HAS_FOUNDED_A_RELIGION'),
	('PLAYER_HAS_NOT_FOUNDED_A_RELIGION',		'REQUIRES_PLAYER_HAS_NOT_FOUNDED_A_RELIGION'),
	('PLOT_ADJACENT_TO_WONDER_OR_NEIGHBORHOOD_REQUIREMENTS',		'REQUIRES_PLOT_ADJACENT_TO_WONDER'),
	('PLOT_ADJACENT_TO_WONDER_OR_NEIGHBORHOOD_REQUIREMENTS',		'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_NEIGHBORHOOD'),
	('HD_PLOT_ADJACENT_TO_IMPROVEMENT_CAMP_OR_PASTURE',		'REQUIRES_PLOT_ADJACENT_TO_IMPROVEMENT_CAMP'),
	('HD_PLOT_ADJACENT_TO_IMPROVEMENT_CAMP_OR_PASTURE',		'REQUIRES_PLOT_ADJACENT_TO_IMPROVEMENT_PASTURE'),
	('CITY_HAS_0_SPECIALTY_DISTRICTS_HAS_NEIGHBORHOOD_REQUIREMENTS',		'REQUIRES_CITY_HAS_0_SPECIALTY_DISTRICTS'),
	('CITY_HAS_0_SPECIALTY_DISTRICTS_HAS_NEIGHBORHOOD_REQUIREMENTS',		'REQUIRES_CITY_HAS_DISTRICT_NEIGHBORHOOD'),
	('HD_STANDARDIZED_PRODUCTION_REQUIREMENTS',		'REQUIRES_DISTRICT_INDUSTRIAL_ZONE_HAS_6_ADJACENCY'),
	('HD_STANDARDIZED_PRODUCTION_REQUIREMENTS',		'REQUIRES_DISTRICT_ENCAMPMENT_HAS_6_ADJACENCY'),
	('HD_EFFECTIVE_ACCELERATIONISM_REQUIREMENTS',		'REQUIRES_CITY_HAS_DISTRICT_CAMPUS_TIER_4_BUILDING'),
	('HD_EFFECTIVE_ACCELERATIONISM_REQUIREMENTS',		'REQUIRES_CITY_HAS_DISTRICT_AERODROME'),
	('CITYCENTER_ADJACENT_TO_MOUNTAIN_REQUIREMENTS', 		'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
	('CITYCENTER_ADJACENT_TO_MOUNTAIN_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_CITY_CENTER'),
	('CITYCENTER_ADJACENT_TO_COAST_REQUIREMENTS',			'HD_REQUIRES_PLOT_ADJACENT_TO_COAST'),
	('CITYCENTER_ADJACENT_TO_COAST_REQUIREMENTS',			'REQUIRES_DISTRICT_IS_CITY_CENTER'),
	('PLOT_HAS_COAST_AND_CITY_HAS_HOLYSITE_REQUIREMENTS',	'REQUIRES_PLOT_HAS_COAST'),
	('PLOT_HAS_COAST_AND_CITY_HAS_HOLYSITE_REQUIREMENTS',	'REQUIRES_CITY_HAS_HOLY_SITE'),
	('PLOT_HAS_IMPROVEMENT_OIL_WELL_OR_OFFSHORE_OIL_RIG',	'REQUIRES_PLOT_HAS_IMPROVEMENT_OFFSHORE_OIL_RIG'),
	('PLOT_HAS_IMPROVEMENT_OIL_WELL_OR_OFFSHORE_OIL_RIG',	'REQUIRES_PLOT_HAS_IMPROVEMENT_OIL_WELL'),
	('HD_AI_CAPITAL_FOLLOWS_RELIGION_REQUIREMENTS',	'REQUIRES_CITY_FOLLOWS_RELIGION'),
	('HD_AI_CAPITAL_FOLLOWS_RELIGION_REQUIREMENTS',	'REQUIRES_CITY_HAS_PALACE'),
	('HD_AI_CAPITAL_FOLLOWS_RELIGION_REQUIREMENTS',	'REQUIRES_PLAYER_IS_AI'),
	('HD_AI_CITY_FOLLOWS_RELIGION_REQUIREMENTS',	'REQUIRES_CITY_FOLLOWS_RELIGION'),
	('HD_AI_CITY_FOLLOWS_RELIGION_REQUIREMENTS',	'REQUIRES_PLAYER_IS_AI'),
	('HD_COLOSSUS_REQUIREMENTS',	'REQUIRES_CITY_HAS_BUILDING_COLOSSUS'),
	('HD_COLOSSUS_REQUIREMENTS',	'REQUIRES_PLOT_HAS_IMPROVEMENT_FISHING_BOATS'),
	('HD_BOROBUDUR_CITY_REQUIREMENTS',	'REQUIRES_CITY_HAS_FEATURE_VOLCANIC_SOIL'),
	('HD_BOROBUDUR_CITY_REQUIREMENTS',	'REQUIRES_CITY_HAS_FEATURE_VOLCANO'),
	('HD_BOROBUDUR_DISTRICT_REQUIREMENTS',	'HD_REQUIRES_PLOT_ON_OR_ADJACENT_TO_FEATURE_VOLCANIC_SOIL'),
	('HD_BOROBUDUR_DISTRICT_REQUIREMENTS',	'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
	('HD_IS_WATER_CONSERVATION_DISTRICT',	'REQUIRES_DISTRICT_IS_DISTRICT_AQUEDUCT'),
	('HD_IS_WATER_CONSERVATION_DISTRICT',	'REQUIRES_DISTRICT_IS_DISTRICT_CANAL'),
	('HD_IS_WATER_CONSERVATION_DISTRICT',	'REQUIRES_DISTRICT_IS_DISTRICT_DAM'),
	('HD_PLOT_HAS_FARM_PLANTATION_PASTURE_REQUIREMENTS',	'REQUIRES_PLOT_HAS_IMPROVEMENT_FARM'),
	('HD_PLOT_HAS_FARM_PLANTATION_PASTURE_REQUIREMENTS',	'REQUIRES_PLOT_HAS_IMPROVEMENT_PASTURE'),
	('HD_PLOT_HAS_FARM_PLANTATION_PASTURE_REQUIREMENTS',	'REQUIRES_PLOT_HAS_IMPROVEMENT_PLANTATION'),
	('KEQING_AOE_LAND_REQUIREMENTS',	'AOE_REQUIRES_LAND_DOMAIN'),
	('KEQING_AOE_LAND_REQUIREMENTS',	'AOE_REQUIRES_OWNER_ADJACENCY'),
	('HD_BREATHTAKING_CITY_FOUNDED',	'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
	('HD_BREATHTAKING_CITY_FOUNDED',	'REQUIRES_CITY_WAS_FOUNDED'),
	('HD_BREATHTAKING_CITY_NOT_FOUNDED',	'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
	('HD_BREATHTAKING_CITY_NOT_FOUNDED',	'REQUIRES_CITY_WAS_NOT_FOUNDED'),
	('HD_PLOT_IS_FARM_ADJACENT_TO_RIVER_REQUIREMENTS',	'REQUIRES_PLOT_HAS_IMPROVEMENT_FARM'),
	('HD_PLOT_IS_FARM_ADJACENT_TO_RIVER_REQUIREMENTS',	'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('HD_CITY_CAN_HAVE_SEA_UNITS_REQUIREMENTS',	'REQUIRES_PLOT_IS_ADJACENT_TO_COAST'),
	('HD_CITY_CAN_HAVE_SEA_UNITS_REQUIREMENTS',	'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_CANAL_RAW'),
	('HD_CITY_CAN_HAVE_SEA_UNITS_REQUIREMENTS',	'REQUIRES_PLOT_ADJACENT_TO_BUILDING_PANAMA_CANAL'),
	('HD_CITY_CAN_HAVE_SEA_UNITS_REQUIREMENTS',	'REQUIRES_CITY_HAS_DISTRICT_HARBOR'),
	('HD_FIR_EXPEDITION_FEATURES_REQUIREMENTS',	'HD_REQUIRES_PLOT_HAS_FEATURE_FOREST'),
	('HD_FIR_EXPEDITION_FEATURES_REQUIREMENTS',	'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_FOREST'),
	('HD_FIR_EXPEDITION_FEATURES_REQUIREMENTS',	'HD_REQUIRES_PLOT_HAS_FEATURE_JUNGLE'),
	('HD_FIR_EXPEDITION_FEATURES_REQUIREMENTS',	'HD_REQUIRES_PLOT_ADJACENT_TO_FEATURE_JUNGLE'),
	('HD_FIR_EXPEDITION_REQUIREMENTS',	'REQUIRES_OBJECT_WITHIN_3_TILES'),
	('HD_FIR_EXPEDITION_REQUIREMENTS',	'REQUIRES_HD_FIR_EXPEDITION_FEATURES'),
	('HD_HEROES_RETURN_REQUIREMENTS',	'REQUIRES_HD_HEROES_RETURN_WITHIN_TURNS'),
	('HD_IMMORTAL_SEARCH_REQUIREMENTS',	'REQUIRES_HD_IMMORTAL_SEARCH_ENKIDU_DEAD'),
	('HD_IS_ADJACENT_CITY_CENTER_REQUIREMENTS',	'ADJACENT_TO_OWNER'),
	('HD_IS_ADJACENT_CITY_CENTER_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_DISTRICT_CITY_CENTER_RAW'),
	('HD_PLOT_HAS_GOVERNMENT_OR_DIPLO_DISTRICTS_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_DISTRICT_GOVERNMENT'),
	('HD_SUPERVISE_OFFICIALS_REQUIREMENTS',	'REQUIRES_HD_PLOT_HAS_GOVERNMENT_OR_DIPLO_DISTRICTS'),
	('HD_SUPERVISE_OFFICIALS_REQUIREMENTS',	'REQUIRES_OBJECT_WITHIN_0_TILE'),
	('HD_NEIGHBORHOOD_PATROL_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_DISTRICT_NEIGHBORHOOD'),
	('HD_NEIGHBORHOOD_PATROL_REQUIREMENTS',	'REQUIRES_OBJECT_WITHIN_0_TILE'),
	('HD_DISTRICT_IS_CAMPUS_WITHIN_6_TILES_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_DISTRICT_CAMPUS'),
	('HD_DISTRICT_IS_CAMPUS_WITHIN_6_TILES_REQUIREMENTS',		'REQUIRES_OBJECT_WITHIN_6_TILES'),
	('HD_DISTRICT_IS_THEATER_WITHIN_6_TILES_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_DISTRICT_THEATER'),
	('HD_DISTRICT_IS_THEATER_WITHIN_6_TILES_REQUIREMENTS',	'REQUIRES_OBJECT_WITHIN_6_TILES'),
	('HD_MADRASA_FAITH_PURCHASE_CAMPUS_REQUIREMENTS',				'REQUIRES_HD_MADRASA_FAITH_PURCHASE_CAMPUS'),
	('HD_MADRASA_FAITH_PURCHASE_THEATER_REQUIREMENTS',			'REQUIRES_HD_MADRASA_FAITH_PURCHASE_THEATER'),
	('HD_IS_HOLY_CITY_REQUIREMENTS',			'REQUIRES_HD_IS_HOLY_CITY'),
	('HD_AT_GOLDEN_AGE_BUILD_WONDER',			'REQUIRES_MAJOR_CIV_OPPONENT'),
	('HD_AT_GOLDEN_AGE_BUILD_WONDER',			'REQUIRES_PLAYERS_HAVE_MET'),
	('HD_AT_GOLDEN_AGE_BUILD_WONDER',			'REQUIRES_MET_10_TURNS_AGO'),
	('HD_AT_GOLDEN_AGE_BUILD_WONDER',			'REQUIRES_PLAYER_HAS_GOLDEN_AGE'),
	('HD_AT_GOLDEN_AGE_BUILD_WONDER',			'REQUIRES_LEADS_WONDERS'),
	('HD_AT_DARK_AGE_AT_WAR',							'REQUIRES_MAJOR_CIV_OPPONENT'),
	('HD_AT_DARK_AGE_AT_WAR',							'REQUIRES_PLAYERS_HAVE_MET'),
	('HD_AT_DARK_AGE_AT_WAR',							'REQUIRES_MET_10_TURNS_AGO'),
	('HD_AT_DARK_AGE_AT_WAR',							'REQUIRES_PLAYER_HAS_DARK_AGE'),
	('HD_AT_DARK_AGE_AT_WAR',							'REQUIRES_WARMONGER_TRIGGER'),
	('HD_HAS_HIGH_COASTAL_CITES_LOW_EXPLORATION',							'REQUIRES_MAJOR_CIV_OPPONENT'),
	('HD_HAS_HIGH_COASTAL_CITES_LOW_EXPLORATION',							'REQUIRES_PLAYERS_HAVE_MET'),
	('HD_HAS_HIGH_COASTAL_CITES_LOW_EXPLORATION',							'REQUIRES_MET_10_TURNS_AGO'),
	('HD_HAS_HIGH_COASTAL_CITES_LOW_EXPLORATION',							'REQUIRES_HAS_HIGH_COASTAL_CITIES'),
	('HD_HAS_HIGH_COASTAL_CITES_LOW_EXPLORATION',							'REQUIRES_HAS_LOW_EXPLORATION'),
	('HD_PILLAGER_HIGH_EXPLORATION',							'REQUIRES_MAJOR_CIV_OPPONENT'),
	('HD_PILLAGER_HIGH_EXPLORATION',							'REQUIRES_PLAYERS_HAVE_MET'),
	('HD_PILLAGER_HIGH_EXPLORATION',							'REQUIRES_MET_10_TURNS_AGO'),
	('HD_PILLAGER_HIGH_EXPLORATION',							'REQUIRES_HAS_HIGH_PILLAGE'),
	('HD_PILLAGER_HIGH_EXPLORATION',							'REQUIRES_HAS_HIGH_EXPLORATION'),
	('CITY_HAS_WONDER_DISTRICT_IS_HOLY_SITE_REQUIREMENTS',								'REQUIRES_CITY_HAS_WONDER'),
	('CITY_HAS_WONDER_DISTRICT_IS_HOLY_SITE_REQUIREMENTS',								'REQUIRES_DISTRICT_IS_HOLY_SITE'),
	('HD_IMPROVEMENT_CHARMING_APPEAL_REQUIREMENTS',								'REQUIRES_PLOT_CHARMING_APPEAL'),
	('HD_IMPROVEMENT_CHARMING_APPEAL_REQUIREMENTS',								'REQUIRES_PLOT_IS_IMPROVED'),
	('HD_IMPROVEMENT_BREATHTAKING_APPEAL_REQUIREMENTS',						'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
	('HD_IMPROVEMENT_BREATHTAKING_APPEAL_REQUIREMENTS',						'REQUIRES_PLOT_IS_IMPROVED'),
	('HD_PLOT_HAS_FEATURE_AND_RESOURCE_REQUIREMENTS',	'PLOT_HAS_ANY_FEATURE_REQUIREMENT'),
	('HD_PLOT_HAS_FEATURE_AND_RESOURCE_REQUIREMENTS',	'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE'),
	('HD_CHARMING_PLOT_HAS_FEATURE_REQUIREMENTS',	'PLOT_HAS_ANY_FEATURE_REQUIREMENT'),
	('HD_CHARMING_PLOT_HAS_FEATURE_REQUIREMENTS',	'REQUIRES_PLOT_CHARMING_APPEAL'),
	('HD_BREATHTAKING_PLOT_HAS_FEATURE_REQUIREMENTS',	'PLOT_HAS_ANY_FEATURE_REQUIREMENT'),
	('HD_BREATHTAKING_PLOT_HAS_FEATURE_REQUIREMENTS',	'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
	('HD_ADJACENT_PLOT_CHARMING',					                'ADJACENT_TO_OWNER'),
	('HD_ADJACENT_PLOT_CHARMING',					                'REQUIRES_PLOT_CHARMING_APPEAL'),
	('HD_ADJACENT_PLOT_BREATHTAKING',					            'ADJACENT_TO_OWNER'),
	('HD_ADJACENT_PLOT_BREATHTAKING',					            'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
	('HD_PLOT_CHARMING_UNIQUE_IMPROVEMENT',		            'REQUIRES_PLOT_CHARMING_APPEAL'),
	('HD_PLOT_CHARMING_UNIQUE_IMPROVEMENT',		            'REQUIRES_PLOT_HAS_CIV_OR_CITYSTATE_UNIQUE'),
	('HD_PLOT_BREATHTAKING_UNIQUE_IMPROVEMENT',		        'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
	('HD_PLOT_BREATHTAKING_UNIQUE_IMPROVEMENT',		        'REQUIRES_PLOT_HAS_CIV_OR_CITYSTATE_UNIQUE'),
	('HD_PLOT_CHARMING_WONDER',					                  'REQUIRES_PLOT_CHARMING_APPEAL'),
	('HD_PLOT_CHARMING_WONDER',					                  'REQUIRES_DISTRICT_IS_DISTRICT_WONDER'),
	('HD_PLOT_CHARMING_WONDER',					                  'REQUIRES_PLOT_HAS_COMPLETE_WONDER'),
	('HD_PLOT_BREATHTAKING_WONDER',					              'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
	('HD_PLOT_BREATHTAKING_WONDER',					              'REQUIRES_DISTRICT_IS_DISTRICT_WONDER'),
	('HD_PLOT_BREATHTAKING_WONDER',					              'REQUIRES_PLOT_HAS_COMPLETE_WONDER'),
	('HD_PLOT_ON_OR_ADJACENT_TO_LUXURY',					              'REQUIRES_PLOT_ADJACENT_TO_LUXURY'),
	('HD_PLOT_ON_OR_ADJACENT_TO_LUXURY',					              'REQUIRES_PLOT_HAS_LUXURY'),
	('HD_IMPROVED_PLOT_WITHIN_3_TIELS',					              'REQUIRES_PLOT_IS_IMPROVED'),
	('HD_IMPROVED_PLOT_WITHIN_3_TIELS',					              'REQUIRES_OBJECT_WITHIN_3_TILES'),
	('HD_CITY_HAS_NEIGHBORHOOD_AND_GOVERNOR_IMPROVEMENT',					              'REQUIRES_CITY_HAS_GOVERNOR'),
	('HD_CITY_HAS_NEIGHBORHOOD_AND_GOVERNOR_IMPROVEMENT',					              'REQUIRES_CITY_HAS_DISTRICT_NEIGHBORHOOD'),
	('HD_CITY_HAS_DISTRICT_ENCAMPMENT_AND_INDUSTRIAL_ZONE_REQUIREMENTS',				'REQUIRES_CITY_HAS_DISTRICT_ENCAMPMENT'),
	('HD_CITY_HAS_DISTRICT_ENCAMPMENT_AND_INDUSTRIAL_ZONE_REQUIREMENTS',				'REQUIRES_CITY_HAS_DISTRICT_INDUSTRIAL_ZONE'),
	('HD_ADJACENT_TO_MOUNTAIN_NO_APPRENTICESHIP',				'HD_REQUIRES_PLAYER_HAS_NO_TECH_APPRENTICESHIP'),
	('HD_ADJACENT_TO_MOUNTAIN_NO_APPRENTICESHIP',				'HD_REQUIRES_PLAYER_HAS_TECH_BRONZE_WORKING'),
	('HD_ADJACENT_TO_MOUNTAIN_NO_APPRENTICESHIP',				'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
	('HD_HAS_HILL_NO_METAL_CASTING',										'HD_REQUIRES_PLAYER_HAS_NO_TECH_METAL_CASTING'),
	('HD_HAS_HILL_NO_METAL_CASTING',										'HD_REQUIRES_PLAYER_HAS_TECH_MASONRY'),
	('HD_HAS_HILL_NO_METAL_CASTING',										'PLOT_IS_HILLS_REQUIREMENT'),
	('HD_ADJACENT_TO_RIVER_NO_MACHINERY',								'HD_REQUIRES_PLAYER_HAS_NO_TECH_MACHINERY'),
	('HD_ADJACENT_TO_RIVER_NO_MACHINERY',								'HD_REQUIRES_PLAYER_HAS_TECH_THE_WHEEL'),
	('HD_ADJACENT_TO_RIVER_NO_MACHINERY',								'REQUIRES_PLOT_ADJACENT_TO_RIVER'),
	('HD_ADJACENT_TO_LAND_OR_HARBOR_NO_COMPASS',								'HD_REQUIRES_PLAYER_HAS_NO_TECH_COMPASS_HD'),
	('HD_ADJACENT_TO_LAND_OR_HARBOR_NO_COMPASS',								'HD_REQUIRES_PLOT_ADJACENT_TO_LAND_OR_HARBOR'),
	('HD_PLOT_ADJACENT_TO_LAND_OR_HARBOR_REQUIREMENTS',					'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_HARBOR_RAW'),
	('PLOT_HAS_WATER_IMPROVEMENT_REQUIREMENTS',					'HD_REQUIRES_PLOT_HAS_TERRAIN_COAST'),
	('PLOT_HAS_WATER_IMPROVEMENT_REQUIREMENTS',					'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_HAS_ROBOT_PRODUCTION_IMPROVEMENT_AND_ADJACENT_TO_OWNER_REQUIREMENTS',			'ADJACENT_TO_OWNER'),
	('PLOT_HAS_ROBOT_PRODUCTION_IMPROVEMENT_AND_ADJACENT_TO_OWNER_REQUIREMENTS',			'REQUIRES_PLOT_HAS_ROBOT_PRODUCTION_IMPROVEMENT'),
	('HD_CANADA_IMPROVEMENT_REQUIREMENTS',			'REQUIRES_PLOT_IS_TUNDRA_OR_SNOW'),
	('HD_CANADA_IMPROVEMENT_REQUIREMENTS',			'REQUIRES_PLOT_HAS_IMPROVEMENT_CLASSIFICATION_BASIC');

-- 机器人生产
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_HAS_ROBOT_PRODUCTION_IMPROVEMENT_REQUIREMENTS', 'REQUIRES_PLOT_HAS_' || ImprovementType from HD_Improvement_Classification
	where ImprovementClassificationType in ('IMPROVEMENT_CLASSIFICATION_AGRICULTURAL_PRODUCTION', 'IMPROVEMENT_CLASSIFICATION_INDUSTRIAL_PRODUCTION');

-- 相邻陆地或港口
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_ADJACENT_TO_LAND_OR_HARBOR_REQUIREMENTS', 'HD_REQUIRES_PLOT_ADJACENT_TO_' || TerrainType
from Terrains where Water = 0 and Impassable = 0;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_PLOT_ADJACENT_TO_LAND_OR_HARBOR_REQUIREMENTS', 'REQUIRES_PLOT_ADJACENT_TO_' || CivUniqueDistrictType || '_RAW'
from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_HARBOR';

-- 文明&城邦特色改良
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLOT_HAS_CIV_OR_CITYSTATE_UNIQUE_REQUIREMENTS', 'REQUIRES_PLOT_HAS_' || ImprovementType from HD_Improvement_Classification
	where ImprovementClassificationType in ('IMPROVEMENT_CLASSIFICATION_UNIQUE', 'IMPROVEMENT_CLASSIFICATION_CITYSTATE');

-- 
insert or ignore into RequirementSetRequirements
	(RequirementSetId,					RequirementId)
select
	'HD_NEW_DEAL_REQUIREMENTS',	'REQUIRES_CITY_DOES_NOT_HAVE_DISTRICT_DIPLOMATIC_QUARTER'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,					RequirementId)
select
	'HD_PLOT_HAS_GOVERNMENT_OR_DIPLO_DISTRICTS_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_DISTRICT_DIPLOMATIC_QUARTER'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,								RequirementId)
select
	'HD_UNIT_IS_RECON_REQUIREMENTS',	'REQUIRES_UNIT_IS_' || UnitType
from Units where PromotionClass = 'PROMOTION_CLASS_RECON';

-- 圣城有圣地X级建筑
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType) select distinct
	'HD_IS_HOLY_CITY_HAS_HOLYSITE_TIER_' || Tier || '_BUILDING_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) select distinct
	'HD_IS_HOLY_CITY_HAS_HOLYSITE_TIER_' || Tier || '_BUILDING_REQUIREMENTS', 'REQUIRES_HD_IS_HOLY_CITY'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) select distinct
	'HD_IS_HOLY_CITY_HAS_HOLYSITE_TIER_' || Tier || '_BUILDING_REQUIREMENTS', 'REQUIRES_CITY_HAS_DISTRICT_HOLY_SITE_TIER_' || Tier || '_BUILDING'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_HOLY_SITE';

-- 2格内有山脉
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_2_TILES_WITHIN_' || TerrainType || '_HD', 'REQUIREMENT_PLOT_ADJACENT_TERRAIN_TYPE_MATCHES'
	from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_2_TILES_WITHIN_' || TerrainType || '_HD', 'TerrainType', TerrainType
	from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN';
insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_2_TILES_WITHIN_' || TerrainType || '_HD', 'MaxRange', 2
	from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_2_TILES_WITHIN_MOUNTAIN_REQUIREMENTS',	'REQUIRES_2_TILES_WITHIN_' || TerrainType || '_HD'
	from TerrainClass_Terrains where TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN';

-- 公共交通
-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,																	RequirementId)
-- select
-- 	'HD_PUBLIC_TRANSPORT_AT_RADIUS_ONE_REQUIREMENTS',		'REQUIRES_PLOT_ADJACENT_TO_' || Type
-- from Types where Type in (
-- 	'BUILDING_HD_BUS_STOP', 'BUILDING_JNR_TRANSIT_HUB', 'IMPROVEMENT_LEU_STATION', 'IMPROVEMENT_MOUNTAIN_TUNNEL', 'IMPROVEMENT_MOUNTAIN_ROAD', 'DISTRICT_AERODROME'
-- );

-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,														RequirementId)
-- select
-- 	'HD_PUBLIC_TRANSPORT_OBJECTS_REQUIREMENTS',		RequirementId
-- from Requirements where RequirementId in (
-- 	'PLOT_HAS_BUILDING_HD_BUS_STOP',
-- 	'PLOT_HAS_BUILDING_JNR_TRANSIT_HUB',
-- 	'REQUIRES_PLOT_HAS_IMPROVEMENT_LEU_STATION',
-- 	'REQUIRES_PLOT_HAS_IMPROVEMENT_MOUNTAIN_TUNNEL',
-- 	'REQUIRES_PLOT_HAS_IMPROVEMENT_MOUNTAIN_ROAD',
-- 	'REQUIRES_DISTRICT_IS_DISTRICT_AERODROME_HD'
-- );

-- insert or ignore into RequirementSets
-- 	(RequirementSetId,																						RequirementSetType)
-- select
-- 	'HD_IS' || DistrictType || '_PUBLIC_TRANSPORT_AT_RADIUS_ONE',	'REQUIREMENTSET_TEST_ALL'
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,																						RequirementId)
-- select
-- 	'HD_IS' || DistrictType || '_PUBLIC_TRANSPORT_AT_RADIUS_ONE',	'HD_REQUIRES_PUBLIC_TRANSPORT_AT_RADIUS_ONE'
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,																						RequirementId)
-- select
-- 	'HD_IS' || DistrictType || '_PUBLIC_TRANSPORT_AT_RADIUS_ONE',	'REQUIRES_DISTRICT_IS_' || DistrictType || '_HD'
-- from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_DISTRICT_IS_' || DistrictType || '_AT_RADIUS_THREE', 'REQUIREMENTSET_TEST_ALL' from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;
insert or ignore into RequirementSetRequirements(RequirementSetId, RequirementId)
	select 'HD_DISTRICT_IS_' || DistrictType || '_AT_RADIUS_THREE',	'REQUIRES_DISTRICT_IS_' || DistrictType from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_DISTRICT_IS_' || DistrictType || '_AT_RADIUS_THREE', 'REQUIRES_PLOT_AT_RADIUS_3' from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 工业区 区域拓展
insert or ignore into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
select
	'HD_CHARCOAL_KILN_REQUIREMENTS',	'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources
where ImprovementType in ('IMPROVEMENT_FARM', 'IMPROVEMENT_LUMBER_MILL', 'IMPROVEMENT_PLANTATION') or ResourceType = 'RESOURCE_COAL';

-- 城市有改良的战略资源
insert or ignore into RequirementSetRequirements
	(RequirementSetId,													RequirementId)
select
	'HD_CITY_HAS_IMPROVED_STRATEGIC_RESOURCE',	'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
--------------------

insert or ignore into RequirementSetRequirements
	(RequirementSetId,										RequirementId)
select
	'HD_PLOT_HAS_SEA_FEATURE',								'HD_REQUIRES_PLOT_HAS_' || i.FeatureType
from Feature_ValidTerrains i, Features j
where i.FeatureType = j.FeatureType and (i.TerrainType = 'TERRAIN_COAST' and j.Impassable = 0 and j.NaturalWonder = 0);

insert or ignore into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
select
	'HD_NILOMETER_REQUIREMENTS',	'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType
from Features
where FeatureType in ('FEATURE_FLOODPLAINS', 'FEATURE_OASIS', 'FEATURE_MARSH', 'FEATURE_FLOODPLAINS_GRASSLAND', 'FEATURE_FLOODPLAINS_PLAINS', 'FEATURE_HD_SWAMP');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,								RequirementId)
select
	'HD_ARENA_REQUIREMENTS',					'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources
where ImprovementType = 'IMPROVEMENT_PASTURE' or ImprovementType = 'IMPROVEMENT_CAMP';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,																											RequirementId)
select
	'HD_CITY_HAS_IMPROVED_CAMP_FISHING_BOAT_RESOURCE_REQUIREMENTS',					'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources
where ImprovementType = 'IMPROVEMENT_FISHING_BOATS' or ImprovementType = 'IMPROVEMENT_CAMP';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,								RequirementId)
select
	'HD_CLONE_RESEARCH_REQUIREMENTS',	'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources
where ImprovementType = 'IMPROVEMENT_PASTURE' or ImprovementType = 'IMPROVEMENT_CAMP';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,															RequirementId)
select
	'HD_PLOT_ADJACENT_TO_ANY_DISTRICT_REQUIRMENTS',		'REQUIRES_PLOT_ADJACENT_TO_' || DistrictType || '_RAW'
from Districts where DistrictType != 'DISTRICT_WONDER';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
	'PLOT_ADJACENT_TO_TOURISM_IMPROVEMENT',		'REQUIRES_PLOT_ADJACENT_TO_' || ImprovementType
from Improvement_Tourism where ImprovementType != 'IMPROVEMENT_SKI_RESORT';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
select
	'PLOT_IS_FRESH_WATER_REQUIREMENTS',		'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType
from Features where AddsFreshWater = 1;

insert or ignore into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
select
	'PLOT_IS_FRESH_WATER_OR_AQUEDUCT_REQUIREMENTS',		'HD_REQUIRES_PLOT_ADJACENT_TO_' || FeatureType
from Features where AddsFreshWater = 1;

insert or ignore into RequirementSets
	(RequirementSetId,									RequirementSetType)
values
	('DISTRICT_IS_SPECIALTY_DISTRICT_REQUIREMENTS',		'REQUIREMENTSET_TEST_ANY');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,									RequirementId)
select 
	'DISTRICT_IS_SPECIALTY_DISTRICT_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_' || DistrictType
from Districts where RequiresPopulation = 1;

-- New city center buildings
insert or ignore into RequirementSets 
	(RequirementSetId, 						RequirementSetType) 
values
	('HD_PLOT_HAS_FARM_RESOURCE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
	('OFFICIAL_RUN_HANDCRAFT_REQUIREMENT',	'REQUIREMENTSET_TEST_ANY'),
	('PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN','REQUIREMENTSET_TEST_ANY');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
select
	'HD_PLOT_HAS_FARM_RESOURCE_REQUIREMENTS',	'REQUIRES_' || ResourceType || '_IN_PLOT'
from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_FARM';

insert or ignore into RequirementSetRequirements
	(RequirementSetId,						RequirementId)
select
	'OFFICIAL_RUN_HANDCRAFT_REQUIREMENT',	'HD_REQUIRES_CITY_HAS_IMPROVED_' || r.ResourceType
from Resources r, Improvement_ValidResources i
where r.ResourceType = i.ResourceType and (i.ImprovementType = 'IMPROVEMENT_MINE' or i.ImprovementType = 'IMPROVEMENT_QUARRY')
	and (r.ResourceClassType = 'RESOURCECLASS_LUXURY' or r.ResourceClassType = 'RESOURCECLASS_BONUS');

insert or ignore into RequirementSetRequirements 
    (RequirementSetId,						RequirementId) 
values
	('PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN',					'REQUIRES_PLOT_IS_HILLS'),
	('PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN',					'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN');

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType) select
	'REQUIRES_DISTRICT_IS_' || DistrictType || '_WITHIN_4_TILES_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) select
	'REQUIRES_DISTRICT_IS_' || DistrictType || '_WITHIN_4_TILES_REQUIREMENTS', 'REQUIRES_DISTRICT_IS_' || DistrictType
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId) select
	'REQUIRES_DISTRICT_IS_' || DistrictType || '_WITHIN_4_TILES_REQUIREMENTS', 'REQUIRES_OBJECT_WITHIN_4_TILES'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- RequirementSets
insert or ignore into RequirementSets
	(RequirementSetId,																			RequirementSetType)
values
	('DISTRICT_IS_HOLY_SITE_WITHIN_SIX_TILES_REQUIREMENTS',										'REQUIREMENTSET_TEST_ALL'),
	('DISTRICT_IS_THEATER_AND_PLAYER_HAS_CIVIC_SOCIAL_SCIENCE_HD',								'REQUIREMENTSET_TEST_ALL'),
	('UNIT_WITHIN_NINE_TILES_REQUIREMENTS', 													'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_CIVIC_SOCIAL_SCIENCE_HD',														'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_CIVIC_URBANIZATION',															'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_NOT_HAS_CIVIC_URBANIZATION',														'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_TECH_CELESTIAL_NAVIGATION',													'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_TECH_BUTTRESS',																'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_CONSTRUCTION_REQUIREMENTS',													'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_PRINTING_REQUIREMENTS',														'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_ASTRONOMY_REQUIREMENTS',														'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_SCIENTIFIC_THEORY_REQUIREMENTS',												'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_CHEMISTRY_REQUIREMENTS',														'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_PAPER_MAKING_REQUIREMENTS',													'REQUIREMENTSET_TEST_ALL'),
	('ATTACKING_DISTRICTS_REQUIREMENTS',														'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_FOREST_REQUIREMENT',																'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_JUNGLE_REQUIREMENT',																'REQUIREMENTSET_TEST_ALL'),
	('HD_DISTRICT_IS_CITY_CENTER',																'REQUIREMENTSET_TEST_ALL'),
	('HD_PLAYER_HAS_TECH_WRITING',																'REQUIREMENTSET_TEST_ALL'),
	('HD_PLAYER_HAS_CIVIC_FOREIGN_TRADE',														'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_ENOUGH_HORSES_REQUIREMENTS',													'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_HAS_ENOUGH_IRON_REQUIREMENTS',														'REQUIREMENTSET_TEST_ALL'),
	('HD_PLAYER_HAS_HORSES_AND_IRON_REQUIREMENTS',												'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_IMPROVED_LUXURY_RESOURCE',														'REQUIREMENTSET_TEST_ANY'),
	('UNIT_IS_CIVILIAN_CLASS',																	'REQUIREMENTSET_TEST_ANY'),
	('NOT_WONDER_IS_OR_ADJACENT_TO_COAST',														'REQUIREMENTSET_TEST_ALL'),
	('WONDER_IS_OR_ADJACENT_TO_COAST',															'REQUIREMENTSET_TEST_ALL'),
    ('HD_DISTRICTS_IS_NOT_WONDERS_OR_CITY_CENTER_REQUIREMENTS',									'REQUIREMENTSET_TEST_ALL'),
	('NON_CITYCENTER_PLOT_IS_OR_ADJACENT_TO_COAST',												'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_SHALLOW_WATER_AND_STEAM_POWER_REQUIREMENTS',										'REQUIREMENTSET_TEST_ALL'),
	('PLOT_ADJACENT_TO_MOUNTAIN_IS_IMPROVED_REQUIREMENTS',										'REQUIREMENTSET_TEST_ALL'),
	('PLOT_ADJACENT_TO_MOUNTAIN_REQUIREMENTS',													'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_RESOURCE_REQUIREMENTS',														'REQUIREMENTSET_TEST_ANY'),
	('HD_TEMPLE_ARTEMIS_IMPROVEMENTS',														'REQUIREMENTSET_TEST_ANY'),
	('HD_TEMPLE_ARTEMIS_REQUIREMENTS',														'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,																		RequirementId)
values
	('DISTRICT_IS_HOLY_SITE_WITHIN_SIX_TILES_REQUIREMENTS', 								'REQUIRES_PLOT_HAS_HOLY_SITE'),
	('DISTRICT_IS_HOLY_SITE_WITHIN_SIX_TILES_REQUIREMENTS', 								'REQUIRES_OBJECT_WITHIN_6_TILES'),
	('DISTRICT_IS_THEATER_AND_PLAYER_HAS_CIVIC_SOCIAL_SCIENCE_HD',							'REQUIRES_DISTRICT_IS_THEATER'),
	('DISTRICT_IS_THEATER_AND_PLAYER_HAS_CIVIC_SOCIAL_SCIENCE_HD',							'REQUIRES_PLAYER_HAS_CIVIC_SOCIAL_SCIENCE_HD'),
	('UNIT_WITHIN_NINE_TILES_REQUIREMENTS', 												'REQUIRES_WITHIN_NINE_TILES_FROM_OWNER'),
	('PLAYER_HAS_CIVIC_SOCIAL_SCIENCE_HD',													'REQUIRES_PLAYER_HAS_CIVIC_SOCIAL_SCIENCE_HD'),
	('PLAYER_HAS_CIVIC_URBANIZATION',														'REQUIRES_PLAYER_HAS_CIVIC_URBANIZATION'),
	('PLAYER_NOT_HAS_CIVIC_URBANIZATION',													'REQUIRES_PLAYER_NOT_HAS_CIVIC_URBANIZATION'),
	('PLAYER_HAS_TECH_CELESTIAL_NAVIGATION',												'HD_REQUIRES_PLAYER_HAS_TECH_CELESTIAL_NAVIGATION'),
	('PLAYER_HAS_TECH_BUTTRESS',															'HD_REQUIRES_PLAYER_HAS_TECH_BUTTRESS'),
	('PLAYER_HAS_CONSTRUCTION_REQUIREMENTS',												'HD_REQUIRES_PLAYER_HAS_TECH_CONSTRUCTION'),
	('PLAYER_HAS_PRINTING_REQUIREMENTS',													'HD_REQUIRES_PLAYER_HAS_TECH_PRINTING'),
	('PLAYER_HAS_ASTRONOMY_REQUIREMENTS',													'HD_REQUIRES_PLAYER_HAS_TECH_ASTRONOMY'),
	('PLAYER_HAS_SCIENTIFIC_THEORY_REQUIREMENTS',											'HD_REQUIRES_PLAYER_HAS_TECH_SCIENTIFIC_THEORY'),
	('PLAYER_HAS_CHEMISTRY_REQUIREMENTS',													'HD_REQUIRES_PLAYER_HAS_TECH_CHEMISTRY'),
	('PLAYER_HAS_PAPER_MAKING_REQUIREMENTS',												'HD_REQUIRES_PLAYER_HAS_TECH_PAPER_MAKING_HD'),
	('ATTACKING_DISTRICTS_REQUIREMENTS',													'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('ATTACKING_DISTRICTS_REQUIREMENTS',													'OPPONENT_IS_DISTRICT'),
	('PLOT_HAS_FOREST_REQUIREMENT',															'PLOT_IS_FOREST_REQUIREMENT'),
	('PLOT_HAS_JUNGLE_REQUIREMENT',															'PLOT_IS_JUNGLE_REQUIREMENT'),
	('HD_DISTRICT_IS_CITY_CENTER',															'REQUIRES_DISTRICT_IS_DISTRICT_CITY_CENTER'),
	('HD_PLAYER_HAS_TECH_WRITING',															'HD_REQUIRES_PLAYER_HAS_TECH_WRITING'),
	('HD_PLAYER_HAS_CIVIC_FOREIGN_TRADE',													'REQUIRES_PLAYER_HAS_CIVIC_FOREIGN_TRADE'),
	('PLAYER_HAS_ENOUGH_HORSES_REQUIREMENTS',												'REQUIRES_PLAYER_HAS_ENOUGH_HORSES'),
	('PLAYER_HAS_ENOUGH_IRON_REQUIREMENTS',													'REQUIRES_PLAYER_HAS_ENOUGH_IRON'),
	('HD_PLAYER_HAS_HORSES_AND_IRON_REQUIREMENTS',											'REQUIRES_PLAYER_HAS_ENOUGH_HORSES'),
	('HD_PLAYER_HAS_HORSES_AND_IRON_REQUIREMENTS',											'REQUIRES_PLAYER_HAS_ENOUGH_IRON'),
	('NOT_WONDER_IS_OR_ADJACENT_TO_COAST',													'PLOT_IS_OR_ADJACENT_TO_COAST_REQUIREMENTS'),
	('NOT_WONDER_IS_OR_ADJACENT_TO_COAST',													'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
	('WONDER_IS_OR_ADJACENT_TO_COAST',														'PLOT_IS_OR_ADJACENT_TO_COAST_REQUIREMENTS'),
	('WONDER_IS_OR_ADJACENT_TO_COAST',														'REQUIRES_DISTRICT_IS_DISTRICT_WONDER'),
	('WONDER_IS_OR_ADJACENT_TO_COAST',														'REQUIRES_PLOT_HAS_COMPLETE_WONDER'),
    ('HD_DISTRICTS_IS_NOT_WONDERS_OR_CITY_CENTER_REQUIREMENTS',								'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
    ('HD_DISTRICTS_IS_NOT_WONDERS_OR_CITY_CENTER_REQUIREMENTS',								'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_CITY_CENTER'),
	('NON_CITYCENTER_PLOT_IS_OR_ADJACENT_TO_COAST', 										'REQUIRES_DISTRICT_IS_NOT_CITY_CENTER'),
	('NON_CITYCENTER_PLOT_IS_OR_ADJACENT_TO_COAST',											'PLOT_IS_OR_ADJACENT_TO_COAST_REQUIREMENTS'),
	('NON_CITYCENTER_PLOT_IS_OR_ADJACENT_TO_COAST',											'REQUIRES_PLOT_DOES_NOT_HAVE_INCOMPLETE_WONDER'),
	('PLOT_HAS_SHALLOW_WATER_AND_STEAM_POWER_REQUIREMENTS',									'REQUIRES_PLOT_HAS_SHALLOW_WATER'),
	('PLOT_HAS_SHALLOW_WATER_AND_STEAM_POWER_REQUIREMENTS',									'HD_REQUIRES_PLAYER_HAS_TECH_STEAM_POWER'),
	('PLOT_ADJACENT_TO_MOUNTAIN_IS_IMPROVED_REQUIREMENTS',									'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
	('PLOT_ADJACENT_TO_MOUNTAIN_IS_IMPROVED_REQUIREMENTS',									'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_ADJACENT_TO_MOUNTAIN_REQUIREMENTS',												'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
	('HD_PLOT_HAS_RESOURCE_REQUIREMENTS',													'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE'),
	('HD_TEMPLE_ARTEMIS_IMPROVEMENTS',													'REQUIRES_PLOT_HAS_IMPROVEMENT_CAMP'),
	('HD_TEMPLE_ARTEMIS_IMPROVEMENTS',													'REQUIRES_PLOT_HAS_IMPROVEMENT_PASTURE'),
	('HD_TEMPLE_ARTEMIS_REQUIREMENTS',													'HD_REQUIRES_TEMPLE_ARTEMIS_IMPROVEMENTS'),
	('HD_TEMPLE_ARTEMIS_REQUIREMENTS',													'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');

-- RequirementSets
insert or ignore into RequirementSets
	(RequirementSetId,									RequirementSetType)
values
	-- Techs
	('HAS_COPPER_RESOURCE_AND_BRONZE_WORKING',			'REQUIREMENTSET_TEST_ALL'),
	('PLOT_ADJACENT_TO_MOUNTAIN',						'REQUIREMENTSET_TEST_ANY'),
	('HAS_APPRENTICESHIP_AND_PLOT_ADJACENT_TO_MOUNTAIN','REQUIREMENTSET_TEST_ALL'),
	('PLOT_ADJACENT_TO_INDUSTRIAL_ZONE',				'REQUIREMENTSET_TEST_ANY'),
	-- ('HAS_CONSTRUCTION_AND_PLOT_ADJACENT_TO_RIVER_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_LUXURY_RESOURCE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_BONUS_RESOURCE_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_STRATEGIC_RESOURCE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_LUXURY_OR_BONUS_RESOURCE_REQUIREMENTS', 'REQUIREMENTSET_TEST_ANY'),
	-- ('PLOT_HAS_WORKSHOP_RESOURCES_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	-- ('PLOT_HAS_WORKSHOP_IMPROVEMENTS_REQUIREMENTS',		'REQUIREMENTSET_TEST_ANY'),
	-- ('PLOT_HAS_MANU_RESOURCES_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	-- ('PLOT_HAS_MANU_IMPROVEMENTS_REQUIREMENTS',			'REQUIREMENTSET_TEST_ANY'),
	-- buildings
	('HD_PLOT_HAS_FISHING_BOATS_OVER_BONUS_RESOURCES',		'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_PLANTATION_OVER_BONUS_RESOURCES',		'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_CAMP_OVER_BONUS_RESOURCES',			'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_PASTURE_OVER_BONUS_RESOURCES',		'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_FARM_OVER_BONUS_RESOURCES',			'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_FARM_OVER_LUXURY_RESOURCES',      	'REQUIREMENTSET_TEST_ALL'),
	('HD_PLAYER_HAS_FAVOR_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_MINE_OVER_BONUS_RESOURCES',							'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_QUARRY_OVER_BONUS_RESOURCES',						'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_LUMBER_MILL_OVER_BONUS_RESOURCES',					'REQUIREMENTSET_TEST_ALL'),
	('HAS_IMPROVED_HORSES',								'REQUIREMENTSET_TEST_ALL'),
	('HAS_IMPROVED_IRON',								'REQUIREMENTSET_TEST_ALL'),
	('HAS_IMPROVED_COAL',								'REQUIREMENTSET_TEST_ALL'),
	('HAS_ARMORY_RESOURCE',								'REQUIREMENTSET_TEST_ANY'),
	('HAS_FACTORY_RESOURCE',							'REQUIREMENTSET_TEST_ANY'),
	('HAS_MILITARY_ACADEMY_RESOURCE',					'REQUIREMENTSET_TEST_ANY'),
	-- 
	('IS_ADJACENT_TO_AQUEDUCT',							'REQUIREMENTSET_TEST_ALL'),
	('IS_FARM_ADJACENT_TO_FRESH_WATER',					'REQUIREMENTSET_TEST_ALL'),
	('IS_FARM_ADJACENT_TO_AQUEDUCT',					'REQUIREMENTSET_TEST_ALL'),
	('IS_FARM_ADJACENT_TO_FRESH_WATER_AND_AQUEDUCT',	'REQUIREMENTSET_TEST_ALL'),
	('UNIVERSITY_ADJACENCY_SCIENCE_JUNGLE_REQUIREMENTS','REQUIREMENTSET_TEST_ALL'),
	('HANSA_ADJACENT_PRODUCTION_RESOURCE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	-- ('MBANZA_ADJACENCY_FOOD_JUNGLE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	-- ('MBANZA_ADJACENCY_FOOD_FOREST_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_MINE_OR_QUARRY',							'REQUIREMENTSET_TEST_ANY'),
	-- Airport
	('HAS_AIRPORT_WITHIN_9_TILES',						'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_NO_FILM_STUDIO',							'REQUIREMENTSET_TEST_ALL'),
	-- Hill
	('PLOT_IS_TERRAIN_HILL',							'REQUIREMENTSET_TEST_ANY'),
	-- Maori
	('PLOT_HAS_JUNGLE_CIVIL_SERVICE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_FOREST_CIVIL_SERVICE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_JUNGLE_ENVIRONMENTALISM_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_FOREST_ENVIRONMENTALISM_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('COUNTER_ANTI_CAVALRY_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,									RequirementId)
values
	('PLOT_ADJACENT_TO_MOUNTAIN',						'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
	('HAS_APPRENTICESHIP_AND_PLOT_ADJACENT_TO_MOUNTAIN','REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN'),
	('HAS_APPRENTICESHIP_AND_PLOT_ADJACENT_TO_MOUNTAIN','HD_REQUIRES_PLAYER_HAS_TECH_APPRENTICESHIP'),
	('PLOT_ADJACENT_TO_INDUSTRIAL_ZONE',				'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_INDUSTRIAL_ZONE'),
	('PLOT_ADJACENT_TO_INDUSTRIAL_ZONE',				'REQUIRES_PLOT_ADJACENT_TO_DISTRICT_HANSA'),
	('HD_PLOT_HAS_LUXURY_RESOURCE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_LUXURY'),
	('HD_PLOT_HAS_BONUS_RESOURCE_REQUIREMENTS',			'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_STRATEGIC_RESOURCE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_STRATEGIC'),
	('HD_PLOT_HAS_LUXURY_OR_BONUS_RESOURCE_REQUIREMENTS', 'REQUIRES_PLOT_HAS_LUXURY'),
	('HD_PLOT_HAS_LUXURY_OR_BONUS_RESOURCE_REQUIREMENTS', 'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_FISHING_BOATS_OVER_BONUS_RESOURCES',		'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_FISHING_BOATS_OVER_BONUS_RESOURCES',		'REQUIRES_PLOT_HAS_IMPROVEMENT_FISHING_BOATS'),
	('HD_PLOT_HAS_PLANTATION_OVER_BONUS_RESOURCES',		'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_PLANTATION_OVER_BONUS_RESOURCES',		'REQUIRES_PLOT_HAS_PLANTATION'),
	('HD_PLOT_HAS_FARM_OVER_BONUS_RESOURCES',			'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_FARM_OVER_BONUS_RESOURCES',			'REQUIRES_PLOT_HAS_FARM'),
	('HD_PLOT_HAS_FARM_OVER_LUXURY_RESOURCES',      	'REQUIRES_PLOT_HAS_LUXURY'),
	('HD_PLOT_HAS_FARM_OVER_LUXURY_RESOURCES',      	'REQUIRES_PLOT_HAS_FARM'),
	('HD_PLAYER_HAS_FAVOR_REQUIREMENTS',     			'HD_REQUIRES_PLAYER_HAS_FAVOR'),
	('HD_PLOT_HAS_CAMP_OVER_BONUS_RESOURCES',			'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_CAMP_OVER_BONUS_RESOURCES',			'REQUIRES_PLOT_HAS_CAMP'),
	-- Commercial hub
	('HD_PLOT_HAS_PASTURE_OVER_BONUS_RESOURCES',		'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_PASTURE_OVER_BONUS_RESOURCES',		'REQUIRES_PLOT_HAS_PASTURE'),
	-- Encampment
	('HD_PLOT_HAS_MINE_OVER_BONUS_RESOURCES',							'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_MINE_OVER_BONUS_RESOURCES',							'REQUIRES_PLOT_HAS_MINE'),
	-- Stable
	('HAS_IMPROVED_HORSES',								'REQUIRES_RESOURCE_HORSES_IN_PLOT'),
	('HAS_IMPROVED_HORSES',								'REQUIRES_PLOT_HAS_PASTURE'),
	-- Barracks
	('HAS_IMPROVED_IRON',								'REQUIRES_RESOURCE_IRON_IN_PLOT'),
	('HAS_IMPROVED_IRON',								'REQUIRES_PLOT_HAS_MINE'),
	-- Armory
	('HAS_ARMORY_RESOURCE',								'REQUIRES_RESOURCE_NITER_IN_PLOT'),
	('HAS_ARMORY_RESOURCE',								'REQUIRES_RESOURCE_OIL_IN_PLOT'),
	-- Factory
	('HAS_IMPROVED_COAL',								'REQUIRES_RESOURCE_COAL_IN_PLOT'),
	('HAS_IMPROVED_COAL',								'REQUIRES_PLOT_HAS_MINE'),
	('HAS_FACTORY_RESOURCE',							'REQUIRES_RESOURCE_COAL_IN_PLOT'),
	-- Military Academy
	('HAS_MILITARY_ACADEMY_RESOURCE',					'REQUIRES_RESOURCE_ALUMINUM_IN_PLOT'),
	('HAS_MILITARY_ACADEMY_RESOURCE',					'REQUIRES_RESOURCE_URANIUM_IN_PLOT'),
	-- 
	('IS_ADJACENT_TO_AQUEDUCT',							'REQUIRES_PLOT_ADJACENT_TO_AQUEDUCT'),
	-- Aqueduct
	('IS_FARM_ADJACENT_TO_AQUEDUCT',					'REQUIRES_PLOT_ADJACENT_TO_AQUEDUCT'),
	('IS_FARM_ADJACENT_TO_AQUEDUCT',					'REQUIRES_PLOT_HAS_FARM'),
	-- ('IS_FARM_ADJACENT_TO_AQUEDUCT',					'HD_REQUIRES_PLAYER_HAS_TECH_CALENDAR_HD'),
	('IS_FARM_ADJACENT_TO_FRESH_WATER',					'REQUIRES_PLOT_IS_FRESH_WATER'),
	('IS_FARM_ADJACENT_TO_FRESH_WATER',					'REQUIRES_PLOT_HAS_FARM'),
	-- ('IS_FARM_ADJACENT_TO_FRESH_WATER',					'HD_REQUIRES_PLAYER_HAS_TECH_CALENDAR_HD'),
	('IS_FARM_ADJACENT_TO_FRESH_WATER_AND_AQUEDUCT',	'REQUIRES_PLOT_ADJACENT_TO_AQUEDUCT'),
	('IS_FARM_ADJACENT_TO_FRESH_WATER_AND_AQUEDUCT',	'REQUIRES_PLOT_IS_FRESH_WATER'),
	('IS_FARM_ADJACENT_TO_FRESH_WATER_AND_AQUEDUCT',	'REQUIRES_PLOT_HAS_FARM'),
	-- ('IS_FARM_ADJACENT_TO_FRESH_WATER_AND_AQUEDUCT',	'HD_REQUIRES_PLAYER_HAS_TECH_CALENDAR_HD'),
	-- Industrial Zone
	('HD_PLOT_HAS_QUARRY_OVER_BONUS_RESOURCES',						'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_QUARRY_OVER_BONUS_RESOURCES',						'REQUIRES_PLOT_HAS_QUARRY'),
	('HD_PLOT_HAS_LUMBER_MILL_OVER_BONUS_RESOURCES',					'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_LUMBER_MILL_OVER_BONUS_RESOURCES',					'REQUIRES_PLOT_HAS_LUMBER_MILL'),
	-- Hansa, add production to adjacent resources.
	('HANSA_ADJACENT_PRODUCTION_RESOURCE_REQUIREMENTS',	'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE'),
	('HANSA_ADJACENT_PRODUCTION_RESOURCE_REQUIREMENTS',	'ADJACENT_TO_OWNER'),
	-- Mbanza, add food to adjacent jungle or forest.
	-- ('MBANZA_ADJACENCY_FOOD_JUNGLE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_JUNGLE'),
	-- ('MBANZA_ADJACENCY_FOOD_JUNGLE_REQUIREMENTS',		'ADJACENT_TO_OWNER'),
	-- ('MBANZA_ADJACENCY_FOOD_FOREST_REQUIREMENTS',		'PLOT_IS_FOREST_REQUIREMENT'),
	-- ('MBANZA_ADJACENCY_FOOD_FOREST_REQUIREMENTS',		'ADJACENT_TO_OWNER'),
	-- University add science to adjacent rainforest
	('UNIVERSITY_ADJACENCY_SCIENCE_JUNGLE_REQUIREMENTS','REQUIRES_PLOT_HAS_JUNGLE'),
	('UNIVERSITY_ADJACENCY_SCIENCE_JUNGLE_REQUIREMENTS','ADJACENT_TO_OWNER'),
	-- Workshop
	('PLOT_HAS_MINE_OR_QUARRY',							'REQUIRES_PLOT_HAS_MINE'),
	('PLOT_HAS_MINE_OR_QUARRY',							'REQUIRES_PLOT_HAS_QUARRY'),
	-- Airport vs film studio
	('HAS_AIRPORT_WITHIN_9_TILES',						'REQUIRES_AIRPORT_AND_WITHIN_9TILES'),
	-- ('HAS_AIRPORT_WITHIN_9_TILES',						'REQUIRES_CITY_HAS_NO_FILM_STUDIO'),
	('CITY_HAS_NO_FILM_STUDIO',							'REQUIRES_CITY_HAS_NO_FILM_STUDIO'),
	-- Hill
	('PLOT_IS_TERRAIN_HILL',							'PLOT_IS_GRASS_HILLS_TERRAIN_REQUIREMENT'),
	('PLOT_IS_TERRAIN_HILL',							'PLOT_IS_PLAINS_HILLS_TERRAIN_REQUIREMENT'),
	('PLOT_IS_TERRAIN_HILL',							'PLOT_IS_TUNDRA_HILLS_TERRAIN_REQUIREMENT'),
	('PLOT_IS_TERRAIN_HILL',							'PLOT_IS_DESERT_HILLS_TERRAIN_REQUIREMENT'),
	('PLOT_IS_TERRAIN_HILL',							'PLOT_IS_SNOW_HILLS_TERRAIN_REQUIREMENT'),
	-- Maori
	('PLOT_HAS_JUNGLE_CIVIL_SERVICE_REQUIREMENTS',		'REQUIRES_PLAYER_HAS_CIVIL_SERVICE'),
	('PLOT_HAS_JUNGLE_CIVIL_SERVICE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),
	('PLOT_HAS_JUNGLE_CIVIL_SERVICE_REQUIREMENTS',		'PLOT_IS_JUNGLE_REQUIREMENT'),
	('PLOT_HAS_FOREST_CIVIL_SERVICE_REQUIREMENTS',		'REQUIRES_PLAYER_HAS_CIVIL_SERVICE'),
	('PLOT_HAS_FOREST_CIVIL_SERVICE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),
	('PLOT_HAS_FOREST_CIVIL_SERVICE_REQUIREMENTS',		'PLOT_IS_FOREST_REQUIREMENT'),
	('PLOT_HAS_JUNGLE_ENVIRONMENTALISM_REQUIREMENTS',	'REQUIRES_PLAYER_HAS_CIVIC_ENVIRONMENTALISM'),
	('PLOT_HAS_JUNGLE_ENVIRONMENTALISM_REQUIREMENTS',	'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),
	('PLOT_HAS_JUNGLE_ENVIRONMENTALISM_REQUIREMENTS',	'PLOT_IS_JUNGLE_REQUIREMENT'),
	('PLOT_HAS_FOREST_ENVIRONMENTALISM_REQUIREMENTS',	'REQUIRES_PLAYER_HAS_CIVIC_ENVIRONMENTALISM'),
	('PLOT_HAS_FOREST_ENVIRONMENTALISM_REQUIREMENTS',	'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),
	('PLOT_HAS_FOREST_ENVIRONMENTALISM_REQUIREMENTS',	'PLOT_IS_FOREST_REQUIREMENT'),
	('COUNTER_ANTI_CAVALRY_REQUIREMENTS',				'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('COUNTER_ANTI_CAVALRY_REQUIREMENTS',				'OPPONENT_ANTI_CAVALRY_REQUIREMENT');

insert or ignore into RequirementSets
	(RequirementSetId,											RequirementSetType)
values
	('PLOT_HAS_LUMBER_MILL_REQUIREMENTS',			            'REQUIREMENTSET_TEST_ALL'),
	('PAN_CITY_HAS_IMPROVED_LUMBER_MILL_RESOURCE',			    'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_LUXURY_LUMBER_MILL_REQUIREMENTS',			    'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_BONUS_LUMBER_MILL_REQUIREMENTS',			    	'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_LUXURY_MINE_REQUIREMENTS',			    		'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_LUXURY_QUARRY_REQUIREMENTS',			    		'REQUIREMENTSET_TEST_ALL');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,											RequirementId)
values
	('PLOT_HAS_LUMBER_MILL_REQUIREMENTS',			            'REQUIRES_PLOT_HAS_LUMBER_MILL'),
	('PLOT_HAS_LUXURY_LUMBER_MILL_REQUIREMENTS',			    'REQUIRES_PLOT_HAS_LUXURY'),
	('PLOT_HAS_LUXURY_LUMBER_MILL_REQUIREMENTS',			    'REQUIRES_PLOT_HAS_LUMBER_MILL'),
	('PLOT_HAS_BONUS_LUMBER_MILL_REQUIREMENTS',			        'REQUIRES_PLOT_HAS_BONUS'),
	('PLOT_HAS_BONUS_LUMBER_MILL_REQUIREMENTS',			        'REQUIRES_PLOT_HAS_LUMBER_MILL'),
	('PLOT_HAS_LUXURY_MINE_REQUIREMENTS',			    		'REQUIRES_PLOT_HAS_LUXURY'),
	('PLOT_HAS_LUXURY_MINE_REQUIREMENTS',			    		'REQUIRES_PLOT_HAS_MINE'),
	('PLOT_HAS_LUXURY_QUARRY_REQUIREMENTS',			    		'REQUIRES_PLOT_HAS_LUXURY'),
	('PLOT_HAS_LUXURY_QUARRY_REQUIREMENTS',			    		'REQUIRES_PLOT_HAS_QUARRY');

-- Policies (include Golden Age)
insert or ignore into RequirementSets
	(RequirementSetId,							RequirementSetType)
values
	('PLAYER_HAS_NO_DIPLOMATIC_QUARTER',		'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_AQUEDUCT_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_THEATER_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_COMMERCIAL_HUB_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_HARBOR_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_HAS_CAMPUS_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_HAS_INDUSTRIAL_ZONE_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'),
	('HD_UNIT_IS_SETTLER',						'REQUIREMENTSET_TEST_ALL'),
	('UNIT_IS_GOLDEN_AGE_SETTLER',				'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,							RequirementId)
values
	('PLAYER_HAS_NO_DIPLOMATIC_QUARTER',		'REQUIRES_PLAYER_HAS_NO_DIPLOMATIC_QUARTER'),
	('CITY_HAS_AQUEDUCT_REQUIREMENTS',			'REQUIRES_CITY_HAS_DISTRICT_AQUEDUCT'),
	('CITY_HAS_THEATER_REQUIREMENTS',			'REQUIRES_CITY_HAS_DISTRICT_THEATER'),
	('CITY_HAS_COMMERCIAL_HUB_REQUIREMENTS',	'REQUIRES_CITY_HAS_DISTRICT_COMMERCIAL_HUB'),
	('CITY_HAS_HARBOR_REQUIREMENTS',			'REQUIRES_CITY_HAS_DISTRICT_HARBOR'),
	('HD_CITY_HAS_CAMPUS_REQUIREMENTS',			'REQUIRES_CITY_HAS_DISTRICT_CAMPUS'),
	('HD_CITY_HAS_INDUSTRIAL_ZONE_REQUIREMENTS', 'REQUIRES_CITY_HAS_DISTRICT_INDUSTRIAL_ZONE'),
	('HD_UNIT_IS_SETTLER',						'REQUIREMENT_UNIT_IS_SETTLER'),
	('UNIT_IS_GOLDEN_AGE_SETTLER',				'REQUIREMENT_UNIT_IS_SETTLER'),
	('UNIT_IS_GOLDEN_AGE_SETTLER',				'REQUIRES_PLAYER_HAS_GOLDEN_AGE');

-- Beliefs
insert or ignore into RequirementSets
	(RequirementSetId,											RequirementSetType)
values
	-- Pantheon
	('TENGRI_CITY_HAS_PASTURE',									'REQUIREMENTSET_TEST_ANY'),
	('GODDESS_OF_FESTIVALS_CITY_HAS_PLANTATION',				'REQUIREMENTSET_TEST_ANY'),
	('GOD_OF_THE_SEA_CITY_HAS_FISHINGBOATS',					'REQUIREMENTSET_TEST_ANY'),
	('CITY_FOLLOWS_PANTHEON_AND_CITY_HAS_HOLYSITE',				'REQUIREMENTSET_TEST_ALL'),
	('CITY_FOLLOWS_PANTHEON_AND_HOLYSITE_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('CITY_FOLLOWS_RELIGION_AND_HOLYSITE_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('HOLYSITE_TUNDRA_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HOLYSITE_TUNDRA_HILL_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL'),
	('HOLYSITE_DESERT_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HOLYSITE_DESERT_HILL_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL'),
	('HOLYSITE_JUNGLE_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_1_DESERT',										'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_1_TUNDRA',										'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_TUNDRA_OR_TUNDRA_HILL_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
--埃及托勒密
	('PLOT_HAS_FLOODPLAINS_OR_PLAINSFLOODPLAINS_OR_GRASSFLOODPLAINS_REQUIREMENTS',		'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_DESERT_OR_DESERT_HILL_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('GODDESS_OF_FIRE_CITY_HAS_VOLCANO',						'REQUIREMENTSET_TEST_ANY'),
	('RELIGIOUS_IDOLS_CITY_HAS_MINE',							'REQUIREMENTSET_TEST_ANY'),
	('STONE_CIRCLES_CITY_HAS_QUARRY',							'REQUIREMENTSET_TEST_ANY'),
	('HD_CITY_HAS_NATURAL_WONDER_REQUIREMENTS',					'REQUIREMENTSET_TEST_ANY'),
	('HOLYSITE_PLANTATION_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL'),
	('HOLYSITE_PASTURE_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('PLOT_EIGHT_INCLUDE_CITY_CENTER',							'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_GRANARY',										'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_MONUMENT',										'REQUIREMENTSET_TEST_ALL'),
	-- ('PLOT_HAS_FARM_RESOURCE_REQUIREMENTS',						'REQUIREMENTSET_TEST_ANY'),
	('PLOT_IS_LAND_ADJACENT_TO_COAST',							'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_COAST_NOT_LAKE_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_OCEAN_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_IMPROVED_FOREST_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_IMPROVED_JUNGLE_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_CAMP_AND_RESOURCE_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_BONUS_FISHING_BOATS_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_LUXURY_FISHING_BOATS_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	--
	('HD_CITY_HAS_RESOURCE_CAMP',								'REQUIREMENTSET_TEST_ANY'),
	('HD_CITY_HAS_RESOURCE_FARM',								'REQUIREMENTSET_TEST_ANY'),
	-- ('HD_CITY_HAS_RESOURCE_FARM_OR_PLANTATION_OR_LUMBER_MILL_REQUIREMENTS', 	'REQUIREMENTSET_TEST_ANY'),
	('HD_PLOT_HAS_RESOURCE_FARM_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_RESOURCE_MINE_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_RESOURCE_LUMBER_MILL_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_RESOURCE_CAMP_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	--
	('HD_PLOT_HAS_FARM_AND_BONUS_RESOURCE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_FARM_AND_LUXURY_RESOURCE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,									RequirementId)
select
	'RELIGIOUS_IDOLS_CITY_HAS_MINE',					'HD_REQUIRES_CITY_HAS_IMPROVED_' || r.ResourceType
from Resources r, Improvement_ValidResources i
where r.ResourceType = i.ResourceType and i.ImprovementType = 'IMPROVEMENT_MINE'
	and (r.ResourceClassType = 'RESOURCECLASS_LUXURY' or r.ResourceClassType = 'RESOURCECLASS_BONUS' or r.ResourceClassType = 'RESOURCECLASS_STRATEGIC');
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select	'STONE_CIRCLES_CITY_HAS_QUARRY', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_QUARRY';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select	'TENGRI_CITY_HAS_PASTURE', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_PASTURE';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select	'GODDESS_OF_FESTIVALS_CITY_HAS_PLANTATION', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_PLANTATION';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select	'GOD_OF_THE_SEA_CITY_HAS_FISHINGBOATS', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_FISHING_BOATS';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select	'HD_CITY_HAS_RESOURCE_CAMP', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_CAMP';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select	'HD_CITY_HAS_RESOURCE_FARM', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_FARM';

-- insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
-- select 'HD_CITY_HAS_RESOURCE_FARM_OR_PLANTATION_OR_LUMBER_MILL_REQUIREMENTS', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
-- from Improvement_ValidResources where ImprovementType = 'IMPROVEMENT_FARM' or ImprovementType = 'IMPROVEMENT_PLANTATION' or ImprovementType = 'IMPROVEMENT_LUMBER_MILL';

-- 城市拥有改良奢侈
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'CITY_HAS_IMPROVED_LUXURY_RESOURCE', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY';

-- 单位是平民单位 不包括伟人、商队、间谍和宗教单位
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'UNIT_IS_CIVILIAN_CLASS', 'REQUIRES_UNIT_IS_' || UnitType
from Units where UnitType in ('UNIT_SETTLER','UNIT_BUILDER','UNIT_ARCHAEOLOGIST','UNIT_NATURALIST','UNIT_ROCK_BAND','UNIT_LEU_INVESTOR','UNIT_LEU_TYCOON');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,											RequirementId)
values
	-- Pantheon
	('CITY_FOLLOWS_PANTHEON_AND_CITY_HAS_HOLYSITE',				'REQUIRES_CITY_FOLLOWS_PANTHEON'),
	('CITY_FOLLOWS_PANTHEON_AND_CITY_HAS_HOLYSITE',				'REQUIRES_CITY_HAS_HOLY_SITE'),
	('CITY_FOLLOWS_PANTHEON_AND_HOLYSITE_REQUIREMENTS',			'REQUIRES_CITY_FOLLOWS_PANTHEON'),
	('CITY_FOLLOWS_PANTHEON_AND_HOLYSITE_REQUIREMENTS',			'REQUIRES_DISTRICT_IS_HOLY_SITE'),
	('CITY_FOLLOWS_RELIGION_AND_HOLYSITE_REQUIREMENTS',			'REQUIRES_CITY_FOLLOWS_RELIGION'),
	('CITY_FOLLOWS_RELIGION_AND_HOLYSITE_REQUIREMENTS',			'REQUIRES_DISTRICT_IS_HOLY_SITE'),
	('HOLYSITE_TUNDRA_REQUIREMENTS',							'REQUIRES_PLOT_HAS_TUNDRA'),
	('HOLYSITE_TUNDRA_REQUIREMENTS',							'ADJACENT_TO_OWNER'),
	('HOLYSITE_TUNDRA_HILL_REQUIREMENTS',						'REQUIRES_PLOT_HAS_TUNDRA_HILLS'),
	('HOLYSITE_TUNDRA_HILL_REQUIREMENTS',						'ADJACENT_TO_OWNER'),
	('HOLYSITE_DESERT_REQUIREMENTS',							'REQUIRES_PLOT_HAS_DESERT'),
	('HOLYSITE_DESERT_REQUIREMENTS',							'ADJACENT_TO_OWNER'),
	('HOLYSITE_DESERT_HILL_REQUIREMENTS',						'REQUIRES_PLOT_HAS_DESERT_HILLS'),
	('HOLYSITE_DESERT_HILL_REQUIREMENTS',						'ADJACENT_TO_OWNER'),
	('HOLYSITE_JUNGLE_REQUIREMENTS',							'REQUIRES_PLOT_HAS_JUNGLE'),
	('HOLYSITE_JUNGLE_REQUIREMENTS',							'ADJACENT_TO_OWNER'),
	('CITY_HAS_1_DESERT',										'REQUIRES_CITY_HAS_1_DESERT'),
	('CITY_HAS_1_TUNDRA',										'REQUIRES_CITY_HAS_1_TUNDRA'),
	('PLOT_HAS_TUNDRA_OR_TUNDRA_HILL_REQUIREMENTS',				'REQUIRES_PLOT_HAS_TUNDRA'),
	('PLOT_HAS_TUNDRA_OR_TUNDRA_HILL_REQUIREMENTS',				'REQUIRES_PLOT_HAS_TUNDRA_HILLS'),
--埃及/托勒密↓
	('PLOT_HAS_FLOODPLAINS_OR_PLAINSFLOODPLAINS_OR_GRASSFLOODPLAINS_REQUIREMENTS',				'HD_REQUIRES_PLOT_HAS_FEATURE_FLOODPLAINS_GRASSLAND'),
	('PLOT_HAS_FLOODPLAINS_OR_PLAINSFLOODPLAINS_OR_GRASSFLOODPLAINS_REQUIREMENTS',				'HD_REQUIRES_PLOT_HAS_FEATURE_FLOODPLAINS_PLAINS'),
	('PLOT_HAS_FLOODPLAINS_OR_PLAINSFLOODPLAINS_OR_GRASSFLOODPLAINS_REQUIREMENTS',				'HD_REQUIRES_PLOT_HAS_FEATURE_FLOODPLAINS'),
--埃及/托勒密↑
	('PLOT_HAS_DESERT_OR_DESERT_HILL_REQUIREMENTS',				'REQUIRES_PLOT_HAS_DESERT'),
	('PLOT_HAS_DESERT_OR_DESERT_HILL_REQUIREMENTS',				'REQUIRES_PLOT_HAS_DESERT_HILLS'),
	('GODDESS_OF_FIRE_CITY_HAS_VOLCANO',						'REQUIRES_CITY_HAS_FEATURE_GEOTHERMAL_FISSURE'),
	('GODDESS_OF_FIRE_CITY_HAS_VOLCANO',						'REQUIRES_CITY_HAS_FEATURE_VOLCANIC_SOIL'),
	('GODDESS_OF_FIRE_CITY_HAS_VOLCANO',						'REQUIRES_CITY_HAS_FEATURE_VOLCANO'),
	('GODDESS_OF_FIRE_CITY_HAS_VOLCANO',						'REQUIRES_CITY_HAS_FEATURE_VESUVIUS'),
	('GODDESS_OF_FIRE_CITY_HAS_VOLCANO',						'REQUIRES_CITY_HAS_FEATURE_KILIMANJARO'),
	('HOLYSITE_PLANTATION_REQUIREMENTS',						'REQUIRES_PLOT_HAS_PLANTATION'),
	('HOLYSITE_PLANTATION_REQUIREMENTS',						'ADJACENT_TO_OWNER'),
	('HOLYSITE_PASTURE_REQUIREMENTS',							'REQUIRES_PLOT_HAS_PASTURE'),
	('HOLYSITE_PASTURE_REQUIREMENTS',							'ADJACENT_TO_OWNER'),
	('PLOT_EIGHT_INCLUDE_CITY_CENTER',							'REQUIRES_PLOT_WITHIN_EIGHT_CITY_CENTER'),
	('CITY_HAS_GRANARY',										'REQUIRES_CITY_HAS_BUILDING_GRANARY'),
	('CITY_HAS_MONUMENT',										'REQUIRES_CITY_HAS_BUILDING_MONUMENT'),
	-- ('PLOT_HAS_FARM_RESOURCE_REQUIREMENTS',						'REQUIRES_WHEAT_IN_PLOT'),
	-- ('PLOT_HAS_FARM_RESOURCE_REQUIREMENTS',						'REQUIRES_RICE_IN_PLOT'),
	('PLOT_IS_LAND_ADJACENT_TO_COAST',							'REQUIRES_PLOT_HAS_NOT_OCEAN'),
	('PLOT_IS_LAND_ADJACENT_TO_COAST',							'REQUIRES_PLOT_HAS_NOT_COAST'),
	('PLOT_IS_LAND_ADJACENT_TO_COAST',							'REQUIRES_PLOT_IS_ADJACENT_TO_COAST'),
	('PLOT_IS_COAST_NOT_LAKE_REQUIREMENTS',						'PLOT_IS_NOT_LAKE_REQUIREMENTS'),
	('PLOT_IS_COAST_NOT_LAKE_REQUIREMENTS',						'REQUIRES_PLOT_HAS_COAST'),
	('PLOT_IS_OCEAN_REQUIREMENTS',								'REQUIRES_TERRAIN_OCEAN'),
	('PLOT_HAS_IMPROVED_FOREST_REQUIREMENTS',					'PLOT_IS_FOREST_REQUIREMENT'),
	('PLOT_HAS_IMPROVED_FOREST_REQUIREMENTS',					'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_HAS_IMPROVED_JUNGLE_REQUIREMENTS',					'PLOT_IS_JUNGLE_REQUIREMENT'),
	('PLOT_HAS_IMPROVED_JUNGLE_REQUIREMENTS',					'REQUIRES_PLOT_IS_IMPROVED'),
	('PLOT_HAS_CAMP_AND_RESOURCE_REQUIREMENTS',					'REQUIRES_PLOT_HAS_CAMP'),
	('PLOT_HAS_CAMP_AND_RESOURCE_REQUIREMENTS',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('PLOT_HAS_BONUS_FISHING_BOATS_REQUIREMENTS',				'REQUIRES_PLOT_HAS_FISHINGBOATS'),
	('PLOT_HAS_BONUS_FISHING_BOATS_REQUIREMENTS',				'REQUIRES_PLOT_HAS_BONUS'),
	('PLOT_HAS_LUXURY_FISHING_BOATS_REQUIREMENTS',				'REQUIRES_PLOT_HAS_FISHINGBOATS'),
	('PLOT_HAS_LUXURY_FISHING_BOATS_REQUIREMENTS',				'REQUIRES_PLOT_HAS_LUXURY'),
	-- 太阳神, by xiaoxiao
	('HD_PLOT_HAS_RESOURCE_FARM_REQUIREMENTS',					'REQUIRES_PLOT_HAS_FARM'),
	('HD_PLOT_HAS_RESOURCE_FARM_REQUIREMENTS',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('HD_PLOT_HAS_RESOURCE_MINE_REQUIREMENTS',					'REQUIRES_PLOT_HAS_MINE'),
	('HD_PLOT_HAS_RESOURCE_MINE_REQUIREMENTS',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('HD_PLOT_HAS_RESOURCE_LUMBER_MILL_REQUIREMENTS',			'REQUIRES_PLOT_HAS_LUMBER_MILL'),
	('HD_PLOT_HAS_RESOURCE_LUMBER_MILL_REQUIREMENTS',			'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	('HD_PLOT_HAS_RESOURCE_CAMP_REQUIREMENTS',					'REQUIRES_PLOT_HAS_CAMP'),
	('HD_PLOT_HAS_RESOURCE_CAMP_REQUIREMENTS',					'PLOT_HAS_RESOURCE_REQUIREMENTS'),
	-------
	('HD_PLOT_HAS_FARM_AND_BONUS_RESOURCE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_FARM'),
	('HD_PLOT_HAS_FARM_AND_BONUS_RESOURCE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_BONUS'),
	('HD_PLOT_HAS_FARM_AND_LUXURY_RESOURCE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_FARM'),
	('HD_PLOT_HAS_FARM_AND_LUXURY_RESOURCE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_LUXURY');

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_CITY_HAS_NATURAL_WONDER_REQUIREMENTS', 'REQUIRES_CITY_HAS_' || FeatureType from Features where NaturalWonder = 1;

-- AI 
insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
select 'PLAYER_IS_HIGH_DIFFICULTY_AI_AT_LEAST_' || EraType, 'REQUIREMENTSET_TEST_ALL' from Eras;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'PLAYER_IS_HIGH_DIFFICULTY_AI_AT_LEAST_' || EraType, 'REQUIRES_PLAYER_IS_AI' from Eras;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'PLAYER_IS_HIGH_DIFFICULTY_AI_AT_LEAST_' || EraType, 'REQUIRES_HIGH_DIFFICULTY' from Eras;
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'PLAYER_IS_HIGH_DIFFICULTY_AI_AT_LEAST_' || EraType, 'REQUIRES_PLAYER_IS_' || EraType from Eras;

-- insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
-- select 'PLAYER_IS_HIGH_DIFFICULTY_AI_AT_LEAST_' || EraType, 'REQUIREMENTSET_TEST_ALL' from Eras;

-- insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
-- select 'PLAYER_IS_HIGH_DIFFICULTY_AI_AT_LEAST_' || EraType, 'REQUIRES_PLAYER_IS_AI' from Eras;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI_CAN_SEE_' || ResourceType, 'REQUIREMENTSET_TEST_ALL'
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI_CAN_SEE_' || ResourceType, 'REQUIRES_PLAYER_IS_AI'
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI_CAN_SEE_' || ResourceType, 'REQUIRES_DIFFICULTY_AT_LEAST_DEITY'
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI_CAN_SEE_' || ResourceType, 'HD_REQUIRES_PLAYER_CAN_SEE_' || ResourceType
from Resources where ResourceClassType = 'RESOURCECLASS_STRATEGIC';

-- 6 or 8 difficulty.
insert or ignore into RequirementArguments (RequirementId,		Name,		Value) values
	('REQUIRES_DIFFICULTY_AT_LEAST_EMPEROR',					'Handicap',	'DIFFICULTY_EMPEROR'),
	('REQUIRES_DIFFICULTY_AT_LEAST_IMMORTAL',					'Handicap',	'DIFFICULTY_IMMORTAL'),
	('REQUIRES_DIFFICULTY_AT_LEAST_DEITY',						'Handicap',	'DIFFICULTY_DEITY');

insert or ignore into Requirements (RequirementId,				RequirementType) values
	('REQUIRES_DIFFICULTY_AT_LEAST_EMPEROR',					'REQUIREMENT_PLAYER_HANDICAP_AT_OR_ABOVE'),
	('REQUIRES_DIFFICULTY_AT_LEAST_IMMORTAL',					'REQUIREMENT_PLAYER_HANDICAP_AT_OR_ABOVE'),
	('REQUIRES_DIFFICULTY_AT_LEAST_DEITY',						'REQUIREMENT_PLAYER_HANDICAP_AT_OR_ABOVE');

insert or ignore into RequirementSets (RequirementSetId,		RequirementSetType) values
	('PLAYER_IS_AT_LEAST_EMPEROR_DIFFICULTY_AI',				'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI',					'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_IS_AT_LEAST_IMMORTAL_DIFFICULTY_HUMAN',			'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN',				'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN_AND_HAS_CITY',	'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,											RequirementId)
values
	('PLAYER_IS_AT_LEAST_EMPEROR_DIFFICULTY_AI',				'REQUIRES_PLAYER_IS_AI'),
	('PLAYER_IS_AT_LEAST_EMPEROR_DIFFICULTY_AI',				'REQUIRES_DIFFICULTY_AT_LEAST_EMPEROR'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI',					'REQUIRES_PLAYER_IS_AI'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_AI',					'REQUIRES_DIFFICULTY_AT_LEAST_DEITY'),
	('PLAYER_IS_AT_LEAST_IMMORTAL_DIFFICULTY_HUMAN',			'REQUIRES_PLAYER_IS_HUMAN'),
	('PLAYER_IS_AT_LEAST_IMMORTAL_DIFFICULTY_HUMAN',			'REQUIRES_DIFFICULTY_AT_LEAST_IMMORTAL'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN',				'REQUIRES_PLAYER_IS_HUMAN'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN',				'REQUIRES_DIFFICULTY_AT_LEAST_DEITY'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN_AND_HAS_CITY',	'REQUIRES_PLAYER_IS_HUMAN'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN_AND_HAS_CITY',	'REQUIRES_DIFFICULTY_AT_LEAST_DEITY'),
	('PLAYER_IS_AT_LEAST_DEITY_DIFFICULTY_HUMAN_AND_HAS_CITY',	'REQUIRES_PLAYER_HAS_AT_LEAST_ONE_CITY');

-- PLOT IS IMPROVED
insert or ignore into Requirements (RequirementId,	RequirementType,	Inverse)	values
	('REQUIRES_PLOT_IS_IMPROVED',	'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT',	0);
insert or ignore into RequirementSetRequirements (RequirementSetId,	RequirementId)	values
	('PLOT_IS_IMPROVED',	'REQUIRES_PLOT_IS_IMPROVED');
insert or ignore into RequirementSets (RequirementSetId,	RequirementSetType)	values
	('PLOT_IS_IMPROVED',	'REQUIREMENTSET_TEST_ALL');

-- City Park梁市立公园
insert or ignore into RequirementSets 
	(RequirementSetId,												RequirementSetType) 
values
	('REQUIRE_PLOT_ADJACENT_TO_OWNER',								'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_GOVERNOR_PROMOTION_PARKS_RECREATION_AND_ADJACENT',	'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
values
	('REQUIRE_PLOT_ADJACENT_TO_OWNER',								'ADJACENT_TO_OWNER'),
	('CITY_HAS_GOVERNOR_PROMOTION_PARKS_RECREATION_AND_ADJACENT',	'ADJACENT_TO_OWNER'),
	('CITY_HAS_GOVERNOR_PROMOTION_PARKS_RECREATION_AND_ADJACENT',	'REQUIRES_CITY_HAS_GOVERNOR_PROMOTION_PARKS_RECREATION');


--UNIT_IS_RELIGIOUS_ALL
insert or ignore into RequirementSetRequirements 
	(RequirementSetId,				RequirementId)	
values
	('UNIT_IS_LAND_COMBAT',			'REQUIREMENT_UNIT_IS_LAND_COMBAT'),
	('UNIT_IS_RELIGOUS_ALL',		'REQUIRES_UNIT_IS_UNIT_MISSIONARY'),
	('UNIT_IS_RELIGOUS_ALL',		'REQUIRES_UNIT_IS_UNIT_APOSTLE'),
	('UNIT_IS_RELIGOUS_ALL',		'REQUIRES_UNIT_IS_UNIT_INQUISITOR'),
	('UNIT_IS_RELIGOUS_ALL',		'REQUIRES_UNIT_IS_UNIT_GURU'),
	('UNIT_IS_RELIGOUS_ALL_AND_MONK','REQUIRES_UNIT_IS_UNIT_MISSIONARY'),
	('UNIT_IS_RELIGOUS_ALL_AND_MONK','REQUIRES_UNIT_IS_UNIT_APOSTLE'),
	('UNIT_IS_RELIGOUS_ALL_AND_MONK','REQUIRES_UNIT_IS_UNIT_INQUISITOR'),
	('UNIT_IS_RELIGOUS_ALL_AND_MONK','REQUIRES_UNIT_IS_UNIT_GURU'),
	('UNIT_IS_RELIGOUS_ALL_AND_MONK','REQUIRES_UNIT_IS_UNIT_WARRIOR_MONK');

insert or ignore into RequirementSets (RequirementSetId,	RequirementSetType)	values
	('UNIT_IS_LAND_COMBAT',			'REQUIREMENTSET_TEST_ALL'),
	('UNIT_IS_RELIGOUS_ALL_AND_MONK','REQUIREMENTSET_TEST_ANY'),
	('UNIT_IS_RELIGOUS_ALL',		'REQUIREMENTSET_TEST_ANY');

--Player_Can_See_Strategic resources(Hattusa)
insert or ignore into RequirementSetRequirements 
	(RequirementSetId,				RequirementId)	
values
	('PLAYER_CAN_SEE_HORSES',		'REQUIRES_PLAYER_CAN_SEE_HORSES'),
	('PLAYER_CAN_SEE_IRON',			'REQUIRES_PLAYER_CAN_SEE_IRON'),
	('PLAYER_CAN_SEE_NITER',		'REQUIRES_PLAYER_CAN_SEE_NITER'),
	('PLAYER_CAN_SEE_COAL',			'REQUIRES_PLAYER_CAN_SEE_COAL'),
	('PLAYER_CAN_SEE_OIL',			'REQUIRES_PLAYER_CAN_SEE_OIL'),
	('PLAYER_CAN_SEE_ALUMINUM',		'REQUIRES_PLAYER_CAN_SEE_ALUMINUM'),
	('PLAYER_CAN_SEE_URANIUM',		'REQUIRES_PLAYER_CAN_SEE_URANIUM');

insert or ignore into RequirementSets (RequirementSetId,	RequirementSetType)	
values
	('PLAYER_CAN_SEE_HORSES',		'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_IRON',			'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_NITER',		'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_COAL',			'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_OIL',			'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_ALUMINUM',		'REQUIREMENTSET_TEST_ALL'),
	('PLAYER_CAN_SEE_URANIUM',		'REQUIREMENTSET_TEST_ALL');

-- NOT CITY CENTER
--TOWER_BRIDGE at war with any Major
insert or ignore into Requirements
	(RequirementId,									RequirementType,									Inverse)
values
	('REQUIRES_DISTRICT_IS_NOT_CITY_CENTER',		'REQUIREMENT_DISTRICT_TYPE_MATCHES',				1),
	('REQUIRES_PLAYER_AT_WAR_WITH_ANY_MAJOR',		'REQUIREMENT_PLAYER_IS_AT_PEACE_WITH_ALL_MAJORS',	1);

insert or ignore into Requirements
	(RequirementId,									RequirementType)
values
	('REQUIRES_PLOT_ADJACENT_TO_JUNGLE',			'REQUIREMENT_PLOT_ADJACENT_FEATURE_TYPE_MATCHES'),
	('REQUIRES_PLOT_ADJACENT_VOLCANO',				'REQUIREMENT_PLOT_ADJACENT_FEATURE_TYPE_MATCHES'),
	('REQUIRES_PLOT_ADJACENT_EYJAFJALLAJOKULL',		'REQUIREMENT_PLOT_ADJACENT_FEATURE_TYPE_MATCHES'),
	('REQUIRES_PLOT_ADJACENT_VESUVIUS',				'REQUIREMENT_PLOT_ADJACENT_FEATURE_TYPE_MATCHES'),
	('REQUIRES_PLOT_ADJACENT_KILIMANJARO',			'REQUIREMENT_PLOT_ADJACENT_FEATURE_TYPE_MATCHES');

insert or ignore into RequirementArguments
	(RequirementId,								Name,				Value)
values
	('REQUIRES_DISTRICT_IS_NOT_CITY_CENTER',	'DistrictType',		'DISTRICT_CITY_CENTER'),
	('REQUIRES_PLOT_ADJACENT_TO_JUNGLE',		'FeatureType',		'FEATURE_JUNGLE'),
	('REQUIRES_PLOT_ADJACENT_VOLCANO',			'FeatureType',		'FEATURE_VOLCANO'),
	('REQUIRES_PLOT_ADJACENT_VESUVIUS',			'FeatureType',		'FEATURE_VESUVIUS'),
	('REQUIRES_PLOT_ADJACENT_KILIMANJARO',		'FeatureType',		'FEATURE_KILIMANJARO');

-- support for Viking DLC EYJAFJALLAJOKULL
insert or ignore into RequirementArguments (RequirementId,	Name,	Value)
select	'REQUIRES_PLOT_ADJACENT_EYJAFJALLAJOKULL',	'FeatureType',	'FEATURE_EYJAFJALLAJOKULL'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_EYJAFJALLAJOKULL');

--for EGYPT 埃及/托勒密法老
insert or ignore into RequirementArguments 
	(RequirementId,						Name,					Value) 
values
	('REQUIRES_FLOODPLAINS_OR_PLAINSFLOODPLAINS_OR_GRASSFLOODPLAINS_REQUIREMENTS',	'RequirementSetId',	'PLOT_HAS_FLOODPLAINS_OR_PLAINSFLOODPLAINS_OR_GRASSFLOODPLAINS_REQUIREMENTS');
insert or ignore into Requirements 
	(RequirementId,																					RequirementType) 
values
	('REQUIRES_FLOODPLAINS_OR_PLAINSFLOODPLAINS_OR_GRASSFLOODPLAINS_REQUIREMENTS',					'REQUIREMENT_REQUIREMENTSET_IS_MET');


-- For Russia
insert or ignore into RequirementArguments (RequirementId,		Name,		Value) values
	('REQUIRES_TUNDRA_OR_TUNDRA_HILL',					'RequirementSetId',	'PLOT_HAS_TUNDRA_OR_TUNDRA_HILL_REQUIREMENTS');
	-- ('REQUIRES_DISTRICTS_NOT_CITY_CENTER_NOT_WONDERS',	'RequirementSetId',	'HD_DISTRICTS_IS_NOT_WONDERS_REQUIREMENTS');

insert or ignore into Requirements (RequirementId,		RequirementType) values
	('REQUIRES_TUNDRA_OR_TUNDRA_HILL',					'REQUIREMENT_REQUIREMENTSET_IS_MET');
	-- ('REQUIRES_DISTRICTS_NOT_CITY_CENTER_NOT_WONDERS',	'REQUIREMENT_REQUIREMENTSET_IS_MET');

insert or ignore into RequirementSets (RequirementSetId,		RequirementSetType) values
	('DISTRICTS_ON_TUNDRA_OR_TUNDRA_HILL_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('HD_DISTRICTS_IS_NOT_WONDERS_REQUIREMENTS',    			'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,											RequirementId)
values
	('DISTRICTS_ON_TUNDRA_OR_TUNDRA_HILL_REQUIREMENTS',			'REQUIRES_TUNDRA_OR_TUNDRA_HILL'),
	('DISTRICTS_ON_TUNDRA_OR_TUNDRA_HILL_REQUIREMENTS',			'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
	('HD_DISTRICTS_IS_NOT_WONDERS_REQUIREMENTS',				'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER');

-- Unit promotions
-- DLC Supports
insert or ignore into RequirementSets
	(RequirementSetId,											RequirementSetType)
values
	('COMBAT_AGAINST_UNITS_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,											RequirementId)
values
	('COMBAT_AGAINST_UNITS_REQUIREMENTS',						'OPPONENT_IS_NOT_DISTRICT');

insert or ignore into Requirements
	(RequirementId,									RequirementType,							Inverse)
values
	('OPPONENT_IS_NOT_DISTRICT',					'REQUIREMENT_OPPONENT_IS_DISTRICT',			1);

-- 
insert or ignore into RequirementSets
	(RequirementSetId,											RequirementSetType)
values
	('HD_CITY_DEFENDER_PROMOTION_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('HD_UNIT_IS_NOT_BARBARIAN_GALLEY_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('HD_UNIT_IS_NOT_BARBARIAN_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('HD_OPPONENT_IS_CAVALRY_REQUIREMENTS',						'REQUIREMENTSET_TEST_ANY'),
	('PLOT_IS_OPEN_AREA_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	-- ('HD_UNIT_IS_CAVALRY_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY'),
	-- ('MELEE_FOREST_AND_JUNGLE_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_FOREST_OR_JUNGLE_REQUIREMENTS',					'REQUIREMENTSET_TEST_ANY'),
	('HD_PLOT_HAS_JUNGLE_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_FOREST_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_GRASSFLOODPLAINS_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_PLAINSFLOODPLAINS_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('HD_PLOT_HAS_FLOODPLAINS_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),	
	('BATTLE_LINE_COMBAT_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	-- ('RANGED_WEAKER_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL'),
	-- ('PLOT_IS_CITY_CENTER',										'REQUIREMENTSET_TEST_ALL'),
	('ATTACK_WOUNDED_UNITS_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL'),
	('DEFENCE_MELEE_ATTACK_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL'),
	('DEFENCE_MELEE_ATTACK_ON_HILLS_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	-- ('UNIT_IS_MELEE_OR_RECON_REQUIREMENTS',						'REQUIREMENTSET_TEST_ANY'),
	-- ('UNIT_IS_RECON_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL'),
	-- ('UNIT_IS_RANGED_ON_HILLS_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	-- ('UNIT_IS_ANTI_CAV_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	-- ('ANTI_CAV_HILLS_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL'),
	('ATTACKING_HILLS_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL'),
	('ATTACK_NAVAL_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL'),
	('WOLFPACK_ADJACENT_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,											RequirementId)
values
	('HD_CITY_DEFENDER_PROMOTION_REQUIREMENTS',					'HD_REQUIRES_UNIT_IS_NOT_UNIT_SPY'),
	('HD_CITY_DEFENDER_PROMOTION_REQUIREMENTS',					'HD_REQUIRES_UNIT_IS_NOT_UNIT_APOSTLE'),
	('HD_UNIT_IS_NOT_BARBARIAN_GALLEY_REQUIREMENTS',			'HD_REQUIRES_UNIT_IS_NOT_UNIT_HD_BARBARIAN_GALLEY'),
	('HD_UNIT_IS_NOT_BARBARIAN_REQUIREMENTS',					'REQUIRES_UNIT_NOT_BARBARIAN'),
	('HD_OPPONENT_IS_CAVALRY_REQUIREMENTS',						'ANTI_CAVALRY_OPPONENT_REQUIREMENT_LC'),
	('HD_OPPONENT_IS_CAVALRY_REQUIREMENTS',						'ANTI_CAVALRY_OPPONENT_REQUIREMENT_HC'),
	('PLOT_IS_OPEN_AREA_REQUIREMENTS',							'REQUIRES_PLOT_IS_NOT_FOREST'),
	('PLOT_IS_OPEN_AREA_REQUIREMENTS',							'REQUIRES_PLOT_IS_NOT_JUNGLE'),
	('PLOT_IS_OPEN_AREA_REQUIREMENTS',							'REQUIRES_PLOT_IS_NOT_MARSH'),
	('PLOT_IS_OPEN_AREA_REQUIREMENTS',							'REQUIRES_PLOT_IS_FLAT'),
	-- ('HD_UNIT_IS_CAVALRY_REQUIREMENTS',							'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_LIGHT_CAVALRY'),
	-- ('HD_UNIT_IS_CAVALRY_REQUIREMENTS',							'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_HEAVY_CAVALRY'),
	-- ('MELEE_FOREST_AND_JUNGLE_REQUIREMENTS',					'REQUIRES_PLOT_HAS_FOREST_OR_JUNGLE'),
	-- ('MELEE_FOREST_AND_JUNGLE_REQUIREMENTS',					'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_MELEE'),
	('PLOT_HAS_FOREST_OR_JUNGLE_REQUIREMENTS',					'PLOT_IS_JUNGLE_REQUIREMENT'),
	('PLOT_HAS_FOREST_OR_JUNGLE_REQUIREMENTS',					'PLOT_IS_FOREST_REQUIREMENT'),
	('HD_PLOT_HAS_JUNGLE_REQUIREMENTS',							'PLOT_IS_JUNGLE_REQUIREMENT'),
	('HD_PLOT_HAS_FOREST_REQUIREMENTS',							'PLOT_IS_FOREST_REQUIREMENT'),
--	('HD_PLOT_HAS_GRASSFLOODPLAINS_REQUIREMENTS',				'PLOT_IS_GRASSFLOODPLAINS_REQUIREMENT'),	
--	('HD_PLOT_HAS_PLAINSFLOODPLAINS_REQUIREMENTS',				'PLOT_IS_PLAINSFLOODPLAINS_REQUIREMENT'),
--	('HD_PLOT_HAS_FLOODPLAINS_REQUIREMENTS',					'PLOT_IS_FLOODPLAINS_REQUIREMENT'),
	('BATTLE_LINE_COMBAT_REQUIREMENTS',							'REQUIRES_UNIT_NEXT_TO_MELEE'),
	-- ('RANGED_WEAKER_REQUIREMENTS',								'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	-- ('RANGED_WEAKER_REQUIREMENTS',								'REQUIRES_PLOT_HAS_FOREST_OR_JUNGLE'),
	-- ('PLOT_IS_CITY_CENTER',										'REQUIRES_PLOT_HAS_CITY_CENTER'),
	('ATTACK_WOUNDED_UNITS_REQUIREMENTS',						'REQUIRES_OPPONENT_IS_WOUNDED'),
	('ATTACK_WOUNDED_UNITS_REQUIREMENTS',						'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('DEFENCE_MELEE_ATTACK_REQUIREMENTS',						'PLAYER_IS_DEFENDER_REQUIREMENTS'),
	('DEFENCE_MELEE_ATTACK_REQUIREMENTS',						'MELEE_COMBAT_REQUIREMENTS'),
	('DEFENCE_MELEE_ATTACK_ON_HILLS_REQUIREMENTS',				'PLAYER_IS_DEFENDER_REQUIREMENTS'),
	('DEFENCE_MELEE_ATTACK_ON_HILLS_REQUIREMENTS',				'MELEE_COMBAT_REQUIREMENTS'),
	('DEFENCE_MELEE_ATTACK_ON_HILLS_REQUIREMENTS',				'PLOT_IS_HILLS_REQUIREMENT'),
	-- ('UNIT_IS_MELEE_OR_RECON_REQUIREMENTS',						'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_MELEE'),
	-- ('UNIT_IS_MELEE_OR_RECON_REQUIREMENTS',						'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_RECON'),
	-- ('UNIT_IS_RECON_REQUIREMENTS',								'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_RECON'),
	-- ('UNIT_IS_RANGED_ON_HILLS_REQUIREMENTS',					'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_RANGED'),
	-- ('UNIT_IS_RANGED_ON_HILLS_REQUIREMENTS',					'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	-- ('UNIT_IS_RANGED_ON_HILLS_REQUIREMENTS',					'PLOT_IS_HILLS_REQUIREMENT'),
	-- ('UNIT_IS_ANTI_CAV_REQUIREMENTS',							'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_ANTI_CAVALRY'),
	-- ('ANTI_CAV_HILLS_REQUIREMENTS',								'HD_REQUIRES_UNIT_IS_PROMOTION_CLASS_ANTI_CAVALRY'),
	-- ('ANTI_CAV_HILLS_REQUIREMENTS',								'PLOT_IS_HILLS_REQUIREMENT'),
	('ATTACKING_HILLS_REQUIREMENTS',							'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('ATTACKING_HILLS_REQUIREMENTS',							'PLOT_IS_HILLS_REQUIREMENT'),
	('ATTACK_NAVAL_REQUIREMENTS',								'PLAYER_IS_ATTACKER_REQUIREMENTS'),
	('ATTACK_NAVAL_REQUIREMENTS',								'OPPONENT_IS_NAVAL_REQUIREMENT'),
	('WOLFPACK_ADJACENT_REQUIREMENTS',							'ADJACENT_TO_OWNER'),
	('WOLFPACK_ADJACENT_REQUIREMENTS',							'REQUIRES_UNIT_IS_NAVAL_RAIDER');

insert or ignore into Requirements
	(RequirementId,									RequirementType,							Inverse)
values
	('REQUIRES_PLOT_IS_NOT_FOREST',					'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES',	1),
	('REQUIRES_PLOT_IS_NOT_JUNGLE',					'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES',	1),
	('REQUIRES_PLOT_IS_NOT_MARSH',					'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES',	1);

insert or ignore into Requirements
	(RequirementId,									RequirementType)
values
	('REQUIRES_PLOT_HAS_FOREST_OR_JUNGLE',			'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_OPPONENT_IS_CAVALRY',				'REQUIREMENT_REQUIREMENTSET_IS_MET'),
	('REQUIRES_UNIT_NEXT_TO_MELEE',					'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TAG_MATCHES'),
	('REQUIRES_PLOT_HAS_CITY_CENTER',				'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES'),
	('REQUIRES_PLOT_HAS_CAMPUS',					'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES'),
	('REQUIRES_PLOT_HAS_THEATER',					'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES'),
	('REQUIRES_PLOT_HAS_INDUSTRIAL_ZONE',			'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES'),
	('OPPONENT_IS_NAVAL_REQUIREMENT',				'REQUIREMENT_OPPONENT_UNIT_TAG_MATCHES');

insert or ignore into RequirementArguments
	(RequirementId,							Name,					Value)
values
	('REQUIRES_PLOT_IS_NOT_FOREST',			'FeatureType',			'FEATURE_FOREST'),
	('REQUIRES_PLOT_IS_NOT_JUNGLE',			'FeatureType',			'FEATURE_JUNGLE'),
	('REQUIRES_PLOT_IS_NOT_MARSH',			'FeatureType',			'FEATURE_MARSH'),
	('REQUIRES_PLOT_HAS_FOREST_OR_JUNGLE',	'RequirementSetId',		'PLOT_HAS_FOREST_OR_JUNGLE_REQUIREMENTS'),
	('REQUIRES_OPPONENT_IS_CAVALRY',		'RequirementSetId',		'HD_OPPONENT_IS_CAVALRY_REQUIREMENTS'),
	('REQUIRES_UNIT_NEXT_TO_MELEE',			'Tag',					'CLASS_MELEE'),
	('REQUIRES_UNIT_NEXT_TO_MELEE',			'IncludeCenter',		0),
	('REQUIRES_PLOT_HAS_CITY_CENTER',		'DistrictType',			'DISTRICT_CITY_CENTER'),
	('REQUIRES_PLOT_HAS_CAMPUS',			'DistrictType',			'DISTRICT_CAMPUS'),
	('REQUIRES_PLOT_HAS_THEATER',			'DistrictType',			'DISTRICT_THEATER'),
	('REQUIRES_PLOT_HAS_INDUSTRIAL_ZONE',	'DistrictType',			'DISTRICT_INDUSTRIAL_ZONE'),
	('OPPONENT_IS_NAVAL_REQUIREMENT',		'Tag',					'CLASS_NAVAL');


-----------------------------------------------
-- LARGEST INFLUENC support, from CIVITAS CSE
-----------------------------------------------
INSERT OR IGNORE INTO RequirementSets
		(RequirementSetId,					RequirementSetType			)
VALUES	('PLAYER_HAS_LARGEST_INFLUENCE',	'REQUIREMENTSET_TEST_ALL'	);

-----------------------------------------------
-- RequirementSetRequirements
-----------------------------------------------

INSERT OR IGNORE INTO RequirementSetRequirements
		(RequirementSetId,					RequirementId							)
VALUES	('PLAYER_HAS_LARGEST_INFLUENCE',	'REQUIRES_PLAYER_HAS_LARGEST_INFLUENCE'	),
		('PLAYER_HAS_LARGEST_INFLUENCE',	'REQUIRES_PLAYER_AT_PEACE'				);

--新增reqs相邻轻骑兵
insert or ignore into Requirements
	(RequirementId,									                RequirementType)
values
	('ADJACENT_FRIENDLY_LIGHT_CAVALRY_UNIT_REQUIREMENT',			'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TAG_MATCHES');
	
insert or ignore into RequirementArguments
	(RequirementId,							                        Name,					Value)
values
	('ADJACENT_FRIENDLY_LIGHT_CAVALRY_UNIT_REQUIREMENT',			'Tag',			        'CLASS_LIGHT_CAVALRY');

insert or ignore into RequirementSets
	(RequirementSetId,                                              RequirementSetType)
values
	("ADJACENT_FRIENDLY_LIGHT_CAVALRY_UNIT_REQUIREMENT_SETS",       'REQUIREMENTSET_TEST_ALL');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,                                              RequirementId)
values
	("ADJACENT_FRIENDLY_LIGHT_CAVALRY_UNIT_REQUIREMENT_SETS",       'ADJACENT_FRIENDLY_LIGHT_CAVALRY_UNIT_REQUIREMENT');
--新增reqs9环沿海
--新增本体的港口一级和二级判定
--新增判定相邻重骑兵一环
--新增判定SPY-间谍向导升级6环内单位
--新增判定SPY-间谍先驱升级9环内单位
insert or ignore into Requirements
	(RequirementId,													RequirementType)
values
	('STATUE_OF_LIBERTY_COASTAL',									'REQUIREMENT_PLOT_IS_COASTAL_LAND'),
	('REQUIRES_CITY_HAS_BUILDING_LIGHTHOUSE_BASIC',					'REQUIREMENT_CITY_HAS_BUILDING'),
	('REQUIRES_CITY_HAS_BUILDING_SHIPYARD_BASIC',					'REQUIREMENT_CITY_HAS_BUILDING'),
	('AOE_REQUIRES_GENERAL_GUARD',									'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('AOE_REQUIRES_SPY_PIONEER',									'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
	('AOE_REQUIRES_SPY_PATHFINDER',									'REQUIREMENT_PLOT_ADJACENT_TO_OWNER');
insert or ignore into RequirementArguments
	(RequirementId,													Name,					Value)
values
	('REQUIRES_CITY_HAS_BUILDING_LIGHTHOUSE_BASIC',					'BuildingType',			'BUILDING_LIGHTHOUSE'),
	('REQUIRES_CITY_HAS_BUILDING_SHIPYARD_BASIC',					'BuildingType',			'BUILDING_SHIPYARD'),
	('AOE_REQUIRES_GENERAL_GUARD',									'MinRange',				0),
	('AOE_REQUIRES_GENERAL_GUARD',									'MaxRange',				1),
	('AOE_REQUIRES_SPY_PIONEER',									'MinDistance',			0),
	('AOE_REQUIRES_SPY_PIONEER',									'MaxDistance',			6),
	('AOE_REQUIRES_SPY_PATHFINDER',									'MinDistance',			0),
	('AOE_REQUIRES_SPY_PATHFINDER',									'MaxDistance',			6);
insert or ignore into RequirementSets
	(RequirementSetId,												RequirementSetType)
values
	('HD_CITY_HAS_HARBOR_TIER_1_BUILDING_REQUIREMENTS_BASIC',		'REQUIREMENTSET_TEST_ALL'),
	('HD_CITY_HAS_HARBOR_TIER_2_BUILDING_REQUIREMENTS_BASIC',		'REQUIREMENTSET_TEST_ALL'),
	('HD_AOE_REQUIRES_GENERAL_GUARD',								'REQUIREMENTSET_TEST_ALL'),
	('HD_AOE_REQUIRES_SPY_PIONEER',									'REQUIREMENTSET_TEST_ALL'),
	('HD_AOE_REQUIRES_SPY_PATHFINDER',								'REQUIREMENTSET_TEST_ALL');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
values
	('HD_CITY_HAS_HARBOR_TIER_1_BUILDING_REQUIREMENTS_BASIC',		'REQUIRES_CITY_HAS_BUILDING_LIGHTHOUSE_BASIC'),
	('HD_CITY_HAS_HARBOR_TIER_2_BUILDING_REQUIREMENTS_BASIC',		'REQUIRES_CITY_HAS_BUILDING_SHIPYARD_BASIC'),
	('HD_AOE_REQUIRES_GENERAL_GUARD',								'AOE_REQUIRES_GENERAL_GUARD'),
	('HD_AOE_REQUIRES_SPY_PIONEER',									'AOE_REQUIRES_SPY_PIONEER'),
	('HD_AOE_REQUIRES_SPY_PATHFINDER',								'AOE_REQUIRES_SPY_PATHFINDER');

-- Great Bath:	Update "plot adjacent to river"	to "plot adjacent to river	or player has Great Bath"
-- 				Update "plot is fresh water"	to "plot is fresh water 	or player has Great Bath"

-- insert or ignore into RequirementArguments
-- 	(RequirementId,		Name,				Value)
-- select
-- 	RequirementId,		'RequirementSetId',	'PLOT_ADJACENT_TO_RIVER_REQUIREMENTS_RAW'
-- from Requirements where RequirementType = 'REQUIREMENT_PLOT_ADJACENT_TO_RIVER';
-- insert or ignore into RequirementArguments
-- 	(RequirementId,		Name,				Value)
-- select
-- 	RequirementId,		'RequirementSetId',	'PLOT_IS_FRESH_WATER_REQUIREMENTS_RAW'
-- from Requirements where RequirementType = 'REQUIREMENT_PLOT_IS_FRESH_WATER';
-- update Requirements set RequirementType = 'REQUIREMENT_REQUIREMENTSET_IS_MET'
-- 	where RequirementType = 'REQUIREMENT_PLOT_ADJACENT_TO_RIVER' or RequirementType = 'REQUIREMENT_PLOT_IS_FRESH_WATER';
-- insert or ignore into Requirements
-- 	(RequirementId,								RequirementType)
-- values
-- 	('REQUIRES_PLOT_ADJACENT_TO_RIVER_RAW',		'REQUIREMENT_PLOT_ADJACENT_TO_RIVER'),
-- 	('REQUIRES_PLOT_IS_FRESH_WATER_RAW',		'REQUIREMENT_PLOT_IS_FRESH_WATER');
-- insert or ignore into RequirementSets
-- 	(RequirementSetId,							RequirementSetType)
-- values
-- 	('PLOT_ADJACENT_TO_RIVER_REQUIREMENTS_RAW',	'REQUIREMENTSET_TEST_ANY'),
-- 	('PLOT_IS_FRESH_WATER_REQUIREMENTS_RAW',	'REQUIREMENTSET_TEST_ANY');
-- insert or ignore into RequirementSetRequirements
-- 	(RequirementSetId,							RequirementId)
-- values
-- 	('PLOT_ADJACENT_TO_RIVER_REQUIREMENTS_RAW',	'REQUIRES_PLOT_ADJACENT_TO_RIVER_RAW'),
-- 	('PLOT_ADJACENT_TO_RIVER_REQUIREMENTS_RAW',	'REQUIRES_PLAYER_HAS_BUILDING_GREAT_BATH'),
-- 	('PLOT_IS_FRESH_WATER_REQUIREMENTS_RAW',	'REQUIRES_PLOT_IS_FRESH_WATER_RAW'),
-- 	('PLOT_IS_FRESH_WATER_REQUIREMENTS_RAW',	'REQUIRES_PLAYER_HAS_BUILDING_GREAT_BATH');

-- 区域高相邻Req
update RequirementArguments set Value = 9 where Name = 'Amount' and RequirementId in (
	'REQUIRES_CAMPUS_HAS_HIGH_ADJACENCY',
	'REQUIRES_COMMERCIAL_HUB_HAS_HIGH_ADJACENCY',
	'REQUIRES_HOLY_SITE_HAS_HIGH_ADJACENCY',
	'REQUIRES_THEATER_SQUARE_HAS_HIGH_ADJACENCY'
);
insert or ignore into Requirements
	(RequirementId,										RequirementType)
values
	('REQUIRES_INDUSTRIAL_ZONE_HAS_HIGH_ADJACENCY',		'REQUIREMENT_CITY_HAS_HIGH_ADJACENCY_DISTRICT'),
	('REQUIRES_HARBOR_HAS_HIGH_ADJACENCY',				'REQUIREMENT_CITY_HAS_HIGH_ADJACENCY_DISTRICT'),
	('REQUIRES_ENCAMPMENT_HAS_HIGH_ADJACENCY',			'REQUIREMENT_CITY_HAS_HIGH_ADJACENCY_DISTRICT'),
	('REQUIRES_THEATER_HAS_HIGH_ADJACENCY',				'REQUIREMENT_CITY_HAS_HIGH_ADJACENCY_DISTRICT');

insert or ignore into Requirements
	(RequirementId,										RequirementType)
select
	'REQUIRES_C_AGRICULTURE_HAS_HIGH_ADJACENCY',		'REQUIREMENT_CITY_HAS_HIGH_ADJACENCY_DISTRICT'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');

insert or ignore into RequirementArguments
	(RequirementId,										Name,				Value)
values
	('REQUIRES_INDUSTRIAL_ZONE_HAS_HIGH_ADJACENCY',		'DistrictType',		'DISTRICT_INDUSTRIAL_ZONE'),
	('REQUIRES_HARBOR_HAS_HIGH_ADJACENCY',				'DistrictType',		'DISTRICT_HARBOR'),
	('REQUIRES_ENCAMPMENT_HAS_HIGH_ADJACENCY',			'DistrictType',		'DISTRICT_ENCAMPMENT'),
	('REQUIRES_THEATER_HAS_HIGH_ADJACENCY',				'DistrictType',		'DISTRICT_THEATER'),
	('REQUIRES_INDUSTRIAL_ZONE_HAS_HIGH_ADJACENCY',		'YieldType',		'YIELD_PRODUCTION'),
	('REQUIRES_HARBOR_HAS_HIGH_ADJACENCY',				'YieldType',		'YIELD_GOLD'),
	('REQUIRES_ENCAMPMENT_HAS_HIGH_ADJACENCY',			'YieldType',		'YIELD_PRODUCTION'),
	('REQUIRES_THEATER_HAS_HIGH_ADJACENCY',				'YieldType',		'YIELD_CULTURE'),
	('REQUIRES_INDUSTRIAL_ZONE_HAS_HIGH_ADJACENCY',		'Amount',			9),
	('REQUIRES_HARBOR_HAS_HIGH_ADJACENCY',				'Amount',			9),
	('REQUIRES_ENCAMPMENT_HAS_HIGH_ADJACENCY',			'Amount',			9),
	('REQUIRES_THEATER_HAS_HIGH_ADJACENCY',				'Amount',			9);

insert or ignore into RequirementArguments
	(RequirementId,										Name,				Value)
select 
	'REQUIRES_C_AGRICULTURE_HAS_HIGH_ADJACENCY',		'DistrictType',		'DISTRICT_C_AGRICULTURE'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');
insert or ignore into RequirementArguments
	(RequirementId,										Name,				Value)
select 
	'REQUIRES_C_AGRICULTURE_HAS_HIGH_ADJACENCY',		'Amount',			9
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');
insert or ignore into RequirementArguments
	(RequirementId,										Name,				Value)
select 
	'REQUIRES_C_AGRICULTURE_HAS_HIGH_ADJACENCY',		'YieldType',			'YIELD_FOOD'
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_C_AGRICULTURE');

insert or ignore into RequirementSets
	(RequirementSetId,									RequirementSetType)
values
	('INDUSTRIAL_ZONE_HAS_HIGH_ADJACENCY',				'REQUIREMENTSET_TEST_ALL'),
	('HARBOR_HAS_HIGH_ADJACENCY',						'REQUIREMENTSET_TEST_ALL'),
	('ENCAMPMENT_HAS_HIGH_ADJACENCY',					'REQUIREMENTSET_TEST_ALL'),
	('THEATER_HAS_HIGH_ADJACENCY',						'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,									RequirementId)
values
	('INDUSTRIAL_ZONE_HAS_HIGH_ADJACENCY',				'REQUIRES_INDUSTRIAL_ZONE_HAS_HIGH_ADJACENCY'),
	('HARBOR_HAS_HIGH_ADJACENCY',						'REQUIRES_HARBOR_HAS_HIGH_ADJACENCY'),
	('ENCAMPMENT_HAS_HIGH_ADJACENCY',					'REQUIRES_ENCAMPMENT_HAS_HIGH_ADJACENCY'),
	('THEATER_HAS_HIGH_ADJACENCY',						'REQUIRES_THEATER_HAS_HIGH_ADJACENCY');

insert or ignore into RequirementSets
	(RequirementSetId,												RequirementSetType)
select
	'DISTRICT_IS_' || DistrictType || '_AND_HAS_HIGH_ADJACENCY',	'REQUIREMENTSET_TEST_ALL'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;
insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
	'DISTRICT_IS_' || DistrictType || '_AND_HAS_HIGH_ADJACENCY',	'REQUIRES_' || substr(DistrictType, 10) || '_HAS_HIGH_ADJACENCY'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;
insert or ignore into RequirementSetRequirements
	(RequirementSetId,												RequirementId)
select
	'DISTRICT_IS_' || DistrictType || '_AND_HAS_HIGH_ADJACENCY',	'REQUIRES_DISTRICT_IS_' || DistrictType || '_HD'
from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 相邻至少+5
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_' || DistrictType ||'_HAS_5_ADJACENCY', 'REQUIREMENT_CITY_HAS_HIGH_ADJACENCY_DISTRICT'
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_' || DistrictType ||'_HAS_5_ADJACENCY', 'DistrictType', DistrictType
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_' || DistrictType ||'_HAS_5_ADJACENCY', 'Amount', 5
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_' || DistrictType ||'_HAS_5_ADJACENCY', 'YieldType', YieldType
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_CITY_' || DistrictType ||'_HAS_5_ADJACENCY_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_CITY_' || DistrictType ||'_HAS_5_ADJACENCY_REQUIREMENTS', 'REQUIRES_' || DistrictType ||'_HAS_5_ADJACENCY'
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 因地制宜Req HD_ADAPTATION_TO_LOCAL_REQUIREMENTS
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_ADAPTATION_TO_LOCAL_REQUIREMENTS', 'REQUIRES_' || substr(DistrictType, 10) || '_HAS_HIGH_ADJACENCY'
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 相邻至少+6
insert or ignore into Requirements (RequirementId, RequirementType)
	select 'REQUIRES_' || DistrictType ||'_HAS_6_ADJACENCY', 'REQUIREMENT_CITY_HAS_HIGH_ADJACENCY_DISTRICT'
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_' || DistrictType ||'_HAS_6_ADJACENCY', 'DistrictType', DistrictType
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_' || DistrictType ||'_HAS_6_ADJACENCY', 'Amount', 6
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementArguments (RequirementId, Name, Value)
	select 'REQUIRES_' || DistrictType ||'_HAS_6_ADJACENCY', 'YieldType', YieldType
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementSets (RequirementSetId, RequirementSetType)
	select 'HD_CITY_' || DistrictType ||'_HAS_6_ADJACENCY_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL'
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
	select 'HD_CITY_' || DistrictType ||'_HAS_6_ADJACENCY_REQUIREMENTS', 'REQUIRES_' || DistrictType ||'_HAS_6_ADJACENCY'
	from DistrictCorrespondingYieldType_HD where HasAdjacency = 1;

-- 相邻的区域Req
insert or ignore into RequirementSets
	(RequirementSetId,                                  RequirementSetType)
select
	'HD_DISTRICT_IS_' || DistrictType || '_ADJACENT',   'REQUIREMENTSET_TEST_ALL'
from Districts;

insert or ignore into RequirementSetRequirements
	(RequirementSetId,                                  RequirementId)
select
	'HD_DISTRICT_IS_' || DistrictType || '_ADJACENT',   'ADJACENT_TO_OWNER'
from Districts;

insert or ignore into RequirementSetRequirements
	(RequirementSetId,                                  RequirementId)
select
	'HD_DISTRICT_IS_' || DistrictType || '_ADJACENT',   'REQUIRES_DISTRICT_IS_' || DistrictType || '_HD'
from Districts;

-- 一环内的区域Req
insert or ignore into RequirementSets
	(RequirementSetId,                                  			RequirementSetType)
select
	'HD_DISTRICT_IS_' || DistrictType || '_WITHIN_1_TILE',   	'REQUIREMENTSET_TEST_ALL'
from Districts;

insert or ignore into RequirementSetRequirements
	(RequirementSetId,                                  			RequirementId)
select
	'HD_DISTRICT_IS_' || DistrictType || '_WITHIN_1_TILE',   	'REQUIRES_OBJECT_WITHIN_1_TILE'
from Districts;

insert or ignore into RequirementSetRequirements
	(RequirementSetId,                                  RequirementId)
select
	'HD_DISTRICT_IS_' || DistrictType || '_WITHIN_1_TILE',   'REQUIRES_DISTRICT_IS_' || DistrictType || '_HD'
from Districts;

-- Ayutthaya & Nan Madol bug fix
insert or ignore into RequirementSets
	(RequirementSetId, 							RequirementSetType)
values
	('PLOT_HAS_COMPLETE_WONDER',				'REQUIREMENTSET_TEST_ANY'),
	('HD_DRY_STONE_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('PLOT_DOES_NOT_HAVE_INCOMPLETE_WONDER',	'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_WONDER',							'REQUIREMENTSET_TEST_ANY');
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'PLOT_HAS_COMPLETE_WONDER',	'PLOT_HAS_' || BuildingType from Buildings where IsWonder = 1;

insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'HD_DRY_STONE_REQUIREMENTS',	'PLOT_HAS_' || BuildingType from Buildings where IsWonder = 1
and PrereqTech in (select TechnologyType from Technologies where EraType in ('ERA_ANCIENT', 'ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE'));
insert or ignore into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'HD_DRY_STONE_REQUIREMENTS',	'PLOT_HAS_' || BuildingType from Buildings where IsWonder = 1
and PrereqCivic in (select CivicType from Civics where EraType in ('ERA_ANCIENT', 'ERA_CLASSICAL', 'ERA_MEDIEVAL', 'ERA_RENAISSANCE'));

insert or ignore into RequirementSetRequirements
	(RequirementSetId, 							RequirementId)
values
	('PLOT_HAS_WONDER',							'REQUIRES_PLOT_HAS_WONDER'),
	('PLOT_DOES_NOT_HAVE_INCOMPLETE_WONDER',	'REQUIRES_PLOT_DOES_NOT_HAVE_WONDER'),
	('PLOT_DOES_NOT_HAVE_INCOMPLETE_WONDER',	'REQUIRES_PLOT_HAS_COMPLETE_WONDER');
insert or ignore into Requirements
	(RequirementId,										RequirementType,									Inverse)
values
	('REQUIRES_PLOT_DOES_NOT_HAVE_INCOMPLETE_WONDER',	'REQUIREMENT_REQUIREMENTSET_IS_MET',				0),
	('REQUIRES_PLOT_DOES_NOT_HAVE_WONDER',				'REQUIREMENT_REQUIREMENTSET_IS_MET',				1),
	('REQUIRES_PLOT_HAS_COMPLETE_WONDER',				'REQUIREMENT_REQUIREMENTSET_IS_MET',				0),
	('REQUIRES_PLOT_HAS_WONDER',						'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES',	0);
insert or ignore into RequirementArguments
	(RequirementId,										Name,				Value)
values
	('REQUIRES_PLOT_DOES_NOT_HAVE_INCOMPLETE_WONDER',	'RequirementSetId',	'PLOT_DOES_NOT_HAVE_INCOMPLETE_WONDER'),
	('REQUIRES_PLOT_DOES_NOT_HAVE_WONDER',				'RequirementSetId',	'PLOT_HAS_WONDER'),
	('REQUIRES_PLOT_HAS_COMPLETE_WONDER',				'RequirementSetId',	'PLOT_HAS_COMPLETE_WONDER'),
	('REQUIRES_PLOT_HAS_WONDER',						'DistrictType',		'DISTRICT_WONDER'),
	('REQUIRES_PLOT_HAS_WONDER',						'MinRange',			'0'),
	('REQUIRES_PLOT_HAS_WONDER',						'MaxRange',			'0');

insert or ignore into RequirementSets
	(RequirementSetId,										RequirementSetType)
values
--沿湖
	('ADJACENT_TO_LAKE_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL'),
--沿湖和湖
	('ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY'),
	('DISTRICT_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('WONDER_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
--圣瓦西里主教座堂
	('ST_BASILS_CATHEDRAL_YIELD_IMPROVEMENT_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
--伦敦塔桥
	('HD_IS_RIVER_OR_ON_OR_ADJACENT_TO_COAST',							'REQUIREMENTSET_TEST_ANY');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,										RequirementId)
values
--沿湖
	('ADJACENT_TO_LAKE_REQUIREMENTS',						'REQUIRES_PLOT_ADJACENT_TO_LAKE'),
--沿湖和湖
	('ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS',				'REQUIRES_PLOT_ADJACENT_TO_LAKE'),
	('ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS',				'REQUIRES_PLOT_IS_LAKE'),
	('DISTRICT_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS',				'REQUIRES_ADJACENT_TO_LAKE_OR_LAKE'),
	('DISTRICT_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS',				'HD_REQUIRES_DISTRICT_IS_NOT_DISTRICT_WONDER'),
	('WONDER_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS',				'REQUIRES_ADJACENT_TO_LAKE_OR_LAKE'),
	('WONDER_ADJACENT_TO_LAKE_OR_LAKE_REQUIREMENTS',				'REQUIRES_PLOT_HAS_COMPLETE_WONDER'),
--圣瓦西里主教座堂
	('ST_BASILS_CATHEDRAL_YIELD_IMPROVEMENT_REQUIREMENTS',		'REQUIRES_PLOT_HAS_ANYTUNDRA'),
	('ST_BASILS_CATHEDRAL_YIELD_IMPROVEMENT_REQUIREMENTS',		'REQUIRES_PLOT_IS_IMPROVED'),
--伦敦塔桥
	('HD_IS_RIVER_OR_ON_OR_ADJACENT_TO_COAST',							'REQUIRES_PLOT_IS_COAST'),
	('HD_IS_RIVER_OR_ON_OR_ADJACENT_TO_COAST',							'REQUIRES_PLOT_IS_ADJACENT_TO_COAST'),
	('HD_IS_RIVER_OR_ON_OR_ADJACENT_TO_COAST',							'REQUIRES_PLOT_ADJACENT_TO_RIVER');
insert or ignore into Requirements
	(RequirementId,											RequirementType)
values
	('REQUIRES_PLOT_HAS_ANYTUNDRA',							'REQUIREMENT_REQUIREMENTSET_IS_MET');
insert or ignore into RequirementArguments
	(RequirementId,											Name,				value)
values
	('REQUIRES_PLOT_HAS_ANYTUNDRA',							'RequirementSetId',	'PLOT_HAS_ANYTUNDRA_REQUIREMENTS');
--御岳
/*
insert or ignore into RequirementSets
	(RequirementSetId,										RequirementSetType)
values
	('PLOT_HAS_SHALLOW_WATER_AND_ADJACENT_TO_HARBOR',		'REQUIREMENTSET_TEST_ALL');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,										RequirementId)
values
	('PLOT_HAS_SHALLOW_WATER_AND_ADJACENT_TO_HARBOR',		'REQUIRES_PLOT_HAS_SHALLOW_WATER'),
	('PLOT_HAS_SHALLOW_WATER_AND_ADJACENT_TO_HARBOR',		'REQUIRES_PLOT_ADJACENT_TO_HARBOR');
insert or ignore into Requirements
	(RequirementId,											RequirementType)
values
	('REQUIRES_PLOT_ADJACENT_TO_HARBOR',					'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES');
insert or ignore into RequirementArguments
	(RequirementId,											Name,				Value)
values
	('REQUIRES_PLOT_ADJACENT_TO_HARBOR',					'DistrictType',		'DISTRICT_HARBOR');
*/
--挪威NORWAY_EXTRA_MOVEMENT_REQUIREMENTS
--Maori
--安善PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN
insert or ignore into RequirementSets
	(RequirementSetId,										RequirementSetType)
values
	('NORWAY_EXTRA_MOVEMENT_REQUIREMENTS',					'REQUIREMENTSET_TEST_ANY'),
	('PLOT_HAS_WOODS_TECH_ASTROLOGY_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
--	('PLOT_HAS_SWAMP_TECH_ASTROLOGY_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_RAINFOREST_TECH_ASTROLOGY_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
	('PLOT_HAS_MARSH_TECH_ASTROLOGY_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
	('PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN_AND_CAMPUS',	'REQUIREMENTSET_TEST_ALL'),
	('ZHANGHAN_REQUIREMENTS',								'REQUIREMENTSET_TEST_ANY');
insert or ignore into RequirementSets
	(RequirementSetId,										RequirementSetType)
select
	'PLOT_HAS_SWAMP_TECH_ASTROLOGY_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,										RequirementId)
values
	('NORWAY_EXTRA_MOVEMENT_REQUIREMENTS',					'REQUIRES_UNIT_IS_UNIT_GALLEY'),
	('NORWAY_EXTRA_MOVEMENT_REQUIREMENTS',					'REQUIRES_UNIT_IS_UNIT_NORWEGIAN_LONGSHIP'),
	('NORWAY_EXTRA_MOVEMENT_REQUIREMENTS',					'REQUIRES_UNIT_IS_UNIT_HD_BARBARIAN_QUADRIREME'),
	('NORWAY_EXTRA_MOVEMENT_REQUIREMENTS',					'REQUIRES_UNIT_IS_UNIT_QUADRIREME'),
	('NORWAY_EXTRA_MOVEMENT_REQUIREMENTS',					'REQUIRES_UNIT_IS_UNIT_ANCIENT_SEADOG'),
	('NORWAY_EXTRA_MOVEMENT_REQUIREMENTS',					'REQUIRES_UNIT_IS_UNIT_HD_BARBARIAN_GALLEY'),
	('PLOT_HAS_WOODS_TECH_ASTROLOGY_REQUIREMENTS',			'HD_REQUIRES_PLOT_HAS_FEATURE_FOREST'),
	('PLOT_HAS_WOODS_TECH_ASTROLOGY_REQUIREMENTS',			'HD_REQUIRES_PLAYER_HAS_TECH_ASTROLOGY'),
--	('PLOT_HAS_SWAMP_TECH_ASTROLOGY_REQUIREMENTS',			'HD_REQUIRES_PLOT_HAS_FEATURE_HD_SWAMP'),
--	('PLOT_HAS_SWAMP_TECH_ASTROLOGY_REQUIREMENTS',			'HD_REQUIRES_PLAYER_HAS_TECH_ASTROLOGY'),
	('PLOT_HAS_RAINFOREST_TECH_ASTROLOGY_REQUIREMENTS',		'HD_REQUIRES_PLOT_HAS_FEATURE_JUNGLE'),
	('PLOT_HAS_RAINFOREST_TECH_ASTROLOGY_REQUIREMENTS',		'HD_REQUIRES_PLAYER_HAS_TECH_ASTROLOGY'),
	('PLOT_HAS_MARSH_TECH_ASTROLOGY_REQUIREMENTS',			'HD_REQUIRES_PLOT_HAS_FEATURE_MARSH'),
	('PLOT_HAS_MARSH_TECH_ASTROLOGY_REQUIREMENTS',			'HD_REQUIRES_PLAYER_HAS_TECH_ASTROLOGY'),
	('PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN_AND_CAMPUS',	'REQUIRES_DISTRICT_IS_CAMPUS'),
	('PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN_AND_CAMPUS',	'PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN_MET'),
	('ZHANGHAN_REQUIREMENTS',								'OPPONENT_IS_FREE_CITY_REQUIREMENT');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,										RequirementId)
select
	'PLOT_HAS_SWAMP_TECH_ASTROLOGY_REQUIREMENTS',			'HD_REQUIRES_PLOT_HAS_FEATURE_HD_SWAMP'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,										RequirementId)
select
	'PLOT_HAS_SWAMP_TECH_ASTROLOGY_REQUIREMENTS',			'HD_REQUIRES_PLAYER_HAS_TECH_ASTROLOGY'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_HD_SWAMP');
insert or ignore into Requirements
	(RequirementId,											RequirementType)
values
	('PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN_MET',			'REQUIREMENT_REQUIREMENTSET_IS_MET');
insert or ignore into RequirementArguments
	(RequirementId,											Name,					Value)
values
	('PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN_MET',			'RequirementSetId',		'PLOT_IS_HILLS_OR_ADJACENT_TO_MOUNTAIN');

insert or ignore into RequirementSets
	(RequirementSetId,										RequirementSetType)
values
	('HD_UNIT_IS_NAVAL',									'REQUIREMENTSET_TEST_ANY');

insert or ignore into RequirementSetRequirements
	(RequirementSetId,								RequirementId)
select
	'HD_UNIT_IS_NAVAL',								'REQUIRES_UNIT_IS_' || UnitType
from Units where Domain = 'DOMAIN_SEA';

--武印度 男玛雅
insert or ignore into RequirementSets
	(RequirementSetId,										RequirementSetType)
values
	('PLAYER_HAS_GOVERNMENTS_TIER_1',						'REQUIREMENTSET_TEST_ANY'),
	('PLAYER_HAS_GOVERNMENTS_TIER_2',						'REQUIREMENTSET_TEST_ANY'),
	('PLAYER_HAS_GOVERNMENTS_TIER_3',						'REQUIREMENTSET_TEST_ANY'),
	('PLAYER_HAS_GOVERNMENTS_TIER_4',						'REQUIREMENTSET_TEST_ANY'),
	('REQUIRES_PLOT_HAS_BONUS_AND_ADJACENT_TO_OWNER',		'REQUIREMENTSET_TEST_ALL'),
	('REQUIRES_PLOT_HAS_LUXURY_AND_ADJACENT_TO_OWNER',		'REQUIREMENTSET_TEST_ALL');
insert or ignore into RequirementSetRequirements
	(RequirementSetId,										RequirementId)
values
	('PLAYER_HAS_GOVERNMENTS_TIER_1',						'REQUIRES_PLAYER_HAS_CIVIC_POLITICAL_PHILOSOPHY'),
	('PLAYER_HAS_GOVERNMENTS_TIER_2',						'REQUIRES_PLAYER_HAS_CIVIC_CIVIL_SERVICE'),
	('PLAYER_HAS_GOVERNMENTS_TIER_2',						'REQUIRES_PLAYER_HAS_CIVIC_REFORMED_CHURCH'),
	('PLAYER_HAS_GOVERNMENTS_TIER_2',						'REQUIRES_PLAYER_HAS_CIVIC_EXPLORATION'),
	('PLAYER_HAS_GOVERNMENTS_TIER_3',						'REQUIRES_PLAYER_HAS_CIVIC_CLASS_STRUGGLE'),
	('PLAYER_HAS_GOVERNMENTS_TIER_3',						'REQUIRES_PLAYER_HAS_CIVIC_TOTALITARIANISM'),
	('PLAYER_HAS_GOVERNMENTS_TIER_3',						'REQUIRES_PLAYER_HAS_CIVIC_SUFFRAGE'),
	('PLAYER_HAS_GOVERNMENTS_TIER_4',						'REQUIRES_PLAYER_HAS_CIVIC_DIGITAL_DEMOCRACY'),
	('PLAYER_HAS_GOVERNMENTS_TIER_4',						'REQUIRES_PLAYER_HAS_CIVIC_SYNTHETIC_TECHNOCRACY'),
	('PLAYER_HAS_GOVERNMENTS_TIER_4',						'REQUIRES_PLAYER_HAS_CIVIC_CORPORATE_LIBERTARIANISM'),
	('REQUIRES_PLOT_HAS_BONUS_AND_ADJACENT_TO_OWNER',		'REQUIRES_PLOT_HAS_BONUS'),
	('REQUIRES_PLOT_HAS_BONUS_AND_ADJACENT_TO_OWNER',		'ADJACENT_TO_OWNER'),
	('REQUIRES_PLOT_HAS_LUXURY_AND_ADJACENT_TO_OWNER',		'REQUIRES_PLOT_HAS_LUXURY'),
	('REQUIRES_PLOT_HAS_LUXURY_AND_ADJACENT_TO_OWNER',		'ADJACENT_TO_OWNER');

insert or ignore into RequirementSets
	(RequirementSetId, 							            RequirementSetType)
values
	('HD_SCIENTIFIC_SUZERAIN_1_REQUIREMENTS',               'REQUIREMENTSET_TEST_ALL'),
	('HD_CULTURAL_SUZERAIN_1_REQUIREMENTS',                 'REQUIREMENTSET_TEST_ALL'),
	('HD_TRADE_SUZERAIN_1_REQUIREMENTS',                    'REQUIREMENTSET_TEST_ALL'),
	('HD_RELIGIOUS_SUZERAIN_1_REQUIREMENTS',                'REQUIREMENTSET_TEST_ALL'),
	('HD_MILITARISTIC_SUZERAIN_1_REQUIREMENTS',             'REQUIREMENTSET_TEST_ALL'),
	('HD_INDUSTRIAL_SUZERAIN_1_REQUIREMENTS',               'REQUIREMENTSET_TEST_ALL'),
	
	('HD_SCIENTIFIC_SUZERAIN_2_REQUIREMENTS',               'REQUIREMENTSET_TEST_ALL'),
	('HD_CULTURAL_SUZERAIN_2_REQUIREMENTS',                 'REQUIREMENTSET_TEST_ALL'),
	('HD_TRADE_SUZERAIN_2_REQUIREMENTS',                    'REQUIREMENTSET_TEST_ALL'),
	('HD_RELIGIOUS_SUZERAIN_2_REQUIREMENTS',                'REQUIREMENTSET_TEST_ALL'),
	('HD_MILITARISTIC_SUZERAIN_2_REQUIREMENTS',             'REQUIREMENTSET_TEST_ALL'),
	('HD_INDUSTRIAL_SUZERAIN_2_REQUIREMENTS',               'REQUIREMENTSET_TEST_ALL'),
	
	('PLAYER_HAS_BUILDING_RCC_OR_WPH_REQUIREMENTS',         'REQUIREMENTSET_TEST_ANY'),
	('CITY_HAS_BUILDING_RCC_OR_WPH_REQUIREMENTS',           'REQUIREMENTSET_TEST_ANY'),

	('ROUTE_BETWEEN_ALLIES_REQUIREMENTS_RCC',		        'REQUIREMENTSET_TEST_ALL'),
	('ALLIES_AT_WAR_WITH_TARGET_REQUIREMENTS_RCC',	        'REQUIREMENTSET_TEST_ALL'),
	('RELIGIOUS_COMBAT_ENEMY_NOT_IN_ALLIED_RELIGION_RCC',	'REQUIREMENTSET_TEST_ALL'),
	('ALLIANCE_CITY_HAS_TRADE_ROUTE_WITH_ALLY_RCC',	        'REQUIREMENTSET_TEST_ALL');

insert or ignore into RequirementSetRequirements
	(RequirementSetId, 							            RequirementId)
values
	('HD_SCIENTIFIC_SUZERAIN_1_REQUIREMENTS',               'HD_SCIENTIFIC_SUZERAIN_1_LEADER'),
	('HD_CULTURAL_SUZERAIN_1_REQUIREMENTS',                 'HD_CULTURAL_SUZERAIN_1_LEADER'),
	('HD_TRADE_SUZERAIN_1_REQUIREMENTS',                    'HD_TRADE_SUZERAIN_1_LEADER'),
	('HD_RELIGIOUS_SUZERAIN_1_REQUIREMENTS',                'HD_RELIGIOUS_SUZERAIN_1_LEADER'),
	('HD_MILITARISTIC_SUZERAIN_1_REQUIREMENTS',             'HD_MILITARISTIC_SUZERAIN_1_LEADER'),
	('HD_INDUSTRIAL_SUZERAIN_1_REQUIREMENTS',               'HD_INDUSTRIAL_SUZERAIN_1_LEADER'),

	('HD_SCIENTIFIC_SUZERAIN_2_REQUIREMENTS',               'HD_SCIENTIFIC_SUZERAIN_2_LEADER'),
	('HD_CULTURAL_SUZERAIN_2_REQUIREMENTS',                 'HD_CULTURAL_SUZERAIN_2_LEADER'),
	('HD_TRADE_SUZERAIN_2_REQUIREMENTS',                    'HD_TRADE_SUZERAIN_2_LEADER'),
	('HD_RELIGIOUS_SUZERAIN_2_REQUIREMENTS',                'HD_RELIGIOUS_SUZERAIN_2_LEADER'),
	('HD_MILITARISTIC_SUZERAIN_2_REQUIREMENTS',             'HD_MILITARISTIC_SUZERAIN_2_LEADER'),
	('HD_INDUSTRIAL_SUZERAIN_2_REQUIREMENTS',               'HD_INDUSTRIAL_SUZERAIN_2_LEADER'),

	('PLAYER_HAS_BUILDING_RCC_OR_WPH_REQUIREMENTS',         'REQUIRES_PLAYER_HAS_BUILDING_HD_REGIONAL_COUNCIL_CENTER'),
	('PLAYER_HAS_BUILDING_RCC_OR_WPH_REQUIREMENTS',         'REQUIRES_PLAYER_HAS_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS'),
	('CITY_HAS_BUILDING_RCC_OR_WPH_REQUIREMENTS',           'REQUIRES_CITY_HAS_BUILDING_HD_REGIONAL_COUNCIL_CENTER'),
	('CITY_HAS_BUILDING_RCC_OR_WPH_REQUIREMENTS',           'REQUIRES_CITY_HAS_BUILDING_HD_WORLD_PARLIAMENT_HEADQUARTERS'),

	('ROUTE_BETWEEN_ALLIES_REQUIREMENTS_RCC',		        'REQUIRES_TRADE_ROUTE_BETWEEN_ALLIES'),
	('ROUTE_BETWEEN_ALLIES_REQUIREMENTS_RCC',		        'REQUIRES_PLAYER_HAS_BUILDING_RCC_OR_WPH'),
	('ALLIES_AT_WAR_WITH_TARGET_REQUIREMENTS_RCC',	        'REQUIRES_ALLIES_AT_WAR_WITH_TARGET'),
	('ALLIES_AT_WAR_WITH_TARGET_REQUIREMENTS_RCC',	        'REQUIRES_COMBAT_UNIT_VS_UNIT'),
	('ALLIES_AT_WAR_WITH_TARGET_REQUIREMENTS_RCC',	        'REQUIRES_PLAYER_HAS_BUILDING_RCC_OR_WPH'),
	('RELIGIOUS_COMBAT_ENEMY_NOT_IN_ALLIED_RELIGION_RCC',	'REQUIRES_RELIGIOUS_ENEMY_NOT_ALLIED_RELIGION'),
	('RELIGIOUS_COMBAT_ENEMY_NOT_IN_ALLIED_RELIGION_RCC',	'REQUIRES_PLAYER_HAS_BUILDING_RCC_OR_WPH'),
	('ALLIANCE_CITY_HAS_TRADE_ROUTE_WITH_ALLY_RCC',     	'REQUIRES_ALLIANCE_CITY_HAS_TRADE_ROUTE_WITH_ALLY'),
	('ALLIANCE_CITY_HAS_TRADE_ROUTE_WITH_ALLY_RCC',     	'REQUIRES_PLAYER_HAS_BUILDING_RCC_OR_WPH');


insert or ignore into Requirements
	(RequirementId,								RequirementType)
values
	('HD_SCIENTIFIC_SUZERAIN_1_LEADER',         'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_CULTURAL_SUZERAIN_1_LEADER',           'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_TRADE_SUZERAIN_1_LEADER',              'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_RELIGIOUS_SUZERAIN_1_LEADER',          'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_MILITARISTIC_SUZERAIN_1_LEADER',       'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_INDUSTRIAL_SUZERAIN_1_LEADER',         'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),

	('HD_SCIENTIFIC_SUZERAIN_2_LEADER',         'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_CULTURAL_SUZERAIN_2_LEADER',           'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_TRADE_SUZERAIN_2_LEADER',              'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_RELIGIOUS_SUZERAIN_2_LEADER',          'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_MILITARISTIC_SUZERAIN_2_LEADER',       'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),
	('HD_INDUSTRIAL_SUZERAIN_2_LEADER',         'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'),

	('REQUIRES_PLAYER_HAS_BUILDING_RCC_OR_WPH',	'REQUIREMENT_REQUIREMENTSET_IS_MET');


insert or ignore into RequirementArguments
	(RequirementId,								Name,				Value)
values
	('HD_SCIENTIFIC_SUZERAIN_1_LEADER',         'Amount',           1),
	('HD_CULTURAL_SUZERAIN_1_LEADER',           'Amount',           1),
	('HD_TRADE_SUZERAIN_1_LEADER',              'Amount',           1),
	('HD_RELIGIOUS_SUZERAIN_1_LEADER',          'Amount',           1),
	('HD_MILITARISTIC_SUZERAIN_1_LEADER',       'Amount',           1),
	('HD_INDUSTRIAL_SUZERAIN_1_LEADER',         'Amount',           1),
	('HD_SCIENTIFIC_SUZERAIN_1_LEADER',         'LeaderType',       'LEADER_MINOR_CIV_SCIENTIFIC'),
	('HD_CULTURAL_SUZERAIN_1_LEADER',           'LeaderType',       'LEADER_MINOR_CIV_CULTURAL'),
	('HD_TRADE_SUZERAIN_1_LEADER',              'LeaderType',       'LEADER_MINOR_CIV_TRADE'),
	('HD_RELIGIOUS_SUZERAIN_1_LEADER',          'LeaderType',       'LEADER_MINOR_CIV_RELIGIOUS'),
	('HD_MILITARISTIC_SUZERAIN_1_LEADER',       'LeaderType',       'LEADER_MINOR_CIV_MILITARISTIC'),
	('HD_INDUSTRIAL_SUZERAIN_1_LEADER',         'LeaderType',       'LEADER_MINOR_CIV_INDUSTRIAL'),

	('HD_SCIENTIFIC_SUZERAIN_2_LEADER',         'Amount',           2),
	('HD_CULTURAL_SUZERAIN_2_LEADER',           'Amount',           2),
	('HD_TRADE_SUZERAIN_2_LEADER',              'Amount',           2),
	('HD_RELIGIOUS_SUZERAIN_2_LEADER',          'Amount',           2),
	('HD_MILITARISTIC_SUZERAIN_2_LEADER',       'Amount',           2),
	('HD_INDUSTRIAL_SUZERAIN_2_LEADER',         'Amount',           2),
	('HD_SCIENTIFIC_SUZERAIN_2_LEADER',         'LeaderType',       'LEADER_MINOR_CIV_SCIENTIFIC'),
	('HD_CULTURAL_SUZERAIN_2_LEADER',           'LeaderType',       'LEADER_MINOR_CIV_CULTURAL'),
	('HD_TRADE_SUZERAIN_2_LEADER',              'LeaderType',       'LEADER_MINOR_CIV_TRADE'),
	('HD_RELIGIOUS_SUZERAIN_2_LEADER',          'LeaderType',       'LEADER_MINOR_CIV_RELIGIOUS'),
	('HD_MILITARISTIC_SUZERAIN_2_LEADER',       'LeaderType',       'LEADER_MINOR_CIV_MILITARISTIC'),
	('HD_INDUSTRIAL_SUZERAIN_2_LEADER',         'LeaderType',       'LEADER_MINOR_CIV_INDUSTRIAL'),

	('REQUIRES_PLAYER_HAS_BUILDING_RCC_OR_WPH',	'RequirementSetId',	'PLAYER_HAS_BUILDING_RCC_OR_WPH_REQUIREMENTS');

-- 开明专制 相邻市政/外交区的区域
insert or ignore into RequirementSets
	(RequirementSetId, 							            																					RequirementSetType)
select
	'HD_IS_' || a.DistrictType || '_ADJACENT_TO_' || b.DistrictType || '_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'
from DistrictCorrespondingYieldType_HD a, Districts b
	where a.HasAdjacency = 1 and b.DistrictType in ('DISTRICT_GOVERNMENT', 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into RequirementSetRequirements
	(RequirementSetId, 							            																					RequirementId)
select
	'HD_IS_' || a.DistrictType || '_ADJACENT_TO_' || b.DistrictType || '_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_' || a.DistrictType
from DistrictCorrespondingYieldType_HD a, Districts b
	where a.HasAdjacency = 1 and b.DistrictType in ('DISTRICT_GOVERNMENT', 'DISTRICT_DIPLOMATIC_QUARTER');

insert or ignore into RequirementSetRequirements
	(RequirementSetId, 							            																					RequirementId)
select
	'HD_IS_' || a.DistrictType || '_ADJACENT_TO_' || b.DistrictType || '_REQUIREMENTS',		'REQUIRES_PLOT_ADJACENT_TO_' || b.DistrictType
from DistrictCorrespondingYieldType_HD a, Districts b
	where a.HasAdjacency = 1 and b.DistrictType in ('DISTRICT_GOVERNMENT', 'DISTRICT_DIPLOMATIC_QUARTER');