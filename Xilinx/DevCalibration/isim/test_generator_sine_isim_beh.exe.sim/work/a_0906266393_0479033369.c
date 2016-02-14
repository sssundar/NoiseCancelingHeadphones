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
static const char *ng0 = "D:/Users/Sushant/Documents/GitHub/NoiseCancelingHeadphones/Xilinx/DevCalibration/test_generator_sine.vhd";
extern char *IEEE_P_1242562249;

unsigned char ieee_p_1242562249_sub_337943598_1035706684(char *, char *, char *, char *, char *);


static void work_a_0906266393_0479033369_p_0(char *t0)
{
    char t15[16];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    unsigned int t8;
    int t9;
    unsigned int t10;
    unsigned int t11;
    int t12;
    unsigned int t13;
    unsigned int t14;
    char *t16;
    char *t17;
    int t18;
    unsigned int t19;
    unsigned char t20;

LAB0:    t1 = (t0 + 2832U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(50, ng0);
    t2 = (t0 + 3464);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(51, ng0);
    t2 = (t0 + 3528);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(52, ng0);
    t7 = (95 * 1000LL);
    t2 = (t0 + 2640);
    xsi_process_wait(t2, t7);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(54, ng0);
    t2 = (t0 + 3528);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(55, ng0);
    t7 = (5 * 1000LL);
    t2 = (t0 + 2640);
    xsi_process_wait(t2, t7);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(58, ng0);
    t2 = (t0 + 1512U);
    t3 = *((char **)t2);
    t2 = (t0 + 6212U);
    t4 = xsi_get_transient_memory(8U);
    memset(t4, 0, 8U);
    t5 = t4;
    if (1 == 1)
        goto LAB14;

LAB15:    t8 = 7;

LAB16:    t9 = (t8 - 0);
    t10 = (t9 * 1);
    t11 = (1U * t10);
    t6 = (t5 + t11);
    t12 = (7 - 0);
    t13 = (t12 * 1);
    t13 = (t13 + 1);
    t14 = (1U * t13);
    memset(t6, (unsigned char)2, t14);
    t16 = (t15 + 0U);
    t17 = (t16 + 0U);
    *((int *)t17) = 0;
    t17 = (t16 + 4U);
    *((int *)t17) = 7;
    t17 = (t16 + 8U);
    *((int *)t17) = 1;
    t18 = (7 - 0);
    t19 = (t18 * 1);
    t19 = (t19 + 1);
    t17 = (t16 + 12U);
    *((unsigned int *)t17) = t19;
    t20 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t3, t2, t4, t15);
    if (t20 == 0)
        goto LAB12;

LAB13:    xsi_set_current_line(63, ng0);
    t2 = (t0 + 6279);
    *((int *)t2) = 1;
    t3 = (t0 + 6283);
    *((int *)t3) = 1000;
    t9 = 1;
    t12 = 1000;

LAB17:    if (t9 <= t12)
        goto LAB18;

LAB20:    xsi_set_current_line(68, ng0);
    t2 = (t0 + 3464);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(69, ng0);
    t7 = (1000 * 1000LL);
    t2 = (t0 + 2640);
    xsi_process_wait(t2, t7);

LAB28:    *((char **)t1) = &&LAB29;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB12:    t17 = (t0 + 6248);
    xsi_report(t17, 31U, (unsigned char)2);
    goto LAB13;

LAB14:    t8 = 0;
    goto LAB16;

LAB18:    xsi_set_current_line(64, ng0);
    t7 = (100 * 1000LL);
    t4 = (t0 + 2640);
    xsi_process_wait(t4, t7);

LAB23:    *((char **)t1) = &&LAB24;
    goto LAB1;

LAB19:    t2 = (t0 + 6279);
    t9 = *((int *)t2);
    t3 = (t0 + 6283);
    t12 = *((int *)t3);
    if (t9 == t12)
        goto LAB20;

LAB25:    t18 = (t9 + 1);
    t9 = t18;
    t4 = (t0 + 6279);
    *((int *)t4) = t9;
    goto LAB17;

LAB21:    goto LAB19;

LAB22:    goto LAB21;

LAB24:    goto LAB22;

LAB26:    xsi_set_current_line(71, ng0);
    t2 = (t0 + 3592);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)1;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(72, ng0);

LAB32:    *((char **)t1) = &&LAB33;
    goto LAB1;

LAB27:    goto LAB26;

LAB29:    goto LAB27;

LAB30:    goto LAB2;

LAB31:    goto LAB30;

LAB33:    goto LAB31;

}

static void work_a_0906266393_0479033369_p_1(char *t0)
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

LAB0:    t1 = (t0 + 3080U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(79, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)0);
    if (t5 != 0)
        goto LAB4;

LAB6:    xsi_set_current_line(83, ng0);

LAB13:    *((char **)t1) = &&LAB14;

LAB1:    return;
LAB4:    xsi_set_current_line(80, ng0);
    t2 = (t0 + 3656);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(81, ng0);
    t10 = (50 * 1000LL);
    t2 = (t0 + 2888);
    xsi_process_wait(t2, t10);

LAB9:    *((char **)t1) = &&LAB10;
    goto LAB1;

LAB5:    xsi_set_current_line(86, ng0);
    t2 = (t0 + 1672U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)0);
    if (t5 != 0)
        goto LAB15;

LAB17:    xsi_set_current_line(90, ng0);

LAB24:    *((char **)t1) = &&LAB25;
    goto LAB1;

LAB7:    goto LAB5;

LAB8:    goto LAB7;

LAB10:    goto LAB8;

LAB11:    goto LAB5;

LAB12:    goto LAB11;

LAB14:    goto LAB12;

LAB15:    xsi_set_current_line(87, ng0);
    t2 = (t0 + 3656);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(88, ng0);
    t10 = (50 * 1000LL);
    t2 = (t0 + 2888);
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


extern void work_a_0906266393_0479033369_init()
{
	static char *pe[] = {(void *)work_a_0906266393_0479033369_p_0,(void *)work_a_0906266393_0479033369_p_1};
	xsi_register_didat("work_a_0906266393_0479033369", "isim/test_generator_sine_isim_beh.exe.sim/work/a_0906266393_0479033369.didat");
	xsi_register_executes(pe);
}
