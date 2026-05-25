<!--
version: 2.10.0
module: references
status: active
-->

# 技能调用速查卡

> 在 Codex Desktop 中输入触发词即可快速唤起对应技能。
> 格式：`/领域:子技能` 或直接输入触发关键词。

---

## 一、12 领域快捷入口

| 触发词 | 领域 | 入口技能 |
|:-------|:-----|:---------|
| `AI治理` `AI合规` `算法审查` | ai-governance-legal | AI 影响评估 / 算法伦理 |
| `审合同` `合同审查` `商铺租赁` | commercial-legal | 合同审查与修改 |
| `尽调` `公司交易` `并购` | corporate-legal | 尽职调查 / 交易文件 |
| `劳动` `用工` `离职` `裁员` | employment-legal | 劳动纠纷 / 用工合规 |
| `知产` `商标` `专利` `著作权` | ip-legal | 知识产权保护 |
| `学法` `法考` `案例研习` | law-student | 法学教育辅助 |
| `做技能` `创建技能` | legal-builder-hub | 技能构建器 |
| `法律援助` `公益` | legal-clinic | 法律援助 |
| `打官司` `诉讼` `仲裁` `起诉` | litigation-legal | 诉讼仲裁全流程 |
| `数据合规` `隐私` `个保法` | privacy-legal | 数据合规 / 隐私评估 |
| `产品合规` `上线审查` | product-legal | 产品合规审查 |
| `监管` `合规` `行政处罚` | regulatory-legal | 监管合规应对 |

---

## 二、高频子技能直通车

| 触发词 | 直达技能 | 领域 |
|:-------|:---------|:-----|
| `写律师函` | cease-desist（律师函生成） | litigation-legal |
| `写起诉状` | draft-complaint（起诉状起草） | litigation-legal |
| `写答辩状` | draft-answer（答辩状起草） | litigation-legal |
| `证据清单` `质证` | evidence-review（证据审查） | litigation-legal |
| `算赔偿` `损害赔偿` | calculate-damages（赔偿计算） | litigation-legal |
| `类案检索` | case-research（类案检索） | litigation-legal |
| `合同审查` | contract-review（合同审查） | commercial-legal |
| `尽调报告` | due-diligence（尽职调查） | corporate-legal |
| `PIA` `隐私评估` | pia（隐私影响评估） | privacy-legal |
| `GDPR` `数据出境` | gdpr-gap（GDPR 差距分析） | privacy-legal |
| `商标检索` | trademark-search（商标检索） | ip-legal |
| `竞业限制` | non-compete（竞业限制审查） | employment-legal |
| `AI备案` `算法备案` | algo-filing（算法备案） | ai-governance-legal |

---

## 三、solo-law-firm 快捷入口

| 触发词 | 科室 | 直达技能 |
|:-------|:-----|:---------|
| `谈案` `接案` | 01-case-practice | 案件访谈 |
| `庭前准备` `开庭` | 01-case-practice | 庭前准备 / 庭审模拟 |
| `客户沟通` | 03-client-relations | 客户沟通话术 |
| `案源拓展` | 05-business-development | 案源拓展策略 |

---

## 四、触发规则

1. **精确匹配**：输入技能名直接调用（如 `合同审查`）
2. **模糊匹配**：输入关键词返回候选列表（如 `合同` → 列出所有合同相关技能）
3. **领域切换**：`切换到 诉讼` → 进入 litigation-legal 语境
4. **组合调用**：`审合同 + 算赔偿` → 依次调用两个技能
