# PBIXConverter Installer Build Guide

This guide explains how to build the Inno Setup installer for PBIXConverter.

## Prerequisites

1. **Windows Operating System** - The installer must be built on Windows
2. **Inno Setup 6.x** - Download from [https://jrsoftware.org/isdl.php](https://jrsoftware.org/isdl.php)
3. **PBIXConverter Files** - All tool files must be in the same directory

## Building the Installer

### Step 1: Download/Clone the Repository

```bash
git clone https://github.com/nsdevaraj/PBIXConverter
cd PBIXConverter
```

### Step 2: Verify Required Files

Ensure the following files are present in the project directory:

```
PBIXConverter/
├── pbix.bat              # Main batch script
├── modify_layout.py      # Python script for layout modifications
├── create_pbix.py        # Python script for PBIX creation
├── README.md            # Documentation
└── PBIXTool.iss         # Inno Setup installer script
```

### Step 3: Open and Compile

1. **Open Inno Setup Compiler**
2. **File → Open** → Select `PBIXTool.iss`
3. **Build → Compile** (or press F9)

The compiler will:
- Validate the script
- Create the `Output` subdirectory (if it doesn't exist)
- Generate `PBIXConverter_Setup.exe` in the `Output` folder

### Step 4: Test the Installer

1. Navigate to the `Output` folder
2. Run `PBIXConverter_Setup.exe`
3. Follow the installation wizard
4. Test the installed application

## Installer Features

### What Gets Installed

The installer deploys the following:

1. **Core Files** (in `C:\Program Files\PBIXConverter` or user-selected directory):
   - `pbix.bat` - Main conversion tool
   - `modify_layout.py` - Layout modification script
   - `create_pbix.py` - PBIX creation script
   - `README.md` - Documentation
   - `BulkConvertPBIX.ps1` - Bulk processing helper script (generated during install)

2. **Start Menu Shortcuts**:
   - **PBIXConverter Command** - Opens command prompt in tool directory
   - **Bulk Convert PBIX Files** - One-click bulk converter with folder browser
   - **Read Me** - Opens documentation
   - **Uninstall** - Removes the application

3. **Desktop Shortcut** (optional):
   - **Bulk Convert PBIX Files** - Quick access to bulk converter

4. **System PATH** (optional):
   - Adds PBIXConverter directory to Windows PATH for command-line access

### Installation Options

During installation, users can choose:

1. **Installation Directory** - Default: `C:\Program Files\PBIXConverter`
2. **Desktop Icon** - Create desktop shortcut for bulk converter
3. **Add to PATH** - Add tool to system PATH for command-line usage

## What Users Get After Installation

### Command-Line Usage

If added to PATH, users can run from any directory:

```cmd
pbix.bat "C:\path\to\file.pbix"
```

### Bulk Convert Tool

The **Bulk Convert PBIX Files** shortcut provides:
1. **Folder Browser** - GUI to select folder containing .pbix files
2. **Automatic Processing** - Finds and converts all .pbix files in the folder
3. **Progress Display** - Shows real-time conversion status in console
4. **Summary Report** - Displays count of successful and failed conversions
5. **Error Handling** - Continues processing even if some files fail

Each file is converted to `<original_name>_converted.pbix` in the same folder.

### Example Bulk Conversion Flow

1. Double-click **Bulk Convert PBIX Files** shortcut
2. Select folder containing PBIX files
3. Click OK to start
4. Watch progress in PowerShell window
5. View summary when complete
6. Check folder for `*_converted.pbix` files

## Customization

### Modify Installer Settings

Edit `PBIXTool.iss` to customize:

**Application Info** (lines 6-11):
```pascal
#define MyAppName "PBIXConverter with Bulk Processing"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "nsdevaraj"
#define MyAppURL "https://github.com/nsdevaraj/PBIXConverter"
```

**Installation Defaults** (lines 21-22):
```pascal
DefaultDirName={autopf}\PBIXConverter
DefaultGroupName=PBIXConverter
```

**Output Settings** (lines 24-25):
```pascal
OutputDir=Output
OutputBaseFilename=PBIXConverter_Setup
```

### Add Custom Icon

1. Create or obtain an `.ico` file for your installer
2. Place it in the project directory (e.g., `PBIXConverter.ico`)
3. Update line 26 in `PBIXTool.iss`:
   ```pascal
   SetupIconFile=PBIXConverter.ico
   ```

### Add License File

1. Create a license file (e.g., `LICENSE.txt`)
2. Place it in the project directory
3. Update line 31 in `PBIXTool.iss`:
   ```pascal
   LicenseFile=LICENSE.txt
   ```

## Advanced Features

### Bulk Conversion Script Details

The installer automatically generates `BulkConvertPBIX.ps1` with these features:

- **Folder Browser Dialog** - Native Windows folder selection
- **File Filtering** - Only processes `.pbix` files
- **Error Handling** - Tracks success/failure for each file
- **Progress Tracking** - Real-time console output with colored status indicators
- **Summary Statistics** - Final report showing:
  - Total files converted
  - Total files failed
  - Location of output files

### PATH Management

**During Installation:**
- Checks if PATH already contains the installation directory
- Only adds to PATH if not already present
- Uses registry-based approach for reliability

**During Uninstallation:**
- Automatically removes installation directory from PATH
- Cleans up all variations (`;path`, `path;`, `path`)

## Troubleshooting

### Compilation Errors

**Error: "Source file not found"**
- Ensure all required files are in the same directory as `PBIXTool.iss`
- Check file names match exactly (case-sensitive on some systems)

**Error: "Invalid AppId"**
- Each installation must have a unique GUID
- Generate new GUID if creating a fork or variant

### Installation Issues

**"Python is not recognized" after installation**
- Python 3.x must be installed separately
- User must add Python to their PATH

**Shortcuts don't work**
- Verify PowerShell execution policy allows script execution
- Right-click shortcut → Properties → check Parameters field

### Uninstallation Issues

**PATH not cleaned up**
- May require manual removal from System Environment Variables
- Requires administrator privileges to modify system PATH

## Requirements for End Users

After installation, users need:

1. **Python 3.x** - Must be installed and in PATH
   - Download from [python.org](https://www.python.org/)
   - Check "Add Python to PATH" during installation

2. **PowerShell 5.0+** - Built-in on Windows 10 and later
   - Check version: `$PSVersionTable.PSVersion`

3. **Administrator Rights** - Only needed if:
   - Installing to `Program Files` directory
   - Adding tool to system PATH

## Support and Issues

- **GitHub Issues**: [https://github.com/nsdevaraj/PBIXConverter/issues](https://github.com/nsdevaraj/PBIXConverter/issues)
- **Documentation**: See `README.md` in installation directory
- **Source Code**: [https://github.com/nsdevaraj/PBIXConverter](https://github.com/nsdevaraj/PBIXConverter)

## Version History

### Version 1.0.0
- Initial installer release
- Bulk conversion capability
- PATH integration
- Desktop and Start Menu shortcuts
- Automatic uninstaller with PATH cleanup

## License

This installer script is part of the PBIXConverter project. See the main repository for license information.
