ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- 战略资源项目
function ProjectStrategicResourcesChange(playerID, cityID, projectID)
  local player = Players[playerID]
  local project_name = GameInfo.Projects[projectID].ProjectType
  local resource_name = string.sub(project_name, 15)
  if string.sub(project_name, 1, 14) == 'PROJECT_GRANT_' then
      local playerResources = Players[playerID]:GetResources()
      local resource_id = GameInfo.Resources[resource_name].Index
      playerResources:ChangeResourceAmount(resource_id, 20)
  end
end
Events.CityProjectCompleted.Add(ProjectStrategicResourcesChange)

-- 巴西特色项目
local PROJECT_CARNIVAL_SCIENCE_PERCENTAGE = GlobalParameters.HD_PROJECT_CARNIVAL_SCIENCE_PERCENTAGE or 0;
local PROJECT_CARNIVAL_CULTURE_PERCENTAGE = GlobalParameters.HD_PROJECT_CARNIVAL_CULTURE_PERCENTAGE or 0;
local PROJECT_CARNIVAL_FAITH_PERCENTAGE = GlobalParameters.HD_PROJECT_CARNIVAL_FAITH_PERCENTAGE or 0;
local PROJECT_CARNIVAL_GOLD_PERCENTAGE = GlobalParameters.HD_PROJECT_CARNIVAL_GOLD_PERCENTAGE or 0;
local PROJECT_CARNIVAL_GPP_PERCENTAGE = GlobalParameters.HD_PROJECT_CARNIVAL_GPP_PERCENTAGE or 0;
local PROJECT_CARNIVAL_RESOURCE_BOOST_PERCENTAGE = GlobalParameters.HD_PROJECT_CARNIVAL_RESOURCE_BOOST_PERCENTAGE or 0;
local PROJECT_CARNIVAL_CITY_BOOST_PERCENTAGE = GlobalParameters.HD_PROJECT_CARNIVAL_CITY_BOOST_PERCENTAGE or 0;

function BrazilUniqueProjects(playerId)
  local player = Players[playerId];
  if not player or not player:IsMajor() then return; end

  -- 统计城市
  local cityDataList = {};
  -- ProjectType
  -- Production
  -- CityX
  -- CityY
  -- GPPType
  -- GPPFactor
  -- GPPX
  -- GPPY

  for _, city in player:GetCities():Members() do
    local current = city:GetBuildQueue():CurrentlyBuilding();
    if current == 'PROJECT_CARNIVAL' or current == 'PROJECT_WATER_CARNIVAL' then
      local data = {};
      data.CityX = city:GetX();
      data.CityY = city:GetY();
      data.ProjectType = current;
      data.Production = city:GetYield(YieldTypes.PRODUCTION) or 0;
      -- print(Locale.Lookup(city:GetName()) .. "生产力：" .. data.Production);

      -- 查询本城提供伟人点的区域
      local districtList = {};
      local districtsNum = city:GetDistricts():GetNumDistricts();
      for index = 0, districtsNum - 1 do
        local district = city:GetDistricts():GetDistrictByIndex(index);
        local districtType = GameInfo.Districts[district:GetType()].DistrictType;

        local gppTypeList = Utils.DistrictCorrespondingGPPMap[districtType] or {};
        if #gppTypeList > 0 then
          table.insert(districtList, {
            GPPTypeList = gppTypeList,
            GPPX = district:GetX(),
            GPPY = district:GetY()
          })
        end
      end

      -- 随机抽取一个区域
      if #districtList > 0 then
        local randomIndex = Game.GetRandNum(#districtList, "Random district for BrazilUniqueProjects " .. playerId) + 1;
        local distirctData = districtList[randomIndex];

        data.GPPX = distirctData.GPPX;
        data.GPPY = distirctData.GPPY;

        if #distirctData.GPPTypeList > 1 then
          randomIndex = Game.GetRandNum(#distirctData.GPPTypeList, "Random GPPType for BrazilUniqueProjects " .. playerId) + 1;
          data.GPPType = distirctData.GPPTypeList[randomIndex];
        else
          data.GPPType = distirctData.GPPTypeList[1];
        end

        randomIndex = Game.GetRandNum(101, "Random GPPFactor for BrazilUniqueProjects " .. playerId) + 50;
        data.GPPFactor = PROJECT_CARNIVAL_GPP_PERCENTAGE / 100 * randomIndex / 100;
        -- print(Locale.Lookup(city:GetName()) .. "伟人点系数：" .. data.GPPFactor);
      end
      
      table.insert(cityDataList, data);
    end
  end

  if #cityDataList == 0 then return; end

  -- 统计资源
  local streetResourceAmount, _  = Utils.GetBuildingNeedPlayerResource(playerId, 'BUILDING_HD_STREET_CARNIVAL_INTERNAL');
  local coastalResourceAmount, _ = Utils.GetBuildingNeedPlayerResource(playerId, 'BUILDING_HD_WATER_STREET_CARNIVAL_INTERNAL');
  -- print("街头狂欢节资源数量：" .. streetResourceAmount);
  -- print("滨海狂欢节资源数量：" .. coastalResourceAmount);

  -- 计算总产出
  local cityFactor = 1 + (#cityDataList * PROJECT_CARNIVAL_CITY_BOOST_PERCENTAGE / 100);
  local streetResourceFactor = 1 + (streetResourceAmount * PROJECT_CARNIVAL_RESOURCE_BOOST_PERCENTAGE / 100);
  local coastalResourceFactor = 1 + (coastalResourceAmount * PROJECT_CARNIVAL_RESOURCE_BOOST_PERCENTAGE / 100);
  local currentTurn = Game.GetCurrentGameTurn();

  print(currentTurn .. "t 巴西狂欢节 城市系数：" .. cityFactor);
  print(currentTurn .. "t 街头狂欢节系数：" .. streetResourceFactor);
  print(currentTurn .. "t 滨海狂欢节系数：" .. coastalResourceFactor);

  local yieldList = {
    Culture = 0,
    Faith = 0,
    Science = 0,
    Gold = 0
  };
  local gppList = {};

  for _, data in ipairs(cityDataList) do
    if data.ProjectType == 'PROJECT_CARNIVAL' then
      -- 基础产出
      local cultureAmount = math.floor(cityFactor * streetResourceFactor * PROJECT_CARNIVAL_CULTURE_PERCENTAGE  * data.Production) / 100;
      yieldList.Culture = yieldList.Culture + cultureAmount;
      Game.AddWorldViewText(playerId, '+' .. cultureAmount .. ' [ICON_CULTURE]', data.CityX, data.CityY);

      local faithAmount = math.floor(cityFactor * streetResourceFactor * PROJECT_CARNIVAL_FAITH_PERCENTAGE * data.Production) / 100;
      yieldList.Faith = yieldList.Faith + faithAmount;
      Game.AddWorldViewText(playerId, '+' .. faithAmount .. ' [ICON_FAITH]', data.CityX, data.CityY);

      -- 伟人点
      if data.GPPType then
        local gppAmount = math.ceil(cityFactor * streetResourceFactor * data.GPPFactor * data.Production);
        gppList[data.GPPType] = (gppList[data.GPPType] or 0) + gppAmount;
        local gpInfo = GameInfo.GreatPersonClasses[data.GPPType];
        Game.AddWorldViewText(playerId, '+' .. gppAmount .. ' ' .. gpInfo.IconString .. ' ' .. Locale.Lookup(gpInfo.Name), data.GPPX, data.GPPY);
      end
    elseif data.ProjectType == 'PROJECT_WATER_CARNIVAL' then
      -- 基础产出
      local scienceAmount = math.floor(cityFactor * coastalResourceFactor * PROJECT_CARNIVAL_SCIENCE_PERCENTAGE * data.Production) / 100;
      yieldList.Science = yieldList.Science + scienceAmount;
      Game.AddWorldViewText(playerId, '+' .. scienceAmount .. ' [ICON_SCIENCE]', data.CityX, data.CityY);

      local goldAmount = math.floor(cityFactor * coastalResourceFactor * PROJECT_CARNIVAL_GOLD_PERCENTAGE * data.Production) / 100;
      yieldList.Gold = yieldList.Gold + goldAmount;
      Game.AddWorldViewText(playerId, '+' .. goldAmount .. ' [ICON_GOLD]', data.CityX, data.CityY);

      -- 伟人点
      if data.GPPType then
        local gppAmount = math.ceil(cityFactor * coastalResourceFactor * data.GPPFactor * data.Production);
        gppList[data.GPPType] = (gppList[data.GPPType] or 0) + gppAmount;
        local gpInfo = GameInfo.GreatPersonClasses[data.GPPType];
        Game.AddWorldViewText(playerId, '+' .. gppAmount .. ' ' .. gpInfo.IconString .. ' ' .. Locale.Lookup(gpInfo.Name), data.GPPX, data.GPPY);
      end
    end
  end

  if yieldList.Culture > 0 then
    player:GetCulture():ChangeCurrentCulturalProgress(yieldList.Culture);
    print(currentTurn .. "t 巴西狂欢节 文化值：" .. yieldList.Culture);
  end
  if yieldList.Faith > 0 then
    player:GetReligion():ChangeFaithBalance(yieldList.Faith);
    print(currentTurn .. "t 巴西狂欢节 信仰值：" .. yieldList.Faith);
  end
  if yieldList.Science > 0 then
    player:GetTechs():ChangeCurrentResearchProgress(yieldList.Science);
    print(currentTurn .. "t 巴西狂欢节 科技值：" .. yieldList.Science);
  end
  if yieldList.Gold > 0 then
    player:GetTreasury():ChangeGoldBalance(yieldList.Gold);
    print(currentTurn .. "t 巴西狂欢节 金币：" .. yieldList.Gold);
  end

  for gppType, amount in pairs(gppList) do
    if amount > 0 then
      local gpInfo = GameInfo.GreatPersonClasses[gppType];
      player:GetGreatPeoplePoints():ChangePointsTotal(gpInfo.Index, amount);
      print(currentTurn .. "t 巴西狂欢节 " .. Locale.Lookup(gpInfo.Name) .. '：' .. amount);
    end
  end
end

function SukienniceOnGameTurnEnded()
	for _, playerId in ipairs(PlayerManager.GetAliveMajorIDs()) do
		BrazilUniqueProjects(playerId)
	end
end
GameEvents.OnGameTurnEnded.Add(SukienniceOnGameTurnEnded)
