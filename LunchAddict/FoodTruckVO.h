//
//  FoodTruckVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 30/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface FoodTruckVO : NSObject

@property(strong,nonatomic) NSNumber *lat;
@property(strong,nonatomic) NSNumber *lng;
@property(strong,nonatomic) NSString *locationid;
@property(strong,nonatomic) NSString *foodtruckid;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *description;
@property(strong,nonatomic) NSString *extraDescription;
@property(strong,nonatomic) NSString *twitterHandle;
@property(strong,nonatomic) NSString *twitterName;
@property(strong,nonatomic) NSString *facebookAddress;
@property(strong,nonatomic) NSString *instagramUserName;
@property(strong,nonatomic) NSString *yelpAddress;
@property(strong,nonatomic) NSString *cousineText;
@property(strong,nonatomic) NSString *website;
@property(strong,nonatomic) NSNumber *distance;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *emailAddress;
@property(strong,nonatomic) NSString *phoneNum;
@property(strong,nonatomic) NSString *openDate;
@property(strong,nonatomic) NSString *closeDate;
@property(strong,nonatomic) NSString *isMerchant;
@property(strong,nonatomic) NSString *icon;
@property(strong,nonatomic) GMSMarker *marker;

@end
