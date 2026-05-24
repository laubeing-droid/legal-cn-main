# 使用指南

## 一、安装

### 前置条件
- Codex Desktop 已安装
- 操作系统：Windows 10/11
- Git

### 安装步骤

```powershell
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```

安装脚本交互式完成 8 步：
1. 检测 MCP 客户端环境（Codex/Claude Code/Claude Desktop）
2. 检查前置依赖（Node.js、Python）
3. **元典智库** — 3 选 1：HTTP MCP（官方推荐）/ npm stdio（备选）/ 跳过
4. **国家法律法规数据库**（Python 自建，免费无需认证）
5. **人民法院案例库**（Python 自建，需 Cookie Token）
6. **飞书 LarkSuite**（企业协作 MCP）
7. **北大法宝**（10 个 HTTP 服务）
8. 完成

安装后自动部署 40 个 SKILL.md（13 入口技能 + 27 个 solo-law-firm 子技能）。

### 验证安装

```powershell
.\verify.ps1
```

应显示全部 13 个入口技能为 [OK]，solo-law-firm 27 个子技能。

---

## 二、配置 MCP 法律检索

本仓库通过 [Codex-Claude-legal-cn-mcp-hub](https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub) 管理所有 MCP 连接器。
`install.ps1` 和 `update.ps1` 自动调用该仓库的安装脚本。

### 2.1 元典智库（推荐）

官方 HTTP Streamable MCP（3 个细分 Server）：

| Server | 分类 | 工具数 | 端点 |
|--------|------|--------|------|
| yuandian-law | 法律法规 | 5 | `/mcp/law/stream` |
| yuandian-case | 案例文书 | 4 | `/mcp/case/stream` |
| yuandian-company | 企业信息 | 26 | `/mcp/company/stream` |

凭证：`Authorization: Bearer YOUR_API_KEY`，注册 https://open.chineselaw.com

方案：`npx @pkulaw/mcp-cli`（社区包，单 Server 全 33 工具，`CHINESELAW_API_KEY`）

REST API 直调：`https://open.chineselaw.com/open/{routeKey}`，`X-API-Key` 头（36 个端点）

### 2.2 飞书 LarkSuite

`npx -y @larksuiteoapi/lark-mcp`（飞书官方包 v0.5.1）
需在 https://open.feishu.cn/app 创建企业自建应用，获取 App ID + App Secret。

### 2.3 北大法宝

10 个 HTTP MCP 服务（语义检索、关键词检索、法条识别、幻觉修正等）。
注册 https://mcp.pkulaw.com → 获取 Access Token。

CLI 调试：`npm install -g @pkulaw/mcp-cli`

### 2.4 自建 Python MCP（免费备选）

仓库内置两个自建 MCP，代码在 `repo-mcp/servers/`：

| 服务 | 端口 | 工具 | 凭证 |
|------|------|------|------|
| 国家法律法规数据库 | localhost:18062 | 11 个 | 无需认证 |
| 人民法院案例库 | localhost:18061 | 7 个 | Cookie Token（4h 过期）|

```bash
pip install -r servers/flk-npc/requirements.txt
python servers/flk-npc/scripts/server.py
```

### 2.5 凭证速查

| 服务 | 配置项 | 获取地址 |
|------|--------|---------|
| 元典 HTTP MCP | Bearer API Key | https://open.chineselaw.com |
| 元典 REST API | X-API-Key | https://open.chineselaw.com |
| 飞书 | LARK_APP_ID + LARK_APP_SECRET | https://open.feishu.cn/app |
| 北大法宝 | Bearer Access Token | https://mcp.pkulaw.com |

---

## 三、使用方式

### 自动路由（推荐）

| 你说 | 路由到 |
|------|--------|
| 帮我审查这份 SaaS 服务协议 | commercial-legal |
| 分析这个案件的管辖权问题 | litigation-legal |
| 评估个人信息保护合规风险 | privacy-legal |
| 搜索民法典关于合同无效的规定 | claude-legal-cn → 调用 MCP 检索 |
| 查一下华为的涉诉信息 | 路由 + 自动调用 MCP 检索 |
| 帮我生成开庭提纲 | solo-law-firm 庭审提纲生成器 |

### 手动指定

```
@litigation-legal 分析一下证据问题
@corporate-legal 审查这份股权转让协议
```

---

## 四、自动更新

每次使用法律技能时自动同步上游。手动更新：

```powershell
.\update.ps1
```

上游监测通过 GitHub Actions 自动进行（主仓库监测 zhou210712/MAXXXXXLI/saysoph，MCP 仓库监测 moyupeng0422）。

---

## 五、卸载

```powershell
.\uninstall.ps1
```

如需清理 config.toml 中的 MCP 条目，手动删除对应 `[mcp_servers.*]` 段。

---

## 六、输出说明

- 所有输出均为**律师审查草稿**，不构成法律意见
- 已连 MCP：引用标注具体来源
- 未连 MCP or 引用无法验证：标注 [需验证]
- 默认适用中国大陆法律
