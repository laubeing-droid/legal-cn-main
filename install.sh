#!/usr/bin/env bash
# install.sh — 一键安装 Claude for Legal CN to Codex (macOS / Linux)
# 用法: bash install.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.codex/skills"
MCP_REPO="https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub.git"
GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${GREEN}=== Claude for Legal CN to Codex 安装 ===${NC}\n"

DOMAINS=(
    commercial-legal privacy-legal product-legal corporate-legal
    employment-legal regulatory-legal ai-governance-legal litigation-legal
    law-student legal-clinic legal-builder-hub ip-legal solo-law-firm
)

# [1/3] 安装技能
echo -e "${YELLOW}[1/3] 安装技能...${NC}"
for name in "${DOMAINS[@]}"; do
    src="$REPO_ROOT/skills/$name"
    tgt="$SKILLS_DIR/$name"
    [ -d "$src" ] || { echo "  [跳过] $name — 源目录不存在"; continue; }
    mkdir -p "$tgt"

    [ -f "$src/SKILL.md" ]  && cp "$src/SKILL.md"  "$tgt/SKILL.md"
    [ -f "$src/CLAUDE.md" ] && cp "$src/CLAUDE.md" "$tgt/CLAUDE.md"
    [ -f "$src/README.md" ] && cp "$src/README.md" "$tgt/README.md"

    # references/
    if [ -d "$src/references" ]; then
        mkdir -p "$tgt/references"
        find "$src/references" -maxdepth 1 -type f -exec cp {} "$tgt/references/" \;
    fi

    # skills/（子技能）
    if [ -d "$src/skills" ]; then
        for sub in "$src/skills"/*/; do
            [ -d "$sub" ] || continue
            sub_name="$(basename "$sub")"
            mkdir -p "$tgt/skills/$sub_name"
            [ -f "$sub/SKILL.md" ] && cp "$sub/SKILL.md" "$tgt/skills/$sub_name/SKILL.md"
        done
    fi

    # agents/
    if [ -d "$src/agents" ]; then
        mkdir -p "$tgt/agents"
        find "$src/agents" -maxdepth 1 -type f -exec cp {} "$tgt/agents/" \;
    fi
done

# 根技能
mkdir -p "$SKILLS_DIR/claude-legal-cn"
cp "$REPO_ROOT/skills/claude-legal-cn/SKILL.md" "$SKILLS_DIR/claude-legal-cn/SKILL.md"

# solo-law-firm（嵌套科室结构）
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
    echo "  solo-law-firm 技能安装完成"
fi
echo "  技能安装完成"

# [2/3] MCP 连接器
echo -e "${YELLOW}[2/3] 配置 MCP 连接器...${NC}"
MCP_DIR="$REPO_ROOT/mcp-connectors"
if [ ! -f "$MCP_DIR/install.sh" ]; then
    echo "  正在克隆 MCP 连接器仓库..."
    git clone --depth 1 "$MCP_REPO" "$MCP_DIR" 2>/dev/null || echo "  [警告] git clone 失败"
fi
if [ -f "$MCP_DIR/install.sh" ]; then
    echo "  运行 MCP 连接器安装..."
    bash "$MCP_DIR/install.sh"
else
    echo "  [警告] 无法获取 MCP 连接器，跳过。手动安装: git clone $MCP_REPO"
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
    exit 1
fi

echo -e "\n${GREEN}安装完成！重启 Codex Desktop 使技能生效。${NC}"
echo -e "${CYAN}MCP 连接器由 Codex-Claude-legal-cn-mcp-hub 管理。${NC}"
echo -e "${CYAN}  配置指南: docs/connectors.md${NC}"
