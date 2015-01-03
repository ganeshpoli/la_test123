//
//  TweetVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 14/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetVO : NSObject

@property(strong, nonatomic) NSString *tweetID;
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSString *picture;
@property(strong, nonatomic) NSString *createddate;
@property(strong, nonatomic) NSString *fromName;
@property(strong, nonatomic) NSString *fromId;
@property(strong, nonatomic) NSString *profilePic;
@property(strong, nonatomic) NSString *screenName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) BOOL hasImage;
@property (nonatomic, getter = isFiltered) BOOL filtered;
@property (nonatomic, getter = isFailed) BOOL failed;
@property (nonatomic, assign) BOOL retweeted;

@end
