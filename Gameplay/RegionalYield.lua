GameEvents = ExposedMembers.GameEvents;
Utils = ExposedMembers.DLHD.Utils;

local MAGNUS_HASH = GameInfo.Governors['GOVERNOR_THE_RESOURCE_MANAGER'].Hash;
local VERTICAL_INTEGRATION_HASH = GameInfo.GovernorPromotions['GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION'].Hash;
local CITY_CENTER_INDEX = GameInfo.Districts['DISTRICT_CITY_CENTER'].Index;
local NEIGHBORHOOD_INDEX = GameInfo.Districts['DISTRICT_NEIGHBORHOOD'].Index;
local MBANZA_INDEX = GameInfo.Districts['DISTRICT_MBANZA'].Index;
local JAMES_WATT_ACTIVATION_TIME_KEY = 'JAMES_WATT_ACTIVATION_TIME';
local SANG_HONGYANG_ACTIVATION_TIME_KEY = 'SANG_HONGYANG_ACTIVATION_TIME';
local ENOUGH_IRON_KEY = 'PLAYER_HAS_ENOUGH_RESOURCE_IRON';
function RefreshRegionalYield (playerId)
	local player = Players[playerId];

	-- Initialize
	local cityCanRecieve = {};
	local cityCanGive = {};
	for _, city in player:GetCities():Members() do
		cityCanRecieve[city:GetID()] = {};
		cityCanGive[city:GetID()] = {};
	end

	-- Get building range info
	local buildingRange = {};
	for row in GameInfo.HD_BuildingRegionalRange() do
		local buildingInfo = GameInfo.Buildings[row.BuildingType];
		buildingRange[buildingInfo.Index] = {
			regionalRange = row.RegionalRange,
			buildingType = row.BuildingType,
			prereqDistrict = buildingInfo.PrereqDistrict
		};
	end
	-- Get Magnus Location
	local magnusCity;
	local governors = player:GetGovernors();
    local governor = governors:GetGovernor(MAGNUS_HASH);
	if governor ~= nil and governor:HasPromotion(VERTICAL_INTEGRATION_HASH) and governor:IsEstablished() then
		magnusCity = governor:GetAssignedCity():GetID();
	end

	-- Policy Cards
	for i = 0, player:GetCulture():GetNumPolicySlots() - 1 do
		local policyIndex = player:GetCulture():GetSlotPolicy(i);
		if policyIndex ~= nil and policyIndex ~= -1 then
			local policyInfo = GameInfo.Policies[policyIndex];
			for row in GameInfo.HD_PolicyRegionalRange() do
				if row.PolicyType == policyInfo.PolicyType then
					for _, info in pairs(buildingRange) do
						if info.prereqDistrict == row.DistrictType then
							info.regionalRange = info.regionalRange + row.RegionalRange;
						end
					end
				end
			end
		end
	end

	-- James Watt
	local watt = player:GetProperty(JAMES_WATT_ACTIVATION_TIME_KEY) or 0;
	for _, info in pairs(buildingRange) do
		if info.prereqDistrict == 'DISTRICT_INDUSTRIAL_ZONE' then
			info.regionalRange = info.regionalRange + 3 * watt;
		end
	end

	-- Sang Hongyang
	local hongyang = player:GetProperty(SANG_HONGYANG_ACTIVATION_TIME_KEY) or 0;
	for _, info in pairs(buildingRange) do
		if info.buildingType == 'BUILDING_JNR_MINT' then
			info.regionalRange = info.regionalRange + 1 * hongyang;
		end
	end

	-- Check if city can recieve / give (to Magnus) bonus
	for _, city in player:GetCities():Members() do
		for index, info in pairs(buildingRange) do
			if city:GetBuildings():HasBuilding(index) and (not city:GetBuildings():IsPillaged(index)) then
				local location = Map.GetPlotByIndex(Utils.GetBuildingLocation(playerId, city:GetID(), index));
				local regionalRange = info.regionalRange;
				
				for _, targetCity in player:GetCities():Members() do
					local inRange = false;
					for _, district in targetCity:GetDistricts():Members() do
						if (district:GetType() == CITY_CENTER_INDEX) or (district:GetType() == NEIGHBORHOOD_INDEX) or (district:GetType() == MBANZA_INDEX) then
							local targetLocation = district:GetLocation();
							local distance = Map.GetPlotDistance(location:GetX(), location:GetY(), targetLocation.x, targetLocation.y);
							if distance <= regionalRange then
								inRange = true;
								break;
							end
						end
					end
					if inRange then
						if (magnusCity == nil) or (targetCity:GetID() ~= magnusCity) then
							cityCanRecieve[targetCity:GetID()][index] = 1;
						else
							cityCanGive[city:GetID()][index] = 1;
						end
					end
				end
			end
		end
	end

	-- Set Property
	for _, city in player:GetCities():Members() do
		for index, info in pairs(buildingRange) do
			local location = city:GetLocation();
			GameEvents.SetPlotPropertySwitch.Call(location.x, location.y, 'CITY_CAN_RECIEVE_' .. info.buildingType .. '_REGIONAL_BONUS', cityCanRecieve[city:GetID()][index] or 0);
			GameEvents.SetPlotPropertySwitch.Call(location.x, location.y, 'CITY_CAN_GIVE_' .. info.buildingType .. '_REGIONAL_BONUS_TO_MAGNUS', cityCanGive[city:GetID()][index] or 0);
		end
	end
end

local pendingRefresh = {};
function RefreshRegionalYieldIfPending (playerId)
	if (pendingRefresh[playerId] == nil) or (pendingRefresh[playerId] == 1) then
		RefreshRegionalYield(playerId);
		pendingRefresh[playerId] = 0;
	end
end
function pendRefresh (playerId)
	pendingRefresh[playerId] = 1;
end
function Initialize ()
	Utils.RefreshRegionalYield = pendRefresh;
	Events.CityWorkerChanged.Add(function (playerId, cityId, x, y)
		RefreshRegionalYieldIfPending(playerId);
	end);
	GameEvents.PlayerTurnStartComplete.Add(RefreshRegionalYield);
	GameEvents.PlayerTurnStarted.Add(RefreshRegionalYield);
	Events.BuildingAddedToMap.Add(function (x, y, buildingId, playerId, misc2, misc3)
		pendingRefresh[playerId] = 1;
	end);
	GameEvents.BuildingPillageStateChanged.Add(function (playerId, cityId, buildingId, pillageState)
		pendingRefresh[playerId] = 1;
	end);
	Events.DistrictAddedToMap.Add(function (playerId, districtId, cityId, x, y, districtType, percentComplete)
		pendingRefresh[playerId] = 1;
	end);
	Events.DistrictRemovedFromMap.Add(function (playerId, districtId, cityId, x, y, districtType)
		pendingRefresh[playerId] = 1;
	end);
	Events.CityAddedToMap.Add(function (playerId, cityId, x, y)
		pendingRefresh[playerId] = 1;
	end);
	Events.GovernorEstablished.Add(function (cityOwner, cityId, governorOwner, governorId)
		pendingRefresh[governorOwner] = 1;
	end);
	Events.GovernorPromoted.Add(function (playerId, governorId, promotionId)
		pendingRefresh[playerId] = 1;
	end);
	Events.GovernorChanged.Add(function (playerId, governorId)
		pendingRefresh[playerId] = 1;
	end);
	Events.GovernmentPolicyChanged.Add(function (playerId, policyId)
		pendingRefresh[playerId] = 1;
	end);
	Events.UnitGreatPersonActivated.Add(function (playerId, unitId, greatPersonClassId, greatPersonIndividualId)
		pendingRefresh[playerId] = 1;
	end);
end

Initialize();