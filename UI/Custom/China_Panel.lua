-- =================================================================================
-- Import base file
-- =================================================================================
include("InstanceManager");
include "HD_StateUtils"

-- ===========================================================================
-- UTILS
-- ===========================================================================
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- ===========================================================================
-- CONSTANTS
-- ===========================================================================
-- local RELOAD_CACHE_ID:string = "China_Panel"; -- Must be unique (usually the same as the file name)

local HEROIC_AGE:number = 1;
local GOLDEN_AGE:number = 2;
local DARK_AGE:number = 3;
local NORMAL_AGE:number = 4;

local COMMEMORATION_CANNOT_SELECT_TAG:string = 'HD_COMMEMORATION_CANNOT_SELECT_';
local COMMEMORATION_CANNOT_SELECT_REASON_TAG:string = 'HD_COMMEMORATION_CANNOT_SELECT_REASON_';
local CHINA_BUILD_WONDER_ERA_ALREADY_SELECT_TAG:string = 'HD_CHINA_BUILD_WONDER_ERA_ALREADY_SELECT_';
local CHINA_FIRST_TURN_ALREADY_SELECT_TAG:string = 'HD_CHINA_FIRST_TURN_ALREADY_SELECT'
-- ===========================================================================
-- VARIABLES
-- ===========================================================================
local m_CurrentAge:number = -1;
-- local m_PreviewEraIndex:number = -1;
-- local m_CurrentEraIndex:number = -1;
local m_SelectedCommemorationType:number = -1;
local m_CommemorationInstanceManager:table = InstanceManager:new("Commemoration", "SelectCheck", Controls.CommemorationsStack);

local m_era:number = -1;
local m_Selected:boolean = false;

local m_isAncient:boolean = false;
local m_isFirstTurn:boolean = false;
local m_randomAncientList:table = {};
-- ===========================================================================
function OnTogglePanel(era:number, firstTurn:boolean)
	if ContextPtr:IsHidden() then
    local localPlayerID:number = Game.GetLocalPlayer();
    local localPlayer = Players[localPlayerID]
    -- 尝试防止重复选取
    if firstTurn and localPlayer:GetProperty(CHINA_FIRST_TURN_ALREADY_SELECT_TAG) == 1 then
      Skip()
    elseif not firstTurn and localPlayer:GetProperty(CHINA_BUILD_WONDER_ERA_ALREADY_SELECT_TAG .. era) == 1 then
      Skip()
    else
      Open(era, firstTurn)
    end
	else
		Close()
	end
end

function Open(era:number, firstTurn:boolean)
	local localPlayerID:number = Game.GetLocalPlayer();
  local localPlayer = Players[localPlayerID]
	local gameEras:table = Game.GetEras();
  -- 记录时代
  m_era = era;
  m_isAncient = (era == 0);
  m_isFirstTurn = firstTurn;
  m_Selected = false;
  
	-- 忽略观察者
	if localPlayerID == PlayerTypes.NONE then return; end

  -- 显示界面
  ContextPtr:SetHide(false);
  LuaEvents.ChinaChooseCommemorationPanel_Opened(m_era, m_isFirstTurn);
  UI.PlaySound("Tech_Tray_Slide_Open");

	-- 玩家时代类型
	if (gameEras:HasHeroicGoldenAge(localPlayerID)) then
		m_CurrentAge = HEROIC_AGE;
	elseif (gameEras:HasGoldenAge(localPlayerID)) then
		m_CurrentAge = GOLDEN_AGE;
	elseif (gameEras:HasDarkAge(localPlayerID)) then
		m_CurrentAge = DARK_AGE;
	else
		m_CurrentAge = NORMAL_AGE;
	end
  if m_isAncient then
    m_CurrentAge = HEROIC_AGE;
  end

  -- 设置标题
  if m_isFirstTurn then
    Controls.Title:SetText(Locale.ToUpper(Locale.Lookup('LOC_CHINA_CHOOSE_ANCIENT_COMMEMORATION_SUBHEADER')));
  else
    Controls.Title:SetText(Locale.ToUpper(Locale.Lookup('LOC_CHINA_CHOOSE_COMMEMORATION_SUBHEADER', Locale.Lookup(GameInfo.Eras[era].Name))));
  end

  -- 初始化着力点选项
  m_CommemorationInstanceManager:ResetInstances();

  -- 查找对应时代的着力点
  if m_isAncient then
    -- 远古时代专属着力点
    local playerConfig = PlayerConfigurations[localPlayerID]
	  local leaderType = playerConfig:GetLeaderTypeName()
    local isChinaLeader = false
    for row in GameInfo.ChinaLeaders_AncientCommemorationTypes_HD() do
      if row.LeaderType == leaderType then
        isChinaLeader = true;
        local ancientCommemorationInfo = GameInfo.China_AncientCommemorationTypes_HD[row.AncientCommemorationType]
        local ancientCommemoration = {
          Index = ancientCommemorationInfo.Index,
          CommemorationType = ancientCommemorationInfo.AncientCommemorationType,
          CategoryDescription = ancientCommemorationInfo.Name,
          Description = ancientCommemorationInfo.Description
        }
        CreateCommemoration(ancientCommemoration);
        print("中国远古时代专属着力点", ancientCommemoration.Index, Locale.Lookup(ancientCommemorationInfo.Name))
      end
    end

    -- 不是中国领袖，随机选取4个专属着力点 China_AncientCommemorationTypes_HD
    if not isChinaLeader then
      -- 若随机列表为空，初始化列表
      if #m_randomAncientList == 0 then
        print("开始选取随机专属着力点……")
        local maxIndex = 0;
        for row in GameInfo.China_AncientCommemorationTypes_HD() do
          maxIndex = maxIndex + 1;
        end
        print('随机远古时代专属着力点 maxIndex', maxIndex)
        while (#m_randomAncientList < 4) do
          print('随机远古时代专属着力点 num', #m_randomAncientList)
          local index = Utils.GetRandNum(maxIndex, "Random Ancient CommemorationTypes for Player " .. localPlayerID);
          print('随机远古时代专属着力点 index', index)
          local exist = false;
          for _, ancientCommemoration in ipairs(m_randomAncientList) do
            if ancientCommemoration.Index == index then
              exist = true;
            end
          end
          print('随机远古时代专属着力点 exist', exist)
          if not exist then
            local ancientCommemorationInfo = GameInfo.China_AncientCommemorationTypes_HD[index]
            print('随机远古时代专属着力点', Locale.Lookup(ancientCommemorationInfo.Name))
            local ancientCommemoration = {
              Index = ancientCommemorationInfo.Index,
              CommemorationType = ancientCommemorationInfo.AncientCommemorationType,
              CategoryDescription = ancientCommemorationInfo.Name,
              Description = ancientCommemorationInfo.Description
            }
            table.insert(m_randomAncientList, ancientCommemoration)
          end
        end
      end

      for _, ancientCommemoration in ipairs(m_randomAncientList) do
        CreateCommemoration(ancientCommemoration);
        print("随机远古时代专属着力点", ancientCommemoration.Index, Locale.Lookup(ancientCommemoration.CategoryDescription))
      end
    end
  else
    -- 通用时代着力点
    for row in GameInfo.CommemorationTypes() do
      local minEraInfo = GameInfo.Eras[row.MinimumGameEra]
      local maxEraInfo = GameInfo.Eras[row.MaximumGameEra]
      local minEra = 0
      local maxEra = 8
      if minEraInfo ~= nil then
        minEra = minEraInfo.Index
      end
      if maxEraInfo ~= nil then
        maxEra = maxEraInfo.Index
      end
      if minEra <= era and era <= maxEra then
        -- 创建着力点实例
        CreateCommemoration(row);
        print("中国造奇观可供选择的着力点", Locale.Lookup(row.CategoryDescription))
      end
    end
  end
  
  m_SelectedCommemorationType = -1;
  Controls.Confirm:SetDisabled(true);
  Controls.CommemorationsStack:CalculateSize();
  Controls.CommemorationsScroller:CalculateSize();

  Controls.CommemorationsScroller:SetScrollValue(0);

  -- 更新控件样式
  if m_CurrentAge == HEROIC_AGE then
    Controls.AgeAchieved:SetText(Locale.ToUpper(Locale.Lookup("LOC_CHINA_CHOOSE_COMMEMORATION_DESCRIPTION")));
    Controls.PopupBackground:SetTexture("Ages_ParchmentHeroic");
    Controls.PopupFrame:SetTexture("Ages_FrameHeroic");
    Controls.HeroicFrameGlow:SetHide(false);
  elseif m_CurrentAge == GOLDEN_AGE then
    Controls.AgeAchieved:SetText(Locale.ToUpper(Locale.Lookup("LOC_CHINA_CHOOSE_COMMEMORATION_DESCRIPTION")));
    Controls.PopupBackground:SetTexture("Ages_ParchmentGolden");
    Controls.PopupFrame:SetTexture("Ages_FrameGolden");
    Controls.HeroicFrameGlow:SetHide(true);
  elseif m_CurrentAge == DARK_AGE then
    Controls.AgeAchieved:SetText(Locale.ToUpper(Locale.Lookup("LOC_CHINA_CHOOSE_COMMEMORATION_DESCRIPTION")));
    Controls.PopupBackground:SetTexture("Ages_ParchmentDark");
    Controls.PopupFrame:SetTexture("Ages_FrameDark");
    Controls.HeroicFrameGlow:SetHide(true);
  else
    Controls.AgeAchieved:SetText(Locale.ToUpper(Locale.Lookup("LOC_CHINA_CHOOSE_COMMEMORATION_DESCRIPTION")));
    Controls.PopupBackground:SetTexture("Ages_ParchmentNormal");
    Controls.PopupFrame:SetTexture("Ages_FrameNormal");
    Controls.HeroicFrameGlow:SetHide(true);
  end
  if m_isAncient then
    Controls.AgeAchieved:SetText(Locale.ToUpper(Locale.Lookup("LOC_CHINA_CHOOSE_ANCIENT_COMMEMORATION_DESCRIPTION")));
  end

	UpdateConfirmButton();
end

-- ===========================================================================
function CreateCommemoration(commemorationInfo:table)
  local localPlayerID:number = Game.GetLocalPlayer();
  local localPlayer = Players[localPlayerID]

  -- 判断是否已经选取过
  local canSelected = 0
  if m_isAncient then
    canSelected = localPlayer:GetProperty(COMMEMORATION_CANNOT_SELECT_TAG .. 'ANCIENT_' .. commemorationInfo.Index) or 0
  else
    canSelected = localPlayer:GetProperty(COMMEMORATION_CANNOT_SELECT_TAG .. commemorationInfo.Index) or 0
  end

	local instance:table = m_CommemorationInstanceManager:GetInstance();

	-- Commemoration Icon
	local iconName:string = "ICON_" .. commemorationInfo.CommemorationType;
  if GameInfo.CommemorationIcons ~= nil and GameInfo.CommemorationIcons[commemorationInfo.CommemorationType] ~= nil then
    iconName = GameInfo.CommemorationIcons[commemorationInfo.CommemorationType].Icon;
  end
	instance.CommemorationIcon:SetIcon(iconName);

  -- Commemoration Name
	local categoryText:string = "";
	if (commemorationInfo ~= nil and commemorationInfo.CategoryDescription ~= nil) then
		categoryText = Locale.ToUpper(Locale.Lookup(commemorationInfo.CategoryDescription));

    -- 如果不可选择该着力点，修改文本
    if canSelected == 1 then
      print('着力点不可选择', categoryText)
      categoryText = categoryText .. ' [ICON_CheckFail]'
    end
	end
	instance.MomentCategory:SetText(categoryText);

  -- 着力点效果文本
  local bonusText:string = ""
  if m_isAncient then
    bonusText = bonusText .. Locale.Lookup(commemorationInfo.Description);
  else
    bonusText = bonusText .. "[ICON_GLORY_GOLDEN_AGE] " .. Locale.Lookup('LOC_ERA_PROGRESS_GOLDEN_AGE') .. ": ";
    bonusText = bonusText .. Locale.Lookup(commemorationInfo.GoldenAgeBonusDescription);
    bonusText = bonusText .. "[NEWLINE]" .. "[ICON_GLORY_NORMAL_AGE] " .. Locale.Lookup('LOC_ERA_PROGRESS_NORMAL_AGE') .. ": ";
    bonusText = bonusText .. Locale.Lookup(commemorationInfo.NormalAgeBonusDescription);
  end

  -- 如果不可选择该着力点，修改文本
  if canSelected == 1 then
    bonusText = Locale.Lookup('LOC_COMMEMORATION_CANNOT_SELECT') .. "[NEWLINE]" .. bonusText
    -- 添加悬浮框提示文本
    local reason
    if m_isAncient then
      reason = localPlayer:GetProperty(COMMEMORATION_CANNOT_SELECT_REASON_TAG .. 'ANCIENT_' .. commemorationInfo.Index)
    else
      reason = localPlayer:GetProperty(COMMEMORATION_CANNOT_SELECT_REASON_TAG .. commemorationInfo.Index)
    end
    if reason ~= nil then
      instance.SelectCheck:SetToolTipString(Locale.Lookup(reason))
    end
  end

	if m_CurrentAge == HEROIC_AGE then
		instance.SelectCheck:SetTexture("Ages_ButtonComHeroic");
	elseif m_CurrentAge == GOLDEN_AGE then
		instance.SelectCheck:SetTexture("Ages_ButtonComGolden");
	elseif m_CurrentAge == DARK_AGE then
		instance.SelectCheck:SetTexture("Ages_ButtonComDark");
	else
		instance.SelectCheck:SetTexture("Ages_ButtonComNormal");
	end

	instance.MomentBonuses:SetText(bonusText);
	instance.SelectCheck:SetSelected(false);
	instance.SelectCheck:RegisterCallback(Mouse.eLClick, function() OnCommemorationSelected(instance, commemorationInfo.Index) end);
end

-- ===========================================================================
function OnCommemorationSelected(selectedInstance:table, commemorationType:number)
  -- 如果不可选择该着力点，直接返回
  local localPlayerID:number = Game.GetLocalPlayer();
  local localPlayer = Players[localPlayerID]

  -- 判断是否已经选取过
  local canSelected = 0
  if m_isAncient then
    canSelected = localPlayer:GetProperty(COMMEMORATION_CANNOT_SELECT_TAG .. 'ANCIENT_' .. commemorationType) or 0
  else
    canSelected = localPlayer:GetProperty(COMMEMORATION_CANNOT_SELECT_TAG .. commemorationType) or 0
  end
  if canSelected == 1 then
    return
  end

	-- 是否已经选中
  if m_SelectedCommemorationType == commemorationType then
    selectedInstance.SelectCheck:SetSelected(false);
    m_SelectedCommemorationType = -1;
  else
    for _, instance in ipairs(m_CommemorationInstanceManager.m_AllocatedInstances) do
      instance.SelectCheck:SetSelected(false);
    end
    m_SelectedCommemorationType = commemorationType
    selectedInstance.SelectCheck:SetSelected(true);
  end

	UpdateConfirmButton();
end

-- ===========================================================================
function UpdateConfirmButton()
	Controls.Confirm:SetDisabled(m_SelectedCommemorationType == -1);
end

-- ===========================================================================
function OnConfirm()
  local param:table = {};
  param['OnStart'] = 'ChinaSelectExtraCommemoration'
  param['CommemorationId'] = m_SelectedCommemorationType;
  param['IsAncient'] = m_isAncient;
  UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, param);

  local localPlayerID:number = Game.GetLocalPlayer();
  local localPlayer = Players[localPlayerID]
  if m_isFirstTurn then
    SetObjectState(localPlayer, CHINA_FIRST_TURN_ALREADY_SELECT_TAG, 1)
  else
    SetObjectState(localPlayer, CHINA_BUILD_WONDER_ERA_ALREADY_SELECT_TAG .. m_era, 1)
  end
  
  UI.PlaySound("Confirm_Dedication");
  m_Selected = true;
  Close();
end

-- ===========================================================================
function CloseButtonCallback()
  print("中国造奇观 关闭界面")
  Close()
  -- if not m_Selected then
  --   print("中国造奇观 未成功进行选择 再次发起通知", m_era)
  --   LuaEvents.ChinaChooseCommemoration_SendNotification(m_era, m_isFirstTurn)
  -- end
end

function Close()
  m_SelectedCommemorationType = -1
  for _, instance in ipairs(m_CommemorationInstanceManager.m_AllocatedInstances) do
    instance.SelectCheck:SetSelected(false);
  end

  UI.PlaySound("Tech_Tray_Slide_Closed");
	LuaEvents.ChinaChooseCommemorationPanel_Closed(m_era, m_isFirstTurn, m_Selected)
  ContextPtr:SetHide(true);
end

function Skip()
  print("中国选取着力点 以阻止重复选取")
  m_SelectedCommemorationType = -1
  for _, instance in ipairs(m_CommemorationInstanceManager.m_AllocatedInstances) do
    instance.SelectCheck:SetSelected(false);
  end
  ContextPtr:SetHide(true);
end

-- ===========================================================================
function OnInit(isReload:boolean)
end

-- ===========================================================================
--	UI EVENT
-- ===========================================================================
-- function OnShutdown()
-- 	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "isVisible", not ContextPtr:IsHidden());
-- 	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "m_PreviewEraIndex", m_PreviewEraIndex);
-- 	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "m_CurrentEraIndex", m_CurrentEraIndex);
-- end

-- ===========================================================================
--	LUA EVENT
--	Reload support
-- ===========================================================================
-- function OnGameDebugReturn(context:string, contextTable:table)
-- 	if context == RELOAD_CACHE_ID then
-- 		if contextTable["isVisible"] ~= nil then			
-- 			ContextPtr:SetHide(not contextTable["isVisible"]);
-- 		end

-- 		m_PreviewEraIndex = contextTable["m_PreviewEraIndex"];
-- 		m_CurrentEraIndex = contextTable["m_CurrentEraIndex"];

-- 		if m_CurrentEraIndex >= 0 then
-- 			OnGameEraChanged(m_PreviewEraIndex, m_CurrentEraIndex);
-- 		end
-- 	end
-- end

-- ===========================================================================
--	Input
--	UI Event Handler
-- ===========================================================================
function OnInputHandler(pInputStruct:table)
	if ( pInputStruct:GetMessageType() == KeyEvents.KeyUp ) then
		local key:number = pInputStruct:GetKey();
		if ( key == Keys.VK_ESCAPE ) then
			Close();
		end
	end
	-- Intercept all input while on this screen (is modal)
	return true;
end

-- ===========================================================================
function Initialize()
	ContextPtr:SetHide(true);
	ContextPtr:SetInitHandler(OnInit);
	-- ContextPtr:SetShutdown(OnShutdown);
	ContextPtr:SetInputHandler(OnInputHandler, true);

	Controls.CloseButton:RegisterCallback(Mouse.eLClick, CloseButtonCallback);
	Controls.Confirm:RegisterCallback(Mouse.eLClick, OnConfirm);

	-- Lua Events
	-- LuaEvents.GameDebug_Return.Add(OnGameDebugReturn);
	LuaEvents.ChinaChooseCommemoration_TogglePopup.Add(OnTogglePanel);
end
Initialize();