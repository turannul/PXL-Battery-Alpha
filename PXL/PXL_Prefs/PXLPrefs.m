#import "PXLPrefs.h"

@implementation PXLPrefs 

-(instancetype)init {
    myIcon = @"PXL";
    self.BundlePath = @"/Library/PreferenceBundles/PXL.bundle";
    
    self = [super init];
    return self;
}

- (NSArray *)specifiers {
	self.plistName = @"MainPrefs";
    self.chosenIDs = @[@"switch0", @"switch1", @"a0",@"a1",@"a2",@"a3",@"a4",@"a5",@"a6",@"a7",@"a8",@"a9",@"a10",@"a11",@"a12",@"a13",@"a14",@"a15",@"a16",@"a17",@"a18",@"a19",@"a20",@"a21"];
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

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
    NSString *key = [specifier propertyForKey:@"key"];

    	/*if ([key isEqualToString:@"CustomTicks"]){
		if ([value boolValue]){
			[self hideMe:@"a4" animate:YES];
			[self hideMe:@"a5" animate:YES];
			[self hideMe:@"a6" animate:YES];
			[self hideMe:@"a7" animate:YES];
			[self hideMe:@"a8" animate:YES];
		}else{
			[self showMe:@"a4" after:@"switch1" animate:YES];
			[self showMe:@"a5" after:@"switch1" animate:YES];
			[self showMe:@"a6" after:@"switch1" animate:YES];
			[self showMe:@"a7" after:@"switch1" animate:YES];
			[self showMe:@"a7" after:@"switch1" animate:YES];
		}*/
    if ([key isEqualToString:@"pxlEnabled"]) {
        BOOL pxlEnabled = [value boolValue];
        if (!pxlEnabled) {
            [self hideMe:@"a0" animate:YES];
            [self hideMe:@"a1" animate:YES];
            [self hideMe:@"a2" animate:YES];
            [self hideMe:@"a3" animate:YES];
            [self hideMe:@"a4" animate:YES];
            [self hideMe:@"a5" animate:YES];
            [self hideMe:@"a6" animate:YES];
            [self hideMe:@"a7" animate:YES];
            [self hideMe:@"a8" animate:YES];
            [self hideMe:@"a9" animate:YES];
            [self hideMe:@"a10" animate:YES];
            [self hideMe:@"a11" animate:YES];
            [self hideMe:@"a12" animate:YES];
            [self hideMe:@"a14" animate:YES];
            [self hideMe:@"a15" animate:YES];
            [self hideMe:@"a16" animate:YES];
            [self hideMe:@"a17" animate:YES];
            [self hideMe:@"a18" animate:YES];
            [self hideMe:@"a19" animate:YES];
            [self hideMe:@"a20" animate:YES];
            [self hideMe:@"a21" animate:YES];
        } else {
            [self showMe:@"a0" after:@"switch0" animate:YES];
            [self showMe:@"a1" after:@"a0" animate:YES];
            [self showMe:@"a2" after:@"a1" animate:YES];
            [self showMe:@"a3" after:@"a2" animate:YES];
            [self showMe:@"a4" after:@"a3" animate:YES];
            [self showMe:@"a5" after:@"a4" animate:YES];
            [self showMe:@"a6" after:@"a5" animate:YES];
            [self showMe:@"a7" after:@"a6" animate:YES];
            [self showMe:@"a8" after:@"a7" animate:YES];
            [self showMe:@"a9" after:@"a8" animate:YES];
            [self showMe:@"a10" after:@"a9" animate:YES];
            [self showMe:@"a11" after:@"a10" animate:YES];
            [self showMe:@"a14" after:@"a11" animate:YES];
            [self showMe:@"a15" after:@"a14" animate:YES];
            [self showMe:@"a16" after:@"a15" animate:YES];
            [self showMe:@"a17" after:@"a16" animate:YES];
            [self showMe:@"a18" after:@"a17" animate:YES];
            [self showMe:@"a19" after:@"a18" animate:YES];
            [self showMe:@"a20" after:@"a19" animate:YES];
            [self showMe:@"a21" after:@"a20" animate:YES];
        }
    }
}

-(void)reloadSpecifiers {
    [super reloadSpecifiers];

    BOOL pxlEnabled = GetBool(@"pxlEnabled", NO, @"xyz.turannul.pxlbattery");
    if (!pxlEnabled) {
        [self hideMe:@"a0" animate:YES];
        [self hideMe:@"a1" animate:YES];
        [self hideMe:@"a2" animate:YES];
        [self hideMe:@"a3" animate:YES];
        [self hideMe:@"a4" animate:YES];
        [self hideMe:@"a5" animate:YES];
        [self hideMe:@"a6" animate:YES];
        [self hideMe:@"a7" animate:YES];
        [self hideMe:@"a8" animate:YES];
        [self hideMe:@"a9" animate:YES];
        [self hideMe:@"a10" animate:YES];
        [self hideMe:@"a11" animate:YES];
        [self hideMe:@"a12" animate:YES];
        [self hideMe:@"a14" animate:YES];
        [self hideMe:@"a15" animate:YES];
        [self hideMe:@"a16" animate:YES];
        [self hideMe:@"a17" animate:YES];
        [self hideMe:@"a18" animate:YES];
        [self hideMe:@"a19" animate:YES];
        [self hideMe:@"a20" animate:YES];
        [self hideMe:@"a21" animate:NO];
    } else {
        [self showMe:@"a0" after:@"switch0" animate:YES];
        [self showMe:@"a1" after:@"a0" animate:YES];
        [self showMe:@"a2" after:@"a1" animate:YES];
        [self showMe:@"a3" after:@"a2" animate:YES];
        [self showMe:@"a4" after:@"a3" animate:YES];
        [self showMe:@"a5" after:@"a4" animate:YES];
        [self showMe:@"a6" after:@"a5" animate:YES];
        [self showMe:@"a7" after:@"a6" animate:YES];
        [self showMe:@"a8" after:@"a7" animate:YES];
        [self showMe:@"a9" after:@"a8" animate:YES];
        [self showMe:@"a10" after:@"switch1" animate:YES];
        [self showMe:@"a11" after:@"a10" animate:YES];
        [self showMe:@"a14" after:@"a11" animate:YES];
        [self showMe:@"a15" after:@"a14" animate:YES];
        [self showMe:@"a16" after:@"a15" animate:YES];
        [self showMe:@"a17" after:@"a16" animate:YES];
        [self showMe:@"a18" after:@"a17" animate:YES];
        [self showMe:@"a19" after:@"a18" animate:YES];
        [self showMe:@"a20" after:@"a19" animate:YES];
        [self showMe:@"a21" after:@"a20" animate:YES];
    }
}

// Buttons
-(void)SourceCode { [self link:@"https://github.com/turannul/PXL-Battery" name:@"Source Code"]; }
-(void)Twitter { [self link:@"https://twitter.com/ImNotTuran" name:@"Follow me on Twitter"]; }
-(void)DonateMe { [self link:@"https://cash.app/$TuranUl" name:@"Donate"]; }
-(void)RandyTwitter { [self link:@"https://twitter.com/rj_skins?s=21&t=YudSBh0iDY9C5zQIsJbXcA" name:@"Follow Randy on Twitter"]; }
-(void)DonatetoRandy420 { [self link:@"https://www.paypal.com/paypalme/4Randy420" name:@"Donate to Randy"]; }
@end
