Utils = ExposedMembers.DLHD.Utils;

-- ==============================================================================================
local RegionalBuildingList = {};
function InitRegionalBuildingList()
	-- print("================================================================")
	-- print("辐射建筑：")
	for row in GameInfo.HD_BuildingRegionalYields() do
		if not RegionalBuildingList[row.BuildingType] then
			local buildingInfo = GameInfo.Buildings[row.BuildingType];
			-- print(Locale.Lookup(buildingInfo.Name));

			RegionalBuildingList[row.BuildingType] = {};
			RegionalBuildingList[row.BuildingType].Index = buildingInfo.Index;
			RegionalBuildingList[row.BuildingType].RegionalRange = GameInfo.HD_BuildingRegionalRange[row.BuildingType].RegionalRange;

			if buildingInfo.IsWonder then
				RegionalBuildingList[row.BuildingType].PrereqDistrict = 'DISTRICT_WONDER';
			elseif buildingInfo.PrereqDistrict then
				RegionalBuildingList[row.BuildingType].PrereqDistrict = buildingInfo.PrereqDistrict;
			end
			
		end

		if not RegionalBuildingList[row.BuildingType].YieldList then
			RegionalBuildingList[row.BuildingType].YieldList = {};
		end
		table.insert(RegionalBuildingList[row.BuildingType].YieldList, {
			YieldType = row.YieldType,
			YieldChange = row.YieldChange,
			RequiresPower = row.RequiresPower,
			PrereqTech = row.PrereqTech and GameInfo.Technologies[row.PrereqTech].Index or nil,
			PrereqCivic = row.PrereqCivic and GameInfo.Civics[row.PrereqCivic].Index or nil
		})
	end
end
Utils.RegionalBuildingList = RegionalBuildingList;
-- ==============================================================================================

local CITY_CENTER_INDEX = GameInfo.Districts['DISTRICT_CITY_CENTER'].Index;

local SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_TAG = 'HD_SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_';

local SINGLE_BUILDING_PROVIDE_REGIONAL_YIELD_BONUS_TAG = 'HD_SINGLE_BUILDING_PROVIDE_REGIONAL_YIELD_BONUS_';
local SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_BONUS_TAG = 'HD_SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_BONUS_';
local ALL_DISTRICTS_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_TAG = 'HD_ALL_DISTRICTS_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_';
local SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_TAG = 'HD_SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_';

local ALL_DISTRICTS_RECEIVE_REGIONAL_YIELD_SCALING_FACTOR_TAG = 'HD_ALL_DISTRICTS_RECEIVE_REGIONAL_YIELD_SCALING_FACTOR_';
local SINGLE_DISTRICT_RECEIVE_REGIONAL_YIELD_SCALING_FACTOR_TAG = 'HD_SINGLE_DISTRICT_RECEIVE_REGIONAL_YIELD_SCALING_FACTOR_';

local PLOT_BINARY_COMPRESS_TAG = 'HD_PLOT_BINARY_COMPRESS_RECEIVE_REGIONAL_';

local CITY_REGIONAL_YIELDS_RECORD_TAG = 'HD_CITY_REGIONAL_YIELDS_RECORD';
function RefreshRegionalYield(playerId)
	local player = Players[playerId];

	print("================================================================")
	-- 遍历记录所有辐射建筑位置
	local buildingList = {};
	for _, city in player:GetCities():Members() do
		for buildingType, data in pairs(RegionalBuildingList) do
			if city:GetBuildings():HasBuilding(data.Index) and not city:GetBuildings():IsPillaged(data.Index) then
				local plot = Map.GetPlotByIndex(city:GetBuildings():GetBuildingLocation(data.Index));
				local regionalRange = data.RegionalRange;
				if data.PrereqDistrict then
					regionalRange = regionalRange + (city:GetProperty(SINGLE_DISTRICT_EXTRA_REGIONAL_RANGE_TAG .. data.PrereqDistrict) or 0)
				end

				local yieldList = {};
				-- 判断科技、市政、供电前置
				for _, yieldData in ipairs(data.YieldList) do
					if (not yieldData.PrereqTech or player:GetTechs():HasTech(yieldData.PrereqTech))
					and (not yieldData.PrereqCivic or player:GetCulture():HasCivic(yieldData.PrereqCivic))
					and (not yieldData.RequiresPower or Utils.IsCityFullyPowered(playerId, city:GetID())) then
						-- TODO：根据本城的Property对辐射产出进行修正
						local yieldChange = yieldData.YieldChange;

						-- 加区：英国、官邸、桑弘羊、艾达等
						local add1 = 0;
						local add2 = 0;
						if not yieldData.RequiresPower then
							add1 = city:GetProperty(SINGLE_BUILDING_PROVIDE_REGIONAL_YIELD_BONUS_TAG .. buildingType .. '_' .. yieldData.YieldType) or 0;
							add2 = city:GetProperty(SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_BONUS_TAG .. data.PrereqDistrict .. '_' .. yieldData.YieldType) or 0;
						else
							add1 = city:GetProperty(SINGLE_BUILDING_PROVIDE_REGIONAL_YIELD_BONUS_TAG .. buildingType .. '_' .. yieldData.YieldType .. '_POWERED') or 0;
							add2 = city:GetProperty(SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_BONUS_TAG .. data.PrereqDistrict .. '_' .. yieldData.YieldType .. '_POWERED') or 0;
						end

						-- 玩家乘区：墨西哥城
						local factor1 = 1 + (city:GetProperty(ALL_DISTRICTS_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_TAG .. yieldData.YieldType) or 0)/100;

						-- 单城乘区
						local factor2 = 1 + (city:GetProperty(SINGLE_DISTRICT_PROVIDE_REGIONAL_YIELD_SCALING_FACTOR_TAG .. data.PrereqDistrict .. '_' .. yieldData.YieldType) or 0)/100;

						-- 产出计算
						yieldChange = math.max(((yieldChange + add1 + add2) * factor1 * factor2), 0);

						print("----------------------------------")
						print(Locale.Lookup(city:GetName()) .. " " .. Locale.Lookup(GameInfo.Buildings[buildingType].Name))
						if add1 ~= 0 then print("建筑加区 " .. add1); end
						if add2 ~= 0 then print("区域加区 " .. add2); end
						if factor1 ~= 1 then print("玩家乘区 " .. factor1); end
						if factor2 ~= 1 then print("单城乘区 " .. factor2); end
						print(yieldChange .. Locale.Lookup('LOC_' .. yieldData.YieldType .. '_NAME'))

						if yieldChange > 0 then
							table.insert(yieldList, {
								YieldType = yieldData.YieldType,
								YieldChange = yieldChange,
								RequiresPower = yieldData.RequiresPower
							});
						end
					end
				end

				if #yieldList > 0 then
					table.insert(buildingList, {
						BuildingType = buildingType,
						X = plot:GetX(),
						Y = plot:GetY(),
						RegionalRange = regionalRange,
						YieldList = yieldList,
						CityName = city:GetName(),
						PrereqDistrict = data.PrereqDistrict
					})
				end
			end
		end
	end

	print("================================================================")
	-- 遍历所有城市
	for _, city in player:GetCities():Members() do
		local yields = {};
		for row in GameInfo.HD_BuildingRegionalYieldTypes() do
			yields[row.YieldType] = 0;
		end
		local recordList = {};
		
		-- 依次判断各个辐射建筑 统计产出
		for _, buildingData in ipairs(buildingList) do
			local inRange = false;

			-- 市中心和社区位置
			local districtsNum = city:GetDistricts():GetNumDistricts();
			for index = 0, districtsNum - 1 do
				local district = city:GetDistricts():GetDistrictByIndex(index);
				if district and (district:GetType() == CITY_CENTER_INDEX or
				(Utils.IsDistrictType(district:GetType(), 'DISTRICT_NEIGHBORHOOD') and district:IsComplete() and not district:IsPillaged())) then
					local distance = Map.GetPlotDistance(district:GetX(), district:GetY(), buildingData.X, buildingData.Y);
					if distance <= buildingData.RegionalRange then
						inRange = true;
						break;
					end
				end
			end

			if inRange then
				for _, yieldData in ipairs(buildingData.YieldList) do
					-- 判断是否是同等条件下受到的最高产出
					local requiresPower = yieldData.RequiresPower and 'POWERED' or 'COMMON';
					if not recordList[buildingData.BuildingType] then
						recordList[buildingData.BuildingType] = {};
					end
					if not recordList[buildingData.BuildingType][yieldData.YieldType] then
						recordList[buildingData.BuildingType][yieldData.YieldType] = {};
					end
					if not recordList[buildingData.BuildingType][yieldData.YieldType][requiresPower] then
						recordList[buildingData.BuildingType][yieldData.YieldType][requiresPower] = {};
					end
					local amount = recordList[buildingData.BuildingType][yieldData.YieldType][requiresPower].Amount or 0;

					local yieldChange = yieldData.YieldChange;
					-- 玩家乘区：官邸
					local factor1 = 1 + (city:GetProperty(ALL_DISTRICTS_RECEIVE_REGIONAL_YIELD_SCALING_FACTOR_TAG .. yieldData.YieldType) or 0)/100;

					-- 单城乘区
					local factor2 = 1 + (city:GetProperty(SINGLE_DISTRICT_RECEIVE_REGIONAL_YIELD_SCALING_FACTOR_TAG .. buildingData.PrereqDistrict .. '_' .. yieldData.YieldType) or 0)/100;

					yieldChange = math.ceil(math.max((yieldChange * factor1 * factor2), 0));

					if yieldChange > amount then
						-- 累加产出
						yields[yieldData.YieldType] = yields[yieldData.YieldType] + (yieldChange - amount);
						
						-- 记录产出来源
						if amount == 0 then
							print(
								Locale.Lookup(city:GetName()) .. " 收到辐射 来自 " .. 
								Locale.Lookup(buildingData.CityName) .. " " .. 
								Locale.Lookup(GameInfo.Buildings[buildingData.BuildingType].Name) .. " " ..
								yieldChange .. Locale.Lookup('LOC_' .. yieldData.YieldType .. '_NAME') .. " " ..
								requiresPower
							)
						else
							print(
								Locale.Lookup(city:GetName()) .. " 收到更高的辐射 来自 " .. 
								Locale.Lookup(buildingData.CityName) .. " " .. 
								Locale.Lookup(GameInfo.Buildings[buildingData.BuildingType].Name) .. " " ..
								yieldChange .. Locale.Lookup('LOC_' .. yieldData.YieldType .. '_NAME') .. " " ..
								requiresPower
							)
						end
						
						recordList[buildingData.BuildingType][yieldData.YieldType][requiresPower] = {
							Amount = yieldChange,
							CityName = buildingData.CityName
						}
					end
				end
			end
		end

		-- 设置 Plot Property
		local plot = Map.GetPlot(city:GetX(), city:GetY());
		for yieldType, yieldChange in pairs(yields) do
			if plot then
				Utils.BinaryCompress(yieldChange, plot, PLOT_BINARY_COMPRESS_TAG .. yieldType);
			end
		end

		-- 记录辐射产出 供UI端查看
		city:SetProperty(CITY_REGIONAL_YIELDS_RECORD_TAG, recordList);
	end
end
Utils.RefreshRegionalYield = RefreshRegionalYield;

local pendingRefresh = {};
function RefreshRegionalYieldIfPending(playerId)
	if (pendingRefresh[playerId] == nil) or (pendingRefresh[playerId] == 1) then
		RefreshRegionalYield(playerId);
		pendingRefresh[playerId] = 0;
	end
end

function Initialize ()
	InitRegionalBuildingList();

	Events.CitySelectionChanged.Add(function (playerId)
		RefreshRegionalYieldIfPending(playerId);
	end);
	
	GameEvents.PlayerTurnStarted.Add(RefreshRegionalYieldIfPending);
  GameEvents.OnPlayerTurnEnded.Add(RefreshRegionalYieldIfPending);

	Events.BuildingAddedToMap.Add(function (x, y, buildingId, playerId, misc2, misc3)
		pendingRefresh[playerId] = 1;
	end);
	GameEvents.BuildingPillageStateChanged.Add(function (playerId, cityId, buildingId, pillageState)
		pendingRefresh[playerId] = 1;
	end);
	Events.DistrictAddedToMap.Add(function (playerId, districtId, cityId, x, y, districtType, percentComplete)
		pendingRefresh[playerId] = 1;
	end);
	Events.DistrictRemovedFromMap.Add(function (playerId, districtId, cityId, x, y, districtType)
		pendingRefresh[playerId] = 1;
	end);
	Events.CityAddedToMap.Add(function (playerId, cityId, x, y)
		pendingRefresh[playerId] = 1;
	end);
	Events.GovernorEstablished.Add(function (cityOwner, cityId, governorOwner, governorId)
		pendingRefresh[governorOwner] = 1;
	end);
	Events.GovernorPromoted.Add(function (playerId, governorId, promotionId)
		pendingRefresh[playerId] = 1;
	end);
	Events.GovernorChanged.Add(function (playerId, governorId)
		pendingRefresh[playerId] = 1;
	end);
	Events.GovernmentPolicyChanged.Add(function (playerId, policyId)
		pendingRefresh[playerId] = 1;
	end);
	Events.UnitGreatPersonActivated.Add(function (playerId, unitId, greatPersonClassId, greatPersonIndividualId)
		pendingRefresh[playerId] = 1;
	end);
	Events.InfluenceGiven.Add(function (citystateId, playerId)
		pendingRefresh[playerId] = 1;
	end);
end

Events.LoadGameViewStateDone.Add(Initialize);