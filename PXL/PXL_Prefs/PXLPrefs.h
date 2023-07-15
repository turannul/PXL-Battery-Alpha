#import <Preferences/PSListController.h>
#import <Foundation/Foundation.h>
#import "Functions/Turann.h"
#import "Functions/SparkColourPickerUtils.h"
@interface PXLPrefs:Turann{BOOL CustomTicks;}
@property (nonatomic, retain) UIBarButtonItem *respringApplyButton;
@property (nonatomic, retain) UIBarButtonItem *respringConfirmButton;
@property (nonatomic, strong) NSArray *customColorIDS;
@end
