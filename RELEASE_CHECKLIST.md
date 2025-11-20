# Release Checklist for PBIXConverter Installer

Use this checklist when preparing a new release of the installer.

## Pre-Build Checklist

### ✅ Version Updates
- [ ] Update version number in `PBIXTool.iss` (line 7)
  ```pascal
  #define MyAppVersion "1.0.0"
  ```
- [ ] Update version in `RELEASE_NOTES.md`
- [ ] Update CHANGELOG if applicable

### ✅ Code Verification
- [ ] Test `pbix.bat` with sample files
- [ ] Verify `modify_layout.py` handles all visual types
- [ ] Verify `create_pbix.py` creates valid PBIX files
- [ ] Test extract mode: `pbix.bat extract "file.pbix"`
- [ ] Test convert mode: `pbix.bat "input.pbix" "output.pbix"`

### ✅ Documentation Review
- [ ] Update `README.md` with new features
- [ ] Review `INSTALLER_GUIDE.md` for accuracy
- [ ] Update `BUILD_INSTALLER.md` if build process changed
- [ ] Update `RELEASE_NOTES.md` with changes

### ✅ File Verification
- [ ] All source files present:
  - [ ] `pbix.bat`
  - [ ] `modify_layout.py`
  - [ ] `create_pbix.py`
  - [ ] `README.md`
  - [ ] `PBIXTool.iss`
- [ ] `.gitignore` excludes build artifacts
- [ ] No temporary or backup files in repository

## Build Checklist

### ✅ Build Preparation
- [ ] Clean working directory
- [ ] Ensure all files are in root directory (not subdirectories)
- [ ] Verify Inno Setup 6.x is installed
- [ ] Close any running instances of Inno Setup Compiler

### ✅ Compilation
- [ ] Open `PBIXTool.iss` in Inno Setup Compiler
- [ ] Check for syntax warnings
- [ ] Press F9 or Build → Compile
- [ ] Verify compilation completes without errors
- [ ] Check `Output/PBIXConverter_Setup.exe` was created
- [ ] Note file size (should be reasonable, typically < 50 KB)

## Post-Build Checklist

### ✅ Testing on Clean System
- [ ] Test installation on clean Windows 10/11 VM
- [ ] Test with Python installed
- [ ] Test without Python (should install but warn about requirement)
- [ ] Verify default installation directory
- [ ] Verify custom installation directory
- [ ] Test PATH integration (if selected)
- [ ] Test without PATH integration

### ✅ Feature Testing
- [ ] Test "PBIXConverter Command" shortcut
- [ ] Test "Bulk Convert PBIX Files" shortcut
- [ ] Test desktop shortcut (if created)
- [ ] Test "Read Me" shortcut opens documentation
- [ ] Verify all Start Menu items created

### ✅ Bulk Converter Testing
- [ ] Create test folder with multiple .pbix files
- [ ] Run "Bulk Convert PBIX Files" shortcut
- [ ] Verify folder browser appears
- [ ] Select test folder
- [ ] Verify progress display
- [ ] Verify summary shows correct counts
- [ ] Verify all files converted to `*_converted.pbix`
- [ ] Verify failed conversions are reported

### ✅ Command-Line Testing
If PATH was added:
- [ ] Open new command prompt
- [ ] Run `pbix.bat "test.pbix"` from any directory
- [ ] Verify conversion works
- [ ] Test with full paths
- [ ] Test with relative paths

### ✅ Uninstallation Testing
- [ ] Run uninstaller from Start Menu
- [ ] Verify all files removed from installation directory
- [ ] Verify Start Menu folder removed
- [ ] Verify desktop shortcut removed (if created)
- [ ] Verify PATH entry removed (if it was added)
- [ ] Check registry for leftover entries
- [ ] Verify clean uninstall

### ✅ Edge Cases
- [ ] Test installation without admin rights
- [ ] Test installation with different Windows language
- [ ] Test with PowerShell execution policy restricted
- [ ] Test with antivirus software enabled
- [ ] Test on 32-bit Windows (if supporting)
- [ ] Test on 64-bit Windows
- [ ] Test upgrade from previous version

## Release Checklist

### ✅ GitHub Release
- [ ] Create release tag (e.g., `v1.0.0`)
- [ ] Upload `PBIXConverter_Setup.exe`
- [ ] Add release notes from `RELEASE_NOTES.md`
- [ ] Mark as pre-release if applicable
- [ ] Publish release

### ✅ Documentation Updates
- [ ] Update README with download link
- [ ] Update installation instructions
- [ ] Create/update GitHub Pages site (if applicable)
- [ ] Update any external documentation

### ✅ Communication
- [ ] Announce release (GitHub Discussions, Twitter, etc.)
- [ ] Update project website
- [ ] Notify users of breaking changes (if any)
- [ ] Update support channels with new version info

## Troubleshooting Common Issues

### Build Fails
**"Source file not found"**
- Ensure all files are in same directory as `.iss`
- Check file names match exactly (case-sensitive)

**Syntax errors**
- Verify Inno Setup version (6.x required)
- Check for unmatched quotes or braces

### Installer Fails
**Installation aborts**
- Check if previous version is still running
- Verify admin rights
- Check disk space

**Shortcuts don't work**
- Verify PowerShell execution policy
- Check file paths in shortcuts
- Verify Python is in PATH

**Bulk converter fails**
- Ensure Python 3.x installed
- Check PowerShell version (5.0+ required)
- Verify .pbix files not open in Power BI

## Sign-off

- [ ] All tests passed
- [ ] Documentation reviewed
- [ ] Release notes complete
- [ ] Ready for distribution

**Release Manager:** _______________  
**Date:** _______________  
**Version:** _______________

---

## Quick Test Commands

```cmd
REM Test single conversion
pbix.bat "PowerBI_NativeVisuals.pbix"

REM Test with custom output
pbix.bat "input.pbix" "output.pbix"

REM Test extract mode
pbix.bat extract "PowerBI_NativeVisuals.pbix"

REM Test from different directory
cd C:\Users\Test\Downloads
C:\Program Files\PBIXConverter\pbix.bat "test.pbix"
```

```powershell
# Test bulk conversion script directly
Set-Location "C:\Program Files\PBIXConverter"
.\BulkConvertPBIX.ps1

# Test PATH integration
Get-Command pbix.bat
```
