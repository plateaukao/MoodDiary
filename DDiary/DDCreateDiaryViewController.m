//
//  DDCreateDiaryViewController.m
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import "DDCreateDiaryViewController.h"
#import "DDMoodPickerViewController.h"
#import "Diary+Extended.h"
#import "DDMood.h"


@interface DDCreateDiaryViewController () <MoodPickerDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIButton *moodButton;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) DDMood *mood;
@property (strong,nonatomic) NSString* diaryContent;
@property (strong, nonatomic) NSDate *date;

@end

@implementation DDCreateDiaryViewController

@synthesize mood = _mood;
@synthesize date = _date;

-(NSDate*) date
{
    if(!_date)
    {
        NSDate *date = [NSDate date];
        _date = date;
    }
    return _date;
}

#pragma mark others

- (IBAction)createDiary:(id)sender {
    [self.delegate createDiary:self withMood:self.mood withDate:self.date withContent:self.textView.text];
}
- (IBAction)cancelView:(id)sender {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - life cycle

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"Y/MM/dd  HH:mm"];
    NSString *dateString = [format stringFromDate:self.date];
    self.dateLabel.text = dateString;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.delegate = self;
}

#pragma mark MoodPickerDelegate methods

- (void) MoodPicker:(DDMoodPickerViewController *)sender seletedMood:(DDMood *)mood
{
    if(!mood)
        self.mood = [[DDMood alloc] initWithValue:@0];
    else
        self.mood = mood;
    [self.moodButton setTitle:[NSString stringWithFormat:@"Mood %@", mood.description] forState:UIControlStateNormal];
    //[self.moodButton setNeedsLayout];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark textview delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setMood"])
    {
        DDMoodPickerViewController* vc = (DDMoodPickerViewController*) segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
