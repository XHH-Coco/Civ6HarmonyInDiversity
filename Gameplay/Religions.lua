Utils = ExposedMembers.DLHD.Utils;

-- Founder Belief

-- To the Glory of God:
-- 33% chance getting a relic when a GreatPerson is fully consumed.
function OnGreatPersonActivated(unitOwner, unitID)
	local unit = UnitManager.GetUnit(unitOwner, unitID);

	if (unit ~= nil) and (unit:GetGreatPerson() ~= nil) and (unit:GetX() < 0) and (unit:GetY() < 0) then
		-- The great person unit has used up all the charges or has been removed
		-- so it has been moved to (-9999, -9999) which is pending deletion.

		local PROP_KEY_NUMBER_USED_GREAT_PEOPLE = 'NumberOfUsedGreatPeople'
		-- Check if the owner has "To the Glory of God" belief.
		local religions = Game.GetReligion():GetReligions();
		local player = Players[unitOwner];
		for _, religion in ipairs(religions) do
			if (religion.Founder == unitOwner) then
				for _, beliefIndex in ipairs(religion.Beliefs) do
					if GameInfo.Beliefs[beliefIndex].BeliefType == "BELIEF_TO_THE_GLORY_OF_GOD" then
						-- The owner has "To the Glory of God" belief, give out a relic by 33% chance.
						-- local rand = math.random(1, 100);
						-- local rand = TerrainBuilder.GetRandomNumber(100, "Random for Relic");
						-- if (rand < 33) then
						--     Utils.GrantRelic(unitOwner);
						-- end
						local amount = player:GetProperty(PROP_KEY_NUMBER_USED_GREAT_PEOPLE);
						if amount == nil then
							amount = 0;
						end
						amount = amount + 1;
						if amount == 1 then
							Utils.GrantRelic(unitOwner);
						end
						-- Every three greatperson grant a relic.
						if amount == 3 then
							amount = 0;
						end
						player:SetProperty(PROP_KEY_NUMBER_USED_GREAT_PEOPLE, amount);
					end
				end
			end
		end
	end
end

Events.UnitGreatPersonActivated.Add(OnGreatPersonActivated)

-- 创建宗教
function ReligionFoundedSetProperty(playerId, religionId)
	local player = Players[playerId];

	if player then
		local capital = player:GetCities():GetCapitalCity();
		local plot = Map.GetPlot(capital:GetX(), capital:GetY());
		plot:SetProperty('HDPlayerHasReligion', 1);
		player:SetProperty('HDPlayerHasReligion', 1);

		-- 记录圣城
		local holyCityId = Utils.GetHolyCityID(playerId);
		if holyCityId == nil then return; end
		
		local holyCity = CityManager.GetCity(playerId, holyCityId)
		if holyCity then
			local holyCityPlot = Map.GetPlot(holyCity:GetX(), holyCity:GetY());
			if holyCityPlot then
				holyCityPlot:SetProperty('HD_IS_HOLY_CITY', 1)
			end
		end
	end
end
Events.ReligionFounded.Add(ReligionFoundedSetProperty)

function HolyCityConquered(playerId, cityId, x, y)
	local player = Players[playerId];
	local city = CityManager.GetCity(playerId, cityId)
	if player and city then
		local holyCityId = Utils.GetHolyCityID(playerId);
		if holyCityId ~= cityId then
			city:SetProperty('HD_IS_HOLY_CITY', 0)
		end
	end
end

--------------------------------------------------------------
-- Initialize
function ReligionsInitialize()
	Events.CityAddedToMap.Add(HolyCityConquered);
end
ReligionsInitialize();