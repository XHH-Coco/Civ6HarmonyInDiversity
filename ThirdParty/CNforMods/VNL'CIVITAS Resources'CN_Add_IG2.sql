-- 由CLear8Sky对Mod Buddy内生成的SQL文件模板进行改动，以便于写入中文
-- VNL'CIVITAS Resources'CN_Add_IG2
-- Author: Clear8Sky , ChiYiuWong
-- DateCreated: 2021/5/28 3:07:52
--------------------------------------------------------------

-- 该文件对应补译/润色模组 “CIVITAS Resources” 中的 p0k_Resources_MODE_Localisation.sql 文件。该文件在 InGame 时载入，需 Criteria ： Mode_Monopolies_ON 与 Active_Mod_CR

---- 仿照原文件，建立临时表

CREATE TEMPORARY TABLE "C8SForp0kResources"
(
	"C8SForp0kResourceType" 			TEXT,
	"C8SForp0kResourceTypeShort" 		TEXT,
	"C8SForp0kResourceEffectDesc" 		TEXT,
	"C8SForp0kResourceName"				TEXT
);

---- 将对应数据填入表中

insert or ignore into C8SForp0kResources
		(C8SForp0kResourceType,			C8SForp0kResourceTypeShort,	C8SForp0kResourceEffectDesc,	C8SForp0kResourceName)
VALUES	
		("RESOURCE_P0K_PENGUINS",		"P0K_PENGUINS",				"SCIENCE_YIELD_BONUS",			"{LOC_RESOURCE_P0K_PENGUINS_NAME}"),
		("RESOURCE_CVS_POMEGRANATES",	"CVS_POMEGRANATES",			"FAITH_YIELD_BONUS",			"{LOC_RESOURCE_CVS_POMEGRANATES_NAME}"),
		("RESOURCE_P0K_PAPYRUS",		"P0K_PAPYRUS",				"SCIENCE_YIELD_BONUS",			"{LOC_RESOURCE_P0K_PAPYRUS_NAME}"),
		("RESOURCE_P0K_MAPLE",			"P0K_MAPLE",				"CITY_GROWTH_DISCOUNT",			"{LOC_RESOURCE_P0K_MAPLE_NAME}"),
		("RESOURCE_P0K_OPAL",			"P0K_OPAL",					"GOLD_YIELD_BONUS",				"{LOC_RESOURCE_P0K_OPAL_NAME}"),
		("RESOURCE_P0K_PLUMS",			"P0K_PLUMS",				"CULTURE_YIELD_BONUS",			"{LOC_RESOURCE_P0K_PLUMS_NAME}");

---- 产品
------ 名称

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||C8SForp0kResourceTypeShort||"_NAME",
		"[ICON_"||C8SForp0kResourceType||"] "||C8SForp0kResourceName||"公司：开发新产品"
FROM C8SForp0kResources;

------ 短名

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||C8SForp0kResourceTypeShort||"_SHORT_NAME",
		"[ICON_"||C8SForp0kResourceType||"] 开发新的"||C8SForp0kResourceName||"产品"
FROM C8SForp0kResources;

------ 描述

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||C8SForp0kResourceTypeShort||"_DESCRIPTION",
		"利用 [ICON_"||C8SForp0kResourceType||"] "||C8SForp0kResourceName||"资源为世界开发新产品。[NEWLINE]{LOC_INDUSTRY_"||C8SForp0kResourceEffectDesc||"_DESCRIPTION}"
FROM C8SForp0kResources;

------ 百科介绍

INSERT OR REPLACE INTO LocalizedText
		(Language,	Tag,	Text)
SELECT	"zh_Hans_CN",
		"LOC_PEDIA_CONCEPTS_"||C8SForp0kResourceTypeShort,
		"[NEWLINE][ICON_BULLET]{LOC_"||C8SForp0kResourceType||"_NAME}：{LOC_P0K_RESOURCE_"||C8SForp0kResourceEffectDesc||"_DESCRIPTION}"
FROM C8SForp0kResources;

------ 百科页面

UPDATE LocalizedText
SET Text = REPLACE(Text, "CIVITAS Resources:", "由“CIVITAS 资源扩充”模组所添加：")
WHERE Tag = "LOC_PEDIA_CONCEPTS_PAGE_MONOPOLIES_CHAPTER_INDUSTRIES_PARA_2" AND Language = "zh_Hans_CN";

------ 产品加成

INSERT OR REPLACE INTO LocalizedText
		(Language,		Tag,													Text)
VALUES		
		("zh_Hans_CN",	"LOC_P0K_RESOURCE_CITY_GROWTH_DISCOUNT_DESCRIPTION",	"所在城市 [ICON_Citizen] 人口增长速度+20%，+3 [ICON_Housing] 住房。"),
		("zh_Hans_CN",	"LOC_P0K_RESOURCE_MILITARY_UNIT_DISCOUNT_DESCRIPTION",	"所在城市训练战斗单位+30% [ICON_Production] 生产力。"),
		("zh_Hans_CN",	"LOC_P0K_RESOURCE_CIVILIAN_UNIT_DISCOUNT_DESCRIPTION",	"所在城市训练平民单位+30% [ICON_Production] 生产力。"),
		("zh_Hans_CN",	"LOC_P0K_RESOURCE_BUILDING_DISCOUNT_DESCRIPTION",		"所在城市建造建筑+30% [ICON_Production] 生产力。"),
		("zh_Hans_CN",	"LOC_P0K_RESOURCE_GOLD_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Gold] 金币产出+25%。"),
		("zh_Hans_CN",	"LOC_P0K_RESOURCE_FAITH_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Faith] 信仰值产出+25%。"),
		("zh_Hans_CN",	"LOC_P0K_RESOURCE_SCIENCE_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Science] 科技值产出+15%。"),
		("zh_Hans_CN",	"LOC_P0K_RESOURCE_CULTURE_YIELD_BONUS_DESCRIPTION",		"所在城市 [ICON_Culture] 文化值产出+20%。"),

------ 产品名称

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_1_NAME",			"“插翅难飞”鸟类图集"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_2_NAME",			"企鹅拼装毛绒玩具"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_3_NAME",			"韦伯斯®企鹅儿童读物"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_4_NAME",			"企鹅群系习性研究手册"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_5_NAME",			"Q弹企鹅软糖"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_1_NAME",		"鲜榨石榴果汁"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_2_NAME",		"巧克力绒球"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_3_NAME",		"寒冬补品"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_4_NAME",		"果树栽培论"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_5_NAME",		"纯天然红色素"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_1_NAME",				"古埃及卷轴"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_2_NAME",				"历史博物馆卷轴纪念品"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_3_NAME",				"图特摩斯的纸莎草情书"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_4_NAME",				"象形文字初学者指南"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_5_NAME",				"纸莎草盆栽"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_MAPLE_1_NAME",				"加拿大原产枫糖浆"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_MAPLE_2_NAME",				"超级枫脆"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_MAPLE_3_NAME",				"红枫种子"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_MAPLE_4_NAME",				"秋月枫画"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_MAPLE_5_NAME",				"枫木妆柜"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_OPAL_1_NAME",				"欧泊婚戒"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_OPAL_2_NAME",				"欧泊项链"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_OPAL_3_NAME",				"欧泊耳环"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_OPAL_4_NAME",				"人造欧泊异石戒指"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_OPAL_5_NAME",				"欧泊黑晶簇"),

		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PLUMS_1_NAME",				"李子酒奇亚籽套餐"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PLUMS_2_NAME",				"李子树观景盆栽"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PLUMS_3_NAME",				"李子坚种弹弓套装"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PLUMS_4_NAME",				"干李子"),
		("zh_Hans_CN",	"LOC_GREATWORK_PRODUCT_P0K_PLUMS_5_NAME",				"告别累瘫：睡眠习惯改善建议");

---- 删除临时表

DROP TABLE "C8SForp0kResources";
