-------------------------------------
--  Trade Route Yield Adjustment   --
-------------------------------------
-- 修改区域的贸易路线产出
update District_TradeRouteYields set YieldChangeAsDomesticDestination = 3, YieldChangeAsInternationalDestination = 0, YieldType = 'YIELD_GOLD'
    where DistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX' or DistrictType in (select CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX');
update District_TradeRouteYields set YieldChangeAsDomesticDestination = 3, YieldChangeAsInternationalDestination = 0, YieldType = 'YIELD_GOLD'
    where DistrictType = 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX' or DistrictType in (select CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX');
update District_TradeRouteYields set YieldChangeAsInternationalDestination = 3 where DistrictType = 'DISTRICT_GOVERNMENT' and YieldType = 'YIELD_GOLD';

insert or replace into District_TradeRouteYields
    (DistrictType,             YieldType,          YieldChangeAsDomesticDestination,   YieldChangeAsInternationalDestination)
values
    ('DISTRICT_CANAL',         'YIELD_GOLD',       3,                                  0),
    ('DISTRICT_NEIGHBORHOOD',  'YIELD_GOLD',       1,                                  0),
    ('DISTRICT_DAM',           'YIELD_FOOD',       1,                                  0),
    ('DISTRICT_AQUEDUCT',      'YIELD_FOOD',       1,                                  0),
    ('DISTRICT_AERODROME',     'YIELD_GOLD',       3,                                  0);

insert or replace into District_TradeRouteYields
    (DistrictType,             YieldType,          YieldChangeAsDomesticDestination,   YieldChangeAsInternationalDestination)
select
    CivUniqueDistrictType,     'YIELD_GOLD',       1,                                  0
from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_NEIGHBORHOOD';

insert or replace into District_TradeRouteYields
    (DistrictType,             YieldType,          YieldChangeAsDomesticDestination,   YieldChangeAsInternationalDestination)
select
    CivUniqueDistrictType,     'YIELD_FOOD',       1,                                  0
from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_AQUEDUCT';

insert or replace into District_TradeRouteYields
    (DistrictType,             YieldType,          YieldChangeAsDomesticDestination,   YieldChangeAsInternationalDestination)
select
    'DISTRICT_PRESERVE',       'YIELD_FOOD',       1,                                  0
where exists (select DistrictType from Districts where DistrictType = 'DISTRICT_PRESERVE');

delete from District_TradeRouteYields where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER' and YieldType = 'YIELD_FOOD';
update District_TradeRouteYields set YieldType = 'YIELD_FOOD', YieldChangeAsDomesticDestination = 1 where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER' and YieldType = 'YIELD_PRODUCTION';

-- 外来商队+1金
insert or replace into DistrictModifiers (DistrictType, ModifierId)
select DistrictType, 'HD_ONE_GOLD_FROM_INCOMING_FOREIGN_ROUTES' from District_TradeRouteYields
where YieldChangeAsInternationalDestination != 0;

insert or replace into Modifiers
    (ModifierId,                                                    ModifierType)
values
    ('HD_ONE_GOLD_FROM_INCOMING_FOREIGN_ROUTES',                    'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FROM_OTHERS');

insert or replace into ModifierArguments
    (ModifierId,                                                    Name,                   Value)
values
    ('HD_ONE_GOLD_FROM_INCOMING_FOREIGN_ROUTES',                    'YieldType',            'YIELD_GOLD'),
    ('HD_ONE_GOLD_FROM_INCOMING_FOREIGN_ROUTES',                    'Amount',               1);
