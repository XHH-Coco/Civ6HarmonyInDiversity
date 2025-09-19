local files = {
	"CivicsTree.lua"
}

for _, file in ipairs(files) do
	include(file);
	if Initialize then
		print("DL_CivicsTree Loading " .. file .. " as base file");
		break;
	end
end

local FREE_CIVIC_KEY = 'HD_FREE_CIVIC';
local FREE_CIVIC_KEY_MAGICA = 'HD_FREE_CIVIC_MAGICA';
PopulateNode_Base = PopulateNode;
function PopulateNode (uiNode, playerTechData)
	PopulateNode_Base(uiNode, playerTechData);
	local item = g_kItemDefaults[uiNode.Type];
	local live = playerTechData[DATA_FIELD_LIVEDATA][uiNode.Type];
	local status = live.IsRevealed and live.Status or ITEM_STATUS.UNREVEALED;
	uiNode.IconButton:RegisterCallback(Mouse.eLClick, function() 
		local localPlayerId = Game.GetLocalPlayer();
		local player = Players[localPlayerId];
		local remains = player:GetProperty(FREE_CIVIC_KEY) or 0;
		local remains_magica = player:GetProperty(FREE_CIVIC_KEY_MAGICA) or 0;
		if (remains) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetCulture():CanProgress(item.Index) then
			ExposedMembers.GameEvents.HD_FreeCivicSwitch.Call(localPlayerId, item.Index);
		elseif (remains_magica) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) then
			ExposedMembers.GameEvents.HD_FreeCivicSwitchMagica.Call(localPlayerId, item.Index);
		end
	end);
	uiNode.IconButton:RegisterMouseEnterCallback(function()
		local localPlayerId = Game.GetLocalPlayer();
		local player = Players[localPlayerId];
		local remains = player:GetProperty(FREE_CIVIC_KEY) or 0;
		local remains_magica = player:GetProperty(FREE_CIVIC_KEY_MAGICA) or 0;
		if (remains) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) and player:GetCulture():CanProgress(item.Index) then
			uiNode.NodeButton:SetToolTipString(Locale.Lookup("LOC_UNCLOCK_FREE_CIVIC", remains));
		elseif (remains_magica) > 0 and (status ~= ITEM_STATUS.RESEARCHED) and (status ~= ITEM_STATUS.UNREVEALED) then
			uiNode.NodeButton:SetToolTipString(Locale.Lookup("LOC_UNCLOCK_FREE_CIVIC_MAGICA", remains_magica));
		end
	end);
	uiNode.IconButton:RegisterMouseExitCallback(function()
		local localPlayerId = Game.GetLocalPlayer();
		uiNode.NodeButton:SetToolTipString(ToolTipHelper.GetToolTip(item.Type, localPlayerId));
	end);
end;