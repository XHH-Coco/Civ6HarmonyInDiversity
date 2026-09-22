-------------------------------------------------
-- Mods Browser Screen
-------------------------------------------------
include( "InstanceManager" );
include( "SupportFunctions" );
include( "PopupDialog" );

print("HD Override Mods Browser Screen")

LOC_MODS_SEARCH_NAME = Locale.Lookup("LOC_MODS_SEARCH_NAME");

g_ModListingsManager = InstanceManager:new("ModInstance", "ModInstanceRoot", Controls.ModListingsStack);
g_Enabled_ModListingsManager = InstanceManager:new("Enabled_ModInstance", "ModInstanceRoot", Controls.Enabled_ModListingsStack);
g_SubscriptionsListingsManager = InstanceManager:new("SubscriptionInstance", "SubscriptionInstanceRoot", Controls.SubscriptionListingsStack);
g_DependencyListingsManager = InstanceManager:new("ReferenceItemInstance", "Item", Controls.ModDependencyItemsStack);


g_SearchContext = "Mods";
g_SearchQuery = nil;
g_EnabledSearchQuery = nil;
g_ModListings = nil;			-- An array of pairs containing the mod handle and its associated listing.
g_EnabledMods = {};				-- FF16 - global copy of enabled mod list.
g_DependantModList = {};		-- FF16 - list for remembering all mods marked as being dependant on another mod.
g_DependencyIDs = {};	
g_FinalDependencyStrings = {};

g_SelectedModHandle = nil;		-- The currently selected mod entry.
g_CurrentModSelectionIDs = {};
g_EndabledModsNames = {};

g_MultiSelectedModHandle = {};	-- FF16 - When multi selecting mods.
g_CurrentListingsSortName = nil;-- FF16 - Just grab the filter name. I need it for determining what filter i'm using elsewhere.
g_CurrentListingsSort = nil;	-- The current method of sorting the mod listings.
g_ModSubscriptions = nil;
g_SubscriptionsSortingMap = {};
g_CustomCollectionOptions = {};

g_CustomCollection = {
	{name = "Off", mods = "None"}
};
g_CustomNotationCollection = {}

-- FF16 - Array of custom mod collections
g_CustomCollectionName = "Off";	-- FF16 - Just grab the filter name. I need it for determining what filter i'm using elsewhere.
g_CustomCollectionNum = 1;
g_CustomCollectionMods = {};

g_ShiftKeyDown = false;

local MIN_SCREEN_Y				:number = 768;

function getCustomNotations(current_modID)
	local customNotations = {}
	for i, v in ipairs(g_CustomNotationCollection) do
		if v.mods then
			local modList = strSplit(v.mods, ",");
			for a, modID in ipairs(modList) do
				if(current_modID == modID) then
					table.insert(customNotations, v);
					-- print(v.name, v.tooltip)
				end
			end
		end
	end
	return customNotations;
end
---------------------------------------------------------------------------
---------------------------------------------------------------------------
function RefreshModGroups()
	local groups = Modding.GetModGroups();
	for i, v in ipairs(groups) do
		v.DisplayName = Locale.Lookup(v.Name);
	end
	table.sort(groups, function(a,b)
		if(a.SortIndex == b.SortIndex) then
			-- Sort by Name.
			return Locale.Compare(a.DisplayName, b.DisplayName) == -1;
		else
			return a.SortIndex < b.SortIndex;
		end
	end);	
	
	local g = Modding.GetCurrentModGroup();

	local comboBox = Controls.ModGroupPullDown;
	comboBox:ClearEntries();
	for i, v in ipairs(groups) do
		local controlTable = {};
		comboBox:BuildEntry( "InstanceOne", controlTable );
		controlTable.Button:LocalizeAndSetText(v.Name);
		controlTable.Button:SetSizeX(937);
	
		controlTable.Button:RegisterCallback(Mouse.eLClick, function()
			Modding.SetCurrentModGroup(v.Handle);
			RefreshModGroups();
			RefreshListings();
		end);	

		if(v.Handle == g) then
			comboBox:GetButton():SetText(v.DisplayName);
			Controls.DeleteModGroup:SetDisabled(not v.CanDelete);
		end
	end

	comboBox:CalculateInternals();
end
---------------------------------------------------------------------------
---------------------------------------------------------------------------
function RefreshListings()
		
	local mods = Modding.GetInstalledMods();
	if(g_CustomCollectionName ~= "Off") then
		mods = FilterByCustomCollection(g_CustomCollectionNum);
	end
		
	g_ModListings = {};
	g_ModListingsManager:ResetInstances();
	g_Enabled_ModListingsManager:ResetInstances();

	Controls.EnableAll:SetDisabled(true);
	Controls.DisableAll:SetDisabled(true);
	Controls.DisabledModsPanel:SetHide(false);
	Controls.EnabledModsPanel:SetHide(false);

	if(mods == nil or #mods == 0) then
		Controls.ModListings:SetHide(true);
		Controls.NoModsInstalled:SetHide(false);
	else
		Controls.ModListings:SetHide(false);
		Controls.NoModsInstalled:SetHide(true);

		PreprocessListings(mods);

		-- FF16 - Split mods list into two. Enabled/Disabled
		local enabledMods = {}; 
		local disabledMods = {};
		for i,v in ipairs(mods) do	
			if(v.Enabled) then
				table.insert(enabledMods, v);
			else
				table.insert(disabledMods, v);
			end
		end
		
		--FF16 - Take a copy of the enabled mods
		g_EnabledMods = enabledMods;
		
		--mods = FilterListings(mods);
		enabledMods = FilterEnabledListings(enabledMods);
		disabledMods = FilterListings(disabledMods);
		
		--SortListings(mods);
		g_DependantModList = {};
		SortListings(enabledMods);
		SortListings(disabledMods);
 
		local hasEnabledMods = false;
		local hasDisabledMods = false;

		local enabledCounterNum = 0;
		local disabledCounterNum = 0;
		
		for i,v in ipairs(disabledMods) do		
				
			--print(v.DisplayName, v.Enabled, v.Source, v.Teaser);
			disabledCounterNum = disabledCounterNum+1;
			local instance = g_ModListingsManager:GetInstance();

			table.insert(g_ModListings, {v.Handle, instance});

			local handle = v.Handle;
		
			instance.ModInstanceButton:RegisterCallback(Mouse.eLClick, function()
				SelectMod(handle);
			end);
			instance.ModInstanceButton:RegisterCallback(Mouse.eRClick, function()			
				Modding.EnableMod(handle, true);
				Modding.SetIgnoreCompatibilityWarnings(handle, true);
				ResetSelectedMods();
				UI.PlaySound("Play_UI_Click");
				RefreshListings();
			end);

			local name = TruncateStringByLength(v.DisplayName, 96);
			
			if(v.Allowance == false) then
				name = name .. " [COLOR_RED](" .. Locale.Lookup("LOC_MODS_DETAILS_OWNERSHIP_NO") .. ")[ENDCOLOR]";
			end
			
			if(Modding.ShouldShowCompatibilityWarnings()) then
				if(not Modding.IsModCompatible(v.Handle) and not Modding.GetIgnoreCompatibilityWarnings(v.Handle)) then
					instance.CompatibleIcon:SetHide(false);
					instance.CompatibleIcon:SetText("[ICON_CheckFail]");
					instance.CompatibleIcon:SetOffsetY(12);
					instance.CompatibleIcon:SetToolTipString(Locale.Lookup("LOC_MODS_DETAILS_COMPATIBLE_NOT"));
				elseif(not Modding.IsModCompatible(v.Handle) and Modding.GetIgnoreCompatibilityWarnings(v.Handle)) then
					instance.CompatibleIcon:SetHide(false);
					instance.CompatibleIcon:SetText("[ICON_CheckmarkBlue]");
					instance.CompatibleIcon:SetOffsetY(8);
					instance.CompatibleIcon:SetToolTipString(Locale.Lookup("LOC_FF16_COMPAT_IGNORED_TOOLTIP"));
				else
					instance.CompatibleIcon:SetHide(true);
				end											 
			end
			
			if(v.SubscriptionId == nil) then 
				instance.LocalInstallIcon:SetHide(false);
				instance.AdditionalIconsStack:SetOffsetX(10);
			else
				instance.LocalInstallIcon:SetHide(true);
				instance.AdditionalIconsStack:SetOffsetX(5);
			end

			instance.CustomNotation:SetHide(true);
			instance.CustomNotationAlt:SetHide(true);
			if not v.Official then
				local notations = getCustomNotations(v.Id);
				if notations[1] then
					instance.CustomNotation:SetHide(false);
					instance.CustomNotation:SetText(notations[1].name);
					instance.CustomNotation:SetToolTipString(notations[1].tooltip);
					if notations[2] then
						instance.CustomNotationAlt:SetHide(false);
						instance.CustomNotationAlt:SetText(notations[2].name);
						instance.CustomNotationAlt:SetToolTipString(notations[2].tooltip);
					end
				end
			end
			
			instance.ModTitle:LocalizeAndSetText(name);
			if(g_CurrentListingsSortName == "LOC_FF16_SORTBY_AUTHOR") then
				local modAuthor = Modding.GetModProperty(v.Handle, "Authors")			
				if(modAuthor == nil) then
					instance.ModSummary:SetText("");
				else
					instance.ModSummary:SetText(Locale.Lookup("LOC_FF16_BY_AUTHOR") .. tostring(Locale.Lookup(modAuthor)));
				end
			elseif(g_CurrentListingsSortName == "LOC_FF16_SORTBY_LASTUPDATED") then
				if(v.SubscriptionId) then
					local details = Modding.GetSubscriptionDetails(v.SubscriptionId);
					if details and details.LastUpdated then
						instance.ModSummary:SetText(Locale.Lookup("LOC_MODS_LAST_UPDATED", details.LastUpdated));
					end
				else
					instance.ModSummary:SetText(Locale.Lookup("LOC_MODS_LAST_UPDATED", "?????"));
				end				
			else
				instance.ModSummary:SetText(Locale.Lookup(v.Teaser:gsub("COLOR_RED", "169,169,169,255")));
			end

			local tooltip;
			if(#v.Teaser) then
				tooltip = Locale.Lookup(v.Teaser:gsub("COLOR_RED", "0,0,0,255"));
			end
			instance.ModInstanceRoot:SetToolTipString(tooltip);

			local enabled = v.Enabled;
			if(enabled) then
				hasEnabledMods = true;
			else
				hasDisabledMods = true;
			end
			
			instance.ModInstanceButton:SetOffsetX(0);
			instance.ModInstanceButton:SetSizeX(instance.ModInstanceRoot:GetSizeX());
			instance.ModSummary:SetWrapWidth(300);
			instance.ModBolt:SetHide(true);
					
			-- Highlight dependant mods
			for k, dm in ipairs(g_DependantModList) do
				if(v.Id == dm and g_CurrentListingsSortName == "LOC_FF16_SORTBY_DEPENDENCY") then
					--print(name," has dependency!")
					instance.ModInstanceButton:SetOffsetX(15);
					instance.ModInstanceButton:SetSizeX(instance.ModInstanceButton:GetSizeX()-15);
					instance.ModSummary:SetWrapWidth(275);
					instance.ModBolt:SetHide(false);
					break;
				end
			end

			local bOfficial = v.Official;
			local bIsMap = v.Source == "Map";
			
			instance.OfficialIcon:SetHide(bIsMap or not bOfficial); -- Show/Hide Official DLC icon
			instance.MapIcon:SetHide(not bIsMap); -- Show/Hide Map icon
			
			if(instance.OfficialIcon:IsVisible() == false and instance.MapIcon:IsVisible() == false) then		
				local affectsSavedGames = Modding.GetModProperty(v.Handle, "AffectsSavedGames");
				if(affectsSavedGames and tonumber(affectsSavedGames) == 0) then  -- If affects saves but not official DLC or MapMod
					instance.CosmeticIcon:SetHide(false);
					instance.CommunityIcon:SetHide(true);
				else
					instance.CosmeticIcon:SetHide(true);
					instance.CommunityIcon:SetHide(false);
				end
			else
				instance.CosmeticIcon:SetHide(true);
				instance.CommunityIcon:SetHide(true);			
			end
		end	
			
		
		for i,v in ipairs(enabledMods) do
			--print(v.DisplayName, v.Enabled);
			enabledCounterNum = enabledCounterNum+1;
			local instance = g_Enabled_ModListingsManager:GetInstance();

			table.insert(g_ModListings, {v.Handle, instance});

			local handle = v.Handle;

			instance.ModInstanceButton:RegisterCallback(Mouse.eLClick, function()
				SelectMod(handle);
			end);
			instance.ModInstanceButton:RegisterCallback(Mouse.eRClick, function()			
				local err, xtra, sources = Modding.CanDisableMod(handle);
				if(err == "OK") then
					Modding.DisableMod(handle, true);
					ResetSelectedMods();
					UI.PlaySound("Play_UI_Click");
					RefreshListings();
				else 
					UI.PlaySound("Play_Mouse_Click_Negative");
				end
			end);

			local name = TruncateStringByLength(v.DisplayName, 96);
			
			if(v.Allowance == false) then
				name = name .. " [COLOR_RED](" .. Locale.Lookup("LOC_MODS_DETAILS_OWNERSHIP_NO") .. ")[ENDCOLOR]";
			end
			
			if(Modding.ShouldShowCompatibilityWarnings()) then
				if(not Modding.IsModCompatible(v.Handle) and not Modding.GetIgnoreCompatibilityWarnings(v.Handle)) then
					instance.CompatibleIcon:SetHide(false);
					instance.CompatibleIcon:SetText("[ICON_CheckFail]");
					instance.CompatibleIcon:SetOffsetY(12);
					instance.CompatibleIcon:SetToolTipString(Locale.Lookup("LOC_MODS_DETAILS_COMPATIBLE_NOT"));
				elseif(not Modding.IsModCompatible(v.Handle) and Modding.GetIgnoreCompatibilityWarnings(v.Handle)) then
					instance.CompatibleIcon:SetHide(false);
					instance.CompatibleIcon:SetText("[ICON_CheckmarkBlue]");
					instance.CompatibleIcon:SetOffsetY(8);
					instance.CompatibleIcon:SetToolTipString(Locale.Lookup("LOC_FF16_COMPAT_IGNORED_TOOLTIP"));
				else
					instance.CompatibleIcon:SetHide(true);
				end											 
			end
			
			if(v.SubscriptionId == nil) then 
				instance.LocalInstallIcon:SetHide(false);
				instance.AdditionalIconsStack:SetOffsetX(10);
			else
				instance.LocalInstallIcon:SetHide(true);
				instance.AdditionalIconsStack:SetOffsetX(5);
			end

			instance.CustomNotation:SetHide(true);
			instance.CustomNotationAlt:SetHide(true);
			if not v.Official then
				local notations = getCustomNotations(v.Id);
				if notations[1] then
					instance.CustomNotation:SetHide(false);
					instance.CustomNotation:SetText(notations[1].name);
					instance.CustomNotation:SetToolTipString(notations[1].tooltip);
					if notations[2] then
						instance.CustomNotationAlt:SetHide(false);
						instance.CustomNotationAlt:SetText(notations[2].name);
						instance.CustomNotationAlt:SetToolTipString(notations[2].tooltip);
					end
				end
			end

			instance.ModTitle:LocalizeAndSetText(name);
			if(g_CurrentListingsSortName == "LOC_FF16_SORTBY_AUTHOR") then
				local modAuthor = Modding.GetModProperty(v.Handle, "Authors")
				if(modAuthor ~= nil) then
					instance.ModSummary:SetText(Locale.Lookup("LOC_FF16_BY_AUTHOR") .. tostring(modAuthor));
					if(modAuthor == nil) then
						instance.ModSummary:SetText("");
					else
						instance.ModSummary:SetText(Locale.Lookup("LOC_FF16_BY_AUTHOR") .. tostring(Locale.Lookup(modAuthor)));
					end
				end
			elseif(g_CurrentListingsSortName == "LOC_FF16_SORTBY_LASTUPDATED") then
				if(v.SubscriptionId) then
					local details = Modding.GetSubscriptionDetails(v.SubscriptionId);
					if details and details.LastUpdated then
						instance.ModSummary:SetText(Locale.Lookup("LOC_MODS_LAST_UPDATED", details.LastUpdated));
					end
				else
					instance.ModSummary:SetText(Locale.Lookup("LOC_MODS_LAST_UPDATED", "?????"));
				end	
			else
				instance.ModSummary:SetText(Locale.Lookup(v.Teaser:gsub("COLOR_RED", "169,169,169,255")));
			end
			
			local tooltip;
			if(#v.Teaser) then
				tooltip = Locale.Lookup(v.Teaser:gsub("COLOR_RED", "0,0,0,255"));
			end
			instance.ModInstanceRoot:SetToolTipString(tooltip);

			local enabled = v.Enabled;
			if(enabled) then
				hasEnabledMods = true;
			else
				hasDisabledMods = true;
			end
			
			instance.ModInstanceButton:SetOffsetX(0);
			instance.ModInstanceButton:SetSizeX(instance.ModInstanceRoot:GetSizeX());
			instance.ModSummary:SetWrapWidth(300);
			instance.ModBolt:SetHide(true);
					
			-- Highlight dependant mods
			for k, dm in ipairs(g_DependantModList) do
				if(v.Id == dm and g_CurrentListingsSortName == "LOC_FF16_SORTBY_DEPENDENCY") then
					--print(name," has dependency!")
					instance.ModInstanceButton:SetOffsetX(15);
					instance.ModInstanceButton:SetSizeX(instance.ModInstanceButton:GetSizeX()-15);
					instance.ModSummary:SetWrapWidth(275);
					instance.ModBolt:SetHide(false);
					break;
				end
			end

			local bOfficial = v.Official;
			local bIsMap = v.Source == "Map";
			
			instance.OfficialIcon:SetHide(bIsMap or not bOfficial); -- Show/Hide Official DLC icon
			instance.MapIcon:SetHide(not bIsMap); -- Show/Hide Map icon
			if(instance.OfficialIcon:IsVisible() == false and instance.MapIcon:IsVisible() == false) then		
				local affectsSavedGames = Modding.GetModProperty(v.Handle, "AffectsSavedGames");
				if(affectsSavedGames and tonumber(affectsSavedGames) == 0) then  -- If affects saves but not official DLC or MapMod
					instance.CosmeticIcon:SetHide(false);
					instance.CommunityIcon:SetHide(true);
				else
					instance.CosmeticIcon:SetHide(true);
					instance.CommunityIcon:SetHide(false);
				end
			else
				instance.CosmeticIcon:SetHide(true);
				instance.CommunityIcon:SetHide(true);			
			end
		end
			

		if(hasEnabledMods) then
			Controls.DisableAll:SetDisabled(false);		
		end

		if(hasDisabledMods) then
			Controls.EnableAll:SetDisabled(false);		
		end
		
		Controls.Enabled_Counter:SetText(enabledCounterNum)
		Controls.Disabled_Counter:SetText(disabledCounterNum)

		Controls.ModListingsStack:CalculateSize();
		Controls.ModListingsStack:ReprocessAnchoring();
		Controls.ModListings:CalculateInternalSize();
	end

	-- Update the selection state of each listing.
	RefreshListingsSelectionState();
	RefreshModDetails();
end

---------------------------------------------------------------------------
-- Pre-process listings by translating strings or stripping tags.
---------------------------------------------------------------------------
function PreprocessListings(mods)
	for i,v in ipairs(mods) do
		local name = v.Name;
		local striped_id = "LOC_" .. string.gsub(v.Id, "-", "");
		local id_to_tag = Locale.Lookup(striped_id);
		if id_to_tag ~= striped_id then
			name = id_to_tag;
		end
		-- print(name, v.Id, striped_id, name_to_tag)
		v.DisplayName = Locale.Lookup(name);
		v.StrippedDisplayName = Locale.StripTags(v.DisplayName);
	end
end

---------------------------------------------------------------------------
-- Filter the listings, returns filtered list.
---------------------------------------------------------------------------
function FilterListings(mods)

	local isFinalRelease = UI.IsFinalRelease();
	local showOfficialContent = Controls.ShowOfficialContent:IsChecked();
	local showCommunityContent = Controls.ShowCommunityContent:IsChecked();
	local showAffectsSavesContent = Controls.ShowAffectsSaves:IsChecked();
	local showNotAffectsSavesContent = Controls.ShowNotAffectsSaves:IsChecked();

	local original = mods;

	mods = {};
	for i,v in ipairs(original) do	
		-- Hide mods marked as always hidden or DLC which is not owned.
		local category = Modding.GetModProperty(v.Handle, "ShowInBrowser");
		if(category ~= "AlwaysHidden" and not (isFinalRelease and v.Allowance == false)) then
			-- Filter by selected options (currently only official and community content).
			if(v.Official and showOfficialContent) then
				if(showAffectsSavesContent) then
					table.insert(mods, v);
				end
			elseif(not v.Official and showCommunityContent) then
				
				-- FF16 - Show/Hide mods that affect save games
				local affectsSavedGames = Modding.GetModProperty(v.Handle, "AffectsSavedGames");
				if(affectsSavedGames == 1 or affectsSavedGames == nil) then
					affectsSavedGames = 1;
				end
				if(showAffectsSavesContent and showNotAffectsSavesContent) then	-- if both checked then add all community mods	
					table.insert(mods, v);
				elseif(showAffectsSavesContent == true and showNotAffectsSavesContent == false) then
					if(affectsSavedGames == nil or tonumber(affectsSavedGames) == 1 or affectsSavedGames == "Yes") then
						table.insert(mods, v);
					end
				elseif(showAffectsSavesContent == false and showNotAffectsSavesContent == true) then
					if(affectsSavedGames and tonumber(affectsSavedGames) == 0) then
						table.insert(mods, v);
					end
				end
						
			end
		end
	end

	-- Index remaining mods and filter by search query.
	if(Search.HasContext(g_SearchContext)) then
		Search.ClearData(g_SearchContext);
		for i, v in ipairs(mods) do
			local authors = Modding.GetModProperty(v.Handle, "Authors");
			Search.AddData(g_SearchContext, v.Handle, v.DisplayName, Locale.Lookup(v.Teaser or ""));
			Search.AddData(g_SearchContext, v.Handle, v.DisplayName, Locale.Lookup(authors or ""));
		end
		Search.Optimize(g_SearchContext);

		if(g_SearchQuery) then
			if (g_SearchQuery ~= nil and #g_SearchQuery > 0 and g_SearchQuery ~= LOC_MODS_SEARCH_NAME) then
				local include_map = {};
				local search_results = Search.Search(g_SearchContext, g_SearchQuery);
				if (search_results and #search_results > 0) then
					for i, v in ipairs(search_results) do
						include_map[tonumber(v[1])] = v[2];
					end
				end

				local original = mods;
				mods = {};
				for i,v in ipairs(original) do
					if(include_map[v.Handle]) then
						v.DisplayName = include_map[v.Handle];
						v.StrippedDisplayName = Locale.StripTags(v.DisplayName);
						table.insert(mods, v);
					end
				end
			end
		end
	end
	
	return mods;
end


function FilterEnabledListings(mods)

	local isFinalRelease = UI.IsFinalRelease();
	
	local enabled_showOfficialContent = Controls.Enabled_ShowOfficialContent:IsChecked();
	local enabled_showCommunityContent = Controls.Enabled_ShowCommunityContent:IsChecked();
	local enabled_showAffectsSavesContent = Controls.Enabled_ShowAffectsSaves:IsChecked();
	local enabled_showNotAffectsSavesContent = Controls.Enabled_ShowNotAffectsSaves:IsChecked();

	local original = mods;
	mods = {};
	g_EnabledModsNames = {};
	for i,v in ipairs(original) do	
		--FF16 capture the names of all enabled mods.
		table.insert(g_EnabledModsNames, v.Id);
		--print(Locale.Lookup(v.Name), v.Id);
		
		-- Hide mods marked as always hidden or DLC which is not owned.
		local category = Modding.GetModProperty(v.Handle, "ShowInBrowser");
		if(category ~= "AlwaysHidden" and not (isFinalRelease and v.Allowance == false)) then
			-- Filter by selected options (currently only official and community content).
			if(v.Official and enabled_showOfficialContent) then
				if(enabled_showAffectsSavesContent) then
					table.insert(mods, v);
				end
			elseif(not v.Official and enabled_showCommunityContent) then
							
				-- FF16 - Show/Hide mods that affect save games
				local affectsSavedGames = Modding.GetModProperty(v.Handle, "AffectsSavedGames");
				if(affectsSavedGames == 1 or affectsSavedGames == nil) then
					affectsSavedGames = 1;
				end
				if(enabled_showAffectsSavesContent and enabled_showNotAffectsSavesContent) then	-- if both checked then add all community mods	
					table.insert(mods, v);
				elseif(enabled_showAffectsSavesContent == true and enabled_showNotAffectsSavesContent == false) then
					if(affectsSavedGames == nil or tonumber(affectsSavedGames) == 1 or affectsSavedGames == "Yes") then
						table.insert(mods, v);
					end
				elseif(enabled_showAffectsSavesContent == false and enabled_showNotAffectsSavesContent == true) then
					if(affectsSavedGames and tonumber(affectsSavedGames) == 0) then
						table.insert(mods, v);
					end
				end
				
			end
		end
	end

	-- Index remaining mods and filter by search query.
	if(Search.HasContext(g_SearchContext)) then
		Search.ClearData(g_SearchContext);
		for i, v in ipairs(mods) do
			local authors = Modding.GetModProperty(v.Handle, "Authors");
			Search.AddData(g_SearchContext, v.Handle, v.DisplayName, Locale.Lookup(v.Teaser or ""));
			Search.AddData(g_SearchContext, v.Handle, v.DisplayName, Locale.Lookup(authors or ""));
		end
		Search.Optimize(g_SearchContext);

		if(g_EnabledSearchQuery) then
			if (g_EnabledSearchQuery ~= nil and #g_EnabledSearchQuery > 0 and g_EnabledSearchQuery ~= LOC_MODS_SEARCH_NAME) then
				local include_map = {};
				local search_results = Search.Search(g_SearchContext, g_EnabledSearchQuery);
				if (search_results and #search_results > 0) then
					for i, v in ipairs(search_results) do
						include_map[tonumber(v[1])] = v[2];
					end
				end

				local original = mods;
				mods = {};
				for i,v in ipairs(original) do
					if(include_map[v.Handle]) then
						v.DisplayName = include_map[v.Handle];
						v.StrippedDisplayName = Locale.StripTags(v.DisplayName);
						table.insert(mods, v);
					end
				end
			end
		end
	end
	
	return mods;
end

---------------------------------------------------------------------------
-- Sort the listings in-place.
---------------------------------------------------------------------------
function SortListings(mods)
	if(g_CurrentListingsSort) then
		g_CurrentListingsSort(mods);
	end
end

-- Update the state of each instanced listing to reflect whether it is selected.
function RefreshListingsSelectionState()
		
	if(#g_MultiSelectedModHandle > 1) then
		for i,v in ipairs(g_ModListings) do			
			local isInList = false;
			for i2,h in ipairs(g_MultiSelectedModHandle) do
				if(v[1] == h) then
					isInList = true;				
				end
			end
			if(isInList) then
				v[2].ModInstanceButton:SetSelected(true);
			else
				v[2].ModInstanceButton:SetSelected(false);
			end
		end
		
		--print(#g_MultiSelectedModHandle, "Doing multi select");
	else
		if(#g_MultiSelectedModHandle == 1) then
			g_SelectedModHandle = g_MultiSelectedModHandle[1];
		end
		
		for i,v in ipairs(g_ModListings) do
			if(v[1] == g_MultiSelectedModHandle[1]) then
				v[2].ModInstanceButton:SetSelected(true);
			else
				v[2].ModInstanceButton:SetSelected(false);
			end
		end
	end
end


function CheckForMissingDependencies(listBeingChecked)
	
	g_DependencyIDs = {};
	g_CurrentModSelectionIDs = {};
	g_FinalDependencyStrings = {};
	
	if(listBeingChecked == "Enabled") then -- Selection is from the Enabled Mod List
	
		for _,modHandle in ipairs(g_MultiSelectedModHandle) do
			
			local info = Modding.GetModInfo(modHandle);
			table.insert(g_CurrentModSelectionIDs, info.Id);
			
			--print("Checking mod " .. info.Name .. " for dependencies.");
			if(info.Source ~= "Map") then
				local err, xtra, sources = Modding.CanDisableMod(modHandle);
				if(err == "MissingDependencies") then						
					for i,v in ipairs(sources) do -- loop through all sources of disable block
							
						-- Add dependant mod name to list if not already in the list			
						local isDuplicate = false;
						for a,depStr in ipairs(g_DependencyIDs) do
							if(v.Id == depStr) then
								isDuplicate = true;
							end
						end
						
						if(not isDuplicate) then
							table.insert(g_DependencyIDs, v.Id);
						end					
					end		
				end
			end
		end
	
	else -- Selection is from the Disabled Mod List
	
		for c,modHandle in ipairs(g_MultiSelectedModHandle) do
			
			local info = Modding.GetModInfo(modHandle);
			table.insert(g_CurrentModSelectionIDs, info.Id);
			--print("Checking mod " .. info.Name .. " for dependencies.");
			if(info.Source ~= "Map") then
				local dependencies, references, blocks = Modding.GetModAssociations(modHandle);			
								
				if(dependencies) then				
					for i,v in ipairs(dependencies) do -- loop through all dependencies
										
						-- Add dependant mod name to list if not already in the list
						local isDuplicate = false;
						for a,depStr in ipairs(g_DependencyIDs) do
							if(v.Id == depStr) then
								isDuplicate = true;
							end
						end
						
						if(not isDuplicate) then
							table.insert(g_DependencyIDs, v.Id);
						end			
					end
				end		
			end			
		end
		
	end
	
	-- Compare dependency list with selection and enabled mod list
	for i,v in ipairs(g_EnabledModsNames) do 
		--print(v);
	end
	
	for i,modID in ipairs(g_DependencyIDs) do 
		
		local dependencyIsSelected = false; local dependencyIsEnabled = false;
		
		dependencyIsSelected = CheckIsModInSelectionByID(modID);
		dependencyIsEnabled = CheckIsModEnabledByID(modID);	

		--print("|__ A mod depends on: " .. Locale.Lookup(modID));
		--print("|____Which is also selected?: ", dependencyIsSelected);
		--print("|____Which is already enabled?: ", dependencyIsEnabled);

		if(listBeingChecked == "Enabled") then
			if(dependencyIsSelected == false and dependencyIsEnabled == true) then
				local modName = getModNameByID(modID);
				table.insert(g_FinalDependencyStrings, modName);
			end
		else
			if(dependencyIsSelected == false and dependencyIsEnabled == false) then
				local modName = getModNameByID(modID);
				table.insert(g_FinalDependencyStrings, modName);
			end
		end
	end
	

end

function RefreshModDetails()
	
	-- Check if selected mods is more than 0
	if(#g_MultiSelectedModHandle < 1) then
		-- Hide details and offer up a guidance string.
		Controls.NoModSelected:SetHide(false);
		Controls.ModDetailsContainer:SetHide(true);
		Controls.ModDetailsGrid:SetHide(true); 
	else
		Controls.NoModSelected:SetHide(true);
		Controls.ModDetailsContainer:SetHide(false);
		Controls.ModDetailsGrid:SetHide(false);

		-- If more than 1 mod is selected --------------------------------------
		if(#g_MultiSelectedModHandle > 1) then
			--print("Displaying Multi Selection Details Screen");
			Controls.ModContent:SetText(Locale.Lookup("LOC_FF16_MULTISELECT_TEASER"));
			Controls.ModTitle:SetText(Locale.Lookup("LOC_FF16_MULTISELECT_TITLE"));
			Controls.ModIdVersion:SetHide(true);
			Controls.ModPropertiesStack:SetHide(true);
			Controls.ModCompatibilityWarning:SetHide(true);
			Controls.OpenWorkshopButton:SetHide(true);
			Controls.OpenChangeLogButton:SetHide(true);
			Controls.ModLastUpdatedDateValue:SetHide(true);
			Controls.WhitelistMod:SetHide(true);
			Controls.ModDescription:SetText(Locale.Lookup("LOC_FF16_MULTISELECT_DESC") .. #g_MultiSelectedModHandle)
			Controls.ModDescription:SetAnchor("C,T");
			Controls.ModDescription:SetOffsetX(0);
			Controls.ModDescription:SetOffsetY(155);
			Controls.ModIDExportButton:SetHide(false);
						
			local modList = Modding.GetModInfo(g_MultiSelectedModHandle[1]);
			if(not modList.Enabled) then -- Behaviour for dealing with disabled mod list multiselect					
				CheckForMissingDependencies("Disabled");				
			else -- Behaviour for dealing with enabled mod list multiselect	
				CheckForMissingDependencies("Enabled");
			end
					
			-- Display dependency info
			g_DependencyListingsManager:ResetInstances();
			for i,v in ipairs(g_FinalDependencyStrings) do
				local instance = g_DependencyListingsManager:GetInstance();
				instance.Item:SetText( "[ICON_BULLET] " .. v);	
			end
			
			if(#g_FinalDependencyStrings > 0) then
				Controls.ModDependenciesStackLabel:SetText(Locale.Lookup("LOC_FF16_MULTISELECT_DEPEND"));
				Controls.ModDependenciesStack:SetHide(false);
				Controls.EnableButton:SetDisabled(true);
				Controls.EnableButton:SetToolTipString(Locale.Lookup("LOC_FF16_MULTISELECT_TOOLTIP"));
				Controls.DisableButton:SetDisabled(true);
				Controls.DisableButton:SetToolTipString(Locale.Lookup("LOC_FF16_MULTISELECT_TOOLTIP"));
			else 
				Controls.ModDependenciesStack:SetHide(true);
				Controls.EnableButton:SetDisabled(false);
				Controls.EnableButton:SetToolTipString(nil);
				Controls.DisableButton:SetDisabled(false);
				Controls.DisableButton:SetToolTipString(nil);
			end		
			
		-- If only 1 mod is selected ---------------------------------------------
		else
			Controls.ModIdVersion:SetHide(false);
			Controls.ModPropertiesStack:SetHide(false);
			Controls.ModDescription:SetAnchor("L,T");
			Controls.ModDescription:SetOffsetX(10);
			Controls.ModDescription:SetOffsetY(5);
			Controls.ModDependenciesStackLabel:SetText(Locale.Lookup("LOC_MODS_DETAILS_REFERENCES_DEPENDENCY"));
			Controls.ModIDExportButton:SetHide(true);
		
			local modHandle = g_MultiSelectedModHandle[1];
			local info = Modding.GetModInfo(modHandle);			
			local teaser = Modding.GetModProperty(modHandle, "Teaser");
			
			local bIsMap = info.Source == "Map";
			if(bIsMap) then
				Controls.ModContent:LocalizeAndSetText("LOC_MODS_WORLDBUILDER_CONTENT");
			elseif(info.Official) then
				Controls.ModContent:SetText(Locale.Lookup(info.Teaser:gsub("COLOR_RED", "169,169,169,255")));	
			else
				Controls.ModContent:SetText(info.Teaser:gsub("COLOR_RED", "169,169,169,255"));
			end
			
			local compatible = Modding.IsModCompatible(modHandle);
			Controls.ModCompatibilityWarning:SetHide(compatible);
			Controls.WhitelistMod:SetHide(compatible);

			if(not compatible) then
				Controls.WhitelistMod:SetCheck(Modding.GetIgnoreCompatibilityWarnings(modHandle));
				Controls.WhitelistMod:RegisterCallback(Mouse.eLClick, function()
					Modding.SetIgnoreCompatibilityWarnings(modHandle, Controls.WhitelistMod:IsChecked());
					RefreshListings();
				end);
			end

			-- Official/Community Icons ---------------------
			local bIsOfficial = info.Official;
			local bIsMap = info.Source == "Map";
			Controls.MapIcon:SetHide(not bIsMap);
			Controls.OfficialIcon:SetHide(bIsMap or not bIsOfficial);				
			
			if(Controls.OfficialIcon:IsVisible() == false and Controls.MapIcon:IsVisible() == false) then		
				local affectsSavedGames = Modding.GetModProperty(modHandle, "AffectsSavedGames");
				if(affectsSavedGames and tonumber(affectsSavedGames) == 0) then  -- If affects saves but not official DLC or MapMod
					Controls.CosmeticIcon:SetHide(false);
					Controls.CommunityIcon:SetHide(true);
				else
					Controls.CosmeticIcon:SetHide(true);
					Controls.CommunityIcon:SetHide(false);
				end
			else
				Controls.CosmeticIcon:SetHide(true);
				Controls.CommunityIcon:SetHide(true);			
			end

			local enableButton = Controls.EnableButton;
			local disableButton = Controls.DisableButton;
			if(info.Official and info.Allowance == false) then
				enableButton:SetHide(true);
				disableButton:SetHide(true);
			else
			
				-- If mod is currently enabled show the mod info with disable option
				local enabled = info.Enabled;
				if(enabled) then
					enableButton:SetHide(true);
					disableButton:SetHide(false);
					
					-- Check that selected mod can be disabled
					local err, xtra, sources = Modding.CanDisableMod(modHandle);
					if(err == "OK") then -- Check is ok, so disable it.
						disableButton:SetDisabled(false);
						disableButton:SetToolTipString(nil);
						disableButton:RegisterCallback(Mouse.eLClick, function()
							if(#g_MultiSelectedModHandle > 1) then
								DisableSelectedMods(g_MultiSelectedModHandle);
							else
								Modding.DisableMod(modHandle);
							end							
							ResetSelectedMods();
							RefreshListings();
						end);
					else -- check is not ok. Don't disable mod.
						disableButton:SetDisabled(true);
								
						-- Generate tip w/ list of mods to enable.
						local error_suffix;
						local tip = {};
						local items = xtra or {};						
						if(err == "OwnershipRequired") then
							error_suffix = "(" .. Locale.Lookup("LOC_MODS_DETAILS_OWNERSHIP_NO") .. ")";
						end
						if(err == "MissingDependencies") then
							tip[1] = Locale.Lookup("LOC_MODS_DISABLE_ERROR_DEPENDS");
							items = sources or {}; -- show sources of errors rather than targets of error.
						else
							tip[1] = Locale.Lookup("LOC_MODS_DISABLE_ERROR") .. err;
						end

						-- List mod references that require this mod.
						for k,ref in ipairs(items) do
							local item = "[ICON_BULLET] " .. Locale.Lookup(ref.Name);
							if(error_suffix) then
								item = item .. " " .. error_suffix;
							end
							table.insert(tip, item);
						end
						disableButton:SetToolTipString(table.concat(tip, "[NEWLINE]"));
					end
					
				-- If mod is currently disabled show the mod info with enable option
				else
					enableButton:SetHide(false);
					disableButton:SetHide(true);
								
					local err, xtra = Modding.CanEnableMod(modHandle);
					if(err == "MissingDependencies") then
						-- Don't replace xtra since we want the old list to enumerate missing mods.
						err, _ = Modding.CanEnableMod(modHandle, true);
					end

					-- Check that selected mod can be enabled
					if(err == "OK") then
						enableButton:SetDisabled(false);
						if(xtra and #xtra > 0) then
							-- Generate tip w/ list of mods to enable.
							local tip = {Locale.Lookup("LOC_MODS_ENABLE_INCLUDE")};
							for k,ref in ipairs(xtra) do
								table.insert(tip, "[ICON_BULLET] " .. Locale.Lookup(ref.Name));
							end
							enableButton:SetToolTipString(table.concat(tip, "[NEWLINE]"));
						else	
							enableButton:SetToolTipString(nil);
						end

						enableButton:RegisterCallback(Mouse.eLClick, function()
							if(#g_MultiSelectedModHandle > 1) then
								EnableSelectedMods(g_MultiSelectedModHandle);
							else
								Modding.EnableMod(modHandle, true);
								Modding.SetIgnoreCompatibilityWarnings(modHandle, true);
							end
							ResetSelectedMods();
							RefreshListings();
						end);
					else
						enableButton:SetDisabled(true);
						
						if(err == "ContainsDuplicates") then
							enableButton:SetToolTipString(Locale.Lookup("LOC_MODS_ERROR_MOD_VERSION_ALREADY_ENABLED"));
						else
							-- Generate tip w/ list of mods to enable.
							local error_suffix;

							if(err == "OwnershipRequired") then
								error_suffix = "(" .. Locale.Lookup("LOC_MODS_DETAILS_OWNERSHIP_NO") .. ")";
							end

							local tip = {Locale.Lookup("LOC_MODS_ENABLE_ERROR")};
							for k,ref in ipairs(xtra) do
								local item = "[ICON_BULLET] " .. Locale.Lookup(ref.Name);
								if(error_suffix) then
									item = item .. " " .. error_suffix;
								end

								table.insert(tip, item);
							end
							enableButton:SetToolTipString(table.concat(tip, "[NEWLINE]"));
						end		
						
					end
				end
			end

			Controls.ModTitle:LocalizeAndSetText(info.Name, 64);
			Controls.ModIdVersion:SetText(Locale.Lookup("LOC_FF16_MODID") .. ": " .. info.Id);

			local desc = Modding.GetModProperty(g_MultiSelectedModHandle[1], "Description") or info.Teaser;
			if(desc) then
				desc = Modding.GetModText(g_MultiSelectedModHandle[1], desc) or desc
				Controls.ModDescription:LocalizeAndSetText(desc:gsub("COLOR_RED", "169,169,169,255"));
				Controls.ModDescription:SetHide(false);
			else
				Controls.ModDescription:SetHide(true);
			end

			local authors = Modding.GetModProperty(g_MultiSelectedModHandle[1], "Authors");
			if(authors) then
				authors = Modding.GetModText(g_MultiSelectedModHandle[1], authors) or authors
				Controls.ModAuthorsValue:LocalizeAndSetText(authors);

				local width, height = Controls.ModAuthorsValue:GetSizeVal();
				Controls.ModAuthorsCaption:SetSizeY(height);
				Controls.ModAuthorsCaption:SetHide(false);
				Controls.ModAuthorsValue:SetHide(false);
			else
				Controls.ModAuthorsCaption:SetHide(true);
				Controls.ModAuthorsValue:SetHide(true);
			end

			local specialThanks = Modding.GetModProperty(g_MultiSelectedModHandle[1], "SpecialThanks");
			if(specialThanks) then
				specialThanks = Modding.GetModText(g_MultiSelectedModHandle[1], specialThanks) or specialThanks
				Controls.ModSpecialThanksValue:LocalizeAndSetText(specialThanks);
			
				local width, height = Controls.ModSpecialThanksValue:GetSizeVal();
				Controls.ModSpecialThanksCaption:SetSizeY(height);
				Controls.ModSpecialThanksValue:SetHide(false);
				Controls.ModSpecialThanksCaption:SetHide(false);
			
			else
				Controls.ModSpecialThanksCaption:SetHide(true);
				Controls.ModSpecialThanksValue:SetHide(true);
			end
			
			if(info.Official and info.Allowance ~= nil) then
				
				Controls.ModOwnershipCaption:SetHide(false);
				Controls.ModOwnershipValue:SetHide(false);
				if(info.Allowance) then
					Controls.ModOwnershipValue:SetText("[COLOR_GREEN]" .. Locale.Lookup("LOC_MODS_YES") .. "[ENDCOLOR]");
				else
					Controls.ModOwnershipValue:SetText("[COLOR_RED]" .. Locale.Lookup("LOC_MODS_NO") .. "[ENDCOLOR]");
				end
			else
				Controls.ModOwnershipCaption:SetHide(true);
				Controls.ModOwnershipValue:SetHide(true);
			end

			local affectsSavedGames = Modding.GetModProperty(g_MultiSelectedModHandle[1], "AffectsSavedGames");
			if(affectsSavedGames and tonumber(affectsSavedGames) == 0) then
				Controls.ModAffectsSavedGamesValue:LocalizeAndSetText("LOC_MODS_NO");
			else
				Controls.ModAffectsSavedGamesValue:LocalizeAndSetText("LOC_MODS_YES");
			end

			local supportsSinglePlayer = Modding.GetModProperty(g_MultiSelectedModHandle[1], "SupportsSinglePlayer");
			local supportsMultiplayer = Modding.GetModProperty(g_MultiSelectedModHandle[1], "SupportsMultiplayer");
			
			if(supportsSinglePlayer and tonumber(supportsSinglePlayer) == 0 and supportsMultiplayer and tonumber(supportsMultiplayer) == 0 ) then
				Controls.ModSupportsSinglePlayerValue:LocalizeAndSetText("N/A");
			elseif(supportsSinglePlayer and tonumber(supportsSinglePlayer) == 0) then
				Controls.ModSupportsSinglePlayerValue:LocalizeAndSetText("[COLOR_RED]" .. Locale.Lookup("LOC_MODS_NO") .. "[ENDCOLOR]");
			else
				Controls.ModSupportsSinglePlayerValue:LocalizeAndSetText("LOC_MODS_YES");
			end
		
			if(supportsSinglePlayer and tonumber(supportsSinglePlayer) == 0 and supportsMultiplayer and tonumber(supportsMultiplayer) == 0 ) then
				Controls.ModSupportsMultiplayerValue:LocalizeAndSetText("N/A");
			elseif(supportsMultiplayer and tonumber(supportsMultiplayer) == 0) then
				Controls.ModSupportsMultiplayerValue:LocalizeAndSetText("[COLOR_RED]" .. Locale.Lookup("LOC_MODS_NO") .. "[ENDCOLOR]");
			else
				Controls.ModSupportsMultiplayerValue:LocalizeAndSetText("LOC_MODS_YES");
			end
			
			Controls.ModIsSubscribedValue:SetHide(true);
			Controls.ModIsSubscribedCaption:SetHide(true);
				
			-- Display Workshop subscription details if not a local mod.
			local thisMod = Modding.GetModInfo(g_MultiSelectedModHandle[1]);
			if(thisMod.SubscriptionId ~= nil) then
				
				Controls.ModLocallyInstalled:SetHide(true);
				local modDetails = Modding.GetSubscriptionDetails(thisMod.SubscriptionId);			
								
				-- Last Updated Info
				if(modDetails.LastUpdated ~= nil) then
					Controls.ModIsSubscribedValue:SetText(Locale.Lookup("LOC_MODS_YES"));
					Controls.ModIsSubscribedValue:SetHide(false);
					Controls.ModIsSubscribedCaption:SetHide(false);
					Controls.ModLastUpdatedDateValue:SetText(Locale.Lookup("LOC_MODS_LAST_UPDATED", modDetails.LastUpdated));
					Controls.ModLastUpdatedDateValue:SetHide(false);
				else -- Not subscribed? Might be a local install of the mod.
					Controls.ModIsSubscribedValue:SetText(Locale.Lookup("LOC_MODS_NO"));
					Controls.ModIsSubscribedValue:SetHide(false);
					Controls.ModIsSubscribedCaption:SetHide(false);
					Controls.ModLastUpdatedDateValue:SetText(Locale.Lookup("LOC_FF16_LAST_UPDATED_OFFLINE"));
					Controls.ModLastUpdatedDateValue:SetHide(false);
				end
				
				-- Links to Steam Workshop Pages
				if(Steam and Steam.IsOverlayEnabled and Steam.IsOverlayEnabled()) then
					Controls.OpenWorkshopButton:SetHide(false);
					Controls.OpenWorkshopButton:RegisterCallback(Mouse.eLClick, function()
						local url = "http://steamcommunity.com/sharedfiles/filedetails/?id=" .. thisMod.SubscriptionId;
						Steam.ActivateGameOverlayToUrl(url);
					end);
					
					Controls.OpenChangeLogButton:SetHide(false);
					Controls.OpenChangeLogButton:RegisterCallback(Mouse.eLClick, function()
						local url = "http://steamcommunity.com/sharedfiles/filedetails/changelog/" .. thisMod.SubscriptionId;
						Steam.ActivateGameOverlayToUrl(url);
					end);
				else
					Controls.OpenWorkshopButton:SetHide(false);
					Controls.OpenChangeLogButton:SetHide(true);
				end
				
			else
				Controls.ModLocallyInstalled:SetHide(false);
				Controls.ModLocallyInstalled:SetText("[COLOR_FLOAT_SCIENCE]"..Locale.Lookup("LOC_FF16_LOCALINSTALL").."[ENDCOLOR]");
				Controls.ModLastUpdatedDateValue:SetHide(true);
				Controls.OpenWorkshopButton:SetHide(true);
				Controls.OpenChangeLogButton:SetHide(true);
			end

			local dependencies, references, blocks = Modding.GetModAssociations(g_MultiSelectedModHandle[1]);
			g_DependencyListingsManager:ResetInstances();
			if(dependencies) then
				local dependencyStrings = {}
				for i,v in ipairs(dependencies) do
					dependencyStrings[i] = Locale.Lookup(v.Name);
				end
				table.sort(dependencyStrings, function(a,b) return Locale.Compare(a,b) == -1 end);

				for i,v in ipairs(dependencyStrings) do
					local instance = g_DependencyListingsManager:GetInstance();
					instance.Item:SetText( "[ICON_BULLET] " .. v);		
				end
			end
			Controls.ModDependenciesStack:SetHide(dependencies == nil or #dependencies == 0);

			
			Controls.ModDependencyItemsStack:CalculateSize();
			Controls.ModDependencyItemsStack:ReprocessAnchoring();
			Controls.ModDependenciesStack:CalculateSize();
			Controls.ModDependenciesStack:ReprocessAnchoring();	
			Controls.ModPropertiesValuesStack:CalculateSize();
			Controls.ModPropertiesValuesStack:ReprocessAnchoring();
			Controls.ModPropertiesCaptionStack:CalculateSize();
			Controls.ModPropertiesCaptionStack:ReprocessAnchoring();
			Controls.ModPropertiesStack:CalculateSize();
			Controls.ModPropertiesStack:ReprocessAnchoring();
			Controls.ModDetailsStack:CalculateSize();
			Controls.ModDetailsStack:ReprocessAnchoring();
			Controls.ModDetailsScrollPanel:CalculateInternalSize();
		end
	end
end

-- Select a specific entry in the listings.
function SelectMod(handle)
	
	-- Is selected mod enabled?
	local thisMod = Modding.GetModInfo(handle);
	local isEnabled = thisMod.Enabled;
		
	if(g_SelectedModHandle ~= handle) then
		g_SelectedModHandle = handle;
		
		--FF16 - If holding shift then add this mod handle to the multi select list.
		if(g_ShiftKeyDown) then
			local isModAlreadyInList = false;
			for i,h in ipairs(g_MultiSelectedModHandle) do
				if(h == g_SelectedModHandle) then
					isModAlreadyInList = true;
					table.remove(g_MultiSelectedModHandle, i);
					break;
				end
			end
			if(not isModAlreadyInList) then
				table.insert(g_MultiSelectedModHandle, handle);
			end
			--print(PrettyPrint(g_MultiSelectedModHandle));
		else
			g_MultiSelectedModHandle = {};
			table.insert(g_MultiSelectedModHandle, handle);
		end
		
		RefreshListingsSelectionState();
		RefreshModDetails();
			
		if(isEnabled) then
			Controls.ModDetailsGrid:SetOffsetX(415);
			Controls.DisabledModsPanel:SetHide(true);
		else
			Controls.ModDetailsGrid:SetOffsetX(0);
			Controls.EnabledModsPanel:SetHide(true);
		end
		
	else -- Same mod selected so deselect it.
		g_SelectedModHandle = nil;
		
		--FF16 - If holding shift then remove this mod handle to the multi select list.
		if(g_ShiftKeyDown) then
			for i,h in ipairs(g_MultiSelectedModHandle) do
				if(h == handle) then
					table.remove(g_MultiSelectedModHandle, i);
					break;
				end
			end
			--print(PrettyPrint(g_MultiSelectedModHandle));
		else
			g_MultiSelectedModHandle = {};
		end
		
		RefreshListingsSelectionState();
		RefreshModDetails();
		
		if(#g_MultiSelectedModHandle < 1) then
			if(isEnabled) then
				Controls.DisabledModsPanel:SetHide(false);
			else
				Controls.EnabledModsPanel:SetHide(false);
			end
		end
	end
end

function CreateModGroup()
	Controls.ModGroupEditBox:SetText("");
	Controls.CreateModGroupButton:SetDisabled(true);

	Controls.NameModGroupPopup:SetHide(false);
	Controls.NameModGroupPopupAlpha:SetToBeginning();
	Controls.NameModGroupPopupAlpha:Play();
	Controls.NameModGroupPopupSlide:SetToBeginning();
	Controls.NameModGroupPopupSlide:Play();

	Controls.ModGroupEditBox:TakeFocus();
end

function DeleteModGroup()
	local currentGroup = Modding.GetCurrentModGroup();
	local groups = Modding.GetModGroups();
	for i, v in ipairs(groups) do
		v.DisplayName = Locale.Lookup(v.Name);
	end

	table.sort(groups, function(a,b)
		if(a.SortIndex == b.SortIndex) then
			-- Sort by Name.
			return Locale.Compare(a.DisplayName, b.DisplayName) == -1;
		else
			return a.SortIndex < b.SortIndex;
		end
	end);	

	for i, v in ipairs(groups) do
		if(v.Handle ~= currentGroup) then
			Modding.SetCurrentModGroup(v.Handle);
			Modding.DeleteModGroup(currentGroup);
			break;
		end
	end

	RefreshModGroups();
	RefreshListings();
end

function EnableAllMods()
	
	local mods = {};
	if(g_CustomCollectionName == "Off") then
		mods = Modding.GetInstalledMods();
	else
		mods = FilterByCustomCollection(g_CustomCollectionNum);
	end
	
	PreprocessListings(mods);
	mods = FilterListings(mods);

	local modHandles = {};
	for i,v in ipairs(mods) do
		local err, _ =  Modding.CanEnableMod(v.Handle, true);
		if (err == "OK") then
			table.insert(modHandles, v.Handle);
		end
	end
			
	Modding.EnableMod(modHandles);
	ResetSelectedMods();
	RefreshListings();
end

function EnableSelectedMods(modHandles) --FF16 - Enable all multi selected mods

	local checkedHandles = {};
	for i,v in ipairs(modHandles) do
		local err, _ =  Modding.CanEnableMod(v, true);
		if (err == "OK") then
			table.insert(checkedHandles, v);
			Modding.SetIgnoreCompatibilityWarnings(v, true);
		end
	end

	Modding.EnableMod(checkedHandles);
	
	RefreshListings();
end

function DisableAllMods()
	
	local mods = {};
	if(g_CustomCollectionName == "Off") then
		mods = Modding.GetInstalledMods();
	else
		mods = FilterByCustomCollection(g_CustomCollectionNum);
	end
	PreprocessListings(mods);
	mods = FilterEnabledListings(mods);

	local modHandles = {};
	for i,v in ipairs(mods) do
		if(v.Id ~= "47dccacd-f1d0-4f25-bb02-deb2b528c833") then
			table.insert(modHandles, v.Handle);
		end
	end
	Modding.DisableMod(modHandles);
	
	ResetSelectedMods();
	RefreshListings();
end

function DisableSelectedMods(modHandles) --FF16 - Disable all multi selected mods

	--local checkedHandles = {};
	--for i,v in ipairs(modHandles) do
	--	local err, _ =  Modding.CanDisableMod(v, true);
	--	if (err == "OK") then
	--		table.insert(checkedHandles, v);
	--	end
	--end

	Modding.DisableMod(modHandles);
	RefreshListings();
end

function DisplayConfirmPopup(state)
	
	if(state == "Enable") then
		Controls.ConfirmPopupTitle:SetText(Locale.Lookup("LOC_FF16_ENABLEALL_QUESTION"));
		Controls.ConfirmDisableButton:SetHide(true);
		Controls.ConfirmEnableButton:SetHide(false);
	elseif(state == "Disable") then
		Controls.ConfirmPopupTitle:SetText(Locale.Lookup("LOC_FF16_DISABLEALL_QUESTION"));
		Controls.ConfirmDisableButton:SetHide(false);
		Controls.ConfirmEnableButton:SetHide(true);
	end
	Controls.ConfirmChoicePopup:SetHide(false);
end

-- FF16 - Custom function to check if mod is selected by its ID.
function CheckIsModInSelectionByID(modID)

	for i,v in ipairs(g_CurrentModSelectionIDs) do -- loop through selected mod list
		--print("Comparing " .. modID .. " with " .. v);
		if(v == modID) then -- if the dependency is in the selected list then we don't care.
			return true;
		end
	end
	
	return false;
end

-- FF16 - Custom function to check for enabled mod by its ID.
function CheckIsModEnabledByID(modID)
		
	for i,v in ipairs(g_EnabledModsNames) do
		--print("Comparing " .. modID .. " with " .. v);
		if(v == modID) then
			return true;
		end
	end
	
	return false;
end

function getModNameByID(modID)

	local installedMods = Modding.GetInstalledMods();
	for i, v in ipairs(installedMods) do
		if(v.Id == modID) then
			return v.Name;
		end		
	end
end

----------------------------------------------------------------        
-- Subscriptions Tab
----------------------------------------------------------------        
function RefreshSubscriptions()
	local subs = Modding.GetSubscriptions();
	
	g_Subscriptions = {};
	g_SubscriptionsSortingMap = {};
	g_SubscriptionsListingsManager:ResetInstances();

	Controls.NoSubscriptions:SetHide(#subs > 0);

	for i,v in ipairs(subs) do
		local instance = g_SubscriptionsListingsManager:GetInstance();
		
		table.insert(g_Subscriptions, {
			SubscriptionId = v,
			Instance = instance,
			NeedsRefresh = true
		});
	end
	UpdateSubscriptions()

	Controls.SubscriptionListingsStack:CalculateSize();
	Controls.SubscriptionListingsStack:ReprocessAnchoring();
	Controls.SubscriptionListings:CalculateInternalSize();
end
----------------------------------------------------------------  
function RefreshSubscriptionItem(item)

	local needsRefresh = false;
	local instance = item.Instance;
	local subscriptionId = item.SubscriptionId;

	local details = Modding.GetSubscriptionDetails(subscriptionId);
	
	--print(PrettyPrint(details));

	local name = details.Name;
	if(name == nil) then
		name = Locale.Lookup("LOC_MODS_SUBSCRIPTION_NAME_PENDING");
		needsRefresh = true;
	end

	instance.SubscriptionTitle:SetText(name);
	g_SubscriptionsSortingMap[tostring(instance.SubscriptionInstanceRoot)] = name;

	if(details.LastUpdated) then
		instance.LastUpdated:SetText(Locale.Lookup("LOC_MODS_LAST_UPDATED", details.LastUpdated));
	end
	
	instance.UnsubscribeButton:SetHide(true);

	local status = details.Status;
	instance.SubscriptionDownloadProgress:SetHide(status ~= "Downloading");
	if(status == "Downloading") then
		local downloaded, total = Modding.GetSubscriptionDownloadStatus(subscriptionId);

		if(total > 0) then
			local w = instance.SubscriptionInstanceRoot:GetSizeX();
			local pct = downloaded/total;

			instance.SubscriptionDownloadProgress:SetSizeX(math.floor(w * pct));
			instance.SubscriptionDownloadProgress:SetHide(false);
		else
			instance.SubscriptionDownloadProgress:SetHide(true);
		end

		instance.SubscriptionStatus:LocalizeAndSetText("LOC_MODS_SUBSCRIPTION_DOWNLOADING", downloaded, total);
	else
		local statusStrings = {
			["Installed"] = "LOC_MODS_SUBSCRIPTION_DOWNLOAD_INSTALLED",
			["DownloadPending"] = "LOC_MODS_SUBSCRIPTION_DOWNLOAD_PENDING",
			["Subscribed"] = "LOC_MODS_SUBSCRIPTION_SUBSCRIBED"
		};
		instance.SubscriptionStatus:LocalizeAndSetText(statusStrings[status]);
	end

	if(Steam and Steam.IsOverlayEnabled and Steam.IsOverlayEnabled()) then
		instance.SubscriptionViewButton:SetHide(false);
		instance.SubscriptionViewButton:RegisterCallback(Mouse.eLClick, function()
			local url = "http://steamcommunity.com/sharedfiles/filedetails/?id=" .. subscriptionId;
			Steam.ActivateGameOverlayToUrl(url);
		end);
	else
		instance.SubscriptionViewButton:SetHide(true);
	end

	-- If we're downloading or about to download, keep refreshing the details.
	if(status == "Downloading" or status == "DownloadingPending") then
		needsRefresh = true;
		instance.SubscriptionUpdateButton:SetHide(true);
	else
		local needsUpdate = details.NeedsUpdate;
		if(needsUpdate) then
			instance.SubscriptionUpdateButton:SetHide(false);
			instance.SubscriptionUpdateButton:RegisterCallback(Mouse.eLClick, function()
				Modding.UpdateSubscription(subscriptionId);
				RefreshSubscriptions();
			end);
		else
			instance.SubscriptionUpdateButton:SetHide(true);
			instance.UnsubscribeButton:SetHide(false);
			instance.UnsubscribeButton:RegisterCallback(Mouse.eLClick, function()
				Modding.Unsubscribe(subscriptionId);
				instance.SubscriptionInstanceRoot:SetHide(true);
			end);
		end
	end


	instance.SubscriptionInstanceRoot:SetHide(false);
	item.NeedsRefresh = needsRefresh;
end
----------------------------------------------------------------  
function SortSubscriptionListings(a,b)
	-- ForgUI requires a strict weak ordering sort.
	local ap = g_SubscriptionsSortingMap[tostring(a)];
	local bp = g_SubscriptionsSortingMap[tostring(b)];

	if(ap == nil and bp ~= nil) then
		return true;
	elseif(ap == nil and bp == nil) then
		return tostring(a) < tostring(b);
	elseif(ap ~= nil and bp == nil) then
		return false;
	else
		return Locale.Compare(ap, bp) == -1;
	end
end
----------------------------------------------------------------  
function UpdateSubscriptions()
	local updated = false;
	if(g_Subscriptions) then
		for i, v in ipairs(g_Subscriptions) do
			if(v.NeedsRefresh) then
				RefreshSubscriptionItem(v);
				updated = true;
			end
		end
	end

	if(updated) then
		Controls.SubscriptionListingsStack:SortChildren(SortSubscriptionListings);
	end
end


----------------------------------------------------------------        
-- Input Handler
----------------------------------------------------------------        
function KeyHandler( key:number, pressType:number )
	--FF16 - Handler for if Shift key held down.
	if key == Keys.VK_SHIFT and pressType == 1 then
		g_ShiftKeyDown = true;		
		return true;
	else
		g_ShiftKeyDown = false;
	end	
	
	--FF16 - Handler for if escape key behaviour
	if key == Keys.VK_ESCAPE and pressType == 0	then
		if(Controls.NameModGroupPopup ~= nil and Controls.NameModGroupPopup:IsVisible()) then
			Controls.NameModGroupPopup:SetHide(true);
		elseif(Controls.ModDetailsGrid:IsVisible() == true) then
			SelectMod(g_SelectedModHandle);
			UI.PlaySound("Play_UI_Click");
		else
			HandleExitRequest();
		end
		return true;
	end
		
	return false;
end
function OnInputHandler( pInputStruct:table )
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyDown then KeyHandler( pInputStruct:GetKey(), 1 ); end;
	if uiMsg == KeyEvents.KeyUp then KeyHandler( pInputStruct:GetKey(), 0 ); end;
	return true;
end

----------------------------------------------------------------  
function OnInstalledModsTabClick(bForce)
	if(Controls.InstalledTabPanel:IsHidden() or bForce) then
		Controls.SubscriptionsTabPanel:SetHide(true);
		Controls.InstalledTabPanel:SetHide(false);

		-- Clear search queries.
		g_SearchQuery = nil;
		g_SelectedModHandle = nil;

		Controls.SearchEditBox:SetText(LOC_MODS_SEARCH_NAME);
		RefreshModGroups();
		RefreshListings();
	end
end
----------------------------------------------------------------  
function OnSubscriptionsTabClick()
	if(Controls.SubscriptionsTabPanel:IsHidden() or bForce) then
		Controls.InstalledTabPanel:SetHide(true);
		Controls.SubscriptionsTabPanel:SetHide(false);

		RefreshSubscriptions();
	end
end
----------------------------------------------------------------  
function OnOpenWorkshop()
	if (Steam ~= nil) then
		Steam.ActivateGameOverlayToWorkshop();
	end
end

----------------------------------------------------------------  
function OnWorldBuilder()
	local worldBuilderMenu = ContextPtr:LookUpControl("/FrontEnd/MainMenu/WorldBuilder");
	if (worldBuilderMenu ~= nil) then
		GameConfiguration.SetWorldBuilderEditor(true);
		UIManager:QueuePopup(worldBuilderMenu, PopupPriority.Current);
	end
end

----------------------------------------------------------------    
function OnShow()
	OnInstalledModsTabClick(true);
	UpdateTips();
	if(GameConfiguration.IsAnyMultiplayer() or not UI.HasFeature("WorldBuilder")) then
		Controls.WorldBuilder:SetHide(false);
		Controls.BrowseWorkshop:SetHide(true);
	else
		Controls.WorldBuilder:SetHide(false);
		Controls.BrowseWorkshop:SetHide(false);
	end
end	
----------------------------------------------------------------    
function HandleExitRequest()
	GameConfiguration.UpdateEnabledMods();
	UIManager:DequeuePopup( ContextPtr );
end
----------------------------------------------------------------  
function PostInit()
	if(not ContextPtr:IsHidden()) then
		OnShow();
	end
end

function OnUpdate(delta)
	-- Overkill..
	UpdateSubscriptions();
end
----------------------------------------------------------------  
-- ===========================================================================
--	Handle Window Sizing
-- ===========================================================================
function Resize()
	local screenX, screenY:number = UIManager:GetScreenSizeVal();
	local hideLogo = true;
	if(screenY >= MIN_SCREEN_Y + (Controls.LogoContainer:GetSizeY()+ Controls.LogoContainer:GetOffsetY() * 2)) then
		hideLogo = false;
		Controls.MainWindow:SetSizeY(screenY- (Controls.LogoContainer:GetSizeY() + Controls.LogoContainer:GetOffsetY()));
		Controls.EnabledModsPanel:SetSizeY((Controls.InstalledTabPanel:GetSizeY()-55) - (Controls.MessageContainer:GetSizeY() - 30));
		Controls.DisabledModsPanel:SetSizeY((Controls.InstalledTabPanel:GetSizeY()-55) - (Controls.MessageContainer:GetSizeY() - 30));
		Controls.ModDetailsGrid:SetSizeY((Controls.InstalledTabPanel:GetSizeY()-55) - (Controls.MessageContainer:GetSizeY() - 30));	
	else
		Controls.MainWindow:SetSizeY(screenY);
		Controls.EnabledModsPanel:SetSizeY((Controls.InstalledTabPanel:GetSizeY()-55));
		Controls.DisabledModsPanel:SetSizeY((Controls.InstalledTabPanel:GetSizeY()-55));
		Controls.ModDetailsGrid:SetSizeY((Controls.InstalledTabPanel:GetSizeY()-55)); 
	end
	Controls.LogoContainer:SetHide(hideLogo);
	Controls.MessageContainer:SetHide(hideLogo);
	
end

function OnSearchBarGainFocus()
	Controls.SearchEditBox:ClearString();
end

function OnEnabledSearchBarGainFocus()
	Controls.Enabled_SearchEditBox:ClearString();
end

----------------------------------------------------------------
function OnUpdateUI( type:number, tag:string, iData1:number, iData2:number, strData1:string )   
  if type == SystemUpdateUI.ScreenResize then
    Resize();
  end
end

function OnSearchCharCallback()
	local str = Controls.SearchEditBox:GetText();
	if (str ~= nil and #str > 0 and str ~= LOC_MODS_SEARCH_NAME) then
		g_SearchQuery = str;
		RefreshListings();
	elseif(str == nil or #str == 0) then
		g_SearchQuery = nil;
		RefreshListings();
	end
end

function OnEnabledSearchCharCallback()
	local str = Controls.Enabled_SearchEditBox:GetText();
	if (str ~= nil and #str > 0 and str ~= LOC_MODS_SEARCH_NAME) then
		g_EnabledSearchQuery = str;
		RefreshListings();
	elseif(str == nil or #str == 0) then
		g_EnabledSearchQuery = nil;
		RefreshListings();
	end
end

--FF16 - Reset selection
function ResetSelectedMods()
	g_SelectedModHandle = nil;
	g_MultiSelectedModHandle = {};
end

---------------------------------------------------------------------------
-- Sort By Pulldown setup
-- Must exist below callback function names
---------------------------------------------------------------------------
function SortListingsByName(mods)
	table.sort(mods, function(a,b) 
		return Locale.Compare(a.StrippedDisplayName, b.StrippedDisplayName) == -1;
	end);
end

function SortListingsByNameAndDependancy(mods)
	table.sort(mods, function(a,b) 
		return Locale.Compare(a.StrippedDisplayName, b.StrippedDisplayName) == -1;
	end);
	
	SortListingsByDependancy(mods);
	SortListingsByDependancy(mods); -- Second Pass
end
--FF16 - Arrange mods so that they appear below the mod they are dependant on. I only vaguely understand how this works.. and I wrote it. 
function SortListingsByDependancy(mods)

	local modHandle = nil;
	
	-- Loop through mod list
	for i,v in ipairs(mods) do
		modHandle = v.Handle;
		
		if not(v.Official) then
			local dependencies, references, blocks = Modding.GetModAssociations(modHandle);
			-- Get mod with dependency	
								
			local dependencyStrings = {};	
			local dependencyID = {};
			for a,d in ipairs(dependencies) do
				dependencyID[a] = d.Id;
				dependencyStrings[a] = Locale.Lookup(d.Name);
			end
			
			if(dependencyID[1] ~= nil) then
			
				--print(v.Name, "depends on: ", dependencyStrings[1], dependencyID[1]);
				
				-- Check mod table for matching ID
				for i2,v2 in ipairs(mods) do
					if(v2.Id == dependencyID[1]) then
						--print("|___", v2.Name, " is in slot ", i2 );
						if(v.Enabled == v2.Enabled) then -- only move if both mods in same list.
							table.insert(mods, i2+1 ,table.remove(mods,i)) -- move current mod in top level loop to slot after dependency
							--print("|_____________Moving ", v.Name, "to slot", i2+1);
	
							-- Add the mod with a dependency to a list for reference later
							local isDuplicate = false;
							for k, dm in ipairs(g_DependantModList) do
								if(v.iD == dm) then
									isDuplicate = true;
								end
							end
							
							if not(isDuplicate) then -- Don't add the same mod twice!
								table.insert(g_DependantModList, v.Id);
							end
						end
						break;
					end
				end			
			end
		end
	end
end

function SortListingsByAuthor(mods)
	table.sort(mods, function(a,b) 
		local a_Author = Modding.GetModProperty(a.Handle, "Authors");
		local b_Author = Modding.GetModProperty(b.Handle, "Authors");
		if(a_Author == nil) then
			a_Author = "";
		end
		if(b_Author == nil) then
			b_Author = "";
		end
				
		return (a_Author < b_Author) or (a_Author == b_Author and a.StrippedDisplayName < b.StrippedDisplayName)
	end);
end

function SortListingsByCompatibility(mods)
	
	table.sort(mods, function(a,b) 
		local a_IsCompat = tostring(Modding.IsModCompatible(a.Handle));
		local b_IsCompat = tostring(Modding.IsModCompatible(b.Handle));
		
		return (a_IsCompat > b_IsCompat) or (a_IsCompat == b_IsCompat and a.StrippedDisplayName < b.StrippedDisplayName)
	end);
	
end

function SortListingsByLastUpdated(mods)
	
	table.sort(mods, function(a,b) 
		
		local a_UpdateTime = 0;
		local b_UpdateTime = 0;
		
		if(a.SubscriptionId ~= nil and a.SubscriptionId ~= 0) then
			local details = Modding.GetSubscriptionDetails(a.SubscriptionId);
			if details and details.LastUpdated then
				a_UpdateTime = details.LastUpdated;
			end
		end
				
		if(b.SubscriptionId ~= nil and a.SubscriptionId ~= 0) then
			local details = Modding.GetSubscriptionDetails(b.SubscriptionId);
			if details and details.LastUpdated then
				b_UpdateTime = details.LastUpdated;
			end
		end
		
		return (a_UpdateTime > b_UpdateTime);
	end);
	
end

---------------------------------------------------------------------------
function SortListingsByEnabled(mods)
	table.sort(mods, function(a,b)
		if(a.Enabled == b.Enabled) then
			-- Sort by Name.
			return Locale.Compare(a.StrippedDisplayName, b.StrippedDisplayName) == -1;
		else
			return a.Enabled;
		end
	end);	
end
---------------------------------------------------------------------------
local g_SortListingsOptions = {
	{"LOC_MODS_SORTBY_NAME", SortListingsByName},
	{"LOC_FF16_SORTBY_DEPENDENCY", SortListingsByNameAndDependancy},
	{"LOC_FF16_SORTBY_AUTHOR", SortListingsByAuthor},
	{"LOC_FF16_SORTBY_LASTUPDATED", SortListingsByLastUpdated},
	{"LOC_FF16_SORTBY_COMPATIBILITY", SortListingsByCompatibility},
	-- {"LOC_MODS_SORTBY_ENABLED", SortListingsByEnabled},
};
---------------------------------------------------------------------------
function InitializeSortListingsPulldown()
	local sortByPulldown = Controls.SortListingsPullDown;
	sortByPulldown:ClearEntries();
	for i, v in ipairs(g_SortListingsOptions) do
		local controlTable = {};
		sortByPulldown:BuildEntry( "InstanceOne", controlTable );
		controlTable.Button:LocalizeAndSetText(v[1]);
		controlTable.Button:SetSizeX(491);
	
		controlTable.Button:RegisterCallback(Mouse.eLClick, function()
			sortByPulldown:GetButton():LocalizeAndSetText( v[1] );
			g_CurrentListingsSortName = v[1];
			g_CurrentListingsSort = v[2];
			RefreshListings();
		end);
	
	end
	sortByPulldown:CalculateInternals();

	sortByPulldown:GetButton():LocalizeAndSetText(g_SortListingsOptions[1][1]);
	g_CurrentListingsSort = g_SortListingsOptions[1][2];
end


function InitializeCustomCollectionPulldown()
	
	-- Import all custom defined collections
	ImportCustomCollections(tonumber(Locale.Lookup("LOC_FF16_NUMOF_CUSTOM_FILTERS")));
	
	-- Add collection names to pulldown
	local customCollectionPulldown = Controls.CustomCollectionPullDown;
	customCollectionPulldown:ClearEntries();
	for i, v in ipairs(g_CustomCollectionOptions) do
		local controlTable = {};
		customCollectionPulldown:BuildEntry( "InstanceOne", controlTable );
		controlTable.Button:LocalizeAndSetText(Locale.Lookup("LOC_FF16_CUSTOM_FILTER") .. " " .. v[1]);
		controlTable.Button:SetSizeX(491);
	
		controlTable.Button:RegisterCallback(Mouse.eLClick, function()
			customCollectionPulldown:GetButton():LocalizeAndSetText(Locale.Lookup("LOC_FF16_CUSTOM_FILTER") .. " "  .. v[1] );
			g_CustomCollectionName = v[1];
			g_CustomCollectionNum = v[2];
			RefreshListings();
		end);
	end
	customCollectionPulldown:CalculateInternals();
	customCollectionPulldown:GetButton():LocalizeAndSetText(Locale.Lookup("LOC_FF16_CUSTOM_FILTER") .. " "  .. g_CustomCollectionOptions[1][1]);

end

function InitializeCustomAdditionalNotations()
	-- Import all custom defined collections for notations
	local numCollections = tonumber(Locale.Lookup("LOC_FF16_NUMOF_CUSTOM_NOTATIONS"));
	for i=1, numCollections do
		local customCollection = "LOC_FF16_CUSTOM_NOTATION_" .. i;
		local customCollectionString = Locale.Lookup(customCollection);
		
		local customCollectionSplit 	= strSplit(customCollectionString, ";");
		local customCollectionName 		= customCollectionSplit[1];
		local customCollectionTooltip 	= customCollectionSplit[2];
		local customCollectionModIDs 	= customCollectionSplit[3];
		-- print(customCollectionName, customCollectionColor, customCollectionModIDs);
		-- Remove spaces
		if(customCollectionModIDs) then customCollectionModIDs = string.gsub(customCollectionModIDs, "%s+", "") ; end;
		-- Add collection name and mod list to global list
		table.insert(g_CustomNotationCollection, {
			name = customCollectionName,
			tooltip = customCollectionTooltip,
			mods = customCollectionModIDs}) 
	end
end

--FF16 - Export Mod ID's to log file:close
function ExportModIDs()
	UI.PlaySound("Confirm_Bed_Positive");
	numOfCurrentFilters = tonumber(Locale.Lookup("LOC_FF16_NUMOF_CUSTOM_FILTERS"))

	print("==============================================================================");
	print("Exported Mod List from Enhanced Mod Manager")
	print("==============================================================================");
	print("Exported - " .. os.date("%m/%d/%Y %I:%M %p"));
	print("Instructions: Copy the text below into CustomFilters.xml in the mod directory.");
		
	--print("<Row Tag=\"LOC_FF16_CUSTOM_FILTER_#\" Language=\"en_US\">");
	--print("<Text>New Filter Name;");
	
	modIDList_string = "------------------------------------------------------------------------------";
	modIDList_string = modIDList_string .. "\n<Row Tag=\"LOC_FF16_CUSTOM_FILTER_" .. numOfCurrentFilters+1 .. "\" Language=\"en_US\">\n"
	modIDList_string = modIDList_string .. "	<Text>New Filter Name;\n	"
	
	for modID, modHandle in ipairs(g_MultiSelectedModHandle) do
		modInfo = Modding.GetModInfo(modHandle);
		
		if(modID % 20 ~= 0) then
		
			if next(g_MultiSelectedModHandle,modID) == nil then
				modIDString = modInfo.Id .. "," .. " -- " .. modInfo.Name .. "\n	";
			else
				modIDString = modInfo.Id .. "," .. " -- " .. modInfo.Name .. ",\n	";
			end
			
			modIDList_string = modIDList_string .. modIDString
			
		else
			if next(g_MultiSelectedModHandle,modID) == nil then
				modIDString = modInfo.Id .. "," .. " -- " .. modInfo.Name;
			else
				modIDString = modInfo.Id .. "," .. " -- " .. modInfo.Name .. ",";
			end
			
			modIDList_string = modIDList_string .. modIDString
		
			print(modIDList_string);
			modIDList_string = "------------------ Continued Below (DELETE THIS LINE) ------------------------\n	"
		end
		
		-- print(modInfo.Id .. "," .. " <!-- " .. modInfo.Name .. " -->");
	end
	
	modIDList_string = modIDList_string .. "</Text>\n"
	modIDList_string = modIDList_string .. "</Row>"
		
	print(modIDList_string);
	print("------------------------------------------------------------------------------");
	
end

-- FF16 - Custom Collection Import
function ImportCustomCollections(numCollections:number)
		
	-- Add default option
	table.insert(g_CustomCollectionOptions, {Locale.Lookup("LOC_FF16_CUSTOM_FILTER_OFF"), 1})	
		
	for i=1, numCollections do
		local customCollection = "LOC_FF16_CUSTOM_FILTER_" .. i;
		local customCollectionString = Locale.Lookup(customCollection);
		
		local customCollectionSplit = strSplit(customCollectionString, ";");
		local customCollectionName = customCollectionSplit[1];
		local customCollectionModIDs = customCollectionSplit[2];
		
		-- Remove spaces
		if(customCollectionModIDs) then customCollectionModIDs = string.gsub(customCollectionModIDs, "%s+", "") ; end;
		
		-- Add collection name and function to call to options
		table.insert(g_CustomCollectionOptions, {customCollectionName, i+1})
		-- Add collection name and mod list to global list
		table.insert(g_CustomCollection, {name = customCollectionName, mods = customCollectionModIDs}) 
	end
end

-- FF16 - Called by pulldown selection, show only mods in custom collection
function FilterByCustomCollection(collectionNum:number)
	local customCollectionMods = {};	
	--print("Showing: " .. g_CustomCollection[collectionNum].name);
	local modListString = g_CustomCollection[collectionNum].mods	
	local modList = strSplit(modListString, ",");
	
	local installedMods = Modding.GetInstalledMods();
	for i, v in ipairs(installedMods) do
		for a, modID in ipairs(modList) do
			if(v.Id == modID) then
				table.insert(customCollectionMods, v);
			end		
		end
	end
	
	return customCollectionMods;
end



--FF16 - Populate a list of tips to display at random. Probably a better and less lazy way to do this..
function UpdateTips()
	
	local tipArray = {};
	local totalTips = tonumber(Locale.Lookup("LOC_FF16_MODSCREEN_TIP_NUM"));
	
	for i=1,totalTips do
		local tipString = tostring("LOC_FF16_MODSCREEN_TIP_" .. i)
		table.insert(tipArray, Locale.Lookup(tipString));
	end

	local tipNum = math.random (#tipArray)
	Controls.MessageText:SetText(tipArray[tipNum]);	
end



function strSplit(self, delimiter)
    local result = {};
    for match in (self..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


	
	
	

function Initialize()
	ContextPtr:SetInputHandler( OnInputHandler, true );
	
	Controls.EnableAll:RegisterCallback(Mouse.eLClick, function()
		DisplayConfirmPopup('Enable');
	end);
	Controls.DisableAll:RegisterCallback(Mouse.eLClick, function()
		DisplayConfirmPopup('Disable');
	end);
	Controls.CreateModGroup:RegisterCallback(Mouse.eLClick, CreateModGroup);
	Controls.DeleteModGroup:RegisterCallback(Mouse.eLClick, DeleteModGroup);
	
	if(not Search.CreateContext(g_SearchContext, "[COLOR_LIGHTBLUE]", "[ENDCOLOR]", "...")) then
		--print("Failed to create mods browser search context!");
	end
	Controls.SearchEditBox:RegisterStringChangedCallback(OnSearchCharCallback);
	Controls.SearchEditBox:RegisterHasFocusCallback(OnSearchBarGainFocus);
	
	Controls.Enabled_SearchEditBox:RegisterStringChangedCallback(OnEnabledSearchCharCallback);
	Controls.Enabled_SearchEditBox:RegisterHasFocusCallback(OnEnabledSearchBarGainFocus);

	local refreshListings = function() RefreshListings(); end;
	Controls.ShowOfficialContent:RegisterCallback(Mouse.eLClick, refreshListings);
	Controls.ShowCommunityContent:RegisterCallback(Mouse.eLClick, refreshListings);
	
	Controls.ShowAffectsSaves:RegisterCallback(Mouse.eLClick, function()
		RefreshListings();
	end);
	
	Controls.ShowNotAffectsSaves:RegisterCallback(Mouse.eLClick, function()
		RefreshListings();
	end);
	
	Controls.Enabled_ShowOfficialContent:RegisterCallback(Mouse.eLClick, function()
		RefreshListings();
	end);

	Controls.Enabled_ShowCommunityContent:RegisterCallback(Mouse.eLClick, function()
		RefreshListings();
	end);
	
	Controls.Enabled_ShowAffectsSaves:RegisterCallback(Mouse.eLClick, function()
		RefreshListings();
	end);
	
	Controls.Enabled_ShowNotAffectsSaves:RegisterCallback(Mouse.eLClick, function()
		RefreshListings();
	end);


		
	--FF16 - Buttons for confirming enable/disable all mods.
	Controls.CancelButton:RegisterCallback(Mouse.eLClick, function()
		Controls.ConfirmChoicePopup:SetHide(true);
	end);
	Controls.ConfirmEnableButton:RegisterCallback(Mouse.eLClick, function()
		EnableAllMods();
		Controls.ConfirmChoicePopup:SetHide(true);
	end);
	Controls.ConfirmDisableButton:RegisterCallback(Mouse.eLClick, function()
		DisableAllMods();
		Controls.ConfirmChoicePopup:SetHide(true);
	end);

	Controls.CancelBindingButton:RegisterCallback(Mouse.eLClick, function()
		Controls.NameModGroupPopup:SetHide(true);
	end);
	
	--FF16 - Button for export MOD ID's to the log
	Controls.ModIDExportButton:RegisterCallback(Mouse.eLClick, function()
		ExportModIDs();
	end);

	Controls.CreateModGroupButton:RegisterCallback(Mouse.eLClick, function()
		Controls.NameModGroupPopup:SetHide(true);
		local groupName = Controls.ModGroupEditBox:GetText();
		local currentGroup = Modding.GetCurrentModGroup();
		Modding.CreateModGroup(groupName, currentGroup);
		RefreshModGroups();
		RefreshListings();
	end);

	Controls.ModGroupEditBox:RegisterStringChangedCallback(function()
		local str = Controls.ModGroupEditBox:GetText();
		Controls.CreateModGroupButton:SetDisabled(str == nil or #str == 0);
	end);

	Controls.ModGroupEditBox:RegisterCommitCallback(function()
		local str = Controls.ModGroupEditBox:GetText();
		if(str and #str > 0) then
			Controls.NameModGroupPopup:SetHide(true);
			local currentGroup = Modding.GetCurrentModGroup();
			Modding.CreateModGroup(str, currentGroup);
			RefreshModGroups();
			RefreshListings();
		end
	end);

	if(Steam ~= nil and Steam.GetAppID() ~= 0) then
		Controls.SubscriptionsTab:RegisterCallback(Mouse.eLClick, function() OnSubscriptionsTabClick() end);
		Controls.SubscriptionsTab:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
		Controls.SubscriptionsTab:SetHide(false);
	else
		Controls.SubscriptionsTab:SetHide(true);
	end

	local pFriends = Network.GetFriends();
	if(pFriends ~= nil and pFriends:IsOverlayEnabled()) then
		Controls.BrowseWorkshop:RegisterCallback( Mouse.eLClick, OnOpenWorkshop );
		Controls.BrowseWorkshop:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	else
		Controls.BrowseWorkshop:SetDisabled(true);
	end
	Controls.ShowOfficialContent:SetCheck(false);
	Controls.ShowCommunityContent:SetCheck(true);
	Controls.ShowAffectsSaves:SetCheck(true);
	Controls.ShowNotAffectsSaves:SetCheck(true);
	Controls.Enabled_ShowOfficialContent:SetCheck(false);
	Controls.Enabled_ShowCommunityContent:SetCheck(true);
	Controls.Enabled_ShowAffectsSaves:SetCheck(true);
	Controls.Enabled_ShowNotAffectsSaves:SetCheck(true);

	InitializeSortListingsPulldown();
	InitializeCustomCollectionPulldown();
	InitializeCustomAdditionalNotations();
	
	Resize();
	Controls.InstalledTab:RegisterCallback(Mouse.eLClick, function() OnInstalledModsTabClick() end);
	Controls.InstalledTab:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.CloseButton:RegisterCallback( Mouse.eLClick, HandleExitRequest );
	Controls.CloseButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	Controls.WorldBuilder:RegisterCallback(Mouse.eLClick, OnWorldBuilder);
	Controls.WorldBuilder:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	Events.SystemUpdateUI.Add( OnUpdateUI );

	ContextPtr:SetShowHandler( OnShow );
	ContextPtr:SetUpdate(OnUpdate);
	ContextPtr:SetPostInit(PostInit);	
	
	--FF16 - Display nice icon in middle of screen. =D
	local icon:string = "ICON_GENERIC_GREAT_PERSON_INDIVIDUAL_ENGINEER";
	Controls.Portrait:SetIcon(icon);
	
	print("FinalFreak16: Loading Mod - Enhanced Mod Manager.");
end

Initialize();
