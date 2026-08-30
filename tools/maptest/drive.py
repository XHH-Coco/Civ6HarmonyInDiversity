# -*- coding: utf-8 -*-
"""没有 Lua 解释器时的替代入口。

    pip install lupa
    python drive.py

等价于依次跑 `lua run.lua`、`lua river.lua`、`lua suk.lua`。注意 lupa 内嵌的是 Lua 5.5，
比游戏内嵌的 5.1 新；这个测试本身不依赖版本差异，但如果将来把桩扩展到用了
table.maxn 之类 5.1 专有 API 的代码，就得换回真正的 5.1 解释器。
"""
import os
import sys

try:
    import lupa
except ImportError:
    sys.exit("需要 lupa：pip install lupa（或者装一个 Lua 解释器直接跑 lua run.lua）")

os.chdir(os.path.dirname(os.path.abspath(__file__)))

SCRIPTS = ("run.lua", "river.lua", "suk.lua")

PRELUDE = """
    -- os.exit 会把 Python 进程一起带走，换成抛错并把码存下来
    local code
    os.exit = function(c) code = c; error("__harness_exit__", 0) end
    _G.__harness_code = function() return code end
    arg = { [0] = "%s" }
"""


def run(script):
    """每个脚本用一个干净的 Lua 状态，避免互相污染全局。"""
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(PRELUDE % script)

    with open(script, encoding="utf-8") as fh:
        src = fh.read()

    try:
        lua.execute(src)
    except lupa.LuaError as exc:
        if "__harness_exit__" not in str(exc):
            print("\nLUA ERROR (%s):\n%s" % (script, exc))
            return 2

    return lua.eval("__harness_code()") or 0


worst = 0
for name in SCRIPTS:
    worst = max(worst, run(name))
sys.exit(0 if worst == 0 else 1)
