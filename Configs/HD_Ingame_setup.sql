-------------------------------------
--        Ingame Configs           --
-------------------------------------

CREATE TABLE IF NOT EXISTS CSE_ClassTypes
    (
    Type                TEXT    NOT NULL, 
    LeaderType          TEXT    DEFAULT NULL, 
    TypeName            TEXT    DEFAULT NULL, 
    SmallBonus          TEXT    DEFAULT NULL, 
    MediumBonus         TEXT    DEFAULT NULL, 
    LargeBonus          TEXT    DEFAULT NULL, 
    LargestBonus        TEXT    DEFAULT NULL,
    TraitType           TEXT    DEFAULT NULL,
    TraitDescription    TEXT    DEFAULT NULL,
    MinorCivBonus       TEXT    DEFAULT NULL,
    BonusIcon           TEXT    DEFAULT NULL, 
    TypeIcon            TEXT    DEFAULT NULL, 
    Color               TEXT    DEFAULT NULL,
    ColorRef            TEXT    DEFAULT NULL,
    New                 INTEGER DEFAULT 1
    );

-----------------------------------------------
-- CSE_ClassTypes
-----------------------------------------------

insert or ignore into CSE_ClassTypes
        (Type,                  New,    Color,              BonusIcon,                              TypeIcon,                           TraitType,                              TraitDescription                            )
values  ('SCIENTIFIC',          0,      '50,202,237,255',   'ICON_ENVOY_BONUS_SCIENCE',             'ICON_CITYSTATE_SCIENCE',           'MINOR_CIV_SCIENTIFIC_TRAIT',           'LOC_CSE_SCIENTIFIC_TRAIT_DESCRIPTION'      ),
        ('RELIGIOUS',           0,      '255,246,235,255',  'ICON_ENVOY_BONUS_FAITH',               'ICON_CITYSTATE_FAITH',             'MINOR_CIV_RELIGIOUS_TRAIT',            'LOC_CSE_RELIGIOUS_TRAIT_DESCRIPTION'       ),
        ('TRADE',               0,      '255,206,108,255',  'ICON_ENVOY_BONUS_GOLD',                'ICON_CITYSTATE_TRADE',             'MINOR_CIV_TRADE_TRAIT',                'LOC_CSE_TRADE_TRAIT_DESCRIPTION'           ),
        ('CULTURAL',            0,      '214,102,255,255',  'ICON_ENVOY_BONUS_CULTURE',             'ICON_CITYSTATE_CULTURE',           'MINOR_CIV_CULTURAL_TRAIT',             'LOC_CSE_CULTURAL_TRAIT_DESCRIPTION'        ),
        ('MILITARISTIC',        0,      '255,92,92,255',    'ICON_ENVOY_BONUS_MILITARISTIC',        'ICON_CITYSTATE_MILITARISTIC',      'MINOR_CIV_MILITARISTIC_TRAIT',         'LOC_CSE_MILITARISTIC_TRAIT_DESCRIPTION'    ),
        ('INDUSTRIAL',          0,      '255,149,77,255',   'ICON_ENVOY_BONUS_INDUSTRIAL',          'ICON_CITYSTATE_INDUSTRIAL',        'MINOR_CIV_INDUSTRIAL_TRAIT',           'LOC_CSE_INDUSTRIAL_TRAIT_DESCRIPTION'      );

UPDATE  CSE_ClassTypes
SET     TypeName = 'LOC_CITY_STATES_TYPE_'||Type,
        LeaderType = 'LEADER_MINOR_CIV_'||Type,
        SmallBonus = 'LOC_CSE_'||Type||'_TRAIT_SMALL_INFLUENCE_BONUS',
        MediumBonus = 'LOC_CSE_'||Type||'_TRAIT_MEDIUM_INFLUENCE_BONUS',
        LargeBonus = 'LOC_CSE_'||Type||'_TRAIT_LARGE_INFLUENCE_BONUS',
        LargestBonus = 'LOC_CSE_'||Type||'_TRAIT_LARGEST_INFLUENCE_BONUS'
        -- MinorCivBonus = 'MINOR_CIV_BONUS_'||Type,
        -- ColorRef = 'COLOR_PLAYER_CITY_STATE_'||Type||'_SECONDARY'
WHERE   New = 0;
