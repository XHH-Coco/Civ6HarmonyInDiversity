-- Units with Ability ABILITY_BLOCK_FIRST_NON_LETHAL_ATTACK_EACH_TURN ignores the first non-lethal combat (as defender) damage each turn. by xiaoxiao
-- ExposedMembers.DLHD = ExposedMembers.DLHD or {};
-- ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
-- Utils = ExposedMembers.DLHD.Utils;

function OnCombat (combatResult)
    local name = "ABILITY_BLOCK_FIRST_NON_LETHAL_ATTACK_EACH_TURN"
    local turn = Game.GetCurrentGameTurn()
    local defender = combatResult[CombatResultParameters.DEFENDER]
    local info = defender[CombatResultParameters.ID]
    local unit = UnitManager.GetUnit(info.player, info.id)
    if unit then
        local used = unit:GetProperty(name .. "_USED_ON_TURN" .. turn)
        if unit:GetAbility():HasAbility(name) and not used then
            local location = unit:GetLocation()
            Game.AddWorldViewText(0, Locale.Lookup("LOC_" .. name .. "_POP"), location.x, location.y)
            unit:ChangeDamage(-defender[CombatResultParameters.DAMAGE_TO])
            unit:SetProperty(name .. "_USED_ON_TURN" .. turn, true)
        end
    end
end

Events.Combat.Add(OnCombat)

-- 垃圾回收中心, by xiaoxiao
local RECYCLING_PLANT_PRODUCTION_PERCENT = GlobalParameters.RECYCLING_PLANT_PRODUCTION_PERCENT or 0;
function HDRecyclingPlantRecycle (playerId, unitId)
    local unit = UnitManager.GetUnit(playerId, unitId);
    local unitInfo = GameInfo.Units[unit:GetType()];
    local cost = unitInfo.Cost;
    local resourceType = unitInfo.StrategicResource;
    local resourceCost = 0;
    local unitXP2Info = GameInfo.Units_XP2[unitInfo.UnitType];
    if unitXP2Info ~= nil then
        resourceCost = unitXP2Info.ResourceCost;
    end
    local resourceCostMultiplier = 0;
    if resourceType ~= nil then
        resourceCostMultiplier = GlobalParameters['RECYCLING_PLANT_' .. resourceType .. '_MULTIPLIER'] or 0;
    end
    local gold = RECYCLING_PLANT_PRODUCTION_PERCENT * cost / 100 + resourceCostMultiplier * resourceCost;
    local player = Players[playerId];
    player:GetTreasury():ChangeGoldBalance(gold);
    
	local location = unit:GetLocation();
	local x = location.x;
	local y = location.y;
    Game.AddWorldViewText(playerId, '+' .. gold ..' [ICON_GOLD]', x, y);

end
GameEvents.HDRecyclingPlantRecycle.Add(HDRecyclingPlantRecycle);

-- 奇琴伊察献祭，by xiaoxiao
local SACRIFICED_CHICHEN_ITZA_KEY = 'SACRIFICED_CHICHEN_ITZA';
function HDChiChenItzaSacrifice (playerId, unitId)
    local player = Players[playerId];
    local unit = UnitManager.GetUnit(playerId, unitId);
    local unitInfo = GameInfo.Units[unit:GetType()];
    local unitType = unitInfo.UnitType;
	local sacrificed = player:GetProperty(SACRIFICED_CHICHEN_ITZA_KEY) or {};
    sacrificed[unitType] = 1;
    player:SetProperty(SACRIFICED_CHICHEN_ITZA_KEY, sacrificed);
    local cost = unitInfo.Combat;
    local award = math.floor(cost * GlobalParameters.CHICHEN_ITZA_PERCENTAGE / 100);
    if award < 1 then
        award = 1;
    end
    for i = 1, award do
        player:AttachModifierByID('CHICHEN_ITZA_SACRIFICE_FAITH');
        player:AttachModifierByID('CHICHEN_ITZA_SACRIFICE_CULTURE');
    end
end
GameEvents.HDChiChenItzaSacrifice.Add(HDChiChenItzaSacrifice);

-- 高德院剃度出家，by xiaoxiao
-- function HDKotokuInPravrajya (playerId, unitId)
--     local player = Players[playerId];
--     player:AttachModifierByID('KOTOKU_IN_GRANTS_CIVILIAN_MONK');
-- end
-- GameEvents.HDKotokuInPravrajya.Add(HDKotokuInPravrajya);

-- 津巴布韦探路者，by xiaoxiao
local PATHFINDER_RESOURCE_KEY = "PATHFINDER_RESOURCE";
local PATHFINDER_TIME_KEY = "PATHFINDER_TIME";
function HDPathfinderRecord (playerId, unitId)
    local unit = UnitManager.GetUnit(playerId, unitId);
	local location = unit:GetLocation();
	local plot = Map.GetPlot(location.x, location.y);
	local resourceId = plot:GetResourceType();
	if resourceId ~= -1 then
		local resourceInfo = GameInfo.Resources[resourceId];
		if resourceInfo.ResourceClassType == 'RESOURCECLASS_LUXURY' then
			unit:SetProperty(PATHFINDER_RESOURCE_KEY, resourceInfo.Index);
		end
	end
end
GameEvents.HDPathfinderRecord.Add(HDPathfinderRecord);
function HDPathfinderPlant (playerId, unitId)
    local unit = UnitManager.GetUnit(playerId, unitId);
	local location = unit:GetLocation();
	local plot = Map.GetPlot(location.x, location.y);
	local resourceId = unit:GetProperty(PATHFINDER_RESOURCE_KEY);
	if resourceId ~= nil then
		ResourceBuilder.SetResourceType(plot, resourceId, 1);
		unit:SetProperty(PATHFINDER_TIME_KEY, (unit:GetProperty(PATHFINDER_TIME_KEY) or 0) + 1);
	end
end
GameEvents.HDPathfinderPlant.Add(HDPathfinderPlant);

--获取单位级别
function UnitGetLevelNum (playerId, unitId)
    local pUnit = UnitManager.GetUnit(playerId, unitId);
    local level = 0;
    for row in GameInfo.UnitPromotions() do
        if (row ~= nil) and (pUnit:GetExperience() ~= nil) and (pUnit:GetExperience():HasPromotion(row.Index)) then
            level = level + 1;
        end
    end
    return level;
end

--间谍
function PromotionSpyOffensiveMission (playerId, pPlotIndex, SpyName, SpyOperationId)
    local PromotionSpyChaosIndex = GameInfo.UnitPromotions['PROMOTION_SPY_CHAOS'].Index;
    local PromotionSpySeniorCheaterIndex = GameInfo.UnitPromotions['PROMOTION_SPY_SENIOR_CHEATER'].Index;
    local PromotionSpyScholarIndex = GameInfo.UnitPromotions['PROMOTION_SPY_SCHOLAR'].Index;
    local PromotionSpyHeroesIndex = GameInfo.UnitPromotions['PROMOTION_SPY_HEROES'].Index;

    local PolicyWallBreakerIndex = GameInfo.Policies['POLICY_WALLBREAKER'].Index;
    local BuildingWallsEarlyIndex = GameInfo.Buildings['BUILDING_WALLS_EARLY'].Index;
    local BuildingWallsIndex = GameInfo.Buildings['BUILDING_WALLS'].Index;
    local BuildingCastleIndex = GameInfo.Buildings['BUILDING_CASTLE'].Index;
    local BuildingStarFortIndex = GameInfo.Buildings['BUILDING_STAR_FORT'].Index;
    local BuildingTsikneIndex = GameInfo.Buildings['BUILDING_TSIKHE'].Index;

    local PolicyScholarSpiritIndex = GameInfo.Policies['POLICY_SCHOLAR_SPIRIT'].Index;
    local PolicySpyHeroesIndex = GameInfo.Policies['POLICY_SPY_HEROES'].Index;

    local pPlayer = Players[playerId];
    local pPlot = Map.GetPlotByIndex(pPlotIndex);
    local city = Cities.GetPlotPurchaseCity(pPlot);
    local SpyOperationType = GameInfo.UnitOperations[SpyOperationId].OperationType;
    local pUnit = nil;

    for i, tUnit in pPlayer:GetUnits():Members() do
        if tUnit:GetName() == SpyName then
            pUnit = tUnit;
        end
    end
    local pUnitX = pUnit:GetX();
    local pUnitY = pUnit:GetY();
    local unitId = pUnit:GetID();
    local level = UnitGetLevelNum (playerId, unitId);

    local Amount = 0;
    --间谍晋升
    if (SpyOperationType ~= 'UNITOPERATION_SPY_LISTENING_POST') and (SpyOperationType ~= 'UNITOPERATION_SPY_COUNTERSPY') then
        --煽动减人口
        if (pUnit:GetExperience():HasPromotion(PromotionSpyChaosIndex)) and (city:GetOwner() ~= playerId) then
            if city:GetPopulation() > 1 then
                city:ChangePopulation(-1);
                Game.AddWorldViewText(0, "-1 [ICON_CITIZEN]", city:GetX(), city:GetY());
            end
        end

        --盗窃团伙给钱
        if (pUnit:GetExperience():HasPromotion(PromotionSpySeniorCheaterIndex)) and (city:GetOwner() ~= playerId) then
            Amount = level * 40;
            pPlayer:GetTreasury():ChangeGoldBalance(Amount);
            Game.AddWorldViewText(0, "+" .. Amount .. " [ICON_GOLD]", pUnitX, pUnitY);
        end

        --犯罪天才给瓶琴
        if (pUnit:GetExperience():HasPromotion(PromotionSpyScholarIndex)) and (city:GetOwner() ~= playerId) then
            pPlayer:GetTechs():ChangeCurrentResearchProgress(50);
            pPlayer:GetCulture():ChangeCurrentCulturalProgress(50);
            Game.AddWorldViewText(0, "+ 50 [ICON_SCIENCE]", pUnitX, pUnitY);
            Game.AddWorldViewText(0, "+ 50 [ICON_CULTURE]", pUnitX, pUnitY);
        end

        --英豪升级
        if (pUnit:GetExperience():HasPromotion(PromotionSpyHeroesIndex)) and (city:GetOwner() ~= playerId) then
            for i, unit in pPlayer:GetUnits():Members() do
                local unitInfo = GameInfo.Units[unit:GetType()];
                local unitTypeName = unitInfo.UnitType;
                local unitX = unit:GetX();
                local unitY = unit:GetY();
                local unitLevel = UnitGetLevelNum (playerId, unit:GetID());
    
                if unitTypeName == "UNIT_SPY" then
                -- if Utils.IsUnitPromotionPromotion(pUnit:GetType(), "PROMOTION_CLASS_SPY") then
                    local plots = Map.GetNeighborPlots(pUnitX, pUnitY, 9);
                    for j, adjPlot in ipairs(plots) do
	                    if (unitX == adjPlot:GetX()) and (unitY == adjPlot:GetY()) and (unitLevel <= 2) then
                            local exps = unit:GetExperience():GetExperienceForNextLevel();
                            unit:GetExperience():ChangeExperience(exps);
                        end
                    end
                end
            end
        end
        --间谍政策
        --判断有没有挂卡
        --城墙破坏者
        if pPlayer:GetCulture():IsPolicyActive(PolicyWallBreakerIndex) then
            --2级间谍破坏简易远古城墙
            if level >= 2 then
                if city:GetBuildings():HasBuilding(BuildingWallsEarlyIndex) and not city:GetBuildings():IsPillaged(BuildingWallsEarlyIndex) then
                    city:GetBuildings():RemoveBuilding(BuildingWallsEarlyIndex);
                    -- city:GetBuildings():SetPillaged(BuildingWallsIndex, true)
                end
            end
            --2级间谍破坏远古城墙
            if level >= 2 then
                if city:GetBuildings():HasBuilding(BuildingWallsIndex) and not city:GetBuildings():IsPillaged(BuildingWallsIndex) then
                    city:GetBuildings():RemoveBuilding(BuildingWallsIndex);
                    -- city:GetBuildings():SetPillaged(BuildingWallsIndex, true)
                end
            end
            --3级间谍破坏中世纪城墙
            if level >= 3 then
                if city:GetBuildings():HasBuilding(BuildingCastleIndex) and not city:GetBuildings():IsPillaged(BuildingCastleIndex) then
                    city:GetBuildings():RemoveBuilding(BuildingCastleIndex);
                    -- city:GetBuildings():SetPillaged(BuildingCastleIndex, true)
                end
                if city:GetBuildings():HasBuilding(BuildingTsikneIndex) and not city:GetBuildings():IsPillaged(BuildingTsikneIndex) then
                    city:GetBuildings():RemoveBuilding(BuildingTsikneIndex);
                    -- city:GetBuildings():SetPillaged(BuildingTsikneIndex, true)
                end
            end
            --4级间谍破坏文艺复兴城墙或城堡
            if level ==4 then
                if city:GetBuildings():HasBuilding(BuildingStarFortIndex) and not city:GetBuildings():IsPillaged(BuildingStarFortIndex) then
                    city:GetBuildings():RemoveBuilding(BuildingStarFortIndex);
                    -- city:GetBuildings():SetPillaged(BuildingStarFortIndex, true)
                end
            end
        end
        --学者精神
        if pPlayer:GetCulture():IsPolicyActive(PolicyScholarSpiritIndex) then
            --遍历所有单位，如果存在犯罪天才则使获取瓶琴的数量翻倍
            local ScholarHad = false;
            for i, Sunit in pPlayer:GetUnits():Members() do
                if Sunit:GetExperience():HasPromotion(PromotionSpyScholarIndex) then
                    ScholarHad = true;
                end
            end
            if ScholarHad == false then
                Amount = level * 5;
            else
                Amount = level * 10;
            end
            pPlayer:GetTechs():ChangeCurrentResearchProgress(Amount);
            pPlayer:GetCulture():ChangeCurrentCulturalProgress(Amount);
            Game.AddWorldViewText(0, "+" .. Amount .. " [ICON_SCIENCE]", pUnitX, pUnitY);
            Game.AddWorldViewText(0, "+" .. Amount .. " [ICON_CULTURE]", pUnitX, pUnitY);
        end
        --游击精英
        if pPlayer:GetCulture():IsPolicyActive(PolicySpyHeroesIndex) then
            if (pUnit:GetExperience():HasPromotion(PromotionSpyHeroesIndex)) and (city:GetOwner() ~= playerId) then
                for i, unit in pPlayer:GetUnits():Members() do
                    local unitInfo = GameInfo.Units[unit:GetType()];
                    local unitTypeName = unitInfo.UnitType;
                    local unitFormationClass = unitInfo.FormationClass;
                    local unitX = unit:GetX();
                    local unitY = unit:GetY();
                    local unitLevel = UnitGetLevelNum (playerId, unit:GetID());
        
                    if (unitFormationClass ~= "FORMATION_CLASS_CIVILIAN") and (unitFormationClass ~= "FORMATION_CLASS_SUPPORT") then
                        local plots = Map.GetNeighborPlots(pUnitX, pUnitY, 6);
                        for j, adjPlot in ipairs(plots) do
                            if (unitX == adjPlot:GetX()) and (unitY == adjPlot:GetY()) and (unitLevel <= 2) then
                                local exps = unit:GetExperience():GetExperienceForNextLevel();
                                unit:GetExperience():ChangeExperience(exps);
                            end
                            if (unitX == adjPlot:GetX()) and (unitY == adjPlot:GetY()) and (unitLevel > 2) then
                                unit:ChangeDamage(-30)
                            end
                        end
                    end
                end
            end
        end
        --如果间谍是3级则获得1次晋升
        if level == 3 and pPlayer:IsHuman() then 
            local Spyexps = pUnit:GetExperience():GetExperienceForNextLevel()
            pUnit:GetExperience():ChangeExperience(Spyexps);
        end
        --间谍完成进攻性任务时获得+1时代得分
        Game.GetEras():ChangePlayerEraScore(playerId, 1);
        NotificationManager.SendNotification(playerId, "NOTIFICATION_PRIDE_MOMENT_RECORDED", "LOC_NOTIFIER_OFFENSIVE_MISSION_ERASCORE");
    end
end

GameEvents.PromotionSpyOffensiveMissionSwitch.Add(PromotionSpyOffensiveMission);


function PromotionSpyPromoted (playerId, unitId)
    local PromotionSpyLocalInformantIndex = GameInfo.UnitPromotions['PROMOTION_SPY_LOCAL_INFORMANT'].Index;
    local PromotionSpyWebberIndex = GameInfo.UnitPromotions['PROMOTION_SPY_WEBBER'].Index;
    local pPlayer = Players[playerId];
    local pUnit = UnitManager.GetUnit(playerId, unitId);
    local level = UnitGetLevelNum (playerId, unitId);
    local pUnitX = pUnit:GetX();
    local pUnitY = pUnit:GetY();

    if GameInfo.Units[pUnit:GetType()].UnitType ~= 'UNIT_SPY' then
    -- if not Utils.IsUnitPromotion(pUnit:GetType(), "PROMOTION_CLASS_SPY") then
        return;
    end

    local SpyName = pUnit:GetName();
    local pPlot = Map.GetPlot(pUnitX, pUnitY);
    local city = Cities.GetPlotPurchaseCity(pPlot);

    --因为每个间谍都有自己固定的名字，移动到其他城市后虽然单位id变了，但间谍名字没有变化，通过间谍的名字存储数据可以避免重复触发。
    --本地线人送新手间谍
    --当玩家拥有的间谍名对应本地线人的数据不存在时，触发本地线人
    if pUnit:GetExperience():HasPromotion(PromotionSpyLocalInformantIndex) and pPlayer:GetProperty(SpyName .. "LocalInformant") == nil then
        UnitManager.InitUnit(playerId, "UNIT_SPY", city:GetX(), city:GetY());
        -- UnitManager.InitUnit(playerId, GameInfo.Units[pUnit:GetType()].UnitType, city:GetX(), city:GetY());
        --触发本地线人后，存储玩家拥有的间谍名对应本地线人的数据为true，避免重复触发
        pPlayer:SetProperty(SpyName .. "LocalInformant", true);
    end

    --幕后织网送间谍并减人口
    --当玩家拥有的间谍名对应幕后织网的数据不存在时，触发幕后织网
    if pUnit:GetExperience():HasPromotion(PromotionSpyWebberIndex) and pPlayer:GetProperty(SpyName .. "Webber") == nil then
        UnitManager.InitUnit(playerId, "UNIT_SPY", city:GetX(), city:GetY());
        -- UnitManager.InitUnit(playerId, GameInfo.Units[pUnit:GetType()].UnitType, city:GetX(), city:GetY());
        city:ChangePopulation(-1);
        Game.AddWorldViewText(0, "-1 [ICON_CITIZEN]", city:GetX(), city:GetY());
        --触发幕后织网后，存储玩家拥有的间谍名对应幕后织网的数据为true，避免重复触发
        pPlayer:SetProperty(SpyName .. "Webber", true);
    end
    --4级间谍获得逃跑成功率提升的能力
    if level == 4 and pUnit:GetAbility():GetAbilityCount("ABILITY_LEVEL4_SPY_ESCAPE_INCREASE") == 0 then
        pUnit:GetAbility():ChangeAbilityCount("ABILITY_LEVEL4_SPY_ESCAPE_INCREASE", 1)
    end

    --传奇间谍+3时代得分
    if level == 4 and pPlayer:GetProperty(SpyName .. "EraScore") == nil then
        Game.GetEras():ChangePlayerEraScore(playerId, 3);
        NotificationManager.SendNotification(playerId, "NOTIFICATION_PRIDE_MOMENT_RECORDED", "LOC_NOTIFIER_LEGENDARY_SPY_ERASCORE");
        pPlayer:SetProperty(SpyName .. "EraScore", true);
    end
end

Events.UnitPromoted.Add(PromotionSpyPromoted);

--外交密探
function DiplomaticSpyTurnEnd ()
    local PromotionSpyDiplomatIndex = GameInfo.UnitPromotions['PROMOTION_SPY_DIPLOMAT'].Index;
    local PolicyDiplomaticSpyIndex = GameInfo.Policies['POLICY_DIPLOMATIC_SPY'].Index;

    local SpyInfuluenceAbilityCount = 0;
    local SpyInfuluenceDoubleAbilityCount = 0;
    local SpyInfuluenceAbilityChange = 0
    local SpyInfuluenceDoubleAbilityChange = 0

    for _, playerId in pairs(PlayerManager.GetWasEverAliveIDs()) do
        local pPlayer = Players[playerId];
        --获取玩家的单位中是否有长袖善舞技能
        local DiplomatHad = false;
        for i, pUnit in pPlayer:GetUnits():Members() do
            if pUnit:GetExperience():HasPromotion(PromotionSpyDiplomatIndex) then
                DiplomatHad = true;
            end
        end
        --判断是否有外交密探政策卡，有则根据长袖善舞给予影响力点数，没有则移除
        if pPlayer:GetCulture():IsPolicyActive(PolicyDiplomaticSpyIndex) then
            if DiplomatHad == false then
                for j, dUnit in pPlayer:GetUnits():Members() do
                    if GameInfo.Units[dUnit:GetType()].UnitType == 'UNIT_SPY' then
                    -- if Utils.IsUnitPromotion(dUnit:GetType(), "PROMOTION_CLASS_SPY") then
                        --初始化能力
                        SpyInfuluenceAbilityCount = dUnit:GetAbility():GetAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE")
                        SpyInfuluenceDoubleAbilityCount = dUnit:GetAbility():GetAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE_DOUBLE")
                        SpyInfuluenceAbilityChange = (SpyInfuluenceAbilityCount ~= 0) and -SpyInfuluenceAbilityCount or 0
                        SpyInfuluenceDoubleAbilityChange = (SpyInfuluenceDoubleAbilityCount ~= 0) and -SpyInfuluenceDoubleAbilityCount or 0
                        dUnit:GetAbility():ChangeAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE", SpyInfuluenceAbilityChange)
                        dUnit:GetAbility():ChangeAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE_DOUBLE", SpyInfuluenceDoubleAbilityChange)
                        --设置能力
                        dUnit:GetAbility():ChangeAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE", 1)
                    end
                end
            end
            if DiplomatHad == true then
                for j, dUnit in pPlayer:GetUnits():Members() do
                    if GameInfo.Units[dUnit:GetType()].UnitType == 'UNIT_SPY' then
                    -- if Utils.IsUnitPromotion(dUnit:GetType(), "PROMOTION_CLASS_SPY") then
                        SpyInfuluenceAbilityCount = dUnit:GetAbility():GetAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE")
                        SpyInfuluenceDoubleAbilityCount = dUnit:GetAbility():GetAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE_DOUBLE")
                        SpyInfuluenceAbilityChange = (SpyInfuluenceAbilityCount ~= 0) and -SpyInfuluenceAbilityCount or 0
                        SpyInfuluenceDoubleAbilityChange = (SpyInfuluenceDoubleAbilityCount ~= 0) and -SpyInfuluenceDoubleAbilityCount or 0
                        dUnit:GetAbility():ChangeAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE", SpyInfuluenceAbilityChange)
                        dUnit:GetAbility():ChangeAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE_DOUBLE", SpyInfuluenceDoubleAbilityChange)
                        dUnit:GetAbility():ChangeAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE_DOUBLE", 1)
                    end
                end
            end
        else
            --没挂卡删除能力
            for j, dUnit in pPlayer:GetUnits():Members() do
                if GameInfo.Units[dUnit:GetType()].UnitType == 'UNIT_SPY' then
                -- if Utils.IsUnitPromotion(dUnit:GetType(), "PROMOTION_CLASS_SPY") then
                    SpyInfuluenceAbilityCount = dUnit:GetAbility():GetAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE")
                    SpyInfuluenceDoubleAbilityCount = dUnit:GetAbility():GetAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE_DOUBLE")
                    SpyInfuluenceAbilityChange = (SpyInfuluenceAbilityCount ~= 0) and -SpyInfuluenceAbilityCount or 0
                    SpyInfuluenceDoubleAbilityChange = (SpyInfuluenceDoubleAbilityCount ~= 0) and -SpyInfuluenceDoubleAbilityCount or 0
                    dUnit:GetAbility():ChangeAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE", SpyInfuluenceAbilityChange)
                    dUnit:GetAbility():ChangeAbilityCount("ABILITY_DIPLOMATIC_SPY_INFLUENCE_DOUBLE", SpyInfuluenceDoubleAbilityChange)
                end
            end
        end
    end
end

Events.TurnEnd.Add(DiplomaticSpyTurnEnd);

--酷吏
function SpyInquisitorTurnEnd ()
    local PromotionSpyInquisitorIndex = GameInfo.UnitPromotions['PROMOTION_SPY_INQUISITOR'].Index;
    local PolicySpyInquisitorIndex = GameInfo.Policies['POLICY_SPY_INQUISITOR'].Index;

    local SpyFoodProductionAbilityCount = 0;
    local SpyFoodProductionAbilityChange = 0

    for _, playerId in pairs(PlayerManager.GetWasEverAliveIDs()) do
        local pPlayer = Players[playerId];

        --判断是否有酷吏政策卡，有则給予严刑逼供粮锤能力，没有则移除
        if pPlayer:GetCulture():IsPolicyActive(PolicySpyInquisitorIndex) then
            --获取玩家拥有严刑逼供的单位
            for i, pUnit in pPlayer:GetUnits():Members() do
                --如果间谍拥有严刑逼供，获取粮锤能力
                if GameInfo.Units[pUnit:GetType()].UnitType == 'UNIT_SPY' and pUnit:GetExperience():HasPromotion(PromotionSpyInquisitorIndex) then
                -- if Utils.IsUnitPromotion(pUnit:GetType(), "PROMOTION_CLASS_SPY") and pUnit:GetExperience():HasPromotion(PromotionSpyInquisitorIndex) then
                    --初始化能力
                    SpyFoodProductionAbilityCount = pUnit:GetAbility():GetAbilityCount("ABILITY_SPY_FOOD_PRODUCTION")
                    SpyFoodProductionAbilityChange = (SpyFoodProductionAbilityCount ~= 0) and -SpyFoodProductionAbilityCount or 0
                    pUnit:GetAbility():ChangeAbilityCount("ABILITY_SPY_FOOD_PRODUCTION", SpyFoodProductionAbilityChange)
                    --赋予能力
                    pUnit:GetAbility():ChangeAbilityCount("ABILITY_SPY_FOOD_PRODUCTION", 1);
                end
            end
        else
            for j, dUnit in pPlayer:GetUnits():Members() do
                if GameInfo.Units[dUnit:GetType()].UnitType == 'UNIT_SPY' then
                -- if Utils.IsUnitPromotion(dUnit:GetType(), "PROMOTION_CLASS_SPY") then
                    --初始化能力
                    SpyFoodProductionAbilityCount = dUnit:GetAbility():GetAbilityCount("ABILITY_SPY_FOOD_PRODUCTION")
                    SpyFoodProductionAbilityChange = (SpyFoodProductionAbilityCount ~= 0) and -SpyFoodProductionAbilityCount or 0
                    dUnit:GetAbility():ChangeAbilityCount("ABILITY_SPY_FOOD_PRODUCTION", SpyFoodProductionAbilityChange)
                end
            end
        end
    end
end

Events.TurnEnd.Add(SpyInquisitorTurnEnd);

function SetSpySkillTreeUnlock (iPlayerID, I,J, spyname)
    local pPlayer = Players[iPlayerID];
    pPlayer:SetProperty("SPY_SKILL_TREE" .. I .. J .. spyname .. "Unlock", true) -- 技能树存表
end

function SetSpySkillTreelock (iPlayerID, I,J, spyname)
    local pPlayer = Players[iPlayerID];
    pPlayer:SetProperty("SPY_SKILL_TREE" .. I .. J .. spyname .. "Unlock", false) -- 技能树存表
end

function GetSpySkillTreeUnlock (iPlayerID, I, J, spyname)
    local pPlayer = Players[iPlayerID];
    return pPlayer:GetProperty("SPY_SKILL_TREE" .. I .. J .. spyname .. "Unlock") -- 读取技能树
end

ExposedMembers.SPYPROMOTION = ExposedMembers.SPYPROMOTION or {}
ExposedMembers.SPYPROMOTION.UnitGetLevelNum = UnitGetLevelNum
ExposedMembers.SPYPROMOTION.SetSpySkillTreeUnlock = SetSpySkillTreeUnlock
ExposedMembers.SPYPROMOTION.SetSpySkillTreelock = SetSpySkillTreelock
ExposedMembers.SPYPROMOTION.GetSpySkillTreeUnlock = GetSpySkillTreeUnlock