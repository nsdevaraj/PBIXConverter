import os
import zipfile
import sys
from time import localtime

def create_pbix(output_file, source_dir):
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

if __name__ == '__main__':
    create_pbix(sys.argv[1], sys.argv[2])
