@echo off
set "PBIX_MOD_DIR=%~dp0"
setlocal enabledelayedexpansion

REM PBIX Converter Utility
REM Converts PBIX files by modifying visual types and removing SecurityBindings

if /i "%~1"=="extract" (
    set "EXTRACT_ONLY=1"
    set "INPUT_FILE=%~f2"
    if "%~3"=="" (
        set "EXTRACT_DIR=%~dpn2_extracted"
    ) else (
        set "EXTRACT_DIR=%~3"
    )
) else (
    set "EXTRACT_ONLY=0"
    set "INPUT_FILE=%~f1"
    if "%~2"=="" (
        set "OUTPUT_FILE=%~dpn1_converted.pbix"
    ) else (
        set "OUTPUT_FILE=%~2"
    )
)

REM Check if input file is provided
if "%INPUT_FILE%"=="" (
    echo [ERROR] No input file specified.
    call :usage
    exit /b 1
)

REM Check if input file exists
if not exist "!INPUT_FILE!" (
    echo [ERROR] Input file '!INPUT_FILE!' not found
    exit /b 1
)

REM Check if input file is a PBIX file
for %%i in ("!INPUT_FILE!") do (
    if /i not "%%~xi"==".pbix" (
        echo [ERROR] Input file must have .pbix extension
        exit /b 1
    )
)

REM Determine output file name for conversion
if "!EXTRACT_ONLY!"=="0" (
    if "%~2"=="" (
        set "OUTPUT_FILE=%~dpn1_converted.pbix"
    ) else (
        set "OUTPUT_FILE=%~2"
    )
    for %%i in ("!OUTPUT_FILE!") do set "OUTPUT_FILE=%%~fi"
)

if "!EXTRACT_ONLY!"=="1" (
    echo [INFO] Starting PBIX extraction
    echo [INFO] Input file: !INPUT_FILE!
    echo [INFO] Output directory: !EXTRACT_DIR!
) else (
    echo [INFO] Starting PBIX conversion
    echo [INFO] Input file: !INPUT_FILE!
    echo [INFO] Output file: !OUTPUT_FILE!
)


REM Create temporary directory
set "TEMP_DIR=%TEMP%\pbix-converter-%RANDOM%%RANDOM%"
mkdir "!TEMP_DIR!"

echo [INFO] Created temporary directory: !TEMP_DIR!

REM Step 1-2: Extract PBIX file
echo [INFO] Step 1-2: Extracting PBIX file...
cd /d "!TEMP_DIR!"

REM Use PowerShell to unzip (available on Windows 10+)
set "TEMP_ZIP_FILE=%TEMP_DIR%\temp.zip"
copy "!INPUT_FILE!" "!TEMP_ZIP_FILE!"

set "EXTRACT_SUCCESS=0"
echo [INFO] Attempting to extract PBIX file...
powershell -Command "Expand-Archive -Path '!TEMP_ZIP_FILE!' -DestinationPath '.' -Force"
if errorlevel 1 (
    echo [ERROR] Expand-Archive failed.
) else (
    echo [DEBUG] Expand-Archive succeeded.
    set "EXTRACT_SUCCESS=1"
)

del "!TEMP_ZIP_FILE!"

if !EXTRACT_SUCCESS! == 0 (
    echo [ERROR] Failed to extract PBIX file.
    cd /d "%~dp0"
    rmdir /s /q "!TEMP_DIR!"
    exit /b 1
)

if "!EXTRACT_ONLY!"=="1" (
    echo [INFO] Moving extracted files to !EXTRACT_DIR!
    cd /d "%~dp0"
    if exist "!EXTRACT_DIR!" (
        rmdir /s /q "!EXTRACT_DIR!"
    )
    mkdir "!EXTRACT_DIR!"
    move "!TEMP_DIR!\*" "!EXTRACT_DIR!" > nul
    echo [INFO] ✓ Extraction complete.
    rmdir /s /q "!TEMP_DIR!"
    exit /b 0
)

REM Step 3: Remove SecurityBindings file
echo [INFO] Step 3: Removing SecurityBindings file...
if exist "SecurityBindings" (
    del /f /q "SecurityBindings"
    echo [INFO] SecurityBindings file removed
) else (
    echo [WARNING] SecurityBindings file not found (this may be expected)
)

REM Step 4-5: Edit Layout file
echo [INFO] Step 4-5: Modifying Layout file...
set "LAYOUT_FILE=Report\Layout"

if exist "!LAYOUT_FILE!" (
    REM Create backup
    copy "!LAYOUT_FILE!" "!LAYOUT_FILE!.backup" >nul

    REM Convert UTF-16LE to UTF-8, perform replacements, and convert back using Python
    echo [INFO]   - Converting Layout from UTF-16LE to UTF-8...
    echo [INFO]   - Replacing pivotTable visual type...
    echo [INFO]   - Replacing tableEx visual type...
    echo [INFO]   - Replacing projections Values with ameasure...
    echo [INFO]   - Replacing Rows with rows...
    echo [INFO]   - Replacing Columns with columns...
    echo [INFO]   - Adding publicCustomVisuals declaration...
    echo [INFO]   - Converting Layout back to UTF-16LE...

    python "!PBIX_MOD_DIR!\\modify_layout.py" "!LAYOUT_FILE!"

    if errorlevel 1 (
        echo [ERROR] Failed to modify Layout file
        cd /d "%~dp0"
        rmdir /s /q "!TEMP_DIR!"
        exit /b 1
    )

    echo [INFO] Layout file modified successfully
) else (
    echo [ERROR] Layout file not found at !LAYOUT_FILE!
    cd /d "%~dp0"
        rmdir /s /q "!TEMP_DIR!"
    exit /b 1
)

REM Step 6: Create new PBIX file
echo [INFO] Step 6: Creating new PBIX file...

REM Remove old output file if it exists
if exist "!OUTPUT_FILE!" del /f /q "!OUTPUT_FILE!"

REM Create PBIX using Python to ensure Windows-compatible ZIP format
python "!PBIX_MOD_DIR!\\create_pbix.py" "!OUTPUT_FILE!" "."

if errorlevel 1 (
    echo [ERROR] Failed to create PBIX file
    cd /d "%~dp0"
    rmdir /s /q "!TEMP_DIR!"
    exit /b 1
)

echo [INFO] ✓ Conversion completed successfully!
echo [INFO] Output file: !OUTPUT_FILE!
echo.
echo Summary of changes:
echo   - SecurityBindings file removed (if present)
echo   - pivotTable visuals -^> inforiverAppPremium
echo   - tableEx visuals -^> inforiverAppPremium
echo   - projections Values -^> ameasure
echo   - Rows -^> rows
echo   - Columns -^> columns

REM Cleanup
echo [INFO] Cleaning up temporary files...
cd /d "%~dp0"
rmdir /s /q "!TEMP_DIR!"

exit /b 0

:usage
    echo Usage: %~nx0 ^<input.pbix^> [output.pbix]
    echo   or
    echo Usage: %~nx0 extract ^<input.pbix^> [extract_dir]
    echo.
    echo Arguments:
    echo   input.pbix    - Path to the input PBIX file.
    echo   output.pbix   - (Optional) Path to the output PBIX file for conversion.
    echo                   If not specified, creates '^<input^>_converted.pbix'.
    echo   extract_dir   - (Optional) Directory to extract files to.
    echo                   If not specified, creates '^<input^>_extracted'.
    echo.
    echo Examples:
    echo   %~nx0 myreport.pbix
    echo   %~nx0 myreport.pbix myreport_modified.pbix
    echo   %~nx0 extract myreport.pbix
    echo   %~nx0 extract myreport.pbix my_extracted_files
    exit /b 1
