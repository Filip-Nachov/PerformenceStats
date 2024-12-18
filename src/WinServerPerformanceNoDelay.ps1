function PrintNoDelay {
    param (
        [string]$text
    )
    Write-Host $text
}

function Get-CPU {
    $cpuUsage = Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty LoadPercentage
    return "$cpuUsage%"
}

function Get-Memory {
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $totalMemMB = [math]::round($osInfo.TotalVisibleMemorySize / 1KB)
    $freeMemMB = [math]::round($osInfo.FreePhysicalMemory / 1KB)
    $usedMemMB = $totalMemMB - $freeMemMB
    $freeMemGB = [math]::round($freeMemMB / 1024, 2)
    $usedMemMB = [math]::round($usedMemMB, 2)
    if ($usedMemMB -lt 0) {
        $usedMemMB = 0
    }
    return "Used memory: ${usedMemMB}MB`nFree memory: ${freeMemGB}GB"
}

function Get-Disk {
    $diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
    $diskOutput = ""
    $diskInfo | ForEach-Object {
        $usedSpace = [math]::round($_.Size - $_.FreeSpace)
        $usedPercent = [math]::round(($usedSpace / $_.Size) * 100)
        $availSpace = [math]::round($_.FreeSpace / 1GB)
        $usedSpaceGB = [math]::round($usedSpace / 1GB)
        $diskOutput += "$($_.DeviceID): $usedSpaceGB GB used, $availSpace GB available, $usedPercent% used`n"
    }
    return $diskOutput
}

function Get-Top5CPU {
    $topProcesses = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
    $topProcessOutput = ""
    $topProcesses | ForEach-Object {
        $topProcessOutput += "$($_.Name) - CPU: $($_.CPU) - Memory: $([math]::round($_.WorkingSet / 1MB)) MB`n"
    }
    return $topProcessOutput
}

function Bar {
    $CMD1 = Get-CPU
    $CMD2 = Get-Memory
    $CMD3 = Get-Disk
    $CMD4 = Get-Top5CPU

    PrintNoDelay "CPU USAGE"
    PrintNoDelay "-----------"
    PrintNoDelay "$CMD1"
    PrintNoDelay ""

    PrintNoDelay "MEMORY USAGE"
    PrintNoDelay "------------"
    PrintNoDelay "$CMD2"
    PrintNoDelay ""

    PrintNoDelay "DISK USAGE"
    PrintNoDelay "----------"
    PrintNoDelay "$CMD3"
    PrintNoDelay ""

    PrintNoDelay "TOP 5 PROCESSES"
    PrintNoDelay "---------------"
    PrintNoDelay "$CMD4"
}

Bar

