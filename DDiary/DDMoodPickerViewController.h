//
//  DDMoodPickerViewController.h
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMood.h"

@class DDMoodPickerViewController;

@protocol MoodPickerDelegate <NSObject>

-(void) MoodPicker:(DDMoodPickerViewController*)sender seletedMood:(DDMood*) mood;

@end

@interface DDMoodPickerViewController : UIViewController

@property (nonatomic,strong) id<MoodPickerDelegate> delegate;

@end
