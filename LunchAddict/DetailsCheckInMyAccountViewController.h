//
//  DetailsCheckInMyAccountViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 10/11/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsCheckInMyAccountViewController : UIViewController


@property (nonatomic, assign) BOOL showStatusBar;

@property (nonatomic, strong) IBOutlet UIButton *btnFacebookLogin;
@property (nonatomic, strong) IBOutlet UIButton *btnTwitterLogin;
@property (nonatomic, strong) IBOutlet UIButton *btnFacebookpost;
@property (nonatomic, strong) IBOutlet UIButton *btnTwitterpost;
@property (nonatomic, strong) IBOutlet UIButton *btnEmailShare;
@property (nonatomic, strong) IBOutlet UIButton *btnYelpShare;
@property (nonatomic, strong) IBOutlet UIButton *btnAddFoodTruck;
@property (nonatomic, strong) IBOutlet UIButton *btnShowRecentFoodTrucks;
@property (nonatomic, strong) IBOutlet UIButton *btnLogOut;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) IBOutlet UIButton *btnEditFoodtruckDetails;
@property (nonatomic, strong) IBOutlet UIButton *btnCheckIn;

@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


@property (nonatomic, strong) IBOutlet UIButton *btnRadioYES;
@property (nonatomic, strong) IBOutlet UIButton *btnRadioNO;




-(IBAction)btnFacebookLoginClicked:(id)sender;
-(IBAction)btnTwitterLoginClicked:(id)sender;
-(IBAction)btnFacebookPostClicked:(id)sender;
-(IBAction)btnTwitterPostClicked:(id)sender;
-(IBAction)btnEmailShareClicked:(id)sender;
-(IBAction)btnYelpShareClicked:(id)sender;
-(IBAction)btnAddFoodTruckClicked:(id)sender;
-(IBAction)btnShowRecentFoodTrucksClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;
-(IBAction)btnCheckInClicked:(id)sender;

-(IBAction)btnRadioYESClicked:(id)sender;
-(IBAction)btnRadioNOClicked:(id)sender;
-(IBAction)btnEditFoodtruckDetailsClicked:(id)sender;

@end
