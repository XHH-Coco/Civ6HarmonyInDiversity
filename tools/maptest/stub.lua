--------------------------------------------------------------------------------
-- 差分测试用的引擎桩
--
-- 只实现 AddVolcanicSoil 实际用到的那 11 个接口。这不是 Civ6 的模拟器，
-- 它唯一的职责是让同一份输入喂给不同版本的函数，好比较输出。
--------------------------------------------------------------------------------

local M = {}

--------------------------------------------------------------------------------
-- 地貌表
--------------------------------------------------------------------------------

-- 索引刻意用了真实的 35 作为火山土，因为 v0 里是硬编码的字面量 35，
-- 而 v1/v2 用 g_FEATURE_VOLCANIC_SOIL。两者必须指向同一个值才能对比。
M.VOLCANIC_SOIL = 35

M.FEATURES = {
    [0]  = { FeatureType = "FEATURE_FOREST",                NaturalWonder = false },
    [1]  = { FeatureType = "FEATURE_JUNGLE",                NaturalWonder = false },
    [2]  = { FeatureType = "FEATURE_MARSH",                 NaturalWonder = false },
    [3]  = { FeatureType = "FEATURE_VOLCANO",               NaturalWonder = false },
    -- 旧代码硬编码名单里的五个
    [4]  = { FeatureType = "FEATURE_EYJAFJALLAJOKULL",      NaturalWonder = true },
    [5]  = { FeatureType = "FEATURE_KILIMANJARO",           NaturalWonder = true },
    [6]  = { FeatureType = "FEATURE_VESUVIUS",              NaturalWonder = true },
    [7]  = { FeatureType = "FEATURE_SUK_FUJI",              NaturalWonder = true },
    [8]  = { FeatureType = "FEATURE_SUK_NGORONGORO_CRATER", NaturalWonder = true },
    -- 不在旧名单里的平地自然奇观，用来暴露缺陷 ②
    [9]  = { FeatureType = "FEATURE_EYE_OF_THE_SAHARA",     NaturalWonder = true },
    [10] = { FeatureType = "FEATURE_IK_KIL_CENOTE",         NaturalWonder = true },
    -- 三种泛滥平原：不是自然奇观，所以旧守卫会把它们盖掉
    [20] = { FeatureType = "FEATURE_FLOODPLAINS",           NaturalWonder = false },
    [21] = { FeatureType = "FEATURE_FLOODPLAINS_GRASSLAND", NaturalWonder = false },
    [22] = { FeatureType = "FEATURE_FLOODPLAINS_PLAINS",    NaturalWonder = false },
    [35] = { FeatureType = "FEATURE_VOLCANIC_SOIL",         NaturalWonder = false },
}

M.F_FOREST      = 0
M.F_JUNGLE      = 1
M.F_MARSH       = 2
M.F_VOLCANO     = 3
M.F_EYJA        = 4
M.F_KILI        = 5
M.F_VESUVIUS    = 6
M.F_FUJI        = 7
M.F_NGORONGORO  = 8
M.F_SAHARA_EYE  = 9
M.F_IK_KIL      = 10
M.F_FLOODPLAINS           = 20
M.F_FLOODPLAINS_GRASSLAND = 21
M.F_FLOODPLAINS_PLAINS    = 22

-- 三种泛滥平原的集合，测试里判断"这格是不是泛滥"用
M.FLOODPLAINS = {
    [M.F_FLOODPLAINS]           = true,
    [M.F_FLOODPLAINS_GRASSLAND] = true,
    [M.F_FLOODPLAINS_PLAINS]    = true,
}

--------------------------------------------------------------------------------
-- 地块
--------------------------------------------------------------------------------

local Plot = {}
Plot.__index = Plot

function Plot:GetX()           return self.x end
function Plot:GetY()           return self.y end
function Plot:GetIndex()       return self.y * self.world.w + self.x end
function Plot:GetFeatureType() return self.feature end
function Plot:IsWater()        return self.water end
function Plot:IsMountain()     return self.mountain end

--------------------------------------------------------------------------------
-- 世界
--------------------------------------------------------------------------------

-- outOfRange 控制 Map.GetPlot 拿到越界 x 时的行为：
--   "wrap" —— 绕回另一侧（Civ6 地图东西向环绕，这是我们相信的真实行为）
--   "nil"  —— 返回 nil（用来验证旧代码确实依赖环绕：这个模式下 v0/v1 会报错）
function M.newWorld(w, h, outOfRange)
    local world = {
        w = w,
        h = h,
        plots = {},
        outOfRange = outOfRange or "wrap",
        scan = {},      -- Map.GetPlot 的调用轨迹（= 外层扫描顺序）
        sets = {},      -- SetFeatureType 的调用轨迹
        rngCalls = 0,
    }
    for y = 0, h - 1 do
        for x = 0, w - 1 do
            world.plots[y * w + x] = setmetatable({
                x = x, y = y, world = world,
                feature = -1, water = false, mountain = false,
            }, Plot)
        end
    end
    return world
end

function M.at(world, x, y)
    return world.plots[y * world.w + x]
end

-- 逐格快照，用来做网格对比
function M.snapshot(world)
    local out = {}
    for y = 0, world.h - 1 do
        for x = 0, world.w - 1 do
            out[y * world.w + x] = M.at(world, x, y).feature
        end
    end
    return out
end

function M.resetTraces(world)
    world.scan = {}
    world.sets = {}
    world.rngCalls = 0
end

--------------------------------------------------------------------------------
-- 邻接：odd-r 偏移坐标（奇数行右移半格），东西环绕、南北截断
--------------------------------------------------------------------------------

local function neighborCoords(x, y)
    if (y % 2) ~= 0 then
        return {
            { x + 1, y + 1 },   -- NE
            { x + 1, y     },   -- E
            { x + 1, y - 1 },   -- SE
            { x,     y - 1 },   -- SW
            { x - 1, y     },   -- W
            { x,     y + 1 },   -- NW
        }
    end
    return {
        { x,     y + 1 },       -- NE
        { x + 1, y     },       -- E
        { x,     y - 1 },       -- SE
        { x - 1, y - 1 },       -- SW
        { x - 1, y     },       -- W
        { x - 1, y + 1 },       -- NW
    }
end

M.neighborCoords = neighborCoords

--------------------------------------------------------------------------------
-- 构造被测函数运行所需的全局环境
--------------------------------------------------------------------------------

-- rng(range) 必须返回 0 .. range-1
function M.makeEnv(world, rng)
    local env = {}

    local function fetch(x, y, record)
        if record then
            world.scan[#world.scan + 1] = x .. "," .. y
        end
        if y < 0 or y >= world.h then
            return nil
        end
        if x < 0 or x >= world.w then
            if world.outOfRange == "nil" then
                return nil
            end
            x = x % world.w
        end
        return world.plots[y * world.w + x]
    end

    local Map = {}

    function Map.GetGridSize()
        return world.w, world.h
    end

    -- 外层扫描唯一的入口，记轨迹
    function Map.GetPlot(x, y)
        return fetch(x, y, true)
    end

    function Map.GetPlotByIndex(i)
        return world.plots[i]
    end

    -- Adjacent / AdjacentCount 用；方向序与 neighborCoords 一致
    function Map.GetAdjacentPlot(x, y, direction)
        local c = neighborCoords(x, y)[direction + 1]
        if not c then return nil end
        return fetch(c[1], c[2], false)
    end

    -- Civ6 在极点会给出 nil 项；这里返回稠密数组（跳过不存在的邻居），
    -- 因为被测代码用的是 ipairs，遇到 nil 会提前中断。对所有版本一致即可。
    function Map.GetAdjacentPlots(x, y)
        local out = {}
        for _, c in ipairs(neighborCoords(x, y)) do
            local p = fetch(c[1], c[2], false)
            if p then
                out[#out + 1] = p
            end
        end
        return out
    end

    local TerrainBuilder = {}

    function TerrainBuilder.SetFeatureType(plot, feature)
        world.sets[#world.sets + 1] = plot.x .. "," .. plot.y .. "=" .. tostring(feature)
        plot.feature = feature
    end

    function TerrainBuilder.GetRandomNumber(range, _name)
        world.rngCalls = world.rngCalls + 1
        return rng(range)
    end

    -- v0 用 math.random(n)（返回 1..n）。转接到同一个 rng 上，
    -- 这样 v0 和 v1 在同一模式下拿到语义相同的结果。
    local mathProxy = setmetatable({
        random = function(a, b)
            world.rngCalls = world.rngCalls + 1
            if b == nil then
                return 1 + rng(a)
            end
            return a + rng(b - a + 1)
        end,
    }, { __index = math })

    env.Map = Map
    env.TerrainBuilder = TerrainBuilder
    env.GameInfo = { Features = M.FEATURES }
    env.g_FEATURE_VOLCANIC_SOIL = M.VOLCANIC_SOIL
    env.g_FEATURE_FLOODPLAINS            = M.F_FLOODPLAINS
    env.g_FEATURE_FLOODPLAINS_GRASSLAND  = M.F_FLOODPLAINS_GRASSLAND
    env.g_FEATURE_FLOODPLAINS_PLAINS     = M.F_FLOODPLAINS_PLAINS
    env.DirectionTypes = { NUM_DIRECTION_TYPES = 6 }
    env.g_PLOT_TYPE_MOUNTAIN = 0
    env.g_PLOT_TYPE_HILLS = 1
    env.g_PLOT_TYPE_LAND = 2
    env.g_PLOT_TYPE_OCEAN = 3
    env.math = mathProxy
    env.ipairs = ipairs
    env.pairs = pairs
    env.tostring = tostring
    env.print = function() end          -- 被测函数里没有 print，留着以防万一
    env._G = env

    return env
end

--------------------------------------------------------------------------------
-- 加载一个版本的 AddVolcanicSoil 到指定环境（兼容 Lua 5.1 / 5.2+ / LuaJIT）
--------------------------------------------------------------------------------

-- anyName = true 时只加载、不取单个函数，用于一次定义多个函数的版本文件
-- （Adjacent / AdjacentCount / SetIslandLayer 就是这种）
function M.loadVersion(path, env, anyName)
    local fh = assert(io.open(path, "r"), "打不开 " .. path)
    local src = fh:read("*a")
    fh:close()

    local chunk
    if setfenv then                       -- 5.1 / LuaJIT
        chunk = assert(loadstring(src, path))
        setfenv(chunk, env)
    else                                  -- 5.2+
        chunk = assert(load(src, path, "t", env))
    end
    chunk()

    if anyName then
        return env
    end
    return assert(env.AddVolcanicSoil, path .. " 里没有定义 AddVolcanicSoil")
end

return M
