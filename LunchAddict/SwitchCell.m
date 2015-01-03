//
//  SwitchCell.m
//  LunchAddict
//
//  Created by SPEROWARE on 31/12/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

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
