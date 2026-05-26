# AGENTS.md — laubeing-droid 多平台开发准则

> 本文件适用于 [laubeing-droid](https://github.com/laubeing-droid) 旗下全部仓库。
> 当你（AI Agent）处理该仓库的任何文件时，必须遵守以下准则。

---

## 一、核心准则：四平台兼容

本仓库的**所有代码、配置、技能、安装脚本**必须兼容以下四种 AI 编程平台：

| # | 平台 | 厂商 | 配置格式 | 技能路径 | MCP 格式 |
|:--|:-----|:-----|:---------|:---------|:---------|
| 1 | **Codex Desktop** | OpenAI | TOML | `~/.codex/skills/` | TOML `[mcp_servers.X]` |
| 2 | **Claude Code** | Anthropic | JSON | `~/.claude/plugins/` | JSON `mcpServers` |
| 3 | **WorkBuddy** | Tencent | JSON | `~/.workbuddy/skills/` | JSON `mcpServers` + ZIP 包 |
| 4 | **Trae** | ByteDance | JSON | `~/.trae/skills/` | JSON `mcpServers` |

**规则：任何一个平台的接口缺失 = Bug，必须修复。**

---

## 二、平台接口要求

### 2.1 技能文件（SKILL.md）

每个 SKILL.md 必须包含以下 frontmatter，确保四平台可识别：

```yaml
---
name: skill-name              # 英文标识（跨平台通用）
description: ...              # 中文描述
platforms: [codex, claude-code, workbuddy, trae]  # 必填
version: x.y.z
---
```

- `platforms` 字段声明该技能支持哪些平台
- 每个平台若需特殊配置，在同目录下创建 `codex.yaml` / `claude-code.json` / `workbuddy.json` / `trae.json`

### 2.2 安装脚本（install.ps1 / install.sh）

**强制规则**：
1. 安装脚本必须检测所有四个平台（参考 `platforms.ps1`）
2. 对已安装的平台，自动部署对应的技能文件/MCP配置
3. 平台检测函数：`Get-AllPlatforms`（从 `platforms.ps1` 加载）
4. 平台特定配置统一使用 `Write-McpToPlatform` 函数

**安装脚本最小模板**：
```powershell
# 加载平台适配框架
. "$PSScriptRoot\..\platforms.ps1"  # 或从独立路径加载

$platforms = Get-AllPlatforms
$active = $platforms | Where-Object { $_.Installed }

foreach ($p in $active) {
    switch ($p.Id) {
        'codex'        { Deploy-ToCodex $p }
        'claude-code'  { Deploy-ToClaudeCode $p }
        'workbuddy'    { Deploy-ToWorkBuddy $p }
        'trae'         { Deploy-ToTrae $p }
    }
}
```

### 2.3 MCP 连接器配置

每个 MCP Server 必须生成四种格式的配置：

| 平台 | 函数 | 配置示例 |
|:-----|:-----|:---------|
| Codex Desktop | `New-CodexMcpConfig` | `[mcp_servers.SERVER]` + `command = "..."` |
| Claude Code | `New-ClaudeMcpConfig` | `{"mcpServers": {"SERVER": {"command": "..."}}}` |
| WorkBuddy | `New-WorkBuddyMcpConfig` | `{"mcpServers": {"SERVER": {"command": "...", "type": "stdio"}}}` |
| Trae | `New-TraeMcpConfig` | `{"mcpServers": {"SERVER": {"command": "..."}}}` |

### 2.4 WorkBuddy 特殊要求

- 每技能独立打包为 ZIP（格式：`{领域}-{技能名}.zip`）
- ZIP 内必须包含 `SKILL.md` + `references/` 目录
- 同时部署解压版和 ZIP 版到 `~/.workbuddy/skills/`

### 2.5 Trae 特殊要求

- Trae 基于 VS Code 架构，配置文件在 `~/.trae/` 目录
- macOS 上可能在 `~/Library/Application Support/Trae/`
- MCP 配置使用 JSON 格式（与 Claude Code 相同）
- 技能部署为 VS Code 扩展兼容格式

---

## 三、仓库特定准则

### 3.1 codex-claude-legal-cn-main（技能主仓库）

- **所有 150+ 子技能**的 SKILL.md 必须声明 `platforms` 字段
- `install.ps1` 必须部署到全部四个平台的技能目录
- 新增技能时同时生成四平台配置
- 护栏/阻断规则（29项）四平台通用，但需确认 WorkBuddy 和 Trae 的加载路径

### 3.2 codex-claude-legal-cn-mcp-hub（MCP 连接器）

- `detect.ps1` 必须检测全部四个平台
- 每个连接器的 `install-*` 函数必须输出四种 MCP 配置
- `verify.ps1` 必须验证四种平台配置的正确性
- Python MCP Server 代码不受影响（平台无关），仅配置生成需要四路输出

### 3.3 codex-claude-legal-cn-core-codices（法律数据库）

- 本仓库是数据层，平台无关
- 但 `install.ps1` 必须确保数据 JSON 能被所有四个平台访问
- 符号链接策略：在四个平台的技能目录下创建指向数据的符号链接

### 3.4 PRC-US-Legal-Semantic-Alignment-Framework（语义对齐）

- 框架文档是平台无关的纯文本
- 但 `install.ps1` 必须将框架注入到所有四个平台的 System Prompt / 知识库路径
- 对齐映射表的 JSON 版本需放在可被四平台共同访问的位置

### 3.5 codex-claude-legal-cn-judgment-predictor（裁判预测）

- `SKILL.md` 的 `platforms` 字段必填
- Prompt 文件（plaintiff/defendant/judge）平台无关
- `install.ps1` 部署到全部四个平台
- MCP 连接（类案检索）需确保四平台都可调用

---

## 四、开发流程

### 4.1 新增功能 Checklist

- [ ] 是否在全部四个平台测试了接口？
- [ ] SKILL.md 是否声明了 `platforms: [codex, claude-code, workbuddy, trae]`？
- [ ] install.ps1 是否对全部四个平台有部署逻辑？
- [ ] MCP 配置是否生成了全部四种格式？
- [ ] WorkBuddy ZIP 包是否正确生成？
- [ ] Trae 的配置路径是否正确（Windows/macOS 双平台）？

### 4.2 不允许的做法

- ❌ 只写 Codex Desktop 的 TOML 配置
- ❌ 硬编码 `~/.codex/skills/` 路径
- ❌ 假设用户只使用一个平台
- ❌ SKILL.md 缺少 `platforms` 字段
- ❌ MCP 配置只输出 JSON 或只输出 TOML

### 4.3 正确做法示例

```powershell
# ✅ 正确：同时为全部平台配置
function Install-McpServer {
    $platforms = Get-AllPlatforms | Where-Object { $_.Installed }
    foreach ($p in $platforms) {
        Write-McpToPlatform -Platform $p -ServerName "my-server" -Command "python" -Args @("server.py")
    }
}

# ❌ 错误：只配置 Codex
function Install-McpServer-WRONG {
    $codexConfig = "$env:USERPROFILE\.codex\config.toml"
    Add-Content $codexConfig "[mcp_servers.my-server]`ncommand = `"python`""
}
```

---

## 五、平台检测优先级

当四个平台同时安装时，按以下优先级处理冲突：

1. **Codex Desktop** — 主开发平台，优先测试
2. **Claude Code** — 格式与 Trae 相似，合并测试
3. **WorkBuddy** — ZIP 打包逻辑独立
4. **Trae** — 与 Claude Code JSON 格式兼容

## 六、测试要求

- 新功能提交前，必须至少在 **Codex Desktop** 上验证通过
- MCP 配置变更必须在 **Codex + Claude Code** 上验证
- WorkBuddy ZIP 生成可在无 WorkBuddy 环境下仅验证 ZIP 结构
- Trae 配置可在无 Trae 环境下仅验证 JSON 格式

---

> **最后更新**：2026-05-26
> **适用仓库**：laubeing-droid 全部
> **强制执行**：是（违反本准则的代码不得合并）

---

## 七、环境一致性校验（强制）

### 7.1 原则

**Python 3.9 在公司能跑、在家就炸** —— 这是典型的"环境不一致"问题。本仓库的 MCP Server 依赖 `mcp>=1.0.0`（需要 Python 3.10+），`pydantic>=2.0.0`（与 v1 不兼容），`httpx>=0.27.0`。依赖链中任何一个版本漂移都会导致：

| 场景 | 表象 | 根因 |
|:-----|:-----|:-----|
| Python 3.9 | `import mcp` → SyntaxError (match/case) | mcp 需要 3.10+ |
| pydantic v1 | `from pydantic import BaseModel` → AttributeError | v2 API 不兼容 v1 |
| httpx 0.26 | AsyncClient 方法签名变化 | 0.27 breaking changes |
| Node.js 缺失 | 飞书连接器静默失败 | npm MCP 无法启动 |

**规则：install.ps1 的第一步必须是调用 `env-check.ps1`。阻断项存在时禁止继续安装。**

### 7.2 安装脚本集成

```powershell
# 每个 install.ps1 必须在开头加入：
$envCheck = Join-Path $PSScriptRoot "env-check.ps1"
if (Test-Path $envCheck) {
    & $envCheck
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Environment check failed. Fix issues above and re-run." -ForegroundColor Red
        exit 1
    }
}
```

### 7.3 校验项目总表

| # | 检查项 | 最低要求 | 不满足后果 | 等级 |
|:--|:-----|:-----|:-----|:--|
| 1 | PowerShell | >=5.1 | 脚本语法错误 | 🔴 CRITICAL |
| 2 | Python | >=3.10 | mcp SDK 无法运行 | 🔴 CRITICAL |
| 3 | pip | 可用 | 无法安装 Python 包 | 🔴 CRITICAL |
| 4 | Git | 可用 | 无法克隆依赖仓库 | 🔴 CRITICAL |
| 5 | GitHub 可达 | 网络通 | 无法下载仓库 | 🔴 CRITICAL |
| 6 | PyPI 可达 | 网络通 | 无法安装 pip 包 | 🔴 CRITICAL |
| 7 | mcp 包 | >=1.0.0 | MCP Server 启动失败 | 🟡 WARNING |
| 8 | httpx 包 | >=0.27.0 | API 调用异常 | 🟡 WARNING |
| 9 | pydantic 包 | >=2.0.0 (非 v1) | server.py 崩溃 | 🔴 CRITICAL |
| 10 | Node.js | >=18.0 | 飞书连接器不可用 | 🟡 WARNING |
| 11 | 磁盘空间 | >=1 GB | 无法克隆仓库 | 🔴 CRITICAL |
| 12 | 平台检测 | 至少一个 | 没有部署目标 | 🟡 WARNING |

### 7.4 用户修复指引

校验失败时，输出精确的修复命令（而非笼统的"请升级 Python"）：

```
[X] [Python] Python 3.9 — mcp SDK requires >=3.10
     fix: winget install Python.Python.3.12

[X] [Pkg] pydantic v1 detected! v2 API incompatible
     fix: pip uninstall pydantic -y; pip install 'pydantic>=2.0.0'
```

---

## 八、提交规范（Conventional Commits）

### 8.1 格式

```
<type>(<scope>): <description>

[optional body]
```

### 8.2 Type 定义

| Type | 用途 | 示例 |
|:-----|:-----|:-----|
| `feat` | 新功能/新技能 | `feat(mcp-hub): add Trae MCP config support` |
| `fix` | Bug 修复 | `fix(env-check): pydantic v1 detection false negative` |
| `docs` | 文档变更 | `docs: update PLATFORM_SPEC.md with Trae path` |
| `chore` | 构建/工具/依赖 | `chore: bump mcp from 1.0.0 to 1.1.0` |
| `refactor` | 重构（无功能变更） | `refactor(detect): extract platform enum` |
| `test` | 测试 | `test: add pydantic v1/v2 compatibility test` |
| `perf` | 性能优化 | `perf(server): reduce httpx timeout` |
| `security` | 安全修复 | `security: sanitize API key in logs` |

### 8.3 Scope 定义

| Scope | 含义 |
|:-----|:-----|
| `mcp-hub` | MCP 连接器中心 |
| `cn-main` | 法律技能主仓库 |
| `jdp` | 裁判预测 |
| `aln` | 中美法律对齐 |
| `codices` | 法律数据库 |
| `env-check` | 环境校验 |
| `platforms` | 平台适配框架 |

---

## 九、版本管理（Semantic Versioning）

### 9.1 规则

```
MAJOR.MINOR.PATCH
  │     │     └─ 修复：Bug fix，不改变 API
  │     └─────── 新增：向后兼容的新功能
  └───────────── 破坏性：不兼容的 API 变更
```

### 9.2 触发条件

| 变更 | 版本 | 要求 |
|:-----|:--|:-----|
| 新增技能/连接器 | MINOR++ | CHANGELOG 条目 |
| 修复 Bug | PATCH++ | CHANGELOG 条目 |
| 删除/重命名 API | MAJOR++ | CHANGELOG + 迁移指南 |
| 平台支持变更 | MINOR++ | PLATFORM_SPEC.md 同步更新 |
| 新增依赖 | MINOR++ | requirements.txt + env-check 同步 |

### 9.3 版本同步

所有五个仓库的版本号**独立管理**，但在 ECOSYSTEM.md 中记录对照表。

---

## 十、安全准则（强制）

### 10.1 凭证管理

```
❌ 禁止：API Key / Token / 密码 硬编码在代码中
❌ 禁止：.env 文件提交到 Git
✅ 必须：使用环境变量或 .env.example 模板
✅ 必须：日志/错误信息中脱敏凭证
```

### 10.2 .gitignore 最小要求

```gitignore
.env
*.key
*.pem
*.token
credentials.json
**/__pycache__/
node_modules/
```

### 10.3 敏感信息检测

提交前检查：
- [ ] 无硬编码 API Key
- [ ] 无硬编码 Token/Cookie
- [ ] 无内网 IP/域名
- [ ] 无真实客户案件数据

---

## 十一、测试要求

### 11.1 最低要求

| 仓库 | 提交前必测 | 测试方式 |
|:-----|:-----|:-----|
| mcp-hub | MCP Server 启动 | `python servers/*/scripts/server.py --help` |
| mcp-hub | 配置生成 | `.\verify.ps1` |
| CN main | 技能加载 | Codex Desktop 中验证 |
| CN main | 护栏有效 | `.\benchmark\run-benchmark.ps1` |
| JDP | Prompt 有效 | 模拟输入测试 |
| codices | JSON 格式 | `python -m json.tool` 校验 |
| ALN | 阻断清单完整 | 29 项全部存在 |

### 11.2 不要求

- 不要求覆盖率指标（法律 AI 不适合传统单元测试）
- 不要求 CI 全绿（部分测试依赖外部 API）

---

## 十二、分支与 PR 规范

### 12.1 分支策略

```
main ─────●──────────●──────────●──→ 生产就绪
           \         /
feature/A ──●──●──●─┘
```

- **main**：受保护，直接推送仅限维护者
- **feature/***：功能分支，合并后删除
- **fix/***：Bug 修复分支

### 12.2 PR 最小 Checklist

```
[ ] 四平台兼容（Codex / Claude Code / WorkBuddy / Trae）
[ ] env-check.ps1 通过
[ ] 无硬编码凭证
[ ] CHANGELOG 已更新
[ ] 版本号已更新（如有需要）
[ ] 相关文档已同步
```

---

## 十三、文档要求

### 13.1 代码与文档同步

- 任何 API / 配置 / 接口变更，**必须同步更新**对应 `.md` 文档
- 新增技能必须更新 `ECOSYSTEM.md` 或 `FILE_INDEX.md`
- 新增 MCP 连接器必须更新 `detect.ps1`

### 13.2 法律引用标准

所有法条引用必须使用可核验格式：
```
✅ 《民法典》第 584 条
✅ 《刑法》第 232 条
❌ "根据相关法律规定"
❌ 未标注来源的司法解释
```

---

## 十四、依赖管理

### 14.1 版本锁定

| 语言 | 锁定文件 | 更新方式 |
|:-----|:-----|:-----|
| Python | `requirements.txt`（下限版本） | 手动审查后 bump |
| PowerShell | `#Requires -Version` 声明 | 同步 env-check 阈值 |
| Node.js | `package.json`（如有） | 手动审查后 bump |

### 14.2 依赖添加流程

1. 在分支中修改 `requirements.txt`
2. 同步更新 `env-check.ps1` 中的最低版本要求
3. 测试 MCP Server 启动
4. PR 中说明新增依赖的理由

---

> **规则优先级**：安全准则 > 环境校验 > 四平台兼容 > 版本管理 > 提交规范 > 其他