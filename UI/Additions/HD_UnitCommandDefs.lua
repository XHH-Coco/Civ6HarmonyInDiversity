
--[[ =======================================================================

	HD Custom Unit Commands - Definitions

		Data and callbacks for enabling custom unit commands to appear and 
		work in the Unit Panel UI. These definitions mimic what appears in 
		data for common unit commands, and are used in the replacement 
		UnitPanel script.

-- =========================================================================]]
if ExposedMembers.DLHD == nil then
    ExposedMembers.DLHD = {};
end

Utils = ExposedMembers.DLHD.Utils;

m_HDUnitCommands = {};

local CITY_HAS_JNR_RECYCLING_PLANT_TAG = 'HD_CITY_HAS_JNR_RECYCLING_PLANT';
local RECYCLING_PLANT_PRODUCTION_PERCENT = GlobalParameters.RECYCLING_PLANT_PRODUCTION_PERCENT or 0;

local SPAIN_NATURAL_WONDER_REVEALED_TAG = 'HD_SpainNaturalWonderRevealed_';
local SPAIN_NATURAL_WONDER_REVEALED_LIST_TAG = 'HD_SpainNaturalWonderRevealedList';

local PLAYER_HAS_INDUSTRY_TAG = 'HD_PLAYER_HAS_INDUSTRY_';
local PLAYER_HAS_CORPORATION_TAG = 'HD_PLAYER_HAS_CORPORATION_';
local GAME_HAS_CORPORATION_TAG = 'HD_GAME_HAS_CORPORATION_';
local CITY_IMPROVEMENT_NUM_TAG = 'HD_CITY_IMPROVEMENT_NUM_';
local CITY_ALLOW_EXTRA_TAG = 'HD_CITY_ALLOW_EXTRA_';

local COAST_INDEX = GameInfo.Terrains['TERRAIN_COAST'].Index;
local OCEAN_INDEX = GameInfo.Terrains['TERRAIN_OCEAN'].Index;

local JUNGLE_INDEX = GameInfo.Features['FEATURE_JUNGLE'].Index;

local ANTIQUITY_SITE_INDEX = GameInfo.Resources['RESOURCE_ANTIQUITY_SITE'].Index;
-- ======================================================================================================================================================
-- 砍二献祭
-- ======================================================================================================================================================
m_HDUnitCommands.SACRIFICE = {};
m_HDUnitCommands.SACRIFICE.Properties = {};

-- UI Data
m_HDUnitCommands.SACRIFICE.EventName		= "HD_Aztec_Sacrifice";
m_HDUnitCommands.SACRIFICE.CategoryInUI		= "SPECIFIC";
m_HDUnitCommands.SACRIFICE.Icon				= "ICON_UNITCOMMAND_AZTEC_SACRIFICE";
m_HDUnitCommands.SACRIFICE.ToolTipString	= Locale.Lookup("LOC_UNITCOMMAND_SACRIFICE_NAME") .. "[NEWLINE][NEWLINE]" .. 
												Locale.Lookup("LOC_UNITCOMMAND_SACRIFICE_DESCRIPTION");
m_HDUnitCommands.SACRIFICE.DisabledToolTipString = Locale.Lookup("LOC_UNITCOMMAND_SACRIFICE_DISABLED_TT");
m_HDUnitCommands.SACRIFICE.VisibleInUI	= true;

-- ===========================================================================
function m_HDUnitCommands.SACRIFICE.CanUse(pUnit : object)
	if pUnit == nil then
		return false;
	end

	return GameInfo.Units[pUnit:GetType()].UnitType == "UNIT_BUILDER";
	-- or GameInfo.Units[pUnit:GetType()].UnitType == "UNIT_MILITARY_ENGINEER";
end

-- ===========================================================================
function m_HDUnitCommands.SACRIFICE.IsVisible(pUnit : object)
	local playerID = pUnit:GetOwner();
	local player = Players[playerID];
	local sMontezumaTrair = 'TRAIT_LEADER_GIFTS_FOR_TLATOANI'
	if Utils.LeaderHasTrait(playerID, sMontezumaTrair) then
		return pUnit ~= nil and pUnit:GetMovesRemaining() > 0;
	end
	return false;
end

-- ===========================================================================
function m_HDUnitCommands.SACRIFICE.IsDisabled(pUnit : object)
	if pUnit == nil or pUnit:GetMovesRemaining() == 0 then
		return true;
	end

	local iPlotId : number = pUnit:GetPlotId();
	local pPlot : object = Map.GetPlotByIndex(iPlotId);
	
	if pPlot == nil then
		return true;
	end
	
	if not pPlot:GetOwner() == pUnit:GetOwner() then
		return true;
	end
	local city = CityManager.GetCityAt(pUnit:GetX(), pUnit:GetY());
	
	return city == nil;
end

-- ======================================================================================================================================================
-- 垃圾回收中心
-- ======================================================================================================================================================
m_HDUnitCommands.RECYCLE = {};
m_HDUnitCommands.RECYCLE.Properties = {};

-- UI Data
m_HDUnitCommands.RECYCLE.EventName = "HDRecyclingPlantRecycle";
m_HDUnitCommands.RECYCLE.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.RECYCLE.Icon = "ICON_UNITCOMMAND_RECYCLE";
m_HDUnitCommands.RECYCLE.GetToolTipString = function (unit)
	local unitInfo = GameInfo.Units[unit:GetType()];
	local cost = unitInfo.Cost;
	local resourceType = unitInfo.StrategicResource;
	local resourceCost = 0;
	local unitXP2Info = GameInfo.Units_XP2[unitInfo.UnitType];
	if unitXP2Info ~= nil then
			resourceCost = unitXP2Info.ResourceCost;
	end
	local resourceCostMultiplier = 0;
	if resourceType ~= nil then
			resourceCostMultiplier = GlobalParameters['RECYCLING_PLANT_' .. resourceType .. '_MULTIPLIER'] or 0;
	end
	local gold = RECYCLING_PLANT_PRODUCTION_PERCENT * cost / 100 + resourceCostMultiplier * resourceCost;

	return Locale.Lookup("LOC_UNITCOMMAND_RECYCLE_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_UNITCOMMAND_RECYCLE_DESCRIPTION", gold);
end
m_HDUnitCommands.RECYCLE.DisabledToolTipString = Locale.Lookup("LOC_UNITCOMMAND_RECYCLE_DISABLED_TT");
m_HDUnitCommands.RECYCLE.VisibleInUI = true;
function m_HDUnitCommands.RECYCLE.CanUse(pUnit : object)
	if pUnit == nil then
		return false;
	end
	local formationClass = GameInfo.Units[pUnit:GetType()].FormationClass;
	return formationClass == 'FORMATION_CLASS_LAND_COMBAT' or formationClass == 'FORMATION_CLASS_AIR' or formationClass == 'FORMATION_CLASS_NAVAL';
end

function m_HDUnitCommands.RECYCLE.IsVisible(pUnit : object)
	if pUnit == nil then
		return;
	end
	if RECYCLING_PLANT_PRODUCTION_PERCENT == 0 then
		return false;
	end
	local formationClass = GameInfo.Units[pUnit:GetType()].FormationClass;
	local playerID = pUnit:GetOwner();
	local player = Players[playerID];
	local location = pUnit:GetLocation();
	local x = location.x;
	local y = location.y;
	local plot = Map.GetPlot(x, y);
	if plot:GetOwner() ~= playerID then
		return false;
	end
	local districtType = plot:GetDistrictType();

	if (formationClass == 'FORMATION_CLASS_LAND_COMBAT' and Utils.IsDistrictType(districtType, 'DISTRICT_NEIGHBORHOOD'))
	or (formationClass == 'FORMATION_CLASS_NAVAL' and Utils.IsDistrictType(districtType, 'DISTRICT_HARBOR'))
	or (formationClass == 'FORMATION_CLASS_AIR' and Utils.IsDistrictType(districtType, 'DISTRICT_AERODROME')) then
		local city = Cities.GetPlotPurchaseCity(plot);
		local hasRecyclingPlant = city:GetProperty(CITY_HAS_JNR_RECYCLING_PLANT_TAG) or 0;
		return hasRecyclingPlant > 0;
	else
		return false;
	end

	return false;
end

-- ===========================================================================
function m_HDUnitCommands.RECYCLE.IsDisabled(pUnit : object)
	if pUnit == nil then
		return true;
	end
	if pUnit:GetMovesRemaining() == 0 then
		return true;
	end
	return pUnit:GetDamage() ~= 0;
end

-- ======================================================================================================================================================
-- 奇琴伊察献祭
-- ======================================================================================================================================================
m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA = {};
m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.Properties = {};

-- UI Data
m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.EventName = "HDChiChenItzaSacrifice";
m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.Icon = "ICON_UNITCOMMAND_SACRIFICE_CHICHEN_ITZA";
m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.ToolTipString = Locale.Lookup("LOC_UNITCOMMAND_SACRIFICE_CHICHEN_ITZA_NAME") .. "[NEWLINE][NEWLINE]" .. 
										Locale.Lookup("LOC_UNITCOMMAND_SACRIFICE_CHICHEN_ITZA_DESCRIPTION");
m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.DisabledToolTipString = Locale.Lookup("LOC_UNITCOMMAND_SACRIFICE_CHICHEN_ITZA_DISABLED_TT");
m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.VisibleInUI = true;
function m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.CanUse(pUnit : object)
	if pUnit == nil then
		return false;
	end
	return GameInfo.Units[pUnit:GetType()].FormationClass == "FORMATION_CLASS_LAND_COMBAT";
end

local SACRIFICED_CHICHEN_ITZA_KEY = 'SACRIFICED_CHICHEN_ITZA';
local CHICHEN_ITZA_INDEX = GameInfo.Buildings['BUILDING_CHICHEN_ITZA'].Index;
function m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.IsVisible(pUnit : object)
	local ownerId = pUnit:GetOwner();
	local owner = Players[ownerId];
	if not Utils.PlayerHasWonder(owner, CHICHEN_ITZA_INDEX) then
		return false;
	end
	local unitType = GameInfo.Units[pUnit:GetType()].UnitType;
	local sacrificed = owner:GetProperty(SACRIFICED_CHICHEN_ITZA_KEY) or {};
	if sacrificed[unitType] then
		return false;
	end
	return true;
end

-- ===========================================================================
function m_HDUnitCommands.SACRIFICE_CHICHEN_ITZA.IsDisabled(pUnit : object)
	if pUnit == nil then
		return true;
	end
	if pUnit:GetMovesRemaining() == 0 then
		return true;
	end
	local location = pUnit:GetLocation();
	local x = location.x;
	local y = location.y;
	local plot = Map.GetPlot(x, y);
	return (plot:GetWonderType() ~= CHICHEN_ITZA_INDEX) or (pUnit:GetDamage() ~= 0);
end

-- ======================================================================================================================================================
-- 高德院出家
-- ======================================================================================================================================================
-- m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN = {};
-- m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.Properties = {};

-- -- UI Data
-- m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.EventName = "HDKotokuInPravrajya";
-- m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.CategoryInUI = "SPECIFIC";
-- m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.Icon = "ICON_UNITCOMMAND_PRAVRAJYA_KOTOKU_IN";
-- m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.ToolTipString = Locale.Lookup("LOC_UNITCOMMAND_PRAVRAJYA_KOTOKU_IN_NAME") .. "[NEWLINE][NEWLINE]" .. 
-- 										Locale.Lookup("LOC_UNITCOMMAND_PRAVRAJYA_KOTOKU_IN_DESCRIPTION");
-- m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.DisabledToolTipString = Locale.Lookup("LOC_UNITCOMMAND_PRAVRAJYA_KOTOKU_IN_DISABLED_TT");
-- m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.VisibleInUI = true;
-- function m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.CanUse(pUnit : object)
-- 	if pUnit == nil then
-- 		return false;
-- 	end
-- 	local unitInfo = GameInfo.Units[pUnit:GetType()];
-- 	return (unitInfo.FormationClass == "FORMATION_CLASS_CIVILIAN") and (unitInfo.ReligiousStrength == 0);
-- end

-- local KOTOKU_IN_INDEX = GameInfo.Buildings['BUILDING_KOTOKU_IN'].Index;
-- function m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.IsVisible(pUnit : object)
-- 	local ownerId = pUnit:GetOwner();
-- 	local owner = Players[ownerId];
-- 	return Utils.PlayerHasWonder(owner, KOTOKU_IN_INDEX);
-- end

-- -- ===========================================================================
-- function m_HDUnitCommands.PRAVRAJYA_KOTOKU_IN.IsDisabled(pUnit : object)
-- 	if pUnit == nil then
-- 		return true;
-- 	end
-- 	if pUnit:GetMovesRemaining() == 0 then
-- 		return true;
-- 	end
-- 	local location = pUnit:GetLocation();
-- 	local x = location.x;
-- 	local y = location.y;
-- 	local plot = Map.GetPlot(x, y);
-- 	return plot:GetWonderType() ~= KOTOKU_IN_INDEX;
-- end

-- ======================================================================================================================================================
-- 津巴布韦种植奢侈
-- ======================================================================================================================================================
-- 津巴布韦津巴布韦探路者 记录奢侈按钮, by xiaoxiao
local PATHFINDER_RESOURCE_KEY = "PATHFINDER_RESOURCE";
local PATHFINDER_TIME_KEY = "PATHFINDER_TIME";
m_HDUnitCommands.PATHFINDER_RECORD = {};
m_HDUnitCommands.PATHFINDER_RECORD.Properties = {};

-- UI Data
m_HDUnitCommands.PATHFINDER_RECORD.EventName = "HDPathfinderRecord";
m_HDUnitCommands.PATHFINDER_RECORD.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.PATHFINDER_RECORD.Icon = "ICON_UNITCOMMAND_PATHFINDER_COPY";
m_HDUnitCommands.PATHFINDER_RECORD.DoNotDelete = true;
m_HDUnitCommands.PATHFINDER_RECORD.GetToolTipString = function (unit)
	-- basic
	local s = Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_RECORD_NAME");
	-- currently recording
	if unit == nil then
		return s;
	end
	local resourceId = unit:GetProperty(PATHFINDER_RESOURCE_KEY);
	if resourceId ~= nil then
		local resourceInfo = GameInfo.Resources[resourceId];
		if resourceInfo ~= nil then
			s = s .. "[NEWLINE]" .. Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_RECORD_RECORDING") .. " [ICON_" .. resourceInfo.ResourceType .. '] ' .. Locale.Lookup(resourceInfo.Name);
		end
	end
	-- resource on plot
	local location = unit:GetLocation();
	local plot = Map.GetPlot(location.x, location.y);
	local resourceId = plot:GetResourceType();
	if resourceId ~= -1 then
		local resourceInfo = GameInfo.Resources[resourceId];
		if resourceInfo.ResourceClassType == 'RESOURCECLASS_LUXURY' then
			s = s .. "[NEWLINE]" .. Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_RECORD_CURRENT") .. " [ICON_" .. resourceInfo.ResourceType .. '] ' .. Locale.Lookup(resourceInfo.Name);
		end
	end
	return s;
end
m_HDUnitCommands.PATHFINDER_RECORD.DisabledToolTipString = Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_RECORD_DISABLED_TT");
m_HDUnitCommands.PATHFINDER_RECORD.VisibleInUI = true;
function m_HDUnitCommands.PATHFINDER_RECORD.CanUse(pUnit : object)
	if pUnit == nil then
		return false;
	end
	local unitInfo = GameInfo.Units[pUnit:GetType()];
	if unitInfo == nil then
		return false;
	end
	return unitInfo.UnitType == 'UNIT_ZIMBABWE_PATHFINDER';
end

function m_HDUnitCommands.PATHFINDER_RECORD.IsVisible(pUnit : object)
	if pUnit == nil then
		return false;
	end
	local times = pUnit:GetProperty(PATHFINDER_TIME_KEY) or 0;
	return times < (GlobalParameters.PATHFINDER_ACTIVATION_CHARGE or 0);
end

function m_HDUnitCommands.PATHFINDER_RECORD.IsDisabled(pUnit : object)
	if pUnit == nil then
		return true;
	end
	local location = pUnit:GetLocation();
	local plot = Map.GetPlot(location.x, location.y);
	local resourceId = plot:GetResourceType();
	if resourceId ~= -1 then
		local resourceInfo = GameInfo.Resources[resourceId];
		if resourceInfo.ResourceClassType == 'RESOURCECLASS_LUXURY' then
			return false;
		end
	end
	return true;
end

-- 津巴布韦津巴布韦探路者 种植奢侈按钮, by xiaoxiao
m_HDUnitCommands.PATHFINDER_PLANT = {};
m_HDUnitCommands.PATHFINDER_PLANT.Properties = {};

-- UI Data
m_HDUnitCommands.PATHFINDER_PLANT.EventName = "HDPathfinderPlant";
m_HDUnitCommands.PATHFINDER_PLANT.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.PATHFINDER_PLANT.Icon = "ICON_UNITCOMMAND_PATHFINDER_PLANT";
m_HDUnitCommands.PATHFINDER_PLANT.DoNotDelete = true;
m_HDUnitCommands.PATHFINDER_PLANT.GetToolTipString = function (unit)
	-- basic
	local s = Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_PLANT_NAME");
	if unit == nil then
		return s;
	end
	-- remaining times
	local times = (GlobalParameters.PATHFINDER_ACTIVATION_CHARGE or 0) - (unit:GetProperty(PATHFINDER_TIME_KEY) or 0);
	s = s .. "[NEWLINE]" .. Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_PLANT_CHARGES", times);
	-- currently recording
	local resourceId = unit:GetProperty(PATHFINDER_RESOURCE_KEY);
	if resourceId ~= nil then
		local resourceInfo = GameInfo.Resources[resourceId];
		if resourceInfo ~= nil then
			s = s .. "[NEWLINE]" .. Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_PLANT_RECORDING") .. " [ICON_" .. resourceInfo.ResourceType .. '] ' .. Locale.Lookup(resourceInfo.Name);
		end
	end
	return s;
end

m_HDUnitCommands.PATHFINDER_PLANT.GetDisabledToolTipString = function (unit)
	if unit == nil then
		return "";
	end
	local resourceId = unit:GetProperty(PATHFINDER_RESOURCE_KEY);
	if resourceId == nil then
		return Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_PLANT_MUST_HAS_RECORD");
	end
	local resourceInfo = GameInfo.Resources[resourceId];
	local onWater = false;
	local onLand = resourceInfo.Frequency > 0;
	for row in GameInfo.Resource_ValidTerrains() do
		if row.ResourceType == resourceInfo.ResourceType then
			if row.TerrainType == 'TERRAIN_COAST' then
				onWater = true;
			else
				onLand = true;
			end
		end
	end
	local location = unit:GetLocation();
	local plot = Map.GetPlot(location.x, location.y);
	if plot:GetOwner() ~= unit:GetOwner() then
		return Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_PLANT_MUST_OWN");
	end
	if plot:GetDistrictType() ~= -1 then
		return Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_PLANT_MUST_HAVE_NO_DISTRICT");
	end
	local isWater = plot:GetTerrainType() == COAST_INDEX;
	if isWater and (not onWater) then
		return Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_PLANT_MUST_ON_LAND");
	end
	if (not isWater) and (not onLand) then
		return Locale.Lookup("LOC_UNITCOMMAND_PATHFINDER_PLANT_MUST_ON_WATER");
	end
	return "";
end
m_HDUnitCommands.PATHFINDER_PLANT.VisibleInUI = true;
function m_HDUnitCommands.PATHFINDER_PLANT.CanUse(pUnit : object)
	if pUnit == nil then
		return false;
	end
	local unitInfo = GameInfo.Units[pUnit:GetType()];
	if unitInfo == nil then
		return false;
	end
	return unitInfo.UnitType == 'UNIT_ZIMBABWE_PATHFINDER';
end

function m_HDUnitCommands.PATHFINDER_PLANT.IsVisible(pUnit : object)
	if pUnit == nil then
		return false;
	end
	local times = pUnit:GetProperty(PATHFINDER_TIME_KEY) or 0;
	return times < (GlobalParameters.PATHFINDER_ACTIVATION_CHARGE or 0);
end

function m_HDUnitCommands.PATHFINDER_PLANT.IsDisabled(pUnit : object)
	if pUnit == nil then
		return true;
	end
	local resourceId = pUnit:GetProperty(PATHFINDER_RESOURCE_KEY);
	if resourceId == nil then
		return true;
	end
	local resourceInfo = GameInfo.Resources[resourceId];
	local onWater = false;
	local onLand = resourceInfo.Frequency > 0;
	for row in GameInfo.Resource_ValidTerrains() do
		if row.ResourceType == resourceInfo.ResourceType then
			if row.TerrainType == 'TERRAIN_COAST' then
				onWater = true;
			else
				onLand = true;
			end
		end
	end
	local location = pUnit:GetLocation();
	local plot = Map.GetPlot(location.x, location.y);
	if plot:GetOwner() ~= pUnit:GetOwner() then
		return true;
	end
	if plot:GetDistrictType() ~= -1 then
		return true;
	end
	local isWater = plot:GetTerrainType() == COAST_INDEX;
	if isWater and (not onWater) then
		return true;
	end
	if (not isWater) and (not onLand) then
		return true;
	end
	return false;
end

-- ======================================================================================================================================================
-- 林肯解放
-- ======================================================================================================================================================
m_HDUnitCommands.LIBERATION_LINCOLN = {};
m_HDUnitCommands.LIBERATION_LINCOLN.Properties = {};

-- UI Data
m_HDUnitCommands.LIBERATION_LINCOLN.EventName = "HD_LIBERATION_LINCOLN";
m_HDUnitCommands.LIBERATION_LINCOLN.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.LIBERATION_LINCOLN.Icon = "ICON_UNITCOMMAND_LIBERATION_LINCOLN";
m_HDUnitCommands.LIBERATION_LINCOLN.ToolTipString = Locale.Lookup("LOC_UNITCOMMAND_LIBERATION_LINCOLN_NAME") .. "[NEWLINE][NEWLINE]" .. 
										Locale.Lookup("LOC_UNITCOMMAND_LIBERATION_LINCOLN_DESCRIPTION");
m_HDUnitCommands.LIBERATION_LINCOLN.DisabledToolTipString = Locale.Lookup("LOC_UNITCOMMAND_LIBERATION_LINCOLN_DISABLED_TT");
m_HDUnitCommands.LIBERATION_LINCOLN.VisibleInUI = true;
function m_HDUnitCommands.LIBERATION_LINCOLN.CanUse(pUnit : object)
	if pUnit == nil then
		return false;
	end
	local unitInfo = GameInfo.Units[pUnit:GetType()];
	return unitInfo.UnitType == "UNIT_BUILDER";
end

function m_HDUnitCommands.LIBERATION_LINCOLN.IsVisible(pUnit : object)
	local ownerId = pUnit:GetOwner();
	return Utils.LeaderHasTrait(ownerId, 'TRAIT_LEADER_LINCOLN');
end

-- ===========================================================================
function m_HDUnitCommands.LIBERATION_LINCOLN.IsDisabled(pUnit : object)
	if pUnit == nil then
		return true;
	end
	if pUnit:GetMovesRemaining() == 0 then
		return true;
	end
	local location = pUnit:GetLocation();
	local x = location.x;
	local y = location.y;
	local plot = Map.GetPlot(x, y);
	local districtInfo = GameInfo.Districts['DISTRICT_INDUSTRIAL_ZONE'];
	return districtInfo.Index ~= plot:GetDistrictType();
--	local districtInfo = GameInfo.Districts[plot:GetDistrictType()];
--	return districtInfo.DistrictType ~= 'DISTRICT_INDUSTRIAL_ZONE';
end

-- ======================================================================================================================================================
-- 工程单位挖火山土 （原婆罗浮屠能力）
-- ======================================================================================================================================================
local VOLCANIC_SOIL_INDEX = GameInfo.Features['FEATURE_VOLCANIC_SOIL'].Index
local MILITARY_ENGINEER_EXCAVATE_TIMES_TAG = 'HD_MILITARY_ENGINEER_EXCAVATE_TIMES';
local MILITARY_ENGINEER_EXCAVATE_MAX_TIMES = GlobalParameters.HD_MILITARY_ENGINEER_EXCAVATE_MAX_TIMES or 0;

m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE = {};
m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.Properties = {};

m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.EventName = "HD_Military_Engineer_Excavate";
m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.Icon = "ICON_UNITCOMMAND_MILITARY_ENGINEER_EXCAVATE";
m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.ToolTipString = Locale.Lookup("LOC_UNITCOMMAND_MILITARY_ENGINEER_EXCAVATE_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_UNITCOMMAND_MILITARY_ENGINEER_EXCAVATE_DESCRIPTION");
m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.GetDisabledToolTipString = function (unit)
	if unit == nil then
		return '';
	end
	if unit:GetMovesRemaining() == 0 then
		return '[COLOR:Red]' .. Locale.Lookup("LOC_HUD_UNIT_ACTION_PILLAGE_REQUIRES_MOVEMENT") .. '[ENDCOLOR]';
	end

	local plotId = unit:GetPlotId();
	local plot = Map.GetPlotByIndex(plotId);
	local times = plot:GetProperty(MILITARY_ENGINEER_EXCAVATE_TIMES_TAG) or 0

	if VOLCANIC_SOIL_INDEX ~= plot:GetFeatureType() then
		return Locale.Lookup("LOC_UNITCOMMAND_MILITARY_ENGINEER_EXCAVATE_DISABLED")
	end

	if plot:GetDistrictType() ~= -1 then
		return Locale.Lookup("LOC_UNITCOMMAND_MILITARY_ENGINEER_EXCAVATE_DISABLED")
	end

	-- if plot:GetImprovementType() ~= -1 then
	-- 	return Locale.Lookup("LOC_UNITCOMMAND_MILITARY_ENGINEER_EXCAVATE_DISABLED")
	-- end

	if times >= MILITARY_ENGINEER_EXCAVATE_MAX_TIMES then
		return Locale.Lookup("LOC_UNITCOMMAND_MILITARY_ENGINEER_EXCAVATE_MAX_TIMES")
	end

	return '';
end

m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.VisibleInUI = true;
m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.DoNotDelete = true;

function m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.CanUse(unit: object)
	if unit == nil then
		return false;
	end
	local unitInfo = GameInfo.Units[unit:GetType()];
	return unitInfo.UnitType == "UNIT_SAPPER"
			or unitInfo.UnitType == "UNIT_MILITARY_ENGINEER"
			or unitInfo.UnitType == "UNIT_ENGINEER_CORP";
end

function m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.IsVisible(unit: object)
	if unit == nil then
		return false;
	end
	local unitInfo = GameInfo.Units[unit:GetType()];
	return unitInfo.UnitType == "UNIT_SAPPER"
			or unitInfo.UnitType == "UNIT_MILITARY_ENGINEER"
			or unitInfo.UnitType == "UNIT_ENGINEER_CORP";
end

function m_HDUnitCommands.MILITARY_ENGINEER_EXCAVATE.IsDisabled(unit: object)
	if unit == nil then
		return true;
	end
	if unit:GetMovesRemaining() == 0 then
		return true;
	end

	local plotId = unit:GetPlotId();
	local plot = Map.GetPlotByIndex(plotId);
	local times = plot:GetProperty(MILITARY_ENGINEER_EXCAVATE_TIMES_TAG) or 0

	return VOLCANIC_SOIL_INDEX ~= plot:GetFeatureType()
			or plot:GetDistrictType() ~= -1
			-- or plot:GetImprovementType() ~= -1
			or times >= MILITARY_ENGINEER_EXCAVATE_MAX_TIMES;
end

-- ======================================================================================================================================================
-- 文老秦
-- ======================================================================================================================================================
local WONDER_INDEX = GameInfo.Districts['DISTRICT_WONDER'].Index;
local QIN_WORKER_BUILD_LATER_WONDER_PERCENTAGE = GlobalParameters.HD_QIN_WORKER_BUILD_LATER_WONDER_PERCENTAGE or 0;
local UNCOMPLETED_WONDER_TAG = 'HD_UNCOMPLETED_WONDER'

m_HDUnitCommands.QIN_BULDER_WONDER = {};
m_HDUnitCommands.QIN_BULDER_WONDER.Properties = {};

m_HDUnitCommands.QIN_BULDER_WONDER.EventName = "HD_Qin_Builder_Later_Wonder";
m_HDUnitCommands.QIN_BULDER_WONDER.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.QIN_BULDER_WONDER.Icon = "ICON_UNITCOMMAND_QIN_BULDER_WONDER";
m_HDUnitCommands.QIN_BULDER_WONDER.ToolTipString = Locale.Lookup("LOC_UNITCOMMAND_QIN_BULDER_WONDER_DESCRIPTION");
m_HDUnitCommands.QIN_BULDER_WONDER.VisibleInUI = true;
m_HDUnitCommands.QIN_BULDER_WONDER.DoNotDelete = true;

function m_HDUnitCommands.QIN_BULDER_WONDER.CanUse(unit: object)
	if unit == nil then
		return false;
	end
	local unitInfo = GameInfo.Units[unit:GetType()];
	return unitInfo.UnitType == "UNIT_BUILDER";
end

function m_HDUnitCommands.QIN_BULDER_WONDER.IsVisible(unit: object)
	local ownerId = unit:GetOwner();
	local owner = Players[ownerId];

	if QIN_WORKER_BUILD_LATER_WONDER_PERCENTAGE <= 0 then
		return false;
	end

	if not Utils.LeaderHasTrait(ownerId, 'FIRST_EMPEROR_TRAIT') then
		return false;
	end

	local plotId = unit:GetPlotId();
	local plot = Map.GetPlotByIndex(plotId);
	-- print('QIN_BULDER_WONDER GetOwner', plot:GetOwner())
	if plot:GetOwner() ~= ownerId then
		return false;
	end
	
	-- print('QIN_BULDER_WONDER GetDistrictType', plot:GetDistrictType())
	if plot:GetDistrictType() ~= WONDER_INDEX then
		return false;
	end

	-- local wonderId = plot:GetWonderType();
	local wonderId = plot:GetProperty(UNCOMPLETED_WONDER_TAG)
	-- print('QIN_BULDER_WONDER wonderId', wonderId)
	if wonderId == -1 then
		return false;
	end

	local city = Cities.GetPlotPurchaseCity(plot);
	if city:GetBuildings():HasBuilding(wonderId) then
		return false;
	end

	local current = Utils.GetCityCurrentlyBuilding(ownerId, city:GetID());
	-- print('QIN_BULDER_WONDER current', current)
	local buildingInfo = GameInfo.Buildings[current];
	if not buildingInfo or not buildingInfo.IsWonder then
		return false;
	end

	if unit:GetMovesRemaining() == 0 then
		return false;
	end

	local era = Utils.GetBuildingEra(wonderId)
	if era <= 1 then
		return false;
	end

	return buildingInfo.Index == wonderId;
end

-- ======================================================================================================================================================
-- 巴西UU
-- ======================================================================================================================================================
local BANDEIRANTES_PLOT_TAG = 'HD_BANDEIRANTES_PLOT';
local BANDEIRANTES_RESOURCE_TAG = 'HD_BANDEIRANTES_RESOURCE';
local BANDEIRANTES_TIMES_TAG = 'HD_BANDEIRANTES_TIMES';

m_HDUnitCommands.BANDEIRANTES = {};
m_HDUnitCommands.BANDEIRANTES.Properties = {};

m_HDUnitCommands.BANDEIRANTES.EventName = "HD_Bandeirantes_Collect_Resource";
m_HDUnitCommands.BANDEIRANTES.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.BANDEIRANTES.Icon = "ICON_UNITCOMMAND_BANDEIRANTES";
m_HDUnitCommands.BANDEIRANTES.GetToolTipString = function (unit) 
	local s = Locale.Lookup("LOC_BANDEIRANTES_COLLECT_RESOURCE_TEXT");
	if unit == nil then
		return s;
	end

	local ownerId = unit:GetOwner();
	local map = Utils.GetPlayerProperty(ownerId, BANDEIRANTES_RESOURCE_TAG) or {};
	local strList = {};

	for resourceType, num in pairs(map) do
		table.insert(strList, '[ICON_' .. resourceType .. '] ' .. num);
	end

	if #strList > 0 then
		local detail = '';
		for i, detailStr in ipairs(strList) do
			if i > 1 then detail = detail .. ' '; end
			detail = detail .. detailStr;
		end

		s = s .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_BANDEIRANTES_COLLECT_RESOURCE_COLLECTED_TEXT', detail);
	end

	local times = Utils.GetUnitProperty(playerId, unit:GetID(), BANDEIRANTES_TIMES_TAG) or 0;
	if times > 0 then
		s = s .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_BANDEIRANTES_COLLECT_RESOURCE_TIMES_TEXT', times);
	end

	return s;
end
m_HDUnitCommands.BANDEIRANTES.GetDisabledToolTipString = function(unit)
	if unit == nil then
		return "";
	end

	local plotId = unit:GetPlotId();
	local plot = Map.GetPlotByIndex(plotId);
	if plot == nil then
		return "";
	end

	if plot:GetProperty(BANDEIRANTES_PLOT_TAG) == 1 then
		return Locale.Lookup("LOC_BANDEIRANTES_COLLECT_RESOURCE_DISABLED_TEXT");
	end

	local times = Utils.GetUnitProperty(playerId, unit:GetID(), BANDEIRANTES_TIMES_TAG) or 0;
	if times <= 0 then
		return Locale.Lookup("LOC_BANDEIRANTES_COLLECT_RESOURCE_DISABLED_TEXT3");
	end

	if unit:GetMovesRemaining() == 0 then
		return '[COLOR:Red]' .. Locale.Lookup("LOC_HUD_UNIT_ACTION_PILLAGE_REQUIRES_MOVEMENT") .. '[ENDCOLOR]';
	end

	return Locale.Lookup("LOC_BANDEIRANTES_COLLECT_RESOURCE_DISABLED_TEXT2");
end
m_HDUnitCommands.BANDEIRANTES.VisibleInUI = true;
m_HDUnitCommands.BANDEIRANTES.DoNotDelete = true;

function m_HDUnitCommands.BANDEIRANTES.CanUse(unit: object)
	if unit == nil then
		return false;
	end
	local unitInfo = GameInfo.Units[unit:GetType()];
	return unitInfo.UnitType == "UNIT_HD_BANDEIRANTES";
end

function m_HDUnitCommands.BANDEIRANTES.IsDisabled(unit: object)
	if unit == nil then
		return true;
	end

	local plotId = unit:GetPlotId();
	local plot = Map.GetPlotByIndex(plotId);

	local ownerId = unit:GetOwner();
	local player = Players[ownerId];

	if not plot or not player then
		return true;
	end

	if plot:GetOwner() ~= -1 then
		return true;
	end

	if plot:GetFeatureType() ~= JUNGLE_INDEX then
		return true;
	end

	if unit:GetMovesRemaining() == 0 then
		return true;
	end

	local times = Utils.GetUnitProperty(playerId, unit:GetID(), BANDEIRANTES_TIMES_TAG) or 0;
	if times <= 0 then
		return true;
	end

	local resourceId = plot:GetResourceType();
	if resourceId == -1 or resourceId == ANTIQUITY_SITE_INDEX or not player:GetResources():IsResourceVisible(plot:GetResourceTypeHash()) then
		return true;
	end

	return plot:GetProperty(BANDEIRANTES_PLOT_TAG) == 1;
end

-- ======================================================================================================================================================
-- 神圣建筑师
-- ======================================================================================================================================================
local GOVERNOR_CARDINAL_RIGHT_3_FAITH_PERCENTAGE = GlobalParameters.HD_GOVERNOR_CARDINAL_RIGHT_3_FAITH_PERCENTAGE or 0;

m_HDUnitCommands.CITADEL_OF_GOD = {};
m_HDUnitCommands.CITADEL_OF_GOD.Properties = {};

m_HDUnitCommands.CITADEL_OF_GOD.EventName = "HD_CitadelOfGodCompleteDistrict";
m_HDUnitCommands.CITADEL_OF_GOD.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.CITADEL_OF_GOD.Icon = "ICON_UNITCOMMAND_CITADEL_OF_GOD";
m_HDUnitCommands.CITADEL_OF_GOD.GetToolTipString = function (unit) 
	if not unit then return Locale.Lookup('LOC_UNIT_CITADEL_OF_GOD_DESCRIPTION'); end

	local playerId = unit:GetOwner();
	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if plot and plot:GetOwner() == playerId then
		local detail = Utils.GetPlotDistrictDetails(unit:GetX(), unit:GetY());
		if detail and not detail.IsCompleted and detail.IsUnderConstruction and GOVERNOR_CARDINAL_RIGHT_3_FAITH_PERCENTAGE > 0 then
			return Locale.Lookup('LOC_CITADEL_OF_GOD_DETAIL', math.ceil(detail.RemainingProduction * GOVERNOR_CARDINAL_RIGHT_3_FAITH_PERCENTAGE / 100), detail.DistrictName);
		end
	end

	return Locale.Lookup('LOC_UNIT_CITADEL_OF_GOD_DESCRIPTION');
end
m_HDUnitCommands.CITADEL_OF_GOD.GetDisabledToolTipString = function(unit)
	if not unit then return ""; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return ""; end

	if unit:GetMovesRemaining() == 0 then
		return '[COLOR:Red]' .. Locale.Lookup("LOC_HUD_UNIT_ACTION_PILLAGE_REQUIRES_MOVEMENT") .. '[ENDCOLOR]';
	end

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if plot and plot:GetOwner() == playerId then
		local detail = Utils.GetPlotDistrictDetails(unit:GetX(), unit:GetY());
		if detail and GOVERNOR_CARDINAL_RIGHT_3_FAITH_PERCENTAGE > 0 then
			if detail.IsCompleted or not detail.IsUnderConstruction then
				return Locale.Lookup("LOC_CITADEL_OF_GOD_NO_DISTRICTS");
			elseif math.ceil(detail.RemainingProduction * GOVERNOR_CARDINAL_RIGHT_3_FAITH_PERCENTAGE / 100) > player:GetReligion():GetFaithBalance() then
				return Locale.Lookup("LOC_CITADEL_OF_GOD_NO_FAITH");
			end
		end
	end

	return Locale.Lookup("LOC_CITADEL_OF_GOD_NO_DISTRICTS");
end
m_HDUnitCommands.CITADEL_OF_GOD.VisibleInUI = true;

function m_HDUnitCommands.CITADEL_OF_GOD.CanUse(unit)
	if not unit then return false; end
	if GOVERNOR_CARDINAL_RIGHT_3_FAITH_PERCENTAGE <= 0 then return false; end
	local unitInfo = GameInfo.Units[unit:GetType()];
	return unitInfo.UnitType == "UNIT_CITADEL_OF_GOD";
end

function m_HDUnitCommands.CITADEL_OF_GOD.IsDisabled(unit)
	if not unit then return true; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return true; end

	if unit:GetMovesRemaining() == 0 then return true; end

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return true; end
	if plot:GetOwner() ~= playerId then return true; end

	local detail = Utils.GetPlotDistrictDetails(unit:GetX(), unit:GetY());
	if not detail then return true; end

	-- local city = Cities.GetPlotPurchaseCity(plot:GetIndex());
	-- print(Locale.Lookup(city:GetName()), Locale.Lookup(detail.DistrictName), detail.IsCompleted, detail.IsUnderConstruction, detail.RemainingProduction);

	if detail.IsCompleted or not detail.IsUnderConstruction then return true; end
	return math.ceil(detail.RemainingProduction * GOVERNOR_CARDINAL_RIGHT_3_FAITH_PERCENTAGE / 100) > player:GetReligion():GetFaithBalance();
end

-- ======================================================================================================================================================
-- 具德上师
-- ======================================================================================================================================================
local GOVERNOR_CARDINAL_RIGHT_2_RELIGIOUS_DISTANCE = GlobalParameters.HD_GOVERNOR_CARDINAL_RIGHT_2_RELIGIOUS_DISTANCE or 0;
local GOVERNOR_CARDINAL_RIGHT_2_RELIGIOUS_PRESSURE = GlobalParameters.HD_GOVERNOR_CARDINAL_RIGHT_2_RELIGIOUS_PRESSURE or 0;
local GOVERNOR_CARDINAL_RIGHT_2_GURU_AOE_PRESSURE_TAG = 'HD_GOVERNOR_CARDINAL_RIGHT_2_GURU_AOE_PRESSURE';

m_HDUnitCommands.GURU_AOE_PRESSURE = {};
m_HDUnitCommands.GURU_AOE_PRESSURE.Properties = {};

m_HDUnitCommands.GURU_AOE_PRESSURE.EventName = "HD_GuruSpreadAoeReligiousPressureConsumeCharges";
m_HDUnitCommands.GURU_AOE_PRESSURE.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.GURU_AOE_PRESSURE.Icon = "ICON_UNITOPERATION_SPREAD_RELIGION";
m_HDUnitCommands.GURU_AOE_PRESSURE.ToolTipString = Locale.Lookup('LOC_ABILITY_HD_GOVERNOR_CARDINAL_RIGHT_2_GURU_TEXT');
m_HDUnitCommands.GURU_AOE_PRESSURE.DisabledToolTipString = '[COLOR:Red]' .. Locale.Lookup("LOC_HUD_UNIT_ACTION_PILLAGE_REQUIRES_MOVEMENT") .. '[ENDCOLOR]';
m_HDUnitCommands.GURU_AOE_PRESSURE.VisibleInUI = true;
m_HDUnitCommands.GURU_AOE_PRESSURE.DoNotDelete = true;

function m_HDUnitCommands.GURU_AOE_PRESSURE.CanUse(unit)
	if not unit then return false; end
	local hasAbility = unit:GetProperty(GOVERNOR_CARDINAL_RIGHT_2_GURU_AOE_PRESSURE_TAG) or 0;
	return hasAbility > 0;
end

function m_HDUnitCommands.GURU_AOE_PRESSURE.IsDisabled(unit)
	if not unit then return true; end
	return unit:GetMovesRemaining() == 0;
end

-- ======================================================================================================================================================
-- 维克多 工程单位建造战略行业
-- ======================================================================================================================================================
local UNIT_CAN_BUILD_STRATEGIC_INDUSTRY_TAG = 'HD_UNIT_CAN_BUILD_STRATEGIC_INDUSTRY';
local BUILD_STRATEGIC_INDUSTRY_CONSUME_RESOURCE_AMOUNT = GlobalParameters.HD_BUILD_STRATEGIC_INDUSTRY_CONSUME_RESOURCE_AMOUNT or 0;
local MILITARY_ENGINEERING_BUILD_STRATEGIC_INDUSTRY_CONSUME_CHARGE_NUM = GlobalParameters.HD_MILITARY_ENGINEERING_BUILD_STRATEGIC_INDUSTRY_CONSUME_CHARGE_NUM or 0;

m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY = {};
m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.Properties = {};

m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.EventName = "HD_BuildStrategicIndustry";
m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.Icon = "ICON_IMPROVEMENT_INDUSTRY";
m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.GetToolTipString = function(unit)
	if not unit then return ""; end

	local toolTipString = Locale.Lookup('LOC_UNITOPERATION_BUILD_IMPROVEMENT_DESCRIPTION')
		.. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT')
		.. Locale.Lookup('LOC_IMPROVEMENT_INDUSTRY_STRATEGIC_NAME');

	-- 改良分类
	local classificationList = {};
	for row in GameInfo.HD_Improvement_Classification() do
		if row.ImprovementType == 'IMPROVEMENT_INDUSTRY_STRATEGIC' then
			local classificationInfo = GameInfo.HD_ImprovementClassificationTypes[row.ImprovementClassificationType];
			if classificationInfo then
				table.insert(classificationList, classificationInfo.Name);
			end
		end
	end
	if #classificationList > 0 then
		toolTipString = toolTipString .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_TOOLTIP_HD_IMPROVEMENT_CLASSIFICATIONS_TEXT');
		
		for _, nameTag in ipairs(classificationList) do
			toolTipString = toolTipString .. '[NEWLINE][ICON_BULLET]' .. Locale.Lookup(nameTag)
		end
	end

	-- 增加行业公司效果说明
	if GameInfo.HD_Monopoly_Resource_Categories ~= nil then
		local plot = Map.GetPlotByIndex(unit:GetPlotId());
		if plot ~= nil then
			local resourceHash = plot:GetResourceTypeHash();
			local resource = GameInfo.Resources[resourceHash];
			local player = Players[Game.GetLocalPlayer()];
			if resource ~= nil and player ~= nil and player:GetResources():IsResourceVisible(resourceHash) then
				local industryStr = {};

				for row in GameInfo.HD_Monopoly_Resource_Categories() do
					if row.ResourceType == resource.ResourceType then
						local categoryInfo = GameInfo.HD_Monopoly_Categories[row.Category];
						if categoryInfo then
							if categoryInfo.IndustryEffect then
								table.insert(industryStr, '[ICON_BULLET]' .. Locale.Lookup('LOC_RESOURCE_CLASSIFICATION_HD_' .. row.Category .. '_NAME') .. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT') .. Locale.Lookup("LOC_" .. categoryInfo.IndustryEffect .. "_DESCRIPTION"));
							end
						end
					end
				end

				if #industryStr > 0 then
					local effectStr = '';
					for i, str in ipairs(industryStr) do
						if i > 1 then effectStr = effectStr .. "[NEWLINE]"; end
						effectStr = effectStr .. str;
					end
					toolTipString = toolTipString .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_HD_INDUSTRY_EFFECT_TEXT', effectStr);
				end
			end
		end
	end

	return toolTipString;
end
m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.GetDisabledToolTipString = function(unit)
	if not unit then return ""; end
	local unitInfo = GameInfo.Units[unit:GetType()];
	if not unitInfo then return ""; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return ""; end
	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return ""; end
	local city = Cities.GetPlotPurchaseCity(plot);
	if not city then return ""; end
	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return ""; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return ""; end

	-- 玩家是否已经建造该行业
	local alreadyBuilt = (Utils.GetPlayerProperty(playerId, PLAYER_HAS_INDUSTRY_TAG .. resourceInfo.ResourceType) or 0)
		+ (Utils.GetPlayerProperty(playerId, PLAYER_HAS_CORPORATION_TAG .. resourceInfo.ResourceType) or 0);
	if alreadyBuilt > 0 then return Locale.Lookup('LOC_IMPROVEMENT_INDUSTRY_PLAYER_DISABLED', "[ICON_" .. resourceInfo.ResourceType .. "]", resourceInfo.Name); end
	-- 本城行业个数限制
	local builtNum = (city:GetProperty(CITY_IMPROVEMENT_NUM_TAG .. 'IMPROVEMENT_INDUSTRY_STRATEGIC') or 0) + (city:GetProperty(CITY_IMPROVEMENT_NUM_TAG .. 'IMPROVEMENT_CORPORATION_STRATEGIC') or 0);
	local extraNum = city:GetProperty(CITY_ALLOW_EXTRA_TAG .. 'IMPROVEMENT_INDUSTRY_STRATEGIC') or 0;
	if extraNum < builtNum then return Locale.Lookup('LOC_IMPROVEMENT_IC_STRATEGIC_CITY_DISABLED', extraNum + 1); end
	-- 控制资源数量
	local resourceAmount = player:GetResources():GetResourceAmount(resourceId);
	if resourceAmount < BUILD_STRATEGIC_INDUSTRY_CONSUME_RESOURCE_AMOUNT then return Locale.Lookup('LOC_IMPROVEMENT_IC_STRATEGIC_RESOURCE_DISABLED', BUILD_STRATEGIC_INDUSTRY_CONSUME_RESOURCE_AMOUNT, "[ICON_" .. resourceInfo.ResourceType .. "]", resourceInfo.Name); end
	-- 单位剩余建造次数
	local needCharges = 1;
	if unitInfo.UnitType == 'UNIT_SAPPER' or unitInfo.UnitType == 'UNIT_MILITARY_ENGINEER' or unitInfo.UnitType == 'UNIT_ENGINEER_CORP' then
		needCharges = MILITARY_ENGINEERING_BUILD_STRATEGIC_INDUSTRY_CONSUME_CHARGE_NUM;
	end
	if unit:GetBuildCharges() < needCharges then return Locale.Lookup('LOC_NO_ENOUGH_CHARGE_DISABLED'); end
	-- 移动力
	if unit:GetMovesRemaining() == 0 then return '[COLOR:Red]' .. Locale.Lookup("LOC_HUD_UNIT_ACTION_PILLAGE_REQUIRES_MOVEMENT") .. '[ENDCOLOR]'; end
	
	return ""
end
m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.VisibleInUI = true;
m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.DoNotDelete = true;

function m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.CanUse(unit)
	if not unit then return false; end
	local canBuild = unit:GetProperty(UNIT_CAN_BUILD_STRATEGIC_INDUSTRY_TAG) or 0;
	return canBuild > 0;
end

function m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.IsVisible(unit)
	if not unit then return false; end

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return false; end
	if plot:GetOwner() ~= unit:GetOwner() then return false; end
	if plot:GetDistrictType() ~= -1 then return false; end
	if plot:IsNationalPark() then return false; end
	if plot:IsNaturalWonder() then return false; end

	local improvementId = plot:GetImprovementType();
	local improvementInfo = GameInfo.Improvements[improvementId];
	if improvementInfo
		and (improvementInfo.ImprovementType == 'IMPROVEMENT_CORPORATION'
		or improvementInfo.ImprovementType == 'IMPROVEMENT_CORPORATION_BONUS'
		or improvementInfo.ImprovementType == 'IMPROVEMENT_CORPORATION_STRATEGIC'
		or improvementInfo.ImprovementType == 'IMPROVEMENT_LEU_TRANSNATIONAL'
		or improvementInfo.ImprovementType == 'IMPROVEMENT_LEU_TRANSNATIONAL_SEA')
	then
		return false;
	end

	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return false; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return false; end

	return resourceInfo.ResourceClassType == 'RESOURCECLASS_STRATEGIC';
end

function m_HDUnitCommands.BUILD_STRATEGIC_INDUSTRY.IsDisabled(unit)
	if not unit then return true; end
	local unitInfo = GameInfo.Units[unit:GetType()];
	if not unitInfo then return true; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return true; end
	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return true; end
	local city = Cities.GetPlotPurchaseCity(plot);
	if not city then return true; end
	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return true; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return true; end

	-- 玩家是否已经建造该行业
	local alreadyBuilt = (Utils.GetPlayerProperty(playerId, PLAYER_HAS_INDUSTRY_TAG .. resourceInfo.ResourceType) or 0)
		+ (Utils.GetPlayerProperty(playerId, PLAYER_HAS_CORPORATION_TAG .. resourceInfo.ResourceType) or 0);
	if alreadyBuilt > 0 then return true; end
	-- 本城行业个数限制
	local builtNum = (city:GetProperty(CITY_IMPROVEMENT_NUM_TAG .. 'IMPROVEMENT_INDUSTRY_STRATEGIC') or 0) + (city:GetProperty(CITY_IMPROVEMENT_NUM_TAG .. 'IMPROVEMENT_CORPORATION_STRATEGIC') or 0);
	local extraNum = city:GetProperty(CITY_ALLOW_EXTRA_TAG .. 'IMPROVEMENT_INDUSTRY_STRATEGIC') or 0;
	if extraNum < builtNum then return true; end
	-- 控制资源数量
	local resourceAmount = player:GetResources():GetResourceAmount(resourceId);
	if resourceAmount < BUILD_STRATEGIC_INDUSTRY_CONSUME_RESOURCE_AMOUNT then return true; end
	-- 单位剩余建造次数
	local needCharges = 1;
	if unitInfo.UnitType == 'UNIT_SAPPER' or unitInfo.UnitType == 'UNIT_MILITARY_ENGINEER' or unitInfo.UnitType == 'UNIT_ENGINEER_CORP' then
		needCharges = MILITARY_ENGINEERING_BUILD_STRATEGIC_INDUSTRY_CONSUME_CHARGE_NUM;
	end
	if unit:GetBuildCharges() < needCharges then return true; end
	-- 移动力
	return unit:GetMovesRemaining() == 0;
end

-- ======================================================================================================================================================
-- 马格努斯 建造者建造加成行业
-- ======================================================================================================================================================
local UNIT_CAN_BUILD_BONUS_INDUSTRY_TAG = 'HD_UNIT_CAN_BUILD_BONUS_INDUSTRY';
local BUILD_BONUS_INDUSTRY_NEED_RESOURCE_NUM = GlobalParameters.HD_BUILD_BONUS_INDUSTRY_NEED_RESOURCE_NUM or 0;
local BUILDER_BUILD_BONUS_INDUSTRY_CONSUME_CHARGE_NUM = GlobalParameters.HD_BUILDER_BUILD_BONUS_INDUSTRY_CONSUME_CHARGE_NUM or 0;

m_HDUnitCommands.BUILD_BONUS_INDUSTRY = {};
m_HDUnitCommands.BUILD_BONUS_INDUSTRY.Properties = {};

m_HDUnitCommands.BUILD_BONUS_INDUSTRY.EventName = "HD_BuildBonusIndustry";
m_HDUnitCommands.BUILD_BONUS_INDUSTRY.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.BUILD_BONUS_INDUSTRY.Icon = "ICON_IMPROVEMENT_INDUSTRY";
m_HDUnitCommands.BUILD_BONUS_INDUSTRY.GetToolTipString = function(unit)
	if not unit then return ""; end

	local toolTipString = Locale.Lookup('LOC_UNITOPERATION_BUILD_IMPROVEMENT_DESCRIPTION')
		.. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT')
		.. Locale.Lookup('LOC_IMPROVEMENT_INDUSTRY_BONUS_NAME');

	-- 改良分类
	local classificationList = {};
	for row in GameInfo.HD_Improvement_Classification() do
		if row.ImprovementType == 'IMPROVEMENT_INDUSTRY_BONUS' then
			local classificationInfo = GameInfo.HD_ImprovementClassificationTypes[row.ImprovementClassificationType];
			if classificationInfo then
				table.insert(classificationList, classificationInfo.Name);
			end
		end
	end
	if #classificationList > 0 then
		toolTipString = toolTipString .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_TOOLTIP_HD_IMPROVEMENT_CLASSIFICATIONS_TEXT');
		
		for _, nameTag in ipairs(classificationList) do
			toolTipString = toolTipString .. '[NEWLINE][ICON_BULLET]' .. Locale.Lookup(nameTag)
		end
	end

	-- 增加行业公司效果说明
	if GameInfo.HD_Monopoly_Resource_Categories ~= nil then
		local plot = Map.GetPlotByIndex(unit:GetPlotId());
		if plot ~= nil then
			local resourceHash = plot:GetResourceTypeHash();
			local resource = GameInfo.Resources[resourceHash];
			local player = Players[Game.GetLocalPlayer()];
			if resource ~= nil and player ~= nil and player:GetResources():IsResourceVisible(resourceHash) then
				local industryStr = {};

				for row in GameInfo.HD_Monopoly_Resource_Categories() do
					if row.ResourceType == resource.ResourceType then
						local categoryInfo = GameInfo.HD_Monopoly_Categories[row.Category];
						if categoryInfo then
							if categoryInfo.IndustryEffect then
								table.insert(industryStr, '[ICON_BULLET]' .. Locale.Lookup('LOC_RESOURCE_CLASSIFICATION_HD_' .. row.Category .. '_NAME') .. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT') .. Locale.Lookup("LOC_" .. categoryInfo.IndustryEffect .. "_DESCRIPTION"));
							end
						end
					end
				end

				if #industryStr > 0 then
					local effectStr = '';
					for i, str in ipairs(industryStr) do
						if i > 1 then effectStr = effectStr .. "[NEWLINE]"; end
						effectStr = effectStr .. str;
					end
					toolTipString = toolTipString .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_HD_INDUSTRY_EFFECT_TEXT', effectStr);
				end
			end
		end
	end

	return toolTipString;
end
m_HDUnitCommands.BUILD_BONUS_INDUSTRY.GetDisabledToolTipString = function(unit)
	if not unit then return ""; end
	local unitInfo = GameInfo.Units[unit:GetType()];
	if not unitInfo then return ""; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return ""; end
	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return ""; end
	local city = Cities.GetPlotPurchaseCity(plot);
	if not city then return ""; end
	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return ""; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return ""; end

	-- 玩家是否已经建造该行业
	local alreadyBuilt = (Utils.GetPlayerProperty(playerId, PLAYER_HAS_INDUSTRY_TAG .. resourceInfo.ResourceType) or 0)
		+ (Utils.GetPlayerProperty(playerId, PLAYER_HAS_CORPORATION_TAG .. resourceInfo.ResourceType) or 0);
	if alreadyBuilt > 0 then return Locale.Lookup('LOC_IMPROVEMENT_INDUSTRY_PLAYER_DISABLED', "[ICON_" .. resourceInfo.ResourceType .. "]", resourceInfo.Name); end
	-- 本城行业个数限制
	local builtNum = (city:GetProperty(CITY_IMPROVEMENT_NUM_TAG .. 'IMPROVEMENT_INDUSTRY_BONUS') or 0) + (city:GetProperty(CITY_IMPROVEMENT_NUM_TAG .. 'IMPROVEMENT_CORPORATION_BONUS') or 0);
	local extraNum = city:GetProperty(CITY_ALLOW_EXTRA_TAG .. 'IMPROVEMENT_INDUSTRY_BONUS') or 0;
	if extraNum < builtNum then return Locale.Lookup('LOC_IMPROVEMENT_IC_BONUS_CITY_DISABLED', extraNum + 1); end
	-- 控制资源数量
	local resourceAmount = player:GetResources():GetResourceAmount(resourceId);
	if resourceAmount < BUILD_BONUS_INDUSTRY_NEED_RESOURCE_NUM then return Locale.Lookup('LOC_IMPROVEMENT_IC_BONUS_RESOURCE_DISABLED', BUILD_BONUS_INDUSTRY_NEED_RESOURCE_NUM, "[ICON_" .. resourceInfo.ResourceType .. "]", resourceInfo.Name); end
	-- 单位剩余建造次数
	local needCharges = 1;
	if unitInfo.UnitType == 'UNIT_BUILDER' then
		needCharges = BUILDER_BUILD_BONUS_INDUSTRY_CONSUME_CHARGE_NUM;
	end
	if unit:GetBuildCharges() < needCharges then return Locale.Lookup('LOC_NO_ENOUGH_CHARGE_DISABLED'); end
	-- 移动力
	if unit:GetMovesRemaining() == 0 then return '[COLOR:Red]' .. Locale.Lookup("LOC_HUD_UNIT_ACTION_PILLAGE_REQUIRES_MOVEMENT") .. '[ENDCOLOR]'; end
	
	return ""
end
m_HDUnitCommands.BUILD_BONUS_INDUSTRY.VisibleInUI = true;
m_HDUnitCommands.BUILD_BONUS_INDUSTRY.DoNotDelete = true;

function m_HDUnitCommands.BUILD_BONUS_INDUSTRY.CanUse(unit)
	if not unit then return false; end
	local canBuild = unit:GetProperty(UNIT_CAN_BUILD_BONUS_INDUSTRY_TAG) or 0;
	return canBuild > 0;
end

function m_HDUnitCommands.BUILD_BONUS_INDUSTRY.IsVisible(unit)
	if not unit then return false; end

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return false; end
	if plot:GetOwner() ~= unit:GetOwner() then return false; end
	if plot:GetDistrictType() ~= -1 then return false; end
	if plot:IsNationalPark() then return false; end
	if plot:IsNaturalWonder() then return false; end

	local improvementId = plot:GetImprovementType();
	local improvementInfo = GameInfo.Improvements[improvementId];
	if improvementInfo
		and (improvementInfo.ImprovementType == 'IMPROVEMENT_CORPORATION'
		or improvementInfo.ImprovementType == 'IMPROVEMENT_CORPORATION_BONUS'
		or improvementInfo.ImprovementType == 'IMPROVEMENT_CORPORATION_STRATEGIC'
		or improvementInfo.ImprovementType == 'IMPROVEMENT_LEU_TRANSNATIONAL'
		or improvementInfo.ImprovementType == 'IMPROVEMENT_LEU_TRANSNATIONAL_SEA')
	then
		return false;
	end

	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return false; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return false; end

	return resourceInfo.ResourceClassType == 'RESOURCECLASS_BONUS';
end

function m_HDUnitCommands.BUILD_BONUS_INDUSTRY.IsDisabled(unit)
	if not unit then return true; end
	local unitInfo = GameInfo.Units[unit:GetType()];
	if not unitInfo then return true; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return true; end
	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return true; end
	local city = Cities.GetPlotPurchaseCity(plot);
	if not city then return true; end
	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return true; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return true; end

	-- 玩家是否已经建造该行业
	local alreadyBuilt = (Utils.GetPlayerProperty(playerId, PLAYER_HAS_INDUSTRY_TAG .. resourceInfo.ResourceType) or 0)
		+ (Utils.GetPlayerProperty(playerId, PLAYER_HAS_CORPORATION_TAG .. resourceInfo.ResourceType) or 0);
	if alreadyBuilt > 0 then return true; end
	-- 本城行业个数限制
	local builtNum = (city:GetProperty(CITY_IMPROVEMENT_NUM_TAG .. 'IMPROVEMENT_INDUSTRY_BONUS') or 0) + (city:GetProperty(CITY_IMPROVEMENT_NUM_TAG .. 'IMPROVEMENT_CORPORATION_BONUS') or 0);
	local extraNum = city:GetProperty(CITY_ALLOW_EXTRA_TAG .. 'IMPROVEMENT_INDUSTRY_BONUS') or 0;
	if extraNum < builtNum then return true; end
	-- 控制资源数量
	local resourceAmount = player:GetResources():GetResourceAmount(resourceId);
	if resourceAmount < BUILD_BONUS_INDUSTRY_NEED_RESOURCE_NUM then return true; end
	-- 单位剩余建造次数
	local needCharges = 1;
	if unitInfo.UnitType == 'UNIT_BUILDER' then
		needCharges = BUILDER_BUILD_BONUS_INDUSTRY_CONSUME_CHARGE_NUM;
	end
	if unit:GetBuildCharges() < needCharges then return true; end
	-- 移动力
	return unit:GetMovesRemaining() == 0;
end

-- ======================================================================================================================================================
-- 鲁尔山谷 投资人建造战略公司
-- ======================================================================================================================================================
local UNIT_CAN_BUILD_STRATEGIC_CORPORATION_TAG = 'HD_UNIT_CAN_BUILD_STRATEGIC_CORPORATION';
local BUILD_STRATEGIC_CORPORATION_CONSUME_RESOURCE_AMOUNT = GlobalParameters.HD_BUILD_STRATEGIC_CORPORATION_CONSUME_RESOURCE_AMOUNT or 0;

m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION = {};
m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.Properties = {};

m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.EventName = "HD_BuildStrategicCorporation";
m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.Icon = "ICON_IMPROVEMENT_CORPORATION";
m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.GetToolTipString = function(unit)
	if not unit then return ""; end

	local toolTipString = Locale.Lookup('LOC_UNITOPERATION_BUILD_IMPROVEMENT_DESCRIPTION')
		.. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT')
		.. Locale.Lookup('LOC_IMPROVEMENT_CORPORATION_STRATEGIC_NAME');

	-- 改良分类
	local classificationList = {};
	for row in GameInfo.HD_Improvement_Classification() do
		if row.ImprovementType == 'IMPROVEMENT_CORPORATION_STRATEGIC' then
			local classificationInfo = GameInfo.HD_ImprovementClassificationTypes[row.ImprovementClassificationType];
			if classificationInfo then
				table.insert(classificationList, classificationInfo.Name);
			end
		end
	end
	if #classificationList > 0 then
		toolTipString = toolTipString .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_TOOLTIP_HD_IMPROVEMENT_CLASSIFICATIONS_TEXT');
		
		for _, nameTag in ipairs(classificationList) do
			toolTipString = toolTipString .. '[NEWLINE][ICON_BULLET]' .. Locale.Lookup(nameTag)
		end
	end

	-- 增加行业公司效果说明
	if GameInfo.HD_Monopoly_Resource_Categories ~= nil then
		local plot = Map.GetPlotByIndex(unit:GetPlotId());
		if plot ~= nil then
			local resourceHash = plot:GetResourceTypeHash();
			local resource = GameInfo.Resources[resourceHash];
			local player = Players[Game.GetLocalPlayer()];
			if resource ~= nil and player ~= nil and player:GetResources():IsResourceVisible(resourceHash) then
				local corporationStr = {};

				for row in GameInfo.HD_Monopoly_Resource_Categories() do
					if row.ResourceType == resource.ResourceType then
						local categoryInfo = GameInfo.HD_Monopoly_Categories[row.Category];
						if categoryInfo then
							if categoryInfo.CorporationEffect then
								table.insert(corporationStr, '[ICON_BULLET]' .. Locale.Lookup('LOC_RESOURCE_CLASSIFICATION_HD_' .. row.Category .. '_NAME') .. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT') .. Locale.Lookup("LOC_" .. categoryInfo.CorporationEffect .. "_DESCRIPTION"));
							end
						end
					end
				end

				if #corporationStr > 0 then
					local effectStr = '';
					for i, str in ipairs(corporationStr) do
						if i > 1 then effectStr = effectStr .. "[NEWLINE]"; end
						effectStr = effectStr .. str;
					end
					toolTipString = toolTipString .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_HD_CORPORATION_EFFECT_TEXT', effectStr);
				end
			end
		end
	end

	return toolTipString;
end
m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.GetDisabledToolTipString = function(unit)
	if not unit then return ""; end
	local unitInfo = GameInfo.Units[unit:GetType()];
	if not unitInfo then return ""; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return ""; end
	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return ""; end
	local city = Cities.GetPlotPurchaseCity(plot);
	if not city then return ""; end
	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return ""; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return ""; end

	-- 世界上是否已经建造该公司
	local alreadyBuilt = (Utils.GetGameProperty(GAME_HAS_CORPORATION_TAG .. resourceInfo.ResourceType) or 0);
	if alreadyBuilt > 0 then return Locale.Lookup('LOC_IMPROVEMENT_CORPORATION_GAME_DISABLED', "[ICON_" .. resourceInfo.ResourceType .. "]", resourceInfo.Name); end
	-- 控制资源数量
	local resourceAmount = player:GetResources():GetResourceAmount(resourceId);
	if resourceAmount < BUILD_STRATEGIC_CORPORATION_CONSUME_RESOURCE_AMOUNT then return Locale.Lookup('LOC_IMPROVEMENT_IC_STRATEGIC_RESOURCE_DISABLED', BUILD_STRATEGIC_CORPORATION_CONSUME_RESOURCE_AMOUNT, "[ICON_" .. resourceInfo.ResourceType .. "]", resourceInfo.Name); end
	-- 单位剩余建造次数
	local needCharges = 1;
	if unit:GetBuildCharges() < needCharges then return Locale.Lookup('LOC_NO_ENOUGH_CHARGE_DISABLED'); end
	-- 移动力
	if unit:GetMovesRemaining() == 0 then return '[COLOR:Red]' .. Locale.Lookup("LOC_HUD_UNIT_ACTION_PILLAGE_REQUIRES_MOVEMENT") .. '[ENDCOLOR]'; end
	
	return ""
end
m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.VisibleInUI = true;
m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.DoNotDelete = true;

function m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.CanUse(unit)
	if not unit then return false; end
	local canBuild = unit:GetProperty(UNIT_CAN_BUILD_STRATEGIC_CORPORATION_TAG) or 0;
	return canBuild > 0;
end

function m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.IsVisible(unit)
	if not unit then return false; end

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return false; end
	if plot:GetOwner() ~= unit:GetOwner() then return false; end
	if plot:GetDistrictType() ~= -1 then return false; end
	if plot:IsNationalPark() then return false; end
	if plot:IsNaturalWonder() then return false; end

	local improvementId = plot:GetImprovementType();
	local improvementInfo = GameInfo.Improvements[improvementId];
	if not improvementInfo then return false; end
	if improvementInfo.ImprovementType ~= 'IMPROVEMENT_INDUSTRY_STRATEGIC' then return false; end

	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return false; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return false; end

	return resourceInfo.ResourceClassType == 'RESOURCECLASS_STRATEGIC';
end

function m_HDUnitCommands.BUILD_STRATEGIC_CORPORATION.IsDisabled(unit)
	if not unit then return true; end
	local unitInfo = GameInfo.Units[unit:GetType()];
	if not unitInfo then return true; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return true; end
	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return true; end
	local city = Cities.GetPlotPurchaseCity(plot);
	if not city then return true; end
	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return true; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return true; end

	-- 世界上是否已经建造该公司
	local alreadyBuilt = (Utils.GetGameProperty(GAME_HAS_CORPORATION_TAG .. resourceInfo.ResourceType) or 0);
	if alreadyBuilt > 0 then return true; end
	-- 控制资源数量
	local resourceAmount = player:GetResources():GetResourceAmount(resourceId);
	if resourceAmount < BUILD_STRATEGIC_CORPORATION_CONSUME_RESOURCE_AMOUNT then return true; end
	-- 单位剩余建造次数
	local needCharges = 1;
	if unit:GetBuildCharges() < needCharges then return true; end
	-- 移动力
	return unit:GetMovesRemaining() == 0;
end

-- ======================================================================================================================================================
-- 鲁尔山谷 投资人建造加成公司
-- ======================================================================================================================================================
local UNIT_CAN_BUILD_BONUS_CORPORATION_TAG = 'HD_UNIT_CAN_BUILD_BONUS_CORPORATION';
local BUILD_BONUS_CORPORATION_NEED_RESOURCE_NUM = GlobalParameters.HD_BUILD_BONUS_CORPORATION_NEED_RESOURCE_NUM or 0;

m_HDUnitCommands.BUILD_BONUS_CORPORATION = {};
m_HDUnitCommands.BUILD_BONUS_CORPORATION.Properties = {};

m_HDUnitCommands.BUILD_BONUS_CORPORATION.EventName = "HD_BuildBonusCorporation";
m_HDUnitCommands.BUILD_BONUS_CORPORATION.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.BUILD_BONUS_CORPORATION.Icon = "ICON_IMPROVEMENT_CORPORATION";
m_HDUnitCommands.BUILD_BONUS_CORPORATION.GetToolTipString = function(unit)
	if not unit then return ""; end

	local toolTipString = Locale.Lookup('LOC_UNITOPERATION_BUILD_IMPROVEMENT_DESCRIPTION')
		.. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT')
		.. Locale.Lookup('LOC_IMPROVEMENT_CORPORATION_BONUS_NAME');

	-- 改良分类
	local classificationList = {};
	for row in GameInfo.HD_Improvement_Classification() do
		if row.ImprovementType == 'IMPROVEMENT_CORPORATION_BONUS' then
			local classificationInfo = GameInfo.HD_ImprovementClassificationTypes[row.ImprovementClassificationType];
			if classificationInfo then
				table.insert(classificationList, classificationInfo.Name);
			end
		end
	end
	if #classificationList > 0 then
		toolTipString = toolTipString .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_TOOLTIP_HD_IMPROVEMENT_CLASSIFICATIONS_TEXT');
		
		for _, nameTag in ipairs(classificationList) do
			toolTipString = toolTipString .. '[NEWLINE][ICON_BULLET]' .. Locale.Lookup(nameTag)
		end
	end

	-- 增加行业公司效果说明
	if GameInfo.HD_Monopoly_Resource_Categories ~= nil then
		local plot = Map.GetPlotByIndex(unit:GetPlotId());
		if plot ~= nil then
			local resourceHash = plot:GetResourceTypeHash();
			local resource = GameInfo.Resources[resourceHash];
			local player = Players[Game.GetLocalPlayer()];
			if resource ~= nil and player ~= nil and player:GetResources():IsResourceVisible(resourceHash) then
				local corporationStr = {};

				for row in GameInfo.HD_Monopoly_Resource_Categories() do
					if row.ResourceType == resource.ResourceType then
						local categoryInfo = GameInfo.HD_Monopoly_Categories[row.Category];
						if categoryInfo then
							if categoryInfo.CorporationEffect then
								table.insert(corporationStr, '[ICON_BULLET]' .. Locale.Lookup('LOC_RESOURCE_CLASSIFICATION_HD_' .. row.Category .. '_NAME') .. Locale.Lookup('LOC_TOOLTIP_HD_COLON_TEXT') .. Locale.Lookup("LOC_" .. categoryInfo.CorporationEffect .. "_DESCRIPTION"));
							end
						end
					end
				end

				if #corporationStr > 0 then
					local effectStr = '';
					for i, str in ipairs(corporationStr) do
						if i > 1 then effectStr = effectStr .. "[NEWLINE]"; end
						effectStr = effectStr .. str;
					end
					toolTipString = toolTipString .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_HD_CORPORATION_EFFECT_TEXT', effectStr);
				end
			end
		end
	end

	return toolTipString;
end
m_HDUnitCommands.BUILD_BONUS_CORPORATION.GetDisabledToolTipString = function(unit)
	if not unit then return ""; end
	local unitInfo = GameInfo.Units[unit:GetType()];
	if not unitInfo then return ""; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return ""; end
	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return ""; end
	local city = Cities.GetPlotPurchaseCity(plot);
	if not city then return ""; end
	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return ""; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return ""; end

	-- 世界上是否已经建造该公司
	local alreadyBuilt = (Utils.GetGameProperty(GAME_HAS_CORPORATION_TAG .. resourceInfo.ResourceType) or 0);
	if alreadyBuilt > 0 then return Locale.Lookup('LOC_IMPROVEMENT_CORPORATION_GAME_DISABLED', "[ICON_" .. resourceInfo.ResourceType .. "]", resourceInfo.Name); end
	-- 控制资源数量
	local resourceAmount = player:GetResources():GetResourceAmount(resourceId);
	if resourceAmount < BUILD_BONUS_CORPORATION_NEED_RESOURCE_NUM then return Locale.Lookup('LOC_IMPROVEMENT_IC_BONUS_RESOURCE_DISABLED', BUILD_BONUS_CORPORATION_NEED_RESOURCE_NUM, "[ICON_" .. resourceInfo.ResourceType .. "]", resourceInfo.Name); end
	-- 单位剩余建造次数
	local needCharges = 1;
	if unit:GetBuildCharges() < needCharges then return Locale.Lookup('LOC_NO_ENOUGH_CHARGE_DISABLED'); end
	-- 移动力
	if unit:GetMovesRemaining() == 0 then return '[COLOR:Red]' .. Locale.Lookup("LOC_HUD_UNIT_ACTION_PILLAGE_REQUIRES_MOVEMENT") .. '[ENDCOLOR]'; end
	
	return ""
end
m_HDUnitCommands.BUILD_BONUS_CORPORATION.VisibleInUI = true;
m_HDUnitCommands.BUILD_BONUS_CORPORATION.DoNotDelete = true;

function m_HDUnitCommands.BUILD_BONUS_CORPORATION.CanUse(unit)
	if not unit then return false; end
	local canBuild = unit:GetProperty(UNIT_CAN_BUILD_BONUS_CORPORATION_TAG) or 0;
	return canBuild > 0;
end

function m_HDUnitCommands.BUILD_BONUS_CORPORATION.IsVisible(unit)
	if not unit then return false; end

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return false; end
	if plot:GetOwner() ~= unit:GetOwner() then return false; end
	if plot:GetDistrictType() ~= -1 then return false; end
	if plot:IsNationalPark() then return false; end
	if plot:IsNaturalWonder() then return false; end

	local improvementId = plot:GetImprovementType();
	local improvementInfo = GameInfo.Improvements[improvementId];
	if not improvementInfo then return false; end
	if improvementInfo.ImprovementType ~= 'IMPROVEMENT_INDUSTRY_BONUS' then return false; end

	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return false; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return false; end

	return resourceInfo.ResourceClassType == 'RESOURCECLASS_BONUS';
end

function m_HDUnitCommands.BUILD_BONUS_CORPORATION.IsDisabled(unit)
	if not unit then return true; end
	local unitInfo = GameInfo.Units[unit:GetType()];
	if not unitInfo then return true; end
	local playerId = unit:GetOwner();
	local player = Players[playerId];
	if not player then return true; end
	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if not plot then return true; end
	local city = Cities.GetPlotPurchaseCity(plot);
	if not city then return true; end
	local resourceId = plot:GetResourceType();
	if resourceId == -1 then return true; end
	local resourceInfo = GameInfo.Resources[resourceId];
	if not resourceInfo then return true; end

	-- 世界上是否已经建造该公司
	local alreadyBuilt = (Utils.GetGameProperty(GAME_HAS_CORPORATION_TAG .. resourceInfo.ResourceType) or 0);
	if alreadyBuilt > 0 then return true; end
	-- 控制资源数量
	local resourceAmount = player:GetResources():GetResourceAmount(resourceId);
	if resourceAmount < BUILD_BONUS_CORPORATION_NEED_RESOURCE_NUM then return true; end
	-- 单位剩余建造次数
	local needCharges = 1;
	if unit:GetBuildCharges() < needCharges then return true; end
	-- 移动力
	return unit:GetMovesRemaining() == 0;
end