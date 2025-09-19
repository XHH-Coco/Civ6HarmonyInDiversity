-- 通过替换游戏自带脚本，来实现禁用尤里卡/鼓舞的弹窗

include("BoostUnlockedPopup")
include("TechCivicCompletedPopup")

-- 备份原先的函数
local OnNotificationPanel_ShowTechBoost_BAK = OnNotificationPanel_ShowTechBoost
local OnNotificationPanel_ShowCivicBoost_BAK = OnNotificationPanel_ShowCivicBoost
local OnNotificationPanel_ShowTech_BAK = OnNotificationPanel_ShowTechDiscovered
local OnNotificationPanel_ShowCivic_BAK = OnNotificationPanel_ShowCivicDiscovered


function OnNotificationPanel_ShowTechBoost( ePlayer, techIndex, iTechProgress, eSource )
	--DoTechBoost(ePlayer, techIndex, iTechProgress, eSource);
end

function OnNotificationPanel_ShowCivicBoost( ePlayer, civicIndex, iCivicProgress, eSource )
	--DoCivicBoost(ePlayer, civicIndex, iCivicProgress, eSource);
end

function OnNotificationPanel_ShowTechDiscovered(ePlayer, techIndex:number, isByUser:boolean)
    -- AddCompletedPopup( ePlayer, nil, techIndex, isByUser );
end

function OnNotificationPanel_ShowCivicDiscovered(ePlayer, civicIndex, isByUser:boolean)
    -- AddCompletedPopup( ePlayer, civicIndex, nil, isByUser  );
end

function Initialize()
    -- 先移除原先的回调函数
    LuaEvents.NotificationPanel_ShowTechBoost.Remove(OnNotificationPanel_ShowTechBoost_BAK)
    LuaEvents.NotificationPanel_ShowCivicBoost.Remove(OnNotificationPanel_ShowCivicBoost_BAK)
    LuaEvents.NotificationPanel_ShowTechDiscovered.Remove(OnNotificationPanel_ShowTech_BAK)
    LuaEvents.NotificationPanel_ShowCivicDiscovered.Remove(OnNotificationPanel_ShowCivic_BAK)

    LuaEvents.NotificationPanel_ShowTechBoost.Add(OnNotificationPanel_ShowTechBoost)
    LuaEvents.NotificationPanel_ShowCivicBoost.Add(OnNotificationPanel_ShowCivicBoost)
    LuaEvents.NotificationPanel_ShowTechDiscovered.Add(OnNotificationPanel_ShowTechDiscovered)
    LuaEvents.NotificationPanel_ShowCivicDiscovered.Add(OnNotificationPanel_ShowCivicDiscovered)
end


Initialize();