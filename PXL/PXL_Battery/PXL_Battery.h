#define kPrefDomain "xyz.turannul.pxlbattery"
#include "SparkColourPickerUtils.h"
#import <QuartzCore/CoreAnimation.h>
#import "Battery_Images.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

UIImageView* icon;
UIImageView* fill;
UIImageView* lockscreenBatteryIconView;
UIImageView* lockscreenBatteryChargerView;

UIColor *LowPowerModeColor;
UIColor *ChargingColor;
UIColor *LowBatteryColor;
UIColor *BatteryColor;
UIColor *batteryColorDark;
UIColor *batteryColorLight;
UIColor *Bar1;
UIColor *Bar2;
UIColor *Bar3;
UIColor *Bar4;
UIColor *Bar5;

BOOL isCharging = NO;
BOOL PXLEnabled;
BOOL SingleColorMode;
BOOL statusBarDark = NO;

double actualPercentage;
static double percentX;
static double percentY;

@interface UIStatusBarManager (StatusBarStyle)
- (int)statusBarStyle; // Declare the method signature
@end

@interface _UIBatteryView : UIView{
}
@property (nonatomic, copy, readwrite) UIColor* fillColor;
@property (nonatomic, copy, readwrite) UIColor* bodyColor;
@property (nonatomic, copy, readwrite) UIColor* pinColor;
@property (assign,nonatomic) BOOL saverModeActive;

+(instancetype)sharedInstance;
-(CGFloat)chargePercent;
-(long long)chargingState;
-(BOOL)saverModeActive;
-(BOOL)isLowBattery;
-(void)refreshIcon;
-(void)updateIconColor;
-(double)getCurrentBattery;
-(void)cleanUpViews;
@end