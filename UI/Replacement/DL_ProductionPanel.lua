-- =================================================================================
-- Import base file
-- =================================================================================
local files = {
  "ProductionPanel_Babylon_Heroes.lua",
  "ProductionPanel.lua",
}

for _, file in ipairs(files) do
  include(file)
  if Initialize then
    print("DL_ProductionPanel Loading " .. file .. " as base file");
    break
  end
end

include( "EspionageViewManager" );

-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================
BASE_CheckQueueItemSelected = CheckQueueItemSelected;
BASE_CloseAfterNewProduction = CloseAfterNewProduction;
BASE_ComposeFailureReasonStrings = ComposeFailureReasonStrings;
BASE_GetData = GetData;
BASE_OnInit = OnInit;
BASE_Open = Open;
BASE_PopulateGenericItemData = PopulateGenericItemData;
BASE_ShowHideDisabled = ShowHideDisabled;
BASE_Refresh = Refresh;
BASE_View = View;
BASE_ComposeBldgForPurchase = ComposeBldgForPurchase;

-- ===========================================================================
-- Constants
-- ===========================================================================
local LISTMODE:table = {PRODUCTION = 1, PURCHASE_GOLD = 2, PURCHASE_FAITH = 3, PROD_QUEUE = 4};
local COLOR_LOW_OPACITY :number = UI.GetColorValueFromHexLiteral(0x3fffffff);
local ICON_PREFIX :string = "ICON_";
local TXT_PRODUCTION_ITEM_REPAIR :string = Locale.Lookup("LOC_PRODUCTION_ITEM_REPAIR");

-- ===========================================================================
-- Members
-- ===========================================================================
local m_listIM              = InstanceManager:new( "NestedList",  "Top", Controls.ProductionList );
local m_purchaseListIM      = InstanceManager:new( "NestedList",  "Top", Controls.PurchaseList );
local m_purchaseFaithListIM = InstanceManager:new( "NestedList",  "Top", Controls.PurchaseFaithList );
local m_queueListIM         = InstanceManager:new( "NestedList",  "Top", Controls.QueueList );

local m_showDisabled:boolean = true;
-- local m_kRecommendedItems:table = {};
local m_kEspionageViewManager = EspionageViewManager:CreateManager();

-- ===========================================================================
-- OVERRIDE BASE FUNCTIONS
-- ===========================================================================
function ComposeBldgForPurchase(pRow:table, pCity:table, sYield:string, pYieldSource:table, sCantAffordKey:string)
  -- 排除虚拟建筑
  if ExposedMembers.DLHD.Utils.DummyBuildingList[pRow.BuildingType] == true then
    -- print("城市购买面板 已排除虚拟建筑", pRow.BuildingType)
    return false, nil;
  end

  return BASE_ComposeBldgForPurchase(pRow, pCity, sYield, pYieldSource, sCantAffordKey);
end

function CheckQueueItemSelected()
  if m_kEspionageViewManager:IsEspionageView() then
    -- Override this function which will be called before starting any production.
    -- If it's in EspionageView, return true to not start the production.
    return true;
  end
  return BASE_CheckQueueItemSelected();
end

function CloseAfterNewProduction()
  if m_kEspionageViewManager:IsEspionageView() then
    -- Don't need to close production panel if an item is selected in EspionageView.
    return;
	end
  BASE_CloseAfterNewProduction();
end

function ComposeFailureReasonStrings( isDisabled:boolean, results:table )
  local allReasonString = BASE_ComposeFailureReasonStrings(isDisabled, results);

  -- Update Magnus dummy building reason if it exists.
  local magnusDummyBuildingName = Locale.Lookup("LOC_BUILDING_DUMMY_MAGNUS_NAME");
  local expectedString = Locale.Lookup("LOC_BUILDING_CONSTRUCT_REQUIRES_BUILDING", magnusDummyBuildingName);
  if allReasonString:find(expectedString) then
    -- Replace original reason with the one without "building" suffix.
    local newString = Locale.Lookup("LOC_BUILDING_CONSTRUCT_REQUIRES_BUILDING_WITHOUT_SUFFIX", magnusDummyBuildingName);
    allReasonString = allReasonString:gsub(expectedString, newString);
  end

  return allReasonString;
end

function GetData()
  local playerID:number = Game.GetLocalPlayer();
  local pSelectedCity:table = UI.GetHeadSelectedCity();
  return GetDataHelper(playerID, pSelectedCity);
end

-- Taken from original GetData(). Refactor first few lines to be more generic that can be used by EspionageView.
function GetDataHelper(playerID:number, pSelectedCity:table)
  local pPlayer:table = Players[playerID];
  if pPlayer == nil or pSelectedCity == nil then
    Close();
    return nil;
  end

  local cityGrowth    = pSelectedCity:GetGrowth();
  local cityCulture   = pSelectedCity:GetCulture();
  local buildQueue    = pSelectedCity:GetBuildQueue();
  local playerTreasury= pPlayer:GetTreasury();
  local playerReligion= pPlayer:GetReligion();
  local cityGold      = pSelectedCity:GetGold();
  local cityBuildings = pSelectedCity:GetBuildings();
  local cityDistricts = pSelectedCity:GetDistricts();
  local cityID        = pSelectedCity:GetID();

  local new_data = {
    City                = pSelectedCity,
    Population          = pSelectedCity:GetPopulation(),
    Owner               = pSelectedCity:GetOwner(),
    Damage              = pPlayer:GetDistricts():FindID( pSelectedCity:GetDistrictID() ):GetDamage(),
    TurnsUntilGrowth    = cityGrowth:GetTurnsUntilGrowth(),
    CurrentTurnsLeft    = buildQueue:GetTurnsLeft(),
    FoodSurplus         = cityGrowth:GetFoodSurplus(),
    CulturePerTurn      = cityCulture:GetCultureYield(),
    TurnsUntilExpansion = cityCulture:GetTurnsUntilExpansion(),
    DistrictItems       = {},
    BuildingItems       = {},
    UnitItems           = {},
    ProjectItems        = {},
    BuildingPurchases   = {},
    UnitPurchases       = {},
    DistrictPurchases   = {},
  };

  m_CurrentProductionHash = buildQueue:GetCurrentProductionTypeHash();
  m_PreviousProductionHash = buildQueue:GetPreviousProductionTypeHash();

  --Must do districts before buildings
  for row in GameInfo.Districts() do
    if row.Hash == m_CurrentProductionHash then
      new_data.CurrentProduction = row.Name;

      if(GameInfo.DistrictReplaces[row.DistrictType] ~= nil) then
        new_data.CurrentProductionType = GameInfo.DistrictReplaces[row.DistrictType].ReplacesDistrictType;
      else
        new_data.CurrentProductionType = row.DistrictType;
      end
    end

    local sortIndex = ExposedMembers.DLHD.Utils.DistrictSortMap[row.DistrictType] or 10000;

    local isInPanelList :boolean = (row.Hash ~= m_CurrentProductionHash or not row.OnePerCity) and not row.InternalOnly;
    local bHasProducedDistrict :boolean = cityDistricts:HasDistrict( row.Index );
    if isInPanelList and ( buildQueue:CanProduce( row.Hash, true ) or bHasProducedDistrict ) then
      local isCanProduceExclusion, results = buildQueue:CanProduce( row.Hash, false, true );
      local isDisabled :boolean = not isCanProduceExclusion;

      -- If at least one valid plot is found where the district can be built, consider it buildable.
      local plots :table = GetCityRelatedPlotIndexesDistrictsAlternative( pSelectedCity, row.Hash );
      if plots == nil or table.count(plots) == 0 then
        -- No plots available for district. Has player had already started building it?
        local isPlotAllocated :boolean = false;
        local pDistricts :table = pSelectedCity:GetDistricts();
        for _, pCityDistrict in pDistricts:Members() do
          if row.Index == pCityDistrict:GetType() then
            isPlotAllocated = true;
            break;
          end
        end
        -- If not, this district can't be built. Guarantee that isDisabled is set.
        if not isPlotAllocated then
          isDisabled = true;
        elseif results ~= nil then
          local pFailureReasons : table = results[CityCommandResults.FAILURE_REASONS];
          if pFailureReasons ~= nil and table.count( pFailureReasons ) > 0 then
            for i,v in ipairs(pFailureReasons) do
              if v == TXT_DISTRICT_REPAIR_LOCATION_FLOODED then
                isDisabled = true;
                break;
              end
            end
          end
        end
      elseif isDisabled and results ~= nil then
        -- TODO this should probably be handled in the exposure, for example:
        -- BuildQueue::CanProduce(nDistrictHash, bExclusionTest, bReturnResults, bAllowPurchasingPlots)
        local pFailureReasons : table = results[CityCommandResults.FAILURE_REASONS];
        if pFailureReasons ~= nil and table.count( pFailureReasons ) > 0 then
          -- There are available plots to purchase, it could still be available
          isDisabled = false;
          for i,v in ipairs(pFailureReasons) do
            -- If its disabled for another reason, keep it disabled
            if v ~= "LOC_DISTRICT_ZONE_NO_SUITABLE_LOCATION" then
              isDisabled = true;
              break;
            end
          end
        end
      end

      local allReasons :string = ComposeFailureReasonStrings( isDisabled, results );
      local sToolTip :string = ToolTipHelper.GetToolTip(row.DistrictType, Game.GetLocalPlayer()) .. allReasons;

      local iProductionCost :number = buildQueue:GetDistrictCost( row.Index );
      local iProductionProgress :number = buildQueue:GetDistrictProgress( row.Index );

      -- sToolTip = sToolTip .. "[NEWLINE][NEWLINE]";
      sToolTip = sToolTip .. "[NEWLINE]" .. ComposeProductionCostString( iProductionProgress, iProductionCost);

      -- local iMaintenanceCost :number = row.Maintenance or 0;
      -- if (iMaintenanceCost ~= nil and iMaintenanceCost > 0) then
      --   local yield = GameInfo.Yields["YIELD_GOLD"];
      --   if(yield) then
      --     sToolTip = sToolTip .. "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_MAINTENANCE", iMaintenanceCost, yield.IconString, yield.Name);
      --   end
      -- end

      local bIsContaminated:boolean = cityDistricts:IsContaminated( row.Index );
      local iContaminatedTurns:number = 0;
      if bIsContaminated then
        for _, pDistrict in cityDistricts:Members() do
          local kDistrictDef:table = GameInfo.Districts[pDistrict:GetType()];
          if kDistrictDef.PrimaryKey == row.DistrictType then
            local kFalloutManager = Game.GetFalloutManager();
            local pDistrictPlot:table = Map.GetPlot(pDistrict:GetX(), pDistrict:GetY());
            iContaminatedTurns = kFalloutManager:GetFalloutTurnsRemaining(pDistrictPlot:GetIndex());
          end
        end
      end

      table.insert( new_data.DistrictItems, {
        Index               = row.Index,
        Type                = row.DistrictType,
        Name                = row.Name,
        ToolTip             = sToolTip,
        Hash                = row.Hash,
        Kind                = row.Kind,
        TurnsLeft           = buildQueue:GetTurnsLeft( row.DistrictType ),
        Disabled            = isDisabled,
        Repair              = cityDistricts:IsPillaged( row.Index ),
        Contaminated        = bIsContaminated,
        ContaminatedTurns   = iContaminatedTurns,
        Cost                = iProductionCost,
        Progress            = iProductionProgress,
        HasBeenBuilt        = bHasProducedDistrict,
        IsComplete          = cityDistricts:IsComplete( row.Index ),
        SortIndex           = sortIndex
      });
    end

    -- Can it be purchased with gold?
    local isAllowed, kDistrict = ComposeDistrictForPurchase( row, pSelectedCity, "YIELD_GOLD", playerTreasury, "LOC_BUILDING_INSUFFICIENT_FUNDS" );
    if isAllowed then
      kDistrict.Index = row.Index;
      kDistrict.SortIndex = sortIndex;
      table.insert( new_data.DistrictPurchases, kDistrict );
    end

    -- Can it be purchased with faith?
    local isAllowed, kDistrict = ComposeDistrictForPurchase( row, pSelectedCity, "YIELD_FAITH", playerReligion, "LOC_BUILDING_INSUFFICIENT_FAITH" );
    if isAllowed then
      kDistrict.Index = row.Index;
      kDistrict.SortIndex = sortIndex;
      table.insert( new_data.DistrictPurchases, kDistrict );
    end
  end

  -- 给区域排序
  table.sort(new_data.DistrictItems, function(a, b)
    if a.SortIndex ~= b.SortIndex then
      return a.SortIndex < b.SortIndex;
    else
      return a.Index < b.Index;
    end

    return false;
  end)

  table.sort(new_data.DistrictPurchases, function(a, b)
    if a.SortIndex ~= b.SortIndex then
      return a.SortIndex < b.SortIndex;
    else
      return a.Index < b.Index;
    end

    return false;
  end)

  -- Must do buildings after districts
  for row in GameInfo.Buildings() do
    if row.Hash == m_CurrentProductionHash then
      new_data.CurrentProduction = row.Name;
      new_data.CurrentProductionType= row.BuildingType;
    end

    local bCanProduce = buildQueue:CanProduce( row.Hash, true );
    local iPrereqDistrict = "";
    if row.PrereqDistrict ~= nil then
      iPrereqDistrict = row.PrereqDistrict;

      --Only add buildings if the prereq district is not the current production (this can happen when repairing)
      if new_data.CurrentProductionType == row.PrereqDistrict then
        bCanProduce = false;
      end
    end

    local tier = 0;
    local tierInfo = GameInfo.HD_BuildingTiers[row.BuildingType];
    if tierInfo then tier = tierInfo.Tier; end

    local districtSortIndex = ExposedMembers.DLHD.Utils.DistrictSortMap[iPrereqDistrict] or 10000;
    local sortIndex = districtSortIndex + tier;

    if row.Hash ~= m_CurrentProductionHash and (not row.MustPurchase or cityBuildings:IsPillaged(row.Hash)) and bCanProduce then
      local isCanStart, results = buildQueue:CanProduce( row.Hash, false, true );
      local isDisabled :boolean = not isCanStart;

      -- Did it fail and it is a Wonder?  If so, if it failed because of *just* NO_SUITABLE_LOCATION, we can look for an alternate.
      if (isDisabled and row.IsWonder and results ~= nil and results[CityOperationResults.NO_SUITABLE_LOCATION] ~= nil and results[CityOperationResults.NO_SUITABLE_LOCATION] == true) then
        local pPurchaseablePlots :table = GetCityRelatedPlotIndexesWondersAlternative( pSelectedCity, row.Hash );
        if (pPurchaseablePlots and #pPurchaseablePlots > 0) then
          isDisabled = false;
        end
      end

      local allReasons :string = ComposeFailureReasonStrings( isDisabled, results );
      local sToolTip :string = ToolTipHelper.GetBuildingToolTip( row.Hash, playerID, pSelectedCity ) .. allReasons;

      local iProductionCost :number = buildQueue:GetBuildingCost( row.Index );
      local iProductionProgress :number = buildQueue:GetBuildingProgress( row.Index );
      -- sToolTip = sToolTip .. "[NEWLINE][NEWLINE]";
      sToolTip = sToolTip .. "[NEWLINE]" .. ComposeProductionCostString( iProductionProgress, iProductionCost);

      -- local iMaintenanceCost :number = row.Maintenance or 0;
      -- if (iMaintenanceCost ~= nil and iMaintenanceCost > 0) then
      --   local yield = GameInfo.Yields["YIELD_GOLD"];
      --   if(yield) then
      --     sToolTip = sToolTip .. "[NEWLINE]" .. Locale.Lookup("LOC_TOOLTIP_MAINTENANCE", iMaintenanceCost, yield.IconString, yield.Name);
      --   end
      -- end

      -- local extraCostText = AddBuildingExtraCostTooltip(row.Hash);
      -- if extraCostText ~= "" then
      --   sToolTip = sToolTip .. "[NEWLINE]" .. AddBuildingExtraCostTooltip(row.Hash);
      -- end

      table.insert( new_data.BuildingItems, {
        Index           = row.Index,
        Type            = row.BuildingType,
        Name            = row.Name,
        ToolTip         = sToolTip,
        Hash            = row.Hash,
        Kind            = row.Kind,
        TurnsLeft       = buildQueue:GetTurnsLeft( row.Hash ),
        Disabled        = isDisabled,
        Repair          = cityBuildings:IsPillaged( row.Hash ),
        Cost            = iProductionCost,
        Progress        = iProductionProgress,
        IsWonder        = row.IsWonder,
        PrereqDistrict  = iPrereqDistrict,
        PrereqBuildings = row.PrereqBuildingCollection,
        Tier            = tier,
        SortIndex       = sortIndex
      });
    end

    -- Can it be purchased with gold?
    if row.PurchaseYield == "YIELD_GOLD" then
      local isAllowed, kBldg = ComposeBldgForPurchase( row, pSelectedCity, "YIELD_GOLD", playerTreasury, "LOC_BUILDING_INSUFFICIENT_FUNDS" );
      if isAllowed then
        kBldg.Index = row.Index;
        kBldg.Tier = tier;
        kBldg.SortIndex = sortIndex;
        table.insert( new_data.BuildingPurchases, kBldg );
      end
    end
    -- Can it be purchased with faith?
    if row.PurchaseYield == "YIELD_FAITH" or cityGold:IsBuildingFaithPurchaseEnabled( row.Hash ) then
      local isAllowed, kBldg = ComposeBldgForPurchase( row, pSelectedCity, "YIELD_FAITH", playerReligion, "LOC_BUILDING_INSUFFICIENT_FAITH" );
      if isAllowed then
        kBldg.Index = row.Index;
        kBldg.Tier = tier;
        kBldg.SortIndex = sortIndex;
        table.insert( new_data.BuildingPurchases, kBldg );
      end
    end
  end

  -- 按所属区域、建筑等级、造价升序排序
  table.sort(new_data.BuildingItems, function(a, b)
    if a.SortIndex ~= b.SortIndex then 
      return a.SortIndex < b.SortIndex;
    elseif a.Cost ~= b.Cost then
      return a.Cost < b.Cost;
    else
      return a.Index < b.Index;
    end

    return false;
  end);

  table.sort(new_data.BuildingPurchases, function(a, b)
    if a.SortIndex ~= b.SortIndex then 
      return a.SortIndex < b.SortIndex;
    elseif a.Cost ~= b.Cost then
      return a.Cost < b.Cost;
    else
      return a.Index < b.Index;
    end

    return false;
  end);

  for row in GameInfo.Units() do
    if row.Hash == m_CurrentProductionHash then
      new_data.CurrentProduction = row.Name;
      new_data.CurrentProductionType= row.UnitType;
    end

    local kBuildParameters = {};
    kBuildParameters.UnitType = row.Hash;
    kBuildParameters.MilitaryFormationType = MilitaryFormationTypes.STANDARD_MILITARY_FORMATION;

    local sortIndex = 100000;
    if row.UnitType == 'UNIT_SETTLER' then
      sortIndex = 0;
    elseif row.UnitType == 'UNIT_BUILDER' then
      sortIndex = 1;
    elseif row.UnitType == 'UNIT_TRADER' then
      sortIndex = 2;
    else
      if row.FormationClass == 'FORMATION_CLASS_CIVILIAN' then
        if not row.TrackReligion then
          sortIndex = 100;
        else
          sortIndex = 200;
        end
      elseif row.FormationClass == 'FORMATION_CLASS_LAND_COMBAT' then
        sortIndex = 300;
      elseif row.FormationClass == 'FORMATION_CLASS_NAVAL' then
        sortIndex = 400;
      elseif row.FormationClass == 'FORMATION_CLASS_AIR' then
        sortIndex = 500;
      elseif row.FormationClass == 'FORMATION_CLASS_SUPPORT' then
        sortIndex = 600;
      end

      local promotionClassInfo = GameInfo.UnitPromotionClasses[row.PromotionClass];
      if promotionClassInfo then
        sortIndex = sortIndex + promotionClassInfo.Index;
      end
    end

    -- Can it be built normally?
    if not row.MustPurchase and buildQueue:CanProduce( kBuildParameters, true ) then
      local isCanProduceExclusion, results = buildQueue:CanProduce( kBuildParameters, false, true );
      local nProductionCost :number = buildQueue:GetUnitCost( row.Index );
      local nProductionProgress :number = buildQueue:GetUnitProgress( row.Index );
      local isDisabled :boolean = not isCanProduceExclusion;
      local sAllReasons :string = ComposeFailureReasonStrings( isDisabled, results );
      local sToolTip :string = ToolTipHelper.GetUnitToolTip( row.Hash, MilitaryFormationTypes.STANDARD_MILITARY_FORMATION, buildQueue ) .. sAllReasons;

      local kUnit :table = {
        Index               = row.Index,
        Type                = row.UnitType,
        Name                = row.Name,
        ToolTip             = sToolTip,
        Hash                = row.Hash,
        Kind                = row.Kind,
        TurnsLeft           = buildQueue:GetTurnsLeft( row.Hash ),
        Disabled            = isDisabled,
        Civilian            = row.FormationClass == "FORMATION_CLASS_CIVILIAN",
        Cost                = nProductionCost,
        Progress            = nProductionProgress,
        Corps               = false,
        CorpsCost           = 0,
        CorpsTurnsLeft      = 1,
        CorpsTooltip        = "",
        CorpsName           = "",
        Army                = false,
        ArmyCost            = 0,
        ArmyTurnsLeft       = 1,
        ArmyTooltip         = "",
        ArmyName            = "",
        ReligiousStrength   = row.ReligiousStrength,
        IsCurrentProduction = row.Hash == m_CurrentProductionHash,
        SortIndex           = sortIndex
      };

      -- Should we present options for building Corps or Army versions?
      if results ~= nil then
        if results[CityOperationResults.CAN_TRAIN_CORPS] then
          kBuildParameters.MilitaryFormationType = MilitaryFormationTypes.CORPS_MILITARY_FORMATION;
          local bCanProduceCorps, kResults = buildQueue:CanProduce( kBuildParameters, false, true);
          kUnit.Corps = true;
          kUnit.CorpsDisabled = not bCanProduceCorps;
          kUnit.CorpsCost = buildQueue:GetUnitCorpsCost( row.Index );
          kUnit.CorpsTurnsLeft = buildQueue:GetTurnsLeft( row.Hash, MilitaryFormationTypes.CORPS_MILITARY_FORMATION );
          kUnit.CorpsTooltip, kUnit.CorpsName = ComposeUnitCorpsStrings( row, nProductionProgress, buildQueue );
          local sFailureReasons:string = ComposeFailureReasonStrings( kUnit.CorpsDisabled, kResults );
          kUnit.CorpsTooltip = kUnit.CorpsTooltip .. sFailureReasons;
          kUnit.Cost= kUnit.CorpsCost;
        end
        if results[CityOperationResults.CAN_TRAIN_ARMY] then
          kBuildParameters.MilitaryFormationType = MilitaryFormationTypes.ARMY_MILITARY_FORMATION;
          local bCanProduceArmy, kResults = buildQueue:CanProduce( kBuildParameters, false, true );
          kUnit.Army = true;
          kUnit.ArmyDisabled = not bCanProduceArmy;
          kUnit.ArmyCost = buildQueue:GetUnitArmyCost( row.Index );
          kUnit.ArmyTurnsLeft = buildQueue:GetTurnsLeft( row.Hash, MilitaryFormationTypes.ARMY_MILITARY_FORMATION );
          kUnit.ArmyTooltip, kUnit.ArmyName = ComposeUnitArmyStrings( row, nProductionProgress, buildQueue );
          local sFailureReasons:string = ComposeFailureReasonStrings( kUnit.ArmyDisabled, kResults );
          kUnit.ArmyTooltip = kUnit.ArmyTooltip .. sFailureReasons;
          kUnit.Cost = kUnit.CorpsCost;
        end
      end

      table.insert(new_data.UnitItems, kUnit );
    end

    -- Can it be purchased with gold?
    if row.PurchaseYield == "YIELD_GOLD" then
      local isAllowed, kUnit = ComposeUnitForPurchase( row, pSelectedCity, "YIELD_GOLD", playerTreasury, "LOC_BUILDING_INSUFFICIENT_FUNDS" );
      if isAllowed then
        kUnit.Index = row.Index;
        kUnit.SortIndex = sortIndex;
        table.insert( new_data.UnitPurchases, kUnit );
      end
    end
    -- Can it be purchased with faith?
    if row.PurchaseYield == "YIELD_FAITH" or cityGold:IsUnitFaithPurchaseEnabled( row.Hash ) then
      local isAllowed, kUnit = ComposeUnitForPurchase( row, pSelectedCity, "YIELD_FAITH", playerReligion, "LOC_BUILDING_INSUFFICIENT_FAITH" );
      if isAllowed then
        kUnit.Index = row.Index;
        kUnit.SortIndex = sortIndex;
        table.insert( new_data.UnitPurchases, kUnit );
      end
    end
  end

  table.sort(new_data.UnitItems, function(a, b)
    if a.SortIndex ~= b.SortIndex then
      return a.SortIndex < b.SortIndex;
    elseif a.Cost ~= b.Cost then
      return a.Cost < b.Cost;
    else
      return a.Index < b.Index;
    end

    return false;
  end)

  table.sort(new_data.UnitPurchases, function(a, b)
    if a.SortIndex ~= b.SortIndex then
      return a.SortIndex < b.SortIndex;
    elseif a.Cost ~= b.Cost then
      return a.Cost < b.Cost;
    else
      return a.Index < b.Index;
    end

    return false;
  end)

  if (pBuildQueue == nil) then
    pBuildQueue = pSelectedCity:GetBuildQueue();
  end

  for row in GameInfo.Projects() do
    if row.Hash == m_CurrentProductionHash then
      new_data.CurrentProduction = row.Name;
      new_data.CurrentProductionType= row.ProjectType;
    end

    if buildQueue:CanProduce( row.Hash, true ) then
      local isCanProduceExclusion, results = buildQueue:CanProduce( row.Hash, false, true );
      local isDisabled :boolean = not isCanProduceExclusion;

      local allReasons :string = ComposeFailureReasonStrings( isDisabled, results );
      local sToolTip :string = ToolTipHelper.GetProjectToolTip( row.Hash) .. allReasons;

      local iProductionCost :number = buildQueue:GetProjectCost( row.Index );
      local iProductionProgress :number = buildQueue:GetProjectProgress( row.Index );
      sToolTip = sToolTip .. "[NEWLINE]" .. ComposeProductionCostString( iProductionProgress, iProductionCost );

      table.insert(new_data.ProjectItems, {
        Index               = row.Index,
        Type                = row.ProjectType,
        Name                = row.Name,
        ToolTip             = sToolTip,
        Hash                = row.Hash,
        Kind                = row.Kind,
        TurnsLeft           = buildQueue:GetTurnsLeft( row.ProjectType ),
        Disabled            = isDisabled,
        Cost                = iProductionCost,
        Progress            = iProductionProgress,
        IsCurrentProduction = row.Hash == m_CurrentProductionHash,
        IsRepeatable        = row.MaxPlayerInstances ~= 1 and true or false,
      });
    end
  end

  table.sort(new_data.ProjectItems, function(a, b)
    if a.Cost ~= b.Cost then
      return a.Cost < b.Cost;
    else
      return a.Index < b.Index;
    end

    return false;
  end)

  return new_data;
end

function OnShowEnemyCityOverview( ownerID:number, cityID:number)
  -- Hide the production panel if it was open when entering EspionageView.
  if not ContextPtr:IsHidden() then
    Close();
  end
  m_kEspionageViewManager:SetEspionageViewCity( ownerID, cityID );
end

function Open()
  if m_kEspionageViewManager:IsEspionageView() then
    if ContextPtr:IsHidden() then
      UI.PlaySound("Production_Panel_Open");
      LuaEvents.ProductionPanel_Open();
      UI.SetInterfaceMode(InterfaceModeTypes.SELECTION);
      Refresh();
      ContextPtr:SetHide(false);

      -- Size the panel to the maximum Y value of the expanded content
      Controls.AlphaIn:SetToBeginning();
      Controls.SlideIn:SetToBeginning();
      Controls.AlphaIn:Play();
      Controls.SlideIn:Play();
    end
  else
    BASE_Open();
  end
end

-- Taken from original PopulateGenericItemData().
-- Have to do this in order to use m_kRecommendedItems declared by us,
-- since original m_kRecommendedItems is not initialized and won't be able to execute.
function PopulateGenericItemData( kInstance:table, kItem:table )
  ResetInstanceVisibility(kInstance);

  -- Recommended check
  -- if m_kRecommendedItems[kItem.Hash] ~= nil then
  --   kInstance.RecommendedIcon:SetHide(false);
  -- end

  -- Item Name
  local sName:string = Locale.Lookup(kItem.Name);
  if (kItem.Repair) then
    sName = sName .. "[NEWLINE]" .. TXT_PRODUCTION_ITEM_REPAIR;
  end

  kInstance.LabelText:SetText(sName);

  -- Tooltips
  kInstance.Button:SetToolTipString(kItem.ToolTip);
  kInstance.Disabled:SetToolTipString(kItem.ToolTip);

  -- Icon
  kInstance.Icon:SetIcon(ICON_PREFIX..kItem.Type);

  -- Is item disabled?
  if (kItem.Disabled) then
    if(m_showDisabled) then
      kInstance.Disabled:SetHide(false);
      kInstance.Button:SetColor(COLOR_LOW_OPACITY);
    else
      kInstance.Button:SetHide(true);
    end
  else
    kInstance.Button:SetHide(false);
    kInstance.Disabled:SetHide(true);
    kInstance.Button:SetColor(UI.GetColorValue("COLOR_WHITE"));
  end
  kInstance.Button:SetDisabled(kItem.Disabled);
end

function ShowHideDisabled()
  m_showDisabled = not m_showDisabled;
  BASE_ShowHideDisabled();
end

function Refresh()
  local pSelectedCity:table = UI.GetHeadSelectedCity();

  if pSelectedCity == nil then
    -- EspionageView handling.
    pSelectedCity = m_kEspionageViewManager:GetEspionageViewCity();
    if pSelectedCity ~= nil then
      local data = GetDataHelper(pSelectedCity:GetOwner(), pSelectedCity);
      if data ~= nil then
        ViewHelper(pSelectedCity, data);
      else
        Close();
      end
    end
  else
    if m_kEspionageViewManager:IsEspionageView() then
      m_kEspionageViewManager:ClearEspionageViewCity();

      m_listIM:ResetInstances();
      m_purchaseListIM:ResetInstances();
      m_purchaseFaithListIM:ResetInstances();
      m_queueListIM:ResetInstances();
    end

    BASE_Refresh();
  end
end

function View(data)
  local pSelectedCity:table = UI.GetHeadSelectedCity();
  return ViewHelper(pSelectedCity, data);
end

-- Taken from original View(). Refactor first few lines to be more generic that can be used by EspionageView.
function ViewHelper(pSelectedCity:table, data)
  -- Get the hashes for the top three recommended items
  -- Convert to a BuildItemHash indexed table for easier look up
  -- m_kRecommendedItems = {};
  -- for _,kItem in ipairs(pSelectedCity:GetCityAI():GetBuildRecommendations()) do
  --     m_kRecommendedItems[kItem.BuildItemHash] = kItem.BuildItemScore;
  -- end

  PopulateList(data, LISTMODE.PRODUCTION, m_listIM);
  Controls.ProductionListScroll:SetScrollValue(GetScrollPosition(LISTMODE.PRODUCTION));
  PopulateList(data, LISTMODE.PURCHASE_GOLD, m_purchaseListIM);
  Controls.PurchaseListScroll:SetScrollValue(GetScrollPosition(LISTMODE.PURCHASE_GOLD));
  PopulateList(data, LISTMODE.PURCHASE_FAITH, m_purchaseFaithListIM);
  Controls.PurchaseFaithListScroll:SetScrollValue(GetScrollPosition(LISTMODE.PURCHASE_FAITH));
  PopulateList(data, LISTMODE.PROD_QUEUE, m_queueListIM);
  Controls.QueueListScroll:SetScrollValue(GetScrollPosition(LISTMODE.PROD_QUEUE));

  RefreshQueue(data.Owner, data.City:GetID())

  Controls.PurchaseList:CalculateSize();
  if( Controls.PurchaseList:GetSizeY() == 0 ) then
    Controls.NoGoldContent:SetHide(false);
  else
    Controls.NoGoldContent:SetHide(true);
  end

  Controls.PurchaseFaithList:CalculateSize();
  if( Controls.PurchaseFaithList:GetSizeY() == 0 ) then
    Controls.NoFaithContent:SetHide(false);
  else
    Controls.NoFaithContent:SetHide(true);
  end
end

function ComposeProductionCostString( iProductionProgress:number, iProductionCost:number)
	-- Show production progress only if there is progress present
	if iProductionCost ~= 0 then
		local costString		:string = tostring(iProductionCost);
		
		if iProductionProgress > 0 then -- Only show fraction if build progress has been made.
			costString = tostring(iProductionProgress) .. "/" .. costString;
		end
		return Locale.Lookup('LOC_TOOLTIP_ACTUAL_COST_TEXT', costString, "[ICON_Production]", 'LOC_HUD_PRODUCTION');
	end
	return "";
end

function ResetInstanceVisibility(productionItem: table)
	if (productionItem.ArmyCorpsDrawer ~= nil) then
		productionItem.ArmyCorpsDrawer:SetHide(true);
		productionItem.CorpsArmyArrow:SetSelected(true);
		-- productionItem.CorpsRecommendedIcon:SetHide(true);
		productionItem.CorpsButtonContainer:SetHide(true);
		productionItem.CorpsDisabled:SetHide(true);
		-- productionItem.ArmyRecommendedIcon:SetHide(true);
		productionItem.ArmyButtonContainer:SetHide(true);
		productionItem.ArmyDisabled:SetHide(true);
		productionItem.CorpsArmyDropdownArea:SetHide(true);
	end
	if (productionItem.BuildingDrawer ~= nil) then
		productionItem.BuildingDrawer:SetHide(true);
		productionItem.CompletedArea:SetHide(true);
	end
	-- productionItem.RecommendedIcon:SetHide(true);
	productionItem.Disabled:SetHide(true);
end

function OnInit()
  BASE_OnInit();

  LuaEvents.CityBannerManager_ShowEnemyCityOverview.Add(OnShowEnemyCityOverview);
end

function DL_Initialize()
  -- Override ContextPtr's init handler since it didn't provide a LateInitialize method.
  ContextPtr:SetInitHandler(OnInit);
end

DL_Initialize();