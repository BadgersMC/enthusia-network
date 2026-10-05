@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM Build all Enthusia plugins in dependency order.
REM Requires: Git, Maven, Python 3, and discoverable JDKs 21 and 25.
REM Tags verification also requires Git Bash and Node.js.
REM Display compile dependencies: see ci/enthusia-display/README.md.
REM Usage: scripts\build-all.bat [--clean]

cd /d "%~dp0\.."
set "COMBATLOGX_API_REF=4812e85af1264ebb27da481b9d9cbf8de0956e53"
set "NEXUS_REF=057836befb9e35aa252cf90104030ec86f28b33f"
set "DEPS_DIR=%CD%\build\deps"

echo === Enthusia Network Build ===

if "%1"=="--clean" (
    echo ^>^> Cleaning composite builds...
    call gradlew.bat cleanAll
    if errorlevel 1 goto :fail
)

echo ^>^> Building Maven plugin dependencies...
for %%P in (diary-keeper enthusia-currency playtime-plugin enthusia-commend) do (
    echo    - %%P
    pushd "plugins\%%P"
    call mvn -q -B package -DskipTests
    set "STEP_ERROR=!ERRORLEVEL!"
    popd
    if not "!STEP_ERROR!"=="0" goto :fail
)

set "ENTHUSIAPLAYTIME_JAR="
for /f "delims=" %%F in ('powershell -NoProfile -Command "$jars=@(Get-ChildItem -LiteralPath 'plugins\playtime-plugin\target' -Filter 'playtime-plugin-*.jar' ^| Where-Object { $_.Name -notlike '*-sources.jar' -and $_.Name -notlike '*-javadoc.jar' }); if($jars.Count -ne 1){exit 1}; $jars[0].FullName"') do set "ENTHUSIAPLAYTIME_JAR=%%F"
if not defined ENTHUSIAPLAYTIME_JAR (
    echo Expected one current Playtime artifact; clean its target directory before building.
    goto :fail
)

echo ^>^> Staging EnthusiaPlaytime API for LumaGuilds...
REM Build Tags before continuing so a successful network build cannot omit it.
where bash >nul 2>nul
if errorlevel 1 (
    echo Git Bash is required for scripts/build-tags.sh
    goto :fail
)
call bash scripts/build-tags.sh
if errorlevel 1 goto :fail

if exist "%DEPS_DIR%\playtime-api" rmdir /S /Q "%DEPS_DIR%\playtime-api"
mkdir "%DEPS_DIR%\playtime-api" 2>nul
if not exist "plugins\luma-guilds\libs" mkdir "plugins\luma-guilds\libs"
javac -d "%DEPS_DIR%\playtime-api" ^
    plugins\playtime-plugin\src\main\java\org\enthusia\playtime\api\PlaytimeService.java ^
    plugins\playtime-plugin\src\main\java\org\enthusia\playtime\api\PlaytimeRange.java ^
    plugins\playtime-plugin\src\main\java\org\enthusia\playtime\api\PlaytimeMetric.java ^
    plugins\playtime-plugin\src\main\java\org\enthusia\playtime\activity\ActivityState.java ^
    plugins\playtime-plugin\src\main\java\org\enthusia\playtime\data\model\PlaytimeSnapshot.java ^
    plugins\playtime-plugin\src\main\java\org\enthusia\playtime\data\model\RangeTotals.java
if errorlevel 1 goto :fail
jar cf "plugins\luma-guilds\libs\EnthusiaPlaytime-api.jar" -C "%DEPS_DIR%\playtime-api" .
if errorlevel 1 goto :fail

echo ^>^> Staging CombatLogX API for LumaGuilds...
if not exist "%DEPS_DIR%\combatlogx\.git" (
    if exist "%DEPS_DIR%\combatlogx" rmdir /S /Q "%DEPS_DIR%\combatlogx"
    git clone https://github.com/SirBlobman/CombatLogX.git "%DEPS_DIR%\combatlogx"
    if errorlevel 1 goto :fail
)
git -C "%DEPS_DIR%\combatlogx" fetch origin %COMBATLOGX_API_REF%
if errorlevel 1 goto :fail
git -C "%DEPS_DIR%\combatlogx" checkout --detach %COMBATLOGX_API_REF%
if errorlevel 1 goto :fail
pushd "%DEPS_DIR%\combatlogx"
call gradlew.bat :api:jar --no-daemon
set "STEP_ERROR=!ERRORLEVEL!"
popd
if not "!STEP_ERROR!"=="0" goto :fail
set "COMBATLOGX_JAR="
for /f "delims=" %%F in ('powershell -NoProfile -Command "Get-ChildItem -Path '%DEPS_DIR%\combatlogx\api\build\libs' -Filter '*.jar' ^| Where-Object { $_.Name -notlike '*-sources.jar' -and $_.Name -notlike '*-javadoc.jar' } ^| Select-Object -First 1 -ExpandProperty FullName"') do set "COMBATLOGX_JAR=%%F"
if not defined COMBATLOGX_JAR (
    echo CombatLogX API build produced no jar
    goto :fail
)
copy /Y "%COMBATLOGX_JAR%" "plugins\luma-guilds\libs\CombatLogX-api.jar" >nul

echo ^>^> Building canonical Enthusia RoseChat...
pushd "plugins\rosechat"
call gradlew.bat shadowJar --no-daemon
set "STEP_ERROR=!ERRORLEVEL!"
popd
if not "!STEP_ERROR!"=="0" goto :fail
set "ROSECHAT_JAR="
for /f "delims=" %%F in ('powershell -NoProfile -Command "Get-ChildItem -Path 'plugins\rosechat\build\libs' -Filter 'RoseChat-*.jar' ^| Select-Object -First 1 -ExpandProperty FullName"') do set "ROSECHAT_JAR=%%F"
if not defined ROSECHAT_JAR (
    echo RoseChat build produced no shaded jar
    goto :fail
)
copy /Y "%ROSECHAT_JAR%" "plugins\luma-guilds\libs\RoseChat-RC-2.jar" >nul
set "ENTHUSIADISPLAY_ROSECHAT_BUILT=true"

echo ^>^> Building LumaGuilds 3 core artifact...
pushd "plugins\luma-guilds"
call gradlew.bat shadowJar --no-daemon
set "STEP_ERROR=!ERRORLEVEL!"
popd
if not "!STEP_ERROR!"=="0" goto :fail
set "LUMAGUILDS_JAR="
for /f "delims=" %%F in ('powershell -NoProfile -Command "Get-ChildItem -Path 'plugins\luma-guilds\build\libs' -Filter 'LumaGuilds-*.jar' ^| Where-Object { $_.Name -notlike '*-sources.jar' -and $_.Name -notlike '*-javadoc.jar' } ^| Select-Object -First 1 -ExpandProperty FullName"') do set "LUMAGUILDS_JAR=%%F"
if not defined LUMAGUILDS_JAR (
    echo LumaGuilds build produced no shaded jar
    goto :fail
)

echo ^>^> Publishing Nexus 2.3.0 dependency locally...
if not exist "%DEPS_DIR%\nexus\.git" (
    if exist "%DEPS_DIR%\nexus" rmdir /S /Q "%DEPS_DIR%\nexus"
    git clone https://github.com/BadgersMC/Nexus.git "%DEPS_DIR%\nexus"
    if errorlevel 1 goto :fail
)
git -C "%DEPS_DIR%\nexus" fetch origin %NEXUS_REF%
if errorlevel 1 goto :fail
git -C "%DEPS_DIR%\nexus" checkout --detach %NEXUS_REF%
if errorlevel 1 goto :fail
pushd "%DEPS_DIR%\nexus"
call gradlew.bat publishToMavenLocal --no-daemon
set "STEP_ERROR=!ERRORLEVEL!"
popd
if not "!STEP_ERROR!"=="0" goto :fail
set "USE_MAVEN_LOCAL_NEXUS=true"

echo ^>^> Building EnthusiaMarket 26.2 artifact...
pushd "plugins\enthusia-market"
call gradlew.bat shadowJar -PuseMavenLocal=true --no-daemon
set "STEP_ERROR=!ERRORLEVEL!"
popd
if not "!STEP_ERROR!"=="0" goto :fail
set "ENTHUSIAMARKET_JAR="
for /f "delims=" %%F in ('powershell -NoProfile -Command "Get-ChildItem -Path 'plugins\enthusia-market\build\libs' -Filter 'EnthusiaMarket-*.jar' ^| Where-Object { $_.Name -notlike '*-sources.jar' -and $_.Name -notlike '*-javadoc.jar' } ^| Select-Object -First 1 -ExpandProperty FullName"') do set "ENTHUSIAMARKET_JAR=%%F"
if not defined ENTHUSIAMARKET_JAR (
    echo EnthusiaMarket build produced no shaded jar
    goto :fail
)

echo ^>^> Building composite plugins...
call gradlew.bat buildAll
if errorlevel 1 goto :fail

echo ^>^> Building enthusia-biomes...
pushd "plugins\enthusia-biomes"
if exist gradlew.bat (
    call gradlew.bat shadowJar
) else (
    gradle shadowJar
)
set "STEP_ERROR=!ERRORLEVEL!"
popd
if not "!STEP_ERROR!"=="0" goto :fail

echo.
echo === Build Complete ===
exit /b 0

:fail
echo BUILD FAILED
exit /b 1
