param([string]$IdeRoot = 'D:\Haawking-IDE-2.3.17')
$ErrorActionPreference = 'Stop'
$compilerBin = Join-Path $IdeRoot 'haawking-tools/compiler/Haawking-RISCV-LLVM/bin'
$gcc = Join-Path $compilerBin 'riscv32-haawking-elf-gcc.exe'
$objcopy = Join-Path $compilerBin 'riscv32-haawking-elf-objcopy.exe'
$linker = Join-Path $IdeRoot 'haawking-tools/compiler/haawking-elf-gcc/riscv32-unknown-elf/bin/ld.exe'
$projectRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$outputDir = Join-Path $projectRoot 'Debug/otp'
New-Item -ItemType Directory -Force $outputDir | Out-Null
foreach ($zone in @('z1', 'z2')) {
    & $gcc -march=rv32imc -mabi=ilp32 -x assembler-with-cpp -c (Join-Path $PSScriptRoot "hx280013x_dcsm_${zone}otp.S") -o (Join-Path $outputDir "${zone}.o")
    if ($LASTEXITCODE -ne 0) { throw "OTP assembler failed for $zone" }
}
$otpElf = Join-Path $outputDir 'hx280013x_dcsm_zsb1.elf'
& $linker -m elf32lriscv --entry=0 -T (Join-Path $PSScriptRoot 'DCSM_OTP.ld') -Map (Join-Path $outputDir 'hx280013x_dcsm_zsb1.map') -o $otpElf (Join-Path $outputDir 'z1.o') (Join-Path $outputDir 'z2.o')
if ($LASTEXITCODE -ne 0) { throw 'OTP link failed' }
& $objcopy -O ihex $otpElf (Join-Path $outputDir 'hx280013x_dcsm_zsb1.hex')
if ($LASTEXITCODE -ne 0) { throw 'OTP HEX conversion failed' }
Write-Output "OTP preparation artifact only: $outputDir. No programming is performed."
