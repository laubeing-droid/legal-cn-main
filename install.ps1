<#
.SYNOPSIS
  一键安装 Codex 中国法律技能包
.DESCRIPTION
  1. 克隆上游法律内容 (SH88-source/claude-for-legal-CN)
  2. 安装 SKILL.md 包装层到 ~/.codex/skills/
  3. 设置内容链接便于自动更新
#>

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$VendorDir = "$env:USERPROFILE\.codex\vendor"
$UpstreamDir = "$VendorDir\claude-for-legal-CN"
$GitUrl = 'https://github.com/SH88-source/claude-for-legal-CN.git'

Write-Host '=== Codex 中国法律技能包 安装 ===' -ForegroundColor Green
Write-Host ''

Write-Host '[1/4] 克隆上游法律内容...' -ForegroundColor Yellow
$null = New-Item -ItemType Directory -Force $VendorDir
if (Test-Path "$UpstreamDir\README.md") {
    Push-Location $UpstreamDir
    git pull 2>&1 | Out-Null
    Pop-Location
    Write-Host "  上游内容已存在，已拉取最新: $UpstreamDir"
} else {
    Write-Host "  正在克隆: $GitUrl"
    Push-Location $VendorDir
    git clone $GitUrl claude-for-legal-CN 2>&1 | Out-Null
    Pop-Location
    if (-not (Test-Path "$UpstreamDir\README.md")) {
        Write-Host '  [错误] 克隆失败，请检查网络连接' -ForegroundColor Red
        exit 1
    }
    Write-Host '  上游内容已克隆'
}

Write-Host '[2/4] 安装技能包装层...' -ForegroundColor Yellow
$domains = @(
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal'
)
foreach ($name in $domains) {
    $srcSkill = "$RepoRoot\skills\$name\SKILL.md"
    $tgtDir = "$SkillsDir\$name"
    $null = New-Item -ItemType Directory -Force $tgtDir
    if (Test-Path $srcSkill) {
        Copy-Item $srcSkill "$tgtDir\SKILL.md" -Force
    }
    $upstreamModule = "$UpstreamDir\$name"
    if (Test-Path "$upstreamModule\CLAUDE.md") { Copy-Item "$upstreamModule\CLAUDE.md" "$tgtDir\CLAUDE.md" -Force }
    if (Test-Path "$upstreamModule\README.md") { Copy-Item "$upstreamModule\README.md" "$tgtDir\README.md" -Force }
    if (Test-Path "$upstreamModule\.mcp.json") { Copy-Item "$upstreamModule\.mcp.json" "$tgtDir\.mcp.json" -Force }
    if (Test-Path "$upstreamModule\references") {
        $null = New-Item -ItemType Directory -Force "$tgtDir\references"
        Get-ChildItem "$upstreamModule\references\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgtDir\references\" -Force
        }
    }
    if (Test-Path "$upstreamModule\skills") {
        Get-ChildItem "$upstreamModule\skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $subTgt = "$tgtDir\skills\$($_.Name)"
            $null = New-Item -ItemType Directory -Force $subTgt
            if (Test-Path "$($_.FullName)\SKILL.md") { Copy-Item "$($_.FullName)\SKILL.md" "$subTgt\SKILL.md" -Force }
        }
    }
    if (Test-Path "$upstreamModule\agents") {
        $null = New-Item -ItemType Directory -Force "$tgtDir\agents"
        Get-ChildItem "$upstreamModule\agents\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgtDir\agents\" -Force
        }
    }
}
# 根技能
$rootTgt = "$SkillsDir\codex-for-legal-cn"
$null = New-Item -ItemType Directory -Force $rootTgt
Copy-Item "$RepoRoot\skills\codex-for-legal-cn\SKILL.md" "$rootTgt\SKILL.md" -Force
Write-Host '  技能安装完成'

Write-Host '[3/4] 配置 PowerShell 执行策略...' -ForegroundColor Yellow
$policy = Get-ExecutionPolicy -Scope CurrentUser 2>$null
if ($policy -eq 'Restricted') {
    Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
    Write-Host '  执行策略已设为 RemoteSigned'
} else {
    Write-Host '  执行策略正常'
}

Write-Host '[4/4] 验证安装...' -ForegroundColor Yellow
$missing = @()
$all = $domains + @('codex-for-legal-cn')
foreach ($name in $all) {
    if (-not (Test-Path "$SkillsDir\$name\SKILL.md")) {
        $missing += $name
    }
}
if ($missing.Count -eq 0) {
    Write-Host "  全部 $($all.Count) 个技能安装成功" -ForegroundColor Green
} else {
    Write-Host "  以下技能缺失: $($missing -join ', ')" -ForegroundColor Red
    Write-Host '  请检查网络后重新运行 install.ps1'
    exit 1
}

Write-Host ''
Write-Host '安装完成！请重启 Codex Desktop 使技能生效。' -ForegroundColor Green
Write-Host '之后每次使用法律技能时会自动同步上游更新。'
