------------------------------------------------------------------------------
--  FILE:    Tiny_Islands.lua (Forked from Archipelago.lua)
--  AUTHOR:  
--  PURPOSE: Base game script - Produces widely varied islands.
------------------------------------------------------------------------------
--  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include "MapEnums"
include "MapUtilities"
include "MountainsCliffs"
include "RiversLakes"
include "FeatureGenerator"
include "TerrainGenerator"
include "NaturalWonderGenerator"
include "ResourceGenerator"
include "CoastalLowlands"
include "AssignStartingPlots"

local g_iW, g_iH;
local g_iFlags = {};
local g_continentsFrac = nil;
local islands = {};
local featureGen = nil;
local world_age_old = 1;
local world_age_normal = 2;
local world_age_new = 3;
-------------------------------------------------------------------------------
function GenerateMap()
    print("Generating Archipelago Map");
    local pPlot;

    -- Set globals
    g_iW, g_iH = Map.GetGridSize();
    g_iFlags = TerrainBuilder.GetFractalFlags();
    local temperature = MapConfiguration.GetValue("temperature"); -- Default setting is Temperate.
    if temperature == 4 then
        temperature  =  1 + TerrainBuilder.GetRandomNumber(3, "Random Temperature- Lua");
    end
    
    --  local world_age
    local world_age = MapConfiguration.GetValue("world_age");
    if (world_age == 1) then
        world_age = world_age_new;
    elseif (world_age == 2) then
        world_age = world_age_normal;
    elseif (world_age == 3) then
        world_age = world_age_old;
    else
        world_age = 1 + TerrainBuilder.GetRandomNumber(3, "Random World Age - Lua");
    end

    plotTypes = GeneratePlotTypes(world_age); --移除沿海山
    terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature, false, -8, 0, 0.04, 0.12);
    ApplyBaseTerrain(plotTypes, terrainTypes, g_iW, g_iH);
    
    AreaBuilder.Recalculate();
    TerrainBuilder.AnalyzeChokepoints();
    TerrainBuilder.StampContinents();

    local iContinentBoundaryPlots = GetContinentBoundaryPlotCount(g_iW, g_iH);
    local biggest_area = Areas.FindBiggestArea(false);
    print("After Adding Hills: ", biggest_area:GetPlotCount());
    AddTerrainFromContinents(plotTypes, terrainTypes, world_age, g_iW, g_iH, iContinentBoundaryPlots, true);--移除大陆边界山

    AreaBuilder.Recalculate();
    TerrainBuilder.AnalyzeChokepoints();

    print ("Num Mountains: " .. tostring(GetMountainCount(g_iW, g_iH)));

    -- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
    AddRivers(2);
    
    -- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
    local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents / 2);
    AddLakes(numLargeLakes);

    AddFeatures();
    
    print("Adding cliffs");
    AddCliffs(plotTypes, terrainTypes);
    
    local args = {
        numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
    };
    local nwGen = NaturalWonderGenerator.Create(args);

    AddFeaturesFromContinents();
    MarkCoastalLowlands();

  
--  for i = 0, (g_iW * g_iH) - 1, 1 do
--      pPlot = Map.GetPlotByIndex(i);
--      print ("i: plotType, terrainType, featureType: " .. tostring(i) .. ": " .. tostring(plotTypes[i]) .. ", " .. tostring(terrainTypes[i]) .. ", " .. tostring(pPlot:GetFeatureType(i)));
--  end
    AddVolcanicSoil();--火山土开局生成必要语句

    local resourcesConfig = MapConfiguration.GetValue("resources");
    local startConfig = MapConfiguration.GetValue("start");-- Get the start config
    local args = {
        iWaterLux = 4,
        iWaterBonus = 1.22,
        resources = resourcesConfig,
        START_CONFIG = startConfig,

        ExtraBonusGroupOneMultiply = 1.5,                          --增加的倍率
        ExtraBonusGroupOne = {  
        "RESOURCE_OAK",                 --橡木
        "RESOURCE_GRANITE",             --花岗岩
        "RESOURCE_LIMESTONE",           --白云石
        "RESOURCE_BERRIES"              --浆果
        },--增加的陆地加成资源,水资无效，奢侈战略无效

        ExtraBonusGroupTwoMultiply = 1.2,                           --增加的倍率
        ExtraBonusGroupTwo = {
        "RESOURCE_GRANITE",             --额外花岗岩
        "RESOURCE_LIMESTONE",           --额外白云石
        "RESOURCE_BERRIES"              --额外浆果
        },--增加的陆地加成资源,水资无效，奢侈战略无效

   

        FewerBonusGroupOneMultiply = 0.85,                          --减少的倍率
        FewerBonusGroupOne = {  
            "RESOURCE_SUK_CAMEL",       --骆驼
            "RESOURCE_BANANAS",         --香蕉
            "RESOURCE_RUBBER"           --橡胶
        },--减少的陆地加成资源,水资无效，奢侈战略无效

        FewerBonusGroupTwoMultiply = 0.77,                          --减少的倍率
        FewerBonusGroupTwo = {  
            "RESOURCE_CRABS",           --螃蟹
            "RESOURCE_DLV_BISON",       --野牛
            "RESOURCE_HAM",             --火腿
            "RESOURCE_MAIZE",           --玉米
            "RESOURCE_COPPER",           --铜矿
            "RESOURCE_TOMATO"           --番茄
        },--减少的陆地加成资源,水资无效，奢侈战略无效

        HorsesMultiply =    1.0,    --调整马资源丰度
        IronMultiply =      1.0,    --调整铁资源丰度
        NiterMultiply =     3.0,    --调整硝石资源丰度，海战需求
        CoalMultiply =      1.0,    --调整煤炭资源丰度
        OilMultiply =       1.0,    --调整石油资源丰度
        AluminumMultiply =  1.0,    --调整铝资源丰度
        ExtraLuxuries = {   
            --"RESOURCE_SAFFRON",               --藏红花
            --"RESOURCE_LEU_P0K_QUINOA"     --藜麦            
        }--增加陆地奢，奢侈按大陆加无倍率，不用在这里加企鹅，企鹅用别的方法加了
    };
    local resGen = ResourceGenerator.Create(args);
    print("Creating start plot database.");
    -- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
    
    local args = {
        MIN_MAJOR_CIV_FERTILITY = 110, 
        MAX_MAJOR_CIV_FERTILITY = 157,
        MIN_MINOR_CIV_FERTILITY = 41, 
        MAX_MINOR_CIV_FERTILITY = 92, 
        MIN_BARBARIAN_FERTILITY = 50,
        START_MIN_Y = 8,
        START_MAX_Y = 26,
        START_MIN_X = 11,
        START_MAX_X = 40,
        WATER = true,
        START_CONFIG = startConfig,
    };
    local start_plot_database = AssignStartingPlots.Create(args)

    local GoodyGen = AddGoodies(g_iW, g_iH);
end
-------------------------------------------------------------------------------

    

-------------------------------------------------------------------------------
function GeneratePlotTypes(world_age)
    print("Generating Plot Types");

    local plotTypes = {};
    local extra_mountains = 0;
    local grain_amount = 3;
    local adjust_plates = 1.0;
    local shift_plot_types = true;
    local tectonic_islands = true;
    local hills_ridge_flags = g_iFlags;
    local peaks_ridge_flags = g_iFlags;
    local has_center_rift = false;
    local sea_level = 1;
    local world_age = 1;

    local water_percent_modifier = 0; 
    
    local desert_shift = 6;

    for x = 0, g_iW - 1 do
        for y = 0, g_iH - 1 do
            local index = (y * g_iW) + x + 1; -- Lua Array starts at 1
            plotTypes[index] = g_PLOT_TYPE_OCEAN;
        end
    end

    --  local sea_level
    local sea_level = MapConfiguration.GetValue("sea_level");
    if sea_level == 1 then -- Low Sea Level
        water_percent_modifier = -4
    elseif sea_level == 2 then -- Normal Sea Level
        water_percent_modifier = 0;
    elseif sea_level == 3 then -- High Sea Level
        water_percent_modifier = 4;
    else
        water_percent_modifier = TerrainBuilder.GetRandomNumber(9, "Random Sea Level - Lua") - 4;
    end



    -- Generate Middle Islands  
    local args = {};
    args.iWaterPercent = 62 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 6;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 6;
    args.iRegionFracYExp = 5;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;


    -- Generate Tiny Islands  
    local args = {};
    args.iWaterPercent = 85 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 6;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 5;
    args.iRegionFracYExp = 4;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;

    -- Generate Fishing Islands  
    local args = {};
    args.iWaterPercent = 89 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 3;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 3;
    args.iRegionFracYExp = 5;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;

 
   -- Generate Small Islands 
   local args = {};
   args.iWaterPercent = 74 + water_percent_modifier;
   args.iRegionWidth = math.ceil(g_iW);
   args.iRegionHeight = math.ceil(g_iH);
   args.iRegionWestX = math.floor(0);
   args.iRegionSouthY = math.floor(0);
   args.iRegionGrain = 6;
   args.iRegionHillsGrain = 4;
   args.iRegionPlotFlags = g_iFlags;
   args.iRegionFracXExp = 4;
   args.iRegionFracYExp = 5;
   plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
   islands = plotTypes;


    -- 峡湾，Cut into this by adding some bays and other water cutouts
    local args = {};
    args.iWaterPercent = 91 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 7;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 3;
    args.iRegionFracYExp = 5;
    args.iRiftGrain = -1;
    plotTypes = GenerateWaterLayer(args, plotTypes);

    -- 在特定的大片陆地区域生成湖以方便海战，其他作用同峡湾
    local args = {};
    args.iWaterPercent = 96 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 6;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 4;
    args.iRegionFracYExp = 2;
    args.iRiftGrain = -1;
    plotTypes = GenerateWaterLayer(args, plotTypes);

    -- Land and water are set. Apply hills and mountains.
    local args = {};--一种山体代码
    args.iW = g_iW;
    args.iH = g_iH
    args.iFlags = g_iFlags;
    args.blendRidge = 3;
    args.blendFract = 2;
    args.adjust_plates = 2;
    args.extra_mountains = 0;
    args.world_age = world_age + 0.25;
    -- mountainRatio = 6 + world_age * 2;
    mountainRatio = 4 + world_age * 5 ;
    print('DL Archipelago, mountainRatio', mountainRatio);
    plotTypes = ApplyTectonics(args, plotTypes);
    plotTypes = AddLonelyMountains(plotTypes, mountainRatio);

    return  plotTypes;
end
-------------------------------------------------------------------------------
function AddFeatures()
    print("Adding Features");

    -- Get Rainfall setting input by user.
    local rainfall = MapConfiguration.GetValue("rainfall");
    if rainfall == 4 then
        rainfall = 1 + TerrainBuilder.GetRandomNumber(3, "Random Rainfall - Lua");
    end
    
    local args = {rainfall = rainfall}
    featuregen = FeatureGenerator.Create(args);
    featuregen:AddFeatures(true, true);  --second parameter is whether or not rivers start inland);
end

function AddFeaturesFromContinents()
    print("Adding Features from Continents");

    featuregen:AddFeaturesFromContinents();
end



-------------------------------------------------------------------------------

-----------------------------------------------------------------------------
function GenerateFractalLayerWithoutHills (args, plotTypes)
    --[[ This function is intended to be paired with ApplyTectonics. If all the hills and
    mountains plots are going to be overwritten by the tectonics results, then why waste
    calculations generating them? ]]--
    local args = args or {};
    local plotTypes2 = {};

    -- Handle args or assign defaults.
    local iWaterPercent = args.iWaterPercent or 34;
    local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
    local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
    local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
    local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
    local iRegionGrain = args.iRegionGrain or 3;
    local iRegionPlotFlags = args.iRegionPlotFlags or g_iFlags;
    local iRegionTerrainFlags = g_iFlags; -- Removed from args list.
    local iRegionFracXExp = args.iRegionFracXExp or 6;
    local iRegionFracYExp = args.iRegionFracYExp or 4;
    local iRiftGrain = args.iRiftGrain or -1;
    local bShift = args.bShift or true;
    
    --print("Received Region Data");
    --print(iRegionWidth, iRegionHeight, iRegionWestX, iRegionSouthY, iRegionGrain);
    --print("- - -");
    
    --print("Filled regional table.");
    -- Loop through the region's plots
    for x = 0, iRegionWidth - 1, 1 do
        for y = 0, iRegionHeight - 1, 1 do
            local i = y * iRegionWidth + x + 1; -- Lua arrays start at 1.
            plotTypes2[i] =g_PLOT_TYPE_OCEAN;
        end
    end

    -- Init the land/water fractal
    local regionContinentsFrac;
    if(iRiftGrain > 0 and iRiftGrain < 4) then
        local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, iRegionFracXExp, iRegionFracYExp);
        regionContinentsFrac = Fractal.CreateRifts(g_iW, g_iH, iRegionGrain, iRegionPlotFlags, riftsFrac, iRegionFracXExp, iRegionFracYExp);
    else
        regionContinentsFrac = Fractal.Create(g_iW, g_iH, iRegionGrain, iRegionPlotFlags, iRegionFracXExp, iRegionFracYExp);    
    end
    --print("Initialized main fractal");
    local iWaterThreshold = regionContinentsFrac:GetHeight(iWaterPercent);

    -- Loop through the region's plots
    for x = 0, iRegionWidth - 1, 1 do
        for y = 0, iRegionHeight - 1, 1 do
            local i = y * iRegionWidth + x + 1; -- Lua arrays start at 1.
            local val = regionContinentsFrac:GetHeight(x,y);
            if val <= iWaterThreshold or Adjacent(i) == true then
                --do nothing
            else
                plotTypes2[i] = g_PLOT_TYPE_LAND;
            end
        end
    end

    if bShift then -- Shift plots to obtain a more natural shape.
        ShiftPlotTypes(plotTypes);
    end

    print("Shifted Plots - Width: ", iRegionWidth, "Height: ", iRegionHeight);

    -- Apply the region's plots to the global plot array.
    for x = 0, iRegionWidth - 1, 1 do
        local wholeworldX = x + iRegionWestX;
        for y = 0, iRegionHeight - 1, 1 do
            local index = y * iRegionWidth + x + 1
            if plotTypes2[index] ~= g_PLOT_TYPE_OCEAN then
                local wholeworldY = y + iRegionSouthY;
                local i = wholeworldY * g_iW + wholeworldX + 1
                plotTypes[i] = plotTypes2[index];
            end
        end
    end
    --print("Generated Plot Types");

    return plotTypes;
end

-- copied from Island_Plates.lua
-------------------------------------------------------------------------------
function GenerateWaterLayer (args, plotTypes)
    -- This function is intended to allow adding seas to specific areas of large continents.
    local args = args or {};
    
    -- Handle args or assign defaults.
    local iWaterPercent = args.iWaterPercent or 31;
    local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
    local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
    local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
    local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
    local iRegionGrain = args.iRegionGrain or 1;
    local iRegionPlotFlags = args.iRegionPlotFlags or g_iFlags;
    local iRegionFracXExp = args.iRegionFracXExp or 4;
    local iRegionFracYExp = args.iRegionFracYExp or 6;
    local iRiftGrain = args.iRiftGrain or -1;
    local bShift = args.bShift or true;

    -- Init the plot types array for this region's plot data. Redone for each new layer.
    -- Compare to self.wholeworldPlotTypes, which contains the sum of all layers.
    plotTypes2 = {};
    -- Loop through the region's plots
    for x = 0, iRegionWidth - 1, 1 do
        for y = 0, iRegionHeight - 1, 1 do
            local i = y * iRegionWidth + x + 1; -- Lua arrays start at 1.
            plotTypes2[i] = g_PLOT_TYPE_OCEAN;
        end
    end

    -- Init the land/water fractal
    local regionContinentsFrac;
    if (iRiftGrain > 0) and (iRiftGrain < 4) then
        local riftsFrac = Fractal.Create(iRegionWidth, iRegionHeight, iRiftGrain, {}, iRegionFracXExp, iRegionFracYExp);
        regionContinentsFrac = Fractal.CreateRifts(iRegionWidth, iRegionHeight, iRegionGrain, iRegionPlotFlags, riftsFrac, iRegionFracXExp, iRegionFracYExp);
    else
        regionContinentsFrac = Fractal.Create(iRegionWidth, iRegionHeight, iRegionGrain, iRegionPlotFlags, iRegionFracXExp, iRegionFracYExp);   
    end
    
    -- Using the fractal matrices we just created, determine fractal-height values for sea level.
    local iWaterThreshold = regionContinentsFrac:GetHeight(iWaterPercent);

    -- Loop through the region's plots
    for x = 0, iRegionWidth - 1, 1 do
        for y = 0, iRegionHeight - 1, 1 do
            local i = y * iRegionWidth + x + 1; -- Lua arrays start at 1.
            local val = regionContinentsFrac:GetHeight(x,y);
            if val <= iWaterThreshold then
                --do nothing
            else
                plotTypes2[i] = g_PLOT_TYPE_LAND;
            end
        end
    end

    if bShift then -- Shift plots to obtain a more natural shape.
        ShiftPlotTypes(plotTypes);
    end

    -- Apply the region's plots to the global plot array.
    for x = 0, iRegionWidth - 1, 1 do
        local wholeworldX = x + iRegionWestX;
        for y = 0, iRegionHeight - 1, 1 do
            local i = y * iRegionWidth + x + 1;
            if plotTypes2[i] ~= g_PLOT_TYPE_OCEAN then
                local wholeworldY = y + iRegionSouthY;
                local index = wholeworldY * g_iW + wholeworldX + 1
                plotTypes[index] = g_PLOT_TYPE_OCEAN;
            end
        end
    end

    -- This region is done.
    return plotTypes;
end
------------------------------------------------------------------------------- 
-------------------------------------------------------------------------------
--火山土开局生成----------------------------------------------------------------
function AddVolcanicSoil()
    local mWidth,mHeight = Map.GetGridSize();
    for CoordinateX = 0,mWidth,1 do
        for CoordinateY = 0,mHeight-1,1 do
            local plots = Map.GetPlot(CoordinateX,CoordinateY);
            if (plots:GetFeatureType() ~= -1) then
                if (GameInfo.Features[plots:GetFeatureType()].FeatureType == "FEATURE_VOLCANO") then
                    local tNeighborPlots = Map.GetAdjacentPlots(CoordinateX,CoordinateY);
                    for _, pNeighborPlot in ipairs(tNeighborPlots) do
                        if (not pNeighborPlot:IsWater() and not pNeighborPlot:IsMountain()) then
                            TerrainBuilder.SetFeatureType(pNeighborPlot,35);
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
                        if (not pNeighborPlot:IsWater() and not pNeighborPlot:IsMountain()) then
                            if (pNeighborPlot:GetFeatureType() ~= -1) then
                                if (GameInfo.Features[pNeighborPlot:GetFeatureType()].FeatureType ~= "FEATURE_EYJAFJALLAJOKULL"
                                and GameInfo.Features[pNeighborPlot:GetFeatureType()].FeatureType ~= "FEATURE_SUK_NGORONGORO_CRATER") then
                                    TerrainBuilder.SetFeatureType(pNeighborPlot,35);
                                end
                            else
                                TerrainBuilder.SetFeatureType(pNeighborPlot,35);
                            end
                        end
                        --二环随机生成
                        local sNeighborPlots = Map.GetAdjacentPlots(pNeighborPlot:GetX(), pNeighborPlot:GetY());
                        for _, rNeighborPlot in ipairs(sNeighborPlots) do
                            if (not rNeighborPlot:IsWater() and not rNeighborPlot:IsMountain()) then
                                if (rNeighborPlot:GetFeatureType() ~= -1) then
                                    if (GameInfo.Features[rNeighborPlot:GetFeatureType()].FeatureType ~= "FEATURE_EYJAFJALLAJOKULL"
                                    and GameInfo.Features[rNeighborPlot:GetFeatureType()].FeatureType ~= "FEATURE_KILIMANJARO"
                                    and GameInfo.Features[rNeighborPlot:GetFeatureType()].FeatureType ~= "FEATURE_VESUVIUS"
                                    and GameInfo.Features[rNeighborPlot:GetFeatureType()].FeatureType ~= "FEATURE_SUK_FUJI"
                                    and GameInfo.Features[rNeighborPlot:GetFeatureType()].FeatureType ~= "FEATURE_SUK_NGORONGORO_CRATER") then
                                        if (math.random(3) == 1) then
                                            TerrainBuilder.SetFeatureType(rNeighborPlot,35);
                                        end
                                    end
                                else
                                    if (math.random(3) == 1) then
                                        TerrainBuilder.SetFeatureType(rNeighborPlot,35);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
---------------------------------------------------------------------------------------------------- 

 function FeatureGenerator:AddIceToMap()
    local iTargetIceTiles = (self.iGridH * self.iGridW *  (GlobalParameters.ICE_TILES_PERCENT + self.iIceModifiedPercent)) / 100;

    local aPhases = {};
    local iPhases = 0;
    for row in GameInfo.RandomEvents() do
        if (row.EffectOperatorType == "SEA_LEVEL") then
            local kPhaseDetails = {};
            kPhaseDetails.RandomEventEnum = row.Index;
            kPhaseDetails.IceLoss = row.IceLoss;
            table.insert(aPhases, kPhaseDetails);
            iPhases = iPhases + 1;
        end
    end
    
    if (iPhases <= 0) then 
        return;
    end

    ------------------------------
    -- PHASE ONE: PERMANENT ICE --
    ------------------------------
    local iIceLossThisLevel = aPhases[iPhases].IceLoss;
    local iPermanentIcePercent = 100 - iIceLossThisLevel;
    local iPermanentIceTiles = (iTargetIceTiles * iPermanentIcePercent) / 100;

    print ("Permanent Ice Tiles: " .. tostring(iPermanentIceTiles));

    -- Count top/bottom map tiles
    local iWaterTilesOnEdges = 0;
    --   On bottom
    for x = 0, self.iGridW - 1, 1 do
        y = 0;
        local i = y * self.iGridW + x;
        local plot = Map.GetPlotByIndex(i);
        if (plot ~= nil) then
            if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_ICE) == true and IsAdjacentToLandPlot(x, y) == false) then
                iWaterTilesOnEdges = iWaterTilesOnEdges + 1;
            end
        end
    end
    --   On top
    for x = 0, self.iGridW - 1, 1 do
        local y = self.iGridH - 1;
        local i = y * self.iGridW + x;
        local plot = Map.GetPlotByIndex(i);
        if (plot ~= nil) then
            if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_ICE) == true and IsAdjacentToLandPlot(x, y) == false) then
                iWaterTilesOnEdges = iWaterTilesOnEdges + 1;
            end
        end
    end

    if (iWaterTilesOnEdges > 0) then
        local iPercentNeeded = 100 * iPermanentIceTiles / iWaterTilesOnEdges;
        for x = 0, self.iGridW - 1, 1 do
            y = 0;
            local i = y * self.iGridW + x;
            local plot = Map.GetPlotByIndex(i);
            if (plot ~= nil) then
                if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_ICE) == true and IsAdjacentToLandPlot(x, y) == false) then
                    if (TerrainBuilder.GetRandomNumber(100, "Permanent Ice") <= iPercentNeeded) then
                        TerrainBuilder.SetFeatureType(plot, g_FEATURE_ICE);
                        TerrainBuilder.AddIce(plot:GetIndex(), -1); 
                    end
                end
            end
        end
        for x = 0, self.iGridW - 1, 1 do
            local y = self.iGridH - 1;
            local i = y * self.iGridW + x;
            local plot = Map.GetPlotByIndex(i);
            if (plot ~= nil) then
                if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_ICE) == true and IsAdjacentToLandPlot(x, y) == false) then
                    if (TerrainBuilder.GetRandomNumber(100, "Permanent Ice") <= iPercentNeeded) then
                        TerrainBuilder.SetFeatureType(plot, g_FEATURE_ICE);
                        TerrainBuilder.AddIce(plot:GetIndex(), -1); 
                    end
                end
            end
        end
    end

    ---------------------------------------
    -- PHASE TWO: ICE THAT CAN DISAPPEAR --
    ---------------------------------------
    if (iPhases > 1) then
        for iPhaseIndex = iPhases, 1, -1 do
            kPhaseDetails = aPhases[iPhaseIndex];
            local iIcePercentToAdd = 0;
            if (iPhaseIndex == 1) then 
                iIcePercentToAdd = kPhaseDetails.IceLoss;           
            else
                iIcePercentToAdd = kPhaseDetails.IceLoss - aPhases[iPhaseIndex - 1].IceLoss;
            end
            local iIceTilesToAdd = (iTargetIceTiles * iIcePercentToAdd) / 100;

            print ("iPhaseIndex: " .. tostring(iPhaseIndex) .. ", iIceTilesToAdd: " .. tostring(iIceTilesToAdd) .. ", RandomEventEnum: " .. tostring(kPhaseDetails.RandomEventEnum));

            -- Find all plots on map adjacent to already-placed ice
            local aTargetPlots = {};
            for y = 0, self.iGridH - 1, 1 do
                for x = 0, self.iGridW - 1, 1 do
                    local i = y * self.iGridW + x;
                    local plot = Map.GetPlotByIndex(i);
                    if (plot ~= nil) then
                        local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_ICE);
                        if (TerrainBuilder.CanHaveFeature(plot, g_FEATURE_ICE) == true and iAdjacent > 0) then
                            if not IsAdjacentToLandPlot(x, y) then -- HD: no ice adjacent to land
                                local kPlotDetails = {};
                                kPlotDetails.PlotIndex = i;
                                kPlotDetails.AdjacentIce = iAdjacent;
                                kPlotDetails.AdjacentToLand = IsAdjacentToLandPlot(x, y);
                                table.insert(aTargetPlots, kPlotDetails);
                            end -- HD: no ice adjacent to land
                        end
                    end
                end
            end

            -- Roll die to see which of these get ice
            if (#aTargetPlots > 0) then
                local iPercentNeeded = 10 * iIceTilesToAdd / #aTargetPlots;
                for i, targetPlot in ipairs(aTargetPlots) do
                    local iFinalPercentNeeded = iPercentNeeded + 10 * targetPlot.AdjacentIce;
                    if (targetPlot.AdjacentToLand == true) then
                        iFinalPercentNeeded = iFinalPercentNeeded / 10;
                    end
                    if (TerrainBuilder.GetRandomNumber(100, "Permanent Ice") <= iFinalPercentNeeded) then
                        local plot = Map.GetPlotByIndex(targetPlot.PlotIndex);
                        TerrainBuilder.SetFeatureType(plot, g_FEATURE_ICE);
                        TerrainBuilder.AddIce(plot:GetIndex(), kPhaseDetails.RandomEventEnum); 
                    end
                end
            end
        end
    end
end

--------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
function Adjacent(index)
    aIslands = islands;
    index = index -1;

    if(aIslands == nil) then
        return false;
    end
    
    if(index < 0) then
        return false
    end

    local plot = Map.GetPlotByIndex(index);
    if(aIslands[index] ~= nil and aIslands[index] == g_PLOT_TYPE_LAND) then
        return true;
    end

    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
        local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
        if(adjacentPlot ~= nil) then
            local newIndex = adjacentPlot:GetIndex();
            if(aIslands  ~= nil and aIslands[newIndex] == g_PLOT_TYPE_LAND) then
                return true;
            end
        end
    end

    return false;
end


-------------------------------------------------------------------------------------------


function AssignStartingPlots:__MajorCivBuffer(plot)
    -- Checks to see if there are major civs in the given distance for this major civ

    local iMaxStart = 14 or 12;

    --if (PlayerConfigurations[0]:GetCivilizationTypeName() == "CIVILIZATION_CANADA") or (PlayerConfigurations[0]:GetCivilizationTypeName() == "CIVILIZATION_RUSSIA")then
    --    local iMaxStart = GlobalParameters.START_DISTANCE_MAJOR_CIVILIZATION or 9;
    --end
    iMaxStart = iMaxStart - 5 or 11;

    local iSourceIndex = plot:GetIndex();
    for i, majorPlot in ipairs(self.majorStartPlots) do
        if(Map.GetPlotDistance(iSourceIndex, majorPlot:GetIndex()) <= iMaxStart) then
            return false;
        end
    end 

    return true;
end

------------------------------------------------------------------------------
function AssignStartingPlots:__MinorMajorCivBuffer(plot)
    -- Checks to see if there are najors in the given distance for this minor civ

    local iMaxStart = 7 or 10;

    --if (PlayerConfigurations[0]:GetCivilizationTypeName() == "CIVILIZATION_CANADA") or (PlayerConfigurations[0]:GetCivilizationTypeName() == "CIVILIZATION_RUSSIA")then
    --    local iMaxStart = GlobalParameters.START_DISTANCE_MINOR_MAJOR_CIVILIZATION -1 or 13;
    --end
    local iSourceIndex = plot:GetIndex();
    
    if(self.waterMap == true) then
        iMaxStart = iMaxStart -2 or iMaxStart + 1;
    end
    
    for i, majorPlot in ipairs(self.majorCopy) do
        if(Map.GetPlotDistance(iSourceIndex, majorPlot:GetIndex()) <= iMaxStart) then
            return false;
        end
    end 

    return true;
end

------------------------------------------------------------------------------
function AssignStartingPlots:__MinorMinorCivBuffer(plot)
    -- Checks to see if there are minors in the given distance for this minor civ

    local iMaxStart = 7 or 5;

    
    local iSourceIndex = plot:GetIndex();

    for i, minorPlot in ipairs(self.minorStartPlots) do
        if(Map.GetPlotDistance(iSourceIndex, minorPlot:GetIndex()) <= iMaxStart) then
            return false;
        end
    end

    return true;
end
