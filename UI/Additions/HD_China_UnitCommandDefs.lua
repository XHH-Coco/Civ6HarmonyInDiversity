-- ======================================================================================================================================================
--	UTILS
-- ======================================================================================================================================================
if ExposedMembers.DLHD == nil then
  ExposedMembers.DLHD = {};
end
Utils = ExposedMembers.DLHD.Utils;

-- ======================================================================================================================================================
--	CONSTS
-- ======================================================================================================================================================
local PROMOTION_ASSASSINATION_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_ASSASSINATION_HD'].Index;
local PROMOTION_HIJACKING_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_HIJACKING_HD'].Index;
local PROMOTION_INCITE_DEFECTION_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_INCITE_DEFECTION_HD'].Index;
local PROMOTION_RECRUIT_BULIANG_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_RECRUIT_BULIANG_HD'].Index;
local PROMOTION_DESTRUCTION_EXPERT_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_DESTRUCTION_EXPERT_HD'].Index;
local PROMOTION_DEVELOP_DOWNLINES_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_DEVELOP_DOWNLINES_HD'].Index;
local PROMOTION_SECRET_ORDER_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_SECRET_ORDER_HD'].Index;
local PROMOTION_KUNG_FU_MASTER_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_KUNG_FU_MASTER_HD'].Index;
local PROMOTION_ROYAL_GUARD_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_ROYAL_GUARD_HD'].Index;
local PROMOTION_ROYAL_ENVOY_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_ROYAL_ENVOY_HD'].Index;
local PROMOTION_ROYAL_TRIBUTE_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_ROYAL_TRIBUTE_HD'].Index;
local PROMOTION_SECRETS_OF_NATURE_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_SECRETS_OF_NATURE_HD'].Index;

local PROMOTION_USED_TIMES_TAG = 'HD_PLUM_INTERNAL_SECURITY_PROMOTION_USED_TIMES_';

local MAX_TIMES_TABLE = {};
MAX_TIMES_TABLE[PROMOTION_ASSASSINATION_HD_INDEX] = GlobalParameters.HD_PROMOTION_ASSASSINATION_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_HIJACKING_HD_INDEX] = GlobalParameters.HD_PROMOTION_HIJACKING_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_INCITE_DEFECTION_HD_INDEX] = GlobalParameters.HD_PROMOTION_INCITE_DEFECTION_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_RECRUIT_BULIANG_HD_INDEX] = GlobalParameters.HD_PROMOTION_RECRUIT_BULIANG_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_DESTRUCTION_EXPERT_HD_INDEX] = GlobalParameters.HD_PROMOTION_DESTRUCTION_EXPERT_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_DEVELOP_DOWNLINES_HD_INDEX] = GlobalParameters.HD_PROMOTION_DEVELOP_DOWNLINES_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_SECRET_ORDER_HD_INDEX] = GlobalParameters.HD_PROMOTION_SECRET_ORDER_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_KUNG_FU_MASTER_HD_INDEX] = GlobalParameters.HD_PROMOTION_KUNG_FU_MASTER_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_ROYAL_GUARD_HD_INDEX] = GlobalParameters.HD_PROMOTION_ROYAL_GUARD_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_ROYAL_ENVOY_HD_INDEX] = GlobalParameters.HD_PROMOTION_ROYAL_ENVOY_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_ROYAL_TRIBUTE_HD_INDEX] = GlobalParameters.HD_PROMOTION_ROYAL_TRIBUTE_MAX_TIMES or 0;
MAX_TIMES_TABLE[PROMOTION_SECRETS_OF_NATURE_HD_INDEX] = GlobalParameters.HD_PROMOTION_SECRETS_OF_NATURE_MAX_TIMES or 0;

local PROPHET_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_PROPHET'].Index;
local DISTRICT_WONDER_INDEX = GameInfo.Districts['DISTRICT_WONDER'].Index;
local DISTRICT_CITY_CENTER_INDEX = GameInfo.Districts['DISTRICT_CITY_CENTER'].Index;
-- ======================================================================================================================================================
--	FUNCTIONS
-- ======================================================================================================================================================
function GetChinaUnitPromotionRemainingTimes(unit, promotionId)
  local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. promotionId) or 0;
  return MAX_TIMES_TABLE[promotionId] - used;
end
Utils.GetChinaUnitPromotionRemainingTimes = GetChinaUnitPromotionRemainingTimes;

-- ======================================================================================================================================================
--	VARIABLES
-- ======================================================================================================================================================
m_HDChinaUnitCommands = {};

-- ======================================================================================================================================================
--	梅花内卫 刺杀行动
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD = {};
m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.EventName = "HD_Promotion_Assassination";
m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_ASSASSINATION_HD";
m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_ASSASSINATION_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_ASSASSINATION_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_ASSASSINATION_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_ASSASSINATION_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_ASSASSINATION_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_ASSASSINATION_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_ASSASSINATION_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_ASSASSINATION_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否相邻敌方军事单位
  local enabled = false;
  for direction = 0, 5 do
    local adjacentPlot = Map.GetAdjacentPlot(unit:GetX(), unit:GetY(), direction);
    if adjacentPlot then
      local units = Units.GetUnitsInPlot(adjacentPlot:GetX(), adjacentPlot:GetY());
      if units ~= nil then
        for _, adjacentUnit in ipairs(units) do
          local unitInfo = GameInfo.Units[adjacentUnit:GetType()];
          if unitInfo then
            local formationClass = unitInfo.FormationClass;
            if (formationClass == 'FORMATION_CLASS_LAND_COMBAT' or formationClass == 'FORMATION_CLASS_NAVAL' or formationClass == 'FORMATION_CLASS_AIR')
            and adjacentUnit:GetOwner() ~= unit:GetOwner() then
              enabled = true;
              break;
            end
          end
        end
      end
    end
    if enabled then break; end
  end

  return not enabled;
end

-- ======================================================================================================================================================
--	梅花内卫 劫持行动
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD = {};
m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.EventName = "HD_Promotion_Hijacking";
m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_HIJACKING_HD";
m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_HIJACKING_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_HIJACKING_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_HIJACKING_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_HIJACKING_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_HIJACKING_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_HIJACKING_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_HIJACKING_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_HIJACKING_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否相邻敌方平民单位
  local enabled = false;
  for direction = 0, 5 do
    local adjacentPlot = Map.GetAdjacentPlot(unit:GetX(), unit:GetY(), direction);
    if adjacentPlot then
      local units = Units.GetUnitsInPlot(adjacentPlot:GetX(), adjacentPlot:GetY());
      if units ~= nil then
        for _, adjacentUnit in ipairs(units) do
          local unitInfo = GameInfo.Units[adjacentUnit:GetType()];
          if unitInfo then
            local unitType = unitInfo.UnitType;
            if adjacentUnit:GetOwner() ~= unit:GetOwner() then
              for row in GameInfo.UnitCaptures() do
                if row.CapturedUnitType == unitType then
                  enabled = true;
                  break;
                end
              end
              if enabled then break; end
            end
          end
        end
      end
    end
    if enabled then break; end
  end

  return not enabled;
end

-- ======================================================================================================================================================
--	梅花内卫 策反行动
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD = {};
m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.EventName = "HD_Promotion_Incite_Defection";
m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_INCITE_DEFECTION_HD";
m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_INCITE_DEFECTION_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_INCITE_DEFECTION_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_INCITE_DEFECTION_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_INCITE_DEFECTION_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_INCITE_DEFECTION_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_INCITE_DEFECTION_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_INCITE_DEFECTION_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_INCITE_DEFECTION_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否相邻敌方伟人单位
  local playerId = unit:GetOwner();
  local enabled = false;
  for direction = 0, 5 do
    local adjacentPlot = Map.GetAdjacentPlot(unit:GetX(), unit:GetY(), direction);
    if adjacentPlot then
      local units = Units.GetUnitsInPlot(adjacentPlot:GetX(), adjacentPlot:GetY());
      if units ~= nil then
        for _, adjacentUnit in ipairs(units) do
          local ownerId = adjacentUnit:GetOwner();
          local greatPerson = adjacentUnit:GetGreatPerson();
          if ownerId ~= playerId and greatPerson and greatPerson:IsGreatPerson() and greatPerson:GetClass() ~= PROPHET_INDEX then
            enabled = true;
            break;
          end
        end
      end
    end
    if enabled then break; end
  end

  return not enabled;
end

-- ======================================================================================================================================================
--	梅花内卫 招募不良人
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD = {};
m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.EventName = "HD_Promotion_Recruit_Buliang";
m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_RECRUIT_BULIANG_HD";
m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_RECRUIT_BULIANG_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_RECRUIT_BULIANG_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_RECRUIT_BULIANG_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_RECRUIT_BULIANG_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_RECRUIT_BULIANG_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_RECRUIT_BULIANG_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_RECRUIT_BULIANG_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_RECRUIT_BULIANG_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否位于敌方区域
  local plot = Map.GetPlotByIndex(unit:GetPlotId());
  if plot then
    local playerId = unit:GetOwner();
    local ownerId = plot:GetOwner();
    local districtId = plot:GetDistrictType();
    local city = Cities.GetPlotPurchaseCity(plot);

    if city and districtId ~= -1 and districtId ~= DISTRICT_WONDER_INDEX and districtId ~= DISTRICT_CITY_CENTER_INDEX and ownerId ~= playerId
    and Utils.IsDistrictComplete(ownerId, city:GetID(), districtId)
    and Utils.GetAllianceTypeBetweenPlayers(playerId, ownerId) == -1 then
      return false;
    end
  end

  return true;
end

-- ======================================================================================================================================================
--	梅花内卫 发展下线
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD = {};
m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.EventName = "HD_Promotion_Develop_Downlines";
m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_DEVELOP_DOWNLINES_HD";
m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_DEVELOP_DOWNLINES_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_DEVELOP_DOWNLINES_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_DEVELOP_DOWNLINES_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_DEVELOP_DOWNLINES_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_DEVELOP_DOWNLINES_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_DEVELOP_DOWNLINES_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_DEVELOP_DOWNLINES_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_DEVELOP_DOWNLINES_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否位于敌方区域
  local plot = Map.GetPlotByIndex(unit:GetPlotId());
  if plot then
    local playerId = unit:GetOwner();
    local ownerId = plot:GetOwner();
    local districtId = plot:GetDistrictType();
    local city = Cities.GetPlotPurchaseCity(plot);

    if city and districtId ~= -1 and districtId ~= DISTRICT_WONDER_INDEX and districtId ~= DISTRICT_CITY_CENTER_INDEX and ownerId ~= playerId
    and Utils.IsDistrictComplete(ownerId, city:GetID(), districtId) then
      return false;
    end
  end

  return true;
end

-- ======================================================================================================================================================
--	梅花内卫 破坏专家
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD = {};
m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.EventName = "HD_Promotion_Destruction_Expert";
m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_DESTRUCTION_EXPERT_HD";
m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_DESTRUCTION_EXPERT_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_DESTRUCTION_EXPERT_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_DESTRUCTION_EXPERT_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_DESTRUCTION_EXPERT_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_DESTRUCTION_EXPERT_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_DESTRUCTION_EXPERT_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_DESTRUCTION_EXPERT_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_DESTRUCTION_EXPERT_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否位于敌方区域
  local plot = Map.GetPlotByIndex(unit:GetPlotId());
  if plot then
    local playerId = unit:GetOwner();
    local ownerId = plot:GetOwner();
    local districtId = plot:GetDistrictType();
    local city = Cities.GetPlotPurchaseCity(plot);

    if city and districtId ~= -1 and districtId ~= DISTRICT_WONDER_INDEX and districtId ~= DISTRICT_CITY_CENTER_INDEX and ownerId ~= playerId
    and Utils.IsDistrictComplete(ownerId, city:GetID(), districtId) then
      return false;
    end
  end

  return true;
end

-- ======================================================================================================================================================
--	梅花内卫 梅花密令
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD = {};
m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD.EventName = "HD_Promotion_Secret_Order";
m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_SECRET_ORDER_HD";
m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD.VisibleInUI = true;

m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_SECRET_ORDER_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_SECRET_ORDER_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_SECRET_ORDER_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_SECRET_ORDER_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_SECRET_ORDER_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_SECRET_ORDER_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_SECRET_ORDER_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_SECRET_ORDER_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否位于我方市中心
  local plot = Map.GetPlotByIndex(unit:GetPlotId());
  if plot then
    local playerId = unit:GetOwner();
    local ownerId = plot:GetOwner();
    local districtId = plot:GetDistrictType();

    if districtId == DISTRICT_CITY_CENTER_INDEX and ownerId == playerId then
      return false;
    end
  end

  return true;
end

-- ======================================================================================================================================================
--	梅花内卫 大内高手
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD = {};
m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.EventName = "HD_Promotion_Kung_Fu_Master";
m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_KUNG_FU_MASTER_HD";
m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_KUNG_FU_MASTER_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_KUNG_FU_MASTER_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_KUNG_FU_MASTER_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_KUNG_FU_MASTER_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_KUNG_FU_MASTER_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_KUNG_FU_MASTER_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_KUNG_FU_MASTER_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_KUNG_FU_MASTER_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否位于我方军事单位
  local plot = Map.GetPlotByIndex(unit:GetPlotId());
  local enabled = false;
  if plot then
    local units = Units.GetUnitsInPlot(plot:GetX(), plot:GetY());
    if units ~= nil then
      for _, pUnit in ipairs(units) do
        local unitInfo = GameInfo.Units[pUnit:GetType()];
        if unitInfo then
          local formationClass = unitInfo.FormationClass;
          if (formationClass == 'FORMATION_CLASS_LAND_COMBAT' or formationClass == 'FORMATION_CLASS_NAVAL' or formationClass == 'FORMATION_CLASS_AIR')
          and pUnit:GetOwner() == unit:GetOwner() then
            local nextExp = pUnit:GetExperience():GetExperienceForNextLevel();
            local nowExp = pUnit:GetExperience():GetExperiencePoints();
						if nextExp > nowExp and nowExp >= 0 then
							enabled = true;
              break;
						end
          end
        end
      end
    end
  end

  return not enabled;
end

-- ======================================================================================================================================================
--	梅花内卫 皇家禁军
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD = {};
m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.EventName = "HD_Promotion_Royal_Guard";
m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_ROYAL_GUARD_HD";
m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_ROYAL_GUARD_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_ROYAL_GUARD_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_ROYAL_GUARD_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_ROYAL_GUARD_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_ROYAL_GUARD_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_ROYAL_GUARD_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_ROYAL_GUARD_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_ROYAL_GUARD_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否位于我方军事单位
  local plot = Map.GetPlotByIndex(unit:GetPlotId());
  local enabled = false;
  if plot then
    local units = Units.GetUnitsInPlot(plot:GetX(), plot:GetY());
    if units ~= nil then
      for _, pUnit in ipairs(units) do
        local unitInfo = GameInfo.Units[pUnit:GetType()];
        if unitInfo then
          local formationClass = unitInfo.FormationClass;
          local militaryFormation = pUnit:GetMilitaryFormation();
          if formationClass == 'FORMATION_CLASS_LAND_COMBAT'
          and pUnit:GetOwner() == unit:GetOwner()
          and (militaryFormation ~= MilitaryFormationTypes.CORPS_FORMATION and militaryFormation ~= MilitaryFormationTypes.ARMY_FORMATION) then
            enabled = true;
            break;
          end
        end
      end
    end
  end

  return not enabled;
end

-- ======================================================================================================================================================
--	梅花内卫 皇家特使
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD = {};
m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.EventName = "HD_Promotion_Royal_Envoy";
m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_ROYAL_ENVOY_HD";
m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_ROYAL_ENVOY_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_ROYAL_ENVOY_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_ROYAL_ENVOY_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_ROYAL_ENVOY_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_ROYAL_ENVOY_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_ROYAL_ENVOY_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_ROYAL_ENVOY_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_ROYAL_ENVOY_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否位于城邦境内
  local plot = Map.GetPlotByIndex(unit:GetPlotId());
  if plot then
    local ownerId = plot:GetOwner();
    local owner = Players[ownerId];
    if owner and owner:IsMinor() and owner:GetInfluence():CanReceiveInfluence() then
      return false;
    end
  end
  
  return true;
end

-- ======================================================================================================================================================
--	梅花内卫 皇家贡品
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD = {};
m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.EventName = "HD_Promotion_Royal_Tribute";
m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_ROYAL_TRIBUTE_HD";
m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_ROYAL_TRIBUTE_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_ROYAL_TRIBUTE_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_ROYAL_TRIBUTE_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_ROYAL_TRIBUTE_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_ROYAL_TRIBUTE_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_ROYAL_TRIBUTE_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_ROYAL_TRIBUTE_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_ROYAL_TRIBUTE_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否有奢侈资源
  local plot = Map.GetPlotByIndex(unit:GetPlotId());
  if plot then
    local playerId = unit:GetOwner();
    local ownerId = plot:GetOwner();
    local resourceId = plot:GetResourceType();
    local resourceInfo = GameInfo.Resources[resourceId];
    if ownerId ~= playerId and resourceInfo and resourceInfo.ResourceClassType == "RESOURCECLASS_LUXURY" then
      return false;
    end
  end
  
  return true;
end

-- ======================================================================================================================================================
--	梅花内卫 山水秘闻
-- ======================================================================================================================================================
m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD = {};
m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.Properties = {};

m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.EventName = "HD_Promotion_Secrets_Of_Nature";
m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.CategoryInUI = "SPECIFIC";
m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.Icon = "ICON_UNITCOMMAND_PROMOTION_SECRETS_OF_NATURE_HD";
m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.VisibleInUI = true;
m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.DoNotDelete = true;

m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.GetToolTipString = function(unit)
  if unit == nil then return ""; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_SECRETS_OF_NATURE_HD_INDEX)
  return Locale.Lookup("LOC_PROMOTION_SECRETS_OF_NATURE_HD_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_PROMOTION_SECRETS_OF_NATURE_HD_DESCRIPTION") .. Locale.Lookup('LOC_PROMOTION_REMAIN_TIMES_TEXT', remains);
end

m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_PROMOTION_SECRETS_OF_NATURE_HD_DISABLED");
end

function m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.CanUse(unit)
  if unit == nil then return false; end
  if not unit:GetExperience():HasPromotion(PROMOTION_SECRETS_OF_NATURE_HD_INDEX) then return false; end
  local remains = GetChinaUnitPromotionRemainingTimes(unit, PROMOTION_SECRETS_OF_NATURE_HD_INDEX)
  return remains > 0;
end

function m_HDChinaUnitCommands.PROMOTION_SECRETS_OF_NATURE_HD.IsDisabled(unit)
  if unit == nil then return true; end
  if not unit:GetExperience():HasPromotion(PROMOTION_SECRETS_OF_NATURE_HD_INDEX) then return true; end
  if unit:GetMovesRemaining() == 0 then return true; end

  -- 检测是否相邻或位于自然奇观
  local enabled = false;
  local plots = Map.GetNeighborPlots(unit:GetX(), unit:GetY(), 1);
  for _, plot in ipairs(plots) do
    if plot and plot:IsNaturalWonder() then
      enabled = true;
      break;
    end
  end
  
  return not enabled;
end