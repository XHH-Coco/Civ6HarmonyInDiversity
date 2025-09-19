local BASE_RegisterHandlers_HD = RegisterHandlers

function RegisterHandlers()
	BASE_RegisterHandlers_HD()

    g_notificationHandlers[NotificationTypes.DIPLOMACY_SESSION].AddSound    = "ALERT_NEUTRAL";
end
