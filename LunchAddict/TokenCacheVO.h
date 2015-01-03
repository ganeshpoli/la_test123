//
//  TokenCacheVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 21/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenCacheVO : NSObject

@property(strong,nonatomic) NSString *providername;
@property(strong,nonatomic) NSString *username;
@property(strong,nonatomic) NSString *accesstoken;
@property(strong,nonatomic) NSString *numofattempts;
@property(strong,nonatomic) NSString *maxlimit;
@property(strong,nonatomic) NSString *isvalid;
@property(strong,nonatomic) NSString *createddate;
@property(strong,nonatomic) NSString *updatedate;


@end
