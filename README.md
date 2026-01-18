# Skillhub MCP

[![PyPI version](https://img.shields.io/pypi/v/skillhub-mcp.svg)](https://pypi.org/project/skillhub-mcp/)
[![PyPI downloads](https://img.shields.io/pypi/dm/skillhub-mcp.svg)](https://pypi.org/project/skillhub-mcp/)

You already have Claude-style skills (`SKILL.md`) but:

- your client supports MCP, not Claude Skills
- your team uses multiple clients (Cursor, Copilot, Codex, etc.) and skills are hard to reuse
- you want a looser skills directory format (nested folders, zip packaging)

**Skillhub MCP** bridges that gap: it turns Claude-style skills into callable MCP tools, so any MCP client can invoke the same skills.

> ⚠️ Experimental. Skills often include scripts/resources; treat them as untrusted. Use sandboxes/containers for isolation.

> Skill directory: **[Skills Supermarket](http://skills.214140846.net/)**.

## What You Get

- Cross-client reuse: write/install once, call from any MCP client
- Flexible packaging: nested directories, `.zip` and `.skill` archives
- Skill resources: expose additional files (scripts, datasets, examples) as MCP resources
- Fallback resource fetch: a `fetch_resource` tool for clients without native MCP resource support
- Multiple transports: `stdio` (default), `http`, `sse`

## Quick Start

Default skills root: `~/.skillhub-mcp`

### uvx (recommended)

```json
{
  "skillhub-mcp": {
    "command": "uvx",
    "args": ["skillhub-mcp@latest"]
  }
}
```

Use a custom skills root:

```json
{
  "skillhub-mcp": {
    "command": "uvx",
    "args": ["skillhub-mcp@latest", "/path/to/skills"]
  }
}
```

### Docker (isolation)

Replace `/path/to/skills` with your skills directory. Any arguments after the
image name are passed to the Skillhub MCP CLI.

```json
{
  "skillhub-mcp": {
    "command": "docker",
    "args": [
      "run",
      "-i",
      "--rm",
      "-v",
      "/path/to/skills:/skillhub-mcp",
      "214140846/skillhub-mcp",
      "/skillhub-mcp"
    ]
  }
}
```

## Skill Format

Skillhub MCP discovers skills under the root directory (default `~/.skillhub-mcp`).
Each skill can be:

- a directory containing `SKILL.md`
- a `.zip` or `.skill` archive containing `SKILL.md` (at the archive root or
  inside a single top-level folder)

All other files become downloadable MCP resources for your agent to read. Note:
Skillhub MCP does not execute scripts; the client decides whether/how to run them.

Example layout:

```text
~/.skillhub-mcp/
├── summarize-docs/
│   ├── SKILL.md
│   ├── summarize.py
│   └── prompts/example.txt
├── translate.zip
├── analyzer.skill
└── web-search/
    └── SKILL.md
```

Archive rules:

```text
translate.zip
├── SKILL.md
└── helpers/
    └── translate.js
```

```text
data-cleaner.zip
└── data-cleaner/
    ├── SKILL.md
    └── clean.py
```

## Directory Structure: Skillhub MCP vs Claude Code

Claude Code expects a flat skills directory (each immediate subdirectory is one
skill). Skillhub MCP is more permissive:

- nested directories are discovered
- `.zip` / `.skill` packaged skills are supported

If you need Claude Code compatibility, keep the flat layout.

## CLI Reference

`skillhub-mcp [skills_root] [options]`

| Flag / Option | Description |
| --- | --- |
| positional `skills_root` | Optional skills directory (defaults to `~/.skillhub-mcp`). |
| `--transport {stdio,http,sse}` | Transport (default `stdio`). |
| `--host HOST` | Bind address for HTTP/SSE transports. |
| `--port PORT` | Port for HTTP/SSE transports. |
| `--path PATH` | URL path for HTTP transport. |
| `--list-skills` | List discovered skills and exit. |
| `--verbose` | Emit debug logging. |
| `--log` | Mirror verbose logs to `/tmp/skillhub-mcp.log`. |

## Language

- English: `README.md`
- 中文: `README.zh-CN.md`
