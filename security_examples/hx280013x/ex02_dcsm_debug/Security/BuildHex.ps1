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

function New-HexRecord([int]$Type, [int]$Address, [byte[]]$Data) {
    $sum = $Data.Length + ($Address -shr 8) + ($Address -band 255) + $Type
    $text = ':{0:X2}{1:X4}{2:X2}' -f $Data.Length, $Address, $Type
    foreach ($value in $Data) { $sum += $value; $text += '{0:X2}' -f $value }
    return $text + ('{0:X2}' -f ((256 - ($sum -band 255)) -band 255))
}

function Write-Hex($Image, [string]$Path) {
    $lines = New-Object 'System.Collections.Generic.List[string]'
    $keys = @($Image.Data.Keys | Sort-Object)
    $position = 0
    $lastUpper = -1
    while ($position -lt $keys.Count) {
        [uint32]$start = $keys[$position]
        $upper = [int]($start -shr 16)
        if ($upper -ne $lastUpper) {
            $lines.Add((New-HexRecord 4 0 ([byte[]]@(($upper -shr 8), ($upper -band 255)))))
            $lastUpper = $upper
        }
        $bytes = New-Object 'System.Collections.Generic.List[byte]'
        while ($position -lt $keys.Count -and $bytes.Count -lt 16 -and
               $keys[$position] -eq ($start + $bytes.Count) -and ($keys[$position] -shr 16) -eq $upper) {
            $bytes.Add($Image.Data[$keys[$position]])
            $position++
        }
        $lines.Add((New-HexRecord 0 ([int]($start -band 65535)) $bytes.ToArray()))
    }
    if ($Image.Entry) { $lines.Add($Image.Entry) }
    $lines.Add(':00000001FF')
    [IO.File]::WriteAllLines($Path, $lines.ToArray(), [Text.Encoding]::ASCII)
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
    $otpDirectory = Join-Path $buildRoot 'otp'
    & (Join-Path $PSScriptRoot 'BuildOtp.ps1') -IdeRoot $IdeRoot -OutputDirectory $otpDirectory
    $otp = Read-Hex (Join-Path $otpDirectory 'hx280013x_dcsm_zsb1.hex')
    if ($otp.Data.Count -eq 0) { throw 'OTP image is empty' }
    foreach ($address in $otp.Data.Keys) {
        if ($address -lt 0x00640000 -or $address -ge 0x00640800) { throw ('OTP data outside Zone1/Zone2 USER OTP: 0x{0:X8}' -f $address) }
        if ($app.Data.ContainsKey($address)) { throw 'APP and OTP images overlap' }
    }
    # Merge data records by absolute byte address. Gaps remain absent, never filled.
    $combined = New-Object 'System.Collections.Generic.Dictionary[uint32,byte]'
    foreach ($address in $app.Data.Keys) { $combined.Add($address, $app.Data[$address]) }
    foreach ($address in $otp.Data.Keys) { $combined.Add($address, $otp.Data[$address]) }
    Write-Hex ([pscustomobject]@{ Data = $combined; Entry = $app.Entry }) $fullTemp
    $check = Read-Hex $fullTemp
    if ($check.Data.Count -ne $combined.Count) { throw 'Combined HEX length mismatch' }
    foreach ($address in $combined.Keys) {
        if (-not $check.Data.ContainsKey($address) -or $check.Data[$address] -ne $combined[$address]) { throw 'Combined HEX verification failed' }
    }
    Move-Item -LiteralPath $plainTemp -Destination $plain
    Move-Item -LiteralPath $fullTemp -Destination $full
    Write-Output "HEX ready: $plain ($($app.Data.Count) APP bytes)"
    Write-Output "HEX ready: $full (APP + $($otp.Data.Count) DCSM bytes; no gap fill)"
} catch {
    Remove-Images
    throw
}
