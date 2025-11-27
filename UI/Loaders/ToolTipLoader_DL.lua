function ConcatReqStr(list, separator, lastSeparator)
  local result = "";
  local maxLength = #list;

  for index, str in ipairs(list) do
    if index == 1 then
      result = result .. str;
    elseif index == maxLength then
      result = result .. lastSeparator .. str;
    else
      result = result .. separator .. str;
    end
  end

  return result;
end

-------------------------------------------------------------------------------
Base_GetDistrictToolTip = ToolTipHelper.GetDistrictToolTip;
ToolTipHelper.GetDistrictToolTip = function(districtType)
  local district = GameInfo.Districts[districtType];
  local name = district.Name;
  local description = district.Description; 
  local toolTipLines = {};

  -----------------------------------------------------------------------------------
  -- 名字
  table.insert(toolTipLines, Locale.ToUpper(name));
  table.insert(toolTipLines, Locale.Lookup("LOC_DISTRICT_NAME"));

  -----------------------------------------------------------------------------------
  -- 描述
  if(not Locale.IsNilOrWhitespace(description)) then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description));
  end

  -----------------------------------------------------------------------------------
  -- 分类
  table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup('LOC_TOOLTIP_HD_CLASSIFICATIONS_TEXT'));
  -----------------------------------------------------------------------------------
  -- 通用/特色区域
  local replaces = GameInfo.DistrictReplaces[districtType];
  if replaces then
    table.insert(toolTipLines, '[ICON_BULLET]' .. Locale.Lookup("LOC_TOOLTIP_HD_REPLACE_BUILDING_TEXT", GameInfo.Districts[replaces.ReplacesDistrictType].Name));
  else
    if district.TraitType then
      table.insert(toolTipLines, '[ICON_BULLET]' .. Locale.Lookup("LOC_TOOLTIP_HD_UNIQUE_BUILDING_TEXT"));
    else
      table.insert(toolTipLines, '[ICON_BULLET]' .. Locale.Lookup("LOC_TOOLTIP_HD_GENERAL_DISTRICT_TEXT"));
    end
  end

  -----------------------------------------------------------------------------------
  -- 专业化/非专业化区域
  if (district.RequiresPopulation) then
    table.insert(toolTipLines, '[ICON_BULLET]' .. Locale.Lookup("LOC_DISTRICT_HD_IS_SPECIALTY_DISTRICT"));
  else
    table.insert(toolTipLines, '[ICON_BULLET]' .. Locale.Lookup("LOC_DISTRICT_HD_IS_NOT_SPECIALTY_DISTRICT"));
  end

  -----------------------------------------------------------------------------------
  -- 区域分类
  for row in GameInfo.HD_District_Classification() do
    if row.DistrictType == districtType then
      table.insert(toolTipLines, '[ICON_BULLET]' .. Locale.Lookup(GameInfo.HD_DistrictClassificationTypes[row.DistrictClassificationType].Name));
    end
  end

  -----------------------------------------------------------------------------------
  -- 特点
  local stats = {};
  -----------------------------------------------------------------------------------
  -- 伟人点
  for row in GameInfo.District_GreatPersonPoints() do
    if(row.DistrictType == districtType) then
      local gpClass = GameInfo.GreatPersonClasses[row.GreatPersonClassType];
      if(gpClass) then
        table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_GREAT_PERSON_POINTS", row.PointsPerTurn, gpClass.IconString, gpClass.Name));
      end
    end
  end
  -----------------------------------------------------------------------------------

  if(district.Housing ~= 0) then
    table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_HOUSING", district.Housing));
  end

  if(district.Entertainment ~= 0) then
    table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_AMENITY_ENTERTAINMENT", district.Entertainment));
  end

  if(district.Appeal ~= 0) then
    table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TOOLTIP_HD_APPEAL_TEXT", district.Appeal));
  end

  local airSlots = district.AirSlots or 0;
  if(airSlots ~= 0) then
    table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_AIRSLOTS", airSlots));
  end

  local citizens = tonumber(district.CitizenSlots) or 0;
  if(citizens ~= 0) then
    table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_CITIZENSLOTS", citizens));
  end

  -- 插入特点
  if #stats > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup('LOC_TOOLTIP_HD_TRAITS_TEXT'));
    for i,v in ipairs(stats) do
      table.insert(toolTipLines, v);
    end
  end

  -- 相邻加成
  local adjacency_yields = ExposedMembers.DLHD.Utils.GetSortedAdjacencyBonuses("DistrictType", districtType)
  if adjacency_yields and #adjacency_yields > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_HD_ADJACENCIES_TEXT"));
    for i,v in ipairs(adjacency_yields) do
      table.insert(toolTipLines, "[ICON_Bullet] " .. v);
    end
  end

  -- 专家产出
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

  if #citizen_yields > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_DISTRICT_CITIZEN_YIELDS_HEADER"));
    for i,v in ipairs(citizen_yields) do
      table.insert(toolTipLines, v);
    end
  end

  -----------------------------------------------------------------------------------
  -- 建造要求
  local reqs = {};

  -- 水域
  if district.Coast and district.AdjacentToLand then
    table.insert(reqs, '[ICON_BULLET]' .. Locale.Lookup("LOC_TOOLTIP_HD_COAST_DISTRICT_TEXT"));
  end

  -- 地形要求
  local validTerrainList = {};
  for row in GameInfo.District_ValidTerrains() do
    if row.DistrictType == districtType then
      table.insert(validTerrainList, Locale.Lookup(GameInfo.Terrains[row.TerrainType].Name));
    end
  end
  if #validTerrainList > 0 then
    table.insert(reqs, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_HD_TERRAIN_REQUIRES_TEXT') .. ConcatReqStr(validTerrainList, Locale.Lookup('LOC_TOOLTIP_HD_COMMA_TEXT'), Locale.Lookup('LOC_TOOLTIP_HD_OR_TEXT')));
  end
  

  -- 地貌要求
  local requiredFeatureList = {};
  for row in GameInfo.District_RequiredFeatures() do
    if row.DistrictType == districtType then
      table.insert(requiredFeatureList, Locale.Lookup(GameInfo.Features[row.FeatureType].Name));
    end
  end
  if #requiredFeatureList > 0 then
    table.insert(reqs, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_HD_FEATURE_REQUIRES_TEXT') .. ConcatReqStr(requiredFeatureList, Locale.Lookup('LOC_TOOLTIP_HD_COMMA_TEXT'), Locale.Lookup('LOC_TOOLTIP_HD_OR_TEXT')));
  end

  -- 不能靠近市中心
  if district.NoAdjacentCity then
    table.insert(reqs, '[ICON_BULLET]' .. Locale.Lookup("LOC_TOOLTIP_HD_REQUIRE_NOT_ADJACENT_TO_CITY"));
  end

  -- 境内最大数量
  if district.MaxPerPlayer ~= -1 then
    table.insert(reqs, '[ICON_BULLET]' .. Locale.Lookup("LOC_TOOLTIP_HD_MAX_PER_PLAY_TEXT", district.MaxPerPlayer));
  end

  -- 插入需求
  if #reqs > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup('LOC_TOOLTIP_HD_REQUIRES_TEXT'));
    for _, req in ipairs(reqs) do
      table.insert(toolTipLines, req)
    end
  end

  -------------------------------------------------------------
  -- 花费
  local cost = district.Cost
  if (cost > 1) then
    local yield = GameInfo.Yields["YIELD_PRODUCTION"];
    if(yield) then
      table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_BASE_COST", cost, yield.IconString, yield.Name));
    end
  end

  -- 维护费
  local maintenance = district.Maintenance
  if (maintenance > 0) then
    local yield = GameInfo.Yields["YIELD_GOLD"];
    if(yield) then
      table.insert(toolTipLines, Locale.Lookup("LOC_TOOLTIP_MAINTENANCE", maintenance, yield.IconString, yield.Name));
    end
  end
  -------------------------------------------------------------

  return table.concat(toolTipLines, "[NEWLINE]");
end
g_ToolTipGenerators.KIND_DISTRICT = ToolTipHelper.GetDistrictToolTip;

-------------------------------------------------------------------------------
Base_GetBuildingToolTip = ToolTipHelper.GetBuildingToolTip;
ToolTipHelper.GetBuildingToolTip = function(buildingHash, playerId, city)
  local building = GameInfo.Buildings[buildingHash];
  
  local buildingType:string = "";
  if (building ~= nil) then
    buildingType = building.BuildingType;
  end

  -----------------------------------------------------------------------------------
  -- 城市政策
  if buildingType:match "^BUILDING_CITY_POLICY_" then
    return ToolTipHelper.GetCityPolicyToolTip(buildingHash, playerId, city);
  end
  -----------------------------------------------------------------------------------

  local name = building.Name;
  local description = building.Description;

  local district = nil;
  if city ~= nil then
    district = city:GetDistricts():GetDistrict(building.PrereqDistrict);
  end

  -----------------------------------------------------------------------------------
  -- 名字
  local toolTipLines = {};
  table.insert(toolTipLines, Locale.ToUpper(name));
  if building.IsWonder then
    if building.MaxWorldInstances == 1 then
      table.insert(toolTipLines, Locale.Lookup("LOC_TOOLTIP_HD_WORLD_WONDER_TEXT"));
    else
      table.insert(toolTipLines, Locale.Lookup("LOC_TOOLTIP_HD_NATIONAL_WONDER_TEXT"));
    end
  else
    table.insert(toolTipLines, Locale.Lookup("LOC_BUILDING_NAME"));
  end

  -----------------------------------------------------------------------------------
  -- 描述
  if(not Locale.IsNilOrWhitespace(description)) then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description));  
  end

  -----------------------------------------------------------------------------------
  -- 分类
  local classificationList = {};
  -----------------------------------------------------------------------------------
  -- 通用/特色建筑
  local replaces = GameInfo.BuildingReplaces[buildingType];
  if replaces then
    table.insert(classificationList, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_HD_REPLACE_BUILDING_TEXT', GameInfo.Buildings[replaces.ReplacesBuildingType].Name))
  elseif not building.IsWonder then
    if building.TraitType then
      table.insert(classificationList, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_HD_UNIQUE_BUILDING_TEXT'))
    else
      table.insert(classificationList, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_HD_GENERAL_BUILDING_TEXT'))
    end
  end

  -----------------------------------------------------------------------------------
  -- 建筑分类
  for row in GameInfo.HD_Building_Classification() do
    if row.BuildingType == buildingType then
      table.insert(classificationList, '[ICON_BULLET]' .. Locale.Lookup(GameInfo.HD_BuildingClassificationTypes[row.BuildingClassificationType].Name));
    end
  end

  -----------------------------------------------------------------------------------
  -- 插入分类
  if #classificationList > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup('LOC_TOOLTIP_HD_CLASSIFICATIONS_TEXT'));
    for _, text in ipairs(classificationList) do
      table.insert(toolTipLines, text)
    end
  end

  -----------------------------------------------------------------------------------
  -- 特点
  local stats = {};
  -----------------------------------------------------------------------------------
  -- 产出
  AddBuildingYieldTooltip(buildingHash, city, stats);

  for row in GameInfo.Building_YieldDistrictCopies() do
    if(row.BuildingType == buildingType) then
      local from = GameInfo.Yields[row.OldYieldType];
      local to = GameInfo.Yields[row.NewYieldType];

      table.insert(stats, Locale.Lookup("LOC_TOOLTIP_BUILDING_DISTRICT_COPY", to.IconString, to.Name, from.IconString, from.Name));
    end
  end

  -- 住房
  local housing = building.Housing or 0;
  if(housing ~= 0) then
    table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_HOUSING", housing));
  end

  -- 宜居度
  AddBuildingEntertainmentTooltip(buildingHash, city, district, stats);

  -- 专家槽位
  local citizens = building.CitizenSlots or 0;
  if(citizens ~= 0) then
    table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_CITIZENS", citizens));
  end

  -- 防御
  local defense = building.OuterDefenseHitPoints or 0;
  if(defense ~= 0) then
    table.insert(stats, Locale.Lookup("LOC_TYPE_TRAIT_OUTER_DEFENSE", defense));
  end

  -- 伟人点
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

  -- 旅游业绩
  if building.IsWonder then
    table.insert(stats, Locale.Lookup('LOC_EPSTWEAK_WONDER_WORDING_TOURISM_1'));
    table.insert(stats, Locale.Lookup('LOC_EPSTWEAK_WONDER_WORDING_TOURISM_2'));
  end
  
  -- 插入特点
  if #stats > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup('LOC_TOOLTIP_HD_TRAITS_TEXT'));
    for i,v in ipairs(stats) do
      table.insert(toolTipLines, '[ICON_BULLET]' .. v);
    end
  end

  -----------------------------------------------------------------------------------
  -- 巨作槽位
  local slotText = {};

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

  local firstRowInfo;

  for row in GameInfo.Building_GreatWorks() do
    if row.BuildingType == buildingType then
      local slotType = row.GreatWorkSlotType;
      local key = slotStrings[slotType];
      if key then
        table.insert(slotText, '[ICON_BULLET]' .. Locale.Lookup(key, row.NumSlots));
      end

      if not firstRowInfo then
        firstRowInfo = row;
      end
    end
  end

  if #slotText > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup('LOC_TOOLTIP_GREATWORK_SOLT_TEXT'));
    for _, text in ipairs(slotText) do
      table.insert(toolTipLines, text)
    end
  end

  -- 主题化
  if #slotText == 1 and firstRowInfo and (firstRowInfo.ThemingYieldMultiplier > 0 or firstRowInfo.ThemingTourismMultiplier > 0) then
    local themingReqText = {};
    -- 主题化条件
    if firstRowInfo.ThemingUniquePerson == true then
      if firstRowInfo.GreatWorkSlotType == 'GREATWORKSLOT_PRODUCT' then
        table.insert(themingReqText, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_THEMING_UNIQUE_PRODUCT_REQ'));
      else
        table.insert(themingReqText, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_THEMING_UNIQUE_PERSON_REQ'));
      end
    end
    if firstRowInfo.ThemingUniqueCivs == true then
        table.insert(themingReqText, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_THEMING_UNIQUE_CIVS_REQ'));
    end
    if firstRowInfo.ThemingSameObjectType == true then
      if firstRowInfo.GreatWorkSlotType == 'GREATWORKSLOT_PALACE'
      or firstRowInfo.GreatWorkSlotType == 'GREATWORKSLOT_ART'
      or firstRowInfo.GreatWorkSlotType == 'GREATWORKSLOT_CATHEDRAL' then
        table.insert(themingReqText, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_THEMING_SAME_OBJECT_TYPE_REQ'));
      else
        table.insert(themingReqText, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_THEMING_ALL_FILLED_REQ'));
      end
    end
    if firstRowInfo.ThemingSameEras == true then
      table.insert(themingReqText, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_THEMING_SAME_ERAS_REQ'));
    end

    if #themingReqText > 0 then
      table.insert(toolTipLines, Locale.Lookup('LOC_TOOLTIP_THEMING_REQ_TITLE'));
      for _, reqText in ipairs(themingReqText) do
        table.insert(toolTipLines, reqText)
      end
    end

    -- 主题化收益
    table.insert(toolTipLines, Locale.Lookup('LOC_TOOLTIP_THEMING_BONUS_TITLE'));
    if firstRowInfo.ThemingYieldMultiplier > 0 then
      table.insert(toolTipLines, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_THEMING_YIELD_BONUS_TEXT', firstRowInfo.ThemingYieldMultiplier));
    end
    if firstRowInfo.ThemingTourismMultiplier > 0 then
      table.insert(toolTipLines, '[ICON_BULLET]' .. Locale.Lookup('LOC_TOOLTIP_THEMING_TOURISM_BONUS_TEXT', firstRowInfo.ThemingTourismMultiplier));
    end
  end

  -----------------------------------------------------------------------------------
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

  -----------------------------------------------------------------------------------
  -- 辐射产出
  -- 奇观
  local range = building.RegionalRange;
  if building.IsWonder and range ~= 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_REGIONAL_EFFECT_RANGE", range)); 
  end
  -- 建筑
  range = 0;
  for row in GameInfo.HD_BuildingRegionalRange() do
    if row.BuildingType == building.BuildingType then
      range = row.RegionalRange;
      break;
    end
  end
  if range ~= 0 then
    local regionalTextList = {};
    for row in GameInfo.HD_BuildingRegionalYields() do
      if row.BuildingType == building.BuildingType and row.YieldChange > 0 then
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
        table.insert(regionalTextList, line);
      end
    end

    if #regionalTextList > 0 then
      table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_REGIONAL_EFFECT_RANGE_MODIFIER", range));
      for _, text in ipairs(regionalTextList) do
          table.insert(toolTipLines, text);
      end
    end
  end
  
  -- if district ~= nil and building.RegionalRange ~= 0 then
  --   local extraRange = district:GetExtraRegionalRange();
  --   if extraRange ~= 0 then
  --     table.insert(toolTipLines, Locale.Lookup("LOC_TOOLTIP_EXTRA_REGIONAL_RANGE", extraRange)); 
  --   end
  -- end

  -----------------------------------------------------------------------------------
  -- 专家产出
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
  
  -----------------------------------------------------------------------------------
  -- 建造条件
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
    table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_HD_MUST_LAKE_TEXT"));
  end

  if(building.MustNotBeLake) then
    table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_HD_MUST_SEA_TEXT"));
  end

  if(building.AdjacentToMountain == true) then
    table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_PLACEMENT_REQUIRES_ADJACENT_MOUNTAIN"));
  end
  if(building.Coast) then
    table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_HD_MUST_COAST_TEXT"));
  end
  if(building.MustBeAdjacentLand) then
    table.insert(reqLines, Locale.Lookup("LOC_TOOLTIP_HD_MUST_ADJACENT_LAND_TEXT"));
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
  -- 电力消耗
  local extraCostText = AddBuildingExtraCostTooltip(buildingHash);
  if extraCostText and extraCostText ~= '' then
    table.insert(toolTipLines, extraCostText);
  end
  -------------------------------------------------------------

  -- Return the composite tooltip!
  return table.concat(toolTipLines, "[NEWLINE]");

end
g_ToolTipGenerators.KIND_BUILDING = ToolTipHelper.GetBuildingToolTip;

-------------------------------------------------------------------------------
Base_GetImprovementToolTip = ToolTipHelper.GetImprovementToolTip;
ToolTipHelper.GetImprovementToolTip = function(improvementType)
	local improvement = GameInfo.Improvements[improvementType];

	local name = improvement.Name;
	local description = improvement.Description;

	local toolTipLines = {};

  -----------------------------------------------------------------------------------
  -- 名字
	table.insert(toolTipLines, Locale.ToUpper(name));
	table.insert(toolTipLines, Locale.Lookup("LOC_IMPROVEMENT_NAME"));

  -----------------------------------------------------------------------------------
  -- 描述
	if(not Locale.IsNilOrWhitespace(description)) then
		table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description));
	end

  -----------------------------------------------------------------------------------
  -- 改良分类
  local classifications = {};

  for row in GameInfo.HD_Improvement_Classification() do
    if row.ImprovementType == improvementType then
      table.insert(classifications, row.ImprovementClassificationType);
    end
  end

  if #classifications > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup('LOC_TOOLTIP_HD_CLASSIFICATIONS_TEXT'));
    
    for _, classificationType in ipairs(classifications) do
      table.insert(toolTipLines, '[ICON_BULLET]' .. Locale.Lookup(GameInfo.HD_ImprovementClassificationTypes[classificationType].Name));
    end
  end

  -----------------------------------------------------------------------------------
  -- 特点
	local stats = {};
	local housing = 0;

	if(tonumber(improvement.TilesRequired) > 0) then
		housing = tonumber(improvement.Housing)/tonumber(improvement.TilesRequired);
	end

	if(housing ~= 0) then
		table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_HOUSING", housing));
	end

  if(improvement.Appeal ~= 0) then
    table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TOOLTIP_HD_APPEAL_TEXT", improvement.Appeal));
  end

	local airSlots = improvement.AirSlots or 0;
	if(airSlots ~= 0) then
		table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_AIRSLOTS", airSlots));
	end

	local citizenSlots = improvement.CitizenSlots or 0;
	if(citizenSlots ~= 0) then
		table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_CITIZENSLOTS", citizenSlots));
	end

	local weaponSlots = improvement.WeaponSlots or 0;
	if(weaponSlots ~= 0) then
		table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TYPE_TRAIT_WEAPONSLOTS", weaponSlots));
	end

  -- 产出转业绩
  for row in GameInfo.Improvement_Tourism() do
    if(row.ImprovementType == improvementType and row.Improvement_Tourism ~= 0) then
      local yield;
      if(row.TourismSource == "TOURISMSOURCE_CULTURE") then
        yield = GameInfo.Yields["YIELD_CULTURE"];
      elseif(row.TourismSource == "TOURISMSOURCE_GOLD") then
        yield = GameInfo.Yields["YIELD_GOLD"];
      elseif(row.TourismSource == "TOURISMSOURCE_FAITH") then
        yield = GameInfo.Yields["YIELD_FAITH"];
      elseif(row.TourismSource == "TOURISMSOURCE_FOOD") then
        yield = GameInfo.Yields["YIELD_FOOD"];
      elseif(row.TourismSource == "TOURISMSOURCE_PRODUCTION") then
        yield = GameInfo.Yields["YIELD_PRODUCTION"];
      elseif(row.TourismSource == "TOURISMSOURCE_SCIENCE") then
        yield = GameInfo.Yields["YIELD_SCIENCE"];
      end
    
      local item;
      if(row.PrereqCivic) then
        item = GameInfo.Civics[row.PrereqCivic];
      else
        item = GameInfo.Technologies[row.PrereqTech];
      end
      
      if(item) then
        if(yield) then
          table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TOOLTIP_HD_TOURISM_FROM_YIELD_TEXT", row.ScalingFactor, yield.IconString, yield.Name, item.Name));
        elseif (row.TourismSource == "TOURISMSOURCE_APPEAL") then
          table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TOOLTIP_HD_TOURISM_FROM_APPEAL_TEXT", row.ScalingFactor, item.Name));
        end
      else
        if(yield) then
          table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TOOLTIP_HD_TOURISM_FROM_YIELD_NOREQ_TEXT", row.ScalingFactor, yield.IconString, yield.Name));
        elseif (row.TourismSource == "TOURISMSOURCE_APPEAL") then
          table.insert(stats, "[ICON_Bullet] " .. Locale.Lookup("LOC_TOOLTIP_HD_TOURISM_FROM_APPEAL_NOREQ_TEXT", row.ScalingFactor));
        end
      end
    end
  end

  -- 插入特点
  if #stats > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup('LOC_TOOLTIP_HD_TRAITS_TEXT'));
    for i,v in ipairs(stats) do
      table.insert(toolTipLines, v);
    end
  end

  -- 加产节点
  local yield_changes = ExposedMembers.DLHD.Utils.GetSortedImprovementYieldChanges(improvementType);
  if yield_changes and #yield_changes > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_HD_YIELD_CHANGES_TEXT"));
    for i,v in ipairs(yield_changes) do
      table.insert(toolTipLines, "[ICON_Bullet] " .. v);
    end
  end

  -- 相邻加成
	local adjacency_yields = ExposedMembers.DLHD.Utils.GetSortedAdjacencyBonuses("ImprovementType", improvementType);
	if adjacency_yields and #adjacency_yields > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_HD_ADJACENCIES_TEXT"));
    for i,v in ipairs(adjacency_yields) do
      table.insert(toolTipLines, "[ICON_Bullet] " .. v);
    end
  end

  -- 改良单位
  local built_by = {};
  for row in GameInfo.Improvement_ValidBuildUnits() do
    if row.ImprovementType == improvementType then
      local unit = GameInfo.Units[row.UnitType];
      if unit then
        local score = unit.Cost;
        if unit.UnitType == 'UNIT_BUILDER' then score = 0; end
        table.insert(built_by, {
          Text = Locale.Lookup(unit.Name),
          Score = score
        });
      end
    end
  end
  table.sort(built_by, function(a, b) return a.Score < b.Score; end)
  if #built_by > 0 then
    table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_HD_IMPROVEMENT_UNIT_TEXT"));
    for i,v in ipairs(built_by) do
      table.insert(toolTipLines, "[ICON_Bullet] " .. v.Text);
    end
  end
  -------------------------------------------------------------

	return table.concat(toolTipLines, "[NEWLINE]");
end
g_ToolTipGenerators.KIND_IMPROVEMENT = ToolTipHelper.GetImprovementToolTip;

-------------------------------------------------------------------------------
Base_GetProjectToolTip = ToolTipHelper.GetProjectToolTip;
ToolTipHelper.GetProjectToolTip = function(projectType)
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
