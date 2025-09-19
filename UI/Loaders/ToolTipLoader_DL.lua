-- Cache original GetDistrictToolTip.
Base_GetDistrictToolTip = ToolTipHelper.GetDistrictToolTip;

-------------------------------------------------------------------------------
ToolTipHelper.GetDistrictToolTip = function(districtType)

    -- ToolTip Format
    -- <Name>
    -- <Static Description>
    -- <Great Person Points>
    local district = GameInfo.Districts[districtType];

    local name = district.Name;
    local description = district.Description;

    local replaces_district;
    local replaces = GameInfo.DistrictReplaces[districtType];
    if(replaces) then
        replaces_district = GameInfo.Districts[replaces.ReplacesDistrictType];
    end
    
    -- Build ze tip!
    -- Build the tool tip line by line.
    local toolTipLines = {};
    table.insert(toolTipLines, Locale.ToUpper(name));

    if(replaces_district) then
        table.insert(toolTipLines, Locale.Lookup("LOC_DISTRICT_NAME_REPLACES", replaces_district.Name));
    else
        table.insert(toolTipLines, Locale.Lookup("LOC_DISTRICT_NAME"));
    end

    -----------------------------------------------------------------------------------
    -- add specilty district
    if (district.RequiresPopulation) then
        table.insert(toolTipLines, Locale.Lookup("LOC_DISTRICT_HD_IS_SPECIALTY_DISTRICT"));
    else
        table.insert(toolTipLines, Locale.Lookup("LOC_DISTRICT_HD_IS_NOT_SPECIALTY_DISTRICT"));
    end
    -----------------------------------------------------------------------------------
    
    if(not Locale.IsNilOrWhitespace(description)) then
        table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description));
    end

    local stats = {};
    -----------------------------------------------------------------------------------
    -- add Great Person Points of District Citizens
    for row in GameInfo.District_GreatPersonPoints() do
        if(row.DistrictType == districtType) then
            local gpClass = GameInfo.GreatPersonClasses[row.GreatPersonClassType];
            if(gpClass) then
                table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_GREAT_PERSON_POINTS", row.PointsPerTurn, gpClass.IconString, gpClass.Name));
            end
        end
    end
    -----------------------------------------------------------------------------------

    if(district.Housing ~= 0) then
        table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_HOUSING", district.Housing));
    end

    if(district.Entertainment ~= 0) then
        table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_AMENITY_ENTERTAINMENT", district.Entertainment));
    end

    local airSlots = district.AirSlots or 0;
    if(airSlots ~= 0) then
        table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_AIRSLOTS", airSlots));
    end

    local citizens = tonumber(district.CitizenSlots) or 0;
    if(citizens ~= 0) then
        table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_CITIZENSLOTS", citizens));
    end

    local adjacency_yields = ToolTipHelper.GetAdjacencyBonuses(GameInfo.District_Adjacencies, "DistrictType", districtType)
    if(adjacency_yields) then
        for i,v in ipairs(adjacency_yields) do
            table.insert(stats, v);
        end
    end

    local citizen_yields = {};
    for row in GameInfo.District_CitizenYieldChanges() do
        if(row.DistrictType == districtType) then
            local yield = GameInfo.Yields[row.YieldType];
            if(yield) then
                table.insert(citizen_yields, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_YIELD", row.YieldChange, yield.IconString, yield.Name));
            end
        end
    end

    for row in GameInfo.District_CitizenGreatPersonPoints() do
        if(row.DistrictType == districtType) then
            local gpClass = GameInfo.GreatPersonClasses[row.GreatPersonClassType];
            local amount = row.PointsPerTurn * 2
            if(gpClass) then
                table.insert(citizen_yields, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_GREAT_PERSON_POINTS", amount, gpClass.IconString, gpClass.Name));
            end
        end
    end

    for i,v in ipairs(stats) do
        if(i == 1) then
            table.insert(toolTipLines, "[NEWLINE]" .. v);
        else
            table.insert(toolTipLines, v);
        end
    end

    for i,v in ipairs(citizen_yields) do
        if(i == 1) then
            table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_DISTRICT_CITIZEN_YIELDS_HEADER"));
            table.insert(toolTipLines, v);
        else
            table.insert(toolTipLines, v);
        end
    end

    if (district.NoAdjacentCity) then
        table.insert(toolTipLines, Locale.Lookup("LOC_DISTRICT_REQUIRE_NOT_ADJACENT_TO_CITY"));
    end
    -- Return the composite tooltip!
    return table.concat(toolTipLines, "[NEWLINE]");

end

g_ToolTipGenerators.KIND_DISTRICT = ToolTipHelper.GetDistrictToolTip;


-- Cache original GetBuildingToolTip.
Base_GetBuildingToolTip = ToolTipHelper.GetBuildingToolTip;
-------------------------------------------------------------------------------
ToolTipHelper.GetBuildingToolTip = function(buildingHash, playerId, city)
    
    -- ToolTip Format
    -- <Name>
    -- <Static Description>
    -- <Great Person Points>
    -- <RequiredDistrict>
    -- <RequiredAdjacentDistrict>
    local building = GameInfo.Buildings[buildingHash];
    

    local buildingType:string = "";
    if (building ~= nil) then
        buildingType = building.BuildingType;
    end

    if buildingType:match "^BUILDING_CITY_POLICY_" then
        return ToolTipHelper.GetCityPolicyToolTip(buildingHash, playerId, city);
    end

    local name = building.Name;
    local description = building.Description;

    local district = nil;
    if city ~= nil then
        district = city:GetDistricts():GetDistrict(building.PrereqDistrict);
    end

    -- Build ze tip!
    -- Build the tool tip line by line.
    local toolTipLines = {};
    table.insert(toolTipLines, Locale.ToUpper(name));

    local replaces_building;
    local replaces = GameInfo.BuildingReplaces[buildingType];
    if(replaces) then
        replaces_building = GameInfo.Buildings[replaces.ReplacesBuildingType];
    end

    if(building.MaxWorldInstances ~= -1) then
        if(replaces_building) then
            table.insert(toolTipLines, Locale.Lookup("LOC_WONDER_NAME_REPLACES", replaces_building.Name));
        else
            table.insert(toolTipLines, Locale.Lookup("LOC_WONDER_NAME"));
        end
    else
        if(replaces_building) then
            table.insert(toolTipLines, Locale.Lookup("LOC_BUILDING_NAME_REPLACES", replaces_building.Name));
        else
            table.insert(toolTipLines, Locale.Lookup("LOC_BUILDING_NAME"));
        end
    end

    local stats = {};

    AddBuildingYieldTooltip(buildingHash, city, stats);

    for row in GameInfo.Building_YieldDistrictCopies() do
        if(row.BuildingType == buildingType) then
            local from = GameInfo.Yields[row.OldYieldType];
            local to = GameInfo.Yields[row.NewYieldType];

            table.insert(stats, Locale.Lookup("LOC_TOOLTIP_BUILDING_DISTRICT_COPY", to.IconString, to.Name, from.IconString, from.Name));
        end
    end

    local housing = building.Housing or 0;
    if(housing ~= 0) then
        table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_HOUSING", housing));
    end

    AddBuildingEntertainmentTooltip(buildingHash, city, district, stats);

    local citizens = building.CitizenSlots or 0;
    if(citizens ~= 0) then
        table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_CITIZENS", citizens));
    end

    local defense = building.OuterDefenseHitPoints or 0;
    if(defense ~= 0) then
        table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_OUTER_DEFENSE", defense));
    end

    for row in GameInfo.Building_GreatPersonPoints() do
        if(row.BuildingType == buildingType) then
            local gpClass = GameInfo.GreatPersonClasses[row.GreatPersonClassType];
            if(gpClass) then
                local greatPersonClassName = gpClass.Name;
                local greatPersonClassIconString = gpClass.IconString;
                table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_GREAT_PERSON_POINTS", row.PointsPerTurn, greatPersonClassIconString, greatPersonClassName));
            end
        end
    end
    
    local slotStrings = {
        ["GREATWORKSLOT_PALACE"] = "LOC_TYPE_TRAIT_GREAT_WORKS_PALACE_SLOTS";
        ["GREATWORKSLOT_ART"] = "LOC_TYPE_TRAIT_GREAT_WORKS_ART_SLOTS";
        ["GREATWORKSLOT_WRITING"] = "LOC_TYPE_TRAIT_GREAT_WORKS_WRITING_SLOTS";
        ["GREATWORKSLOT_MUSIC"] = "LOC_TYPE_TRAIT_GREAT_WORKS_MUSIC_SLOTS";
        ["GREATWORKSLOT_RELIC"] = "LOC_TYPE_TRAIT_GREAT_WORKS_RELIC_SLOTS";
        ["GREATWORKSLOT_ARTIFACT"] = "LOC_TYPE_TRAIT_GREAT_WORKS_ARTIFACT_SLOTS";
        ["GREATWORKSLOT_CATHEDRAL"] = "LOC_TYPE_TRAIT_GREAT_WORKS_CATHEDRAL_SLOTS";
        ["GREATWORKSLOT_PRODUCT"] = "LOC_TYPE_TRAIT_GREAT_WORKS_PRODUCT_SLOTS";
    };

    for row in GameInfo.Building_GreatWorks() do
        if(row.BuildingType == buildingType) then
            local slotType = row.GreatWorkSlotType;
            local key = slotStrings[slotType];
            if(key) then
                table.insert(stats, Locale.Lookup(key, row.NumSlots));
            end
        end
    end
    
    if(not Locale.IsNilOrWhitespace(description)) then
        table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description));  
    end

	-- xxcat: Preserve Tier 3 building collection progress
	-- if city ~= nil then
	-- 	local collected, uncollected = ExposedMembers.DLHD.Utils.GetCollectionProgress(playerId, building.Index);
	-- 	if (collected ~= nil) and (uncollected ~= nil) then
	-- 		if #collected > 0 then
	-- 			local line = Locale.Lookup("LOC_TOOLTIP_COLLECTED");
	-- 			for index, object in ipairs(collected) do
	-- 				line = line .. Locale.Lookup(object.name);
	-- 				if index ~= #collected then
	-- 					line = line .. Locale.Lookup('LOC_COMMA');
	-- 				else
	-- 					line = line .. Locale.Lookup('LOC_PERIOD');
	-- 				end
	-- 			end
	-- 			table.insert(toolTipLines, '[COLOR:ResScienceLabelCS]' .. line .. '[ENDCOLOR]');
	-- 		end
	-- 		if #uncollected > 0 then
	-- 			local line = Locale.Lookup("LOC_TOOLTIP_UNCOLLECTED");
	-- 			for index, object in ipairs(uncollected) do
	-- 				line = line .. Locale.Lookup(object.name);
	-- 				if index ~= #uncollected then
	-- 					line = line .. Locale.Lookup('LOC_COMMA');
	-- 				else
	-- 					line = line .. Locale.Lookup('LOC_PERIOD');
	-- 				end
	-- 			end
	-- 			table.insert(toolTipLines, '[COLOR:ResCultureLabelCS]' .. line .. '[ENDCOLOR]');
	-- 		else
	-- 			local line = Locale.Lookup("LOC_TOOLTIP_FULL_COLLECTED");
	-- 			table.insert(toolTipLines, '[COLOR:ResFoodLabelCS]' .. line .. '[ENDCOLOR]');
	-- 		end
	-- 	end
	-- end
	-- xxcat end
    
    if playerId ~= nil and playerId ~= -1 then
        local kPlayerCulture:table = Players[playerId]:GetCulture();
        -- Determine the unlocked Policy, if any
        if building.UnlocksGovernmentPolicy == true then
            local slottounlock :number = kPlayerCulture:GetPolicyToUnlock(building.Index);
            if (slottounlock ~= -1) then
                local newpolicy = GameInfo.Policies[slottounlock];
                if newpolicy ~= nil then
                    table.insert(toolTipLines, Locale.Lookup("LOC_TOOLTIP_UNLOCKS_POLICY_CARD", newpolicy.Name))
                end
            end
        end
    end

    -------------------------------------------------------------
    -- Add Regional Effect
	-- Wonder Regional Effect
    local range = building.RegionalRange;
    if building.IsWonder and range ~= 0 then
        table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_REGIONAL_EFFECT_RANGE", range)); 
    end
	-- Building Regional Effect
    range = 0;
	for row in GameInfo.HD_BuildingRegionalRange() do
		if row.BuildingType == building.BuildingType then
			range = row.RegionalRange;
			break;
		end
	end
    if range ~= 0 then
        table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_REGIONAL_EFFECT_RANGE_MODIFIER", range));
		for row in GameInfo.HD_BuildingRegionalYields() do
			if row.BuildingType == building.BuildingType then
				local line;
				if row.YieldType == 'AMENITY' then
					local tooltip;
					if row.RequiresPower then
						tooltip = "LOC_TYPE_TRAIT_AMENITY_ENTERTAINMENT_POWER_ENHANCEMENT";
					else
						tooltip = "LOC_TYPE_TRAIT_AMENITY_ENTERTAINMENT";
					end
					line = "[ICON_Bullet] " .. Locale.Lookup(tooltip, row.YieldChange);
				else
					local tooltip;
					local yield = GameInfo.Yields[row.YieldType];
					if row.RequiresPower then
						tooltip = "LOC_TYPE_TRAIT_YIELD_POWER_ENHANCEMENT";
					else
						tooltip = "LOC_TYPE_TRAIT_YIELD";
					end
					line = "[ICON_Bullet] " .. Locale.Lookup(tooltip, row.YieldChange, yield.IconString, yield.Name);
				end
				if row.PrereqCivic or row.PrereqTech then
					local item;
					if row.PrereqCivic then
						item = GameInfo.Civics[row.PrereqCivic];
					else
						item = GameInfo.Technologies[row.PrereqTech];
					end
					if item then
						local text = Locale.Lookup("LOC_TOOLTIP_REGIONAL_EFFECT_REQ", item.Name);
						line = line .. " " .. text;
					end
				end
				table.insert(toolTipLines, line);
			end
		end
    end
    -------------------------------------------------------------
    
    if district ~= nil and building.RegionalRange ~= 0 then
        local extraRange = district:GetExtraRegionalRange();
        if extraRange ~= 0 then
            table.insert(toolTipLines, Locale.Lookup("LOC_TOOLTIP_EXTRA_REGIONAL_RANGE", extraRange)); 
        end
    end

    for i,v in ipairs(stats) do
        if(i == 1) then
            table.insert(toolTipLines, "[NEWLINE]" .. v);
        else
            table.insert(toolTipLines, v);
        end
    end

    local citizen_yields = {};
    for row in GameInfo.Building_CitizenYieldChanges() do
        if(row.BuildingType == buildingType) then
            local yield = GameInfo.Yields[row.YieldType];
            if(yield) then
                table.insert(citizen_yields, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_YIELD", row.YieldChange, yield.IconString, yield.Name));
            end
        end
    end
    for i,v in ipairs(citizen_yields) do
        if(i == 1) then
            table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_BUILDING_CITIZEN_YIELDS_HEADER"));
            table.insert(toolTipLines, v);
        else
            table.insert(toolTipLines, v);
        end
    end
        
    local reqLines = {};

    if(building.RequiresReligion) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_PLACEMENT_REQUIRES_RELIGION"));
    end

    for row in GameInfo.MutuallyExclusiveBuildings() do
        if(row.Building == buildingType) then
            local exBuilding = GameInfo.Buildings[row.MutuallyExclusiveBuilding];
            if(exBuilding) then
                table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_BUILDING_MUTUALLY_EXCLUSIVE_WITH", exBuilding.Name));
            end
        end
    end

    local required_buildings = {};
    for row in GameInfo.BuildingPrereqs() do
        if(row.Building == buildingType) then
            local required_building = GameInfo.Buildings[row.PrereqBuilding];
            if(required_building) then
                local district = GameInfo.Districts[required_building.PrereqDistrict];
                if(district and district.DistrictType ~= "DISTRICT_CITY_CENTER" and district.DistrictType ~=  building.PrereqDistrict) then
                    table.insert(required_buildings, Locale.Lookup("LOC_TOOLTIP_BUILDING_REQUIRES_BUILDING_WITH_DISTRICT", required_building.Name, district.Name));
                else
                    table.insert(required_buildings, Locale.Lookup("LOC_TOOLTIP_BUILDING_REQUIRES_BUILDING", required_building.Name));
                end
            end
        end
    end

    -- Required Buildings is an OR relationship.  
    -- If there are 3 or more, show as bullet list.
    local required_buildings_count = #required_buildings;
    if(required_buildings_count > 2) then
        table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_BUILDING_REQUIRES_ONE_OF_FOLLOWING"));
        for i,v in ipairs(required_buildings) do
            table.insert(toolTipLines, "[ICON_Bullet] " .. v);
        end
    end

    if(required_buildings_count == 2) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_BUILDING_REQUIRES_BUILDING_OR", required_buildings[1], required_buildings[2]));
    end

    if(required_buildings_count == 1) then
        -- Insert in front.
        table.insert(reqLines, required_buildings[1]);
    end

    local preReqDistrict = GameInfo.Districts[building.PrereqDistrict];
    if(preReqDistrict and preReqDistrict.DistrictType ~= "DISTRICT_CITY_CENTER") then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_BUILDING_REQUIRES_DISTRICT", preReqDistrict.Name));
    end

    local adjDistrict = GameInfo.Districts[building.AdjacentDistrict];
    if(adjDistrict) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_BUILDING_REQUIRES_ADJACENT_DISTRICT", adjDistrict.Name));
    end

    local adjImprovement = GameInfo.Improvements[building.AdjacentImprovement];
    if(adjImprovement) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_BUILDING_REQUIRES_ADJACENT_DISTRICT", adjImprovement.Name));
    end

    local adjResource = GameInfo.Resources[building.AdjacentResource];
    if(adjResource) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_BUILDING_REQUIRES_ADJACENT_RESOURCE", adjResource.Name));
    end

    if(building.RequiresRiver or building.RequiresAdjacentRiver) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_PLACEMENT_REQUIRES_ADJACENT_RIVER"));
    end

    if(building.MustBeLake) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_PLACEMENT_REQUIRES_LAKE"));
    end

    if(building.MustNotBeLake) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_PLACEMENT_REQUIRES_NOT_LAKE"));
    end

    if(building.AdjacentToMountain == true) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_PLACEMENT_REQUIRES_ADJACENT_MOUNTAIN"));
    end
    if(building.Coast or building.MustBeAdjacentLand) then
        table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_PLACEMENT_REQUIRES_COAST"));
    end
    
    if(#reqLines > 0) then
        table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_BUILDING_REQUIRES"));
        for i,v in ipairs(reqLines) do
            table.insert(toolTipLines, "[ICON_Bullet] " .. v);
        end
    end

    -------------------------------------------------------------
    -- Add Base Cost
    local cost = building.Cost
    if (cost > 1) then
        local yield = GameInfo.Yields["YIELD_PRODUCTION"];
        if(yield) then
            table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_BASE_COST", cost, yield.IconString, yield.Name));
        end
    end
    -- Add Base Maintenance
    local maintenance = building.Maintenance
    if (maintenance > 0) then
        local yield = GameInfo.Yields["YIELD_GOLD"];
        if(yield) then
            table.insert(toolTipLines, Locale.Lookup("LOC_TOOLTIP_MAINTENANCE", maintenance, yield.IconString, yield.Name));
        end
    end
    -------------------------------------------------------------

    -- Return the composite tooltip!
    return table.concat(toolTipLines, "[NEWLINE]");

end

g_ToolTipGenerators.KIND_BUILDING = ToolTipHelper.GetBuildingToolTip;


-- Cache original GetBuildingToolTip.
Base_GetProjectToolTip = ToolTipHelper.GetProjectToolTip;
ToolTipHelper.GetProjectToolTip = function(projectType)
    
    -- ToolTip Format
    -- <Name>
    -- <Static Description>
    -- <Amenities While Active>
    -- <Yield Conversions>
    -- <Great Person Points>
    local projectReference = GameInfo.Projects[projectType];

    local name = projectReference.Name;
    local description = projectReference.Description;
    local amenitiesWhileActive = projectReference.AmenitiesWhileActive;

    -- Build ze tip!
    -- Build the tool tip line by line.
    local toolTipLines = {};
    table.insert(toolTipLines, Locale.ToUpper(name));
    table.insert(toolTipLines, Locale.Lookup("LOC_PROJECT_NAME"));

    AddProjectStrategicResourceTooltip(projectReference, toolTipLines);

    if(not Locale.IsNilOrWhitespace(description)) then
        table.insert(toolTipLines,  "[NEWLINE]" .. Locale.Lookup(description));
    end

    AddReactorProjectData(projectReference, toolTipLines);

    if (amenitiesWhileActive ~= nil and amenitiesWhileActive > 0) then
        table.insert(toolTipLines, Locale.Lookup("LOC_PROJECT_AMENITIES_WHILE_ACTIVE", amenitiesWhileActive));
    end

    for row in GameInfo.Project_YieldConversions() do
        if(row.ProjectType == projectReference.ProjectType) then -- Fix
            local yield = GameInfo.Yields[row.YieldType];
            if(yield) then
                local yieldIcon = yield.IconString;
                local yieldName = yield.Name;
                local percent = row.PercentOfProductionRate; --TODO: Include player bonuses, like those from government
                table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_PROJECT_YIELD_CONVERSIONS", yieldIcon, yieldName, percent));
            end
        end
    end

    for row in GameInfo.Project_GreatPersonPoints() do
        if(row.ProjectType == projectReference.ProjectType) then -- Fix
            local greatPersonClass = GameInfo.GreatPersonClasses[row.GreatPersonClassType];
            if(greatPersonClass) then
                local greatPersonClassName = greatPersonClass.Name;
                local greatPersonClassIconString = greatPersonClass.IconString;
                table.insert(toolTipLines, Locale.Lookup("LOC_PROJECT_GREAT_PERSON_POINTS", greatPersonClassIconString, greatPersonClassName));
            end 
        end
    end

    -------------------------------------------------------------
    -- Add Base Cost
    local cost = projectReference.Cost
    if (cost > 1) then
        local yield = GameInfo.Yields["YIELD_PRODUCTION"];
        if(yield) then
            table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_BASE_COST", cost, yield.IconString, yield.Name));
        end
    end
    local progression = projectReference.CostProgressionParam1
    if progression > 0 then
        table.insert(toolTipLines, Locale.Lookup("LOC_TOOLTIP_COST_PROGRESSION_PARAM", progression / 100) .. "[NEWLINE]");
    end
    -------------------------------------------------------------
    
    -- Return the composite tooltip!
    return table.concat(toolTipLines, "[NEWLINE]");
end
g_ToolTipGenerators.KIND_PROJECT = ToolTipHelper.GetProjectToolTip;

-- -------------------------------------------------------------------------------
-- ToolTipHelper.GetResourceToolTip = function(resourceType)
--     -- Gather up all the information
--     local resource = GameInfo.Resources[resourceType];
--     if(resource == nil) then
--         return;
--     end

--     local name = resource.Name;
--     local description = resource.Description;
    
--     -- Build the tool tip line by line.
--     local toolTipLines = {};
--     table.insert(toolTipLines, Locale.ToUpper(name));
--     table.insert(toolTipLines, Locale.Lookup("LOC_RESOURCE_NAME"));
--     if(not Locale.IsNilOrWhitespace(description)) then
--         table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description));
--     end
    
--     return table.concat(toolTipLines, "[NEWLINE]");
-- end
-- g_ToolTipGenerators.KIND_RESOURCE = ToolTipHelper.GetResourceToolTip;
