# 架构文档

> 最后更新：2026-05-25

---

## 架构原则

1. **本地即真相**：所有技能内容以本仓库 `skills/` 为准，install/update 直接部署。
2. **上游是参考窗口**：4 个上游仓库通过 GitHub Actions + diff-tool 监控，不自动同步。
3. **委托非重复**：MCP 连接器交给独立仓库管理。
4. **来源可追溯**：patches/ 保持上游快照，diff-tool 哈希比对，`-Diff` 行级差异。

---

## 分层结构

```
┌──────────────────────────────────────────────┐
│              上游监控层                        │
│  .github/workflows/upstream-monitor.yml       │
│  + 4 个 diff-tool 脚本                         │
│  → 每周一检查，有更新提 Issue                  │
└──────────────┬───────────────────────────────┘
               │ 不自动写入
┌──────────────▼───────────────────────────────┐
│              内容层（本仓库 skills/）          │
│                                               │
│  12 个法律领域（skills/*/）                    │
│  ├── SKILL.md       ← 本仓库维护的入口         │
│  ├── CLAUDE.md      ← 本仓库维护的工作流       │
│  ├── references/    ← 中国法引用 + 对齐文件    │
│  ├── skills/*/SKILL.md ← 子技能               │
│  └── agents/        ← 代理                    │
│                                               │
│  solo-law-firm（skills/solo-law-firm/）       │
│  └── 01-08 科室/技能/SKILL.md（27 个）         │
│                                               │
│  knowledge-base（skills/knowledge-base/）     │
│  └── 22 部中国法律官方 PDF                     │
│                                               │
│  references（skills/references/）             │
│  └── 护栏文件                                 │
└──────────────┬───────────────────────────────┘
               │ install/update → ~/.codex/skills/
┌──────────────▼───────────────────────────────┐
│              快照层（patches/）                │
│  workflows/  ← CLAUDE.md 快照                 │
│  connectors/ ← .mcp.json 快照                 │
│  sub-skills/ ← 子技能快照（150+）              │
│  references/ → 语境 + 对齐 + 护栏             │
│  guards/     → 护栏文件                        │
│  metadata/   → marketplace/NOTICE             │
└──────────────────────────────────────────────┘
```

## 部署流程

```
install.ps1 / update.ps1
  ├── 遍历 skills/ 每个领域
  │   ├── 复制 SKILL.md / CLAUDE.md / README.md
  │   ├── 复制 references/* / skills/*/ / agents/*
  ├── 单独处理 solo-law-firm（嵌套 8 科室结构）
  ├── 克隆 MCP 连接器仓库
  └── 验证完整性
```

## 上游检测流程

```
diff-tool-zhou.ps1
  ├── 拉取 zhou210712 到 TEMP
  ├── 哈希比对 patches/ 快照 vs 上游
  ├── 颜色标记：绿✓ 黄Δ 紫+ 红？
  └── -Diff 参数：行级 git diff
```
