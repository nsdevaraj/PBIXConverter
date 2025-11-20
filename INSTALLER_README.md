# PBIXConverter Installer Package

## 📦 Complete Installer Solution

This repository now includes a professional Windows installer for the PBIXConverter tool, built with Inno Setup.

## 🎯 What You Get

### Single-File Installer
- **File:** `PBIXConverter_Setup.exe` (built from `PBIXTool.iss`)
- **Size:** ~20-50 KB
- **Platform:** Windows 10/11 (32-bit and 64-bit)
- **Requirements:** Admin rights for system installation

### Installation Includes
1. **Core Tools** → `C:\Program Files\PBIXConverter`
   - pbix.bat
   - modify_layout.py
   - create_pbix.py
   - README.md
   - BulkConvertPBIX.ps1 (bulk processor)

2. **Start Menu Shortcuts**
   - PBIXConverter Command
   - Bulk Convert PBIX Files ⭐
   - Read Me
   - Uninstall

3. **Optional Features**
   - Desktop shortcut
   - System PATH integration

## 🚀 Quick Start

### For End Users
```
1. Download PBIXConverter_Setup.exe
2. Run installer
3. Follow wizard
4. Use shortcuts to convert files
```

### For Developers
```
1. Install Inno Setup 6.x
2. Open PBIXTool.iss
3. Press F9 to compile
4. Get installer from Output/PBIXConverter_Setup.exe
```

## 📚 Documentation Structure

| File | Purpose | Audience |
|------|---------|----------|
| **README.md** | Main user documentation | End Users |
| **INSTALLER_GUIDE.md** | Comprehensive installer guide | Developers |
| **BUILD_INSTALLER.md** | Quick build instructions | Developers |
| **RELEASE_NOTES.md** | Version 1.0.0 features | All |
| **RELEASE_CHECKLIST.md** | Pre-release verification | Maintainers |
| **INSTALLER_README.md** | This file - package overview | All |

## 🎨 Key Features

### 1. Bulk Conversion Tool ⭐
The killer feature - convert entire folders of .pbix files with one click!

**How it works:**
```
Desktop/Start Menu → Bulk Convert PBIX Files
    ↓
Select folder with .pbix files
    ↓
Automatic conversion of all files
    ↓
Summary: X converted, Y failed
```

**Behind the scenes:**
- PowerShell script with GUI folder browser
- Processes each .pbix file sequentially
- Creates `<filename>_converted.pbix` for each file
- Shows real-time progress with colors
- Counts successes and failures

### 2. Professional Installation
- Modern wizard UI
- Custom installation directory
- Optional desktop shortcut
- Optional PATH integration
- Clean uninstallation

### 3. Smart PATH Management
- Checks if already in PATH
- Only adds if needed
- Removes on uninstall
- No duplicates

## 🏗️ Architecture

### Installer Flow
```
PBIXTool.iss (Inno Setup Script)
    ↓
InitializeWizard() → Creates BulkConvertPBIX.ps1
    ↓
Files Section → Copies all files
    ↓
Registry Section → Adds to PATH (if selected)
    ↓
Icons Section → Creates shortcuts
    ↓
Post-install → Shows welcome message
```

### Runtime Flow
```
User clicks "Bulk Convert PBIX Files"
    ↓
BulkConvertPBIX.ps1 runs
    ↓
Shows folder browser (Shell.Application)
    ↓
Gets all .pbix files (Get-ChildItem)
    ↓
For each file:
    - Call pbix.bat with input/output paths
    - Track exit code
    - Display progress
    - Count results
    ↓
Show summary message box
```

## 📋 File Manifest

### Source Files (Required for Build)
```
pbix.bat              ← Main conversion script
modify_layout.py      ← Visual modification logic
create_pbix.py        ← PBIX packaging logic
README.md            ← User documentation
PBIXTool.iss         ← Installer script
```

### Documentation Files
```
INSTALLER_GUIDE.md       ← Full installer documentation
BUILD_INSTALLER.md       ← Quick build guide
RELEASE_NOTES.md         ← v1.0.0 release info
RELEASE_CHECKLIST.md     ← Pre-release testing
INSTALLER_README.md      ← This file
```

### Generated Files (Not in Repo)
```
Output/
    PBIXConverter_Setup.exe    ← Built installer
BulkConvertPBIX.ps1            ← Generated during install
*_converted.pbix               ← Converted files
```

### Test Files
```
PowerBI_NativeVisuals.pbix     ← Sample test file
cmd.txt                         ← Command examples
```

## 🔧 Customization Guide

### Change Version
Edit `PBIXTool.iss` line 7:
```pascal
#define MyAppVersion "1.0.0"  → "1.1.0"
```

### Change Installation Directory
Edit `PBIXTool.iss` line 21:
```pascal
DefaultDirName={autopf}\PBIXConverter  → {autopf}\MyCompany\PBIXConverter
```

### Change Output Filename
Edit `PBIXTool.iss` line 25:
```pascal
OutputBaseFilename=PBIXConverter_Setup  → MyCompany_PBIXConverter_Setup
```

### Add Custom Icon
1. Create/obtain `icon.ico`
2. Edit `PBIXTool.iss` line 26:
   ```pascal
   SetupIconFile=  → SetupIconFile=icon.ico
   ```

### Add License Agreement
1. Create `LICENSE.txt`
2. Edit `PBIXTool.iss` line 31:
   ```pascal
   LicenseFile=  → LicenseFile=LICENSE.txt
   ```

## 🧪 Testing Strategy

### Manual Testing
1. **Clean Install** → Fresh Windows VM
2. **Upgrade Install** → Over existing version
3. **Custom Directory** → Non-default location
4. **PATH Testing** → Command-line access
5. **Bulk Convert** → Multiple files at once
6. **Uninstall** → Complete removal

### Automated Testing
See `RELEASE_CHECKLIST.md` for comprehensive test plan.

## 📦 Distribution

### GitHub Releases
1. Tag version: `git tag v1.0.0`
2. Push tag: `git push origin v1.0.0`
3. Create GitHub Release
4. Upload `PBIXConverter_Setup.exe`
5. Copy release notes from `RELEASE_NOTES.md`

### Direct Distribution
- Share `PBIXConverter_Setup.exe` directly
- Host on company website
- Distribute via email/file share
- Include `README.md` for reference

## 🐛 Common Issues & Solutions

### Build Issues

**"Source file not found"**
```
Solution: Ensure all files in same directory as PBIXTool.iss
```

**"Syntax error"**
```
Solution: Use Inno Setup 6.x (not 5.x)
```

### Installation Issues

**"Access Denied"**
```
Solution: Run installer as Administrator
```

**"Python not found"**
```
Solution: Install Python 3.x separately
```

### Runtime Issues

**Bulk converter fails**
```
Solution 1: Ensure Python in PATH
Solution 2: Close Power BI Desktop
Solution 3: Check PowerShell execution policy
```

## 📊 Metrics

### Installer Size
- Compiled: ~20-50 KB (compressed)
- Installed: ~15-20 KB (files only)
- With Python: N/A (external dependency)

### Installation Time
- Installation: ~5-10 seconds
- First run setup: ~1 second
- Bulk convert (10 files): ~10-30 seconds

### System Impact
- Registry entries: 1-2 keys
- Start Menu: 1 folder, 4 shortcuts
- Desktop: 0-1 shortcuts
- PATH: 0-1 entries
- CPU: Minimal (batch processing)
- Disk: <1 MB

## 🔗 Links

- **Repository:** https://github.com/nsdevaraj/PBIXConverter
- **Issues:** https://github.com/nsdevaraj/PBIXConverter/issues
- **Releases:** https://github.com/nsdevaraj/PBIXConverter/releases
- **Inno Setup:** https://jrsoftware.org/isinfo.php

## 👥 Support

### For End Users
- Read `README.md` in installation directory
- Check GitHub Issues for known problems
- Create new issue if problem persists

### For Developers
- Read `INSTALLER_GUIDE.md` for build details
- Check `BUILD_INSTALLER.md` for quick start
- Use `RELEASE_CHECKLIST.md` before releasing

## 📄 License

See repository for license information.

---

**Made with ❤️ using Inno Setup**
