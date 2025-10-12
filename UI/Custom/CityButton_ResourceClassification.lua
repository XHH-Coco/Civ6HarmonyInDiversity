-- ===========================================================================
-- Utils
-- ===========================================================================
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- ===========================================================================
-- Base Functions
-- ===========================================================================
function ResourceClassificationButtonReset()
  -- 获取城市对象，玩家当前UI选中的城市
  local city = UI.GetHeadSelectedCity()
  -- 判断是否显示按钮
  if city then
    local hasAnyBuilding = false;
    local toolTipStr = "";
    local BuildingNeedDetectList = Utils.BuildingNeedDetectList or {};

    -- 检测玩家拥有的资源
    local BuildingNeedDetectPlayerResourceList = BuildingNeedDetectList['PLAYER'] or {};
    for buildingType, propertyKeyList in pairs(BuildingNeedDetectPlayerResourceList) do
      -- 判断城市是否有依赖资源分类的建筑
      local buildingInfo = GameInfo.Buildings[buildingType];
      if buildingInfo ~= nil and city:GetBuildings():HasBuilding(buildingInfo.Index) then
        if hasAnyBuilding == true then
          toolTipStr = toolTipStr .. "[NEWLINE][NEWLINE]"
        end
        
        hasAnyBuilding = true;
        toolTipStr = toolTipStr .. "[COLOR:ResProductionLabelCS]" .. Locale.Lookup(buildingInfo.Name) .. "[ENDCOLOR][NEWLINE]"

        local totalNum, data = Utils.GetBuildingNeedPlayerResource(city:GetOwner(), buildingType);
  
        toolTipStr = toolTipStr .. Locale.Lookup('LOC_BUILDING_PLAYER_RESOURCE_TOTAL_TOOLTIP_TEXT', totalNum)
        
        for classificationType, detail in pairs(data) do
          toolTipStr = toolTipStr .. "[NEWLINE]" .. Locale.Lookup('LOC_BUILDING_PLAYER_RESOURCE_CLASSIFICATION_TOOLTIP_TEXT', detail.Amount, GameInfo.HD_ResourceClassificationTypes[classificationType].Name)
          
          if detail.Amount > 0 then
            toolTipStr = toolTipStr .. ':' .. detail.ResourceString;
          end
        end
      end
    end

    -- TODO: 检测城市拥有的资源

    -- 若有相关建筑，显示ToolTip
    if hasAnyBuilding == true then
      Controls.ResourceClassification_Button_Stack:SetHide(false)
      Controls.ResourceClassification_Button:SetToolTipString(toolTipStr)
    else
      Controls.ResourceClassification_Button_Stack:SetHide(true)
      Controls.ResourceClassification_Button:SetToolTipString("")
    end
  end
end

-- ===========================================================================
-- Events Functions
-- ===========================================================================
--添加按钮到城市面板
function AddResourceClassificationButton()
  local context = ContextPtr:LookUpControl("/InGame/CityPanel/ActionStack")
  if context then
      Controls.ResourceClassification_Button_Stack:ChangeParent(context)
      -- 刷新按钮
      ResourceClassificationButtonReset()
  end
end

-- 城市选中时
function ResourceClassificationCitySelectChange(ownerId, cityId, i, j, k, isSelected)
  -- 获得本地玩家
  local loaclPlayerId = Game.GetLocalPlayer()
  -- 本地玩家是否与触发该事件的玩家一致，是否选中城市
  if ownerId == loaclPlayerId and isSelected then
      -- 是，且选中城市
      -- 刷新按钮
      ResourceClassificationButtonReset()
  end
  -- 这个函数似乎有点多余
end

-- ===========================================================================
-- Initialize
-- ===========================================================================
function Initialize()
  -------------------Events-------------------
  Events.LoadGameViewStateDone.Add(AddResourceClassificationButton)
  Events.CitySelectionChanged.Add(ResourceClassificationCitySelectChange)
  -------------------Resets-------------------
  -- 本地玩家换了后刷新一遍
  Events.LocalPlayerChanged.Add(ResourceClassificationButtonReset)

  -- 刷新按钮的时机
  Events.CityAddedToMap.Add(ResourceClassificationButtonReset)
  Events.CityProductionQueueChanged.Add(ResourceClassificationButtonReset)
  Events.CityProductionUpdated.Add(ResourceClassificationButtonReset)
  Events.CityProductionChanged.Add(ResourceClassificationButtonReset)
  Events.CityProductionCompleted.Add(ResourceClassificationButtonReset)
  Events.CityPopulationChanged.Add(ResourceClassificationButtonReset)
  Events.TurnEnd.Add(ResourceClassificationButtonReset)

  --------------------------------------------
  print('Initial success!')
end

Initialize()