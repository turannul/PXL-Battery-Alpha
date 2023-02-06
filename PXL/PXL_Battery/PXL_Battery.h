#import <QuartzCore/CoreAnimation.h>
#import "BATTERY_IMAGE.h"
#import "PXL_Settings.h"

UIImageView* icon;
UIImageView* fill;
UIImageView* lockscreenBatteryIconView;
UIImageView* lockscreenBatteryChargerView;
UIColor *LPM_Color;
BOOL isCharging = NO;
BOOL customViewApplied = NO;
double actualPercentage;
static double percentX;
static double percentY;


@interface _UIBatteryView : UIView{
}
@property (nonatomic, copy, readwrite) UIColor* fillColor;
@property (nonatomic, copy, readwrite) UIColor* bodyColor;
@property (nonatomic, copy, readwrite) UIColor* pinColor;
@property (assign,nonatomic) BOOL saverModeActive;

+(instancetype)sharedInstance;
//+(UIColor *)colorFromHexString:(NSString *)hexString;
-(CGFloat)chargePercent;
-(long long)chargingState;
-(BOOL)saverModeActive;
-(BOOL)isLowBattery;
-(void)refreshIcon;
-(void)updateIconColor;
-(double)getCurrentBattery;
-(void)cleanUpViews;
@end

#define RED [UIColor colorWithRed:234.0/255.0 green:51.0/255.0 blue:35.0/255.0 alpha:1.0f]
#define GREEN [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:12.0/255.0 alpha:1.0f]
#define YELLOW [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:2.0/255.0 alpha:1.0f]