-- ===========================================================================
include("InstanceManager");

ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;
-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local cityStateSelectionIM: table = InstanceManager:new("CityStateSelectionInstance", "CityStateSelection", Controls.CityStateSelectionStack);

local selectedCityStateIndex = -1;
local x = -1;
local y = -1;
local onStart = nil;
local scriptParam = nil;

local CITY_STATE_TYPE_TAG = 'HD_CITY_STATE_TYPE';
-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
function OnCityStateSelectionPanelPopup(param)
	local playerId = param.PlayerId;
	
	-- 判断本地玩家
	if playerId == -1 or playerId ~= Game.GetLocalPlayer() then return; end

	-- 记录单元格坐标
	x = param.X;
	y = param.Y;
  -- 记录脚本名
  onStart = param.OnStart;
	-- 记录脚本参数
	scriptParam = param.ScriptParam;

	-- 设置文本/图标
	if param.HeaderTitle then
		Controls.HeaderTitle:SetText(param.HeaderTitle);
	else
		Controls.HeaderTitle:SetText(Locale.Lookup('LOC_HD_CITYSTATE_SELECTION_MAIN_TITLE'));
	end

	if param.SubheaderIcon then
		Controls.SubheaderIcon:SetIcon(param.SubheaderIcon);
	else
		Controls.SubheaderIcon:SetIcon('ICON_IMPROVEMENT_FARM');
	end

	if param.SubheaderLabel then
		Controls.SubheaderLabel:SetText(param.SubheaderLabel);
	else
		Controls.SubheaderLabel:SetText('');
	end

	if param.CityStateListTitle then
		Controls.CityStateListTitle:SetText(param.CityStateListTitle);
	else
		Controls.CityStateListTitle:SetText(Locale.Lookup('LOC_HD_CITYSTATE_SELECTION_LIST_SUBTITLE'));
	end

	if param.CityStateDetailTitle then
		Controls.CityStateDetailTitle:SetText(param.CityStateDetailTitle);
	else
		Controls.CityStateDetailTitle:SetText(Locale.Lookup('LOC_HD_CITYSTATE_SELECTION_DETAIL_SUBTITLE'));
	end

	-- 重置被选中城邦相关信息
	Controls.SelectedCityStateIcon:SetHide(true);
	Controls.SelectedCityStateDetailLabel:SetText("");
	-- 启用确认按钮
	Controls.Confirm:SetDisabled(true);

	-- 选择相关参数
	selectedCityStateIndex = -1;

	-- 生成待选城邦列表
	cityStateSelectionIM:ResetInstances();
  local list = param.CityStateList or {};
	if #list > 0 then
		-- 隐藏没有可用城邦文本提示
		Controls.NoAvailableCityStateLabel:SetHide(true);

		-- 根据城邦类型排序
		table.sort(list, function(a, b)
      local typeA = Utils.GetPlayerProperty(a.CityStatePlayerId, CITY_STATE_TYPE_TAG) or "";
			local typeB = Utils.GetPlayerProperty(b.CityStatePlayerId, CITY_STATE_TYPE_TAG) or "";
			local nameA = PlayerConfigurations[a.CityStatePlayerId]:GetCivilizationShortDescription();
			local nameB = PlayerConfigurations[b.CityStatePlayerId]:GetCivilizationShortDescription();

      if a.Disabled ~= b.Disabled then
        return b.Disabled;
      end

			if typeA == typeB then
        return nameA < nameB;
      else
        return typeA < typeB;
      end
		end)

		for _, data in ipairs(list) do
			local instance = cityStateSelectionIM:GetInstance();
      local cfg = PlayerConfigurations[data.CityStatePlayerId];

      -- 判断是否能够被选择
      if data.Disabled == true then
        -- 设置图片
        instance.CityStateIcon:SetIcon('ICON_' .. cfg:GetCivilizationTypeName());
        local primaryColor, secondaryColor = UI.GetPlayerColors(data.CityStatePlayerId);
        instance.CityStateIcon:SetColor(secondaryColor);
        -- 设置ToolTip
        local toolTipStr = Locale.Lookup(cfg:GetLeaderName());
        -- 城邦专属资源
        if data.DetailParam and data.DetailParam.CityStateResource then
          local resourceInfo = GameInfo.Resources[data.DetailParam.CityStateResource];
          if resourceInfo then
            toolTipStr = toolTipStr .. Locale.Lookup('LOC_IMPROVEMENT_TRANSNATIONAL_SELECTION_TOOLTIP', '[ICON_' .. data.DetailParam.CityStateResource .. ']', resourceInfo.Name)
          end
        end
        if data.DisabledReason then toolTipStr = toolTipStr .. '[NEWLINE][NEWLINE]' .. Locale.Lookup(data.DisabledReason); end
        instance.SelectButton:SetToolTipString(toolTipStr);
        -- 设置按钮可用性
        instance.SelectButton:SetDisabled(true);
      else
        -- 设置图片
        instance.CityStateIcon:SetIcon('ICON_' .. cfg:GetCivilizationTypeName());
        local primaryColor, secondaryColor = UI.GetPlayerColors(data.CityStatePlayerId);
        instance.CityStateIcon:SetColor(secondaryColor);
        -- 设置ToolTip
        local toolTipStr = Locale.Lookup(cfg:GetLeaderName());
        -- 城邦专属资源
        if data.DetailParam and data.DetailParam.CityStateResource then
          local resourceInfo = GameInfo.Resources[data.DetailParam.CityStateResource];
          if resourceInfo then
            toolTipStr = toolTipStr .. Locale.Lookup('LOC_IMPROVEMENT_TRANSNATIONAL_SELECTION_TOOLTIP', '[ICON_' .. data.DetailParam.CityStateResource .. ']', resourceInfo.Name)
          end
        end
        instance.SelectButton:SetToolTipString(toolTipStr);
        -- 设置按钮可用性
        instance.SelectButton:SetDisabled(false);
        -- 注册事件
        instance.SelectButton:RegisterCallback(Mouse.eLClick, function() OnSelect(data.CityStatePlayerId, data.DetailParam); end);
      end
		end
	else
		-- 如果城邦列表为空 显示没有可用城邦文本提示
		Controls.NoAvailableCityStateLabel:SetHide(false);
		print('待选城邦列表为空');
	end

	-- 显示界面
	ContextPtr:SetHide(false);
end

function OnSelect(cityStatePlayerId, param)
  local detailParam = param or {};
  local detailStrList = {};

	if detailParam.CityStateResource then
    -- 城邦专属资源详情
    local resourceInfo = GameInfo.Resources[detailParam.CityStateResource];
	  if not resourceInfo then return; end

    -- 设置被选中资源图标
    Controls.SelectedCityStateIcon:SetHide(false);
    Controls.SelectedCityStateIcon:SetIcon('ICON_MONOPOLIES_AND_CORPS_' .. resourceInfo.ResourceType);
    Controls.SelectedCityStateIcon:SetColor(nil);

    -- 基本信息
    table.insert(detailStrList, Locale.Lookup(resourceInfo.Name) .. "  [COLOR:199,21,133,255]" .. Locale.Lookup("LOC_HD_OVERSEAS_CORPORATION_RESOURCE_TEXT") .. "[ENDCOLOR][NEWLINE]");

    -- 行业公司效果
    if detailParam.IndustryEffect == true or detailParam.CorporationEffect == true then
      local industryStr = {};
      local corporationStr = {};

      for row in GameInfo.HD_Monopoly_Resource_Categories() do
        if row.ResourceType == resourceInfo.ResourceType then
          local categoryInfo = GameInfo.HD_Monopoly_Categories[row.Category];
          if categoryInfo then
            if detailParam.IndustryEffect == true and categoryInfo.IndustryEffect then
              table.insert(industryStr, '[ICON_BULLET]' .. Locale.Lookup('LOC_RESOURCE_CLASSIFICATION_HD_' .. row.Category .. '_NAME') .. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT') .. Locale.Lookup("LOC_" .. categoryInfo.IndustryEffect .. "_DESCRIPTION"));
            end
            if detailParam.CorporationEffect == true and categoryInfo.CorporationEffect then
              table.insert(corporationStr, '[ICON_BULLET]' .. Locale.Lookup('LOC_RESOURCE_CLASSIFICATION_HD_' .. row.Category .. '_NAME') .. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT') .. Locale.Lookup("LOC_" .. categoryInfo.CorporationEffect .. "_DESCRIPTION"));
            end
          end
        end
      end

      if #industryStr > 0 then
        local effectStr = '';
        for i, str in ipairs(industryStr) do
          if i > 1 then effectStr = effectStr .. "[NEWLINE]"; end
          effectStr = effectStr .. str;
        end
        table.insert(detailStrList, Locale.Lookup('LOC_HD_INDUSTRY_EFFECT_TEXT', effectStr));
      end

      if #corporationStr > 0 then
        local effectStr = '';
        for i, str in ipairs(corporationStr) do
          if i > 1 then effectStr = effectStr .. "[NEWLINE]"; end
          effectStr = effectStr .. str;
        end
        table.insert(detailStrList, Locale.Lookup('LOC_HD_OVERSEAS_CORPORATION_EFFECT_TEXT', effectStr));
      end
    end
  else
    -- 城邦基本信息
    -- 设置被选中资源图标
    Controls.SelectedCityStateIcon:SetHide(false);
    Controls.SelectedCityStateIcon:SetIcon('ICON_' .. PlayerConfigurations[cityStatePlayerId]:GetCivilizationTypeName());
    local primaryColor, secondaryColor = UI.GetPlayerColors(cityStatePlayerId);
    Controls.SelectedCityStateIcon:SetColor(secondaryColor);
    -- 宗主效果
    for row in GameInfo.LeaderTraits() do
      if row.LeaderType == PlayerConfigurations[cityStatePlayerId]:GetLeaderTypeName() then
        local traitInfo = GameInfo.Traits[row.TraitType];
        if traitInfo and traitInfo.Description then
          table.insert(detailStrList, Locale.Lookup(traitInfo.Description));
        end
      end
    end
  end

  -- 记录被选中资源Index
	selectedCityStateIndex = cityStatePlayerId;

  -- 启用确认按钮
  Controls.Confirm:SetDisabled(false);

  -- 拼接详情文本
	local detailStr = "";
	if #detailStrList > 0 then
		for i, str in ipairs(detailStrList) do
			if i > 1 then detailStr = detailStr .. "[NEWLINE]"; end
			detailStr = detailStr .. str;
		end
	end
	Controls.SelectedCityStateDetailLabel:SetText(detailStr);
end

function OnConfirm()
  if selectedCityStateIndex == -1 then return; end

  local param = {};
  param['OnStart'] = onStart or 'HD_CityStateSelection_OnChooseCityState';
  param['CityStateId'] = selectedCityStateIndex;
  param['X'] = x;
  param['Y'] = y;
  if scriptParam then param['ScriptParam'] = scriptParam; end
  UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, param);

	-- 关闭界面
	ClosePopup();
end

function ClosePopup()
	selectedCityStateIndex = -1;
  onStart = nil;
  scriptParam = nil;
	Controls.Confirm:SetDisabled(true);
	ContextPtr:SetHide(true);
end

function OnClose()
	ClosePopup();
end

function OnLocalPlayerTurnEnd()
	ClosePopup();
end

function OnInputHandler(pInputStruct:table)
	local uiMsg :number = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp and pInputStruct:GetKey() == Keys.VK_ESCAPE then
		ClosePopup();
		return true;
	end
	return false;
end

-- ===========================================================================
--	Custom Functions
-- ===========================================================================
-- 海外投资人 选择城邦专属资源 唤起面板
function CallOverseasInvestorSelectCityStateEvent(param)
  local sendParam = {
    PlayerId = param.PlayerId,
    X = param.X,
    Y = param.Y,
    OnStart = 'HD_OverseasInvestorBuildTransnational',
    ScriptParam = {UnitId = param.UnitId}
  };

	local list = Utils.GetOverSeasInvestorCityStateResources(param.PlayerId, {IncludeAlreadyBuilt = true});
  sendParam.CityStateList = list;

  local plot = Map.GetPlot(param.X, param.Y);
	if not plot then return; end
  local improvementType = "";
	if not plot:IsWater() then
		improvementType = "IMPROVEMENT_LEU_TRANSNATIONAL";
	else
		improvementType = "IMPROVEMENT_LEU_TRANSNATIONAL_SEA";
	end

  sendParam.HeaderTitle = Locale.Lookup('LOC_IMPROVEMENT_TRANSNATIONAL_SELECTION_TITLE', 'LOC_' .. improvementType .. '_NAME');
  sendParam.SubheaderIcon = 'ICON_' .. improvementType;
  sendParam.SubheaderLabel = Locale.Lookup('LOC_IMPROVEMENT_TRANSNATIONAL_SELECTION_SUBLABEL');

  LuaEvents.HD_TriggerCityStateSelectionPanel.Call(sendParam);
end

-- ===========================================================================
--	INITIALIZE
-- ===========================================================================
function Initialize()	
  -- ContextPtr:SetInputHandler(OnInputHandler, true);

	-- Callbacks
	Controls.CloseButton:RegisterCallback(Mouse.eLClick, OnClose);
	Controls.CloseButton:RegisterCallback(Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.Confirm:RegisterCallback(Mouse.eLClick, function()
		OnConfirm();
		UI.PlaySound("ALERT_POSITIVE");
	end);

  -- LUA Events
	LuaEvents.HD_TriggerCityStateSelectionPanel.Add(OnCityStateSelectionPanelPopup);
  LuaEvents.HD_CallOverseasInvestorSelectCityStateEvent.Add(CallOverseasInvestorSelectCityStateEvent);

	-- Game Events
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd);
end

Initialize();