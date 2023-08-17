#import <Foundation/Foundation.h>

static NSString *GetNSString(NSString *pkey, NSString *defaultValue){
	NSDictionary *Dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", @kPrefDomain]];
	return [Dict objectForKey:pkey] ? [Dict objectForKey:pkey] : defaultValue;
}

static BOOL GetBool(NSString *pkey, BOOL defaultValue){
	NSDictionary *Dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", @kPrefDomain]];
	return [Dict objectForKey:pkey] ? [[Dict objectForKey:pkey] boolValue] : defaultValue;
}

static UIColor *invertColor(UIColor *originalColor){
	CGFloat red, green, blue, alpha;
	[originalColor getRed:&red green:&green blue:&blue alpha:&alpha];

	UIColor *invertedColor = [UIColor colorWithRed:(1.0 - red) green:(1.0 - green) blue:(1.0 - blue) alpha:alpha];

	return invertedColor;
}

static void loader(){
	PXLEnabled = GetBool(@"pxlEnabled", YES);
	SingleColorMode = GetBool(@"SingleColorMode",YES);

	UIStatusBarStyle statusBarStyle;

//	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.1")) {
	UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
	statusBarStyle = statusBarManager.statusBarStyle;
//	} else {
//		statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
//	}

	if (statusBarStyle == UIStatusBarStyleDefault)
		statusBarDark = YES;
	else
		statusBarDark = NO;

	NSString *Color = GetNSString(@"BatteryColor", @"#FFFFFF");
	BatteryColor = [SparkColourPickerUtils colourWithString:Color withFallback:@"#FFFFFF"];

	Color = GetNSString(@"LowPowerModeColor", @"#FFCC02");
	LowPowerModeColor = [SparkColourPickerUtils colourWithString:Color withFallback:@"#FFCC02"];

	Color = GetNSString(@"LowBatteryColor", @"#EA3323");
	LowBatteryColor = [SparkColourPickerUtils colourWithString:Color withFallback:@"#EA3323"];

	Color = GetNSString(@"ChargingColor", @"#00FF0C");
	ChargingColor = [SparkColourPickerUtils colourWithString:Color withFallback:@"#00FF0C"];

	Color = GetNSString(@"Bar1", @"#FFFFFF");
	Bar1 = [SparkColourPickerUtils colourWithString:Color withFallback:@"#FFFFFF"];

	Color = GetNSString(@"Bar2", @"#FFFFFF");
	Bar2 = [SparkColourPickerUtils colourWithString:Color withFallback:@"#FFFFFF"];

	Color = GetNSString(@"Bar3", @"#FFFFFF");
	Bar3 = [SparkColourPickerUtils colourWithString:Color withFallback:@"#FFFFFF"];

	Color = GetNSString(@"Bar4", @"#FFFFFF");
	Bar4 = [SparkColourPickerUtils colourWithString:Color withFallback:@"#FFFFFF"];

	Color = GetNSString(@"Bar5", @"#FFFFFF");
	Bar5 = [SparkColourPickerUtils colourWithString:Color withFallback:@"#FFFFFF"];

	if (!statusBarDark){
		BatteryColor = invertColor(BatteryColor);
		LowPowerModeColor = invertColor(LowPowerModeColor);
		LowBatteryColor = invertColor(LowBatteryColor);
		ChargingColor = invertColor(ChargingColor);
		Bar1 = invertColor(Bar1);
		Bar2 = invertColor(Bar2);
		Bar3 = invertColor(Bar3);
		Bar4 = invertColor(Bar4);
		Bar5 = invertColor(Bar5);
	}
}