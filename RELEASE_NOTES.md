# PBIXConverter Release Notes

## v1.1.0 - Standalone EXE Support

### 🎉 New Features
- **Cross-platform CLI:** Added `pbix_converter.py`, a Python entry point that mirrors the batch script logic and can run on Windows, macOS, or Linux.
- **Standalone Executable:** Introduced a PyInstaller workflow (see `build_exe.py`, `pbix_converter.spec`, and `requirements.txt`) to produce `pbix_converter.exe` without requiring Python on the target machine.
- **EXE Build Guide:** Added `BUILD_EXE.md` with detailed instructions for building, customizing, and distributing the standalone executable.
- **README Enhancements:** Installation and usage sections now cover the Python/EXE workflow alongside the existing batch file and installer instructions.

### 📦 What's Included in v1.1.0
- `pbix_converter.py` – Cross-platform CLI & PyInstaller entry point
- `build_exe.py` – Automated build helper
- `pbix_converter.spec` – Reproducible PyInstaller configuration
- `BUILD_EXE.md` – Comprehensive EXE build documentation
- `requirements.txt` – Captures the PyInstaller dependency

### 🚀 Usage Updates
- Run conversions with `python pbix_converter.py input.pbix` on any OS.
- Build and distribute `pbix_converter.exe` via `python build_exe.py`.
- README now documents Method 3 (Standalone Python / EXE) with command examples for conversion and extraction.

---

## v1.0.0 - Windows Installer Release

### 🎉 New Features

#### Windows Installer Package
- **One-click installation** with professional Inno Setup installer
- Installs to `C:\Program Files\PBIXConverter` (or custom location)
- Creates Start Menu folder with multiple shortcuts
- Optional desktop shortcut for quick access
- Optional system PATH integration for command-line access

#### Bulk Conversion Tool
- **New:** `BulkConvertPBIX.ps1` - PowerShell script for batch processing
- **Folder Browser** - GUI to select directory containing .pbix files
- **Automatic Processing** - Converts all .pbix files in selected folder
- **Progress Tracking** - Real-time console output with status indicators
- **Summary Report** - Shows count of successful and failed conversions
- **Error Handling** - Continues processing even if individual files fail

#### Installation Features
- ✅ All tool files bundled in single installer
- ✅ Documentation included (README.md)
- ✅ Multiple Start Menu shortcuts:
  - PBIXConverter Command (opens in tool directory)
  - Bulk Convert PBIX Files (bulk processor)
  - Read Me (documentation)
  - Uninstall (clean removal)
- ✅ Clean uninstall with PATH cleanup
- ✅ Modern wizard-style UI

### 📦 What's Included

#### Core Files
- `pbix.bat` - Main conversion tool
- `modify_layout.py` - Layout modification script
- `create_pbix.py` - PBIX creation script
- `README.md` - User documentation

#### Installer Assets
- `PBIXTool.iss` - Inno Setup installer script
- `INSTALLER_GUIDE.md` - Comprehensive build guide
- `BUILD_INSTALLER.md` - Quick start build guide
- `BulkConvertPBIX.ps1` - Bulk conversion helper (generated during install)
- `.gitignore` - Version control exclusions

### 🚀 Getting Started

#### For End Users
- **Option 1: Use the Installer (Recommended)**
  1. Download `PBIXConverter_Setup.exe`
  2. Run the installer
  3. Choose installation options
  4. Use the desktop or Start Menu shortcuts
- **Option 2: Manual Setup**
  1. Download the three core files
  2. Place in any directory
  3. Run `pbix.bat` from command line

#### For Developers
- Install [Inno Setup 6.x](https://jrsoftware.org/isdl.php)
- Open `PBIXTool.iss` in Inno Setup Compiler
- Press F9 to compile
- Find output in `Output\PBIXConverter_Setup.exe`
- See [BUILD_INSTALLER.md](BUILD_INSTALLER.md) for quick start guide
- See [INSTALLER_GUIDE.md](INSTALLER_GUIDE.md) for comprehensive documentation

### 🎯 Key Features

#### Conversion Capabilities
- ✅ Remove SecurityBindings
- ✅ Convert `pivotTable` → `inforiverAppPremium`
- ✅ Convert `tableEx` → `inforiverAppPremium`
- ✅ Replace projections: `Values` → `ameasure`
- ✅ Replace `Rows` → `rows`
- ✅ Replace `Columns` → `columns`
- ✅ Add publicCustomVisuals declaration

#### Bulk Processing
- ✅ Process entire folders at once
- ✅ Visual folder browser interface
- ✅ Real-time progress display
- ✅ Success/failure tracking
- ✅ Automatic file naming (`*_converted.pbix`)

#### Installation Options
- ✅ Custom installation directory
- ✅ Desktop shortcut (optional)
- ✅ System PATH integration (optional)
- ✅ Start Menu shortcuts
- ✅ Clean uninstallation

### 💻 System Requirements

#### For End Users
- **OS:** Windows 10 or later
- **Python:** 3.x (must be in PATH)
- **PowerShell:** 5.0+ (built-in on Windows 10+)
- **Admin Rights:** Required for Program Files installation

#### For Building Installer
- **OS:** Windows 10 or later
- **Inno Setup:** 6.x or later
- All source files in same directory

### 📖 Documentation
- **[README.md](README.md)** - User guide and usage examples
- **[INSTALLER_GUIDE.md](INSTALLER_GUIDE.md)** - Comprehensive installer documentation
- **[BUILD_INSTALLER.md](BUILD_INSTALLER.md)** - Quick build guide
- **[RELEASE_NOTES.md](RELEASE_NOTES.md)** - This file

### 🔧 Usage Examples

#### Single File Conversion
```cmd
pbix.bat "C:\path\to\file.pbix"
```

#### Custom Output Name
```cmd
pbix.bat "input.pbix" "output.pbix"
```

#### Extract PBIX Contents
```cmd
pbix.bat extract "file.pbix"
```

#### Bulk Convert (Using Installer)
1. Click "Bulk Convert PBIX Files" shortcut
2. Select folder
3. Watch conversion progress
4. Check folder for `*_converted.pbix` files

### 🐛 Known Issues
- Python 3.x must be installed separately (not included in installer)
- PowerShell execution policy must allow script execution
- Original files must be closed in Power BI Desktop during conversion

### 🛠️ Troubleshooting
- **"Python is not recognized"** – Install Python 3.x from [python.org](https://www.python.org/) and add to PATH
- **Shortcuts don't work** – Right-click shortcut → Run as Administrator; check PowerShell execution policy
- **Bulk converter fails** – Ensure Python is in PATH, close Power BI Desktop, and verify write permissions

### 📝 Version History
- **v1.0.0** – Initial installer release with bulk conversion, PATH integration, modern installer, and documentation set

### 🤝 Contributing
Visit [https://github.com/nsdevaraj/PBIXConverter](https://github.com/nsdevaraj/PBIXConverter) for source code, issues, feature requests, and pull requests.

### 📄 License
See repository for license information.

### 👏 Credits
- **Author:** nsdevaraj
- **Repository:** https://github.com/nsdevaraj/PBIXConverter
- **Installer:** Inno Setup (jrsoftware.org)

---

**Happy Converting! 🎊**
