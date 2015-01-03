//
//  RestOperation.h
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestOperation : NSObject

@property (nonatomic, strong) NSMutableDictionary *operationInProgress;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end
