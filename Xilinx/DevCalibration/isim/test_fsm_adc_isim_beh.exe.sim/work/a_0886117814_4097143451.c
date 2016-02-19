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
static const char *ng0 = "D:/Users/Sushant/Documents/GitHub/NoiseCancelingHeadphones/Xilinx/DevCalibration/test_fsm_adc.vhd";



static void work_a_0886117814_4097143451_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int t8;
    int t9;
    int t10;

LAB0:    t1 = (t0 + 4592U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(83, ng0);
    t2 = (t0 + 5224);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(84, ng0);
    t2 = (t0 + 5288);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(85, ng0);
    t2 = (t0 + 5352);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(86, ng0);
    t7 = (95 * 1000LL);
    t2 = (t0 + 4400);
    xsi_process_wait(t2, t7);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(88, ng0);
    t2 = (t0 + 5288);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(89, ng0);
    t7 = (5 * 1000LL);
    t2 = (t0 + 4400);
    xsi_process_wait(t2, t7);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(91, ng0);
    t7 = (100 * 1000LL);
    t2 = (t0 + 4400);
    xsi_process_wait(t2, t7);

LAB14:    *((char **)t1) = &&LAB15;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB12:    xsi_set_current_line(92, ng0);
    t2 = (t0 + 5224);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(97, ng0);
    t2 = (t0 + 9401);
    *((int *)t2) = 1;
    t3 = (t0 + 9405);
    *((int *)t3) = 30;
    t8 = 1;
    t9 = 30;

LAB16:    if (t8 <= t9)
        goto LAB17;

LAB19:    xsi_set_current_line(101, ng0);
    t2 = (t0 + 5352);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(102, ng0);
    t7 = (100 * 1000LL);
    t2 = (t0 + 4400);
    xsi_process_wait(t2, t7);

LAB27:    *((char **)t1) = &&LAB28;
    goto LAB1;

LAB13:    goto LAB12;

LAB15:    goto LAB13;

LAB17:    xsi_set_current_line(98, ng0);
    t7 = (100 * 1000LL);
    t4 = (t0 + 4400);
    xsi_process_wait(t4, t7);

LAB22:    *((char **)t1) = &&LAB23;
    goto LAB1;

LAB18:    t2 = (t0 + 9401);
    t8 = *((int *)t2);
    t3 = (t0 + 9405);
    t9 = *((int *)t3);
    if (t8 == t9)
        goto LAB19;

LAB24:    t10 = (t8 + 1);
    t8 = t10;
    t4 = (t0 + 9401);
    *((int *)t4) = t8;
    goto LAB16;

LAB20:    goto LAB18;

LAB21:    goto LAB20;

LAB23:    goto LAB21;

LAB25:    xsi_set_current_line(103, ng0);
    t2 = (t0 + 5352);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(105, ng0);
    t2 = (t0 + 9409);
    *((int *)t2) = 1;
    t3 = (t0 + 9413);
    *((int *)t3) = 40;
    t8 = 1;
    t9 = 40;

LAB29:    if (t8 <= t9)
        goto LAB30;

LAB32:    xsi_set_current_line(109, ng0);
    t2 = (t0 + 5352);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(110, ng0);
    t7 = (100 * 1000LL);
    t2 = (t0 + 4400);
    xsi_process_wait(t2, t7);

LAB40:    *((char **)t1) = &&LAB41;
    goto LAB1;

LAB26:    goto LAB25;

LAB28:    goto LAB26;

LAB30:    xsi_set_current_line(106, ng0);
    t7 = (100 * 1000LL);
    t4 = (t0 + 4400);
    xsi_process_wait(t4, t7);

LAB35:    *((char **)t1) = &&LAB36;
    goto LAB1;

LAB31:    t2 = (t0 + 9409);
    t8 = *((int *)t2);
    t3 = (t0 + 9413);
    t9 = *((int *)t3);
    if (t8 == t9)
        goto LAB32;

LAB37:    t10 = (t8 + 1);
    t8 = t10;
    t4 = (t0 + 9409);
    *((int *)t4) = t8;
    goto LAB29;

LAB33:    goto LAB31;

LAB34:    goto LAB33;

LAB36:    goto LAB34;

LAB38:    xsi_set_current_line(111, ng0);
    t2 = (t0 + 5352);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(113, ng0);
    t2 = (t0 + 9417);
    *((int *)t2) = 1;
    t3 = (t0 + 9421);
    *((int *)t3) = 40;
    t8 = 1;
    t9 = 40;

LAB42:    if (t8 <= t9)
        goto LAB43;

LAB45:    xsi_set_current_line(117, ng0);
    t2 = (t0 + 5352);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(118, ng0);
    t7 = (100 * 1000LL);
    t2 = (t0 + 4400);
    xsi_process_wait(t2, t7);

LAB53:    *((char **)t1) = &&LAB54;
    goto LAB1;

LAB39:    goto LAB38;

LAB41:    goto LAB39;

LAB43:    xsi_set_current_line(114, ng0);
    t7 = (100 * 1000LL);
    t4 = (t0 + 4400);
    xsi_process_wait(t4, t7);

LAB48:    *((char **)t1) = &&LAB49;
    goto LAB1;

LAB44:    t2 = (t0 + 9417);
    t8 = *((int *)t2);
    t3 = (t0 + 9421);
    t9 = *((int *)t3);
    if (t8 == t9)
        goto LAB45;

LAB50:    t10 = (t8 + 1);
    t8 = t10;
    t4 = (t0 + 9417);
    *((int *)t4) = t8;
    goto LAB42;

LAB46:    goto LAB44;

LAB47:    goto LAB46;

LAB49:    goto LAB47;

LAB51:    xsi_set_current_line(119, ng0);
    t2 = (t0 + 5352);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(121, ng0);
    t2 = (t0 + 9425);
    *((int *)t2) = 1;
    t3 = (t0 + 9429);
    *((int *)t3) = 40;
    t8 = 1;
    t9 = 40;

LAB55:    if (t8 <= t9)
        goto LAB56;

LAB58:    xsi_set_current_line(125, ng0);
    t2 = (t0 + 5352);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(126, ng0);
    t7 = (100 * 1000LL);
    t2 = (t0 + 4400);
    xsi_process_wait(t2, t7);

LAB66:    *((char **)t1) = &&LAB67;
    goto LAB1;

LAB52:    goto LAB51;

LAB54:    goto LAB52;

LAB56:    xsi_set_current_line(122, ng0);
    t7 = (100 * 1000LL);
    t4 = (t0 + 4400);
    xsi_process_wait(t4, t7);

LAB61:    *((char **)t1) = &&LAB62;
    goto LAB1;

LAB57:    t2 = (t0 + 9425);
    t8 = *((int *)t2);
    t3 = (t0 + 9429);
    t9 = *((int *)t3);
    if (t8 == t9)
        goto LAB58;

LAB63:    t10 = (t8 + 1);
    t8 = t10;
    t4 = (t0 + 9425);
    *((int *)t4) = t8;
    goto LAB55;

LAB59:    goto LAB57;

LAB60:    goto LAB59;

LAB62:    goto LAB60;

LAB64:    xsi_set_current_line(127, ng0);
    t2 = (t0 + 5352);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(129, ng0);
    t2 = (t0 + 9433);
    *((int *)t2) = 1;
    t3 = (t0 + 9437);
    *((int *)t3) = 40;
    t8 = 1;
    t9 = 40;

LAB68:    if (t8 <= t9)
        goto LAB69;

LAB71:    xsi_set_current_line(133, ng0);
    t2 = (t0 + 5416);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)1;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(134, ng0);

LAB79:    *((char **)t1) = &&LAB80;
    goto LAB1;

LAB65:    goto LAB64;

LAB67:    goto LAB65;

LAB69:    xsi_set_current_line(130, ng0);
    t7 = (100 * 1000LL);
    t4 = (t0 + 4400);
    xsi_process_wait(t4, t7);

LAB74:    *((char **)t1) = &&LAB75;
    goto LAB1;

LAB70:    t2 = (t0 + 9433);
    t8 = *((int *)t2);
    t3 = (t0 + 9437);
    t9 = *((int *)t3);
    if (t8 == t9)
        goto LAB71;

LAB76:    t10 = (t8 + 1);
    t8 = t10;
    t4 = (t0 + 9433);
    *((int *)t4) = t8;
    goto LAB68;

LAB72:    goto LAB70;

LAB73:    goto LAB72;

LAB75:    goto LAB73;

LAB77:    goto LAB2;

LAB78:    goto LAB77;

LAB80:    goto LAB78;

}

static void work_a_0886117814_4097143451_p_1(char *t0)
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

LAB0:    t1 = (t0 + 4840U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(141, ng0);
    t2 = (t0 + 3112U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)0);
    if (t5 != 0)
        goto LAB4;

LAB6:    xsi_set_current_line(145, ng0);

LAB13:    *((char **)t1) = &&LAB14;

LAB1:    return;
LAB4:    xsi_set_current_line(142, ng0);
    t2 = (t0 + 5480);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(143, ng0);
    t10 = (50 * 1000LL);
    t2 = (t0 + 4648);
    xsi_process_wait(t2, t10);

LAB9:    *((char **)t1) = &&LAB10;
    goto LAB1;

LAB5:    xsi_set_current_line(148, ng0);
    t2 = (t0 + 3112U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)0);
    if (t5 != 0)
        goto LAB15;

LAB17:    xsi_set_current_line(152, ng0);

LAB24:    *((char **)t1) = &&LAB25;
    goto LAB1;

LAB7:    goto LAB5;

LAB8:    goto LAB7;

LAB10:    goto LAB8;

LAB11:    goto LAB5;

LAB12:    goto LAB11;

LAB14:    goto LAB12;

LAB15:    xsi_set_current_line(149, ng0);
    t2 = (t0 + 5480);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(150, ng0);
    t10 = (50 * 1000LL);
    t2 = (t0 + 4648);
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


extern void work_a_0886117814_4097143451_init()
{
	static char *pe[] = {(void *)work_a_0886117814_4097143451_p_0,(void *)work_a_0886117814_4097143451_p_1};
	xsi_register_didat("work_a_0886117814_4097143451", "isim/test_fsm_adc_isim_beh.exe.sim/work/a_0886117814_4097143451.didat");
	xsi_register_executes(pe);
}
