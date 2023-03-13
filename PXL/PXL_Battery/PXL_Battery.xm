#import "PXL_Battery.h"

#define RED [UIColor colorWithRed:234.0/255.0 green:51.0/255.0 blue:35.0/255.0 alpha:1.0f]
#define GREEN [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:12.0/255.0 alpha:1.0f]

static NSString *GetNSString(NSString *pkey, NSString *defaultValue){
	NSDictionary *Dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", @kPrefDomain]];
	
	return [Dict objectForKey:pkey] ? [Dict objectForKey:pkey] : defaultValue;
}

static BOOL GetBool(NSString *pkey, BOOL defaultValue){
	NSDictionary *Dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", @kPrefDomain]];

	return [Dict objectForKey:pkey] ? [[Dict objectForKey:pkey] boolValue] : defaultValue;
}

static void loader(){
	PXLEnabled = GetBool(@"pxlEnabled", YES);

	NSString *Color = GetNSString(@"BatteryColor", @"#FFFFFF");
	BatteryColor = [SparkColourPickerUtils colourWithString:Color withFallback:@"#FFFFFF"];

	Color = GetNSString(@"LowPowerModeColor", @"#FFCC02");
	LowPowerModeColor = [SparkColourPickerUtils colourWithString:Color withFallback:@"#FFCC02"];

	Color = GetNSString(@"LowBatteryColor", @"#EA3323");
	LowBatteryColor = [SparkColourPickerUtils colourWithString:Color withFallback:@"#EA3323"];

	Color = GetNSString(@"ChargingColor", @"#00FF0C");
	ChargingColor = [SparkColourPickerUtils colourWithString:Color withFallback:@"#00FF0C"];
}

%group PXLBattery // Here go again
%hook _UIStaticBatteryView// Control Center Battery
-(bool) _showsInlineChargingIndicator{return PXLEnabled?NO:%orig;} // Hide charging bolt
-(bool) _shouldShowBolt{return PXLEnabled?NO:%orig;} // Hide charging bolt x2
-(id) bodyColor{return PXLEnabled?[UIColor clearColor]:%orig;} // Hide the body
-(CGFloat) bodyColorAlpha{return PXLEnabled?0.0:%orig;}// Hide the body x2
-(id) pinColor{return PXLEnabled?[UIColor clearColor]:%orig;}// Hide the pin
-(CGFloat) pinColorAlpha{return PXLEnabled?0.0:%orig;} // Hide battery pin x2
-(id) _batteryFillColor{return PXLEnabled?[UIColor clearColor]:%orig;} // Hide the fill

-(void)_updateFillLayer{
	PXLEnabled?[self refreshIcon]:%orig; 
}
%end
		/*
		Research required here.
		%hook ? // Lock Screen Charging view
		 -(void)_updateFillLayer{ if (PXLEnabled){ [self refreshIcon]; }else{ %orig; }
		 %end
	%hook ?? // Control Center LPM Module
			-(void)_updateFillLayer{ if (PXLEnabled){ [self refreshIcon]; }else{ %orig; }
	%end
		*/
%hook _UIBatteryView // SpringBoard Battery
%new
+ (instancetype)sharedInstance{
	static _UIBatteryView *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = (_UIBatteryView *) [[[self class] alloc] init];
	});
	return sharedInstance;
}

-(BOOL)_showsInlineChargingIndicator{return PXLEnabled?NO:%orig;} // Hide charging bolt
-(BOOL)_shouldShowBolt{return PXLEnabled?NO:%orig;} // Hide charging bolt x2
-(id)bodyColor{return PXLEnabled?[UIColor clearColor]:%orig;} // Hide the body
-(CGFloat)bodyColorAlpha{return PXLEnabled?0.0:%orig;}// Hide the body x2
-(id)pinColor{return PXLEnabled?[UIColor clearColor]:%orig;}// Hide the pin
-(CGFloat)pinColorAlpha{return PXLEnabled?0.0:%orig;} // Hide the pin x2
-(id)_batteryFillColor{return PXLEnabled?[UIColor clearColor]:%orig;} // Hide the fill

//-----------------------------------------------
//Keep updating view

-(void)_updateFillLayer{
	if (PXLEnabled)
		[self refreshIcon];
	else
		%orig;
}
// when low power mode activated
-(void)setSaverModeActive:(bool)arg1{
	%orig;
	if (PXLEnabled)
		[self refreshIcon];
}
// when charger plugged
-(void)setChargingState:(long long)arg1{
	%orig;
	isCharging = (arg1 == 1); // 1 = Charging
	if (PXLEnabled)
		[self refreshIcon];
}
//-----------------------------------------------
//Update corresponding battery percentage
-(CGFloat)chargePercent
{
	CGFloat orig = %orig;
	actualPercentage = orig * 100;

	return orig;
}

%new
-(void)cleanUpViews{
	for (UIImageView* imageView in [self subviews])
		[imageView removeFromSuperview];
}

%new
-(void)refreshIcon{
	if (!PXLEnabled)
		return;

	[self chargePercent];
	icon = nil;
	fill = nil;

// Frame as base64
	[self cleanUpViews];

	NSData *batteryImage = BATTERY_IMAGE;
	NSData *batteryLowImage = BATTERY_LOW_IMAGE;

	if (!icon){
		icon = [[UIImageView alloc] initWithFrame:[self bounds]];
		[icon setContentMode:UIViewContentModeScaleAspectFill];
		[icon setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		if (![icon isDescendantOfView:self])
			[self addSubview:icon];
	}
// Update tick count in battery %
	float barPercent = 0.00f;
	if (!fill){
		int tickCt = 0;

		if (actualPercentage >= 80){
			tickCt = 5;
			barPercent = ((actualPercentage - 80) / 20.00f);
		}else if (actualPercentage >= 60){
			tickCt = 4;
			barPercent = ((actualPercentage - 60) / 20.00f);
		}else if (actualPercentage >= 40){
			tickCt = 3;
			barPercent = ((actualPercentage - 40) / 20.00f);
		}else if (actualPercentage >= 20){
			tickCt = 2;
			barPercent = ((actualPercentage - 20) / 20.00f);
		}else if (actualPercentage >= 6){
			tickCt = 1;
			barPercent = ((actualPercentage - 6) / 14.00f);
		}else{
			tickCt = 0;
		}

		float iconLocationX = icon.frame.origin.x + 2;
		float iconLocationY = icon.frame.origin.y + 2.75;
		float barWidth = (icon.frame.size.width - 6) / 6;
		float barHeight = icon.frame.size.height - 5;

		for (int i = 1; i <= tickCt; ++i){
			UIView *fill;
			if (i == tickCt)
				fill = [[UIView alloc] initWithFrame: CGRectMake(iconLocationX + ((i-1)*(barWidth + 1)), iconLocationY, barWidth * barPercent, barHeight)];
			else
				fill = [[UIView alloc] initWithFrame: CGRectMake(iconLocationX + ((i-1)*(barWidth + 1)), iconLocationY, barWidth, barHeight)];
			[fill setContentMode:UIViewContentModeScaleAspectFill];
			[fill setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];	
//-----------------------------------------------

//Colors
	if ([self saverModeActive]){
		fill.backgroundColor = LowPowerModeColor; //This should return correctly formatted value.
	} else {
		if (isCharging){
			fill.backgroundColor = ChargingColor;
		} else {
			if (actualPercentage >= 20) //{
				// Attempt 9 
//				if ([BatteryColor colourWithHexString:@"#FFFFFF:1.00"]) /* NOT sure about this */{ 
					/* 
					Explanation and Workaround Idea:
					I made a mistake here If BatteryColor = white <read from plist> (#000000[:1.00]) apply labelColor. `May, my logic is wrong?` 
					labelColor is Dark/Light switch introduced in iOS 13. Problem is, Black required when some apps not support Dark Mode. (eg Cydia) 
					Actual idea was to use labelColor if BatteryColor = white. But I failed to implement it. 
					Here whats left behind my attepmts. 
					See Attempts.txt 
					-Turann_
					*/

				//	fill.backgroundColor = [UIColor labelColor];
    			//} else { 
    				fill.backgroundColor = BatteryColor; 
    			//} 
			/*} */else /*{*/
				fill.backgroundColor = LowBatteryColor; /* This executed for some reason while battery not even low (Because of my [failed] workaround) */
			//}
		}
	}
	[self addSubview:fill];
	} 
	}


	//UIImageView *percentageLabel = 
//-----------------------------------------------
//Loading Frame
	if (actualPercentage >= 6)
		[icon setImage:[UIImage imageWithData:batteryImage]];
	else
		[icon setImage:[UIImage imageWithData:batteryLowImage]];

	[self updateIconColor];
}
//-----------------------------------------------
/*%new
+(UIImage *)imageFromText:(NSString *)text{
	UIFont *font = [UIFont systemFontOfSize:20.0];
	CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:
		[UIFont systemFontOfSize:20.0f]}];
	if (UIGraphicsBeginImageContextWithOptions != NULL)
		UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
	else
		UIGraphicsBeginImageContext(size);

	[text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
//    [text drawAtPoint:CGPointMake(0.0, 0.0) forWidth:CGPointMake(0, 0) withFont:font fontSize:nil lineBreakMode:NSLineBreakByWordWrapping baselineAdjustment:NSTextAlignmentCenter];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}
*/
%new
// Load colors in conditions
-(void)updateIconColor{
	if (!PXLEnabled)
		return;

icon.image = [icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; // What this does actually?
fill.image = [fill.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

	if (![self saverModeActive]){
		if (isCharging){
			[icon setTintColor:ChargingColor];
			[fill setTintColor:ChargingColor];
		}else{
			if (actualPercentage >= 20){
				[icon setTintColor:BatteryColor];
				[fill setTintColor:BatteryColor];
			}else{
            	[icon setTintColor:fill.backgroundColor = BatteryColor];
                [fill setTintColor:fill.backgroundColor = LowBatteryColor];
				if (actualPercentage >= 10){
                    [icon setTintColor:BatteryColor];
                    [fill setTintColor:BatteryColor];
				}else{
					[icon setTintColor:fill.backgroundColor = LowBatteryColor];
					[fill setTintColor:fill.backgroundColor = LowBatteryColor];

				}
			}
		}
	}else{
		if (isCharging){
			[icon setTintColor:fill.backgroundColor = ChargingColor];
			[fill setTintColor:fill.backgroundColor = ChargingColor];

		}else{
			[icon setTintColor:fill.backgroundColor = LowPowerModeColor];
			[fill setTintColor:fill.backgroundColor = LowPowerModeColor];
		}
	}
}
/*
This code sets colors for battery icon & fill. 
Colors are determined by whether device is in low power mode, charging, or has a certain battery percentage. 
If device is in low power mode, colors will be set to LowPowerModeColor. 
If charging = 1, colors will be set to ChargingColor. 
If device has a battery percentage of 20% or greater, colors will be set to BatteryColor. 
If device has a battery percentage of less than 20%, colors will be set to LowBatteryColor. 
Code sets both tint color of icon and fill using appropriate color value.
*/
%end

// Purpose of the code coloring other items in the status bar Poor impelementation sends straight to safe mode. 
// Inactive (cell wifi color unhandled)
/* 
 *
 * -[_UIStatusBarCellularSignalView refreshIcon]: unrecognized selector sent to instance 0x10c83d380 thats bad idea lol.
 *
 *
 *
*/

%hook _UIStatusBarCellularSignalView //_UIStatusBar Wrong Hook (safe mode)
-(void)setActiveColor:(UIColor *)color{
	if (PXLEnabled && actualPercentage >= 20) {
		if (isCharging == 1) { %orig(ChargingColor); }  
			else if (actualPercentage <= 20) { %orig(LowBatteryColor); }
				else { %orig(BatteryColor); }
					} else {
						%orig;
						}
						}
%end
/* 
 *To do Replace PXLEnabled here with a switch 
 * if pxlenabled if switch [code] else do nothing
 *        >>>>>>>>>>>>>>>>>>>>>>>>>:UP
*/ 

%hook _UIStatusBarWifiSignalView
-(void)setActiveColor:(UIColor *)color{
	if (PXLEnabled && actualPercentage >= 20) {
		if (isCharging == 1) { %orig(ChargingColor); }  
			else if (actualPercentage <= 20) { %orig(LowBatteryColor); }
				else { %orig(BatteryColor); }
					} else {
						%orig;
						}
						}
%end
// Find Time View.
%hook _UIStatusBarStringView //Labels for general including clock?
-(void)setActiveColor:(UIColor *)color{
	if (PXLEnabled && actualPercentage >= 20) {
		if (isCharging == 1){ 
			%orig(ChargingColor); }  
			else if (actualPercentage <= 20){ 
				%orig(LowBatteryColor); }
				else{ 
					%orig(BatteryColor); }
					} else {
						%orig;
						}
						}
%end
%hook _UIStatusBarActivityIndicator

-(void)setActiveColor:(UIColor *)color{
	if (PXLEnabled && actualPercentage >= 20) {
		if (isCharging == 1){ 
			%orig(ChargingColor); }  
			else if (actualPercentage <= 20){ 
				%orig(LowBatteryColor); }
				else{ 
					%orig(BatteryColor); }
					} else {
						%orig;
						}
						}
    %end

%hook _UIStatusBarImageView // Small logos in status bar (Rotation, DND, Alarm...)

      -(void)setActiveColor:(UIColor *)color{
	if (PXLEnabled && actualPercentage >= 20) {
		if (isCharging == 1){ 
			%orig(ChargingColor); }  
			else if (actualPercentage <= 20){ 
				%orig(LowBatteryColor); }
				else{ 
					%orig(BatteryColor); }
					} else {
						%orig;
						}
						}
    %end

%end
%ctor{
	loader();
	%init(PXLBattery);
}