//
//  LAFindSeachViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 01/01/15.
//  Copyright (c) 2015 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTextFieldCell.h"
#import "FinderSwitchCell.h"
#import "PickerCell.h"
#import "DatePickerCell.h"

@interface LAFindSeachViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataSection0;
@property (nonatomic, strong) NSArray *dataSection1;




@property (nonatomic, strong) NSArray *userOptionsDataSection0;
//@property (nonatomic, strong) NSArray *userOptionsDataSection1;

@property (nonatomic, strong) NSArray *pickerArray;

@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, strong) NSDateFormatter *dateFormator;

@property (nonatomic, strong) NSMutableArray *arrPastAddress;

@property (nonatomic, strong) NSMutableDictionary *nearItem;
@property (nonatomic, strong) NSMutableDictionary *pastAddressItem;
@property (nonatomic, strong) NSMutableDictionary *useGPSitem;
@property (nonatomic, strong) NSMutableDictionary *currentMapitem;
@property (nonatomic, strong) NSMutableDictionary *byNameitem;
@property (nonatomic, strong) NSMutableDictionary *openNowitem;
@property (nonatomic, strong) NSMutableDictionary *willOpenSoonitem;
@property (nonatomic, strong) NSMutableDictionary *openDateitem;

@property (nonatomic, strong) NSMutableDictionary *searchByitem;
@property (nonatomic, strong) NSMutableDictionary *searchByDate;

@property (nonatomic, assign) BOOL isOpenNow;

@property (nonatomic, strong) IBOutlet UITextField *textFieldCurrent;


// keep track which indexPath points to the cell with UIDatePicker
//@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (nonatomic, strong) NSIndexPath *pickerIndexPath;

@property (assign) NSInteger pickerViewCellRowHeight;

-(IBAction)switchBtnValueChanged:(id)sender;


@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger datepickerCellRowHeight;

- (IBAction)dateAction:(id)sender;





@end
