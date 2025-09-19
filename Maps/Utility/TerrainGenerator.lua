------------------------------------------------------------------------------
--	FILE:	 TerrainGenerator.lua
--	AUTHOR:  
--	PURPOSE: Shared map script to assign Civ 6 terrain types to a map
------------------------------------------------------------------------------
--	Copyright (c) 2014-6 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

-------------------------------------------------------------------------------

function ConvertToMountain(type)

	local rtnValue = type;

	if (type == g_TERRAIN_TYPE_SNOW or type == g_TERRAIN_TYPE_SNOW_HILLS) then
		rtnValue = g_TERRAIN_TYPE_SNOW_MOUNTAIN;
	elseif (type == g_TERRAIN_TYPE_TUNDRA or type == g_TERRAIN_TYPE_TUNDRA_HILLS) then
		rtnValue = g_TERRAIN_TYPE_TUNDRA_MOUNTAIN;
	elseif (type == g_TERRAIN_TYPE_DESERT or type == g_TERRAIN_TYPE_DESERT_HILLS) then
		rtnValue = g_TERRAIN_TYPE_DESERT_MOUNTAIN;
	elseif (type == g_TERRAIN_TYPE_GRASS or type == g_TERRAIN_TYPE_GRASS_HILLS) then
		rtnValue = g_TERRAIN_TYPE_GRASS_MOUNTAIN;
	elseif (type == g_TERRAIN_TYPE_PLAINS or type == g_TERRAIN_TYPE_PLAINS_HILLS) then
		rtnValue = g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
	end

	return rtnValue;
end

function ConvertToHills(type)

	local rtnValue = type;

	if (type == g_TERRAIN_TYPE_SNOW or type == g_TERRAIN_TYPE_SNOW_MOUNTAIN) then
		rtnValue = g_TERRAIN_TYPE_SNOW_HILLS;
	elseif (type == g_TERRAIN_TYPE_TUNDRA or type == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN) then
		rtnValue = g_TERRAIN_TYPE_TUNDRA_HILLS;
	elseif (type == g_TERRAIN_TYPE_DESERT or type == g_TERRAIN_TYPE_DESERT_MOUNTAIN) then
		rtnValue = g_TERRAIN_TYPE_DESERT_HILLS;
	elseif (type == g_TERRAIN_TYPE_GRASS or type == g_TERRAIN_TYPE_GRASS_MOUNTAIN) then
		rtnValue = g_TERRAIN_TYPE_GRASS_HILLS;
	elseif (type == g_TERRAIN_TYPE_PLAINS or type == g_TERRAIN_TYPE_PLAINS_MOUNTAIN) then
		rtnValue = g_TERRAIN_TYPE_PLAINS_HILLS;
	end

	return rtnValue;
end

function ApplyBaseTerrain(plotTypes, terrainTypes, iW, iH)
	for i = 0, (iW * iH) - 1, 1 do
		pPlot = Map.GetPlotByIndex(i);
		if (plotTypes[i] == g_PLOT_TYPE_HILLS) then
			terrainTypes[i] = terrainTypes[i] + 1;
		end
		TerrainBuilder.SetTerrainType(pPlot, terrainTypes[i]);
	end
end

function GetContinentBoundaryPlotCount(iW, iH)

	local iContinentBoundaryPlots = 0;

	for i = 0, (iW * iH) - 1, 1 do
		pPlot = Map.GetPlotByIndex(i);
		if (Map.FindSecondContinent(pPlot, 3)) then
			iContinentBoundaryPlots = iContinentBoundaryPlots + 1;
		end
	end
	return iContinentBoundaryPlots;
end

function GenerateTerrainTypes(plotTypes, iW, iH, iFlags, bNoCoastalMountains, temperature, notExpandCoasts, iDesertPercentArg, iPlainsPercentArg, fSnowLatitudeArg, fTundraLatitudeArg, fGrassLatitudeArg, fDesertBottomLatitudeArg, fDesertTopLatitudeArg)
	print("Generating Terrain Types");
	local terrainTypes = {};

	-- Sea Level option affects only plot generation.
	-- World Age option affects plot generation and geothermal/volcanic features
	-- Temperature map options affect only terrain generation.
	-- Rainfall map options affect only feature generation.
	if(temperature == nil) then
		temperature = 2;
	end

	local coldShift = 0.0;
	local temperature_shift = 0.1;
	local desert_shift = 16;
	local plains_shift = 6;
	
	-- Set terrain bands args.
	local iDesertShift = iDesertPercentArg or 0;
	local iPlainsShift = iPlainsPercentArg or 0;
	local fSnowShift = fSnowLatitudeArg or 0.0;
	local fTundraShift = fTundraLatitudeArg or 0.0;
	local fGrassShift = fGrassLatitudeArg or 0.0;
	local fDesertShiftTop = fDesertBottomLatitudeArg or 0.0;
	local fDesertShiftBottom = fDesertTopLatitudeArg or 0.0;
	
	-- Set terrain bands.
	local iDesertPercent = 22 + iDesertShift;
	local iPlainsPercent = 50 + iPlainsShift;
	-- more 10% for non-snow plots.
	local fSnowLatitude  = 0.90 + coldShift + fSnowShift;
	local fTundraLatitude = 0.70 + coldShift + fTundraShift;
	local fGrassLatitude = 0.11 + fGrassShift;
	local fDesertBottomLatitude = 0.22 + fDesertShiftTop;
	local fDesertTopLatitude = 0.55 + fDesertShiftBottom;
	-- local fSnowLatitude  = 0.8 + coldShift + fSnowShift;
	-- local fTundraLatitude = 0.65 + coldShift + fTundraShift;
	-- local fGrassLatitude = 0.1 + fGrassShift;
	-- local fDesertBottomLatitude = 0.2 + fDesertShiftTop;
	-- local fDesertTopLatitude = 0.5 + fDesertShiftBottom;

	-- Adjust user's Temperature selection.
	if temperature > 2.5 then -- World Temperature is Cool.
		iDesertPercent = iDesertPercent - desert_shift;
		fTundraLatitude = fTundraLatitude - (temperature_shift * 1.5);
		iPlainsPercent = iPlainsPercent + plains_shift;
		fDesertTopLatitude = fDesertTopLatitude - temperature_shift;
		fGrassLatitude = fGrassLatitude - (temperature_shift * 0.5);
	elseif temperature < 1.5 then -- World Temperature is Hot.
		iDesertPercent = iDesertPercent + desert_shift;
		fSnowLatitude  = fSnowLatitude + (temperature_shift * 0.5);
		fTundraLatitude = fTundraLatitude + temperature_shift;
		fDesertTopLatitude = fDesertTopLatitude + temperature_shift;
		fGrassLatitude = fGrassLatitude - (temperature_shift * 0.5);
		iPlainsPercent = iPlainsPercent + plains_shift;
	else -- Normal Temperature.
	end

	local iDesertTopPercent		= 100;
	local iDesertBottomPercent	= math.max(0, math.floor(100-iDesertPercent));
	local iPlainsTopPercent		= 100;
	local iPlainsBottomPercent	= math.max(0, math.floor(100-iPlainsPercent));

	
	-- Activate printout for debugging only
	print("-"); print("- Desert Percentage:", iDesertPercent);
	print("--- Latitude Readout ---");
	print("- All Grass End Latitude:", fGrassLatitude);
	print("- Desert Start Latitude:", fDesertBottomLatitude);
	print("- Desert End Latitude:", fDesertTopLatitude);
	print("- Tundra Start Latitude:", fTundraLatitude);
	print("- Snow Start Latitude:", fSnowLatitude);
	print("- - - - - - - - - - - - - -");

	local fracXExp = -1;
	local fracYExp = -1;
	local grain_amount = 3;
	local iDesertTop;
	local iDesertBottom;																
	local iPlainsTop;
	local iPlainsBottom;

	deserts = Fractal.Create(iW, iH, 
									grain_amount, iFlags, 
									fracXExp, fracYExp);
									
	iDesertTop = deserts:GetHeight(iDesertTopPercent);
	iDesertBottom = deserts:GetHeight(iDesertBottomPercent);

	plains = Fractal.Create(iW, iH, 
									grain_amount, iFlags, 
									fracXExp, fracYExp);
																		
	iPlainsTop = plains:GetHeight(iPlainsTopPercent);
	iPlainsBottom = plains:GetHeight(iPlainsBottomPercent);

	local variationFrac = Fractal.Create(iW, iH,  
									grain_amount, iFlags, 
									fracXExp, fracYExp);
	
	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = (iY * iW) + iX;
			if (plotTypes[index] == g_PLOT_TYPE_OCEAN) then
				if (IsAdjacentToLand(plotTypes, iX, iY)) then
					terrainTypes[index] = g_TERRAIN_TYPE_COAST;
				else
					terrainTypes[index] = g_TERRAIN_TYPE_OCEAN;
				end
			end
		end
	end

	if (bNoCoastalMountains == true) then
		plotTypes = RemoveCoastalMountains(plotTypes, terrainTypes);
	end

	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = (iY * iW) + iX;
			local lat = GetLatitudeAtPlot(variationFrac, iX, iY);

			if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
			    terrainTypes[index] = g_TERRAIN_TYPE_GRASS_MOUNTAIN;

				if(lat >= fSnowLatitude) then
					terrainTypes[index] = g_TERRAIN_TYPE_SNOW_MOUNTAIN;
				elseif(lat >= fTundraLatitude) then
					terrainTypes[index] = g_TERRAIN_TYPE_TUNDRA_MOUNTAIN;
				elseif (lat < fGrassLatitude) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS_MOUNTAIN;
				else
					local desertVal = deserts:GetHeight(iX, iY);
					local plainsVal = plains:GetHeight(iX, iY);
					if ((desertVal >= iDesertBottom) and (desertVal <= iDesertTop) and (lat >= fDesertBottomLatitude) and (lat < fDesertTopLatitude)) then
						terrainTypes[index] = g_TERRAIN_TYPE_DESERT_MOUNTAIN;
					elseif ((plainsVal >= iPlainsBottom) and (plainsVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
					end
				end

			elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
				terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
				
				if(lat >= fSnowLatitude) then
					terrainTypes[index] = g_TERRAIN_TYPE_SNOW;
				elseif(lat >= fTundraLatitude) then
					terrainTypes[index] = g_TERRAIN_TYPE_TUNDRA;
				elseif (lat < fGrassLatitude) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
				else
					local desertVal = deserts:GetHeight(iX, iY);
					local plainsVal = plains:GetHeight(iX, iY);
					if ((desertVal >= iDesertBottom) and (desertVal <= iDesertTop) and (lat >= fDesertBottomLatitude) and (lat < fDesertTopLatitude)) then
						terrainTypes[index] = g_TERRAIN_TYPE_DESERT;
					elseif ((plainsVal >= iPlainsBottom) and (plainsVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS;
					end
				end
			end
		end
	end

	local bNotExpandCoasts = notExpandCoasts or false;

	if bNotExpandCoasts == true then
		return terrainTypes;
	end

	print("Expanding coasts");
	for iI = 0, 2 do
		local shallowWaterPlots = {};
		for iX = 0, iW - 1 do
			for iY = 0, iH - 1 do
				local index = (iY * iW) + iX;
				if (terrainTypes[index] == g_TERRAIN_TYPE_OCEAN) then
					-- Chance for each eligible plot to become an expansion is 1 / iExpansionDiceroll.
					-- Default is two passes at 1/4 chance per eligible plot on each pass.
					if (IsAdjacentToShallowWater(terrainTypes, iX, iY) and TerrainBuilder.GetRandomNumber(4, "add shallows") == 0) then
						table.insert(shallowWaterPlots, index);
					end
				end
			end
		end
		for i, index in ipairs(shallowWaterPlots) do
			terrainTypes[index] = g_TERRAIN_TYPE_COAST;
		end
	end
	
	return terrainTypes; 
end
------------------------------------------------------------------------------
function AddTerrainFromContinents(plotTypes, terrainTypes, world_age, iW, iH, iContinentBoundaryPlots, bNoCoastalMountains)

	local iMountainPercentByDistance:table = {42, 24, 6}; 
	-- bias the probability of generate mountains when adjacent to mountains
	local iMountainPercentBias:table = {12,6,0};
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
	local iDivisor = 8;
	if (world_age < 8) then
		iDivisor = 8 - world_age;  -- iDivisor should be 3 for new, 6 for old
	end
	local iDesiredVolcanoes = iTotalLandPlots / (iDivisor * 50);

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
						if not(bNoCoastalMountains and IsAdjacentToShallowWater(terrainTypes, iX, iY)) then --get rid of coastal volcano.
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
					end

					if (bVolcanoHere) then
						TerrainBuilder.SetTerrainType(pPlot, ConvertToMountain(terrainTypes[index]));
						TerrainBuilder.SetFeatureType(pPlot, g_FEATURE_VOLCANO);
						print ("Volcano Placed at (x, y): " .. iX .. ", " .. iY);
						table.insert(aPlacedVolcanoes, index);

					elseif (iPlotsFromBoundary > 0)	then	
						local iMountainChance = iMountainPercentByDistance[iPlotsFromBoundary];
						-- bias the probability of generating continent boundary mountains when adjacent to other mountains.
						-- the goal is to make continent boundary more accessible.
						local AdjacentBias = iMountainPercentBias[iPlotsFromBoundary];
						local iNumAdjacentMountains = GetNumberAdjacentMountains(iX, iY);
						iMountainChance = math.max(iMountainChance - AdjacentBias*iNumAdjacentMountains, 0);
						if (GetNumberAdjacentVolcanoes(iX, iY) > 0) then
							iMountainChance = iMountainChance / 2;
						end						
						-- Mountain?
						if (TerrainBuilder.GetRandomNumber(100, "Mountain near boundary") < iMountainChance) then
							if bNoCoastalMountains and IsAdjacentToShallowWater(terrainTypes, iX, iY) then
								print('Disabled Coastal Mountain on Continent Boundary', iX, iY)
							else
								TerrainBuilder.SetTerrainType(pPlot, ConvertToMountain(terrainTypes[index]));
							end

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
	
	if (GameCapabilities.HasCapability("CAPABILITY_MEGADISASTERS")) then
		iDesiredVolcanoes = iDesiredVolcanoes * 2 + 2;
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
function GetNumberAdjacentVolcanoes(iX, iY)
	
	local iVolcanoCount = 0;

	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(iX, iY, direction);
		if (adjacentPlot ~= nil) then
			terrainType = adjacentPlot:GetTerrainType();
			featureType = adjacentPlot:GetFeatureType();
			if (terrainType == g_TERRAIN_TYPE_DESERT_VOLCANO or
				terrainType == g_TERRAIN_TYPE_VOLCANO or featureType == g_FEATURE_VOLCANO) then
				iVolcanoCount = iVolcanoCount + 1;
			end
		end
	end

	return iVolcanoCount;
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

------------------------------------------------------------------------------
function GetNumberAdjacentMountains(iX, iY)
	
	local iMountainCount = 0;

	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(iX, iY, direction);
		if (adjacentPlot ~= nil) then
			terrainType = adjacentPlot:GetTerrainType();
			if (adjacentPlot:IsMountain()) then
				iMountainCount = iMountainCount + 1;
			end
		end
	end

	return iMountainCount;
end

------------------------------------------------------------------------------
function GetNumberAdjacentLakes(iX, iY)
	
	local iLakeCount = 0;

	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(iX, iY, direction);

		if (adjacentPlot ~= nil) then
			if ( adjacentPlot:IsLake() == true) then
				iLakeCount = iLakeCount + 1;

			elseif (adjacentPlot:IsNaturalWonder() == true) then
				local eFeature = adjacentPlot:GetFeatureType();
				if (eFeature ~= -1 and GameInfo.Features[eFeature].Lake == true) then
					iLakeCount = iLakeCount + 1;
				end
			end
		end
	end

	return iLakeCount;
end

------------------------------------------------------------------------------
function GetMountainCount(iW, iH)
	
	local iCount = 0;
	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local plot = Map.GetAdjacentPlot(iX, iY, direction);
			if (plot ~= nil) then
				if (plot:IsMountain()) then
					iCount = iCount + 1;
				end
			end
		end
	end
	return iCount;
end