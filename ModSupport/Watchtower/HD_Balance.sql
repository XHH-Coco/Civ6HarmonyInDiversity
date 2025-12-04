update ModifierArguments set Value = 1 where ModifierId = 'SAILOR_WATCHTOWER_MAJOR_SIGHT_MOD' and Name = 'Amount';

-- 补充所有侦察单位可以建造瞭望塔
insert or ignore into Improvement_ValidBuildUnits (ImprovementType, UnitType)
  select 'IMPROVEMENT_SAILOR_WATCHTOWER', UnitType
from Units where PromotionClass = 'PROMOTION_CLASS_RECON' and Domain = 'DOMAIN_LAND';
update Units set BuildCharges = 1 where PromotionClass = 'PROMOTION_CLASS_RECON' and BuildCharges = 0;

insert or ignore into Improvement_ValidFeatures (ImprovementType, FeatureType) values
	('IMPROVEMENT_SAILOR_WATCHTOWER','FEATURE_VOLCANIC_SOIL'),
	('IMPROVEMENT_SAILOR_WATCHTOWER','FEATURE_GEOTHERMAL_FISSURE');