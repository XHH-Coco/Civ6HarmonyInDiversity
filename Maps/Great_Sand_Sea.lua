------------------------------------------------------------------------------
--	FILE:	 New_Highlands.lua
--	AUTHOR:  
--	PURPOSE: Base game script - Produces widely varied islands.
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
local islands = {};
local featureGen = nil;
local world_age_old = 2;
local world_age_normal = 3;
local world_age_new = 4;

-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating New Highlands Map");
	local pPlot;

	-- Set globals
	g_iW, g_iH = Map.GetGridSize();
	g_iFlags = TerrainBuilder.GetFractalFlags();
	local temperature = MapConfiguration.GetValue("temperature"); -- Default setting is Temperate.
	if temperature == 4 then
		temperature  =  2 + TerrainBuilder.GetRandomNumber(2, "Random Temperature- Lua");
	end
	
	--	local world_age
	local world_age = MapConfiguration.GetValue("world_age");
	if (world_age == 3) then
		world_age = world_age_new;
	elseif (world_age == 7) then
		world_age = world_age_normal;
	elseif (world_age == 10) then
		world_age = world_age_old;
	else
		world_age = 1 + TerrainBuilder.GetRandomNumber(3, "Random World Age - Lua");
	end
--------------------------------------------------------------------------

--------------------------------------------------------------------------
	plotTypes = GeneratePlotTypes(world_age);
	terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature, false, 64, 0, 0.2, 0.5,-0.12,-0.45,0.6);
    ApplyBaseTerrain(plotTypes, terrainTypes, g_iW, g_iH);
    
    AreaBuilder.Recalculate();
    TerrainBuilder.AnalyzeChokepoints();
    TerrainBuilder.StampContinents();


	local iContinentBoundaryPlots = GetContinentBoundaryPlotCount(g_iW, g_iH);
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());
	AddTerrainFromContinents(plotTypes, terrainTypes, world_age, g_iW, g_iH, iContinentBoundaryPlots, true);

	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();

	print ("Num Mountains: " .. tostring(GetMountainCount(g_iW, g_iH)));

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers(-1);
	
	-- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
	local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 5 + 16);
	AddLakes(numLargeLakes);

	AddFeatures(2.2);
	
	print("Adding cliffs");
	AddCliffs(plotTypes, terrainTypes);
	
	local args = {
		numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
	};
	local nwGen = NaturalWonderGenerator.Create(args);

	AddFeaturesFromContinents(2.3);
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
        iWaterBonus = 1.5,
        resources = resourcesConfig,
        START_CONFIG = startConfig,

        ExtraBonusGroupOneMultiply = 2.4,                          --增加的倍率
        ExtraBonusGroupOne = {  
        "RESOURCE_SUK_CAMEL",		--骆驼
        "RESOURCE_SUK_CAMEL",		--额外骆驼
        "RESOURCE_SUK_CAMEL",		--额外骆驼
        "RESOURCE_SUK_CAMEL",		--额外骆驼
        "RESOURCE_SHEEP",			--羊
		"RESOURCE_SHEEP",			--额外羊
		"RESOURCE_COPPER",			--铜矿
        "RESOURCE_DATES",			--椰枣
		"RESOURCE_DATES",			--额外椰枣
		"RESOURCE_DATES",			--额外椰枣
        "RESOURCE_TIN"				--锡矿	
        },--增加的陆地加成资源,水资无效，奢侈战略无效

        ExtraBonusGroupTwoMultiply = 1.1,                           --增加的倍率
        ExtraBonusGroupTwo = {
        "RESOURCE_GRANITE",			--花岗岩
		"RESOURCE_COPPER",			--额外铜矿
        "RESOURCE_CATTLE",			--牛
		"RESOURCE_WHEAT",			--小麦
		"RESOURCE_WHEAT",			--小麦
		"RESOURCE_DATES"			--额外椰枣
        },--增加的陆地加成资源,水资无效，奢侈战略无效

   

        FewerBonusGroupOneMultiply = 0.7,                          --减少的倍率
        FewerBonusGroupOne = {  
        	"RESOURCE_CRABS",           --螃蟹
			"RESOURCE_BANANAS",			--香蕉
        	"RESOURCE_CATTLE",			--牛
        	"RESOURCE_DEER",		    --鹿	
        	"RESOURCE_MAIZE",           --玉米
            "RESOURCE_TOMATO",			--番茄

            "RESOURCE_RUBBER"           --橡胶
        },--减少的陆地加成资源,水资无效，奢侈战略无效

        FewerBonusGroupTwoMultiply = 0.5,                          --减少的倍率
        FewerBonusGroupTwo = {  
        	"RESOURCE_LEU_P0K_POTATOES",	--马铃薯
            "RESOURCE_DLV_BISON",       --野牛
            "RESOURCE_HAM",             --火腿
			"RESOURCE_PINE",			--松木
			"RESOURCE_OAK",				--橡木	
			"RESOURCE_RICE",			--大米
            "RESOURCE_JNR_PEAT"			--泥炭
        },--减少的陆地加成资源,水资无效，奢侈战略无效

		HorsesMultiply =    0.5,	--调整马资源丰度
        IronMultiply =		1.7,	--调整铁资源丰度
        NiterMultiply =     1.2,	--调整硝石资源丰度
        CoalMultiply =      0.5,	--调整煤炭资源丰度
        OilMultiply =       1.5,	--调整石油资源丰度
        AluminumMultiply =  1.2,	--调整铝资源丰度
        ExtraLuxuries = {   
            "RESOURCE_SAFFRON",			--藏红花
            "RESOURCE_ALOE",			--芦荟
            "RESOURCE_COTTON",			--棉花
            "RESOURCE_P0K_PAPYRUS"		--纸莎草
            --"RESOURCE_LEU_P0K_QUINOA"     --藜麦            
        }--增加陆地奢，奢侈按大陆加无倍率
    };

	local mSavannah = "FEATURE_JNR_SAVANNAH"
	if(GameInfo.Features[mSavannah] ~= nil)then
		args.ExtraLuxuries = {   
            "RESOURCE_ALOE",			--芦荟    
        }--开启稀树草原时，增加陆地奢的，奢侈按大陆加无倍率
	end

	local resGen = ResourceGenerator.Create(args);
	print("Creating start plot database.");
	-- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
	
	local args = {
		MIN_MAJOR_CIV_FERTILITY = 90,
		MAX_MAJOR_CIV_FERTILITY = 135,
        MIN_MINOR_CIV_FERTILITY = 5, 
        MAX_MINOR_CIV_FERTILITY = 60,
		MIN_BARBARIAN_FERTILITY = 50,
        START_MIN_Y = 24,
        START_MAX_Y = 42,
        START_MIN_X = 34,
        START_MAX_X = 40,
        --WATER = true,
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
	local sea_level_low = 25;
	local sea_level_normal = 30;
	local sea_level_high = 34;
	local world_age = 1;

	local water_percent_modifier = 0; 

	local desert_shift = 8;

	for x = 0, g_iW - 1 do
		for y = 0, g_iH - 1 do
			local index = (y * g_iW) + x + 1; -- Lua Array starts at 1
			plotTypes[index] = g_PLOT_TYPE_OCEAN;
		end
	end





	--	local sea_level
    local sea_level = MapConfiguration.GetValue("sea_level");
	local water_percent;
	local water_percent_modifier = 0;
	if sea_level == 1 then -- Low Sea Level
		water_percent = sea_level_low
		water_percent_modifier = -4
	elseif sea_level == 2 then -- Normal Sea Level
		water_percent =sea_level_normal
		water_percent_modifier = 4;
	elseif sea_level == 3 then -- High Sea Level
		water_percent = sea_level_high
	else
		water_percent = TerrainBuilder.GetRandomNumber(sea_level_high- sea_level_low, "Random Sea Level - Lua") + sea_level_low  + 1 ;
		water_percent_modifier = TerrainBuilder.GetRandomNumber(9, "Random Sea Level - Lua") - 4;
	end

--------------------------------------------
--------------------------------------------
	-- Set values for hills and mountains according to World Age chosen by user.
	local adjustment = world_age;
	if world_age <= world_age_old  then -- 5 Billion Years
		adjust_plates = adjust_plates * 0.75;
	elseif world_age >= world_age_new then -- 3 Billion Years
		adjust_plates = adjust_plates * 1.5;
	else -- 4 Billion Years
	end

	local hillsBottom1 = 43 - adjustment;
	local hillsTop1 = 44 + adjustment;
	local hillsBottom2 = 75 - adjustment;
	local hillsTop2 = 21 + adjustment;
	local hillsClumps = 1 + adjustment;
	local hillsNearMountains = 95 - (adjustment * 1.5) - extra_mountains;
	local mountains = 97 - adjustment - extra_mountains;

	local polar =  true;

	local fracFlags = {};

	fracFlags.FRAC_POLAR = true;
	local MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.MapSizeType] = row.PlateValue;
	end
	local sizekey = Map.GetMapSize();
	local numPlates = MapSizeTypes[sizekey] or 4;

	local continent_grain = 3;
	local rift_grain = -1;

	local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 6, 5);
	g_continentsFrac = Fractal.CreateRifts(g_iW, g_iH, continent_grain, fracFlags, riftsFrac, 6, 5);
	g_continentsFrac:BuildRidges(numPlates, {}, 1, 2);
	
	hillsFrac = Fractal.Create(g_iW, g_iH, continent_grain, {}, 6, 5);
	mountainsFrac = Fractal.Create(g_iW, g_iH, continent_grain, {}, 6, 5);
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
	local iWaterShift1 = math.ceil(g_iH * 0.8);
	--local iWaterHeight1 = g_iH - iWaterShift1 * 3;
	local iWaterHeight1 = {};
--------------------------------------------
	-- by changing iRegionFracXExp and iRegionFracYExp to control the shape of oceans.
	-- Generate Large Lakes		
	local args = {};	
	args.iWaterPercent = 62 + water_percent_modifier;
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
	islands = plotTypes;

	-- Generate Medium Lakes	
	local args = {};	
	args.iWaterPercent = 78 + water_percent_modifier;
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
	islands = plotTypes;

	-- Generate Small  Lakes
	local args = {};	
	args.iWaterPercent = 85 + water_percent_modifier;
	args.iRegionWidth = math.ceil(g_iW);
	args.iRegionHeight = math.ceil(g_iH);
	args.iRegionWestX = math.floor(0);
	args.iRegionSouthY = math.floor(0);
	args.iRegionGrain = 5;
	args.iRegionHillsGrain = 4;
	args.iRegionPlotFlags = g_iFlags;
	args.iRegionFracXExp = 7;
	args.iRegionFracYExp = 6;
    plotTypes = GenerateFractalLayerWithoutHills(args, plotTypes);

	-- Generate Tiny Lakes
	local args = {};	
	args.iWaterPercent = 90 + water_percent_modifier;
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

	local args = {};
	args.world_age = world_age;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 3;
	-- args.blendFract = 5; -- original setting
	args.blendFract = 1;
	-- args.extra_mountains = 5; -- original setting
	args.extra_mountains = -1;
	-- mountainRatio = 8 + world_age * 3; -- original setting
	mountainRatio = 5 + world_age * 7;

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
	
		local args = {rainfall = rainfall,  iSavannahPercent = 14, iOasisPercent = 58 ,iMarshPercent = 1, iSwampPercent = 1, iJunglePercent = 11, iForestPercent = 6} 
	--稀疏的森林植被
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
	local iWaterPercent = args.iWaterPercent or 41;
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
			elseif (adjCount > 8 and adjCount < 15) then
				if (math.random(5,7) <= adjCount) then
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
    local iWaterPercent = args.iWaterPercent or 44;
    local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
    local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
    local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
    local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
    local iRegionGrain = args.iRegionGrain or 5;
    local iRegionPlotFlags = args.iRegionPlotFlags or g_iFlags;
    local iRegionFracXExp = args.iRegionFracXExp or 5;
    local iRegionFracYExp = args.iRegionFracYExp or 4;
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



------------------------------------------------------------------------------


function AddTerrainFromContinents(plotTypes, terrainTypes, world_age, iW, iH, iContinentBoundaryPlots)

	local iMountainPercentByDistance:table = {20, 10, 0}; 
	local iMountainPercentBias:table = {5, 3, 0};
	local iHillPercentByDistance:table = {50, 40, 30};
	local aLonelyMountainIndices:table = {};
	local aPlacedVolcanoes:table = {};

	-- Split Lonely Mountain into Continents: we need to fight the RNG, splitting volcanoes between continents where it would clump them otherwise
	local vContinents = Map.GetContinentsInUse();

	for i, index in ipairs(vContinents) do
		local aTable:table = {}
		aLonelyMountainIndices[index] = aTable;
	end

	-- Compute target number of volcanoes
	local iTotalLandPlots = 0;
	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = (iY * iW) + iX;
			if (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
				iTotalLandPlots = iTotalLandPlots + 1;
			end
		end
	end

	local iDivisor = 5;
	if (world_age < 10) then
		iDivisor = 5 - math.floor(world_age / 2);
	end
	local iDesiredVolcanoes = iTotalLandPlots / (iDivisor * 50) * 1.5;

	print ("Desired Volcanoes: " .. iDesiredVolcanoes);

	-- 2/3rds of Earth's volcanoes are near continent boundaries
	print ("Continent Boundary Plots: " .. iContinentBoundaryPlots);
	local iDesiredNearBoundaries = iDesiredVolcanoes * 2 / 3;

	if (iDesiredNearBoundaries > 0) then
		local iBoundaryPlotsPerVolcano = iContinentBoundaryPlots / iDesiredNearBoundaries;

		print ("Boundary Plots Per Volcano: " .. iBoundaryPlotsPerVolcano);

		for iX = 0, iW - 1 do
			for iY = 0, iH - 1 do
				local index = (iY * iW) + iX;
				if (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
					local pPlot = Map.GetPlotByIndex(index);
					local iPlotsFromBoundary = -1;
					local bVolcanoHere = false;
					local iNumAdjacentMountains = GetNumberAdjacentMountains(iX, iY);
					-- Changes: no longer place inaccessible volcanoes, and no longer place volcanoes along continent boundaries too near each other
					if (iNumAdjacentMountains ~= 6 and GetNumberNearbyVolcanoes(iX, iY, 3, aPlacedVolcanoes) == 0) then
						if (Map.FindSecondContinent(pPlot, 1)) then
							if (TerrainBuilder.GetRandomNumber(iBoundaryPlotsPerVolcano *.7, "Volcano on boundary") == 0) then
								bVolcanoHere = true;
							end
							iPlotsFromBoundary = 1;
						elseif(Map.FindSecondContinent(pPlot, 2)) then
							if (TerrainBuilder.GetRandomNumber(iBoundaryPlotsPerVolcano, "Volcano 1 from boundary") == 0) then
								bVolcanoHere = true;
							end
							iPlotsFromBoundary = 2;
						elseif(Map.FindSecondContinent(pPlot, 3)) then
							if (TerrainBuilder.GetRandomNumber(iBoundaryPlotsPerVolcano * 1.5, "Volcano 2 from boundary") == 0) then
								bVolcanoHere = true;
							end
							iPlotsFromBoundary = 3;

						elseif (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
							if (iNumAdjacentMountains == 0 or (iNumAdjacentMountains > 1 and iNumAdjacentMountains < 4 )) then
								local iContinentType = pPlot:GetContinentType();
								table.insert(aLonelyMountainIndices[pPlot:GetContinentType()], index);
							end
						end
					end

					if (bVolcanoHere) then
						TerrainBuilder.SetTerrainType(pPlot, ConvertToMountain(terrainTypes[index]));
						TerrainBuilder.SetFeatureType(pPlot, g_FEATURE_VOLCANO);
						print ("Volcano Placed at (x, y): " .. iX .. ", " .. iY);
						table.insert(aPlacedVolcanoes, index);

					elseif (iPlotsFromBoundary > 0)	then	
						local iMountainChance = iMountainPercentByDistance[iPlotsFromBoundary];
						if (GetNumberAdjacentVolcanoes(iX, iY) > 0) then
							iMountainChance = iMountainChance / 2;
						end						
						-- Mountain?
						if (TerrainBuilder.GetRandomNumber(100, "Mountain near boundary") < iMountainChance) then
							TerrainBuilder.SetTerrainType(pPlot, ConvertToMountain(terrainTypes[index]));

						-- Hills?
						elseif (TerrainBuilder.GetRandomNumber(100, "Hill near boundary") < iHillPercentByDistance[iPlotsFromBoundary]) then
							TerrainBuilder.SetTerrainType(pPlot, ConvertToHills(terrainTypes[index]));
						end
					end
				end
			end
		end
		print ("Continent Edge Volcanoes Placed: " .. #aPlacedVolcanoes);
	end

	local iLonelyVolcanoes = iDesiredVolcanoes - #aPlacedVolcanoes;
	local iTempVolcCount = 0;
	
	local iTotalMountains = 0;

	for i, Indices in pairs(aLonelyMountainIndices) do
		iTotalMountains = iTotalMountains + #Indices;
	end

	if (iTotalMountains > 0 and iLonelyVolcanoes > 0) then
		for i, Indices in pairs(aLonelyMountainIndices) do
			local iNumVolcanoes = iLonelyVolcanoes * #Indices/iTotalMountains
			if (iNumVolcanoes > 0) then
				aShuffledIndices =  GetShuffledCopyOfTable(Indices);
				iTempVolcCount = 0;

				for i, index in ipairs(aShuffledIndices) do
					local pPlot = Map.GetPlotByIndex(index);
					local iNearby = GetNumberNearbyVolcanoes(pPlot:GetX(),  pPlot:GetY(), 4, aPlacedVolcanoes);
					if (iNearby == 0) then
						TerrainBuilder.SetFeatureType(pPlot, g_FEATURE_VOLCANO);
						print ("Volcano Placed at (x, y): " .. pPlot:GetX() .. ", " .. pPlot:GetY());
						table.insert(aPlacedVolcanoes, index);
						iTempVolcCount = iTempVolcCount + 1;
						if (iTempVolcCount >= iNumVolcanoes) then
							break
						end
					end
				end

			end
		end
	end

	print ("Total Volcanoes Placed: " .. #aPlacedVolcanoes);
end

------------------------------------------------------------------------------
function GetNumberNearbyVolcanoes(iX, iY, range, aPlacedVolcanoes)
	
	local iVolcanoCount = 0;

	for i, iVolcano in pairs(aPlacedVolcanoes) do
		local volcanoPlot = Map.GetPlotByIndex(iVolcano);
		iDistance = Map.GetPlotDistance(iX, iY, volcanoPlot:GetX(), volcanoPlot:GetY());
		if (iDistance <= range) then
			iVolcanoCount = iVolcanoCount + 1;
		end
	end

	return iVolcanoCount;
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
function FeatureGenerator:AddSavannahAtPlot(plot, iX, iY)
	--Savannah Check. First see if it can place the feature.
	
	local sSavannah				= "FEATURE_JNR_SAVANNAH"
	if(GameInfo.Features[sSavannah] == nil)then
		return false;
	end
	local g_FEATURE_JNR_SAVANNAH	= GameInfo.Features[sSavannah].Index
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_JNR_SAVANNAH)) then
		if(math.ceil(self.iSavannahCount * 100 / self.iNumLandPlots) <= self.iSavannahMaxPercent) then
			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 220;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_JNR_SAVANNAH);
				

			if (iAdjacent == 0 ) then
				iScore = iScore;
			elseif (iAdjacent == 1) then
				iScore = iScore + 110;
			elseif (iAdjacent == 2) then
				iScore = iScore + 170;
			elseif (iAdjacent == 3) then
				iScore = iScore + 170;
			elseif (iAdjacent == 4) then
				iScore = iScore - 110;
			else
				iScore = iScore - 230;
			end
				
			if(TerrainBuilder.GetRandomNumber(550, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_JNR_SAVANNAH);
				self.iSavannahCount = self.iSavannahCount + 1;

				return true;
			end
		end
	end

	return false;
end

-------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------


function AddLakes(largeLakes)

	print("Map Generation - Adding Lakes");
	largeLakes = largeLakes or 0;

	local numLakesAdded = 0;
	local numLargeLakesAdded = 0;

	local lakePlotRand =  math.floor(GlobalParameters.LAKE_PLOT_RANDOM or 5);
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