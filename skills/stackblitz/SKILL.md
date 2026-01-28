---
name: stackblitz
description: Download source code from StackBlitz public projects into local .context/stackblitz/ folder. Use when user shares a StackBlitz preview URL (e.g., stackblitz.com/edit/abc123) and wants to analyze, run, or work with the code locally.
allowed-tools: ["Bash", "Read", "Write", "Glob", "Grep"]
---

# StackBlitz Project Downloader

## Overview

Downloads source code from public StackBlitz projects into a structured local directory for analysis, modification, or local execution. Extracts project files via StackBlitz's API and organizes them in `.context/stackblitz/{project-id}/`.

## When to Use

- User shares a StackBlitz URL like `https://stackblitz.com/edit/1fkuu1yx?file=src%2FDemo.tsx`
- User wants to analyze code from a StackBlitz example
- User wants to run a StackBlitz project locally
- User references a StackBlitz demo and needs the source code

## Instructions

### Step 1: Extract Project ID from URL

Parse the StackBlitz URL to extract the project ID. Supported URL formats:
- `https://stackblitz.com/edit/{project-id}`
- `https://stackblitz.com/edit/{project-id}?file=...`
- `https://stackblitz.com/github/{owner}/{repo}`

For edit URLs, the project ID is the path segment after `/edit/` (before any query params).

### Step 2: Download Project Files

Run the download script to fetch all project files:

```bash
bash "$(dirname "$0")/scripts/download-stackblitz.sh" {project-id}
```

This will:
1. Fetch project metadata from StackBlitz API
2. Download all source files
3. Save them to `.context/stackblitz/{project-id}/`

### Step 3: Explore Downloaded Code

After download, the project structure will be at `.context/stackblitz/{project-id}/`. Use Read and Glob tools to explore:

```bash
# List all files
ls -la .context/stackblitz/{project-id}/

# Find specific file types
find .context/stackblitz/{project-id}/ -name "*.tsx"
```

### Step 4: Run Locally (Optional)

If the user wants to run the project locally:

1. Check for `package.json` to identify the project type
2. Install dependencies: `cd .context/stackblitz/{project-id} && npm install`
3. Start dev server: `npm run dev` or `npm start`

## Bundled Resources

**scripts/download-stackblitz.sh** - Downloads StackBlitz project files via their public API
- Input: StackBlitz project ID
- Output: Project files saved to `.context/stackblitz/{project-id}/`

## Examples

**User shares StackBlitz URL:**
```
User: "Can you download this StackBlitz project? https://stackblitz.com/edit/1fkuu1yx?file=src%2FDemo.tsx"
Claude: I'll download that StackBlitz project for you.
[Extracts project ID: 1fkuu1yx]
[Runs download script]
[Reports downloaded files and structure]
```

**User wants to analyze demo code:**
```
User: "Look at this MUI demo https://stackblitz.com/edit/mui-datagrid-example and explain how it works"
Claude: I'll download the code and analyze it.
[Downloads project]
[Reads relevant source files]
[Explains the implementation]
```

## Notes

- Only works with **public** StackBlitz projects
- GitHub-linked projects (`/github/owner/repo`) may require different handling
- Large projects may take longer to download
- The `.context/` directory is gitignored by default in most projects
