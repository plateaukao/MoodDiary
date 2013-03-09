//
//  DDDiaryViewController.m
//  DDiary
//
//  Created by 高 茂原 on 2013/03/09.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import "DDDiaryViewController.h"
#import "Diary+Extended.h"

@interface DDDiaryViewController ()
@property (strong, nonatomic) IBOutlet UILabel *dateString;
@property (strong, nonatomic) IBOutlet UILabel *moodString;
@property (strong, nonatomic) IBOutlet UITextView *contentString;

@end

@implementation DDDiaryViewController

@synthesize diary = _diary;

-(void) setDiary:(Diary *)diary
{
    if(_diary != diary)
    {
        _diary = diary;
    }

     
}
 

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"Y/MM/dd  HH:mm"];
    NSString *dateString = [format stringFromDate:self.diary.date];
    self.dateString.text = dateString;
    
    self.contentString.text = self.diary.content;
    self.moodString.text = [DDMood getMood:self.diary.mood];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
