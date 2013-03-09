//
//  Diary+Extended.h
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import "Diary.h"
#import "DDMood.h"

@interface Diary (Extended)

+ (Diary *) diaryWithMood:(DDMood*) mood
                  andDate:(NSDate*) date
               andContent:(NSString*) content
   inManagedObjectContext:context;  
@end
