-- Insert new text tag for replaced texts.

-- Early ones may be overwrite

update Districts set Description = 'LOC_DISTRICT_AQUEDUCT_HD_DESCRIPTION' where DistrictType = 'DISTRICT_AQUEDUCT';
update Districts set Description = 'LOC_DISTRICT_BATH_HD_DESCRIPTION' where DistrictType = 'DISTRICT_BATH';