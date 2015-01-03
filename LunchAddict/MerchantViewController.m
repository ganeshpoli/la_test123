//
//  MerchantViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "MerchantViewController.h"
#import "MZFormSheetController.h"
#import "LAAppDelegate.h"
#import "AppConstants.h"
#import "AppUtil.h"
#import "AppDatabase.h"

@interface MerchantViewController ()

@end

@implementation MerchantViewController

@synthesize strMerchantName;
@synthesize showStatusBar;
@synthesize btnMaybelater;
@synthesize btnYesLogin;
@synthesize btnYesLoginCheckin;
@synthesize lblMsgTitle;

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
    
    btnYesLoginCheckin.layer.cornerRadius = 4;
    btnYesLoginCheckin.layer.borderWidth = 1;
    btnYesLoginCheckin.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnYesLogin.layer.cornerRadius = 4;
    btnYesLogin.layer.borderWidth = 1;
    btnYesLogin.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnMaybelater.layer.cornerRadius = 4;
    btnMaybelater.layer.borderWidth = 1;
    btnMaybelater.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = NO;
    
    
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

- (void) designView{
    self.lblMsgTitle.text = [NSString stringWithFormat:@"Welcome back to %@.",self.strMerchantName];
}

-(IBAction)btnYesLoginCheckinClicked:(id)sender{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegte.MERCHANT_CHECKIN_REQ_STATE = YES_LOGIN_CHECKIN_STATE;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [AppUtil loginToTwitter];
    }];
    
    
}
-(IBAction)btnYesLoginClicked:(id)sender{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegte.MERCHANT_CHECKIN_REQ_STATE = YES_LOGIN_STATE;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [AppUtil loginToTwitter];
    }];
    
    
}
-(IBAction)btnMaybelaterClicked:(id)sender{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegte.MERCHANT_CHECKIN_REQ_STATE = APP_DEFAULT;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [AppUtil loadMapIntialView];
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
