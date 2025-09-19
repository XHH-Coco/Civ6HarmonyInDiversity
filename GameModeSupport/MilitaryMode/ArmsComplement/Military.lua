--------------------------------
--     Military Gameplay      --
--------------------------------
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- Start debug
function EarnMoneyOnConquerCity( capturerID, ownerID, cityID, cityX, cityY )
    local cPlayer = Players[ownerID]
    local pPlayer = Players[capturerID]
    local conquerCity = CityManager.GetCityAt(cityX, cityY)
    local citizen = conquerCity:GetPopulation()
    local buildingID = GameInfo.Buildings['BUILDING_GOV_CONQUEST'].Index
    if cPlayer ~= nil and pPlayer ~= nil and conquerCity ~= nil and citizen ~= nil then 
        local amount = citizen * GlobalParameters.OCCUPATION_GOLD_PER_POP
        if (Utils.HasBuildingWithinCountry(capturerID, buildingID)) then
            amount = amount * 2
        end
        Utils.ChangeGoldBalance(capturerID, amount)
        local message = '[COLOR:ResGoldLabelCS]+' .. tostring(amount) .. '[ENDCOLOR][ICON_Gold]'
        Game.AddWorldViewText(0, message, conquerCity:GetX(), conquerCity:GetY())
    end
end

GameEvents.CityConquered.Add(EarnMoneyOnConquerCity);

function EngineerAutoRoad(iPlayerID,iUnitID,iX,iY,locallyVisible,stateChange)
    local pPlayer = Players[iPlayerID];
    local pUnit = UnitManager.GetUnit(iPlayerID, iUnitID);
    local plot = Map.GetPlot(iX, iY);

    if(plot:IsWater())then
        return
    end

    if(pUnit == nil)then
        return
    end

    if(GameInfo.Units[pUnit:GetType()].UnitType ~= "UNIT_SAPPER") and
    (GameInfo.Units[pUnit:GetType()].UnitType ~= "UNIT_MILITARY_ENGINEER") and
    (GameInfo.Units[pUnit:GetType()].UnitType ~= "UNIT_ENGINEER_CORP")then
        return
    end

    local currentRouteType = plot:GetRouteType(plot);
    local playerRouteType = Utils.GetRouteTypeForPlayer(pPlayer);
    if currentRouteType == RouteTypes.NONE or Utils.CompareRoutes(playerRouteType,currentRouteType) then
        RouteBuilder.SetRouteType(plot, playerRouteType);
    end
end

Events.UnitMoved.Add(EngineerAutoRoad);