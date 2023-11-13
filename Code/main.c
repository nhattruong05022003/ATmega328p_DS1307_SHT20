/*******************************************************
This program was created by the CodeWizardAVR V3.40 
Automatic Program Generator
© Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : Project1
Version : 1.0.0
Date    : 29-07-2023
Author  : School
Company : 
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega328p.h>
#include <delay.h>

#include "lcd4.h"
#include "Soft_I2c.h"
#include "Ds1307.h"
#include "sht20.h"


// Declare your global variables here
#define MODE PIND.7
#define CHANGE_MODE PIND.2
#define ALARM_MODE PIND.3
#define TANG PINC.1
#define GIAM PINC.2
#define LEFT PINC.3
#define RIGHT PIND.4
#define LEN PIND.5
#define XUONG PIND.6

unsigned char sec, min, hour, day, date, month, year;
unsigned char a_sec = 99, a_min = 99, a_hour = 99, a_day = 99, a_date = 99, a_month = 99, a_year = 100;
unsigned char flag = 0;
unsigned char* dayOfWeek[] = {"Sat","Sun", "Mon", "Tue", "Wed", "Thu", "Fri"};
// 0 la 30 ngay, 1 la 31 ngay
unsigned int dayOfMonth[] = {1,0,1,0,1,0,1,1,0,1,0,1};

char change_mode = 0;
unsigned char address;

unsigned int do_am, nhiet_do;

// HAM HIEN THI LEN LCD
void display(){
    // CHAY CA 2 TRUOC -> KHONG BI GHI DE DU LIEU KHI XAY RA NGAT
    // tinh toan do am
    do_am = (-6 + 125 * (SHT20_Read_RH()*1.0f / 65536));
    delay_ms(1); 
    // tinh toan nhiet do
    nhiet_do = (-46.85 + 0.17572 * (SHT20_Read_T() * 1000.0f / 65536.0)) * 1000;
    delay_ms(1);
    DS1307_Get_Date(&day, &date, &month, &year);
    delay_ms(1);
    DS1307_Get_Time(&sec, &min, &hour, &flag);
    delay_ms(1);
    
    if(change_mode < 2){         
         Lcd_Chr(1,1, date/10+0x30);
         Lcd_Chr_Cp(date%10+0x30);
         Lcd_Chr_Cp('/');
		 Lcd_Chr_Cp(month/10+0x30);
		 Lcd_Chr_Cp(month%10+0x30);
		 Lcd_Chr_Cp('/');
		 Lcd_Chr_Cp(year/10+0x30);
		 Lcd_Chr_Cp(year%10+0x30);
		 Lcd_Chr_Cp(' ');
         Lcd_Out_Cp(dayOfWeek[day%7]);
                       
         
         Lcd_Chr(2,1, hour/10+0x30);
         Lcd_Chr_Cp(hour%10+0x30);
         if(flag == 1)
			 Lcd_Out_Cp(" AM : ");
		 else if (flag == 2)
			 Lcd_Out_Cp(" PM : ");
		 else
			 Lcd_Out_Cp(" : ");
         Lcd_Chr_Cp(min/10+0x30);
		 Lcd_Chr_Cp(min%10+0x30);
		 Lcd_Chr_Cp(' ');
	 	 Lcd_Chr_Cp(':');
		 Lcd_Chr_Cp(' ');
		 Lcd_Chr_Cp(sec/10+0x30);
		 Lcd_Chr_Cp(sec%10+0x30);
    }
    else{
      
         Lcd_Chr(1,1,nhiet_do/10000 + 0x30);
         Lcd_Chr_Cp(nhiet_do/1000 % 10 + 0x30);
         Lcd_Chr_Cp('.');
         Lcd_Chr_Cp(nhiet_do/100 % 10 + 0x30);
         Lcd_Chr_Cp(nhiet_do/10 % 10 + 0x30);
         Lcd_Chr_Cp(nhiet_do%10 + 0x30);
         Lcd_Chr_Cp('C');

         Lcd_Chr(2,1,do_am/10000 + 0x30);
         Lcd_Chr_Cp(do_am/1000 % 10 + 0x30);
         Lcd_Chr_Cp(do_am/100 % 10 + 0x30);
         Lcd_Chr_Cp(do_am/10 % 10 + 0x30);
         Lcd_Chr_Cp(do_am%10 + 0x30);
         Lcd_Chr_Cp('%');
    }    
}

// Pin change 16-23 interrupt service routine
// DIEU CHINH GIUA CACC MODE (24h -> 12h -> nhiet_do, do_am -> 24h -> .....)
interrupt [PC_INT2] void pin_change_isr2(void) 
{
// Place your code here    
    delay_ms(20);
    while(MODE == 0);
    if(change_mode == 2){
       change_mode = -1;
       adjust(); 
    }
    else if(change_mode == 0){
       adjust(); 
    }
    Lcd_Cmd(_LCD_CLEAR);
    change_mode ++;
    delay_ms(50);
    Lcd_Cmd(_LCD_CLEAR); 
}

// External Interrupt 0 service routine
// HAM DIEU CHINH THOI GIAN
interrupt [EXT_INT0] void ext_int0_isr(void) 
{
// Place your code here
    // Bien thay doi vi tri
    int inOrde;
    int position = 1;
    unsigned char row = 0;
    unsigned char max_day = 30;
    
    // Bien dung doi sang bcd
    unsigned char bcd_convert;
    unsigned char t;
    
    delay_ms(20);
    if(change_mode != 0){
//        if(change_mode == 1){
//            adjust();
//        }
//        else{
//            adjust();
//        }
        adjust()
        flag = 0;
        change_mode = 0;
    }
    
    Lcd_Cmd(_LCD_CLEAR);
    
    DS1307_Get_Date(&day, &date, &month, &year);
    Lcd_Chr(1,1, date/10+0x30);
    Lcd_Chr_Cp(date%10+0x30);
    Lcd_Chr_Cp('/');
    Lcd_Chr_Cp(month/10+0x30);
    Lcd_Chr_Cp(month%10+0x30);
    Lcd_Chr_Cp('/');
    Lcd_Chr_Cp(year/10+0x30);
    Lcd_Chr_Cp(year%10+0x30);
    Lcd_Chr_Cp(' ');
    Lcd_Out_Cp(dayOfWeek[day%7]);
                       
    DS1307_Get_Time(&sec, &min, &hour, &flag);
    Lcd_Chr(2,1, hour/10+0x30);
    Lcd_Chr_Cp(hour%10+0x30);
    Lcd_Out_Cp(" : ");
    Lcd_Chr_Cp(min/10+0x30);
    Lcd_Chr_Cp(min%10+0x30);
    Lcd_Chr_Cp(' ');
    Lcd_Chr_Cp(':');
    Lcd_Chr_Cp(' ');
    Lcd_Chr_Cp(sec/10+0x30);
    Lcd_Chr_Cp(sec%10+0x30);
    
    Lcd_Cmd(_LCD_FIRST_ROW); // _LCD_FIRST_ROW
    Lcd_Cmd(_LCD_BLINK_CURSOR_ON); // _LCD_BLINK_CURSOR_ON
    position = 1;
    while(CHANGE_MODE == 0){
        if(LEN == 0){
            delay_ms(20);
            row = 0;
            
            address = 0x80 + position - 1;
            Lcd_Cmd(address);
            
            while(LEN == 0);
        }
        if(XUONG == 0){
            delay_ms(20);
            row = 1;
            
            address = 0xC0 + position - 1;
            Lcd_Cmd(address);
            
            while(XUONG == 0);
        }
        if(RIGHT == 0){
            delay_ms(20);
            if(position > 0){
                position ++;
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                if(position <= 16){
                    Lcd_Cmd(address);
                }
            }
            while(RIGHT == 0);
        }
        if(LEFT == 0){
            delay_ms(20);
            if(position > 1){
                position --;
                if(position < 1)
                    position = 1;
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
            }
            while(LEFT == 0);
        }
        
        
        
        if(row == 0){
            max_day = dayOfMonth[month-1] + 30;
            if(TANG == 0){
                inOrde = 1;
                DS1307_Set_Date(&day, &date, &month, &year, max_day, position, inOrde);
                
                Lcd_Chr(1,1, date/10+0x30);
                Lcd_Chr_Cp(date%10+0x30);
                Lcd_Chr_Cp('/');
                Lcd_Chr_Cp(month/10+0x30);
                Lcd_Chr_Cp(month%10+0x30);
                Lcd_Chr_Cp('/');
                Lcd_Chr_Cp(year/10+0x30);
                Lcd_Chr_Cp(year%10+0x30);
                Lcd_Chr_Cp(' ');
                Lcd_Out_Cp(dayOfWeek[day%7]);
                
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
                
                while(TANG == 0);
            }
            
            if(GIAM == 0){
                inOrde = 0;
                DS1307_Set_Date(&day, &date, &month, &year, max_day, position, inOrde);
                
                Lcd_Chr(1,1, date/10+0x30);
                Lcd_Chr_Cp(date%10+0x30);
                Lcd_Chr_Cp('/');
                Lcd_Chr_Cp(month/10+0x30);
                Lcd_Chr_Cp(month%10+0x30);
                Lcd_Chr_Cp('/');
                Lcd_Chr_Cp(year/10+0x30);
                Lcd_Chr_Cp(year%10+0x30);
                Lcd_Chr_Cp(' ');
                Lcd_Out_Cp(dayOfWeek[day%7]);
                
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
                
                while(GIAM == 0);
            }
        }
        
        else{
            if(TANG == 0){
                inOrde = 1;
                DS1307_Set_Time(&sec, &min, &hour, position, inOrde);
                
                Lcd_Chr(2,1, hour/10+0x30);
                Lcd_Chr_Cp(hour%10+0x30);
                Lcd_Out_Cp(" : ");
                Lcd_Chr_Cp(min/10+0x30);
                Lcd_Chr_Cp(min%10+0x30);
                Lcd_Chr_Cp(' ');
                Lcd_Chr_Cp(':');
                Lcd_Chr_Cp(' ');
                Lcd_Chr_Cp(sec/10+0x30);
                Lcd_Chr_Cp(sec%10+0x30);
                
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
                
                while(TANG == 0);
            }
            if(GIAM == 0){
                inOrde = 0;
                DS1307_Set_Time(&sec, &min, &hour, position, inOrde);
                
                Lcd_Chr(2,1, hour/10+0x30);
                Lcd_Chr_Cp(hour%10+0x30);
                Lcd_Out_Cp(" : ");
                Lcd_Chr_Cp(min/10+0x30);
                Lcd_Chr_Cp(min%10+0x30);
                Lcd_Chr_Cp(' ');
                Lcd_Chr_Cp(':');
                Lcd_Chr_Cp(' ');
                Lcd_Chr_Cp(sec/10+0x30);
                Lcd_Chr_Cp(sec%10+0x30);
                
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
                
                while(GIAM == 0);
            }
        }
    }
    
    // Doi sang BCD r chuyen cho DS1307
    t = sec;
    bcd_convert = t / 10;
    bcd_convert <<= 4;
    bcd_convert |= t%10;
    DS1307_Receive(0, bcd_convert);
    
    t = min;
    bcd_convert = t / 10;
    bcd_convert <<= 4;
    bcd_convert |= t%10;
    DS1307_Receive(1, bcd_convert);
    
    t = hour;
    bcd_convert = t / 10;
    bcd_convert <<= 4;
    bcd_convert |= t%10;
    DS1307_Receive(2, bcd_convert);
    
    t = day;
    bcd_convert = t / 10;
    bcd_convert <<= 4;
    bcd_convert |= t%10;
    DS1307_Receive(3, bcd_convert);
    
    t = date;
    bcd_convert = t / 10;
    bcd_convert <<= 4;
    bcd_convert |= t%10;
    DS1307_Receive(4, bcd_convert);
    
    t = month;
    bcd_convert = t / 10;
    bcd_convert <<= 4;
    bcd_convert |= t%10;
    DS1307_Receive(5, bcd_convert);
    
    t = year;
    bcd_convert = t / 10;
    bcd_convert <<= 4;
    bcd_convert |= t%10;
    DS1307_Receive(6, bcd_convert);
    
    Lcd_Cmd(_LCD_CURSOR_OFF); // _LCD_CURSOR_OFF
    Lcd_Cmd(_LCD_CLEAR);
}

// External Interrupt 1 service routine
// HAM SET ALARM
interrupt [EXT_INT1] void ext_int1_isr(void)  
{
// Place your code here
    // Bien thay doi vi tri
    int inOrde;
    int position = 1;
    unsigned char row = 0;
    unsigned char max_day = 30;
    
    
    delay_ms(20);
    if(change_mode != 0){
        adjust();
        flag = 0;
        change_mode = 0;
    }   
    
    Lcd_Cmd(_LCD_CLEAR);
    
    DS1307_Get_Date(&day, &date, &month, &year);
    Lcd_Chr(1,1, date/10+0x30);
    Lcd_Chr_Cp(date%10+0x30);
    Lcd_Chr_Cp('/');
    Lcd_Chr_Cp(month/10+0x30);
    Lcd_Chr_Cp(month%10+0x30);
    Lcd_Chr_Cp('/');
    Lcd_Chr_Cp(year/10+0x30);
    Lcd_Chr_Cp(year%10+0x30);
    Lcd_Chr_Cp(' ');
    Lcd_Out_Cp(dayOfWeek[day%7]);
                       
    DS1307_Get_Time(&sec, &min, &hour, &flag);
    Lcd_Chr(2,1, hour/10+0x30);
    Lcd_Chr_Cp(hour%10+0x30);
    Lcd_Out_Cp(" : ");
    Lcd_Chr_Cp(min/10+0x30);
    Lcd_Chr_Cp(min%10+0x30);
    Lcd_Chr_Cp(' ');
    Lcd_Chr_Cp(':');
    Lcd_Chr_Cp(' ');
    Lcd_Chr_Cp(sec/10+0x30);
    Lcd_Chr_Cp(sec%10+0x30);
    
    a_sec = sec;
    a_min = min;
    a_hour = hour;
    a_day = day;
    a_date = date;
    a_month = month;
    a_year = year;
    
    Lcd_Cmd(_LCD_FIRST_ROW); // _LCD_FIRST_ROW
    Lcd_Cmd(_LCD_BLINK_CURSOR_ON); // _LCD_BLINK_CURSOR_ON
    position = 1;
    while(ALARM_MODE == 0){
        if(LEN == 0){
            delay_ms(20);
            row = 0;
            
            address = 0x80 + position - 1;
            Lcd_Cmd(address);
            
            while(LEN == 0);
        }
        if(XUONG == 0){
            delay_ms(20);
            row = 1;
            
            address = 0xC0 + position - 1;
            Lcd_Cmd(address);
            
            while(XUONG == 0);
        }
        if(RIGHT == 0){
            delay_ms(20);
            if(position > 0){
                position ++;
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                if(position <= 16){
                    Lcd_Cmd(address);
                }
            }
            while(RIGHT == 0);
        }
        if(LEFT == 0){
            delay_ms(20);
            if(position > 1){
                position --;
                if(position < 1)
                    position = 1;
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
            }
            while(LEFT == 0);
        }
        
        
        
        if(row == 0){
            max_day = dayOfMonth[month-1] + 30;
            if(TANG == 0){
                inOrde = 1;
                DS1307_Set_Date(&a_day, &a_date, &a_month, &a_year, max_day, position, inOrde);
                
                Lcd_Chr(1,1, a_date/10+0x30);
                Lcd_Chr_Cp(a_date%10+0x30);
                Lcd_Chr_Cp('/');
                Lcd_Chr_Cp(a_month/10+0x30);
                Lcd_Chr_Cp(a_month%10+0x30);
                Lcd_Chr_Cp('/');
                Lcd_Chr_Cp(a_year/10+0x30);
                Lcd_Chr_Cp(a_year%10+0x30);
                Lcd_Chr_Cp(' ');
                Lcd_Out_Cp(dayOfWeek[a_day%7]);
                
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
                
                while(TANG == 0);
            }
            
            if(GIAM == 0){
                inOrde = 0;
                DS1307_Set_Date(&a_day, &a_date, &a_month, &a_year, max_day, position, inOrde);
                
                Lcd_Chr(1,1, a_date/10+0x30);
                Lcd_Chr_Cp(a_date%10+0x30);
                Lcd_Chr_Cp('/');
                Lcd_Chr_Cp(a_month/10+0x30);
                Lcd_Chr_Cp(a_month%10+0x30);
                Lcd_Chr_Cp('/');
                Lcd_Chr_Cp(a_year/10+0x30);
                Lcd_Chr_Cp(a_year%10+0x30);
                Lcd_Chr_Cp(' ');
                Lcd_Out_Cp(dayOfWeek[a_day%7]);
                
                if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
                
                while(GIAM == 0);
            }
        }
        
        else{
            if(TANG == 0){
                inOrde = 1;
                DS1307_Set_Time(&a_sec, &a_min, &a_hour, position, inOrde);
                
                Lcd_Chr(2,1, a_hour/10+0x30);
                Lcd_Chr_Cp(a_hour%10+0x30);
                Lcd_Out_Cp(" : ");
                Lcd_Chr_Cp(a_min/10+0x30);
                Lcd_Chr_Cp(a_min%10+0x30);
                Lcd_Chr_Cp(' ');
                Lcd_Chr_Cp(':');
                Lcd_Chr_Cp(' ');
                Lcd_Chr_Cp(a_sec/10+0x30);
                Lcd_Chr_Cp(a_sec%10+0x30);
                
				if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
                
				while(TANG == 0);
			}
			if(GIAM == 0){
				inOrde = 0;
                DS1307_Set_Time(&a_sec, &a_min, &a_hour, position, inOrde);
                
                Lcd_Chr(2,1, a_hour/10+0x30);
                Lcd_Chr_Cp(a_hour%10+0x30);
                Lcd_Out_Cp(" : ");
                Lcd_Chr_Cp(a_min/10+0x30);
                Lcd_Chr_Cp(a_min%10+0x30);
                Lcd_Chr_Cp(' ');
                Lcd_Chr_Cp(':');
                Lcd_Chr_Cp(' ');
                Lcd_Chr_Cp(a_sec/10+0x30);
                Lcd_Chr_Cp(a_sec%10+0x30);
                
				if(row == 0){
                    address = 0x80 + position - 1;  
                }
                else{
                    address = 0xC0 + position - 1;
                }
                Lcd_Cmd(address);
                
				while(GIAM == 0);
			}
		}
	}
	
	Lcd_Cmd(_LCD_CURSOR_OFF); // _LCD_CURSOR_OFF
	Lcd_Cmd(_LCD_CLEAR);
}

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=0 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: On
EICRA=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
EIMSK=(1<<INT1) | (1<<INT0);
EIFR=(1<<INTF1) | (1<<INTF0);
PCICR=(1<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
PCMSK2=(1<<PCINT23) | (0<<PCINT22) | (0<<PCINT21) | (0<<PCINT20) | (0<<PCINT19) | (0<<PCINT18) | (0<<PCINT17) | (0<<PCINT16);
PCIFR=(1<<PCIF2) | (0<<PCIF1) | (0<<PCIF0);

// USART initialization
// USART disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
ADCSRB=(0<<ACME);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Globally enable interrupts
#asm("sei")
Lcd_Init();
I2C_Init();

while (1)
      {
        // Place your code here
        display();
        if(year == a_year && month == a_month && date == a_date && hour == a_hour && min >= a_min && sec >= a_sec){
			// CODE CHO ALARM
            
		}
        delay_ms(1000);        
      }
}
