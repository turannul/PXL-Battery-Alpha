#import "../includes.h"
#import <notify.h>

@interface pxlSettings ()
@property (nonatomic, readonly) int token;
@end

@implementation pxlSettings
@synthesize preferences = _preferences;

-(instancetype)init{
	if(self = [super init]){
		[self registerDefaults];

		int token = 0;
		__block pxlSettings *blockSelf = self;
		notify_register_dispatch(kPrefDomain, &token, dispatch_get_main_queue(), ^(int token){
			blockSelf->_preferences = nil;
		});
		_token = token;
	}
	return self;
}

-(void)dealloc{
	[super dealloc];
	notify_cancel(self.token);
}

-(void)registerDefaults{
	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("pxlEnabled"), CFSTR(kPrefDomain))))
		CFPreferencesSetAppValue((CFStringRef)CFSTR("pxlEnabled"), (CFPropertyListRef)@1, CFSTR(kPrefDomain));

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("LowPowerModeColor"), CFSTR(kPrefDomain))))
		CFPreferencesSetAppValue((CFStringRef)CFSTR("LowPowerModeColor"), (CFPropertyListRef)CFSTR("#FFCC02"), CFSTR(kPrefDomain));

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("BatteryColor"), CFSTR(kPrefDomain))))
		CFPreferencesSetAppValue((CFStringRef)CFSTR("BatteryColor"), (CFPropertyListRef)CFSTR("#FFFFFF"), CFSTR(kPrefDomain));

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("LowBatteryColor"), CFSTR(kPrefDomain))))
		CFPreferencesSetAppValue((CFStringRef)CFSTR("LowBatteryColor"), (CFPropertyListRef)CFSTR("#EA3323"), CFSTR(kPrefDomain));

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("ChargingColor"), CFSTR(kPrefDomain))))
		CFPreferencesSetAppValue((CFStringRef)CFSTR("ChargingColor"), (CFPropertyListRef)CFSTR("#00FF0C"), CFSTR(kPrefDomain));
}

-(NSMutableDictionary *)preferences{
	if (!_preferences){
		CFStringRef appID = CFSTR(kPrefDomain);
		CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (!keyList) return nil;
		_preferences = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	}

	return _preferences;
}

-(NSString *)LowPowerModeColor{
	return (self.preferences[@"LowPowerModeColor"] ? self.preferences[@"LowPowerModeColor"] : @"#FFCC02");
}
-(NSString *)BatteryColor{
return (self.preferences[@"BatteryColor"] ? self.preferences[@"BatteryColor"] : @"#FFFFFF");
}
-(NSString *)LowBatteryColor{
	return (self.preferences[@"LowBatteryColor"] ? self.preferences[@"LowBatteryColor"] : @"#EA3323");
}
-(NSString *)ChargingColor{
	return (self.preferences[@"ChargingColor"] ? self.preferences[@"ChargingColor"] : @"#00FF0C");
}

-(BOOL)pxlEnabled{
	return (self.preferences[@"pxlEnabled"] ? [self.preferences[@"pxlEnabled"] boolValue] : YES);
}
@end