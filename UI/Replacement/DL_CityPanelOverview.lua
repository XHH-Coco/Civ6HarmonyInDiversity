local tCityBannerVersions = {
    "CityPanelOverview_CityPolicies_Suk.lua",
    "CityPanelOverview_CityPolicies.lua",
    "CityPanelOverview_Expansion2.lua",
    "CityPanelOverview_Expansion1.lua",
    "CityPanelOverview.lua",
}

for _, sVersion in ipairs(tCityBannerVersions) do
    include(sVersion)
    if Initialize then
        print("DL_CityPanelOverview loading " .. sVersion .. " as base file")
        break
    end
end

local UV_CITIZEN_GROWTH_STATUS        :table    = {};
        UV_CITIZEN_GROWTH_STATUS[0] = {u=0, v=0  };        -- revolt
        UV_CITIZEN_GROWTH_STATUS[1] = {u=0, v=0 };        -- unrest
        UV_CITIZEN_GROWTH_STATUS[2] = {u=0, v=0};        -- unhappy
        UV_CITIZEN_GROWTH_STATUS[3] = {u=0, v=50};        -- displeased
        UV_CITIZEN_GROWTH_STATUS[4] = {u=0, v=100};        -- content (normal)
        UV_CITIZEN_GROWTH_STATUS[5] = {u=0, v=150};        -- delighted (new)
        UV_CITIZEN_GROWTH_STATUS[6] = {u=0, v=200};        -- happy
        UV_CITIZEN_GROWTH_STATUS[7] = {u=0, v=250};        -- joyful (new)
        UV_CITIZEN_GROWTH_STATUS[8] = {u=0, v=300};        -- ecstatic

Base_ViewPanelAmenities = ViewPanelAmenities;

-- ===========================================================================
function ViewPanelAmenities( data:table )
    local isFinished, errMsg = pcall(Base_ViewPanelAmenities, data);

    -- No need to do extra processing if there's no error.
    if isFinished then return end

    if (IsHappinessOutOfBoundError(errMsg)) then
        -- If the error is Happiness out of bound (due to newly added happiness level), complete the rest of the UI rendering with new values.
        -- From Base CityPanelOverview
        local colorName:string = GetHappinessColor(data.Happiness);
        Controls.CitizenGrowthStatus:SetTextureOffsetVal( UV_CITIZEN_GROWTH_STATUS[data.Happiness].u, UV_CITIZEN_GROWTH_STATUS[data.Happiness].v );
        Controls.CitizenGrowthStatusIcon:SetColorByName( colorName );
        -- From CityPanelOverview_Expansion1
        kInstance = g_kAmenitiesIM:GetInstance();
        kInstance.Amenity:SetText( Locale.Lookup("LOC_HUD_CITY_AMENITIES_LOST_FROM_GOVERNORS") );
        kInstance.AmenityYield:SetText( Locale.ToNumber(data.AmenitiesFromGovernors) );
    else
        -- Otherwise throw out the error.
        error(errMsg);
    end
end

function IsHappinessOutOfBoundError(err)
    -- The error message looks like
    -- ".....\Base\Assets\UI\Panels\CityPanelOverview.lua:524: attempt to index a nil value"
    return err ~= nil and err:find("CityPanelOverview.lua:524: attempt to index a nil value");
end