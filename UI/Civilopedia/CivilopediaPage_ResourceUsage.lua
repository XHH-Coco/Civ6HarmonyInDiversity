PageLayouts["HD_Resource_Usage"] = function(page)
  local sectionId = page.SectionId;
	local pageId = page.PageId;

  SetPageHeader(page.Title);
	SetPageSubHeader(page.Subtitle);

  local classificationInfo = GameInfo.HD_ResourceClassificationTypes[pageId];
	if classificationInfo == nil then return; end

  -- 行业公司特效
  if GameInfo.HD_Monopoly_Categories then
    local categoryInfo = GameInfo.HD_Monopoly_Categories[pageId:gsub('RESOURCE_CLASSIFICATION_HD_', '')];
    if categoryInfo then
      if categoryInfo.IndustryEffect then
        AddChapter("LOC_UI_PEDIA_RESOURCES_INDUSTRY_EFFECT_TEXT", Locale.Lookup("LOC_" .. categoryInfo.IndustryEffect .. "_DESCRIPTION"));
      end
      if categoryInfo.CorporationEffect then
        AddChapter("LOC_UI_PEDIA_RESOURCES_CORPORATION_EFFECT_TEXT", Locale.Lookup("LOC_" .. categoryInfo.CorporationEffect .. "_DESCRIPTION"));
      end
    end
  end

  -- 下属资源
  local resourceList = {};
  for row in GameInfo.HD_Resource_Classification() do
    if row.ResourceClassificationType == pageId then
      local resourceInfo = GameInfo.Resources[row.ResourceType];
      if resourceInfo then
        table.insert(resourceList, '[ICON_BULLET][ICON_' .. row.ResourceType .. '] ' .. Locale.Lookup(resourceInfo.Name));
      end
    end
  end

  if #resourceList > 0 then
    local resourceStr = '';
    for i, s in ipairs(resourceList) do
      if i > 1 then resourceStr = resourceStr .. '[NEWLINE]'; end
      resourceStr = resourceStr .. s;
    end
    AddChapter("LOC_UI_PEDIA_RESOURCES_TEXT", resourceStr);
  end
end