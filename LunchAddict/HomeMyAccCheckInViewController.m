//
//  HomeMyAccCheckInViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 07/11/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "HomeMyAccCheckInViewController.h"
#import "MZFormSheetController.h"
#import "LAViewController.h"
#import "LAAppDelegate.h"
#import "AppUtil.h"
#import "AppMsg.h"

@interface HomeMyAccCheckInViewController ()

@end

@implementation HomeMyAccCheckInViewController

@synthesize showStatusBar;
@synthesize btnFacebookLogin;
@synthesize btnTwitterLogin;
@synthesize btnFacebookpost;
@synthesize btnTwitterpost;
@synthesize btnEmailShare;
@synthesize btnYelpShare;
@synthesize btnAddFoodTruck;
@synthesize btnShowRecentFoodTrucks;
@synthesize btnLogOut;
@synthesize btnCancel;
@synthesize btnMyAccCheckIn;
@synthesize scrollView;
@synthesize mainView;
//@synthesize formSheetController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
    
    btnAddFoodTruck.layer.cornerRadius = 4;
    btnAddFoodTruck.layer.borderWidth = 1;
    btnAddFoodTruck.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnShowRecentFoodTrucks.layer.cornerRadius = 4;
    btnShowRecentFoodTrucks.layer.borderWidth = 1;
    btnShowRecentFoodTrucks.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnLogOut.layer.cornerRadius = 4;
    btnLogOut.layer.borderWidth = 1;
    btnLogOut.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnCancel.layer.cornerRadius = 4;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnMyAccCheckIn.layer.cornerRadius = 4;
    btnMyAccCheckIn.layer.borderWidth = 1;
    btnMyAccCheckIn.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    //LAViewController *root = (LAViewController *)appdelegte.window.rootViewController;
    
    CGRect newFrame = self.mainView.frame;
    self.scrollView.contentSize = newFrame.size;
    self.scrollView.contentOffset = CGPointZero;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight)
    {
        
        [self.scrollView setScrollEnabled:YES];
    }
    else
    {
        [self.scrollView setScrollEnabled:NO];
    }
    
    UIImage *facebookactiveImage     = [UIImage imageNamed:@"facebook_active.png"];
    UIImage *facebookdeactiveImage   = [UIImage imageNamed:@"facebook32.png"];
    
    UIImage *twitteractiveImage     = [UIImage imageNamed:@"twitter_active.png"];
    UIImage *twitterdeactiveImage   = [UIImage imageNamed:@"twitter32.png"];
    
    if (appdelegte.userVO.facebookLogin && [AppUtil isFacebookSessionValid]) {
        
        
        [btnFacebookLogin setBackgroundImage:facebookactiveImage forState:UIControlStateNormal];
        [btnFacebookLogin setBackgroundImage:facebookactiveImage forState:UIControlStateSelected];
        [btnFacebookLogin setBackgroundImage:facebookactiveImage forState:UIControlStateHighlighted];
        
        [btnFacebookpost setBackgroundImage:facebookactiveImage forState:UIControlStateNormal];
        [btnFacebookpost setBackgroundImage:facebookactiveImage forState:UIControlStateSelected];
        [btnFacebookpost setBackgroundImage:facebookactiveImage forState:UIControlStateHighlighted];
        
    }else{
        [btnFacebookLogin setBackgroundImage:facebookdeactiveImage forState:UIControlStateNormal];
        [btnFacebookLogin setBackgroundImage:facebookdeactiveImage forState:UIControlStateSelected];
        [btnFacebookLogin setBackgroundImage:facebookdeactiveImage forState:UIControlStateHighlighted];
        
        [btnFacebookpost setBackgroundImage:facebookdeactiveImage forState:UIControlStateNormal];
        [btnFacebookpost setBackgroundImage:facebookdeactiveImage forState:UIControlStateSelected];
        [btnFacebookpost setBackgroundImage:facebookdeactiveImage forState:UIControlStateHighlighted];
    }
    
    if (appdelegte.userVO.twitterLogin && appdelegte.accessToken != nil) {
        [btnTwitterLogin setBackgroundImage:twitteractiveImage forState:UIControlStateNormal];
        [btnTwitterLogin setBackgroundImage:twitteractiveImage forState:UIControlStateSelected];
        [btnTwitterLogin setBackgroundImage:twitteractiveImage forState:UIControlStateHighlighted];
        
        [btnTwitterpost setBackgroundImage:twitteractiveImage forState:UIControlStateNormal];
        [btnTwitterpost setBackgroundImage:twitteractiveImage forState:UIControlStateSelected];
        [btnTwitterpost setBackgroundImage:twitteractiveImage forState:UIControlStateHighlighted];
    }else{
        [btnTwitterLogin setBackgroundImage:twitterdeactiveImage forState:UIControlStateNormal];
        [btnTwitterLogin setBackgroundImage:twitterdeactiveImage forState:UIControlStateSelected];
        [btnTwitterLogin setBackgroundImage:twitterdeactiveImage forState:UIControlStateHighlighted];
        
        [btnTwitterpost setBackgroundImage:twitterdeactiveImage forState:UIControlStateNormal];
        [btnTwitterpost setBackgroundImage:twitterdeactiveImage forState:UIControlStateSelected];
        [btnTwitterpost setBackgroundImage:twitterdeactiveImage forState:UIControlStateHighlighted];
    }
    
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

-(IBAction)btnFacebookLoginClicked:(id)sender{
    //NSLog(@"Facebook login");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [AppUtil loginToFacebook];
        
    }];
}

-(IBAction)btnMyAccCheckinClicked:(id)sender{
    //NSLog(@"Btn Check in load");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
        [vc getOpenCloseDateTimes];
    }];
    
}


-(IBAction)btnTwitterLoginClicked:(id)sender{
    //NSLog(@"Twitter login");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [AppUtil loginToTwitter];
        
    }];
}
-(IBAction)btnFacebookPostClicked:(id)sender{
    //NSLog(@"Facebook post");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *root = (LAViewController *)appdelegte.window.rootViewController;
        if (appdelegte.IS_ONLINE) {
            [AppUtil openFaceBookShareDialog];
        }else{
            
            [root.view makeToast:@"internet connection is required"];
        }
        
    }];
}
-(IBAction)btnTwitterPostClicked:(id)sender{
    //NSLog(@"Twitter post");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *root = (LAViewController *)appdelegte.window.rootViewController;
        if (appdelegte.IS_ONLINE) {
            if (appdelegte.accessToken != nil) {
                [root openTweetDialog];
            }else{
                
                [root.view makeToast:@"You need to login into twitter"];
            }
            
        }else{
            [root.view makeToast:@"internet connection is required"];
        }
    }];
}
-(IBAction)btnEmailShareClicked:(id)sender{
    //NSLog(@"Email share");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *vc = (LAViewController *)appdelegte.window.rootViewController;
        [vc sendMailTo:LUNCH_ADDICT_SHARED_EMAILID withEmailSubject:LUNCH_ADDICT_SHARED_SUBJECT withMessageBody:LUNCH_ADDICT_SHARED_MSG_BODY];
    }];
}
-(IBAction)btnYelpShareClicked:(id)sender{
    //NSLog(@"Yelp share");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}
-(IBAction)btnAddFoodTruckClicked:(id)sender{
    //NSLog(@"AddFoodTruck");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *vc = (LAViewController *)appdelegte.window.rootViewController;
        [vc addFoodTruckBasedOnLocation:vc.mapView.camera.target];
    }];
}
-(IBAction)btnShowRecentFoodTrucksClicked:(id)sender{
    //NSLog(@"ShowRecentFoodTruck");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *vc = (LAViewController *)appdelegte.window.rootViewController;
        [vc showRecentFoodTruck];
    }];
}
-(IBAction)btnLogoutClicked:(id)sender{
    //NSLog(@"Logout button");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        appdelegte.ALERT_ACTION_INDICATOR = LOGOUT_FROM_LOGOUTBTN;
        LAViewController *root = (LAViewController *)appdelegte.window.rootViewController;
        [AppUtil openTwoOptionsMsgDialog:@"Alert" withmsg:LOGOUT_FROM_ALL_SOCIALNETWORKS_MSG withdelegate:root];
    }];
}
-(IBAction)btnCancelClicked:(id)sender{
    //NSLog(@"Cancel button");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
     MZFormSheetController *viewController = [[MZFormSheetController formSheetControllersStack] lastObject];
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
       viewController.presentedFormSheetSize = CGSizeMake(300, 298);
        self.scrollView.contentOffset = CGPointZero;
        [self.scrollView setScrollEnabled:YES];
    }
    else
    {
       viewController.presentedFormSheetSize = CGSizeMake(300, 350);
       self.scrollView.contentOffset = CGPointZero;
       [self.scrollView setScrollEnabled:NO];
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
