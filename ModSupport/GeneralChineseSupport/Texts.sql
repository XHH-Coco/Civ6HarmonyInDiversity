--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                    Text)
values
    -- Notification Log
    ("zh_Hans_CN",  "LOC_FF16_NOTIFICATION_LOG_TITLE",      "消息记录"),
    ("zh_Hans_CN",  "LOC_FF16_LOGSIZE_OPTION",              "面板尺寸:"),
    ("zh_Hans_CN",  "LOC_FF16_MAXLOGSIZE_OPTION",           "最多条数:"),
    ("zh_Hans_CN",  "LOC_FF16_LOGSIZE_AUTO",                "自动"),
    ("zh_Hans_CN",  "LOC_FF16_CLEARLOG_OPTION",             "过回合清空消息记录"),
    ("zh_Hans_CN",  "LOC_FF16_LOG_OPTIONS_TITLE",           "消息记录偏好设置"),
    ("zh_Hans_CN",  "LOC_FF16_NOTIFICATION_LOG_TOOLTIP",    "偏好设置"),
    ("zh_Hans_CN",  "LOC_FF16_LOG_ENTRY_SINGLE",            "有新的小道消息，右键清空记录。"),
    ("zh_Hans_CN",  "LOC_FF16_LOG_ENTRY_MULTIPLE",          "有新的小道消息，右键清空记录。"),
    -- Configure Minimal City Distance
    ("zh_Hans_CN",  "LOC_CMCD_NAME",                        "最小城市间距"),
    ("zh_Hans_CN",  "LOC_CMCD_DESCRIPTION",                 "建立城市时的最近距离限制"),
    ("zh_Hans_CN",  "LOC_CMCD_HEADER_NAME",                 "[COLOR_Production]设置最小城市间距[ENDCOLOR]"),
    ("zh_Hans_CN",  "LOC_CMCD_HEADER_DESCRIPTION",          "由DahakaMVl制作的 设置最小城市间距"),
    ("zh_Hans_CN",  "LOC_CMCD_FOOTER_NAME",                 "[COLOR_Production]设置最小城市间距 结束[ENDCOLOR]"),
    ("zh_Hans_CN",  "LOC_CMCD_FOOTER_DESCRIPTION",          "用于填充的假选项"),
    -- [MOD] Gift it to me
    ("zh_Hans_CN",  "LOC_GIFTITTOME_GIFT_THIS_UNIT",            "赠送单位（给当前位置领土的所有者）"),
    ("zh_Hans_CN",  "LOC_GIFTITTOME_GIFT_THIS_UNIT_DISABLED",   "赠送单位[NEWLINE] - 需要在其他玩家的领土内[NEWLINE] - 宗教单位、开拓者和考古学家无法赠送给城邦[NEWLINE] - 征兵不能赠送[NEWLINE] - 匈牙利需要将单位与金币一起赠送给宗主的城邦[NEWLINE] - 不能赠送给与你处于战争状态的玩家[NEWLINE] - 已达到每回合赠送单位的上限：{1_MaxGifts}次[NEWLINE] - 单位血量必须超过90％"),
    ("zh_Hans_CN",  "LOC_HUD_UNIT_PANEL_ARE_YOU_SURE_GIFT",     "您确定要向其他玩家赠送（{2_GiftCount} / {3_MaxGiftCount}）你的{1_UnitName}吗？"),
    ("zh_Hans_CN",  "LOC_HUD_UNIT_PANEL_ARE_YOU_SURE_GIFT_PAY", "您确定要向城邦赠送（{3_GiftCount} / {4_MaxGiftCount}）您的{1_UnitName}和{2_Gold}金币吗？[NEWLINE]（匈牙利需要将黄金与单位一起赠送给宗主的城邦）"),
    ("zh_Hans_CN",  "LOC_GIFTITTOME_WARNING_HEADLINE",          "来自{1_LeaderName}的警告"),
    ("zh_Hans_CN",  "LOC_GIFTITTOME_WARNING_CONTENT",           "向我们的敌人赠送单位可能会导致外交行动。[NEWLINE]我们已经警告你了"),
    ("zh_Hans_CN",  "LOC_GIFTITTOME_INFO_HEADLINE",             "{1_LeaderName}给了你一个单位！"),
    ("zh_Hans_CN",  "LOC_GIFTITTOME_INFO_CONTENT",              "您收到了{1_UnitName}！"),
    -- RadialMeasuringTool
    ("zh_Hans_CN",  "LOC_RMT_WND_TITLE",                    "半径测量工具"),
    ("zh_Hans_CN",  "LOC_RMT_LBL1",                         "点击地图上的位置来可视化半径内的地格"),
    ("zh_Hans_CN",  "LOC_RMT_RAD_LBL",                      "半径:"),
    ("zh_Hans_CN",  "LOC_RMT_ALT_RAD_PREFIX",               "在"),
    ("zh_Hans_CN",  "LOC_RMT_ALT_RAD_SUFIX",                "格内"),
    ("zh_Hans_CN",  "LOC_RMT_ALT_RAD_CB_TT",                "选中后采用在x格内的计数方式"),
    ("zh_Hans_CN",  "LOC_RMT_CB_MULTI",                     "多重半径高亮"),
    ("zh_Hans_CN",  "LOC_RMT_CB_CITY_ONLY",                 "只高亮市中心"),
    ("zh_Hans_CN",  "LOC_RMT_CB_BONUS_RES",                 "忽略加成资源"),
    ("zh_Hans_CN",  "LOC_RMT_MAX_CITY_RAD",                 "- 市民可工作范围"),
    ("zh_Hans_CN",  "LOC_RMT_KEY_CITY_CEN",                 "市中心"),
    ("zh_Hans_CN",  "LOC_RMT_KEY_RES",                      "资源"),
    ("zh_Hans_CN",  "LOC_RMT_CB_TRANSP",                    "使用透明的窗口背景"),
    ("zh_Hans_CN",  "LOC_RMT_CB_WND_POS",                   "窗口位置");

-- Greatest cities
--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                                         Text)
values
    ("zh_Hans_CN",  "LOC_AKGC_CITIES_BUTTON",                                    "最伟大的城市"),
    ("zh_Hans_CN",  "LOC_AKGC_CITIES_TITLE",                                     "世界上最伟大的城市"),
    ("zh_Hans_CN",  "LOC_AKGC_CITIES_TITLE_HISTORIC",                            "由{1_author}统计的在{2_era}最伟大的城市"),
    ("zh_Hans_CN",  "LOC_AKGC_CITIES_TAB_WORLD",                                 "世界"),
    ("zh_Hans_CN",  "LOC_AKGC_CITIES_TAB_EMPIRE",                                "帝国"),
    ("zh_Hans_CN",  "LOC_AKGC_CITIES_TAB_WONDERS",                               "奇观"),
    ("zh_Hans_CN",  "LOC_AKGC_UNDISCOVERED_CITY",                                "未发现的城市"),
    ("zh_Hans_CN",  "LOC_AKGC_AWARD_HIGHEST_GoldPT",                             "最富有的城市 (每回合{1} [ICON_GOLD])"),
    ("zh_Hans_CN",  "LOC_AKGC_AWARD_HIGHEST_FaithPT",                            "最虔诚的城市 (每回合{1} [ICON_FAITH])"),
    ("zh_Hans_CN",  "LOC_AKGC_AWARD_HIGHEST_CulturePT",                          "最有文化的城市 (每回合{1} [ICON_CULTURE])"),
    ("zh_Hans_CN",  "LOC_AKGC_AWARD_HIGHEST_SciencePT",                          "受教育程度最高的城市 (每回合{1} [ICON_SCIENCE])"),
    ("zh_Hans_CN",  "LOC_AKGC_AWARD_HIGHEST_ProductionPT",                       "最工业化的城市 (每回合{1} [ICON_PRODUCTION])"),
    ("zh_Hans_CN",  "LOC_AKGC_AWARD_HIGHEST_Population",                         "最大的城市 ({1} [ICON_CITIZEN])"),
    ("zh_Hans_CN",  "LOC_AKGC_AWARD_HIGHEST_Defense",                            "最坚固的城市 ({1} [ICON_STRENGTH])"),
    ("zh_Hans_CN",  "LOC_AKGC_AWARD_HIGHEST_Happiness",                          "最幸福的城市 (+{1} [ICON_AMENITIES])"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMPOPULATION",                             "{1_score} 来自人口"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMWONDERS",                                "{1_score} 来自奇观"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMLAND",                                   "{1_score} 来自土地"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMAMENITIES",                              "{1_score} 来自宜居度"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMDISTRICTSANDBUILDINGS",                  "{1_score} 来自开发程度"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMDAMAGE",                                 "{1_score} 来自受损设施"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMTOPGPT",                                 "{1_score} 来自拥有最高的回合 [ICON_GOLD]"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMTOPFPT",                                 "{1_score} 来自拥有最高的回合 [ICON_FAITH]"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMTOPCPT",                                 "{1_score} 来自拥有最高的回合 [ICON_CULTURE]"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMTOPSPT",                                 "{1_score} 来自拥有最高的回合 [ICON_SCIENCE]"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMTOPPPT",                                 "{1_score} 来自拥有最高的回合 [ICON_PRODUCTION]"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_FROMHOLYCITY",                               "{1_relscore} 作为 {2_rel} 的圣城"),
    ("zh_Hans_CN",  "LOC_AKGC_SCORE_TOTAL",                                      "总计{1_score}分"),
    ("zh_Hans_CN",  "LOC_AKGC_CITYFOUNDEDUNKNOWN",                               "{1_civ}{2_occupied}"),
    ("zh_Hans_CN",  "LOC_AKGC_CITYFOUNDED",                                      "{1_civ}{2_occupied} 建立于{3_year}"),
    ("zh_Hans_CN",  "LOC_AKGC_CITYFOUNDEDBYSOMEONEELSE",                         "{1_civ}{2_occupied} 由 {4_origciv} 建立于{3_year}"),
    ("zh_Hans_CN",  "LOC_AKGC_CITYOCCUPIED",                                     " (已占领)"),
    ("zh_Hans_CN",  "LOC_AKGC_CITYRAZED",                                        " 已被夷平"),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_FOUNDED",                             "{1_year}: 由 {3_civ} 建立的 {2_city}"),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_CAPTURED",                            "{1_year}: 被 {2_civ} 征服"),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_RAZED",                               "{1_year}: 被 {2_civ} 夷平"),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_OCCUPIED",                            "{1_year}: 被 {2_civ} 占领"),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_LIBERATED",                           "{1_year}: 被 {2_civ} 解放"),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_TRADED",                              "{1_year}: 被交易给 {2_civ} "),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_DEFECTED",                            "{1_year}: 向 {2_civ} 叛变"),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_RENAMED",                             "{1_year}: 重命名为 {2_name} "),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_FOUNDEDONRUINS",                      "{1_year}: {3_civ}在{4_oldcity}的废墟上重建了{2_city}"),
    ("zh_Hans_CN",  "LOC_AKGC_CITY_HISTORY_UNKNOWN",                             "{1_year}: 未知事件{2_name}"),
    ("zh_Hans_CN",  "LOC_AKGC_ERADROPDOWN_CURRENTERA",                           "当前 {1_year}"),
    ("zh_Hans_CN",  "LOC_AKGC_ENDOFERARANK_NOTIFICATION_HEADER",                 "{1_era} 最伟大的城市"),
    ("zh_Hans_CN",  "LOC_AKGC_ENDOFERARANK_NOTIFICATION_TEXT",                   "{1_person} 完成了一个关于全世界城市的调查，并宣称 {2_civ} {3_city} 是 {4_era} 最伟大的城市。"),
    ("zh_Hans_CN",  "LOC_AKGC_ENDOFERARANK_UNKNOWNWINNER_NOTIFICATION_TEXT",     "{1_person} 完成了一个关于全世界城市的调查，并宣称我们的城市 {2_city} 是 {4_era} 第{3_rank}伟大的城市。"),
    ("zh_Hans_CN",  "LOC_AKGC_UNKNOWN_AUTHOR",                                   "一位无名学者"),
    ("zh_Hans_CN",  "LOC_AKGC_DEFAULTOPTIONS_NOTIFICATION_HEADER",               "最伟大的城市：选项设置提示"),
    ("zh_Hans_CN",  "LOC_AKGC_DEFAULTOPTIONS_NOTIFICATION_TEXT_ON",              "[NEWLINE]你可以点击此处访问选项界面，或点击“最伟大的城市”窗口左上角的齿轮图标。[NEWLINE][NEWLINE]已检测到伟大城市的奖励：[COLOR_GREEN]已启用[ENDCOLOR]时代结束时的奖励。[NEWLINE]"),
    ("zh_Hans_CN",  "LOC_AKGC_DEFAULTOPTIONS_NOTIFICATION_TEXT_OFF",             "[NEWLINE]你可以点击此处访问选项界面，或点击“最伟大的城市”窗口左上角的齿轮图标。[NEWLINE][NEWLINE]未检测到伟大城市的奖励：[COLOR_RED]未启用[ENDCOLOR]时代结束时的奖励。[NEWLINE]"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_GENERAL",                                      "通用设置"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_NumWorldCitiesToShow",                         "显示世界城市的数量"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_NumOwnCitiesToShow",                           "显示帝国内城市的数量"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_IncludeMinors",                                "包含城邦"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowWondersForDiscoveredCities",               "显示奇观"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowBestOfBonusesForDiscoveredCities",         "显示世界之最"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowScoreBreakdownForDiscoveredCities",        "显示分数明细"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowCityDetailsForDiscoveredCities",           "显示城市细节"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowWondersForUndiscoveredCities",             "显示奇观"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowBestOfBonusesForUndiscoveredCities",       "显示世界之最"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowScoreBreakdownForUndiscoveredCities",      "显示分数明细"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowCityDetailsForUndiscoveredCities",         "显示城市细节"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowCapitalForUndiscoveredCities",             "显示首都"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowHolyCityForUndiscoveredCities",            "显示圣城"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowCityNamesForUndiscoveredCities",           "显示名字"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowOwnerForUnmetCivs",                        "显示所有者"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_DebugMode",                                    "开启调试模式"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_GrantEndofEraAwards",                          "在每个时代结束时奖励最顶尖的城市"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ForDiscoveredCities",                          "已发现的城市"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ForUndiscoverCities",                          "未发现的城市"),
    ("zh_Hans_CN",  "LOC_AKGC_COL_RANK",                                         "排名"),
    ("zh_Hans_CN",  "LOC_AKGC_COL_CITY",                                         "城市"),
    ("zh_Hans_CN",  "LOC_AKGC_COL_POPULATION",                                   "人口"),
    ("zh_Hans_CN",  "LOC_AKGC_COL_SPECIAL",                                      "特殊"),
    ("zh_Hans_CN",  "LOC_AKGC_COL_WONDERS",                                      "奇观"),
    ("zh_Hans_CN",  "LOC_AKGC_BUTTON_OPTIONS_TT",                                "选项"),
    ("zh_Hans_CN",  "LOC_AKGC_BUTTON_SETTINGSRESET",                             "重置"),
    ("zh_Hans_CN",  "LOC_AKGC_BUTTON_SETTINGSSAVE",                              "保存"),
    ("zh_Hans_CN",  "LOC_AKGC_BUTTON_SETTINGSCANCEL",                            "取消"),
    -- newly added
    ("zh_Hans_CN",  "LOC_AKGC_OPT_WonderList",                                   "世界奇观列表"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowLineNumbersOnCityLists",                   "在城市列表中显示行号"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowRevealedUnderConstructionWonders",         "显示视野范围内建造中的奇观"),
    ("zh_Hans_CN",  "LOC_AKGC_OPT_ShowUnRevealedUnderConstructionWonders",       "显示不可见范围内建造中的奇观"),
    ("zh_Hans_CN",  "LOC_AKGC_COL_WONDER",                                       "名称"),
    ("zh_Hans_CN",  "LOC_AKGC_COL_OWNER",                                        "所有者"),
    ("zh_Hans_CN",  "LOC_AKGC_COL_DATEBUILT",                                    "建成时间"),
    ("zh_Hans_CN",  "LOC_AKGC_COL_LOCATION",                                     "位置");

-- Endgame Map Replay
--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                         Text)
values
    ("zh_Hans_CN",  "LOC_AKMH_LAUNCHBUTTON_TT",                  "地图史[NEWLINE][NEWLINE]查看您文明地图变化的历史。"),
    ("zh_Hans_CN",  "LOC_AKMH_LAUNCHBUTTON_ALERT_SINGLE_TT",     ""),
    ("zh_Hans_CN",  "LOC_AKMH_MAIN_TITLE",                       "地图史"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_OPTIONS_TT",                "选项"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_HEADER",                       "选项"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_GENERAL_HEADER",               "一般设置"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_SETTINGSCANCEL",            "取消"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_SETTINGSRESET",             "重置"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_SETTINGSSAVE",              "保存"),
    ("zh_Hans_CN",  "LOC_AKMH_ENDGAME_TITLE",                    "世界"),
    ("zh_Hans_CN",  "LOC_AKMH_THE_KNOWN_WORLD",                  "已知的世界"),
    ("zh_Hans_CN",  "LOC_AKMH_THE_DAWN_OF_TIME",                 "伊始之时"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_Overlays",                     "滤镜"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_ShowOwnerOverlayRB",           "文明"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_ShowReligionOverlayRB",        "宗教"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_layers",                       "显示内容"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_ShowCities",                   "市中心"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_ShowDevelopment",              "发展状况"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_ShowResources",                "资源"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_ShowFeatures",                 "地貌"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_Pings",                        "事件提示"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_PingCityFounded",              "建立城市"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_PingCityCaptured",             "占领城市"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_PingCityRazed",                "夷平城市"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_PingWonderBuilt",              "建成奇观"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_PingSound",                    "提示音"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_General",                      "一般设置"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_DynamicCentring",              "动态居中"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_DynamicSizing",                "动态大小"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_ShowUnRevealed",               "未探索的疆域"),
    ("zh_Hans_CN",  "LOC_AKMH_OPT_ShowInvisibleResources",       "未揭示的资源"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_TOGGLEWINDOWED_TT",         "窗口化显示"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_TOGGLEFULLSCREEN_TT",       "全屏显示"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_PLAY_TT",                   "播放[NEWLINE]右键点击以倒放"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_STOP_TT",                   "暂停"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_SKIPTOSTART_TT",            "跳转到起始"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_SKIPTOEND_TT",              "跳转到结束"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_NEXTTURN_TT",               "下一回合[NEWLINE]右键点击+50 [ICON_TURN] 回合"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_PREVTURN_TT",               "上一回合[NEWLINE]右键点击-50 [ICON_TURN] 回合"),
    ("zh_Hans_CN",  "LOC_AKMH_BUTTON_SPEED_TT",                  "修改播放速度[NEWLINE]左键增加[NEWLINE]右键减少"),
    ("zh_Hans_CN",  "LOC_AKMH_PING_CITYFOUNDED",                 "[COLOR_Civ6Green]{1_cityname}已建立[ENDCOLOR]"),
    ("zh_Hans_CN",  "LOC_AKMH_PING_CITYRAZED",                   "[COLOR_RED]{1_cityname}被夷平[ENDCOLOR]"),
    ("zh_Hans_CN",  "LOC_AKMH_PING_CITYCAPTURED",                "[COLOR_Civ6Yellow]{1_cityname}被占领[ENDCOLOR]"),
    ("zh_Hans_CN",  "LOC_AKMH_PING_WONDERBUILT",                 "[COLOR_White]{1_wondername}[ENDCOLOR]"),
    ("zh_Hans_CN",  "LOC_AKMH_UPDATEFREQUENCY_INFO_HEADER",      "地图回放节流调整"),
    ("zh_Hans_CN",  "LOC_AKMH_UPDATEFREQUENCY_INFO_TEXT",        "选择({1_mapx}x{2_mapy})的地图大小与预期的({3_expectedturns})回合数意味着，在{4_fullupdatecutoff}回合之后，地图历史数据将只会每{5_updatefreq}回合更新一次。"),
    ("zh_Hans_CN",  "LOC_AKMH_DATASIZE_WARNING_HEADER",          "[COLOR_RED]地图回放警告[ENDCOLOR]"),
    ("zh_Hans_CN",  "LOC_AKMH_DATASIZE_WARNING_TEXT",            "[COLOR_RED]地图历史数据现在已经有{1_maxsafedatasize}字节大小了[ENDCOLOR][NEWLINE]若你仍将进行很多个回合，推荐禁用该mod来避免可能的存档损坏问题。"),
    ("zh_Hans_CN",  "LOC_AKMH_SAVESPEED_WARNING_HEADER",         "地图回放"),
    ("zh_Hans_CN",  "LOC_AKMH_SAVESPEED_WARNING_TEXT",           "[COLOR_Civ6Yellow]保存地图历史数据用了{1_slowsavecutoff}秒[ENDCOLOR][NEWLINE]存档退出并重新启动游戏或许能加速这个过程。");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                             Text)
values
    ("zh_Hans_CN",  "LOC_AKPAL_LAUNCHBUTTON_TT",                     "宫殿和王座厅"),
    ("zh_Hans_CN",  "LOC_AKPAL_LAUNCHBUTTON_ALERT_SINGLE_TT",        "我们的子民愿意改进宫殿！"),
    ("zh_Hans_CN",  "LOC_AKPAL_LAUNCHBUTTON_ALERT_MULTI_TT",         "我们的子民愿意改进宫殿{1_num}次！"),
    ("zh_Hans_CN",  "LOC_AKPAL_MAIN_TITLE",                          "{1_civadj}宫殿和王座厅"),
    ("zh_Hans_CN",  "LOC_AKPAL_TAB_PALACE",                          "宫殿"),
    ("zh_Hans_CN",  "LOC_AKPAL_TAB_THRONE",                          "王座厅"),
    ("zh_Hans_CN",  "LOC_AKPAL_BUTTON_OPTIONS_TT",                   "选项"),
    ("zh_Hans_CN",  "LOC_AKPAL_BUTTON_DELETETOGGLE_TT",              "完全移除一个之前已建造的模块"),
    ("zh_Hans_CN",  "LOC_AKPAL_NUM_UPGRADES_AVAILABLE_SINGLE",       "升级可用！"),
    ("zh_Hans_CN",  "LOC_AKPAL_NUM_UPGRADES_AVAILABLE_MULTI",        "{1_num}次升级可用！"),
    ("zh_Hans_CN",  "LOC_AKPAL_NUM_UPGRADES_BUILT_SINGLE",           "已进行1次升级"),
    ("zh_Hans_CN",  "LOC_AKPAL_NUM_UPGRADES_BUILT_MULTI",            "已进行{1_num}次升级"),
    ("zh_Hans_CN",  "LOC_AKPAL_WLTKD",                               "我们的子民对我们的统治印象深刻，他们提出要对宫殿或王座厅进行改进！"),
    ("zh_Hans_CN",  "LOC_AKPAL_INSTRUCTIONS",                        "将鼠标移动到图片上找到可用升级，左键点击以进行建造。绿色高亮的项目可解锁后续升级。"),
    ("zh_Hans_CN",  "LOC_AKPAL_INSTRUCTIONS_MULTISTYLE",             "右键点击以为该升级切换不同的风格。"),
    ("zh_Hans_CN",  "LOC_AKPAL_INSTRUCTIONS_DELETEMODE",             "当鼠标悬浮在可被删除的项目上时，其会红色高亮显示，双击以确认删除。[NEWLINE]删除项目不消耗升级点数。"),
    ("zh_Hans_CN",  "LOC_AKPAL_INSTRUCTIONS_DELETEMODE_HEADER",      "[COLOR_RED]已启用删除模式[ENDCOLOR]"),
    ("zh_Hans_CN",  "LOC_AKPAL_DELETEMODE_ENABLED",                  "已启用删除模式"),
    ("zh_Hans_CN",  "LOC_AKPAL_DIFFICULTY_NAME_1",                   "简单"),
    ("zh_Hans_CN",  "LOC_AKPAL_DIFFICULTY_NAME_2",                   "中等"),
    ("zh_Hans_CN",  "LOC_AKPAL_DIFFICULTY_NAME_3",                   "较难"),
    ("zh_Hans_CN",  "LOC_AKPAL_DIFFICULTY_DESC_1",                   "我们的子民是单纯的人，几乎任何事情都能令他们印象深刻，即使是他们以前见过的东西也会让他们赶来祝贺我们。我们很容易就能建造一座宏伟的宫殿，而且也许能重新设计好几次。"),
    ("zh_Hans_CN",  "LOC_AKPAL_DIFFICULTY_DESC_2",                   "新颖性是我们子民的追求，如果我们不断做新的事情，不断开拓新的领域，他们会回报我们。但第四个“令人印象深刻”的学院？谁在乎呢？他们之前已经看过了。只要我们不停滞不前，一座宏伟的宫殿就在我们的掌握之中。"),
    ("zh_Hans_CN",  "LOC_AKPAL_DIFFICULTY_DESC_3",                   "你无法想象一个更加愤世嫉俗和厌倦的人群，只有最令人印象深刻和世界领先的成就才能激励他们。我们有可能完成这座宫殿，但我们必须领先于历代的对手，才有机会。"),
    ("zh_Hans_CN",  "LOC_AKPAL_DIFFICULTY_DESC_3_WARNING",           "[COLOR_RED]
        在高游戏难度下玩时不推荐该选项，AI很可能在多方面超越你率先获得世界首次，你将无法获得可观的升级数量。[ENDCOLOR]"),
    ("zh_Hans_CN",  "LOC_AKPAL_OPT_DIFFICULTY_HEADER",               "难度"),
    ("zh_Hans_CN",  "LOC_AKPAL_OPT_GENERAL_HEADER",                  "通用设置"),
    ("zh_Hans_CN",  "LOC_AKPAL_OPT_ShowInstructionsPanel",           "显示说明面板"),
    ("zh_Hans_CN",  "LOC_AKPAL_OPT_ShowNotificationOnPointAdded",    "在获得升级点数时显示提示"),
    ("zh_Hans_CN",  "LOC_AKPAL_OPT_GW_HEADER",                       "巨作"),
    ("zh_Hans_CN",  "LOC_AKPAL_OPT_AllowUseOfOwnedGreatWorks",       "只有我们目前拥有的巨作可以使用"),
    ("zh_Hans_CN",  "LOC_AKPAL_OPT_AllowUseOfEverOwnedGreatWorks",   "所有我们曾经拥有过的巨作都可以使用"),
    ("zh_Hans_CN",  "LOC_AKPAL_OPT_AllowUseOfAllGreatWorks",         "所有的巨作都可以使用"),
    ("zh_Hans_CN",  "LOC_AKPAL_POINTGAINED_NOTIFICATION_HEADER",     "获得宫殿升级点数"),
    ("zh_Hans_CN",  "LOC_AKPAL_POINTGAINED_NOTIFICATION_TEXT",       "我们的子民对我们的统治印象深刻，他们提出要对宫殿或王座厅进行改进");

-- Extended Map Search
--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                                                    Text)
values
    ("zh_Hans_CN",  "LOC_MSE_WINDOW_TITLE",                                                 "地图搜索扩展"),
    ("zh_Hans_CN",  "LOC_MSE_BTN_REMOVE_LAST_WORD",                                         "退格"),
    ("zh_Hans_CN",  "LOC_MSE_BTN_REMOVE_LAST_WORD_TT",                                      "删除输入框的最后一个词。"),
    ("zh_Hans_CN",  "LOC_MSE_APPEND",                                                       "追加搜索项目"),
    ("zh_Hans_CN",  "LOC_MSE_APPEND_TT",                                                    "将右侧面板中选择的项目追加至输入框中，取消勾选则会直接替代。"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA",                                                  "搜索满足下列条件的单元格"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA_TT",                                               "只有满足下列勾选条件之一的地块才会被搜索。"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA_ME",                                               "我的领土内"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA_ME_TT",                                            "在我的领土内搜索。"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA_OTHER",                                            "其他人的领土内"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA_OTHER_TT",                                         "在其他人的领土内搜索。"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA_NONE",                                             "无主地块"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA_NONE_TT",                                          "在无主地块上搜索。"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA_PURCHASED_BY_ME",                                  "我的城市附近"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_AREA_PURCHASED_BY_ME_TT",                               "在我的城市的3个单元格内搜索。"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_OPTIONS_BTN",                                           "选项"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_OPTIONS_BTN_TT",                                        "设置地图搜索扩展的选项"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_OPTIONS_WND_TITLE",                                     "地图搜索扩展的选项"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_OPTIONS_COLOR_TITLE",                                   "地块高亮配色"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_OPTIONS_COLOR_FILL",                                    "地块高亮填充颜色"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_OPTIONS_COLOR_BORDER1",                                 "地块高亮边框颜色"),
    ("zh_Hans_CN",  "LOC_MSE_SEARCH_OPTIONS_COLOR_BORDER2",                                 "地块高亮内部阴影颜色"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_BLACK",                                                  "黑"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_BLACK_TRANS",                                            "透明黑"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_WHITE",                                                  "白"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_WHITE_TRANS",                                            "透明白"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_GREY",                                                   "灰"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_GREY_TRANS",                                             "透明灰"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_GREEN",                                                  "绿"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_GREEN_TRANS",                                            "透明绿"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_GREEN_DEFAULT",                                          "默认的绿色"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_BLUE",                                                   "蓝"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_BLUE_TRANS",                                             "透明蓝"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_RED",                                                    "红"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_RED_TRANS",                                              "透明红"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_YELLOW",                                                 "黄"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_YELLOW_TRANS",                                           "透明黄"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_CYAN",                                                   "天蓝"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_CYAN_TRANS",                                             "透明天蓝"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_MAGENTA",                                                "品红"),
    ("zh_Hans_CN",  "LOC_MSE_COLOR_MAGENTA_TRANS",                                          "透明品红"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEL_DEST_SEARCH_TT",                                       "选择的项目将进入搜索项目。单击改为进入过滤项目。"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEL_DEST_FILTER_TT",                                       "选择的项目将进入过滤项目。单击改为进入搜索项目。"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEL_RESOURCE_TT",                                          "显示资源"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEL_CITY_TT",                                              "显示城市"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEL_CIVILIZATION_TT",                                      "显示文明"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEL_IMPROVEMENT_TT",                                       "显示改良设施"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEL_UNIT_TT",                                              "显示单位"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEL_WONDER_TT",                                            "显示奇观"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_WINDOW_TITLE",                                             "选择搜索项目"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_WINDOW_TITLE_FILTER",                                      "选择过滤项目"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEARCH_TERMS_IMPROVEMENT_DOES_NOT_MATCH_RESOURCE_DESC",    "搜索因未正确改良而无法享受收益的资源"),
    ("zh_Hans_CN",  "LOC_MSE_EXT_SEARCH_TERMS_IMPROVEMENT_DOES_NOT_MATCH_RESOURCE",         "未正确改良的资源");

-- Custom Notifications
--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                Text)
values
    ("zh_Hans_CN",  "LOC_CN_BUTTON_TOOLTIP",            "自定义提示"),
    ("zh_Hans_CN",  "LOC_CN_TITLE",                     "自定义提示"),
    ("zh_Hans_CN",  "LOC_CN_CITY_POP_CHECKBOX",         "提示城市人口增长"),
    ("zh_Hans_CN",  "LOC_CN_CITY_BORDER_CHECKBOX",      "提示城市边界扩展"),
    ("zh_Hans_CN",  "LOC_CN_TRADE_DEAL_CHECKBOX",       "提示交易到期"),
    ("zh_Hans_CN",  "LOC_CN_RELIGION_CHECKBOX",         "提示宗教传播"),
    ("zh_Hans_CN",  "LOC_CN_CITY_POP_TITLE",            "城市人口增长"),
    ("zh_Hans_CN",  "LOC_CN_CITY_POP_MESSAGE",          "{1_CN_City_Name} 的人口增长了"),
    ("zh_Hans_CN",  "LOC_CN_CITY_POP_MESSAGE_1",        "村民选择了 {1_CN_City_Name} 作为他们的新家"),
    ("zh_Hans_CN",  "LOC_CN_RELIGION_TITLE",            "宗教传播"),
    ("zh_Hans_CN",  "LOC_CN_RELIGION_MESSAGE",          "{1_CN_Religion_Name} 现在是 {2_CN_City_Name} 的主流宗教了"),
    ("zh_Hans_CN",  "LOC_CN_RELIGION_MESSAGE_1",        "{1_CN_Religion_Name} 不再是 {2_CN_City_Name} 的主流宗教了"),
    ("zh_Hans_CN",  "LOC_CN_CITY_BORDER_TITLE",         "城市边界扩展"),
    ("zh_Hans_CN",  "LOC_CN_CITY_BORDER_MESSAGE",       "{1_CN_City_Name} 城市扩展了他的边界"),
    ("zh_Hans_CN",  "LOC_CN_TRADE_DEAL_TITLE",          "交易到期"),
    ("zh_Hans_CN",  "LOC_CN_TRADE_DEAL_MESSAGE",        "你与 {1_CN_Player_Name} 的交易到期了");

--------------------------------------------------------------------------------------------------------------------------
-- Policy Change Reminder
insert or replace into LocalizedText
    (Language,      Tag,                                Text)
values
    ("zh_Hans_CN",  "LOC_FF16_NEWPOLICY_TITLE",         "你有新的政策卡"),
    ("zh_Hans_CN",  "LOC_FF16_NEWPOLICY_DESC",          "有新的政策卡刚刚解锁。[NEWLINE]这回合改变政策与政体是免费的。[NEWLINE][NEWLINE]是否不修改继续回合？"),
    ("zh_Hans_CN",  "LOC_FF16_NEWPOLICY_CHANGE",        "改变政策"),
    ("zh_Hans_CN",  "LOC_FF16_NEWPOLICY_CONTINUE",      "下一回合");

--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
-- Great Person Recruited Notification
insert or replace into LocalizedText
    (Language,      Tag,                                                                        Text)
values
    ("zh_Hans_CN",  "LOC_NOTIFICATION_OTHER_PLAYER_RECRUITED_GREATPERSON_MESSAGE",              "伟人被招募"),
    ("zh_Hans_CN",  "LOC_NOTIFICATION_OTHER_PLAYER_RECRUITED_GREATPERSON_SUMMARY",              "{1_recruiter} 已招募了 {2_greatPersonType} {3_greatPersonName}");

--------------------------------------------------------------------------------------------------------------------------
-- Enhanced Mod Manager
insert or replace into LocalizedText
    (Language,      Tag,                                Text)
values
    ("zh_Hans_CN",  "LOC_FF16_SORTBY_LASTUPDATED",      "按更新时间排序"),
    ("zh_Hans_CN",  "LOC_FF16_SORTBY_COMPATIBILITY",    "按兼容性排序"),
    ("zh_Hans_CN",  "LOC_FF16_CUSTOM_FILTER",           "自定义过滤："),
    ("zh_Hans_CN",  "LOC_FF16_CUSTOM_FILTER_OFF",       "关闭");

--------------------------------------------------------------------------------------------------------------------------
-- Enhanced Mod Manager
insert or replace into LocalizedText
    (Language,      Tag,                                Text)
values
    ("zh_Hans_CN",  "LOC_FF16_SORTBY_LASTUPDATED",      "按更新时间排序"),
    ("zh_Hans_CN",  "LOC_FF16_SORTBY_COMPATIBILITY",    "按兼容性排序"),
    ("zh_Hans_CN",  "LOC_FF16_CUSTOM_FILTER",           "自定义过滤："),
    ("zh_Hans_CN",  "LOC_FF16_CUSTOM_FILTER_OFF",       "Off");

--------------------------------------------------------------------------------------------------------------------------
-- Aircraft Carriers Perfected
insert or replace into LocalizedText
    (Language,      Tag,                                                                    Text)
values
    ("zh_Hans_CN",  "LOC_ABILITY_AIRCRAFT_CARRIER_FLEET_AIRCRAFT_SLOT_NAME",                "舰队机库扩容"),
    ("zh_Hans_CN",  "LOC_ABILITY_AIRCRAFT_CARRIER_FLEET_AIRCRAFT_SLOT_DESCRIPTION",         "从组建舰队获得+1航空单位槽位"),
    ("zh_Hans_CN",  "LOC_ABILITY_AIRCRAFT_CARRIER_ARMADA_AIRCRAFT_SLOT_NAME",               "无敌舰队机库扩容"),
    ("zh_Hans_CN",  "LOC_ABILITY_AIRCRAFT_CARRIER_ARMADA_AIRCRAFT_SLOT_DESCRIPTION",        "从组建无敌舰队获得+1航空单位槽位"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_ARMOURED_FLIGHT_DECK_NAME",                           "装甲甲板"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_ARMOURED_FLIGHT_DECK_DESCRIPTION",                    "防御时+10 [ICON_Strength] 战斗力。"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_DAMAGE_CONTROL_NAME",                                 "损伤管制"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_DAMAGE_CONTROL_DESCRIPTION",                          "每回合都可以自动回复，在友军领土外也可以回复。"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_MOBILE_DRYDOCKS_NAME",                                "机动干船坞"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_MOBILE_DRYDOCKS_DESCRIPTION",                         "每回合为自己和相邻海军单位+10额外回复。"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_SCOUT_PLANES_NAME",                                   "侦察机"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_SCOUT_PLANES_DESCRIPTION",                            "+2视野。"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_COMBAT_AIR_PATROL_NAME",                              "防空巡航"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_COMBAT_AIR_PATROL_DESCRIPTION",                       "+15 [ICON_AntiAir_Large] 防空战斗力。"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_ANTI_SUB_NAME",                                       "反潜巡航"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_ANTI_SUB_DESCRIPTION",                                "发现视野中的隐形单位。"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_SUPER_CARRIER_NAME",                                  "超级航母"),
    ("zh_Hans_CN",  "LOC_PROMOTION_NS_SUPER_CARRIER_DESCRIPTION",                           "+1 [ICON_Movement] 移动力，+1额外航空单位槽位，每回合为舰载机+5额外回复。"),
    ("zh_Hans_CN",  "LOC_ABILITY_CARRIER_CANNOT_ATTACK_NAME",                               "航空母舰"),
    ("zh_Hans_CN",  "LOC_ABILITY_CARRIER_CANNOT_ATTACK_DESCRIPTION",                        "无法攻击。"),
    ("zh_Hans_CN",  "LOC_PEDIA_UNITPROMOTIONS_PAGE_PROMOTION_NS_ARMOURED_FLIGHT_DECK_CHAPTER_HISTORY_PARA_1",   "装甲飞行甲板的发展是战争对提高生存能力要求的自然结果。 设计师们必须选择装甲布置最有效的地方来保护易燃燃料、军械和关键船舶系统。"),
    ("zh_Hans_CN",  "LOC_PEDIA_UNITPROMOTIONS_PAGE_PROMOTION_NS_DAMAGE_CONTROL_CHAPTER_HISTORY_PARA_1",         "安全运行飞行甲板所涉及的技能、培训和知识对于航母在攻击中幸存是至关重要的。 许多这样的规定都是在以前的灾难中产生的。 在火灾中打开通风系统可能会使整艘船沉没。 对于船员来说，无论是在正常的操作中还是在攻击后，严格遵守规章制度和程序是非常重要的。 那些遵守规定的人都能活下来。"),
    ("zh_Hans_CN",  "LOC_PEDIA_UNITPROMOTIONS_PAGE_PROMOTION_NS_MOBILE_DRYDOCKS_CHAPTER_HISTORY_PARA_1",        "美国发展出的后勤中队，或移动的前沿作业船厂和基地，是跨越太平洋向日本推进的一个关键因素。 移动干船坞和可移动的码头让受损的船只进行维修，而不需要长途跋涉回到正规的船厂。 这些移动基地甚至可以建立在遍布太平洋的浅水环礁上，远离敌人侦察兵窥视的更明显的地点。"),
    ("zh_Hans_CN",  "LOC_PEDIA_UNITPROMOTIONS_PAGE_PROMOTION_NS_SCOUT_PLANES_CHAPTER_HISTORY_PARA_1",           "早期的侦察机对于发现敌人是非常有价值的，以至于许多早期的巡洋舰都携带了海上飞机，就是为了这个目的。 随着航空母舰的发展和飞行技术的进步，这种侦察机可以抛弃高阻力的浮桥，更快地覆盖更多区域。"),
    ("zh_Hans_CN",  "LOC_PEDIA_UNITPROMOTIONS_PAGE_PROMOTION_NS_COMBAT_AIR_PATROL_CHAPTER_HISTORY_PARA_1",      "保持战斗空中巡逻是航母保护舰队免受来袭空中威胁的主要方法。 在不断进步的雷达技术的帮助下，盟军飞行员获得了主动权，并能在气浪到达舰队之前拦截它们。"),
    ("zh_Hans_CN",  "LOC_PEDIA_UNITPROMOTIONS_PAGE_PROMOTION_NS_ANTI_SUB_CHAPTER_HISTORY_PARA_1",               "世界大战期间，潜艇对盟国航运的极端危险要求盟军进一步努力探测和打击这些水下威胁。 使用带有机载雷达的侦察机是盟国用来定位和摧毁敌方潜艇的一种技巧。 即使潜艇探测到了雷达，它们也会被迫潜入水中，几乎不能动弹，因此没有效果。"),
    ("zh_Hans_CN",  "LOC_PEDIA_UNITPROMOTIONS_PAGE_PROMOTION_NS_SUPER_CARRIER_CHAPTER_HISTORY_PARA_1",          "在冷战时期及以后，航母变得更加庞大，其能力也随之增强。 它们就像一个小型的城市，能够在海上持续很长时间。");

--------------------------------------------------------------------------------------------------------------------------
-- No Trait Challenge
insert or replace into LocalizedText
    (Language,      Tag,                                            Text)
values
    ("zh_Hans_CN",  "LOC_CIVILIZATION_NORMAL_NAME",                 "白板文明"),
    ("zh_Hans_CN",  "LOC_CIVILIZATION_NORMAL_DESCRIPTION",          "一个白板文明"),
    ("zh_Hans_CN",  "LOC_CIVILIZATION_NORMAL_ADJECTIVE",            "你的"),
    ("zh_Hans_CN",  "LOC_LEADER_PLAYER_ONE_NAME",                   "白板"),
    ("zh_Hans_CN",  "LOC_TRAIT_CIVILIZATION_NORMAL_NAME",           "白板文明"),
    ("zh_Hans_CN",  "LOC_TRAIT_CIVILIZATION_NORMAL_DESCRIPTION",    "无特色能力，无特色建筑，无特色改良，无特色区域，无特色单位。"),
    ("zh_Hans_CN",  "LOC_TRAIT_LEADER_PLAYER_ONE_NAME",             "白板领袖"),
    ("zh_Hans_CN",  "LOC_TRAIT_LEADER_PLAYER_ONE_DESCRIPTION",      "无领袖能力");

insert or replace into LocalizedText
    (Language,      Tag,                                                                            Text)
values
    ("zh_Hans_CN",  "LOC_PEDIA_LEADERS_PAGE_LEADER_PLAYER_ONE_CHAPTER_CAPSULE_BODY",                "白板"),
    ("zh_Hans_CN",  "LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_NORMAL_CHAPTER_HISTORY_PARA_1",      "文明6于2016年10月21日发布。");

insert or replace into LocalizedText
    (Language,      Tag,                                            Text)
values
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_MALE_1",                    "某人"),
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_MALE_2",                    "某人"),
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_MALE_3",                    "某人"),
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_MALE_4",                    "某人"),
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_MALE_5",                    "某人"),
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_FEMALE_1",                  "某人"),
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_FEMALE_2",                  "某人"),
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_FEMALE_3",                  "某人"),
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_FEMALE_4",                  "某人"),
    ("zh_Hans_CN",  "LOC_CITIZEN_NORMAL_FEMALE_5",                  "某人"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_CAPITAL",          "首都"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_1",                "一分"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_2",                "二分"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_3",                "三分"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_4",                "四分"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_5",                "五分"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_6",                "六分"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_7",                "七分"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_8",                "八分"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_9",                "九分"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_10",               "第10分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_11",               "第11分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_12",               "第12分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_13",               "第13分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_14",               "第14分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_15",               "第15分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_16",               "第16分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_17",               "第17分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_18",               "第18分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_19",               "第19分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_20",               "第20分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_21",               "第21分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_22",               "第22分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_23",               "第23分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_24",               "第24分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_25",               "第25分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_26",               "第26分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_27",               "第27分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_28",               "第28分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_29",               "第29分城"),
    ("zh_Hans_CN",  "LOC_CIVLIZATION_NORMAL_CITY_30",               "你城好多啊！");
--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                    Text)
values
    -- Better Religion Screen
    ("zh_Hans_CN",  "LOC_BRW_CITY_SORT_ALL",                "所有城市"),
    ("zh_Hans_CN",  "LOC_BRW_CITY_SORT_NOT_FOLLOWING",      "[COLOR_Red]不[ENDCOLOR]信奉宗教的城市");
