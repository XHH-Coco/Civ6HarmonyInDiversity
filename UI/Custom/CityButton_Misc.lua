-- ===========================================================================
-- Utils
-- ===========================================================================
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

local GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_BASE = GlobalParameters.HD_GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_BASE or 0;
local GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_PER_TRADINGPOST = GlobalParameters.HD_GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_PER_TRADINGPOST or 0;

local MAGNANIMOUS_COMPLETE_DISTRICT_BUILDING_TAG = 'HD_MAGNANIMOUS_COMPLETE_DISTRICT_BUILDING';
local GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_NUM_TAG = 'HD_GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_NUM';
local GOVERNOR_MERCHANT_RIGHT_3_TRADE_ROUTE_YIELD_LIST_TAG = 'HD_GOVERNOR_MERCHANT_RIGHT_3_TRADE_ROUTE_YIELD_LIST';
-- ===========================================================================
-- Base Functions
-- ===========================================================================
function MiscButtonReset()
  -- 获取城市对象，玩家当前UI选中的城市
  local city = UI.GetHeadSelectedCity();
  -- 判断是否显示按钮
  if city then
    local playerId = city:GetOwner();
    local player = Players[playerId];
    if player then
      local toolTipStr = "";
      local textList = {};

      -- 巴西 免费区域建造次数
      if Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_MAGNANIMOUS') then
        local times = Utils.GetPlayerProperty(playerId, MAGNANIMOUS_COMPLETE_DISTRICT_BUILDING_TAG) or 0;
        if times >= 0 then
          table.insert(textList, Locale.Lookup('LOC_TRAIT_LEADER_MAGNANIMOUS_NAME') .. '[NEWLINE][ICON_BULLET]' .. Locale.Lookup('LOC_TRAIT_LEADER_MAGNANIMOUS_BUILD_TIMES_TEXT', times));
        end
      end

      -- 瑞娜右三
      if Utils.CityHasAssignedGovernorPromotion(playerId, city:GetID(), 'GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_3') then
        local tradingPostNum = Utils.GetPlayerProperty(playerId, GOVERNOR_MERCHANT_RIGHT_3_TRADINGPOST_NUM_TAG) or 0;
        local factor = GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_BASE + tradingPostNum * GOVERNOR_MERCHANT_RIGHT_3_TRADE_YIELD_PERCENTAGE_PER_TRADINGPOST;
        local text = Locale.Lookup('LOC_GOVERNOR_PROMOTION_HD_MERCHANT_RIGHT_3_BUTTON_TEXT', factor);

        local yieldList = city:GetProperty(GOVERNOR_MERCHANT_RIGHT_3_TRADE_ROUTE_YIELD_LIST_TAG) or {};
        for row in GameInfo.Yields() do
          text = text .. '[NEWLINE][ICON_BULLET]+' .. math.floor(yieldList[row.Index] or 0) .. ' ' .. row.IconString .. ' ' .. Locale.Lookup(row.Name);
        end

        table.insert(textList, text);
      end
      
      if #textList > 0 then
        for i, str in ipairs(textList) do
          if i > 1 then toolTipStr = toolTipStr .. '[NEWLINE][NEWLINE]'; end
          toolTipStr = toolTipStr .. str;
        end
        Controls.Misc_Button_Stack:SetHide(false);
        Controls.Misc_Button:SetToolTipString(toolTipStr);
      else
        Controls.Misc_Button_Stack:SetHide(true);
      end
    else
      Controls.Misc_Button_Stack:SetHide(true);
    end
  else
    Controls.Misc_Button_Stack:SetHide(true);
  end
end

-- ===========================================================================
-- Events Functions
-- ===========================================================================
--添加按钮到城市面板
function AddMiscButton()
  local context = ContextPtr:LookUpControl("/InGame/CityPanel/ActionStack")
  if context then
      Controls.Misc_Button_Stack:ChangeParent(context)
      -- 刷新按钮
      MiscButtonReset()
  end
end

-- 城市选中时
function MiscCitySelectChange(ownerId, cityId, i, j, k, isSelected)
  -- 获得本地玩家
  local loaclPlayerId = Game.GetLocalPlayer()
  -- 本地玩家是否与触发该事件的玩家一致，是否选中城市
  if ownerId == loaclPlayerId and isSelected then
      -- 是，且选中城市
      -- 刷新按钮
      MiscButtonReset()
  end
  -- 这个函数似乎有点多余
end

-- ===========================================================================
-- Initialize
-- ===========================================================================
function Initialize()
  -------------------Events-------------------
  Events.LoadGameViewStateDone.Add(AddMiscButton)
  Events.CitySelectionChanged.Add(MiscCitySelectChange)
  -------------------Resets-------------------
  -- 本地玩家换了后刷新一遍
  Events.LocalPlayerChanged.Add(MiscButtonReset)

  -- 刷新按钮的时机
  Events.CityAddedToMap.Add(MiscButtonReset)
  Events.CityProductionQueueChanged.Add(MiscButtonReset)
  Events.CityProductionUpdated.Add(MiscButtonReset)
  Events.CityProductionChanged.Add(MiscButtonReset)
  Events.CityProductionCompleted.Add(MiscButtonReset)
  Events.CityPopulationChanged.Add(MiscButtonReset)
  Events.TurnEnd.Add(MiscButtonReset)

  --------------------------------------------
  print('Initial success!')
end

Initialize()