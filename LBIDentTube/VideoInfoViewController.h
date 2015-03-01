//
//  VideoInfoViewController.h
//  LBIDentTube
//
//  Created by Leonardo Barros on 01/03/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"

@interface VideoInfoViewController : UIViewController

@property (nonatomic, strong) Video *video;
@property (nonatomic, strong) UIImage *thumbImage;

@end
