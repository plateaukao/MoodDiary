//
//  DDMood.h
//  DDiary
//
//  Created by 高 茂原 on 2013/02/26.
//  Copyright (c) 2013年 daniel Kao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMood : NSObject

@property (nonatomic,strong) NSNumber* value;

-(DDMood*) initWithValue:(NSNumber*) value;
+(NSString*) getMood:(NSNumber*) value;

@end
