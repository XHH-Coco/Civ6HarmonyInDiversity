--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
	(Tag,                                             			Text)
values
	("LOC_IMPROVEMENT_JNR_OASIS_FARM_DESCRIPTION",    			"+1 [ICON_AMENITIES] Amenity. If city has a Nilometer, +1 [ICON_Culture] Culture. Respectively +1 [ICON_AMENITIES] Amenity after Urbanization, Refrigeration Technique and Virtual Reality is researched. [NEWLINE][NEWLINE]Can only be built on Oases."),
	("LOC_IMPROVEMENT_JNR_REED_HOME_DESCRIPTION",     			"If city has a Nilometer, +1 [ICON_Science] Science. [NEWLINE][NEWLINE]Can only be built on Marsh or Swamp or Floodplains."),

	("LOC_FEATURE_HD_SWAMP_NAME",                           "Swamp"),
	("LOC_OR_SWAMP_NAME",                                		" or Swamp"),
	("LOC_BELIEF_JNR_JINJA_DL_DESCRIPTION",                 "Allows construction of Jinja (+8 [ICON_Faith] Faith, +4 [ICON_Production] Production. +2 [ICON_FOOD] Food for Forest tiles, +2 [ICON_PRODUCTION] Production for Rainforest tiles, +2 [ICON_CULTURE] Culture for Marsh tiles, and +2 [ICON_SCIENCE] Science for Swamp tiles in this city.)"),
	("LOC_BUILDING_JNR_JINJA_DL_DESCRIPTION",               "+2 [ICON_FOOD] Food for Forest tiles, +2 [ICON_PRODUCTION] Production for Rainforest tiles, +2 [ICON_CULTURE] Culture for Marsh tiles, and +2 [ICON_SCIENCE] Science for Swamp tiles in this city."),
	("LOC_BELIEF_HD_DRUID_DL_DESCRIPTION",                  "Forest tiles provide +1 [ICON_Food] Food. Rainforest tiles provide +1 [ICON_Production] Production. Swamp tiles provide +1 [ICON_CULTURE] Culture and +1 [ICON_Food] Food."),
	("LOC_TRAIT_CIVILIZATION_VIETNAM_DESCRIPTION",          "All Districts (except City Centers) do not remove Forest, Rainforest and Marsh. Receive the following yields for every building and Districts itself on these features: +2 [ICON_Production] Production in Forest, +2 [ICON_Food] Food in Rainforest, +2 [ICON_Science] Science in Marsh and +2 [ICON_Culture] Culture in Swamp. Woods can be planted with the Mysticism civic."),
	("LOC_BUILDING_ETEMENANKI_DESCRIPTION",                 "+2 [ICON_SCIENCE] Science and +1 [ICON_PRODUCTION] Production to all Marsh tiles in your empire. +2 [ICON_CULTURE] Culture and +1 [ICON_PRODUCTION] Production to all Swamp tiles in your empire. +1 [ICON_SCIENCE] Science and +1 [ICON_PRODUCTION] Production on all Floodplains tiles for this city.[NEWLINE][NEWLINE]Must be built on Floodplains or Marsh or Swamp."),
	("LOC_IMPROVEMENT_MOAI_DESCRIPTION",										"+2 [ICON_Culture] Culture. +2 [ICON_Culture] Culture if on or adjacent to a Volcanic Soil. +1 [ICON_Culture] Culture if adjacent to Shallow Sea and Lake. +1 [ICON_Culture] Culture for every 2 adjacent Moai or for every adjacent Moai after progress 'Medieval Faires' Civic. Can be built on Plains, Plains Hills, Grassland, Grassland Hills, or Volcanic Soil. Cannot be built adjacent to Woods or Rainforests."),
	("LOC_TECH_IRRIGATION_DESCRIPTION",											"+2 [ICON_GOLD] Gold from Plantations adjacent to fresh water or Aqueduct.[NEWLINE]Allows clearing of Marsh and Swamp, and harvesting of resources improved by Plantations. Allows Builders to build Farms on Plains Hills or Grassland Hills adjacent to fresh water or Aqueduct.");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
	(Language,      Tag,                                                        Text)
values
	("zh_Hans_CN",  "LOC_RESOURCE_JNR_PEAT_NAME",                               "泥炭"),
	("zh_Hans_CN",  "LOC_IMPROVEMENT_JNR_OASIS_FARM_NAME",                      "绿洲花园"),
	("zh_Hans_CN",  "LOC_IMPROVEMENT_JNR_OASIS_FARM_DESCRIPTION",               "+1 [ICON_AMENITIES] 宜居度。城市若拥有测量仪，+1 [ICON_Culture] 文化值。研究城市化市政、制冷技术科技和虚拟现实科技后，分别+1 [ICON_AMENITIES] 宜居度。[NEWLINE][NEWLINE]只能建造在绿洲上。"),
	("zh_Hans_CN",  "LOC_IMPROVEMENT_JNR_REED_HOME_NAME",                       "芦苇屋"),
	("zh_Hans_CN",  "LOC_IMPROVEMENT_JNR_REED_HOME_DESCRIPTION",                "城市若拥有测量仪，+1 [ICON_SCIENCE] 科技值。[NEWLINE][NEWLINE]可建造在沼泽或泛滥平原上。"),
	
	("zh_Hans_CN",  "LOC_FEATURE_MARSH_NAME",                                   "草本沼泽"),
	("zh_Hans_CN",  "LOC_FEATURE_HD_SWAMP_NAME",                                "木本沼泽"),
	("zh_Hans_CN",  "LOC_OR_SWAMP_NAME",                                				"或木本沼泽"),
	("zh_Hans_CN",  "LOC_BELIEF_JNR_JINJA_DL_DESCRIPTION",                      "允许建造神道教神社（+8 [ICON_Faith] 信仰值、+4 [ICON_Production] 生产力。本城的森林+2 [ICON_FOOD] 食物，雨林+2 [ICON_PRODUCTION] 生产力，草本沼泽+2 [ICON_CULTURE] 文化值，木本沼泽+2 [ICON_SCIENCE] 科技值。）"),
	("zh_Hans_CN",  "LOC_BUILDING_JNR_JINJA_DL_DESCRIPTION",                    "本城的森林+2 [ICON_FOOD] 食物，雨林+2 [ICON_PRODUCTION] 生产力，草本沼泽+2 [ICON_CULTURE] 文化值，木本沼泽+2 [ICON_SCIENCE] 科技值。"),
	("zh_Hans_CN",  "LOC_BELIEF_HD_DRUID_DL_DESCRIPTION",                       "森林单元格+1 [ICON_Food] 食物，雨林单元格+1 [ICON_Production] 生产力。木本沼泽单元格+1 [ICON_Food] 食物，+1 [ICON_CULTURE] 文化值。"),
	("zh_Hans_CN",  "LOC_TRAIT_CIVILIZATION_VIETNAM_DESCRIPTION",               "所有区域（除市中心外）不移除树林、雨林、沼泽地貌。建在这些区域中的建筑以及区域本体和奇观将获得以下收益：建在树林上提供+2 [ICON_Production] 生产力、建在雨林上提供+2 [ICON_Food] 食物、建在草本沼泽上提供+2 [ICON_Science] 科技值、建在木本沼泽上提供+2 [ICON_CULTURE] 文化值。拥有“神秘主义”市政后即可栽种树林。"),
	("zh_Hans_CN",  "LOC_BUILDING_ETEMENANKI_DESCRIPTION",                      "帝国中的所有草本沼泽单元格+2 [ICON_SCIENCE] 科技值、+1 [ICON_PRODUCTION] 生产力，木本沼泽单元格+2 [ICON_CULTURE] 文化值、+1 [ICON_PRODUCTION] 生产力。此城市的所有泛滥平原单元格+1 [ICON_SCIENCE] 科技值、+1 [ICON_PRODUCTION] 生产力。[NEWLINE][NEWLINE]必须建在泛滥平原或沼泽上。"),
	("zh_Hans_CN",  "LOC_BELIEF_LADY_OF_THE_REEDS_AND_MARSHES_DL_DESCRIPTION",  "平原泛滥平原提供+1 [ICON_Food] 食物，草原泛滥平原提供+1 [ICON_Production] 生产力。草本沼泽提供+1 [ICON_Production] 生产力和+1 [ICON_Science] 科技值。"),
	("zh_Hans_CN",	"LOC_IMPROVEMENT_MOAI_DESCRIPTION",													"+2 [ICON_Culture] 文化值。在火山土上或与其相邻时+2 [ICON_Culture] 文化值。相邻浅海与湖泊时+1 [ICON_Culture] 文化值。与每2个摩艾石像相邻+1 [ICON_Culture] 文化值，解锁“中世纪集市”后变为每与1个摩艾石像相邻。获得等同于 [ICON_Culture] 文化值产出的 [ICON_Tourism] 旅游业绩。只可建在平原、平原丘陵、草原、草原丘陵或火山土单元格之上。不能建造在相邻树林或雨林的单元格上。");