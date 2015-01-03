//
//  LAAppDelegate.h
//  LunchAddict
//
//  Created by ramu chembeti on 29/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppConstants.h"
#import "AppDatabase.h"
#import "UserVO.h"
#import "SettingsVO.h"
#import "Reachability.h"
#import "RestOperation.h"
#import "AddFoodTruckVO.h"
#import "OAuthConsumer.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TokenCacheVO.h"
#import "Service.h"



@interface LAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *deviceid;

@property (strong, nonatomic) NSMutableArray *arrPastAddress;

@property (strong, nonatomic) UserVO *userVO;

@property (strong, nonatomic) SettingsVO *settingsVO;

@property (strong, nonatomic) NSNumber *numAddFoodTruckCount;

@property (strong, nonatomic) Reachability *internetReachable;

@property (assign, nonatomic) BOOL IS_ONLINE;

@property (strong, nonatomic) RestOperation *restOpertaion;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) GMSMarker *USER_MARKER;

@property (strong, nonatomic) NSMutableDictionary *FOOD_TRUCK_MARKERS;

@property (strong, nonatomic) NSMutableArray *FOOD_TRUCK_LIST;

@property (assign, nonatomic) CLLocationCoordinate2D PREV_FOOD_TRUCK_LOCATION;

@property (assign, nonatomic) int GPS_INVOKE_CAUSE;

@property (assign, nonatomic) long RES_SEARCH_DISTANCE;

@property(assign, nonatomic)  BOOL mapAnimated;

@property(assign, nonatomic)  CLLocationCoordinate2D userTappedLocation;

@property(strong, nonatomic)  CLLocation *userCheckinLocation;

@property (strong, nonatomic) NSMutableDictionary *TWITTER_CACHE;

@property (strong, nonatomic) AddFoodTruckVO *addFdVO;

@property (assign, nonatomic) int ALERT_ACTION_INDICATOR;

@property (assign, nonatomic) int GPS_STATUS_INDICATOR;

@property (assign, nonatomic) int REFRESH_INDICATOR;

@property(assign, nonatomic)  CLLocationCoordinate2D LAST_PINNED_LOCATION;

@property(assign, nonatomic)  int GEOCODER_ADDRESS_INDICATOR;

@property(assign, nonatomic)  BOOL POP_UP_FT_CONFIRM_YES;

@property(assign, nonatomic)  BOOL POP_UP_FT_CONFIRM_NO;

@property(strong, nonatomic)  NSTimer *POP_UP_FT_SHOW_TIMER;

@property(strong, nonatomic)  NSTimer *POP_UP_FT_HIDE_TIMER;

@property(assign, nonatomic)  BOOL FD_TRACK_ENABLED;

@property (strong, nonatomic) NSMutableArray *FOODTRUCKS_HISTORY_RECORD;

@property (strong, nonatomic) OAConsumer* consumer;

@property (strong, nonatomic) OAToken* accessToken;

@property (strong, nonatomic) FBSession *fbSession;

@property (assign, nonatomic) NSInteger TWITTER_TOKEN_VALIDATION_STATE;

@property (assign, nonatomic) NSInteger MERCHANT_CHECKIN_REQ_STATE;

@property (strong, nonatomic) Service *service;

@property (assign, nonatomic) int GPS_TRACKER_INDICATOR;

@property (strong, nonatomic) NSString *addressAddFoodTruck;

@property (strong, nonatomic) NSString *addressCheckinFoodTruck;

@property (strong, nonatomic) NSNumber *RECORDS_INDICATOR;

@property (strong, nonatomic) FoodTruckVO *OPEN_CLOSE_FD_VO;

@property (assign, nonatomic) BOOL RESET_PIN_LOCATION;

//@property (assign, nonatomic) BOOL IS_TESTING;

@property (assign, nonatomic) NSNumber *MAP_INTIAL_LOAD;


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
