
if ExposedMembers.DLHD == nil then
    ExposedMembers.DLHD = {}
end

Utils = ExposedMembers.DLHD.Utils

function PlayerHasWonder(player, wonderId)
  if player == nil then return false; end
  for _, city in player:GetCities():Members() do
    if city:GetBuildings():HasBuilding(wonderId) then
      return true;
    end
  end
  return false;
end
Utils.PlayerHasWonder = PlayerHasWonder;

-- 通知
local NOTIFICATION_PRIDE_MOMENT_RECORDED_HASH = GameInfo.Notifications['NOTIFICATION_PRIDE_MOMENT_RECORDED'].Hash;

-- 伟人
local WRITER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_WRITER'].Index;
local ARTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ARTIST'].Index;
local MUSICIAN_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MUSICIAN'].Index;
local SCIENTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_SCIENTIST'].Index;
local MERCHANT_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MERCHANT'].Index;
local ENGINEER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ENGINEER'].Index;
local PROPHET_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_PROPHET'].Index;
local ADMIRAL_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ADMIRAL'].Index;
local GENERAL_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_GENERAL'].Index;

-- 布达拉宫
local POTALA_PALACE_INDEX = GameInfo.Buildings['BUILDING_POTALA_PALACE'].Index;
local POTALA_PALACE_CAN_COPY_MAJOR_FOLLOWER_BELIEF_TAG = 'HD_POTALA_PALACE_CAN_COPY_MAJOR_FOLLOWER_BELIEF'
local POTALA_PALACE_COPIED_MAJOR_FOLLOWER_BELIEF_TAG = 'HD_POTALA_PALACE_COPIED_MAJOR_FOLLOWER_BELIEF_'
local POTALA_PALACE_CAN_ADD_EXTRA_BELIEF_TAG = 'HD_POTALA_PALACE_CAN_ADD_EXTRA_BELIEF'
local POTALA_PALACE_EXTRA_BELIEF_ADDED_TAG = 'HD_POTALA_PALACE_EXTRA_BELIEF_ADDED'
function PotalaWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if buildingId == POTALA_PALACE_INDEX then
    local player = Players[playerId];
    local religionId = player:GetReligion():GetReligionTypeCreated();
    if religionId ~= -1 then
      player:SetProperty(POTALA_PALACE_CAN_ADD_EXTRA_BELIEF_TAG, 1)
    else
      if not player:IsBarbarian() then
        local majorReligionId = player:GetReligion():GetReligionInMajorityOfCities()
        if player:GetProperty(POTALA_PALACE_CAN_COPY_MAJOR_FOLLOWER_BELIEF_TAG) ~= 1 and majorReligionId ~= -1 then
          print('布达拉宫 开始复制主流宗教追随者信仰')
          local religions = Game.GetReligion():GetReligions();
          for _, religion in ipairs(religions) do
            -- 查找被复制的追随者信仰
            if religion.Religion == majorReligionId then
              for _, copyBeliefIndex in ipairs(religion.Beliefs) do
                local belief = GameInfo.Beliefs[copyBeliefIndex];
                if belief.BeliefClassType == 'BELIEF_CLASS_FOLLOWER' then
                  local beliefType = belief.BeliefType
                  player:SetProperty(POTALA_PALACE_COPIED_MAJOR_FOLLOWER_BELIEF_TAG .. beliefType, 1)
                  for modifier_row in GameInfo.BeliefModifiers() do
                    if modifier_row.BeliefType == beliefType then
                      local modifierId = modifier_row.ModifierID
                      print('布达拉宫 复制主流宗教追随者信仰', modifierId)
                      player:AttachModifierByID(modifierId .. '_POTALA_PALACE_DOUBLE_FOLLOWER')
                    end
                  end
                end
              end
            end
          end          
          player:SetProperty(POTALA_PALACE_CAN_COPY_MAJOR_FOLLOWER_BELIEF_TAG, 1)
        end
      end
    end
  end
end
Events.WonderCompleted.Add(PotalaWonderCompleted);

function PotalaAddExtraBelief(playerId, param)
  local player = Players[playerId];
  player:SetProperty(POTALA_PALACE_EXTRA_BELIEF_ADDED_TAG, 1)
  local founderBeliefId = param.FounderBelief
  if founderBeliefId ~= nil and founderBeliefId ~= -1 then
    Game.GetReligion():AddBelief(playerId, founderBeliefId)
    print("已添加创始人信仰", Locale.Lookup(GameInfo.Beliefs[founderBeliefId].Name))
  end
  local enhancerBeliefId = param.EnhancerBelief
  if enhancerBeliefId ~= nil and enhancerBeliefId ~= -1 then
    Game.GetReligion():AddBelief(playerId, enhancerBeliefId)
    print("已添加强化信仰", Locale.Lookup(GameInfo.Beliefs[enhancerBeliefId].Name))
  end
end
GameEvents.PotalaAddExtraBelief.Add(PotalaAddExtraBelief);

-- 郑王庙: 招募伟人返还原始点数20%的信仰，每招募一名伟人+2影响力。
local WAT_ARUN = GameInfo.Buildings['BUILDING_SUK_WAT_ARUN'];
function UnitGreatPersonCreatedWatArun(playerId, unitId, greatPersonClassId, greatPersonIndividualId)
	local player = Players[playerId];
  player:AttachModifierByID('WAT_ARUN_INFLUNCE');
end

if WAT_ARUN ~= nil then
  Events.UnitGreatPersonCreated.Add(UnitGreatPersonCreatedWatArun);
end

-- 黄鹤楼: 使用大作家返还点数
local YELLOW_CRANE = GameInfo.Buildings['BUILDING_YELLOW_CRANE_HD'];
local YellowCraneTagX = 'HD_YellowCrane_X'
local YellowCraneTagY = 'HD_YellowCrane_Y'
function YellowCraneWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if YELLOW_CRANE == nil then
    return;
  end
  if buildingId == YELLOW_CRANE.Index then
    Game:SetProperty(YellowCraneTagX, x)
    Game:SetProperty(YellowCraneTagY, y)
  end
end
Events.WonderCompleted.Add(YellowCraneWonderCompleted);

function OnYellowCraneGreatWriterActived(playerID, unitID, greatpersonclassID)
  if YELLOW_CRANE == nil then
    return;
  end
  local pPlayer = Players[playerID];
  local pUnit = pPlayer:GetUnits():FindID(unitID);
  local iYellowCrane = YELLOW_CRANE.Index;
  local tGreatpersonClass = GameInfo.GreatPersonClasses[greatpersonclassID].GreatPersonClassType; 
  if (pPlayer ~= nil) then
    local bHasYC = false;
    for i, pCity in pPlayer:GetCities():Members() do
      if (pCity:GetBuildings():HasBuilding(iYellowCrane)) then
        bHasYC = true;
        break;
      end
    end
    if (bHasYC) then
      if (tGreatpersonClass == "GREAT_PERSON_CLASS_WRITER") then
        local iGreatWriter = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_WRITER"].Index;
        -- local nGPPTotal = pPlayer:GetGreatPeoplePoints():GetPointsTotal(iGreatWriter);
        -- local nGPPGained = nGPPTotal * 0.3;
        local timeline = Game.GetGreatPeople():GetTimeline();
        local cost = 0;
        for i, entry in ipairs(timeline) do
          if entry.Class == iGreatWriter then
            cost = entry.Cost;
          end
        end
        local nGPPGained = math.floor(cost * GlobalParameters.YELLOW_CRANE_TOWER_POINT_PERCENTAGE / 100);
        pPlayer:GetGreatPeoplePoints():ChangePointsTotal(greatpersonclassID, nGPPGained);

        local msg = Locale.Lookup('LOC_BUILDING_YELLOW_CRANE_NAME') .. ": "
        msg = msg .. "+" .. nGPPGained .. " [ICON_GreatWriter]"
        local x = Game:GetProperty(YellowCraneTagX)
        local y = Game:GetProperty(YellowCraneTagY)
        Game.AddWorldViewText(playerID, msg, x, y)
      end
    end
  end
end
Events.UnitGreatPersonActivated.Add(OnYellowCraneGreatWriterActived);

-- 黄鹤楼: 招募大作家触发对应时代鼓舞
local WRITER_INDEX = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_WRITER"].Index;
function YellowCraneUnitGreatPersonCreated(playerId, unitId, greatPersonClassId, greatPersonIndividualId)
	local player = Players[playerId];
  if (greatPersonClassId == WRITER_INDEX) and (PlayerHasWonder (player, YELLOW_CRANE.Index)) then
    local greatPerson = GameInfo.GreatPersonIndividuals[greatPersonIndividualId];
    player:AttachModifierByID('YELLOW_CRANE_WRITER_' .. greatPerson.EraType .. '_BOOST');
  end
end
if YELLOW_CRANE ~= nil then
  Events.UnitGreatPersonCreated.Add(YellowCraneUnitGreatPersonCreated);
end

-- 自由女神像
local STATUE_LIBERTY_INDEX = GameInfo.Buildings['BUILDING_STATUE_LIBERTY'].Index;
local STATUE_LIBERTY_NAVAL_HEAL = GlobalParameters.HD_STATUE_LIBERTY_NAVAL_HEAL or 0;
local STATUE_LIBERTY_NAVAL_FLEET = GlobalParameters.HD_STATUE_LIBERTY_NAVAL_FLEET or 0;
local STATUE_LIBERTY_INFLUENCE_POINT_PERCENTAGE = GlobalParameters.HD_STATUE_LIBERTY_INFLUENCE_POINT_PERCENTAGE or 0;
local STATUE_LIBERTY_POS_X_TAG = 'HD_STATUE_LIBERTY_POS_X';
local STATUE_LIBERTY_POS_Y_TAG = 'HD_STATUE_LIBERTY_POS_Y';
local STATUE_LIBERTY_HARBOR_TAG = 'HD_STATUE_LIBERTY_HARBOR_';
function StatueLibertyWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
	if buildingId == STATUE_LIBERTY_INDEX then
    Game.SetProperty(STATUE_LIBERTY_POS_X_TAG, x)
    Game.SetProperty(STATUE_LIBERTY_POS_Y_TAG, y)
    local player = Players[playerId]

    -- 海军回血 组建舰队
    for _, unit in player:GetUnits():Members() do
      local unitInfo = GameInfo.Units[unit:GetType()]
      local domian = unitInfo.Domain
			local formationClass = unitInfo.FormationClass
			local militaryFormation = unit:GetMilitaryFormation()
      if domian == 'DOMAIN_SEA' and formationClass == 'FORMATION_CLASS_NAVAL' then
        if STATUE_LIBERTY_NAVAL_FLEET > 0 then
          if militaryFormation ~= MilitaryFormationTypes.CORPS_FORMATION and militaryFormation ~= MilitaryFormationTypes.ARMY_FORMATION then
            unit:SetMilitaryFormation(MilitaryFormationTypes.CORPS_FORMATION)
          end
        end
        if STATUE_LIBERTY_NAVAL_HEAL > 0 then
          unit:SetDamage(0)
        end
      end
    end
	end
end
Events.WonderCompleted.Add(StatueLibertyWonderCompleted);

function StatueLibertyOnGameTurnEnded()
  if Game.GetProperty(STATUE_LIBERTY_POS_X_TAG) == nil then
    return;
  end
  local alives = PlayerManager.GetAlive()
  for _, player in ipairs(alives) do
    if PlayerHasWonder(player, STATUE_LIBERTY_INDEX) then
      local amount = 0;
      for _, unit in player:GetUnits():Members() do
        -- 判断是否在城邦境内
        local unitPlot = Map.GetPlot(unit:GetX(), unit:GetY())
        if unitPlot then
          if Utils.PlayerIsMinor(unitPlot:GetOwner()) then
            -- 获取战斗力最大值
            local combat = unit:GetCombat()
            combat = math.max(combat, unit:GetRangedCombat())
            combat = math.max(combat, unit:GetBombardCombat())
            combat = math.max(combat, unit:GetAntiAirCombat())
            amount = amount + combat
            print(unit:GetCombat(), unit:GetRangedCombat(), unit:GetBombardCombat(), unit:GetAntiAirCombat())
          end
        end
      end
      amount = math.floor(amount * STATUE_LIBERTY_INFLUENCE_POINT_PERCENTAGE / 100);
      local plot = Map.GetPlot(Game.GetProperty(STATUE_LIBERTY_POS_X_TAG), Game.GetProperty(STATUE_LIBERTY_POS_Y_TAG))
      Utils.BinaryCompress(amount, plot, 'HD_PLOT_BINARY_COMPRESS_STATUE_LIBERTY')
    end
  end
end
GameEvents.OnGameTurnEnded.Add(StatueLibertyOnGameTurnEnded)

function StatueLibertyDistrictConstructed(playerId, districtType, x, y)
  local player = Players[playerId];
  local plot = Map.GetPlot(x, y);
	if player ~= nil and plot ~= nil and not plot:IsLake() and Utils.IsDistrictType(districtType, 'DISTRICT_HARBOR') then
		-- 获取本格海洋名字
		local seaName = Utils.GetPlotSeaName(x, y);
		if seaName ~= nil and player:GetProperty(STATUE_LIBERTY_HARBOR_TAG .. seaName) ~= 1 then
      player:SetProperty(STATUE_LIBERTY_HARBOR_TAG .. seaName, 1)
      print('自由女神像', seaName)
      player:AttachModifierByID('HD_STATUE_LIBERTY_TRADE_ROUTE_CAPACITY');
    end
	end
end
GameEvents.OnDistrictConstructed.Add(StatueLibertyDistrictConstructed);

-- 宙斯像
local STATUE_OF_ZEUS_DOUBLE_PANTHEON_TAG = 'HD_StatueOfZeusDoublePantheon';
function StatueOfZeusDoublePantheon(playerID, cityID, buildingID, plotID, bOriginalConstruction)
  local m_StatueOfZeus_table = GameInfo.Buildings['BUILDING_STATUE_OF_ZEUS']
  if (m_StatueOfZeus_table ~= nil) then
    local m_StatueOfZeus = m_StatueOfZeus_table.Index
    if playerID >= 0 and buildingID == m_StatueOfZeus then 
      local player = Players[playerID] 
      if not player:IsBarbarian() then
        if player:GetProperty(STATUE_OF_ZEUS_DOUBLE_PANTHEON_TAG) ~= 1 then
          local panthonId = player:GetReligion():GetPantheon()
          for belief_row in GameInfo.Beliefs() do
            if belief_row.Index == panthonId then
              local beliefType = belief_row.BeliefType
              for modifier_row in GameInfo.BeliefModifiers() do
                if modifier_row.BeliefType == beliefType then
                  local modifierId = modifier_row.ModifierID
                  player:AttachModifierByID(modifierId .. '_STATUE_OF_ZEUS_DOUBLE_PANTHEON')
                end
              end
            end
          end
          player:SetProperty(STATUE_OF_ZEUS_DOUBLE_PANTHEON_TAG, 1)
        end
      end
    end
  end
end
GameEvents.BuildingConstructed.Add(StatueOfZeusDoublePantheon)

-- 圣索菲亚大教堂
local HAGIA_SOPHIA_INDEX = GameInfo.Buildings['BUILDING_HAGIA_SOPHIA'].Index;
local HAGIA_SOPHIA_GET_WORSHIP_TAG = 'HD_HagiaSophiaGetWorship_';
function HagiaSophiaGetWorship(playerId, cityId, eVisibility)
  local buildings = {}
  -- 判断是否为圣城
  local isHolyCity = Utils.IsHolyCity(playerId, cityId);
  if isHolyCity then
    -- 获取城市当前宗教
    local city = CityManager.GetCity(playerId, cityId);
    if not city then return; end
    local cityReligion = city:GetReligion():GetMajorityReligion();
    -- 获取该圣城原本的宗教
    local player = Players[playerId];
    local playerReligion = player:GetReligion():GetReligionTypeCreated();
    -- 如果圣城的宗教改变
    if cityReligion ~= playerReligion then
      -- 查询改变后的宗教创建者
      local alivePlayers = PlayerManager.GetAliveMajorIDs()
      for _, alivePlayerId in ipairs(alivePlayers) do
        local alivePlayer = Players[alivePlayerId]
        local alivePlayerReligionFounded = alivePlayer:GetReligion():GetReligionTypeCreated()
        if alivePlayerReligionFounded ~= -1 and alivePlayerReligionFounded == cityReligion and alivePlayerId ~= playerId then
          -- 判断是否有圣索菲亚大教堂
          if Utils.PlayerHasWonder(alivePlayer, HAGIA_SOPHIA_INDEX) then
            local religions = Game.GetReligion():GetReligions();
            for _, religion in ipairs(religions) do
              -- 查找被复制的祭祀建筑
              if (religion.Founder == playerId) then
                for _, copyBeliefIndex in ipairs(religion.Beliefs) do
                  local belief = GameInfo.Beliefs[copyBeliefIndex];
                  if belief.BeliefClassType == 'BELIEF_CLASS_WORSHIP' then
                    for belief_building in GameInfo.HD_WorshipBeliefs_Buildings() do
                      if belief_building.BeliefType == belief.BeliefType then
                        buildings.copyBuilding = belief_building.BuildingType
                      end
                    end
                  end
                end
              end
              -- 查找目标祭祀建筑
              if (religion.Founder == alivePlayerId) then
                for _, targetBeliefIndex in ipairs(religion.Beliefs) do
                  local belief = GameInfo.Beliefs[targetBeliefIndex];
                  if belief.BeliefClassType == 'BELIEF_CLASS_WORSHIP' then
                    for belief_building in GameInfo.HD_WorshipBeliefs_Buildings() do
                      if belief_building.BeliefType == belief.BeliefType then
                        buildings.targetBuilding = belief_building.BuildingType
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      -- 如果两种建筑都存在
      if buildings.copyBuilding ~= nil and buildings.targetBuilding ~= nil and buildings.copyBuilding ~= buildings.targetBuilding then
        -- print('HagiaSophiaGetWorship 被复制的祭祀建筑', buildings.copyBuilding)
        -- print('HagiaSophiaGetWorship 目标祭祀建筑', buildings.targetBuilding)
        -- 取出被复制的祭祀建筑的 Modifiers
        local buildings_modifiers = {}
        for worship_modifier in GameInfo.HD_WorshipModifiers() do
          if worship_modifier.BuildingType == buildings.copyBuilding then
            table.insert(buildings_modifiers, worship_modifier.ModifierId)
          end
        end
        -- 给所有存活的玩家贴 Modifier
        for _, alivePlayerId in ipairs(alivePlayers) do
          local alivePlayer = Players[alivePlayerId]
          if alivePlayer:GetProperty(HAGIA_SOPHIA_GET_WORSHIP_TAG .. buildings.copyBuilding .. '_' .. buildings.targetBuilding) ~= 1 then
            for _, modifierId in ipairs(buildings_modifiers) do
              -- print('HagiaSophiaGetWorship', buildings.copyBuilding .. '_' .. modifierId .. '_ATTACH_TO_' .. buildings.targetBuilding)
              alivePlayer:AttachModifierByID(buildings.copyBuilding .. '_' .. modifierId .. '_ATTACH_TO_' .. buildings.targetBuilding)
            end
            -- SetProperty 防止重复贴
            alivePlayer:SetProperty(HAGIA_SOPHIA_GET_WORSHIP_TAG .. buildings.copyBuilding .. '_' .. buildings.targetBuilding, 1)
          end
        end
      end
    end
  end
end
Events.CityReligionFollowersChanged.Add(HagiaSophiaGetWorship);

--悉尼歌剧院
function SydneyOperaHouseTurnBeginGold(playerId, Tourism)
  local pPlayer = Players[playerId];
	local CapitalCity = pPlayer:GetCities():GetCapitalCity();
  local GoldAmount = Tourism * 0.5;
  pPlayer:GetTreasury():ChangeGoldBalance(GoldAmount);
	Game.AddWorldViewText(playerId, "+" .. GoldAmount .. " [ICON_GOLD]", CapitalCity:GetX(), CapitalCity:GetY());
end

GameEvents.SydneyOperaHouseTurnBeginSwitch.Add(SydneyOperaHouseTurnBeginGold);

--圣母院
local NOTRE_DAME = GameInfo.Buildings['BUILDING_SUK_NOTRE_DAME_DE_PARIS']
function NotreDameCivicBoostTriggered(playerId, iBoostedCivic)
  if not NOTRE_DAME then
    return;
  end
  local player = Players[playerId];

  if not PlayerHasWonder(player, NOTRE_DAME.Index) then
    return;
  end

  local cost = player:GetCulture():GetCultureCost(iBoostedCivic);
  print("圣母院 市政需求", cost)
  local percentage = GlobalParameters.HD_NOTRE_DAME_CIVIC_BOOST_PERCENTAGE or 0;
  local amount = cost * percentage / 100;
  -- player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ARTIST'].Index, amount);
  player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MUSICIAN'].Index, amount);
end

Events.CivicBoostTriggered.Add(NotreDameCivicBoostTriggered);

--百老汇
local WRITER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_WRITER'].Index;
local ARTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ARTIST'].Index;
local MUSICIAN_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MUSICIAN'].Index;
local BROADWAY_INDEX = GameInfo.Buildings['BUILDING_BROADWAY'].Index;

function BroadwayBuildingConstructed(playerID, cityID, buildingID, plotID, bOriginalConstruction)
  local pPlayer = Players[playerID];

  if buildingID ~= BROADWAY_INDEX then
    return;
  end

  local CapitalCity = pPlayer:GetCities():GetCapitalCity();
  local WriterNum = pPlayer:GetProperty('HD_UnitGreatPersonCreated_' .. WRITER_INDEX) or 0;
  local ArtistNum = pPlayer:GetProperty('HD_UnitGreatPersonCreated_' .. ARTIST_INDEX) or 0;
  local MusicianNum = pPlayer:GetProperty('HD_UnitGreatPersonCreated_' .. MUSICIAN_INDEX) or 0;
  local Num = WriterNum + ArtistNum + MusicianNum + 1;
  local pGold = GlobalParameters.HD_BROADWAY_GOLD_PER_GREAT_PERSON or 0;
  local pCulture = GlobalParameters.HD_BROADWAY_CULTURE_PER_GREAT_PERSON or 0;
  local GoldAmount = Num * pGold;
  local CultureAmount = Num * pCulture;

  pPlayer:GetTreasury():ChangeGoldBalance(GoldAmount);
  pPlayer:GetCulture():ChangeCurrentCulturalProgress(CultureAmount);

  Game.AddWorldViewText(playerID, "+" .. GoldAmount .. " [ICON_GOLD]", CapitalCity:GetX(), CapitalCity:GetY());
  Game.AddWorldViewText(playerID, "+" .. CultureAmount .. " [ICON_CULTURE]", CapitalCity:GetX(), CapitalCity:GetY());
end

GameEvents.BuildingConstructed.Add(BroadwayBuildingConstructed)

-- 艾尔米塔什博物馆: 招募大艺术家后，下一个招募的伟人获得等同于该大艺术家消耗的大艺术家点数的15%.
local HermitageIndex = GameInfo.Buildings["BUILDING_HERMITAGE"].Index;
local HermitageTagX = 'HD_Hermitage_X'
local HermitageTagY = 'HD_Hermitage_Y'
function HermitageWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if buildingId == HermitageIndex then
    Game:SetProperty(HermitageTagX, x)
    Game:SetProperty(HermitageTagY, y)
  end
end
Events.WonderCompleted.Add(HermitageWonderCompleted);

function OnhemitageArtistCreated(playerId, unitId, greatPersonClassId, greatPersonIndividualId)
  local pPlayer = Players[playerId];
  local CapitalCity = pPlayer:GetCities():GetCapitalCity();
  local tGreatpersonClass = GameInfo.GreatPersonClasses[greatPersonClassId].GreatPersonClassType; 
  
  if (pPlayer ~= nil) then
    if not PlayerHasWonder(pPlayer, HermitageIndex) then
      return;
    end

    if (tGreatpersonClass == "GREAT_PERSON_CLASS_ARTIST") then
      local iGreatArtist = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_ARTIST"].Index;
      local timeline = Game.GetGreatPeople():GetTimeline();
      local cost = 0;
      for i, entry in ipairs(timeline) do
        if entry.Class == iGreatArtist then
          cost = entry.Cost;
        end
      end
      local nGPPGained = math.floor(cost * GlobalParameters.HD_HERMITAGE_POINT_PERCENTAGE / 100);
      
      for tRow in GameInfo.GreatPersonClasses() do
        if tRow.AvailableInTimeline == true then
          pPlayer:GetGreatPeoplePoints():ChangePointsTotal(tRow.Index, nGPPGained);

          local msg = Locale.Lookup('LOC_BUILDING_HERMITAGE_NAME') .. ": "
          msg = msg .. "+" .. nGPPGained .. " " .. tRow.IconString
          local x = Game:GetProperty(HermitageTagX)
          local y = Game:GetProperty(HermitageTagY)
          Game.AddWorldViewText(playerId, msg, x, y)
        end
      end
    end
  end
end

Events.UnitGreatPersonCreated.Add(OnhemitageArtistCreated);

-- 巴米扬大佛
local BAMYAN_INFO = GameInfo.Buildings['BUILDING_BAMYAN']
local NOTIFICATION_TRADING_POST_CREATED_HASH = GameInfo.Notifications['NOTIFICATION_TRADING_POST_CREATED'].Hash;
local BAMYAN_RELIC_TAG = 'HD_BAMYAN_RELIC_';
local BAMYAN_RELIC_NUM_TAG = 'HD_BAMYAN_RELIC_NUM';
function BamyanNotificationAdded(playerId, notificationId)
  if not BAMYAN_INFO then return; end

  local player = Players[playerId];
  if not player then return; end

  local notificationEntry = NotificationManager.Find(playerId, notificationId)
  if notificationEntry then
    if notificationEntry:GetType() == NOTIFICATION_TRADING_POST_CREATED_HASH then
      local x, y = notificationEntry:GetLocation();
      local city = CityManager.GetCityAt(x, y);
      if not city then return; end

      local ownerId = city:GetOwner();
      local owner = Players[ownerId];
      if ownerId == playerId or not owner or not owner:IsMajor() then return; end

      local religionId = owner:GetReligion():GetReligionTypeCreated();
      if religionId and religionId ~= -1 and player:GetProperty(BAMYAN_RELIC_TAG .. ownerId) ~= 1 then
        player:SetProperty(BAMYAN_RELIC_TAG .. ownerId, 1);

        -- 判断是否有巴米扬大佛
        if PlayerHasWonder(player, BAMYAN_INFO.Index) then
          -- 直接获得遗物
          player:AttachModifierByID('BAMYAN_GRANT_RELIC');
          print("巴米扬大佛送遗物 建立贸易站：" .. Locale.Lookup(city:GetName()));
        else
          -- 计数 等建成后追溯
          local amount = player:GetProperty(BAMYAN_RELIC_NUM_TAG) or 0;
          player:SetProperty(BAMYAN_RELIC_NUM_TAG, amount + 1);
          print("巴米扬大佛未建成 遗物计数：" .. amount + 1 .. " 建立贸易站：" .. Locale.Lookup(city:GetName()));
        end
      end
    end
  end
end
Events.NotificationAdded.Add(BamyanNotificationAdded);

-- 建成巴米扬大佛后追溯遗物
function BamyanWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if BAMYAN_INFO and buildingId == BAMYAN_INFO.Index then
    local player = Players[playerId];
    if not player then return; end

    local amount = player:GetProperty(BAMYAN_RELIC_NUM_TAG) or 0;
    for i=1, amount, 1 do
      player:AttachModifierByID('BAMYAN_GRANT_RELIC');
      print("建成巴米扬大佛后追溯遗物", i);
    end
  end
end
Events.WonderCompleted.Add(BamyanWonderCompleted);

-- 铜雀台
local BronzeBirdInfo = GameInfo.Buildings["BUILDING_PHANTA_BRONZE_BIRD_TERRACE"];
local BronzeBirdTagX = 'HD_BronzeBird_X'
local BronzeBirdTagY = 'HD_BronzeBird_Y'
function BronzeBirdWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if BronzeBirdInfo == nil then
    return;
  end
  if buildingId == BronzeBirdInfo.Index then
    Game:SetProperty(BronzeBirdTagX, x)
    Game:SetProperty(BronzeBirdTagY, y)
  end
end
Events.WonderCompleted.Add(BronzeBirdWonderCompleted);

function BronzeBirdPlayerTurnActivated(playerId, isFirstTime)
  if not isFirstTime or BronzeBirdInfo == nil then
    return;
  end
	local player = Players[playerId];
	if PlayerHasWonder(player, BronzeBirdInfo.Index) then
    local amount = Utils.GetGreatPeoplePointsPerTurn(playerId, GENERAL_INDEX)
    player:GetGreatPeoplePoints():ChangePointsTotal(WRITER_INDEX, amount);

    local msg = Locale.Lookup('LOC_BUILDING_PHANTA_BRONZE_BIRD_TERRACE_NAME') .. ": "
    msg = msg .. "+" .. amount .. " [ICON_GreatWriter]"

    local x = Game:GetProperty(BronzeBirdTagX)
    local y = Game:GetProperty(BronzeBirdTagY)
    Game.AddWorldViewText(playerId, msg, x, y)
	end
end
Events.PlayerTurnActivated.Add(BronzeBirdPlayerTurnActivated);

-- 圣米歇尔山
local MICHEL_INDEX = GameInfo.Buildings['BUILDING_MONT_ST_MICHEL'].Index;
local MICHEL_TAG = 'HD_MICHEL';
local MICHEL_PLAYER_TAG = 'HD_MICHEL_PLAYER';
-- local MICHEL_LIST_TAG = 'HD_MICHEL_LIST';
local MICHEL_GPP_AMOUNT = GlobalParameters.HD_MONT_ST_MICHEL_GPP_AMOUNT or 0
function MichelWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if buildingId ~= MICHEL_INDEX then
    return;
  end
  local player = Players[playerId];
  local playerReligion = player:GetReligion():GetReligionTypeCreated();
  if playerReligion ~= -1 then
    print('MichelWonderCompleted', playerId, playerReligion)
    Game:SetProperty(MICHEL_TAG, playerReligion)
    Game:SetProperty(MICHEL_PLAYER_TAG, playerId)

    -- 标记已经信仰该宗教的城市
    local alives = PlayerManager.GetAlive()
    for _, alivePlayer in ipairs(alives) do
      if not alivePlayer:IsBarbarian() then
        local aliveCities = alivePlayer:GetCities()
        if aliveCities then
          for _, city in aliveCities:Members() do
            local cityReligion = city:GetReligion():GetMajorityReligion();
            if cityReligion == playerReligion then
              print('MichelWonderCompleted ignore city', alivePlayer:GetID(), city:GetID())
              city:SetProperty(MICHEL_TAG, 1);
            end
          end
        end
      end
    end
  end
end
Events.WonderCompleted.Add(MichelWonderCompleted);

function MichelCityReligionFollowersChanged(playerId, cityId, eVisibility)
  local city = CityManager.GetCity(playerId, cityId);
  if not city then return; end

  local cityReligion = city:GetReligion():GetMajorityReligion();
  local michelReligion = Game:GetProperty(MICHEL_TAG) or -1;
  if MICHEL_GPP_AMOUNT ~= 0 and city:GetProperty(MICHEL_TAG) ~= 1 and cityReligion ~= -1 and michelReligion ~= -1 and cityReligion == michelReligion then
    city:SetProperty(MICHEL_TAG, 1)
    local michelPlayerId = Game.GetProperty(MICHEL_PLAYER_TAG)
    local michelPlayer = Players[michelPlayerId];
    if michelPlayer and michelPlayer:IsAlive() then
      -- 随机获得伟人点
      local population = city:GetPopulation()
      local amount = population * MICHEL_GPP_AMOUNT
      local list = Utils.GreatPeopleList;
      local randomIndex = Game.GetRandNum(#list, "Random Michel GPP for Player " .. playerId) + 1
      local greatPersonId = list[randomIndex].Index
      print('MichelCityReligionFollowersChanged', greatPersonId, amount)
      michelPlayer:GetGreatPeoplePoints():ChangePointsTotal(greatPersonId, amount)

      local msg = Locale.Lookup('LOC_BUILDING_MONT_ST_MICHEL_NAME') .. ": "
      msg = msg .. "+" .. amount .. " " .. list[randomIndex].Icon
      Game.AddWorldViewText(playerId, msg, city:GetX(), city:GetY())
    end
  end
end
Events.CityReligionFollowersChanged.Add(MichelCityReligionFollowersChanged);

-- 比萨斜塔
local LEANING_TOWER_SCIENTIST_PERCENTAGE = GlobalParameters.HD_LEANING_TOWER_SCIENTIST_PERCENTAGE or 0;
local LEANING_TOWER_INFO = GameInfo.Buildings['BUILDING_LEANING_TOWER'];
local LeaningTowerTagX = 'HD_LeaningTower_X'
local LeaningTowerTagY = 'HD_LeaningTower_Y'
function LeaningTowerWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if LEANING_TOWER_INFO == nil then
    return;
  end
  if buildingId == LEANING_TOWER_INFO.Index then
    Game:SetProperty(LeaningTowerTagX, x)
    Game:SetProperty(LeaningTowerTagY, y)
  end
end
Events.WonderCompleted.Add(LeaningTowerWonderCompleted);

function LeaningTowerTechBoostTriggered(playerId)
  if LEANING_TOWER_INFO then
    local player = Players[playerId];
    if PlayerHasWonder(player, LEANING_TOWER_INFO.Index) then
      local amount = Utils.GetGreatPeoplePointsPerTurn(playerId, SCIENTIST_INDEX)
      -- local amount = player:GetGreatPeoplePoints():CalculatePointsPerTurn(SCIENTIST_INDEX)
      amount = math.floor(amount * LEANING_TOWER_SCIENTIST_PERCENTAGE / 100);
      player:GetGreatPeoplePoints():ChangePointsTotal(SCIENTIST_INDEX, amount);

      local msg = Locale.Lookup('LOC_BUILDING_LEANING_TOWER_NAME') .. ": "
      msg = msg .. "+" .. amount .. " [ICON_GreatScientist]"
      local x = Game:GetProperty(LeaningTowerTagX)
      local y = Game:GetProperty(LeaningTowerTagY)
      Game.AddWorldViewText(playerId, msg, x, y)
    end
  end
end
Events.TechBoostTriggered.Add(LeaningTowerTechBoostTriggered)

-- 哈利法塔
local KHALIFA_INFO = GameInfo.Buildings['BUILDING_BURJ_KHALIFA'];
local BURJ_KHALIFA_MERCHANT_PERCENTAGE = GlobalParameters.HD_BURJ_KHALIFA_MERCHANT_PERCENTAGE or 0;
local DESERT_INDEX = GameInfo.Terrains['TERRAIN_DESERT'].Index;
local OIL_INDEX = GameInfo.Resources['RESOURCE_OIL'].Index;
local KhalifaTagX = 'HD_Khalifa_X'
local KhalifaTagY = 'HD_Khalifa_Y'
function KhalifaWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if KHALIFA_INFO == nil then
    return;
  end
  if buildingId == KHALIFA_INFO.Index then
    Game:SetProperty(KhalifaTagX, x)
    Game:SetProperty(KhalifaTagY, y)

    local plots = Map.GetNeighborPlots(x, y, 6);
    for _, plot in ipairs(plots) do
      if plot and plot:GetDistrictType() == -1 and plot:GetResourceType() == -1 and plot:GetImprovementType() == -1 and plot:GetTerrainType() == DESERT_INDEX and not plot:IsNaturalWonder() then
        Utils.GenerateResource(plot, OIL_INDEX)
      end
    end
  end
end
Events.WonderCompleted.Add(KhalifaWonderCompleted);

function KhalifaGreatWorkCreated(playerId, unitId, x, y, buildingId, greatWorkIndex)
  if KHALIFA_INFO == nil or Game:GetProperty(KhalifaTagX) == nil then
    return;
  end
  local player = Players[playerId];
  if PlayerHasWonder(player, KHALIFA_INFO.Index) then
    local city = CityManager.GetCityAt(x, y);
    local greatWorkId = Utils.GetGreatWorkTypeFromIndex(playerId, city:GetID(), greatWorkIndex)
    local greatWorkInfo = GameInfo.GreatWorks[greatWorkId];
    if greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_PRODUCT' then
      local timeline = Game.GetGreatPeople():GetTimeline();
      local amount = 0;
      for i, entry in ipairs(timeline) do
        if entry.Class == MERCHANT_INDEX then
          amount = entry.Cost;
        end
      end 
      amount = math.floor(amount * BURJ_KHALIFA_MERCHANT_PERCENTAGE / 100);
      player:GetGreatPeoplePoints():ChangePointsTotal(MERCHANT_INDEX, amount);

      local msg = Locale.Lookup('LOC_BUILDING_BURJ_KHALIFA_NAME') .. ": "
      msg = msg .. "+" .. amount .. " [ICON_GreatMerchant]"
      local x = Game:GetProperty(KhalifaTagX)
      local y = Game:GetProperty(KhalifaTagY)
      Game.AddWorldViewText(playerId, msg, x, y)
    end
  end
end
Events.GreatWorkCreated.Add(KhalifaGreatWorkCreated);

-- 圣彼得大教堂
local BUILDING_AL_STPETERSBASILICA_INFO = GameInfo.Buildings['BUILDING_AL_STPETERSBASILICA'];
local AL_STPETERSBASILICA_PLAYER_TAG = 'HD_AL_STPETERSBASILICA_PLAYER';
local AL_STPETERSBASILICA_RELIGION_TAG = 'HD_AL_STPETERSBASILICA_RELIGION';
local AL_STPETERSBASILICA_HAS_GRANTED_APOSTLE_TAG = 'HD_AL_STPETERSBASILICA_HAS_GRANTED_APOSTLE';
local NEED_REFRESH_RELIGION_FLAG_TAG = 'HD_NEED_REFRESH_RELIGION_FLAG';
local AL_STPETERSBASILICA_HAS_GRANTED_YIELD_TAG = 'HD_AL_STPETERSBASILICA_HAS_GRANTED_YIELD';
function AlStpetersbasilicaWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if BUILDING_AL_STPETERSBASILICA_INFO == nil then
    return;
  end

  local player = Players[playerId];
  if not player then return; end

  if buildingId == BUILDING_AL_STPETERSBASILICA_INFO.Index then
    -- 记录玩家创建的宗教
    local playerReligion = player:GetReligion():GetReligionTypeCreated();
    Game:SetProperty(AL_STPETERSBASILICA_PLAYER_TAG, playerId);
    Game:SetProperty(AL_STPETERSBASILICA_RELIGION_TAG, playerReligion);

    local alivePlayers = PlayerManager.GetAliveIDs()
    for _, alivePlayerId in ipairs(alivePlayers) do
      local alivePlayer = Players[alivePlayerId];
      local capitalCity = alivePlayer:GetCities():GetCapitalCity();
      if alivePlayer:IsMajor() and capitalCity and capitalCity:GetProperty(AL_STPETERSBASILICA_HAS_GRANTED_APOSTLE_TAG) ~= 1 then
        -- 判断是否信奉玩家的宗教
        local cityReligion = capitalCity:GetReligion():GetMajorityReligion();
        if cityReligion ~= -1 and cityReligion == playerReligion then
          capitalCity:SetProperty(AL_STPETERSBASILICA_HAS_GRANTED_APOSTLE_TAG, 1);
          AlStpetersbasilicaInitUnit(playerId, capitalCity, playerReligion);
        end
      end

      -- 标记已经信仰该宗教的城市
      local aliveCities = alivePlayer:GetCities()
      for _, city in aliveCities:Members() do
        local cityReligion = city:GetReligion():GetMajorityReligion();
        if cityReligion == playerReligion then
          city:SetProperty(AL_STPETERSBASILICA_HAS_GRANTED_YIELD_TAG, 1);
        end
      end
    end

  end
end
Events.WonderCompleted.Add(AlStpetersbasilicaWonderCompleted);

local AL_STPETERSBASILICA_YIELD_SCIENCE_PER_POP = GlobalParameters.HD_AL_STPETERSBASILICA_YIELD_SCIENCE_PER_POP or 0;
local AL_STPETERSBASILICA_YIELD_CULTURE_PER_POP = GlobalParameters.HD_AL_STPETERSBASILICA_YIELD_CULTURE_PER_POP or 0;
local AL_STPETERSBASILICA_YIELD_FAITH_PER_POP = GlobalParameters.HD_AL_STPETERSBASILICA_YIELD_FAITH_PER_POP or 0;
local AL_STPETERSBASILICA_YIELD_GOLD_PER_POP = GlobalParameters.HD_AL_STPETERSBASILICA_YIELD_GOLD_PER_POP or 0;
function AlStpetersbasilicaCityReligionFollowersChanged(playerId, cityId, eVisibility)
  local player = Players[playerId];

  local city = CityManager.GetCity(playerId, cityId);
  local cityReligion = city:GetReligion():GetMajorityReligion();
  local alStpetersbasilicaReligion = Game:GetProperty(AL_STPETERSBASILICA_RELIGION_TAG) or -1;

  if cityReligion ~= -1 and alStpetersbasilicaReligion ~= -1 and cityReligion == alStpetersbasilicaReligion then
    local alStpetersbasilicaPlayerId = Game.GetProperty(AL_STPETERSBASILICA_PLAYER_TAG)
    local alStpetersbasilicaPlayer = Players[alStpetersbasilicaPlayerId];
    if alStpetersbasilicaPlayer and alStpetersbasilicaPlayer:IsAlive() then
      -- 若为首都 获得使徒
      if player:IsMajor() and Utils.IsPlayerCapital(playerId, cityId) and city:GetProperty(AL_STPETERSBASILICA_HAS_GRANTED_APOSTLE_TAG) ~= 1 then
        city:SetProperty(AL_STPETERSBASILICA_HAS_GRANTED_APOSTLE_TAG, 1);
        AlStpetersbasilicaInitUnit(alStpetersbasilicaPlayerId, city, alStpetersbasilicaReligion);
      end
      
      -- 根据人口和区域获得产出
      if city:GetProperty(AL_STPETERSBASILICA_HAS_GRANTED_YIELD_TAG) ~= 1 then
        city:SetProperty(AL_STPETERSBASILICA_HAS_GRANTED_YIELD_TAG, 1);

        local districtsNum = city:GetDistricts():GetNumDistricts();
        for index = 0, districtsNum - 1 do
          local district = city:GetDistricts():GetDistrictByIndex(index);
          if district and not district:IsPillaged() and district:IsComplete() then
            local districtInfo = GameInfo.Districts[district:GetType()];
            if districtInfo and districtInfo.DistrictType ~= 'DISTRICT_WONDER' then
              local districtType = districtInfo.DistrictType;

              -- 检测 UD
              local districtReplaceInfo = GameInfo.DistrictReplaces[districtType];
              if districtReplaceInfo then
                districtType = districtReplaceInfo.ReplacesDistrictType;
              end

              -- 查询区域对应产出
              local correspondingYieldInfo = GameInfo.DistrictCorrespondingYieldType_HD[districtType];
              if correspondingYieldInfo and correspondingYieldInfo.RequiresPopulation == true then
                local popNum = city:GetPopulation();
                local yieldType = correspondingYieldInfo.YieldType;
                if yieldType == 'YIELD_FOOD' or yieldType == 'YIELD_FAITH' then
                  local amount = popNum * AL_STPETERSBASILICA_YIELD_FAITH_PER_POP
                  alStpetersbasilicaPlayer:GetReligion():ChangeFaithBalance(amount);
                  local msg = "+" .. amount .. " [ICON_Faith]"
                  Game.AddWorldViewText(alStpetersbasilicaPlayerId, msg, district:GetX(), district:GetY())
                elseif yieldType == 'YIELD_PRODUCTION' or yieldType == 'YIELD_GOLD' then
                  local amount = popNum * AL_STPETERSBASILICA_YIELD_GOLD_PER_POP
                  alStpetersbasilicaPlayer:GetTreasury():ChangeGoldBalance(amount);
                  local msg = "+" .. amount .. " [ICON_Gold]"
                  Game.AddWorldViewText(alStpetersbasilicaPlayerId, msg, district:GetX(), district:GetY())
                elseif yieldType == 'YIELD_SCIENCE' then
                  local amount = popNum * AL_STPETERSBASILICA_YIELD_SCIENCE_PER_POP
                  alStpetersbasilicaPlayer:GetTechs():ChangeCurrentResearchProgress(amount);
                  local msg = "+" .. amount .. " [ICON_Science]"
                  Game.AddWorldViewText(alStpetersbasilicaPlayerId, msg, district:GetX(), district:GetY())
                elseif yieldType == 'YIELD_CULTURE' then
                  local amount = popNum * AL_STPETERSBASILICA_YIELD_CULTURE_PER_POP
                  alStpetersbasilicaPlayer:GetCulture():ChangeCurrentCulturalProgress(amount);
                  local msg = "+" .. amount .. " [ICON_Culture]"
                  Game.AddWorldViewText(alStpetersbasilicaPlayerId, msg, district:GetX(), district:GetY())
                end
              end
            end
          end
        end
      end
    end
  end
end
Events.CityReligionFollowersChanged.Add(AlStpetersbasilicaCityReligionFollowersChanged);

local TECH_CELESTIAL_NAVIGATION_INDEX = GameInfo.Technologies['TECH_CELESTIAL_NAVIGATION'].Index;
local TECH_SHIPBUILDING_INDEX = GameInfo.Technologies['TECH_SHIPBUILDING'].Index;
function AlStpetersbasilicaInitUnit(playerId, city, religionId)
  local player = Players[playerId];
  if not player or not player:IsAlive() then return; end

  local targetPlot;

  -- 选取目标首都周围的可用单元格
  for direction = 0, 5 do
    local plot = Map.GetAdjacentPlot(city:GetX(), city:GetY(), direction);
    if plot and not plot:IsImpassable() then
      if not plot:IsWater() or (player:GetTechs():HasTech(TECH_CELESTIAL_NAVIGATION_INDEX) or player:GetTechs():HasTech(TECH_SHIPBUILDING_INDEX)) then
        -- 获取单元格内的单位
        local units = Units.GetUnitsInPlot(plot:GetX(), plot:GetY());
        if units ~= nil then
          -- 无单位
          if #units == 0 then
            targetPlot = plot;
            break;
          end

          -- 有友方单位
          for _, pUnit in ipairs(units) do
            if pUnit:GetOwner() == playerId then
              targetPlot = plot;
              break;
            end
          end

          if targetPlot then
            break;
          end
        end
      end
    end
  end

  -- 如果没有合法单位 则生成在首都
  if not targetPlot then
    local playerCapitalCity = player:GetCities():GetCapitalCity();
    if playerCapitalCity then
      targetPlot = Map.GetPlot(playerCapitalCity:GetX(), playerCapitalCity:GetY());
    end
  end

  -- 生成单位
  if targetPlot then
    print("圣彼得大教堂 " .. Locale.Lookup(city:GetName()) .. "信教 获得使徒");
    local newUnit = UnitManager.InitUnit(playerId, 'UNIT_APOSTLE', targetPlot:GetX(), targetPlot:GetY());
    if newUnit and newUnit:GetReligion() then
      newUnit:GetReligion():SetReligionType(religionId);
      newUnit:SetProperty(NEED_REFRESH_RELIGION_FLAG_TAG, 1);
      ReportingEvents.SendLuaEvent('HD_UpdateUnitReligionIcon', {
        playerId = newUnit:GetOwner(),
        unitId = newUnit:GetID()
      });
    end
  end
end

-- 瓦西里升天教堂
local BUILDING_ST_BASILS_CATHEDRAL_INDEX = GameInfo.Buildings['BUILDING_ST_BASILS_CATHEDRAL'].Index;
local ST_BASILS_CATHEDRAL_CULTURE_FOLLOWER = GlobalParameters.HD_ST_BASILS_CATHEDRAL_CULTURE_FOLLOWER or 0;
local ST_BASILS_CATHEDRAL_CULTURE_AMOUNT = GlobalParameters.HD_ST_BASILS_CATHEDRAL_CULTURE_AMOUNT or 0;
local ST_BASILS_CATHEDRAL_FAITH_FOLLOWER = GlobalParameters.HD_ST_BASILS_CATHEDRAL_FAITH_FOLLOWER or 0;
local ST_BASILS_CATHEDRAL_FAITH_AMOUNT = GlobalParameters.HD_ST_BASILS_CATHEDRAL_FAITH_AMOUNT or 0;
local ST_BASILS_CATHEDRAL_POS_X_TAG = 'HD_ST_BASILS_CATHEDRAL_POS_X';
local ST_BASILS_CATHEDRAL_POS_Y_TAG = 'HD_ST_BASILS_CATHEDRAL_POS_Y';

function StBasilsWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
	if buildingId == BUILDING_ST_BASILS_CATHEDRAL_INDEX then
    Game.SetProperty(ST_BASILS_CATHEDRAL_POS_X_TAG, x)
    Game.SetProperty(ST_BASILS_CATHEDRAL_POS_Y_TAG, y)
    
    RefreshStBasils()
	end
end
Events.WonderCompleted.Add(StBasilsWonderCompleted);

function RefreshStBasils()
  if Game.GetProperty(ST_BASILS_CATHEDRAL_POS_X_TAG) == nil then return; end

  local alives = PlayerManager.GetAlive()
  for _, player in ipairs(alives) do
    if PlayerHasWonder(player, BUILDING_ST_BASILS_CATHEDRAL_INDEX) then
      local followerAmount = Utils.GetReligionFollowerNum(player:GetReligion():GetReligionTypeCreated());
      print("瓦西里升天教堂 信徒数量 " .. followerAmount)

      -- 文化值
      if ST_BASILS_CATHEDRAL_CULTURE_FOLLOWER > 0 and ST_BASILS_CATHEDRAL_CULTURE_AMOUNT > 0 then
        local amount = math.floor(followerAmount / ST_BASILS_CATHEDRAL_CULTURE_FOLLOWER) * ST_BASILS_CATHEDRAL_CULTURE_AMOUNT;
        local plot = Map.GetPlot(Game.GetProperty(ST_BASILS_CATHEDRAL_POS_X_TAG), Game.GetProperty(ST_BASILS_CATHEDRAL_POS_Y_TAG))
        Utils.BinaryCompress(amount, plot, 'HD_PLOT_BINARY_COMPRESS_ST_BASILS_CATHEDRAL_1')
      end

      -- 信仰值
      if ST_BASILS_CATHEDRAL_FAITH_FOLLOWER > 0 and ST_BASILS_CATHEDRAL_FAITH_AMOUNT > 0 then
        local amount = math.floor(followerAmount / ST_BASILS_CATHEDRAL_FAITH_FOLLOWER) * ST_BASILS_CATHEDRAL_FAITH_AMOUNT;
        local plot = Map.GetPlot(Game.GetProperty(ST_BASILS_CATHEDRAL_POS_X_TAG), Game.GetProperty(ST_BASILS_CATHEDRAL_POS_Y_TAG))
        Utils.BinaryCompress(amount, plot, 'HD_PLOT_BINARY_COMPRESS_ST_BASILS_CATHEDRAL_2')
      end
      
    end
  end
end

local pendingRefreshStBasils = false;
function RefreshStBasilsIfPending(playerId)
	if pendingRefreshStBasils == true then
		RefreshStBasils();
		pendingRefreshStBasils = false;
	end
end
Events.CityReligionFollowersChanged.Add(function()
  pendingRefreshStBasils = true;
end)
GameEvents.OnGameTurnEnded.Add(RefreshStBasilsIfPending)
Events.CitySelectionChanged.Add(RefreshStBasilsIfPending)

-- 婆罗浮屠
local BOROBUDUR_UNIT_TAG = 'HD_BOROBUDUR_UNIT_';
function BorobudurTrainOrPurchaseUnit(playerId, objectId)
  local player = Players[playerId];
  if not player then return; end

  local unit = GameInfo.Units[objectId];
  if not unit then return; end

  if unit.FormationClass == 'FORMATION_CLASS_NAVAL' and player:GetProperty(BOROBUDUR_UNIT_TAG .. unit.UnitType) ~= 1 then
    player:SetProperty(BOROBUDUR_UNIT_TAG .. unit.UnitType, 1);
    player:AttachModifierByID('HD_BOROBUDUR_GRANT_ENVOY_' .. unit.UnitType);
    print('婆罗浮屠建造或购买海军获得使者：' .. Locale.Lookup(unit.Name));
  end
end

function BorobudurTrainUnit(playerId, cityId, type, objectId, cancelled)
  if type == 0 then
    BorobudurTrainOrPurchaseUnit(playerId, objectId);
  end
end
Events.CityProductionCompleted.Add(BorobudurTrainUnit);

function BorobudurPurchaseUnit(playerId, cityId, x, y, type, objectId)
  if type == EventSubTypes.UNIT then
    BorobudurTrainOrPurchaseUnit(playerId, objectId);
  end
end
Events.CityMadePurchase.Add(BorobudurPurchaseUnit);

-- 勃兰登堡门
local BRANDENBURG_GATE_INFO = GameInfo.Buildings['BUILDING_BRANDENBURG_GATE'];
local BRANDENBURG_GATE_MOMENT_TAG = 'HD_BRANDENBURG_GATE_MOMENT_';
local BRANDENBURG_GATE_MOMENT_NUM_TAG = 'HD_BRANDENBURG_GATE_MOMENT_NUM';
local BRANDENBURG_GATE_MILITARY_MOMENT_COUNT = GlobalParameters.HD_BRANDENBURG_GATE_MILITARY_MOMENT_COUNT or 0;
function BrandenburgGateNotificationAdded(playerId, notificationId)
  if not BRANDENBURG_GATE_INFO then return; end

  local player = Players[playerId];
  if not player then return; end

  local notificationEntry = NotificationManager.Find(playerId, notificationId)
  if notificationEntry and notificationEntry:GetType() == NOTIFICATION_PRIDE_MOMENT_RECORDED_HASH then
    local momentId = notificationEntry:GetValue("MomentID");
    if momentId then
      print('momentId', momentId)
      local momentData = Utils.GetHistoricalMomentData(momentId);
      local momentInfo = momentData and GameInfo.Moments[momentData.Type] or nil;
      if momentInfo then
        if Utils.MomentClassificationMap['MOMENT_CLASSIFICATION_MILITARY'][momentInfo.MomentType] == true
          and player:GetProperty(BRANDENBURG_GATE_MOMENT_TAG .. momentId) ~= 1
        then
          player:SetProperty(BRANDENBURG_GATE_MOMENT_TAG .. momentId, 1);
          player:AttachModifierByID('HD_BRANDENBURG_GATE_SCIENCE');
          player:AttachModifierByID('HD_BRANDENBURG_GATE_PRODUCTION');

          local amount = player:GetProperty('BRANDENBURG_GATE_MOMENT_NUM_TAG') or 0;
          player:SetProperty('BRANDENBURG_GATE_MOMENT_NUM_TAG', amount + 1);
          print("勃兰登堡门 军事类历史时刻次数：" .. (amount + 1));
          if BRANDENBURG_GATE_MILITARY_MOMENT_COUNT > 0 and amount == BRANDENBURG_GATE_MILITARY_MOMENT_COUNT - 1 then
            player:AttachModifierByID('HD_BRANDENBURG_GATE_YIELD_BOOST');
            print("勃兰登堡门 获得全国百分比");
          end
        end
      end
    end
  end
end
Events.NotificationAdded.Add(BrandenburgGateNotificationAdded);

--------------------------------------------------------------
-- Initialize
-- function initialize()
  
-- end
-- Events.LoadGameViewStateDone.Add(initialize);