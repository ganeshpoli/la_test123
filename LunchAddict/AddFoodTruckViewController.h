//
//  AddFoodTruckViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 26/12/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "LAViewController.h"
#import "GPSTracker.h"
#import "MBProgressHUD.h"
#import "LAAppDelegate.h"
#import "AppDatePickerViewController.h"
#import "AppMsg.h"
#import "CheckinoutVO.h"
#import "NSDate+Utils.h"
#import "AppUtil.h"

@interface AddFoodTruckViewController : UIViewController<UITextFieldDelegate,GeoCoderDelegate>{
    MBProgressHUD *hud;
    
}

@property (nonatomic, assign) BOOL showStatusBar;

@property(strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic) IBOutlet UIView *contentView;
@property(strong,nonatomic) IBOutlet UITextField *textFieldFoodTruck;
@property(strong,nonatomic) IBOutlet UITextField *textFieldAt;
@property(strong,nonatomic) IBOutlet UITextField *textFieldLaterDate;
@property(strong,nonatomic) IBOutlet UITextField *textFieldUntilDate;
@property(strong,nonatomic) IBOutlet UITextField *textFieldTwitter;
@property(strong,nonatomic) IBOutlet UITextField *textFieldFacebok;
@property(strong,nonatomic) IBOutlet UIButton *btnRadioOpenNow;
@property(strong,nonatomic) IBOutlet UIButton *btnRadioWillOpenSoon;

@property (strong, nonatomic) UITextField *textFieldCurrent;

- (void)saveAction;
- (void)cancelAction;

-(IBAction)btnRadioOpenNowClicked:(id)sender;
-(IBAction)btnRadioWillOpenSoonClicked:(id)sender;

@property (nonatomic, assign) NSInteger TEXTFIELD_INDICATOR;

@property(strong, nonatomic) GeoCoder *geocoder;


@end
