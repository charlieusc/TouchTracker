//
//  BNRLine.m
//  BNRTouchTracker
//
//  Created by YangJialin on 8/11/16.
//  Copyright © 2016 YangJialin. All rights reserved.
//

#import "BNRLine.h"

@implementation BNRLine

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self){
        NSValue *vBegin = [aDecoder decodeObjectForKey:@"begin"];
        NSValue *vEnd = [aDecoder decodeObjectForKey:@"end"];
        UIColor *vColor = [aDecoder decodeObjectForKey:@"lineColor"];
        self.begin = [vBegin CGPointValue];
        self.end = [vEnd CGPointValue];
        self.lineColor = vColor;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSValue *vBegin= [NSValue valueWithCGPoint:self.begin];
    NSValue *vEnd = [NSValue valueWithCGPoint:self.end];
    [aCoder encodeObject:vBegin forKey:@"begin"];
    [aCoder encodeObject:vEnd forKey:@"end"];
    [aCoder encodeObject:self.lineColor forKey:@"lineColor"];
}

@end
