-------------------------------------
--     RandomEvents Adjustments    --
-------------------------------------

-- Forest/Jungle fire provide 1 food when forest/jungle grow back.
update RandomEvent_Yields set Amount = 0 where FeatureType = 'FEATURE_BURNT_JUNGLE' and RandomEventType = 'RANDOM_EVENT_JUNGLE_FIRE';
update RandomEvent_Yields set YieldType = 'YIELD_FOOD' where FeatureType = 'FEATURE_JUNGLE' and RandomEventType = 'RANDOM_EVENT_JUNGLE_FIRE';
update RandomEvent_Yields set Amount = 0 where FeatureType = 'FEATURE_BURNT_FOREST' and RandomEventType = 'RANDOM_EVENT_FOREST_FIRE';
update RandomEvent_Yields set YieldType = 'YIELD_FOOD' where FeatureType = 'FEATURE_FOREST' and RandomEventType = 'RANDOM_EVENT_FOREST_FIRE';

update RandomEvent_Yields set Percentage = Percentage -10
 where RandomEventType = 'RANDOM_EVENT_FLOOD_MODERATE'
	or RandomEventType = 'RANDOM_EVENT_FLOOD_MAJOR'
	or RandomEventType = 'RANDOM_EVENT_FLOOD_1000_YEAR'
	or RandomEventType = 'RANDOM_EVENT_VOLCANO_GENTLE'
	or RandomEventType = 'RANDOM_EVENT_VOLCANO_CATASTROPHIC'
	or RandomEventType = 'RANDOM_EVENT_VOLCANO_MEGACOLOSSAL'
	or RandomEventType = 'RANDOM_EVENT_HURRICANE_CAT_4'
	or RandomEventType = 'RANDOM_EVENT_HURRICANE_CAT_5'
;

update RandomEvent_Yields set Percentage = Percentage -5
 where RandomEventType = 'RANDOM_EVENT_BLIZZARD_SIGNIFICANT'
	or RandomEventType = 'RANDOM_EVENT_BLIZZARD_CRIPPLING'
	or RandomEventType = 'RANDOM_EVENT_DUST_STORM_GRADIENT'
	or RandomEventType = 'RANDOM_EVENT_DUST_STORM_HABOOB'
;
