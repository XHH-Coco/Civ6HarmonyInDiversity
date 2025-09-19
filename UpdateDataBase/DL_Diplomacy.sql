-------------------------------------
--      Diplomacy Adjustments      --
-------------------------------------

update DiplomaticActions set InitiatorPrereqCivic = 'CIVIC_DIVINE_RIGHT' where DiplomaticActionType = 'DIPLOACTION_DECLARE_HOLY_WAR';
update DiplomaticActions set InitiatorPrereqCivic = 'CIVIC_CIVIL_SERVICE' where DiplomaticActionType = 'DIPLOACTION_DECLARE_LIBERATION_WAR';
update DiplomaticActions set InitiatorPrereqCivic = 'CIVIC_MILITARY_TRAINING' where DiplomaticActionType = 'DIPLOACTION_DECLARE_TERRITORIAL_WAR';
update DiplomaticActions set InitiatorPrereqCivic = NULL where DiplomaticActionType = 'DIPLOACTION_DECLARE_RECONQUEST_WAR';
update DiplomaticActions set InitiatorPrereqCivic = NULL where DiplomaticActionType = 'DIPLOACTION_DECLARE_PROTECTORATE_WAR';
update DiplomaticActions set InitiatorPrereqCivic = 'CIVIC_COLONIALISM' where DiplomaticActionType = 'DIPLOACTION_DECLARE_COLONIAL_WAR';
update DiplomaticActions set InitiatorPrereqCivic = NULL where DiplomaticActionType = 'DIPLOACTION_JOINT_WAR';
update DiplomaticActions set InitiatorPrereqCivic = NULL where DiplomaticActionType = 'DIPLOACTION_THIRD_PARTY_WAR';
update DiplomaticActions set InitiatorPrereqCivic = 'CIVIC_MILITARY_TRADITION' where DiplomaticActionType = 'DIPLOACTION_DECLARE_WAR_OF_RETRIBUTION';

update DiplomaticStateActions set Cost = 0 where StateType = 'DIPLO_STATE_ALLIED' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
update DiplomaticStateActions set Cost = 0 where StateType = 'DIPLO_STATE_DECLARED_FRIEND' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
update DiplomaticStateActions set Cost = 0 where StateType = 'DIPLO_STATE_FRIENDLY' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
update DiplomaticStateActions set Cost = 0 where StateType = 'DIPLO_STATE_NEUTRAL' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
update DiplomaticStateActions set Cost = 0 where StateType = 'DIPLO_STATE_UNFRIENDLY' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
update DiplomaticStateActions set Cost = 1000 where StateType = 'DIPLO_STATE_DENOUNCED' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';

-- update DiplomaticStateActions set Cost = 0 where StateType = 'DIPLO_STATE_ALLIED' and DiplomaticActionType = 'DIPLOACTION_OPEN_BORDERS';
-- update DiplomaticStateActions set Cost = -20 where StateType = 'DIPLO_STATE_DECLARED_FRIEND' and DiplomaticActionType = 'DIPLOACTION_OPEN_BORDERS';
-- update DiplomaticStateActions set Cost = -20 where StateType = 'DIPLO_STATE_FRIENDLY' and DiplomaticActionType = 'DIPLOACTION_OPEN_BORDERS';
-- update DiplomaticStateActions set Cost = -40 where StateType = 'DIPLO_STATE_NEUTRAL' and DiplomaticActionType = 'DIPLOACTION_OPEN_BORDERS';
-- update DiplomaticStateActions set Cost = -60 where StateType = 'DIPLO_STATE_UNFRIENDLY' and DiplomaticActionType = 'DIPLOACTION_OPEN_BORDERS';
-- update DiplomaticStateActions set Cost = 1000 where StateType = 'DIPLO_STATE_DENOUNCED' and DiplomaticActionType = 'DIPLOACTION_OPEN_BORDERS';

-- update DiplomaticStateActions set Cost = 5 where StateType = 'DIPLO_STATE_ALLIED' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
-- update DiplomaticStateActions set Cost = 10 where StateType = 'DIPLO_STATE_DECLARED_FRIEND' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
-- update DiplomaticStateActions set Cost = 10 where StateType = 'DIPLO_STATE_FRIENDLY' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
-- update DiplomaticStateActions set Cost = 15 where StateType = 'DIPLO_STATE_NEUTRAL' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
-- update DiplomaticStateActions set Cost = 20 where StateType = 'DIPLO_STATE_UNFRIENDLY' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';
update DiplomaticStateActions set Cost = 1000 where StateType = 'DIPLO_STATE_DENOUNCED' and DiplomaticActionType = 'DIPLOACTION_PROPOSE_TRADE';

-- Useless for adjust trading.
-- update GlobalParameters set Value = 0 where Name = 'AI_BASE_LUXURY_VALUE';

-- attempt to enable surprise war during declared friend state.
-- insert or ignore into DiplomaticStateActions (StateType, DiplomaticActionType, Worth, Cost) values 
-- 	('DIPLO_STATE_DECLARED_FRIEND', 'DIPLOACTION_DECLARE_SURPRISE_WAR', 0, 0)
-- ;
-- delete from DiplomaticStateActions where DiplomaticActionType = 'DIPLOACTION_DECLARE_SURPRISE_WAR';

-- Make declare friend harder.
-- update DiplomaticStateTransitions set RequireTransitionMax = 35, AllowTransitionMin = 15 where
-- 	BaseState = 'DIPLO_STATE_FRIENDLY' and TransitionState = 'DIPLO_STATE_DECLARED_FRIEND';

-- lower the one side trades influence.
update ModifierArguments set Value = 50 where
	ModifierId = 'STANDARD_DIPLOMATIC_ONE_SIDED_TRADES' and Name = 'TradeValuePerModifierPoint';

update ModifierArguments set Value = 6 where
	ModifierId = 'STANDARD_DIPLOMATIC_WARMONGER' and Name = 'PercentOfGrievances';
-- 第三方文明因不满产出的不满
update ModifierArguments set Value = 3 where
	ModifierId = 'STANDARD_DIPLOMATIC_THIRD_PARTY_WARMONGER' and Name = 'PercentOfGrievancesDelta';

insert or replace into ModifierArguments
    (ModifierId,                                                    Name,                   Value)
values
    ('STANDARD_DIPLOMACY_TRADE_RELATIONS',                          'TradeBonus',           4);

-- 同宗教好感+3，异教-4
/*insert or replace into TraitModifiers
	(TraitType,								ModifierId)
values
	('TRAIT_LEADER_MAJOR_CIV',				'STANDARD_DIPLOMATIC_SAME_RELIGION'),
    ('TRAIT_LEADER_MAJOR_CIV',				'STANDARD_DIPLOMATIC_ENCROACHING_RELIGION');

insert or replace into Modifiers
	(ModifierId,								    ModifierType,                                   SubjectRequirementSetId)
values
	('STANDARD_DIPLOMATIC_SAME_RELIGION',			'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',    'PLAYER_SAME_RELIGION'),
	('STANDARD_DIPLOMATIC_ENCROACHING_RELIGION',	'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',    'PLAYER_ENCROACHING_RELIGION');

insert or replace into ModifierArguments
	(ModifierId,								    Name,				            Value)
values
	('STANDARD_DIPLOMATIC_SAME_RELIGION',			'InitialValue',                 3),
    ('STANDARD_DIPLOMATIC_SAME_RELIGION',			'SimpleModifierDescription',    'LOC_DIPLO_MODIFIER_INTOLERANT_SAME'),
	('STANDARD_DIPLOMATIC_ENCROACHING_RELIGION',	'InitialValue',                 -4),
    ('STANDARD_DIPLOMATIC_ENCROACHING_RELIGION',	'SimpleModifierDescription',    'LOC_DIPLO_MODIFIER_INTOLERANT_ENCROACHING');
*/

-- 同盟效果
insert or replace into AllianceEffects
	(LevelRequirement,      AllianceType,             ModifierID)
values
	(1,                     'ALLIANCE_MILITARY',      'ALLIANCE_ADD_PRODUCTION_TO_ORIGIN_TRADE_ROUTE'),
	(1,                     'ALLIANCE_MILITARY',      'ALLIANCE_ADD_PRODUCTION_TO_DESTINATION_TRADE_ROUTE');

insert or replace into Modifiers
	(ModifierId,	                                            ModifierType,                                           SubjectRequirementSetId)
values
	('ALLIANCE_ADD_PRODUCTION_TO_ORIGIN_TRADE_ROUTE',       	'MODIFIER_ALLIANCE_TRADE_ROUTE_ADJUST_YIELD',           'ROUTE_BETWEEN_ALLIES_REQUIREMENTS'),
	('ALLIANCE_ADD_PRODUCTION_TO_DESTINATION_TRADE_ROUTE',  	'MODIFIER_ALLIANCE_TRADE_ROUTE_ADJUST_YIELD',           'ROUTE_BETWEEN_ALLIES_REQUIREMENTS');

insert or replace into ModifierArguments
	(ModifierId,	                                        	Name,	                Value)
values
	('ALLIANCE_ADD_PRODUCTION_TO_ORIGIN_TRADE_ROUTE',           'Amount',               2),
	('ALLIANCE_ADD_PRODUCTION_TO_ORIGIN_TRADE_ROUTE',         	'YieldType',            'YIELD_PRODUCTION'),
	('ALLIANCE_ADD_PRODUCTION_TO_ORIGIN_TRADE_ROUTE',         	'AffectOrigin',         1),
	('ALLIANCE_ADD_PRODUCTION_TO_DESTINATION_TRADE_ROUTE',    	'Amount',               1),
	('ALLIANCE_ADD_PRODUCTION_TO_DESTINATION_TRADE_ROUTE',    	'YieldType',            'YIELD_PRODUCTION'),
	('ALLIANCE_ADD_PRODUCTION_TO_DESTINATION_TRADE_ROUTE',    	'AffectDestination',    1);

insert or replace into ModifierStrings
	(ModifierId,																						Context,				Text)
values
	('ALLIANCE_ADD_PRODUCTION_TO_ORIGIN_TRADE_ROUTE',				'Summary',				'LOC_ALLIANCE_LV1_MILITARY_EFFECT_2'),
	('ALLIANCE_ADD_PRODUCTION_TO_DESTINATION_TRADE_ROUTE',	'Summary',				'LOC_ALLIANCE_LV1_MILITARY_EFFECT_3');