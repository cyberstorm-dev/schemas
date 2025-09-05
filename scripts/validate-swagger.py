#!/usr/bin/env python3
"""Validate Swagger 2.0 files."""

import json
import sys
import glob
import os

def validate_swagger_files():
    """Validate all Swagger 2.0 JSON files."""
    print("📋 Validating Swagger 2.0 files...")
    
    pattern = "dist/openapi/*.swagger.json"
    swagger_files = glob.glob(pattern)
    
    if not swagger_files:
        print(f"  ❌ No Swagger files found matching: {pattern}")
        return False
    
    success = True
    for file_path in swagger_files:
        filename = os.path.basename(file_path)
        print(f"  Validating {filename}...")
        
        try:
            with open(file_path, 'r') as f:
                data = json.load(f)
            
            if 'swagger' in data and data['swagger'] == '2.0':
                print(f"  ✅ Valid Swagger 2.0 JSON")
            else:
                print(f"  ❌ Missing swagger 2.0 identifier")
                success = False
                
        except json.JSONDecodeError as e:
            print(f"  ❌ Invalid JSON: {e}")
            success = False
        except Exception as e:
            print(f"  ❌ Error reading file: {e}")
            success = False
    
    return success

if __name__ == "__main__":
    if validate_swagger_files():
        print("✅ All Swagger 2.0 files are valid")
        sys.exit(0)
    else:
        print("❌ Some Swagger 2.0 files are invalid")
        sys.exit(1)