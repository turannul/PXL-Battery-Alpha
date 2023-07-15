#import "PXLPrefs.h"

@implementation PXLPrefs 

-(instancetype)init {
	myIcon = @"PXL";
	self.BundlePath = @"/Library/PreferenceBundles/PXL.bundle";
	
	self = [super init];
	return self;
}

- (NSArray *)specifiers {
	if (!_specifiers){
		self.plistName = @"MainPrefs";
		self.IDgroup1 = @[@"tick_5", @"tick_4", @"tick_3", @"tick_2", @"tick_1", @"battery_color", @"group_3"];
		self.theRest = @[@"restore_defaults", @"group_8", @"donate_randy", @"follow_randy", @"group_7", @"contribute_coffee", @"follow_twitter", @"group_6", @"source_code", @"group_5", @"group_4", @"charging_color", @"low_power_mode_color", @"low_battery_color"];
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
	if ([key isEqualToString:@"CustomTicks"]){
		if ([value boolValue]){
			for (NSString *whichTick in self.IDgroup1)
				[self hideMe:whichTick animate:NO];
			NSLog(@"Randy420:setPreferenceValue:hideMe:");
		} else {
			for (NSString *whichTick in self.IDgroup1)
				[self showMe:whichTick after:@"swtch_custom_ticks" animate:NO];
			NSLog(@"Randy420:setPreferenceValue:showMe:");
		}
	}
/*	
	BOOL pxlEnabled = GetBool(@"pxlEnabled", NO, @"xyz.turannul.pxlbattery");
		if (!pxlEnabled) {
			[self hideMe:@"switch1" animate:YES];
			[self hideMe:@"c1" animate:YES];
			[self hideMe:@"c2" animate:YES];
			[self hideMe:@"c8" animate:YES];
			[self hideMe:@"c9" animate:YES];
			[self hideMe:@"c10" animate:YES];
			[self hideMe:@"d1" animate:YES];
			[self hideMe:@"d2" animate:YES];
			[self hideMe:@"d3" animate:YES];
			[self hideMe:@"e1" animate:YES];
			[self hideMe:@"e2" animate:YES];
			[self hideMe:@"e3" animate:YES];
			[self hideMe:@"f2" animate:YES];
			[self hideMe:@"f3" animate:YES];
			[self hideMe:@"g1" animate:YES];
		} else {
			[self showMe:@"g2" after:@"g1" animate:YES];
			[self showMe:@"f3" after:@"f2" animate:YES];
			[self showMe:@"f1" after:@"e3" animate:YES];
			[self showMe:@"e2" after:@"e1" animate:YES];
			[self showMe:@"d3" after:@"d2" animate:YES];
			[self showMe:@"c10" after:@"c9" animate:YES];
			[self showMe:@"c9" after:@"c8" animate:YES];
			[self showMe:@"c8" after:@"c7" animate:YES];
			[self showMe:@"b2" after:@"b1" animate:YES];
			[self showMe:@"switch0" after:@"a0" animate:YES];
		}*/
}

- (void)reloadSpecifiers {
	[super reloadSpecifiers];

	CustomTicks = GetBool(@"CustomTicks", YES, @"xyz.turannul.pxlbattery");
		if (CustomTicks) {
			NSLog(@"Randy420:reload:hideMe:");
			for (NSString *whichTick in self.IDgroup1)
				[self hideMe:whichTick animate:NO];

			} else {
				/*for (NSString *whichTick in self.IDgroup1)
					[self showMe:whichTick after:@"swtch_custom_ticks" animate:YES];*/
			}

/*	BOOL pxlEnabled = GetBool(@"pxlEnabled", NO, @"xyz.turannul.pxlbattery");
		if (!pxlEnabled) {
			[self hideMe:@"switch1" animate:YES];
			[self hideMe:@"c1" animate:YES];
			[self hideMe:@"c2" animate:YES];
			[self hideMe:@"c8" animate:YES];
			[self hideMe:@"c9" animate:YES];
			[self hideMe:@"c10" animate:YES];
			[self hideMe:@"d1" animate:YES];
			[self hideMe:@"d2" animate:YES];
			[self hideMe:@"d3" animate:YES];
			[self hideMe:@"e1" animate:YES];
			[self hideMe:@"e2" animate:YES];
			[self hideMe:@"e3" animate:YES];
			[self hideMe:@"f2" animate:YES];
			[self hideMe:@"f3" animate:YES];
			[self hideMe:@"g1" animate:YES];
		} else {
			[self showMe:@"g2" after:@"g1" animate:YES];
			[self showMe:@"f3" after:@"f2" animate:YES];
			[self showMe:@"f1" after:@"e3" animate:YES];
			[self showMe:@"e2" after:@"e1" animate:YES];
			[self showMe:@"d3" after:@"d2" animate:YES];
			[self showMe:@"c10" after:@"c9" animate:YES];
			[self showMe:@"c9" after:@"c8" animate:YES];
			[self showMe:@"c8" after:@"c7" animate:YES];
			[self showMe:@"b2" after:@"b1" animate:YES];
			[self showMe:@"switch0" after:@"a0" animate:YES];
		}*/
}
// Buttons
-(void)SourceCode { [self link:@"https://github.com/turannul/PXL-Battery" name:@"Source Code"]; }
-(void)Twitter { [self link:@"https://twitter.com/ImNotTuran" name:@"Follow me on Twitter"]; }
-(void)DonateMe { [self link:@"https://cash.app/$TuranUl" name:@"Donate"]; }
-(void)RandyTwitter { [self link:@"https://twitter.com/rj_skins?s=21&t=YudSBh0iDY9C5zQIsJbXcA" name:@"Follow Randy on Twitter"]; }
-(void)DonatetoRandy420 { [self link:@"https://www.paypal.com/paypalme/4Randy420" name:@"Donate to Randy"]; }
@end
