------------------------------------------------------------------------------
--	FILE:	 Wet_Lakes2.lua
--	AUTHOR:  
--	PURPOSE: Base game script - Produces widely varied islands.
------------------------------------------------------------------------------
--	Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------
--坦博帕塔丛林
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
local world_age_new = 4;

-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Wet_Lakes2 Map");
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
	terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature, false, -9, 0, 0.05, 0.12);
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
	AddRivers(2);
	
	-- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
	local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 6.5 );
	AddLakes(numLargeLakes);

	AddFeatures();
	
	print("Adding cliffs");
	AddCliffs(plotTypes, terrainTypes);
	
	local args = {
		numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
	};
	local nwGen = NaturalWonderGenerator.Create(args);

	AddFeaturesFromContinents();
	MarkCoastalLowlands(2);
	
--	for i = 0, (g_iW * g_iH) - 1, 1 do
--		pPlot = Map.GetPlotByIndex(i);
--		print ("i: plotType, terrainType, featureType: " .. tostring(i) .. ": " .. tostring(plotTypes[i]) .. ", " .. tostring(terrainTypes[i]) .. ", " .. tostring(pPlot:GetFeatureType(i)));
--	end
    AddVolcanicSoil();--火山土开局生成必要语句

	local resourcesConfig = MapConfiguration.GetValue("resources");
	local startConfig = MapConfiguration.GetValue("start");-- Get the start config
	local args = {
		iWaterLux = 3,
		iWaterBonus = 1.25, 
		resources = resourcesConfig,
		START_CONFIG = startConfig,	

		ExtraBonusGroupTwoMultiply = 1.5,							--增加的倍率
		ExtraBonusGroupTwo = {
		"RESOURCE_JNR_PEAT",		--泥炭
		"RESOURCE_RICE",			--大米
		"RESOURCE_OAK",				--橡木
		"RESOURCE_DEER"				--鹿
		},--增加的陆地加成资源,水资无效，奢侈战略无效

		ExtraBonusGroupOneMultiply = 1.3,							--增加的倍率
		ExtraBonusGroupOne = {	
		"MUSHROOMS",				--蘑菇
		"MUSHROOMS",				--额外蘑菇
		"MUSHROOMS",				--额外蘑菇
		"MUSHROOMS",				--额外蘑菇
		"MUSHROOMS",				--额外蘑菇
		"MUSHROOMS",				--额外蘑菇
		"RESOURCE_JNR_PEAT",		--额外泥炭
		"RESOURCE_RICE",			--额外大米
		"RESOURCE_RICE",			--额外大米
		"RESOURCE_LIMESTONE",		--白云石
		"RESOURCE_WHEAT",			--小麦
		"RESOURCE_BERRIES",			--浆果
		"RESOURCE_BERRIES",			--浆果
		"RESOURCE_TIN"				--锡矿
		},--增加的陆地加成资源,水资无效，奢侈战略无效

		FewerBonusGroupOneMultiply = 0.72,							--减少的倍率
		FewerBonusGroupOne = {	
			"RESOURCE_SUK_CAMEL",		--骆驼
			"RESOURCE_COPPER",			--铜矿
			"RESOURCE_STONE",			--安山岩
			"RESOURCE_SHEEP",			--羊
			"RESOURCE_BANANAS"			--香蕉
		},--减少的陆地加成资源,水资无效，奢侈战略无效

		FewerBonusGroupTwoMultiply = 0.62,							--减少的倍率
		FewerBonusGroupTwo = {	
			"RESOURCE_DLV_BISON",		--野牛
			"RESOURCE_HAM",				--火腿
			"RESOURCE_MAIZE",			--玉米
			"RESOURCE_TOMATO",			--番茄
			"RESOURCE_CATTLE"			--牛		
		},--减少的陆地加成资源,水资无效，奢侈战略无效
		HorsesMultiply =    0.7,	--调整马资源丰度
        IronMultiply =		0.7,	--调整铁资源丰度
        NiterMultiply =     1.0,	--调整硝石资源丰度
        CoalMultiply =      1.6,	--调整煤炭资源丰度
        OilMultiply =       2.0,	--调整石油资源丰度
        AluminumMultiply =  2.0,	--调整铝资源丰度
	};
	local resGen = ResourceGenerator.Create(args);
	print("Creating start plot database.");
	-- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
	
	local args = {
		MIN_MAJOR_CIV_FERTILITY = 101,
		MAX_MAJOR_CIV_FERTILITY = 156,
        MIN_MINOR_CIV_FERTILITY = 15, 
        MAX_MINOR_CIV_FERTILITY = 78,
		MIN_BARBARIAN_FERTILITY = 50,
        START_MIN_Y = 8,
        START_MAX_Y = 55,
        START_MIN_X = 5,
        START_MAX_X = 50,
        --WATER = true,
        LAND = true,
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
	local sea_level = 73;
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
	local iWaterShift1 = math.ceil(g_iH * 300 / 100);
	local iWaterHeight1 = g_iH - iWaterShift1 * 2;
	--local iWaterShift1 = 4;
	--local iWaterHeight1 = g_iH - iWaterShift1 * 2 +6;

	-- by changing iRegionFracXExp and iRegionFracYExp to control the shape of oceans.



			-- Generate Medium Lakes	
		local args = {};	
		args.iWaterPercent = 72 + water_percent_modifier;
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

		-- Generate huge Lakes		
		local args = {};	
		args.iWaterPercent = 78 + water_percent_modifier;
		args.iRegionWidth = math.ceil(g_iW);
		args.iRegionHeight = math.ceil(g_iH);
		args.iRegionWestX = math.floor(0);
		args.iRegionSouthY = math.floor(0);
		args.iRegionGrain = 4; 
		args.iRegionHillsGrain = 4;
		args.iRegionPlotFlags = g_iFlags;
		args.iRegionFracXExp = 7;
		args.iRegionFracYExp = 5;
		plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
		islands = plotTypes;
	
	
		-- Generate Medium Lakes		
		local args = {};	
		args.iWaterPercent = 76 + water_percent_modifier;
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
	
	
	

	
		-- Generate Tiny Lakes
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
		args.iRegionFracYExp = 5;
		plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);
	
		local args = {};
		args.world_age = world_age;
		args.iW = g_iW;
		args.iH = g_iH
		args.iFlags = g_iFlags;
		args.blendRidge = 3;
		-- args.blendFract = 5; -- original setting
		args.blendFract = 1;
		-- args.extra_mountains = 5; -- original setting
		args.extra_mountains = -2;
		-- mountainRatio = 8 + world_age * 3; -- original setting
		mountainRatio = 6 + world_age * 12; --further lower the mountainRation in order to generate less lonely mountains

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
	
	local args = {rainfall = rainfall, iMarshPercent = 16, iSwampPercent = 13, iJunglePercent = 31, iForestPercent = 15, iOasisPercent = 9}
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
	local iWaterPercent = args.iWaterPercent or 47;
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
			elseif (adjCount > 16 and adjCount < 30) then
			if (math.random(3,6) <= adjCount) then
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
function GenerateWaterLayer (args, plotTypes)
    -- This function is intended to allow adding seas to specific areas of large continents.
    local args = args or {};
    
    -- Handle args or assign defaults.
    local iWaterPercent = args.iWaterPercent or 41;
    local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
    local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
    local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
    local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
    local iRegionGrain = args.iRegionGrain or 5;
    local iRegionPlotFlags = args.iRegionPlotFlags or g_iFlags;
    local iRegionFracXExp = args.iRegionFracXExp or 5;
    local iRegionFracYExp = args.iRegionFracYExp or 5;
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
------------------------------------------------------------------------------
function FeatureGenerator:AddMarshAtPlot(plot, iX, iY)
	--Marsh Check. First see if it can place the feature.
	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_MARSH)) then
		if(math.ceil(self.iMarshCount * 100 / self.iNumLandPlots) <= self.iMarshMaxPercent) then
			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 400;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_MARSH);
				

			if (iAdjacent == 0 ) then
				iScore = iScore;
			elseif (iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 100;
			elseif (iAdjacent == 4) then
				iScore = iScore + 110;
			elseif (iAdjacent == 5) then
				iScore = iScore + 125;
			elseif (iAdjacent == 6) then
				iScore = iScore - 50;
			else
				iScore = iScore - 150;
			end
				
			if(TerrainBuilder.GetRandomNumber(600, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_MARSH);
				self.iMarshCount = self.iMarshCount + 1.1;

				return true;
			end
		end
	end

	return false;
end
------------------------------------------------------------------------------
function FeatureGenerator:AddSwampAtPlot(plot, iX, iY)
	--Swamp Check. First see if it can place the feature.
	
	local sSwamp				= "FEATURE_HD_SWAMP"
	if(GameInfo.Features[sSwamp] == nil)then
		return false;
	end
	local g_FEATURE_HD_SWAMP	= GameInfo.Features[sSwamp].Index
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_HD_SWAMP)) then
		if(math.ceil(self.iSwampCount * 100 / self.iNumLandPlots) <= self.iSwampMaxPercent) then
			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 400;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_HD_SWAMP);
				

			if (iAdjacent == 0 ) then
				iScore = iScore;
			elseif (iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 100;
			elseif (iAdjacent == 4) then
				iScore = iScore + 110;
			elseif (iAdjacent == 5) then
				iScore = iScore + 125;
			elseif (iAdjacent == 6) then
				iScore = iScore - 50;
			else
				iScore = iScore - 150;
			end
				
			if(TerrainBuilder.GetRandomNumber(600, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_HD_SWAMP);
				self.iSwampCount = self.iSwampCount + 1.1;

				return true;
			end
		end
	end

	return false;
end
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function MarkCoastalLowlands()

	print("Map Generation - Marking Coastal Lowlands");

	local numDesiredCoastalLowlandsPercentage = 75 or 45;

	scoredTiles = ScoreCoastalLowlandTiles();
	tilesToMark = math.floor((#scoredTiles * numDesiredCoastalLowlandsPercentage) / 100);
	
	if tilesToMark > 0 then
        table.sort (scoredTiles, function(a, b) return a.Score > b.Score; end);
		for tileIdx = 1, tilesToMark, 1 do
			local iElevation = 2;
			if (tileIdx <= tilesToMark / 3) then
				iElevation = 0;
			elseif (tileIdx <= (tilesToMark * 2) / 3) then
				iElevation = 1.6;
			end
			TerrainBuilder.AddCoastalLowland(scoredTiles[tileIdx].MapIndex, iElevation);
		end
		print(tostring(tilesToMark).." Coastal Lowland tiles added");
		print("  " .. tostring(GlobalParameters.CACAPULCOTE_CHANGE_PERCENT_COASTAL_LOWLANDS) .. "% of eligible coastal tiles");
	end
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

	local lakePlotRand =  math.floor(GlobalParameters.LAKE_PLOT_RANDOM or 8);
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
		end
	end
	
	-- this is a minimalist update because lakes have been added
	if numLakesAdded > 0 then
		print(tostring(numLakesAdded).." lakes added")
		AreaBuilder.Recalculate();
	end
end