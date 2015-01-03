//
//  LAPastAddressViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 30/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LAPastAddressViewController.h"

@interface LAPastAddressViewController () 
@end

@implementation LAPastAddressViewController

@synthesize pickerView;
@synthesize arrPicker;
@synthesize strSelection;

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
    self.pickerView.delegate    = self;
    self.pickerView.dataSource  = self;
    
    NSInteger selectedrow   = [self.arrPicker indexOfObject:strSelection];
    
    [self.pickerView selectRow:selectedrow inComponent:0 animated:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.arrPicker count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.arrPicker objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen{
    
    self.strSelection   = (NSString *)[self.arrPicker objectAtIndex:row];
    
    NSLog(@"%@",self.strSelection);
}




@end
