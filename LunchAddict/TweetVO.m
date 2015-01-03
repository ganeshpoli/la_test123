//
//  TweetVO.m
//  LunchAddict
//
//  Created by SPEROWARE on 14/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "TweetVO.h"

@implementation TweetVO

@synthesize tweetID;
@synthesize message;
@synthesize createddate;
@synthesize fromId;
@synthesize fromName;
@synthesize picture;
@synthesize profilePic;
@synthesize screenName;
@synthesize image = _image;
@synthesize hasImage = _hasImage;
@synthesize filtered = _filtered;
@synthesize failed = _failed;
@synthesize retweeted;


- (BOOL)hasImage {
    return _image != nil;
}


- (BOOL)isFailed {
    return _failed;
}


- (BOOL)isFiltered {
    return _filtered;
}

@end
