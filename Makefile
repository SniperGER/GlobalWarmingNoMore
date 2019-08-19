INSTALL_TARGET_PROCESSES = Weather

export THEOS_DEVICE_IP=Janiks-iPhone.local
export THEOS_DEVICE_PORT=22
export SDKROOT=iphoneos
export SYSROOT=$(THEOS)/sdks/iPhoneOS11.2.sdk

export PACKAGE_VERSION=1.0-1
ARCHS=arm64
TARGET=iphone:latest:11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GlobalWarmingNoMore
GlobalWarmingNoMore_FILES = $(wildcard *.x) $(wildcard Onboarding/*.m) $(wildcard Editor/*.m)
GlobalWarmingNoMore_CFLAGS = -fobjc-arc -I ./

include $(THEOS_MAKE_PATH)/tweak.mk
