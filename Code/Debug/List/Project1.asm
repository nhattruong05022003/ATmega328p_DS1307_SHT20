
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _prev_sec=R4
	.DEF _sec=R3
	.DEF _min=R6
	.DEF _hour=R5
	.DEF _day=R8
	.DEF _date=R7
	.DEF _month=R10
	.DEF _year=R9
	.DEF _a_sec=R12
	.DEF _a_min=R11
	.DEF _a_hour=R14
	.DEF _a_day=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  _pin_change_isr2
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x63,0x63,0x63,0x63

_0x3:
	.DB  0x63
_0x4:
	.DB  0x63
_0x5:
	.DB  0x64
_0x7:
	.DB  LOW(_0x6),HIGH(_0x6),LOW(_0x6+4),HIGH(_0x6+4),LOW(_0x6+8),HIGH(_0x6+8),LOW(_0x6+12),HIGH(_0x6+12)
	.DB  LOW(_0x6+16),HIGH(_0x6+16),LOW(_0x6+20),HIGH(_0x6+20),LOW(_0x6+24),HIGH(_0x6+24)
_0x8:
	.DB  0x1,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x1,0x0,0x0,0x0,0x1,0x0,0x1,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x1
_0x0:
	.DB  0x53,0x61,0x74,0x0,0x53,0x75,0x6E,0x0
	.DB  0x4D,0x6F,0x6E,0x0,0x54,0x75,0x65,0x0
	.DB  0x57,0x65,0x64,0x0,0x54,0x68,0x75,0x0
	.DB  0x46,0x72,0x69,0x0,0x20,0x41,0x4D,0x20
	.DB  0x3A,0x20,0x0,0x20,0x50,0x4D,0x20,0x3A
	.DB  0x20,0x0,0x41,0x4C,0x41,0x52,0x4D,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x0B
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _a_date
	.DW  _0x3*2

	.DW  0x01
	.DW  _a_month
	.DW  _0x4*2

	.DW  0x01
	.DW  _a_year
	.DW  _0x5*2

	.DW  0x04
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x04
	.DW  _0x6+4
	.DW  _0x0*2+4

	.DW  0x04
	.DW  _0x6+8
	.DW  _0x0*2+8

	.DW  0x04
	.DW  _0x6+12
	.DW  _0x0*2+12

	.DW  0x04
	.DW  _0x6+16
	.DW  _0x0*2+16

	.DW  0x04
	.DW  _0x6+20
	.DW  _0x0*2+20

	.DW  0x04
	.DW  _0x6+24
	.DW  _0x0*2+24

	.DW  0x0E
	.DW  _dayOfWeek
	.DW  _0x7*2

	.DW  0x17
	.DW  _dayOfMonth
	.DW  _0x8*2

	.DW  0x07
	.DW  _0xC
	.DW  _0x0*2+28

	.DW  0x07
	.DW  _0xC+7
	.DW  _0x0*2+35

	.DW  0x04
	.DW  _0xC+14
	.DW  _0x0*2+31

	.DW  0x04
	.DW  _0x18
	.DW  _0x0*2+31

	.DW  0x04
	.DW  _0x18+4
	.DW  _0x0*2+31

	.DW  0x04
	.DW  _0x18+8
	.DW  _0x0*2+31

	.DW  0x04
	.DW  _0x4F
	.DW  _0x0*2+31

	.DW  0x04
	.DW  _0x4F+4
	.DW  _0x0*2+31

	.DW  0x04
	.DW  _0x4F+8
	.DW  _0x0*2+31

	.DW  0x06
	.DW  _0x8B
	.DW  _0x0*2+42

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x300

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;unsigned char prev_sec;
;unsigned char sec, min, hour, day, date, month, year;
;unsigned char a_sec = 99, a_min = 99, a_hour = 99, a_day = 99, a_date = 99, a_mo ...

	.DSEG
;unsigned char flag = 0;
;unsigned char* dayOfWeek[] = {"Sat","Sun", "Mon", "Tue", "Wed", "Thu", "Fri"};
_0x6:
	.BYTE 0x1C
;unsigned int dayOfMonth[] = {1,0,1,0,1,0,1,1,0,1,0,1};
;char change_mode = 0;
;unsigned char address;
;unsigned int do_am, nhiet_do;
;void display(){
; 0000 003A void display(){

	.CSEG
_display:
; .FSTART _display
; 0000 003B // CHAY CA 2 TRUOC -> KHONG BI GHI DE DU LIEU KHI XAY RA NGAT
; 0000 003C // tinh toan do am
; 0000 003D #asm("cli")
	CLI
; 0000 003E do_am = (-6 + 125 * (SHT20_Read_RH()*1.0f / 65536));
	CALL _SHT20_Read_RH
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x3F800000
	CALL SUBOPT_0x0
	__GETD2N 0x42FA0000
	CALL __MULF12
	__GETD2N 0xC0C00000
	CALL __ADDF12
	LDI  R26,LOW(_do_am)
	LDI  R27,HIGH(_do_am)
	CALL SUBOPT_0x1
; 0000 003F delay_ms(1);
; 0000 0040 // tinh toan nhiet do
; 0000 0041 nhiet_do = (-46.85 + 0.17572 * (SHT20_Read_T() * 1000.0f / 65536.0)) * 1000;
	CALL _SHT20_Read_T
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x447A0000
	CALL SUBOPT_0x0
	__GETD2N 0x3E33EFF2
	CALL __MULF12
	__GETD2N 0xC23B6666
	CALL __ADDF12
	__GETD2N 0x447A0000
	CALL __MULF12
	LDI  R26,LOW(_nhiet_do)
	LDI  R27,HIGH(_nhiet_do)
	CALL SUBOPT_0x1
; 0000 0042 delay_ms(1);
; 0000 0043 DS1307_Get_Date(&day, &date, &month, &year);
	CALL SUBOPT_0x2
; 0000 0044 delay_ms(1);
	CALL SUBOPT_0x3
; 0000 0045 DS1307_Get_Time(&sec, &min, &hour, &flag);
	CALL SUBOPT_0x4
; 0000 0046 delay_ms(1);
	CALL SUBOPT_0x3
; 0000 0047 #asm("sei")
	SEI
; 0000 0048 
; 0000 0049 if(prev_sec != sec){
	CP   R3,R4
	BRNE PC+2
	RJMP _0x9
; 0000 004A Lcd_Cmd(_LCD_CLEAR);
	LDI  R26,LOW(1)
	CALL _Lcd_Cmd
; 0000 004B if(change_mode < 2){
	LDS  R26,_change_mode
	CPI  R26,LOW(0x2)
	BRSH _0xA
; 0000 004C Lcd_Chr(1,1, date/10+0x30);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 004D Lcd_Chr_Cp(date%10+0x30);
; 0000 004E Lcd_Chr_Cp('/');
; 0000 004F Lcd_Chr_Cp(month/10+0x30);
; 0000 0050 Lcd_Chr_Cp(month%10+0x30);
; 0000 0051 Lcd_Chr_Cp('/');
; 0000 0052 Lcd_Chr_Cp(year/10+0x30);
; 0000 0053 Lcd_Chr_Cp(year%10+0x30);
; 0000 0054 Lcd_Chr_Cp(' ');
; 0000 0055 Lcd_Out_Cp(dayOfWeek[day%7]);
	CALL SUBOPT_0x7
; 0000 0056 
; 0000 0057 
; 0000 0058 Lcd_Chr(2,1, hour/10+0x30);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0059 Lcd_Chr_Cp(hour%10+0x30);
; 0000 005A if(flag == 1)
	LDS  R26,_flag
	CPI  R26,LOW(0x1)
	BRNE _0xB
; 0000 005B Lcd_Out_Cp(" AM : ");
	__POINTW2MN _0xC,0
	RJMP _0x96
; 0000 005C else if (flag == 2)
_0xB:
	LDS  R26,_flag
	CPI  R26,LOW(0x2)
	BRNE _0xE
; 0000 005D Lcd_Out_Cp(" PM : ");
	__POINTW2MN _0xC,7
	RJMP _0x96
; 0000 005E else
_0xE:
; 0000 005F Lcd_Out_Cp(" : ");
	__POINTW2MN _0xC,14
_0x96:
	CALL _Lcd_Out_Cp
; 0000 0060 Lcd_Chr_Cp(min/10+0x30);
	CALL SUBOPT_0xA
; 0000 0061 Lcd_Chr_Cp(min%10+0x30);
; 0000 0062 Lcd_Chr_Cp(' ');
; 0000 0063 Lcd_Chr_Cp(':');
; 0000 0064 Lcd_Chr_Cp(' ');
; 0000 0065 Lcd_Chr_Cp(sec/10+0x30);
; 0000 0066 Lcd_Chr_Cp(sec%10+0x30);
	RJMP _0x97
; 0000 0067 }
; 0000 0068 else{
_0xA:
; 0000 0069 
; 0000 006A Lcd_Chr(1,1,nhiet_do/10000 + 0x30);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 006B Lcd_Chr_Cp(nhiet_do/1000 % 10 + 0x30);
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
; 0000 006C Lcd_Chr_Cp('.');
	LDI  R26,LOW(46)
	CALL SUBOPT_0xE
; 0000 006D Lcd_Chr_Cp(nhiet_do/100 % 10 + 0x30);
	CALL SUBOPT_0xF
	CALL SUBOPT_0xE
; 0000 006E Lcd_Chr_Cp(nhiet_do/10 % 10 + 0x30);
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
; 0000 006F Lcd_Chr_Cp(nhiet_do%10 + 0x30);
	CALL SUBOPT_0x11
; 0000 0070 Lcd_Chr_Cp('C');
	LDI  R26,LOW(67)
	CALL _Lcd_Chr_Cp
; 0000 0071 
; 0000 0072 Lcd_Chr(2,1,do_am/10000 + 0x30);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x12
	CALL SUBOPT_0xC
; 0000 0073 Lcd_Chr_Cp(do_am/1000 % 10 + 0x30);
	CALL SUBOPT_0x12
	CALL SUBOPT_0xD
; 0000 0074 Lcd_Chr_Cp(do_am/100 % 10 + 0x30);
	CALL SUBOPT_0x12
	CALL SUBOPT_0xF
	CALL _Lcd_Chr_Cp
; 0000 0075 Lcd_Chr_Cp(do_am/10 % 10 + 0x30);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
	CALL _Lcd_Chr_Cp
; 0000 0076 Lcd_Chr_Cp(do_am%10 + 0x30);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
; 0000 0077 Lcd_Chr_Cp('%');
	LDI  R26,LOW(37)
_0x97:
	CALL _Lcd_Chr_Cp
; 0000 0078 }
; 0000 0079 }
; 0000 007A prev_sec = sec;
_0x9:
	MOV  R4,R3
; 0000 007B }
	RET
; .FEND

	.DSEG
_0xC:
	.BYTE 0x12
;interrupt [PC_INT2] void pin_change_isr2(void)
; 0000 0080 {

	.CSEG
_pin_change_isr2:
; .FSTART _pin_change_isr2
	CALL SUBOPT_0x13
; 0000 0081 // Place your code here
; 0000 0082 delay_ms(20);
	CALL SUBOPT_0x14
; 0000 0083 while(MODE == 0);
_0x11:
	SBIS 0x9,7
	RJMP _0x11
; 0000 0084 if(change_mode == 2){
	LDS  R26,_change_mode
	CPI  R26,LOW(0x2)
	BRNE _0x14
; 0000 0085 change_mode = -1;
	LDI  R30,LOW(255)
	STS  _change_mode,R30
; 0000 0086 adjust();
	RJMP _0x98
; 0000 0087 }
; 0000 0088 else if(change_mode == 0){
_0x14:
	LDS  R30,_change_mode
	CPI  R30,0
	BRNE _0x16
; 0000 0089 adjust();
_0x98:
	RCALL _adjust
; 0000 008A }
; 0000 008B Lcd_Cmd(_LCD_CLEAR);
_0x16:
	LDI  R26,LOW(1)
	CALL _Lcd_Cmd
; 0000 008C change_mode ++;
	LDS  R30,_change_mode
	SUBI R30,-LOW(1)
	STS  _change_mode,R30
; 0000 008D delay_ms(50);
	CALL SUBOPT_0x15
; 0000 008E Lcd_Cmd(_LCD_CLEAR);
	LDI  R26,LOW(1)
	CALL _Lcd_Cmd
; 0000 008F }
	RJMP _0xA5
; .FEND
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0094 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x13
; 0000 0095 // Place your code here
; 0000 0096 // Bien thay doi vi tri
; 0000 0097 int inOrde;
; 0000 0098 int position = 1;
; 0000 0099 unsigned char row = 0;
; 0000 009A unsigned char max_day = 30;
; 0000 009B 
; 0000 009C // Bien dung doi sang bcd
; 0000 009D unsigned char bcd_convert;
; 0000 009E unsigned char t;
; 0000 009F 
; 0000 00A0 delay_ms(20);
	SBIW R28,2
	CALL SUBOPT_0x16
;	inOrde -> R16,R17
;	position -> R18,R19
;	row -> R21
;	max_day -> R20
;	bcd_convert -> Y+7
;	t -> Y+6
; 0000 00A1 if(change_mode != 0){
	LDS  R30,_change_mode
	CPI  R30,0
	BREQ _0x17
; 0000 00A2 //        if(change_mode == 1){
; 0000 00A3 //            adjust();
; 0000 00A4 //        }
; 0000 00A5 //        else{
; 0000 00A6 //            adjust();
; 0000 00A7 //        }
; 0000 00A8 adjust();
	CALL SUBOPT_0x17
; 0000 00A9 flag = 0;
; 0000 00AA change_mode = 0;
; 0000 00AB }
; 0000 00AC 
; 0000 00AD Lcd_Cmd(_LCD_CLEAR);
_0x17:
	LDI  R26,LOW(1)
	CALL _Lcd_Cmd
; 0000 00AE 
; 0000 00AF DS1307_Get_Date(&day, &date, &month, &year);
	CALL SUBOPT_0x2
; 0000 00B0 Lcd_Chr(1,1, date/10+0x30);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 00B1 Lcd_Chr_Cp(date%10+0x30);
; 0000 00B2 Lcd_Chr_Cp('/');
; 0000 00B3 Lcd_Chr_Cp(month/10+0x30);
; 0000 00B4 Lcd_Chr_Cp(month%10+0x30);
; 0000 00B5 Lcd_Chr_Cp('/');
; 0000 00B6 Lcd_Chr_Cp(year/10+0x30);
; 0000 00B7 Lcd_Chr_Cp(year%10+0x30);
; 0000 00B8 Lcd_Chr_Cp(' ');
; 0000 00B9 Lcd_Out_Cp(dayOfWeek[day%7]);
	CALL SUBOPT_0x7
; 0000 00BA 
; 0000 00BB DS1307_Get_Time(&sec, &min, &hour, &flag);
	CALL SUBOPT_0x4
; 0000 00BC Lcd_Chr(2,1, hour/10+0x30);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00BD Lcd_Chr_Cp(hour%10+0x30);
; 0000 00BE Lcd_Out_Cp(" : ");
	__POINTW2MN _0x18,0
	CALL SUBOPT_0x18
; 0000 00BF Lcd_Chr_Cp(min/10+0x30);
; 0000 00C0 Lcd_Chr_Cp(min%10+0x30);
; 0000 00C1 Lcd_Chr_Cp(' ');
; 0000 00C2 Lcd_Chr_Cp(':');
; 0000 00C3 Lcd_Chr_Cp(' ');
; 0000 00C4 Lcd_Chr_Cp(sec/10+0x30);
; 0000 00C5 Lcd_Chr_Cp(sec%10+0x30);
	CALL _Lcd_Chr_Cp
; 0000 00C6 
; 0000 00C7 Lcd_Cmd(_LCD_FIRST_ROW); // _LCD_FIRST_ROW
	CALL SUBOPT_0x19
; 0000 00C8 Lcd_Cmd(_LCD_BLINK_CURSOR_ON); // _LCD_BLINK_CURSOR_ON
; 0000 00C9 position = 1;
; 0000 00CA while(CHANGE_MODE == 0){
_0x19:
	SBIC 0x9,2
	RJMP _0x1B
; 0000 00CB if(LEN == 0){
	SBIC 0x9,5
	RJMP _0x1C
; 0000 00CC delay_ms(20);
	CALL SUBOPT_0x14
; 0000 00CD row = 0;
	CALL SUBOPT_0x1A
; 0000 00CE 
; 0000 00CF address = 0x80 + position - 1;
; 0000 00D0 Lcd_Cmd(address);
; 0000 00D1 
; 0000 00D2 while(LEN == 0);
_0x1D:
	SBIS 0x9,5
	RJMP _0x1D
; 0000 00D3 }
; 0000 00D4 if(XUONG == 0){
_0x1C:
	SBIC 0x9,6
	RJMP _0x20
; 0000 00D5 delay_ms(20);
	CALL SUBOPT_0x14
; 0000 00D6 row = 1;
	CALL SUBOPT_0x1B
; 0000 00D7 
; 0000 00D8 address = 0xC0 + position - 1;
; 0000 00D9 Lcd_Cmd(address);
; 0000 00DA 
; 0000 00DB while(XUONG == 0);
_0x21:
	SBIS 0x9,6
	RJMP _0x21
; 0000 00DC }
; 0000 00DD if(RIGHT == 0){
_0x20:
	SBIC 0x9,4
	RJMP _0x24
; 0000 00DE delay_ms(20);
	CALL SUBOPT_0x14
; 0000 00DF if(position > 0){
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRGE _0x25
; 0000 00E0 position ++;
	__ADDWRN 18,19,1
; 0000 00E1 if(row == 0){
	CPI  R21,0
	BRNE _0x26
; 0000 00E2 address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0x99
; 0000 00E3 }
; 0000 00E4 else{
_0x26:
; 0000 00E5 address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0x99:
	STS  _address,R30
; 0000 00E6 }
; 0000 00E7 if(position <= 16){
	__CPWRN 18,19,17
	BRGE _0x28
; 0000 00E8 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 00E9 }
; 0000 00EA }
_0x28:
; 0000 00EB while(RIGHT == 0);
_0x25:
_0x29:
	SBIS 0x9,4
	RJMP _0x29
; 0000 00EC }
; 0000 00ED if(LEFT == 0){
_0x24:
	SBIC 0x6,3
	RJMP _0x2C
; 0000 00EE delay_ms(20);
	CALL SUBOPT_0x14
; 0000 00EF if(position > 1){
	__CPWRN 18,19,2
	BRLT _0x2D
; 0000 00F0 position --;
	__SUBWRN 18,19,1
; 0000 00F1 if(position < 1)
	__CPWRN 18,19,1
	BRGE _0x2E
; 0000 00F2 position = 1;
	__GETWRN 18,19,1
; 0000 00F3 if(row == 0){
_0x2E:
	CPI  R21,0
	BRNE _0x2F
; 0000 00F4 address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0x9A
; 0000 00F5 }
; 0000 00F6 else{
_0x2F:
; 0000 00F7 address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0x9A:
	STS  _address,R30
; 0000 00F8 }
; 0000 00F9 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 00FA }
; 0000 00FB while(LEFT == 0);
_0x2D:
_0x31:
	SBIS 0x6,3
	RJMP _0x31
; 0000 00FC }
; 0000 00FD 
; 0000 00FE 
; 0000 00FF 
; 0000 0100 if(row == 0){
_0x2C:
	CPI  R21,0
	BRNE _0x34
; 0000 0101 max_day = dayOfMonth[month-1] + 30;
	CALL SUBOPT_0x1D
; 0000 0102 if(TANG == 0){
	SBIC 0x6,1
	RJMP _0x35
; 0000 0103 inOrde = 1;
	__GETWRN 16,17,1
; 0000 0104 DS1307_Set_Date(&day, &date, &month, &year, max_day, position, inOrde);
	CALL SUBOPT_0x1E
; 0000 0105 
; 0000 0106 Lcd_Chr(1,1, date/10+0x30);
	CALL SUBOPT_0x6
; 0000 0107 Lcd_Chr_Cp(date%10+0x30);
; 0000 0108 Lcd_Chr_Cp('/');
; 0000 0109 Lcd_Chr_Cp(month/10+0x30);
; 0000 010A Lcd_Chr_Cp(month%10+0x30);
; 0000 010B Lcd_Chr_Cp('/');
; 0000 010C Lcd_Chr_Cp(year/10+0x30);
; 0000 010D Lcd_Chr_Cp(year%10+0x30);
; 0000 010E Lcd_Chr_Cp(' ');
; 0000 010F Lcd_Out_Cp(dayOfWeek[day%7]);
	CALL SUBOPT_0x7
; 0000 0110 
; 0000 0111 if(row == 0){
	CPI  R21,0
	BRNE _0x36
; 0000 0112 address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0x9B
; 0000 0113 }
; 0000 0114 else{
_0x36:
; 0000 0115 address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0x9B:
	STS  _address,R30
; 0000 0116 }
; 0000 0117 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 0118 
; 0000 0119 while(TANG == 0);
_0x38:
	SBIS 0x6,1
	RJMP _0x38
; 0000 011A }
; 0000 011B 
; 0000 011C if(GIAM == 0){
_0x35:
	SBIC 0x6,2
	RJMP _0x3B
; 0000 011D inOrde = 0;
	__GETWRN 16,17,0
; 0000 011E DS1307_Set_Date(&day, &date, &month, &year, max_day, position, inOrde);
	CALL SUBOPT_0x1E
; 0000 011F 
; 0000 0120 Lcd_Chr(1,1, date/10+0x30);
	CALL SUBOPT_0x6
; 0000 0121 Lcd_Chr_Cp(date%10+0x30);
; 0000 0122 Lcd_Chr_Cp('/');
; 0000 0123 Lcd_Chr_Cp(month/10+0x30);
; 0000 0124 Lcd_Chr_Cp(month%10+0x30);
; 0000 0125 Lcd_Chr_Cp('/');
; 0000 0126 Lcd_Chr_Cp(year/10+0x30);
; 0000 0127 Lcd_Chr_Cp(year%10+0x30);
; 0000 0128 Lcd_Chr_Cp(' ');
; 0000 0129 Lcd_Out_Cp(dayOfWeek[day%7]);
	CALL SUBOPT_0x7
; 0000 012A 
; 0000 012B if(row == 0){
	CPI  R21,0
	BRNE _0x3C
; 0000 012C address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0x9C
; 0000 012D }
; 0000 012E else{
_0x3C:
; 0000 012F address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0x9C:
	STS  _address,R30
; 0000 0130 }
; 0000 0131 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 0132 
; 0000 0133 while(GIAM == 0);
_0x3E:
	SBIS 0x6,2
	RJMP _0x3E
; 0000 0134 }
; 0000 0135 }
_0x3B:
; 0000 0136 
; 0000 0137 else{
	RJMP _0x41
_0x34:
; 0000 0138 if(TANG == 0){
	SBIC 0x6,1
	RJMP _0x42
; 0000 0139 inOrde = 1;
	__GETWRN 16,17,1
; 0000 013A DS1307_Set_Time(&sec, &min, &hour, position, inOrde);
	CALL SUBOPT_0x1F
; 0000 013B 
; 0000 013C Lcd_Chr(2,1, hour/10+0x30);
	CALL SUBOPT_0x9
; 0000 013D Lcd_Chr_Cp(hour%10+0x30);
; 0000 013E Lcd_Out_Cp(" : ");
	__POINTW2MN _0x18,4
	CALL SUBOPT_0x18
; 0000 013F Lcd_Chr_Cp(min/10+0x30);
; 0000 0140 Lcd_Chr_Cp(min%10+0x30);
; 0000 0141 Lcd_Chr_Cp(' ');
; 0000 0142 Lcd_Chr_Cp(':');
; 0000 0143 Lcd_Chr_Cp(' ');
; 0000 0144 Lcd_Chr_Cp(sec/10+0x30);
; 0000 0145 Lcd_Chr_Cp(sec%10+0x30);
	CALL _Lcd_Chr_Cp
; 0000 0146 
; 0000 0147 if(row == 0){
	CPI  R21,0
	BRNE _0x43
; 0000 0148 address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0x9D
; 0000 0149 }
; 0000 014A else{
_0x43:
; 0000 014B address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0x9D:
	STS  _address,R30
; 0000 014C }
; 0000 014D Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 014E 
; 0000 014F while(TANG == 0);
_0x45:
	SBIS 0x6,1
	RJMP _0x45
; 0000 0150 }
; 0000 0151 if(GIAM == 0){
_0x42:
	SBIC 0x6,2
	RJMP _0x48
; 0000 0152 inOrde = 0;
	__GETWRN 16,17,0
; 0000 0153 DS1307_Set_Time(&sec, &min, &hour, position, inOrde);
	CALL SUBOPT_0x1F
; 0000 0154 
; 0000 0155 Lcd_Chr(2,1, hour/10+0x30);
	CALL SUBOPT_0x9
; 0000 0156 Lcd_Chr_Cp(hour%10+0x30);
; 0000 0157 Lcd_Out_Cp(" : ");
	__POINTW2MN _0x18,8
	CALL SUBOPT_0x18
; 0000 0158 Lcd_Chr_Cp(min/10+0x30);
; 0000 0159 Lcd_Chr_Cp(min%10+0x30);
; 0000 015A Lcd_Chr_Cp(' ');
; 0000 015B Lcd_Chr_Cp(':');
; 0000 015C Lcd_Chr_Cp(' ');
; 0000 015D Lcd_Chr_Cp(sec/10+0x30);
; 0000 015E Lcd_Chr_Cp(sec%10+0x30);
	CALL _Lcd_Chr_Cp
; 0000 015F 
; 0000 0160 if(row == 0){
	CPI  R21,0
	BRNE _0x49
; 0000 0161 address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0x9E
; 0000 0162 }
; 0000 0163 else{
_0x49:
; 0000 0164 address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0x9E:
	STS  _address,R30
; 0000 0165 }
; 0000 0166 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 0167 
; 0000 0168 while(GIAM == 0);
_0x4B:
	SBIS 0x6,2
	RJMP _0x4B
; 0000 0169 }
; 0000 016A }
_0x48:
_0x41:
; 0000 016B }
	RJMP _0x19
_0x1B:
; 0000 016C 
; 0000 016D // Doi sang BCD r chuyen cho DS1307
; 0000 016E t = sec;
	__PUTBSR 3,6
; 0000 016F bcd_convert = t / 10;
	CALL SUBOPT_0x20
; 0000 0170 bcd_convert <<= 4;
; 0000 0171 bcd_convert |= t%10;
; 0000 0172 DS1307_Receive(0, bcd_convert);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x21
; 0000 0173 
; 0000 0174 t = min;
	__PUTBSR 6,6
; 0000 0175 bcd_convert = t / 10;
	CALL SUBOPT_0x20
; 0000 0176 bcd_convert <<= 4;
; 0000 0177 bcd_convert |= t%10;
; 0000 0178 DS1307_Receive(1, bcd_convert);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x21
; 0000 0179 
; 0000 017A t = hour;
	__PUTBSR 5,6
; 0000 017B bcd_convert = t / 10;
	CALL SUBOPT_0x20
; 0000 017C bcd_convert <<= 4;
; 0000 017D bcd_convert |= t%10;
; 0000 017E DS1307_Receive(2, bcd_convert);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x21
; 0000 017F 
; 0000 0180 t = day;
	__PUTBSR 8,6
; 0000 0181 bcd_convert = t / 10;
	CALL SUBOPT_0x20
; 0000 0182 bcd_convert <<= 4;
; 0000 0183 bcd_convert |= t%10;
; 0000 0184 DS1307_Receive(3, bcd_convert);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x21
; 0000 0185 
; 0000 0186 t = date;
	__PUTBSR 7,6
; 0000 0187 bcd_convert = t / 10;
	CALL SUBOPT_0x20
; 0000 0188 bcd_convert <<= 4;
; 0000 0189 bcd_convert |= t%10;
; 0000 018A DS1307_Receive(4, bcd_convert);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x21
; 0000 018B 
; 0000 018C t = month;
	__PUTBSR 10,6
; 0000 018D bcd_convert = t / 10;
	CALL SUBOPT_0x20
; 0000 018E bcd_convert <<= 4;
; 0000 018F bcd_convert |= t%10;
; 0000 0190 DS1307_Receive(5, bcd_convert);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x21
; 0000 0191 
; 0000 0192 t = year;
	__PUTBSR 9,6
; 0000 0193 bcd_convert = t / 10;
	CALL SUBOPT_0x20
; 0000 0194 bcd_convert <<= 4;
; 0000 0195 bcd_convert |= t%10;
; 0000 0196 DS1307_Receive(6, bcd_convert);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x21
; 0000 0197 
; 0000 0198 Lcd_Cmd(_LCD_CURSOR_OFF); // _LCD_CURSOR_OFF
	CALL SUBOPT_0x22
; 0000 0199 Lcd_Cmd(_LCD_CLEAR);
; 0000 019A }
	ADIW R28,8
	RJMP _0xA5
; .FEND

	.DSEG
_0x18:
	.BYTE 0xC
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 019F {

	.CSEG
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x13
; 0000 01A0 // Place your code here
; 0000 01A1 // Bien thay doi vi tri
; 0000 01A2 int inOrde;
; 0000 01A3 int position = 1;
; 0000 01A4 unsigned char row = 0;
; 0000 01A5 unsigned char max_day = 30;
; 0000 01A6 
; 0000 01A7 
; 0000 01A8 delay_ms(20);
	CALL SUBOPT_0x16
;	inOrde -> R16,R17
;	position -> R18,R19
;	row -> R21
;	max_day -> R20
; 0000 01A9 if(change_mode != 0){
	LDS  R30,_change_mode
	CPI  R30,0
	BREQ _0x4E
; 0000 01AA adjust();
	CALL SUBOPT_0x17
; 0000 01AB flag = 0;
; 0000 01AC change_mode = 0;
; 0000 01AD }
; 0000 01AE 
; 0000 01AF Lcd_Cmd(_LCD_CLEAR);
_0x4E:
	LDI  R26,LOW(1)
	CALL _Lcd_Cmd
; 0000 01B0 
; 0000 01B1 DS1307_Get_Date(&day, &date, &month, &year);
	CALL SUBOPT_0x2
; 0000 01B2 Lcd_Chr(1,1, date/10+0x30);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 01B3 Lcd_Chr_Cp(date%10+0x30);
; 0000 01B4 Lcd_Chr_Cp('/');
; 0000 01B5 Lcd_Chr_Cp(month/10+0x30);
; 0000 01B6 Lcd_Chr_Cp(month%10+0x30);
; 0000 01B7 Lcd_Chr_Cp('/');
; 0000 01B8 Lcd_Chr_Cp(year/10+0x30);
; 0000 01B9 Lcd_Chr_Cp(year%10+0x30);
; 0000 01BA Lcd_Chr_Cp(' ');
; 0000 01BB Lcd_Out_Cp(dayOfWeek[day%7]);
	CALL SUBOPT_0x7
; 0000 01BC 
; 0000 01BD DS1307_Get_Time(&sec, &min, &hour, &flag);
	CALL SUBOPT_0x4
; 0000 01BE Lcd_Chr(2,1, hour/10+0x30);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 01BF Lcd_Chr_Cp(hour%10+0x30);
; 0000 01C0 Lcd_Out_Cp(" : ");
	__POINTW2MN _0x4F,0
	CALL SUBOPT_0x18
; 0000 01C1 Lcd_Chr_Cp(min/10+0x30);
; 0000 01C2 Lcd_Chr_Cp(min%10+0x30);
; 0000 01C3 Lcd_Chr_Cp(' ');
; 0000 01C4 Lcd_Chr_Cp(':');
; 0000 01C5 Lcd_Chr_Cp(' ');
; 0000 01C6 Lcd_Chr_Cp(sec/10+0x30);
; 0000 01C7 Lcd_Chr_Cp(sec%10+0x30);
	CALL _Lcd_Chr_Cp
; 0000 01C8 
; 0000 01C9 a_sec = sec;
	MOV  R12,R3
; 0000 01CA a_min = min;
	MOV  R11,R6
; 0000 01CB a_hour = hour;
	MOV  R14,R5
; 0000 01CC a_day = day;
	MOV  R13,R8
; 0000 01CD a_date = date;
	STS  _a_date,R7
; 0000 01CE a_month = month;
	STS  _a_month,R10
; 0000 01CF a_year = year;
	STS  _a_year,R9
; 0000 01D0 
; 0000 01D1 Lcd_Cmd(_LCD_FIRST_ROW); // _LCD_FIRST_ROW
	CALL SUBOPT_0x19
; 0000 01D2 Lcd_Cmd(_LCD_BLINK_CURSOR_ON); // _LCD_BLINK_CURSOR_ON
; 0000 01D3 position = 1;
; 0000 01D4 while(ALARM_MODE == 0){
_0x50:
	SBIC 0x9,3
	RJMP _0x52
; 0000 01D5 if(LEN == 0){
	SBIC 0x9,5
	RJMP _0x53
; 0000 01D6 delay_ms(20);
	CALL SUBOPT_0x14
; 0000 01D7 row = 0;
	CALL SUBOPT_0x1A
; 0000 01D8 
; 0000 01D9 address = 0x80 + position - 1;
; 0000 01DA Lcd_Cmd(address);
; 0000 01DB 
; 0000 01DC while(LEN == 0);
_0x54:
	SBIS 0x9,5
	RJMP _0x54
; 0000 01DD }
; 0000 01DE if(XUONG == 0){
_0x53:
	SBIC 0x9,6
	RJMP _0x57
; 0000 01DF delay_ms(20);
	CALL SUBOPT_0x14
; 0000 01E0 row = 1;
	CALL SUBOPT_0x1B
; 0000 01E1 
; 0000 01E2 address = 0xC0 + position - 1;
; 0000 01E3 Lcd_Cmd(address);
; 0000 01E4 
; 0000 01E5 while(XUONG == 0);
_0x58:
	SBIS 0x9,6
	RJMP _0x58
; 0000 01E6 }
; 0000 01E7 if(RIGHT == 0){
_0x57:
	SBIC 0x9,4
	RJMP _0x5B
; 0000 01E8 delay_ms(20);
	CALL SUBOPT_0x14
; 0000 01E9 if(position > 0){
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRGE _0x5C
; 0000 01EA position ++;
	__ADDWRN 18,19,1
; 0000 01EB if(row == 0){
	CPI  R21,0
	BRNE _0x5D
; 0000 01EC address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0x9F
; 0000 01ED }
; 0000 01EE else{
_0x5D:
; 0000 01EF address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0x9F:
	STS  _address,R30
; 0000 01F0 }
; 0000 01F1 if(position <= 16){
	__CPWRN 18,19,17
	BRGE _0x5F
; 0000 01F2 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 01F3 }
; 0000 01F4 }
_0x5F:
; 0000 01F5 while(RIGHT == 0);
_0x5C:
_0x60:
	SBIS 0x9,4
	RJMP _0x60
; 0000 01F6 }
; 0000 01F7 if(LEFT == 0){
_0x5B:
	SBIC 0x6,3
	RJMP _0x63
; 0000 01F8 delay_ms(20);
	CALL SUBOPT_0x14
; 0000 01F9 if(position > 1){
	__CPWRN 18,19,2
	BRLT _0x64
; 0000 01FA position --;
	__SUBWRN 18,19,1
; 0000 01FB if(position < 1)
	__CPWRN 18,19,1
	BRGE _0x65
; 0000 01FC position = 1;
	__GETWRN 18,19,1
; 0000 01FD if(row == 0){
_0x65:
	CPI  R21,0
	BRNE _0x66
; 0000 01FE address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0xA0
; 0000 01FF }
; 0000 0200 else{
_0x66:
; 0000 0201 address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0xA0:
	STS  _address,R30
; 0000 0202 }
; 0000 0203 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 0204 }
; 0000 0205 while(LEFT == 0);
_0x64:
_0x68:
	SBIS 0x6,3
	RJMP _0x68
; 0000 0206 }
; 0000 0207 
; 0000 0208 
; 0000 0209 
; 0000 020A if(row == 0){
_0x63:
	CPI  R21,0
	BRNE _0x6B
; 0000 020B max_day = dayOfMonth[month-1] + 30;
	CALL SUBOPT_0x1D
; 0000 020C if(TANG == 0){
	SBIC 0x6,1
	RJMP _0x6C
; 0000 020D inOrde = 1;
	__GETWRN 16,17,1
; 0000 020E DS1307_Set_Date(&a_day, &a_date, &a_month, &a_year, max_day, position, inOrde);
	CALL SUBOPT_0x23
; 0000 020F 
; 0000 0210 Lcd_Chr(1,1, a_date/10+0x30);
	CALL SUBOPT_0x24
; 0000 0211 Lcd_Chr_Cp(a_date%10+0x30);
; 0000 0212 Lcd_Chr_Cp('/');
; 0000 0213 Lcd_Chr_Cp(a_month/10+0x30);
; 0000 0214 Lcd_Chr_Cp(a_month%10+0x30);
; 0000 0215 Lcd_Chr_Cp('/');
; 0000 0216 Lcd_Chr_Cp(a_year/10+0x30);
; 0000 0217 Lcd_Chr_Cp(a_year%10+0x30);
; 0000 0218 Lcd_Chr_Cp(' ');
; 0000 0219 Lcd_Out_Cp(dayOfWeek[a_day%7]);
	CALL SUBOPT_0x7
; 0000 021A 
; 0000 021B if(row == 0){
	CPI  R21,0
	BRNE _0x6D
; 0000 021C address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0xA1
; 0000 021D }
; 0000 021E else{
_0x6D:
; 0000 021F address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0xA1:
	STS  _address,R30
; 0000 0220 }
; 0000 0221 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 0222 
; 0000 0223 while(TANG == 0);
_0x6F:
	SBIS 0x6,1
	RJMP _0x6F
; 0000 0224 }
; 0000 0225 
; 0000 0226 if(GIAM == 0){
_0x6C:
	SBIC 0x6,2
	RJMP _0x72
; 0000 0227 inOrde = 0;
	__GETWRN 16,17,0
; 0000 0228 DS1307_Set_Date(&a_day, &a_date, &a_month, &a_year, max_day, position, inOrde);
	CALL SUBOPT_0x23
; 0000 0229 
; 0000 022A Lcd_Chr(1,1, a_date/10+0x30);
	CALL SUBOPT_0x24
; 0000 022B Lcd_Chr_Cp(a_date%10+0x30);
; 0000 022C Lcd_Chr_Cp('/');
; 0000 022D Lcd_Chr_Cp(a_month/10+0x30);
; 0000 022E Lcd_Chr_Cp(a_month%10+0x30);
; 0000 022F Lcd_Chr_Cp('/');
; 0000 0230 Lcd_Chr_Cp(a_year/10+0x30);
; 0000 0231 Lcd_Chr_Cp(a_year%10+0x30);
; 0000 0232 Lcd_Chr_Cp(' ');
; 0000 0233 Lcd_Out_Cp(dayOfWeek[a_day%7]);
	CALL SUBOPT_0x7
; 0000 0234 
; 0000 0235 if(row == 0){
	CPI  R21,0
	BRNE _0x73
; 0000 0236 address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0xA2
; 0000 0237 }
; 0000 0238 else{
_0x73:
; 0000 0239 address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0xA2:
	STS  _address,R30
; 0000 023A }
; 0000 023B Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 023C 
; 0000 023D while(GIAM == 0);
_0x75:
	SBIS 0x6,2
	RJMP _0x75
; 0000 023E }
; 0000 023F }
_0x72:
; 0000 0240 
; 0000 0241 else{
	RJMP _0x78
_0x6B:
; 0000 0242 if(TANG == 0){
	SBIC 0x6,1
	RJMP _0x79
; 0000 0243 inOrde = 1;
	__GETWRN 16,17,1
; 0000 0244 DS1307_Set_Time(&a_sec, &a_min, &a_hour, position, inOrde);
	CALL SUBOPT_0x25
; 0000 0245 
; 0000 0246 Lcd_Chr(2,1, a_hour/10+0x30);
	CALL SUBOPT_0x26
; 0000 0247 Lcd_Chr_Cp(a_hour%10+0x30);
; 0000 0248 Lcd_Out_Cp(" : ");
	__POINTW2MN _0x4F,4
	CALL SUBOPT_0x27
; 0000 0249 Lcd_Chr_Cp(a_min/10+0x30);
; 0000 024A Lcd_Chr_Cp(a_min%10+0x30);
; 0000 024B Lcd_Chr_Cp(' ');
; 0000 024C Lcd_Chr_Cp(':');
; 0000 024D Lcd_Chr_Cp(' ');
; 0000 024E Lcd_Chr_Cp(a_sec/10+0x30);
; 0000 024F Lcd_Chr_Cp(a_sec%10+0x30);
; 0000 0250 
; 0000 0251 if(row == 0){
	BRNE _0x7A
; 0000 0252 address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0xA3
; 0000 0253 }
; 0000 0254 else{
_0x7A:
; 0000 0255 address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0xA3:
	STS  _address,R30
; 0000 0256 }
; 0000 0257 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 0258 
; 0000 0259 while(TANG == 0);
_0x7C:
	SBIS 0x6,1
	RJMP _0x7C
; 0000 025A }
; 0000 025B if(GIAM == 0){
_0x79:
	SBIC 0x6,2
	RJMP _0x7F
; 0000 025C inOrde = 0;
	__GETWRN 16,17,0
; 0000 025D DS1307_Set_Time(&a_sec, &a_min, &a_hour, position, inOrde);
	CALL SUBOPT_0x25
; 0000 025E 
; 0000 025F Lcd_Chr(2,1, a_hour/10+0x30);
	CALL SUBOPT_0x26
; 0000 0260 Lcd_Chr_Cp(a_hour%10+0x30);
; 0000 0261 Lcd_Out_Cp(" : ");
	__POINTW2MN _0x4F,8
	CALL SUBOPT_0x27
; 0000 0262 Lcd_Chr_Cp(a_min/10+0x30);
; 0000 0263 Lcd_Chr_Cp(a_min%10+0x30);
; 0000 0264 Lcd_Chr_Cp(' ');
; 0000 0265 Lcd_Chr_Cp(':');
; 0000 0266 Lcd_Chr_Cp(' ');
; 0000 0267 Lcd_Chr_Cp(a_sec/10+0x30);
; 0000 0268 Lcd_Chr_Cp(a_sec%10+0x30);
; 0000 0269 
; 0000 026A if(row == 0){
	BRNE _0x80
; 0000 026B address = 0x80 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(127)
	RJMP _0xA4
; 0000 026C }
; 0000 026D else{
_0x80:
; 0000 026E address = 0xC0 + position - 1;
	MOV  R30,R18
	SUBI R30,-LOW(191)
_0xA4:
	STS  _address,R30
; 0000 026F }
; 0000 0270 Lcd_Cmd(address);
	CALL SUBOPT_0x1C
; 0000 0271 
; 0000 0272 while(GIAM == 0);
_0x82:
	SBIS 0x6,2
	RJMP _0x82
; 0000 0273 }
; 0000 0274 }
_0x7F:
_0x78:
; 0000 0275 }
	RJMP _0x50
_0x52:
; 0000 0276 
; 0000 0277 Lcd_Cmd(_LCD_CURSOR_OFF); // _LCD_CURSOR_OFF
	CALL SUBOPT_0x22
; 0000 0278 Lcd_Cmd(_LCD_CLEAR);
; 0000 0279 }
	ADIW R28,6
_0xA5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x4F:
	.BYTE 0xC
;void main(void)
; 0000 027C {

	.CSEG
_main:
; .FSTART _main
; 0000 027D // Declare your local variables here
; 0000 027E 
; 0000 027F // Crystal Oscillator division factor: 1
; 0000 0280 #pragma optsize-
; 0000 0281 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0282 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0283 #ifdef _OPTIMIZE_SIZE_
; 0000 0284 #pragma optsize+
; 0000 0285 #endif
; 0000 0286 
; 0000 0287 // Input/Output Ports initialization
; 0000 0288 // Port B initialization
; 0000 0289 // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=O ...
; 0000 028A DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1< ...
	LDI  R30,LOW(63)
	OUT  0x4,R30
; 0000 028B // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 028C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<< ...
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 028D 
; 0000 028E // Port C initialization
; 0000 028F // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 0290 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1< ...
	LDI  R30,LOW(1)
	OUT  0x7,R30
; 0000 0291 // State: Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=0
; 0000 0292 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<< ...
	LDI  R30,LOW(14)
	OUT  0x8,R30
; 0000 0293 
; 0000 0294 // Port D initialization
; 0000 0295 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 0296 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0< ...
	LDI  R30,LOW(1)
	OUT  0xA,R30
; 0000 0297 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0298 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<< ...
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0299 
; 0000 029A // Timer/Counter 0 initialization
; 0000 029B // Clock source: System Clock
; 0000 029C // Clock value: Timer 0 Stopped
; 0000 029D // Mode: Normal top=0xFF
; 0000 029E // OC0A output: Disconnected
; 0000 029F // OC0B output: Disconnected
; 0000 02A0 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<< ...
	OUT  0x24,R30
; 0000 02A1 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 02A2 TCNT0=0x00;
	OUT  0x26,R30
; 0000 02A3 OCR0A=0x00;
	OUT  0x27,R30
; 0000 02A4 OCR0B=0x00;
	OUT  0x28,R30
; 0000 02A5 
; 0000 02A6 // Timer/Counter 1 initialization
; 0000 02A7 // Clock source: System Clock
; 0000 02A8 // Clock value: Timer1 Stopped
; 0000 02A9 // Mode: Normal top=0xFFFF
; 0000 02AA // OC1A output: Disconnected
; 0000 02AB // OC1B output: Disconnected
; 0000 02AC // Noise Canceler: Off
; 0000 02AD // Input Capture on Falling Edge
; 0000 02AE // Timer1 Overflow Interrupt: Off
; 0000 02AF // Input Capture Interrupt: Off
; 0000 02B0 // Compare A Match Interrupt: Off
; 0000 02B1 // Compare B Match Interrupt: Off
; 0000 02B2 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<< ...
	STS  128,R30
; 0000 02B3 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) ...
	STS  129,R30
; 0000 02B4 TCNT1H=0x00;
	STS  133,R30
; 0000 02B5 TCNT1L=0x00;
	STS  132,R30
; 0000 02B6 ICR1H=0x00;
	STS  135,R30
; 0000 02B7 ICR1L=0x00;
	STS  134,R30
; 0000 02B8 OCR1AH=0x00;
	STS  137,R30
; 0000 02B9 OCR1AL=0x00;
	STS  136,R30
; 0000 02BA OCR1BH=0x00;
	STS  139,R30
; 0000 02BB OCR1BL=0x00;
	STS  138,R30
; 0000 02BC 
; 0000 02BD // Timer/Counter 2 initialization
; 0000 02BE // Clock source: System Clock
; 0000 02BF // Clock value: Timer2 Stopped
; 0000 02C0 // Mode: Normal top=0xFF
; 0000 02C1 // OC2A output: Disconnected
; 0000 02C2 // OC2B output: Disconnected
; 0000 02C3 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 02C4 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<< ...
	STS  176,R30
; 0000 02C5 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 02C6 TCNT2=0x00;
	STS  178,R30
; 0000 02C7 OCR2A=0x00;
	STS  179,R30
; 0000 02C8 OCR2B=0x00;
	STS  180,R30
; 0000 02C9 
; 0000 02CA // Timer/Counter 0 Interrupt(s) initialization
; 0000 02CB TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 02CC 
; 0000 02CD // Timer/Counter 1 Interrupt(s) initialization
; 0000 02CE TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 02CF 
; 0000 02D0 // Timer/Counter 2 Interrupt(s) initialization
; 0000 02D1 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 02D2 
; 0000 02D3 // External Interrupt(s) initialization
; 0000 02D4 // INT0: On
; 0000 02D5 // INT0 Mode: Falling Edge
; 0000 02D6 // INT1: On
; 0000 02D7 // INT1 Mode: Falling Edge
; 0000 02D8 // Interrupt on any change on pins PCINT0-7: Off
; 0000 02D9 // Interrupt on any change on pins PCINT8-14: Off
; 0000 02DA // Interrupt on any change on pins PCINT16-23: On
; 0000 02DB EICRA=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	STS  105,R30
; 0000 02DC EIMSK=(1<<INT1) | (1<<INT0);
	LDI  R30,LOW(3)
	OUT  0x1D,R30
; 0000 02DD EIFR=(1<<INTF1) | (1<<INTF0);
	OUT  0x1C,R30
; 0000 02DE PCICR=(1<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	LDI  R30,LOW(4)
	STS  104,R30
; 0000 02DF PCMSK2=(1<<PCINT23) | (0<<PCINT22) | (0<<PCINT21) | (0<<PCINT20) | (0<<PCINT19)  ...
	LDI  R30,LOW(128)
	STS  109,R30
; 0000 02E0 PCIFR=(1<<PCIF2) | (0<<PCIF1) | (0<<PCIF0);
	LDI  R30,LOW(4)
	OUT  0x1B,R30
; 0000 02E1 
; 0000 02E2 // USART initialization
; 0000 02E3 // USART disabled
; 0000 02E4 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<U ...
	LDI  R30,LOW(0)
	STS  193,R30
; 0000 02E5 
; 0000 02E6 // Analog Comparator initialization
; 0000 02E7 // Analog Comparator: Off
; 0000 02E8 // The Analog Comparator's positive input is
; 0000 02E9 // connected to the AIN0 pin
; 0000 02EA // The Analog Comparator's negative input is
; 0000 02EB // connected to the AIN1 pin
; 0000 02EC ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<AC ...
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 02ED ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 02EE // Digital input buffer on AIN0: On
; 0000 02EF // Digital input buffer on AIN1: On
; 0000 02F0 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 02F1 
; 0000 02F2 // ADC initialization
; 0000 02F3 // ADC disabled
; 0000 02F4 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | ...
	STS  122,R30
; 0000 02F5 
; 0000 02F6 // SPI initialization
; 0000 02F7 // SPI disabled
; 0000 02F8 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<< ...
	OUT  0x2C,R30
; 0000 02F9 
; 0000 02FA // TWI initialization
; 0000 02FB // TWI disabled
; 0000 02FC TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 02FD 
; 0000 02FE // Globally enable interrupts
; 0000 02FF #asm("sei")
	SEI
; 0000 0300 Lcd_Init();
	CALL _Lcd_Init
; 0000 0301 I2C_Init();
	CALL _I2C_Init
; 0000 0302 
; 0000 0303 while (1)
_0x85:
; 0000 0304 {
; 0000 0305 // Place your code here
; 0000 0306 display();
	RCALL _display
; 0000 0307 
; 0000 0308 if(year == a_year && month == a_month && date == a_date && hour == a_hour && min ...
	LDS  R30,_a_year
	CP   R30,R9
	BRNE _0x89
	LDS  R30,_a_month
	CP   R30,R10
	BRNE _0x89
	LDS  R30,_a_date
	CP   R30,R7
	BRNE _0x89
	CP   R14,R5
	BRNE _0x89
	CP   R6,R11
	BRLO _0x89
	CP   R3,R12
	BRSH _0x8A
_0x89:
	RJMP _0x88
_0x8A:
; 0000 0309 // CODE CHO ALARM
; 0000 030A Lcd_Cmd(_LCD_CLEAR);
	LDI  R26,LOW(1)
	CALL _Lcd_Cmd
; 0000 030B Lcd_Out(1, 5, "ALARM");
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2MN _0x8B,0
	CALL _Lcd_Out
; 0000 030C while(TANG == 1 && GIAM == 1 && LEFT == 1 && RIGHT == 1 && LEN == 1 && XUONG ==  ...
_0x8C:
	SBIS 0x6,1
	RJMP _0x8F
	SBIS 0x6,2
	RJMP _0x8F
	SBIS 0x6,3
	RJMP _0x8F
	SBIS 0x9,4
	RJMP _0x8F
	SBIS 0x9,5
	RJMP _0x8F
	SBIC 0x9,6
	RJMP _0x90
_0x8F:
	RJMP _0x8E
_0x90:
; 0000 030D BUZZ = 1;
	SBI  0xB,0
; 0000 030E delay_ms(50);
	CALL SUBOPT_0x15
; 0000 030F BUZZ = 0;
	CBI  0xB,0
; 0000 0310 delay_ms(50);
	CALL SUBOPT_0x15
; 0000 0311 }
	RJMP _0x8C
_0x8E:
; 0000 0312 a_sec = 99;
	LDI  R30,LOW(99)
	MOV  R12,R30
; 0000 0313 a_min = 99;
	MOV  R11,R30
; 0000 0314 a_hour = 99;
	MOV  R14,R30
; 0000 0315 a_day = 99;
	MOV  R13,R30
; 0000 0316 a_date = 99;
	STS  _a_date,R30
; 0000 0317 a_month = 99;
	STS  _a_month,R30
; 0000 0318 a_year = 100;
	LDI  R30,LOW(100)
	STS  _a_year,R30
; 0000 0319 }
; 0000 031A }
_0x88:
	RJMP _0x85
; 0000 031B }
_0x95:
	RJMP _0x95
; .FEND

	.DSEG
_0x8B:
	.BYTE 0x6
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;void DS1307_Receive(unsigned char add, unsigned char dat){
; 0001 0003 void DS1307_Receive(unsigned char add, unsigned char dat){

	.CSEG
_DS1307_Receive:
; .FSTART _DS1307_Receive
; 0001 0004 I2C_Start();
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
;	add -> R16
;	dat -> R17
	CALL SUBOPT_0x28
; 0001 0005 I2C_Send_Byte(0xD0);
; 0001 0006 if(I2C_Wait_Ack() == 0){
	BRNE _0x20003
; 0001 0007 I2C_Send_Byte(add);
	MOV  R26,R16
	CALL SUBOPT_0x29
; 0001 0008 I2C_Wait_Ack();
; 0001 0009 I2C_Send_Byte(dat);
	MOV  R26,R17
	CALL SUBOPT_0x29
; 0001 000A I2C_Wait_Ack();
; 0001 000B }
; 0001 000C I2C_Stop();
_0x20003:
	CALL _I2C_Stop
; 0001 000D }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
;void adjust(void){
; 0001 000F void adjust(void){
_adjust:
; .FSTART _adjust
; 0001 0010 unsigned char t;
; 0001 0011 unsigned char hour,c,dv;
; 0001 0012 unsigned char p;
; 0001 0013 // Lay gia tri o dia chi 0x02
; 0001 0014 I2C_Start();
	CALL __SAVELOCR6
;	t -> R17
;	hour -> R16
;	c -> R19
;	dv -> R18
;	p -> R21
	CALL SUBOPT_0x28
; 0001 0015 I2C_Send_Byte(0xD0);
; 0001 0016 if(I2C_Wait_Ack() == 0){
	BREQ PC+2
	RJMP _0x20004
; 0001 0017 I2C_Send_Byte(0x02);
	LDI  R26,LOW(2)
	CALL SUBOPT_0x29
; 0001 0018 I2C_Wait_Ack();
; 0001 0019 I2C_Start();
	CALL SUBOPT_0x2A
; 0001 001A I2C_Send_Byte(0xD1);
; 0001 001B I2C_Wait_Ack();
; 0001 001C hour = I2C_Read_Byte(1);
	LDI  R26,LOW(1)
	CALL _I2C_Read_Byte
	MOV  R16,R30
; 0001 001D I2C_Stop();
	CALL _I2C_Stop
; 0001 001E 
; 0001 001F 
; 0001 0020 
; 0001 0021 // Neu dang o che do 24 mode
; 0001 0022 if(((hour>>6) & 0x01) == 0){
	MOV  R26,R16
	LDI  R27,0
	LDI  R30,LOW(6)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x20005
; 0001 0023 t = (hour >> 4)*10 + (hour & 0x0F);
	CALL SUBOPT_0x2B
; 0001 0024 hour &= 0x00;
	ANDI R16,LOW(0)
; 0001 0025 // set pm hoac am
; 0001 0026 if(t >= 12){
	CPI  R17,12
	BRLO _0x20006
; 0001 0027 hour |= 0x20;
	ORI  R16,LOW(32)
; 0001 0028 }
; 0001 0029 else{
	RJMP _0x20007
_0x20006:
; 0001 002A hour |= 0x00;
	ORI  R16,LOW(0)
; 0001 002B }
_0x20007:
; 0001 002C t %= 12;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL __MODW21
	MOV  R17,R30
; 0001 002D c = t / 10;
	CALL SUBOPT_0x2C
; 0001 002E c <<= 4;
; 0001 002F dv = t % 10;
; 0001 0030 hour |= 0x40+dv+c; // set bit6 len 1
	MOV  R30,R18
	SUBI R30,-LOW(64)
	ADD  R30,R19
	RJMP _0x20090
; 0001 0031 
; 0001 0032 DS1307_Receive(0x02, hour);
; 0001 0033 }
; 0001 0034 // Neu dang o che do 12 mode
; 0001 0035 else{
_0x20005:
; 0001 0036 p = ((hour>>5) & 0x01);
	MOV  R30,R16
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x1)
	MOV  R21,R30
; 0001 0037 hour &= 0x1F;
	ANDI R16,LOW(31)
; 0001 0038 t = (hour >> 4)*10 + (hour & 0x0F);
	CALL SUBOPT_0x2B
; 0001 0039 if(p == 1){
	CPI  R21,1
	BRNE _0x20009
; 0001 003A t += 12;
	SUBI R17,-LOW(12)
; 0001 003B if(hour == 24){
	CPI  R16,24
	BRNE _0x2000A
; 0001 003C t = 0;
	LDI  R17,LOW(0)
; 0001 003D }
; 0001 003E }
_0x2000A:
; 0001 003F c = t / 10;
_0x20009:
	CALL SUBOPT_0x2C
; 0001 0040 c <<= 4;
; 0001 0041 dv = t % 10;
; 0001 0042 hour &= 0x00;
	ANDI R16,LOW(0)
; 0001 0043 hour |= dv+c;
	MOV  R30,R19
	ADD  R30,R18
_0x20090:
	OR   R16,R30
; 0001 0044 DS1307_Receive(0x02, hour);
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOV  R26,R16
	RCALL _DS1307_Receive
; 0001 0045 }
; 0001 0046 }
; 0001 0047 
; 0001 0048 }
_0x20004:
	CALL __LOADLOCR6
	JMP  _0x2000006
; .FEND
;void DS1307_Get_Time(unsigned char *sec, unsigned char *min, unsigned char *hour ...
; 0001 004A void DS1307_Get_Time(unsigned char *sec, unsigned char *min, unsigned char *hour, unsigned char *flag){
_DS1307_Get_Time:
; .FSTART _DS1307_Get_Time
; 0001 004B unsigned char t_sec, t_min, t_hour;
; 0001 004C unsigned char temp;
; 0001 004D // Lay du lieu tu DS1307
; 0001 004E I2C_Start();
	CALL __SAVELOCR6
	MOVW R20,R26
;	*sec -> Y+10
;	*min -> Y+8
;	*hour -> Y+6
;	*flag -> R20,R21
;	t_sec -> R17
;	t_min -> R16
;	t_hour -> R19
;	temp -> R18
	CALL SUBOPT_0x28
; 0001 004F I2C_Send_Byte(0xD0);
; 0001 0050 if(I2C_Wait_Ack() == 0){
	BRNE _0x2000B
; 0001 0051 I2C_Send_Byte(0x00); // bat dau doc tu dia chi cua sec
	LDI  R26,LOW(0)
	CALL SUBOPT_0x29
; 0001 0052 I2C_Wait_Ack();
; 0001 0053 I2C_Start();
	CALL SUBOPT_0x2A
; 0001 0054 I2C_Send_Byte(0xD1);
; 0001 0055 I2C_Wait_Ack();
; 0001 0056 t_sec = I2C_Read_Byte(0);
	CALL SUBOPT_0x2D
; 0001 0057 t_min = I2C_Read_Byte(0);
; 0001 0058 t_hour = I2C_Read_Byte(1);
	LDI  R26,LOW(1)
	CALL _I2C_Read_Byte
	MOV  R19,R30
; 0001 0059 I2C_Stop();
	CALL _I2C_Stop
; 0001 005A 
; 0001 005B 
; 0001 005C // Xoa cac bit du
; 0001 005D t_sec &= 0x7F;
	ANDI R17,LOW(127)
; 0001 005E t_min &= 0x7F;
	ANDI R16,LOW(127)
; 0001 005F 
; 0001 0060 // Chuyen tu BCD sang thap phan
; 0001 0061 *sec =  (t_sec >> 4)*10 + (t_sec & 0x0F);
	MOV  R30,R17
	CALL SUBOPT_0x2E
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	ADD  R30,R26
	CALL SUBOPT_0x2F
; 0001 0062 *min = (t_min >> 4)*10 + (t_min & 0x0F);
	CALL SUBOPT_0x30
; 0001 0063 
; 0001 0064 // Kiem tra mode dang hoat dong la 24 hay 12
; 0001 0065 temp = ((t_hour>>6) & 0x01);
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	MOV  R18,R30
; 0001 0066 // Mode 12
; 0001 0067 if(temp == 0x01){
	CPI  R18,1
	BRNE _0x2000C
; 0001 0068 temp = ((t_hour>>5) & 0x01);
	MOV  R30,R19
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x1)
	MOV  R18,R30
; 0001 0069 // PM
; 0001 006A if(temp == 1){
	CPI  R18,1
	BRNE _0x2000D
; 0001 006B *flag = 2;
	MOVW R26,R20
	LDI  R30,LOW(2)
	RJMP _0x20091
; 0001 006C }
; 0001 006D // AM
; 0001 006E else{
_0x2000D:
; 0001 006F *flag = 1;
	MOVW R26,R20
	LDI  R30,LOW(1)
_0x20091:
	ST   X,R30
; 0001 0070 }
; 0001 0071 t_hour &= 0x1F;
	ANDI R19,LOW(31)
; 0001 0072 *hour = (t_hour >> 4)*10 + (t_hour & 0x0F);
	RJMP _0x20092
; 0001 0073 }
; 0001 0074 // Mode 24
; 0001 0075 else{
_0x2000C:
; 0001 0076 *flag = 0;
	MOVW R26,R20
	LDI  R30,LOW(0)
	ST   X,R30
; 0001 0077 t_hour &= 0x3F;
	ANDI R19,LOW(63)
; 0001 0078 *hour = (t_hour >> 4)*10 + (t_hour & 0x0F);
_0x20092:
	MOV  R30,R19
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
; 0001 0079 }
; 0001 007A }
; 0001 007B }
_0x2000B:
	RJMP _0x2000008
; .FEND
;void DS1307_Get_Date(unsigned char *day, unsigned char *date, unsigned char *mon ...
; 0001 007D void DS1307_Get_Date(unsigned char *day, unsigned char *date, unsigned char *month, unsigned char *year){
_DS1307_Get_Date:
; .FSTART _DS1307_Get_Date
; 0001 007E unsigned char t_day, t_date, t_month, t_year;
; 0001 007F // Lay du lieu tu DS1307
; 0001 0080 I2C_Start();
	CALL __SAVELOCR6
	MOVW R20,R26
;	*day -> Y+10
;	*date -> Y+8
;	*month -> Y+6
;	*year -> R20,R21
;	t_day -> R17
;	t_date -> R16
;	t_month -> R19
;	t_year -> R18
	CALL SUBOPT_0x28
; 0001 0081 I2C_Send_Byte(0xD0);
; 0001 0082 if(I2C_Wait_Ack() == 0){
	BRNE _0x20010
; 0001 0083 I2C_Send_Byte(0x03); // bat dau doc tu dia chi cua day
	LDI  R26,LOW(3)
	CALL SUBOPT_0x29
; 0001 0084 I2C_Wait_Ack();
; 0001 0085 I2C_Start();
	CALL SUBOPT_0x2A
; 0001 0086 I2C_Send_Byte(0xD1);
; 0001 0087 I2C_Wait_Ack();
; 0001 0088 t_day = I2C_Read_Byte(0);
	CALL SUBOPT_0x2D
; 0001 0089 t_date = I2C_Read_Byte(0);
; 0001 008A t_month = I2C_Read_Byte(0);
	LDI  R26,LOW(0)
	CALL _I2C_Read_Byte
	MOV  R19,R30
; 0001 008B t_year = I2C_Read_Byte(1);
	CALL SUBOPT_0x32
; 0001 008C I2C_Stop();
	CALL _I2C_Stop
; 0001 008D 
; 0001 008E // Xoa cac bit du
; 0001 008F t_day &= 0x0F;
	ANDI R17,LOW(15)
; 0001 0090 t_date &= 0x3F;
	ANDI R16,LOW(63)
; 0001 0091 t_month &= 0x1F;
	ANDI R19,LOW(31)
; 0001 0092 
; 0001 0093 // Chuyen tu BCD sang thap phan
; 0001 0094 *day = (t_day & 0x0F);
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	CALL SUBOPT_0x2F
; 0001 0095 *date = (t_date >> 4)*10 + (t_date & 0x0F);
	CALL SUBOPT_0x30
; 0001 0096 *month = (t_month >> 4)*10 + (t_month & 0x0F);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
; 0001 0097 *year = (t_year >> 4)*10 + (t_year & 0x0F);
	MOV  R30,R18
	CALL SUBOPT_0x2E
	MOV  R30,R18
	ANDI R30,LOW(0xF)
	ADD  R30,R26
	MOVW R26,R20
	ST   X,R30
; 0001 0098 }
; 0001 0099 }
_0x20010:
_0x2000008:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
;void DS1307_Set_Date(unsigned char *day, unsigned char *date, unsigned char *mon ...
; 0001 009C void DS1307_Set_Date(unsigned char *day, unsigned char *date, unsigned char *month, unsigned char *year, unsigned char max_day, int position,    int inOrde){
_DS1307_Set_Date:
; .FSTART _DS1307_Set_Date
; 0001 009D if(inOrde == 1){
	CALL __SAVELOCR6
	MOVW R16,R26
	__GETWRS 18,19,6
	LDD  R21,Y+8
;	*day -> Y+15
;	*date -> Y+13
;	*month -> Y+11
;	*year -> Y+9
;	max_day -> R21
;	position -> R18,R19
;	inOrde -> R16,R17
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+2
	RJMP _0x20011
; 0001 009E if(position == 1){
	CALL SUBOPT_0x33
	BRNE _0x20012
; 0001 009F if(*date + 10 > max_day){
	CALL SUBOPT_0x34
	ADIW R30,10
	MOVW R26,R30
	MOV  R30,R21
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x20013
; 0001 00A0 *date = *date + 10 - max_day;
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LD   R30,X
	SUBI R30,-LOW(10)
	CALL SUBOPT_0x35
; 0001 00A1 *month += 1;
; 0001 00A2 if(*month > 12){
	BRLO _0x20014
; 0001 00A3 *month = 1;
	CALL SUBOPT_0x36
; 0001 00A4 *year += 1;
; 0001 00A5 if(*year > 99)
	BRLO _0x20015
; 0001 00A6 *year -= 100;
	CALL SUBOPT_0x37
; 0001 00A7 }
_0x20015:
; 0001 00A8 }
_0x20014:
; 0001 00A9 else{
	RJMP _0x20016
_0x20013:
; 0001 00AA *date += 10;
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LD   R30,X
	SUBI R30,-LOW(10)
	ST   X,R30
; 0001 00AB }
_0x20016:
; 0001 00AC }
; 0001 00AD else if(position == 2){
	RJMP _0x20017
_0x20012:
	CALL SUBOPT_0x38
	BRNE _0x20018
; 0001 00AE if(*date + 1 > max_day){
	CALL SUBOPT_0x34
	ADIW R30,1
	MOVW R26,R30
	MOV  R30,R21
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x20019
; 0001 00AF *date = *date + 1 - max_day;
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LD   R30,X
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x35
; 0001 00B0 *month += 1;
; 0001 00B1 if(*month > 12){
	BRLO _0x2001A
; 0001 00B2 *month = 1;
	CALL SUBOPT_0x36
; 0001 00B3 *year += 1;
; 0001 00B4 if(*year > 99)
	BRLO _0x2001B
; 0001 00B5 *year -= 100;
	CALL SUBOPT_0x37
; 0001 00B6 }
_0x2001B:
; 0001 00B7 }
_0x2001A:
; 0001 00B8 else{
	RJMP _0x2001C
_0x20019:
; 0001 00B9 *date += 1;
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0001 00BA }
_0x2001C:
; 0001 00BB }
; 0001 00BC else if(position == 4){
	RJMP _0x2001D
_0x20018:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2001E
; 0001 00BD if(*month + 10 > 12){
	CALL SUBOPT_0x39
	SBIW R30,3
	BRLT _0x2001F
; 0001 00BE *month = *month + 10 - 12;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	SUBI R30,LOW(2)
	CALL SUBOPT_0x3A
; 0001 00BF *year += 1;
; 0001 00C0 if(*year > 99)
	BRLO _0x20020
; 0001 00C1 *year -= 100;
	CALL SUBOPT_0x37
; 0001 00C2 }
_0x20020:
; 0001 00C3 else{
	RJMP _0x20021
_0x2001F:
; 0001 00C4 *month += 10;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	SUBI R30,-LOW(10)
	ST   X,R30
; 0001 00C5 }
_0x20021:
; 0001 00C6 }
; 0001 00C7 else if(position == 5){
	RJMP _0x20022
_0x2001E:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20023
; 0001 00C8 if(*month + 1 > 12){
	CALL SUBOPT_0x39
	SBIW R30,12
	BRLT _0x20024
; 0001 00C9 *month = *month + 1 - 12;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	SUBI R30,LOW(11)
	CALL SUBOPT_0x3A
; 0001 00CA *year += 1;
; 0001 00CB if(*year > 99)
	BRLO _0x20025
; 0001 00CC *year -= 100;
	CALL SUBOPT_0x37
; 0001 00CD }
_0x20025:
; 0001 00CE else{
	RJMP _0x20026
_0x20024:
; 0001 00CF *month += 1;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0001 00D0 }
_0x20026:
; 0001 00D1 }
; 0001 00D2 else if(position == 7){
	RJMP _0x20027
_0x20023:
	CALL SUBOPT_0x3B
	BRNE _0x20028
; 0001 00D3 if(*year + 10 > 99){
	CALL SUBOPT_0x3C
	ADIW R30,10
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRLT _0x20029
; 0001 00D4 *year = *year + 10 - 100;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,LOW(90)
	RJMP _0x20093
; 0001 00D5 }
; 0001 00D6 else{
_0x20029:
; 0001 00D7 *year += 10;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,-LOW(10)
_0x20093:
	ST   X,R30
; 0001 00D8 }
; 0001 00D9 }
; 0001 00DA else if(position == 8){
	RJMP _0x2002B
_0x20028:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2002C
; 0001 00DB if(*year + 1 >= 99){
	CALL SUBOPT_0x3C
	ADIW R30,1
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRLT _0x2002D
; 0001 00DC *year = *year + 1 - 100;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,LOW(99)
	RJMP _0x20094
; 0001 00DD }
; 0001 00DE else{
_0x2002D:
; 0001 00DF *year += 1;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,-LOW(1)
_0x20094:
	ST   X,R30
; 0001 00E0 }
; 0001 00E1 }
; 0001 00E2 else if(position >= 10 && position <= 12){
	RJMP _0x2002F
_0x2002C:
	__CPWRN 18,19,10
	BRLT _0x20031
	__CPWRN 18,19,13
	BRLT _0x20032
_0x20031:
	RJMP _0x20030
_0x20032:
; 0001 00E3 *day += 1;
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0001 00E4 *day %= 7;
	CALL SUBOPT_0x3D
; 0001 00E5 }
; 0001 00E6 }
_0x20030:
_0x2002F:
_0x2002B:
_0x20027:
_0x20022:
_0x2001D:
_0x20017:
; 0001 00E7 else{
	RJMP _0x20033
_0x20011:
; 0001 00E8 if(position == 1){
	CALL SUBOPT_0x33
	BRNE _0x20034
; 0001 00E9 if(*date - 10 <= 0){
	CALL SUBOPT_0x34
	SBIW R30,10
	CALL __CPW01
	BRLT _0x20035
; 0001 00EA *date = *date + max_day - 10;
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LD   R30,X
	ADD  R30,R21
	SUBI R30,LOW(10)
	CALL SUBOPT_0x3E
; 0001 00EB *month -= 1;
; 0001 00EC if(*month == 0){
	BRNE _0x20036
; 0001 00ED *month = 12;
	CALL SUBOPT_0x3F
; 0001 00EE if(*year == 0)
	BRNE _0x20037
; 0001 00EF *year = 100;
	CALL SUBOPT_0x40
; 0001 00F0 *year -= 1;
_0x20037:
	CALL SUBOPT_0x41
; 0001 00F1 }
; 0001 00F2 }
_0x20036:
; 0001 00F3 else{
	RJMP _0x20038
_0x20035:
; 0001 00F4 *date -= 10;
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LD   R30,X
	SUBI R30,LOW(10)
	ST   X,R30
; 0001 00F5 }
_0x20038:
; 0001 00F6 }
; 0001 00F7 else if(position == 2){
	RJMP _0x20039
_0x20034:
	CALL SUBOPT_0x38
	BRNE _0x2003A
; 0001 00F8 if(*date - 1 <= 0){
	CALL SUBOPT_0x34
	SBIW R30,1
	CALL __CPW01
	BRLT _0x2003B
; 0001 00F9 *date = *date + max_day - 1;
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LD   R30,X
	ADD  R30,R21
	SUBI R30,LOW(1)
	CALL SUBOPT_0x3E
; 0001 00FA *month -= 1;
; 0001 00FB if(*month == 0){
	BRNE _0x2003C
; 0001 00FC *month = 12;
	CALL SUBOPT_0x3F
; 0001 00FD if(*year == 0)
	BRNE _0x2003D
; 0001 00FE *year = 100;
	CALL SUBOPT_0x40
; 0001 00FF *year -= 1;
_0x2003D:
	CALL SUBOPT_0x41
; 0001 0100 }
; 0001 0101 }
_0x2003C:
; 0001 0102 else{
	RJMP _0x2003E
_0x2003B:
; 0001 0103 *date -= 1;
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0001 0104 }
_0x2003E:
; 0001 0105 }
; 0001 0106 else if(position == 4){
	RJMP _0x2003F
_0x2003A:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20040
; 0001 0107 if(*month - 10 <= 0){
	CALL SUBOPT_0x39
	SBIW R30,10
	CALL __CPW01
	BRLT _0x20041
; 0001 0108 *month = *month + 12 - 10;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	SUBI R30,-LOW(2)
	ST   X,R30
; 0001 0109 if(*year == 0)
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x20042
; 0001 010A *year = 100;
	CALL SUBOPT_0x40
; 0001 010B *year -= 1;
_0x20042:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,LOW(1)
	RJMP _0x20095
; 0001 010C }
; 0001 010D else{
_0x20041:
; 0001 010E *month -= 10;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	SUBI R30,LOW(10)
_0x20095:
	ST   X,R30
; 0001 010F }
; 0001 0110 }
; 0001 0111 else if(position == 5){
	RJMP _0x20044
_0x20040:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20045
; 0001 0112 if(*month - 1 <= 0){
	CALL SUBOPT_0x39
	SBIW R30,1
	CALL __CPW01
	BRLT _0x20046
; 0001 0113 *month = *month + 12 - 1;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	SUBI R30,-LOW(11)
	ST   X,R30
; 0001 0114 *year -= 1;
	CALL SUBOPT_0x41
; 0001 0115 if(*year == 0)
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x20047
; 0001 0116 *year = 100;
	CALL SUBOPT_0x40
; 0001 0117 *year -= 1;
_0x20047:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	RJMP _0x20096
; 0001 0118 }
; 0001 0119 else{
_0x20046:
; 0001 011A *month -= 1;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
_0x20096:
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0001 011B }
; 0001 011C }
; 0001 011D else if(position == 7){
	RJMP _0x20049
_0x20045:
	CALL SUBOPT_0x3B
	BRNE _0x2004A
; 0001 011E if(*year - 10 <= 0){
	CALL SUBOPT_0x3C
	SBIW R30,10
	CALL __CPW01
	BRLT _0x2004B
; 0001 011F *year = *year + 100 - 10;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,-LOW(90)
	RJMP _0x20097
; 0001 0120 }
; 0001 0121 else{
_0x2004B:
; 0001 0122 *year -= 10;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,LOW(10)
_0x20097:
	ST   X,R30
; 0001 0123 }
; 0001 0124 }
; 0001 0125 else if(position == 8){
	RJMP _0x2004D
_0x2004A:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2004E
; 0001 0126 if(*year - 1 <= 0){
	CALL SUBOPT_0x3C
	SBIW R30,1
	CALL __CPW01
	BRLT _0x2004F
; 0001 0127 *year = *year + 100 - 1;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,-LOW(99)
	RJMP _0x20098
; 0001 0128 }
; 0001 0129 else{
_0x2004F:
; 0001 012A *year -= 1;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,LOW(1)
_0x20098:
	ST   X,R30
; 0001 012B }
; 0001 012C }
; 0001 012D else if(position >= 10 && position <= 12){
	RJMP _0x20051
_0x2004E:
	__CPWRN 18,19,10
	BRLT _0x20053
	__CPWRN 18,19,13
	BRLT _0x20054
_0x20053:
	RJMP _0x20052
_0x20054:
; 0001 012E *day -= 1;
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0001 012F if(*day<=0)
	LD   R26,X
	CPI  R26,0
	BRNE _0x20055
; 0001 0130 *day = 7;
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	LDI  R30,LOW(7)
	ST   X,R30
; 0001 0131 *day %= 7;
_0x20055:
	CALL SUBOPT_0x3D
; 0001 0132 }
; 0001 0133 }
_0x20052:
_0x20051:
_0x2004D:
_0x20049:
_0x20044:
_0x2003F:
_0x20039:
_0x20033:
; 0001 0134 }
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND
;void DS1307_Set_Time(unsigned char *sec, unsigned char *min, unsigned char *hour ...
; 0001 0136 void DS1307_Set_Time(unsigned char *sec, unsigned char *min, unsigned char *hour, int position, int inOrde){
_DS1307_Set_Time:
; .FSTART _DS1307_Set_Time
; 0001 0137 if(inOrde == 1){
	CALL __SAVELOCR6
	MOVW R16,R26
	__GETWRS 18,19,6
	__GETWRS 20,21,8
;	*sec -> Y+12
;	*min -> Y+10
;	*hour -> R20,R21
;	position -> R18,R19
;	inOrde -> R16,R17
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+2
	RJMP _0x20056
; 0001 0138 if(position == 1){
	CALL SUBOPT_0x33
	BRNE _0x20057
; 0001 0139 if(*hour + 10 >= 24){
	MOVW R26,R20
	LD   R30,X
	LDI  R31,0
	SBIW R30,14
	BRLT _0x20058
; 0001 013A *hour = (*hour + 10) % 24;
	CALL SUBOPT_0x42
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL __MODW21
	MOVW R26,R20
	RJMP _0x20099
; 0001 013B }
; 0001 013C else{
_0x20058:
; 0001 013D *hour += 10;
	MOVW R26,R20
	LD   R30,X
	SUBI R30,-LOW(10)
_0x20099:
	ST   X,R30
; 0001 013E }
; 0001 013F }
; 0001 0140 else if(position == 2){
	RJMP _0x2005A
_0x20057:
	CALL SUBOPT_0x38
	BRNE _0x2005B
; 0001 0141 if(*hour + 1 >= 24){
	MOVW R26,R20
	LD   R30,X
	LDI  R31,0
	SBIW R30,23
	BRLT _0x2005C
; 0001 0142 *hour = (*hour + 1) % 24;
	CALL SUBOPT_0x43
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL __MODW21
	MOVW R26,R20
	RJMP _0x2009A
; 0001 0143 }
; 0001 0144 else{
_0x2005C:
; 0001 0145 *hour += 1;
	MOVW R26,R20
	LD   R30,X
	SUBI R30,-LOW(1)
_0x2009A:
	ST   X,R30
; 0001 0146 }
; 0001 0147 }
; 0001 0148 else if(position == 6){
	RJMP _0x2005E
_0x2005B:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2005F
; 0001 0149 if(*min + 10 >= 60){
	CALL SUBOPT_0x44
	SBIW R30,50
	BRLT _0x20060
; 0001 014A *min = (*min + 10) % 60;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x42
	CALL SUBOPT_0x45
; 0001 014B *hour += 1;
; 0001 014C if(*hour == 24){
	BRNE _0x20061
; 0001 014D *hour = 0;
	MOVW R26,R20
	LDI  R30,LOW(0)
	ST   X,R30
; 0001 014E }
; 0001 014F }
_0x20061:
; 0001 0150 else{
	RJMP _0x20062
_0x20060:
; 0001 0151 *min += 10;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X
	SUBI R30,-LOW(10)
	ST   X,R30
; 0001 0152 }
_0x20062:
; 0001 0153 }
; 0001 0154 else if(position == 7){
	RJMP _0x20063
_0x2005F:
	CALL SUBOPT_0x3B
	BRNE _0x20064
; 0001 0155 if(*min + 1 >= 60){
	CALL SUBOPT_0x44
	SBIW R30,59
	BRLT _0x20065
; 0001 0156 *min = (*min + 1) % 60;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x43
	CALL SUBOPT_0x45
; 0001 0157 *hour += 1;
; 0001 0158 if(*hour == 24){
	BRNE _0x20066
; 0001 0159 *hour = 0;
	MOVW R26,R20
	LDI  R30,LOW(0)
	ST   X,R30
; 0001 015A }
; 0001 015B }
_0x20066:
; 0001 015C else{
	RJMP _0x20067
_0x20065:
; 0001 015D *min += 1;
	CALL SUBOPT_0x46
; 0001 015E }
_0x20067:
; 0001 015F }
; 0001 0160 else if(position == 11){
	RJMP _0x20068
_0x20064:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20069
; 0001 0161 if(*sec + 10 >= 60){
	CALL SUBOPT_0x47
	SBIW R30,50
	BRLT _0x2006A
; 0001 0162 *sec = (*sec+10) % 60;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x42
	CALL SUBOPT_0x48
; 0001 0163 *min += 1;
; 0001 0164 if(*min == 60){
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,LOW(0x3C)
	BRNE _0x2006B
; 0001 0165 *min = 0;
	CALL SUBOPT_0x49
; 0001 0166 }
; 0001 0167 }
_0x2006B:
; 0001 0168 else{
	RJMP _0x2006C
_0x2006A:
; 0001 0169 *sec += 10;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X
	SUBI R30,-LOW(10)
	ST   X,R30
; 0001 016A }
_0x2006C:
; 0001 016B }
; 0001 016C else if(position == 12){
	RJMP _0x2006D
_0x20069:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2006E
; 0001 016D if(*sec + 1 >= 60){
	CALL SUBOPT_0x47
	SBIW R30,59
	BRLT _0x2006F
; 0001 016E *sec = (*sec+1) % 60;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x43
	CALL SUBOPT_0x48
; 0001 016F *min += 1;
; 0001 0170 if(*min == 60){
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,LOW(0x3C)
	BRNE _0x20070
; 0001 0171 *min = 0;
	CALL SUBOPT_0x49
; 0001 0172 }
; 0001 0173 }
_0x20070:
; 0001 0174 else{
	RJMP _0x20071
_0x2006F:
; 0001 0175 *sec += 1;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0001 0176 }
_0x20071:
; 0001 0177 }
; 0001 0178 }
_0x2006E:
_0x2006D:
_0x20068:
_0x20063:
_0x2005E:
_0x2005A:
; 0001 0179 else{
	RJMP _0x20072
_0x20056:
; 0001 017A if(position == 1){
	CALL SUBOPT_0x33
	BRNE _0x20073
; 0001 017B if(*hour - 10 > 0){
	MOVW R26,R20
	LD   R30,X
	LDI  R31,0
	SBIW R30,10
	CALL __CPW01
	BRGE _0x20074
; 0001 017C *hour -= 10;
	LD   R30,X
	SUBI R30,LOW(10)
	RJMP _0x2009B
; 0001 017D }
; 0001 017E else{
_0x20074:
; 0001 017F *hour = *hour + 24 - 10;
	MOVW R26,R20
	LD   R30,X
	SUBI R30,-LOW(14)
_0x2009B:
	ST   X,R30
; 0001 0180 }
; 0001 0181 }
; 0001 0182 else if(position == 2){
	RJMP _0x20076
_0x20073:
	CALL SUBOPT_0x38
	BRNE _0x20077
; 0001 0183 if(*hour - 1 > 0){
	MOVW R26,R20
	LD   R30,X
	LDI  R31,0
	SBIW R30,1
	CALL __CPW01
	BRGE _0x20078
; 0001 0184 *hour -= 1;
	LD   R30,X
	SUBI R30,LOW(1)
	RJMP _0x2009C
; 0001 0185 }
; 0001 0186 else{
_0x20078:
; 0001 0187 *hour = *hour + 24 - 1;
	CALL SUBOPT_0x4A
_0x2009C:
	ST   X,R30
; 0001 0188 }
; 0001 0189 }
; 0001 018A else if(position == 6){
	RJMP _0x2007A
_0x20077:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2007B
; 0001 018B if(*min - 10 < 0){
	CALL SUBOPT_0x44
	SBIW R30,10
	TST  R31
	BRPL _0x2007C
; 0001 018C *min = (*min + 60) - 10;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X
	SUBI R30,-LOW(50)
	CALL SUBOPT_0x4B
; 0001 018D *hour -= 1;
; 0001 018E if(*hour == 255){
	BRNE _0x2007D
; 0001 018F *hour = 0;
	CALL SUBOPT_0x4C
; 0001 0190 *hour = *hour + 24 - 1;
	ST   X,R30
; 0001 0191 }
; 0001 0192 }
_0x2007D:
; 0001 0193 else{
	RJMP _0x2007E
_0x2007C:
; 0001 0194 *min -= 10;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X
	SUBI R30,LOW(10)
	ST   X,R30
; 0001 0195 }
_0x2007E:
; 0001 0196 }
; 0001 0197 else if(position == 7){
	RJMP _0x2007F
_0x2007B:
	CALL SUBOPT_0x3B
	BRNE _0x20080
; 0001 0198 if(*min - 1 < 0){
	CALL SUBOPT_0x44
	SBIW R30,1
	TST  R31
	BRPL _0x20081
; 0001 0199 *min = (*min + 60) - 1;
	CALL SUBOPT_0x4D
; 0001 019A *hour -= 1;
; 0001 019B if(*hour == 255){
	BRNE _0x20082
; 0001 019C *hour = 0;
	CALL SUBOPT_0x4C
; 0001 019D *hour = *hour + 24 - 1;
	ST   X,R30
; 0001 019E }
; 0001 019F }
_0x20082:
; 0001 01A0 else{
	RJMP _0x20083
_0x20081:
; 0001 01A1 *min -= 1;
	CALL SUBOPT_0x4E
; 0001 01A2 }
_0x20083:
; 0001 01A3 }
; 0001 01A4 else if(position == 11){
	RJMP _0x20084
_0x20080:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20085
; 0001 01A5 if(*sec - 10 < 0){
	CALL SUBOPT_0x47
	SBIW R30,10
	TST  R31
	BRPL _0x20086
; 0001 01A6 *sec = (*sec+60) - 10;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X
	SUBI R30,-LOW(50)
	ST   X,R30
; 0001 01A7 *min -= 1;
	CALL SUBOPT_0x4E
; 0001 01A8 if(*min == 255){
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,LOW(0xFF)
	BRNE _0x20087
; 0001 01A9 *min = 0;
	CALL SUBOPT_0x49
; 0001 01AA *min = 60 + *min - 1;
	CALL SUBOPT_0x4D
; 0001 01AB *hour -= 1;
; 0001 01AC if(*hour == 255){
	BRNE _0x20088
; 0001 01AD *hour = 0;
	CALL SUBOPT_0x4C
; 0001 01AE *hour = *hour + 24 - 1;
	ST   X,R30
; 0001 01AF }
; 0001 01B0 }
_0x20088:
; 0001 01B1 }
_0x20087:
; 0001 01B2 else{
	RJMP _0x20089
_0x20086:
; 0001 01B3 *sec -= 10;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X
	SUBI R30,LOW(10)
	ST   X,R30
; 0001 01B4 }
_0x20089:
; 0001 01B5 }
; 0001 01B6 else if(position == 12){
	RJMP _0x2008A
_0x20085:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2008B
; 0001 01B7 if(*sec - 1 < 0){
	CALL SUBOPT_0x47
	SBIW R30,1
	TST  R31
	BRPL _0x2008C
; 0001 01B8 *sec = (*sec+60) - 1;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X
	SUBI R30,-LOW(59)
	ST   X,R30
; 0001 01B9 *min -= 1;
	CALL SUBOPT_0x4E
; 0001 01BA if(*min == 255){
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,LOW(0xFF)
	BRNE _0x2008D
; 0001 01BB *min = 0;
	CALL SUBOPT_0x49
; 0001 01BC *min = 60 + *min - 1;
	CALL SUBOPT_0x4D
; 0001 01BD *hour -= 1;
; 0001 01BE if(*hour == 255){
	BRNE _0x2008E
; 0001 01BF *hour = 0;
	CALL SUBOPT_0x4C
; 0001 01C0 *hour = *hour + 24 - 1;
	ST   X,R30
; 0001 01C1 }
; 0001 01C2 }
_0x2008E:
; 0001 01C3 }
_0x2008D:
; 0001 01C4 else{
	RJMP _0x2008F
_0x2008C:
; 0001 01C5 *sec -= 1;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0001 01C6 }
_0x2008F:
; 0001 01C7 }
; 0001 01C8 }
_0x2008B:
_0x2008A:
_0x20084:
_0x2007F:
_0x2007A:
_0x20076:
_0x20072:
; 0001 01C9 }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;void Lcd_Write_High_Nibble(unsigned char);
;void Lcd_Write_Low_Nibble(unsigned char );
;void Lcd_Delay_us(unsigned char);
;void Lcd_Write_High_Nibble(unsigned char b)
; 0002 000F {

	.CSEG
_Lcd_Write_High_Nibble:
; .FSTART _Lcd_Write_High_Nibble
; 0002 0010 LCD_D7 = b & 0x80;
	ST   -Y,R17
	MOV  R17,R26
;	b -> R17
	SBRC R17,7
	RJMP _0x40003
	CBI  0x8,0
	RJMP _0x40004
_0x40003:
	SBI  0x8,0
_0x40004:
; 0002 0011 LCD_D6 = b & 0x40;
	SBRC R17,6
	RJMP _0x40005
	CBI  0x5,5
	RJMP _0x40006
_0x40005:
	SBI  0x5,5
_0x40006:
; 0002 0012 LCD_D5 = b & 0x20;
	SBRC R17,5
	RJMP _0x40007
	CBI  0x5,4
	RJMP _0x40008
_0x40007:
	SBI  0x5,4
_0x40008:
; 0002 0013 LCD_D4 = b & 0x10;
	SBRC R17,4
	RJMP _0x40009
	CBI  0x5,3
	RJMP _0x4000A
_0x40009:
	SBI  0x5,3
_0x4000A:
; 0002 0014 }
	RJMP _0x2000007
; .FEND
;void Lcd_Write_Low_Nibble(unsigned char b)
; 0002 001A {
_Lcd_Write_Low_Nibble:
; .FSTART _Lcd_Write_Low_Nibble
; 0002 001B LCD_D7 = b & 0x08;
	ST   -Y,R17
	MOV  R17,R26
;	b -> R17
	SBRC R17,3
	RJMP _0x4000B
	CBI  0x8,0
	RJMP _0x4000C
_0x4000B:
	SBI  0x8,0
_0x4000C:
; 0002 001C LCD_D6 = b & 0x04;
	SBRC R17,2
	RJMP _0x4000D
	CBI  0x5,5
	RJMP _0x4000E
_0x4000D:
	SBI  0x5,5
_0x4000E:
; 0002 001D LCD_D5 = b & 0x02;
	SBRC R17,1
	RJMP _0x4000F
	CBI  0x5,4
	RJMP _0x40010
_0x4000F:
	SBI  0x5,4
_0x40010:
; 0002 001E LCD_D4 = b & 0x01;
	SBRC R17,0
	RJMP _0x40011
	CBI  0x5,3
	RJMP _0x40012
_0x40011:
	SBI  0x5,3
_0x40012:
; 0002 001F }
	RJMP _0x2000007
; .FEND
;void Lcd_Delay_us(unsigned char t)
; 0002 0025 {
; 0002 0026 while(t--);
;	t -> R17
; 0002 0027 }
;void Lcd_Init()
; 0002 002E {
_Lcd_Init:
; .FSTART _Lcd_Init
; 0002 002F LCD_RS = 0;
	CBI  0x5,0
; 0002 0030 LCD_EN = 0;
	CBI  0x5,2
; 0002 0031 LCD_RW = 0;
	CBI  0x5,1
; 0002 0032 
; 0002 0033 delay_ms(20);
	CALL SUBOPT_0x14
; 0002 0034 
; 0002 0035 Lcd_Write_Low_Nibble(0x03);
	CALL SUBOPT_0x4F
; 0002 0036 LCD_EN = 1;
; 0002 0037 LCD_EN = 0;
; 0002 0038 delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0002 0039 
; 0002 003A Lcd_Write_Low_Nibble(0x03);
	CALL SUBOPT_0x4F
; 0002 003B LCD_EN = 1;
; 0002 003C LCD_EN = 0;
; 0002 003D delay_us(100);
	__DELAY_USW 400
; 0002 003E 
; 0002 003F Lcd_Write_Low_Nibble(0x03);
	CALL SUBOPT_0x4F
; 0002 0040 LCD_EN = 1;
; 0002 0041 LCD_EN = 0;
; 0002 0042 
; 0002 0043 delay_ms(1);
	CALL SUBOPT_0x3
; 0002 0044 
; 0002 0045 
; 0002 0046 Lcd_Write_Low_Nibble(0x02);
	LDI  R26,LOW(2)
	CALL SUBOPT_0x50
; 0002 0047 LCD_EN = 1;
; 0002 0048 LCD_EN = 0;
; 0002 0049 delay_ms(1);
	CALL SUBOPT_0x3
; 0002 004A 
; 0002 004B Lcd_Cmd(_LCD_4BIT_2LINE_5x7FONT);
	LDI  R26,LOW(40)
	RCALL _Lcd_Cmd
; 0002 004C Lcd_Cmd(_LCD_TURN_ON);
	LDI  R26,LOW(12)
	RCALL _Lcd_Cmd
; 0002 004D Lcd_Cmd(_LCD_CLEAR);
	LDI  R26,LOW(1)
	RCALL _Lcd_Cmd
; 0002 004E Lcd_Cmd(_LCD_ENTRY_MODE);
	LDI  R26,LOW(6)
	RCALL _Lcd_Cmd
; 0002 004F }
	RET
; .FEND
;void Lcd_Cmd(unsigned char cmd)
; 0002 0056 {
_Lcd_Cmd:
; .FSTART _Lcd_Cmd
; 0002 0057 LCD_RW = 0;
	ST   -Y,R17
	MOV  R17,R26
;	cmd -> R17
	CBI  0x5,1
; 0002 0058 LCD_RS = 0;
	CBI  0x5,0
; 0002 0059 Lcd_Write_High_Nibble(cmd);
	CALL SUBOPT_0x51
; 0002 005A LCD_EN = 1;
; 0002 005B LCD_EN = 0;
; 0002 005C 
; 0002 005D Lcd_Write_Low_Nibble(cmd);
; 0002 005E LCD_EN = 1;
; 0002 005F LCD_EN = 0;
; 0002 0060 
; 0002 0061 switch(cmd)
	MOV  R30,R17
	LDI  R31,0
; 0002 0062 {
; 0002 0063 case _LCD_CLEAR:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x4003C
; 0002 0064 case _LCD_RETURN_HOME:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4003E
_0x4003C:
; 0002 0065 delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0002 0066 break;
	RJMP _0x4003A
; 0002 0067 default:
_0x4003E:
; 0002 0068 delay_us(37);
	__DELAY_USB 197
; 0002 0069 break;
; 0002 006A }
_0x4003A:
; 0002 006B }
	RJMP _0x2000007
; .FEND
;void Lcd_Chr_Cp(unsigned char achar)
; 0002 0071 {
_Lcd_Chr_Cp:
; .FSTART _Lcd_Chr_Cp
; 0002 0072 LCD_RW = 0;
	ST   -Y,R17
	MOV  R17,R26
;	achar -> R17
	CBI  0x5,1
; 0002 0073 LCD_RS = 1;
	SBI  0x5,0
; 0002 0074 Lcd_Write_High_Nibble(achar);
	CALL SUBOPT_0x51
; 0002 0075 LCD_EN = 1;
; 0002 0076 LCD_EN = 0;
; 0002 0077 
; 0002 0078 Lcd_Write_Low_Nibble(achar);
; 0002 0079 LCD_EN = 1;
; 0002 007A LCD_EN = 0;
; 0002 007B 
; 0002 007C delay_us(37+4);
	__DELAY_USB 219
; 0002 007D 
; 0002 007E }
_0x2000007:
	LD   R17,Y+
	RET
; .FEND
;void Lcd_Chr(unsigned char row, unsigned char column, unsigned char achar)
; 0002 0085 {
_Lcd_Chr:
; .FSTART _Lcd_Chr
; 0002 0086 unsigned char add;
; 0002 0087 add = (row==1?0x80:0xC0);
	CALL __SAVELOCR4
	MOV  R16,R26
	LDD  R19,Y+4
	LDD  R18,Y+5
;	row -> R18
;	column -> R19
;	achar -> R16
;	add -> R17
	CPI  R18,1
	BRNE _0x4004B
	LDI  R30,LOW(128)
	RJMP _0x4004C
_0x4004B:
	LDI  R30,LOW(192)
_0x4004C:
	MOV  R17,R30
; 0002 0088 add += (column - 1);
	MOV  R30,R19
	SUBI R30,LOW(1)
	ADD  R17,R30
; 0002 0089 Lcd_Cmd(add);
	MOV  R26,R17
	RCALL _Lcd_Cmd
; 0002 008A Lcd_Chr_Cp(achar);
	MOV  R26,R16
	RCALL _Lcd_Chr_Cp
; 0002 008B }
	CALL __LOADLOCR4
_0x2000006:
	ADIW R28,6
	RET
; .FEND
;void Lcd_Out_Cp(unsigned char * str)
; 0002 008E {
_Lcd_Out_Cp:
; .FSTART _Lcd_Out_Cp
; 0002 008F unsigned char i = 0;
; 0002 0090 while(str[i])
	CALL __SAVELOCR4
	MOVW R18,R26
;	*str -> R18,R19
;	i -> R17
	LDI  R17,0
_0x4004E:
	MOVW R26,R18
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x40050
; 0002 0091 {
; 0002 0092 Lcd_Chr_Cp(str[i]);
	MOVW R26,R18
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _Lcd_Chr_Cp
; 0002 0093 i++;
	SUBI R17,-1
; 0002 0094 }
	RJMP _0x4004E
_0x40050:
; 0002 0095 }
	JMP  _0x2000002
; .FEND
;void Lcd_Out(unsigned char row, unsigned char column,
; 0002 009D unsigned char* str)
; 0002 009E {
_Lcd_Out:
; .FSTART _Lcd_Out
; 0002 009F unsigned char add;
; 0002 00A0 add = (row==1?0x80:0xC0);
	CALL __SAVELOCR6
	MOVW R18,R26
	LDD  R16,Y+6
	LDD  R21,Y+7
;	row -> R21
;	column -> R16
;	*str -> R18,R19
;	add -> R17
	CPI  R21,1
	BRNE _0x40051
	LDI  R30,LOW(128)
	RJMP _0x40052
_0x40051:
	LDI  R30,LOW(192)
_0x40052:
	MOV  R17,R30
; 0002 00A1 add += (column - 1);
	MOV  R30,R16
	SUBI R30,LOW(1)
	ADD  R17,R30
; 0002 00A2 Lcd_Cmd(add);
	MOV  R26,R17
	RCALL _Lcd_Cmd
; 0002 00A3 Lcd_Out_Cp(str);
	MOVW R26,R18
	RCALL _Lcd_Out_Cp
; 0002 00A4 }
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;void Lcd_Custom_Chr(unsigned char location, unsigned char * lcd_char)
; 0002 00B5 {
; 0002 00B6 unsigned char i;
; 0002 00B7 Lcd_Cmd(0x40+location*8);
;	location -> R16
;	*lcd_char -> R18,R19
;	i -> R17
; 0002 00B8 for (i = 0; i<=7; i++)
; 0002 00B9 Lcd_Chr_Cp(lcd_char[i]);
; 0002 00BA }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;unsigned int SHT20_Read_RH(void){ // Mode no hold master
; 0003 0003 unsigned int SHT20_Read_RH(void){

	.CSEG
_SHT20_Read_RH:
; .FSTART _SHT20_Read_RH
; 0003 0004 unsigned int do_am = 0;
; 0003 0005 unsigned int do_am1 = 0;
; 0003 0006 I2C_Start();
	CALL SUBOPT_0x52
;	do_am -> R16,R17
;	do_am1 -> R18,R19
; 0003 0007 I2C_Send_Byte(0x80);
; 0003 0008 if(I2C_Wait_Ack() == 0){
	CPI  R30,0
	BRNE _0x60003
; 0003 0009 I2C_Send_Byte(0xF5); // gui lenh doc do am (xem trong datasheet)
	LDI  R26,LOW(245)
	RCALL SUBOPT_0x29
; 0003 000A if(I2C_Wait_Ack() == 0){
	CPI  R30,0
	BRNE _0x60004
; 0003 000B delay_us(20);
	__DELAY_USB 107
; 0003 000C I2C_Stop();
	RCALL _I2C_Stop
; 0003 000D 
; 0003 000E // Cho cho den khi do xong (loi mo phong phai them delay 30 ms (xem datasheet))
; 0003 000F delay_ms(29);
	LDI  R26,LOW(29)
	LDI  R27,0
	CALL _delay_ms
; 0003 0010 while(1){
_0x60005:
; 0003 0011 I2C_Start();
	RCALL _I2C_Start
; 0003 0012 I2C_Send_Byte(0x81);
	LDI  R26,LOW(129)
	RCALL SUBOPT_0x29
; 0003 0013 if(I2C_Wait_Ack() == 0){
	CPI  R30,0
	BREQ _0x60007
; 0003 0014 
; 0003 0015 break;
; 0003 0016 }
; 0003 0017 I2C_Stop();
	RCALL _I2C_Stop
; 0003 0018 
; 0003 0019 }
	RJMP _0x60005
_0x60007:
; 0003 001A 
; 0003 001B 
; 0003 001C do_am = I2C_Read_Byte(0);
	CALL SUBOPT_0x53
; 0003 001D do_am <<= 8;
; 0003 001E do_am1 = I2C_Read_Byte(1);
	CLR  R19
; 0003 001F do_am |= do_am1;
	__ORWRR 16,17,18,19
; 0003 0020 
; 0003 0021 
; 0003 0022 //            I2C_Read_Byte(1);
; 0003 0023 //            I2C_Wait_Ack();
; 0003 0024 
; 0003 0025 }
; 0003 0026 }
_0x60004:
; 0003 0027 I2C_Stop();
_0x60003:
	RCALL _I2C_Stop
; 0003 0028 return do_am;
	MOVW R30,R16
	RJMP _0x2000002
; 0003 0029 }
; .FEND
;unsigned int SHT20_Read_T(void){ // Mode no hold master
; 0003 002B unsigned int SHT20_Read_T(void){
_SHT20_Read_T:
; .FSTART _SHT20_Read_T
; 0003 002C unsigned int nhiet_do = 0;
; 0003 002D unsigned int nhiet_do1 = 0;
; 0003 002E I2C_Start();
	CALL SUBOPT_0x52
;	nhiet_do -> R16,R17
;	nhiet_do1 -> R18,R19
; 0003 002F I2C_Send_Byte(0x80);
; 0003 0030 if(I2C_Wait_Ack() == 0){
	CPI  R30,0
	BRNE _0x60009
; 0003 0031 I2C_Send_Byte(0xF3); // gui lenh doc nhiet do (xem trong datasheet)
	LDI  R26,LOW(243)
	RCALL SUBOPT_0x29
; 0003 0032 if(I2C_Wait_Ack() == 0){
	CPI  R30,0
	BRNE _0x6000A
; 0003 0033 delay_us(20);
	__DELAY_USB 107
; 0003 0034 I2C_Stop();
	RCALL _I2C_Stop
; 0003 0035 
; 0003 0036 // Cho cho den khi do xong (loi mo phong phai them delay 85 ms (xem datasheet))
; 0003 0037 delay_ms(85);
	LDI  R26,LOW(85)
	LDI  R27,0
	CALL _delay_ms
; 0003 0038 while(1){
_0x6000B:
; 0003 0039 I2C_Start();
	RCALL _I2C_Start
; 0003 003A I2C_Send_Byte(0x81);
	LDI  R26,LOW(129)
	RCALL SUBOPT_0x29
; 0003 003B if(I2C_Wait_Ack() == 0){
	CPI  R30,0
	BREQ _0x6000D
; 0003 003C 
; 0003 003D break;
; 0003 003E }
; 0003 003F I2C_Stop();
	RCALL _I2C_Stop
; 0003 0040 
; 0003 0041 }
	RJMP _0x6000B
_0x6000D:
; 0003 0042 
; 0003 0043 
; 0003 0044 nhiet_do = I2C_Read_Byte(0);
	CALL SUBOPT_0x53
; 0003 0045 nhiet_do <<= 8;
; 0003 0046 nhiet_do1 = I2C_Read_Byte(1);
	CLR  R19
; 0003 0047 nhiet_do |= nhiet_do1;
	__ORWRR 16,17,18,19
; 0003 0048 
; 0003 0049 //            I2C_Read_Byte(1);
; 0003 004A //            I2C_Wait_Ack();
; 0003 004B 
; 0003 004C }
; 0003 004D }
_0x6000A:
; 0003 004E I2C_Stop();
_0x60009:
	RCALL _I2C_Stop
; 0003 004F return nhiet_do;
	MOVW R30,R16
	RJMP _0x2000002
; 0003 0050 }
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;void I2C_Init(void){
; 0004 0003 void I2C_Init(void){

	.CSEG
_I2C_Init:
; .FSTART _I2C_Init
; 0004 0004 // PORT C config
; 0004 0005 DDRC |= (1<<DDC5) | (1<<DDC4);
	IN   R30,0x7
	ORI  R30,LOW(0x30)
	OUT  0x7,R30
; 0004 0006 
; 0004 0007 I2C_SCL = 1;
	SBI  0x8,5
; 0004 0008 I2C_SDA = 1;
	RJMP _0x2000005
; 0004 0009 }
; .FEND
;void I2C_Start(void){
; 0004 000A void I2C_Start(void){
_I2C_Start:
; .FSTART _I2C_Start
; 0004 000B SDA_OUT();
	SBI  0x7,4
; 0004 000C I2C_SCL = 1;
	SBI  0x8,5
; 0004 000D I2C_SDA = 1;
	SBI  0x8,4
; 0004 000E delay_ms(1);
	RCALL SUBOPT_0x3
; 0004 000F I2C_SDA = 0;
	CBI  0x8,4
; 0004 0010 delay_ms(1);
	RJMP _0x2000004
; 0004 0011 I2C_SCL = 0;
; 0004 0012 }
; .FEND
;void I2C_Stop(void){
; 0004 0014 void I2C_Stop(void){
_I2C_Stop:
; .FSTART _I2C_Stop
; 0004 0015 SDA_OUT();
	SBI  0x7,4
; 0004 0016 I2C_SCL = 0;
	CBI  0x8,5
; 0004 0017 I2C_SDA = 0;
	CBI  0x8,4
; 0004 0018 delay_ms(1);
	RCALL SUBOPT_0x3
; 0004 0019 I2C_SCL = 1;
	SBI  0x8,5
; 0004 001A delay_ms(1);
	RCALL SUBOPT_0x3
; 0004 001B I2C_SDA = 1;
_0x2000005:
	SBI  0x8,4
; 0004 001C }
	RET
; .FEND
;void I2C_Send_Byte(unsigned char txd){ // truyen tu bit cao den bit thap
; 0004 0021 void I2C_Send_Byte(unsigned char txd){
_I2C_Send_Byte:
; .FSTART _I2C_Send_Byte
; 0004 0022 unsigned char i = 0;
; 0004 0023 SDA_OUT();
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	txd -> R16
;	i -> R17
	LDI  R17,0
	SBI  0x7,4
; 0004 0024 I2C_SCL = 0;
	CBI  0x8,5
; 0004 0025 for(i = 0; i < 8; i++){
	LDI  R17,LOW(0)
_0x8001A:
	CPI  R17,8
	BRSH _0x8001B
; 0004 0026 I2C_SDA = (txd & 0x80) >> 7;
	MOV  R30,R16
	ANDI R30,LOW(0x80)
	LDI  R31,0
	CALL __ASRW3
	CALL __ASRW4
	CPI  R30,0
	BRNE _0x8001C
	CBI  0x8,4
	RJMP _0x8001D
_0x8001C:
	SBI  0x8,4
_0x8001D:
; 0004 0027 txd <<= 1;
	LSL  R16
; 0004 0028 delay_ms(1);
	RCALL SUBOPT_0x3
; 0004 0029 I2C_SCL = 1;
	SBI  0x8,5
; 0004 002A delay_ms(1);
	RCALL SUBOPT_0x3
; 0004 002B I2C_SCL = 0;
	CBI  0x8,5
; 0004 002C }
	SUBI R17,-1
	RJMP _0x8001A
_0x8001B:
; 0004 002D }
	RJMP _0x2000001
; .FEND
;void I2C_Ack(void){
; 0004 002F void I2C_Ack(void){
_I2C_Ack:
; .FSTART _I2C_Ack
; 0004 0030 SDA_OUT();
	SBI  0x7,4
; 0004 0031 I2C_SDA = 0;
	CBI  0x8,4
; 0004 0032 delay_ms(1);
	RJMP _0x2000003
; 0004 0033 I2C_SCL = 1;
; 0004 0034 delay_ms(1);
; 0004 0035 I2C_SCL = 0;
; 0004 0036 }
; .FEND
;void I2C_NAck(void){
; 0004 0038 void I2C_NAck(void){
_I2C_NAck:
; .FSTART _I2C_NAck
; 0004 0039 SDA_OUT();
	SBI  0x7,4
; 0004 003A I2C_SDA = 1;
	SBI  0x8,4
; 0004 003B delay_ms(1);
_0x2000003:
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0004 003C I2C_SCL = 1;
	SBI  0x8,5
; 0004 003D delay_ms(1);
_0x2000004:
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0004 003E I2C_SCL = 0;
	CBI  0x8,5
; 0004 003F }
	RET
; .FEND
;unsigned char I2C_Read_Byte(unsigned char ack){ // nhan tu bit cao den bit thap
; 0004 0044 unsigned char I2C_Read_Byte(unsigned char ack){
_I2C_Read_Byte:
; .FSTART _I2C_Read_Byte
; 0004 0045 unsigned char i = 0;
; 0004 0046 unsigned char dat = 0;
; 0004 0047 SDA_OUT();
	RCALL __SAVELOCR4
	MOV  R19,R26
;	ack -> R19
;	i -> R17
;	dat -> R16
	LDI  R17,0
	LDI  R16,0
	SBI  0x7,4
; 0004 0048 I2C_SDA = 1; // san sang nhan du lieu
	SBI  0x8,4
; 0004 0049 SDA_IN();
	CBI  0x7,4
; 0004 004A I2C_SCL = 0;
	CBI  0x8,5
; 0004 004B for(i = 0; i < 8; i++){
	LDI  R17,LOW(0)
_0x80033:
	CPI  R17,8
	BRSH _0x80034
; 0004 004C READ_SDA = 1; // cho SDA = 1 de san sang nhan du lieu
	SBI  0x6,4
; 0004 004D delay_ms(1);
	RCALL SUBOPT_0x3
; 0004 004E I2C_SCL = 1;
	SBI  0x8,5
; 0004 004F delay_ms(1);
	RCALL SUBOPT_0x3
; 0004 0050 dat <<= 1;
	LSL  R16
; 0004 0051 dat |= READ_SDA; // muon doc du lieu tu SDA
	LDI  R30,0
	SBIC 0x6,4
	LDI  R30,1
	OR   R16,R30
; 0004 0052 I2C_SCL = 0;
	CBI  0x8,5
; 0004 0053 }
	SUBI R17,-1
	RJMP _0x80033
_0x80034:
; 0004 0054 // SDA = 0 -> ACK
; 0004 0055 // SDA = 1 -> NACK
; 0004 0056 if(ack == 0){
	CPI  R19,0
	BRNE _0x8003B
; 0004 0057 I2C_Ack();
	RCALL _I2C_Ack
; 0004 0058 }
; 0004 0059 else{
	RJMP _0x8003C
_0x8003B:
; 0004 005A I2C_NAck();
	RCALL _I2C_NAck
; 0004 005B }
_0x8003C:
; 0004 005C return dat;
	MOV  R30,R16
_0x2000002:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; 0004 005D }
; .FEND
;unsigned char I2C_Wait_Ack(void){
; 0004 005F unsigned char I2C_Wait_Ack(void){
_I2C_Wait_Ack:
; .FSTART _I2C_Wait_Ack
; 0004 0060 unsigned char result = 0;
; 0004 0061 unsigned char time = 0;
; 0004 0062 SDA_IN();
	ST   -Y,R17
	ST   -Y,R16
;	result -> R17
;	time -> R16
	LDI  R17,0
	LDI  R16,0
	CBI  0x7,4
; 0004 0063 I2C_SDA = 1;
	SBI  0x8,4
; 0004 0064 delay_ms(1);
	RCALL SUBOPT_0x3
; 0004 0065 I2C_SCL = 1;
	SBI  0x8,5
; 0004 0066 delay_ms(1);
	RCALL SUBOPT_0x3
; 0004 0067 while(READ_SDA){ // muon doc du lieu tu SDA
_0x80041:
	SBIS 0x6,4
	RJMP _0x80043
; 0004 0068 time++;
	SUBI R16,-1
; 0004 0069 if(time > 250){
	CPI  R16,251
	BRLO _0x80044
; 0004 006A result = 1;
	LDI  R17,LOW(1)
; 0004 006B break;
	RJMP _0x80043
; 0004 006C }
; 0004 006D }
_0x80044:
	RJMP _0x80041
_0x80043:
; 0004 006E I2C_SCL = 0;
	CBI  0x8,5
; 0004 006F return result;
	MOV  R30,R17
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0004 0070 }
; .FEND

	.DSEG
_a_date:
	.BYTE 0x1
_a_month:
	.BYTE 0x1
_a_year:
	.BYTE 0x1
_flag:
	.BYTE 0x1
_dayOfWeek:
	.BYTE 0xE
_dayOfMonth:
	.BYTE 0x18
_change_mode:
	.BYTE 0x1
_address:
	.BYTE 0x1
_do_am:
	.BYTE 0x2
_nhiet_do:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x47800000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	JMP  _DS1307_Get_Date

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_flag)
	LDI  R27,HIGH(_flag)
	JMP  _DS1307_Get_Time

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:273 WORDS
SUBOPT_0x6:
	MOV  R26,R7
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr
	MOV  R26,R7
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(47)
	CALL _Lcd_Chr_Cp
	MOV  R26,R10
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	MOV  R26,R10
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(47)
	CALL _Lcd_Chr_Cp
	MOV  R26,R9
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	MOV  R26,R9
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(32)
	CALL _Lcd_Chr_Cp
	MOV  R26,R8
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __MODW21
	LDI  R26,LOW(_dayOfWeek)
	LDI  R27,HIGH(_dayOfWeek)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R30
	JMP  _Lcd_Out_Cp

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x9:
	MOV  R26,R5
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr
	MOV  R26,R5
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _Lcd_Chr_Cp

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:177 WORDS
SUBOPT_0xA:
	MOV  R26,R6
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	MOV  R26,R6
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(32)
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(58)
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(32)
	CALL _Lcd_Chr_Cp
	MOV  R26,R3
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	MOV  R26,R3
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDS  R26,_nhiet_do
	LDS  R27,_nhiet_do+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __DIVW21U
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _Lcd_Chr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _Lcd_Chr_Cp

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	CALL _Lcd_Chr_Cp
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _Lcd_Chr_Cp

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDS  R26,_do_am
	LDS  R27,_do_am+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x13:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	RCALL __SAVELOCR6
	__GETWRN 18,19,1
	LDI  R21,0
	LDI  R20,30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	CALL _adjust
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _change_mode,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	CALL _Lcd_Out_Cp
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(128)
	CALL _Lcd_Cmd
	LDI  R26,LOW(15)
	CALL _Lcd_Cmd
	__GETWRN 18,19,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	LDI  R21,LOW(0)
	MOV  R30,R18
	SUBI R30,-LOW(127)
	STS  _address,R30
	LDS  R26,_address
	JMP  _Lcd_Cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDI  R21,LOW(1)
	MOV  R30,R18
	SUBI R30,-LOW(191)
	STS  _address,R30
	LDS  R26,_address
	JMP  _Lcd_Cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1C:
	LDS  R26,_address
	JMP  _Lcd_Cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	MOV  R30,R10
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_dayOfMonth)
	LDI  R27,HIGH(_dayOfMonth)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(30)
	MOV  R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R20
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R16
	CALL _DS1307_Set_Date
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R16
	CALL _DS1307_Set_Time
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x20:
	LDD  R26,Y+6
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+7,R30
	SWAP R30
	ANDI R30,0xF0
	STD  Y+7,R30
	LDD  R26,Y+6
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	LDD  R26,Y+7
	OR   R30,R26
	STD  Y+7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	ST   -Y,R30
	LDD  R26,Y+8
	JMP  _DS1307_Receive

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(12)
	CALL _Lcd_Cmd
	LDI  R26,LOW(1)
	CALL _Lcd_Cmd
	RCALL __LOADLOCR6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_a_date)
	LDI  R31,HIGH(_a_date)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_a_month)
	LDI  R31,HIGH(_a_month)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_a_year)
	LDI  R31,HIGH(_a_year)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R20
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R16
	CALL _DS1307_Set_Date
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0x24:
	LDS  R26,_a_date
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr
	LDS  R26,_a_date
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(47)
	CALL _Lcd_Chr_Cp
	LDS  R26,_a_month
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDS  R26,_a_month
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(47)
	CALL _Lcd_Chr_Cp
	LDS  R26,_a_year
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDS  R26,_a_year
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(32)
	CALL _Lcd_Chr_Cp
	MOV  R26,R13
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R16
	CALL _DS1307_Set_Time
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x26:
	MOV  R26,R14
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr
	MOV  R26,R14
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _Lcd_Chr_Cp

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x27:
	CALL _Lcd_Out_Cp
	MOV  R26,R11
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	MOV  R26,R11
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(32)
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(58)
	CALL _Lcd_Chr_Cp
	LDI  R26,LOW(32)
	CALL _Lcd_Chr_Cp
	MOV  R26,R12
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	MOV  R26,R12
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _Lcd_Chr_Cp
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x28:
	RCALL _I2C_Start
	LDI  R26,LOW(208)
	RCALL _I2C_Send_Byte
	RCALL _I2C_Wait_Ack
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x29:
	RCALL _I2C_Send_Byte
	RJMP _I2C_Wait_Ack

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	RCALL _I2C_Start
	LDI  R26,LOW(209)
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	MOV  R30,R16
	SWAP R30
	ANDI R30,0xF
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	MOV  R30,R16
	ANDI R30,LOW(0xF)
	ADD  R30,R26
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2C:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R19,R30
	SWAP R19
	ANDI R19,0xF0
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOV  R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(0)
	RCALL _I2C_Read_Byte
	MOV  R17,R30
	LDI  R26,LOW(0)
	RCALL _I2C_Read_Byte
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2E:
	SWAP R30
	ANDI R30,0xF
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ST   X,R30
	MOV  R30,R16
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	MOV  R30,R16
	ANDI R30,LOW(0xF)
	ADD  R30,R26
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ST   X,R30
	MOV  R30,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	MOV  R30,R19
	ANDI R30,LOW(0xF)
	ADD  R30,R26
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	LDI  R26,LOW(1)
	RCALL _I2C_Read_Byte
	MOV  R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x35:
	SUB  R30,R21
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	ST   X,R30
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	LD   R26,X
	CPI  R26,LOW(0xD)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x36:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDI  R30,LOW(1)
	ST   X,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	LD   R26,X
	CPI  R26,LOW(0x64)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x37:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,LOW(100)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ST   X,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	LD   R26,X
	CPI  R26,LOW(0x64)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3D:
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	MOVW R22,R26
	LD   R26,X
	CLR  R27
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __MODW21
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3E:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	ST   X,R30
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDI  R30,LOW(12)
	ST   X,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDI  R30,LOW(100)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LD   R30,X
	LDI  R31,0
	ADIW R30,10
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LD   R30,X
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ST   X,R30
	MOVW R26,R20
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	LD   R26,X
	CPI  R26,LOW(0x18)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ST   X,R30
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4A:
	MOVW R26,R20
	LD   R30,X
	SUBI R30,-LOW(23)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4B:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ST   X,R30
	MOVW R26,R20
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	LD   R26,X
	CPI  R26,LOW(0xFF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4C:
	MOVW R26,R20
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4D:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X
	SUBI R30,-LOW(59)
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(3)
	CALL _Lcd_Write_Low_Nibble
	SBI  0x5,2
	CBI  0x5,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	CALL _Lcd_Write_Low_Nibble
	SBI  0x5,2
	CBI  0x5,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	MOV  R26,R17
	CALL _Lcd_Write_High_Nibble
	SBI  0x5,2
	CBI  0x5,2
	MOV  R26,R17
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x52:
	RCALL __SAVELOCR4
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RCALL _I2C_Start
	LDI  R26,LOW(128)
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x53:
	LDI  R26,LOW(0)
	RCALL _I2C_Read_Byte
	MOV  R16,R30
	CLR  R17
	MOV  R17,R16
	CLR  R16
	RJMP SUBOPT_0x32

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12S8:
	CP   R0,R1
	BRLO __ASRW12L
	MOV  R30,R31
	LDI  R31,0
	SBRC R30,7
	LDI  R31,0xFF
	SUB  R0,R1
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	MOVW R22,R30
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	MOVW R20,R18
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
