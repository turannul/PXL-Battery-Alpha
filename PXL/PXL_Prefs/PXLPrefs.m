#import "PXLPrefs.h"

@implementation PXLPrefs {
}

-(instancetype)init {
    myIcon = @"PXL";
    self.BundlePath = @"/Library/PreferenceBundles/PXL.bundle";
    self = [super init];
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        plist = @{
            @"items": @[
                @{
                    @"cell": @"PSGroupCell",
                    @"condensed": @YES,
                    @"headerCellClass": @"HBPackageNameHeaderCell",
                    @"icon": @"icon.png",
                    @"packageIdentifier": @"xyz.turannul.pxlbattery",
                    @"id": @"pkg_header",
                    @"packageNameOverride": @"PXL Battery"
                },
                @{
                    @"cell": @"PSGroupCell",
                    @"id": @"group_1"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"cell": @"PSSwitchCell",
                    @"default": @YES,
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"swtch_enabled",
                    @"key": @"pxlEnabled", // Now modify code to IF this key NO DO NOT Show anything except this button & pkg header
                    @"label": @"Enabled"
                },
                @{
                    @"cell": @"PSGroupCell",
                    @"id": @"group_2"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"cell": @"PSSwitchCell",
                    @"default": @YES,
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"swtch_custom_ticks",
                    @"key": @"CustomTicks",
                    @"label": @"Custom Tick color"
                },
                @{
                    @"cell": @"PSGroupCell",
                    @"id": @"group_3"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"battery_color",
                    @"cell": @"PSLinkCell",
                    @"cellClass": @"SparkColourPickerCell",
                    @"libsparkcolourpicker": @{
                        @"defaults": @"xyz.turannul.pxlbattery",
                        @"fallback": @"#FFFFFF",
                        @"alpha": @YES,
                        @"PreviewGradient": @NO
                    },
                    @"key": @"BatteryColor",
                    @"label": @"Battery Color"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"tick_1",
                    @"cell": @"PSLinkCell",
                    @"cellClass": @"SparkColourPickerCell",
                    @"libsparkcolourpicker": @{
                        @"defaults": @"xyz.turannul.pxlbattery",
                        @"fallback": @"#FFFFFF",
                        @"alpha": @YES,
                        @"PreviewGradient": @NO
                    },
                    @"label": @"Tick 1",
                    @"key": @"Bar1"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"tick_2",
                    @"cell": @"PSLinkCell",
                    @"cellClass": @"SparkColourPickerCell",
                    @"libsparkcolourpicker": @{
                        @"defaults": @"xyz.turannul.pxlbattery",
                        @"fallback": @"#FFFFFF",
                        @"alpha": @YES,
                        @"PreviewGradient": @NO
                    },
                    @"label": @"Tick 2",
                    @"key": @"Bar2"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"tick_3",
                    @"cell": @"PSLinkCell",
                    @"cellClass": @"SparkColourPickerCell",
                    @"libsparkcolourpicker": @{
                        @"defaults": @"xyz.turannul.pxlbattery",
                        @"fallback": @"#FFFFFF",
                        @"alpha": @YES,
                        @"PreviewGradient": @NO
                    },
                    @"label": @"Tick 3",
                    @"key": @"Bar3"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"tick_4",
                    @"cell": @"PSLinkCell",
                    @"cellClass": @"SparkColourPickerCell",
                    @"libsparkcolourpicker": @{
                        @"defaults": @"xyz.turannul.pxlbattery",
                        @"fallback": @"#FFFFFF",
                        @"alpha": @YES,
                        @"PreviewGradient": @NO
                    },
                    @"label": @"Tick 4",
                    @"key": @"Bar4"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"tick_5",
                    @"cell": @"PSLinkCell",
                    @"cellClass": @"SparkColourPickerCell",
                    @"libsparkcolourpicker": @{
                        @"defaults": @"xyz.turannul.pxlbattery",
                        @"fallback": @"#FFFFFF",
                        @"alpha": @YES,
                        @"PreviewGradient": @NO
                    },
                    @"label": @"Tick 5",
                    @"key": @"Bar5"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"low_battery_color",
                    @"cell": @"PSLinkCell",
                    @"cellClass": @"SparkColourPickerCell",
                    @"libsparkcolourpicker": @{
                        @"defaults": @"xyz.turannul.pxlbattery",
                        @"fallback": @"#EA3323",
                        @"alpha": @YES,
                        @"PreviewGradient": @NO
                    },
                    @"label": @"Low Battery Color",
                    @"key": @"LowBatteryColor"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"low_power_mode_color",
                    @"cell": @"PSLinkCell",
                    @"cellClass": @"SparkColourPickerCell",
                    @"libsparkcolourpicker": @{
                        @"defaults": @"xyz.turannul.pxlbattery",
                        @"fallback": @"#FFCC02",
                        @"alpha": @YES,
                        @"PreviewGradient": @NO
                    },
                    @"label": @"Low Power Mode Color",
                    @"key": @"LowPowerModeColor"
                },
                @{
                    @"PostNotification": @"xyz.turannul.pxlbattery.settingschanged",
                    @"defaults": @"xyz.turannul.pxlbattery",
                    @"id": @"charging_color",
                    @"cell": @"PSLinkCell",
                    @"cellClass": @"SparkColourPickerCell",
                    @"libsparkcolourpicker": @{
                        @"defaults": @"xyz.turannul.pxlbattery",
                        @"fallback": @"#00FF0C",
                        @"alpha": @YES,
                        @"PreviewGradient": @NO
                    },
                    @"label": @"Charging Color",
                    @"key": @"ChargingColor"
                },
                @{
                    @"cell": @"PSGroupCell",
                    @"id": @"group_4"
                },
                @{
                    @"cell": @"PSGroupCell",
                    @"footerText": @"Made with ❤️",
                    @"id": @"group_5"
                },
                @{
                    @"action": @"SourceCode",
                    @"cell": @"PSButtonCell",
                    @"icon": @"Github.png",
                    @"label": @"View source code",
                    @"id": @"source_code"
                },
                @{
                    @"cell": @"PSGroupCell",
                    @"id": @"group_6"
                },
                @{
                    @"action": @"Twitter",
                    @"cell": @"PSButtonCell",
                    @"icon": @"Twitter.png",
                    @"id": @"follow_twitter",
                    @"label": @"Follow on Twitter"
                },
                @{
                    @"action": @"DonateMe",
                    @"cell": @"PSButtonCell",
                    @"icon": @"CashApp.png",
                    @"id": @"contribute_coffee",
                    @"label": @"Contribute a Coffee"
                },
                @{
                    @"cell": @"PSGroupCell",
                    @"id": @"group_7"
                },
                @{
                    @"action": @"RandyTwitter",
                    @"cell": @"PSButtonCell",
                    @"icon": @"Twitter.png",
                    @"id": @"follow_randy",
                    @"label": @"Follow Randy420 on Twitter"
                },
                @{
                    @"action": @"DonatetoRandy420",
                    @"cell": @"PSButtonCell",
                    @"icon": @"PayPal.png",
                    @"label": @"Donate to Randy420",
                    @"id": @"donate_randy"
                },
                @{
                    @"cell": @"PSGroupCell",
                    @"id": @"group_8"
                },
                @{
                    @"action": @"resetPrefs",
                    @"cell": @"PSButtonCell",
                    @"label": @"Restore Defaults",
                    @"id": @"restore_defaults"
                }
            ]
        };
    }
    return self;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        self.plistName = @"MainPrefs";
        self.BarGroup = @[@"tick_5", @"tick_4", @"tick_3", @"tick_2", @"tick_1"];
        self.onSwitchIDs = @[@"group_8", @"donate_randy", @"follow_randy", @"group_7", @"contribute_coffee", @"follow_twitter", @"group_6", @"source_code", @"group_5", @"group_4", @"charging_color", @"low_power_mode_color", @"low_battery_color", self.BarGroup, @"battery_color", @"group_3", @"swtch_custom_ticks", @"group_2", @"pkg_header"];
 }
    return [super specifiers];
}


-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[UIView animateWithDuration:INFINITY animations:^{
		self.navigationController.navigationBar.tintColor = nil;
	}];
}

-(void)respringApply {
	_respringApplyButton = (_respringApplyButton) ? _respringApplyButton : [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(respringConfirm)];
	[[self navigationItem] setRightBarButtonItem:_respringApplyButton animated:YES];
}

-(void)respringConfirm {
	if ([[[self navigationItem] rightBarButtonItem] isEqual:_respringConfirmButton]) {
		[self respring];
	} else {
		_respringConfirmButton = (_respringConfirmButton) ? _respringConfirmButton : [[UIBarButtonItem alloc] initWithTitle:@"Respring?" style:UIBarButtonItemStylePlain target:self action:@selector(respringConfirm)];
		[_respringConfirmButton setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.00]];
		[[self navigationItem] setRightBarButtonItem:_respringConfirmButton animated:YES];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self respringApply];
		});
	}
}

- (void)resetPrefs {
	UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Restore Defaults?" style:UIBarButtonItemStylePlain target:self action:@selector(Confirm)];
	resetButton.tintColor = [UIColor redColor];
	self.navigationItem.rightBarButtonItem = resetButton;
}

- (void)Confirm {
	if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Are you sure?"]) {
		[self resetprefs];
		[self reloadSpecifiers];
		
		for (int i = 3; i > -1; i--) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((3-i) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Respringing in %d", i];
			});
			
			if (i == 0) {
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self respring];
				});
			}
		}
	} else {
		self.navigationItem.rightBarButtonItem.title = @"Are you sure?";
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self respringApply];
		});
	}
}

-(void)respring {
	NSTask *killallBackboardd = [NSTask new];
	[killallBackboardd setLaunchPath:@"/usr/bin/killall"];
	[killallBackboardd setArguments:@[@"-9", @"SpringBoard"]];
	[killallBackboardd launch];
}

-(void)resetprefs {
	NSTask *resetprefs = [NSTask new];
	[resetprefs setLaunchPath:@"/bin/rm"];
	[resetprefs setArguments:@[@"-f", @"/var/mobile/Library/Preferences/xyz.turannul.pxlbattery.plist"]];
	[resetprefs launch];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	[self respringApply];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
    NSString *key = [specifier propertyForKey:@"key"];
    if ([key isEqualToString:@"CustomTicks"]) {
        CustomTicks = GetBool(@"CustomTicks", YES, @"xyz.turannul.pxlbattery");
            if (CustomTicks) {
                NSLog(@"Randy420:reload:hideMe:");
                for (NSString *BarGroup in self.BarGroup) {
                    [self showMe:BarGroup after:@"battery_color" animate:YES];
                }
            } else {
                for (NSString *BarGroup in self.BarGroup) {
                    [self hideMe:BarGroup animate:YES];
                }
            }
    }
        MasterSwitch = GetBool(@"pxlEnabled", YES, @"xyz.turannul.pxlbattery");
            if (MasterSwitch) {
                NSLog(@"Randy420:reload:hideMe:");
                for (NSString *onSwitchIDs in self.onSwitchIDs)
                    [self showMe:onSwitchIDs after:@"pkg_header" animate:YES];
            } else {
                    for (NSString *onSwitchIDs in self.onSwitchIDs)
                    [self hideMe:onSwitchIDs animate:YES];
            }
}

- (void)reloadSpecifiers {
    [super reloadSpecifiers];

    CustomTicks = GetBool(@"CustomTicks", YES, @"xyz.turannul.pxlbattery");
    if (CustomTicks) {
        NSLog(@"Randy420:reload:hideMe:");
        for (NSString *BarGroup in self.BarGroup)
            [self hideMe:BarGroup animate:YES];

    } else {
        for (NSString *BarGroup in self.BarGroup)
            [self showMe:BarGroup after:@"swtch_custom_ticks" animate:YES];
    }

    MasterSwitch = GetBool(@"pxlEnabled", YES, @"xyz.turannul.pxlbattery");
    if (MasterSwitch) {
        NSLog(@"Randy420:reload:hideMe:");
        for (NSString *onSwitchIDs in self.onSwitchIDs)
        [self hideMe:onSwitchIDs animate:YES];

        } else {
                    for (NSString *onSwitchIDs in self.onSwitchIDs)
                                [self showMe:onSwitchIDs after:@"pkg_header" animate:YES];
        }
}

// Buttons
-(void)SourceCode { [self link:@"https://github.com/turannul/PXL-Battery" name:@"Source Code"]; }
-(void)Twitter { [self link:@"https://twitter.com/ImNotTuran" name:@"Follow me on Twitter"]; }
-(void)DonateMe { [self link:@"https://cash.app/$TuranUl" name:@"Donate"]; }
-(void)RandyTwitter { [self link:@"https://twitter.com/rj_skins?s=21&t=YudSBh0iDY9C5zQIsJbXcA" name:@"Follow Randy on Twitter"]; }
-(void)DonatetoRandy420 { [self link:@"https://www.paypal.com/paypalme/4Randy420" name:@"Donate to Randy"]; }
@end