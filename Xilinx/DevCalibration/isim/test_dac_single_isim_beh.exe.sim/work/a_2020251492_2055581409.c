/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/Users/Sushant/Documents/GitHub/NoiseCancelingHeadphones/Xilinx/DevCalibration/test_dac_single.vhd";
extern char *IEEE_P_1242562249;

unsigned char ieee_p_1242562249_sub_319130236_1035706684(char *, unsigned char , unsigned char );
unsigned char ieee_p_1242562249_sub_337943598_1035706684(char *, char *, char *, char *, char *);


static void work_a_2020251492_2055581409_p_0(char *t0)
{
    char t17[16];
    char t25[16];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    int64 t9;
    unsigned int t10;
    int t11;
    unsigned int t12;
    unsigned int t13;
    int t14;
    unsigned int t15;
    unsigned int t16;
    int t18;
    unsigned int t19;
    unsigned char t20;
    char *t21;
    unsigned char t22;
    unsigned char t23;
    char *t24;
    char *t26;
    char *t27;
    unsigned char t28;
    char *t29;
    unsigned char t30;
    unsigned char t31;

LAB0:    t1 = (t0 + 4432U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(78, ng0);
    t2 = (t0 + 5064);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(79, ng0);
    t2 = (t0 + 9767);
    t4 = (t0 + 5128);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 8U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(80, ng0);
    t2 = (t0 + 9775);
    t4 = (t0 + 5192);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 8U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(81, ng0);
    t2 = (t0 + 5256);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(82, ng0);
    t2 = (t0 + 5320);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(83, ng0);
    t2 = (t0 + 5384);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(84, ng0);
    t2 = (t0 + 5448);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(85, ng0);
    t9 = (95 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(87, ng0);
    t2 = (t0 + 5064);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(88, ng0);
    t9 = (5 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(92, ng0);
    t2 = (t0 + 2632U);
    t3 = *((char **)t2);
    t2 = (t0 + 9604U);
    t4 = xsi_get_transient_memory(8U);
    memset(t4, 0, 8U);
    t5 = t4;
    if (1 == 1)
        goto LAB14;

LAB15:    t10 = 7;

LAB16:    t11 = (t10 - 0);
    t12 = (t11 * 1);
    t13 = (1U * t12);
    t6 = (t5 + t13);
    t14 = (7 - 0);
    t15 = (t14 * 1);
    t15 = (t15 + 1);
    t16 = (1U * t15);
    memset(t6, (unsigned char)2, t16);
    t7 = (t17 + 0U);
    t8 = (t7 + 0U);
    *((int *)t8) = 0;
    t8 = (t7 + 4U);
    *((int *)t8) = 7;
    t8 = (t7 + 8U);
    *((int *)t8) = 1;
    t18 = (7 - 0);
    t19 = (t18 * 1);
    t19 = (t19 + 1);
    t8 = (t7 + 12U);
    *((unsigned int *)t8) = t19;
    t20 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t3, t2, t4, t17);
    if (t20 == 0)
        goto LAB12;

LAB13:    xsi_set_current_line(95, ng0);
    t2 = (t0 + 2472U);
    t3 = *((char **)t2);
    t2 = (t0 + 9588U);
    t4 = xsi_get_transient_memory(11U);
    memset(t4, 0, 11U);
    t5 = t4;
    if (1 == 1)
        goto LAB19;

LAB20:    t10 = 10;

LAB21:    t11 = (t10 - 0);
    t12 = (t11 * 1);
    t13 = (1U * t12);
    t6 = (t5 + t13);
    t14 = (10 - 0);
    t15 = (t14 * 1);
    t15 = (t15 + 1);
    t16 = (1U * t15);
    memset(t6, (unsigned char)2, t16);
    t7 = (t17 + 0U);
    t8 = (t7 + 0U);
    *((int *)t8) = 0;
    t8 = (t7 + 4U);
    *((int *)t8) = 10;
    t8 = (t7 + 8U);
    *((int *)t8) = 1;
    t18 = (10 - 0);
    t19 = (t18 * 1);
    t19 = (t19 + 1);
    t8 = (t7 + 12U);
    *((unsigned int *)t8) = t19;
    t20 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t3, t2, t4, t17);
    if (t20 == 0)
        goto LAB17;

LAB18:    xsi_set_current_line(98, ng0);
    t2 = (t0 + 2312U);
    t3 = *((char **)t2);
    t20 = *((unsigned char *)t3);
    t22 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t20, (unsigned char)2);
    if (t22 == 0)
        goto LAB22;

LAB23:    xsi_set_current_line(103, ng0);
    t2 = (t0 + 5448);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(104, ng0);
    t9 = (100 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB26:    *((char **)t1) = &&LAB27;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB12:    t8 = (t0 + 9783);
    xsi_report(t8, 32U, (unsigned char)2);
    goto LAB13;

LAB14:    t10 = 0;
    goto LAB16;

LAB17:    t8 = (t0 + 9815);
    xsi_report(t8, 37U, (unsigned char)2);
    goto LAB18;

LAB19:    t10 = 0;
    goto LAB21;

LAB22:    t2 = (t0 + 9852);
    xsi_report(t2, 28U, (unsigned char)2);
    goto LAB23;

LAB24:    xsi_set_current_line(105, ng0);
    t2 = (t0 + 2312U);
    t3 = *((char **)t2);
    t20 = *((unsigned char *)t3);
    t22 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t20, (unsigned char)3);
    if (t22 == 0)
        goto LAB28;

LAB29:    xsi_set_current_line(110, ng0);
    t2 = (t0 + 5320);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(111, ng0);
    t9 = (95 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB32:    *((char **)t1) = &&LAB33;
    goto LAB1;

LAB25:    goto LAB24;

LAB27:    goto LAB25;

LAB28:    t2 = (t0 + 9880);
    xsi_report(t2, 27U, (unsigned char)2);
    goto LAB29;

LAB30:    xsi_set_current_line(112, ng0);
    t2 = (t0 + 5320);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(113, ng0);
    t9 = (5 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB36:    *((char **)t1) = &&LAB37;
    goto LAB1;

LAB31:    goto LAB30;

LAB33:    goto LAB31;

LAB34:    xsi_set_current_line(116, ng0);
    t2 = (t0 + 5384);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(117, ng0);
    t9 = (95 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB40:    *((char **)t1) = &&LAB41;
    goto LAB1;

LAB35:    goto LAB34;

LAB37:    goto LAB35;

LAB38:    xsi_set_current_line(118, ng0);
    t2 = (t0 + 5384);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(119, ng0);
    t9 = (5 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB44:    *((char **)t1) = &&LAB45;
    goto LAB1;

LAB39:    goto LAB38;

LAB41:    goto LAB39;

LAB42:    xsi_set_current_line(120, ng0);
    t2 = (t0 + 2632U);
    t3 = *((char **)t2);
    t2 = (t0 + 9604U);
    t4 = (t0 + 9907);
    t6 = (t17 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 0;
    t7 = (t6 + 4U);
    *((int *)t7) = 7;
    t7 = (t6 + 8U);
    *((int *)t7) = 1;
    t11 = (7 - 0);
    t10 = (t11 * 1);
    t10 = (t10 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t10;
    t23 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t3, t2, t4, t17);
    if (t23 == 1)
        goto LAB51;

LAB52:    t22 = (unsigned char)0;

LAB53:    if (t22 == 1)
        goto LAB48;

LAB49:    t20 = (unsigned char)0;

LAB50:    if (t20 == 0)
        goto LAB46;

LAB47:    xsi_set_current_line(126, ng0);
    t2 = (t0 + 5256);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(127, ng0);
    t2 = (t0 + 5320);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(128, ng0);
    t9 = (95 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB56:    *((char **)t1) = &&LAB57;
    goto LAB1;

LAB43:    goto LAB42;

LAB45:    goto LAB43;

LAB46:    t27 = (t0 + 9926);
    xsi_report(t27, 26U, (unsigned char)2);
    goto LAB47;

LAB48:    t27 = (t0 + 2312U);
    t29 = *((char **)t27);
    t30 = *((unsigned char *)t29);
    t31 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t30, (unsigned char)3);
    t20 = t31;
    goto LAB50;

LAB51:    t7 = (t0 + 2472U);
    t8 = *((char **)t7);
    t7 = (t0 + 9588U);
    t21 = (t0 + 9915);
    t26 = (t25 + 0U);
    t27 = (t26 + 0U);
    *((int *)t27) = 0;
    t27 = (t26 + 4U);
    *((int *)t27) = 10;
    t27 = (t26 + 8U);
    *((int *)t27) = 1;
    t14 = (10 - 0);
    t10 = (t14 * 1);
    t10 = (t10 + 1);
    t27 = (t26 + 12U);
    *((unsigned int *)t27) = t10;
    t28 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t8, t7, t21, t25);
    t22 = t28;
    goto LAB53;

LAB54:    xsi_set_current_line(129, ng0);
    t2 = (t0 + 5320);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(130, ng0);
    t9 = (5 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB60:    *((char **)t1) = &&LAB61;
    goto LAB1;

LAB55:    goto LAB54;

LAB57:    goto LAB55;

LAB58:    xsi_set_current_line(131, ng0);
    t2 = (t0 + 2632U);
    t3 = *((char **)t2);
    t2 = (t0 + 9604U);
    t4 = (t0 + 9952);
    t6 = (t17 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 0;
    t7 = (t6 + 4U);
    *((int *)t7) = 7;
    t7 = (t6 + 8U);
    *((int *)t7) = 1;
    t11 = (7 - 0);
    t10 = (t11 * 1);
    t10 = (t10 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t10;
    t23 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t3, t2, t4, t17);
    if (t23 == 1)
        goto LAB67;

LAB68:    t22 = (unsigned char)0;

LAB69:    if (t22 == 1)
        goto LAB64;

LAB65:    t20 = (unsigned char)0;

LAB66:    if (t20 == 0)
        goto LAB62;

LAB63:    xsi_set_current_line(144, ng0);
    t2 = (t0 + 5384);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(145, ng0);
    t9 = (100 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB72:    *((char **)t1) = &&LAB73;
    goto LAB1;

LAB59:    goto LAB58;

LAB61:    goto LAB59;

LAB62:    t27 = (t0 + 9971);
    xsi_report(t27, 26U, (unsigned char)2);
    goto LAB63;

LAB64:    t27 = (t0 + 2312U);
    t29 = *((char **)t27);
    t30 = *((unsigned char *)t29);
    t31 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t30, (unsigned char)3);
    t20 = t31;
    goto LAB66;

LAB67:    t7 = (t0 + 2472U);
    t8 = *((char **)t7);
    t7 = (t0 + 9588U);
    t21 = (t0 + 9960);
    t26 = (t25 + 0U);
    t27 = (t26 + 0U);
    *((int *)t27) = 0;
    t27 = (t26 + 4U);
    *((int *)t27) = 10;
    t27 = (t26 + 8U);
    *((int *)t27) = 1;
    t14 = (10 - 0);
    t10 = (t14 * 1);
    t10 = (t10 + 1);
    t27 = (t26 + 12U);
    *((unsigned int *)t27) = t10;
    t28 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t8, t7, t21, t25);
    t22 = t28;
    goto LAB69;

LAB70:    xsi_set_current_line(146, ng0);
    t2 = (t0 + 2632U);
    t3 = *((char **)t2);
    t2 = (t0 + 9604U);
    t4 = (t0 + 9997);
    t6 = (t17 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 0;
    t7 = (t6 + 4U);
    *((int *)t7) = 7;
    t7 = (t6 + 8U);
    *((int *)t7) = 1;
    t11 = (7 - 0);
    t10 = (t11 * 1);
    t10 = (t10 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t10;
    t23 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t3, t2, t4, t17);
    if (t23 == 1)
        goto LAB79;

LAB80:    t22 = (unsigned char)0;

LAB81:    if (t22 == 1)
        goto LAB76;

LAB77:    t20 = (unsigned char)0;

LAB78:    if (t20 == 0)
        goto LAB74;

LAB75:    xsi_set_current_line(149, ng0);
    t9 = (100 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB84:    *((char **)t1) = &&LAB85;
    goto LAB1;

LAB71:    goto LAB70;

LAB73:    goto LAB71;

LAB74:    t27 = (t0 + 10016);
    xsi_report(t27, 58U, (unsigned char)2);
    goto LAB75;

LAB76:    t27 = (t0 + 2312U);
    t29 = *((char **)t27);
    t30 = *((unsigned char *)t29);
    t31 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t30, (unsigned char)2);
    t20 = t31;
    goto LAB78;

LAB79:    t7 = (t0 + 2472U);
    t8 = *((char **)t7);
    t7 = (t0 + 9588U);
    t21 = (t0 + 10005);
    t26 = (t25 + 0U);
    t27 = (t26 + 0U);
    *((int *)t27) = 0;
    t27 = (t26 + 4U);
    *((int *)t27) = 10;
    t27 = (t26 + 8U);
    *((int *)t27) = 1;
    t14 = (10 - 0);
    t10 = (t14 * 1);
    t10 = (t10 + 1);
    t27 = (t26 + 12U);
    *((unsigned int *)t27) = t10;
    t28 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t8, t7, t21, t25);
    t22 = t28;
    goto LAB81;

LAB82:    xsi_set_current_line(150, ng0);
    t2 = (t0 + 2632U);
    t3 = *((char **)t2);
    t2 = (t0 + 9604U);
    t4 = (t0 + 10074);
    t6 = (t17 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 0;
    t7 = (t6 + 4U);
    *((int *)t7) = 7;
    t7 = (t6 + 8U);
    *((int *)t7) = 1;
    t11 = (7 - 0);
    t10 = (t11 * 1);
    t10 = (t10 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t10;
    t23 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t3, t2, t4, t17);
    if (t23 == 1)
        goto LAB91;

LAB92:    t22 = (unsigned char)0;

LAB93:    if (t22 == 1)
        goto LAB88;

LAB89:    t20 = (unsigned char)0;

LAB90:    if (t20 == 0)
        goto LAB86;

LAB87:    xsi_set_current_line(155, ng0);
    t2 = (t0 + 5320);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(156, ng0);
    t2 = (t0 + 5256);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(157, ng0);
    t2 = (t0 + 3448U);
    t3 = *((char **)t2);
    t2 = (t0 + 5192);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t3, 8U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(158, ng0);
    t9 = (100 * 1000LL);
    t2 = (t0 + 4240);
    xsi_process_wait(t2, t9);

LAB96:    *((char **)t1) = &&LAB97;
    goto LAB1;

LAB83:    goto LAB82;

LAB85:    goto LAB83;

LAB86:    t27 = (t0 + 10093);
    xsi_report(t27, 59U, (unsigned char)2);
    goto LAB87;

LAB88:    t27 = (t0 + 2312U);
    t29 = *((char **)t27);
    t30 = *((unsigned char *)t29);
    t31 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t30, (unsigned char)2);
    t20 = t31;
    goto LAB90;

LAB91:    t7 = (t0 + 2472U);
    t8 = *((char **)t7);
    t7 = (t0 + 9588U);
    t21 = (t0 + 10082);
    t26 = (t25 + 0U);
    t27 = (t26 + 0U);
    *((int *)t27) = 0;
    t27 = (t26 + 4U);
    *((int *)t27) = 10;
    t27 = (t26 + 8U);
    *((int *)t27) = 1;
    t14 = (10 - 0);
    t10 = (t14 * 1);
    t10 = (t10 + 1);
    t27 = (t26 + 12U);
    *((unsigned int *)t27) = t10;
    t28 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t8, t7, t21, t25);
    t22 = t28;
    goto LAB93;

LAB94:    xsi_set_current_line(159, ng0);
    t2 = (t0 + 2632U);
    t3 = *((char **)t2);
    t2 = (t0 + 9604U);
    t4 = (t0 + 2152U);
    t5 = *((char **)t4);
    t4 = (t0 + 9572U);
    t23 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t3, t2, t5, t4);
    if (t23 == 1)
        goto LAB103;

LAB104:    t22 = (unsigned char)0;

LAB105:    if (t22 == 1)
        goto LAB100;

LAB101:    t20 = (unsigned char)0;

LAB102:    if (t20 == 0)
        goto LAB98;

LAB99:    xsi_set_current_line(167, ng0);
    t2 = (t0 + 5320);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(168, ng0);
    t2 = (t0 + 10217);
    *((int *)t2) = 1;
    t3 = (t0 + 10221);
    *((int *)t3) = 1000;
    t11 = 1;
    t14 = 1000;

LAB106:    if (t11 <= t14)
        goto LAB107;

LAB109:    xsi_set_current_line(172, ng0);
    t2 = (t0 + 5512);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)1;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(173, ng0);

LAB117:    *((char **)t1) = &&LAB118;
    goto LAB1;

LAB95:    goto LAB94;

LAB97:    goto LAB95;

LAB98:    t26 = (t0 + 10163);
    xsi_report(t26, 54U, (unsigned char)2);
    goto LAB99;

LAB100:    t26 = (t0 + 2312U);
    t27 = *((char **)t26);
    t30 = *((unsigned char *)t27);
    t31 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t30, (unsigned char)3);
    t20 = t31;
    goto LAB102;

LAB103:    t6 = (t0 + 2472U);
    t7 = *((char **)t6);
    t6 = (t0 + 9588U);
    t8 = (t0 + 10152);
    t24 = (t17 + 0U);
    t26 = (t24 + 0U);
    *((int *)t26) = 0;
    t26 = (t24 + 4U);
    *((int *)t26) = 10;
    t26 = (t24 + 8U);
    *((int *)t26) = 1;
    t11 = (10 - 0);
    t10 = (t11 * 1);
    t10 = (t10 + 1);
    t26 = (t24 + 12U);
    *((unsigned int *)t26) = t10;
    t28 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t7, t6, t8, t17);
    t22 = t28;
    goto LAB105;

LAB107:    xsi_set_current_line(169, ng0);
    t9 = (100 * 1000LL);
    t4 = (t0 + 4240);
    xsi_process_wait(t4, t9);

LAB112:    *((char **)t1) = &&LAB113;
    goto LAB1;

LAB108:    t2 = (t0 + 10217);
    t11 = *((int *)t2);
    t3 = (t0 + 10221);
    t14 = *((int *)t3);
    if (t11 == t14)
        goto LAB109;

LAB114:    t18 = (t11 + 1);
    t11 = t18;
    t4 = (t0 + 10217);
    *((int *)t4) = t11;
    goto LAB106;

LAB110:    goto LAB108;

LAB111:    goto LAB110;

LAB113:    goto LAB111;

LAB115:    goto LAB2;

LAB116:    goto LAB115;

LAB118:    goto LAB116;

}

static void work_a_2020251492_2055581409_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    int64 t10;

LAB0:    t1 = (t0 + 4680U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(180, ng0);
    t2 = (t0 + 2792U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)0);
    if (t5 != 0)
        goto LAB4;

LAB6:    xsi_set_current_line(184, ng0);

LAB13:    *((char **)t1) = &&LAB14;

LAB1:    return;
LAB4:    xsi_set_current_line(181, ng0);
    t2 = (t0 + 5576);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(182, ng0);
    t10 = (50 * 1000LL);
    t2 = (t0 + 4488);
    xsi_process_wait(t2, t10);

LAB9:    *((char **)t1) = &&LAB10;
    goto LAB1;

LAB5:    xsi_set_current_line(187, ng0);
    t2 = (t0 + 2792U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)0);
    if (t5 != 0)
        goto LAB15;

LAB17:    xsi_set_current_line(191, ng0);

LAB24:    *((char **)t1) = &&LAB25;
    goto LAB1;

LAB7:    goto LAB5;

LAB8:    goto LAB7;

LAB10:    goto LAB8;

LAB11:    goto LAB5;

LAB12:    goto LAB11;

LAB14:    goto LAB12;

LAB15:    xsi_set_current_line(188, ng0);
    t2 = (t0 + 5576);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(189, ng0);
    t10 = (50 * 1000LL);
    t2 = (t0 + 4488);
    xsi_process_wait(t2, t10);

LAB20:    *((char **)t1) = &&LAB21;
    goto LAB1;

LAB16:    goto LAB2;

LAB18:    goto LAB16;

LAB19:    goto LAB18;

LAB21:    goto LAB19;

LAB22:    goto LAB16;

LAB23:    goto LAB22;

LAB25:    goto LAB23;

}


extern void work_a_2020251492_2055581409_init()
{
	static char *pe[] = {(void *)work_a_2020251492_2055581409_p_0,(void *)work_a_2020251492_2055581409_p_1};
	xsi_register_didat("work_a_2020251492_2055581409", "isim/test_dac_single_isim_beh.exe.sim/work/a_2020251492_2055581409.didat");
	xsi_register_executes(pe);
}
