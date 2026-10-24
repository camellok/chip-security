param(
    [string]$ProjectName,
    [string]$BuildDirectory = '.',
    [string]$IdeRoot = 'D:\Haawking-IDE-2.3.17',
    [switch]$Clean
)
$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
if (-not $ProjectName) { $ProjectName = Split-Path $projectRoot -Leaf }
if ($ProjectName -notmatch '^[A-Za-z0-9_-]+$') { throw 'Invalid project name' }
$buildRoot = [IO.Path]::GetFullPath($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($BuildDirectory))
if (-not $buildRoot.StartsWith($projectRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Build directory must be inside this project'
}
$plain = Join-Path $buildRoot ($ProjectName + '.hex')
$full = Join-Path $buildRoot ($ProjectName + '_dcsm.hex')
$plainTemp = $plain + '.tmp'
$fullTemp = $full + '.tmp'
$outputs = @($plain, $full, $plainTemp, $fullTemp)

function Remove-Images {
    foreach ($path in $outputs) {
        if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Force }
    }
}

function Read-Hex([string]$Path) {
    $data = New-Object 'System.Collections.Generic.Dictionary[uint32,byte]'
    [uint32]$upper = 0
    $ended = $false
    $entry = $null
    foreach ($line in [IO.File]::ReadAllLines($Path)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($ended -or $line -notmatch '^:([0-9A-Fa-f]{2})+$') { throw "Invalid HEX record: $Path" }
        [byte[]]$record = for ($i = 1; $i -lt $line.Length; $i += 2) { [Convert]::ToByte($line.Substring($i, 2), 16) }
        $count = [int]$record[0]
        if ($record.Length -ne ($count + 5)) { throw "Invalid HEX length: $Path" }
        $sum = 0
        foreach ($value in $record) { $sum += $value }
        if (($sum -band 255) -ne 0) { throw "Invalid HEX checksum: $Path" }
        $address = ([int]$record[1] * 256) + [int]$record[2]
        switch ($record[3]) {
            0 {
                if (($address + $count) -gt 65536) { throw 'HEX data record crosses a 64 KB boundary' }
                for ($j = 0; $j -lt $count; $j++) {
                    [uint32]$absolute = $upper + $address + $j
                    if ($data.ContainsKey($absolute)) { throw ('Duplicate HEX address: 0x{0:X8}' -f $absolute) }
                    $data.Add($absolute, $record[4 + $j])
                }
            }
            1 { if ($count -ne 0) { throw 'Invalid EOF record' }; $ended = $true }
            2 { if ($count -ne 2) { throw 'Invalid segment record' }; $upper = (([uint32]$record[4] * 256) + $record[5]) * 16 }
            3 { if ($count -ne 4) { throw 'Invalid start address' }; $entry = $line }
            4 { if ($count -ne 2) { throw 'Invalid linear address record' }; $upper = (([uint32]$record[4] * 256) + $record[5]) * 65536 }
            5 { if ($count -ne 4) { throw 'Invalid start address' }; $entry = $line }
            default { throw "Unsupported HEX record type: $($record[3])" }
        }
    }
    if (-not $ended) { throw "Missing HEX EOF: $Path" }
    return [pscustomobject]@{ Data = $data; Entry = $entry }
}

# Invalidate both final files first, including after failed generation attempts.
Remove-Images
if ($Clean) { return }
try {
    $elf = Join-Path $buildRoot ($ProjectName + '.elf')
    if (-not (Test-Path -LiteralPath $elf)) { throw "APP ELF not found: $elf" }
    $objcopy = Join-Path $IdeRoot 'haawking-tools/compiler/Haawking-RISCV-LLVM/bin/riscv32-haawking-elf-objcopy.exe'
    & $objcopy -O ihex '--remove-section=.dcsm*' $elf $plainTemp
    if ($LASTEXITCODE -ne 0) { throw 'APP HEX conversion failed' }
    $app = Read-Hex $plainTemp
    if ($app.Data.Count -eq 0) { throw 'APP image is empty' }
    foreach ($address in $app.Data.Keys) {
        if ($address -lt 0x00600000 -or $address -ge 0x00640000) { throw ('APP data outside Flash: 0x{0:X8}' -f $address) }
    }
    # Both HEX variants follow the current ELF; OTP may be excluded in the IDE.
    & $objcopy -O ihex $elf $fullTemp
    if ($LASTEXITCODE -ne 0) { throw 'Full HEX conversion failed' }
    $check = Read-Hex $fullTemp
    $otpCount = 0
    foreach ($address in $check.Data.Keys) {
        if ($address -ge 0x00640000 -and $address -lt 0x00640800) {
            $otpCount++
        } elseif (-not $app.Data.ContainsKey($address) -or $app.Data[$address] -ne $check.Data[$address]) {
            throw ('Unexpected full HEX data: 0x{0:X8}' -f $address)
        }
    }
    foreach ($address in $app.Data.Keys) {
        if (-not $check.Data.ContainsKey($address) -or $check.Data[$address] -ne $app.Data[$address]) {
            throw 'Full HEX is missing APP data'
        }
    }
    if ($check.Data.Count -ne ($app.Data.Count + $otpCount) -or $check.Entry -ne $app.Entry) {
        throw 'Full HEX verification failed'
    }
    Move-Item -LiteralPath $plainTemp -Destination $plain
    Move-Item -LiteralPath $fullTemp -Destination $full
    Write-Output "HEX ready: $plain ($($app.Data.Count) APP bytes)"
    Write-Output "HEX ready: $full (APP + $otpCount DCSM bytes; no gap fill)"
    if ($otpCount -eq 0) {
        Write-Output 'OTP not present in ELF: both HEX files contain APP data only.'
    }
} catch {
    Remove-Images
    throw
}
