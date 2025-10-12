if ExposedMembers.DLHD == nil then
  ExposedMembers.DLHD = {};
end
Utils = ExposedMembers.DLHD.Utils;

-- 获取城市建造队列项目花费
function GetCityCurrentBuildQueueCost(playerId, cityId, type, objectIndex)
	local city = CityManager.GetCity(playerId, cityId);
  local cost = 0
  if (type == 0) then
    cost = city:GetBuildQueue():GetBuildingCost(objectIndex)
  elseif (type == 1) then
    cost = city:GetBuildQueue():GetDistrictCost(objectIndex)
  elseif (type == 2) then
    cost = city:GetBuildQueue():GetUnitCost(objectIndex)
  elseif (type == 3) then
    cost = city:GetBuildQueue():GetProjectCost(objectIndex)
  end

	return cost
end
Utils.GetCityCurrentBuildQueueCost = GetCityCurrentBuildQueueCost

-- 获取城市建造队列项目进度
function GetCityCurrentBuildQueueProgress(playerId, cityId, type, objectIndex)
	local city = CityManager.GetCity(playerId, cityId);
  local process = 0
  if (type == 0) then
    process = city:GetBuildQueue():GetBuildingProgress(objectIndex)
  elseif (type == 1) then
    process = city:GetBuildQueue():GetDistrictProgress(objectIndex)
  elseif (type == 2) then
    process = city:GetBuildQueue():GetUnitProgress(objectIndex)
  elseif (type == 3) then
    process = city:GetBuildQueue():GetProjectProgress(objectIndex)
  end

	return process
end
Utils.GetCityCurrentBuildQueueProgress = GetCityCurrentBuildQueueProgress

-- 获取圣城ID
function GetHolyCityID(playerId)
  local player = Players[playerId]
  if player ~= nil then
    local holyCity = CityManager.GetCity(player:GetReligion():GetHolyCityID());
    if holyCity ~= nil then
      return holyCity:GetID()
    else
      return nil
    end
  else
    return nil
  end
end
Utils.GetHolyCityID = GetHolyCityID

-- 判定城市是否是圣城
function IsHolyCity(playerId, cityId)
  local holyCityId = GetHolyCityID(playerId)
  if holyCityId ~= nil then
    return holyCityId == cityId
  else
    return false
  end
end
Utils.IsHolyCity = IsHolyCity

-- 获取同盟等级
function GetAllianceLevelBetweenPlayers(playerId, alliesId)
  local player = Players[playerId]
  local playerDiplomacy = player:GetDiplomacy()
  local level = playerDiplomacy:GetAllianceLevel(alliesId)

  return level
end
Utils.GetAllianceLevelBetweenPlayers = GetAllianceLevelBetweenPlayers

-- 获取同盟类型
function GetAllianceTypeBetweenPlayers(playerId, alliesId)
  return Players[playerId]:GetDiplomacy():GetAllianceType(alliesId)
end
Utils.GetAllianceTypeBetweenPlayers = GetAllianceTypeBetweenPlayers

-- 获取玩家激活着力点
local COMMEMORATION_HAS_TAG = 'HD_COMMEMORATION_HAS_';
function PlayerHasCommemoration(playerId, CommemorationId)
  local player = Players[playerId]

  -- 排除非主要文明
  if not player or not player:IsMajor() then
    return false;
  end
  
  -- 从 Player Property 读取
  if player:GetProperty(COMMEMORATION_HAS_TAG .. CommemorationId) == 1 then
    print('PlayerHasCommemoration 从 Player Property 读取', playerId, CommemorationId)
    return true;
  end

  local activeCommemorations = Game.GetEras():GetPlayerActiveCommemorations(playerId);
  for i, activeCommemoration in ipairs(activeCommemorations) do
    if CommemorationId == activeCommemoration then
      return true
    end
  end

  return false
end
Utils.PlayerHasCommemoration = PlayerHasCommemoration

-- 判断玩家时代
function PlayerHasHeroicGoldenAge(playerId)
  return Game.GetEras():HasHeroicGoldenAge(playerId);
end
Utils.PlayerHasHeroicGoldenAge = PlayerHasHeroicGoldenAge

function PlayerHasGoldenAge(playerId)
  return Game.GetEras():HasGoldenAge(playerId);
end
Utils.PlayerHasGoldenAge = PlayerHasGoldenAge

function PlayerHasDarkAge(playerId)
  return Game.GetEras():HasDarkAge(playerId);
end
Utils.PlayerHasDarkAge = PlayerHasDarkAge

-- 资源玩家是否可见
function IsResourceVisible(playerId, resourceHash)
  local player = Players[playerId]
  if player ~= nil then
    return player:GetResources():IsResourceVisible(resourceHash);
  end
end
Utils.IsResourceVisible = IsResourceVisible

-- 获取地标名称
function GetPlotTerritoryName(x, y)
  local plotIndex = Map.GetPlotIndex(x, y);
  local territory = Territories.GetTerritoryAt(plotIndex);

  if territory ~= nil then
    local TerritoryName = territory:GetName();
    -- print('GetPlotTerritoryName', TerritoryName)
    return TerritoryName
  end
end
Utils.GetPlotTerritoryName = GetPlotTerritoryName

-- 获取海洋名字(附带判断是否是海洋单元格)
local COAST_INDEX = GameInfo.Terrains['TERRAIN_COAST'].Index;
local OCEAN_INDEX = GameInfo.Terrains['TERRAIN_OCEAN'].Index;
function GetPlotSeaName(x, y)
  local name = nil;
  local plot = Map.GetPlot(x, y);
  local terrainId = plot:GetTerrainType();
  if terrainId == COAST_INDEX or terrainId == OCEAN_INDEX then
    name = GetPlotTerritoryName(x, y);
  end
  return name
end
Utils.GetPlotSeaName = GetPlotSeaName

-- 判断是否是首都
function IsPlayerCapital(playerId, cityId)
  local city = CityManager.GetCity(playerId, cityId)
  if city ~= nil then
    return city:IsCapital();
  else
    return false;
  end
end
Utils.IsPlayerCapital = IsPlayerCapital

-- 获取伟人点
function GetGreatPeoplePointsPerTurn(playerId, classId)
  local player = Players[playerId];
  if player and player:IsMajor() then
    return player:GetGreatPeoplePoints():GetPointsPerTurn(classId)
  else
    return 0
  end
end
Utils.GetGreatPeoplePointsPerTurn = GetGreatPeoplePointsPerTurn

-- 根据 Index 获取巨作 Type
function GetGreatWorkTypeFromIndex(playerId, cityId, greatWorkIndex)
  local city = CityManager.GetCity(playerId, cityId)
  if city then
    local cityBuildings = city:GetBuildings();
    if cityBuildings then
      return cityBuildings:GetGreatWorkTypeFromIndex(greatWorkIndex)
    end
  end
  return -1
end
Utils.GetGreatWorkTypeFromIndex = GetGreatWorkTypeFromIndex

-- 判断是否是城邦
function PlayerIsMinor(playerId)
  local player = Players[playerId]
  if player then
    return player:IsMinor()
  else
    return false
  end
end
Utils.PlayerIsMinor = PlayerIsMinor

-- 获取激活商队数量
function GetPlayerActiveTradeRoutesNum(playerId)
  local player = Players[playerId]
  if player then
    return player:GetTrade():GetNumOutgoingRoutes()
  else
    return 0
  end
end
Utils.GetPlayerActiveTradeRoutesNum = GetPlayerActiveTradeRoutesNum

-- 获取城市商路信息
function GetCityIncomingRoutes(playerId, cityId)
  local city = CityManager.GetCity(playerId, cityId)
  if city then
    return city:GetTrade():GetIncomingRoutes();
  end
end
Utils.GetCityIncomingRoutes = GetCityIncomingRoutes

-- 获取城市单元格列表
function GetCityPlots(playerId, cityId)
  local city = CityManager.GetCity(playerId, cityId)
  if city then
    return Map.GetCityPlots():GetPurchasedPlots(city)
  end
end
Utils.GetCityPlots = GetCityPlots

-- 城市购买单元格
function CityPurchasePlot(playerId, cityId, x, y)
  local city = CityManager.GetCity(playerId, cityId)
  if city then
    HD_UI_SetPlotOwner(playerId, nil, x, y)

    local tParameters = {};
    tParameters[CityCommandTypes.PARAM_PLOT_PURCHASE] = UI.GetInterfaceModeParameter(CityCommandTypes.PARAM_PLOT_PURCHASE);
    tParameters[CityCommandTypes.PARAM_X] = x;
    tParameters[CityCommandTypes.PARAM_Y] = y;

    if CityManager.CanStartCommand(city, CityCommandTypes.PURCHASE, tParameters) then
      print('CityPurchasePlot 预添加金币')
      HD_UI_ChangeGoldBalance(playerId, 500)
      print('CityPurchasePlot purchase')
			CityManager.RequestCommand(city, CityCommandTypes.PURCHASE, tParameters);
      HD_UI_SetPurchasedPlotProperty(playerId, x, y, 1)
    else
      print('CityPurchasePlot cannot purchase')
		end
  end
end
Utils.CityPurchasePlot = CityPurchasePlot

--更改单元格所有者的函数，代码来自IthildinX
function HD_UI_SetPlotOwner(playerId, cityId, x, y)
	local kPara = {}
	kPara.X = x
	kPara.Y = y
	kPara.ID = cityId
	kPara.OnStart = 'HDSetPlotOwner'
	UI.RequestPlayerOperation(playerId, PlayerOperations.EXECUTE_SCRIPT, kPara)
end

--更改国库金币的函数，代码来自IthildinX
function HD_UI_ChangeGoldBalance(playerId, amount)
	local kPara = {}
	kPara.Gold = amount
	kPara.OnStart = 'HDChangeGoldBalance'
	UI.RequestPlayerOperation(playerId, PlayerOperations.EXECUTE_SCRIPT, kPara)
end

--SetProperty的函数，代码来自IthildinX
function HD_UI_SetPurchasedPlotProperty(playerId, x, y, Property)
	local kPara = {}
	kPara.X = x
	kPara.Y = y
	kPara.Property = Property
	kPara.OnStart = 'HDSetPurchasedPlotProperty'
	UI.RequestPlayerOperation(playerId, PlayerOperations.EXECUTE_SCRIPT, kPara)
end

-- 获取单位剩余移动力（包含小数）
function GetUnitMovesRemaining(playerId, unitId)
  local unit = UnitManager.GetUnit(playerId, unitId);
  if unit then
    return unit:GetMovesRemaining();
  end
  return 0;
end
Utils.GetUnitMovesRemaining = GetUnitMovesRemaining

-- 获取玩家时代分
function GetPlayerCurrentScore(playerId)
  local player = Players[playerId]
  if player ~= nil then
    return Game.GetEras():GetPlayerCurrentScore(playerId);
  end
  return 0;
end
Utils.GetPlayerCurrentScore = GetPlayerCurrentScore

-- 获取城邦当前任务
function GetCitystateQuestId(playerId, citystateId)
  local questsManager = Game.GetQuestsManager();
  if questsManager ~= nil then
    for questInfo in GameInfo.Quests() do
      if questsManager:HasActiveQuestFromPlayer(playerId, citystateId, questInfo.Index) then
        return questInfo.Index;
      end
    end
  end
  return -1;
end
Utils.GetCitystateQuestId = GetCitystateQuestId

-- 判断是否是原始首都
function IsOriginalCapital(playerId, cityId)
  local city = CityManager.GetCity(playerId, cityId)
  if city then
    return city:IsOriginalCapital();
  else
    return false;
  end
end
Utils.IsOriginalCapital = IsOriginalCapital

-- 获得间谍任务
function GetSpyOperation(playerId, unitId)
  local unit = UnitManager.GetUnit(playerId, unitId);
  if unit then
    return unit:GetSpyOperation();
  end
  return -1;
end
Utils.GetSpyOperation = GetSpyOperation;

local UNITOPERATION_SPY_LISTENING_POST_INDEX = GameInfo.UnitOperations['UNITOPERATION_SPY_LISTENING_POST'].Index
local UNITOPERATION_SPY_COUNTERSPY_INDEX = GameInfo.UnitOperations['UNITOPERATION_SPY_COUNTERSPY'].Index
function IsOffensiveOperation(playerId, unitId)
  local operationId = GetSpyOperation(playerId, unitId)
  if operationId == -1
  or operationId == UNITOPERATION_SPY_LISTENING_POST_INDEX
  or operationId == UNITOPERATION_SPY_COUNTERSPY_INDEX then
    return false;
  else
    return true;
  end
end
Utils.IsOffensiveOperation = IsOffensiveOperation;

-- 获得宣友回合数
function GetDeclaredFriendshipTurn(playerId, targetId)
  local player = Players[playerId]
  if player then
    return player:GetDiplomacy():GetDeclaredFriendshipTurn(targetId);
  end
  return 0;
end
Utils.GetDeclaredFriendshipTurn = GetDeclaredFriendshipTurn;

-- 判断是否是伟人单位
function IsGreatPerson(playerId, unitId)
  local unit = UnitManager.GetUnit(playerId, unitId);
  if unit then
    local greatPerson = unit:GetGreatPerson();
    if greatPerson and greatPerson:IsGreatPerson() then
      return true;
    end
  end
  return false;
end
Utils.IsGreatPerson = IsGreatPerson;

-- 获取单元格内的建筑
function GetBuildingsInPlot(x, y)
  local plot = Map.GetPlot(x, y);
  if plot then
    local city = Cities.GetPlotPurchaseCity(plot);
    if city then
      return city:GetBuildings():GetBuildingsAtLocation(plot:GetIndex());
    end
  end
  return {};
end
Utils.GetBuildingsInPlot = GetBuildingsInPlot;

-- 获取城市建造队列
function GetCityBuildQueueAt(playerId, cityId, position)
  local city = CityManager.GetCity(playerId, cityId)
  if city then
    return city:GetBuildQueue():GetAt(position);
  end
end
Utils.GetCityBuildQueueAt = GetCityBuildQueueAt;

function GetCityBuildQueueLocationAt(playerId, cityId, position)
  local entry = GetCityBuildQueueAt(playerId, cityId, position);
  if entry ~= nil and entry.Location ~= nil then
    return entry.Location.x, entry.Location.y
  else
    return -1, -1
  end
end
Utils.GetCityBuildQueueLocationAt = GetCityBuildQueueLocationAt;

-- 获得玩家进入黄金时代的分数临界值
function GetPlayerGoldenAgeThreshold(playerId)
  return Game.GetEras():GetPlayerGoldenAgeThreshold(playerId);
end
Utils.GetPlayerGoldenAgeThreshold = GetPlayerGoldenAgeThreshold;

-- 打印已启用Mod
-- local enabledMods = GameConfiguration.GetEnabledMods();
-- for _, curMod in ipairs(enabledMods) do
--   if(not curMod.Official) then
--     print("启用Mod", curMod.Id, curMod.Title)
--   end
-- end

-- 获取区域相邻加成
function GetDistrictAdjacencyYield(playerId, districtId, yieldId)
  local player = Players[playerId];
  if player then
    local district = player:GetDistricts():FindID(districtId);
    if district then
      return district:GetAdjacencyYield(yieldId);
    end
  end
  return 0;
end
Utils.GetDistrictAdjacencyYield = GetDistrictAdjacencyYield;

-- 获取政策槽位类型
function GetPolicySlotType(playerId, slotId)
  local player = Players[playerId];
  if player then
    return player:GetCulture():GetSlotType(slotId);
  end
  return -1;
end
Utils.GetPolicySlotType = GetPolicySlotType;

-- 判断是否是AI
function PlayerIsAI(playerId)
  local player = Players[playerId]
  if player then
    return player:IsAI();
  end
  return false;
end
Utils.PlayerIsAI = PlayerIsAI;

-- 获取游戏难度
function GetGameDifficulty()
  return GameConfiguration.GetHandicapType()
end
Utils.GetGameDifficulty = GetGameDifficulty;

-- 获得宗教总信徒
function GetReligionFollowerNum(religionId)
  local num = 0;
  local majorPlayers = PlayerManager.GetAlive();

	for _, player in ipairs(majorPlayers) do
    for _, city in player:GetCities():Members() do
      local religionsInCity = city:GetReligion():GetReligionsInCity();

      for _, cityReligionData in ipairs(religionsInCity) do
        if cityReligionData.Religion == religionId then
          num = num + cityReligionData.Followers;
        end
      end
    end
  end

  return num;
end
Utils.GetReligionFollowerNum = GetReligionFollowerNum;

-- 玩家拥有的资源个数
function GetPlayerResourceAmount(playerId, resourceId)
  local player = Players[playerId];
  if player then
    return player:GetResources():GetResourceAmount(resourceId);
  end
  return 0;
end
Utils.GetPlayerResourceAmount = GetPlayerResourceAmount;

-- 用于UI端建筑界面上显示玩家拥有多少相关资源
function GetBuildingNeedPlayerResource(playerId, buildingType)
  local totalNum = 0;
  local data = {};
  local player = Players[playerId];
  local propertyKeyList = Utils.BuildingNeedDetectList['PLAYER'][buildingType]

  if player and propertyKeyList ~= nil then
    -- 需要的资源类型
    for propertyKey, list in pairs(propertyKeyList) do
      for _, classificationType in ipairs(list) do
        data[classificationType] = {
          Amount = 0,
          ResourceString = ""
        };
      end
    end

    -- 统计每种资源类型的数量
    for row in GameInfo.HD_Resource_Classification() do
      if data[row.ResourceClassificationType] ~= nil and player:GetResources():GetResourceAmount(row.ResourceType) > 0 then
        totalNum = totalNum + 1;
        data[row.ResourceClassificationType].Amount = data[row.ResourceClassificationType].Amount + 1;

        local resourceInfo = GameInfo.Resources[row.ResourceType];
        if resourceInfo then
          data[row.ResourceClassificationType].ResourceString = data[row.ResourceClassificationType].ResourceString .. " [ICON_" .. row.ResourceType .. "] " .. Locale.Lookup(resourceInfo.Name)
        end
      end
    end

  end

  return totalNum, data;
end
Utils.GetBuildingNeedPlayerResource = GetBuildingNeedPlayerResource;