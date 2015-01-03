//
//  LAPastAddressViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 30/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"

@interface LAPastAddressViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *arrPicker;
@property (nonatomic, strong) NSString *strSelection;

@end
