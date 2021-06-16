//
//  ImageManager.h
//  NewsProject
//
//  Created by Daniil Oleynik on 16.06.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageManager : NSObject

- (void)loadImageAtUrl:(nonnull NSURL *) url completion: (void(^_Nullable)(UIImage * _Nullable , NSError* _Nullable)) completion;

@end
