include "HD_StateUtils"
Utils = ExposedMembers.DLHD.Utils;

ExposedMembers.GameEvents = GameEvents

function AttachModifier(playerId, cityId, modifierId)
	local city = CityManager.GetCity(playerId, cityId);
	city:AttachModifierByID(modifierId);
end
GameEvents.AttachModifierSwitch.Add(AttachModifier);

function OnPlayerEraScoreChanged(playerID, amountAwarded)
    local player = Players[playerID]
    if player ~= nil then
        -- print(player)
        if player:IsMajor() then
            local amount = tonumber(GameInfo.GlobalParameters['GOLD_FOR_EVERY_ERA_SCORE'].Value)
            player:GetTreasury():ChangeGoldBalance(amountAwarded * amount)
        end
    end
end

Events.PlayerEraScoreChanged.Add(OnPlayerEraScoreChanged)

-- local m_FortID = GameInfo.Improvements['IMPROVEMENT_FORT'].Index;
-- local m_WatchTower = GameInfo.Improvements['IMPROVEMENT_SAILOR_WATCHTOWER'];
-- local m_WatchTowerID = -1;
-- if m_WatchTower ~= nil then
--     m_WatchTowerID = m_WatchTower.Index;
-- end
-- local PROP_IMPROVEMENT_PILLAGED_TURNS = "ImprovementsPillagedTurns";
-- local needTurn = GlobalParameters.TURNS_BEFORE_DESTROY_AFTER_PILLAGE;

-- Countdown for Pillaged Watchtower or Fort.
-- GameEvents.OnGameTurnStarted.Add(function (currentTurn)
--     local mapsize = GameInfo.Maps[Map.GetMapSize()];
--     local iH = mapsize.GridHeight;
--     local iW = mapsize.GridWidth;
--     for x = 0, iW - 1 do
--         for y = 0, iH - 1 do
--             local plot = Map.GetPlotXY(x, y);
--             if (plot ~= nil) then
--                 local eImprovement = plot:GetImprovementType();
--                 -- Fort or Watchtower Improvement (outside territory).
--                 if (eImprovement == m_FortID or eImprovement == m_WatchTowerID) and plot:GetOwner() == -1 then
--                     local turns = plot:GetProperty(PROP_IMPROVEMENT_PILLAGED_TURNS) or 0;
--                     if (plot:IsImprovementPillaged()) then
--                         if turns == needTurn then
--                             -- destroy the improvement.
--                             ImprovementBuilder.SetImprovementType(plot, -1, -1);
--                             print('Improvement completely destroyed: ', plot:GetX(), plot:GetY());
--                             break;
--                         end
--                         message = Locale.Lookup("LOC_TURNS_BEFORE_DESTROY_HD", needTurn - turns);
--                         turns = turns + 1;
--                         Game.AddWorldViewText(0, message, plot:GetX(), plot:GetY());
--                         -- UI.AddWorldViewText(EventSubTypes.PLOT, message, plot:GetX(), plot:GetY(), 0);
--                     else
--                         turns = 0;
--                     end
--                     plot:SetProperty(PROP_IMPROVEMENT_PILLAGED_TURNS, turns)
--                 end
--             end
--         end
--     end
-- end);

-- BUG
-- Events.ImprovementAddedToMap.Add(function (iX, iY, improvementID, playerID)
--     local plot = Map.GetPlotXY(iX, iY);
--     -- The Wrong plot. 
--     print(iX, iY, improvementID, playerID);
--     if improvementID == m_FortID then
--         plot:SetOwner(playerID);
--     end
-- end);

-- strategic projects
function ProjectStrategicResourcesChange(playerID, cityID, projectID)
    local player = Players[playerID]
    -- print(GameInfo.Projects['PROJECT_GRANT_RESOURCE_HORSES'].Index, projectID)
    local project_name = GameInfo.Projects[projectID].ProjectType
    local resource_name = string.sub(project_name, 15)
    if string.sub(project_name, 1, 14) == 'PROJECT_GRANT_' then
        local playerResources = Players[playerID]:GetResources()
        local resource_id = GameInfo.Resources[resource_name].Index
        playerResources:ChangeResourceAmount(resource_id, 20)
    end
end

Events.CityProjectCompleted.Add(ProjectStrategicResourcesChange)

-- great admiral free strategic resource for heal
function GreatAdmiralFreeStrategicResource(unitOwner, unitID, greatPersonClassID, greatPersonIndividualID)
	local owner = Players[unitOwner]
    if greatPersonIndividualID == GameInfo.GreatPersonIndividuals["GREAT_PERSON_INDIVIDUAL_YI_SUN_SIN"].Index or 
       greatPersonIndividualID == GameInfo.GreatPersonIndividuals["GREAT_PERSON_INDIVIDUAL_FRANZ_VON_HIPPER"].Index then    
        local resource_id = GameInfo.Resources["RESOURCE_COAL"].Index
		owner:GetResources():ChangeResourceAmount(resource_id, 1)
	end
    if greatPersonIndividualID == GameInfo.GreatPersonIndividuals["GREAT_PERSON_INDIVIDUAL_CHESTER_NIMITZ"].Index then    
        local resource_id = GameInfo.Resources["RESOURCE_OIL"].Index
		owner:GetResources():ChangeResourceAmount(resource_id, 1)
	end
end

Events.UnitGreatPersonActivated.Add(GreatAdmiralFreeStrategicResource)

function SyncFavor(playerID)
    local player = Players[playerID]
    player:AttachModifierByID('HD_GRANT_ZERO_FAVOR')
end
GameEvents.ForceSyncFavor.Add(SyncFavor)

function ChangeFaithBalance(playerID, amount)
    local player = Players[playerID]
    if player ~= nil then
        player:GetReligion():ChangeFaithBalance(amount)
    end
end
GameEvents.RequestChangeFaithBalance.Add(ChangeFaithBalance)

GameEvents.RequestCreateBuilding.Add(function (playerID, cityID, buildingID)
    local city = CityManager.GetCity(playerID, cityID)
    print('HD DEBUG create building requested', playerID, cityID, buildingID)
    if city then
        local buildingQueue = city:GetBuildQueue()
        -- print(city, buildingQueue)
        buildingQueue:CreateBuilding(buildingID) 
    end
end)

GameEvents.RequestRemoveBuilding.Add(function (playerID, cityID, buildingID)
    local city = CityManager.GetCity(playerID, cityID)
    print('HD DEBUG remove building requested', playerID, cityID, buildingID)
    if city ~= nil then
        local buildings = city:GetBuildings()
        buildings:RemoveBuilding(buildingID)
    end
end)

GameEvents.ChangeUnitExperience.Add(function(playerID, unitID, amount)
    local unit = UnitManager.GetUnit(playerID, unitID)
    if unit ~= nil then
        print('HD DEBUG +exp', amount, playerID, unitID)
        unit:GetExperience():SetExperienceLocked(false);
        unit:GetExperience():ChangeExperience(amount);
    end
end)

GameEvents.SendEnvoytoCityState.Add(function(playerID, citystateID)
    -- Need to make sure the second is citystate
    local player = Players[playerID]
    if player ~= nil then
        player:GetInfluence():GiveFreeTokenToPlayer(citystateID)
    end
end)

GameEvents.AddGreatPeoplePoints.Add(function(playerID, gppID, amount)
    local player = Players[playerID]
    if player ~= nil then
        print('HD DEBUG add great people point', playerID, gppID, amount)
        player:GetGreatPeoplePoints():ChangePointsTotal(gppID, amount)
    end
end)

-- Archer for City State
local CITY_STATE_ARCHER_TURN_KEY = 'CITY_STATE_ARCHER_TURN';
function ArcherForCityState ()
	if Game.GetCurrentGameTurn() == 1 then
		local min = GlobalParameters.CITY_STATE_ARCHER_MIN_TURN;
		local max = GlobalParameters.CITY_STATE_ARCHER_MAX_TURN;
		if (min ~= nil) and (max ~= nil) and (min <= max) then
			for _, player in pairs(Players) do
				if (player ~= nil) and (player:GetInfluence() ~= nil) and player:GetInfluence():CanReceiveInfluence() then
					player:SetProperty(CITY_STATE_ARCHER_TURN_KEY, math.random(min, max));
				end
			end
		end
	end
	for _, player in pairs(Players) do
		if (player ~= nil) and (player:GetInfluence() ~= nil) then
			local turn = player:GetProperty(CITY_STATE_ARCHER_TURN_KEY);
			if (turn ~= nil) and (turn == Game.GetCurrentGameTurn()) then
				player:AttachModifierByID('CITY_STATE_GRANT_ARCHER');
			end
		end
	end
end
Events.TurnBegin.Add(ArcherForCityState);

-- Reyna
local REYNA_CULTURE_KEY = 'REYNA_CULTURE_';
GameEvents.ReynaChangeCurrentCulturalProgress.Add(function (playerId, amount)
	local player = Players[playerId];
	local turn = Game.GetCurrentGameTurn();
	local key = REYNA_CULTURE_KEY .. turn;
	if player:GetProperty(key) == nil then
		player:SetProperty(key, 1);
		player:GetCulture():ChangeCurrentCulturalProgress(amount);
	end
end);

-- Religious Settlements
local RELIGIOUS_SETTLEMENTS_INDEX = GameInfo.Beliefs['BELIEF_RELIGIOUS_SETTLEMENTS'].Index;
local GREAT_PROPHET_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_PROPHET'].Index;
GameEvents.CityBuilt.Add(function (playerId, cityId, x, y)
	local player = Players[playerId];
	local pantheon = player:GetReligion():GetPantheon();
	if pantheon == RELIGIOUS_SETTLEMENTS_INDEX then
		player:GetGreatPeoplePoints():ChangePointsTotal(GREAT_PROPHET_INDEX, 30);
	end
end);
-- local SETTLER_INDEX = GameInfo.Units['UNIT_SETTLER'].Index;
-- Events.CityProductionCompleted.Add(function (playerId, cityId, type, unitId, cancelled)
-- 	if unitId == nil then
-- 		return;
-- 	end
-- 	local player = Players[playerId];
-- 	local unit = UnitManager.GetUnit(playerId, unitId);
-- 	local pantheon = player:GetReligion():GetPantheon();
-- 	if (pantheon == RELIGIOUS_SETTLEMENTS_INDEX) and (unit:GetType() == SETTLER_INDEX) then
-- 		player:GetGreatPeoplePoints():ChangePointsTotal(GREAT_PROPHET_INDEX, 30);
-- 	end
-- end);
-- Events.CityMadePurchase.Add(function (playerId, cityId, x, y, purchaseType, objectType)
-- 	if (purchaseType == EventSubTypes.UNIT) and (objectType == SETTLER_INDEX) then
-- 		local player = Players[playerId];
-- 		local pantheon = player:GetReligion():GetPantheon();
-- 		if pantheon == RELIGIOUS_SETTLEMENTS_INDEX then
-- 			player:GetGreatPeoplePoints():ChangePointsTotal(GREAT_PROPHET_INDEX, 30);
-- 		end
-- 	end
-- end);

-- Free Tech
local FREE_TECH_KEY = 'HD_FREE_TECH';
GameEvents.HD_FreeTechSwitch.Add(function (playerId, techId)
	local player = Players[playerId];
	local remains = player:GetProperty(FREE_TECH_KEY) or 0;
	local playerTech = player:GetTechs();
	
	player:SetProperty(FREE_TECH_KEY, remains - 1);
	playerTech:SetResearchProgress(techId, playerTech:GetResearchCost(techId));
end);
Events.WonderCompleted.Add(function (x, y, buildingId, playerId, cityId, percentComplete, unknown)
	local player = Players[playerId];
	local buildingInfo = GameInfo.Buildings[buildingId];
	local remains = player:GetProperty(FREE_TECH_KEY) or 0;
	if buildingInfo.BuildingType == 'BUILDING_OXFORD_UNIVERSITY' then
		player:SetProperty(FREE_TECH_KEY, remains + 2);
	elseif buildingInfo.BuildingType == 'WON_CL_BUILDING_ARECIBO' then
		player:SetProperty(FREE_TECH_KEY, remains + 1);
	end
end);

-- Free Civic
local FREE_CIVIC_KEY = 'HD_FREE_CIVIC';
GameEvents.HD_FreeCivicSwitch.Add(function (playerId, civicId)
	local player = Players[playerId];
	local remains = player:GetProperty(FREE_CIVIC_KEY) or 0;
	local playerCulture = player:GetCulture();

	player:SetProperty(FREE_CIVIC_KEY, remains - 1);
	playerCulture:SetCulturalProgress(civicId, playerCulture:GetCultureCost(civicId));
end);
Events.WonderCompleted.Add(function (x, y, buildingId, playerId, cityId, percentComplete, unknown)
	local player = Players[playerId];
	local buildingInfo = GameInfo.Buildings[buildingId];
	local remains = player:GetProperty(FREE_CIVIC_KEY) or 0;
	if buildingInfo.BuildingType == 'BUILDING_BOLSHOI_THEATRE' then
		player:SetProperty(FREE_CIVIC_KEY, remains + 2);
	end
end);

-- Horses and Iron within 6 tiles
local PALACE_INDEX = GameInfo.Buildings['BUILDING_PALACE'].Index;
function StrategicCityAddedToMap (playerId, cityId, x, y)
	local player = Players[playerId];
	if not player:IsMajor() then
		return;
	end
	local city = CityManager.GetCity(playerId, cityId);
	if city:GetBuildings():HasBuilding(PALACE_INDEX) then
		print("开始生成保底战略资源", playerId)
		for row in GameInfo.HD_GuaranteedStrategicResources() do
			local resourceInfo = GameInfo.Resources[row.ResourceType];
			local plots = Map.GetNeighborPlots(x, y, row.Distance);
			local hasResource = false;
			local availablePlots = {};
			for _, plot in ipairs(plots) do
				if plot:GetResourceType() == resourceInfo.Index then
					hasResource = true;
					break;
				end
				if plot:GetOwner() == -1 and ResourceBuilder.CanHaveResource(plot, resourceInfo.Index) then
					local distance = Map.GetPlotDistance(x, y, plot:GetX(), plot:GetY());
					local adjResources = ResourceBuilder.GetAdjacentResourceCount(plot);
					local s = distance * 60 - adjResources * 10 + TerrainBuilder.GetRandomNumber(10, "Guaranteed Strategic Resource Adjust")
					table.insert(availablePlots, {plotId = plot:GetIndex(), score = s});
				end
			end
			if (not hasResource) and (#availablePlots > 0) then
				table.sort(availablePlots, function(a, b) return a.score > b.score; end);
				local plotId = availablePlots[1].plotId;
				local plot = Map.GetPlotByIndex(plotId);
				ResourceBuilder.SetResourceType(plot, resourceInfo.Index, 1);
				print('生成保底战略资源', plot:GetX(), plot:GetY(), resourceInfo.ResourceType)
			end
		end
	end
end

-- Free Tech张衡
-- local FREE_TECH_KEY_ZH = 'HD_FREE_TECH_ZH';
-- GameEvents.HD_FreeTechSwitchZH.Add(function (playerId, techId)
-- 	local player = Players[playerId];
-- 	local remains = player:GetProperty(FREE_TECH_KEY_ZH) or 0;
-- 	local playerTech = player:GetTechs();
-- 	
-- 	player:SetProperty(FREE_TECH_KEY_ZH, remains - 1);
-- 	playerTech:SetResearchProgress(techId, playerTech:GetResearchCost(techId));
-- end);

-- GameEvents.GreatPersonHandleActivation.Add(function (unitOwner, unitId, greatPersonIndividualId)
-- 	local player = Players[unitOwner];
-- 	local ZHANGHENG_INDEX = GameInfo.GreatPersonIndividuals['GREAT_PERSON_INDIVIDUAL_ZHANG_HENG'].Index;
-- 	local remains = player:GetProperty(FREE_TECH_KEY_ZH) or 0;
-- 	if greatPersonIndividualId == ZHANGHENG_INDEX then
-- 		player:SetProperty(FREE_TECH_KEY_ZH, remains + 1);
-- 	end
-- end);

-- Free Tech霍普
local FREE_TECH_KEY_HP = 'HD_FREE_TECH_HP';
GameEvents.HD_FreeTechSwitchHP.Add(function (playerId, techId)
	local player = Players[playerId];
	local remains = player:GetProperty(FREE_TECH_KEY_HP) or 0;
	local playerTech = player:GetTechs();
	
	player:SetProperty(FREE_TECH_KEY_HP, remains - 1);
	playerTech:SetResearchProgress(techId, playerTech:GetResearchCost(techId));
end);

GameEvents.GreatPersonHandleActivation.Add(function (unitOwner, unitId, greatPersonIndividualId)
	local player = Players[unitOwner];
	local HOPPER_INDEX = GameInfo.GreatPersonIndividuals['GREAT_PERSON_INDIVIDUAL_GRACE_HOPPER'].Index;
	local remains = player:GetProperty(FREE_TECH_KEY_HP) or 0;
	if greatPersonIndividualId == HOPPER_INDEX then
		player:SetProperty(FREE_TECH_KEY_HP, remains + 2);
	end
end);

-- Free Civic李斯
GameEvents.GreatPersonHandleActivation.Add(function (unitOwner, unitId, greatPersonIndividualId)
	local player = Players[unitOwner];
	local LISI_INDEX = GameInfo.GreatPersonIndividuals['GREAT_PERSON_INDIVIDUAL_LISI'].Index;
	local remains = player:GetProperty(FREE_CIVIC_KEY) or 0;
	if greatPersonIndividualId == LISI_INDEX then
		player:SetProperty(FREE_CIVIC_KEY, remains + 1);
	end
end);

-- 随机部落村庄奖励
local goodyHutRewards = {};
function initGoodyHutReward()
	local totalWeight = 0;
	for row in GameInfo.HD_RandomGoodyHutReward() do
		totalWeight = totalWeight + row.Weight;
	end

	for row in GameInfo.HD_RandomGoodyHutReward() do
		table.insert(goodyHutRewards, {
      GoodyHut = row.GoodyHut,
      SubTypeGoodyHut = row.SubTypeGoodyHut,
			Weight = row.Weight / totalWeight,
			ModifierId = row.ModifierId,
			Turn = row.Turn
    })
		print(
			"initGoodyHutReward",
			row.GoodyHut,
			row.SubTypeGoodyHut,
			row.ModifierId,
			row.Turn
		)
	end
end
initGoodyHutReward();

local m_PendingGoodyHut = nil;
local firstCivicBoosted = nil;
local firstTechBoosted = nil;
local NOTIFICATION_DISCOVER_GOODY_HUT_HASH = GameInfo.Types['NOTIFICATION_DISCOVER_GOODY_HUT'].Hash;

function GetRandomGoodyHutReward(playerId, title, notificationHash, extra)
	local player = Players[playerId]
	if player:IsMajor() then
		print('GetRandomGoodyHutReward', playerId)
		local iRandom = Game.GetRandNum(#goodyHutRewards, "GetRandomGoodyHutReward_" .. playerId) + 1
		local reward = goodyHutRewards[iRandom]
		local checkResult = CheckRewardValidity(player, reward, extra)
		if checkResult ~= 0 then
			m_PendingGoodyHut = {
				Title = title,
				NotificationHash = notificationHash or NOTIFICATION_DISCOVER_GOODY_HUT_HASH,
				ModifierId = reward.ModifierId
			};

			-- 应用奖励
			if checkResult == 1 then
				local capital = player:GetCities():GetCapitalCity();
				capital:AttachModifierByID(reward.ModifierId)
			elseif checkResult == 2 then
				player:AttachModifierByID(reward.ModifierId)
			end

			-- 奖励通知
			if reward.SubTypeGoodyHut ~= 'GOODYHUT_ONE_CIVIC_BOOST'
				and reward.SubTypeGoodyHut ~= 'GOODYHUT_TWO_CIVIC_BOOSTS'
				and reward.SubTypeGoodyHut ~= 'GOODYHUT_ONE_TECH_BOOST'
				and reward.SubTypeGoodyHut ~= 'GOODYHUT_TWO_TECH_BOOSTS'
				and reward.SubTypeGoodyHut ~= 'GOODYHUT_RESOURCES' then
					local msg = GetGoodyHutRewardDescription(reward.ModifierId)
					SendRewardNotification(playerId, notificationHash, Locale.Lookup(title), msg);
			end
			
			print("GetRandomGoodyHutReward", "应用奖励", reward.ModifierId)
		else
			-- 重新随机
			print("GetRandomGoodyHutReward", "重新随机")
			GetRandomGoodyHutReward(playerId, title, notificationHash, extra)
		end
	end
end
GameEvents.GetRandomGoodyHutReward.Add(GetRandomGoodyHutReward)

function SendRewardNotification(playerId, notificationType, message, summary, separator)
	local data = {};
	data[ParameterTypes.MESSAGE] = message;
	data[ParameterTypes.SUMMARY] = summary;
	local separatorString = "; "
	if separator ~= nil then
		separatorString = separator
	end

	local notifyIdList = NotificationManager.GetList(playerId);
	if(notifyIdList ~= nil) then
		for _, notifyId in pairs(notifyIdList) do
			local notification = NotificationManager.Find(playerId, notifyId);
			if notification ~= nil
				and notification:GetType() == notificationType
				and not notification:IsDismissed()
				and notification:GetValue(ParameterTypes.MESSAGE) == message then
					local preValue = notification:GetValue(ParameterTypes.SUMMARY);
					print('SendRewardNotification preValue', preValue)
					if preValue ~= nil then
						NotificationManager.Dismiss(playerId, notifyId);
						data[ParameterTypes.SUMMARY] = preValue .. separatorString .. data[ParameterTypes.SUMMARY]
					end
			end
		end
	end

	NotificationManager.SendNotification(playerId, notificationType, data);
end
Utils.SendMergableNotification = SendRewardNotification;

local ANIMAL_HUSBANDRY_INDEX = GameInfo.Technologies['TECH_ANIMAL_HUSBANDRY'].Index
local BRONZE_WORKING_INDEX = GameInfo.Technologies['TECH_BRONZE_WORKING'].Index
local ALCHEMY_HD_INDEX = GameInfo.Technologies['TECH_ALCHEMY_HD'].Index

-- Params:
--  player: table of player
--  reward: table of reward
-- 	extra: table of extra settings
-- Returns:
--	0: false
--	1: attach to capital
--	2: attach to player
function CheckRewardValidity(player, reward, extra)
	-- 判断回合数
	local turn = Game.GetCurrentGameTurn()
	if reward.Turn > turn then
		print("GetRandomGoodyHutReward", "回合数不合法", turn, reward.ModifierId)
		return 0;
	else
		local modifierId = reward.ModifierId;
		-- 根据额外设置，判断是否生效
		if extra ~= nil then
			print("GetRandomGoodyHutReward", "检查额外信息")
			if extra.ContinuousTriggered then
				print("GetRandomGoodyHutReward", "循环中触发")
				if reward.SubTypeGoodyHut == 'GOODYHUT_ONE_CIVIC_BOOST'
				or reward.SubTypeGoodyHut == 'GOODYHUT_TWO_CIVIC_BOOSTS'
				or reward.SubTypeGoodyHut == 'GOODYHUT_ONE_TECH_BOOST'
				or reward.SubTypeGoodyHut == 'GOODYHUT_TWO_TECH_BOOSTS'
				or reward.SubTypeGoodyHut == 'GOODYHUT_RESOURCES' then
					-- 在循环中多次连续触发该接口，这些Modifier会导致通知丢失，所以跳过
					print("GetRandomGoodyHutReward", "循环中不可用的效果", reward.ModifierId)
					return 0;
				end
			end
		end
		

		-- 根据生效对象，判断是否生效
		if modifierId == 'GOODY_MILITARY_GRANT_SCOUT' or modifierId == 'GOODY_SURVIVORS_ADD_POPULATION' or modifierId == 'GOODY_SURVIVORS_GRANT_BUILDER' or
				modifierId == 'GOODY_CULTURE_GRANT_ONE_RELIC' or modifierId == 'GOODY_SURVIVORS_GRANT_TRADER' then
			-- 首都类 Modifer
			local capital = player:GetCities():GetCapitalCity();
			if capital == nil then
				print("GetRandomGoodyHutReward", "未检测到首都", reward.ModifierId)
				return 0;
			else
				if modifierId == 'GOODY_SURVIVORS_GRANT_TRADER' then
					-- 检测商队容量
					local capacity = player:GetTrade():GetOutgoingRouteCapacity()
					local num = Utils.GetPlayerActiveTradeRoutesNum(player:GetID())
					if capacity <= num then
						print("GetRandomGoodyHutReward", "商队容量不足: " .. num .. "/" .. capacity, reward.ModifierId)
						return 0;
					end
				end
			end
			return 1;
		else
			-- 玩家类 Modifer
			if modifierId == 'GOODY_MILITARY_ADJUST_STRATEGIC_RESOURCES' then
				local playerTechs = player:GetTechs()
				if not (playerTechs:HasTech(ANIMAL_HUSBANDRY_INDEX) or playerTechs:HasTech(BRONZE_WORKING_INDEX) or playerTechs:HasTech(ALCHEMY_HD_INDEX)) then
					print("GetRandomGoodyHutReward", "未解锁战略", reward.ModifierId)
					return 0;
				end
			end
			return 2;
		end
	end
end

function GetGoodyHutRewardDescription(modifierId)
	local infoText = Locale.Lookup("LOC_GAMESUMMARY_UNKNOWN");
	-- Type GOODYHUT_CULTURE
	if modifierId == "GOODY_CULTURE_GRANT_ONE_RELIC" then
		infoText = "[ICON_GreatWork_Relic]" .. Locale.Lookup("LOC_GREAT_WORK_OBJECT_RELIC_NAME");
	-- Type GOODYHUT_GOLD
	elseif modifierId == "GOODY_GOLD_LARGE_MODIFIER" 
		or modifierId == "GOODY_GOLD_MEDIUM_MODIFIER" 
		or modifierId == "GOODY_GOLD_SMALL_MODIFIER" then
			local amount = Utils.GetModifierAmount(modifierId);
			infoText = amount .. "[ICON_Gold]";
	-- Type GOODYHUT_FAITH
	elseif modifierId == "GOODY_FAITH_LARGE_MODIFIER" 
		or modifierId == "GOODY_FAITH_MEDIUM_MODIFIER" 
		or modifierId == "GOODY_FAITH_SMALL_MODIFIER" then
			local amount = Utils.GetModifierAmount(modifierId);
			infoText = amount .. "[ICON_Faith]";
	-- Type GOODYHUT_MILITARY
	elseif modifierId == "GOODY_MILITARY_GRANT_SCOUT" then
		infoText = Locale.Lookup("LOC_UNIT_SCOUT_NAME");
	elseif modifierId == "GOODY_MILITARY_GRANT_UPGRADE" then
		infoText = Locale.Lookup("LOC_UNITOPERATION_UPGRADE_DESCRIPTION");
	elseif modifierId == "GOODY_MILITARY_GRANT_EXPERIENCE" then
		infoText = Locale.Lookup("LOC_HUD_UNIT_PANEL_XP");
	elseif modifierId == "GOODY_MILITARY_HEAL" then
		infoText = Locale.Lookup("LOC_TECH_FILTER_HEALTH"); -- Not ideal but ok.
	-- Type GOODYHUT_SURVIVORS
	elseif modifierId == "GOODY_SURVIVORS_ADD_POPULATION" then
		infoText = "[ICON_Citizen]" .. Locale.Lookup("LOC_CIVINFO_POPULATION");
	elseif modifierId == "GOODY_SURVIVORS_GRANT_BUILDER" then
		infoText = Locale.Lookup("LOC_UNIT_BUILDER_NAME");
	elseif modifierId == "GOODY_SURVIVORS_GRANT_TRADER" then
		infoText = Locale.Lookup("LOC_UNIT_TRADER_NAME");
	elseif modifierId == "GOODY_SURVIVORS_GRANT_SETTLER" then
		infoText = Locale.Lookup("LOC_UNIT_SETTLER_NAME");
	-- Type GOODYHUT_DIPLOMACY
	elseif modifierId == "GOODY_DIPLOMACY_GRANT_GOVERNOR_TITLE" then
		infoText = "[Icon_Governor]" .. Locale.Lookup("LOC_ACTION_PANEL_GOVERNOR_OPPORTUNITY");
	elseif modifierId == "GOODY_DIPLOMACY_GRANT_ENVOY" then
		infoText = "[ICON_Envoy]" .. Locale.Lookup("LOC_ENVOY_NAME");
	elseif modifierId == "GOODY_DIPLOMACY_GRANT_FAVOR" then
		infoText = "[ICON_Favor]" .. Locale.Lookup("LOC_DIPLOMATIC_FAVOR_NAME");
	end

	return infoText
end

function OnCivicBoostTriggered(playerId, boostedCivic)
	if playerId ~= Game.GetLocalPlayer() then
		return;
	end
	local pendingHut = m_PendingGoodyHut;
	if pendingHut ~= nil then
		local modifierId = pendingHut.ModifierId;
		local title = pendingHut.Title;
		local notificationHash = pendingHut.NotificationHash;
		local msg;
		if modifierId == "GOODY_CULTURE_GRANT_ONE_CIVIC_BOOST" then
			local civicName = GameInfo.Civics[boostedCivic].Name;
			msg = "[ICON_CivicBoosted]" .. Locale.Lookup(civicName);
			SendRewardNotification(playerId, notificationHash, Locale.Lookup(title), msg);
			m_PendingGoodyHut = nil;
		elseif modifierId == "GOODY_CULTURE_GRANT_TWO_CIVIC_BOOSTS" then
			if firstCivicBoosted == nil then
				firstCivicBoosted = boostedCivic;
			else
				local civicName = Locale.Lookup(GameInfo.Civics[boostedCivic].Name);
				local firstCivicName = Locale.Lookup(GameInfo.Civics[firstCivicBoosted].Name);
				msg = "[ICON_CivicBoosted]" .. firstCivicName .. "&" .. civicName;
				firstCivicBoosted = nil;
				m_PendingGoodyHut = nil;
				SendRewardNotification(playerId, notificationHash, Locale.Lookup(title), msg);
			end
		end
	end
end

function OnTechBoostTriggered(playerId, boostedTech)
	if playerId ~= Game.GetLocalPlayer() then
		return;
	end
	local pendingHut = m_PendingGoodyHut;
	if pendingHut ~= nil then
		local modifierId = pendingHut.ModifierId;
		local title = pendingHut.Title;
		local notificationHash = pendingHut.NotificationHash;
		local msg;
		if modifierId == "GOODY_SCIENCE_GRANT_ONE_TECH_BOOST" then
			local techName = GameInfo.Technologies[boostedTech].Name;
			msg = "[ICON_TechBoosted]" .. Locale.Lookup(techName);
			SendRewardNotification(playerId, notificationHash, Locale.Lookup(title), msg);
			m_PendingGoodyHut = nil;
		elseif modifierId == "GOODY_SCIENCE_GRANT_TWO_TECH_BOOSTS" then
			if firstTechBoosted == nil then
				firstTechBoosted = boostedTech;
			else
				local techName = Locale.Lookup(GameInfo.Technologies[boostedTech].Name);
				local firstTechName = Locale.Lookup(GameInfo.Technologies[firstTechBoosted].Name);
				msg = "[ICON_TechBoosted]" .. firstTechName .. "&" .. techName;
				firstTechBoosted = nil;
				m_PendingGoodyHut = nil;
				SendRewardNotification(playerId, notificationHash, Locale.Lookup(title), msg);
			end
		end
	end
end

function OnPlayerResourceChanged(playerId, resourceId)
	if playerId ~= Game.GetLocalPlayer() then
		return;
	end
	local pendingHut = m_PendingGoodyHut;
	if pendingHut ~= nil then
		local modifierId = pendingHut.ModifierId;
		local title = pendingHut.Title;
		local notificationHash = pendingHut.NotificationHash;
		local msg;
		if modifierId == "GOODY_MILITARY_ADJUST_STRATEGIC_RESOURCES" then
			local resourceName = GameInfo.Resources[resourceId].Name;
			local amount = Utils.GetModifierAmount(modifierId);
			msg = amount .. Locale.Lookup(resourceName);
			SendRewardNotification(playerId, notificationHash, Locale.Lookup(title), msg);
			m_PendingGoodyHut = nil;
		end
	end
end

Events.CivicBoostTriggered.Add(OnCivicBoostTriggered);
Events.TechBoostTriggered.Add(OnTechBoostTriggered);
Events.PlayerResourceChanged.Add(OnPlayerResourceChanged);
--------------------------------------------------------------
-- 城市记录改良数量
local improvementNeedCountList = {}
function initImprovementNeedCountList()
	for row in GameInfo.ImprovementsNeedCount_HD() do
		table.insert(improvementNeedCountList, {
			ImprovementType = row.ImprovementType
		})
	end
	Utils.improvementNeedCountList = improvementNeedCountList
end
initImprovementNeedCountList()

-- function CityImprovementAddedToMap(x, y, improvementId, playerId, resourceId, isPillaged, isWorked)
-- 	for _, info in ipairs(improvementNeedCountList) do
-- 		if info.ImprovementIndex == improvementId then
-- 			local plot = Map.GetPlot(x, y);
-- 			local city = Cities.GetPlotPurchaseCity(plot);
-- 			local amount = city:GetProperty(City_Improvement_Num_Tag .. improvementId) or 0;
-- 			city:SetProperty(City_Improvement_Num_Tag .. improvementId, amount + 1)
-- 			plot:SetProperty(City_Improvement_Num_Tag .. improvementId, 1)
-- 			print("CityImprovementAddedToMap", improvementId, amount + 1)
-- 			return
-- 		end
-- 	end
-- end

-- function CityImprovementRemovedFromMap(x, y, playerId)
-- 	local plot = Map.GetPlot(x, y);
-- 	local city = Cities.GetPlotPurchaseCity(plot);
-- 	for _, info in ipairs(improvementNeedCountList) do
-- 		local improvementId = info.ImprovementIndex
-- 		if plot:GetProperty(City_Improvement_Num_Tag .. improvementId) == 1 then
-- 			plot:SetProperty(City_Improvement_Num_Tag .. improvementId, 0)
-- 			if city ~= nil then
-- 				local amount = city:GetProperty(City_Improvement_Num_Tag .. improvementId) or 0;
-- 				city:SetProperty(City_Improvement_Num_Tag .. improvementId, amount - 1)
-- 				print("CityImprovementRemovedFromMap", improvementId, amount - 1)
-- 			end
-- 			return
-- 		end
-- 	end
-- end

-- 记录未建成奇观
local WONDER_INDEX = GameInfo.Districts['DISTRICT_WONDER'].Index;
local UNCOMPLETED_WONDER_TAG = 'HD_UNCOMPLETED_WONDER'
function UncompletedWonderRecord(playerId, districtId, x, y)
	if districtId == WONDER_INDEX then
		local plot = Map.GetPlot(x, y);
		local city = Cities.GetPlotPurchaseCity(plot);
		local current = city:GetBuildQueue():CurrentlyBuilding();
		print("UncompletedWonderRecord 落奇观", current)

		local buildingInfo = GameInfo.Buildings[current];
		if buildingInfo and buildingInfo.IsWonder then
			plot:SetProperty(UNCOMPLETED_WONDER_TAG, buildingInfo.Index)
		end
	end
end
GameEvents.OnDistrictConstructed.Add(UncompletedWonderRecord)

-- 摧毁蛮族哨站
function ClearBarbarianCamp(x, y, ownerId)
	-- 摧毁者
	local playerId = -1

	-- 判断是否是蛮族哨站
	local owner = Players[ownerId]
  if owner ~= nil and owner:IsBarbarian() then
		local units = Units.GetUnitsInPlot(x, y)
    if units ~= nil then
			for _, unit in ipairs(units) do
				local unitInfo = GameInfo.Units[unit:GetType()];
				local unitOwnerId = unit:GetOwner();
				local unitOwner = Players[unitOwnerId]
				-- 排除非玩家单位、空军、商人、宗教单位、间谍
				if unitOwner
				and (unitOwner:IsMajor() or Utils.PlayerIsMinor(unitOwnerId))
				and unitInfo
				and unitInfo.Domain ~= 'DOMAIN_AIR'
				and not unitInfo.MakeTradeRoute
				and unitInfo.ReligiousStrength == 0
				and not unitInfo.Spy then
        	playerId = unitOwnerId;
					break;
				end
      end
		end

		-- 唤起回调
		if playerId ~= -1 then
			print("蛮族哨站被已知单位摧毁", x, y, playerId)
			GameEvents.HDClearBarbarianCamp.Call(x, y, playerId)
		else
			local plot = Map.GetPlot(x, y);
			if plot then
				print("蛮族哨站被未知单位摧毁", x, y)
				Game:SetProperty('HD_ClearBarbarianCamp_Turn', Game.GetCurrentGameTurn());
				Game:SetProperty('HD_ClearBarbarianCamp_Index', plot:GetIndex());
			end
		end
	end
end

-- 排除劫掠改良的情况
function ClearBarbarianCampOnPillage(playerId, unitId, improvementId, buildingId, districtId, plotId)
	Game:SetProperty('HD_ClearBarbarianCamp_Turn', -1);
	Game:SetProperty('HD_ClearBarbarianCamp_Index', -1);
end
GameEvents.OnPillage.Add(ClearBarbarianCampOnPillage)

-- 沿岸扫荡 摧毁蛮族哨站
local UNITOPERATION_COASTAL_RAID_HASH = GameInfo.UnitOperations['UNITOPERATION_COASTAL_RAID'].Hash
function ClearBarbarianCampUnitOperationDeactivated(playerId, unitId, operationHash)
	if operationHash == UNITOPERATION_COASTAL_RAID_HASH then
		-- print("沿岸扫荡", playerId, unitId)
		local unit = UnitManager.GetUnit(playerId, unitId)
		if unit then
			for direction = 0, 5 do
				local adjacentPlot = Map.GetAdjacentPlot(unit:GetX(), unit:GetY(), direction);
				if adjacentPlot
				and Game:GetProperty('HD_ClearBarbarianCamp_Turn') == Game.GetCurrentGameTurn()
				and Game:GetProperty('HD_ClearBarbarianCamp_Index') == adjacentPlot:GetIndex() then
					print("沿岸扫荡摧毁蛮族哨站", adjacentPlot:GetX(), adjacentPlot:GetY())
					Game:SetProperty('HD_ClearBarbarianCamp_Turn', -1);
					Game:SetProperty('HD_ClearBarbarianCamp_Index', -1);
					GameEvents.HDClearBarbarianCamp.Call(adjacentPlot:GetX(), adjacentPlot:GetY(), playerId)
				end
			end
		end
	end
end
Events.UnitOperationDeactivated.Add(ClearBarbarianCampUnitOperationDeactivated)

-- 移除单位
function HDDestroyUnit(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit then
		Players[playerId]:GetUnits():Destroy(unit);
	end
end
GameEvents.HDDestroyUnit.Add(HDDestroyUnit)

--------------------------------------------------------------
-- Initialize
function initialize()
	Events.CityAddedToMap.Add(StrategicCityAddedToMap);
	-- Events.ImprovementAddedToMap.Add(CityImprovementAddedToMap);
	-- Events.ImprovementRemovedFromMap.Add(CityImprovementRemovedFromMap);
	Events.ImprovementRemovedFromMap.Add(ClearBarbarianCamp);
end
Events.LoadGameViewStateDone.Add(initialize);