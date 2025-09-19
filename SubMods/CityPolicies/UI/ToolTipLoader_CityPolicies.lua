-- Cache original GetBuildingToolTip.
Base_GetBuildingToolTip = ToolTipHelper.GetBuildingToolTip;

-- Generate ToolTip for City Policy.
ToolTipHelper.GetCityPolicyToolTip = function(buildingHash, playerId, city)
    local building = GameInfo.Buildings[buildingHash];
    if building == nil then return end

    local toolTipLines = {};
    local name = building.Name;
    local description = building.Description;

    -- Append City Policy name.
    table.insert(toolTipLines, Locale.ToUpper(name));

    -- Append "City Policy" as type.
    table.insert(toolTipLines, Locale.Lookup("LOC_CITY_POLICY_NAME"));

    -- Append description.
    if not Locale.IsNilOrWhitespace(description) then
        table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description));
    end

    return table.concat(toolTipLines, "[NEWLINE]");
end

-- Overwrite original GetBuildingToolTip to include CityPolicy check.
ToolTipHelper.GetBuildingToolTip = function(buildingHash, playerId, city)
    local building = GameInfo.Buildings[buildingHash];
    if building == nil then return end

    if building.BuildingType:match "^BUILDING_CITY_POLICY_" then
        return ToolTipHelper.GetCityPolicyToolTip(buildingHash, playerId, city);
    else
        return Base_GetBuildingToolTip(buildingHash, playerId, city);
    end
end

g_ToolTipGenerators.KIND_CITY_POLICY = ToolTipHelper.GetCityPolicyToolTip;
g_ToolTipGenerators.KIND_BUILDING = ToolTipHelper.GetBuildingToolTip;
