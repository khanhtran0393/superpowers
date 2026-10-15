[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $TargetPath,
    [switch] $Force
)

$ErrorActionPreference = 'Stop'

function Get-ResolvedDirectory([string] $Path, [string] $Label) {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        throw "$Label does not exist or is not a directory: $Path"
    }
    return (Resolve-Path -LiteralPath $Path).Path
}

function Read-Utf8([string] $Path) {
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Write-Utf8NoBom([string] $Path, [string] $Content) {
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

function Copy-IntegrationItem(
    [string] $SourcePath,
    [string] $DestinationPath,
    [string] $RelativeName,
    [string] $BackupRoot,
    [bool] $Replace
) {
    if (Test-Path -LiteralPath $DestinationPath) {
        if (-not $Replace) {
            Write-Host "SKIP (already exists): $RelativeName"
            return 'skipped'
        }
        $backupPath = Join-Path $BackupRoot $RelativeName
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backupPath) | Out-Null
        Copy-Item -LiteralPath $DestinationPath -Destination $backupPath -Recurse -Force
        Remove-Item -LiteralPath $DestinationPath -Recurse -Force
        Write-Host "BACKUP: $RelativeName -> $backupPath"
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $DestinationPath) | Out-Null
    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Recurse -Force
    return 'installed'
}

function Adapt-CopiedSkill([string] $SkillDirectory) {
    Get-ChildItem -LiteralPath $SkillDirectory -Recurse -File -Filter '*.md' | ForEach-Object {
        $content = Read-Utf8 $_.FullName
        # Convert Superpowers namespaced skill references to Cline slash commands.
        $content = $content -replace 'superpowers:subagent-driven-development', '/executing-plans'
        $content = $content -replace 'superpowers:dispatching-parallel-agents', 'Cline-supported parallel agents when explicitly available; otherwise execute tasks sequentially'
        $content = $content -replace 'superpowers:([a-z0-9-]+)', '/$1'
        $content = $content -replace '/executing-plans \(recommended\) or /executing-plans', '/executing-plans'
        Write-Utf8NoBom -Path $_.FullName -Content $content
    }
}

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$targetRoot = Get-ResolvedDirectory -Path $TargetPath -Label 'Target project'
$separatorChars = [char[]]@([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
$repoRootNormalized = [System.IO.Path]::GetFullPath($repoRoot).TrimEnd($separatorChars)
$targetRootNormalized = [System.IO.Path]::GetFullPath($targetRoot).TrimEnd($separatorChars)

if ($targetRootNormalized.Equals($repoRootNormalized, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw 'TargetPath must point to the AI Video Studio project, not this Superpowers checkout.'
}

$coreSkillNames = @(
    'brainstorming',
    'writing-plans',
    'systematic-debugging',
    'test-driven-development',
    'verification-before-completion',
    'using-git-worktrees',
    'finishing-a-development-branch'
)

$integrationSkillRoot = Join-Path $PSScriptRoot 'skills'
$coreSourceRoot = Join-Path $repoRoot 'skills'
$allSkills = @()

foreach ($name in $coreSkillNames) {
    $allSkills += [PSCustomObject]@{
        Name = $name
        Source = Join-Path $coreSourceRoot $name
    }
}

Get-ChildItem -LiteralPath $integrationSkillRoot -Directory | Sort-Object Name | ForEach-Object {
    $allSkills += [PSCustomObject]@{
        Name = $_.Name
        Source = $_.FullName
    }
}

foreach ($skill in $allSkills) {
    $manifest = Join-Path $skill.Source 'SKILL.md'
    if (-not (Test-Path -LiteralPath $manifest -PathType Leaf)) {
        throw "Skill source is missing SKILL.md: $($skill.Source)"
    }
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupRoot = Join-Path $targetRootNormalized (Join-Path '.cline' (Join-Path 'integration-backups' $stamp))
$destSkillRoot = Join-Path $targetRootNormalized (Join-Path '.cline' 'skills')
$installed = 0
$skipped = 0

foreach ($skill in $allSkills) {
    $destination = Join-Path $destSkillRoot $skill.Name
    $relativeName = Join-Path (Join-Path '.cline' 'skills') $skill.Name
    $result = Copy-IntegrationItem -SourcePath $skill.Source -DestinationPath $destination -RelativeName $relativeName -BackupRoot $backupRoot -Replace ([bool]$Force)
    if ($result -eq 'installed') {
        Adapt-CopiedSkill -SkillDirectory $destination
        $installed++
    } else {
        $skipped++
    }
}

$sourceRule = Join-Path (Join-Path $PSScriptRoot 'rules') 'ai-video-studio-development.md'
if (-not (Test-Path -LiteralPath $sourceRule -PathType Leaf)) {
    throw "Project rule source is missing: $sourceRule"
}
$destinationRule = Join-Path $targetRootNormalized (Join-Path '.clinerules' 'ai-video-studio-development.md')
$ruleResult = Copy-IntegrationItem -SourcePath $sourceRule -DestinationPath $destinationRule -RelativeName (Join-Path '.clinerules' 'ai-video-studio-development.md') -BackupRoot $backupRoot -Replace ([bool]$Force)
if ($ruleResult -eq 'installed') {
    $installed++
} else {
    $skipped++
}

Write-Host ''
Write-Host "Cline integration finished. Installed: $installed; skipped: $skipped."
Write-Host "Target: $targetRootNormalized"
if ($Force) {
    Write-Host "Backups (if any files were replaced): $backupRoot"
}
Write-Host 'Next: open this project in Cline, enable Skills, and inspect the installed Skills before use.'
