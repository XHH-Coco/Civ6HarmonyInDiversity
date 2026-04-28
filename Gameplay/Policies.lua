ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- 判断玩家是否挂某个政策卡
function PlayerHasPolicy(playerId, policyId)
  local player = Players[playerId]
  if player and player:IsMajor() then
    local playerCulture = player:GetCulture()
    local numSlots = playerCulture:GetNumPolicySlots();
    for i = 0, numSlots-1, 1 do
      if policyId == playerCulture:GetSlotPolicy(i) then
        return true;
      end
    end
  end
  return false;
end
Utils.PlayerHasPolicy = PlayerHasPolicy;

-- 福音本土化
local POLICY_HD_GOSPEL_LOCALISATION_INDEX = GameInfo.Policies['POLICY_HD_GOSPEL_LOCALISATION'].Index;
local GOSPEL_LOCALISATION_RELIGIOUS_PRESSURE = GlobalParameters.HD_GOSPEL_LOCALISATION_RELIGIOUS_PRESSURE or 0;
-- 大觉醒运动
local POLICY_HD_GREAT_AWAKENING_INDEX = GameInfo.Policies['POLICY_HD_GREAT_AWAKENING'].Index;
local GREAT_AWAKENING_RELIGIOUS_PRESSURE = GlobalParameters.HD_GREAT_AWAKENING_RELIGIOUS_PRESSURE or 0;
-- 宗教电台
local POLICY_HD_RELIGIOUS_BROADCASTING_INDEX = GameInfo.Policies['POLICY_HD_RELIGIOUS_BROADCASTING'].Index;
local RELIGIOUS_BROADCASTING_RELIGIOUS_PRESSURE = GlobalParameters.HD_RELIGIOUS_BROADCASTING_RELIGIOUS_PRESSURE or 0;

function PolicyOnDistrictConstructed(playerId, districtId, x, y)
	local player = Players[playerId]
  if player == nil then
    return;
  end

  local plot = Map.GetPlot(x, y)
  local districtType = plot:GetDistrictType()
  -- 港口
  if Utils.IsDistrictType(districtType, 'DISTRICT_HARBOR') then
    -- 福音本土化
    if GOSPEL_LOCALISATION_RELIGIOUS_PRESSURE ~= 0 and PlayerHasPolicy(playerId, POLICY_HD_GOSPEL_LOCALISATION_INDEX) then
      local religionId = player:GetReligion():GetReligionTypeCreated()
      if religionId >= 0 then
        local city = Cities.GetPlotPurchaseCity(plot);
        city:GetReligion():AddReligiousPressure(playerId, religionId, GOSPEL_LOCALISATION_RELIGIOUS_PRESSURE, playerId);
        for row in GameInfo.Religions() do
          if row.Index == religionId then
            local religionName = Locale.Lookup(row.Name)
            local message = '[COLOR:White]+' .. tostring(GOSPEL_LOCALISATION_RELIGIOUS_PRESSURE) .. ' ' .. religionName .. '[ENDCOLOR]'
            Game.AddWorldViewText(playerId, message, city:GetX(), city:GetY())
          end
        end
      end
    end

    -- 福音本土化
    if GREAT_AWAKENING_RELIGIOUS_PRESSURE ~= 0 and PlayerHasPolicy(playerId, POLICY_HD_GREAT_AWAKENING_INDEX) then
      local religionId = player:GetReligion():GetReligionTypeCreated()
      if religionId >= 0 then
        local city = Cities.GetPlotPurchaseCity(plot);
        city:GetReligion():AddReligiousPressure(playerId, religionId, GREAT_AWAKENING_RELIGIOUS_PRESSURE, playerId);
        for row in GameInfo.Religions() do
          if row.Index == religionId then
            local religionName = Locale.Lookup(row.Name)
            local message = '[COLOR:White]+' .. tostring(GREAT_AWAKENING_RELIGIOUS_PRESSURE) .. ' ' .. religionName .. '[ENDCOLOR]'
            Game.AddWorldViewText(playerId, message, city:GetX(), city:GetY())
          end
        end
      end
    end
  end

  -- 商业中心
  if Utils.IsDistrictType(districtType, 'DISTRICT_COMMERCIAL_HUB') then
    -- 福音本土化
    if GREAT_AWAKENING_RELIGIOUS_PRESSURE ~= 0 and PlayerHasPolicy(playerId, POLICY_HD_GREAT_AWAKENING_INDEX) then
      local religionId = player:GetReligion():GetReligionTypeCreated()
      if religionId >= 0 then
        local city = Cities.GetPlotPurchaseCity(plot);
        city:GetReligion():AddReligiousPressure(playerId, religionId, GREAT_AWAKENING_RELIGIOUS_PRESSURE, playerId);
        for row in GameInfo.Religions() do
          if row.Index == religionId then
            local religionName = Locale.Lookup(row.Name)
            local message = '[COLOR:White]+' .. tostring(GREAT_AWAKENING_RELIGIOUS_PRESSURE) .. ' ' .. religionName .. '[ENDCOLOR]'
            Game.AddWorldViewText(playerId, message, city:GetX(), city:GetY())
          end
        end
      end
    end
  end

end
GameEvents.OnDistrictConstructed.Add(PolicyOnDistrictConstructed)

function PolicyBuildingConstructed(playerId, cityId, buildingId, plotId, bOriginalConstruction)
  local player = Players[playerId]
  if player == nil then
    return;
  end

  local building = GameInfo.Buildings[buildingId];
  local plot = Map.GetPlotByIndex(plotId)
  if (building.BuildingType == 'BUILDING_BROADCAST_CENTER'
      or building.BuildingType == 'BUILDING_FILM_STUDIO'
      or building.BuildingType == 'BUILDING_JNR_MEDIA_CENTER') then
    -- 宗教电台
    if RELIGIOUS_BROADCASTING_RELIGIOUS_PRESSURE ~= 0 and PlayerHasPolicy(playerId, POLICY_HD_RELIGIOUS_BROADCASTING_INDEX) then
      local religionId = player:GetReligion():GetReligionTypeCreated()
      if religionId >= 0 then
        for _, cityOwner in ipairs(Players) do
					if cityOwner:GetCities() ~= nil then
						for _, city in cityOwner:GetCities():Members() do
							local cityLocation = city:GetLocation();
							if Map.GetPlotDistance(plot:GetX(), plot:GetY(), cityLocation.x, cityLocation.y) <= 6 then
								city:GetReligion():AddReligiousPressure(playerId, religionId, RELIGIOUS_BROADCASTING_RELIGIOUS_PRESSURE, playerId);
								for row in GameInfo.Religions() do
									if row.Index == religionId then
										local religionName = Locale.Lookup(row.Name)
										local message = '[COLOR:White]+' .. tostring(RELIGIOUS_BROADCASTING_RELIGIOUS_PRESSURE) .. ' ' .. religionName .. '[ENDCOLOR]'
										Game.AddWorldViewText(playerId, message, cityLocation.x, cityLocation.y)
									end
								end
							end
						end
					end
				end
      end
    end
	end
end
GameEvents.BuildingConstructed.Add(PolicyBuildingConstructed)

-- 祭司阶层
local POLICY_HD_PRIEST_CLASS_INDEX = GameInfo.Policies['POLICY_HD_PRIEST_CLASS'].Index;
local PRIEST_CLASS_FAITH_PERCENTAGE = GlobalParameters.HD_PRIEST_CLASS_FAITH_PERCENTAGE or 0;
local PRIEST_CLASS_CULTURE_PERCENTAGE = GlobalParameters.HD_PRIEST_CLASS_CULTURE_PERCENTAGE or 0;
function UnitDamageChanged(playerId, unitId, newDamage, prevDamage)
  local player = Players[playerId]
  if player == nil then
    return;
  end

  if PlayerHasPolicy(playerId, POLICY_HD_PRIEST_CLASS_INDEX) then
    print('UnitDamageChanged', newDamage, prevDamage)
    local amount = newDamage - prevDamage
    if amount > 0 then
      local faithAmount = amount * PRIEST_CLASS_FAITH_PERCENTAGE / 100
      local cultureAmount = amount * PRIEST_CLASS_CULTURE_PERCENTAGE / 100
      player:GetReligion():ChangeFaithBalance(faithAmount)
      player:GetCulture():ChangeCurrentCulturalProgress(cultureAmount)

      local unit = player:GetUnits():FindID(unitId)
      if unit and unit:GetX() > 0 then
        local faithMessage = '[COLOR:ResFaithLabelCS]+' .. tostring(faithAmount) .. '[ENDCOLOR][ICON_Faith]'
        local cultureMessage = '[COLOR:ResCultureLabelCS]+' .. tostring(cultureAmount) .. '[ENDCOLOR][ICON_Culture]'
        Game.AddWorldViewText(playerId, faithMessage, unit:GetX(), unit:GetY());
        Game.AddWorldViewText(playerId, cultureMessage, unit:GetX(), unit:GetY());
      end
    end
  end
end

-- 手动解锁政策
-- local POLICY_HD_TRANSLATE_Index = GameInfo.Policies['POLICY_HD_TRANSLATE'].Index;
-- local POLICY_HD_CIVIC_ASSEMBLY_Index = GameInfo.Policies['POLICY_HD_CIVIC_ASSEMBLY'].Index;
-- local POLICY_HD_TRANSLATE_Tag = 'HD_POLICY_HD_TRANSLATE';
-- local POLICY_HD_CIVIC_ASSEMBLY_Tag = 'HD_POLICY_HD_CIVIC_ASSEMBLY';
-- function OnDistrictConstructedPolicy(playerId, districtId, x, y)
-- 	local player = Players[playerId]
--   if player ~= nil then
-- 		-- 翻译
-- 		if player:GetProperty(POLICY_HD_TRANSLATE_Tag) ~= 1 and Utils.IsDistrictType(districtId, 'DISTRICT_DIPLOMATIC_QUARTER') then
-- 			player:SetProperty(POLICY_HD_TRANSLATE_Tag, 1)
-- 			player:GetCulture():UnlockPolicy(POLICY_HD_TRANSLATE_Index)
-- 		end

-- 		-- 公民集会
-- 		if player:GetProperty(POLICY_HD_CIVIC_ASSEMBLY_Tag) ~= 1 and Utils.IsDistrictType(districtId, 'DISTRICT_GOVERNMENT') then
-- 			player:SetProperty(POLICY_HD_CIVIC_ASSEMBLY_Tag, 1)
-- 			player:GetCulture():UnlockPolicy(POLICY_HD_CIVIC_ASSEMBLY_Index)
-- 		end
-- 	end
-- end
-- GameEvents.OnDistrictConstructed.Add(OnDistrictConstructedPolicy)

-- 开路先锋
local PATHFINDER_FAITH_MAJOR_CIV_KEY = 'HD_PATHFINDER_FAITH_MAJOR_CIV';
local PATHFINDER_FAITH_CITYSTATE_KEY = 'HD_PATHFINDER_FAITH_CITYSTATE';
local PATHFINDER_FAITH_NEW_CONTINENT_KEY = 'HD_PATHFINDER_FAITH_NEW_CONTINENT';
local PATHFINDER_FAITH_NATURAL_WONDER_KEY = 'HD_PATHFINDER_FAITH_NATURAL_WONDER';
-- 发现文明、城邦
function PathFinderDiplomacyMeet(player1Id, player2Id)
  local player1 = Players[player1Id];
  local player2 = Players[player2Id];

  if player1 and player2 then
    if player1:IsMajor() and (player2:IsMajor() or Utils.PlayerIsMinor(player2Id)) then
      local capital = player1:GetCities():GetCapitalCity();

      if capital then
        local plot = Map.GetPlot(capital:GetX(), capital:GetY());
        if plot then
          if player2:IsMajor() and plot:GetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY) ~= 1 then
            plot:SetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY, 1);
            -- print('plot', player1Id, PATHFINDER_FAITH_MAJOR_CIV_KEY);
          elseif Utils.PlayerIsMinor(player2Id) and plot:GetProperty(PATHFINDER_FAITH_CITYSTATE_KEY) ~= 1 then
            plot:SetProperty(PATHFINDER_FAITH_CITYSTATE_KEY, 1);
            -- print('plot', player1Id, PATHFINDER_FAITH_CITYSTATE_KEY);
          end
        end
      else
        if player2:IsMajor() and player1:GetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY) ~= 1 then
          player1:SetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY, 1);
          -- print('play', player1Id, PATHFINDER_FAITH_MAJOR_CIV_KEY);
        elseif Utils.PlayerIsMinor(player2Id) and player1:GetProperty(PATHFINDER_FAITH_CITYSTATE_KEY) ~= 1 then
          player1:SetProperty(PATHFINDER_FAITH_CITYSTATE_KEY, 1);
          -- print('play', player1Id, PATHFINDER_FAITH_CITYSTATE_KEY);
        end
      end
    end

    if player2:IsMajor() and (player1:IsMajor() or Utils.PlayerIsMinor(player1Id)) then
      local capital = player2:GetCities():GetCapitalCity();

      if capital then
        local plot = Map.GetPlot(capital:GetX(), capital:GetY());
        if plot then
          if player1:IsMajor() and plot:GetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY) ~= 1 then
            plot:SetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY, 1);
            -- print('plot', player2Id, PATHFINDER_FAITH_MAJOR_CIV_KEY);
          elseif Utils.PlayerIsMinor(player1Id) and plot:GetProperty(PATHFINDER_FAITH_CITYSTATE_KEY) ~= 1 then
            plot:SetProperty(PATHFINDER_FAITH_CITYSTATE_KEY, 1);
            -- print('plot', player2Id, PATHFINDER_FAITH_CITYSTATE_KEY);
          end
        end
      else
        if player1:IsMajor() and player2:GetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY) ~= 1 then
          player2:SetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY, 1);
          -- print('play', player2Id, PATHFINDER_FAITH_MAJOR_CIV_KEY);
        elseif Utils.PlayerIsMinor(player1Id) and player2:GetProperty(PATHFINDER_FAITH_CITYSTATE_KEY) ~= 1 then
          player2:SetProperty(PATHFINDER_FAITH_CITYSTATE_KEY, 1);
          -- print('play', player2Id, PATHFINDER_FAITH_CITYSTATE_KEY);
        end
      end
    end

  end
end
Events.DiplomacyMeet.Add(PathFinderDiplomacyMeet);

-- 发现新大陆、自然奇观
local NOTIFICATION_DISCOVER_CONTINENT_HASH = GameInfo.Notifications['NOTIFICATION_DISCOVER_CONTINENT'].Hash
local NOTIFICATION_DISCOVER_NATURAL_WONDER_HASH = GameInfo.Notifications['NOTIFICATION_DISCOVER_NATURAL_WONDER'].Hash
local IsNewContinentKey = 'HD_IsNewContinent';
function PathFinderNotificationAdded(playerId, notificationId)
  local player = Players[playerId];
  if not player then return; end

  local notificationEntry = NotificationManager.Find(playerId, notificationId)
  if notificationEntry then
    local key;
    if notificationEntry:GetType() == NOTIFICATION_DISCOVER_CONTINENT_HASH then
      if player:GetProperty(IsNewContinentKey) ~= 1 then
        player:SetProperty(IsNewContinentKey, 1);
      else
        key = PATHFINDER_FAITH_NEW_CONTINENT_KEY;
      end
    elseif notificationEntry:GetType() == NOTIFICATION_DISCOVER_NATURAL_WONDER_HASH then
      key = PATHFINDER_FAITH_NATURAL_WONDER_KEY;
    end

    if key then
      local capital = player:GetCities():GetCapitalCity();

      if capital then
        local plot = Map.GetPlot(capital:GetX(), capital:GetY());
        if plot and plot:GetProperty(key) ~= 1 then
          plot:SetProperty(key, 1);
          -- print('plot', key);
        end
      elseif player:GetProperty(key) ~= 1 then
        player:SetProperty(key, 1);
        -- print('player', key);
      end
    end
  end
end
Events.NotificationAdded.Add(PathFinderNotificationAdded);

-- 建造首都
function PathFinderBuildCapital(playerId, cityId, x, y)
  local player = Players[playerId]
	local city = CityManager.GetCity(playerId, cityId)

  if player:IsMajor() then
    local capital = player:GetCities():GetCapitalCity();
    if capital and cityId == capital:GetID() then
      -- print(playerId, "建造首都");
      local plot = Map.GetPlot(capital:GetX(), capital:GetY());

      if player:GetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY) == 1 then
        plot:SetProperty(PATHFINDER_FAITH_MAJOR_CIV_KEY, 1);
        -- print('capital', PATHFINDER_FAITH_MAJOR_CIV_KEY);
      end
      if player:GetProperty(PATHFINDER_FAITH_CITYSTATE_KEY) == 1 then
        plot:SetProperty(PATHFINDER_FAITH_CITYSTATE_KEY, 1);
        -- print('capital', PATHFINDER_FAITH_CITYSTATE_KEY);
      end
      if player:GetProperty(PATHFINDER_FAITH_NEW_CONTINENT_KEY) == 1 then
        plot:SetProperty(PATHFINDER_FAITH_NEW_CONTINENT_KEY, 1);
        -- print('capital', PATHFINDER_FAITH_NEW_CONTINENT_KEY);
      end
      if player:GetProperty(PATHFINDER_FAITH_NATURAL_WONDER_KEY) == 1 then
        plot:SetProperty(PATHFINDER_FAITH_NATURAL_WONDER_KEY, 1);
        -- print('capital', PATHFINDER_FAITH_NATURAL_WONDER_KEY);
      end
    end
  end
end

function initialize()
  Events.UnitDamageChanged.Add(UnitDamageChanged);
  Events.CityAddedToMap.Add(PathFinderBuildCapital)
end
Events.LoadGameViewStateDone.Add(initialize);