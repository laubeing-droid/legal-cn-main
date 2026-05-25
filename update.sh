#!/usr/bin/env bash
# update.sh — 更新 Claude for Legal CN to Codex (macOS / Linux)
# 用法: bash update.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.codex/skills"
MCP_REPO="https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub.git"
GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${GREEN}=== 更新 Codex 中国法律技能 ===${NC}\n"

DOMAINS=(
    commercial-legal privacy-legal product-legal corporate-legal
    employment-legal regulatory-legal ai-governance-legal litigation-legal
    law-student legal-clinic legal-builder-hub ip-legal solo-law-firm
)

# [1/3] 同步技能
echo -e "${YELLOW}[1/3] 同步技能...${NC}"
COUNT=0
for name in "${DOMAINS[@]}"; do
    src="$REPO_ROOT/skills/$name"
    tgt="$SKILLS_DIR/$name"
    [ -d "$src" ] || continue
    mkdir -p "$tgt"

    [ -f "$src/SKILL.md" ]  && cp "$src/SKILL.md"  "$tgt/SKILL.md"
    [ -f "$src/CLAUDE.md" ] && cp "$src/CLAUDE.md" "$tgt/CLAUDE.md"
    [ -f "$src/README.md" ] && cp "$src/README.md" "$tgt/README.md"

    if [ -d "$src/references" ]; then
        mkdir -p "$tgt/references"
        find "$src/references" -maxdepth 1 -type f -exec cp {} "$tgt/references/" \;
    fi

    if [ -d "$src/skills" ]; then
        for sub in "$src/skills"/*/; do
            [ -d "$sub" ] || continue
            sub_name="$(basename "$sub")"
            mkdir -p "$tgt/skills/$sub_name"
            [ -f "$sub/SKILL.md" ] && cp "$sub/SKILL.md" "$tgt/skills/$sub_name/SKILL.md"
        done
    fi

    if [ -d "$src/agents" ]; then
        mkdir -p "$tgt/agents"
        find "$src/agents" -maxdepth 1 -type f -exec cp {} "$tgt/agents/" \;
    fi

    ((COUNT++))
done

# 根技能
mkdir -p "$SKILLS_DIR/claude-legal-cn"
cp "$REPO_ROOT/skills/claude-legal-cn/SKILL.md" "$SKILLS_DIR/claude-legal-cn/SKILL.md"
echo "  已同步 $COUNT 个技能领域 + 根技能"

# solo-law-firm
SOLO_SRC="$REPO_ROOT/skills/solo-law-firm"
if [ -d "$SOLO_SRC" ]; then
    for dept in "$SOLO_SRC"/*/; do
        [ -d "$dept" ] || continue
        dept_name="$(basename "$dept")"
        for skill_dir in "$dept"*/; do
            [ -d "$skill_dir" ] || continue
            skill_name="$(basename "$skill_dir")"
            tgt_dir="$SKILLS_DIR/solo-law-firm/$dept_name/$skill_name"
            mkdir -p "$tgt_dir"
            [ -f "$skill_dir/SKILL.md" ] && cp "$skill_dir/SKILL.md" "$tgt_dir/SKILL.md"
        done
    done
    echo "  solo-law-firm 技能同步完成"
fi

# [2/3] MCP 检查
echo -e "${YELLOW}[2/3] MCP 连接器检查...${NC}"
MCP_DIR="$REPO_ROOT/mcp-connectors"
if [ ! -f "$MCP_DIR/verify.sh" ] && [ ! -f "$MCP_DIR/verify.ps1" ]; then
    echo "  正在克隆 MCP 连接器仓库..."
    git clone --depth 1 "$MCP_REPO" "$MCP_DIR" 2>/dev/null || echo "  [警告] git clone 失败"
fi
if [ -f "$MCP_DIR/verify.sh" ]; then
    echo "  运行 MCP 连接器验证..."
    bash "$MCP_DIR/verify.sh"
elif [ -f "$MCP_DIR/verify.ps1" ]; then
    echo "  [提示] MCP 验证需要 PowerShell (pwsh verify.ps1)，跳过"
else
    echo "  [警告] 无法获取 MCP 验证脚本"
fi

# [3/3] 验证
echo -e "${YELLOW}[3/3] 验证安装完整性...${NC}"
MISSING=()
ALL_DOMAINS=("${DOMAINS[@]}" "claude-legal-cn" "solo-law-firm")
for name in "${ALL_DOMAINS[@]}"; do
    [ -f "$SKILLS_DIR/$name/SKILL.md" ] || MISSING+=("$name")
done
if [ ${#MISSING[@]} -eq 0 ]; then
    echo -e "  ${GREEN}[OK] ${#ALL_DOMAINS[@]} 个技能全部存在${NC}"
else
    echo -e "  ${RED}[!!] 缺失 ${#MISSING[@]} 个: ${MISSING[*]}${NC}"
fi

echo -e "\n${GREEN}更新完成。重启 Codex Desktop 使新内容生效。${NC}"
echo -e "${CYAN}MCP 连接器由 Codex-Claude-legal-cn-mcp-hub 独立管理。${NC}"
