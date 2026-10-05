function Get-PandoraRunCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $App = Get-AppxPackage | Where-Object { $_.Name -like "*Pandora*" }
    if ($App) {
        $Manifest = Get-AppxPackageManifest -Package $App.PackageFullName
        $AppID = $Manifest.Package.Applications.Application.Id
        $FamilyName = $App.PackageFamilyName

        Remove-Item -Path $Path -Force -ErrorAction "SilentlyContinue"
        Set-Content -Path $Path -Value "explorer.exe ""shell:AppsFolder\$FamilyName!$AppID"""
    } else {
        Set-Content -Path $Path -Value "ERROR Pandora not found."
    }
}

Get-PandoraRunCommand @args
