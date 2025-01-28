/*
*****************************************************************************
**

**  File        : LinkerScript.ld
**
**  Abstract    : Linker script for STM32F723xE Device with
**                512KByte FLASH, 256KByte RAM
**
**                Set heap size, stack size and stack location according
**                to application requirements.
**
**                Set memory bank area and size if external memory is used.
**
**  Target      : STMicroelectronics STM32
**
**
**  Distribution: The file is distributed as is, without any warranty
**                of any kind.
**
**  (c)Copyright Ac6.
**  You may use this file as-is or modify it according to the needs of your
**  project. Distribution of this file (unmodified or modified) is not
**  permitted. Ac6 permit registered System Workbench for MCU users the
**  rights to distribute the assembled, compiled & linked contents of this
**  file as part of an application binary file, provided that it is built
**  using the System Workbench for MCU toolchain.
**
*****************************************************************************
*/

/* Entry Point */
ENTRY(Reset_Handler)

/* Highest address of the user mode stack */
_estack = 0x20040000;    /* end of RAM */
/* Generate a link error if heap and stack don't fit into RAM */
_Min_Heap_Size = 0x200;      /* required amount of heap  */
_Min_Stack_Size = 0x460; /* required amount of stack */

/* Specify the memory areas */
MEMORY
{
RAM (xrw)      : ORIGIN = 0x20000000, LENGTH = 256K
FLASH (rx)     : ORIGIN = DEFINED(_bootloader_) ? 0x90000000 :0x08000000, LENGTH = 2048K
}

/* Define output sections */
SECTIONS
{
    /* used by the startup to initialize data */
  _siisr_vector = LOADADDR(.isr_vector);

  /* The startup code goes first into FLASH */
  .isr_vector :
  {
    . = ALIGN(4);
    _sisr_vector = .;    /* create a global symbol at data start */
    KEEP(*(.isr_vector)) /* Startup code */
    . = ALIGN(4);
    _eisr_vector = .;    /* define a global symbol at data end */
  } >RAM AT> FLASH

    /* The program code and other data goes into FLASH */
  .text.Reset_Handler :
  {
    . = ALIGN(4);
    *(.text.Reset_Handler)
    . = ALIGN(4);
  } >FLASH
  
  /* used by the startup to initialize data */
  _sitext = LOADADDR(.text);

  /* The program code and other data goes into FLASH */
  .text :
  {
    . = ALIGN(4);
    _stext = .; 
    *(.text)           /* .text sections (code) */
    *(.text*)          /* .text* sections (code) */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
    *(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    _etext = .;        /* define a global symbols at end of code */
  } >RAM AT> FLASH

  /* Uninitialized data section */
  . = ALIGN(4);
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss secion */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM


  /* used by the startup to initialize data */
  _sidata = LOADADDR(.data);

  /* Initialized data sections goes into RAM, load LMA copy after code */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */
    *(.RamFunc)        /* .RamFunc sections */
    *(.RamFunc*)       /* .RamFunc* sections */

    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
  } >RAM AT> FLASH



  /* used by the startup to initialize data */
  _sirodata = LOADADDR(.rodata);

  /* Constant data goes into FLASH */
  .rodata :
  {
    . = ALIGN(4);
    _srodata = .;
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
    _erodata = .;
  } >RAM AT> FLASH
  
  /* used by the startup to initialize data */
  _siextab = LOADADDR(.ARM.extab);

  .ARM.extab   : 
  {
    _sextab = .;
     *(.ARM.extab* .gnu.linkonce.armextab.*)
     _eextab = .; 
  } >RAM AT> FLASH

  /* used by the startup to initialize data */
  _siexidx = LOADADDR(.ARM);

  .ARM : {
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
  } >RAM AT> FLASH

  /* used by the startup to initialize data */
  _sipreinit_array = LOADADDR(.preinit_array);

  .preinit_array     :
  {
    __preinit_array_start = .;
    KEEP (*(.preinit_array*))
    __preinit_array_end = .;
  } >RAM AT> FLASH

  /* used by the startup to initialize data */
  _siinit_array = LOADADDR(.init_array);

  .init_array :
  {
    __init_array_start = .;
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    __init_array_end = .;
  } >RAM AT> FLASH

    /* used by the startup to initialize data */
  _sifini_array = LOADADDR(.fini_array);

  .fini_array :
  {
    __fini_array_start = .;
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    __fini_array_end = .;
  } >RAM AT> FLASH

  /* User_heap_stack section, used to check that there is enough RAM left */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM



  /* Remove information from the standard libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
}
