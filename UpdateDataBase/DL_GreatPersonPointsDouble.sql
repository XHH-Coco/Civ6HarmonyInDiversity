-------------------------------------
--   Great Person Points Double    --
-------------------------------------

-- 1. 建筑（本体）集体
-- 2. 区域整体
-- 3. 专家整体
-- 4. 万神整体
-- 5. 项目伟人点，伟人购买价格
-- 6. 梁的奇观返大工点
-- 7. 一系列modifier

update Eras set GreatPersonBaseCost = GreatPersonBaseCost * 2 where EraType in ("ERA_ANCIENT","ERA_CLASSICAL","ERA_MEDIEVAL");
update Eras set GreatPersonBaseCost = GreatPersonBaseCost * 2 where EraType in ("ERA_RENAISSANCE","ERA_INDUSTRIAL","ERA_MODERN");
update Eras set GreatPersonBaseCost = GreatPersonBaseCost * 2 where EraType in ("ERA_ATOMIC","ERA_INFORMATION","ERA_FUTURE");
update Building_GreatPersonPoints set PointsPerTurn = PointsPerTurn * 2;
update District_GreatPersonPoints set PointsPerTurn = PointsPerTurn * 2;
update Project_GreatPersonPoints set Points = Points * 2;

-- Oracle are being taken care of by DL_Wonders.

update ModifierArguments set Value = Value * 2 where Name = 'Amount' and
	(  ModifierId = 'BYZANTIUM_GREATPROPHETPOINTS'   -- 拜占庭 
	or ModifierId = 'COMMEMORATION_RELIGIOUS_GA_GREAT_PROPHET_POINTS' -- 布道
	-- or ModifierId = 'DIVINE_SPARK_HOLY_SITE_MODIFIER' -- 神光
	-- or ModifierId = 'DIVINE_SPARK_SCIENTIST_MODIFIER'
	-- or ModifierId = 'DIVINE_SPARK_WRITER_MODIFIER'
	or ModifierId = 'FRESCOES_ARTIST_ARTMUSEUM' -- 政策卡
	or ModifierId = 'FRESCOES_GREATARTISTPOINTS'
	or ModifierId = 'GARDE_GREAT_GENERAL_POINTS' -- 帝国卫队
	or ModifierId = 'GREAT_GENERAL_ZHANGYE' -- 丹霞
	or ModifierId = 'GREAT_MERCHANT_ZHANGYE'
	or ModifierId = 'HETAIROI_GREAT_GENERAL_POINTS' -- 伙友骑兵
	or ModifierId = 'INSPIRATION_GREATSCIENTISTPOINTS' -- 政策卡
	-- or ModifierId = 'INVENTION_ENGINEER_WORKSHOP' -- 政策卡
	-- or ModifierId = 'INVENTION_GREATENGINEERPOINTS'
	or ModifierId = 'LAISSEZFAIRE_ADMIRAL_SEAPORT' -- 政策卡
	or ModifierId = 'LAISSEZFAIRE_ADMIRAL_SHIPYARD' 
	or ModifierId = 'LAISSEZFAIRE_GREATMERCHANTPOINTS' 
	or ModifierId = 'LAISSEZFAIRE_MERCHANT_BANK' 
	or ModifierId = 'LAISSEZFAIRE_MERCHANT_STOCKEXCHANGE' 
	or ModifierId = 'LITERARYTRADITION_GREATWRITERPOINTS' -- 政策卡
	-- or ModifierId = 'MILITARYORGANIZATION_GREATGENERALPOINTS' -- 政策卡
	-- or ModifierId = 'MILITARYORGANIZATION_GREATGENERAL_ARMORY'
	-- or ModifierId = 'MILITARYORGANIZATION_GREATGENERAL_MILITARYACADEMY'
	-- or ModifierId = 'MINOR_CIV_BOLOGNA_GREAT_ADMIRAL_POINTS_BONUS' -- 博洛尼亚
	-- or ModifierId = 'MINOR_CIV_BOLOGNA_GREAT_ARTIST_POINTS_BONUS'
	-- or ModifierId = 'MINOR_CIV_BOLOGNA_GREAT_ENGINEER_POINTS_BONUS'
	-- or ModifierId = 'MINOR_CIV_BOLOGNA_GREAT_GENERAL_POINTS_BONUS'
	-- or ModifierId = 'MINOR_CIV_BOLOGNA_GREAT_MERCHANT_POINTS_BONUS'
	-- or ModifierId = 'MINOR_CIV_BOLOGNA_GREAT_MUSICIAN_POINTS_BONUS'
	-- or ModifierId = 'MINOR_CIV_BOLOGNA_GREAT_PROPHET_POINTS_BONUS'
	-- or ModifierId = 'MINOR_CIV_BOLOGNA_GREAT_SCIENTIST_POINTS_BONUS'
	-- or ModifierId = 'MINOR_CIV_BOLOGNA_GREAT_WRITER_POINTS_BONUS'
	or ModifierId = 'NAVIGATION_GREATADMIRALPOINTS' -- 政策卡
	or ModifierId = 'NOBELPRIZE_GREATSCIENTISTPOINTS' -- 政策卡（已更名）
	or ModifierId = 'REVELATION_GREATPROPHETPOINTS' -- 政策卡
	or ModifierId = 'SCIENCEFOUNDATION_ENGINEER_FACTORY' -- 政策卡
	or ModifierId = 'SCIENCEFOUNDATION_ENGINEER_POWERPLANT'
	or ModifierId = 'SCIENCEFOUNDATION_SCIENTIST_RESEARCHLAB'
	or ModifierId = 'SCIENCEFOUNDATION_SCIENTIST_UNIVERSITY'
	or ModifierId = 'STRATEGOS_GREATGENERALPOINTS' -- 政策卡
	or ModifierId = 'SYMPHONIES_GREATMUSICIANPOINTS' -- 政策卡
	or ModifierId = 'SYMPHONIES_MUSICIAN_BROADCASTCENTER'
	or ModifierId = 'TRAIT_ENGINEER_ECSTATIC' -- 苏格兰
	or ModifierId = 'TRAIT_ENGINEER_HAPPY'
	or ModifierId = 'TRAIT_SCIENTIST_ECSTATIC'
	or ModifierId = 'TRAIT_SCIENTIST_HAPPY'
	or ModifierId = 'TRAIT_GREAT_ENGINEER_FACTORY_MODIFIER' -- 瑞典
	or ModifierId = 'TRAIT_GREAT_SCIENTIST_UNIVERSITY_MODIFIER'
	or ModifierId = 'TRAVELINGMERCHANTS_GREATMERCHANTPOINTS' -- 政策卡
	or ModifierId = 'WOLIN_GREAT_ADMIRAL_POINTS' -- 沃林
	or ModifierId = 'WOLIN_GREAT_GENERAL_POINTS'
	or ModifierId = 'ALLIANCE_ADJUST_DISTRICT_GREAT_PEOPLE_POINTS' -- 同盟
	or ModifierId = 'GREATPERSON_GREAT_PERSON_FREE_POINTS' -- 诺贝尔（伟人）
	or ModifierId = 'WORLD_FAIR_FIRST_PLACE_GREAT_PERSON_POINTS' -- 世博会
);
