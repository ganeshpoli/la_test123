//
//  AppUtil.h
//  LunchAddict
//
//  Created by SPEROWARE on 30/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LAAppDelegate.h"
#import "RestAPIVO.h"
#import "RestAPIConsts.h"
#import "RestApiWorker.h"
#import "FdListPostParam.h"
#import "AppJsonGenerator.h"
#import "MBProgressHUD.h"
#import "AddFoodTruckVO.h"
#import <CommonCrypto/CommonDigest.h>
#import "CheckinoutVO.h"


@interface AppUtil : NSObject<UIAlertViewDelegate>

+ (UIImage *)getFoodTruckStatusIcon:(NSString *)stricon;

+ (NSString*)md5HexDigest:(NSString*)input;

+ (void)openErrorDialog:(NSString*)strTitle withmsg:(NSString *)strMsg withdelegate:(id)delegate;

+ (void)getFoodTrucks:(FdListPostParam *)fdListPostParam withDelegate:(id)delegate;

+ (double) getDistanceInMetersBetWeenLocation1:(CLLocationCoordinate2D)coord1 withLocation2:(CLLocationCoordinate2D)coord2;

+ (void)getFoodTruckDetailsByTwitterHandler:(NSString *)strTwitter withDelegate:(id)delegate;

+ (void)openMsgDialog:(NSString*)strTitle withmsg:(NSString *)strMsg withdelegate:(id)delegate;

+ (NSComparisonResult)compareDateOnly:(NSDate *)otherDate;

+ (NSString *)getTwitterDateString:(NSString *)strDate;

+ (NSString *)getFacebookDateString:(NSString *)strDate;

+ (void)openRefreshMsgDialog:(NSString*)strTitle withmsg:(NSString *)strMsg withdelegate:(id)delegate;

+ (void)addFoodTruckToHistoryRecord:(FoodTruckVO *)foodTruckVO;

+ (void)openFaceBookShareDialog;

+ (BOOL)isFacebookSessionValid;

+ (NSString *) md5:(NSString *) input;

+ (void) validateTokens;

+ (void) clearTwitterSession;

+ (void) clearMerchantData;

+ (void) clearFBSession;

+ (void) loginToFacebook;

+ (void) loginToTwitter;

+ (void)openTwoOptionsMsgDialog:(NSString*)strTitle withmsg:(NSString *)strMsg withdelegate:(id)delegate;

+ (void) clearMarchantCheckinData;

+ (BOOL) hasUserChangedAddFoodTruckAddress:(NSString *)strAddress;

+ (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate;

+ (NSString *) getfiterHashTags:(NSString *)userdata with:(NSString *)internaldata;

+ (void)updateHashTags:(NSString*)strTags withIndicator:(NSInteger)indicator;

+ (void)postMsgOnFacebookWall:(NSDictionary *)params withIndicator:(NSNumber *)indicator;

+ (void) loadMapIntialView;

+ (BOOL) hasUserChangedCheckInAddress:(NSString *)strAddress;



@end
