$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $repositoryRoot "plugin.json"
$filesToPackage = @(
    @{ Path = "main.lua"; Entry = "main.lua" },
    @{ Path = "plugin.json"; Entry = "plugin.json" },
    @{ Path = "LICENSE"; Entry = "LICENSE" },
    @{ Path = "src\enumerable.lua"; Entry = "src/enumerable.lua" }
)

if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Plugin manifest not found: $manifestPath"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
if ([string]::IsNullOrWhiteSpace($manifest.name)) {
    throw "plugin.json must define a plugin name."
}
if ($manifest.version -notmatch '^\d+(\.\d+)*$') {
    throw "plugin.json version must contain only numbers and periods."
}
if ([string]::IsNullOrWhiteSpace($manifest.contactEmailAddress) -or
    $manifest.contactEmailAddress -match '^REPLACE_WITH_') {
    throw "Set contactEmailAddress in plugin.json before packaging."
}

foreach ($file in $filesToPackage) {
    $sourcePath = Join-Path $repositoryRoot $file.Path
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
        throw "Required package file not found: $sourcePath"
    }
}

$invalidFileNameChars = [System.IO.Path]::GetInvalidFileNameChars()
$packageName = -join ($manifest.name.ToCharArray() | Where-Object {
    $invalidFileNameChars -notcontains $_
})
$outputDirectory = Join-Path $repositoryRoot "dist"
$archivePath = Join-Path $outputDirectory "$packageName-$($manifest.version).zip"

New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$archive = $null
try {
    $archive = [System.IO.Compression.ZipFile]::Open(
        $archivePath,
        [System.IO.Compression.ZipArchiveMode]::Create
    )

    foreach ($file in $filesToPackage) {
        $sourcePath = Join-Path $repositoryRoot $file.Path
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $archive,
            $sourcePath,
            $file.Entry,
            [System.IO.Compression.CompressionLevel]::Optimal
        ) | Out-Null
    }
}
catch {
    if ($archive -ne $null) {
        $archive.Dispose()
        $archive = $null
    }
    if (Test-Path -LiteralPath $archivePath -PathType Leaf) {
        Remove-Item -LiteralPath $archivePath
    }
    throw
}
finally {
    if ($archive -ne $null) {
        $archive.Dispose()
    }
}

Write-Output "Created Mod.io package: $archivePath"
