//
//  ShareViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 28/11/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LAViewController.h"
#import "MBProgressHUD.h"
#import "M13Checkbox.h"
#import "AppConstants.h"
#import "MZFormSheetController.h"
#import "LAAppDelegate.h"
#import "AppDatePickerViewController.h"
#import "AppMsg.h"
#import "CheckinoutVO.h"
#import "NSDate+Utils.h"
#import "AppUtil.h"

@interface ShareViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{
    MBProgressHUD *hud;
    
}

@property (nonatomic, assign) BOOL showStatusBar;
@property (nonatomic, strong) NSNumber *indicator;

@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) id obj;



@property (nonatomic, strong) IBOutlet UITextField *textFieldHashTags;
@property (nonatomic, strong) IBOutlet UITextView *textViewShareData;
@property (nonatomic, strong) IBOutlet M13Checkbox *checkBoxGoogleMapsLink;
@property (nonatomic, strong) IBOutlet M13Checkbox *checkBoxIncludeLunchAddict;

@property(strong, nonatomic) IBOutlet UITextField *textFieldCurrent;
@property(strong, nonatomic) IBOutlet UITextView *textViewCurrent;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIView *mainview;


@property (nonatomic, strong) IBOutlet UIButton *btnYesPostit;
@property (nonatomic, strong) IBOutlet UIButton *btnNoMayBeLater;

-(IBAction)btnYesPostitClicked:(id)sender;
-(IBAction)btnNoMayBeLaterClicked:(id)sender;

-(IBAction)checkBoxGoogleMapsLinkClicked:(id)sender;
-(IBAction)checkBoxIncludeLunchAddictClicked:(id)sender;

-(void) designView:(NSNumber *)indicator with:(id)dataobj;

@end
