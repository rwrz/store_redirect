#import "StoreRedirectPlugin.h"

@implementation StoreRedirectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"store_redirect"
                                     binaryMessenger:[registrar messenger]];
    StoreRedirectPlugin* instance = [[StoreRedirectPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"redirect" isEqualToString:call.method]) {
        NSString *appId = call.arguments[@"ios_id"];
        if (!appId.length) {
            result([FlutterError errorWithCode:@"ERROR"
                                       message:@"Invalid app id"
                                       details:nil]);
        } else {
            NSString* iTunesLink;

            // change url to beta if is_ios_beta
            if ([call.arguments[@"is_ios_beta"] boolValue]) {
                iTunesLink = [NSString stringWithFormat:@"itms-beta://beta.itunes.apple.com/v1/app/id%@", appId];
            } else {
                if([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
                    iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/xy/app/foo/id%@", appId];
                } else {
                    iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
                }
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
            
            result(nil);
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
