//
//  VideoImporter.m
//  LBIDentTube
//
//  Created by Leonardo Barros on 28/02/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import "VideoImporter.h"
#import "SVProgressHUD.h"
#import "Video+Create.h"

@implementation VideoImporter


#pragma mark - Start Importer

+ (void)startImporter:(completionBlockFinished)completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = @"http://gdata.youtube.com/feeds/api/users/iDentBrasil/uploads?alt=json";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = responseObject;
        
        NSDictionary *feed = [result objectForKey:@"feed"];
        if (!feed || feed.count == 0) {
            [Utils showMessage:@"Não foi possível recuperar os vídeos. Tente novamente mais tarde."];
            
            if (completion) {
                completion(YES);
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return;
        }
        
        NSArray *entry = [feed objectForKey:@"entry"];
        if (!entry || entry.count == 0) {
            [Utils showMessage:@"Não foi possível recuperar os vídeos. Tente novamente mais tarde."];
            
            if (completion) {
                completion(YES);
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return;
        }
        
        // Save videos in core data.
        NSManagedObjectContext *moc = [CoreDataUtils createBackgroundMoc];
        [moc performBlock:^{
            
            for (NSDictionary *videoDict in entry) {
                [Video createVideoWithDictionary:videoDict andMoc:moc];
            }
            [moc save:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion) {
                    completion(YES);
                }
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [Utils showMessage:@"Ocorreu um erro ao recuperar os vídeos. Tente novamente mais tarde"];
        
        if (completion) {
            completion(YES);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


@end
