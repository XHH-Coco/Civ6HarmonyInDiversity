------------------------------------------------------------------------------
--	FILE:	 Pangaea.lua
--	AUTHOR:  
--	PURPOSE: Base game script - Simulates a Pan-Earth Supercontinent.
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
local g_iNumTotalLandTiles = 0; 
local featureGen = nil;
local world_age_new = 5;
local world_age_normal = 3;
local world_age_old = 2;

-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Pangea Map");
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
	terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature);
	ApplyBaseTerrain(plotTypes, terrainTypes, g_iW, g_iH);

	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();
	TerrainBuilder.StampContinents();

	local iContinentBoundaryPlots = GetContinentBoundaryPlotCount(g_iW, g_iH);
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());
	AddTerrainFromContinents(plotTypes, terrainTypes, world_age, g_iW, g_iH, iContinentBoundaryPlots, true);

	AreaBuilder.Recalculate();

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers();
	
	-- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
	-- local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 1.5); -- original setting
	local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 4 + 30); 
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
	AddVolcanicSoil();--火山土开局生成必要语句
	resourcesConfig = MapConfiguration.GetValue("resources");
	local startConfig = MapConfiguration.GetValue("start");-- Get the start config
	local args = {
		iWaterLux = 3,	
		resources = resourcesConfig,
		START_CONFIG = startConfig,
	};
	local resGen = ResourceGenerator.Create(args);

	print("Creating start plot database.");
	
	-- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
	local args = {
        MIN_MAJOR_CIV_FERTILITY = 100,
        MAX_MAJOR_CIV_FERTILITY = 139,    
        MIN_MINOR_CIV_FERTILITY = 33, 
        MAX_MINOR_CIV_FERTILITY = 86, 
        MIN_BARBARIAN_FERTILITY = 50,
     	START_MIN_Y = 24,
        START_MAX_Y = 42,
        START_MIN_X = 34,
        START_MAX_X = 40,
		START_CONFIG = startConfig,
		--WATER = true,
	};
	local start_plot_database = AssignStartingPlots.Create(args)

	local GoodyGen = AddGoodies(g_iW, g_iH);
end

-------------------------------------------------------------------------------
function GeneratePlotTypes(world_age)
	print("Generating Plot Types");
	local plotTypes = {};

	local sea_level_low = 18;--非常大的陆地
	local sea_level_normal = 22;--非常大的陆地（相对）
	local sea_level_high = 55;--中型陆地（相对）
	-- BEGIN DL update sea level
	sea_level_low = 15
	sea_level_normal = 20
	sea_level_high = 45
	-- sea_level_low = 38
	-- sea_level_normal = 43
	-- sea_level_high = 48
	-- END
	local grain_amount = 3;
	local adjust_plates = 1.3;
	local shift_plot_types = true;
	local tectonic_islands = false;
	local hills_ridge_flags = g_iFlags;
	local peaks_ridge_flags = g_iFlags;
	local has_center_rift = false;

	--	local sea_level
    local sea_level = MapConfiguration.GetValue("sea_level");
	local water_percent;
	if sea_level == 1 then -- Low Sea Level
		water_percent = sea_level_low
	elseif sea_level == 2 then -- Normal Sea Level
		water_percent =sea_level_normal
	elseif sea_level == 3 then -- High Sea Level
		water_percent = sea_level_high
	else
		water_percent = TerrainBuilder.GetRandomNumber(sea_level_high - sea_level_low, "Random Sea Level - Lua") + sea_level_low + 1; 
	end

	-- Generate continental fractal layer and examine the largest landmass. Reject
	-- the result until the largest landmass occupies 84% or more of the total land.
	local done = false;
	local iAttempts = 0;
	local iWaterThreshold, biggest_area, iNumBiggestAreaTiles, iBiggestID;
	while done == false do
		local grain_dice = TerrainBuilder.GetRandomNumber(7, "Continental Grain roll - LUA Pangea");
		-- if grain_dice < 4 then -- original setting
		if grain_dice < 8 then
			grain_dice = 1;
		else
			grain_dice = 2;
		end
		local rift_dice = TerrainBuilder.GetRandomNumber(3, "Rift Grain roll - LUA Pangea");
		if rift_dice < 1 then
			rift_dice = -1;
		end
		
		g_continentsFrac = nil;
		InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
		iWaterThreshold = g_continentsFrac:GetHeight(water_percent);
		
		g_iNumTotalLandTiles = 0;
		for x = 0, g_iW - 1 do
			for y = 0, g_iH - 1 do
				local i = y * g_iW + x;
				local val = g_continentsFrac:GetHeight(x, y);
				local pPlot = Map.GetPlotByIndex(i);
				if(val <= iWaterThreshold) then
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  -- temporary setting so can calculate areas
				else
					plotTypes[i] = g_PLOT_TYPE_LAND;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
					g_iNumTotalLandTiles = g_iNumTotalLandTiles + 1;
				end
			end
		end
		
		AreaBuilder.Recalculate();
		local biggest_area = Areas.FindBiggestArea(false);
		iNumBiggestAreaTiles = biggest_area:GetPlotCount();
		
		-- Now test the biggest landmass to see if it is large enough.
		if iNumBiggestAreaTiles >= g_iNumTotalLandTiles * 0.84 then
			done = true;
			iBiggestID = biggest_area:GetID();
		end
		iAttempts = iAttempts + 1;
		
		-- Printout for debug use only
		print("-"); print("--- Pangea landmass generation, Attempt#", iAttempts, "---");
		print("- This attempt successful: ", done);
		print("- Total Land Plots in world:", g_iNumTotalLandTiles);
		print("- Land Plots belonging to biggest landmass:", iNumBiggestAreaTiles);
		print("- Percentage of land belonging to Pangaea: ", 100 * iNumBiggestAreaTiles / g_iNumTotalLandTiles);
		print("- Continent Grain for this attempt: ", grain_dice);
		print("- Rift Grain for this attempt: ", rift_dice);
		print("- WaterThreshold: ", iWaterThreshold);
		print("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
		-- print(".");
	end

	-- for x = 0, g_iW - 1 do
	-- 	local str = ''
	-- 	for y = 0, g_iH - 1 do
	-- 		local val = g_continentsFrac:GetHeight(x, y);
	-- 		str = str .. tostring(val) .. ' '
	-- 	end
	-- 	print(str)
	-- end




	local args = {};
	args.world_age = world_age;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 3;
	args.blendFract = 1;
	args.extra_mountains = -3;
	mountainRatio = 6 + world_age * 7;
	plotTypes = ApplyTectonics(args, plotTypes);
	plotTypes = AddLonelyMountains(plotTypes, mountainRatio);
	
	-- Now shift everything toward one of the poles, to reduce how much jungles tend to dominate this script.
	local shift_dice = TerrainBuilder.GetRandomNumber(2, "Shift direction - LUA Pangaea");
	local iStartRow, iNumRowsToShift;
	local bFoundPangaea, bDoShift = false, false;
	if shift_dice == 1 then
		-- Shift North
		for y = g_iH - 2, 1, -1 do
			for x = 0, g_iW - 1 do
				local i = y * g_iW + x;
				if plotTypes[i] == g_PLOT_TYPE_HILLS or plotTypes[i] == g_PLOT_TYPE_LAND then
					local plot = Map.GetPlot(x, y);
					local iAreaID = plot:GetArea();
					if iAreaID == iBiggestID then
						bFoundPangaea = true;
						iStartRow = y + 1;
						if iStartRow < iNumPlotsY - 4 then -- Enough rows of water space to do a shift.
							bDoShift = true;
						end
						break
					end
				end
			end
			-- Check to see if we've found the Pangaea.
			if bFoundPangaea == true then
				break
			end
		end
	else
		-- Shift South
		for y = 1, g_iH - 2 do
			for x = 0, g_iW- 1 do
				local i = y * g_iW + x;
				if plotTypes[i] == g_PLOT_TYPE_HILLS or plotTypes[i] == g_PLOT_TYPE_LAND then
					local plot = Map.GetPlot(x, y);
					local iAreaID = plot:GetArea();
					if iAreaID == iBiggestID then
						bFoundPangaea = true;
						iStartRow = y - 1;
						if iStartRow > 3 then -- Enough rows of water space to do a shift.
							bDoShift = true;
						end
						break
					end
				end
			end
			-- Check to see if we've found the Pangaea.
			if bFoundPangaea == true then
				break
			end
		end
	end
	if bDoShift == true then
		if shift_dice == 1 then -- Shift North
			local iRowsDifference = g_iH - iStartRow - 2;
			local iRowsInPlay = math.floor(iRowsDifference * 0.7);
			local iRowsBase = math.ceil(iRowsDifference * 0.3);
			local rows_dice = TerrainBuilder.GetRandomNumber(iRowsInPlay, "Number of Rows to Shift - LUA Pangaea");
			local iNumRows = math.min(iRowsDifference - 1, iRowsBase + rows_dice);
			local iNumEvenRows = 2 * math.floor(iNumRows / 2); -- MUST be an even number or we risk breaking a 1-tile isthmus and splitting the Pangaea.
			local iNumRowsToShift = math.max(2, iNumEvenRows);
			--print("-"); print("Shifting lands northward by this many plots: ", iNumRowsToShift); print("-");
			-- Process from top down.
			for y = (g_iH - 1) - iNumRowsToShift, 0, -1 do
				for x = 0, g_iW - 1 do
					local sourcePlotIndex = y * g_iW + x + 1;
					local destPlotIndex = (y + iNumRowsToShift) * g_iW + x + 1;
					plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
				end
			end
			for y = 0, iNumRowsToShift - 1 do
				for x = 0, g_iW - 1 do
					local i = y * g_iW + x + 1;
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
				end
			end
		else -- Shift South
			local iRowsDifference = iStartRow - 1;
			local iRowsInPlay = math.floor(iRowsDifference * 0.7);
			local iRowsBase = math.ceil(iRowsDifference * 0.3);
			local rows_dice = TerrainBuilder.GetRandomNumber(iRowsInPlay, "Number of Rows to Shift - LUA Pangaea");
			local iNumRows = math.min(iRowsDifference - 1, iRowsBase + rows_dice);
			local iNumEvenRows = 2 * math.floor(iNumRows / 2); -- MUST be an even number or we risk breaking a 1-tile isthmus and splitting the Pangaea.
			local iNumRowsToShift = math.max(2, iNumEvenRows);
			--print("-"); print("Shifting lands southward by this many plots: ", iNumRowsToShift); print("-");
			-- Process from bottom up.
			for y = 0, (g_iH - 1) - iNumRowsToShift do
				for x = 0, g_iW - 1 do
					local sourcePlotIndex = (y + iNumRowsToShift) * g_iW + x + 1;
					local destPlotIndex = y * g_iW + x + 1;
					plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
				end
			end
			for y = g_iH - iNumRowsToShift, g_iH - 1 do
				for x = 0, g_iW - 1 do
					local i = y * g_iW + x + 1;
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
				end
			end
		end
	end

	return plotTypes;
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

	-- HD update: remove this convertion
	--g_continentsFrac:BuildRidges(numPlates, {}, 1,2);
end
-------------------------------------------------------------------------------
function AddFeatures()
	print("Adding Features");

	-- Get Rainfall setting input by user.
	local rainfall = MapConfiguration.GetValue("rainfall");
	if rainfall == 4 then
		rainfall = 1 + TerrainBuilder.GetRandomNumber(3, "Random Rainfall - Lua");
	end
	
	local args = {rainfall = rainfall, iMarshPercent = 5, iSwampPercent = 4, iJunglePercent = 36, iForestPercent = 24} 
	--茂盛的森林植被，可创造更多锤足够的出生点，因此，城邦出生点下限也要适当降低才易扔到角落；主要文明出生点需要更高的下限和更高的上限以获得高级的出生点。
	featuregen = FeatureGenerator.Create(args);
	featuregen:AddFeatures(true, true);  --second parameter is whether or not rivers start inland);
end
-------------------------------------------------------------------------------
function AddFeaturesFromContinents()
	print("Adding Features from Continents");

	featuregen:AddFeaturesFromContinents();
end
-----------------------------------------------------------------------------

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