#import "PXL_Battery.h"
#import "PXL_Settings.h"

#define RED [UIColor colorWithRed:234.0/255.0 green:51.0/255.0 blue:35.0/255.0 alpha:1.0f]
#define GREEN [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:12.0/255.0 alpha:1.0f]
#define YELLOW [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:2.0/255.0 alpha:1.0f]

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

		NSData* batteryImage = [[NSData alloc] initWithBase64EncodedString:@"iVBORw0KGgoAAAANSUhEUgAAAG4AAAA0CAYAAABrTg1qAAABZ2lDQ1BEaXNwbGF5IFAzAAAokXXQsWtTcQDE8c9rlUKsg5ihQ4c3iUPUkgp2cWgrFEUwVIWkTq+vSVpI4o+XiFTcxFUK/gdWcBYcLCIVXBwcBNFBRDenTgouGp5DImkRb7njyw3HMTaVhNA6hHanly0vLcTV2ko88U0kApK0G+Yrlcvw1w/q58dB9/2pJITWXn/7wdz9pdftZy+v3Pk0debf/gEV1urdFL8xk4asR1RC5XYv9IjuophVaytEWyg2B/kxiquD/BzF7NryItFbxOl6ska0h9LqPt7cl9utW+lwQ4TJeuf6VRQx7YINXUFLYlOsYvY//bOYtuimYFNmQ9O6nti8IGipi13UkTqtJFY2o6xcra3Ew/8+DP8rjdi9r5zfzfP8xYhd2uXpOQo7I3ZyjmNHeLMTkiwB4xhrNPj+hKM1jr+jcKPbmC0P1k8ucPhLnv84wcRD+lt5/utRnve3Gf/Mq84fFylqvMNVpzcAAAAJcEhZcwAACxMAAAsTAQCanBgAAAwmaVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/PiA8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA5LjAtYzAwMCA3OS4xNzFjMjdmYWIsIDIwMjIvMDgvMTYtMjI6MzU6NDEgICAgICAgICI+IDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+IDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iIHhtbG5zOmV4aWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vZXhpZi8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0RXZ0PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bXA6Q3JlYXRvclRvb2w9IlBpeGVsbWF0b3IgUHJvIDMuMi4yIiB4bXA6Q3JlYXRlRGF0ZT0iMjAyMy0wMS0yMlQxNTo1Nzo1NCswMzowMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyMy0wMS0yMlQxNjozNjowMSswMzowMCIgeG1wOk1vZGlmeURhdGU9IjIwMjMtMDEtMjJUMTY6MzY6MDErMDM6MDAiIHRpZmY6T3JpZW50YXRpb249IjEiIHRpZmY6WFJlc29sdXRpb249IjcyMDAwMC8xMDAwMCIgdGlmZjpZUmVzb2x1dGlvbj0iNzIwMDAwLzEwMDAwIiB0aWZmOlJlc29sdXRpb25Vbml0PSIyIiBleGlmOlBpeGVsWERpbWVuc2lvbj0iMTEwIiBleGlmOlBpeGVsWURpbWVuc2lvbj0iNTIiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiBwaG90b3Nob3A6SUNDUHJvZmlsZT0iRGlzcGxheSBQMyIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoxOTU0YTY2Ny05NjgzLTQ2MzctYTU1NC00MmFhNzEyZjBkZTAiIHhtcE1NOkRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDo2NTAxYTAzZC01NzQxLWZkNDYtYTM5ZS00ZjA2N2FiMzliNDEiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoyNjg0MTUwYS0yMDRmLTRhZTYtOTRlMC00N2VjOWE3ZTBlODgiPiA8eG1wTU06SGlzdG9yeT4gPHJkZjpTZXE+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDoyNjg0MTUwYS0yMDRmLTRhZTYtOTRlMC00N2VjOWE3ZTBlODgiIHN0RXZ0OndoZW49IjIwMjMtMDEtMjJUMTY6MTM6MzArMDM6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNC4wIChNYWNpbnRvc2gpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJjb252ZXJ0ZWQiIHN0RXZ0OnBhcmFtZXRlcnM9ImZyb20gaW1hZ2UvcG5nIHRvIGFwcGxpY2F0aW9uL3ZuZC5hZG9iZS5waG90b3Nob3AiLz4gPHJkZjpsaSBzdEV2dDphY3Rpb249ImRlcml2ZWQiIHN0RXZ0OnBhcmFtZXRlcnM9ImNvbnZlcnRlZCBmcm9tIGltYWdlL3BuZyB0byBhcHBsaWNhdGlvbi92bmQuYWRvYmUucGhvdG9zaG9wIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDoyNDI5YmM4Zi05YzMwLTRlNGYtODM3My1jYWRiYjMwNmQwMjYiIHN0RXZ0OndoZW49IjIwMjMtMDEtMjJUMTY6MTM6MzArMDM6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNC4wIChNYWNpbnRvc2gpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDpmNzUwYjIxYi1jYTU3LTRiZTQtOTM4My0zZmUyZDZjNTI5NTEiIHN0RXZ0OndoZW49IjIwMjMtMDEtMjJUMTY6MTU6NDkrMDM6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNC4wIChNYWNpbnRvc2gpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJjb252ZXJ0ZWQiIHN0RXZ0OnBhcmFtZXRlcnM9ImZyb20gYXBwbGljYXRpb24vdm5kLmFkb2JlLnBob3Rvc2hvcCB0byBpbWFnZS9wbmciLz4gPHJkZjpsaSBzdEV2dDphY3Rpb249ImRlcml2ZWQiIHN0RXZ0OnBhcmFtZXRlcnM9ImNvbnZlcnRlZCBmcm9tIGFwcGxpY2F0aW9uL3ZuZC5hZG9iZS5waG90b3Nob3AgdG8gaW1hZ2UvcG5nIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDo0ZDZjNWUyZi1kODM0LTRlMDMtYTI1NS00NjMzNTZhNWVkMmQiIHN0RXZ0OndoZW49IjIwMjMtMDEtMjJUMTY6MTU6NDkrMDM6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNC4wIChNYWNpbnRvc2gpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDoxOTU0YTY2Ny05NjgzLTQ2MzctYTU1NC00MmFhNzEyZjBkZTAiIHN0RXZ0OndoZW49IjIwMjMtMDEtMjJUMTY6MzY6MDErMDM6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNC4wIChNYWNpbnRvc2gpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDwvcmRmOlNlcT4gPC94bXBNTTpIaXN0b3J5PiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpmNzUwYjIxYi1jYTU3LTRiZTQtOTM4My0zZmUyZDZjNTI5NTEiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MjQyOWJjOGYtOWMzMC00ZTRmLTgzNzMtY2FkYmIzMDZkMDI2IiBzdFJlZjpvcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6MjY4NDE1MGEtMjA0Zi00YWU2LTk0ZTAtNDdlYzlhN2UwZTg4Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+W1jOzQAAA1tJREFUeJztnN9u0zAUh7/jph0bpRNCwCbxAtzxCHv/Sy54AxACITHWdX+65nDh4zVr02zZmibZzidlS5MT2+mvdmyf+AjVvAMWwEhVf4nIEJgAc2AKHAM/gT079hkYA9+AHBBgZnY/LC3MZgqgqioiAgzM/gtwDXwF9m1fgGD5XNt2bGmkc8H2c+DCNoBXwKVdm/IQ4Bw4MJtzy+vCyjO2Y68tnUNgZNctLP+p5TkHhpb+vtlh953bdmbHxGzngFq6A8tjViXEKlJxTusk9IxQqr+XJvMNK8eSyGtsKuBLFa1tiuIFYm0tZVXhPVy0NklN/YMMi7ho3aGyuQ6qCrGz4KJ1i8qaJ0BG+QOwjQf0S2ZTxSnVIQDvmyuL0xSB5RjD6RFpUOv0jMByhsHpEYE4TeP0jIz1QXglWrO3KT7MeBKqSpzKvSUAeZqYdTqKiKz+8HOI6o3WzZ2OsSreKCO6LraGN42NkbN8rGkA3m4rZRetUe5MQFe6Dmqm6qI1j2D+wgBctVwYpz55ILron0waJtQdLjiP4ia9A3FdcrJUgPuE8Sbz0dT53sQ7Jz0lUF7bnI6ztQG417adcTtzUmuu0mmdkP48eRzntW3niNe2nrIV4XzstnM0ULeZOzkZlKZUIp4L2hhvAI6I4q1upShI1baTYj9PyjTYtJGxZX9cUTzvtDRHWibUCF4DGyP4zEk/Gbtbp58M/WWhfvI3Az60XQqnFgKxc1I6LnM6SSjuLCoMne6Q3jeZgK/W6QvFqcl/gGR456TrlOkjvsyqP9xxCGTATZ2rfRqrNYp+07y+d8DpBD4A7ymBGK/L6SEjavjjnMYo02DjauFiM+lidYvqyEKF/eOGC+I8nHunIYXYVBZ9cl7z2kUK/0dscLslR2ooGB82XjRnE0XRlApfaZcDjW4r4Ge6j64Pe4qibYqvtmZ8y0p4hox44x+B3yzD9SaDPeIyrZy7XoYU/lbNJq1fPrLPl8RQtn8srTHLCH65FfqKGDwnJ4bnxT4LMFTVKxFJz4KgqnMAERmo6kJEDoizQik08CFwSlydpMBUVeci8gn4TlwLn9YKBiC3ML9vVPVMRA5UdSYimZX11GyHxCYtzULNLP2Jqp6KyIjYO5zb9RNiWOD0g3pUBfkPQxjzfZf0S4sAAAAASUVORK5CYII=" options:0];

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
