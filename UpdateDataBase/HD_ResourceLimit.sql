create table if not exists HD_BanResourcesOnTerrainsOrFeatures (
	ResourceType text not null,
	TerrainType text not null,
	FeatureType text not null,
	primary key (ResourceType, TerrainType, FeatureType)
);

insert or replace into HD_BanResourcesOnTerrainsOrFeatures
	(ResourceType,                      TerrainType,                        FeatureType)
values
    ("RESOURCE_IVORY",					"TERRAIN_TUNDRA",					"FEATURE_FOREST"),	--冻土森林象
    ("RESOURCE_IVORY",					"TERRAIN_TUNDRA_HILLS",				"FEATURE_FOREST"),	--冻土丘陵森林象
    ("RESOURCE_SAKURA",               	"TERRAIN_TUNDRA",                   "FEATURE_FOREST"),	--冻土森林樱花木
    ("RESOURCE_SAKURA",					"TERRAIN_TUNDRA_HILLS",				"FEATURE_FOREST"),	--冻土丘陵森林樱花木
    ("RESOURCE_MEDIHERBS",              "TERRAIN_TUNDRA",                   "FEATURE_FOREST"),	--冻土森林铁皮石斛
    ("RESOURCE_MEDIHERBS",				"TERRAIN_TUNDRA_HILLS",				"FEATURE_FOREST"),	--冻土丘陵森林铁皮石斛
    ("RESOURCE_LEU_P0K_CAPYBARAS",		"TERRAIN_TUNDRA",                   "FEATURE_FOREST"),	--冻土森林水豚
    ("RESOURCE_LEU_P0K_CAPYBARAS",		"TERRAIN_TUNDRA_HILLS",				"FEATURE_FOREST"),	--冻土丘陵森林水豚
	("RESOURCE_SILK",              		"TERRAIN_TUNDRA",                   "FEATURE_FOREST"),	--冻土森林丝绸
    ("RESOURCE_SILK",					"TERRAIN_TUNDRA_HILLS",				"FEATURE_FOREST"),	--冻土丘陵森林丝绸
    ("RESOURCE_WINE",              		"TERRAIN_TUNDRA",                   "FEATURE_FOREST"),	--冻土森林葡萄酒
    ("RESOURCE_WINE",					"TERRAIN_TUNDRA_HILLS",				"FEATURE_FOREST"),	--冻土丘陵森林葡萄酒
    ("RESOURCE_SPICES",              	"TERRAIN_TUNDRA",                   "FEATURE_FOREST"),	--冻土森林香料
    ("RESOURCE_SPICES",					"TERRAIN_TUNDRA_HILLS",				"FEATURE_FOREST"),	--冻土丘陵森林香料
    ("RESOURCE_TRUFFLES",              	"TERRAIN_TUNDRA",                   "FEATURE_FOREST"),	--冻土森林松露
    ("RESOURCE_TRUFFLES",				"TERRAIN_TUNDRA_HILLS",				"FEATURE_FOREST"),	--冻土丘陵森林松露
    ("RESOURCE_OAK",              		"TERRAIN_TUNDRA",                   "FEATURE_FOREST"),	--冻土森林橡木
    ("RESOURCE_OAK",					"TERRAIN_TUNDRA_HILLS",				"FEATURE_FOREST"),	--冻土丘陵森林橡木

    ("RESOURCE_LEAD",					"TERRAIN_DESERT",					"FEATURE_VOLCANIC_SOIL"),	--沙漠火山土铅锌矿
    ("RESOURCE_LEAD",					"TERRAIN_DESERT_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--沙漠丘陵火山土铅锌矿
    ("RESOURCE_LIMESTONE",				"TERRAIN_DESERT",					"FEATURE_VOLCANIC_SOIL"),	--沙漠火山土白云石
    ("RESOURCE_LIMESTONE",				"TERRAIN_DESERT_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--沙漠丘陵火山土白云石

    ("RESOURCE_LEAD",					"TERRAIN_DESERT",					"FEATURE_GEOTHERMAL_FISSURE"),	--沙漠地热铅锌矿
    ("RESOURCE_LEAD",					"TERRAIN_DESERT_HILLS",				"FEATURE_GEOTHERMAL_FISSURE"),	--沙漠丘陵地热铅锌矿
    ("RESOURCE_LIMESTONE",				"TERRAIN_DESERT",					"FEATURE_GEOTHERMAL_FISSURE"),	--沙漠地热白云石
    ("RESOURCE_LIMESTONE",				"TERRAIN_DESERT_HILLS",				"FEATURE_GEOTHERMAL_FISSURE"),	--沙漠丘陵地热白云石

    ("RESOURCE_STONE",					"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土安山岩
    ("RESOURCE_STONE",					"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土安山岩
    ("RESOURCE_MARBLE",					"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土大理石
    ("RESOURCE_MARBLE",					"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土大理石
    ("RESOURCE_SUK_OBSIDIAN",			"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土黑曜石
    ("RESOURCE_SUK_OBSIDIAN",			"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土黑曜石
    ("RESOURCE_RUBY",					"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土红宝石
    ("RESOURCE_RUBY",					"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土红宝石
    ("RESOURCE_GRANITE",				"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土花岗岩
    ("RESOURCE_GRANITE",				"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土花岗岩
    ("RESOURCE_GOLD",					"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土黄金
    ("RESOURCE_GOLD",					"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土黄金
    ("RESOURCE_LEAD",					"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土铅锌矿
    ("RESOURCE_LEAD",					"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土铅锌矿
    ("RESOURCE_LIMESTONE",				"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土白云石
    ("RESOURCE_LIMESTONE",				"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土白云石
    ("RESOURCE_QUARTZ",					"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土石英
    ("RESOURCE_QUARTZ",					"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土石英
    ("RESOURCE_MERCURY",				"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土水银
    ("RESOURCE_MERCURY",				"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土水银
    ("RESOURCE_COPPER",					"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土铜
    ("RESOURCE_COPPER",					"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土铜
    ("RESOURCE_TIN",					"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土锡
    ("RESOURCE_TIN",					"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL"),	--雪地丘陵火山土锡
    ("RESOURCE_DIAMONDS",				"TERRAIN_SNOW",						"FEATURE_VOLCANIC_SOIL"),	--雪地火山土钻石
    ("RESOURCE_DIAMONDS",				"TERRAIN_SNOW_HILLS",				"FEATURE_VOLCANIC_SOIL");	--雪地丘陵火山土钻石
