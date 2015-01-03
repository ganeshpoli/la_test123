

#import "ImageDownloader.h"



@interface ImageDownloader ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) TweetVO *tweetVO;
@end


@implementation ImageDownloader
@synthesize imgdownloaderdelegate = _imgdownloaderdelegate;
@synthesize indexPathInTableView = _indexPathInTableView;
@synthesize tweetVO = _tweetVO;
@synthesize numProviderIndicator;

#pragma mark -
#pragma mark - Life Cycle

- (id)initWithTweetRecord:(TweetVO *)tweetVO atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>) theDelegate withProviderIndicator:(NSNumber *)indicator{
    
    if (self = [super init]) {
        
        self.imgdownloaderdelegate = theDelegate;
        self.indexPathInTableView = indexPath;
        self.tweetVO = tweetVO;
        self.numProviderIndicator = indicator;
    }
    return self;
}

#pragma mark -
#pragma mark - Downloading image


- (void)main {
    
    
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.tweetVO.profilePic]];
        
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        if (imageData) {
            UIImage *downloadedImage = [UIImage imageWithData:imageData];
            self.tweetVO.image = downloadedImage;
        }
        else {
            self.tweetVO.failed = YES;
        }
        
        imageData = nil;
        
        if (self.isCancelled)
            return;
        
        
        [(NSObject *)self.imgdownloaderdelegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}

@end


