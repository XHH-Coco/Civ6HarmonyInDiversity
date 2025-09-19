-- =================================================================================
-- Import base file
-- =================================================================================
local files = {
    -- "CityPanel_Expansion2.lua", -- Suk simple UI doesn't support CityPanel_Expansion2
    "CityPanel_Expansion1.lua",
    "CityPanel.lua",
}

for _, file in ipairs(files) do
    include(file)
    if Initialize then
        print("DL_CityPanel Loading " .. file .. " as base file");
        break
    end
end

include( "EspionageViewManager" );

-- =================================================================================
-- Cache base functions
-- =================================================================================
BASE_LateInitialize = LateInitialize;
BASE_OnCitySelectionChanged = OnCitySelectionChanged;
BASE_OnInterfaceModeChanged = OnInterfaceModeChanged;
BASE_OnUnitSelectionChanged = OnUnitSelectionChanged;
BASE_RecenterCameraOnCity = RecenterCameraOnCity;
BASE_Refresh = Refresh;

local m_kEspionageViewManager = EspionageViewManager:CreateManager();

function UpdateEspionageView(playerID)
    -- Update banner
    local primaryColor, secondaryColor  = UI.GetPlayerColors(playerID);
    if(primaryColor == nil or secondaryColor == nil or primaryColor == 0 or secondaryColor == 0) then
        UI.DataError("Couldn't find player colors for player - " .. playerID);
    end

    local darkerBackColor = UI.DarkenLightenColor(primaryColor,-85,100);
    local brighterBackColor = UI.DarkenLightenColor(primaryColor,90,255);

    Controls.Banner:SetColor(primaryColor);
    Controls.BannerLighter:SetColor(brighterBackColor);
    Controls.BannerDarker:SetColor(darkerBackColor);
    Controls.CircleBacking:SetColor(primaryColor);
    Controls.CircleLighter:SetColor(brighterBackColor);
    Controls.CircleDarker:SetColor(darkerBackColor);
    Controls.CityName:SetColor(secondaryColor);
    Controls.CivIcon:SetColor(secondaryColor);
end

function OnCitySelectionChanged( ownerPlayerID:number, cityID:number, i:number, j:number, k:number, isSelected:boolean, isEditable:boolean)
    if isSelected == false and m_kEspionageViewManager:IsEspionageView() then
        -- Don't need to update if it deselects the previous city and it is now in EspionageView,
        -- since it will try to hide city panel but we have already shown the EspionageView city panel.
        return;
    end
    BASE_OnCitySelectionChanged(ownerPlayerID, cityID, i, j, k, isSelected, isEditable);
end

function OnInterfaceModeChanged( eOldMode:number, eNewMode:number )
    if not ContextPtr:IsHidden() and m_kEspionageViewManager:IsEspionageView() then
        -- Don't need to update if it deselects the previous city and it is now in EspionageView,
        -- since we have already updated the city panel.
        return;
    end
    BASE_OnInterfaceModeChanged(eOldMode, eNewMode);
end

function OnShowEnemyCityOverview( ownerID:number, cityID:number)
    m_kEspionageViewManager:SetEspionageViewCity( ownerID, cityID );

    -- Update UI.
    Refresh();
    UpdateEspionageView(ownerID);

    -- Show panel.
    ContextPtr:SetHide(false);
    AnimateFromCloseToOpen();
end

function OnUnitSelectionChanged( playerID:number, unitID:number, hexI:number, hexJ:number, hexK:number, isSelected:boolean, isEditable:boolean )
    if isSelected == false and m_kEspionageViewManager:IsEspionageView() then
        -- Don't need to update if it deselects an unit and it is now in EspionageView,
        -- since it will try to hide city panel but we have already shown the EspionageView city panel.
        return;
    end
    BASE_OnUnitSelectionChanged(playerID, unitID, hexI, hexJ, hexK, isSelected, isEditable);
end

function RecenterCameraOnCity()
    if m_kEspionageViewManager:IsEspionageView() then
        -- Don't need to recenter if it is in EspionageView,
        -- since it tries to recenter to head selected city but EspionageView doesn't have one.
        return;
    end
    BASE_RecenterCameraOnCity();
end

function Refresh()
    BASE_Refresh();

    g_pCity	 = UI.GetHeadSelectedCity();

    if g_pCity == nil then
        g_pCity = m_kEspionageViewManager:GetEspionageViewCity();
        if g_pCity ~= nil then
            local data = GetCityData( g_pCity );
            if data ~= nil then
                ViewMain( data );
                -- Tell others (e.g., CityPanelOverview) that the selected city data has changed.
                LuaEvents.CityPanel_LiveCityDataChanged( data, true );
            end
        end
    else
        m_kEspionageViewManager:ClearEspionageViewCity();
    end

    -- Disable these buttons if is in EspionageView.
    local IsEspionageView = m_kEspionageViewManager:IsEspionageView();
    if Controls.PurchaseTileCheck ~= nil then Controls.PurchaseTileCheck:SetDisabled(IsEspionageView); end
    if Controls.ManageCitizensCheck ~= nil then Controls.ManageCitizensCheck:SetDisabled(IsEspionageView); end
end

function LateInitialize()
    BASE_LateInitialize();

    Events.CitySelectionChanged.Remove(BASE_OnCitySelectionChanged);
    Events.InterfaceModeChanged.Remove(BASE_OnInterfaceModeChanged);
    Events.UnitSelectionChanged.Remove(BASE_OnUnitSelectionChanged);

    Events.CitySelectionChanged.Add(OnCitySelectionChanged);
    Events.InterfaceModeChanged.Add(OnInterfaceModeChanged);
    Events.UnitSelectionChanged.Add(OnUnitSelectionChanged);

    LuaEvents.CityBannerManager_ShowEnemyCityOverview.Add(OnShowEnemyCityOverview);
end
