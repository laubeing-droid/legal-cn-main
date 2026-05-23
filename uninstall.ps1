<#
.SYNOPSIS
  卸载 Codex 中国法律技能包
.DESCRIPTION
  删除 ~/.codex/skills/ 下所有法律技能和 ~/.codex/vendor/ 下上游内容。
  本仓库的克隆文件不受影响。
#>

$SkillsDir = "$env:USERPROFILE\.codex\skills"
$VendorDir = "$env:USERPROFILE\.codex\vendor"

Write-Host '=== 卸载 Codex 中国法律技能包 ===' -ForegroundColor Yellow
Write-Host ''

$domains = @(
    'codex-for-legal-cn',
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal'
)

Write-Host '[1/2] 删除技能目录...'
$removed = 0
foreach ($name in $domains) {
    $dir = "$SkillsDir\$name"
    if (Test-Path $dir) {
        Remove-Item $dir -Recurse -Force
        Write-Host "  - 已删除: $name"
        $removed++
    }
}
Write-Host "  共删除 $removed 个技能目录"

Write-Host '[2/2] 删除上游内容缓存...'
if (Test-Path $VendorDir) {
    Remove-Item $VendorDir -Recurse -Force
    Write-Host '  - 已删除: ~/.codex/vendor/'
} else {
    Write-Host '  - 无上游缓存'
}

Write-Host ''
Write-Host '卸载完成。重启 Codex Desktop 即可生效。' -ForegroundColor Green
