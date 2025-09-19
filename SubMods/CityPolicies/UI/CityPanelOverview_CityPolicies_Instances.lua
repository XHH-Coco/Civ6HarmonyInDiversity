include( "Civ6Common" );
include( "InstanceManager" );
include( "ToolTipHelper" );

-- ===========================================================================
-- MEMBERS
-- ===========================================================================
pBreakdownStack    = nil

local m_kCityPolicyIM:table = InstanceManager:new("CityPolicyInstance",    "Top", Controls.CityPolicyStack);

-- ===========================================================================
-- CityPanelOverview_CityPolicies
-- ===========================================================================
function On_CityPanelOverview_CityPolicies(data)
    local playerID = Game.GetLocalPlayer();

    local hasCityPolicies = false;
    m_kCityPolicyIM:ResetInstances();

    for _, district in ipairs(data.BuildingsAndDistricts) do
        if district.isBuilt and district.Type == "DISTRICT_CITY_CENTER" then
            for _,building in ipairs(district.Buildings) do
                if building.isBuilt then
                    local buildingType = building.Type;
                    if buildingType == "BUILDING_CITY_POLICY_EMPTY" then
                        -- No city policies have been established.
                        hasCityPolicies = false;
                        break;
                    elseif buildingType:match "^BUILDING_CITY_POLICY_" then
                        -- Add active city policy
                        hasCityPolicies = true;
                        local cityPolicyInstance:table = m_kCityPolicyIM:GetInstance();
                        cityPolicyInstance.CityPolicyName:SetText(building.Name);
                        cityPolicyInstance.Icon:SetIcon(building.Icon);
                        -- TODO: Add proper tooltip for city policy
                        local pRow = GameInfo.Buildings[buildingType];
                        local sToolTip = ToolTipHelper.GetBuildingToolTip(pRow.Hash, playerID, m_pCity);
                        cityPolicyInstance.Top:SetToolTipString(sToolTip);
                    end
                end
            end
            Controls.CityPolicyStack:CalculateSize();
        end
    end

    Controls.NoCityPolicyArea:SetHide(hasCityPolicies);
    Controls.CityPolicyArea:SetHide(not hasCityPolicies);
end

-- ===========================================================================
--    Init and Shutdown
-- ===========================================================================
local bLoadScreenHookup = false

function OnInit(isReload)
    if not ContextPtr:LookUpControl("/InGame/CityPanelOverview/BreakdownStack") then
        Events.LoadScreenClose.Add(OnInit)
        bLoadScreenHookup = true
        return
    end

    -- Attach CityPolicyContainer to BreakdownStack in CityPanelOverview
    pBreakdownStack    = ContextPtr:LookUpControl("/InGame/CityPanelOverview/BreakdownStack")
    Controls.CityPolicyContainer:ChangeParent(pBreakdownStack)

    LuaEvents.CityPanelOverview_CityPolicies.Add(On_CityPanelOverview_CityPolicies)
end

function OnShutdown()
    if bLoadScreenHookup then Events.LoadScreenClose.Remove(OnInit) end
    LuaEvents.CityPanelOverview_CityPolicies.Remove(On_CityPanelOverview_CityPolicies)

    m_kCityPolicyIM:DestroyInstances()
    -- Detach CityPolicyContainer
    pBreakdownStack:DestroyChild(Controls.CityPolicyContainer)
end
-- ===========================================================================
function Initialize()
    ContextPtr:SetInitHandler(OnInit)
    ContextPtr:SetHide(false)
    ContextPtr:SetShutdown(OnShutdown)
end
Initialize()