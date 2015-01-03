//
//  CheckOutConfirmController.h
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckinoutVO.h"

@interface CheckOutConfirmController : UIViewController

@property (nonatomic, assign) BOOL showStatusBar;

@property (nonatomic, strong) CheckinoutVO *checkinVO;
@property (nonatomic, strong) IBOutlet UIButton *btnYes;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;

-(IBAction)btnYesClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;


@end
