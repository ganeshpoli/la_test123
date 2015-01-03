//
//  TokenVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 21/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenVO : NSObject

@property(strong, nonatomic) NSString *tokenValue;
@property(strong, nonatomic) NSString *status;
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *tokenSecreteValue;
@property(strong, nonatomic) NSString *expire;



@end
