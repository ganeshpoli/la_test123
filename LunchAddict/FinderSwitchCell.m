//
//  FinderSwitchCell.m
//  LunchAddict
//
//  Created by SPEROWARE on 01/01/15.
//  Copyright (c) 2015 lunchaddict. All rights reserved.
//

#import "FinderSwitchCell.h"

@implementation FinderSwitchCell

@synthesize switchbtn;
@synthesize lable;

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
