<#
.SYNOPSIS
  一键安装 Codex 中国法律技能包
.DESCRIPTION
  1. 克隆上游法律内容 (SH88-source/claude-for-legal-CN)
  2. 安装 SKILL.md 包装层到 ~/.codex/skills/
  3. 设置 git 目录联接便于自动更新
#>

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$UpstreamDir = "$env:USERPROFILE\.codex\vendor\claude-for-legal-ZH"
$UpstreamSource = "C:\Users\being\Documents\codex-legal\claude-for-legal-CN"

Write-Host "=== Codex 中国法律技能包 安装 ===" -ForegroundColor Green
Write-Host ""

# 第1步：确保上游内容
Write-Host "[1/4] 检查上游法律内容..." -ForegroundColor Yellow
if (-not (Test-Path $UpstreamSource\README.md)) {
    # 尝试从 git 克隆（首次安装）
    $gitUrl = "https://github.com/SH88-source/claude-for-legal-CN.git"
    if (-not (Test-Path "$env:USERPROFILE\Documents\codex-legal")) {
        $null = New-Item -ItemType Directory -Force "$env:USERPROFILE\Documents\codex-legal"
    }
    Set-Location "$env:USERPROFILE\Documents\codex-legal"
    git clone $gitUrl claude-for-legal-CN 2>&1 | Out-Null
    $UpstreamSource = "$env:USERPROFILE\Documents\codex-legal\claude-for-legal-CN"
    Write-Host "  上游内容已克隆"
} else {
    Write-Host "  上游内容已就绪：$UpstreamSource"
}

# 第2步：设置 vendor 目录联接
Write-Host "[2/4] 设置内容链接..." -ForegroundColor Yellow
$null = New-Item -ItemType Directory -Force "$env:USERPROFILE\.codex\vendor"
if (Test-Path $UpstreamDir) {
    Remove-Item $UpstreamDir -Force -Recurse -ErrorAction SilentlyContinue
}
$null = New-Item -ItemType Junction -Path $UpstreamDir -Target $UpstreamSource -Force
Write-Host "  目录联接已创建：$UpstreamDir → $UpstreamSource"

# 第3步：安装 SKILL.md 包装层
Write-Host "[3/4] 安装技能包装层..." -ForegroundColor Yellow
$domains = @("commercial-legal","privacy-legal","product-legal","corporate-legal","employment-legal","regulatory-legal","ai-governance-legal","litigation-legal","law-student","legal-clinic","legal-builder-hub","ip-legal")
foreach ($name in $domains) {
    # 复制 SKILL.md
    $srcSkill = "$RepoRoot\skills\$name\SKILL.md"
    $tgtDir = "$SkillsDir\$name"
    if (Test-Path $srcSkill) {
        $null = New-Item -ItemType Directory -Force $tgtDir
        Copy-Item $srcSkill "$tgtDir\SKILL.md" -Force
    }
    # 复制上游 CLAUDE.md + references
    $upstreamModule = "$UpstreamSource\$name"
    if (Test-Path "$upstreamModule\CLAUDE.md") {
        Copy-Item "$upstreamModule\CLAUDE.md" "$tgtDir\CLAUDE.md" -Force
    }
    if (Test-Path "$upstreamModule\README.md") {
        Copy-Item "$upstreamModule\README.md" "$tgtDir\README.md" -Force
    }
    if (Test-Path "$upstreamModule\.mcp.json") {
        Copy-Item "$upstreamModule\.mcp.json" "$tgtDir\.mcp.json" -Force
    }
    if (Test-Path "$upstreamModule\references") {
        $null = New-Item -ItemType Directory -Force "$tgtDir\references"
        Get-ChildItem "$upstreamModule\references\*" -File | ForEach-Object {
            Copy-Item $_.FullName "$tgtDir\references\" -Force
        }
    }
    if (Test-Path "$upstreamModule\skills") {
        Get-ChildItem "$upstreamModule\skills" -Directory | ForEach-Object {
            $subTgt = "$tgtDir\skills\$($_.Name)"
            $null = New-Item -ItemType Directory -Force $subTgt
            if (Test-Path "$($_.FullName)\SKILL.md") {
                Copy-Item "$($_.FullName)\SKILL.md" "$subTgt\SKILL.md" -Force
            }
        }
    }
}
# 根技能
$null = New-Item -ItemType Directory -Force "$SkillsDir\codex-for-legal-cn"
Copy-Item "$RepoRoot\skills\codex-for-legal-cn\SKILL.md" "$SkillsDir\codex-for-legal-cn\SKILL.md" -Force
Write-Host "  技能安装完成"

# 第4步：设置执行策略
Write-Host "[4/4] 检查运行环境..." -ForegroundColor Yellow
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -eq "Restricted") {
    Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
    Write-Host "  执行策略已设为 RemoteSigned"
}
Write-Host ""
Write-Host "✓ 安装完成！请重启 Codex 终端使技能生效。" -ForegroundColor Green
Write-Host "  之后每次使用法律技能时会自动更新。"
