include("WorldInput_Expansion2");
include("HD_Improvements");

function OnMouseBuildImprovementAdjacentEnd( pInputStruct:table )
	-- If a drag was occurring, end it; otherwise raise event.
	if g_isMouseDragging then
		g_isMouseDragging = false;
	elseif IsSelectionAllowedAt(UI.GetCursorPlotID()) then
		local plot = Map.GetPlotByIndex(UI.GetCursorPlotID());
		local improvementHash = UI.GetInterfaceModeParameter(UnitOperationTypes.PARAM_IMPROVEMENT_TYPE)
		if plot and CanBuildOnResourceWithSpecificTerrainOrFeature(improvementHash, plot) then
			BuildImprovementAdjacent(pInputStruct);
		end
	end
	EndDragMap();
	g_isMouseDownInWorld = false;
	return true;
end

function OnInterfaceModeChange_BuildImprovementAdjacent( eNewMode:number )
  print("OnInterfaceModeChange_BuildImprovementAdjacent")
	UIManager:SetUICursor(CursorTypes.RANGE_ATTACK);
	local pSelectedUnit = UI.GetHeadSelectedUnit();
	local eOperation = UI.GetInterfaceModeParameter(UnitOperationTypes.PARAM_OPERATION_TYPE);
	local tParameters = {};
	tParameters[UnitOperationTypes.PARAM_IMPROVEMENT_TYPE] = UI.GetInterfaceModeParameter(UnitOperationTypes.PARAM_IMPROVEMENT_TYPE);
	local tResults = UnitManager.GetOperationTargets(pSelectedUnit, eOperation, tParameters);
	local allPlots = tResults[UnitOperationResults.PLOTS];
	if allPlots then
		g_targetPlots = {};

    for _, plotIndex in pairs(allPlots) do
			local plot = Map.GetPlotByIndex(plotIndex);
			if plot and CanBuildOnResourceWithSpecificTerrainOrFeature(tParameters[UnitOperationTypes.PARAM_IMPROVEMENT_TYPE], plot) then
				table.insert(g_targetPlots, plotIndex)
			end
    end

		-- Highlight the plots available to attack a priority target
		if (table.count(g_targetPlots) ~= 0) then
			local pOverlay:object = UILens.GetOverlay("PlacementValidOverlay");
			if pOverlay ~= nil then
				pOverlay:CreateSprites( g_targetPlots, "Placement_Valid", 0 );
			end
		end
	end
end
