//
//  AppDatePickerViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 28/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"

@interface AppDatePickerViewController : UIViewController

@property(nonatomic, assign) NSInteger PICKER_SELECTION;
@property(nonatomic, strong) NSDate *date;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property(nonatomic, strong) IBOutlet UITextField *textFieldPicker;

@end
