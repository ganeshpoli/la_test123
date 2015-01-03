//
//  TwitterPostViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 20/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterPostViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, assign) BOOL showStatusBar;

@property(strong, nonatomic) IBOutlet UITextView *textViewTweet;

@property(strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property(strong, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)btnSubmitClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;

@end
