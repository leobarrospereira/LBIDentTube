//
//  Video+Create.m
//  LBIDentTube
//
//  Created by Leonardo Barros on 28/02/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import "Video+Create.h"

@implementation Video (Create)


#pragma mark - Create Video With Dictionary

+ (void)createVideoWithDictionary:(NSDictionary *)dict andMoc:(NSManagedObjectContext *)moc
{
    NSString *idVideo = [[dict objectForKey:@"id"] objectForKey:@"$t"];
    idVideo = [[idVideo componentsSeparatedByString:@"/"] lastObject];
    
    // Check if video already exists on core data
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", idVideo];
    
    Video *video = [[CoreDataUtils fetchEntity:@"Video" withPredicate:predicate inContext:moc] firstObject];
    
    if (!video) {
        video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:moc];
        video.identifier = idVideo;
    }
    
    video.author = [[[[dict objectForKey:@"author"] firstObject] objectForKey:@"name"] objectForKey:@"$t"];
    video.category = [[[dict objectForKey:@"category"] lastObject] objectForKey:@"label"];
    video.content = [[dict objectForKey:@"content"] objectForKey:@"$t"];
    
    // Video URL and Related Video URL
    NSArray *links = [dict objectForKey:@"link"];
    for (NSDictionary *link in links) {
        if ([[link objectForKey:@"rel"] isEqualToString:@"alternate"]) {
            video.videoUrl = [link objectForKey:@"href"];
            
        } else if ([[link objectForKey:@"rel"] isEqualToString:@"http://gdata.youtube.com/schemas/2007#video.related"]) {
            video.relatedVideosUrl = [link objectForKey:@"href"];
        }
    }
    
    // Thumbnail
    NSDictionary *mediaGroup = [dict objectForKey:@"media$group"];
    NSArray *thumbs = [mediaGroup objectForKey:@"media$thumbnail"];
    for (NSDictionary *thumb in thumbs) {
        video.thumbnailUrl = [thumb objectForKey:@"url"];
        break;
    }
    
    // Duration
    NSString *durationString = [[mediaGroup objectForKey:@"yt$duration"] objectForKey:@"seconds"];
    video.duration = [NSNumber numberWithInt:[durationString intValue]];
    
    // Published Date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    video.publishedDate = [dateFormat dateFromString:[[dict objectForKey:@"published"] objectForKey:@"$t"]];
    
    // Update Date
    video.updatedDate = [dateFormat dateFromString:[[dict objectForKey:@"updated"] objectForKey:@"$t"]];
    
    // View Count
    NSString *viewCountString = [[dict objectForKey:@"yt$statistics"] objectForKey:@"viewCount"];
    video.viewCount = [NSNumber numberWithLongLong:[viewCountString longLongValue]];
    
    // Title
    video.title = [[dict objectForKey:@"title"] objectForKey:@"$t"];
}


@end
