//
//  ServiceOperation.m
//  LunchAddict
//
//  Created by SPEROWARE on 22/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "ServiceOperation.h"

@implementation ServiceOperation

@synthesize serviceOperationQueue      = _serviceOperationQueue;

- (NSOperationQueue *)serviceOperationQueue {
    if (!_serviceOperationQueue) {
        _serviceOperationQueue = [[NSOperationQueue alloc] init];
        _serviceOperationQueue.name = @"service operation Queue";
        _serviceOperationQueue.maxConcurrentOperationCount = 1;
    }
    return _serviceOperationQueue;
}

@end
