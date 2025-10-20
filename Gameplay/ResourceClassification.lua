ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

local pendingRefresh = {};
-- 初始化需要用Lua按分类统计资源的建筑列表

local BuildingNeedDetectList = {
  PLAYER = {},
  CITY = {}
};
-- DetectRange
  -- BuildingType
    -- PropertyKey
      -- ResourceClassificationType
function Init()
  for row in GameInfo.HD_Building_Base_On_ResourceClassification() do
    local propertyKeyList = BuildingNeedDetectList[row.DetectRange][row.BuildingType] or {};
    local resourceClassificationTypeList = propertyKeyList[row.PropertyKey] or {};

    table.insert(resourceClassificationTypeList, row.ResourceClassificationType);
    propertyKeyList[row.PropertyKey] = resourceClassificationTypeList
    BuildingNeedDetectList[row.DetectRange][row.BuildingType] = propertyKeyList;
  end

  Utils.BuildingNeedDetectList = BuildingNeedDetectList;
end
Init();

-- 建造需要用Lua按分类统计资源的建筑
local PLAYER_BUILDING_NEED_DETECT_LIST_TAG = 'HD_PLAYER_BUILDING_NEED_DETECT_LIST'
function CompleteBuildingNeedDetect(playerId, cityId, buildingId, plotId, bOriginalConstruction)
  local player = Players[playerId];
  local buildingInfo = GameInfo.Buildings[buildingId];
  local plot = Map.GetPlotByIndex(plotId);
  if not player or not buildingInfo or not plot then return; end

  -- 玩家资源
	if BuildingNeedDetectList['PLAYER'][buildingInfo.BuildingType] ~= nil then
    print("建造需要用Lua按分类统计玩家资源的建筑 " .. Locale.Lookup(buildingInfo.Name), playerId, plot:GetX(), plot:GetY());

    local playerTotalList = player:GetProperty(PLAYER_BUILDING_NEED_DETECT_LIST_TAG) or {};
    local dataList = playerTotalList[buildingInfo.BuildingType] or {};
    table.insert(dataList, {
      X = plot:GetX(),
      Y = plot:GetY()
    })
    playerTotalList[buildingInfo.BuildingType] = dataList;
    player:SetProperty(PLAYER_BUILDING_NEED_DETECT_LIST_TAG, playerTotalList)

    pendingRefresh[playerId] = 1;
  end

  -- 城市资源
end
GameEvents.BuildingConstructed.Add(CompleteBuildingNeedDetect)

-- 刷新按分类统计玩家资源
function RefreshPlayerResourceDetect(player)
  local playerTotalList = player:GetProperty(PLAYER_BUILDING_NEED_DETECT_LIST_TAG) or {};

  -- 汇总所有需要统计的资源分类
  local classificationTypeList = {};
  for buildingType, dataList in pairs(playerTotalList) do
    if BuildingNeedDetectList['PLAYER'][buildingType] ~= nil then
      for propertyKey, list in pairs(BuildingNeedDetectList['PLAYER'][buildingType]) do
        for _, classificationType in ipairs(list) do
          classificationTypeList[classificationType] = 0;
        end
      end
    end
  end

  -- 遍历检查玩家是否拥有某资源 按分类记录
  for classificationType, resourceList in pairs(Utils.Classification_Resource_Map) do
    if classificationTypeList[classificationType] ~= nil then
      for _, resourceType in ipairs(resourceList) do
        if Utils.GetPlayerResourceAmount(player:GetID(), resourceType) > 0 then
          print("玩家拥有资源 " .. resourceType)
          classificationTypeList[classificationType] = classificationTypeList[classificationType] + 1;
        end
      end
    end
  end

  for classificationType, num in pairs(classificationTypeList) do
    print("玩家拥有 " .. Locale.Lookup(GameInfo.HD_ResourceClassificationTypes[classificationType].Name) .. " 资源共 " .. num .. " 个")
  end

  -- Set plot property
  for buildingType, dataList in pairs(playerTotalList) do
    local propertyKeyList = BuildingNeedDetectList['PLAYER'][buildingType] or {};
    for propertyKey, list in pairs(propertyKeyList) do
      local totalNum = 0;
      for _, classificationType in ipairs(list) do
        print(Locale.Lookup(GameInfo.Buildings[buildingType].Name) .. " " .. propertyKey .. " 需要 " .. Locale.Lookup(GameInfo.HD_ResourceClassificationTypes[classificationType].Name) .. " 资源")
        totalNum = totalNum + classificationTypeList[classificationType];
      end
      print(Locale.Lookup(GameInfo.Buildings[buildingType].Name) .. " " .. propertyKey .. " 所需资源共拥有 " .. totalNum .. " 个")

      for _, data in ipairs(dataList) do
        local plot = Map.GetPlot(data.X, data.Y);
        if plot ~= nil then
          Utils.BinaryCompress(totalNum, plot, propertyKey);
        end
      end
    end
  end
end

-- TODO 刷新按分类统计城市资源

function RefreshPlayerResourceDetectIfPending(playerId)
	if (pendingRefresh[playerId] == nil) or (pendingRefresh[playerId] == 1) then
    local player = Players[playerId];
    if not player then return; end
		RefreshPlayerResourceDetect(player);
		pendingRefresh[playerId] = 0;
	end
end

local function Initialize()
  Events.CitySelectionChanged.Add(RefreshPlayerResourceDetectIfPending);
  GameEvents.PlayerTurnStarted.Add(RefreshPlayerResourceDetectIfPending);
  GameEvents.OnPlayerTurnEnded.Add(RefreshPlayerResourceDetectIfPending);

  -- 资源变化时记录允许刷新状态
  Events.PlayerResourceChanged.Add(function (playerId, resourceId)
    pendingRefresh[playerId] = 1;
  end);
end
Events.LoadGameViewStateDone.Add(Initialize);