export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:13.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.1.sdk

FINALPACKAGE = 1
DEBUG = 0

# I need it for make install command its localhost you could use too
THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222

INSTALL_TARGET_PROCESSES = SpringBoard
SUBPROJECTS += PXL/PXL_Battery           # Basic code works no bugs, more features coming. Completed:%50

#SUBPROJECTS += PXL/PXL_CC_Modules/ON-OFF # It works.  Compeleted:%100

#SUBPROJECTS += PXL/PXL_CC_Modules/LPM    # Development Stage  Completed:%0 I don't know how to do that

SUBPROJECTS += PXL/PXL_Prefs             # Basic switch works no bugs, more Features needs to be implemented. Completed:%50
#Speed up compling with not compling uneeded parts

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
c:
	find . -name ".DS_Store" -delete
#Clean up using 'make c'