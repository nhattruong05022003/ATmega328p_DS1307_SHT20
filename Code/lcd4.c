#include "lcd4.h"

/*-------------------------------------*-
    Prototype of Local Functions    
-*-------------------------------------*/
void Lcd_Write_High_Nibble(unsigned char);
void Lcd_Write_Low_Nibble(unsigned char );
void Lcd_Delay_us(unsigned char);


/*-------------------------------------*-
    Lcd_Write_High_Nibble - Local Function
-*-------------------------------------*/
void Lcd_Write_High_Nibble(unsigned char b)
{
    LCD_D7 = b & 0x80;
    LCD_D6 = b & 0x40;
    LCD_D5 = b & 0x20;
    LCD_D4 = b & 0x10;     
}

/*-------------------------------------*-
    Lcd_Write_High_Low - Local Function
-*-------------------------------------*/
void Lcd_Write_Low_Nibble(unsigned char b)
{
    LCD_D7 = b & 0x08;
    LCD_D6 = b & 0x04;
    LCD_D5 = b & 0x02;
    LCD_D4 = b & 0x01;
}

/*-------------------------------------*-
    Lcd_Delay_us - Local Function
-*-------------------------------------*/
void Lcd_Delay_us(unsigned char t)
{
     while(t--);
}

/*-------------------------------------*-
    Lcd_Init
    - Khoi tao LCD che do 4 bit, font 5x7
-*-------------------------------------*/
void Lcd_Init()
{    
    LCD_RS = 0;
    LCD_EN = 0;
    LCD_RW = 0;
    
    delay_ms(20);

    Lcd_Write_Low_Nibble(0x03);
    LCD_EN = 1;
    LCD_EN = 0;
    delay_ms(5);

    Lcd_Write_Low_Nibble(0x03);
    LCD_EN = 1;
    LCD_EN = 0;
    delay_us(100);

    Lcd_Write_Low_Nibble(0x03);
    LCD_EN = 1;
    LCD_EN = 0;

    delay_ms(1);


    Lcd_Write_Low_Nibble(0x02);
    LCD_EN = 1;
    LCD_EN = 0;
    delay_ms(1);
        
    Lcd_Cmd(_LCD_4BIT_2LINE_5x7FONT);
    Lcd_Cmd(_LCD_TURN_ON);
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_ENTRY_MODE);
}

/*-------------------------------------*-
    Lcd_Cmd
    - Gui lenh cho LCD
-*-------------------------------------*/
void Lcd_Cmd(unsigned char cmd)
{
    LCD_RW = 0;
    LCD_RS = 0;
    Lcd_Write_High_Nibble(cmd); 
    LCD_EN = 1;
    LCD_EN = 0;

    Lcd_Write_Low_Nibble(cmd);
    LCD_EN = 1;
    LCD_EN = 0;

    switch(cmd)
    {
        case _LCD_CLEAR:
        case _LCD_RETURN_HOME:
            delay_ms(2);
            break;
        default:
            delay_us(37);
            break;
    }
}

/*-------------------------------------*-
    Lcd_Chr_Cp
-*-------------------------------------*/
void Lcd_Chr_Cp(unsigned char achar)
{
    LCD_RW = 0;
    LCD_RS = 1;
    Lcd_Write_High_Nibble(achar);
    LCD_EN = 1;
    LCD_EN = 0;
    
    Lcd_Write_Low_Nibble(achar);
    LCD_EN = 1;
    LCD_EN = 0;
    
    delay_us(37+4);
   
} 

/*-------------------------------------*-
    Lcd_Chr
    - In ky tu ra man hinh tai (row, column)
-*-------------------------------------*/
void Lcd_Chr(unsigned char row, unsigned char column, unsigned char achar)
{
    unsigned char add;
    add = (row==1?0x80:0xC0);
    add += (column - 1);
    Lcd_Cmd(add);
    Lcd_Chr_Cp(achar);
}

void Lcd_Out_Cp(unsigned char * str)
{
    unsigned char i = 0;
    while(str[i])
    {
        Lcd_Chr_Cp(str[i]);
         i++;
    }
}

/*-------------------------------------*-
    Lcd_Out
    - In chuoi (text) ra man hinh
    - Vi tri bat dau tai (row, column)
-*-------------------------------------*/
void Lcd_Out(unsigned char row, unsigned char column, 
    unsigned char* str)
{
    unsigned char add;
    add = (row==1?0x80:0xC0);
    add += (column - 1);
    Lcd_Cmd(add);
    Lcd_Out_Cp(str); 
}

/*-------------------------------------*-
    Lcd_Custom_Chr Function
    - Tao ky tu tren LCD
    - Tham so:
        location: Vi tri tren CGRAM (0ÅÄ7)
        lcd_char: Con tro den mang Font ky tu
    - Ex: Tao ky tu "Clock" sau do in len dong 1, cot 1
        unsigned char code Lcd_Char_Clock[] = {14,21,21,23,17,17,14,0};
        //...
        Lcd_Init();
        Lcd_Custom_Chr(0,Lcd_Char_Clock);
        Lcd_Chr(1,1,0);
        //...
-*-------------------------------------*/
void Lcd_Custom_Chr(unsigned char location, unsigned char * lcd_char) 
{
    unsigned char i;
    Lcd_Cmd(0x40+location*8);
    for (i = 0; i<=7; i++) 
        Lcd_Chr_Cp(lcd_char[i]);
}