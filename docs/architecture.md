# 架构说明

## 四层架构

本仓库采用四层架构，将入口定义、法律内容、运行环境和 MCP 连接器分离：

`
Claude-for-Legal-CN-to-Codex                    ← 包装层（本仓库）
  skills/*/SKILL.md                      入口定义 + 路由规则
  install.ps1                            一键安装
  update.ps1                             手动更新
  docs/                                  文档
         │
         │ 依赖上游（自动拉取）
         ▼
~/.codex/vendor/claude-for-legal-CN/    ← 内容层（上游缓存）
  CLAUDE.md + references                  工作流指令 + 法条参考
         │
         │ 安装到
         ▼
~/.codex/skills/<domain>/               ← 运行层
  SKILL.md                               本仓库提供（入口）
  CLAUDE.md + references                 上游同步
  skills/ + agents/                      上游同步
         │
         │ MCP 配置写入
         ▼
~/.codex/config.toml                    ← MCP 层
  [mcp_servers.chineselaw]               chineselaw-mcp（33 个工具）
  [mcp_servers.pkulaw-*]                 北大法宝 MCP 协议（10 个服务）
`

## 各层职责

| 层级 | 内容 | 维护者 |
|------|------|--------|
| 包装层 | SKILL.md、安装脚本、文档 | 本仓库 |
| 内容层 | CLAUDE.md、references 法条参考 | 上游仓库（SH88-source） |
| 运行层 | 技能实际执行目录 | install.ps1 自动管理 |
| MCP 层 | 法律检索连接器配置 | install.ps1 写入 + 用户替换凭证 |

## MCP 连接器架构

| 连接器 | 方式 | 用途 |
|--------|------|------|
| chineselaw-mcp | stdio（npx） | Codex 内法律检索（33 工具） |
| 北大法宝 MCP 协议 | HTTP（10 服务） | Codex 内法律检索 |
| @pkulaw/mcp-cli | CLI 命令行 | 调试 Token、查看服务、脚本自动化 |

chineselaw 和北大法宝 MCP 协议直接集成到 Codex，通过 config.toml 的 [mcp_servers] 段加载。
@pkulaw/mcp-cli 为独立 CLI 工具，安装在系统级，用于调试和验证。

## 更新流程

`
用户触发法律任务 → 根技能激活 → git pull 同步上游
→ 检查 config.toml MCP 状态 → 读取最新内容 → 完成
`

## 依赖关系

- **SH88-source/claude-for-legal-CN**（Apache 2.0）— 当前直接上游
  - 源流：anthropics/claude-for-legal → zhou210712/claude-for-legal-ZH → SH88-source

详细项目关系分析见 docs/project-analysis.md。