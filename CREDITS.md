# CREDITS — 致谢与来源说明

本仓库整合了多个开源项目的成果。以下逐一注明来源、许可协议和具体贡献范围。

---

## 核心内容来源

### anthropics/claude-for-legal

| 项目 | 说明 |
|:-----|:-----|
| **仓库** | https://github.com/anthropics/claude-for-legal |
| **作者** | Anthropic PBC |
| **许可** | Apache License 2.0 |
| **贡献** | 12 个法律领域 × 150+ 子技能的原始框架设计、工作流逻辑、技能结构 |
| **本仓库使用方式** | 所有子技能的结构和流程框架继承自该仓库（经 zhou210712 汉化后整合） |

### zhou210712/claude-for-legal-ZH

| 项目 | 说明 |
|:-----|:-----|
| **仓库** | https://github.com/zhou210712/claude-for-legal-ZH |
| **作者** | 陈石 律师 |
| **许可** | Apache License 2.0 |
| **贡献** | 12 个法律领域的主文件（CLAUDE.md 中文化、MCP 连接器替换为中国工具、中国法引用文件 9 个） |
| **本仓库使用方式** | 本仓库 12 个法律领域的内容主体来源于此。包括 workflows/、connectors/、子技能主体 |
| **状态** | 已断开自动同步，改为参考窗口模式 |
| **跟踪** | `patches/diff-tool-zhou.ps1` 逐文件比对变更 |

### MAXXXXXLI/workbuddy-cn-legal-skills

| 项目 | 说明 |
|:-----|:-----|
| **仓库** | https://github.com/MAXXXXXLI/workbuddy-cn-legal-skills |
| **许可** | 开源（具体许可见上游仓库） |
| **贡献** | 14 个中国法律语境文件（china-context-*.md），为每个领域提供中国法背景提示 |
| **本仓库使用方式** | 语境文件整合进 `patches/references/context/`，随 install.ps1 部署到各领域 |
| **状态** | 已断开自动同步，改为参考窗口模式 |
| **跟踪** | `patches/diff-tool-max.ps1` 逐文件比对变更 |

### saysoph/solo-law-firm-agents

| 项目 | 说明 |
|:-----|:-----|
| **仓库** | https://github.com/saysoph/solo-law-firm-agents |
| **许可** | MIT |
| **贡献** | 26 个独立执业技能（8 科室），覆盖案件实务、案件管理、客户关系、尽职调查、市场拓展、财务行政、知识管理、合规风控 |
| **本仓库使用方式** | 技能经格式适配、技能名中英映射、合并优化后纳入 `skills/solo-law-firm/` |
| **本仓库补充** | 新增庭审提纲生成器（trial-outline-generator），补齐从证据分析到庭前核查之间的环节 |
| **状态** | 已断开自动同步，改为参考窗口模式 |
| **跟踪** | `patches/diff-tool-solo.ps1` 逐文件比对变更 |

---

## 自研内容（本仓库独有，不涉及上游）

以下内容完全由本仓库自行研发，不依赖于任何上游：

- **PRC-US 法律语义对齐框架** — 12 个领域 × 中美法律概念一对一映射
- **qulv 知识库** — 22 部中国法律官方 PDF 全文入库
- **护栏系统** — 阻断清单（blocking-list）、元规则（meta-rules）、香港普通法桥梁（hk-bridge）、核心原则（core-principles-guard）
- **4 路 diff-tool 参考窗口架构** — zhou210712/MAXXXXXLI/saysoph/自研框架 各一路独立比对
- **中国化子技能** — 调查取证准备、证据保全与留存、司法协查响应、律师函生成（4 个全量重写，1 个删除）
- **MCP 连接器独立仓库** — 与技能内容解耦，独立管理凭证和更新
- **安装/更新脚本** — install.ps1 / update.ps1 / uninstall.ps1 / verify.ps1

---

## 许可

本仓库整体采用 Apache License 2.0（继承自上游 anthropics/claude-for-legal）。
各上游内容遵循其原始许可协议。

---

> 如本致谢遗漏了任何贡献者，请提交 Issue 告知。
