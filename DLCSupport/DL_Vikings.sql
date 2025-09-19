-------------------------------------
--            Vikings DLC          --
-------------------------------------

-- Natural Wonders
insert or replace into Feature_AdjacentYields
	(FeatureType,				YieldType,				YieldChange)
values
    ('FEATURE_LYSEFJORDEN',		'YIELD_PRODUCTION',		1);
insert or ignore into RequirementSetRequirements
    (RequirementSetId,                                          RequirementId)
values
    ('GODDESS_OF_FIRE_CITY_HAS_VOLCANO',                        'REQUIRES_CITY_HAS_FEATURE_EYJAFJALLAJOKULL');

-- Modifiers in this table are attached to suzerain
create temporary table if not exists TraitAttachedModifiers (
    TraitType text not null,
    ModifierId text not null,
    primary key (TraitType, ModifierId)
);

-- Monastery (Armagh)
update Improvements set OnePerCity = 1 where ImprovementType = 'IMPROVEMENT_MONASTERY';
update Adjacency_YieldChanges set TilesRequired = 1, YieldChange = 2, ObsoleteCivic = 'CIVIC_REFORMED_CHURCH' where ID = 'Monastery_DistrictAdjacency';
insert or replace into Improvement_Adjacencies
    (ImprovementType,               YieldChangeId)
values 
    ('IMPROVEMENT_MONASTERY',       'Monastery_DistrictAdjacency_Divine_Right_Late');
insert or replace into Adjacency_YieldChanges
    (ID,												Description,	YieldType,		YieldChange,	OtherDistrictAdjacent,	PrereqCivic)  
values 
    ('Monastery_DistrictAdjacency_Divine_Right_Late',	'Placeholder',	'YIELD_FAITH',	3,				1,						'CIVIC_REFORMED_CHURCH');

-- Auckland
update Modifiers set SubjectRequirementSetId = 'PLOT_HAS_SHALLOW_WATER_AND_STEAM_POWER_REQUIREMENTS' where ModifierId = 'MINOR_CIV_AUCKLAND_SHALLOW_WATER_PRODUCTION_BONUS_INDUSTRIAL';

-- Muscat
delete from TraitModifiers where TraitType = 'MINOR_CIV_MUSCAT_TRAIT';
insert or replace into TraitAttachedModifiers
    (TraitType,                 ModifierId)
values
    ('MINOR_CIV_MUSCAT_TRAIT',  'MINOR_CIV_MUSCAT_COMMERCIAL'),
    ('MINOR_CIV_MUSCAT_TRAIT',  'MINOR_CIV_MUSCAT_HARBOR');
insert or replace into Modifiers
    (ModifierId,                            	ModifierType,										SubjectRequirementSetId)
values
    ('MINOR_CIV_MUSCAT_COMMERCIAL',      		'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',			'CITY_ON_HOME_CONTINENT_HAS_COMMERCIAL_HUB'),
    ('MINOR_CIV_MUSCAT_HARBOR',    				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',			'CITY_ON_HOME_CONTINENT_HAS_HARBOR'),
    ('MINOR_CIV_MUSCAT_COMMERCIAL_MODIFIER',    'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',	'CITY_IS_CAPITAL_OR_ON_FOREIGN_CONTINENT'),
    ('MINOR_CIV_MUSCAT_HARBOR_MODIFIER',    	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE',	'CITY_IS_CAPITAL_OR_ON_FOREIGN_CONTINENT');
insert or replace into ModifierArguments
    (ModifierId,                            	Name,				Value)
values
	('MINOR_CIV_MUSCAT_COMMERCIAL',	    		'ModifierId',		'MINOR_CIV_MUSCAT_COMMERCIAL_MODIFIER'),
	('MINOR_CIV_MUSCAT_HARBOR',	    			'ModifierId',	    'MINOR_CIV_MUSCAT_HARBOR_MODIFIER'),
	('MINOR_CIV_MUSCAT_COMMERCIAL_MODIFIER',	'YieldType',		'YIELD_GOLD'),
	('MINOR_CIV_MUSCAT_COMMERCIAL_MODIFIER',	'Amount',			3),
	('MINOR_CIV_MUSCAT_HARBOR_MODIFIER',		'YieldType',		'YIELD_PRODUCTION'),
	('MINOR_CIV_MUSCAT_HARBOR_MODIFIER',		'Amount',			1);

-- Mitla
update ModifierArguments set value = 10 where ModifierId = 'MINOR_CIV_PALENQUE_CAMPUS_GROWTH_BONUS' and Name = 'Amount';
insert or replace into TraitAttachedModifiers
    (TraitType,						ModifierId)
values
    ('MINOR_CIV_PALENQUE_TRAIT',	'MINOR_CIV_PALENQUE_CAMPUS_FOOD');
insert or replace into Modifiers
    (ModifierId,                            	ModifierType,										SubjectRequirementSetId)
values
    ('MINOR_CIV_PALENQUE_CAMPUS_FOOD',      	'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',	'DISTRICT_IS_DISTRICT_CAMPUS_REQUIREMENTS');
insert or replace into ModifierArguments
    (ModifierId,                            	Name,				Value)
values
	('MINOR_CIV_PALENQUE_CAMPUS_FOOD',	    	'YieldType',		'YIELD_FOOD'),
	('MINOR_CIV_PALENQUE_CAMPUS_FOOD',	    	'Amount',			1);
insert or replace into TraitAttachedModifiers
    (TraitType,						ModifierId)
select
    'MINOR_CIV_PALENQUE_TRAIT',		'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS';
insert or replace into Modifiers
    (ModifierId,                            			ModifierType)
select
	'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD',	'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS';
insert or replace into ModifierArguments
    (ModifierId,                            			Name,				Value)
select
	'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD',	'BuildingType',		BuildingType
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS' union all select
	'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD',	'YieldType',		'YIELD_FOOD'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS' union all select
	'MINOR_CIV_PALENQUE_' || BuildingType || '_FOOD',	'Amount',			1
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_CAMPUS';

-- Attach modifiers in TraitAttachedModifiers to suzerain
insert or ignore into TraitModifiers
    (TraitType, ModifierId)
select
    TraitType,  ModifierId || '_ATTACH'
from TraitAttachedModifiers;
insert or ignore into Modifiers
    (ModifierId,                ModifierType,                               SubjectRequirementSetId)
select
    ModifierId || '_ATTACH',    'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',     'PLAYER_IS_SUZERAIN'
from TraitAttachedModifiers;
insert or ignore into ModifierArguments
    (ModifierId,                Name,           Value)
select
    ModifierId || '_ATTACH',    'ModifierId',   ModifierId
from TraitAttachedModifiers;
drop table TraitAttachedModifiers;