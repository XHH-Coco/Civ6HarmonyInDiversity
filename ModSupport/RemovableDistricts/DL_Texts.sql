-------------------------------------
--     Adaptation for the Mod      --
-------------------------------------

--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
    (Tag,                                       Text)
values
    ('LOC_REMOVE_DISTRICT_PROJECT_DESCRIPTION', 'Removes the district with all its buildings.');

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN

insert or ignore into LocalizedText ( Language, Tag, Text )
 select 'zh_Hans_CN', 'LOC_PROJECT_REMOVE'||substr(Tag, 4), '移除 '||Text 
from LocalizedText where Language = 'zh_Hans_CN' and Tag like 'LOC_DISTRICT%NAME';

insert or replace into LocalizedText ( Language, Tag, Text ) values
    ('zh_Hans_CN', 'LOC_REMOVE_DISTRICT_PROJECT_DESCRIPTION', '移除该区域和其内的所有建筑。');
