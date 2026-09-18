-- ===========================================================================
include("InstanceManager");

ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;
-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local resourceSelectionIM: table = InstanceManager:new("ResourceSelectionInstance", "ResourceSelection", Controls.ResourceSelectionStack);

local selectedResourceIndex = -1;
local x = -1;
local y = -1;
local onStart = nil;
local scriptParam = nil;

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
function OnResourceSelectionPanelPopup(param)
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
		Controls.HeaderTitle:SetText(Locale.Lookup('LOC_HD_RESOURCE_SELECTION_MAIN_TITLE'));
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

	if param.ResourceListTitle then
		Controls.ResourceListTitle:SetText(param.ResourceListTitle);
	else
		Controls.ResourceListTitle:SetText(Locale.Lookup('LOC_HD_RESOURCE_SELECTION_LIST_SUBTITLE'));
	end

	if param.ResourceDetailTitle then
		Controls.ResourceDetailTitle:SetText(param.ResourceDetailTitle);
	else
		Controls.ResourceDetailTitle:SetText(Locale.Lookup('LOC_HD_RESOURCE_SELECTION_DETAIL_SUBTITLE'));
	end

	-- 重置被选中资源相关信息
	Controls.SelectedResourceIcon:SetHide(true);
	Controls.SelectedResourceDetailLabel:SetText("");
	-- 启用确认按钮
	Controls.Confirm:SetDisabled(true);

	-- 选择相关参数
	selectedResourceIndex = -1;

	-- 生成待选资源列表
	resourceSelectionIM:ResetInstances();
	local list = param.ResourceList or {};
	if #list > 0 then
		-- 隐藏没有可用资源文本提示
		Controls.NoAvailableResourceLabel:SetHide(true);

		-- 排序
		table.sort(list, function(a, b)
			local a_score = Utils.ResourceClassSortList[GameInfo.Resources[a.ResourceType].ResourceClassType] or 100;
			local b_score = Utils.ResourceClassSortList[GameInfo.Resources[b.ResourceType].ResourceClassType] or 100;

			if a.Disabled == true then a_score = a_score + 10000; end
			if b.Disabled == true then b_score = b_score + 10000; end

			return a_score < b_score;
		end)

		for _, data in ipairs(list) do
			local resourceInfo = GameInfo.Resources[data.ResourceType];
			if resourceInfo then
				local instance = resourceSelectionIM:GetInstance();

				-- 判断是否能够被选择
				if data.Disabled == true then
					-- 设置图片
					instance.ResourceIcon:SetIcon('ICON_' .. resourceInfo.ResourceType .. '_FOW');
					-- 设置ToolTip
					local toolTipStr = Locale.Lookup(resourceInfo.Name);
					if data.DisabledReason then toolTipStr = toolTipStr .. '[NEWLINE][NEWLINE]' .. Locale.Lookup(data.DisabledReason); end
					instance.SelectButton:SetToolTipString(toolTipStr);
					-- 设置按钮可用性
					instance.SelectButton:SetDisabled(true);
				else
					-- 设置图片
					instance.ResourceIcon:SetIcon('ICON_' .. resourceInfo.ResourceType);
					-- 设置ToolTip
					instance.SelectButton:SetToolTipString(Locale.Lookup(resourceInfo.Name));
					-- 设置按钮可用性
					instance.SelectButton:SetDisabled(false);
					-- 注册事件
					instance.SelectButton:RegisterCallback(Mouse.eLClick, function() OnSelect(resourceInfo.ResourceType, data.DetailParam); end);
				end
			end
		end
	else
		-- 如果资源列表为空 显示没有可用资源文本提示
		Controls.NoAvailableResourceLabel:SetHide(false);
		print('待选资源列表为空');
	end

	-- 显示界面
	ContextPtr:SetHide(false);
end

function OnSelect(resourceType, param)
	local resourceInfo = GameInfo.Resources[resourceType];
	if not resourceInfo then return; end
	print('选中：' .. resourceType);

	-- 记录被选中资源Index
	selectedResourceIndex = resourceInfo.Index;

	-- 设置被选中资源详情
	local detailParam = param or {};
	local detailStrList = {};

	-- 设置被选中资源图标
	Controls.SelectedResourceIcon:SetHide(false);
	if detailParam.IndustryEffect == true or detailParam.CorporationEffect == true then
		Controls.SelectedResourceIcon:SetIcon('ICON_MONOPOLIES_AND_CORPS_' .. resourceType);
	else
		Controls.SelectedResourceIcon:SetIcon('ICON_' .. resourceType);
	end

	-- 启用确认按钮
	Controls.Confirm:SetDisabled(false);

	-- 基本信息
	if resourceInfo.ResourceClassType == "RESOURCECLASS_BONUS" then
		table.insert(detailStrList, Locale.Lookup(resourceInfo.Name) .. "  [COLOR:0,102,0,255]" .. Locale.Lookup("LOC_TOOLTIP_BONUS_RESOURCE") .. "[ENDCOLOR][NEWLINE]");
	elseif resourceInfo.ResourceClassType == "RESOURCECLASS_LUXURY" then
		table.insert(detailStrList, Locale.Lookup(resourceInfo.Name) .. "  [COLOR:153,102,0,255]" .. Locale.Lookup("LOC_TOOLTIP_LUXURY_RESOURCE") .. "[ENDCOLOR][NEWLINE]");
	elseif resourceInfo.ResourceClassType == "RESOURCECLASS_STRATEGIC" then
		table.insert(detailStrList, Locale.Lookup(resourceInfo.Name) .. "  [COLOR:ResScienceLabelCS]" .. Locale.Lookup("LOC_TOOLTIP_STRATEGIC_RESOURCE") .. "[ENDCOLOR][NEWLINE]");
	elseif resourceInfo.ResourceClassType == "RESOURCECLASS_ARTIFACT" then
		table.insert(detailStrList, Locale.Lookup(resourceInfo.Name) .. "  [COLOR:ResCultureLabelCS]" .. Locale.Lookup("LOC_TOOLTIP_ARTIFACT_RESOURCE") .. "[ENDCOLOR][NEWLINE]");
	end

	-- 行业公司效果
	if detailParam.IndustryEffect == true or detailParam.CorporationEffect == true then
		local industryStr = {};
		local corporationStr = {};

		for row in GameInfo.HD_Monopoly_Resource_Categories() do
			if row.ResourceType == resourceType then
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
			table.insert(detailStrList, Locale.Lookup('LOC_HD_CORPORATION_EFFECT_TEXT', effectStr));
		end
	end

	-- 资源数量文本
	if detailParam.Amount then
		table.insert(detailStrList, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_SELECT_RESOURCE_AMOUNT', detailParam.Amount, '[ICON_' .. resourceType .. ']', resourceInfo.Name))
	end
	if detailParam.RequiredAmount then
		table.insert(detailStrList, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_SELECT_RESOURCE_REQUIRED', detailParam.RequiredAmount, '[ICON_' .. resourceType .. ']', resourceInfo.Name))
	end

	-- 拼接详情文本
	local detailStr = "";
	if #detailStrList > 0 then
		for i, str in ipairs(detailStrList) do
			if i > 1 then detailStr = detailStr .. "[NEWLINE]"; end
			detailStr = detailStr .. str;
		end
	end
	Controls.SelectedResourceDetailLabel:SetText(detailStr);

end

function OnConfirm()
	if selectedResourceIndex == -1 then return; end

	local param = {};
  param['OnStart'] = onStart or 'HD_ResourceSelection_OnChooseResource';
  param['ResourceId'] = selectedResourceIndex;
  param['X'] = x;
  param['Y'] = y;
  if scriptParam then param['ScriptParam'] = scriptParam; end
  UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, param);

	-- 关闭界面
	ClosePopup();
end

function ClosePopup()
	selectedResourceIndex = -1;
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
local UNIT_ZIMBABWE_PATHFINDER_STRATEGIC_RESOURCE_PLAYER_TAG = 'HD_UNIT_ZIMBABWE_PATHFINDER_STRATEGIC_RESOURCE_PLAYER_';

local UNIT_ZIMBABWE_PATHFINDER_STRATEGIC_RESOURCE_BASE = GlobalParameters.HD_UNIT_ZIMBABWE_PATHFINDER_STRATEGIC_RESOURCE_BASE or 0;
local UNIT_ZIMBABWE_PATHFINDER_STRATEGIC_RESOURCE_ADD_PER_TIME = GlobalParameters.HD_UNIT_ZIMBABWE_PATHFINDER_STRATEGIC_RESOURCE_ADD_PER_TIME or 0;

function CallZimbabwePathfinderSelectResourceEvent(param)
	local playerId = param.PlayerId;
	local player = Players[playerId];
	if not player then return; end

	local sendParam = {
    PlayerId = playerId,
    OnStart = 'HD_ZimbabwePathfinderSelectResource',
    ScriptParam = {UnitId = param.UnitId}
  };

	local resourceList = Utils.Classification_Resource_Map['RESOURCE_CLASSIFICATION_HD_TRANSIT'] or {};
	local dataList = {}
	for _, resourceType in ipairs(resourceList) do
		local resourceInfo = GameInfo.Resources[resourceType];
		if resourceInfo then
			local requiredAmount = 1;
			local amount = player:GetResources():GetResourceAmount(resourceType) or 0;

			-- 战略资源需求 10 + 10n
			if resourceInfo.ResourceClassType == 'RESOURCECLASS_STRATEGIC' then
				local times = Utils.GetPlayerProperty(playerId, UNIT_ZIMBABWE_PATHFINDER_STRATEGIC_RESOURCE_PLAYER_TAG .. resourceType) or 0;
				requiredAmount = UNIT_ZIMBABWE_PATHFINDER_STRATEGIC_RESOURCE_BASE + UNIT_ZIMBABWE_PATHFINDER_STRATEGIC_RESOURCE_ADD_PER_TIME * times;
			end

			local data = {
				ResourceType = resourceType,
				DetailParam = {
					Amount = amount,
					RequiredAmount = requiredAmount
				},
				Disabled = amount < requiredAmount
			};
			if data.Disabled then
				data.DisabledReason = Locale.Lookup('LOC_ABILITY_HD_ZIMBABWE_PATHFINDER_SELECT_RESOURCE_DISABLED', requiredAmount, '[ICON_' .. resourceType .. ']', resourceInfo.Name);
			end

			table.insert(dataList, data)
		end
	end

	sendParam.ResourceList = dataList;
	LuaEvents.HD_TriggerResourceSelectionPanel.Call(sendParam);
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
	LuaEvents.HD_TriggerResourceSelectionPanel.Add(OnResourceSelectionPanelPopup);
	LuaEvents.HD_CallZimbabwePathfinderSelectResourceEvent.Add(CallZimbabwePathfinderSelectResourceEvent);

	-- Game Events
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd);
end

Initialize();