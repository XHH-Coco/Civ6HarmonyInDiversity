--------------------------------------------------------------------------------
-- AddVolcanicSoil 差分测试
--
--   lua run.lua
--
-- 把 2026-08-10 那批改动拆成一条链，每一步只做一件事，然后断言链的终点
-- 和实际发布的版本**逐格、逐次调用完全相同**：
--
--   v0   最初实现（math.random、硬编码 feature id 35）
--   v1   换成 GetRandomNumber + g_FEATURE_VOLCANIC_SOIL       断言 ≡ v0
--   v1a  只修 X 循环越界（缺陷 ①）
--   v1b  只换自然奇观守卫（缺陷 ②）
--   v2   实际发布的重写版                                      断言 ≡ v1b
--
-- 两处 ≡ 都成立，就等于证明了 v2 恰好是"v1 + 缺陷① + 缺陷②"，
-- 没有夹带任何第三种行为变化。这比"逐格解释差异"强，因为它不需要我去
-- 猜测差异的成因——级联效应之类的间接后果会被自动涵盖。
--------------------------------------------------------------------------------

local here = arg and arg[0] and arg[0]:match("^(.*)[/\\][^/\\]*$") or "."
package.path = here .. "/?.lua;" .. package.path
local S = require("stub")

local V = {
    v0  = { label = "v0  最初实现",       path = here .. "/versions/v0_original.lua"       },
    v1  = { label = "v1  接入种子",       path = here .. "/versions/v1_seeded.lua"         },
    v1a = { label = "v1a 只修接缝",       path = here .. "/versions/v1a_seam_fixed.lua"    },
    v1b = { label = "v1b 再修奇观守卫",   path = here .. "/versions/v1b_wonder_guarded.lua"},
    v2  = { label = "v2  实际发布版",     path = here .. "/versions/v2_rewritten.lua"      },
}

--------------------------------------------------------------------------------
-- 确定性随机源
--------------------------------------------------------------------------------

local function lcg(seed)
    local state = seed % 2147483647
    if state <= 0 then state = state + 2147483646 end
    return function(n)
        state = (state * 16807) % 2147483647
        if n == nil then return state end
        return state % n
    end
end

local MODES = {
    place  = { label = "总是铺", rng = function() return function(_) return 0 end end },
    skip   = { label = "总是跳", rng = function() return function(n) return n > 1 and 1 or 0 end end },
    stream = { label = "真随机", rng = function(seed) return lcg(seed) end },
}

--------------------------------------------------------------------------------
-- 合成地图
--------------------------------------------------------------------------------

local function blank(w, h, outOfRange)
    local world = S.newWorld(w, h, outOfRange)
    for y = 0, h - 1 do
        for x = 0, w - 1 do
            S.at(world, x, y).feature = S.F_FOREST
        end
    end
    return world
end

local CASES = {}
local function case(name, build) CASES[#CASES + 1] = { name = name, build = build } end

-- 火山落在东西接缝两侧：命中缺陷 ①
case("接缝火山", function(oor)
    local w = blank(20, 12, oor)
    S.at(w, 0, 5).feature  = S.F_VESUVIUS
    S.at(w, 19, 7).feature = S.F_FUJI
    S.at(w, 1, 9).feature  = S.F_VOLCANO
    S.at(w, 0, 2).feature  = S.F_VOLCANO
    return w
end)

-- 平地自然奇观紧贴普通火山：命中缺陷 ②
-- （普通火山那一支原先一个奇观都不排除）
case("普通火山旁的平地奇观", function(oor)
    local w = blank(16, 12, oor)
    S.at(w, 8, 6).feature = S.F_VOLCANO
    for _, c in ipairs(S.neighborCoords(8, 6)) do
        local p = S.at(w, c[1], c[2])
        if p then p.feature = S.F_SAHARA_EYE end
    end
    S.at(w, 4, 4).feature = S.F_VOLCANO
    S.at(w, 4, 5).feature = S.F_IK_KIL
    S.at(w, 5, 4).feature = S.F_NGORONGORO
    return w
end)

-- 火山系奇观互相挨着：命中一环/二环名单不一致，也制造级联
case("奇观挨着奇观", function(oor)
    local w = blank(16, 12, oor)
    S.at(w, 8, 6).feature  = S.F_KILI
    S.at(w, 9, 6).feature  = S.F_SAHARA_EYE
    S.at(w, 8, 7).feature  = S.F_EYJA
    S.at(w, 10, 6).feature = S.F_IK_KIL
    S.at(w, 7, 5).feature  = S.F_NGORONGORO
    return w
end)

case("极点与水山混杂", function(oor)
    local w = blank(18, 10, oor)
    for x = 0, 17 do
        S.at(w, x, 0).water = true
        S.at(w, x, 9).water = true
    end
    S.at(w, 5, 1).feature  = S.F_VESUVIUS
    S.at(w, 12, 8).feature = S.F_FUJI
    for _, c in ipairs(S.neighborCoords(5, 1)) do
        local p = S.at(w, c[1], c[2])
        if p then p.mountain = true end
    end
    return w
end)

case("奇数宽度", function(oor)
    local w = blank(15, 11, oor)
    S.at(w, 0, 5).feature  = S.F_EYJA
    S.at(w, 14, 5).feature = S.F_KILI
    return w
end)

for i = 1, 40 do
    case("随机地图 #" .. i, function(oor)
        local rnd = lcg(1000 + i * 7919)
        local w = blank(24 + (i % 5), 16 + (i % 3), oor)
        for y = 0, w.h - 1 do
            for x = 0, w.w - 1 do
                local p = S.at(w, x, y)
                local r = rnd(100)
                if r < 30 then
                    p.water = true
                elseif r < 40 then
                    p.mountain = true
                    p.feature = -1
                elseif r < 44 then
                    p.feature = S.F_VOLCANO
                elseif r < 46 then
                    p.feature = 4 + rnd(7)      -- 任一自然奇观，含不在旧名单里的
                elseif r < 60 then
                    p.feature = -1
                else
                    p.feature = rnd(3)
                end
            end
        end
        return w
    end)
end

--------------------------------------------------------------------------------

local function runOne(v, build, mode, seed, oor)
    local world = build(oor or "wrap")
    local before = S.snapshot(world)
    local env = S.makeEnv(world, MODES[mode].rng(seed))
    local fn = S.loadVersion(v.path, env)
    local ok, err = pcall(fn)
    return { ok = ok, err = err, world = world, before = before,
             after = S.snapshot(world), scan = world.scan,
             sets = world.sets, rngCalls = world.rngCalls }
end

local function listEq(a, b)
    if #a ~= #b then return false, "长度 " .. #a .. " vs " .. #b end
    for i = 1, #a do
        if a[i] ~= b[i] then
            return false, "第 " .. i .. " 项：" .. tostring(a[i]) .. " vs " .. tostring(b[i])
        end
    end
    return true
end

local function gridEq(a, b, world)
    for i = 0, world.w * world.h - 1 do
        if a.after[i] ~= b.after[i] then
            return false, string.format("(%d,%d) %s vs %s",
                i % world.w, math.floor(i / world.w),
                tostring(a.after[i]), tostring(b.after[i]))
        end
    end
    return true
end

local function gridDiffCount(a, b, world)
    local n = 0
    for i = 0, world.w * world.h - 1 do
        if a.after[i] ~= b.after[i] then n = n + 1 end
    end
    return n
end

--------------------------------------------------------------------------------

local failures = 0
local function fail(fmt, ...)
    failures = failures + 1
    print("  [FAIL] " .. string.format(fmt, ...))
end

print("================================================================")
print(" AddVolcanicSoil 差分测试     " .. _VERSION)
print("================================================================")

-- 桩自检
do
    print("\n-- 桩自检 --")
    local bad = 0
    for y = 0, 7 do
        for x = 0, 11 do
            for _, c in ipairs(S.neighborCoords(x, y)) do
                if c[2] >= 0 and c[2] <= 7 then
                    local nx, back = c[1] % 12, false
                    for _, d in ipairs(S.neighborCoords(nx, c[2])) do
                        if d[1] % 12 == x and d[2] == y then back = true end
                    end
                    if not back then bad = bad + 1 end
                end
            end
        end
    end
    if bad > 0 then fail("邻接不对称：%d 处", bad) else print("  邻接对称  OK") end

    local w = blank(12, 8, "wrap")
    local p = S.makeEnv(w, function() return 0 end).Map.GetPlot(12, 3)
    if p and p:GetX() == 0 then print("  东西绕回  OK")
    else fail("Map.GetPlot(w, y) 没有绕回第 0 列") end
end

--------------------------------------------------------------------------------
-- 主断言
--------------------------------------------------------------------------------

local stats = { seamScan = 0, wonderKept = 0, cascade = 0 }

for _, mode in ipairs({ "place", "skip", "stream" }) do
    print(string.format("\n-- 模式：%s --", MODES[mode].label))
    local d1a, d1b = 0, 0

    for _, c in ipairs(CASES) do
        local r0  = runOne(V.v0,  c.build, mode, 4242)
        local r1  = runOne(V.v1,  c.build, mode, 4242)
        local r1a = runOne(V.v1a, c.build, mode, 4242)
        local r1b = runOne(V.v1b, c.build, mode, 4242)
        local r2  = runOne(V.v2,  c.build, mode, 4242)

        for name, r in pairs({ v0 = r0, v1 = r1, v1a = r1a, v1b = r1b, v2 = r2 }) do
            if not r.ok then fail("%s / %s：运行报错 %s", c.name, name, tostring(r.err)) end
        end

        if r0.ok and r1.ok and r1a.ok and r1b.ok and r2.ok then
            -- 断言 1：v0 ≡ v1，那两步替换是纯重构
            local ok, why = gridEq(r0, r1, r0.world)
            if not ok then fail("%s：v0 ≠ v1 网格 —— %s", c.name, why) end
            ok, why = listEq(r0.sets, r1.sets)
            if not ok then fail("%s：v0 ≠ v1 的 SetFeatureType 序列 —— %s", c.name, why) end
            if r0.rngCalls ~= r1.rngCalls then
                fail("%s：v0/v1 抽取次数 %d vs %d", c.name, r0.rngCalls, r1.rngCalls)
            end

            -- 断言 2：v1b ≡ v2，发布版恰好等于两个修复之和
            ok, why = gridEq(r1b, r2, r2.world)
            if not ok then fail("%s：v1b ≠ v2 网格 —— %s", c.name, why) end
            ok, why = listEq(r1b.sets, r2.sets)
            if not ok then fail("%s：v1b ≠ v2 的 SetFeatureType 序列 —— %s", c.name, why) end
            if r1b.rngCalls ~= r2.rngCalls then
                fail("%s：v1b/v2 抽取次数 %d vs %d", c.name, r1b.rngCalls, r2.rngCalls)
            end

            -- 描述性统计（不作断言）
            d1a = d1a + gridDiffCount(r1, r1a, r1.world)
            d1b = d1b + gridDiffCount(r1a, r1b, r1.world)
            if mode == "place" then
                stats.seamScan = stats.seamScan + (#r1.scan - #r1a.scan)
                for i = 0, r1.world.w * r1.world.h - 1 do
                    local orig = r1.before[i]
                    if orig ~= -1 and S.FEATURES[orig] and S.FEATURES[orig].NaturalWonder
                       and r1a.after[i] == S.VOLCANIC_SOIL and r1b.after[i] == orig then
                        stats.wonderKept = stats.wonderKept + 1
                    elseif r1a.after[i] ~= r1b.after[i] then
                        stats.cascade = stats.cascade + 1
                    end
                end
            end
        end
    end

    print(string.format("  用例 %d｜缺陷① 造成的格差 %d｜缺陷② 造成的格差 %d",
                        #CASES, d1a, d1b))
end

--------------------------------------------------------------------------------
-- 缺陷 ① 的直接证据：扫描轨迹
--------------------------------------------------------------------------------

print("\n-- 缺陷 ① 的直接证据（扫描轨迹，与随机无关）--")
do
    local badCol = 0
    for _, c in ipairs(CASES) do
        local r1  = runOne(V.v1,  c.build, "place", 1)
        local r1a = runOne(V.v1a, c.build, "place", 1)
        local j = 1
        for i = 1, #r1.scan do
            if r1.scan[i] == r1a.scan[j] then
                j = j + 1
            else
                if tonumber(r1.scan[i]:match("^(-?%d+),")) ~= r1.world.w then
                    badCol = badCol + 1
                end
            end
        end
        if j ~= #r1a.scan + 1 then
            fail("%s：v1a 的扫描轨迹不是 v1 的子序列", c.name)
        end
    end
    print(string.format("  v1 多扫的格子 %d 个，其中不在 x==mWidth 列的：%d",
                        stats.seamScan, badCol))
    if badCol > 0 then fail("v1 的多余扫描不全在接缝列，缺陷 ① 的描述有误") end
    if stats.seamScan == 0 then fail("没有观察到多余扫描，用例没能触发缺陷 ①") end
end

--------------------------------------------------------------------------------
-- 缺陷 ② 的直接证据
--------------------------------------------------------------------------------

print("\n-- 缺陷 ② 的直接证据 --")
print(string.format("  被 v1a 铺掉、被 v1b 保住的自然奇观格：%d", stats.wonderKept))
print(string.format("  由此级联产生的其它格差（奇观得以保留后自己继续辐射）：%d", stats.cascade))
if stats.wonderKept == 0 then fail("没有观察到奇观被保住，用例没能触发缺陷 ②") end

--------------------------------------------------------------------------------
-- 越界返回 nil：验证旧代码确实依赖东西环绕
--------------------------------------------------------------------------------

print("\n-- Map.GetPlot 越界返回 nil --")
do
    local r1 = runOne(V.v1, CASES[1].build, "place", 1, "nil")
    local r2 = runOne(V.v2, CASES[1].build, "place", 1, "nil")
    print("  v1 " .. (r1.ok and "未报错" or "报错（预期：它访问了 x==mWidth）"))
    print("  v2 " .. (r2.ok and "未报错（预期）" or ("报错：" .. tostring(r2.err))))
    if r1.ok then fail("v1 在 nil 模式下没报错，说明用例没覆盖到 x==mWidth") end
    if not r2.ok then fail("v2 在 nil 模式下报错，说明循环上界仍然越界") end
end

--------------------------------------------------------------------------------

print("\n================================================================")
if failures == 0 then
    print("  通过")
    print("  v0 ≡ v1：math.random→GetRandomNumber 与 feature id→枚举 是纯重构")
    print("  v1b ≡ v2：发布版恰好等于 v1 + 缺陷① + 缺陷②，无第三种行为变化")
    os.exit(0)
else
    print(string.format("  失败 %d 项", failures))
    os.exit(1)
end
