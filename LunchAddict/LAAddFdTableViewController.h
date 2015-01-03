//
//  LAAddFdTableViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 30/12/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextfieldCell.h"
#import "SwitchCell.h"
#import "LocationCell.h"
#import "AddLocDatePickerCell.h"

@interface LAAddFdTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataSection00;
@property (nonatomic, strong) NSArray *dataSection01;
@property (nonatomic, strong) NSArray *dataSection20;
@property (nonatomic, strong) NSArray *dataSection21;
@property (nonatomic, strong) NSArray *dataSection1;

@property (nonatomic, strong) NSMutableDictionary *foodTruckNameOrID;
@property (nonatomic, strong) NSMutableDictionary *location;
@property (nonatomic, strong) NSMutableDictionary *openNow;
@property (nonatomic, strong) NSMutableDictionary *openAt;
@property (nonatomic, strong) NSMutableDictionary *closeAt;
@property (nonatomic, strong) NSMutableDictionary *foodTruckTwitterHandle;
@property (nonatomic, strong) NSMutableDictionary *resetGPSAddress;

@property (nonatomic, strong) IBOutlet UITextField *textFieldCurrent;




@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, assign) BOOL isOpenNow;

@property (nonatomic, strong) NSDateFormatter *dateFormator;


// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (nonatomic, strong) NSIndexPath *locationAddressIndexPath;


@property (nonatomic, strong) NSIndexPath *foodtruckNameIndexPath;
@property (nonatomic, strong) NSIndexPath *twitterHandlerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;

// this button appears only when the date picker is shown (iOS 6.1.x or earlier)
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

-(IBAction)doneAction:(id)sender;

-(IBAction)dateAction:(id)sender;

-(IBAction)switchBtnValueChanged:(id)sender;


@end
