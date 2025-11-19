import sys
import json

def modify_layout(layout_file):
    # Power BI layout files are UTF-16 LE
    with open(layout_file, 'r', encoding='utf-16-le') as f:
        # The file may have a BOM that json.load can handle
        layout_data = json.load(f)

    visual_to_replace_with = "inforiverAppPremium2B7A5FD2992D434DAE0B149479307B7B"

    # Iterate through all visual containers in all sections
    for section in layout_data.get('sections', []):
        for visual_container in section.get('visualContainers', []):
            # The visual's configuration is stored in a string that is itself JSON.
            if 'config' in visual_container and visual_container['config']:
                try:
                    config = json.loads(visual_container['config'])
                    
                    if 'singleVisual' in config:
                        single_visual = config['singleVisual']
                        
                        # 1. Replace visualType
                        original_visual_type = single_visual.get('visualType')
                        if original_visual_type in ['pivotTable', 'tableEx']:
                            single_visual['visualType'] = visual_to_replace_with

                        # 2. Modify projections
                        if 'projections' in single_visual:
                            projections = single_visual['projections']
                            if 'Values' in projections:
                                values_copy = projections['Values']
                                projections['ameasure'] = projections.pop('Values')
                                # For tableEx, duplicate Values as rows
                                if original_visual_type == 'tableEx':
                                    projections['rows'] = values_copy
                            if 'Rows' in projections:
                                projections['rows'] = projections.pop('Rows')
                            if 'Columns' in projections:
                                projections['columns'] = projections.pop('Columns')
                    
                    # Put the modified config back
                    visual_container['config'] = json.dumps(config, separators=(',', ':'))

                except json.JSONDecodeError:
                    # Not all 'config' properties are valid JSON, so ignore errors
                    pass

    # 3. Add the custom visual to the public list at the root
    if 'publicCustomVisuals' not in layout_data:
        layout_data['publicCustomVisuals'] = []
    
    if visual_to_replace_with not in layout_data['publicCustomVisuals']:
        layout_data['publicCustomVisuals'].append(visual_to_replace_with)

    # Write the modified data back to the file
    with open(layout_file, 'w', encoding='utf-16-le') as f:
        json.dump(layout_data, f, ensure_ascii=False, separators=(',', ':'))

if __name__ == '__main__':
    if len(sys.argv) > 1:
        modify_layout(sys.argv[1])
    else:
        print("Usage: python modify_layout.py <path_to_layout_file>")
        sys.exit(1)
