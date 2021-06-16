//
//  WebViewController.h
//  NewsProject
//
//  Created by Daniil Oleynik on 16.06.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/// Посзволятет отображать web страницу по заданному url
@interface WebViewController : UIViewController

- (instancetype)initWithUrl:(NSURL *)url;

@end
