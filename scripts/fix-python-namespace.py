#!/usr/bin/env python3
"""
Move buf.validate modules to cyberstorm.validate namespace and fix imports.
This ensures we don't pollute the buf namespace while keeping all validation code working.
"""
import os
import re
import glob
import shutil
from pathlib import Path

def move_buf_validate_to_cyberstorm():
    """Move buf/validate modules to cyberstorm/buf/validate."""
    buf_validate_dir = Path("dist/python/buf/validate")
    cyberstorm_buf_validate_dir = Path("dist/python/cyberstorm/buf/validate")
    
    if buf_validate_dir.exists():
        # Create cyberstorm/buf/validate directory
        cyberstorm_buf_validate_dir.mkdir(parents=True, exist_ok=True)
        
        # Create __init__.py for cyberstorm/buf
        (Path("dist/python/cyberstorm/buf") / "__init__.py").touch()
        
        # Move all files from buf/validate to cyberstorm/buf/validate
        for file_path in buf_validate_dir.glob("*.py"):
            dest_path = cyberstorm_buf_validate_dir / file_path.name
            shutil.move(str(file_path), str(dest_path))
            print(f"Moved {file_path} to {dest_path}")
        
        # Remove empty buf directory structure
        if buf_validate_dir.exists() and not list(buf_validate_dir.iterdir()):
            buf_validate_dir.rmdir()
            buf_dir = Path("dist/python/buf")
            if buf_dir.exists() and not list(buf_dir.iterdir()):
                buf_dir.rmdir()
        
        return True
    return False

def remove_google_imports():
    """Remove google imports directory to prevent shadowing system protobuf."""
    google_dir = Path("dist/python/google")
    
    if google_dir.exists():
        shutil.rmtree(str(google_dir))
        print(f"✅ Removed {google_dir} to prevent shadowing system protobuf")
        return True
    return False

def fix_imports_in_file(file_path):
    """Fix buf.validate imports to use cyberstorm.buf.validate."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Replace all buf.validate imports with cyberstorm.buf.validate
    patterns = [
        (r'from buf\.validate import validate_pb2 as buf_dot_validate_dot_validate__pb2', 
         'from cyberstorm.buf.validate import validate_pb2 as buf_dot_validate_dot_validate__pb2'),
        (r'from buf\.validate import ([^\\n]+)', 
         r'from cyberstorm.buf.validate import \1'),
        (r'import buf\.validate\.([^\\s]+)', 
         r'import cyberstorm.buf.validate.\1'),
    ]
    
    for pattern, replacement in patterns:
        content = re.sub(pattern, replacement, content)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        print(f"✅ Fixed imports in {file_path}")
        return True
    return False

def main():
    """Move buf.validate to cyberstorm.buf.validate and fix all imports."""
    print("Moving buf.validate modules to cyberstorm.buf.validate namespace...")
    
    if move_buf_validate_to_cyberstorm():
        print("✅ Moved buf.validate modules to cyberstorm.buf.validate")
    else:
        print("ℹ️  No buf.validate modules found to move")
    
    # Remove google imports that shadow system packages
    if remove_google_imports():
        print("✅ Removed local google imports - using installed googleapis-common-protos instead")
    else:
        print("ℹ️  No google imports found to remove")
    
    # Fix imports in all Python files
    python_files = glob.glob('dist/python/**/*.py', recursive=True)
    fixed_count = 0
    
    for py_file in python_files:
        if fix_imports_in_file(py_file):
            fixed_count += 1
    
    print(f"✅ Fixed imports in {fixed_count} files")
    print("✅ Python namespace cleanup complete")

if __name__ == "__main__":
    main()