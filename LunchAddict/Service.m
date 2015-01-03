//
//  Service.m
//  LunchAddict
//
//  Created by SPEROWARE on 21/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "Service.h"
#import "LAViewController.h"
#import "LAAppDelegate.h"
#import "AppConstants.h"
#import "AppDatabase.h"
#import "AppUtil.h"


@implementation Service

@synthesize timer;
@synthesize IS_SERVICE_RUNNING;
@synthesize count;
@synthesize servicedelegate;
@synthesize serviceOpration;


- (id)initWithdelegate:(id<ServiceDelegate>)thedelegate{
    if(self = [super init]){
        self.servicedelegate    = thedelegate;
        self.serviceOpration    = [[ServiceOperation alloc] init];
    }
    return self;
}


-(void) bindService{
    
    
    
    self.IS_SERVICE_RUNNING = YES;
    if (self.timer == nil) {
        
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:SERVICE_TIME_INTERVAL target:self selector:@selector(validateTokensWithServer:) userInfo:nil repeats:YES];
    }
    
   // NSLog(@"Service is started");
    
}

-(void) stopService{
    self.IS_SERVICE_RUNNING = NO;
    
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.serviceOpration.serviceOperationQueue cancelAllOperations];
    
   // NSLog(@"Service is stopped");
    
}

-(void) validateTokensWithServer:(id)obj{
    NSMutableArray *listTokens  = [AppDatabase getListOfTokenCaches];
    if (listTokens != nil && [listTokens count] > 0) {
        for (id obj in listTokens) {
            TokenCacheVO *tokenCacheVO = (TokenCacheVO *)obj;
            NSInteger numAttempts = [tokenCacheVO.numofattempts integerValue];
            tokenCacheVO.numofattempts = [NSString stringWithFormat:@"%d", (numAttempts+1)];
            ServiceWorker *serviceWorker = [[ServiceWorker alloc] initWithTokenCacheVO:tokenCacheVO  delegate:self];
            [self.serviceOpration.serviceOperationQueue addOperation:serviceWorker];
        }
        
    }else{
        [self stopService];
    }
    
}

- (void)serviceWorkercallback:(NSMutableDictionary *)dicResponse{
    if([self.servicedelegate conformsToProtocol:@protocol(ServiceDelegate)]) {
        [self.servicedelegate tokenStatuscallback:dicResponse];
	}
}



@end
