#!/usr/bin/env bash
# 这是一个shell脚本

cd "$(dirname "$0")" # 进入当前脚本所在目录
# 脚本只要发生错误，就终止执行。
set -e

echo "Autocorrect 检查文档错误并尝试修复"

#autocorrect --lint kisa747.github.io/docs/**/*.md
autocorrect --lint docs/

#autocorrect --fix kisa747.github.io/docs/**/*.md
autocorrect --fix docs/

echo "脚本将在 10 秒后退出..."
sleep 10

exit
