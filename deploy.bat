@echo off
chcp 65001 >nul
setlocal

set BLOG_DIR=E:\hexo-blog
set PATH=C:\Program Files\Git\bin;C:\Program Files\nodejs;C:\Users\zszsb\AppData\Roaming\npm;%PATH%

cd /d "%BLOG_DIR%"

echo ============================================
echo   网工学习笔记 - 一键部署
echo ============================================
echo.

:: 1. 本地构建验证
echo [1/3] 正在本地构建验证...
call hexo clean >nul 2>&1
call hexo generate
if %errorlevel% neq 0 (
    echo [错误] 本地构建失败，请检查文章内容！
    pause
    exit /b 1
)
echo [1/3] 本地构建成功 ✓
echo.

:: 2. Git 提交
echo [2/3] 正在提交到 Git...
git add .
git status --short

:: 如果有改动则提交，否则跳过
for /f %%i in ('git status --porcelain') do set HAS_CHANGES=1
if defined HAS_CHANGES (
    set /p COMMIT_MSG="请输入提交说明（直接回车使用默认）: "
    if "!COMMIT_MSG!"=="" set COMMIT_MSG=更新博客内容 %date:~0,10%
    git commit -m "!COMMIT_MSG!"
    echo [2/3] 已提交 ✓
) else (
    echo [2/3] 没有需要提交的改动
)
echo.

:: 3. 推送到 GitHub
echo [3/3] 正在推送到 GitHub...
git push origin main
if %errorlevel% neq 0 (
    echo [错误] 推送失败，请检查网络或 GitHub 连接！
    pause
    exit /b 1
)
echo [3/3] 推送成功 ✓
echo.
echo ============================================
echo   部署完成！Netlify 将自动构建并发布
echo   博客地址: https://fluffy-wisp-8111b3.netlify.app
echo ============================================
echo.
pause
