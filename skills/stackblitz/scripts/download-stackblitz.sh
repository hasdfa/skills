#!/bin/bash
# Download source code from a public StackBlitz project
# Usage: ./download-stackblitz.sh <project-id>
#
# Example: ./download-stackblitz.sh 1fkuu1yx
# Output: Files saved to .context/stackblitz/1fkuu1yx/

set -e

PROJECT_ID="$1"

if [ -z "$PROJECT_ID" ]; then
    echo "Usage: $0 <project-id>"
    echo "Example: $0 1fkuu1yx"
    exit 1
fi

# Determine output directory (relative to where script is called from)
OUTPUT_DIR=".context/stackblitz/${PROJECT_ID}"
ZIP_FILE="${OUTPUT_DIR}.zip"

echo "Downloading StackBlitz project: ${PROJECT_ID}"
echo "Output directory: ${OUTPUT_DIR}"

# Create parent directory
mkdir -p "$(dirname "${OUTPUT_DIR}")"

# Download zip from stackblitz.zip
ZIP_URL="https://stackblitz.zip/edit/${PROJECT_ID}"

echo "Fetching project from: ${ZIP_URL}"

curl -L -f -o "${ZIP_FILE}" "${ZIP_URL}" 2>&1 || {
    echo "Error: Failed to download project. Make sure the project ID is correct and the project is public."
    echo "URL attempted: ${ZIP_URL}"
    rm -f "${ZIP_FILE}"
    exit 1
}

# Verify we got a valid zip file
if ! file "${ZIP_FILE}" | grep -q "Zip archive"; then
    echo "Error: Downloaded file is not a valid zip archive"
    rm -f "${ZIP_FILE}"
    exit 1
fi

# Create output directory and extract
mkdir -p "${OUTPUT_DIR}"
echo "Extracting files..."

unzip -q -o "${ZIP_FILE}" -d "${OUTPUT_DIR}"

# Remove the zip file
rm -f "${ZIP_FILE}"
echo "Cleaned up zip file"

# Create info file
{
    echo "# StackBlitz Project: ${PROJECT_ID}"
    echo ""
    echo "Downloaded from: https://stackblitz.com/edit/${PROJECT_ID}"
    echo "Downloaded at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
} > "${OUTPUT_DIR}/.stackblitz-info.md"

# Count actual files created
ACTUAL_COUNT=$(find "${OUTPUT_DIR}" -type f | wc -l | tr -d ' ')

echo ""
echo "Download complete!"
echo "Files saved to: ${OUTPUT_DIR}"
echo "Total files: ${ACTUAL_COUNT}"

# List the structure
echo ""
echo "Project structure:"
if command -v tree &> /dev/null; then
    tree "${OUTPUT_DIR}" -L 3 --noreport 2>/dev/null || ls -la "${OUTPUT_DIR}"
else
    find "${OUTPUT_DIR}" -type f | head -20
    TOTAL=$(find "${OUTPUT_DIR}" -type f | wc -l | tr -d ' ')
    if [ "${TOTAL}" -gt 20 ]; then
        echo "... and $((TOTAL - 20)) more files"
    fi
fi
