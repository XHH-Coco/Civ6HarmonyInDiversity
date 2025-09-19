------------------------------------------------------------------------------
--	FILE:	 Terra.lua
--	AUTHOR:  
--	PURPOSE: Base game script - Produces a near earth map.
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
include "AssignStartingPlots"

local g_iW, g_iH;
local g_iFlags = {};
local g_continentsFrac = nil;
local islands = {};
------------------------
------------------------------------------------------
-- The application side will call GetMapScriptInfo directly to request
-- information about the map script.
-------------------------------------------------------------------------------
function ApplyTerrain(plotTypes, terrainTypes)
	for i = 0, (g_iW * g_iH) - 1, 1 do
		pPlot = Map.GetPlotByIndex(i);
		if (plotTypes[i] == g_PLOT_TYPE_HILLS) then
			terrainTypes[i] = terrainTypes[i] + 1;
		end
		TerrainBuilder.SetTerrainType(pPlot, terrainTypes[i]);
	end
end
-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Terra Map");
	local pPlot;

	-- Set globals
	g_iW, g_iH = Map.GetGridSize();
	g_iFlags = TerrainBuilder.GetFractalFlags();
	local temperature = MapConfiguration.GetValue("temperature"); -- Default setting is Temperate.
	if temperature == 4 then
		temperature  =  1 + TerrainBuilder.GetRandomNumber(3, "Random Temperature- Lua");
	end
	
	plotTypes = GeneratePlotTypes();
	terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature, false,-8, 0, 0.03, 0.07,0);
	
	print("Expanding coasts");
	for iI = 0, 2 do
		local shallowWaterPlots = {};
		for iX = 0, g_iW - 1 do
			for iY = 0, g_iH - 1 do
				local index = (iY * g_iW) + iX;
				if (terrainTypes[index] == g_TERRAIN_TYPE_OCEAN) then
					-- Chance for each eligible plot to become an expansion is 1 / iExpansionDiceroll.
					-- Default is two passes at 1/8 chance per eligible plot on each pass.
				  --if (IsAdjacentToShallowWater(terrainTypes, iX, iY) and TerrainBuilder.GetRandomNumber(10, "add shallows")  <= 3) then 
					if (IsAdjacentToShallowWater(terrainTypes, iX, iY) and TerrainBuilder.GetRandomNumber(10, "add shallows")  == 0) then 
						table.insert(shallowWaterPlots, index);
					end
				end
			end
		end
		for i, index in ipairs(shallowWaterPlots) do
			terrainTypes[index] = g_TERRAIN_TYPE_COAST;
		end
	end
	ApplyTerrain(plotTypes, terrainTypes);
	
	-- Temp
	AreaBuilder.Recalculate();
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers(1);
	
	-- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
	local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 8);
	AddLakes(numLargeLakes);

	AddFeatures();
	
	print("Adding cliffs");
	AddCliffs(plotTypes, terrainTypes);

	local args = {
		numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
	};
	local nwGen = NaturalWonderGenerator.Create(args);

	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();
	TerrainBuilder.StampContinents();
	
--	for i = 0, (g_iW * g_iH) - 1, 1 do
--		pPlot = Map.GetPlotByIndex(i);
--		print ("i: plotType, terrainType, featureType: " .. tostring(i) .. ": " .. tostring(plotTypes[i]) .. ", " .. tostring(terrainTypes[i]) .. ", " .. tostring(pPlot:GetFeatureType(i)));
--	end
    AddVolcanicSoil();--火山土开局生成必要语句	
	resourcesConfig = MapConfiguration.GetValue("resources");
	local startConfig = MapConfiguration.GetValue("start");-- Get the start config
	local args = {
		iWaterLux = 3,
	    iWaterBonus = 1.33,
		resources = resourcesConfig,
		START_CONFIG = startConfig,
		HorsesMultiply =    2.0,	--调整马资源丰度
        IronMultiply =		3.0,	--调整铁资源丰度
        NiterMultiply =     2.0,	--调整硝石资源丰度
        CoalMultiply =      1.0,	--调整煤炭资源丰度
        OilMultiply =       1.0,	--调整石油资源丰度
        AluminumMultiply =  1.0,	--调整铝资源丰度
	};
	local resGen = ResourceGenerator.Create(args);

	print("Creating start plot database.");
	
	-- START_MIN_Y, START_MAX_Y, START_MIN_X is the percent of the map ignored for major civs' starting positions.
	local args = {
        MIN_MAJOR_CIV_FERTILITY = 110,
        MAX_MAJOR_CIV_FERTILITY = 151,    
        MIN_MINOR_CIV_FERTILITY = 18, 
        MAX_MINOR_CIV_FERTILITY = 68, 
        MIN_BARBARIAN_FERTILITY = 50,
        START_MIN_Y = 15,
        START_MAX_Y = 49,
        START_MIN_X = 19,
        START_MAX_X = 43,
        START_CONFIG = startconfig,
		START_LARGEST_LANDMASS_ONLY = true,
		WATER = true,
		--LAND = true,
	};
	local start_plot_database = AssignStartingPlots.Create(args)

	local GoodyGen = AddGoodies(g_iW, g_iH);
end
-------------------------------------------------------------------------------
function GeneratePlotTypes(world_age)
	local plotTypes = {};

	local sea_level_low = 39;
	local sea_level_normal = 45;
	local sea_level_high = 66;
	local world_age_new = 5;
	local world_age_normal = 3;
	local world_age_old = 2;

	local extra_mountains = 0;
	local grain_amount = 3;
	local adjust_plates = 1.0;
	local shift_plot_types = true;
	local tectonic_islands = false;
	local hills_ridge_flags = g_iFlags;
	local peaks_ridge_flags = g_iFlags;
	local has_center_rift = true;
	local water_percent;

	--	local sea_level
	local sea_level = MapConfiguration.GetValue("sea_level");
	local water_percent_modifier = 0; 
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
	end

	-- Set values for hills and mountains according to World Age chosen by user.
	local adjustment = world_age;
	local world_age = MapConfiguration.GetValue("world_age");
	if world_age <= world_age_old  then -- 5 Billion Years
		adjust_plates = adjust_plates * 0.75;
	elseif world_age >= world_age_new then -- 3 Billion Years
		adjust_plates = adjust_plates * 1.5;
	else -- 4 Billion Years
	end

	-- Generate continental fractal layer and examine the largest landmass. Reject
	-- the result until the largest landmass occupies 58% or less of the total land.
	local done = false;
	local iAttempts = 0;
	local iWaterThreshold, biggest_area, iNumTotalLandTiles, iNumBiggestAreaTiles, iBiggestID;
	
	local iLargeIslandShift = 8;
	local iMediumIslandShift = 12;
	local iTinyIslandShift = 4;
	local iCenterMeridian = math.ceil(g_iW / 2)
	local iLargeIslandValue = math.floor(g_iW / iLargeIslandShift);
	local iMediumIslandValue = math.floor(g_iW / iMediumIslandShift);
	local iTinyIslandValue = math.floor(g_iW / iTinyIslandShift);
	
	while done == false do
		local grain_dice = TerrainBuilder.GetRandomNumber(7, "Continental Grain roll - LUA Continents");
		if grain_dice < 4 then
			grain_dice = 2;
		else
			grain_dice = 1;
		end
		local rift_dice = TerrainBuilder.GetRandomNumber(3, "Rift Grain roll - LUA Continents");
		if rift_dice < 1 then
			rift_dice = -1;
		end
		
		InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
		iWaterThreshold = g_continentsFrac:GetHeight(water_percent);
		local iBuffer = math.floor(g_iH/13.0);
		local iBuffer2 = math.floor(g_iH/13.0/2.0);

		iNumTotalLandTiles = 0;
		for x = 0, g_iW - 1 do
			for y = 0, g_iH - 1 do
				local i = y * g_iW + x;
				local val = g_continentsFrac:GetHeight(x, y);
				local pPlot = Map.GetPlotByIndex(i);

				if(y <= iBuffer or y >= g_iH - iBuffer - 1) then
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  -- temporary setting so can calculate areas
				else
					if(val >= iWaterThreshold) then
						if(y <= iBuffer + iBuffer2) then
							local iRandomRoll = y - iBuffer + 1;
							local iRandom = TerrainBuilder.GetRandomNumber(iRandomRoll, "Random Region Edges");
							if(iRandom == 0 and iRandomRoll > 0) then
								plotTypes[i] = g_PLOT_TYPE_LAND;
								TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
								iNumTotalLandTiles = iNumTotalLandTiles + 1;
							else 
								plotTypes[i] = g_PLOT_TYPE_OCEAN;
								TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  -- temporary setting so can calculate areas
							end
						elseif (y >= g_iH - iBuffer - iBuffer2 - 1) then
							local iRandomRoll = g_iH - y - iBuffer;
							local iRandom = TerrainBuilder.GetRandomNumber(iRandomRoll, "Random Region Edges");
							if(iRandom == 0 and iRandomRoll > 0) then
								plotTypes[i] = g_PLOT_TYPE_LAND;
								TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
								iNumTotalLandTiles = iNumTotalLandTiles + 1;
							else
								plotTypes[i] = g_PLOT_TYPE_OCEAN;
								TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  -- temporary setting so can calculate areas
							end
						else
							plotTypes[i] = g_PLOT_TYPE_LAND;
							TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
							iNumTotalLandTiles = iNumTotalLandTiles + 1;
						end
					else
						plotTypes[i] = g_PLOT_TYPE_OCEAN;
						TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  -- temporary setting so can calculate areas
					end
				end
			end
		end

		ShiftPlotTypes(plotTypes);
		GenerateCenterRift(plotTypes);

		AreaBuilder.Recalculate();
		local biggest_area = Areas.FindBiggestArea(false);
		iNumBiggestAreaTiles = biggest_area:GetPlotCount();
		
		-- Now test the biggest landmass to see if it is large enough.
		if iNumBiggestAreaTiles >= iNumTotalLandTiles * 0.71 and iNumBiggestAreaTiles < iNumTotalLandTiles * 0.78 then
			done = true;
			iBiggestID = biggest_area:GetID();
		end
		iAttempts = iAttempts + 1;
		
		-- Printout for debug use only
		-- print("-"); print("--- Continents landmass generation, Attempt#", iAttempts, "---");
		-- print("- This attempt successful: ", done);
		-- print("- Total Land Plots in world:", iNumTotalLandTiles);
		-- print("- Land Plots belonging to biggest landmass:", iNumBiggestAreaTiles);
		-- print("- Percentage of land belonging to biggest: ", 100 * iNumBiggestAreaTiles / iNumTotalLandTiles);
		-- print("- Continent Grain for this attempt: ", grain_dice);
		-- print("- Rift Grain for this attempt: ", rift_dice);
		-- print("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
		-- print(".");
	end

	-- Generate West Large Islands	
	islands = plotTypes;
	local args = {};
	args.iWaterPercent = 77 + water_percent_modifier;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 5;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 5;
	args.iRegionFracYExp = 5;
	args.adjustment = adjustment;
	plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
	islands = plotTypes;

	-- Generate West Medium Islands
	local args = {};	
	islands = plotTypes;
	args.iWaterPercent = 80 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW / 2 - iMediumIslandValue * 2);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = iMediumIslandValue;
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 6;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 5;
	args.iRegionFracYExp = 4;
	args.adjustment = world;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

	-- Generate West Tiny Islands
	islands = plotTypes;
	local args = {};	
	args.iWaterPercent = 88 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW / 2 - iTinyIslandValue * 2);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = iTinyIslandValue;
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 5;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 5;
	args.iRegionFracYExp = 5;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
	
	-- Generate East Large Islands	
	islands = plotTypes;
	local args = {};
	args.iWaterPercent = 79 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW / 2 - iLargeIslandValue * 2);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = math.floor(iCenterMeridian + g_iW / iLargeIslandShift);
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 5;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 6;
	args.iRegionFracYExp = 5;
	args.adjustment = adjustment;
	plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
	islands = plotTypes;

	-- Generate East Medium Islands
	local args = {};	
	islands = plotTypes;
	args.iWaterPercent = 83 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = math.floor(0);
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 5;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 6;
	args.iRegionFracYExp = 4;
	args.adjustment = world;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
	islands = plotTypes;

	-- Generate East Tiny Islands
	islands = plotTypes;
	local args = {};	
	args.iWaterPercent = 88 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW / 2 - iTinyIslandValue * 2);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = math.floor(iCenterMeridian + g_iW / iTinyIslandShift);
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 5;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 7;
	args.iRegionFracYExp = 6;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

	-- Land and water are set. Apply hills and mountains.
	local args = {};
	args.world_age = world_age + 1;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 3;
	args.blendFract = 1;
	args.extra_mountains = 1;
	mountainRatio = 10 + world_age * 2;
	plotTypes = ApplyTectonics(args, plotTypes);
	plotTypes = AddLonelyMountains(plotTypes, mountainRatio);
	
	return plotTypes;
end
-------------------------------------------------------------------------------
function GenerateCenterRift(plotTypes)
	-- Causes a rift to break apart and separate any landmasses overlaying the map center.
	-- Rift runs south to north ala the Atlantic Ocean.
	-- Any land plots in the first or last map columns will be lost, overwritten.
	-- This rift function is hex-dependent. It would have to be adapted to work with squares tiles.
	-- Center rift not recommended for non-oceanic worlds or with continent grains higher than 2.
	-- 
	-- First determine the rift "lean". 0 = Starts west, leans east. 1 = Starts east, leans west.
	local riftLean = TerrainBuilder.GetRandomNumber(2, "FractalWorld Center Rift Lean - Lua");
	
	-- Set up tables recording the rift line and the edge plots to each side of the rift line.
	local riftLine = {};
	local westOfRift = {};
	local eastOfRift = {};
	-- Determine minimum and maximum length of line segments for each possible direction.
	local primaryMaxLength = math.max(1, math.floor(g_iH / 8));
	local secondaryMaxLength = math.max(1, math.floor(g_iH / 11));
	local tertiaryMaxLength = math.max(1, math.floor(g_iH / 14));
	
	-- Set rift line starting plot and direction.
	local startDistanceFromCenterColumn = math.floor(g_iH / 8);
	if riftLean == 0 then
		startDistanceFromCenterColumn = -(startDistanceFromCenterColumn);
	end
	local startX = math.floor(g_iW / 2) + startDistanceFromCenterColumn;
	local startY = 0;
	local startingDirection = DirectionTypes.DIRECTION_NORTHWEST;
	if riftLean == 0 then
		startingDirection = DirectionTypes.DIRECTION_NORTHEAST;
	end
	-- Set rift X boundary.
	local riftXBoundary = math.floor(g_iW / 2) - startDistanceFromCenterColumn;
	
	-- Rift line is defined by a series of line segments traveling in one of three directions.
	-- East-leaning lines move NE primarily, NW secondarily, and E tertiary.
	-- West-leaning lines move NW primarily, NE secondarily, and W tertiary.
	-- Any E or W segments cause a wider gap on that row, requiring independent storage of data regarding west or east of rift.
	--
	-- Key variables need to be defined here so they persist outside of the various loops that follow.
	-- This requires that the starting plot be processed outside of those loops.
	local currentDirection = startingDirection;
	local currentX = startX;
	local currentY = startY;
	table.insert(riftLine, {currentX, currentY});
	-- Record west and east of the rift for this row.
	local rowIndex = currentY + 1;
	westOfRift[rowIndex] = currentX - 1;
	eastOfRift[rowIndex] = currentX + 1;
	-- Set this rift plot as type Ocean.
	local plotIndex = currentX + 1; -- Lua arrays starting at 1 sure makes for a lot of extra work and chances for bugs.
	plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN; -- Tiles crossed by the rift all turn in to water.
	
	-- Generate the rift line.
	if riftLean == 0 then -- Leans east
		while currentY < g_iH - 1 do
			-- Generate a line segment
			local nextDirection = 0;

			if currentDirection == DirectionTypes.DIRECTION_EAST then
				local segmentLength = TerrainBuilder.GetRandomNumber(tertiaryMaxLength + 1, "FractalWorld Center Rift Segment Length - Lua");
				-- Choose next direction
				if currentX >= riftXBoundary then -- Gone as far east as allowed, must turn back west.
					nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
				else
					local dice = TerrainBuilder.GetRandomNumber(3, "FractalWorld Center Rift Direction - Lua");
					if dice == 1 then
						nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
					else
						nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
					end
				end
				-- Process the line segment
				local plotsToDo = segmentLength;
				while plotsToDo > 0 do
					currentX = currentX + 1; -- Moving east, no change to Y.
					rowIndex = currentY;
					-- westOfRift[rowIndex] does not change.
					eastOfRift[rowIndex] = currentX + 1;
					plotIndex = currentY * g_iW + currentX + 1;
					plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
					plotsToDo = plotsToDo - 1;
				end

			elseif currentDirection == DirectionTypes.DIRECTION_NORTHWEST then
				local segmentLength = TerrainBuilder.GetRandomNumber(secondaryMaxLength + 1, "FractalWorld Center Rift Segment Length - Lua");
				-- Choose next direction
				if currentX >= riftXBoundary then -- Gone as far east as allowed, must turn back west.
					nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
				else
					local dice = TerrainBuilder.GetRandomNumber(4, "FractalWorld Center Rift Direction - Lua");
					if dice == 2 then
						nextDirection = DirectionTypes.DIRECTION_EAST;
					else
						nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
					end
				end
				-- Process the line segment
				local plotsToDo = segmentLength;
				while plotsToDo > 0 and currentY < g_iH - 1 do
					local nextPlot = Map.GetAdjacentPlot(currentX, currentY, currentDirection);
					currentX = nextPlot:GetX();
					currentY = currentY + 1;
					rowIndex = currentY;
					westOfRift[rowIndex] = currentX - 1;
					eastOfRift[rowIndex] = currentX + 1;
					plotIndex = currentY * g_iW + currentX + 1;
					plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
					plotsToDo = plotsToDo - 1;
				end
				
			else -- NORTHEAST
				local segmentLength = TerrainBuilder.GetRandomNumber(primaryMaxLength + 1, "FractalWorld Center Rift Segment Length - Lua");
				-- Choose next direction
				if currentX >= riftXBoundary then -- Gone as far east as allowed, must turn back west.
					nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
				else
					local dice = TerrainBuilder.GetRandomNumber(2, "FractalWorld Center Rift Direction - Lua");
					if dice == 1 and currentY > g_iH * 0.28 then
						nextDirection = DirectionTypes.DIRECTION_EAST;
					else
						nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
					end
				end
				-- Process the line segment
				local plotsToDo = segmentLength;
				while plotsToDo > 0 and currentY < g_iH - 1 do
					local nextPlot = Map.GetAdjacentPlot(currentX, currentY, currentDirection);
					currentX = nextPlot:GetX();
					currentY = currentY + 1;
					rowIndex = currentY;
					westOfRift[rowIndex] = currentX - 1;
					eastOfRift[rowIndex] = currentX + 1;
					plotIndex = currentY * g_iW + currentX + 1;
					plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
					plotsToDo = plotsToDo - 1;
				end
			end
			
			-- Line segment is done, set next direction.
			currentDirection = nextDirection;
		end

	else -- Leans west
		while currentY < g_iH - 1 do
			-- Generate a line segment
			local nextDirection = 0;

			if currentDirection == DirectionTypes.DIRECTION_WEST then
				local segmentLength = TerrainBuilder.GetRandomNumber(tertiaryMaxLength + 1, "FractalWorld Center Rift Segment Length - Lua");
				-- Choose next direction
				if currentX <= riftXBoundary then -- Gone as far west as allowed, must turn back east.
					nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
				else
					local dice = TerrainBuilder.GetRandomNumber(3, "FractalWorld Center Rift Direction - Lua");
					if dice == 1 then
						nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
					else
						nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
					end
				end
				-- Process the line segment
				local plotsToDo = segmentLength;
				while plotsToDo > 0 do
					currentX = currentX - 1; -- Moving west, no change to Y.
					rowIndex = currentY;
					westOfRift[rowIndex] = currentX - 1;
					-- eastOfRift[rowIndex] does not change.
					plotIndex = currentY * g_iW + currentX + 1;
					plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
					plotsToDo = plotsToDo - 1;
				end

			elseif currentDirection == DirectionTypes.DIRECTION_NORTHEAST then
				local segmentLength = TerrainBuilder.GetRandomNumber(secondaryMaxLength + 1, "FractalWorld Center Rift Segment Length - Lua");
				-- Choose next direction
				if currentX <= riftXBoundary then -- Gone as far west as allowed, must turn back east.
					nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
				else
					local dice = TerrainBuilder.GetRandomNumber(4, "FractalWorld Center Rift Direction - Lua");
					if dice == 2 then
						nextDirection = DirectionTypes.DIRECTION_WEST;
					else
						nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
					end
				end
				-- Process the line segment
				local plotsToDo = segmentLength;
				while plotsToDo > 0 and currentY < g_iH - 1 do
					local nextPlot = Map.GetAdjacentPlot(currentX, currentY, currentDirection);
					currentX = nextPlot:GetX();
					currentY = currentY + 1;
					rowIndex = currentY;
					westOfRift[rowIndex] = currentX - 1;
					eastOfRift[rowIndex] = currentX + 1;
					plotIndex = currentY * g_iW + currentX + 1;
					plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
					plotsToDo = plotsToDo - 1;
				end
				
			else -- NORTHWEST
				local segmentLength = TerrainBuilder.GetRandomNumber(primaryMaxLength + 1, "FractalWorld Center Rift Segment Length - Lua");
				-- Choose next direction
				if currentX <= riftXBoundary then -- Gone as far west as allowed, must turn back east.
					nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
				else
					local dice = TerrainBuilder.GetRandomNumber(2, "FractalWorld Center Rift Direction - Lua");
					if dice == 1 and currentY > g_iH * 0.28 then
						nextDirection = DirectionTypes.DIRECTION_WEST;
					else
						nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
					end
				end
				-- Process the line segment
				local plotsToDo = segmentLength;
				while plotsToDo > 0 and currentY < g_iH - 1 do
					local nextPlot = Map.GetAdjacentPlot(currentX, currentY, currentDirection);
					currentX = nextPlot:GetX();
					currentY = currentY + 1;
					rowIndex = currentY;
					westOfRift[rowIndex] = currentX - 1;
					eastOfRift[rowIndex] = currentX + 1;
					plotIndex = currentY * g_iW + currentX + 1;
					plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
					plotsToDo = plotsToDo - 1;
				end
			end
			
			-- Line segment is done, set next direction.
			currentDirection = nextDirection;
		end
	end
	-- Process the final plot in the rift.
	westOfRift[g_iH] = currentX - 1;
	eastOfRift[g_iH] = currentX + 1;
	plotIndex = (g_iH - 1) * g_iW + currentX + 1;
	plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;

	-- Now force the rift to widen, causing land on either side of the rift to drift apart.
	local horizontalDrift = 3;
	local verticalDrift = 2;
	--
	if riftLean == 0 then
		-- Process Western side from top down.
		for y = g_iH - 1 - verticalDrift, 0, -1 do
			local thisRowX = westOfRift[y+1];
			for x = horizontalDrift, thisRowX do
				local sourcePlotIndex = y * g_iW + x + 1;
				local destPlotIndex = (y + verticalDrift) * g_iW + (x - horizontalDrift) + 1;
				plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
			end
		end
		-- Process Eastern side from bottom up.
		for y = verticalDrift, g_iH - 1 do
			local thisRowX = eastOfRift[y+1];
			for x = thisRowX, g_iW - horizontalDrift - 1 do
				local sourcePlotIndex = y * g_iW + x + 1;
				local destPlotIndex = (y - verticalDrift) * g_iW + (x + horizontalDrift) + 1;
				plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
			end
		end
		-- Clean up remainder of tiles (by turning them all to Ocean).
		-- Clean up bottom left.
		for y = 0, verticalDrift - 1 do
			local thisRowX = westOfRift[y+1];
			for x = 0, thisRowX do
				local plotIndex = y * g_iW + x + 1;
				plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
			end
		end
		-- Clean up top right.
		for y = g_iH - verticalDrift, g_iH - 1 do
			local thisRowX = eastOfRift[y+1];
			for x = thisRowX, g_iW - 1 do
				local plotIndex = y * g_iW + x + 1;
				plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
			end
		end
		-- Clean up the rift.
		for y = verticalDrift, g_iH - 1 - verticalDrift do
			local westX = westOfRift[y-verticalDrift+1] - horizontalDrift + 1;
			local eastX = eastOfRift[y+verticalDrift+1] + horizontalDrift - 1;
			for x = westX, eastX do
				local plotIndex = y * g_iW + x + 1;
				plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
			end
		end

	else -- riftLean = 1
		-- Process Western side from bottom up.
		for y = verticalDrift, g_iH - 1 do
			local thisRowX = westOfRift[y+1];
			for x = horizontalDrift, thisRowX do
				local sourcePlotIndex = y * g_iW + x + 1;
				local destPlotIndex = (y - verticalDrift) * g_iW + (x - horizontalDrift) + 1;
				plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
			end
		end
		-- Process Eastern side from top down.
		for y = g_iH - 1 - verticalDrift, 0, -1 do
			local thisRowX = eastOfRift[y+1];
			for x = thisRowX, g_iW - horizontalDrift - 1 do
				local sourcePlotIndex = y * g_iW + x + 1;
				local destPlotIndex = (y + verticalDrift) * g_iW + (x + horizontalDrift) + 1;
				plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
			end
		end
		-- Clean up remainder of tiles (by turning them all to Ocean).
		-- Clean up top left.
		for y = g_iH - verticalDrift, g_iH - 1 do
			local thisRowX = westOfRift[y+1];
			for x = 0, thisRowX do
				local plotIndex = y * g_iW + x + 1;
				plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
			end
		end
		-- Clean up bottom right.
		for y = 0, verticalDrift - 1 do
			local thisRowX = eastOfRift[y+1];
			for x = thisRowX, g_iW - 1 do
				local plotIndex = y * g_iW + x + 1;
				plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
			end
		end
		-- Clean up the rift.
		for y = verticalDrift, g_iH - 1 - verticalDrift do
			local westX = westOfRift[y+verticalDrift+1] - horizontalDrift + 1;
			local eastX = eastOfRift[y-verticalDrift+1] + horizontalDrift - 1;
			for x = westX, eastX do
				local plotIndex = y * g_iW + x + 1;
				plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
			end
		end
	end


end
-------------------------------------------------------------------------------
function InitFractal(args)

	if(args == nil) then args = {}; end

	local continent_grain = args.continent_grain or 2;
	local rift_grain = args.rift_grain or -1; -- Default no rifts. Set grain to between 1 and 3 to add rifts. - Bob
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
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 6, 5);
		g_continentsFrac = Fractal.CreateRifts(g_iW, g_iH, continent_grain, fracFlags, riftsFrac, 6, 5);
	else
		g_continentsFrac = Fractal.Create(g_iW, g_iH, continent_grain, fracFlags, 6, 5);	
	end

	-- Use Brian's tectonics method to weave ridgelines in to the continental fractal.
	-- Without fractal variation, the tectonics come out too regular.
	--
	--[[ "The principle of the RidgeBuilder code is a modified Voronoi diagram. I 
	added some minor randomness and the slope might be a little tricky. It was 
	intended as a 'whole world' modifier to the fractal class. You can modify 
	the number of plates, but that is about it." ]]-- Brian Wade - May 23, 2009
	--
	local MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.MapSizeType] = row.PlateValue;
	end
	local sizekey = Map.GetMapSize();

	local numPlates = MapSizeTypes[sizekey] or 4

	-- Blend a bit of ridge into the fractal.
	-- This will do things like roughen the coastlines and build inland seas. - Brian

	g_continentsFrac:BuildRidges(numPlates, {}, 1, 2);
end


-------------------------------------------------------------------------------
function GenerateFractalLayerWithoutHills (args, plotTypes)
	--[[ This function is intended to be paired with ApplyTectonics. If all the hills and
	mountains plots are going to be overwritten by the tectonics results, then why waste
	calculations generating them? ]]--
	local args = args or {};
	local plotTypes2 = {};

	-- Handle args or assign defaults.
	local iWaterPercent = args.iWaterPercent or 40;
	local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
	local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
	local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
	local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
	local iRegionGrain = args.iRegionGrain or 5;
	local iRegionPlotFlags = args.iRegionPlotFlags or g_iFlags;
	local iRegionTerrainFlags = g_iFlags; -- Removed from args list.
	local iRegionFracXExp = args.iRegionFracXExp or 5;
	local iRegionFracYExp = args.iRegionFracYExp or 5;
	local iRiftGrain = args.iRiftGrain or -1;
	local bShift = args.bShift or false;
	local iBufferAdustment = args.iBufferAdustment or 0;
	
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
	local iBuffer = math.floor(g_iH/(10 + iBufferAdustment));
	for x = 0, iRegionWidth - 1, 1 do
		for y = 0, iRegionHeight - 1, 1 do
			local i = y * iRegionWidth + x + 1; -- Lua arrays start at 1.
			local val = regionContinentsFrac:GetHeight(x,y);
			local iDistance = Map.GetPlotDistance(x, y, g_xCenter, g_yCenter);
			if (val <= iWaterThreshold or Adjacent(i) == true or iDistance <= iBuffer) then
				--do nothing
			else
				plotTypes2[i] = g_PLOT_TYPE_LAND;
			end
		end
	end

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

function AddFeatures()
	print("Adding Features");

	-- Get Rainfall setting input by user.
	local rainfall = MapConfiguration.GetValue("rainfall");
	if rainfall == 4 then
		rainfall = 1 + TerrainBuilder.GetRandomNumber(3, "Random Rainfall - Lua");
	end
	
	local args = {rainfall = rainfall, iMarshPercent = 2, iSwampPercent = 2, iJunglePercent = 22, iForestPercent = 13} 
	local featuregen = FeatureGenerator.Create(args);

	featuregen:AddFeatures();
end

-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------------------
function AddLakes(largeLakes)

	print("Map Generation - Adding Lakes");
	largeLakes = largeLakes or 0;

	local numLakesAdded = 0;
	local numLargeLakesAdded = 0;

	local lakePlotRand =  math.floor(GlobalParameters.LAKE_PLOT_RANDOM or 25 / 4);
	local iW, iH = Map.GetGridSize();

	for i = 0, (iW * iH) - 1, 1 do
		plot = Map.GetPlotByIndex(i);
		if(plot) then
			if (plot:IsWater() == false) then
				if (plot:IsCoastalLand() == false) then
					if (plot:IsRiver() == false) then
						if (AdjacentToNaturalWonder(plot) == false) then
							local r = TerrainBuilder.GetRandomNumber(lakePlotRand, "MapGenerator AddLakes");
							if r == 0 then
								numLakesAdded = numLakesAdded + 1;
								if(largeLakes > numLargeLakesAdded) then
									local bLakes = AddMoreLake(plot);
									if(bLakes == true) then
										numLargeLakesAdded = numLargeLakesAdded + 1;
									end
								end

								TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_COAST);
							end
						end
					end
				end
			end
		end
	end
	
	-- this is a minimalist update because lakes have been added
	if numLakesAdded > 0 then
		print(tostring(numLakesAdded).." lakes added")
		AreaBuilder.Recalculate();
	end
end

-------------------------------------------------------------------------------------------


function AssignStartingPlots:__MajorCivBuffer(plot)
    -- Checks to see if there are major civs in the given distance for this major civ

    local iMaxStart = 10 or 13;

    --if (PlayerConfigurations[0]:GetCivilizationTypeName() == "CIVILIZATION_CANADA") or (PlayerConfigurations[0]:GetCivilizationTypeName() == "CIVILIZATION_RUSSIA")then
    --    local iMaxStart = GlobalParameters.START_DISTANCE_MAJOR_CIVILIZATION or 9;
    --end
    iMaxStart = iMaxStart - 1 or 3;

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

    local iMaxStart = 6 or 16;

    --if (PlayerConfigurations[0]:GetCivilizationTypeName() == "CIVILIZATION_CANADA") or (PlayerConfigurations[0]:GetCivilizationTypeName() == "CIVILIZATION_RUSSIA")then
    --    local iMaxStart = GlobalParameters.START_DISTANCE_MINOR_MAJOR_CIVILIZATION -1 or 13;
    --end
    local iSourceIndex = plot:GetIndex();
    
    if(self.waterMap == true) then
        iMaxStart = iMaxStart - 1 or 2;
    end
    
    for i, majorPlot in ipairs(self.majorCopy) do
        if(Map.GetPlotDistance(iSourceIndex, majorPlot:GetIndex()) <= iMaxStart) then
            return false;
        end
    end 

    return true;
end

------------------------------------------------------------------------------