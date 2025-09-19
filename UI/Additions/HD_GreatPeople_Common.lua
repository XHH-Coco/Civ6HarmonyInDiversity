local CITY_CENTER_INDEX = GameInfo.Districts["DISTRICT_CITY_CENTER"].Index;
local SPACE_PORT_INDEX = GameInfo.Districts["DISTRICT_SPACEPORT"].Index;
local DISTRICT_WONDER_INDEX = GameInfo.Districts["DISTRICT_WONDER"].Index;

local MIMAR_SINAN_INDEX = GameInfo.GreatPersonIndividuals["GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN"].Index;

local MIMAR_SINAN_INVALID_DISTRICTS = {};
MIMAR_SINAN_INVALID_DISTRICTS[CITY_CENTER_INDEX] = true;
MIMAR_SINAN_INVALID_DISTRICTS[SPACE_PORT_INDEX] = true;
MIMAR_SINAN_INVALID_DISTRICTS[DISTRICT_WONDER_INDEX] = true;

local FEATURE_BURNING_FOREST_INDEX = -2;
local FEATURE_BURNT_FOREST_INDEX = -2;
local FEATURE_BURNING_JUNGLE_INDEX = -2;
local FEATURE_BURNT_JUNGLE_INDEX = -2;
if GameInfo.Features["FEATURE_BURNING_FOREST"] ~= nil then
	FEATURE_BURNING_FOREST_INDEX = GameInfo.Features["FEATURE_BURNING_FOREST"].Index;
end
if GameInfo.Features["FEATURE_BURNT_FOREST"] ~= nil then
	FEATURE_BURNING_FOREST_INDEX = GameInfo.Features["FEATURE_BURNT_FOREST"].Index;
end
if GameInfo.Features["FEATURE_BURNING_JUNGLE"] ~= nil then
	FEATURE_BURNING_FOREST_INDEX = GameInfo.Features["FEATURE_BURNING_JUNGLE"].Index;
end
if GameInfo.Features["FEATURE_BURNT_JUNGLE"] ~= nil then
	FEATURE_BURNING_FOREST_INDEX = GameInfo.Features["FEATURE_BURNT_JUNGLE"].Index;
end

-- Return table of plot index
function HDGreatPersonGetActivationPlots(playerID, greatPersonIndividualID)
    local player = Players[playerID];
    if greatPersonIndividualID == MIMAR_SINAN_INDEX then
        local activationPlots = {};
        for _, district in player:GetDistricts():Members() do
            if (district ~= nil and not MIMAR_SINAN_INVALID_DISTRICTS[district:GetType()]) then
                local isValid = false;
                if district:IsComplete() then
                    isValid = true;
                else
                    local districtCity = district:GetCity();
                    if districtCity ~= nil then
                        local buildQueue = districtCity:GetBuildQueue();
                        local currentlyBuilding = buildQueue:GetCurrentProductionTypeHash(); -- CurrentlyBuilding();
                        local districtType = GameInfo.Districts[district:GetType()].DistrictType;
                        -- local districtHash = GameInfo.Types[district:GetType()].Hash;
                        local currentlyBuildingType = GameInfo.Types[currentlyBuilding].Type
                        -- print('HD_DEBUG aaa ', GameInfo.Types[currentlyBuilding].Type);
                        -- print('HD_DEBUG', currentlyBuilding, currentlyBuildingType, districtType)
                        if districtType == currentlyBuildingType then
                            isValid = true;
                        end
                    end
                end
                if isValid then
                    local districtPlot:table = Map.GetPlot(district:GetX(), district:GetY());
                    -- print('HD_DEBUG plot', district:GetX(), district:GetY(), districtPlot)
                    if districtPlot ~= nil then
                        table.insert(activationPlots, districtPlot:GetIndex());
                    end
                end
            end
        end
        return activationPlots;
    end

    -- 公司模式大商开公司, by xiaoxiao
    if GameInfo.XXCAT_GreatPersonUniqueResources ~= nil then
        for row in GameInfo.XXCAT_GreatPersonUniqueResources() do
            local greatPersonIndex = GameInfo.GreatPersonIndividuals[row.GreatPersonIndividualType].Index;
            if greatPersonIndividualID == greatPersonIndex then
                activationPlots = {};
                for _, city in player:GetCities():Members() do
                    local plots = Map.GetCityPlots():GetPurchasedPlots(city)
                    for _, plotIndex in pairs(plots) do
                        local plot = Map.GetPlotByIndex(plotIndex);
                        if plot:GetDistrictType() == -1 -- 没有区域
                        and plot:GetImprovementType() == -1 -- 没有改良
                        and plot:GetResourceType() == -1 --没有资源
                        and not plot:IsNaturalWonder() -- 没有自然奇观
                        and not plot:IsWater() -- 是陆地单元格
                        and plot:GetFeatureType() ~= FEATURE_BURNING_FOREST_INDEX -- 没有燃烧的树林
                        and plot:GetFeatureType() ~= FEATURE_BURNT_FOREST_INDEX -- 没有烧毁的的树林
                        and plot:GetFeatureType() ~= FEATURE_BURNING_JUNGLE_INDEX -- 没有燃烧的雨林
                        and plot:GetFeatureType() ~= FEATURE_BURNT_JUNGLE_INDEX -- 没有烧毁的雨林
                        then
                            table.insert(activationPlots, plotIndex);
                        end
                    end
                end
                return activationPlots;
            end
        end
    end
        
    return nil;
end
