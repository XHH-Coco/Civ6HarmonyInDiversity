-- Monopoly
--========================================================================================================================
-- Automated Stuff
-- Some of this can be automated...
-- Your really just need to populate this table below
-- and provide 5 resource names. Everything else will be done for you!
--========================================================================================================================
    -- PRODUCT
    --------------------------------------------------------------------
        -- Name
        -------------------------------------
            INSERT OR REPLACE INTO LocalizedText
                    (
                        Tag,
                        Language,
                        Text
                    )
            SELECT
                "LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||ResourceTypeShort||"_NAME",
                "zh_Hans_CN",                
                "[ICON_"||ResourceType||"] {LOC_"||ResourceType||"_NAME}公司：开发新产品"
            FROM Suk_Resources;
        -------------------------------------
        -- Short Name
        -------------------------------------
            INSERT OR REPLACE INTO LocalizedText
                    (
                        Tag,
                        Language,
                        Text
                    )
            SELECT
                "LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||ResourceTypeShort||"_SHORT_NAME",
                "zh_Hans_CN",                
                "[ICON_"||ResourceType||"] 开发新的{LOC_"||ResourceType||"_NAME}产品"
            FROM Suk_Resources;
        -------------------------------------
        -- Description
        -------------------------------------
            INSERT OR REPLACE INTO LocalizedText
                    (
                        Tag,
                        Language,
                        Text
                    )
            SELECT
                "LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||ResourceTypeShort||"_DESCRIPTION",
                "zh_Hans_CN",                
                "利用 [ICON_"||ResourceType||"] {LOC_"||ResourceType||"_NAME}资源为世界开发新产品。{LOC_INDUSTRY_"||BonusType||"_DESCRIPTION}"
            FROM Suk_Resources;
        -------------------------------------
        -- Pedia Blurb
        -------------------------------------
            -- INSERT OR REPLACE INTO LocalizedText
            --         (
            --             Tag,
            --             Language,
            --             Text
            --         )
            -- SELECT
            --     "LOC_PEDIA_CONCEPTS_"||ResourceTypeShort,
            --     "zh_Hans_CN",                
            --     "[NEWLINE][ICON_BULLET] {LOC_"||ResourceType||"_NAME}: {LOC_SUK_RESOURCE_"||BonusType||"_DESCRIPTION}"
            -- FROM Suk_Resources;
--========================================================================================================================
-- Civilopedia Entry
--========================================================================================================================
UPDATE LocalizedText
    SET Text = Text || "[NEWLINE][NEWLINE]Sukritact的海洋模式:"||(SELECT GROUP_CONCAT("{LOC_PEDIA_CONCEPTS_"||ResourceTypeShort||"}","") FROM Suk_Resources)
    WHERE Tag = "LOC_PEDIA_CONCEPTS_PAGE_MONOPOLIES_CHAPTER_INDUSTRIES_PARA_2" and Language = "zh_Hans_CN";
--========================================================================================================================
-- Product Effects
--========================================================================================================================
INSERT OR REPLACE INTO LocalizedText
        (Tag,                               Language,       Text)
VALUES
        (
            "LOC_SUK_RESOURCE_CITY_GROWTH_DISCOUNT_DESCRIPTION",
            "zh_Hans_CN",
            "所处城市发展速度+20%、+3 [ICON_Housing] 住房。"
        ),
        (
            "LOC_SUK_RESOURCE_MILITARY_UNIT_DISCOUNT_DESCRIPTION",
            "zh_Hans_CN",
            "在所处城市生产军事单位时+30% [ICON_Production] 生产力。"
        ),
        (
            "LOC_SUK_RESOURCE_CIVILIAN_UNIT_DISCOUNT_DESCRIPTION",
            "zh_Hans_CN",
            "在所处城市生产平民单位时+30% [ICON_Production] 生产力。"
        ),
        (
            "LOC_SUK_RESOURCE_BUILDING_DISCOUNT_DESCRIPTION",
            "zh_Hans_CN",
            "在所处城市建造建筑时+30% [ICON_Production] 生产力。"
        ),
        (
            "LOC_SUK_RESOURCE_GOLD_YIELD_BONUS_DESCRIPTION",
            "zh_Hans_CN",
            "所处城市的 [ICON_Gold] 金币产量+25%。"
        ),
        (
            "LOC_SUK_RESOURCE_FAITH_YIELD_BONUS_DESCRIPTION",
            "zh_Hans_CN",
            "所处城市的 [ICON_Faith] 信仰值产量+25%。"
        ),
        (
            "LOC_SUK_RESOURCE_SCIENCE_YIELD_BONUS_DESCRIPTION",
            "zh_Hans_CN",
            "所处城市的 [ICON_Science] 科技值产量+15%。"
        ),
        (
            "LOC_SUK_RESOURCE_CULTURE_YIELD_BONUS_DESCRIPTION",
            "zh_Hans_CN",
            "所处城市的 [ICON_Culture] 文化值产量+20%。"
        );
--========================================================================================================================
-- Product Names
--========================================================================================================================
INSERT OR REPLACE INTO LocalizedText
        (Tag,                               Language,       Text)
VALUES
    --------------------------------------------------------------------
    -- Coral
    --------------------------------------------------------------------
        (
            "LOC_GREATWORK_PRODUCT_SUK_CORAL_1_NAME",
            "zh_Hans_CN",
            "斯瓦西里珊瑚建筑混凝土"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_CORAL_2_NAME",
            "zh_Hans_CN",
            "希腊珊瑚宝塔"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_CORAL_3_NAME",
            "zh_Hans_CN",
            "真红珊瑚盆景"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_CORAL_4_NAME",
            "zh_Hans_CN",
            "几内亚湾珊瑚宝珠"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_CORAL_5_NAME",
            "zh_Hans_CN",
            "哈罗娜的珠串和首饰"
        ),
    --------------------------------------------------------------------
    -- Lobster
    --------------------------------------------------------------------
        (
            "LOC_GREATWORK_PRODUCT_SUK_LOBSTER_1_NAME",
            "zh_Hans_CN",
            "真红龙虾"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_LOBSTER_2_NAME",
            "zh_Hans_CN",
            "利奥波德的热月龙虾"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_LOBSTER_3_NAME",
            "zh_Hans_CN",
            "鲁迪的大虾"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_LOBSTER_4_NAME",
            "zh_Hans_CN",
            "莱格万螳螂虾"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_LOBSTER_5_NAME",
            "zh_Hans_CN",
            "卡伊的小龙虾"
        ),
    --------------------------------------------------------------------
	-- Stringrays
	--------------------------------------------------------------------
		(
			"LOC_GREATWORK_PRODUCT_SUK_RAYS_1_NAME",
            "zh_Hans_CN",
			"巨型黄貂鱼"
		),
		(
			"LOC_GREATWORK_PRODUCT_SUK_RAYS_2_NAME",
            "zh_Hans_CN",
			"辛辣味赤魟"
		),
		(
			"LOC_GREATWORK_PRODUCT_SUK_RAYS_3_NAME",
            "zh_Hans_CN",
			"赤魟尾毒液"
		),
		(
			"LOC_GREATWORK_PRODUCT_SUK_RAYS_4_NAME",
            "zh_Hans_CN",
			"皇家菜：大扒鱼皮"
		),
		(
			"LOC_GREATWORK_PRODUCT_SUK_RAYS_5_NAME",
            "zh_Hans_CN",
			"Q弹美容花胶"
		),
	--------------------------------------------------------------------
	-- Abalone
	--------------------------------------------------------------------
		(
			"LOC_GREATWORK_PRODUCT_SUK_ABALONE_1_NAME",
            "zh_Hans_CN",
			"蒜香粉丝鲍鱼"
		),
		(
			"LOC_GREATWORK_PRODUCT_SUK_ABALONE_2_NAME",
            "zh_Hans_CN",
			"泰式冰镇鲍鱼"
		),
		(
			"LOC_GREATWORK_PRODUCT_SUK_ABALONE_3_NAME",
            "zh_Hans_CN",
			"日式矶煮鲍鱼"
		),
		(
			"LOC_GREATWORK_PRODUCT_SUK_ABALONE_4_NAME",
            "zh_Hans_CN",
			"茄香鲜鲍"
		),
		(
			"LOC_GREATWORK_PRODUCT_SUK_ABALONE_5_NAME",
            "zh_Hans_CN",
			"松茸鲍鱼花胶鸡汤"
		),
    --------------------------------------------------------------------
    -- Caviar
    --------------------------------------------------------------------
        (
            "LOC_GREATWORK_PRODUCT_SUK_CAVIAR_1_NAME",
            "zh_Hans_CN",
            "佐伊德伯格黄鱼子酱"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_CAVIAR_2_NAME",
            "zh_Hans_CN",
            "克罗列夫斯基蓝鱼子酱"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_CAVIAR_3_NAME",
            "zh_Hans_CN",
            "江户鲑鱼子酱"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_CAVIAR_4_NAME",
            "zh_Hans_CN",
            "伊朗里海鱼子酱"
        ),
        (
            "LOC_GREATWORK_PRODUCT_SUK_CAVIAR_5_NAME",
            "zh_Hans_CN",
            "瑞典三明治鱼子酱"
        );
