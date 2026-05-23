<#
.SYNOPSIS
  手动更新 Codex 中国法律技能包
.DESCRIPTION
  从上游拉取最新内容，同步技能和 MCP 连接器配置到 ~/.codex/skills/。
  检查 chineselaw-mcp / @pkulaw/mcp-cli 是否有新版本。
#>

$ErrorActionPreference = 'Stop'
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$UpstreamDir = "$env:USERPROFILE\.codex\vendor\claude-for-legal-CN"
$ConfigPath = "$env:USERPROFILE\.codex\config.toml"

$domains = @(
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal'
)

Write-Host '=== 更新 Codex 中国法律技能 ===' -ForegroundColor Green

# --- 步骤 1: 更新上游内容 ---
if (-not (Test-Path "$UpstreamDir\.git")) {
    Write-Host '[错误] 上游内容不存在。请先运行 install.ps1。' -ForegroundColor Red
    exit 1
}
Push-Location $UpstreamDir
$result = git pull 2>&1
Pop-Location
Write-Host "  [上游] $($result -join '')"

# --- 步骤 2: 同步技能 ---
$count = 0
foreach ($name in $domains) {
    $src = "$UpstreamDir\$name"
    $tgt = "$SkillsDir\$name"
    if (-not (Test-Path $src)) { continue }
    if (-not (Test-Path $tgt)) { $null = New-Item -ItemType Directory -Force $tgt }
    Copy-Item "$src\CLAUDE.md" "$tgt\CLAUDE.md" -Force -ErrorAction SilentlyContinue
    Copy-Item "$src\README.md" "$tgt\README.md" -Force -ErrorAction SilentlyContinue
    if (Test-Path "$src\.mcp.json") { Copy-Item "$src\.mcp.json" "$tgt\.mcp.json" -Force -ErrorAction SilentlyContinue }
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
Write-Host "  已同步 $count 个技能领域"

# --- 步骤 3: 检查 MCP 配置状态 ---
Write-Host ''
Write-Host '检查 MCP 连接器状态...' -ForegroundColor Yellow
if (Test-Path $ConfigPath) {
    $config = Get-Content $ConfigPath -Encoding UTF8 -Raw
    $checks = @{
        'chineselaw'           = 'mcp_servers.chineselaw'
        'pkulaw-law-search'    = 'mcp_servers.pkulaw-law-search'
        'pkulaw-case-keyword'  = 'mcp_servers.pkulaw-case-keyword'
    }
    foreach ($name in $checks.Keys) {
        if ($config -match "(?ms)^\[$($checks[$name])\]") {
            if ($config -match "(?ms)^\[$($checks[$name])\].*?enabled\s*=\s*true") {
                Write-Host "  [OK] $name (config.toml)" -ForegroundColor Green
            } else {
                Write-Host "  [!]  $name (已配置但未启用)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  [!!] $name (未配置)" -ForegroundColor Red
        }
    }
} else {
    Write-Host '  [!!] config.toml 不存在' -ForegroundColor Red
}

# --- 步骤 4: 检查 npm 包版本 ---
Write-Host ''
Write-Host '检查 npm 包版本...' -ForegroundColor Yellow

function Check-NpmVersion {
    param($PackageName, $DisplayName)
    try {
        $info = curl.exe -s "https://registry.npmjs.org/$PackageName/latest" 2>$null | ConvertFrom-Json
        $latest = $info.version
        # 检查本地是否已安装
        $local = & npx.cmd "$PackageName" --version 2>$null
        if (-not $local) { $local = "未安装" }

        if ($local -eq $latest) {
            Write-Host "  [OK] $DisplayName v$latest (已最新)" -ForegroundColor Green
        } elseif ($local -eq '未安装') {
            Write-Host "  [!]  $DisplayName latest=$latest (未在本地安装)" -ForegroundColor Yellow
        } else {
            Write-Host "  [!!] $DisplayName local=$local → latest=$latest (有新版本)" -ForegroundColor Yellow
            Write-Host "       更新: npm install -g $PackageName" -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "  [!]  $DisplayName (无法检查版本)" -ForegroundColor DarkGray
    }
}

Check-NpmVersion 'chineselaw-mcp' 'chineselaw-mcp'
Check-NpmVersion '@pkulaw/mcp-cli' '@pkulaw/mcp-cli'

# --- 步骤 5: 检测 @pkulaw/mcp-cli 并自动验证 ---
Write-Host ''
$pkulawCli = Get-Command 'pkulaw-mcp' -ErrorAction SilentlyContinue
if ($pkulawCli) {
    Write-Host '检测到 @pkulaw/mcp-cli，正在验证北大法宝服务状态...' -ForegroundColor Yellow
    try {
        $timeoutSec = 15
        $job = Start-Job -ScriptBlock { param($p) & $p update 2>&1 | Out-String }
        $job | Wait-Job -Timeout $timeoutSec | Out-Null
        if ($job.State -eq 'Completed') {
            $output = Receive-Job $job
            if ($output -match 'update completed|success|OK|成功') {
                Write-Host "  [OK] 北大法宝 CLI 验证通过" -ForegroundColor Green
            } else {
                Write-Host "  [!]  北大法宝 CLI 返回异常：" -ForegroundColor Yellow
                $output.Trim() -split "`n" | ForEach-Object { Write-Host "    $_" }
            }
        } else {
            Stop-Job $job
            Write-Host "  [!]  北大法宝 CLI 超时（${timeoutSec}s），跳过" -ForegroundColor Yellow
        }
        Remove-Job $job -ErrorAction SilentlyContinue
    } catch {
        Write-Host "  [!]  北大法宝 CLI 验证出错: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host '未检测到 @pkulaw/mcp-cli（可选，用于调试验证）' -ForegroundColor DarkGray
    Write-Host '  安装: npm install -g @pkulaw/mcp-cli' -ForegroundColor DarkGray
}

Write-Host ''
Write-Host '更新完成。重启 Codex Desktop 使新内容生效。' -ForegroundColor Green