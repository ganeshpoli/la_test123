//
//  LAMoreInfoViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 03/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LAMoreInfoViewController.h"
#import "MZFormSheetController.h"
#import "LAAppDelegate.h"
#import "LAViewController.h"

@interface LAMoreInfoViewController ()

@end

@implementation LAMoreInfoViewController

@synthesize btnCancel;
@synthesize btnOk;
@synthesize textFieldCurrent;
@synthesize textFieldFacebook;
@synthesize textFieldName;
@synthesize textFieldWebsite;
@synthesize showStatusBar;
@synthesize addFdVO;
@synthesize foodTruckVO;


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
    
    
    btnOk.layer.cornerRadius = 4;
    btnOk.layer.borderWidth = 1;
    btnOk.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnCancel.layer.cornerRadius = 4;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    
    
}

- (void)intilizeparameters:(AddFoodTruckVO *)addVO withFoodTruckDetails:(FoodTruckVO *)fdVO{
    self.foodTruckVO = fdVO;
    if (self.foodTruckVO != nil) {
        textFieldWebsite.text   = foodTruckVO.website;
        textFieldName.text      = foodTruckVO.name;
        textFieldFacebook.text  = foodTruckVO.facebookAddress;
    }
    
    self.addFdVO = addVO;
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
    [textFieldName becomeFirstResponder];
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
    addFdVO.fdName = textFieldName.text;
    addFdVO.facebookAddress = textFieldFacebook.text;
    addFdVO.website = textFieldWebsite.text;
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegte.addFdVO = addFdVO;
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
        [vc addFoodTruckDetailsToServer];
    }];
    
}
-(IBAction)cancelBtnClicked:(id)sender{
    NSLog(@"cancel btn clicked");
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textfield did end editting");
    textFieldCurrent    = nil;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (textFieldCurrent != nil) {
        [textFieldCurrent resignFirstResponder];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textfield did begin editting");
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
