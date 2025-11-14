#!/usr/bin/env python3
"""
Script to add all Swift files to Xcode project.pbxproj
This script properly adds files to PBXBuildFile, PBXFileReference, PBXGroup, and PBXSourcesBuildPhase
"""

import os
import re
import uuid

PROJECT_FILE = "MoonReader.xcodeproj/project.pbxproj"
SOURCE_DIR = "MoonReader"

def generate_id():
    """Generate a unique 24-bit hex ID (8 characters)"""
    # Use a simple counter starting from A1000100 to avoid conflicts
    counter = 0x1000100
    while True:
        yield f"{counter:08X}"
        counter += 1

def find_swift_files():
    """Find all Swift files, excluding Preview Content"""
    swift_files = []
    for root, dirs, files in os.walk(SOURCE_DIR):
        # Skip Preview Content
        if "Preview Content" in root:
            continue
        for file in files:
            if file.endswith('.swift'):
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, SOURCE_DIR)
                swift_files.append((full_path, rel_path, file))
    return sorted(swift_files)

def get_existing_ids(content):
    """Get all existing object IDs"""
    ids = set()
    for match in re.finditer(r'\t\t([A-F0-9]{8}) /\*', content):
        ids.add(match.group(1))
    return ids

def main():
    print("🔍 Finding Swift files...")
    swift_files = find_swift_files()
    print(f"✅ Found {len(swift_files)} Swift files")
    
    print("📖 Reading project file...")
    with open(PROJECT_FILE, 'r') as f:
        content = f.read()
    
    existing_ids = get_existing_ids(content)
    print(f"✅ Found {len(existing_ids)} existing IDs")
    
    # Generate IDs for new files
    id_gen = generate_id()
    file_entries = []
    build_entries = []
    file_refs = {}
    
    print("🔨 Generating file entries...")
    for full_path, rel_path, filename in swift_files:
        # Skip if already exists (MoonReaderApp.swift)
        if filename == "MoonReaderApp.swift":
            continue
            
        # Generate unique IDs
        file_ref_id = next(id_gen)
        while file_ref_id in existing_ids:
            file_ref_id = next(id_gen)
        existing_ids.add(file_ref_id)
        
        build_file_id = next(id_gen)
        while build_file_id in existing_ids:
            build_file_id = next(id_gen)
        existing_ids.add(build_file_id)
        
        # Store mapping
        file_refs[rel_path] = {
            'file_ref_id': file_ref_id,
            'build_file_id': build_file_id,
            'filename': filename,
            'rel_path': rel_path
        }
        
        # Create PBXFileReference entry
        file_entry = f'\t\t{file_ref_id} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{rel_path}"; sourceTree = "<group>"; }};'
        file_entries.append(file_entry)
        
        # Create PBXBuildFile entry
        build_entry = f'\t\t{build_file_id} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {filename} */; }};'
        build_entries.append(build_entry)
    
    print(f"✅ Generated {len(file_entries)} file entries")
    
    # Add to PBXFileReference section
    print("✏️  Adding to PBXFileReference...")
    file_ref_section_end = content.find("/* End PBXFileReference section */")
    if file_ref_section_end != -1:
        indent = '\t\t'
        new_file_refs = '\n' + '\n'.join(file_entries) + '\n' + indent
        content = content[:file_ref_section_end] + new_file_refs + content[file_ref_section_end:]
    
    # Add to PBXBuildFile section
    print("✏️  Adding to PBXBuildFile...")
    build_file_section_end = content.find("/* End PBXBuildFile section */")
    if build_file_section_end != -1:
        indent = '\t\t'
        new_build_files = '\n' + '\n'.join(build_entries) + '\n' + indent
        content = content[:build_file_section_end] + new_build_files + content[build_file_section_end:]
    
    # Add to PBXGroup - MoonReader group
    print("✏️  Adding to PBXGroup...")
    moonreader_group_pattern = r'(A0FFFFF9 /\* MoonReader \*/ = \{[^}]+children = \()([^)]+)(\);[^}]+path = MoonReader;)'
    match = re.search(moonreader_group_pattern, content, re.DOTALL)
    if match:
        existing_children = match.group(2).strip()
        # Organize files by directory
        dirs = {}
        root_files = []
        for rel_path, info in file_refs.items():
            dir_path = os.path.dirname(rel_path)
            if dir_path == '':
                root_files.append(f'\t\t\t\t{info["file_ref_id"]} /* {info["filename"]} */,')
            else:
                if dir_path not in dirs:
                    dirs[dir_path] = []
                dirs[dir_path].append((info["file_ref_id"], info["filename"]))
        
        # Create group entries for directories
        group_id_gen = generate_id()
        group_entries = []
        group_map = {}
        
        for dir_path in sorted(dirs.keys()):
            parts = dir_path.split(os.sep)
            parent_id = None
            
            # Create groups for each level
            current_path = ""
            for i, part in enumerate(parts):
                current_path = os.sep.join(parts[:i+1]) if current_path else part
                
                if current_path not in group_map:
                    group_id = next(group_id_gen)
                    while group_id in existing_ids:
                        group_id = next(group_id_gen)
                    existing_ids.add(group_id)
                    group_map[current_path] = group_id
                    
                    # Get children for this group
                    if i == len(parts) - 1:
                        # Leaf directory - contains files
                        children = [f'\t\t\t\t\t{file_ref_id} /* {filename} */,' for file_ref_id, filename in dirs[dir_path]]
                        children_str = '\n'.join(children) if children else ''
                    else:
                        children_str = ''
                    
                    group_entry = f'''\t\t{group_id} /* {part} */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{children_str}
\t\t\t);
\t\t\tpath = "{part}";
\t\t\tsourceTree = "<group>";
\t\t}};'''
                    group_entries.append(group_entry)
                
                parent_id = group_map[current_path]
        
        # Add group entries to PBXGroup section
        group_section_end = content.find("/* End PBXGroup section */")
        if group_section_end != -1:
            indent = '\t\t'
            new_groups = '\n' + '\n'.join(group_entries) + '\n' + indent
            content = content[:group_section_end] + new_groups + content[group_section_end:]
        
        # Update MoonReader group children
        new_children = existing_children
        if new_children and not new_children.endswith('\n'):
            new_children += '\n'
        
        # Add root files
        for child in root_files:
            new_children += '\t\t\t\t' + child.split('\t\t\t\t')[1] if '\t\t\t\t' in child else child + '\n'
        
        # Add top-level directory groups
        top_level_dirs = set()
        for dir_path in dirs.keys():
            top_level = dir_path.split(os.sep)[0]
            if top_level not in top_level_dirs and top_level in group_map:
                new_children += f'\t\t\t\t{group_map[top_level]} /* {top_level} */,\n'
                top_level_dirs.add(top_level)
        
        content = content[:match.start(2)] + new_children + content[match.end(2):]
    
    # Add to PBXSourcesBuildPhase
    print("✏️  Adding to PBXSourcesBuildPhase...")
    sources_pattern = r'(A0FFFFFC /\* Sources \*/ = \{[^}]+files = \()([^)]+)(\);[^}]+runOnlyForDeploymentPostprocessing = 0;)'
    match = re.search(sources_pattern, content, re.DOTALL)
    if match:
        existing_files = match.group(2).strip()
        new_files = existing_files
        if new_files and not new_files.endswith('\n'):
            new_files += '\n'
        
        # Add all build file references
        for rel_path, info in sorted(file_refs.items()):
            new_files += f'\t\t\t\t{info["build_file_id"]} /* {info["filename"]} in Sources */,\n'
        
        content = content[:match.start(2)] + new_files + content[match.end(2):]
    
    print("💾 Writing updated project file...")
    with open(PROJECT_FILE, 'w') as f:
        f.write(content)
    
    print("✅ Done!")
    print(f"   - Added {len(file_entries)} file references")
    print(f"   - Added {len(build_entries)} build files")
    print(f"   - Added {len(group_entries)} groups")
    print("\n⚠️  Please verify the project file and test build")

if __name__ == "__main__":
    main()

