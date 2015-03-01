//
//  Utils.m
//  LBIDentTube
//
//  Created by Leonardo Barros on 28/02/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import "Utils.h"

@implementation Utils


#pragma mark - isConnected

+ (BOOL)isConnected
{
    BOOL isConnected = [AFNetworkReachabilityManager sharedManager].reachable;
    return isConnected;
}


#pragma mark - Show Alert

+ (void)showMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        [alertView show];
    });
}


@end
