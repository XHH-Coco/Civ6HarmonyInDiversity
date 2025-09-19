-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================
local BASE_RegisterHandlers = RegisterHandlers;

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local HASH_POTALA_NOTIFICATION = DB.MakeHash('NOTIFICATION_POTALA_EXTRA_BELIEF');

-- ===========================================================================
--	VARIABLES
-- ===========================================================================
local IsNotificationExist =	false;
local IsPotalaPanelOpen =	false;

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
-- 发起通知
function Potala_SendNotification()
  print("布达拉宫 收到发送通知的请求")
  if not IsNotificationExist and not IsPotalaPanelOpen then
    -- 忽略已经存在的同类通知
    DismissSameTypeNotifications(HASH_POTALA_NOTIFICATION)

    local data = {}
    data[ParameterTypes.MESSAGE] = Locale.Lookup('LOC_BUILDING_POTALA_PALACE_NAME')
    data[ParameterTypes.SUMMARY] = Locale.Lookup('LOC_BUILDING_POTALA_PALACE_EXTRA_BELIEF_AVAILABLE')

    NotificationManager.SendNotification(Game.GetLocalPlayer(), HASH_POTALA_NOTIFICATION, data)
    IsNotificationExist = true
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
        print("布达拉宫 忽略同类通知")
        NotificationManager.Dismiss(localPlayerID, notification:GetID());
      end
    end
  end
end

-- 点击通知
function OnPotalaBeliefsActivate(notificationEntry)
  if (notificationEntry ~= nil and notificationEntry.m_PlayerID == Game.GetLocalPlayer()) then
    local pNotification = GetActiveNotificationFromEntry(notificationEntry);
    if pNotification ~= nil then
      print("布达拉宫 点击通知 打开界面")
      LuaEvents.Potala_TogglePopup()
      notificationEntry.m_kHandlers.TryDismiss(notificationEntry);
      IsNotificationExist = false
    end
  end
end

-- 忽略通知
function OnPotalaBeliefDismiss(notificationEntry)
  if (notificationEntry ~= nil and notificationEntry.m_PlayerID == Game.GetLocalPlayer()) then
    IsNotificationExist = false
    OnDefaultTryDismissNotification(notificationEntry)
  end
end

-- 忽略通知
function Potala_NotificationDismissed(iPlayer, iNotification)
  if iPlayer == Game.GetLocalPlayer() then
    local pNotification:table = NotificationManager.Find( iPlayer, iNotification );
    if pNotification and pNotification:GetType() == HASH_POTALA_NOTIFICATION then
      IsNotificationExist = false
    end
  end
end

-- 回合结束
function Potala_LocalPlayerTurnEnd()
  -- IsNotificationExist = false
end

-- 界面打开
function PotalaPanel_Opened()
  IsPotalaPanelOpen = true
end

-- 界面关闭
function PotalaPanel_Closed(selected:boolean)
  IsPotalaPanelOpen = false

  if selected == false then
    print("布达拉宫 未成功进行选择 再次发起通知")
    LuaEvents.Potala_SendNotification()
  end
end
-- ===========================================================================
--	Register
-- ===========================================================================
function RegisterHandlers()
  BASE_RegisterHandlers();

  g_notificationHandlers[HASH_POTALA_NOTIFICATION] = MakeDefaultHandlers();
	g_notificationHandlers[HASH_POTALA_NOTIFICATION].AddSound = 'NOTIFICATION_MISC_POSITIVE';
	g_notificationHandlers[HASH_POTALA_NOTIFICATION].Activate = OnPotalaBeliefsActivate;
	g_notificationHandlers[HASH_POTALA_NOTIFICATION].TryDismiss = OnPotalaBeliefDismiss;

  Events.NotificationDismissed.Add(Potala_NotificationDismissed);
	Events.LocalPlayerTurnEnd.Add(Potala_LocalPlayerTurnEnd);

	LuaEvents.PotalaPanel_Opened.Add(PotalaPanel_Opened);
	LuaEvents.PotalaPanel_Closed.Add(PotalaPanel_Closed);
	LuaEvents.Potala_SendNotification.Add(Potala_SendNotification);
end