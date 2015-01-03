//
//  SocialNetworkVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 31/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialNetworkVO : NSObject

@property(strong, nonatomic) NSString *providerName;
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *userHandler;
@property(strong, nonatomic) NSString *accessToken;
@property(strong, nonatomic) NSString *accessTokenSecrete;
@property(strong, nonatomic) NSString *accessTokenExpire;

@end
