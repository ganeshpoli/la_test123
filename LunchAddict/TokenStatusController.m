//
//  TokenStatusController.m
//  LunchAddict
//
//  Created by SPEROWARE on 22/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "TokenStatusController.h"
#import "AppConstants.h"
#import "AppMsg.h"
#import "MZFormSheetController.h"
#import "LAAppDelegate.h"
#import "LAViewController.h"
#import "AppUtil.h"


@interface TokenStatusController ()

@end

@implementation TokenStatusController

@synthesize tokenCacheVO;
@synthesize btnSupportMail;
@synthesize btnNo;
@synthesize btnYes;
@synthesize lblMsg;
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    btnNo.layer.cornerRadius = 4;
    btnNo.layer.borderWidth = 1;
    btnNo.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnYes.layer.cornerRadius = 4;
    btnYes.layer.borderWidth = 1;
    btnYes.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnSupportMail.layer.cornerRadius = 4;
    btnSupportMail.layer.borderWidth = 1;
    btnSupportMail.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
}

-(void)designView{
    if ([FACEBOOK isEqualToString:tokenCacheVO.providername]) {
        self.lblMsg.text = FACEBOOK_LOGIN_VERFIED_FAILED_MSG;
    }else if([TWITTER isEqualToString:tokenCacheVO.providername]){
        self.lblMsg.text = TWITTER_LOGIN_VERFIED_FAILED_MSG;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnYesClicked:(id)sender{
    if ([FACEBOOK isEqualToString:tokenCacheVO.providername]) {
        
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            [AppUtil loginToFacebook];
        }];
    }else if([TWITTER isEqualToString:tokenCacheVO.providername]){
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            [AppUtil loginToTwitter];
        }];
    }
}
-(IBAction)btnNoClicked:(id)sender{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}
-(IBAction)btnSupportMailClicked:(id)sender{
    
        
    NSMutableString *strMsg = [[NSMutableString alloc] init];
    
    [strMsg appendString:self.tokenCacheVO.providername];
    [strMsg appendString:@"\n"];
    [strMsg appendString:self.tokenCacheVO.accesstoken];
    [strMsg appendString:@"\n"];
    [strMsg appendString:self.tokenCacheVO.maxlimit];
    [strMsg appendString:@"\n"];
    [strMsg appendString:self.tokenCacheVO.numofattempts];
    [strMsg appendString:@"\n"];
    [strMsg appendString:self.tokenCacheVO.username];
    [strMsg appendString:@"\n"];
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *root = (LAViewController *)appdelegte.window.rootViewController;
        [root sendMailTo:EMAIL_TO withEmailSubject:EMAIL_SUBJECT withMessageBody:strMsg];
    }];
        
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
