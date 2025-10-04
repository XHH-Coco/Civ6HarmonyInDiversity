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

function initialize()
  Events.UnitDamageChanged.Add(UnitDamageChanged)
end
Events.LoadGameViewStateDone.Add(initialize);