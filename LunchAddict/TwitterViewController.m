//
//  TwitterViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 20/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "TwitterViewController.h"
#import "AppConstants.h"
#import "AppMsg.h"
#import "LAViewController.h"
#import "AppUtil.h"

@interface TwitterViewController ()

@end

@implementation TwitterViewController
@synthesize webview;
@synthesize requestToken;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    self.webview.delegate = self;
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        
         NSRange domainRange = [[[cookie domain] lowercaseString] rangeOfString:[@"twitter.com" lowercaseString]];
        
        if (domainRange.location != NSNotFound) {
            [storage deleteCookie:cookie];
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = LOADING_MSG;
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSURL* requestTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:requestTokenUrl
                                                                               consumer:appdelegte.consumer
                                                                                  token:nil
                                                                                  realm:nil
                                                                      signatureProvider:nil];
    OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:TWITTER_CALLBACK];
    [requestTokenRequest setHTTPMethod:@"POST"];
    [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
    OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
    [dataFetcher fetchDataWithRequest:requestTokenRequest
                             delegate:self
                    didFinishSelector:@selector(didReceiveRequestToken:data:)
                      didFailSelector:@selector(didRequestTokenFailOAuth:error:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    if (hud != nil) {
        [hud hide:YES];
    }
    
    [webview loadRequest:authorizeRequest];
}



- (void)didReceiveAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    appdelegte.accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
   // [appdelegte.window.rootViewController.view makeToast:@"User successfully logged into twitter"];
    
    //LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    
    appdelegte.TWITTER_TOKEN_VALIDATION_STATE = TWITTER_TOKEN_LOGIN_VALIDATION;
    
    [self getAccountVerifyCredentials];
    
    //[vc getAccountVerifyCredentials];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
}

- (void)didRequestTokenFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
   // NSLog(@"Twitter oauth error = %@",error.description);
    
    if (hud != nil) {
        [hud hide:YES];
    }
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    [appdelegte.window.rootViewController.view makeToast:@"Sorry, some problem occured with twitter"];
    
    
}

- (void)didFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
    //NSLog(@"Twitter oauth error = %@",error.description);
}


#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = PLEASEWAIT_MSG;
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *temp = [NSString stringWithFormat:@"%@",request];
    
    NSRange textRange = [[temp lowercaseString] rangeOfString:[TWITTER_CALLBACK lowercaseString]];
    NSRange authRange = [[temp lowercaseString] rangeOfString:[@"https://api.twitter.com/oauth/authorize" lowercaseString]];
    NSRange sessionRange = [[temp lowercaseString] rangeOfString:[@"https://twitter.com/intent/sessions" lowercaseString]];
    NSRange errorrange  = [[temp lowercaseString] rangeOfString:[@"https://twitter.com/login/error" lowercaseString]];
    
    if(textRange.location != NSNotFound){
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"oauth_verifier"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
            OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:appdelegte.consumer token:requestToken realm:nil signatureProvider:nil];
            OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
            [accessTokenRequest setHTTPMethod:@"POST"];
            [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
            OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
            [dataFetcher fetchDataWithRequest:accessTokenRequest
                                     delegate:self
                            didFinishSelector:@selector(didReceiveAccessToken:data:)
                              didFailSelector:@selector(didFailOAuth:error:)];
            
            [self.webview setHidden:YES];
            
        } else {
            //NSLog(@"Twitter oauth error");
        }
        
        
        
        return YES;
    }else if(authRange.location != NSNotFound){
        return YES;
    }else if(sessionRange.location != NSNotFound){
        return YES;
    }else if(errorrange.location != NSNotFound){
        NSString* operation = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"redirect_after_login"]) {
                operation = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        NSRange cancelrange  = [[temp lowercaseString] rangeOfString:[@"cancel" lowercaseString]];
        if (cancelrange.location != NSNotFound) {
            LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
            [appdelegte.window.rootViewController.view makeToast:@"Twitter login cancel"];
        }
        
        
    }
    
    return NO;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    
   //NSLog(@"%@",error);
    if(hud != nil){
        [hud hide:YES];
        //hud = nil;
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(hud != nil){
        [hud hide:YES];
        //hud = nil;
    }
    
    
}

-(IBAction)cancelBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [AppUtil loadMapIntialView];
    }];
}

- (void)getAccountVerifyCredentials{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = TWITER_TOKEN_VALIDATING_MSG;
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appdelegte.accessToken != nil) {
        NSURL* verifyCredentialsUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
        
        OAMutableURLRequest* verifyCredentialRequest = [[OAMutableURLRequest alloc] initWithURL:verifyCredentialsUrl
                                                                                       consumer:appdelegte.consumer
                                                                                          token:appdelegte.accessToken
                                                                                          realm:nil
                                                                              signatureProvider:nil];
        
        OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:TWITTER_CALLBACK];
        [verifyCredentialRequest setHTTPMethod:@"GET"];
        [verifyCredentialRequest setParameters:[NSArray arrayWithObject:callbackParam]];
        OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
        [dataFetcher fetchDataWithRequest:verifyCredentialRequest
                                 delegate:self
                        didFinishSelector:@selector(didReceiveVerifyAccessToken:data:)
                          didFailSelector:@selector(didVerifyAccessTokenFailOAuth:error:)];
    }
    
    
}

- (void)didReceiveVerifyAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (hud != nil) {
        [hud hide:YES];
    }
    
    NSError *error=nil;
    NSDictionary *jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    
    if(error){
       // NSLog(@"Json object with data error %@", error);
        
        
    }else{
        if ([[jsonData allKeys] containsObject:@"errors"]) {
            
            [self saveTwitterValidationResponse:nil];
            
        }else{
            
            //[self.view makeToast:@""];
            
            [appdelegte.window.rootViewController.view makeToast:@"User successfully logged into twitter"duration:1.0 position:@"bottom"];
            
            SocialNetworkVO *socialNetworkVO = [[SocialNetworkVO alloc] init];
            socialNetworkVO.username            = [jsonData objectForKey:@"name"];
            socialNetworkVO.userHandler         = [jsonData objectForKey:@"screen_name"];
            socialNetworkVO.accessToken         = appdelegte.accessToken.key;
            socialNetworkVO.accessTokenExpire   = @"";
            socialNetworkVO.providerName        = TWITTER;
            socialNetworkVO.accessTokenSecrete  = appdelegte.accessToken.secret;
            [self saveTwitterValidationResponse:socialNetworkVO];
        }
    }
    
    
}

- (void)didVerifyAccessTokenFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
   // NSLog(@"Twitter oauth error = %@",error.description);
    
    if (hud != nil) {
        [hud hide:YES];
    }
    
    [self saveTwitterValidationResponse:nil];
    
}

-(void)saveTwitterValidationResponse:(SocialNetworkVO *)socialVo{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    if (socialVo != nil) {
        switch (appdelegte.TWITTER_TOKEN_VALIDATION_STATE) {
            case TWITTER_TOKEN_VALIDATION:{
                appdelegte.userVO.twitterLogin = YES;
                appdelegte.userVO.isValidTwitterToken = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
            
            case TWITTER_TOKEN_LOGIN_VALIDATION:{
                [AppDatabase saveSocialNetworkInfo:socialVo isLogin:YES isSessionValid:YES];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [vc logToken:socialVo];
                }];
            }
            break;
        }
    }else{
        switch (appdelegte.TWITTER_TOKEN_VALIDATION_STATE) {
            case TWITTER_TOKEN_VALIDATION:{
                appdelegte.userVO.twitterLogin = YES;
                appdelegte.userVO.isValidTwitterToken = NO;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
            
            case TWITTER_TOKEN_LOGIN_VALIDATION:{
                [AppDatabase saveSocialNetworkInfo:socialVo isLogin:NO isSessionValid:NO];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
    }
    
    
}




@end
