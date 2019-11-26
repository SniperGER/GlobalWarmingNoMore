INSTALL_TARGET_PROCESSES = Weather

export THEOS_DEVICE_IP=Janiks-iPhone.local
export THEOS_DEVICE_PORT=22
export SDKROOT=iphoneos
export SYSROOT=$(THEOS)/sdks/iPhoneOS13.2.3.sdk

export PACKAGE_VERSION=1.1
ARCHS=arm64 arm64e
TARGET=iphone:latest:13.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GlobalWarmingNoMore
GlobalWarmingNoMore_FILES = $(wildcard *.x) $(wildcard Onboarding/*.m) $(wildcard Editor/*.m)
GlobalWarmingNoMore_CFLAGS = -fobjc-arc -I ./

include $(THEOS_MAKE_PATH)/tweak.mk
