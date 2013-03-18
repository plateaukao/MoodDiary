//
//  DDDiaryViewController.h
//  DDiary
//
//  Created by 高 茂原 on 2013/03/09.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMood.h"
#import "Diary+Extended.h"

@protocol DiaryViewerDelegate <NSObject>

-(void) setNextDiary;
-(void) setPreviousDiary;

@end

@interface DDDiaryViewController : UIViewController

@property (strong, nonatomic) Diary *diary;
@property (strong, nonatomic) id<DiaryViewerDelegate> delegate;

@end
