local files = {
	"TechTree_AustraliaScenario.lua",
	"TechTree_Expansion2.lua",
	"TechTree_Expansion1.lua",
	"TechTree.lua"
}

for _, file in ipairs(files) do
	include(file);
	if Initialize then
		print("DL_TechTree Loading " .. file .. " as base file");
		break;
	end
end

local FREE_TECH_KEY = 'HD_FREE_TECH';
PopulateNode_Base = PopulateNode;

function PopulateNode (uiNode, playerTechData)
	PopulateNode_Base(uiNode, playerTechData);
	local item = g_kItemDefaults[uiNode.Type];
	local live = playerTechData[DATA_FIELD_LIVEDATA][uiNode.Type];
	local status = live.IsRevealed and live.Status or ITEM_STATUS.UNREVEALED;

	uiNode.IconButton:RegisterCallback(Mouse.eLClick, function() 
		local localPlayerId = Game.GetLocalPlayer();
		local player = Players[localPlayerId];
		local remains = player:GetProperty(FREE_TECH_KEY) or 0;
		if (remains) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetTechs():CanResearch(item.Index) then
			ExposedMembers.GameEvents.HD_FreeTechSwitch.Call(localPlayerId, item.Index);
		end
	end);

	uiNode.IconButton:RegisterMouseEnterCallback(function()
		local localPlayerId = Game.GetLocalPlayer();
		local player = Players[localPlayerId];
		local remains = player:GetProperty(FREE_TECH_KEY) or 0;
		if (remains) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetTechs():CanResearch(item.Index) then
			uiNode.NodeButton:SetToolTipString(Locale.Lookup("LOC_UNCLOCK_FREE_TECH", remains));
		end
	end);

	uiNode.IconButton:RegisterMouseExitCallback(function()
		local localPlayerId = Game.GetLocalPlayer();
		uiNode.NodeButton:SetToolTipString(ToolTipHelper.GetToolTip(item.Type, localPlayerId));
	end);
end;