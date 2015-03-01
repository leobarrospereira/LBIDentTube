//
//  CoreDataUtils.m
//  LBIDentTube
//
//  Created by Leonardo Barros on 28/02/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import "CoreDataUtils.h"
#import "AppDelegate.h"

@implementation CoreDataUtils


#pragma mark - Main Moc

+ (NSManagedObjectContext *)mainMoc
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return delegate.managedObjectContext;
}


#pragma mark - Create Background Moc

+ (NSManagedObjectContext *)createBackgroundMoc
{
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    backgroundContext.persistentStoreCoordinator = [self mainMoc].persistentStoreCoordinator;
    backgroundContext.undoManager = nil;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:backgroundContext
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification* note) {
                                                      
                                                      NSManagedObjectContext *mainMoc = [self mainMoc];
                                                      
                                                      [mainMoc performBlock:^(){
                                                          [mainMoc mergeChangesFromContextDidSaveNotification:note];
                                                          [mainMoc save:nil];
                                                      }];
                                                  }];
    
    return backgroundContext;
}


#pragma mark - Fetch Entity

+ (NSArray *)fetchEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)moc
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError* error;
    
    return  [moc executeFetchRequest:request error:&error];
}


#pragma mark - Fetch Result Controller

+ (NSFetchedResultsController *)fetchedResultsControllerWithEntity:(NSString *)entityName
                                                      andPredicate:(NSPredicate *)predicate
                                                     andOrderByKey:(NSString *)keyOrderBy
                                                 andAscendingOrder:(BOOL)ascendingOrder
                                                         inContext:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyOrderBy ascending:ascendingOrder];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *fetchedResultsController;
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    
    NSError* error;
    
    [fetchedResultsController performFetch:&error];
    
    return fetchedResultsController;
}

@end
