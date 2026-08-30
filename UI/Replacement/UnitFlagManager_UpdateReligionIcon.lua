-- =================================================================================
-- Import base file
-- =================================================================================
local files = {
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

-- 建造次数显示
-- =================================================================================
-- Cache base functions
-- =================================================================================
local BASE_Subscribe        = Subscribe;
local BASE_Unsubscribe      = Unsubscribe;
local BASE_UpdatePromotions = UnitFlag.UpdatePromotions;

-- =================================================================================
-- Overrides
-- =================================================================================
function OnUnitChargesChanged(playerID, unitID)
    local flagInstance = GetUnitFlag(playerID, unitID);
    if flagInstance ~= nil then 
        flagInstance:UpdatePromotions();
    end
end

function UnitFlag.UpdatePromotions(self)
    local unit = self:GetUnit();
    if unit ~= nil and unit:GetUnitType() ~= -1 then
        local unitType = GameInfo.Units[unit:GetUnitType()].UnitType;
        if unitType == "UNIT_BUILDER"
        or unitType == "UNIT_SAPPER"
        or unitType == "UNIT_MILITARY_ENGINEER"
        or unitType == "UNIT_ENGINEER_CORP"
        or unitType == "UNIT_AUS_MINER"
        or unitType == "UNIT_AUS_HERDER"
        or unitType == "UNIT_AUS_FISHERMAN"
        or unitType == "UNIT_LEU_TYCOON"
        or unitType == "UNIT_LEU_INVESTOR"
        or unitType == "UNIT_ZIMBABWE_PATHFINDER"
        or unitType == "UNIT_SUK_JAHAZI" then
            -- The unit is a builder or military engineer, try updating it's builder charges.
            local buildCharges = unit:GetBuildCharges();
            if buildCharges > 0 then
                -- Only need to update if has charges.
                self.m_Instance.UnitNumPromotions:SetText(buildCharges);
                self.m_Instance.Promotion_Flag:SetHide(false);
            end
            return;
        end
    end
    BASE_UpdatePromotions(self);
end

function Subscribe()
    BASE_Subscribe();
    Events.UnitChargesChanged.Add(OnUnitChargesChanged);
end

function Unsubscribe()
    BASE_Unsubscribe();
    Events.UnitChargesChanged.Remove(OnUnitChargesChanged);
end