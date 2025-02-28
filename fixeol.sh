#!/bin/bash

# Convert line-endings for whole directory tree (Git)
# https://stackoverflow.com/questions/7068179/convert-line-endings-for-whole-directory-tree-git
# Here is a one-liner that recursively replaces line endings and properly handles whitespace, quotes, and shell meta chars.
# If you're using dos2unix 6.0 binary files will be ignored.

# On Windows use Git Bash (MINGW64)
# cd /c/

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#find $this_file_dir -maxdepth 3 -type f \( -iname '*.sh' -or -iname '*.conf' -or -iname '*.config' -or -iname '*.yml' -or -iname '*.yaml' -or -iname '*.template' \) -exec ls -lad {} \;
find $this_file_dir -maxdepth 3 -type f \( -iname '*.sh' -or -iname '*.conf' -or -iname '*.config' -or -iname '*.yml' -or -iname '*.yaml' -or -iname '*.template' \) -exec dos2unix {} \;
