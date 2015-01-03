//
//  AutoCheckinController.h
//  LunchAddict
//
//  Created by SPEROWARE on 27/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoCheckinController : UIViewController

@property (nonatomic, assign) BOOL showStatusBar;

@property (nonatomic, strong) IBOutlet UILabel *lblMsgTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnYesCheckin;
@property (nonatomic, strong) IBOutlet UIButton *btnMaybeLater;

-(IBAction)btnYesCheckinClicked:(id)sender;
-(IBAction)btnMaybeLaterClicked:(id)sender;




@end
