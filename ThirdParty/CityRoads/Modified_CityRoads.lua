ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

local m_Tech_Wheel = GameInfo.Technologies['TECH_THE_WHEEL'].Index;
local city_roads_require_wheel = GlobalParameters.HD_CITY_ROADS_REQUIRE_WHEEL;
function OnImprovementAddedToMap(locationX, locationY, improvementType, eImprovementOwner, resource, isPillaged, isWorked)
	local plot = Map.GetPlot(locationX,locationY);
	local owner = plot:GetOwner();
	if owner >= 0 and owner == eImprovementOwner and not plot:IsWater() then 
		local player = Players[owner];
		local playerTechs = player:GetTechs();
		-- enable the improvements roads after researching TECH_THE_WHEEL
		if playerTechs:HasTech(m_Tech_Wheel) or (city_roads_require_wheel == 0) then
			local era = GameInfo.Eras[player:GetEra()];
			local currentRouteType = plot:GetRouteType(plot);
			local playerRouteType = Utils.GetRouteTypeForPlayer(player);
			if currentRouteType == RouteTypes.NONE or Utils.CompareRoutes(playerRouteType,currentRouteType) then
				RouteBuilder.SetRouteType(plot, playerRouteType);
			end
		end
	end
end

function OnResearchCompleted(ePlayer, eTech)
	-- print('CityRoads:OnResearchCompleted:', 'Player', ePlayer, 'Tech', eTech);
	if ePlayer >= 0 and (eTech == m_Tech_Wheel) and (city_roads_require_wheel ~= 0) then
		-- place roads on the improvements roads after researching TECH_THE_WHEEL
		local player = Players[ePlayer];
		if not player:IsBarbarian() then
			local pCities = player:GetCities();
			local pCity;
			for i, pCity in pCities:Members() do
				local playerRouteType = Utils.GetRouteTypeForPlayer(player);
				local pPlots = pCity:GetOwnedPlots();
				for key, plot in pairs(pPlots) do
					if plot and not plot:IsWater() and plot:GetImprovementType() >= 0 then
						local currentRouteType = plot:GetRouteType(plot);
						if currentRouteType == RouteTypes.NONE or Utils.CompareRoutes(playerRouteType,currentRouteType) then
							RouteBuilder.SetRouteType(plot, playerRouteType);
						end
					end
				end
			end
		end
	end
end

function initialize()
	Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap);
	Events.ResearchCompleted.Add(OnResearchCompleted);
end
Events.LoadGameViewStateDone.Add(initialize);