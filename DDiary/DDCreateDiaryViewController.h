//
//  DDCreateDiaryViewController.h
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMood.h"

@protocol CreateDiaryDelegate <NSObject>

- (Boolean) createDiary:(id) sender
               withMood:(DDMood*) mood
               withDate:(NSDate*) date
            withContent:(NSString*) content;

@end

@interface DDCreateDiaryViewController : UIViewController

@property (nonatomic,strong) id<CreateDiaryDelegate> delegate;

@end
