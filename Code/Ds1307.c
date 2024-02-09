#include "Ds1307.h"

void DS1307_Receive(unsigned char add, unsigned char dat){
    I2C_Start();
    I2C_Send_Byte(0xD0); 
    if(I2C_Wait_Ack() == 0){
        I2C_Send_Byte(add); 
        I2C_Wait_Ack();    
        I2C_Send_Byte(dat);
        I2C_Wait_Ack();    
    }
    I2C_Stop();
}

void adjust(void){
    unsigned char t;
    unsigned char hour,c,dv;
    unsigned char p;
    // Lay gia tri o dia chi 0x02
    I2C_Start();
    I2C_Send_Byte(0xD0);
    if(I2C_Wait_Ack() == 0){    
        I2C_Send_Byte(0x02);
        I2C_Wait_Ack();    
        I2C_Start();
        I2C_Send_Byte(0xD1);
        I2C_Wait_Ack();    
        hour = I2C_Read_Byte(1);
        I2C_Stop();
        

        
        // Neu dang o che do 24 mode
        if(((hour>>6) & 0x01) == 0){
            t = (hour >> 4)*10 + (hour & 0x0F);
            hour &= 0x00;
            // set pm hoac am
            if(t >= 12){
                hour |= 0x20;
            }
            else{
                hour |= 0x00;
            }
            t %= 12;
            c = t / 10;
            c <<= 4;
            dv = t % 10;
            hour |= 0x40+dv+c; // set bit6 len 1
            
            DS1307_Receive(0x02, hour);
        }
        // Neu dang o che do 12 mode
        else{
            p = ((hour>>5) & 0x01);
            hour &= 0x1F;
            t = (hour >> 4)*10 + (hour & 0x0F);
            if(p == 1){
                t += 12;
                if(hour == 24){
                    t = 0;
                }
            }
            c = t / 10;
            c <<= 4;
            dv = t % 10;
            hour &= 0x00;
            hour |= dv+c;
            DS1307_Receive(0x02, hour);
        }
    }

}

void DS1307_Get_Time(unsigned char *sec, unsigned char *min, unsigned char *hour, unsigned char *flag){
    unsigned char t_sec, t_min, t_hour;
    unsigned char temp;
    // Lay du lieu tu DS1307
    I2C_Start();
    I2C_Send_Byte(0xD0);
    if(I2C_Wait_Ack() == 0){
        I2C_Send_Byte(0x00); // bat dau doc tu dia chi cua sec
        I2C_Wait_Ack();    
        I2C_Start();
        I2C_Send_Byte(0xD1); 
        I2C_Wait_Ack();    
        t_sec = I2C_Read_Byte(0);
        t_min = I2C_Read_Byte(0);
        t_hour = I2C_Read_Byte(1);
        I2C_Stop();
        
        
        // Xoa cac bit du 
        t_sec &= 0x7F;
        t_min &= 0x7F;
        
        // Chuyen tu BCD sang thap phan
        *sec =  (t_sec >> 4)*10 + (t_sec & 0x0F);
        *min = (t_min >> 4)*10 + (t_min & 0x0F);
        
        // Kiem tra mode dang hoat dong la 24 hay 12
        temp = ((t_hour>>6) & 0x01);
        // Mode 12
        if(temp == 0x01){
            temp = ((t_hour>>5) & 0x01);
            // PM
            if(temp == 1){
                *flag = 2;
            }
            // AM
            else{
                *flag = 1;
            }
            t_hour &= 0x1F;
            *hour = (t_hour >> 4)*10 + (t_hour & 0x0F);
        }
        // Mode 24
        else{
            *flag = 0;
            t_hour &= 0x3F;
            *hour = (t_hour >> 4)*10 + (t_hour & 0x0F);
        }
    }
}

void DS1307_Get_Date(unsigned char *day, unsigned char *date, unsigned char *month, unsigned char *year){
    unsigned char t_day, t_date, t_month, t_year;
    // Lay du lieu tu DS1307
    I2C_Start();
    I2C_Send_Byte(0xD0);
    if(I2C_Wait_Ack() == 0){
        I2C_Send_Byte(0x03); // bat dau doc tu dia chi cua day
        I2C_Wait_Ack();    
        I2C_Start();
        I2C_Send_Byte(0xD1); 
        I2C_Wait_Ack();    
        t_day = I2C_Read_Byte(0);
        t_date = I2C_Read_Byte(0);
        t_month = I2C_Read_Byte(0);
        t_year = I2C_Read_Byte(1);
        I2C_Stop();
        
        // Xoa cac bit du
        t_day &= 0x0F;
        t_date &= 0x3F;
        t_month &= 0x1F;
        
        // Chuyen tu BCD sang thap phan
        *day = (t_day & 0x0F);
        *date = (t_date >> 4)*10 + (t_date & 0x0F);
        *month = (t_month >> 4)*10 + (t_month & 0x0F);
        *year = (t_year >> 4)*10 + (t_year & 0x0F);
    }
}


void DS1307_Set_Date(unsigned char *day, unsigned char *date, unsigned char *month, unsigned char *year, unsigned char max_day, int position,    int inOrde){
    if(inOrde == 1){
        if(position == 1){
            if(*date + 10 > max_day){
                *date = *date + 10 - max_day;
                *month += 1;
                if(*month > 12){
                    *month = 1;
                    *year += 1;
                    if(*year > 99)
                        *year -= 100;
                }
            }
            else{
                *date += 10;
            }
        }
        else if(position == 2){
            if(*date + 1 > max_day){
                *date = *date + 1 - max_day;
                *month += 1;
                if(*month > 12){
                    *month = 1;
                    *year += 1;
                    if(*year > 99)
                        *year -= 100;
                }
            }
            else{
                *date += 1;
            }
        }
        else if(position == 4){
            if(*month + 10 > 12){
                *month = *month + 10 - 12;
                *year += 1;
                if(*year > 99)
                        *year -= 100;
            }
            else{
                *month += 10;
            }
        }
        else if(position == 5){
            if(*month + 1 > 12){
                *month = *month + 1 - 12;
                *year += 1;
                if(*year > 99)
                    *year -= 100;
            }
            else{
                *month += 1;
            }
        }
        else if(position == 7){
            if(*year + 10 > 99){
                *year = *year + 10 - 100;
            }
            else{
                *year += 10;
            }
        }
        else if(position == 8){
            if(*year + 1 >= 99){
                *year = *year + 1 - 100;
            }
            else{
                *year += 1;
            }
        }
        else if(position >= 10 && position <= 12){
            *day += 1;
            *day %= 7;
        }
    }
    else{
        if(position == 1){
            if(*date - 10 <= 0){
                *date = *date + max_day - 10;
                *month -= 1;
                if(*month == 0){
                    *month = 12;
                    if(*year == 0)
                        *year = 100;
                    *year -= 1;
                }
            }
            else{
                *date -= 10;
            }
        }
        else if(position == 2){
            if(*date - 1 <= 0){
                *date = *date + max_day - 1;
                *month -= 1;
                if(*month == 0){
                    *month = 12;
                    if(*year == 0)
                        *year = 100;
                    *year -= 1;
                }
            }
            else{
                *date -= 1;
            }
        }
        else if(position == 4){
            if(*month - 10 <= 0){
                *month = *month + 12 - 10;
                if(*year == 0)
                    *year = 100;
                *year -= 1;
            }
            else{
                *month -= 10;
            }
        }
        else if(position == 5){
            if(*month - 1 <= 0){
                *month = *month + 12 - 1;
                *year -= 1;
                if(*year == 0)
                    *year = 100;
                *year -= 1;
            }
            else{
                *month -= 1;
            }
        }
        else if(position == 7){
            if(*year - 10 <= 0){
                *year = *year + 100 - 10;
            }
            else{
                *year -= 10;
            }
        }
        else if(position == 8){
            if(*year - 1 <= 0){
                *year = *year + 100 - 1;
            }
            else{
                *year -= 1;
            }
        }
        else if(position >= 10 && position <= 12){
            *day -= 1;
            if(*day<=0)
                *day = 7;
            *day %= 7;
        }
    }
}

void DS1307_Set_Time(unsigned char *sec, unsigned char *min, unsigned char *hour, int position, int inOrde){
    if(inOrde == 1){
        if(position == 1){
            if(*hour + 10 >= 24){
                *hour = (*hour + 10) % 24;
            }
            else{
                *hour += 10;
            }
        }
        else if(position == 2){
            if(*hour + 1 >= 24){
                *hour = (*hour + 1) % 24;
            }
            else{
                *hour += 1;
            }
        }
        else if(position == 6){
            if(*min + 10 >= 60){
                *min = (*min + 10) % 60;
                *hour += 1;
                if(*hour == 24){
                    *hour = 0;
                }
            }
            else{
                *min += 10;
            }
        }
        else if(position == 7){
            if(*min + 1 >= 60){
                *min = (*min + 1) % 60;
                *hour += 1;
                if(*hour == 24){
                    *hour = 0;
                }
            }
            else{
                *min += 1;
            }
        }
        else if(position == 11){
            if(*sec + 10 >= 60){
                *sec = (*sec+10) % 60;
                *min += 1;
                if(*min == 60){
                    *min = 0;
                }
            }
            else{
                *sec += 10;
            }
        }
        else if(position == 12){
            if(*sec + 1 >= 60){
                *sec = (*sec+1) % 60;
                *min += 1;
                if(*min == 60){
                    *min = 0;
                }
            }
            else{
                *sec += 1;
            }
        }
    }
    else{
        if(position == 1){
            if(*hour - 10 > 0){
                *hour -= 10;
            }
            else{
                *hour = *hour + 24 - 10;
            }
        }
        else if(position == 2){
            if(*hour - 1 > 0){
                *hour -= 1;
            }
            else{
                *hour = *hour + 24 - 1;
            }
        }
        else if(position == 6){
            if(*min - 10 < 0){
                *min = (*min + 60) - 10;
                *hour -= 1;
                if(*hour == 255){
                    *hour = 0;
                    *hour = *hour + 24 - 1;
                }
            }
            else{
                *min -= 10;
            }
        }
        else if(position == 7){
            if(*min - 1 < 0){
                *min = (*min + 60) - 1;
                *hour -= 1;
                if(*hour == 255){
                    *hour = 0;
                    *hour = *hour + 24 - 1;
                }
            }
            else{
                *min -= 1;
            }
        }
        else if(position == 11){
            if(*sec - 10 < 0){
                *sec = (*sec+60) - 10;
                *min -= 1;
                if(*min == 255){
                    *min = 0;    
                    *min = 60 + *min - 1;
                    *hour -= 1;
                    if(*hour == 255){
                        *hour = 0;
                        *hour = *hour + 24 - 1;
                    } 
                }
            }
            else{
                *sec -= 10;
            }
        }
        else if(position == 12){
            if(*sec - 1 < 0){
                *sec = (*sec+60) - 1;
                *min -= 1;
                if(*min == 255){
                    *min = 0;    
                    *min = 60 + *min - 1;
                    *hour -= 1;
                    if(*hour == 255){
                        *hour = 0;
                        *hour = *hour + 24 - 1;
                    } 
                }
            }
            else{
                *sec -= 1;
			}
		}
	}
}