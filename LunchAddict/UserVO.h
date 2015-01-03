//
//  UserVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 31/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserVO : NSObject

@property(assign, nonatomic) BOOL isMarchant;
@property(strong, nonatomic) NSString *twitterName;
@property(strong, nonatomic) NSString *twitterHanbler;
@property(strong, nonatomic) NSString *facebookName;
@property(strong, nonatomic) NSString *facebookHandler;
@property(strong, nonatomic) NSString *facebookAccessToken;
@property(strong, nonatomic) NSString *faceboolAccessTokenExpire;
@property(strong, nonatomic) NSString *twitterAccessToken;
@property(strong, nonatomic) NSString *twitterAccessTokenScrete;
@property(assign, nonatomic) BOOL isValidFbToken;
@property(assign, nonatomic) BOOL isValidTwitterToken;
@property(assign, nonatomic) BOOL twitterLogin;
@property(assign, nonatomic) BOOL facebookLogin;
@property(strong, nonatomic) NSString *foodtruckname;
@property(strong, nonatomic) NSString *foodtruckid;
@property(strong, nonatomic) NSString *foodtruckLocationId;




@end
