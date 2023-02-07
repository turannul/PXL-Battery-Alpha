#define kPrefDomain "xyz.turannul.pxlbattery"
#include <Foundation/Foundation.h>

@interface pxlSettings : NSObject{}
@property (nonatomic, copy) NSMutableDictionary *preferences;

-(BOOL)pxlEnabled;
-(NSString *)LPM_Color;
//-(NSString *)LPM_Charging_Color;
-(NSString *)C_Color;
-(NSString *)B_Color;
-(NSString *)LB_Color;
@end