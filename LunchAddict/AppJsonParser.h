//
//  AppJsonParser.h
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestAPIVO.h"
#import "AppConstants.h"

@interface AppJsonParser : NSObject

+(NSObject *)getResponseObj:(RestAPIVO *)restApiVO withData:(NSData *)data;

@end
