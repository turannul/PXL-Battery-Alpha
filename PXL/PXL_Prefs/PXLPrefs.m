#import "PXLPrefs.h"

@implementation PXLPrefs

-(instancetype)init{
	myIcon = @"PXL";
	//myTitle = @"PXL Battery";
	self.BundlePath=@"/Library/PreferenceBundles/PXL.bundle";

	self = [super init];
	return self;
}

-(NSArray *)specifiers{
	self.plistName = @"MainPrefs";
	self.chosenIDs = @[@"Bottom", @"example2"];
	return [super specifiers];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[UIView animateWithDuration:INFINITY animations:^{
		[[[[self navigationController] navigationController] navigationBar] setTintColor:nil];
	}];
}

-(void)respringApply{
	_respringApplyButton = (_respringApplyButton)? _respringApplyButton : [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(respringConfirm)];
	[[self navigationItem] setRightBarButtonItem:_respringApplyButton animated:YES];
}

-(void)respringConfirm{
	if ([[[self navigationItem] rightBarButtonItem] isEqual:_respringConfirmButton]){
		[self respring];
	}else{
		_respringConfirmButton = (_respringConfirmButton)? _respringConfirmButton : [[UIBarButtonItem alloc] initWithTitle:@"Respring?" style:UIBarButtonItemStylePlain target:self action:@selector(respringConfirm)];
		[_respringConfirmButton setTintColor:[UIColor colorWithRed: 1.00 green: 0.00 blue: 0.00 alpha: 1.00]];
		[[self navigationItem] setRightBarButtonItem:_respringConfirmButton animated:YES];

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self respringApply];
		});
	}
}

-(void)respring{
	NSTask *killallBackboardd = [NSTask new];
	[killallBackboardd setLaunchPath:@"/usr/bin/killall"];
	[killallBackboardd setArguments:@[@"-9", @"backboardd"]];
	[killallBackboardd launch];
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	[self respringApply];
}

// Buttons
-(void)SourceCode
{
	[self link:@"https://github.com/turannul/PXL-Battery" name:@"Source Code"];
}

-(void)Twitter
{
	[self link:@"https://twitter.com/ImNotTuran" name:@"Follow me on Twitter"];
}
-(void)DonateMe
{
	[self link:@"https://cash.app/$TuranUl" name:@"Donate"];
}

-(void)RandyTwitter
{
	[self link:@"https://twitter.com/rj_skins?s=21&t=YudSBh0iDY9C5zQIsJbXcA" name:@"Follow Randy on Twitter"];
}
-(void)DonatetoRandy420
{
	[self link:@"https://www.paypal.com/paypalme/4Randy420" name:@"Donate to Randy"];
}
@end
