-- =================================================================================
-- Import base file
-- =================================================================================
local files = {
    "PlotToolTip_Expansion2_BarbarianClansMode.lua",
    "PlotToolTip_BarbarianClansMode.lua",
    "PlotToolTip_Expansion2.lua",
    "PlotToolTip.lua",
}

for _, file in ipairs(files) do
    include(file)
    if Initialize then
        print("DL_PlotToolTip Loading " .. file .. " as base file");
        break
    end
end

-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================
BASE_FetchAdditionalData = FetchAdditionalData;
BASE_GetDetails = GetDetails;

-- ===========================================================================
-- OVERRIDE BASE FUNCTIONS
-- ===========================================================================

function FetchAdditionalData( pPlot:table, kPlotData:table )
    BASE_FetchAdditionalData(pPlot, kPlotData);

    -- Filter data's building names to exclude city policies and internal buildings.
    local indexToBeRemoved = {};
    local buildingTypes = kPlotData.BuildingTypes;
    for index, type in ipairs(buildingTypes) do
        local building = GameInfo.Buildings[type];
        if building.InternalOnly or building.BuildingType:match("^BUILDING_CITY_POLICY_") then
            -- Insert to table in descending order.
            table.insert(indexToBeRemoved, 1, index);
        end
    end

    -- Remove the buildings that we don't want to show in the list from the back, so the indices stay valid.
    for _, index in ipairs(indexToBeRemoved) do
        table.remove(kPlotData.BuildingTypes, index);
        table.remove(kPlotData.BuildingNames, index);
        table.remove(kPlotData.BuildingsPillaged, index);
    end
end

-- function GetDetails(data : table)
--     local details = BASE_GetDetails(data)

--     if(data.ResourceType ~= nil) then
--         -- if it's a resource that requires a tech to improve, let the player know that in the tooltip
--         -- HD: add improvement info and corp effect (if corp mode enabled)
--         local resourceType = data.ResourceType;
--         local resource = GameInfo.Resources[resourceType];

--         local resourceString = ""; -- Locale.Lookup(resource.Name);
--         local resourceHash = GameInfo.Resources[resourceType].Hash;

--         local terrainType = data.TerrainType;
--         local featureType = data.FeatureType;

--         local valid_feature = false;
--         local valid_terrain = false;
--         local valid_resources = false;

--         -- Are there any improvements that specifically require this resource?
--         for row in GameInfo.Improvement_ValidResources() do
--             if (row.ResourceType == resourceType) then
--                 -- Found one!  Now.  Can it be constructed on this terrain/feature
--                 local improvementType = row.ImprovementType;
--                 local has_feature = false;
--                 for inner_row in GameInfo.Improvement_ValidFeatures() do
--                     if(inner_row.ImprovementType == improvementType) then
--                         has_feature = true;
--                         if(inner_row.FeatureType == featureType) then
--                             valid_feature = true;
--                         end
--                     end
--                 end
--                 valid_feature = not has_feature or valid_feature;

--                 local has_terrain = false;
--                 for inner_row in GameInfo.Improvement_ValidTerrains() do
--                     if(inner_row.ImprovementType == improvementType) then
--                         has_terrain = true;
--                         if(inner_row.TerrainType == terrainType) then
--                             valid_terrain = true;
--                         end
--                     end
--                 end
--                 valid_terrain = not has_terrain or valid_terrain;
                
--                 -- if we match the resource in Improvement_ValidResources it's a get-out-of-jail-free card for feature and terrain checks
--                 for inner_row in GameInfo.Improvement_ValidResources() do
--                     if(inner_row.ImprovementType == improvementType) then
--                         if(inner_row.ResourceType == resourceType) then
--                             valid_resources = true;
--                             break;
--                         end
--                     end
--                 end

--                 if( GameInfo.Terrains[terrainType].TerrainType  == "TERRAIN_COAST") then
--                     if ("DOMAIN_SEA" == GameInfo.Improvements[improvementType].Domain) then
--                         valid_terrain = true;
--                     elseif ("DOMAIN_LAND" == GameInfo.Improvements[improvementType].Domain) then
--                         valid_terrain = false;
--                     end
--                 else
--                     if ("DOMAIN_SEA" == GameInfo.Improvements[improvementType].Domain) then
--                         valid_terrain = false;
--                     elseif ("DOMAIN_LAND" == GameInfo.Improvements[improvementType].Domain) then
--                         valid_terrain = true;
--                     end
--                 end

--                 -- print('HD details 3', valid_feature, valid_terrain, valid_resources)
--                  -- HD: original code have bug here
--                 if ((valid_feature == true and valid_terrain == true) or valid_resources == true) then
--                     local improvementName = "LOC_" .. GameInfo.Improvements[improvementType].ImprovementType .. "_NAME";
--                     print(improvementName, Locale.Lookup(improvementName))
--                     resourceString = Locale.Lookup("LOC_TOOLTIP_REQUIRES") .. " " .. Locale.Lookup(improvementName);
--                     break;
--                 end
--             end
--         end
--         -- print('HD details 2')
--         local localPlayer = Players[Game.GetLocalPlayer()];
--         if (localPlayer ~= nil) then
--             local playerResources = localPlayer:GetResources();
--             if(playerResources:IsResourceVisible(resourceHash)) then
--                 table.insert(details, resourceString);
--                 -- print('here', resourceString)
--             end
--         end
--     end
--     -- for k, v in pairs(details) do
--     --     print(k, v)
--     -- end
--     return details
-- end
