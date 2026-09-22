-- Copyright 2017-2018, Firaxis Games
include("ActionPanel");
include("GameCapabilities");

print("HD Action Panel Loaded")

ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

BASE_OnRefresh = OnRefresh;
BASE_LateInitialize = LateInitialize;
BASE_DoEndTurn = DoEndTurn;

local governorAppointmentString:string = Locale.Lookup("LOC_ACTION_PANEL_GOVERNOR_APPOINTMENT");
local governorAppointmentTooltip:string = Locale.Lookup("LOC_ACTION_PANEL_GOVERNOR_APPOINTMENT_TOOLTIP");
local governorOpportunityString:string = Locale.Lookup("LOC_ACTION_PANEL_GOVERNOR_OPPORTUNITY");
local governorOpportunityTooltip:string = Locale.Lookup("LOC_ACTION_PANEL_GOVERNOR_OPPORTUNITY_TOOLTIP");
local governorPromotionString:string = Locale.Lookup("LOC_ACTION_PANEL_GOVERNOR_PROMOTION");
local governorPromotionTooltip:string = Locale.Lookup("LOC_ACTION_PANEL_GOVERNOR_PROMOTION_TOOLTIP");
local governorIdleString:string = Locale.Lookup("LOC_ACTION_PANEL_GOVERNOR_IDLE");
local governorIdleTooltip:string = Locale.Lookup("LOC_ACTION_PANEL_GOVERNOR_IDLE_TOOLTIP");
local considerDisloyalCityString:string = Locale.Lookup("LOC_ACTION_PANEL_CONSIDER_DISLOYAL_CITY");
local considerDisloyalCityTooltip:string = Locale.Lookup("LOC_ACTION_PANEL_CONSIDER_DISLOYAL_CITY_TOOLTIP");
local EmergencyAttentionString:string = Locale.Lookup("LOC_NOTIFICATION_EMERGENCY_NEEDS_ATTENTION_MESSAGE");
local EmergencyAttentionTooltip:string = Locale.Lookup("LOC_NOTIFICATION_EMERGENCY_NEEDS_ATTENTION_SUMMARY");
local commemorationAvailableString:string = Locale.Lookup("LOC_NOTIFICATION_COMMEMORATION_AVAILABLE_MESSAGE");
local commemorationAvailableTooltip:string = Locale.Lookup("LOC_NOTIFICATION_COMMEMORATION_AVAILABLE_SUMMARY");

g_kMessageInfo[EndTurnBlockingTypes.ENDTURN_BLOCKING_GOVERNOR_APPOINTMENT]		= {Message = governorAppointmentString,		ToolTip = governorAppointmentTooltip	, Icon="ICON_NOTIFICATION_GOVERNOR_APPOINTMENT_AVAILABLE"	};
g_kMessageInfo[EndTurnBlockingTypes.ENDTURN_BLOCKING_GOVERNOR_OPPORTUNITY]		= {Message = governorOpportunityString,		ToolTip = governorOpportunityTooltip	, Icon="ICON_NOTIFICATION_GOVERNOR_OPPORTUNITY_AVAILABLE"	};
g_kMessageInfo[EndTurnBlockingTypes.ENDTURN_BLOCKING_GOVERNOR_PROMOTION]		= {Message = governorPromotionString,		ToolTip = governorPromotionTooltip		, Icon="ICON_NOTIFICATION_GOVERNOR_PROMOTION_AVAILABLE"	};
g_kMessageInfo[EndTurnBlockingTypes.ENDTURN_BLOCKING_GOVERNOR_IDLE]				= {Message = governorIdleString,			ToolTip = governorIdleTooltip			, Icon="ICON_NOTIFICATION_GOVERNOR_IDLE"	};
g_kMessageInfo[EndTurnBlockingTypes.ENDTURN_BLOCKING_CONSIDER_DISLOYAL_CITY]	= {Message = considerDisloyalCityString,	ToolTip = considerDisloyalCityTooltip	, Icon="ICON_NOTIFICATION_CONSIDER_DISLOYAL_CITY"			};
g_kMessageInfo[EndTurnBlockingTypes.ENDTURN_BLOCKING_EMERGENCY_NEEDS_ATTENTION]	= {Message = EmergencyAttentionString,	ToolTip = EmergencyAttentionTooltip			, Icon="ICON_NOTIFICATION_TURNBLOCKER_EMERGENCY"			};
g_kMessageInfo[EndTurnBlockingTypes.ENDTURN_BLOCKING_COMMEMORATION_AVAILABLE]	= {Message = commemorationAvailableString,	ToolTip = commemorationAvailableTooltip	, Icon="ICON_NOTIFICATION_COMMEMORATION_AVAILABLE"			};

local COMMEMORATION_HAS_TAG = 'HD_COMMEMORATION_HAS_';

-- ===========================================================================
function OnRefresh()

	BASE_OnRefresh();

	local localPlayerID : number = Game.GetLocalPlayer();
	local pPlayerConfig : object = PlayerConfigurations[localPlayerID];

	if ((localPlayerID == PlayerTypes.NONE) or (not pPlayerConfig:IsAlive())) then
		return;
	end

	local gameEras : table = Game.GetEras();
	local score : number	= gameEras:GetPlayerCurrentScore(localPlayerID);
	local detailsString : string = Locale.Lookup("LOC_ERA_SCORE_HEADER") .. " " .. score;
	local isFinalEra:boolean = gameEras:GetCurrentEra() == gameEras:GetFinalEra();
	local localPlayer	: table = Players[localPlayerID];

	if not isFinalEra then
		detailsString = detailsString .. Locale.Lookup("LOC_DARK_AGE_THRESHOLD_TEXT", gameEras:GetPlayerDarkAgeThreshold(localPlayerID));
		detailsString = detailsString .. Locale.Lookup("LOC_GOLDEN_AGE_THRESHOLD_TEXT", gameEras:GetPlayerGoldenAgeThreshold(localPlayerID));
	end
	detailsString = detailsString .. "[NEWLINE][NEWLINE]";

	--Set our animation based on our current age
	if gameEras:HasHeroicGoldenAge(localPlayerID) then
		Controls.TurnAgeAnimation:SetTexture("ActionPanel_TurnProcessing_Heroic");
		Controls.EndTurnButtonLabel:SetTexture("ActionPanel_TurnBlocker_Heroic");
		Controls.GoldenAgeAnimation:SetHide(false);
		Controls.DarkAgeShadow:SetHide(true);
		--Tooltip setup
		detailsString = detailsString .. Locale.Lookup("LOC_ERA_TT_HAVE_HEROIC_AGE_EFFECT_PARAM", {Name = "Amount", Value=localPlayer:GetCivilianLoyalty()});
	elseif gameEras:HasGoldenAge(localPlayerID) then
		Controls.TurnAgeAnimation:SetTexture("ActionPanel_TurnProcessing_Golden");
		Controls.EndTurnButtonLabel:SetTexture("ActionPanel_TurnBlocker_Golden");
		Controls.GoldenAgeAnimation:SetHide(false);
		Controls.DarkAgeShadow:SetHide(true);
		--Tooltip setup
		detailsString = detailsString .. Locale.Lookup("LOC_ERA_TT_HAVE_GOLDEN_AGE_EFFECT_PARAM", {Name = "Amount", Value=localPlayer:GetCivilianLoyalty()});
	elseif gameEras:HasDarkAge(localPlayerID) then
		Controls.TurnAgeAnimation:SetTexture("ActionPanel_TurnProcessing_Dark");
		Controls.EndTurnButtonLabel:SetTexture("ActionPanel_TurnBlocker_Dark");
		Controls.DarkAgeShadow:SetHide(false);
		Controls.GoldenAgeAnimation:SetHide(true);
		--Tooltip setup
		detailsString = detailsString .. Locale.Lookup("LOC_ERA_TT_HAVE_DARK_AGE_EFFECT_PARAM", {Name = "Amount", Value=localPlayer:GetCivilianLoyalty()});
	else
		Controls.TurnAgeAnimation:SetTexture("ActionPanel_TurnProcessing");
		Controls.EndTurnButtonLabel:SetTexture("ActionPanel_TurnBlocker");
		Controls.DarkAgeShadow:SetHide(true);
		Controls.GoldenAgeAnimation:SetHide(true);
		--Tooltip setup
		detailsString = detailsString ..Locale.Lookup("LOC_ERA_TT_HAVE_NORMAL_AGE_EFFECT_PARAM", {Name = "Amount", Value=localPlayer:GetCivilianLoyalty()});
	end
	
	--Set our bar state
	local baseline = gameEras:GetPlayerThresholdBaseline(localPlayerID);
	local darkAgeThreshold = gameEras:GetPlayerDarkAgeThreshold(localPlayerID);
	local goldenAgeThreshold = gameEras:GetPlayerGoldenAgeThreshold(localPlayerID);
	local ageIconName = "[ICON_GLORY_NORMAL_AGE]";
	Controls.TurnTimerMeterWarning:SetHide(true);
	Controls.AgeLabelCurrent:SetColorByName("Age_Normal");
	if score >= darkAgeThreshold then
		--We are working towards, or scored Golden age
		ageIconName = gameEras:HasDarkAge(localPlayerID) and "[ICON_GLORY_GOLDEN_AGE]" or "[ICON_GLORY_SUPER_GOLDEN_AGE]";
		if score >= goldenAgeThreshold then
			--Just working toward a golden age
			Controls.TurnTimerMeterGolden:SetTexture("ActionPanel_AgeMeterFill_Golden");
			Controls.AgeLabelCurrent:SetColorByName("Age_Golden");
		end
	else
		--Is the age ending? If so, show the red warning
		local eraCountdown = gameEras:GetNextEraCountdown() + 1; -- 0 turns remaining is the last turn, shift by 1 to make sense to non-programmers
		if eraCountdown ~= nil and eraCountdown ~= 0 then
			Controls.TurnTimerMeterWarning:SetHide(false);
			Controls.AgeLabelCurrent:SetColorByName("Age_Warning");
			ageIconName = "[ICON_GLORY_DARK_AGE]";
		end
	end

	Controls.AgeLabelCurrent:SetText(ageIconName .. score .. " ");
	Controls.AgeLabelTotal:SetText(" " .. (score > darkAgeThreshold and goldenAgeThreshold or darkAgeThreshold));
	local normalPercent = 1;
	if ((darkAgeThreshold - baseline) > 0) then -- If this is negative then our baseline is already past the threshold, so show the full meter
		normalPercent = (score - baseline) / (darkAgeThreshold - baseline);
	end
	Controls.TurnTimerMeterNormal:SetPercent(normalPercent);
	local goldenPercent = 1;
	-- in Dramatic Ages, goldenAgeThreshold is equal to darkAgeThreshold because there are no normal ages
	if HasCapability("CAPABILITY_DRAMATICAGES") then
		goldenPercent = (score - baseline) / (goldenAgeThreshold - baseline);
		-- Dramatic Ages has no normal eras, so don't show that part of the meter
		Controls.TurnTimerMeterNormal:SetPercent(0);
	else
		if ((goldenAgeThreshold - darkAgeThreshold) ~= 0) then
			goldenPercent = (score - darkAgeThreshold) / (goldenAgeThreshold - darkAgeThreshold);
		end
	end
	Controls.TurnTimerMeterGolden:SetPercent(goldenPercent);

	Controls.AgeScoreStack:CalculateSize();
	Controls.AgeButtonBG:SetSizeX(Controls.AgeScoreStack:GetSizeX() + 24);

	Controls.TurnAgeAnimation:Play();

	--Are we in the last age
	if isFinalEra then
		Controls.TurnTimerMeterBG:SetHide(true);
		Controls.TurnTimerMeterGolden:SetHide(true);
		Controls.TurnTimerMeterNormal:SetHide(true);
		Controls.TurnTimerMeterWarning:SetHide(true);
		Controls.AgeLabelTotal:SetHide(true);
		Controls.AgeLabelDivider:SetHide(true);
		Controls.AgeLabelCurrent:SetColorByName("Age_Normal");
		if gameEras:HasDarkAge() then
			Controls.AgeLabelCurrent:SetText("[ICON_GLORY_DARK_AGE]" .. score);
		elseif gameEras:HasGoldenAge() then
			Controls.AgeLabelCurrent:SetText("[ICON_GLORY_GOLDEN_AGE]" .. score);
		else
			Controls.AgeLabelCurrent:SetText("[ICON_GLORY_NORMAL_AGE]" .. score);
		end

	end

	--Tooltip
  if Utils.CivilizationHasTrait(localPlayerID, 'TRAIT_CIVILIZATION_DYNASTIC_CYCLE') then
    -- 中国UA适配
    local bonusText = "";
    local player = Players[localPlayerID];
    -- 查询专属着力点
    for row in GameInfo.China_AncientCommemorationTypes_HD() do
      if player:GetProperty(COMMEMORATION_HAS_TAG .. 'ANCIENT_' .. row.Index) == 1 then
        bonusText = bonusText .. "[NEWLINE][ICON_BULLET]" .. Locale.Lookup("LOC_MOMENT_ACTION_PANEL_TEXT", row.Name, row.Description);
      end
    end
    -- 查询通用着力点
    for row in GameInfo.CommemorationTypes() do
      if player:GetProperty(COMMEMORATION_HAS_TAG .. row.Index) == 1 then
        if (gameEras:HasGoldenAge(localPlayerID)) then
          bonusText = bonusText .. "[NEWLINE][ICON_BULLET]" .. Locale.Lookup("LOC_MOMENT_ACTION_PANEL_TEXT", row.CategoryDescription, row.GoldenAgeBonusDescription);
          if (gameEras:IsPlayerAlwaysAllowedCommemorationQuest(localPlayerID)) then
            bonusText = bonusText .. Locale.Lookup(row.NormalAgeBonusDescription);
          end
        elseif (gameEras:HasDarkAge(localPlayerID)) then
          bonusText = bonusText .. "[NEWLINE][ICON_BULLET]" .. Locale.Lookup("LOC_MOMENT_ACTION_PANEL_TEXT", row.CategoryDescription, row.DarkAgeBonusDescription);
        else
          bonusText = bonusText .. "[NEWLINE][ICON_BULLET]" .. Locale.Lookup("LOC_MOMENT_ACTION_PANEL_TEXT", row.CategoryDescription, row.NormalAgeBonusDescription);
        end
      end
    end
    -- 描述合并
    if bonusText ~= "" then
      detailsString = detailsString .. "[NEWLINE]" .. bonusText;
    end
  else
    -- 其他文明 正常显示
		local bonusText = "";
    local activeCommemorations = gameEras:GetPlayerActiveCommemorations(localPlayerID);

    for i,activeCommemoration in ipairs(activeCommemorations) do
      local commemorationInfo = GameInfo.CommemorationTypes[activeCommemoration];
      if (commemorationInfo ~= nil) then
        if (gameEras:HasGoldenAge(localPlayerID)) then
          bonusText = bonusText .. "[NEWLINE][ICON_BULLET]" .. Locale.Lookup("LOC_MOMENT_ACTION_PANEL_TEXT", commemorationInfo.CategoryDescription, commemorationInfo.GoldenAgeBonusDescription);
          if (gameEras:IsPlayerAlwaysAllowedCommemorationQuest(localPlayerID)) then
            bonusText = bonusText .. Locale.Lookup(commemorationInfo.NormalAgeBonusDescription);
          end
        elseif (gameEras:HasDarkAge(localPlayerID)) then
          bonusText = bonusText .. "[NEWLINE][ICON_BULLET]" .. Locale.Lookup("LOC_MOMENT_ACTION_PANEL_TEXT", commemorationInfo.CategoryDescription, commemorationInfo.DarkAgeBonusDescription);
        else
          bonusText = bonusText .. "[NEWLINE][ICON_BULLET]" .. Locale.Lookup("LOC_MOMENT_ACTION_PANEL_TEXT", commemorationInfo.CategoryDescription, commemorationInfo.NormalAgeBonusDescription);
        end
      end
    end

		if bonusText ~= "" then
      detailsString = detailsString .. "[NEWLINE]" .. bonusText;
    end
  end

	
	
	Controls.AgeButtonBG:SetToolTipString(detailsString);

	RealizeEraIndicator();
end

-- ===========================================================================
-- Set the era rotation and tooltip.
-- ===========================================================================
function RealizeEraIndicator()

	if HasCapability("CAPABILITY_ERAS")==false then
		Controls.EraIndicator:SetHide( true );
		return;
	end
	
	local displayEra:number = 1;
	if (Game ~= nil and Game.GetEras() ~= nil) then
		displayEra = Game.GetEras():GetCurrentEra() + 1; -- Engine is 0 Based
	else
		UI.DataError("Unable to obtain eras from Game object while realizing ActionPanel.");
		return;
	end
	
	local gameEras :table = Game.GetEras();
	for _,kEra in pairs(g_kEras) do
		if kEra.Index == displayEra then
			local description:string = Locale.Lookup("LOC_GAME_ERA_DESC", kEra.Description );
			local turnsTill :number = gameEras:GetNextEraCountdown() + 1;	-- 0 turns remaining is the last turn, shift by 1 to make sense to non-programmers
			if turnsTill > 0 then
				 description = description .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_GLORY_HUD_ERA_ENDS_IN", turnsTill);
			end
			Controls.EraToolTipArea1:SetToolTipString( description );
			Controls.EraToolTipArea2:SetToolTipString( description );
			Controls.EraIndicator:Rotate( kEra.Degree + 90 );	-- 0 degree in art points "left"
			break;
		end		
	end
end

-- ===========================================================================
function OnAgeButtonClicked()
	LuaEvents.PartialScreenHooks_Expansion1_ToggleEraProgress();
end

-- ===========================================================================
function LateInitialize()
	BASE_LateInitialize();
	Controls.AgeButtonBG:RegisterCallback( Mouse.eLClick, OnAgeButtonClicked )
	ContextPtr:SetRefreshHandler(OnRefresh);
end

-- ===========================================================================
--	政策卡更换提醒 Mod 适配
-- ===========================================================================
local isPolicyChangeReminderActive: boolean = Modding.IsModActive("2778f75d-9c72-4919-a081-620f6482f5d6");
-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local reminderTitle 				:string = Locale.Lookup("LOC_FF16_NEWPOLICY_TITLE");
local reminderDesc 					:string = Locale.Lookup("LOC_FF16_NEWPOLICY_DESC");
local reminderChange 				:string = Locale.Lookup("LOC_FF16_NEWPOLICY_CHANGE");
local reminderContinue 				:string = Locale.Lookup("LOC_FF16_NEWPOLICY_CONTINUE");
													  
-- ===============================================================================================
--	Override for - Attempt to end the turn or execute the most current blocking notification
-- ===============================================================================================
function DoEndTurn( optionalNewBlocker:number )
	if not isPolicyChangeReminderActive then return BASE_DoEndTurn(optionalNewBlocker); end

	print("开启政策卡更换提醒 Mod")
	local pPlayer = Players[Game.GetLocalPlayer()];
	if (pPlayer == nil) then
		return;
	end
	
	--FF16 - Get Culture info.
	local kCulture:table	= pPlayer:GetCulture();
	--FF16 - Get Civic unlocked this turn, if any. Used later to not prompt on Future Civic Completion.
	local lastCivicInfo = GameInfo.Civics[kCulture:GetCivicCompletedThisTurn()];
	if(lastCivicInfo == nil) then lastCivicInfo = "None"; end
	--print(lastCivicInfo);
	--print("New Policy Cards?", kCulture:CivicCompletedThisTurn());
	--print("Cards have been changed?", kCulture:PolicyChangeMade());

	-- If the player can unready their turn, request that.
	-- CanUnreadyTurn() only checks the gamecore state. IsTurnTimerElapsed() is also required to ensure the local player still has turn time remaining.
	if pPlayer:CanUnreadyTurn()
		and not UI.IsTurnTimerElapsed(Game.GetLocalPlayer()) then
		UI.RequestAction(ActionTypes.ACTION_UNREADYTURN);	
		return;
	end

	if UI.IsProcessingMessages() then
		print("ActionPanel:DoEndTurn() The game is busy processing messages");
		return;
	end

	-- If not in selection mode; reset mode before performing the action.
	if UI.GetInterfaceMode() ~= InterfaceModeTypes.SELECTION then
		UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
	end

	-- Make sure if an active blocker is not set, to do one more check from the engine/authority.
	if optionalNewBlocker ~= nil then
		m_activeBlockerId = optionalNewBlocker;
	else
		m_activeBlockerId = NotificationManager.GetFirstEndTurnBlocking(Game.GetLocalPlayer());
	end
	
	if m_activeBlockerId == EndTurnBlockingTypes.NO_ENDTURN_BLOCKING then
		if (CheckUnitsHaveMovesState()) then
			UI.SelectNextReadyUnit();
		elseif(CheckCityRangeAttackState()) then
			local attackCity = pPlayer:GetCities():GetFirstRangedAttackCity();
			if(attackCity ~= nil) then
				UI.SelectCity(attackCity);
				UI.SetInterfaceMode(InterfaceModeTypes.CITY_RANGE_ATTACK);
			else
				UI.DataError( "Unable to find selectable attack city while in CheckCityRangeAttackState()" );
			end

		--========================================================================================================================================--
		--FF16~ Add a reminder about new policies being unlocked. 
		elseif(kCulture:CivicCompletedThisTurn() and not kCulture:PolicyChangeMade() and Game.GetCurrentGameTurn() ~= 1 and lastCivicInfo.CivicType ~= "CIVIC_FUTURE_CIVIC") then	  
			local m_kPopupDialog:table = PopupDialogInGame:new( "ContinueWithoutChangingPoliciesPrompt" );
			m_kPopupDialog:AddTitle(reminderTitle);
			m_kPopupDialog:AddText(reminderDesc);
			m_kPopupDialog:AddCancelButton(reminderChange, function() 
				LuaEvents.NotificationPanel_GovernmentOpenPolicies();
			end );
			m_kPopupDialog:AddConfirmButton(reminderContinue, function()
				UI.RequestAction(ActionTypes.ACTION_ENDTURN);		
				UI.PlaySound("Stop_Unit_Movement_Master");
			end );
			m_kPopupDialog:Open();		
		else
			UI.RequestAction(ActionTypes.ACTION_ENDTURN);		
			UI.PlaySound("Stop_Unit_Movement_Master");
		end
		--========================================================================================================================================--

	elseif (   m_activeBlockerId == EndTurnBlockingTypes.ENDTURN_BLOCKING_STACKED_UNITS
			or m_activeBlockerId == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNIT_NEEDS_ORDERS
			or m_activeBlockerId == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNITS)	then
		UI.SelectNextReadyUnit();
	else		

		-- generic turn blocker, trigger the notification associated with the turn blocker.
		local pNotification :table = NotificationManager.FindEndTurnBlocking(m_activeBlockerId, Game.GetLocalPlayer());
		
		if pNotification == nil then
			-- Notification is missing.  Use fallback behavior.
			if not UI.CanEndTurn() then
				UI.DataError("The UI thinks that we can't end turn, but the notification system disagrees.");
				return;
			end				
			UI.RequestAction(ActionTypes.ACTION_ENDTURN);		
			return;
		end

		-- Raise the event across the UI which may be listening for this particular notification.
		LuaEvents.ActionPanel_ActivateNotification( pNotification );
	end
end