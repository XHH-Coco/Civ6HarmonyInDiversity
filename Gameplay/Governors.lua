ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- ============================================================================================================================================================
-- 常量
-- ============================================================================================================================================================
local SCIENTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_SCIENTIST'].Index;
local ENGINEER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ENGINEER'].Index;

local GOVERNOR_THE_BUILDER_INDEX = GameInfo.Governors['GOVERNOR_THE_BUILDER'].Index;
local GOVERNOR_THE_AMBASSADOR_INDEX = GameInfo.Governors['GOVERNOR_THE_AMBASSADOR'].Index;

local GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_3_INDEX = GameInfo.GovernorPromotions['GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_3'].Index;
local GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_2_INDEX = GameInfo.GovernorPromotions['GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_2'].Index;

local NOTIFICATION_TRADING_POST_CREATED_HASH = GameInfo.Notifications['NOTIFICATION_TRADING_POST_CREATED'].Hash;

local GOVERNOR_BUILDER_RIGHT_3_WONDER_ENGINEER_PERCENTAGE = GlobalParameters.HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_ENGINEER_PERCENTAGE or 0;
local GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_BASE = GlobalParameters.HD_GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_BASE or 0;
local GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_PER_TRADINGPOST = GlobalParameters.HD_GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_PER_TRADINGPOST or 0;
local GOVERNOR_AMBASSADOR_RIGHT_2_ENVOY_NUM = GlobalParameters.HD_GOVERNOR_AMBASSADOR_RIGHT_2_ENVOY_NUM or 0;

local GOVERNOR_BUILDER_RIGHT_3_WONDER_RECORD_TAG = 'HD_GOVERNOR_BUILDER_RIGHT_3_WONDER_RECORD';
local GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_RECORD_TAG = 'HD_GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_RECORD_';
local GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_NUM_TAG = 'HD_GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_NUM';
local GOVERNOR_MERCHANT_RIGHT_3_TRADE_ROUTE_YIELD_LIST_TAG = 'HD_GOVERNOR_MERCHANT_RIGHT_3_TRADE_ROUTE_YIELD_LIST';
-- ============================================================================================================================================================
-- 平伽拉
-- ============================================================================================================================================================
-- 典籍研读会
local educatorGreatWorkTypeFilter = {
  GREATWORKOBJECT_SCULPTURE = true,
  GREATWORKOBJECT_PORTRAIT = true,
  GREATWORKOBJECT_LANDSCAPE = true,
  GREATWORKOBJECT_RELIGIOUS = true,
  GREATWORKOBJECT_ARTIFACT = true,
  GREATWORKOBJECT_WRITING = true,
  GREATWORKOBJECT_MUSIC = true
};
function EducatorRefreshGreatWorkProperty(playerId, cityId)
  if Utils.CityHasAssignedGovernorPromotion(playerId, cityId, 'GOVERNOR_PROMOTION_HD_EDUCATOR_LEFT_2') then
    local greatWorkList = Utils.GetCityGreatWorks(playerId, cityId, educatorGreatWorkTypeFilter);
    local typeList = {};
    local eraList = {};
    local num = 0;
    for _, greatWorkId in ipairs(greatWorkList) do
      local greatWorkInfo = GameInfo.GreatWorks[greatWorkId];
      if greatWorkInfo then
        if typeList[greatWorkInfo.GreatWorkObjectType] ~= true then
          typeList[greatWorkInfo.GreatWorkObjectType] = true;
          num = num + 1;
        end
        if eraList[greatWorkInfo.EraType] ~= true then
          eraList[greatWorkInfo.EraType] = true;
          num = num + 1;
        end
      end
    end
    print("平伽拉 典籍研读会 巨作类别和时代数量：" .. num);

    local city = CityManager.GetCity(playerId, cityId);
    if not city then return; end
    local plot = Map.GetPlot(city:GetX(), city:GetY());
    if plot then
      Utils.BinaryCompress(num, plot, 'HD_PLOT_BINARY_COMPRESS_GOVERNOR_EDUCATOR_LEFT_2');
    end
  end
end

-- 国家科学院
function EducatorRefreshScientistProperty(playerId, cityId)
  if Utils.CityHasAssignedGovernorPromotion(playerId, cityId, 'GOVERNOR_PROMOTION_HD_EDUCATOR_RIGHT_3') then
    local player = Players[playerId];
    if not player then return; end

    local num = player:GetProperty('HD_UnitGreatPersonCreated_' .. SCIENTIST_INDEX) or 0;

    local city = CityManager.GetCity(playerId, cityId);
    if not city then return; end
    local plot = Map.GetPlot(city:GetX(), city:GetY());
    if plot then
      Utils.BinaryCompress(num, plot, 'HD_PLOT_BINARY_COMPRESS_GOVERNOR_EDUCATOR_RIGHT_3');
    end
  end
end

-- ============================================================================================================================================================
-- 梁
-- ============================================================================================================================================================
-- 国家工程院
  -- 相邻加成
function BuilderRefreshEngineerProperty(playerId, cityId)
  if Utils.CityHasAssignedGovernorPromotion(playerId, cityId, 'GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_3') then
    local player = Players[playerId];
    if not player then return; end

    local num = player:GetProperty('HD_UnitGreatPersonCreated_' .. ENGINEER_INDEX) or 0;

    local city = CityManager.GetCity(playerId, cityId);
    if not city then return; end
    local plot = Map.GetPlot(city:GetX(), city:GetY());
    if plot then
      Utils.BinaryCompress(num, plot, 'HD_PLOT_BINARY_COMPRESS_GOVERNOR_BUILDER_RIGHT_3');
    end
  end
end

  -- 完成奇观获得大工点
function BuilderWonderAddGPP(x, y, buildingId, playerId, cityId, percentComplete)
  if Utils.CityHasAssignedGovernorPromotion(playerId, cityId, 'GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_3') then
    local player = Players[playerId];
    if not player then return; end

    local buildingInfo = GameInfo.Buildings[buildingId];
    if not buildingInfo then return; end

    local isNotDummy = GameInfo.HD_DUMMY_BUILDINGS[buildingInfo.BuildingType] == nil;
    if buildingInfo.IsWonder == true and isNotDummy then
      local amount = math.ceil(buildingInfo.Cost * GOVERNOR_BUILDER_RIGHT_3_WONDER_ENGINEER_PERCENTAGE / 100);
      player:GetGreatPeoplePoints():ChangePointsTotal(ENGINEER_INDEX, amount);
      Game.AddWorldViewText(playerId, '+' .. amount .. ' [ICON_GreatEngineer]', x, y);
    end
  elseif Utils.CityHasAssignedGovernorPromotion(playerId, cityId, 'GOVERNOR_PROMOTION_HD_BUILDER_BASE') then
    -- 记录就职后建造的奇观（还未有右三升级）
    local city = CityManager.GetCity(playerId, cityId);
    if not city then return; end

    local buildingInfo = GameInfo.Buildings[buildingId];
    if not buildingInfo then return; end

    local isNotDummy = GameInfo.HD_DUMMY_BUILDINGS[buildingInfo.BuildingType] == nil;
    if buildingInfo.IsWonder == true and isNotDummy then
      local amount = math.ceil(buildingInfo.Cost * GOVERNOR_BUILDER_RIGHT_3_WONDER_ENGINEER_PERCENTAGE / 100);

      local list = city:GetProperty(GOVERNOR_BUILDER_RIGHT_3_WONDER_RECORD_TAG) or {};
      table.insert(list, {
        Amount = amount,
        X = x,
        Y = y
      })
      city:SetProperty(GOVERNOR_BUILDER_RIGHT_3_WONDER_RECORD_TAG, list);
    end
  end
end
Events.WonderCompleted.Add(BuilderWonderAddGPP);

  -- 追溯奇观获得大工点
function BuilderWonderRetrospectGPP(playerId, governorId, promotionId)
  if governorId == GOVERNOR_THE_BUILDER_INDEX and promotionId == GOVERNOR_PROMOTION_HD_BUILDER_RIGHT_3_INDEX then
    local player = Players[playerId];
    if not player then return; end

    local cityId = Utils.GetGovernorAssignedCityId(playerId, GOVERNOR_THE_BUILDER_INDEX);
    if not cityId then return; end
    local city = CityManager.GetCity(playerId, cityId);
    if not city then return; end

    local list = city:GetProperty(GOVERNOR_BUILDER_RIGHT_3_WONDER_RECORD_TAG) or {};
    local totalAmount = 0;
    for _, data in ipairs(list) do
      totalAmount = totalAmount + data.Amount;
      Game.AddWorldViewText(playerId, '+' .. data.Amount .. ' [ICON_GreatEngineer]', data.X, data.Y);
    end

    if totalAmount > 0 then
      player:GetGreatPeoplePoints():ChangePointsTotal(ENGINEER_INDEX, totalAmount);
    end
    city:SetProperty(GOVERNOR_BUILDER_RIGHT_3_WONDER_RECORD_TAG, {});
  end
end

-- ============================================================================================================================================================
-- 瑞娜
-- ============================================================================================================================================================
-- 国际贸易
  -- 统计贸易站数量
function MerchantBuildTradingPost(playerId, notificationId)
  local player = Players[playerId];
  if not player then return; end

  local notificationEntry = NotificationManager.Find(playerId, notificationId)
  if notificationEntry then
    if notificationEntry:GetType() == NOTIFICATION_TRADING_POST_CREATED_HASH then
      local x, y = notificationEntry:GetLocation();
      local city = CityManager.GetCityAt(x, y);
      if not city then return; end

      local ownerId = city:GetOwner();
      local owner = Players[ownerId];
      if ownerId == playerId or not owner or not owner:IsMajor() then return; end

      if player:GetProperty(GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_RECORD_TAG .. ownerId) ~= 1 then
        player:SetProperty(GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_RECORD_TAG .. ownerId, 1);
        local amount = player:GetProperty(GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_NUM_TAG) or 0;
        player:SetProperty(GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_NUM_TAG, amount + 1);
        print("瑞娜 国际贸易 首座贸易站数量：" .. amount + 1);
      end
    end
  end
end
Events.NotificationAdded.Add(MerchantBuildTradingPost);

  -- 计算国际商路收益
function MerchantRefreshTradeYieldProperty(playerId, cityId)
  if Utils.CityHasAssignedGovernorPromotion(playerId, cityId, 'GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_3') then
    local player = Players[playerId];
    if not player then return; end
  
    local city = CityManager.GetCity(playerId, cityId);
    if not city then return; end

    print("================================================================")
    local tradingPostNum = player:GetProperty(GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_NUM_TAG) or 0;
    local factor = (GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_BASE + tradingPostNum * GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_PER_TRADINGPOST) / 100;
    print("瑞娜 国际贸易 乘区：" .. factor);

    local outgoingRoutes = Utils.GetCityOutgoingRoutes(playerId, cityId);
    if not outgoingRoutes then return; end

    local yieldList = {};
    for _, route in ipairs(outgoingRoutes) do
      if route.DestinationCityPlayer ~= playerId then
        for _, yieldInfo in ipairs(route.OriginYields) do
          local yieldChange = yieldList[yieldInfo.YieldIndex] or 0;
          yieldList[yieldInfo.YieldIndex] = yieldChange + yieldInfo.Amount * factor;
        end
      end
    end
    city:SetProperty(GOVERNOR_MERCHANT_RIGHT_3_TRADE_ROUTE_YIELD_LIST_TAG, yieldList);

    local plot = Map.GetPlot(city:GetX(), city:GetY());
    if not plot then return; end

    for yieldIndex, yieldChange in pairs(yieldList) do
      local yieldInfo = GameInfo.Yields[yieldIndex];
      if yieldInfo then
        print("瑞娜 国际贸易 " .. Locale.Lookup(yieldInfo.Name) .. "：" .. yieldChange);
        Utils.BinaryCompress(math.floor(yieldChange), plot, 'HD_PLOT_BINARY_COMPRESS_GOVERNOR_MERCHANT_RIGHT_3_' .. yieldInfo.YieldType);
      end
    end
    print("================================================================")
  end
end

-- ============================================================================================================================================================
-- 阿玛妮
-- ============================================================================================================================================================
-- 互惠同盟
function AmbassadorSendEnvoy(playerId, governorId, promotionId)
  if governorId == GOVERNOR_THE_AMBASSADOR_INDEX and promotionId == GOVERNOR_PROMOTION_HD_AMBASSADOR_RIGHT_2_INDEX and GOVERNOR_AMBASSADOR_RIGHT_2_ENVOY_NUM > 0 then
    local player = Players[playerId];
    if not player then return; end
    
    local playersMetIds = Utils.GetPlayersMetIds(playerId);
    if not playersMetIds then return; end

    for _, metId in ipairs(playersMetIds) do
      local owner = Players[metId];
      if owner and Utils.PlayerIsMinor(metId) and owner:GetInfluence():CanReceiveInfluence() and Utils.CanGiveTokensToPlayer(playerId, metId) then
        for i=1, GOVERNOR_AMBASSADOR_RIGHT_2_ENVOY_NUM, 1 do
          player:GetInfluence():GiveFreeTokenToPlayer(metId);
        end
      end
    end
  end
end

-- ============================================================================================================================================================
-- 总督刷新检测
-- ============================================================================================================================================================
-- 总督升级
function HDGovernorPromoted(playerId, governorId, promotionId)
  -- 梁右三
  BuilderWonderRetrospectGPP(playerId, governorId, promotionId);
  -- 阿右二
  AmbassadorSendEnvoy(playerId, governorId, promotionId);
end
Events.GovernorPromoted.Add(HDGovernorPromoted)

-- 切换城市
function GovernorRefreshCitySelectionChanged(playerId, cityId)
  -- 平左二
  EducatorRefreshGreatWorkProperty(playerId, cityId);
  -- 平右三
  EducatorRefreshScientistProperty(playerId, cityId);
  -- 梁右三
  BuilderRefreshEngineerProperty(playerId, cityId);
  -- 瑞右三
  MerchantRefreshTradeYieldProperty(playerId, cityId);
end
Events.CitySelectionChanged.Add(GovernorRefreshCitySelectionChanged);

-- 回合结束
function GovernorRefreshOnGameTurnEnded()
  for _, playerId in ipairs(PlayerManager.GetAliveMajorIDs()) do
    local player = Players[playerId];
    if player then
      for _, city in player:GetCities():Members() do
        -- 平左二
        EducatorRefreshGreatWorkProperty(playerId, city:GetID());
        -- 平右三
        EducatorRefreshScientistProperty(playerId, city:GetID());
        -- 梁右三
        BuilderRefreshEngineerProperty(playerId, city:GetID());
        -- 瑞右三
        MerchantRefreshTradeYieldProperty(playerId, city:GetID());
      end
    end
	end
end
GameEvents.OnGameTurnEnded.Add(GovernorRefreshOnGameTurnEnded);