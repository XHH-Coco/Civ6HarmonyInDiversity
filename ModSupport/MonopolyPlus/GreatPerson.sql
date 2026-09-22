delete from GreatPersonIndividualActionModifiers where GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI' or GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE';
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,							ModifierId,										AttachmentTargetType)
values
	('GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI',			'LEU_GREATPERSON_FREE_TYCOON',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI',			'PIERO_DE_BARDI_TYCOON_PRODUCTION',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
	('GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE',				'GREATPERSON_GRANT_FAIR',							'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
	('GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE',		'GREATPERSON_MARKET',							'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE',		'GREATPERSON_BANK',								'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY'),
	('GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE',		'GREATPERSON_STOCK_EXCHANGE',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY');
insert or replace into Modifiers
	(ModifierId,								ModifierType,														RunOnce,	Permanent)
values
	('PIERO_DE_BARDI_TYCOON_PRODUCTION',		'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PRODUCTION',					0,			1),
	('GREATPERSON_STOCK_EXCHANGE',				'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',				1,			1);
insert or replace into ModifierArguments
	(ModifierId,								Name,				Value)
values
	('PIERO_DE_BARDI_TYCOON_PRODUCTION',		'Amount',			50),
	('PIERO_DE_BARDI_TYCOON_PRODUCTION',		'UnitType',			'UNIT_LEU_TYCOON'),
	('GREATPERSON_STOCK_EXCHANGE',				'BuildingType',		'BUILDING_STOCK_EXCHANGE');
insert or replace into GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,							ModifierId,												AttachmentTargetType)
select
	'GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE',		'LEU_ANDREW_CARNEGIE_' || BuildingType || '_GOLD',		'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 4;
insert or replace into Modifiers
	(ModifierId,											ModifierType,													RunOnce,	Permanent)
select
	'LEU_ANDREW_CARNEGIE_' || BuildingType || '_GOLD',		'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',			0,			1
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 4;
insert or replace into ModifierArguments
	(ModifierId,											Name,					Value)
select
	'LEU_ANDREW_CARNEGIE_' || BuildingType || '_GOLD',		'BuildingType',			BuildingType
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 4 union all select
	'LEU_ANDREW_CARNEGIE_' || BuildingType || '_GOLD',		'YieldType',			'YIELD_GOLD'
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 4 union all select
	'LEU_ANDREW_CARNEGIE_' || BuildingType || '_GOLD',		'Amount',				15
from HD_BuildingTiers where PrereqDistrict = 'DISTRICT_COMMERCIAL_HUB' and Tier = 4;
-- Text
insert or replace into ModifierStrings
	(ModifierId,												Context,		Text)
values
	('LEU_GREATPERSON_FREE_TYCOON',								'Summary',		'LOC_LEU_GREATPERSON_FREE_TYCOON'),
	('PIERO_DE_BARDI_TYCOON_PRODUCTION',						'Summary',		'LOC_PIERO_DE_BARDI_TYCOON_PRODUCTION');
update GreatPersonIndividuals set ActionEffectTextOverride = 'LOC_JNR_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_ACTIVE' where
	GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE' and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_JNR_COMMODITY_EXCHANGE');