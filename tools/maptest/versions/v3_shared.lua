function AddVolcanicSoil(iSecondRingChance)
    -- iSecondRingChance：二环铺火山土的概率分母，默认 1/3。Primordial 传 2。
    iSecondRingChance = iSecondRingChance or 3;

    local mWidth, mHeight = Map.GetGridSize();

    -- 能不能在这一格铺火山土：水域、山地和任何自然奇观都不铺。
    -- 原先这里是三份互不一致的硬编码奇观名单，普通火山那一支甚至一份都没有，
    -- 会把平地上的自然奇观（如恩戈罗恩戈罗火山口、撒哈拉之眼）直接覆盖掉。
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

    for CoordinateX = 0, mWidth - 1, 1 do
        for CoordinateY = 0, mHeight - 1, 1 do
            local plots = Map.GetPlot(CoordinateX, CoordinateY);
            if (plots:GetFeatureType() ~= -1) then
                local sFeatureType = GameInfo.Features[plots:GetFeatureType()].FeatureType;

                -- 普通火山：一环铺满，没有二环。
                if (sFeatureType == "FEATURE_VOLCANO") then
                    local tNeighborPlots = Map.GetAdjacentPlots(CoordinateX, CoordinateY);
                    for _, pNeighborPlot in ipairs(tNeighborPlots) do
                        if (CanTakeVolcanicSoil(pNeighborPlot)) then
                            TerrainBuilder.SetFeatureType(pNeighborPlot, g_FEATURE_VOLCANIC_SOIL);
                        end
                    end
                end

                -- 火山系自然奇观：一环铺满，二环按概率。
                if (sFeatureType == "FEATURE_EYJAFJALLAJOKULL"
                or sFeatureType == "FEATURE_KILIMANJARO"
                or sFeatureType == "FEATURE_VESUVIUS"
                or sFeatureType == "FEATURE_SUK_FUJI"
                or sFeatureType == "FEATURE_SUK_NGORONGORO_CRATER") then
                    local tNeighborPlots = Map.GetAdjacentPlots(CoordinateX, CoordinateY);
                    for _, pNeighborPlot in ipairs(tNeighborPlots) do
                        if (CanTakeVolcanicSoil(pNeighborPlot)) then
                            TerrainBuilder.SetFeatureType(pNeighborPlot, g_FEATURE_VOLCANIC_SOIL);
                        end
                        -- 二环随机生成。这一段刻意留在上面的 if 之外：每个一环邻格都向外摇一圈，
                        -- 所以一个二环格子邻接几个一环格就被摇几次（角格 1 次、边格 2 次），
                        -- 实际覆盖率因此高于 1/iSecondRingChance（默认参数下是 33%~56%）。
                        local sNeighborPlots = Map.GetAdjacentPlots(pNeighborPlot:GetX(), pNeighborPlot:GetY());
                        for _, rNeighborPlot in ipairs(sNeighborPlots) do
                            if (CanTakeVolcanicSoil(rNeighborPlot)) then
                                if (TerrainBuilder.GetRandomNumber(iSecondRingChance, "Volcanic Soil - Lua") == 0) then
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
