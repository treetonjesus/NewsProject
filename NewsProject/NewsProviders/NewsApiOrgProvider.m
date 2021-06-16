//
//  NewsApiOrgProvider.m
//  NewsProject
//
//  Created by Daniil Oleynik on 15.06.2021.
//

#import "NewsApiOrgProvider.h"
#import "Article.h"

#define NewsApiOrgProviderErrorDomain @"NewsApiOrgProviderErrorDomain"
#define NewsApiOrgProviderErrorApiKeyInvalid 1

// MARK: - Extensions
@interface NewsApiOrgProvider ()
@property (nonnull, nonatomic) NSString *apiKey;
@end

// MARK: - Class implementation
@implementation NewsApiOrgProvider
@synthesize apiKey;

- (nonnull instancetype)initWithApiKey:(NSString*_Nonnull) key
{
    self = [super init];
    if (self) {
        self.apiKey = key;
    }
    return self;
}

// MARK: - NewsProvider implementation
- (void)requestTopHeadlines:( void (^)( NSArray<Article*>* _Nullable , NSError* _Nullable )) completion {
    NSString *urlPath = @"https://newsapi.org/v2/top-headlines";
    NSString *parametrs = [NSString stringWithFormat:@"?country=ru&apiKey=%@",apiKey];
    NSURL *url = [NSURL URLWithString: [urlPath stringByAppendingString:parametrs]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"GET";
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration
                                                          delegate:nil
                                                     delegateQueue:nil];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:
                                  request completionHandler:^(NSData * _Nullable data,
                                                              NSURLResponse * _Nullable response,
                                                              NSError * _Nullable error) {
        // json sessionDataTask errors
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(nil,error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *response_ = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        // json serialization errors
        if (jsonError) {
            completion(nil,jsonError);
            return;
        }
        
        // newsapi.org errors
        if ([[response_ objectForKey:@"status"]  isEqual: @"error"]) {
            
            NSString *message = [response_ objectForKey:@"message"];
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:message forKey:NSLocalizedDescriptionKey];
            
            NSError *error = [NSError errorWithDomain:NewsApiOrgProviderErrorDomain
                                                 code:NewsApiOrgProviderErrorApiKeyInvalid
                                             userInfo:details];
            completion(nil,error);
            return;
        }
        
        
        NSArray *articles = (NSArray *)[response_ objectForKey:@"articles"];
        
        NSMutableArray<Article*> *articleModels = [NSMutableArray<Article*> new];
        
        for (NSDictionary *article in articles) {
            NSString *title = [article valueForKey:@"title"];
            NSString *description = [article valueForKey:@"description"];
            
            NSURL *articleUrl = [NSURL URLWithString:[article valueForKey:@"url"]];
            
            NSString *urlPathToImage = [article valueForKey:@"urlToImage"];
            NSURL *urlToImage = nil;
            
            if (![urlPathToImage  isEqual: @""]) {
                urlToImage = [NSURL URLWithString: urlPathToImage];
            }
            
            Article *model = [[Article alloc] initWithTitle:title
                                                description:description
                                                        url:articleUrl
                                                   imageUrl:urlToImage];
            
            [articleModels addObject:model];
        }
        
        completion(articleModels,jsonError);;
        
    }];
    
    [task resume];
}


@end
