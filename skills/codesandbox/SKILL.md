---
name: codesandbox
description: Download source code from CodeSandbox public projects into local .context/csb/ folder. Use when user shares a CodeSandbox URL (e.g., codesandbox.io/s/abc123) and wants to analyze, run, or work with the code locally.
allowed-tools: ["Bash", "Read", "Write", "Glob", "Grep"]
---

# CodeSandbox Project Downloader

## Overview

Downloads source code from public CodeSandbox projects into a structured local directory for analysis, modification, or local execution. Extracts project files via CodeSandbox's API and organizes them in `.context/csb/{sandbox-id}/`.

## When to Use

- User shares a CodeSandbox URL like `https://codesandbox.io/s/cjgvhx`
- User wants to analyze code from a CodeSandbox example
- User wants to run a CodeSandbox project locally
- User references a CodeSandbox demo and needs the source code

## Instructions

### Step 1: Extract Sandbox ID from URL

Parse the CodeSandbox URL to extract the sandbox ID. Supported URL formats:
- `https://codesandbox.io/s/{sandbox-id}`
- `https://codesandbox.io/s/{sandbox-id}?file=...`
- `https://codesandbox.io/embed/{sandbox-id}`

For these URLs, the sandbox ID is the path segment after `/s/` or `/embed/` (before any query params).

### Step 2: Download Project Files

Run the download script to fetch all project files:

```bash
node "$(dirname "$0")/scripts/download-csb.mjs" {sandbox-id-or-url}
```

This will:
1. Fetch sandbox data from CodeSandbox API
2. Download all source files (binary files are skipped)
3. Save them to `.context/csb/{sandbox-id}/`
4. Create a `.csb-manifest.json` with metadata

### Step 3: Explore Downloaded Code

After download, the project structure will be at `.context/csb/{sandbox-id}/`. Use Read and Glob tools to explore:

```bash
# List all files
ls -la .context/csb/{sandbox-id}/

# Find specific file types
find .context/csb/{sandbox-id}/ -name "*.tsx"
```

### Step 4: Run Locally (Optional)

If the user wants to run the project locally:

1. Check for `package.json` to identify the project type
2. Install dependencies: `cd .context/csb/{sandbox-id} && pnpm install`
3. Start dev server: `pnpm dev` or `pnpm start`

## Bundled Resources

**scripts/download-csb.mjs** - Downloads CodeSandbox project files via their public API
- Input: CodeSandbox sandbox ID or full URL
- Output: Project files saved to `.context/csb/{sandbox-id}/`
- Note: Binary files are skipped during download

## Examples

**User shares CodeSandbox URL:**
```
User: "Can you download this CodeSandbox project? https://codesandbox.io/s/cjgvhx"
Claude: I'll download that CodeSandbox project for you.
[Extracts sandbox ID: cjgvhx]
[Runs download script]
[Reports downloaded files and structure]
```

**User wants to analyze demo code:**
```
User: "Look at this React demo https://codesandbox.io/s/react-hooks-example and explain how it works"
Claude: I'll download the code and analyze it.
[Downloads project]
[Reads relevant source files]
[Explains the implementation]
```

## Notes

- Only works with **public** CodeSandbox projects
- Binary files (images, etc.) are skipped during download
- Large projects may take longer to download
- The `.context/` directory is gitignored by default in most projects
