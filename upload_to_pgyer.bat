@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo 上传IPA到蒲公英
echo ========================================

:: 蒲公英配置
set PGYER_API_KEY=你的蒲公英API_KEY
set PGYER_USER_KEY=你的蒲公英USER_KEY
set PGYER_APP_KEY=你的蒲公英APP_KEY

:: 从pubspec.yaml读取版本号
for /f "tokens=2 delims=: " %%i in ('findstr /C:"version:" pubspec.yaml') do set VERSION=%%i
set VERSION=%VERSION: =%

:: IPA文件路径
set IPA_NAME=canknow_aggregate_app-%VERSION%-release.ipa
set IPA_PATH=build\ios\ipa\%IPA_NAME%

echo 版本号: %VERSION%
echo IPA文件: %IPA_NAME%
echo.

:: 检查IPA文件是否存在
if not exist "%IPA_PATH%" (
    echo 错误: IPA文件不存在: %IPA_PATH%
    echo 请先运行 build_ios.bat 构建IPA文件
    pause
    exit /b 1
)

echo [1/3] 检查文件...
for %%A in ("%IPA_PATH%") do (
    echo IPA文件大小: %%~zA 字节
    echo 文件路径: %%~fA
)

echo.
echo [2/3] 上传到蒲公英...

:: 构建上传URL
set UPLOAD_URL=https://www.pgyer.com/apiv2/app/upload

:: 使用curl上传
echo 正在上传，请稍候...
call curl.exe -F "file=@%IPA_PATH%" -F "_api_key=%PGYER_API_KEY%" -F "buildInstallType=2" -F "buildPassword=123456" -F "buildUpdateDescription=版本%VERSION%更新" "%UPLOAD_URL%"

if %errorlevel% neq 0 (
    echo 错误: 上传失败
    echo 请检查网络连接和API配置
    pause
    exit /b 1
)

echo.
echo [3/3] 上传完成！

echo.
echo ========================================
echo 上传成功！
echo ========================================
echo 应用版本: %VERSION%
echo IPA文件: %IPA_NAME%
echo 蒲公英链接: https://www.pgyer.com/%PGYER_APP_KEY%
echo ========================================

:: 自动打开蒲公英页面
echo 正在打开蒲公英页面...
start https://www.pgyer.com/%PGYER_APP_KEY%

echo.
echo 脚本执行完成，按任意键退出...
pause 