ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- 建造区域类尤里卡/鼓舞
local CITY_CENTER_INDEX = GameInfo.Districts['DISTRICT_CITY_CENTER'].Index;
local WONDER_INDEX = GameInfo.Districts['DISTRICT_WONDER'].Index;

local EVOLUTION_THEORY_INDEX = GameInfo.Civics['CIVIC_EVOLUTION_THEORY_HD'].Index;
local REFRIGERATION_INDEX = GameInfo.Technologies['TECH_REFRIGERATION_HD'].Index;
local URBAN_DESIGN_INDEX = GameInfo.Civics['CIVIC_URBAN_DESIGN_HD'].Index;
local URBAN_DESIGN_TAG = "HD_URBAN_DESIGN"
local PROFESSIONAL_SPORTS_INDEX = GameInfo.Civics['CIVIC_PROFESSIONAL_SPORTS'].Index;
local PROFESSIONAL_SPORTS_TAG = "HD_PROFESSIONAL_SPORTS"
function OnDistrictConstructedBoost(playerId, districtId, x, y)
  local player = Players[playerId]
  if player ~= nil then
    local plot = Map.GetPlot(x, y)
    local districtType = plot:GetDistrictType()
    -- 演化论
    if not player:GetCulture():HasBoostBeenTriggered(EVOLUTION_THEORY_INDEX) then
      if Utils.IsDistrictType(districtType, 'DISTRICT_CAMPUS') then
        local iDistrictContinent = plot:GetContinentType()
        local iCapital = player:GetCities():GetCapitalCity()
        local iCapitalPlot = Map.GetPlot(iCapital:GetX(), iCapital:GetY())
        local iCapitalContinent = iCapitalPlot:GetContinentType()
        if (iDistrictContinent ~= nil and iCapitalContinent ~= nil and iDistrictContinent ~= iCapitalContinent) then
          player:GetCulture():TriggerBoost(EVOLUTION_THEORY_INDEX);
        end
      end
    end

    -- 制冷科技
    if not player:GetTechs():HasBoostBeenTriggered(REFRIGERATION_INDEX) then
      if Utils.IsDistrictType(districtType, 'DISTRICT_NEIGHBORHOOD') then
        local terrainId = plot:GetTerrainType()
        if terrainId ~= nil and terrainId ~= -1 then
          local terrain = GameInfo.Terrains[terrainId]
          if terrain.TerrainType == 'TERRAIN_DESERT' or terrain.TerrainType == 'TERRAIN_DESERT_HILLS' then
            player:GetTechs():TriggerBoost(REFRIGERATION_INDEX);
          else
            for direction = 0, 5 do
              local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
              if adjacentPlot then
                local featureId = adjacentPlot:GetFeatureType()
                if featureId ~= nil and featureId ~= -1 then
                  local feature = GameInfo.Features[featureId]
                  if feature.FeatureType == 'FEATURE_JUNGLE' then
                    player:GetTechs():TriggerBoost(REFRIGERATION_INDEX);
                    break;
                  end
                end
              end
            end
          end
        end
      end
    end

    -- 城市设计
    if districtType ~= CITY_CENTER_INDEX and districtType ~= WONDER_INDEX then
      if not player:GetCulture():HasBoostBeenTriggered(URBAN_DESIGN_INDEX) then
        local plot = Map.GetPlot(x, y)
        local city = Cities.GetPlotPurchaseCity(plot);
        local amount = city:GetProperty(URBAN_DESIGN_TAG) or 0;
        print('OnDistrictConstructedBoost', amount, districtType)
        amount = amount + 1;
        if amount == 10 then
          player:GetCulture():TriggerBoost(URBAN_DESIGN_INDEX);
        else
          city:SetProperty(URBAN_DESIGN_TAG, amount)
        end
      end
    end

    -- 职业体育
    if not player:GetCulture():HasBoostBeenTriggered(PROFESSIONAL_SPORTS_INDEX) then
      if Utils.IsDistrictType(districtType, 'DISTRICT_ENTERTAINMENT_COMPLEX')
      or Utils.IsDistrictType(districtType, 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX') then
        local amount = player:GetProperty(PROFESSIONAL_SPORTS_TAG) or 0;
        amount = amount + 1;
        if amount == 4 then
          player:GetCulture():TriggerBoost(PROFESSIONAL_SPORTS_INDEX);
        else
          player:SetProperty(PROFESSIONAL_SPORTS_TAG, amount)
        end
      end
    end
    
  end
end
GameEvents.OnDistrictConstructed.Add(OnDistrictConstructedBoost)

-- 未来市政
local MOON_LANDING_INDEX = GameInfo.Projects['PROJECT_LAUNCH_MOON_LANDING'].Index;
function MoonLandingBoost(playerId, cityId, projectId)
	if projectId ~= MOON_LANDING_INDEX then
		return;
	end
  local player = Players[playerId];
	local playerCulture = player:GetCulture();
	-- local boostPercent = 0;
	-- for row in GameInfo.ModifierArguments() do
	-- 	if (row.ModifierId == 'LAUNCH_MOON_LANDING_CIVIC_BOOST_PRECENTAGE') and (row.Name == 'Amount') then
	-- 		boostPercent = row.Value;
	-- 	end
	-- end
	-- print(boostPercent);
	for row in GameInfo.Civics() do
		if row.EraType == 'ERA_FUTURE'
    and not playerCulture:HasCivic(row.Index)
    and not playerCulture:HasBoostBeenTriggered(row.Index) then
			-- if playerCulture:HasBoostBeenTriggered(row.Index) then
			-- 	local progress = Utils.GetCulturalProgress(playerId, row.Index);
			-- 	local cost = playerCulture:GetCultureCost(row.Index);
			-- 	playerCulture:SetCulturalProgress(row.Index, progress + cost * boostPercent / 100);
			-- else
			-- 	if row.EraType == 'ERA_FUTURE' then
			-- 		player:GetCulture():TriggerBoost(row.Index);
			-- 	end
			-- end
      playerCulture:TriggerBoost(row.Index);
		end
	end
end

Events.CityProjectCompleted.Add(MoonLandingBoost);

-- 建造建筑类尤里卡/鼓舞
local TELECOMMUNICATIONS_INDEX = GameInfo.Technologies['TECH_TELECOMMUNICATIONS'].Index;
local TELECOMMUNICATIONS_BOOST_TAG = 'HD_TelecommunicationsBoost'
local COMPASS_INDEX = GameInfo.Technologies['TECH_COMPASS_HD'].Index;
local HUMAN_RIGHTS_INDEX = GameInfo.Civics['CIVIC_HUMAN_RIGHTS_HD'].Index;
local POLICE_SYSTEM_INDEX = GameInfo.Civics['CIVIC_POLICE_SYSTEM_HD'].Index;
local POLICE_SYSTEM_BOOST_TAG = 'HD_PoliceSystemBoost'
local FINANCE_INDEX = GameInfo.Civics['CIVIC_FINANCE_HD'].Index;
local FINANCE_BOOST_TAG = 'HD_FinanceBoost'
local BUILDING_SHOPPING_MALL = GameInfo.Buildings['BUILDING_SHOPPING_MALL'];
local BUILDING_JNR_GRAND_HOTEL = GameInfo.Buildings['BUILDING_JNR_GRAND_HOTEL'];
local ENVIRONMENTALISM_INDEX = GameInfo.Civics['CIVIC_ENVIRONMENTALISM'].Index;
local DISTRICT_PRESERVE = GameInfo.Districts['DISTRICT_PRESERVE'];
local CLASS_STRUGGLE_INDEX = GameInfo.Civics['CIVIC_CLASS_STRUGGLE'].Index;
local CLASS_STRUGGLE_BOOST_TAG = 'HD_ClassStruggleBoost'
local BIOLOGY_INDEX = GameInfo.Technologies['TECH_BIOLOGY_HD'].Index;
local STEEL_INDEX = GameInfo.Technologies['TECH_STEEL'].Index;
local STEEL_BOOST_TAG_FACTORY = 'HD_SteelBoost_Factory'
local STEEL_BOOST_TAG_COAL = 'HD_SteelBoost_Coal'
local TEXTILE_HD_INDEX = GameInfo.Technologies['TECH_TEXTILE_HD'].Index;
function BuildingConstructedBoost(playerId, cityId, buildingId, plotId, bOriginalConstruction)
	local player = Players[playerId];
	local building = GameInfo.Buildings[buildingId];
  
  -- 纺织
  if (building.BuildingType == 'BUILDING_JNR_WAYSTATION') then
    if not player:GetTechs():HasBoostBeenTriggered(TEXTILE_HD_INDEX) then
      player:GetTechs():TriggerBoost(TEXTILE_HD_INDEX);
    end
  end

  -- 现代通讯设备
	if (building.BuildingType == 'BUILDING_BROADCAST_CENTER'
      or building.BuildingType == 'BUILDING_FILM_STUDIO'
      or building.BuildingType == 'BUILDING_JNR_MEDIA_CENTER') then
    if player:GetProperty(TELECOMMUNICATIONS_BOOST_TAG) ~= 1 then
      player:SetProperty(TELECOMMUNICATIONS_BOOST_TAG, 1)
    else
      if not player:GetTechs():HasBoostBeenTriggered(TELECOMMUNICATIONS_INDEX) then
        player:GetTechs():TriggerBoost(TELECOMMUNICATIONS_INDEX);
      end
    end
	end

  -- 罗盘
  if (building.BuildingType == 'BUILDING_LIGHTHOUSE'
      or building.BuildingType == 'BUILDING_JNR_LIGHTHOUSE_FISHING') then
    if not player:GetTechs():HasBoostBeenTriggered(COMPASS_INDEX) then
      player:GetTechs():TriggerBoost(COMPASS_INDEX);
    end
  end

  -- 人权
  if (building.BuildingType == 'BUILDING_BANK'
      or building.BuildingType == 'BUILDING_GRAND_BAZAAR'
      or building.BuildingType == 'BUILDING_JNR_GUILDHALL'
      or building.BuildingType == 'BUILDING_JNR_MERCHANT_QUARTER') then
    if not player:GetCulture():HasBoostBeenTriggered(HUMAN_RIGHTS_INDEX) then
      local city = CityManager.GetCity(playerId, cityId);
      local cityReligion = city:GetReligion():GetMajorityReligion();
      if cityReligion ~= -1 then
        player:GetCulture():TriggerBoost(HUMAN_RIGHTS_INDEX);
      end
    end
  end

  -- 警察制度
  if not player:GetCulture():HasBoostBeenTriggered(POLICE_SYSTEM_INDEX) then
    if (building.BuildingType == 'BUILDING_HD_VILLA'
      or building.BuildingType == 'BUILDING_HD_MANSION') then
      local num = player:GetProperty(POLICE_SYSTEM_BOOST_TAG) or 0;
      num = num + 1;
      if num == 3 then
        player:GetCulture():TriggerBoost(POLICE_SYSTEM_INDEX);
      else
        player:SetProperty(POLICE_SYSTEM_BOOST_TAG, num)
      end
    end
  end

  -- 金融学
  if BUILDING_JNR_GRAND_HOTEL ~= nil then
    if not player:GetCulture():HasBoostBeenTriggered(FINANCE_INDEX) then
      if (building.BuildingType == 'BUILDING_SHOPPING_MALL') then
        if Utils.HasBuildingWithinCountry(playerId, BUILDING_JNR_GRAND_HOTEL.Index) then
          player:GetCulture():TriggerBoost(FINANCE_INDEX);
        end
      end
  
      if (building.BuildingType == 'BUILDING_JNR_GRAND_HOTEL') then
        if Utils.HasBuildingWithinCountry(playerId, BUILDING_SHOPPING_MALL.Index) then
          player:GetCulture():TriggerBoost(FINANCE_INDEX);
        end
      end
    end
  end

  -- 环境保护主义
  if DISTRICT_PRESERVE ~= nil then
    if (building.BuildingType == 'BUILDING_HD_LANDFORM_EPO'
        or building.BuildingType == 'BUILDING_HD_RESOURCE_EPO'
        or building.BuildingType == 'BUILDING_HD_SPECIES_EPO'
        or building.BuildingType == 'BUILDING_HD_SCENIC_EPO') then
      if not player:GetCulture():HasBoostBeenTriggered(ENVIRONMENTALISM_INDEX) then
        player:GetCulture():TriggerBoost(ENVIRONMENTALISM_INDEX);
      end
    end
  end

  -- 阶级斗争
  if (building.BuildingType == 'BUILDING_FACTORY'
      or building.BuildingType == 'BUILDING_HD_ELECTRONICS_FACTORY'
      or building.BuildingType == 'BUILDING_JNR_CHEMICAL')
      and GlobalParameters.HD_CLASS_STRUGGLE_BOOST_WAREHOUSE ~= 1
    then
    if player:GetProperty(CLASS_STRUGGLE_BOOST_TAG) == nil then
      player:SetProperty(CLASS_STRUGGLE_BOOST_TAG, 1)
    elseif player:GetProperty(CLASS_STRUGGLE_BOOST_TAG) < 3 then
      local num = player:GetProperty(CLASS_STRUGGLE_BOOST_TAG)
      player:SetProperty(CLASS_STRUGGLE_BOOST_TAG, num + 1)
    end

    if (player:GetProperty(CLASS_STRUGGLE_BOOST_TAG) ~= nil
        and player:GetProperty(CLASS_STRUGGLE_BOOST_TAG) >= 3) then
      if not player:GetCulture():HasBoostBeenTriggered(CLASS_STRUGGLE_INDEX) then
        player:GetCulture():TriggerBoost(CLASS_STRUGGLE_INDEX);
      end
    end
	end

  -- 生物
  if (building.BuildingType == 'BUILDING_JNR_BOTANICAL_GARDEN') then
    if not player:GetTechs():HasBoostBeenTriggered(BIOLOGY_INDEX) then
      player:GetTechs():TriggerBoost(BIOLOGY_INDEX);
    end
  end

  -- 钢铁
  if building.BuildingType == 'BUILDING_FACTORY' then
    if player:GetProperty(STEEL_BOOST_TAG_COAL) == 1 then
      if not player:GetTechs():HasBoostBeenTriggered(STEEL_INDEX) then
        player:GetTechs():TriggerBoost(STEEL_INDEX);
      end
    else
      player:SetProperty(STEEL_BOOST_TAG_FACTORY, 1)
    end
  end
end
GameEvents.BuildingConstructed.Add(BuildingConstructedBoost);

-- 人权
local BANK = GameInfo.Buildings['BUILDING_BANK'];
local JNR_GUILDHALL = GameInfo.Buildings['BUILDING_JNR_GUILDHALL'];
local JNR_MERCHANT_QUARTER = GameInfo.Buildings['BUILDING_JNR_MERCHANT_QUARTER'];
local GRAND_BAZAAR = GameInfo.Buildings['BUILDING_GRAND_BAZAAR'];
function HumanRightsBoost(playerId, cityId, eVisibility)
  local player = Players[playerId];
  if not player:GetCulture():HasBoostBeenTriggered(HUMAN_RIGHTS_INDEX) then
    local city = CityManager.GetCity(playerId, cityId);
    local cityReligion = city:GetReligion():GetMajorityReligion();
    if cityReligion ~= -1 then
      if (city:GetBuildings():HasBuilding(BANK.Index)
          or (GRAND_BAZAAR ~= nil and city:GetBuildings():HasBuilding(GRAND_BAZAAR.Index))
          or (JNR_GUILDHALL ~= nil and city:GetBuildings():HasBuilding(JNR_GUILDHALL.Index))
          or (JNR_MERCHANT_QUARTER ~= nil and city:GetBuildings():HasBuilding(JNR_MERCHANT_QUARTER.Index))) then
        player:GetCulture():TriggerBoost(HUMAN_RIGHTS_INDEX);
      end
    end
  end
end
Events.CityReligionFollowersChanged.Add(HumanRightsBoost);

-- 建造改良类
local OCEANOGRAPHY_INDEX = GameInfo.Technologies['TECH_OCEANOGRAPHY_HD'].Index;
local FISHERY_INDEX = GameInfo.Improvements['IMPROVEMENT_FISHERY'].Index;
local MINE_INDEX = GameInfo.Improvements['IMPROVEMENT_MINE'].Index;
local COAL_INDEX = GameInfo.Resources['RESOURCE_COAL'].Index;
local HORSEBACK_RIDING_INDEX = GameInfo.Technologies['TECH_HORSEBACK_RIDING'].Index;
local PASTURE_INDEX = GameInfo.Improvements['IMPROVEMENT_PASTURE'].Index;
local HEAVENLY_HORSE_INDEX = GameInfo.Resources['RESOURCE_C_HEAVENLY_HORSE'].Index;
function ImprovementAddedToMapBoost(x, y, improvementId, playerId, resourceId, isPillaged, isWorked)
  -- 海洋学
  if improvementId == FISHERY_INDEX then
    local player = Players[playerId]
    if not player:GetTechs():HasBoostBeenTriggered(OCEANOGRAPHY_INDEX) then
      local plot = Map.GetPlot(x, y)
      local ownerId = plot:GetOwner()
      if playerId == ownerId then
        local featureId = plot:GetFeatureType()
        if featureId ~= nil and featureId ~= -1 then
          player:GetTechs():TriggerBoost(OCEANOGRAPHY_INDEX);
        end
      end
    end
  end

  -- 钢铁
  if improvementId == MINE_INDEX and resourceId == COAL_INDEX then
    local player = Players[playerId]
    if player:GetProperty(STEEL_BOOST_TAG_FACTORY) == 1 then
      if not player:GetTechs():HasBoostBeenTriggered(STEEL_INDEX) then
        player:GetTechs():TriggerBoost(STEEL_INDEX);
      end
    else
      player:SetProperty(STEEL_BOOST_TAG_COAL, 1)
    end
  end

  -- 骑马
  if improvementId == PASTURE_INDEX and resourceId == HEAVENLY_HORSE_INDEX then
    local player = Players[playerId]
    if not player:GetTechs():HasBoostBeenTriggered(HORSEBACK_RIDING_INDEX) then
      player:GetTechs():TriggerBoost(HORSEBACK_RIDING_INDEX);
    end
  end
end

-- 履带
local CATERPILLAR_TRACK_INDEX = GameInfo.Technologies['TECH_CATERPILLAR_TRACK_HD'].Index;
function CaterpillarTrackBoost(playerId, unitId, x, y)
  local player = Players[playerId]
  if not player:GetTechs():HasBoostBeenTriggered(CATERPILLAR_TRACK_INDEX) then
    local unit = UnitManager.GetUnit(playerId, unitId)
    if unit == nil then
      return
    end
    local militaryFormation = unit:GetMilitaryFormation()
    if militaryFormation == MilitaryFormationTypes.CORPS_FORMATION then
      local promotionClass = GameInfo.Units[unit:GetType()].PromotionClass
      if promotionClass == 'PROMOTION_CLASS_LIGHT_CAVALRY' or promotionClass == 'PROMOTION_CLASS_HEAVY_CAVALRY' then
        local plot = Map.GetPlot(x, y)
        local featureId = plot:GetFeatureType()
        if featureId ~= nil and featureId ~= -1 then
          local feature = GameInfo.Features[featureId]
          if feature.FeatureType == 'FEATURE_MARSH' or feature.FeatureType == 'FEATURE_HD_SWAMP' then
            player:GetTechs():TriggerBoost(CATERPILLAR_TRACK_INDEX);
          end
        end
      end
    end
  end
end
Events.UnitMoveComplete.Add(CaterpillarTrackBoost);

-- 招募伟人类尤里卡/鼓舞
local GENERAL_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_GENERAL'].Index;
local ADMIRAL_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ADMIRAL'].Index;
local ENGINEER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ENGINEER'].Index;
local MERCHANT_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MERCHANT'].Index;
local PROPHET_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_PROPHET'].Index;
local SCIENTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_SCIENTIST'].Index;
local WRITER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_WRITER'].Index;
local ARTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ARTIST'].Index;
local MUSICIAN_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MUSICIAN'].Index;

local INDUSTRIAL_AUTOMATION_INDEX = GameInfo.Technologies['TECH_INDUSTRIAL_AUTOMATION_HD'].Index;
local BUILDING_JNR_RECYCLING_PLANT = GameInfo.Buildings['BUILDING_JNR_RECYCLING_PLANT'];
local MODERNISM_INDEX = GameInfo.Civics['CIVIC_MODERNISM_HD'].Index;
local BUILDING_JNR_ART_GALLERY = GameInfo.Buildings['BUILDING_JNR_ART_GALLERY'];
local IDEOLOGY_INDEX = GameInfo.Civics['CIVIC_IDEOLOGY'].Index;
local HIGHER_EDUCATION_INDEX = GameInfo.Civics['CIVIC_HIGHER_EDUCATION_HD'].Index;
local OPERA_BALLET_INDEX = GameInfo.Civics['CIVIC_OPERA_BALLET'].Index;
local SQUARE_RIGGING_INDEX = GameInfo.Technologies['TECH_SQUARE_RIGGING'].Index;
local NAVAL_TRADITION_INDEX = GameInfo.Civics['CIVIC_NAVAL_TRADITION'].Index;
function UnitGreatPersonCreatedBoost(playerId, unitId, greatPersonClassId, greatPersonIndividualId)
  local player = Players[playerId]
  if player:GetProperty('HD_UnitGreatPersonCreated_' .. greatPersonClassId) == nil then
    player:SetProperty('HD_UnitGreatPersonCreated_' .. greatPersonClassId, 1)
  else
    local num = player:GetProperty('HD_UnitGreatPersonCreated_' .. greatPersonClassId)
    player:SetProperty('HD_UnitGreatPersonCreated_' .. greatPersonClassId, num + 1)
  end

  -- 工业自动化
  if BUILDING_JNR_RECYCLING_PLANT == nil then
    if (player:GetProperty('HD_UnitGreatPersonCreated_' .. ENGINEER_INDEX) ~= nil
        and player:GetProperty('HD_UnitGreatPersonCreated_' .. ENGINEER_INDEX) >= 3) then
      if not player:GetTechs():HasBoostBeenTriggered(INDUSTRIAL_AUTOMATION_INDEX) then
        player:GetTechs():TriggerBoost(INDUSTRIAL_AUTOMATION_INDEX);
      end
    end
  end

  -- 现代主义思潮
  if BUILDING_JNR_ART_GALLERY == nil then
    if (player:GetProperty('HD_UnitGreatPersonCreated_' .. WRITER_INDEX) ~= nil
        and player:GetProperty('HD_UnitGreatPersonCreated_' .. WRITER_INDEX) >= 3) then
      if not player:GetCulture():HasBoostBeenTriggered(MODERNISM_INDEX) then
        player:GetCulture():TriggerBoost(MODERNISM_INDEX);
      end
    end
  end

  -- 意识形态
  if (player:GetProperty('HD_UnitGreatPersonCreated_' .. GENERAL_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. GENERAL_INDEX) >= 2
      and player:GetProperty('HD_UnitGreatPersonCreated_' .. ADMIRAL_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. ADMIRAL_INDEX) >= 2
      and player:GetProperty('HD_UnitGreatPersonCreated_' .. ENGINEER_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. ENGINEER_INDEX) >= 2
      and player:GetProperty('HD_UnitGreatPersonCreated_' .. MERCHANT_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. MERCHANT_INDEX) >= 2
      and player:GetProperty('HD_UnitGreatPersonCreated_' .. SCIENTIST_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. SCIENTIST_INDEX) >= 2
      and player:GetProperty('HD_UnitGreatPersonCreated_' .. WRITER_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. WRITER_INDEX) >= 2
      and player:GetProperty('HD_UnitGreatPersonCreated_' .. ARTIST_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. ARTIST_INDEX) >= 2
      and player:GetProperty('HD_UnitGreatPersonCreated_' .. MUSICIAN_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. MUSICIAN_INDEX) >= 2) then
    if not player:GetCulture():HasBoostBeenTriggered(IDEOLOGY_INDEX) then
      player:GetCulture():TriggerBoost(IDEOLOGY_INDEX);
    end
  end

  -- 高等教育
  if (player:GetProperty('HD_UnitGreatPersonCreated_' .. SCIENTIST_INDEX) ~= nil
      and player:GetProperty('HD_UnitGreatPersonCreated_' .. SCIENTIST_INDEX) >= 4) then
    if not player:GetCulture():HasBoostBeenTriggered(HIGHER_EDUCATION_INDEX) then
      player:GetCulture():TriggerBoost(HIGHER_EDUCATION_INDEX);
    end
  end

  -- 歌剧与芭蕾
  if (player:GetProperty('HD_UnitGreatPersonCreated_' .. ARTIST_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. ARTIST_INDEX) >= 1
      and player:GetProperty('HD_UnitGreatPersonCreated_' .. MUSICIAN_INDEX) ~= nil and player:GetProperty('HD_UnitGreatPersonCreated_' .. MUSICIAN_INDEX) >= 1) then
    if not player:GetCulture():HasBoostBeenTriggered(OPERA_BALLET_INDEX) then
      player:GetCulture():TriggerBoost(OPERA_BALLET_INDEX);
    end
  end

  -- 航海仪器
  if greatPersonClassId == SCIENTIST_INDEX then
    if not player:GetTechs():HasBoostBeenTriggered(SQUARE_RIGGING_INDEX) then
      if player:GetCulture():HasCivic(NAVAL_TRADITION_INDEX) then
        player:GetTechs():TriggerBoost(SQUARE_RIGGING_INDEX);
      end
    end
  end
  
end
Events.UnitGreatPersonCreated.Add(UnitGreatPersonCreatedBoost)

-- 建造/购买单位
local EARLY_WARFARE_INDEX = GameInfo.Civics['CIVIC_EARLY_WARFARE_HD'].Index;
local EARLY_WARFARE_BOOST_TAG = 'HD_EarlyWarfareBoost'
local SQUARE_SAIL_INDEX = GameInfo.Technologies['TECH_SQUARE_SAIL_HD'].Index;
local SQUARE_SAIL_BOOST_TAG = 'HD_SquareSailBoost'
function UnitBoost(playerId, cityId, type, objectId, cancelled)
  local player = Players[playerId]

  -- 原始军事
  if not player:GetCulture():HasBoostBeenTriggered(EARLY_WARFARE_INDEX) then
    local unit = GameInfo.Units[objectId]
    if (unit.FormationClass == 'FORMATION_CLASS_LAND_COMBAT'
        or unit.FormationClass == 'FORMATION_CLASS_NAVAL') then
      if player:GetProperty(EARLY_WARFARE_BOOST_TAG) == nil then
        player:SetProperty(EARLY_WARFARE_BOOST_TAG, 1)
      elseif player:GetProperty(EARLY_WARFARE_BOOST_TAG) < 3 then
        local num = player:GetProperty(EARLY_WARFARE_BOOST_TAG)
        player:SetProperty(EARLY_WARFARE_BOOST_TAG, num + 1)
      end
      
      if (player:GetProperty(EARLY_WARFARE_BOOST_TAG) ~= nil
          and player:GetProperty(EARLY_WARFARE_BOOST_TAG) >= 3) then
        player:GetCulture():TriggerBoost(EARLY_WARFARE_INDEX);
      end
    end
  end

  -- 方帆
  if not player:GetTechs():HasBoostBeenTriggered(SQUARE_SAIL_INDEX) then
    local unit = GameInfo.Units[objectId]
    if unit.FormationClass == 'FORMATION_CLASS_NAVAL' then
      if player:GetProperty(SQUARE_SAIL_BOOST_TAG) == nil then
        player:SetProperty(SQUARE_SAIL_BOOST_TAG, 1)
      elseif player:GetProperty(SQUARE_SAIL_BOOST_TAG) < 8 then
        local num = player:GetProperty(SQUARE_SAIL_BOOST_TAG)
        player:SetProperty(SQUARE_SAIL_BOOST_TAG, num + 1)
      end

      if (player:GetProperty(SQUARE_SAIL_BOOST_TAG) ~= nil
          and player:GetProperty(SQUARE_SAIL_BOOST_TAG) >= 8) then
        player:GetTechs():TriggerBoost(SQUARE_SAIL_INDEX);
      end
    end
  end
end

function EarlyWarfareProductionBoost(playerId, cityId, type, objectId, cancelled)
  if type == 0 then
    UnitBoost(playerId, cityId, type, objectId)
  end
end
Events.CityProductionCompleted.Add(EarlyWarfareProductionBoost)
function EarlyWarfarePurchaseBoost(playerId, cityId, x, y, type, objectId)
  if type == EventSubTypes.UNIT then
    UnitBoost(playerId, cityId, type, objectId)
  end
end
Events.CityMadePurchase.Add(EarlyWarfarePurchaseBoost)

-- 丧仪
local FUNERAL_INDEX = GameInfo.Civics['CIVIC_FUNERAL_HD'].Index;
function FuneralBoost(attackerPlayerId, attackerUnitId, defenderPlayerId, defenderUnitId)
  local attackerPlayer = Players[attackerPlayerId]
  if attackerPlayer == nil then
    return
  end
  if not attackerPlayer:GetCulture():HasBoostBeenTriggered(FUNERAL_INDEX) then
    attackerPlayer:GetCulture():TriggerBoost(FUNERAL_INDEX);
  end

  local defenderPlayer = Players[defenderPlayerId]
  if defenderPlayer == nil then
    return
  end
  if not defenderPlayer:GetCulture():HasBoostBeenTriggered(FUNERAL_INDEX) then
    defenderPlayer:GetCulture():TriggerBoost(FUNERAL_INDEX);
  end
end
GameEvents.OnCombatOccurred.Add(FuneralBoost)

-- 人类学
local ANTHROPOLOGY_INDEX = GameInfo.Civics['CIVIC_ANTHROPOLOGY_HD'].Index;
local ANTHROPOLOGY_BOOST_TAG = 'HD_Anthropology'
function AnthropologyGoodyHutBoost(playerId, unitId, iRewardType, iRewardSubType)
  local player = Players[playerId]
  if player == nil then
    return
  end

  if not player:GetCulture():HasBoostBeenTriggered(ANTHROPOLOGY_INDEX) then
    if player:GetProperty(ANTHROPOLOGY_BOOST_TAG) == nil then
      player:SetProperty(ANTHROPOLOGY_BOOST_TAG, 1)
      print('AnthropologyBarbarianBoost', playerId, 1)
    elseif player:GetProperty(ANTHROPOLOGY_BOOST_TAG) < 15 then
      local num = player:GetProperty(ANTHROPOLOGY_BOOST_TAG)
      player:SetProperty(ANTHROPOLOGY_BOOST_TAG, num + 1)
      print('AnthropologyGoodyHutBoost', playerId, num + 1)
    end

    if (player:GetProperty(ANTHROPOLOGY_BOOST_TAG) ~= nil
        and player:GetProperty(ANTHROPOLOGY_BOOST_TAG) >= 15) then
      player:GetCulture():TriggerBoost(ANTHROPOLOGY_INDEX);
    end
  end
end
Events.GoodyHutReward.Add(AnthropologyGoodyHutBoost);

function AnthropologyBarbarianBoost(x, y, playerId)
  local player = Players[playerId]
  if not player:GetCulture():HasBoostBeenTriggered(ANTHROPOLOGY_INDEX) then
    if player:GetProperty(ANTHROPOLOGY_BOOST_TAG) == nil then
      player:SetProperty(ANTHROPOLOGY_BOOST_TAG, 1)
      print('AnthropologyBarbarianBoost', playerId, 1)
    elseif player:GetProperty(ANTHROPOLOGY_BOOST_TAG) < 15 then
      local num = player:GetProperty(ANTHROPOLOGY_BOOST_TAG)
      player:SetProperty(ANTHROPOLOGY_BOOST_TAG, num + 1)
      print('AnthropologyBarbarianBoost', playerId, num + 1)
    end

    if (player:GetProperty(ANTHROPOLOGY_BOOST_TAG) ~= nil
        and player:GetProperty(ANTHROPOLOGY_BOOST_TAG) >= 15) then
      player:GetCulture():TriggerBoost(ANTHROPOLOGY_INDEX);
    end
  end
end
GameEvents.HDClearBarbarianCamp.Add(AnthropologyBarbarianBoost)

-- 现代国防
local SCORCHED_EARTH_INDEX = GameInfo.Civics['CIVIC_SCORCHED_EARTH'].Index;
function ScorchedEarthBoost(iUnitPlayerId, iUnitId, eImprovement, eBuilding, eDistrict, iPlotIndex)
  local plot = Map.GetPlotByIndex(iPlotIndex);
  if plot ~= nil then
    local ownerId = plot:GetOwner()
    if ownerId ~= nil then
      local player = Players[ownerId]
      if player ~= nil then
        if not player:GetCulture():HasBoostBeenTriggered(SCORCHED_EARTH_INDEX) then
          player:GetCulture():TriggerBoost(SCORCHED_EARTH_INDEX);
        end
      end
    end
  end
end
GameEvents.OnPillage.Add(ScorchedEarthBoost);

-- 建立城市类尤里卡/鼓舞
local NATIONALISM_INDEX = GameInfo.Civics['CIVIC_NATIONALISM'].Index;
local NATIONALISM_BOOST_TAG = 'HD_NationalismBoost'
local COLONIALISM_INDEX = GameInfo.Civics['CIVIC_COLONIALISM'].Index;
local COLONIALISM_BOOST_TAG = 'HD_ColonialismBoost'
local SAILING_INDEX = GameInfo.Technologies['TECH_SAILING'].Index;
function NationalismBoost(playerId, cityId, x, y)
  local plot = Map.GetPlot(x, y)
  local newCityContinent = plot:GetContinentType()

  local player = Players[playerId]
  local capital = player:GetCities():GetCapitalCity()
  local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
  local capitalContinent = capitalPlot:GetContinentType()
  -- 民族主义
  if not player:GetCulture():HasBoostBeenTriggered(NATIONALISM_INDEX) then
    if (newCityContinent ~= nil and capitalContinent ~= nil and newCityContinent == capitalContinent) then
      if player:GetProperty(NATIONALISM_BOOST_TAG) == nil then
        player:SetProperty(NATIONALISM_BOOST_TAG, 1)
      elseif player:GetProperty(NATIONALISM_BOOST_TAG) < 4 then
        local num = player:GetProperty(NATIONALISM_BOOST_TAG)
        player:SetProperty(NATIONALISM_BOOST_TAG, num + 1)
      end

      if (player:GetProperty(NATIONALISM_BOOST_TAG) ~= nil
          and player:GetProperty(NATIONALISM_BOOST_TAG) >= 4) then
        player:GetCulture():TriggerBoost(NATIONALISM_INDEX);
      end
    end
  end

  -- 殖民主义
  if not player:GetCulture():HasBoostBeenTriggered(COLONIALISM_INDEX) then
    if (newCityContinent ~= nil and capitalContinent ~= nil and newCityContinent ~= capitalContinent) then
      if player:GetProperty(COLONIALISM_BOOST_TAG) == nil then
        player:SetProperty(COLONIALISM_BOOST_TAG, 1)
      elseif player:GetProperty(COLONIALISM_BOOST_TAG) < 2 then
        local num = player:GetProperty(COLONIALISM_BOOST_TAG)
        player:SetProperty(COLONIALISM_BOOST_TAG, num + 1)
      end

      if (player:GetProperty(COLONIALISM_BOOST_TAG) ~= nil
          and player:GetProperty(COLONIALISM_BOOST_TAG) >= 2) then
        player:GetCulture():TriggerBoost(COLONIALISM_INDEX);
      end
    end
  end

  -- 航行
  if not player:GetTechs():HasBoostBeenTriggered(SAILING_INDEX) then
    for direction = 0, 5 do
      local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
      if adjacentPlot and adjacentPlot:IsLake() then
        player:GetTechs():TriggerBoost(SAILING_INDEX);
        break;
      end
    end
  end
end

-- 新殖民主义
local NEOCOLONIALISM_INDEX = GameInfo.Civics['CIVIC_NEOCOLONIALISM_HD'].Index;
local NEOCOLONIALISM_BOOST_TAG = 'HD_NeocolonialismBoost'
function NeocolonialismBoost(playerId, originPlayerId, originCityId, targetPlayerId, targetCityId)
  local player = Players[playerId]

  if not player:GetCulture():HasBoostBeenTriggered(NEOCOLONIALISM_INDEX) then
    local originCity = CityManager.GetCity(originPlayerId, originCityId);
    if not originCity then return; end
    local originPlot = Map.GetPlot(originCity:GetX(), originCity:GetY());
    local originContinent = originPlot:GetContinentType()

    local targetCity = CityManager.GetCity(targetPlayerId, targetCityId);
    if not targetCity then return; end
    local targetPlot = Map.GetPlot(targetCity:GetX(), targetCity:GetY());
    local targetContinent = targetPlot:GetContinentType()

    if (originContinent ~= nil and targetContinent ~= nil and originContinent ~= targetContinent) then
      if player:GetProperty(NEOCOLONIALISM_BOOST_TAG) == nil then
        player:SetProperty(NEOCOLONIALISM_BOOST_TAG, 1)
      elseif player:GetProperty(NEOCOLONIALISM_BOOST_TAG) < 8 then
        local num = player:GetProperty(NEOCOLONIALISM_BOOST_TAG)
        player:SetProperty(NEOCOLONIALISM_BOOST_TAG, num + 1)
      end

      if (player:GetProperty(NEOCOLONIALISM_BOOST_TAG) ~= nil
          and player:GetProperty(NEOCOLONIALISM_BOOST_TAG) >= 8) then
        player:GetCulture():TriggerBoost(NEOCOLONIALISM_INDEX);
      end
    end
  end
end
Events.TradeRouteActivityChanged.Add(NeocolonialismBoost);

-- 国际联盟
local LEAGUE_OF_NATIONS_INDEX = GameInfo.Civics['CIVIC_LEAGUE_OF_NATIONS_HD'].Index;
function LeagueOfNationsBoost()
  local playerSuzerainRecord = {}
  local alivePlayers = PlayerManager.GetAliveMajorIDs()
	for _, playerId in ipairs(alivePlayers) do
    table.insert(playerSuzerainRecord, {
      playerId = playerId,
      suzerainCount = 0
    })
  end

  local aliveMinorsCount = PlayerManager.GetAliveMinorsCount()
  local aliveMinors = PlayerManager.GetAliveMinors()
  for _, minor in ipairs(aliveMinors) do
    local suzerainId = minor:GetInfluence():GetSuzerain()
    if suzerainId ~= nil and suzerainId ~= -1 then
      for _, row in ipairs(playerSuzerainRecord) do
        if row.playerId == suzerainId then
          row.suzerainCount = row.suzerainCount + 1
        end
      end
    end
  end

  for _, row in ipairs(playerSuzerainRecord) do
    if row.suzerainCount/aliveMinorsCount >= 0.5 then
      local player = Players[row.playerId]
      if not player:GetCulture():HasBoostBeenTriggered(LEAGUE_OF_NATIONS_INDEX) then
        player:GetCulture():TriggerBoost(LEAGUE_OF_NATIONS_INDEX);
      end
    end
  end
end
Events.InfluenceChanged.Add(LeagueOfNationsBoost)

-- 户籍
local HOUSEHOLD_REGISTRATION_INDEX = GameInfo.Civics['CIVIC_HOUSEHOLD_REGISTRATION_HD'].Index;
function HouseholdRegistrationBoost(playerId, cityId)
  local player = Players[playerId]

  if not player:GetCulture():HasBoostBeenTriggered(HOUSEHOLD_REGISTRATION_INDEX) then
    local num = 0
    local cities = player:GetCities();
    if cities ~= nil then
      for _, city in cities:Members() do
        if city:GetPopulation() >= 4 then
          num = num + 1
          if num >= 3 then
            break;
          end
        end
      end
    end

    if num >= 3 then
      player:GetCulture():TriggerBoost(HOUSEHOLD_REGISTRATION_INDEX);
    end
  end
end
GameEvents.OnCityPopulationChanged.Add(HouseholdRegistrationBoost)

-- 探索
local EXPLORATION_INDEX = GameInfo.Civics['CIVIC_EXPLORATION'].Index;
local NOTIFICATION_PRIDE_MOMENT_RECORDED_HASH = GameInfo.Notifications['NOTIFICATION_PRIDE_MOMENT_RECORDED'].Hash
function NotificationAddedBoost(playerId, notificationId)
  local notificationEntry = NotificationManager.Find(playerId, notificationId)
  if notificationEntry and notificationEntry:GetType() == NOTIFICATION_PRIDE_MOMENT_RECORDED_HASH then
    local momentId = notificationEntry:GetValue("MomentID");
    if momentId then
      local momentData = Utils.GetHistoricalMomentData(momentId);
      local momentInfo = momentData and GameInfo.Moments[momentData.Type] or nil
      -- print(Locale.Lookup(momentInfo.Name))
      if momentInfo and (momentInfo.MomentType == 'MOMENT_WORLD_CIRCUMNAVIGATED' or momentInfo.MomentType == 'MOMENT_WORLD_CIRCUMNAVIGATED_FIRST_IN_WORLD') then
        local player = Players[playerId];
        if not player:GetCulture():HasBoostBeenTriggered(EXPLORATION_INDEX) then
          player:GetCulture():TriggerBoost(EXPLORATION_INDEX);
        end
      end
    end
  end
end
Events.NotificationAdded.Add(NotificationAddedBoost);
--------------------------------------------------------------
-- Initialize
function initialize()
  Events.ImprovementAddedToMap.Add(ImprovementAddedToMapBoost);
  Events.CityAddedToMap.Add(NationalismBoost);
end
Events.LoadGameViewStateDone.Add(initialize);