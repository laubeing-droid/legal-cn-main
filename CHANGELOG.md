# 更新日志

## [1.0.1] - 2026-05-23

### 修复
- install.ps1: 修复根技能安装时目录未创建的 Bug
- install.ps1: 简化上游路径逻辑，统一使用 ~/.codex/vendor/claude-for-legal-CN
- update.ps1: 修复转义字符错误，重构路径逻辑
- SKILL.md: 统一 12 个领域技能的 description 和 keywords 格式

### 新增
- uninstall.ps1: 一键卸载所有已安装技能和上游缓存
- verify.ps1: 安装后完整性检查脚本
- .gitattributes: 统一行尾符号（LF），消除 git 警告
- .gitignore: 完善忽略规则

### 改进
- GitHub Actions: 增加 commit SHA 缓存，仅在有实际更新时创建 Issue
- README: 更新架构图，增加新脚本说明
- 文档: 配置 .gitattributes 后消除 LF/CRLF 警告杂音

## [1.0.0] - 2026-05-23

### 新增
- 13 个 Codex 技能（1 根技能 + 12 领域技能）
- 自动路由：根据关键词自动分发到对应法律领域
- 自动更新：每次调用法律技能时自动同步上游
- 上游监测：GitHub Actions 每周自动检查
- install.ps1 / update.ps1 安装更新脚本

### 文档
- README / QUICKSTART / CHANGELOG
- project-analysis.md / usage-guide.md / architecture.md
- connectors.md / troubleshooting.md / contributing.md

### 上游
- 基于 SH88-source/claude-for-legal-CN 整合
- 源流：anthropics/claude-for-legal → zhou210712/claude-for-legal-ZH → SH88-source