//
//  LAAppDelegate.m
//  LunchAddict
//
//  Created by ramu chembeti on 29/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LAAppDelegate.h"
#import "FoodTruckVO.h"
#import "LAViewController.h"
#import "RestAPIConsts.h"
#import "AppUtil.h"
#import "LADetailsView.h"

@implementation LAAppDelegate{
    NSMutableArray *listFoodTrucks;
}

@synthesize userid;
@synthesize deviceid;
@synthesize arrPastAddress;
@synthesize userVO;
@synthesize numAddFoodTruckCount;
@synthesize settingsVO;
@synthesize internetReachable;
@synthesize manager;
@synthesize restOpertaion;
@synthesize USER_MARKER;
@synthesize FOOD_TRUCK_MARKERS;
@synthesize FOOD_TRUCK_LIST;
@synthesize PREV_FOOD_TRUCK_LOCATION;
@synthesize GPS_INVOKE_CAUSE;
@synthesize RES_SEARCH_DISTANCE;
@synthesize mapAnimated;
@synthesize userTappedLocation;
@synthesize TWITTER_CACHE;
@synthesize addFdVO;
@synthesize ALERT_ACTION_INDICATOR;
@synthesize GPS_STATUS_INDICATOR;
@synthesize REFRESH_INDICATOR;
@synthesize LAST_PINNED_LOCATION;
@synthesize GEOCODER_ADDRESS_INDICATOR;
@synthesize POP_UP_FT_CONFIRM_NO;
@synthesize POP_UP_FT_CONFIRM_YES;
@synthesize POP_UP_FT_HIDE_TIMER;
@synthesize POP_UP_FT_SHOW_TIMER;
@synthesize FD_TRACK_ENABLED;
@synthesize FOODTRUCKS_HISTORY_RECORD;
@synthesize consumer;
@synthesize accessToken;
@synthesize fbSession;
@synthesize service;
@synthesize MERCHANT_CHECKIN_REQ_STATE;
@synthesize GPS_TRACKER_INDICATOR;
@synthesize addressAddFoodTruck;
@synthesize RECORDS_INDICATOR;
@synthesize OPEN_CLOSE_FD_VO;
@synthesize RESET_PIN_LOCATION;
//@synthesize IS_TESTING;
@synthesize MAP_INTIAL_LOAD;
@synthesize userCheckinLocation;
@synthesize addressCheckinFoodTruck;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x4F62A1)];    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0], NSFontAttributeName, nil]];
    
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    
    self.IS_ONLINE = [self connected];
    
    
    
    self.MAP_INTIAL_LOAD = NO;
    
    self.consumer = [[OAConsumer alloc] initWithKey:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUNER_SCRETE_KEY realm:nil];
    
    self.FOOD_TRUCK_LIST    = [[NSMutableArray alloc] init];
    
    self.restOpertaion  = [[RestOperation alloc] init];
    
    self.FOOD_TRUCK_MARKERS = [[NSMutableDictionary alloc] init];
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    self.mapAnimated = YES;
    
    self.FD_TRACK_ENABLED = NO;
    
    self.TWITTER_CACHE  = [[NSMutableDictionary alloc] init];
    
    self.FOODTRUCKS_HISTORY_RECORD = [[NSMutableArray alloc] init];
    
    self.ALERT_ACTION_INDICATOR = APP_DEFAULT;
    
    self.REFRESH_INDICATOR = APP_DEFAULT;
    
    self.MERCHANT_CHECKIN_REQ_STATE = APP_DEFAULT;
    
    //self.CHECK_IN_OUT_ACTION = APP_DEFAULT;
    
    self.POP_UP_FT_CONFIRM_NO   = NO;
    self.POP_UP_FT_CONFIRM_YES  = NO;
    
    self.FOODTRUCKS_HISTORY_RECORD = [AppDatabase loadRecentFoodTrucks];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    [GMSServices provideAPIKey:@"AIzaSyAxo65_8YPU5czEPL6wUSsZTUplKCjSAdQ"];
    
    [AppDatabase createAppDatabaseTables];
    
    [AppDatabase insertProviderSeedData];
    [AppDatabase insertUserMerchantSeedData];
    [AppDatabase insertUserPastAddressSeedData];
    [AppDatabase insertAddFoodTruckSeedData];
    [AppDatabase insertCheckInCheckOutSeedData];
    [AppDatabase insertHashTagSeedData];
    

    
    NSUUID *nsDeviceid = [[UIDevice currentDevice] identifierForVendor];
    self.deviceid   = [AppUtil md5HexDigest:[nsDeviceid UUIDString]];
    
    
    [AppDatabase loadusercredentials];
    
    
    return YES;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

-(void) checkNetworkStatus:(NSNotification *)notice{
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.IS_ONLINE = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.IS_ONLINE = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.IS_ONLINE = YES;
            
            break;
        }
    }
    
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if (self.service != nil) {
        [self.service stopService];
    }
    
    [manager.operationQueue setSuspended:YES];
    [restOpertaion.operationQueue setSuspended:YES];
    [self.TWITTER_CACHE removeAllObjects];
    
    if (self.POP_UP_FT_SHOW_TIMER != nil) {
        [self.POP_UP_FT_SHOW_TIMER invalidate];
        self.POP_UP_FT_SHOW_TIMER = nil;
    }
    
    if (self.POP_UP_FT_HIDE_TIMER != nil) {
        [self.POP_UP_FT_HIDE_TIMER invalidate];
        self.POP_UP_FT_HIDE_TIMER = nil;
    }
    
    if ([self.window.rootViewController isMemberOfClass:[LAViewController class]] ) {
        LAViewController *laViewController   = (LAViewController *)self.window.rootViewController;
        if (laViewController.detailsView != nil) {
            LADetailsView *laDetailsView    = (LADetailsView *)laViewController.detailsView;
            [laDetailsView.popupFtConfirmView setHidden:YES];
        }
        
        if (self.FD_TRACK_ENABLED) {
            [laViewController stopTrackFoodTruckLocation];
        }
    }
    
    
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [manager.operationQueue setSuspended:NO];
    [restOpertaion.operationQueue setSuspended:NO];
    [self.TWITTER_CACHE removeAllObjects];
    
    if ([self.window.rootViewController isMemberOfClass:[LAViewController class]] ) {
        LAViewController *laViewController   = (LAViewController *)self.window.rootViewController;        
        if (self.FD_TRACK_ENABLED) {
            [laViewController startTrackFoodTruckLocation];
        }
    }
    
    if (service != nil) {
        [self.service bindService];
    }
    
    
    [FBAppCall handleDidBecomeActive];
    
    
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    // Note this handler block should be the exact same as the handler passed to any open calls.
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         LAAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
     }];
    
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}




- (void)applicationWillTerminate:(UIApplication *)application
{
    [manager.operationQueue cancelAllOperations];
    [restOpertaion.operationQueue cancelAllOperations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [AppDatabase finalizeStatements];
    [self.TWITTER_CACHE removeAllObjects];
    
    self.MAP_INTIAL_LOAD = NO;
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");       
       
    }
    
    if(!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        NSString *token = session.accessTokenData.accessToken;
        //NSLog(@"Token is %@",token);
        NSLog(@"Facebook Permissions = %@",session.permissions);
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
                [AppUtil loadMapIntialView];
            }else{
                LAViewController *root = (LAViewController *)self.window.rootViewController;
                [root saveFacebookUserInfo];
            }
        }];
    }else{
        NSLog(@"Error is %@",[error description]);
        [AppUtil loadMapIntialView];
    }
}

@end
