//
//  LAInitViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LAInitViewController.h"
#import "AppJsonGenerator.h"
#import "LAAppDelegate.h"
#import "AppMsg.h"
#import "AppDatabase.h"
#import "RegistrationVO.h"
#import "ErrorVO.h"
#import "SettingsVO.h"
#import "AppUtil.h"
#import "LAViewController.h"
#import "LAInternetConnErrController.h"


@interface LAInitViewController ()<MZFormSheetBackgroundWindowDelegate>

@end

@implementation LAInitViewController

@synthesize btnTryToConnectNow;
@synthesize viewInternetConn;
@synthesize noConnFailRestApiVO;
@synthesize failureRestApiVO;

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
    
    [viewInternetConn setHidden:YES];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:self.viewInternetConn
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0f
                                      constant:0.0f];
    
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                  constraintWithItem:self.viewInternetConn
                  attribute:NSLayoutAttributeCenterY
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.view
                  attribute:NSLayoutAttributeCenterY
                  multiplier:1.0f
                  constant:0.0f];
    
    [self.view addConstraint:constraint];
    
    
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegte.arrPastAddress   = [AppDatabase loadPastAddress];
    
    [self.viewInternetConn.layer setCornerRadius:10.0f];
    [self.viewInternetConn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.viewInternetConn.layer setBorderWidth:1.5f];
    
    btnTryToConnectNow.layer.cornerRadius = 4;
    btnTryToConnectNow.layer.borderWidth = 1;
    btnTryToConnectNow.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    if ([AppDatabase loadUserid]) {
        [self getAppSettings];
    }else{
        [self startAppRegistering];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnTryToCoonectNowClicked:(id)sender{
    
    if (self.noConnFailRestApiVO != nil) {
        [self.viewInternetConn setHidden:YES];
        
        NSLog(@"no coonection fail url = %@",self.noConnFailRestApiVO.reqUrl);
        
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = NO;
        hud.labelText = PLEASEWAIT_MSG;
        
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:self.noConnFailRestApiVO.TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:self.noConnFailRestApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:self.noConnFailRestApiVO.TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
        }
    }
    
}

-(void)startAppRegistering{
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
    restApiVO.REQ_IDENTIFIER    = REGISTRATION_REQ;
    restApiVO.TAG = REQ_REGISTRATION_TAG;
    restApiVO.reqtype = POST_REQ;
    restApiVO.reqUrl  = REGISTERUSER_URL;
    restApiVO.reqDicParamObj = [AppJsonGenerator getRegistrationPostParam];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    hud.labelText = LOADING_MSG;
    hud.detailsLabelText = REG_MSG;
    
    if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_REGISTRATION_TAG]){
        RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
        [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_REGISTRATION_TAG];
        [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
    }
    
    
    
}


-(void)getAppSettings{
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    RestAPIVO *restApiVO = [[RestAPIVO alloc] init];
    restApiVO.REQ_IDENTIFIER    = SETTINGS_REQ;
    restApiVO.TAG = REQ_SETTINGS_TAG;
    restApiVO.reqtype = GET_REQ;
    restApiVO.reqUrl  = APP_SETTINGS_URL;
    restApiVO.reqDicParamObj = [[NSMutableDictionary alloc] init];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    hud.labelText = LOADING_MSG;
    hud.detailsLabelText = SETT_MSG;
    
    if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_SETTINGS_TAG]){
        RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:restApiVO delegate:self];
        [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:REQ_SETTINGS_TAG];
        [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
    }
    
    
    
}

- (void)successcallback:(RestAPIVO *)restApiVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(hud != nil){
        [hud hide:YES];
    }
    
    if(restApiVO != nil && restApiVO.response != nil){
        [appdelegte.restOpertaion.operationInProgress removeObjectForKey:restApiVO.TAG];
        
        switch (restApiVO.REQ_IDENTIFIER) {
            case REGISTRATION_REQ:{
                if ([restApiVO.response class] == [RegistrationVO class]){
                    
                    RegistrationVO *regVO   = (RegistrationVO *)restApiVO.response;
                    [AppDatabase insertUserId:regVO];
                    
                    appdelegte.userid   = regVO.userid;
                    
                    [self getAppSettings];
                    
                }else if ([restApiVO.response class] == [ErrorVO class]){
                    ErrorVO *errorVo = (ErrorVO *)restApiVO.response;
                    [AppUtil openErrorDialog:errorVo.status withmsg:errorVo.msg withdelegate:self];
                }
            }
                break;
                
            case SETTINGS_REQ:{
                
                if ([restApiVO.response class] == [SettingsVO class]){
                    SettingsVO *settingsVO   = (SettingsVO *)restApiVO.response;
                    appdelegte.settingsVO    = settingsVO;
                    [AppUtil validateTokens];
//                    LAViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
//                    appdelegte.window.rootViewController = mainViewController;
                }else if ([restApiVO.response class] == [ErrorVO class]){
                    ErrorVO *errorVo = (ErrorVO *)restApiVO.response;
                    [AppUtil openErrorDialog:errorVo.status withmsg:errorVo.msg withdelegate:self];
                }
                
            }
                break;
                
            default:
                break;
        }
        
        
        
    }
    
}

- (void)failurecallback:(RestAPIVO *)restApiVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(hud != nil){
        [hud hide:YES];
    }
    
    if(restApiVO != nil){
        [appdelegte.restOpertaion.operationInProgress removeObjectForKey:restApiVO.TAG];
        
        switch (restApiVO.REQ_IDENTIFIER) {
            case REGISTRATION_REQ:{
                [AppUtil openErrorDialog:OPS_MSG withmsg:REG_FAILED_MSG withdelegate:self];
            }
                break;
                
            case SETTINGS_REQ:{
                self.failureRestApiVO = restApiVO;
                [self openLunchAddictServerDialog];
            }
                break;
                
            default:
                break;
        }
    }
    
    
}

- (void)internetConnectionError:(RestAPIVO *)restApiVO{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(hud != nil){
        [hud hide:YES];
    }
    
    //[self.view makeToast:@"internet connection is not avaliable"];
    
    
    if(restApiVO != nil){
        [appdelegte.restOpertaion.operationInProgress removeObjectForKey:restApiVO.TAG];
        
        [self.viewInternetConn setHidden:NO];
        
        self.noConnFailRestApiVO = restApiVO;
        

    }
}

- (void)validateTwitterUserCredentials{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
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
        NSLog(@"Json object with data error %@", error);
        
        
    }else{
        if ([[jsonData allKeys] containsObject:@"errors"]) {
            
            [self saveTwitterValidationResponse:nil];
            
        }else{
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
    NSLog(@"Twitter oauth error = %@",error.description);
    
    if (hud != nil) {
        [hud hide:YES];
    }
    
    [self saveTwitterValidationResponse:nil];
    
}

-(void)saveTwitterValidationResponse:(SocialNetworkVO *)socialVo{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (socialVo != nil) {
        switch (appdelegte.TWITTER_TOKEN_VALIDATION_STATE) {
            case TWITTER_TOKEN_VALIDATION:{
                appdelegte.userVO.twitterLogin = YES;
                appdelegte.userVO.isValidTwitterToken = YES;
            }
            break;           
        }
    }else{
        switch (appdelegte.TWITTER_TOKEN_VALIDATION_STATE) {
            case TWITTER_TOKEN_VALIDATION:{
                appdelegte.userVO.twitterLogin = YES;
                appdelegte.userVO.isValidTwitterToken = NO;
            }
            break;
            
            case TWITTER_TOKEN_LOGIN_VALIDATION:{
                [AppDatabase saveSocialNetworkInfo:socialVo isLogin:NO isSessionValid:NO];
            }
            break;
        }
    }
    
    LAViewController *mainViewController = [appdelegte.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"main"];
    appdelegte.window.rootViewController = mainViewController;
    
}

-(void)openLunchAddictServerDialog{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"serverconnerror"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 250);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[LAInternetConnErrController class]]) {
            LAInternetConnErrController *lainternetvc = (LAInternetConnErrController *)navController.topViewController;
            
            lainternetvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        LAInternetConnErrController *lainternetvc = (LAInternetConnErrController *)navController.topViewController;
        lainternetvc.title               = @"Sorry";
    };
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

#pragma mark - mail compose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            [self.view makeToast:@"Mail cancelled"];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            [self.view makeToast:@"Mail saved"];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            [self.view makeToast:@"Mail sent"];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            [self.view makeToast:@"Mail sent failure"];
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void) sendMailTo:(NSString *)strEmailID withEmailSubject:(NSString *)strEmailSubject withMessageBody:(NSString *)strMsg{
    if (strMsg != nil && strEmailSubject != nil && strEmailID != nil) {
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        NSArray *reciptents = @[strEmailID];
        [mailComposer setToRecipients:reciptents];
        [mailComposer setSubject:strEmailSubject];
        [mailComposer setMessageBody:strMsg isHTML:NO];
        [self presentModalViewController:mailComposer animated:YES];
    }
    
}

-(void)trytoReconnect{
    
    if (self.failureRestApiVO != nil) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = PLEASEWAIT_MSG;
        if(![[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:self.failureRestApiVO.TAG]){
            RestApiWorker *restApiWorker = [[RestApiWorker alloc] initWithRestAPIVO:self.failureRestApiVO delegate:self];
            [appdelegte.restOpertaion.operationInProgress setObject:restApiWorker forKey:self.failureRestApiVO.TAG];
            [appdelegte.restOpertaion.operationQueue addOperation:restApiWorker];
            
        }
    }
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
