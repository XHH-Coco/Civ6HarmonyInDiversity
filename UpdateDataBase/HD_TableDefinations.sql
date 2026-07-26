create table if not exists 'HDCounter'(
	'Count' INT NOT NULL,
	PRIMARY KEY(Count)
);
insert or ignore into HDCounter (Count) values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15);

create table if not exists HD_BuildingRegionalRange (
	BuildingType text not null primary key,
	RegionalRange int not null,
	foreign key (BuildingType) references Buildings (BuildingType) on update cascade on delete cascade
);

create table if not exists HD_BuildingRegionalYieldTypes (
	YieldType 	text not null primary key,
	Name				text not null,
	IconString	text not null
);

create table if not exists HD_BuildingRegionalYields (
	BuildingType text not null,
	YieldType text not null,
	YieldChange int not null,
	RequiresPower boolean not null default 0,
	PrereqTech text,
	PrereqCivic text,
	primary key (BuildingType, YieldType, RequiresPower),
	foreign key (BuildingType) references Buildings (BuildingType) on update cascade on delete cascade,
	foreign key (YieldType) references HD_BuildingRegionalYieldTypes (YieldType) on update cascade on delete cascade,
	foreign key (PrereqTech) references Technologies (TechnologyType) on update cascade on delete cascade,
	foreign key (PrereqCivic) references Civics (CivicType) on update cascade on delete cascade
);

create table if not exists HD_PolicyRegionalRange (
	PolicyType text not null,
	DistrictType text not null,
	RegionalRange int not null,
	primary key (PolicyType, DistrictType)
);

create table if not exists HD_GreatWork_Text(
	GreatWorkType   TEXT NOT NULL,
	Description     TEXT NOT NULL,
	PRIMARY KEY(GreatWorkType)
	FOREIGN KEY(GreatWorkType) REFERENCES GreatWorks(GreatWorkType) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 着力点图标
create table if not exists 'CommemorationIcons'(
	'CommemorationType' TEXT    not NULL,
	'Icon'              TEXT    not NULL,
	PRIMARY KEY('CommemorationType')
);

------------------- 需要Lua统计城市改良数量的改良 -------------------
create table if not exists ImprovementsNeedCount_HD(
	ImprovementType TEXT not NULL,
PRIMARY KEY('ImprovementType'));

------------------- 允许改良特定地形地貌上资源的改良 -------------------
create table if not exists ImprovementsRules_HD(
	ImprovementType TEXT not NULL,
PRIMARY KEY('ImprovementType'));

------------------- 依赖Plot Property的政策 -------------------
create table if not exists HD_PolicyNeedDetect(
	PolicyType 		TEXT not NULL,
	PropertyRange TEXT not NULL,
PRIMARY KEY('PolicyType'));

------------------- 提供总督点的科技 -------------------
create table if not exists HD_TechnologyGovernorPoints(
	TechnologyType TEXT not NULL,
PRIMARY KEY('TechnologyType'));