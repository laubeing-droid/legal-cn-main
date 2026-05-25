#!/usr/bin/env bash
# uninstall.sh — 卸载 Claude for Legal CN to Codex (macOS / Linux)
# 用法: bash uninstall.sh
set -euo pipefail

SKILLS_DIR="$HOME/.codex/skills"
GREEN='\033[0;32m'; YELLOW='\033[0;33m'; NC='\033[0m'

echo -e "${YELLOW}=== 卸载 Claude for Legal CN to Codex ===${NC}\n"

DOMAINS=(
    claude-legal-cn
    commercial-legal privacy-legal product-legal corporate-legal
    employment-legal regulatory-legal ai-governance-legal litigation-legal
    law-student legal-clinic legal-builder-hub ip-legal solo-law-firm
)

echo "[1/1] 删除技能目录..."
REMOVED=0
for name in "${DOMAINS[@]}"; do
    dir="$SKILLS_DIR/$name"
    if [ -d "$dir" ]; then
        rm -rf "$dir"
        echo "  - 已删除: $name"
        ((REMOVED++))
    fi
done
echo "  共删除 $REMOVED 个技能目录"

echo -e "\n${GREEN}卸载完成。重启 Codex Desktop 即可生效。${NC}"
