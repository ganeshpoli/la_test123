//
//  LAAutoPinViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 04/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LAAutoPinViewController : UIViewController

@property(strong, nonatomic) IBOutlet UILabel *lableDialogMsg;

@property(strong, nonatomic) IBOutlet UIButton *btnRefreshCurrentMap;
@property(strong, nonatomic) IBOutlet UIButton *btnRefreshLastPinnedAddress;
@property(strong, nonatomic) IBOutlet UIButton *btnCancel;
@property(strong, nonatomic) IBOutlet UIButton *btnWhatisit;

-(IBAction)btnRefreshCurrentMap:(id)sender;
-(IBAction)btnRefreshLastPinnedAddress:(id)sender;
-(IBAction)btnCancel:(id)sender;
-(IBAction)btnWhatisit:(id)sender;

@property (nonatomic, assign) BOOL showStatusBar;

@property (nonatomic, strong) NSString *strAddress;

-(void)setDialogMsg;

@end
