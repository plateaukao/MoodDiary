//
//  DDDiaryTableViewController.h
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "DDCreateDiaryViewController.h"
#import "DDDiaryViewController.h"

@interface DDDiaryTableViewController : CoreDataTableViewController <CreateDiaryDelegate, DiaryViewerDelegate>

@end
