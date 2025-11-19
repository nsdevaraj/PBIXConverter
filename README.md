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
