export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:13.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.1.sdk

FINALPACKAGE = 1
DEBUG = 0

INSTALL_TARGET_PROCESSES = SpringBoard

SUBPROJECTS += PXL/PXL_Battery           # Basic code works no bugs, more features coming. Completed:%50
SUBPROJECTS += PXL/PXL_CC_Modules/ON-OFF # It works.  Compeleted:%100
#SUBPROJECTS += PXL/PXL_CC_Modules/LPM    # Development Stage  Completed:%0 I don't know how to do that
SUBPROJECTS += PXL/PXL_Prefs             # Basic switch works no bugs, more Features needs to be implemented. Completed:%50

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
	
c:
	find . -name ".DS_Store" -delete
	rm -rf .theos/
#Clean caches using 'make c'
