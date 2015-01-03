//
//  TokenStatusController.h
//  LunchAddict
//
//  Created by SPEROWARE on 22/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenCacheVO.h"

@interface TokenStatusController : UIViewController

@property(strong, nonatomic) IBOutlet UIButton *btnYes;
@property(strong, nonatomic) IBOutlet UIButton *btnNo;
@property(strong, nonatomic) IBOutlet UIButton *btnSupportMail;

@property(strong, nonatomic) IBOutlet UILabel *lblMsg;

@property(strong, nonatomic) TokenCacheVO *tokenCacheVO;

@property (nonatomic, assign) BOOL showStatusBar;

-(IBAction)btnYesClicked:(id)sender;
-(IBAction)btnNoClicked:(id)sender;
-(IBAction)btnSupportMailClicked:(id)sender;

-(void)designView;

@end
