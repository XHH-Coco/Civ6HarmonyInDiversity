-- ===========================================================================
include("GameCapabilities");
include("InstanceManager");
include("ModalScreen_PlayerYieldsHelper");
-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local m_IsXP1Active: boolean = Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9");
local m_IsXP2Active: boolean = Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68");


local SIZE_BELIEF_ICON_LARGE: number = 64;
local BELIEFS_PANEL_RELATIVE_SIZE_UNSELECTED: number = -236;
local BELIEFS_PANEL_RELATIVE_SIZE_SELECTED: number = -326;

local DATA_FIELD_BELIEF_INDEX: string = "DataField_BeliefIndex";

local POTALA_PALACE_EXTRA_FOUNDER: number = GlobalParameters.HD_POTALA_PALACE_EXTRA_FOUNDER or 0;
local POTALA_PALACE_EXTRA_ENHANCER: number = GlobalParameters.HD_POTALA_PALACE_EXTRA_ENHANCER or 0;

-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local m_pSelectBeliefsIM: table = InstanceManager:new("BeliefSlot", "BeliefButton", Controls.BeliftStack);

local m_pGameReligion: table = Game.GetReligion();

local m_SelectedInst: table = {
  FounderBelief = nil,
  EnhancerBelief = nil
};

local m_Inited: boolean = false;
local m_Selected: boolean = false;

-- ===========================================================================
function Realize()
	local localPlayerId = Game.GetLocalPlayer()
	local localPlayer = Players[localPlayerId]
  m_Inited = true;

	if POTALA_PALACE_EXTRA_FOUNDER == 0 and POTALA_PALACE_EXTRA_ENHANCER == 0 then
    return;
  end
	
	m_pSelectBeliefsIM:ResetInstances();
	m_SelectedInst = {
    FounderBelief = nil,
    EnhancerBelief = nil
  };
	
	Controls.ReligionOrPatheonTitle:SetText(Locale.Lookup('LOC_BUILDING_POTALA_PALACE_EXTRA_BELIEF_AVAILABLE'))
	
	for row in GameInfo.Beliefs() do
		if CanSelectFounderBelief(row) then
			local beliefInst:table = m_pSelectBeliefsIM:GetInstance();
			beliefInst.BeliefLabel:LocalizeAndSetText(Locale.ToUpper(row.Name));
			beliefInst.BeliefDescription:LocalizeAndSetText(row.Description);
			SetBeliefIcon(beliefInst.BeliefIcon, row.BeliefType, SIZE_BELIEF_ICON_LARGE);
			beliefInst.BeliefButton:RegisterCallback(Mouse.eLClick, function() ChangeSelectState(beliefInst); end);
			beliefInst.BeliefButton:SetVoid1(row.Index)
		end
	end

  for row in GameInfo.Beliefs() do
		if CanSelectEnhancerBelief(row) then
			local beliefInst:table = m_pSelectBeliefsIM:GetInstance();
			beliefInst.BeliefLabel:LocalizeAndSetText(Locale.ToUpper(row.Name));
			beliefInst.BeliefDescription:LocalizeAndSetText(row.Description);
			SetBeliefIcon(beliefInst.BeliefIcon, row.BeliefType, SIZE_BELIEF_ICON_LARGE);
			beliefInst.BeliefButton:RegisterCallback(Mouse.eLClick, function() ChangeSelectState(beliefInst); end);
			beliefInst.BeliefButton:SetVoid1(row.Index)
		end
	end
	
end

-- ===========================================================================
function ChangeSelectState(instance:table)
  local beliefId = instance.BeliefButton:GetVoid1()
  local beliefClassType = GameInfo.Beliefs[beliefId].BeliefClassType

  if beliefClassType == 'BELIEF_CLASS_FOUNDER' then
    if m_SelectedInst.FounderBelief ~= nil then
      m_SelectedInst.FounderBelief.BeliefButton:SetSelected(false)
      if m_SelectedInst.FounderBelief.BeliefButton:GetVoid1() ~= beliefId then
        instance.BeliefButton:SetSelected(true)
        m_SelectedInst.FounderBelief = instance
        print('重新选择了一个新的创始人信仰')
      else
        m_SelectedInst.FounderBelief = nil
        print('取消选择创始人信仰')
      end
    else
      instance.BeliefButton:SetSelected(true)
      m_SelectedInst.FounderBelief = instance
      print('选择了一个创始人信仰')
    end
  elseif beliefClassType == 'BELIEF_CLASS_ENHANCER' then
    if m_SelectedInst.EnhancerBelief ~= nil then
      m_SelectedInst.EnhancerBelief.BeliefButton:SetSelected(false)
      if m_SelectedInst.EnhancerBelief.BeliefButton:GetVoid1() ~= beliefId then
        instance.BeliefButton:SetSelected(true)
        m_SelectedInst.EnhancerBelief = instance
        print('重新选择了一个新的强化信仰')
      else
        m_SelectedInst.EnhancerBelief = nil
        print('取消选择强化信仰')
      end
    else
      instance.BeliefButton:SetSelected(true)
      m_SelectedInst.EnhancerBelief = instance
      print('选择了一个强化信仰')
    end
  end
	
	CheckConfirm()
end

-- ===========================================================================
function CheckConfirm()
	Controls.ConfirmButton:SetDisabled(true)
	
	if (POTALA_PALACE_EXTRA_FOUNDER == 0 or m_SelectedInst.FounderBelief ~= nil) and (POTALA_PALACE_EXTRA_ENHANCER == 0 or m_SelectedInst.EnhancerBelief ~= nil) then
		Controls.ConfirmButton:SetDisabled(false)
	end
end

-- ===========================================================================
function SetBeliefIcon(targetControl:table, beliefType:string, iconSize:number)
	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas("ICON_" .. beliefType, iconSize);
	if(textureSheet == nil or textureSheet == "") then
		error("Could not find icon in SetBeliefIcon: beliefType=\""..beliefType.."\", iconSize="..tostring(iconSize) );
	else
		targetControl:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
		targetControl:SetSizeVal(iconSize, iconSize);
	end
end

-- ===========================================================================
function CanSelectFounderBelief(kBeliefDef:table)
  if POTALA_PALACE_EXTRA_FOUNDER ~= 0 and kBeliefDef.BeliefClassType == 'BELIEF_CLASS_FOUNDER' and not m_pGameReligion:IsInSomeReligion(kBeliefDef.Index) then
    return true;
  end
	return false;
end

function CanSelectEnhancerBelief(kBeliefDef:table)
  if POTALA_PALACE_EXTRA_ENHANCER ~= 0 and kBeliefDef.BeliefClassType == 'BELIEF_CLASS_ENHANCER' and not m_pGameReligion:IsInSomeReligion(kBeliefDef.Index) then
    return true;
  end
	return false;
end

-- ===========================================================================
function DeselectedAll(kInstances)
  if m_SelectedInst.FounderBelief ~= nil then
    m_SelectedInst.FounderBelief.BeliefButton:SetSelected(false)
  end

  if m_SelectedInst.EnhancerBelief ~= nil then
    m_SelectedInst.EnhancerBelief.BeliefButton:SetSelected(false)
  end

	m_SelectedInst = {
    FounderBelief = nil,
    EnhancerBelief = nil
  };
end

-- ===========================================================================
function OnConfirm()
	if Players[Game.GetLocalPlayer()]:IsTurnActive() then

    local param = {}
    param['OnStart'] = 'PotalaAddExtraBelief'
    if m_SelectedInst.FounderBelief ~= nil then
      param['FounderBelief'] = m_SelectedInst.FounderBelief.BeliefButton:GetVoid1()
    end
    if m_SelectedInst.EnhancerBelief ~= nil then
      param['EnhancerBelief'] = m_SelectedInst.EnhancerBelief.BeliefButton:GetVoid1()
    end
    
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, param)
    UI.PlaySound("Confirm_Religion");
    m_Selected = true;
		Close()
	end
end

-- ===========================================================================
function OnInit(isReload:boolean)
end

function OnInputHandler(pInputStruct:table)
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp and pInputStruct:GetKey() == Keys.VK_ESCAPE then
		if not ContextPtr:IsHidden() then
			Close();
		end
		return true;
	end
	return false;
end
-- ===========================================================================
function OnTogglePanel()
	if ContextPtr:IsHidden() then
		Open()
	else
		Close()
	end
end
-- ===========================================================================
function Open()
	if (Game.GetLocalPlayer() == -1) then
		return
	end

	ContextPtr:SetHide(false);
	
	Controls.PantheonChooserSlideAnim:SetToBeginning();
	Controls.PantheonChooserSlideAnim:Play();

	UI.PlaySound("Tech_Tray_Slide_Open");
	LuaEvents.PotalaPanel_Opened();
	
	Realize()
end

function CloseButtonCallback()
  print("布达拉宫 关闭界面")
  Close()
  -- if not m_Selected then
  --   print("布达拉宫 未成功进行选择 再次发起通知")
  --   LuaEvents.Potala_SendNotification()
  -- end
end

function Close()
	DeselectedAll(m_SelectedInst)
	if not Controls.PantheonChooserSlideAnim:IsReversing() then
		Controls.PantheonChooserSlideAnim:SetToEnd();
		Controls.PantheonChooserSlideAnim:Reverse();

		UI.PlaySound("Tech_Tray_Slide_Closed");
		if m_Inited then LuaEvents.PotalaPanel_Closed(m_Selected); end
	end
end
-- ===========================================================================
function CloseOtherPanels()
  LuaEvents.LaunchBar_CloseTechTree()
  LuaEvents.LaunchBar_CloseCivicsTree()
  LuaEvents.LaunchBar_CloseGovernmentPanel()
  LuaEvents.LaunchBar_CloseReligionPanel()
  LuaEvents.LaunchBar_CloseGreatPeoplePopup()
  LuaEvents.LaunchBar_CloseGreatWorksOverview()
  if m_IsXP1Active then
    LuaEvents.GovernorPanel_Close()
    LuaEvents.HistoricMoments_Close()
  end
  if m_IsXP2Active then
    LuaEvents.Launchbar_Expansion2_ClimateScreen_Close()
  end
end
-- ===========================================================================
function OnAnimEnd()
	if Controls.PantheonChooserSlideAnim:IsReversing() then
		-- If we're reversing due to closing the panel then hide the context after that anim ends
		ContextPtr:SetHide(true);
	end
end

-- ===========================================================================
function Initialize()
	
	ContextPtr:SetHide(true);
	ContextPtr:SetInitHandler(OnInit);
	ContextPtr:SetInputHandler(OnInputHandler, true);

	Controls.ConfirmButton:RegisterCallback(Mouse.eLClick, OnConfirm)
	Controls.Header_CloseButton:RegisterCallback(Mouse.eLClick, CloseButtonCallback);
	Controls.PantheonChooserSlideAnim:RegisterEndCallback(OnAnimEnd);

	LuaEvents.Potala_TogglePopup.Add(OnTogglePanel);
	LuaEvents.PotalaPanel_Opened.Add(CloseOtherPanels);
	
	LuaEvents.DiplomacyActionView_HideIngameUI.Add(Close)
  LuaEvents.EndGameMenu_Shown.Add(Close)
  LuaEvents.FullscreenMap_Shown.Add(Close)
  LuaEvents.NaturalWonderPopup_Shown.Add(Close)
  LuaEvents.ProjectBuiltPopup_Shown.Add(Close)
  LuaEvents.Tutorial_ToggleInGameOptionsMenu.Add(Close)
  LuaEvents.WonderBuiltPopup_Shown.Add(Close)
  LuaEvents.NaturalDisasterPopup_Shown.Add(Close)  
  LuaEvents.RockBandMoviePopup_Shown.Add(Close)
	LuaEvents.CivicsTree_OpenCivicsTree.Add(Close);	
	LuaEvents.Government_OpenGovernment.Add(Close);
	LuaEvents.GovernorPanel_Opened.Add(Close);	
	LuaEvents.GreatPeople_OpenGreatPeople.Add(Close);
	LuaEvents.GreatWorks_OpenGreatWorks.Add(Close);
	LuaEvents.HistoricMoments_Opened.Add(Close);
	LuaEvents.Religion_OpenReligion.Add(Close);	
	LuaEvents.PantheonChooser_OpenReligion.Add(Close);	
	LuaEvents.TechTree_OpenTechTree.Add(Close);
	LuaEvents.ClimateScreen_Opened.Add(Close);
end

Initialize();