#include "sht20.h"

unsigned int SHT20_Read_RH(void){ // Mode no hold master
    unsigned int do_am = 0;
    unsigned int do_am1 = 0;
    I2C_Start();
    I2C_Send_Byte(0x80);
    if(I2C_Wait_Ack() == 0){
        I2C_Send_Byte(0xF5); // gui lenh doc do am (xem trong datasheet)
        if(I2C_Wait_Ack() == 0){
            delay_us(20);
            I2C_Stop();
            
            // Cho cho den khi do xong (loi mo phong phai them delay 30 ms (xem datasheet))
            delay_ms(29);
            while(1){
                I2C_Start();
                I2C_Send_Byte(0x81);
                if(I2C_Wait_Ack() == 0){

                    break;
                }
                I2C_Stop();
                
            }
           
            
            do_am = I2C_Read_Byte(0);
            do_am <<= 8;
            do_am1 = I2C_Read_Byte(1);
            do_am |= do_am1;
            
            
//            I2C_Read_Byte(1);
//            I2C_Wait_Ack();
            
        }
    }
    I2C_Stop();
    return do_am;
}

unsigned int SHT20_Read_T(void){ // Mode no hold master
    unsigned int nhiet_do = 0;
    unsigned int nhiet_do1 = 0;
    I2C_Start();
    I2C_Send_Byte(0x80);
    if(I2C_Wait_Ack() == 0){
        I2C_Send_Byte(0xF3); // gui lenh doc nhiet do (xem trong datasheet)
        if(I2C_Wait_Ack() == 0){
            delay_us(20);
            I2C_Stop();
            
            // Cho cho den khi do xong (loi mo phong phai them delay 85 ms (xem datasheet))
            delay_ms(85);
            while(1){
                I2C_Start();
                I2C_Send_Byte(0x81);
                if(I2C_Wait_Ack() == 0){
                    
                    break;
                }
                I2C_Stop();
                
            }
            
            
            nhiet_do = I2C_Read_Byte(0);
            nhiet_do <<= 8;
            nhiet_do1 = I2C_Read_Byte(1);
            nhiet_do |= nhiet_do1;
         
//            I2C_Read_Byte(1);
//            I2C_Wait_Ack();
            
        }
    }
    I2C_Stop();
	return nhiet_do;
}
