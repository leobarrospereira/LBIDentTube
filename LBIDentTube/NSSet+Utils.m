//
//  NSSet+Utils.m
//  LBIDentTube
//
//  Created by Leonardo Barros on 28/02/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import "NSSet+Utils.h"

@implementation NSSet (Utils)


- (BOOL)containsMemberOfClass:(Class)class
{
    for (id element in self) {
        if ([element isMemberOfClass:class]) {
            return YES;
        }
    }
    
    return NO;
}

@end
