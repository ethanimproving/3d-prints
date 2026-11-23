# Builds scad-auto-preview-<version>.vsix without vsce. A VSIX is a zip holding a manifest
# and the extension files under extension/.
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$pkg = Get-Content (Join-Path $root 'package.json') -Raw | ConvertFrom-Json
$id = "$($pkg.publisher).$($pkg.name)"
$out = Join-Path $root "$($pkg.name)-$($pkg.version).vsix"
$stage = Join-Path ([IO.Path]::GetTempPath()) "$($pkg.name)-vsix"

if (Test-Path $stage) { Remove-Item -Recurse -Force $stage }
New-Item -ItemType Directory -Force (Join-Path $stage 'extension') | Out-Null
foreach ($f in 'package.json', 'extension.js', 'README.md') {
    Copy-Item -LiteralPath (Join-Path $root $f) -Destination (Join-Path $stage "extension\$f")
}

@'
<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension=".json" ContentType="application/json"/>
  <Default Extension=".js" ContentType="application/javascript"/>
  <Default Extension=".md" ContentType="text/markdown"/>
  <Default Extension=".vsixmanifest" ContentType="text/xml"/>
</Types>
'@ | ForEach-Object { [IO.File]::WriteAllText((Join-Path $stage '[Content_Types].xml'), $_) }

@"
<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011">
  <Metadata>
    <Identity Language="en-US" Id="$($pkg.name)" Version="$($pkg.version)" Publisher="$($pkg.publisher)"/>
    <DisplayName>$($pkg.displayName)</DisplayName>
    <Description xml:space="preserve">$($pkg.description)</Description>
    <Properties>
      <Property Id="Microsoft.VisualStudio.Code.Engine" Value="$($pkg.engines.vscode)"/>
      <Property Id="Microsoft.VisualStudio.Code.ExtensionDependencies" Value="$($pkg.extensionDependencies -join ',')"/>
      <Property Id="Microsoft.VisualStudio.Code.ExtensionKind" Value="workspace"/>
    </Properties>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Code"/>
  </Installation>
  <Dependencies/>
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true"/>
    <Asset Type="Microsoft.VisualStudio.Services.Content.Details" Path="extension/README.md" Addressable="true"/>
  </Assets>
</PackageManifest>
"@ | ForEach-Object { [IO.File]::WriteAllText((Join-Path $stage 'extension.vsixmanifest'), $_) }

if (Test-Path $out) { Remove-Item -Force $out }
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
# Add entries one by one: Windows PowerShell's CreateFromDirectory writes backslash entry names.
$zip = [IO.Compression.ZipFile]::Open($out, 'Create')
try {
    Get-ChildItem -LiteralPath $stage -Recurse -File | ForEach-Object {
        $name = $_.FullName.Substring($stage.Length).TrimStart('\').Replace('\', '/')
        [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $name)
    }
} finally {
    $zip.Dispose()
}
Remove-Item -Recurse -Force $stage
Write-Output "Built $out ($id)"
