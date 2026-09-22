-- 合并后：状态与函数都在 MapUtilities 里，共享 chunk-local upvalue
local g_IslandLayer = {};

function SetIslandLayer(plotTypes)
	g_IslandLayer = plotTypes;
end

function Adjacent(index)
	local aIslands = g_IslandLayer;
	index = index -1;

	if(aIslands == nil) then
		return false;
	end
	
	if(index < 0) then
		return false
	end

	local plot = Map.GetPlotByIndex(index);
	if(aIslands[index] ~= nil and aIslands[index] == g_PLOT_TYPE_LAND) then
		return true;
	end

	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
		if(adjacentPlot ~= nil) then
			local newIndex = adjacentPlot:GetIndex();
			if(aIslands  ~= nil and aIslands[newIndex] == g_PLOT_TYPE_LAND) then
				return true;
			end
		end
	end

	return false;
end

function AdjacentCount(index)
	local aIslands = g_IslandLayer;
	index = index -1;

	if(aIslands == nil) then
		return 0;
	end
	
	if(index < 0) then
		return 0;
	end

	local plot = Map.GetPlotByIndex(index);
	if(aIslands[index] ~= nil and aIslands[index] == g_PLOT_TYPE_LAND) then
		return 7;
	end

	local adjCount = 0;
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
		if(adjacentPlot ~= nil) then
			local newIndex = adjacentPlot:GetIndex();
			if(aIslands  ~= nil and aIslands[newIndex] == g_PLOT_TYPE_LAND) then
				adjCount = adjCount+1;
			end
		end
	end

	return adjCount;
end

