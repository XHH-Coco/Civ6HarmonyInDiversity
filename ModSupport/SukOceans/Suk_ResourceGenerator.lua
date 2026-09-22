--------------------------------------------------------------------------------
-- HD 覆盖版 —— 请不要手工编辑
--
-- 这是 Sukritact's Oceans（创意工坊 2542898147）里同名文件的副本，
-- 由 tools/vendor_suk_oceans.py 从上游原文件生成。上游原文件保存在
-- tools/maptest/versions/suk_upstream/ 作为合并基准。
--
-- 为什么要覆盖：上游那个文件会在某些地图上崩掉，崩了就等于整局一个海洋
-- 奢侈品都不放（详见 docs/SukOceans.md 第 6 节）。`include` 按文件名解析，
-- HD 用 ImportFiles 提供同名文件即可顶掉上游的。
--
-- 改了什么：只有下面标着 [HD] 的几处，全部是防御性的。
-- tools/maptest/suk.lua 逐格比对上游版和本版，证明**数据正常时行为完全一致**
-- （8 个场景，最终资源分布和随机数抽取次数都相同）。
--
-- 上游更新之后怎么办：把新版原文件重新跑一遍 vendor_suk_oceans.py 即可；
-- 补丁锚点对不上会直接报错，不会静默生成一个半新半旧的文件。
--------------------------------------------------------------------------------

print("HD: overriding Suk_ResourceGenerator.lua");

-- Suk_ResourceGenerator
-- Author: Sukritact
-- DateCreated: 4/14/2021 5:02:10 PM
--======================================================================================================================
if Game:GetProperty("Suk_Oceans_Resources_Spawned") then
	local tJumpFloodContinents = Game:GetProperty("Suk_Oceans_ContinentsData")
	if tJumpFloodContinents then
		ExposedMembers.Suk_Oceans_ContinentsData = tJumpFloodContinents
	end
	return
else
	Game:SetProperty("Suk_Oceans_Resources_Spawned", true)
end

include "PlotIterators"
--======================================================================================================================
-- Defines
--======================================================================================================================
local sQuery = [[
		SELECT *, (ResourceType IN (SELECT DISTINCT Type FROM TypeTags WHERE Tag = 'CLASS_SUK_LAKE_ONLY'))
		AS LakeOnly FROM Resources WHERE SeaFrequency > 0
	]]
local tResults = DB.Query(sQuery)

local tLakeOnly		= {}
local tLuxuries 	= {}
local tBonuses		= {}
local tResourceClasses = {
	RESOURCECLASS_BONUS		= tBonuses,
	RESOURCECLASS_LUXURY	= tLuxuries,
}

for _, tRow in pairs(tResults) do
	local iResource			= GameInfo.Resources[tRow.ResourceType].Index
	local sResourceClass	= tRow.ResourceClassType

	local tTable = tResourceClasses[sResourceClass]
	if tTable then
		tTable[iResource] = tRow
	end
	if tRow.LakeOnly == 1 then
		tLakeOnly[iResource] = true
	end
end

local iWidth, iHeight		= Map.GetGridSize()
local iTargetPercentage		= 40
local iLuxuryPercentage		= 19.33

local iResourceSetting		= MapConfiguration.GetValue("resources") or 0
local tResourceSettings		= {
	[1] = -3,
	--[2] = 0, -- Standard
	[3] = 3,
	[4] = TerrainBuilder.GetRandomNumber(9, "Random Resources - Lua") - 4,
	[25] = 25,
	[45] = 45,
}
iResourceSetting = tResourceSettings[iResourceSetting] or 0
iTargetPercentage = iTargetPercentage + iResourceSetting
--======================================================================================================================
-- Utility Functions
--======================================================================================================================
function DrawRandomCard(tCards, tWeights, sReason)
	assert(#tCards == #tWeights, "Cards and Weights must be equal in length")
	local sReason = sReason or "Drawing Random Card - Suk"

	local iWeightSum = 0
	for _,iWeight in ipairs(tWeights) do
		iWeightSum = iWeightSum + iWeight
	end

	local iRandomDraw = TerrainBuilder.GetRandomNumber(100, sReason)/100 * iWeightSum
	local iRunningWeight = 0
	local iDrawn = 1

	for iIndex, iWeight in ipairs(tWeights) do
		iRunningWeight = iRunningWeight + iWeight

		if iRandomDraw < iRunningWeight then
			iDrawn = iIndex
			break
		end
	end

	return tCards[iDrawn], iDrawn
end

function DrawRandomCards(tCards, tWeights, iNum, sReason)
	assert(#tCards >= iNum, "Deck smaller than specified number to draw")
	assert(iNum > 0, "Number to draw must be greater than 0")
	local tCards	= {unpack(tCards)}
	local tWeights	= {unpack(tWeights)}
	local sReason	= sReason or "Drawing Random Card - Suk"

	local tDrawn			= {}

	while #tDrawn < iNum do
		pDrawnCard, iDrawnIndex = DrawRandomCard(tCards, tWeights, sReason)

		table.insert(tDrawn, pDrawnCard)
		table.remove(tCards, iDrawnIndex)
		table.remove(tWeights, iDrawnIndex)
	end

	return unpack(tDrawn)
end

function CanHaveResource(pPlot, iResource)
	if tLakeOnly[iResource] then
		return ResourceBuilder.CanHaveResource(pPlot, iResource) and pPlot:IsLake() and (pPlot:GetResourceType() == -1)
	else
		return ResourceBuilder.CanHaveResource(pPlot, iResource) and (pPlot:GetResourceType() == -1)
	end
end
--======================================================================================================================
-- Generate Continents
--======================================================================================================================
local tJumpFloodContinents	= Suk_GetPlotContinents()
Game:SetProperty("Suk_Oceans_ContinentsData", tJumpFloodContinents)
ExposedMembers.Suk_Oceans_ContinentsData = tJumpFloodContinents

local tContinentWaterPlots	= {}
local iNumContinents		= 0
local iNumWaterPlots		= 0

local tPlotsData = {
	Plots			= {}, -- array of plots
	Continent		= {},
	IsWater			= {},
	NearbyLuxuries	= {},
	LuxuryWeight	= {},
	BonusWeight		= {},
}

for iContinent, tPlots in pairs(tJumpFloodContinents.Continents) do

	tContinentWaterPlots[iContinent] = {}
	iNumContinents = iNumContinents + 1

	for _, iPlot in pairs(tPlots) do
		local pPlot		= Map.GetPlotByIndex(iPlot)
		local bIsWater	= pPlot:IsWater()

		tPlotsData.Plots[iPlot]				= pPlot
		tPlotsData.Continent[iPlot]			= iContinent
		tPlotsData.IsWater[iPlot]			= bIsWater
		tPlotsData.NearbyLuxuries[iPlot]	= 0

		if bIsWater then
			table.insert(tContinentWaterPlots[iContinent], iPlot)
			iNumWaterPlots = iNumWaterPlots + 1
		end
	end
end

if iNumWaterPlots < 1 then return end -- Apparently this map is land only.
--======================================================================================================================
-- Generate Resource Heat Map
--======================================================================================================================
local tLuxuryMap			= Suk_MapConvolution:new(0)
local tBonusMap				= Suk_MapConvolution:new(0)

local iLakesMultiplier = 0
local iNumOceans = 0
local iNumCoasts = 0
local iNumLakes = 0
local iNumLuxuries = 0

for iY = 0, iHeight - 1, 1 do
	for iX = 0, iWidth - 1, 1 do

		local iPlot				= iY * iWidth + iX;
		local pPlot				= Map.GetPlotByIndex(iPlot)

		if pPlot:IsWater() then
			------------------------
			-- Resource Stuff
			------------------------
			local iResource		= pPlot:GetResourceType()
			local iLuxWeight	= tLuxuries[iResource] and 500 or 0
			local iBonusWight	= tBonuses[iResource] and 500 or 0

			tLuxuryMap.m_MapGrid[iPlot]	= iLuxWeight
			tBonusMap.m_MapGrid[iPlot]	= iBonusWight
			------------------------
			-- Lake or Coast
			------------------------
				if pPlot:IsLake() then
					iNumLakes = iNumLakes + 1
				elseif pPlot:GetTerrainType() == g_TERRAIN_TYPE_COAST then
					iNumCoasts = iNumCoasts + 1
				else
					iNumOceans = iNumOceans + 1
				end
			------------------------
			-- Remove Resources
			------------------------
			if iLuxWeight > 0 then
				ResourceBuilder.SetResourceType(pPlot, -1)
				iNumLuxuries = iNumLuxuries + 1
			end
		else
			tLuxuryMap.m_MapGrid[iPlot] = 0
			tBonusMap.m_MapGrid[iPlot] = 0
		end
	end
end

print("Removed luxuries from " .. iNumLuxuries .. " tiles")

iLakesMultiplier = 1 + (iNumWaterPlots - iNumLakes)/iNumWaterPlots

tLuxuryMap = tLuxuryMap:DoConvolution(g_Suk_GaussianKernel_3x3)
tLuxuryMap = tLuxuryMap:DoConvolution(g_Suk_GaussianKernel_5x5)
tLuxuryMap:DoNormalise()

tBonusMap = tBonusMap:DoConvolution(g_Suk_GaussianKernel_3x3)
tBonusMap = tBonusMap:DoConvolution(g_Suk_GaussianKernel_5x5)
tBonusMap:DoNormalise()

-- [HD] 按地图尺寸铺满，别挂在 #tPlotsData.Plots 上；缺失的补 0
for iPlot = 0, iWidth * iHeight - 1 do
	tPlotsData.LuxuryWeight[iPlot]	= tLuxuryMap.m_MapGrid[iPlot] or 0
	tPlotsData.BonusWeight[iPlot]	= tBonusMap.m_MapGrid[iPlot] or 0
end
--======================================================================================================================
-- Score Luxuries for each continent
--======================================================================================================================
local tContinentLuxuries = {}

for iResource, tResource in pairs(tLuxuries) do

	local iFrequency = tResource.SeaFrequency
	tContinentLuxuries[iResource] = {}

	for iContinent, tWaterPlots in pairs(tContinentWaterPlots) do

		--local iValidPlots = 0
		tContinentLuxuries[iResource][iContinent] = {Score = 0, Plots = {}}

		for _, iPlot in pairs(tWaterPlots) do
			if CanHaveResource(tPlotsData.Plots[iPlot], iResource) then
				--iValidPlots = iValidPlots + 1
				table.insert(tContinentLuxuries[iResource][iContinent].Plots, iPlot)
			end
		end

		-- if tLakeOnly[iResource] then
		-- 	tContinentLuxuries[iResource][iContinent].Score = iValidPlots * iFrequency * iLakesMultiplier
		-- else
		-- 	tContinentLuxuries[iResource][iContinent].Score = iValidPlots * iFrequency
		-- end

		local iResourcePlots = #tContinentLuxuries[iResource][iContinent].Plots
		tContinentLuxuries[iResource][iContinent].Score = math.floor((iTargetPercentage/100) * iResourcePlots * (iLuxuryPercentage/100) * iFrequency + 0.5) * 100
	end
end
--======================================================================================================================
-- Pick Resources for each Continent
--======================================================================================================================
local tResourcesToPlace = {}

for iContinent, _ in pairs(tContinentWaterPlots) do
	-------------------------------------------------
	-- Pick two random resources
	-------------------------------------------------
	local tCards	= {}
	local tWeights	= {}
	local iCount	= 0

	for iResource, tResource in pairs(tLuxuries) do
		if tContinentLuxuries[iResource][iContinent].Score > 0 then
			iCount				= iCount + 1
			tCards[iCount]		= iResource
			tWeights[iCount]	= tContinentLuxuries[iResource][iContinent].Score
		end
	end

	local tResources = tCards
	if iCount >= 2 then
		tResources = {DrawRandomCards(tCards, tWeights, 2)}
	end
	-------------------------------------------------
	-- After two resources have been picked:
	-------------------------------------------------
	if #tResources > 0 then
		for _,iResource in ipairs(tResources) do
			-------------------------------------------------
			-- Enter the resource into the resources to place table
			-------------------------------------------------
			local iFrequency = tLuxuries[iResource].SeaFrequency
			local iResourcePlots = #tContinentLuxuries[iResource][iContinent].Plots

			local tEntry = {
				Resource = iResource,
				Continent = iContinent,
				Score = math.floor((iTargetPercentage/100) * iResourcePlots * iFrequency * (iLuxuryPercentage/100) + 0.5)
			}

			table.insert(tResourcesToPlace, tEntry)
			-------------------------------------------------
			-- Lower the score for the selected resources
			-- to make them less likely to be picked again
			-------------------------------------------------
			local iScoreToSubtract = tContinentLuxuries[iResource][iContinent].Score

			for iContinent, tWaterPlots in pairs(tContinentWaterPlots) do
				local iScore = tContinentLuxuries[iResource][iContinent].Score
				iScore = math.max(iScore - iScoreToSubtract, 1)
				tContinentLuxuries[iResource][iContinent].Score = iScore
			end
		end
	end
end
-------------------------------------------------
-- Sort Resources by number of Plots
-------------------------------------------------
table.sort(tResourcesToPlace, function(a, b)
	return a.Score < b.Score
end)
--======================================================================================================================
-- Place Luxuries
--======================================================================================================================
function PlaceResource(pPlot, iResource)
	ResourceBuilder.SetResourceType(pPlot, iResource, 1)

	for pLoopPlot in PlotRingIterator(pPlot, 1) do
		local iLoopPlot = pLoopPlot:GetIndex()
		tPlotsData.NearbyLuxuries[iLoopPlot] = tPlotsData.NearbyLuxuries[iLoopPlot] + 3
	end
	for pLoopPlot in PlotRingIterator(pPlot, 2) do
		local iLoopPlot = pLoopPlot:GetIndex()
		tPlotsData.NearbyLuxuries[iLoopPlot] = tPlotsData.NearbyLuxuries[iLoopPlot] + 2
	end
	for pLoopPlot in PlotRingIterator(pPlot, 3) do
		local iLoopPlot = pLoopPlot:GetIndex()
		tPlotsData.NearbyLuxuries[iLoopPlot] = tPlotsData.NearbyLuxuries[iLoopPlot] + 1
	end
end

for _, tRow in pairs(tResourcesToPlace) do

	local iResource = tRow.Resource
	local iContinent = tRow.Continent
	local iTargetOccurences = tRow.Score

	print("Placing Resource:\t" ..  tLuxuries[iResource].ResourceType)
	print("On Continent:\t" .. iContinent)
	-------------------------------------------------
	-- Sort Plots by Heatmap Score
	-------------------------------------------------
	local tResourcePlots = tContinentLuxuries[iResource][iContinent].Plots
	table.sort(tResourcePlots, function(a, b)
		-- [HD] 兜底：权重缺失时当 0，别让整个脚本因为一个 nil 被打断
		return (tPlotsData.LuxuryWeight[a] or 0) > (tPlotsData.LuxuryWeight[b] or 0)
	end)
	-------------------------------------------------
	-- Calcuate number of tiles to place
	-------------------------------------------------
	if iTargetOccurences > 10 then
		iTargetOccurences = (
			iTargetOccurences - math.ceil((Map.GetMapSize()+1)/2)
			+ TerrainBuilder.GetRandomNumber(Map.GetMapSize()+1, "Target Occurences Adjust - Lua")
		)
	end

	iTargetOccurences = math.floor(iTargetOccurences + 0.5)

	print("Valid Plots:\t\t" ..  #tResourcePlots)
	print("Target Occurences:\t" ..  iTargetOccurences)

	local iOccurences = 0
	local iMaxWeight = 0
	for _, iPlot in ipairs(tResourcePlots) do
		if tPlotsData.LuxuryWeight[iPlot] > iMaxWeight then
			iMaxWeight = tPlotsData.LuxuryWeight[iPlot]
		end
	end
	-------------------------------------------------
	-- Actually Place Resources
	-------------------------------------------------
	for _, iPlot in ipairs(tResourcePlots) do
		local pPlot = tPlotsData.Plots[iPlot]
		if CanHaveResource(pPlot, iResource) then

			local bPlaced	= false
			local iWeight	= tPlotsData.LuxuryWeight[iPlot]/iMaxWeight
			local iNearby	= tPlotsData.NearbyLuxuries[iPlot]
			local iScore	= (iWeight^0.666) * (6 - iNearby) * 0.1666 * 100

			-- Be a bit more lax with lake resource placement
			if tLakeOnly[iResource] then
				iScore = iScore * iLakesMultiplier
			end

			if(TerrainBuilder.GetRandomNumber(100, "Resources Placement Score - Lua") <= iScore) then
				PlaceResource(pPlot, iResource)
				iOccurences = iOccurences + 1
			end
		end

		if iOccurences >= iTargetOccurences then break end
	end
	if iOccurences == 0 then
		iTargetOccurences = math.ceil(iTargetOccurences/2)
		for _, iPlot in ipairs(tResourcePlots) do
			local pPlot = tPlotsData.Plots[iPlot]
			if CanHaveResource(pPlot, iResource) then
				PlaceResource(pPlot, iResource)
				iOccurences = iOccurences + 1
			end

			if iOccurences >= iTargetOccurences then break end
		end
	end

	print("Occurences Placed:\t" ..  iOccurences)
end
--======================================================================================================================
--======================================================================================================================