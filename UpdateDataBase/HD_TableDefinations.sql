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