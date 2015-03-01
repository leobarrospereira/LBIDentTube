//
//  VideoInfoViewController.m
//  LBIDentTube
//
//  Created by Leonardo Barros on 01/03/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "RelatedVideosViewController.h"

@interface VideoInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;

@end


@implementation VideoInfoViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Info Vídeo";
    
    if (self.video) {
        self.titleLabel.text = self.video.title;
        
        int duration = [self.video.duration intValue];
        int minutes = duration / 60;
        int seconds = duration % 60;
        NSString *durationString = [NSString stringWithFormat:@"Duração - %d:%02d", minutes, seconds];
        
        self.durationLabel.text = durationString;
        
        self.descriptionTextView.text = self.video.content;
        
        self.thumbImageView.image = self.thumbImage;
        
        NSLog(@"%@", self.video.relatedVideosUrl);
        
        if (self.video.relatedVideosUrl) {
            RelatedVideosViewController *controller = [self.childViewControllers objectAtIndex:0];
            controller.relatedVideosUrl = self.video.relatedVideosUrl;
            [controller loadRelatedVideos];
        }
    }
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.descriptionHeightConstraint.constant = self.descriptionTextView.contentSize.height;
}


#pragma mark - Play Video

- (IBAction)playVideo:(id)sender
{
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.video.identifier];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
}


@end
