//
//  LAAddFdTableViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 30/12/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LAAddFdTableViewController.h"

#define APP_LOCATION_DATE_FORMATE   @"MMM dd yyyy hh:mm a"
#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDataKey        @"date"    // key for obtaining the data source item's date value



// keep track of which rows have date cells
#define kDateStartRow   1
#define kDateEndRow     2
#define kDateSection    2

#define kSectionHeight  15.0

static NSString *kDateCellID    = @"dateCell";
static NSString *kDatePickerID  = @"datePicker";
static NSString *ktextCell      = @"textCell";
static NSString *kswitchCell    = @"switchCell";
static NSString *klableCell     = @"lableCell";
static NSString *klocationCell  = @"locationCell";



@interface LAAddFdTableViewController ()

@end

@implementation LAAddFdTableViewController

@synthesize dataSection00;
@synthesize dataSection01;
@synthesize data;
@synthesize datePickerIndexPath;
@synthesize pickerCellRowHeight;
@synthesize pickerView;
@synthesize doneButton;
@synthesize dateFormator;
@synthesize isOpenNow;
@synthesize foodTruckNameOrID;
@synthesize location;
@synthesize openNow;
@synthesize openAt;
@synthesize closeAt;
@synthesize foodTruckTwitterHandle;
@synthesize dataSection20;
@synthesize dataSection21;
@synthesize dataSection1;
@synthesize locationAddressIndexPath;
@synthesize textFieldCurrent;
@synthesize twitterHandlerIndexPath;
@synthesize foodtruckNameIndexPath;

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
    // setup our data source
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIBarButtonItem *addBarButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(saveAction)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = addBarButton;   
    
    self.isOpenNow = YES;
    
    
    self.foodTruckNameOrID = [@{ kTitleKey : @"Food Truck Name or ID", kDataKey:@"" } mutableCopy];
    self.location = [@{ kTitleKey : @"Location", kDataKey:@"Glade Drive, Reston, VA 20191, USA" } mutableCopy];
    
    self.resetGPSAddress = [@{ kTitleKey : @"GPSAddress", kDataKey:@"Glade Drive, Reston, VA 20191, USA" } mutableCopy];
    
    self.openNow = [@{ kTitleKey : @"Open Now", kDataKey:@"" } mutableCopy];
    
    self.openAt  = [@{ kTitleKey : @"Open at", kDataKey:[NSDate date] } mutableCopy];
    self.closeAt= [@{ kTitleKey : @"Close at", kDataKey:[NSDate date] } mutableCopy];
    
    self.foodTruckTwitterHandle = [@{ kTitleKey : @"Food Truck Twitter Handle(optional)", kDataKey:@"" } mutableCopy];
    
    NSMutableDictionary *resetGpsBtnItem = [@{ kTitleKey : @"GpsBtn", kDataKey:@"" } mutableCopy];
   
   
    self.dataSection00 = @[self.foodTruckNameOrID];
    self.dataSection01 = @[self.foodTruckNameOrID,self.foodTruckTwitterHandle];
    self.dataSection1 = @[self.location, resetGpsBtnItem];
    self.dataSection20 =  @[self.openNow,self.closeAt];
    self.dataSection21 =  @[self.openNow,self.openAt,self.closeAt];
    
    
    
    self.data = [[NSMutableDictionary alloc] init];
    
    [self.data setObject:self.dataSection01 forKey:@"0"];
    
    if (self.isOpenNow) {
        [self.data setObject:self.dataSection20 forKey:@"2"];
    }else{
        [self.data setObject:self.dataSection21 forKey:@"2"];
    }
    
    [self.data setObject:self.dataSection1 forKey:@"1"];
    
    self.dateFormator = [[NSDateFormatter alloc] init];
    [self.dateFormator setDateFormat:APP_LOCATION_DATE_FORMATE];    // show short-style date format
    
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    
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


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}


#pragma mark - Utilities

/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion =
        [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] integerValue];
    });
    
    return _deviceSystemMajorVersion;
}

#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:indexPath.section]];
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
            //
            
            NSDictionary *itemData;
            
            if (self.isOpenNow) {
                itemData = self.dataSection20[self.datePickerIndexPath.row - 1];
            }else{
                itemData = self.dataSection21[self.datePickerIndexPath.row - 1];
            }
            
            //NSDictionary *itemData = self.dataSection11[self.datePickerIndexPath.row - 1];
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
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if (indexPath.section != kDateSection) {
        return hasDate;
    }
    
    
    if (self.isOpenNow) {
        
        if ((indexPath.row == kDateStartRow) || (([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
        {
            hasDate = YES;
        }
        
    }else{
        if ((indexPath.row == kDateStartRow) ||
            (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
        {
            hasDate = YES;
        }
    }
        
    
    
    return hasDate;
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *dataArray = [self.data objectForKey:[NSString stringWithFormat:@"%ld",(long)section]];
    
    if (section ==kDateSection && [self hasInlineDatePicker])
    {
        // we have a date picker, so allow for it in the number of rows in this section
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
    
    NSString *cellID = ktextCell;
    
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker
        cellID = kDatePickerID;     // the current/opened date picker cell
    }
    else if ([self indexPathHasDate:indexPath])
    {
        // the indexPath is one that contains the date information
        cellID = kDateCellID;       // the start/end date cells
    }
    
    
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row)
    {
        modelRow--;
    }
    
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    
    NSArray *dataArray = [data objectForKey:str];
    
    NSDictionary *itemData = dataArray[modelRow];
    
    NSString *strItem = [itemData valueForKey:kTitleKey];
    
    if ([strItem isEqualToString:@"Open Now"]) {
        cellID = kswitchCell;
    }else if([strItem isEqualToString:@"Location"]){
        cellID = klocationCell;
    }else if([strItem isEqualToString:@"GpsBtn"]){
        cellID = klableCell;
    }
    
    
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // proceed to configure our cell
    if ([cellID isEqualToString:kDateCellID])
    {
        // we have either start or end date cells, populate their date field
        //
        cell.textLabel.text = [itemData valueForKey:kTitleKey];
        cell.detailTextLabel.text = [self.dateFormator stringFromDate:[itemData valueForKey:kDataKey]];
    }
    else if ([cellID isEqualToString:ktextCell])
    {
        // this cell is a non-date cell, just assign it's text label
        
        TextfieldCell *textCell = (TextfieldCell *)cell;
        
        NSString *tag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        
        [textCell.textField setTag:[tag integerValue]];
        
        [textCell.textField setPlaceholder:[itemData valueForKey:kTitleKey]];
        
        textCell.textField.borderStyle = UITextBorderStyleNone;
        
        textCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if ([@"Food Truck Name or ID" isEqualToString:[itemData valueForKey:kTitleKey]]) {
            self.foodtruckNameIndexPath = indexPath;
        }else if ([@"Food Truck Twitter Handle(optional)" isEqualToString:[itemData valueForKey:kTitleKey]]){
            self.twitterHandlerIndexPath = indexPath;
        }
        
    }
    else if ([cellID isEqualToString:kswitchCell])
    {
        // this cell is a non-date cell, just assign it's text label
        //
         SwitchCell *switchCell = (SwitchCell *)cell;
         switchCell.lable.text = [itemData valueForKey:kTitleKey];
         switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if ([cellID isEqualToString:klocationCell])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        LocationCell *locationCell = (LocationCell *)cell;
        locationCell.textfield.placeholder = [itemData valueForKey:kTitleKey];
        locationCell.textfield.text = [itemData valueForKey:kDataKey];
        locationCell.textfield.borderStyle = UITextBorderStyleNone;
        self.locationAddressIndexPath = indexPath;
        
        locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else if ([cellID isEqualToString:klableCell])
    {
        // this cell is a non-date cell, just assign it's text label
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else if ([cellID isEqualToString:kDatePickerID])
    {
        AddLocDatePickerCell *datePickerCell = (AddLocDatePickerCell *)cell;
        
        [datePickerCell.datePicker setDate:[itemData valueForKey:kDataKey]animated:NO];
        
    }
    
    
    
	return cell;
}



-(IBAction)switchBtnValueChanged:(id)sender{
    UISwitch *switchbtn = (UISwitch *)sender;
    
    NSLog(@"Switch is executed");
    
    if ([switchbtn isOn]) {
        isOpenNow = YES;
    }else{
        isOpenNow = NO;
    }
    
    [self deleteDatePicker];
    
    if (self.isOpenNow) {
        [self.data setObject:self.dataSection20 forKey:@"2"];
    }else{
        [self.data setObject:self.dataSection21 forKey:@"2"];
    }
    
    [self.tableView reloadData];
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
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
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:indexPath.section]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:indexPath.section];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:indexPath.section];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath used to display the UIDatePicker.
 */
- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    
    NSArray *dataArray = [self.data objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    NSDictionary *itemData = dataArray[indexPath.row];
    [self.pickerView setDate:[itemData valueForKey:kDataKey] animated:YES];
    
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = CGRectGetHeight(self.view.frame);
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - CGRectGetHeight(endFrame);
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
                             self.navigationItem.rightBarButtonItem = self.doneButton;
                         }];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 2*kSectionHeight;
    }
    
    return kSectionHeight;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID)
    {
        if (EMBEDDED_DATE_PICKER)
            [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        else
            [self displayExternalDatePickerForRowAtIndexPath:indexPath];
    }else if (indexPath.section ==1 && indexPath.row ==1){
        [self resetGpsAddress];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)resetGpsAddress{
    NSLog(@"Reset Gps btn clicked");
    
    if (self.locationAddressIndexPath != nil) {
        LocationCell *cell = (LocationCell *)[self.tableView cellForRowAtIndexPath:self.locationAddressIndexPath];
        cell.textfield.text = [self.resetGPSAddress valueForKey:kDataKey];
    }
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  NO;
}


#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:self.datePickerIndexPath.section];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    
    NSArray *dataArray = [self.data objectForKey:[NSString stringWithFormat:@"%ld",(long)targetedCellIndexPath.section]];
    
    NSMutableDictionary *itemData = dataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kDataKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormator stringFromDate:targetedDatePicker.date];
}


/*! User chose to finish using the UIDatePicker by pressing the "Done" button
 (used only for "non-inline" date picker, iOS 6.1.x or earlier)
 
 @param sender The sender for this action: The "Done" UIBarButtonItem
 */
- (IBAction)doneAction:(id)sender
{
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = CGRectGetHeight(self.view.frame);
    
    // animate the date picker out of view
    [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = pickerFrame; }
                     completion:^(BOOL finished) {
                         [self.pickerView removeFromSuperview];
                     }];
    
    // remove the "Done" button in the navigation bar
	self.navigationItem.rightBarButtonItem = nil;
    
    // deselect the current table cell
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textfield did end editting");
    textFieldCurrent    = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textfield did begin editting");
    
    textFieldCurrent = textField;
    [self deleteDatePicker];
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"%d",textField.tag);
    return YES;
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





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
