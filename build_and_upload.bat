@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo 任务打卡APP - 构建并上传脚本
echo ========================================

:: 设置变量
set APP_NAME=canknow_aggregate_app

:: 从pubspec.yaml读取版本号
for /f "tokens=2 delims=: " %%i in ('findstr /C:"version:" pubspec.yaml') do set VERSION=%%i
set VERSION=%VERSION: =%

:: 简化APK文件名，只使用版本号
set APK_NAME=%APP_NAME%-%VERSION%-arm64-release.apk
set APK_PATH=build\app\outputs\flutter-apk\%APK_NAME%
set CODING_URL=https://one-zero-sky-success-generic.pkg.coding.net/canknow-aggregate-laboratory/generic
set USERNAME=3230525823@qq.com
set PASSWORD=Lianhubo131314@

echo 应用名称: %APP_NAME%
echo 版本号: %VERSION%
echo APK文件名: %APK_NAME%
echo.

:: 检查Flutter环境
echo [1/5] 检查Flutter环境...
call flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未找到Flutter环境，请确保Flutter已正确安装并添加到PATH
    pause
    exit /b 1
)
echo Flutter环境检查通过

:: 清理之前的构建
echo.
echo [2/5] 清理之前的构建...
call flutter clean
if %errorlevel% neq 0 (
    echo 错误: 清理失败
    pause
    exit /b 1
)
echo 清理完成

:: 获取依赖
echo.
echo [3/5] 获取依赖包...
call flutter pub get
if %errorlevel% neq 0 (
    echo 错误: 获取依赖失败
    pause
    exit /b 1
)
echo 依赖获取完成

:: 构建APK
echo.
echo [4/5] 构建APK...
echo 构建命令: flutter build apk --release --target-platform=android-arm64
call flutter build apk --release --target-platform=android-arm64
if %errorlevel% neq 0 (
    echo 错误: APK构建失败
    pause
    exit /b 1
)

:: 检查APK文件是否存在并重命名
set ORIGINAL_APK=build\app\outputs\flutter-apk\app-release.apk
if not exist "%ORIGINAL_APK%" (
    echo 错误: APK文件未找到: %ORIGINAL_APK%
    echo 请检查构建输出目录
    pause
    exit /b 1
)

:: 重命名APK文件
copy "%ORIGINAL_APK%" "%APK_PATH%" >nul
if %errorlevel% neq 0 (
    echo 错误: 重命名APK文件失败
    pause
    exit /b 1
)
echo APK构建完成: %APK_PATH%

:: 显示APK文件信息
for %%A in ("%APK_PATH%") do (
    echo APK文件大小: %%~zA 字节
)

:: 上传到Coding制品库
echo.
echo [5/5] 上传到Coding制品库...
echo 上传URL: %CODING_URL%/%APK_NAME%?version=%VERSION%

:: 使用curl上传
set UPLOAD_URL=%CODING_URL%/%APK_NAME%?version=%VERSION%
call curl.exe -T "%APK_PATH%" -u "%USERNAME%:%PASSWORD%" "%UPLOAD_URL%"
if %errorlevel% neq 0 (
    echo 错误: 上传失败
    echo 请检查网络连接和认证信息
    pause
    exit /b 1
)

echo.
echo ========================================
echo 构建并上传完成！
echo ========================================
echo 应用名称: %APP_NAME%
echo 版本号: %VERSION%
echo APK文件: %APK_NAME%
echo 文件路径: %APK_PATH%
echo 制品库URL: %CODING_URL%/%APK_NAME%?version=%VERSION%
echo ========================================

:: 自动打开APK文件所在文件夹
echo 正在打开APK文件所在文件夹...
explorer /select,"%APK_PATH%"

echo.
echo 脚本执行完成，按任意键退出...
pause 