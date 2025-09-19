-------------------------------------
--      Goodyhuts Adjustments      --
-------------------------------------

update GoodyHutSubTypes set Turn = 30 where SubTypeGoodyHut = 'GOODYHUT_ONE_RELIC';
update GoodyHutSubTypes set Turn = 15 where SubTypeGoodyHut = 'GOODYHUT_GRANT_BUILDER';
update GoodyHutSubTypes set Turn = 50 where SubTypeGoodyHut = 'GOODYHUT_GOVERNOR_TITLE';
update GoodyHutSubTypes set Turn = 50 where SubTypeGoodyHut = 'GOODYHUT_FAVOR';

update GoodyHutSubTypes set Weight = 60 where SubTypeGoodyHut = 'GOODYHUT_LARGE_GOLD';
update GoodyHutSubTypes set Weight = 30 where SubTypeGoodyHut = 'GOODYHUT_MEDIUM_GOLD';
update GoodyHutSubTypes set Weight = 10 where SubTypeGoodyHut = 'GOODYHUT_SMALL_GOLD';

update GoodyHutSubTypes set Weight = 60 where SubTypeGoodyHut = 'GOODYHUT_LARGE_FAITH';
update GoodyHutSubTypes set Weight = 30 where SubTypeGoodyHut = 'GOODYHUT_MEDIUM_FAITH';
update GoodyHutSubTypes set Weight = 10 where SubTypeGoodyHut = 'GOODYHUT_SMALL_FAITH';

-- TODO: grant random tech by era
update GoodyHutSubTypes set Weight = 0 where SubTypeGoodyHut = 'GOODYHUT_ONE_TECH';
update GoodyHutSubTypes set Weight = 30 where SubTypeGoodyHut = 'GOODYHUT_TWO_TECH_BOOSTS';
update GoodyHutSubTypes set Weight = 70 where SubTypeGoodyHut = 'GOODYHUT_ONE_TECH_BOOST';

update GoodyHutSubTypes set Weight = 35 where SubTypeGoodyHut = 'GOODYHUT_GRANT_SCOUT';
update GoodyHutSubTypes set Weight = 0 where SubTypeGoodyHut = 'GOODYHUT_GRANT_UPGRADE';
update GoodyHutSubTypes set Weight = 20, Turn = 15 where SubTypeGoodyHut = 'GOODYHUT_GRANT_EXPERIENCE';
update GoodyHutSubTypes set Weight = 0, Turn = 15 where SubTypeGoodyHut = 'GOODYHUT_HEAL';
update GoodyHutSubTypes set Weight = 35 where SubTypeGoodyHut = 'GOODYHUT_RESOURCES';

-- TODO: Grant Settler for difficulty 1.
