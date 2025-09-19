-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local POTALA_PALACE_INDEX = GameInfo.Buildings['BUILDING_POTALA_PALACE'].Index;
local POTALA_PALACE_EXTRA_FOUNDER = GlobalParameters.HD_POTALA_PALACE_EXTRA_FOUNDER or 0;
local POTALA_PALACE_EXTRA_ENHANCER = GlobalParameters.HD_POTALA_PALACE_EXTRA_ENHANCER or 0;
local POTALA_PALACE_CAN_ADD_EXTRA_BELIEF_TAG = 'HD_POTALA_PALACE_CAN_ADD_EXTRA_BELIEF'
local POTALA_PALACE_EXTRA_BELIEF_ADDED_TAG = 'HD_POTALA_PALACE_EXTRA_BELIEF_ADDED'

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
function PotalaWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  local localPlayerId = Game.GetLocalPlayer();
  if buildingId == POTALA_PALACE_INDEX and playerId == localPlayerId then
    Refresh()
  end
end

function PotalaLocalPlayerTurnBegin()
  local localPlayerId = Game.GetLocalPlayer();
  local localPlayer = Players[localPlayerId];
  if localPlayer:GetProperty(POTALA_PALACE_CAN_ADD_EXTRA_BELIEF_TAG) == 1 and localPlayer:GetProperty(POTALA_PALACE_EXTRA_BELIEF_ADDED_TAG) ~= 1 then
    Refresh()
  end
end

function PotalaBeliefAdded(playerId)
  local localPlayerId = Game.GetLocalPlayer();
  local localPlayer = Players[localPlayerId];
  if playerId == localPlayerId and localPlayer:GetProperty(POTALA_PALACE_CAN_ADD_EXTRA_BELIEF_TAG) == 1 and localPlayer:GetProperty(POTALA_PALACE_EXTRA_BELIEF_ADDED_TAG) ~= 1 then
    Refresh()
  end
end

function Refresh()
  if POTALA_PALACE_EXTRA_FOUNDER == 0 and POTALA_PALACE_EXTRA_ENHANCER == 0 then
    return;
  end
  local localPlayerId = Game.GetLocalPlayer();
  local localPlayer = Players[localPlayerId];
  local religionId = localPlayer:GetReligion():GetReligionTypeCreated();
  local beliefNum = localPlayer:GetReligion():GetNumBeliefsEarned();
  print("布达拉宫 已有信条数量", beliefNum)
  if religionId ~= -1 and beliefNum == 4 then
    print("布达拉宫 尝试发起通知")
    LuaEvents.Potala_SendNotification()
  end
end

-- ===========================================================================
--	Initialize
-- ===========================================================================
function initialize()
  Events.WonderCompleted.Add(PotalaWonderCompleted);
  Events.LocalPlayerTurnBegin.Add(PotalaLocalPlayerTurnBegin);
  Events.BeliefAdded.Add(PotalaBeliefAdded);
end
Events.LoadScreenClose.Add(initialize);