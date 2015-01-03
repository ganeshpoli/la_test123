//
//  AddFoodTruckViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 26/12/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "AddFoodTruckViewController.h"

@interface AddFoodTruckViewController() <WYPopoverControllerDelegate>{
    WYPopoverController *datePickerPopoverController;
}


@end

@implementation AddFoodTruckViewController

@synthesize scrollView;
@synthesize contentView;
@synthesize btnRadioOpenNow;
@synthesize btnRadioWillOpenSoon;
@synthesize textFieldAt;
@synthesize textFieldFacebok;
@synthesize textFieldFoodTruck;
@synthesize textFieldLaterDate;
@synthesize textFieldTwitter;
@synthesize textFieldUntilDate;
@synthesize textFieldCurrent;
@synthesize TEXTFIELD_INDICATOR;


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
    
    TEXTFIELD_INDICATOR = APP_DEFAULT;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    UIBarButtonItem *addBarButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(saveAction)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = addBarButton;
    
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    [dateformate setDateFormat:CHECK_IN_DATE_FORMATE];
    
    NSDate *date = [NSDate date];
    [self.textFieldLaterDate setText:[dateformate stringFromDate:date]];
    [self.textFieldUntilDate setText:[dateformate stringFromDate:date]];
    
    
}





- (void)saveAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(IBAction)btnRadioOpenNowClicked:(id)sender{
    NSLog(@"Button open now clicked");
}
-(IBAction)btnRadioWillOpenSoonClicked:(id)sender{
    NSLog(@"Button will open soon clicked");
}


- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.textFieldCurrent.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.textFieldCurrent.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self deregisterForKeyboardNotifications];
    
}

- (void)deregisterForKeyboardNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    BOOL isEditable = YES;
    
    //NSLog(@"textfield should begin editting");
    if ([textField isEqual:self.textFieldLaterDate] || [textField isEqual:self.textFieldUntilDate]) {
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
            viewController.date                = [df dateFromString:textField.text];
            viewController.textFieldPicker     = textField;
            
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
            
            CGRect rect = view.bounds;
            
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
                viewController.textFieldPicker.text = [df stringFromDate:selecteddate];
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


-(void)showLoaderMsg{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = PLEASEWAIT_MSG;
    hud.detailsLabelText = GEOCODER_MSG;
}

-(void)hideLoaderMsg{
    if(hud != nil){
        [hud hide:YES];
    }
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
