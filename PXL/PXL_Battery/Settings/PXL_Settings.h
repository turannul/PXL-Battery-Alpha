#define kPrefDomain "xyz.turannul.pxlbattery"
#include <Foundation/Foundation.h>

@interface pxlSettings : NSObject{}
@property (nonatomic, copy) NSMutableDictionary *preferences;

-(BOOL)pxlEnabled;
-(NSString *)LowPowerModeColor;
//-(NSString *)LPM_Charging_Color;
-(NSString *)ChargingColor;
-(NSString *)BatteryColor;
-(NSString *)LowBatteryColor;
@end