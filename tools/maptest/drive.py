# -*- coding: utf-8 -*-
"""没有 Lua 解释器时的替代入口。

    pip install lupa
    python drive.py

等价于 `lua run.lua`。注意 lupa 内嵌的是 Lua 5.5，比游戏内嵌的 5.1 新；
这个测试本身不依赖版本差异，但如果将来把桩扩展到用了 table.maxn 之类
5.1 专有 API 的代码，就得换回真正的 5.1 解释器。
"""
import os
import sys

try:
    import lupa
except ImportError:
    sys.exit("需要 lupa：pip install lupa（或者装一个 Lua 解释器直接跑 lua run.lua）")

os.chdir(os.path.dirname(os.path.abspath(__file__)))

lua = lupa.LuaRuntime(unpack_returned_tuples=True)

# os.exit 会把 Python 进程一起带走，换成抛错并把码存下来
lua.execute('''
    local code
    os.exit = function(c) code = c; error("__harness_exit__", 0) end
    _G.__harness_code = function() return code end
''')

with open('run.lua', encoding='utf-8') as fh:
    src = fh.read()

try:
    lua.execute(src)
except lupa.LuaError as exc:
    if '__harness_exit__' not in str(exc):
        print('\nLUA ERROR:\n%s' % exc)
        sys.exit(2)

code = lua.eval('__harness_code()')
sys.exit(0 if code == 0 else 1)
