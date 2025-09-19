ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

function OnImprovementAddedToMap(locationX, locationY, improvementType, eImprovementOwner, resource, isPillaged, isWorked)
	local plot = Map.GetPlot(locationX,locationY);
	local owner = plot:GetOwner();
	if owner >= 0 and owner == eImprovementOwner and not plot:IsWater() then 
		local player = Players[owner];
		local era = GameInfo.Eras[player:GetEra()];
		local currentRouteType = plot:GetRouteType(plot);
		local playerRouteType = Utils.GetRouteTypeForPlayer(player);
		if currentRouteType == RouteTypes.NONE or Utils.CompareRoutes(playerRouteType,currentRouteType) then
			RouteBuilder.SetRouteType(plot, playerRouteType);
		end
	end
end

Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap);