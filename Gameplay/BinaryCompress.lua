ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

local BINARY_COMPRESS_MAX_EXP = GlobalParameters.HD_BINARY_COMPRESS_MAX_EXP or 0;
function BinaryCompress(amount, plot, key)
  key = key or 'HD_PLOT_BINARY_COMPRESS';
  local total_key = 'TOTAL_' .. key;

  local pre_total = plot:GetProperty(total_key) or 0;
  if pre_total == amount then
    -- print("二进制折叠 与前值相同 跳过");
    return;
  end
  plot:SetProperty(total_key, amount);

  local num = math.min(amount, math.pow(2, BINARY_COMPRESS_MAX_EXP + 1) - 1)
  print('BinaryCompress start', num)
  for i=BINARY_COMPRESS_MAX_EXP, 0, -1 do
    plot:SetProperty(key .. '_' .. i, 0)
    local divisor = math.pow(2, i)
    if num >= divisor then
      num = num % divisor
      plot:SetProperty(key .. '_' .. i, 1)
      print('BinaryCompress', divisor, plot:GetProperty(key .. '_' .. i))
    end
  end
end
Utils.BinaryCompress = BinaryCompress

-- =========================
-- 二进制自助统计
-- =========================
-- 城市正宜居度
function CityPositiveAmenitySetProperty(playerId, cityId)
  local city = CityManager.GetCity(playerId, cityId);
	if not city then return; end

  local needCount = city:GetProperty('HD_CITY_NEED_COUNT_POSITIVE_AMENITY') or 0;
  if needCount == 0 then return; end

  local positiveAmenity = Utils.GetCityPositiveAmenity(playerId, cityId);
  local plot = Map.GetPlot(city:GetX(), city:GetY());
  if not plot then return; end

  print(Locale.Lookup(city:GetName()) .. "正宜居度：" .. positiveAmenity);
  Utils.BinaryCompress(positiveAmenity, plot, 'HD_PLOT_BINARY_COMPRESS_CITY_POSITIVE_AMENITY');
end
Utils.CityPositiveAmenitySetProperty = CityPositiveAmenitySetProperty;
Events.CitySelectionChanged.Add(CityPositiveAmenitySetProperty);

-- 城市溢出宜居度
function CityExcessAmenitySetProperty(playerId, cityId)
  local city = CityManager.GetCity(playerId, cityId);
	if not city then return; end

  local needCount = city:GetProperty('HD_CITY_NEED_COUNT_EXCESS_AMENITY') or 0;
  if needCount == 0 then return; end

  local excessAmenity = Utils.GetCityExcessAmenity(playerId, cityId);
  local plot = Map.GetPlot(city:GetX(), city:GetY());
  if not plot then return; end

  print(Locale.Lookup(city:GetName()) .. "溢出宜居度：" .. excessAmenity);
  Utils.BinaryCompress(excessAmenity, plot, 'HD_PLOT_BINARY_COMPRESS_CITY_EXCESS_AMENITY');
end
Utils.CityExcessAmenitySetProperty = CityExcessAmenitySetProperty;
Events.CitySelectionChanged.Add(CityExcessAmenitySetProperty);

-- 玩家已挂政策卡数量
function PlayerPolicyNumSetProperty(playerId)
  local player = Players[playerId];
  if not player then return; end

  local needCountMilitary = player:GetProperty('HD_PLAYER_NEED_COUNT_MILITARY_POLICY') or 0;
  local needCountEconomic = player:GetProperty('HD_PLAYER_NEED_COUNT_ECONOMIC_POLICY') or 0;
  local needCountCultural = player:GetProperty('HD_PLAYER_NEED_COUNT_CULTURAL_POLICY') or 0;
  local needCountWildcard = player:GetProperty('HD_PLAYER_NEED_COUNT_WILDCARD_POLICY') or 0;

  if needCountMilitary + needCountEconomic + needCountCultural + needCountWildcard == 0 then return; end

  local militaryNum = 0;
  local economicNum = 0;
  local culturalNum = 0;
  local wildCardNum = 0;

  local policySlots = player:GetCulture():GetNumPolicySlots();
  for i = 0, policySlots - 1, 1 do
    local policyId = player:GetCulture():GetSlotPolicy(i);
    local policyInfo = GameInfo.Policies[policyId];
    if policyInfo then
      local slotType = policyInfo.GovernmentSlotType;

      if slotType == 'SLOT_MILITARY' then militaryNum = militaryNum + 1; end
      if slotType == 'SLOT_ECONOMIC' then economicNum = economicNum + 1; end
      if slotType == 'SLOT_DIPLOMATIC' then culturalNum = culturalNum + 1; end
      if slotType == 'SLOT_GREAT_PERSON' then wildCardNum = wildCardNum + 1; end
      if slotType == 'SLOT_WILDCARD' then wildCardNum = wildCardNum + 1; end
    end
  end

  print("军事政策数量：" .. militaryNum);
  print("经济政策数量：" .. economicNum);
  print("文化政策数量：" .. culturalNum);
  print("通配政策数量：" .. wildCardNum);

  local capital = player:GetCities():GetCapitalCity();
  if not capital then return; end

  local plot = Map.GetPlot(capital:GetX(), capital:GetY());
  if not plot then return; end

  if needCountMilitary > 0 then
    Utils.BinaryCompress(militaryNum, plot, 'HD_PLOT_BINARY_COMPRESS_PLAYER_MILITARY_POLICY');
  end

  if needCountEconomic > 0 then
    Utils.BinaryCompress(economicNum, plot, 'HD_PLOT_BINARY_COMPRESS_PLAYER_ECONOMIC_POLICY');
  end

  if needCountCultural > 0 then
    Utils.BinaryCompress(culturalNum, plot, 'HD_PLOT_BINARY_COMPRESS_PLAYER_CULTURAL_POLICY');
  end

  if needCountWildcard > 0 then
    Utils.BinaryCompress(wildCardNum, plot, 'HD_PLOT_BINARY_COMPRESS_PLAYER_WILDCARD_POLICY');
  end
end
Events.GovernmentPolicyChanged.Add(PlayerPolicyNumSetProperty);
Events.CitySelectionChanged.Add(PlayerPolicyNumSetProperty);

-- 回合结束时自助统计
function BinaryCompressCountOnGameTurnEnded()
	for _, playerId in ipairs(PlayerManager.GetAliveMajorIDs()) do
    local player = Players[playerId];
    if player then
      -- 城市溢出宜居度统计
      for _, city in player:GetCities():Members() do
        CityPositiveAmenitySetProperty(playerId, city:GetID());
        CityExcessAmenitySetProperty(playerId, city:GetID());
      end

      -- 已挂政策卡数量统计
      PlayerPolicyNumSetProperty(playerId);
    end
	end
end
GameEvents.OnGameTurnEnded.Add(BinaryCompressCountOnGameTurnEnded)