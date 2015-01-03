//
//  TextfieldCell.m
//  LunchAddict
//
//  Created by SPEROWARE on 31/12/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "TextfieldCell.h"

@implementation TextfieldCell

@synthesize textField;

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
