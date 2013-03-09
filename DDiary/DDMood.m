//
//  DDMood.m
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import "DDMood.h"

@implementation DDMood

@synthesize value = _value;

-(DDMood*) initWithValue:(NSNumber*) value;
{
    self.value = value;
    
    return self;
}

-(NSString*) description
{
    switch ([self.value intValue])
    {
        case -2:
            return @":-(";
        case -1:
            return @":(";
        case 0:
            return @":-|";
        case 1:
            return @":)";
        case 2:
            return @":D";
        case 3:
            return @":-D";
        default:
            return @"?";
    }
}

+(NSString*) getMood:(NSNumber*) value
{
    return [[[DDMood alloc] initWithValue:value] description];
}

@end
