//
//  LAInternetConnErrController.m
//  LunchAddict
//
//  Created by SPEROWARE on 04/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LAInternetConnErrController.h"
#import "MZFormSheetController.h"
#import "LAViewController.h"
#import "AppConstants.h"
#import "LAInitViewController.h"

@interface LAInternetConnErrController ()

@end

@implementation LAInternetConnErrController

@synthesize btnSupportEmail;
@synthesize btnTryReConnect;
@synthesize strErrMsg;
@synthesize restApiVO;
@synthesize showStatusBar;

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
    btnTryReConnect.layer.cornerRadius = 4;
    btnTryReConnect.layer.borderWidth = 1;
    btnTryReConnect.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnSupportEmail.layer.cornerRadius = 4;
    btnSupportEmail.layer.borderWidth = 1;
    btnSupportEmail.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
    
}

-(IBAction)tryToReConnectBtnClicked:(id)sender{
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UIViewController *viewController    = appdelegte.window.rootViewController;
        
        if([viewController class] == [LAInitViewController class]){
            LAInitViewController *vc    = (LAInitViewController *)appdelegte.window.rootViewController;
            [vc trytoReconnect];
        }else if ([viewController class] == [LAViewController class]){
            LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
            [vc trytoReconnect];
        }
        
       
    }];
}
-(IBAction)supportBtnClicked:(id)sender{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
         UIViewController *viewController    = appdelegte.window.rootViewController;
        
        if([viewController class] == [LAInitViewController class]){
            LAInitViewController *lainitvc    = (LAInitViewController *)appdelegte.window.rootViewController;
            [lainitvc sendMailTo:LUNCH_ADDICT_SUPPORT_EMAILID withEmailSubject:LUNCH_ADDICT_SUPPORT_SUBJECT withMessageBody:lainitvc.failureRestApiVO.error.description];
        }else if ([viewController class] == [LAViewController class]){
            LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
            [vc sendMailTo:LUNCH_ADDICT_SUPPORT_EMAILID withEmailSubject:LUNCH_ADDICT_SUPPORT_SUBJECT withMessageBody:vc.failureRestApiVO.error.description];
        }
       
    }];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) intializeParameters:(RestAPIVO *)restVO withErrorMsg:(NSString *)strMsg{
    self.restApiVO = restVO;
    self.strErrMsg = strMsg;
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
