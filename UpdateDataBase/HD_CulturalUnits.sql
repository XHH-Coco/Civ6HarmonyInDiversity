delete from UnitPromotions where UnitPromotionType="PROMOTION_ALBUM_COVER_ART";
delete from UnitPromotions where UnitPromotionType="PROMOTION_ARENA_ROCK";
delete from UnitPromotions where UnitPromotionType="PROMOTION_GLAM_ROCK";
delete from UnitPromotions where UnitPromotionType="PROMOTION_GOES_TO";
delete from UnitPromotions where UnitPromotionType="PROMOTION_INDIE";
delete from UnitPromotions where UnitPromotionType="PROMOTION_MUSIC_FESTIVAL";
delete from UnitPromotions where UnitPromotionType="PROMOTION_POP";
delete from UnitPromotions where UnitPromotionType="PROMOTION_REGGAE_ROCK";
delete from UnitPromotions where UnitPromotionType="PROMOTION_RELIGIOUS_ROCK";
delete from UnitPromotions where UnitPromotionType="PROMOTION_ROADIES";
delete from UnitPromotions where UnitPromotionType="PROMOTION_SPACE_ROCK";
delete from UnitPromotions where UnitPromotionType="PROMOTION_SURF_ROCK";

update Units set Maintenance="32" where UnitType = "UNIT_ROCK_BAND";
update Units set MustPurchase=0 where UnitType = "UNIT_ROCK_BAND";
update Units set CostProgressionParam1=200 where UnitType = "UNIT_ROCK_BAND";
update Units set NumRandomChoices=24 where UnitType = "UNIT_ROCK_BAND";
update Units set PurchaseYield="YIELD_GOLD" where UnitType = "UNIT_ROCK_BAND";
update Units_XP2 set TourismBomb="800" where UnitType = "UNIT_ROCK_BAND";
update GlobalParameters set Value="600" where Name = "TOURISM_BOMB_WONDER_ADDITIONAL";
update GlobalParameters set Value=6 where Name = "ROCK_BAND_MAX_LEVEL";
update GlobalParameters set Value=6 where Name = "ROCK_BAND_MAX_PROMOTIONS";

insert or replace into Requirements
    (RequirementId,                                             RequirementType)
values
	("REQUIRES_ROCK_BOMB_AOE_HD",								"REQUIREMENT_PLOT_ADJACENT_TO_OWNER");

insert or replace into RequirementArguments
    (RequirementId,                                     		Name,                       Value)
values
	('REQUIRES_ROCK_BOMB_AOE_HD',								'MinDistance',			    0),
	('REQUIRES_ROCK_BOMB_AOE_HD',								'MaxDistance',			    1);

insert or replace into RequirementSets
    (RequirementSetId,                                  		RequirementSetType)
values
    ("REQUIRESETS_ROCK_BOMB_AOE_HD",                    		"REQUIREMENTSET_TEST_ALL");

insert or replace into RequirementSetRequirements
    (RequirementSetId,                                  		RequirementId)
values
    ("REQUIRESETS_ROCK_BOMB_AOE_HD",                    		"REQUIRES_ROCK_BOMB_AOE_HD");

insert or replace into UnitAbilities
    (UnitAbilityType,                                   		Name,                                           Description)
values
    ("ABILITY_ORAL_SCHOLAR_BOMB_ALL_HD",                		"LOC_ABILITY_ORAL_SCHOLAR_BOMB_ALL_HD_NAME",    "LOC_ABILITY_ORAL_SCHOLAR_BOMB_ALL_HD_DESCRIPTION"),
    ("ABILITY_TRAVEL_THEATRE_BOMB_ALL_HD",              		"LOC_ABILITY_TRAVEL_THEATRE_BOMB_ALL_HD_NAME",  "LOC_ABILITY_TRAVEL_THEATRE_BOMB_ALL_HD_DESCRIPTION"),
    ("ABILITY_ROCK_BAND_BOMB_ALL_HD",                   		"LOC_ABILITY_ROCK_BAND_BOMB_ALL_HD_NAME",       "LOC_ABILITY_ROCK_BAND_BOMB_ALL_HD_DESCRIPTION"),

    ("ABILITY_ROCK_BASIC_YIELD_HD",                     		"LOC_ABILITY_ROCK_BASIC_YIELD_HD_NAME",         "LOC_ABILITY_ROCK_BASIC_YIELD_HD_DESCRIPTION"),
    ("ABILITY_MALI_GRIOTS_BASIC_YIELD_HD",              		"LOC_ABILITY_MALI_GRIOTS_BASIC_YIELD_HD_NAME",  "LOC_ABILITY_MALI_GRIOTS_BASIC_YIELD_HD_DESCRIPTION");

insert or replace into Types
	(Type,											    		Kind)
values
    ("ABILITY_ORAL_SCHOLAR_BOMB_ALL_HD",                		"KIND_ABILITY"),
    ("ABILITY_TRAVEL_THEATRE_BOMB_ALL_HD",              		"KIND_ABILITY"),
    ("ABILITY_ROCK_BAND_BOMB_ALL_HD",              				"KIND_ABILITY"),

    ("ABILITY_ROCK_BASIC_YIELD_HD",                     		"KIND_ABILITY"),
    ("ABILITY_MALI_GRIOTS_BASIC_YIELD_HD",              		"KIND_ABILITY");

insert or replace into TypeTags
    (Type,                                              		Tag)
values
    ("ABILITY_ORAL_SCHOLAR_BOMB_ALL_HD",              			"CLASS_ORAL_SCHOLAR_HD"),
    ("ABILITY_TRAVEL_THEATRE_BOMB_ALL_HD",              		"CLASS_TRAVEL_THEATRE_HD"),
    ("ABILITY_ROCK_BAND_BOMB_ALL_HD",              				"CLASS_ROCK_BAND_HD"),

    ("ABILITY_ROCK_BASIC_YIELD_HD",                     		"CLASS_ROCK_BAND"),
    ("ABILITY_MALI_GRIOTS_BASIC_YIELD_HD",              		"CLASS_MALI_GRIOTS_HD");

insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                                   		ModifierId)
values
    ("ABILITY_ORAL_SCHOLAR_BOMB_ALL_HD",                		"ORAL_SCHOLAR_TOURISM_BOMB_ALL_HD"),
    ("ABILITY_TRAVEL_THEATRE_BOMB_ALL_HD",              		"TRAVEL_THEATRE_TOURISM_BOMB_ALL_HD"),
    ("ABILITY_ROCK_BAND_BOMB_ALL_HD",                   		"ROCK_BAND_TOURISM_BOMB_ALL_HD"),

    ("ABILITY_ROCK_BASIC_YIELD_HD",                     		"HD_ROCK_BASIC_YIELD_GOLD"),
    ("ABILITY_ROCK_BASIC_YIELD_HD",                     		"HD_ROCK_BASIC_YIELD_CULTURE"),
    ("ABILITY_MALI_GRIOTS_BASIC_YIELD_HD",              		"HD_MALI_GRIOTS_BASIC_YIELD_GOLD");

insert or replace into DistrictModifiers
    (DistrictType,                                      		ModifierId)
values
    ("DISTRICT_CITY_CENTER",                            		"CITY_ENABLE_ROCK_BAND_FAITH_PURCHASE_HD");

insert or replace into Modifiers
    (ModifierId,                                        		ModifierType)
values
    ("ROCKBAND_MYSTICISM_WONDER_HD",                    		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_MYSTICISM_HOLY_SITE_HD",                 		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_MYSTICISM_LAVRA_HD",                     		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_MYSTICISM_NATIONAL_PARK_HD",             		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_NATIONAL_PARK"),
    ("ROCKBAND_MYSTICISM_NATURAL_WONDER_HD",            		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_NATURAL_WONDER"),
    ("ROCKBAND_CLASSICISM_HD",                          		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_CLASSICISM_ACROPOLIS_HD",                		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_ROMANTICISM_HD",                         		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_ROMANTICISM_HIPPODROME_HD",              		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_ROMANTICISM_STREET_CARNIVAL_HD",         		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_HEDONISM_HD",                            		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_HEDONISM_WATER_STREET_CARNIVAL_HD",      		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_HEDONISM_BEACH_RESORT_HD",               		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_IMPROVEMENT"),
    ("ROCKBAND_REALISM_HD",                             		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_REALISM_MBANZA_HD",                      		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_ACADEMISM_HD",                           		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_ACADEMISM_SEOWON_HD",                    		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_ACADEMISM_OBSERVATORY_HD",               		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_POPULARISM_HD",                          		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_POPULARISM_SUGUBA_HD",                   		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_POPULARISM_SUK_FLOATINGMARKET_HD",       		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_PLURALISM_HD",                           		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_PLURALISM_HANSA_HD",                     		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_PLURALISM_OPPIDUM_HD",                   		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_FISHER_SONG_HD",                         		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_FISHER_SONG_ROYAL_NAVY_DOCKYARD_HD",     		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    ("ROCKBAND_FISHER_SONG_COTHON_HD",                  		"MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT"),
    
    ("ROCKBAND_MYSTICISM_HOLY_SITE_PRE_HD",                 	"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_MYSTICISM_LAVRA_PRE_HD",                     	"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_MYSTICISM_TOURISM_BOMB_NATIONAL_PARK_HD",		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_NATIONAL_PARK"),
    ("ROCKBAND_MYSTICISM_TOURISM_BOMB_NATURAL_WONDER_HD",		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_NATURAL_WONDER"),
    ("ROCKBAND_CLASSICISM_PRE_HD",                          	"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_CLASSICISM_ACROPOLIS_PRE_HD",               		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_ROMANTICISM_PRE_HD",                        		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_ROMANTICISM_HIPPODROME_PRE_HD",             		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_ROMANTICISM_STREET_CARNIVAL_PRE_HD",        		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_HEDONISM_PRE_HD",                           		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_HEDONISM_BEACH_RESORT_TOURISM_BOMB_HD",  		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_IMPROVEMENT"),
    ("ROCKBAND_HEDONISM_WATER_STREET_CARNIVAL_PRE_HD",      	"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_REALISM_PRE_HD",                             	"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_REALISM_FARM_TOURISM_BOMB_HD",           		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_IMPROVEMENT"),
    ("ROCKBAND_REALISM_CAMP_TOURISM_BOMB_HD",           		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_IMPROVEMENT"),
    ("ROCKBAND_REALISM_MBANZA_PRE_HD",                      	"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_ACADEMISM_PRE_HD",                           	"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_ACADEMISM_SEOWON_PRE_HD",                   		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_ACADEMISM_OBSERVATORY_PRE_HD",              		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_POPULARISM_PRE_HD",                         		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_POPULARISM_SUGUBA_PRE_HD",                  		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_POPULARISM_SUK_FLOATINGMARKET_PRE_HD",      		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_PLURALISM_PRE_HD",                          		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_PLURALISM_HANSA_PRE_HD",                    		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_PLURALISM_OPPIDUM_PRE_HD",                  		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_FISHER_SONG_PRE_HD",                        		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_FISHER_SONG_ROYAL_NAVY_DOCKYARD_PRE_HD",     	"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),
    ("ROCKBAND_FISHER_SONG_COTHON_PRE_HD",                  	"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT"),

    ("ROCKBAND_GLEEMAN_HD",                             		"MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT"),
    ("ROCKBAND_URBAN_OPERA_HD",                         		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_ADDITIONAL_YIELD"),
    ("ROCKBAND_PAN_POLITICALIZATION_HD",                		"MODIFIER_SINGLE_UNIT_ADJUST_POST_TOURISM_BOMB_LOYALTY"),
    ("ROCKBAND_WELL_KNOWN_HD",                          		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_RANGE"),
    --文化传播单位无视地形河流
    ("HD_ROCK_IGNORE_ALL",                 						"MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_TERRAIN_COST"),
    ("HD_ROCK_IGNORE_RIVERS",                           		"MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_RIVERS"),
    --信仰购买文化传播单位
    ("CITY_ENABLE_ROCK_BAND_FAITH_PURCHASE_HD",         		"MODIFIER_CITY_ENABLE_UNIT_FAITH_PURCHASE"),
    --文化传播单位基础额外产出
    ("HD_ROCK_BASIC_YIELD_GOLD",                        		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_ADDITIONAL_YIELD"),
    ("HD_ROCK_BASIC_YIELD_CULTURE",                     		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_ADDITIONAL_YIELD"),
    ("HD_MALI_GRIOTS_BASIC_YIELD_GOLD",                 		"MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_ADDITIONAL_YIELD");

insert or replace into Modifiers
    (ModifierId,                                        		ModifierType,                                                           SubjectRequirementSetId)
values
    --文化传播单位数量效应
    ("ORAL_SCHOLAR_TOURISM_BOMB_ALL_HD",                		"MODIFIER_PLAYER_UNITS_ADJUST_ROCK_BAND_TOURISM_BOMB_VALUE_PEACE",      "REQUIRESETS_ROCK_BOMB_AOE_HD"),
    ("TRAVEL_THEATRE_TOURISM_BOMB_ALL_HD",              		"MODIFIER_PLAYER_UNITS_ADJUST_ROCK_BAND_TOURISM_BOMB_VALUE_PEACE",      "REQUIRESETS_ROCK_BOMB_AOE_HD"),
    ("ROCK_BAND_TOURISM_BOMB_ALL_HD",                   		"MODIFIER_PLAYER_UNITS_ADJUST_ROCK_BAND_TOURISM_BOMB_VALUE_PEACE",      "REQUIRESETS_ROCK_BOMB_AOE_HD");

insert or replace into ModifierArguments
    (ModifierId,                                        		Name,                   Value)
values
    ("ROCKBAND_MYSTICISM_WONDER_HD",                    		"DistrictType",         "DISTRICT_WONDER"),
    ("ROCKBAND_MYSTICISM_WONDER_HD",                    		"Amount",               1),
    ("ROCKBAND_MYSTICISM_HOLY_SITE_HD",                 		"DistrictType",         "DISTRICT_HOLY_SITE"),
    ("ROCKBAND_MYSTICISM_HOLY_SITE_HD",                 		"Amount",               1),
    ("ROCKBAND_MYSTICISM_LAVRA_HD",                     		"DistrictType",         "DISTRICT_LAVRA"),
    ("ROCKBAND_MYSTICISM_LAVRA_HD",                     		"Amount",               1),
    ("ROCKBAND_MYSTICISM_NATIONAL_PARK_HD",             		"Amount",               1),
    ("ROCKBAND_MYSTICISM_NATURAL_WONDER_HD",            		"Amount",               1),
    ("ROCKBAND_CLASSICISM_HD",                          		"DistrictType",         "DISTRICT_THEATER"),
    ("ROCKBAND_CLASSICISM_HD",                          		"Amount",               2),
    ("ROCKBAND_CLASSICISM_ACROPOLIS_HD",                		"DistrictType",         "DISTRICT_ACROPOLIS"),
    ("ROCKBAND_CLASSICISM_ACROPOLIS_HD",                		"Amount",               2),
    ("ROCKBAND_ROMANTICISM_HD",                         		"DistrictType",         "DISTRICT_ENTERTAINMENT_COMPLEX"),
    ("ROCKBAND_ROMANTICISM_HD",                         		"Amount",               2),
    ("ROCKBAND_ROMANTICISM_HIPPODROME_HD",              		"DistrictType",         "DISTRICT_HIPPODROME"),
    ("ROCKBAND_ROMANTICISM_HIPPODROME_HD",              		"Amount",               2),
    ("ROCKBAND_ROMANTICISM_STREET_CARNIVAL_HD",         		"DistrictType",         "DISTRICT_STREET_CARNIVAL"),
    ("ROCKBAND_ROMANTICISM_STREET_CARNIVAL_HD",         		"Amount",               2),
    ("ROCKBAND_HEDONISM_HD",                            		"DistrictType",         "DISTRICT_WATER_ENTERTAINMENT_COMPLEX"),
    ("ROCKBAND_HEDONISM_HD",                            		"Amount",               2),
    ("ROCKBAND_HEDONISM_WATER_STREET_CARNIVAL_HD",      		"DistrictType",         "DISTRICT_WATER_STREET_CARNIVAL"),
    ("ROCKBAND_HEDONISM_WATER_STREET_CARNIVAL_HD",      		"Amount",               2),
    ("ROCKBAND_HEDONISM_BEACH_RESORT_HD",               		"ImprovementType",      "IMPROVEMENT_BEACH_RESORT"),
    ("ROCKBAND_HEDONISM_BEACH_RESORT_HD",               		"Amount",               2),
    ("ROCKBAND_REALISM_HD",                             		"DistrictType",         "DISTRICT_NEIGHBORHOOD"),
    ("ROCKBAND_REALISM_HD",                             		"Amount",               2),
    ("ROCKBAND_REALISM_MBANZA_HD",                      		"DistrictType",         "DISTRICT_MBANZA"),
    ("ROCKBAND_REALISM_MBANZA_HD",                      		"Amount",               2),
    ("ROCKBAND_ACADEMISM_HD",                           		"DistrictType",         "DISTRICT_CAMPUS"),
    ("ROCKBAND_ACADEMISM_HD",                           		"Amount",               2),
    ("ROCKBAND_ACADEMISM_SEOWON_HD",                    		"DistrictType",         "DISTRICT_SEOWON"),
    ("ROCKBAND_ACADEMISM_SEOWON_HD",                    		"Amount",               2),
    ("ROCKBAND_ACADEMISM_OBSERVATORY_HD",               		"DistrictType",         "DISTRICT_OBSERVATORY"),
    ("ROCKBAND_ACADEMISM_OBSERVATORY_HD",               		"Amount",               2),
    ("ROCKBAND_POPULARISM_HD",                          		"DistrictType",         "DISTRICT_COMMERCIAL_HUB"),
    ("ROCKBAND_POPULARISM_HD",                          		"Amount",               2),
    ("ROCKBAND_POPULARISM_SUGUBA_HD",                   		"DistrictType",         "DISTRICT_SUGUBA"),
    ("ROCKBAND_POPULARISM_SUGUBA_HD",                   		"Amount",               2),
    ("ROCKBAND_POPULARISM_SUK_FLOATINGMARKET_HD",       		"DistrictType",         "DISTRICT_SUK_FLOATINGMARKET"),
    ("ROCKBAND_POPULARISM_SUK_FLOATINGMARKET_HD",       		"Amount",               2),
    ("ROCKBAND_PLURALISM_HD",                           		"DistrictType",         "DISTRICT_INDUSTRIAL_ZONE"),
    ("ROCKBAND_PLURALISM_HD",                           		"Amount",               2),
    ("ROCKBAND_PLURALISM_HANSA_HD",                     		"DistrictType",         "DISTRICT_HANSA"),
    ("ROCKBAND_PLURALISM_HANSA_HD",                     		"Amount",               2),
    ("ROCKBAND_PLURALISM_OPPIDUM_HD",                   		"DistrictType",         "DISTRICT_OPPIDUM"),
    ("ROCKBAND_PLURALISM_OPPIDUM_HD",                   		"Amount",               2),
    ("ROCKBAND_FISHER_SONG_HD",                         		"DistrictType",         "DISTRICT_HARBOR"),
    ("ROCKBAND_FISHER_SONG_HD",                         		"Amount",               2),
    ("ROCKBAND_FISHER_SONG_ROYAL_NAVY_DOCKYARD_HD",     		"DistrictType",         "DISTRICT_ROYAL_NAVY_DOCKYARD"),
    ("ROCKBAND_FISHER_SONG_ROYAL_NAVY_DOCKYARD_HD",     		"Amount",               2),
    ("ROCKBAND_FISHER_SONG_COTHON_HD",                  		"DistrictType",         "DISTRICT_COTHON"),
    ("ROCKBAND_FISHER_SONG_COTHON_HD",                  		"Amount",               2),

    ("ROCKBAND_MYSTICISM_HOLY_SITE_PRE_HD",                 	"DistrictType",         "DISTRICT_HOLY_SITE"),
    ("ROCKBAND_MYSTICISM_HOLY_SITE_PRE_HD",                 	"Amount",               50),
    ("ROCKBAND_MYSTICISM_LAVRA_PRE_HD",                    		"DistrictType",         "DISTRICT_LAVRA"),
    ("ROCKBAND_MYSTICISM_LAVRA_PRE_HD",                    		"Amount",               50),
    ("ROCKBAND_MYSTICISM_TOURISM_BOMB_NATIONAL_PARK_HD",		"Amount",               600),
    ("ROCKBAND_MYSTICISM_TOURISM_BOMB_NATURAL_WONDER_HD",		"Amount",              	600),
    ("ROCKBAND_CLASSICISM_PRE_HD",                          	"DistrictType",         "DISTRICT_THEATER"),
    ("ROCKBAND_CLASSICISM_PRE_HD",                          	"Amount",               50),
    ("ROCKBAND_CLASSICISM_ACROPOLIS_PRE_HD",               		"DistrictType",         "DISTRICT_ACROPOLIS"),
    ("ROCKBAND_CLASSICISM_ACROPOLIS_PRE_HD",               		"Amount",               50),
    ("ROCKBAND_ROMANTICISM_PRE_HD",                        		"DistrictType",         "DISTRICT_ENTERTAINMENT_COMPLEX"),
    ("ROCKBAND_ROMANTICISM_PRE_HD",                        		"Amount",               50),
    ("ROCKBAND_ROMANTICISM_HIPPODROME_PRE_HD",             		"DistrictType",         "DISTRICT_HIPPODROME"),
    ("ROCKBAND_ROMANTICISM_HIPPODROME_PRE_HD",             		"Amount",               50),
    ("ROCKBAND_ROMANTICISM_STREET_CARNIVAL_PRE_HD",         	"DistrictType",         "DISTRICT_STREET_CARNIVAL"),
    ("ROCKBAND_ROMANTICISM_STREET_CARNIVAL_PRE_HD",         	"Amount",               50),
    ("ROCKBAND_HEDONISM_PRE_HD",                           		"DistrictType",         "DISTRICT_WATER_ENTERTAINMENT_COMPLEX"),
    ("ROCKBAND_HEDONISM_PRE_HD",                           		"Amount",               50),
    ("ROCKBAND_HEDONISM_WATER_STREET_CARNIVAL_PRE_HD",     		"DistrictType",         "DISTRICT_WATER_STREET_CARNIVAL"),
    ("ROCKBAND_HEDONISM_WATER_STREET_CARNIVAL_PRE_HD",     		"Amount",               50),
    ("ROCKBAND_HEDONISM_BEACH_RESORT_TOURISM_BOMB_HD",  		"ImprovementType",      "IMPROVEMENT_BEACH_RESORT"),
    ("ROCKBAND_HEDONISM_BEACH_RESORT_TOURISM_BOMB_HD",  		"Amount",               600),
    ("ROCKBAND_REALISM_PRE_HD",                            		"DistrictType",         "DISTRICT_NEIGHBORHOOD"),
    ("ROCKBAND_REALISM_PRE_HD",                            		"Amount",               50),
    ("ROCKBAND_REALISM_FARM_TOURISM_BOMB_HD",           		"ImprovementType",      "IMPROVEMENT_FARM"),
    ("ROCKBAND_REALISM_FARM_TOURISM_BOMB_HD",           		"Amount",               25),
    ("ROCKBAND_REALISM_CAMP_TOURISM_BOMB_HD",           		"ImprovementType",      "IMPROVEMENT_CAMP"),
    ("ROCKBAND_REALISM_CAMP_TOURISM_BOMB_HD",           		"Amount",               25),
    ("ROCKBAND_REALISM_MBANZA_PRE_HD",                      	"DistrictType",         "DISTRICT_MBANZA"),
    ("ROCKBAND_REALISM_MBANZA_PRE_HD",                      	"Amount",               50),
    ("ROCKBAND_ACADEMISM_PRE_HD",                          		"DistrictType",         "DISTRICT_CAMPUS"),
    ("ROCKBAND_ACADEMISM_PRE_HD",                          		"Amount",               50),
    ("ROCKBAND_ACADEMISM_SEOWON_PRE_HD",                   		"DistrictType",         "DISTRICT_SEOWON"),
    ("ROCKBAND_ACADEMISM_SEOWON_PRE_HD",                  		"Amount",               50),
    ("ROCKBAND_ACADEMISM_OBSERVATORY_PRE_HD",              		"DistrictType",         "DISTRICT_OBSERVATORY"),
    ("ROCKBAND_ACADEMISM_OBSERVATORY_PRE_HD",              		"Amount",               50),
    ("ROCKBAND_POPULARISM_PRE_HD",                         		"DistrictType",         "DISTRICT_COMMERCIAL_HUB"),
    ("ROCKBAND_POPULARISM_PRE_HD",                         		"Amount",               50),
    ("ROCKBAND_POPULARISM_SUGUBA_PRE_HD",                  		"DistrictType",         "DISTRICT_SUGUBA"),
    ("ROCKBAND_POPULARISM_SUGUBA_PRE_HD",                  		"Amount",               50),
    ("ROCKBAND_POPULARISM_SUK_FLOATINGMARKET_PRE_HD",       	"DistrictType",         "DISTRICT_SUK_FLOATINGMARKET"),
    ("ROCKBAND_POPULARISM_SUK_FLOATINGMARKET_PRE_HD",       	"Amount",               50),
    ("ROCKBAND_PLURALISM_PRE_HD",                          		"DistrictType",         "DISTRICT_INDUSTRIAL_ZONE"),
    ("ROCKBAND_PLURALISM_PRE_HD",                          		"Amount",               50),
    ("ROCKBAND_PLURALISM_HANSA_PRE_HD",                    		"DistrictType",         "DISTRICT_HANSA"),
    ("ROCKBAND_PLURALISM_HANSA_PRE_HD",                    		"Amount",               50),
    ("ROCKBAND_PLURALISM_OPPIDUM_PRE_HD",                  		"DistrictType",         "DISTRICT_OPPIDUM"),
    ("ROCKBAND_PLURALISM_OPPIDUM_PRE_HD",                  		"Amount",               50),
    ("ROCKBAND_FISHER_SONG_PRE_HD",                        		"DistrictType",         "DISTRICT_HARBOR"),
    ("ROCKBAND_FISHER_SONG_PRE_HD",                        		"Amount",               50),
    ("ROCKBAND_FISHER_SONG_ROYAL_NAVY_DOCKYARD_PRE_HD",     	"DistrictType",         "DISTRICT_ROYAL_NAVY_DOCKYARD"),
    ("ROCKBAND_FISHER_SONG_ROYAL_NAVY_DOCKYARD_PRE_HD",     	"Amount",               50),
    ("ROCKBAND_FISHER_SONG_COTHON_PRE_HD",                 		"DistrictType",         "DISTRICT_COTHON"),
    ("ROCKBAND_FISHER_SONG_COTHON_PRE_HD",                 		"Amount",               50),

    ("ROCKBAND_GLEEMAN_HD",                             		"Amount",               4),
    ("ROCKBAND_URBAN_OPERA_HD",                         		"YieldType",            "YIELD_GOLD"),
    ("ROCKBAND_URBAN_OPERA_HD",                         		"Amount",               60),
    ("ROCKBAND_PAN_POLITICALIZATION_HD",                		"Amount",               -50),
    ("ROCKBAND_WELL_KNOWN_HD",                          		"Modifier",             -50),
    ("ROCKBAND_WELL_KNOWN_HD",                          		"Range",                12),

    ("ORAL_SCHOLAR_TOURISM_BOMB_ALL_HD",                		"Amount",               4),
    ("TRAVEL_THEATRE_TOURISM_BOMB_ALL_HD",              		"Amount",               8),
    ("ROCK_BAND_TOURISM_BOMB_ALL_HD",                   		"Amount",               20),

    ("HD_ROCK_IGNORE_ALL",                              		"Ignore",               1),
    ("HD_ROCK_IGNORE_ALL",                              		"Type",                 "ALL"),
    ("HD_ROCK_IGNORE_RIVERS",                           		"Ignore",               1),

    ("CITY_ENABLE_ROCK_BAND_FAITH_PURCHASE_HD",         		"Tag",                  "CLASS_ROCK_BAND"),

    ("HD_ROCK_BASIC_YIELD_GOLD",                        		"YieldType",            "YIELD_GOLD"),
    ("HD_ROCK_BASIC_YIELD_GOLD",                        		"Amount",               -99),
    ("HD_ROCK_BASIC_YIELD_CULTURE",                     		"YieldType",            "YIELD_CULTURE"),
    ("HD_ROCK_BASIC_YIELD_CULTURE",                     		"Amount",               -99),
    ("HD_MALI_GRIOTS_BASIC_YIELD_GOLD",                 		"YieldType",            "YIELD_GOLD"),
    ("HD_MALI_GRIOTS_BASIC_YIELD_GOLD",                 		"Amount",               3);

insert or replace into UnitPromotionModifiers
    (UnitPromotionType,                             ModifierId)
values
    ("PROMOTION_MYSTICISM_HD",                      "ROCKBAND_MYSTICISM_WONDER_HD"),
    ("PROMOTION_MYSTICISM_HD",                      "ROCKBAND_MYSTICISM_HOLY_SITE_HD"),
    ("PROMOTION_MYSTICISM_HD",                      "ROCKBAND_MYSTICISM_LAVRA_HD"),
    ("PROMOTION_MYSTICISM_HD",                      "ROCKBAND_MYSTICISM_NATIONAL_PARK_HD"),
    ("PROMOTION_MYSTICISM_HD",                      "ROCKBAND_MYSTICISM_NATURAL_WONDER_HD"),
    ("PROMOTION_CLASSICISM_HD",                     "ROCKBAND_CLASSICISM_HD"),
    ("PROMOTION_CLASSICISM_HD",                     "ROCKBAND_CLASSICISM_ACROPOLIS_HD"),
    ("PROMOTION_ROMANTICISM_HD",                    "ROCKBAND_ROMANTICISM_HD"),
    ("PROMOTION_ROMANTICISM_HD",                    "ROCKBAND_ROMANTICISM_HIPPODROME_HD"),
    ("PROMOTION_ROMANTICISM_HD",                    "ROCKBAND_ROMANTICISM_STREET_CARNIVAL_HD"),
/*     ("PROMOTION_HEDONISM_HD",                       "ROCKBAND_HEDONISM_HD"),
    ("PROMOTION_HEDONISM_HD",                       "ROCKBAND_HEDONISM_WATER_STREET_CARNIVAL_HD"),
    ("PROMOTION_HEDONISM_HD",                       "ROCKBAND_HEDONISM_BEACH_RESORT_TOURISM_BOMB_HD"),
    ("PROMOTION_HEDONISM_HD",                       "ROCKBAND_HEDONISM_BEACH_RESORT_HD"), */
    ("PROMOTION_ROMANTICISM_HD",                    "ROCKBAND_HEDONISM_HD"),
    ("PROMOTION_ROMANTICISM_HD",                    "ROCKBAND_HEDONISM_WATER_STREET_CARNIVAL_HD"),
    ("PROMOTION_ROMANTICISM_HD",                    "ROCKBAND_HEDONISM_BEACH_RESORT_HD"),
    ("PROMOTION_REALISM_HD",                        "ROCKBAND_REALISM_HD"),
    ("PROMOTION_REALISM_HD",                        "ROCKBAND_REALISM_MBANZA_HD"),
    ("PROMOTION_ACADEMISM_HD",                      "ROCKBAND_ACADEMISM_HD"),
    ("PROMOTION_ACADEMISM_HD",                      "ROCKBAND_ACADEMISM_SEOWON_HD"),
    ("PROMOTION_ACADEMISM_HD",                      "ROCKBAND_ACADEMISM_OBSERVATORY_HD"),
    ("PROMOTION_POPULARISM_HD",                     "ROCKBAND_POPULARISM_HD"),
    ("PROMOTION_POPULARISM_HD",                     "ROCKBAND_POPULARISM_SUGUBA_HD"),
    ("PROMOTION_POPULARISM_HD",                     "ROCKBAND_POPULARISM_SUK_FLOATINGMARKET_HD"),
    ("PROMOTION_PLURALISM_HD",                      "ROCKBAND_PLURALISM_HD"),
    ("PROMOTION_PLURALISM_HD",                      "ROCKBAND_PLURALISM_HANSA_HD"),
    ("PROMOTION_PLURALISM_HD",                      "ROCKBAND_PLURALISM_OPPIDUM_HD"),
    ("PROMOTION_FISHER_SONG_HD",                    "ROCKBAND_FISHER_SONG_HD"),
    ("PROMOTION_FISHER_SONG_HD",                    "ROCKBAND_FISHER_SONG_ROYAL_NAVY_DOCKYARD_HD"),
    ("PROMOTION_FISHER_SONG_HD",                    "ROCKBAND_FISHER_SONG_COTHON_HD"),

	("PROMOTION_MYSTICISM_PRE_HD",                  "ROCKBAND_MYSTICISM_HOLY_SITE_PRE_HD"),
    ("PROMOTION_MYSTICISM_PRE_HD",                  "ROCKBAND_MYSTICISM_LAVRA_PRE_HD"),
    ("PROMOTION_MYSTICISM_PRE_HD",                  "ROCKBAND_MYSTICISM_TOURISM_BOMB_NATIONAL_PARK_HD"),
    ("PROMOTION_MYSTICISM_PRE_HD",                  "ROCKBAND_MYSTICISM_TOURISM_BOMB_NATURAL_WONDER_HD"),
    ("PROMOTION_CLASSICISM_PRE_HD",                 "ROCKBAND_CLASSICISM_PRE_HD"),
    ("PROMOTION_CLASSICISM_PRE_HD",                 "ROCKBAND_CLASSICISM_ACROPOLIS_PRE_HD"),
    ("PROMOTION_ROMANTICISM_PRE_HD",                "ROCKBAND_ROMANTICISM_PRE_HD"),
    ("PROMOTION_ROMANTICISM_PRE_HD",                "ROCKBAND_ROMANTICISM_HIPPODROME_PRE_HD"),
    ("PROMOTION_ROMANTICISM_PRE_HD",                "ROCKBAND_ROMANTICISM_STREET_CARNIVAL_PRE_HD"),
    ("PROMOTION_ROMANTICISM_PRE_HD",                "ROCKBAND_HEDONISM_PRE_HD"),
    ("PROMOTION_ROMANTICISM_PRE_HD",                "ROCKBAND_HEDONISM_WATER_STREET_CARNIVAL_PRE_HD"),
    ("PROMOTION_ROMANTICISM_PRE_HD",                "ROCKBAND_HEDONISM_BEACH_RESORT_TOURISM_BOMB_HD"),
    ("PROMOTION_REALISM_PRE_HD",                    "ROCKBAND_REALISM_PRE_HD"),
    ("PROMOTION_REALISM_PRE_HD",                    "ROCKBAND_REALISM_FARM_TOURISM_BOMB_HD"),
    ("PROMOTION_REALISM_PRE_HD",                    "ROCKBAND_REALISM_CAMP_TOURISM_BOMB_HD"),
    ("PROMOTION_REALISM_PRE_HD",                    "ROCKBAND_REALISM_MBANZA_PRE_HD"),
    ("PROMOTION_ACADEMISM_PRE_HD",                  "ROCKBAND_ACADEMISM_PRE_HD"),
    ("PROMOTION_ACADEMISM_PRE_HD",                  "ROCKBAND_ACADEMISM_SEOWON_PRE_HD"),
    ("PROMOTION_ACADEMISM_PRE_HD",                  "ROCKBAND_ACADEMISM_OBSERVATORY_PRE_HD"),
    ("PROMOTION_POPULARISM_PRE_HD",                 "ROCKBAND_POPULARISM_PRE_HD"),
    ("PROMOTION_POPULARISM_PRE_HD",                 "ROCKBAND_POPULARISM_SUGUBA_PRE_HD"),
    ("PROMOTION_POPULARISM_PRE_HD",                 "ROCKBAND_POPULARISM_SUK_FLOATINGMARKET_PRE_HD"),
    ("PROMOTION_PLURALISM_PRE_HD",                  "ROCKBAND_PLURALISM_PRE_HD"),
    ("PROMOTION_PLURALISM_PRE_HD",                  "ROCKBAND_PLURALISM_HANSA_PRE_HD"),
    ("PROMOTION_PLURALISM_PRE_HD",                  "ROCKBAND_PLURALISM_OPPIDUM_PRE_HD"),
    ("PROMOTION_FISHER_SONG_PRE_HD",                "ROCKBAND_FISHER_SONG_PRE_HD"),
    ("PROMOTION_FISHER_SONG_PRE_HD",                "ROCKBAND_FISHER_SONG_ROYAL_NAVY_DOCKYARD_PRE_HD"),
    ("PROMOTION_FISHER_SONG_PRE_HD",                "ROCKBAND_FISHER_SONG_COTHON_PRE_HD"),

    ("PROMOTION_GLEEMAN_HD",                        "ROCKBAND_GLEEMAN_HD"),
    ("PROMOTION_GLEEMAN_HD",                        "HD_ROCK_IGNORE_ALL"),
    ("PROMOTION_GLEEMAN_HD",                        "HD_ROCK_IGNORE_RIVERS"),
    ("PROMOTION_URBAN_OPERA_HD",                    "ROCKBAND_URBAN_OPERA_HD"),
    ("PROMOTION_PAN_POLITICALIZATION_HD",           "ROCKBAND_PAN_POLITICALIZATION_HD"),
    ("PROMOTION_WELL_KNOWN_HD",                     "ROCKBAND_WELL_KNOWN_HD");

insert or replace into UnitPromotionPrereqs
    (UnitPromotion,                             	PrereqUnitPromotion)
values
	("PROMOTION_MYSTICISM_HD",						"PROMOTION_MYSTICISM_PRE_HD"),
	("PROMOTION_CLASSICISM_HD",						"PROMOTION_CLASSICISM_PRE_HD"),
	("PROMOTION_ROMANTICISM_HD",					"PROMOTION_ROMANTICISM_PRE_HD"),
	("PROMOTION_REALISM_HD",						"PROMOTION_REALISM_PRE_HD"),
	("PROMOTION_ACADEMISM_HD",						"PROMOTION_ACADEMISM_PRE_HD"),
	("PROMOTION_POPULARISM_HD",						"PROMOTION_POPULARISM_PRE_HD"),
	("PROMOTION_PLURALISM_HD",						"PROMOTION_PLURALISM_PRE_HD"),
	("PROMOTION_FISHER_SONG_HD",					"PROMOTION_FISHER_SONG_PRE_HD"),

	("PROMOTION_GLEEMAN_HD",						"PROMOTION_MYSTICISM_PRE_HD"),
	("PROMOTION_GLEEMAN_HD",						"PROMOTION_CLASSICISM_PRE_HD"),
	("PROMOTION_GLEEMAN_HD",						"PROMOTION_ROMANTICISM_PRE_HD"),
	("PROMOTION_GLEEMAN_HD",						"PROMOTION_REALISM_PRE_HD"),
	("PROMOTION_GLEEMAN_HD",						"PROMOTION_ACADEMISM_PRE_HD"),
	("PROMOTION_GLEEMAN_HD",						"PROMOTION_POPULARISM_PRE_HD"),
	("PROMOTION_GLEEMAN_HD",						"PROMOTION_PLURALISM_PRE_HD"),
	("PROMOTION_GLEEMAN_HD",						"PROMOTION_FISHER_SONG_PRE_HD"),

	("PROMOTION_PAN_POLITICALIZATION_HD",			"PROMOTION_MYSTICISM_PRE_HD"),
	("PROMOTION_PAN_POLITICALIZATION_HD",			"PROMOTION_CLASSICISM_PRE_HD"),
	("PROMOTION_PAN_POLITICALIZATION_HD",			"PROMOTION_ROMANTICISM_PRE_HD"),
	("PROMOTION_PAN_POLITICALIZATION_HD",			"PROMOTION_REALISM_PRE_HD"),
	("PROMOTION_PAN_POLITICALIZATION_HD",			"PROMOTION_ACADEMISM_PRE_HD"),
	("PROMOTION_PAN_POLITICALIZATION_HD",			"PROMOTION_POPULARISM_PRE_HD"),
	("PROMOTION_PAN_POLITICALIZATION_HD",			"PROMOTION_PLURALISM_PRE_HD"),
	("PROMOTION_PAN_POLITICALIZATION_HD",			"PROMOTION_FISHER_SONG_PRE_HD"),

	("PROMOTION_URBAN_OPERA_HD",					"PROMOTION_MYSTICISM_HD"),
	("PROMOTION_URBAN_OPERA_HD",					"PROMOTION_CLASSICISM_HD"),
	("PROMOTION_URBAN_OPERA_HD",					"PROMOTION_ROMANTICISM_HD"),
	("PROMOTION_URBAN_OPERA_HD",					"PROMOTION_REALISM_HD"),
	("PROMOTION_URBAN_OPERA_HD",					"PROMOTION_ACADEMISM_HD"),
	("PROMOTION_URBAN_OPERA_HD",					"PROMOTION_POPULARISM_HD"),
	("PROMOTION_URBAN_OPERA_HD",					"PROMOTION_PLURALISM_HD"),
	("PROMOTION_URBAN_OPERA_HD",					"PROMOTION_FISHER_SONG_HD"),

	("PROMOTION_WELL_KNOWN_HD",						"PROMOTION_MYSTICISM_HD"),
	("PROMOTION_WELL_KNOWN_HD",						"PROMOTION_CLASSICISM_HD"),
	("PROMOTION_WELL_KNOWN_HD",						"PROMOTION_ROMANTICISM_HD"),
	("PROMOTION_WELL_KNOWN_HD",						"PROMOTION_REALISM_HD"),
	("PROMOTION_WELL_KNOWN_HD",						"PROMOTION_ACADEMISM_HD"),
	("PROMOTION_WELL_KNOWN_HD",						"PROMOTION_POPULARISM_HD"),
	("PROMOTION_WELL_KNOWN_HD",						"PROMOTION_PLURALISM_HD"),
	("PROMOTION_WELL_KNOWN_HD",						"PROMOTION_FISHER_SONG_HD");

update Policies set PrereqCivic = "CIVIC_LITERARY_TRADITION_HD" where PolicyType = "POLICY_MUSIC_CENSORSHIP";
delete from PolicyModifiers where PolicyType = "POLICY_MUSIC_CENSORSHIP" and ModifierId = "MUSIC_CENSORSHIP_AMENITY_LOSS";

insert or replace into Modifiers
    (ModifierId,                                        		ModifierType)
values
    ("MUSIC_CENSORSHIP_BLOCK_ORAL_SCHOLAR_ENTRY",             	"MODIFIER_PLAYER_ADJUST_BLOCK_UNIT_ENTRY"),
    ("MUSIC_CENSORSHIP_BLOCK_TRAVEL_THEATRE_ENTRY",             "MODIFIER_PLAYER_ADJUST_BLOCK_UNIT_ENTRY");

insert or replace into ModifierArguments
    (ModifierId,                                        		Name,                   Value)
values
    ("MUSIC_CENSORSHIP_BLOCK_ORAL_SCHOLAR_ENTRY",               "UnitType",         	"UNIT_ORAL_SCHOLAR"),
    ("MUSIC_CENSORSHIP_BLOCK_TRAVEL_THEATRE_ENTRY",             "UnitType",         	"UNIT_TRAVEL_THEATRE");

insert or replace into PolicyModifiers
	(PolicyType,												ModifierId)
values
	('POLICY_MUSIC_CENSORSHIP',									'MUSIC_CENSORSHIP_BLOCK_ORAL_SCHOLAR_ENTRY'),
	('POLICY_MUSIC_CENSORSHIP',									'MUSIC_CENSORSHIP_BLOCK_TRAVEL_THEATRE_ENTRY');
	
With Building_TourismBombs_XP2_Pre
    (BuildingType,                                  TourismBombValue)
as (values
    --剧院
    ("BUILDING_JNR_ASSEMBLY",                       200),
    ("BUILDING_AMPHITHEATER",                       200),
    ("BUILDING_MARAE",                              200),
    ("BUILDING_JNR_CABINET",                        250),
    ("BUILDING_JNR_MANSION",                        250),
    ("BUILDING_JNR_OPERA",                          300),
    ("BUILDING_JNR_GRAND_HOTEL",                    300),
    ("BUILDING_JNR_MEDIA_CENTER",                   450),
    ("BUILDING_BROADCAST_CENTER",                   450),
    ("BUILDING_FILM_STUDIO",                        450),
    --娱乐区
    ("BUILDING_ARENA",                              200),
    ("BUILDING_JNR_TOURNEY",                        200),
    ("BUILDING_TLACHTLI",                           200),
    ("BUILDING_ZOO",                                250),
    ("BUILDING_JNR_BOTANICAL_GARDEN",               250),
    ("BUILDING_THERMAL_BATH",                       250),
    ("BUILDING_JNR_THEME_PARK",                     450),
    ("BUILDING_STADIUM",                            450),
    --水上乐园
    ("BUILDING_JNR_MARINA",                         200),
    ("BUILDING_FERRIS_WHEEL",                       200),
    ("BUILDING_JNR_CASINO",                         250),
    ("BUILDING_AQUARIUM",                           250),
    ("BUILDING_JNR_FOOD_COURT",                     450),
    ("BUILDING_AQUATICS_CENTER",                    450),
    --社区，地铁站没给
    ("BUILDING_FOOD_MARKET",                        250),
    ("BUILDING_SHOPPING_MALL",                      250),
    ("BUILDING_JNR_RECYCLING_PLANT",                300),
    ("BUILDING_JNR_HOSPITAL",                       300),
    ("BUILDING_JNR_MEDITATION",                     450),
    ("BUILDING_JNR_ART_GALLERY",                    450),
    --学院
    ("BUILDING_LIBRARY",                            200),
    ("BUILDING_JNR_ACADEMY",                        200),
    ("BUILDING_MER_ROYAL_ARCHIVE",                  200),
    ("BUILDING_MER_LITERARY_SCHOOL_HD",             200),
    ("BUILDING_UNIVERSITY",                         250),
    ("BUILDING_JNR_SCHOOL",                         250),
    ("BUILDING_MADRASA",                            250),
    ("BUILDING_NAVIGATION_SCHOOL",                  250),
    ("BUILDING_JNR_LABORATORY",                     300),
    ("BUILDING_JNR_REAL_ACADEMY",                   300),
    ("BUILDING_JNR_LIBERAL_ARTS",                   300),
    ("BUILDING_JNR_ARCHITECTURE",                   300),
    ("BUILDING_RESEARCH_LAB",                       450),
    ("BUILDING_JNR_EDUCATION",                      450),
    --商业中心
    ("BUILDING_FAIR",                               150),
    ("BUILDING_JNR_WAYSTATION",                     150),
    ("BUILDING_MARKET",                             200),
    ("BUILDING_JNR_MINT",                           200),
    ("BUILDING_SUKIENNICE",                         200),
    ("BUILDING_JNR_GUILDHALL",                      250),
    ("BUILDING_JNR_MERCHANT_QUARTER",               250),
    ("BUILDING_BANK",                               250),
    ("BUILDING_GRAND_BAZAAR",                       250),
    ("BUILDING_JNR_MARKETING_AGENCY",               450),
    ("BUILDING_JNR_COMMODITY_EXCHANGE",             450),
    ("BUILDING_STOCK_EXCHANGE",                     450),
    --工业区
    ("BUILDING_IZ_WATER_MILL",                      200),
    ("BUILDING_JNR_WIND_MILL",                      200),
    ("BUILDING_JNR_MANUFACTURY",                    250),
    ("BUILDING_WORKSHOP",                           250),
    ("BUILDING_FACTORY",                            300),
    ("BUILDING_JNR_CHEMICAL",                       300),
    ("BUILDING_COAL_POWER_PLANT",                   450),
    ("BUILDING_FOSSIL_FUEL_POWER_PLANT",            450),
    ("BUILDING_JNR_FREIGHT_YARD",                   450),
    ("BUILDING_POWER_PLANT",                        450),
    ("BUILDING_HD_ELECTRONICS_FACTORY",             450),
    ("BUILDING_HD_INTERNET_COMPANY",                600),
    --港口
    ("BUILDING_JNR_LIGHTHOUSE_FISHING",             200),
    ("BUILDING_LIGHTHOUSE",                         200),
    ("BUILDING_JNR_FISH_MARKET",                       250),
    ("BUILDING_JNR_ENTREPOT",                          250),
    ("BUILDING_SHIPYARD",                           250),
    ("BUILDING_JNR_NAVAL_BASE",                     450),
    ("BUILDING_SEAPORT",                            450),
    ("BUILDING_JNR_OFFSHORE_TERMINAL",                450),
    --圣地
    ("BUILDING_SHRINE",                             200),
    ("BUILDING_JNR_ALTAR",                          200),
    ("BUILDING_JNR_MONASTERY",                      250),
    ("BUILDING_TEMPLE",                             250),
    ("BUILDING_STAVE_CHURCH",                       250),
    ("BUILDING_PRASAT",                             250),
    ("BUILDING_JNR_HOSPITIUM",                      450),
    ("BUILDING_JNR_GARDEN",                         450),
    ("BUILDING_CATHEDRAL",                          300),
    ("BUILDING_GURDWARA",                           300),
    ("BUILDING_MEETING_HOUSE",                      300),
    ("BUILDING_MOSQUE",                             300),
    ("BUILDING_PAGODA",                             300),
    ("BUILDING_SYNAGOGUE",                          300),
    ("BUILDING_WAT",                                300),
    ("BUILDING_STUPA",                              300),
    ("BUILDING_DAR_E_MEHR",                         300),
    ("BUILDING_JNR_CANDI",                          300),
    ("BUILDING_JNR_DAOGUAN",                        300),
    ("BUILDING_JNR_JINJA",                          300),
    ("BUILDING_JNR_KHALWAT",                        300),
    ("BUILDING_JNR_MANDIR",                         300),
    ("BUILDING_JNR_MBARI",                          300),
    ("BUILDING_JNR_PERIPTEROS",                     300),
    ("BUILDING_JNR_SOBOR",                          300),
    ("BUILDING_JNR_TZACUALLI",                      300))
insert or replace into Building_TourismBombs_XP2
    (BuildingType,                                  TourismBombValue)
select
    Building_TourismBombs_XP2_Pre.BuildingType,     Building_TourismBombs_XP2_Pre.TourismBombValue
from Building_TourismBombs_XP2_Pre INNER JOIN Buildings ON Buildings.BuildingType = Building_TourismBombs_XP2_Pre.BuildingType;

insert or replace into CivilizationTraits (CivilizationType,TraitType)
    select CivilizationType,'TRAIT_CIVILIZATION_UNIT_MALI_GRIOTS'
from Civilizations where CivilizationType = 'CIVILIZATION_CVS_SONGHAI';