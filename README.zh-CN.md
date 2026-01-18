# Skillhub MCP

[![PyPI version](https://img.shields.io/pypi/v/skillhub-mcp.svg)](https://pypi.org/project/skillhub-mcp/)
[![PyPI downloads](https://img.shields.io/pypi/dm/skillhub-mcp.svg)](https://pypi.org/project/skillhub-mcp/)

你已经有一套 Claude 风格的 Skills `SKILL.md`，但经常会遇到：

- 你的客户端只支持 MCP，不原生支持 Claude Skills
- 团队里用的客户端很多（Cursor、Copilot、Codex 等），Skills 难以“跨工具复用”
- 想要更灵活的目录组织与分发方式（嵌套目录、打包成 zip 等）

**Skillhub MCP** 的定位很简单：把 Claude 风格的 Skills 转成可被任何 MCP 客户端调用的 MCP tools，让你实现“**一次写或装，多处用**”。

> ⚠️ 试验性项目。Skills 往往包含脚本与资源文件，请当作不可信代码对待，建议用沙箱或容器隔离。

> Skills 目录：**[Skills Supermarket](http://skills.214140846.net/)**。

## 你会得到什么

- 跨客户端复用：同一套 Skills，任意 MCP 客户端都能调用
- 更宽松的组织与分发：支持嵌套目录，支持 `.zip` / `.skill` 打包
- 资源透出：脚本、数据集、示例等作为 MCP resources 暴露给客户端读取
- 资源兜底能力：提供 `fetch_resource` 工具，兼容不支持原生 MCP 资源拉取的客户端
- 标准化连接方式：支持 `stdio`（默认）、`http`、`sse`

## 快速开始

默认 skills 根目录：`~/.skillhub-mcp`

### uvx（推荐）

```json
{
  "skillhub-mcp": {
    "command": "uvx",
    "args": ["skillhub-mcp@latest"]
  }
}
```

指定自定义 skills 根目录：

```json
{
  "skillhub-mcp": {
    "command": "uvx",
    "args": ["skillhub-mcp@latest", "/path/to/skills"]
  }
}
```

### Docker（隔离运行）

把 `/path/to/skills` 替换成你的 skills 目录。数组中镜像名之后的参数会原样传给 Skillhub MCP 的 CLI。

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

## Skill 目录与打包规则

Skillhub MCP 会从 skills 根目录（默认 `~/.skillhub-mcp`）递归发现技能。每个技能可以是：

- 一个包含 `SKILL.md` 的目录
- 一个包含 `SKILL.md` 的 `.zip` / `.skill` 压缩包
  - `SKILL.md` 可以放在压缩包根目录
  - 也可以放在压缩包的单一顶层目录内

除 `SKILL.md` 以外的文件会作为 MCP resources 对外暴露，客户端可按需读取。注意：Skillhub MCP **不会执行**这些脚本，是否以及如何执行由客户端决定。

示例目录：

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

压缩包规则示例：

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

## 目录结构对比：Skillhub MCP 与 Claude Code

Claude Code 要求 skills 目录是“扁平”的：每个直接子目录就是一个 skill。Skillhub MCP 更宽松：

- 支持嵌套目录
- 支持 `.zip` / `.skill` 打包形式

如果你希望与 Claude Code 共用同一份 skills 目录，请保持扁平结构。

## CLI 参数

`skillhub-mcp [skills_root] [options]`

| 参数 | 说明 |
| --- | --- |
| 位置参数 `skills_root` | skills 根目录（默认 `~/.skillhub-mcp`）。 |
| `--transport {stdio,http,sse}` | 传输层（默认 `stdio`）。 |
| `--host HOST` | HTTP/SSE 绑定地址。 |
| `--port PORT` | HTTP/SSE 端口。 |
| `--path PATH` | HTTP 传输层的 URL 路径。 |
| `--list-skills` | 列出已发现的 skills 并退出。 |
| `--verbose` | 输出更详细的日志。 |
| `--log` | 将 verbose 日志同时写入 `/tmp/skillhub-mcp.log`。 |

## 语言

- English: `README.md`
- 中文: `README.zh-CN.md`

