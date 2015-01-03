//
//  AppJsonGenerator.h
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "FdListPostParam.h"
#import "AddFoodTruckVO.h"
#import "FoodTruckVO.h"
#import "SocialNetworkVO.h"
#import "TokenVO.h"

@interface AppJsonGenerator : NSObject
+ (NSMutableDictionary *) getRegistrationPostParam;
+ (NSMutableDictionary *) getFoodTruckListPostParam:(FdListPostParam *)fdPostListParam;
+ (NSMutableDictionary *) getFoodtruckByTwitterHandler:(NSString*)strTwitter;
+ (NSMutableDictionary *) getAddFoodtruckPostParam:(AddFoodTruckVO*)addFdVO;
+ (NSMutableDictionary *) getTweetsPostParam:(FoodTruckVO*)fdVO withSocialProvider:(NSString *)strProvider;
+ (NSMutableDictionary *) getUpdateFoodTruckLocationPostParam:(FoodTruckVO*)fdVO;

+ (NSMutableDictionary *) getFtConfirmationPostParam:(FoodTruckVO *)fdVO withConfirmation:(BOOL)bConfirm;

+ (NSMutableDictionary *) getIsMarchantPostParam:(SocialNetworkVO *)socialNetWorkVO withHandler:(NSString *)strHandler;

+ (NSMutableDictionary *) getLogOutJSONPostParam:(TokenVO *)tokenvo;

+ (NSMutableDictionary *) getTokenStatusJSONPostParam:(TokenVO*) token withHandler:(NSString *)strHandle;

+ (NSMutableDictionary *) getaddUserTokenJSONPostParam:(TokenVO*) token withHandler:(NSInteger )handler;

+ (NSMutableDictionary *) getCheckInJSONPostParam:(FoodTruckVO*)fdVO;

+ (NSMutableDictionary *) getCheckOutJSONPostParam:(FoodTruckVO*)fdVO;

+ (NSMutableDictionary *) getOpenCloseTimeJSONPostParam:(BOOL)isMerchant;

@end
