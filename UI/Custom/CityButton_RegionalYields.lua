-- ===========================================================================
-- Utils
-- ===========================================================================
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

local CITY_REGIONAL_YIELDS_RECORD_TAG = 'HD_CITY_REGIONAL_YIELDS_RECORD';
-- ===========================================================================
-- Base Functions
-- ===========================================================================
function RegionalYieldsButtonReset()
  -- 获取城市对象，玩家当前UI选中的城市
  local city = UI.GetHeadSelectedCity()
  -- 判断是否显示按钮
  if city then
    local hasAnyBuilding = false;
    local toolTipStr = "";
    local dataList = Utils.GetCityProperty(city:GetOwner(), city:GetID(), CITY_REGIONAL_YIELDS_RECORD_TAG) or {};
    local textList = {};
    local totalList = {};

    for buildingType, yieldList in pairs(dataList) do
      local buildingInfo = GameInfo.Buildings[buildingType];
      for yieldType, powerList in pairs(yieldList) do
        local yieldInfo = GameInfo.HD_BuildingRegionalYieldTypes[yieldType];
        if textList[yieldType] == nil then
          textList[yieldType] = {};
        end

        for powerTag, data in pairs(powerList) do
          if buildingInfo and yieldInfo then
            totalList[yieldType] = (totalList[yieldType] or 0) + data.Amount;

            local text = Locale.Lookup(
              'LOC_CITY_REGIONAL_YIELD_DETAILS_TEXT',
              data.Amount,
              yieldInfo.IconString,
              yieldInfo.Name,
              buildingInfo.Name,
              powerTag == 'POWERED' and '[ICON_POWER]' or '',
              data.CityName
            );

            table.insert(textList[yieldType], {
              Amount = data.Amount,
              Text = text
            })
          end
        end
      end
    end

    for row in GameInfo.HD_BuildingRegionalYieldTypes() do
      local list = textList[row.YieldType];
      if list then 
        table.sort(list, function(a, b) return a.Amount < b.Amount; end)

        if toolTipStr ~= '' then
          toolTipStr = toolTipStr .. '[NEWLINE][NEWLINE]';
        end

        local totalAmount = totalList[row.YieldType] or 0;
        toolTipStr = toolTipStr .. Locale.Lookup('LOC_CITY_REGIONAL_YIELD_TOTAL_TEXT', totalAmount, row.IconString, row.Name)

        for _, textData in ipairs(list) do
          toolTipStr = toolTipStr .. '[NEWLINE][ICON_BULLET] ' .. textData.Text;
        end
      end
    end

    if toolTipStr ~= '' then
      Controls.RegionalYields_Button_Stack:SetHide(false)
      Controls.RegionalYields_Button:SetToolTipString(toolTipStr)
    else
      Controls.RegionalYields_Button_Stack:SetHide(false)
      Controls.RegionalYields_Button:SetToolTipString(Locale.Lookup('LOC_CITY_REGIONAL_YIELD_NON_TEXT'))
    end
  end
end

-- ===========================================================================
-- Events Functions
-- ===========================================================================
--添加按钮到城市面板
function AddRegionalYieldsButton()
  local context = ContextPtr:LookUpControl("/InGame/CityPanel/ActionStack")
  if context then
      Controls.RegionalYields_Button_Stack:ChangeParent(context)
      -- 刷新按钮
      RegionalYieldsButtonReset()
  end
end

-- 城市选中时
function RegionalYieldsCitySelectChange(ownerId, cityId, i, j, k, isSelected)
  -- 获得本地玩家
  local loaclPlayerId = Game.GetLocalPlayer()
  -- 本地玩家是否与触发该事件的玩家一致，是否选中城市
  if ownerId == loaclPlayerId and isSelected then
      -- 是，且选中城市
      -- 刷新按钮
      RegionalYieldsButtonReset()
  end
  -- 这个函数似乎有点多余
end

-- ===========================================================================
-- Initialize
-- ===========================================================================
function Initialize()
  -------------------Events-------------------
  Events.LoadGameViewStateDone.Add(AddRegionalYieldsButton)
  Events.CitySelectionChanged.Add(RegionalYieldsCitySelectChange)
  -------------------Resets-------------------
  -- 本地玩家换了后刷新一遍
  Events.LocalPlayerChanged.Add(RegionalYieldsButtonReset)

  -- 刷新按钮的时机
  Events.CityAddedToMap.Add(RegionalYieldsButtonReset)
  Events.CityProductionQueueChanged.Add(RegionalYieldsButtonReset)
  Events.CityProductionUpdated.Add(RegionalYieldsButtonReset)
  Events.CityProductionChanged.Add(RegionalYieldsButtonReset)
  Events.CityProductionCompleted.Add(RegionalYieldsButtonReset)
  Events.CityPopulationChanged.Add(RegionalYieldsButtonReset)
  Events.TurnEnd.Add(RegionalYieldsButtonReset)

  --------------------------------------------
  print('Initial success!')
end

Initialize()