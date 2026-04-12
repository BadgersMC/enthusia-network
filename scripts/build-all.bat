@echo off
REM Build all Enthusia plugins in dependency order.
REM Usage: scripts\build-all.bat [--clean]

cd /d "%~dp0\.."

if "%1"=="--clean" (
    echo == Cleaning all builds...
    call gradlew.bat cleanAll
)

echo == Building composite plugins (Gradle 8.x)...
call gradlew.bat buildAll
if errorlevel 1 goto :fail

echo == Building enthusia-biomes (Gradle 9.x)...
pushd plugins\enthusia-biomes
if exist gradlew.bat (
    call gradlew.bat shadowJar
) else (
    gradle shadowJar
)
if errorlevel 1 goto :fail
popd

echo.
echo === Build Complete ===
goto :eof

:fail
echo BUILD FAILED
exit /b 1
