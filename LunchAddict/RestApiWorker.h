//
//  RestApiWorker.h
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestAPIVO.h"


@protocol RestAPIWorkerDelegate;

@interface RestApiWorker : NSOperation

@property(strong, nonatomic) RestAPIVO *restApiVO;

@property(weak, nonatomic) id<RestAPIWorkerDelegate> delegate;

- (id)initWithRestAPIVO:(RestAPIVO *)therestApiVO delegate:(id<RestAPIWorkerDelegate>)thedelegate;

@end


@protocol RestAPIWorkerDelegate <NSObject>

- (void) successcallback:(RestAPIVO*) restApiVO;

- (void) failurecallback:(RestAPIVO*) restApiVO;

- (void) internetConnectionError:(RestAPIVO *)restApiVO;

@end
