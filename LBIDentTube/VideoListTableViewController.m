//
//  VideoListTableViewController.m
//  LBIDentTube
//
//  Created by Leonardo Barros on 28/02/15.
//  Copyright (c) 2015 leonardobarros. All rights reserved.
//

#import "VideoListTableViewController.h"
#import "VideoImporter.h"
#import "VideoCell.h"
#import "Video.h"
#import "NSSet+Utils.h"
#import "SVProgressHUD.h"
#import "VideoInfoViewController.h"
#import "UIImageView+WebCache.h"

@interface VideoListTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation VideoListTableViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add model changes notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDataModelChange:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:[CoreDataUtils mainMoc]];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Force load videos if not has local videos
    if ([CoreDataUtils fetchEntity:@"Video" withPredicate:nil inContext:[CoreDataUtils mainMoc]].count == 0) {
        [SVProgressHUD showWithStatus:@"Carregando vídeos" maskType:SVProgressHUDMaskTypeBlack];
        
        [VideoImporter startImporter:^(BOOL finished) {
            [SVProgressHUD dismiss];
        }];
    }
}


#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [CoreDataUtils fetchedResultsControllerWithEntity:@"Video"
                                                                     andPredicate:nil
                                                                    andOrderByKey:@"publishedDate"
                                                                andAscendingOrder:NO
                                                                        inContext:[CoreDataUtils mainMoc]];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


#pragma mark - Date Formatter

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter) {
        return _dateFormatter;
    }
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"d MMMM, YYYY"];
    
    return _dateFormatter;
}


#pragma mark - Notification Center

- (void)handleDataModelChange:(NSNotification *)note
{
    NSSet *updatedObjects = [[note userInfo] objectForKey:NSUpdatedObjectsKey];
    NSSet *insertedObjects = [[note userInfo] objectForKey:NSInsertedObjectsKey];
    NSSet *deletedObjects = [[note userInfo] objectForKey:NSDeletedObjectsKey];
    
    
    if ([updatedObjects containsMemberOfClass:[Video class]] ||
        [insertedObjects containsMemberOfClass:[Video class]] ||
        [deletedObjects containsMemberOfClass:[Video class]]) {
        
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
    }
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
    
    Video *video = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.titleLabel.text = video.title;
    cell.dateLabel.text = [self.dateFormatter stringFromDate:video.publishedDate];
    
    cell.thumbnailImageView.image = nil;
    [cell.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:video.thumbnailUrl]];
    
    return cell;
}


#pragma mark - Refresh Videos

- (IBAction)refreshVideos:(id)sender
{
    [VideoImporter startImporter:^(BOOL finished) {
        [self.refreshControl endRefreshing];
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"videoInfoSegue"]) {
        NSIndexPath *indexPath = nil;
        
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            indexPath = [self.tableView indexPathForCell:sender];
        }
        
        if (indexPath) {
            Video *video = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            VideoCell *cell = sender;
            UIImage *thumb = cell.thumbnailImageView.image;
            
            VideoInfoViewController *controller = segue.destinationViewController;
            controller.video = video;
            controller.thumbImage = thumb;
        }
    }
}


@end
