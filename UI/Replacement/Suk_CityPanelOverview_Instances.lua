-- Suk_CityPanelOverview_Instances
-- Author: Sukritact
-- DateCreated: 12/1/2020 2:56:45 AM

include( "Civ6Common" );
include( "InstanceManager" );
include( "ToolTipHelper" );

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local YIELDS_TABLE = {
	{"Food",		"YIELD_FOOD",		GameInfo.Yields["YIELD_FOOD"].Index},
	{"Production",	"YIELD_PRODUCTION",	GameInfo.Yields["YIELD_PRODUCTION"].Index},
	{"Gold",		"YIELD_GOLD",		GameInfo.Yields["YIELD_GOLD"].Index},
	{"Science",		"YIELD_SCIENCE",	GameInfo.Yields["YIELD_SCIENCE"].Index},
	{"Culture",		"YIELD_CULTURE",	GameInfo.Yields["YIELD_CULTURE"].Index},
	{"Faith",		"YIELD_FAITH",		GameInfo.Yields["YIELD_FAITH"].Index},
}

local PILLAGED_ICON		= "[ICON_Pillaged]"
local NEWLINE			= "[NEWLINE]"
local MAX_YIELD_LENGTH	= 3
-- ===========================================================================
--	MEMBERS
-- ===========================================================================
pDistrictsStack	= nil
pWondersStack	= nil

m_kBuildingsIM	= InstanceManager:new("Suk_BuildingInstance",	"Top");
m_kDistrictsIM	= InstanceManager:new("Suk_DistrictInstance",	"Top");
m_kWondersIM	= InstanceManager:new("Suk_WonderInstance",		"Top");
-- ===========================================================================
--	Suk_CityPanelOverview_Districts
-- ===========================================================================
function GenerateYieldString(tYields, iMaxLength)
	local sYieldString = ""
	local iYieldCount = 0

	for _,tYield in ipairs(YIELDS_TABLE) do

		local sYieldShort	= tYield[1]
		local sYield		= tYield[2]
		local iYieldChange	= tYields[sYieldShort] or 0;

		if iYieldChange ~= 0 then
			if iYieldCount == iMaxLength then
				sYieldString = sYieldString .. NEWLINE
				iYieldCount = 0
			elseif iYieldCount > 0 then
				sYieldString = sYieldString .. " "
			end
			sYieldString = sYieldString .. GetYieldString(sYield, iYieldChange)
			iYieldCount = iYieldCount + 1
		end
	end
	if sYieldString == "" then sYieldString = "-" end

	return sYieldString
end
-- ===========================================================================
--	Suk_CityPanelOverview_Districts
-- ===========================================================================
function OnSuk_CityPanelOverview_Districts(iPlayer, tData)

	m_kBuildingsIM:ResetInstances()
	m_kDistrictsIM:ResetInstances()

	for _, tDistrict in ipairs(tData.BuildingsAndDistricts) do
		if tDistrict.isBuilt then
			local tDistrictInstance = m_kDistrictsIM:GetInstance()
			----------------------------------
			-- District Name and Icon
			----------------------------------
			local sDistrictName = (tDistrict.isPillaged) and (tDistrict.Name .. PILLAGED_ICON) or (tDistrict.Name)
			tDistrictInstance.DistrictName:SetText(sDistrictName)
			tDistrictInstance.Icon:SetIcon(tDistrict.Icon)
			----------------------------------
			-- Callback
			----------------------------------
			tDistrictInstance.Top:RegisterCallback(Mouse.eRClick, function() LuaEvents.OpenCivilopedia(tDistrict.Type); end);
			----------------------------------
			-- Adjacencies
			----------------------------------
			local tOtherBonuses = {}
			for _,tYield in ipairs(YIELDS_TABLE) do
				local sYieldShort = tYield[1]
				tOtherBonuses[sYieldShort] = tDistrict[sYieldShort] - tDistrict.AdjacencyBonus[sYieldShort]
			end
			local sAdjacency		= GenerateYieldString(tDistrict.AdjacencyBonus, MAX_YIELD_LENGTH)
			local sOtherBonuses		= GenerateYieldString(tOtherBonuses, MAX_YIELD_LENGTH)
			tDistrictInstance.DistrictAdjacencyBonuses:SetText(sAdjacency)
			tDistrictInstance.DistrictOtherBonuses:SetText(sOtherBonuses)
			----------------------------------
			-- Show/Hide Elements
			----------------------------------
			-- local bAdjacencyBonuses	= (sAdjacency ~= "-")
			local bOtherBonuses		= (sOtherBonuses ~= "-")
			-- local bNoBonuses		= not (bAdjacencyBonuses or bOtherBonuses)

			-- tDistrictInstance.DistrictYields:SetHide(bNoBonuses)
			-- tDistrictInstance.DistrictName:SetHide(bNoBonuses)
			-- tDistrictInstance.DistrictName2:SetHide(not bNoBonuses)
			tDistrictInstance.DistrictOtherBonuses:SetHide(not bOtherBonuses)
			tDistrictInstance.DistrictOtherBonusesLabel:SetHide(not bOtherBonuses)
			----------------------------------
			-- Tooltip
			----------------------------------
			local sToolTip = ToolTipHelper.GetToolTip(tDistrict.Type, iPlayer)
			tDistrictInstance.Top:SetToolTipString(sToolTip)
			----------------------------------
			-- Buildings
			----------------------------------
			for _,building in ipairs(tDistrict.Buildings) do
				if building.isBuilt then
					local kInstanceBuild:table = m_kBuildingsIM:GetInstance(tDistrictInstance.BuildingStack);
					local buildingName = building.Name;
					if building.isPillaged then
						buildingName = buildingName .. PILLAGED_ICON;
					end
					kInstanceBuild.BuildingName:SetText( buildingName );
					kInstanceBuild.Icon:SetIcon( building.Icon );

					local pRow = GameInfo.Buildings[building.Type];
					local sToolTip = ToolTipHelper.GetBuildingToolTip( pRow.Hash, playerID, m_pCity );
					local yieldString:string = "";

					for index, kYield in ipairs(building.Yields) do
						yieldString = yieldString .. GetYieldString(kYield.YieldType,kYield.YieldChange);
						if index == 3 then yieldString = yieldString .. '[NEWLINE]'; end
					end

					kInstanceBuild.Top:SetToolTipString( sToolTip );
					kInstanceBuild.Top:RegisterCallback(Mouse.eRClick, function() LuaEvents.OpenCivilopedia(building.Type); end);
					kInstanceBuild.BuildingYield:SetText( yieldString );
				end
			end
			----------------------------------
		end
	end
end
-- ===========================================================================
--	Suk_CityPanelOverview_Wonders
-- ===========================================================================
function OnSuk_CityPanelOverview_Wonders(iPlayer, tData, bShowWonders)

	m_kWondersIM:ResetInstances()
	if not bShowWonders then return end

	for _, tWonder in ipairs(tData.Wonders) do
		local tWonderInstance = m_kWondersIM:GetInstance();
		tWonderInstance.WonderName:SetText( tWonder.Name );
		local pRow = GameInfo.Buildings[tWonder.Type];
		local sToolTip = ToolTipHelper.GetBuildingToolTip( pRow.Hash, playerID, m_pCity );
		local yieldString:string = "";
		for index, kYield in ipairs(tWonder.Yields) do
			yieldString = yieldString .. GetYieldString(kYield.YieldType,kYield.YieldChange);
			if index == 3 then yieldString = yieldString .. '[NEWLINE]'; end
		end

		tWonderInstance.Top:SetToolTipString( sToolTip );
		tWonderInstance.Top:RegisterCallback(Mouse.eRClick, function() LuaEvents.OpenCivilopedia(tWonder.Type); end);
		tWonderInstance.WonderYield:SetText( yieldString );
		tWonderInstance.Icon:SetIcon( tWonder.Icon );
	end
end
-- ===========================================================================
--	Init and Shutdown
-- ===========================================================================
local bLoadScreenHookup = false

function OnInit(isReload)
	if not ContextPtr:LookUpControl("/InGame/CityPanelOverview/BuildingAndDistrictsStack") then
		Events.LoadScreenClose.Add(OnInit)
		bLoadScreenHookup = true
		return
	end

	pDistrictsStack	= ContextPtr:LookUpControl("/InGame/CityPanelOverview/BuildingAndDistrictsStack")
	pWondersStack	= ContextPtr:LookUpControl("/InGame/CityPanelOverview/WondersStack")

	m_kDistrictsIM.m_ParentControl	= pDistrictsStack
	m_kWondersIM.m_ParentControl	= pWondersStack

	LuaEvents.Suk_CityPanelOverview_Districts.Add(OnSuk_CityPanelOverview_Districts)
	LuaEvents.Suk_CityPanelOverview_Wonders.Add(OnSuk_CityPanelOverview_Wonders)
end

function OnShutdown()
	if bLoadScreenHookup then Events.LoadScreenClose.Remove(OnInit) end
	LuaEvents.Suk_CityPanelOverview_Districts.Remove(OnSuk_CityPanelOverview_Districts)
	LuaEvents.Suk_CityPanelOverview_Wonders.Remove(OnSuk_CityPanelOverview_Wonders)

	m_kBuildingsIM:DestroyInstances()
	m_kDistrictsIM:DestroyInstances()
	m_kWondersIM:DestroyInstances()
end
-- ===========================================================================
function Initialize()
	ContextPtr:SetInitHandler(OnInit)
	ContextPtr:SetHide(false)
	ContextPtr:SetShutdown(OnShutdown)
end
Initialize()