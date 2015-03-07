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
#import "UIImageView+WebCache.h"

@interface RelatedVideosViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *relatedVideos;

@end


@implementation RelatedVideosViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSArray *)relatedVideos
{
    if (_relatedVideos) {
        return _relatedVideos;
    }
    
    _relatedVideos = [NSArray new];
    
    return _relatedVideos;
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
    
    
    // Thumbnail
    cell.thumbnailImageView.image = nil;
    
    NSDictionary *mediaGroup = [videoDict objectForKey:@"media$group"];
    NSArray *thumbs = [mediaGroup objectForKey:@"media$thumbnail"];
    NSString *thumbUrl;
    for (NSDictionary *thumb in thumbs) {
        thumbUrl = [thumb objectForKey:@"url"];
        break;
    }
    
    [cell.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:thumbUrl]];
    
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
