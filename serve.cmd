@echo off
chcp 65001 >NUL
title %0

rem start http://127.0.0.1:8000

uv sync -U
echo.
echo markdownlint 正在检查语法...
call markdownlint --fix docs/**/*.md
if errorlevel 1 goto lint_error

rem 预览并在浏览器中打开
uv run zensical serve -o

exit

:lint_error
echo.
echo MarkdownLint 检查到不可修复的语法错误，需手动修复
echo.
pause & exit
