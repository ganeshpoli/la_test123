//
//  AutoCheckOutViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckinoutVO.h"

@interface AutoCheckOutViewController : UIViewController

@property (nonatomic, assign) BOOL showStatusBar;

@property (nonatomic, strong) IBOutlet UILabel *lblMsgTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnCheckout;
@property (nonatomic, strong) IBOutlet UIButton *btnEditCheckinDetails;
@property (nonatomic, strong) IBOutlet UIButton *btnLetMeBrowseArround;
@property (nonatomic, strong) CheckinoutVO  *checkinOutVO;

-(void) designView;

-(IBAction)btnCheckoutClicked:(id)sender;
-(IBAction)btnEditCheckinDetailsClicked:(id)sender;
-(IBAction)btnLetMeBrowseArroundClicked:(id)sender;

@end
