#ifndef _SOFT_I2C_H_
#define _SOFT_I2C_H_

#include <mega328p.h>
#include <delay.h>

#define SDA_IN(){DDRC &= 0xEF; /* xoa bit thu 4 PortC */ }
#define SDA_OUT(){DDRC |= 0x10;/* gan bit thu 4 PortC = 1*/}

#define I2C_SCL PORTC.5
#define I2C_SDA PORTC.4
#define READ_SDA PINC.4

// Khoi tao I2C
void I2C_Init(void);
// Start
void I2C_Start(void);
// Stop
void I2C_Stop(void);
// Master gui 1 byte den slave
void I2C_Send_Byte(unsigned char txd);
// Master doc 1 byte tu slave gui den
unsigned char I2C_Read_Byte(unsigned char ack);
// Master cho slave gui ack den
unsigned char I2C_Wait_Ack(void);
// Master gui ack den slave
void I2C_Ack(void);
// Master gui nack den slave
void I2C_NAck(void);

#endif
