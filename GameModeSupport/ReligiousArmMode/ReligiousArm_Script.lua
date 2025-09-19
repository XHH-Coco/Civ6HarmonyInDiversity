ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

function GetCost(unit, percent)
	if unit == nil then
		return 0;
	end
	local unitInfo = GameInfo.Units[unit:GetType()];
	return math.ceil(percent * unitInfo.Combat);
end

GameEvents.HD_ReligiousArm_UniversalRestoration.Add(function (playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	local cost = GetCost(unit, GlobalParameters.RELIGIOUS_ARM_UNIVERSAL_RESTORATION_COST);
	local player = Players[playerId];
	if (player:GetReligion():GetFaithBalance() >= cost) and (unit:GetMovesRemaining() >= 3) then
		player:GetReligion():ChangeFaithBalance(-cost);
		UnitManager.ChangeMovesRemaining(unit, -3);
		local location = unit:GetLocation();
		local x = location.x;
		local y = location.y;
		local unitInfo = GameInfo.Units[unit:GetType()];
		local damage = unitInfo.Combat;
		for direction = 0, 5 do
			local plot = Map.GetAdjacentPlot(x, y, direction);
			if plot then
				for enemyUnit in Map.GetUnitsAt(plot):Units() do
					local owner = enemyUnit:GetOwner();
					if player:GetDiplomacy():IsAtWarWith(owner) then
						local enemyUnitInfo = GameInfo.Units[enemyUnit:GetType()];
						if (enemyUnitInfo.FormationClass == 'FORMATION_CLASS_LAND_COMBAT') or (enemyUnitInfo.FormationClass == 'FORMATION_CLASS_NAVAL') or (enemyUnitInfo.FormationClass == 'FORMATION_CLASS_AIR') then
							enemyUnit:ChangeDamage(damage);
						end
					end
				end
			end
		end
	end
end);

local PUNCITIVE_LAND_USED_KEY = 'PUNCITIVE_LAND_USED';
GameEvents.HD_ReligiousArm_PunctiveLand.Add(function (playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	local cost = GetCost(unit, GlobalParameters.RELIGIOUS_ARM_PUNCITIVE_LAND_COST);
	local player = Players[playerId];
	local turn = Game.GetCurrentGameTurn();
	local property = PUNCITIVE_LAND_USED_KEY .. turn;
	if (player:GetReligion():GetFaithBalance() >= cost) and (unit:GetProperty(property) == nil) then
		player:GetReligion():ChangeFaithBalance(-cost);
		unit:SetProperty(property, 1);
		UnitManager.RestoreMovement(unit);
	end
end);

local PROMISED_LAND_PENDING_KEY = 'PROMISED_LAND_PENDING';
local HORSES_INDEX = GameInfo.Resources['RESOURCE_HORSES'].Index;
GameEvents.HD_ReligiousArm_PromisedLand.Add(function (playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	local cost = GetCost(unit, GlobalParameters.RELIGIOUS_ARM_PUNCITIVE_LAND_COST);
	local player = Players[playerId];
	if (player:GetReligion():GetFaithBalance() >= cost) and (player:GetResources():GetResourceAmount(HORSES_INDEX) >= 5) then
		player:SetProperty(PROMISED_LAND_PENDING_KEY, unitId);
	end
end);

GameEvents.HD_ReligiousArm_PromisedLandTeleportSwitch.Add(function (playerId, unitId, x, y, distance)
	local unit = UnitManager.GetUnit(playerId, unitId);
	local cost = GetCost(unit, GlobalParameters.RELIGIOUS_ARM_PUNCITIVE_LAND_COST);
	local player = Players[playerId];
	if player:GetProperty(PROMISED_LAND_PENDING_KEY) ~= nil then
		player:SetProperty(PROMISED_LAND_PENDING_KEY, nil);
		player:GetReligion():ChangeFaithBalance(-cost);
		player:GetResources():ChangeResourceAmount(HORSES_INDEX, -5);
		local remaining = unit:GetMovesRemaining();
		UnitManager.PlaceUnit(unit, x, y);
		UnitManager.ChangeMovesRemaining(unit, remaining - distance);
	end
end);

GameEvents.HD_ReligiousArm_Pilgrim.Add(function (playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	local cost = GlobalParameters.RELIGIOUS_ARM_HD_PILGRIM_COST or 0;
	local player = Players[playerId];
	if player:GetReligion():GetFaithBalance() >= cost then
		local route = Utils.GetRouteTypeForPlayer(player);
		local location = unit:GetLocation();
		local x = location.x;
		local y = location.y;
		local plot = Map.GetPlot(x, y);
		player:GetReligion():ChangeFaithBalance(-cost);
		RouteBuilder.SetRouteType(plot, route);
	end
end);

GameEvents.HD_ReligiousArm_MindOverMatter.Add(function (playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	local cost = GetCost(unit, GlobalParameters.RELIGIOUS_ARM_HD_PILGRIM_COST);
	local player = Players[playerId];
	if player:GetReligion():GetFaithBalance() >= cost then
		player:GetReligion():ChangeFaithBalance(-cost);
		UnitManager.RestoreUnitAttacks(unit);
	end
end);

function playerFoundedBelief (playerId, beliefType)
	local religions = Game.GetReligion():GetReligions();
	for _, religion in ipairs(religions) do
		if religion.Founder == playerId then
			for _, beliefIndex in ipairs(religion.Beliefs) do
				if GameInfo.Beliefs[beliefIndex].BeliefType == beliefType then
					return true;
				end
			end
		end
	end
	return false;
end
function playerHasBelief (playerId, beliefType)
	local player = Players[playerId];
	if player:GetReligion() == nil then
		return false;
	end
	local religions = Game.GetReligion():GetReligions();
	for _, religion in ipairs(religions) do
		if religion.Religion == player:GetReligion():GetReligionInMajorityOfCities() then
			for _, beliefIndex in ipairs(religion.Beliefs) do
				if GameInfo.Beliefs[beliefIndex].BeliefType == beliefType then
					return true;
				end
			end
		end
	end
	return false;
end

-- Silkh Sword Baptism
function SilkhSwordBaptismUnitPromoted (playerId, unitId)
	if playerFoundedBelief(playerId, 'BELIEF_SILKH_SWORD_BAPTISM') then
		local unit = UnitManager.GetUnit(playerId, unitId);
		unit:ChangeDamage(-(GlobalParameters.SILKH_SWORD_BAPTISM_HEAL_AMOUNT or 0));
	end
end
Events.UnitPromoted.Add(SilkhSwordBaptismUnitPromoted);
function SilkhSwordBaptismUnitKilledInCombat (killedPlayerId, killedUnitId, playerId, unitId)
	if playerFoundedBelief(playerId, 'BELIEF_SILKH_SWORD_BAPTISM') then
		local player = Players[playerId];
		local killedPlayer = Players[killedPlayerId];
		if not killedPlayer:IsBarbarian() then
			if player:GetReligion():GetReligionInMajorityOfCities() ~= killedPlayer:GetReligion():GetReligionInMajorityOfCities() then
				local unit = UnitManager.GetUnit(playerId, unitId);
				unit:ChangeDamage(-(GlobalParameters.SILKH_SWORD_BAPTISM_HEAL_AMOUNT or 0));
			end
		end
	end
end
Events.UnitKilledInCombat.Add(SilkhSwordBaptismUnitKilledInCombat);

-- Capellani
function CapellaniUnitKilledInCombat (killedPlayerId, killedUnitId, playerId, unitId)
	if playerHasBelief(playerId, 'BELIEF_CAPELLANI') then
		local player = Players[playerId];
		local religion = player:GetReligion():GetReligionInMajorityOfCities();
		local unit = UnitManager.GetUnit(playerId, unitId);
		local location = unit:GetLocation();
		local amount = GlobalParameters.CAPELLANI_PRESSURE or 0;
		for _, cityOwner in ipairs(Players) do
			if cityOwner:GetCities() ~= nil then
				for _, city in cityOwner:GetCities():Members() do
					local cityLocation = city:GetLocation();
					if Map.GetPlotDistance(location.x, location.y, cityLocation.x, cityLocation.y) <= 6 then
						city:GetReligion():AddReligiousPressure(cityOwner:GetID(), religion, amount, cityOwner:GetID());
					end
				end
			end
		end
	end
end
Events.UnitKilledInCombat.Add(CapellaniUnitKilledInCombat);
function CapellaniCityConquered (newPlayerId, oldPlayerId, newCityId, x, y)
	if playerHasBelief(newPlayerId, 'BELIEF_CAPELLANI') then
		local city = CityManager.GetCity(newPlayerId, newCityId);
		local amount = (GlobalParameters.CAPELLANI_FAITH_PER_POPULATION or 0) * city:GetPopulation();
		local player = Players[newPlayerId];
		player:GetReligion():ChangeFaithBalance(amount);
		Game.AddWorldViewText(0, '+' .. amount .. ' [ICON_FAITH]', x, y);
	end
end
GameEvents.CityConquered.Add(CapellaniCityConquered);

function playerHasSuzerain (playerId, cityStateCivType)
	for minorPlayerId, player in pairs(Players) do
        influence = player:GetInfluence();
        if influence ~= nil and influence:CanReceiveInfluence() and influence:GetSuzerain() == playerId then
            local config = PlayerConfigurations[minorPlayerId];
            local civId = config:GetCivilizationTypeID();
            local civInfo = GameInfo.Civilizations[civId];
			if cityStateCivType == civInfo.CivilizationType then
				return true;
			end
        end
    end
	return false;
end

-- Jerusalem
function JerusalemCityConquered (newPlayerId, oldPlayerId, newCityId, x, y)
	local player = Players[newPlayerId];
	local religion = player:GetReligion():GetReligionInMajorityOfCities();
	if playerHasSuzerain(newPlayerId, 'CIVILIZATION_JERUSALEM') and (religion ~= nil) and (religion ~= -1) then
		local valid = false;
		for direction = -1, 5 do
			local plot;
			if direction == -1 then
				plot = Map.GetPlot(x, y);
			else
				plot = Map.GetAdjacentPlot(x, y, direction);
			end
			if plot then
				for unit in Map.GetUnitsAt(plot):Units() do
					if (unit:GetOwner() == newPlayerId) and (GameInfo.Units[unit:GetType()].PromotionClass == 'PROMOTION_CLASS_MONK') then
						valid = true;
						break;
					end
				end
			end
			if valid then
				break;
			end
		end
		if valid then
			local city = CityManager.GetCity(newPlayerId, newCityId);
			while city:GetReligion():GetMajorityReligion() ~= religion do
				city:GetReligion():AddReligiousPressure(newPlayerId, religion, 50, newPlayerId);
			end
		end
	end
end
GameEvents.CityConquered.Add(JerusalemCityConquered);