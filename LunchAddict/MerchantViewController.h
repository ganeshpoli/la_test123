//
//  MerchantViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantViewController : UIViewController

@property (nonatomic, assign) BOOL showStatusBar;

@property (nonatomic, strong) NSString *strMerchantName;

- (void) designView;


@property (nonatomic, strong) IBOutlet UILabel *lblMsgTitle;

@property (nonatomic, strong) IBOutlet UIButton *btnYesLoginCheckin;
@property (nonatomic, strong) IBOutlet UIButton *btnYesLogin;
@property (nonatomic, strong) IBOutlet UIButton *btnMaybelater;

-(IBAction)btnYesLoginCheckinClicked:(id)sender;
-(IBAction)btnYesLoginClicked:(id)sender;
-(IBAction)btnMaybelaterClicked:(id)sender;

@end
