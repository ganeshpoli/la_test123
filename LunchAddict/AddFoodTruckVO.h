//
//  AddFoodTruckVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 03/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddFoodTruckVO : NSObject

@property(strong, nonatomic) NSString *timeZone;
@property(strong, nonatomic) NSString *fdName;
@property(strong, nonatomic) NSString *address;
@property(strong, nonatomic) NSString *lat;
@property(strong, nonatomic) NSString *lng;
@property(strong, nonatomic) NSString *positiveConfirm	;
@property(strong, nonatomic) NSString *twitterHandler;
@property(strong, nonatomic) NSString *facebookAddress;
@property(strong, nonatomic) NSString *website;
@property(strong, nonatomic) NSString *description ;
@property(strong, nonatomic) NSString *icon ;
@property(strong, nonatomic) NSString *opendate;
@property(strong, nonatomic) NSString *closedate;
@property(strong, nonatomic) NSString *deviceID;
@property(strong, nonatomic) NSString *createddate;
@property(strong, nonatomic) NSString *isMerchant;
@property(strong, nonatomic) NSString *partialAddress;

@end
