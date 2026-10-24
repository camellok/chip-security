# 280013x链接脚本差异与清理说明

日期：2026-10-24。比较基线为用户提供的2800137_EDE模板中 `haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld`；该原版文件可从Git提交 `5438c9a` 获取，无需在各工程内保留副本。

修改后的应用Flash主脚本已放回各工程的 `haawking-drivers/ldscripts/`，布局内容保持不变；原版副本与未使用RAM脚本不保留。ex01和ex02的应用Flash脚本完全相同。主脚本包含DCSM.ld，但这不等于OTP源已参与构建：ex02当前主动排除两个OTP汇编源，ELF无OTP；脚本已支持无OTP构建并完成复验，见[当前状态](REGRESSION_HX280013X_EX00_EX02.md)。

## 布局差异

| 项目 | 厂商原版Flash脚本 | ex00应用脚本 | ex01 / ex02应用脚本 |
| --- | --- | --- | --- |
| 启动入口 | `_start`，BEGIN `0x00600000`，预留0x10字节 | 相同 | 相同 |
| 普通APP Flash | `0x00600010`～`0x0063FFFF`，长度0x3FFF0 | 相同 | `0x00600010`～`0x0060FFFF`，长度0xFFF0 |
| 模块代码 | 无专门的 `module_code` 收集规则 | `*(module_code)` 收入普通 `text` | 独立输出段，`0x00610000`起，容量0x4000，扇区32～39 |
| 模块参数 | 无专门的 `module_params` 收集规则 | `*(module_params)` 收入普通 `text` | 独立输出段，`0x00614000`起，容量0x4000，扇区40～47 |
| 模块段保留 | 无对应KEEP | 沿用正常引用和垃圾回收规则 | 使用 `KEEP`，避免演示段被 `--gc-sections` 删除 |
| 链接断言 | 无本例专用断言 | 未新增 | 代码段不超过0x4000；参数段必须8字节；APP加载镜像末地址不超过0x00610000 |
| RAM及启动搬运 | M0放ramfunc，LS0放data/bss，加载镜像在普通Flash | 相同 | 相同，加载镜像限制在APP Flash内 |
| USER OTP | 不包含OTP段 | 不包含OTP段 | 主脚本包含 `haawking-drivers/ldscripts/DCSM.ld`，默认ELF含APP+OTP；普通HEX移除OTP，_dcsm.hex保留 |

ex01/ex02没有将剩余的 `0x00618000`～`0x0063FFFF` 分配给APP，因此普通APP可用空间确实比原版小；APP增长超过边界时应调整布局，而不是让其进入模块区。

链接脚本只安排地址，**不能设置Flash的Zone归属或使能保护**。ex01/ex02模块区域的Zone1归属由单独核对并人工准备的OTP决定；没有相应OTP时，这些地址只是普通Flash位置。

## 保持不变的内容

| 项目 | 数值或行为 |
| --- | --- |
| RAMSTACK | `0x00000000`，长度0x800；栈顶符号 `__global_sp$ = 0x7F8` |
| RAMM0 | `0x00000800`，长度0x3800；承载ramfunc |
| RAMLS0 | `0x00010000`，长度0x4000；承载data/bss |
| data/bss收集及对齐 | 沿用模板，包括global pointer和16字节对齐的端点符号 |
| 运行/加载符号 | `__RAMFUNC_*`、`__DATA_*`、`__BSS_*`、`__FLASH_RAMFUNC_*`、`__FLASH_DATA_*`保留模板协议 |
| IER / IFR映射 | `0x00400C10` / `0x00400D10`，NOLOAD |
| 外设与BootROM映射 | 继续包含 `Peripheral.ld`、`BootROM.ld` |

## 完整文本差异

以下为清理前逐行比较所得，忽略文件换行形式。版权头保留，没有另造一份完整原版脚本。

### ex00与原版

```diff
--- vendor/HXS320F2800137_EDE_link_FLASH.ld
+++ ex00_base_system/haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld
@@ -120,6 +120,8 @@
     /* Text segment */
     text ALIGN(0x10):
     {
+        *(module_code)
+        *(module_params)
         *(.text.init)
         *(.text)
         *(.text*)
```

### ex01 / ex02与原版

两例差异相同，下面以ex01为代表。

```diff
--- vendor/HXS320F2800137_EDE_link_FLASH.ld
+++ ex01_dcsm_secure_flash/haawking-drivers/ldscripts/HXS320F2800137_EDE_link_FLASH.ld
@@ -54,7 +54,9 @@
     RAMM0(rwx):                    ORIGIN = 0x00000800, LENGTH = 0x00003800     /* Internal RAM M0 */
     RAMLS0(rwx):                   ORIGIN = 0x00010000, LENGTH = 0x00004000     /* Internal RAM LS0 */
     BEGIN(rwx):                    ORIGIN = 0x00600000, LENGTH = 0x00000010     /* Code Entry */
-    FLASH(rwx):                    ORIGIN = 0x00600010, LENGTH = 0x0003FFF0     /* Internal Flash Bank0 */
+    FLASH(rwx):                    ORIGIN = 0x00600010, LENGTH = 0x0000FFF0     /* Internal Flash Bank0 */
+    MODULE_CODE(rx):               ORIGIN = 0x00610000, LENGTH = 0x00004000
+    MODULE_PARAMS(r):              ORIGIN = 0x00614000, LENGTH = 0x00004000
     IER_REGISTER_FILE(rw):         ORIGIN = 0x00400C10, LENGTH = 0x00000004     /* IER Regitser */
     IFR_REGISTER_FILE(rw):         ORIGIN = 0x00400D10, LENGTH = 0x00000004     /* IFR Regitser */
 }
@@ -156,6 +158,17 @@
         *(.ifr_register)
     } > IFR_REGISTER_FILE
 
+    module_code 0x00610000 : ALIGN(0x10)
+    {
+        KEEP(*(module_code))
+    } > MODULE_CODE
+    module_params 0x00614000 : ALIGN(0x10)
+    {
+        KEEP(*(module_params))
+    } > MODULE_PARAMS
+    ASSERT(SIZEOF(module_code) <= 0x4000, "Module code overflows sector32-39")
+    ASSERT(SIZEOF(module_params) == 8, "Demo parameters must be two uint32_t words")
+    ASSERT(__FLASH_DATA_END <= 0x00610000, "APP load image reaches secure Flash")
     /* End */
     _end = .;
 }
```

## 清理后的文件

每个工程将修改后的 `HXS320F2800137_EDE_link_FLASH.ld` 放回 `haawking-drivers/ldscripts/`，作为唯一Flash主脚本。该文件使用本文说明的应用布局，原版副本不保留，未使用的RAM主脚本仍删除。

`haawking-drivers/ldscripts/Peripheral.ld` 和 `BootROM.ld` 是应用脚本正在包含的地址映射依赖，继续保留且内容不改。ex01/ex02默认APP主脚本现包含DCSM.ld，使启用的OTP段进入默认ELF；普通HEX转换时移除这些段。

IDE `.cproject` 删除原版Flash文件的冗余排除项，逐文件排除 `Security/hx280013x_dcsm_z1otp.S` 和 `Security/hx280013x_dcsm_z2otp.S`；链接器仅需 `../haawking-drivers/ldscripts` 搜索路径来解析Flash主脚本及两个映射依赖；C编译器的 `../src` 头文件搜索路径保留。工程仍使用FLASH配置，本次不提供RAM运行版本。28002x工程不在此次删除范围内。

清理后验证：三个工程由IDE重新生成构建文件，并分别强制重编译通过；应用主脚本与清理前SHA-256一致，两个映射依赖内容一致。map/符号检查确认RAM布局、APP加载镜像和模块地址保持预期；APP HEX校验通过且不包含OTP。本次未连接硬件。

2026-10-24排版整理：Flash主脚本使用与28002x相同的 `. = 地址;` 加多行段块格式，安全Flash区域命名统一为 `FLASH_ZONE1_CODE` / `FLASH_ZONE1_PARAMS`。运行/加载地址和段收集逻辑不变。独立OTP链接脚本统一命名为 `DCSM.ld` 并放在ldscripts目录，使用显式MEMORY / SECTIONS，现按开发者要求被APP主脚本包含，启用的OTP段进入默认ELF。
