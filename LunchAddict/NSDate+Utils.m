//
//  NSDate+Utils.m
//  LunchAddict
//
//  Created by SPEROWARE on 05/09/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

-(NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

-(NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

@end
