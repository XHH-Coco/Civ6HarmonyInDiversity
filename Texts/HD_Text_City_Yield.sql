--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                 Text)
values
    ("LOC_CITY_YIELD_FROM_GAMEEFFECTS_TOOLTIP",           "{1_Value : number +#.#;-#.#} from Modifiers"),
    ("LOC_CITY_YIELD_FROM_REGIONAL_BUILDINGS_TOOLTIP",    "{1_Value : number +#.#;-#.#} from Regional Buildings");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                                Text)
values
    ("zh_Hans_CN",  "LOC_CITY_YIELD_FROM_GAMEEFFECTS_TOOLTIP",          "{1_Value : number +#.#;-#.#}来自修正值"),
    ("zh_Hans_CN",  "LOC_CITY_YIELD_FROM_REGIONAL_BUILDINGS_TOOLTIP",   "{1_Value : number +#.#;-#.#}来自建筑辐射"),
    ("zh_Hans_CN",  "LOC_SUK_DISTRICT_POPULATION_TOOLTIP",              "目前最多可以建造{1}个专业化区域。[NEWLINE]当城市达到{2} [ICON_Citizen] 人口时，可以再额外建造一个专业化区域。"),
    ("zh_Hans_CN",  "LOC_SUK_CITY_YIELD_FROM_POPULATION_TOOLTIP",       "{1} 来自人口消耗"),
    ("zh_Hans_CN",  "LOC_SUK_CITY_YIELD_FROM_HAPPINESS_TOOLTIP",        "{1}% ({2}) 来自余粮和宜居度"),
    ("zh_Hans_CN",  "LOC_SUK_CITY_YIELD_FROM_HOUSING_TOOLTIP",          "{1}% ({2}) 来自住房"),
    ("zh_Hans_CN",  "LOC_SUK_CITY_YIELD_FROM_OCCUPATION_TOOLTIP",       "{1}% ({2}) 来自占领");

