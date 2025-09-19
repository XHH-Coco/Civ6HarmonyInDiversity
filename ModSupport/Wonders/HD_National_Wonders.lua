-- 民族史诗
function NationEpicGreatPersonAddYield(playerId, unitId, greatPersonClassId, greatPersonIndividualId)
	local player = Players[playerId]
	local greatPersonClassType = GameInfo.GreatPersonClasses[greatPersonClassId].GreatPersonClassType
	-- print('NationEpicGreatPersonAddYield', greatPersonClassType)
	player:AttachModifierByID('HD_NAT_NATIONALEPIC_' .. greatPersonClassType .. '_ATTACH')
end

Events.UnitGreatPersonCreated.Add(NationEpicGreatPersonAddYield)