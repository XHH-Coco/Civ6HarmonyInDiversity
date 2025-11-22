-------------------------------------
-- Remove the Game Cost Escalation --
-------------------------------------

update GlobalParameters set Value = 100 where Name = 'GAME_COST_ESCALATION';

-- Harvest & chopping
update Resource_Harvests set Amount = 40 where YieldType = 'YIELD_FOOD';
update Resource_Harvests set Amount = 40 where YieldType = 'YIELD_PRODUCTION';
update Resource_Harvests set Amount = 80 where YieldType = 'YIELD_GOLD';
update Feature_Removes set Yield = 30 where FeatureType = 'FEATURE_FOREST';
update Feature_Removes set Yield = 30 where FeatureType = 'FEATURE_MARSH';
update Feature_Removes set Yield = 15 where FeatureType = 'FEATURE_JUNGLE' and YieldType = 'YIELD_FOOD';
update Feature_Removes set Yield = 15 where FeatureType = 'FEATURE_JUNGLE' and YieldType = 'YIELD_PRODUCTION';
-- Suk ocean
update Feature_Removes set Yield = 30 where FeatureType = 'FEATURE_SUK_KELP';
-- Districts

-- progression with number of previous copies

-- update cost progression model and cost
-- specialized districts 
update Districts set CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1 = 15, Cost = 75 
 where DistrictType = 'DISTRICT_HOLY_SITE'				--圣地
	or DistrictType = 'DISTRICT_CAMPUS'					--学院
	or DistrictType = 'DISTRICT_ENCAMPMENT'				--军营
	or DistrictType = 'DISTRICT_COMMERCIAL_HUB'			--商业
	-- or DistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX'	--娱乐
	or DistrictType = 'DISTRICT_THEATER'				--剧院
	or DistrictType = 'DISTRICT_INDUSTRIAL_ZONE'		--工业
	-- or DistrictType = 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX' --水上娱乐
;

update Districts set CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1 = 12, Cost = 60 
 where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER';

-- unique districts
update Districts set CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1 = 12, Cost = 60 where DistrictType in 
(select CivUniqueDistrictType from DistrictReplaces where
	ReplacesDistrictType = 'DISTRICT_HOLY_SITE'					--圣地
	or ReplacesDistrictType = 'DISTRICT_CAMPUS'					--学院
	or ReplacesDistrictType = 'DISTRICT_ENCAMPMENT'				--军营
	or ReplacesDistrictType = 'DISTRICT_COMMERCIAL_HUB'			--商业
	-- or ReplacesDistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX'	--娱乐
	or ReplacesDistrictType = 'DISTRICT_THEATER'				--剧院
	or ReplacesDistrictType = 'DISTRICT_INDUSTRIAL_ZONE'		--工业
	-- or ReplacesDistrictType = 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX' --水上娱乐
);

--normal districts
update Districts set CostProgressionModel = 'NO_COST_PROGRESSION', CostProgressionParam1 = 0
 where DistrictType = 'DISTRICT_GOVERNMENT'				--政府区
	-- or DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER'		--外交区
	or DistrictType = 'DISTRICT_AERODROME'				--空港
	or DistrictType = 'DISTRICT_HARBOR'					--港口
	or DistrictType = 'DISTRICT_AQUEDUCT'				--水渠
	or DistrictType = 'DISTRICT_NEIGHBORHOOD'			--社区
	or DistrictType = 'DISTRICT_CANAL'					--运河
	or DistrictType = 'DISTRICT_DAM'					--大坝
	or DistrictType = 'DISTRICT_THANH'					--城池（越南）
	or DistrictType = 'DISTRICT_PRESERVE'				--保护区
	or DistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX'	--娱乐
	or DistrictType = 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX' --水上娱乐
;

update Districts set Cost = 60 where DistrictType = 'DISTRICT_GOVERNMENT';
-- update Districts set Cost = 60 where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER';
update Districts set Cost = 75 where DistrictType = 'DISTRICT_HARBOR';
update Districts set Cost = 90 where DistrictType = 'DISTRICT_AQUEDUCT';
update Districts set CostProgressionModel = 'NO_COST_PROGRESSION', CostProgressionParam1 = 0, Cost = 60 where DistrictType in 
(select CivUniqueDistrictType from DistrictReplaces where
	ReplacesDistrictType = 'DISTRICT_AQUEDUCT'
	or ReplacesDistrictType = 'DISTRICT_HARBOR'
	or ReplacesDistrictType = 'DISTRICT_PRESERVE'
	or ReplacesDistrictType = 'DISTRICT_GOVERNMENT'
	-- or ReplacesDistrictType = 'DISTRICT_DIPLOMATIC_QUARTER'
	or ReplacesDistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX'	--娱乐
	or ReplacesDistrictType = 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX' --水上娱乐
);

update Districts set CostProgressionModel = 'NO_COST_PROGRESSION', CostProgressionParam1 = 0, Cost = 75 where DistrictType in 
(select CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_NEIGHBORHOOD');

update Districts set Cost = 60 where DistrictType = 'DISTRICT_THANH';
update Districts set Cost = 75 where DistrictType = 'DISTRICT_NEIGHBORHOOD';
update Districts set Cost = 150 where DistrictType = 'DISTRICT_AERODROME';
update Districts set Cost = 200 where DistrictType = 'DISTRICT_CANAL';
update Districts set Cost = 200 where DistrictType = 'DISTRICT_DAM';
