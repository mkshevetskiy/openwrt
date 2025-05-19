define Build/an7583-bl2-bl31-uboot
  head -c $$((0x800)) /dev/zero > $@
  cat $(STAGING_DIR_IMAGE)/an7583_$1-bl2.fip >> $@
  dd if=$(STAGING_DIR_IMAGE)/an7583_$1-bl31-uboot.img of=$@ bs=1 seek=$$((0x20000)) conv=notrunc
endef

define Device/FitImageLzma
	KERNEL_SUFFIX := -uImage.itb
	KERNEL = kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(DEVICE_DTS).dtb
	KERNEL_NAME := Image
endef

define Device/airoha_an7583-evb
  $(call Device/FitImageLzma)
  DEVICE_VENDOR := Airoha
  DEVICE_MODEL := AN7583 Evaluation Board (SNAND)
  DEVICE_PACKAGES := kmod-leds-pwm kmod-input-gpio-keys-polled
  DEVICE_DTS := an7583-evb
  DEVICE_DTS_DIR := ../dts
  DEVICE_DTS_CONFIG := config@1
  KERNEL_LOADADDR := 0x80088000
  IMAGE/sysupgrade.bin := append-kernel | pad-to 128k | append-rootfs | pad-rootfs | append-metadata
  ARTIFACT/bl2-bl31-uboot.bin := an7583-bl2-bl31-uboot rfb
  ARTIFACTS := bl2-bl31-uboot.bin
endef
TARGET_DEVICES += airoha_an7583-evb
