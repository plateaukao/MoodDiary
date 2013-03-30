    //
//  DDDiaryTableViewController.m
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import "DDDiaryTableViewController.h"
#import "Diary+Extended.h"

@interface DDDiaryTableViewController ()

@property (nonatomic, strong) UIManagedDocument *dbFile;
@property (nonatomic, strong) DDDiaryViewController* diaryVC;

@end

@implementation DDDiaryTableViewController

@synthesize dbFile = _dbFile;
@synthesize diaryVC = _diaryVC;

#pragma mark DiaryViewerDelegate

-(void) setNextDiary
{
    NSInteger currentIndex = self.tableView.indexPathForSelectedRow.row;
    int diaryCount = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if(currentIndex < diaryCount-1)
    {
        //change selected index
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex+1 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionMiddle];
        
        Diary *d = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        [self.diaryVC setDiary:d];
    }
    
}
-(void) setPreviousDiary
{
    NSInteger currentIndex = self.tableView.indexPathForSelectedRow.row;
    if(0 < currentIndex)
    {
        //change selected index
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex-1 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionMiddle];
        
        Diary *d = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        [self.diaryVC setDiary:d];
    }
    
}

#pragma mark initialization

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Diary"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.dbFile.managedObjectContext
                                                                          sectionNameKeyPath:nil cacheName:nil];
}

- (void) useDocument
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.dbFile.fileURL path]])
    {
        [self.dbFile saveToURL:self.dbFile.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    }
    else if (self.dbFile.documentState == UIDocumentStateClosed)
    {
        [self.dbFile openWithCompletionHandler:^(BOOL success){
            [self setupFetchedResultsController];
        }];

    }
    else if (self.dbFile.documentState == UIDocumentStateNormal)
    {
        [self setupFetchedResultsController];
    }
}

- (void) setDbFile:(UIManagedDocument *)dbFile
{
    if(_dbFile != dbFile)
    {
        _dbFile = dbFile;
        [self useDocument];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.debug = YES;
    
    if(!self.dbFile)
    {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"diaryDB"];
        self.dbFile = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - createDiaryDelegate 

- (Boolean) createDiary:(id) sender
               withMood:(DDMood*) mood
               withDate:(NSDate*) date
            withContent:(NSString*) content
{
    [self.dbFile.managedObjectContext performBlock:^{
        [Diary diaryWithMood:mood andDate:date andContent:content inManagedObjectContext:self.dbFile.managedObjectContext];
    }];
    
    // dismiss dialog
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"diary";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Diary *d = [self.fetchedResultsController objectAtIndexPath:indexPath];

    // Configure the cell...
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"Y/MM/dd  HH:mm"];
    NSString *dateString = [format stringFromDate:d.date];
    
    cell.textLabel.text = d.content; 
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [DDMood getMood:d.mood], dateString];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        Diary *d = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:d];
        
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    Diary *d = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"viewDiary" sender:d];
    
}

#pragma mark segue handling
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"createDiary"])
    {
        DDCreateDiaryViewController* vc = (DDCreateDiaryViewController*) segue.destinationViewController;
        vc.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"viewDiary"])
    {
        DDDiaryViewController *vc = (DDDiaryViewController*) segue.destinationViewController;
        vc.delegate = self;
        self.diaryVC = vc;
        
        Diary* d = (Diary*) sender;
        [vc setDiary:d];
    }
}

@end
