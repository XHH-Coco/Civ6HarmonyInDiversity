------------------------------------------------------------------------------
--	FILE:	 Frozen_Continents.lua
--	AUTHOR:  
--	PURPOSE: Base game script - Produces widely varied continents.
------------------------------------------------------------------------------
--	Copyright (c) 2019 Firaxis Games, Inc. All rights reserved.
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
local featureGen = nil;
local world_age_new = 5;
local world_age_normal = 3;
local world_age_old = 2;
local islands = {};

-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Frozen_Continents Map");
	local pPlot;

	-- Set globals
	g_iW, g_iH = Map.GetGridSize();
	g_iFlags = TerrainBuilder.GetFractalFlags();
	local temperature = MapConfiguration.GetValue("temperature"); -- Default setting is Temperate.
	if temperature == 2 then
		temperature  =  1 + TerrainBuilder.GetRandomNumber(2, "Random Temperature- Lua");
	end
	
	--	local world_age
	local world_age = MapConfiguration.GetValue("world_age");
	if (world_age == 1) then
		world_age = world_age_new;
	elseif (world_age == 3) then
		world_age = world_age_normal;
	elseif (world_age == 5) then
		world_age = world_age_old;
	else
		world_age = 2 + TerrainBuilder.GetRandomNumber(4, "Random World Age - Lua");
	end

	plotTypes = GeneratePlotTypes(world_age);
	terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature, false,  -22, -2, -0.12, -0.8,-0.15,0.2,-0.1);
	ApplyBaseTerrain(plotTypes, terrainTypes, g_iW, g_iH);

	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();
	TerrainBuilder.StampContinents();

	local iContinentBoundaryPlots = GetContinentBoundaryPlotCount(g_iW, g_iH);
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());
	AddTerrainFromContinents(plotTypes, terrainTypes, world_age, g_iW, g_iH, iContinentBoundaryPlots,true);--删除大陆边缘群山

	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers();
	
	-- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
	--local numLargeLakes = GameInfo.Maps[Map.GetMapSize()].Continents
	local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 2 + 10); 
	--Continents * 2 + 10=配合造湖的代码，产生一批分散的小湖（在本图上湖内有鱼），创造更多出生点（利于沙漠文明、冻土文明和城邦立足）
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
	AddVolcanicSoil();--火山土开局生成必要语句

	resourcesConfig = MapConfiguration.GetValue("resources");
	local startConfig = MapConfiguration.GetValue("start");-- Get the start config
	local args = {
		iWaterLux = 3,
	    iWaterBonus = 1.8,
		resources = resourcesConfig,
		START_CONFIG = startConfig,
		ExtraBonusGroupOneMultiply = 1.92,							--增加的倍率
		ExtraBonusGroupOne = {	
            "RESOURCE_LEU_P0K_POTATOES",--马铃薯
            "RESOURCE_LEU_P0K_POTATOES",--额外马铃薯
            "RESOURCE_DLV_BISON",		--野牛
            "RESOURCE_DLV_BISON",		--额外野牛
            "RESOURCE_SHEEP",			--羊
            "RESOURCE_LEAD",			--铅锌矿
            "RESOURCE_PINE",			--松木
            "RESOURCE_PINE",			--额外松木
            "RESOURCE_BARLEY",			--青稞
            "RESOURCE_DEER",			--额外鹿
            "RESOURCE_DEER"			    --鹿				
        },--增加的陆地加成资源,水资无效，奢侈战略无效
	};
	local resGen = ResourceGenerator.Create(args);

	print("Creating start plot database.");
	
	-- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
	local args = {
        MIN_MAJOR_CIV_FERTILITY = 85,
        MAX_MAJOR_CIV_FERTILITY = 133,    
        MIN_MINOR_CIV_FERTILITY = 11, 
        MAX_MINOR_CIV_FERTILITY = 65, 
        MIN_BARBARIAN_FERTILITY = 50,
        START_MIN_Y = 31,
        START_MAX_Y = 49,
        START_MIN_X = 19,
        START_MAX_X = 43,
        WATER = true,
		START_CONFIG = startConfig,
};
	local start_plot_database = AssignStartingPlots.Create(args)

	local GoodyGen = AddGoodies(g_iW, g_iH);
end

-------------------------------------------------------------------------------
function GeneratePlotTypes(world_age)
	print("Generating Plot Types");
	local plotTypes = {};

	local sea_level_low = 64;
	local sea_level_normal = 69;--64陆大 76海大
	local sea_level_high = 76;

	local extra_mountains = 0;
	local adjust_plates = 1.5;
	local tectonic_islands = true;
	local water_percent = 0;
	local water_percent_modifier = 0;

	--	local sea_level
    	local sea_level = MapConfiguration.GetValue("sea_level");
	if sea_level == 1 then -- Low Sea Level
		water_percent = sea_level_low
		water_percent_modifier = -4
	elseif sea_level == 2 then -- Normal Sea Level
		water_percent =sea_level_normal
	elseif sea_level == 3 then -- High Sea Level
		water_percent = sea_level_high
		water_percent_modifier = 4;
	else
		water_percent = TerrainBuilder.GetRandomNumber(sea_level_high - sea_level_low, "Random Sea Level - Lua") + sea_level_low  + 1;
		water_percent_modifier = TerrainBuilder.GetRandomNumber(4, "Random Sea Level - Lua") - 4;
	end

	-- Set values for hills and mountains according to World Age chosen by user.
	local adjustment = world_age;
	if world_age <= world_age_old  then -- 5 Billion Years
		adjust_plates = adjust_plates * 0.75;
	elseif world_age >= world_age_new then -- 3 Billion Years
		adjust_plates = adjust_plates * 1.5;
	else -- 4 Billion Years
	end
--------------------------------------------------------------------------------------	
	local done = false;
	local iAttempts = 0;
	while done == false do
		iNumTotalLandTiles = 0;

		local iWaterThreshold;
		InitFractal{continent_grain = 3};
		iWaterThreshold = g_continentsFrac:GetHeight(water_percent);

		for x = 0, g_iW - 1 do
			for y = 0, g_iH - 1 do
				local i = y * g_iW + x;
				local val = g_continentsFrac:GetHeight(x, y);
				local pPlot = Map.GetPlotByIndex(i);
				
				if(val >= iWaterThreshold) then
					plotTypes[i] = g_PLOT_TYPE_LAND;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
					iNumTotalLandTiles = iNumTotalLandTiles + 1;
				else
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  -- temporary setting so can calculate areas
				end
			end
		end
	
		ShiftPlotTypes(plotTypes);

		AreaBuilder.Recalculate();
		local biggest_area = Areas.FindBiggestArea(false);
		iNumBiggestAreaTiles = biggest_area:GetPlotCount();
		
		-- Now test the biggest landmass to see if it is small enough.
		if iNumBiggestAreaTiles <= iNumTotalLandTiles * 0.36 then
			done = true;
		end
		iAttempts = iAttempts + 1;
		--print("--- Continents landmass generation, Attempt#", iAttempts, "---");
		--print("- Total Land Plots in world:", iNumTotalLandTiles);
		--print("- Land Plots belonging to biggest landmass:", iNumBiggestAreaTiles);
	end
--------------------------------------------------------------------------------------		
	
	-- Generate Medium Islands  小小型大陆/大型半岛，偏竖偏方
    islands = plotTypes;
    local args = {};    
    args.iWaterPercent = 72 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 5;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 5;
    args.iRegionFracYExp = 5;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;
	
    -- Generate Small Islands   --联结物
    islands = plotTypes;
    local args = {};    
    args.iWaterPercent = 79 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 5;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 6;
    args.iRegionFracYExp = 5;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;



    -- Generate Tiny Islands 可移民的最小型岛
    local args = {};    
    args.iWaterPercent = 83 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 5;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 5;
    args.iRegionFracYExp = 4;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    

    -- Generate fishing Islands 产鱼产礁石
    local args = {};    
    args.iWaterPercent = 92 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 5;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 6;
    args.iRegionFracYExp = 4;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

    -- Generate fishing Islands 产鱼产礁石
    local args = {};    
    args.iWaterPercent = 84 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 5;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 4;
    args.iRegionFracYExp = 5;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

    -- Generate fishing Islands 产鱼产礁石
    local args = {};    
    args.iWaterPercent = 88 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 3;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 6;
    args.iRegionFracYExp = 5;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

	-- Generate Medium Lakes	
	local args = {};	
	args.iWaterPercent = 95 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = math.floor(0);
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 6;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 5;
	args.iRegionFracYExp = 3;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
	islands = plotTypes;

	-- Generate Tiny Lakes
	local args = {};	
	args.iWaterPercent = 95 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = math.floor(0);
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 5;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 4;
	args.iRegionFracYExp = 3;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

     -- 峡湾，竖向	钓鱼点，陆地切割者
    local args = {};
    args.iWaterPercent = 98 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 6;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 6;
    args.iRegionFracYExp = 5;
    args.iRiftGrain = -1;
    plotTypes = GenerateWaterLayer(args, plotTypes);

    -- 峡湾，斜向	陆地切割者
    local args = {};
    args.iWaterPercent = 96 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 5;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 3;
    args.iRegionFracYExp = 5;
    args.iRiftGrain = -1;
    plotTypes = GenerateWaterLayer(args, plotTypes);

    -- 峡湾，斜向	陆地切割者
    local args = {};
    args.iWaterPercent = 97 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 5;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 5;
    args.iRegionFracYExp = 3;
    args.iRiftGrain = -1;
    plotTypes = GenerateWaterLayer(args, plotTypes);



	local args = {};
	args.world_age = world_age;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 3;
	args.blendFract = 1;
	--args.extra_mountains = -3;
	args.extra_mountains = -1;
	mountainRatio = 9 + world_age * 4;
	plotTypes = ApplyTectonics(args, plotTypes);
	plotTypes = AddLonelyMountains(plotTypes, mountainRatio);

	return plotTypes;
end
--------------------------------------------------------------------------------------
function InitFractal(args)

	if(args == nil) then args = {}; end

	local continent_grain = args.continent_grain or 2;
	local rift_grain = args.rift_grain or -1; -- Default no rifts.
	local invert_heights = args.invert_heights or false;
	local polar = args.polar or true;
	local ridge_flags = args.ridge_flags or g_iFlags;

	local fracFlags = {};
	
	if(invert_heights) then
		fracFlags.FRAC_INVERT_HEIGHTS = true;
	end
	
	if(polar) then
		fracFlags.FRAC_POLAR = true;
	end
	
	if(rift_grain > 0 and rift_grain < 4) then
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 5, 4);
		g_continentsFrac = Fractal.CreateRifts(g_iW, g_iH, continent_grain, fracFlags, riftsFrac, 3, 3);
	else
		g_continentsFrac = Fractal.Create(g_iW, g_iH, continent_grain, fracFlags, 4, 4);	
	end
	--
	local MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.MapSizeType] = row.PlateValue;
	end
	local sizekey = Map.GetMapSize();

	local numPlates = MapSizeTypes[sizekey] or 4

	g_continentsFrac:BuildRidges(numPlates, {}, 1, 2);
end

function AddFeatures()
	print("Adding Features");

	-- Get Rainfall setting input by user.
	local rainfall = MapConfiguration.GetValue("rainfall");
	if rainfall == 4 then
		rainfall = 1 + TerrainBuilder.GetRandomNumber(3, "Random Rainfall - Lua");
	end

	local args = {rainfall = rainfall, iMarshPercent = 1, iSwampPercent = 1, iJunglePercent = 15, iForestPercent = 19} 
	--茂盛的森林植被，可创造更多锤足够的出生点，因此，城邦出生点下限也要适当降低才易扔到角落；主要文明出生点需要更高的下限和更高的上限以获得高级的出生点。
	featuregen = FeatureGenerator.Create(args);
	featuregen:AddFeatures(true, true);  --second parameter is whether or not rivers start inland);
end

function AddFeaturesFromContinents()
	print("Adding Features from Continents");

	featuregen:AddFeaturesFromContinents();
end
--------------------------------------------------------------------------------------
function GenerateFractalLayerWithoutHills (args, plotTypes)
	local args = args or {};
	local plotTypes2 = {};

	-- Handle args or assign defaults.
	local iWaterPercent = args.iWaterPercent or 55;
	local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
	local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
	local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
	local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
	local iRegionGrain = args.iRegionGrain or 4;
	local iRegionPlotFlags = args.iRegionPlotFlags or g_iFlags;
	local iRegionTerrainFlags = g_iFlags; -- Removed from args list.
	local iRegionFracXExp = args.iRegionFracXExp or 3;
	local iRegionFracYExp = args.iRegionFracYExp or 3;
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
	if(iRiftGrain > 0 and iRiftGrain < 2) then--2协助塑形大陆成叶片状，4无干扰会按参数长得方状或者条状，配置海平面适当上升，结构变形随机度更高
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 4, 4);
		regionContinentsFrac = Fractal.CreateRifts(g_iW, g_iH, iRegionGrain, iRegionPlotFlags, riftsFrac, iRegionFracXExp, iRegionFracYExp);
	else
		regionContinentsFrac = Fractal.Create(g_iW, g_iH, iRegionGrain, iRegionPlotFlags, iRegionFracXExp, iRegionFracYExp);	
	end
	--print("Initialized main fractal");
	local iWaterThreshold = regionContinentsFrac:GetHeight(iWaterPercent);

	-- Loop through the region's plots
	for x = 0, iRegionWidth - 1, 1 do
		for y = 0, iRegionHeight - 1, 1 do
			local i = y * iRegionWidth + x + 1; 
			local val = regionContinentsFrac:GetHeight(x,y);
			if val <= iWaterThreshold or Adjacent(i) == true then
				--do nothing
			else
				plotTypes2[i] = g_PLOT_TYPE_LAND;
			end
		end
	end

	if bShift then
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

--------------------------------------------------------------------------------------
function GenerateWaterLayer (args, plotTypes)
    -- This function is intended to allow adding seas to specific areas of large continents.
    local args = args or {};
    
    -- Handle args or assign defaults.
    local iWaterPercent = args.iWaterPercent or 32;
    local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
    local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
    local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
    local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
    local iRegionGrain = args.iRegionGrain or 4;
    local iRegionPlotFlags = args.iRegionPlotFlags or g_iFlags;
    local iRegionFracXExp = args.iRegionFracXExp or 5;
    local iRegionFracYExp = args.iRegionFracYExp or 3;
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
    if (iRiftGrain > 0) and (iRiftGrain < 2) then
        local riftsFrac = Fractal.Create(iRegionWidth, iRegionHeight, iRiftGrain, {}, 3, 4);
        regionContinentsFrac = Fractal.CreateRifts(iRegionWidth, iRegionHeight, iRegionGrain, iRegionPlotFlags, riftsFrac, 3, 4);
    else
        regionContinentsFrac = Fractal.Create(iRegionWidth, iRegionHeight, iRegionGrain, iRegionPlotFlags, 5, 5);   
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

-----修改
    -- This region is done.
--    return plotTypes;
--end
-----修改
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
--------------------------------------------------------------------------------------
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
								local iPercentNeeded = 100 * iIceTilesToAdd / #aTargetPlots;
								for i, targetPlot in ipairs(aTargetPlots) do
									local iFinalPercentNeeded = iPercentNeeded + 10 * targetPlot.AdjacentIce;
									if (targetPlot.AdjacentToLand == true) then
										iFinalPercentNeeded = iFinalPercentNeeded / 3;
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
--------------------------------------------------------------------------------------

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

