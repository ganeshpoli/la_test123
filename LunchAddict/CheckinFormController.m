//
//  CheckinFormController.m
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "CheckinFormController.h"
#import "MZFormSheetController.h"
#import "LAAppDelegate.h"
#import "AppDatePickerViewController.h"
#import "AppMsg.h"
#import "CheckinoutVO.h"
#import "NSDate+Utils.h"
#import "AppUtil.h"

@interface CheckinFormController () <WYPopoverControllerDelegate>{
    WYPopoverController *datePickerPopoverController;
}


@end

@implementation CheckinFormController

@synthesize textFieldAtLocationAddress;
@synthesize textFieldFromTime;
@synthesize textFieldOnDate;
@synthesize textFieldUntilTime;
@synthesize btnCancel;
@synthesize btnCheckin;
@synthesize btnEnterMoreDetails;
@synthesize geocoder;
@synthesize textFieldCurrent;
@synthesize numCheckInAction;
@synthesize timepickerindicator;
@synthesize strStreetAddress;

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
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    textFieldAtLocationAddress.delegate = self;
    textFieldFromTime.delegate = self;
    textFieldOnDate.delegate = self;
    textFieldUntilTime.delegate = self;
    
    btnCheckin.layer.cornerRadius = 4;
    btnCheckin.layer.borderWidth = 1;
    btnCheckin.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    
    btnCancel.layer.cornerRadius = 4;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    
    btnEnterMoreDetails.layer.cornerRadius = 4;
    btnEnterMoreDetails.layer.borderWidth = 1;
    btnEnterMoreDetails.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    self.geocoder   = [[GeoCoder alloc] init];
    self.geocoder.delegate  = self;
    
}


-(void) designView{
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    [dateformate setDateFormat:CHECK_IN_DATE_FORMATE];
    
    NSDateFormatter *timeformate = [[NSDateFormatter alloc] init];
    [timeformate setDateFormat:CHECK_IN_TIME_FORMATE];
    
    NSDateFormatter *openCloseDateFormate = [[NSDateFormatter alloc] init];
    [openCloseDateFormate setDateFormat:OPEN_CLOSE_DATE_FORMATE];
    
    switch ([numCheckInAction integerValue]) {
        case ADD_CHECKIN_OUT_DEATLS:{
            self.textFieldAtLocationAddress.text = self.strAddress;
            
            if (appdelegte.OPEN_CLOSE_FD_VO != nil) {
                
                NSString *strOpenDate   = appdelegte.OPEN_CLOSE_FD_VO.openDate;
                NSString *strCloseDate = appdelegte.OPEN_CLOSE_FD_VO.closeDate;
                
                
                NSDate *opendate = [openCloseDateFormate dateFromString:strOpenDate];
                NSDate *closedate = [openCloseDateFormate dateFromString:strCloseDate];
                [self.textFieldOnDate setText:[dateformate stringFromDate:opendate]];
                [self.textFieldFromTime setText:[timeformate stringFromDate:opendate]];
                [self.textFieldUntilTime setText:[timeformate stringFromDate:closedate]];
                appdelegte.OPEN_CLOSE_FD_VO = nil;
            }else{
                NSDate *date = [NSDate date];
                [self.textFieldOnDate setText:[dateformate stringFromDate:date]];
                [self.textFieldFromTime setText:[timeformate stringFromDate:date]];
                [self.textFieldUntilTime setText:[timeformate stringFromDate:date]];
            }
            
            
        }
            break;
        case EDIT_CHECKIN_OUT_DETAILS:{
            CheckinoutVO *checkVO   = [AppDatabase getCheckOutDetails];
            self.textFieldAtLocationAddress.text = checkVO.at;
            [self.textFieldOnDate setText:checkVO.on];
            [self.textFieldFromTime setText:checkVO.from];
            [self.textFieldUntilTime setText:checkVO.until];
        }
            break;
            
        default:
            break;
    }
    
    
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

-(IBAction)btnCheckinClicked:(id)sender{
    
    if (self.textFieldAtLocationAddress.text != nil && [[self.textFieldAtLocationAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        
        NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
        [dateformate setDateFormat:[NSString stringWithFormat:@"%@%@",CHECK_IN_DATE_FORMATE,CHECK_IN_TIME_FORMATE]];
        
        NSDate *openDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@",self.textFieldOnDate.text,self.textFieldFromTime.text]];
        NSDate *closeDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@",self.textFieldOnDate.text,self.textFieldUntilTime.text]];
        
        long long openmillisecands = (long long)([openDate timeIntervalSince1970] * 1000.0);
        long long closemillisecands = (long long)([closeDate timeIntervalSince1970] * 1000.0);
        
        if (openmillisecands < closemillisecands) {
            
            if ([AppUtil hasUserChangedCheckInAddress:textFieldAtLocationAddress.text]) {
                self.strStreetAddress = [textFieldAtLocationAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                [self showLoaderMsg];
                [self.geocoder getLatLongFromAddress:self.textFieldAtLocationAddress.text];
                
            }else{
                [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
                    [self submitCheckDataToServer:appdelegte.userCheckinLocation];
                }];
                
            }
            
            
//            [self showLoaderMsg];
//            [self.geocoder getLatLongFromAddress:self.textFieldAtLocationAddress.text];
        }else{
            [self.navigationController.formSheetController.view makeToast:OPEN_TIME_CLOSE_TIME_ERROR_MSG];
        }
        
    }else {
        [self.navigationController.formSheetController.view makeToast:ADDRESS_NOT_EMPTY_MSG];
    }
    
    
}
-(IBAction)btnEnterMoreDetailsClicked:(id)sender{
    
}
-(IBAction)btnCancelClicked:(id)sender{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [AppUtil loadMapIntialView];
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
    //NSLog(@"textfield did end editting");
    textFieldCurrent    = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"textfield did begin editting");
    textFieldCurrent = textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    BOOL isEditable = YES;
    
    //NSLog(@"textfield should begin editting");
    if ([textField isEqual:textFieldOnDate]) {
        isEditable  = NO;
        
        if (textFieldCurrent != nil) {
            [textFieldCurrent resignFirstResponder];
            textFieldCurrent = nil;
        }
        
        
        
        if (datePickerPopoverController == nil)
        {
            UIView *view = (UIView *)textField;
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:CHECK_IN_DATE_FORMATE];
            
            AppDatePickerViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"datepicker"];
            viewController.PICKER_SELECTION    = DATE_PICKER;
            viewController.date                = [df dateFromString:self.textFieldOnDate.text];
            
            viewController.preferredContentSize = CGSizeMake(320, 280);
            
            viewController.title = @"Date Picker";
            
            [viewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)]];
            
            [viewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)]];
            
            viewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            datePickerPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            datePickerPopoverController.delegate = self;
            datePickerPopoverController.passthroughViews = @[view];
            datePickerPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            datePickerPopoverController.wantsDefaultContentAppearance = NO;
            
            [datePickerPopoverController presentPopoverFromRect:view.bounds
                                                          inView:view
                                        permittedArrowDirections:WYPopoverArrowDirectionAny
                                                        animated:YES
                                                         options:WYPopoverAnimationOptionFadeWithScale];
            
        }
        else
        {
            [self close:nil];
        }
        
    }else if ([textField isEqual:textFieldFromTime] || [textField isEqual:textFieldUntilTime]) {
        isEditable  = NO;
        
        if (textFieldCurrent != nil) {
            [textFieldCurrent resignFirstResponder];
            textFieldCurrent = nil;
        }
        
        
        
        
        
        if (datePickerPopoverController == nil)
        {
            UIView *view = (UIView *)textField;
            
            AppDatePickerViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"datepicker"];
            viewController.PICKER_SELECTION    = TIME_PICKER;
            
            NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
            [dateformate setDateFormat:[NSString stringWithFormat:@"%@%@",CHECK_IN_DATE_FORMATE,CHECK_IN_TIME_FORMATE]];
            
            if ([textField isEqual:textFieldFromTime]){
                timepickerindicator = FROM_TIME;
                NSDate *openDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@",self.textFieldOnDate.text,self.textFieldFromTime.text]];
                viewController.date                = openDate;
                
            }else if ([textField isEqual:textFieldUntilTime]) {
                timepickerindicator = UNTIL_TIME;
                NSDate *closeDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@",self.textFieldOnDate.text,self.textFieldUntilTime.text]];
                viewController.date                = closeDate;
            }
            
            viewController.preferredContentSize = CGSizeMake(320, 280);
            
            viewController.title = @"Date Picker";
            
            [viewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)]];
            
            [viewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)]];
            
            viewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            datePickerPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            datePickerPopoverController.delegate = self;
            datePickerPopoverController.passthroughViews = @[view];
            datePickerPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            datePickerPopoverController.wantsDefaultContentAppearance = NO;
            
            [datePickerPopoverController presentPopoverFromRect:view.bounds
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
   // NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == datePickerPopoverController)
    {
        //NSLog(@"popoverControllerDissmissed");
        datePickerPopoverController.delegate = nil;
        datePickerPopoverController = nil;
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
    if(datePickerPopoverController != nil){
        AppDatePickerViewController *viewController = (AppDatePickerViewController *)datePickerPopoverController.contentViewController.childViewControllers[0];
        NSInteger PICKER_SELECTION          = viewController.PICKER_SELECTION;
        UIDatePicker *datePicker            = viewController.datePicker;
        NSDate *selecteddate                = [datePicker date];
        
        
        
        switch (PICKER_SELECTION) {
            case DATE_PICKER:{
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:CHECK_IN_DATE_FORMATE];
                self.textFieldOnDate.text = [df stringFromDate:selecteddate];
            }
            break;
            
            case TIME_PICKER:{
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:CHECK_IN_TIME_FORMATE];
                
                switch (timepickerindicator) {
                    case FROM_TIME:{
                        self.textFieldFromTime.text = [df stringFromDate:selecteddate];
                    }
                        break;
                    case UNTIL_TIME:{
                       self.textFieldUntilTime.text = [df stringFromDate:selecteddate];
                    }
                        break;
                        
                    default:
                        break;
                }
                

                
            }
            break;
            
            default:
            break;
        }
        
        
    }
    [self close:sender];
}

- (void)close:(id)sender
{
    [datePickerPopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:datePickerPopoverController];
    }];
}

- (void)cancel:(id)sender
{
    [self close:sender];
}

- (void) submitCheckDataToServer:(CLLocation *)location{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    
    if (self.strStreetAddress == nil || [[self.strStreetAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        self.strStreetAddress = [textFieldAtLocationAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    
    CheckinoutVO *checkVO = [[CheckinoutVO alloc] init];
    checkVO.checkin = APP_NO;
    checkVO.at= [self.textFieldAtLocationAddress text];
    checkVO.on= [self.textFieldOnDate text];
    checkVO.from = [self.textFieldFromTime text];
    checkVO.until = [self.textFieldUntilTime text];
    checkVO.suggfrom = @"";
    checkVO.sugguntil= @"";
    checkVO.lat = [[[NSNumber alloc] initWithDouble:location.coordinate.latitude] stringValue];
    checkVO.lng = [[[NSNumber alloc] initWithDouble:location.coordinate.longitude] stringValue];
    checkVO.partiaAddress = self.strStreetAddress;
    
    FoodTruckVO *fdVO   = [AppDatabase getMerchantFoodTruckVO];
    fdVO.lat            = [[NSNumber alloc] initWithDouble:location.coordinate.latitude];
    fdVO.lng            = [[NSNumber alloc] initWithDouble:location.coordinate.longitude];
    
    if (appdelegte.userVO.isMarchant) {
        fdVO.isMerchant = APP_YES;
    }else{
        fdVO.isMerchant = APP_NO;
    }
    
    
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    [dateformate setDateFormat:[NSString stringWithFormat:@"%@%@",CHECK_IN_DATE_FORMATE,CHECK_IN_TIME_FORMATE]];
    
    NSDate *openDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@",checkVO.on,checkVO.from]];
    
    NSDate *closeDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@",checkVO.on,checkVO.until]];
    
    NSDateFormatter *openCloseDateFormate = [[NSDateFormatter alloc] init];
    [openCloseDateFormate setDateFormat:[NSString stringWithFormat:@"%@",OPEN_CLOSE_DATE_FORMATE]];
    
    
    long long opendatetimemilli = (long long)([openDate timeIntervalSince1970] * 1000.0);
    long long closedatetimemilli = (long long)([closeDate timeIntervalSince1970] * 1000.0);
    
    fdVO.openDate = [NSString stringWithFormat:@"%lld",opendatetimemilli];
    fdVO.closeDate = [NSString stringWithFormat:@"%lld",closedatetimemilli];
    
    [vc submitCheckINDetails:fdVO withTagObj:checkVO];
}

- (void)locationFromAddressSuccessCallback:(CLLocation *)location{
    
    [self hideLoaderMsg];
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [self submitCheckDataToServer:location];
//        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
//        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
//        CheckinoutVO *checkVO = [[CheckinoutVO alloc] init];
//        checkVO.checkin = APP_NO;
//        checkVO.at= [self.textFieldAtLocationAddress text];
//        checkVO.on= [self.textFieldOnDate text];
//        checkVO.from = [self.textFieldFromTime text];
//        checkVO.until = [self.textFieldUntilTime text];
//        checkVO.suggfrom = @"";
//        checkVO.sugguntil= @"";
//        checkVO.lat = [[[NSNumber alloc] initWithDouble:location.coordinate.latitude] stringValue];
//        checkVO.lng = [[[NSNumber alloc] initWithDouble:location.coordinate.longitude] stringValue];
//        
//        FoodTruckVO *fdVO   = [AppDatabase getMerchantFoodTruckVO];
//        fdVO.lat            = [[NSNumber alloc] initWithDouble:location.coordinate.latitude];
//        fdVO.lng            = [[NSNumber alloc] initWithDouble:location.coordinate.longitude];
//        
//        if (appdelegte.userVO.isMarchant) {
//            fdVO.isMerchant = APP_YES;
//        }else{
//            fdVO.isMerchant = APP_NO;
//        }
//        
//        
//        NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
//        [dateformate setDateFormat:[NSString stringWithFormat:@"%@%@",CHECK_IN_DATE_FORMATE,CHECK_IN_TIME_FORMATE]];
//        
//        NSDate *openDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@",checkVO.on,checkVO.from]];
//        
//        NSDate *closeDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@",checkVO.on,checkVO.until]];
//        
//        NSDateFormatter *openCloseDateFormate = [[NSDateFormatter alloc] init];
//        [openCloseDateFormate setDateFormat:[NSString stringWithFormat:@"%@",OPEN_CLOSE_DATE_FORMATE]];
//        
//        
//        long long opendatetimemilli = (long long)([openDate timeIntervalSince1970] * 1000.0);
//        long long closedatetimemilli = (long long)([closeDate timeIntervalSince1970] * 1000.0);
//        
//        fdVO.openDate = [NSString stringWithFormat:@"%lld",opendatetimemilli];
//        fdVO.closeDate = [NSString stringWithFormat:@"%lld",closedatetimemilli];
//        
//        [vc submitCheckINDetails:fdVO withTagObj:checkVO];        
        
    }];
    
}

- (void)locationFromAddressFailureCallback:(NSError *)error{
    
    [self hideLoaderMsg];
    [self.navigationController.formSheetController.view makeToast:GEOCODER_FAILED_MSG];
}

- (void)addressFromLocationSuccessCallback:(NSString *)address{
    
}

- (void)addressFromLocationFailureCallback:(NSError *)error{
    
}

- (void)partialAddressFromLocationSuccessCallback:(NSString *)address{
    //NSLog(@"Partial address =%@", address);
}



-(void)showLoaderMsg{
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.formSheetController.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = PLEASEWAIT_MSG;
    hud.detailsLabelText = GEOCODER_MSG;
}

-(void)hideLoaderMsg{
    if(hud != nil){
        [hud hide:YES];
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
