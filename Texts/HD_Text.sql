--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
	(Tag,																	 Text)
values
	-- UI Texts
	("LOC_HD_MESSAGE",														"Harmony in Diversity"),
	("LOC_PANTHEON_SELECTED_BY_OTHERS",									   "This pantheon has been selected by others."),
	("LOC_BELIEF_SELECTED_BY_OTHERS",										 "This religion belief has been selected by others."),
	("LOC_COMMEMORATION_CANNOT_SELECT",										 "[COLOR_RED]This Commemorations cannot be selected. [ENDCOLOR]"),
	("LOC_UNITCOMMAND_SACRIFICE_NAME",										"Human Sacrifice"),
	("LOC_UNITCOMMAND_SACRIFICE_DESCRIPTION",								 "Sacrifice this unit. Gain +10 [ICON_Culture] Culture and +10 [ICON_Faith] Faith for each builder charge the unit has."),
	("LOC_UNITCOMMAND_SACRIFICE_DISABLED_TT",								 "[COLOR_RED]Must occupy City Center[ENDCOLOR]"),
	("LOC_FLYOVER_AZTEC_SACRIFICE",										   "Human Sacrifice[COLOR:ResCultureLabelCS]+{1_Amount}[ENDCOLOR][ICON_Culture][COLOR:ResFaithLabelCS]+{1_Amount}[ENDCOLOR][ICON_Faith]"),
	-- Main
	("LOC_EPSTWEAK_WONDER_WORDING_TOURISM_1",								   "+2 [ICON_Tourism] Tourism"),
	("LOC_EPSTWEAK_WONDER_WORDING_TOURISM_2",								   "+1 [ICON_Tourism] extra per Era that you've advanced past this Wonder's era"),
	("LOC_DISTRICT_HD_IS_SPECIALTY_DISTRICT",								 "Specialty District"),
	("LOC_DISTRICT_HD_IS_NOT_SPECIALTY_DISTRICT",							 "District"),
	("LOC_UI_PEDIA_CITIZEN_YIELDS",										   "Citizen Yields (per citizen in this district)"),
	("LOC_TYPE_TRAIT_AMENITY_ENTERTAINMENT_POWER_ENHANCEMENT",				"{1_Amount: number +#,###;-#,###} [ICON_Amenities] {1_Amount : plural 1?Amenity; other?Amenities;} additionally when this city is [ICON_Power] Powered"),
	("LOC_TYPE_TRAIT_YIELD_POWER_ENHANCEMENT",								"{1_Amount: number +#,###;-#,###} {2_Icon} {3_Name} additionally when this city is [ICON_Power] Powered"),
	("LOC_HAPPINESS_DELIGHTED_NAME",										  "Delighted"),
	("LOC_HAPPINESS_JOYFUL_NAME",											 "Joyful"),
	("LOC_IMPROVEMENT_GOODY_BUILDER_NAME",									"Please Ignore"),
	("LOC_LOYALTY_LEVEL_4_NAME",											  "Unswervingly Loyal"),
	("LOC_LOYALTY_LEVEL_4_DESCRIPTION",									   "The Citizens are Unswervingly Loyal to your civilization!"),
	("LOC_TURNS_BEFORE_DESTROY_HD",										   "Completely destroy after {1_num} turns"),
	("LOC_CANNOT_REMOVE_FEATURE_USING_RECONS",								"Cannot remove features using Recon units"),
	("LOC_VIZSOURCE_CHANCERY",												"Built Building Chancery"),
	("LOC_VIZSOURCE_ACTION_CHANCERY",										 "Build Building Chancery"),
	("LOC_GOSSIP_SOURCE_CHANCERY",											"Your officier from Chancery informed that "),
	("LOC_GOSSIP_SOURCE_GOV_SPIES",										   "Your senator informed that "),
	("LOC_VIZSOURCE_GOV_SPIES",											   "Built Building International parliamentary Body"),
	("LOC_VIZSOURCE_ACTION_GOV_SPIES",										"Build Building International parliamentary Body"),
	("LOC_DISTRICT_LUMBER_MILL_1_PRODUCTION",								 "+{1_num} [ICON_Production] Production from the adjacent Lumber Mill."),
	("LOC_DISTRICT_DESERT_SCIENCE",										   "+{1_num} [ICON_Science] Science from adjacent Desert {1_Num : plural 1?Tile; other?Tiles;}."),
	("LOC_DISTRICT_DESERT_HILLS_SCIENCE",									 "+{1_num} [ICON_Science] Science from adjacent Desert Hills {1_Num : plural 1?Tile; other?Tiles;}."),
	("LOC_DISTRICT_HARBOR_HANSA_PRODUCTION",								  "+{1_num} [ICON_Production] Production from adjacent Harbor {1_Num : plural 2?district; other?districts;}."),
	("LOC_DISTRICT_ROYALDOCK_HANSA_PRODUCTION",							   "+{1_num} [ICON_Production] Production from adjacent RoyalDock {1_Num : plural 2?district; other?districts;}."),
	("LOC_DISTRICT_COTHON_HANSA_PRODUCTION",								  "+{1_num} [ICON_Production] Production from adjacent Cothon {1_Num : plural 2?district; other?districts;}."),
	("LOC_ALLIANCE_LV2_RESEARCH_EFFECT_1",									"Every 10 turns (on Standard), you unlock a [ICON_TechBoosted] Eureka for a tech that your ally has researched or boosted, but you have not."),
	("LOC_ALLIANCE_LV1_MILITARY_EFFECT_2",									"+2 [ICON_Production] Production from [ICON_TradeRoute] Trade Routes to your ally"),
	("LOC_ALLIANCE_LV1_MILITARY_EFFECT_3",									"+1 [ICON_Production] Production from [ICON_TradeRoute] Trade Routes from your ally"),
  ("LOC_AND_DIPLOMATIC_QUARTER",                         ""),
  ("LOC_OR_DIPLOMATIC_QUARTER",                         ""),
  ("LOC_HUD_SEADOG_LENS",                         "Naval Raider"),
  ("LOC_HUD_SEADOG_LENS_TOOLTIP",                         "Highlights goody huts on the map"),
  ("LOC_TIER_1_GOVERNMRNT_NAME",         	"Tier 1 Government"),
  ("LOC_TIER_2_GOVERNMRNT_NAME",         	"Tier 2 Government"),
  ("LOC_TIER_3_GOVERNMRNT_NAME",         	"Tier 3 Government"),
  ("LOC_TIER_4_GOVERNMRNT_NAME",         	"Tier 4 Government"),
  ("LOC_TERRAIN_GRASS_HILLS_NAME",         			"Grassland Hills"),
  ("LOC_TERRAIN_COAST_NAME",         						"Shallow Sea and Lake"),
  ("LOC_TOOLTIP_COAST",         								"Shallow Sea"),
  ("LOC_TERRAIN_OCEAN_NAME",         						"Deep Ocean"),
  ("LOC_TERRAIN_GRASS_MOUNTAIN_NAME",         	"Grassland Mountain"),
  ("LOC_TERRAIN_PLAINS_HILLS_NAME",         		"Plains Hills"),
  ("LOC_TERRAIN_PLAINS_MOUNTAIN_NAME",         	"Plains Mountain"),
  ("LOC_TERRAIN_DESERT_HILLS_NAME",         		"Desert Hills"),
  ("LOC_TERRAIN_DESERT_MOUNTAIN_NAME",         	"Desert Mountain"),
  ("LOC_TERRAIN_TUNDRA_HILLS_NAME",         		"Tundra Hills"),
  ("LOC_TERRAIN_TUNDRA_MOUNTAIN_NAME",         	"Tundra Mountain"),
  ("LOC_TERRAIN_SNOW_HILLS_NAME",         			"Snow Hills"),
  ("LOC_TERRAIN_SNOW_MOUNTAIN_NAME",         		"Snow Mountain"),
  ("LOC_TERRAIN_CLASS_MOUNTAIN_NAME",         	"Mountain"),
  ("LOC_TERRAIN_CLASS_WATER_NAME",         			"Water Area"),
	("LOC_RESOURCE_STONE_NAME",                                   "Andesite"),
	("LOC_RESOURCE_FISH_NAME",                                    "Threadfin");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
	(Language,	  Tag,																	 Text)
values
	-- UI texts 
	("zh_Hans_CN",  "LOC_HD_MESSAGE",														"和而不同"),
	("zh_Hans_CN",  "LOC_PANTHEON_SELECTED_BY_OTHERS",									   "该万神殿已被他人选取"),
	("zh_Hans_CN",  "LOC_BELIEF_SELECTED_BY_OTHERS",										 "该宗教信仰已被他人选取"),
	("zh_Hans_CN",  "LOC_COMMEMORATION_CANNOT_SELECT",										 "[COLOR_RED]该着力点不可选择。[ENDCOLOR]"),
	("zh_Hans_CN",  "LOC_UNITCOMMAND_SACRIFICE_NAME",										"活人献祭"),
	("zh_Hans_CN",  "LOC_UNITCOMMAND_SACRIFICE_DESCRIPTION",								 "向神明献祭该单位，每有一次剩余劳动力获得10点 [ICON_Culture] 文化值和10点 [ICON_Faith] 信仰值，移除该单位。"),
	("zh_Hans_CN",  "LOC_UNITCOMMAND_SACRIFICE_DISABLED_TT",								 "[COLOR_RED]必须位于市中心[ENDCOLOR]"),
	("zh_Hans_CN",  "LOC_FLYOVER_AZTEC_SACRIFICE",										   "活人献祭[COLOR:ResCultureLabelCS]+{1_Amount}[ENDCOLOR][ICON_Culture][COLOR:ResFaithLabelCS]+{1_Amount}[ENDCOLOR][ICON_Faith]"),
	-- Main
	("zh_Hans_CN",  "LOC_GOVERNMENT_INHERENT_BONUS",										 "传承效果"), -- 官方好像在ui上面写反了。

	("zh_Hans_CN",  "LOC_EPSTWEAK_WONDER_WORDING_TOURISM_1",								   "+2 [ICON_Tourism] 旅游业绩"),
	("zh_Hans_CN",  "LOC_EPSTWEAK_WONDER_WORDING_TOURISM_2",								   "您所处时代每超越该奇观所属的时代一个时代，则+1 [ICON_Tourism] 旅游业绩"),
	("zh_Hans_CN",  "LOC_DISTRICT_HD_IS_SPECIALTY_DISTRICT",								 "专业化区域"),
	("zh_Hans_CN",  "LOC_DISTRICT_HD_IS_NOT_SPECIALTY_DISTRICT",							 "非专业化区域"),
	("zh_Hans_CN",  "LOC_UI_PEDIA_CITIZEN_YIELDS",										   "每个在此区域中工作的 [ICON_Citizen] 专家收益"),
	("zh_Hans_CN",  "LOC_TYPE_TRAIT_CITIZENS",											   "{1_Amount: number +#,###;-#,###} [ICON_Citizen] 专家{1_Amount : plural 1?槽位; other?槽位;}"),
	("zh_Hans_CN",  "LOC_TYPE_TRAIT_CITIZENSLOTS",										   "{1_Amount: number +#,###;-#,###} [ICON_Citizen] 专家{1_Amount : plural 1?槽位; other?槽位;}"),
	("zh_Hans_CN",  "LOC_TYPE_TRAIT_AMENITY_ENTERTAINMENT_POWER_ENHANCEMENT",				"此城 [ICON_Power] 供电充足时，额外{1_Amount: number +#,###;-#,###} [ICON_Amenities] {1_Amount : plural 1?宜居度; other?宜居度;}"),
	("zh_Hans_CN",  "LOC_TYPE_TRAIT_YIELD_POWER_ENHANCEMENT",								"此城 [ICON_Power] 供电充足时，额外{1_Amount: number +#,###;-#,###} {2_Icon} {3_Name}"),
	("zh_Hans_CN",  "LOC_HAPPINESS_DELIGHTED_NAME",										  "愉悦"),
	("zh_Hans_CN",  "LOC_HAPPINESS_JOYFUL_NAME",											 "喜悦"),
	("zh_Hans_CN",  "LOC_IMPROVEMENT_GOODY_BUILDER_NAME",									"请忽略"),
	("zh_Hans_CN",  "LOC_LOYALTY_LEVEL_4_NAME",											  "绝对忠诚"),
	("zh_Hans_CN",  "LOC_LOYALTY_LEVEL_4_DESCRIPTION",									   "您的公民绝对忠于您的文明。"),
	("zh_Hans_CN",  "LOC_TURNS_BEFORE_DESTROY_HD",										   "将在{1_num}回合后被彻底摧毁"),
	("zh_Hans_CN",  "LOC_DISTRICT_BASE_DISTRICT_SCIENCE",									"+{1_Num} [ICON_Science] 科技值。"),
	("zh_Hant_HK",  "LOC_DISTRICT_BASE_DISTRICT_SCIENCE",									"+{1_Num} [ICON_Science] 科技值。"),
	("zh_Hans_CN",  "LOC_CANNOT_REMOVE_FEATURE_USING_RECONS",								"侦察类单位不能移除地貌"),
	("zh_Hans_CN",  "LOC_VIZSOURCE_CHANCERY",												"建造了外交办"),
	("zh_Hans_CN",  "LOC_VIZSOURCE_ACTION_CHANCERY",										 "建造外交办"),
	("zh_Hans_CN",  "LOC_GOSSIP_SOURCE_CHANCERY",											"外交办的官员 帝普罗杰克 获悉"),
	("zh_Hans_CN",  "LOC_GOSSIP_SOURCE_GOV_SPIES",										   "议会议员 五字老师 获悉"),
	("zh_Hans_CN",  "LOC_VIZSOURCE_GOV_SPIES",											   "建造了国际议会机构"),
	("zh_Hans_CN",  "LOC_VIZSOURCE_ACTION_GOV_SPIES",										"建造国际议会机构"),
	("zh_Hans_CN",  "LOC_PROMOTION_SHELLS_DESCRIPTION",									  "与区域防御战斗时+10 [ICON_Strength] 战斗力。"),
	("zh_Hans_CN",  "LOC_UNIT_GAUL_GAESATAE_DESCRIPTION",									"高卢特色远古时代单位，替代勇士。此单位拥有更高花费。与基础战斗力更高的单位作战时+10 [ICON_Strength] 战斗力。与区域防御战斗时+5 [ICON_Strength] 战斗力。"),
	("zh_Hans_CN",  "LOC_DISTRICT_LUMBER_MILL_1_PRODUCTION",								 "相邻伐木场提供+{1_num} [ICON_Production] 生产力。"),
	("zh_Hans_CN",  "LOC_DISTRICT_DESERT_SCIENCE",										   "+{1_num} [ICON_Science] 科技值来自相邻的沙漠单元格。"),
	("zh_Hans_CN",  "LOC_DISTRICT_DESERT_HILLS_SCIENCE",									 "+{1_num} [ICON_Science] 科技值来自相邻的沙漠丘陵单元格。"),
	--研究同盟
	("zh_Hans_CN",  "LOC_ALLIANCE_LV2_RESEARCH_EFFECT_1",									"每5回合（标准游戏速度下）解锁1个您盟友已研究或提升，而您尚未研究之科技的 [ICON_TechBoosted] 尤里卡"),
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_RESEARCH_EFFECT_1",									"从通往盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_SCIENCE] 科技值+2，需要“行政部门”市政"),
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_RESEARCH_EFFECT_2",									"从源自盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_SCIENCE] 科技值+1，需要“行政部门”市政"),	
	--军事同盟	
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_MILITARY_EFFECT_2",									"从通往盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_Production] 生产力+2，需要“行政部门”市政"),
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_MILITARY_EFFECT_3",									"从源自盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_Production] 生产力+1，需要“行政部门”市政"),
	--经济同盟
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_ECONOMIC_EFFECT_1",									"从通往盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_GOLD] 金币+4，需要“行政部门”市政"),
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_ECONOMIC_EFFECT_2",									"从源自盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_GOLD] 金币+2，需要“行政部门”市政"),
	--宗教同盟
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_RELIGIOUS_EFFECT_1",									"从通往盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_FAITH] 信仰值+2，需要“行政部门”市政"),
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_RELIGIOUS_EFFECT_2",									"从源自盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_FAITH] 信仰值+1，需要“行政部门”市政"),
	--文化同盟
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_CULTURAL_EFFECT_1",									"从通往盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_Culture] 文化值+2，需要“行政部门”市政"),
	("zh_Hans_CN",  "LOC_ALLIANCE_LV1_CULTURAL_EFFECT_2",									"从源自盟友城市的 [ICON_TradeRoute] 贸易路线处获得的 [ICON_Culture] 文化值+1，需要“行政部门”市政"),
  ("zh_Hans_CN",  "LOC_AND_DIPLOMATIC_QUARTER",                         	""),
  ("zh_Hans_CN",  "LOC_OR_DIPLOMATIC_QUARTER",                         		""),
  ("zh_Hans_CN",  "LOC_HUD_SEADOG_LENS",                         					"海狗"),
  ("zh_Hans_CN",  "LOC_HUD_SEADOG_LENS_TOOLTIP",                         	"高亮显示地图上的部落村庄"),
  ("zh_Hans_CN",  "LOC_QUEST_ZONE_DISTRICT_TYPE_INSTANCE_NAME",          	"建造一座{1_DistrictName}。"),
  ("zh_Hans_CN",  "LOC_QUEST_TRAIN_UNIT_TYPE_INSTANCE_NAME",            	"训练一个{1_UnitName}。"),
  ("zh_Hans_CN",  "LOC_QUEST_RECRUIT_GREAT_PERSON_CLASS_INSTANCE_NAME",  	"招募一名{1_GreatPersonClassName}。"),
  ("zh_Hans_CN",  "LOC_QUEST_TRIGGER_TECH_BOOST_INSTANCE_NAME",          	"触发{1_TechName}的 [ICON_TechBoosted] 尤里卡。"),
  ("zh_Hans_CN",  "LOC_QUEST_TRIGGER_CIVIC_BOOST_INSTANCE_NAME",         	"触发{1_CivicName}的 [ICON_CivicBoosted] 鼓舞。"),
  ("zh_Hans_CN",  "LOC_TIER_1_GOVERNMRNT_NAME",         	"一级政体"),
  ("zh_Hans_CN",  "LOC_TIER_2_GOVERNMRNT_NAME",         	"二级政体"),
  ("zh_Hans_CN",  "LOC_TIER_3_GOVERNMRNT_NAME",         	"三级政体"),
  ("zh_Hans_CN",  "LOC_TIER_4_GOVERNMRNT_NAME",         	"四级政体"),
  ("zh_Hans_CN",  "LOC_TERRAIN_COAST_NAME",         					"浅海与湖泊"),
  ("zh_Hans_CN",  "LOC_TOOLTIP_COAST",         								"浅海"),
  ("zh_Hans_CN",  "LOC_TERRAIN_OCEAN_NAME",         					"深海"),
  ("zh_Hans_CN",  "LOC_TERRAIN_GRASS_HILLS_NAME",         			"草原丘陵"),
  ("zh_Hans_CN",  "LOC_TERRAIN_GRASS_MOUNTAIN_NAME",         	"草原山脉"),
  ("zh_Hans_CN",  "LOC_TERRAIN_PLAINS_HILLS_NAME",         		"平原丘陵"),
  ("zh_Hans_CN",  "LOC_TERRAIN_PLAINS_MOUNTAIN_NAME",         	"平原山脉"),
  ("zh_Hans_CN",  "LOC_TERRAIN_DESERT_HILLS_NAME",         		"沙漠丘陵"),
  ("zh_Hans_CN",  "LOC_TERRAIN_DESERT_MOUNTAIN_NAME",         	"沙漠山脉"),
  ("zh_Hans_CN",  "LOC_TERRAIN_TUNDRA_HILLS_NAME",         		"冻土丘陵"),
  ("zh_Hans_CN",  "LOC_TERRAIN_TUNDRA_MOUNTAIN_NAME",         	"冻土山脉"),
  ("zh_Hans_CN",  "LOC_TERRAIN_SNOW_HILLS_NAME",         			"雪地丘陵"),
  ("zh_Hans_CN",  "LOC_TERRAIN_SNOW_MOUNTAIN_NAME",         		"雪地山脉"),
  ("zh_Hans_CN",  "LOC_TERRAIN_CLASS_MOUNTAIN_NAME",         		"山脉"),
  ("zh_Hans_CN",  "LOC_TERRAIN_CLASS_WATER_NAME",         		"水域"),
	("zh_Hans_CN",  "LOC_RESOURCE_STONE_NAME",                                   "安山岩"),
	("zh_Hans_CN",  "LOC_RESOURCE_FISH_NAME",                                    "鲅鱼"),
	("zh_Hans_CN",  "LOC_RESOURCE_COPPER_NAME",                                  "铜矿"),
	("zh_Hans_CN",  "LOC_RESOURCE_CATTLE_NAME",                                  "奶牛"),
	("zh_Hans_CN",  "LOC_RESOURCE_SHEEP_NAME",                                   "绵羊");

-- 外交区DLC文本
update LocalizedText set Text = "and {LOC_DISTRICT_DIPLOMATIC_QUARTER_NAME} " where Tag = 'LOC_AND_DIPLOMATIC_QUARTER'
	and exists (select Tag from LocalizedText where Tag = 'LOC_DISTRICT_DIPLOMATIC_QUARTER_NAME');
update LocalizedText set Text = "和{LOC_DISTRICT_DIPLOMATIC_QUARTER_NAME}" where Language = 'zh_Hans_CN' and Tag = 'LOC_AND_DIPLOMATIC_QUARTER'
	and exists (select Tag from LocalizedText where Tag = 'LOC_DISTRICT_DIPLOMATIC_QUARTER_NAME');

update LocalizedText set Text = "or {LOC_DISTRICT_DIPLOMATIC_QUARTER_NAME} " where Tag = 'LOC_OR_DIPLOMATIC_QUARTER'
	and exists (select Tag from LocalizedText where Tag = 'LOC_DISTRICT_DIPLOMATIC_QUARTER_NAME');
update LocalizedText set Text = "或{LOC_DISTRICT_DIPLOMATIC_QUARTER_NAME}" where Language = 'zh_Hans_CN' and Tag = 'LOC_OR_DIPLOMATIC_QUARTER'
	and exists (select Tag from LocalizedText where Tag = 'LOC_DISTRICT_DIPLOMATIC_QUARTER_NAME');

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
	(Language,	  Tag,																 Text)
values
	("zh_Hans_CN",  "LOC_RESOURCE_GOLD_NAME",											"黄金"),
	("zh_Hans_CN",  "LOC_PEDIA_RESOURCES_PAGE_RESOURCE_GOLD_CHAPTER_HISTORY_PARA_1",	 "黄金是一种柔软、有光泽和延展性的金属，在历史上一直受到人们的珍视。这是一种稀有金属，它的稀有性大大增加了它的价值。尽管黄金有一些工业和医疗用途，但它主要用作铸币或装饰用途，装饰珠宝、杯子、器皿以及超级富豪和权贵的马桶。 ");

--------------------------------------------------------------------------------
-- projects
-- Language: en_US
insert or replace into EnglishText
	(Tag,																	 Text)
values
	("LOC_PROJECT_COTHON_CAPITAL_MOVE_DESCRIPTION",								"Phoenician unique project available to any city founded by you with a Cothon. When complete, the Phoenician [ICON_CAPITAL] Capital moves to this city."),
	("LOC_PROJECT_LAUNCH_MOON_LANDING_DESCRIPTION",							  "Space Race project which launches a large rocket to land a human on the moon. [ICON_CIVICBOOSTED] Inspirations provide +10% [ICON_CULTURE] Culture after finishing this Project. Trigger the [ICON_CIVICBOOSTED] Inspiration of all Future Era Civics. Marks the second step towards the Science Victory."),
	("LOC_PROJECT_BREAD_AND_CIRCUSES_DESCRIPTION",							"City project which increases the Loyalty Pressure that this city exerts on itself and other cities nearby.[NEWLINE][NEWLINE]While active, each of your [ICON_Citizen] Citizens here exerts +1 Loyalty pressure to this city. This pressure also affects other cities within 9 tiles, but is 10% less effective per tile. Once completed, instantly gain +20 Loyalty in this city.[NEWLINE][NEWLINE]Requires: Entertainment Complex district."),
	("LOC_PROJECT_CIRCUSES_AND_BREAD_HD_NAME",								"Judgement of Love"),
	("LOC_PROJECT_CIRCUSES_AND_BREAD_HD_SHORT_NAME",						  "Judgement of Love"),
	("LOC_PROJECT_CIRCUSES_AND_BREAD_HD_DESCRIPTION",						 "Once completed, other Civilizations' cities within 9 tiles and having negative Loyalty per turn will instantly lose all Loyalty."),
	("LOC_PROJECT_ENDLESS_MONEY_HD_NAME",									 "Endless Money"),
	("LOC_PROJECT_ENDLESS_MONEY_HD_SHORT_NAME",							   "Endless Money"),
	("LOC_PROJECT_ENDLESS_MONEY_HD_DESCRIPTION",							  "City project which provides a huge amount of [ICON_Gold] Gold every turn."),
	("LOC_PROJECT_GRANT_RESOURCE_HORSES_HD_NAME",							 "Mule Breeding"),
	("LOC_PROJECT_GRANT_RESOURCE_HORSES_HD_SHORT_NAME",					   "Mule Breeding"),
	("LOC_PROJECT_GRANT_RESOURCE_HORSES_HD_DESCRIPTION",					  "Stable project. Once completed, instantly gain +20 [ICON_RESOURCE_HORSES] Horses."),
	("LOC_PROJECT_GRANT_RESOURCE_IRON_HD_NAME",							   "Recycling Ironware"),
	("LOC_PROJECT_GRANT_RESOURCE_IRON_HD_SHORT_NAME",						 "Recycling Ironware"),
	("LOC_PROJECT_GRANT_RESOURCE_IRON_HD_DESCRIPTION",						"Barracks project. Once completed, instantly gain +20 [ICON_RESOURCE_IRON] Iron."),
	("LOC_PROJECT_GRANT_RESOURCE_NITER_HD_NAME",							  "Droit de Fouille"),
	("LOC_PROJECT_GRANT_RESOURCE_NITER_HD_SHORT_NAME",						"Droit de Fouille"),
	("LOC_PROJECT_GRANT_RESOURCE_NITER_HD_DESCRIPTION",					   "Armory project. Once completed, instantly gain +20 [ICON_RESOURCE_NITER] Niter."),
	("LOC_PROJECT_GRANT_RESOURCE_COAL_HD_NAME",							   "Charcoal Production"),
	("LOC_PROJECT_GRANT_RESOURCE_COAL_HD_SHORT_NAME",						 "Charcoal Production"),
	("LOC_PROJECT_GRANT_RESOURCE_COAL_HD_DESCRIPTION",						"Armory project. Once completed, instantly gain +20 [ICON_RESOURCE_COAL] Coal."),
	("LOC_PROJECT_GRANT_RESOURCE_OIL_HD_NAME",								"Shale Oil Extraction"),
	("LOC_PROJECT_GRANT_RESOURCE_OIL_HD_SHORT_NAME",						  "Shale Oil Extraction"),
	("LOC_PROJECT_GRANT_RESOURCE_OIL_HD_DESCRIPTION",						 "Military academy project. Once completed, instantly gain +20 [ICON_RESOURCE_OIL] Oil."),
	("LOC_PROJECT_GRANT_RESOURCE_ALUMINUM_HD_NAME",						   "Selective Silica Removal"),
	("LOC_PROJECT_GRANT_RESOURCE_ALUMINUM_HD_SHORT_NAME",					 "Selective Silica Removal"),
	("LOC_PROJECT_GRANT_RESOURCE_ALUMINUM_HD_DESCRIPTION",					"Military academy project. Once completed, instantly gain +20 [ICON_RESOURCE_ALUMINUM] Aluminum."),
	("LOC_PROJECT_GRANT_RESOURCE_URANIUM_HD_NAME",							"Breeder Reactor"),
	("LOC_PROJECT_GRANT_RESOURCE_URANIUM_HD_SHORT_NAME",					  "Breeder Reactor"),
	("LOC_PROJECT_GRANT_RESOURCE_URANIUM_HD_DESCRIPTION",					 "Military Academy project. Once completed, instantly gain +20 [ICON_RESOURCE_URANIUM] Uranium."),

	("LOC_DISTRICT_APPEAL_FOOD",					 			"+{1_num} [ICON_Food] Food from the tile's Appeal."),
	("LOC_DISTRICT_APPEAL_PRODUCTION",					"+{1_num} [ICON_Production] Production from the tile's Appeal.");
	-- ("LOC_PROJECT_RECRUIT_WORKERS_HD_NAME",								   "Recruit Workers"),
	-- ("LOC_PROJECT_RECRUIT_WORKERS_HD_SHORT_NAME",							 "Recruit Workers"),
	-- ("LOC_PROJECT_RECRUIT_WORKERS_HD_DESCRIPTION",							"City project. If this city has at least 2 [ICON_Citizen] Citizens, this project grants a builder and reduces 1 [ICON_Citizen] Citizen.[NEWLINE]If this city has only 1 [ICON_Citizen] Citizen, this project will take effect later when the population of this city increases next time.");

-- Language: zh_Hans_CN
insert or replace into LocalizedText
	(Language,	  Tag,																	Text)
values
	("zh_Hans_CN",  "LOC_PROJECT_COTHON_CAPITAL_MOVE_DESCRIPTION",								"腓尼基特色项目，可在由你建立的拥有U型港的城市中开展。完成时，腓尼基的原始 [ICON_CAPITAL] 首都将迁至该城市。"),
	("zh_Hans_CN",	"LOC_PROJECT_LAUNCH_MOON_LANDING_DESCRIPTION",							 "发射火箭让人类登陆月球的太空竞赛项目。完成此项目后，[ICON_CIVICBOOSTED] 鼓舞额外提供+10% [ICON_CULTURE] 文化值。所有未来时代的市政获得 [ICON_CIVICBOOSTED] 鼓舞。标志着科技胜利的第二步。"),
	("zh_Hans_CN",  "LOC_PROJECT_BREAD_AND_CIRCUSES_DESCRIPTION",							"城市项目，可增加此城市对自身和对附近其他城市施加的忠诚度压力。[NEWLINE][NEWLINE]项目启动后，每位 [ICON_Citizen] 公民每回合对此城所施加的忠诚度压力+1。此忠诚度压力还将影响9个单元格以内的其他城市，但每远离1个单元格，效果减弱10%。项目完成后此城立即+20忠诚度。[NEWLINE][NEWLINE]需要先建成“娱乐设施”区域。"),
	("zh_Hans_CN",  "LOC_PROJECT_CIRCUSES_AND_BREAD_HD_NAME",								"爱之审判"),
	("zh_Hans_CN",  "LOC_PROJECT_CIRCUSES_AND_BREAD_HD_SHORT_NAME",						  "爱之审判"),
	("zh_Hans_CN",  "LOC_PROJECT_CIRCUSES_AND_BREAD_HD_DESCRIPTION",						 "完成此项目时，在此剧院广场9个单元格以内的其他文明城市，如果忠诚变化趋势为“正在下降”，立即失去全部忠诚度，更易转变为自由城市"),
	("zh_Hans_CN",  "LOC_PROJECT_ENDLESS_MONEY_HD_NAME",									 "多钱善贾"),
	("zh_Hans_CN",  "LOC_PROJECT_ENDLESS_MONEY_HD_SHORT_NAME",							   "多钱善贾"),
	("zh_Hans_CN",  "LOC_PROJECT_ENDLESS_MONEY_HD_DESCRIPTION",							  "城市项目，每回合提供巨额 [ICON_Gold] 金币。"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_HORSES_HD_NAME",							 "良驹育种"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_HORSES_HD_SHORT_NAME",					   "良驹育种"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_HORSES_HD_DESCRIPTION",					  "马厩项目，项目完成后提供20点 [ICON_RESOURCE_HORSES] 马。"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_IRON_HD_NAME",							   "土制高炉"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_IRON_HD_SHORT_NAME",						 "土制高炉"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_IRON_HD_DESCRIPTION",						"兵营项目，项目完成后提供20点 [ICON_RESOURCE_IRON] 铁。"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_NITER_HD_NAME",							  "烈性炸药"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_NITER_HD_SHORT_NAME",						"烈性炸药"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_NITER_HD_DESCRIPTION",					   "兵工厂项目，项目完成后提供20点 [ICON_RESOURCE_NITER] 硝石。"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_COAL_HD_NAME",							   "特种燃料"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_COAL_HD_SHORT_NAME",						 "特种燃料"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_COAL_HD_DESCRIPTION",						"兵工厂项目，项目完成后提供20点 [ICON_RESOURCE_COAL] 煤。"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_OIL_HD_NAME",								"页岩提取"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_OIL_HD_SHORT_NAME",						  "页岩提取"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_OIL_HD_DESCRIPTION",						 "军事学院项目，项目完成后提供20点 [ICON_RESOURCE_OIL] 石油。"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_ALUMINUM_HD_NAME",						   "稀土研究"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_ALUMINUM_HD_SHORT_NAME",					 "稀土研究"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_ALUMINUM_HD_DESCRIPTION",					"军事学院项目，项目完成后提供20点 [ICON_RESOURCE_ALUMINUM] 铝。"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_URANIUM_HD_NAME",							"气体离心"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_URANIUM_HD_SHORT_NAME",					  "气体离心"),
	("zh_Hans_CN",  "LOC_PROJECT_GRANT_RESOURCE_URANIUM_HD_DESCRIPTION",					 "军事学院项目，项目完成后提供20点 [ICON_RESOURCE_URANIUM] 铀。"),
	("zh_Hans_CN",  "LOC_PROJECT_ORBITAL_LASER_DESCRIPTION",					 		"需要30点 [ICON_RESOURCE_ALUMINUM] 铝才能开始建造（标准速度下）。“太空竞赛”项目将使每回合“系外行星探索”的加速1光年，从而加快您的科技胜利进程。"),

	("zh_Hans_CN",  "LOC_DISTRICT_APPEAL_FOOD",					 			"+{1_num} [ICON_FOOD] 食物来自单元格魅力加成。"),
	("zh_Hans_CN",  "LOC_DISTRICT_APPEAL_PRODUCTION",					"+{1_num} [ICON_PRODUCTION] 生产力来自单元格魅力加成。"),

	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_RIVER_DEFENSE_DESC",								"+{1_Value} 河流防御"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_BONUS_VS_BARBARIANS",								"+{1_Value} 对战蛮族优势"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_TERRAIN_PENALTY",										"[COLOR_RED]{1_Value} 不利地形[ENDCOLOR]"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DEFENSIVE_IMPROVEMENT_BONUS_DESC",	"+{1_Value} 静态防御工事"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_TERRAIN_BONUS_DESC",								"+{1_Value} 理想地形"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_FRIENDLY_TERRITORY_BONUS",					"+{1_Value} 友军领土"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_RELIGIOUS_TERRAIN_BONUS_DESC",			"+{1_Value} 圣地"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_FORTIFIED_DEFENSE_DESC",						"+{1_Value} 强化防御"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_LESS_EFFECTIVE_VS_UNITS_DESC",			"-{1_Value} 对战单位"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_LESS_EFFECTIVE_VS_WALLS_DESC",			"-{1_Value} 对战防御工事"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_FLANKING_BONUS_DESC",								"+{1_Value} 夹击加成"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_LUXURY_ATTACK_BONUS_DESC",					"+{1_Value} 每个奢侈攻击加成"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_NUMBER_MILITARY_POLICIES_BONUS_DESC","+{1_Value} 来自槽中的军事政策"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DISTRICT_WALLS_BONUS",							"+{1_Value} 城墙防御"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DISTRICT_ENHANCED_WALLS_BONUS",			"+{1_Value} 强化防御"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DISTRICT_CASTLE_BONUS",							"+{1_Value} 城堡防御"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DISTRICT_STARFORT_BONUS",						"+{1_Value} 星形要塞防御"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DISTRICT_GARRISONED_UNIT_BONUS",		"+{1_Value} 驻守{2_Unit}"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DISTRICT_PALACE_BONUS",							"+{1_Value} 放置守卫"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DISTRICT_STRENGTH_BONUS",						"+{1_Value} 来自区域"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_ENVOY_STRENGTH_BONUS",							"+{1_Value} 来自外界影响"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_SUPPORT_BONUS_DESC",								"+{1_Value} 支援加成"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DAMAGED_UNIT_DESC",									"[COLOR_RED]{1_Value} 受损单位[ENDCOLOR]"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DAMAGED_DISTRICT_DESC",							"[COLOR_RED]{1_Value} 受损区域[ENDCOLOR]"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_DISTRICT_ATTACK_BONUS",							"+{1 Value} 远程攻击加成"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_TRAIT_KILLER_OF_CYRUS",							"+{1_Value} 对战伤员单位加成"),
	("zh_Hans_CN",  "LOC_COMBAT_PREVIEW_AMPHIBIOUS_ATTACK_PENALTY",					"{1_Amount} 水陆两栖攻击减益"),

	("zh_Hans_CN",  "LOC_DIPLO_KUDO_LEADER_ANY_REASON_AGENDA_MODIFIER_NOT_COMPETING_MINORS",					"我们是城邦的真正朋友。我们很感激您承认这一事实。");

--------------------------------------------------------------------------------   
-- error texts
-- Language: en_US
insert or replace into EnglishText
	(Tag,																	 Text)
values
	("LOC_CITY_YIELD_MODIFIER_PER_GOVERNOR_TITLE_TOOLTIP",					"{Value : number +#;-#}% ({ActualValue : number +#.#;-#.#}) from [ICON_Governor] Governor with {1} {1 : plural 1?Promotion; other?Promotions;}"),
--	("LOC_WORLD_RANKINGS_CULTURE_TOURIST_TOOLTIP_GOVERNMENT",				"{1_Tooltip}[NEWLINE]Overall [ICON_Tourism] Tourism Boosted {2_Percent}% for Different Governments");
	("LOC_WORLD_RANKINGS_CULTURE_TOURIST_TOOLTIP_GOVERNMENT",				"{1_Tooltip}");

-- Language: zh_Hans_CN
insert or replace into LocalizedText
	(Language,	  Tag,																 Text)
values
	("zh_Hans_CN",  "LOC_CITY_YIELD_FROM_TERRAIN_TOOLTIP",							   "{Value : number +#.#;-#.#}来自地形"),
	("zh_Hans_CN",  "LOC_PLAYER_YIELD_FAITH_FROM_BELIEFS",							   "{Value : number +#.#;-#.#}来自信仰"),
	("zh_Hans_CN",  "LOC_PLAYER_YIELD_CULTURE_FROM_TRIBUTARIES",						 "{Value : number +#.#;-#.#}来自您是领主的城邦"),
	("zh_Hans_CN",  "LOC_CITY_YIELD_MODIFIER_PER_GOVERNOR_TITLE_TOOLTIP",				"{Value : number +#;-#}%（{ActualValue : number +#.#;-#.#}）来自拥有{1}次{1 : plural 1?升级; other?升级;}的 [ICON_Governor] 总督"),
--	("zh_Hans_CN",	"LOC_WORLD_RANKINGS_CULTURE_TOURIST_TOOLTIP_GOVERNMENT",			"{1_Tooltip}[NEWLINE]总的 [ICON_Tourism] 旅游业绩因不同政体而提升{2_Percent}%");
	("zh_Hans_CN",	"LOC_WORLD_RANKINGS_CULTURE_TOURIST_TOOLTIP_GOVERNMENT",			"{1_Tooltip}");

-- 糖改名甘蔗
update  LocalizedText set Text = REPLACE(Text, '糖', '甘蔗')
where Language = 'zh_Hans_CN' and (Tag in (
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_DESCRIPTION',
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_SHORT_NAME',
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_NAME'
));

update  LocalizedText set Text = REPLACE(Text, 'Sugar', 'Sugarcane')
where Tag in (
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_DESCRIPTION',
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_SHORT_NAME',
  'LOC_PROJECT_CREATE_CORPORATION_PRODUCT_SUGAR_NAME'
);