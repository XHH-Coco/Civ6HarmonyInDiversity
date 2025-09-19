-------------------------------------
--     Adaptation for the Mod      --
-------------------------------------

update Projects set
    Cost = 30, CostProgressionModel = 'NO_PROGRESSION_MODEL', CostProgressionParam1 = 0,
    Description = 'LOC_REMOVE_DISTRICT_PROJECT_DESCRIPTION'
where ProjectType like 'PROJECT_REMOVE_DISTRICT_%';

delete from Projects where ProjectType = 'PROJECT_REMOVE_DISTRICT_CANAL' and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_CANAL');
delete from Types where Type = 'PROJECT_REMOVE_DISTRICT_CANAL' and exists (select BuildingType from Buildings where BuildingType = 'BUILDING_CANAL');