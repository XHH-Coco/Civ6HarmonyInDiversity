--delete from PlayerItems where Type = 'UNIT_ENGLISH_SEADOG';
delete from PlayerItems where Type in (select Type from UnitsToDelete);