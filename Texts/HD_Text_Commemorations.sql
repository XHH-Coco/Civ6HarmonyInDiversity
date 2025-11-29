--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
  (Tag,                                                                           Text)
values
  ("LOC_MOMENT_ACTION_PANEL_TEXT",                                                "{1_Name}: {2_Bonus}"),
  ("LOC_MOMENT_CIVILOPEDIA_TEXT",                                                 "[ICON_GLORY_NORMAL_AGE] Normal Age: {1_NormalBonus}[NEWLINE][NEWLINE][ICON_GLORY_GOLDEN_AGE] Golden Age: {2_GoldenBonus}"),
  -- Natural Philosophy
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC",                                              "Natural Philosophy"),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_GOLDEN_AGE",                             "Campus, Harbor, and Aqueducts provide +1 [ICON_SCIENCE] Science and +1 [ICON_CULTURE] Culture. Each triggered [ICON_TECHBOOSTED] Eureka provides 10 [ICON_GREATSCIENTIST] Great Scientist points."),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_NORMAL_AGE",                             "Each triggered [ICON_TECHBOOSTED] Eureka provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Buildings whose production is based on Science provide +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_DARK_AGE",                               "Each triggered [ICON_TECHBOOSTED] Eureka provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Buildings whose production is based on Science provide +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Axis Age
  ("LOC_MOMENT_CATEGORY_CULTURAL",                                                "Axial Age"),
  ("LOC_MOMENT_CATEGORY_CULTURAL_BONUS_GOLDEN_AGE",                               "Each district provides +1 [ICON_CULTURE] Culture and +1 [ICON_FAITH] Faith. Specialized districts provide +3 [ICON_GREATWRITER] Great Writer points."),
  ("LOC_MOMENT_CATEGORY_CULTURAL_BONUS_NORMAL_AGE",                               "Each triggered [ICON_CIVICBOOSTED] Inspiration provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Buildings with Great Work slots provide +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_CULTURAL_BONUS_DARK_AGE",                                 "Each triggered [ICON_CIVICBOOSTED] Inspiration provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Buildings with Great Work slots provide +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Majestic Splendor
  ("LOC_MOMENT_CATEGORY_INFRASTRUCTURE",                                          "Monumentality"),
  ("LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_GOLDEN_AGE",                         "[ICON_CAPITAL] Capital can build one more district than the [ICON_CITIZEN] Population limit allows. Building Ancient, Classical, and Medieval Wonders provides +10% construction speed. Cities with Wonders gain +10% [ICON_FOOD] Food and [ICON_PRODUCTION] Production."),
  ("LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_NORMAL_AGE",                         "Each new district built provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_DARK_AGE",                           "Each new district built provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Glorious Victory
  ("LOC_MOMENT_CATEGORY_RELIGIOUS",                                               "Glorious Victory"),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_GOLDEN_AGE",                              "Recon units and naval raider units gain +1 [ICON_MOVEMENT] Movement and +1 sight. Military units gain +2 [ICON_STRENGTH] Strength. Clearing Barbarian Outposts provides +50 [ICON_GOLD] Gold. Conquering cities grants Tribal Village rewards."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_NORMAL_AGE",                              "Each Barbarian Outpost cleared provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Each city conquered provides +3 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_DARK_AGE",                                "Each Barbarian Outpost cleared provides +1 [ICON_GLORY_NORMAL_AGE] Era Score. Each city conquered provides +3 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_SPEED_SIGHT_DESCRIPTION",            "Focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS}”: +1 [ICON_MOVEMENT] Movement. +1 sight."),
  ("LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_STRENGTH_MODIFIER_TEXT",             "From focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS}”"),
  ("LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_STRENGTH_DESCRIPTION",               "Focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS}”: +2 [ICON_Strength] Strength."),
  ------------------------------------------------
  -- Translation Movement
  ("LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT",                                    "Translation Movement"),
  ("LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_GOLDEN_AGE",                   "Building Academies, Theater Squares, and buildings in these districts provides +30% construction speed. [ICON_SCIENCE] Science from [ICON_TechBoosted] Eureka +3%, [ICON_CULTURE] Culture from [ICON_Civicboosted] Inspirations +3%."),
  ("LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_NORMAL_AGE",                   "Each recruitment of a [ICON_GREATSCIENTIST] Great Scientist, [ICON_GREATWRITER] Great Writer, [ICON_GREATARTIST] Great Artist, or [ICON_GREATMUSICIAN] Great Musician provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_DARK_AGE",                     "Each recruitment of a [ICON_GREATSCIENTIST] Great Scientist, [ICON_GREATWRITER] Great Writer, [ICON_GREATARTIST] Great Artist, or [ICON_GREATMUSICIAN] Great Musician provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Prosperous Road
  ("LOC_MOMENT_CATEGORY_FLOURSHING_ROAD",                                         "Flourshing Road"),
  ("LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_GOLDEN_AGE",                        "+50% adjacency bonus for Industrial Zones, Commercial Hubs, and Harbors. All international [ICON_TRADEROUTE] Trade Routes provide +1 [ICON_SCIENCE] Science, +1 [ICON_CULTURE] Culture and +6 [ICON_GOLD] Gold."),
  ("LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_NORMAL_AGE",                        "Each completed [ICON_TRADEROUTE] Trade Route provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_DARK_AGE",                          "Each completed [ICON_TRADEROUTE] Trade Route provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Rough Beginnings
  ("LOC_MOMENT_CATEGORY_DOMESTIC_ASSART",                                         "Domestic Assart"),
  ("LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_GOLDEN_AGE",                        "Civilian units gain +2 [ICON_MOVEMENT] Movement. Newly founded cities receive 1 free Builder. Each improved resource provides +1 [ICON_FOOD] Food and +1 [ICON_PRODUCTION] Production in the city."),
  ("LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_NORMAL_AGE",                        "Each improved resource provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_DARK_AGE",                          "Each improved resource provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_HD_DOMESTIC_ASSART_CIVILIAN_SPEED_DESCRIPTION",     "Focus point “{LOC_MOMENT_CATEGORY_DOMESTIC_ASSART}”: +2 [ICON_MOVEMENT] Movement."),

  -- Religious War
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_WAR",                                           "Religious War"),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_GOLDEN_AGE",                          "Military units gain +1 [ICON_MOVEMENT] Movement. Religious units gain +2 [ICON_MOVEMENT] Movement and +2 uses. +5 [ICON_STRENGTH] Strength when fighting units from civilizations with different religion. Plundering and Coastal Raiding rewards +50%. Plundering or Coastal Raiding improvements will yield additional [ICON_SCIENCE] Science equivalent."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_NORMAL_AGE",                          "First city to follow your founded religion provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_DARK_AGE",                            "First city to follow your founded religion provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_MILITARY_SPEED_DESCRIPTION",       "Focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”: +1 [ICON_MOVEMENT] Movement. +5 [ICON_STRENGTH] Strength when fighting units from non-religious civilizations."),
  ("LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_SPEED_DESCRIPTION",      "Focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”: +2 [ICON_MOVEMENT] Movement. +5 [ICON_RELIGION] Religious combat strength in Theological Wars."),
  ("LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_MILITARY_STRENGTH_TEXT",           "From focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”"),
  ("LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_STRENGTH_TEXT",          "From focus point “{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”"),
  ------------------------------------------------
  -- Enlightened Despotism
  ("LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM",                                   "Enlightened Despotism"),
  ("LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_GOLDEN_AGE",                  "Gain a wildcard policy slot permanently. All cities can build one additional district without population restrictions from [ICON_CITIZEN]. Districts adjacent to the Civic Square {LOC_AND_DIPLOMATIC_QUARTER} gain +50% adjacency bonus."),
  ("LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_NORMAL_AGE",                  "Each constructed Community or building in the Civic Square {LOC_AND_DIPLOMATIC_QUARTER} grants +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_DARK_AGE",                    "Each constructed Community or building in the Civic Square {LOC_AND_DIPLOMATIC_QUARTER} grants +2 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Economic Model
  ("LOC_MOMENT_CATEGORY_ECONOMIC",                                                "Primitive Accumulation"),
  ("LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_GOLDEN_AGE",                               "[ICON_GREATENGINEER] Great Engineers and [ICON_GREATMERCHANT] Great Merchants accumulate points +50% faster. All [ICON_TRADEROUTE] Trade Routes provide +2 [ICON_PRODUCTION] Production and +6 [ICON_GOLD] Gold. Purchase districts, buildings, or units at -10% cost."),
  ("LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_NORMAL_AGE",                               "Each recruitment of a [ICON_GREATENGINEER] Great Engineer and [ICON_GREATMERCHANT] Great Merchant provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_DARK_AGE",                                 "Each recruitment of a [ICON_GREATENGINEER] Great Engineer and [ICON_GREATMERCHANT] Great Merchant provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Religious Reform
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM",                                        "Religious Reform"),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_GOLDEN_AGE",                       "+100% adjacency bonus for Holy Sites. Cities with Shrines provide +10% [ICON_SCIENCE] Science, [ICON_CULTURE] Culture, and [ICON_FAITH] Faith."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_NORMAL_AGE",                       "Each constructed Holy Site building provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_DARK_AGE",                         "Each constructed Holy Site building provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Here Be Dragons
  ("LOC_MOMENT_CATEGORY_EXPLORATION",                                             "Hic Sunt Dracones"),
  ("LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_GOLDEN_AGE",                            "Civilian, naval, and waterborne units gain +2 [ICON_MOVEMENT] Movement. Newly founded cities gain +3 [ICON_CITIZEN] Population. Cities without specialized districts build districts +100% faster."),
  ("LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_NORMAL_AGE",                            "Each discovered new continent or natural wonder provides +3 [ICON_GLORY_NORMAL_AGE] Era Score. Each naval non-barbarian unit killed in combat provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_DARK_AGE",                              "Each discovered new continent or natural wonder provides +3 [ICON_GLORY_NORMAL_AGE] Era Score. Each naval non-barbarian unit killed in combat provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_EXPLORATION_CIVILIAN_SPEED_DESCRIPTION",            "Focus point “{LOC_MOMENT_CATEGORY_EXPLORATION}”: +2 [ICON_MOVEMENT] Movement."),
  ------------------------------------------------
  -- Steamrolling
  ("LOC_MOMENT_CATEGORY_INDUSTRIAL",                                              "Heartbeat of Steam"),
  ("LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_GOLDEN_AGE",                             "Constructing wonders from the Industrial Era or later provides +25% construction speed. +50% basic and regional yiels from buildings in Industrial Zones."),
  ("LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_NORMAL_AGE",                             "Each construction of a building from the Industrial Era or later provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_DARK_AGE",                               "Each construction of a building from the Industrial Era or later provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- International System
  ("LOC_MOMENT_CATEGORY_INTERNATIONAL_SYSTEM",                                    "International System"),
  ("LOC_MOMENT_CATEGORY_INTERNATIONAL_SYSTEM_BONUS_GOLDEN_AGE",                   "+100% Influence points. +100% [ICON_FAVOR] Diplomatic Favor as Suzerain of a City-State. Your [ICON_TRADEROUTE] Trade Routes to an Ally's city or vassal city-state provide +4 [ICON_SCIENCE] Science, [ICON_CULTURE] Culture and [ICON_GOLD] Gold."),
  ("LOC_MOMENT_CATEGORY_INTERNATIONAL_SYSTEM_BONUS_NORMAL_AGE",                   "Provide +3 [ICON_GLORY_NORMAL_AGE] Era Scores for each time you a [ICON_TRADEROUTE] Trade Route to an Ally's city or vassal city-state."),
  ("LOC_MOMENT_CATEGORY_INTERNATIONAL_SYSTEM_BONUS_DARK_AGE",                     "Provide +3 [ICON_GLORY_NORMAL_AGE] Era Scores for each time you a [ICON_TRADEROUTE] Trade Route to an Ally's city or vassal city-state."),

  -- Romanticism
  ("LOC_MOMENT_CATEGORY_ROMANTICISM",                                             "Romanticism"),
  ("LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_GOLDEN_AGE",                            "[ICON_GREATWRITER] Great Writers, [ICON_GREATARTIST] Great Artists, and [ICON_GREATMUSICIAN] Great Musicians accumulate points +50% faster. Tourism performance from Great Works is +300%."),
  ("LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_NORMAL_AGE",                            "Each activation of a [ICON_GREATWORK_WRITING] Writing, [ICON_GREATWORK_LANDSCAPE] Art or [ICON_GREATWORK_MUSIC] Music Great Work in a city provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_DARK_AGE",                              "Each activation of a [ICON_GREATWORK_WRITING] Writing, [ICON_GREATWORK_LANDSCAPE] Art or [ICON_GREATWORK_MUSIC] Music Great Work in a city provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Scientific Revolution
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION",                                   "Scientific Revolution"),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_GOLDEN_AGE",                  "[ICON_GREATSCIENTIST] Great Scientists accumulate points +30% faster. [ICON_SCIENCE] Science from [ICON_TechBoosted] Eureka moments is +5%."),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_NORMAL_AGE",                  "Each research of an Industrial Era or later technology provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_DARK_AGE",                    "Each research of an Industrial Era or later technology provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ------------------------------------------------
  -- Illuminated City
  ("LOC_MOMENT_CATEGORY_ILLUMINATED_CITY",                                        "Illuminated City"),
  ("LOC_MOMENT_CATEGORY_ILLUMINATED_CITY_BONUS_GOLDEN_AGE",                       "When purchasing buildings that provide [ICON_POWER] power, the cost is reduced by 50%. The [ICON_POWER] powered basic and regional yields from buildings or wonders are increased by +8. If city is fully [ICON_POWER] powered, the regional range of all districts reach 3 tiles farther."),
  ("LOC_MOMENT_CATEGORY_ILLUMINATED_CITY_BONUS_NORMAL_AGE",                       "Each construction of a building or wonder providing or consuming [ICON_POWER] power provides +2 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_ILLUMINATED_CITY_BONUS_DARK_AGE",                         "Each construction of a building or wonder providing or consuming [ICON_POWER] power provides +2 [ICON_GLORY_NORMAL_AGE] Era Scores."),

  -- Capital Export
  ("LOC_MOMENT_CATEGORY_CAPITAL_EXPORT",                                          "Capital Export"),
  ("LOC_MOMENT_CATEGORY_CAPITAL_EXPORT_BONUS_GOLDEN_AGE",                         "When you start a [ICON_TRADEROUTE] Trade Route to a City-State, send 2 [ICON_ENVOY] Envoys to this City-State. +3 [ICON_PRODUCTION] Production, [ICON_SCIENCE] Science, [ICON_CULTURE] Culture and [ICON_GOLD] Gold to your international [ICON_TRADEROUTE] Trade Routes; these bonuses are doubled for [ICON_TRADEROUTE] Trade Routes across multiple continents."),
  ("LOC_MOMENT_CATEGORY_CAPITAL_EXPORT_BONUS_NORMAL_AGE",                         "Provide +3 [ICON_GLORY_NORMAL_AGE] Era Scores for each time an International [ICON_TRADEROUTE] Trade Route is established between cities on different continents."),
  ("LOC_MOMENT_CATEGORY_CAPITAL_EXPORT_BONUS_DARK_AGE",                           "Provide +3 [ICON_GLORY_NORMAL_AGE] Era Scores for each time an International [ICON_TRADEROUTE] Trade Route is established between cities on different continents."),

  -- World War
  ("LOC_MOMENT_CATEGORY_WORLD_WAR",                                               "World War"),
  ("LOC_MOMENT_CATEGORY_WORLD_WAR_BONUS_GOLDEN_AGE",                              "Grant a free [ICON_GREATGENERAL] Great General. +100% accumulation rate for [ICON_GREATGENERAL] Great General Points. +7 [ICON_STRENGTH] Combat Strength to Corps and Armies. +10% [ICON_PRODUCTION] Production to cities with Encampment district."),
  ("LOC_MOMENT_CATEGORY_WORLD_WAR_BONUS_NORMAL_AGE",                              "Provide +1 [ICON_GLORY_NORMAL_AGE] Era Score for each time Corps or Armies kill an enemy."),
  ("LOC_MOMENT_CATEGORY_WORLD_WAR_BONUS_DARK_AGE",                                "Provide +1 [ICON_GLORY_NORMAL_AGE] Era Score for each time Corps or Armies kill an enemy."),

  -- All's Fair in War
  ("LOC_MOMENT_CATEGORY_ESPIONAGE",                                               "Bodyguard of Lies"),
  ("LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_GOLDEN_AGE",                              "+3 Spy capacity and gain 3 free Spies. Each time your Spies get promoted, they will immediately receive another promotion until they reach the maximum level. Spies deployed to cities of other civilizations require no time. Time for completing offensive missions is reduced by 25%."),
  ("LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_NORMAL_AGE",                              "Each successful offensive espionage mission provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_DARK_AGE",                                "Each successful offensive espionage mission provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ------------------------------------------------
  -- Star War
  ("LOC_MOMENT_CATEGORY_STAR_WAR",                                                "Star War"),
  ("LOC_MOMENT_CATEGORY_STAR_WAR_BONUS_GOLDEN_AGE",                               "+30% building speed toward Spaceport districts and Space Race projects. Each Spaceport district provides +10% accumulation rate for [ICON_GREATSCIENTIST] Great Scientists and [ICON_GREATENGINEER] Great Engineers Points."),
  ("LOC_MOMENT_CATEGORY_STAR_WAR_BONUS_NORMAL_AGE",                               "Each construction of Spaceport districts provides +3 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_STAR_WAR_BONUS_DARK_AGE",                                 "Each construction of Spaceport districts provides +3 [ICON_GLORY_NORMAL_AGE] Era Scores."),

  -- Ideology Storm
  ("LOC_MOMENT_CATEGORY_IDEOLOGY_STORM",                                          "Ideology Storm"),
  ("LOC_MOMENT_CATEGORY_IDEOLOGY_STORM_BONUS_GOLDEN_AGE",                         "Awards 1 freely-chosen free civic. (To choose the Civic to be awarded, please click on the Civic icon on the Civic tree.) [ICON_CULTURE] Culture from [ICON_Civicboosted] Inspirations +10%. Government Plaza Tier 3 buildings provide +5% [ICON_TOURISM] Tourism across your empire"),
  ("LOC_MOMENT_CATEGORY_IDEOLOGY_STORM_BONUS_NORMAL_AGE",                         "Each recruitment of a [ICON_GREATPERSON] Great Person provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_IDEOLOGY_STORM_BONUS_DARK_AGE",                           "Each recruitment of a [ICON_GREATPERSON] Great Person provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Mega Corporation
  ("LOC_MOMENT_CATEGORY_MEGA_CORPORATION",                                        "Mega Corporation"),
  ("LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_GOLDEN_AGE",                       "Grant 2 free [ICON_GREATMERCHANT] Great Merchants. Cities with a Commercial Hub Tier 4 building can build one more district than the [ICON_CITIZEN] Population limit allows, receive +20% [ICON_PRODUCTION] Production and purchase districts, buildings, or units at -20% cost."),
  ("LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_NORMAL_AGE",                       "Each construction of buildings in Commercial Hub districts provides +1 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_DARK_AGE",                         "Each construction of buildings in Commercial Hub districts provides +1 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_GOLDEN_AGE_CORP",                  "Grant 2 free [ICON_GREATMERCHANT] Great Merchants. Cities with a Corporation can build one more district than the [ICON_CITIZEN] Population limit allows, receive +20% [ICON_PRODUCTION] Production and purchase districts, buildings, or units at -20% cost."),
  ("LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_NORMAL_AGE_CORP",                  "Each construction of Industry or Corporation provides +3 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_DARK_AGE_CORP",                    "Each construction of Industry or Corporation provides +3 [ICON_GLORY_NORMAL_AGE] Era Scores."),

  -- Universal Conscription
  ("LOC_MOMENT_CATEGORY_MILITARY",                                                "To Arms!"),
  ("LOC_MOMENT_CATEGORY_MILITARY_BONUS_GOLDEN_AGE",                               "Unlock a special war casus belli, enabling immediate declaration of war after denouncing a target, with [ICON_STAT_GRIEVANCE] Grievance -75%. Military units gain +7 [ICON_STRENGTH] Combat Strength and +2 [ICON_MOVEMENT] Movement. Production of military units is +100% [ICON_PRODUCTION] faster."),
  ("LOC_MOMENT_CATEGORY_MILITARY_BONUS_NORMAL_AGE",                               "In battle, each non-barbarian Legion killed provides +1 [ICON_GLORY_NORMAL_AGE] Era Score, each non-barbarian Army killed provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_MILITARY_BONUS_DARK_AGE",                                 "In battle, each non-barbarian Legion killed provides +1 [ICON_GLORY_NORMAL_AGE] Era Score, each non-barbarian Army killed provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_MILITARY_STRENGTH_DESCRIPTION",                     "Focus point “{LOC_MOMENT_CATEGORY_MILITARY}”: +7 [ICON_STRENGTH] Combat Strength. +2 [ICON_MOVEMENT] Movement."),
  ("LOC_COMMEMORATION_MILITARY_STRENGTH_MODIFIER_TEXT",                           "From focus point “{LOC_MOMENT_CATEGORY_MILITARY}”"),
  ------------------------------------------------
  -- Digital Revolution
  ("LOC_MOMENT_CATEGORY_DIGITAL_REVOLUTION",                                      "Digital Revolution"),
  ("LOC_MOMENT_CATEGORY_DIGITAL_REVOLUTION_BONUS_GOLDEN_AGE",                     "Grant a free [ICON_GREATSCIENTIST] Great Scientist. +20% [ICON_SCIENCE] Science to cities with Campus Tier 4 buildings."),
  ("LOC_MOMENT_CATEGORY_DIGITAL_REVOLUTION_BONUS_NORMAL_AGE",                     "Each research of an Information Era or later technology provides +3 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_DIGITAL_REVOLUTION_BONUS_DARK_AGE",                       "Each research of an Information Era or later technology provides +3 [ICON_GLORY_NORMAL_AGE] Era Scores."),

  -- World Market
  ("LOC_MOMENT_CATEGORY_WORLD_MARKET",                                            "World Market"),
  ("LOC_MOMENT_CATEGORY_WORLD_MARKET_BONUS_GOLDEN_AGE",                           "International [ICON_TRADEROUTE] Trade Routes receive +50% towards all yields. +15% [ICON_Tourism] Tourism output to civilizations to which you have a [ICON_TradeRoute] Trade Route."),
  ("LOC_MOMENT_CATEGORY_WORLD_MARKET_BONUS_NORMAL_AGE",                           "Provide +3 [ICON_GLORY_NORMAL_AGE] Era Scores for each time an International [ICON_TRADEROUTE] Trade Route is established."),
  ("LOC_MOMENT_CATEGORY_WORLD_MARKET_BONUS_DARK_AGE",                             "Provide +3 [ICON_GLORY_NORMAL_AGE] Era Scores for each time an International [ICON_TRADEROUTE] Trade Route is established."),

  -- Cyberculture
  ("LOC_MOMENT_CATEGORY_CYBERCULTURE",                                            "Cyberculture"),
  ("LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_GOLDEN_AGE",                           "When purchasing Internet Company or Rock Band, the cost is reduced by 50%. +20% [ICON_CULTURE] Culture and [ICON_GOLD] Gold to cities with Internet Company. Each Internet Company provides +100% [ICON_TOURISM] Tourism to Greatworks in all cities."),
  ("LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_NORMAL_AGE",                           "Each activation of a Great Work in a city provides +2 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_DARK_AGE",                             "Each activation of a Great Work in a city provides +2 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_GOLDEN_AGE_CORP",                      "When purchasing Internet Company or Rock Band, the cost is reduced by 50%. +20% [ICON_CULTURE] Culture and [ICON_GOLD] Gold to cities with Internet Company. Each Internet Company provides +100% [ICON_TOURISM] Tourism to Greatworks and [ICON_GREATWORK_PRODUCT] Products in all cities."),
  ("LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_NORMAL_AGE_CORP",                      "Each activation of a Great Work or [ICON_GREATWORK_PRODUCT] Product in a city provides +2 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_DARK_AGE_CORP",                        "Each activation of a Great Work or [ICON_GREATWORK_PRODUCT] Product in a city provides +2 [ICON_GLORY_NORMAL_AGE] Era Scores."),

  -- Military-Industrial Complex
  ("LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX",                             "Military-Industrial Complex"),
  ("LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX_BONUS_GOLDEN_AGE",            "Each city with Encampment and Industrial Zone district provide +10 Influence points per turn and +3 [ICON_STRENGTH] Combat Strength to all military units. Combat victories provide [ICON_SCIENCE] Science and [ICON_GOLD] Gold equal to 200% of the [ICON_STRENGTH] Combat Strength of the defeated unit."),
  ("LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX_BONUS_NORMAL_AGE",            "Each constructed Encampment or Industrial Zone building provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX_BONUS_DARK_AGE",              "Each constructed Encampment or Industrial Zone building provides +2 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_ABILITY_COMMEMORATION_HD_MILITARY_INDUSTRIAL_COMPLEX_DESCRIPTION",        "Focus point “{LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX}”: +3 [ICON_STRENGTH] Combat Strength from each city with Encampment and Industrial Zone district. Combat victories provide [ICON_SCIENCE] Science and [ICON_GOLD] Gold equal to 200% of the [ICON_STRENGTH] Combat Strength of the defeated unit."),
  ("LOC_HD_COMMEMORATION_HD_MILITARY_INDUSTRIAL_COMPLEX_STRENGTH_TEXT",           "+{Property} from Focus point “{LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX}”"),
  ------------------------------------------------
  -- Space Travel
  ("LOC_MOMENT_CATEGORY_TOURISM",                                                 "Space Travel"),
  ("LOC_MOMENT_CATEGORY_TOURISM_BONUS_GOLDEN_AGE",                                "+5 [ICON_MOVEMENT] movement if starting turn in friendly territory. [ICON_TOURISM] Tourism performance from improvements, wonders, and national parks is +500%."),
  ("LOC_MOMENT_CATEGORY_TOURISM_BONUS_NORMAL_AGE",                                "Each artifact discovered provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_TOURISM_BONUS_DARK_AGE",                                  "Each artifact discovered provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Cosmic Exploitation
  ("LOC_MOMENT_CATEGORY_COSMIC_EXPLOITATION",                                     "Cosmic Exploitation"),
  ("LOC_MOMENT_CATEGORY_COSMIC_EXPLOITATION_BONUS_GOLDEN_AGE",                    "Each completed unrepeatable Space Race project provides +10% all yields to all cities permanently. Improved resources provide +10 [ICON_SCIENCE] Science for each copy the city owns."),
  ("LOC_MOMENT_CATEGORY_COSMIC_EXPLOITATION_BONUS_NORMAL_AGE",                    "Each completed Space Race project provide +5 [ICON_GLORY_NORMAL_AGE] Era Scores."),
  ("LOC_MOMENT_CATEGORY_COSMIC_EXPLOITATION_BONUS_DARK_AGE",                      "Each completed Space Race project provide +5 [ICON_GLORY_NORMAL_AGE] Era Scores."),

  -- Artificial Intelligence
  ("LOC_MOMENT_CATEGORY_AERONAUTICAL",                                            "Artificial Intelligence"),
  ("LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_EXPANSION2_GOLDEN_AGE",                "Triggers the [ICON_TECHBOOSTED] Eureka moment for all technologies. Awards 1 freely-chosen free technology. (To choose the technology to be awarded, please click on the technology icon on the technology tree.) +50% [ICON_PRODUCTION] Production to all cities."),
  ("LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_NORMAL_AGE",                           "Each construction of an Airbase building provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_DARK_AGE",                             "Each construction of an Airbase building provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),

  -- Robot Wars
  ("LOC_MOMENT_CATEGORY_AUTOMATON",                                               "Automaton Warfare"),
  ("LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_GOLDEN_AGE",                              "One Doomsday Mech appears in the capital. Gain 3 [ICON_RESOURCE_URANIUM] Uranium per turn. Each turn, collect +1 [ICON_RESOURCE_URANIUM] Uranium."),
  ("LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_NORMAL_AGE",                              "Each kill of a non-barbarian unit with the Doomsday Mech provides +1 [ICON_GLORY_NORMAL_AGE] Era Score."),
  ("LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_DARK_AGE",                                "Each kill of a non-barbarian unit with the Doomsday Mech provides +1 [ICON_GLORY_NORMAL_AGE] Era Score.");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
  (Language,      Tag,                                                                            Text)
values
  ("zh_Hans_CN",  "LOC_MOMENT_ACTION_PANEL_TEXT",                                                 "{1_Name}：{2_Bonus}"),
  ("zh_Hans_CN",  "LOC_MOMENT_CIVILOPEDIA_TEXT",                                                  "[ICON_GLORY_NORMAL_AGE] 普通时代：{1_NormalBonus}[NEWLINE][NEWLINE][ICON_GLORY_GOLDEN_AGE] 黄金时代：{2_GoldenBonus}"),
  -- 自然哲学
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC",                                               "自然哲学"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_GOLDEN_AGE",                              "学院、港口和水渠+1 [ICON_SCIENCE] 科技值和+1 [ICON_CULTURE] 文化值。每次触发 [ICON_TECHBOOSTED] 尤里卡，获得10点 [ICON_GREATSCIENTIST] 大科学家点数。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_NORMAL_AGE",                              "每次触发 [ICON_TECHBOOSTED] 尤里卡+1 [ICON_GLORY_NORMAL_AGE] 时代得分。建造以科技值为基础产出的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_BONUS_DARK_AGE",                                "每次触发 [ICON_TECHBOOSTED] 尤里卡+1 [ICON_GLORY_NORMAL_AGE] 时代得分。建造以科技值为基础产出的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 轴心时代
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CULTURAL",                                                 "轴心时代"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CULTURAL_BONUS_GOLDEN_AGE",                                "每个区域+1 [ICON_CULTURE] 文化值和+1 [ICON_FAITH] 信仰值。专业化区域+3 [ICON_GREATWRITER] 大作家点数。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CULTURAL_BONUS_NORMAL_AGE",                                "每次触发 [ICON_CIVICBOOSTED] 鼓舞+1 [ICON_GLORY_NORMAL_AGE] 时代得分。建成拥有巨作槽位的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CULTURAL_BONUS_DARK_AGE",                                  "每次触发 [ICON_CIVICBOOSTED] 鼓舞+1 [ICON_GLORY_NORMAL_AGE] 时代得分。建成拥有巨作槽位的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 雄伟壮丽
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INFRASTRUCTURE",                                           "雄伟壮丽"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_GOLDEN_AGE",                          "[ICON_CAPITAL] 首都+1区域位。建造远古、古典和中世纪奇观+10%建造速度。拥有奇观的城市+10% [ICON_FOOD] 食物和 [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_NORMAL_AGE",                          "每修建1座新区域+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INFRASTRUCTURE_BONUS_DARK_AGE",                            "每修建1座新区域+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 光荣胜利
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS",                                                "光荣胜利"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_GOLDEN_AGE",                               "侦察单位和海军袭击者单位+1 [ICON_MOVEMENT] 移动力和+1视野。军事单位+2 [ICON_STRENGTH] 战斗力。摧毁 [ICON_Barbarian] 蛮族哨站时+50 [ICON_GOLD] 金币。征服城市时获得一次部落村庄奖励。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_NORMAL_AGE",                               "每摧毁1个 [ICON_Barbarian] 蛮族哨站+1 [ICON_GLORY_NORMAL_AGE] 时代得分。每征服1座城市+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_BONUS_DARK_AGE",                                 "每摧毁1个 [ICON_Barbarian] 蛮族哨站+1 [ICON_GLORY_NORMAL_AGE] 时代得分。每征服1座城市+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_SPEED_SIGHT_DESCRIPTION",             "着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS}”：+1 [ICON_MOVEMENT] 移动力。+1视野。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_STRENGTH_MODIFIER_TEXT",              "来自着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS}”"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_RELIGIOUS_UNIT_STRENGTH_DESCRIPTION",                "着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS}”：+2 [ICON_Strength] 战斗力。"),
  ------------------------------------------------
  -- 翻译运动
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT",                                     "翻译运动"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_GOLDEN_AGE",                    "建造学院、剧院广场和这些区域中的建筑时+30%建造速度。为 [ICON_TechBoosted] 尤里卡提供的 [ICON_SCIENCE] 科技值+3%，为 [ICON_Civicboosted] 鼓舞提供的 [ICON_CULTURE] 文化值+3%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_NORMAL_AGE",                    "每招募1位 [ICON_GREATSCIENTIST] 大科学家、[ICON_GREATWRITER] 大作家、[ICON_GREATARTIST] 大艺术家或 [ICON_GREATMUSICIAN] 大音乐家+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TRANSLATION_MOVEMENT_BONUS_DARK_AGE",                      "每招募1位 [ICON_GREATSCIENTIST] 大科学家、[ICON_GREATWRITER] 大作家、[ICON_GREATARTIST] 大艺术家或 [ICON_GREATMUSICIAN] 大音乐家+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 繁荣之路
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_FLOURSHING_ROAD",                                          "繁荣之路"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_GOLDEN_AGE",                         "+50%工业区、商业中心和港口相邻加成。所有国际 [ICON_TRADEROUTE] 贸易路线+1 [ICON_SCIENCE] 科技值、+1 [ICON_CULTURE] 文化值+6 [ICON_GOLD] 金币。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_NORMAL_AGE",                         "每完成1条 [ICON_TRADEROUTE] 贸易路线+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_FLOURSHING_ROAD_BONUS_DARK_AGE",                           "每完成1条 [ICON_TRADEROUTE] 贸易路线+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 筚路蓝缕
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DOMESTIC_ASSART",                                          "筚路蓝缕"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_GOLDEN_AGE",                         "平民单位+2 [ICON_MOVEMENT] 移动力。新建立的城市获得1个免费的建造者。每种改良的资源为所在城市+1 [ICON_FOOD] 食物和+1 [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_NORMAL_AGE",                         "每改良1处资源+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DOMESTIC_ASSART_BONUS_DARK_AGE",                           "每改良1处资源+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_DOMESTIC_ASSART_CIVILIAN_SPEED_DESCRIPTION",      "着力点“{LOC_MOMENT_CATEGORY_DOMESTIC_ASSART}”：+2 [ICON_MOVEMENT] 移动力。"),
  -- 信仰之战
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_WAR",                                            "信仰之战"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_GOLDEN_AGE",                           "军事单位+1 [ICON_MOVEMENT] 移动力。宗教单位+2 [ICON_MOVEMENT] 移动力和+2使用次数。与异教文明的单位作战时+5 [ICON_STRENGTH] 战斗力。掠夺和海岸扫荡的收益+50%。对改良发起掠夺或海岸扫荡时将获得额外等额的 [ICON_SCIENCE] 科技值。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_NORMAL_AGE",                           "首次使一座城市信奉您创立的宗教+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_WAR_BONUS_DARK_AGE",                             "首次使一座城市信奉您创立的宗教+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_MILITARY_SPEED_DESCRIPTION",        "着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”：+1 [ICON_MOVEMENT] 移动力。与异教文明的单位作战时+5 [ICON_STRENGTH] 战斗力。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_SPEED_DESCRIPTION",       "着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”：+2 [ICON_MOVEMENT] 移动力。神学战争中+5 [ICON_RELIGION] 宗教战斗力。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_MILITARY_STRENGTH_TEXT",            "来自着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_STRENGTH_TEXT",           "来自着力点“{LOC_MOMENT_CATEGORY_RELIGIOUS_WAR}”"),
  ------------------------------------------------
  -- 开明专制
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM",                                    "开明专制"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_GOLDEN_AGE",                   "永久获得一个通配符政策槽位。所有城市+1区域位。与市政广场{LOC_AND_DIPLOMATIC_QUARTER}相邻的区域+50%相邻加成。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_NORMAL_AGE",                   "每建造1座社区、市政广场{LOC_AND_DIPLOMATIC_QUARTER}中的建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ENLIGHTENED_DESPOTISM_BONUS_DARK_AGE",                     "每建造1座社区、市政广场{LOC_AND_DIPLOMATIC_QUARTER}中的建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 原始积累
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ECONOMIC",                                                 "原始积累"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_GOLDEN_AGE",                                "[ICON_GREATENGINEER] 大工程师和 [ICON_GREATMERCHANT] 大商人点数积累速度+50%。所有 [ICON_TRADEROUTE] 贸易路线+2 [ICON_PRODUCTION] 生产力和+6 [ICON_GOLD] 金币。购买区域、建筑或单位时费用-10%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_NORMAL_AGE",                                "每招募1位 [ICON_GREATENGINEER] 大工程师和 [ICON_GREATMERCHANT] 大商人+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ECONOMIC_BONUS_DARK_AGE",                                  "每招募1位 [ICON_GREATENGINEER] 大工程师和 [ICON_GREATMERCHANT] 大商人+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 宗教改革
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM",                                         "宗教改革"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_GOLDEN_AGE",                        "+100%圣地相邻加成。拥有祭祀建筑的城市+10% [ICON_SCIENCE] 科技值、[ICON_CULTURE] 文化值和 [ICON_FAITH] 信仰值。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_NORMAL_AGE",                        "每建造1座圣地建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_RELIGIOUS_REFORM_BONUS_DARK_AGE",                          "每建造1座圣地建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 此处有龙
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_EXPLORATION",                                              "此处有龙"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_GOLDEN_AGE",                             "平民、海军和水运单位+2 [ICON_MOVEMENT] 移动力。新建立的城市+3 [ICON_CITIZEN] 人口。没有专业化区域的城市建造区域时+100%建造速度。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_NORMAL_AGE",                             "每发现1个新大陆或自然奇观+3 [ICON_GLORY_NORMAL_AGE] 时代得分。在战斗中每击杀1个非蛮族海军单位+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_EXPLORATION_BONUS_DARK_AGE",                               "每发现1个新大陆或自然奇观+3 [ICON_GLORY_NORMAL_AGE] 时代得分。在战斗中每击杀1个非蛮族海军单位+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_EXPLORATION_CIVILIAN_SPEED_DESCRIPTION",             "着力点“{LOC_MOMENT_CATEGORY_EXPLORATION}”：+2 [ICON_MOVEMENT] 移动力。"),
  ------------------------------------------------
  -- 滚滚蒸汽
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INDUSTRIAL",                                               "滚滚蒸汽"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_GOLDEN_AGE",                              "建造工业时代或以后的奇观+25%建造速度。工业区建筑的基础产出和辐射产出+50%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_NORMAL_AGE",                              "每建造1座工业时代或以后的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INDUSTRIAL_BONUS_DARK_AGE",                                "每建造1座工业时代或以后的建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 国际体系
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INTERNATIONAL_SYSTEM",                                     "国际体系"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INTERNATIONAL_SYSTEM_BONUS_GOLDEN_AGE",                    "+100%影响力点数。从宗主城邦获得的 [ICON_FAVOR] 外交支持+100%。通往盟友城市或宗主城邦的 [ICON_TRADEROUTE] 贸易路线+4 [ICON_SCIENCE] 科技值、[ICON_CULTURE] 文化值和 [ICON_GOLD] 金币。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INTERNATIONAL_SYSTEM_BONUS_NORMAL_AGE",                    "每次建立通往盟友城市或宗主城邦的 [ICON_TRADEROUTE] 贸易路线时+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_INTERNATIONAL_SYSTEM_BONUS_DARK_AGE",                      "每次建立通往盟友城市或宗主城邦的 [ICON_TRADEROUTE] 贸易路线时+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 浪漫主义
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ROMANTICISM",                                              "浪漫主义"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_GOLDEN_AGE",                             "[ICON_GREATWRITER] 大作家、[ICON_GREATARTIST] 大艺术家和 [ICON_GREATMUSICIAN] 大音乐家点数积累速度+50%。来自巨作的 [ICON_TOURISM] 旅游业绩+300%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_NORMAL_AGE",                             "每次在城市中创作 [ICON_GREATWORK_WRITING] 著作、[ICON_GREATWORK_LANDSCAPE] 艺术或 [ICON_GREATWORK_MUSIC] 音乐巨作+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ROMANTICISM_BONUS_DARK_AGE",                               "每次在城市中创作 [ICON_GREATWORK_WRITING] 著作、[ICON_GREATWORK_LANDSCAPE] 艺术或 [ICON_GREATWORK_MUSIC] 音乐巨作+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 科学革命
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION",                                    "科学革命"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_GOLDEN_AGE",                   "[ICON_GREATSCIENTIST] 大科学家点数积累速度+30%。为 [ICON_TechBoosted] 尤里卡提供的 [ICON_SCIENCE] 科技值+5%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_NORMAL_AGE",                   "每研究1项工业时代或以后科技+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_SCIENTIFIC_REVOLUTION_BONUS_DARK_AGE",                     "每研究1项工业时代或以后科技+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ------------------------------------------------
  -- 灯火通明
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ILLUMINATED_CITY",                                         "灯火通明"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ILLUMINATED_CITY_BONUS_GOLDEN_AGE",                        "购买提供 [ICON_POWER] 电力的建筑时费用降低50%。建筑或奇观 [ICON_POWER] 通电的基础和辐射产出额外+8。若城市 [ICON_POWER] 供电充足，则所有区域的辐射范围+3。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ILLUMINATED_CITY_BONUS_NORMAL_AGE",                        "每建造1座需要或提供 [ICON_POWER] 电力的建筑或奇观+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ILLUMINATED_CITY_BONUS_DARK_AGE",                          "每建造1座需要或提供 [ICON_POWER] 电力的建筑或奇观+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 资本输出
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CAPITAL_EXPORT",                                           "资本输出"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CAPITAL_EXPORT_BONUS_GOLDEN_AGE",                          "通往城邦的 [ICON_TRADEROUTE] 贸易路线将向该城邦派遣2位 [ICON_ENVOY] 使者。国际 [ICON_TRADEROUTE] 贸易路线提供+3 [ICON_PRODUCTION] 生产力、[ICON_SCIENCE] 科技值、[ICON_CULTURE] 文化值和 [ICON_GOLD] 金币；如 [ICON_TRADEROUTE] 贸易路线横跨多个大陆则该收益翻倍。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CAPITAL_EXPORT_BONUS_NORMAL_AGE",                          "每次在不同大陆的城市间建立国际 [ICON_TRADEROUTE] 贸易路线时+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CAPITAL_EXPORT_BONUS_DARK_AGE",                            "每次在不同大陆的城市间建立国际 [ICON_TRADEROUTE] 贸易路线时+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 世界大战
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_WORLD_WAR",                                                "世界大战"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_WORLD_WAR_BONUS_GOLDEN_AGE",                               "获得一个 [ICON_GREATGENERAL] 大将军。玩家的 [ICON_GREATGENERAL] 大将军点数积累速度+100%。军团和军队+7 [ICON_STRENGTH] 战斗力。拥有军营的城市+10% [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_WORLD_WAR_BONUS_NORMAL_AGE",                               "军团和军队每击杀一个单位+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_WORLD_WAR_BONUS_DARK_AGE",                                 "军团和军队每击杀一个单位+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 兵不厌诈
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ESPIONAGE",                                                "兵不厌诈"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_GOLDEN_AGE",                               "获得3个间谍容量和3个间谍。你的间谍每完成一次晋升后，立即获得一次晋升，直到升至满级。间谍部署到另一文明的城市无需时间。完成进攻性任务的时间缩短25%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_NORMAL_AGE",                               "每次进攻性间谍行动成功+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_ESPIONAGE_BONUS_DARK_AGE",                                 "每次进攻性间谍行动成功+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ------------------------------------------------
  -- 星球大战
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_STAR_WAR",                                                 "星球大战"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_STAR_WAR_BONUS_GOLDEN_AGE",                                "建造宇航中心和太空竞赛项目时+30%建造速度。每座宇航中心使玩家的 [ICON_GREATSCIENTIST] 大科学家和 [ICON_GREATENGINEER] 大工程师点数积累速度+10%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_STAR_WAR_BONUS_NORMAL_AGE",                                "每建造1座宇航中心+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_STAR_WAR_BONUS_DARK_AGE",                                  "每建造1座宇航中心+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 思想风暴
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_IDEOLOGY_STORM",                                           "思想风暴"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_IDEOLOGY_STORM_BONUS_GOLDEN_AGE",                          "可点击市政树上的市政图标来选择奖励1项当前可以研究的市政。为 [ICON_Civicboosted] 鼓舞提供的 [ICON_CULTURE] 文化值+10%。市政广场三级建筑使全境内+20% [ICON_TOURISM] 旅游业绩。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_IDEOLOGY_STORM_BONUS_NORMAL_AGE",                          "每招募1位 [ICON_GREATPERSON] 伟人+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_IDEOLOGY_STORM_BONUS_DARK_AGE",                            "每招募1位 [ICON_GREATPERSON] 伟人+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 巨型企业
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MEGA_CORPORATION",                                         "巨型企业"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_GOLDEN_AGE",                        "获得2个 [ICON_GREATMERCHANT] 大商人。拥有商业中心四级建筑的城市+1区域位，+20% [ICON_PRODUCTION] 生产力，且购买区域、建筑或单位时费用-20%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_NORMAL_AGE",                        "每建造1座商业中心建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_DARK_AGE",                          "每建造1座商业中心建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_GOLDEN_AGE_CORP",                   "获得2个 [ICON_GREATMERCHANT] 大商人。拥有公司的城市+1区域位，+20% [ICON_PRODUCTION] 生产力，且购买区域、建筑或单位时费用-20%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_NORMAL_AGE_CORP",                   "每建造1座行业或公司+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MEGA_CORPORATION_BONUS_DARK_AGE_CORP",                     "每建造1座行业或公司+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 全民皆兵
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY",                                                 "全民皆兵"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_BONUS_GOLDEN_AGE",                                "解锁特殊战争借口，谴责目标后可立即宣战，[ICON_STAT_GRIEVANCE] 不满-75%。军事单位+7 [ICON_STRENGTH] 战斗力，+2 [ICON_MOVEMENT] 移动力。生产军事单位时+100% [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_BONUS_NORMAL_AGE",                                "在战斗中每击杀1个非蛮族军团+1 [ICON_GLORY_NORMAL_AGE] 时代得分、每击杀1个非蛮族军队+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_BONUS_DARK_AGE",                                  "在战斗中每击杀1个非蛮族军团+1 [ICON_GLORY_NORMAL_AGE] 时代得分、每击杀1个非蛮族军队+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_MILITARY_STRENGTH_DESCRIPTION",                      "着力点“{LOC_MOMENT_CATEGORY_MILITARY}”：+7 [ICON_STRENGTH] 战斗力，+2 [ICON_MOVEMENT] 移动力。"),
  ("zh_Hans_CN",  "LOC_COMMEMORATION_MILITARY_STRENGTH_MODIFIER_TEXT",                            "来自着力点“{LOC_MOMENT_CATEGORY_MILITARY}”"),
  ------------------------------------------------
  -- 数字革命
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DIGITAL_REVOLUTION",                                       "数字革命"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DIGITAL_REVOLUTION_BONUS_GOLDEN_AGE",                      "获得1个 [ICON_GREATSCIENTIST] 大科学家。有学院四级建筑的城市+20% [ICON_SCIENCE] 科技值。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DIGITAL_REVOLUTION_BONUS_NORMAL_AGE",                      "每研究1项信息时代或以后科技+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_DIGITAL_REVOLUTION_BONUS_DARK_AGE",                        "每研究1项信息时代或以后科技+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 全球市场
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_WORLD_MARKET",                                             "全球市场"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_WORLD_MARKET_BONUS_GOLDEN_AGE",                            "国际 [ICON_TRADEROUTE] 贸易路线产出+50%。向有 [ICON_TradeRoute] 贸易路线连接的文明输出的 [ICON_Tourism] 旅游业绩+15%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_WORLD_MARKET_BONUS_NORMAL_AGE",                            "建立国际 [ICON_TRADEROUTE] 贸易路线时+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_WORLD_MARKET_BONUS_DARK_AGE",                              "建立国际 [ICON_TRADEROUTE] 贸易路线时+3 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 网络娱乐
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CYBERCULTURE",                                             "网络娱乐"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_GOLDEN_AGE",                            "购买互联网公司或摇滚乐队时费用降低50%。有互联网公司的城市+20% [ICON_CULTURE] 文化值和 [ICON_GOLD] 金币。每座互联网公司使境内巨作提供的 [ICON_Tourism] 旅游业绩+100%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_NORMAL_AGE",                            "每次在城市中创作一个巨作+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_DARK_AGE",                              "每次在城市中创作一个巨作+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_GOLDEN_AGE_CORP",                       "购买互联网公司或摇滚乐队时费用降低50%。有互联网公司的城市+20% [ICON_CULTURE] 文化值和 [ICON_GOLD] 金币。每座互联网公司使境内巨作和 [ICON_GreatWork_Product] 产品提供的 [ICON_Tourism] 旅游业绩+100%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_NORMAL_AGE_CORP",                       "每次在城市中创作一个巨作或 [ICON_GreatWork_Product] 产品+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_CYBERCULTURE_BONUS_DARK_AGE_CORP",                         "每次在城市中创作一个巨作或 [ICON_GreatWork_Product] 产品+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 军工复合
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX",                              "军工复合"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX_BONUS_GOLDEN_AGE",             "每座同时拥有军营和工业区的城市为所有军事单位+3 [ICON_STRENGTH] 战斗力，并+10影响力点数。战斗胜利后，获得等同于被击杀单位 [ICON_STRENGTH] 战斗力200%的 [ICON_SCIENCE] 科技值和 [ICON_GOLD] 金币。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX_BONUS_NORMAL_AGE",             "每建造1座军营或工业区建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX_BONUS_DARK_AGE",               "每建造1座军营或工业区建筑+2 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_ABILITY_COMMEMORATION_HD_MILITARY_INDUSTRIAL_COMPLEX_DESCRIPTION",         "着力点“{LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX}”：从每座同时拥有军营和工业区的城市获得+3 [ICON_STRENGTH] 战斗力。战斗胜利后，获得等同于被击杀单位 [ICON_STRENGTH] 战斗力200%的 [ICON_SCIENCE] 科技值和 [ICON_GOLD] 金币。"),
  ("zh_Hans_CN",  "LOC_HD_COMMEMORATION_HD_MILITARY_INDUSTRIAL_COMPLEX_STRENGTH_TEXT",            "+{Property} 来自着力点“{LOC_MOMENT_CATEGORY_MILITARY_INDUSTRIAL_COMPLEX}”"),
  ------------------------------------------------
  -- 空间旅行
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TOURISM",                                                  "空间旅行"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TOURISM_BONUS_GOLDEN_AGE",                                 "在友好领土开启回合+5 [ICON_MOVEMENT] 移动力。来自改良、奇观和国家公园的 [ICON_TOURISM] 旅游业绩+500%。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TOURISM_BONUS_NORMAL_AGE",                                 "每发掘1件文物+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_TOURISM_BONUS_DARK_AGE",                                   "每发掘1件文物+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 宇宙开发
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_COSMIC_EXPLOITATION",                                      "宇宙开发"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_COSMIC_EXPLOITATION_BONUS_GOLDEN_AGE",                     "每完成一个不可重复的太空竞赛项目，所有城市永久+10%所有产出。城市的每个已改良的资源会为城市提供 [ICON_SCIENCE] 科技值，其数值为10倍于本城改良的该种资源的份数。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_COSMIC_EXPLOITATION_BONUS_NORMAL_AGE",                     "每完成一个太空竞赛项目+5 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_COSMIC_EXPLOITATION_BONUS_DARK_AGE",                       "每完成一个太空竞赛项目+5 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 人工智能
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AERONAUTICAL",                                             "人工智能"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_EXPANSION2_GOLDEN_AGE",                 "解锁所有科技的 [ICON_TechBoosted] 尤里卡。可点击科技树上的科技图标来选择奖励1项当前可以研究的科技。所有城市+50% [ICON_PRODUCTION] 生产力。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_NORMAL_AGE",                            "每建造1座航空港建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AERONAUTICAL_BONUS_DARK_AGE",                              "每建造1座航空港建筑+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  -- 机甲战争
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AUTOMATON",                                                "机甲战争"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_GOLDEN_AGE",                               "首都中将出现1个末日机甲。每回合获得3点 [ICON_RESOURCE_URANIUM] 铀。每回合收集的 [ICON_RESOURCE_URANIUM] 铀矿资源+1。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_NORMAL_AGE",                               "每用末日机甲击杀1个非蛮族单位便+1 [ICON_GLORY_NORMAL_AGE] 时代得分。"),
  ("zh_Hans_CN",  "LOC_MOMENT_CATEGORY_AUTOMATON_BONUS_DARK_AGE",                                 "每用末日机甲击杀1个非蛮族单位便+1 [ICON_GLORY_NORMAL_AGE] 时代得分。");