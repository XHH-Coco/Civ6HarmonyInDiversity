----CivilizationandLeaderHasTrait
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

function CivilizationHasTrait(playerId, sTrait)
	if playerId == nil then
		print("ERROR playerId为nil")
		return false;
	end
	-- 根据 property 判断
	local player = Players[playerId];
	if not player then
		print("ERROR 该文明不存在")
		return false;
	end
	if player:GetProperty(sTrait .. "_CAPTURED") == true then
		return true;
	end
	
	-- 查表判断
	local playerConfig = PlayerConfigurations[playerId]
	local sCiv = playerConfig:GetCivilizationTypeName()
	for tRow in GameInfo.CivilizationTraits() do
		if (tRow.CivilizationType == sCiv and tRow.TraitType == sTrait) then
			return true;
		end
	end

	return false;
end
Utils.CivilizationHasTrait = CivilizationHasTrait;

function LeaderHasTrait(playerId, sTrait)
	if playerId == nil then
		print("ERROR playerId为nil")
		return false;
	end
	-- 根据 property 判断
	local player = Players[playerId];
	if not player then
		print("ERROR 该文明不存在")
		return false;
	end
	if player:GetProperty(sTrait .. "_CAPTURED") == true then
		return true;
	end

	-- 查表判断
	local playerConfig = PlayerConfigurations[playerId]
	local sLeader = playerConfig:GetLeaderTypeName()
	for tRow in GameInfo.LeaderTraits() do
		if (tRow.LeaderType == sLeader and tRow.TraitType == sTrait) then return
			true;
		end
	end

	return false;
end
Utils.LeaderHasTrait = LeaderHasTrait;

-- 伟人
local WRITER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_WRITER'].Index;
local ARTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ARTIST'].Index;
local MUSICIAN_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MUSICIAN'].Index;
local SCIENTIST_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_SCIENTIST'].Index;
local MERCHANT_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MERCHANT'].Index;
local ENGINEER_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ENGINEER'].Index;
local PROPHET_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_PROPHET'].Index;
local ADMIRAL_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ADMIRAL'].Index;
local GENERAL_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_GENERAL'].Index;

-- 区域
local DISTRICT_CITY_CENTER_INDEX = GameInfo.Districts['DISTRICT_CITY_CENTER'].Index
local DISTRICT_CAMPUS_INDEX = GameInfo.Districts['DISTRICT_CAMPUS'].Index
local DISTRICT_COMMERCIAL_HUB_INDEX = GameInfo.Districts['DISTRICT_COMMERCIAL_HUB'].Index
local DISTRICT_INDUSTRIAL_ZONE_INDEX = GameInfo.Districts['DISTRICT_INDUSTRIAL_ZONE'].Index
local DISTRICT_THEATER_INDEX = GameInfo.Districts['DISTRICT_THEATER'].Index
local DISTRICT_ENCAMPMENT_INDEX = GameInfo.Districts['DISTRICT_ENCAMPMENT'].Index
local DISTRICT_HARBOR_INDEX = GameInfo.Districts['DISTRICT_HARBOR'].Index

-- UD
local DISTRICT_COTHON_INDEX = GameInfo.Districts['DISTRICT_COTHON'].Index;
local DISTRICT_SEOWON_INDEX = GameInfo.Districts['DISTRICT_SEOWON'].Index;

-- =====================================================================================================================================
-- 中国
-- =====================================================================================================================================
local CHINA_TRAIT_MODIFIED = GlobalParameters.HD_CHINA_TRAIT_MODIFIED or 0;

-- 触发鼓舞获得科技值
local CHINA_TRIGGERED_INSPIRATIONS_TAG = 'HD_CHINA_TRIGGERED_INSPIRATIONS';
function ChinaTriggerInspiration(playerId, civicId)
	if CHINA_TRAIT_MODIFIED == 0 then return; end
	if CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_DYNASTIC_CYCLE') then
		local player = Players[playerId];
		local amount = player:GetProperty(CHINA_TRIGGERED_INSPIRATIONS_TAG) or 0;
		amount = amount + 1;
		player:SetProperty(CHINA_TRIGGERED_INSPIRATIONS_TAG, amount);
		player:GetTechs():ChangeCurrentResearchProgress(amount);
	end
	
end
Events.CivicBoostTriggered.Add(ChinaTriggerInspiration)

-- 完成市政获得科技值
local CHINA_COMPLETED_CIVICS_TAG = 'HD_CHINA_COMPLETED_CIVICS';
function ChinaCompleteCivic(playerId, civicId)
	if CHINA_TRAIT_MODIFIED == 0 then return; end
	if CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_DYNASTIC_CYCLE') then
		local player = Players[playerId]
		local amount = player:GetProperty(CHINA_COMPLETED_CIVICS_TAG) or 0;
		amount = amount + 1;
		player:SetProperty(CHINA_COMPLETED_CIVICS_TAG, amount);
		player:GetTechs():ChangeCurrentResearchProgress(amount);
	end
end
Events.CivicCompleted.Add(ChinaCompleteCivic)

local COMMEMORATION_HAS_TAG = 'HD_COMMEMORATION_HAS_';
local COMMEMORATION_CANNOT_SELECT_TAG = 'HD_COMMEMORATION_CANNOT_SELECT_';
local COMMEMORATION_CANNOT_SELECT_REASON_TAG = 'HD_COMMEMORATION_CANNOT_SELECT_REASON_';
local CHINA_LAST_ERA_SELECTED_COMMEMORATION_TAG = 'HD_CHINA_LAST_ERA_SELECTED_COMMEMORATION';
-- 每次过时代 Attach上个时代选择的着力点效果
function ChinaGameEraChanged(previousEraIndex, newEraIndex)
	if CHINA_TRAIT_MODIFIED == 0 then return; end
	local alivePlayers = PlayerManager.GetAliveMajorIDs()
	for _, playerId in ipairs(alivePlayers) do
		if CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_DYNASTIC_CYCLE') then
			local player = Players[playerId]
			local selectedCommemorationTypes = player:GetProperty(CHINA_LAST_ERA_SELECTED_COMMEMORATION_TAG) or {}
			for _, commemorationType in ipairs(selectedCommemorationTypes) do
				print("中国上个时代选择的着力点", Locale.Lookup(GameInfo.CommemorationTypes[commemorationType].CategoryDescription))
				for row in GameInfo.CommemorationModifiers() do
					if row.CommemorationType == commemorationType then
						-- 排除部分永久生效的 Modifier
						if row.ModifierId ~= 'COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_ADD_SLOT'
						and row.ModifierId ~= 'COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_ADD_SLOT_ATTACH'
						and row.ModifierId ~= 'COMMEMORATION_HD_ENLIGHTENED_DESPOTISM_ADD_SLOT_ATTACH_EXTRA'
						and row.ModifierId ~= 'COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_CHARGE'
						and row.ModifierId ~= 'COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_CHARGE_ATTACH'
						and row.ModifierId ~= 'COMMEMORATION_HD_RELIGIOUS_WAR_RELIGIOUS_CHARGE_ATTACH_EXTRA'
						and row.ModifierId ~= 'COMMEMORATION_AUTOMATON_GA_FREE_GDR'
						and row.ModifierId ~= 'COMMEMORATION_AUTOMATON_GA_FREE_GDR_ATTACH'
						and row.ModifierId ~= 'COMMEMORATION_AUTOMATON_GA_FREE_GDR_ATTACH_EXTRA'
						and row.ModifierId ~= 'COMMEMORATION_HD_WORLD_WAR_GRANT_GENERAL'
						and row.ModifierId ~= 'COMMEMORATION_HD_WORLD_WAR_GRANT_GENERAL_ATTACH'
						and row.ModifierId ~= 'COMMEMORATION_HD_WORLD_WAR_GRANT_GENERAL_ATTACH_EXTRA'
						and row.ModifierId ~= 'COMMEMORATION_ESPIONAGE_GRANT_SPY'
						and row.ModifierId ~= 'COMMEMORATION_ESPIONAGE_GRANT_SPY_ATTACH'
						and row.ModifierId ~= 'COMMEMORATION_ESPIONAGE_GRANT_SPY_ATTACH_EXTRA'
						and row.ModifierId ~= 'COMMEMORATION_HD_IDEOLOGY_STORM_FREE_CIVIC'
						and row.ModifierId ~= 'COMMEMORATION_HD_IDEOLOGY_STORM_FREE_CIVIC_ATTACH'
						and row.ModifierId ~= 'COMMEMORATION_HD_IDEOLOGY_STORM_FREE_CIVIC_ATTACH_EXTRA'
						and row.ModifierId ~= 'COMMEMORATION_HD_MEGA_CORPORATION_GRANT_MERCHANT'
						and row.ModifierId ~= 'COMMEMORATION_HD_MEGA_CORPORATION_GRANT_MERCHANT_ATTACH'
						and row.ModifierId ~= 'COMMEMORATION_HD_MEGA_CORPORATION_GRANT_MERCHANT_ATTACH_EXTRA'
						and row.ModifierId ~= 'COMMEMORATION_HD_DIGITAL_REVOLUTION_GRANT_SCIENTIST'
						and row.ModifierId ~= 'COMMEMORATION_HD_DIGITAL_REVOLUTION_GRANT_SCIENTIST_ATTACH'
						and row.ModifierId ~= 'COMMEMORATION_HD_DIGITAL_REVOLUTION_GRANT_SCIENTIST_ATTACH_EXTRA' then
							player:AttachModifierByID(row.ModifierId)
							print("中国上个时代选择的着力点 应用效果", row.ModifierId)
						end
					end
				end
			end
		end
	end
end
Events.GameEraChanged.Add(ChinaGameEraChanged)

-- 造奇观选择对应时代着力点
function ChinaSelectExtraCommemoration(playerId, param)
	local player = Players[playerId];
	local commemorationId = param.CommemorationId
	local isAncient = param.IsAncient

	if isAncient then
		local commemorationType = GameInfo.China_AncientCommemorationTypes_HD[commemorationId].AncientCommemorationType;
		print("中国选择专属远古着力点", Locale.Lookup(GameInfo.China_AncientCommemorationTypes_HD[commemorationId].Name))
		for row in GameInfo.ChinaLeaders_AncientCommemorationModifiers_HD() do
			if row.AncientCommemorationType == commemorationType then
				player:AttachModifierByID(row.ModifierId)
				print("中国选择专属远古着力点 应用效果", row.ModifierId)
			end
		end

		ChinaAncientCommemorationLuaEffects(playerId, commemorationId)
		player:SetProperty(COMMEMORATION_HAS_TAG .. 'ANCIENT_' .. commemorationId, 1)
		player:SetProperty(COMMEMORATION_CANNOT_SELECT_TAG .. 'ANCIENT_' .. commemorationId, 1)
		player:SetProperty(COMMEMORATION_CANNOT_SELECT_REASON_TAG .. 'ANCIENT_' .. commemorationId, 'LOC_COMMEMORATION_ALREADY_SELECTED')
	else
		local commemorationType = GameInfo.CommemorationTypes[commemorationId].CommemorationType
		print("中国造奇观选择着力点", Locale.Lookup(GameInfo.CommemorationTypes[commemorationId].CategoryDescription))
		for row in GameInfo.CommemorationModifiers() do
			if row.CommemorationType == commemorationType then
				player:AttachModifierByID(row.ModifierId)
				print("中国造奇观选择着力点 应用效果", row.ModifierId)
			end
		end

		player:SetProperty(COMMEMORATION_HAS_TAG .. commemorationId, 1)
		player:SetProperty(COMMEMORATION_CANNOT_SELECT_TAG .. commemorationId, 1)
		player:SetProperty(COMMEMORATION_CANNOT_SELECT_REASON_TAG .. commemorationId, 'LOC_COMMEMORATION_ALREADY_SELECTED')
	end
end
GameEvents.ChinaSelectExtraCommemoration.Add(ChinaSelectExtraCommemoration);

-- 招募特色伟人元万顷和司农司
local HD_CHINA_ANCIENT_COMMEMORATION_MUSIC_BOOK_INDEX = GameInfo.China_AncientCommemorationTypes_HD['HD_CHINA_ANCIENT_COMMEMORATION_MUSIC_BOOK'].Index;
local GREAT_PERSON_INDIVIDUAL_HD_YUAN_WAN_QING_INDEX = GameInfo.GreatPersonIndividuals['GREAT_PERSON_INDIVIDUAL_HD_YUAN_WAN_QING'].Index;
local GREAT_PERSON_CLASS_HD_YUAN_WAN_QING_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_HD_YUAN_WAN_QING'].Index;
local HD_CHINA_ANCIENT_COMMEMORATION_AGRICULTURAL_BOOK_INDEX = GameInfo.China_AncientCommemorationTypes_HD['HD_CHINA_ANCIENT_COMMEMORATION_AGRICULTURAL_BOOK'].Index;
local GREAT_PERSON_INDIVIDUAL_HD_SI_NONG_SI_INDEX = GameInfo.GreatPersonIndividuals['GREAT_PERSON_INDIVIDUAL_HD_SI_NONG_SI'].Index;
local GREAT_PERSON_CLASS_HD_SI_NONG_SI_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_HD_SI_NONG_SI'].Index;
function ChinaAncientCommemorationLuaEffects(playerId, ancientCommemorationId)
	if ancientCommemorationId == HD_CHINA_ANCIENT_COMMEMORATION_MUSIC_BOOK_INDEX then
		local era = Game.GetEras():GetCurrentEra();
		Game.GetGreatPeople():GrantPerson(GREAT_PERSON_INDIVIDUAL_HD_YUAN_WAN_QING_INDEX, GREAT_PERSON_CLASS_HD_YUAN_WAN_QING_INDEX, era, 0, playerId, false);
	elseif ancientCommemorationId == HD_CHINA_ANCIENT_COMMEMORATION_AGRICULTURAL_BOOK_INDEX then
		local era = Game.GetEras():GetCurrentEra();
		Game.GetGreatPeople():GrantPerson(GREAT_PERSON_INDIVIDUAL_HD_SI_NONG_SI_INDEX, GREAT_PERSON_CLASS_HD_SI_NONG_SI_INDEX, era, 0, playerId, false);
	end
end

-- 市舶司
-- local CHINA_SHIP_BUREAU_ENVOY_TARGET_TAG = 'HD_CHINA_SHIP_BUREAU_ENVOY_TARGET_';
-- function ShipBureauTradeRouteActivityChanged(playerId, originPlayerId, originCityId, targetPlayerId, targetCityId)
-- 	local player = Players[playerId];
-- 	local targetPlayer = Players[targetPlayerId];

-- 	if player:GetProperty(CHINA_SHIP_BUREAU_ENVOY_TARGET_TAG .. targetPlayerId) == 1 then
-- 		return;
-- 	end
-- 	local amount = player:GetProperty('HD_CHINA_SHIP_BUREAU_TAG') or 0;
-- 	if amount > 0 then
-- 		for i=1,amount,1 do
-- 			player:AttachModifierByID('HD_CHINA_SHIP_BUREAU_ENVOY');
-- 		end
-- 		player:SetProperty(CHINA_SHIP_BUREAU_ENVOY_TARGET_TAG .. targetPlayerId, 1);
-- 	end
-- end
-- Events.TradeRouteActivityChanged.Add(ShipBureauTradeRouteActivityChanged);

-- =====================================================================================================================================
-- 文老秦
local QIN_WORKER_BUILD_LATER_WONDER_PERCENTAGE = GlobalParameters.HD_QIN_WORKER_BUILD_LATER_WONDER_PERCENTAGE or 0;
local QIN_WORKER_BUILD_LATER_WONDER_ERA_SCORE = GlobalParameters.HD_QIN_WORKER_BUILD_LATER_WONDER_ERA_SCORE or 0;
-- 后续奇观加速
function QinBuilderLaterWonder(playerId, unitId)
	local player = Players[playerId];
	local unit = UnitManager.GetUnit(playerId, unitId);

	-- 推进进度
	local x = unit:GetX()
  local y = unit:GetY()
	local plot = Map.GetPlot(x, y);
	local city = Cities.GetPlotPurchaseCity(plot);
	Utils.CityAddProgressPercentage(playerId, city:GetID(), QIN_WORKER_BUILD_LATER_WONDER_PERCENTAGE, {WonderOnly = true})

	-- 扣除时代分
	Utils.ChangePlayerEraScore(playerId, QIN_WORKER_BUILD_LATER_WONDER_ERA_SCORE)
	Game.AddWorldViewText(playerId, QIN_WORKER_BUILD_LATER_WONDER_ERA_SCORE .. " [ICON_GLORY_NORMAL_AGE] " .. Locale.Lookup('LOC_CATEGORY_ERA_SCORE_NAME'), x, y);

	-- 消耗次数
	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
	-- print('QinBuilderLaterWonder', movesRemaining)
  unit:ChangeMovesRemaining(-movesRemaining)
  local unitAbility = unit:GetAbility()
  for i=1, 15, 1 do
    if unitAbility:GetAbilityCount('ABILITY_HD_BUILDER_NEGA_CHARGE_' .. i) == 0 then
      unitAbility:ChangeAbilityCount('ABILITY_HD_BUILDER_NEGA_CHARGE_' .. i, 1);
      break;
    end
  end
end
GameEvents.HD_Qin_Builder_Later_Wonder.Add(QinBuilderLaterWonder)

-- =====================================================================================================================================
-- 武老秦
-- 客卿招募
local KeqingPersonClass = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_KEQING"];
local EraScorePerKeqing = GlobalParameters.HD_WU_QIN_ERA_SCORE_PER_KEQING or 0;
local KeqingListTag = "HD_KeqingList";
local KeqingNumTag = "HD_KeqingNum";

function InitKeqing()
	local keqingList = {};
	for row in GameInfo.GreatPersonIndividuals() do
		if row.GreatPersonClassType == "GREAT_PERSON_CLASS_KEQING" then
			table.insert(keqingList, row.Index);
		end
	end
	return keqingList;
end

function GrantKeqing(playerId)
	if KeqingPersonClass == nil then return; end

	local player = Players[playerId];
	local keqingList = player:GetProperty(KeqingListTag);

	if keqingList == nil then
		print("武老秦招募客卿 初始化客卿列表")
		keqingList = InitKeqing()
	end
		
	if #keqingList < 1 then
		return; 
	else
		print("武老秦招募客卿 剩余可招募客卿数量", #keqingList)
		local alreadyNum = player:GetProperty(KeqingNumTag) or 0;
		player:SetProperty(KeqingNumTag, alreadyNum + 1)
		local randomIndex = Game.GetRandNum(#keqingList, "Random Keqing for Player " .. playerId) + 1
		local era = Game.GetEras():GetCurrentEra();
		Game.GetGreatPeople():GrantPerson(keqingList[randomIndex], KeqingPersonClass.Index, era, 0, playerId, false);
		table.remove(keqingList, randomIndex);
		player:SetProperty(KeqingListTag, keqingList);
	end
end

-- 时代分获得客卿
function WuQinPlayerEraScoreChanged(playerId, score)
	if EraScorePerKeqing > 0 and LeaderHasTrait(playerId, 'TRAIT_LEADER_QIN') then
		local player = Players[playerId];
		local capital = player:GetCities():GetCapitalCity()
		if capital == nil then
			print("武老秦招募客卿 首都不存在 跳过判定")
			return;
		end

		local alreadyNum = player:GetProperty(KeqingNumTag) or 0;
		local totalScore = Utils.GetPlayerCurrentScore(playerId)
		local totalNum = math.floor(totalScore / EraScorePerKeqing)
		local newNum = totalNum - alreadyNum;
		if newNum > 0 then
			for i=1,newNum,1 do
				GrantKeqing(playerId)
			end
		end
	end
end
Events.PlayerEraScoreChanged.Add(WuQinPlayerEraScoreChanged)

-- 占林原始首都秦锐士加力
local WuQinConqueredCapital_Tag = 'HD_WuQinConqueredCapital'
function WuQinConqueredCapital(playerId, cityId, x, y)
	-- 判断是否是原始首都
	if LeaderHasTrait(playerId, 'TRAIT_LEADER_QIN') and Utils.IsOriginalCapital(playerId, cityId) then
		-- 判断是否是其他文明
		local city = CityManager.GetCity(playerId, cityId)
		local originalOwnerId = city:GetOriginalOwner();
		if originalOwnerId ~= playerId then
			-- 判断是否是主要文明
			local originalOwner = Players[originalOwnerId]
			if originalOwner:IsMajor() then
				-- 判断是否是第一次
				local plot = Map.GetPlot(x, y)
				-- 最多叠加6次
				local player = Players[playerId];
				local amount = player:GetProperty(WuQinConqueredCapital_Tag) or 0;
				if plot and not plot:GetProperty(WuQinConqueredCapital_Tag) and amount < 6 then
					plot:SetProperty(WuQinConqueredCapital_Tag, 1)
					player:SetProperty(WuQinConqueredCapital_Tag, amount + 1)
					player:AttachModifierByID('HD_QIN_ELITE_SOLDIER_STRENGTH_SET_PROPERTY')
					player:AttachModifierByID('HD_WU_QIN_GREATWALL_PRODUCTION')
					print("武秦占领原始首都 秦锐士加战斗力 长城加生产力", amount + 1)
				end
			end
		end
	end
end
-- =====================================================================================================================================
-- 武则天
function WztUnitGreatPersonCreated(playerID, unitID, greatPersonClassID, greatPersonIndividualID)
	local player = Players[playerID];
	if not LeaderHasTrait(playerID, 'TRAIT_LEADER_WU_ZETIAN') then
		return;
	end
	for row in GameInfo.GreatPersonClasses() do
		if row.Index == greatPersonClassID then
			local classType = row.GreatPersonClassType;
			player:AttachModifierByID('WU_ZETIAN_' .. classType);
		end
	end
end
Events.UnitGreatPersonCreated.Add(WztUnitGreatPersonCreated);

-- 时代分送梅花内卫
local WU_ZETIAN_ERA_SCORE_PER_SPY = GlobalParameters.HD_WU_ZETIAN_ERA_SCORE_PER_SPY or 0;
local WU_ZETIAN_ERA_SCORE_TAG = "HD_WU_ZETIAN_ERA_SCORE_TAG";
function WuZetianPlayerEraScoreChanged(playerId, score)
	if WU_ZETIAN_ERA_SCORE_PER_SPY > 0 and LeaderHasTrait(playerId, 'TRAIT_LEADER_WU_ZETIAN') then
		local player = Players[playerId];
		local capital = player:GetCities():GetCapitalCity()
		if capital == nil then
			print("武则天梅花内卫 首都不存在 跳过判定")
			return;
		end

		local alreadyNum = player:GetProperty(WU_ZETIAN_ERA_SCORE_TAG) or 0;
		local totalScore = Utils.GetPlayerCurrentScore(playerId)
		local totalNum = math.floor(totalScore / WU_ZETIAN_ERA_SCORE_PER_SPY)
		local newNum = totalNum - alreadyNum;
		if newNum > 0 then
			for i=1,newNum,1 do
				player:AttachModifierByID('HD_WU_ZETIAN_GRANT_PLUM_INTERNAL_SECURITY')
			end
		end
		player:SetProperty(WU_ZETIAN_ERA_SCORE_TAG, totalNum)
	end
end
Events.PlayerEraScoreChanged.Add(WuZetianPlayerEraScoreChanged)

-- 梅花内卫获取伟人点
local WU_ZETIAN_SPY_GPP_SELF = GlobalParameters.HD_WU_ZETIAN_SPY_GPP_SELF or 0;
local WU_ZETIAN_SPY_GPP_OTHER = GlobalParameters.HD_WU_ZETIAN_SPY_GPP_OTHER or 0;
local WU_ZETIAN_SPY_EXP_SELF = GlobalParameters.HD_WU_ZETIAN_SPY_EXP_SELF or 0;
local WU_ZETIAN_SPY_EXP_OTHER = GlobalParameters.HD_WU_ZETIAN_SPY_EXP_OTHER or 0;
local PLUM_INTERNAL_SECURITY_NUM_TAG = 'HD_PLUM_INTERNAL_SECURITY_NUM';
local HASH_NOTIFICATION_PLUM_INTERNAL_SECURITY_GPP = DB.MakeHash('NOTIFICATION_PLUM_INTERNAL_SECURITY_GPP');
function WuZetianSpyEarnGPP(playerId)
	local player = Players[playerId]
	local hasWztSpy = player:GetProperty(PLUM_INTERNAL_SECURITY_NUM_TAG) or 0;
	
	if hasWztSpy > 0 then
		local gppList = {}
		print("武则天 开始遍历单位检索梅花内卫")
		for _, unit in player:GetUnits():Members() do
			if Utils.IsUnit(unit:GetType(), "UNIT_PLUM_INTERNAL_SECURITY_HD", true) then
				local expAmount = 0;
				local plots = Map.GetNeighborPlots(unit:GetX(), unit:GetY(), 1);
				-- 遍历一环内的区域
				for _, plot in ipairs(plots) do
					local districtId = plot:GetDistrictType();
					local targetPlayerId = plot:GetOwner();
					local city = Cities.GetPlotPurchaseCity(plot);
					if city and districtId ~= nil and districtId ~= -1 and Utils.IsDistrictComplete(targetPlayerId, city:GetID(), districtId) then
						-- 获取对应伟人点
						local districtType = GameInfo.Districts[Utils.GetCommonDistrictId(districtId)].DistrictType
						local isSteal = targetPlayerId ~= playerId and player:IsHuman();
						local earnExp = false;
						for row in GameInfo.DistrictCorrespondingGPP_HD() do
							if row.DistrictType == districtType then
								earnExp = true;
								local prevAmount = gppList[row.GreatPersonClassType] or 0;
								
								if isSteal then
									-- 偷取伟人点
									gppList[row.GreatPersonClassType] = prevAmount + WU_ZETIAN_SPY_GPP_OTHER;
									local targetPlayer = Players[targetPlayerId]
									if targetPlayer:IsMajor() then
										targetPlayer:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses[row.GreatPersonClassType].Index, -WU_ZETIAN_SPY_GPP_OTHER);
									end
								else
									-- 自己的区域 加伟人点
									gppList[row.GreatPersonClassType] = prevAmount + WU_ZETIAN_SPY_GPP_SELF;
								end
								print("武则天 梅花内卫 有效区域", districtType, row.GreatPersonClassType, isSteal);
							end
						end

						-- 获得经验值
						if earnExp then
							if isSteal then
								if WU_ZETIAN_SPY_EXP_OTHER > 0 then
									expAmount = expAmount + WU_ZETIAN_SPY_EXP_OTHER;
								end
							else
								if WU_ZETIAN_SPY_EXP_SELF > 0 then
									expAmount = expAmount + WU_ZETIAN_SPY_EXP_SELF;
								end
							end
						end
					end
				end
				-- 获得经验值
				if expAmount > 0 then
					unit:GetExperience():ChangeExperience(expAmount);
				end
			end
		end

		-- 增加伟人点
		for row in GameInfo.DistrictCorrespondingGPP_HD() do
			local amount = gppList[row.GreatPersonClassType]
			if amount ~= nil and amount > 0 then
				local gpInfo = GameInfo.GreatPersonClasses[row.GreatPersonClassType]
				player:GetGreatPeoplePoints():ChangePointsTotal(gpInfo.Index, amount)
				local msg = '+' .. amount .. ' ' .. Locale.Lookup(gpInfo.IconString) .. ' ' .. Locale.Lookup(gpInfo.Name);
				Utils.SendMergableNotification(playerId, HASH_NOTIFICATION_PLUM_INTERNAL_SECURITY_GPP, Locale.Lookup('LOC_UNIT_PLUM_INTERNAL_SECURITY_HD_NAME'), msg)
				print("武则天 梅花内卫 获取伟人点", Locale.Lookup(gpInfo.Name), amount);
			end
		end

	end
end
GameEvents.PlayerTurnStarted.Add(WuZetianSpyEarnGPP);

-- 梅花内卫单位操作
local PROMOTION_ASSASSINATION_HD_INFO = GameInfo.UnitPromotions['PROMOTION_ASSASSINATION_HD'];
local PROMOTION_HIJACKING_HD_INFO = GameInfo.UnitPromotions['PROMOTION_HIJACKING_HD'];
local PROMOTION_INCITE_DEFECTION_HD_INFO = GameInfo.UnitPromotions['PROMOTION_INCITE_DEFECTION_HD'];
local PROMOTION_RECRUIT_BULIANG_HD_INFO = GameInfo.UnitPromotions['PROMOTION_RECRUIT_BULIANG_HD'];
local PROMOTION_DESTRUCTION_EXPERT_HD_INFO = GameInfo.UnitPromotions['PROMOTION_DESTRUCTION_EXPERT_HD'];
local PROMOTION_DEVELOP_DOWNLINES_HD_INFO = GameInfo.UnitPromotions['PROMOTION_DEVELOP_DOWNLINES_HD'];
local PROMOTION_SECRET_ORDER_HD_INFO = GameInfo.UnitPromotions['PROMOTION_SECRET_ORDER_HD'];
local PROMOTION_KUNG_FU_MASTER_HD_INFO = GameInfo.UnitPromotions['PROMOTION_KUNG_FU_MASTER_HD'];
local PROMOTION_ROYAL_GUARD_HD_INFO = GameInfo.UnitPromotions['PROMOTION_ROYAL_GUARD_HD'];
local PROMOTION_ROYAL_ENVOY_HD_INFO = GameInfo.UnitPromotions['PROMOTION_ROYAL_ENVOY_HD'];
local PROMOTION_ROYAL_TRIBUTE_HD_INFO = GameInfo.UnitPromotions['PROMOTION_ROYAL_TRIBUTE_HD'];
local PROMOTION_SECRETS_OF_NATURE_HD_INFO = GameInfo.UnitPromotions['PROMOTION_SECRETS_OF_NATURE_HD'];

local PROMOTION_USED_TIMES_TAG = 'HD_PLUM_INTERNAL_SECURITY_PROMOTION_USED_TIMES_';

local PROMOTION_ROYAL_ENVOY_NUM = GlobalParameters.HD_PROMOTION_ROYAL_ENVOY_NUM or 0;
local PROMOTION_ROYAL_TRIBUTE_GOLD = GlobalParameters.HD_PROMOTION_ROYAL_TRIBUTE_GOLD or 0;
local PROMOTION_SECRETS_OF_NATURE_GPP = GlobalParameters.HD_PROMOTION_SECRETS_OF_NATURE_GPP or 0;

-- 刺杀行动
function HD_Promotion_Assassination(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_ASSASSINATION_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_ASSASSINATION_HD_INFO.Index, used + 1)
	print("梅花内卫 刺杀行动 已使用" .. used + 1 .. '次')

	for direction = 0, 5 do
    local adjacentPlot = Map.GetAdjacentPlot(unit:GetX(), unit:GetY(), direction);
    if adjacentPlot then
      local units = Units.GetUnitsInPlot(adjacentPlot:GetX(), adjacentPlot:GetY());
      for _, adjacentUnit in ipairs(units) do
        local unitInfo = GameInfo.Units[adjacentUnit:GetType()];
        if unitInfo then
          local formationClass = unitInfo.FormationClass;
          if (formationClass == 'FORMATION_CLASS_LAND_COMBAT' or formationClass == 'FORMATION_CLASS_NAVAL' or formationClass == 'FORMATION_CLASS_AIR')
          and adjacentUnit:GetOwner() ~= unit:GetOwner() then
						print("梅花内卫 刺杀行动", unitInfo.UnitType, adjacentUnit:GetOwner());
						Players[adjacentUnit:GetOwner()]:GetUnits():Destroy(adjacentUnit);
						Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_ASSASSINATION_HD_NAME'), adjacentPlot:GetX(), adjacentPlot:GetY());
          end
        end
      end
    end
  end

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Assassination.Add(HD_Promotion_Assassination)

-- 劫持行动
function HD_Promotion_Hijacking(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_HIJACKING_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_HIJACKING_HD_INFO.Index, used + 1)
	print("梅花内卫 劫持行动 已使用" .. used + 1 .. '次')

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	local plotOwner = plot:GetOwner();
	if plotOwner ~= playerId then plot:SetOwner(-1); end
	for direction = 0, 5 do
    local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
    if adjacentPlot then
      local units = Units.GetUnitsInPlot(adjacentPlot:GetX(), adjacentPlot:GetY());
      for _, adjacentUnit in ipairs(units) do
        local unitInfo = GameInfo.Units[adjacentUnit:GetType()];
        if unitInfo then
					local unitType = unitInfo.UnitType;
					if adjacentUnit:GetOwner() ~= unit:GetOwner() then
						for row in GameInfo.UnitCaptures() do
							if row.CapturedUnitType == unitType then
								print("梅花内卫 劫持行动", unitType, row.BecomesUnitType, adjacentUnit:GetOwner());
								Players[adjacentUnit:GetOwner()]:GetUnits():Destroy(adjacentUnit);
								UnitManager.InitUnit(playerId, row.BecomesUnitType, plot:GetX(), plot:GetY());
								Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_HIJACKING_HD_NAME'), adjacentPlot:GetX(), adjacentPlot:GetY());
							end
						end
					end
        end
      end
    end
  end
	if plotOwner ~= playerId then plot:SetOwner(plotOwner); end

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Hijacking.Add(HD_Promotion_Hijacking)

-- 策反行动
function HD_Promotion_Incite_Defection(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_INCITE_DEFECTION_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_INCITE_DEFECTION_HD_INFO.Index, used + 1)
	print("梅花内卫 策反行动 已使用" .. used + 1 .. '次')

	for direction = 0, 5 do
    local adjacentPlot = Map.GetAdjacentPlot(unit:GetX(), unit:GetY(), direction);
    if adjacentPlot then
      local units = Units.GetUnitsInPlot(adjacentPlot:GetX(), adjacentPlot:GetY());
      if units ~= nil then
        for _, adjacentUnit in ipairs(units) do
					local ownerId = adjacentUnit:GetOwner();
					local greatPerson = adjacentUnit:GetGreatPerson();
          if ownerId ~= playerId and greatPerson and Utils.IsGreatPerson(ownerId, adjacentUnit:GetID()) and greatPerson:GetClass() ~= PROPHET_INDEX then
            local classId = greatPerson:GetClass();
						local individualId = greatPerson:GetIndividualHash();
						local era = Game.GetEras():GetCurrentEra();
						Game.GetGreatPeople():GrantPerson(individualId, classId, era, 0, playerId, false);
						Players[ownerId]:GetUnits():Destroy(adjacentUnit);
						print("梅花内卫 策反行动", classId, individualId, ownerId);
						Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_INCITE_DEFECTION_HD_NAME'), adjacentPlot:GetX(), adjacentPlot:GetY());
          end
        end
      end
    end
  end

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Incite_Defection.Add(HD_Promotion_Incite_Defection)

-- 招募不良人
function HD_Promotion_Recruit_Buliang(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_RECRUIT_BULIANG_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_RECRUIT_BULIANG_HD_INFO.Index, used + 1)
	print("梅花内卫 招募不良人 已使用" .. used + 1 .. '次')

	local player = Players[playerId];
	player:AttachModifierByID('HD_RECRUIT_BULIANG_SPY_CAP');

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	if plot then
		local city = Cities.GetPlotPurchaseCity(plot);
		UnitManager.InitUnit(playerId, 'UNIT_SPY', city:GetX(), city:GetY());
		Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_RECRUIT_BULIANG_HD_NAME'), city:GetX(), city:GetY());
	end

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Recruit_Buliang.Add(HD_Promotion_Recruit_Buliang)

-- 发展下线
function HD_Promotion_Develop_Downlines(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_DEVELOP_DOWNLINES_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_DEVELOP_DOWNLINES_HD_INFO.Index, used + 1)
	print("梅花内卫 发展下线 已使用" .. used + 1 .. '次')

	local player = Players[playerId];
	UnitManager.InitUnit(playerId, 'UNIT_PLUM_INTERNAL_SECURITY_HD', unit:GetX(), unit:GetY());
	Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_DEVELOP_DOWNLINES_HD_NAME'), unit:GetX(), unit:GetY());

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Develop_Downlines.Add(HD_Promotion_Develop_Downlines)

-- 破坏专家
function HD_Promotion_Destruction_Expert(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_DESTRUCTION_EXPERT_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_DESTRUCTION_EXPERT_HD_INFO.Index, used + 1)
	print("梅花内卫 破坏专家 已使用" .. used + 1 .. '次')

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
  if plot then
		local city = Cities.GetPlotPurchaseCity(plot);
		local plunderType = "NO_PLUNDER";
		local plunderAmount = 1;
		if city then
			-- 劫掠建筑
			local buildings = Utils.GetBuildingsInPlot(unit:GetX(), unit:GetY());
			for _, buildingId in ipairs(buildings) do
				local buildingType = GameInfo.Buildings[buildingId].BuildingType;
				local buildingXp2Info = GameInfo.Buildings_XP2[buildingType];
				if (buildingXp2Info == nil or buildingXp2Info.Pillage == true)
				and not city:GetBuildings():IsPillaged(buildingId) then
					print("梅花内卫 破坏专家", buildingType)
					city:GetBuildings():SetPillaged(buildingId, true)
					plunderAmount = plunderAmount + 1;
				end
			end

			-- 劫掠区域
			local districtInfo = GameInfo.Districts[plot:GetDistrictType()];
			if districtInfo then
				plunderType = districtInfo.PlunderType;
				plunderAmount = plunderAmount * districtInfo.PlunderAmount
				local district = city:GetDistricts():GetDistrictAtLocation(unit:GetX(), unit:GetY());
				if district then
					district:SetPillaged(true);
				end
			end
		end

		-- 劫掠产出
		local player = Players[playerId];
		if plunderType == "PLUNDER_GOLD" or plunderType == "PLUNDER_HEAL" then
			player:GetTreasury():ChangeGoldBalance(plunderAmount);
			Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_DESTRUCTION_EXPERT_HD_NAME') .. "[COLOR:ResGoldLabelCS] +" .. plunderAmount .. " [ICON_Gold][ENDCOLOR]", unit:GetX(), unit:GetY());
		elseif plunderType == "PLUNDER_FAITH" then
			player:GetReligion():ChangeFaithBalance(plunderAmount);
			Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_DESTRUCTION_EXPERT_HD_NAME') .. "[COLOR:ResFaithLabelCS] +" .. plunderAmount .. " [ICON_Faith][ENDCOLOR]", unit:GetX(), unit:GetY());
		elseif plunderType == "PLUNDER_SCIENCE" then
			player:GetTechs():ChangeCurrentResearchProgress(plunderAmount)
			Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_DESTRUCTION_EXPERT_HD_NAME') .. "[COLOR:ResScienceLabelCS] +" .. plunderAmount .. " [ICON_Science][ENDCOLOR]", unit:GetX(), unit:GetY());
		elseif plunderType == "PLUNDER_CULTURE" then
			player:GetCulture():ChangeCurrentCulturalProgress(plunderAmount)
			Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_DESTRUCTION_EXPERT_HD_NAME') .. "[COLOR:ResCultureLabelCS] +" .. plunderAmount .. " [ICON_Culture][ENDCOLOR]", unit:GetX(), unit:GetY());
		end
	end

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Destruction_Expert.Add(HD_Promotion_Destruction_Expert)

-- 梅花密令
function HD_Promotion_Secret_Order(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_SECRET_ORDER_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_SECRET_ORDER_HD_INFO.Index, used + 1)
	print("梅花内卫 梅花密令 已使用" .. used + 1 .. '次')

	local player = Players[playerId];
	player:AttachModifierByID('HD_SECRET_ORDER_GOVERNOR');
	Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_SECRET_ORDER_HD_NAME'), unit:GetX(), unit:GetY());

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Secret_Order.Add(HD_Promotion_Secret_Order)

-- 大内高手
function HD_Promotion_Kung_Fu_Master(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_KUNG_FU_MASTER_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_KUNG_FU_MASTER_HD_INFO.Index, used + 1)
	print("梅花内卫 大内高手 已使用" .. used + 1 .. '次')

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
  if plot then
    local units = Units.GetUnitsInPlot(plot:GetX(), plot:GetY());
    if units ~= nil then
      for _, pUnit in ipairs(units) do
        local unitInfo = GameInfo.Units[pUnit:GetType()];
        if unitInfo then
          local formationClass = unitInfo.FormationClass;
          if (formationClass == 'FORMATION_CLASS_LAND_COMBAT' or formationClass == 'FORMATION_CLASS_NAVAL' or formationClass == 'FORMATION_CLASS_AIR')
          and pUnit:GetOwner() == unit:GetOwner() then
						local nextExp = pUnit:GetExperience():GetExperienceForNextLevel();
            local nowExp = pUnit:GetExperience():GetExperiencePoints();
						if nextExp > nowExp and nowExp >= 0 then
							pUnit:GetExperience():ChangeExperience(nextExp - nowExp);
              break;
						end
          end
        end
      end
    end
  end
	Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_KUNG_FU_MASTER_HD_NAME'), unit:GetX(), unit:GetY());

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Kung_Fu_Master.Add(HD_Promotion_Kung_Fu_Master)

-- 皇家禁军
function HD_Promotion_Royal_Guard(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_ROYAL_GUARD_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_ROYAL_GUARD_HD_INFO.Index, used + 1)
	print("梅花内卫 皇家禁军 已使用" .. used + 1 .. '次')

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
  if plot then
    local units = Units.GetUnitsInPlot(plot:GetX(), plot:GetY());
    if units ~= nil then
      for _, pUnit in ipairs(units) do
        local unitInfo = GameInfo.Units[pUnit:GetType()];
        if unitInfo then
          local formationClass = unitInfo.FormationClass;
          local militaryFormation = pUnit:GetMilitaryFormation();
          if formationClass == 'FORMATION_CLASS_LAND_COMBAT'
          and pUnit:GetOwner() == unit:GetOwner()
          and (militaryFormation ~= MilitaryFormationTypes.CORPS_FORMATION and militaryFormation ~= MilitaryFormationTypes.ARMY_FORMATION) then
            pUnit:SetMilitaryFormation(MilitaryFormationTypes.CORPS_FORMATION);
            break;
          end
        end
      end
    end
  end
	Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_ROYAL_GUARD_HD_NAME'), unit:GetX(), unit:GetY());

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Royal_Guard.Add(HD_Promotion_Royal_Guard)

-- 皇家特使
function HD_Promotion_Royal_Envoy(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_ROYAL_ENVOY_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_ROYAL_ENVOY_HD_INFO.Index, used + 1)
	print("梅花内卫 皇家特使 已使用" .. used + 1 .. '次')

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
  if PROMOTION_ROYAL_ENVOY_NUM > 0 and plot then
    local ownerId = plot:GetOwner();
    local owner = Players[ownerId];
    if owner and Utils.PlayerIsMinor(ownerId) and owner:GetInfluence():CanReceiveInfluence() then
			local player = Players[playerId];
      for i=1,PROMOTION_ROYAL_ENVOY_NUM,1 do
				player:GetInfluence():GiveFreeTokenToPlayer(ownerId);
			end
    end
  end
	Game.AddWorldViewText(playerId, Locale.Lookup('LOC_PROMOTION_ROYAL_ENVOY_HD_NAME'), unit:GetX(), unit:GetY());

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Royal_Envoy.Add(HD_Promotion_Royal_Envoy)

-- 皇家贡品
function HD_Promotion_Royal_Tribute(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_ROYAL_TRIBUTE_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_ROYAL_TRIBUTE_HD_INFO.Index, used + 1)
	print("梅花内卫 皇家贡品 已使用" .. used + 1 .. '次')

	local plot = Map.GetPlot(unit:GetX(), unit:GetY());
	local msg = Locale.Lookup('LOC_PROMOTION_ROYAL_TRIBUTE_HD_NAME');
	if plot then
		local resourceId = plot:GetResourceType();
    local resourceInfo = GameInfo.Resources[resourceId];
		if resourceInfo then
			local player = Players[playerId];
			player:AttachModifierByID('HD_GRANT_' .. resourceInfo.ResourceType);
			msg = msg .. ' [ICON_' .. resourceInfo.ResourceType .. ']';
			if PROMOTION_ROYAL_TRIBUTE_GOLD > 0 then
				player:GetTreasury():ChangeGoldBalance(PROMOTION_ROYAL_TRIBUTE_GOLD);
				msg = msg .. "[COLOR:ResGoldLabelCS] +" .. PROMOTION_ROYAL_TRIBUTE_GOLD .. " [ICON_Gold][ENDCOLOR]";
			end
		end
	end
	Game.AddWorldViewText(playerId, msg, unit:GetX(), unit:GetY());

	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Royal_Tribute.Add(HD_Promotion_Royal_Tribute)

-- 山水秘闻
function HD_Promotion_Secrets_Of_Nature(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit == nil then return; end
	local used = unit:GetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_SECRETS_OF_NATURE_HD_INFO.Index) or 0;
	unit:SetProperty(PROMOTION_USED_TIMES_TAG .. PROMOTION_SECRETS_OF_NATURE_HD_INFO.Index, used + 1)
	print("梅花内卫 山水秘闻 已使用" .. used + 1 .. '次')

	if PROMOTION_SECRETS_OF_NATURE_GPP <= 0 then return; end
	local list = Utils.GreatPeopleList;
	local player = Players[playerId];

	local plots = Map.GetNeighborPlots(unit:GetX(), unit:GetY(), 1);
  for _, plot in ipairs(plots) do
    if plot and plot:IsNaturalWonder() then
			-- 随机伟人点数量
			local amount = PROMOTION_SECRETS_OF_NATURE_GPP / 2 + Game.GetRandNum(PROMOTION_SECRETS_OF_NATURE_GPP + 1, "Random Secrets Of Nature GPP Amount for Player " .. playerId);
      -- 随机伟人类型
      local randomIndex = Game.GetRandNum(#list, "Random Secrets Of Nature GPP Type for Player " .. playerId) + 1;
      local greatPersonId = list[randomIndex].Index;
      print('梅花内卫 山水秘闻', greatPersonId, amount);
      player:GetGreatPeoplePoints():ChangePointsTotal(greatPersonId, amount);

			local msg = Locale.Lookup('LOC_PROMOTION_SECRETS_OF_NATURE_HD_NAME');
      msg = msg .. " +" .. amount .. " " .. list[randomIndex].Icon;
			Game.AddWorldViewText(playerId, msg, plot:GetX(), plot:GetY());
    end
  end
	
	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_Promotion_Secrets_Of_Nature.Add(HD_Promotion_Secrets_Of_Nature)

-- =====================================================================================================================================
-- 朱棣
-- local YONGLE_ERA_SCORE_GOLD_BONUS = GlobalParameters.HD_YONGLE_ERA_SCORE_GOLD_BONUS or 0;
-- function YongLeEraScoreChanged(playerId, score)
-- 	if score > 0 and YONGLE_ERA_SCORE_GOLD_BONUS ~= 0 and LeaderHasTrait(playerId, 'TRAIT_LEADER_YONGLE') then
-- 		local player = Players[playerId];
-- 		player:GetTreasury():ChangeGoldBalance(YONGLE_ERA_SCORE_GOLD_BONUS);
-- 	end
-- end
-- Events.PlayerEraScoreChanged.Add(YongLeEraScoreChanged)

local YONGLE_GOODY_HUT_BONUS = GlobalParameters.HD_YONGLE_GOODY_HUT_BONUS or 0;
local YONGLE_SETTLER_BONUS = GlobalParameters.HD_YONGLE_SETTLER_BONUS or 0;
local YONGLE_LAST_SCORE_TAG = 'HD_YONGLE_LAST_SCORE_TAG'
local NOTIFICATION_YONGLE_REWARD_HASH = GameInfo.Types['NOTIFICATION_YONGLE_REWARD'].Hash;
function YonglePlayerEraScoreChanged(playerId, score)
	if score == 0 then
		return;
	end
	if LeaderHasTrait(playerId, 'TRAIT_LEADER_YONGLE') then
		local player = Players[playerId];

		local last = player:GetProperty(YONGLE_LAST_SCORE_TAG) or 0;
		local diff = score - last
		if diff >= 1 then
			for i=1,diff,1 do
				-- 村子
				if YONGLE_GOODY_HUT_BONUS == 1 then
					if i == diff then
						print("YonglePlayerEraScoreChanged 循环最后一次")
						GameEvents.GetRandomGoodyHutReward.Call(playerId, "LOC_TRAIT_LEADER_YONGLE_NAME", NOTIFICATION_YONGLE_REWARD_HASH)
					else
						print("YonglePlayerEraScoreChanged 循环中")
						GameEvents.GetRandomGoodyHutReward.Call(playerId, "LOC_TRAIT_LEADER_YONGLE_NAME", NOTIFICATION_YONGLE_REWARD_HASH, {ContinuousTriggered = true})
					end
					print("YonglePlayerEraScoreChanged 村庄奖励")
				end
			end
		elseif diff == -4 then
			if YONGLE_SETTLER_BONUS == 1 then
				player:AttachModifierByID('HD_YONGLE_GRANT_SETTLER')
				print("YonglePlayerEraScoreChanged 开拓者奖励")
			end
		end
		
		player:SetProperty(YONGLE_LAST_SCORE_TAG, score)
	end
end
Events.PlayerEraScoreChanged.Add(YonglePlayerEraScoreChanged)

-- 招募伟人送科文进度
local YONGLE_GP_NUM_TAG = 'HD_YONGLE_GP_NUM_TAG'
local TECH_FAKE_TECH = GameInfo.Technologies['TECH_FAKE_TECH'];
local YONGLE_GP_NUM = GlobalParameters.HD_YONGLE_GP_NUM or 0;
local YONGLE_TECH_BONUS = GlobalParameters.HD_YONGLE_TECH_BONUS or 0;
function ZhuDiUnitGreatPersonCreated(playerId, unitId, greatPersonClassId, greatPersonIndividualId)
  if YONGLE_GP_NUM == 0 then
    return;
  end
	local player = Players[playerId];
	if not Utils.LeaderHasTrait(playerId, 'TRAIT_LEADER_YONGLE') then
		return;
	end
	
  local amount = player:GetProperty(YONGLE_GP_NUM_TAG) or 0;
  amount = amount + 1;
  if amount == YONGLE_GP_NUM then
		local playerTech = player:GetTechs();
		local currentTech = playerTech:GetResearchingTech();
		if currentTech ~= -1 and (TECH_FAKE_TECH == nil or currentTech ~= TECH_FAKE_TECH.Index) then
			local techCost = playerTech:GetResearchCost(currentTech)
			local techProgress = playerTech:GetResearchProgress(currentTech)
			local bonusAmount = techCost * YONGLE_TECH_BONUS / 100
			bonusAmount = math.min(bonusAmount, techCost - techProgress)
			playerTech:ChangeCurrentResearchProgress(bonusAmount)
			print("ZhuDiUnitGreatPersonCreated 科技进度奖励", currentTech, bonusAmount)
		end
    amount = 0;
  end
  player:SetProperty(YONGLE_GP_NUM_TAG, amount);
end
Events.UnitGreatPersonCreated.Add(ZhuDiUnitGreatPersonCreated);

-- =====================================================================================================================================
-- 苏美尔
-- =====================================================================================================================================
local HASH_NOTIFICATION_SUMERIA_FREE_TECH = DB.MakeHash('NOTIFICATION_SUMERIA_FREE_TECH');
local HASH_NOTIFICATION_SUMERIA_FREE_CIVIC = DB.MakeHash('NOTIFICATION_SUMERIA_FREE_CIVIC');
local HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST = DB.MakeHash('NOTIFICATION_SUMERIA_SPECIAL_QUEST');
local HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST_REWORD = DB.MakeHash('NOTIFICATION_SUMERIA_SPECIAL_QUEST_REWORD');
-- UA
local Sumeria_Suzerain_Tag = 'HD_Sumeria_Suzerain_'
function SumeriaSuzerain(citystateId)
	local citystate = Players[citystateId]
	local playerId = citystate:GetInfluence():GetSuzerain()

	if playerId ~= nil and playerId ~= -1 and CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_FIRST_CIVILIZATION') then
		local player = Players[playerId]
		local citystateConfig = PlayerConfigurations[citystateId]
		local citystateLeader = citystateConfig:GetLeaderTypeName()
		local citystateType = GameInfo.Leaders[citystateLeader].InheritFrom
		if player:GetProperty(Sumeria_Suzerain_Tag .. citystateType) ~= 1 then
			player:SetProperty(Sumeria_Suzerain_Tag .. citystateType, 1)
			print('SumeriaSuzerain', citystateType, playerId)

			-- 首次宗主该类型
			local playerTechs = player:GetTechs()
			local playerCulture = player:GetCulture()
			local techCivicList = {}

			-- 查找可解锁的科文
			for row in GameInfo.Sumeria_CityState_Relevant_Tech_Civic_HD() do
				if 'LEADER_MINOR_CIV_' .. row.CityStateType == citystateType then
					if row.TechnologyType ~= nil then
						local techId = GameInfo.Technologies[row.TechnologyType].Index
						if not playerTechs:HasTech(techId) then
							print('SumeriaSuzerain', Locale.Lookup(GameInfo.Technologies[techId].Name))
							table.insert(techCivicList, {
								techId = techId
							})
						end
					elseif row.CivicType ~= nil then
						local civicId = GameInfo.Civics[row.CivicType].Index
						print('SumeriaSuzerain', Locale.Lookup(GameInfo.Civics[civicId].Name))
						if not playerCulture:HasCivic(civicId) then
							table.insert(techCivicList, {
								civicId = civicId
							})
						end
					end
				end
			end

			-- 随机选取科文解锁
			if #techCivicList > 0 then
				local randomIndex = Game.GetRandNum(#techCivicList, "Sumeria Unlock Random Tech or Civic for Player " .. playerId) + 1
				local techCivic = techCivicList[randomIndex]
				if techCivic.techId ~= nil then
					playerTechs:SetResearchProgress(techCivic.techId, playerTechs:GetResearchCost(techCivic.techId));
					local msg = Locale.Lookup("LOC_CITY_STATES_TYPE_" .. string.sub(citystateType, 18)) .. Locale.Lookup('LOC_CITY_STATES_CITY_STATE') .. ": " .. Locale.Lookup(GameInfo.Technologies[techCivic.techId].Name)
					Utils.SendMergableNotification(playerId, HASH_NOTIFICATION_SUMERIA_FREE_TECH, Locale.Lookup('LOC_TRAIT_CIVILIZATION_FIRST_CIVILIZATION_NAME'), msg)
				elseif techCivic.civicId ~= nil then
					playerCulture:SetCulturalProgress(techCivic.civicId, playerCulture:GetCultureCost(techCivic.civicId));
					local msg = Locale.Lookup("LOC_CITY_STATES_TYPE_" .. string.sub(citystateType, 18)) .. Locale.Lookup('LOC_CITY_STATES_CITY_STATE') .. ": " .. Locale.Lookup(GameInfo.Civics[techCivic.civicId].Name)
					Utils.SendMergableNotification(playerId, HASH_NOTIFICATION_SUMERIA_FREE_CIVIC, Locale.Lookup('LOC_TRAIT_CIVILIZATION_FIRST_CIVILIZATION_NAME'), msg)
				end
			else
				print('SumeriaSuzerain 没有可用的远古古典科文')
			end
		end
	end
end
Events.InfluenceGiven.Add(SumeriaSuzerain)

local Sumeria_Special_Quest_Tag = 'HD_Sumeria_Special_Quest';
function SumeriaFinishQuest(citystateId, playerId)
	if playerId ~= nil and playerId ~= -1 and CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_FIRST_CIVILIZATION') then
		local player = Players[playerId]
		local specialQuestList = player:GetProperty(Sumeria_Special_Quest_Tag) or {};

		-- 判断是否已有任务
		local hasQuest = (Utils.GetCitystateQuestId(playerId, citystateId) ~= -1) or (specialQuestList[citystateId] ~= nil)
		if not hasQuest then
			-- 判断与城邦处于和平状态
			if not player:GetDiplomacy():IsAtWarWith(citystateId) then
				-- 选取随机特殊任务
				local randomQuestList = {}
				for questInfo in GameInfo.Sumeria_CityState_Special_Quests_HD() do
					-- 前置条件判断
					if Utils.IsRowValid(playerId, questInfo) then
						-- 额外判断
						local isValid = true;

						if isValid then
							print("苏美尔 可用特殊任务", questInfo.SpecialQuestType)
							table.insert(randomQuestList, {
								SpecialQuestType = questInfo.SpecialQuestType,
								Description = questInfo.Description,
								HasSubType = questInfo.HasSubType
							})
						end
					end
				end
				if #randomQuestList == 0 then
					print("苏美尔 没有可用的特殊任务")
					return;
				end
				local randomQuestIndex = Game.GetRandNum(#randomQuestList, "Sumeria Random Special Quest for Player " .. playerId) + 1
				local selectedQuest = randomQuestList[randomQuestIndex]
				local specialQuest = {
					SpecialQuestType = selectedQuest.SpecialQuestType,
					Description = selectedQuest.Description
				}
				print("苏美尔 选定特殊任务", specialQuest.SpecialQuestType)

				-- 查找子任务
				if selectedQuest.HasSubType then
					local randomSubQuestList = {}
					for subQuestInfo in GameInfo.Sumeria_CityState_Special_SubQuests_HD() do
						-- 前置条件判断
						if subQuestInfo.SpecialQuestType == selectedQuest.SpecialQuestType and Utils.IsRowValid(playerId, subQuestInfo) then
							-- 额外判断
							local isValid = true;
							if subQuestInfo.SpecialQuestType == "HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST" then
								-- 判断尤里卡是否已经触发
								if player:GetTechs():HasBoostBeenTriggered(GameInfo.Technologies[subQuestInfo.ObjectType].Index) then
									isValid = false;
								end
							elseif subQuestInfo.SpecialQuestType == "HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST" then
								-- 判断鼓舞是否已经触发
								if player:GetCulture():HasBoostBeenTriggered(GameInfo.Civics[subQuestInfo.ObjectType].Index) then
									isValid = false;
								end
							end

							if isValid then
								print("苏美尔 可用特殊子任务", subQuestInfo.SpecialSubQuestType)
								table.insert(randomSubQuestList, {
									SpecialSubQuestType = subQuestInfo.SpecialSubQuestType,
									ObjectType = subQuestInfo.ObjectType,
									SubDescription = subQuestInfo.Description
								})
							end
						end
					end
					if #randomSubQuestList > 0 then
						local randomSubQuestIndex = Game.GetRandNum(#randomSubQuestList, "Sumeria Random Special SubQuest for Player " .. playerId) + 1
						local selectedSubQuest = randomSubQuestList[randomSubQuestIndex]
						specialQuest.SpecialSubQuestType = selectedSubQuest.SpecialSubQuestType
						specialQuest.ObjectType = selectedSubQuest.ObjectType
						specialQuest.SubDescription = selectedSubQuest.SubDescription
						print("苏美尔 选定特殊子任务", specialQuest.SpecialSubQuestType)
					else
						print("苏美尔 没有可用的特殊子任务 尝试重新选取随机特殊任务")
						SumeriaFinishQuest(citystateId, playerId);
						return;
					end
				end

				-- 选取随机特殊奖励
				specialQuest.SpecialReward = SumeriaGetRandomSpecialReward(player, citystateId)

				-- 记录 Property
				specialQuestList[citystateId] = specialQuest
				player:SetProperty(Sumeria_Special_Quest_Tag, specialQuestList)

				-- 发送任务通知
				local citystateConfig = PlayerConfigurations[citystateId]
				local citystateLeaderName = citystateConfig:GetLeaderName()
				local msg = Locale.Lookup(citystateLeaderName) .. " "
				if specialQuest.SubDescription ~= nil then
					local description = Locale.Lookup(specialQuest.Description, specialQuest.SubDescription)
					msg = msg .. Locale.Lookup("LOC_HD_SPECIAL_QUEST_DESCRIPTION", description)
				else
					msg = msg .. Locale.Lookup("LOC_HD_SPECIAL_QUEST_DESCRIPTION", specialQuest.Description)
				end
				Utils.SendMergableNotification(playerId, HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST, Locale.Lookup('LOC_NOTIFICATION_CITYSTATE_QUEST_GIVEN_MESSAGE'), msg, "")
			end
		else
			-- 过时代清除特殊任务
			specialQuestList[citystateId] = nil
			player:SetProperty(Sumeria_Special_Quest_Tag, specialQuestList)
			print('苏美尔 已有普通任务 清除特殊任务', citystateId)
		end
	end
end
Events.QuestChanged.Add(SumeriaFinishQuest)

-- 与城邦开战清除特殊任务
function SumeriaWarWithCitystate(playerId1, playerId2)
	if Utils.PlayerIsMinor(playerId1) then
		local player = Players[playerId2]
		local specialQuestList = player:GetProperty(Sumeria_Special_Quest_Tag);
		if specialQuestList then
			specialQuestList[playerId1] = nil;
			player:SetProperty(Sumeria_Special_Quest_Tag, specialQuestList)
		end
	elseif Utils.PlayerIsMinor(playerId2) then
		local player = Players[playerId1]
		local specialQuestList = player:GetProperty(Sumeria_Special_Quest_Tag);
		if specialQuestList then
			specialQuestList[playerId2] = nil;
			player:SetProperty(Sumeria_Special_Quest_Tag, specialQuestList)
		end
	end
end
Events.DiplomacyDeclareWar.Add(SumeriaWarWithCitystate)

-- 选取随机奖励
function SumeriaGetRandomSpecialReward(player, citystateId)
	-- -- 有概率没有特殊奖励
	-- local gameTurn = Game.GetCurrentGameTurn() + 50
	-- local randomTurn = Game.GetRandNum(100, "Sumeria Random Turn for Player " .. player:GetID()) + 1
	-- if gameTurn < randomTurn then
	-- 	print("苏美尔 无特殊奖励")
	-- 	return {Description = 'LOC_HD_SPECIAL_QUEST_REWARD_NONE_DESCRIPTION'};
	-- end

	local citystateConfig = PlayerConfigurations[citystateId]
	local citystateLeader = citystateConfig:GetLeaderTypeName()
	local citystateType = GameInfo.Leaders[citystateLeader].InheritFrom

	local randomRewardList = {}
	for rewardInfo in GameInfo.Sumeria_CityState_Special_Quest_Rewards_HD() do
		-- 前置条件判断
		if Utils.IsRowValid(player:GetID(), rewardInfo) and (not rewardInfo.PrereqCityStateType or 'LEADER_MINOR_CIV_' .. rewardInfo.PrereqCityStateType == citystateType) then
			-- 额外判断
			local isValid = true;
			-- 判断首都是否可以生成海军单位
			if rewardInfo.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_GRANT_SEA_UNIT' then
				local capitalCanHaveSeaUnits = player:GetProperty('HD_CAPITAL_CAN_HAVE_SEA_UNITS') or 0
				if capitalCanHaveSeaUnits == 0 then
					isValid = false
				end
			end

			if isValid then
				print("苏美尔 可用特殊奖励", rewardInfo.SpecialRewardType)
				table.insert(randomRewardList, {
					SpecialRewardType = rewardInfo.SpecialRewardType,
					Description = rewardInfo.Description,
					ModifierId = rewardInfo.ModifierId,
					HasSubType = rewardInfo.HasSubType
				})
			end
		end
	end
	if #randomRewardList == 0 then
		print("苏美尔 没有可用的特殊奖励")
		return {Description = 'LOC_HD_SPECIAL_QUEST_REWARD_NONE_DESCRIPTION'};
	end

	local randomRewardIndex = Game.GetRandNum(#randomRewardList, "Sumeria Random Special Reward for Player " .. player:GetID()) + 1
	local selectedReward = randomRewardList[randomRewardIndex]
	local specialReward = {
		SpecialRewardType = selectedReward.SpecialRewardType,
		Description = selectedReward.Description,
		ModifierId = selectedReward.ModifierId
	}
	print("苏美尔 选定特殊奖励", specialReward.SpecialRewardType)

	-- 查找子奖励
	if selectedReward.HasSubType then
		local randomSubRewardList = {}
		for subRewardInfo in GameInfo.Sumeria_CityState_Special_Quest_SubRewards_HD() do
			-- 前置条件判断
			if subRewardInfo.SpecialRewardType == specialReward.SpecialRewardType
			and Utils.IsRowValid(player:GetID(), subRewardInfo)
			and (not subRewardInfo.PrereqCityStateType or 'LEADER_MINOR_CIV_' .. subRewardInfo.PrereqCityStateType == citystateType) then
				-- 额外判断
				local isValid = true;
				if subRewardInfo.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_LUXURY_RESOURCE' then
					-- 送奢侈需要判断城邦是否拥有
					local resourceId = GameInfo.Resources[subRewardInfo.ObjectType].Index
					local citystate = Players[citystateId]
					if not citystate:GetResources():HasResource(resourceId) then
						isValid = false;
					end
				end

				if isValid then
					print("苏美尔 可用特殊子奖励", subRewardInfo.SpecialSubRewardType)
					local subReward = {
						SpecialSubRewardType = subRewardInfo.SpecialSubRewardType,
						ObjectType = subRewardInfo.ObjectType,
						SubDescription = subRewardInfo.Description,
						SubModifierId = subRewardInfo.ModifierId
					}

					-- 子奖励数据特殊处理
					if subRewardInfo.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT'
					or subRewardInfo.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_GRANT_SEA_UNIT' then
						-- 手动选取具体单位，有概率送UU
						local playerEraId = GameInfo.Eras[player:GetEras():GetEra()].ChronologyIndex
						local isUU = Game.GetRandNum(10, "Sumeria Random Special SubReword UU for Player " .. player:GetID()) < 5
						local unitList = {}
						print("苏美尔 特殊子奖励 选择可用单位", subRewardInfo.ObjectType, isUU)
						-- 选择符合条件的单位
						for unitInfo in GameInfo.Units() do
							if unitInfo.PromotionClass == subRewardInfo.ObjectType then
								local unitEraId = 1;
								if unitInfo.PrereqTech ~= nil then
									unitEraId = GameInfo.Eras[GameInfo.Technologies[unitInfo.PrereqTech].EraType].ChronologyIndex
								end
								if unitInfo.PrereqCivic ~= nil then
									unitEraId = GameInfo.Eras[GameInfo.Civics[unitInfo.PrereqCivic].EraType].ChronologyIndex
								end
								if unitEraId >= playerEraId - 1 and unitEraId <= playerEraId + 1 then
									if not isUU and (unitInfo.TraitType == nil or unitInfo.TraitType == 'TRAIT_BARBARIAN_BUT_SHOWS_UP_IN_PEDIA') then
										table.insert(unitList, {
											UnitType = unitInfo.UnitType,
											UnitName = unitInfo.Name
										})
										print("苏美尔 特殊子奖励 可用单位", Locale.Lookup(unitInfo.Name))
									elseif isUU and unitInfo.TraitType ~= nil then
										table.insert(unitList, {
											UnitType = unitInfo.UnitType,
											UnitName = unitInfo.Name
										})
										print("苏美尔 特殊子奖励 可用单位", Locale.Lookup(unitInfo.Name))
									end
								end
							end
						end

						if #unitList == 0 then
							print("苏美尔 特殊子奖励 无可用单位 替代为建造者")
							subReward.ObjectType = 'UNIT_BUILDER'
							subReward.SubDescription = 'LOC_UNIT_BUILDER_NAME'
						else
							local randomUnitIndex = Game.GetRandNum(#unitList, "Sumeria Random Special SubReward Unit for Player " .. player:GetID()) + 1
							local selectedUnit = unitList[randomUnitIndex]
							subReward.ObjectType = selectedUnit.UnitType
							subReward.SubDescription = selectedUnit.UnitName
						end
					elseif subRewardInfo.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_STRATEGIC_RESOURCE'
					or subRewardInfo.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_LUXURY_RESOURCE' then
						-- 添加资源图标
						subReward.SubDescription = '[ICON_' .. subReward.ObjectType .. '] ' .. Locale.Lookup(subReward.SubDescription)
					elseif subRewardInfo.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_GPP' then
						-- 添加伟人图标
						subReward.SubDescription = GameInfo.GreatPersonClasses[subReward.ObjectType].IconString .. ' ' .. Locale.Lookup(subReward.SubDescription)
						-- 计算伟人点数
						subReward.Amount = math.max(20, Game.GetCurrentGameTurn())
					end

					table.insert(randomSubRewardList, subReward)
				end
			end
		end
		if #randomSubRewardList > 0 then
			local randomSubRewardIndex = Game.GetRandNum(#randomSubRewardList, "Sumeria Random Special SubReward for Player " .. player:GetID()) + 1
			local selectedSubReward = randomSubRewardList[randomSubRewardIndex]
			specialReward.SpecialSubRewardType = selectedSubReward.SpecialSubRewardType
			specialReward.ObjectType = selectedSubReward.ObjectType
			specialReward.SubDescription = selectedSubReward.SubDescription
			specialReward.ModifierId = selectedSubReward.SubModifierId
			specialReward.Amount = selectedSubReward.Amount
			print("苏美尔 选定特殊子奖励", specialReward.SpecialSubRewardType)
		else
			print("苏美尔 没有可用的特殊子奖励")
			return {Description = 'LOC_HD_SPECIAL_QUEST_REWARD_NONE_DESCRIPTION'};
		end
	end
	
	
	return specialReward;
end

-- 判断任务完成
local Ziggurat_SpecialQuest_Tag = "HD_Ziggurat_SpecialQuest_"
function SumeriaCompleteSpecialQuest(playerId, specialQuestType, specialSubQuestType, objectType)
	if playerId == nil or playerId == -1 or not CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_FIRST_CIVILIZATION') then
		return;
	end

	print("苏美尔 开始检测特殊任务", specialQuestType, specialSubQuestType, objectType)
	local player = Players[playerId]
	local specialQuestList = player:GetProperty(Sumeria_Special_Quest_Tag) or {};
	local citystateIdList = {}
	for _, citystateId in ipairs(PlayerManager.GetAliveMinorIDs()) do
		local specialQuest = specialQuestList[citystateId]
		if specialQuest ~= nil
		and specialQuest.SpecialQuestType == specialQuestType
		and (specialSubQuestType == nil or specialQuest.SpecialSubQuestType == specialSubQuestType)
		and (objectType == nil or specialQuest.ObjectType == objectType) then
			-- 派遣使者
			player:GetInfluence():GiveFreeTokenToPlayer(citystateId);

			local citystateConfig = PlayerConfigurations[citystateId]
			local citystateLeaderName = citystateConfig:GetLeaderName()
			local rewardDescription = 'LOC_HD_SPECIAL_QUEST_REWARD_ENVOY_DESCRIPTION'
			-- 获得额外奖励
			if specialQuest.SpecialReward.SpecialRewardType ~= nil then
				SumeriaApplySpecialReward(player, specialQuest.SpecialReward)
				-- 发起额外奖励通知
				rewardDescription = Utils.GetSumeriaSpecialRewardDescription(specialQuest.SpecialReward)
			end

			-- 发起奖励通知
			local msg = Locale.Lookup(
				'LOC_NOTIFICATION_CITYSTATE_QUEST_COMPLETED_SUMMARY',
				citystateLeaderName,
				rewardDescription
			)
			Utils.SendMergableNotification(playerId, HASH_NOTIFICATION_SUMERIA_SPECIAL_QUEST_REWORD, Locale.Lookup('LOC_NOTIFICATION_CITYSTATE_QUEST_COMPLETED_MESSAGE'), msg, "")
			print("苏美尔 完成特殊任务", Locale.Lookup(citystateLeaderName), Locale.Lookup(rewardDescription))

			-- 金字形神塔加产
			-- local gameEra = Game.GetEras():GetCurrentEra();
			local citystateConfig = PlayerConfigurations[citystateId]
			local citystateLeader = citystateConfig:GetLeaderTypeName()
			local citystateType = GameInfo.Leaders[citystateLeader].InheritFrom
			if player:GetProperty(Ziggurat_SpecialQuest_Tag ..  '_' .. citystateType) ~= 1 then
				player:SetProperty(Ziggurat_SpecialQuest_Tag ..  '_' .. citystateType, 1)
				player:AttachModifierByID('HD_ZIGGURAT_' .. citystateType .. '_BONUS');
				print("苏美尔 金字形神塔", 'HD_ZIGGURAT_' .. citystateType .. '_BONUS')
			end

			-- 记录城邦Id，用于触发回调，刷新特殊任务
			table.insert(citystateIdList, citystateId)
		elseif specialQuest ~= nil
		and ((specialQuestType == 'HD_SPECIAL_QUEST_FINISH_TECH' and specialQuest.SpecialQuestType == 'HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST' and objectType == specialQuest.ObjectType)
		or (specialQuestType == 'HD_SPECIAL_QUEST_FINISH_CIVIC' and specialQuest.SpecialQuestType == 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST' and objectType == specialQuest.ObjectType)) then
			-- 若完成科文，则淘汰相同科文尤里卡鼓舞的任务
			print("苏美尔 淘汰特殊任务", specialQuest.SpecialQuestType, citystateId)
			table.insert(citystateIdList, citystateId)
		end
	end

	-- 删除已完成的任务
	for _, citystateId in ipairs(citystateIdList) do
		specialQuestList[citystateId] = nil
	end
	player:SetProperty(Sumeria_Special_Quest_Tag, specialQuestList)

	-- 触发回调，刷新特殊任务
	for _, citystateId in ipairs(citystateIdList) do
		SumeriaFinishQuest(citystateId, playerId)
	end
end

-- 摧毁蛮族哨站
function SumeriaClearBarbarianCamp(x, y, playerId)
	SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_CLEAR_BARBARIAN_CAMP')
end
GameEvents.HDClearBarbarianCamp.Add(SumeriaClearBarbarianCamp)

-- 训练单位
function SumeriaTrainUnit(playerId, unitId)
	local unitInfo = GameInfo.Units[unitId]
	local promotionClass = unitInfo.PromotionClass
	if promotionClass ~= nil
	and promotionClass ~= 'LOC_PROMOTION_CLASS_APOSTLE_NAME'
	and promotionClass ~= 'LOC_PROMOTION_CLASS_INQUISITOR_NAME'
	and promotionClass ~= 'LOC_PROMOTION_CLASS_MONK_NAME'
	and promotionClass ~= 'LOC_PROMOTION_CLASS_NIHANG_NAME' then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_TRAIN_UNIT', 'HD_SPECIAL_SUBQUEST_TRAIN_' .. promotionClass, promotionClass)
	end
end
function SumeriaProduceUnit(playerId, cityId, type, objectId, cancelled)
	if type == 0 then
		SumeriaTrainUnit(playerId, objectId)
	end
end
Events.CityProductionCompleted.Add(SumeriaProduceUnit)
function SumeriaPurchaseUnit(playerId, cityId, x, y, type, objectId)
	if type == EventSubTypes.UNIT then
		SumeriaTrainUnit(playerId, objectId)
	end
end
Events.CityMadePurchase.Add(SumeriaPurchaseUnit)

-- 建造区域
function SumeriaBuildDistrict(playerId, districtId, x, y)
	local districtInfo = GameInfo.Districts[Utils.GetCommonDistrictId(districtId)]
	if districtInfo ~= nil
	and districtInfo.DistrictType ~= 'DISTRICT_CITY_CENTER'
	and districtInfo.DistrictType ~= 'DISTRICT_WONDER'
	and districtInfo.MaxPerPlayer == -1 then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_BUILD_DISTRICT', 'HD_SPECIAL_SUBQUEST_BUILD_' .. districtInfo.DistrictType, districtInfo.DistrictType)
	end
end
GameEvents.OnDistrictConstructed.Add(SumeriaBuildDistrict)

-- 建造奇观
function SumeriaBuildWonder(x, y, buildingId, playerId, cityId)
	local buildingInfo = GameInfo.Buildings[buildingId]
	if buildingInfo ~= nil and buildingInfo.IsWonder then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_BUILD_WONDER')
	end
end
Events.WonderCompleted.Add(SumeriaBuildWonder);

-- 招募伟人
function SumeriaGreatPersonCreated(playerId, unitId, greatPersonClassId, greatPersonIndividualId)
	local greatPersonClassInfo = GameInfo.GreatPersonClasses[greatPersonClassId]
	if greatPersonClassInfo ~= nil
	and greatPersonClassInfo.AvailableInTimeline
	and greatPersonClassId ~= PROPHET_INDEX then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_RECRUIT_GREAT_PERSON_CLASS', 'HD_SPECIAL_SUBQUEST_RECRUIT_' .. greatPersonClassInfo.GreatPersonClassType, greatPersonClassInfo.GreatPersonClassType)
	end
end
Events.UnitGreatPersonCreated.Add(SumeriaGreatPersonCreated)

-- 建造改良
function SumeriaBuildImprovement(x, y, improvementId, playerId, resourceId, isPillaged, isWorked)
	local improvementInfo = GameInfo.Improvements[improvementId]
	if improvementInfo ~= nil then
		local improvementType = improvementInfo.ImprovementType
		if improvementType == 'IMPROVEMENT_AIRSTRIP'
		or improvementType == 'IMPROVEMENT_BEACH_RESORT'
		or improvementType == 'IMPROVEMENT_CORPORATION'
		or improvementType == 'IMPROVEMENT_FORT'
		or improvementType == 'IMPROVEMENT_GEOTHERMAL_PLANT'
		or improvementType == 'IMPROVEMENT_INDUSTRY'
		or improvementType == 'IMPROVEMENT_LEU_CONTAINER_PORT'
		or improvementType == 'IMPROVEMENT_LEU_STATION'
		or improvementType == 'IMPROVEMENT_LEU_WAREHOUSE'
		or improvementType == 'IMPROVEMENT_MISSILE_SILO'
		or improvementType == 'IMPROVEMENT_MOUNTAIN_TUNNEL'
		or improvementType == 'IMPROVEMENT_OFFSHORE_WIND_FARM'
		or improvementType == 'IMPROVEMENT_SAILOR_WATCHTOWER'
		or improvementType == 'IMPROVEMENT_SEASTEAD'
		or improvementType == 'IMPROVEMENT_SKI_RESORT'
		or improvementType == 'IMPROVEMENT_SOLAR_FARM'
		or improvementType == 'IMPROVEMENT_WIND_FARM' then
			-- 建造特殊改良
			SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_BUILD_SPECIAL_IMPROVEMENT', 'HD_SPECIAL_SUBQUEST_BUILD_' .. improvementType, improvementType)
		elseif improvementType == 'IMPROVEMENT_CAMP'
		or improvementType == 'IMPROVEMENT_FARM'
		or improvementType == 'IMPROVEMENT_FISHING_BOATS'
		or improvementType == 'IMPROVEMENT_LUMBER_MILL'
		or improvementType == 'IMPROVEMENT_MINE'
		or improvementType == 'IMPROVEMENT_PASTURE'
		or improvementType == 'IMPROVEMENT_PLANTATION'
		or improvementType == 'IMPROVEMENT_QUARRY' then
			-- 改良资源
			if resourceId ~= nil and resourceId >= 0 then
				local resourceHash = GameInfo.Resources[resourceId].Hash;
				if Utils.IsResourceVisible(playerId, resourceHash) then
					SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_IMPROVE_RESOURCE', 'HD_SPECIAL_SUBQUEST_IMPROVE_' .. improvementType .. '_RESOURCE', improvementType)
				end
			end
		end
	end
end

-- 建立贸易路线
function SumeriaTradeRouteActivityChanged(playerId, originPlayerId, originCityId, targetPlayerId, targetCityId)
	if originPlayerId ~= targetPlayerId then
		-- 国际贸易
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_ESTABLISH_INTERNATIONAL_TRADE_ROUTE')
	else
		-- 国内贸易
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_ESTABLISH_DOMESTIC_TRADE_ROUTE')
	end
end
Events.TradeRouteActivityChanged.Add(SumeriaTradeRouteActivityChanged)

-- 城市改变信仰
local Sumeria_CityReligionFollowersChanged_Tag = 'HD_Sumeria_CityReligionFollowersChanged_'
function SumeriaCityReligionFollowersChanged(ownerId, cityId, eVisibility)
	local city = CityManager.GetCity(ownerId, cityId);
	if not city then return; end
	local cityReligion = city:GetReligion():GetMajorityReligion();

	for _, playerId in ipairs(PlayerManager.GetAliveMajorIDs()) do
		local player = Players[playerId]
		local playerReligion = player:GetReligion():GetReligionTypeCreated();
		if cityReligion ~= -1
		and michelReligion ~= -1
		and cityReligion == playerReligion
		and city:GetProperty(Sumeria_CityReligionFollowersChanged_Tag .. cityReligion) ~= 1 then
			city:SetProperty(Sumeria_CityReligionFollowersChanged_Tag .. cityReligion, 1)
			SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_CONVERT_CITY_RELIGION')
		end
	end
	
end
Events.CityReligionFollowersChanged.Add(SumeriaCityReligionFollowersChanged);

-- 建立城市
function SumeriaCreateCity(playerId, cityId, x, y)
	local player = Players[playerId]
	local capital = player:GetCities():GetCapitalCity()
	if capital then
		local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
		local capitalContinent = capitalPlot:GetContinentType()

		local cityPlot = Map.GetPlot(x, y);
		local cityContinent = cityPlot:GetContinentType()

		if capitalContinent ~= nil and cityContinent ~= nil then
			if capitalContinent ~= cityContinent then
				-- 异大陆
				SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_CREATE_FOREIGN_CONTINENT_CITY')
			else
				-- 同大陆
				SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_CREATE_SAME_CONTINENT_CITY')
			end
		end
	end
end

-- 更换政体
function SumeriaGovernmentChanged(playerId, governmentId)
	local governmentInfo = GameInfo.Governments[governmentId]
	if governmentInfo ~= nil then
		local tierType = governmentInfo.Tier
		if tierType ~= nil then
			local tier = GameInfo.GovernmentTiers[tierType].Sorting
			SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_CHANGE_ADVANCED_GOVERNMRNT', 'HD_SPECIAL_SUBQUEST_CHANGE_TIER_' .. tier .. '_GOVERNMRNT', tostring(tier))
		end
	end
end
Events.GovernmentChanged.Add(SumeriaGovernmentChanged)

-- 成立军团/军队/舰队/无敌舰队
function SumeriaFormCorps(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId)
	local domian = GameInfo.Units[unit:GetType()].Domain
	local formationClass = GameInfo.Units[unit:GetType()].FormationClass

	if domian == 'DOMAIN_SEA' and formationClass == 'FORMATION_CLASS_NAVAL' then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_FORM_FLEET')
	elseif domian == 'DOMAIN_LAND' and formationClass == 'FORMATION_CLASS_LAND_COMBAT' then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_FORM_CORPS')
	end
end
Events.UnitFormCorps.Add(SumeriaFormCorps)

function SumeriaFormArmy(playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId)
	local domian = GameInfo.Units[unit:GetType()].Domain
	local formationClass = GameInfo.Units[unit:GetType()].FormationClass

	if domian == 'DOMAIN_SEA' and formationClass == 'FORMATION_CLASS_NAVAL' then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_FORM_ARMADA')
	elseif domian == 'DOMAIN_LAND' and formationClass == 'FORMATION_CLASS_LAND_COMBAT' then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_FORM_ARMY')
	end
end
Events.UnitFormArmy.Add(SumeriaFormArmy)

-- 生成巨作
function SumeriaGreatWorkCreated(playerId, unitId, x, y, buildingId, greatWorkIndex)
	local city = CityManager.GetCityAt(x, y);
	local greatWorkId = Utils.GetGreatWorkTypeFromIndex(playerId, city:GetID(), greatWorkIndex)
	local greatWorkInfo = GameInfo.GreatWorks[greatWorkId];
	if greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_ARTIFACT' then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_EXTRACT_ARTIFACT')
	elseif greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_PRODUCT' then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_CREATE_PRODUCT')
	end
end
Events.GreatWorkCreated.Add(SumeriaGreatWorkCreated);

-- 建造国家公园
function SumeriaNationalParkAdded(plyerId, x, y)
	SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_BUILD_NATIONAL_PARK')
end

-- 尤里卡
function SumeriaTechBoost(playerId, techId)
	local techInfo = GameInfo.Technologies[techId]
	if techInfo ~= nil then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_TRIGGER_TECH_BOOST', 'HD_SPECIAL_SUBQUEST_TRIGGER_' .. techInfo.TechnologyType .. '_BOOST', techInfo.TechnologyType)
	end
end
Events.TechBoostTriggered.Add(SumeriaTechBoost)

-- 鼓舞
function SumeriaCivicBoost(playerId, civicId)
	local civicInfo = GameInfo.Civics[civicId]
	if civicInfo ~= nil then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_TRIGGER_CIVIC_BOOST', 'HD_SPECIAL_SUBQUEST_TRIGGER_' .. civicInfo.CivicType .. '_BOOST', civicInfo.CivicType)
	end
end
Events.CivicBoostTriggered.Add(SumeriaCivicBoost)

-- 完成科技
function SumeriaTechCompleted(playerId, techId)
	local techInfo = GameInfo.Technologies[techId]
	if techInfo ~= nil then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_FINISH_TECH', 'HD_SPECIAL_SUBQUEST_FINISH_' .. techInfo.TechnologyType, techInfo.TechnologyType)
	end
end
Events.ResearchCompleted.Add(SumeriaTechCompleted)

-- 完成市政
function SumeriaCivicCompleted(playerId, civicId)
	local civicInfo = GameInfo.Civics[civicId]
	if civicInfo ~= nil then
		SumeriaCompleteSpecialQuest(playerId, 'HD_SPECIAL_QUEST_FINISH_CIVIC', 'HD_SPECIAL_SUBQUEST_FINISH_' .. civicInfo.CivicType, civicInfo.CivicType)
	end
end
Events.CivicCompleted.Add(SumeriaCivicCompleted)

-- 完成任务，提供特殊奖励
function SumeriaApplySpecialReward(player, specialReward)
	if not player then return; end
	if specialReward.ModifierId ~= nil then
		-- 如果有 ModifierId 则直接 Attach
		player:AttachModifierByID(specialReward.ModifierId)
		print("苏美尔 应用特殊奖励", specialReward.ModifierId)
	else
		if specialReward.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_GPP' then
			-- 伟人点
			local greatPersonClassId = GameInfo.GreatPersonClasses[specialReward.ObjectType].Index;
			local amount = specialReward.Amount or 0;
			player:GetGreatPeoplePoints():ChangePointsTotal(greatPersonClassId, amount);
			print("苏美尔 应用特殊奖励 伟人点", specialReward.ObjectType, amount)
		elseif specialReward.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_STRATEGIC_RESOURCE' then
			-- 战略资源
			local resourceId = GameInfo.Resources[specialReward.ObjectType].Index;
			local amount = 40;
			player:GetResources():ChangeResourceAmount(resourceId, amount)
			print("苏美尔 应用特殊奖励 战略资源", specialReward.ObjectType, amount)
		-- elseif specialReward.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT' then
		-- 	-- 陆军单位
		-- 	local capital = player:GetCities():GetCapitalCity()
		-- 	if capital then
		-- 		local unitId = GameInfo.Units[specialReward.ObjectType].Index
		-- 		player:GetUnits():Create(unitId, capital:GetX(), capital:GetY())
		-- 		print("苏美尔 应用特殊奖励 陆军单位", specialReward.ObjectType)
		-- 	end
		-- elseif specialReward.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_GRANT_SEA_UNIT' then
		-- 	-- 海军单位
		-- 	local capital = player:GetCities():GetCapitalCity()
		-- 	local capitalCanHaveSeaUnits = player:GetProperty('HD_CAPITAL_CAN_HAVE_SEA_UNITS') or 0
		-- 	if capital and capitalCanHaveSeaUnits > 0 then
		-- 		local unitId = GameInfo.Units[specialReward.ObjectType].Index
		-- 		-- 判断是否有港口
		-- 		local harbor = Utils.GetCityDistrict(capital, DISTRICT_HARBOR_INDEX)
		-- 		if harbor == nil then
		-- 			player:GetUnits():Create(unitId, capital:GetX(), capital:GetY())
		-- 		else
		-- 			player:GetUnits():Create(unitId, harbor:GetX(), harbor:GetY())
		-- 		end
		-- 		print("苏美尔 应用特殊奖励 海军单位", specialReward.ObjectType)
		-- 	end
		elseif specialReward.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_GRANT_LAND_UNIT'
		or specialReward.SpecialRewardType == 'HD_SPECIAL_QUEST_REWARD_GRANT_SEA_UNIT' then
			-- 军事单位
			local capital = player:GetCities():GetCapitalCity()
			if capital then
				capital:AttachModifierByID('HD_CITY_GRANT_' .. specialReward.ObjectType)
				print("苏美尔 应用特殊奖励 军事单位", specialReward.ObjectType)
			end
		else
			print("苏美尔 应用特殊奖励失败 未找到 ModifierId 或合法的 Lua 脚本")
		end
	end
end

-- 吉尔伽美什
	-- 建立首都获得恩奇都
local SumeriaGetEnkidu_Tag = "HD_SumeriaGetEnkidu"
local GREAT_PERSON_INDIVIDUAL_ENKIDU_HD_INDEX = GameInfo.GreatPersonIndividuals['GREAT_PERSON_INDIVIDUAL_ENKIDU_HD'].Index;
local GREAT_PERSON_CLASS_ENKIDU_HD_INDEX = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ENKIDU_HD'].Index;
function SumeriaGetEnkidu(playerId, cityId, x, y)
	if LeaderHasTrait(playerId, 'TRAIT_LEADER_ADVENTURES_ENKIDU') or LeaderHasTrait(playerId, 'TRAIT_LEADER_GILGAMESH_HEROES') then
		local player = Players[playerId]
		local alreadyHas = player:GetProperty(SumeriaGetEnkidu_Tag) or 0;
		if alreadyHas == 0 then
			player:SetProperty(SumeriaGetEnkidu_Tag, 1)
			local era = Game.GetEras():GetCurrentEra();
			Game.GetGreatPeople():GrantPerson(GREAT_PERSON_INDIVIDUAL_ENKIDU_HD_INDEX, GREAT_PERSON_CLASS_ENKIDU_HD_INDEX, era, 0, playerId, false);
		end
	end
end

	-- 恩奇都击杀单位
local UNIT_ENKIDU_HD_INDEX = GameInfo.Units['UNIT_ENKIDU_HD'].Index
local PROMOTION_ADVENTURE_CHAPTER_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_ADVENTURE_CHAPTER_HD'].Index
local ADVENTURE_CHAPTER_GPP_PERCENTAGE = GlobalParameters.HD_ADVENTURE_CHAPTER_GPP_PERCENTAGE or 0
local PROMOTION_HEROES_RETURN_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_HEROES_RETURN_HD'].Index
local HEROES_RETURN_WITHIN_TURNS_TAG = 'HD_HEROES_RETURN_WITHIN_TURNS'
local HEROES_HEROES_RETURN_TURNS = GlobalParameters.HD_HEROES_HEROES_RETURN_TURNS or 0
local IMMORTAL_SEARCH_ENKIDU_DEAD_TAG = 'HD_IMMORTAL_SEARCH_ENKIDU_DEAD'
local PROMOTION_IMMORTAL_SEARCH_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_IMMORTAL_SEARCH_HD'].Index
function SumeriaEnkiduKillUnit(killedPlayerId, killedUnitId, playerId, unitId)
	local unit = UnitManager.GetUnit(playerId, unitId);
	local killedUnit = UnitManager.GetUnit(killedPlayerId, killedUnitId);

	if unit and unit:GetType() == UNIT_ENKIDU_HD_INDEX then
		local player = Players[playerId]
		print("苏美尔 恩奇都击杀单位")

		-- 基础能力 加战斗力
		player:AttachModifierByID('HD_ENKIDU_STRENGTH_FROM_KILL_SET_PROPERTY')
		Game.AddWorldViewText(playerId, Locale.Lookup('LOC_ABILITY_HD_ENKIDU_STRENGTH_FROM_KILL_VIEWTEXT'), unit:GetX(), unit:GetY());
		
		-- 冒险篇章 大作家点数
		if unit:GetExperience():HasPromotion(PROMOTION_ADVENTURE_CHAPTER_HD_INDEX) then
			if killedUnit then
				local amount = math.floor(killedUnit:GetCombat() * ADVENTURE_CHAPTER_GPP_PERCENTAGE / 100)
				if amount > 0 then
					player:GetGreatPeoplePoints():ChangePointsTotal(WRITER_INDEX, amount);
					Game.AddWorldViewText(playerId, "+" .. amount .. " [ICON_GREATWRITER]", unit:GetX(), unit:GetY());
				end
			end
		end

		-- 英雄凯旋
		if unit:GetExperience():HasPromotion(PROMOTION_HEROES_RETURN_HD_INDEX) and HEROES_HEROES_RETURN_TURNS > 0 then
			if killedUnit then
				if killedUnit:GetCombat() > unit:GetCombat() then
					local capital = player:GetCities():GetCapitalCity()
					if capital then
						local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
						capitalPlot:SetProperty(HEROES_RETURN_WITHIN_TURNS_TAG, HEROES_HEROES_RETURN_TURNS)
						Game.AddWorldViewText(playerId, '[COLOR:ResCultureLabelCS]' .. Locale.Lookup('LOC_PROMOTION_HEROES_RETURN_HD_NAME') .. '[ENDCOLOR]', unit:GetX(), unit:GetY());
						Game.AddWorldViewText(playerId, '[COLOR:ResCultureLabelCS]' .. Locale.Lookup('LOC_PROMOTION_HEROES_RETURN_HD_NAME') .. '[ENDCOLOR]', capital:GetX(), capital:GetY());
						print("苏美尔 恩奇都 英雄凯旋")
					end
				end
			end
		end
	end

	if killedUnit and killedUnit:GetType() == UNIT_ENKIDU_HD_INDEX then
		-- 不朽追寻
		if killedUnit:GetExperience():HasPromotion(PROMOTION_IMMORTAL_SEARCH_HD_INDEX) then
			local killedPlayer = Players[killedPlayerId]
			local capital = killedPlayer:GetCities():GetCapitalCity()
			if capital then
				local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
				capitalPlot:SetProperty(IMMORTAL_SEARCH_ENKIDU_DEAD_TAG, 1)
				Game.AddWorldViewText(killedPlayerId, '[COLOR:Red]' .. Locale.Lookup('LOC_PROMOTION_IMMORTAL_SEARCH_HD_NAME') .. '[ENDCOLOR]', unit:GetX(), unit:GetY());
				Game.AddWorldViewText(killedPlayerId, '[COLOR:Red]' .. Locale.Lookup('LOC_PROMOTION_IMMORTAL_SEARCH_HD_NAME') .. '[ENDCOLOR]', capital:GetX(), capital:GetY());
				print("苏美尔 恩奇都 不朽追寻")
			end
		end
	end
end
Events.UnitKilledInCombat.Add(SumeriaEnkiduKillUnit);

	-- 恩奇都受伤 英雄相惜 获得信仰值
local PROMOTION_HEROES_CHERISH_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_HEROES_CHERISH_HD'].Index
local HEROES_CHERISH_FAITH_PERCENTAGE = GlobalParameters.HD_HEROES_CHERISH_FAITH_PERCENTAGE or 0;
function SumeriaEnkiduDamageChanged(playerId, unitId, newDamage, prevDamage)
	local unit = UnitManager.GetUnit(playerId, unitId);
	if unit and unit:GetType() == UNIT_ENKIDU_HD_INDEX and unit:GetExperience():HasPromotion(PROMOTION_HEROES_CHERISH_HD_INDEX) then
		local amount = math.floor((newDamage - prevDamage) * HEROES_CHERISH_FAITH_PERCENTAGE / 100)
		if amount > 0 then
			local player = Players[playerId]
			if player then
				player:GetReligion():ChangeFaithBalance(amount)
				local faithMessage = '[COLOR:ResFaithLabelCS]+' .. tostring(amount) .. '[ENDCOLOR][ICON_Faith]'
				Game.AddWorldViewText(playerId, faithMessage, unit:GetX(), unit:GetY());
			end
		end
	end
end

	-- 恩奇都 英雄凯旋 过回合递减回合数
function SumeriaEnkiduTurnStarted(playerId)
	local player = Players[playerId]
	local capital = player:GetCities():GetCapitalCity()
	if capital then
		local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
		local preValue = capitalPlot:GetProperty(HEROES_RETURN_WITHIN_TURNS_TAG) or 0;
		if preValue > 0 then
			capitalPlot:SetProperty(HEROES_RETURN_WITHIN_TURNS_TAG, preValue - 1)
			print("苏美尔 英雄凯旋 首都剩余回合数", preValue - 1)
			
		end
	end
end
GameEvents.PlayerTurnStarted.Add(SumeriaEnkiduTurnStarted);

	-- 恩奇都 史诗终章
local PROMOTION_EPIC_EPILOGUE_HD_INDEX = GameInfo.UnitPromotions['PROMOTION_EPIC_EPILOGUE_HD'].Index
local SumeriaEnkiduConqueredCapital_Tag = 'HD_SumeriaEnkiduConqueredCapital'
function SumeriaEnkiduConqueredCapital(playerId, cityId, x, y)
	-- 判断是否是原始首都
	if Utils.IsOriginalCapital(playerId, cityId) then
		-- 判断是否是其他文明
		local city = CityManager.GetCity(playerId, cityId)
		local originalOwnerId = city:GetOriginalOwner();
		if originalOwnerId ~= playerId then
			-- 判断是否是主要文明
			local originalOwner = Players[originalOwnerId]
			if originalOwner:IsMajor() then
				-- 判断是否是第一次
				local plot = Map.GetPlot(x, y)
				if plot and not plot:GetProperty(SumeriaEnkiduConqueredCapital_Tag) then
					-- 遍历该单元格内的所有单位
					local units = Units.GetUnitsInPlot(x, y)
					if units ~= nil then
						for _, unit in ipairs(units) do
							-- 判断是否是恩奇都
							if unit:GetType() == UNIT_ENKIDU_HD_INDEX and unit:GetExperience():HasPromotion(PROMOTION_EPIC_EPILOGUE_HD_INDEX) then
								plot:SetProperty(SumeriaEnkiduConqueredCapital_Tag, 1)
								local player = Players[playerId]
								local randomIndex = Game.GetRandNum(2, "Sumeria Enkidu Unlock Random Tech or Civic for Player " .. playerId) + 1
								if randomIndex == 1 then
									player:AttachModifierByID('HD_EPIC_EPILOGUE_GRANT_RANDOM_TECHNOLOGY')
									Game.AddWorldViewText(playerId, Locale.Lookup('LOC_ABILITY_HD_EPIC_EPILOGUE_FREE_TECH_VIEWTEXT'), x, y);
									print("恩奇都 史诗终章 随机科技")
								else
									player:AttachModifierByID('HD_EPIC_EPILOGUE_GRANT_RANDOM_CIVIC')
									Game.AddWorldViewText(playerId, Locale.Lookup('LOC_ABILITY_HD_EPIC_EPILOGUE_CIVIC_TECH_VIEWTEXT'), x, y);
									print("恩奇都 史诗终章 随机市政")
								end
							end
						end
					end
				end
			end
		end
	end
end

-- 额外建造金字形神塔
function SumeriaZigguratPantheonFounded(playerId)
	local player = Players[playerId]
	if player then
		player:AttachModifierByID('HD_CAPITAL_ALLOW_EXTRA_ZIGGURAT')
	end
end
Events.PantheonFounded.Add(SumeriaZigguratPantheonFounded)

function SumeriaZigguratReligionFounded(playerId, religionId)
	local player = Players[playerId]
	if player then
		player:AttachModifierByID('HD_CAPITAL_ALLOW_EXTRA_ZIGGURAT')
	end
end
Events.ReligionFounded.Add(SumeriaZigguratReligionFounded)

-- =====================================================================================================================================
-- 巴西
-- =====================================================================================================================================
function PedroGreatPersonFaith(playerID, unitID, greatPersonClassID, greatPersonIndividualID)
	local player = Players[playerID]
	local sMagnanimous = 'TRAIT_LEADER_MAGNANIMOUS'
	local sModifierID = 'TRAIT_GREAT_PEOPLE_JUNGLE_FAITH'
	local PROP_KEY_NUMBER_GREAT_PEOPLE = 'NumberofGreatPeople'
	if LeaderHasTrait(playerID, sMagnanimous) then
		local amount = player:GetProperty(PROP_KEY_NUMBER_GREAT_PEOPLE)
		if amount == nil then
			amount = 0
		end
		amount = amount + 1
		-- Every two greatperson add 1 faith to jungle.
		if amount == 2 then
			amount = 0
			player:AttachModifierByID(sModifierID)
		end
		player:SetProperty(PROP_KEY_NUMBER_GREAT_PEOPLE, amount)
	end
end

Events.UnitGreatPersonCreated.Add(PedroGreatPersonFaith)

--Mali EraScore +15 Gold
function MaliPlayerEraScoreChanged(playerID, amountAwarded)
	local player = Players[playerID]
	local sMaliGoldDesert = 'TRAIT_LEADER_SAHEL_MERCHANTS'
	local amount = GlobalParameters.MALI_EXTRA_GOLD_FOR_EVERY_ERA_SCORE
	if (not LeaderHasTrait(playerID, sMaliGoldDesert)) then return; end
	player:GetTreasury():ChangeGoldBalance(amountAwarded * amount)
end

Events.PlayerEraScoreChanged.Add(MaliPlayerEraScoreChanged)

-- =====================================================================================================================================
-- 阿兹特克
-- =====================================================================================================================================
function HD_Aztec_Sacrifice(eOwner : number, iUnitID : number)
	local pPlayer = Players[eOwner];
	if (pPlayer == nil) then
		return;
	end

	local pUnit = pPlayer:GetUnits():FindID(iUnitID);
	if (pUnit == nil) then
		return;
	end

	local city = CityManager.GetCityAt(pUnit:GetX(), pUnit:GetY());

	if city == nil then
		return;
	end
	local amount = 10 * pUnit:GetBuildCharges();
	pPlayer:GetCulture():ChangeCurrentCulturalProgress(amount);
	pPlayer:GetReligion():ChangeFaithBalance(amount);

	-- Flyover text
	local message:string  = Locale.Lookup("LOC_FLYOVER_AZTEC_SACRIFICE", amount);
	Game.AddWorldViewText(eOwner, message, pUnit:GetX(), pUnit:GetY());

	-- Report to the application side that we did something.  This helps with visualization
	-- UnitManager.ReportActivation(pUnit, "DEMOLISH");

end
GameEvents.HD_Aztec_Sacrifice.Add(HD_Aztec_Sacrifice)

-- =====================================================================================================================================
-- 波兰
-- =====================================================================================================================================
local PolandGovernmentBuildingCompleted_Tag = 'HD_PolandGovernmentBuildingCompleted_'
local GOLDEN_LIBERTY_ALL_GOV_BUILDING = GlobalParameters.HD_GOLDEN_LIBERTY_ALL_GOV_BUILDING or 0;
function PolandGovernmentBuildingCompleted(playerId, cityId, buildingId, plotId, bOriginalConstruction)
	if GOLDEN_LIBERTY_ALL_GOV_BUILDING == 1 and CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_GOLDEN_LIBERTY') then
		local buildingInfo = GameInfo.Buildings[buildingId]
		if buildingInfo and buildingInfo.PrereqDistrict == 'DISTRICT_GOVERNMENT' then
			local player = Players[playerId];
			if player:GetProperty(PolandGovernmentBuildingCompleted_Tag .. buildingInfo.GovernmentTierRequirement) ~= 1 then
				player:SetProperty(PolandGovernmentBuildingCompleted_Tag .. buildingInfo.GovernmentTierRequirement, 1)
				local city = CityManager.GetCity(playerId, cityId);
				-- 寻找同级建筑
				for row in GameInfo.Buildings() do
					if row.Index ~= buildingId
					and row.PrereqDistrict == 'DISTRICT_GOVERNMENT'
					and row.GovernmentTierRequirement == buildingInfo.GovernmentTierRequirement
					and row.TraitType == nil then
						print("波兰 建造同级市政广场建筑", Locale.Lookup(row.Name))
						city:GetBuildQueue():CreateBuilding(row.Index)
					end
				end
			end
		end
	end
end
GameEvents.BuildingConstructed.Add(PolandGovernmentBuildingCompleted)

local LITHUANIAN_UNION_COPY_ALLY_GPP = GlobalParameters.HD_LITHUANIAN_UNION_COPY_ALLY_GPP or 0;
local HASH_NOTIFICATION_POLAND_ALLIANCE_COPY_GPP = DB.MakeHash('NOTIFICATION_POLAND_ALLIANCE_COPY_GPP');
function PolandCopyAllyGpp(playerId, isFirstTime)
	if isFirstTime and LITHUANIAN_UNION_COPY_ALLY_GPP > 0 and LeaderHasTrait(playerId, 'TRAIT_LEADER_LITHUANIAN_UNION') then
		local player = Players[playerId];
		for _, allyId in ipairs(PlayerManager.GetAliveMajorIDs()) do
			if playerId ~= allyId then
				local allianceTypeId = Utils.GetAllianceTypeBetweenPlayers(playerId, allyId)
				if allianceTypeId ~= nil and allianceTypeId ~= -1 then
					local allianceInfo = GameInfo.Alliances[allianceTypeId]
					if allianceInfo then
						for row in GameInfo.AllianceCorrespondingGPP_HD() do
							if row.AllianceType == allianceInfo.AllianceType then
								local greatPersonClassInfo = GameInfo.GreatPersonClasses[row.GreatPersonClassType];
								if greatPersonClassInfo then
									-- 加伟人点
									local amount = Utils.GetGreatPeoplePointsPerTurn(allyId, greatPersonClassInfo.Index) * LITHUANIAN_UNION_COPY_ALLY_GPP / 100
									if amount > 0 then
										player:GetGreatPeoplePoints():ChangePointsTotal(greatPersonClassInfo.Index, amount);
										-- 发送通知
										local msg = Locale.Lookup(
											'LOC_TRAIT_LEADER_LITHUANIAN_UNION_VIEWTEXT',
											allianceInfo.Name,
											amount,
											greatPersonClassInfo.IconString,
											greatPersonClassInfo.Name
										)
										Utils.SendMergableNotification(playerId, HASH_NOTIFICATION_POLAND_ALLIANCE_COPY_GPP, Locale.Lookup('LOC_TRAIT_LEADER_LITHUANIAN_UNION_NAME'), msg)
										print("雅德维加 同盟复制伟人点", Locale.Lookup(allianceInfo.Name), Locale.Lookup(greatPersonClassInfo.Name), amount)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
Events.PlayerTurnActivated.Add(PolandCopyAllyGpp);

-- =====================================================================================================================================
-- 忽必烈 
-- =====================================================================================================================================
function KublaiGrantCivTrait( playerID, iX, iY )
	local captureModifier = {}
	local captureTrait = {}
	local pPlayer = Players[playerID]
	local pCity = CityManager.GetCityAt(iX, iY)
	local originalOwnerID = pCity:GetOriginalOwner() 
	
	if originalOwnerID ~= playerID and originalOwnerID ~= nil then
		-- 防止重复获取
		local oPlayer = Players[originalOwnerID]
		local oPlayerConfig = PlayerConfigurations[originalOwnerID]
		local oCiv = oPlayerConfig:GetCivilizationTypeName()
		local have_captured = pPlayer:GetProperty('PROP_KEY_HAVE_CAPTURED_'..oCiv)
		-- 判断是否是相同文明
		local pPlayerConfig = PlayerConfigurations[playerID]
		local pCiv = pPlayerConfig:GetCivilizationTypeName()
		local is_same_civ = pCiv == oCiv

		if have_captured == nil and is_same_civ == false then
			pPlayer:SetProperty('PROP_KEY_HAVE_CAPTURED_'..oCiv, true)

			-- 设置首都 plot property 用于获得reqset类能力
			local capital = pPlayer:GetCities():GetCapitalCity()
			local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
			capitalPlot:SetProperty(oCiv .. "_CAPTURED", 1)

			for tRow in GameInfo.CivilizationTraits() do
				if tRow.CivilizationType == oCiv then
					table.insert(captureTrait,tRow.TraitType)
					-- 获取 lua 能力
					pPlayer:SetProperty(tRow.TraitType .. "_CAPTURED", true);
					print("KublaiGrantCivTrait", tRow.TraitType)
				end
			end
			
			for _, traitType in ipairs(captureTrait) do
				for tRow in GameInfo.TraitModifiers() do
					if string.sub(tRow.TraitType,1,28) ~= 'TRAIT_CIVILIZATION_BUILDING_' and
					string.sub(tRow.TraitType,1,28) ~= 'TRAIT_CIVILIZATION_DISTRICT_' and
					tRow.TraitType == traitType then
						-- 排除获取特色项目的 modifier
						local isUP = false
						for upRow in GameInfo.UniqueProjects_HD() do
							if upRow.ModifierId == tRow.ModifierId then
								isUP = true
							end
						end
						-- 获取 modifier 能力
						if not isUP then
							table.insert(captureModifier,tRow.ModifierId)
							print("KublaiGrantCivTrait", tRow.ModifierId)
						end
					end
				end
			end

			for _, modifier in ipairs(captureModifier) do
				pPlayer:AttachModifierByID(modifier)
			end
		end
	end
end

GameEvents.KublaiGrantCivTraitSwitch.Add(KublaiGrantCivTrait)

-- Eleanor
-- ===========================================================================
-- Judgement of Love -- part of Gameplay
-- ===========================================================================
function ProjectJudgementOfLove(iX, iY, dX, dY)
	local city = CityManager.GetCityAt(iX, iY)
	local pCity = CityManager.GetCityAt(dX, dY)
	local pCityDistricts : object = pCity:GetDistricts();
	if (pCityDistricts ~= nil) then
		local eX, eY = pCityDistricts:GetDistrictLocation(DISTRICT_THEATER_INDEX)
		local distance = Map.GetPlotDistance(eX, eY, iX, iY)
		--print('PROJECT_CIRCUSES_AND_BREAD3',eX, eY, iX, iY, distance)
		if distance <= 9 then
			city:ChangeLoyalty(-200)
		end
	end
end
GameEvents.ProjectEnemyCitiesChangeLoyaltySwitch.Add(ProjectJudgementOfLove)

-- Hungary Conquer Envoy
--function ConquerEnvoy(newPlayerID, oldPlayerID, newCityID, iCityX, iCityY)
--    local pPlayer = Players[newPlayerID]
--    if pPlayer ~= nil then
--        local pPlayerConfig = PlayerConfigurations[newPlayerID]
--        local sLeader = pPlayerConfig:GetLeaderTypeName()
--        local sConquerEnvoy = 'TRAIT_LEADER_RAVEN_KING'
--        if LeaderHasTrait(sLeader, sConquerEnvoy) then
--            pPlayer:GetInfluence():ChangeTokensToGive(1)
--        end
--    end
--end
--GameEvents.CityConquered.Add(ConquerEnvoy)

-- 刚果
function MBANZABoost(playerID, districtID, iX, iY)
	local pPlayer = Players[playerID]
	if pPlayer ~= nil then
		local plot = Map.GetPlot(iX, iY)
		local districtType = plot:GetDistrictType()
		if ExposedMembers.DLHD.Utils.IsDistrictType(districtType, 'DISTRICT_MBANZA') then
			local m_THEOLOGY = GameInfo.Civics['CIVIC_THEOLOGY'].Index;
			local m_DIVINE_RIGHT = GameInfo.Civics['CIVIC_DIVINE_RIGHT'].Index;
			local m_REFORMED_CHURCH = GameInfo.Civics['CIVIC_REFORMED_CHURCH'].Index;

			if LeaderHasTrait(playerID, 'TRAIT_LEADER_RELIGIOUS_CONVERT') then
				pPlayer:GetCulture():TriggerBoost(m_THEOLOGY);
				pPlayer:GetCulture():TriggerBoost(m_DIVINE_RIGHT);
				pPlayer:GetCulture():TriggerBoost(m_REFORMED_CHURCH);
			end
		end
	end
end

GameEvents.OnDistrictConstructed.Add(MBANZABoost)

-- 维多利亚: 招提督送使者 by 先驱
function OnUnitGreatPersonCreated(playerID, unitID, greatPersonClassID, greatPersonIndividualID)
	if not LeaderHasTrait(playerID, 'TRAIT_LEADER_PAX_BRITANNICA') then
		return;
	end
	local era = nil;
	for row in GameInfo.GreatPersonIndividuals() do
		if row.Index == greatPersonIndividualID and row.GreatPersonClassType == 'GREAT_PERSON_CLASS_ADMIRAL' then
			era = row.EraType
			break
		end
	end
	if not era then
		return;
	end
	local player = Players[playerID]
	player:AttachModifierByID('HD_VICTORIA_GRANT_ENVOY');
end

Events.UnitGreatPersonCreated.Add(OnUnitGreatPersonCreated)

-- 巴西UD改动, by xiaoxiao
function OnUnitGreatPersonCreatedBrazil(playerID, unitID, greatPersonClassID, greatPersonIndividualID)
	local player = Players[playerID]
	if not CivilizationHasTrait(playerID, 'TRAIT_CIVILIZATION_STREET_CARNIVAL') then
		return;
	end
	for row in GameInfo.GreatPersonClasses() do
		if row.Index == greatPersonClassID then
			local classType = row.GreatPersonClassType
			player:AttachModifierByID('HD_BRAZIL_UD_' .. classType)
		end
	end
end
Events.UnitGreatPersonCreated.Add(OnUnitGreatPersonCreatedBrazil)

-- 法国UA改动
function FranceWonderGreatPeoplePoint (x, y, buildingId, playerId, cityId, percentComplete, unknown)
	local player = Players[playerId];
	if CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_WONDER_TOURISM') then
		local building = GameInfo.Buildings[buildingId];
		local amount = building.Cost * (GlobalParameters.FRANCE_WONDER_GREATPEOPLE_PERCENTAGE or 0) * 0.01;
		player:GetGreatPeoplePoints():ChangePointsTotal(WRITER_INDEX, amount);
		player:GetGreatPeoplePoints():ChangePointsTotal(ARTIST_INDEX, amount);
		player:GetGreatPeoplePoints():ChangePointsTotal(MUSICIAN_INDEX, amount);
	end
end
Events.WonderCompleted.Add(FranceWonderGreatPeoplePoint);

local FRANCE_GREATPEOPLE_WONDER_PERCENTAGE = GlobalParameters.FRANCE_GREATPEOPLE_WONDER_PERCENTAGE or 0;
function FranceGreatPeopleActiveWonder(playerId, unitId, x, y, buildingId, greatWorkIndex)
	local player = Players[playerId];
	if not CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_WONDER_TOURISM') then
		return;
	end
	local city = CityManager.GetCityAt(x, y);
	local greatWorkId = Utils.GetGreatWorkTypeFromIndex(playerId, city:GetID(), greatWorkIndex)
	local greatWorkInfo = GameInfo.GreatWorks[greatWorkId];
	-- print('FranceGreatPeopleActiveWonder', greatWorkInfo.GreatWorkType)
	if greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_SCULPTURE' or
		greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_PORTRAIT' or
		greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_LANDSCAPE' or
		greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_RELIGIOUS' or
		greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_WRITING' or
		greatWorkInfo.GreatWorkObjectType == 'GREATWORKOBJECT_MUSIC'
	then
		Utils.CityAddProgressPercentage(playerId, city:GetID(), FRANCE_GREATPEOPLE_WONDER_PERCENTAGE, {WonderOnly = true, AddViewText = true})
	end
end
Events.GreatWorkCreated.Add(FranceGreatPeopleActiveWonder);

-- 荷兰跳探索
local EXPLORATION_INDEX = GameInfo.Civics['CIVIC_EXPLORATION'].Index;
function NetherlandsBuildingAddedToMap (playerID, cityID, buildingID, plotID, bOriginalConstruction)
	if GlobalParameters.NETHERLANDS_EXPLORATION ~= 1 then
		return;
	end
	local player = Players[playerID];
	if CivilizationHasTrait(playerID, 'TRAIT_CIVILIZATION_GROTE_RIVIEREN') then
		local building = GameInfo.Buildings[buildingID];
		if building.PrereqDistrict == 'DISTRICT_HARBOR' then
			if not player:GetCulture():HasBoostBeenTriggered(EXPLORATION_INDEX) then
				player:GetCulture():TriggerBoost(EXPLORATION_INDEX);
			elseif not player:GetCulture():HasCivic(EXPLORATION_INDEX) then
				local cost = player:GetCulture():GetCultureCost(EXPLORATION_INDEX);
				player:GetCulture():SetCulturalProgress(EXPLORATION_INDEX, cost);
			end
		end
	end
end
GameEvents.BuildingConstructed.Add(NetherlandsBuildingAddedToMap);

-- 印加梯田触发尤里卡和鼓舞
local TERRACE_FARM_INDEX = GameInfo.Improvements['IMPROVEMENT_TERRACE_FARM'].Index;
local IRRIGATION_INDEX = GameInfo.Technologies['TECH_IRRIGATION'].Index;
local FEUDALISM_INDEX = GameInfo.Civics['CIVIC_FEUDALISM'].Index;
local TerraceFarm_Tag = "HD_TerraceFarm"
function TerraceFarmAddedToMap(x, y, improvementId, playerId, resourceId, isPillaged, isWorked)
	if improvementId == TERRACE_FARM_INDEX then
		local player = Players[playerId];
		-- 灌溉
		if resourceId >= 0 then
			if not player:GetTechs():HasBoostBeenTriggered(IRRIGATION_INDEX) then
				local resourceType = GameInfo.Resources[resourceId].ResourceType;
				for row in GameInfo.Improvement_ValidResources() do
					if row.ResourceType == resourceType and row.ImprovementType == 'IMPROVEMENT_FARM' then
						player:GetTechs():TriggerBoost(IRRIGATION_INDEX);
						break;
					end
				end
			end
		end
		
		-- 封建
		if not player:GetCulture():HasBoostBeenTriggered(FEUDALISM_INDEX) then
			local plot = Map.GetPlot(x, y)
			plot:SetProperty(TerraceFarm_Tag, 1)
			local amount = player:GetProperty(TerraceFarm_Tag)
			if amount == nil then
				player:SetProperty(TerraceFarm_Tag, 1)
			elseif amount < 3 then
				player:SetProperty(TerraceFarm_Tag, amount + 1)
			else
				player:GetCulture():TriggerBoost(FEUDALISM_INDEX);
			end
		end
	end
end

function TerraceFarmRemovedFromMap(x, y, playerId)
	local plot = Map.GetPlot(x, y)
	if plot:GetProperty(TerraceFarm_Tag) == 1 then
		plot:SetProperty(TerraceFarm_Tag, 0)
		local player = Players[playerId];
		local amount = player:GetProperty(TerraceFarm_Tag)
		if amount ~= nil then
			player:SetProperty(TerraceFarm_Tag, amount - 1)
		end
	end
end

-- 斯基泰 骑兵死亡加鸽子
local HOUSR_ARCHER_INDEX = GameInfo.Units['UNIT_SCYTHIAN_HORSE_ARCHER'].Index;
local GREAT_GENERAL_INDEX = GameInfo.Units['UNIT_GREAT_GENERAL'].Index;
function CavalryKurganFaith (killedPlayerId, killedUnitId, playerId, unitId)
	local player = Players[killedPlayerId];
	local unit = UnitManager.GetUnit(killedPlayerId, killedUnitId);
	for row in GameInfo.UnitPromotions() do
		if (row ~= nil) and (unit ~= nil) and (unit:GetExperience() ~= nil) and (unit:GetExperience():HasPromotion(row.Index)) then
			if (row.PromotionClass == 'PROMOTION_CLASS_LIGHT_CAVALRY') or (row.PromotionClass == 'PROMOTION_CLASS_HEAVY_CAVALRY') then
				player:AttachModifierByID('KURGAN_CAVALRY_FAITH');
			end
			if (row.PromotionClass == 'PROMOTION_CLASS_RANGED') and (unit:GetType() == HOUSR_ARCHER_INDEX) then
				player:AttachModifierByID('KURGAN_CAVALRY_FAITH');
			end
		end
	end
end
Events.UnitKilledInCombat.Add(CavalryKurganFaith);

function GreatGeneralFaith (playerId, unitId)
	local player = Players[playerId];
	local unit = UnitManager.GetUnit(playerId, unitId);
	if (unit ~= nil) and (unit:GetType() == GREAT_GENERAL_INDEX) then
		player:AttachModifierByID('KURGAN_GENERAL_FAITH');
	end
end
Events.UnitRemovedFromMap.Add(GreatGeneralFaith);

--波斯
function PersiaGrantYield (player, prereqDistrict, amount)
	if (prereqDistrict == 'DISTRICT_CAMPUS') or (prereqDistrict == 'DISTRICT_INDUSTRIAL_ZONE') or (PrereqDistrict == 'DISTRICT_ENCAMPMENT') then
		player:GetTechs():ChangeCurrentResearchProgress(amount);
	elseif (prereqDistrict == 'DISTRICT_HOLY_SITE') or (prereqDistrict == 'DISTRICT_THEATER') or (PrereqDistrict == 'DISTRICT_ENTERTAINMENT_COMPLEX') or (prereqDistrict == 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX') then
		player:GetCulture():ChangeCurrentCulturalProgress(amount);
	else
		player:GetTreasury():ChangeGoldBalance(4 * amount);
	end
end
function PersiaCityConquered (newPlayerId, oldPlayerId, newCityId, x, y)
	if not LeaderHasTrait(newPlayerId, 'TRAIT_LEADER_NADER_SHAH') then
		return;
	end
	local player = Players[newPlayerId];
	local city = CityManager.GetCity(newPlayerId, newCityId);
	local cityBuildings = city:GetBuildings();
	for row in GameInfo.Buildings() do
		if cityBuildings:HasBuilding(row.Index) then
			if (row.PrereqDistrict ~= nil) and (row.Cost ~= 0) and (row.Cost ~= 1) and (row.Cost ~= 9999)then
				cityBuildings:RemoveBuilding(row.Index);
				PersiaGrantYield(player, row.PrereqDistrict, row.Cost);
			end
		end
	end
	local cityDistricts = city:GetDistricts();
	for row in GameInfo.Districts() do
		if cityDistricts:HasDistrict(row.Index) and (row.DistrictType ~= 'DISTRICT_WONDER') and (row.DistrictType ~= 'DISTRICT_CITY_CENTER') then
			cityDistricts:RemoveDistrict(row.Index);
			PersiaGrantYield(player, row.DistrictType, row.Cost);
		end
	end
end
GameEvents.CityConquered.Add(PersiaCityConquered);
--马其顿
local ALEXANDER_WONDER_PERCENTAGE = GlobalParameters.ALEXANDER_WONDER_PERCENTAGE or 0;
function MacedonActiveWonder (newPlayerID, oldPlayerID, newCityID, iCityX, iCityY)
	local player = Players[newPlayerID];
	if not LeaderHasTrait(newPlayerID, 'TRAIT_LEADER_TO_WORLDS_END') then
		return;
	end
	for _, city in player:GetCities():Members() do
		Utils.CityAddProgressPercentage(newPlayerID, city:GetID(), ALEXANDER_WONDER_PERCENTAGE, {WonderOnly = true})
	end
end
GameEvents.CityConquered.Add(MacedonActiveWonder);

--瑞典时代分伟人点
function SwedenPlayerEraScoreChanged(playerID, amountAwarded)
	if amountAwarded <= 0 then return; end
	local player = Players[playerID];
	local sSweden = 'TRAIT_CIVILIZATION_NOBEL_PRIZE';
	local sCAMPUS = 0;
	local sCOMMERCIAL = 0;
	local sINDUSTRIAL = 0;
	local sTHEATER = 0;
	if (not CivilizationHasTrait(playerID, sSweden)) then
		return;
	end
	for _,city in player:GetCities():Members() do
		local cityDistricts = city:GetDistricts();

		if cityDistricts:HasDistrict(DISTRICT_CAMPUS_INDEX) and (Utils.IsDistrictComplete(playerId, city:GetID(), DISTRICT_CAMPUS_INDEX)) then
			sCAMPUS = sCAMPUS + 1;
		end
		if cityDistricts:HasDistrict(DISTRICT_COMMERCIAL_HUB_INDEX) and (Utils.IsDistrictComplete(playerId, city:GetID(), DISTRICT_COMMERCIAL_HUB_INDEX)) then
			sCOMMERCIAL = sCOMMERCIAL + 1;
		end
		if cityDistricts:HasDistrict(DISTRICT_INDUSTRIAL_ZONE_INDEX) and (Utils.IsDistrictComplete(playerId, city:GetID(), DISTRICT_INDUSTRIAL_ZONE_INDEX)) then
			sINDUSTRIAL = sINDUSTRIAL + 1;
		end
		if cityDistricts:HasDistrict(DISTRICT_THEATER_INDEX) and (Utils.IsDistrictComplete(playerId, city:GetID(), DISTRICT_THEATER_INDEX)) then
			sTHEATER = sTHEATER + 1;
		end

	end
	local coefficient = GlobalParameters.HD_NOBEL_PRIZE_ERA_SCORE_GPP_PER_DISTRICT or 0;
	player:GetGreatPeoplePoints():ChangePointsTotal(SCIENTIST_INDEX, amountAwarded * (coefficient * sCAMPUS + 1));
	player:GetGreatPeoplePoints():ChangePointsTotal(MERCHANT_INDEX, amountAwarded * (coefficient * sCOMMERCIAL + 1));
	player:GetGreatPeoplePoints():ChangePointsTotal(ENGINEER_INDEX, amountAwarded * (coefficient * sINDUSTRIAL + 1));
	player:GetGreatPeoplePoints():ChangePointsTotal(WRITER_INDEX, amountAwarded * (coefficient * sTHEATER + 1));
end

Events.PlayerEraScoreChanged.Add(SwedenPlayerEraScoreChanged);

--美国ua钱买人口
function AmericaUAAddPop(playerID, param)
	-- 获得玩家对象
    local pPlayer = Players[playerID]
    -- 获得城市对象
    local pCity = CityManager.GetCity(playerID, param.cityID)
	-- 玩家对象和城市对象肯定都不能为nil，不然操作无法实现
    if pCity and pPlayer then
		--扣除金币
		pPlayer:GetTreasury():ChangeGoldBalance(-param.goldneed)
		--增加人口
		pCity:ChangePopulation(1)
		Game.AddWorldViewText(playerID, "+1 [ICON_CITIZEN]", pCity:GetX(), pCity:GetY());
		Game.AddWorldViewText(playerID, "-" .. param.goldneed .. " [ICON_GOLD]", pCity:GetX(), pCity:GetY());
    end
end

GameEvents.AmericaAddPop.Add(AmericaUAAddPop)

--美国ua获得单元格给收益
function AmericaPlotGoldChangeTurnEnd (playerId, AmericaPlotsIndex, pPlotNumber, ResourcePlotNumber)
	local pPlayer = Players[playerId];
	local CapitalCity = pPlayer:GetCities():GetCapitalCity();
	for i, pPlotIndex in ipairs(AmericaPlotsIndex) do
		local pPlot = Map.GetPlotByIndex(pPlotIndex);
		pPlot:SetProperty("AmericaPlotChanged", 1);
	end
	local GoldAmount = pPlotNumber * GlobalParameters.AMERICA_GOLD_FROM_EVERY_PLOTS + ResourcePlotNumber * GlobalParameters.AMERICA_GOLD_FROM_LUXURY_AND_STRATEGIC;
	if GoldAmount ~= 0 then
		pPlayer:GetTreasury():ChangeGoldBalance(GoldAmount);
		Game.AddWorldViewText(playerId, "+" .. GoldAmount .. " [ICON_GOLD]", CapitalCity:GetX(), CapitalCity:GetY());
	end
end

GameEvents.AmericaPlotGoldChangeTurnEndSwitch.Add(AmericaPlotGoldChangeTurnEnd);

--武美攻占首都
function RoughRiderCityConquered(playerID, iX, iY)
	local pPlayer = Players[playerID];
	local pCity = CityManager.GetCityAt(iX, iY);
	local originalOwnerID = pCity:GetOriginalOwner();
	local oPlayer = Players[originalOwnerID];
	local count = 0;
	if originalOwnerID ~= playerID and originalOwnerID ~= nil then
		for citystateID, player in ipairs(Players) do
			if (player ~= nil) and (player:GetInfluence() ~= nil) and player:GetInfluence():CanReceiveInfluence() then
				local citystateConfig = PlayerConfigurations[citystateID];
				-- print(player:GetInfluence():GetSuzerain());
				-- print(originalOwnerID);
				-- print(citystateConfig:GetLeaderTypeName());
				if player:GetInfluence():GetSuzerain() == originalOwnerID then
					-- print(playerID);
					-- print(player:GetInfluence():GetSuzerain());
					count = player:GetInfluence():GetTokensReceived(originalOwnerID);
					-- print(count);
					-- print(player:GetInfluence():GetTokensReceived(originalOwnerID));
					while ((count ~= -1) and (player:GetInfluence():GetSuzerain() ~= playerID)) do
						pPlayer:GetInfluence():GiveFreeTokenToPlayer(citystateID);
						count = count - 1;
					end
				end
			end
		end
	end
end
GameEvents.RoughRiderCityConqueredSwitch.Add(RoughRiderCityConquered);

--武马里
local MaliUnit = 'HD_MaliList';
function MaliCityMadePurchase(playerId, cityId, x, y, purchaseType, objectType)
	local player = Players[playerId];
	if not LeaderHasTrait(playerId, 'TRAIT_LEADER_SUNDIATA_KEITA') then
		return;
	end
 	if not (purchaseType == EventSubTypes.UNIT) then
		return;
 	end
	local unitId = player:GetProperty(MaliUnit);
	local pUnit = UnitManager.GetUnit(playerId, unitId);
	UnitManager.RestoreMovement(pUnit, true);
	UnitManager.RestoreUnitAttacks(pUnit, true);
end

Events.CityMadePurchase.Add(MaliCityMadePurchase);

function MaliUnitAddedToMap(playerId, unitId)
	local player = Players[playerId];
	if not LeaderHasTrait(playerId, 'TRAIT_LEADER_SUNDIATA_KEITA') then
		return;
	end
	player:SetProperty(MaliUnit, unitId);
end

--迪奥多拉圣地送建造者
function TheodoraOnDistrictConstructed (playerId, districtId, x, y)
	if not LeaderHasTrait(playerId, 'TRAIT_LEADER_THEODORA') then
		return;
	end
	local tdistrict = CityManager.GetDistrictAt(x, y);
	local tcity = tdistrict:GetCity();
	local plot = Map.GetPlot(x, y);
    local districtType = plot:GetDistrictType();
	if ExposedMembers.DLHD.Utils.IsDistrictType(districtType, 'DISTRICT_HOLY_SITE') then
		tcity:AttachModifierByID('TRAIT_WONDER_GRANT_BUILDER_MODIFIER');
	end
end
GameEvents.OnDistrictConstructed.Add(TheodoraOnDistrictConstructed);

--迪奥多拉圣地建筑送人口
local Theodora_Add_POP_TAG = 'HD_Theodora_Add_POP_TAG_'
function TheodoraBuildingConstructed(playerId, cityId, buildingId, plotId, bOriginalConstruction)
	if not LeaderHasTrait(playerId, 'TRAIT_LEADER_THEODORA') then
		return;
	end
	local buildingInfo = GameInfo.Buildings[buildingId]
	if buildingInfo and buildingInfo.PrereqDistrict == 'DISTRICT_HOLY_SITE' then
		-- 判断是否是虚拟建筑
		for row in GameInfo.HD_DUMMY_BUILDINGS() do
			if row.BuildingType == buildingInfo.BuildingType then
				return;
			end
		end

		-- 添加人口
		local city = CityManager.GetCity(playerId, cityId);
		if city:GetProperty(Theodora_Add_POP_TAG .. buildingId) ~= 1 then
			city:SetProperty(Theodora_Add_POP_TAG .. buildingId, 1)
			city:AttachModifierByID('THEODORA_DISTRICT_HOLY_SITE_BUILDING_GRANT_CITIZEN')
		end
	end
end
GameEvents.BuildingConstructed.Add(TheodoraBuildingConstructed)

-- 迪奥多拉创立宗教额外多选一个信条
function TheodoraReligionFounded(playerId, religionId)
	local player = Players[playerId]
	if player and LeaderHasTrait(playerId, 'TRAIT_LEADER_THEODORA') then
		player:AttachModifierByID('THEODORA_ADD_BELIEF');
		print("迪奥多拉创立宗教额外多选一个信条");
	end
end
Events.ReligionFounded.Add(TheodoraReligionFounded)

--林肯工业区送建造者
function LincolnOnDistrictConstructed (playerId, districtId, x, y)
	if not LeaderHasTrait(playerId, 'TRAIT_LEADER_LINCOLN') then
		return;
	end
	local tdistrict = CityManager.GetDistrictAt(x, y);
	local tcity = tdistrict:GetCity();
	local plot = Map.GetPlot(x, y);
    local districtType = plot:GetDistrictType();
	if ExposedMembers.DLHD.Utils.IsDistrictType(districtType, 'DISTRICT_INDUSTRIAL_ZONE') then
		tcity:AttachModifierByID('TRAIT_WONDER_GRANT_BUILDER_MODIFIER');
	end
end
GameEvents.OnDistrictConstructed.Add(LincolnOnDistrictConstructed);

--挪威
local VarangianAdventurenumber = 'HD_VarangianAdventure';
function VarangianAdventure()
	for _, iPlayer in pairs(PlayerManager.GetWasEverAliveIDs()) do
		local player = Players[iPlayer];
		if LeaderHasTrait(iPlayer, 'TRAIT_LEADER_HARALD_ALT') then
			local pPlayerVisibility = PlayersVisibility[iPlayer];
			-- print(pPlayerVisibility);
			if pPlayerVisibility then
				local curExploredCount:number = pPlayerVisibility:GetNumRevealedHexes();
				local amount = player:GetProperty(VarangianAdventurenumber) or 0;
				player:SetProperty(VarangianAdventurenumber, curExploredCount);
				player:GetTreasury():ChangeGoldBalance(curExploredCount - amount);
				return;
			end
		end
	end
end
function HaraldTurnEnd(iTurn:number)
	VarangianAdventure();
end
Events.TurnEnd.Add(HaraldTurnEnd);

function HaraldGoodyHutReward(playerID, unitID, iRewardType, iRewardSubType)
	local player = Players[playerID];
	if player ~= nil then
		if not LeaderHasTrait(playerID, 'TRAIT_LEADER_HARALD_ALT') then
			return;
		end
		player:GetTreasury():ChangeGoldBalance(30);
	end
end
Events.GoodyHutReward.Add(HaraldGoodyHutReward);

-- =====================================================================================================================================
-- 西班牙
-- =====================================================================================================================================
local SPAIN_NATURAL_WONDER_REVEALED_TAG = 'HD_SpainNaturalWonderRevealed_';
local SPAIN_NATURAL_WONDER_REVEALED_LIST_TAG = 'HD_SpainNaturalWonderRevealedList';
function SpainNaturalWonderRevealed(playerId, unitId)
	local player = Players[playerId];
	local unit = UnitManager.GetUnit(playerId, unitId);
	if not player or not unit then return; end

	local plots = Map.GetNeighborPlots(unit:GetX(), unit:GetY(), 1);
  for _, plot in ipairs(plots) do
    if plot and plot:IsNaturalWonder() then
			-- 判断是否探索过
			local featureId = plot:GetFeatureType();
			if featureId and featureId ~= -1 and player:GetProperty(SPAIN_NATURAL_WONDER_REVEALED_TAG .. featureId) ~= 1 then
				local featureInfo = GameInfo.Features[featureId];
				if featureInfo then
					player:AttachModifierByID('TRAIT_' .. featureInfo.FeatureType .. '_ADD_GOVERNOR')
					player:AttachModifierByID('TRAIT_' .. featureInfo.FeatureType .. '_ADD_PROPHET_POINT')
					player:AttachModifierByID('TRAIT_' .. featureInfo.FeatureType .. '_ADD_WRITER_POINT')
					player:AttachModifierByID('TRAIT_' .. featureInfo.FeatureType .. '_ADD_ARTIST_POINT')

					for row2 in GameInfo.Feature_YieldChanges() do
						if row2.FeatureType == featureInfo.FeatureType then
							player:AttachModifierByID('TRAIT_' .. featureInfo.FeatureType .. '_ON_' .. row2.YieldType)
							player:AttachModifierByID('TRAIT_PALACE_' .. featureInfo.FeatureType .. '_ON_' .. row2.YieldType)
						end
					end

					for row3 in GameInfo.Feature_AdjacentYields() do
						if row3.FeatureType == featureInfo.FeatureType then
							player:AttachModifierByID('TRAIT_' .. featureInfo.FeatureType .. '_ADJACENT_' .. row3.YieldType)
							player:AttachModifierByID('TRAIT_PALACE_' .. featureInfo.FeatureType .. '_ADJACENT_' .. row3.YieldType)
						end
					end

					player:SetProperty(SPAIN_NATURAL_WONDER_REVEALED_TAG .. featureId, 1);

					local list = player:GetProperty(SPAIN_NATURAL_WONDER_REVEALED_LIST_TAG) or {};
					table.insert(list, featureId);
					player:SetProperty(SPAIN_NATURAL_WONDER_REVEALED_LIST_TAG, list);

					local traitName = Locale.Lookup('LOC_TRAIT_CIVILIZATION_TREASURE_FLEET_NAME')
					local featureName = Locale.Lookup(featureInfo.Name)
					local message = '[COLOR:Gold]' .. traitName .. ' ' .. featureName .. '[ENDCOLOR]'
					Game.AddWorldViewText(playerId, message, plot:GetX(), plot:GetY());
				end
			end
    end
  end

	-- 升级
	local nextExp = unit:GetExperience():GetExperienceForNextLevel();
	local nowExp = unit:GetExperience():GetExperiencePoints();
	if nextExp > nowExp and nowExp >= 0 then
		unit:GetExperience():ChangeExperience(nextExp - nowExp);
	end

	-- 消耗移动力
	local movesRemaining = Utils.GetUnitMovesRemaining(playerId, unitId)
  unit:ChangeMovesRemaining(-movesRemaining)
end
GameEvents.HD_SPAIN_EL_DORADO.Add(SpainNaturalWonderRevealed);

local SPAIN_INTERCONTINENTAL_CITY_TRADE_TAG = 'HD_SpainIntercontinentalCityAdded_';
function SpainCityAddedToMap(playerId, cityId, x, y)
	if CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_TREASURE_FLEET') then
		local plot = Map.GetPlot(x, y)
		local newCityContinent = plot:GetContinentType()

		local player = Players[playerId]
		local capital = player:GetCities():GetCapitalCity()
		local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
		local capitalContinent = capitalPlot:GetContinentType()

		if (newCityContinent ~= nil and capitalContinent ~= nil and newCityContinent ~= capitalContinent) then
			if player:GetProperty(SPAIN_INTERCONTINENTAL_CITY_TRADE_TAG .. newCityContinent) ~= 1 then
				player:AttachModifierByID('TRAIT_TREASURE_FLEET_TRADE_ROUTE_CAPACITY')
				-- local city = CityManager.GetCity(playerId, cityId);
				-- city:AttachModifierByID('TRAIT_TREASURE_FLEET_GRANT_TRADER')

				player:SetProperty(SPAIN_INTERCONTINENTAL_CITY_TRADE_TAG .. newCityContinent, 1)
			end
		end
	end
end

-- 西班牙 传教团
local MISSION_INDEX = GameInfo.Improvements['IMPROVEMENT_MISSION'].Index;
function MissionAddedToMap (x, y, improvementId, playerId, resourceId, isPillaged, isWorked)
	if improvementId == MISSION_INDEX then
		local plot = Map.GetPlot(x, y)
		local player = Players[playerId]
		local religionID = player:GetReligion():GetReligionTypeCreated()
		if plot ~= nil and player ~= nil and religionID >= 0 then
			for _, cityOwner in ipairs(Players) do
				if cityOwner:GetCities() ~= nil then
					for _, city in cityOwner:GetCities():Members() do
						local cityLocation = city:GetLocation();
						if Map.GetPlotDistance(x, y, cityLocation.x, cityLocation.y) <= 3 then
							city:GetReligion():AddReligiousPressure(playerId, religionID, 150, playerId);
							for row in GameInfo.Religions() do
								if row.Index == religionID then
									local religionName = Locale.Lookup(row.Name)
									local message = '[COLOR:White]+' .. tostring(150) .. ' ' .. religionName .. '[ENDCOLOR]'
									Game.AddWorldViewText(playerId, message, cityLocation.x, cityLocation.y)
								end
							end
						end
					end
				end
			end
		end
	end
end

-- 西班牙 LA
local TREASURE_FLEET_CONQUERED_CITY_TAG = 'HD_TreasureFleetConqueredCity';
local NAVAL_TRADITION_INDEX = GameInfo.Civics['CIVIC_NAVAL_TRADITION'].Index;
function TreasureFleetConqueredCity(newPlayerId, oldPlayerId, newCityId, iCityX, iCityY)
	local player = Players[newPlayerId]
	if LeaderHasTrait(newPlayerId, 'TRAIT_LEADER_EL_ESCORIAL') then
		local cityPlot = Map.GetPlot(iCityX, iCityY)
		cityPlot:SetProperty(TREASURE_FLEET_CONQUERED_CITY_TAG, 1)
	end
end
GameEvents.CityConquered.Add(TreasureFleetConqueredCity);

function TreasureFleetUnitTeleported(playerId, unitId, x, y)
	local player = Players[playerId]
	if LeaderHasTrait(playerId, 'TRAIT_LEADER_EL_ESCORIAL') then
		local plot = Map.GetPlot(x, y)
		if plot:GetProperty(TREASURE_FLEET_CONQUERED_CITY_TAG) == 1 then
			local unit = UnitManager.GetUnit(playerId, unitId)
			local domian = GameInfo.Units[unit:GetType()].Domain
			local formationClass = GameInfo.Units[unit:GetType()].FormationClass
			local militaryFormation = unit:GetMilitaryFormation()
			if domian == 'DOMAIN_SEA' and formationClass == 'FORMATION_CLASS_NAVAL' then
				if militaryFormation ~= MilitaryFormationTypes.CORPS_FORMATION and militaryFormation ~= MilitaryFormationTypes.ARMY_FORMATION then
					if player:GetCulture():HasCivic(EXPLORATION_INDEX) then
						unit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION)
					elseif player:GetCulture():HasCivic(NAVAL_TRADITION_INDEX) then
						unit:SetMilitaryFormation(MilitaryFormationTypes.CORPS_FORMATION)
					end
				elseif militaryFormation == MilitaryFormationTypes.CORPS_FORMATION then
					if player:GetCulture():HasCivic(EXPLORATION_INDEX) then
						unit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION)
					end
				end
				plot:SetProperty(TREASURE_FLEET_CONQUERED_CITY_TAG, 0)
			elseif domian == 'DOMAIN_LAND' and formationClass == 'FORMATION_CLASS_LAND_COMBAT' then
				plot:SetProperty(TREASURE_FLEET_CONQUERED_CITY_TAG, 0)
			end
		end
	end
end
Events.UnitTeleported.Add(TreasureFleetUnitTeleported)

-- =====================================================================================================================================
-- 日本
-- =====================================================================================================================================
-- 德川家康跳封建
local FEUDALISM_INDEX = GameInfo.Civics['CIVIC_FEUDALISM'].Index;
function TokugawaDistrictConstructed(playerID, districtID, iX, iY)
	local player = Players[playerID];

	if LeaderHasTrait(playerID, 'TRAIT_LEADER_TOKUGAWA') then
		if districtID == DISTRICT_ENCAMPMENT_INDEX then
			if not player:GetCulture():HasBoostBeenTriggered(FEUDALISM_INDEX) then
				player:GetCulture():TriggerBoost(FEUDALISM_INDEX);
			elseif not player:GetCulture():HasCivic(FEUDALISM_INDEX) then
				local cost = player:GetCulture():GetCultureCost(FEUDALISM_INDEX);
				player:GetCulture():SetCulturalProgress(FEUDALISM_INDEX, cost);
			end
		end
	end
end
GameEvents.OnDistrictConstructed.Add(TokugawaDistrictConstructed);

-- 瑞典LB跳歌剧与芭蕾
local OPERA_BALLET_INDEX = GameInfo.Civics['CIVIC_OPERA_BALLET'].Index;
function QueenBibliothequeBuildingAddedToMap (playerID, cityID, buildingID, plotID, bOriginalConstruction)
	if GlobalParameters.BUILDING_QUEENS_BIBLIOTHEQUE_OPERA_BALLET ~= 1 then
		return;
	end
	local player = Players[playerID];
	local building = GameInfo.Buildings[buildingID];
	if building.BuildingType == 'BUILDING_QUEENS_BIBLIOTHEQUE' then
		if not player:GetCulture():HasBoostBeenTriggered(OPERA_BALLET_INDEX) then
			player:GetCulture():TriggerBoost(OPERA_BALLET_INDEX);
		elseif not player:GetCulture():HasCivic(OPERA_BALLET_INDEX) then
			local cost = player:GetCulture():GetCultureCost(OPERA_BALLET_INDEX);
			player:GetCulture():SetCulturalProgress(OPERA_BALLET_INDEX, cost);
		end
	end

end
GameEvents.BuildingConstructed.Add(QueenBibliothequeBuildingAddedToMap);

-- 瑞典LA尤里卡和鼓舞加速首都建造
local KRISTINA_BOOST_ADD_BUILD_PERCENTAGE = GlobalParameters.HD_KRISTINA_BOOST_ADD_BUILD_PERCENTAGE or 0;
function KristinaBoostTriggered(playerId)
	if GlobalParameters.HD_KRISTINA_BOOST_ADD_BUILD ~= 1 then
		return;
	end

	local player = Players[playerId];

	if LeaderHasTrait(playerId, 'TRAIT_LEADER_KRISTINA_AUTO_THEME') then
		local capital = player:GetCities():GetCapitalCity();
		if capital then
			Utils.CityAddProgressPercentage(playerId, capital:GetID(), KRISTINA_BOOST_ADD_BUILD_PERCENTAGE, {AddViewText = true})
		end
	end
end
Events.CivicBoostTriggered.Add(KristinaBoostTriggered)
Events.TechBoostTriggered.Add(KristinaBoostTriggered)

-- 编撰官招募
local CodifierListTag = "HD_CodifierList";
local CodifierPersonClass = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_HD_CODIFIER"];
function InitCodifier()
	local codifierList = {};
	for row in GameInfo.GreatPersonIndividuals() do
		if row.GreatPersonClassType == "GREAT_PERSON_CLASS_HD_CODIFIER" then
			table.insert(codifierList, row.Index);
		end
	end
	return codifierList;
end

function GrantCodifier(playerId)
	if CodifierPersonClass == nil then return; end

	local player = Players[playerId];
	local codifierList = player:GetProperty(CodifierListTag);

	if codifierList == nil then
		print("男朝鲜招募编撰官 初始化编撰官列表")
		codifierList = InitCodifier()
	end
		
	if #codifierList < 1 then
		return; 
	else
		print("男朝鲜招募编撰官 剩余可招募编撰官数量", #codifierList)
		local randomIndex = Game.GetRandNum(#codifierList, "Random Codifier for Player " .. playerId) + 1
		local era = Game.GetEras():GetCurrentEra();
		Game.GetGreatPeople():GrantPerson(codifierList[randomIndex], CodifierPersonClass.Index, era, 0, playerId, false);
		table.remove(codifierList, randomIndex);
		player:SetProperty(CodifierListTag, codifierList);
	end
end

-- 完成学院建筑送伟人
function SeJongBuildingConstructed(playerId, cityId, buildingType, plotId, originalConstruction)
	if not LeaderHasTrait(playerId, 'TRAIT_LEADER_SEJONG') then
		return;
	end
	local player = Players[playerId];

	local tBuilding = GameInfo.Buildings[buildingType];
	if not tBuilding then 
		return;
	end
	if tBuilding.PrereqDistrict == "DISTRICT_CAMPUS" and tBuilding.Cost ~= 0 then
		GrantCodifier(playerId);
	end
end
GameEvents.BuildingConstructed.Add(SeJongBuildingConstructed);

-- 书院地基送伟人 送槽位
local BUILDING_SEOWON_INFO = GameInfo.Buildings["BUILDING_SEOWON"];
function SeJongDistrictConstructed(playerId, districtType, x, y)
	if BUILDING_SEOWON_INFO == nil or not LeaderHasTrait(playerId, 'TRAIT_LEADER_SEJONG') then
		return;
	end

	if districtType == DISTRICT_SEOWON_INDEX or districtType == DISTRICT_CAMPUS_INDEX then
		-- 送伟人
		GrantCodifier(playerId);

		-- 送虚拟建筑 槽位
		local plot = Map.GetPlot(x, y);
		if plot then
			local city = Cities.GetPlotPurchaseCity(plot);
      if city then
        city:GetBuildQueue():CreateBuilding(BUILDING_SEOWON_INFO.Index)
      end
		end
	end
end
GameEvents.OnDistrictConstructed.Add(SeJongDistrictConstructed);

-- 李裪LA
function SeJongGreatPersonCreated(playerId, unitId, greatPersonClassId, greatPersonIndividualId)
	if SCIENTIST_INDEX ~= greatPersonClassId then
		return;
	end

	local alivePlayers = PlayerManager.GetAliveMajorIDs()
	for _, alivePlayerId in ipairs(alivePlayers) do
		if alivePlayerId ~= playerId then
			local player = Players[alivePlayerId];
			if LeaderHasTrait(alivePlayerId, 'TRAIT_LEADER_SEJONG') then
				for row in GameInfo.GreatPersonIndividuals() do
					if row.Index == greatPersonIndividualId then
						local greatPersonIndividualType = row.GreatPersonIndividualType;
						print('SeJongGreatPersonCreated', greatPersonIndividualType)
						for row2 in GameInfo.GreatPersonIndividualActionModifiers() do
							if row2.GreatPersonIndividualType == greatPersonIndividualType then
								print('SeJongGreatPersonCreated', row2.ModifierId, row2.AttachmentTargetType)
								if row2.AttachmentTargetType == 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_CITY' then
									local capital = player:GetCities():GetCapitalCity();
									capital:AttachModifierByID(row2.ModifierId)
								elseif row2.AttachmentTargetType == 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE' then
									local capital = player:GetCities():GetCapitalCity();
									capital:AttachModifierByID(row2.GreatPersonIndividualType .. '_' .. row2.ModifierId .. '_ATTACH')
								elseif row2.AttachmentTargetType == 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER' then
									player:AttachModifierByID(row2.ModifierId)
								end
							end
						end
					end
				end
			end
		end
	end
end
Events.UnitGreatPersonCreated.Add(SeJongGreatPersonCreated);

-- 图拉真
function TrajanCityProductionChanged(playerId, cityId, productionId, objectId)
	local player = Players[playerId];

	if LeaderHasTrait(playerId, 'TRAJANS_COLUMN_TRAIT') then
		local city = player:GetCities():FindID(cityId);
		if city ~= nil then
			local current = city:GetBuildQueue():CurrentlyBuilding();
			if current then
				local buildingInfo = GameInfo.Buildings[current];
				local districtInfo = GameInfo.Districts[current];

				if buildingInfo ~= nil then
					if buildingInfo.PrereqDistrict == 'DISTRICT_GOVERNMENT' then
						city:GetBuildQueue():FinishProgress()
					end
				end

				if districtInfo ~= nil then
					if districtInfo.DistrictType == 'DISTRICT_GOVERNMENT' then
						city:GetBuildQueue():FinishProgress()
					end
				end
			end
		end
	end
end
Events.CityProductionChanged.Add(TrajanCityProductionChanged)

-- 埃及女王
local Cleopatra_Trait = 'TRAIT_LEADER_MEDITERRANEAN'
local Cleopatra_Tag = 'CleopatraAlliance_times'
function CleopatraAlliance(id1, id2)
	local alliance = Utils.GetAllianceTypeBetweenPlayers(id1, id2)
	if alliance == nil or alliance == -1 then
		return;
	end

	local is_Cleopatra = LeaderHasTrait(id1, Cleopatra_Trait)

	if is_Cleopatra then
		print('CleopatraAlliance', id1, id2, alliance)
		local captureModifier = {}
		local captureTrait = {}
		local player = Players[id1]
		-- 防止重复获取
		local targetPlayer = Players[id2]
		local targetPlayerConfig = PlayerConfigurations[id2]
		local targetLeader = targetPlayerConfig:GetLeaderTypeName()
		local have_captured = player:GetProperty('PROP_KEY_HAVE_CAPTURED_'..targetLeader)
		-- 判断是否是相同领袖
		local playerConfig = PlayerConfigurations[id1]
		local leader = playerConfig:GetLeaderTypeName()
		local is_same_leader = leader == targetLeader
		-- 判断结盟次数
		local times = player:GetProperty(Cleopatra_Tag) or 0
		local can_captured = times < 2
		print('CleopatraAlliance1', times)
		
		if have_captured == nil and is_same_leader == false and can_captured then
			player:SetProperty(Cleopatra_Tag, times + 1)
			player:SetProperty('PROP_KEY_HAVE_CAPTURED_'..targetLeader, true)

			-- 设置首都 plot property 用于获得reqset类能力
			local capital = player:GetCities():GetCapitalCity()
			local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
			capitalPlot:SetProperty(targetLeader .. "_CAPTURED", 1)

			-- 获取对应 trait
			for tRow in GameInfo.LeaderTraits() do
				if tRow.LeaderType == targetLeader then
					table.insert(captureTrait,tRow.TraitType)
					-- 获取 lua 能力
					player:SetProperty(tRow.TraitType .. "_CAPTURED", true);
					print('CleopatraAlliance2', tRow.TraitType)
				end
			end

			for _, traitType in ipairs(captureTrait) do
				for tRow in GameInfo.TraitModifiers() do
					if tRow.TraitType == traitType then
						-- 排除获取特色项目的 modifier
						local isUP = false
						for upRow in GameInfo.UniqueProjects_HD() do
							if upRow.ModifierId == tRow.ModifierId then
								isUP = true
							end
						end
						-- 获取 modifier 能力
						if not isUP then
							table.insert(captureModifier,tRow.ModifierId)
							print('CleopatraAlliance3', tRow.ModifierId)
						end
					end
				end
			end

			for _, modifier in ipairs(captureModifier) do
				player:AttachModifierByID(modifier)
			end
		end
	end
end
Events.DiplomacyRelationshipChanged.Add(CleopatraAlliance)

-- 腓尼基
	-- UA 送人口
local Dido_Has_Capital_Tag = 'HD_Dido_Has_Capital'
local DidoCityProjectCompleted_Tag = 'HD_DidoCityProjectCompleted_'
function PhoeniciaCityAddedToMap(playerId, cityId, x, y)
	local player = Players[playerId];
	if CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_MEDITERRANEAN_COLONIES') then
		-- 首都建立时设置 Property
		if player:GetProperty(Dido_Has_Capital_Tag) == nil then
			local plot = Map.GetPlot(x, y);
			local capitalContinent = plot:GetContinentType();
			player:SetProperty(Dido_Has_Capital_Tag, 1)
			player:SetProperty(DidoCityProjectCompleted_Tag .. capitalContinent, 1)
		end

		local city = CityManager.GetCity(playerId, cityId)
		if city ~= nil then
			-- 获取首都相邻海洋名字
			local capital = player:GetCities():GetCapitalCity();
			if capital ~= nil then
				local seaNameList = {}
				for direction = 0, 5 do
					local adjacentPlot = Map.GetAdjacentPlot(capital:GetX(), capital:GetY(), direction);
					if adjacentPlot then
						local seaName = Utils.GetPlotSeaName(adjacentPlot:GetX(), adjacentPlot:GetY());
						if seaName ~= nil then
							table.insert(seaNameList, seaName)
						end
					end
				end
				-- 获取本城相邻海洋名字
				for direction = 0, 5 do
					local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
					if adjacentPlot then
						local seaName = Utils.GetPlotSeaName(adjacentPlot:GetX(), adjacentPlot:GetY());
						if seaName ~= nil then
							for _, capitalSeaName in ipairs(seaNameList) do
								if seaName == capitalSeaName then
									print('PhoeniciaCityAddedToMap', seaName)
									city:AttachModifierByID('HD_MEDITERRANEAN_COLONIES_CITY_ADD_POP');
									return;
								end
							end
						end
					end
				end
			end
		end
	end
end

	-- UD 送贸易路线
local Cothon_Grant_Trade_Route_Tag = "HD_Cothon_Grant_Trade_Route_Tag"
function PhoeniciaDistrictConstructed(playerId, districtType, x, y)
	if districtType == DISTRICT_COTHON_INDEX then
		-- 获取本格海洋名字
		local seaName = Utils.GetPlotSeaName(x, y);
		print('PhoeniciaDistrictConstructed1', seaName)
		if seaName ~= nil then
			-- 获取首都U港海洋名字
			local player = Players[playerId];
			local capital = player:GetCities():GetCapitalCity();
			local capitalCothon = capital:GetDistricts():GetDistrict(DISTRICT_COTHON_INDEX);
			-- print('PhoeniciaDistrictConstructed2', capitalCothon)
			if capitalCothon ~= nil and capitalCothon:IsComplete() and not capitalCothon:IsPillaged() then
				local capitalCothonSeaName = Utils.GetPlotSeaName(capitalCothon:GetX(), capitalCothon:GetY());
				print('PhoeniciaDistrictConstructed3', capitalCothonSeaName)
				if seaName == capitalCothonSeaName then
					local plot = Map.GetPlot(x, y);
					local city = Cities.GetPlotPurchaseCity(plot);
					if city:GetProperty(Cothon_Grant_Trade_Route_Tag) ~= 1 then
						city:SetProperty(Cothon_Grant_Trade_Route_Tag, 1)
						city:AttachModifierByID('HD_MEDITERRANEAN_COLONIES_ADD_TRADE_ROUTE');
					end
				end
			end
		end
	end
end
GameEvents.OnDistrictConstructed.Add(PhoeniciaDistrictConstructed);

	-- LA 送外交区建筑
function DidoCityProductionChanged(playerId, cityId, productionId, objectId)
	local player = Players[playerId];

	if LeaderHasTrait(playerId, 'TRAIT_LEADER_FOUNDER_CARTHAGE') then
		local city = player:GetCities():FindID(cityId);
		if city ~= nil then
			local current = city:GetBuildQueue():CurrentlyBuilding();
			if current then
				local buildingInfo = GameInfo.Buildings[current];
				local districtInfo = GameInfo.Districts[current];

				if buildingInfo ~= nil then
					if buildingInfo.PrereqDistrict == 'DISTRICT_DIPLOMATIC_QUARTER' then
						city:GetBuildQueue():FinishProgress()
					end
				end

				if districtInfo ~= nil then
					if districtInfo.DistrictType == 'DISTRICT_DIPLOMATIC_QUARTER' then
						city:GetBuildQueue():FinishProgress()
					end
				end
			end
		end
	end
end
Events.CityProductionChanged.Add(DidoCityProductionChanged)

	-- LA 迁都触发特效
local PROJECT_COTHON_CAPITAL_MOVE_INDEX = GameInfo.Projects['PROJECT_COTHON_CAPITAL_MOVE'].Index
function DidoCityProjectCompleted(playerId, cityId, projectId)
	if projectId == PROJECT_COTHON_CAPITAL_MOVE_INDEX then
		-- 获取新首都大陆
		local city = CityManager.GetCity(playerId, cityId)
		local plot = city:GetPlot();
		local newCapitalContinent = plot:GetContinentType();

		local player = Players[playerId];
		if player:GetProperty(DidoCityProjectCompleted_Tag .. newCapitalContinent) ~= 1 then
			player:SetProperty(DidoCityProjectCompleted_Tag .. newCapitalContinent, 1)
			print('DidoCityProjectCompleted', newCapitalContinent)
			-- 边界扩张速度
			player:AttachModifierByID('HD_FOUNDER_CARTHAGE_BORDER_EXPANSION')
			-- 向同大陆所有城邦派遣1使者
			for citystateId, citystatePlayer in ipairs(Players) do
				if (citystatePlayer ~= nil) and (citystatePlayer:GetInfluence() ~= nil) and citystatePlayer:GetInfluence():CanReceiveInfluence() then
					local citystateCapital = citystatePlayer:GetCities():GetCapitalCity();
					if citystateCapital ~= nil then
						local citystateContinent = citystateCapital:GetPlot():GetContinentType();
						if citystateContinent == newCapitalContinent then
							local citystateConfig = PlayerConfigurations[citystateId];
							print('DidoCityProjectCompleted', citystateConfig:GetLeaderTypeName());
							player:GetInfluence():GiveFreeTokenToPlayer(citystateId);
						end
					end
				end
			end
		end
	end
end
Events.CityProjectCompleted.Add(DidoCityProjectCompleted)

-- 阿拉伯
local NOTIFICATION_ARABIA_TRANSFORM_GPP_HASH = GameInfo.Types['NOTIFICATION_ARABIA_TRANSFORM_GPP'].Hash;
function ArabiaPlayerTurnActivated(playerId, isFirstTime)
	local player = Players[playerId];
	if isFirstTime and CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_LAST_PROPHET') then
		if player:GetProperty('HDPlayerHasReligion') == 1 then
			local amount = math.floor(Utils.GetGreatPeoplePointsPerTurn(playerId, PROPHET_INDEX))
			player:GetGreatPeoplePoints():ChangePointsTotal(WRITER_INDEX, amount);
			player:GetGreatPeoplePoints():ChangePointsTotal(ARTIST_INDEX, amount);
			player:GetGreatPeoplePoints():ChangePointsTotal(SCIENTIST_INDEX, amount);

			local msg = ""
			msg = msg .. "+" .. amount .. " [ICON_GreatScientist]" .. ' '
			msg = msg .. "+" .. amount .. " [ICON_GreatWriter]" .. ' '
			msg = msg .. "+" .. amount .. " [ICON_GreatArtist]"
			Utils.SendMergableNotification(playerId, NOTIFICATION_ARABIA_TRANSFORM_GPP_HASH, Locale.Lookup('LOC_TRAIT_CIVILIZATION_LAST_PROPHET_NAME'), msg)
		end
	end
end
Events.PlayerTurnActivated.Add(ArabiaPlayerTurnActivated);

local Arabia_TAG = 'HD_ArabiaTradeRouteAddedToMap';
local LAST_PROPHET_RELIGIOUS_PRESSURE = GlobalParameters.HD_LAST_PROPHET_RELIGIOUS_PRESSURE or 0;
function ArabiaTradeRouteAddedToMap(playerId, x, y)
  if CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_LAST_PROPHET') then
    local city = Cities.GetCityInPlot(x, y)
    city:SetProperty(Arabia_TAG, 1)
  end
end

function ArabiaTradeRouteActivityChanged(playerId, originPlayerId, originCityId, targetPlayerId, targetCityId)
	if CivilizationHasTrait(originPlayerId, 'TRAIT_CIVILIZATION_LAST_PROPHET') then
		local originCity = CityManager.GetCity(originPlayerId, originCityId)
		if originCity and originPlayerId ~= targetPlayerId then
			if originCity:GetProperty(Arabia_TAG) == 1 then
				-- 判断是否是创建商队
				originCity:SetProperty(Arabia_TAG, 0)
		
				-- 获取宗教
				local originPlayer = Players[originPlayerId];
				if originPlayer:GetProperty('HDPlayerHasReligion') ~= 1 then
					return;
				end
				local playerReligion = originPlayer:GetReligion():GetReligionTypeCreated();
				-- 给目标城市施加宗教压力
				local targetCity = CityManager.GetCity(targetPlayerId, targetCityId)
				targetCity:GetReligion():AddReligiousPressure(originPlayerId, playerReligion, LAST_PROPHET_RELIGIOUS_PRESSURE, originPlayerId);
				for row in GameInfo.Religions() do
					if row.Index == playerReligion then
						local religionName = Locale.Lookup(row.Name)
						local message = '[COLOR:White]+' .. tostring(LAST_PROPHET_RELIGIOUS_PRESSURE) .. ' ' .. religionName .. '[ENDCOLOR]'
						local cityLocation = targetCity:GetLocation();
						Game.AddWorldViewText(playerId, message, cityLocation.x, cityLocation.y)
					end
				end
			end
		end
	end
end
Events.TradeRouteActivityChanged.Add(ArabiaTradeRouteActivityChanged)

function ArabiaBeliefAdded(playerId, beliefId)
	if CivilizationHasTrait(playerId, 'TRAIT_CIVILIZATION_LAST_PROPHET') then
    local player = Players[playerId];
		print('ArabiaBeliefAdded')
		player:AttachModifierByID('HD_LAST_PROPHET_CULTURAL_GOVERNMENT_SLOT')
  end
end
Events.BeliefAdded.Add(ArabiaBeliefAdded)

-- 印加
local Pachacuti_2_Tiles_Within_Mountain = 'HD_PACHACUTI_QHAPAQ_NAN_CITY_2_TILES_WITHIN_MOUNTAIN'
local Pachacuti_Governor_Established_Tag = 'HD_PachacutiGovernorEstablished_'
local Pachacuti_Governor_Add = 'HD_PachacutiGovernorAdd_'
function PachacutiGovernorEstablished(cityOwner, cityId, governorOwner, governorId)
	if LeaderHasTrait(governorOwner, 'TRAIT_LEADER_PACHACUTI_QHAPAQ_NAN') then
		-- print('PachacutiGovernorEstablished', cityOwner, cityId, governorOwner, governorId)
		local city = CityManager.GetCity(cityOwner, cityId);
		-- print('PachacutiGovernorEstablished', city:GetProperty(Pachacuti_2_Tiles_Within_Mountain))
		if city:GetProperty(Pachacuti_2_Tiles_Within_Mountain) ~= nil 
			and city:GetProperty(Pachacuti_2_Tiles_Within_Mountain) > 0 then
			local player = Players[governorOwner];
			-- print('PachacutiGovernorEstablished', player:GetProperty(Pachacuti_Governor_Established_Tag .. governorId))
			if player:GetProperty(Pachacuti_Governor_Established_Tag .. governorId) ~= 1 then
				player:SetProperty(Pachacuti_Governor_Established_Tag .. governorId, 1);
				player:AttachModifierByID('HD_PACHACUTI_QHAPAQ_NAN_GOVERNOR');
			end
		end
	end
end
Events.GovernorEstablished.Add(PachacutiGovernorEstablished)

function PachacutiGovernorPromoted(playerId, governorId)
	if LeaderHasTrait(playerId, 'TRAIT_LEADER_PACHACUTI_QHAPAQ_NAN') then
		local player = Players[playerId];
		local amount = player:GetProperty(Pachacuti_Governor_Add .. governorId) or 0
		player:SetProperty(Pachacuti_Governor_Add .. governorId, amount + 1)
		if amount == 3 then
			-- 梯田增产
			local capital = player:GetCities():GetCapitalCity();
			if capital ~= nil then
				print('PachacutiGovernorPromoted', amount + 1)
				for row in GameInfo.Pachacuti_Modifiers_HD() do
					capital:AttachModifierByID(row.ModifierId)
					print('PachacutiGovernorPromoted', row.ModifierId)
				end
			end
		end


-- 		local amount = player:GetProperty(Pachacuti_Governor_Add)
-- 		if amount == nil then
-- 			player:SetProperty(Pachacuti_Governor_Add, 1)
-- 		elseif amount < 3 then
-- 			player:SetProperty(Pachacuti_Governor_Add, amount + 1)
-- 		else
-- 			player:SetProperty(Pachacuti_Governor_Add, 0)
-- 			-- 梯田增产
-- 			local capital = player:GetCities():GetCapitalCity();
-- 			if capital ~= nil then
-- 				for row in GameInfo.Pachacuti_Modifiers_HD() do
-- 					capital:AttachModifierByID(row.ModifierId)
-- 					-- print('PachacutiGovernorAdd', 'HD_PACHACUTI_QHAPAQ_NAN_' .. row.DistrictType .. '_' .. row.YieldType .. '_BONUS')
-- 				end
-- 			end
-- 		end

-- 		-- print('PachacutiGovernorAdd', player:GetProperty(Pachacuti_Governor_Add))
	end
end
Events.GovernorPromoted.Add(PachacutiGovernorPromoted)

--------------------------------------------------------------
-- 金法国
local MapLuxuryResources = {}
function InitMapLuxuryResources()
	for row in GameInfo.Resources() do
		if row.ResourceClassType == 'RESOURCECLASS_LUXURY' and (row.Frequency ~= 0 or row.SeaFrequency ~= 0) then
			table.insert(MapLuxuryResources, row.ResourceType)
		end
	end
end
InitMapLuxuryResources()

local NOTIFICATION_LEADER_MAGNIFICENCES_WONDER_HASH = GameInfo.Types['NOTIFICATION_LEADER_MAGNIFICENCES_WONDER'].Hash;
function MagnificencesWonderCompleted(x, y, buildingId, playerId, cityId, percentComplete, unknown)
  if LeaderHasTrait(playerId, 'TRAIT_LEADER_MAGNIFICENCES') then
		local wonderInfo = GameInfo.Buildings[buildingId]
		if wonderInfo ~= nil and wonderInfo.IsWonder and wonderInfo.MaxWorldInstances ~= -1 then
			local player = Players[playerId];
			local resourceType

			local wonderType = wonderInfo.BuildingType
			local wonderResource = GameInfo.Wonder_Resources_HD[wonderType]
			if wonderResource ~= nil then
				resourceType = wonderResource.ResourceType
			else
				local randomIndex = Game.GetRandNum(#MapLuxuryResources, "Random Luxury from Wonder " .. playerId) + 1
				resourceType = GameInfo.Resources[randomIndex].ResourceType
			end

			if resourceType ~= nil then
				player:AttachModifierByID('HD_GRANT_' .. resourceType)
				player:AttachModifierByID('HD_GRANT_' .. resourceType)
				local wonderName = Locale.Lookup(wonderInfo.Name)
				local resourceName = Locale.Lookup('LOC_' .. resourceType .. '_NAME')
				local msg = wonderName .. ': 2 [ICON_' .. resourceType .. '] ' .. resourceName
				Utils.SendMergableNotification(playerId, NOTIFICATION_LEADER_MAGNIFICENCES_WONDER_HASH, Locale.Lookup('LOC_TRAIT_LEADER_MAGNIFICENCES_NAME'), msg)
			end
		end
	end
end
Events.WonderCompleted.Add(MagnificencesWonderCompleted);

-- 宫廷宴会
local PROJECT_COURT_FESTIVAL_INFO = GameInfo.Projects['PROJECT_COURT_FESTIVAL']
local PROJECT_COURT_FESTIVAL_TAG = 'HD_CITY_ALLOW_EXTRA_IMPROVEMENT_CHATEAU'
function CourtFestivalCityProjectCompleted(playerId, cityId, projectId)
	if PROJECT_COURT_FESTIVAL_INFO ~= nil and projectId == PROJECT_COURT_FESTIVAL_INFO.Index then
		local city = CityManager.GetCity(playerId, cityId);
		local amount = city:GetProperty(PROJECT_COURT_FESTIVAL_TAG) or 0
		city:SetProperty(PROJECT_COURT_FESTIVAL_TAG, amount + 1)
	end
end
Events.CityProjectCompleted.Add(CourtFestivalCityProjectCompleted)

-- 内陆牧场
local OUTBACK_STATION_COPY_RESOURCE = GlobalParameters.HD_OUTBACK_STATION_COPY_RESOURCE or 0;
local OUTBACK_STATION_INFO = GameInfo.Improvements['IMPROVEMENT_OUTBACK_STATION'];
local OUTBACK_STATION_TAG = "HD_OUTBACK_STATION"
local HD_OUTBACK_STATION_IMPORTED_RESOURCE_FLAG = "HD_OUTBACK_STATION_IMPORTED_RESOURCE"

local FEATURE_JNR_SAVANNAH_INFO = GameInfo.Features['FEATURE_JNR_SAVANNAH']
local TERRAIN_GRASS_INDEX = GameInfo.Terrains['TERRAIN_GRASS'].Index
local TERRAIN_GRASS_HILLS_INDEX = GameInfo.Terrains['TERRAIN_GRASS_HILLS'].Index
local TERRAIN_PLAINS_INDEX = GameInfo.Terrains['TERRAIN_PLAINS'].Index
local TERRAIN_PLAINS_HILLS_INDEX = GameInfo.Terrains['TERRAIN_PLAINS_HILLS'].Index
local TERRAIN_DESERT_INDEX = GameInfo.Terrains['TERRAIN_DESERT'].Index
local TERRAIN_DESERT_HILLS_INDEX = GameInfo.Terrains['TERRAIN_DESERT_HILLS'].Index
function OutbackStationImprovementAddedToMap(x, y, improvementId, playerId, resourceId, isPillaged, isWorked)
	if OUTBACK_STATION_COPY_RESOURCE == 1 and OUTBACK_STATION_INFO ~= nil and improvementId == OUTBACK_STATION_INFO.Index then
		local plot = Map.GetPlot(x, y);
		if plot:GetProperty(OUTBACK_STATION_TAG) ~= 1 then
			local player = Players[playerId];
			local resourceList = player:GetProperty(HD_OUTBACK_STATION_IMPORTED_RESOURCE_FLAG) or {};
			local plotList = {};
			-- 记录可生成资源的地块和相邻资源
			for direction = 0, 5 do
				local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
				if adjacentPlot then
					-- 记录可生成资源的地块
					local adjacentResourceId = adjacentPlot:GetResourceType()
					local adjacentDistrictId = adjacentPlot:GetDistrictType()
					local adjacentImprovementId = adjacentPlot:GetImprovementType()
					local adjacentFeatureId = adjacentPlot:GetFeatureType()
					local adjacentTerrainId = adjacentPlot:GetTerrainType()
					if (
						adjacentResourceId == -1 and
						adjacentDistrictId == -1 and
						adjacentImprovementId == -1 and
						(
							(FEATURE_JNR_SAVANNAH_INFO and adjacentFeatureId == FEATURE_JNR_SAVANNAH_INFO.Index) or
							(adjacentFeatureId == -1 and (
								adjacentTerrainId == TERRAIN_GRASS_INDEX or
								adjacentTerrainId == TERRAIN_GRASS_HILLS_INDEX or
								adjacentTerrainId == TERRAIN_PLAINS_INDEX or
								adjacentTerrainId == TERRAIN_PLAINS_HILLS_INDEX or
								adjacentTerrainId == TERRAIN_DESERT_INDEX or
								adjacentTerrainId == TERRAIN_DESERT_HILLS_INDEX
							))
						)
					) then
						table.insert(plotList, adjacentPlot)
					end

					-- 记录牧场资源
					if adjacentResourceId ~= -1 then
						local resource = GameInfo.Resources[adjacentPlot:GetResourceType()]
						for row in GameInfo.Improvement_ValidResources() do
							if row.ResourceType == resource.ResourceType and row.ImprovementType == 'IMPROVEMENT_PASTURE' then
								table.insert(resourceList, resource.Index);
								break;
							end
						end
					end
				end
			end

			if #plotList == 0 then
				print('OutbackStationImprovementAddedToMap 相邻单元格没有合法的位置生成资源')
				return;
			end
			if #resourceList == 0 then
				print('OutbackStationImprovementAddedToMap 没有合法的牧场资源')
				return;
			end

			for _, res in ipairs(resourceList) do
				print(Locale.Lookup(GameInfo.Resources[res].Name))
			end
			-- 随机选择资源
			local randomResourceId = resourceList[Game.GetRandNum(#resourceList, "Random OutbackStation Resource for Player " .. playerId) + 1]
			local randomPlot = plotList[Game.GetRandNum(#plotList, "Random OutbackStation Plot for Player " .. playerId) + 1]
			plot:SetProperty(OUTBACK_STATION_TAG, 1)

			Utils.GenerateResource(randomPlot, randomResourceId)

			local resourceInfo = GameInfo.Resources[randomResourceId]
			local msg = Locale.Lookup('LOC_OUTBACK_STATION_COPY_RESOURCE') .. '[ICON_' .. resourceInfo.ResourceType .. '] ' .. Locale.Lookup(resourceInfo.Name)
			Game.AddWorldViewText(playerId, msg, randomPlot:GetX(), randomPlot:GetY());
		end
	end
end
--------------------------------------------------------------
-- Initialize
function initialize()
	Events.UnitAddedToMap.Add(MaliUnitAddedToMap);
	Events.TradeRouteAddedToMap.Add(ArabiaTradeRouteAddedToMap);
	Events.CityAddedToMap.Add(WuQinConqueredCapital);
	Events.CityAddedToMap.Add(SpainCityAddedToMap);
  Events.CityAddedToMap.Add(PhoeniciaCityAddedToMap);
	Events.CityAddedToMap.Add(SumeriaCreateCity);
	Events.CityAddedToMap.Add(SumeriaGetEnkidu);
	Events.CityAddedToMap.Add(SumeriaEnkiduConqueredCapital);
	Events.ImprovementAddedToMap.Add(TerraceFarmAddedToMap);
	Events.ImprovementAddedToMap.Add(MissionAddedToMap);
	Events.ImprovementAddedToMap.Add(OutbackStationImprovementAddedToMap);
	Events.ImprovementAddedToMap.Add(SumeriaBuildImprovement);
	Events.ImprovementRemovedFromMap.Add(TerraceFarmRemovedFromMap);
	Events.NationalParkAdded.Add(SumeriaNationalParkAdded);
	Events.UnitDamageChanged.Add(SumeriaEnkiduDamageChanged);
end
Events.LoadGameViewStateDone.Add(initialize);