include "HD_StateUtils"
-- ===========================================================================
--	UTILS
-- ===========================================================================
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local CHINA_TRAIT_MODIFIED = GlobalParameters.HD_CHINA_TRAIT_MODIFIED or 0;

local CHINA_BUILD_WONDER_ERA_TAG = 'HD_CHINA_BUILD_WONDER_ERA_'
local CHINA_BUILD_WONDER_ERA_ALREADY_SELECT_TAG = 'HD_CHINA_BUILD_WONDER_ERA_ALREADY_SELECT_'
local CHINA_FIRST_TURN_TAG = 'HD_CHINA_FIRST_TURN'
local CHINA_FIRST_TURN_ALREADY_SELECT_TAG = 'HD_CHINA_FIRST_TURN_ALREADY_SELECT'

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
function ChinaWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if CHINA_TRAIT_MODIFIED == 0 then return; end

  local localPlayerId = Game.GetLocalPlayer();
  if playerId == localPlayerId and Utils.CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_DYNASTIC_CYCLE') then
    local player = Players[playerId]
    -- 获取奇观所属时代
    local era = Utils.GetBuildingEra(buildingId)
    if player:GetProperty(CHINA_BUILD_WONDER_ERA_TAG .. era) ~= 1 then
      -- 记录首次建造每个时代的奇观
      SetObjectState(player, CHINA_BUILD_WONDER_ERA_TAG .. era, 1)
      -- 发起通知
      print("中国造奇观 发起通知", Locale.Lookup(GameInfo.Eras[era].Name))
      Refresh(era, false)
    end
  end
end

function ChinaLocalPlayerTurnBegin()
  if CHINA_TRAIT_MODIFIED == 0 then return; end

  local localPlayerId = Game.GetLocalPlayer();
  local localPlayer = Players[localPlayerId];
  for era=0,8,1 do
    if localPlayer:GetProperty(CHINA_BUILD_WONDER_ERA_TAG .. era) == 1 and localPlayer:GetProperty(CHINA_BUILD_WONDER_ERA_ALREADY_SELECT_TAG .. era) ~= 1 then
      print("中国造奇观 过回合 发起通知", Locale.Lookup(GameInfo.Eras[era].Name))
      Refresh(era, false)
    end
  end

  if localPlayer:GetProperty(CHINA_FIRST_TURN_TAG) == 1 and localPlayer:GetProperty(CHINA_FIRST_TURN_ALREADY_SELECT_TAG) ~= 1 then
    print("中国开局选择专属远古着力点 过回合 发起通知")
    Refresh(0, true)
  end
end

-- 开局选择一次远古着力点
function ChinaAncientCommemorationFirstTurn(playerId, cityId, x, y)
  if CHINA_TRAIT_MODIFIED == 0 then return; end
  
  local localPlayerId = Game.GetLocalPlayer();
  local localPlayer = Players[localPlayerId];
  if playerId == localPlayerId and Utils.CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_DYNASTIC_CYCLE') and localPlayer:GetProperty(CHINA_FIRST_TURN_TAG) ~= 1 then
    SetObjectState(localPlayer, CHINA_FIRST_TURN_TAG, 1)
    print("中国开局选择专属远古着力点 发起通知")
    Refresh(0, true)
  end
end

function Refresh(era, firstTurn)
  LuaEvents.ChinaChooseCommemoration_SendNotification(era, firstTurn)
end

-- ===========================================================================
--	Initialize
-- ===========================================================================
function initialize()
  Events.WonderCompleted.Add(ChinaWonderCompleted);
  Events.LocalPlayerTurnBegin.Add(ChinaLocalPlayerTurnBegin);
  Events.CityAddedToMap.Add(ChinaAncientCommemorationFirstTurn);
end
Events.LoadScreenClose.Add(initialize);