//
//  DDMoodPickerViewController.m
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import "DDMoodPickerViewController.h"
#import "DDMood.h"

@interface DDMoodPickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,strong) NSArray* moodArray;
@end

@implementation DDMoodPickerViewController

@synthesize moodArray = _moodArray;
@synthesize delegate = _delegate;

- (NSArray*) moodArray
{
    if(!_moodArray)
    {
        NSMutableArray *moods = [NSMutableArray arrayWithCapacity:10];
        for (int i=-2;i<4;i++)
        {
            DDMood *m = [[DDMood alloc] initWithValue:[NSNumber numberWithInt:i]];
            
            [moods addObject:m];
        }
        
        _moodArray = [[NSArray alloc] initWithArray:moods];
    }
    
    return _moodArray;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
}

#pragma mark pickerview DataSource

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.moodArray count];
}

#pragma mark pickerview delegate

-(NSString*) pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return [[self.moodArray objectAtIndex:row] description];
}

- (void) pickerView:(UIPickerView *)pickerView
       didSelectRow:(NSInteger)row
        inComponent:(NSInteger)component
{
    [self.delegate MoodPicker:self seletedMood:[self.moodArray objectAtIndex:row]];
}

@end
