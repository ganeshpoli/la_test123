//
//  LAPinMeViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 30/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LAPinMeViewController.h"
#import "MZFormSheetController.h"
#include "AppConstants.h"
#import "AppDatabase.h"
#import "AppMsg.h"

@interface LAPinMeViewController ()<WYPopoverControllerDelegate>{
    WYPopoverController *pastAddressPopoverController;
}


@end

@implementation LAPinMeViewController

@synthesize textFieldPastAdress;
@synthesize textFieldPinMeAddress;
@synthesize textFieldCurrent;
@synthesize arrPastAddress;
@synthesize showStatusBar;
@synthesize btnCancel;
@synthesize btnGo;
@synthesize btnReset;
@synthesize geocoder;
//@synthesize mainViewController;
@synthesize GPS_UPDATE;
//@synthesize activityIndicatorView;
@synthesize labelGpsNotAvaliable;


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
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    btnReset.layer.cornerRadius = 4;
    btnReset.layer.borderWidth = 1;
    btnReset.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnGo.layer.cornerRadius = 4;
    btnGo.layer.borderWidth = 1;
    btnGo.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnCancel.layer.cornerRadius = 4;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;    
    
    if (appdelegte.GPS_STATUS_INDICATOR == GPS_IS_NOT_AVALIBLE) {
        [self.labelGpsNotAvaliable setHidden:NO];
    }else{
        [self.labelGpsNotAvaliable setHidden:YES];
    }
    
    appdelegte.GPS_STATUS_INDICATOR = APP_DEFAULT;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    self.geocoder   = [[GeoCoder alloc] init];
    self.geocoder.delegate  = self;
    
    //[self.activityIndicatorView setHidden:YES];
    
    self.gpsTracker = [[GPSTracker alloc] init];
    self.gpsTracker.delegate    = self;
    
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = NO;
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    arrPastAddress  = appdelegte.arrPastAddress;
    
    //[self viewEnable];
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.showStatusBar = YES;
    [textFieldPinMeAddress becomeFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
    
}

-(IBAction)goBtnClicked:(id)sender{
    NSLog(@"Go btn clicked");
    if(textFieldPinMeAddress.text != nil && [[textFieldPinMeAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0){
        [self showLoaderMsg];
        [self.geocoder getLatLongFromAddress:textFieldPinMeAddress.text];
    }else{
        [self.navigationController.formSheetController.view makeToast:ADDRESS_NOT_EMPTY_MSG];
    }
    
    
}
-(IBAction)resetBtnClicked:(id)sender{
    NSLog(@"reset btn clicked");
    
    if ([CLLocationManager locationServicesEnabled]) {
        //[self viewDisable];
        GPS_UPDATE  = YES;
        [self showLoaderMsg];
        [self.gpsTracker.locMgr startUpdatingLocation];
    }else{
        [self.navigationController.formSheetController.view makeToast:GPS_DISABLED_MSG];
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            
        }];
    }
    
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textfield did end editting");
    textFieldCurrent    = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textfield did begin editting");
    textFieldCurrent = textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    BOOL isEditable = YES;
    
    NSLog(@"textfield should begin editting");    
    if ([textField isEqual:textFieldPastAdress]) {
        isEditable  = NO;
        
        if (textFieldCurrent != nil) {
            [textFieldCurrent resignFirstResponder];
            textFieldCurrent = nil;
        }
        
        
        
        if (pastAddressPopoverController == nil)
        {
            UIView *view = (UIView *)textField;
            
            LAPastAddressViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"passaddressView"];
            viewController.arrPicker    = arrPastAddress;
            viewController.strSelection = textFieldPastAdress.text;
            viewController.preferredContentSize = CGSizeMake(320, 280);
            
            viewController.title = @"Past address";
            
            [viewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)]];
            
            [viewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)]];
            
            viewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            pastAddressPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            pastAddressPopoverController.delegate = self;
            pastAddressPopoverController.passthroughViews = @[view];
            pastAddressPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            pastAddressPopoverController.wantsDefaultContentAppearance = NO;
            
            [pastAddressPopoverController presentPopoverFromRect:view.bounds
                                                           inView:view
                                         permittedArrowDirections:WYPopoverArrowDirectionAny
                                                         animated:YES
                                                          options:WYPopoverAnimationOptionFadeWithScale];
            
        }
        else
        {
            [self close:nil];
        }
        
    }
    return isEditable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  NO;
}

#pragma mark - WYPopoverControllerDelegate

- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == pastAddressPopoverController)
    {
        NSLog(@"popoverControllerDissmissed");
        pastAddressPopoverController.delegate = nil;
        pastAddressPopoverController = nil;
    }
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value
{
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
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

- (void)done:(id)sender

{
    if(pastAddressPopoverController != nil){
        LAPastAddressViewController *viewController = (LAPastAddressViewController *)pastAddressPopoverController.contentViewController.childViewControllers[0];
        NSString *strSelection = viewController.strSelection;
        if(![PASTADDRESS isEqualToString:strSelection]){
            [textFieldPastAdress setText:strSelection];
            [textFieldPinMeAddress setText:strSelection];
        }
        NSLog(@"from pinme controller =%@",strSelection);
    }
    [self close:sender];
}

- (void)close:(id)sender
{
    [pastAddressPopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:pastAddressPopoverController];
    }];
}

- (void)cancel:(id)sender
{
    [self close:sender];
}

- (void)locationFromAddressSuccessCallback:(CLLocation *)location{
    
    [self hideLoaderMsg];
    
    BOOL isContains = NO;
    
    for (NSString *str in self.arrPastAddress) {
        if ([[str lowercaseString] isEqualToString:[self.textFieldPinMeAddress.text lowercaseString]]) {
            isContains = YES;
        }
    }
    
    if (!isContains) {
        [self.arrPastAddress addObject:self.textFieldPinMeAddress.text];
        [AppDatabase updatePastAddress];
    }
    
    //[mainViewController getFoodTruckDataBasedOnAddress:location];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        appdelegte.REFRESH_INDICATOR    = LAST_PINNED_LOCATION_IS_ADDRESS;
        [appdelegte.USER_MARKER setPosition:location.coordinate];
        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
        
        //BETA-51
        GMSCameraPosition* camera = [GMSCameraPosition cameraWithTarget:appdelegte.USER_MARKER.position zoom:appdelegte.settingsVO.zoomLevel];
        appdelegte.mapAnimated = YES;
        [vc.mapView animateToCameraPosition:camera];
        
        [vc getFoodTruckDataBasedOnAddress:location];
    }];
    
}

- (void)locationFromAddressFailureCallback:(NSError *)error{
    //[self.view makeToast:GEOCODER_FAILED_MSG];
    [self hideLoaderMsg];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
        [vc.view makeToast:GEOCODER_FAILED_MSG];
    }];
}

- (void)addressFromLocationSuccessCallback:(NSString *)address{
    
}

- (void)addressFromLocationFailureCallback:(NSError *)error{
    
}

- (void)locationUpdate:(CLLocation *)location{
    [self hideLoaderMsg];
    [self.gpsTracker.locMgr stopUpdatingLocation];
    if (GPS_UPDATE) {
        GPS_UPDATE = NO;
        //[mainViewController getFoodTruckDataBasedOnGPS:location];
        
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
            appdelegte.REFRESH_INDICATOR    = LAST_PINNED_LOCATION_IS_GPS;
            LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
            [appdelegte.USER_MARKER setPosition:location.coordinate];
            vc.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:appdelegte.settingsVO.zoomLevel];
            
            appdelegte.RESET_PIN_LOCATION = YES;
            
            //[vc getFoodTruckDataBasedOnGPS:location];
        }];
    }
    
    
    
}

- (void)locationError:(NSError *)error{
    [self hideLoaderMsg];
    [self.gpsTracker.locMgr stopUpdatingLocation];
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
        [vc.view makeToast:GPS_DISABLED_MSG];
    }];
}

- (void)partialAddressFromLocationSuccessCallback:(NSString *)address{
    NSLog(@"Partial address =%@", address);
}

-(void)showLoaderMsg{
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.formSheetController.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = PINME_MSG;
    hud.detailsLabelText = GEOCODER_MSG;
}

-(void)hideLoaderMsg{
    if(hud != nil){
        [hud hide:YES];
    }
}




@end
