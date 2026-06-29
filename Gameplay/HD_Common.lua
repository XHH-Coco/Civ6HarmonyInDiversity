-- =======================================================================
-- Common helper functions to be used by other files.
-- =======================================================================
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

Utils.HasBuildingWithinCountry = function(playerID, buildingID)
	local player = Players[playerID]
	local Allcity = player:GetCities()
	if player ~= nil and Allcity ~= nil then
		for _, city in Allcity:Members() do
			local CityHasBuilding = city:GetBuildings():HasBuilding(buildingID)
			if CityHasBuilding then
				return true
			end            
		end       
	end
	return false
end

Utils.GetDistrictIndex = function(districtType)
	local row = GameInfo.Districts[districtType]
	if row then
		return row.Index
	end
	return nil
end

Utils.IsDistrictType = function(districtType, targetType, noUniqueReplace)
	-- print(districtType, targetType, noUniqueReplace)
	local index = Utils.GetDistrictIndex(targetType)
	if index then
		if districtType == index then
			return true
		end
		if noUniqueReplace then
			return false
		end
		for tRow in GameInfo.DistrictReplaces() do
			if tRow.ReplacesDistrictType == targetType then
				if districtType == Utils.GetDistrictIndex(tRow.CivUniqueDistrictType) then
					return true
				end
			end
		end
	end
	return false
end

Utils.CityHasDistrict = function(city, DistrictType)
	local district_index = Utils.GetDistrictIndex(DistrictType)
	if city:GetDistricts():HasDistrict(district_index) then return true end
	
	for row in GameInfo.DistrictReplaces() do
		if row.ReplacesDistrictType == DistrictType then
			district_index = Utils.GetDistrictIndex(row.CivUniqueDistrictType)
			if city:GetDistricts():HasDistrict(district_index) then
				return true
			end
		end
	end
end

Utils.PlayerAttachModifierByID = function(playerID, sModifierID)
	local player = Players[playerID]
	if player ~= nil then
		player:AttachModifierByID(sModifierID)
	end
end

Utils.ChangeGoldBalance = function(playerID, amount)
	local player = Players[playerID]
	if player ~= nil then
		player:GetTreasury():ChangeGoldBalance(amount)
	end
end

Utils.GetPlotDistance = function(plotIndex, otherPlotIndex)
	return Map.GetPlotDistance(plotIndex, otherPlotIndex)
end

Utils.RemoveBuilding = function(playerID, cityID, buildingID)
	local city = CityManager.GetCity(playerID, cityID)
	if city ~= nil then
		local buildings = city:GetBuildings()
		buildings:RemoveBuilding(buildingID)
	end
end

Utils.CreateBuilding = function(playerID, cityID, buildingID)
	local city = CityManager.GetCity(playerID, cityID)
	if city ~= nil then
		local buildingQueue = city:GetBuildQueue()
		buildingQueue:CreateBuilding(buildingID)
	end
end

Utils.SetImprovementType = function(plotID, ImprovementID, OwnerID)
	local plot = Map.GetPlotByIndex(plotID)
	ImprovementBuilder.SetImprovementType(plot, ImprovementID, OwnerID)
end

Utils.AddGreatPeoplePoints = function(playerID, gppID, amount)
	local player = Players[playerID]
	if player ~= nil then
		player:GetGreatPeoplePoints():ChangePointsTotal(gppID, amount)
	end
end

Utils.SetUnitExperience = function(playerID, unitID, amount)
	local unit = UnitManager.GetUnit(playerID, unitID)
	if unit ~= nil then
		-- print('+exp', amount)
		unit:GetExperience():SetExperienceLocked(false);
		unit:GetExperience():ChangeExperience(amount);
	end
end

Utils.SetUnitStoredPromotions = function(playerID, unitID, amount)
	local unit = UnitManager.GetUnit(playerID, unitID)
	if amount == nil then 
		amount = 1
	end
	if unit ~= nil then
		unit:GetExperience():ChangeStoredPromotions(amount);
	end
end

-- Generic helper function to grant a relic to the given player.
Utils.GrantRelic = function(playerID)
	local player = Players[playerID];

	if player ~= nil then
		-- Grant relic here.
		player:AttachModifierByID("MODIFIER_RELIC_CREATOR");

		-- Cancel additional notification for the local player (the last RELIC_CREATED notification).
		local localPlayerId = Game.GetLocalPlayer();
		if localPlayerId == playerID then
			local lastRelicCreated = nil;
			local notificationIds = NotificationManager.GetList(localPlayerId);
			for _, notificationId in ipairs(notificationIds) do
				local notification = NotificationManager.Find(localPlayerId, notificationId);
				if notification ~= nil and notification:GetType() == NotificationTypes.RELIC_CREATED then
					lastRelicCreated = notification;
				end
			end
			if lastRelicCreated ~= nil and not lastRelicCreated:IsDismissed() then
				NotificationManager.Dismiss(localPlayerId, lastRelicCreated:GetID());
			end
		end
	end
end

Utils.GetBuildingLocation = function (playerId, cityId, buildingId)
	local city = CityManager.GetCity(playerId, cityId);
	if city ~= nil then
		return city:GetBuildings():GetBuildingLocation(buildingId);
	end
end

local m_ModifierAmountCache = {};
Utils.GetModifierAmount = function (modifierId)
	local amount = m_ModifierAmountCache[modifierId];
	if amount ~= nil then
		return amount;
	end
	for row in GameInfo.ModifierArguments() do
		if row.ModifierId == modifierId and row.Name == "Amount" then
			local rawValue = row.Value or 0;
			local gameSpeed = GameConfiguration.GetGameSpeedType();
			local costMultiplier = GameInfo.GameSpeeds[gameSpeed].CostMultiplier;
			amount = math.floor(rawValue * costMultiplier / 100);
			-- Cache it.
			m_ModifierAmountCache[modifierId] = amount;
		end
	end
	return amount;
end

-- 修改玩家时代分
function ChangePlayerEraScore(playerId, amount)
	return Game.GetEras():ChangePlayerEraScore(playerId, amount);
end
Utils.ChangePlayerEraScore = ChangePlayerEraScore

-- 判断区域是否完成
function IsDistrictComplete(playerId, cityId, districtId)
	local city = CityManager.GetCity(playerId, cityId);
	if city == nil then
		return false
	end

	local district = city:GetDistricts():GetDistrict(districtId)

	if district == nil then
		return false
	end

	if district:IsPillaged() then
		return false
	end

	return district:IsComplete()
end
Utils.IsDistrictComplete = IsDistrictComplete

--------------------------------------------------------------------
-- 生成资源
function GenerateResource(plot, resourceId)
	ResourceBuilder.SetResourceType(plot, resourceId, 1);

	local city = Cities.GetPlotPurchaseCity(plot);
	if city then
		local playerId = city:GetOwner()
		local player = Players[playerId];

		-- 对于玩家的地块，需要先设置为无主，然后购买
		if player:IsHuman() then
			-- 判断是否是三环内
			local distance = Map.GetPlotDistance(plot:GetIndex(), city:GetPlot():GetIndex())
			print('GenerateResource distance', distance)
			if distance <= 3 then
				local gold = player:GetTreasury():GetGoldBalance();
				print("GenerateResource 购买前的国库", gold)
				player:SetProperty("HD_GenerateResource_GoldBalance", gold)
	
				local cityId = city:GetID()
				Utils.CityPurchasePlot(playerId, cityId, plot:GetX(), plot:GetY())
			end
		end
	end
end
Utils.GenerateResource = GenerateResource

-- 更改单元格所有者的函数，代码来自IthildinX
function HDSetPlotOwner(playerId, param)
	local x, y = param.X, param.Y
	local plot = Map.GetPlot(x, y)
	if param.ID then
		local city = CityManager.GetCity(playerId, param.ID)
		WorldBuilder.CityManager():SetPlotOwner(plot, city)
	else
		WorldBuilder.CityManager():SetPlotOwner(plot, false)
	end
end
GameEvents.HDSetPlotOwner.Add(HDSetPlotOwner)

-- 更改国库金币的函数，代码来自IthildinX
function HDChangeGoldBalance(playerId, param)
	local amount = param.Gold
	Players[playerId]:GetTreasury():ChangeGoldBalance(amount)
end
GameEvents.HDChangeGoldBalance.Add(HDChangeGoldBalance)

-- SetProperty的函数，代码来自IthildinX
function HDSetPurchasedPlotProperty(playerId, param)
	local x, y = param.X, param.Y
	local plot = Map.GetPlot(x, y)
	plot:SetProperty('HD_PurchasedPlot', param.Property)
end
GameEvents.HDSetPurchasedPlotProperty.Add(HDSetPurchasedPlotProperty)

function GenerateResourcePurchasePlot(playerId, cityId, x, y, purchaseType, objectType)
	if purchaseType == EventSubTypes.PLOT then 
		local player = Players[playerId];
		if player then
			local plot = Map.GetPlot(x, y)
			if plot and plot:GetProperty('HD_PurchasedPlot') == 1 then
				local gold = player:GetProperty("HD_GenerateResource_GoldBalance")
				print("GenerateResource 购买后 需要回调为", gold)
				player:GetTreasury():SetGoldBalance(gold);
			end
		end
	end
end
Events.CityMadePurchase.Add(GenerateResourcePurchasePlot);
--------------------------------------------------------------------
-- 判断建筑所属时代
function GetBuildingEra(buildingId)
	local buildingInfo = GameInfo.Buildings[buildingId]
	if buildingInfo == nil then
		return -1;
	end
	local prereqTech = GameInfo.Technologies[buildingInfo.PrereqTech]
	local prereqCivic = GameInfo.Civics[buildingInfo.PrereqCivic]
	if prereqTech ~= nil then
		local era = GameInfo.Eras[prereqTech.EraType].Index
		return era;
	elseif prereqCivic ~= nil then
		local era = GameInfo.Eras[prereqCivic.EraType].Index
		return era;
	else
		return 0;
	end
end
Utils.GetBuildingEra = GetBuildingEra

-- 获取城市正在建造
function GetCityCurrentlyBuilding(playerId, cityId)
	local city = CityManager.GetCity(playerId, cityId);
	return city:GetBuildQueue():CurrentlyBuilding();
end
Utils.GetCityCurrentlyBuilding = GetCityCurrentlyBuilding;

-- 获取随机数
function GetRandNum(max, reason)
	return Game.GetRandNum(max, reason)
end
Utils.GetRandNum = GetRandNum;

-- 百分比加速城市队列，不产生溢出锤
function CityAddProgressPercentage(playerId, cityId, percentage, extra)
	local city = CityManager.GetCity(playerId, cityId);
	local current = city:GetBuildQueue():CurrentlyBuilding();
	if current then
		local buildingInfo = GameInfo.Buildings[current];
		local districtInfo = GameInfo.Districts[current];
		local unitInfo = GameInfo.Units[current];
		local projectInfo = GameInfo.Projects[current];

		-- 其他设置
		local extraInfo = extra or {}
		local addViewText = extraInfo.AddViewText
		local wonderOnly = extraInfo.WonderOnly

		if wonderOnly then
			if not buildingInfo or not buildingInfo.IsWonder then return; end
		end

		local cost = 0;
		local process = 0;
		local amount = 0;
		if buildingInfo ~= nil then
			cost = Utils.GetCityCurrentBuildQueueCost(playerId, cityId, 0, buildingInfo.Index)
			process = Utils.GetCityCurrentBuildQueueProgress(playerId, cityId, 0, buildingInfo.Index)
		end

		if districtInfo ~= nil then
			cost = Utils.GetCityCurrentBuildQueueCost(playerId, cityId, 1, districtInfo.Index);
			process = Utils.GetCityCurrentBuildQueueProgress(playerId, cityId, 1, districtInfo.Index);
		end

		if unitInfo ~= nil then
			cost = Utils.GetCityCurrentBuildQueueCost(playerId, cityId, 2, unitInfo.Index);
			process = Utils.GetCityCurrentBuildQueueProgress(playerId, cityId, 2, unitInfo.Index);
		end

		if projectInfo ~= nil then
			cost = Utils.GetCityCurrentBuildQueueCost(playerId, cityId, 3, projectInfo.Index);
			process = Utils.GetCityCurrentBuildQueueProgress(playerId, cityId, 3, projectInfo.Index);
		end

		amount = math.floor(cost * percentage / 100);
		amount = math.min(amount, cost - process);
		city:GetBuildQueue():AddProgress(amount);
		if addViewText then Game.AddWorldViewText(playerId, "+" .. amount .. " [ICON_PRODUCTION]", city:GetX(), city:GetY()); end
		print("百分比加速城市队列", current, percentage, amount)
	end
end
Utils.CityAddProgressPercentage = CityAddProgressPercentage;

-- 列表是否包含某元素
function TableHasValue(t, v)
	for _, i in ipairs(t) do
		if i == v then
			return true;
		end
	end
	return false;
end
Utils.TableHasValue = TableHasValue;

-- 数组去重
function TableRemoveRepeat(a)
	local b = {}
	for k,v in ipairs(a) do
		if(#b == 0) then
			b[1]=v;
		else
			local index = 0
			for i=1,#b do
				if(v == b[i]) then
					break
				end
				index = index + 1
			end
			if(index == #b) then
				b[#b + 1] = v;
			end
		end
	end
	return b
end
Utils.TableRemoveRepeat = TableRemoveRepeat;

-- 获取玩家道路
local eraRouteTypeList = {}
local routeTypeLevelList = {}
local RAILROAD_INDEX = GameInfo.Routes['ROUTE_RAILROAD'].Index
function InitRouteTypeList()
	-- 远古道路
	eraRouteTypeList[GameInfo.Eras['ERA_ANCIENT'].Index] = GameInfo.Routes['ROUTE_ANCIENT_ROAD'].Index
	-- 记录远古以后时代对应的道路
	for era in GameInfo.Eras() do
		for route in GameInfo.Routes() do
			local prereqEra = route.PrereqEra
			if prereqEra then
				local prereqEraIndex = GameInfo.Eras[prereqEra].ChronologyIndex;
				if era.ChronologyIndex >= prereqEraIndex then
					eraRouteTypeList[era.Index] = route.Index;
				end
			end
		end
	end

	for eraIndex, routeIndex in ipairs(eraRouteTypeList) do
		if not TableHasValue(routeTypeLevelList, routeIndex) then
			table.insert(routeTypeLevelList, routeIndex)
		end

		-- print(
		-- 	Locale.Lookup(GameInfo.Eras[eraIndex].Name),
		-- 	Locale.Lookup(GameInfo.Routes[routeIndex].Name)
		-- )
	end

	-- for level, routeIndex in ipairs(routeTypeLevelList) do
	-- 	print(
	-- 		level,
	-- 		Locale.Lookup(GameInfo.Routes[routeIndex].Name)
	-- 	)
	-- end
end
InitRouteTypeList()

function GetRouteTypeForPlayer(player)
	local eraIndex = player:GetEra();
	local routeIndex = eraRouteTypeList[eraIndex]

	-- 获取 Modifer 提供的额外道路等级
	local extraLevel = player:GetProperty("HD_ROUTE_EXTRA_LEVEL") or 0;
	if extraLevel > 0 then
		local newLevel = 0;
		for level, ri in ipairs(routeTypeLevelList) do
			if ri == routeIndex then
				newLevel = level;
				break;
			end
		end
		newLevel = math.min(newLevel + extraLevel, #routeTypeLevelList)
		routeIndex = routeTypeLevelList[newLevel]
	end
	
	return routeIndex;
end
Utils.GetRouteTypeForPlayer = GetRouteTypeForPlayer;

function CompareRoutes(a,b)
	-- 判断铁路
	if a == RAILROAD_INDEX then
		return true;
	elseif b == RAILROAD_INDEX then
		return false;
	end

	-- 判断普通道路
	local levelA = 0;
	local levelB = 0;
	for level, routeIndex in ipairs(routeTypeLevelList) do
		if routeIndex == a then
			levelA = level;
		end
		if routeIndex == b then
			levelB = level;
		end
	end 

	return levelA > levelB;
end
Utils.CompareRoutes = CompareRoutes;

-- 根据科文、时代、回合数等条件判断是否可用
function IsRowValid(playerId, row)
	local player = Players[playerId]
	if row and player then
		local playerEras = player:GetEras();
		local playerTechs = player:GetTechs();
		local playerCulture = player:GetCulture();
		local playerReligion = player:GetReligion();
		-- print("玩家时代", GameInfo.Eras[playerEras:GetEra()].ChronologyIndex)
		if (not row.PrereqEra or GameInfo.Eras[playerEras:GetEra()].ChronologyIndex >= GameInfo.Eras[row.PrereqEra].ChronologyIndex)
		and (not row.PrereqTech or playerTechs:HasTech(GameInfo.Technologies[row.PrereqTech].Index))
		and (not row.PrereqCivic or playerCulture:HasCivic(GameInfo.Civics[row.PrereqCivic].Index))
		and (not row.ObsoleteEra or GameInfo.Eras[playerEras:GetEra()].ChronologyIndex < GameInfo.Eras[row.ObsoleteEra].ChronologyIndex)
		and (not row.ObsoleteTech or not playerTechs:HasTech(GameInfo.Technologies[row.ObsoleteTech].Index))
		and (not row.ObsoleteCivic or not playerCulture:HasCivic(GameInfo.Civics[row.ObsoleteCivic].Index))
		and (not row.MinTurn or Game.GetCurrentGameTurn() >= row.MinTurn)
		and (not row.RequiresReligion or playerReligion:GetReligionTypeCreated() >= 0) then
			return true;
		else
			return false;
		end
	else
		return false
	end
end
Utils.IsRowValid = IsRowValid;

-- 苏美尔 获得特殊任务描述
local Sumeria_Special_Quest_Tag = 'HD_Sumeria_Special_Quest';
local m_Sumeria_SpecialQuestList = {};
function GetSumeriaSpecialQuestDescription(playerId, citystateId)
	local player = Players[playerId]
	m_Sumeria_SpecialQuestList = player:GetProperty(Sumeria_Special_Quest_Tag) or {}
	local specialQuest = m_Sumeria_SpecialQuestList[citystateId]
	if specialQuest then
		-- 任务描述
		local description = specialQuest.Description
		if specialQuest.SubDescription ~= nil then
			description = Locale.Lookup(description, specialQuest.SubDescription)
		end

		-- 奖励描述
		local rewardDescription = GetSumeriaSpecialRewardDescription(specialQuest.SpecialReward)

		-- 合并描述
		local resultString = Locale.Lookup(
			"LOC_HD_SPECIAL_QUEST_AND_REWARD_DESCRIPTION",
			description,
			rewardDescription
		)
		return resultString;
	end
	return nil;
end
Utils.GetSumeriaSpecialQuestDescription = GetSumeriaSpecialQuestDescription;

-- 奖励描述
function GetSumeriaSpecialRewardDescription(specialReward)
	if specialReward == nil then
		return Locale.Lookup('LOC_HD_SPECIAL_QUEST_REWARD_NONE_DESCRIPTION')
	end

	local rewardDescription = specialReward.Description
	if specialReward.SubDescription ~= nil then
		if specialReward.Amount == nil then
			rewardDescription = Locale.Lookup(rewardDescription, specialReward.SubDescription)
		else
			rewardDescription = Locale.Lookup(rewardDescription, specialReward.Amount, specialReward.SubDescription)
		end
	end
	return rewardDescription;
end
Utils.GetSumeriaSpecialRewardDescription = GetSumeriaSpecialRewardDescription;

-- 获得通用区域 Id
function GetCommonDistrictId(districtId)
	local commonId = districtId;

	local districtInfo = GameInfo.Districts[districtId]
	if districtInfo.TraitType == nil then
		return commonId;
	end

	-- 开始检测UD
	local districtType = districtInfo.DistrictType
	for row in GameInfo.DistrictReplaces() do
		if row.CivUniqueDistrictType == districtType then
			commonId = GameInfo.Districts[row.ReplacesDistrictType].Index;
			break;
		end
	end
	return commonId;
end
Utils.GetCommonDistrictId = GetCommonDistrictId;

-- 获取城市区域对象 包括UD
function GetCityDistrict(city, districtId)
	local district = city:GetDistricts():GetDistrict(districtId)
	if not district then
		-- 获取特色区域
		local districtType = GameInfo.Districts[districtId].Index
		for row in GameInfo.DistrictReplaces() do
			if row.CivUniqueDistrictType == districtType then
				local udId = GameInfo.Districts[row.ReplacesDistrictType].Index;
				district = city:GetDistricts():GetDistrict(udId)
				if district ~= nil then
					break;
				end
			end
		end
	end
	return district;
end
Utils.GetCityDistrict = GetCityDistrict;

-- 判断单位 包含UU
function IsUnit(unit, targetUnitType, noUniqueReplace)
	if unit == targetUnitType then return true; end
	local unitInfo = GameInfo.Units[unit]
	if unitInfo then
		if unitInfo.UnitType == targetUnitType then return true; end
		if noUniqueReplace then return false; end
		for row in GameInfo.UnitReplaces() do
			if row.ReplacesUnitType == targetUnitType and row.CivUniqueUnitType == unitInfo.UnitType then
				return true;
			end
		end
	end

	return false;
end
Utils.IsUnit = IsUnit;

-- 判断单位升级树
function IsUnitPromotion(unit, promotion)
	local unitInfo = GameInfo.Units[unit]
	if unitInfo then
		if unitInfo.PromotionClass == promotion then
			return true;
		end
	end
	return false;
end
Utils.IsUnitPromotion = IsUnitPromotion;

-- 记录可获得点数的伟人类型
local GreatPeopleList = {}
function InitGreatPeopleList()
	for row in GameInfo.GreatPersonClasses() do
		if row.AvailableInTimeline == true and row.GreatPersonClassType ~= 'GREAT_PERSON_CLASS_PROPHET' then
			table.insert(GreatPeopleList, {
				Index = row.Index,
				Icon = row.IconString
			})
		end
	end
	Utils.GreatPeopleList = GreatPeopleList;
end
InitGreatPeopleList()

-- 统计有相邻加成的区域 包括UD
local HasAdjacencyDistrictList = {}
function InitHasAdjacencyDistrictList()
  if not GameInfo.DistrictCorrespondingYieldType_HD() then
    print("Error DistrictCorrespondingYieldType_HD表格不存在！")
    return;
  end

  -- print("开始统计有相邻加成的区域")

  for row in GameInfo.DistrictCorrespondingYieldType_HD() do
    if row.HasAdjacency == true then
      HasAdjacencyDistrictList[GameInfo.Districts[row.DistrictType].Index] = true;
      -- print(Locale.Lookup(GameInfo.Districts[row.DistrictType].Name))

      -- 检测UD
      for rrow in GameInfo.DistrictReplaces() do
        if row.DistrictType == rrow.ReplacesDistrictType then
          HasAdjacencyDistrictList[GameInfo.Districts[rrow.CivUniqueDistrictType].Index] = true;
          -- print(Locale.Lookup(GameInfo.Districts[rrow.CivUniqueDistrictType].Name))
        end
      end
    end
  end
end
InitHasAdjacencyDistrictList()
Utils.HasAdjacencyDistrictList = HasAdjacencyDistrictList;

-- 记录虚拟建筑
local DummyBuildingList = {};
function InitDummyBuildings()
	for row in GameInfo.HD_DUMMY_BUILDINGS() do
		DummyBuildingList[row.BuildingType] = true;
		-- print("记录虚拟建筑", Locale.Lookup(GameInfo.Buildings[row.BuildingType].Name))
	end
end
InitDummyBuildings();
Utils.DummyBuildingList = DummyBuildingList;

-- 资源类型排序 奢侈 > 战略 > 加成 > 其他
Utils.ResourceClassSortList = {
	RESOURCECLASS_LUXURY = 0,
	RESOURCECLASS_STRATEGIC = 1,
	RESOURCECLASS_BONUS = 2,
	RESOURCECLASS_ARTIFACT = 3
};

-- 缓存每种类型对应的资源
local Classification_Resource_Map = {};
-- 缓存每种资源对应的类型
local Resource_Classification_Map = {};
function InitResourceClassificationList()
	for row in GameInfo.HD_Resource_Classification() do
		-- 缓存每种类型对应的资源
		if Classification_Resource_Map[row.ResourceClassificationType] == nil then
			Classification_Resource_Map[row.ResourceClassificationType] = {};
		end
		table.insert(Classification_Resource_Map[row.ResourceClassificationType], row.ResourceType);

		-- 缓存每种资源对应的类型
		if Resource_Classification_Map[row.ResourceType] == nil then
			Resource_Classification_Map[row.ResourceType] = {};
		end
		table.insert(Resource_Classification_Map[row.ResourceType], row.ResourceClassificationType);
	end

	-- 排序
	for _, list in pairs(Classification_Resource_Map) do
		table.sort(list, function(a, b)
			local a_score = Utils.ResourceClassSortList[GameInfo.Resources[a].ResourceClassType] or 100;
			local b_score = Utils.ResourceClassSortList[GameInfo.Resources[b].ResourceClassType] or 100;
			return a_score < b_score;
		end);
	end
	
	for _, list in pairs(Resource_Classification_Map) do
		table.sort(list, function(a, b)
			return GameInfo.HD_ResourceClassificationTypes[a].SortIndex < GameInfo.HD_ResourceClassificationTypes[b].SortIndex;
		end);
	end
end
InitResourceClassificationList();
Utils.Classification_Resource_Map = Classification_Resource_Map;
Utils.Resource_Classification_Map = Resource_Classification_Map;

-- 判断某种资源是否是某个分类
function IsResourceHasClassification(resourceId, classificationType)
	local resourceInfo = GameInfo.Resources[resourceId];
	if resourceInfo and Utils.Resource_Classification_Map[resourceInfo.ResourceType] then
		for _, v in ipairs(Utils.Resource_Classification_Map[resourceInfo.ResourceType]) do
			if v == classificationType then
				return true;
			end
		end
	end
	return false;
end
Utils.IsResourceHasClassification = IsResourceHasClassification;

-- 缓存每种改良对应的类型
local Improvement_Classification_Map = {};
function InitImprovementClassificationList()
	for row in GameInfo.HD_Improvement_Classification() do
		if Improvement_Classification_Map[row.ImprovementType] == nil then
			Improvement_Classification_Map[row.ImprovementType] = {};
		end
		table.insert(Improvement_Classification_Map[row.ImprovementType], row.ImprovementClassificationType);
	end
end
InitImprovementClassificationList()
Utils.Improvement_Classification_Map = Improvement_Classification_Map;

-- 判断某种改良是否是某个分类
function IsImprovementHasClassification(improvementId, classificationType)
	local improvementInfo = GameInfo.Improvements[improvementId];
	if improvementInfo and Utils.Improvement_Classification_Map[improvementInfo.ImprovementType] then
		for _, v in ipairs(Utils.Improvement_Classification_Map[improvementInfo.ImprovementType]) do
			if v == classificationType then
				return true;
			end
		end
	end
	return false;
end
Utils.IsImprovementHasClassification = IsImprovementHasClassification;

-- 获取城市单元格资源列表
-- filterParam
	-- ClassTypeList 加成/奢侈/战略
	-- ClassificationList 资源分类列表
	-- NeedImproved 是否需要改良
local function GetCityPlotsResources(playerId, cityId, filterParam)
	local city = CityManager.GetCity(playerId, cityId);
	if not city then return {}; end

	-- 筛选条件参数
	local classTypeList = {};
	local classificationList = {};
	local needImproved = false;
	if filterParam then
		classTypeList = filterParam.ClassTypeList or {};
		classificationList = filterParam.ClassificationList or {};
		needImproved = filterParam.NeedImproved or false;
	end

	local resourceList = {};
	local cityPlots = city:GetOwnedPlots();
	for _, plot in pairs(cityPlots) do
		if plot then
			local resourceId = plot:GetResourceType();
			if resourceId ~= nil and resourceId ~= -1 and Utils.IsResourceVisible(playerId, resourceId) then
				local resourceInfo = GameInfo.Resources[resourceId];
				if resourceInfo then
					print("=======================================================")
					print("开始检测：" .. Locale.Lookup(resourceInfo.Name));
					-- 检查资源类型
					local meetClassTypeFilter = #classTypeList == 0;
					for _, classType in ipairs(classTypeList) do
						meetClassTypeFilter = meetClassTypeFilter or (classType == resourceInfo.ResourceClassType);
						if meetClassTypeFilter then
							print('满足资源类型检测：' .. classType);
							break;
						end
					end

					-- 检查资源用途
					local meetClassificationFilter = #classificationList == 0;
					for _, classification in ipairs(classificationList) do
						meetClassificationFilter = meetClassificationFilter or IsResourceHasClassification(resourceId, classification);
						if meetClassificationFilter then
							print('满足资源用途检测：' .. classification);
							break;
						end
					end

					-- 检查是否改良
					local meetImprovedFilter = not needImproved;
					if needImproved then
						local districtId = plot:GetDistrictType();
						local improvementId = plot:GetImprovementType();
						meetImprovedFilter = (districtId ~= nil and districtId > -1) or (improvementId ~= nil and improvementId > -1);
						if meetImprovedFilter then
							print('满足资源改良检测');
						end
					end

					-- 满足所有筛选条件
					if meetClassTypeFilter and meetClassificationFilter and meetImprovedFilter then
						resourceList[resourceInfo.ResourceType] = true;
						print(Locale.Lookup(city:GetName()) .. ' 拥有 ' .. Locale.Lookup(resourceInfo.Name))
					end
				end

			end
		end
	end

	return resourceList;
end
Utils.GetCityPlotsResources = GetCityPlotsResources;

-- 获取城市参数
local function GetCityProperty(playerId, cityId, tag)
	local city = CityManager.GetCity(playerId, cityId);
	if not city then return nil; end

	return city:GetProperty(tag);
end
Utils.GetCityProperty = GetCityProperty;

-- 获取单位参数
local function GetUnitProperty(playerId, unitId, tag)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if not unit then return nil; end

	return unit:GetProperty(tag);
end
Utils.GetUnitProperty = GetUnitProperty;

-- 获得玩家参数
local function GetPlayerProperty(playerId, tag)
	local player = Players[playerId];
	if not player then return nil; end

	return player:GetProperty(tag);
end
Utils.GetPlayerProperty = GetPlayerProperty;


-- 设置玩家property
local function SetPlayerProperty(playerId, tag, value)
	local player = Players[playerId];
	if not player then return; end

	return player:SetProperty(tag, value);
end
Utils.SetPlayerProperty = SetPlayerProperty;

-- 宣战
local function DeclareWarBetweenPlayers(player1Id, player2Id, warId)
	local player1 = Players[player1Id];
	if player1 and player1:GetDiplomacy():CanDeclareWarOn(player2Id, warId, true) then
		player1:GetDiplomacy():DeclareWarOn(player2Id, warId, true);
		return true;
	end

	return false;
end
Utils.DeclareWarBetweenPlayers = DeclareWarBetweenPlayers;

-- 按权重展开的列表
local function GetListByWeight(dataList, resultList, dataName)
	local list = resultList or {};
	dataName = dataName or 'Data';
	for _, data in ipairs(dataList) do
		for i = 1, data.Weight do
			table.insert(list, data[dataName]);
		end
	end

	return list;
end
Utils.GetListByWeight = GetListByWeight;

-- 获取已解锁的某个兵种的列表
local function GetUnlockedUnitListByPromotionClass(playerId, promotionClass, Domain, resultList)
	local list = resultList or {};
	local player = Players[playerId];
	if player then
		for row in GameInfo.Units() do
			if row.PromotionClass == promotionClass and
			(not row.PrereqTech or player:GetTechs():HasTech(GameInfo.Technologies[row.PrereqTech].Index)) and
			(not row.PrereqCivic or player:GetCulture():HasCivic(GameInfo.Civics[row.PrereqCivic].Index)) and
			(not Domain or row.Domain == Domain) then
				table.insert(list, row.Index);
			end
		end
	end

	return list;
end
Utils.GetUnlockedUnitListByPromotionClass = GetUnlockedUnitListByPromotionClass;

-- 根据当前世界时代获取某个兵种的列表
local function GetUnitListByPromotionClassByWorldEra(promotionClass, Domain, resultList)
	local list = resultList or {};

	for row in GameInfo.Units() do
		if row.PromotionClass == promotionClass and (not Domain or row.Domain == Domain) then
			local unitEraIndex = 1;
			local gameEraIndex = GameInfo.Eras[Game.GetEras():GetCurrentEra()].ChronologyIndex;

			if row.PrereqTech then
				unitEraIndex = GameInfo.Eras[GameInfo.Technologies[row.PrereqTech].EraType].ChronologyIndex;
			end

			if row.PrereqCivic then
				unitEraIndex = GameInfo.Eras[GameInfo.Civics[row.PrereqCivic].EraType].ChronologyIndex;
			end

			if unitEraIndex <= gameEraIndex then
				table.insert(list, row.Index);
				-- print(Locale.Lookup(row.Name))
			end
		end
	end

	return list;
end
Utils.GetUnitListByPromotionClassByWorldEra = GetUnitListByPromotionClassByWorldEra;

-- 获取已解锁的某个类型的资源
local function GetUnlockedResourceListByClass(playerId, resourceClassType)
	local list = {};
	local player = Players[playerId];

	if player then
		for row in GameInfo.Resources() do
			if row.ResourceClassType == resourceClassType and (row.Frequency ~= 0 or row.SeaFrequency ~= 0) and
			(not row.PrereqTech or player:GetTechs():HasTech(GameInfo.Technologies[row.PrereqTech].Index)) and
			(not row.PrereqCivic or player:GetCulture():HasCivic(GameInfo.Civics[row.PrereqCivic].Index)) then
				table.insert(list, row.Index);
				-- print(Locale.Lookup(row.Name))
			end
		end
	end

	return list;
end
Utils.GetUnlockedResourceListByClass = GetUnlockedResourceListByClass;

-- 获取最近的城市
local function GetNearestCity(playerId, x, y)
	local player = Players[playerId];

	local distance;
	local resultCity;

	if player then
		for _, city in player:GetCities():Members() do
			local cityLocation = city:GetLocation();
			local d = Map.GetPlotDistance(x, y, cityLocation.x, cityLocation.y);
			if not resultCity then
				distance = d;
				resultCity = city:GetID();
			elseif d < distance then
				distance = d;
				resultCity = city:GetID();
			end
		end
	end

	return resultCity;
end
Utils.GetNearestCity = GetNearestCity;

-- 记录创作巨作的伟人
local GreatWorkGreatPersonList = {}
local function InitGreatWorkGreatPersonList()
	for row in GameInfo.GreatWorks() do
		if row.GreatPersonIndividualType ~= nil then
			GreatWorkGreatPersonList[GameInfo.GreatPersonIndividuals[row.GreatPersonIndividualType].Index] = true;
		end
	end
end
InitGreatWorkGreatPersonList()
Utils.GreatWorkGreatPersonList = GreatWorkGreatPersonList;

-- 区域对应伟人点Map 包括特色区域
local DistrictCorrespondingGPPMap = {};
local function InitDistrictCorrespondingGPPMap()
	for row in GameInfo.DistrictCorrespondingGPP_HD() do
		local data = DistrictCorrespondingGPPMap[row.DistrictType] or {};
		table.insert(data, row.GreatPersonClassType);
		DistrictCorrespondingGPPMap[row.DistrictType] = data;

		-- 处理UD
		for rr in GameInfo.DistrictReplaces() do
			if rr.ReplacesDistrictType == row.DistrictType then
				local udData = DistrictCorrespondingGPPMap[rr.CivUniqueDistrictType] or {};
				table.insert(udData, row.GreatPersonClassType);
				DistrictCorrespondingGPPMap[rr.CivUniqueDistrictType] = udData;
			end
		end
	end
end
InitDistrictCorrespondingGPPMap();
Utils.DistrictCorrespondingGPPMap = DistrictCorrespondingGPPMap;

-- 历史时刻分类
local MomentClassificationMap = {};
function InitMomentClassificationMap()
	for row in GameInfo.HD_Moment_Classification() do
		local map = MomentClassificationMap[row.MomentClassificationType] or {};
		map[row.MomentType] = true;
		MomentClassificationMap[row.MomentClassificationType] = map;
	end

	-- Debug
	print('=======================================================================')
	print('文明首次发展类历史记录：')
	for momentType, _ in pairs(MomentClassificationMap['MOMENT_CLASSIFICATION_CIVILIZATION_FIRST']) do
		if MomentClassificationMap['MOMENT_CLASSIFICATION_DEVELOPMENT'][momentType] == true then
			print(Locale.Lookup(GameInfo.Moments[momentType].Name));
		end
	end
	print('=======================================================================')
	print('文明首次发展类历史记录：')
	for momentType, _ in pairs(MomentClassificationMap['MOMENT_CLASSIFICATION_WORLD_FIRST']) do
		if MomentClassificationMap['MOMENT_CLASSIFICATION_DEVELOPMENT'][momentType] == true then
			print(Locale.Lookup(GameInfo.Moments[momentType].Name));
		end
	end
	print('=======================================================================')
end
InitMomentClassificationMap();
Utils.MomentClassificationMap = MomentClassificationMap;