#include <Foundation/Foundation.h>

@interface pxlSettings : NSObject{}
@property (nonatomic, copy) NSMutableDictionary *preferences;

-(BOOL)pxlEnabled;
-(NSString *)LPM_Color;
-(NSString *)LPM_Charging_Color;
-(NSString *)Charging_Color;
-(NSString *)Normal_Color;
@end
