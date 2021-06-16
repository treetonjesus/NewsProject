//
//  NewsApiOrgProvider.h
//  NewsProject
//
//  Created by Daniil Oleynik on 15.06.2021.
//

#import <Foundation/Foundation.h>
#import "NewsProvider.h"

@interface NewsApiOrgProvider : NSObject <NewsProvider>

- (nonnull instancetype)initWithApiKey:(NSString*_Nonnull) key;

@end
