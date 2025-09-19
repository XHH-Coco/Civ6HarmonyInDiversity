-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================
local BASE_RegisterHandlers = RegisterHandlers;

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local HASH_CHINA_CHOOSE_FIRST_TURN_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_FIRST_TURN_COMMEMORATION');

local HASH_CHINA_CHOOSE_ERA_ANCIENT_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_ERA_ANCIENT_COMMEMORATION');
local HASH_CHINA_CHOOSE_ERA_CLASSICAL_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_ERA_CLASSICAL_COMMEMORATION');
local HASH_CHINA_CHOOSE_ERA_MEDIEVAL_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_ERA_MEDIEVAL_COMMEMORATION');
local HASH_CHINA_CHOOSE_ERA_RENAISSANCE_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_ERA_RENAISSANCE_COMMEMORATION');
local HASH_CHINA_CHOOSE_ERA_INDUSTRIAL_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_ERA_INDUSTRIAL_COMMEMORATION');
local HASH_CHINA_CHOOSE_ERA_MODERN_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_ERA_MODERN_COMMEMORATION');
local HASH_CHINA_CHOOSE_ERA_ATOMIC_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_ERA_ATOMIC_COMMEMORATION');
local HASH_CHINA_CHOOSE_ERA_INFORMATION_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_ERA_INFORMATION_COMMEMORATION');
local HASH_CHINA_CHOOSE_ERA_FUTURE_COMMEMORATION_NOTIFICATION = DB.MakeHash('NOTIFICATION_CHINA_CHOOSE_ERA_FUTURE_COMMEMORATION');
local HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST = {
  HASH_CHINA_CHOOSE_ERA_ANCIENT_COMMEMORATION_NOTIFICATION,
  HASH_CHINA_CHOOSE_ERA_CLASSICAL_COMMEMORATION_NOTIFICATION,
  HASH_CHINA_CHOOSE_ERA_MEDIEVAL_COMMEMORATION_NOTIFICATION,
  HASH_CHINA_CHOOSE_ERA_RENAISSANCE_COMMEMORATION_NOTIFICATION,
  HASH_CHINA_CHOOSE_ERA_INDUSTRIAL_COMMEMORATION_NOTIFICATION,
  HASH_CHINA_CHOOSE_ERA_MODERN_COMMEMORATION_NOTIFICATION,
  HASH_CHINA_CHOOSE_ERA_ATOMIC_COMMEMORATION_NOTIFICATION,
  HASH_CHINA_CHOOSE_ERA_INFORMATION_COMMEMORATION_NOTIFICATION,
  HASH_CHINA_CHOOSE_ERA_FUTURE_COMMEMORATION_NOTIFICATION
}

-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local IsFirstTurnNotificationExist = false;
local IsFirstTurnChinaChooseCommemorationPanelOpen = false;

local IsNotificationExist =	{false, false, false, false, false, false, false, false, false};
local IsChinaChooseCommemorationPanelOpen =	{false, false, false, false, false, false, false, false, false};

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
-- 发起通知
function ChinaChooseCommemoration_SendNotification(era:number, firstTurn:boolean)
  if firstTurn then
    print("中国开局选择专属远古着力点 收到发送通知的请求")
    if not IsFirstTurnNotificationExist and not IsFirstTurnChinaChooseCommemorationPanelOpen then
      -- 忽略已经存在的同类通知
			DismissSameTypeNotifications(HASH_CHINA_CHOOSE_FIRST_TURN_COMMEMORATION_NOTIFICATION)

      local data = {}
      data[ParameterTypes.MESSAGE] = Locale.Lookup('LOC_TRAIT_CIVILIZATION_DYNASTIC_CYCLE_NAME')
      data[ParameterTypes.SUMMARY] = Locale.Lookup('LOC_CHINA_CHOOSE_ANCIENT_COMMEMORATION_SUBHEADER')

      NotificationManager.SendNotification(Game.GetLocalPlayer(), HASH_CHINA_CHOOSE_FIRST_TURN_COMMEMORATION_NOTIFICATION, data)
      IsFirstTurnNotificationExist = true
    end
  else
    print("中国造奇观 收到发送通知的请求")
    if not IsNotificationExist[era+1] and not IsChinaChooseCommemorationPanelOpen[era+1] then
      -- 忽略已经存在的同类通知
			DismissSameTypeNotifications(HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST[era+1])

      local data = {}
      data[ParameterTypes.MESSAGE] = Locale.Lookup('LOC_TRAIT_CIVILIZATION_DYNASTIC_CYCLE_NAME')
      data[ParameterTypes.SUMMARY] = Locale.Lookup('LOC_CHINA_CHOOSE_COMMEMORATION_SUBHEADER', Locale.Lookup(GameInfo.Eras[era].Name))

      NotificationManager.SendNotification(Game.GetLocalPlayer(), HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST[era+1], data)
      IsNotificationExist[era+1] = true
    end
  end
end

-- 忽略同类通知
function DismissSameTypeNotifications(notificationType)
  local localPlayerID:number = Game.GetLocalPlayer();
  local notificationIds = NotificationManager.GetList(localPlayerID);
  for _, notificationId in ipairs(notificationIds) do
    local notification = NotificationManager.Find(localPlayerID, notificationId);
    if notification ~= nil and notification:GetType() == notificationType then
      if not notification:IsDismissed() then
        print("中国造奇观 忽略同类通知")
        NotificationManager.Dismiss(localPlayerID, notification:GetID());
      end
    end
  end
end

-- 点击通知
function OnChinaFirstTurnChooseCommemorationActivate(notificationEntry)
  if (notificationEntry ~= nil and notificationEntry.m_PlayerID == Game.GetLocalPlayer()) then
    local pNotification = GetActiveNotificationFromEntry(notificationEntry);
    if pNotification ~= nil then
      print("中国开局选择专属远古着力点 点击通知 打开界面")
      LuaEvents.ChinaChooseCommemoration_TogglePopup(0, true);
      notificationEntry.m_kHandlers.TryDismiss(notificationEntry);
      IsFirstTurnNotificationExist = false;
    end
  end
end

function OnChinaChooseCommemorationActivate(notificationEntry)
  if (notificationEntry ~= nil and notificationEntry.m_PlayerID == Game.GetLocalPlayer()) then
    local pNotification = GetActiveNotificationFromEntry(notificationEntry);
    if pNotification ~= nil then
      for era=0,8,1 do
        if pNotification:GetType() == HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST[era+1] then
          print("中国造奇观 点击通知 打开界面", Locale.Lookup(GameInfo.Eras[era].Name))
          LuaEvents.ChinaChooseCommemoration_TogglePopup(era, false);
          notificationEntry.m_kHandlers.TryDismiss(notificationEntry);
          IsNotificationExist[era+1] = false;
        end
      end
    end
  end
end

-- 忽略通知
function OnChinaFirstTurnChooseCommemorationDismiss(notificationEntry)
  if (notificationEntry ~= nil and notificationEntry.m_PlayerID == Game.GetLocalPlayer()) then
    local pNotification = GetActiveNotificationFromEntry(notificationEntry);
    if pNotification ~= nil then
      IsFirstTurnNotificationExist = false
      OnDefaultTryDismissNotification(notificationEntry)
    end
  end
end

function OnChinaChooseCommemorationDismiss(notificationEntry)
  if (notificationEntry ~= nil and notificationEntry.m_PlayerID == Game.GetLocalPlayer()) then
    local pNotification = GetActiveNotificationFromEntry(notificationEntry);
    if pNotification ~= nil then
      for era=0,8,1 do
        if pNotification:GetType() == HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST[era+1] then
          IsNotificationExist[era+1] = false
          OnDefaultTryDismissNotification(notificationEntry)
        end
      end
    end
  end
end

-- 忽略通知
function ChinaChooseCommemoration_NotificationDismissed(iPlayer, iNotification)
  if iPlayer == Game.GetLocalPlayer() then
    local pNotification:table = NotificationManager.Find(iPlayer, iNotification);
    if pNotification and pNotification:GetType() == HASH_CHINA_CHOOSE_FIRST_TURN_COMMEMORATION_NOTIFICATION then
      IsFirstTurnNotificationExist = false;
    else
      for era=0,8,1 do
        if pNotification and pNotification:GetType() == HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST[era+1] then
          IsNotificationExist[era+1] = false
        end
      end
    end
  end
end

-- 回合结束
function ChinaChooseCommemoration_LocalPlayerTurnEnd()
  -- IsFirstTurnNotificationExist = false;
  -- IsNotificationExist = {false, false, false, false, false, false, false, false, false};
end

-- 界面打开
function ChinaChooseCommemorationPanel_Opened(era:number, firstTurn:boolean)
  if firstTurn then
    IsFirstTurnChinaChooseCommemorationPanelOpen = true;
  else
    IsChinaChooseCommemorationPanelOpen[era+1] = true;
  end
end

-- 界面关闭
function ChinaChooseCommemorationPanel_Closed(era:number, firstTurn:boolean, selected:boolean)
  print('ChinaChooseCommemorationPanel_Closed', era, firstTurn, selected)
  if firstTurn then
    IsFirstTurnChinaChooseCommemorationPanelOpen = false;
  else
    IsChinaChooseCommemorationPanelOpen[era+1] = false;
  end

  if selected == false then
    print("中国造奇观 未成功进行选择 再次发起通知", era)
    LuaEvents.ChinaChooseCommemoration_SendNotification(era, firstTurn, selected)
  end
end

-- ===========================================================================
--	Register
-- ===========================================================================
function RegisterHandlers()
  BASE_RegisterHandlers();

  g_notificationHandlers[HASH_CHINA_CHOOSE_FIRST_TURN_COMMEMORATION_NOTIFICATION] = MakeDefaultHandlers();
  g_notificationHandlers[HASH_CHINA_CHOOSE_FIRST_TURN_COMMEMORATION_NOTIFICATION].AddSound = 'NOTIFICATION_MISC_POSITIVE';
  g_notificationHandlers[HASH_CHINA_CHOOSE_FIRST_TURN_COMMEMORATION_NOTIFICATION].Activate = OnChinaFirstTurnChooseCommemorationActivate;
  g_notificationHandlers[HASH_CHINA_CHOOSE_FIRST_TURN_COMMEMORATION_NOTIFICATION].TryDismiss = OnChinaFirstTurnChooseCommemorationDismiss;

  for era=0,8,1 do
    g_notificationHandlers[HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST[era+1]] = MakeDefaultHandlers();
    g_notificationHandlers[HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST[era+1]].AddSound = 'NOTIFICATION_MISC_POSITIVE';
    g_notificationHandlers[HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST[era+1]].Activate = OnChinaChooseCommemorationActivate;
    g_notificationHandlers[HASH_CHINA_CHOOSE_COMMEMORATION_NOTIFICATION_LIST[era+1]].TryDismiss = OnChinaChooseCommemorationDismiss;
  end

  Events.NotificationDismissed.Add(ChinaChooseCommemoration_NotificationDismissed);
	Events.LocalPlayerTurnEnd.Add(ChinaChooseCommemoration_LocalPlayerTurnEnd);

	LuaEvents.ChinaChooseCommemorationPanel_Opened.Add(ChinaChooseCommemorationPanel_Opened);
	LuaEvents.ChinaChooseCommemorationPanel_Closed.Add(ChinaChooseCommemorationPanel_Closed);
  LuaEvents.ChinaChooseCommemoration_SendNotification.Add(ChinaChooseCommemoration_SendNotification);
end