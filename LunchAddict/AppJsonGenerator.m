//
//  AppJsonGenerator.m
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "AppJsonGenerator.h"
#import "LAAppDelegate.h"
#import "AppJsonConst.h"
#import "AppUtil.h"
#import "AppConstants.h"

@implementation AppJsonGenerator

+ (NSMutableDictionary *) getRegistrationPostParam{
    
    LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:appDelegate.deviceid forKey:DEVICE_ID];
    
    return  dictionary;
}

+ (NSMutableDictionary *) getFoodTruckListPostParam:(FdListPostParam *)fdPostListParam{    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:fdPostListParam.lat forKey:LATITUDE];
    [dictionary setObject:fdPostListParam.lng forKey:LONGITUDE];
    [dictionary setObject:fdPostListParam.basedOn forKey:BASED_ON];
    [dictionary setObject:fdPostListParam.deviceId forKey:DEVICE_ID];
    [dictionary setObject:fdPostListParam.zoomLevel forKey:ZOOM_LEVEL];
    
    
    return dictionary;
    
}


+ (NSMutableDictionary *) getFoodtruckByTwitterHandler:(NSString*)strTwitter{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:strTwitter forKey:TWITTER_HANDLER];
    return dictionary;
    
}

+ (NSMutableDictionary *) getAddFoodtruckPostParam:(AddFoodTruckVO*)addFdVO{
    
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:addFdVO.lat forKey:LATITUDE];
    [dictionary setObject:addFdVO.lng forKey:LONGITUDE];
    [dictionary setObject:addFdVO.positiveConfirm forKey:POSITIVE_CONFIRM];
    [dictionary setObject:addFdVO.twitterHandler forKey:TWITTER_HANDLER];
    [dictionary setObject:addFdVO.facebookAddress forKey:FACEBOOK_ADDRESS];
    [dictionary setObject:addFdVO.website forKey:WEBSITE];
    [dictionary setObject:addFdVO.description forKey:DESCRIPTION];
    [dictionary setObject:addFdVO.isMerchant forKey:IS_MERCHANT];
    [dictionary setObject:addFdVO.deviceID forKey:DEVICE_ID];
    [dictionary setObject:addFdVO.fdName forKey:FT_NAME];
    [dictionary setObject:@"false" forKey:FT_CHECKIN];
    [dictionary setObject:[NSString stringWithFormat:@"%lld",milliseconds] forKey:CREATED_DATE];
    
    return dictionary;
    
}

+ (NSMutableDictionary *) getTweetsPostParam:(FoodTruckVO*)fdVO withSocialProvider:(NSString *)strProvider{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:fdVO.foodtruckid forKey:FOOD_TRUCK_ID];
    [dictionary setObject:strProvider forKey:HANDLER_TYPE];    
    return dictionary;
}



+ (NSMutableDictionary *) getUpdateFoodTruckLocationPostParam:(FoodTruckVO*)fdVO{
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSString stringWithFormat:@"%lld",milliseconds] forKey:CLOSE_DATE];
    [dictionary setObject:fdVO.description forKey:EXT_DESCRIPTION];
    [dictionary setObject:fdVO.locationid forKey:LOCATION_ID];
    [dictionary setObject:[NSString stringWithFormat:@"%f",[fdVO.lat doubleValue]] forKey:LATITUDE];
    [dictionary setObject:[NSString stringWithFormat:@"%f",[fdVO.lng doubleValue]] forKey:LONGITUDE];
    [dictionary setObject:[NSString stringWithFormat:@"%lld",milliseconds] forKey:OPEN_DATE];
    
    
    
    return dictionary;
}



+ (NSMutableDictionary *)getFtConfirmationPostParam:(FoodTruckVO *)fdVO withConfirmation:(BOOL)bConfirm{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:fdVO.foodtruckid forKey:FOOD_TRUCK_ID];
    [dictionary setObject:fdVO.locationid forKey:LOCATION_ID];
    
    if (bConfirm) {
        [dictionary setObject:@"true" forKey:POSITIVE_CONFIRM];
    }else{
        [dictionary setObject:@"true" forKey:NEGATIVE_CONFIRM];
    }
    
    return dictionary;
}

+ (NSMutableDictionary *) getIsMarchantPostParam:(SocialNetworkVO *)socialNetWorkVO withHandler:(NSString *)strHandler{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:socialNetWorkVO.userHandler forKey:HANDLER];
    [dictionary setObject:strHandler forKey:HANDLER_TYPE];
    
    return dictionary;
}



+ (NSMutableDictionary *) getLogOutJSONPostParam:(TokenVO *)tokenvo{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:tokenvo.tokenValue forKey:TOKEN_VALUE];
    return dictionary;
}



+ (NSMutableDictionary *) getTokenStatusJSONPostParam:(TokenVO*) token withHandler:(NSString *)strHandle{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[AppUtil md5:token.tokenValue] forKey:TOKEN_VALUE];
    [dictionary setObject:strHandle forKey:HANDLER_TYPE];
    return dictionary;
}


+ (NSMutableDictionary *) getaddUserTokenJSONPostParam:(TokenVO*) token withHandler:(NSInteger )handler{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    switch (handler) {
        case FACEBOOK_HANDLER_TYPE:{
            [dictionary setObject:FACEBOOK forKey:TOKEN_TYPE];
            [dictionary setObject:token.expire forKey:EXPIRE];
        }
        
        break;
        
        case TWITTER_HANDLER_TYPE:{
            [dictionary setObject:TWITTER forKey:TOKEN_TYPE];
            [dictionary setObject:token.tokenSecreteValue forKey:TOKEN_SECRET_VALUE];
        }
        break;
        
        default:
        break;
    }
    
    
    [dictionary setObject:token.username forKey:TOKEN_USER_NAME];
    [dictionary setObject:token.tokenValue forKey:TOKEN_VALUE];
    
    
    return dictionary;
}


+ (NSMutableDictionary *) getCheckInJSONPostParam:(FoodTruckVO*)fdVO{
    
    LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:fdVO.lat forKey:LATITUDE];
    [dictionary setObject:fdVO.lng forKey:LONGITUDE];
    [dictionary setObject:@"true" forKey:POSITIVE_CONFIRM];
    [dictionary setObject:fdVO.twitterHandle forKey:TWITTER_HANDLER];
    [dictionary setObject:fdVO.facebookAddress forKey:FACEBOOK_ADDRESS];
    [dictionary setObject:fdVO.website forKey:WEBSITE];
    [dictionary setObject:fdVO.description forKey:DESCRIPTION];
    [dictionary setObject:fdVO.isMerchant forKey:IS_MERCHANT];
    [dictionary setObject:appDelegate.deviceid forKey:DEVICE_ID];
    [dictionary setObject:fdVO.name forKey:FT_NAME];
    [dictionary setObject:[NSString stringWithFormat:@"%lld",milliseconds] forKey:CREATED_DATE];
    [dictionary setObject:fdVO.openDate forKey:OPEN_DATE];
    [dictionary setObject:fdVO.closeDate forKey:CLOSE_DATE];
    [dictionary setObject:@"true" forKey:FT_CHECKIN];
    
    return dictionary;
    
}

//+ (NSMutableDictionary *) getCheckInJSONPostParam:(FoodTruckVO*)fdVO{
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    [dictionary setObject:fdVO.locationid forKey:LOCATION_ID];
//    [dictionary setObject:fdVO.openDate forKey:OPEN_DATE];
//    [dictionary setObject:fdVO.closeDate forKey:CLOSE_DATE];
//    [dictionary setObject:fdVO.lat forKey:LATITUDE];
//    [dictionary setObject:fdVO.lng forKey:LONGITUDE];
//    [dictionary setObject:fdVO.isMerchant forKey:IS_MERCHANT];
//    
//    return dictionary;
//}

+ (NSMutableDictionary *) getCheckOutJSONPostParam:(FoodTruckVO*)fdVO{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:fdVO.locationid forKey:LOCATION_ID];
    [dictionary setObject:fdVO.closeDate forKey:CLOSE_DATE];
    
    return dictionary;
}

+ (NSMutableDictionary *) getOpenCloseTimeJSONPostParam:(BOOL)isMerchant{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *openCloseDateFormate = [[NSDateFormatter alloc] init];
    [openCloseDateFormate setDateFormat:[NSString stringWithFormat:@"%@",OPEN_CLOSE_DATE_FORMATE]];
    
    NSString *strDate = [openCloseDateFormate stringFromDate:[NSDate date]];
    
    if (isMerchant) {
        [dictionary setObject:APP_YES forKey:IS_MERCHANT];
    }else{
        [dictionary setObject:APP_NO forKey:IS_MERCHANT];
    }
    
    [dictionary setObject:strDate forKey:CREATED_DATE];
    
    return dictionary;
}


@end
