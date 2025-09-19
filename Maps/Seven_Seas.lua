------------------------------------------------------------------------------
--	FILE:	 Splintered_Fractal.lua
--	AUTHOR:  
--	PURPOSE: Base game script - Produces widely varied continents.
------------------------------------------------------------------------------
--	Copyright (c) 2014 Firaxis Games, Inc. All rights reserved.
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
	print("Generating Seven_Seas Map");
	local pPlot;

	-- Set globals
	g_iW, g_iH = Map.GetGridSize();
	g_iFlags = TerrainBuilder.GetFractalFlags();

	local temperature = MapConfiguration.GetValue("temperature"); -- Default setting is Temperate.
	if temperature == 4 then
		temperature  =  1 + TerrainBuilder.GetRandomNumber(3, "Random Temperature- Lua");
	end
	
	--	local world_age
	local world_age = MapConfiguration.GetValue("world_age");
	if (world_age == 1) then
		world_age = world_age_new;
	elseif (world_age == 2) then
		world_age = world_age_normal;
	elseif (world_age == 3) then
		world_age = world_age_old;
	else
		world_age = 2 + TerrainBuilder.GetRandomNumber(4, "Random World Age - Lua");
	end

	plotTypes = GeneratePlotTypes(world_age);
	terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature);--
	ApplyBaseTerrain(plotTypes, terrainTypes, g_iW, g_iH);
	
	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();
	TerrainBuilder.StampContinents();

	local iContinentBoundaryPlots = GetContinentBoundaryPlotCount(g_iW, g_iH);
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());
	AddTerrainFromContinents(plotTypes, terrainTypes, world_age, g_iW, g_iH, iContinentBoundaryPlots, true); --添加true削掉七海的大陆边界山脉

	AreaBuilder.Recalculate();

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers();
	
	-- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
	--local numLargeLakes = GameInfo.Maps[Map.GetMapSize()].Continents
	local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 4 + 14);
	AddLakes(numLargeLakes);

	AddFeatures();
	TerrainBuilder.AnalyzeChokepoints();
	
	print("Adding cliffs");
	AddCliffs(plotTypes, terrainTypes);

	local args = {
		numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
	};
	local nwGen = NaturalWonderGenerator.Create(args);
	
	AddFeaturesFromContinents();
	MarkCoastalLowlands();
	
	--for i = 0, (g_iW * g_iH) - 1, 1 do
		--pPlot = Map.GetPlotByIndex(i);
		--print ("i: plotType, terrainType, featureType: " .. tostring(i) .. ": " .. tostring(plotTypes[i]) .. ", " .. tostring(terrainTypes[i]) .. ", " .. tostring(pPlot:GetFeatureType(i)));
	--end
	AddVolcanicSoil();--火山土开局生成必要语句
	local resourcesConfig = MapConfiguration.GetValue("resources");
	local startconfig = MapConfiguration.GetValue("start"); -- Get the start config
	local args = {
	    iWaterLux = 3,
	    iWaterBonus = 1.6,
		resources = resourcesConfig,
		START_CONFIG = startConfig,
	};
	local resGen = ResourceGenerator.Create(args);

	print("Creating start plot database.");
	
	-- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
	local args = {
        MIN_MAJOR_CIV_FERTILITY = 107,
        MAX_MAJOR_CIV_FERTILITY = 148,    
        MIN_MINOR_CIV_FERTILITY = 18, 
        MAX_MINOR_CIV_FERTILITY = 83, 
        MIN_BARBARIAN_FERTILITY = 60,
        START_MIN_Y = 35,
        START_MAX_Y = 43,
        START_MIN_X = 35,
        START_MAX_X = 43,
        WATER = true,
		START_CONFIG = startconfig,
	};
	local start_plot_database = AssignStartingPlots.Create(args)

	local GoodyGen = AddGoodies(g_iW, g_iH);
end


-------------------------------------------------------------------------------
function GeneratePlotTypes(world_age)
	print("Generating Plot Types");
	local plotTypes = {};
	
	local sea_level_low = 29;
	local sea_level_normal = 43;
	local sea_level_high = 58;
	local extra_mountains = 0;
	local adjust_plates = 1.0;
	local shift_plot_types = true;
	local hills_ridge_flags = g_iFlags;
	local peaks_ridge_flags = g_iFlags;
	local has_center_rift = false;

	--	local sea_level
    local sea_level = MapConfiguration.GetValue("sea_level");
	local water_percent;
	local water_percent_modifier = 0;
	if sea_level == 1 then -- Low Sea Level
		water_percent = 20
		water_percent_modifier = -4
	elseif sea_level == 2 then -- Normal Sea Level
		water_percent = 22
		water_percent_modifier = 4;
	elseif sea_level == 3 then -- High Sea Level
		water_percent = 45
	else
		water_percent = TerrainBuilder.GetRandomNumber(sea_level_high- sea_level_low, "Random Sea Level - Lua") + sea_level_low  + 1 ;
		water_percent_modifier = TerrainBuilder.GetRandomNumber(9, "Random Sea Level - Lua") - 4;
	end

	-- Set values for hills and mountains according to World Age chosen by user.
	local adjustment = world_age;
	if world_age <= world_age_old  then -- 5 Billion Years
		adjust_plates = adjust_plates * 0.75;
	elseif world_age >= world_age_new then -- 3 Billion Years
		adjust_plates = adjust_plates * 1.5;
	else -- 4 Billion Years
	end

	local hillsBottom1 = 37 - adjustment;
	local hillsTop1 = 37 + adjustment;
	local hillsBottom2 = 61 - adjustment;
	local hillsTop2 = 66 + adjustment;
	local hillsClumps = 1 + adjustment;
	local hillsNearMountains = 93 - (adjustment * 2) - extra_mountains;
	local mountains = 97 - adjustment - extra_mountains;

	local polar =  false;

	local fracFlags = {};

	fracFlags.FRAC_POLAR = true;
	local MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.MapSizeType] = row.PlateValue;
	end
	local sizekey = Map.GetMapSize();
	local numPlates = MapSizeTypes[sizekey] or 4;

	local continent_grain = 3;
	local rift_grain = -1; --=-1

	local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 5, 5);
	g_continentsFrac = Fractal.CreateRifts(g_iW, g_iH, continent_grain, fracFlags, riftsFra,6, 5);
	--g_continentsFrac:BuildRidges(numPlates, {}, 1, 2); --水体生成,因为容易报错暂且删除
	
	hillsFrac = Fractal.Create(g_iW, g_iH, continent_grain, {}, 4, 4);
	mountainsFrac = Fractal.Create(g_iW, g_iH, continent_grain, {}, 4, 4);
	hillsFrac:BuildRidges(numPlates, g_iFlags, 1, 2);
	mountainsFrac:BuildRidges(numPlates * 2/3, g_iFlags, 6, 1);
	local iWaterThreshold = g_continentsFrac:GetHeight(water_percent);	
	local iHillsBottom1 = hillsFrac:GetHeight(hillsBottom1);
	local iHillsTop1 = hillsFrac:GetHeight(hillsTop1);
	local iHillsBottom2 = hillsFrac:GetHeight(hillsBottom2);
	local iHillsTop2 = hillsFrac:GetHeight(hillsTop2);
	local iHillsClumps = mountainsFrac:GetHeight(hillsClumps);
	local iHillsNearMountains = mountainsFrac:GetHeight(hillsNearMountains);
	local iMountainThreshold = mountainsFrac:GetHeight(mountains);
	local iPassThreshold = hillsFrac:GetHeight(hillsNearMountains);
	local iMountain100 = mountainsFrac:GetHeight(100);
	local iMountain99 = mountainsFrac:GetHeight(99);
	local iMountain97 = mountainsFrac:GetHeight(97);
	local iMountain95 = mountainsFrac:GetHeight(95);

	for x = 0, g_iW - 1 do
		for y = 0, g_iH - 1 do
			local i = y * g_iW + x + 1;
			local val = g_continentsFrac:GetHeight(x, y);
			local mountainVal = mountainsFrac:GetHeight(x, y);
			local hillVal = hillsFrac:GetHeight(x, y);
			local pPlot = Map.GetPlotByIndex(i);
	
			if(val <= iWaterThreshold) then
				plotTypes[i] = g_PLOT_TYPE_OCEAN;
				TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  -- temporary setting so can calculate areas

				if (mountainVal == iMountain100) then -- Isolated peak in the ocean
					plotTypes[i] = g_PLOT_TYPE_MOUNTAIN;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
				elseif (mountainVal == iMountain99) then
					plotTypes[i] = g_PLOT_TYPE_HILLS;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
				elseif (mountainVal == iMountain97) or (mountainVal == iMountain95) then
					plotTypes[i] = g_PLOT_TYPE_LAND;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
				end
			else
				if (mountainVal >= iMountainThreshold) then
					if (hillVal >= iPassThreshold) then -- Mountain Pass though the ridgeline - Brian
						plotTypes[i] = g_PLOT_TYPE_HILLS;
						TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
					else -- Mountain
						plotTypes[i] = g_PLOT_TYPE_MOUNTAIN;
						TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
					end
				elseif (mountainVal >= iHillsNearMountains) then
					plotTypes[i] = g_PLOT_TYPE_HILLS;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
				else
					if ((hillVal >= iHillsBottom1 and hillVal <= iHillsTop1) or (hillVal >= iHillsBottom2 and hillVal <= iHillsTop2)) then
						plotTypes[i] = g_PLOT_TYPE_HILLS;
						TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
					else
						plotTypes[i] = g_PLOT_TYPE_LAND;
						TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
					end
				end
			end
		end
	end
	
	ShiftPlotTypes(plotTypes);
	AreaBuilder.Recalculate();


	-- Generate Large Islands   大岛、中型陆地
    local args = {};    
    islands = plotTypes;
    args.iWaterPercent = 65 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 3;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 6;
    args.iRegionFracYExp = 4;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

    ShiftPlotTypes(plotTypes);
    AreaBuilder.Recalculate();
    
    -- Generate Middle Islands   桥接物
    local args = {};
    args.iWaterPercent = 74 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 3;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 5;
    args.iRegionFracYExp = 3;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;



    -- Generate Small Islands  小岛屿1
    local args = {};
    args.iWaterPercent = 81 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 3;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 5;
    args.iRegionFracYExp = 5;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;



    -- Generate Small Islands  小岛屿2
    local args = {};
    args.iWaterPercent = 81 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 1;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 6;
    args.iRegionFracYExp = 4;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;



   -- Generate Small Islands  小岛屿3
    local args = {};
    args.iWaterPercent = 87 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 3;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 5;
    args.iRegionFracYExp = 6;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;


    -- Generate Tiny Fishing Islands  内海岛屿1
    local args = {};
    args.iWaterPercent = 95 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 3;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 5;
    args.iRegionFracYExp = 5;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;

      -- Generate Tiny Fishing Islands  内海岛屿2
    local args = {};
    args.iWaterPercent = 96 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 4;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 3;
    args.iRegionFracYExp = 2;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;

     -- Generate Tiny Fishing Islands  内海岛屿3
    local args = {};
    args.iWaterPercent = 96 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 2;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 3;
    args.iRegionFracYExp = 4;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
    islands = plotTypes;

    -- 峡湾，纵向乱切型 陆地切割者，可产生随机的内海岛屿4
    local args = {};
    args.iWaterPercent = 87 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 5;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 5;
    args.iRegionFracYExp = 4;
    args.iRiftGrain = -1;
    plotTypes = GenerateWaterLayer(args, plotTypes);


    -- 峡湾，填充物   陆地切割者，可产生随机的内海岛屿4
    local args = {};
    args.iWaterPercent = 82 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 5;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 4;
    args.iRegionFracYExp = 5;
    args.iRiftGrain = -1;
    plotTypes = GenerateWaterLayer(args, plotTypes);

    -- 峡湾，陆地切割者，可产生随机的内海岛屿4
    local args = {};
    args.iWaterPercent = 87 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 3;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 3;
    args.iRegionFracYExp = 5;
    args.iRiftGrain = -1;
    plotTypes = GenerateWaterLayer(args, plotTypes);


    -- 峡湾，陆地切割者，可产生随机的内海岛屿4
    local args = {};
    args.iWaterPercent = 84 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 4;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 3;
    args.iRegionFracYExp = 5;
    args.iRiftGrain = -1;
    plotTypes = GenerateWaterLayer(args, plotTypes);

    -- 超小型湖泊 提供淡水
    local args = {};    
    args.iWaterPercent = 97 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 4;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = g_iFlags;
    args.iRegionFracXExp = 3;
    args.iRegionFracYExp = 4;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

    -- 湖还是海
    local args = {};    
    args.iWaterPercent = 82 + water_percent_modifier;
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

    

    -- 小型湖泊 提供淡水
    local args = {};    
    args.iWaterPercent = 94 + water_percent_modifier;
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






		local args = {};
		world_age = world_age;--一种山体代码
		args.world_age = world_age;
		args.iW = g_iW;
		args.iH = g_iH
		args.iFlags = g_iFlags;
		args.tectonic_islands = false;
		args.blendRidge = 3;
		args.blendFract = 1;
		--	args.adjust_plates = 4;暂时不明意义
		args.extra_mountains = -1;
		mountainRatio = 8 + world_age * 4 ;
		plotTypes = ApplyTectonics(args, plotTypes);
		plotTypes = AddLonelyMountains(plotTypes, mountainRatio);

	return plotTypes;
end

----------------------------------------------------------------------------------
function AddFeatures()
	print("Adding Features");

	-- Get Rainfall setting input by user.
	local rainfall = MapConfiguration.GetValue("rainfall");
	if rainfall == 4 then
		rainfall = 1 + TerrainBuilder.GetRandomNumber(3, "Random Rainfall - Lua");
	end
	
	local args = {rainfall = rainfall, iMarshPercent = 4, iSwampPercent = 5, iJunglePercent = 39, iForestPercent = 24} 
	--茂盛的森林植被，可创造更多锤足够的出生点，因此，城邦出生点下限也要适当降低才易扔到角落；主要文明出生点需要更高的下限和更高的上限以获得高级的出生点。
	featuregen = FeatureGenerator.Create(args);
	featuregen:AddFeatures(true, true);  --second parameter is whether or not rivers start inland);
end

function AddFeaturesFromContinents()
	print("Adding Features from Continents");

	featuregen:AddFeaturesFromContinents();
end



-------------------------------------------------------------------------------
function GenerateFractalLayerWithoutHills (args, plotTypes)
	local args = args or {};
	local plotTypes2 = {};

	-- Handle args or assign defaults.
	local iWaterPercent = args.iWaterPercent or 42;
	local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
	local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
	local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
	local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
	local iRegionGrain = args.iRegionGrain or 5;
	local iRegionPlotFlags = args.iRegionPlotFlags or g_iFlags;
	local iRegionTerrainFlags = g_iFlags; -- Removed from args list.
	local iRegionFracXExp = args.iRegionFracXExp or 5;
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
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {},4, 4);
		regionContinentsFrac = Fractal.CreateRifts(g_iW, g_iH, iRegionGrain, iRegionPlotFlags, riftsFrac, 4, 4);
	else
		regionContinentsFrac = Fractal.Create(g_iW, g_iH, iRegionGrain, iRegionPlotFlags, 4, 4);	
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
-------------------------------------------------------------------------------
function GenerateWaterLayer (args, plotTypes)
    -- This function is intended to allow adding seas to specific areas of large continents.
    local args = args or {};
    
    -- Handle args or assign defaults.
    local iWaterPercent = args.iWaterPercent or 42;
    local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
    local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
    local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
    local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
    local iRegionGrain = args.iRegionGrain or 3;
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
    if (iRiftGrain > 0) and (iRiftGrain < 4) then
        local riftsFrac = Fractal.Create(iRegionWidth, iRegionHeight, iRiftGrain, {}, 4, 4);
        regionContinentsFrac = Fractal.CreateRifts(iRegionWidth, iRegionHeight, iRegionGrain, iRegionPlotFlags, riftsFrac, 5, 4);
    else
        regionContinentsFrac = Fractal.Create(iRegionWidth, iRegionHeight, iRegionGrain, iRegionPlotFlags, 4, 4);   
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
	-- Remove ice near land for navigation 0.0quchu jidi de bingkuai
	local bNoIceAdjacentToLand 	= MapConfiguration.GetValue("NoIceAdjacentToLand")
	local bRemoveLowLand		= bExpansion2 and lowLandPlacement ~= "PLACEMENT_IMPORT"
	
	if bNoIceAdjacentToLand then print("Removing Ice adjacent to Land...") end
	print("Removing default LowLands...")
	local g_iW, g_iH = Map.GetGridSize()
	for plotIndex = 0, (g_iW * g_iH) - 1, 1 do
		plot = Map.GetPlotByIndex(plotIndex)
		if bNoIceAdjacentToLand and plot:IsAdjacentToLand() and plot:GetFeatureType() == g_FEATURE_ICE then
			TerrainBuilder.SetFeatureType(plot, -1);
		end
	end
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
-------------------------------------------------------------------------------
