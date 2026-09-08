$operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
$reportDirectory = Join-Path $PSScriptRoot "reports"
New-Item -ItemType Directory -Path $reportDirectory -Force | Out-Null

$diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = 3" |
    Select-Object DeviceID,
        @{Name = "TotalGB"; Expression = {[math]::Round($_.Size / 1GB, 2)}},
        @{Name = "FreeGB"; Expression = {[math]::Round($_.FreeSpace / 1GB, 2)}},
        @{Name = "FreePercent"; Expression = {[math]::Round(($_.FreeSpace / $_.Size) * 100, 1)}}

$networkInfo = Get-NetIPConfiguration |
    Where-Object { $null -ne $_.IPv4DefaultGateway } |
    ForEach-Object {
        [PSCustomObject]@{
            Interface   = $_.InterfaceAlias
            IPv4Address = $_.IPv4Address.IPAddress -join ", "
            Gateway     = $_.IPv4DefaultGateway.NextHop -join ", "
            DnsServers  = $_.DNSServer.ServerAddresses -join ", "
        }
    }

$importantServices = @(
    "WinDefend"
    "MpsSvc"
    "wuauserv"
    "ssh-agent"
    "com.docker.service"
    "WslService"
    "LxssManager"
)

$serviceInfo = Get-Service -Name $importantServices -ErrorAction SilentlyContinue |
    Select-Object Name, DisplayName, Status, StartType

$report = [ordered]@{
    GeneratedAt     = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    ComputerName    = $env:COMPUTERNAME
    CurrentUser     = "$env:USERDOMAIN\$env:USERNAME"
    OperatingSystem = $operatingSystem.Caption
    WindowsVersion  = $operatingSystem.Version
    BuildNumber     = $operatingSystem.BuildNumber
    LastBootTime    = $operatingSystem.LastBootUpTime
    TotalMemoryGB   = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
}

$reportDirectory = Join-Path $PSScriptRoot "reports"
New-Item -ItemType Directory -Path $reportDirectory -Force | Out-Null

$reportFileName = "system-report-{0}.txt" -f (Get-Date -Format "yyyyMMdd-HHmmss")
$reportPath = Join-Path $reportDirectory $reportFileName

$reportText = @(
    "=== ASTA IT OPERATIONS - WINDOWS SYSTEM REPORT ==="
    ""
    "--- General information ---"
    (([PSCustomObject]$report | Format-List | Out-String).TrimEnd())
    ""
    "--- Fixed disks ---"
    (($diskInfo | Format-Table -AutoSize | Out-String).TrimEnd())
    ""
    "--- Active network interfaces ---"
    (($networkInfo | Format-Table -AutoSize -Wrap | Out-String).TrimEnd())
    ""
    "--- Important services ---"
    (($serviceInfo | Format-Table -AutoSize | Out-String).TrimEnd())
) -join [Environment]::NewLine

$reportText | Set-Content -Path $reportPath -Encoding UTF8

$reportText
Write-Output "`nReport saved to: $reportPath"