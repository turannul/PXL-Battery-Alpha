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
		CFPreferencesSetAppValue((CFStringRef)@"pxlEnabled", (CFPropertyListRef)@1, CFSTR(kPrefDomain));

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("LPM_Color"), CFSTR(kPrefDomain)))) 
		CFPreferencesSetAppValue((CFStringRef)@"LPM_Color", (CFPropertyListRef)@"#FFCC02", CFSTR(kPrefDomain));

		if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("B_Color"), CFSTR(kPrefDomain)))) 
		CFPreferencesSetAppValue((CFStringRef)@"B_Color", (CFPropertyListRef)@"#FFFFFF", CFSTR(kPrefDomain));

		if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("LB_Color"), CFSTR(kPrefDomain)))) 
		CFPreferencesSetAppValue((CFStringRef)@"LB_Color", (CFPropertyListRef)@"#EA3323", CFSTR(kPrefDomain));

		if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("C_Color"), CFSTR(kPrefDomain)))) 
		CFPreferencesSetAppValue((CFStringRef)@"C_Color", (CFPropertyListRef)@"#00FF0C", CFSTR(kPrefDomain));
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