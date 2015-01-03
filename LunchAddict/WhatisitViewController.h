//
//  WhatisitViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 04/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatisitViewController : UIViewController

@property(strong, nonatomic) IBOutlet UILabel *lableDialogMsg;
@property(strong, nonatomic) IBOutlet UIButton *btnok;

-(IBAction)btnOk:(id)sender;

@property (nonatomic, assign) BOOL showStatusBar;

@property (nonatomic, strong) NSString *strAddress;

-(void)setDialogMsg;

@end
