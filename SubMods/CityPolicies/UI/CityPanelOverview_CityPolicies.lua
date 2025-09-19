local tCityBannerVersions = {
    "CityPanelOverview_Expansion2.lua",
    "CityPanelOverview_Expansion1.lua",
    "CityPanelOverview.lua",
}

for _, sVersion in ipairs(tCityBannerVersions) do
    include(sVersion)
    if Initialize then
        print("CityPanelOverview_CityPolicies loading " .. sVersion .. " as base file")
        break
    end
end

Base_LateInitialize = LateInitialize;
Base_ViewPanelBreakdown = ViewPanelBreakdown;

-- ===========================================================================
function ViewPanelBreakdown( data:table )
    -- Duplicate current data for modification.
    local modifiedData = deepcopy(data, {});

    -- Change modifiedData's all buildings that should be hidden to be "not built". Can also remove them but harder to do when iterating the table.
    for _, district in ipairs(modifiedData.BuildingsAndDistricts) do
        if district.isBuilt and district.Type == "DISTRICT_CITY_CENTER" then
            for _,building in ipairs(district.Buildings) do
                if building.isBuilt and ShouldHideBuilding(building) then
                    building.isBuilt = false;
                end
            end
        end
    end

    -- Construct the panel using default ViewPanelBreakdown with modified data, which won't render city policy data.
    Base_ViewPanelBreakdown(modifiedData);

    -- Add city policy (process with original data)
    LuaEvents.CityPanelOverview_CityPolicies(data);
end

function ShouldHideBuilding(building:table)
    -- Hide internal only buildings and city policy buildings.
    local buildingType:string = building.Type;
    local building = GameInfo.Buildings[buildingType];
    return building.InternalOnly or buildingType:match "^BUILDING_CITY_POLICY_";
end

-- Deepcopying table. Taken from http://lua-users.org/wiki/CopyTable.
function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function LateInitialize()
    Base_LateInitialize();

    -- Fix TradingPostsHeader
    for _, child in ipairs(Controls.TradingPostsHeader:GetChildren()) do
        -- Set Trading Post Label's offsetX from 10 to 0. The other child has offsetX of 0 by default.
        child:SetOffsetX(0);
    end
end