

#import "ImageFiltration.h"


@interface ImageFiltration ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) TweetVO *tweetVO;
@end


@implementation ImageFiltration
@synthesize indexPathInTableView = _indexPathInTableView;
@synthesize tweetVO = _tweetVO;
@synthesize imgfilterdelegate = _imgfilterdelegate;
@synthesize numProviderIndicator;

#pragma mark -
#pragma mark - Life cycle

- (id)initWithTweetRecord:(TweetVO *)tweetVO atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageFiltrationDelegate>)theDelegate withProviderIndicator:(NSNumber *)indicator{
    
    if (self = [super init]) {
        self.tweetVO = tweetVO;
        self.indexPathInTableView = indexPath;
        self.imgfilterdelegate = theDelegate;
        self.numProviderIndicator = indicator;
    }
    return self;
}


#pragma mark -
#pragma mark - Main operation


- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        if (!self.tweetVO.hasImage)
            return;
        
        UIImage *rawImage = self.tweetVO.image;
        UIImage *processedImage = [self applySepiaFilterToImage:rawImage];
        
        if (self.isCancelled)
            return;
        
        if (processedImage) {
            self.tweetVO.image = processedImage;
            self.tweetVO.filtered = YES;
            [(NSObject *)self.imgfilterdelegate performSelectorOnMainThread:@selector(imageFiltrationDidFinish:) withObject:self waitUntilDone:NO];
        }
    }
    
}

#pragma mark -
#pragma mark - Filtering image


- (UIImage *)applySepiaFilterToImage:(UIImage *)image {
    
    
    CIImage *inputImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    
    if (self.isCancelled)
        return nil;
    
    UIImage *sepiaImage = nil;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, inputImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    
    if (self.isCancelled)
        return nil;
    
    
    CGImageRef outputImageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    if (self.isCancelled) {
        CGImageRelease(outputImageRef);
        return nil;
    }
    
    sepiaImage = [UIImage imageWithCGImage:outputImageRef];
    CGImageRelease(outputImageRef);
    return sepiaImage;
}

@end


