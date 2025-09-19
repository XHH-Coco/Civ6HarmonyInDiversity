-- Trading Dome (Samarkand)
-- other basic adjustments are written in DLCSupport/DL_Babylon.sql
create temporary table TradingDomeResourceYieldChanges (
	ResourceType text not null,
	YieldType text not null,
	YieldChange int not null,
	primary key (ResourceType, YieldType)
);
insert or replace into TradingDomeResourceYieldChanges
	(ResourceType,	YieldType,	YieldChange)
select
	ResourceType,	YieldType,	YieldChange
from Resource_YieldChanges where ResourceType in (select ResourceType from Resources where ResourceClassType = 'RESOURCECLASS_LUXURY' and Frequency > 0);
insert or replace into Improvement_ValidResources
	(ImprovementType,				ResourceType,		MustRemoveFeature)
select distinct
	'IMPROVEMENT_TRADING_DOME',		ResourceType,	0
from TradingDomeResourceYieldChanges;
-- Bonus for other Trading Dome
insert or replace into ImprovementModifiers
	(ImprovementType,				ModifierId)
select
	'IMPROVEMENT_TRADING_DOME',		'TRADING_DOME_' || ResourceType || '_' || YieldType || '_ATTACH'
from TradingDomeResourceYieldChanges;
insert or replace into Modifiers
	(ModifierId,														ModifierType,									OwnerRequirementSetId,						SubjectRequirementSetId,							SubjectStackLimit)
select
	'TRADING_DOME_' || ResourceType || '_' || YieldType || '_ATTACH',	'MODIFIER_PLAYER_IMPROVEMENTS_ATTACH_MODIFIER',	ResourceType || '_IN_PLOT_REQUIREMENTS',	'PLOT_HAS_IMPROVEMENT_TRADING_DOME_REQUIREMENTS',	1
from TradingDomeResourceYieldChanges;
insert or replace into ModifierArguments
	(ModifierId,											Name,			Value)
select
	'TRADING_DOME_' || ResourceType || '_' || YieldType || '_ATTACH',	'ModifierId',	'TRADING_DOME_' || ResourceType || '_' || YieldType
from TradingDomeResourceYieldChanges;
insert or replace into Modifiers
	(ModifierId,											ModifierType)
select
	'TRADING_DOME_' || ResourceType || '_' || YieldType,	'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS'
from TradingDomeResourceYieldChanges;
insert or replace into ModifierArguments
	(ModifierId,											Name,			Value)
select
	'TRADING_DOME_' || ResourceType || '_' || YieldType,	'YieldType',	YieldType
from TradingDomeResourceYieldChanges;
insert or replace into ModifierArguments
	(ModifierId,											Name,			Value)
select
	'TRADING_DOME_' || ResourceType || '_' || YieldType,	'Amount',		YieldChange
from TradingDomeResourceYieldChanges;
-- Bonus for trade routes
create temporary table TradingDomeTradeRouteYieldChanges (
	ResourceType text not null,
	YieldType text not null,
	YieldChange int not null,
	TradeRouteType text not null,
	PrereqTechType text not null,
	ModifierId text,
	primary key (ResourceType, YieldType, TradeRouteType, PrereqTechType)
);
with T(TradeRouteType) as (values ('DOMESTIC'), ('INTERNATIONAL')),
	P(PrereqTechType) as (values ('TECH_CURRENCY'), ('TECH_ECONOMICS'))
insert or replace into TradingDomeTradeRouteYieldChanges
	(ResourceType,	YieldType,	YieldChange,	TradeRouteType,	PrereqTechType)
select
	ResourceType,	YieldType,	YieldChange,	TradeRouteType,	PrereqTechType
from TradingDomeResourceYieldChanges cross join T cross join P;
update TradingDomeTradeRouteYieldChanges set ModifierId = 'TRADING_DOME_' || ResourceType || '_' || TradeRouteType || '_' || YieldType || '_' || PrereqTechType;
insert or replace into ImprovementModifiers
	(ImprovementType,				ModifierId)
select
	'IMPROVEMENT_TRADING_DOME',		ModifierId
from TradingDomeTradeRouteYieldChanges;
insert or replace into Modifiers
	(ModifierId,	ModifierType,															OwnerRequirementSetId,						SubjectRequirementSetId)
select
	ModifierId,		'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_' || TradeRouteType,	ResourceType || '_IN_PLOT_REQUIREMENTS',	'PLAYER_HAS_' || PrereqTechType || '_REQUIREMENTS'
from TradingDomeTradeRouteYieldChanges;
insert or replace into ModifierArguments
	(ModifierId,	Name,			Value)
select
	ModifierId,		'YieldType',	YieldType
from TradingDomeTradeRouteYieldChanges;
insert or replace into ModifierArguments
	(ModifierId,	Name,			Value)
select
	ModifierId,		'Amount',		YieldChange
from TradingDomeTradeRouteYieldChanges;