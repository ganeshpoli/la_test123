//
//  RestAPIVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RestAPIVO : NSObject

@property(nonatomic, strong) NSString *TAG;
@property(nonatomic, strong) NSString *reqtype;
@property(nonatomic, strong) NSString *reqUrl;
@property(nonatomic, assign) int REQ_IDENTIFIER;
@property(nonatomic, strong) NSObject *response;
@property(nonatomic, strong) NSDictionary *reqDicParamObj;
@property(nonatomic, strong) NSOperation *worker;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, strong) NSObject *reqTagObj;

@end
