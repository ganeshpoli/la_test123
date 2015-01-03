//
//  RestOperation.m
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "RestOperation.h"

@implementation RestOperation

@synthesize operationInProgress = _operationInProgress;
@synthesize operationQueue      = _operationQueue;

- (NSMutableDictionary *)operationInProgress {
    if (!_operationInProgress) {
        _operationInProgress = [[NSMutableDictionary alloc] init];
    }
    return _operationInProgress;
}


- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.name = @"operation Queue";
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}


@end
