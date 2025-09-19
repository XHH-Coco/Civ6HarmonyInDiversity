-- =================================================================================
-- Helper functions for checking fresh water hill farms.
-- =================================================================================

function HasFreshWater(plot)
    if plot:IsFreshWater() then
        return true;
    end

    -- Check if has an adjacent Aqueduct.
    local adjPlots = Map.GetAdjacentPlots(plot:GetX(), plot:GetY());
    for i, plot in ipairs(adjPlots) do
        if plot ~= nil then
            local districtTypeId = plot:GetDistrictType();
            if districtTypeId ~= nil and districtTypeId ~= -1 then
                local districtType = GameInfo.Districts[districtTypeId].DistrictType;
                if districtType == 'DISTRICT_AQUEDUCT' or districtType == 'DISTRICT_BATH' then
                    local district = CityManager.GetDistrictAt(plot);
                    if district ~= nil and district:IsComplete() then
                        -- Check if pillaged.
                        local cityDistricts = district:GetCity():GetDistricts();
                        if not cityDistricts:IsPillaged(districtTypeId, plot:GetIndex()) then
                            return true;
                        end
                    end
                end
            end
        end
    end

    return false;
end

-- Only need to check if player cannot place farm on this plot due to non fresh water hills, since normal farms check should have already been done.
-- i.e. If the plot doesn't belong to the user, has features (forrest, jungle, etc.), has resources, has district, etc.
function ShouldDisableHillFarm(plot, player)
    if plot == nil or player == nil then
        -- Shouldn't be executed.
        return true;
    end

    -- Should disable hill farm if the player doesn't have CIVIL_ENGINEERING and the hill doesn't have fresh water.
    -- if player:GetCulture():HasCivic(GameInfo.Civics['CIVIC_CIVIL_ENGINEERING'].Index) then
    --     return false;
    -- end
    if player:GetTechs():HasTech(GameInfo.Technologies['TECH_CIVIL_ENGINEERING_HD'].Index) then
        return false;
    end

    -- If reached here, player doesn't have CIVIL_ENGINEERING.
    local terrainType = GameInfo.Terrains[plot:GetTerrainType()].TerrainType;
    if terrainType ~= 'TERRAIN_PLAINS_HILLS'
        and terrainType ~= 'TERRAIN_GRASS_HILLS'
        and terrainType ~= 'TERRAIN_TUNDRA_HILLS' then
            return false;
    end

    -- If reached here, player doesn't have CIVIL_ENGINEERING and the plot is a hill.
    local resourceID = plot:GetResourceType();
    -- print(resourceID)
    if resourceID ~= -1 then
        local resourceType = GameInfo.Resources[resourceID].ResourceType;
        if resourceType ~= nil then
            for tRow in GameInfo.Improvement_ValidResources() do
                if tRow.ResourceType == resourceType and tRow.ImprovementType == 'IMPROVEMENT_FARM' then
                    return false
                end
            end
        end
    end

    -- If reached here, player doesn't have CIVIL_ENGINEERING and the plot is a hill, and there is no farm resource on it.
    if not HasFreshWater(plot) then
        -- Should disable hill farm since this hill is not a fresh water hill.
        return true;
    end


    -- Don't need to disable by default since it allows normal farm to check itself.
    return false;
end
