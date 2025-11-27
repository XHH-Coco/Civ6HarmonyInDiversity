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
    for classificationType, resourceList in pairs(Utils.Classification_Resource_Map) do
      if data[classificationType] ~= nil then
        for _, resourceType in ipairs(resourceList) do
          if player:GetResources():GetResourceAmount(resourceType) > 0 then
            totalNum = totalNum + 1;
            data[classificationType].Amount = data[classificationType].Amount + 1;

            local resourceInfo = GameInfo.Resources[resourceType];
            if resourceInfo then
              data[classificationType].ResourceString = data[classificationType].ResourceString .. " [ICON_" .. resourceType .. "] " .. Locale.Lookup(resourceInfo.Name)
            end
          end
        end
      end
    end

  end

  return totalNum, data;
end
Utils.GetBuildingNeedPlayerResource = GetBuildingNeedPlayerResource;

-- 获取相邻加成
-- 相邻加成排序规则
-- 分类
  -- 自我
  -- 地形
    -- 某个地形
    -- 地形分类
  -- 河流
  -- 地貌
  -- 自然奇观
  -- 奇观
  -- 区域
    -- 任何区域
    -- 某个区域
    -- 区域分类
  -- 资源
    -- 任何资源
    -- 海洋资源
    -- 加成/奢侈/战略
    -- 资源分类（需要马良相邻）
  -- 改良
    -- 某个改良
    -- 改良分类
function GetSortedAdjacencyBonuses(objectKind, objectType)
	-- 获取该区域/改良的相邻加成Id
  local gameInfoTable;
  local gameInfoTable_Classification;
  if objectKind == 'DistrictType' then
    gameInfoTable = GameInfo.District_Adjacencies;
    gameInfoTable_Classification = GameInfo.HD_District_Adjacencies_Base_On_Classification;
  elseif objectKind == 'ImprovementType' then
    gameInfoTable = GameInfo.Improvement_Adjacencies;
    gameInfoTable_Classification = GameInfo.HD_Improvement_Adjacencies_Base_On_Classification;
  else
    return {};
  end

	local bonuseDataList = {
    {}, -- 1  SELF
    {}, -- 2  TERRAIN_SPECIFIC
    {}, -- 3  TERRAIN_CLASSIFICATION
    {}, -- 4  RIVER
    {}, -- 5  FEATURE
    {}, -- 6  NATURAL_WONDER
    {}, -- 7  WONDER
    {}, -- 8  DISTRICT_ALL
    {}, -- 9  DISTRICT_SPECIFIC
    {}, -- 10 DISTRICT_CLASSIFICATION
    {}, -- 11 RESOURCE_ALL
    {}, -- 12 RESOURCE_SEA
    {}, -- 13 RESOURCE_CLASS_BONUS
    {}, -- 14 RESOURCE_CLASS_LUXURY
    {}, -- 15 RESOURCE_CLASS_STRATEGIC
    {}, -- 16 RESOURCE_CLASS_OTHER
    {}, -- 17 RESOURCE_CLASSIFICATION
    {}, -- 18 IMPROVEMENT_SPECIFIC
    {}  -- 19 IMPROVEMENT_CLASSIFICATION
  };

  for row in gameInfoTable_Classification() do
    if row[objectKind] == objectType then
      local data = GameInfo.HD_Adjacency_Base_On_Classification[row.YieldChangeId];
      local yield = GameInfo.Yields[data.YieldType];

      -- 权重计算 较小的排序靠前
      local score = data.YieldChange / data.TilesRequired + 10 * yield.Index;

      if data.TerrainClassType then
        table.insert(bonuseDataList[3], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = GameInfo.TerrainClasses[data.TerrainClassType].Name,
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.DistrictClassificationType then
        table.insert(bonuseDataList[10], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = GameInfo.HD_DistrictClassificationTypes[data.DistrictClassificationType].Name,
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.ResourceClassificationType then
        table.insert(bonuseDataList[17], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = GameInfo.HD_ResourceClassificationTypes[data.ResourceClassificationType].Name,
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.ImprovementClassificationType then
        table.insert(bonuseDataList[19], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = GameInfo.HD_ImprovementClassificationTypes[data.ImprovementClassificationType].Name,
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      else
        -- 非法情况
        print("非法的相邻加成数据", row.YieldChangeId)
      end
    end
  end

  -- 原版的相邻加成系统
  for row in gameInfoTable() do
    if row[objectKind] == objectType and GameInfo.HD_Adjacencies_YieldChangeId_ParentId[row.YieldChangeId] == nil then
      local data = GameInfo.Adjacency_YieldChanges[row.YieldChangeId];
      local yield = GameInfo.Yields[data.YieldType];

      -- 权重计算 较小的排序靠前
      local score = data.YieldChange / data.TilesRequired + 10 * yield.Index;

      if data.Self then
        table.insert(bonuseDataList[1], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = 'LOC_TOOLTIP_HD_ADJACENCIES_SELF_TEXT',
          Score = score
        })
      elseif data.AdjacentTerrain then
        table.insert(bonuseDataList[2], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = GameInfo.Terrains[data.AdjacentTerrain].Name,
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.AdjacentRiver then
        table.insert(bonuseDataList[4], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = 'LOC_TOOLTIP_HD_ADJACENCIES_RIVER_TEXT',
          Score = score
        })
      elseif data.AdjacentFeature then
        local featureInfo = GameInfo.Features[data.AdjacentFeature];
        if not featureInfo.NaturalWonder then
          table.insert(bonuseDataList[5], {
            YieldName = yield.Name,
            YieldIcon = yield.IconString,
            YieldChange = data.YieldChange,
            ObjectName = featureInfo.Name,
            TilesRequired = data.TilesRequired,
            PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
            PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
            ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
            ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
            TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
            Score = score
          })
        end
      elseif data.AdjacentNaturalWonder then
        table.insert(bonuseDataList[6], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = 'LOC_TYPE_TRAIT_ADJACENT_OBJECT_NATURAL_WONDER',
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.AdjacentWonder then
        table.insert(bonuseDataList[7], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = 'LOC_TYPE_TRAIT_ADJACENT_OBJECT_WONDER',
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.OtherDistrictAdjacent then
        table.insert(bonuseDataList[8], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = 'LOC_TYPE_TRAIT_ADJACENT_OBJECT_DISTRICT',
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.AdjacentDistrict then
        table.insert(bonuseDataList[9], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = GameInfo.Districts[data.AdjacentDistrict].Name,
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.AdjacentResource then
        table.insert(bonuseDataList[11], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = 'LOC_TYPE_TRAIT_ADJACENT_OBJECT_RESOURCE',
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.AdjacentSeaResource then
        table.insert(bonuseDataList[12], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = 'LOC_TYPE_TRAIT_ADJACENT_OBJECT_SEA_RESOURCE',
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      elseif data.AdjacentResourceClass ~= "NO_RESOURCECLASS" then
        if data.AdjacentResourceClass == "RESOURCECLASS_BONUS" then
          table.insert(bonuseDataList[13], {
            YieldName = yield.Name,
            YieldIcon = yield.IconString,
            YieldChange = data.YieldChange,
            ObjectName = 'LOC_TOOLTIP_BONUS_RESOURCE',
            TilesRequired = data.TilesRequired,
            PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
            PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
            ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
            ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
            TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
            Score = score
          })
        elseif data.AdjacentResourceClass == "RESOURCECLASS_LUXURY" then
          table.insert(bonuseDataList[14], {
            YieldName = yield.Name,
            YieldIcon = yield.IconString,
            YieldChange = data.YieldChange,
            ObjectName = 'LOC_TOOLTIP_LUXURY_RESOURCE',
            TilesRequired = data.TilesRequired,
            PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
            PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
            ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
            ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
            TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
            Score = score
          })
        elseif data.AdjacentResourceClass == "RESOURCECLASS_STRATEGIC" then
          table.insert(bonuseDataList[15], {
            YieldName = yield.Name,
            YieldIcon = yield.IconString,
            YieldChange = data.YieldChange,
            ObjectName = 'LOC_TOOLTIP_BONUS_STRATEGIC',
            TilesRequired = data.TilesRequired,
            PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
            PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
            ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
            ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
            TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
            Score = score
          })
        else
          table.insert(bonuseDataList[16], {
            YieldName = yield.Name,
            YieldIcon = yield.IconString,
            YieldChange = data.YieldChange,
            ObjectName = 'LOC_TYPE_TRAIT_ADJACENT_OBJECT_RESOURCE_CLASS',
            TilesRequired = data.TilesRequired,
            PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
            PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
            ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
            ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
            TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
            Score = score
          })
        end
      elseif data.AdjacentImprovement then
        table.insert(bonuseDataList[18], {
          YieldName = yield.Name,
          YieldIcon = yield.IconString,
          YieldChange = data.YieldChange,
          ObjectName = GameInfo.Improvements[data.AdjacentImprovement].Name,
          TilesRequired = data.TilesRequired,
          PrereqCivic = (data.PrereqCivic) and GameInfo.Civics[data.PrereqCivic].Name or nil,
          PrereqTech = (data.PrereqTech) and GameInfo.Technologies[data.PrereqTech].Name or nil,
          ObsoleteCivic = (data.ObsoleteCivic) and GameInfo.Civics[data.ObsoleteCivic].Name or nil,
          ObsoleteTech = (data.ObsoleteTech) and GameInfo.Technologies[data.ObsoleteTech].Name or nil,
          TextTemplate = (data.TilesRequired > 1) and "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_PER_TEXT" or "LOC_TOOLTIP_HD_ADJACENCIES_OBJECT_TEXT",
          Score = score
        })
      else
        -- 非法情况
        print("非法的相邻加成数据", row.YieldChangeId)
      end
    end
  end

  -- 排序
  for _, list in ipairs(bonuseDataList) do
    table.sort(list, function(a, b) return a.Score < b.Score; end)
  end

  -- 生成文本
  local textList = {};
  for _, list in ipairs(bonuseDataList) do
    for _, data in ipairs(list) do
      local text = '';
      if data.ObjectName == nil then
        text = Locale.Lookup(data.TextTemplate, data.YieldChange, data.YieldIcon, data.YieldName);
      else
        text = Locale.Lookup(data.TextTemplate, data.YieldChange, data.YieldIcon, data.YieldName, data.TilesRequired, data.ObjectName);
      end

      if data.PrereqCivic or data.PrereqTech then
        text = text .. Locale.Lookup("LOC_TOOLTIP_HD_ADJACENCIES_REQUIRES_TEXT", (data.PrereqCivic and data.PrereqCivic or data.PrereqTech))
      end

      if data.ObsoleteCivic or data.ObsoleteTech then
        text = text .. Locale.Lookup("LOC_TOOLTIP_HD_ADJACENCIES_OBSOLETE_TEXT", (data.ObsoleteCivic and data.ObsoleteCivic or data.ObsoleteTech))
      end

      table.insert(textList, text);
    end
  end

	return textList;
end
Utils.GetSortedAdjacencyBonuses = GetSortedAdjacencyBonuses;

-- 获得改良产出和加产节点
function GetSortedImprovementYieldChanges(improvementType)
  local yieldChanges = {};

  for row in GameInfo.Improvement_YieldChanges() do
		if row.ImprovementType == improvementType and row.YieldChange ~= 0 then
			local yield = GameInfo.Yields[row.YieldType];
			if yield then
				table.insert(yieldChanges, {
          Text = Locale.Lookup("LOC_TOOLTIP_HD_BASIC_YIELDS_TEXT", row.YieldChange, yield.IconString, yield.Name),
          Score = yield.Index
        });
			end
		end
	end

  for row in GameInfo.Improvement_BonusYieldChanges() do
		if row.ImprovementType == improvementType and row.BonusYieldChange ~= 0 then
			local yield = GameInfo.Yields[row.YieldType];
			if yield then

				local item;
				if row.PrereqCivic then
					item = GameInfo.Civics[row.PrereqCivic];
				else
					item = GameInfo.Technologies[row.PrereqTech];
				end

				if item then
					table.insert(yieldChanges, {
            Text = Locale.Lookup("LOC_TOOLTIP_HD_YIELD_CHANGES_REQUIRES_TEXT", row.BonusYieldChange, yield.IconString, yield.Name, item.Name),
            Score = yield.Index + item.Cost
          });
				end
			end
		end
	end

  table.sort(yieldChanges, function(a, b) return a.Score < b.Score; end)

  local textList = {};
  for _, data in ipairs(yieldChanges) do
    table.insert(textList, data.Text)
  end

  -- 魅力转产
  local improvement = GameInfo.Improvements[improvementType];
  if improvement.YieldFromAppeal then
    local yield = GameInfo.Yields[improvement.YieldFromAppeal];
    table.insert(textList, Locale.Lookup('LOC_TOOLTIP_HD_YIELD_FROM_APPEAL_TEXT', improvement.YieldFromAppealPercent, yield.IconString, yield.Name))
  end

  return textList;
end
Utils.GetSortedImprovementYieldChanges = GetSortedImprovementYieldChanges;

-- 区域排序 用于界面显示等

local DistrictSortMap = {
  DISTRICT_CITY_CENTER = 0,

  DISTRICT_HOLY_SITE = 100,
    DISTRICT_LAVRA = 101,
  DISTRICT_CAMPUS = 200,
    DISTRICT_SEOWON = 201,
    DISTRICT_OBSERVATORY = 202,
  DISTRICT_THEATER = 300,
    DISTRICT_ACROPOLIS = 301,
    DISTRICT_XHH_FESTIVAL_THEATER = 302,
  DISTRICT_COMMERCIAL_HUB = 400,
    DISTRICT_SUGUBA = 401,
    DISTRICT_SUK_FLOATINGMARKET = 402,
  DISTRICT_HARBOR = 500,
    DISTRICT_ROYAL_NAVY_DOCKYARD = 501,
    DISTRICT_COTHON = 502,
  DISTRICT_C_AGRICULTURE = 600,
    DIS_C_IKU = 601,
  DISTRICT_INDUSTRIAL_ZONE = 700,
    DISTRICT_HANSA = 701,
    DISTRICT_OPPIDUM = 702,
  DISTRICT_ENCAMPMENT = 800,
    DISTRICT_IKANDA = 801,
    DISTRICT_THANH = 802,
  DISTRICT_GOVERNMENT = 900,
  DISTRICT_DIPLOMATIC_QUARTER = 1000,

  DISTRICT_AQUEDUCT = 2000,
    DISTRICT_BATH = 2001,
  DISTRICT_C_FISHING = 2100,
    DISTRICT_C_ROMAN_GARUM = 2101,
  DISTRICT_C_MARITIMEWORKS = 2200,
    DISTRICT_C_PHOENICIAN_PURPLE = 2201,
  DISTRICT_ENTERTAINMENT_COMPLEX = 2300,
    DISTRICT_STREET_CARNIVAL = 2301,
    DISTRICT_HIPPODROME = 2302,
  DISTRICT_WATER_ENTERTAINMENT_COMPLEX = 2400,
    DISTRICT_WATER_STREET_CARNIVAL = 2401,
  DISTRICT_NEIGHBORHOOD = 2500,
    DISTRICT_MBANZA = 2501,
  DISTRICT_PRESERVE = 2600,
  DISTRICT_CANAL = 2700,
  DISTRICT_DAM = 2800,
  DISTRICT_AERODROME = 2900,

  DISTRICT_SPACEPORT = 10000,

  DISTRICT_WONDER = 100000
};
function InitDistrictSortList()
  for row in GameInfo.Districts() do
    if DistrictSortMap[row.DistrictType] == nil then
      local repalceInfo = GameInfo.DistrictReplaces[row.DistrictType];
      if repalceInfo ~= nil and DistrictSortMap[repalceInfo.ReplacesDistrictType] ~= nil then
        local score = DistrictSortMap[repalceInfo.ReplacesDistrictType] + 1;
        DistrictSortMap[row.DistrictType] = score;
      else
        local score = 1100;
        if not row.RequiresPopulation then score = 3000; end
      end
    end
  end

  -- print("=============================================================")
  -- print("区域排序")
  -- for key, score in pairs(DistrictSortMap) do
  --   print(key, GameInfo.Districts[key], score);
  -- end
  -- print("=============================================================")
end
InitDistrictSortList();
Utils.DistrictSortMap = DistrictSortMap;

-- 获取城市电力
function IsCityFullyPowered(playerId, cityId)
  local city = CityManager.GetCity(playerId, cityId)
  if city then
    return city:GetPower():IsFullyPowered();
  end

  return false;
end
Utils.IsCityFullyPowered = IsCityFullyPowered;

-- 获取单位级别
function GetUnitLevelNum(playerId, unitId)
  local pUnit = UnitManager.GetUnit(playerId, unitId);
  local level = 0;
  for row in GameInfo.UnitPromotions() do
    if (row ~= nil) and (pUnit:GetExperience() ~= nil) and (pUnit:GetExperience():HasPromotion(row.Index)) then
      level = level + 1;
    end
  end
  return level;
end
Utils.GetUnitLevelNum = GetUnitLevelNum;

-- 获取历史时刻
function GetHistoricalMomentData(momentId)
  return Game.GetHistoryManager():GetMomentData(momentId);
end
Utils.GetHistoricalMomentData = GetHistoricalMomentData;