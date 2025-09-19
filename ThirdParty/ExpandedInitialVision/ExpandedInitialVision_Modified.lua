local PROP_KEY_EXPANDED_INIT_VISION = "ExpandedInitVision";

function RevealArea()
	-- Only done once.
	if Game.GetProperty(PROP_KEY_EXPANDED_INIT_VISION) == 1 then
		return;
	end
	Game.SetProperty(PROP_KEY_EXPANDED_INIT_VISION, 1);

	--Set desired sight radius using GlobalParameters
	local base_rad = GlobalParameters.EXPANDED_INIT_VISION_RANGE;
	
	local majors = PlayerManager.GetAliveMajorIDs();
	for _, player_id in ipairs(majors) do
		local player = Players[player_id];
		local pVis = PlayersVisibility[player_id];
		local playerConfig = PlayerConfigurations[player_id];
		local sLeader = playerConfig:GetLeaderTypeName();
		local rad = base_rad;
		for tRow in GameInfo.LeaderTraits() do
			-- Maya with 3 more vision
	        if (tRow.LeaderType == sLeader and tRow.TraitType == 'TRAIT_LEADER_MUTAL') then
	            rad = rad + 3;
	        end
	    end
		local pPlot = player:GetStartingPlot();
		local tPlots = GetValidPlotsInRadiusR(pPlot, rad);
		
		for k, pPickPlot in ipairs(tPlots) do
			
			--If there is a natural wonder on the tile, do not reveal. Any amount of revealing this tile will not allow the wonder discovery eureka during game.
			if(pPickPlot:IsNaturalWonder()) then
				print("wonder on tile - not revealing tile");

			--If there is a unit on the tile, do not remove FOW. This avoids the diplomatic meet event.
			elseif(pPickPlot:GetUnitCount() > 0 or pPickPlot:IsCity()) then
				pVis:ChangeVisibilityCount(pPickPlot:GetIndex(), 0);
				print("unit or city on tile - revealing tile, not removing FOW");

			--If there is no unit or wonder, temporarily remove FOW so that the resouce icon will show.
			else
				pVis:ChangeVisibilityCount(pPickPlot:GetIndex(), 1);
				pVis:ChangeVisibilityCount(pPickPlot:GetIndex(), -1);
				-- print("no unit or wonder on tile - revealing tile, temporarily removing FOW");
			end
	    end
	end
end

function GetValidPlotsInRadiusR(pPlot, iRadius)
	local tTempTable = {}
	if pPlot ~= nil then
		local iPlotX, iPlotY = pPlot:GetX(), pPlot:GetY()
		for dx = (iRadius * -1), iRadius do
			for dy = (iRadius * -1), iRadius do
				local pNearPlot = Map.GetPlotXYWithRangeCheck(iPlotX, iPlotY, dx, dy, iRadius);
				if pNearPlot then
					table.insert(tTempTable, pNearPlot)
				end
			end
		end
	end
	return tTempTable;
end

RevealArea();