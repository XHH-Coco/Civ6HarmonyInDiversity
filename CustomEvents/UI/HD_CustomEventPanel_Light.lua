-- ===========================================================================
include("InstanceManager");

-- ===========================================================================
-- UTILS
-- ===========================================================================
ExposedMembers.HD_CustomEvent_Utils = ExposedMembers.HD_CustomEvent_Utils or {};
HD_CustomEvent_Utils = ExposedMembers.HD_CustomEvent_Utils;

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local maxSelectionAmount = GameInfo.HD_CustomEvent_UIStyle['Light'].MaxSelectionAmount or 3;

-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local eventSelectionIM: table = InstanceManager:new("EventSelectionInstance", "EventSelection", Controls.EventSelectionStack);

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
function OnEventPanelPopup(param)
	local playerId = param.PlayerId;
	local eventId = param.EventId;
	
	-- 判断本地玩家
	if playerId == -1 or playerId ~= Game.GetLocalPlayer() then return; end

	-- 查询自定义事件信息
	local eventInfo = GameInfo.HD_CustomEvents[eventId];
	if not eventInfo then return; end

	-- 设置事件标题与描述
	if param.EventName then
		Controls.HeaderLabel:SetText(param.EventName);
	else
		Controls.HeaderLabel:SetText(Locale.Lookup(eventInfo.Name));
	end

	if param.EventDescription then
		Controls.SubheaderLabel:SetText(param.EventDescription);
	else
		Controls.SubheaderLabel:SetText(Locale.Lookup(eventInfo.Description));
	end
	
	-- 设置事件图片
	-- 这个模板不支持事件图片

	-- 设置选项
	local selectionAmount = 0;
	local hasAnyIcon = false;
	eventSelectionIM:ResetInstances();
	if param.SelectionList and #param.SelectionList > 0 then
		-- 如果提供了 SelectionList 则直接应用
		for _, data in ipairs(param.SelectionList) do
			local selectionInfo = GameInfo.HD_CustomEventSelections[data.Id];
			if selectionInfo then
				local instance = eventSelectionIM:GetInstance();
				selectionAmount = selectionAmount + 1;

				-- 设置图片
				if selectionInfo.Icon then
					instance.EventSelectionIcon:SetHide(false);
					instance.EventSelectionIcon:SetIcon(selectionInfo.Icon);
					hasAnyIcon = true;
				else
					instance.EventSelectionIcon:SetHide(true);
				end

				-- 设置描述
				if data.Description then
					instance.EventSelectionInfo:SetText(data.Description);
				else
					instance.EventSelectionInfo:SetText(Locale.Lookup(selectionInfo.Description));
				end

				-- 设置按钮文本
				if data.ButtonText then
					instance.EventSelectionButton:SetText(data.ButtonText);
				else
					instance.EventSelectionButton:SetText(Locale.Lookup(selectionInfo.ButtonText));
				end

				-- 设置按钮ToolTip
				if data.ButtonToolTip then
					instance.EventSelectionButton:SetToolTipString(data.ButtonToolTip);
				elseif selectionInfo.ButtonToolTip then
					instance.EventSelectionButton:SetToolTipString(Locale.Lookup(selectionInfo.ButtonToolTip));
				else
					instance.EventSelectionButton:SetToolTipString(nil);
				end

				-- 设置按钮可用性
				instance.EventSelectionButton:SetDisabled(data.ButtonDisabled == true);

				-- 音效
				instance.EventSelectionButton:RegisterCallback(Mouse.eLClick, function()
					OnChooseSelection(playerId, data.Id, data.ScriptParam);
					if data.Sound then
						UI.PlaySound(data.Sound);
					elseif selectionInfo.Sound then
						UI.PlaySound(selectionInfo.Sound);
					end
				end);
				instance.EventSelectionButton:RegisterCallback(Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
				
			end
		end
	else
		-- 如果没有提供 则随机选取 selection
		selectionAmount = param.SelectionAmount or maxSelectionAmount;
		local selectionList = {};
		for row in GameInfo.HD_CustomEventSelections() do
			if row.CustomEventType == eventInfo.CustomEventType then
				table.insert(selectionList, row);
			end
		end

		selectionAmount = math.min(selectionAmount, #selectionList);
		local list = {};
		for i=1, selectionAmount, 1 do
			local index = HD_CustomEvent_Utils.GetRandNum(#selectionList, "Random Selection for Player " .. playerId) + 1;
			table.insert(list, selectionList[index]);
			table.remove(selectionList, index);
		end

		if #list > 0 then
			for _, selectionInfo in ipairs(list) do
				local instance = eventSelectionIM:GetInstance();

				-- 设置图片
				if selectionInfo.Icon then
					instance.EventSelectionIcon:SetHide(false);
					instance.EventSelectionIcon:SetIcon(selectionInfo.Icon);
					hasAnyIcon = true;
				else
					instance.EventSelectionIcon:SetHide(true);
				end

				-- 设置描述
				instance.EventSelectionInfo:SetText(Locale.Lookup(selectionInfo.Description));

				-- 设置按钮文本
				instance.EventSelectionButton:SetText(Locale.Lookup(selectionInfo.ButtonText));

				-- 设置按钮ToolTip
				if selectionInfo.ButtonToolTip then
					instance.EventSelectionButton:SetToolTipString(Locale.Lookup(selectionInfo.ButtonToolTip));
				else
					instance.EventSelectionButton:SetToolTipString(nil);
				end

				-- 设置按钮可用性
				instance.EventSelectionButton:SetDisabled(false);

				-- 注册选取事件
				instance.EventSelectionButton:RegisterCallback(Mouse.eLClick, function()
					OnChooseSelection(playerId, selectionInfo.Index);
					if selectionInfo.Sound then
						UI.PlaySound(selectionInfo.Sound);
					end
				end);
				instance.EventSelectionButton:RegisterCallback(Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

			end
		else
			print("没有任何可用的事件选项", playerId, eventId);
			return;
		end
	end

	-- 设置尺寸
	-- 事件描述区域高度
	local eventDescriptionHeight = 60;
	if param.EventDescriptionHeight then
		eventDescriptionHeight = param.EventDescriptionHeight;
	end
	Controls.SubheaderScrollPanel:SetSizeY(eventDescriptionHeight);
	Controls.EventSelectionStack:SetOffsetY(97 + eventDescriptionHeight);
	-- 总高度
	local totalHeight = 720 - 60 + eventDescriptionHeight;

	-- PopupFrameGrid = 376 + (260+2) * (x-1)
	-- SubheaderGrid = 260 + (260+2) * (x-1)
	-- SubheaderScrollPanel = SubheaderGrid - 25
	-- SubheaderLabel = SubheaderGrid - 25
	selectionAmount = math.max(selectionAmount, 1);
	Controls.PopupFrameGrid:SetSizeX(376+262*(selectionAmount-1));
	Controls.SubheaderGrid:SetSizeX(260+262*(selectionAmount-1));
	Controls.SubheaderScrollPanel:SetSizeX(235+262*(selectionAmount-1));
	Controls.SubheaderLabel:SetWrapWidth(235+262*(selectionAmount-1));
	if hasAnyIcon then
		Controls.PopupFrameGrid:SetSizeY(totalHeight);
		for i=1, selectionAmount, 1 do
			local instance = eventSelectionIM:GetAllocatedInstance(i);
			instance.EventSelection:SetSizeY(525);
			instance.EventSelectionGrid:SetOffsetY(282);
		end
	else
		Controls.PopupFrameGrid:SetSizeY(totalHeight-256);
		for i=1, selectionAmount, 1 do
			local instance = eventSelectionIM:GetAllocatedInstance(i);
			instance.EventSelection:SetSizeY(525-256-2);
			instance.EventSelectionGrid:SetOffsetY(24);
		end
	end
	
	-- 播放声音
	if param.Sound then
		UI.PlaySound(param.Sound);
	elseif eventInfo.Sound then
		UI.PlaySound(eventInfo.Sound);
	end

	-- 显示界面
  ContextPtr:SetHide(false);
end

function OnChooseSelection(playerId, selectionId, scriptParam)
	-- 触发通用事件
	local param = {};
  param['OnStart'] = 'HD_CustomEvent_OnChooseSelection';
  param['SelectionId'] = selectionId;
  if scriptParam then param['Param'] = scriptParam; end
  UI.RequestPlayerOperation(playerId, PlayerOperations.EXECUTE_SCRIPT, param);

	-- 关闭界面
	ClosePopup();
end

function ClosePopup()
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
--	INITIALIZE
-- ===========================================================================
function Initialize()	
  -- ContextPtr:SetInputHandler(OnInputHandler, true);

	-- Callbacks
	Controls.CloseButton:RegisterCallback(Mouse.eLClick, OnClose);
	Controls.CloseButton:RegisterCallback(Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

  -- LUA Events
	LuaEvents.HD_TriggerCustomEventPanel_Light.Add(OnEventPanelPopup);

	-- Game Events
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd);
end

Initialize();