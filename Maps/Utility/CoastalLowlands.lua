include "TerrainGenerator"

-- Marks Coastal Lowlands for Civ VI XP2
--    These are areas that are susceptible to coastal flooding from XP2 environmental effects

function IsValidCoastalLowland(plot)
	if (plot:IsCoastalLand() == true) then
		if (not plot:IsHills()) then
			if (not plot:IsMountain()) then
				if (not plot:IsNaturalWonder()) then
					return true;
				end
			end
		end
	end
	return false;
end

function ScoreCoastalLowlandTiles()
	
	aaScoredTiles = {};
	local iW, iH = Map.GetGridSize();
	for i = 0, (iW * iH) - 1, 1 do
		plot = Map.GetPlotByIndex(i);
		if (plot) then
			if (IsValidCoastalLowland(plot)) then
				local featureType = plot:GetFeatureType();

				local iScore = 0;

			    -- An adjacent volcano or lake is also bad news
				if (GetNumberAdjacentVolcanoes(plot:GetX(), plot:GetY()) > 0) then
					iScore = 0;

				elseif (GetNumberAdjacentLakes(plot:GetX(), plot:GetY()) > 0) then
					iScore = 0;
				--elseif (GetNumberAdjacentMountains(plot:GetX(), plot:GetY()) > 0) then
				--	iScore = 0;
				-- Marsh is top-priority
				elseif (featureType == g_FEATURE_MARSH) then
					iScore = 1000;

				-- Floodplains are already dangerous, don't include them here
				elseif (featureType == g_FEATURE_FLOODPLAINS or featureType == g_FEATURE_FLOODPLAINS_GRASSLAND or featureType == g_FEATURE_FLOODPLAINS_PLAINS) then
					iScore = 0;

				-- All other tiles are chosen based on the weightings in this section:
				else
					-- Start with a mid-range base Score
					iScore = 500;

					-- Tiles near a River are prioritized heavily (to balance with the up-to-six occurrences of the factors below)
					if (plot:IsRiver()) then
						iScore = iScore + 200;
					end

					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
						if (adjacentPlot ~= nil) then
							
							local adjFeatureType = adjacentPlot:GetFeatureType();

							-- Tiles near Marsh or Floodplain are prioritized
							if (adjFeatureType == g_FEATURE_MARSH or adjFeatureType == g_FEATURE_FLOODPLAINS or adjFeatureType == g_FEATURE_FLOODPLAINS_GRASSLAND or adjFeatureType == g_FEATURE_FLOODPLAINS_PLAINS) then
								iScore = iScore + 50;
							end

							-- Tiles near Hills or Mountains are deprioritized
							if (adjacentPlot:IsHills() or adjacentPlot:IsMountain()) then
								iScore = iScore - 10;
							end

							-- Tiles with more adjacent Coast tiles are prioritized
							if (adjacentPlot:IsWater()) then

								-- If a Natural Wonder (Dead Sea?) don't allow it
								if (adjacentPlot:IsNaturalWonder()) then
									iScore = 0;
									break;
								else
									iScore = iScore + 50;
								end
							end
						end
					end
				end

				if (iScore > 0) then
					row = {};
					row.MapIndex = i;
					row.Score = iScore;
					table.insert(aaScoredTiles, row);
				end
			end
		end
	end

	return aaScoredTiles;
end

function MarkCoastalLowlands()

	print("Map Generation - Marking Coastal Lowlands");

	local numDesiredCoastalLowlandsPercentage = GlobalParameters.CACAPULCOTE_CHANGE_PERCENT_COASTAL_LOWLANDS or 35;

	scoredTiles = ScoreCoastalLowlandTiles();
	tilesToMark = math.floor((#scoredTiles * numDesiredCoastalLowlandsPercentage) / 100);
	
	if tilesToMark > 0 then
        table.sort (scoredTiles, function(a, b) return a.Score > b.Score; end);
		for tileIdx = 1, tilesToMark, 1 do
			local iElevation = 2;
			if (tileIdx <= tilesToMark / 3) then
				iElevation = 0;
			elseif (tileIdx <= (tilesToMark * 2) / 3) then
				iElevation = 1.2;
			end
			TerrainBuilder.AddCoastalLowland(scoredTiles[tileIdx].MapIndex, iElevation);
		end
		print(tostring(tilesToMark).." Coastal Lowland tiles added");
		print("  " .. tostring(GlobalParameters.CACAPULCOTE_CHANGE_PERCENT_COASTAL_LOWLANDS) .. "% of eligible coastal tiles");
	end
end