-- Insert new text tag for replaced texts.

--------------------------------------------------------------------------------
-- Major Civs

update PlayerItems set Description = 'LOC_DISTRICT_BATH_HD_DESCRIPTION'
    where Type = 'DISTRICT_BATH' and Domain = 'Players:Expansion2_Players';