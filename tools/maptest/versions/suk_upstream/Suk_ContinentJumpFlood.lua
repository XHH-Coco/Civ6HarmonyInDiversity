-- Suk_ContinentJumpFlood
-- Author: Sukritact
-- DateCreated: 8/7/2021 5:05:39 PM
--======================================================================================================================
-- References
-- https://bgolus.medium.com/the-quest-for-very-wide-outlines-ba82ed442cd9
-- https://observablehq.com/@rreusser/gpu-voronoi-diagrams-using-the-jump-flooding-algorithm
-- https://blog.demofox.org/2016/02/29/fast-voronoi-diagrams-and-distance-dield-textures-on-the-gpu-with-the-jump-flooding-algorithm/
-- https://twitter.com/freyaholmer/status/1292536599230775296?lang=en
-- https://computergraphics.stackexchange.com/questions/4830/understanding-jump-flooding-algorithm-jfa-for-voronoi-diagrams
--
-- https://www.redblobgames.com/grids/hexagons/
--======================================================================================================================
-- Defines
--======================================================================================================================
local m_SQRT_3 = math.sqrt(3) -- For calculating Hex distance

local m_WRAP_X = Map.IsWrapX()
local m_WRAP_Y = Map.IsWrapY()

local m_MAP_WIDTH, m_MAP_HEIGHT = Map.GetGridSize()
local m_PIXEL_WIDTH = m_MAP_WIDTH * m_SQRT_3
local m_PIXEL_HEIGHT = m_MAP_HEIGHT * 1.5
--======================================================================================================================
-- Generic Functions
--======================================================================================================================
local function Log_CustomBase(iNum, iBase)
	return math.log(iNum)/math.log(iBase)
end

local function GetDistance_SingleAxis(iPixel, iSeedPixel, iPixelMax, bWrap)
	local iDelta

	if bWrap then
		local iDelta1 =  math.abs(iPixel - (iSeedPixel - iPixelMax))
		local iDelta2 =  math.abs(iPixel - iSeedPixel)
		local iDelta3 =  math.abs(iPixel - (iSeedPixel + iPixelMax))
		iDelta = math.min(iDelta1, iDelta2, iDelta3)
	else
		iDelta = iPixel - iSeedPixel
	end

	return iDelta
end

local function GetWrappedCoords(iCoord, iMaxCoord, bWrap)
	if bWrap then
		if iCoord < 0 then
			iCoord = iCoord + iMaxCoord
		elseif iCoord >= iMaxCoord then
			iCoord = iCoord - iMaxCoord
		end
	end

	local bIsValid = (not (iCoord < 0)) and (iCoord < iMaxCoord)

	return iCoord, bIsValid
end
--======================================================================================================================
-- Pack/Unpack Map
--======================================================================================================================
local function PackMap()

	-- ----------------------------------------------
	-- NGL, really wish Lua had shorthand for 2D table init.
	-- ----------------------------------------------
	local tMapArray = {}
	for iX = 0, m_MAP_WIDTH - 1 do
		tMapArray[iX] = {} -- Create Column
		for iY = 0, m_MAP_HEIGHT - 1 do
			tMapArray[iX][iY] = {-1, -1, -1} -- Create Entry
		end
	end
	-- ----------------------------------------------
	for iY = 0, m_MAP_HEIGHT - 1 do
		for iX = 0, m_MAP_WIDTH - 1 do

			local iPlot			= iY * m_MAP_WIDTH + iX
			local pPlot			= Map.GetPlotByIndex(iPlot)
			local iContinent	= pPlot:GetContinentType()

			local iSeedX		= (iContinent > -1) and iX or -1
			local iSeedY		= (iContinent > -1) and iY or -1

			tMapArray[iX][iY] = {iSeedX, iSeedY, iContinent}
		end
	end

	return tMapArray
end

local function UnpackMap(tMapArray)
	tContinentPlots = {
		Continents = {},
		Plots = {},
	}

	for iY = 0, m_MAP_HEIGHT - 1 do
		for iX = 0, m_MAP_WIDTH - 1 do
			local iContinent = tMapArray[iX][iY][3]
			local iPlot			= iY * m_MAP_WIDTH + iX

			if not tContinentPlots.Continents[iContinent] then
				tContinentPlots.Continents[iContinent] = {}
			end

			table.insert(tContinentPlots.Continents[iContinent], iPlot)
			tContinentPlots.Plots[iPlot] = iContinent
		end
	end

	return tContinentPlots
end
--======================================================================================================================
-- Jump Flood Algorithm
--======================================================================================================================
local function JumpFloodingStep(tMapArray, iStep)

	local tNewArray = {}
	for iX = 0, m_MAP_WIDTH - 1 do
		tNewArray[iX] = {} -- Create Column
		for iY = 0, m_MAP_HEIGHT - 1 do
			tNewArray[iX][iY] = {-1, -1, -1} -- Create Entry
		end
	end

	local iStepSize = 2 ^ (math.ceil(Log_CustomBase(math.max(m_MAP_WIDTH, m_MAP_HEIGHT), 2) - iStep - 1))

	for iX = 0, m_MAP_WIDTH - 1 do
		for iY = 0, m_MAP_HEIGHT - 1 do

			local tBestSeed		= tMapArray[iX][iY]
			local iBestDistance	= math.huge

			local iPixelX = m_SQRT_3 * (iX + ((iY % 2 == 0) and 0 or 0.5))
			local iPixelY = 1.5 * iY

			for iOffsetX = -iStepSize, iStepSize, iStepSize do
				for iOffsetY = -iStepSize, iStepSize, iStepSize do

					local iCoordX, bValidX = GetWrappedCoords(iX + iOffsetX, m_MAP_WIDTH, m_WRAP_X)
					local iCoordY, bValidY = GetWrappedCoords(iY + iOffsetY, m_MAP_HEIGHT, m_WRAP_Y)

					if bValidX and bValidY then
						local tSeed		= tMapArray[iCoordX][iCoordY]

						if tSeed[3] >= 0 then
							local iSeedX	= tSeed[1]
							local iSeedY	= tSeed[2]

							iSeedX = m_SQRT_3 * (iSeedX + ((iSeedY % 2) * 0.5))
							iSeedY = 1.5 * iSeedY

							local iDeltaX = GetDistance_SingleAxis(iPixelX, iSeedX, m_PIXEL_WIDTH, m_WRAP_X)
							local iDeltaY = GetDistance_SingleAxis(iPixelY, iSeedY, m_PIXEL_HEIGHT, m_WRAP_Y)

							local iDistance = (iDeltaX * iDeltaX) + (iDeltaY * iDeltaY) -- This is fine, no need to sqrt it

							if iDistance < iBestDistance then
								tBestSeed = tSeed
								iBestDistance = iDistance
							end
						end
					end
				end
			end

			tNewArray[iX][iY] = tBestSeed

		end
	end

	return tNewArray
end
--======================================================================================================================
-- Suk_GetPlotContinents
--======================================================================================================================
function Suk_GetPlotContinents()
	local tMapArray		= PackMap()
	local iCurrentPass	= 0
	local iMaxPass		= math.ceil(Log_CustomBase(math.max(m_MAP_WIDTH, m_MAP_HEIGHT), 2))

	while iCurrentPass < iMaxPass do
		tMapArray = JumpFloodingStep(tMapArray, iCurrentPass)
		iCurrentPass = iCurrentPass + 1
	end

	return UnpackMap(tMapArray)
end
--======================================================================================================================
--======================================================================================================================