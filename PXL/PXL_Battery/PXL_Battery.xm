#import "PXL_Battery.h"
#import <syslog.h>
#import <QuartzCore/QuartzCore.h>
#import "statics.h"

%group PXLBattery // Here go again
%hook UIStatusBar_Modern
- (NSInteger)_effectiveStyleFromStyle:(NSInteger)arg1 {
	NSInteger original = %orig;
	if (arg1 == 3) {
		statusBarDark = YES;
	} else if (arg1 == 1) {
		statusBarDark = NO;
	} else {
		statusBarDark = YES; // Default to dark status bar for unexpected arg1.
		//NSLog(@"[PXL dbg]: arg1 has an unexpected value: %ld. Setting statusBarDark to YES.", arg1);
	}
	
	if (statusBarDark) {
		BatteryColor = [UIColor blackColor];
	// NSLog(@"[PXL dbg]: Setting BatteryColor to black.");
	} else {
		BatteryColor = [UIColor whiteColor];
		//NSLog(@"[PXL dbg]: Setting BatteryColor to white.");
	}
	//NSLog(@"[PXL dbg]: StatusBar is Dark: %d", statusBarDark);
	return original;
}
%end
%hook _UIStaticBatteryView // Control Center Battery
-(bool) _showsInlineChargingIndicator{return PXLEnabled?NO:%orig;} // Hide charging bolt
-(bool) _shouldShowBolt{return PXLEnabled?NO:%orig;} // Hide charging bolt x2
-(id) bodyColor{return PXLEnabled?[UIColor clearColor]:%orig;} // Hide the body
-(CGFloat) bodyColorAlpha{return PXLEnabled?0.0:%orig;}// Hide the body x2
-(id) pinColor{return PXLEnabled?[UIColor clearColor]:%orig;}// Hide the pin
-(CGFloat) pinColorAlpha{return PXLEnabled?0.0:%orig;} // Hide battery pin x2
-(id) _batteryFillColor{return PXLEnabled?[UIColor clearColor]:%orig;} // Hide the fill
-(void)_updateFillLayer{PXLEnabled?[self refreshIcon]:%orig;}
%end

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
	if (PXLEnabled){
		[self refreshIcon];
		if (isCharging) {
			// Set initial alpha value to 0
			for (UIView *subview in self.subviews) {
				if (![subview isKindOfClass:[UIImageView class]]) {
					subview.alpha = 0.0;
				}
			}

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				// Animate the fade-in effect
				[UIView animateWithDuration:2.5 delay:0.5 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
					for (UIView *subview in self.subviews) {
						if (![subview isKindOfClass:[UIImageView class]]) {
							subview.alpha = 1.0;
						}
					}
				} completion:nil];
			});
		}
	} else {
		%orig;
	}
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
				fill.backgroundColor = LowPowerModeColor;
			} else if (isCharging){
				fill.backgroundColor = ChargingColor;
			} else if (SingleColorMode && (i >= 1 && i <= 5)) {
				fill.backgroundColor = BatteryColor;
			} else if (i == 1 && actualPercentage >=  0) { 
				fill.backgroundColor = Bar1;
			} else if (i == 2 && actualPercentage >= 20) {
				fill.backgroundColor = Bar2;
			} else if (i == 3 && actualPercentage >= 40) {
				fill.backgroundColor = Bar3;
			} else if (i == 4 && actualPercentage >= 60) {
				fill.backgroundColor = Bar4;
			} else if (i == 5 && actualPercentage >= 80) {
				fill.backgroundColor = Bar5;
			if (actualPercentage >= 20)
				fill.backgroundColor = BatteryColor;
			else
				fill.backgroundColor = LowBatteryColor;
			} [self addSubview:fill]; } }
//-----------------------------------------------
//Loading Frame
	if (actualPercentage >= 6)
		[icon setImage:[UIImage imageWithData:batteryImage]];
	else
		[icon setImage:[UIImage imageWithData:batteryLowImage]];

	[self updateIconColor];
}

%new
// Load colors in conditions
-(void)updateIconColor{
	if (!PXLEnabled)
		return;

	icon.image = [icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; 
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
Explanation required in depth because, too many if else confusing here is what does:
This code sets colors for battery icon (frame) & fill (tick). 
Colors are determined by whether device is in low power mode, charging, or has a certain battery percentage. 
If device is in low power mode, colors will be set to LowPowerModeColor. 
If charging = 1, colors will be set to ChargingColor. 
If device has a battery percentage of 20% or greater, colors will be set to BatteryColor. 
If device has a battery percentage of less than 20%, colors will be set to LowBatteryColor. 
Code sets both tint color of icon (frame) & fill (tick) using appropriate color value.
*/
%end
%end

%ctor{
	loader();
	%init(PXLBattery);
	}