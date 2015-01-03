//
//  ServiceWorker.h
//  LunchAddict
//
//  Created by SPEROWARE on 22/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenCacheVO.h"
#import "TokenVO.h"

@protocol ServiceWorkerDelegate;
@interface ServiceWorker : NSOperation

@property(strong, nonatomic) TokenCacheVO *tokenCacheVO;

@property(weak, nonatomic) id<ServiceWorkerDelegate> serviceWorkerdelegate;

- (id)initWithTokenCacheVO:(TokenCacheVO *)theTokenCacheVO delegate:(id<ServiceWorkerDelegate>)thedelegate;


@end

@protocol ServiceWorkerDelegate <NSObject>
- (void) serviceWorkercallback:(NSMutableDictionary *)dicResponse;
@end
