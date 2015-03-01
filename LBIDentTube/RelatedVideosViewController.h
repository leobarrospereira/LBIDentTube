//
//  RelatedVideosViewController.h
//  LBIDentTube
//
//  Created by Leonardo Barros on 01/03/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelatedVideosViewController : UIViewController

@property (nonatomic, strong) NSString *relatedVideosUrl;

- (void)loadRelatedVideos;

@end
