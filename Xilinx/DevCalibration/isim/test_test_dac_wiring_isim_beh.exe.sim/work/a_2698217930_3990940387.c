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
static const char *ng0 = "D:/Users/Sushant/Documents/GitHub/NoiseCancelingHeadphones/Xilinx/DevCalibration/kBitCounter.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_2698217930_3990940387_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(53, ng0);

LAB3:    t1 = (t0 + 3944U);
    t2 = *((char **)t1);
    t1 = (t0 + 10472);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 9U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 10360);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2698217930_3990940387_p_1(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(54, ng0);

LAB3:    t1 = (t0 + 4104U);
    t2 = *((char **)t1);
    t3 = (0 - 0);
    t4 = (t3 * 1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 10536);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast_port(t8);

LAB2:    t13 = (t0 + 10376);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2698217930_3990940387_p_2(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    int t8;
    unsigned int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    int t14;
    int t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;

LAB0:    xsi_set_current_line(65, ng0);
    t1 = (t0 + 3104U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 10392);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(66, ng0);
    t3 = (t0 + 3304U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:    t1 = (t0 + 3464U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB11;

LAB12:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(67, ng0);
    t3 = xsi_get_transient_memory(9U);
    memset(t3, 0, 9U);
    t7 = t3;
    t8 = (9 - 1);
    if (1 == 1)
        goto LAB8;

LAB9:    t9 = t8;

LAB10:    t10 = (t9 - 0);
    t11 = (t10 * 1);
    t12 = (1U * t11);
    t13 = (t7 + t12);
    t14 = (9 - 1);
    t15 = (t14 - 0);
    t16 = (t15 * 1);
    t16 = (t16 + 1);
    t17 = (1U * t16);
    memset(t13, (unsigned char)2, t17);
    t18 = (t0 + 10600);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    memcpy(t22, t3, 9U);
    xsi_driver_first_trans_fast(t18);
    goto LAB6;

LAB8:    t9 = 0;
    goto LAB10;

LAB11:    xsi_set_current_line(69, ng0);
    t1 = (t0 + 4264U);
    t4 = *((char **)t1);
    t1 = (t0 + 10600);
    t7 = (t1 + 56U);
    t13 = *((char **)t7);
    t18 = (t13 + 56U);
    t19 = *((char **)t18);
    memcpy(t19, t4, 9U);
    xsi_driver_first_trans_fast(t1);
    goto LAB6;

}


extern void work_a_2698217930_3990940387_init()
{
	static char *pe[] = {(void *)work_a_2698217930_3990940387_p_0,(void *)work_a_2698217930_3990940387_p_1,(void *)work_a_2698217930_3990940387_p_2};
	xsi_register_didat("work_a_2698217930_3990940387", "isim/test_test_dac_wiring_isim_beh.exe.sim/work/a_2698217930_3990940387.didat");
	xsi_register_executes(pe);
}
