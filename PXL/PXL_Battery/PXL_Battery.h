//PXL_Battery.h
//@@ -1,41 +1,41 @@ Saved from git stash

#import <QuartzCore/CoreAnimation.h>
#import "BATTERY_IMAGE.h"
#import "includes.h"

UIImageView* icon;
UIImageView* fill;
UIImageView* lockscreenBatteryIconView;
UIImageView* lockscreenBatteryChargerView;

UIColor *LPM_Color;
UIColor *LPM_Charging_Color;
//UIColor *LPM_Charging_Color;
UIColor *Charging_Color;
UIColor *Normal_Color;
UIColor *Low_Battery_Color;

BOOL isCharging = NO;
BOOL customViewApplied = NO;
BOOL PXLEnabled;

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
-(CGFloat)chargePercent;
-(long long)chargingState;
-(BOOL)saverModeActive;
-(BOOL)isLowBattery;
-(void)refreshIcon;
-(void)updateIconColor;
-(double)getCurrentBattery;
-(void)cleanUpViews;
@end
