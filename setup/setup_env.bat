@echo off
setlocal

REM install python/anaconda, VS Code, Git for Windows, Google Cloud CLI, (and Tableau)
REM Move this file to the intended parent directory

REM Clone GitHub repository
if not exist "Food-Retail-Dashboard-1" (
    git clone https://github.com/YuHsiangHuangSean/Food-Retail-Dashboard-1.git
    if errorlevel 1 goto :error
)

REM Config Git
cd Food-Retail-Dashboard-1 || goto :error
git config --global user.name "Sean Huang"
git config --global user.email "yuhsianghuang.sean@gmail.com"

REM Create Python virtual environment if missing and activate it. Change python path if needed.
if not exist ".venv\Scripts\python.exe" (
    "D:\Anaconda3\python.exe" -m venv .venv
    if errorlevel 1 goto :error
)
call .venv\Scripts\activate.bat
REM .\.venv\Scripts\Activate.ps1 in powershell

REM Upgrade pip
python -m pip install --upgrade pip
if errorlevel 1 goto :error

REM Install required packages
if exist "requirements.txt" (
    python -m pip install -r requirements.txt
) else (
    python -m pip install duckdb dbt-bigquery
)
if errorlevel 1 goto :error

REM Initialize dbt if the project does not exist
if not exist "dbt_food_retail_dashboard_1\dbt_project.yml" (
    call dbt init dbt_food_retail_dashboard_1
    if errorlevel 1 goto :error
)

REM Connect to BigQuery
REM Only initialize if not done so already after downloading Google Cloud CLI
REM call gcloud init
REM if errorlevel 1 goto :error
call gcloud auth application-default login
if errorlevel 1 goto :error

echo.
echo Setup completed
goto :end

:error
echo.
echo Setup failed

:end
pause
endlocal