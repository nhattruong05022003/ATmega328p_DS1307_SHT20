#ifndef _DS1307_H_
#define _DS1307_H_

// Add thu vien I2C cung voi thu vien DS1307
#include "Soft_I2c.h"

void DS1307_Receive(unsigned char add, unsigned char dat);
void adjust(void);
void DS1307_Get_Time(unsigned char *sec, unsigned char *min, unsigned char *hour, unsigned char *flag);
void DS1307_Get_Date(unsigned char *day, unsigned char *date, unsigned char *month, unsigned char *year);
/*
inOrde : tang hay giam (= 1 : tang, = 0 : giam)
*/
void DS1307_Set_Time(unsigned char *sec, unsigned char *min, unsigned char *hour, int position, int inOrde);
void DS1307_Set_Date(unsigned char *day, unsigned char *date, unsigned char *month, unsigned char *year, unsigned char max_day, int position, int inOrde);

#endif
