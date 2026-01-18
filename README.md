# Skillhub MCP

[![PyPI version](https://img.shields.io/pypi/v/skillhub-mcp.svg)](https://pypi.org/project/skillhub-mcp/)
[![PyPI downloads](https://img.shields.io/pypi/dm/skillhub-mcp.svg)](https://pypi.org/project/skillhub-mcp/)

## Links

- PyPI: https://pypi.org/project/skillhub-mcp/
- PyPI v1.0.0: https://pypi.org/project/skillhub-mcp/1.0.0/
- Skills directory: http://skills.214140846.net/

You already have Claude-style skills (`SKILL.md`), but in practice you often hit a wall:

- your client speaks MCP, not Claude Skills
- your team uses multiple agents (Cursor, Copilot, Codex, etc.), so skills are painful to reuse across tools
- you want a more flexible way to organize and ship skills (nested folders, zip packaging)

**Skillhub MCP** bridges that gap: it turns Claude-style skills into MCP tools, so any MCP client can call the same skills.

> ⚠️ Experimental. Skills may contain scripts/resources. Treat them as untrusted and run with sandboxes/containers when possible.

## What You Get

- Cross-client reuse: install once, use from any MCP client
- Flexible packaging: nested directories, `.zip` and `.skill` archives
- Skill resources: expose scripts/datasets/examples as MCP resources (files the client can read)
- Resource fallback: a `fetch_resource` tool for clients without native MCP resource support
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

## Safety Notes

- Skills are not "just prompts": they can include scripts and arbitrary files.
- Skillhub MCP does not run scripts, but your client might. Prefer running in a sandbox/container.

## Language

- English: `README.md`
- 中文: `README.zh-CN.md`
