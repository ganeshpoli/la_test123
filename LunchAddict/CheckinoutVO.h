//
//  CheckinoutVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckinoutVO : NSObject

@property(strong,nonatomic) NSString *checkid;
@property(strong,nonatomic) NSString *checkin;
@property(strong,nonatomic) NSString *at;
@property(strong,nonatomic) NSString *on;
@property(strong,nonatomic) NSString *from;
@property(strong,nonatomic) NSString *until;
@property(strong,nonatomic) NSString *suggfrom;
@property(strong,nonatomic) NSString *sugguntil;
@property(strong,nonatomic) NSString *createddate;
@property(strong,nonatomic) NSString *updatedate;
@property(strong,nonatomic) NSString *locationid;
@property(strong,nonatomic) NSString *lat;
@property(strong,nonatomic) NSString *lng;
@property(strong,nonatomic) NSString *partiaAddress;


@end
