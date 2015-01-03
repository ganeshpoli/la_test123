//
//  AppDatePickerViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 28/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "AppDatePickerViewController.h"
#import "AppConstants.h"

@interface AppDatePickerViewController ()

@end

@implementation AppDatePickerViewController

@synthesize PICKER_SELECTION;
@synthesize datePicker;
@synthesize date;
@synthesize textFieldPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.datePicker setDate:self.date];
    
    switch (self.PICKER_SELECTION) {
        case DATE_PICKER:{
            [self.datePicker setDatePickerMode:UIDatePickerModeDate];
            [self.datePicker setMinimumDate:[NSDate date]];
        }
        break;
        
        case TIME_PICKER:{
           [self.datePicker setDatePickerMode:UIDatePickerModeTime];
        }
        break;
        
        default:
        break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
