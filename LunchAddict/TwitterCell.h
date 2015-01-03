//
//  TwitterCell.h
//  LunchAddict
//
//  Created by SPEROWARE on 14/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *tweetImgView;
@property(strong, nonatomic) IBOutlet UILabel *lablefromname;
@property(strong, nonatomic) IBOutlet UILabel *lablescreenname;
@property(strong, nonatomic) IBOutlet UILabel *labledate;
@property(strong, nonatomic) IBOutlet UILabel *lableMsg;

@property(strong, nonatomic) IBOutlet UILabel *lablereTweeted;
@property(strong, nonatomic) IBOutlet UILabel *lablereTweetedOwner;
@property(strong, nonatomic) IBOutlet UIImageView *retweetedImgView;

@end
