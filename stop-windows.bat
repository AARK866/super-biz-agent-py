@echo off
chcp 65001 >nul
echo ====================================
echo 停止 SuperBizAgent 服务
echo ====================================
echo.

REM 停止 FastAPI 服务
echo [1/4] 停止 FastAPI 服务...
taskkill /FI "WINDOWTITLE eq SuperBizAgent API*" /F >nul 2>&1
for /f "tokens=5" %%p in ('netstat -ano ^| findstr /R /C:":9900 .*LISTENING"') do taskkill /PID %%p /T /F >nul 2>&1
echo [成功] FastAPI 服务已停止或未运行
echo.

REM 停止 CLS MCP 服务
echo [2/4] 停止 CLS MCP 服务...
taskkill /FI "WINDOWTITLE eq CLS MCP Server*" /F >nul 2>&1
for /f "tokens=5" %%p in ('netstat -ano ^| findstr /R /C:":8003 .*LISTENING"') do taskkill /PID %%p /T /F >nul 2>&1
echo [成功] CLS MCP 服务已停止或未运行
echo.

REM 停止 Monitor MCP 服务
echo [3/4] 停止 Monitor MCP 服务...
taskkill /FI "WINDOWTITLE eq Monitor MCP Server*" /F >nul 2>&1
for /f "tokens=5" %%p in ('netstat -ano ^| findstr /R /C:":8004 .*LISTENING"') do taskkill /PID %%p /T /F >nul 2>&1
echo [成功] Monitor MCP 服务已停止或未运行
echo.

REM 停止 Docker 容器
echo [4/4] 停止 Milvus 容器...
docker compose -f vector-database.yml down
if errorlevel 1 (
    echo [错误] Docker 容器停止失败
) else (
    echo [成功] Milvus 容器已停止
)
echo.

echo ====================================
echo 所有服务已停止！
echo ====================================
echo.
echo 提示:
echo   - 数据保存在项目专用 Docker 命名卷中，普通停止不会删除数据
echo   - 请勿随意使用 down -v 或 docker volume prune
echo.
pause
