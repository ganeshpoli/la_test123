//
//  ServiceWorker.m
//  LunchAddict
//
//  Created by SPEROWARE on 22/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "ServiceWorker.h"
#import "LAAppDelegate.h"
#import "RestAPIConsts.h"
#import "AppJsonGenerator.h"
#import "AppJsonParser.h"
#import "RestAPIVO.h"


@implementation ServiceWorker

@synthesize serviceWorkerdelegate;
@synthesize tokenCacheVO;

- (id)initWithTokenCacheVO:(TokenCacheVO *)theTokenCacheVO delegate:(id<ServiceWorkerDelegate>)thedelegate{
    
    if(self = [super init]){
        self.tokenCacheVO   = theTokenCacheVO;
        self.serviceWorkerdelegate    = thedelegate;
    }
    return self;
}

- (void)main{
    
    @autoreleasepool {
        
        LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (!appDelegate.IS_ONLINE) {
            return;
        }
        
        if(self.isCancelled)
        return;
        
        if (self.tokenCacheVO == nil) {
            return;
        }
        
        AFHTTPRequestOperationManager *manager = appDelegate.manager;
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager.requestSerializer setValue:appDelegate.userid forHTTPHeaderField:REQ_HEADER_USERID];
        [manager.requestSerializer setValue:appDelegate.deviceid forHTTPHeaderField:REQ_HEADER_DEVICEID];

        
        TokenVO *tokenVO = [[TokenVO alloc] init];
        tokenVO.tokenValue = self.tokenCacheVO.accesstoken;
        
        NSDictionary *reqDicParamObj = [AppJsonGenerator getTokenStatusJSONPostParam:tokenVO  withHandler:self.tokenCacheVO.providername];
        
        [manager POST:LOGIN_TOKEN_STATUS_URL parameters:reqDicParamObj success:^(AFHTTPRequestOperation *operation, id responseObject) {
               // NSLog(@"JSON: %@", [NSString stringWithUTF8String:[responseObject bytes]]);
            RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
            restApiVO.REQ_IDENTIFIER = APP_TOKEN_STATUS_REQ;
            
                NSObject *obj = [AppJsonParser getResponseObj:restApiVO withData:(NSData *)responseObject];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:obj forKey:@"Response"];
            [dic setObject:self.tokenCacheVO forKey:@"TokenCache"];
            
            
            
            if (self.isCancelled) {
                return ;
            }
            
                [(NSObject*)self.serviceWorkerdelegate performSelectorOnMainThread:@selector(serviceWorkercallback:) withObject:dic waitUntilDone:NO];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               // NSLog(@"Error: %@", error);
                
            }];
        
    }
}





@end
