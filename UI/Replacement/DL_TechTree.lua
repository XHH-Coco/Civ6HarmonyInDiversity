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
local FREE_TECH_KEY_ZH = 'HD_FREE_TECH_ZH';
local FREE_TECH_KEY_HP = 'HD_FREE_TECH_HP';
local FREE_TECH_KEY_MAGICA = 'HD_FREE_TECH_MAGICA';
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
		local remains_ZH = player:GetProperty(FREE_TECH_KEY_ZH) or 0;
		local remains_HP = player:GetProperty(FREE_TECH_KEY_HP) or 0;
		local remains_magica = player:GetProperty(FREE_TECH_KEY_MAGICA) or 0;
		if (remains_ZH) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetTechs():CanResearch(item.Index) and (GameInfo.Technologies[item.Index].EraType == 'ERA_CLASSICAL') then
			ExposedMembers.GameEvents.HD_FreeTechSwitchZH.Call(localPlayerId, item.Index);
		elseif (remains) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetTechs():CanResearch(item.Index) then
			ExposedMembers.GameEvents.HD_FreeTechSwitch.Call(localPlayerId, item.Index);
		elseif (remains_HP) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetTechs():CanResearch(item.Index) then
			ExposedMembers.GameEvents.HD_FreeTechSwitchHP.Call(localPlayerId, item.Index);
		elseif (remains_magica) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) then
			ExposedMembers.GameEvents.HD_FreeTechSwitchMagica.Call(localPlayerId, item.Index);
		end
	end);
	uiNode.IconButton:RegisterMouseEnterCallback(function()
		local localPlayerId = Game.GetLocalPlayer();
		local player = Players[localPlayerId];
		local remains = player:GetProperty(FREE_TECH_KEY) or 0;
		local remains_ZH = player:GetProperty(FREE_TECH_KEY_ZH) or 0;
		local remains_HP = player:GetProperty(FREE_TECH_KEY_HP) or 0;
		local remains_magica = player:GetProperty(FREE_TECH_KEY_MAGICA) or 0;
		if (remains_ZH) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetTechs():CanResearch(item.Index) and (GameInfo.Technologies[item.Index].EraType == 'ERA_CLASSICAL') then
			uiNode.NodeButton:SetToolTipString(Locale.Lookup("LOC_UNCLOCK_FREE_TECH", remains_ZH));
		elseif (remains) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetTechs():CanResearch(item.Index) then
			uiNode.NodeButton:SetToolTipString(Locale.Lookup("LOC_UNCLOCK_FREE_TECH", remains));
		elseif (remains_HP) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetTechs():CanResearch(item.Index) then
			uiNode.NodeButton:SetToolTipString(Locale.Lookup("LOC_UNCLOCK_FREE_TECH", remains_HP));
		elseif (remains_magica) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) then
			uiNode.NodeButton:SetToolTipString(Locale.Lookup("LOC_UNCLOCK_FREE_TECH_MAGICA", remains_magica));
		end
	end);
	uiNode.IconButton:RegisterMouseExitCallback(function()
		local localPlayerId = Game.GetLocalPlayer();
		uiNode.NodeButton:SetToolTipString(ToolTipHelper.GetToolTip(item.Type, localPlayerId));
	end);
end;