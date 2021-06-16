//
//  ImageManager.m
//  NewsProject
//
//  Created by Daniil Oleynik on 16.06.2021.
//

#import "ImageManager.h"

@interface ImageManager ()
@property (strong, nonatomic)NSCache<NSString*,UIImage*> *cache;
@end

@implementation ImageManager
@synthesize cache;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [NSCache<NSString*,UIImage*> new];
    }
    return self;
}

/// Позволяет загрузить изображение по заданному url.
/// Если по такому url изображение содержится в кеше повторная загрузка производится не будет.
- (void)loadImageAtUrl:(NSURL *) url completion: (void(^)( UIImage * _Nullable , NSError* _Nullable)) completion {
    
    UIImage *img = [cache objectForKey: url.relativeString];
    if (img) {
        completion(img, nil);
        return;
    }
    
    // 1. загрузить изображение по ссылке
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:url
                                               completionHandler:^(NSData * _Nullable data,
                                                                   NSURLResponse * _Nullable response,
                                                                   NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // 2. вернуть изображение
        UIImage *img = [UIImage imageWithData:data];
        completion(img, nil);
        
        // 3. кешировать изображение
        if (img) {
            [self.cache setObject:img forKey:url.relativeString];
        }
        
    }];
    
    [dataTask resume];

}

@end
