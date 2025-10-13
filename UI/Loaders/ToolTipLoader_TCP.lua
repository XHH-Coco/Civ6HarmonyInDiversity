print("HD Tech Civic Progress Override Loaded")
-- Cache original GetCivicToolTip.
Base_GetCivicToolTip = ToolTipHelper.GetCivicToolTip

-- Check if the modifier's owner requirement set is met.
-- function IsOwnerRequirementSetMet(modifierObjId:number)
--     -- Check if owner requirements are met.
--     if modifierObjId ~= nil and modifierObjId ~= 0 then
--         local ownerRequirementSetId = GameEffects.GetModifierOwnerRequirementSet(modifierObjId);
--         if ownerRequirementSetId then
--             return GameEffects.GetRequirementSetState(ownerRequirementSetId) == "Met";
--         end
--     end
--     return true;
-- end

-- local cached_turn = -1;
-- local cached_extra_techboost = 0;
-- local cached_extra_civicboost = 0;
-- function GetExtraBoostFromModifiers(playerID, isTech)
--     -- Only need to check for the local players.
--     local cur = Game.GetCurrentGameTurn()
--     -- print(playerID, Game.GetLocalPlayer(), cur, cached_turn, '???')
--     if playerID ~= Game.GetLocalPlayer() then return; end
--     if cur == cached_turn then
--         if isTech then
--             return cached_extra_techboost
--         else
--             return cached_extra_civicboost
--         end
--     end

--     cached_turn = cur;
--     local tech_ratio = 0;
--     local civic_ratio = 0;
--     for _, modifierObjID in ipairs(GameEffects.GetModifiers()) do
--         -- Check player ids.
--         local isActive = GameEffects.GetModifierActive(modifierObjID);
--         local ownerObjID = GameEffects.GetModifierOwner(modifierObjID);
--         if isActive and IsOwnerRequirementSetMet(modifierObjID) and (GameEffects.GetObjectsPlayerId(ownerObjID) == playerID) then
--             -- The modifier is active, belongs to the given player, and owner requirement set is met.
--             local modifierDef = GameEffects.GetModifierDefinition(modifierObjID);
--             local modifierType = GameInfo.Modifiers[modifierDef.Id].ModifierType;
--             if modifierType then
--                 local modifierTypeRow = GameInfo.DynamicModifiers[modifierType];
--                 -- print(modifierTypeRow.EffectType)
--                 if modifierTypeRow then
--                     if modifierTypeRow.EffectType == 'EFFECT_ADJUST_TECHNOLOGY_BOOST' then
--                         tech_ratio = tech_ratio + modifierDef.Arguments.Amount;
--                         print("生效的额外尤里卡百分比 Modifier", GameInfo.Modifiers[modifierDef.Id].ModifierId)
--                     end
--                     if modifierTypeRow.EffectType == 'EFFECT_ADJUST_CIVIC_BOOST' then
--                         civic_ratio = civic_ratio + modifierDef.Arguments.Amount;
--                         print("生效的额外鼓舞百分比 Modifier", GameInfo.Modifiers[modifierDef.Id].ModifierId)
--                     end
--                     -- print(modifierObjID, modifierType, modifierTypeRow.EffectType)
--                     -- for k, v in pairs(modifierDef.Arguments) do
--                     --     print(k, v)
--                     -- end
--                 end
--             end
--         end
--     end
--     -- print(cur, tech_ratio, civic_ratio)
--     cached_extra_techboost = tech_ratio;
--     cached_extra_civicboost = civic_ratio;
--     print("额外尤里卡百分比", cached_extra_techboost)
--     print("额外鼓舞百分比", cached_extra_civicboost)
--     if isTech then
--         return cached_extra_techboost;
--     else
--         return cached_extra_civicboost;
--     end
-- end

local Player_Extra_Tech_Boost_Tag = 'HD_Player_Extra_Tech_Boost';
local Player_Extra_Civic_Boost_Tag = 'HD_Player_Extra_Civic_Boost';
function GetExtraBoostFromModifiers(playerId, isTech)
  if playerId ~= Game.GetLocalPlayer() then return; end
  local player = Players[playerId];
  local extra_boost = 0;
  if player then
    if isTech then
      extra_boost = player:GetProperty(Player_Extra_Tech_Boost_Tag) or 0;
      -- print("额外尤里卡百分比", extra_boost);
    else
      extra_boost = player:GetProperty(Player_Extra_Civic_Boost_Tag) or 0;
      -- print("额外鼓舞百分比", extra_boost);
    end
  end
  return extra_boost;
end



function GetBoostRatio(TechorCivicType, playerId, isTech)
    local ratio = nil
    if TechorCivicType then
        for row in GameInfo.Boosts() do
            if (row.TechnologyType == TechorCivicType) then
                ratio = row.Boost
            end
            if (row.CivicType == TechorCivicType) then
                ratio = row.Boost
            end
        end
    end
    if playerId ~= nil and ratio ~= nil then
        ratio = ratio + GetExtraBoostFromModifiers(playerId, isTech)
    end
    if ratio == nil then
        ratio = 0
    end
    return ratio;
end

-------------------------------------------------------------------------------
ToolTipHelper.GetCivicToolTip = function(civicType, playerId)

	-- ToolTip Format
	-- <Name> <Cost>
	-- <Static Description>
	-- <Unlocks>
	-- 	<UnlocksBuildings>
	-- 	<UnlocksImprovements>
	-- 	<UnlocksUnits>
	-- </Unlocks>

	-- Gather up all the information
	local civic = GameInfo.Civics[civicType];
	if(civic == nil) then
		return;
	end

	local name = civic.Name;
	local description = civic.Description;
	local cost = civic.Cost;
	local progress = 0;
	local boosted = false;
	local boost_ratio = 0;

	local unlock_text;
	local unlockables = GetUnlockablesForCivic_Cached(civicType, playerId);

	if(playerId) then
		local player = Players[playerId];
		if(player) then
			local playerCulture = player:GetCulture();
			if(playerCulture) then
				cost = playerCulture:GetCultureCost(civic.Index);
				progress = playerCulture:GetCulturalProgress(civic.Index);
				boosted = playerCulture:HasBoostBeenTriggered(civic.Index);
				boost_ratio = GetBoostRatio(civic.CivicType, playerId, false);
				-- print(Locale.Lookup(civic.Name), '鼓舞百分比', boost_ratio)
			end
		end
	end

	if(unlockables and #unlockables > 0) then
		local unlock_lookup_text = {
			KIND_BUILDING = "LOC_TOOLTIP_UNLOCKS_BUILDING",
			KIND_DIPLOMATIC_ACTION = "LOC_TOOLTIP_UNLOCKS_DIPLOMACY",
			KIND_DISTRICT = "LOC_TOOLTIP_UNLOCKS_DISTRICT",
			KIND_GOVERNMENT = "LOC_TOOLTIP_UNLOCKS_GOVERNMENT",
			KIND_IMPROVEMENT = "LOC_TOOLTIP_UNLOCKS_IMPROVEMENT",
			KIND_POLICY = "LOC_TOOLTIP_UNLOCKS_POLICY",
			KIND_PROJECT = "LOC_TOOLTIP_UNLOCKS_PROJECT",
			KIND_UNIT = "LOC_TOOLTIP_UNLOCKS_UNIT",
		};

		function GetUnlockText(typeName, name)
			local t = GameInfo.Types[typeName];
			if(t) then
				local text = unlock_lookup_text[t.Kind];
				if(text) then
					return Locale.Lookup(text, name)
				else
					return Locale.Lookup(name);
				end
			end
		end

		unlock_text = {};
		for i,v in ipairs(unlockables) do
			local text = GetUnlockText(v[1], v[2]);
			if(text) then
				table.insert(unlock_text, GetUnlockText(v[1], v[2]));
			end
		end
		table.sort(unlock_text, function(a,b) return Locale.Compare(a,b) == -1; end);
	end

	local obsolete = {};
	if(unlockables) then
		local unlockable_index = {};
		for i,v in ipairs(unlockables) do
			unlockable_index[v[1]] = true;
		end

		for row in GameInfo.ObsoletePolicies() do
			if(unlockable_index[row.ObsoletePolicy]) then
				local policy = GameInfo.Policies[row.PolicyType];
				if(policy) then
					table.insert(obsolete, Locale.Lookup("LOC_TOOLTIP_UNLOCKS_POLICY", policy.Name));
				end
			end
		end
	end
	table.sort(obsolete, function(a,b) return Locale.Compare(a,b) == -1; end);

	local yield_icon;
	local yield_name;
	local yield = GameInfo.Yields["YIELD_CULTURE"];
	if(yield) then
		yield_name = yield.Name;
		yield_icon = yield.IconString;
	end

	-- Build the tool tip line by line.
	local toolTipLines = {};
	table.insert(toolTipLines, Locale.ToUpper(name));
	table.insert(toolTipLines, Locale.Lookup("{1_Progress}/{2_Cost} {3_Icon} {4_Name}", string.format("%.1f", progress), cost, yield_icon, yield_name));
	if (not boosted) and (boost_ratio > 0) then
		local boosted_progress = math.min(progress + math.floor(math.max(cost * boost_ratio / 100.0 - 1, 0)), cost);
		table.insert(toolTipLines, Locale.Lookup("{1_Progress}/{2_Cost} {3_Icon} {4_Name} ({5_Boost})",
			string.format("%.1f", boosted_progress), cost, yield_icon, yield_name, Locale.Lookup('LOC_ESTIMATED_PROGRESS_AFTER_BOOST')));
	end

	if(not Locale.IsNilOrWhitespace(description)) then
		table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description));
	end

	if(unlock_text and #unlock_text > 0) then
		table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_UNLOCKS"));
		for i,v in ipairs(unlock_text) do
			table.insert(toolTipLines, "[ICON_Bullet]" .. v);
		end
	end

	if(obsolete and #obsolete > 0) then
		table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_MAKES_OBSOLETE"));
		for i,v in ipairs(obsolete) do
			table.insert(toolTipLines, "[ICON_Bullet]" .. v);
		end
	end

	return table.concat(toolTipLines, "[NEWLINE]");
end

g_ToolTipGenerators.KIND_CIVIC = ToolTipHelper.GetCivicToolTip;

-- Cache original GetCivicToolTip.
Base_GetTechnologyToolTip = ToolTipHelper.GetTechnologyToolTip

-------------------------------------------------------------------------------
ToolTipHelper.GetTechnologyToolTip = function(techType, playerId)
	-- ToolTip Format
	-- <Name> <Cost>
	-- <Static Description>
	-- <Unlocks>
	-- 	<UnlocksBuildings>
	-- 	<UnlocksImprovements>
	-- 	<UnlocksUnits>
	-- </Unlocks>

	-- Gather up all the information
	local tech = GameInfo.Technologies[techType];
	if(tech == nil) then
		return;
	end

	local name = tech.Name;
	local cost = tech.Cost;
	local description = tech.Description;
	local progress = 0;
	local boosted = false;
	local boost_ratio = 0;

	if(playerId) then
		local player = Players[playerId];
		if(player) then
			local playerTechs = player:GetTechs();
			if(playerTechs) then
				cost = playerTechs:GetResearchCost(tech.Index);
				progress = playerTechs:GetResearchProgress(tech.Index);
				boosted = playerTechs:HasBoostBeenTriggered(tech.Index);
				boost_ratio = GetBoostRatio(tech.TechnologyType, playerId, true);
				-- print(Locale.Lookup(tech.Name), '尤里卡百分比', boost_ratio)
			end
		end
	end

	local unlock_text;
	local unlockables = GetUnlockablesForTech_Cached( techType, playerId );

	if(unlockables and #unlockables > 0) then
		local unlock_lookup_text = {
			KIND_BUILDING = "LOC_TOOLTIP_UNLOCKS_BUILDING",
			KIND_DIPLOMATIC_ACTION = "LOC_TOOLTIP_UNLOCKS_DIPLOMACY",
			KIND_DISTRICT = "LOC_TOOLTIP_UNLOCKS_DISTRICT",
			KIND_IMPROVEMENT = "LOC_TOOLTIP_UNLOCKS_IMPROVEMENT",
			KIND_PROJECT = "LOC_TOOLTIP_UNLOCKS_PROJECT",
			KIND_RESOURCE = "LOC_TOOLTIP_UNLOCKS_RESOURCE",
			KIND_ROUTE = "LOC_TOOLTIP_UNLOCKS_ROUTE",
			KIND_UNIT = "LOC_TOOLTIP_UNLOCKS_UNIT",
		};

		function GetUnlockText(typeName, name)
			local t = GameInfo.Types[typeName];
			if(t) then
				local text = unlock_lookup_text[t.Kind];
				if(text) then
					return Locale.Lookup(text, name)
				else
					return Locale.Lookup(name);
				end
			end
		end

		unlock_text = {};
		for i,v in ipairs(unlockables) do
			local text = GetUnlockText(v[1], v[2]);
			if(text) then
				table.insert(unlock_text, text);
			end
		end
		table.sort(unlock_text, function(a,b) return Locale.Compare(a,b) == -1; end);
	end

	local yield_icon;
	local yield_name;
	local yield = GameInfo.Yields["YIELD_SCIENCE"];
	if(yield) then
		yield_name = yield.Name;
		yield_icon = yield.IconString;
	end

	-- Build the tool tip line by line.
	local toolTipLines = {};
	table.insert(toolTipLines, Locale.ToUpper(name));
	table.insert(toolTipLines, Locale.Lookup("{1_Progress}/{2_Cost} {3_Icon} {4_Name}", string.format("%.1f", progress), cost, yield_icon, yield_name));
	if (not boosted) and (boost_ratio > 0) then
		local boosted_progress = math.min(progress + math.floor(math.max(cost * boost_ratio / 100.0 - 1, 0)), cost);
		table.insert(toolTipLines, Locale.Lookup("{1_Progress}/{2_Cost} {3_Icon} {4_Name} ({5_Boost})",
			string.format("%.1f", boosted_progress), cost, yield_icon, yield_name, Locale.Lookup('LOC_ESTIMATED_PROGRESS_AFTER_BOOST')));
	end

	if(not Locale.IsNilOrWhitespace(description)) then
		table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description));
	end

	if(unlock_text and #unlock_text > 0) then
		--table.insert(toolTipLines, "");
		table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_UNLOCKS"));
		for i,v in ipairs(unlock_text) do
			table.insert(toolTipLines, "[ICON_Bullet]" .. v);
		end
	end

	return table.concat(toolTipLines, "[NEWLINE]");
end

g_ToolTipGenerators.KIND_TECH = ToolTipHelper.GetTechnologyToolTip;
