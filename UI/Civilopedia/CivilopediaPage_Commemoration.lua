PageLayouts["Commemoration"] = function(page)
  local sectionId = page.SectionId;
  local pageId = page.PageId;

  SetPageHeader(page.Title);
  SetPageSubHeader(page.Subtitle);
  
  local commemoration = GameInfo.CommemorationTypes[pageId];
  if(commemoration == nil) then
    return;
  end
  
  local commemorationType = commemoration.CommemorationType;

  local iconName = "ICON_" .. commemorationType;
  if GameInfo.CommemorationIcons ~= nil and GameInfo.CommemorationIcons[commemorationType] ~= nil then
    iconName = GameInfo.CommemorationIcons[commemorationType].Icon;
  end
  AddPortrait(iconName);
  
  local minEra;
  local minEraRow = GameInfo.Eras[commemoration.MinimumGameEra];
  if(minEraRow) then minEra = minEraRow.Name; end

  local maxEra;
  local maxEraRow = GameInfo.Eras[commemoration.MaximumGameEra];
  if(maxEraRow) then maxEra = maxEraRow.Name; end
  AddRightColumnStatBox("LOC_UI_PEDIA_REQUIREMENTS", function(s)
    s:AddSeparator();

    if(minEra) then
      local t = Locale.Lookup("LOC_UI_PEDIA_MIN_ERA", minEra);
      s:AddLabel(t);
    end

    if(maxEra) then
      local t = Locale.Lookup("LOC_UI_PEDIA_MAX_ERA", maxEra);
      s:AddLabel(t);
    end
      
    s:AddSeparator();
  end);
  
  -- Left Column
  local description = Locale.Lookup("LOC_MOMENT_CIVILOPEDIA_TEXT", commemoration.NormalAgeBonusDescription, commemoration.GoldenAgeBonusDescription)
  AddChapter("LOC_UI_PEDIA_DESCRIPTION", description);
end

PageLayouts["China_Commemoration"] = function(page)
  local sectionId = page.SectionId;
  local pageId = page.PageId;

  SetPageHeader(page.Title);
  SetPageSubHeader(page.Subtitle);
  
  local commemoration = GameInfo.China_AncientCommemorationTypes_HD[pageId];
  if(commemoration == nil) then
    return;
  end
  
  local commemorationType = commemoration.AncientCommemorationType;

  local iconName = "ICON_" .. commemorationType;
  if GameInfo.CommemorationIcons ~= nil and GameInfo.CommemorationIcons[commemorationType] ~= nil then
    iconName = GameInfo.CommemorationIcons[commemorationType].Icon;
  end
  AddPortrait(iconName);
  
  local unique_to = {};
  for row in GameInfo.ChinaLeaders_AncientCommemorationTypes_HD() do
    if row.AncientCommemorationType == commemorationType then
      local leader = GameInfo.Leaders[row.LeaderType];
      if leader ~= nil then
        table.insert(unique_to, {"ICON_" .. row.LeaderType, leader.Name, row.LeaderType});
      end
    end
  end

  AddRightColumnStatBox("LOC_UI_PEDIA_TRAITS", function(s)
		s:AddSeparator();
		
		if(#unique_to > 0) then
			s:AddHeader("LOC_UI_PEDIA_UNIQUE_TO");
			for _, icon in ipairs(unique_to) do
				s:AddIconLabel(icon, icon[2]);
			end
			s:AddSeparator();
		end
	end);

  -- Left Column
  local description = commemoration.Description;
  -- 对云韶府特殊处理
  if commemorationType == 'HD_CHINA_ANCIENT_COMMEMORATION_MUSIC_BOOK' then
    description = Locale.Lookup(description) .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_MOMENT_ACTION_PANEL_TEXT', 'LOC_BUILDING_HD_YUNSHAO_MANSION_NAME', 'LOC_BUILDING_HD_YUNSHAO_MANSION_DESCRIPTION')
  end
  AddChapter("LOC_UI_PEDIA_DESCRIPTION", description);
end