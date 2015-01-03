//
//  AppDatabase.h
//  PetApp
//
//  Created by ramu chembeti on 03/04/13.
//  Copyright (c) 2013 ramu chembeti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "RegistrationVO.h"
#import "SocialNetworkVO.h"
#import "FoodTruckVO.h"
#import "FdConfirmVO.h"
#import "TokenCacheVO.h"
#import "CheckinoutVO.h"
#import "HashTagVO.h"

@interface AppDatabase : NSObject

+ (void) createAppDatabaseTables;
+ (NSString *) getDbPath;

+ (void) insertCheckInCheckOutSeedData;
+ (void) insertAddFoodTruckSeedData;
+ (void) insertUserMerchantSeedData;
+ (void) insertUserPastAddressSeedData;
+ (void) insertProviderSeedData;

+ (BOOL) loadUserid;

+ (void) insertUserId:(RegistrationVO *)regVO;

+ (NSMutableArray *) loadPastAddress;

+ (void) updatePastAddress;

+ (void) loadusercredentials;

+ (BOOL) hasAddFoodTruckLimitExceed;

+ (void) finalizeStatements;

+ (void) saveAddFoodTruckCount;

+ (void) saveSocialNetworkInfo:(SocialNetworkVO *)socialNetworkVO isLogin:(BOOL)islogin isSessionValid:(BOOL)isSessionValid;
+ (void) updateMerchantData:(FoodTruckVO *)fdVO;

+ (FdConfirmVO *)getFoodTruckFromLocationCache:(FoodTruckVO *)ifdvo;

+ (void)saveFDConfirmDetails:(FoodTruckVO *)ifdvo withConfirmation:(NSString *)strConfirm;

+ (void) insertTokenIntoTokenCache:(TokenCacheVO *)tokenCacheVO;
+ (void) updateTokenIntoTokenCache:(TokenCacheVO *)tokenCacheVO;
+ (void) deleteTokenIntoTokenCache:(TokenCacheVO *)tokenCacheVO;
+ (NSMutableArray *)getListOfTokenCaches;

+ (void)saveCheckinDetails:(CheckinoutVO *)checkVO;

+ (void)saveHasTagDetails:(HashTagVO *)hashTagVO;

+(void) deleteAllCheckinDetails;

+(void) deleteCheckinDetails:(NSString *)strID;

+ (CheckinoutVO*) getCheckOutDetails;

+ (void) insertHashTagSeedData;

+ (BOOL) checkColumnExists:(NSString *)strColumname inTable:(NSString *)strTableName;

+ (HashTagVO *)getHastagDetails;

+ (FoodTruckVO *)getMerchantFoodTruckVO;

+ (NSMutableArray *) loadRecentFoodTrucks;

+ (void) deleteRecentFooTruckDetails:(NSString *)locationid withFoodTruckID:(NSString *)foodtruckid;

+ (void) insertRecentFoodTruckDetails:(FoodTruckVO *)foodtruckVO;

@end
