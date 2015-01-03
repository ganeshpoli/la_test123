//
//  LAAddFdViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 03/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSTracker.h"
#import "GeoCoder.h"
#import "MBProgressHUD.h"
#import "LAAppDelegate.h"
#import "RestApiWorker.h"

@interface LAAddFdViewController : UIViewController<UITextFieldDelegate, GeoCoderDelegate, RestAPIWorkerDelegate>{
    MBProgressHUD *hud;
    
}

@property(strong, nonatomic) IBOutlet UITextField *textFieldTwitter;
@property(strong, nonatomic) IBOutlet UITextField *textFieldAt;
@property(strong, nonatomic) IBOutlet UITextField *textFieldCurrent;

@property(strong, nonatomic) IBOutlet UIButton *btnOk;
@property(strong, nonatomic) IBOutlet UIButton *btnGps;
@property(strong, nonatomic) IBOutlet UIButton *btnCancel;
@property(strong, nonatomic) GeoCoder *geocoder;
@property(strong, nonatomic) GPSTracker *gpsTracker;


@property(strong, nonatomic) NSString *strUserTapedAddress;
@property(strong, nonatomic) NSString *strPartialAddress;

@property (nonatomic, assign) BOOL showStatusBar;

-(IBAction)okBtnClicked:(id)sender;
-(IBAction)GpsBtnClicked:(id)sender;
-(IBAction)cancelBtnClicked:(id)sender;


@end
