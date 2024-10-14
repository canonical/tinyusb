MCU_VARIANT = stm32f730xx
PORT ?= 0
SPEED ?= high

CFLAGS += \
  -DSTM32F730xx \
  -DHSE_VALUE=8000000 \

LD_FILE = $(BOARD_PATH)/STM32F7xx_FLASH.ld
SRC_S += $(ST_CMSIS)/Source/Templates/gcc/startup_stm32f730xx.s

# flash target using on-board stlink
flash: flash-stlink

# For flash-jlink target
JLINK_DEVICE = stm32f723ie
