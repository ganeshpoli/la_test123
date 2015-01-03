//
//  TwitterCell.m
//  LunchAddict
//
//  Created by SPEROWARE on 14/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "TwitterCell.h"

@implementation TwitterCell

@synthesize lableMsg;
@synthesize lablefromname;
@synthesize labledate;
@synthesize lablescreenname;
@synthesize tweetImgView;
@synthesize lablereTweeted;
@synthesize lablereTweetedOwner;
@synthesize retweetedImgView;

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
