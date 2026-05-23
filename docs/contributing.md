# 贡献指南

## 仓库结构

`
Claude-for-Legal-CN-to-Codex/
  skills/<domain>/SKILL.md   入口定义（轻量，本仓库维护）
  install.ps1                一键安装脚本
  update.ps1                 更新脚本
  uninstall.ps1              卸载脚本
  verify.ps1                 安装验证脚本
  docs/                      文档
  .github/workflows/         GitHub Actions 配置
`

## 设计原则

本仓库是**包装层**，不直接包含上游法律内容。技能使用两层指令设计：

1. **SKILL.md** — 入口定义：做什么、何时使用、路由关键词
2. **CLAUDE.md** — 完整工作流（位于上游仓库）：步骤、输出框架、质量标准和护栏

## 编辑指南

### 本仓库适合修改的内容

- SKILL.md 中的路由关键词和触发规则
- 安装/更新/卸载脚本（install.ps1, update.ps1, uninstall.ps1, verify.ps1）
- MCP 连接器配置逻辑（在 install.ps1 / update.ps1 中）
- 文档完善（docs/ 目录下所有文件）
- GitHub Actions 工作流配置

### 本仓库不直接修改的内容

- 法律工作流指令（CLAUDE.md）— 请直接编辑上游仓库
- 法律参考文件（references/）— 请直接编辑上游仓库
- 子技能内容 — 请直接编辑上游仓库

### 法律内容修改流程

1. 修改上游仓库（SH88-source/claude-for-legal-CN 或更上游）
2. 本仓库的自动更新机制会在下次使用时同步变更

### MCP 连接器修改

MCP 连接器配置通过 install.ps1 的 Add-McpServerToConfig 函数写入 ~/.codex/config.toml。
如需新增或修改连接器，编辑 install.ps1 和 update.ps1 中对应的配置段。

## 提交 PR

1. 确保更改不影响现有功能
2. 更新相关文档
3. 提交 PR 到 https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex