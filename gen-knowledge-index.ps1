# gen-knowledge-index.ps1 v1.1
# Auto-scan skills/*/references/ and regenerate MAPPING.md

$RepoRoot = $PSScriptRoot
$SkillsDir = Join-Path $RepoRoot "skills"
$OutputFile = Join-Path $SkillsDir "knowledge-base\MAPPING.md"

$nameMap = @{
    'civil_code.md'='民法典'
    'company_law.md'='公司法2024修订'
    'company_law_time_effect_interpretation.md'='公司法时间效力规定'
    'contract_general_interpretation.md'='合同编通则司法解释'
    'patent_law.md'='专利法'; 'trademark_law.md'='商标法'; 'copyright_law.md'='著作权法'
    'ip_punitive_damages_interpretation.md'='知识产权惩罚性赔偿解释'
    'personal_information_protection_law.md'='个人信息保护法'
    'data_security_law.md'='数据安全法'
    'network_data_security_regulation.md'='网络数据安全管理条例'
    'personal_info_export_standard_contract.md'='个人信息出境标准合同'
    'gen_ai_interim_measures.md'='生成式AI暂行办法'
    'algorithm_recommendation_provisions.md'='算法推荐管理规定'
    'deep_synthesis_provisions.md'='深度合成管理规定'
    'ai_content_label_method.md'='AI内容标识办法'
    'advertising_law.md'='广告法2021修正'
    'internet_advertising_measures.md'='互联网广告管理办法'
    'absolute_terms_ad_guide.md'='绝对化用语广告指南'
    'consumer_protection_regulation.md'='消保法实施条例'
    'contract_admin_supervision_measures.md'='合同行政监督办法'
    'online_anti_unfair_competition_provisions.md'='网络反不正当竞争规定'
}

$include = '*_law.md','*_law_*.md','*_regulation.md','*_measures.md','*_provisions.md','*_interim_measures.md','*_interpretation.md','*civil_code.md','*_guide.md','*_contract.md','*_method.md'
$exclude = '*-core.md','*-alignment.md','*-watch.md','*-checklist.md','*-playbook.md','*-quickref.md','reasoning-template-zh.md','*company-profile*','*dashboard*','*currency*'

function Test-LawFile($n) {
    foreach ($p in $include) { if ($n -like $p) {
        foreach ($e in $exclude) { if ($n -like $e) { return $false } }
        return $true
    }}
    return $false
}
function Get-Name($f) { if ($nameMap.ContainsKey($f)) { return $nameMap[$f] }; return ($f -replace '\.md$','' -replace '_',' ') }

$entries = @()
foreach ($domain in Get-ChildItem $SkillsDir -Directory) {
    $refDir = Join-Path $domain.FullName "references"
    if (Test-Path $refDir) {
        foreach ($file in Get-ChildItem $refDir -File -ErrorAction SilentlyContinue) {
            if (-not (Test-LawFile $file.Name)) { continue }
            $lines = (Get-Content $file.FullName | Measure-Object -Line).Lines
            $path = "skills/$($domain.Name)/references/$($file.Name)"
            $entries += [PSCustomObject]@{Law=(Get-Name $file.Name);Lines=$lines;Path=$path;Domain=$domain.Name}
        }
    }
    # knowledge-base has files directly in the folder
    if ($domain.Name -eq 'knowledge-base') {
        foreach ($file in Get-ChildItem $domain.FullName -File -ErrorAction SilentlyContinue) {
            if (-not (Test-LawFile $file.Name)) { continue }
            $lines = (Get-Content $file.FullName | Measure-Object -Line).Lines
            $path = "skills/knowledge-base/$($file.Name)"
            $entries += [PSCustomObject]@{Law=(Get-Name $file.Name);Lines=$lines;Path=$path;Domain='global'}
        }
    }
}

$entries = $entries | Sort-Object Domain, Law
$date = Get-Date -Format 'yyyy-MM-dd'
$total = $entries.Count
$domCount = ($entries.Domain | Select-Object -Unique).Count

$md = "# Knowledge Base Index`n`n> Auto-generated: $date | gen-knowledge-index.ps1`n> Scan: skills/*/references/ + skills/knowledge-base/`n`n| Law | Articles | Path | Domain |`n|:---|:--:|:---|:---|`n"
foreach ($e in $entries) { $md += "| $($e.Law) | $($e.Lines) lines | $($e.Path) | $($e.Domain) |`n" }
$md += "`n---`n> **$total laws across $domCount domains**`n> Run ``.\gen-knowledge-index.ps1`` to regenerate`n"

[System.IO.File]::WriteAllText($OutputFile, $md, (New-Object System.Text.UTF8Encoding $true))
Write-Host "Done: $total laws across $domCount domains"
foreach ($e in $entries) { Write-Host "  $($e.Domain) : $($e.Law) ($($e.Lines) lines)" }