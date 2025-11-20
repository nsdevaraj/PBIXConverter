# Quick Guide: Build PBIXConverter Installer

## Quick Start (3 Steps)

### 1. Prerequisites
- Install [Inno Setup 6.x](https://jrsoftware.org/isdl.php) (free)
- Ensure all files are in the project directory:
  - `pbix.bat`
  - `modify_layout.py`
  - `create_pbix.py`
  - `README.md`
  - `PBIXTool.iss`

### 2. Compile
1. Open **Inno Setup Compiler**
2. **File → Open** → Select `PBIXTool.iss`
3. Press **F9** or **Build → Compile**

### 3. Get Output
- Find installer in `Output\PBIXConverter_Setup.exe`
- Distribute this single `.exe` file to users

## What the Installer Does

### Installs
✅ All tool files to `C:\Program Files\PBIXConverter`  
✅ Start Menu shortcuts (Command, Bulk Convert, Read Me, Uninstall)  
✅ Optional Desktop shortcut  
✅ Optional PATH integration  
✅ Bulk conversion PowerShell script  

### Features
🎯 **Bulk Convert Tool** - One-click folder browser to convert all .pbix files  
🎯 **PATH Integration** - Optional command-line access from anywhere  
🎯 **Clean Uninstall** - Removes all files and PATH entries  
🎯 **Professional UI** - Modern wizard-style installation  

## Installation Options

During install, users choose:
- ☑️ Installation directory (default: Program Files)
- ☑️ Desktop shortcut for Bulk Converter
- ☑️ Add to system PATH

## Bulk Converter Usage

After installation, users can:

**Method 1: Use Shortcut**
1. Double-click "Bulk Convert PBIX Files" (Desktop or Start Menu)
2. Select folder with .pbix files
3. Watch automatic conversion
4. Get summary report

**Method 2: Command Line** (if added to PATH)
```cmd
pbix.bat "file.pbix"
```

## Customization

Edit `PBIXTool.iss` to customize:

```pascal
#define MyAppVersion "1.0.0"        ; Change version
#define MyAppPublisher "Your Name"   ; Change publisher
DefaultDirName={autopf}\CustomName   ; Change install directory
OutputBaseFilename=CustomName_Setup  ; Change output filename
```

## Troubleshooting

**"Source file not found"**
→ Ensure all files are in same directory as `.iss` file

**"Invalid syntax"**
→ Use Inno Setup 6.x (not 5.x)

**Installer doesn't work**
→ Test Python 3.x is installed on target system

## Complete Documentation

See [INSTALLER_GUIDE.md](INSTALLER_GUIDE.md) for comprehensive details.

## Support

- **Issues**: https://github.com/nsdevaraj/PBIXConverter/issues
- **Docs**: https://github.com/nsdevaraj/PBIXConverter
