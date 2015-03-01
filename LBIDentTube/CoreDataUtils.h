//
//  CoreDataUtils.h
//  LBIDentTube
//
//  Created by Leonardo Barros on 28/02/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataUtils : NSObject

+ (NSManagedObjectContext *)mainMoc;
+ (NSManagedObjectContext *)createBackgroundMoc;

+ (NSArray *)fetchEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)moc;

+ (NSFetchedResultsController *)fetchedResultsControllerWithEntity:(NSString *)entityName
                                                      andPredicate:(NSPredicate *)predicate
                                                     andOrderByKey:(NSString *)keyOrderBy
                                                 andAscendingOrder:(BOOL)ascendingOrder
                                                         inContext:(NSManagedObjectContext *)moc;

@end
