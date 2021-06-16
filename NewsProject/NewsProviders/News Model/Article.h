//
//  NewsDataModel.h
//  NewsProject
//
//  Created by Daniil Oleynik on 15.06.2021.
//

#import <Foundation/Foundation.h>

/// Article Data Model
@interface Article : NSObject

@property (readonly, nonnull, nonatomic) NSString *title;
@property (readonly, nonnull, nonatomic) NSString *articleDescription;
@property (readonly, nullable, nonatomic) NSURL *url;
@property (readonly, nullable, nonatomic) NSURL *imageUrl;

- (nonnull instancetype)initWithTitle:(nonnull NSString*)title
                          description:(nonnull NSString*)description
                                  url:(nonnull NSURL*) url
                             imageUrl:(nullable NSURL*)imageUrl;

@end
