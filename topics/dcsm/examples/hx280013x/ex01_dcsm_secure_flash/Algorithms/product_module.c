/*
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd.
 * Public demonstration parameters; not production secrets.
 */
#include "driverlib.h"
#include "product_module.h"

// Volatile keeps real Flash reads in this memory-access demonstration.
CODE_SECTION("module_params")
const volatile uint32_t g_module_params[2] = {3U, 7U};

CODE_SECTION("module_code")
uint32_t ProductModule_Process(uint32_t input)
{
    return input * g_module_params[0] + g_module_params[1];
}
