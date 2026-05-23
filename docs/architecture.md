# 架构说明

## 三层结构

`
本仓库 (codex-legal-cn-skills)          ← 包装层
  ├── skills/*/SKILL.md                 入口定义 + 路由规则
  ├── install.ps1                       一键安装
  └── update.ps1                        手动更新
         │
         │ 依赖上游 (git submodule 或独立克隆)
         ▼
SH88-source/claude-for-legal-CN          ← 内容层
  ├── commercial-legal/
  │   ├── CLAUDE.md                     完整工作流指令
  │   ├── references/                    中国法核心规则
  │   └── skills/*/SKILL.md              子技能
  ├── litigation-legal/
  └── ...
         │
         │ 安装到
         ▼
~/.codex/skills/<domain>/               ← 运行层
  ├── SKILL.md                           本仓库提供
  ├── CLAUDE.md                          上游提供，自动同步
  ├── references/                        上游提供
  └── skills/                            上游提供
`

## 更新流程

`
用户触发法律任务
  → 根技能 codex-for-legal-cn 激活
  → 执行 git pull 拉取上游最新
  → 同步 CLAUDE.md + references 到 ~/.codex/skills/
  → 读取最新内容完成任务
`

## 依赖关系

- SH88-source/claude-for-legal-CN (Apache 2.0)
  - 上游 fork 自 zhou210712/claude-for-legal-ZH
  - 原始汉化自 Anthropic claude-for-legal
