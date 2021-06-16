//
//  ViewController.m
//  NewsProject
//
//  Created by Daniil Oleynik on 15.06.2021.
//

#import "ViewController.h"
#import "NewsApiOrgProvider.h"
#import "ArticleCell.h"
#import "ImageManager.h"
#import "WebViewController.h"


/// Your api key from https://newsapi.org
#define API_KEY @""

// MARK: - Extensions
@interface ViewController (TableViewDelegateAndDataSource) <UITableViewDelegate, UITableViewDataSource> @end
@interface ViewController ()
@property (nonnull, nonatomic) UITableView *tableView;
@property (nonnull, nonatomic) UIRefreshControl *refreshControl;
@property (nonnull, nonatomic) NSObject<NewsProvider> *provider;
@property (nonnull, nonatomic) NSArray<Article*> *articles;
@property (nonnull, nonatomic) ImageManager *imageManager;
@end

// MARK: Class implementation

@implementation ViewController
@synthesize provider, tableView, articles, refreshControl, imageManager;

// MARK: Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self preload];
}

// MARK: Class Functions

/// Инециализирует свойства и представления
- (void)preload {
    provider = [[NewsApiOrgProvider alloc] initWithApiKey:API_KEY];
    imageManager = [[ImageManager alloc] init];

    [self initViews];
    [self reloadData];
}

- (void)initViews {
    self.title = @"Top Headlines";
    
    // tableView Instance
    tableView = [UITableView new];
    [self.view insertSubview:tableView atIndex:0];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:
     [NSArray arrayWithObjects:
      [tableView.leftAnchor constraintEqualToAnchor:[self.view leftAnchor]],
      [tableView.rightAnchor constraintEqualToAnchor:[self.view rightAnchor]],
      [tableView.topAnchor constraintEqualToAnchor:[self.view topAnchor]],
      [tableView.bottomAnchor constraintEqualToAnchor:[self.view bottomAnchor]],
      nil]
     ];
    refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    tableView.refreshControl = refreshControl;
    [tableView registerNib:[UINib nibWithNibName: ArticleCell.identifier bundle:nil] forCellReuseIdentifier:ArticleCell.identifier];
    
}

/// Запрашивает данные и обновляет табличное представление
- (void)reloadData {
    [refreshControl beginRefreshing];
    [provider requestTopHeadlines:^(NSArray<Article *> * artcles, NSError * error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
            
            dispatch_after(delay, dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
            
            if (error) {
                [self presentAlertWithError:error];
                return;
            }
            
            self.articles = artcles;
            [[self tableView] reloadData];
        });

        for (Article *artcle in artcles) {
            NSLog(@"title: %@", artcle.title);
            NSLog(@"urlimage: %@", artcle.imageUrl);
        }

    }];
}

/// Отображет локализированное сообщение о переданной ошибке
- (void)presentAlertWithError:(NSError *) error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

@end

// MARK: - UITableViewDelegate And UITableViewDataSource

@implementation ViewController (TableViewDelegateAndDataSource)

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:ArticleCell.identifier
                                                        forIndexPath:indexPath];
    
    Article *article = articles[indexPath.row];
    
    [cell updateWithArticleModel:article];
    
    __weak ArticleCell *weakCell = cell;
    
    [imageManager loadImageAtUrl:article.imageUrl completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            
            if (weakCell && article.imageUrl == weakCell.article.imageUrl) {
                [weakCell setImage:image];
            };
        });
    }];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return articles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    WebViewController *vc = [[WebViewController alloc] initWithUrl:cell.article.url];
    
    [self.navigationController pushViewController:vc animated:true];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
