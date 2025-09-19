create table if not exists HR_Denominations (
	Value integer default 0,
	Type text);
create trigger HD_HistoricalReligionSetting after insert on HR_Denominations when new.Type = 'HR_LITE_COMPLETE_SWITCH' begin
	update HR_Denominations set Value = 0 where Type = 'HR_LITE_COMPLETE_SWITCH';
end;