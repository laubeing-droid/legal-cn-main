<#
.SYNOPSIS
  手动更新 Codex 中国法律技能包
.DESCRIPTION
  从上游仓库拉取最新内容，同步到 ~/.codex/skills/ 各技能目录。
#>

$ErrorActionPreference = 'Stop'
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$UpstreamDir = "$env:USERPROFILE\.codex\vendor\claude-for-legal-CN"

$domains = @(
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal'
)

Write-Host '=== 更新 Codex 中国法律技能 ===' -ForegroundColor Green

if (-not (Test-Path "$UpstreamDir\.git")) {
    Write-Host '[错误] 上游内容不存在。请先运行 install.ps1。' -ForegroundColor Red
    exit 1
}

Push-Location $UpstreamDir
$result = git pull 2>&1
Pop-Location
Write-Host "  [上游] $($result -join '')"

$count = 0
foreach ($name in $domains) {
    $src = "$UpstreamDir\$name"
    $tgt = "$SkillsDir\$name"
    if (-not (Test-Path $src)) { continue }
    if (-not (Test-Path $tgt)) { $null = New-Item -ItemType Directory -Force $tgt }

    Copy-Item "$src\CLAUDE.md" "$tgt\CLAUDE.md" -Force -ErrorAction SilentlyContinue
    Copy-Item "$src\README.md" "$tgt\README.md" -Force -ErrorAction SilentlyContinue
    Copy-Item "$src\.mcp.json" "$tgt\.mcp.json" -Force -ErrorAction SilentlyContinue

    if (Test-Path "$src\references") {
        $null = New-Item -ItemType Directory -Force "$tgt\references"
        Get-ChildItem "$src\references\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgt\references\" -Force
        }
    }
    if (Test-Path "$src\skills") {
        Get-ChildItem "$src\skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $subTgt = "$tgt\skills\$($_.Name)"
            $null = New-Item -ItemType Directory -Force $subTgt
            if (Test-Path "$($_.FullName)\SKILL.md") { Copy-Item "$($_.FullName)\SKILL.md" "$subTgt\SKILL.md" -Force }
        }
    }
    if (Test-Path "$src\agents") {
        $null = New-Item -ItemType Directory -Force "$tgt\agents"
        Get-ChildItem "$src\agents\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgt\agents\" -Force
        }
    }
    $count++
}

Write-Host "  已更新 $count 个技能领域"
Write-Host ''
Write-Host '更新完成。重启 Codex Desktop 使新内容生效。' -ForegroundColor Green
