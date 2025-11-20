# PBIX Converter Utility

A cross-platform utility to convert Power BI (.pbix) files by modifying visual types and removing SecurityBindings.

**Available Formats:**
- 🪟 Windows Batch Script (`pbix.bat`)
- 🐍 Cross-platform Python Script (`pbix_converter.py`)
- 📦 Standalone EXE (via PyInstaller)
- 🎁 Windows Installer Package (via Inno Setup)

## Installation

### Option 1: Windows Installer (Recommended)

Download and run `PBIXConverter_Setup.exe` for a one-click installation that includes:
- All tool files installed to `Program Files`
- Start Menu and optional Desktop shortcuts
- Bulk conversion tool with folder browser
- Optional PATH integration for command-line access

See [INSTALLER_GUIDE.md](INSTALLER_GUIDE.md) for detailed installation instructions.

### Option 2: Standalone EXE (PyInstaller)

Build a single-file executable that packages Python and the converter logic:
1. Install Python 3.x and `pip` on your build machine
2. `pip install pyinstaller` *(or `pip install -r requirements.txt`)*
3. `python build_exe.py` *(or run `pyinstaller pbix_converter.spec`)*
4. Find the output at `dist/pbix_converter.exe`
5. Copy the EXE anywhere and run it:
   ```cmd
   pbix_converter.exe "C:\path\to\file.pbix"
   ```

> **No Python required on target machines!** The EXE includes everything needed.
> 
> See [BUILD_EXE.md](BUILD_EXE.md) for the complete build guide, customization options, and distribution tips.

### Option 3: Manual Installation

Download the three main files and use them directly without installation:
- `pbix.bat`
- `modify_layout.py`
- `create_pbix.py`

> **Tip:** You can also run `pbix_converter.py` directly with Python on Windows, macOS, or Linux:
> ```bash
> python pbix_converter.py "./PowerBI_NativeVisuals.pbix"
> ```

## What it Does

This tool performs the following modifications on PBIX files:

- Removes SecurityBindings file (if present)
- Converts `pivotTable` visuals → `inforiverAppPremium`
- Converts `tableEx` visuals → `inforiverAppPremium`
- Replaces projections `Values` → `ameasure`
- Replaces `Rows` → `rows`
- Replaces `Columns` → `columns`
- Adds publicCustomVisuals declaration

## Prerequisites

- Windows operating system (Windows 10 or later recommended)
- Python 3.x installed and available in PATH
- PowerShell 5.0 or later (built-in on Windows 10+)

## Usage

### Method 1: Using Command Prompt (Recommended)

#### Convert a PBIX File

**Basic conversion** (creates `<filename>_converted.pbix`):

```cmd
pbix.bat "C:\path\to\your\file.pbix"
```

**Specify output filename**:

```cmd
pbix.bat "C:\path\to\input.pbix" "C:\path\to\output.pbix"
```

#### Extract PBIX Contents Only

**Extract to default directory** (creates `<filename>_extracted`):

```cmd
pbix.bat extract "C:\path\to\your\file.pbix"
```

**Extract to specific directory**:

```cmd
pbix.bat extract "C:\path\to\your\file.pbix" "C:\path\to\extract\folder"
```

### Method 2: Using PowerShell

If you prefer to run from PowerShell or need to bypass execution policies:

#### Navigate to the directory and run

```powershell
Set-Location -Path "C:\path\to\pbix\converter"
.\pbix.bat "C:\path\to\your\file.pbix"
```

#### One-liner with execution policy bypass

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-Location -Path 'C:\path\to\pbix\converter'; .\pbix.bat 'C:\path\to\your\file.pbix'"
```

#### With custom output file

```powershell
.\pbix.bat "C:\path\to\input.pbix" "C:\path\to\output.pbix"
```

### Method 3: Standalone Python / EXE (Cross-Platform)

The new `pbix_converter.py` script and the generated `pbix_converter.exe` share the same syntax as the batch file.

#### Run with Python
```bash
python pbix_converter.py "C:\path\to\input.pbix"
python pbix_converter.py "C:\path\to\input.pbix" "C:\path\to\output.pbix"
python pbix_converter.py --extract "C:\path\to\input.pbix" "C:\path\to\extract\folder"
```

#### Run with Standalone EXE
```cmd
pbix_converter.exe "C:\path\to\input.pbix"
pbix_converter.exe "C:\path\to\input.pbix" "C:\path\to\output.pbix"
pbix_converter.exe --extract "C:\path\to\input.pbix"
```

## Command Syntax

### Conversion Mode

```text
pbix.bat <input.pbix> [output.pbix]
```

**Parameters:**

- `input.pbix` - **(Required)** Path to the input PBIX file
- `output.pbix` - **(Optional)** Path for the output file. If not specified, creates `<input>_converted.pbix`

### Extract Mode

```text
pbix.bat extract <input.pbix> [extract_dir]
```

**Parameters:**

- `extract` - **(Required)** Keyword to enable extraction mode
- `input.pbix` - **(Required)** Path to the input PBIX file
- `extract_dir` - **(Optional)** Destination directory. If not specified, creates `<input>_extracted`

## Examples

### Example 1: Convert with Default Output Name

```cmd
pbix.bat "PowerBI_NativeVisuals.pbix"
```

**Result:** Creates `PowerBI_NativeVisuals_converted.pbix`

### Example 2: Convert with Custom Output Name

```cmd
pbix.bat "PowerBI_NativeVisuals.pbix" "PowerBI_Modified.pbix"
```

**Result:** Creates `PowerBI_Modified.pbix`

### Example 3: Extract PBIX Contents

```cmd
pbix.bat extract "PowerBI_NativeVisuals.pbix"
```

**Result:** Creates folder `PowerBI_NativeVisuals_extracted\` with contents

### Example 4: Extract to Specific Folder

```cmd
pbix.bat extract "PowerBI_NativeVisuals.pbix" "MyExtractedFiles"
```

**Result:** Creates folder `MyExtractedFiles\` with contents

### Example 5: Using from Different Directory

```cmd
cd /d C:\Users\YourName\Downloads
C:\path\to\pbix.bat "PowerBI_NativeVisuals.pbix"
```

### Example 6: PowerShell with Full Paths

```powershell
Set-Location -Path "C:\Users\SrikkanthM\Downloads"
.\pbix.bat "PowerBI_NativeVisuals.pbix"
```

### Example 7: Bulk Convert Multiple Files (Installer Only)

If you installed using the Windows installer, you can use the **Bulk Convert PBIX Files** shortcut:

1. Click the **Bulk Convert PBIX Files** shortcut (Desktop or Start Menu)
2. Browse to the folder containing your .pbix files
3. Click OK to start conversion
4. All files will be converted to `<filename>_converted.pbix` in the same folder

**Advantages:**
- No need to run commands for each file
- Visual folder browser
- Progress tracking
- Summary of successful and failed conversions

## Output

### Conversion Mode

The script will display:

- Input and output file paths
- Extraction progress
- SecurityBindings removal status
- Layout file modification steps
- PBIX creation status
- Summary of all changes made

### Extract Mode

The script will:

- Extract all contents from the PBIX file
- Create a directory with the extracted files
- Preserve the internal PBIX structure

## Error Handling

The script will exit with an error message if:

- No input file is specified
- Input file doesn't exist
- Input file doesn't have a `.pbix` extension
- Extraction fails
- Layout file is not found
- Python scripts fail during processing

## Troubleshooting

### "Python is not recognized"

Ensure Python is installed and added to your system PATH.

### "Execution Policy" errors in PowerShell

Run with `-ExecutionPolicy Bypass` flag:

```powershell
powershell.exe -ExecutionPolicy Bypass -File pbix.bat "input.pbix"
```

### "Access Denied" errors

- Ensure the PBIX file is not open in Power BI Desktop
- Check you have write permissions to the output directory
- Run Command Prompt as Administrator if necessary

### Conversion fails

- Verify the PBIX file is not corrupted
- Check that `modify_layout.py` and `create_pbix.py` exist in the same directory
- Ensure you have enough disk space in the TEMP directory

## Technical Details

- Uses PowerShell's `Expand-Archive` for extraction
- Creates temporary directory in `%TEMP%\pbix-converter-*`
- Automatically cleans up temporary files after completion
- Preserves original Layout file encoding (UTF-16LE)
- Creates Windows-compatible ZIP format for output PBIX

## File Structure

```text
PBIXConverter/
├── pbix.bat              # Main batch script (Windows)
├── pbix_converter.py     # Cross-platform CLI entry point / EXE source
├── build_exe.py          # Helper script to build pbix_converter.exe
├── pbix_converter.spec   # PyInstaller spec file
├── modify_layout.py      # Python script for layout modifications
├── create_pbix.py        # Python script for PBIX creation
├── BUILD_EXE.md          # Standalone EXE build guide
└── README.md             # This file
```

## Notes

- The original PBIX file is never modified
- Backup files are created during processing (`.backup` extension)
- All temporary files are automatically cleaned up
- The script requires Python helper scripts to function properly

## Support

If you encounter issues, check that:

1. Python is properly installed and in PATH
2. The helper Python scripts exist in the same directory
3. You have write permissions to the output location
4. The PBIX file is valid and not corrupted
# PBIX Converter Utility

A Windows batch utility to convert Power BI (.pbix) files by modifying visual types and removing SecurityBindings.

## What it Does

This tool performs the following modifications on PBIX files:

- Removes SecurityBindings file (if present)
- Converts `pivotTable` visuals → `inforiverAppPremium`
- Converts `tableEx` visuals → `inforiverAppPremium`
- Replaces projections `Values` → `ameasure`
- Replaces `Rows` → `rows`
- Replaces `Columns` → `columns`
- Adds publicCustomVisuals declaration

## Prerequisites

- Windows operating system (Windows 10 or later recommended)
- Python 3.x installed and available in PATH
- PowerShell 5.0 or later (built-in on Windows 10+)

## Usage

### Method 1: Using Command Prompt (Recommended)

#### Convert a PBIX File

**Basic conversion** (creates `<filename>_converted.pbix`):

```cmd
pbix.bat "C:\path\to\your\file.pbix"
```

**Specify output filename**:

```cmd
pbix.bat "C:\path\to\input.pbix" "C:\path\to\output.pbix"
```

#### Extract PBIX Contents Only

**Extract to default directory** (creates `<filename>_extracted`):

```cmd
pbix.bat extract "C:\path\to\your\file.pbix"
```

**Extract to specific directory**:

```cmd
pbix.bat extract "C:\path\to\your\file.pbix" "C:\path\to\extract\folder"
```

### Method 2: Using PowerShell

If you prefer to run from PowerShell or need to bypass execution policies:

#### Navigate to the directory and run

```powershell
Set-Location -Path "C:\path\to\pbix\converter"
.\pbix.bat "C:\path\to\your\file.pbix"
```

#### One-liner with execution policy bypass

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-Location -Path 'C:\path\to\pbix\converter'; .\pbix.bat 'C:\path\to\your\file.pbix'"
```

#### With custom output file

```powershell
.\pbix.bat "C:\path\to\input.pbix" "C:\path\to\output.pbix"
```

## Command Syntax

### Conversion Mode

```text
pbix.bat <input.pbix> [output.pbix]
```

**Parameters:**

- `input.pbix` - **(Required)** Path to the input PBIX file
- `output.pbix` - **(Optional)** Path for the output file. If not specified, creates `<input>_converted.pbix`

### Extract Mode

```text
pbix.bat extract <input.pbix> [extract_dir]
```

**Parameters:**

- `extract` - **(Required)** Keyword to enable extraction mode
- `input.pbix` - **(Required)** Path to the input PBIX file
- `extract_dir` - **(Optional)** Destination directory. If not specified, creates `<input>_extracted`

## Examples

### Example 1: Convert with Default Output Name

```cmd
pbix.bat "PowerBI_NativeVisuals.pbix"
```

**Result:** Creates `PowerBI_NativeVisuals_converted.pbix`

### Example 2: Convert with Custom Output Name

```cmd
pbix.bat "PowerBI_NativeVisuals.pbix" "PowerBI_Modified.pbix"
```

**Result:** Creates `PowerBI_Modified.pbix`

### Example 3: Extract PBIX Contents

```cmd
pbix.bat extract "PowerBI_NativeVisuals.pbix"
```

**Result:** Creates folder `PowerBI_NativeVisuals_extracted\` with contents

### Example 4: Extract to Specific Folder

```cmd
pbix.bat extract "PowerBI_NativeVisuals.pbix" "MyExtractedFiles"
```

**Result:** Creates folder `MyExtractedFiles\` with contents

### Example 5: Using from Different Directory

```cmd
cd /d C:\Users\YourName\Downloads
C:\path\to\pbix.bat "PowerBI_NativeVisuals.pbix"
```

### Example 6: PowerShell with Full Paths

```powershell
Set-Location -Path "C:\Users\SrikkanthM\Downloads"
.\pbix.bat "PowerBI_NativeVisuals.pbix"
```

## Output

### Conversion Mode

The script will display:

- Input and output file paths
- Extraction progress
- SecurityBindings removal status
- Layout file modification steps
- PBIX creation status
- Summary of all changes made

### Extract Mode

The script will:

- Extract all contents from the PBIX file
- Create a directory with the extracted files
- Preserve the internal PBIX structure

## Error Handling

The script will exit with an error message if:

- No input file is specified
- Input file doesn't exist
- Input file doesn't have a `.pbix` extension
- Extraction fails
- Layout file is not found
- Python scripts fail during processing

## Troubleshooting

### "Python is not recognized"

Ensure Python is installed and added to your system PATH.

### "Execution Policy" errors in PowerShell

Run with `-ExecutionPolicy Bypass` flag:

```powershell
powershell.exe -ExecutionPolicy Bypass -File pbix.bat "input.pbix"
```

### "Access Denied" errors

- Ensure the PBIX file is not open in Power BI Desktop
- Check you have write permissions to the output directory
- Run Command Prompt as Administrator if necessary

### Conversion fails

- Verify the PBIX file is not corrupted
- Check that `modify_layout.py` and `create_pbix.py` exist in the same directory
- Ensure you have enough disk space in the TEMP directory

## Technical Details

- Uses PowerShell's `Expand-Archive` for extraction
- Creates temporary directory in `%TEMP%\pbix-converter-*`
- Automatically cleans up temporary files after completion
- Preserves original Layout file encoding (UTF-16LE)
- Creates Windows-compatible ZIP format for output PBIX

## File Structure

```text
PBIXConverter/
├── pbix.bat              # Main batch script
├── modify_layout.py      # Python script for layout modifications
├── create_pbix.py        # Python script for PBIX creation
└── README.md            # This file
```

## Notes

- The original PBIX file is never modified
- Backup files are created during processing (`.backup` extension)
- All temporary files are automatically cleaned up
- The script requires Python helper scripts to function properly

## Support

If you encounter issues, check that:

1. Python is properly installed and in PATH
2. The helper Python scripts exist in the same directory
3. You have write permissions to the output location
4. The PBIX file is valid and not corrupted
