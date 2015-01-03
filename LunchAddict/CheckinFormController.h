//
//  CheckinFormController.h
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "GeoCoder.h"
#import "LAViewController.h"
#import "GPSTracker.h"
#import "MBProgressHUD.h"

@interface CheckinFormController : UIViewController<UITextFieldDelegate, GeoCoderDelegate>{
    MBProgressHUD *hud;
    
}


@property (nonatomic, assign) BOOL showStatusBar;

@property (nonatomic, strong) NSString *strAddress;
@property (nonatomic, strong) NSString *strStreetAddress;

@property (nonatomic, strong) IBOutlet UITextField *textFieldAtLocationAddress;
@property (nonatomic, strong) IBOutlet UITextField *textFieldOnDate;
@property (nonatomic, strong) IBOutlet UITextField *textFieldFromTime;
@property (nonatomic, strong) IBOutlet UITextField *textFieldUntilTime;
@property(strong, nonatomic) IBOutlet UITextField *textFieldCurrent;

@property (nonatomic, strong) IBOutlet UIButton *btnCheckin;
@property (nonatomic, strong) IBOutlet UIButton *btnEnterMoreDetails;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;

-(IBAction)btnCheckinClicked:(id)sender;
-(IBAction)btnEnterMoreDetailsClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;

@property(strong, nonatomic) GeoCoder *geocoder;

@property(strong, nonatomic) NSNumber *numCheckInAction;

@property(assign, nonatomic) NSInteger timepickerindicator;


-(void) designView;


@end
