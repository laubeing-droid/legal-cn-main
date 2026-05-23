# 七个项目关系分析

## 一、总览

> **七个项目、三个层级、一个目标：让 AI 帮助中国律师工作。**
>
> 从 Anthropic 的美国法原版，到 zhou210712 的全面汉化，再到 SH88-source 的改名，
> 然后分化出四个面向不同平台的分支，最后汇聚到本仓库作为 Codex 的统一入口。

## 二、演进路线图

```
年代/顺序                   项目                             核心变化
─────────────────────────────────────────────────────────────────────
2024                      anthropics/claude-for-legal       美国法 Claude Code 插件（原始版）
                                    │
2025                      zhou210712/claude-for-legal-ZH    全面汉化：美国法 → 中国法（里程碑）
                                    │
                    ┌───────────────────┐
                    │                   │
2025-2026     SH88-source/            gjhcsjamin/
              claude-for-legal-CN      codex-for-legal-CN
              改名版（-zh → -cn）       Codex 封装层（自动路由）
                    │                   │
          ┌─────────┼─────────┐         │
          │         │         │         │
2026  drdavid-kor/  │  MAXXXXXLI/       │
      在线网页版    │  豆包版           │
                    │                   │
                    └─────────┬─────────┘
                              │
2026                  laubeing-droid/
                 ──── codex-legal-cn-skills（本仓库）
                      包装整合 + 自动更新 + 上游监测
```

## 三、逐项目深度分析

### 1. anthropics/claude-for-legal（最上游）

- 作者：Anthropic PBC
- 定位：**Claude Code 插件市场**中的法律工作流参考实现
- 内容：12 个美国法领域插件（商业合同、诉讼、隐私、公司、劳动、IP、产品合规、监管合规、AI治理、法学生、法律诊所、技能治理）+ 5 个托管 Agent 蓝图 + 16 个 MCP 连接器
- 法律基础：美国法（UCC、FRCP、GDPR/CCPA、Delaware公司法、FLSA、ABA 等）
- 平台：Claude Code（终端）/ Claude Cowork（桌面）
- 许可证：Apache 2.0
- 意义：**整个生态的源头**，定义了一整套法律 AI 工作流的模板和范式

### 2. zhou210712/claude-for-legal-ZH（原始汉化版）

- 作者：CSlawyer1985 / zhou210712
- 定位：**第一个将 Anthropic 官方项目全面汉化为中国法的版本**
- 核心工作：把 12 个插件领域的美国法内容全部替换为中国法：
  - 合同法：UCC → 民法典合同编
  - 诉讼法：FRCP → 民事诉讼法、民诉法司法解释
  - 劳动法：FLSA → 劳动合同法、劳动仲裁法
  - 隐私法：GDPR/CCPA → 个人信息保护法、数据安全法
  - 公司法：Delaware 公司法 → 中国公司法、证券法
  - 案例检索：Westlaw/CourtListener → 元典 MCP/北大法宝
  - 合同管理：Ironclad/DocuSign → e签宝/法大大/飞书知识库
  - 等等共 12 个领域
- 额外工作：新增中国法核心规则参考文件（民法典、诉讼法、劳动合同法等底层法条原文）
- 平台：Claude Code
- 意义：**汉化工程的里程碑**，后续所有中国法版本的基础

### 3. SH88-source/claude-for-legal-CN（改名版）

- 作者：SH88-source
- 定位：**从 zhou210712 仓库 fork 后改名**
- 核心变化：仅将插件命名从 `-zh` 改为 `-cn`，作者信息改为 SH
- 内容：与 zhou210712 版**完全一致**，无实质性内容改动
- 区别：
  - 去掉了 README 中的致谢部分和图片
  - 没有 docs/ 官网静态页面
- 命名空间：`claude-for-legal-cn`
- 意义：**提供了一个更简洁的命名版本**，也是我们当前直接上游

### 4. drdavid-kor/claude-for-legal-cn-online（在线网页版）

- 作者：drdavid-kor
- 定位：**BYOK（Bring Your Own Key）在线 Web 应用**
- 技术栈：Cloudflare Workers + Static Assets + TypeScript
- 来源：以 SH88-source 仓库为 git submodule
- 使用方式：**无需安装任何 CLI 工具**，打开浏览器即可使用
- 隐私模型：API Key 仅存浏览器内存/会话存储，服务器不持久化
- 两种模式：
  - **Demo 模式**：8 个预设场景快速体验
  - **Expert 模式**：9 个专业领域技能（隐藏了 builder/admin/student/诊所等面向非实务律师的模块）
- 支持：OpenRouter、SiliconFlow、DeepSeek 等 OpenAI 兼容 API
- 意义：**降低了使用门槛**，让不熟悉终端的律师也能用

### 5. MAXXXXXLI/workbuddy-cn-legal-skills（豆包版）

- 作者：MAXXXXXLI
- 定位：**Workbuddy（字节跳动豆包工作台）技能包**
- 来源：从 Anthropic 官方原版适配到 Workbuddy 平台
- 内容：151 个中文命名的 .zip 技能包
- 覆盖领域：商事合同、数据合规、AI治理、产品合规、公司治理、劳动用工、知识产权、争议解决、监管合规、法律援助、中国法学习、技能治理
- 重要特征：
  - 基于 **Anthropic 美国法原版** 而非 zhou210712 汉化版
  - 内容是"美国法模板 + 中文翻译壳"——在 CLAUDE.md 开头注明"遇到冲突以中国法为准"
  - 非真正的中国法适配（法条引用、司法解释、裁判规则等仍为美国法）
- 平台：Workbuddy（豆包）
- 意义：**面向不同平台的分支**，让用户多一个选择

### 6. gjhcsjamin/codex-for-legal-CN（Codex 封装版）

- 作者：gjhcsjamin
- 定位：**面向 Codex（OpenAI CLI）的自动路由封装层**
- 来源：以 zhou210712/claude-for-legal-ZH 为上游
- 核心功能：
  - **自动路由**：根据用户输入的关键词自动分发到对应法律领域
  - **安装脚本**：install.py 一键部署到 Codex
  - **兼容入口**：codex-for-legal-cn（主入口）+ claude-for-legal-zh（兼容入口）
- 安装方式：`python scripts/install.py`
- 入口：codex-for-legal-cn
- 领域：12 个（同上游）
- 意义：**首次将中国法律技能带到 Codex 平台**，验证了自动路由的可行性

### 7. laubeing-droid/codex-legal-cn-skills（本仓库）

- 作者：你（laubeing-droid）
- 定位：**整合包装层 —— 统一入口 + 自动更新 + 本地优化**
- 来源：以 SH88-source/claude-for-legal-CN 为上游
- 核心资产：

  | 资产 | 来源 | 说明 |
  |------|------|------|
  | 12 个领域 SKILL.md | 自创 | 精简入口定义，指向上游具体内容 |
  | 根技能 codex-for-legal-cn | 自创 | 自动路由 + 自动更新指令 |
  | install.ps1 | 自创 | 自动拉取上游 + 安装到 Codex + 设置目录联接 |
  | update.ps1 | 自创 | 手动同步最新内容 |
  | 自动更新机制 | 自创 | 每次使用法律功能时自动 git pull + 同步 |
  | GitHub Actions 上游监测 | 自创 | 每周检查 4 个上游仓库更新，自动开 Issue |
  | 全套中文文档 | 自创 | README、QUICKSTART、usage-guide、architecture、connectors、troubleshooting、contributing、project-analysis |

- 安装方式：`.\install.ps1` 一键完成
- 平台：Codex（OpenAI Desktop）
- 意义：**把 gjhcsjamin 的包装层思路 + 你本地已做的配置优化 + 自动更新合并为一个可分发的独立包**

## 四、七项目对比表

| 对比维度 | anthropics | zhou210712 | SH88-source | drdavid-kor | MAXXXXXLI | gjhcsjamin | **本仓库** |
|---------|-----------|------------|-------------|-------------|-----------|------------|-----------|
| **平台** | Claude Code | Claude Code | Claude Code | 浏览器 | Workbuddy | Codex | **Codex** |
| **法律基础** | 美国法 | 中国法 | 中国法 | 中国法 | 美国法+中文壳 | 中国法 | **中国法** |
| **安装方式** | /plugin install | /plugin install | /plugin install | 打开网页 | 上传 zip | install.py | **install.ps1** |
| **需 API Key** | 需 Claude | 需 Claude | 需 Claude | 自备(BYOK) | 不须 | 须 Codex | **须 Codex** |
| **自动更新** | git pull | git pull | git pull | 重新部署 | 重新下载 | git pull | **git pull + 集成** |
| **语言** | 英文 | 中文 | 中文 | 中文 | 中文 | 中/英 | **中文** |
| **内容量** | 12插件+5Agent | 12插件 | 12插件 | 9领域技能 | 151 skill | 12领域 | **12领域+根技能** |
| **CLI需求** | 要 | 要 | 要 | 不要 | 不要 | 要 | **要** |
| **安装步骤** | 6步 | 6步 | 6步 | 1步 | 2步 | 1步 | **1步** |
| **上游依赖** | - | anthropics | zhou210712 | SH88-source | anthropics | zhou210712 | **SH88-source** |
| **原创性** | 原始 | 汉化改造 | rebrand | 架构创新 | 平台适配 | 包装创新 | **整合优化** |

## 五、本仓库的核心价值

### 为什么需要本仓库？

**七个项目，没有一个能独立满足你的需求：**

| 如果你的需求是 | 现有方案 | 本仓库 |
|--------------|---------|--------|
| 在 Codex 上用中国法 | gjhcsjamin 包装层太薄，无自动更新 | **完整包装 + 自动更新** |
| 一键安装 | 每个项目要各自的手动步骤 | **install.ps1 一步到位** |
| 自动更新 | 各项目独立手动 git pull | **集成在根技能中自动执行** |
| 文档完善 | 只有 Anthropic 文档最全 | **全中文文档 + 上游分析** |
| 可分发 | 需要多个仓库配合 | **单一仓库，clone 即用** |
| 监控上游变化 | 无 | **GitHub Actions 自动监测** |

### 本仓库做了什么事

1. **选型**：从 5 个中国法相关项目中，选择 SH88-source/claude-for-legal-CN 作为最干净的上游
2. **安装**：写 install.ps1，自动处理克隆、目录联接、技能部署
3. **包装**：为 12 个领域写 SKILL.md 入口，创建根技能 codex-for-legal-cn
4. **路由**：在根技能中实现关键词自动路由
5. **更新**：自动更新机制集成到技能调用流程中
6. **监测**：GitHub Actions 每周检查整条上游链
7. **文档**：完整的项目分析、使用指南、架构说明、FAQ
8. **分发**：打包为一个可发布的 GitHub 仓库

### 本仓库不做的事

- ❌ 不修改上游法律内容（CLAUDE.md 和 references 来自 SH88-source）
- ❌ 不重新汉化美国法（汉化工作由 zhou210712 完成）
- ❌ 不提供在线网页版（drdavid-kor 做这个）
- ❌ 不转码 Workbuddy 格式（MAXXXXXLI 做这个）

## 六、项目角色总结

```
项目                             角色       面向平台      能否独立使用
────────────────────────────────────────────────────────────────
anthropics/claude-for-legal      源头        Claude Code   能
zhou210712/claude-for-legal-ZH   汉化者      Claude Code   能
SH88-source/claude-for-legal-CN  改名者      Claude Code   能
drdavid-kor/...-online           在线化者     浏览器        能
MAXXXXXLI/...-workbuddy          平台适配者   Workbuddy     能
gjhcsjamin/codex-for-legal-CN    包装者      Codex         能
laubeing-droid/...-skills        整合者      Codex         能（推荐）
```

**结论：本仓库不是重复造轮子，而是把六个轮子整合成一辆可以开走的车。**
