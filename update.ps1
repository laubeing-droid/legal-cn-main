<#
.SYNOPSIS
  手动更新 Codex 中国法律技能包
#>

$ErrorActionPreference = "Stop"
$UpstreamSource = "C:\Users\being\Documents\codex-legal\claude-for-legal-CN"
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$domains = @("commercial-legal","privacy-legal","product-legal","corporate-legal","employment-legal","regulatory-legal","ai-governance-legal","litigation-legal","law-student","legal-clinic","legal-builder-hub","ip-legal")

Write-Host "=== 更新 Codex 中国法律技能 ===" -ForegroundColor Green

# 更新上游
if (Test-Path $UpstreamSource) {
    Set-Location $UpstreamSource
    $result = git pull 2>&1
    Write-Host "[upstream] $result"
} else {
    Write-Host "[!] 上游内容不存在，请先运行 install.ps1" -ForegroundColor Red
    exit 1
}

# 同步到 skills
foreach ($name in $domains) {
    $src = "$UpstreamSource\$name"
    $tgt = "$SkillsDir\$name"
    if (Test-Path $src) {
        if (Test-Path "$src\CLAUDE.md") { Copy-Item "$src\CLAUDE.md" "$tgt\CLAUDE.md" -Force }
        if (Test-Path "$src\README.md") { Copy-Item "$src\README.md" "$tgt\README.md" -Force }
        if (Test-Path "$src\references") {
            Get-ChildItem "$src\references\*" -File | ForEach-Object { Copy-Item $_.FullName "$tgt\references\" -Force }
        }
        if (Test-Path "$src\skills") {
            Get-ChildItem "$src\skills" -Directory | ForEach-Object {
                $subTgt = "$tgt\skills\$($_.Name)"
                if (Test-Path "$($_.FullName)\SKILL.md") { Copy-Item "$($_.FullName)\SKILL.md" "$subTgt\SKILL.md" -Force }
            }
        }
        if (Test-Path "$src\agents") {
            Get-ChildItem "$src\agents\*" -File | ForEach-Object { Copy-Item $_.FullName "$tgt\agents\" -Force }
        }
    }
}
Write-Host "
✓ 更新完成，请重启 Codex 终端" -ForegroundColor Green
