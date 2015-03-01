//
//  Video+Create.h
//  LBIDentTube
//
//  Created by Leonardo Barros on 28/02/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import "Video.h"

@interface Video (Create)

+ (void)createVideoWithDictionary:(NSDictionary *)dict andMoc:(NSManagedObjectContext *)moc;

@end
