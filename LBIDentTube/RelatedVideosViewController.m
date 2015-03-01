//
//  RelatedVideosViewController.m
//  LBIDentTube
//
//  Created by Leonardo Barros on 01/03/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import "RelatedVideosViewController.h"
#import "RelatedVideoCell.h"
#import "XCDYouTubeVideoPlayerViewController.h"

@interface RelatedVideosViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *relatedVideos;
@property (nonatomic, strong) NSCache *thumbnailCache;

@end


@implementation RelatedVideosViewController


#pragma mark - Queue

dispatch_queue_t queueLoadThumb;


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    queueLoadThumb = dispatch_queue_create("RelatedVideosViewController.LoadThumb", NULL);
}

- (NSArray *)relatedVideos
{
    if (_relatedVideos) {
        return _relatedVideos;
    }
    
    _relatedVideos = [NSArray new];
    
    return _relatedVideos;
}


#pragma mark - Cache

- (NSCache *)thumbnailCache
{
    if (_thumbnailCache) {
        return _thumbnailCache;
    }
    
    _thumbnailCache = [[NSCache alloc] init];
    [_thumbnailCache setCountLimit:60];
    
    return _thumbnailCache;
}


#pragma mark - Load Related Videos

- (void)loadRelatedVideos
{
    if (!self.relatedVideosUrl) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?alt=json", self.relatedVideosUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = responseObject;
        
        NSDictionary *feed = [result objectForKey:@"feed"];
        if (!feed || feed.count == 0) {
            return;
        }
        
        NSArray *entry = [feed objectForKey:@"entry"];
        if (!entry || entry.count == 0) {
            return;
        }
        
        self.relatedVideos = entry;
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error related videos - %@", error.localizedDescription);
    }];
    
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.relatedVideos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RelatedVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"relatedVideoCell" forIndexPath:indexPath];
    
    NSDictionary *videoDict = [self.relatedVideos objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [[videoDict objectForKey:@"title"] objectForKey:@"$t"];
    
    cell.thumbnailImageView.image = [self.thumbnailCache objectForKey:indexPath];
    
    if (!cell.thumbnailImageView.image) {
        
        // Load thumbnail async
        dispatch_async(queueLoadThumb, ^{
            
            // Thumbnail
            NSDictionary *mediaGroup = [videoDict objectForKey:@"media$group"];
            NSArray *thumbs = [mediaGroup objectForKey:@"media$thumbnail"];
            NSString *thumbUrl;
            for (NSDictionary *thumb in thumbs) {
                thumbUrl = [thumb objectForKey:@"url"];
                break;
            }
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbUrl]]];
            
            if (image) {
                [self.thumbnailCache setObject:image forKey:indexPath];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    RelatedVideoCell *updateCell = (RelatedVideoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    
                    [UIView transitionWithView:updateCell
                                      duration:0.2f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        
                                        updateCell.thumbnailImageView.image = image;
                                        
                                    } completion:NULL];
                });
            }
            
        });
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *videoDict = [self.relatedVideos objectAtIndex:indexPath.row];
    
    NSString *idVideo = [[videoDict objectForKey:@"id"] objectForKey:@"$t"];
    idVideo = [[idVideo componentsSeparatedByString:@"/"] lastObject];
    
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:idVideo];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
}


@end
