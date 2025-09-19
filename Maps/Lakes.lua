------------------------------------------------------------------------------
--	FILE:	 Lakes.lua
--	AUTHOR:  
--	PURPOSE: Base game script - Produces widely varied islands.
------------------------------------------------------------------------------
--	Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
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
local world_age_old = 2;
local world_age_normal = 3;
local world_age_new = 5;

-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Lakes Map");
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
		world_age = 1 + TerrainBuilder.GetRandomNumber(3, "Random World Age - Lua");
	end

	plotTypes = GeneratePlotTypes(world_age);
	-- terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, false, temperature);
	terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature); -- Remove Coastal Mountains.
	ApplyBaseTerrain(plotTypes, terrainTypes, g_iW, g_iH);
	
	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();
	TerrainBuilder.StampContinents();

	local iContinentBoundaryPlots = GetContinentBoundaryPlotCount(g_iW, g_iH);
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());
	AddTerrainFromContinents(plotTypes, terrainTypes, world_age, g_iW, g_iH, iContinentBoundaryPlots, true); -- Remove Coastal Mountains.

	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();

	print ("Num Mountains: " .. tostring(GetMountainCount(g_iW, g_iH)));

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers();
	
	-- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
	local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 4 + 28);
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
	
--	for i = 0, (g_iW * g_iH) - 1, 1 do
--		pPlot = Map.GetPlotByIndex(i);
--		print ("i: plotType, terrainType, featureType: " .. tostring(i) .. ": " .. tostring(plotTypes[i]) .. ", " .. tostring(terrainTypes[i]) .. ", " .. tostring(pPlot:GetFeatureType(i)));
--	end
    AddVolcanicSoil();--火山土开局生成必要语句
	local resourcesConfig = MapConfiguration.GetValue("resources");
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
		MIN_MAJOR_CIV_FERTILITY = 101,
		MAX_MAJOR_CIV_FERTILITY = 141,
        MIN_MINOR_CIV_FERTILITY = 41, 
        MAX_MINOR_CIV_FERTILITY = 88,
		MIN_BARBARIAN_FERTILITY = 50,
        START_MIN_Y = 21,
        START_MAX_Y = 44,
        START_MIN_X = 30,
        START_MAX_X = 40,
		START_CONFIG = startConfig,
	};
	local start_plot_database = AssignStartingPlots.Create(args)

	local GoodyGen = AddGoodies(g_iW, g_iH);
end

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

	for x = 0, g_iW - 1 do
		for y = 0, g_iH - 1 do
			local index = (y * g_iW) + x + 1; -- Lua Array starts at 1
			plotTypes[index] = g_PLOT_TYPE_OCEAN;
		end
	end

	--	local sea_level
    local sea_level = MapConfiguration.GetValue("sea_level");
	if sea_level == 1 then -- Low Sea Level
		water_percent_modifier = 4
	elseif sea_level == 2 then -- Normal Sea Level
		water_percent_modifier = 0;
	elseif sea_level == 3 then -- High Sea Level
		water_percent_modifier = -4;
	else
		water_percent_modifier = TerrainBuilder.GetRandomNumber(9, "Random Sea Level - Lua") - 4;
	end

	local iWaterShift1 = math.ceil(g_iH * 27 / 100);
	local iWaterHeight1 = g_iH - iWaterShift1 * 2;

	-- by changing iRegionFracXExp and iRegionFracYExp to control the shape of oceans.



		-- Generate huge Lakes		
	local args = {};	
	args.iWaterPercent = 68 + water_percent_modifier;
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


	-- Generate Medium Lakes		
	local args = {};	
	args.iWaterPercent = 75 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = math.floor(0);
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 4;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 6;
	args.iRegionFracYExp = 5;
	plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
	islands = plotTypes;



	-- Generate Medium Lakes	
	local args = {};	
	args.iWaterPercent = 88 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = math.floor(0);
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 5;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 5;
	args.iRegionFracYExp = 6;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
	islands = plotTypes;

	-- Generate Tiny Lakes
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
	args.iRegionFracYExp = 6;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

	local args = {};
	args.world_age = world_age;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 5;
	-- args.blendFract = 5; -- original setting
	args.blendFract = 1;
	-- args.extra_mountains = 5; -- original setting
	args.extra_mountains = -1;
	-- mountainRatio = 8 + world_age * 3; -- original setting
	mountainRatio = 8 + world_age * 6;

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
-------------------------------------------------------------------------------
function AddFeaturesFromContinents()
	print("Adding Features from Continents");

	featuregen:AddFeaturesFromContinents();
end


-------------------------------------------------------------------------------
function GenerateFractalLayerWithoutHills (args, plotTypes)
	--[[ This function is intended to be paired with ApplyTectonics. If all the hills and
	mountains plots are going to be overwritten by the tectonics results, then why waste
	calculations generating them? ]]--
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
	local iRegionFracXExp = args.iRegionFracXExp or 5;
	local iRegionFracYExp = args.iRegionFracYExp or 6;
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
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 4, 3);--改变了大陆视角大陆的分割形状以保护冻土文明可以出生到冻土边缘
		regionContinentsFrac = Fractal.CreateRifts(g_iW, g_iH, iRegionGrain, iRegionPlotFlags, riftsFrac, iRegionFracXExp, iRegionFracYExp);
	else
		regionContinentsFrac = Fractal.Create(g_iW, g_iH, iRegionGrain, iRegionPlotFlags, iRegionFracXExp, iRegionFracYExp);	
	end
	--print("Initialized main fractal");
	local iWaterThreshold = regionContinentsFrac:GetHeight(iWaterPercent);

	-- Loop through the region's plots
	-- remove ocean at north and south pole
	local half_height = math.floor(iRegionHeight/2);
	local half_width = math.floor(iRegionWidth/2);
	for x = 0, iRegionWidth-1,1 do
		local i = x + 1;
		plotTypes2[i] = g_PLOT_TYPE_LAND;
		i = (iRegionHeight-1) * iRegionWidth + x + 1;
		plotTypes2[i] = g_PLOT_TYPE_LAND;
	end
	for y = 0, iRegionHeight - 1, 1 do
		for x = 0, iRegionWidth - 1, 1 do
			-- adjust the order of looping over the map, might relieve the stripe ocean problem.
			local dir_y = y%2;
			local dir_x = x%2;
			local i;
			local loc_x=x;
			local loc_y=y;
			
			if (dir_y == 1) then
				loc_y = (y-1)/2+half_height;
			else
				loc_y = y/2;
			end
			
			if (dir_x == 1) then
				loc_x = (x-1)/2+half_width;
			else
				loc_x = x/2;
			end
			
			i = loc_y * iRegionWidth + loc_x + 1;
			local val = regionContinentsFrac:GetHeight(loc_x,loc_y);
			
			local adjCount = AdjacentCount(i);
			if (val >= iWaterThreshold) then
				--do nothing
			elseif (adjCount == 7) then
				--do nothing
			-- by changing oceans adjacent to lots of land into land, might be able to relieve the stripe ocean problem.
			elseif (adjCount > 1 and adjCount < 9) then
				if (math.random(1,2) <= adjCount) then
					plotTypes2[i] = g_PLOT_TYPE_LAND;
				end
			elseif (adjCount == 0) then
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

function AdjacentCount(index)
	aIslands = islands;
	index = index -1;

	if(aIslands == nil) then
		return 0;
	end
	
	if(index < 0) then
		return 0;
	end

	local plot = Map.GetPlotByIndex(index);
	if(aIslands[index] ~= nil and aIslands[index] == g_PLOT_TYPE_LAND) then
		return 7;
	end

	local adjCount = 0;
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
		if(adjacentPlot ~= nil) then
			local newIndex = adjacentPlot:GetIndex();
			if(aIslands  ~= nil and aIslands[newIndex] == g_PLOT_TYPE_LAND) then
				adjCount = adjCount+1;
			end
		end
	end

	return adjCount;
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
			if (plot:IsMountain() == false) then
			if (plot:IsWater() == false) then
				if (plot:IsCoastalLand() == false) then
					if (plot:IsRiver() == false) then
						if (AdjacentToNaturalWonder(plot) == false) then
							local iX = plot:GetX();
							local iY = plot:GetY();
							if (GetNumberAdjacentLakes(iX,iY)==0 or GetNumberAdjacentMountains(iX,iY)<2) then
							local r = TerrainBuilder.GetRandomNumber(lakePlotRand, "MapGenerator AddLakes");
							if r == 0 then
								numLakesAdded = numLakesAdded + 1;
								if(largeLakes > numLargeLakesAdded) then
									local bLakes = AddMoreLake(plot);
									if(bLakes == true) then
										numLargeLakesAdded = numLargeLakesAdded + 1.42;
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
		end
	end
	
	-- this is a minimalist update because lakes have been added
	if numLakesAdded > 0 then
		print(tostring(numLakesAdded).." lakes added")
		AreaBuilder.Recalculate();
	end
end