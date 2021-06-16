//
//  ArticleCell.m
//  NewsProject
//
//  Created by Daniil Oleynik on 16.06.2021.
//

#import "ArticleCell.h"

@interface ArticleCell ()
@property (readwrite, nonatomic) Article* article;
@end

@implementation ArticleCell
@synthesize article;

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (void)setImage:(UIImage * _Nullable)img {
    if (!img) { return; }
    self.pictureImageView.image = img;
}

- (void)updateWithArticleModel:(Article *)article {
    self.pictureImageView.image = [UIImage imageNamed:@"img_empty"];
    self.article = article;
    
    [self.pictureImageView setHidden: article.imageUrl == nil];
    [_lableTopTopConstraint setPriority:article.imageUrl == nil ? 750 : 1000];
    
    [self layoutSubviews];

    self.titleLabel.text = article.title;
    self.descriptionLabel.text = article.articleDescription;
    
}

@end
