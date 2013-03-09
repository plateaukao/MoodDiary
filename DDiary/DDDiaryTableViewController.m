    //
//  DDDiaryTableViewController.m
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import "DDDiaryTableViewController.h"
#import "Diary+Extended.h"
#import "DDDiaryViewController.h"

@interface DDDiaryTableViewController ()

@property (nonatomic, strong) UIManagedDocument *dbFile;

@end

@implementation DDDiaryTableViewController

@synthesize dbFile = _dbFile;



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
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
        
        Diary* d = (Diary*) sender;
        [vc setDiary:d];
    }
}

@end
