//
//  LAFindSeachViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 01/01/15.
//  Copyright (c) 2015 lunchaddict. All rights reserved.
//

#import "LAFindSeachViewController.h"



#define APP_LOCATION_DATE_FORMATE   @"MMM dd yyyy hh:mm a"
#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kPickerTag              99     // view tag identifiying the date picker view

#define kDatePickerTag          100     // view tag identifiying the date picker view


#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDataKey        @"data"    // key for obtaining the data source item's date value



// keep track of which rows have date cells
#define kPickerStartRow   0
#define kPickerEndRow     1

#define kClickableTextlableCell     50

#define kSection0     0
#define kSection1     1


#define kSectionHeight  15.0

static NSString *kDetailsCellID         = @"detailsCell";
static NSString *kPickerID              = @"pickerCell";
static NSString *ktextLableCell         = @"textlabelCell";
static NSString *ktextFieldCell         = @"textFieldCell";
static NSString *kswitchCell            = @"switchCell";
static NSString *kDatePickerID          = @"datePicker";

#define KPICkerCellSearchOpts 200
#define KPickerCellSearchOpts 300



#define SEARCH_OPTIONS_PICKER_VIEW 0
#define PAST_ADDRESS_PICKER_VIEW   1


#define kDateStartRow   1
#define kDateEndRow     2


@interface LAFindSeachViewController ()

@end

@implementation LAFindSeachViewController

@synthesize userOptionsDataSection0;
@synthesize dataSection0;
@synthesize dataSection1;
@synthesize nearItem;
@synthesize useGPSitem;
@synthesize data;
@synthesize pickerViewCellRowHeight;
@synthesize pickerIndexPath;
@synthesize byNameitem;
@synthesize currentMapitem;
@synthesize openDateitem;
@synthesize openNowitem;
@synthesize willOpenSoonitem;
@synthesize dateFormator;
@synthesize pastAddressItem;
@synthesize searchByitem;
@synthesize searchByDate;
@synthesize isOpenNow;
@synthesize arrPastAddress;
@synthesize textFieldCurrent;
@synthesize pickerArray;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isOpenNow = YES;
    
    UIBarButtonItem *searchBarButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(saveAction)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = searchBarButton;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    self.dateFormator = [[NSDateFormatter alloc] init];
    [self.dateFormator setDateFormat:APP_LOCATION_DATE_FORMATE];    // show short-style date format
    
    
    self.arrPastAddress = [@[@"Select Address",@"past address2",@"past address3",@"past address4"] mutableCopy];
    
    
    self.nearItem= [@{ kTitleKey : @"Address", kDataKey:@"Enter Address"} mutableCopy];
    self.pastAddressItem = [@{ kTitleKey : @"Past Address", kDataKey:@""} mutableCopy];
    
    
    self.useGPSitem = [@{ kTitleKey : @"Device Gps", kDataKey:@""} mutableCopy];
    self.currentMapitem = [@{ kTitleKey : @"Current Map Position", kDataKey:@""} mutableCopy];
    self.byNameitem = [@{ kTitleKey : @"Food Truck Name/ID", kDataKey:@"Food Truck Name/ID, like Twitter"} mutableCopy];
    
    self.openNowitem = [@{ kTitleKey : @"Open Now"} mutableCopy];
    self.openDateitem = [@{ kTitleKey : @"Select Date", kDataKey:[NSDate date] } mutableCopy];
    
    //self.nearItem= [@{ kTitleKey : @"Near", kDataKey:@""} mutableCopy];
    
    self.searchByitem= [@{ kTitleKey : @"Search With", kDataKey:@"Address"} mutableCopy];
    
    self.dataSection0 = @[self.searchByitem, self.nearItem];
    
    self.dataSection1 = @[self.openNowitem];
    
    self.data = [[NSMutableDictionary alloc] init];
    
    [self.data setObject:self.dataSection0 forKey:@"0"];
    [self.data setObject:self.dataSection1 forKey:@"1"];
    
    self.userOptionsDataSection0 = @[@"Address",@"Past Address",@"Device Gps",@"Current Map Position",@"Food Truck Name/ID"];
    //self.userOptionsDataSection1 = @[@"Open Now",@"Will OpenSoon",@"Open Date"];
    
    
    
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kPickerID];
    self.pickerViewCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    
    
    
    UITableViewCell *datepickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.datepickerCellRowHeight = CGRectGetHeight(datepickerViewCellToCheck.frame);
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}





- (void)saveAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - picker view

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerIndexPath.row == 2) {
        self.pickerArray = self.arrPastAddress;
    }else{
        self.pickerArray = self.userOptionsDataSection0;
    }
    
    return self.pickerArray.count;
    
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerIndexPath.row == 2) {
        self.pickerArray = self.arrPastAddress;
    }else{
        self.pickerArray = self.userOptionsDataSection0;
    }
    
    return self.pickerArray[row];
    NSLog(@"data = %@", self.pickerIndexPath);
   
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlinePickerView])
    {
        
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.pickerIndexPath.row - 1 inSection:self.pickerIndexPath.section];
    }
    else
    {
        
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    
    
    // update our data model
    NSArray *dataArray = [self.data objectForKey:[NSString stringWithFormat:@"%ld",(long)targetedCellIndexPath.section]];
    
    NSMutableDictionary *itemData = dataArray[targetedCellIndexPath.row];
    
    
    if (targetedCellIndexPath.section == 0) {
        switch (targetedCellIndexPath.row) {
            case SEARCH_OPTIONS_PICKER_VIEW:{
                
                 NSString *strSelected = [self.userOptionsDataSection0 objectAtIndex:row];
                
                [itemData setValue:[self.userOptionsDataSection0 objectAtIndex:row] forKey:kDataKey];
                
                // update the cell's date string
                cell.detailTextLabel.text = [self.userOptionsDataSection0 objectAtIndex:row];
                
                
                self.dataSection0 = nil;
                
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                if ([strSelected isEqualToString:@"Device Gps"] || [strSelected isEqualToString:@"Current Map Position"]) {
                    
                    self.dataSection0 = @[self.searchByitem];
                }else if ([strSelected isEqualToString:@"Address"]){
                     self.navigationItem.rightBarButtonItem.enabled = NO;
                     self.dataSection0 = @[self.searchByitem, self.nearItem];
                }else if ([strSelected isEqualToString:@"Food Truck Name/ID"]){
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    self.dataSection0 = @[self.searchByitem, self.byNameitem];
                }else if ([strSelected isEqualToString:@"Past Address"]){
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    self.dataSection0 = @[self.searchByitem, self.pastAddressItem];
                }
                
                [self.data setObject:self.dataSection0 forKey:@"0"];
                
                [self.tableView reloadData];
            }
                break;
                
            case PAST_ADDRESS_PICKER_VIEW:{
                [itemData setValue:[self.arrPastAddress objectAtIndex:row] forKey:kDataKey];
                
                NSString *strSelecedValue = [self.arrPastAddress objectAtIndex:row];
                
                if ([strSelecedValue isEqualToString:@"Select Address"]) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                }else{
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                }
                
                // update the cell's date string
                cell.textLabel.text = [self.arrPastAddress objectAtIndex:row];
            }
                break;
                
            default:
                break;
        }
    }
    
}




- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textfield did end editting");
    textFieldCurrent    = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textfield did begin editting");
    textFieldCurrent = textField;
    [self deletePickerView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] + [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] - range.length;
    
    if (newLength > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    return YES;
}



//=================================================================================================

- (BOOL)hasDatePickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:1]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            
            NSDictionary *itemData = self.dataSection1[self.datePickerIndexPath.row - 1];
            //NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kDataKey] animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasDatePicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
    {
        hasDate = YES;
    }
    
    return hasDate;
}

//================================================================================================================


- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasPicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkPickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:indexPath.section]];
    UIPickerView *checkPickerView = (UIPickerView *)[checkPickerCell viewWithTag:kPickerTag];
    
    hasPicker = (checkPickerView != nil);
    return hasPicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updatePickerView:(NSInteger)section
{
    if (self.pickerIndexPath != nil)
    {
        UITableViewCell *associatedPickerCell = [self.tableView cellForRowAtIndexPath:self.pickerIndexPath];
        
        UIPickerView *targetedPicker = (UIPickerView *)[associatedPickerCell viewWithTag:kPickerTag];
        
        if (targetedPicker != nil)
        {
            // we found a UIPicker in this cell, so update it's date value
            //
            [targetedPicker reloadAllComponents];
            NSDictionary *itemData = [self.data objectForKey:[NSString stringWithFormat:@"%ld",(long)section]];
            
            NSString *str = [itemData valueForKey:kDataKey];
            
            [targetedPicker selectRow:[self.pickerArray indexOfObject:str] inComponent:0 animated:NO];
            
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlinePickerView
{
    return (self.pickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIPicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIPicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ([self hasInlinePickerView] && self.pickerIndexPath.row == indexPath.row);
    }else{
        return NO;
    }
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasItem:(NSIndexPath *)indexPath
{
    BOOL hasPicker = NO;
    
    if (indexPath.section == 0) {
        if ((indexPath.row == kPickerStartRow) || (([self hasInlinePickerView] && (indexPath.row == kPickerEndRow + 1))))
        {
            hasPicker = YES;
        }
    }else{
        if ((indexPath.row == kPickerEndRow))
        {
            hasPicker = YES;
        }
    }
    
    
    
    return hasPicker;
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ([self indexPathHasPicker:indexPath] ? self.pickerViewCellRowHeight : self.tableView.rowHeight);
    }else{
        return ([self indexPathHasDatePicker:indexPath] ? self.datepickerCellRowHeight : self.tableView.rowHeight);
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *dataArray = [self.data objectForKey:[NSString stringWithFormat:@"%ld",(long)section]];
    
    if (section == kSection0 && [self hasInlinePickerView])
    {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows = dataArray.count;
        return ++numRows;
    }else if (section == kSection1 && [self hasInlineDatePicker]){
        NSInteger numRows = dataArray.count;
        return ++numRows;
    }
    
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (textFieldCurrent != nil) {
        [textFieldCurrent resignFirstResponder];
        textFieldCurrent = nil;
    }
    
    NSString *cellID = ktextLableCell;
    
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    
    NSArray *dataArray = [data objectForKey:str];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cellID = kDetailsCellID;
        }else{
            NSMutableDictionary *itemdata = [dataArray objectAtIndex:indexPath.section];
            
            NSString *strData = [itemdata objectForKey:kDataKey];
            
            if ([strData isEqualToString:@"Address"]
                || [strData isEqualToString:@"Food Truck Name/ID"]) {
                cellID = ktextFieldCell;
            }
        }
    }
    
    
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker
        cellID = kPickerID;
    }else if ([self indexPathHasDatePicker:indexPath]){
        cellID = kDatePickerID;     // the current/opened date picker cell
    }else if(indexPath.section==1){
        NSMutableDictionary *itemdata = [dataArray objectAtIndex:indexPath.row];
        
        NSString *strData = [itemdata objectForKey:kTitleKey];
        
        if ([strData isEqualToString:@"Open Now"]) {
            cellID = kswitchCell;
        }else{
            cellID = kDetailsCellID;       // the start/end date cells
        }
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //    if (indexPath.row == 0)
    //    {
    //        // we decide here that first cell in the table is not selectable (it's just an indicator)
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    }
    
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    //
    NSInteger modelRow = indexPath.row;
    if ((indexPath.section == 0 && self.pickerIndexPath != nil && self.pickerIndexPath.row <= indexPath.row) ||
        (indexPath.section == 1 && self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row))
    {
        modelRow--;
    }
    
    NSDictionary *itemData = dataArray[modelRow];
    
    //NSDictionary *itemData = self.dataArray[modelRow];
    
    // proceed to configure our cell
    if ([cellID isEqualToString:kDetailsCellID])
    {
        // we have either start or end date cells, populate their date field
        //
        cell.textLabel.text = [itemData valueForKey:kTitleKey];
        
        NSObject *dataitem = [itemData valueForKey:kDataKey];
        
        if ([dataitem isKindOfClass:[NSString class]]) {
            cell.detailTextLabel.text = [itemData valueForKey:kDataKey];
        }else if ([dataitem isKindOfClass:[NSDate class]]){
            cell.detailTextLabel.text = [self.dateFormator stringFromDate:[itemData valueForKey:kDataKey]];
        }
        
    }
    else if ([cellID isEqualToString:ktextFieldCell])
    {
        // this cell is a non-date cell, just assign it's text label
        
        SearchTextFieldCell *textCell = (SearchTextFieldCell *)cell;
        
        textCell.textField.placeholder = [itemData valueForKey:kDataKey];
        textCell.textField.text = @"";
        
        NSString *tag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        
        [textCell.textField setTag:[tag integerValue]];
        
        textCell.textField.borderStyle = UITextBorderStyleNone;
        textCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else if ([cellID isEqualToString:ktextLableCell])
    {
        
        [itemData setValue:[self.arrPastAddress objectAtIndex:0] forKey:kDataKey];
        
        // update the cell's date string
        cell.textLabel.text = [self.arrPastAddress objectAtIndex:0];
        
        //cell.textLabel.text = [itemData valueForKey:kTitleKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if ([cellID isEqualToString:kswitchCell])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        FinderSwitchCell *switchCell = (FinderSwitchCell *)cell;
        switchCell.lable.text = [itemData valueForKey:kTitleKey];
        switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if ([cellID isEqualToString:kPickerID])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        PickerCell *pickercell = (PickerCell *)cell;
        [pickercell.pickerView reloadAllComponents];
        
        if (self.pickerArray != nil && self.pickerArray.count > 0) {
            
            NSInteger index = [self.pickerArray indexOfObject:[itemData valueForKey:kDataKey]];
            
            [pickercell.pickerView selectRow:index inComponent:0 animated:NO];
        }
    }
    else if ([cellID isEqualToString:kDatePickerID])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        DatePickerCell *pickercell = (DatePickerCell *)cell;
        
        [pickercell.datePicker setDate:[itemData valueForKey:kDataKey]];
    }
    
    
    
	return cell;
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)togglePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlinePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlinePickerView])
    {
        before = self.pickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.pickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlinePickerView])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.pickerIndexPath.row inSection:indexPath.section]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.pickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:indexPath.section];
        
        [self togglePickerForSelectedIndexPath:indexPathToReveal];
        self.pickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:indexPath.section];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updatePickerView:indexPath.section];
}

/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath used to display the UIDatePicker.
 */



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDetailsCellID || cell.reuseIdentifier == ktextLableCell)
    {
        if (indexPath.section == 0) {
            [self displayInlinePickerForRowAtIndexPath:indexPath];
        }else{
            [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


-(IBAction)switchBtnValueChanged:(id)sender{
    UISwitch *switchbtn = (UISwitch *)sender;
    
    NSLog(@"Switch is executed");
    
    if ([switchbtn isOn]) {
        isOpenNow = YES;
    }else{
        isOpenNow = NO;
        NSDate *date = [NSDate date];
        NSTimeInterval secondsIn1Hours = 1 * 60 * 60;
        NSDate *dateNextHour = [date dateByAddingTimeInterval:secondsIn1Hours];
        
        [self.openDateitem setObject:dateNextHour forKey:kDataKey];
    }
    
    
    [self deleteDatePicker];
    
    if (self.isOpenNow) {
        self.dataSection1 = @[self.openNowitem];
        [self.data setObject:self.dataSection1 forKey:@"1"];
    }else{
        self.dataSection1 = @[self.openNowitem, self.openDateitem];
        [self.data setObject:self.dataSection1 forKey:@"1"];
    }    
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 2*kSectionHeight;
    }
    
    return kSectionHeight;
}





/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasDatePickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:1]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:1];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:1];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}



- (void)deleteDatePicker
{
    if (self.datePickerIndexPath != nil) {
        [self.tableView beginUpdates];
        // remove any date picker cell if it exists
        if ([self hasInlineDatePicker])
        {
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:self.datePickerIndexPath.section]]
                                  withRowAnimation:UITableViewRowAnimationFade];
            self.datePickerIndexPath = nil;
        }
        
        
        [self.tableView endUpdates];
    }
    
}


- (void)deletePickerView
{
    if (self.pickerIndexPath != nil) {
        [self.tableView beginUpdates];
        // remove any date picker cell if it exists
        if ([self hasInlinePickerView])
        {
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.pickerIndexPath.row inSection:self.pickerIndexPath.section]]
                                  withRowAnimation:UITableViewRowAnimationFade];
            self.pickerIndexPath = nil;
        }
        
        
        [self.tableView endUpdates];
    }
    
}



- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:1];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    NSArray *dataArray = [self.data objectForKey:[NSString stringWithFormat:@"%ld",(long)targetedCellIndexPath.section]];
    
    NSMutableDictionary *itemData = dataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kDataKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormator stringFromDate:targetedDatePicker.date];
}



@end
