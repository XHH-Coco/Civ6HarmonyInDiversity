#!/usr/bin/env python3
"""把 origin/xhh_reborn 的新提交同步进 cloud 分支。

两条分支的分工是固定的：xhh_reborn 是上游作者改玩法（Gameplay / Texts /
UpdateDataBase），cloud 是这边改地图和工具（Maps / tools / docs）。文件集基本
不相交，所以绝大多数同步是一次干净的 merge，不需要人看。这个脚本负责那部分，
并在需要判断时干净地停下来。

退出码：
  0  同步完成（或本来就没有新提交）
  2  需要人/Claude 介入（合并冲突、检查不通过、工作区不干净）
  1  脚本自身出错

用法：
  python tools/sync_cloud.py            # 合并到本地 cloud，不推送
  python tools/sync_cloud.py --push     # 合并并推送 origin/cloud
  python tools/sync_cloud.py --check    # 只看有没有新提交，什么都不改
"""

import argparse
import os
import re
import subprocess
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        # encoding：提交信息是中文，别让 Windows 控制台默认编码毁掉日志。
        # line_buffering：输出走管道时 stdout 默认块缓冲，会让 stderr 抢跑到前面。
        _s.reconfigure(encoding="utf-8", line_buffering=True)
    except (AttributeError, ValueError):
        pass

UPSTREAM = "origin/xhh_reborn"
TARGET = "cloud"

# cloud 分支自己负责的目录。上游若动到这里，说明和这边的重构撞车了，
# 即使 merge 干净也值得人看一眼。
CLOUD_TERRITORY = ("Maps/", "tools/", "docs/", "ModSupport/SukOceans/")


def git(*args, check=True):
    r = subprocess.run(
        ["git", *args], capture_output=True, text=True, encoding="utf-8", errors="replace"
    )
    if check and r.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} 失败：\n{r.stdout}{r.stderr}")
    return r


def out(*args):
    return git(*args).stdout.strip()


def modinfo_missing_refs(ref=None):
    """DL.modinfo 里引用了但磁盘上/该 commit 里不存在的文件。"""
    if ref is None:
        text = open("DL.modinfo", encoding="utf-8-sig").read()
        exists = os.path.exists
    else:
        text = out("show", f"{ref}:DL.modinfo")
        tree = set(out("ls-tree", "-r", "--name-only", ref).splitlines())
        exists = tree.__contains__
    refs = set(re.findall(r"<File>([^<]+)</File>", text))
    return {r for r in refs if not exists(r.replace("\\", "/"))}


def conflict_markers():
    """已跟踪文件里残留的冲突标记。"""
    r = git("grep", "-l", "-E", r"^<<<<<<< |^>>>>>>> ", check=False)
    return [f for f in r.stdout.strip().splitlines() if f]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--push", action="store_true", help="检查通过后推送 origin/cloud")
    ap.add_argument("--check", action="store_true", help="只报告，不改动任何东西")
    args = ap.parse_args()

    os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))

    git("fetch", "origin", "--prune")

    behind = out("rev-list", "--count", f"{TARGET}..{UPSTREAM}")
    if behind == "0":
        print(f"cloud 已包含 {UPSTREAM} 的全部提交，无需同步。")
        return 0

    new_commits = out("log", "--oneline", f"{TARGET}..{UPSTREAM}")
    changed = out("diff", "--name-only", f"{TARGET}...{UPSTREAM}").splitlines()
    print(f"{UPSTREAM} 有 {behind} 个新提交：")
    for line in new_commits.splitlines():
        print("  " + line)
    print(f"涉及 {len(changed)} 个文件。")

    touched = [f for f in changed if f.startswith(CLOUD_TERRITORY)]
    if touched:
        print("\n注意：上游动了 cloud 负责的目录，合并干净也建议人看一眼：")
        for f in touched:
            print("  " + f)

    if args.check:
        return 0

    dirty = out("status", "--porcelain")
    if dirty:
        print("\n工作区不干净，先处理掉再同步：\n" + dirty, file=sys.stderr)
        return 2

    original = out("rev-parse", "--abbrev-ref", "HEAD")
    baseline_missing = modinfo_missing_refs(TARGET)

    git("checkout", TARGET)
    try:
        # cloud 落后于 origin/cloud 就先跟上，避免推送时被拒。
        git("merge", "--ff-only", f"origin/{TARGET}", check=False)

        m = git("merge", "--no-edit", UPSTREAM, check=False)
        print(m.stdout + m.stderr)
        if m.returncode != 0:
            conflicts = out("diff", "--name-only", "--diff-filter=U")
            git("merge", "--abort", check=False)
            print("\n合并冲突，已回滚。冲突文件：", file=sys.stderr)
            print(conflicts, file=sys.stderr)
            print("交给 Claude 处理这次同步。", file=sys.stderr)
            return 2

        problems = []
        markers = conflict_markers()
        if markers:
            problems.append("残留冲突标记：" + ", ".join(markers))
        # 只报新增的缺失引用，历史遗留的两条不算数。
        new_missing = modinfo_missing_refs() - baseline_missing
        if new_missing:
            problems.append("DL.modinfo 新增了指向不存在文件的引用：" + ", ".join(sorted(new_missing)))

        if problems:
            print("\n合并后检查不通过，已保留合并结果供检查：", file=sys.stderr)
            for p in problems:
                print("  " + p, file=sys.stderr)
            print("回滚用：git reset --hard origin/cloud", file=sys.stderr)
            return 2

        print("检查通过：无冲突标记，DL.modinfo 引用完整。")

        if args.push:
            p = git("push", "origin", TARGET, check=False)
            print(p.stdout + p.stderr)
            if p.returncode != 0:
                print("推送失败。", file=sys.stderr)
                return 2
            print("已推送 origin/cloud。")
        else:
            print("已合并到本地 cloud（未推送，加 --push 可推）。")
        return 0
    finally:
        if original != TARGET:
            git("checkout", original, check=False)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:  # noqa: BLE001
        print(f"错误：{e}", file=sys.stderr)
        sys.exit(1)
