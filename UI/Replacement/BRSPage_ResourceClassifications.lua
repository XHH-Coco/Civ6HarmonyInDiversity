print("HD Custom BRSPage_ResourceClassifications.lua")

m_kResourceClassificationSortedIndexList = {};

function ViewResourceClassificationsPage()
  print("ViewResourceClassificationsPage");

  if g_DirtyFlag.RESOURCE_CLASSIFICATIONS then UpdateResourceClassificationData(); end

  ResetTabForNewPageContent();

  local localPlayerId = Game.GetLocalPlayer();
	local localPlayer = Players[localPlayerId];

  for _, sortedData in ipairs(m_kResourceClassificationSortedIndexList) do
    local resourceClassificationType = sortedData.ResourceClassificationType;
    local resourceClassificationInfo = GameInfo.HD_ResourceClassificationTypes[resourceClassificationType];
    if resourceClassificationInfo then
      local instance:table = NewCollapsibleGroupInstance();
      -- 设置标题
      instance.RowHeaderButton:SetText(Locale.Lookup(resourceClassificationInfo.Name));
      -- 隐藏不需要的元素
      instance.AmenitiesContainer:SetHide(true);
      instance.IndustryContainer:SetHide(true);
      instance.MonopolyContainer:SetHide(true);

      -- 获取该资源分类下属的所有资源
      local resourceList = ExposedMembers.DLHD.Utils.Classification_Resource_Map[resourceClassificationType] or {};
      -- 统计数据
      local resourceTypeAmount = 0;
      local notOwnedResourceTypeAmount = 0;
      -- 目前尚未控制的资源
      local notOwnedResourceText = '';
      -- 逐个查询玩家对资源的控制情况
      for _, resourceType in ipairs(resourceList) do
        local resourceInfo = GameInfo.Resources[resourceType];
        if resourceInfo then
          local kSingleResourceData = m_kResourceData[resourceInfo.Index];
          if kSingleResourceData and kSingleResourceData.Total > 0 then
            resourceTypeAmount = resourceTypeAmount + 1;

            local pEntryInstance:table = {};
            ContextPtr:BuildInstanceForControl("ResourcesEntryInstance", pEntryInstance, instance.ContentStack) ;
            pEntryInstance.CityName:SetText(kSingleResourceData.Icon .. " " .. Locale.Lookup(resourceInfo.Name));
            pEntryInstance.Control:SetText('');
            pEntryInstance.Amount:SetText('');
          else
            notOwnedResourceTypeAmount = notOwnedResourceTypeAmount + 1;
            notOwnedResourceText = notOwnedResourceText .. '[NEWLINE][ICON_Bullet] [ICON_' .. resourceType .. '] ' .. Locale.Lookup(resourceInfo.Name);
          end
        end
      end
      -- 资源总数
      instance.RowHeaderLabel:SetHide(false);
      instance.RowHeaderLabel:SetText(Locale.Lookup("LOC_HUD_REPORTS_TOTALS") .. " " .. resourceTypeAmount);
      -- 尚未控制的资源
      if notOwnedResourceTypeAmount > 0 then
        local title = Locale.Lookup('LOC_HD_REPORTS_NOT_OWNED_RESOURCE_TEXT', resourceClassificationInfo.Name, notOwnedResourceTypeAmount);
        notOwnedResourceText = title .. notOwnedResourceText;
        instance.Monopoly:SetText(title);
        instance.MonopolyContainer:SetToolTipString(notOwnedResourceText);
        instance.MonopolyContainer:SetHide(false);
      else
        instance.Monopoly:SetText(Locale.Lookup('LOC_HD_REPORTS_ALL_OWNED_RESOURCE_TEXT'));
        instance.MonopolyContainer:SetToolTipString(nil);
        instance.MonopolyContainer:SetHide(false);
      end

      SetGroupCollapsePadding(instance, 0);
		  RealizeGroup(instance);
    end
  end

  Controls.CollapseAll:SetHide( false );
	Controls.BottomYieldTotals:SetHide( true );
	Controls.BottomResourceTotals:SetHide( true );
	Controls.BottomPoliciesFilters:SetHide( true );
	Controls.BottomMinorsFilters:SetHide( true );
	Controls.Scroll:SetSizeY( Controls.Main:GetSizeY() - SIZE_HEIGHT_PADDING_BOTTOM_ADJUST);

  m_kCurrentTab = 10;
end

-- 更新玩家资源信息
-- 直接复用 Resources 界面的更新函数
function UpdateResourceClassificationData()
  print("UpdateResourceClassificationData");
	Timer1Start();
	m_kResourceData = GetDataResources();
	Timer1Tick("UpdateResourceClassificationData");
	g_DirtyFlag.RESOURCE_CLASSIFICATIONS = false;
end

-- =========================================================================================================
-- Initialize
-- =========================================================================================================
function InitResourceClassificationSortedIndexList()
  for row in GameInfo.HD_ResourceClassificationTypes() do
    table.insert(m_kResourceClassificationSortedIndexList, {
      ResourceClassificationType = row.ResourceClassificationType,
      SortIndex = row.SortIndex
    });
  end

  table.sort(m_kResourceClassificationSortedIndexList, function(a, b) return a.SortIndex < b.SortIndex; end)
end

function InitializeResourceClassifications()
  InitResourceClassificationSortedIndexList();
end