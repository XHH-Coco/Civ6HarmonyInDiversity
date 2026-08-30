--------------------------------------------------------------------------------
-- Sukritact's Oceans 覆盖版的差分测试
--
--   lua suk.lua        （python drive.py 会连它一起跑）
--
-- HD 用 ImportFiles 顶掉了上游两个文件（见 tools/vendor_suk_oceans.py）。
-- 这里在同一批合成地图上分别跑**上游原版**和**HD 覆盖版**，断言两件事完全相同：
--
--   ① 跑完之后每一格的资源
--   ② TerrainBuilder.GetRandomNumber 的调用次数
--
-- 也就是说：那几处补丁是**纯防御**，数据正常时一格都不改。
--
-- 上游原文件在 versions/suk_upstream/，是 vendor 脚本存下来的合并基准。
--
-- 一处说明：上游的 Suk_MapConvolution.lua 用 `Select(n, ...)`，实现依赖
-- Lua 5.0 时代的 `arg` 表，Lua 5.5 没有。加载时对**两个版本做同样的**文本替换，
-- 所以不影响比较的公平性。
--------------------------------------------------------------------------------

local here = arg and arg[0] and arg[0]:match("^(.*)[/\\][^/\\]*$") or "."
local UPSTREAM = here .. "/versions/suk_upstream"
local SHIPPED  = here .. "/../../ModSupport/SukOceans"

local failures = 0
local function fail(fmt, ...)
    failures = failures + 1
    print("  失败：" .. string.format(fmt, ...))
end

--------------------------------------------------------------------------------
-- 合成地图
--------------------------------------------------------------------------------

local TERRAIN_COAST = 15
local RES_AMBER, RES_CAVIAR, RES_CORAL, RES_FISH = 11, 12, 13, 14

local function buildEnv(cfg, convSrc, resSrc, silent)
    local W, H = cfg.w, cfg.h

    local Plot = {}
    Plot.__index = Plot
    function Plot:GetX() return self.x end
    function Plot:GetY() return self.y end
    function Plot:GetIndex() return self.i end
    function Plot:IsWater() return self.water end
    function Plot:IsLake() return self.lake end
    function Plot:GetTerrainType() return self.terrain end
    function Plot:GetResourceType() return self.resource end
    function Plot:GetContinentType() return self.continent end

    local state = 12345
    local rngCalls = 0
    local function rnd(range)
        state = (state * 16807) % 2147483647
        if range == nil or range <= 0 then return 0 end
        return state % math.floor(range)
    end

    local plots = {}
    for y = 0, H - 1 do
        for x = 0, W - 1 do
            plots[y * W + x] = setmetatable({
                x = x, y = y, i = y * W + x,
                water = false, lake = false, terrain = 3, resource = -1,
                continent = 11 + math.floor(x * cfg.continents / W),
            }, Plot)
        end
    end
    for _ = 1, cfg.water do
        local p = plots[rnd(W * H)]
        p.water, p.terrain, p.continent = true, TERRAIN_COAST, -1
    end
    for _ = 1, cfg.lakes do
        local p = plots[rnd(W * H)]
        p.water, p.lake, p.terrain, p.continent = true, true, TERRAIN_COAST, -1
    end
    -- 预置的水域奢侈品数量决定热力图是不是全零，也就是走不走那条除零的路
    local seeded = 0
    for i = 0, W * H - 1 do
        if plots[i].water and seeded < cfg.seedLux then
            plots[i].resource = RES_AMBER
            seeded = seeded + 1
        end
    end

    local env = {}

    local Map = {}
    function Map.GetGridSize() return W, H end
    function Map.GetPlotByIndex(i) return plots[i] end
    function Map.GetPlot(x, y)
        if y < 0 or y >= H then return nil end
        return plots[y * W + (x % W)]
    end
    function Map.IsWrapX() return true end
    function Map.IsWrapY() return false end
    function Map.GetMapSize() return 0 end
    -- 上游用的是冒号调用 Map:IsWrapX()，两种写法都要能通
    setmetatable(Map, { __index = function(_, k)
        if k == "IsWrapX" then return function() return true end end
        if k == "IsWrapY" then return function() return false end end
    end })
    env.Map = Map

    local props = {}
    env.Game = { GetProperty = function(_, k) return props[k] end,
                 SetProperty = function(_, k, v) props[k] = v end }
    env.ExposedMembers = {}
    env.MapConfiguration = { GetValue = function() return nil end }

    env.TerrainBuilder = {
        GetRandomNumber = function(range)
            rngCalls = rngCalls + 1
            return rnd(range)
        end,
    }
    env.ResourceBuilder = {
        CanHaveResource = function(p) return p ~= nil and p:IsWater() end,
        SetResourceType = function(p, r) p.resource = r end,
    }

    local RES = {
        { ResourceType = "RESOURCE_AMBER",      Index = RES_AMBER,  ResourceClassType = "RESOURCECLASS_LUXURY", SeaFrequency = 4,  LakeOnly = 0 },
        { ResourceType = "RESOURCE_SUK_CAVIAR", Index = RES_CAVIAR, ResourceClassType = "RESOURCECLASS_LUXURY", SeaFrequency = 4,  LakeOnly = 1 },
        { ResourceType = "RESOURCE_SUK_CORAL",  Index = RES_CORAL,  ResourceClassType = "RESOURCECLASS_LUXURY", SeaFrequency = 2,  LakeOnly = 0 },
        { ResourceType = "RESOURCE_FISH",       Index = RES_FISH,   ResourceClassType = "RESOURCECLASS_BONUS",  SeaFrequency = 5,  LakeOnly = 0 },
    }
    env.GameInfo = { Resources = {} }
    for _, r in ipairs(RES) do
        env.GameInfo.Resources[r.ResourceType] = r
        env.GameInfo.Resources[r.Index] = r
    end
    env.DB = { Query = function() return RES end }

    env.g_TERRAIN_TYPE_COAST = TERRAIN_COAST
    env.math, env.table, env.ipairs, env.pairs = math, table, ipairs, pairs
    env.string, env.tostring, env.tonumber = string, tostring, tonumber
    env.type, env.select, env.error, env.assert = type, select, error, assert
    env.coroutine, env.setmetatable, env.rawget = coroutine, setmetatable, rawget
    env.unpack = table.unpack or unpack
    env.print = silent and function() end or print
    env._G = env

    local function loadChunk(src, name)
        local chunk
        if setfenv then
            chunk = assert(loadstring(src, name)); setfenv(chunk, env)
        else
            chunk = assert(load(src, name, "t", env))
        end
        return chunk
    end

    local function slurp(path)
        local fh = assert(io.open(path, "r"), "打不开 " .. path)
        local s = fh:read("*a"); fh:close()
        return s
    end

    local loaded = {}
    env.include = function(name)
        if loaded[name] then return end
        loaded[name] = true
        if name == "Suk_MapConvolution" then loadChunk(convSrc, name)() ; return end
        if name == "Suk_ResourceGenerator" then loadChunk(resSrc, name)() ; return end
        loadChunk(slurp(UPSTREAM .. "/" .. name .. ".lua"), name)()
    end

    return env, plots, W, H, function() return rngCalls end
end

--------------------------------------------------------------------------------

local function readSrc(path)
    local fh = assert(io.open(path, "r"), "打不开 " .. path)
    local s = fh:read("*a"); fh:close()
    -- Lua 5.5 没有 5.1 的 `arg` 兼容表；两个版本做同样的替换
    return (s:gsub("return arg%[n%]", "return (select(n, ...))"))
end

local function run(cfg, dir)
    local env, plots, W, H, rngCalls = buildEnv(
        cfg,
        readSrc(dir .. "/Suk_MapConvolution.lua"),
        readSrc(dir .. "/Suk_ResourceGenerator.lua"),
        true)

    env.include "Suk_MapConvolution"
    env.include "Suk_ContinentJumpFlood"
    env.include "PlotIterators"
    local ok, err = pcall(env.include, "Suk_ResourceGenerator")

    local out = {}
    for i = 0, W * H - 1 do out[#out + 1] = tostring(plots[i].resource) end
    return table.concat(out, ","), rngCalls(), (not ok) and tostring(err) or nil
end

local CASES = {
    { "只有湖、无预置奢侈（热力图全零）", { water = 0,   lakes = 18, seedLux = 0,  continents = 1, w = 44, h = 26 } },
    { "只有湖、无预置奢侈、大图",         { water = 0,   lakes = 40, seedLux = 0,  continents = 1, w = 74, h = 46 } },
    { "有海有湖、无预置奢侈",             { water = 120, lakes = 18, seedLux = 0,  continents = 1, w = 44, h = 26 } },
    { "有海有湖、预置 1 个",              { water = 120, lakes = 18, seedLux = 1,  continents = 1, w = 44, h = 26 } },
    { "有海有湖、预置 12 个",             { water = 120, lakes = 18, seedLux = 12, continents = 1, w = 44, h = 26 } },
    { "三个大洲、预置 8 个",              { water = 200, lakes = 20, seedLux = 8,  continents = 3, w = 60, h = 38 } },
    { "水很多、预置 30 个",               { water = 400, lakes = 10, seedLux = 30, continents = 2, w = 60, h = 38 } },
    { "几乎全是水",                       { water = 900, lakes = 5,  seedLux = 20, continents = 1, w = 44, h = 26 } },
}

print("\n-- Suk's Oceans 覆盖版 vs 上游原版 --")
print(string.format("  %-34s %-8s %s", "用例", "格局", "抽数"))

local same = 0
for _, case in ipairs(CASES) do
    local label, cfg = case[1], case[2]
    local a, ra, ea = run(cfg, UPSTREAM)
    local b, rb, eb = run(cfg, SHIPPED)

    if ea then fail("%s：上游版报错 %s", label, ea) end
    if eb then fail("%s：覆盖版报错 %s", label, eb) end

    local gridOK, rngOK = (a == b), (ra == rb)
    if gridOK and rngOK then same = same + 1 end
    if not gridOK then fail("%s：最终资源分布不同", label) end
    if not rngOK then fail("%s：随机数抽取次数不同（%d vs %d）", label, ra, rb) end

    print(string.format("  %-34s %-8s %s", label,
        gridOK and "一致" or "不同",
        rngOK and ("一致 " .. ra) or string.format("不同 %d/%d", ra, rb)))
end

print(string.format("  %d / %d 个用例完全一致", same, #CASES))

print()
if failures > 0 then
    print(string.format("失败 %d 项", failures))
    os.exit(1)
end
print("完成")
os.exit(0)
