--------------------------------------------------------------------------------
-- DoRiver 断头河统计（离线）
--
--   lua river.lua        （python drive.py 会连它一起跑）
--
-- 直接加载真实的 Maps/Utility/RiversLakes.lua，桩掉它用到的十来个引擎接口，
-- 然后数一件事：`bestFlowDirection == NO_FLOWDIRECTION` 这条路走了多少次，
-- 分别是哪些 (thisFlowDirection, originalFlowDirection) 组合。
--
-- 这正是"补边界"要处理的那条路，也是唯一一条能在代码里明确识别的断头方式。
--
-- 为什么不做"河道是否连通到水/边界"的几何校验：那需要一套六边形顶点模型，
-- 而 Civ6 的 W/NW/NE-of-river 标志位和 DoRiver 里"startPlot 的某个角"这个
-- 约定之间的对应关系，在游戏外没法验证。与其给出一个自己都不敢信的数字，
-- 不如只量这条能明确识别的。
--
-- 预期（穷举得到，见 docs/MapGeneration.md 5.4）：只有首行/末行会走到这里，
-- 共 12 种可达组合，北边界 10 种、南边界 2 种。
--------------------------------------------------------------------------------

local here = arg and arg[0] and arg[0]:match("^(.*)[/\\][^/\\]*$") or "."
local RIVERS_LAKES = here .. "/../../Maps/Utility/RiversLakes.lua"

local failures = 0
local function fail(fmt, ...)
    failures = failures + 1
    print("  失败：" .. string.format(fmt, ...))
end

--------------------------------------------------------------------------------
-- 确定性随机源
--------------------------------------------------------------------------------

local function lcg(seed)
    local state = seed % 2147483647
    if state <= 0 then state = state + 2147483646 end
    return function(range)
        state = (state * 16807) % 2147483647
        if range == nil or range <= 0 then return 0 end
        return state % math.floor(range)
    end
end

--------------------------------------------------------------------------------
-- 六边形网格：odd-r 偏移坐标，东西环绕、南北截断
--------------------------------------------------------------------------------

local DIR = {
    NORTHEAST = 0, EAST = 1, SOUTHEAST = 2,
    SOUTHWEST = 3, WEST = 4, NORTHWEST = 5,
}

local function neighborOffset(y, dir)
    local odd = (y % 2) ~= 0
    if dir == DIR.EAST then return 1, 0 end
    if dir == DIR.WEST then return -1, 0 end
    if odd then
        if dir == DIR.NORTHEAST then return 1, 1 end
        if dir == DIR.SOUTHEAST then return 1, -1 end
        if dir == DIR.SOUTHWEST then return 0, -1 end
        if dir == DIR.NORTHWEST then return 0, 1 end
    else
        if dir == DIR.NORTHEAST then return 0, 1 end
        if dir == DIR.SOUTHEAST then return 0, -1 end
        if dir == DIR.SOUTHWEST then return -1, -1 end
        if dir == DIR.NORTHWEST then return -1, 1 end
    end
end

--------------------------------------------------------------------------------
-- 地块
--------------------------------------------------------------------------------

local TERRAIN_DESERT = 2

local Plot = {}
Plot.__index = Plot

function Plot:GetX() return self.x end
function Plot:GetY() return self.y end
function Plot:GetIndex() return self.y * self.world.w + self.x end
function Plot:IsWater() return self.water end
function Plot:IsMountain() return self.mountain end
function Plot:IsHills() return self.hills end
function Plot:GetTerrainType() return self.terrain end
function Plot:IsNWOfRiver() return self.riverNW ~= nil end
function Plot:IsWOfRiver() return self.riverW ~= nil end
function Plot:IsNEOfRiver() return self.riverNE ~= nil end
function Plot:IsNWOfCliff() return false end
function Plot:IsWOfCliff() return false end
function Plot:IsNEOfCliff() return false end
function Plot:IsNaturalWonder() return false end

--------------------------------------------------------------------------------
-- 世界
--------------------------------------------------------------------------------

local function newWorld(w, h, rng, waterPercent)
    local world = { w = w, h = h, plots = {} }
    for y = 0, h - 1 do
        for x = 0, w - 1 do
            local p = setmetatable({
                x = x, y = y, world = world,
                water = rng(100) < waterPercent,
                hills = false, mountain = false, terrain = 0,
            }, Plot)
            if not p.water then
                local t = rng(100)
                p.hills = t < 22
                p.mountain = (t >= 22 and t < 30)
                if t >= 80 then p.terrain = TERRAIN_DESERT end
            end
            world.plots[y * w + x] = p
        end
    end
    return world
end

local function at(world, x, y)
    if y < 0 or y >= world.h then return nil end
    return world.plots[y * world.w + (x % world.w)]      -- 东西环绕
end

--------------------------------------------------------------------------------
-- 环境
--------------------------------------------------------------------------------

local function makeEnv(world, rng, log)
    local env = {}

    env.FlowDirectionTypes = {
        NO_FLOWDIRECTION        = -1,
        FLOWDIRECTION_NORTH     = 0,
        FLOWDIRECTION_NORTHEAST = 1,
        FLOWDIRECTION_SOUTHEAST = 2,
        FLOWDIRECTION_SOUTH     = 3,
        FLOWDIRECTION_SOUTHWEST = 4,
        FLOWDIRECTION_NORTHWEST = 5,
        NUM_FLOWDIRECTION_TYPES = 6,
    }
    env.DirectionTypes = {
        DIRECTION_NORTHEAST = 0, DIRECTION_EAST = 1, DIRECTION_SOUTHEAST = 2,
        DIRECTION_SOUTHWEST = 3, DIRECTION_WEST = 4, DIRECTION_NORTHWEST = 5,
        NUM_DIRECTION_TYPES = 6,
    }
    env.g_TERRAIN_TYPE_DESERT = TERRAIN_DESERT

    local Map = {}
    function Map.GetGridSize() return world.w, world.h end
    function Map.GetPlotByIndex(i) return world.plots[i] end
    function Map.GetAdjacentPlot(x, y, dir)
        local dx, dy = neighborOffset(y, dir)
        if dx == nil then return nil end
        return at(world, x + dx, y + dy)
    end
    env.Map = Map

    world.edgeCount = 0
    local TerrainBuilder = {}
    -- 铺边事件也进日志流：补丁是"两条 Set 紧跟一句 print"，
    -- 顺序信息足以校验它铺了哪两条边，不需要任何六边形几何知识。
    local function mark(side, plot)
        world.edgeCount = world.edgeCount + 1
        log(string.format("EDGE %s %d,%d", side, plot:GetX(), plot:GetY()))
    end
    function TerrainBuilder.SetWOfRiver(plot, on, flow)
        if on then plot.riverW = flow; mark("W", plot) end
    end
    function TerrainBuilder.SetNWOfRiver(plot, on, flow)
        if on then plot.riverNW = flow; mark("NW", plot) end
    end
    function TerrainBuilder.SetNEOfRiver(plot, on, flow)
        if on then plot.riverNE = flow; mark("NE", plot) end
    end
    function TerrainBuilder.GetRandomNumber(range, _r) return rng(range) end
    env.TerrainBuilder = TerrainBuilder

    env.print = log
    env.math, env.table, env.ipairs, env.pairs = math, table, ipairs, pairs
    env.string, env.tostring, env.tonumber = string, tostring, tonumber
    env.type, env.select, env.error, env.assert = type, select, error, assert
    env._G = env
    return env
end

local function loadInto(path, env)
    local fh = assert(io.open(path, "r"), "打不开 " .. path)
    local src = fh:read("*a")
    fh:close()
    local chunk
    if setfenv then
        chunk = assert(loadstring(src, path)); setfenv(chunk, env)
    else
        chunk = assert(load(src, path, "t", env))
    end
    chunk()
    return env
end

--------------------------------------------------------------------------------

local FLOW_NAME = { [-1] = "起点", [0] = "NORTH", [1] = "NORTHEAST", [2] = "SOUTHEAST",
                    [3] = "SOUTH", [4] = "SOUTHWEST", [5] = "NORTHWEST" }

local stats = { starts = 0, edges = 0, dead = 0, repaired = 0, combos = {}, rows = {} }

local function runMap(w, h, seed, waterPercent, poleFocus)
    local rng = lcg(seed)
    local world = newWorld(w, h, rng, waterPercent)

    local logs = {}
    local env = makeEnv(world, rng, function(...)
        local parts = {}
        for i = 1, select("#", ...) do parts[#parts + 1] = tostring((select(i, ...))) end
        logs[#logs + 1] = table.concat(parts, "\t")
    end)
    loadInto(RIVERS_LAKES, env)

    for y = 0, h - 1 do
        for x = 0, w - 1 do
            local p = at(world, x, y)
            local nearPole = (y >= h - 4) or (y <= 3)
            local pick = poleFocus and (nearPole or (x + y) % 11 == 0)
                                   or ((x * 7 + y * 3) % 5 == 0)
            if not p:IsWater() and pick then
                env.DoRiver(p)
                stats.starts = stats.starts + 1
            end
        end
    end
    stats.edges = stats.edges + world.edgeCount

    for i, line in ipairs(logs) do
        local py, this, orig = line:match("RIVER DEAD END: %(%d+,(%d+)%) this=(%-?%d+) orig=(%-?%d+)")
        if py then
            stats.dead = stats.dead + 1
            local key = string.format("this=%-10s orig=%s",
                FLOW_NAME[tonumber(this)], FLOW_NAME[tonumber(orig)])
            stats.combos[key] = (stats.combos[key] or 0) + 1
            py = tonumber(py)
            local where = (py == 0 and "南边界 y=0")
                       or (py == h - 1 and "北边界 y=H-1")
                       or ("内陆 y=" .. py)
            stats.rows[where] = (stats.rows[where] or 0) + 1
        elseif line:find("NORTH EDGE OF MAP RIVER REPAIR") then
            stats.repaired = stats.repaired + 1
            -- 补丁应当恰好铺两条边：同一格的 NW 和 W，紧挨在这句 print 前面。
            -- 这条断言不需要任何六边形几何知识，只是钉住"补丁的形状没被改坏"。
            local a = logs[i - 2] and logs[i - 2]:match("^EDGE (%a+ %d+,%d+)$")
            local b = logs[i - 1] and logs[i - 1]:match("^EDGE (%a+ %d+,%d+)$")
            if not (a and b) then
                fail("补丁前面不是两条铺边事件：%s | %s", tostring(a), tostring(b))
            else
                local sa, pa = a:match("^(%a+) (.+)$")
                local sb, pb = b:match("^(%a+) (.+)$")
                if pa ~= pb or not ((sa == "NW" and sb == "W") or (sa == "W" and sb == "NW")) then
                    fail("补丁铺的边不是同一格的 NW+W：%s | %s", a, b)
                end
            end
        end
    end
end

print("\n-- DoRiver 断头河统计 --")

local SCENARIOS = {
    { label = "常规水量 32%",   water = 32, pole = false, maps = 12 },
    { label = "少水 8%（河更容易走到极地）", water = 8, pole = true, maps = 12 },
}
local SIZES = { { 44, 26 }, { 60, 38 }, { 74, 46 } }

for _, sc in ipairs(SCENARIOS) do
    for _, size in ipairs(SIZES) do
        for i = 1, sc.maps do
            runMap(size[1], size[2], i * 7919 + size[1] + sc.water, sc.water, sc.pole)
        end
    end
end

print(string.format("  起河 %d 次，铺下 %d 条河流边", stats.starts, stats.edges))
print(string.format("  走到 NO_FLOWDIRECTION（断在陆地上）：%d 次", stats.dead))
print(string.format("  其中被北边界补丁救回：%d 次", stats.repaired))
print(string.format("  没救回（真正的断头河）：%d 次", stats.dead - stats.repaired))

if stats.dead > 0 then
    print("  按位置：")
    local rk = {}
    for k in pairs(stats.rows) do rk[#rk + 1] = k end
    table.sort(rk)
    for _, k in ipairs(rk) do print(string.format("    %-16s %d", k, stats.rows[k])) end

    print("  按方向组合：")
    local ck = {}
    for k in pairs(stats.combos) do ck[#ck + 1] = k end
    table.sort(ck, function(a, b) return stats.combos[a] > stats.combos[b] end)
    for _, k in ipairs(ck) do print(string.format("    %-34s %d", k, stats.combos[k])) end
end

if stats.dead > stats.repaired then
    fail("还有 %d 次断头没有被补边界救回", stats.dead - stats.repaired)
end

-- 穷举结论的实测校验：绝不该出现在内陆
for k, v in pairs(stats.rows) do
    if k:find("内陆") then
        fail("死胡同出现在内陆（%s，%d 次）——和穷举结论矛盾，桩或结论有一个错了", k, v)
    end
end

print()
if failures > 0 then
    print(string.format("失败 %d 项", failures))
    os.exit(1)
end
print("完成")
os.exit(0)
