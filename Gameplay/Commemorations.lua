Utils = ExposedMembers.DLHD.Utils;

-- 伟人
local GENERAL_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_GENERAL'].Index;
local ADMIRAL_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ADMIRAL'].Index;
local ENGINEER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ENGINEER'].Index;
local MERCHANT_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MERCHANT'].Index;
local PROPHET_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_PROPHET'].Index;
local SCIENTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_SCIENTIST'].Index;
local WRITER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_WRITER'].Index;
local ARTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ARTIST'].Index;
local MUSICIAN_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MUSICIAN'].Index;
-- 着力点
local COMMEMORATION_SCIENTIFIC_INDEX = GameInfo.CommemorationTypes['COMMEMORATION_SCIENTIFIC'].Index;
local COMMEMORATION_RELIGIOUS_INDEX = GameInfo.CommemorationTypes['COMMEMORATION_RELIGIOUS'].Index;
local COMMEMORATION_HD_TRANSLATION_MOVEMENT_INDEX = GameInfo.CommemorationTypes['COMMEMORATION_HD_TRANSLATION_MOVEMENT'].Index;
local COMMEMORATION_HD_DOMESTIC_ASSART_INDEX = GameInfo.CommemorationTypes['COMMEMORATION_HD_DOMESTIC_ASSART'].Index;
local COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_INDEX = GameInfo.CommemorationTypes['COMMEMORATION_HD_ENLIGHTENED_DESPOTISM'].Index;
local COMMEMORATION_ECONOMIC_INDEX = GameInfo.CommemorationTypes['COMMEMORATION_ECONOMIC'].Index;
local COMMEMORATION_HD_RELIGIOUS_REFORM_INDEX = GameInfo.CommemorationTypes['COMMEMORATION_HD_RELIGIOUS_REFORM'].Index;
local COMMEMORATION_HD_ROMANTICISM_INDEX = GameInfo.CommemorationTypes['COMMEMORATION_HD_ROMANTICISM'].Index;
local COMMEMORATION_HD_SCIENTIFIC_REVOLUTION_INDEX = GameInfo.CommemorationTypes['COMMEMORATION_HD_SCIENTIFIC_REVOLUTION'].Index;
-- 全局参数
local COMMEMORATION_SCIENTIFIC_SCIENTIST_POINTS = GlobalParameters.HD_COMMEMORATION_SCIENTIFIC_SCIENTIST_POINTS or 0
local COMMEMORATION_RELIGIOUS_CONQUER_CITY_GOODY_HUT = GlobalParameters.HD_COMMEMORATION_RELIGIOUS_CONQUER_CITY_GOODY_HUT or 0
local COMMEMORATION_RELIGIOUS_BARBARIAN_CAMP_ERA_SCORE = GlobalParameters.HD_COMMEMORATION_RELIGIOUS_BARBARIAN_CAMP_ERA_SCORE or 0
local COMMEMORATION_RELIGIOUS_CONQUER_CITY_ERA_SCORE = GlobalParameters.HD_COMMEMORATION_RELIGIOUS_CONQUER_CITY_ERA_SCORE or 0
local COMMEMORATION_HD_TRANSLATION_MOVEMENT_GP_ERA_SCORE = GlobalParameters.HD_COMMEMORATION_HD_TRANSLATION_MOVEMENT_GP_ERA_SCORE or 0
local COMMEMORATION_HD_DOMESTIC_ASSART_RESOURCES_ERA_SCORE = GlobalParameters.HD_COMMEMORATION_HD_DOMESTIC_ASSART_RESOURCES_ERA_SCORE or 0
local COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_DISTRICT_ERA_SCORE = GlobalParameters.HD_COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_DISTRICT_ERA_SCORE or 0
local COMMEMORATION_ECONOMIC_GP_ERA_SCORE = GlobalParameters.HD_COMMEMORATION_ECONOMIC_GP_ERA_SCORE or 0
local COMMEMORATION_HD_RELIGIOUS_REFORM_DISTRICT_ERA_SCORE = GlobalParameters.HD_COMMEMORATION_HD_RELIGIOUS_REFORM_DISTRICT_ERA_SCORE or 0
local COMMEMORATION_HD_ROMANTICISM_GW_ERA_SCORE = GlobalParameters.HD_COMMEMORATION_HD_ROMANTICISM_GW_ERA_SCORE or 0
local COMMEMORATION_HD_SCIENTIFIC_REVOLUTION_TECH_ERA_SCORE = GlobalParameters.HD_COMMEMORATION_HD_SCIENTIFIC_REVOLUTION_TECH_ERA_SCORE or 0
-- 大帝 三倍着力点
local TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION = GlobalParameters.HD_TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION or 0

-- 触发尤里卡
function CommemorationTechBoostTriggered(playerId, iBoostedCivic)
  local player = Players[playerId];
  if player == nil then
    return
  end

  -- 自然哲学
  if Utils.PlayerHasCommemoration(playerId, COMMEMORATION_SCIENTIFIC_INDEX) then
    if Utils.PlayerHasHeroicGoldenAge(playerId) or Utils.PlayerHasGoldenAge(playerId) then
      if COMMEMORATION_SCIENTIFIC_SCIENTIST_POINTS > 0 then
        if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
          -- 大帝
          player:GetGreatPeoplePoints():ChangePointsTotal(SCIENTIST_INDEX, COMMEMORATION_SCIENTIFIC_SCIENTIST_POINTS * 3)
        else
          player:GetGreatPeoplePoints():ChangePointsTotal(SCIENTIST_INDEX, COMMEMORATION_SCIENTIFIC_SCIENTIST_POINTS)
        end
      end
    end
  end
end
Events.TechBoostTriggered.Add(CommemorationTechBoostTriggered)

-- 征服城市
function CommemorationCityConquered(newPlayerId, oldPlayerId, newCityId, x, y)
  local player = Players[newPlayerId];
  if player == nil then
    return
  end

  -- 光荣胜利
  if Utils.PlayerHasCommemoration(newPlayerId, COMMEMORATION_RELIGIOUS_INDEX) then
    if Utils.PlayerHasHeroicGoldenAge(newPlayerId) or Utils.PlayerHasGoldenAge(newPlayerId) then
      -- 黄金时代
      if COMMEMORATION_RELIGIOUS_CONQUER_CITY_GOODY_HUT == 1 then
        if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(newPlayerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
          -- 大帝
          GameEvents.GetRandomGoodyHutReward.Call(newPlayerId, "LOC_MOMENT_CATEGORY_RELIGIOUS")
          GameEvents.GetRandomGoodyHutReward.Call(newPlayerId, "LOC_MOMENT_CATEGORY_RELIGIOUS")
          GameEvents.GetRandomGoodyHutReward.Call(newPlayerId, "LOC_MOMENT_CATEGORY_RELIGIOUS")
        else
          GameEvents.GetRandomGoodyHutReward.Call(newPlayerId, "LOC_MOMENT_CATEGORY_RELIGIOUS")
        end
      end
    else
      -- 普通时代
      if COMMEMORATION_RELIGIOUS_CONQUER_CITY_ERA_SCORE > 0 then
        if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(newPlayerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
          Utils.ChangePlayerEraScore(newPlayerId, COMMEMORATION_RELIGIOUS_CONQUER_CITY_ERA_SCORE * 3)
        else
          Utils.ChangePlayerEraScore(newPlayerId, COMMEMORATION_RELIGIOUS_CONQUER_CITY_ERA_SCORE)
        end
      end
    end
  end
end
GameEvents.CityConquered.Add(CommemorationCityConquered)

-- 改良添加
function CommemorationImprovementAddedToMap(x, y, improvementId, ownerId)
  local owner = Players[ownerId]
  if owner ~= nil and owner:IsMajor() then
    local plot = Map.GetPlot(x, y);
    local resource = plot:GetResourceType();
    if resource ~= -1 and Utils.IsResourceVisible(ownerId, plot:GetResourceTypeHash()) then
      -- 筚路蓝缕
      if Utils.PlayerHasCommemoration(ownerId, COMMEMORATION_HD_DOMESTIC_ASSART_INDEX) then
        if not (Utils.PlayerHasHeroicGoldenAge(ownerId) or Utils.PlayerHasGoldenAge(ownerId)) then
          -- 普通时代
          if COMMEMORATION_HD_DOMESTIC_ASSART_RESOURCES_ERA_SCORE > 0 then
            if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(ownerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
              -- 大帝
              Utils.ChangePlayerEraScore(ownerId, COMMEMORATION_HD_DOMESTIC_ASSART_RESOURCES_ERA_SCORE * 3)
            else
              Utils.ChangePlayerEraScore(ownerId, COMMEMORATION_HD_DOMESTIC_ASSART_RESOURCES_ERA_SCORE)
            end
          end
        end
      end
    end
  end
end

-- 摧毁蛮族哨站
function CommemorationClearBarbarianCamp(x, y, playerId)
  -- 光荣胜利
  if Utils.PlayerHasCommemoration(playerId, COMMEMORATION_RELIGIOUS_INDEX) then
    if not (Utils.PlayerHasHeroicGoldenAge(playerId) or Utils.PlayerHasGoldenAge(playerId)) then
      -- 普通时代
      if COMMEMORATION_RELIGIOUS_BARBARIAN_CAMP_ERA_SCORE > 0 then
        if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
          -- 大帝
          Utils.ChangePlayerEraScore(playerId, COMMEMORATION_RELIGIOUS_BARBARIAN_CAMP_ERA_SCORE * 3)
        else
          Utils.ChangePlayerEraScore(playerId, COMMEMORATION_RELIGIOUS_BARBARIAN_CAMP_ERA_SCORE)
        end
      end
    end
  end
end
GameEvents.HDClearBarbarianCamp.Add(CommemorationClearBarbarianCamp)

-- 招募伟人
function CommemorationUnitGreatPersonCreated(playerId, unitId, greatPersonClassId, greatPersonIndividualId)
  local player = Players[playerId];
  if player == nil then
    return
  end

  if greatPersonClassId == SCIENTIST_INDEX or greatPersonClassId == WRITER_INDEX or greatPersonClassId == ARTIST_INDEX or greatPersonClassId == MUSICIAN_INDEX then
    -- 翻译运动
    if Utils.PlayerHasCommemoration(playerId, COMMEMORATION_HD_TRANSLATION_MOVEMENT_INDEX) then
      if not (Utils.PlayerHasHeroicGoldenAge(playerId) or Utils.PlayerHasGoldenAge(playerId)) then
        -- 普通时代
        if COMMEMORATION_HD_TRANSLATION_MOVEMENT_GP_ERA_SCORE > 0 then
          if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
            -- 大帝
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_TRANSLATION_MOVEMENT_GP_ERA_SCORE * 3)
          else
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_TRANSLATION_MOVEMENT_GP_ERA_SCORE)
          end
        end
      end
    end
  end

  if greatPersonClassId == ENGINEER_INDEX or greatPersonClassId == MERCHANT_INDEX then
    -- 工商业本位
    if Utils.PlayerHasCommemoration(playerId, COMMEMORATION_ECONOMIC_INDEX) then
      if not (Utils.PlayerHasHeroicGoldenAge(playerId) or Utils.PlayerHasGoldenAge(playerId)) then
        -- 普通时代
        if COMMEMORATION_ECONOMIC_GP_ERA_SCORE > 0 then
          if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
            -- 大帝
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_ECONOMIC_GP_ERA_SCORE * 3)
          else
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_ECONOMIC_GP_ERA_SCORE)
          end
        end
      end
    end
  end


end
Events.UnitGreatPersonCreated.Add(CommemorationUnitGreatPersonCreated)

-- 建造建筑
function CommemorationBuildingConstructed(playerId, cityId, buildingId, plotId, bOriginalConstruction)
  local player = Players[playerId];
  if player == nil then
    return
  end

  -- 开明专制
  if Utils.PlayerHasCommemoration(playerId, COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_INDEX) then
    if not (Utils.PlayerHasHeroicGoldenAge(playerId) or Utils.PlayerHasGoldenAge(playerId)) then
      -- 普通时代
      local building = GameInfo.Buildings[buildingId];
      if (building.PrereqDistrict == 'DISTRICT_NEIGHBORHOOD' or building.PrereqDistrict == 'DISTRICT_GOVERNMENT' or building.PrereqDistrict == 'DISTRICT_DIPLOMATIC_QUARTER') then
        if COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_DISTRICT_ERA_SCORE > 0 then
          if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
            -- 大帝
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_DISTRICT_ERA_SCORE * 3)
          else
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_DISTRICT_ERA_SCORE)
          end
        end
      end
    end
  end

  -- 宗教改革
  if Utils.PlayerHasCommemoration(playerId, COMMEMORATION_HD_RELIGIOUS_REFORM_INDEX) then
    if not (Utils.PlayerHasHeroicGoldenAge(playerId) or Utils.PlayerHasGoldenAge(playerId)) then
      -- 普通时代
      local building = GameInfo.Buildings[buildingId];
      if building.PrereqDistrict == 'DISTRICT_HOLY_SITE' then
        if COMMEMORATION_HD_RELIGIOUS_REFORM_DISTRICT_ERA_SCORE > 0 then
          if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
            -- 大帝
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_RELIGIOUS_REFORM_DISTRICT_ERA_SCORE * 3)
          else
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_RELIGIOUS_REFORM_DISTRICT_ERA_SCORE)
          end
        end
      end
    end
  end

end
GameEvents.BuildingConstructed.Add(CommemorationBuildingConstructed);

-- 伟人激活
function CommemorationGreatWorkCreated (playerId, unitId, x, y, buildingId, greatWorkIndex)
	local player = Players[playerId];
  if player == nil then
    return
  end

  -- 浪漫主义
  if Utils.PlayerHasCommemoration(playerId, COMMEMORATION_HD_ROMANTICISM_INDEX) then
    if not (Utils.PlayerHasHeroicGoldenAge(playerId) or Utils.PlayerHasGoldenAge(playerId)) then
      -- 普通时代
      local city = CityManager.GetCityAt(x, y);
	    local greatWorkId = Utils.GetGreatWorkTypeFromIndex(playerId, city:GetID(), greatWorkIndex)
      local greatWorkInfo = GameInfo.GreatWorks[greatWorkId];
      if greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_SCULPTURE' or
        greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_PORTRAIT' or
        greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_LANDSCAPE' or
        greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_RELIGIOUS' or
        greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_WRITING' or
        greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_MUSIC'
      then
        if COMMEMORATION_HD_ROMANTICISM_GW_ERA_SCORE > 0 then
          if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
            -- 大帝
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_ROMANTICISM_GW_ERA_SCORE * 3)
          else
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_ROMANTICISM_GW_ERA_SCORE)
          end
        end
      end
    end
  end
end
Events.GreatWorkCreated.Add(CommemorationGreatWorkCreated);

-- 完成科技
function CommemorationResearchCompleted(playerId, techId)
  local player = Players[playerId];
  if player == nil then
    return
  end

  -- 科技革命
  if Utils.PlayerHasCommemoration(playerId, COMMEMORATION_HD_SCIENTIFIC_REVOLUTION_INDEX) then
    if not (Utils.PlayerHasHeroicGoldenAge(playerId) or Utils.PlayerHasGoldenAge(playerId)) then
      -- 普通时代
      local tech = GameInfo.Technologies[techId];
      if tech.EraType == 'ERA_INDUSTRIAL'
         or tech.EraType == 'ERA_MODERN'
         or tech.EraType == 'ERA_ATOMIC'
         or tech.EraType == 'ERA_INFORMATION'
         or tech.EraType == 'ERA_FUTURE' then
        if COMMEMORATION_HD_SCIENTIFIC_REVOLUTION_TECH_ERA_SCORE > 0 then
          if TRAIT_LEADER_SULEIMAN_ALT_TRIPLE_COMMEMORATION == 1 and Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_SULEIMAN_ALT') then
            -- 大帝
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_SCIENTIFIC_REVOLUTION_TECH_ERA_SCORE * 3)
          else
            Utils.ChangePlayerEraScore(playerId, COMMEMORATION_HD_SCIENTIFIC_REVOLUTION_TECH_ERA_SCORE)
          end
        end
      end
    end
  end
end
Events.ResearchCompleted.Add(CommemorationResearchCompleted);

-- 神级ai保底时代分
local AI_TURN_END_ERA_SCORE = GlobalParameters.HD_AI_TURN_END_ERA_SCORE or 0;
local AI_DISTRICT_ERA_SCORE = GlobalParameters.HD_AI_DISTRICT_ERA_SCORE or 0;
local DEITY_HASH = GameInfo.Difficulties['DIFFICULTY_DEITY'].Hash;
function OnGameTurnEndedAddEraScore()
  if Utils.GetGameDifficulty() ~= DEITY_HASH then return; end
  local era = Game.GetEras():GetCurrentEra();
  if era == 0 then return; end
	for _, playerId in ipairs(PlayerManager.GetAliveMajorIDs()) do
    if Utils.PlayerIsAI(playerId) then
      print("AI 回合结束 获得保底时代分")
      Utils.ChangePlayerEraScore(playerId, AI_TURN_END_ERA_SCORE)
    end
	end
end
GameEvents.OnGameTurnEnded.Add(OnGameTurnEndedAddEraScore)

function OnDistrictConstructedAddEraScore(playerId, districtId, x, y)
  if Utils.GetGameDifficulty() ~= DEITY_HASH then return; end
  local era = Game.GetEras():GetCurrentEra();
  if era == 0 then return; end
  local player = Players[playerId];
  if player:IsMajor() and Utils.PlayerIsAI(playerId) then
    print("AI 建造区域 获得保底时代分")
    Utils.ChangePlayerEraScore(playerId, AI_DISTRICT_ERA_SCORE)
  end
end
GameEvents.OnDistrictConstructed.Add(OnDistrictConstructedAddEraScore)
--------------------------------------------------------------
-- Initialize
function initialize()
  Events.ImprovementAddedToMap.Add(CommemorationImprovementAddedToMap);
end
Events.LoadGameViewStateDone.Add(initialize);