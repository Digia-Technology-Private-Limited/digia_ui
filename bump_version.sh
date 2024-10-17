#!/bin/bash

# Get the changelog and version type from the GitHub Action inputs
changelog_input=$1
version_type=$2

# Parse the changelog input into an array
IFS=';' read -r -a changelog_lines <<< "$changelog_input"

# Read the pubspec.yaml version
current_version=$(grep '^version:' pubspec.yaml | sed 's/version: //')

# Parse the current version
major=$(echo $current_version | cut -d '.' -f 1)
minor=$(echo $current_version | cut -d '.' -f 2)
patch=$(echo $current_version | cut -d '.' -f 3 | cut -d '-' -f 1)
beta=$(echo $current_version | grep -o 'beta.[0-9]*' | cut -d '.' -f 2)

# If beta is empty, set it to 0
if [ -z "$beta" ]; then
  beta=0
fi

# Bump the version based on input
case "$version_type" in
  major)
    major=$((major + 1))
    minor=0
    patch=0
    beta=0
    ;;
  minor)
    minor=$((minor + 1))
    patch=0
    beta=0
    ;;
  patch)
    patch=$((patch + 1))
    beta=0
    ;;
  beta)
    beta=$((beta + 1))
    ;;
  *)
    echo "Invalid version bump type"
    exit 1
    ;;
esac

# Build the new version string
if [ "$beta" -gt 0 ]; then
  new_version="$major.$minor.$patch-beta.$beta"
else
  new_version="$major.$minor.$patch"
fi

# Update pubspec.yaml
sed -i "s/^version: .*/version: $new_version/" pubspec.yaml

# Update version.dart
echo "// Generated code. Do not modify." > lib/src/version.dart
echo "const packageVersion = '$new_version';" >> lib/src/version.dart

# Add changelog entry to CHANGELOG.md
date=$(date +'%Y-%m-%d')  # Get today's date in YYYY-MM-DD format
new_entry="## [$new_version] - $date"

# Create a temporary file for the new changelog
temp_file=$(mktemp)

# Add new entry and changelog lines to the temp file
{
  # Write the first 4 lines of CHANGELOG.md (preserve existing structure)
  head -n 4 CHANGELOG.md
  
  # Add new version entry
  echo "$new_entry"
  echo ""
  
  # Loop through the changelog lines and format them
  for line in "${changelog_lines[@]}"; do
      trimmed_line=$(echo "$line" | sed 's/^[ \t]*//')
      # Capitalize the first character of the trimmed line
      capitalized_line="$(tr '[:lower:]' '[:upper:]' <<< "${trimmed_line:0:1}")${trimmed_line:1}"
      echo "- $capitalized_line"  # Add the entry
  done
  echo ""
  # Append the rest of CHANGELOG.md
  tail -n +5 CHANGELOG.md
} > "$temp_file"

# Replace the original CHANGELOG.md with the updated temp file
mv "$temp_file" CHANGELOG.md
echo "new_version=$new_version" >> $GITHUB_ENV
