-- 由CLear8Sky对Mod Buddy内生成的SQL文件模板进行改动，以便于写入中文
-- VNL'Latin American Resources'CN_Add_IG2
-- Author: ChiYiuWong , Clear8Sky
-- DateCreated: 2021/8/15 15:40:18
--------------------------------------------------------------

-- 该文件对应补译/润色模组 “Latin American Resources” 中的 LatResources_Monopolies_Text.sql 文件。该文件在 InGame 时载入，需 Criteria ： Mode_Monopolies_ON 与 Active_Mod_LARes

---- 仿照原文件，建立临时表

CREATE TEMPORARY TABLE "C8SForLatinResources"
(
	"C8SForLatinResourceType" 			TEXT,
	"C8SForLatinResourceTypeShort" 		TEXT,
	"C8SForLatinResourceEffectDesc" 	TEXT,
	"C8SForLatinResourceName"			TEXT
);

---- 将对应数据填入表中

insert or ignore into C8SForLatinResources
		(C8SForLatinResourceType,		C8SForLatinResourceTypeShort,	C8SForLatinResourceEffectDesc,	C8SForLatinResourceName)
VALUES	
		("RESOURCE_LEU_P0K_CAPYBARAS",	"LEU_P0K_CAPYBARAS",			"SCIENCE_YIELD_BONUS",			"{LOC_RESOURCE_LEU_P0K_CAPYBARAS_NAME}"),
		("RESOURCE_LEU_P0K_COCA",		"LEU_P0K_COCA",					"FAITH_YIELD_BONUS",			"{LOC_RESOURCE_LEU_P0K_COCA_NAME}"),
		("RESOURCE_LEU_P0K_LLAMAS",		"LEU_P0K_LLAMAS",				"CIVILIAN_UNIT_DISCOUNT",		"{LOC_RESOURCE_LEU_P0K_LLAMAS_NAME}"),
		("RESOURCE_LEU_P0K_QUINOA",		"LEU_P0K_QUINOA",				"CITY_GROWTH_DISCOUNT",			"{LOC_RESOURCE_LEU_P0K_QUINOA_NAME}"),
		("RESOURCE_LEU_P0K_YERBAMATE",	"LEU_P0K_YERBAMATE",			"MILITARY_UNIT_DISCOUNT",		"{LOC_RESOURCE_LEU_P0K_YERBAMATE_NAME}");

---- 产品
------ 名称

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||C8SForLatinResourceTypeShort||"_NAME",
		"[ICON_"||C8SForLatinResourceType||"] "||C8SForLatinResourceName||"公司：开发新产品"
FROM C8SForLatinResources;

------ 短名

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||C8SForLatinResourceTypeShort||"_SHORT_NAME",
		"[ICON_"||C8SForLatinResourceType||"] 开发新的"||C8SForLatinResourceName||"产品"
FROM C8SForLatinResources;

------ 描述

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||C8SForLatinResourceTypeShort||"_DESCRIPTION",
		"利用 [ICON_"||C8SForLatinResourceType||"] "||C8SForLatinResourceName||"资源为世界开发新产品。[NEWLINE]{LOC_INDUSTRY_"||C8SForLatinResourceEffectDesc||"_DESCRIPTION}"
FROM C8SForLatinResources;

------ 百科介绍

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PEDIA_CONCEPTS_"||C8SForLatinResourceTypeShort,
		"[NEWLINE][ICON_BULLET]{LOC_"||C8SForLatinResourceType||"_NAME}：{LOC_P0K_RESOURCE_"||C8SForLatinResourceEffectDesc||"_DESCRIPTION}"
FROM C8SForLatinResources;

------ 百科页面

UPDATE LocalizedText
SET Text = REPLACE(Text, "Latin American Resources:", "由“Latin American 资源扩充”模组所添加：")
WHERE Tag = "LOC_PEDIA_CONCEPTS_PAGE_MONOPOLIES_CHAPTER_INDUSTRIES_PARA_2" AND Language = "zh_Hans_CN";

------ 产品加成

INSERT OR REPLACE INTO LocalizedText
		(Language,		Tag,														Text)
VALUES		
		("zh_Hans_CN",	"LOC_LEU_P0K_RESOURCE_CITY_GROWTH_DISCOUNT_DESCRIPTION",	"所在城市 [ICON_Citizen] 人口增长速度+20%，+3 [ICON_Housing] 住房。"),
		("zh_Hans_CN",	"LOC_LEU_P0K_RESOURCE_MILITARY_UNIT_DISCOUNT_DESCRIPTION",	"所在城市训练战斗单位+30% [ICON_Production] 生产力。"),
		("zh_Hans_CN",	"LOC_LEU_P0K_RESOURCE_CIVILIAN_UNIT_DISCOUNT_DESCRIPTION",	"所在城市训练平民单位+30% [ICON_Production] 生产力。"),
		("zh_Hans_CN",	"LOC_LEU_P0K_RESOURCE_BUILDING_DISCOUNT_DESCRIPTION",		"所在城市建造建筑+30% [ICON_Production] 生产力。"),
		("zh_Hans_CN",	"LOC_LEU_P0K_RESOURCE_GOLD_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Gold] 金币产出+25%。"),
		("zh_Hans_CN",	"LOC_LEU_P0K_RESOURCE_FAITH_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Faith] 信仰值产出+25%。"),
		("zh_Hans_CN",	"LOC_LEU_P0K_RESOURCE_SCIENCE_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Science] 科技值产出+15%。"),
		("zh_Hans_CN",	"LOC_LEU_P0K_RESOURCE_CULTURE_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Culture] 文化值产出+20%。"),

------ 产品名称

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_CAPYBARAS_1_NAME",			"野生动物相簿"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_CAPYBARAS_2_NAME",			"水豚毛绒玩具"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_CAPYBARAS_3_NAME",			"水豚儿童书籍"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_CAPYBARAS_4_NAME",			"瓦格斯|水豚社会行为研究"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_CAPYBARAS_5_NAME",			"水豚三哥姐"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_COCA_1_NAME",				"古柯糖浆"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_COCA_2_NAME",				"草本古柯浸液"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_COCA_3_NAME",				"阿库利库®古柯叶包"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_COCA_4_NAME",				"丹赞蒂©古柯能量饮料"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_COCA_5_NAME",				"卡拉瓦亚™治疗药膏"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_QUINOA_1_NAME",				"帕查奎克™藜麦片"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_QUINOA_2_NAME",				"超级营养棒"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_QUINOA_3_NAME",				"埃尔多拉多©有机藜麦"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_QUINOA_4_NAME",				"麦度昂®素食汉堡"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_QUINOA_5_NAME",				"天然藜麥奶昔"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_LLAMAS_1_NAME",				"阿卡帕查商队|载货羊驼"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_LLAMAS_2_NAME",				"羊驼营养熏肉"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_LLAMAS_3_NAME",				"阿拉斯塔®羊驼毛衣"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_LLAMAS_4_NAME",				"阿廷卡™羊驼帽"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_LLAMAS_5_NAME",				"恰恰瓦米©羊驼披风"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_YERBAMATE_1_NAME",			"圣伊格纳西奥波尔多|凉马黛茶"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_YERBAMATE_2_NAME",			"埃尔马特雷罗©经典耶巴马黛茶"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_YERBAMATE_3_NAME",			"君主佩德罗™卿享马黛"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_YERBAMATE_4_NAME",			"瓜拉尼亚®耶巴马黛茶葫芦"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_LEU_P0K_YERBAMATE_5_NAME",			"马拉多纳之心®耶巴马黛茶酒");

---- 删除临时表

DROP TABLE "C8SForLatinResources";