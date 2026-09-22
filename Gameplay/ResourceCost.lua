local TARGET_RANGE = GameInfo.Buildings['BUILDING_JNR_TARGET_RANGE'];
function GetResourceCost (playerId)
	local player = Players[playerId];
	local costs = {};
	for row in GameInfo.Resources() do
		if row.ResourceClassType == 'RESOURCECLASS_STRATEGIC' then
			local sum = 0;
			for _, city in player:GetCities():Members() do
				local buildings = city:GetBuildings();
				if (row.ResourceType == 'RESOURCE_HORSES') and (TARGET_RANGE ~= nil) and (buildings:HasBuilding(TARGET_RANGE.Index)) then
					sum = sum + 2;
				end
				if (row.ResourceType == 'RESOURCE_IRON') and (TARGET_RANGE ~= nil) and (buildings:HasBuilding(TARGET_RANGE.Index)) then
					sum = sum + 2;
				end
			end
			table.insert(costs, {
				id = row.Index,
				type = row.ResourceType,
				cost = sum
			});
		end
	end
	return costs;
end

local ENOUGH_RESOURCE_KEY = 'PLAYER_HAS_ENOUGH_';
function RefreshResourceCost (playerId, doReduce)
	local player = Players[playerId];
	if not player:IsMajor() then
		return;
	end
	local cost = GetResourceCost(playerId);
	for _, v in ipairs(cost) do
		local amount = player:GetResources():GetResourceAmount(v.id);
		if amount >= v.cost then
			player:SetProperty(ENOUGH_RESOURCE_KEY .. v.type, 1);
		else
			player:SetProperty(ENOUGH_RESOURCE_KEY .. v.type, 0);
		end
		for _, city in player:GetCities():Members() do
			local location = city:GetLocation();
			local cityPlot = Map.GetPlot(location.x, location.y);
			if amount >= v.cost then
				cityPlot:SetProperty(ENOUGH_RESOURCE_KEY .. v.type, 1);
			else
				cityPlot:SetProperty(ENOUGH_RESOURCE_KEY .. v.type, 0);
			end
		end
		if doReduce and (amount >= v.cost) and (v.cost > 0) then
			player:GetResources():ChangeResourceAmount(v.id, -v.cost);
		end
	end
end

local sync = false;
function SyncRefreshResourceCost (playerId, doReduce)
	if sync then
		return;
	end
	sync = true;
	local error, msg = pcall(RefreshResourceCost, playerId, doReduce);
	if not error then
		print(msg);
	end
	sync = false;
end

GameEvents.PlayerTurnStartComplete.Add(function (playerId)
	SyncRefreshResourceCost(playerId, false);
end);
GameEvents.PlayerTurnStarted.Add(function (playerId)
	SyncRefreshResourceCost(playerId, true);
end);