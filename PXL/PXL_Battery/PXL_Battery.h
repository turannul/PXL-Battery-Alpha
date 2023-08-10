#define kPrefDomain "xyz.turannul.pxlbattery"
#include "SparkColourPickerUtils.h"
#import <QuartzCore/CoreAnimation.h>
#import "Battery_Images.h"
#import "UIImage+AverageColor.h"

UIImageView* icon;
UIImageView* fill;
UIImageView* lockscreenBatteryIconView;
UIImageView* lockscreenBatteryChargerView;

UIColor *LowPowerModeColor;
UIColor *ChargingColor;
UIColor *LowBatteryColor;
UIColor *BatteryColor;
UIColor *Bar1;
UIColor *Bar2;
UIColor *Bar3;
UIColor *Bar4;
UIColor *Bar5;

BOOL isCharging = NO;
BOOL PXLEnabled;
BOOL SingleColorMode;

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
-(CGFloat)luminanceForColor:(UIColor *)color;
-(UIColor *)statusBarColor;
-(CGFloat)chargePercent;
-(long long)chargingState;
-(BOOL)saverModeActive;
-(BOOL)isLowBattery;
-(void)refreshIcon;
-(void)updateIconColor;
-(double)getCurrentBattery;
-(void)cleanUpViews;
@end