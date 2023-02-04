#import "PXL_LPM.h"

@implementation PXL_LPM



// LowPower Framework not a thing in iOS 14... I found i can change lpm state using this
// Question how?
//    -(void)enableLowPowerMode { [[NSProcessInfo processInfo] setLowPowerModeEnabled:YES]; }
//    -(void)disableLowPowerMode { [[NSProcessInfo processInfo] setLowPowerModeEnabled:NO]; }
//    -(void)LowPowerMode { [[NSProcessInfo processInfo] isLowPowerModeEnabled]; }

/*
 -(void)selected {
 if lowpower condition = 1
 turn off
 else
 turn on
 }
 */
/*
 Another thing i need to figure how, UIBatteryView in CC Module? not sure is that possible?
 Second idea may crazy but worth to try on... Replace Apple's LPM CC Icon with UIBatteryView. also can i make it?
 */
- (UIImage *)iconGlyph {
    return [UIImage imageNamed:@"nothing" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

- (UIColor *)selectedColor {
return [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(0.0/255.0) alpha:1.0];
}
/*  - (BOOL)isSelected { // This is nonsense
but atleast i trying to do.
    [[NSProcessInfo processInfo] 
    // Work here
    [[NSProcessInfo processInfo]
    BOOL isLowPowerModeEnabled = [[NSProcessInfo processInfo] isLowPowerModeEnabled];
    if (isLowPowerModeEnabled) {
        NSLog(@"Low power mode is currently enabled");
        [[NSProcessInfo processInfo] setLowPowerModeEnabled:NO];
        NSLog(@"Low power mode disabled using my bundle");
    } else {
        NSLog(@"Low power mode is currently disabled");
        [[NSProcessInfo processInfo] setLowPowerModeEnabled:YES];
        NSLog(@"Low power mode enabled using my bundle");
    } */
- (void)setSelected:(bool)selected { [super refreshState]; }
@end
