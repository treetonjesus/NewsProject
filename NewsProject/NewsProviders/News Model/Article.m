//
//  NewsDataModel.m
//  NewsProject
//
//  Created by Daniil Oleynik on 15.06.2021.
//

#import "Article.h"

@interface Article ()
@property (readwrite, nonnull, nonatomic) NSString *title;
@property (readwrite, nonnull, nonatomic) NSString *articleDescription;
@property (readwrite, nullable, nonatomic) NSURL *url;
@property (readwrite, nullable, nonatomic) NSURL *imageUrl;
@end

@implementation Article

- (nonnull instancetype)initWithTitle:(nonnull NSString*)title
                          description:(nonnull NSString*)description
                                  url:(nonnull NSURL*) url
                             imageUrl:(nullable NSURL*)imageUrl
{
    self = [super init];
    if (self) {
        self.title = title;
        self.articleDescription = description;
        self.url = url;
        self.imageUrl = imageUrl;
    }
    return self;
}

@end
