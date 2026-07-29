ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

local PROPHET_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_PROPHET'].Index;
local WRITER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_WRITER'].Index;

local ARMAGH_PROPHET_TO_WRITER_PERCENTAGE = GlobalParameters.HD_ARMAGH_PROPHET_TO_WRITER_PERCENTAGE or 0;
function ArmaghPlayerTurnActivated(playerId, isFirstTime)
	local player = Players[playerId];
  if not player then return; end

  local is = player:GetProperty('HD_ARMAGH_SUZERAIN_FOUNDED_A_RELIGION') or 0;
	if isFirstTime and is > 0 and player:GetProperty('HDPlayerHasReligion') == 1 then
    local amount = math.floor(Utils.GetGreatPeoplePointsPerTurn(playerId, PROPHET_INDEX) * ARMAGH_PROPHET_TO_WRITER_PERCENTAGE / 100);
    player:GetGreatPeoplePoints():ChangePointsTotal(WRITER_INDEX, amount);
	end
end
Events.PlayerTurnActivated.Add(ArmaghPlayerTurnActivated);