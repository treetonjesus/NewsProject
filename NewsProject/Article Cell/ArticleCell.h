//
//  ArticleCell.h
//  NewsProject
//
//  Created by Daniil Oleynik on 16.06.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleCell : UITableViewCell

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (readonly, nonatomic) Article* article;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableTopLazyConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableTopTopConstraint;

- (void)setImage:(UIImage * _Nullable)img;
- (void)updateWithArticleModel:(Article *) article;



//@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
