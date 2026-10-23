//###########################################################################
//
// FILE:   pin_map.h
//
// TITLE:  Definitions of pin mux info for gpio.c.
//
//###########################################################################

#ifndef __PIN_MAP_H__
#define __PIN_MAP_H__

//*****************************************************************************
// 0x00000003 = MUX register value
// 0x0000000C = GMUX register value
// 0x0000FF00 = Shift amount within mux registers
// 0xFFFF0000 = Offset of MUX register
//*****************************************************************************


#define GPIO_0_GPIO0                    0x000C0000U
#define GPIO_0_EPWM1_A                  0x000C0001U
#define GPIO_0_OUTPUTXBAR7              0x000C0003U
#define GPIO_0_SCIA_RX                  0x000C0005U
#define GPIO_0_I2CA_SDA                 0x000C0006U
#define GPIO_0_SPIA_STE                 0x000C0007U
#define GPIO_0_EQEP1_INDEX              0x000C000DU
#define GPIO_0_EPWM3_A                  0x000C000FU

#define GPIO_1_GPIO1                    0x000C0200U
#define GPIO_1_EPWM1_B                  0x000C0201U
#define GPIO_1_SCIA_TX                  0x000C0205U
#define GPIO_1_I2CA_SCL                 0x000C0206U
#define GPIO_1_SPIA_SOMI                0x000C0207U
#define GPIO_1_EQEP1_STROBE             0x000C0209U
#define GPIO_1_EPWM3_B                  0x000C020FU

#define GPIO_2_GPIO2                    0x000C0400U
#define GPIO_2_EPWM2_A                  0x000C0401U
#define GPIO_2_OUTPUTXBAR1              0x000C0405U
#define GPIO_2_SPIA_SIMO                0x000C0407U
#define GPIO_2_SCIA_TX                  0x000C0409U
#define GPIO_2_I2CA_SDA                 0x000C040BU
#define GPIO_2_EPWM4_A                  0x000C040FU

#define GPIO_3_GPIO3                    0x000C0600U
#define GPIO_3_EPWM2_B                  0x000C0601U
#define GPIO_3_OUTPUTXBAR2              0x000C0602U
#define GPIO_3_SPIA_CLK                 0x000C0607U
#define GPIO_3_SCIA_RX                  0x000C0609U
#define GPIO_3_I2CA_SCL                 0x000C060BU
#define GPIO_3_EPWM4_B                  0x000C060FU

#define GPIO_4_GPIO4                    0x000C0800U
#define GPIO_4_EPWM3_A                  0x000C0801U
#define GPIO_4_I2CA_SCL                 0x000C0802U
#define GPIO_4_OUTPUTXBAR3              0x000C0805U
#define GPIO_4_SPIA_SOMI                0x000C080EU
#define GPIO_4_EPWM1_A                  0x000C080FU

#define GPIO_5_GPIO5                    0x000C0A00U
#define GPIO_5_EPWM3_B                  0x000C0A01U
#define GPIO_5_I2CA_SDA                 0x000C0A02U
#define GPIO_5_OUTPUTXBAR3              0x000C0A03U
#define GPIO_5_SPIA_STE                 0x000C0A07U
#define GPIO_5_SCIA_RX                  0x000C0A0BU
#define GPIO_5_EPWM1_B                  0x000C0A0FU

#define GPIO_6_GPIO6                    0x000C0C00U
#define GPIO_6_EPWM4_A                  0x000C0C01U
#define GPIO_6_OUTPUTXBAR4              0x000C0C02U
#define GPIO_6_SYNCOUT                  0x000C0C03U
#define GPIO_6_EQEP1_A                  0x000C0C05U
#define GPIO_6_EPWM2_A                  0x000C0C0FU

#define GPIO_7_GPIO7                    0x000C0E00U
#define GPIO_7_EPWM4_B                  0x000C0E01U
#define GPIO_7_EPWM2_A                  0x000C0E02U
#define GPIO_7_OUTPUTXBAR5              0x000C0E03U
#define GPIO_7_EQEP1_B                  0x000C0E05U
#define GPIO_7_SPIA_SIMO                0x000C0E07U
#define GPIO_7_SCIA_TX                  0x000C0E0BU
#define GPIO_7_EPWM2_B                  0x000C0E0FU

#define GPIO_8_GPIO8                    0x000C1000U
#define GPIO_8_EPWM5_A                  0x000C1001U
#define GPIO_8_ADCSOCAO                 0x000C1003U
#define GPIO_8_EQEP1_STROBE             0x000C1005U
#define GPIO_8_SCIA_TX                  0x000C1006U
#define GPIO_8_SPIA_SIMO                0x000C1007U
#define GPIO_8_I2CA_SCL                 0x000C1009U

#define GPIO_9_GPIO9                    0x000C1200U
#define GPIO_9_EPWM5_B                  0x000C1201U
#define GPIO_9_SCIB_TX                  0x000C1202U
#define GPIO_9_OUTPUTXBAR6              0x000C1203U
#define GPIO_9_EQEP1_INDEX              0x000C1205U
#define GPIO_9_SCIA_RX                  0x000C1206U
#define GPIO_9_SPIA_CLK                 0x000C1207U
#define GPIO_9_I2CA_SCL                 0x000C120EU

#define GPIO_10_GPIO10                  0x000C1400U
#define GPIO_10_EPWM6_A                 0x000C1401U
#define GPIO_10_ADCSOCBO                0x000C1403U
#define GPIO_10_EQEP1_A                 0x000C1405U
#define GPIO_10_SCIB_TX                 0x000C1406U
#define GPIO_10_SPIA_SOMI               0x000C1407U
#define GPIO_10_I2CA_SDA                0x000C1409U

#define GPIO_11_GPIO11                  0x000C1600U
#define GPIO_11_EPWM6_B                 0x000C1601U
#define GPIO_11_OUTPUTXBAR7             0x000C1603U
#define GPIO_11_EQEP1_B                 0x000C1605U
#define GPIO_11_SCIB_RX                 0x000C1606U
#define GPIO_11_SPIA_STE                0x000C1607U
#define GPIO_11_SPIA_SIMO               0x000C160DU

#define GPIO_12_GPIO12                  0x000C1800U
#define GPIO_12_EPWM7_A                 0x000C1801U
#define GPIO_12_EQEP1_STROBE            0x000C1805U
#define GPIO_12_SCIB_TX                 0x000C1806U
#define GPIO_12_SPIA_CLK                0x000C180BU

#define GPIO_13_GPIO13                  0x000C1A00U
#define GPIO_13_EPWM7_B                 0x000C1A01U
#define GPIO_13_EQEP1_INDEX             0x000C1A05U
#define GPIO_13_SCIB_RX                 0x000C1A06U
#define GPIO_13_SPIA_SOMI               0x000C1A0BU

#define GPIO_16_GPIO16                  0x00100000U
#define GPIO_16_SPIA_SIMO               0x00100001U
#define GPIO_16_OUTPUTXBAR7             0x00100003U
#define GPIO_16_EPWM5_A                 0x00100005U
#define GPIO_16_SCIA_TX                 0x00100006U
#define GPIO_16_EQEP1_STROBE            0x00100009U
#define GPIO_16_XCLKOUT                 0x0010000BU

#define GPIO_17_GPIO17                  0x00100200U
#define GPIO_17_SPIA_SOMI               0x00100201U
#define GPIO_17_OUTPUTXBAR8             0x00100203U
#define GPIO_17_EPWM5_B                 0x00100205U
#define GPIO_17_SCIA_RX                 0x00100206U
#define GPIO_17_EQEP1_INDEX             0x00100209U
#define GPIO_17_EPWM6_A                 0x0010020EU

#define GPIO_18_GPIO18                  0x00100400U
#define GPIO_18_SPIA_CLK                0x00100401U
#define GPIO_18_SCIB_TX                 0x00100402U
#define GPIO_18_EPWM6_A                 0x00100405U
#define GPIO_18_I2CA_SCL                0x00100406U
#define GPIO_18_XCLKOUT                 0x0010040BU

#define GPIO_19_GPIO19                  0x00100600U
#define GPIO_19_SPIA_STE                0x00100601U
#define GPIO_19_SCIB_RX                 0x00100602U
#define GPIO_19_EPWM6_B                 0x00100605U
#define GPIO_19_I2CA_SDA                0x00100606U

#define GPIO_20_GPIO20                  0x00100800U
#define GPIO_20_EQEP1_A                 0x00100801U
#define GPIO_20_SPIA_SIMO               0x00100806U
#define GPIO_20_I2CA_SCL                0x0010080BU
#define GPIO_20_SCIC_TX                 0x0010080FU

#define GPIO_21_GPIO21                  0x00100A00U
#define GPIO_21_EQEP1_B                 0x00100A01U
#define GPIO_21_SPIA_SOMI               0x00100A06U
#define GPIO_21_I2CA_SDA                0x00100A0BU
#define GPIO_21_SCIC_RX                 0x00100A0FU

#define GPIO_22_GPIO22                  0x00100C00U
#define GPIO_22_EQEP1_STROBE            0x00100C01U
#define GPIO_22_SCIB_TX                 0x00100C03U
#define GPIO_22_SCIC_TX                 0x00100C09U
#define GPIO_22_EPWM4_A                 0x00100C0EU

#define GPIO_23_GPIO23                  0x00100E00U
#define GPIO_23_EQEP1_INDEX             0x00100E01U
#define GPIO_23_SCIB_RX                 0x00100E03U
#define GPIO_23_SCIC_RX                 0x00100E09U
#define GPIO_23_EPWM4_B                 0x00100E0EU

#define GPIO_24_GPIO24                  0x00101000U
#define GPIO_24_OUTPUTXBAR1             0x00101001U
#define GPIO_24_SPIA_STE                0x00101003U
#define GPIO_24_EPWM4_A                 0x00101005U
#define GPIO_24_SPIA_SIMO               0x00101006U
#define GPIO_24_SCIA_TX                 0x0010100BU
#define GPIO_24_ERRORSTS                0x0010100DU

#define GPIO_28_GPIO28                  0x00101800U
#define GPIO_28_SCIA_RX                 0x00101801U
#define GPIO_28_EPWM7_A                 0x00101803U
#define GPIO_28_OUTPUTXBAR5             0x00101805U
#define GPIO_28_EQEP1_A                 0x00101806U
#define GPIO_28_SCIC_TX                 0x0010180AU
#define GPIO_28_SPIA_CLK                0x0010180BU
#define GPIO_28_ERRORSTS                0x0010180DU
#define GPIO_28_I2CA_SDA                0x0010180EU

#define GPIO_29_GPIO29                  0x00101A00U
#define GPIO_29_SCIA_TX                 0x00101A01U
#define GPIO_29_EPWM7_B                 0x00101A03U
#define GPIO_29_OUTPUTXBAR6             0x00101A05U
#define GPIO_29_EQEP1_B                 0x00101A06U
#define GPIO_29_SCIC_RX                 0x00101A0AU
#define GPIO_29_SPIA_STE                0x00101A0BU
#define GPIO_29_ERRORSTS                0x00101A0DU
#define GPIO_29_I2CA_SCL                0x00101A0EU

#define GPIO_32_GPIO32                  0x008C0000U
#define GPIO_32_I2CA_SDA                0x008C0001U
#define GPIO_32_EQEP1_INDEX             0x008C0002U
#define GPIO_32_SPIA_CLK                0x008C0003U
#define GPIO_32_EPWM4_B                 0x008C0005U
#define GPIO_32_SCIC_TX                 0x008C0006U
#define GPIO_32_ADCSOCBO                0x008C000DU

#define GPIO_33_GPIO33                  0x008C0200U
#define GPIO_33_I2CA_SCL                0x008C0201U
#define GPIO_33_OUTPUTXBAR4             0x008C0205U
#define GPIO_33_SCIC_RX                 0x008C0206U
#define GPIO_33_ADCSOCAO                0x008C020DU

#define GPIO_35_GPIO35                  0x008C0600U
#define GPIO_35_SCIA_RX                 0x008C0601U
#define GPIO_35_SPIA_SOMI               0x008C0602U
#define GPIO_35_I2CA_SDA                0x008C0603U
#define GPIO_35_SCIC_RX                 0x008C0607U
#define GPIO_35_EQEP1_A                 0x008C0609U
#define GPIO_35_EPWM5_B                 0x008C060BU
#define GPIO_35_TDI                     0x008C060FU

#define GPIO_37_GPIO37                  0x008C0A00U
#define GPIO_37_OUTPUTXBAR2             0x008C0A01U
#define GPIO_37_SPIA_STE                0x008C0A02U
#define GPIO_37_I2CA_SCL                0x008C0A03U
#define GPIO_37_SCIA_TX                 0x008C0A05U
#define GPIO_37_SCIC_TX                 0x008C0A07U
#define GPIO_37_EQEP1_B                 0x008C0A09U
#define GPIO_37_EPWM5_A                 0x008C0A0BU
#define GPIO_37_TDO                     0x008C0A0FU

#define GPIO_39_GPIO39                  0x008C0E00U
#define GPIO_39_SYNCOUT                 0x008C0E0DU
#define GPIO_39_EQEP1_INDEX             0x008C0E0EU

#define GPIO_40_GPIO40                  0x008C1000U
#define GPIO_40_EPWM2_B                 0x008C1005U
#define GPIO_40_SCIB_TX                 0x008C1009U
#define GPIO_40_EQEP1_A                 0x008C100AU

#define GPIO_41_GPIO41                  0x008C1200U
#define GPIO_41_EPWM7_A                 0x008C1201U
#define GPIO_41_EPWM2_A                 0x008C1205U
#define GPIO_41_SCIB_RX                 0x008C1209U
#define GPIO_41_EQEP1_B                 0x008C120AU

#define GPIO_224_GPIO224                0x038C0000U
#define GPIO_224_OUTPUTXBAR3            0x038C0005U
#define GPIO_224_SPIA_SIMO              0x038C0006U
#define GPIO_224_EPWM1_A                0x038C0009U
#define GPIO_224_EQEP1_A                0x038C000BU
#define GPIO_224_SCIC_TX                0x038C000EU

#define GPIO_225_GPIO225                0x038C0200U

#define GPIO_226_GPIO226                0x038C0400U
#define GPIO_226_EPWM6_A                0x038C0405U
#define GPIO_226_SPIA_CLK               0x038C0406U
#define GPIO_226_EPWM1_B                0x038C0409U
#define GPIO_226_EQEP1_STROBE           0x038C040BU
#define GPIO_226_SCIC_RX                0x038C040EU

#define GPIO_227_GPIO227                0x038C0600U
#define GPIO_227_I2CA_SCL               0x038C0601U
#define GPIO_227_EPWM3_A                0x038C0603U
#define GPIO_227_OUTPUTXBAR1            0x038C0605U
#define GPIO_227_EPWM2_B                0x038C0606U

#define GPIO_228_GPIO228                0x038C0800U
#define GPIO_228_ADCSOCAO               0x038C0803U
#define GPIO_228_SPIA_SOMI              0x038C0806U
#define GPIO_228_EPWM2_B                0x038C0809U
#define GPIO_228_EQEP1_B                0x038C080BU

#define GPIO_230_GPIO230                0x038C0C00U
//#define GPIO_230_I2CA_SDA               0x038C0C01U
#define GPIO_230_EPWM3_B                0x038C0C03U
#define GPIO_230_EPWM2_A                0x038C0C06U
#define GPIO_230_I2CA_SDA               0x038C0C07U

#define GPIO_231_GPIO231                0x038C0E00U

#define GPIO_232_GPIO232                0x038C1000U

#define GPIO_233_GPIO233                0x038C1200U

#define GPIO_237_GPIO237                0x038C1A00U

#define GPIO_238_GPIO238                0x038C1C00U

#define GPIO_239_GPIO239                0x038C1E00U

#define GPIO_241_GPIO241                0x03900200U

#define GPIO_242_GPIO242                0x03900400U
#define GPIO_242_OUTPUTXBAR2            0x03900405U
#define GPIO_242_SPIA_STE               0x03900406U
#define GPIO_242_EPWM4_A                0x03900409U
#define GPIO_242_EQEP1_INDEX            0x0390040BU

#define GPIO_244_GPIO244                0x03900800U

#define GPIO_245_GPIO245                0x03900A00U

#endif // PIN_MAP_H
