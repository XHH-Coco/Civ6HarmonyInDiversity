ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

-- =====================================================================================================================================
-- 国防部
-- =====================================================================================================================================
local BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE_TAG = 'HD_MINISTRY_OF_NATIONAL_DEFENSE_'
function MinistryOfNationalDefense(playerId, cityId, type, objectId, cancelled)
  local player = Players[playerId]
	local unit = GameInfo.Units[objectId]
	if (unit.FormationClass == 'FORMATION_CLASS_LAND_COMBAT'
			or unit.FormationClass == 'FORMATION_CLASS_NAVAL'
			or unit.FormationClass == 'FORMATION_CLASS_AIR') then
		if player:GetProperty(BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE_TAG .. unit.UnitType) ~= 1 then
			player:AttachModifierByID('HD_MND_SCIENCE')
			player:AttachModifierByID('HD_MND_PRODUCTION')
			player:SetProperty(BUILDING_HD_MINISTRY_OF_NATIONAL_DEFENSE_TAG .. unit.UnitType, 1)
		end
	end
end
function MinistryOfNationalDefenseProduction(playerId, cityId, type, objectId, cancelled)
  if type == 0 then
    MinistryOfNationalDefense(playerId, cityId, type, objectId)
  end
end
Events.CityProductionCompleted.Add(MinistryOfNationalDefenseProduction)
function MinistryOfNationalDefensePurchase(playerId, cityId, x, y, type, objectId)
  if type == EventSubTypes.UNIT then
    MinistryOfNationalDefense(playerId, cityId, type, objectId)
  end
end
Events.CityMadePurchase.Add(MinistryOfNationalDefensePurchase)

-- =====================================================================================================================================
-- 数据中心
-- =====================================================================================================================================
local BUILDING_HD_DATA_CENTER_INDEX = GameInfo.Buildings['BUILDING_HD_DATA_CENTER'].Index
local BUILDING_HD_DATA_CENTER_TAG = 'HD_DATA_CENTER'
function DataCenter(playerId, cityId, buildingId, plotId, bOriginalConstruction)
	if buildingId == BUILDING_HD_DATA_CENTER_INDEX then
		local player = Players[playerId]

		if player:GetProperty(BUILDING_HD_DATA_CENTER_TAG) ~= 1 then
			local alivePlayers = PlayerManager.GetAliveMajorIDs()
			for _, alivePlayerId in ipairs(alivePlayers) do
				if playerId ~= alivePlayerId then
					local level = Utils.GetAllianceLevelBetweenPlayers(playerId, alivePlayerId);
					if level == 3 then
						player:AttachModifierByID('HD_DATA_CENTER_SCIENCE')
						player:AttachModifierByID('HD_DATA_CENTER_CULTURE')
					end
				end
			end

			player:SetProperty(BUILDING_HD_DATA_CENTER_TAG, 1)
		end
	end
end
GameEvents.BuildingConstructed.Add(DataCenter)

-- =====================================================================================================================================
-- 纺织会馆
-- =====================================================================================================================================
local BUILDING_SUKIENNICE = GameInfo.Buildings['BUILDING_SUKIENNICE'];
local PLAYER_HAS_SUKIENNICE_TAG = 'HD_PLAYER_HAS_SUKIENNICE';
local SUKIENNICE_X = 'HD_SUKIENNICE_X';
local SUKIENNICE_Y = 'HD_SUKIENNICE_Y';
function SukienniceConstructed(playerId, cityId, buildingId, plotId, bOriginalConstruction)
	if BUILDING_SUKIENNICE and buildingId == BUILDING_SUKIENNICE.Index then
		local player = Players[playerId];
		local plot = Map.GetPlotByIndex(plotId);
		if player and plot then
			player:SetProperty(SUKIENNICE_X, plot:GetX());
			player:SetProperty(SUKIENNICE_Y, plot:GetY());
			SukienniceAdjacencyChange(playerId)
		end
	end
end
GameEvents.BuildingConstructed.Add(SukienniceConstructed)

-- 判断商业相邻加成
local SUKIENNICE_TRADE_ROUTE_NUM = GlobalParameters.HD_SUKIENNICE_TRADE_ROUTE_NUM or 0;
local SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_PERCENTAGE = GlobalParameters.HD_SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_PERCENTAGE or 0;
local SUKIENNICE_INTERNATIONAL_TRADE_GOLD_PERCENTAGE = GlobalParameters.HD_SUKIENNICE_INTERNATIONAL_TRADE_GOLD_PERCENTAGE or 0;
local YIELD_GOLD_INDEX = GameInfo.Yields["YIELD_GOLD"].Index;
function SukienniceAdjacencyChange(playerId)
	local player = Players[playerId];
	if player and player:GetProperty(PLAYER_HAS_SUKIENNICE_TAG) == 1 then
		local x = player:GetProperty(SUKIENNICE_X) or -1;
		local y = player:GetProperty(SUKIENNICE_Y) or -1;
		local plot = Map.GetPlot(x, y);
		if plot then
			local districtId = plot:GetDistrictID();
			local adjacency = Utils.GetDistrictAdjacencyYield(playerId, districtId, YIELD_GOLD_INDEX);
			if adjacency > 0 then
				-- 商队容量
				if SUKIENNICE_TRADE_ROUTE_NUM > 0 then
					local amount = math.floor(adjacency/SUKIENNICE_TRADE_ROUTE_NUM);
					print("纺织会馆 商队容量", amount)
					Utils.BinaryCompress(amount, plot, 'HD_PLOT_BINARY_COMPRESS_SUKIENNICE_1');
				end
				-- 内商产出
				if SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_PERCENTAGE > 0 then
					local amount = math.floor(adjacency*SUKIENNICE_DOMESTIC_TRADE_PRODUCTION_PERCENTAGE/100)
					print("纺织会馆 内商产出", amount)
					Utils.BinaryCompress(amount, plot, 'HD_PLOT_BINARY_COMPRESS_SUKIENNICE_2');
				end
				-- 外商产出
				if SUKIENNICE_INTERNATIONAL_TRADE_GOLD_PERCENTAGE > 0 then
					local amount = math.floor(adjacency*SUKIENNICE_INTERNATIONAL_TRADE_GOLD_PERCENTAGE/100)
					print("纺织会馆 外商产出", amount)
					Utils.BinaryCompress(amount, plot, 'HD_PLOT_BINARY_COMPRESS_SUKIENNICE_3');
				end
			end
		end
	end
end

-- 触发判断商业相邻加成
function SukienniceOnGameTurnEnded()
	for _, playerId in ipairs(PlayerManager.GetAliveMajorIDs()) do
		SukienniceAdjacencyChange(playerId)
	end
end
GameEvents.OnGameTurnEnded.Add(SukienniceOnGameTurnEnded)

function SukienniceOnDistrictConstructed(playerId, districtId, x, y)
	SukienniceAdjacencyChange(playerId)
end
GameEvents.OnDistrictConstructed.Add(SukienniceOnDistrictConstructed)

function SukienniceCityFocusChanged(playerId, cityId)
	SukienniceAdjacencyChange(playerId)
end
Events.CityFocusChanged.Add(SukienniceCityFocusChanged)

function SukienniceGovernmentPolicyChanged(playerId, policyId)
	SukienniceAdjacencyChange(playerId)
end
Events.GovernmentPolicyChanged.Add(SukienniceGovernmentPolicyChanged);

-- 建立外商
local CITY_HAS_SUKIENNICE_TAG = 'HD_CITY_HAS_SUKIENNICE';
local CITY_SUKIENNICE_ALREADY_TAG = 'HD_CITY_SUKIENNICE_ALREADY_';
local CITY_HAS_IMPROVED_TAG = 'HD_CITY_HAS_IMPROVED_'
function SukienniceTradeRouteActivityChanged(playerId, originPlayerId, originCityId, targetPlayerId, targetCityId)
	if originPlayerId ~= targetPlayerId then
		local city = CityManager.GetCity(originPlayerId, originCityId);
		local targetCity = CityManager.GetCity(targetPlayerId, targetCityId);
		if city and city:GetProperty(CITY_HAS_SUKIENNICE_TAG) == 1
		and targetCity and targetCity:GetProperty(CITY_SUKIENNICE_ALREADY_TAG .. originPlayerId) ~= 1 then
			local player = Players[originPlayerId];
			local x = player:GetProperty(SUKIENNICE_X) or -1;
			local y = player:GetProperty(SUKIENNICE_Y) or -1;
			local plot = Map.GetPlot(x, y);

			if plot then
				local resourceList = {};
				-- 随机选取奢侈资源
				local cityResourceList = Utils.GetCityPlotsResources(targetCity:GetOwner(), targetCity:GetID());

				for resourceType, has in pairs(cityResourceList) do
					if has == true then
						local row = GameInfo.Resources[resourceType];
						if row and row.ResourceClassType == 'RESOURCECLASS_LUXURY' then
							print("纺织会馆 创建国际商路 目的地拥有", Locale.Lookup(row.Name))
							table.insert(resourceList, {
								ResourceType = resourceType,
								Name = row.Name
							})
						end
					end
				end

				if #resourceList == 0 then
					print("纺织会馆 创建国际商路 目的地没有任何资源")
					return;
				end

				local randomIndex = Game.GetRandNum(#resourceList, "Random Sukiennice Resource for Player " .. playerId) + 1;
				local resourceInfo = resourceList[randomIndex];
				local msg = '[ICON_' .. resourceInfo.ResourceType .. ']' .. Locale.Lookup(resourceInfo.Name);
				-- 复制资源
				player:AttachModifierByID('HD_GRANT_' .. resourceInfo.ResourceType)
				-- 获得产出
				for row in GameInfo.Resource_YieldChanges() do
					if row.ResourceType == resourceInfo.ResourceType then
						if row.YieldChange > 0 then
							for i=1,row.YieldChange,1 do
								player:AttachModifierByID('HD_SUKIENNICE_' .. row.YieldType)
							end
							msg = msg .. ' +' .. row.YieldChange .. ' [ICON_' .. string.sub(row.YieldType, 7) .. ']'
						end
					end
				end
				-- 文本提示
				Game.AddWorldViewText(originPlayerId, msg, x, y)
			end
		end
	end
end
Events.TradeRouteActivityChanged.Add(SukienniceTradeRouteActivityChanged);

-- =====================================================================================================================================
-- 伊斯兰大学
-- =====================================================================================================================================
local BUILDING_MADRASA_INDEX = GameInfo.Buildings['BUILDING_MADRASA'].Index;
local PLAYER_HAS_MADRASA_TAG = 'HD_PLAYER_HAS_MADRASA';
local MADRASA_X = 'HD_MADRASA_X';
local MADRASA_Y = 'HD_MADRASA_Y';
local MADRASA_CAMPUS_ADJACENCY_NUM = GlobalParameters.HD_MADRASA_CAMPUS_ADJACENCY_NUM or 0;
local MADRASA_THEATER_ADJACENCY_NUM = GlobalParameters.HD_MADRASA_THEATER_ADJACENCY_NUM or 0;
function MadrasaConstructed(playerId, cityId, buildingId, plotId, bOriginalConstruction)
	if buildingId == BUILDING_MADRASA_INDEX then
		local player = Players[playerId];
		local plot = Map.GetPlotByIndex(plotId);
		if player and plot then
			player:SetProperty(MADRASA_X, plot:GetX());
			player:SetProperty(MADRASA_Y, plot:GetY());
			local playerList = Game:GetProperty(PLAYER_HAS_MADRASA_TAG) or {};
			table.insert(playerList, playerId);
			Game:SetProperty(PLAYER_HAS_MADRASA_TAG, playerList);

			MadrasaCityReligionFollowersChanged()
			MadrasaGovernmentPolicyChanged(playerId)
		end
	end
end
GameEvents.BuildingConstructed.Add(MadrasaConstructed)

-- 信教城市数量
function MadrasaCityReligionFollowersChanged(cityOwnerId, cityId, eVisibility)
	local playerList = Game:GetProperty(PLAYER_HAS_MADRASA_TAG) or {};
	for _, playerId in ipairs(playerList) do
		print("拥有伊斯兰学校的玩家", playerId)
		local player = Players[playerId];
		local playerReligion = player:GetReligion():GetReligionTypeCreated();
		if playerReligion ~= -1 then
			-- 统计信教城数
			local cityAmount = 0;
			for _, majorPlayer in ipairs(PlayerManager.GetAlive()) do
				for _, city in majorPlayer:GetCities():Members() do
					if city:GetReligion():GetMajorityReligion() == playerReligion then
						cityAmount = cityAmount + 1;
					end
				end
			end

			local x = player:GetProperty(MADRASA_X) or -1;
			local y = player:GetProperty(MADRASA_Y) or -1;
			local plot = Map.GetPlot(x, y);
			local amount = math.floor(cityAmount*MADRASA_CAMPUS_ADJACENCY_NUM);
			print("伊斯兰学校 学院相邻", amount)
			Utils.BinaryCompress(amount, plot, 'HD_PLOT_BINARY_COMPRESS_MADRASA_1');

			plot:SetProperty('HD_MADRASA_FAITH_PURCHASE_CAMPUS', cityAmount);
		end
	end
end
Events.CityReligionFollowersChanged.Add(MadrasaCityReligionFollowersChanged);

-- 文化政策数量
local CulturePolicySlotIndex = GameInfo.GovernmentSlots['SLOT_DIPLOMATIC'].Index;
function MadrasaGovernmentPolicyChanged(playerId, policyId)
	local player = Players[playerId];
	if player and player:GetProperty(PLAYER_HAS_MADRASA_TAG) == 1 then
		-- 统计文化政策槽位数量
		local culturePolicySlotNum = 0;
		local policySlots = player:GetCulture():GetNumPolicySlots();
		for i = 0, policySlots-1, 1 do
			local slotType = Utils.GetPolicySlotType(playerId, i);
			if slotType == CulturePolicySlotIndex then
				culturePolicySlotNum = culturePolicySlotNum + 1;
			end
		end

		local x = player:GetProperty(MADRASA_X) or -1;
		local y = player:GetProperty(MADRASA_Y) or -1;
		local plot = Map.GetPlot(x, y);
		local amount = math.floor(culturePolicySlotNum*MADRASA_THEATER_ADJACENCY_NUM);
		print("伊斯兰学校 剧院相邻", amount)
		Utils.BinaryCompress(amount, plot, 'HD_PLOT_BINARY_COMPRESS_MADRASA_2');

		plot:SetProperty('HD_MADRASA_FAITH_PURCHASE_THEATER', culturePolicySlotNum);
	end
end
Events.GovernmentPolicyChanged.Add(MadrasaGovernmentPolicyChanged);

-- =====================================================================================================================================
-- 自然环境保护部
-- =====================================================================================================================================
local BUILDING_SANCTUARY = GameInfo.Buildings['BUILDING_SANCTUARY'];

function SanctuaryConstructed(playerId, cityId, buildingId, plotId, bOriginalConstruction)
	if BUILDING_SANCTUARY and buildingId == BUILDING_SANCTUARY.Index then
		local city = CityManager.GetCity(playerId, cityId);
		if not city then return; end

		local validResourceList = {};
		local cityPlots = city:GetOwnedPlots();
		for _, plot in pairs(cityPlots) do
			if plot then
				local resourceId = plot:GetResourceType();
				-- 判断是否为生物类资源
				if resourceId ~= nil and resourceId ~= -1 and Utils.IsResourceVisible(playerId, resourceId)
				and Utils.IsResourceHasClassification(resourceId, 'RESOURCE_CLASSIFICATION_BIOLOGICAL') == true then
					print("保护部 本城生物资源" .. Locale.Lookup(GameInfo.Resources[resourceId].Name))
					-- 判断一环内是否有合法单元格
					local vaildPlots = {};

					for direction = 0, 5 do
						local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
						if adjacentPlot then
							local districtId = adjacentPlot:GetDistrictType();
							local improvementId = adjacentPlot:GetImprovementType();

							if (districtId == nil or districtId == -1)
							and (improvementId == nil or improvementId == -1)
							and ResourceBuilder.CanHaveResource(adjacentPlot, resourceId) then
								table.insert(vaildPlots, adjacentPlot);
							end
						end
					end

					print("一环内有" .. #vaildPlots .. "个可用单元格")
					if #vaildPlots > 0 then
						table.insert(validResourceList, {
							resourceId = resourceId,
							vaildPlots = vaildPlots
						})
					end
					
				end
			end
		end

		if #validResourceList > 0 then
			local randomResourceIndex = Game.GetRandNum(#validResourceList, "Sanctuary Get Random Resource For Player " .. playerId) + 1
			local resourceId = validResourceList[randomResourceIndex].resourceId;
			local vaildPlots = validResourceList[randomResourceIndex].vaildPlots;
			local randomPlotIndex = Game.GetRandNum(#vaildPlots, "Sanctuary Get Random Plot For Player " .. playerId) + 1
			local targetPlot = vaildPlots[randomPlotIndex];
			
			local resourceInfo = GameInfo.Resources[resourceId];
			if resourceInfo then
				Utils.GenerateResource(targetPlot, resourceId);
				local msg = '[ICON_' .. resourceInfo.ResourceType .. ']' .. Locale.Lookup(resourceInfo.Name);
				Game.AddWorldViewText(playerId, Locale.Lookup('LOC_BUILDING_SANCTUARY_TEXT', msg), targetPlot:GetX(), targetPlot:GetY());
			end
		end

	end
end
GameEvents.BuildingConstructed.Add(SanctuaryConstructed)

-- =====================================================================================================================================
-- 中心医院
-- =====================================================================================================================================
local PLAYER_HAS_JNR_HOSPITAL_TAG = 'HD_PLAYER_HAS_JNR_HOSPITAL';
local JNR_HOSPITAL_PREVENT_POP_LOST_TAG = 'HD_JNR_HOSPITAL_PREVENT_POP_LOST';
local JNR_HOSPITAL_EXTRA_POP_BOOST_TAG = 'HD_JNR_HOSPITAL_EXTRA_POP_BOOST';
local NOTIFICATION_JNR_HOSPITAL_PREVENT_POP_LOST_HASH = GameInfo.Types['NOTIFICATION_JNR_HOSPITAL_PREVENT_POP_LOST'].Hash;
local NOTIFICATION_JNR_HOSPITAL_EXTRA_POP_BOOST_HASH = GameInfo.Types['NOTIFICATION_JNR_HOSPITAL_EXTRA_POP_BOOST'].Hash;
local JNR_HOSPITAL_PREVENT_POP_LOST_CHANCE = GlobalParameters.HD_JNR_HOSPITAL_PREVENT_POP_LOST_CHANCE or 0;
local JNR_HOSPITAL_EXTRA_POP_BOOST_CHANCE = GlobalParameters.HD_JNR_HOSPITAL_EXTRA_POP_BOOST_CHANCE or 0;

function HospitalCityPopulationChanged(playerId, cityId, changeAmount)
  local player = Players[playerId]
	if not player then return; end
	local hasHospital = player:GetProperty(PLAYER_HAS_JNR_HOSPITAL_TAG) or 0;

	local city = CityManager.GetCity(playerId, cityId);
	if not city then return; end

	if hasHospital > 0 then
		print(Locale.Lookup(city:GetName()) .. " 人口变化 " .. changeAmount);

		if changeAmount < 0 and JNR_HOSPITAL_PREVENT_POP_LOST_CHANCE > 0 then
			-- 防止人口损失
			local randomIndex = Game.GetRandNum(100, "Hospital Prevent Population Lost for Player " .. playerId) + 1;
			print("中心医院 " .. Locale.Lookup(city:GetName()) .. " 防止人口损失 随机数 " .. randomIndex);
			if randomIndex / 100 <= JNR_HOSPITAL_PREVENT_POP_LOST_CHANCE then
				print("中心医院 " .. Locale.Lookup(city:GetName()) .. " 城市损失" .. (-changeAmount) .. "人口")
				city:SetProperty(JNR_HOSPITAL_PREVENT_POP_LOST_TAG, 1)
				city:ChangePopulation(-changeAmount)
				Utils.SendMergableNotification(playerId, NOTIFICATION_JNR_HOSPITAL_PREVENT_POP_LOST_HASH, Locale.Lookup('LOC_BUILDING_JNR_HOSPITAL_PREVENT_POP_LOST_VIEWTEXT'), Locale.Lookup(city:GetName()), ', ')
			end
		elseif changeAmount > 0 and JNR_HOSPITAL_EXTRA_POP_BOOST_CHANCE > 0 then
			if city:GetProperty(JNR_HOSPITAL_PREVENT_POP_LOST_TAG) == 1 then
				city:SetProperty(JNR_HOSPITAL_PREVENT_POP_LOST_TAG, 0);
				print("中心医院 " .. Locale.Lookup(city:GetName()) .. " 城市补偿" .. changeAmount .. "人口")
			elseif city:GetProperty(JNR_HOSPITAL_EXTRA_POP_BOOST_TAG) == 1 then
				city:SetProperty(JNR_HOSPITAL_EXTRA_POP_BOOST_TAG, 0);
				print("中心医院 " .. Locale.Lookup(city:GetName()) .. " 已额外增长人口")
			else
				-- 增长人口有概率额外增长一个
				local randomIndex = Game.GetRandNum(100, "Hospital Extra Population Boost for Player " .. playerId) + 1;
				print("中心医院 " .. Locale.Lookup(city:GetName()) .. " 额外人口增长 随机数 " .. randomIndex);
				if randomIndex / 100 <= JNR_HOSPITAL_EXTRA_POP_BOOST_CHANCE then
					city:SetProperty(JNR_HOSPITAL_EXTRA_POP_BOOST_TAG, 1)
					city:ChangePopulation(1);
					print("中心医院 " .. Locale.Lookup(city:GetName()) .. " 城市额外增长1人口")
					Utils.SendMergableNotification(playerId, NOTIFICATION_JNR_HOSPITAL_EXTRA_POP_BOOST_HASH, Locale.Lookup('LOC_BUILDING_JNR_HOSPITAL_EXTRA_POP_BOOST_VIEWTEXT'), Locale.Lookup(city:GetName()), ', ')
				end
			end
		end
	end
end
GameEvents.OnCityPopulationChanged.Add(HospitalCityPopulationChanged)