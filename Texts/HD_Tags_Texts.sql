-- Insert new text tag for replaced texts.

-------------------------------------------------------------------------------- 
-- Techs and Civics

update Technologies set Description = 'LOC_TECH_ANIMAL_HUSBANDRY_HD_DESCRIPTION' where TechnologyType ='TECH_ANIMAL_HUSBANDRY';
update Technologies set Description = 'LOC_TECH_MINING_HD_DESCRIPTION' where TechnologyType ='TECH_MINING';
update Technologies set Description = 'LOC_TECH_MASONRY_HD_DESCRIPTION' where TechnologyType ='TECH_MASONRY';
update Technologies set Description = 'LOC_TECH_SAILING_HD_DESCRIPTION' where TechnologyType ='TECH_SAILING';
-- 
update Technologies set Description = 'LOC_TECH_ARCHERY_HD_DESCRIPTION' where TechnologyType ='TECH_ARCHERY';
update Technologies set Description = 'LOC_TECH_IRRIGATION_DESCRIPTION' where TechnologyType ='TECH_IRRIGATION';
update Technologies set Description = 'LOC_TECH_THE_WHEEL_HD_DESCRIPTION' where TechnologyType = 'TECH_THE_WHEEL';
update Technologies set Description = 'LOC_TECH_CELESTIAL_NAVIGATION_HD_DESCRIPTION' where TechnologyType ='TECH_CELESTIAL_NAVIGATION';
update Technologies set Description = 'LOC_TECH_CONSTRUCTION_HD_DESCRIPTION' where TechnologyType ='TECH_CONSTRUCTION';
update Technologies set Description = 'LOC_TECH_ENGINEERING_HD_DESCRIPTION' where TechnologyType = 'TECH_ENGINEERING';
-- update Technologies set Description = 'LOC_TECH_CURRENCY_HD_DESCRIPTION' where TechnologyType ='TECH_CURRENCY';
update Technologies set Description = 'LOC_TECH_APPRENTICESHIP_HD_DESCRIPTION' where TechnologyType ='TECH_APPRENTICESHIP';
update Technologies set Description = 'LOC_TECH_MACHINERY_HD_DESCRIPTION' where TechnologyType ='TECH_MACHINERY';
update Technologies set Description = 'LOC_TECH_METAL_CASTING_HD_DESCRIPTION' where TechnologyType ='TECH_METAL_CASTING';
update Technologies set Description = 'LOC_TECH_PRINTING_HD_DESCRIPTION' where TechnologyType ='TECH_PRINTING';
update Technologies set Description = NULL where TechnologyType = 'TECH_STIRRUPS';
-- update Technologies set Description = 'LOC_TECH_CASTLES_HD_DESCRIPTION' where TechnologyType = 'TECH_CASTLES';
update Technologies set Description = 'LOC_TECH_ASTRONOMY_HD_DESCRIPTION' where TechnologyType = 'TECH_ASTRONOMY';
update Technologies set Description = 'LOC_TECH_MASS_PRODUCTION_HD_DESCRIPTION' where TechnologyType = 'TECH_MASS_PRODUCTION';
-- update Technologies set Description = 'LOC_TECH_RIFLING_HD_DESCRIPTION' where TechnologyType ='TECH_RIFLING';
update Technologies set Name = 'LOC_TECH_SQUARE_RIGGING_HD_NAME', Description = 'LOC_TECH_SQUARE_RIGGING_HD_DESCRIPTION' where TechnologyType ='TECH_SQUARE_RIGGING';
update Technologies set Description = 'LOC_TECH_STEAM_POWER_HD_DESCRIPTION' where TechnologyType = 'TECH_STEAM_POWER';
update Technologies set Description = 'LOC_TECH_STEEL_HD_DESCRIPTION' where TechnologyType = 'TECH_STEEL';
update Technologies set Description = null where TechnologyType = 'TECH_SCIENTIFIC_THEORY';
update Technologies set Description = null where TechnologyType ='TECH_REPLACEABLE_PARTS';
-- update Technologies set Description = 'LOC_TECH_TELECOMMUNICATIONS_HD_DESCRIPTION' where TechnologyType ='TECH_TELECOMMUNICATIONS';
update Technologies set Description = 'LOC_TECH_CARTOGRAPHY_HD_DESCRIPTION' where TechnologyType ='TECH_CARTOGRAPHY';
update Technologies set Description = null where TechnologyType ='TECH_INDUSTRIALIZATION';
update Technologies set Description = 'LOC_TECH_SYNTHETIC_MATERIALS_HD_DESCRIPTION' where TechnologyType ='TECH_SYNTHETIC_MATERIALS';
update Technologies set Description = 'LOC_TECH_ROBOTICS_HD_DESCRIPTION' where TechnologyType ='TECH_ROBOTICS';
-- update Technologies set Description = 'LOC_TECH_CYBERNETICS_HD_DESCRIPTION' where TechnologyType ='TECH_CYBERNETICS';
-- update Technologies set Description = 'LOC_TECH_SMART_MATERIALS_HD_DESCRIPTION' where TechnologyType ='TECH_SMART_MATERIALS';
update Technologies set Description = 'LOC_TECH_PLASTICS_HD_DESCRIPTION' where TechnologyType ='TECH_PLASTICS';
update Technologies set Description = 'LOC_TECH_MATHEMATICS_HD_DESCRIPTION' where TechnologyType ='TECH_MATHEMATICS';
update Technologies set Description = 'LOC_TECH_COMPOSITES_HD_DESCRIPTION' where TechnologyType ='TECH_COMPOSITES';
update Technologies set Description = 'LOC_TECH_PREDICTIVE_SYSTEMS_HD_DESCRIPTION' where TechnologyType ='TECH_PREDICTIVE_SYSTEMS';
update Technologies set Description = 'LOC_TECH_ADVANCED_FLIGHT_HD_DESCRIPTION' where TechnologyType ='TECH_ADVANCED_FLIGHT';
update Technologies set Description = 'LOC_TECH_COMBUSTION_HD_DESCRIPTION' where TechnologyType ='TECH_COMBUSTION';
update Technologies set Description = 'LOC_TECH_NANOTECHNOLOGY_HD_DESCRIPTION' where TechnologyType ='TECH_NANOTECHNOLOGY';


update Technologies set Description = NULL where TechnologyType ='TECH_ROCKETRY';
-- update Technologies set Description = NULL where TechnologyType ='TECH_APPRENTICESHIP';
update Technologies set Description = null where TechnologyType = 'TECH_HORSEBACK_RIDING'; 
update Technologies set Description = 'LOC_TECH_SANITATION_HD_DESCRIPTION' where TechnologyType = 'TECH_SANITATION';
update Technologies set Description = null where TechnologyType = 'TECH_BUTTRESS';

update Civics set Name = 'LOC_CIVIC_DEFENSIVE_TACTICS_HD_NAME' where CivicType ='CIVIC_DEFENSIVE_TACTICS';
update Civics set Name = 'LOC_CIVIC_NATURAL_HISTORY_HD_NAME' where CivicType ='CIVIC_NATURAL_HISTORY';

update Civics set Description = 'LOC_CIVIC_CRAFTSMANSHIP_HD_DESCRIPTION' where CivicType ='CIVIC_CRAFTSMANSHIP';
-- update Civics set Description = 'LOC_CIVIC_CIVIL_SERVICE_HD_DESCRIPTION' where CivicType ='CIVIC_CIVIL_SERVICE';
update Civics set Description = 'LOC_CIVIC_GUILDS_HD_DESCRIPTION' where CivicType ='CIVIC_GUILDS';
update Civics set Description = 'LOC_CIVIC_MEDIEVAL_FAIRES_HD_DESCRIPTION' where CivicType ='CIVIC_MEDIEVAL_FAIRES';
update Civics set Description = 'LOC_CIVIC_EXPLORATION_HD_DESCRIPTION' where CivicType ='CIVIC_EXPLORATION';
update Civics set Description = NULL where CivicType ='CIVIC_COLONIALISM';
update Civics set Description = 'LOC_CIVIC_FEUDALISM_HD_DESCRIPTION' where CivicType ='CIVIC_FEUDALISM';
update Civics set Description = 'LOC_CIVIC_MERCANTILISM_HD_DESCRIPTION' where CivicType ='CIVIC_MERCANTILISM';
update Civics set Description = 'LOC_CIVIC_NAVAL_TRADITION_HD_DESCRIPTION' where CivicType ='CIVIC_NAVAL_TRADITION';
update Civics set Description = 'LOC_CIVIC_COLONIALISM_HD_DESCRIPTION' where CivicType ='CIVIC_COLONIALISM';
update Civics set Description = 'LOC_CIVIC_NATIONALISM_HD_DESCRIPTION' where CivicType ='CIVIC_NATIONALISM';
update Civics set Description = 'LOC_CIVIC_CIVIL_ENGINEERING_HD_DESCRIPTION' where CivicType ='CIVIC_CIVIL_ENGINEERING';
update Civics set Description = 'LOC_CIVIC_CONSERVATION_HD_DESCRIPTION' where CivicType ='CIVIC_CONSERVATION';
update Civics set Description = 'LOC_CIVIC_GLOBALIZATION_HD_DESCRIPTION' where CivicType ='CIVIC_GLOBALIZATION';
update Civics set Description = 'LOC_CIVIC_ENVIRONMENTALISM_HD_DESCRIPTION' where CivicType ='CIVIC_ENVIRONMENTALISM';
update Civics set Description = NULL where CivicType ='CIVIC_ENVIRONMENTALISM'
	and exists (select DistrictType from Districts where DistrictType = 'DISTRICT_PRESERVE');
update Civics set Description = 'LOC_POLICY_FUTURE_VICTORY_CULTURE_DESCRIPTION' where CivicType ='CIVIC_CULTURAL_HEGEMONY'; --temp

--------------------------------------------------------------------------------
-- Buildings
update Buildings set Description = 'LOC_BUILDING_GRANARY_DESCRIPTION' where BuildingType = 'BUILDING_GRANARY';
update Buildings set Description = 'LOC_BUILDING_UNIVERSITY_DESCRIPTION' where BuildingType = 'BUILDING_UNIVERSITY';
update Buildings set Description = 'LOC_BUILDING_RESEARCH_LAB_DESCRIPTION' where BuildingType = 'BUILDING_RESEARCH_LAB';
update Buildings set Description = 'LOC_BUILDING_LIBRARY_DESCRIPTION' where BuildingType = 'BUILDING_LIBRARY';
-- update Buildings set Description = 'LOC_BUILDING_AMPHITHEATER_DESCRIPTION' where BuildingType = 'BUILDING_AMPHITHEATER';
update Buildings set Description = NULL where BuildingType = 'BUILDING_AMPHITHEATER';
update Buildings set Description = 'LOC_BUILDING_BROADCAST_CENTER_DESCRIPTION' where BuildingType = 'BUILDING_BROADCAST_CENTER';
update Buildings set Description = 'LOC_BUILDING_BANK_DESCRIPTION' where BuildingType = 'BUILDING_BANK';
update Buildings set Description = 'LOC_BUILDING_STOCK_EXCHANGE_DESCRIPTION' where BuildingType = 'BUILDING_STOCK_EXCHANGE';
update Buildings set Description = 'LOC_BUILDING_WORKSHOP_DESCRIPTION' where BuildingType = 'BUILDING_WORKSHOP';
update Buildings set Description = 'LOC_BUILDING_FACTORY_DL_DESCRIPTION' where BuildingType = 'BUILDING_FACTORY';
update Buildings set Description = 'LOC_BUILDING_COAL_POWER_PLANT_DL_DESCRIPTION' where BuildingType = 'BUILDING_COAL_POWER_PLANT';
update Buildings set Description = 'LOC_BUILDING_FOSSIL_FUEL_POWER_PLANT_DL_DESCRIPTION' where BuildingType = 'BUILDING_FOSSIL_FUEL_POWER_PLANT';
update Buildings set Description = 'LOC_BUILDING_POWER_PLANT_DL_DESCRIPTION' where BuildingType = 'BUILDING_POWER_PLANT';
update Buildings set Description = 'LOC_BUILDING_SEWER_DESCRIPTION' where BuildingType = 'BUILDING_SEWER';	

update Buildings set Description = 'LOC_BUILDING_CATHEDRAL_DL_DESCRIPTION' where BuildingType = 'BUILDING_CATHEDRAL';
update Buildings set Description = 'LOC_BUILDING_GURDWARA_DL_DESCRIPTION' where BuildingType = 'BUILDING_GURDWARA';
update Buildings set Description = 'LOC_BUILDING_MEETING_HOUSE_DL_DESCRIPTION' where BuildingType = 'BUILDING_MEETING_HOUSE';
update Buildings set Description = 'LOC_BUILDING_MOSQUE_DL_DESCRIPTION' where BuildingType = 'BUILDING_MOSQUE';
update Buildings set Description = 'LOC_BUILDING_SYNAGOGUE_DL_DESCRIPTION' where BuildingType = 'BUILDING_SYNAGOGUE';
update Buildings set Description = 'LOC_BUILDING_WAT_DL_DESCRIPTION' where BuildingType = 'BUILDING_WAT';
update Buildings set Description = 'LOC_BUILDING_STUPA_DL_DESCRIPTION' where BuildingType = 'BUILDING_STUPA';
update Buildings set Description = 'LOC_BUILDING_DAR_E_MEHR_DL_DESCRIPTION' where BuildingType = 'BUILDING_DAR_E_MEHR';
update Buildings set Name = 'LOC_BUILDING_PAGODA_DL_NAME', Description = 'LOC_BUILDING_PAGODA_DL_DESCRIPTION' where BuildingType = 'BUILDING_PAGODA';

update Buildings set Description = 'LOC_BUILDING_FERRIS_WHEEL_DESCRIPTION_HD' where BuildingType = 'BUILDING_FERRIS_WHEEL';
update Buildings set Description = 'LOC_BUILDING_AQUARIUM_DL_DESCRIPTION' where BuildingType = 'BUILDING_AQUARIUM';
update Buildings set Description = 'LOC_BUILDING_AQUATICS_CENTER_DL_DESCRIPTION' where BuildingType = 'BUILDING_AQUATICS_CENTER';
update Buildings set Description = 'LOC_BUILDING_STADIUM_DL_DESCRIPTION' where BuildingType = 'BUILDING_STADIUM';

update Beliefs set Description = 'LOC_BELIEF_CATHEDRAL_DL_DESCRIPTION' where BeliefType = 'BELIEF_CATHEDRAL';
update Beliefs set Description = 'LOC_BELIEF_GURDWARA_DL_DESCRIPTION' where BeliefType = 'BELIEF_GURDWARA';
update Beliefs set Description = 'LOC_BELIEF_MEETING_HOUSE_DL_DESCRIPTION' where BeliefType = 'BELIEF_MEETING_HOUSE';
update Beliefs set Description = 'LOC_BELIEF_MOSQUE_DL_DESCRIPTION' where BeliefType = 'BELIEF_MOSQUE';
update Beliefs set Name = 'LOC_BELIEF_PAGODA_DL_NAME', Description = 'LOC_BELIEF_PAGODA_DL_DESCRIPTION' where BeliefType = 'BELIEF_PAGODA';
update Beliefs set Description = 'LOC_BELIEF_SYNAGOGUE_DL_DESCRIPTION' where BeliefType = 'BELIEF_SYNAGOGUE';
update Beliefs set Description = 'LOC_BELIEF_WAT_DL_DESCRIPTION' where BeliefType = 'BELIEF_WAT';
update Beliefs set Description = 'LOC_BELIEF_STUPA_DL_DESCRIPTION' where BeliefType = 'BELIEF_STUPA';
update Beliefs set Description = 'LOC_BELIEF_DAR_E_MEHR_DL_DESCRIPTION' where BeliefType = 'BELIEF_DAR_E_MEHR';


--------------------------------------------------------------------------------
-- Basic Improvements
update Improvements set Description = 'LOC_IMPROVEMENT_FARM_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_FARM';
update Improvements set Description = 'LOC_IMPROVEMENT_FISHING_BOATS_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_FISHING_BOATS';
update Improvements set Description = 'LOC_IMPROVEMENT_PASTURE_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_PASTURE';
update Improvements set Description = 'LOC_IMPROVEMENT_CAMP_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_CAMP';
update Improvements set Description = 'LOC_IMPROVEMENT_MINE_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_MINE';
update Improvements set Description = 'LOC_IMPROVEMENT_QUARRY_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_QUARRY';
update Improvements set Description = 'LOC_IMPROVEMENT_PLANTATION_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_PLANTATION';
update Improvements set Description = 'LOC_IMPROVEMENT_LUMBER_MILL_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_LUMBER_MILL';
update Improvements set Description = 'LOC_IMPROVEMENT_FISHERY_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_FISHERY';
update Improvements set Description = 'LOC_IMPROVEMENT_BEACH_RESORT_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_BEACH_RESORT';
update Improvements set Description = 'LOC_IMPROVEMENT_SKI_RESORT_HD_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_SKI_RESORT';
update Improvements set Description = 'LOC_IMPROVEMENT_SKI_RESORT_HD_MONOPOLY_DESCRIPTION' where ImprovementType = 'IMPROVEMENT_SKI_RESORT'
	and exists (select GreatWorkSlotType from GreatWorkSlotTypes where GreatWorkSlotType = 'GREATWORKSLOT_PRODUCT');
-- UI of Majors

-- UI of Minors

--------------------------------------------------------------------------------
-- Districts
update Districts set Description = 'LOC_DISTRICT_HOLY_SITE_HD_DESCRIPTION' where DistrictType = 'DISTRICT_HOLY_SITE';
update Districts set Description = 'LOC_DISTRICT_LAVRA_HD_DESCRIPTION' where DistrictType = 'DISTRICT_LAVRA';
update Districts set Description = 'LOC_DISTRICT_INDUSTRIAL_ZONE_HD_DESCRIPTION' where DistrictType = 'DISTRICT_INDUSTRIAL_ZONE';
update Districts set Description = 'LOC_DISTRICT_HANSA_HD_DESCRIPTION' where DistrictType = 'DISTRICT_HANSA';
update Districts set Description = 'LOC_DISTRICT_OPPIDUM_HD_DESCRIPTION' where DistrictType = 'DISTRICT_OPPIDUM';
update Districts set Description = 'LOC_DISTRICT_HARBOR_HD_DESCRIPTION' where DistrictType = 'DISTRICT_HARBOR';
update Districts set Description = 'LOC_DISTRICT_COTHON_HD_DESCRIPTION' where DistrictType = 'DISTRICT_COTHON';
update Districts set Description = 'LOC_DISTRICT_ROYAL_NAVY_DOCKYARD_HD_DESCRIPTION' where DistrictType = 'DISTRICT_ROYAL_NAVY_DOCKYARD';
update Districts set Description = 'LOC_DISTRICT_ENCAMPMENT_HD_DESCRIPTION' where DistrictType = 'DISTRICT_ENCAMPMENT';
update Districts set Description = 'LOC_DISTRICT_IKANDA_HD_DESCRIPTION' where DistrictType = 'DISTRICT_IKANDA';
update Districts set Description = 'LOC_DISTRICT_THANH_HD_DESCRIPTION' where DistrictType = 'DISTRICT_THANH';
update Districts set Description = 'LOC_DISTRICT_MBANZA_HD_DESCRIPTION' where DistrictType = 'DISTRICT_MBANZA';
update Districts set Description = 'LOC_DISTRICT_AERODROME_HD_DESCRIPTION' where DistrictType = 'DISTRICT_AERODROME';
update Districts set Description = 'LOC_DISTRICT_DIPLOMATIC_QUARTER_HD_DESCRIPTION' where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER';
update Districts set Description = 'LOC_DISTRICT_GOVERNMENT_HD_DESCRIPTION' where DistrictType = 'DISTRICT_GOVERNMENT';
update Districts set Description = 'LOC_DISTRICT_ACROPOLIS_HD_DESCRIPTION' where DistrictType = 'DISTRICT_ACROPOLIS';
update Districts set Description = 'LOC_DISTRICT_PRESERVE_HD_DESCRIPTION' where DistrictType = 'DISTRICT_PRESERVE';
update Districts set Description = 'LOC_DISTRICT_ENTERTAINMENT_COMPLEX_HD_DESCRIPTION' where DistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX';
update Districts set Description = 'LOC_DISTRICT_WATER_ENTERTAINMENT_COMPLEX_HD_DESCRIPTION' where DistrictType = 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX';
update Districts set Description = 'LOC_DISTRICT_WATER_STREET_CARNIVAL_HD_DESCRIPTION' where DistrictType = 'DISTRICT_WATER_STREET_CARNIVAL';
update Districts set Description = 'LOC_DISTRICT_STREET_CARNIVAL_HD_DESCRIPTION' where DistrictType = 'DISTRICT_STREET_CARNIVAL';
update Districts set Description = 'LOC_DISTRICT_HIPPODROME_HD_DESCRIPTION' where DistrictType = 'DISTRICT_HIPPODROME';
update Districts set Description = 'LOC_DISTRICT_COMMERCIAL_HUB_HD_DESCRIPTION' where DistrictType = 'DISTRICT_COMMERCIAL_HUB';
update Districts set Description = 'LOC_DISTRICT_SUGUBA_HD_DESCRIPTION' where DistrictType = 'DISTRICT_SUGUBA';
update Districts set Description = 'LOC_DISTRICT_CANAL_HD_DESCRIPTION' where DistrictType = 'DISTRICT_CANAL';
update Districts set Description = 'LOC_DISTRICT_DAM_HD_DESCRIPTION' where DistrictType = 'DISTRICT_DAM';
update Districts set Description = 'LOC_DISTRICT_SEOWON_HD_DESCRIPTION' where DistrictType = 'DISTRICT_SEOWON';
update Districts set Description = 'LOC_DISTRICT_OBSERVATORY_HD_DESCRIPTION' where DistrictType = 'DISTRICT_OBSERVATORY';
update Districts set Description = 'LOC_DISTRICT_THEATER_HD_DESCRIPTION' where DistrictType = 'DISTRICT_THEATER';


--------------------------------------------------------------------------------
-- GreatWorks Theming
update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_GLOBE_THEATRE' where BuildingType = 'BUILDING_GLOBE_THEATRE';
update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_OXFORD_UNIVERSITY' where BuildingType = 'BUILDING_OXFORD_UNIVERSITY';

update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_HERMITAGE' where BuildingType = 'BUILDING_HERMITAGE';
update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_SYDNEY_OPERA_HOUSE' where BuildingType = 'BUILDING_SYDNEY_OPERA_HOUSE';
-- update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_APADANA' where BuildingType = 'BUILDING_APADANA';
-- update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_GREAT_LIBRARY' where BuildingType = 'BUILDING_GREAT_LIBRARY';
update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_HERMITAGE' where BuildingType = 'BUILDING_HERMITAGE';
update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_SYDNEY_OPERA_HOUSE' where BuildingType = 'BUILDING_SYDNEY_OPERA_HOUSE';
update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_GOV_CULTURE' where BuildingType = 'BUILDING_GOV_CULTURE';
update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_NEUSCHWANSTEIN' where BuildingType = 'BUILDING_NEUSCHWANSTEIN';
update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_UFFIZI' where BuildingType = 'BUILDING_UFFIZI';
update Building_GreatWorks set ThemingBonusDescription = 'LOC_BUILDING_THEMINGBONUS_DL_STPETERSBASILICA' where BuildingType = 'BUILDING_AL_STPETERSBASILICA';

--------------------------------------------------------------------------------
-- Policies
update Policies set Description = 'LOC_POLICY_RAID_DL_DESCRIPTION' where PolicyType = 'POLICY_RAID';
update Policies set Description = 'LOC_POLICY_TOTAL_WAR_DL_DESCRIPTION' where PolicyType = 'POLICY_TOTAL_WAR';
update Policies set Description = 'LOC_POLICY_EQUESTRIAN_ORDERS_DL_DESCRIPTION' where PolicyType = 'POLICY_EQUESTRIAN_ORDERS';
update Policies set Description = 'LOC_POLICY_DRILL_MANUALS_DL_DESCRIPTION' where PolicyType = 'POLICY_DRILL_MANUALS';
update Policies set Description = 'LOC_POLICY_RESOURCE_MANAGEMENT_DL_DESCRIPTION' where PolicyType = 'POLICY_RESOURCE_MANAGEMENT';
update Policies set Description = 'LOC_POLICY_SIMULTANEUM_DL_DESCRIPTION' where PolicyType = 'POLICY_SIMULTANEUM';

update Policies set Description = 'LOC_POLICY_SCIENCE_FOUNDATIONS_DL_DESCRIPTION' where PolicyType = 'POLICY_NOBEL_PRIZE';

-- Military
update Policies set Description = 'LOC_POLICY_AGOGE_HD_DESCRIPTION' where PolicyType = 'POLICY_AGOGE';
update Policies set Description = 'LOC_POLICY_FEUDAL_CONTRACT_HD_DESCRIPTION' where PolicyType = 'POLICY_FEUDAL_CONTRACT';
update Policies set Description = 'LOC_POLICY_GRANDE_ARMEE_HD_DESCRIPTION' where PolicyType = 'POLICY_GRANDE_ARMEE';
update Policies set Description = 'LOC_POLICY_MILITARY_FIRST_HD_DESCRIPTION' where PolicyType = 'POLICY_MILITARY_FIRST';

update Policies set Description = 'LOC_POLICY_MARITIME_INDUSTRIES_HD_DESCRIPTION' where PolicyType = 'POLICY_MARITIME_INDUSTRIES';
update Policies set Description = 'LOC_POLICY_PRESS_GANGS_HD_DESCRIPTION' where PolicyType = 'POLICY_PRESS_GANGS';
update Policies set Description = 'LOC_POLICY_INTERNATIONAL_WATERS_HD_DESCRIPTION' where PolicyType = 'POLICY_INTERNATIONAL_WATERS';

update Policies set Description = 'LOC_POLICY_LIGHTNING_WARFARE_HD_DESCRIPTION' where PolicyType = 'POLICY_LIGHTNING_WARFARE';

--------------------------------------------------------------------------------
-- Units
update Units set Description = 'LOC_UNIT_BUILDER_DL_DESCRIPTION' where UnitType = 'UNIT_BUILDER';
/*
-- City Names
update CivilizationLeaders set CapitalName = 'LOC_CITY_XIANYANG' where CivilizationType = 'CIVILIZATION_CHINA' and LeaderType = 'LEADER_QIN';
update CivilizationLeaders set CapitalName = 'LOC_CITY_DADU' where CivilizationType = 'CIVILIZATION_CHINA' and LeaderType = 'LEADER_KUBLAI_KHAN_CHINA';
delete from CityNames where CivilizationType = 'CIVILIZATION_CHINA';
insert or replace into CityNames
	(ID,	CivilizationType,		CityName)
values
	(108,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_HANDAN'),
	(109,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_LUOYANG'),
	(110,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_CHANGAN'),
	(111,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_JINLING'),
	(112,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_BA'),
	(113,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_YING'),
	(114,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_SHOUCHUN'),
	(115,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_CHENGDU'),
	(116,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_CHANGSHA'),
	(117,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_KUAIJI'),
	(118,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_GUANGLING'),
	(119,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_PANYU'),
	(120,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_YE'),
	(121,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_YANGDI'),
	(122,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_LANGYA'),
	(123,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_SHANGCAI'),
	(124,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_JYULU'),
	(125,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_YUNZHONG'),
	(126,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_YINGCHUAN'),
	(127,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_JIMO'),
	(128,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_LIAOYANG'),
	(129,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_GUSU'),
	(130,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_SHANGDANG'),
	(131,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_DALIANG'),
	(132,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_TAIYUAN'),
	(133,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_LINZI'),
	(134,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_LANLING'),
	(135,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_PUYANG'),
	(136,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_YEWANG'),
	(137,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_XINZHENG'),
	(138,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_PENGCHENG'),
	(139,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_WAN'),
	(140,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_XIANGYANG'),
	(141,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_HUAIYIN'),
	(142,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_ZHAOGE'),
	(143,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_QUFU'),
	(144,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_JIANGLING'),
	(145,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_PINGYAO'),
	(146,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_YUHANG'),
	(147,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_FENG'),
	(148,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_PEI'),
	(149,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_JI'),
	(150,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_BEIPING'),
	(151,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_SONGJIANG'),
	(152,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_CANGWU'),
	(153,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_GUILIN'),
	(154,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_GUZANG'),
	(155,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_ZHANGYE'),
	(156,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_DUNHUANG'),
	(157,	'CIVILIZATION_CHINA',	'LOC_CITY_NAME_JIUQUAN');

delete from NamedDesertCivilizations where CivilizationType = 'CIVILIZATION_CHINA';
insert or replace into NamedDesertCivilizations
	(NamedDesertType,				CivilizationType)
values
	('NAMED_DESERT_GOBI',			'CIVILIZATION_CHINA'),
	('NAMED_DESERT_TAKLAMAKAN',		'CIVILIZATION_CHINA');
insert or ignore into NamedDeserts
	(NamedDesertType,				Name)
values
	('NAMED_DESERT_GOBI',			'LOC_NAMED_DESERT_GOBI_NAME'),
	('NAMED_DESERT_TAKLAMAKAN',		'LOC_NAMED_DESERT_TAKLAMAKAN_NAME');

delete from NamedLakeCivilizations where CivilizationType = 'CIVILIZATION_CHINA';
insert or replace into NamedLakeCivilizations
	(NamedLakeType,					CivilizationType)
values
	('NAMED_LAKE_CHAO_LAKE',		'CIVILIZATION_CHINA'),
	('NAMED_LAKE_DONGTING_LAKE',	'CIVILIZATION_CHINA'),
	('NAMED_LAKE_HONGZE_LAKE',		'CIVILIZATION_CHINA'),
	('NAMED_LAKE_HULUN_LAKE',		'CIVILIZATION_CHINA'),
	('NAMED_LAKE_LAKE_KHANKA',		'CIVILIZATION_CHINA'),
	('NAMED_LAKE_LAKE_TAI',			'CIVILIZATION_CHINA'),
	('NAMED_LAKE_POYANG_LAKE',		'CIVILIZATION_CHINA'),
	('NAMED_LAKE_QINGHAI_LAKE',		'CIVILIZATION_CHINA'),
	('NAMED_LAKE_WEST_LAKE',		'CIVILIZATION_CHINA');
insert or ignore into NamedLakes
	(NamedLakeType,					Name)
values
	('NAMED_LAKE_CHAO_LAKE',		'LOC_NAMED_LAKE_CHAO_LAKE_NAME'),
	('NAMED_LAKE_DONGTING_LAKE',	'LOC_NAMED_LAKE_DONGTING_LAKE_NAME'),
	('NAMED_LAKE_HONGZE_LAKE',		'LOC_NAMED_LAKE_HONGZE_LAKE_NAME'),
	('NAMED_LAKE_HULUN_LAKE',		'LOC_NAMED_LAKE_HULUN_LAKE_NAME'),
	('NAMED_LAKE_LAKE_KHANKA',		'LOC_NAMED_LAKE_LAKE_KHANKA_NAME'),
	('NAMED_LAKE_LAKE_TAI',			'LOC_NAMED_LAKE_LAKE_TAI_NAME'),
	('NAMED_LAKE_POYANG_LAKE',		'LOC_NAMED_LAKE_POYANG_LAKE_NAME'),
	('NAMED_LAKE_QINGHAI_LAKE',		'LOC_NAMED_LAKE_QINGHAI_LAKE_NAME'),
	('NAMED_LAKE_WEST_LAKE',		'LOC_NAMED_LAKE_WEST_LAKE_NAME');

delete from NamedMountainCivilizations where CivilizationType = 'CIVILIZATION_CHINA';
insert or replace into NamedMountainCivilizations
	(NamedMountainType,				CivilizationType)
values
	('NAMED_MOUNTAIN_HENGDUAN',		'CIVILIZATION_CHINA'),
	('NAMED_MOUNTAIN_HIMALAYAS',	'CIVILIZATION_CHINA'),
	('NAMED_MOUNTAIN_HINDU_KUSH',	'CIVILIZATION_CHINA'),
	('NAMED_MOUNTAIN_KARAKORAM',	'CIVILIZATION_CHINA'),
	('NAMED_MOUNTAIN_KHINGAN',		'CIVILIZATION_CHINA'),
	('NAMED_MOUNTAIN_KUNLUN',		'CIVILIZATION_CHINA'),
	('NAMED_MOUNTAIN_PAMIRS',		'CIVILIZATION_CHINA'),
	('NAMED_MOUNTAIN_QINLING',		'CIVILIZATION_CHINA'),
	('NAMED_MOUNTAIN_TIEN_SHAN',	'CIVILIZATION_CHINA');
insert or ignore into NamedMountains
	(NamedMountainType,				Name)
values
	('NAMED_MOUNTAIN_HENGDUAN',		'LOC_NAMED_MOUNTAIN_HENGDUAN_NAME'),
	('NAMED_MOUNTAIN_HIMALAYAS',	'LOC_NAMED_MOUNTAIN_HIMALAYAS_NAME'),
	('NAMED_MOUNTAIN_HINDU_KUSH',	'LOC_NAMED_MOUNTAIN_HINDU_KUSH_NAME'),
	('NAMED_MOUNTAIN_KARAKORAM',	'LOC_NAMED_MOUNTAIN_KARAKORAM_NAME'),
	('NAMED_MOUNTAIN_KHINGAN',		'LOC_NAMED_MOUNTAIN_KHINGAN_NAME'),
	('NAMED_MOUNTAIN_KUNLUN',		'LOC_NAMED_MOUNTAIN_KUNLUN_NAME'),
	('NAMED_MOUNTAIN_PAMIRS',		'LOC_NAMED_MOUNTAIN_PAMIRS_NAME'),
	('NAMED_MOUNTAIN_QINLING',		'LOC_NAMED_MOUNTAIN_QINLING_NAME'),
	('NAMED_MOUNTAIN_TIEN_SHAN',	'LOC_NAMED_MOUNTAIN_TIEN_SHAN_NAME');

delete from NamedRiverCivilizations where CivilizationType = 'CIVILIZATION_CHINA';
insert or replace into NamedRiverCivilizations
	(NamedRiverType,				CivilizationType)
values
	('NAMED_RIVER_AMUR',			'CIVILIZATION_CHINA'),
	('NAMED_RIVER_HAI',				'CIVILIZATION_CHINA'),
	('NAMED_RIVER_PEARL',			'CIVILIZATION_CHINA'),
	('NAMED_RIVER_SALWEEN',			'CIVILIZATION_CHINA'),
	('NAMED_RIVER_SONGHUA_RIVER',	'CIVILIZATION_CHINA'),
	('NAMED_RIVER_TARIM',			'CIVILIZATION_CHINA'),
	('NAMED_RIVER_WEI',				'CIVILIZATION_CHINA'),
	('NAMED_RIVER_YANGTZE',			'CIVILIZATION_CHINA'),
	('NAMED_RIVER_YELLOW',			'CIVILIZATION_CHINA'),
	('NAMED_RIVER_XIANGJIANG',		'CIVILIZATION_CHINA'),
	('NAMED_RIVER_JISHUI',			'CIVILIZATION_CHINA'),
	('NAMED_RIVER_SISHUI',			'CIVILIZATION_CHINA');
insert or ignore into NamedRivers
	(NamedRiverType,				Name)
values
	('NAMED_RIVER_AMUR',			'LOC_NAMED_RIVER_AMUR_NAME'),
	('NAMED_RIVER_HAI',				'LOC_NAMED_RIVER_HAI_NAME'),
	('NAMED_RIVER_PEARL',			'LOC_NAMED_RIVER_PEARL_NAME'),
	('NAMED_RIVER_SALWEEN',			'LOC_NAMED_RIVER_SALWEEN_NAME'),
	('NAMED_RIVER_SONGHUA_RIVER',	'LOC_NAMED_RIVER_SONGHUA_RIVER_NAME'),
	('NAMED_RIVER_TARIM',			'LOC_NAMED_RIVER_TARIM_NAME'),
	('NAMED_RIVER_WEI',				'LOC_NAMED_RIVER_WEI_NAME'),
	('NAMED_RIVER_YANGTZE',			'LOC_NAMED_RIVER_YANGTZE_NAME'),
	('NAMED_RIVER_YELLOW',			'LOC_NAMED_RIVER_YELLOW_NAME'),
	('NAMED_RIVER_XIANGJIANG',		'LOC_NAMED_RIVER_XIANGJIANG_NAME'),
	('NAMED_RIVER_JISHUI',			'LOC_NAMED_RIVER_JISHUI_NAME'),
	('NAMED_RIVER_SISHUI',			'LOC_NAMED_RIVER_SISHUI_NAME');
	
delete from NamedSeaCivilizations where CivilizationType = 'CIVILIZATION_CHINA';
insert or replace into NamedSeaCivilizations
	(NamedSeaType,					CivilizationType)
values
	('NAMED_SEA_BO_HAI',			'CIVILIZATION_CHINA'),
	('NAMED_SEA_EAST_CHINA_SEA',	'CIVILIZATION_CHINA'),
	('NAMED_SEA_GULF_OF_TONKIN',	'CIVILIZATION_CHINA'),
	('NAMED_SEA_SOUTH_CHINA_SEA',	'CIVILIZATION_CHINA'),
	('NAMED_SEA_YELLOW_SEA',		'CIVILIZATION_CHINA');
insert or ignore into NamedSeas
	(NamedSeaType,					Name)
values
	('NAMED_SEA_BO_HAI',			'LOC_NAMED_SEA_BO_HAI_NAME'),
	('NAMED_SEA_EAST_CHINA_SEA',	'LOC_NAMED_SEA_EAST_CHINA_SEA_NAME'),
	('NAMED_SEA_GULF_OF_TONKIN',	'LOC_NAMED_SEA_GULF_OF_TONKIN_NAME'),
	('NAMED_SEA_SOUTH_CHINA_SEA',	'LOC_NAMED_SEA_SOUTH_CHINA_SEA_NAME'),
	('NAMED_SEA_YELLOW_SEA',		'LOC_NAMED_SEA_YELLOW_SEA_NAME');
	
delete from NamedVolcanoCivilizations where CivilizationType = 'CIVILIZATION_CHINA';
insert or replace into NamedVolcanoCivilizations
	(NamedVolcanoType,				CivilizationType)
values
	('NAMED_VOLCANO_PAEKTU',		'CIVILIZATION_CHINA');
insert or ignore into NamedVolcanoes
	(NamedVolcanoType,				Name)
values
	('NAMED_VOLCANO_PAEKTU',		'LOC_NAMED_VOLCANO_PAEKTU_NAME');
*/
