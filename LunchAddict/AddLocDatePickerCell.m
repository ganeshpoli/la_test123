//
//  AddLocDatePickerCell.m
//  LunchAddict
//
//  Created by SPEROWARE on 03/01/15.
//  Copyright (c) 2015 lunchaddict. All rights reserved.
//

#import "AddLocDatePickerCell.h"

@implementation AddLocDatePickerCell

@synthesize datePicker;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
