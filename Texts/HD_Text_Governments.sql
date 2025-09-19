insert or replace into EnglishText
  (Tag,                                                         Text)
values
  ("LOC_GOVT_INHERENT_BONUS_AUTOCRACY_ETHIOPIA",                "All Palace, Government Plaza buildings and Diplomatic Quarter buildings provide +3 [ICON_FOOD] Food and +3 [ICON_PRODUCTION] Production."),
  ("LOC_GOVT_INHERENT_BONUS_AUTOCRACY_XP1",                     "All Palace and Government Plaza buildings provide +3 [ICON_FOOD] Food and +3 [ICON_PRODUCTION] Production."),
  ("LOC_GOVT_INHERENT_BONUS_CLASSREP_XP1",                      "All cities with a district receive +1 [ICON_HOUSING] Housing, +1 [ICON_AMENITIES] Amenity, +1 [ICON_SCIENCE] Science and +1 [ICON_CULTURE] Culture."),
  -- Tier 2
  ("LOC_GOVT_INHERENT_BONUS_MONARCHY_XP1",                      "Increases the city growth rate by +10% and +15% construction speed towards Districts with a garrisoned unit."),
  ("LOC_GOVT_ACCUMULATED_BONUS_BRIEF_MONARCHY_XP1",             "+50% Influence Points. +20% [ICON_Production] Production toward units for cities with a garrisoned unit."),
  ("LOC_GOVT_INHERENT_BONUS_MERCHREP_XP1",                      "[ICON_CITIZEN] Citizens in this city provide +4 [ICON_GOLD] Gold. +10% [ICON_GOLD] Gold in all cities with an established [ICON_Governor] Governor."),
  ("LOC_GOVT_ACCUMULATED_BONUS_BRIEF_MERCHREP_XP1",             "Reduces the cost of purchasing a tile by 20%."),
  ("LOC_GOVT_INHERENT_BONUS_THEOCRACY_XP1",                     "+5 [ICON_Religion] Religious Strength in Theological Combat. Each Tier of buildings in Holy Site districts provides +0.5 [ICON_Faith] Faith for [ICON_CITIZEN] Citizens in this city."),
  ("LOC_GOVT_ACCUMULATED_BONUS_BRIEF_THEOCRACY_XP1",            "15% Discount on Purchases with [ICON_Faith] Faith. Enable purchasing land military units with [ICON_Faith] Faith in cities that has Holy Site."),
  -- Tier 3
  ("LOC_GOVT_INHERENT_BONUS_DEMOCRACY_XP2",                     "Each Tier 3 building in Commercial Hub district provides +5% [ICON_GreatPerson] Great Person points to all cities. Allows city to purchase districts with [ICON_Gold] Gold."),
  ("LOC_GOVT_ACCUMULATED_BONUS_BRIEF_DEMOCRACY_XP1",            "15% Discount on Purchases with [ICON_Gold] Gold."),
  ("LOC_GOVT_INHERENT_BONUS_COMMUNISM_XP1",                     "+25% [ICON_Production] Production toward Industrial era and later Wonders. +1 [ICON_Production] Production per [ICON_Citizen] Citizen in cities."),
  ("LOC_GOVT_ACCUMULATED_BONUS_BRIEF_COMMUNISM_XP2",            "+50% [ICON_Production] Production towards districts and buildings in all cities. +15% [ICON_Science] Science in cities with at least [ICON_Citizen] Citizen.");

insert or replace into LocalizedText
  (Language,      Tag,                                                         Text)
values
  ("zh_Hans_CN",  "LOC_GOVT_INHERENT_BONUS_AUTOCRACY_ETHIOPIA",                "所有宫殿、市政广场建筑、外交区建筑提供+3 [ICON_FOOD] 食物和+3 [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_GOVT_INHERENT_BONUS_AUTOCRACY_XP1",                     "所有宫殿、市政广场建筑提供+3 [ICON_FOOD] 食物和+3 [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_GOVT_INHERENT_BONUS_CLASSREP_XP1",                      "你的每个拥有专业化区域的城市+1 [ICON_Housing] 住房、+1 [ICON_Amenities] 宜居度、+1 [ICON_SCIENCE] 科技值和+1 [ICON_CULTURE] 文化值。"),
  -- Tier 2
  ("zh_Hans_CN",  "LOC_GOVT_INHERENT_BONUS_MONARCHY_XP1",                      "拥有驻军单位的城市+10%余粮，建造区域+25%建造速度。"),
  ("zh_Hans_CN",  "LOC_GOVT_ACCUMULATED_BONUS_BRIEF_MONARCHY_XP1",             "+50%影响力点数。拥有驻军单位的城市生产单位时+20% [ICON_Production] 生产力。"),
  ("zh_Hans_CN",  "LOC_GOVT_INHERENT_BONUS_MERCHREP_XP1",                      "城市中每位 [ICON_CITIZEN] 公民+4 [ICON_GOLD] 金币。有 [ICON_Governor] 总督就职的城市+10% [ICON_GOLD] 金币。"),
  ("zh_Hans_CN",  "LOC_GOVT_ACCUMULATED_BONUS_BRIEF_MERCHREP_XP1",             "购买一个单元格的费用降低20%。"),
  ("zh_Hans_CN",  "LOC_GOVT_INHERENT_BONUS_THEOCRACY_XP1",                     "神学战争中+5 [ICON_Religion] 宗教战斗力。每一级圣地建筑为城市中每位 [ICON_CITIZEN] 公民+0.5 [ICON_Faith] 信仰值。"),
  ("zh_Hans_CN",  "LOC_GOVT_ACCUMULATED_BONUS_BRIEF_THEOCRACY_XP1",            "使用 [ICON_Faith] 信仰值购买可享受15%折扣。可使用信仰在拥有圣地的城市购买陆地军事单位。"),
  -- Tier 3
  ("zh_Hans_CN",  "LOC_GOVT_INHERENT_BONUS_DEMOCRACY_XP2",                     "每座商业中心三级建筑为所有城市+5% [ICON_GreatPerson] 伟人点。城市可使用 [ICON_Gold] 金币购买区域。"),
  ("zh_Hans_CN",  "LOC_GOVT_ACCUMULATED_BONUS_BRIEF_DEMOCRACY_XP1",            "使用 [ICON_Gold] 金币购买时费用-15%。"),
  ("zh_Hans_CN",  "LOC_GOVT_INHERENT_BONUS_COMMUNISM_XP1",                     "建造工业时代或以后的奇观+25%建造速度。城市中每位 [ICON_Citizen] 公民将+1 [ICON_Production] 生产力。"),
  ("zh_Hans_CN",  "LOC_GOVT_ACCUMULATED_BONUS_BRIEF_COMMUNISM_XP2",            "所有城市建造区域和建筑+50%建造速度。拥有至少15 [ICON_Citizen] 公民的城市+15% [ICON_Science] 科技值。");

insert or replace into LocalizedText
  (Language,      Tag,                                            Text)
select
  "zh_Hans_CN",   "LOC_GOVT_INHERENT_BONUS_DEMOCRACY_XP2",        "每座公司为所有城市+5% [ICON_GreatPerson] 伟人点。城市可使用 [ICON_Gold] 金币购买区域。"
where exists (select Tag from LocalizedText where Tag = 'LOC_IMPROVEMENT_CORPORATION_NAME');
insert or replace into EnglishText
  (Tag,                                          Text)
select
  "LOC_GOVT_INHERENT_BONUS_DEMOCRACY_XP2",       "Each Corporation provides +5% [ICON_GreatPerson] Great Person points to all cities. Allows city to purchase districts with [ICON_Gold] Gold."
where exists (select Tag from LocalizedText where Tag = 'LOC_IMPROVEMENT_CORPORATION_NAME');