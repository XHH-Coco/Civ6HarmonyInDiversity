local GovernmentSlotSortIndex = {
  SLOT_MILITARY = 1,
  SLOT_ECONOMIC = 2,
  SLOT_DIPLOMATIC = 3,
  SLOT_GREAT_PERSON = 4,
  SLOT_WILDCARD = 5
};

function GetUnlockableItems(playerId)
	
	local has_trait = GetTraitMapForPlayer(playerId);	-- Get the player trait map (expensive to calculate)

	local unlockables = {};
	
	for row in GameInfo.Governments() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.GovernmentType, row.Name, row.GovernmentType});
		end
	end

  -----------------------------------------------------------------------------------------
  -- 政策卡排序
  local policyList = {};
	for row in GameInfo.Policies() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(policyList, {row, row.PolicyType, row.Name, row.PolicyType});
		end
	end

  table.sort(policyList, function(a, b)
    local aSortIndex = GovernmentSlotSortIndex[a[1].GovernmentSlotType] or 1000;
    local bSortIndex = GovernmentSlotSortIndex[b[1].GovernmentSlotType] or 1000;
    return aSortIndex < bSortIndex;
  end)

  for _, policy in ipairs(policyList) do
    table.insert(unlockables, policy);
  end
  -----------------------------------------------------------------------------------------
		
	for row in GameInfo.Districts() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.DistrictType, row.Name, row.DistrictType});
		end
	end

  -----------------------------------------------------------------------------------------
  -- 建筑 奇观 排序
  local buildingList = {}
  for row in GameInfo.Buildings() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(buildingList, {row, row.BuildingType, row.Name, row.BuildingType});
		end
	end

  table.sort(buildingList, function(a, b)
    local aSortIndex = a[1].IsWonder and 2 or 1;
    local bSortIndex = b[1].IsWonder and 2 or 1;
    return aSortIndex < bSortIndex;
  end)

  for _, building in ipairs(buildingList) do
    table.insert(unlockables, building);
  end
  -----------------------------------------------------------------------------------------

	for row in GameInfo.Units() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.UnitType, row.Name, row.UnitType});
		end
	end

	for row in GameInfo.Improvements() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.ImprovementType, row.Name, row.ImprovementType});
		end
	end

	for row in GameInfo.Projects() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.ProjectType, row.Name, row.ProjectType});
		end
	end

	for row in GameInfo.Resources() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.ResourceType, row.Name, row.ResourceType});
		end
	end

	for row in GameInfo.DiplomaticActions() do
		if(CanEverUnlock(has_trait, row)  and row.Name ~= nil) then
			table.insert(unlockables, {row, row.DiplomaticActionType, row.Name, row.CivilopediaKey});
		end
	end

  if (GameInfo.Routes_XP2 ~= nil) then
		for row in GameInfo.Routes_XP2() do
			if(CanEverUnlock(has_trait, row)) then
				local baseTableRow = GameInfo.Routes[row.RouteType];
				if (baseTableRow ~= nil) then
					table.insert(unlockables, {row, row.RouteType, baseTableRow.Name, row.RouteType});
				end
			end
		end
	end

	return unlockables;
end