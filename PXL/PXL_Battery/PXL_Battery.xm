#import "PXL_Battery.h"
#import "PXL_Settings.h"

static void loader() {
	pxlSettings *_settings = [[pxlSettings alloc] init];
	PXLEnabled = [_settings pxlEnabled];
	if (customViewApplied){
		[[_UIBatteryView sharedInstance] cleanUpViews];
		customViewApplied = NO;
	}
}

%group PXLBattery // Here go again
%hook _UIStaticBatteryView  // Control Center Battery
-(bool) _showsInlineChargingIndicator{return PXLEnabled?NO:%orig;}     // Hide charging bolt
-(bool) _shouldShowBolt{return PXLEnabled?NO:%orig;}                   // Hide charging bolt x2
-(id) bodyColor{return PXLEnabled?[UIColor clearColor]:%orig;}         // Hide the body
-(CGFloat) bodyColorAlpha{return PXLEnabled?0.0:%orig;}                // Hide the body x2
-(id) pinColor{return PXLEnabled?[UIColor clearColor]:%orig;}          // Hide the pin
-(CGFloat) pinColorAlpha{return PXLEnabled?0.0:%orig;}                 // Hide battery pin x2
-(id) _batteryFillColor{return PXLEnabled?[UIColor clearColor]:%orig;} // Hide the fill

-(void)_updateFillLayer{
	PXLEnabled?[self refreshIcon]:%orig; 
}
%end
		/*
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

-(BOOL)_showsInlineChargingIndicator{return PXLEnabled?NO:%orig;}     // Hide charging bolt
-(BOOL)_shouldShowBolt{return PXLEnabled?NO:%orig;}                   // Hide charging bolt x2
-(id)bodyColor{return PXLEnabled?[UIColor clearColor]:%orig;}         // Hide the body
-(CGFloat)bodyColorAlpha{return PXLEnabled?0.0:%orig;}                // Hide the body x2
-(id)pinColor{return PXLEnabled?[UIColor clearColor]:%orig;}          // Hide the pin
-(CGFloat)pinColorAlpha{return PXLEnabled?0.0:%orig;}                 // Hide the pin x2
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
	if (PXLEnabled){
		[self chargePercent];
		icon = nil;
		fill = nil;

// Frame as base64
		[self cleanUpViews];

		NSData* batteryImage = BATTERY_IMAGE;

		if (!icon){
			icon = [[UIImageView alloc] initWithFrame:[self bounds]];
			[icon setContentMode:UIViewContentModeScaleAspectFill];
			[icon setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			if (![icon isDescendantOfView:self])[self addSubview:icon];
		}
// Update tick count in battery %
		if (!fill){
			int tickCt = 0;

			if (actualPercentage >= 85)
				tickCt = 5;
			else if (actualPercentage >= 65)
				tickCt = 4;
			else if (actualPercentage >= 50)
				tickCt = 3;
			else if (actualPercentage >= 30)
				tickCt = 2;
			else if (actualPercentage >= 10)
				tickCt = 1;
			else
				tickCt = 0; //You died, R.I.P.. 
// Location of ticks
			float iconLocationX = icon.frame.origin.x + 2;
			float iconLocationY = icon.frame.origin.y + 2.75;
			float barWidth = (icon.frame.size.width - 6) / 6;
			float barHeight = icon.frame.size.height - 5;

			for (int i = 1; i <= tickCt; ++i){
				UIView *fill = [[UIView alloc] initWithFrame:CGRectMake(iconLocationX + ((i-1) * (barWidth + 1)), iconLocationY, barWidth, barHeight)];
				[fill setContentMode:UIViewContentModeScaleAspectFill];
				[fill setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

//-----------------------------------------------
//Colors
				if ([self saverModeActive]){
					fill.backgroundColor = YELLOW;
				}else{
					if (isCharging){
						fill.backgroundColor = GREEN;
					}else{
						if (actualPercentage >= 20)
							fill.backgroundColor = [UIColor labelColor];
						else
							fill.backgroundColor = RED;
					}
				}
				[self addSubview:fill];
			}
		}

//-----------------------------------------------
//Loading Frame
		[icon setImage:[UIImage imageWithData:batteryImage]];

		[self updateIconColor];
		customViewApplied=YES;
	}
}
//-----------------------------------------------
%new
// Load colors in conditions
-(void)updateIconColor{
	if (PXLEnabled){
		icon.image = [icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		fill.image = [fill.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		
		if (![self saverModeActive]){
			if (isCharging){
				[icon setTintColor:GREEN];
				[fill setTintColor:GREEN];
			}else{
				if (actualPercentage >= 20){
					[icon setTintColor:[UIColor labelColor]];
					[fill setTintColor:[UIColor labelColor]];
				}else{
					[icon setTintColor:[UIColor labelColor]];
					[fill setTintColor:fill.backgroundColor = RED];
					if (actualPercentage >= 10){
						[icon setTintColor:[UIColor labelColor]];
						[fill setTintColor:[UIColor labelColor]];
					}else{
						[icon setTintColor:fill.backgroundColor = RED];
						[fill setTintColor:fill.backgroundColor = RED];
					}
				}
			}
		}else{
			if (isCharging){
				[icon setTintColor:GREEN];
				[fill setTintColor:GREEN];
			}else{
				[icon setTintColor:YELLOW];
				[fill setTintColor:YELLOW];
			}
		}
	}
}
%end
%end
%ctor{
	loader();
	%init(PXLBattery);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loader, CFSTR("xyz.turannul.pxlbattery.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
