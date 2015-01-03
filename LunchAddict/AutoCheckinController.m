//
//  AutoCheckinController.m
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "AutoCheckinController.h"
#import "MZFormSheetController.h"
#import "LAAppDelegate.h"
#import "LAViewController.h"
#import "AppUtil.h"

@interface AutoCheckinController ()

@end

@implementation AutoCheckinController

@synthesize showStatusBar;
@synthesize btnMaybeLater;
@synthesize btnYesCheckin;
@synthesize lblMsgTitle;


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
    
    btnYesCheckin.layer.cornerRadius = 4;
    btnYesCheckin.layer.borderWidth = 1;
    btnYesCheckin.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnMaybeLater.layer.cornerRadius = 4;
    btnMaybeLater.layer.borderWidth = 1;
    btnMaybeLater.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
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

-(IBAction)btnYesCheckinClicked:(id)sender{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        //appdelegte.CHECK_IN_OUT_ACTION = ADD_CHECKIN_OUT_DEATLS;
        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
        //[vc preOpenCheckinFormWithIndicator:ADD_CHECKIN_OUT_DEATLS];
        [vc getOpenCloseDateTimes];
    }];
}
-(IBAction)btnMaybeLaterClicked:(id)sender{
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
