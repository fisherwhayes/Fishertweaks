# KaramTweaks PowerShell/GitHub launcher
# Replace this with the public GitHub repository that hosts the releases.
$KaramTweaksRepository = 'OWNER/REPOSITORY'

function Start-KaramTweaksFromGitHub {
    [CmdletBinding()]
    param([Parameter(Mandatory = $true)][string]$Repository)

    $ErrorActionPreference = 'Stop'

    if ($Repository -notmatch '^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$' -or $Repository -match '^(OWNER|YOURNAME)/') {
        throw 'Set $KaramTweaksRepository near the top of this launcher to your public GitHub owner/repository first.'
    }

    $headers = @{ 'User-Agent' = 'KaramTweaks-Public-Launcher'; 'Accept' = 'application/vnd.github+json' }
    $api = "https://api.github.com/repos/$Repository/releases?per_page=10"
    $releases = Invoke-RestMethod -Uri $api -Headers $headers -Method Get
    $release = $releases | Where-Object { -not $_.draft -and -not $_.prerelease } | Select-Object -First 1
    if ($null -eq $release) { throw "No published stable release found in $Repository." }

    $asset = @($release.assets | Where-Object { $_.name -match '^KaramTweaks\.Native\.v[0-9]+(?:\.[0-9]+)*\.exe$' }) | Select-Object -First 1
    if ($null -eq $asset) { throw "Release $($release.tag_name) has no KaramTweaks.Native.vX.Y.exe asset." }
    $downloadUri = [Uri]$asset.browser_download_url
    if ($downloadUri.Scheme -ne 'https' -or $downloadUri.Host -ne 'github.com') { throw 'GitHub returned an unexpected download URL; refusing to download it.' }

    $appFolder = Join-Path $env:LOCALAPPDATA 'KaramTweaks\Releases'
    [void](New-Item -ItemType Directory -Path $appFolder -Force)
    $appPath = Join-Path $appFolder $asset.name
    $partialPath = "$appPath.download"

    try {
        Invoke-WebRequest -Uri $downloadUri.AbsoluteUri -Headers @{ 'User-Agent' = 'KaramTweaks-Public-Launcher' } -OutFile $partialPath
        if (-not (Test-Path -LiteralPath $partialPath -PathType Leaf) -or (Get-Item -LiteralPath $partialPath).Length -lt 100KB) {
            throw 'The downloaded app is missing or unexpectedly small; it was not launched.'
        }

        if ($asset.digest -match '^sha256:([0-9a-fA-F]{64})$') {
            $actualHash = (Get-FileHash -LiteralPath $partialPath -Algorithm SHA256).Hash
            if ($actualHash -ne $Matches[1]) { throw 'The downloaded file did not match GitHub’s published SHA-256 digest.' }
        }

        Move-Item -LiteralPath $partialPath -Destination $appPath -Force
        Write-Host "Starting KaramTweaks $($release.tag_name)..." -ForegroundColor Cyan
        Start-Process -FilePath $appPath
    }
    finally {
        if (Test-Path -LiteralPath $partialPath) { Remove-Item -LiteralPath $partialPath -Force -ErrorAction SilentlyContinue }
    }
}

try {
    Start-KaramTweaksFromGitHub -Repository $KaramTweaksRepository
}
catch {
    Write-Error ("KaramTweaks launcher: " + $_.Exception.Message)
}
