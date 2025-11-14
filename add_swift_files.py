#!/usr/bin/env python3
"""
Script to automatically add all Swift files to Xcode project.pbxproj
"""

import re
import os
from pathlib import Path

PROJECT_FILE = "MoonReader.xcodeproj/project.pbxproj"
SOURCE_DIR = "MoonReader"

def get_next_id(start=0x1000100):
    """Generate unique hex IDs for Xcode project"""
    current = start
    while True:
        yield f"{current:08X}"
        current += 1

def find_all_swift_files():
    """Find all Swift files in the project"""
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

def read_project_file():
    """Read the current project file"""
    with open(PROJECT_FILE, 'r') as f:
        return f.read()

def get_existing_ids(content):
    """Extract all existing IDs from project file"""
    ids = set()
    for match in re.finditer(r'\t\t([A-F0-9]{8}) /\*', content):
        ids.add(match.group(1))
    return ids

def create_file_entries(swift_files, existing_ids):
    """Create PBXFileReference and PBXBuildFile entries"""
    id_gen = get_next_id()
    file_refs = []
    build_files = []
    file_map = {}  # path -> (file_ref_id, build_file_id)
    
    for full_path, rel_path, filename in swift_files:
        # Generate IDs
        file_ref_id = next(id_gen)
        while file_ref_id in existing_ids:
            file_ref_id = next(id_gen)
        existing_ids.add(file_ref_id)
        
        build_file_id = next(id_gen)
        while build_file_id in existing_ids:
            build_file_id = next(id_gen)
        existing_ids.add(build_file_id)
        
        # Create entries
        file_ref = f'\t\t{file_ref_id} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{rel_path}"; sourceTree = "<group>"; }};'
        build_file = f'\t\t{build_file_id} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {filename} */; }};'
        
        file_refs.append(file_ref)
        build_files.append(build_file)
        file_map[full_path] = (file_ref_id, build_file_id, filename, rel_path)
    
    return file_refs, build_files, file_map

def build_group_structure(file_map):
    """Build PBXGroup structure from file paths"""
    groups = {}
    root_children = []
    
    # Organize files by directory
    dirs = {}
    for full_path, (file_ref_id, build_file_id, filename, rel_path) in file_map.items():
        dir_path = os.path.dirname(rel_path)
        if dir_path == '':
            # File in root
            root_children.append((file_ref_id, filename))
        else:
            # File in subdirectory
            if dir_path not in dirs:
                dirs[dir_path] = []
            dirs[dir_path].append((file_ref_id, filename, rel_path))
    
    # Create group entries
    id_gen = get_next_id(0x1000200)
    group_map = {}
    
    # Create groups for each directory level
    for dir_path in sorted(dirs.keys()):
        parts = dir_path.split(os.sep)
        parent_id = None
        parent_path = ""
        
        for i, part in enumerate(parts):
            current_path = os.sep.join(parts[:i+1])
            if current_path in group_map:
                parent_id = group_map[current_path]
                parent_path = current_path
                continue
            
            group_id = next(id_gen)
            group_map[current_path] = group_id
            
            # Get children
            if i == len(parts) - 1:
                # Leaf directory - contains files
                children = [f'{file_ref_id} /* {filename} */' for file_ref_id, filename, _ in dirs[dir_path]]
            else:
                # Intermediate directory - will be populated later
                children = []
            
            groups[group_id] = {
                'id': group_id,
                'name': part,
                'path': part,
                'children': children,
                'parent': parent_id,
                'full_path': current_path
            }
            parent_id = group_id
            parent_path = current_path
    
    # Build root children list
    root_children_ids = [f'{file_ref_id} /* {filename} */' for file_ref_id, filename in root_children]
    
    # Add subdirectory groups to root
    top_level_dirs = [g for g in groups.values() if g['parent'] is None]
    for group in top_level_dirs:
        root_children_ids.append(f"{group['id']} /* {group['name']} */")
    
    return groups, root_children_ids

def insert_into_section(content, section_name, new_entries, before_marker=None):
    """Insert entries into a section"""
    begin_marker = f"/* Begin {section_name} section */"
    end_marker = f"/* End {section_name} section */"
    
    begin_pos = content.find(begin_marker)
    end_pos = content.find(end_marker)
    
    if begin_pos == -1 or end_pos == -1:
        return content
    
    # Find insertion point
    if before_marker:
        insert_pos = content.find(before_marker, begin_pos, end_pos)
        if insert_pos != -1:
            # Insert before the marker
            indent = content[begin_pos:insert_pos].rfind('\n') + 1
            indent_str = content[begin_pos:indent]
            new_content = content[:insert_pos] + '\n'.join(new_entries) + '\n' + indent_str + content[insert_pos:]
            return new_content
    
    # Insert before end marker
    indent_pos = content.rfind('\n', begin_pos, end_pos) + 1
    indent_str = content[indent_pos:end_pos].replace('\t', '')[:2]  # Get indentation
    if not indent_str.startswith('\t'):
        indent_str = '\t\t'
    
    new_content = content[:end_pos] + '\n' + '\n'.join(new_entries) + '\n' + indent_str + content[end_pos:]
    return new_content

def main():
    print("🔍 Finding Swift files...")
    swift_files = find_all_swift_files()
    print(f"✅ Found {len(swift_files)} Swift files")
    
    print("📖 Reading project file...")
    content = read_project_file()
    existing_ids = get_existing_ids(content)
    print(f"✅ Found {len(existing_ids)} existing IDs")
    
    print("🔨 Creating file entries...")
    file_refs, build_files, file_map = create_file_entries(swift_files, existing_ids)
    print(f"✅ Created {len(file_refs)} file references")
    
    print("📁 Building group structure...")
    groups, root_children = build_group_structure(file_map)
    print(f"✅ Created {len(groups)} groups")
    
    print("✏️  Updating project file...")
    
    # Add PBXBuildFile entries
    content = insert_into_section(content, "PBXBuildFile", build_files)
    
    # Add PBXFileReference entries
    content = insert_into_section(content, "PBXFileReference", file_refs)
    
    # Update PBXGroup - add to root MoonReader group
    moonreader_group_pattern = r'(A0FFFFF9 /\* MoonReader \*/ = \{[^}]+children = \()([^)]+)(\);[^}]+path = MoonReader;)'
    match = re.search(moonreader_group_pattern, content, re.DOTALL)
    if match:
        existing_children = match.group(2).strip()
        new_children = existing_children
        if new_children:
            new_children += '\n'
        new_children += '\n'.join([f'\t\t\t\t{child},' for child in root_children])
        content = content[:match.start(2)] + new_children + content[match.end(2):]
    
    # Add PBXGroup entries for directories
    group_entries = []
    for group in groups.values():
        children_str = '\n'.join([f'\t\t\t\t{child},' for child in group['children']]) if group['children'] else ''
        group_entry = f'''\t\t{group['id']} /* {group['name']} */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{children_str}
\t\t\t);
\t\t\tpath = "{group['path']}";
\t\t\tsourceTree = "<group>";
\t\t}};'''
        group_entries.append(group_entry)
    
    content = insert_into_section(content, "PBXGroup", group_entries)
    
    # Update PBXSourcesBuildPhase - add all build files
    sources_pattern = r'(A0FFFFFC /\* Sources \*/ = \{[^}]+files = \()([^)]+)(\);[^}]+runOnlyForDeploymentPostprocessing = 0;)'
    match = re.search(sources_pattern, content, re.DOTALL)
    if match:
        existing_files = match.group(2).strip()
        new_files = existing_files
        if new_files:
            new_files += '\n'
        new_files += '\n'.join([f'\t\t\t\t{build_file_id} /* {filename} in Sources */,' for _, (build_file_id, _, filename, _) in file_map.items()])
        content = content[:match.start(2)] + new_files + content[match.end(2):]
    
    print("💾 Writing updated project file...")
    with open(PROJECT_FILE, 'w') as f:
        f.write(content)
    
    print("✅ Done! Project file updated.")
    print(f"   - Added {len(file_refs)} file references")
    print(f"   - Added {len(build_files)} build files")
    print(f"   - Added {len(groups)} groups")
    print("\n⚠️  Note: Please verify the project file and test build in Xcode")

if __name__ == "__main__":
    main()

