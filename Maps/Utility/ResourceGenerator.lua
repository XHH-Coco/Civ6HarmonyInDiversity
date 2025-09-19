------------------------------------------------------------------------------
--	FILE:               ResourceGenerator.lua
--	ORIGNIAL AUTHOR:    Ed Beach
--	PURPOSE:            Default method for resource placement
------------------------------------------------------------------------------
--	Copyright (c) 2014 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include "MapEnums"
include "MapUtilities"

------------------------------------------------------------------------------
ResourceGenerator = {};
------------------------------------------------------------------------------
function ResourceGenerator.Create(args)

	print ("In ResourceGenerator.Create()");
	print ("    Placing resources");

	-- create instance data
	local instance = {
			
		-- methods
		__InitResourceData		= ResourceGenerator.__InitResourceData,
		__FindValidLocs			= ResourceGenerator.__FindValidLocs,
		__GetLuxuryResources	= ResourceGenerator.__GetLuxuryResources,
		__PrepareContinentsData	= ResourceGenerator.__PrepareContinentsData, -- HD
		__ValidLuxuryPlots		= ResourceGenerator.__ValidLuxuryPlots,
		__PlaceLuxuryResources		= ResourceGenerator.__PlaceLuxuryResources,
		__ScoreLuxuryPlots			= ResourceGenerator.__ScoreLuxuryPlots,
		__GetWaterLuxuryResources			= ResourceGenerator.__GetWaterLuxuryResources,
		__SetWaterLuxury			= ResourceGenerator.__SetWaterLuxury,
		__PlaceWaterLuxury			= ResourceGenerator.__PlaceWaterLuxury,
		__GetStrategicResources	= ResourceGenerator.__GetStrategicResources,
		__ValidStrategicPlots		= ResourceGenerator.__ValidStrategicPlots,
		__ScoreStrategicPlots			= ResourceGenerator.__ScoreStrategicPlots,
		__PlaceStrategicResources		= ResourceGenerator.__PlaceStrategicResources,
		__GetWaterStrategicResources	= ResourceGenerator.__GetWaterStrategicResources,
		__SetWaterStrategic			= ResourceGenerator.__SetWaterStrategic,
		__PlaceWaterStrategic			= ResourceGenerator.__PlaceWaterStrategic,
		__GetOtherResources		= ResourceGenerator.__GetOtherResources,
		__PlaceOtherResources		= ResourceGenerator.__PlaceOtherResources,
		__GetWaterOtherResources		= ResourceGenerator.__GetWaterOtherResources,
		__PlaceWaterOtherResources		= ResourceGenerator.__PlaceWaterOtherResources,
		__RemoveOtherDuplicateResources		= ResourceGenerator.__RemoveOtherDuplicateResources,
		__RemoveDuplicateResources		= ResourceGenerator.__RemoveDuplicateResources,
		__CheckResources		= ResourceGenerator.__CheckResources,
		__ScorePlots			= ResourceGenerator.__ScorePlots,
		__ScoreWaterPlots			= ResourceGenerator.__ScoreWaterPlots,

		-- data
		iWaterLux = args.iWaterLux or 3;
		iWaterBonus = args.iWaterBonus or 1.25;
		iLuxuriesPerRegion = args.LuxuriesPerRegion or 4;
		resources = args.resources;

		iExtraBonusGroupOne = args.ExtraBonusGroupOne or {};
		iExtraBonusGroupTwo = args.ExtraBonusGroupTwo or {};
		iFewerBonusGroupOne = args.FewerBonusGroupOne or {};
		iFewerBonusGroupTwo = args.FewerBonusGroupTwo or {};
		iExtraBonusGroupOneMultiply = args.ExtraBonusGroupOneMultiply or 1;
		iExtraBonusGroupTwoMultiply = args.ExtraBonusGroupTwoMultiply or 1;
		iFewerBonusGroupOneMultiply = args.FewerBonusGroupOneMultiply or 1;
		iFewerBonusGroupTwoMultiply = args.FewerBonusGroupTwoMultiply or 1;

		iExtraLuxuries = args.ExtraLuxuries or {};
		--iHorsesAndIronMultiply = args.HorsesAndIronMultiply or 1;
		iHorsesMultiply = args.HorsesMultiply or 1;--调整马资源丰度
		iIronMultiply = args.IronMultiply or 1;--调整铁资源丰度
		iNiterMultiply = args.NiterMultiply or 1;--调整硝石资源丰度
		iCoalMultiply = args.CoalMultiply or 1;--调整煤炭资源丰度
		iOilMultiply = args.OilMultiply or 1;--调整石油资源丰度
		iAluminumMultiply = args.AluminumMultiply or 1;--调整铝资源丰度
		


		uiStartConfig = args.START_CONFIG or 2,

		iResourcesInDB      = 0;
		iNumContinents		= 0;
		iTotalValidPlots    = 0;
		iWaterPlots = 0;
		iFrequencyTotal     = 0;
		iFrequencyTotalWater     = 0;
		iFrequencyStrategicTotal     = 0;
		iFrequencyStrategicTotalWater    = 0;
		iTargetPercentage   = 30;
		iStandardPercentage = 30;
		iLuxuryPercentage   = 19.33;
		iStrategicPercentage   = 21.7;
		iOccurencesPerFrequency = 0;
		iNumWaterLuxuries = 0;
		iNumWaterStrategics = 0;
		bOdd = false;
		eResourceType		= {},
		eResourceClassType	= {},
		iFrequency          = {},
		iSeaFrequency          = {},
		aLuxuryType		= {},
		aLuxuryTypeCoast		= {},
		aStrategicType		= {},
		aOtherType		= {},
		aOtherTypeWater		= {},
		aStrategicTypeCoast = {},
		aIndex = {},
		aaPossibleLuxLocs		= {},
		aaPossibleStratLocs		= {},
		aaPossibleLocs		= {},
		aaPossibleWaterLocs		= {},
		aResourcePlacementOrderStrategic = {},
		aResourcePlacementOrder = {},
		aWaterResourcePlacementOrder = {},
		aPeakEra = {},
	};

	-- initialize instance data
	instance:__InitResourceData()
	
	-- Chooses and then places the land luxury resources
	instance:__GetLuxuryResources()

	-- Chooses and then places the water luxury resources
	instance:__GetWaterLuxuryResources()

	-- Chooses and then places the land strategic resources
	instance:__GetStrategicResources()

	-- Chooses and then places the water strategic resources
	instance:__GetWaterStrategicResources()

	-- Chooses and then places the other resources [other is now only bonus, but later could be resource types added through mods]
	instance:__GetOtherResources()

	-- Chooses and then places the water other resources [other is now only bonus, but later could be resource types added through mods]
	instance:__GetWaterOtherResources()

	-- Removes too many adjacent other resources.
	instance:__RemoveOtherDuplicateResources()

	return instance;
end
------------------------------------------------------------------------------
function ResourceGenerator:__InitResourceData()

	self.iResourcesInDB = 0;
	if (GameInfo.Maps[Map.GetMapSize()] ~= nil) then
		self.iLuxuriesThisSizeMap = GameInfo.Maps[Map.GetMapSize()].DefaultPlayers * 2;
	else
		self.iLuxuriesThisSizeMap = 12; -- Default size for Small map
	end

	-- Get resource value setting input by user.
	if self.resources == 1 then
			self.resources = -15;
	elseif self.resources == 3 then
			self.resources = 30;
	elseif self.resources == 4 then
		self.resources = TerrainBuilder.GetRandomNumber(45, "Random Resources - Lua") - 15;		--丰富
	else 
		self.resources = 0;
	end

	self.iTargetPercentage = self.iTargetPercentage + self.resources;


	for row in GameInfo.Resources() do
		self.eResourceType[self.iResourcesInDB] = row.Hash;
		self.aIndex[self.iResourcesInDB] = row.Index;
		self.eResourceClassType[self.iResourcesInDB] = row.ResourceClassType;
		self.aaPossibleLocs[self.iResourcesInDB] = {};
		self.aaPossibleWaterLocs[self.iResourcesInDB] = {};
		self.aaPossibleLuxLocs[self.iResourcesInDB] = {};
		self.aaPossibleStratLocs[self.iResourcesInDB] = {};
		self.iFrequency[self.iResourcesInDB] = row.Frequency;
		self.iSeaFrequency[self.iResourcesInDB] = row.SeaFrequency;
		self.aPeakEra[self.iResourcesInDB] = row.PeakEra;
		self.iResourcesInDB = self.iResourcesInDB + 1;
	end
end

------------------------------------------------------------------------------
-- HD rewrite begin
function ResourceGenerator:__PrepareContinentsData()
	local continentsInUse = Map.GetContinentsInUse()
	self.continentInfo = {}
	local totalPlots = 0
	------------------------------------------
	local totalLuxuries = #continentsInUse * self.iLuxuriesPerRegion + math.floor(self.iTargetPercentage/(12 - #continentsInUse)) - 2	--提高奢侈种类，会导致部分地图反而变差
	--local totalLuxuries = #continentsInUse * self.iLuxuriesPerRegion + 1  --v1.4少量增加奢侈种类
	------------------------------------------
	-- print('total luxuries', totalLuxuries)
	for _, eContinent in ipairs(continentsInUse) do 
		plots = Map.GetContinentPlots(eContinent)
		local iNumPlots = #plots
		local info = {plots=plots, num=iNumPlots, id=eContinent} 
		totalPlots = totalPlots + iNumPlots
		table.insert(self.continentInfo, info)
	end
	-- Get num luxuries for each continent according to the size of the continent
	local remainsAmount = totalLuxuries
	for _, cont in ipairs(self.continentInfo) do
		cont.plotsRatio = cont.num / totalPlots
		local requiredAmount = totalLuxuries * cont.plotsRatio
		cont.numLuxuries = math.floor(requiredAmount)
		cont.reminder = requiredAmount - cont.numLuxuries
		remainsAmount = remainsAmount - cont.numLuxuries
		-- print(cont.id, cont.numLuxuries)
	end
	-- assign the remains, first to the ones with larger reminder
	if remainsAmount > 0 then
		local tmp = {}
		for i, cont in ipairs(self.continentInfo) do
			table.insert(tmp, {score=cont.reminder, id=i})
		end
		table.sort(tmp, function(a, b) return a.score > b.score; end)
		for i = 1, remainsAmount do
			self.continentInfo[tmp[i].id].numLuxuries = self.continentInfo[tmp[i].id].numLuxuries + 1
		end
	end
	print('HD: continent resources')
	for _, cont in ipairs(self.continentInfo) do
		print('id', cont.id, 'assign amount', cont.numLuxuries, 'plots', cont.num, 'ratio', cont.plotsRatio)
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__GetLuxuryResources()
	self:__PrepareContinentsData();
	self.aLuxuryIds = {}
	-- Find the Luxury Resources
	-- 寻找奢侈并创建一个奢侈资源id表格
		-- self.iResourcesInDB 表示资源数据库中资源的总数。循环从 0 到 self.iResourcesInDB - 1，逐个检查每个资源。
	for row = 0, self.iResourcesInDB - 1 do
		if (self.eResourceClassType[row] == "RESOURCECLASS_LUXURY" and self.iFrequency[row] > 0) then
			table.insert(self.aLuxuryIds, row)
		end
	end

	-- 打乱奢侈
		-- 对self.aLuxuryIds 表中的元素进行随机打乱（洗牌），并将打乱后的结果重新赋值给 self.aLuxuryIds。
	self.aLuxuryIds = GetShuffledCopyOfTable(self.aLuxuryIds)
	self.iExtraLuxuries = GetShuffledCopyOfTable(self.iExtraLuxuries)

	-- 初始化和遍历大陆
	local cur_index = 0;
	for i, cont in ipairs(self.continentInfo) do
	
	-- 确定奢侈资源数量
		local num = cont.numLuxuries

	-- 准备奢侈资源列表
		local luxuries = {};

	-- 检查可放置地块
		for j = 1, num do
			local lux = self.aLuxuryIds[cur_index + j];
			local numPossiblePlots = 0;
			for i, plot in ipairs(cont.plots) do
				local pPlot = Map.GetPlotByIndex(plot)
				if (pPlot~=nil and pPlot:IsWater() == false) then
					if (ResourceBuilder.CanHaveResource(pPlot, lux)) then
						if (self:__CheckResources(pPlot, lux)) then
							numPossiblePlots = numPossiblePlots + 1;
						end
					end
				end
			end
	
		-- 存储奢侈资源和得分
			table.insert(luxuries, {luxIndex = self.aLuxuryIds[cur_index + j], score = - numPossiblePlots});
		end

	-- 排序奢侈资源
		-- place luxuries with high requirements first
		-- 根据得分对奢侈资源进行排序，得分越高的资源会优先考虑放置（即可用地块越少的资源会优先）。
		table.sort(luxuries, function(a, b) return a.score > b.score; end);

	-- 放置奢侈资源
		local extra = 0;
		for j = 1, num do
			local remains = self:__PlaceLuxuryResources(luxuries[j].luxIndex, i, extra);
			if j < num then
				extra = math.floor(extra + remains / (num - j));
			end
		end

	-- 处理额外奢侈资源
		local maxExtraLuxuries = 2  -- 设置最大放置的额外奢侈资源数量
		local extraCount = 0        -- 记录已放置的额外奢侈资源数量

		for k,iResourceTypeHD in ipairs(self.iExtraLuxuries) do

			if extraCount >= maxExtraLuxuries then
				break  -- 达到最大数量后退出循环
			end

			local extraluxIndex = 0;
			for row = 0, self.iResourcesInDB - 1 do
				if (self.eResourceClassType[row] == "RESOURCECLASS_LUXURY" and self.iFrequency[row] > 0) then
					if(GameInfo.Resources[row].ResourceType == iResourceTypeHD) then
						extraluxIndex = row;
					end
				end
			end

			for j = 1, num do
				if GameInfo.Resources[luxuries[j].luxIndex].ResourceType == iResourceTypeHD then

				elseif j == num and extraluxIndex ~= 0 then
					remains = self:__PlaceLuxuryResources(extraluxIndex, i, extra);
					extra = math.floor(extra + remains);
					extraCount = extraCount + 1  -- 增加已放置的数量
            		if extraCount >= maxExtraLuxuries then
                		break  -- 达到最大数量后退出内层循环
					end
				end
			end
		end

	-- 更新当前大陆索引
		cur_index = cur_index + num;

	end
end

-- ------------------------------------------------------------------------------
function ResourceGenerator:__PlaceLuxuryResources(chosenLuxID, continentID, extra)
	local cont = self.continentInfo[continentID]
	local possiblePlots = {};
	local numToPlace = self.iTargetPercentage / 100 * cont.num * self.iLuxuryPercentage / 100 / cont.numLuxuries + extra;
	for i, plot in ipairs(cont.plots) do
		local pPlot = Map.GetPlotByIndex(plot)
		if (pPlot~=nil and pPlot:IsWater() == false) then
			if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[chosenLuxID])) then
				if (self:__CheckResources(pPlot, self.eResourceType[chosenLuxID])) then
					local score = 500
					local adjResources = ResourceBuilder.GetAdjacentResourceCount(pPlot)
					score = score / ((adjResources + 1) * 3.75)
					score = score + TerrainBuilder.GetRandomNumber(200, "Resource Placement Score Adjust") -- origin: 100
					if adjResources <= 1 then
						table.insert(possiblePlots, {plotID=plot, score=score})
					end
				end
			end
		end
	end
	table.sort(possiblePlots, function(a, b) return a.score > b.score; end)
	local numPossiblePlots = #possiblePlots
	local placed = 0;
	for i = 1, numPossiblePlots do
		local pPlot = Map.GetPlotByIndex(possiblePlots[i].plotID);
		if ResourceBuilder.GetAdjacentResourceCount(pPlot) <= 0 then
			ResourceBuilder.SetResourceType(pPlot, self.eResourceType[chosenLuxID], 1);
			placed = placed + 1;
			-- if(GameInfo.Resources[chosenLuxID].ResourceType == "RESOURCE_P0K_PENGUINS") then
			-- 	placed = placed - 0.6;
			-- end
		end
		if placed >= numToPlace or (placed >= (21 + #Map.GetContinentsInUse())) then		--防止丰富单个奢侈过多	注：也不能太少
			break;
		end
	end
	return numToPlace - placed;
end
-- HD rewrite end

-- ------------------------------------------------------------------------------
-- function ResourceGenerator:__GetLuxuryResources()
-- 	local continentsInUse = Map.GetContinentsInUse();	
-- 	self.aLuxuryType = {};
-- 	local max = self.iLuxuriesPerRegion;

-- 	-- Find the Luxury Resources
-- 	for row = 0, self.iResourcesInDB do
-- 		local index = self.aIndex[row]
-- 		if (self.eResourceClassType[row] == "RESOURCECLASS_LUXURY" and self.iFrequency[index] > 0) then
-- 			table.insert(self.aLuxuryType, index);
-- 		end
-- 	end
	
-- 	-- Shuffle the table
-- 	self.aLuxuryType = GetShuffledCopyOfTable(self.aLuxuryType);

-- 	for _, eContinent in ipairs(continentsInUse) do 

-- 		--print ("Retrieved plots for continent: " .. tostring(eContinent));

-- 		self:__ValidLuxuryPlots(eContinent);

-- 		-- next find the valid plots for each of the luxuries
-- 		local failed = 0;
-- 		local iI = 1;
-- 		local index = 1;
-- 		while max >= iI and failed < 2 do 
-- 			local eChosenLux = self.aLuxuryType[self.aIndex[index]];
-- 			local isValid = false;
-- 			if (eChosenLux ~= nil) then
-- 				isValid = true;
-- 			end
			
-- 			if (isValid == true and #self.aLuxuryType > 0) then
-- 				table.remove(self.aLuxuryType,index);
-- 				self:__PlaceLuxuryResources(eChosenLux, eContinent);

-- 				index = index + 1;
-- 				iI = iI + 1;
-- 				failed = 0;
-- 			end

-- 			if index > #self.aLuxuryType then
-- 				index = 1;
-- 				failed = failed + 1;
-- 			elseif (isValid == false) then
-- 				failed = failed + 1;
-- 			end
-- 		end
-- 	end
-- end

-- ------------------------------------------------------------------------------
-- function ResourceGenerator:__ValidLuxuryPlots(eContinent)
-- 	-- go through each plot on the continent and put the luxuries	
-- 	local iSize = #self.aLuxuryType;
-- 	local iBaseScore = 1;
-- 	self.iTotalValidPlots = 0;

-- 	plots = Map.GetContinentPlots(eContinent);
-- 	local iNumPlots = #plots;
	
-- 	for i, plot in ipairs(plots) do

-- 		local bCanHaveSomeResource = false;
-- 		local pPlot = Map.GetPlotByIndex(plot);

-- 		if(pPlot~=nil and pPlot:IsWater() == false) then

-- 			-- See which resources can appear here
-- 			for iI = 1, iSize do
-- 				local bIce = false;

-- 				if(IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == true) then
-- 					bIce = true;
-- 				end
			
-- 				if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[self.aLuxuryType[iI]]) and bIce == false) then
-- 					row = {};
-- 					row.MapIndex = plot;
-- 					row.Score = iBaseScore;

-- 					table.insert (self.aaPossibleLuxLocs[self.aLuxuryType[iI]], row);
-- 					bCanHaveSomeResource = true;
-- 				end
-- 			end


-- 			if (bCanHaveSomeResource == true) then
-- 				self.iTotalValidPlots = self.iTotalValidPlots + 1;
-- 			end

-- 		end

-- 		-- Compute how many of each resource to place
-- 	end
	
-- 	--This is a fix to make land heavy maps have a more equal amount of luxuries to other maps. Unless it is a legendary start.
-- 	if(self.iWaterLux == 1 and self.uiStartConfig ~= 3) then
-- 		iNumPlots = iNumPlots / 2;
-- 	end
	
-- 	self.iOccurencesPerFrequency = self.iTargetPercentage / 100 * iNumPlots * self.iLuxuryPercentage / 100 / self.iLuxuriesPerRegion;
-- end

-- ------------------------------------------------------------------------------
-- function ResourceGenerator:__PlaceLuxuryResources(eChosenLux, eContinent)
-- 	-- Go through continent placing the chosen luxuries
	
-- 	plots = Map.GetContinentPlots(eContinent);
-- 	--print ("Occurrences per frequency: " .. tostring(self.iOccurencesPerFrequency));
-- 	--print("Resource: ", eChosenLux);

-- 	local iTotalPlaced = 0;

-- 	-- Compute how many to place
-- 	local iNumToPlace = 1;
-- 	if(self.iOccurencesPerFrequency > 1) then
-- 		iNumToPlace = self.iOccurencesPerFrequency;
-- 	end

-- 	-- Score possible locations
-- 	self:__ScoreLuxuryPlots(eChosenLux, eContinent);

-- 	-- Sort and take best score
-- 	table.sort (self.aaPossibleLuxLocs[eChosenLux], function(a, b) return a.Score > b.Score; end);

-- 	for iI = 1, iNumToPlace do
-- 			if (iI <= #self.aaPossibleLuxLocs[eChosenLux]) then
-- 				local iMapIndex = self.aaPossibleLuxLocs[eChosenLux][iI].MapIndex;
-- 				local iScore = self.aaPossibleLuxLocs[eChosenLux][iI].Score;

-- 				-- Place at this location
-- 				local pPlot = Map.GetPlotByIndex(iMapIndex);
-- 				ResourceBuilder.SetResourceType(pPlot, self.eResourceType[eChosenLux], 1);
-- 			iTotalPlaced = iTotalPlaced + 1;
-- 			--print ("   Placed at (" .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()) .. ") with score of " .. tostring(iScore));
-- 		end
-- 	end
-- end

-- ------------------------------------------------------------------------------
-- function ResourceGenerator:__ScoreLuxuryPlots(iResourceIndex, eContinent)
-- 	-- Clear all earlier entries (some might not be valid if resources have been placed
-- 	for k, v in pairs(self.aaPossibleLuxLocs[iResourceIndex]) do
-- 		self.aaPossibleLuxLocs[iResourceIndex][k] = nil;
-- 	end

-- 	plots = Map.GetContinentPlots(eContinent);
-- 	for i, plot in ipairs(plots) do
-- 		local pPlot = Map.GetPlotByIndex(plot);
-- 		local bIce = false;
		
-- 		if(IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == true) then
-- 			bIce = true;
-- 		end

-- 		if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[iResourceIndex]) and bIce == false) then
-- 			row = {};
-- 			row.MapIndex = plot;
-- 			row.Score = 500;
-- 			row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * 3.75);
-- 			row.Score = row.Score + TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust");
			
-- 			if(ResourceBuilder.GetAdjacentResourceCount(pPlot) <= 1 or #self.aaPossibleLuxLocs == 0) then
-- 					table.insert (self.aaPossibleLuxLocs[iResourceIndex], row);
-- 			end
-- 		end
-- 	end
-- end

------------------------------------------------------------------------------
function ResourceGenerator:__GetWaterLuxuryResources()
	self.aLuxuryTypeCoast = {};

	-- Find the Luxury Resources
	for row = 0, self.iResourcesInDB do
		local index = self.aIndex[row]
		if (self.eResourceClassType[row] == "RESOURCECLASS_LUXURY" and self.iSeaFrequency[index] > 0) then
			table.insert(self.aLuxuryTypeCoast, index);
		end
	end
	
	-- Shuffle the table
	self.aLuxuryTypeCoast = GetShuffledCopyOfTable(self.aLuxuryTypeCoast);

	-- Find the Map Size
	local iW, iH;
	iW, iH = Map.GetGridSize();
	local iSize = Map.GetMapSize() + 1;

	-- Use the Map Size to Determine the number of Water Luxuries
	for row in GameInfo.Resource_SeaLuxuries() do
		if (row.MapArgument == self.iWaterLux ) then
			if(iSize <= 1) then
				self.iNumWaterLuxuries = row.Duel;
			elseif(iSize == 2) then
				self.iNumWaterLuxuries = row.Tiny;
			elseif(iSize == 3) then
				self.iNumWaterLuxuries = row.Small;
			elseif(iSize == 4) then
				self.iNumWaterLuxuries = row.Standard;
			elseif(iSize == 5) then
				self.iNumWaterLuxuries = row.Large;
			else
				self.iNumWaterLuxuries = row.Huge;
			end
		end
	end

	if (self.iNumWaterLuxuries == 0) then
		return
	end

	local iNumLuxuries = math.floor(self.iNumWaterLuxuries / 2);
	self.bOdd = false;

	-- Determine if the number of water luxuries is odd
	if(self.iNumWaterLuxuries % 2 == 1) then
		self.bOdd = true;
		iNumLuxuries = iNumLuxuries + 1
	end


	-- Water plots
	self.iWaterPlots = 0;
	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x;
			local pPlot = Map.GetPlotByIndex(i);

			if(pPlot~=nil) then
				local terrainType = pPlot:GetTerrainType();
				if(terrainType == g_TERRAIN_TYPE_COAST and IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == false) then
					self.iWaterPlots = self.iWaterPlots + 1;
				end
			end
		end
	end


	self.iOccurencesPerFrequency =  self.iTargetPercentage / 100 * self.iWaterPlots * self.iLuxuryPercentage / 100 / iNumLuxuries / 2;
	
	aLuxuries = {};
	aLuxuries = self.aLuxuryTypeCoast;

	--First go through check the tropics
	for i = 1, iNumLuxuries do
		local eChosenLux  = aLuxuries[i];
		if(eChosenLux == nil)  then
			return;
		else
			self:__SetWaterLuxury(eChosenLux, 100.0, 35.1);
		end
	end

	aLuxuries = self.aLuxuryTypeCoast;

	--Then check the equator
	for i = 1, iNumLuxuries do		
		local eChosenLux  = aLuxuries[i];
		if(eChosenLux == nil)  then
			return;
		else
			self:__SetWaterLuxury(eChosenLux, 35.0, 0.0);
		end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__SetWaterLuxury(eChosenLux, latitudeMax, latitudeMin, index)
	local bOddSwitch = false;
	local bFirst = true;
	local iNumber = 0
	local iW, iH;
	iW, iH = Map.GetGridSize();

	local iNumToPlace = self.iOccurencesPerFrequency * self.iSeaFrequency[eChosenLux];

	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			-- Water plots
			if(pPlot~=nil and pPlot:IsWater() == true and IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == false) then
				local lat = math.abs((iH/2) - y)/(iH/2) * 100.0;
				if(lat < latitudeMax and lat > latitudeMin and iNumber <= iNumToPlace) then

					-- If the the luxury is placed then it returns true and is removed
					local bChosen = self:__PlaceWaterLuxury(eChosenLux, pPlot);
					if(bChosen == true) then
						if(bFirst == true) then
							if(self.bOdd == true) then
								bOddSwitch = true;
							else
								if(#self.aLuxuryTypeCoast > 0) then
									table.remove(self.aLuxuryTypeCoast, 1);
								else
									return;
								end
							end

							bFirst = false;
						end

						iNumber = iNumber + 1;
					end
				end
			end

			if(bOddSwitch == true and self.bOdd == true) then
				self.bOdd  = false;
			end	
		end
	end

	--print("Water Resource: ", eChosenLux, " number placed = ",  iNumber);
end

------------------------------------------------------------------------------
function ResourceGenerator:__PlaceWaterLuxury(eChosenLux, pPlot)
	if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[eChosenLux])) then
		if (self:__CheckResources(pPlot, self.eResourceType[chosenLux])) then
			-- Randomly detetermine each plot if a water luxury is placed less likely if there are adjacent of the same type

			local iBonusAdjacent = 0;

			if( self.iStandardPercentage < self.iTargetPercentage) then
				iBonusAdjacent = -1.5;
			elseif ( self.iStandardPercentage > self.iTargetPercentage) then
				iBonusAdjacent = 1;
			end
				
			local iRandom = 15 * self.iOccurencesPerFrequency + 300;

			--print ("Random Frequency: " , iRandom);

			local score = TerrainBuilder.GetRandomNumber(iRandom, "Resource Placement Score Adjust");
			score = score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * (3.0 + iBonusAdjacent));
				
			if(score * self.iSeaFrequency[eChosenLux] >= 85 + 5 * self.iOccurencesPerFrequency) then
				ResourceBuilder.SetResourceType(pPlot, self.eResourceType[eChosenLux], 1);
				return true
			end
		end
	end

	return false;
end

------------------------------------------------------------------------------
function ResourceGenerator:__GetStrategicResources()
	local continentsInUse = Map.GetContinentsInUse();	
	self.iNumContinents = #continentsInUse;
	self.aStrategicType = {};

	-- Find the Strategic Resources
	for row = 0, self.iResourcesInDB do
		local index = self.aIndex[row]
		if (self.eResourceClassType[row] == "RESOURCECLASS_STRATEGIC" and self.iFrequency[index] > 0) then
				table.insert(self.aStrategicType, index);
		end
	end

	aWeight = {};
	for row in GameInfo.Resource_Distribution() do
		if (row.Continents == self.iNumContinents) then
			if(self.uiStartConfig == 1 ) then
				for iI = 1, row.Continents do
					table.insert(aWeight, 1);
				end
			else
				for iI = 1, row.Scarce do
					table.insert(aWeight, 1 - row.PercentAdjusted / 100);
				end

				for iI = 1, row.Average do
					table.insert(aWeight, 1);
				end

				for iI = 1, row.Plentiful do
					table.insert(aWeight, 1 + row.PercentAdjusted / 100);
				end
			end
		end
	end

	aWeight	= GetShuffledCopyOfTable(aWeight);

	self.iFrequencyStrategicTotal = 0;
    for i, row in ipairs(self.aStrategicType) do
		self.iFrequencyStrategicTotal = self.iFrequencyStrategicTotal + self.iFrequency[row];
	end

	for index, eContinent in ipairs(continentsInUse) do 
		-- Shuffle the table
		self.aStrategicType = GetShuffledCopyOfTable(self.aStrategicType);
		--print ("Retrieved plots for continent: " .. tostring(eContinent));

		self:__ValidStrategicPlots(aWeight[index], eContinent);

		-- next find the valid plots for each of the strategics
		self:__PlaceStrategicResources(eContinent);
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__ValidStrategicPlots(iWeight, eContinent)
	-- go through each plot on the continent and find the valid strategic plots
	local iSize = #self.aStrategicType;
	local iBaseScore = 1;
	self.iTotalValidPlots = 0;
	self.aResourcePlacementOrderStrategic = {};
	plots = Map.GetContinentPlots(eContinent);

	-- Find valid spots for land resources first
	for i, plot in ipairs(plots) do
		local bCanHaveSomeResource = false;
		local pPlot = Map.GetPlotByIndex(plot);

		-- See which resources can appear here
		for iI = 1, iSize do
			local eResourceType = self.eResourceType[self.aStrategicType[iI]]
			if (ResourceBuilder.CanHaveResource(pPlot, eResourceType)) then
				if (self:__CheckResources(pPlot, eResourceType)) then
					row = {};
					row.MapIndex = plot;
					row.Score = iBaseScore;
					table.insert (self.aaPossibleStratLocs[self.aStrategicType[iI]], row);
					bCanHaveSomeResource = true;
				end
			end
		end

		if (bCanHaveSomeResource == true) then
			self.iTotalValidPlots = self.iTotalValidPlots + 1;
		end
	end

	for iI = 1, iSize do
		row = {};
		row.ResourceIndex = self.aStrategicType[iI];
		row.NumEntries = #self.aaPossibleStratLocs[iI];
		row.Weight = iWeight or 0;
		table.insert (self.aResourcePlacementOrderStrategic, row);
	end

	table.sort (self.aResourcePlacementOrderStrategic, function(a, b) return a.NumEntries < b.NumEntries; end);

	self.iOccurencesPerFrequency = (#plots) * (self.iTargetPercentage / 100)  * (self.iStrategicPercentage / 100);
end

------------------------------------------------------------------------------
function ResourceGenerator:__PlaceStrategicResources(eContinent)
	-- Go through continent placing the chosen strategic
	for i, row in ipairs(self.aResourcePlacementOrderStrategic) do
		local eResourceType = self.eResourceType[row.ResourceIndex]

		local iNumToPlace;

		-- Compute how many to place
		iNumToPlace = self.iOccurencesPerFrequency * (self.iFrequency[row.ResourceIndex] / self.iFrequencyStrategicTotal) * row.Weight;

		--------------
		--if (GameInfo.Resources[row.ResourceIndex].ResourceType == "RESOURCE_HORSES") or (GameInfo.Resources[row.ResourceIndex].ResourceType == "RESOURCE_IRON") then
		--	iNumToPlace = iNumToPlace * self.iHorsesAndIronMultiply;
		--end


		if (GameInfo.Resources[row.ResourceIndex].ResourceType == "RESOURCE_HORSES")  then
			iNumToPlace = iNumToPlace * self.iHorsesMultiply;
		end

		if (GameInfo.Resources[row.ResourceIndex].ResourceType == "RESOURCE_IRON")  then
			iNumToPlace = iNumToPlace * self.iIronMultiply;
		end

		if (GameInfo.Resources[row.ResourceIndex].ResourceType == "RESOURCE_NITER")  then
			iNumToPlace = iNumToPlace * self.iNiterMultiply;
		end

		if (GameInfo.Resources[row.ResourceIndex].ResourceType == "RESOURCE_COAL")  then
			iNumToPlace = iNumToPlace * self.iCoalMultiply;
		end

		if (GameInfo.Resources[row.ResourceIndex].ResourceType == "RESOURCE_OIL")  then
			iNumToPlace = iNumToPlace * self.iOilMultiply;
		end
		
		if (GameInfo.Resources[row.ResourceIndex].ResourceType == "RESOURCE_ALUMINUM")  then
			iNumToPlace = iNumToPlace * self.iAluminumMultiply;
		end
		--------------
			-- Score possible locations
		self:__ScoreStrategicPlots(row.ResourceIndex, eContinent);

		-- Sort and take best score
		table.sort (self.aaPossibleStratLocs[row.ResourceIndex], function(a, b) return a.Score > b.Score; end);

		if(self.iFrequency[row.ResourceIndex] > 1 and iNumToPlace < 1) then
			iNumToPlace = 1;
		end

		for iI = 1, iNumToPlace do
			if (iI <= #self.aaPossibleStratLocs[row.ResourceIndex]) then
				local iMapIndex = self.aaPossibleStratLocs[row.ResourceIndex][iI].MapIndex;
				local iScore = self.aaPossibleStratLocs[row.ResourceIndex][iI].Score;

				-- Place at this location
				local pPlot = Map.GetPlotByIndex(iMapIndex);
				ResourceBuilder.SetResourceType(pPlot, eResourceType, 1);
--				print ("   Placed at (" .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()) .. ") with score of " .. tostring(iScore));
			end
		end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__ScoreStrategicPlots(iResourceIndex, eContinent)
	-- Clear all earlier entries (some might not be valid if resources have been placed
	for k, v in pairs(self.aaPossibleStratLocs[iResourceIndex]) do
		self.aaPossibleStratLocs[iResourceIndex][k] = nil;
	end

	local iBonusAdjacent = 0;

		if( self.iStandardPercentage < self.iTargetPercentage) then
			iBonusAdjacent = 5;
		elseif ( self.iStandardPercentage > self.iTargetPercentage) then
			iBonusAdjacent = -5;
		end

	plots = Map.GetContinentPlots(eContinent);
	for i, plot in ipairs(plots) do
		local pPlot = Map.GetPlotByIndex(plot);
		if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[iResourceIndex])) then
			if (self:__CheckResources(pPlot, self.eResourceType[iResourceIndex])) then
				row = {};
				row.MapIndex = plot;
				row.Score = 500;
				row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * (15 + iBonusAdjacent));
				row.Score = row.Score + TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust");
				
				if(ResourceBuilder.GetAdjacentResourceCount(pPlot) <= 1 or #self.aaPossibleStratLocs == 0) then
					table.insert (self.aaPossibleStratLocs[iResourceIndex], row);
				end
			end
		end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__GetWaterStrategicResources()
	self.aStrategicTypeCoast = {};

	-- Find the Strategic Resources
	for row = 0, self.iResourcesInDB do
		local index = self.aIndex[row]
		if (self.eResourceClassType[row] == "RESOURCECLASS_STRATEGIC" and self.iSeaFrequency[index] > 0) then
			table.insert(self.aStrategicTypeCoast, index);
		end
	end
	
	-- Shuffle the table
	self.aStrategicTypeCoast = GetShuffledCopyOfTable(self.aStrategicTypeCoast);

	-- Find the Map Size
	local iW, iH;
	iW, iH = Map.GetGridSize();
	local iSize = Map.GetMapSize() + 1;

	-- Use the Map Size to Determine the number of Water Strategics
	for row in GameInfo.Resource_SeaStrategics() do
		if (row.MapArgument == self.iWaterLux ) then
			if(iSize <= 1) then
				self.iNumWaterStrategics = row.Duel;
			elseif(iSize == 2) then
				self.iNumWaterStrategics = row.Tiny;
			elseif(iSize == 3) then
				self.iNumWaterStrategics = row.Small;
			elseif(iSize == 4) then
				self.iNumWaterStrategics = row.Standard;
			elseif(iSize == 5) then
				self.iNumWaterStrategics = row.Large;
			else
				self.iNumWaterStrategics = row.Huge;
			end
		end
	end

	if (self.iNumWaterStrategics == 0) then
		return
	end

	local iNumStrategics = math.floor(self.iNumWaterStrategics / 2);
	self.bOdd = false;

	-- Determine if the number of water strategics is odd
	if(self.iNumWaterStrategics % 2 == 1) then
		self.bOdd = true;
		iNumStrategics = iNumStrategics + 1
	end

	

	-- Water plots
	self.iWaterPlots = 0;
	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x;
			local pPlot = Map.GetPlotByIndex(i);

			if(pPlot~=nil) then
				local terrainType = pPlot:GetTerrainType();
				if(terrainType == g_TERRAIN_TYPE_COAST and IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == false) then
					self.iWaterPlots = self.iWaterPlots + 1;
				end
			end
		end
	end


	self.iOccurencesPerFrequency =  self.iTargetPercentage / 100.0 * self.iWaterPlots * self.iStrategicPercentage / 100.0 / iNumStrategics / 12.0;
	
	aStrategics = {};
	aStrategics = self.aStrategicTypeCoast;

	--First go through check the tropics
	for i = 1, iNumStrategics do
		local eChosenStrat  = aStrategics[i];
		if(eChosenStrat == nil)  then
			return;
		else
			self:__SetWaterStrategic(eChosenStrat, 100.0, 35.1);
		end
	end

	aStrategics = self.aStrategicTypeCoast;

	--Then check the equator
	for i = 1, iNumStrategics do		
		local eChosenStrat  = aStrategics[i];
		if(eChosenStrat == nil)  then
			return;
		else
			self:__SetWaterStrategic(eChosenStrat, 35.0, 0.0);
		end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__SetWaterStrategic(eChosenStrat, latitudeMax, latitudeMin, index)
	local bOddSwitch = false;
	local bFirst = true;
	local iNumber = 0
	local iW, iH;
	iW, iH = Map.GetGridSize();

	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			-- Water plots
			if(pPlot~=nil and pPlot:IsWater() == true and IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == false) then
				local lat = math.abs((iH/2) - y)/(iH/2) * 100.0;
				if(lat < latitudeMax and lat > latitudeMin and iNumber <= self.iOccurencesPerFrequency) then

					-- If the the strategic is placed then it returns true and is removed
					local bChosen = self:__PlaceWaterStrategic(eChosenStrat, pPlot);
					if(bChosen == true) then
						if(bFirst == true) then
							if(self.bOdd == true) then
								bOddSwitch = true;
							else
								if(#self.aStrategicTypeCoast > 0) then
									table.remove(self.aStrategicTypeCoast, 1);
								else
									return;
								end
							end

							bFirst = false;
						end

						iNumber = iNumber + 1;
					end
				end
			end

			if(bOddSwitch == true and self.bOdd == true) then
				self.bOdd  = false;
			end	
		end
	end

	--print("Water Resource: ", eChosenStrat, " number placed = ",  iNumber);
end

------------------------------------------------------------------------------
function ResourceGenerator:__PlaceWaterStrategic(eChosenStrat, pPlot)
	if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[eChosenStrat])) then
		if (self:__CheckResources(pPlot, self.eResourceType[eChosenStrat])) then
			-- Randomly detetermine each plot if a water strategic is placed less likely if there are adjacent of the same type

			local iBonusAdjacent = 0;

			if( self.iStandardPercentage < self.iTargetPercentage) then
				iBonusAdjacent = -1.5;
			elseif ( self.iStandardPercentage > self.iTargetPercentage) then
				iBonusAdjacent = -0.5;
			end
				
			local iRandom = 15 * self.iOccurencesPerFrequency + 300;

			--print ("Random Frequency: " , iRandom);

			local score = TerrainBuilder.GetRandomNumber(iRandom, "Resource Placement Score Adjust");
			score = score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * (3.0 + iBonusAdjacent));
				
			if(score >= 85 + 5 * self.iOccurencesPerFrequency) then
				ResourceBuilder.SetResourceType(pPlot, self.eResourceType[eChosenStrat], 1);
				return true
			end
		end
	end

	return false;
end
------------------------------------------------------------------------------
function ResourceGenerator:__GetOtherResources()
	self.aOtherType = {};
	-- Find the other resources
    for row = 0, self.iResourcesInDB do
		local index  = self.aIndex[row];
		if(self.eResourceClassType[index] ~= nil) then
			if (self.eResourceClassType[index] ~= "RESOURCECLASS_STRATEGIC" and self.eResourceClassType[index] ~= "RESOURCECLASS_LUXURY" and self.eResourceClassType[index] ~= "RESOURCECLASS_ARTIFACT") then
				if(self.iFrequency[index] > 0) then
					table.insert(self.aOtherType, index);
				end
			end
		end
	end

	-- Shuffle the table
	self.aOtherType = GetShuffledCopyOfTable(self.aOtherType);

	local iW, iH;
	iW, iH = Map.GetGridSize();

	local iBaseScore = 1;
	self.iTotalValidPlots = 0;
	local iSize = #self.aOtherType;
	local iPlotCount = Map.GetPlotCount();
	for i = 0, iPlotCount - 1 do
		local pPlot = Map.GetPlotByIndex(i);
		local bCanHaveSomeResource = false;

		-- See which resources can appear here
		for iI = 1, iSize do
			if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[self.aOtherType[iI]])) then
				if (self:__CheckResources(pPlot, self.eResourceType[self.aOtherType[iI]])) then
					row = {};
					row.MapIndex = i;
					row.Score = iBaseScore;
					table.insert (self.aaPossibleLocs[self.aOtherType[iI]], row);
					bCanHaveSomeResource = true;
				end
			end
		end

		if (bCanHaveSomeResource == true) then
			self.iTotalValidPlots = self.iTotalValidPlots + 1;
		end
	end

	for iI = 1, iSize do
		row = {};
		row.ResourceIndex = self.aOtherType[iI];
		row.NumEntries = #self.aaPossibleLocs[iI];
		table.insert (self.aResourcePlacementOrder, row);
	end

	table.sort (self.aResourcePlacementOrder, function(a, b) return a.NumEntries < b.NumEntries; end);

    for i, row in ipairs(self.aOtherType) do
		self.iFrequencyTotal = self.iFrequencyTotal + self.iFrequency[row];
	end

	--print ("Total frequency: " .. tostring(self.iFrequencyTotal));

	-- Compute how many of each resource to place
	self.iOccurencesPerFrequency = (self.iTargetPercentage / 100 ) * self.iTotalValidPlots * (100 - self.iStrategicPercentage - self.iLuxuryPercentage) / 100 / self.iFrequencyTotal;

	--print ("Occurrences per frequency: " .. tostring(self.iOccurencesPerFrequency));

	self:__PlaceOtherResources();
end
------------------------------------------------------------------------------
function ResourceGenerator:__PlaceOtherResources()

    for i, row in ipairs(self.aResourcePlacementOrder) do

		local eResourceType = self.eResourceType[row.ResourceIndex]

		local iNumToPlace;

		-- Compute how many to place
		iNumToPlace = self.iOccurencesPerFrequency * self.iFrequency[row.ResourceIndex];
		for k,iResourceTypeHD in ipairs(self.iExtraBonusGroupOne) do
			if GameInfo.Resources[row.ResourceIndex].ResourceType == iResourceTypeHD then
				iNumToPlace = iNumToPlace * self.iExtraBonusGroupOneMultiply;
			end
		end
		for k,iResourceTypeHD in ipairs(self.iExtraBonusGroupTwo) do
			if GameInfo.Resources[row.ResourceIndex].ResourceType == iResourceTypeHD then
				iNumToPlace = iNumToPlace * self.iExtraBonusGroupTwoMultiply;
			end
		end
		for k,iResourceTypeHD in ipairs(self.iFewerBonusGroupOne) do
			if GameInfo.Resources[row.ResourceIndex].ResourceType == iResourceTypeHD then
				iNumToPlace = iNumToPlace * self.iFewerBonusGroupOneMultiply;
			end
		end
		for k,iResourceTypeHD in ipairs(self.iFewerBonusGroupTwo) do
			if GameInfo.Resources[row.ResourceIndex].ResourceType == iResourceTypeHD then
				iNumToPlace = iNumToPlace * self.iFewerBonusGroupTwoMultiply;
			end
		end
		
		-- Score possible locations
		self:__ScorePlots(row.ResourceIndex);
	
		-- Sort and take best score
		table.sort (self.aaPossibleLocs[row.ResourceIndex], function(a, b) return a.Score > b.Score; end);

		for iI = 1, iNumToPlace do
			if (iI <= #self.aaPossibleLocs[row.ResourceIndex]) then
				local iMapIndex = self.aaPossibleLocs[row.ResourceIndex][iI].MapIndex;
				local iScore = self.aaPossibleLocs[row.ResourceIndex][iI].Score;

					-- Place at this location
				local pPlot = Map.GetPlotByIndex(iMapIndex);
				ResourceBuilder.SetResourceType(pPlot, eResourceType, 1);
--				print ("   Placed at (" .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()) .. ") with score of " .. tostring(iScore));
			end
		end
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__ScorePlots(iResourceIndex)

	local iW, iH;
	iW, iH = Map.GetGridSize();

	-- Clear all earlier entries (some might not be valid if resources have been placed
	for k, v in pairs(self.aaPossibleLocs[iResourceIndex]) do
		self.aaPossibleLocs[iResourceIndex][k] = nil;
	end

	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[iResourceIndex])) then
				if (self:__CheckResources(pPlot, self.eResourceType[iResourceIndex])) then
					row = {};
					row.MapIndex = i;
					row.Score = 500;
					row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * 1.1);
					row.Score = row.Score + TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust");
					table.insert (self.aaPossibleLocs[iResourceIndex], row);
				end
			end
		end
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__GetWaterOtherResources()
	self.aOtherTypeWater = {};
	-- Find the other resources
    for row = 0, self.iResourcesInDB do
		local index  =self.aIndex[row];
		if (self.eResourceClassType[index] ~= nil) then
			if (self.eResourceClassType[index] ~= "RESOURCECLASS_STRATEGIC" and self.eResourceClassType[index] ~= "RESOURCECLASS_LUXURY" and self.eResourceClassType[index] ~= "RESOURCECLASS_ARTIFACT") then
				if(self.iSeaFrequency[index] > 0) then
					table.insert(self.aOtherTypeWater, index);
				end
			end
		end
	end

	-- Shuffle the table
	self.aOtherTypeWater = GetShuffledCopyOfTable(self.aOtherTypeWater);

	local iW, iH;
	iW, iH = Map.GetGridSize();

	local iBaseScore = 1;
	self.iTotalValidPlots = 0;
	local iSize = #self.aOtherTypeWater;
	local iPlotCount = Map.GetPlotCount();
	for i = 0, iPlotCount - 1 do
		local pPlot = Map.GetPlotByIndex(i);
		local bCanHaveSomeResource = false;

		-- See which resources can appear here
		for iI = 1, iSize do
			if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[self.aOtherTypeWater[iI]])) then
				if (self:__CheckResources(pPlot, self.eResourceType[self.aOtherTypeWater[iI]])) then
					row = {};
					row.MapIndex = i;
					row.Score = iBaseScore;
					table.insert (self.aaPossibleWaterLocs[self.aOtherTypeWater[iI]], row);
					bCanHaveSomeResource = true;
				end
			end
		end

		if (bCanHaveSomeResource == true) then
			self.iTotalValidPlots = self.iTotalValidPlots + 1;
		end
	end

	for iI = 1, iSize do
		row = {};
		row.ResourceIndex = self.aOtherTypeWater[iI];
		row.NumEntries = #self.aaPossibleWaterLocs[iI];
		table.insert (self.aWaterResourcePlacementOrder, row);
	end

	table.sort (self.aWaterResourcePlacementOrder, function(a, b) return a.NumEntries < b.NumEntries; end);
	self.iFrequencyTotalWater = 0;

    for i, row in ipairs(self.aOtherTypeWater) do
		self.iFrequencyTotalWater = self.iFrequencyTotalWater + self.iSeaFrequency[row];
	end

	--print ("Total frequency: " .. tostring(self.iFrequencyTotalWater));

	-- Compute how many of each resource to place
	self.iOccurencesPerFrequency = (self.iTargetPercentage / 100 ) * self.iTotalValidPlots * (100 - self.iStrategicPercentage - self.iLuxuryPercentage) / 100 / self.iFrequencyTotalWater * self.iWaterBonus;

	--print ("Occurrences per frequency: " .. tostring(self.iOccurencesPerFrequency));

	self:__PlaceWaterOtherResources();
end
------------------------------------------------------------------------------
function ResourceGenerator:__PlaceWaterOtherResources()

    for i, row in ipairs(self.aWaterResourcePlacementOrder) do

		local eResourceType = self.eResourceType[row.ResourceIndex]

		local iNumToPlace;

		-- Compute how many to place
		iNumToPlace = self.iOccurencesPerFrequency * self.iSeaFrequency[row.ResourceIndex];
	
		-- Score possible locations
		self:__ScoreWaterPlots(row.ResourceIndex);
	
		-- Sort and take best score
		table.sort (self.aaPossibleWaterLocs[row.ResourceIndex], function(a, b) return a.Score > b.Score; end);

		for iI = 1, iNumToPlace do
			if (iI <= #self.aaPossibleWaterLocs[row.ResourceIndex]) then
				local iMapIndex = self.aaPossibleWaterLocs[row.ResourceIndex][iI].MapIndex;
				local iScore = self.aaPossibleWaterLocs[row.ResourceIndex][iI].Score;

					-- Place at this location
				local pPlot = Map.GetPlotByIndex(iMapIndex);
				ResourceBuilder.SetResourceType(pPlot, eResourceType, 1);
--				print ("   Placed at (" .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()) .. ") with score of " .. tostring(iScore));
			end
		end
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__ScoreWaterPlots(iResourceIndex)

	local iW, iH;
	iW, iH = Map.GetGridSize();

	-- Clear all earlier entries (some might not be valid if resources have been placed
	for k, v in pairs(self.aaPossibleWaterLocs[iResourceIndex]) do
		self.aaPossibleWaterLocs[iResourceIndex][k] = nil;
	end

	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[iResourceIndex])) then
				if (self:__CheckResources(pPlot, self.eResourceType[iResourceIndex])) then
					row = {};
					row.MapIndex = i;
					row.Score = 500;
					row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * 1.1);
					row.Score = row.Score + TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust");
					table.insert (self.aaPossibleWaterLocs[iResourceIndex], row);
				end
			end
		end
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__RemoveOtherDuplicateResources()

	local iW, iH;
	iW, iH = Map.GetGridSize();

	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			if(pPlot:GetResourceCount() > 0) then
				for row = 0, self.iResourcesInDB do
					local index = self.aIndex[row];
					
					if (self.eResourceClassType[index] ~= "RESOURCECLASS_STRATEGIC" and self.eResourceClassType[index] ~= "RESOURCECLASS_LUXURY" and self.eResourceClassType[index] ~= "RESOURCECLASS_ARTIFACT") then
						if(self.eResourceType[index]  == pPlot:GetResourceTypeHash()) then
							local bRemove = self:__RemoveDuplicateResources(pPlot, self.eResourceType[index]);
							if(bRemove == true) then
								ResourceBuilder.SetResourceType(pPlot, -1);
							end
						end
					end		
				end
			end
		end
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__RemoveDuplicateResources(plot, eResourceType)
	local iCount = 0;
	
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
		if (adjacentPlot ~= nil) then
			if(adjacentPlot:GetResourceCount() > 0) then
				if(adjacentPlot:GetResourceTypeHash() == eResourceType) then
					iCount = iCount + 1;
				end
			end
		end
	end

	if(iCount >= 2) then
		return true;
	else
		return false;
	end
end

--by txym
--移除指定地形地貌上资源
function ResourceGenerator:__CheckResources(plot, eResourceType)
	
	if (eResourceType ~= -1 and plot:GetTerrainType() ~= -1 and plot:GetFeatureType() ~= -1 and GameInfo.Resources[eResourceType] ~= nil) then
		for row in GameInfo.HD_BanResourcesOnTerrainsOrFeatures() do
			if row.ResourceType == GameInfo.Resources[eResourceType].ResourceType then
				if row.TerrainType == GameInfo.Terrains[plot:GetTerrainType()].TerrainType then
					if row.FeatureType == GameInfo.Features[plot:GetFeatureType()].FeatureType then
						return false;
					end
				end
			end
		end
	end
	
	return true;
end