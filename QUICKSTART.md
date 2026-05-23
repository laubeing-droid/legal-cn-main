# 快速入门

60 秒完成安装并开始使用法律技能。

## 安装

`powershell
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills
.\install.ps1
`

## 验证

`powershell
.\verify.ps1
`

## 配置 MCP（可选但推荐）

安装脚本已在 ~/.codex/config.toml 写入配置，你只需替换凭证：

**chineselaw（推荐）**：基于 [chineselaw-mcp](https://www.npmjs.com/package/chineselaw-mcp)。
注册 https://open.chineselaw.com → 获取 API Key → 编辑 config.toml → 替换 CHINESELAW_API_KEY。

**北大法宝 MCP 协议**：注册 https://mcp.pkulaw.com → 获取 Access Token → 编辑 config.toml → 替换所有 YOUR_ACCESS_TOKEN。

**北大法宝 CLI 命令行**（可选调试工具）：基于 [@pkulaw/mcp-cli](https://www.npmjs.com/package/@pkulaw/mcp-cli)。
`ash
npm install -g @pkulaw/mcp-cli
pkulaw-mcp init --authorization "Bearer YOUR_ACCESS_TOKEN"
pkulaw-mcp update
`

## 开始使用

重启 Codex Desktop，直接输入：

`
帮我审查这份 SaaS 服务协议
分析一下这个案件的管辖权
评估个人信息保护合规风险
`

系统自动识别并调用对应技能。

## 常见问题

- **技能没生效？** 重启 Codex Desktop
- **引用标注[需验证]？** 配置 MCP 连接器（见 docs/connectors.md）
- **如何更新？** 运行 .\update.ps1
- **如何卸载？** 运行 .\uninstall.ps1

详细说明见 docs/usage-guide.md。