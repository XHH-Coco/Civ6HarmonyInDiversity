-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================
local BASE_RegisterHandlers = RegisterHandlers;

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local HASH_NOTIFICATION_JNR_HOSPITAL_PREVENT_POP_LOST = DB.MakeHash('NOTIFICATION_JNR_HOSPITAL_PREVENT_POP_LOST');
local HASH_NOTIFICATION_JNR_HOSPITAL_EXTRA_POP_BOOST = DB.MakeHash('NOTIFICATION_JNR_HOSPITAL_EXTRA_POP_BOOST');

local HASH_NOTIFICATION_YONGLE_REWARD = DB.MakeHash('NOTIFICATION_YONGLE_REWARD');
local HASH_NOTIFICATION_QIXIA_XIYANG = DB.MakeHash('NOTIFICATION_QIXIA_XIYANG');
local HASH_NOTIFICATION_PLUM_INTERNAL_SECURITY_GPP = DB.MakeHash('NOTIFICATION_PLUM_INTERNAL_SECURITY_GPP');

local HASH_NOTIFICATION_SUMERIA_FREE_TECH = DB.MakeHash('NOTIFICATION_SUMERIA_FREE_TECH');
local HASH_NOTIFICATION_SUMERIA_FREE_CIVIC = DB.MakeHash('NOTIFICATION_SUMERIA_FREE_CIVIC');
local HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST = DB.MakeHash('NOTIFICATION_SUMERIA_SPECIAL_QUEST');
local HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST_REWORD = DB.MakeHash('NOTIFICATION_SUMERIA_SPECIAL_QUEST_REWORD');

local HASH_NOTIFICATION_LEADER_MAGNIFICENCES_WONDER = DB.MakeHash('NOTIFICATION_LEADER_MAGNIFICENCES_WONDER');
local HASH_NOTIFICATION_ARABIA_TRANSFORM_GPP = DB.MakeHash('NOTIFICATION_ARABIA_TRANSFORM_GPP');
local HASH_NOTIFICATION_POLAND_ALLIANCE_COPY_GPP = DB.MakeHash('NOTIFICATION_POLAND_ALLIANCE_COPY_GPP');
local HASH_NOTIFICATION_MEDITERRANEAN_REWARD = DB.MakeHash('NOTIFICATION_MEDITERRANEAN_REWARD');
local HASH_NOTIFICATION_GLORIOUS_VICTORY_REWARD = DB.MakeHash('NOTIFICATION_GLORIOUS_VICTORY_REWARD');

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
function OnActivate(notificationEntry)
  if (notificationEntry ~= nil and notificationEntry.m_PlayerID == Game.GetLocalPlayer()) then
    local pNotification = GetActiveNotificationFromEntry(notificationEntry);
    if pNotification ~= nil then
      notificationEntry.m_kHandlers.TryDismiss(notificationEntry);
    end
  end
end

function OnDismiss(notificationEntry)
  if (notificationEntry ~= nil and notificationEntry.m_PlayerID == Game.GetLocalPlayer()) then
    OnDefaultTryDismissNotification(notificationEntry)
  end
end

-- ===========================================================================
--	Register
-- ===========================================================================
function RegisterHandlers()
  BASE_RegisterHandlers();

  g_notificationHandlers[HASH_NOTIFICATION_JNR_HOSPITAL_PREVENT_POP_LOST] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_JNR_HOSPITAL_PREVENT_POP_LOST].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_JNR_HOSPITAL_PREVENT_POP_LOST].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_JNR_HOSPITAL_EXTRA_POP_BOOST] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_JNR_HOSPITAL_EXTRA_POP_BOOST].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_JNR_HOSPITAL_EXTRA_POP_BOOST].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_YONGLE_REWARD] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_YONGLE_REWARD].AddSound = 'ALERT_POSITIVE';
	g_notificationHandlers[HASH_NOTIFICATION_YONGLE_REWARD].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_YONGLE_REWARD].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_QIXIA_XIYANG] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_QIXIA_XIYANG].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_QIXIA_XIYANG].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_PLUM_INTERNAL_SECURITY_GPP] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_PLUM_INTERNAL_SECURITY_GPP].AddSound = 'NOTIFICATION_ESPIONAGE_OP_SUCCESS';
	g_notificationHandlers[HASH_NOTIFICATION_PLUM_INTERNAL_SECURITY_GPP].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_PLUM_INTERNAL_SECURITY_GPP].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_FREE_TECH] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_FREE_TECH].AddSound = 'NOTIFICATION_ESPIONAGE_OP_SUCCESS';
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_FREE_TECH].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_FREE_TECH].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_FREE_CIVIC] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_FREE_CIVIC].AddSound = 'NOTIFICATION_ESPIONAGE_OP_SUCCESS';
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_FREE_CIVIC].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_FREE_CIVIC].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST_REWORD] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST_REWORD].AddSound = 'NOTIFICATION_ESPIONAGE_OP_SUCCESS';
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST_REWORD].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST_REWORD].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_LEADER_MAGNIFICENCES_WONDER] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_LEADER_MAGNIFICENCES_WONDER].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_LEADER_MAGNIFICENCES_WONDER].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_ARABIA_TRANSFORM_GPP] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_ARABIA_TRANSFORM_GPP].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_ARABIA_TRANSFORM_GPP].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_POLAND_ALLIANCE_COPY_GPP] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_POLAND_ALLIANCE_COPY_GPP].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_POLAND_ALLIANCE_COPY_GPP].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_MEDITERRANEAN_REWARD] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_MEDITERRANEAN_REWARD].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_MEDITERRANEAN_REWARD].TryDismiss = OnDismiss;

  g_notificationHandlers[HASH_NOTIFICATION_GLORIOUS_VICTORY_REWARD] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_NOTIFICATION_GLORIOUS_VICTORY_REWARD].AddSound = 'ALERT_POSITIVE';
	g_notificationHandlers[HASH_NOTIFICATION_GLORIOUS_VICTORY_REWARD].Activate = OnActivate;
	g_notificationHandlers[HASH_NOTIFICATION_GLORIOUS_VICTORY_REWARD].TryDismiss = OnDismiss;
end