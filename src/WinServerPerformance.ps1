function PrintDelay {
    param (
        [string]$text,
        [float]$delay
    )
    foreach ($char in $text.ToCharArray()) {
        Write-Host -NoNewline $char
        Start-Sleep -Seconds $delay
    }
    Write-Host
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

    PrintDelay "CPU USAGE" 0.02
    PrintDelay "-----------" 0.01
    PrintDelay "$CMD1" 0.03
    PrintDelay "" 0.01

    PrintDelay "MEMORY USAGE" 0.02
    PrintDelay "------------" 0.01
    PrintDelay "$CMD2" 0.03
    PrintDelay "" 0.01

    PrintDelay "DISK USAGE" 0.02
    PrintDelay "----------" 0.01
    PrintDelay "$CMD3" 0.03
    PrintDelay "" 0.05

    PrintDelay "TOP 5 PROCESSES" 0.02
    PrintDelay "---------------" 0.01
    PrintDelay "$CMD4" 0.03
}

Bar

