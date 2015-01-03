//
//  AppJsonParser.m
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "AppJsonParser.h"
#import "ResMsgVO.h"
#import "ErrorVO.h"
#import "AppJsonConst.h"
#import "RegistrationVO.h"
#import "SettingsVO.h"
#import "LAAppDelegate.h"
#import "TweetVO.h"
#import "TokenVO.h"


@implementation AppJsonParser

+(NSObject *)getResponseObj:(RestAPIVO *)restApiVO withData:(NSData *)data{
    
    NSObject *obj           = nil;
    NSError *error          = nil;
    ResMsgVO *resMsgVO      = nil;
    ErrorVO *errorVO        = nil;
    
    NSDictionary *jsonRes  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    
    if(error){
        //NSLog(@"Json object with data error %@", error);
        return  nil;
    }
    
    NSString *strstatus = [jsonRes objectForKey:STATUS];
    if ([SUCCESS isEqualToString:strstatus]) {
        
        if (restApiVO.REQ_IDENTIFIER != CHECK_IN_REQ && [[jsonRes allKeys] containsObject:MESSAGE]){
            resMsgVO = [[ResMsgVO alloc] init];
            resMsgVO.status = strstatus;
            resMsgVO.msg    = [jsonRes objectForKey:MESSAGE];
        }else if ([[jsonRes allKeys] containsObject:DATA]) {
            NSString *strData   = [jsonRes objectForKey:DATA];
            NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
            NSError *dataerror          = nil;
            NSDictionary *jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &dataerror];
            
            if (dataerror) {
                //NSLog(@"Json object with data error %@", error);
                return nil;
            }
            
            switch (restApiVO.REQ_IDENTIFIER) {
                case REGISTRATION_REQ:{
                    RegistrationVO *regVO   = [[RegistrationVO alloc] init];
                    regVO.userid            = [jsonData objectForKey:FD_ID];
                    regVO.email             = [jsonData objectForKey:EMAIL]== (id)[NSNull null]?@"":[jsonData objectForKey:EMAIL];
                    regVO.name              = [jsonData objectForKey:NAME]== (id)[NSNull null]?@"":[jsonData objectForKey:NAME];
                    regVO.deviceid          = [jsonData objectForKey:DEVICE_ID]== (id)[NSNull null]?@"":[jsonData objectForKey:DEVICE_ID];
                    obj                     = regVO;
                    
                }
                    break;
                    
                case SETTINGS_REQ:{
                    SettingsVO *settingsVO  = [[SettingsVO alloc] init];
                    settingsVO.zoomLevel    = [[jsonData objectForKey:SETTINGS_ZOOM_LEVEL] floatValue];
                    settingsVO.lat          = [[jsonData objectForKey:SETTINGS_LATITUDE] doubleValue];
                    settingsVO.lng          = [[jsonData objectForKey:SETTINGS_LONGITUDE] doubleValue];
                    settingsVO.longrefreshlimit         = [[jsonData objectForKey:LONG_REFRESH_LIMIT] integerValue];
                    settingsVO.popupappearseconds       = [[jsonData objectForKey:CONFURMATION_APPEAR] longValue];
                    settingsVO.popupdisappearseconds    = [[jsonData objectForKey:CONFURMATION_DISAPPEAR] longValue];
                    settingsVO.loginvalidationcount     = [[jsonData objectForKey:LOGIN_VALIDATION_COUNT] integerValue];
                    settingsVO.minimumdistance          = [[jsonData objectForKey:MIN_DISTANCE] integerValue];
                    settingsVO.maxdistance              = [[jsonData objectForKey:MAX_DISTANCE] integerValue];
                    settingsVO.beforelogin              = [[jsonData objectForKey:USER_BEFORE_LOGIN] integerValue];
                    settingsVO.afterlogin               = [[jsonData objectForKey:USER_AFTER_LOGIN] integerValue];
                    settingsVO.ftaddedbymerchanticon    = [jsonData objectForKey:FT_ADDED_BY_MERCHANT_ICON];
                    settingsVO.ftaddedbyconsumericon    = [jsonData objectForKey:FT_ADDED_BY_CONSUMER_ICON];
                    settingsVO.ftlistmaxlimit           = [[jsonData objectForKey:FT_LIST_MAX_LIMIT] integerValue];
                    obj                                 = settingsVO;
                }
                    break;
                    
                case FOODTRUCK_LIST_REQ:{
                    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
                    appdelegte.RES_SEARCH_DISTANCE  = [[jsonData objectForKey:SEARCH_DISTANCE] integerValue]*ONE_MILE_IN_METERS;
                    NSArray *jsonArray  = [jsonData objectForKey:LIST];
                    NSMutableArray *listFoodTrucks   = [[NSMutableArray alloc] init];
                    
                    for (id obj in jsonArray) {
                        NSDictionary *recordObj       = obj;
                        FoodTruckVO *foodTruckVO      = [[FoodTruckVO alloc] init];
                        foodTruckVO.locationid        = [recordObj objectForKey:LOCATION_ID]== (id)[NSNull null]?@"":[recordObj objectForKey:LOCATION_ID];
                        foodTruckVO.foodtruckid       = [recordObj objectForKey:FOOD_TRUCK_ID]== (id)[NSNull null]?@"":[recordObj objectForKey:FOOD_TRUCK_ID];
                        foodTruckVO.name              = [recordObj objectForKey:NAME]== (id)[NSNull null]?@"":[recordObj objectForKey:NAME];
                        foodTruckVO.description       = [recordObj objectForKey:DESCRIPTION]== (id)[NSNull null]?@"":[recordObj objectForKey:DESCRIPTION];
                        foodTruckVO.extraDescription  = [recordObj objectForKey:EXT_DESCRIPTION]== (id)[NSNull null]?@"":[recordObj objectForKey:EXT_DESCRIPTION];
                        foodTruckVO.twitterHandle     = [recordObj objectForKey:TWITTER_HANDLER]== (id)[NSNull null]?@"":[recordObj objectForKey:TWITTER_HANDLER];
                        foodTruckVO.twitterName       = [recordObj objectForKey:TWITTER_NAME]== (id)[NSNull null]?@"":[recordObj objectForKey:TWITTER_NAME];
                        foodTruckVO.facebookAddress   = [recordObj objectForKey:FACEBOOK_ADDRESS]== (id)[NSNull null]?@"":[recordObj objectForKey:FACEBOOK_ADDRESS];
                        foodTruckVO.instagramUserName = [recordObj objectForKey:INSTAGRAM_USERNAME]== (id)[NSNull null]?@"":[recordObj objectForKey:INSTAGRAM_USERNAME];
                        foodTruckVO.yelpAddress       = [recordObj objectForKey:YELP_ADDRESS]== (id)[NSNull null]?@"":[recordObj objectForKey:YELP_ADDRESS];
                        foodTruckVO.cousineText       = [recordObj objectForKey:COUSINE_TEXT]== (id)[NSNull null]?@"":[recordObj objectForKey:COUSINE_TEXT];
                        foodTruckVO.lat               = [recordObj objectForKey:LATITUDE]== (id)[NSNull null]?@"":[recordObj objectForKey:LATITUDE];
                        foodTruckVO.lng               = [recordObj objectForKey:LONGITUDE]== (id)[NSNull null]?@"":[recordObj objectForKey:LONGITUDE];
                        foodTruckVO.website           = [recordObj objectForKey:WEBSITE]== (id)[NSNull null]?@"":[recordObj objectForKey:WEBSITE];
                        foodTruckVO.distance          = [recordObj objectForKey:DISTANCE]== (id)[NSNull null]?@"":[recordObj objectForKey:DISTANCE];
                        foodTruckVO.status            = [recordObj objectForKey:STATUS]== (id)[NSNull null]?@"":[recordObj objectForKey:STATUS];
                        foodTruckVO.emailAddress      = [recordObj objectForKey:EMAIL_ADDRESS]== (id)[NSNull null]?@"":[recordObj objectForKey:EMAIL_ADDRESS];
                        foodTruckVO.phoneNum          = [recordObj objectForKey:PHONE_NUM]== (id)[NSNull null]?@"":[recordObj objectForKey:PHONE_NUM];
                        foodTruckVO.openDate          = [recordObj objectForKey:OPEN_DATE]== (id)[NSNull null]?@"":[recordObj objectForKey:OPEN_DATE];
                        foodTruckVO.closeDate         = [recordObj objectForKey:CLOSE_DATE]== (id)[NSNull null]?@"":[recordObj objectForKey:CLOSE_DATE];
                        foodTruckVO.icon              = [recordObj objectForKey:ICON]== (id)[NSNull null]?@"":[recordObj objectForKey:ICON];
                        foodTruckVO.isMerchant        = [[recordObj objectForKey:IS_MERCHANT] boolValue]?APP_YES:APP_NO;
                        [listFoodTrucks addObject:foodTruckVO];
                    }
                    
                    obj                                 = listFoodTrucks;
                }
                    break;
                
                case CHECK_IN_REQ:
                case OPEN_CLOSE_TIME_REQ:
                case IS_MERCHANT_REQ:
                case APP_FD_BY_TWITTER_REQ:
                case FD_DETAILS_BY_TWITTER_REQ:{
                    FoodTruckVO *foodTruckVO      = [[FoodTruckVO alloc] init];
                    foodTruckVO.locationid        = [jsonData objectForKey:LOCATION_ID]== (id)[NSNull null]?@"":[jsonData objectForKey:LOCATION_ID];
                    foodTruckVO.foodtruckid       = [jsonData objectForKey:FOOD_TRUCK_ID]== (id)[NSNull null]?@"":[jsonData objectForKey:FOOD_TRUCK_ID];
                    foodTruckVO.name              = [jsonData objectForKey:NAME]== (id)[NSNull null]?@"":[jsonData objectForKey:NAME];
                    foodTruckVO.description       = [jsonData objectForKey:DESCRIPTION]== (id)[NSNull null]?@"":[jsonData objectForKey:DESCRIPTION];
                    foodTruckVO.extraDescription  = [jsonData objectForKey:EXT_DESCRIPTION]== (id)[NSNull null]?@"":[jsonData objectForKey:EXT_DESCRIPTION];
                    foodTruckVO.twitterHandle     = [jsonData objectForKey:TWITTER_HANDLER]== (id)[NSNull null]?@"":[jsonData objectForKey:TWITTER_HANDLER];
                    foodTruckVO.twitterName       = [jsonData objectForKey:TWITTER_NAME]== (id)[NSNull null]?@"":[jsonData objectForKey:TWITTER_NAME];
                    foodTruckVO.facebookAddress   = [jsonData objectForKey:FACEBOOK_ADDRESS]== (id)[NSNull null]?@"":[jsonData objectForKey:FACEBOOK_ADDRESS];
                    foodTruckVO.instagramUserName = [jsonData objectForKey:INSTAGRAM_USERNAME]== (id)[NSNull null]?@"":[jsonData objectForKey:INSTAGRAM_USERNAME];
                    foodTruckVO.yelpAddress       = [jsonData objectForKey:YELP_ADDRESS]== (id)[NSNull null]?@"":[jsonData objectForKey:YELP_ADDRESS];
                    foodTruckVO.cousineText       = [jsonData objectForKey:COUSINE_TEXT]== (id)[NSNull null]?@"":[jsonData objectForKey:COUSINE_TEXT];
                    foodTruckVO.lat               = [jsonData objectForKey:LATITUDE]== (id)[NSNull null]?@"":[jsonData objectForKey:LATITUDE];
                    foodTruckVO.lng               = [jsonData objectForKey:LONGITUDE]== (id)[NSNull null]?@"":[jsonData objectForKey:LONGITUDE];
                    foodTruckVO.website           = [jsonData objectForKey:WEBSITE]== (id)[NSNull null]?@"":[jsonData objectForKey:WEBSITE];
                    foodTruckVO.distance          = [jsonData objectForKey:DISTANCE]== (id)[NSNull null]?@"":[jsonData objectForKey:DISTANCE];
                    foodTruckVO.status            = [jsonData objectForKey:STATUS]== (id)[NSNull null]?@"":[jsonData objectForKey:STATUS];
                    foodTruckVO.emailAddress      = [jsonData objectForKey:EMAIL_ADDRESS]== (id)[NSNull null]?@"":[jsonData objectForKey:EMAIL_ADDRESS];
                    foodTruckVO.phoneNum          = [jsonData objectForKey:PHONE_NUM]== (id)[NSNull null]?@"":[jsonData objectForKey:PHONE_NUM];                    
                    foodTruckVO.openDate          = [jsonData objectForKey:OPEN_DATE]== (id)[NSNull null]?@"":[NSString stringWithFormat:@"%@",[jsonData objectForKey:OPEN_DATE]];
                    foodTruckVO.closeDate         = [jsonData objectForKey:CLOSE_DATE]== (id)[NSNull null]?@"":[NSString stringWithFormat:@"%@",[jsonData objectForKey:CLOSE_DATE]];
                    foodTruckVO.icon              = [jsonData objectForKey:ICON]== (id)[NSNull null]?@"":[jsonData objectForKey:ICON];
                    foodTruckVO.isMerchant        = [[jsonData objectForKey:IS_MERCHANT] boolValue]?APP_YES:APP_NO;
                    
                    obj                           = foodTruckVO;
                    
                }
                    break;
                    
                case CACHE_TWEETS_REQ:
                case LIVE_TWEETS_REQ:{
                    NSArray *jsonFacebookArray  = [jsonData objectForKey:JSON_FACEBOOK];
                    NSArray *jsonTwitterArray  = [jsonData objectForKey:JSON_TWITTER];
                    
                    NSMutableDictionary *dic    = [[NSMutableDictionary alloc] init];
                    
                    NSMutableArray *arrTweets = nil;
                    NSMutableArray *arrFBPosts = nil;
                    
                    
                    if (jsonFacebookArray != nil) {
                        arrFBPosts = [[NSMutableArray alloc] init];
                        arrFBPosts = [self addTweets:arrFBPosts ofData:jsonFacebookArray];
                        [dic setObject:arrFBPosts forKey:JSON_FACEBOOK];
                    }
                    
                    if (jsonTwitterArray != nil) {
                        arrTweets = [[NSMutableArray alloc] init];
                        arrTweets = [self addTweets:arrTweets ofData:jsonTwitterArray];
                        [dic setObject:arrTweets forKey:JSON_TWITTER];
                    }
                    
                    obj = dic;
                    
                }
                    
                    break;
                
                case APP_TOKEN_STATUS_REQ:{
                    TokenVO *tokenVO    = [[TokenVO alloc] init];
                    tokenVO.status      = [jsonData objectForKey:TOKEN_STATUS]== (id)[NSNull null]?@"":[jsonData objectForKey:TOKEN_STATUS];
                    
                    obj = tokenVO;
                }
                break;
                    
                default:
                    break;
            }
        }
        
//        else if(restApiVO.REQ_IDENTIFIER==CHECK_OUT_REQ){
//            resMsgVO = [[ResMsgVO alloc] init];
//            resMsgVO.status = @"Success";
//            resMsgVO.msg = @"Checkout successful";
//            
//            obj = resMsgVO;
//        }
        
    }else if ([ERROR isEqualToString:strstatus] || [VALIDATIONERROR isEqualToString:strstatus]){
        errorVO = [[ErrorVO alloc] init];
        errorVO.status          = strstatus;
        NSString *strMsg        = [jsonRes objectForKey:MESSAGE];
        strMsg = [strMsg stringByReplacingOccurrencesOfString:@"{" withString:@""];
        strMsg = [strMsg stringByReplacingOccurrencesOfString:@"}" withString:@""];
        strMsg = [strMsg stringByReplacingOccurrencesOfString:@"[" withString:@""];
        strMsg = [strMsg stringByReplacingOccurrencesOfString:@"]" withString:@""];
        errorVO.msg = [strMsg stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    if (obj == nil) {
        if (errorVO != nil) {
            obj = errorVO;
        }
        
        if (resMsgVO != nil) {
            obj = resMsgVO;
        }
    }
    
    
    return obj;
}








+(NSMutableArray *)addTweets:(NSMutableArray *)array ofData:(NSArray *)jsonArray{
    
    if (array != nil && jsonArray != nil) {
        for (id obj in jsonArray) {
            NSDictionary *recordObj       = obj;
            TweetVO *tweetVO            = [[TweetVO alloc] init];
            
            tweetVO.tweetID             = [recordObj objectForKey:FD_ID]== (id)[NSNull null]?@"":[recordObj objectForKey:FD_ID];
            tweetVO.fromId              = [recordObj objectForKey:TWEET_FROM_ID]== (id)[NSNull null]?@"":[recordObj objectForKey:TWEET_FROM_ID];
            tweetVO.fromName            = [recordObj objectForKey:TWEET_FROM_NAME]== (id)[NSNull null]?@"":[recordObj objectForKey:TWEET_FROM_NAME];
            tweetVO.screenName          = [recordObj objectForKey:TWEET_SCREENNAME]== (id)[NSNull null]?@"":[recordObj objectForKey:TWEET_SCREENNAME];
            tweetVO.createddate         = [recordObj objectForKey:CREATED_DATE]== (id)[NSNull null]?@"":[recordObj objectForKey:CREATED_DATE];
            tweetVO.message             = [recordObj objectForKey:TWEET_MESSAGE]== (id)[NSNull null]?@"":[recordObj objectForKey:TWEET_MESSAGE];
            tweetVO.picture             = [recordObj objectForKey:TWEET_PICTURE]== (id)[NSNull null]?@"":[recordObj objectForKey:TWEET_PICTURE];
            tweetVO.profilePic          = [recordObj objectForKey:TWEET_PROFILEPIC]== (id)[NSNull null]?@"":[recordObj objectForKey:TWEET_PROFILEPIC];
            
            //[[appDelegate.userid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0
            
            if ([recordObj objectForKey:TWEET_RETWEETED] != (id)[NSNull null]) {
                NSString *strRetweeted = [recordObj objectForKey:TWEET_RETWEETED];
                if (strRetweeted !=nil && strRetweeted != NULL &&[[strRetweeted stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
                    NSString *strTemp = [strRetweeted lowercaseString];
                    
                    if ([strTemp isEqualToString:@"true"]) {
                        tweetVO.retweeted = YES;
                    }else{
                        tweetVO.retweeted = NO;
                    }
                    
                }else{
                    tweetVO.retweeted = NO;
                }
                
            }else{
                tweetVO.retweeted = NO;
                //tweetVO.retweeted = YES;
            }
            
            
            
            [array addObject:tweetVO];
        }
    }
    
    return array;
}

@end
