# Law Freshness Check — 本地法律版本核实脚本
# 用法: .\patches\law-freshness.ps1

param(
    [switch]$UpdateNextCheck  # 将核实日期更新为6个月后
)

$versionsFile = Join-Path $PSScriptRoot "..\skills\references\law-versions.json"
if (-not (Test-Path $versionsFile)) {
    Write-Host "[!!] law-versions.json not found" -ForegroundColor Red
    exit 1
}

$data = Get-Content $versionsFile -Raw -Encoding UTF8 | ConvertFrom-Json
$today = Get-Date -Format "yyyy-MM-dd"
$overdue = @()

Write-Host "=== 法律版本核实 ===" -ForegroundColor Cyan
Write-Host "日期: $today`n"

foreach ($category in @("laws", "judicial_interpretations")) {
    $label = if ($category -eq "laws") { "法律" } else { "司法解释" }
    foreach ($prop in $data.$category.PSObject.Properties) {
        $name = $prop.Name
        $info = $prop.Value
        $nextCheck = $info.next_check
        $status = $info.status
        
        if ($nextCheck -and $nextCheck -lt $today) {
            $overdue += "[$label] $name"
            Write-Host "🔴 [$label] $name" -ForegroundColor Red
            Write-Host "   现行版本: $($info.current_version)"
            Write-Host "   上次核实应不晚于: $nextCheck (已过期)"
            Write-Host "   来源: $($info.source_url)"
            if ($info.note) { Write-Host "   注意: $($info.note)" -ForegroundColor Yellow }
            Write-Host ""
        } elseif ($nextCheck) {
            $days = (New-TimeSpan -Start $today -End $nextCheck).Days
            if ($days -le 30) {
                Write-Host "🟡 [$label] $name — $days 天后需核实" -ForegroundColor Yellow
            }
        }
    }
}

# Upcoming items
Write-Host "--- 待关注的新法规/修正案 ---" -ForegroundColor Cyan
foreach ($category in @("laws", "judicial_interpretations")) {
    foreach ($prop in $data.$category.PSObject.Properties) {
        $info = $prop.Value
        foreach ($u in $info.upcoming) {
            if ($u.status -match "待纳入|征求意见|未施行") {
                Write-Host "  ⚠️  $($u.description) — $($u.status)" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host "`n--- 汇总 ---"
Write-Host "追踪法律: $($data.meta.total_laws) 部"
Write-Host "追踪司法解释: $($data.meta.total_interpretations) 部"
Write-Host "过期未核实: $($overdue.Count) 项"

if ($overdue.Count -eq 0) {
    Write-Host "✅ 全部在核实窗口内" -ForegroundColor Green
}

if ($UpdateNextCheck) {
    Write-Host "`n[UpdateNextCheck] 将更新所有已过期项的 next_check 为6个月后..." -ForegroundColor Yellow
    $newDate = (Get-Date).AddMonths(6).ToString("yyyy-MM-dd")
    foreach ($category in @("laws", "judicial_interpretations")) {
        foreach ($prop in $data.$category.PSObject.Properties) {
            if ($prop.Value.next_check -and $prop.Value.next_check -lt $today) {
                $prop.Value.next_check = $newDate
                Write-Host "  更新: $($prop.Name) → $newDate"
            }
        }
    }
    $data.meta.last_updated = $today
    $data | ConvertTo-Json -Depth 5 | Set-Content $versionsFile -Encoding UTF8
    Write-Host "Done." -ForegroundColor Green
}
