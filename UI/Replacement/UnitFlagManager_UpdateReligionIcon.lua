-- =================================================================================
-- Import base file
-- =================================================================================
local files = {
  "UnitFlagManager_BuilderCharges.lua",
  "UnitFlagManager_BarbarianClansMode.lua",
  "UnitFlagManager.lua",
}

for _, file in ipairs(files) do
  include(file)
  if Initialize then
      print("Loading " .. file .. " as base file");
      break
  end
end

include "HD_StateUtils"

-- =================================================================================
-- Consts
-- =================================================================================
local NEED_REFRESH_RELIGION_FLAG_TAG = 'HD_NEED_REFRESH_RELIGION_FLAG';

-- =================================================================================
-- Functions
-- =================================================================================
-- 手动刷新单位宗教图标
function UpdateUnitReligionIcon(param)
  local playerId = param.playerId;
  local unitId = param.unitId;
  
  if ExposedMembers.DLHD.Utils.GetUnitProperty(playerId, unitId, NEED_REFRESH_RELIGION_FLAG_TAG) == 1 then
    local unit = UnitManager.GetUnit(playerId, unitId);
    local unitFlag = GetUnitFlag(playerId, unitId);
    -- print('UpdateUnitReligionIcon', unit, unitFlag)
    if unit and unitFlag then
      unitFlag:UpdateReligion();
      -- print('手动刷新单位宗教图标');
      SetObjectState(unit, NEED_REFRESH_RELIGION_FLAG_TAG, 0);
    end
  end
end
LuaEvents.HD_UpdateUnitReligionIcon.Add(UpdateUnitReligionIcon);

