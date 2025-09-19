--富士山
update ModifierArguments set Value = 2 * Value where ModifierId like 'SUK_FUJI_%' and Name = 'Amount';

--恩戈罗恩戈罗火山口
update Features set Impassable = 1 where FeatureType = 'FEATURE_SUK_NGORONGORO_CRATER';
delete from Feature_YieldChanges where FeatureType = 'FEATURE_SUK_NGORONGORO_CRATER';
delete from RequirementSetRequirements where RequirementSetId = 'SUK_NGORONGORO_CRATER_IS_ADJACENT_CHARMING_UNIMPROVED' and RequirementId = 'REQUIRES_PLOT_CHARMING_APPEAL';
delete from RequirementSetRequirements where RequirementSetId = 'SUK_NGORONGORO_CRATER_IS_ADJACENT_CHARMING_UNIMPROVED' and RequirementId = 'REQUIRES_SUK_NGORONGORO_CRATER_IS_UNIMPROVED';
delete from RequirementSetRequirements where RequirementSetId = 'SUK_NGORONGORO_CRATER_IS_ADJACENT_CHARMING_IMPROVED' and RequirementId = 'REQUIRES_PLOT_CHARMING_APPEAL';
insert or replace into GameModifiers
	(ModifierId)
select
	'SUK_NGORONGORO_CRATER_GOLD_EXTRA'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_SUK_NGORONGORO_CRATER');

insert or replace into Modifiers
	(ModifierId,							ModifierType,						OwnerRequirementSetId,					SubjectRequirementSetId)
select
	'SUK_NGORONGORO_CRATER_GOLD_EXTRA',		'MODIFIER_GAME_ADJUST_PLOT_YIELD',	'SUK_NGORONGORO_CRATER_REQUIREMENTS',	'SUK_NGORONGORO_CRATER_IS_ADJACENT_CHARMING_IMPROVED'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_SUK_NGORONGORO_CRATER');

insert or replace into ModifierArguments
	(ModifierId,							Name,				Value)
select
	'SUK_NGORONGORO_CRATER_GOLD_EXTRA',		'Amount',			1
where exists (select FeatureType from Features where FeatureType = 'FEATURE_SUK_NGORONGORO_CRATER');

insert or replace into ModifierArguments
	(ModifierId,							Name,				Value)
select
	'SUK_NGORONGORO_CRATER_GOLD_EXTRA',		'YieldType',		'YIELD_GOLD'
where exists (select FeatureType from Features where FeatureType = 'FEATURE_SUK_NGORONGORO_CRATER');

--大峡谷
update Features set NoResource = 1 where FeatureType = 'FEATURE_SUK_GRANDCANYON';
--纪念碑谷
delete from GameModifiers where ModifierId in (
	'SUK_MONUMENTVALLEY_FAVOR_A',
	'SUK_MONUMENTVALLEY_FAVOR_B',
	'SUK_MONUMENTVALLEY_FAVOR_C',
	'SUK_MONUMENTVALLEY_GOLD_A',
	'SUK_MONUMENTVALLEY_GOLD_B'
);