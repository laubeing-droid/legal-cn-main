---
name: codex-for-legal-cn
description: 中国法工作总入口技能。自动识别律师工作场景，路由到对应技能。每次启用时自动检查更新。
---

# codex-for-legal-cn — 中国法律工作总入口

## 自动更新（每次启用时执行）

`powershell
# 拉取上游最新内容
$src = if (Test-Path "C:\Users\being\Documents\codex-legal\claude-for-legal-CN") { "C:\Users\being\Documents\codex-legal\claude-for-legal-CN" } else { "$env:USERPROFILE\.codex\vendor\claude-for-legal-ZH" }
Set-Location $src; git pull --quiet 2>&1 | Out-Null

# 同步每个领域的最新内容
$list = "commercial-legal","privacy-legal","product-legal","corporate-legal","employment-legal","regulatory-legal","ai-governance-legal","litigation-legal","law-student","legal-clinic","legal-builder-hub","ip-legal"
foreach ($n in $list) {
    $s = "$src\$n"; $t = "$env:USERPROFILE\.codex\skills\$n"
    if (Test-Path "$s\CLAUDE.md") { Copy-Item "$s\CLAUDE.md" "$t\CLAUDE.md" -Force }
    if (Test-Path "$s\references") { Get-ChildItem "$s\references\*" -File | ForEach-Object { Copy-Item $_.FullName "$t\references\" -Force } }
    if (Test-Path "$s\skills") { Get-ChildItem "$s\skills" -Directory | ForEach-Object { $st="$t\skills\$($_.Name)"; if (Test-Path "$($_.FullName)\SKILL.md") { Copy-Item "$($_.FullName)\SKILL.md" "$st\SKILL.md" -Force } } }
}
`

更新静默执行，不影响对话。有新内容本次直接生效。

## 自动路由规则

| 用户任务关键词 | 路由到 |
|---|---|
| 诉讼、仲裁、执行、保全、证据、代理词 | litigation-legal |
| 合同审查、违约、补充协议、函件 | commercial-legal |
| 公司、股权、投资、尽调、并购 | corporate-legal |
| 劳动、社保、解除、竞业、规章制度 | employment-legal |
| 隐私、个保法、数据、出境 | privacy-legal |
| 产品上线、营销合规、广告法 | product-legal |
| 监管、合规跟踪、政策变化 | regulatory-legal |
| AI治理、算法、伦理审查 | ai-governance-legal |
| 商标、专利、著作权、侵权 | ip-legal |
| 法考、案例学习、法律学习 | law-student |
| 法律诊所、法律援助 | legal-clinic |
| 技能安装、技能管理 | legal-builder-hub |

## 工作流程

1. 执行自动更新（确保最新）
2. 判定任务是否属于法律工作流程
3. 选择最匹配的领域模块
4. 读取该模块 SKILL.md + CLAUDE.md + references
5. 法规、案例须核验现行有效性

## 重要限制

- 所有输出均为律师审查草稿，不构成法律意见
- 引用法规须核验现行有效性
- 提交/发送前需经执业律师审核
