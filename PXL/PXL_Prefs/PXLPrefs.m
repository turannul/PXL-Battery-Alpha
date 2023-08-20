#import "PXLPrefs.h"

@implementation PXLPrefs {}

-(instancetype)init {
    myIcon = @"PXL";
    self.BundlePath = @"/Library/PreferenceBundles/PXL.bundle";
    self = [super init];
    return self;
}

-(NSArray *)specifiers {
	self.plistName = @"MainPrefs";
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
  /*  NSString *key = [specifier propertyForKey:@"key"];
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
            }*/
}

- (void)reloadSpecifiers {
    [super reloadSpecifiers];

    /*CustomTicks = GetBool(@"CustomTicks", YES, @"xyz.turannul.pxlbattery");
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
        }*/
}

// Buttons
-(void)SourceCode { [self link:@"https://github.com/turannul/PXL-Battery" name:@"Source Code"]; }
-(void)Twitter { [self link:@"https://twitter.com/ImNotTuran" name:@"Follow me on Twitter"]; }
-(void)DonateMe { [self link:@"https://cash.app/$TuranUl" name:@"Donate"]; }
-(void)RandyTwitter { [self link:@"https://twitter.com/rj_skins?s=21&t=YudSBh0iDY9C5zQIsJbXcA" name:@"Follow Randy on Twitter"]; }
-(void)DonatetoRandy420 { [self link:@"https://www.paypal.com/paypalme/4Randy420" name:@"Donate to Randy"]; }
@end