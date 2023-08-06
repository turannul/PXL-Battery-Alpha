#import <Preferences/PSListController.h>
#import <Foundation/Foundation.h>
#import "Functions/Turann.h"
#import "Functions/SparkColourPickerUtils.h"
@interface PXLPrefs:Turann {
    NSDictionary *plist;
    BOOL CustomTicks;
    BOOL MasterSwitch;
    BOOL hideCharging;
    }
@property (nonatomic, retain) UIBarButtonItem *respringApplyButton;
@property (nonatomic, retain) UIBarButtonItem *respringConfirmButton;
@property (nonatomic, strong) NSArray *BarGroup;
@property (nonatomic, strong) NSArray *onSwitchIDs;
@end
