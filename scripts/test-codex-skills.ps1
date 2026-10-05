[CmdletBinding()]
param(
    [Parameter()]
    [string]$Root = (Join-Path (Split-Path $PSScriptRoot -Parent) 'skills')
)

$ErrorActionPreference = 'Stop'

$skillNames = @(
    'zhongzhi-teaching-contest-master',
    'zhongzhi-competition-teaching-design',
    'zhongzhi-teaching-competition-presentation',
    'zhongzhi-teaching-speaking-script',
    'zhongzhi-teaching-mock-review'
)

$failures = [System.Collections.Generic.List[string]]::new()

foreach ($skillName in $skillNames) {
    $skillDirectory = Join-Path $Root $skillName
    $skillFile = Join-Path $skillDirectory 'SKILL.md'
    $metadataFile = Join-Path $skillDirectory 'agents\openai.yaml'

    if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
        $failures.Add("$skillName：缺少 SKILL.md")
        continue
    }

    $content = Get-Content -LiteralPath $skillFile -Raw
    if ($content -notmatch '(?ms)\A---\s*\r?\n.*?^name:\s*([^\r\n]+)') {
        $failures.Add("$skillName：SKILL.md 缺少有效 YAML frontmatter/name")
    }
    elseif ($Matches[1].Trim(' ', '"', "'") -ne $skillName) {
        $failures.Add("$skillName：frontmatter name 与目录名不一致")
    }

    if ($content -notmatch '(?m)^description:\s*\S.+$') {
        $failures.Add("$skillName：SKILL.md 缺少非空 description")
    }

    if (-not (Test-Path -LiteralPath $metadataFile -PathType Leaf)) {
        $failures.Add("$skillName：缺少 agents/openai.yaml")
        continue
    }

    $metadata = Get-Content -LiteralPath $metadataFile -Raw
    if ($metadata -notmatch '(?m)^interface:\s*$' -or
        $metadata -notmatch '(?m)^\s+display_name:\s*".+"\s*$' -or
        $metadata -notmatch '(?m)^\s+short_description:\s*".+"\s*$' -or
        $metadata -notmatch [regex]::Escape("`$$skillName")) {
        $failures.Add("$skillName：agents/openai.yaml 字段不完整或 default_prompt 未显式引用 Skill")
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "验证通过：$($skillNames.Count) 个 Codex Skill 的目录、frontmatter 与 UI 元数据均有效。"
