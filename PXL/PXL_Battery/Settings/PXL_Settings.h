//PXL_Settings.h
//@@ -1,13 +1,13 @@ Saved from git stash
#include <Foundation/Foundation.h>

@interface pxlSettings : NSObject{}
@property (nonatomic, copy) NSMutableDictionary *preferences;

-(BOOL)pxlEnabled;
-(NSString *)LPM_Color;
-(NSString *)LPM_Charging_Color;
//-(NSString *)LPM_Charging_Color;
-(NSString *)Charging_Color;
-(NSString *)Normal_Color;
-(NSString *)Low_Battery_Color;
@end
