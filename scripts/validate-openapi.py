#!/usr/bin/env python3
"""Validate OpenAPI 3.0 files."""

import json
import sys
import glob
import os

def validate_openapi_files():
    """Validate all OpenAPI 3.0 JSON files."""
    print("📋 Validating OpenAPI 3.0 files...")
    
    pattern = "dist/openapi/*.openapi.json"
    openapi_files = glob.glob(pattern)
    
    if not openapi_files:
        print(f"  ❌ No OpenAPI files found matching: {pattern}")
        return False
    
    success = True
    for file_path in openapi_files:
        filename = os.path.basename(file_path)
        print(f"  Validating {filename}...")
        
        try:
            with open(file_path, 'r') as f:
                data = json.load(f)
            
            if 'openapi' in data and data['openapi'].startswith('3.'):
                print(f"  ✅ Valid OpenAPI 3.0 JSON")
            else:
                print(f"  ❌ Missing openapi 3.x identifier")
                success = False
                
        except json.JSONDecodeError as e:
            print(f"  ❌ Invalid JSON: {e}")
            success = False
        except Exception as e:
            print(f"  ❌ Error reading file: {e}")
            success = False
    
    return success

if __name__ == "__main__":
    if validate_openapi_files():
        print("✅ All OpenAPI 3.0 files are valid")
        sys.exit(0)
    else:
        print("❌ Some OpenAPI 3.0 files are invalid")
        sys.exit(1)