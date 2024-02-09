#include "Soft_I2c.h"

void I2C_Init(void){
    // PORT C config
    DDRC |= (1<<DDC5) | (1<<DDC4);
    
    I2C_SCL = 1;
	I2C_SDA = 1;
}
void I2C_Start(void){
    SDA_OUT();
    I2C_SCL = 1;
    I2C_SDA = 1;
    delay_ms(1);
    I2C_SDA = 0;
    delay_ms(1);
    I2C_SCL = 0;
}

void I2C_Stop(void){
    SDA_OUT();
    I2C_SCL = 0;
    I2C_SDA = 0;
    delay_ms(1);
    I2C_SCL = 1;
    delay_ms(1);
    I2C_SDA = 1;
}

/*
    Tham so txd : du lieu can truyen
*/
void I2C_Send_Byte(unsigned char txd){ // truyen tu bit cao den bit thap
    unsigned char i = 0;
    SDA_OUT();
    I2C_SCL = 0;
    for(i = 0; i < 8; i++){
        I2C_SDA = (txd & 0x80) >> 7;
        txd <<= 1;
        delay_ms(1);
        I2C_SCL = 1;
        delay_ms(1);
        I2C_SCL = 0;
    }
}

void I2C_Ack(void){
    SDA_OUT();
    I2C_SDA = 0;
    delay_ms(1);
    I2C_SCL = 1;
    delay_ms(1);
    I2C_SCL = 0;
}

void I2C_NAck(void){
    SDA_OUT();
    I2C_SDA = 1;
    delay_ms(1);
    I2C_SCL = 1;
    delay_ms(1);
    I2C_SCL = 0;
}

/*
    Tham so ack : tin hieu ack tu master gui den slave (0: tiep tuc truyen, 1: dung truyen)
*/
unsigned char I2C_Read_Byte(unsigned char ack){ // nhan tu bit cao den bit thap
    unsigned char i = 0;
    unsigned char dat = 0;
    SDA_OUT();
    I2C_SDA = 1; // san sang nhan du lieu
    SDA_IN();
    I2C_SCL = 0;
    for(i = 0; i < 8; i++){
        READ_SDA = 1; // cho SDA = 1 de san sang nhan du lieu
        delay_ms(1);
        I2C_SCL = 1;
        delay_ms(1);
        dat <<= 1;
        dat |= READ_SDA; // muon doc du lieu tu SDA
        I2C_SCL = 0;
    }
    // SDA = 0 -> ACK
    // SDA = 1 -> NACK
    if(ack == 0){
        I2C_Ack();
    }
    else{
        I2C_NAck();
    }
    return dat;
}

unsigned char I2C_Wait_Ack(void){
    unsigned char result = 0;
    unsigned char time = 0;
    SDA_IN();
    I2C_SDA = 1;
    delay_ms(1);
    I2C_SCL = 1;
    delay_ms(1);
    while(READ_SDA){ // muon doc du lieu tu SDA
        time++;
        if(time > 250){
            result = 1;
            break;
        }
    }
    I2C_SCL = 0;
    return result;
}
