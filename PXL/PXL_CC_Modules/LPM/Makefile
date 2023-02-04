SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk
TARGET = iphone:clang:11.2:11.0
ARCHS = arm64 arm64e

BUNDLE_NAME = PXL_LPM

$(BUNDLE_NAME)_FILES = PXL_LPM.m
$(BUNDLE_NAME)_INSTALL_PATH = /Library/ControlCenter/Bundles/
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = ControlCenterUIKit IOKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
