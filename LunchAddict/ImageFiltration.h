
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "TweetVO.h"


@protocol ImageFiltrationDelegate;

@interface ImageFiltration : NSOperation

@property (nonatomic, weak) id <ImageFiltrationDelegate> imgfilterdelegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) TweetVO *tweetVO;
@property (nonatomic, strong) NSNumber *numProviderIndicator;

- (id)initWithTweetRecord:(TweetVO *)tweetVO atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageFiltrationDelegate>)theDelegate withProviderIndicator:(NSNumber *)indicator;

@end

@protocol ImageFiltrationDelegate <NSObject>
- (void)imageFiltrationDidFinish:(ImageFiltration *)filtration;
@end