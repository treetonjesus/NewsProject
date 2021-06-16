//
//  NewsProvider.h
//  NewsProject
//
//  Created by Daniil Oleynik on 15.06.2021.

#import "Article.h"

@protocol NewsProvider <NSObject>

- (void)requestTopHeadlines:(void(^)(NSArray<Article*>*, NSError*)) completion;

@end

