//
//  BTAppDelegate.mm
//  Stetho
//
//  Created by Nick Winter on 10/20/12.
//  Copyright (c) 2012 BodyTrack. All rights reserved.
//

#import "BTAppDelegate.h"
#import "TestFlight.h"
#import "Constants.h"

@implementation BTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#pragma clang diagnostic pop
    [TestFlight takeOff:@"c989fabcf5fa3f8b701757e52e30bd73_MTQ1ODE0MjAxMi0xMC0yMSAxNjo1OTozMi40MzE5Nzc"];
    
    _pulseTracker = [[BTPulseTracker alloc] init];
    _phoneTracker = [[BTPhoneTracker alloc] init];
    _photoUploader = [BTPhotoUploader sharedPhotoUploader];
    
    [self registerDefaults];
    
    return YES;
}


- (void)registerDefaults
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    [defaultValues setObject:@"" forKey:DEFAULTS_USERNAME];
    [defaultValues setObject:@"" forKey:DEFAULTS_PASSWORD];
    [defaultValues setObject:@"flxtest.bodytrack.org" forKey:DEFAULTS_SERVER];
    
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:DEFAULTS_FIRSTRUN];
    
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:DEFAULTS_RECORD_LOCATION];
    [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_RECORD_MOTION];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:DEFAULTS_RECORD_APP_STATS];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:DEFAULTS_RECORD_HEARTRATE];
    [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_HEARTBEAT_SOUND];
    
    [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_PHOTO_ORIENTATION_PORTRAIT];
    [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_PHOTO_ORIENTATION_UPSIDE_DOWN];
    [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_PHOTO_ORIENTATION_LANDSCAPE_LEFT];
    [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_PHOTO_ORIENTATION_LANDSCAPE_RIGHT];
    
    [defaultValues setObject:[NSDate date] forKey:DEFAULTS_PHOTO_ORIENTATION_SETTINGS_CHANGED];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)selectSettingsTab
{
    UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;
    [tabBarController setSelectedIndex:2];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.logger logVerbose:@"Becoming inactive."];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.logger logVerbose:@"Entered background."];
    
    [self savePhotosArray];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.logger logVerbose:@"Entering foreground."];
    [[NSNotificationCenter defaultCenter] postNotificationName:BT_NOTIFICATION_APP_FOREGROUNDED object:self];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.logger logVerbose:@"Became active."];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self savePhotosArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)savePhotosArray
{
    BOOL success = [_photoUploader savePhotosArray];
    if (success) {
        NSLog(@"Saved photos array");
    } else {
        NSLog(@"!! Photos array was not saved");
    }
}

@end