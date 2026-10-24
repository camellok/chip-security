/*
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd.
 * Public demonstration parameters; not production secrets.
 */
#include "driverlib.h"
#include "product_module.h"

// Volatile keeps real Flash reads in this memory-access demonstration.
CODE_SECTION("module_params")
const volatile uint32_t g_module_params[2] = {3U, 7U};

// NOLOAD state is initialized only by Zone1 code, never by APP startup.
CODE_SECTION("module_work")
static volatile uint32_t s_module_work;

CODE_SECTION("module_code")
__attribute__((noinline)) void ProductModule_Init(void)
{
    s_module_work = 0U;
}

CODE_SECTION("module_code")
__attribute__((noinline)) uint32_t ProductModule_Process(uint32_t input)
{
    s_module_work = input * g_module_params[0] + g_module_params[1];
    return s_module_work;
}
