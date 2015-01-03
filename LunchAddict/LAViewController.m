//
//  LAViewController.m
//  LunchAddict
//
//  Created by ramu chembeti on 29/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LAViewController.h"
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "LATruckListController.h"
#import "MZFormSheetSegue.h"
#import "LAPinMeViewController.h"
#import "FoodTruckVO.h"
#import "LAAppDelegate.h"
#import "AppConstants.h"
#import "AppMsg.h"
#import "AppUtil.h"
#import "FdListPostParam.h"
#import "AppJsonConst.h"
#import "ErrorVO.h"
#import "LAEmptyViewController.h"
#import "LAAddFdViewController.h"
#import "LAMoreInfoViewController.h"
#import "ResMsgVO.h"
#import "LAInternetConnErrController.h"
#import "LAAutoPinViewController.h"
#import "LADetailsView.h"
#import "HomeMyAccountController.h"
#import "HomeMyAccountNavController.h"
#import "DetailsMyAccountController.h"
#import "DetailsMyAccountNavController.h"
#import "TwitterPostNavController.h"
#import "TwitterPostViewController.h"
#import "SocialNetworkVO.h"
#import "TokenVO.h"
#import "TokenStatusController.h"
#import "MerchantViewController.h"
#import "UserVO.h"
#import "CheckinoutVO.h"
#import "AutoCheckinController.h"
#import "AutoCheckOutViewController.h"
#import "CheckOutConfirmController.h"
#import "CheckinFormController.h"
#import "NSDate+Utils.h"
#import "HomeMyAccCheckinController.h"
#import "HomeMyAccCheckInViewController.h"
#import "DetailsCheckInMyAccountViewController.h"
#import "DetailsMyAccCheckInNavController.h"
#import "ShareNavController.h"
#import "ShareViewController.h"



@interface LAViewController () <MZFormSheetBackgroundWindowDelegate>

@end

@implementation LAViewController

@synthesize mapView;
@synthesize superView;
@synthesize menuView;
@synthesize truckListBtn;
@synthesize pinMeBtn;
@synthesize refreshBtn;
@synthesize myAccBtn;
@synthesize arrFoodTrucks;
@synthesize gpsTracker;
@synthesize mapworker;
@synthesize geocoder;
@synthesize failureRestApiVO;
@synthesize detailsView;
@synthesize viewInternetConn;
@synthesize btnTryToConnectNow;
@synthesize noConnFailRestApiVO;
@synthesize checkinAction;
@synthesize hud;
@synthesize resAddFoodTruckVO;
@synthesize socialNWDataObj;
@synthesize numTwitterPostIndicator;
@synthesize strPartAddress;



- (void) setMapIntialView{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([CLLocationManager locationServicesEnabled]){
        self.gpsTracker.GPS_UPDATE  = GPS_SINGLE_UPDATE;
        appdelegte.GPS_INVOKE_CAUSE = USER_LOCATION;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = SEARCHING_MSG;
        hud.detailsLabelText = GPS_MSG;
        appdelegte.REFRESH_INDICATOR    = LAST_PINNED_LOCATION_IS_GPS;
        [self.gpsTracker.locMgr startUpdatingLocation];
        
    }else{
        appdelegte.GPS_STATUS_INDICATOR = GPS_IS_NOT_AVALIBLE;
        appdelegte.REFRESH_INDICATOR    = LAST_PINNED_LOCATION_IS_ADDRESS;
        [self openPinMeDialog];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:self.viewInternetConn
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0f
                                      constant:0.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                  constraintWithItem:self.viewInternetConn
                  attribute:NSLayoutAttributeCenterY
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.view
                  attribute:NSLayoutAttributeCenterY
                  multiplier:1.0f
                  constant:0.0f];
    
    [self.view addConstraint:constraint];
    
    
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appdelegte.MAP_INTIAL_LOAD = @NO;
    
    [self.viewInternetConn setHidden:YES];
    
    self.mapView.delegate   = self;
    
    self.gpsTracker = [[GPSTracker alloc] init];
    self.gpsTracker.delegate = self;
    
    self.mapworker  = [[MapWorker alloc] init];
    self.mapworker.mapView  = mapView;
    
    self.geocoder   = [[GeoCoder alloc] init];
    self.geocoder.delegate  = self;
    
    
    
//    if ([CLLocationManager locationServicesEnabled]){
//        self.gpsTracker.GPS_UPDATE  = GPS_SINGLE_UPDATE;
//        appdelegte.GPS_INVOKE_CAUSE = USER_LOCATION;
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.dimBackground = YES;
//        hud.labelText = SEARCHING_MSG;
//        hud.detailsLabelText = GPS_MSG;
//        appdelegte.REFRESH_INDICATOR    = LAST_PINNED_LOCATION_IS_GPS;
//        [self.gpsTracker.locMgr startUpdatingLocation];
//        
//    }else{
//        appdelegte.GPS_STATUS_INDICATOR = GPS_IS_NOT_AVALIBLE;
//        appdelegte.REFRESH_INDICATOR    = LAST_PINNED_LOCATION_IS_ADDRESS;
//        [self openPinMeDialog];
//        
//    }
    
    
    [self.viewInternetConn.layer setCornerRadius:10.0f];
    [self.viewInternetConn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.viewInternetConn.layer setBorderWidth:1.5f];
    
    btnTryToConnectNow.layer.cornerRadius = 4;
    btnTryToConnectNow.layer.borderWidth = 1;
    btnTryToConnectNow.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    
    //[menuView.layer setCornerRadius:10.0f];
    [menuView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [menuView.layer setBorderWidth:0.5f];
    
//    [truckListBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [truckListBtn.layer setBorderWidth:1.5f];
//    
//    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(1.0f, 0, truckListBtn.frame.size.width - 1.0f, truckListBtn.frame.size.height)];
//    mask.backgroundColor = [UIColor blackColor];
//    truckListBtn.layer.mask = mask.layer;
    
    
    
    CGFloat spacing = 5; // the amount of spacing to appear between image and title
    truckListBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    truckListBtn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    //CGFloat spacing = 10; // the amount of spacing to appear between image and title
    pinMeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    pinMeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    //CGFloat spacing = 10; // the amount of spacing to appear between image and title
    refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    refreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    //CGFloat spacing = 10; // the amount of spacing to appear between image and title
    myAccBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    myAccBtn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
   
    
    //[pinMeBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //[pinMeBtn.layer setBorderWidth:0.3f];
    
    
    
    //[refreshBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //[refreshBtn.layer setBorderWidth:0.3f];
    
    
    
//    [myAccBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [myAccBtn.layer setBorderWidth:1.5f];
    
    
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    
    [MZFormSheetController registerTransitionClass:[MZCustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];
    
    if (appdelegte.userVO != nil) {
        UserVO *userVO  = appdelegte.userVO;
        
        if (userVO.isMarchant) {
            
            if (userVO.facebookLogin) {
                if (userVO.isValidFbToken) {
                    
                }else{
                    [AppUtil clearFBSession];
                }
            }
            
            
            if (userVO.twitterLogin) {
                appdelegte.MAP_INTIAL_LOAD = @YES;
                if (userVO.isValidTwitterToken) {
                    CheckinoutVO *checkinoutVO  = [AppDatabase getCheckOutDetails];
                    
                    if (checkinoutVO == nil || [APP_YES isEqualToString:checkinoutVO.checkin]) {
                        [self openAutoCheckinDialog];
                    }else if([APP_NO isEqualToString:checkinoutVO.checkin]){
                        [self openAutoCheckoutdialogWithTagObj:checkinoutVO];
                    }                    
                }else{
                    [self openMerchantSessionExpired:userVO.twitterHanbler];
                    [AppUtil clearTwitterSession];
                }
            }else{
                [self setMapIntialView];
            }
            
            
        }else{
            
            [self setMapIntialView];
            
            if (userVO.facebookLogin) {
                if (userVO.isValidFbToken) {
                    
                }else{
                    [AppUtil clearFBSession];
                }
            }
            
            if (userVO.twitterLogin) {
                if (userVO.isValidTwitterToken) {
                    
                }else{
                    [AppUtil clearTwitterSession];

                }
            }
        }
        
        
//        if (userVO.facebookLogin) {
//            if (userVO.isValidFbToken) {
//                
//            }else{
//                [AppUtil clearFBSession];
//            }
//        }
        
//        if (userVO.twitterLogin) {
//            if (userVO.isValidTwitterToken) {
//                
//            }else{
//                if (userVO.isMarchant) {
//                    [self openMerchantSessionExpired:userVO.twitterHanbler];
//                    [AppUtil clearTwitterSession];
//                }
//            }
//        }
        
    }else{
        [self setMapIntialView];
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegte.service = [[Service alloc] initWithdelegate:self];
    [appdelegte.service bindService];
}

- (void)preOpenCheckinFormWithIndicator:(NSInteger)indicator{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.checkinAction = indicator;
    
    appdelegte.userCheckinLocation = nil;
    
    switch (indicator) {
        case ADD_CHECKIN_OUT_DEATLS:{
            if ([CLLocationManager locationServicesEnabled]){
                self.gpsTracker.GPS_UPDATE  = GPS_SINGLE_UPDATE;
                appdelegte.GPS_INVOKE_CAUSE = CHECKIN_USER_LOCATION;
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.dimBackground = YES;
                hud.labelText = SEARCHING_MSG;
                hud.detailsLabelText = GPS_MSG;
                [self.gpsTracker.locMgr startUpdatingLocation];
                
            }else{
                [self openCheckInFormDialog:@"" withActionIndicator:[[NSNumber alloc] initWithLong:self.checkinAction] WithStreetAddress:@""];
                
            }
        }
            break;
            
        case EDIT_CHECKIN_OUT_DETAILS:{
            
            //check in edit is not there....
            
            [self openCheckInFormDialog:@"" withActionIndicator:[[NSNumber alloc] initWithLong:self.checkinAction] WithStreetAddress:@""];
        }
            break;
            
        default:
            break;
    }
    
    
}

-(IBAction)btnTryToCoonectNowClicked:(id)sender{
    
    [self.viewInternetConn setHidden:YES];
    [self connectToInternet];
}

- (void) connectToInternet{
    if (self.noConnFailRestApiVO != nil) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        NSLog(@"Req= %@",self.noConnFailRestApiVO.reqUrl);
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:self.noConnFailRestApiVO.TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:self.noConnFailRestApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:self.noConnFailRestApiVO.TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
        }
    }
}

-(IBAction)truckListBtnClicked:(id)sender{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.viewInternetConn setHidden:YES];
    //BETA-43
    appdelegte.RECORDS_INDICATOR = [NSNumber numberWithInt:TRUCKS_RECORDS];
    if ([appdelegte.FOOD_TRUCK_LIST count] > 0) {
        [self openTruckListDialog:@"Truck List" withFoodTrucksList:appdelegte.FOOD_TRUCK_LIST];
    }else{
        [self openEmptyTruckListDialog:@"Truck List"];
    }
}
-(IBAction)pinMeBtnClicked:(id)sender{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.viewInternetConn setHidden:YES];
    appdelegte.GPS_STATUS_INDICATOR = APP_DEFAULT;
    //[self openPinMeDialog];
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"findNavSearch"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

-(void)openPinMeDialog{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"pinMeModal"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 280);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAPinMeViewController class]]) {
            LAPinMeViewController *mzvc = (LAPinMeViewController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        navController.topViewController.title = @"Pin Me";
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}


-(void)openTweetDialog{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tweetpost"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 290);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[TwitterPostViewController class]]) {
            TwitterPostViewController *mzvc = (TwitterPostViewController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        navController.topViewController.title = @"Tweet";
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

-(void)postTweetUpdate:(NSString *)strmsg withindicator:(NSNumber *)indicator{
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.numTwitterPostIndicator = indicator;
    
    if (appdelegte.accessToken != nil) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        NSURL* postUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
        OAMutableURLRequest* postRequest = [[OAMutableURLRequest alloc] initWithURL:postUrl
                                                                           consumer:appdelegte.consumer
                                                                              token:appdelegte.accessToken
                                                                              realm:nil
                                                                  signatureProvider:nil];
        OARequestParameter* oauthTokenParam1 = [[OARequestParameter alloc] initWithName:@"status" value:strmsg];
        OARequestParameter* oauthTokenParam2 = [[OARequestParameter alloc] initWithName:@"trim_user" value:@"true"];
        
        NSArray *params = [NSArray arrayWithObjects:oauthTokenParam1, oauthTokenParam2, nil];
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setParameters:params];
        
        
        OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
        [dataFetcher fetchDataWithRequest:postRequest
                                 delegate:self
                        didFinishSelector:@selector(didPostMsg:data:)
                          didFailSelector:@selector(didFailPostTweet:error:)];
    }
    
    
}


- (void)didPostMsg:(OAServiceTicket*)ticket data:(NSData*)data{
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(hud != nil){
        [hud hide:YES];
    }
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response msg %@", httpBody);
    NSError *error          = nil;
    NSDictionary *jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    
    if ([jsonData objectForKey:@"errors"] != nil) {
        [self.view makeToast:TWEET_POST_FAIL_MSG];
    }else{
        [self.view makeToast:TWEET_POST_SUCCESSFUL_MSG];
    }
    
    
        if (self.numTwitterPostIndicator == nil) {
            return;
        }
        
        if (appdelegte.userVO != nil && appdelegte.userVO.facebookLogin && self.socialNWDataObj != nil) {
            
            switch ([self.numTwitterPostIndicator integerValue]) {
                case TWITTER_SHARE_ADDFOODTRUCK:{
                    
                    //comment facebook posting code due to facebook permission denied
                    
//                    [self openSocialNetWorkShareDialogWithTitle:SHARE_FACEBOOK_TITLE
//                                                  withIndicator:[[NSNumber alloc] initWithInteger:FACEBOOK_SHARE_ADDFOODTRUCK]
//                                                        withObj:self.socialNWDataObj];
                    
                    if (self.mapView != nil) {
                        [self getFoodTruckData];
                    }
                    
                }
                    break;
                    
                case TWITTER_SHARE_CHECKIN:{
                    //comment facebook posting code due to facebook permission denied
//                    [self openSocialNetWorkShareDialogWithTitle:SHARE_FACEBOOK_TITLE
//                                                  withIndicator:[[NSNumber alloc] initWithInteger:FACEBOOK_SHARE_CHECKIN]
//                                                        withObj:self.socialNWDataObj];
                    
                    [AppUtil loadMapIntialView];
                }
                    break;
                    
                default:
                    break;
            }
            
        }else{
            switch ([self.numTwitterPostIndicator integerValue]) {
                case TWITTER_SHARE_ADDFOODTRUCK:{
                    if (self.mapView != nil) {
                        [self getFoodTruckData];
                    }
                }
                    break;
                    
                case TWITTER_SHARE_CHECKIN:{
                    //load map intial view.
                    [AppUtil loadMapIntialView];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
   
}

- (void)didFailPostTweet:(OAServiceTicket*)ticket error:(NSError*)error{
    if(hud != nil){
        [hud hide:YES];
    }
    NSLog(@"error msg %@", error.description);
    [self.view makeToast:TWEET_POST_FAIL_MSG];
    
    [AppUtil loadMapIntialView];
}


-(IBAction)refreshBtnClicked:(id)sender{

    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.viewInternetConn setHidden:YES];

    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addfdNavV2"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
//# As per V2 changes we commented the code
    
//    switch (appdelegte.REFRESH_INDICATOR) {
//            /*
//             if last pinned location is gps is visible ,
//                refresh (re-query) data based on the new center
//             
//             if last pinned location is gps is not visible ,
//                refresh (re-query) data based on the new center
//             */
//        case LAST_PINNED_LOCATION_IS_GPS:{
//            [self getFoodTruckData];
//        }
//            break;
//            
//            /*
//             if last pinned location is Address is visible ,
//             refresh (re-query) data based on the new center
//             
//             if last pinned location is address is not visible ,
//             pop up auto-pin
//             */
//            
//        case LAST_PINNED_LOCATION_IS_ADDRESS:{
//            GMSVisibleRegion visibleRegion = self.mapView.projection.visibleRegion;
//            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithRegion: visibleRegion];
//            if ([bounds containsCoordinate:appdelegte.USER_MARKER.position]) {
//                [self getFoodTruckData];
//            }else{
//                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.dimBackground = YES;
//                hud.labelText = PLEASEWAIT_MSG;
//                
//                LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
//                
//                CLLocation *location    = [[CLLocation alloc] initWithLatitude:appdelegte.USER_MARKER.position.latitude longitude:appdelegte.USER_MARKER.position.longitude];
//                appdelegte.GEOCODER_ADDRESS_INDICATOR   = ADDRESS_FOR_REFRESH_LOCATION;
//                [self.geocoder getAddressFromLocation:location];
//                
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
    
}
-(IBAction)myAccBtnClicked:(id)sender{
//    UIAlertView *alertView  =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"MyAccountBtn" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil];
//    [alertView show];
     LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.viewInternetConn setHidden:YES];
    
    if(appdelegte.userVO != nil && appdelegte.userVO.twitterLogin && appdelegte.userVO.isMarchant){
        [self openHomeMyAccountCheckInDialog];
    }else{
        [self openHomeMyAccountDialog];
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

//-(UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarToOrientation:(UIInterfaceOrientation)orientation
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didRotateToOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)locationUpdate:(CLLocation *)location{
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    switch (self.gpsTracker.GPS_UPDATE) {
        case GPS_SINGLE_UPDATE:{
            NSLog(@"single gps update");
            self.gpsTracker.GPS_UPDATE  = APP_DEFAULT;
            [self.gpsTracker.locMgr stopUpdatingLocation];
            
            switch (appdelegte.GPS_INVOKE_CAUSE) {
                case USER_LOCATION:{
                    if(hud != nil){
                        [hud hide:YES];
                    }
                    appdelegte.USER_MARKER = [GMSMarker markerWithPosition:location.coordinate];
                    appdelegte.USER_MARKER.icon = [UIImage imageNamed:@"useryev"];
                    appdelegte.USER_MARKER.map  = self.mapView;
                    appdelegte.mapAnimated  = YES;
                    self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:appdelegte.settingsVO.zoomLevel];
                    [self getFoodTruckDataBasedOnGPS:location];
                }
                    break;
                    
                case CHECKIN_USER_LOCATION:{
                    NSLog(@"Check in user location executed");
                    if (appdelegte.FD_TRACK_ENABLED) {
                        [self startTrackFoodTruckLocation];
                    }
                    appdelegte.GEOCODER_ADDRESS_INDICATOR = ADDRESS_FOR_CHECKIN_LOCATION;
                    appdelegte.userCheckinLocation = location;
                    [self.geocoder getAddressFromLocation:location];
                }
                    break;
                    
            }
            
        }
            break;
            
        case GPS_CONTINUOUS_UPDATE:{
            NSLog(@"continuous gps update");
            [self calculateDistance:location];
        }
            break;
            
        default:
            break;
    }
    
    
    
    NSLog(@"latitude %f", location.coordinate.latitude);
    NSLog(@"longitude %f", location.coordinate.longitude);
    
    appdelegte.GPS_INVOKE_CAUSE = APP_DEFAULT;
    
}

- (void)locationError:(NSError *)error{
    if(hud != nil){
        [hud hide:YES];
    }
    self.gpsTracker.GPS_UPDATE  = APP_DEFAULT;
    [self.gpsTracker.locMgr stopUpdatingLocation];
    NSLog(@"Gps Error Occur %@", error.description);
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    switch (appdelegte.GPS_INVOKE_CAUSE) {
        case USER_LOCATION:{
            CLLocationCoordinate2D defaultLocation  = CLLocationCoordinate2DMake(appdelegte.settingsVO.lat, appdelegte.settingsVO.lng);
            appdelegte.USER_MARKER = [GMSMarker markerWithPosition:defaultLocation];
            appdelegte.USER_MARKER.icon = [UIImage imageNamed:@"useryev"];
            appdelegte.USER_MARKER.map  = self.mapView;
            appdelegte.mapAnimated  = YES;
            self.mapView.camera = [GMSCameraPosition cameraWithTarget:defaultLocation zoom:appdelegte.settingsVO.zoomLevel];
            appdelegte.GPS_STATUS_INDICATOR = GPS_IS_NOT_AVALIBLE;
            appdelegte.REFRESH_INDICATOR    = LAST_PINNED_LOCATION_IS_ADDRESS;
            [self openPinMeDialog];
        }
            break;
            
        case CHECKIN_USER_LOCATION:{
            NSLog(@"Check in user location fail");
            appdelegte.userCheckinLocation = nil;
            [self openCheckInFormDialog:@"" withActionIndicator:[[NSNumber alloc] initWithLong:self.checkinAction] WithStreetAddress:@""];
        }
            break;
            
            
            
        default:
            break;
    }
    
    appdelegte.GPS_INVOKE_CAUSE = APP_DEFAULT;
    
}

- (void)startTrackFoodTruckLocation{
    if ([CLLocationManager locationServicesEnabled]){
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.gpsTracker.GPS_UPDATE  = GPS_CONTINUOUS_UPDATE;
        appdelegte.GPS_INVOKE_CAUSE = FD_TRACK_LOCATION;
        appdelegte.FD_TRACK_ENABLED = YES;
        [self.gpsTracker.locMgr startUpdatingLocation];
        
    }
}

- (void)stopTrackFoodTruckLocation{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegte.GPS_INVOKE_CAUSE = APP_DEFAULT;
    self.gpsTracker.GPS_UPDATE  = APP_DEFAULT;
    [self.gpsTracker.locMgr stopUpdatingLocation];
}

-(void)calculateDistance:(CLLocation *)userCurrentlocation{
    
    
    if (userCurrentlocation != nil) {
        LADetailsView *dView  = (LADetailsView *)self.detailsView;
        FoodTruckVO *fdVO    = dView.foodTruckVO;
        if (fdVO != nil) {
            
            CLLocation *foodtrucklocation = [[CLLocation alloc] initWithLatitude:[fdVO.lat doubleValue] longitude:[fdVO.lng doubleValue]];
            CLLocationDistance distance = [foodtrucklocation distanceFromLocation:userCurrentlocation];
            
            NSLog(@"tracking lat == %f", foodtrucklocation.coordinate.latitude);
            NSLog(@"tracking lon == %f", foodtrucklocation.coordinate.longitude);
            
            NSLog(@"tracking distance == %f", distance);
            
            if (distance <= FD_CNFM_DIALOG_DISTANCE_IN_METERS) {
                LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
                appdelegte.FD_TRACK_ENABLED = NO;
                [self stopTrackFoodTruckLocation];
                
                if (appdelegte.POP_UP_FT_SHOW_TIMER != nil) {
                    [appdelegte.POP_UP_FT_SHOW_TIMER invalidate];
                    appdelegte.POP_UP_FT_SHOW_TIMER = nil;
                }
                
                if (appdelegte.POP_UP_FT_HIDE_TIMER != nil) {
                    [appdelegte.POP_UP_FT_HIDE_TIMER invalidate];
                    appdelegte.POP_UP_FT_HIDE_TIMER = nil;
                }
                
                [dView showPopUp:nil];
            }
            
        }
    }
    
    
}



- (void)successcallback:(RestAPIVO *)restApiVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(hud != nil){
        [hud hide:YES];
    }
    
    if(restApiVO != nil && restApiVO.response != nil){
         [appdelegte.restOpertaion.operationInProgress removeObjectForKey:restApiVO.TAG];
        
         if ([restApiVO.response class] == [ErrorVO class]){
            appdelegte.ALERT_ACTION_INDICATOR = ERROR_DIALOG;
            ErrorVO *errorVo = (ErrorVO *)restApiVO.response;
            [AppUtil openErrorDialog:errorVo.status withmsg:errorVo.msg withdelegate:self];
         }else{
             switch (restApiVO.REQ_IDENTIFIER) {
                 case FOODTRUCK_LIST_REQ:{
                     appdelegte.FOOD_TRUCK_LIST  = [[NSMutableArray alloc] initWithArray:(NSArray *)restApiVO.response];
                     [self.mapworker setDataOnMapView];
                                          
                 }
                     break;
                     
                 case FD_DETAILS_BY_TWITTER_REQ:{
                     if ([restApiVO.response class] == [FoodTruckVO class]) {
                         FoodTruckVO *fdVO  = (FoodTruckVO *)restApiVO.response;
                         [self openMoreInfoDialogWithFoodTruckDetails:fdVO];
                     }
                 }
                     break;
                     
                 case ADDFOODTRUCK_REQ:{
                     if ([restApiVO.response class] == [ResMsgVO class]) {
                         ResMsgVO *resMsgVO = (ResMsgVO *)restApiVO.response;
                         //BETA-28
                         if (![AppDatabase hasAddFoodTruckLimitExceed]) {
                             resMsgVO.msg = BELOW_LIMIT_ADD_FD_TRUCK_MSG;
                         }else{
                             resMsgVO.msg = ABOVE_LIMIT_ADD_FD_TRUCK_MSG;
                         }
                         
                         self.resAddFoodTruckVO = (AddFoodTruckVO *)restApiVO.reqTagObj;
                         
                         [AppUtil openMsgDialog:resMsgVO.status withmsg:resMsgVO.msg withdelegate:self];
                         [AppDatabase saveAddFoodTruckCount];
                     }
                 }
                     break;
                     
                 case CACHE_TWEETS_REQ:{
                     if (restApiVO.response != nil) {
                         NSMutableDictionary *dic   = (NSMutableDictionary *)restApiVO.response;
                         NSMutableArray *listTweets = [dic objectForKey:JSON_TWITTER];
                         NSMutableArray  *listFbPosts   = [dic objectForKey:JSON_FACEBOOK];
                         NSString *strTwitterMsg = nil;
                         NSString *strFacebookMsg = nil;
                         LADetailsView *dView = (LADetailsView *)self.detailsView;
                         [dView.arrFBPosts removeAllObjects];
                         [dView.arrTweets removeAllObjects];
                         
                         [dView.tableViewFacebook reloadData];
                         [dView.tableViewTwitter reloadData];
                         
                         if (listTweets != nil && [listTweets count] > 0) {
                             dView.arrTweets = listTweets;
                         }else{
                             dView.arrTweets = [[NSMutableArray alloc] init];
                             strTwitterMsg = @"Twitter";
                         }
                         
                         if (listFbPosts != nil && [listFbPosts count] > 0) {
                             dView.arrFBPosts = listFbPosts;
                         }else{
                             dView.arrFBPosts = [[NSMutableArray alloc] init];
                             strFacebookMsg = @"Facebook";
                         }
                         
                         [dView.tableViewFacebook reloadData];
                         [dView.tableViewTwitter reloadData];
                         
                         if (strFacebookMsg != nil && strTwitterMsg != nil) {
                             [self.view makeToast:[NSString stringWithFormat:@"Sorry, %@ && %@ data is not available in the system",strFacebookMsg,strTwitterMsg]];
                         }else if(strTwitterMsg != nil){
                             [self.view makeToast:[NSString stringWithFormat:@"Sorry, %@ data is not available in the system",strTwitterMsg]];
                         }else if (strFacebookMsg != nil){
                             [self.view makeToast:[NSString stringWithFormat:@"Sorry, %@ data is not available in the system",strFacebookMsg]];
                         }
                         
                     }
                     
                 }
                     break;
                     
                 case LIVE_TWEETS_REQ:{
                     if (restApiVO.response != nil) {
                         NSMutableDictionary *dic   = (NSMutableDictionary *)restApiVO.response;
                         NSMutableArray *listTweets = [dic objectForKey:JSON_TWITTER];
                         NSMutableArray  *listFbPosts   = [dic objectForKey:JSON_FACEBOOK];
                         NSString *strTwitterMsg = nil;
                         NSString *strFacebookMsg = nil;
                         LADetailsView *dView = (LADetailsView *)self.detailsView;
                         
                         if (listTweets != nil) {
                             [dView.arrTweets removeAllObjects];
                             dView.arrTweets = listTweets;
                             [dView.tableViewTwitter reloadData];
                             if ([dView.arrTweets count] <= 0) {
                                 strTwitterMsg = @"twitter";
                             }
                         }
                         
                         if (listFbPosts != nil) {
                             [dView.arrFBPosts removeAllObjects];
                             dView.arrFBPosts = listFbPosts;
                             [dView.tableViewFacebook reloadData];
                             if ([dView.arrFBPosts count] <= 0) {
                                 strFacebookMsg = @"facebook";
                             }
                         }
                         
                         
                         if(strTwitterMsg != nil){
                             [self.view makeToast:[NSString stringWithFormat:@"Sorry, %@ live data is not available in the system",strTwitterMsg]];
                         }else if (strFacebookMsg != nil){
                             [self.view makeToast:[NSString stringWithFormat:@"Sorry, %@ live data is not available in the system",strFacebookMsg]];
                         }
                         
                     }
                 }
                     break;
                     
                 case UPDATE_FOODTRUCK_REQ:{
                     if ([restApiVO.response class] == [ResMsgVO class]) {
                         [self homeBackAction];
                         ResMsgVO *resMsgVO = (ResMsgVO *)restApiVO.response;
                         [AppUtil openMsgDialog:resMsgVO.status withmsg:resMsgVO.msg withdelegate:self];
                         
                     }
                 }
                     break;
                     
                 case FT_CONFIRM_REQ:{
                     if ([restApiVO.response class] == [ResMsgVO class]) {
                         NSDictionary *reqDic = restApiVO.reqDicParamObj;
                         
                         NSString *strPositiveConfirm   = [reqDic objectForKey:POSITIVE_CONFIRM];
                         NSString *strNegativeConfirm   = [reqDic objectForKey:NEGATIVE_CONFIRM];
                         
                         FoodTruckVO *fdVO = ((LADetailsView *)self.detailsView).foodTruckVO;
                         
                         if(strPositiveConfirm != nil){
                             appdelegte.POP_UP_FT_CONFIRM_NO    = NO;
                             appdelegte.POP_UP_FT_CONFIRM_YES   = YES;
                             [AppDatabase saveFDConfirmDetails:fdVO withConfirmation:APP_YES];
                         }else if (strNegativeConfirm != nil){
                             appdelegte.POP_UP_FT_CONFIRM_NO    = YES;
                             appdelegte.POP_UP_FT_CONFIRM_YES   = NO;
                             [AppDatabase saveFDConfirmDetails:fdVO withConfirmation:APP_NO];
                         }                         
                         
                         ResMsgVO *resMsgVO = (ResMsgVO *)restApiVO.response;
                         [AppUtil openMsgDialog:resMsgVO.status withmsg:resMsgVO.msg withdelegate:self];
                         
                     }
                 }
                     break;
                 
                 case IS_MERCHANT_REQ:{
                     if ([restApiVO.response class] == [FoodTruckVO class]) {
                         FoodTruckVO *fdVO  = (FoodTruckVO *)restApiVO.response;                         
                         
                         if ([APP_YES isEqualToString:fdVO.isMerchant]) {
                             appdelegte.userVO.isMarchant = YES;
                         }else{
                             appdelegte.userVO.isMarchant = NO;
                         }
                         
                         [AppDatabase updateMerchantData:fdVO];
                         
                         if(!appdelegte.service.IS_SERVICE_RUNNING){
                             [appdelegte.service bindService];
                         }
                         
                         if (appdelegte.userVO.isMarchant) {
                             switch (appdelegte.MERCHANT_CHECKIN_REQ_STATE) {
                                 case YES_LOGIN_STATE:{
                                     [AppUtil loadMapIntialView];
                                 }
                                 break;
                                 
                                 case YES_LOGIN_CHECKIN_STATE:{
                                     //[self openAutoCheckinDialog];
                                     [self getOpenCloseDateTimes];
                                 }
                                 break;
                                 
                                 default:{
                                     [self openAutoCheckinDialog];
                                 }
                                 break;
                             }
                         }else{
                             [AppUtil loadMapIntialView];
                         }
                         
                         
                         
                         appdelegte.MERCHANT_CHECKIN_REQ_STATE = APP_DEFAULT;
                     }
                 }
                 break;
                 
                 case ADD_USER_TOKEN_REQ:{
                     if ([restApiVO.response class] == [ResMsgVO class]) {
                         ResMsgVO *resMsgVO = (ResMsgVO *)restApiVO.response;
                         [self.view makeToast:resMsgVO.msg];
                         
                         SocialNetworkVO *socialVO  = (SocialNetworkVO *)restApiVO.reqTagObj;
                         
                         TokenCacheVO *tokenCacheVO = [[TokenCacheVO alloc] init];
                         
                         tokenCacheVO.accesstoken = socialVO.accessToken;
                         tokenCacheVO.providername = socialVO.providerName;
                         tokenCacheVO.username = socialVO.username;
                         tokenCacheVO.isvalid = APP_NO;
                         tokenCacheVO.numofattempts = @"0";
                         tokenCacheVO.maxlimit = [NSString stringWithFormat:@"%d",appdelegte.settingsVO.loginvalidationcount];
                         
                         [AppDatabase insertTokenIntoTokenCache:tokenCacheVO];
                         
                         if ([TWITTER isEqualToString:tokenCacheVO.providername]) {
                             [self isMerchantValidation:socialVO];
                         }else{
                             if(!appdelegte.service.IS_SERVICE_RUNNING){
                                 [appdelegte.service bindService];
                             }
                         }
                     }
                 }
                 break;
                 
                 case LOGOUT_TOKEN_REQ:{
                     if ([restApiVO.response class] == [ResMsgVO class]) {
                         ResMsgVO *resMsgVO = (ResMsgVO *)restApiVO.response;
                         [self.view makeToast:resMsgVO.msg];
                     }
                 }
                 break;
                 
                 case CHECK_IN_REQ:{
                     if ([restApiVO.response class] == [FoodTruckVO class]) {
                         FoodTruckVO *fdVO  = (FoodTruckVO *)restApiVO.response;
                         CheckinoutVO *checkVO  = (CheckinoutVO*)restApiVO.reqTagObj;
                         checkVO.suggfrom = @"";
                         checkVO.sugguntil= @"";
                         checkVO.locationid = fdVO.locationid;
                         [AppDatabase saveCheckinDetails:checkVO];
                         [self.view makeToast:CHEKIN_SUCCESS_MSG];
                         
                         [self openSocialNetWorkShareDialogWithTitle:SHARE_TWITER_TITLE withIndicator:[[NSNumber alloc] initWithInteger:TWITTER_SHARE_CHECKIN] withObj:restApiVO.reqTagObj];
                     }
                 }
                 break;
                 
                 case CHECK_OUT_REQ:{
                     if ([restApiVO.response class] == [ResMsgVO class]) {
                         ResMsgVO *resMsgVO = (ResMsgVO *)restApiVO.response;
                         
                         if ([restApiVO.reqTagObj isMemberOfClass:[CheckinoutVO class]]) {
                            
                             CheckinoutVO *ccheckinvo = (CheckinoutVO *)restApiVO.reqTagObj;
                             [AppDatabase deleteCheckinDetails:ccheckinvo.checkid];
                             [self.view makeToast:resMsgVO.msg];
                             
                             
                         }
                         
                         [AppUtil loadMapIntialView];
                         
                     }
                 }
                 break;
                     
                 case OPEN_CLOSE_TIME_REQ:{
                     if ([restApiVO.response class] == [FoodTruckVO class]) {
                        FoodTruckVO *fdVO  = (FoodTruckVO *)restApiVO.response;
                         appdelegte.OPEN_CLOSE_FD_VO = fdVO;
                         [self preOpenCheckinFormWithIndicator:ADD_CHECKIN_OUT_DEATLS];
                         
                     }
                 }
                     break;
                
                     
             }
         }
    }
    
}

- (void)failurecallback:(RestAPIVO *)restApiVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(hud != nil){
        [hud hide:YES];
    }
    
    if(restApiVO != nil){
        [appdelegte.restOpertaion.operationInProgress removeObjectForKey:restApiVO.TAG];
        
        switch (restApiVO.REQ_IDENTIFIER) {
            case FD_DETAILS_BY_TWITTER_REQ:{
                [self openMoreInfoDialogWithFoodTruckDetails:nil];
            }
                break;
                
            default:{
                if (restApiVO.error != nil) {
                    self.failureRestApiVO = restApiVO;
                    [self openLunchAddictServerDialog];
                }
                
            }
                break;
        }
    }
    
    
}

- (void)internetConnectionError:(RestAPIVO *)restApiVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(hud != nil){
        [hud hide:YES];
    }
    
    //[self.view makeToast:@"internet connection is not avaliable"];
    
    
    
    if(restApiVO != nil){
        [appdelegte.restOpertaion.operationInProgress removeObjectForKey:restApiVO.TAG];
        
        if (self.detailsView != nil && ![self.detailsView isHidden]) {
            LADetailsView *dview        = (LADetailsView *)detailsView;
            [dview.viewInternetConn setHidden:NO];
        }else{
            [self.viewInternetConn setHidden:NO];
        }
        
        self.noConnFailRestApiVO = restApiVO;
        
//        switch (restApiVO.REQ_IDENTIFIER) {
//            case FD_DETAILS_BY_TWITTER_REQ:{
//                [self openMoreInfoDialogWithFoodTruckDetails:nil];
//            }
//                break;
//        }
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.dimBackground = YES;
//    hud.labelText = PLEASEWAIT_MSG;
//    
//    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
//    appdelegte.userTappedLocation = coordinate;
//    CLLocation *location    = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    appdelegte.GEOCODER_ADDRESS_INDICATOR   = ADDRESS_FOR_ADDFOODTRUCK;
//    [self.geocoder getAddressFromLocation:location];
    [self addFoodTruckBasedOnLocation:coordinate];
    
}

- (void)addFoodTruckBasedOnLocation:(CLLocationCoordinate2D)coordinate{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = PLEASEWAIT_MSG;
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegte.userTappedLocation = coordinate;
    CLLocation *location    = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    appdelegte.GEOCODER_ADDRESS_INDICATOR   = ADDRESS_FOR_ADDFOODTRUCK;
    [self.geocoder getAddressFromLocation:location];
    
}

- (void)showRecentFoodTruck{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    //BETA-43
    appdelegte.RECORDS_INDICATOR = [NSNumber numberWithInt:HISTORY_RECORDS];
    
    if ([appdelegte.FOODTRUCKS_HISTORY_RECORD count] > 0) {
        [self openTruckListDialog:@"Recent Food Trucks List" withFoodTrucksList:appdelegte.FOODTRUCKS_HISTORY_RECORD];
    }else{
        [self openEmptyTruckListDialog:@"Recent Food Trucks List"];
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    FoodTruckVO *fdVO   = [appdelegte.FOOD_TRUCK_MARKERS objectForKey:[marker title]];
    
    if (fdVO != nil) {
        //BETA-43
        appdelegte.RECORDS_INDICATOR = [NSNumber numberWithInt:TRUCKS_RECORDS];
        [self showDetailsView:fdVO];
        [AppUtil addFoodTruckToHistoryRecord:fdVO];
    }else if(appdelegte.USER_MARKER != nil){
        
        [self addFoodTruckBasedOnLocation:appdelegte.USER_MARKER.position];
    }
    
    
    
    return YES;
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appdelegte.mapAnimated){
        appdelegte.mapAnimated = NO;
        return;
    }
    
    if (appdelegte.RESET_PIN_LOCATION) {
        appdelegte.RESET_PIN_LOCATION = NO;
        CLLocation *location    = [[CLLocation alloc] initWithLatitude:appdelegte.USER_MARKER.position.latitude longitude:appdelegte.USER_MARKER.position.longitude];
        
        [self getFoodTruckDataBasedOnGPS:location];
        return;
    }
    
//    if (appdelegte.PREV_FOOD_TRUCK_LOCATION.latitude ==0 && appdelegte.PREV_FOOD_TRUCK_LOCATION.longitude == 0) {
//        [self getFoodTruckData];
//    }else{
//        
//        double d1   = [AppUtil getDistanceInMetersBetWeenLocation1:appdelegte.PREV_FOOD_TRUCK_LOCATION withLocation2:self.mapView.projection.visibleRegion.nearLeft];
//        
//        double d2   = [AppUtil getDistanceInMetersBetWeenLocation1:appdelegte.PREV_FOOD_TRUCK_LOCATION withLocation2:self.mapView.projection.visibleRegion.nearRight];
//        
//        double d3   = [AppUtil getDistanceInMetersBetWeenLocation1:appdelegte.PREV_FOOD_TRUCK_LOCATION withLocation2:self.mapView.projection.visibleRegion.farRight];
//        
//        double d4   = [AppUtil getDistanceInMetersBetWeenLocation1:appdelegte.PREV_FOOD_TRUCK_LOCATION withLocation2:self.mapView.projection.visibleRegion.farLeft];
//        
//        if ([appdelegte.FOOD_TRUCK_LIST count] < appdelegte.settingsVO.ftlistmaxlimit) {
//            if(d1 > appdelegte.RES_SEARCH_DISTANCE || d2 > appdelegte.RES_SEARCH_DISTANCE ||
//               d3 > appdelegte.RES_SEARCH_DISTANCE || d4 > appdelegte.RES_SEARCH_DISTANCE){
//                NSLog(@"MAP BOUNDARY CROSSED 1");
//                [self getFoodTruckData];
//               
//            }
//            
//        }else if([appdelegte.FOOD_TRUCK_LIST count] > 0){
//            NSUInteger size = [appdelegte.FOOD_TRUCK_LIST count];
//            double fdsMiles	= [((FoodTruckVO *)[appdelegte.FOOD_TRUCK_LIST objectAtIndex:size-1]).distance doubleValue]*ONE_MILE_IN_METERS;
//            
//            if(d1 > fdsMiles || d2 > fdsMiles ||
//               d3 >fdsMiles || d4 > fdsMiles){
//                NSLog(@"MAP BOUNDARY CROSSED 2");
//                [self getFoodTruckData];
//                
//            }
//            
//        }
//        
//        
//    }
    
    
}

- (void)getFoodTruckData{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    FdListPostParam *fdListPostParam = [[FdListPostParam alloc] init];
    fdListPostParam.lat = [NSString stringWithFormat:@"%f",self.mapView.camera.target.latitude];
    fdListPostParam.lng = [NSString stringWithFormat:@"%f",self.mapView.camera.target.longitude];
    fdListPostParam.basedOn = GPS;
    fdListPostParam.deviceId = appdelegte.deviceid;
    fdListPostParam.zoomLevel = [NSString stringWithFormat:@"%f",self.mapView.camera.zoom];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = SEARCHING_MSG;
    hud.detailsLabelText = FOR_FD_TRUCKS_MSG;
    
    [AppUtil getFoodTrucks:fdListPostParam withDelegate:self];
}

- (void)openTruckListDialog:(NSString *)strTitle withFoodTrucksList:(NSMutableArray *)fdlist{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"truckListNavModal"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 298);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LATruckListController class]]) {
            LATruckListController *latrucklistvc = (LATruckListController *)navController.topViewController;
            latrucklistvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        LATruckListController *latrucklistvc = (LATruckListController *)navController.topViewController;
        
        latrucklistvc.title             = strTitle;
        latrucklistvc.arrFoodtrucks     = fdlist;
        
        [[latrucklistvc tableView] reloadData];
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)openEmptyTruckListDialog:(NSString *)strTitle{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"truckListEmpty"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 298);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAEmptyViewController class]]) {
            LAEmptyViewController *latemptyvc = (LAEmptyViewController *)navController.topViewController;
            latemptyvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        LAEmptyViewController *latEmptyvc = (LAEmptyViewController *)navController.topViewController;
        latEmptyvc.title             = strTitle;
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}


- (void)openHomeMyAccountCheckInDialog{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeMyAccCheckIn"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight)
    {
        
        formSheet.presentedFormSheetSize = CGSizeMake(300,298);
    }
    else
    {
        formSheet.presentedFormSheetSize = CGSizeMake(300, 350);
    }
    
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAEmptyViewController class]]) {
            HomeMyAccCheckInViewController *homemyaccvc = (HomeMyAccCheckInViewController *)navController.topViewController;
            homemyaccvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        HomeMyAccCheckInViewController *homemyaccvc = (HomeMyAccCheckInViewController *)navController.topViewController;
        homemyaccvc.title             = @"My Account";
        
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)openHomeMyAccountDialog{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homemyaccount"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    //formSheet.presentedFormSheetSize = CGSizeMake(300, 298);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAEmptyViewController class]]) {
            HomeMyAccountController *homemyaccvc = (HomeMyAccountController *)navController.topViewController;
            homemyaccvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        HomeMyAccountController *homemyaccvc = (HomeMyAccountController *)navController.topViewController;
        homemyaccvc.title             = @"My Account";
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}



- (void)openDetailsMyAccountCheckInDialog{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsMyAccCheckIn"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight)
    {
       
        formSheet.presentedFormSheetSize = CGSizeMake(300,298);
    }
    else
    {
        formSheet.presentedFormSheetSize = CGSizeMake(300, 420);
    }
    
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAEmptyViewController class]]) {
            DetailsCheckInMyAccountViewController *detailsmyaccvc = (DetailsCheckInMyAccountViewController *)navController.topViewController;
            detailsmyaccvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        DetailsCheckInMyAccountViewController *detailsmyaccvc = (DetailsCheckInMyAccountViewController *)navController.topViewController;
        detailsmyaccvc.title             = @"My Account";
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)openDetailsMyAccountDialog{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsMyAccount"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight)
    {
        
        formSheet.presentedFormSheetSize = CGSizeMake(300,298);
    }
    else
    {
        formSheet.presentedFormSheetSize = CGSizeMake(300, 400);
    }
    
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAEmptyViewController class]]) {
            DetailsMyAccountController *detailsmyaccvc = (DetailsMyAccountController *)navController.topViewController;
            detailsmyaccvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        DetailsMyAccountController *detailsmyaccvc = (DetailsMyAccountController *)navController.topViewController;
        detailsmyaccvc.title             = @"My Account";
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)getFoodTruckDataBasedOnAddress:(CLLocation*)location {
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    FdListPostParam *fdListPostParam = [[FdListPostParam alloc] init];
    fdListPostParam.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    fdListPostParam.lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    fdListPostParam.basedOn = ADDRESS;
    fdListPostParam.deviceId = appdelegte.deviceid;
    fdListPostParam.zoomLevel = [NSString stringWithFormat:@"%f",self.mapView.camera.zoom];
    
    appdelegte.REFRESH_INDICATOR = LAST_PINNED_LOCATION_IS_ADDRESS;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = SEARCHING_MSG;
    hud.detailsLabelText = FOR_FD_TRUCKS_MSG;
    
    [AppUtil getFoodTrucks:fdListPostParam withDelegate:self];
}

- (void)getFoodTruckDataBasedOnGPS:(CLLocation*)location{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    FdListPostParam *fdListPostParam = [[FdListPostParam alloc] init];
    fdListPostParam.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    fdListPostParam.lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    fdListPostParam.basedOn = GPS;
    fdListPostParam.deviceId = appdelegte.deviceid;
    fdListPostParam.zoomLevel = [NSString stringWithFormat:@"%f",self.mapView.camera.zoom];
    
    appdelegte.REFRESH_INDICATOR = LAST_PINNED_LOCATION_IS_GPS;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = SEARCHING_MSG;
    hud.detailsLabelText = FOR_FD_TRUCKS_MSG;
    
    [AppUtil getFoodTrucks:fdListPostParam withDelegate:self];
}

- (void)goToAddFoodTruckMoreDetails{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.addFdVO =    appdelegte.addFdVO;
    if (self.addFdVO != nil) {
        //BETA-28
        //if (![AppDatabase hasAddFoodTruckLimitExceed]) {
            FoodTruckVO *foodTruckVO    = [appdelegte.TWITTER_CACHE objectForKey:[self.addFdVO.twitterHandler lowercaseString]];
            [appdelegte.TWITTER_CACHE removeAllObjects];
            if (foodTruckVO != nil) {
                [self openMoreInfoDialogWithFoodTruckDetails:foodTruckVO];
            }else{
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.dimBackground = YES;
                hud.labelText = PLEASEWAIT_MSG;
                [AppUtil getFoodTruckDetailsByTwitterHandler:self.addFdVO.twitterHandler withDelegate:self];
            }
        //BETA-28
       // }else{
           // [AppUtil openErrorDialog:SORRY_MSG withmsg:ADD_FD_MAX_LIMIT_EXCEED_MSG];
      //  }
    }
}


- (void)getOpenCloseDateTimes{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
    restApiVO.REQ_IDENTIFIER    = OPEN_CLOSE_TIME_REQ;
    restApiVO.TAG = OPEN_CLOSE_TIME_TAG;
    restApiVO.reqtype = POST_REQ;
    restApiVO.reqUrl  = OPEN_CLOSE_TIME_URL;
    restApiVO.reqDicParamObj = [AppJsonGenerator getOpenCloseTimeJSONPostParam:appdelegte.userVO.isMarchant];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = PLEASEWAIT_MSG;
    
    if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:OPEN_CLOSE_TIME_TAG]){
        RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
        [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:OPEN_CLOSE_TIME_TAG];
        [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
    }
    
}


- (void)addFoodTruckDetailsToServer{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.addFdVO =    appdelegte.addFdVO;
    if (self.addFdVO != nil) {
        
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = ADDFOODTRUCK_REQ;
        restApiVO.TAG = REQ_ADD_FOODTRUCK_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = ADD_FOODTRUCK_URL;
        restApiVO.reqDicParamObj = [AppJsonGenerator getAddFoodtruckPostParam:self.addFdVO];
        restApiVO.reqTagObj = self.addFdVO;
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_ADD_FOODTRUCK_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_ADD_FOODTRUCK_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            appdelegte.ALERT_ACTION_INDICATOR = ADD_FOODTRUCK;
        }
    }
    
    appdelegte.addFdVO = nil;
}

- (void)openMoreInfoDialogWithFoodTruckDetails:(FoodTruckVO *)fdVO{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"moreinfo"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 250);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAMoreInfoViewController class]]) {
            LAMoreInfoViewController *lamoreinfovc = (LAMoreInfoViewController *)navController.topViewController;
            lamoreinfovc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        LAMoreInfoViewController *lamoreinfovc = (LAMoreInfoViewController *)navController.topViewController;
        lamoreinfovc.title               = @"More Details (optional)";
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        [lamoreinfovc intilizeparameters:appdelegte.addFdVO withFoodTruckDetails:fdVO];
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}


- (void)openAddFoodTruckDialog:(NSString *)strAddress withPartialAddress:(NSString *)strStreetAddress{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addfoodtruck"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 250);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAAddFdViewController class]]) {
            LAAddFdViewController *laaddvc = (LAAddFdViewController *)navController.topViewController;
            laaddvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAAddFdViewController *laaddvc = (LAAddFdViewController *)navController.topViewController;
        laaddvc.title               = @"Add Food Truck";
        laaddvc.strUserTapedAddress     = strAddress;
        appdelegte.addressAddFoodTruck  = strAddress;
        laaddvc.textFieldAt.text        = strAddress;
        laaddvc.strPartialAddress       = strStreetAddress;
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)loadCacheTweets:(NSString *)strProvider{
    FoodTruckVO *fdVO = [((LADetailsView *)self.detailsView) foodTruckVO];
    if (fdVO != nil) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = CACHE_TWEETS_REQ;
        restApiVO.TAG = REQ_CACHE_TWEETS_FOODTRUCK_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = FD_TWEETS_URL;
        restApiVO.reqDicParamObj = [AppJsonGenerator getTweetsPostParam:fdVO withSocialProvider:strProvider];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_CACHE_TWEETS_FOODTRUCK_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_CACHE_TWEETS_FOODTRUCK_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
}

- (void)loadLiveTweets{
    FoodTruckVO *fdVO = [((LADetailsView *)self.detailsView) foodTruckVO];
    
    NSString *strProvider    = nil;
    
    switch ([((LADetailsView *)self.detailsView).numIndicator integerValue]) {
        case TWITTER_INFO_TAB:{
            strProvider = JSON_TWITTER;
        }
            break;
            
        case FACEBOOK_INFO_TAB:{
             strProvider = JSON_FACEBOOK;
        }
            break;
            
        default:
            break;
    }
    
    
    if (fdVO != nil && strProvider != nil) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = LIVE_TWEETS_REQ;
        restApiVO.TAG = REQ_LIVE_TWEETS_FOODTRUCK_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = FD_LIVE_TWEETS_URL;
        
        restApiVO.reqDicParamObj = [AppJsonGenerator getTweetsPostParam:fdVO withSocialProvider:strProvider];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_LIVE_TWEETS_FOODTRUCK_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_LIVE_TWEETS_FOODTRUCK_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
    
}


- (void)updateFoodTruckLocation{
    FoodTruckVO *fdVO = [((LADetailsView *)self.detailsView) foodTruckVO];
    if (fdVO != nil) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = UPDATE_FOODTRUCK_REQ;
        restApiVO.TAG = REQ_UPDATE_FOODTRUCK_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = UPDATE_FOODTRUCK_LOCATION_URL;
        restApiVO.reqDicParamObj = [AppJsonGenerator getUpdateFoodTruckLocationPostParam:fdVO];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_UPDATE_FOODTRUCK_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_UPDATE_FOODTRUCK_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
    
}





- (void)openRefreshDialog:(NSString *)strAddress{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"autopin"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 350);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAAutoPinViewController class]]) {
            LAAutoPinViewController *laautopinvc = (LAAutoPinViewController *)navController.topViewController;
            laautopinvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        LAAutoPinViewController *laautopinvc = (LAAutoPinViewController *)navController.topViewController;
        laautopinvc.title               = @"Refresh";
        laautopinvc.strAddress = strAddress;
        [laautopinvc setDialogMsg];
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}



- (void)locationFromAddressFailureCallback:(NSError *)error{
    //LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(hud != nil){
        [hud hide:YES];
    }
    
    
}

- (void)locationFromAddressSuccessCallback:(CLLocation *)location{
    //LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(hud != nil){
        [hud hide:YES];
    }
}

- (void)addressFromLocationFailureCallback:(NSError *)error{
   LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(hud != nil){
        [hud hide:YES];
    }
    
    switch (appdelegte.GEOCODER_ADDRESS_INDICATOR) {
        case ADDRESS_FOR_ADDFOODTRUCK:{
            [self openAddFoodTruckDialog:@"" withPartialAddress:@""];
        }
            break;
            
        case ADDRESS_FOR_REFRESH_LOCATION:{
            [self openRefreshDialog:@"UNKNOWN ADDRESS"];
        }
            break;
            
        case ADDRESS_FOR_CHECKIN_LOCATION:{
            NSLog(@"geo coder Check in user location address fail");
            [self openCheckInFormDialog:@"" withActionIndicator:[[NSNumber alloc] initWithInteger:self.checkinAction] WithStreetAddress:@""];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)addressFromLocationSuccessCallback:(NSString *)address{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(hud != nil){
        [hud hide:YES];
    }
    
    switch (appdelegte.GEOCODER_ADDRESS_INDICATOR) {
        case ADDRESS_FOR_ADDFOODTRUCK:{
            [self openAddFoodTruckDialog:address withPartialAddress:self.strPartAddress];
        }
            break;
            
        case ADDRESS_FOR_REFRESH_LOCATION:{
            [self openRefreshDialog:address];
        }
            break;
            
        case ADDRESS_FOR_CHECKIN_LOCATION:{
            NSLog(@"geo coder Check in user location address suucess");
            [self openCheckInFormDialog:address withActionIndicator:[[NSNumber alloc] initWithInteger:self.checkinAction] WithStreetAddress:self.strPartAddress];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)partialAddressFromLocationSuccessCallback:(NSString *)address{
    NSLog(@"Partial address =%@", address);
    self.strPartAddress = address;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (buttonIndex == 0) {
        
        switch (appdelegte.ALERT_ACTION_INDICATOR) {
            case ADD_FOODTRUCK:{
                
                if (appdelegte.userVO != nil && appdelegte.userVO.twitterLogin) {
                    
                    [self openSocialNetWorkShareDialogWithTitle:SHARE_TWITER_TITLE withIndicator:[[NSNumber alloc] initWithInteger:TWITTER_SHARE_ADDFOODTRUCK] withObj:self.resAddFoodTruckVO];
                    
                }else if(appdelegte.userVO != nil && appdelegte.userVO.facebookLogin){
                    [self getFoodTruckData];
                    //facebook permission denied
//                    [self openSocialNetWorkShareDialogWithTitle:SHARE_FACEBOOK_TITLE withIndicator:[[NSNumber alloc] initWithInteger:FACEBOOK_SHARE_ADDFOODTRUCK] withObj:self.resAddFoodTruckVO];
                }else{
                    [self getFoodTruckData];
                }
                
            }
                break;
        
            case ERROR_DIALOG:{
                [AppUtil loadMapIntialView];
            }
                break;
                
            default:
                break;
        }
    }else if (buttonIndex == 1){
        LADetailsView *dView    = (LADetailsView *)self.detailsView;
        switch (appdelegte.ALERT_ACTION_INDICATOR) {
                
            case TRUCK_INFO_TAB:{
                [dView.detailsTextView setText:dView.foodTruckVO.description];
            }
                break;
            case FACEBOOK_INFO_TAB:
            case TWITTER_INFO_TAB:{
                [self loadLiveTweets];
            }
                break;
                
                
            case YELP_INFO_TAB:{
//                NSURLRequest *reqUrl = [dView getYelpWebUrlRequestBasedOnString:dView.foodTruckVO.yelpAddress];
//                
//                if (reqUrl != nil) {
//                    [dView.webViewYelp loadRequest:reqUrl];
//                }else{
//                    [dView loadErrorPage:dView.webViewYelp withMsg:@"Sorry, Yelp data is not available in the system"];
//                }
                
                [dView loadYelpSiteWebPage];
                
            }
                break;
                
            case WEB_INFO_TAB:{
                [dView loadWebSiteWebPage];
//                 NSURLRequest *reqUrl = [dView getWebSiteUrlRequestBasedOnString:dView.foodTruckVO.website];
//                
//                if (reqUrl != nil) {
//                    
//                    [dView.webViewWebSite loadRequest:reqUrl];
//                }else{
//                    [dView loadErrorPage:dView.webViewWebSite withMsg:@"Sorry, Website data is not available in the system"];
//                }
            }
                break;
            
            case LOGOUT_FROM_FACEBOOK:{
                [self logOutToken:appdelegte.userVO.facebookAccessToken];
                [AppUtil clearFBSession];
                
            }
            break;
            
            case LOGOUT_FROM_TWITTER:{
                [self logOutToken:appdelegte.userVO.twitterAccessToken];
                [AppUtil clearTwitterSession];
                
            }
            break;
            
            case LOGOUT_FROM_LOGOUTBTN:{
                NSString *strTwitter = nil;
                NSString *strFacebook = nil;
                if (appdelegte.accessToken != nil) {
                    strTwitter = appdelegte.accessToken.key;
                    [AppUtil clearTwitterSession];
                }
                
                if ([AppUtil isFacebookSessionValid]) {
                    strFacebook = [appdelegte.fbSession accessTokenData].accessToken;
                    [AppUtil clearFBSession];
                }
                
                if (strFacebook != nil && strTwitter != nil) {
                    NSString *strValues = [NSString stringWithFormat:@"%@,%@",strTwitter,strFacebook];
                    [self logOutToken:strValues];
                }else if(strFacebook != nil){
                    NSString *strValues = [NSString stringWithFormat:@"%@",strFacebook];
                    [self logOutToken:strValues];
                }else if(strTwitter != nil){
                    NSString *strValues = [NSString stringWithFormat:@"%@",strTwitter];
                    [self logOutToken:strValues];
                }
                
            }
            break;
                
            default:
                break;
        }
    }
    
    appdelegte.ALERT_ACTION_INDICATOR = APP_DEFAULT;
}



-(void) sendMailTo:(NSString *)strEmailID withEmailSubject:(NSString *)strEmailSubject withMessageBody:(NSString *)strMsg{
   if (strMsg != nil && strEmailSubject != nil && strEmailID != nil) {
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        NSArray *reciptents = @[strEmailID];
        [mailComposer setToRecipients:reciptents];
        [mailComposer setSubject:strEmailSubject];
        //[mailComposer setMessageBody:self.failureRestApiVO.error.description isHTML:NO];
        [mailComposer setMessageBody:strMsg isHTML:NO];
        [self presentModalViewController:mailComposer animated:YES];
  }
    
}

-(void)trytoReconnect{
    
    if (self.failureRestApiVO != nil) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:self.failureRestApiVO.TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:self.failureRestApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:self.failureRestApiVO.TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
    
    
}

-(void)openLunchAddictServerDialog{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"serverconnerror"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 250);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAInternetConnErrController class]]) {
            LAInternetConnErrController *lainternetvc = (LAInternetConnErrController *)navController.topViewController;
            lainternetvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        LAInternetConnErrController *lainternetvc = (LAInternetConnErrController *)navController.topViewController;
        lainternetvc.title               = @"Sorry";
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}
     
#pragma mark - mail compose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            [self.view makeToast:@"Mail cancelled"];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            [self.view makeToast:@"Mail saved"];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            [self.view makeToast:@"Mail sent"];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            [self.view makeToast:@"Mail sent failure"];
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)showDetailsView:(FoodTruckVO *)fdVO{
    if(fdVO != nil){
        [self.menuView setHidden:YES];
        self.detailsView =(LADetailsView *)[[NSBundle mainBundle] loadNibNamed:@"DetailsView" owner:self options:nil].lastObject;
        LADetailsView *detailsview  = (LADetailsView *)self.detailsView;
        
        detailsview.foodTruckVO = fdVO;
        [detailsview designView];
        self.detailsView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.view addSubview:self.detailsView];
    }
}

-(void)homeBackAction{
    [self.detailsView removeFromSuperview];
    [self.menuView setHidden:NO];
    [self.detailsView setHidden:YES];
    //self.detailsView = nil;
}

- (void)detailsPageLongRefresh{
   
    [AppUtil openRefreshMsgDialog:@"Refresh" withmsg:@"It will take up to 10 seconds to get the latest content. Proceed?" withdelegate:self];
}

- (void)doFoodTruckConfirm:(FoodTruckVO *)fdVO withConfirm:(BOOL)bConfirm{
    if (fdVO != nil) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = FT_CONFIRM_REQ;
        restApiVO.TAG = REQ_FT_CONFIRM_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = FOODTRUCK_CONFORMATION_URL;
        restApiVO.reqDicParamObj = [AppJsonGenerator getFtConfirmationPostParam:fdVO withConfirmation:bConfirm];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_FT_CONFIRM_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_FT_CONFIRM_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
}

- (void)getAccountVerifyCredentials{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = TWITER_TOKEN_VALIDATING_MSG;
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appdelegte.accessToken != nil) {
        NSURL* verifyCredentialsUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
        
        OAMutableURLRequest* verifyCredentialRequest = [[OAMutableURLRequest alloc] initWithURL:verifyCredentialsUrl
                                                                                       consumer:appdelegte.consumer
                                                                                          token:appdelegte.accessToken
                                                                                          realm:nil
                                                                              signatureProvider:nil];
        
        OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:TWITTER_CALLBACK];
        [verifyCredentialRequest setHTTPMethod:@"GET"];
        [verifyCredentialRequest setParameters:[NSArray arrayWithObject:callbackParam]];
        OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
        [dataFetcher fetchDataWithRequest:verifyCredentialRequest
                                 delegate:self
                        didFinishSelector:@selector(didReceiveVerifyAccessToken:data:)
                          didFailSelector:@selector(didVerifyAccessTokenFailOAuth:error:)];
    }
    
    
}

- (void)didReceiveVerifyAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (hud != nil) {
        [hud hide:YES];
    }
    
    NSError *error=nil;
    NSDictionary *jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    
    if(error){
        NSLog(@"Json object with data error %@", error);
        
        
    }else{
        if ([[jsonData allKeys] containsObject:@"errors"]) {
            
            [self saveTwitterValidationResponse:nil];
            
        }else{
            SocialNetworkVO *socialNetworkVO = [[SocialNetworkVO alloc] init];
            socialNetworkVO.username            = [jsonData objectForKey:@"name"];
            socialNetworkVO.userHandler         = [jsonData objectForKey:@"screen_name"];
            socialNetworkVO.accessToken         = appdelegte.accessToken.key;
            socialNetworkVO.accessTokenExpire   = @"";
            socialNetworkVO.providerName        = TWITTER;
            socialNetworkVO.accessTokenSecrete  = appdelegte.accessToken.secret;
            
            [self saveTwitterValidationResponse:socialNetworkVO];
            
            
        }
    }
   
    
}

- (void)didVerifyAccessTokenFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
    NSLog(@"Twitter oauth error = %@",error.description);
    
    if (hud != nil) {
        [hud hide:YES];
    }
    
    [self saveTwitterValidationResponse:nil];
    
}

-(void)saveTwitterValidationResponse:(SocialNetworkVO *)socialVo{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (socialVo != nil) {
        switch (appdelegte.TWITTER_TOKEN_VALIDATION_STATE) {
            case TWITTER_TOKEN_VALIDATION:{
                appdelegte.userVO.twitterLogin = YES;
                appdelegte.userVO.isValidTwitterToken = YES;
            }
            break;
            
            case TWITTER_TOKEN_LOGIN_VALIDATION:{
                [AppDatabase saveSocialNetworkInfo:socialVo isLogin:YES isSessionValid:YES];
                [self logToken:socialVo];
            }
            break;
        }
    }else{
        switch (appdelegte.TWITTER_TOKEN_VALIDATION_STATE) {
            case TWITTER_TOKEN_VALIDATION:{
                appdelegte.userVO.twitterLogin = YES;
                appdelegte.userVO.isValidTwitterToken = NO;
            }
            break;
            
            case TWITTER_TOKEN_LOGIN_VALIDATION:{
                [AppDatabase saveSocialNetworkInfo:socialVo isLogin:NO isSessionValid:NO];
            }
            break;
        }
    }
}

- (void)submitCheckOutDetails:(FoodTruckVO *)foodTruckVO withTagObj:(CheckinoutVO *)checkinVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (foodTruckVO != nil ) {
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = CHECK_OUT_REQ;
        restApiVO.TAG = REQ_CHECK_OUT_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = CHECK_OUT_URL;
        restApiVO.reqTagObj = checkinVO;
        restApiVO.reqDicParamObj = [AppJsonGenerator getCheckOutJSONPostParam:foodTruckVO];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_CHECK_OUT_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_CHECK_OUT_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
}


- (void)submitCheckINDetails:(FoodTruckVO *)foodTruckVO withTagObj:(CheckinoutVO *)checkinVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (foodTruckVO != nil && checkinVO != nil) {
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = CHECK_IN_REQ;
        restApiVO.TAG = REQ_CHECK_IN_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = CHECK_IN_URL;
        restApiVO.reqTagObj = checkinVO;
        
        
        
        
        restApiVO.reqDicParamObj = [AppJsonGenerator getCheckInJSONPostParam:foodTruckVO];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_CHECK_IN_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_CHECK_IN_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
}




- (void)isMerchantValidation:(SocialNetworkVO *)socialNetworkVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (socialNetworkVO != nil) {
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = IS_MERCHANT_REQ;
        restApiVO.TAG = REQ_IS_MERCHANT_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = IS_MERCHANT_URL;
        restApiVO.reqDicParamObj = [AppJsonGenerator getIsMarchantPostParam:socialNetworkVO withHandler:TWITTER];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = IS_MERCHANT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_IS_MERCHANT_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_IS_MERCHANT_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
}

- (void)logToken:(SocialNetworkVO *)socialNetworkVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (socialNetworkVO != nil) {
        NSInteger source = 0;
        
        if ([socialNetworkVO.providerName isEqualToString:TWITTER]) {
            source = TWITTER_HANDLER_TYPE;
        }else if ([socialNetworkVO.providerName isEqualToString:FACEBOOK]){
            source = FACEBOOK_HANDLER_TYPE;
        }
        
        TokenVO *tokenVO = [[TokenVO alloc] init];
        tokenVO.username = socialNetworkVO.username;
        tokenVO.tokenValue = socialNetworkVO.accessToken;
        tokenVO.tokenSecreteValue = socialNetworkVO.accessTokenSecrete;
        
        if (socialNetworkVO.accessTokenExpire != nil && [[socialNetworkVO.accessTokenExpire stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:APP_DB_DATE_FORMATE];
            
            NSDate *expDate  = [df dateFromString:socialNetworkVO.accessTokenExpire];
            long long milliseconds = (long long)([expDate timeIntervalSince1970] * 1000.0);
            tokenVO.expire   = [NSString stringWithFormat:@"%lld", milliseconds];
            
        }else{
            tokenVO.expire = socialNetworkVO.accessTokenExpire;
        }
        
        tokenVO.status = @"";
        
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = ADD_USER_TOKEN_REQ;
        restApiVO.TAG = REQ_ADD_USER_TOKEN_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = ADD_USER_TOKEN_URL;
        restApiVO.reqTagObj = socialNetworkVO;
        restApiVO.reqDicParamObj = [AppJsonGenerator getaddUserTokenJSONPostParam:tokenVO withHandler:source];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_ADD_USER_TOKEN_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_ADD_USER_TOKEN_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
    
}


- (void)logOutToken:(NSString *)strTokenValues{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (strTokenValues != nil && [[strTokenValues stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        
        
        TokenVO *tokenVO = [[TokenVO alloc] init];
        tokenVO.tokenValue = strTokenValues;
        
        
        RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
        restApiVO.REQ_IDENTIFIER    = LOGOUT_TOKEN_REQ;
        restApiVO.TAG = REQ_LOGOUT_TOKEN_TAG;
        restApiVO.reqtype = POST_REQ;
        restApiVO.reqUrl  = LOGOUT_TOKEN_URL;
        restApiVO.reqDicParamObj = [AppJsonGenerator getLogOutJSONPostParam:tokenVO];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_LOGOUT_TOKEN_TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_LOGOUT_TOKEN_TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
    
}

- (void)saveFacebookUserInfo{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegte.window.rootViewController.view makeToast:@"User successfully logged into facebook"duration:1.0 position:@"bottom"];
    //[appdelegte.window.rootViewController.view makeToast:@"User successfully logged into facebook"];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = PLEASEWAIT_MSG;
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        
        if (hud != nil) {
            [hud hide:YES];
        }
        
        if (error) {
            
            NSLog(@"error:%@",error);
            
            
        }
        else
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:APP_DB_DATE_FORMATE];
            
            SocialNetworkVO *socialNetWorkVO    = [[SocialNetworkVO alloc] init];
            
            socialNetWorkVO.providerName = FACEBOOK;
            socialNetWorkVO.username = user.name;
            socialNetWorkVO.userHandler = user.name;
            socialNetWorkVO.accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
            socialNetWorkVO.accessTokenExpire = [df stringFromDate:[[[FBSession activeSession] accessTokenData] expirationDate]];
            socialNetWorkVO.accessTokenSecrete = @"";
            
            [AppDatabase saveSocialNetworkInfo:socialNetWorkVO isLogin:YES isSessionValid:YES];
            
            [self logToken:socialNetWorkVO];
            
        }
    }];
}

- (void)tokenStatuscallback:(NSMutableDictionary *)dicResponse{
    if (dicResponse != nil) {
        
        TokenCacheVO *tokenCacheVO  = [dicResponse objectForKey:@"TokenCache"];
        NSObject *obj   = [dicResponse objectForKey:@"Response"];
        
        if (obj != nil) {
            if ([obj class] == [TokenVO class]) {
                TokenVO *tokenVO = (TokenVO *)obj;
                
                if ([TOKEN_ACTIVE isEqualToString:tokenVO.status]) {
                    tokenCacheVO.isvalid = APP_YES;
                    
                }else{
                    tokenCacheVO.isvalid = APP_NO;
                }
                
                if ([APP_YES isEqualToString:tokenCacheVO.isvalid]) {
                    [AppDatabase deleteTokenIntoTokenCache:tokenCacheVO];
                }else if([APP_NO isEqualToString:tokenCacheVO.isvalid]){
                    NSInteger numAttempts   = [tokenCacheVO.numofattempts integerValue];
                    NSInteger maxlimit      = [tokenCacheVO.maxlimit integerValue];
                    if(numAttempts < maxlimit){
                        [AppDatabase updateTokenIntoTokenCache:tokenCacheVO];
                        
                    }else if(numAttempts >= maxlimit){
                        [AppDatabase deleteTokenIntoTokenCache:tokenCacheVO];
                        
                        if ([FACEBOOK isEqualToString:tokenCacheVO.providername]) {
                            [AppUtil clearFBSession];
                        }else if([TWITTER isEqualToString:tokenCacheVO.providername]){
                            [AppUtil clearTwitterSession];
                        }
                        
                        [self openTokenStatusErrorDialog:tokenCacheVO];
                        
                    }
                }
                
            }else if ([obj class] == [ErrorVO class]){
                ErrorVO *errorVo    = (ErrorVO *)obj;
                NSLog(@"Error token status %@", errorVo.msg);
            }
        }
        
        
        
    }
}

-(void)openTokenStatusErrorDialog:(TokenCacheVO *)tokenCacheVO{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tokenstatus"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 280);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[TokenStatusController class]]) {
            TokenStatusController *mzvc = (TokenStatusController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        TokenStatusController *tokenstatusvc = (TokenStatusController *)navController.topViewController;
        navController.topViewController.title = @"Token status failed";
        tokenstatusvc.tokenCacheVO = tokenCacheVO;
        [tokenstatusvc designView];
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}


- (void)openMerchantSessionExpired:(NSString *)strMerchant{
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mersessionexpired"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 298);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[TokenStatusController class]]) {
            MerchantViewController *mzvc = (MerchantViewController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        MerchantViewController *mersessvc = (MerchantViewController *)navController.topViewController;
        navController.topViewController.title = @"Merchant Session Expired";
        mersessvc.strMerchantName = strMerchant;
        [mersessvc designView];
        
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)openAutoCheckinDialog{
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"autocheckin"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 230);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[TokenStatusController class]]) {
            AutoCheckinController *mzvc = (AutoCheckinController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        AutoCheckinController *autochecinvc = (AutoCheckinController *)navController.topViewController;
        navController.topViewController.title = @"Auto Check-In";
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)openAutoCheckoutdialogWithTagObj:(CheckinoutVO *)checkinVO{
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"autocheckout"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 270);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[TokenStatusController class]]) {
            AutoCheckOutViewController *mzvc = (AutoCheckOutViewController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        AutoCheckOutViewController *autocheckoutvc = (AutoCheckOutViewController *)navController.topViewController;
        navController.topViewController.title = @"Auto Checkout";
        autocheckoutvc.checkinOutVO = checkinVO;
        [autocheckoutvc designView];
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)openCheckOutConfirmDialogWithTagObj:(CheckinoutVO *)checkinVO{
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"checkoutconfirm"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 270);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[TokenStatusController class]]) {
            CheckOutConfirmController *mzvc = (CheckOutConfirmController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        CheckOutConfirmController *checkoutconfirmvc = (CheckOutConfirmController *)navController.topViewController;
        navController.topViewController.title = @"Checkout confirm";
        checkoutconfirmvc.checkinVO = checkinVO;
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
    
    
}

- (void)openCheckInFormDialog:(NSString *)strAddress withActionIndicator:(NSNumber *)numAction WithStreetAddress:(NSString *)strStreetAddress{
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"checkinform"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 310);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[TokenStatusController class]]) {
            CheckinFormController *mzvc = (CheckinFormController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
         LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        CheckinFormController *checkinformvc = (CheckinFormController *)navController.topViewController;
        navController.topViewController.title = @"Checkin";
        checkinformvc.strAddress = strAddress;
        checkinformvc.numCheckInAction = numAction;
        checkinformvc.strStreetAddress = strStreetAddress;
        appdelegte.addressCheckinFoodTruck = strAddress;
        [checkinformvc designView];
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}


- (void)openSocialNetWorkShareDialogWithTitle:(NSString *)strTitle withIndicator:(NSNumber *)num withObj:(id)obj{
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sharedialog"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(320, 298);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[ShareViewController class]]) {
            ShareViewController *mzvc = (ShareViewController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        navController.topViewController.title = strTitle;
        ShareViewController *sharemvc = (ShareViewController *)navController.topViewController;
        [sharemvc designView:num with:obj];
        
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}





@end
