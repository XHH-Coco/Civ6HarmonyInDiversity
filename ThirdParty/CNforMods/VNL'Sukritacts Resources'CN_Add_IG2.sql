-- 由CLear8Sky对Mod Buddy内生成的SQL文件模板进行改动，以便于写入中文
-- VNL"Sukritacts Resources"CN_Add_IG2
-- Author: Clear8Sky
-- DateCreated: 2021/5/29 17:16:17
--------------------------------------------------------------

-- 该文件对应补译/润色模组 “Sukritact's Resources” 中的 Suk_AltEcon_Localisation.sql 文件。该文件在 InGame 时载入，需 Criteria ： Mode_Monopolies_ON 与 Active_Mod_SUKR
-- 全用双引号是因为68行出现了单引号——“Sukritact's”

---- 仿照原文件，建立临时表

CREATE TEMPORARY TABLE "C8SForSukResourcess"
(
	"C8SForSukResourcesType" 			TEXT,
	"C8SForSukResourcesTypeShort" 		TEXT,
	"C8SForSukResourcesEffectDesc" 		TEXT
);

---- 将对应数据填入表中

insert or ignore into C8SForSukResourcess
		(C8SForSukResourcesType,	C8SForSukResourcesTypeShort,	C8SForSukResourcesEffectDesc)
VALUES	
		("RESOURCE_SUK_CHEESE",		"SUK_CHEESE",					"CULTURE_YIELD_BONUS"),
		("RESOURCE_SUK_OBSIDIAN",	"SUK_OBSIDIAN",					"MILITARY_UNIT_DISCOUNT"),
		("RESOURCE_SUK_SHARK",		"SUK_SHARK",					"CIVILIAN_UNIT_DISCOUNT"),
		("RESOURCE_GOLD",			"GOLD",							"GOLD_YIELD_BONUS");

---- 产品
------ 名称

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||C8SForSukResourcesTypeShort||"_NAME",
		"[ICON_"||C8SForSukResourcesType||"] {LOC_"||C8SForSukResourcesType||"_NAME}公司：开发新产品"
FROM C8SForSukResourcess;

------ 短名

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||C8SForSukResourcesTypeShort||"_SHORT_NAME",
		"[ICON_"||C8SForSukResourcesType||"] 开发新的{LOC_"||C8SForSukResourcesType||"_NAME}产品"
FROM C8SForSukResourcess;

------ 描述

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||C8SForSukResourcesTypeShort||"_DESCRIPTION",
		"利用 [ICON_"||C8SForSukResourcesType||"] {LOC_"||C8SForSukResourcesType||"_NAME}资源为世界开发新产品。[NEWLINE]{LOC_INDUSTRY_"||C8SForSukResourcesEffectDesc||"_DESCRIPTION}"
FROM C8SForSukResourcess;

------ 百科介绍

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PEDIA_CONCEPTS_"||C8SForSukResourcesTypeShort,
		"[NEWLINE][ICON_BULLET]{LOC_"||C8SForSukResourcesType||"_NAME}：{LOC_SUK_RESOURCE_"||C8SForSukResourcesEffectDesc||"_DESCRIPTION}"
FROM C8SForSukResourcess;

------ 百科页面

UPDATE LocalizedText
SET Text = REPLACE(Text, "Sukritact's Resources:", "由“Sukritact 资源扩充”模组所添加：")
WHERE Tag = "LOC_PEDIA_CONCEPTS_PAGE_MONOPOLIES_CHAPTER_INDUSTRIES_PARA_2" AND Language = "zh_Hans_CN";

------ 产品加成

INSERT OR REPLACE INTO LocalizedText
		(Language,		Tag,													Text)
VALUES		
		("zh_Hans_CN",	"LOC_SUK_RESOURCE_CITY_GROWTH_DISCOUNT_DESCRIPTION",	"所在城市 [ICON_Citizen] 人口增长速度+20%，+3 [ICON_Housing] 住房。"),
		("zh_Hans_CN",	"LOC_SUK_RESOURCE_MILITARY_UNIT_DISCOUNT_DESCRIPTION",	"所在城市训练战斗单位+30% [ICON_Production] 生产力。"),
		("zh_Hans_CN",	"LOC_SUK_RESOURCE_CIVILIAN_UNIT_DISCOUNT_DESCRIPTION",	"所在城市训练平民单位+30% [ICON_Production] 生产力。"),
		("zh_Hans_CN",	"LOC_SUK_RESOURCE_BUILDING_DISCOUNT_DESCRIPTION",		"所在城市建造建筑+30% [ICON_Production] 生产力。"),
		("zh_Hans_CN",	"LOC_SUK_RESOURCE_GOLD_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Gold] 金币产出+25%。"),
		("zh_Hans_CN",	"LOC_SUK_RESOURCE_FAITH_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Faith] 信仰值产出+25%。"),
		("zh_Hans_CN",	"LOC_SUK_RESOURCE_SCIENCE_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Science] 科技值产出+15%。"),
		("zh_Hans_CN",	"LOC_SUK_RESOURCE_CULTURE_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Culture] 文化值产出+20%。"),

------ 产品名称

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_CHEESE_1_NAME",				"美味！™豪达奶酪"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_CHEESE_2_NAME",				"提加卜®阿伊贝起司开胃乳品"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_CHEESE_3_NAME",				"切塔尔©精美芝士"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_CHEESE_4_NAME",				"夏羊™幸福奶酪"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_CHEESE_5_NAME",				"阿瑞斯泰俄斯™菲达干酪乳品"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_OBSIDIAN_1_NAME",			"戴塞克©外科手术刀"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_OBSIDIAN_2_NAME",			"莫图伊卡®黑曜石配件"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_OBSIDIAN_3_NAME",			"特兹卡特利波伽™珠宝"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_OBSIDIAN_4_NAME",			"伊珂邱安©优质刃片"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_OBSIDIAN_5_NAME",			"琉璃山™黑曜石"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_GOLD_1_NAME",					"萨尼努莫™臻品"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_GOLD_2_NAME",					"涅璞®奢华饰品"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_GOLD_3_NAME",					"琉齿金牙"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_GOLD_4_NAME",					"金尹®微处理器"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_GOLD_5_NAME",					"西柚公司©电子元件"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_SHARK_1_NAME",				"宾威™鲨翅"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_SHARK_3_NAME",				"鲛川滨田®鲨鲜"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_SHARK_3_NAME",				"维京海盗™鲨鱼肉"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_SHARK_4_NAME",				"克里基™鲨鱼探险之旅"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_SUK_SHARK_5_NAME",				"卡拉莫阿里®与鲨邂逅");

---- 删除临时表

DROP TABLE "C8SForSukResourcess";