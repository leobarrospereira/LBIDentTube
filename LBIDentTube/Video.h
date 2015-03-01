//
//  Video.h
//  LBIDentTube
//
//  Created by Leonardo Barros on 01/03/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * publishedDate;
@property (nonatomic, retain) NSString * relatedVideosUrl;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) NSNumber * viewCount;

@end
