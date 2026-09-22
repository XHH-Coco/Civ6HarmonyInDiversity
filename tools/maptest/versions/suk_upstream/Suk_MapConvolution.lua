--======================================================================================================================
-- Suk_MapConvolution
-- Author: Sukritact
-- DateCreated: 4/13/2021 5:54:26 PM
--======================================================================================================================
g_Suk_GaussianKernel_3x3 =	{
	0.077847,	0.123317,	0.077847,
	0.123317,	0.195346,	0.123317,
	0.077847,	0.123317,	0.077847,
}

g_Suk_GaussianKernel_5x5 =	{
	0.003765,	0.015019,	0.023792,	0.015019,	0.003765,
	0.015019,	0.059912,	0.094907,	0.059912,	0.015019,
	0.023792,	0.094907,	0.150342,	0.094907,	0.023792,
	0.015019,	0.059912,	0.094907,	0.059912,	0.015019,
	0.003765,	0.015019,	0.023792,	0.015019,	0.003765,
}

g_Suk_GaussianKernel_7x7 =	{
	0.000036,	0.000363,	0.001446,	0.002291,	0.001446,	0.000363,	0.000036,
	0.000363,	0.003676,	0.014662,	0.023226,	0.014662,	0.003676,	0.000363,
	0.001446,	0.014662,	0.058488,	0.092651,	0.058488,	0.014662,	0.001446,
	0.002291,	0.023226,	0.092651,	0.146768,	0.092651,	0.023226,	0.002291,
	0.001446,	0.014662,	0.058488,	0.092651,	0.058488,	0.014662,	0.001446,
	0.000363,	0.003676,	0.014662,	0.023226,	0.014662,	0.003676,	0.000363,
	0.000036,	0.000363,	0.001446,	0.002291,	0.001446,	0.000363,	0.000036,
}

function Select (n, ...)
	return arg[n]
end

function Suk_iter2D (x1, y1, x2, y2)
	local i = 0
	local x = x1 - 1
	local y = y1
	return function ()
		i = i + 1
		x = x + 1
		if x <= x2 then
			return x, y, i
		else
			x = x1
			y = y + 1
			if y <= y2 then
				return x, y, i
			end
		end
	end
end

Suk_MapConvolution = {
	------------------------------------------------------------------
	-- Properties
	------------------------------------------------------------------
		m_MapWidth	= Map.GetGridSize();
		m_MapHeight	= Select(2, Map.GetGridSize());
		m_WrapX		= Map:IsWrapX();
		m_WrapY		= Map:IsWrapY();
	------------------------------------------------------------------
	-- Constructor
	------------------------------------------------------------------
		new = function(self, padding, limiter)
			local o = {}
			setmetatable(o, self)
			self.__index = self

			o.m_Padding = padding
			-- If you wanna be lazy and NOT run convolution on certain plots
			-- Flawed results ofc, but probs good enough
			o.m_Limiter = limiter
			o.m_MapGrid = {}

			return o
		end,
	------------------------------------------------------------------
	-- Get/Set
	------------------------------------------------------------------
		ProcessCoordinate = function(self, coord, maxVal, isWrap)
			local new_coord = math.min(math.max(coord, 0), maxVal - 1)
			if new_coord ~= coord then
				if isWrap then
					-- is the coordinate too small?
					if coord < 0 then
						new_coord = coord + maxVal
					-- We already checked that the coord isn't in range, so if it's not less than 0 then it had to be greater than the max
					-- No need to add a superfluous check
					else
						new_coord = coord - maxVal
					end
				else
					if self.m_Padding then
						new_coord = -1
					end
				end
			end

			return new_coord
		end,

		Get = function(self, x, y)
			local x = self:ProcessCoordinate(x,	self.m_MapWidth,	self.m_WrapX)
			local y = self:ProcessCoordinate(y,	self.m_MapHeight,	self.m_WrapY)

			if (x == -1 ) or (y == -1) then
				return self.m_Padding, x, y
			else
				return self.m_MapGrid[y * self.m_MapWidth + x], x, y
			end
		end,

		Set = function(self, x, y, val)
			local x = self:ProcessCoordinate(x,	self.m_MapWidth,	self.m_WrapX)
			local y = self:ProcessCoordinate(y,	self.m_MapHeight,	self.m_WrapY)

			if (x == -1 )or (y == -1) then
				return
			else
				self.m_MapGrid[y * self.m_MapWidth + x] = val
			end
		end,
	------------------------------------------------------------------
	-- Convolution
	-- Let's just assume the kernel is a square, I can't see you needing a non-square kernel anyway
	------------------------------------------------------------------
		DoConvolution = function(self, kernel)
			local half_length = math.floor(math.sqrt(#kernel)/2)
			local new_grid = Suk_MapConvolution:new(self.m_Padding, self.m_Limiter)

			for plotX, plotY in Suk_iter2D(0, 0, self.m_MapWidth-1, self.m_MapHeight-1) do
				local plotIndex = plotY * self.m_MapWidth + plotX

				if (not self.m_Limiter) or (self.m_Limiter(plotIndex)) then
					local new_value = 0

					for kernelX, kernelY, kernelIndex in Suk_iter2D(-half_length, -half_length, half_length, half_length) do
						new_value = (new_value + (self:Get(plotX + kernelX, plotY + kernelY) * kernel[kernelIndex]))
					end

					new_grid.m_MapGrid[plotY * self.m_MapWidth + plotX] = new_value
				else
					new_grid.m_MapGrid[plotY * self.m_MapWidth + plotX] = self.m_MapGrid[plotY * self.m_MapWidth + plotX]
				end
			end

			return new_grid
		end,
	------------------------------------------------------------------
	-- Normalise
	------------------------------------------------------------------
		DoNormalise = function(self)

			local iMin = 0
			local iMax = 0

			for i,v in pairs(self.m_MapGrid) do
				iMin = math.min(iMin, v)
				iMax = math.max(iMax, v)
			end

			local iRange = iMax - iMin

			for i,v in pairs(self.m_MapGrid) do
				self.m_MapGrid[i] = (v - iMin)/iRange
			end
		end
}

