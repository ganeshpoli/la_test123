//
//  AutoCheckOutViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "AutoCheckOutViewController.h"
#import "MZFormSheetController.h"
#import "LAAppDelegate.h"
#import "LAViewController.h"
#import "AppConstants.h"
#import "CheckinoutVO.h"
#import "AppUtil.h"

@interface AutoCheckOutViewController ()

@end

@implementation AutoCheckOutViewController

@synthesize showStatusBar;
@synthesize btnCheckout;
@synthesize btnEditCheckinDetails;
@synthesize btnLetMeBrowseArround;
@synthesize lblMsgTitle;
@synthesize checkinOutVO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.lblMsgTitle.text = [NSString stringWithFormat:@"Welcome %@",appdelegte.userVO.twitterHanbler];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    btnCheckout.layer.cornerRadius = 4;
    btnCheckout.layer.borderWidth = 1;
    btnCheckout.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    //btnCheckout.titleLabel.text   = [NSString stringWithFormat:@"Checkout@%@", checkinoutVO.at];
    
    btnEditCheckinDetails.layer.cornerRadius = 4;
    btnEditCheckinDetails.layer.borderWidth = 1;
    btnEditCheckinDetails.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
   // btnEditCheckinDetails.titleLabel.text   = [NSString stringWithFormat:@"Editdetails@%@", checkinoutVO.at];
    
    btnLetMeBrowseArround.layer.cornerRadius = 4;
    btnLetMeBrowseArround.layer.borderWidth = 1;
    btnLetMeBrowseArround.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
}

-(void) designView{
    CheckinoutVO *checkinoutVO  = [AppDatabase getCheckOutDetails];
    
    NSString *strAt = [NSString stringWithFormat:@"%@", checkinoutVO.at];
    
    if ([strAt length] >10) {
        strAt = [strAt substringWithRange:NSMakeRange(0, 9)];
    }
    
    //btnCheckout.titleLabel.text   = [NSString stringWithFormat:@"Checkout@%@", strAt];
    //btnEditCheckinDetails.titleLabel.text   = [NSString stringWithFormat:@"Editdetails@%@", strAt];
    
   // btnCheckout.titleLabel.text   = [NSString stringWithFormat:@"Checkout"];
   // btnEditCheckinDetails.titleLabel.text   = [NSString stringWithFormat:@"Editdetails"];
    
    
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

-(IBAction)btnCheckoutClicked:(id)sender{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
        [vc openCheckOutConfirmDialogWithTagObj:checkinOutVO];
    }];
}
-(IBAction)btnEditCheckinDetailsClicked:(id)sender{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        //appdelegte.CHECK_IN_OUT_ACTION = EDIT_CHECKIN_OUT_DETAILS;
        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
        [vc preOpenCheckinFormWithIndicator:EDIT_CHECKIN_OUT_DETAILS];
    }];
}
-(IBAction)btnLetMeBrowseArroundClicked:(id)sender{
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
