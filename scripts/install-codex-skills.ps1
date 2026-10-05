[CmdletBinding()]
param(
    [Parameter()]
    [string]$DestinationRoot,

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path $PSScriptRoot -Parent
$sourceRoot = Join-Path $repositoryRoot 'skills'
$validator = Join-Path $PSScriptRoot 'test-codex-skills.ps1'

if ([string]::IsNullOrWhiteSpace($DestinationRoot)) {
    $codexRoot = $env:CODEX_HOME
    if ([string]::IsNullOrWhiteSpace($codexRoot)) {
        $userProfileDirectory = [Environment]::GetFolderPath('UserProfile')
        $codexRoot = Join-Path $userProfileDirectory '.codex'
    }
    $DestinationRoot = Join-Path $codexRoot 'skills'
}

& $validator -Root $sourceRoot

$skillNames = @(
    'zhongzhi-teaching-contest-master',
    'zhongzhi-competition-teaching-design',
    'zhongzhi-teaching-competition-presentation',
    'zhongzhi-teaching-speaking-script',
    'zhongzhi-teaching-mock-review'
)

New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null

foreach ($skillName in $skillNames) {
    $source = Join-Path $sourceRoot $skillName
    $destination = Join-Path $DestinationRoot $skillName

    if ((Test-Path -LiteralPath $destination) -and -not $Force) {
        throw "目标已存在：$destination。若要更新，请重新运行并添加 -Force。"
    }

    if (Test-Path -LiteralPath $destination) {
        Get-ChildItem -LiteralPath $source -Force | Copy-Item -Destination $destination -Recurse -Force
    }
    else {
        Copy-Item -LiteralPath $source -Destination $destination -Recurse
    }
    Write-Host "已安装：$skillName"
}

& $validator -Root $DestinationRoot
Write-Host '安装完成。请在下一轮对话或新建 Codex 对话后使用 $zhongzhi-teaching-contest-master。'
