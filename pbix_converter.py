#!/usr/bin/env python3
"""
PBIX Converter Utility
Converts PBIX files by modifying visual types and removing SecurityBindings
"""

import sys
import os
import zipfile
import json
import shutil
import tempfile
import argparse
from pathlib import Path


def extract_pbix(pbix_file, extract_dir):
    """Extract PBIX file to a directory"""
    print(f"[INFO] Extracting PBIX file to {extract_dir}...")
    with zipfile.ZipFile(pbix_file, 'r') as zip_ref:
        zip_ref.extractall(extract_dir)
    print("[INFO] ✓ Extraction complete.")


def remove_security_bindings(extract_dir):
    """Remove SecurityBindings file if it exists"""
    print("[INFO] Removing SecurityBindings file...")
    security_bindings = os.path.join(extract_dir, "SecurityBindings")
    if os.path.exists(security_bindings):
        os.remove(security_bindings)
        print("[INFO] SecurityBindings file removed")
    else:
        print("[WARNING] SecurityBindings file not found (this may be expected)")


def modify_layout(layout_file):
    """Modify the Layout file to convert visual types"""
    print("[INFO] Modifying Layout file...")
    
    # Power BI layout files are UTF-16 LE
    with open(layout_file, 'r', encoding='utf-16-le') as f:
        layout_data = json.load(f)

    visual_to_replace_with = "inforiverAppPremium2B7A5FD2992D434DAE0B149479307B7B"

    print("[INFO]   - Replacing pivotTable visual type...")
    print("[INFO]   - Replacing tableEx visual type...")
    print("[INFO]   - Replacing projections Values with ameasure...")
    print("[INFO]   - Replacing Rows with rows...")
    print("[INFO]   - Replacing Columns with columns...")

    # Iterate through all visual containers in all sections
    for section in layout_data.get('sections', []):
        for visual_container in section.get('visualContainers', []):
            if 'config' in visual_container and visual_container['config']:
                try:
                    config = json.loads(visual_container['config'])
                    
                    if 'singleVisual' in config:
                        single_visual = config['singleVisual']
                        
                        # Replace visualType
                        if single_visual.get('visualType') in ['pivotTable', 'tableEx']:
                            single_visual['visualType'] = visual_to_replace_with

                        # Modify projections
                        if 'projections' in single_visual:
                            projections = single_visual['projections']
                            if 'Values' in projections:
                                projections['ameasure'] = projections.pop('Values')
                            if 'Rows' in projections:
                                projections['rows'] = projections.pop('Rows')
                            if 'Columns' in projections:
                                projections['columns'] = projections.pop('Columns')
                    
                    # Put the modified config back
                    visual_container['config'] = json.dumps(config, separators=(',', ':'))

                except json.JSONDecodeError:
                    pass

    print("[INFO]   - Adding publicCustomVisuals declaration...")
    
    # Add the custom visual to the public list at the root
    if 'publicCustomVisuals' not in layout_data:
        layout_data['publicCustomVisuals'] = []
    
    if visual_to_replace_with not in layout_data['publicCustomVisuals']:
        layout_data['publicCustomVisuals'].append(visual_to_replace_with)

    # Write the modified data back to the file
    with open(layout_file, 'w', encoding='utf-16-le') as f:
        json.dump(layout_data, f, ensure_ascii=False, separators=(',', ':'))
    
    print("[INFO] Layout file modified successfully")


def create_pbix(output_file, source_dir):
    """Create PBIX file from directory"""
    print(f"[INFO] Creating new PBIX file: {output_file}...")
    
    with zipfile.ZipFile(output_file, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(source_dir):
            for file in files:
                if not file.endswith('.backup') and file != '.DS_Store':
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, source_dir)
                    
                    # Set a fixed timestamp for reproducible builds
                    zip_info = zipfile.ZipInfo(arcname, date_time=(2023, 1, 1, 0, 0, 0))
                    zip_info.compress_type = zipfile.ZIP_DEFLATED
                    zip_info.create_system = 0
                    zip_info.external_attr = 0o644 << 16
                    
                    with open(file_path, 'rb') as f:
                        zipf.writestr(zip_info, f.read())
    
    print("[INFO] ✓ PBIX file created successfully!")


def convert_pbix(input_file, output_file):
    """Convert a PBIX file by modifying visuals and removing SecurityBindings"""
    print("[INFO] Starting PBIX conversion")
    print(f"[INFO] Input file: {input_file}")
    print(f"[INFO] Output file: {output_file}")
    
    # Create temporary directory
    temp_dir = tempfile.mkdtemp(prefix="pbix-converter-")
    print(f"[INFO] Created temporary directory: {temp_dir}")
    
    try:
        # Extract PBIX
        extract_pbix(input_file, temp_dir)
        
        # Remove SecurityBindings
        remove_security_bindings(temp_dir)
        
        # Modify Layout
        layout_file = os.path.join(temp_dir, "Report", "Layout")
        if not os.path.exists(layout_file):
            print(f"[ERROR] Layout file not found at {layout_file}")
            return False
        
        # Create backup
        shutil.copy2(layout_file, layout_file + ".backup")
        
        modify_layout(layout_file)
        
        # Create new PBIX
        create_pbix(output_file, temp_dir)
        
        print("\n[INFO] ✓ Conversion completed successfully!")
        print(f"[INFO] Output file: {output_file}")
        print("\nSummary of changes:")
        print("  - SecurityBindings file removed (if present)")
        print("  - pivotTable visuals -> inforiverAppPremium")
        print("  - tableEx visuals -> inforiverAppPremium")
        print("  - projections Values -> ameasure")
        print("  - Rows -> rows")
        print("  - Columns -> columns")
        
        return True
        
    except Exception as e:
        print(f"[ERROR] Conversion failed: {e}")
        return False
        
    finally:
        # Cleanup
        print("[INFO] Cleaning up temporary files...")
        shutil.rmtree(temp_dir, ignore_errors=True)


def extract_only(input_file, extract_dir):
    """Extract PBIX contents to a directory"""
    print("[INFO] Starting PBIX extraction")
    print(f"[INFO] Input file: {input_file}")
    print(f"[INFO] Output directory: {extract_dir}")
    
    try:
        # Create extract directory if it doesn't exist
        os.makedirs(extract_dir, exist_ok=True)
        
        # Extract PBIX
        extract_pbix(input_file, extract_dir)
        
        return True
        
    except Exception as e:
        print(f"[ERROR] Extraction failed: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(
        description='PBIX Converter Utility - Convert PBIX files by modifying visual types',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Examples:
  Convert with default output name:
    pbix_converter.exe myreport.pbix
    
  Convert with custom output name:
    pbix_converter.exe myreport.pbix myreport_modified.pbix
    
  Extract PBIX contents:
    pbix_converter.exe --extract myreport.pbix
    
  Extract to specific directory:
    pbix_converter.exe --extract myreport.pbix --output my_extracted_files
        '''
    )
    
    parser.add_argument('input', help='Path to the input PBIX file')
    parser.add_argument('output', nargs='?', help='Path to the output file/directory')
    parser.add_argument('--extract', '-e', action='store_true', 
                       help='Extract PBIX contents only (no conversion)')
    parser.add_argument('--version', '-v', action='version', version='PBIX Converter 1.0.0')
    
    args = parser.parse_args()
    
    # Validate input file
    input_file = Path(args.input)
    if not input_file.exists():
        print(f"[ERROR] Input file '{args.input}' not found")
        sys.exit(1)
    
    if input_file.suffix.lower() != '.pbix':
        print("[ERROR] Input file must have .pbix extension")
        sys.exit(1)
    
    # Determine mode and output
    if args.extract:
        # Extract mode
        if args.output:
            extract_dir = args.output
        else:
            extract_dir = str(input_file.with_suffix('')) + '_extracted'
        
        success = extract_only(str(input_file), extract_dir)
    else:
        # Convert mode
        if args.output:
            output_file = args.output
        else:
            output_file = str(input_file.with_suffix('')) + '_converted.pbix'
        
        success = convert_pbix(str(input_file), output_file)
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
