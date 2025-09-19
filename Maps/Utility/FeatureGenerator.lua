include "MapUtilities.lua"
------------------------------------------------------------------------------
FeatureGenerator = {};
------------------------------------------------------------------------------
function FeatureGenerator.Create(args)
	--
	local args = args or {};
	local rainfall = args.rainfall or 2; -- Default is Normal rainfall.
	local iEquatorAdjustment = args.iEquatorAdjustment or 0;
	
	-- Sea Level option affects only plot generation.
	-- World Age option affects plot generation and geothermal/volcanic features
	-- Temperature map options affect only terrain generation.
	-- Rainfall map options affect only feature generation.

	if rainfall == 1 then
		rainfall = -4;
	elseif rainfall == 2 then
		rainfall = 0
	elseif rainfall == 3 then
		rainfall = 4;	
	else
		rainfall = TerrainBuilder.GetRandomNumber(11, "Random Rainfall - Lua") - 5;
	end

	-- Set feature traits.
	local iJunglePercent = args.iJunglePercent or 35;
	local iForestPercent = args.iForestPercent or 18;
	local iMarshPercent = args.iMarshPercent or 2;
	local iOasisPercent = args.iOasisPercent or 2;
	local iReefPercent = args.iReefPercent or 9;
	local iIcePercent = args.iIcePercent or 0;
	local iSwampPercent = args.iSwampPercent or 2;
	local iSavannahPercent = args.iSavannahPercent or 7;

	iJunglePercent = iJunglePercent + rainfall;
	iForestPercent = iForestPercent + rainfall;
	iMarshPercent = iMarshPercent + rainfall / 2;
	iOasisPercent = 4 + iOasisPercent + rainfall / 2;--绿洲增加？
	iSwampPercent = iSwampPercent + rainfall / 2;
	iSavannahPercent = iSavannahPercent + rainfall/2-3;

	local gridWidth, gridHeight = Map.GetGridSize();
	local iEquator = math.ceil(gridHeight / 2) + iEquatorAdjustment;
--
	-- create instance data
	local instance = {
	
		-- methods
		__initFractals		= FeatureGenerator.__initFractals,
		__initFeatureTypes	= FeatureGenerator.__initFeatureTypes,
		AddFeatures			= FeatureGenerator.AddFeatures,
		AddFeaturesFromContinents = FeatureGenerator.AddFeaturesFromContinents,
		GetLatitudeAtPlot	= FeatureGenerator.GetLatitudeAtPlot,
		AddFeaturesAtPlot	= FeatureGenerator.AddFeaturesAtPlot,
		AddOasisAtPlot		= FeatureGenerator.AddOasisAtPlot,
		AddIceToMap		= FeatureGenerator.AddIceToMap,
		AddMarshAtPlot		= FeatureGenerator.AddMarshAtPlot,
		AddJunglesAtPlot	= FeatureGenerator.AddJunglesAtPlot,
		AddForestsAtPlot	= FeatureGenerator.AddForestsAtPlot,
		AddReefAtPlot		= FeatureGenerator.AddReefAtPlot,
		AddSwampAtPlot		= FeatureGenerator.AddSwampAtPlot,
		AddSavannahAtPlot	= FeatureGenerator.AddSavannahAtPlot,

		-- members
		iGridW = gridWidth,
		iGridH = gridHeight,
		
		iJungleMaxPercent = iJunglePercent,
		iForestMaxPercent = iForestPercent,
		iMarshMaxPercent = iMarshPercent,
		iOasisMaxPercent = iOasisPercent,
		iReefMaxPercent = iReefPercent,
		iIceModifiedPercent = iIcePercent,
		iSwampMaxPercent = iSwampPercent,
		iSavannahMaxPercent = iSavannahPercent,

		iForestCount = 0,
		iJungleCount = 0,
		iMarshCount = 0,
		iOasisCount = 0,
		iReefCount = 0,
		iFissureCount = 0,
		iNumLandPlots = 0,
		iNumJunglablePlots = 0,
		iNumReefablePlots = 0,
		iceLat = 0.78;
		iSwampCount = 0,
		iSavannahCount = 0,

		-- Rainforest on Earth mostly in Tropics, so keep in narrow band around Equator
		iJungleBottom = iEquator - (20 * gridHeight / 180);
		iJungleTop = iEquator + (20 * gridHeight / 180);
		iNumEquator = iEquator,
	};

	-- initialize instance data
	
	return instance;
end
------------------------------------------------------------------------------
function FeatureGenerator:AddFeatures(allow_mountains_on_coast, bRiversStartInland)

	-- First let's add Floodplains
	local iMinFloodplainSize = 4;
	local iMaxFloodplainSize = 9;
	TerrainBuilder.GenerateFloodplains(bRiversStartInland, iMinFloodplainSize, iMaxFloodplainSize);

	local flag = allow_mountains_on_coast or true;

	if allow_mountains_on_coast == false then -- remove any mountains from coastal plots
		for x = 0, self.iGridW - 1 do
			for y = 0, self.iGridH - 1 do
				local plot = Map.GetPlot(x, y)
				if plot:GetPlotType() == g_PLOT_TYPE_MOUNTAIN then
					if plot:IsCoastalLand() then
						plot:SetPlotType(g_PLOT_TYPE_HILLS, false, true); -- These flags are for recalc of areas and rebuild of graphics. Instead of recalc over and over, do recalc at end of loop.
					end
				end
			end
		end
		-- This function needs to recalculate areas after operating. However, so does 
		-- adding feature ice, so the recalc was removed from here and put in MapGenerator()
	end

	self:AddIceToMap();
	
	-- Main loop, adds features to all plots as appropriate based on the count and percentage of that type, but not ones that can't be adjacent to other features
	-- for y = 0, self.iGridH - 1, 1 do
		-- for x = 0, self.iGridW - 1, 1 do
			-- local i = y * self.iGridW + x;
	
	print("Add Features (DeepLogic version)");
	-- Get all positions.
	local aPositions = {};
	for x = 0, self.iGridW - 1 do
		for y = 0, self.iGridH - 1 do
			local i = y * self.iGridW + x;
			table.insert(aPositions, i);
		end
	end
	local aShuffledPositions = GetShuffledCopyOfTable(aPositions);

	for ind, i in ipairs(aShuffledPositions) do
		local y = math.floor(i / self.iGridW);
		local x = i % self.iGridW;		
		local plot = Map.GetPlotByIndex(i);
		if(plot ~= nil) then
			local featureType = plot:GetFeatureType();

			if(plot:IsImpassable() or featureType ~= g_FEATURE_NONE) then
				--No Feature
			elseif(plot:IsWater() == true) then					
				if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_REEF) == true ) then
					
					self:AddReefAtPlot(plot, x, y);
				end
			else
				self.iNumLandPlots = self.iNumLandPlots + 1;

				local bMarsh = false;
				local bJungle = false;
				local bSwamp = false;
				local bSavannah = false;
				--None of these are guarenteed
				if(featureType == g_FEATURE_NONE) then
					--First check to add Marsh
					bMarsh = self:AddMarshAtPlot(plot, x, y);

					if(featureType == g_FEATURE_NONE and bMarsh == false) then 
						--check to add Jungle
						bJungle = self:AddJunglesAtPlot(plot, x, y);
					end

					if(featureType == g_FEATURE_NONE and bMarsh == false and bJungle == false) then
						--check to add Swamp
						bSwamp = self:AddSwampAtPlot(plot, x, y);
					end

					if(featureType == g_FEATURE_NONE and bMarsh == false and bSwamp == false and bJungle == false) then
						--check to add Savannah
						bSavannah = self:AddSavannahAtPlot(plot, x, y);
					end

					if(featureType == g_FEATURE_NONE and bMarsh == false and bSwamp == false and bJungle == false and bSavannah == false) then 
						--check to add Forest
						self:AddForestsAtPlot(plot, x, y);
					end
				end
			end
		end
		-- end
	end

	print("Number of Tiles: ", self.iNumLandPlots);
	print("Number of Forests: ", self.iForestCount);
	print("Percent Forests: ", (100 * self.iForestCount) / self.iNumLandPlots);
	print("Number of Jungles: ", self.iJungleCount);
	print("Percent Jungles: ", (100 * self.iJungleCount) / self.iNumLandPlots);
	print("Percent of Junglable: ", (100 * self.iJungleCount) / self.iNumJunglablePlots);
	print("Number of Marshes: ", self.iMarshCount);
	print("Number of Swamps: ", self.iSwampCount);
	print("Number of Savannahs: ", self.iSavannahCount);
end
------------------------------------------------------------------------------
function FeatureGenerator:AddFeaturesFromContinents()

	local aPossibleFissureIndices:table = {};

	-- Oasis are in this loop even though not placed near continent boundaries.  Want in a secondary loop since can't be adjacent to other features
	for y = 0, self.iGridH - 1, 1 do
		for x = 0, self.iGridW - 1, 1 do
			local i = y * self.iGridW + x;
			local plot = Map.GetPlotByIndex(i);
			if(plot ~= nil) then
				local featureType = plot:GetFeatureType();

				if(plot:IsImpassable() or featureType ~= g_FEATURE_NONE) then
					--No Feature
				else
					if (TerrainBuilder.CanHaveFeature(plot, g_FEATURE_OASIS) == true and math.ceil(self.iOasisCount * 100 / self.iNumLandPlots) <= self.iOasisMaxPercent ) then
						if(TerrainBuilder.GetRandomNumber(4, "Oasis Random") == 1) then
							TerrainBuilder.SetFeatureType(plot, g_FEATURE_OASIS);
							self.iOasisCount = self.iOasisCount + 7;--绿洲增加？
						end
					end
					if (TerrainBuilder.CanHaveFeature(plot, g_FEATURE_GEOTHERMAL_FISSURE) == true) then
						if (Map.FindSecondContinent(plot, 3)) then
							table.insert(aPossibleFissureIndices, i);
						end
					end
				end
			end
		end
	end

	-- Place fissures near continent divides
	local iDesiredFissures = self.iNumLandPlots / 200;
	if (iDesiredFissures > 0 and #aPossibleFissureIndices > 0) then
		aShuffledIndices =  GetShuffledCopyOfTable(aPossibleFissureIndices);
		for i, index in ipairs(aShuffledIndices) do
			local pPlot = Map.GetPlotByIndex(index);
			TerrainBuilder.SetFeatureType(pPlot, g_FEATURE_GEOTHERMAL_FISSURE);
			self.iFissureCount = self.iFissureCount + 0.5;
			print ("Fissure Placed at (x, y): " .. pPlot:GetX() .. ", " .. pPlot:GetY());
			if (self.iFissureCount >= iDesiredFissures) then
				break
			end
		end
	end

	-- Still have fissures to place?  Add them anywhere
	if (iDesiredFissures > self.iFissureCount) then
		local aFullMapFissureIndices:table = {};
		for y = 0, self.iGridH - 1, 1 do
			for x = 0, self.iGridW - 1, 1 do
				local i = y * self.iGridW + x;
				local plot = Map.GetPlotByIndex(i);
				if(plot ~= nil) then
					local featureType = plot:GetFeatureType();

					if(plot:IsImpassable() or featureType ~= g_FEATURE_NONE) then
						--No Feature
					else
						if (TerrainBuilder.CanHaveFeature(plot, g_FEATURE_GEOTHERMAL_FISSURE) == true) then
							if (not Map.FindSecondContinent(plot, 3)) then
								table.insert(aFullMapFissureIndices, i);
							end
						end
					end
				end
			end
		end
		if (#aFullMapFissureIndices > 0) then
			aShuffledIndices =  GetShuffledCopyOfTable(aFullMapFissureIndices);
			for i, index in ipairs(aShuffledIndices) do
				local pPlot = Map.GetPlotByIndex(index);
				TerrainBuilder.SetFeatureType(pPlot, g_FEATURE_GEOTHERMAL_FISSURE);
				self.iFissureCount = self.iFissureCount + 0.5;
				print ("Full-Map Fissure Placed at (x, y): " .. pPlot:GetX() .. ", " .. pPlot:GetY());
				if (self.iFissureCount >= iDesiredFissures) then
					break
				end
			end
		end
	end

	print("Number of Oasis: ", self.iOasisCount);
	print("Number of Fissures: ", self.iFissureCount)
end
------------------------------------------------------------------------------
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
						iFinalPercentNeeded = iFinalPercentNeeded / 5;
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
------------------------------------------------------------------------------
function FeatureGenerator:AddMarshAtPlot(plot, iX, iY)
	--Marsh Check. First see if it can place the feature.
	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_MARSH)) then
		if(math.ceil(self.iMarshCount * 100 / self.iNumLandPlots) <= self.iMarshMaxPercent) then
			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 300;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_MARSH);
				

			if (iAdjacent == 0 ) then
				iScore = iScore;
			elseif (iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 150;
			elseif (iAdjacent == 4) then
				iScore = iScore - 50;
			else
				iScore = iScore - 200;
			end
				
			if(TerrainBuilder.GetRandomNumber(450, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_MARSH);
				self.iMarshCount = self.iMarshCount + 1;

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
			local iScore = 300;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_HD_SWAMP);
				

			if (iAdjacent == 0 ) then
				iScore = iScore;
			elseif (iAdjacent == 1) then
				iScore = iScore + 100;
			elseif (iAdjacent == 2) then
				iScore = iScore - 100;
			elseif (iAdjacent == 3) then
				iScore = iScore - 150;
			elseif (iAdjacent == 4) then
				iScore = iScore - 200;
			else
				iScore = iScore - 250;
			end
				
			if(TerrainBuilder.GetRandomNumber(450, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_HD_SWAMP);
				self.iSwampCount = self.iSwampCount + 1;

				return true;
			end
		end
	end

	return false;
end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
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
			local iScore = 200;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_JNR_SAVANNAH);
				

			if (iAdjacent == 0 ) then
				iScore = iScore;
			elseif (iAdjacent == 1) then
				iScore = iScore + 110;
			elseif (iAdjacent == 2) then
				iScore = iScore + 190;
			elseif (iAdjacent == 3) then
				iScore = iScore + 210;
			elseif (iAdjacent == 4) then
				iScore = iScore - 140;
			else
				iScore = iScore - 430;
			end
				
			if(TerrainBuilder.GetRandomNumber(670, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_JNR_SAVANNAH);
				self.iSavannahCount = self.iSavannahCount + 1;

				return true;
			end
		end
	end

	return false;
end

------------------------------------------------------------------------------
function FeatureGenerator:AddJunglesAtPlot(plot, iX, iY)
	--Jungle Check. First see if it can place the feature.
	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_JUNGLE)) then
		if(iY >= self.iJungleBottom  and iY <= self.iJungleTop) then 
			self.iNumJunglablePlots = self.iNumJunglablePlots + 1;
			if(math.ceil(self.iJungleCount * 100 / self.iNumJunglablePlots) <= self.iJungleMaxPercent) then
				--Weight based on adjacent plots if it has more than 3 start subtracting
				local iScore = 300;
				local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_JUNGLE);

				if (iAdjacent == 0 ) then
					iScore = iScore;
				elseif (iAdjacent == 1) then
					iScore = iScore + 50;
				elseif (iAdjacent == 2 or iAdjacent == 3) then
					iScore = iScore + 150;
				elseif (iAdjacent == 4) then
					iScore = iScore - 50;
				else
					iScore = iScore - 200;
				end

				if(TerrainBuilder.GetRandomNumber(450, "Resource Placement Score Adjust") <= iScore) then
					TerrainBuilder.SetFeatureType(plot, g_FEATURE_JUNGLE);
					local terrainType = plot:GetTerrainType();

					if(terrainType == g_TERRAIN_TYPE_PLAINS_HILLS or terrainType == g_TERRAIN_TYPE_GRASS_HILLS) then
						TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS_HILLS);
					else
						TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS);
					end

					self.iJungleCount = self.iJungleCount + 1;
					return true;
				end
			end
		end
	end

	return false
end
------------------------------------------------------------------------------
function FeatureGenerator:AddForestsAtPlot(plot, iX, iY)
	--Forest Check. First see if it can place the feature.
	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_FOREST)) then
		if(math.ceil(self.iForestCount * 100 / self.iNumLandPlots) <= self.iForestMaxPercent) then
			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 300;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_FOREST);

			if (iAdjacent == 0 ) then
				iScore = iScore;
			elseif (iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 150;
			elseif (iAdjacent == 4) then
				iScore = iScore - 50;
			else
				iScore = iScore - 200;
			end
				
			if(TerrainBuilder.GetRandomNumber(450, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_FOREST);
				self.iForestCount = self.iForestCount + 1;
			end
		end
	end
end
------------------------------------------------------------------------------
function FeatureGenerator:AddReefAtPlot(plot, iX, iY)
	--Reef Check. First see if it can place the feature.
	local lat = math.abs((self.iGridH/2) - iY)/(self.iGridH/2)
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_REEF) and lat < self.iceLat * 0.9) then
		self.iNumReefablePlots = self.iNumReefablePlots + 1;
		if(math.ceil(self.iReefCount * 100 / self.iNumReefablePlots) <= self.iReefMaxPercent) then
				--Weight based on adjacent plots
				local iScore  = 3 * math.abs(iY - self.iNumEquator);
				local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_REEF);

				if (iAdjacent == 0 ) then
					iScore = iScore + 100;
				elseif (iAdjacent == 1) then
					iScore = iScore + 125;
				elseif (iAdjacent == 2) then
					iScore = iScore  + 150;
				elseif (iAdjacent == 3 or iAdjacent == 4) then
					iScore = iScore + 175;
				else
					iScore = iScore + 10000;
				end

				if(TerrainBuilder.GetRandomNumber(200, "Resource Placement Score Adjust") >= iScore) then
					TerrainBuilder.SetFeatureType(plot, g_FEATURE_REEF);
					self.iReefCount = self.iReefCount + 1;
				end
		end
	end
end
------------------------------------------------------------------------------
function FeatureGenerator:GetNumberAdjacentVolcanoes(iX, iY)
	
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