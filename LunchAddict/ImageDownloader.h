

#import <Foundation/Foundation.h>


#import "TweetVO.h"


@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSOperation

@property (nonatomic, assign) id <ImageDownloaderDelegate> imgdownloaderdelegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) TweetVO *tweetVO;
@property (nonatomic, strong) NSNumber *numProviderIndicator;


- (id)initWithTweetRecord:(TweetVO *)tweetVO atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>) theDelegate withProviderIndicator:(NSNumber *)indicator;

@end

@protocol ImageDownloaderDelegate <NSObject>
- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader;
@end