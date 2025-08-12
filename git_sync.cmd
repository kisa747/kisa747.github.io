@echo off
chcp 65001 >NUL
rem 使用UTF-8编码
::同步远程仓库

rem cp936编码下
rem set dt_1=%date:~0,10%

echo markdownlint 正在语法检查...
call markdownlint --fix docs/**/*.md
if errorlevel 1 goto lint_error
echo.
echo. markdownlint ------------------- Passed
echo.

rem cp65001编码下
set dt_1=%date:~-10%
set dt=%dt_1:/=-%
set now=%dt%_%time%

git fetch && echo fetch成功！ || goto fetch_fail
git status | find "can be fast-forwarded" && git merge FETCH_HEAD
git status | find "Changes not staged for commit" && git status -s && git add *
git status | find "Changes to be committed" && git status -s && git commit -m "%now%" && git merge FETCH_HEAD
git status | find "You have unmerged paths" && goto :unmerged
git status | find "All conflicts fixed but you are still merging" && goto :unmerged
git status | find "Your branch is ahead of" && git push
git status | find "Your branch is up to date with" || goto push_fail
git status | find "working tree clean" || goto not_clean
echo ***********************************************
git status
echo ********************* OK！*********************
echo.
pause & exit

:unmerged
echo.
echo  = = = = 有文件冲突，手动解决冲突后再手动合并！ = = = =
echo.
echo 1、使用 git diff 命令查看冲突的文件
echo 2、修改冲突，确认没有冲突文件
echo 3、重新提交、push。
echo.
pause & exit

:fetch_fail
git status
echo.
echo  = = = = 同步远程仓库失败！确认是否联网！ = = = =
echo.
pause & exit

:push_fail
git status
echo.
echo  = = = = push远程仓库失败！ = = = =
echo.
pause & exit


:not_clean
echo.
echo = = = = working tree not clean！= = = =
echo.
pause & exit


:lint_error
echo.
echo MarkdownLint 检查到不可修复的语法错误，需手动修复
echo.
pause & exit
