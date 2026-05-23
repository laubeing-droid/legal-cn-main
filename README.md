# Codex 中国法律技能包 (codex-legal-cn-skills)

面向中国律师的 Codex 法律工作技能集。覆盖诉讼仲裁、商事合同、劳动用工、
数据合规、知识产权等 12 个核心法律领域，安装即用、自动更新。

## 快速安装

`powershell
# 克隆本仓库
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills

# 一键安装（自动拉取上游内容 + 安装到 Codex）
.\install.ps1
`

安装后重启 Codex，直接描述你的法律任务即可：

> "帮我审查这份 SaaS 合同" → commercial-legal
> "分析管辖权问题" → litigation-legal
> "评估个人信息保护风险" → privacy-legal

## 技能一览（12 个领域 + 1 个根路由）

| 技能 | 领域 | 说明 |
|---|---|---|
| codex-for-legal-cn | 根路由 | 自动识别任务类型并分发 |
| commercial-legal | 商事合同 | 合同审查、SaaS、NDA、供应商协议 |
| litigation-legal | 诉讼仲裁 | 证据管理、文书起草、保全、管辖 |
| employment-legal | 劳动用工 | 解除审查、竞业限制、规章制度 |
| privacy-legal | 数据合规 | 个保法、数据出境、影响评估 |
| corporate-legal | 公司交易 | 并购尽调、公司治理、三会文件 |
| ip-legal | 知识产权 | 商标专利、FTO、侵权分析 |
| product-legal | 产品合规 | 上线审查、广告法、风险评估 |
| egulatory-legal | 监管合规 | 动态监测、政策差距分析 |
| i-governance-legal | AI治理 | 算法评估、伦理审查 |
| law-student | 法学生 | 法考练习、IRAC、案例摘要 |
| legal-clinic | 法律诊所 | 法律援助、客户接谈 |
| legal-builder-hub | 技能治理 | 技能发现与管理 |

## 架构

`
本仓库 (包装层)
  ├── skills/          SKILL.md 入口定义 + 路由规则
  ├── scripts/         安装/更新脚本
  └── install.ps1      一键安装

         │ 首次安装 & 每次启用时自动 git pull
         ▼
SH88-source/claude-for-legal-CN (上游)
  ├── CLAUDE.md         完整工作流指令 (10~44KB/每个领域)
  ├── references/       中国法核心规则参考
  └── skills/           各子技能 SKILL.md
`

## 自动更新机制

每次在 Codex 中触发法律任务时，codex-for-legal-cn 根技能自动执行：

1. git pull 拉取上游最新内容
2. 同步 CLAUDE.md + references + 子技能到 ~/.codex/skills/
3. 本次对话直接生效

## 手动更新

`powershell
.\update.ps1
`

## 许可证

Apache License 2.0
