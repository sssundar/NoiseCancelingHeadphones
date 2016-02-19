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
static const char *ng0 = "D:/Users/Sushant/Documents/GitHub/NoiseCancelingHeadphones/Xilinx/DevCalibration/fsm_adc.vhd";
extern char *IEEE_P_1242562249;
extern char *IEEE_P_2592010699;

unsigned char ieee_p_1242562249_sub_319130236_1035706684(char *, unsigned char , unsigned char );
unsigned char ieee_p_1242562249_sub_337943598_1035706684(char *, char *, char *, char *, char *);
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_2080298263_3990940387_p_0(char *t0)
{
    char t16[16];
    char t29[16];
    char t41[16];
    char t53[16];
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    unsigned char t6;
    unsigned char t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    unsigned char t11;
    unsigned char t12;
    char *t13;
    char *t14;
    char *t17;
    char *t18;
    int t19;
    unsigned int t20;
    unsigned char t21;
    unsigned char t22;
    char *t23;
    unsigned char t24;
    unsigned char t25;
    char *t26;
    char *t27;
    char *t30;
    char *t31;
    int t32;
    unsigned char t33;
    unsigned char t34;
    char *t35;
    unsigned char t36;
    unsigned char t37;
    char *t38;
    char *t39;
    char *t42;
    char *t43;
    int t44;
    unsigned char t45;
    unsigned char t46;
    char *t47;
    unsigned char t48;
    unsigned char t49;
    char *t50;
    char *t51;
    char *t54;
    char *t55;
    int t56;
    unsigned char t57;
    char *t58;
    char *t59;
    char *t60;
    char *t61;
    char *t62;
    char *t63;
    char *t64;
    char *t65;
    char *t66;
    char *t67;

LAB0:    xsi_set_current_line(145, ng0);
    t2 = (t0 + 4712U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)3);
    if (t5 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB29:    t62 = (t0 + 16328);
    t63 = (t62 + 56U);
    t64 = *((char **)t63);
    t65 = (t64 + 56U);
    t66 = *((char **)t65);
    *((unsigned char *)t66) = (unsigned char)2;
    xsi_driver_first_trans_fast(t62);

LAB2:    t67 = (t0 + 15864);
    *((int *)t67) = 1;

LAB1:    return;
LAB3:    t55 = (t0 + 16328);
    t58 = (t55 + 56U);
    t59 = *((char **)t58);
    t60 = (t59 + 56U);
    t61 = *((char **)t60);
    *((unsigned char *)t61) = (unsigned char)3;
    xsi_driver_first_trans_fast(t55);
    goto LAB2;

LAB5:    t2 = (t0 + 6312U);
    t10 = *((char **)t2);
    t11 = *((unsigned char *)t10);
    t12 = (t11 == (unsigned char)3);
    if (t12 == 1)
        goto LAB17;

LAB18:    t9 = (unsigned char)0;

LAB19:    if (t9 == 1)
        goto LAB14;

LAB15:    t18 = (t0 + 6632U);
    t23 = *((char **)t18);
    t24 = *((unsigned char *)t23);
    t25 = (t24 == (unsigned char)3);
    if (t25 == 1)
        goto LAB20;

LAB21:    t22 = (unsigned char)0;

LAB22:    t8 = t22;

LAB16:    if (t8 == 1)
        goto LAB11;

LAB12:    t31 = (t0 + 6952U);
    t35 = *((char **)t31);
    t36 = *((unsigned char *)t35);
    t37 = (t36 == (unsigned char)3);
    if (t37 == 1)
        goto LAB23;

LAB24:    t34 = (unsigned char)0;

LAB25:    t7 = t34;

LAB13:    if (t7 == 1)
        goto LAB8;

LAB9:    t43 = (t0 + 7272U);
    t47 = *((char **)t43);
    t48 = *((unsigned char *)t47);
    t49 = (t48 == (unsigned char)3);
    if (t49 == 1)
        goto LAB26;

LAB27:    t46 = (unsigned char)0;

LAB28:    t6 = t46;

LAB10:    t1 = t6;
    goto LAB7;

LAB8:    t6 = (unsigned char)1;
    goto LAB10;

LAB11:    t7 = (unsigned char)1;
    goto LAB13;

LAB14:    t8 = (unsigned char)1;
    goto LAB16;

LAB17:    t2 = (t0 + 5352U);
    t13 = *((char **)t2);
    t2 = (t0 + 28408U);
    t14 = (t0 + 28644);
    t17 = (t16 + 0U);
    t18 = (t17 + 0U);
    *((int *)t18) = 0;
    t18 = (t17 + 4U);
    *((int *)t18) = 1;
    t18 = (t17 + 8U);
    *((int *)t18) = 1;
    t19 = (1 - 0);
    t20 = (t19 * 1);
    t20 = (t20 + 1);
    t18 = (t17 + 12U);
    *((unsigned int *)t18) = t20;
    t21 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t13, t2, t14, t16);
    t9 = t21;
    goto LAB19;

LAB20:    t18 = (t0 + 5352U);
    t26 = *((char **)t18);
    t18 = (t0 + 28408U);
    t27 = (t0 + 28646);
    t30 = (t29 + 0U);
    t31 = (t30 + 0U);
    *((int *)t31) = 0;
    t31 = (t30 + 4U);
    *((int *)t31) = 1;
    t31 = (t30 + 8U);
    *((int *)t31) = 1;
    t32 = (1 - 0);
    t20 = (t32 * 1);
    t20 = (t20 + 1);
    t31 = (t30 + 12U);
    *((unsigned int *)t31) = t20;
    t33 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t26, t18, t27, t29);
    t22 = t33;
    goto LAB22;

LAB23:    t31 = (t0 + 5352U);
    t38 = *((char **)t31);
    t31 = (t0 + 28408U);
    t39 = (t0 + 28648);
    t42 = (t41 + 0U);
    t43 = (t42 + 0U);
    *((int *)t43) = 0;
    t43 = (t42 + 4U);
    *((int *)t43) = 1;
    t43 = (t42 + 8U);
    *((int *)t43) = 1;
    t44 = (1 - 0);
    t20 = (t44 * 1);
    t20 = (t20 + 1);
    t43 = (t42 + 12U);
    *((unsigned int *)t43) = t20;
    t45 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t38, t31, t39, t41);
    t34 = t45;
    goto LAB25;

LAB26:    t43 = (t0 + 5352U);
    t50 = *((char **)t43);
    t43 = (t0 + 28408U);
    t51 = (t0 + 28650);
    t54 = (t53 + 0U);
    t55 = (t54 + 0U);
    *((int *)t55) = 0;
    t55 = (t54 + 4U);
    *((int *)t55) = 1;
    t55 = (t54 + 8U);
    *((int *)t55) = 1;
    t56 = (1 - 0);
    t20 = (t56 * 1);
    t20 = (t20 + 1);
    t55 = (t54 + 12U);
    *((unsigned int *)t55) = t20;
    t57 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t50, t43, t51, t53);
    t46 = t57;
    goto LAB28;

LAB30:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;

LAB0:    xsi_set_current_line(146, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 8608U);
    t5 = *((char **)t4);
    t4 = (t0 + 8616);
    t4 = *((char **)t4);
    t6 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t6 != 0)
        goto LAB3;

LAB4:
LAB5:    t12 = (t0 + 16392);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = (unsigned char)2;
    xsi_driver_first_trans_fast(t12);

LAB2:    t17 = (t0 + 15880);
    *((int *)t17) = 1;

LAB1:    return;
LAB3:    t7 = (t0 + 16392);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_fast(t7);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_2(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    xsi_set_current_line(147, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t3 = (0 - 0);
    t4 = (t3 * 1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t7, (unsigned char)3);
    if (t8 != 0)
        goto LAB3;

LAB4:
LAB5:    t14 = (t0 + 16456);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    *((unsigned char *)t18) = (unsigned char)3;
    xsi_driver_first_trans_fast(t14);

LAB2:    t19 = (t0 + 15896);
    *((int *)t19) = 1;

LAB1:    return;
LAB3:    t9 = (t0 + 16456);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = (unsigned char)2;
    xsi_driver_first_trans_fast(t9);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_3(char *t0)
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

LAB0:    xsi_set_current_line(150, ng0);

LAB3:    t1 = (t0 + 5352U);
    t2 = *((char **)t1);
    t3 = (1 - 0);
    t4 = (t3 * 1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 16520);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast_port(t8);

LAB2:    t13 = (t0 + 15912);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_4(char *t0)
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

LAB0:    xsi_set_current_line(151, ng0);

LAB3:    t1 = (t0 + 5352U);
    t2 = *((char **)t1);
    t3 = (0 - 0);
    t4 = (t3 * 1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 16584);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast_port(t8);

LAB2:    t13 = (t0 + 15928);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_5(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(152, ng0);

LAB3:    t1 = (t0 + 3752U);
    t2 = *((char **)t1);
    t1 = (t0 + 16648);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 8U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 15944);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_6(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(153, ng0);

LAB3:    t1 = (t0 + 3912U);
    t2 = *((char **)t1);
    t1 = (t0 + 16712);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 8U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 15960);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_7(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(154, ng0);

LAB3:    t1 = (t0 + 4072U);
    t2 = *((char **)t1);
    t1 = (t0 + 16776);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 8U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 15976);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_8(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(155, ng0);

LAB3:    t1 = (t0 + 4232U);
    t2 = *((char **)t1);
    t1 = (t0 + 16840);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 8U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 15992);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_9(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(156, ng0);

LAB3:    t1 = (t0 + 4392U);
    t2 = *((char **)t1);
    t1 = (t0 + 16904);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 8U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 16008);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_10(char *t0)
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

LAB0:    xsi_set_current_line(157, ng0);

LAB3:    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t3 = (0 - 0);
    t4 = (t3 * 1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 16968);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast_port(t8);

LAB2:    t13 = (t0 + 16024);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_11(char *t0)
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

LAB0:    xsi_set_current_line(158, ng0);

LAB3:    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t3 = (1 - 0);
    t4 = (t3 * 1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 17032);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast_port(t8);

LAB2:    t13 = (t0 + 16040);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_12(char *t0)
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

LAB0:    xsi_set_current_line(161, ng0);

LAB3:    t1 = (t0 + 6152U);
    t2 = *((char **)t1);
    t3 = (2 - 2);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 17096);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 16056);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_13(char *t0)
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

LAB0:    xsi_set_current_line(162, ng0);

LAB3:    t1 = (t0 + 6472U);
    t2 = *((char **)t1);
    t3 = (2 - 2);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 17160);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 16072);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_14(char *t0)
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

LAB0:    xsi_set_current_line(163, ng0);

LAB3:    t1 = (t0 + 6792U);
    t2 = *((char **)t1);
    t3 = (2 - 2);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 17224);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 16088);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_15(char *t0)
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

LAB0:    xsi_set_current_line(164, ng0);

LAB3:    t1 = (t0 + 7112U);
    t2 = *((char **)t1);
    t3 = (2 - 2);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 17288);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 16104);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_16(char *t0)
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

LAB0:    xsi_set_current_line(165, ng0);

LAB3:    t1 = (t0 + 7432U);
    t2 = *((char **)t1);
    t3 = (2 - 2);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 17352);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 16120);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_17(char *t0)
{
    char t16[16];
    char t18[16];
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    char *t8;
    char *t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned char t14;
    char *t15;
    char *t17;
    char *t19;
    char *t20;
    int t21;
    unsigned int t22;
    unsigned char t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;

LAB0:    xsi_set_current_line(169, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 16136);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(170, ng0);
    t3 = (t0 + 6152U);
    t4 = *((char **)t3);
    t5 = (2 - 1);
    t6 = (t5 * 1U);
    t7 = (0 + t6);
    t3 = (t4 + t7);
    t8 = (t0 + 1672U);
    t9 = *((char **)t8);
    t10 = (0 - 0);
    t11 = (t10 * 1);
    t12 = (1U * t11);
    t13 = (0 + t12);
    t8 = (t9 + t13);
    t14 = *((unsigned char *)t8);
    t17 = ((IEEE_P_2592010699) + 4024);
    t19 = (t18 + 0U);
    t20 = (t19 + 0U);
    *((int *)t20) = 1;
    t20 = (t19 + 4U);
    *((int *)t20) = 0;
    t20 = (t19 + 8U);
    *((int *)t20) = -1;
    t21 = (0 - 1);
    t22 = (t21 * -1);
    t22 = (t22 + 1);
    t20 = (t19 + 12U);
    *((unsigned int *)t20) = t22;
    t15 = xsi_base_array_concat(t15, t16, t17, (char)97, t3, t18, (char)99, t14, (char)101);
    t22 = (2U + 1U);
    t23 = (3U != t22);
    if (t23 == 1)
        goto LAB5;

LAB6:    t20 = (t0 + 17416);
    t24 = (t20 + 56U);
    t25 = *((char **)t24);
    t26 = (t25 + 56U);
    t27 = *((char **)t26);
    memcpy(t27, t15, 3U);
    xsi_driver_first_trans_delta(t20, 0U, 3U, 0LL);
    xsi_set_current_line(171, ng0);
    t1 = (t0 + 6472U);
    t3 = *((char **)t1);
    t5 = (2 - 1);
    t6 = (t5 * 1U);
    t7 = (0 + t6);
    t1 = (t3 + t7);
    t4 = (t0 + 1672U);
    t8 = *((char **)t4);
    t10 = (1 - 0);
    t11 = (t10 * 1);
    t12 = (1U * t11);
    t13 = (0 + t12);
    t4 = (t8 + t13);
    t2 = *((unsigned char *)t4);
    t15 = ((IEEE_P_2592010699) + 4024);
    t17 = (t18 + 0U);
    t19 = (t17 + 0U);
    *((int *)t19) = 1;
    t19 = (t17 + 4U);
    *((int *)t19) = 0;
    t19 = (t17 + 8U);
    *((int *)t19) = -1;
    t21 = (0 - 1);
    t22 = (t21 * -1);
    t22 = (t22 + 1);
    t19 = (t17 + 12U);
    *((unsigned int *)t19) = t22;
    t9 = xsi_base_array_concat(t9, t16, t15, (char)97, t1, t18, (char)99, t2, (char)101);
    t22 = (2U + 1U);
    t14 = (3U != t22);
    if (t14 == 1)
        goto LAB7;

LAB8:    t19 = (t0 + 17480);
    t20 = (t19 + 56U);
    t24 = *((char **)t20);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    memcpy(t26, t9, 3U);
    xsi_driver_first_trans_delta(t19, 0U, 3U, 0LL);
    xsi_set_current_line(172, ng0);
    t1 = (t0 + 6792U);
    t3 = *((char **)t1);
    t5 = (2 - 1);
    t6 = (t5 * 1U);
    t7 = (0 + t6);
    t1 = (t3 + t7);
    t4 = (t0 + 1672U);
    t8 = *((char **)t4);
    t10 = (2 - 0);
    t11 = (t10 * 1);
    t12 = (1U * t11);
    t13 = (0 + t12);
    t4 = (t8 + t13);
    t2 = *((unsigned char *)t4);
    t15 = ((IEEE_P_2592010699) + 4024);
    t17 = (t18 + 0U);
    t19 = (t17 + 0U);
    *((int *)t19) = 1;
    t19 = (t17 + 4U);
    *((int *)t19) = 0;
    t19 = (t17 + 8U);
    *((int *)t19) = -1;
    t21 = (0 - 1);
    t22 = (t21 * -1);
    t22 = (t22 + 1);
    t19 = (t17 + 12U);
    *((unsigned int *)t19) = t22;
    t9 = xsi_base_array_concat(t9, t16, t15, (char)97, t1, t18, (char)99, t2, (char)101);
    t22 = (2U + 1U);
    t14 = (3U != t22);
    if (t14 == 1)
        goto LAB9;

LAB10:    t19 = (t0 + 17544);
    t20 = (t19 + 56U);
    t24 = *((char **)t20);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    memcpy(t26, t9, 3U);
    xsi_driver_first_trans_delta(t19, 0U, 3U, 0LL);
    xsi_set_current_line(173, ng0);
    t1 = (t0 + 7112U);
    t3 = *((char **)t1);
    t5 = (2 - 1);
    t6 = (t5 * 1U);
    t7 = (0 + t6);
    t1 = (t3 + t7);
    t4 = (t0 + 1672U);
    t8 = *((char **)t4);
    t10 = (3 - 0);
    t11 = (t10 * 1);
    t12 = (1U * t11);
    t13 = (0 + t12);
    t4 = (t8 + t13);
    t2 = *((unsigned char *)t4);
    t15 = ((IEEE_P_2592010699) + 4024);
    t17 = (t18 + 0U);
    t19 = (t17 + 0U);
    *((int *)t19) = 1;
    t19 = (t17 + 4U);
    *((int *)t19) = 0;
    t19 = (t17 + 8U);
    *((int *)t19) = -1;
    t21 = (0 - 1);
    t22 = (t21 * -1);
    t22 = (t22 + 1);
    t19 = (t17 + 12U);
    *((unsigned int *)t19) = t22;
    t9 = xsi_base_array_concat(t9, t16, t15, (char)97, t1, t18, (char)99, t2, (char)101);
    t22 = (2U + 1U);
    t14 = (3U != t22);
    if (t14 == 1)
        goto LAB11;

LAB12:    t19 = (t0 + 17608);
    t20 = (t19 + 56U);
    t24 = *((char **)t20);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    memcpy(t26, t9, 3U);
    xsi_driver_first_trans_delta(t19, 0U, 3U, 0LL);
    xsi_set_current_line(174, ng0);
    t1 = (t0 + 7432U);
    t3 = *((char **)t1);
    t5 = (2 - 1);
    t6 = (t5 * 1U);
    t7 = (0 + t6);
    t1 = (t3 + t7);
    t4 = (t0 + 1512U);
    t8 = *((char **)t4);
    t2 = *((unsigned char *)t8);
    t9 = ((IEEE_P_2592010699) + 4024);
    t15 = (t18 + 0U);
    t17 = (t15 + 0U);
    *((int *)t17) = 1;
    t17 = (t15 + 4U);
    *((int *)t17) = 0;
    t17 = (t15 + 8U);
    *((int *)t17) = -1;
    t10 = (0 - 1);
    t11 = (t10 * -1);
    t11 = (t11 + 1);
    t17 = (t15 + 12U);
    *((unsigned int *)t17) = t11;
    t4 = xsi_base_array_concat(t4, t16, t9, (char)97, t1, t18, (char)99, t2, (char)101);
    t11 = (2U + 1U);
    t14 = (3U != t11);
    if (t14 == 1)
        goto LAB13;

LAB14:    t17 = (t0 + 17672);
    t19 = (t17 + 56U);
    t20 = *((char **)t19);
    t24 = (t20 + 56U);
    t25 = *((char **)t24);
    memcpy(t25, t4, 3U);
    xsi_driver_first_trans_delta(t17, 0U, 3U, 0LL);
    goto LAB3;

LAB5:    xsi_size_not_matching(3U, t22, 0);
    goto LAB6;

LAB7:    xsi_size_not_matching(3U, t22, 0);
    goto LAB8;

LAB9:    xsi_size_not_matching(3U, t22, 0);
    goto LAB10;

LAB11:    xsi_size_not_matching(3U, t22, 0);
    goto LAB12;

LAB13:    xsi_size_not_matching(3U, t11, 0);
    goto LAB14;

}

static void work_a_2080298263_3990940387_p_18(char *t0)
{
    char t19[16];
    char t20[16];
    char *t1;
    unsigned char t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    int t21;
    unsigned int t22;
    char *t23;
    char *t24;

LAB0:    xsi_set_current_line(206, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 16152);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(207, ng0);
    t4 = (t0 + 4712U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    if (t7 == 1)
        goto LAB8;

LAB9:    t3 = (unsigned char)0;

LAB10:    if (t3 != 0)
        goto LAB5;

LAB7:
LAB6:    xsi_set_current_line(214, ng0);
    t1 = (t0 + 4552U);
    t4 = *((char **)t1);
    t3 = *((unsigned char *)t4);
    t6 = (t3 == (unsigned char)3);
    if (t6 == 1)
        goto LAB16;

LAB17:    t2 = (unsigned char)0;

LAB18:    if (t2 != 0)
        goto LAB13;

LAB15:
LAB14:    xsi_set_current_line(218, ng0);
    t1 = (t0 + 1352U);
    t4 = *((char **)t1);
    t2 = *((unsigned char *)t4);
    t3 = (t2 == (unsigned char)3);
    if (t3 != 0)
        goto LAB19;

LAB21:
LAB20:    goto LAB3;

LAB5:    xsi_set_current_line(208, ng0);
    t4 = (t0 + 4072U);
    t11 = *((char **)t4);
    t4 = (t0 + 17736);
    t12 = (t4 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t11, 8U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(209, ng0);
    t1 = (t0 + 4232U);
    t4 = *((char **)t1);
    t1 = (t0 + 17800);
    t5 = (t1 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t4, 8U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(210, ng0);
    t1 = (t0 + 4392U);
    t4 = *((char **)t1);
    t1 = (t0 + 17864);
    t5 = (t1 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t4, 8U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(211, ng0);
    t1 = (t0 + 4872U);
    t4 = *((char **)t1);
    t2 = *((unsigned char *)t4);
    t1 = (t0 + 1832U);
    t5 = *((char **)t1);
    t16 = (1 - 0);
    t17 = (t16 * 1U);
    t18 = (0 + t17);
    t1 = (t5 + t18);
    t11 = ((IEEE_P_2592010699) + 4024);
    t12 = (t20 + 0U);
    t13 = (t12 + 0U);
    *((int *)t13) = 1;
    t13 = (t12 + 4U);
    *((int *)t13) = 7;
    t13 = (t12 + 8U);
    *((int *)t13) = 1;
    t21 = (7 - 1);
    t22 = (t21 * 1);
    t22 = (t22 + 1);
    t13 = (t12 + 12U);
    *((unsigned int *)t13) = t22;
    t8 = xsi_base_array_concat(t8, t19, t11, (char)99, t2, (char)97, t1, t20, (char)101);
    t22 = (1U + 7U);
    t3 = (8U != t22);
    if (t3 == 1)
        goto LAB11;

LAB12:    t13 = (t0 + 17928);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    t23 = (t15 + 56U);
    t24 = *((char **)t23);
    memcpy(t24, t8, 8U);
    xsi_driver_first_trans_delta(t13, 0U, 8U, 0LL);
    goto LAB6;

LAB8:    t4 = (t0 + 1352U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)2);
    t3 = t10;
    goto LAB10;

LAB11:    xsi_size_not_matching(8U, t22, 0);
    goto LAB12;

LAB13:    xsi_set_current_line(215, ng0);
    t1 = (t0 + 1832U);
    t8 = *((char **)t1);
    t1 = (t0 + 17992);
    t11 = (t1 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t8, 8U);
    xsi_driver_first_trans_fast(t1);
    goto LAB14;

LAB16:    t1 = (t0 + 1352U);
    t5 = *((char **)t1);
    t7 = *((unsigned char *)t5);
    t9 = (t7 == (unsigned char)2);
    t2 = t9;
    goto LAB18;

LAB19:    xsi_set_current_line(219, ng0);
    t1 = (t0 + 28652);
    t8 = (t0 + 17992);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t1, 8U);
    xsi_driver_first_trans_fast(t8);
    xsi_set_current_line(220, ng0);
    t1 = (t0 + 28660);
    t5 = (t0 + 17736);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 8U);
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(221, ng0);
    t1 = (t0 + 28668);
    t5 = (t0 + 17800);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 8U);
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(222, ng0);
    t1 = (t0 + 28676);
    t5 = (t0 + 17864);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 8U);
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(223, ng0);
    t1 = (t0 + 28684);
    t5 = (t0 + 17928);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 8U);
    xsi_driver_first_trans_fast(t5);
    goto LAB20;

}

static void work_a_2080298263_3990940387_p_19(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(231, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 16168);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(232, ng0);
    t3 = (t0 + 3592U);
    t4 = *((char **)t3);
    t3 = (t0 + 18056);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t4, 5U);
    xsi_driver_first_trans_fast(t3);
    goto LAB3;

}

static void work_a_2080298263_3990940387_p_20(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;

LAB0:    xsi_set_current_line(237, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 7888U);
    t5 = *((char **)t4);
    t4 = (t0 + 7896);
    t4 = *((char **)t4);
    t6 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t6 != 0)
        goto LAB3;

LAB4:
LAB5:    t12 = (t0 + 18120);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = (unsigned char)2;
    xsi_driver_first_trans_fast(t12);

LAB2:    t17 = (t0 + 16184);
    *((int *)t17) = 1;

LAB1:    return;
LAB3:    t7 = (t0 + 18120);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_fast(t7);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_21(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;

LAB0:    xsi_set_current_line(238, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 8008U);
    t5 = *((char **)t4);
    t4 = (t0 + 8016);
    t4 = *((char **)t4);
    t6 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t6 != 0)
        goto LAB3;

LAB4:
LAB5:    t12 = (t0 + 18184);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = (unsigned char)2;
    xsi_driver_first_trans_fast(t12);

LAB2:    t17 = (t0 + 16200);
    *((int *)t17) = 1;

LAB1:    return;
LAB3:    t7 = (t0 + 18184);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_fast(t7);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_22(char *t0)
{
    unsigned char t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned char t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;

LAB0:    xsi_set_current_line(239, ng0);
    t3 = (t0 + 3432U);
    t4 = *((char **)t3);
    t3 = (t0 + 3440U);
    t5 = *((char **)t3);
    t6 = (t0 + 7888U);
    t7 = *((char **)t6);
    t6 = (t0 + 7896);
    t6 = *((char **)t6);
    t8 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t4, t5, t7, t6);
    if (t8 == 1)
        goto LAB8;

LAB9:    t9 = (t0 + 3432U);
    t10 = *((char **)t9);
    t9 = (t0 + 3440U);
    t11 = *((char **)t9);
    t12 = (t0 + 8368U);
    t13 = *((char **)t12);
    t12 = (t0 + 8376);
    t12 = *((char **)t12);
    t14 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t10, t11, t13, t12);
    t2 = t14;

LAB10:    if (t2 == 1)
        goto LAB5;

LAB6:    t15 = (t0 + 3432U);
    t16 = *((char **)t15);
    t15 = (t0 + 3440U);
    t17 = *((char **)t15);
    t18 = (t0 + 8008U);
    t19 = *((char **)t18);
    t18 = (t0 + 8016);
    t18 = *((char **)t18);
    t20 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t16, t17, t19, t18);
    t1 = t20;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB11:    t26 = (t0 + 18248);
    t27 = (t26 + 56U);
    t28 = *((char **)t27);
    t29 = (t28 + 56U);
    t30 = *((char **)t29);
    *((unsigned char *)t30) = (unsigned char)2;
    xsi_driver_first_trans_fast(t26);

LAB2:    t31 = (t0 + 16216);
    *((int *)t31) = 1;

LAB1:    return;
LAB3:    t21 = (t0 + 18248);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    *((unsigned char *)t25) = (unsigned char)3;
    xsi_driver_first_trans_fast(t21);
    goto LAB2;

LAB5:    t1 = (unsigned char)1;
    goto LAB7;

LAB8:    t2 = (unsigned char)1;
    goto LAB10;

LAB12:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_23(char *t0)
{
    unsigned char t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned char t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;

LAB0:    xsi_set_current_line(240, ng0);
    t3 = (t0 + 3432U);
    t4 = *((char **)t3);
    t3 = (t0 + 3440U);
    t5 = *((char **)t3);
    t6 = (t0 + 8128U);
    t7 = *((char **)t6);
    t6 = (t0 + 8136);
    t6 = *((char **)t6);
    t8 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t4, t5, t7, t6);
    if (t8 == 1)
        goto LAB8;

LAB9:    t9 = (t0 + 3432U);
    t10 = *((char **)t9);
    t9 = (t0 + 3440U);
    t11 = *((char **)t9);
    t12 = (t0 + 8248U);
    t13 = *((char **)t12);
    t12 = (t0 + 8256);
    t12 = *((char **)t12);
    t14 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t10, t11, t13, t12);
    t2 = t14;

LAB10:    if (t2 == 1)
        goto LAB5;

LAB6:    t15 = (t0 + 3432U);
    t16 = *((char **)t15);
    t15 = (t0 + 3440U);
    t17 = *((char **)t15);
    t18 = (t0 + 8488U);
    t19 = *((char **)t18);
    t18 = (t0 + 8496);
    t18 = *((char **)t18);
    t20 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t16, t17, t19, t18);
    t1 = t20;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB11:    t26 = (t0 + 18312);
    t27 = (t26 + 56U);
    t28 = *((char **)t27);
    t29 = (t28 + 56U);
    t30 = *((char **)t29);
    *((unsigned char *)t30) = (unsigned char)2;
    xsi_driver_first_trans_fast(t26);

LAB2:    t31 = (t0 + 16232);
    *((int *)t31) = 1;

LAB1:    return;
LAB3:    t21 = (t0 + 18312);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    *((unsigned char *)t25) = (unsigned char)3;
    xsi_driver_first_trans_fast(t21);
    goto LAB2;

LAB5:    t1 = (unsigned char)1;
    goto LAB7;

LAB8:    t2 = (unsigned char)1;
    goto LAB10;

LAB12:    goto LAB2;

}

static void work_a_2080298263_3990940387_p_24(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    unsigned char t11;
    unsigned char t12;
    char *t13;
    unsigned char t14;
    unsigned char t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;

LAB0:    xsi_set_current_line(244, ng0);
    t1 = (t0 + 7888U);
    t2 = *((char **)t1);
    t1 = (t0 + 18376);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 5U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(246, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 7888U);
    t5 = *((char **)t4);
    t4 = (t0 + 7896);
    t4 = *((char **)t4);
    t9 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t9 == 1)
        goto LAB8;

LAB9:    t8 = (unsigned char)0;

LAB10:    if (t8 == 1)
        goto LAB5;

LAB6:    t7 = (unsigned char)0;

LAB7:    if (t7 != 0)
        goto LAB2;

LAB4:
LAB3:    xsi_set_current_line(250, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 8128U);
    t5 = *((char **)t4);
    t4 = (t0 + 8136);
    t4 = *((char **)t4);
    t8 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t8 == 1)
        goto LAB14;

LAB15:    t7 = (unsigned char)0;

LAB16:    if (t7 != 0)
        goto LAB11;

LAB13:
LAB12:    xsi_set_current_line(258, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 8248U);
    t5 = *((char **)t4);
    t4 = (t0 + 8256);
    t4 = *((char **)t4);
    t8 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t8 == 1)
        goto LAB23;

LAB24:    t7 = (unsigned char)0;

LAB25:    if (t7 != 0)
        goto LAB20;

LAB22:
LAB21:    xsi_set_current_line(266, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 8368U);
    t5 = *((char **)t4);
    t4 = (t0 + 8376);
    t4 = *((char **)t4);
    t8 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t8 == 1)
        goto LAB32;

LAB33:    t7 = (unsigned char)0;

LAB34:    if (t7 != 0)
        goto LAB29;

LAB31:
LAB30:    xsi_set_current_line(274, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 8488U);
    t5 = *((char **)t4);
    t4 = (t0 + 8496);
    t4 = *((char **)t4);
    t8 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t8 == 1)
        goto LAB41;

LAB42:    t7 = (unsigned char)0;

LAB43:    if (t7 != 0)
        goto LAB38;

LAB40:
LAB39:    xsi_set_current_line(282, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 8608U);
    t5 = *((char **)t4);
    t4 = (t0 + 8616);
    t4 = *((char **)t4);
    t8 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t8 == 1)
        goto LAB50;

LAB51:    t7 = (unsigned char)0;

LAB52:    if (t7 != 0)
        goto LAB47;

LAB49:
LAB48:    xsi_set_current_line(286, ng0);
    t1 = (t0 + 3432U);
    t2 = *((char **)t1);
    t1 = (t0 + 3440U);
    t3 = *((char **)t1);
    t4 = (t0 + 8008U);
    t5 = *((char **)t4);
    t4 = (t0 + 8016);
    t4 = *((char **)t4);
    t8 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t2, t3, t5, t4);
    if (t8 == 1)
        goto LAB56;

LAB57:    t7 = (unsigned char)0;

LAB58:    if (t7 != 0)
        goto LAB53;

LAB55:
LAB54:    t1 = (t0 + 16248);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(247, ng0);
    t6 = (t0 + 8128U);
    t16 = *((char **)t6);
    t6 = (t0 + 18376);
    t17 = (t6 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t16, 5U);
    xsi_driver_first_trans_fast(t6);
    goto LAB3;

LAB5:    t6 = (t0 + 1352U);
    t13 = *((char **)t6);
    t14 = *((unsigned char *)t13);
    t15 = (t14 == (unsigned char)2);
    t7 = t15;
    goto LAB7;

LAB8:    t6 = (t0 + 1192U);
    t10 = *((char **)t6);
    t11 = *((unsigned char *)t10);
    t12 = (t11 == (unsigned char)3);
    t8 = t12;
    goto LAB10;

LAB11:    xsi_set_current_line(251, ng0);
    t6 = (t0 + 5992U);
    t13 = *((char **)t6);
    t12 = *((unsigned char *)t13);
    t14 = (t12 == (unsigned char)3);
    if (t14 != 0)
        goto LAB17;

LAB19:    xsi_set_current_line(254, ng0);
    t1 = (t0 + 8128U);
    t2 = *((char **)t1);
    t1 = (t0 + 18376);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 5U);
    xsi_driver_first_trans_fast(t1);

LAB18:    goto LAB12;

LAB14:    t6 = (t0 + 1352U);
    t10 = *((char **)t6);
    t9 = *((unsigned char *)t10);
    t11 = (t9 == (unsigned char)2);
    t7 = t11;
    goto LAB16;

LAB17:    xsi_set_current_line(252, ng0);
    t6 = (t0 + 8248U);
    t16 = *((char **)t6);
    t6 = (t0 + 18376);
    t17 = (t6 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t16, 5U);
    xsi_driver_first_trans_fast(t6);
    goto LAB18;

LAB20:    xsi_set_current_line(259, ng0);
    t6 = (t0 + 5992U);
    t13 = *((char **)t6);
    t12 = *((unsigned char *)t13);
    t14 = (t12 == (unsigned char)3);
    if (t14 != 0)
        goto LAB26;

LAB28:    xsi_set_current_line(262, ng0);
    t1 = (t0 + 8248U);
    t2 = *((char **)t1);
    t1 = (t0 + 18376);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 5U);
    xsi_driver_first_trans_fast(t1);

LAB27:    goto LAB21;

LAB23:    t6 = (t0 + 1352U);
    t10 = *((char **)t6);
    t9 = *((unsigned char *)t10);
    t11 = (t9 == (unsigned char)2);
    t7 = t11;
    goto LAB25;

LAB26:    xsi_set_current_line(260, ng0);
    t6 = (t0 + 8368U);
    t16 = *((char **)t6);
    t6 = (t0 + 18376);
    t17 = (t6 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t16, 5U);
    xsi_driver_first_trans_fast(t6);
    goto LAB27;

LAB29:    xsi_set_current_line(267, ng0);
    t6 = (t0 + 7592U);
    t13 = *((char **)t6);
    t12 = *((unsigned char *)t13);
    t14 = (t12 == (unsigned char)2);
    if (t14 != 0)
        goto LAB35;

LAB37:    xsi_set_current_line(270, ng0);
    t1 = (t0 + 8368U);
    t2 = *((char **)t1);
    t1 = (t0 + 18376);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 5U);
    xsi_driver_first_trans_fast(t1);

LAB36:    goto LAB30;

LAB32:    t6 = (t0 + 1352U);
    t10 = *((char **)t6);
    t9 = *((unsigned char *)t10);
    t11 = (t9 == (unsigned char)2);
    t7 = t11;
    goto LAB34;

LAB35:    xsi_set_current_line(268, ng0);
    t6 = (t0 + 8488U);
    t16 = *((char **)t6);
    t6 = (t0 + 18376);
    t17 = (t6 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t16, 5U);
    xsi_driver_first_trans_fast(t6);
    goto LAB36;

LAB38:    xsi_set_current_line(275, ng0);
    t6 = (t0 + 5992U);
    t13 = *((char **)t6);
    t12 = *((unsigned char *)t13);
    t14 = (t12 == (unsigned char)3);
    if (t14 != 0)
        goto LAB44;

LAB46:    xsi_set_current_line(278, ng0);
    t1 = (t0 + 8488U);
    t2 = *((char **)t1);
    t1 = (t0 + 18376);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 5U);
    xsi_driver_first_trans_fast(t1);

LAB45:    goto LAB39;

LAB41:    t6 = (t0 + 1352U);
    t10 = *((char **)t6);
    t9 = *((unsigned char *)t10);
    t11 = (t9 == (unsigned char)2);
    t7 = t11;
    goto LAB43;

LAB44:    xsi_set_current_line(276, ng0);
    t6 = (t0 + 8608U);
    t16 = *((char **)t6);
    t6 = (t0 + 18376);
    t17 = (t6 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t16, 5U);
    xsi_driver_first_trans_fast(t6);
    goto LAB45;

LAB47:    xsi_set_current_line(283, ng0);
    t6 = (t0 + 8008U);
    t13 = *((char **)t6);
    t6 = (t0 + 18376);
    t16 = (t6 + 56U);
    t17 = *((char **)t16);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    memcpy(t19, t13, 5U);
    xsi_driver_first_trans_fast(t6);
    goto LAB48;

LAB50:    t6 = (t0 + 1352U);
    t10 = *((char **)t6);
    t9 = *((unsigned char *)t10);
    t11 = (t9 == (unsigned char)2);
    t7 = t11;
    goto LAB52;

LAB53:    xsi_set_current_line(287, ng0);
    t6 = (t0 + 5512U);
    t13 = *((char **)t6);
    t12 = *((unsigned char *)t13);
    t14 = (t12 == (unsigned char)2);
    if (t14 != 0)
        goto LAB59;

LAB61:
LAB60:    goto LAB54;

LAB56:    t6 = (t0 + 1352U);
    t10 = *((char **)t6);
    t9 = *((unsigned char *)t10);
    t11 = (t9 == (unsigned char)2);
    t7 = t11;
    goto LAB58;

LAB59:    xsi_set_current_line(288, ng0);
    t6 = (t0 + 8128U);
    t16 = *((char **)t6);
    t6 = (t0 + 18376);
    t17 = (t6 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t16, 5U);
    xsi_driver_first_trans_fast(t6);
    goto LAB60;

}


void ieee_p_2592010699_sub_3130575329_503743352();

extern void work_a_2080298263_3990940387_init()
{
	static char *pe[] = {(void *)work_a_2080298263_3990940387_p_0,(void *)work_a_2080298263_3990940387_p_1,(void *)work_a_2080298263_3990940387_p_2,(void *)work_a_2080298263_3990940387_p_3,(void *)work_a_2080298263_3990940387_p_4,(void *)work_a_2080298263_3990940387_p_5,(void *)work_a_2080298263_3990940387_p_6,(void *)work_a_2080298263_3990940387_p_7,(void *)work_a_2080298263_3990940387_p_8,(void *)work_a_2080298263_3990940387_p_9,(void *)work_a_2080298263_3990940387_p_10,(void *)work_a_2080298263_3990940387_p_11,(void *)work_a_2080298263_3990940387_p_12,(void *)work_a_2080298263_3990940387_p_13,(void *)work_a_2080298263_3990940387_p_14,(void *)work_a_2080298263_3990940387_p_15,(void *)work_a_2080298263_3990940387_p_16,(void *)work_a_2080298263_3990940387_p_17,(void *)work_a_2080298263_3990940387_p_18,(void *)work_a_2080298263_3990940387_p_19,(void *)work_a_2080298263_3990940387_p_20,(void *)work_a_2080298263_3990940387_p_21,(void *)work_a_2080298263_3990940387_p_22,(void *)work_a_2080298263_3990940387_p_23,(void *)work_a_2080298263_3990940387_p_24};
	xsi_register_didat("work_a_2080298263_3990940387", "isim/test_fsm_adc_isim_beh.exe.sim/work/a_2080298263_3990940387.didat");
	xsi_register_executes(pe);
	xsi_register_resolution_function(1, 2, (void *)ieee_p_2592010699_sub_3130575329_503743352, 4);
}
