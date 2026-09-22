create table if not exists 'HD_Binary_Compress'(
	'Exp' INT NOT NULL,
	'Amount' INT NOT NULL,
	PRIMARY KEY('Exp')
);
insert or ignore into HD_Binary_Compress ('Exp', 'Amount') values
	(0,1),
	(1,2),
	(2,4),
	(3,8),
	(4,16),
	(5,32),
	(6,64),
	(7,128),
	(8,256),
	(9,512),
	(10,1024),
	(11,2048),
	(12,4096),
	(13,8192),
	(14,16384);

insert or replace into GlobalParameters (Name, Value) values ('HD_BINARY_COMPRESS_MAX_EXP', 14);

create table if not exists 'HD_Binary_Compress_Keys'(
	'Key' TEXT NOT NULL,
	'MaxExp' INT NOT NULL Default 9,
	PRIMARY KEY('Key')
);

insert or replace into HD_Binary_Compress_Keys (Key, MaxExp) values
    -- 正宜居度
	('HD_PLOT_BINARY_COMPRESS_CITY_POSITIVE_AMENITY',   6),
    -- 溢出宜居度
	('HD_PLOT_BINARY_COMPRESS_CITY_EXCESS_AMENITY',     6),
    -- 政策卡数量
	('HD_PLOT_BINARY_COMPRESS_PLAYER_MILITARY_POLICY',  4),
	('HD_PLOT_BINARY_COMPRESS_PLAYER_ECONOMIC_POLICY',  4),
	('HD_PLOT_BINARY_COMPRESS_PLAYER_CULTURAL_POLICY',  4),
	('HD_PLOT_BINARY_COMPRESS_PLAYER_WILDCARD_POLICY',  4);

create table if not exists 'HD_Binary_Compress_AtLeast'(
	'Key' TEXT NOT NULL,
	'AtLeast' INT NOT NULL,
	PRIMARY KEY('Key')
);