//
//  Diary+Extended.m
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import "Diary+Extended.h"

@implementation Diary (Extended)

+ (Diary *) diaryWithMood:(DDMood*) mood
                  andDate:(NSDate*) date
               andContent:(NSString*) content
   inManagedObjectContext:context
{
    Diary *diary = nil;
    
    // check if it's already in database
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Diary"];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@", date];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || ([matches count] > 1))
    {
        //handle error
        return nil;
    }
    else if ([matches count] == 0)
    {
        
        diary = [NSEntityDescription insertNewObjectForEntityForName:@"Diary" inManagedObjectContext:context];
        diary.date = date;
        diary.content = content;
        diary.mood = mood.value;
        
        return diary;
        
    }
    else
    {
        diary = [matches lastObject];
        return diary;
    }
    
}

@end
