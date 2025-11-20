#!/usr/bin/env python3
"""
Build script for creating standalone EXE from pbix_converter.py
"""

import os
import sys
import subprocess
import shutil
from pathlib import Path

def main():
    print("=" * 60)
    print("PBIX Converter - EXE Builder")
    print("=" * 60)
    print()
    
    # Check if PyInstaller is installed
    try:
        import PyInstaller
        print(f"✓ PyInstaller {PyInstaller.__version__} found")
    except ImportError:
        print("✗ PyInstaller not found")
        print("Installing PyInstaller...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "pyinstaller"])
        print("✓ PyInstaller installed")
    
    print()
    
    # Clean previous builds
    print("Cleaning previous builds...")
    for dir_name in ['build', 'dist']:
        if os.path.exists(dir_name):
            shutil.rmtree(dir_name)
            print(f"  Removed {dir_name}/")
    
    print()
    
    # Build using PyInstaller
    print("Building EXE with PyInstaller...")
    print("-" * 60)
    
    cmd = [
        sys.executable,
        "-m", "PyInstaller",
        "--clean",
        "--onefile",
        "--name", "pbix_converter",
        "--console",
        "pbix_converter.py"
    ]
    
    result = subprocess.run(cmd)
    
    if result.returncode != 0:
        print()
        print("✗ Build failed!")
        sys.exit(1)
    
    print("-" * 60)
    print()
    
    # Check if EXE was created
    exe_path = Path("dist/pbix_converter.exe")
    if exe_path.exists():
        size_mb = exe_path.stat().st_size / (1024 * 1024)
        print("✓ Build successful!")
        print()
        print(f"Output: {exe_path}")
        print(f"Size: {size_mb:.2f} MB")
        print()
        print("To test the executable:")
        print(f"  {exe_path} --help")
        print(f"  {exe_path} your_file.pbix")
    else:
        print("✗ EXE file not found in dist/")
        sys.exit(1)
    
    print()
    print("=" * 60)

if __name__ == '__main__':
    main()
