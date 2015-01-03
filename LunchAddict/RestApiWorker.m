//
//  RestApiWorker.m
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "RestApiWorker.h"
#import "LAAppDelegate.h"
#import "AppConstants.h"
#import "AppJsonGenerator.h"
#import "AppJsonParser.h"

@implementation RestApiWorker

@synthesize restApiVO;
@synthesize delegate;

- (id)initWithRestAPIVO:(RestAPIVO *)therestApiVO delegate:(id<RestAPIWorkerDelegate>)thedelegate {
    
    if(self = [super init]){
        self.restApiVO   = therestApiVO;
        self.delegate    = thedelegate;
        self.restApiVO.worker = self;
    }
    return self;
    
}




- (void)main{
    
    @autoreleasepool {
        
        LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (!appDelegate.IS_ONLINE) {
            /*We need to implement ui for non internet connection*/
            //NSLog(@"internet connection error---");
            [(NSObject*)self.delegate performSelectorOnMainThread:@selector(internetConnectionError:) withObject:self.restApiVO waitUntilDone:NO];
            return;
        }
        
        if(self.isCancelled)
            return;
        
        if (restApiVO == nil || restApiVO.TAG == nil || restApiVO.REQ_IDENTIFIER < 0 || restApiVO.reqtype == nil || restApiVO.reqUrl == nil || restApiVO.reqDicParamObj == nil) {
            return;
        }
        
        AFHTTPRequestOperationManager *manager = appDelegate.manager;
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        if (REGISTRATION_REQ != restApiVO.REQ_IDENTIFIER) {
            [manager.requestSerializer setValue:appDelegate.userid forHTTPHeaderField:REQ_HEADER_USERID];
            [manager.requestSerializer setValue:appDelegate.deviceid forHTTPHeaderField:REQ_HEADER_DEVICEID];
        }
        
        
        if ([POST_REQ isEqualToString:restApiVO.reqtype]) {
            [manager POST:restApiVO.reqUrl parameters:restApiVO.reqDicParamObj success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"JSON: %@", [NSString stringWithUTF8String:[responseObject bytes]]);
                
                self.restApiVO.response = [AppJsonParser getResponseObj:self.restApiVO withData:(NSData *)responseObject];
                
                [(NSObject*)self.delegate performSelectorOnMainThread:@selector(successcallback:) withObject:self.restApiVO waitUntilDone:NO];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //NSLog(@"Error: %@", error);
                self.restApiVO.error    = error;
                [(NSObject*)self.delegate performSelectorOnMainThread:@selector(failurecallback:) withObject:self.restApiVO waitUntilDone:NO];
            }];
            
            
            
        }else if([GET_REQ isEqualToString:restApiVO.reqtype]){
            [manager GET:restApiVO.reqUrl parameters:restApiVO.reqDicParamObj success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"JSON: %@", [NSString stringWithUTF8String:[responseObject bytes]]);
                
                self.restApiVO.response = [AppJsonParser getResponseObj:self.restApiVO withData:(NSData *)responseObject];
                
                [(NSObject*)self.delegate performSelectorOnMainThread:@selector(successcallback:) withObject:self.restApiVO waitUntilDone:NO];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //NSLog(@"Error: %@", error);
                self.restApiVO.error    = error;
                [(NSObject*)self.delegate performSelectorOnMainThread:@selector(failurecallback:) withObject:self.restApiVO waitUntilDone:NO];
            }];
        }
        
        
    }
}



@end
