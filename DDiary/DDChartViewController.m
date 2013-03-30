//
//  DDChartViewController.m
//  DDiary
//
//  Created by 高 茂原 on 2013/03/22.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import "DDChartViewController.h"
#import "PCPieChart.h"
#import <CoreData/CoreData.h>
#import "Diary.h"
#import "DDMood.h"

@interface DDChartViewController ()
@property (nonatomic, strong) UIManagedDocument *dbFile;
@property (strong, nonatomic) IBOutlet PCPieChart *chartView;
@end

@implementation DDChartViewController

@synthesize chartView = _chartView;
@synthesize dbFile = _dbFile;

#pragma mark - variable setters/getters
- (void) setDbFile:(UIManagedDocument *)dbFile
{
    if(_dbFile != dbFile)
    {
        _dbFile = dbFile;
        [self useDocument];
    }
}

#pragma mark - cycle methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupChartView];

    if(!self.dbFile)
    {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"diaryDB"];
        self.dbFile = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    else
    {
        [self useDocument];
    }
    
}

#pragma mark - init methods
- (void) fetchData
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Diary"];
    //NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"mood" ascending:YES];
    //request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    
    __block NSArray *matches;
    [self.dbFile.managedObjectContext performBlock:^{
        NSError *error = nil;
        matches = [self.dbFile.managedObjectContext executeFetchRequest:request error:&error];
        
        
        if(!matches) return; // not found
        
        NSMutableDictionary *summary = [NSMutableDictionary dictionary];
        
        // summarize
        NSNumber* currentMood;
        for(Diary* d in matches)
        {
            // no key yet
            if(!currentMood || currentMood != d.mood)
            {
                //prevent the value is empty
                if(!d.mood)
                    d.mood = [NSNumber numberWithInt:0];
                
                [summary setValue:@1 forKey:[d.mood description]];
                currentMood = d.mood;
            }
            else    
            {
                [summary setValue:[NSNumber numberWithInt:[[summary valueForKey:[d.mood description]] intValue]+ 1]
                           forKey:[d.mood description]];
            }
            NSLog(@"count of %@: %@", [d.mood description], [summary valueForKey:[d.mood description]]);
        }
     
        // update on UI
        [self updateViewwithDictionary:summary];
                      
    }];
}

- (void) useDocument
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.dbFile.fileURL path]])
    {
        [self.dbFile saveToURL:self.dbFile.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self fetchData];
        }];
    }
    else if (self.dbFile.documentState == UIDocumentStateClosed)
    {
        [self.dbFile openWithCompletionHandler:^(BOOL success){
            [self fetchData];
        }];
        
    }
    else if (self.dbFile.documentState == UIDocumentStateNormal)
    {
        [self fetchData];
    }
}

- (void) setupChartView
{
    self.chartView.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    self.chartView.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    [self.chartView setDiameter:self.chartView.frame.size.width/2];
    [self.chartView setSameColorLabel:YES];
    [self.chartView setShowArrow:YES];
    
}

- (void) updateViewwithDictionary:(NSDictionary*)dictionary
{
    if(!dictionary || dictionary.count == 0) return;

    __block NSMutableArray *components = [NSMutableArray array];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* STOP){
        
        PCPieComponent *component;
        component = [PCPieComponent pieComponentWithTitle:[DDMood getMood:[NSNumber numberWithInt:[key intValue]]]
                                                    value:([obj floatValue]/dictionary.count)*100];
        [component setColour:[self randomColor]];
        [components addObject:component];
    }];
    

    [self.chartView setComponents:components];
    [self.chartView setNeedsDisplay];
}

- (UIColor *)randomColor
{

    CGFloat redValue = arc4random() % 255 / 255.0;
    CGFloat greenValue = arc4random() % 255 / 255.0;
    CGFloat blueValue = arc4random() % 255 / 255.0;
    
    
    return [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0];
}

@end
