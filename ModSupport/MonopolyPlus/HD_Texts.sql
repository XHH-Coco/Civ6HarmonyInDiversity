update LocalizedText
set Text = replace(Text, "[NEWLINE][NEWLINE]Moving the [ICON_GREATWORK_PRODUCT] Product to another city or civilization grants this Corporation's tile +1 [ICON_GOLD] Gold. Consumes 2 [ICON_POWER] Power while produced.[NEWLINE]",
"[NEWLINE][NEWLINE]移动 [ICON_GREATWORK_PRODUCT] 产品到另一个城市或文明会给该公司所在单元格+1 [ICON_GOLD] 金币。在生产时消耗2点 [ICON_POWER] 电力。[NEWLINE]")
where Tag LIKE "LOC_PROJECT_CREATE_CORPORATION_PRODUCT_%_DESCRIPTION" and Language = 'zh_Hans_CN';

--------------------------------------------------------------------------------
insert or replace into EnglishText
    (Tag,                                                           Text)
values
    ("LOC_IMPROVEMENT_LEU_STATION_DESCRIPTION",                     "Improvement built by Tycoon or Military Engineers. Cannot be built Marsh, Swamp or Geothermal Fissure tiles. Only one may be built in each city, and may not be built adjacent to another Station. Railroads are instantly built on current and adjacent passable land tiles. [NEWLINE][NEWLINE]Improvements of this City provided +50% [ICON_TOURISM] Tourism. [NEWLINE][NEWLINE]Each type of adjacent Specialized districts or adjacent Aqueduct provide corresponding yield to International [ICON_TradeRoute] Trade Routes from this city. This bonus is doubled if this city is fully [ICON_POWER] Powered.");

-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                               Text)
values
    ("zh_Hans_CN",  "LOC_UNIT_LEU_TYCOON_NAME",                        "大亨"),
    ("zh_Hans_CN",  "LOC_UNIT_LEU_TYCOON_NOMONOPOLY_DESCRIPTION",      "需要“工作坊”方可建造或购买的高价平民单位。[NEWLINE][NEWLINE]可以创建铁路和火车站来改善你的领土上的区域产出、贸易和 [ICON_PRODUCTION] 生产力。"),
    ("zh_Hans_CN",  "LOC_STATION_ADJ_PRODUCTION",                      "+{1_num} [ICON_PRODUCTION] 生产力来自相邻火车站。"),
    ("zh_Hans_CN",  "LOC_IMPROVEMENT_LEU_STATION_NAME",                "火车站"),
    ("zh_Hans_CN",  "LOC_IMPROVEMENT_LEU_STATION_DESCRIPTION",         "由大亨或军事工程师建造，不能建在沼泽或地热裂缝上，一座城市只能拥有一个火车站，火车站不能与另一个火车站相邻。在所在单元格和所有相邻的可通行陆地单元格上自动创建铁路。[NEWLINE][NEWLINE]本城改良提供的 [ICON_TOURISM] 旅游业绩+50%。[NEWLINE][NEWLINE]相邻的每种专业化区域或水渠为本城出发的国际 [ICON_TradeRoute] 贸易路线提供对应产出；此城 [ICON_POWER] 供电充足时效果翻倍。");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                               Text)
values
    ("zh_Hans_CN", 
    "LOC_PEDIA_IMPROVEMENTS_PAGE_IMPROVEMENT_LEU_STATION_CHAPTER_HISTORY_PARA_1",                   
    "列车站、火车站、铁路站或车厂是一个铁路设施或区域，列车定期在此停靠以装载或卸载乘客、货物或两者均由。它通常由至少一个轨边站台和一个提供票务销售、候车室和行李/货运服务等辅助服务的车站建筑（车厂）组成。如果一个车站位于单轨线上，它通常有一个通行环路，以方便交通移动。"),

    ("zh_Hans_CN", 
    "LOC_PEDIA_IMPROVEMENTS_PAGE_IMPROVEMENT_LEU_STATION_CHAPTER_HISTORY_PARA_2",                   
    "在现代化进程中，高效运输货物和人员的能力一直很重要。以蒸汽为动力的机车产生了最深远的影响。火车是一种重型的、快速的、全年的运输解决方案。随着时间的推移，它们成为商业运输的首选。美国最早的铁路只覆盖短距离。1827年，马里兰州巴尔的摩市的一群商人成立了一个公司，建造了第一条主要铁路。它在他们的城市和俄亥俄河之间运行。在南北战争（1861-1865）之前的几十年里，还有许多私人铁路企业相继成立。1840年至1860年间，全国铺设的铁路数量增加了10倍。第一条横贯大陆的线路是在1869年建立的。最终，铁路降低了许多种货物的远距离运输成本。"),

    ("zh_Hans_CN", 
    "LOC_PEDIA_IMPROVEMENTS_PAGE_IMPROVEMENT_LEU_STATION_CHAPTER_HISTORY_PARA_3",                   
    "这些运输方面的进步有助于推动北美西部地区的定居。它们对于国家的工业化也是至关重要的。由此带来的生产力的增长是惊人的。繁忙的交通联系促进了城市的发展。运输系统有助于在全世界范围内建立一个国家规模的工业经济。"),

    ("zh_Hans_CN", 
    "LOC_PEDIA_UNITS_PAGE_UNIT_LEU_TYCOON_CHAPTER_HISTORY_PARA_1",                  
    "大亨一词来源于日本的taikun，意思是“大领主”，用作对幕府将军的称呼。这个词在1857年随着佩里准将返回美国而进入英语。美国总统林肯被他的助手约翰-尼古拉和约翰-海幽默地称为大亨。这个词传到了商业界，并一直使用到现在。大亨(mogul)、大亨(Tycoon)和男爵(baron)这些词经常被用于19世纪末和20世纪初北美的商业巨头，如采矿、伐木和石油等采掘业，航运和铁路等运输领域，汽车制造和钢铁制造等制造业，以及银行和报纸出版业。他们的统治地位被称为第二次工业革命，镀金时代，或强盗男爵时代。"),

    ("zh_Hans_CN", 
    "LOC_PEDIA_UNITS_PAGE_UNIT_LEU_TYCOON_CHAPTER_HISTORY_PARA_2",                  
    "在美国的镀金时代——横跨19世纪后半叶的大部分时间，从1870年左右到1900年——经通货膨胀调整后的财富和美国最杰出人物的影响远远超过了我们今天所看到的情况。"),

    ("zh_Hans_CN", 
    "LOC_PEDIA_UNITS_PAGE_UNIT_LEU_TYCOON_CHAPTER_HISTORY_PARA_3",                  
    "像约翰-D-洛克菲勒、科尼利厄斯-范德比尔特、亨利-福特和安德鲁-卡内基这样的人的财富，按照今天的标准，将以数千亿美元计算——远远超过埃隆-马斯克、比尔-盖茨、马克-扎克伯格等科技巨头，甚至是截至2019年世界上最富有的个人杰夫-贝佐斯。如此庞大的财富往往能凸显一个时代的金融不平等。正是这种面对未解决的社会问题的宏伟想法，导致马克-吐温在其1873年的小说《镀金时代：今天的故事》中创造了“镀金时代”这个词。这个标题表明，精英阶层薄薄的财富外衣掩盖了许多中下阶层的更广泛的问题。"),

    ("zh_Hans_CN", 
    "LOC_PEDIA_UNITS_PAGE_UNIT_LEU_TYCOON_CHAPTER_HISTORY_PARA_4",                  
    "但美国在镀金时代取得的进步是不可否认的。作为第二次工业革命的一部分，美国经历了令人印象深刻的经济扩张——由当时比生命更重要的财富和权力人物领导。这种增长在很大程度上得益于铁路——现在从海岸延伸到海岸——以及工厂、钢铁和煤矿业。大企业蓬勃发展，打字机、收银机和加钞机等技术有助于改变人们的工作方式。经济爆炸不仅包括工业增长，还包括农业技术的增长，如机械收割机。"),

    ("zh_Hans_CN", 
    "LOC_PEDIA_UNITS_PAGE_UNIT_LEU_TYCOON_CHAPTER_HISTORY_PARA_5",                  
    "在这样一个巨幅扩张的时代，围绕财富和商业行为的法规较少，环境非常适合占社会很小比例的极度富有的个人阶层的崛起。他们有能力和手段为许多人创造机会和工作，尽管社会对工人权利的重视程度较低，但歧视、剥削和低工资等问题是这个时代的特点。"),

-- --------------------------------------------------------------------
-- -- Basic Great Person Info
-- --------------------------------------------------------------------
    ("zh_Hans_CN", 
    "LOC_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_NAME",                 
    "安德鲁·卡内基"),

-- --------------------------------------------------------------------
-- -- Great Person Abilities / Great Works
-- --------------------------------------------------------------------
    ("zh_Hans_CN", 
    "LOC_LEU_GREATPERSON_FREE_TYCOON",                   
    "立即获得一个大亨。"),
    ("en_US", 
    "LOC_LEU_GREATPERSON_FREE_TYCOON",                   
    "Receives a free Tycoon."),
    ("zh_Hans_CN", 
    "LOC_PIERO_DE_BARDI_TYCOON_PRODUCTION",                   
    "所有城市生产大亨+50%建造速度。"),
    ("en_US", 
    "LOC_PIERO_DE_BARDI_TYCOON_PRODUCTION",                   
    "+50% construction speed towards Tycoons in all cities."),
    ("zh_Hans_CN", 
    "LOC_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_ACTIVE",                   
    "立即在该区域建造集市、银行、市场和证券交易所。[NEWLINE]所有商业中心四级建筑+15 [ICON_GOLD] 金币。"),
    ("en_US", 
    "LOC_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_ACTIVE",                   
    "Instantly builds a Fair, a Market, a Bank and a Stock Exchange in this city. [NEWLINE]Provides +15 [ICON_GOLD] Gold to Tier 4 buildings in Commercial Hub districts."),
    ("zh_Hans_CN", 
    "LOC_JNR_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_ACTIVE",                   
    "立即在该区域建造集市、银行、市场和证券交易所。[NEWLINE]所有商业中心四级建筑+15 [ICON_GOLD] 金币。"),
    ("en_US", 
    "LOC_JNR_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_ACTIVE",                   
    "Instantly builds a Fair, a Market, a Bank and a Stock Exchange in this city. [NEWLINE]Provides +15 [ICON_GOLD] Gold to Tier 4 buildings in Commercial Hub districts."),

-- --------------------------------------------------------------------
-- -- Great Person Pedia
-- --------------------------------------------------------------------
    -- Andrew Carnegie
    ("zh_Hans_CN", 
    "LOC_PEDIA_GREATPEOPLE_PAGE_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_CHAPTER_HISTORY_PARA_1",                    
    "出生于苏格兰的美国工业家和慈善家安德鲁-卡内基是1873年至1901年美国钢铁工业的领导者。他将大量的财富捐赠给教育、文化和科学机构。"),

    ("zh_Hans_CN", 
    "LOC_PEDIA_GREATPEOPLE_PAGE_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_CHAPTER_HISTORY_PARA_2",                    
    "安德鲁-卡内基于1835年11月25日出生在苏格兰的邓弗姆林，是织工威廉-卡内基和玛格丽特-莫里森-卡内基的儿子。织布机的发明取代了卡内基父亲所做的工作，最终，这个家庭被迫陷入贫困。1848年，他们全家离开苏格兰，在宾夕法尼亚州的阿勒格尼市定居。卡内基的父亲在一家棉纺厂找到了一份工作，但他很快就辞职回到家里的手织机上，制作亚麻布并试图挨家挨户地出售。卡内基也在棉纺厂工作，但在他的父亲于1855年去世后，他帮助照顾家庭的强烈愿望促使他自己接受教育。他成了一个狂热的读者，一个剧院的观众，以及一个音乐爱好者。卡内基成为匹兹堡电报局的一名送信员。后来他成为一名电报员。宾夕法尼亚州铁路公司西部分部的主管托马斯-A-斯科特让18岁的卡内基担任他的秘书。卡内基很快就赚到了足够的薪水，为他的母亲买了一套房子。内战期间（1861-65年），斯科特被任命为负责运输的助理战争部长，卡内基帮助组织了军事电报系统。但他很快就回到了匹兹堡，接替斯科特在铁路公司的老工作。"),

    ("zh_Hans_CN", 
    "LOC_PEDIA_GREATPEOPLE_PAGE_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_CHAPTER_HISTORY_PARA_3",                    
    "在1865年至1870年间，卡内基通过投资几个小铁厂和工厂赚了钱。他还走遍英国，出售美国小型铁路和桥梁公司的债券。卡内基开始看到，钢铁最终将取代铁，用于制造铁轨、结构形状、管道和电线。1873年，他组织了一家钢轨公司。1874年，宾夕法尼亚州布拉多克的第一个钢炉开始轧制钢轨。卡内基通过削减价格、赶走竞争对手、甩掉弱小的合作伙伴，并将收益投入到公司中，继续进行建设。他从未上市（为了筹集资金而出售公司的股份）。相反，他从利润中获得资本（资金）——必要时，从当地银行获得——他继续发展，独自制造重钢。到1878年，该公司的价值为125万美元。在19世纪80年代，卡内基的采购包括H.C.弗里克公司的多数股份。"),
    
    ("zh_Hans_CN", 
    "LOC_PEDIA_GREATPEOPLE_PAGE_GREAT_PERSON_INDIVIDUAL_LEU_ANDREW_CARNEGIE_CHAPTER_HISTORY_PARA_4",                    
    "该公司在宾夕法尼亚州的康奈尔斯维尔和宾夕法尼亚州匹兹堡郊外的霍姆斯特德工厂拥有大片煤田和一千多座锅炉。弗里克成为他的合伙人，并最终成为卡内基公司的董事长。卡内基于1867年搬到纽约市，以接近钢铁产品的营销中心；弗里克则留在匹兹堡担任总经理。他们是一个很好的团队。在幕后，卡内基计划新项目、成本控制和改进工厂；弗里克是工作主管，负责监督有助于降低价格的大规模生产计划。卡内基将他的闲暇时间用于旅行。他还写了几本书，包括《胜利的民主》（1886年），其中指出了美国生活相对于英国和其他欧洲国家不平等社会的优势。对卡内基来说，获得教育是美国政治稳定和工业成就的关键。1889年，他发表了一篇题为“财富”的文章，阐述了他的信念，即富人有责任用他们的钱来改善社区的福利。卡内基一直是个单身汉，直到他母亲在1886年去世。一年后，他与路易丝-惠特菲尔德结婚。他们共生了一个孩子。这对夫妇开始每年在苏格兰度过六个月的时间，卡内基一直关注着商业发展和问题。");
