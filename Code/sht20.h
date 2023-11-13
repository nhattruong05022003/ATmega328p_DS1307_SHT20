#ifndef _SHT20_H_
#define _SHT20_H_

// THEM THU VIEN I2C

#include <mega328p.h>
#include <delay.h>
#include "Soft_I2c.h"
#include "lcd4.h"


unsigned int SHT20_Read_RH(void); // Doc do am
unsigned int SHT20_Read_T(void);  // Doc nhiet do

#endif
