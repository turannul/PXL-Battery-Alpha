//PXL_Settings.m
//@@ -1,58 +1,68 @@ Saved from git stash
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

-(NSString *)Normal_Color{
return (self.preferences[@"Normal_Color"] ? self.preferences[@"Normal_Color"] : @"#FFFFFF");
}
-(NSString *)Low_Battery_Color{
	return (self.preferences[@"Low_Battery_Color"] ? self.preferences[@"Low_Battery_Color"] : @"#EA3323");
}
-(NSString *)LPM_Color{
	return (self.preferences[@"LPM_Color"] ? self.preferences[@"LPM_Color"] : @"#FFCC02");
}
-(NSString *)Charging_Color{
	return (self.preferences[@"Charging_Color"] ? self.preferences[@"Charging_Color"] : @"#00FF0C");
}



-(BOOL)pxlEnabled{
	return (self.preferences[@"pxlEnabled"] ? [self.preferences[@"pxlEnabled"] boolValue] : YES);
}
@end
