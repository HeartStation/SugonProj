

#import "ImageLoadService.h"
#import "LocalCache.h"

@implementation ImageLoadService

+ (UIImage *)imageFrom:(NSString *)url
{
    UIImage *image = nil;
    
    if (url) {
        url = [IMAGE_BASE_URL stringByAppendingString:url];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
        LocalCache *cache = [LocalCache loadFromRequest:request];
        
        if (cache) {
            image = [UIImage imageWithData:cache.data];
        }
        
    }
    
    return image;
}


+ (void)downLoadImageFrom:(NSString *)url completeHandler:(ImageBlock)block
{
    if (!url) return;

    url = [IMAGE_BASE_URL stringByAppendingString:url];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:60];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示网络链接
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //显示网络链接
                               
                               if (!connectionError) {
                                   
                                   [LocalCache storeCacheForRequest:request withData:data];
                                   
                                   UIImage *image = [UIImage imageWithData:data];
                                   
                                   if (image && block) block(image);
                               }
                           }];
}

@end
