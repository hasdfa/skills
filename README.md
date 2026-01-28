# Claude Code Skills Collection

A collection of skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Installation

Install a skill using the `skills` CLI:

```bash
npx skills add https://github.com/hasdfa/skills --skill stackblitz
```

Or install all skills:

```bash
npx skills add https://github.com/hasdfa/skills
```

## Available Skills

### stackblitz

Download source code from StackBlitz public projects into a local `.context/stackblitz/` folder. Use when a user shares a StackBlitz preview URL (e.g., `stackblitz.com/edit/abc123`) and wants to analyze, run, or work with the code locally.

**Usage:** Share a StackBlitz URL and the skill will download the project files for local analysis.

### codesandbox

Download source code from CodeSandbox public projects into a local `.context/csb/` folder. Use when a user shares a CodeSandbox URL (e.g., `codesandbox.io/s/abc123`) and wants to analyze, run, or work with the code locally.

**Usage:** Share a CodeSandbox URL and the skill will download the project files for local analysis.

## License

MIT
