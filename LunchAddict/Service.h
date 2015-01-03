//
//  Service.h
//  LunchAddict
//
//  Created by SPEROWARE on 21/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenCacheVO.h"
#import "ServiceWorker.h"
#import "ServiceOperation.h"

@protocol ServiceDelegate;
@interface Service : NSObject<ServiceWorkerDelegate>

@property(assign, nonatomic) BOOL IS_SERVICE_RUNNING;
@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) NSNumber *count;

@property(strong, nonatomic) ServiceOperation *serviceOpration;

@property(weak, nonatomic) id<ServiceDelegate> servicedelegate;



- (id)initWithdelegate:(id<ServiceDelegate>)thedelegate;

- (void)stopService;

-(void) bindService;

-(void) validateTokensWithServer:(id)obj;



@end

@protocol ServiceDelegate <NSObject>

- (void) tokenStatuscallback:(NSMutableDictionary *)dicResponse;


@end
