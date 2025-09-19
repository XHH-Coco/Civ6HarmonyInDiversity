include("SupportFunctions");
function GetCost(unit, percent)
	if unit == nil then
		return 0;
	end
	local unitInfo = GameInfo.Units[unit:GetType()];
	return math.ceil(percent * unitInfo.Combat);
end

ExposedMembers.GameEvents.HD_ReligiousArm_PromisedLand.Add(function (playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	local cost = GetCost(unit, GlobalParameters.RELIGIOUS_ARM_PUNCITIVE_LAND_COST);
	local player = Players[playerId];
	if (player:GetReligion():GetFaithBalance() >= cost) and (unit:GetMovesRemaining() > 0) then
		UILens.ClearLayerHexes(UILens.CreateLensLayerHash("Hex_Coloring_Great_People"));
		if UILens.IsLayerOn(UILens.CreateLensLayerHash("Hex_Coloring_Great_People")) then
			UILens.ToggleLayerOff(UILens.CreateLensLayerHash("Hex_Coloring_Great_People"));
		end
		local location = unit:GetLocation();
		local activationPlots = {};
		for _, plot in ipairs(Map.GetNeighborPlots(location.x, location.y, unit:GetMovesRemaining())) do
			table.insert(activationPlots, {"Great_People", plot:GetIndex()});
		end
		UILens.SetLayerHexesArea(UILens.CreateLensLayerHash("Hex_Coloring_Great_People"), Game.GetLocalPlayer(), {}, activationPlots);
		UILens.ToggleLayerOn(UILens.CreateLensLayerHash("Hex_Coloring_Great_People"));
		UI.SetInterfaceMode(InterfaceModeTypes.WB_SELECT_PLOT);
	end
end);

local PROMISED_LAND_PENDING_KEY = 'PROMISED_LAND_PENDING';
function ReligiousArmSelectPlot(plotId, plotEdge, boolParam)
	local localPlayerId = Game.GetLocalPlayer();
	local player = Players[localPlayerId];
	local pending = player:GetProperty(PROMISED_LAND_PENDING_KEY);
	if not pending then
		return;
	end
	if UILens.IsLayerOn(UILens.CreateLensLayerHash("Hex_Coloring_Great_People")) then
		UILens.ToggleLayerOff(UILens.CreateLensLayerHash("Hex_Coloring_Great_People"));
	end
	local unit = UnitManager.GetUnit(localPlayerId, pending);
	local location = unit:GetLocation();
	local target = Map.GetPlotByIndex(plotId);
	local distance = Map.GetPlotDistance(location.x, location.y, target:GetX(), target:GetY());
	if distance <= unit:GetMovesRemaining() then
		ExposedMembers.GameEvents.HD_ReligiousArm_PromisedLandTeleportSwitch.Call(localPlayerId, pending, target:GetX(), target:GetY(), distance);
	end
	UILens.ToggleLayerOff(UILens.CreateLensLayerHash("Hex_Coloring_Great_People"));
	UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
end
LuaEvents.WorldInput_WBSelectPlot.Add(ReligiousArmSelectPlot);