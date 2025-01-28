MCU_VARIANT = stm32f750xx
PORT ?= 0
SPEED ?= high

CFLAGS += \
  -DSTM32F750xx \
  -DHSE_VALUE=8000000 \

LD_FILE = $(BOARD_PATH)/STM32F7xx_SRAM_FLASH.ld
SRC_S += $(BOARD_PATH)/startup_stm32f750xx.s

# flash target using on-board stlink
flash: flash-stlink

# For flash-jlink target
JLINK_DEVICE = stm32f723ie
