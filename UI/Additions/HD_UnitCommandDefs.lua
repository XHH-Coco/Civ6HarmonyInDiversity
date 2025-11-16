
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

local COAST_INDEX = GameInfo.Terrains['TERRAIN_COAST'].Index;
local OCEAN_INDEX = GameInfo.Terrains['TERRAIN_OCEAN'].Index;
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
-- 婆罗浮屠
-- ======================================================================================================================================================
local BOROBUDUR_INFO = GameInfo.Buildings['BUILDING_BOROBUDUR'];
local VOLCANIC_SOIL_INDEX = GameInfo.Features['FEATURE_VOLCANIC_SOIL'].Index
local BOROBUDUR_EXCAVATE_TIMES_TAG = 'HD_BOROBUDUR_EXCAVATE_TIMES';
local BOROBUDUR_EXCAVATE_MAX_TIMES = GlobalParameters.HD_BOROBUDUR_EXCAVATE_MAX_TIMES or 0;

m_HDUnitCommands.BOROBUDUR = {};
m_HDUnitCommands.BOROBUDUR.Properties = {};

m_HDUnitCommands.BOROBUDUR.EventName = "HD_Borobudur_Excavate";
m_HDUnitCommands.BOROBUDUR.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.BOROBUDUR.Icon = "ICON_UNITCOMMAND_BOROBUDUR_EXCAVATE";
m_HDUnitCommands.BOROBUDUR.ToolTipString = Locale.Lookup("LOC_UNITCOMMAND_BOROBUDUR_EXCAVATE_NAME") .. "[NEWLINE][NEWLINE]" .. Locale.Lookup("LOC_UNITCOMMAND_BOROBUDUR_EXCAVATE_DESCRIPTION");
m_HDUnitCommands.BOROBUDUR.GetDisabledToolTipString = function (unit)
	if unit == nil then
		return '';
	end
	if unit:GetMovesRemaining() == 0 then
		return '[COLOR_RED]' .. Locale.Lookup("LOC_HUD_UNIT_ACTION_PILLAGE_REQUIRES_MOVEMENT") .. '[ENDCOLOR]';
	end

	local plotId = unit:GetPlotId();
	local plot = Map.GetPlotByIndex(plotId);
	local times = plot:GetProperty(BOROBUDUR_EXCAVATE_TIMES_TAG) or 0

	if VOLCANIC_SOIL_INDEX ~= plot:GetFeatureType() then
		return Locale.Lookup("LOC_UNITCOMMAND_BOROBUDUR_EXCAVATE_DISABLED")
	end

	if plot:GetDistrictType() ~= -1 then
		return Locale.Lookup("LOC_UNITCOMMAND_BOROBUDUR_EXCAVATE_DISABLED")
	end

	-- if plot:GetImprovementType() ~= -1 then
	-- 	return Locale.Lookup("LOC_UNITCOMMAND_BOROBUDUR_EXCAVATE_DISABLED")
	-- end

	if times >= BOROBUDUR_EXCAVATE_MAX_TIMES then
		return Locale.Lookup("LOC_UNITCOMMAND_BOROBUDUR_EXCAVATE_MAX_TIMES")
	end

	return '';
end

m_HDUnitCommands.BOROBUDUR.VisibleInUI = true;
m_HDUnitCommands.BOROBUDUR.DoNotDelete = true;

function m_HDUnitCommands.BOROBUDUR.CanUse(unit: object)
	if unit == nil then
		return false;
	end
	local unitInfo = GameInfo.Units[unit:GetType()];
	return unitInfo.UnitType == "UNIT_SAPPER"
			or unitInfo.UnitType == "UNIT_MILITARY_ENGINEER"
			or unitInfo.UnitType == "UNIT_ENGINEER_CORP";
end

function m_HDUnitCommands.BOROBUDUR.IsVisible(unit: object)
	local ownerId = unit:GetOwner();
	local owner = Players[ownerId];
	return BOROBUDUR_INFO ~= nil and Utils.PlayerHasWonder(owner, BOROBUDUR_INFO.Index);
end

function m_HDUnitCommands.BOROBUDUR.IsDisabled(unit: object)
	if unit == nil then
		return true;
	end
	if unit:GetMovesRemaining() == 0 then
		return true;
	end

	local plotId = unit:GetPlotId();
	local plot = Map.GetPlotByIndex(plotId);
	local times = plot:GetProperty(BOROBUDUR_EXCAVATE_TIMES_TAG) or 0

	return VOLCANIC_SOIL_INDEX ~= plot:GetFeatureType()
			or plot:GetDistrictType() ~= -1
			-- or plot:GetImprovementType() ~= -1
			or times >= BOROBUDUR_EXCAVATE_MAX_TIMES;
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
-- 黄金七城
-- ======================================================================================================================================================
m_HDUnitCommands.SPAIN_EL_DORADO_HD = {};
m_HDUnitCommands.SPAIN_EL_DORADO_HD.Properties = {};

m_HDUnitCommands.SPAIN_EL_DORADO_HD.EventName = "HD_SPAIN_EL_DORADO";
m_HDUnitCommands.SPAIN_EL_DORADO_HD.CategoryInUI = "SPECIFIC";
m_HDUnitCommands.SPAIN_EL_DORADO_HD.Icon = "ICON_UNITCOMMAND_SPAIN_EL_DORADO_HD";
m_HDUnitCommands.SPAIN_EL_DORADO_HD.VisibleInUI = true;
m_HDUnitCommands.SPAIN_EL_DORADO_HD.DoNotDelete = true;

m_HDUnitCommands.SPAIN_EL_DORADO_HD.GetToolTipString = function(unit)
	local text = Locale.Lookup("LOC_SPAIN_EL_DORADO_HD_TEXT");

	local ownerId = unit:GetOwner();
	local owner = Players[ownerId];
	local list = owner:GetProperty(SPAIN_NATURAL_WONDER_REVEALED_LIST_TAG) or {};
	if #list > 0 then
		text = text .. Locale.Lookup("LOC_SPAIN_EL_DORADO_HD_LIST");
		for i, featureId in ipairs(list) do
			local featureInfo = GameInfo.Features[featureId];

			if featureInfo then
				if i > 1 then
					text = text .. Locale.Lookup("LOC_TOOLTIP_HD_COMMA_TEXT");
				end
				text = text .. Locale.Lookup(featureInfo.Name);
			end
		end
	end

	return text;
end

m_HDUnitCommands.SPAIN_EL_DORADO_HD.GetDisabledToolTipString = function(unit)
  if unit == nil then return ""; end
  return Locale.Lookup("LOC_SPAIN_EL_DORADO_HD_DISABLED");
end

function m_HDUnitCommands.SPAIN_EL_DORADO_HD.CanUse(unit)
  if unit == nil then return false; end

	-- 判断文明特质
	local ownerId = unit:GetOwner();
	if not Utils.CivilizationHasTrait(ownerId, 'TRAIT_CIVILIZATION_TREASURE_FLEET') then
		return false;
	end

	-- 判断军事单位
	local unitInfo = GameInfo.Units[unit:GetType()];
	if unitInfo then
		local formationClass = unitInfo.FormationClass;
		if (formationClass == 'FORMATION_CLASS_LAND_COMBAT' or formationClass == 'FORMATION_CLASS_NAVAL' or formationClass == 'FORMATION_CLASS_AIR') then
			return true;
		end
	end

	return false;
end

function m_HDUnitCommands.SPAIN_EL_DORADO_HD.IsDisabled(unit)
	if unit == nil then return true; end

	-- 判断移动力
	if unit:GetMovesRemaining() == 0 then return true; end

	-- 判断相邻或位于奇观
	local enabled = false;
	local ownerId = unit:GetOwner();
	local owner = Players[ownerId];
	local plots = Map.GetNeighborPlots(unit:GetX(), unit:GetY(), 1);
	for _, plot in ipairs(plots) do
		if plot and plot:IsNaturalWonder() then
			-- 判断是否探索过
			local featureId = plot:GetFeatureType();
			if featureId and featureId ~= -1 and owner:GetProperty(SPAIN_NATURAL_WONDER_REVEALED_TAG .. featureId) ~= 1 then
				enabled = true;
      	break;
			end
		end
	end

	return not enabled;
end