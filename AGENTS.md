# Repository Guidelines

## Project Structure & Module Organization

`security_examples/` contains standalone Haawking IDE projects: `ex00_base_system`, `ex01_dcsm_secure_flash`, and `ex02_dcsm_debug`. Each project keeps application logic in `src/`, peripheral helpers in `Driver/`, and demonstration calculations in `Algorithms/`. `Security/` contains OTP assembly templates and the demonstration password header. Vendor sources and linker scripts live under `haawking-drivers/`; startup configuration lives under `device/`.

`Debug/` contains generated build recipes and ELF, HEX, and map outputs. Root documents include `README.md`, `FAQ.md`, and `DCSM_ERRATA.md`. Planned examples and 280013x support must be distinguished from implemented, verified behavior.

## Build, Test, and Development Commands

Use Haawking IDE 2.3.17 or its bundled tools. From the repository root in PowerShell:

```powershell
$ide = 'D:\Haawking-IDE-2.3.17'
$env:Path = "$ide\haawking-tools\compiler\Haawking-RISCV-LLVM\bin;$ide\haawking-tools\compiler\bin;$env:Path"
make -C security_examples/ex02_dcsm_debug/Debug all
```

Replace the example directory as needed. Use `-B all` to force rebuilding after linker changes. Prefer changing IDE settings over editing generated makefiles. When copying projects, check `.project`, `.cproject`, `.launch`, and absolute linker paths together.

## Coding Style & Naming Conventions

Keep demonstrations small: polling loops, few variables, and existing DriverLib APIs. Follow nearby naming patterns such as `Drv_Sci_Log_Print`, `g_epwm_cmp_value`, and uppercase register macros. Use four-space indentation for new C code; avoid unrelated formatting changes. Keep vendor libraries unchanged and place documented experimental preparation steps in application code. No formatter or linter configuration is currently provided.

## Testing Guidelines

There is no automated test framework or coverage threshold. Build first, then inspect map and HEX contents, including section sizes, RAM runtime addresses, and Flash load addresses. Check disassembly when volatile reads or instruction placement matter.

Hardware validation includes standalone boot, UART/LED operation, repeated lock/unlock, protected-memory readback, and power-cycle recovery. The ex02 baseline includes ten successful cycles. Record target, tool versions, register values, and observed results; compilation alone is not board validation.

## Commit & Pull Request Guidelines

This checkout is managed in the public camellok/chip-security GitHub repository. Use scoped subjects such as `ex02: document lock-state readback`. Changes should identify affected examples, configuration changes, build results, and hardware evidence. Preserve user edits and existing validation records.

## Security & Configuration

Separate Flash updates from OTP programming; full HEX files can contain OTP sections. Back up device-specific OTP before intentional programming. Demo passwords are not production provisioning. Describe unresolved behavior neutrally: do not assume driver defects, future library fixes, or equivalent TI and Haawking behavior.
