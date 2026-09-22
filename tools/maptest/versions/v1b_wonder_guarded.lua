function AddVolcanicSoil()
    local mWidth,mHeight = Map.GetGridSize();
    local function CanTakeVolcanicSoil(pPlot)
        if (pPlot:IsWater() or pPlot:IsMountain()) then
            return false;
        end
        local eFeature = pPlot:GetFeatureType();
        if (eFeature ~= -1 and GameInfo.Features[eFeature].NaturalWonder) then
            return false;
        end
        return true;
    end
    for CoordinateX = 0,mWidth-1,1 do
        for CoordinateY = 0,mHeight-1,1 do
            local plots = Map.GetPlot(CoordinateX,CoordinateY);
            if (plots:GetFeatureType() ~= -1) then
                if (GameInfo.Features[plots:GetFeatureType()].FeatureType == "FEATURE_VOLCANO") then
                    local tNeighborPlots = Map.GetAdjacentPlots(CoordinateX,CoordinateY);
                    for _, pNeighborPlot in ipairs(tNeighborPlots) do
                        if (CanTakeVolcanicSoil(pNeighborPlot)) then
                            TerrainBuilder.SetFeatureType(pNeighborPlot, g_FEATURE_VOLCANIC_SOIL);
                        end
                    end
                end
                if (GameInfo.Features[plots:GetFeatureType()].FeatureType == "FEATURE_EYJAFJALLAJOKULL"
                or GameInfo.Features[plots:GetFeatureType()].FeatureType == "FEATURE_KILIMANJARO"
                or GameInfo.Features[plots:GetFeatureType()].FeatureType == "FEATURE_VESUVIUS"
                or GameInfo.Features[plots:GetFeatureType()].FeatureType == "FEATURE_SUK_FUJI"
                or GameInfo.Features[plots:GetFeatureType()].FeatureType == "FEATURE_SUK_NGORONGORO_CRATER") then
                    local tNeighborPlots = Map.GetAdjacentPlots(CoordinateX,CoordinateY);
                    for _, pNeighborPlot in ipairs(tNeighborPlots) do
                        if (CanTakeVolcanicSoil(pNeighborPlot)) then
                            TerrainBuilder.SetFeatureType(pNeighborPlot, g_FEATURE_VOLCANIC_SOIL);
                        end
                        --二环随机生成
                        local sNeighborPlots = Map.GetAdjacentPlots(pNeighborPlot:GetX(), pNeighborPlot:GetY());
                        for _, rNeighborPlot in ipairs(sNeighborPlots) do
                            if (CanTakeVolcanicSoil(rNeighborPlot)) then
                                if (TerrainBuilder.GetRandomNumber(3, "Volcanic Soil - Lua") == 0) then
                                    TerrainBuilder.SetFeatureType(rNeighborPlot, g_FEATURE_VOLCANIC_SOIL);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
