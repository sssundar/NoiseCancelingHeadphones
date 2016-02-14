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
static const char *ng0 = "D:/Users/Sushant/Documents/GitHub/NoiseCancelingHeadphones/Xilinx/DevCalibration/generator_sine.vhd";
extern char *IEEE_P_1242562249;
extern char *IEEE_P_2592010699;

unsigned char ieee_p_1242562249_sub_319130236_1035706684(char *, unsigned char , unsigned char );
unsigned char ieee_p_1242562249_sub_337943598_1035706684(char *, char *, char *, char *, char *);
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_0582510309_3990940387_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(89, ng0);

LAB3:    t1 = (t0 + 3520U);
    t2 = *((char **)t1);
    t1 = (t0 + 9392);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 8U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 9264);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_0582510309_3990940387_p_1(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;

LAB0:    xsi_set_current_line(92, ng0);
    t2 = (t0 + 3680U);
    t3 = *((char **)t2);
    t2 = (t0 + 17344U);
    t4 = (t0 + 6376U);
    t5 = *((char **)t4);
    t4 = (t0 + 17424U);
    t6 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t3, t2, t5, t4);
    if (t6 == 1)
        goto LAB5;

LAB6:    t7 = (t0 + 3680U);
    t8 = *((char **)t7);
    t7 = (t0 + 17344U);
    t9 = (t0 + 6256U);
    t10 = *((char **)t9);
    t9 = (t0 + 17408U);
    t11 = ieee_p_1242562249_sub_337943598_1035706684(IEEE_P_1242562249, t8, t7, t10, t9);
    t1 = t11;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB8:    t17 = (t0 + 9456);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    *((unsigned char *)t21) = (unsigned char)2;
    xsi_driver_first_trans_fast(t17);

LAB2:    t22 = (t0 + 9280);
    *((int *)t22) = 1;

LAB1:    return;
LAB3:    t12 = (t0 + 9456);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = (unsigned char)3;
    xsi_driver_first_trans_fast(t12);
    goto LAB2;

LAB5:    t1 = (unsigned char)1;
    goto LAB7;

LAB9:    goto LAB2;

}

static void work_a_0582510309_3990940387_p_2(char *t0)
{
    unsigned char t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    unsigned char t10;
    unsigned char t11;
    unsigned char t12;
    char *t13;
    unsigned char t14;
    char *t15;
    unsigned char t16;
    unsigned char t17;
    char *t18;
    unsigned char t19;
    unsigned char t20;
    char *t21;
    unsigned char t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    unsigned char t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;

LAB0:    xsi_set_current_line(94, ng0);
    t3 = (t0 + 4000U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t3 = (t0 + 5896U);
    t6 = *((char **)t3);
    t7 = *((unsigned char *)t6);
    t8 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t5, t7);
    if (t8 == 1)
        goto LAB8;

LAB9:    t2 = (unsigned char)0;

LAB10:    if (t2 == 1)
        goto LAB5;

LAB6:    t3 = (t0 + 4000U);
    t13 = *((char **)t3);
    t14 = *((unsigned char *)t13);
    t3 = (t0 + 6016U);
    t15 = *((char **)t3);
    t16 = *((unsigned char *)t15);
    t17 = ieee_p_1242562249_sub_319130236_1035706684(IEEE_P_1242562249, t14, t16);
    if (t17 == 1)
        goto LAB11;

LAB12:    t12 = (unsigned char)0;

LAB13:    t1 = t12;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB14:    t27 = (t0 + 6016U);
    t28 = *((char **)t27);
    t29 = *((unsigned char *)t28);
    t27 = (t0 + 9520);
    t30 = (t27 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    *((unsigned char *)t33) = t29;
    xsi_driver_first_trans_fast(t27);

LAB2:    t34 = (t0 + 9296);
    *((int *)t34) = 1;

LAB1:    return;
LAB3:    t3 = (t0 + 5896U);
    t21 = *((char **)t3);
    t22 = *((unsigned char *)t21);
    t3 = (t0 + 9520);
    t23 = (t3 + 56U);
    t24 = *((char **)t23);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    *((unsigned char *)t26) = t22;
    xsi_driver_first_trans_fast(t3);
    goto LAB2;

LAB5:    t1 = (unsigned char)1;
    goto LAB7;

LAB8:    t3 = (t0 + 4320U);
    t9 = *((char **)t3);
    t10 = *((unsigned char *)t9);
    t11 = (t10 == (unsigned char)2);
    t2 = t11;
    goto LAB10;

LAB11:    t3 = (t0 + 4320U);
    t18 = *((char **)t3);
    t19 = *((unsigned char *)t18);
    t20 = (t19 == (unsigned char)3);
    t12 = t20;
    goto LAB13;

LAB15:    goto LAB2;

}

static void work_a_0582510309_3990940387_p_3(char *t0)
{
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
    unsigned char t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(98, ng0);
    t1 = (t0 + 3320U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 9312);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(99, ng0);
    t4 = (t0 + 3040U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    if (t7 == 1)
        goto LAB8;

LAB9:    t3 = (unsigned char)0;

LAB10:    if (t3 != 0)
        goto LAB5;

LAB7:    t1 = (t0 + 3200U);
    t4 = *((char **)t1);
    t2 = *((unsigned char *)t4);
    t3 = (t2 == (unsigned char)3);
    if (t3 != 0)
        goto LAB11;

LAB12:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(100, ng0);
    t4 = (t0 + 4160U);
    t11 = *((char **)t4);
    t12 = *((unsigned char *)t11);
    t4 = (t0 + 9584);
    t13 = (t4 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = t12;
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(101, ng0);
    t1 = (t0 + 3680U);
    t4 = *((char **)t1);
    t1 = (t0 + 9648);
    t5 = (t1 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t13 = *((char **)t11);
    memcpy(t13, t4, 8U);
    xsi_driver_first_trans_fast(t1);
    goto LAB6;

LAB8:    t4 = (t0 + 3200U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)2);
    t3 = t10;
    goto LAB10;

LAB11:    xsi_set_current_line(103, ng0);
    t1 = (t0 + 5896U);
    t5 = *((char **)t1);
    t6 = *((unsigned char *)t5);
    t1 = (t0 + 9584);
    t8 = (t1 + 56U);
    t11 = *((char **)t8);
    t13 = (t11 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = t6;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(104, ng0);
    t1 = (t0 + 6256U);
    t4 = *((char **)t1);
    t1 = (t0 + 9648);
    t5 = (t1 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t13 = *((char **)t11);
    memcpy(t13, t4, 8U);
    xsi_driver_first_trans_fast(t1);
    goto LAB6;

}


void ieee_p_2592010699_sub_3130575329_503743352();

extern void work_a_0582510309_3990940387_init()
{
	static char *pe[] = {(void *)work_a_0582510309_3990940387_p_0,(void *)work_a_0582510309_3990940387_p_1,(void *)work_a_0582510309_3990940387_p_2,(void *)work_a_0582510309_3990940387_p_3};
	xsi_register_didat("work_a_0582510309_3990940387", "isim/test_test_dac_wiring_isim_beh.exe.sim/work/a_0582510309_3990940387.didat");
	xsi_register_executes(pe);
	xsi_register_resolution_function(1, 0, (void *)ieee_p_2592010699_sub_3130575329_503743352, 5);
}
