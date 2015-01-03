//
//  LAAddFdViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 03/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LAAddFdViewController.h"
#import "MZFormSheetController.h"
#include "AppConstants.h"
#import "AppDatabase.h"
#import "AppMsg.h"
#import "AppUtil.h"
#import "FoodTruckVO.h"
#import "ErrorVO.h"
#import "AppJsonConst.h"
#import "AddFoodTruckVO.h"
#import "LAViewController.h"

@interface LAAddFdViewController ()

@end

@implementation LAAddFdViewController

@synthesize textFieldAt;
@synthesize textFieldTwitter;
@synthesize btnCancel;
@synthesize btnGps;
@synthesize btnOk;
@synthesize textFieldCurrent;
@synthesize showStatusBar;
@synthesize strUserTapedAddress;
@synthesize strPartialAddress;

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
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    btnGps.layer.cornerRadius = 4;
    btnGps.layer.borderWidth = 1;
    btnGps.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnOk.layer.cornerRadius = 4;
    btnOk.layer.borderWidth = 1;
    btnOk.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnCancel.layer.cornerRadius = 4;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    self.strPartialAddress = @"";
    
    //[textFieldAt setText:strUserTapedAddress];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.geocoder   = [[GeoCoder alloc] init];
    self.geocoder.delegate  = self;
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.showStatusBar = YES;
    
    [textFieldTwitter becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)okBtnClicked:(id)sender{
    if(textFieldTwitter.text != nil && [[textFieldTwitter.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0){
        
        
        
        if ([AppUtil hasUserChangedAddFoodTruckAddress:textFieldAt.text]) {
            self.strPartialAddress = [textFieldAt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self showLoaderMsg];
            [self.geocoder getLatLongFromAddress:textFieldAt.text];
        }else{
            [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
                [self loadAddFoodtruckDetails:appdelegte.userTappedLocation];
            }];
            
        }
        
        
    }else{
        [self.navigationController.formSheetController.view makeToast:TWITTER_NOT_EMPTY_MSG];
    }
    
    
    
}
-(IBAction)GpsBtnClicked:(id)sender{
    [textFieldAt setText:strUserTapedAddress];
}
-(IBAction)cancelBtnClicked:(id)sender{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegte.TWITTER_CACHE removeAllObjects];
    //NSLog(@"cancel btn clicked");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if ([textField isEqual:self.textFieldTwitter]) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 15) ? NO : YES;
    }else{
        return YES;
    }
    
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.showStatusBar;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //NSLog(@"textfield did end editting");
    
    if ([textField isEqual:self.textFieldTwitter]) {
        if(textFieldTwitter.text != nil && [[textFieldTwitter.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0){
            LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
            if([[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_FD_DETAILS_BY_TWITTER_TAG]){
                RestApiWorker *restApiWorker = [appdelegte.restOpertaion.operationInProgress objectForKey:REQ_FD_DETAILS_BY_TWITTER_TAG];
                [restApiWorker cancel];
                [appdelegte.restOpertaion.operationInProgress removeObjectForKey:REQ_FD_DETAILS_BY_TWITTER_TAG];
            }
            
            [AppUtil getFoodTruckDetailsByTwitterHandler:textFieldTwitter.text withDelegate:self];
            
        }
    }
    
    textFieldCurrent    = nil;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if([[appdelegte.restOpertaion.operationInProgress allKeys] containsObject:REQ_FD_DETAILS_BY_TWITTER_TAG]){
        RestApiWorker *restApiWorker = [appdelegte.restOpertaion.operationInProgress objectForKey:REQ_FD_DETAILS_BY_TWITTER_TAG];
        [restApiWorker cancel];
        [appdelegte.restOpertaion.operationInProgress removeObjectForKey:REQ_FD_DETAILS_BY_TWITTER_TAG];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"textfield did begin editting");
    textFieldCurrent = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  NO;
}



#pragma mark - UIViewControllerRotation

// Applications should use supportedInterfaceOrientations and/or shouldAutorotate..
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

// New Autorotation support.
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

-(void)showLoaderMsg{
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.formSheetController.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = ADD_GEOCODING_MSG;
    
}

-(void)hideLoaderMsg{
    if(hud != nil){
        [hud hide:YES];
    }
}

- (void)locationFromAddressFailureCallback:(NSError *)error{
    [self hideLoaderMsg];
    //NSLog(@"ok btn clicked");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        [self loadAddFoodtruckDetails:appdelegte.userTappedLocation];
        
    }];
}

- (void)locationFromAddressSuccessCallback:(CLLocation *)location{
    [self hideLoaderMsg];
    //NSLog(@"ok btn clicked");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [self loadAddFoodtruckDetails:location.coordinate];
    }];
}

- (void)partialAddressFromLocationSuccessCallback:(NSString *)address{
    //NSLog(@"Partial address add food truck =%@", address);
    //self.strPartialAddress = address;
    
}

- (void)addressFromLocationFailureCallback:(NSError *)error{
    [self hideLoaderMsg];
}

- (void)addressFromLocationSuccessCallback:(NSString *)address{
    [self hideLoaderMsg];
    
}

- (void)successcallback:(RestAPIVO *)restApiVO{
    if(restApiVO != nil){
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelegte.restOpertaion.operationInProgress removeObjectForKey:restApiVO.TAG];
        if(!restApiVO.worker.isCancelled && restApiVO.response != nil){
            if ([restApiVO.response class] == [FoodTruckVO class]){
                LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
                FoodTruckVO *fdVO   = (FoodTruckVO *)restApiVO.response;
                [appdelegte.TWITTER_CACHE setObject:fdVO forKey:[[restApiVO.reqDicParamObj objectForKey:TWITTER_HANDLER] lowercaseString]];
                
            }else if ([restApiVO.response class] == [ErrorVO class]){
                ErrorVO *errorVo = (ErrorVO *)restApiVO.response;
                //NSLog(@"%@, %@",errorVo.status, errorVo.msg);
            }
        }
        
    }
}

- (void)failurecallback:(RestAPIVO *)restApiVO{
     //NSLog(@"getting fd details by twitter handler Requset failed");
    if(restApiVO != nil){
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelegte.restOpertaion.operationInProgress removeObjectForKey:restApiVO.TAG];
    }
    
}

- (void)internetConnectionError:(RestAPIVO *)restApiVO{
    [self hideLoaderMsg];
    
    if(restApiVO != nil){
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelegte.restOpertaion.operationInProgress removeObjectForKey:restApiVO.TAG];
        //Need to implement
    }
}

-(void) loadAddFoodtruckDetails:(CLLocationCoordinate2D)location{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    AddFoodTruckVO *addFdVO = [[AddFoodTruckVO alloc] init];
    addFdVO.lat = [NSString stringWithFormat:@"%f",location.latitude];
    addFdVO.lng = [NSString stringWithFormat:@"%f",location.longitude];
    
    NSError *error = nil;
    NSString *strTwitter = self.textFieldTwitter.text;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:strTwitter options:0 range:NSMakeRange(0, [strTwitter length]) withTemplate:@""];
    //NSLog(@"modified==%@", modifiedString);
    
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    modifiedString= [modifiedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.strPartialAddress==nil || [[self.strPartialAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        self.strPartialAddress = textFieldAt.text;
    }
    
    addFdVO.twitterHandler = modifiedString;
    addFdVO.deviceID = appdelegte.deviceid;
    addFdVO.icon     = @"YELLOW";
    addFdVO.positiveConfirm = @"true";
    addFdVO.description = @"";
    addFdVO.isMerchant = @"false";
    addFdVO.timeZone   = [[NSTimeZone systemTimeZone] name];
    addFdVO.address    = textFieldAt.text;
    addFdVO.partialAddress = self.strPartialAddress;
    appdelegte.addFdVO = addFdVO;
    
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    [vc goToAddFoodTruckMoreDetails];
    
}



@end
