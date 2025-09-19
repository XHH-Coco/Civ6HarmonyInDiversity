-- ===========================================================================
--	Civilopedia - City-State Page Layout
-- ===========================================================================

-- C15 --
local tCityStateTypes = {}
for row in GameInfo.CSE_ClassTypes() do
	tCityStateTypes[row.Type] = {
		idx = row.Index,
		TypeName = Locale.Lookup(row.TypeName),
		LeaderType = row.LeaderType,
		SmallBonus = Locale.Lookup(row.SmallBonus),
		MediumBonus = Locale.Lookup(row.MediumBonus),
		LargeBonus = Locale.Lookup(row.LargeBonus),
		LargestBonus = Locale.Lookup(row.LargestBonus),
		BonusIcon = row.BonusIcon,
		TypeIcon = row.TypeIcon}
end
-- xiaoxiao get text
for row in GameInfo.HD_CityStateBuffedObjects() do
	local typeString = string.sub(row.TraitType, 11, string.len(row.TraitType) - 6);
	local type = tCityStateTypes[typeString];
	type[row.Level] = type[row.Level] or {};
	local objects = type[row.Level];
	if row.IsDistrict == 1 then
		local district = GameInfo.Districts[row.ObjectType];
		if district then
			table.insert(objects, {
				prereqDistrict = row.ObjectType,
				name = district.Name,
				index = district.Index,
				isDistrict = true
			});
		end
	else
		local building = GameInfo.Buildings[row.ObjectType];
		if building then
			table.insert(objects, {
				prereqDistrict = building.PrereqDistrict,
				name = building.Name,
				index = building.Index,
				isWorship = building.EnabledByReligion,
				isDistrict = false
			});
		end
	end
end
for k, v in pairs(tCityStateTypes) do
	local s = {};
	s["SMALL"]		= "";
	s["MEDIUM"]		= "";
	s["LARGE"]		= "";
	s["LARGEST"]	= "";
	for level, str in pairs(s) do
		if v[level] ~= nil then
			-- names with the following order: district -> buildings; City Center & Diplomatic Quarter -> Others
			table.sort(v[level], function (o1, o2)
				local d = o1.index - o2.index;
				if o1.isDistrict then d = d - 1024; end
				if o2.isDistrict then d = d + 1024; end
				if o1.prereqDistrict == "DISTRICT_CITY_CENTER" or o1.prereqDistrict == "DISTRICT_DIPLOMATIC_QUARTER" then d = d - 512; end
				if o2.prereqDistrict == "DISTRICT_CITY_CENTER" or o2.prereqDistrict == "DISTRICT_DIPLOMATIC_QUARTER" then d = d + 512; end
				return d < 0;
			end);
			local names = {};
			for _, object in ipairs(v[level]) do
				local name = Locale.Lookup(object.name);
				if object.isWorship then
					name = Locale.Lookup('LOC_WORSHIP_BUILDINGS');
				end
				local contains = false;
				for _, vName in ipairs(names) do
					if name == vName then
						contains = true;
					end
				end
				if not contains then
					table.insert(names, name);
				end
			end
			-- generate string
			for i, name in ipairs(names) do
				s[level] = s[level] .. name;
				if names[i + 2] ~= nil then
					s[level] = s[level] .. Locale.Lookup("LOC_COMMA");
				elseif names[i + 1] ~= nil then
					s[level] = s[level] .. Locale.Lookup("LOC_AND");
				end
			end
		end
	end
	v.SmallBonus	= string.gsub(v.SmallBonus,		"*", s["SMALL"]);
	v.MediumBonus	= string.gsub(v.MediumBonus,	"*", s["MEDIUM"]);
	v.LargeBonus	= string.gsub(v.LargeBonus,		"*", s["LARGE"]);
	v.LargestBonus	= string.gsub(v.LargestBonus,	"*", s["LARGEST"]);

	v.BonusSummary =	Locale.Lookup("LOC_MINOR_CIV_SMALL_INFLUENCE_ENVOYS")	.. " " .. v.SmallBonus
	.. "[NEWLINE]" ..	Locale.Lookup("LOC_MINOR_CIV_MEDIUM_INFLUENCE_ENVOYS")	.. " " .. v.MediumBonus
	.. "[NEWLINE]" ..	Locale.Lookup("LOC_MINOR_CIV_LARGE_INFLUENCE_ENVOYS")	.. " " .. v.LargeBonus
	.. "[NEWLINE]" ..	Locale.Lookup("LOC_MINOR_CIV_LARGEST_INFLUENCE_ENVOYS")	.. " " .. v.LargestBonus;
	print(v.BonusSummary);
end
-- xiaoxiao end
-- /C15 --

PageLayouts["CityState" ] = function(page)
    local sectionId = page.SectionId;
    local pageId = page.PageId;

    SetPageHeader(page.Title);
    SetPageSubHeader(page.Subtitle);

    local civ = GameInfo.Civilizations[pageId];
    if(civ == nil) then
        return;
    end
    local civType = civ.CivilizationType;

    -- Leaders has an Inherit from column which makes life..tricky.
    -- We need to recursively discover all leader types and use all of them.
    local base_leaders = {};
    for row in GameInfo.CivilizationLeaders() do
        if(row.CivilizationType == civType) then
            local leader = GameInfo.Leaders[row.LeaderType];
            if(leader) then
                table.insert(base_leaders, leader);
            end
	    end
    end

    function AddInheritedLeaders(leaders, leader)
        local inherit = leader.InheritFrom;
        if(inherit ~= nil) then
            local parent = GameInfo.Leaders[inherit];
            if(parent) then
                table.insert(leaders, parent);
                AddInheritedLeaders(leaders, parent);
            end
        end
    end

	-- Recurse base leaders and populate list with inherited leaders.
	local leaders = {};
    for i,v in ipairs(base_leaders) do
		table.insert(leaders, v);
		AddInheritedLeaders(leaders, v);
    end

	-- Enumerate final list and index.
	local has_leader = {};
	for i,v in ipairs(leaders) do
		has_leader[v.LeaderType] = true;
	end

	-- City-State type.
	-- Should be database-driven, but presently is not.
	-- SCOTLAD Y U NO CHANGE THIS!!! Smh
	-- C15 --
	--[[local types = {
		["LEADER_MINOR_CIV_INDUSTRIAL"] = {"ICON_CITYSTATE_INDUSTRIAL", "LOC_CITY_STATES_TYPE_INDUSTRIAL", "COLOR_PLAYER_CITY_STATE_INDUSTRIAL_SECONDARY"},
		["LEADER_MINOR_CIV_CULTURAL"] = {"ICON_CITYSTATE_CULTURE", "LOC_CITY_STATES_TYPE_CULTURAL", "COLOR_PLAYER_CITY_STATE_CULTURAL_SECONDARY"},
		["LEADER_MINOR_CIV_TRADE"] = {"ICON_CITYSTATE_TRADE", "LOC_CITY_STATES_TYPE_TRADE", "COLOR_PLAYER_CITY_STATE_TRADE_SECONDARY"},
		["LEADER_MINOR_CIV_MILITARISTIC"] = {"ICON_CITYSTATE_MILITARISTIC", "LOC_CITY_STATES_TYPE_MILITARISTIC", "COLOR_PLAYER_CITY_STATE_MILITARISTIC_SECONDARY"},
		["LEADER_MINOR_CIV_RELIGIOUS"] = {"ICON_CITYSTATE_FAITH", "LOC_CITY_STATES_TYPE_RELIGIOUS", "COLOR_PLAYER_CITY_STATE_RELIGIOUS_SECONDARY"},
		["LEADER_MINOR_CIV_SCIENTIFIC"] = {"ICON_CITYSTATE_SCIENCE", "LOC_CITY_STATES_TYPE_SCIENTIFIC", "COLOR_PLAYER_CITY_STATE_SCIENCE_SECONDARY"},

		-- KLUDGE - DLC 6 Scenario
		["LEADER_MINOR_CIV_MARITIME"] = {"ICON_CITYSTATE_MARITIME", "LOC_CITY_STATES_SCENARIO_TYPE_MARITIME", "COLOR_PLAYER_CITY_STATE_MARITIME_SECONDARY"},

		--CIVITAS MOD
		["CVS_LEADER_MINOR_CIV_AGRICULTURAL"] = {"ICON_CVS_CITYSTATE_AGRICULTURAL", "LOC_CITY_STATES_TYPE_CVS_AGRICULTURAL", "CVS_COLOR_PLAYER_CITY_STATE_AGRICULTURAL_SECONDARY"},
		["CVS_LEADER_MINOR_CIV_ARTISTIC"] = {"ICON_CVS_CITYSTATE_ARTISTIC", "LOC_CITY_STATES_TYPE_CVS_ARTISTIC", "CVS_COLOR_PLAYER_CITY_STATE_ARTISTIC_SECONDARY"},
		["CVS_LEADER_MINOR_CIV_MARITIME"] = {"ICON_CVS_CITYSTATE_MARITIME", "LOC_CITY_STATES_TYPE_MARITIME", "CVS_COLOR_PLAYER_CITY_STATE_MARITIME_SECONDARY"},
	}]]
	local types = {}
	for k, v in pairs(tCityStateTypes) do
		types[v.LeaderType] = {v.TypeIcon, v.TypeName, v.SecondaryColor, v.BonusSummary}
	end
	-- /C15 --
	local cityStateType;
	for k, v in pairs(types) do
		if(has_leader[k] == true) then
			cityStateType = v;
			break;
		end
	end

    -- Unique Abilities
    -- We're considering a unique ability to be a trait which does 
    -- not have a unique unit, building, district, or improvement associated with it.
    -- While we scrub for unique units and infrastructure, mark traits that match 
    -- so we can filter them later.
    local traits = {};
    local has_trait = {};

    -- Populate traits from civilizations.
    for row in GameInfo.CivilizationTraits() do
        if(row.CivilizationType == civType) then
            local trait = GameInfo.Traits[row.TraitType];
            if(trait) then
                table.insert(traits, trait);
            end

            has_trait[row.TraitType] = true;
        end
    end

    -- Populate traits from leaders (including inherited)
    for row in GameInfo.LeaderTraits() do
        if(has_leader[row.LeaderType] == true and has_trait[row.TraitType] ~= true) then
            local trait = GameInfo.Traits[row.TraitType];
            if(trait) then
                table.insert(traits, trait);
            end

             has_trait[row.TraitType] = true;
        end	
    end

    local unique_abilities = {};
    for i, trait in ipairs(traits) do
        if(not trait.InternalOnly) then
            table.insert(unique_abilities, trait);
        end
    end

    local preferred_religion;
    for row in GameInfo.FavoredReligions() do
        if((row.CivilizationType == civType or row.CivilizationType == nil) and (row.LeaderType == nil or has_leader[row.LeaderType] == true)) then
            local religion = GameInfo.Religions[row.ReligionType];
            if(religion) then
                preferred_religion = religion;
            end
        end
    end

    -- Random bits of info.
    local info = {};
    for row in GameInfo.CivilizationInfo() do
        if(row.CivilizationType == civType) then
            table.insert(info, row);
        end
    end
    table.sort(info, function(a, b) 
        if(a.SortIndex ~= b.SortIndex) then
            return tonumber(a.SortIndex) < tonumber(b.SortIndex);
        else
           return Locale.Compare(a.Header, b.Header) == -1;    
        end	
    end);


    -- Right Column
    -- City-States don't have unique icons...yet.
	AddPortrait("ICON_" .. civType);
	if(cityStateType ~= nil) then
		AddRightColumnStatBox("LOC_UI_PEDIA_CITY_STATE_TYPE", function(s)
			s:AddSeparator();
			local icon = {cityStateType[1], cityStateType[2], nil, cityStateType[3]};
			s:AddIconLabel(icon, cityStateType[2])
		end);
	end

    if(preferred_religion ~= nil) then
        AddRightColumnStatBox("LOC_UI_PEDIA_PREFERENCES", function(s)
            s:AddSeparator();
            if(preferred_religion ~= nil) then
                s:AddHeader("LOC_UI_PEDIA_PREFERRED_RELIGION");

                local icon = {"ICON_" .. preferred_religion.RelgionType, preferred_religion.Name, preferred_religion.RelgionType};
                s:AddIconLabel(icon, preferred_religion.Name);
                s:AddSeparator();
            end
        end);
    end

    AddRightColumnStatBox("LOC_UI_PEDIA_GEOGRAPHY_AND_SOCIAL_DATA", function(s)
        s:AddSeparator();
        for _, item in ipairs(info) do
            s:AddHeader(item.Header);
            s:AddLabel(item.Caption);
            s:AddSeparator();
        end
    end);

    -- Left Column
    if(#unique_abilities > 0) then
        AddHeader("LOC_UI_PEDIA_UNIQUE_ABILITY");
	end
	for _, item in ipairs(unique_abilities) do
		local desc = Locale.Lookup(item.Description);
		if (string.find(desc, '*') ~= nil) then
			AddHeaderBody(item.Name, cityStateType[4]);
		end
    end
    for _, item in ipairs(unique_abilities) do
		local desc = Locale.Lookup(item.Description);
		if (string.find(desc, '*') == nil) then
			AddHeaderBody(item.Name, desc);
		end
    end

    local chapters = GetPageChapters(page.PageLayoutId);
    for i, chapter in ipairs(chapters) do
        local chapterId = chapter.ChapterId;
        local chapter_header = GetChapterHeader(sectionId, pageId, chapterId);
        local chapter_body = GetChapterBody(sectionId, pageId, chapterId);

		AddChapter(chapter_header, chapter_body);
    end
end

