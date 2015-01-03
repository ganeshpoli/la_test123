//
//  LAPinMeViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 30/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "LAPastAddressViewController.h"
#import "GeoCoder.h"
#import "LAViewController.h"
#import "GPSTracker.h"
#import "MBProgressHUD.h"

@interface LAPinMeViewController : UIViewController<UITextFieldDelegate, GeoCoderDelegate, GPSTrackerDelegate>{
    MBProgressHUD *hud;
    
}


@property(strong, nonatomic) IBOutlet UITextField *textFieldPinMeAddress;
@property(strong, nonatomic) IBOutlet UITextField *textFieldPastAdress;
@property(strong, nonatomic) IBOutlet UITextField *textFieldCurrent;
@property(strong, nonatomic) NSMutableArray *arrPastAddress;
@property (nonatomic, assign) BOOL showStatusBar;

@property(strong, nonatomic) IBOutlet UIButton *btnGo;
@property(strong, nonatomic) IBOutlet UIButton *btnReset;
@property(strong, nonatomic) IBOutlet UIButton *btnCancel;

@property(strong, nonatomic) IBOutlet UILabel *labelGpsNotAvaliable;

//@property(strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property(strong, nonatomic) GeoCoder *geocoder;
@property(strong, nonatomic) GPSTracker *gpsTracker;
//@property(strong, nonatomic) LAViewController *mainViewController;

@property(assign, nonatomic) BOOL GPS_UPDATE;

-(IBAction)goBtnClicked:(id)sender;
-(IBAction)resetBtnClicked:(id)sender;
-(IBAction)cancelBtnClicked:(id)sender;

@end
