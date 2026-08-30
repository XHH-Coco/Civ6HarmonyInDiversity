# -*- coding: utf-8 -*-
"""从创意工坊的 Sukritact's Oceans 生成 HD 的覆盖副本。

    python tools/vendor_suk_oceans.py "<创意工坊 2542898147 目录>"

干两件事：
  1. 把上游原文件原样存到 tools/maptest/versions/suk_upstream/ —— 这是**合并基准**，
     Suk 哪天更新了，拿新版和它 diff 一眼就知道上游改了什么。
  2. 把打过补丁的副本写到 ModSupport/SukOceans/ —— 这是实际随 mod 发布、
     靠 ImportFiles 覆盖上游同名文件的版本。

补丁本身很小（见下面的 PATCHES），而且**在数据正常时零行为改动** ——
tools/maptest/suk.lua 会逐格比对上游版和补丁版，证明这一点。

为什么要覆盖：见 docs/SukOceans.md 第 6 节。
"""
import io
import os
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

UPSTREAM_DIR = os.path.join(HERE, "maptest", "versions", "suk_upstream")
SHIP_DIR = os.path.join(ROOT, "ModSupport", "SukOceans")

# 跑测试需要，但 HD 不覆盖它们：原样留作基准
FIXTURE_ONLY = ["Suk_ContinentJumpFlood.lua", "PlotIterators.lua"]

BANNER = """--------------------------------------------------------------------------------
-- HD 覆盖版 —— 请不要手工编辑
--
-- 这是 Sukritact's Oceans（创意工坊 2542898147）里同名文件的副本，
-- 由 tools/vendor_suk_oceans.py 从上游原文件生成。上游原文件保存在
-- tools/maptest/versions/suk_upstream/ 作为合并基准。
--
-- 为什么要覆盖：上游那个文件会在某些地图上崩掉，崩了就等于整局一个海洋
-- 奢侈品都不放（详见 docs/SukOceans.md 第 6 节）。`include` 按文件名解析，
-- HD 用 ImportFiles 提供同名文件即可顶掉上游的。
--
-- 改了什么：只有下面标着 [HD] 的几处，全部是防御性的。
-- tools/maptest/suk.lua 逐格比对上游版和本版，证明**数据正常时行为完全一致**
-- （8 个场景，最终资源分布和随机数抽取次数都相同）。
--
-- 上游更新之后怎么办：把新版原文件重新跑一遍 vendor_suk_oceans.py 即可；
-- 补丁锚点对不上会直接报错，不会静默生成一个半新半旧的文件。
--------------------------------------------------------------------------------

"""

# 覆盖版开头打一句，用来在 Lua.log 里确认 ImportFiles 到底有没有顶掉上游那份。
# 这是唯一没法在游戏外验证的环节。
MARKER = 'print("HD: overriding %s");\n\n'

PATCHES = {
    "Suk_MapConvolution.lua": [
        # 尺寸改成每个实例现取。类级常量是首次加载时抓一次的，其中 m_MapHeight
        # 还要过 Select() 里 Lua 5.0 时代的 `arg` 表；一旦和当前地图尺寸不符，
        # DoConvolution 重建网格时尾部就没人写，下游拿到 nil。
        # 正常情况下两者相等，所以这处改动是纯防御。
        # 类级的那几行故意留着不删，为的是把 diff 压到最小。
        ("""		new = function(self, padding, limiter)
			local o = {}
			setmetatable(o, self)
			self.__index = self

			o.m_Padding = padding""",
         """		new = function(self, padding, limiter)
			local o = {}
			setmetatable(o, self)
			self.__index = self

			-- [HD] 尺寸每个实例现取，不吃类级常量（那是首次加载时抓的一次）
			o.m_MapWidth, o.m_MapHeight = Map.GetGridSize()
			o.m_WrapX = Map:IsWrapX()
			o.m_WrapY = Map:IsWrapY()

			o.m_Padding = padding"""),
        # iMin/iMax 从 0 起算而不是从首个元素起算，所以整张全零的图会得到
        # iRange == 0，每一格变成 0/0 = NaN。改成整体置零，别让 NaN 流下去。
        # 注意：这一处**不改变可观察行为** —— 下游 iMaxWeight 仍然停在 0，
        # iWeight = 0/0 依旧是 NaN，加权投放段照样整段失效、走兜底分支。
        # 要真正启用加权投放还得给 iMaxWeight 兜底，那才是行为改动，故意没做。
        ("""			local iRange = iMax - iMin

			for i,v in pairs(self.m_MapGrid) do
				self.m_MapGrid[i] = (v - iMin)/iRange
			end""",
         """			local iRange = iMax - iMin

			-- [HD] 全图同值时整体置零，而不是除以 0 让每格变成 NaN
			if iRange == 0 then
				for i in pairs(self.m_MapGrid) do
					self.m_MapGrid[i] = 0
				end
				return
			end

			for i,v in pairs(self.m_MapGrid) do
				self.m_MapGrid[i] = (v - iMin)/iRange
			end"""),
    ],
    "Suk_ResourceGenerator.lua": [
        # 权重表的覆盖范围原本挂在另一张表的 `#` 上。`#` 返回的是 border 不是计数，
        # 这里恰好抵消（Plots 的键是 0..N-1，# 得 N-1，循环 0..N-1 正好覆盖全图），
        # 但没有道理这么写。改成按地图尺寸铺满，缺失的补 0。
        ("""for iPlot = 0, #tPlotsData.Plots do
	tPlotsData.LuxuryWeight[iPlot]	= tLuxuryMap.m_MapGrid[iPlot]
	tPlotsData.BonusWeight[iPlot]	= tBonusMap.m_MapGrid[iPlot]
end""",
         """-- [HD] 按地图尺寸铺满，别挂在 #tPlotsData.Plots 上；缺失的补 0
for iPlot = 0, iWidth * iHeight - 1 do
	tPlotsData.LuxuryWeight[iPlot]	= tLuxuryMap.m_MapGrid[iPlot] or 0
	tPlotsData.BonusWeight[iPlot]	= tBonusMap.m_MapGrid[iPlot] or 0
end"""),
        # 就是这一行报 "operator < is not supported for number < nil"。
        # 权重表里只要有一个 nil，整个脚本就被打断，后面的资源一个都不放。
        ("""		return tPlotsData.LuxuryWeight[a] > tPlotsData.LuxuryWeight[b]""",
         """		-- [HD] 兜底：权重缺失时当 0，别让整个脚本因为一个 nil 被打断
		return (tPlotsData.LuxuryWeight[a] or 0) > (tPlotsData.LuxuryWeight[b] or 0)"""),
    ],
}


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    src_dir = os.path.join(sys.argv[1], "Lua")
    if not os.path.isdir(src_dir):
        sys.exit("找不到 %s —— 第一个参数应当是创意工坊 2542898147 的目录" % src_dir)

    os.makedirs(UPSTREAM_DIR, exist_ok=True)

    for name in FIXTURE_ONLY:
        shutil.copyfile(os.path.join(src_dir, name), os.path.join(UPSTREAM_DIR, name))
        print("基准  %s" % name)

    for name, patches in PATCHES.items():
        raw = io.open(os.path.join(src_dir, name), encoding="utf-8-sig").read()
        io.open(os.path.join(UPSTREAM_DIR, name), "w",
                encoding="utf-8", newline="").write(raw)
        print("基准  %s" % name)

        out = raw
        for old, new in patches:
            if old not in out:
                sys.exit("补丁锚点在 %s 里没匹配上，上游大概改过了：\n%s" % (name, old[:120]))
            out = out.replace(old, new, 1)

        io.open(os.path.join(SHIP_DIR, name), "w", encoding="utf-8", newline="").write(
            BANNER + (MARKER % name) + out)
        print("覆盖版 %s（%d 处补丁）" % (name, len(patches)))

    print()
    print("上游基准 -> %s" % os.path.relpath(UPSTREAM_DIR, ROOT))
    print("覆盖版   -> %s" % os.path.relpath(SHIP_DIR, ROOT))


if __name__ == "__main__":
    main()
