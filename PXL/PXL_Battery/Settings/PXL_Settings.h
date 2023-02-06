#include <Foundation/Foundation.h>

BOOL PXLEnabled;

@interface pxlSettings : NSObject{}
@property (nonatomic, copy) NSMutableDictionary *preferences;

-(BOOL)pxlEnabled;
-(NSString *)LPM_Color;
@end
