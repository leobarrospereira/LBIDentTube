//
//  VideoImporter.h
//  LBIDentTube
//
//  Created by Leonardo Barros on 28/02/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoImporter : NSObject

typedef void(^completionBlockFinished)(BOOL finished);

+ (void)startImporter:(completionBlockFinished)completion;

@end
