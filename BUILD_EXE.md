# Building Standalone EXE for PBIX Converter

This guide explains how to build a standalone Windows executable (.exe) for the PBIX Converter tool.

## Overview

The PBIX Converter can be distributed as a single standalone executable file that includes:
- All Python code and dependencies
- No Python installation required on target machines
- Single-file deployment
- Cross-platform build support

## Prerequisites

### For Building on Windows
- Python 3.7 or later
- pip (Python package installer)

### For Building on Linux/macOS (cross-platform)
- Python 3.7 or later
- pip (Python package installer)
- Wine (optional, for testing Windows executables)

## Quick Start

### Method 1: Using the Build Script (Recommended)

The easiest way to build the EXE is using the provided build script:

```bash
python build_exe.py
```

This script will:
1. Check if PyInstaller is installed (and install it if needed)
2. Clean previous builds
3. Build the standalone EXE
4. Display the output location and size

**Output:** `dist/pbix_converter.exe`

### Method 2: Manual Build with PyInstaller

If you prefer manual control:

1. **Install PyInstaller:**
   ```bash
   pip install pyinstaller
   ```

2. **Build the EXE:**
   ```bash
   pyinstaller --clean --onefile --name pbix_converter --console pbix_converter.py
   ```

3. **Find the output:**
   - EXE location: `dist/pbix_converter.exe`

### Method 3: Using the Spec File

For advanced customization, use the provided spec file:

1. **Install PyInstaller:**
   ```bash
   pip install pyinstaller
   ```

2. **Build with spec file:**
   ```bash
   pyinstaller pbix_converter.spec
   ```

3. **Find the output:**
   - EXE location: `dist/pbix_converter.exe`

## Build Options

### PyInstaller Options Explained

- `--onefile`: Creates a single executable file (no dependencies folder)
- `--console`: Shows console window during execution (recommended for this tool)
- `--name pbix_converter`: Sets the output filename
- `--clean`: Cleans PyInstaller cache before building

### Advanced Options

For more control, edit `pbix_converter.spec`:

```python
# Enable UPX compression (smaller file size)
upx=True

# Disable UPX for specific files
upx_exclude=[]

# Add icon (Windows)
icon='icon.ico'

# Add version information
version='version.txt'
```

## Testing the EXE

After building, test the executable:

```bash
# Show help
dist/pbix_converter.exe --help

# Show version
dist/pbix_converter.exe --version

# Convert a PBIX file
dist/pbix_converter.exe test.pbix

# Extract a PBIX file
dist/pbix_converter.exe --extract test.pbix
```

## Distribution

Once built, you can distribute the single `pbix_converter.exe` file:

1. **Single File Distribution:**
   - Just copy `dist/pbix_converter.exe` to any Windows machine
   - No Python installation required
   - No additional dependencies needed

2. **With Installer:**
   - Include the EXE in the Inno Setup installer
   - See `BUILD_INSTALLER.md` for details

## File Size

The standalone EXE will be approximately 10-15 MB, which includes:
- Python runtime
- Standard library modules
- JSON, zipfile, and other required modules

You can reduce the size by:
- Enabling UPX compression: `upx=True` in spec file
- Using `--strip` option (Linux builds)

## Cross-Platform Building

### Building Windows EXE on Linux/macOS

PyInstaller can only create executables for the host platform. To create a Windows EXE:

**Option 1: Use Wine**
```bash
# Install Wine
sudo apt-get install wine  # Ubuntu/Debian
brew install wine          # macOS

# Install Python in Wine
wine python-installer.exe

# Build with PyInstaller in Wine
wine python -m PyInstaller --onefile pbix_converter.py
```

**Option 2: Use a Windows VM or CI/CD**
- Use GitHub Actions with Windows runner
- Use a Windows VM (VirtualBox, VMware)
- Use cloud build services

## Troubleshooting

### "PyInstaller is not recognized"

Install PyInstaller:
```bash
pip install pyinstaller
```

### "Failed to execute script"

Ensure all imports are available:
```bash
python pbix_converter.py --help
```

If the script works but the EXE doesn't, check for:
- Hidden imports (add to spec file)
- Data files (add to datas section)
- Dynamic imports

### Large EXE Size

To reduce size:
1. Enable UPX compression in spec file
2. Use `--exclude-module` for unused modules
3. Consider using `--onedir` instead of `--onefile`

### Antivirus False Positives

Some antivirus software may flag PyInstaller executables:
- Use code signing certificate
- Submit to antivirus vendors for whitelisting
- Build in `--onedir` mode instead

## Advanced Customization

### Adding an Icon

1. Create or obtain a `.ico` file
2. Update the build command:
   ```bash
   pyinstaller --onefile --icon=icon.ico pbix_converter.py
   ```

### Adding Version Information (Windows only)

1. Create `version.txt`:
   ```txt
   VSVersionInfo(
     ffi=FixedFileInfo(
       filevers=(1, 0, 0, 0),
       prodvers=(1, 0, 0, 0),
       mask=0x3f,
       flags=0x0,
       OS=0x40004,
       fileType=0x1,
       subtype=0x0,
       date=(0, 0)
     ),
     kids=[
       StringFileInfo(
         [
         StringTable(
           u'040904B0',
           [StringStruct(u'CompanyName', u'Your Company'),
           StringStruct(u'FileDescription', u'PBIX Converter'),
           StringStruct(u'FileVersion', u'1.0.0'),
           StringStruct(u'ProductName', u'PBIX Converter'),
           StringStruct(u'ProductVersion', u'1.0.0')])
         ]), 
       VarFileInfo([VarStruct(u'Translation', [1033, 1200])])
     ]
   )
   ```

2. Update build command:
   ```bash
   pyinstaller --onefile --version-file=version.txt pbix_converter.py
   ```

### Hidden Imports

If the EXE fails with import errors, add hidden imports to spec file:

```python
hiddenimports=['module_name']
```

## Comparison: EXE vs Installer

| Feature | Standalone EXE | Inno Setup Installer |
|---------|---------------|---------------------|
| File Size | ~10-15 MB | ~5 MB + dependencies |
| Installation | Copy and run | Install wizard |
| Python Required | No | Yes (for scripts) |
| Batch Files | Not included | Included |
| PATH Integration | Manual | Automatic (optional) |
| Start Menu | No | Yes |
| Uninstaller | No | Yes |

**Recommendation:**
- Use **standalone EXE** for quick deployment and portable usage
- Use **Inno Setup installer** for professional installation with all features

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Build EXE

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v2
    - uses: actions/setup-python@v2
      with:
        python-version: '3.9'
    - name: Install dependencies
      run: pip install pyinstaller
    - name: Build EXE
      run: python build_exe.py
    - name: Upload artifact
      uses: actions/upload-artifact@v2
      with:
        name: pbix_converter.exe
        path: dist/pbix_converter.exe
```

## Additional Resources

- **PyInstaller Documentation**: https://pyinstaller.org/
- **Spec File Reference**: https://pyinstaller.org/en/stable/spec-files.html
- **Common Issues**: https://github.com/pyinstaller/pyinstaller/wiki

## Support

For issues specific to building the EXE:
- Check PyInstaller documentation
- Ensure Python script runs correctly before building
- Test on target Windows version

---

**Ready to build?** Run: `python build_exe.py`
