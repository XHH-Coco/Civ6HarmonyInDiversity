--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                             Text)
values
    ("LOC_BUILDING_ALCHEMICAL_SOCIETY_DESCRIPTION",                   "Unique to the Hermetic Order, replaces the University. This Campus district generates [ICON_Gold] Gold equal to its [ICON_Science] Science adjacency bonus. +1 [ICON_SCIENCE] Science to all adjacent Rainforest tiles. Campus districts get standard adjacency bonus from Rainforests."),
    ("LOC_BUILDING_GILDED_VAULT_DESCRIPTION",                         "Unique to the Owls of Minerva, replaces the Bank. This Commercial Hub generates [ICON_CULTURE] Culture equal to its [ICON_Gold] Gold adjacency bonus.  Having a Harbor in this city provides you with +1 [ICON_TradeRoute] Trade Route capacity. +5% [ICON_gold] Gold in this city.");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                                             Text)
values
    ("zh_Hans_CN",  "LOC_BUILDING_ALCHEMICAL_SOCIETY_DESCRIPTION",                   "黄金黎明协会专属，替代大学。此学院区域将提供等同于其 [ICON_Science] 科技值相邻加成的 [ICON_Gold] 金币。相邻学院的雨林+1 [ICON_SCIENCE] 科技值；本城的学院获得雨林的标准相邻加成。"),
    ("zh_Hans_CN",  "LOC_BUILDING_GILDED_VAULT_DESCRIPTION",                         "弥涅耳瓦夜鹰专属，替代银行。这个商业中心将提供等同于其 [ICON_Gold] 金币相邻加成的 [ICON_CULTURE] 文化值。若此城市中拥有港口，则+1 [ICON_TradeRoute] 贸易路线容量。本城 [ICON_GOLD] 金币产出+5%。");
