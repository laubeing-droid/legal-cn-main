# 项目关系分析

> 最后更新：2026-05-25

## 生态演进

```
anthropics/claude-for-legal（Anthropic 官方，美国法）
  → zhou210712/claude-for-legal-ZH（中国化汉化）
    → 本仓库（Codex 全功能整合）
```

## 上游关系（当前）

| 上游 | 关系 | 状态 |
|:----|:----|:----:|
| zhou210712/claude-for-legal-ZH | 12 个法律领域的内容来源 | 已断开自动同步，仅监控 |
| saysoph/solo-law-firm-agents | solo-law-firm 来源 | 已断开自动同步，仅监控 |
| MAXXXXXLI/workbuddy-cn-legal-skills | 14 个语境文件来源 | 仅通过 diff-tool 比对 |
| anthropics/claude-for-legal | 原始 US 版框架 | 仅参考监控 |

## 本仓库增强

| 增强 | 说明 |
|:----|:-----|
| qulv 知识库 | 22 部官方 PDF，替代摘要式法条 |
| PRC-US 对齐 | 12 领域映射 + 6 护栏文件 |
| 5 个子技能中国化 | 删除 1 + 改名 1 + 重写 3 |
| solo-law-firm 自研 | 27 技能含自研庭审提纲生成器 |
| 4 路 diff-tool | 统一上游变更检测 |
