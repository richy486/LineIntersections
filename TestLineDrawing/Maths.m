//
//  Maths.m
//  TestLineDrawing
//
//  Created by Richard Adem on 19/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "Maths.h"

@implementation Maths

+ (float) dot:(CGPoint)p1 andPoint:(CGPoint)p2
{
	return (p1.x * p2.x) + (p1.y * p2.y);
}

// http://www.dreamincode.net/forums/topic/277514-normalize-angle-and-radians/
+ (double) wrap:(double) value max:(double) max min:(double) min
{
    value -= min;
    max -= min;
    if (max == 0)
        return min;
    
    value = fmod(value, max);
    value += min;
    while (value < min)
    {
        value += max;
    }
    
    return value;
}

@end
