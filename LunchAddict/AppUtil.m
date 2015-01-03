//
//  AppUtil.m
//  LunchAddict
//
//  Created by SPEROWARE on 30/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "AppUtil.h"
#import "AppConstants.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppMsg.h"
#import "LAViewController.h"
#import "AppDatabase.h"
#import "LAInitViewController.h"


@implementation AppUtil

+(UIImage *)getFoodTruckStatusIcon:(NSString *)stricon{
    
    if ([FOOD_TRUCK_YELLOW_ICON isEqualToString:stricon]) {
        return [UIImage imageNamed:@"fdyellow60"];
    }else if ([FOOD_TRUCK_RED_ICON isEqualToString:stricon]) {
        return [UIImage imageNamed:@"fdred60"];
    }else if ([FOOD_TRUCK_GREEN_ICON isEqualToString:stricon]) {
        return [UIImage imageNamed:@"fdgreen60"];
    }else if ([FOOD_TRUCK_BLUE_ICON isEqualToString:stricon]) {
        return [UIImage imageNamed:@"fdblue60"];
    }else if ([FOOD_TRUCK_WHITE_ICON isEqualToString:stricon]) {
        return [UIImage imageNamed:@"fdwhite60"];
    }else if ([FOOD_TRUCK_BLACK_ICON isEqualToString:stricon]) {
        return [UIImage imageNamed:@"fdblack60"];
    }else {
        return [UIImage imageNamed:@"fdyellow60"];
    }
}

+ (NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+ (void)openErrorDialog:(NSString*)strTitle withmsg:(NSString *)strMsg withdelegate:(id)delegate{
    if(strTitle != nil && strMsg != nil){
        UIAlertView *alertView  =[[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:delegate cancelButtonTitle:@"Ok"otherButtonTitles:nil];
        [alertView show];
    }
}

+ (void)openMsgDialog:(NSString*)strTitle withmsg:(NSString *)strMsg withdelegate:(id)delegate{
    if(strTitle != nil && strMsg != nil){
        UIAlertView *alertView  =[[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:delegate cancelButtonTitle:@"Ok"otherButtonTitles:nil];
        [alertView show];
    }
}

+ (void)openRefreshMsgDialog:(NSString*)strTitle withmsg:(NSString *)strMsg withdelegate:(id)delegate{
    if(strTitle != nil && strMsg != nil){
        UIAlertView *alertView  =[[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:delegate cancelButtonTitle:@"Cancel"otherButtonTitles:nil];
        [alertView addButtonWithTitle:@"Proceed"];
        [alertView show];
    }
}

+ (void)openTwoOptionsMsgDialog:(NSString*)strTitle withmsg:(NSString *)strMsg withdelegate:(id)delegate{
    if(strTitle != nil && strMsg != nil){
        UIAlertView *alertView  =[[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:delegate cancelButtonTitle:@"Cancel"otherButtonTitles:nil];
        [alertView addButtonWithTitle:@"Ok"];
        [alertView show];
    }
}

+ (void)getFoodTrucks:(FdListPostParam *)fdListPostParam withDelegate:(id)delegate{
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appdelegte.PREV_FOOD_TRUCK_LOCATION = CLLocationCoordinate2DMake([fdListPostParam.lat doubleValue], [fdListPostParam.lng doubleValue]);
    
    RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
    restApiVO.REQ_IDENTIFIER    = FOODTRUCK_LIST_REQ;
    restApiVO.TAG = REQ_FOODTRUCK_LIST_TAG;
    restApiVO.reqtype = POST_REQ;
    restApiVO.reqUrl  = FOODTRUCK_LIST_URL;
    restApiVO.reqDicParamObj = [AppJsonGenerator getFoodTruckListPostParam:fdListPostParam];
    
    if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_FOODTRUCK_LIST_TAG]){
        RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:delegate];
        [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_FOODTRUCK_LIST_TAG];
        [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
    }
    
}

+ (void)getFoodTruckDetailsByTwitterHandler:(NSString *)strTwitter withDelegate:(id)delegate{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
    restApiVO.REQ_IDENTIFIER    = FD_DETAILS_BY_TWITTER_REQ;
    restApiVO.TAG = REQ_FD_DETAILS_BY_TWITTER_TAG;
    restApiVO.reqtype = POST_REQ;
    restApiVO.reqUrl  = FOODTRUCK_BY_TWITTER_URL;
    restApiVO.reqDicParamObj = [AppJsonGenerator getFoodtruckByTwitterHandler:strTwitter];
    
    
    if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_FD_DETAILS_BY_TWITTER_TAG]){
        RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:delegate];
        [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_FD_DETAILS_BY_TWITTER_TAG];
        [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
    }
    
}



+ (double) getDistanceInMetersBetWeenLocation1:(CLLocationCoordinate2D)coord1 withLocation2:(CLLocationCoordinate2D)coord2{
    
    CLLocation* location1 =[[CLLocation alloc]initWithLatitude: coord1.latitude longitude: coord1.longitude];
    CLLocation* location2 =[[CLLocation alloc]initWithLatitude: coord2.latitude
     longitude: coord2.longitude];
    
    return [location1 distanceFromLocation: location2];
    
}

+ (NSComparisonResult)compareDateOnly:(NSDate *)otherDate {
    NSUInteger dateFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *selfComponents = [gregorianCalendar components:dateFlags fromDate:[NSDate date]];
    NSDate *selfDateOnly = [gregorianCalendar dateFromComponents:selfComponents];
    
    NSDateComponents *otherCompents = [gregorianCalendar components:dateFlags fromDate:otherDate];
    NSDate *otherDateOnly = [gregorianCalendar dateFromComponents:otherCompents];
    return [selfDateOnly compare:otherDateOnly];
}

+ (NSComparisonResult)compareDateYesterDayOnly:(NSDate *)otherDate {
    NSUInteger dateFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    
    NSDateComponents *selfComponents = [gregorianCalendar components:dateFlags fromDate:yesterday];
    NSDate *selfDateOnly = [gregorianCalendar dateFromComponents:selfComponents];
    
    NSDateComponents *otherCompents = [gregorianCalendar components:dateFlags fromDate:otherDate];
    NSDate *otherDateOnly = [gregorianCalendar dateFromComponents:otherCompents];
    return [selfDateOnly compare:otherDateOnly];
}



+ (NSString *)getTwitterDateString:(NSString *)strDate{
    
    //strDate = @"Thu Aug 14 11:39:00 +0000 2014";
    
    NSString *strTwitter = @"";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *twitterdate = [df dateFromString:strDate];
    
    NSComparisonResult result   = [AppUtil compareDateOnly:twitterdate];
    
    NSDate *date = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    if (result == NSOrderedSame) {
       // NSLog(@"Today...");
        
        
        NSDateComponents *secondsComponent = [calender components:NSCalendarUnitSecond fromDate:twitterdate toDate:date options:NSCalendarWrapComponents];
        NSDateComponents *minutsComponent = [calender components:NSCalendarUnitMinute fromDate:twitterdate toDate:date options:NSCalendarWrapComponents];
        NSDateComponents *hourComponent = [calender components:NSCalendarUnitHour fromDate:twitterdate toDate:date options:NSCalendarWrapComponents];
        
        if ([hourComponent hour] > 0) {
            strTwitter = [NSString stringWithFormat:@"%ldh",(long)[hourComponent hour]];
        }else if ([minutsComponent minute] > 0){
            strTwitter = [NSString stringWithFormat:@"%ldm",(long)[minutsComponent minute]];
        }else if ([secondsComponent second] > 0){
            strTwitter = [NSString stringWithFormat:@"%lds",(long)[secondsComponent second]];
        }
    }else{
        
        
        NSDateComponents *yearComponent = [calender components:NSCalendarUnitYear fromDate:twitterdate toDate:date options:NSCalendarWrapComponents];
        if ([yearComponent year] == 0) {
            [df setDateFormat:@"MMM dd"];
            strTwitter = [df stringFromDate:twitterdate];            
        }else {
            [df setDateFormat:@"MMM dd, yyyy"];
            strTwitter = [df stringFromDate:twitterdate];
        }
        
    }
    
    
    return strTwitter;
    
}


+ (NSString *)getFacebookDateString:(NSString *)strDate{
    
    NSString *strFacebook = @"";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *twitterdate = [df dateFromString:strDate];
    
    NSComparisonResult result   = [AppUtil compareDateOnly:twitterdate];
    
    NSDate *date = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    if (result == NSOrderedSame) {
        NSDateComponents *secondsComponent = [calender components:NSCalendarUnitSecond fromDate:twitterdate toDate:date options:NSCalendarWrapComponents];
        NSDateComponents *minutsComponent = [calender components:NSCalendarUnitMinute fromDate:twitterdate toDate:date options:NSCalendarWrapComponents];
        NSDateComponents *hourComponent = [calender components:NSCalendarUnitHour fromDate:twitterdate toDate:date options:NSCalendarWrapComponents];
        
        if ([hourComponent hour] > 0) {
            strFacebook = [NSString stringWithFormat:@"%ldh",(long)[hourComponent hour]];
        }else if ([minutsComponent minute] > 0){
            strFacebook = [NSString stringWithFormat:@"%ldm",(long)[minutsComponent minute]];
        }else if ([secondsComponent second] > 0){
            strFacebook = [NSString stringWithFormat:@"%lds",(long)[secondsComponent second]];
        }
    }else{
        
        NSDateComponents *yearComponent = [calender components:NSCalendarUnitYear fromDate:twitterdate toDate:date options:NSCalendarWrapComponents];
        NSComparisonResult result   = [AppUtil compareDateYesterDayOnly:twitterdate];
        
        if (result == NSOrderedSame) {
            
            strFacebook = @"Yesterday";
            //Facebook Time formate
            [df setDateFormat:APP_TIME_FORMATE];
            NSString *strTime = [df stringFromDate:twitterdate];
            strFacebook = [strFacebook stringByAppendingString:@" at "];
            strFacebook = [strFacebook stringByAppendingString:[strTime lowercaseString]];
            
            
        }else if ([yearComponent year] == 0) {
            [df setDateFormat:@"MMMM dd"];
            strFacebook = [df stringFromDate:twitterdate];
            //Facebook Time formate
            [df setDateFormat:APP_TIME_FORMATE];
            NSString *strTime = [df stringFromDate:twitterdate];
            strFacebook = [strFacebook stringByAppendingString:@" at "];
            strFacebook = [strFacebook stringByAppendingString:[strTime lowercaseString]];
        }else {
            [df setDateFormat:@"MMMM dd, yyyy"];
            strFacebook = [df stringFromDate:twitterdate];
            //Facebook Time formate
            [df setDateFormat:APP_TIME_FORMATE];
            NSString *strTime = [df stringFromDate:twitterdate];
            strFacebook = [strFacebook stringByAppendingString:@" at "];
            strFacebook = [strFacebook stringByAppendingString:[strTime lowercaseString]];
        }
        
    }
    
    
    return strFacebook;
    
}

+ (void)addFoodTruckToHistoryRecord:(FoodTruckVO *)foodTruckVO{
    
    if (foodTruckVO == nil) {
        return;
    }
    
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    BOOL isExists   = NO;
    
    
    NSMutableArray *historyFoodTrucks = [AppDatabase loadRecentFoodTrucks];
    
    for (id obj in historyFoodTrucks) {
        FoodTruckVO *fdVO   = (FoodTruckVO *)obj;
        if ([[fdVO.foodtruckid lowercaseString] isEqualToString:[foodTruckVO.foodtruckid lowercaseString]] && [[fdVO.locationid lowercaseString] isEqualToString:[foodTruckVO.locationid lowercaseString]]) {
            isExists = YES;
        }
    }
    
    if (!isExists) {
        [AppDatabase insertRecentFoodTruckDetails:foodTruckVO];
    }
    
    NSMutableArray *deleteFoodTrucks = [AppDatabase loadRecentFoodTrucks];
    
    if ([deleteFoodTrucks count] > 10) {
        FoodTruckVO *deleteFdVO = [deleteFoodTrucks objectAtIndex:0];
        [AppDatabase deleteRecentFooTruckDetails:deleteFdVO.locationid withFoodTruckID:deleteFdVO.foodtruckid];
    }
    
    
    
    appdelegte.FOODTRUCKS_HISTORY_RECORD = [AppDatabase loadRecentFoodTrucks];
    
    
//    for (id obj in appdelegte.FOODTRUCKS_HISTORY_RECORD) {
//        FoodTruckVO *fdVO   = (FoodTruckVO *)obj;
//        if ([fdVO.foodtruckid isEqualToString:foodTruckVO.foodtruckid] && [fdVO.locationid isEqualToString:foodTruckVO.locationid]) {
//            isExists = YES;
//        }
//    }
//    
//    if (!isExists) {
//        [appdelegte.FOODTRUCKS_HISTORY_RECORD addObject:foodTruckVO];
//    }
//    
//    if ([appdelegte.FOODTRUCKS_HISTORY_RECORD count] >= 10) {
//        [appdelegte.FOODTRUCKS_HISTORY_RECORD removeObjectAtIndex:0];
//    }
}

+ (void)openFaceBookShareDialog{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc = (LAViewController *)appdelegte.window.rootViewController;
    
    if ([self isFacebookSessionValid]) {
        [FBWebDialogs presentFeedDialogModallyWithSession:[FBSession activeSession]
                                               parameters:nil
                                                  handler:
         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 [vc.view makeToast:FACEBOOK_POST_FAIL_MSG];
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     // User clicked the "x" icon
                     //NSLog(@"User canceled story publishing.");
                     [vc.view makeToast:FACEBOOK_POST_FAIL_MSG];
                 } else {
                     [vc.view makeToast:FACEBOOK_POST_SUCCESSFUL_MSG];
                 }
             }
         }];
    }else{
        [vc.view makeToast:@"You need to login into facebook"];
    }
    
    
}


+ (void)postMsgOnFacebookWall:(NSDictionary *)params withIndicator:(NSNumber *)indicator{
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc = (LAViewController *)appdelegte.window.rootViewController;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = PLEASEWAIT_MSG;
    
    
    if (params != nil) {
        
        [FBRequestConnection startWithGraphPath:@"/me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  
                                  if(hud != nil){
                                      [hud hide:YES];
                                  }
                                  
                                  if (error)
                                  {
                                      //showing an alert for failure
                                      //NSLog(@"fail error : %@", error);
                                      [AppUtil loadMapIntialView];
                                      [vc.view makeToast:FACEBOOK_POST_FAIL_MSG];
                                  }
                                  else
                                  {
                                      //showing an alert for success
                                      //NSLog(@"posted succes fully!");
                                      [vc.view makeToast:FACEBOOK_POST_SUCCESSFUL_MSG];
                                      switch ([indicator integerValue]) {
                                          case FACEBOOK_SHARE_CHECKIN:{
                                              [AppUtil loadMapIntialView];
                                          }
                                              break;
                                          case FACEBOOK_SHARE_ADDFOODTRUCK:{
                                              [vc getFoodTruckData];
                                          }
                                              break;
                                          
                                          default:
                                              break;
                                      }
                                      
                                  }
                                  
                              }];
    }
    
}

+ (BOOL)isFacebookSessionValid{
    BOOL isValid = NO;
    //if([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded){
        NSString *strAccessToken    = [FBSession activeSession].accessTokenData.accessToken;
        NSDate *expireDate  = [FBSession activeSession].accessTokenData.expirationDate;
        
        if (strAccessToken != nil && expireDate != nil && [[strAccessToken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
            NSComparisonResult result   = [AppUtil compareDateOnly:expireDate];
            if (result == NSOrderedSame || result == NSOrderedAscending) {
                isValid = YES;
            }
        }
        
        
    //}
    
    return isValid;
}

+ (NSString *) md5:(NSString *) input{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+ (void)validateTokens{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAInitViewController *vc = (LAInitViewController *)appdelegte.window.rootViewController;
    NSArray *fbpermissions = [NSArray arrayWithObjects:@"email", @"publish_stream",@"publish_actions",nil];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    
    if (appdelegte.userVO != nil) {
        
        if (appdelegte.userVO.facebookAccessToken != nil && appdelegte.userVO.faceboolAccessTokenExpire != nil && [[appdelegte.userVO.facebookAccessToken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0 && [[appdelegte.userVO.faceboolAccessTokenExpire stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
            NSString *strFBDate = appdelegte.userVO.faceboolAccessTokenExpire;
            NSString *strFbAccessToken = appdelegte.userVO.facebookAccessToken;
            
            NSDate *exipireDate = [df dateFromString:strFBDate];
            
            FBAccessTokenData *fbAccessTokenData = [FBAccessTokenData createTokenFromString:strFbAccessToken permissions:fbpermissions expirationDate:exipireDate loginType:FBSessionLoginTypeWebView refreshDate:[[NSDate alloc] init]];
            
            FBSessionTokenCachingStrategy *tokenStrategy= [[FBSessionTokenCachingStrategy alloc] init];
            [tokenStrategy cacheFBAccessTokenData:fbAccessTokenData];
            
             appdelegte.fbSession = [[FBSession alloc] initWithAppID:FACEBOOK_APPID permissions:fbpermissions urlSchemeSuffix:nil tokenCacheStrategy:tokenStrategy];
            
            [FBSession setActiveSession:appdelegte.fbSession];
            if ([self isFacebookSessionValid]) {
                appdelegte.userVO.isValidFbToken = YES;
                appdelegte.userVO.facebookLogin  = YES;
                [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                   // NSLog(@"Finished opening login session, with state: %d", status);
                }];
                
            }else{
                appdelegte.userVO.isValidFbToken = NO;
                appdelegte.userVO.facebookLogin  = YES;
            }
            
        }else{
            appdelegte.userVO.isValidFbToken = NO;
            appdelegte.userVO.facebookLogin  = NO;
            
            FBSessionTokenCachingStrategy *tokenEmptyStrategy= [[FBSessionTokenCachingStrategy alloc] init];
            [tokenEmptyStrategy cacheFBAccessTokenData:[[FBAccessTokenData alloc] init]];
            
            appdelegte.fbSession = [[FBSession alloc] initWithAppID:FACEBOOK_APPID permissions:fbpermissions urlSchemeSuffix:nil tokenCacheStrategy:tokenEmptyStrategy];
            [FBSession setActiveSession:appdelegte.fbSession];
        }
        
        
        
        if (appdelegte.userVO.twitterAccessToken != nil && appdelegte.userVO.twitterAccessTokenScrete != nil && [[appdelegte.userVO.twitterAccessToken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0 && [[appdelegte.userVO.twitterAccessTokenScrete stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0){
            
            appdelegte.accessToken = [[OAToken alloc] initWithKey:appdelegte.userVO.twitterAccessToken secret:appdelegte.userVO.twitterAccessTokenScrete];
            
            appdelegte.TWITTER_TOKEN_VALIDATION_STATE = TWITTER_TOKEN_VALIDATION;
            [vc validateTwitterUserCredentials];
            
            
        }else{
            appdelegte.userVO.isValidTwitterToken = NO;
            appdelegte.userVO.twitterLogin  = NO;
            appdelegte.accessToken  = nil;
            LAViewController *mainViewController = [appdelegte.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"main"];
            appdelegte.window.rootViewController = mainViewController;
        }
    }
    
    
    
}

+ (void) clearTwitterSession{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    SocialNetworkVO *socialNetWorkVO    = [[SocialNetworkVO alloc] init];
    socialNetWorkVO.providerName = TWITTER;
    socialNetWorkVO.accessToken  = @"";
    socialNetWorkVO.accessTokenExpire = @"";
    socialNetWorkVO.accessTokenSecrete = @"";
    socialNetWorkVO.username = @"";
    socialNetWorkVO.userHandler = @"";
    
    [AppDatabase saveSocialNetworkInfo:socialNetWorkVO isLogin:NO isSessionValid:NO];
    
    appdelegte.accessToken = nil;
    
    TokenCacheVO *tokenCacheVO  = [[TokenCacheVO alloc] init];
    tokenCacheVO.providername = TWITTER;
    
    [AppDatabase deleteTokenIntoTokenCache:tokenCacheVO];
    
    [self clearMerchantData];
    [self clearMarchantCheckinData];
    
}

+ (void) clearFBSession{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
     NSArray *fbpermissions = [NSArray arrayWithObjects:@"email", @"publish_stream",nil];
    
    SocialNetworkVO *socialNetWorkVO    = [[SocialNetworkVO alloc] init];
    socialNetWorkVO.providerName = FACEBOOK;
    socialNetWorkVO.accessToken  = @"";
    socialNetWorkVO.accessTokenExpire = @"";
    socialNetWorkVO.accessTokenSecrete = @"";
    socialNetWorkVO.username = @"";
    socialNetWorkVO.userHandler = @"";
    
    [AppDatabase saveSocialNetworkInfo:socialNetWorkVO isLogin:NO isSessionValid:NO];
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    
    FBSessionTokenCachingStrategy *tokenEmptyStrategy= [[FBSessionTokenCachingStrategy alloc] init];
    [tokenEmptyStrategy cacheFBAccessTokenData:[[FBAccessTokenData alloc] init]];
    
    appdelegte.fbSession = [[FBSession alloc] initWithAppID:FACEBOOK_APPID permissions:fbpermissions urlSchemeSuffix:nil tokenCacheStrategy:tokenEmptyStrategy];
    [FBSession setActiveSession:appdelegte.fbSession];
    
    
    TokenCacheVO *tokenCacheVO  = [[TokenCacheVO alloc] init];
    tokenCacheVO.providername = FACEBOOK;
    

    
    [AppDatabase deleteTokenIntoTokenCache:tokenCacheVO];
}

+ (void) clearMerchantData{
    FoodTruckVO *fdVO   = [[FoodTruckVO alloc] init];
    fdVO.isMerchant = APP_NO;
    fdVO.lat = 0;
    fdVO.lng = 0;
    fdVO.locationid = @"";
    fdVO.foodtruckid= @"";
    fdVO.name= @"";
    fdVO.description= @"";
    fdVO.extraDescription= @"";
    fdVO.twitterHandle= @"";
    fdVO.twitterName= @"";
    fdVO.facebookAddress= @"";
    fdVO.instagramUserName= @"";
    fdVO.yelpAddress= @"";
    fdVO.cousineText= @"";
    fdVO.website= @"";
    fdVO.distance= 0;
    fdVO.status= @"";
    fdVO.emailAddress= @"";
    fdVO.phoneNum= @"";
    fdVO.openDate= @"";
    fdVO.closeDate= @"";
    fdVO.icon= @"";
    
    [AppDatabase updateMerchantData:fdVO];
}

+ (void)loginToFacebook{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegte.IS_ONLINE) {
        if (![AppUtil isFacebookSessionValid]) {
            [[FBSession activeSession] closeAndClearTokenInformation];
            
            NSArray *fbpermissions = [NSArray arrayWithObjects:@"email", @"publish_stream",@"publish_actions",nil];
            
            FBSessionTokenCachingStrategy *tokenEmptyStrategy= [[FBSessionTokenCachingStrategy alloc] init];
            [tokenEmptyStrategy cacheFBAccessTokenData:[[FBAccessTokenData alloc] init]];
            
            appdelegte.fbSession = [[FBSession alloc] initWithAppID:FACEBOOK_APPID permissions:fbpermissions urlSchemeSuffix:nil tokenCacheStrategy:tokenEmptyStrategy];
            [FBSession setActiveSession:appdelegte.fbSession];
            
            
            [FBSession openActiveSessionWithPublishPermissions:fbpermissions defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                
                // Retrieve the app delegate
                LAAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                [appDelegate sessionStateChanged:session state:state error:error];
            }];
            
//            [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView     completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
//             {
//                 if(!error)
//                 {
//                     NSString *token = session.accessTokenData.accessToken;
//                    // NSLog(@"Token is %@",token);
//                     
//                    // NSLog(@"Token is %@",session.permissions);
//                     
//                     
//                     
//                     [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
//                         if (error) {
//                             
//                             //NSLog(@"error:%@",error);
//                             [AppUtil loadMapIntialView];
//                             
//                         }
//                         else
//                         {
//                             LAViewController *root = (LAViewController *)appdelegte.window.rootViewController;
//                             [root saveFacebookUserInfo];
//                             
//                         }
//                     }];
//                     
//                 }
//                 else
//                 {
//                     //NSLog(@"Error is %@",[error description]);
//                     [AppUtil loadMapIntialView];
//                 }
//             }];
        }else{
            appdelegte.ALERT_ACTION_INDICATOR = LOGOUT_FROM_FACEBOOK;
            LAViewController *root = (LAViewController *)appdelegte.window.rootViewController;
            [self openTwoOptionsMsgDialog:@"Alert" withmsg:LOGOUT_FROM_FACEBOOK_MSG withdelegate:root];
        }
        
    }else{
        [appdelegte.window.rootViewController.view makeToast:@"Internet is not available."];
    }
}

+ (void)loginToTwitter{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegte.IS_ONLINE) {
        if (appdelegte.accessToken == nil) {
            LAViewController *root = (LAViewController *)appdelegte.window.rootViewController;
            UIViewController *vc = [root.storyboard instantiateViewControllerWithIdentifier:@"twitterlogin"];
            [root presentModalViewController:vc animated:YES];
        }else{
            appdelegte.ALERT_ACTION_INDICATOR = LOGOUT_FROM_TWITTER;
            LAViewController *root = (LAViewController *)appdelegte.window.rootViewController;
            [self openTwoOptionsMsgDialog:@"Alert" withmsg:LOGOUT_FROM_TWITTER_MSG withdelegate:root];
        }
        
    }else{
        [appdelegte.window.rootViewController.view makeToast:@"Internet is not available."];
    }
}


+ (void) clearMarchantCheckinData{
    
    [AppDatabase deleteAllCheckinDetails];
    
    [AppUtil loadMapIntialView];
    
}

+(NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

+(NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

+ (BOOL) hasUserChangedAddFoodTruckAddress:(NSString *)strAddress{
    BOOL hasChanged = YES;
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (strAddress != nil && appdelegte.addressAddFoodTruck != nil && [[appdelegte.addressAddFoodTruck stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 && [[strAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        
        strAddress = [strAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        strAddress = [[strAddress componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
        strAddress = [strAddress stringByReplacingOccurrencesOfString:@"." withString:@""];
                      
        NSString *strTextAddress = [[[strAddress stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] lowercaseString];
        
        NSString *strGeoCoderAddress = [[appdelegte.addressAddFoodTruck componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                      
         strGeoCoderAddress = [strGeoCoderAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                               
        strGeoCoderAddress = [strGeoCoderAddress stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        strGeoCoderAddress = [[[strGeoCoderAddress stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] lowercaseString];
        
        if ([strTextAddress isEqualToString:strGeoCoderAddress]) {
            hasChanged = NO;
        }
        
    }
    
    return hasChanged;
}

+ (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return ([date compare:firstDate] == NSOrderedDescending || [date compare:firstDate] == NSOrderedSame) &&
    ([date compare:lastDate]  == NSOrderedAscending || [date compare:lastDate]  == NSOrderedSame);
}

+ (void)updateHashTags:(NSString*)strTags withIndicator:(NSInteger)indicator{
    if (strTags != nil && [[strTags stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        HashTagVO *hashTagVO = [AppDatabase getHastagDetails];
        
        if (hashTagVO != nil) {
            switch (indicator) {
                case FACEBOOK_SHARE_ADDFOODTRUCK:{
                    hashTagVO.loggedFacebookUser = [self getfiterHashTags:strTags with:hashTagVO.loggedFacebookUser];
                }
                    break;
                case FACEBOOK_SHARE_CHECKIN:{
                    hashTagVO.loggedFacebookMar = [self getfiterHashTags:strTags with:hashTagVO.loggedFacebookMar];
                }
                    break;
                case TWITTER_SHARE_ADDFOODTRUCK:{
                    hashTagVO.loggedTwitterUser = [self getfiterHashTags:strTags with:hashTagVO.loggedTwitterUser];
                }
                    break;
                case TWITTER_SHARE_CHECKIN:{
                    hashTagVO.loggedTwitterMar = [self getfiterHashTags:strTags with:hashTagVO.loggedTwitterMar];
                }
                    break;
                    
                default:
                    break;
            }
            
            [AppDatabase saveHasTagDetails:hashTagVO];
        }
    }
}

+ (NSString *) getfiterHashTags:(NSString *)userdata with:(NSString *)internaldata{
    NSMutableString * string = [[NSMutableString alloc] init];
    [string appendString:@" "];
    NSMutableOrderedSet *orderset = [[NSMutableOrderedSet alloc] init];
    
    NSArray *splituserdata = [userdata componentsSeparatedByString:@" "];
    NSArray *splitinternaldata = [internaldata componentsSeparatedByString:@" "];
    
    for (int i=0; i<[splituserdata count]; i++) {
        
        NSString *str = [[splituserdata objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        str= [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
        //str= [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        [orderset addObject:[str lowercaseString]];
    }
    
    
    for (int i=0; i<[splitinternaldata count]; i++) {
        
        NSString *str = [[splitinternaldata objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        str= [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
        //str= [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        [orderset addObject:[str lowercaseString]];
    }
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    [orderset enumerateObjectsUsingBlock:^(id obj,NSUInteger index, BOOL *stop){
        [tempArr addObject:obj];
    }];
    
    
    [tempArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        
        return [str1 compare:str2];
    }];
    
    for (int i=0; i<[tempArr count]; i++) {
        NSString *str = [tempArr objectAtIndex:i];
        
        if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) {
            
            [string appendString:[NSString stringWithFormat:@"#%@",str]];
            [string appendString:@" "];
        }
    }
    
    
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


+ (void) loadMapIntialView{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    @synchronized(appdelegte.MAP_INTIAL_LOAD) {
        if ([appdelegte.MAP_INTIAL_LOAD boolValue]) {
            appdelegte.MAP_INTIAL_LOAD = @NO;
            [vc setMapIntialView];
        }
    }

    
}


+ (BOOL) hasUserChangedCheckInAddress:(NSString *)strAddress{
    BOOL hasChanged = YES;
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (strAddress != nil && appdelegte.addressCheckinFoodTruck != nil && [[appdelegte.addressCheckinFoodTruck stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 && [[strAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        
        strAddress = [strAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        strAddress = [[strAddress componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
        strAddress = [strAddress stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        NSString *strTextAddress = [[[strAddress stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] lowercaseString];
        
        NSString *strGeoCoderAddress = [[appdelegte.addressCheckinFoodTruck componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
        
        strGeoCoderAddress = [strGeoCoderAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        strGeoCoderAddress = [strGeoCoderAddress stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        strGeoCoderAddress = [[[strGeoCoderAddress stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] lowercaseString];
        
        if ([strTextAddress isEqualToString:strGeoCoderAddress]) {
            hasChanged = NO;
        }
        
    }
    
    return hasChanged;
}



@end
