-- ===========================================================================
-- UTILS
-- ===========================================================================
ExposedMembers.HD_CustomEvent_Utils = ExposedMembers.HD_CustomEvent_Utils or {};
HD_CustomEvent_Utils = ExposedMembers.HD_CustomEvent_Utils;

-- 获取随机数
function GetRandNum(max, reason)
	return Game.GetRandNum(max, reason)
end
HD_CustomEvent_Utils.GetRandNum = GetRandNum;

function CustomEvent_AttachModifierToPlayer(playerId, param)
  local player = Players[playerId];
  local selectionInfo = GameInfo.HD_CustomEventSelections[param.SelectionId];

  if player and selectionInfo then
    -- attach modifier by id
    for row in GameInfo.HD_CustomEventSelectionModifiers() do
      if row.SelectionType == selectionInfo.SelectionType then
        player:AttachModifierByID(row.ModifierId);
      end
    end
  end
end
GameEvents.HD_CustomEvent_OnChooseSelection.Add(CustomEvent_AttachModifierToPlayer);